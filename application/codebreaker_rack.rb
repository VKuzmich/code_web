# frozen_string_literal: true

class Codebreaker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)

    @router = Router.new(@request)
  end

  def response

  end
end