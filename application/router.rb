# frozen_string_literal: true

class Router
  URLS = {
      home: '/',
      game: '/game',
      check: '/game/check',
      win: '/game/win',
      lose: '/game/lose',
      statistics: '/statistics',
      rules: '/rules',
      hint: '/hint'
  }.freeze

  def initialize(request)
    @request = request

  end



  def response

  end

end
