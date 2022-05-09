defmodule RecipeBookWeb.PageController do
  use RecipeBookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
