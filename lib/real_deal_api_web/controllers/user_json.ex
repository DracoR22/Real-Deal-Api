defmodule RealDealApiWeb.UserJSON do
  alias RealDealApi.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """

   #--------------------------------------------USER DATA JSON---------------------------------------#
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      gender: user.gender,
      biography: user.biography
    }
  end
end
