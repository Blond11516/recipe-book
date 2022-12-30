defmodule RecipeBookSchemas.RecipeIndexSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  @type t :: %__MODULE__{
          name: String.t(),
          ingredients: String.t()
        }

  @primary_key {:rowid, :id, autogenerate: true}

  schema "recipes_fts5" do
    field :name, :string, source: :recipes_name_fts5
    field :ingredients, :string, source: :recipes_ingredients_fts5
  end
end
