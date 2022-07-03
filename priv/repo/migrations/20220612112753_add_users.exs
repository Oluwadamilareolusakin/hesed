defmodule Hesed.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:username, :string)
      add(:phone_number, :string)
      add(:password_hash, :string)
      add(:archived, :boolean, default: false)
      add(:confirmation_token, :string)

      timestamps()
    end
  end
end
