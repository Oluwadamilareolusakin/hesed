defmodule Hesed.Utils.UserIdentifierType do
  def check(identifier) when is_binary(identifier) do
    case String.contains?(identifier, "@") do
      true -> {:email}
      _ -> {:username}
    end
  end
end
