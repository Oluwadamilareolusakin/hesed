defmodule HesedWeb.Router do
  use HesedWeb, :router

  alias Hesed.Plug.{Authenticate, EnsureAdmin}

  pipeline :authenticate_user do
    plug Authenticate
  end

  pipeline :ensure_admin do
    plug EnsureAdmin
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HesedWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HesedWeb do
    pipe_through :browser

    pipe_through :authenticate_user

    get "/", HomeController, only: [:index]
  end

  scope "/admin", HesedWeb.Admin do
    pipe_through :browser

    pipe_through [:authenticate_user, :ensure_admin]

    resources "/users", UsersController, only: [:index, :delete]
    patch "/users/:id/archive", UsersController, :archive
  end

  scope "/", HesedWeb do
    pipe_through :browser

    get "/sign-up", UserRegistrationsController, :new
    post "/sign-up", UserRegistrationsController, :create
    get "/users/:id/confirmation", UserRegistrationsController, :send_confirmation
    get "/users/:id/confirm", UserRegistrationsController, :confirm

    post "/login", SessionsController, :create
    get "/login", SessionsController, :new
    get "/logout", SessionsController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", HesedWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HesedWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
