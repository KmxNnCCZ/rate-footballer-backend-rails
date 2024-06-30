class CommentsController < ApplicationController

  def create
    comment = current_user.comments.create(
      rate_id: params[:rate_id],
      body: params[:comment_body]
    )
    render json: comment, status: 201
  end


  def update
    comment = Comment.find(params[:id])
    if comment.update(body: params[:comment_body])
      head :no_content # 204 No Content
    else
      head :unprocessable_entity # 422 Unprocessable Entity
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      head :no_content # 204 No Content
    else
      head :unprocessable_entity # 422 Unprocessable Entity
    end
  end
end