defmodule RecipeBookSchemas.RecipeSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  alias RecipeBookSchemas.EctoHttpURL

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          photo_url: URI.t()
        }

  schema "recipes" do
    field :name, :string
    field :photo_url, EctoHttpURL

    timestamps()
  end
end
