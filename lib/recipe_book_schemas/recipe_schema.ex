defmodule RecipeBookSchemas.RecipeSchema do
  @moduledoc false

  use RecipeBookSchemas.Schema

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          photo_url: String.t()
        }

  @enforce_keys [:name, :photo_url]

  schema "recipes" do
    field :name, :string
    field :photo_url, :string

    timestamps()
  end
end
