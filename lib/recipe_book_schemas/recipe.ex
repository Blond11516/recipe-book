defmodule RecipeBookSchemas.RecipeSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  schema "recipes" do
    field :name, :string
    field :photo_url, :string

    timestamps()
  end
end
