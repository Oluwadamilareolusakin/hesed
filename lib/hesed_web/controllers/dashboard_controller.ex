defmodule HesedWeb.DashboardController do
  use HesedWeb, :controller

  def index(conn, %{"id" => id}) do
    render(conn, 'index.html', id: id)
  end
end
