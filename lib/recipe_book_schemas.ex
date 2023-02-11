defmodule RecipeBookSchemas do
  use Boundary,
    deps: [RecipeBook, Ecto.Schema, Ecto.Query, Ecto.Type],
    check: [in: false, out: true]
end
