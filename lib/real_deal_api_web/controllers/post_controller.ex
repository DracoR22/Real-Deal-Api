defmodule RealDealApiWeb.PostController do
  use RealDealApiWeb, :controller

  alias RealDealApi.Posts
  alias RealDealApi.Posts.Post

  action_fallback RealDealApiWeb.FallbackController

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

#----------------------------------------------CREATE POST-------------------------------------------#
  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Posts.create_post(post_params) do
      conn
      |> put_status(:created)
      |> render(:show, post: post)
    end
  end

#--------------------------------------------GET ALL POSTS-------------------------------------------#
  def show_all(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, :show, post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    with {:ok, %Post{} = post} <- Posts.update_post(post, post_params) do
      render(conn, :show, post: post)
    end
  end

  def delete(conn, %{"id" => id}) do

    post = Posts.get_post!(id)

    with {:ok, %Post{}} <- Posts.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
