# frozen_string_literal: true

class BaseController
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def show(view)
    Rack::Response.new(render("#{view}.html.erb"))
  end

  def redirect_to(uri)
    Rack::Response.new([], 302, 'Location' => uri)
  end

  private

  def render(template)
    path = File.expand_path("../../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
