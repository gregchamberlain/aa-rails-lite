require 'erb'

class ShowExceptions

  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    res = Rack::Response.new
    res['Content-type'] = "text/html"
    status, type, body = nil, {'Content-type' => "text/html"}, []
    begin
      app.call(env)
    rescue => e
      body << e.class.to_s
      status = "500"
    end
    [status, type, body]
  end

  private

  def render_exception(e)
  end

end
