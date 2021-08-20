require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'pry'

class ControllerBase
  attr_reader :req, :res, :params
  @@protect_from_forgery = false

  # Setup the controller
  def initialize(req, res, route_params={})
    @req, @res = req, res
    @params = req.params.merge(route_params)
  end

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def form_authenticity_token
    @token ||= SecureRandom.urlsafe_base64
    res.set_cookie("authenticity_token", path: "/", value: @token)
    @token
  end

  def already_built_response?
    @already_built_response ||= false
  end

  # Redirect
  def redirect_to(url)
    if already_built_response?
      raise "double render"
    else
      res.status = 302
      res['Location'] = url
      store_flash_and_session(res)
      @already_built_response = true
    end
  end

  # Render content (other than html.erb template), handle double render
  def render_content(content, content_type)
    if already_built_response?
      raise "double render"
    else
      res['Content-Type'] =  content_type
      res.write(content)
      store_flash_and_session(res)
      @already_built_response = true
    end
  end

  # Render erb template
  def render(template_name)
    if already_built_response?
      raise "double render"
    else
      filepath = File.join(
                  File.dirname(__FILE__).delete_suffix("/lib"),
                  "app/views", 
                  self.class.to_s.underscore, 
                  (template_name.to_s + ".html.erb")
                )
      f = File.new(filepath, "r")
      template = f.read
      f.close

      res['Content-Type'] = "text/html"
      res.write(ERB.new(template).result(binding))
      store_flash_and_session(res)
      @already_built_response = true
    end
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  # Calls (:index, :show, :create...)
  def invoke_action(name)
    if req.request_method != "GET" && @@protect_from_forgery
      self.check_authenticity_token
    end
    self.send(name)
  end

  private

  def check_authenticity_token
    cookie_token = req.cookies['authenticity_token']
    param_token = self.params['authenticity_token']
    if cookie_token != param_token
      raise "Invalid authenticity token"
    elsif !cookie_token || !param_token
      raise "Invalid authenticity token"
    end
  end

  def store_flash_and_session(res)
    flash.store_flash(res)
    session.store_session(res)
  end
end

