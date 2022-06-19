defmodule HesedWeb.UserRegistrationsController do
  use HesedWeb, :controller
  alias Hesed.Users.User
  alias Hesed.Users

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    Users.create_user(user_params)

    go_to_index(conn)
  end

  defp go_to_index(conn) do
    redirect(conn, to: "/users")
  end
end
