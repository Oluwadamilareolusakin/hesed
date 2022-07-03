defmodule Hesed.Users do
  alias Hesed.{Repo, Mailer, Users.User, Utils.UserIdentifierType}
  import Ecto.Query
  alias Ecto.Changeset

  def list_users(user_status) do
    case user_status do
      "Archived" -> archived_users
      "Active" -> active_users
      _ -> all_users
    end
  end

  def authenticate_user(%{"user_identifier" => user_identifier, "password" => password} = params)
      when user_identifier == "" or is_nil(password) == "",
      do: {:error, "Please fill in your email/username and password"}

  def authenticate_user(%{"user_identifier" => user_identifier, "password" => password}) do
    user =
      case UserIdentifierType.check(user_identifier) do
        {:email} -> Repo.get_by(User, email: user_identifier)
        {:username} -> Repo.get_by(User, username: user_identifier)
        _ -> nil
      end

    with user,
         true <- user |> User.authenticate(password) do
      {:ok, user}
    else
      _ -> {:error, "Username or Password incorrect"}
    end
  end

  def send_confirmation_email(id) do
    user = Repo.get_by(User, id: id)

    with %User{} <- user,
         {:ok, email} <- Mailer.send_user_confirmation_email(user),
         true <- is_binary(email) do
      {:ok, email}
    else
      _ -> {:error, "Problem sending confirmation to your user"}
    end
  end

  def confirm_user(id, token) do
    with user = %User{} <- Repo.get_by(User, id: id),
         {:ok, user} <- User.build_confirmed_user(user, token),
         {:ok, user} = result <- Repo.update(user) do
      result
      |> IO.inspect()
    else
      {:error, changeset} -> {:error, changeset}
      nil -> {:not_found, "Problem confirming your account, please contact support"}
    end
  end

  def create_user(params) do
    with {:ok, user} <-
           build_user(params)
           |> Repo.insert() do
      {:ok, user}
    else
      {:error, changeset} -> {:error, changeset}
    end
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

  defp build_user(params) do
    %User{}
    |> User.registration_changeset(params)
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
