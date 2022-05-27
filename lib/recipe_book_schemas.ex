defmodule RecipeBookSchemas do
  use Boundary, deps: [Ecto.Schema, Ecto.Query], check: [in: false, out: true]
end
