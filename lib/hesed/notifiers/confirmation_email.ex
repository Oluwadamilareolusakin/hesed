defmodule Hesed.Notifiers.ConfirmationEmail do
  import Swoosh.Email
  alias HesedWeb.Router.Helpers, as: Routes
  alias HesedWeb.Endpoint

  def generate(user) do
    new()
    |> from({"Hesed", "noreply@hesed.co"})
    |> to({user.first_name, user.email})
    |> subject("Hello, #{user.first_name}")
    |> html_body("<a href=#{confirmation_url(user)}>Confirm</h1>")
  end

  defp confirmation_url(user) do
    "#{Routes.user_registrations_url(Endpoint, :confirm, user.id)}?confirmation_token=#{user.confirmation_token}"
  end
end
