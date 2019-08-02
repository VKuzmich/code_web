# frozen_string_literal: true

class CodebreakerRack
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)

    @router = Router.new(@request, __________.new(@request))
  end

  def response
    @router.route!
  end
end