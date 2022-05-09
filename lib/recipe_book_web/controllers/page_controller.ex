defmodule RecipeBookWeb.PageController do
  use Phoenix.Controller,
    namespace: RecipeBookWeb

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
