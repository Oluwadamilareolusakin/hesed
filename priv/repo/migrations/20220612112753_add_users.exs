defmodule Hesed.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:username, :string)
      add(:phone_number, :string)
      add(:password_hash, :string)
      add(:archived, :boolean, default: false)

      timestamps()
    end
  end
end
