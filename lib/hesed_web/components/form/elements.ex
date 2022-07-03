defmodule HesedWeb.Components.Form.Elements do
  use Phoenix.Component
  import HesedWeb.ErrorHelpers
  use Phoenix.HTML

  def input(assigns) do
    case @handle_errors do
      false ->
        ~H"""
          <%= error_tag @form, @field %>
          <%= text_input @form, @field, placeholder: @placeholder %>
        """

      _ ->
        ~H"""
          <%= error_tag @form, @field %>
          <%= text_input @form, @field, placeholder: @placeholder, class: class_names_with_errors(@form, @field) %>
        """
    end
  end
end
