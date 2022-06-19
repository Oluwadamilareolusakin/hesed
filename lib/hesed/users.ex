defmodule Hesed.Users do
  alias Hesed.Repo
  alias Hesed.Users.User
  import Ecto.Query
  alias Ecto.Changeset
  alias Hesed.Utils.UserIdentifierType

  def list_users(user_status) do
    case user_status do
      "Archived" -> archived_users
      "Active" -> active_users
      _ -> all_users
    end
  end

  def authenticate_user(params) do
    identifier = params["user_identifier"]

    user =
      case UserIdentifierType.check(identifier) do
        {:email} -> Repo.get_by(User, email: identifier)
        {:username} -> Repo.get_by(User, username: identifier)
        _ -> nil
      end

    with user,
         true <- user |> User.authenticate(params["password"]) do
      {:ok, user}
    else
      _ -> {:error, "Username or Password incorrect"}
    end
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def delete_user(id) do
    Repo.get(User, id)
    |> Repo.delete()
  end

  def archive_user(id) do
    Repo.get(User, id)
    |> Changeset.change(archived: true)
    |> Repo.update()
  end

  defp show_archived(user_status) do
    user_status == "Archived"
  end

  defp all_users do
    User
    |> order_by(desc: :id)
    |> Repo.all()
  end

  defp active_users do
    User
    |> where(archived: ^false)
    |> order_by(desc: :id)
    |> Repo.all()
  end

  defp archived_users do
    User
    |> where(archived: ^true)
    |> order_by(desc: :id)
    |> Repo.all()
  end
end
