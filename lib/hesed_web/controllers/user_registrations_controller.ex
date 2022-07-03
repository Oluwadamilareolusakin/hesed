defmodule HesedWeb.UserRegistrationsController do
  use HesedWeb, :controller
  alias Hesed.Users.User
  alias Hesed.Users
  import Hesed.Utils.ErrorBuilder

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        redirect(conn, to: "/users/#{user.id}/confirmation")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, errors: changeset.errors)
    end
  end

  defp go_to_index(conn) do
    redirect(conn, to: "/users")
  end

  def send_confirmation(conn, %{"id" => id}) do
    case Users.send_confirmation_email(id) do
      {:ok, email} -> render(conn, "confirmation.html", email: email)
      {:error, error} -> render(conn, "generic_error.html", error: error)
    end
  end

  def confirm(conn, %{"id" => id, "confirmation_token" => token}) do
    with {:ok, user} <- Users.confirm_user(id, token) do
      conn
      |> put_flash(:info, "Your user has successfully been confirmed. Please login")
      |> redirect(to: "/login")
    else
      {:error, changeset} ->
        error =
          changeset
          |> build_errors_from_changeset()
          |> List.to_string()

        conn
        |> put_flash(:error, error)
        |> redirect(to: "/login")

      {:not_found, error} ->
        conn |> put_flash(:error, error) |> redirect(to: "/login")
    end
  end
end
