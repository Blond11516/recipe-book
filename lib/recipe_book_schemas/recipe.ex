defmodule RecipeBookSchemas.RecipeSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  schema "recipes" do
    field :name, :string

    timestamps()
  end
end
