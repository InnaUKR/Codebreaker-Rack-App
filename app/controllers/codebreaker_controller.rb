# frozen_string_literal: true

require 'codebreaker'
require_relative './base_controller.rb'

class CodebreakerController < BaseController
  PATH = File.expand_path('../../../tmp/statistic.yml', __FILE__)
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

  def code_handling(guess_code)
    game.attempts_numb -= 1
    @request.session[:guesses] << guess_code
    pluses_numb, minuses_numb = game.mark(guess_code)
    @request.session[:answer] << [pluses_numb, minuses_numb]
    return redirect_to('/win_game') if game.win?(pluses_numb)
    return redirect_to('/lose_game') if game.attempts_numb.zero?
  end

  def hint
    @request.session[:hints] << game.take_hint! if game.hints_numb.positive?
    redirect_to('/play')
  end

  def save
    data = load_statistic
    id = (data.count + 1).to_s.to_sym
    current_game = {}
    current_game[:user_name] = request.params['user_name']
    pluses_number = request.session[:answer].last[0]
    current_game[:win] = game.win?(pluses_number)
    current_game[:difficulty] = request.session[:difficulty]
    current_game[:attempts_number] = game.attempts_numb
    current_game[:hints_number] = game.hints_numb
    data[id] = current_game
    File.write(PATH, data.to_yaml)
    redirect_to('/statistic')
  end

  def statistic
    @statistic = load_statistic
    show('statistic')
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

  def load_statistic
    yaml_string = File.read(PATH)
    YAML.safe_load(yaml_string, [Symbol])
  end
end
