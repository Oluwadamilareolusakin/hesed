defmodule HesedWeb.Admin.UsersController do
  use HesedWeb, :controller
  alias Hesed.Users

  def index(conn, params) do
    users = Map.get(params, "user_status", nil) |> Users.list_users()

    render(conn, "index.html", users: users)
  end

  def archive(conn, %{"id" => id}) do
    Users.archive_user(id)

    go_to_index(conn)
  end

  def delete(conn, %{"id" => id}) do
    Users.delete_user(id)

    go_to_index(conn)
  end

  defp go_to_index(conn) do
    redirect(conn, to: "/admin/users")
  end
end
