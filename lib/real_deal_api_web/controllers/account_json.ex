defmodule RealDealApiWeb.AccountJSON do
  alias RealDealApi.Accounts.Account
  alias RealDealApiWeb.UserJSON

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(account <- accounts, do: data(account))}
  end

  @doc """
  Renders a single account.
  """

  #--------------------------------------------ACCOUNT DATA JSON---------------------------------------#
  def show(%{account: account}) do
    %{data: data(account)}
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      email: account.email,
      hash_password: account.hash_password
    }
  end

#-----------------------------------------FULL ACCOUNT JSON-----------------------------------------#
  def full_account(%{account: account}) do
    %{
      id: account.id,
      email: account.email,
      user: UserJSON.data(account.user)
    }
  end

#-------------------------------------------ACCOUNT TOKEN JSON-----------------------------------------#
  def account_token(%{account: account, token: token}) do
     %{
       id: account.id,
       email: account.email,
       token: token
     }
  end
end
