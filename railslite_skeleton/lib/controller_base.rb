require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params


  @@protected = false

  def self.protect_from_forgery
    @@protected = true
  end


  # Setup the controller
  def initialize(req, res, params = {})
    @params = params
    @req = req
    @res = res
    @flash = Flash.new(req)
    @token = SecureRandom.urlsafe_base64
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  def flash
    @flash
  end

  # Set the response status code and header
  def redirect_to(url)
    raise Error if @already_built_response
    @res['location'] = url
    @res.status = 302
    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise Error if @already_built_response
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
    flash.store_flash(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    name = self.class.to_s.underscore
    index = name.index("_controller")
    path = ROOT + "app/views/#{name[0...index]}/#{template_name}.html.erb"
    data = File.read(path)
    erb = ERB.new(data)
    content = erb.result(binding)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    if @@protected && @req.request_method == "POST"
      check_authenticity_token
    end
    send(name)
    render(name) unless @already_built_response
  end

  def form_authenticity_token
    @res.set_cookie("authenticity_token", {path: "/", value: @token})
    @token
  end

  def check_authenticity_token
    unless params["authenticity_token"] && @req.cookies["authenticity_token"] && params["authenticity_token"] == @req.cookies["authenticity_token"]
      raise "Invalid authenticity token"
    end
  end
end
