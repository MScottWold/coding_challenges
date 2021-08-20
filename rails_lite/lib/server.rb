require 'rack'
require_relative 'router'
require_relative 'controller_base'
require_relative 'static'
require_relative 'sql_object'
require_relative 'show_exceptions'

Dir['./app/controllers/*.rb'].each do |file|
  require file
end

Dir['./app/models/*.rb'].each do |file|
  require file
end

router = Router.new
router.draw do
  get Regexp.new("^/comments$"), CommentsController, :index
  get Regexp.new("^/comments/new$"), CommentsController, :new
  post Regexp.new("^/comments$"), CommentsController, :create

  get Regexp.new("^/posts$"), PostsController, :index
  get Regexp.new("^/posts/new$"), PostsController, :new
  get Regexp.new("^/posts/(?<post_id>\\d+)$"), PostsController, :show
  post Regexp.new("^/posts$"), PostsController, :create

  get Regexp.new("^/authors$"), AuthorsController, :index
  get Regexp.new("^/authors/new$"), AuthorsController, :new
  get Regexp.new("^/authors/(?<author_id>\\d+)$"), AuthorsController, :show
  post Regexp.new("^/authors$"), AuthorsController, :create
end

router_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run router_app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)