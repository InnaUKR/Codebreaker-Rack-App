require 'codebreaker'

class Controller

  def initialize(request)
    @request = request
  end

  def start
    game = Codebreaker::Game.new
    [200, { "Content-Type" => "text/plain" }, [("#{game.choose_difficulty(:easy)} #{game.hints_numb} Hello from start")]]
  end
end
