# frozen_string_literal: true
require_relative 'game_process'

class GameProcess
  attr_reader :game, :round_result

  include CodebreakerVk::Database
  include GameHelper

  MISSED = 'x'
  MARKS = {
    success: CodebreakerVk::Game::GOT_IT,
    primary: CodebreakerVk::Game::NOT_YET,
    missed: MISSED
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

    @request.session[:game] = CodebreakerVk::Game.new(difficulty)
    redirect_to(CodebreakerRack::URLS[:game])
  end

  def show_hint
    @game.hint
    redirect_to(CodebreakerRack::URLS[:game])
  end

  def start_round
    validate_guess
    return win if @game.win?(@guess.check(number))
    return lose if @game.attempts.zero

    @request.session[:result] = @game.start_round(@guess.check(number)) if validate_guess
    redirect_to(CodebreakerRack::URLS[:game])
  end

  private

  def update_round_result_data
    @round_result = @request.session[:result]
    fill_missed_in_result if @round_result.size < CodebreakerVk::Game::SECRET_CODE_LENGTH
  end

  def register_name
    CodebreakerVk::Game.new(name: @request.params['player_name'], difficulty: @request.params['difficulty'])
  end

  def register_difficulty
    CodebreakerVk::DIFFICULTY_LEVEL.find(@request.params['difficulty'])
  end

  def registration_data_valid?(difficulty, user)
    user.valid? && difficulty
  end

  def validate_guess
    @guess = CodebreakerVk::Validation.new(@request.params['guess'])
    @guess.check(number) if @guess.valid?
  end

  def fill_missed_in_result
    @round_result += Array.new(CodebreakerVk::Game::SECRET_CODE_LENGTH - @round_result.size) { MARKS[:danger] }
  end

  def win
    save(@game.win?(true))
    @request.session[:game_over] = true
    redirect_to(CodebreakerRack::URLS[:win])
  end

  def lose
    @game.attempts.zero
    @request.session[:game_over] = true
    redirect_to(CodebreakerRack::URLS[:lose])
  end
end
