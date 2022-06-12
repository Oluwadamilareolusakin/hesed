defmodule Hesed.Repo do
  use Ecto.Repo,
    otp_app: :hesed,
    adapter: Ecto.Adapters.Postgres
end
