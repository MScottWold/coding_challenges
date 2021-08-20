class CommentsController < ControllerBase
  protect_from_forgery

  def create
    @comment = Comment.new(params["comment"])
    if @comment.save
      flash[:notice] = "Saved comment successfully"
      
      redirect_to "/posts/#{@comment.post.id}"
    else
      flash.now[:errors] = @comment.errors
      @post_id = @comment.post_id

      render :new
    end
  end

  def index
    @comments = Comment.all

    render :index
  end

  def new
    @comment = Comment.new
    @post_id = params["post_id"]

    render :new
  end

  def show
    @comment = Comment.find(params[:comment_id])
    
    render :show
  end
end