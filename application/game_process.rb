# frozen_string_literal: true
require_relative 'game_process'

class GameProcess
  attr_reader :game, :round_result

  include CodebreakerVk::Uploader
  include GameHelper

  EMPTY_SPACE_IN_RESULT = 'x'
  GUESS_MARKS = {
    success: CodebreakerVk::Game::GUESS_PLACE,
    primary: CodebreakerVk::Game::GUESS_PRESENCE,
    danger: EMPTY_SPACE_IN_RESULT
  }.freeze

  def initialize(request)
    @request = request
  end

  def update_game_data
    @game = @request.session[:game]
    update_round_result_data if session_contain?(@request, :result)
  end

  def register_new_game
    user = register_name
    difficulty = register_difficulty
    return redirect_to(CodebreakerRack::URLS[:index]) unless registration_data_valid?(difficulty, user)

    @request.session[:game] = CodebreakerVk::Game.new(difficulty, user)
    redirect_to(CodebreakerRack::URLS[:game])
  end

  def show_hint
    @game.hint
    redirect_to(CodebreakerRack::URLS[:game])
  end

  def start_round
    validate_guess
    return win if @game.win?(@guess.as_array_of_numbers)
    return lose if @game.lose?(@guess.as_array_of_numbers)

    @request.session[:result] = @game.start_round(@guess.as_array_of_numbers) if validate_guess
    redirect_to(CodebreakerRack::URLS[:game])
  end

  private

  def update_round_result_data
    @round_result = @request.session[:result]
    fill_empty_space_in_result if @round_result.size < Codebreaker::Game::CODE_SIZE
  end

  def register_name
    CodebreakerVk::GameUser.new(@request.params['player_name'])
  end

  def register_difficulty
    CodebreakerVk::Difficulty.find(@request.params['level'])
  end

  def registration_data_valid?(difficulty, user)
    user.valid? && difficulty
  end

  def validate_guess
    @guess = CodebreakerVk::CheckErrors.new(@request.params['guess'])
    @guess.as_array_of_numbers if @guess.valid?
  end

  def fill_empty_space_in_result
    @round_result += Array.new(CodebreakerVk::Game::CODE_SIZE - @round_result.size) { GUESS_MARKS[:danger] }
  end

  def win
    save_to_db(@game.to_h)
    @request.session[:game_over] = true
    redirect_to(CodebreakerRack::URLS[:win])
  end

  def lose
    @request.session[:game_over] = true
    redirect_to(CodebreakerRack::URLS[:lose])
  end
end
