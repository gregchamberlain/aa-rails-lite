index = __FILE__.index("lib/server.rb")
ROOT = __FILE__[0...index]
require 'rack'
require_relative '../lib/router'
require_relative '../lib/controller_base'
require_relative '../lib/model_base'
Dir[ROOT + "app/controllers/*.rb"].each {|file| require file }
Dir[ROOT + "app/models/*.rb"].each {|file| require file }

router = Router.new

puts
eval(File.read(ROOT + 'config/routes.rb'))

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
