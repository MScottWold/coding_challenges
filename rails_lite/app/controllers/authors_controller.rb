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

  def show
    @author = Author.find(params[:author_id])
    render :show
  end

  def index
    @authors = Author.all
    render :index
  end

  def new
    @author = Author.new
    render :new
  end
end