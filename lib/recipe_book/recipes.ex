defmodule RecipeBook.Recipes do
  alias Ecto.Changeset
  alias RecipeBook.Repo
  alias RecipeBookSchemas.RecipeSchema

  import Ecto.Query
  import RecipeBook.QueryHelpers

  @spec all :: [RecipeSchema.t()]
  def all, do: Repo.all(RecipeSchema)

  @spec get_random(integer()) :: [RecipeSchema.t()]
  def get_random(count) do
    Repo.all(from r in RecipeSchema, order_by: random(), limit: ^count)
  end

  @spec add(String.t(), URI.t(), String.t()) :: {:ok, RecipeSchema.t()} | {:error, Changeset.t()}
  def add(name, photo_url, ingredients) do
    %RecipeSchema{}
    |> Changeset.change(%{name: name, photo_url: photo_url, ingredients: ingredients})
    |> Repo.insert()
  end

  @spec update(String.t(), String.t(), URI.t(), String.t()) ::
          {:ok, RecipeSchema.t()} | {:error, Changeset.t()}
  def update(id, name, photo_url, ingredients) do
    %RecipeSchema{id: id}
    |> Changeset.change(%{name: name, photo_url: photo_url, ingredients: ingredients})
    |> Repo.update()
  end
end
