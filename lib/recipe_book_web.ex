defmodule RecipeBookWeb do
  use Boundary, deps: [RecipeBook, Phoenix, Ecto.Changeset], exports: [Endpoint]
end
