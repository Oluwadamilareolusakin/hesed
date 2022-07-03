defmodule Hesed.Mailer do
  use Swoosh.Mailer, otp_app: :hesed, api_key: Application.fetch_env!(:hesed, :mailgun_api_key)
  require Logger

  alias Hesed.Notifiers.ConfirmationEmail

  def send_user_confirmation_email(user) do
    Logger.info("Sending confirmation email for #{user.email}")

    with email = %Swoosh.Email{} <- ConfirmationEmail.generate(user),
         {:ok, %{}} <- Hesed.Mailer.deliver(email) do
      Logger.info("Sent confirmation email for #{user.email}")
      {:ok, user.email}
    else
      _ -> nil
    end
  end
end
