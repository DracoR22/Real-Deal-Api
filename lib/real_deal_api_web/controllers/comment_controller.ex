defmodule RealDealApiWeb.CommentController do
  use RealDealApiWeb, :controller

  alias RealDealApi.Comments
  alias RealDealApi.Comments.Comment

  action_fallback RealDealApiWeb.FallbackController

#---------------------------------------------ALL COMMENTS--------------------------------------------#
  def index(conn, _params) do
    comment = Comments.list_comment()
    render(conn, :index, comment: comment)
  end

#---------------------------------------------CREATE COMMENT------------------------------------------#
  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Comments.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> render(:show, comment: comment)
    end
  end

#-----------------------------------------------GET COMMENT--------------------------------------------#
  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, :show, comment: comment)
  end

#---------------------------------------------UPDATE COMMENT------------------------------------------#
  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params) do
      render(conn, :show, comment: comment)
    end
  end

#---------------------------------------------DELETE COMMENT------------------------------------------#
  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
