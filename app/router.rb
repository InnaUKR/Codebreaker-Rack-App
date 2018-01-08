class Router
  attr_reader :request, :controller
  def initialize(request)
    @request = request
    @controller = Controller.new(request)
  end

  def route!
    case request.path
    when '/start' then controller.start
    else
      not_found
    end
  end

  private

  def not_found(msg = "Not Found")
    [404, { "Content-Type" => "text/plain" }, [msg]]
  end
end
