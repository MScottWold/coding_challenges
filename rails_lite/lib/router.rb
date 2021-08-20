class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks for pattern match
  def matches?(req)
    self.pattern =~ req.path && self.http_method.to_s.upcase == req.request_method
  end

  # pull out route params and execute action
  def run(req, res)
    route_params = {}
    match_data = @pattern.match(req.path)
    match_data.names.each do |name|
      route_params[name.to_sym] = match_data[name]
    end
    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # Add new methods
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # Return proper route
  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  # call route or return 404
  def run(req, res)
    route = match(req)

    if route
      route.run(req, res)
    else
      res.status = 404
      res.write("404 Missing Route")
    end
  end
end
