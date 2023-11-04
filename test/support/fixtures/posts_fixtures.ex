defmodule RealDealApi.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealDealApi.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> RealDealApi.Posts.create_post()

    post
  end
end
