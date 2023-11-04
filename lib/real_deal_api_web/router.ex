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
    get "/posts/show_all", PostController, :show_all
    get "/comments/show_all", CommentController, :index
    get "/comments/show/:id", CommentController, :show
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
    post "/posts/create", PostController, :create
  end

  #--------------------------------------------PROTECTED ROUTES----------------------------------------#
  scope "/api", RealDealApiWeb do
    pipe_through [:api, :auth]
    get "/accounts/current", AccountController, :current_account
    get "/accounts/sign_out", AccountController, :sign_out
    get "/accounts/refresh_session", AccountController, :refresh_session
    post "/accounts/update", AccountController, :update
    post "/comments/create", CommentController, :create
    put "/users/update", UserController, :update
    put "/comments/update/:id", CommentController, :update
    delete "/accounts/delete", AccountController, :delete
  end
end
