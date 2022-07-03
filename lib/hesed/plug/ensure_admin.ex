defmodule Hesed.Plug.EnsureAdmin do
  import Plug.Conn
  alias Hesed.{Repo, Users.User}
  alias Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :current_user)

    user = Repo.get_by(User, id: user_id)

    case user do
      %User{admin: true} ->
        conn

      _ ->
        conn
        |> Controller.put_flash(:error, "You don't have permission to visit that page")
        |> Controller.redirect(to: "/")
        |> halt()
    end
  end
end
