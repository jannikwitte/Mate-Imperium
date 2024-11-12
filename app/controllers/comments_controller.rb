class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Kommentar erfolgreich erstellt'
    else
      redirect_to @post, alert: 'ERROR Kommentar konnte nicht erstellt werden'
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @post, notice: 'Kommentar erfolgreich bearbeitet.' }
        format.js   # Erlaubt die Antwort mit JS
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: 'Error updating comment.' }
        format.js   # Auch für Fehlerfälle mit JS antworten
      end
    end
  end


  def edit
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'Kommentar gelöscht'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
