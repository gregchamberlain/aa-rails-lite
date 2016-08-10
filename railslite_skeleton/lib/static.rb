class Static

  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env["PATH_INFO"]
    res = Rack::Response.new
    if path.start_with?("/public")
      if File.exist?(path[1..-1])
        data = File.read(path[1..-1])
        res.write(data)
      else
        res.status = 404
      end
    end
    res.finish
  end
end
