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