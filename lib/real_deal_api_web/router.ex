defmodule RealDealApiWeb.Router do
  use RealDealApiWeb, :router
  use Plug.ErrorHandler

#------------------------------------------------HANDLE ERRORS------------------------------------------#
  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

#----------------------------------------------ESTABLISH ROUTES----------------------------------------#
  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

#---------------------------------------ESTABLISH PROTECTED ROUTES-------------------------------------#
  pipeline :auth do
    plug RealDealApiWeb.Auth.Pipeline
    plug RealDealApiWeb.Auth.SetAccount
  end

#---------------------------------------------------ROUTES---------------------------------------------#
  scope "/api", RealDealApiWeb do
    pipe_through :api
    get "/", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  #--------------------------------------------PROTECTED ROUTES----------------------------------------#
  scope "/api", RealDealApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/by_id/:id", AccountController, :show
    get "/accounts/sign_out", AccountController, :sign_out
    get "/accounts/refresh_session", AccountController, :refresh_session
    post "/accounts/update", AccountController, :update
  end
end
