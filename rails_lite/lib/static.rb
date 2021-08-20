# Static content
class Static
  attr_reader :app, :res, :req
  def initialize(app)
    @app = app
  end
  
  def call(env)
    @req = Rack::Request.new(env)
    @res = Rack::Response.new


    pattern = Regexp.new(/^\/public\/(?<folder>\w+\/)?(?<filename>\w+\.(?<ext>\w+))$/)
    if match_data = pattern.match(req.path)

      if File.exist?(".#{req.path}") 
        res["Content_Type"] = "image/#{match_data[:ext]}"
        static_file = File.open(".#{req.path}", "r") do |file| 
          file.read 
        end
        res.write(static_file)
      else
        res.status = 404
        res["Content-Type"] = "text/plain"
        res.write("404 Not Found")
      end
      res.finish
    else
      app.call(env)
    end
  end
end
