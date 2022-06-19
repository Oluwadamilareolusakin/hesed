defmodule HesedWeb.SessionsController do
  use HesedWeb, :controller

  alias Hesed.Users

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    case Users.authenticate_user(params) do
      {:ok, user} ->
        conn
        |> store_user_in_session(user)
        |> put_flash(:success, "Successful login")
        |> redirect(to: "/users")

      {:error, message} ->
        conn
        |> handle_login_failure(message)

      _ ->
        conn
        |> handle_login_failure("Problem login in you in")
    end
  end

  def destroy(conn, _params) do
    # log a user out
  end

  defp handle_login_failure(conn, message) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: "/login")
  end

  defp store_user_in_session(conn, user) do
    conn
    |> put_session(:current_user, user.id)
  end
end
