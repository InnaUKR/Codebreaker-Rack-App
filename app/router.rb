# frozen_string_literal: true

require_relative 'controllers/codebreaker_controller.rb'
require 'erb'

class Router
  attr_reader :request, :controller

  def self.call(env)
    new(env).route
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @controller = CodebreakerController.new(@request)
  end

  def route
    case @request.path
    when '/' then show('main')
    when '/choose_difficulty' then show('choose_difficulty')
    when '/set_difficulty' then controller.set_difficulty
    when '/play' then controller.play
    when '/make_guess' then controller.make_guess
    when '/hint' then controller.hint
    when '/win_game' then show('win_game')
    when '/lose_game' then show('lose_game')
    when '/save_form' then show('save')
    when '/save' then controller.save
    when '/statistic' then controller.statistic
    else
      not_found
    end
  end

  private

  def show(view)
    path = File.expand_path("../views/#{view}.html", __FILE__)
    Rack::Response.new(File.read(path))
  end

  def not_found(msg = 'Not Found')
    Rack::Response.new([msg], 404)
  end
end
