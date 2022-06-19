defmodule Hesed.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :username, :string
    field :phone_number, :string
    field :archived, :boolean
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email, :username, :phone_number, :password])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  def authenticate(user, password) do
    verify_pass(password, user.password_hash)
  end
end
