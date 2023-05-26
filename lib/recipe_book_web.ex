defmodule RecipeBookWeb do
  use Boundary, deps: [RecipeBook, Phoenix, Ecto.Changeset, Ecto.Type], exports: [Endpoint]

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)
end
