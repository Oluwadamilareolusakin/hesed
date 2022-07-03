defmodule Hesed.Utils.ErrorBuilder do
  def build_errors_from_changeset(changeset) do
    for error <- Keyword.values(changeset.errors) do
      {msg, opts} = error

      msg
    end
  end
end
