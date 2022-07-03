defmodule Hesed.Plug.Authenticate do
  import Plug.Conn
  alias HesedWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        login_route = Routes.sessions_path(conn, :new)

        conn
        |> Controller.redirect(to: login_route)
        |> halt()

      _ ->
        conn
    end
  end
end
