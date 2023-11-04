defmodule RealDealApi.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealDealApi.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> RealDealApi.Comments.create_comment()

    comment
  end
end
