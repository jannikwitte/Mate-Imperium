class PostsController < ApplicationController
  load_and_authorize_resource

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @post.build_nutritional_info
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post, notice: 'Beitrag wurde erfolgreich erstellt.'
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @post.build_nutritional_info unless @post.nutritional_info
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: 'Post erfolgreich aktualisiert.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  def approve
    @post = Post.find(params[:id])
    if current_user.role == 'admin' || current_user.role == 'manager'
      @post.update(approved: true)
      redirect_to unapproved_posts_path, notice: 'Beitrag wurde erfolgreich genehmigt.'
    else
      redirect_to root_path, alert: 'Zugriff verweigert.'
    end
  end

  def unapproved
    if current_user.role == 'admin' || current_user.role == 'manager'
      @posts = Post.unapproved.includes(:user)
    else
      redirect_to root_path, alert: 'Zugriff verweigert.'
    end
  end


  def reject
    @post = Post.find(params[:id])
    if current_user.role == 'admin' || current_user.role == 'manager'
      @post.destroy
      redirect_to unapproved_posts_path

    else
      redirect_to root_path, alert: 'Zugriff verweigert.'
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :rating, :image, :link, :best_price, :caffeine, :basic_knowledge, nutritional_info_attributes: [:calories, :sugar, :protein, :fat, :carbohydrates])
  end
end
