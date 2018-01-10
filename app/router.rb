# frozen_string_literal: true

require_relative 'controllers/codebreaker_controller.rb'
require 'erb'
require 'codebreaker'

class Router
  attr_reader :request

  def self.call(env)
    new(env).route
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @controller = CodebreakerController.new(@request)
  end

  def route
    case @request.path
    when '/' then @controller.show('main')
    when '/choose_difficulty' then @controller.show('choose_difficulty')
    when '/set_difficulty' then @controller.set_difficulty
    when '/play' then @controller.play
    when '/make_guess' then @controller.make_guess
    when '/hint' then @controller.hint
    when '/win_game' then @controller.show('win_game')
    when '/lose_game' then @controller.show('lose_game')
    else
      not_found
    end
  end

  private

  def not_found(msg = 'Not Found')
    [404, { 'Content-Type' => 'text/plain' }, [msg]]
  end
end
