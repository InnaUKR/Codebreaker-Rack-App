# frozen_string_literal: true

require_relative './base_controller.rb'
require 'codebreaker'

class CodebreakerController < BaseController
  attr_reader :hints

  def set_difficulty
    start_new_game
    request.session[:difficulty] = request.params['difficulty']
    @difficulty = request.session[:difficulty]
    game.choose_difficulty(@difficulty)
    redirect_to('/play')
  end

  def play
    show_info
    @inputted_guesses = @request.session[:guesses]
    show('play')
  end

  def make_guess
    guess_string = request.params['enter_numbers']
    guess_code = guess_string.split('').map(&:to_i)
    if game.got_guess_code?(guess_code)
      game.attempts_numb -= 1
      @request.session[:guesses] << guess_code
      pluses_numb, minuses_numb = game.mark(guess_code)
      @request.session[:answer] << [pluses_numb, minuses_numb]
      return redirect_to('/win_game') if game.win?(pluses_numb)
      return redirect_to('/lose_game') if game.attempts_numb.zero?
    end
    redirect_to('/play')
  end

  def hint
    @request.session[:hints] << game.take_hint! if game.hints_numb.positive?
    redirect_to('/play')
  end

  private

  def game
    @request.session[:game]
  end

  def start_new_game
    request.session[:game] = Codebreaker::Game.new
    @request.session[:hints] = []
    @request.session[:guesses] = []
    @request.session[:answer] = []
  end

  def show_info
    @attempts_numb = game.attempts_numb
    @hints_numb = game.hints_numb
    @hints = @request.session[:hints]
    @answer = @request.session[:answer]
  end
end
