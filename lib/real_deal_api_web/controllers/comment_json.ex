defmodule RealDealApiWeb.CommentJSON do
  alias RealDealApi.Comments.Comment

  @doc """
  Renders a list of comment.
  """
  def index(%{comment: comment}) do
    %{data: for(comment <- comment, do: data(comment))}
  end

  @doc """
  Renders a single comment.
  """
  def show(%{comment: comment}) do
    %{data: data(comment)}
  end

  def data(%Comment{} = comment) do
    %{
      id: comment.id,
      text: comment.text
    }
  end
end
