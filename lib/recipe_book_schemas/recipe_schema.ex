defmodule RecipeBookSchemas.RecipeSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  alias RecipeBookSchemas.EctoHttpURL

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          photo_url: URI.t(),
          ingredients: String.t()
        }

  schema "recipes" do
    field :name, :string
    field :photo_url, EctoHttpURL
    field :ingredients, :string

    timestamps()
  end
end
