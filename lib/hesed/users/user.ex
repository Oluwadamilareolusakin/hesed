defmodule Hesed.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :username, :string
    field :phone_number, :string
    field :archived, :boolean
    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmation_token, :string
    field :confirmed_at, :utc_datetime
    field :admin, :boolean, virtual: true

    timestamps()
  end

  def registration_changeset(user, params \\ %{}) do
    user
    |> cast(params, registration_params)
    |> validate_required(registration_params)
    |> unique_constraint([:email], name: :users_email_index)
    |> unique_constraint([:username], name: :users_username_index)
    |> put_pass_hash()
  end

  def changeset(user, params \\ %{}) do
    cast(user, params, [])
  end

  defp registration_params do
    [:first_name, :last_name, :email, :username, :phone_number, :password]
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, add_hash(password))
    |> change(add_hash(Bcrypt.Base.gen_salt(12, true), hash_key: :confirmation_token))
  end

  defp put_pass_hash(changeset), do: changeset

  def build_confirmed_user(user, token) do
    Logger.info("Starting confirmation for #{user.email}")

    if user.confirmation_token == token do
      case confirm_user_changeset(user) do
        %Ecto.Changeset{valid?: true} = changeset -> {:ok, changeset}
        changeset -> {:error, changeset}
      end
    end
  end

  defp confirm_user_changeset(user) do
    user
    |> validate_not_already_confirmed
    |> change(confirmed_at: time_now_without_milliseconds)
  end

  defp time_now_without_milliseconds do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end

  def validate_not_already_confirmed(%__MODULE__{confirmed_at: confirmed_at} = changeset)
      when not is_nil(confirmed_at) do
    changeset
    |> change(%{})
    |> add_error(:confirmed_at, "Your account has already been confirmed. Please login")
  end

  def validate_not_already_confirmed(changeset), do: changeset

  defp generate_token do
    UUID.uuid4()
  end

  def authenticate(user, password) do
    verify_pass(password, user.password_hash)
  end
end
