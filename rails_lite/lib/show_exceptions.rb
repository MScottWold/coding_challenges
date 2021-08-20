require 'erb'
require 'pry'

class ShowExceptions
  attr_reader :res, :req, :app
  def initialize(app)
    @app = app
  end

  def call(env)
    @req = Rack::Request.new(env)
    @res = Rack::Response.new
    
    app.call(env)
  rescue => exception
    render_exception(exception)
  end

  private

  def render_exception(e)
    @message = e.message
    @trace = e.backtrace
    @type = e.class.to_s
    
  
    error_file_path = e.backtrace[0].split(":")[0]
    error_line = e.backtrace[0].split(":")[1].to_i
    start_line = error_line > 5 ? (error_line - 5) : 0
    
    @code_preview = [error_file_path]
    File.open(error_file_path, "r") do |file|
      start_line.times { file.gets }
      10.times do |n|
        if n == 4
          @code_preview << "=> #{error_line}: " + file.gets
        else
          @code_preview << "   #{error_line - (4 - n)}: " + file.gets
        end
      end
    end

    file = File.open("./lib/templates/rescue.html.erb", "r")
    error_template = file.read
    file.close
    content = ERB.new(error_template).result(binding)

    res.status = "500"
    res['Content-type'] = "text/html"
    res.write(content)
    res.finish
  end
end
