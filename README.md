# Assorted Problem Sets
This repo contains a sample of some coding chellenges I've done. It's purpose 
is to document the type of code I've been writing, not to claim credit for 
originating the idea behind any of these projects. These were coding exercises, 
not original projects.

## Installation
```
$ gem install bundler
$ bundle install
```
# Rails Lite

Rails Light started as a series of smaller exercises designed to recreate and 
better understand some of the main components of Rails (e.g. ActiveRecord, Rack, associations, ORM, MVC architecture, etc.). I decided to combine those 
components into a single project to create a fully working Rails Lite and I also
added some additional features, just for fun. 

## Goal

The main goal with Rails Lite was to recreate a slimmed down version of Ruby on 
Rails to understand how it works, rather than to create a secure, feature-rich 
Rails Lite framework. It is totally functional, however, it can only work with 
SQLite3.

Another goal was to practice meta-progamming patterns. See the 
[SQLObject class](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/sql_object.rb) and 
[Associatable](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/associatable.rb).

## Features
All of these features are designed to mimic the real Ruby on Rails framework, 
including the same file structure. A lot of this should look similar to standard
Rails code.
- ### Functional server-side web application

  It really works!

  ### Get it running

  ````
  $ cd rails_lite
  $ ruby lib/server.rb

  # Then navigate to localhost:3000/posts in your browser
  ````

- ### Custom models  

  ```` Ruby
  # app/models/post.rb

  class Post < SQLObject
    validate_presence_of :title, :body

    has_many :comments,
    foreign_key: :post_id
    
    belongs_to :author
    
    def author_name
      if self.author
        self.author.username
      else
        "anonymous"
      end
    end

    self.finalize!
  end  
  ```` 

   Checkout the code for SQLObject is [here](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/sql_object.rb).

- ### Custom controllers and ERB templates

  ````Ruby
  # app/controllers/posts_controller.rb

  class PostsController < ControllerBase
    protect_from_forgery

    def create
      @post = Post.new(params["post"])
      if @post.save
        flash[:notice] = "Saved post successfully"
        redirect_to "/posts"
      else
        flash.now[:errors] = @post.errors
        render :new
      end
    end

    def show
      @post = Post.find(params[:post_id])
      @comments = @post ? @post.comments : []
      render :show
    end

    def index
      @posts = Post.all
      render :index
    end

    def new
      @post = Post.new
      render :new
    end
  end
  ````
  ````HTML
  <!-- app/views/posts_controller/show.html.erb -->
  <!-- checkout ControllerBase#render in lib/controller_base.rb for ERB implementation -->

  <img src="/public/images/banner.jpg" alt="image of lake">
  <h1>Post</h1>
  <p>from <%= @post.author_name %></p>
  <h2><%= @post.title %></h2>
  <p><%= @post.body %></p>
  <ul>
  <% @comments.each do |comment| %>
    <li><%= "#{comment.body} - #{comment.username}" %></li>
  <% end %>
  </ul>
  <br>
  <a href="/comments/new?post_id=<%= @post.id %>">make comment</a>
  <br>
  <br>
  <a href="/posts">All posts</a>
  <br>
  <a href="/authors">All authors</a>
  ````

    The code for ControllerBase is [here](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/controller_base.rb).

- ### Model associations

  ````Ruby
  class Comment < SQLObject
    has_one_through :original_poster, :post, :author
    
    belongs_to :post,
    foreign_key: :post_id
    
    self.finalize!
  end
  ````
  The code for the associations is [here](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/associatable.rb).

- ### Basic, model-level validations

  ````Ruby
  class Comment < SQLObject
    validate_presence_of :body, :username, :post_id

    self.finalize!
  end
  ````

  The code for the validations implementation is in the SQLObject 
  [validate_presence_of](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/associatable.rb) method.

- ### Session, flash, flash.now, & authenticity token

  ````Ruby
  # /lib/server.rb

  class AuthorsController < ControllerBase
    protect_from_forgery

    def create
      @author = Author.new(params["author"])
      if @author.save
        flash[:notice] = "Saved author successfully"
        redirect_to "/authors"
      else
        flash.now[:errors] = @author.errors
        render :new
      end
    end
  end
  ````

    [Flash](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/flash.rb), [Session](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/session.rb), & [ControllerBase#check_authenticity_token](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/session.rb).

- ### Rack middleware to serve static assets or display exceptions and stack trace

  Serving [static content](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/static.rb), such as images.

  Showing [exceptions](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/show_exception.rb).

- ### Router and custom routes
  [Router Class](https://github.com/MScottWold/coding_challenges/tree/master/rails_lite/lib/router.rb) code.

  ````Ruby
  # /lib/server.rb

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
  ````

# Chess

Simple chess running in the console that uses keyboard controls.

### Get it running

```
# To start the game
$ ruby chess/game.rb
```

### Controls

up, down, left, right: move cursor

enter: select piece, or once piece is selected, move to space

### Features

- Tracks check and checkmate and will not allow you to put yourself in check
- Keyboard controls

# Minesweeper

Minesweeper running in the console

### Get it running

```
# To start the game
$ ruby minesweeper/minesweeper.rb
```

### Features

- Save/load game via .yml file
- flag and track bombs

# Snake

Basic snake game running on a browser

### Get it running

````
# Open index.html in a browser window
````

### Features

- Ugly user interface?

## More to come...