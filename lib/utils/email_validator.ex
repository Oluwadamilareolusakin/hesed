defmodule Hesed.Utils.EmailValidator do
  @tlds [".com", ".net", ".co", ".ie", ".us", ".org", ".com.ng", ".co.uk"]

  def valid_email?(email) when is_binary(email) do
    validate_email(email)
  end

  defp validate_email(email) do
    with true <- validate_email_format(email),
         true <- validate_tld(email) do
      true
    else
      _ -> false
    end
  end

  defp validate_email_format(email) do
    String.match?(email, email_regex)
  end

  defp validate_tld(email) do
    for tld <- @tlds do
      if String.match?(email, ~r/#{tld}$/) do
        throw(:break)
      end
    end
  catch
    :break -> true
  end

  defp email_regex do
    ~R/^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/
  end
end
