defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RealDealApi.{Accounts, Accounts.Account, Users, Users.User}

  import RealDealApiWeb.Auth.AuthorizedPlug

  # DETERMINE WHICH ROUTES ARE GOING TO BE PROTECTED BY MIDDLEWARE
  plug :is_authorized when action in [:update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

#---------------------------------------------CREATE ACCOUNT------------------------------------------#
  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
     {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      authorize_account(conn, account.email, account_params["hash_password"])
    end
  end

#---------------------------------------------SIGN IN METHOD------------------------------------------#
  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    authorize_account(conn, email, hash_password)
  end

  defp authorize_account(conn, email, hash_password) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})
        {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or Password incorrect"
    end
  end

#----------------------------------------------REFRESH TOKEN-------------------------------------------#
def refresh_session(conn, %{}) do
  token = Guardian.Plug.current_token(conn)
  {:ok, account, new_token} = Guardian.authenticate(token)
  conn
  |> Plug.Conn.put_session(:account_id, account.id)
  |> put_status(:ok)
  |> render(:account_token, %{account: account, token: new_token})
end

#-----------------------------------------------LOG OUT METHOD-----------------------------------------#
def sign_out(conn, %{}) do
  account = conn.assigns[:account]
  token = Guardian.Plug.current_token(conn)
  Guardian.revoke(token)
  conn
  |> Plug.Conn.clear_session()
  |> put_status(:ok)
  |> render(:account_token, %{account: account, token: nil})
end

#--------------------------------------------GET ACCOUNT BY ID-----------------------------------------#
  def show(conn, %{"id" => id}) do
  # Get Account By Params In Url
    account = Accounts.get_full_account(id)
    render(conn, :full_account, account: account)
  end

#--------------------------------------------GET CURRENT ACCOUNT---------------------------------------#
def current_account(conn, %{}) do
  conn
  |> put_status(:ok)
  |> render(:full_account, %{account: conn.assigns.account})
end

#-------------------------------------------UPDATE ACCOUNT INFO----------------------------------------#
  def update(conn, %{"current_hash" => current_hash, "account" => account_params}) do
  # Check If Requested Password is Equal To The Account Password, Then Update Account With Our Current Account Id
    case Guardian.validate_password(current_hash, conn.assigns.account.hash_password) do
      true -> {:ok, account} = Accounts.update_account(conn.assigns.account, account_params)
      render(conn, :show, account: account)
      false -> raise ErrorResponse.Unauthorized, message: "Password incorrect."
    end
  end

#---------------------------------------------DELETE ACCOUNT------------------------------------------#
  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
