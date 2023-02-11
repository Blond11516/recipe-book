defmodule RecipeBook.Recipes do
  alias Ecto.Changeset
  alias RecipeBookSchemas.RecipeSchema

  import Ecto.Query
  import RecipeBook.QueryHelpers

  @spec all(atom()) :: [RecipeSchema.t()]
  def all(repo), do: repo.all(RecipeSchema)

  @spec get_random(atom(), integer()) :: [RecipeSchema.t()]
  def get_random(repo, count) do
    repo.all(from r in RecipeSchema, order_by: random(), limit: ^count)
  end

  @spec get_random(atom(), integer(), String.t()) :: [RecipeSchema.t()]
  def get_random(repo, count, search_term) do
    repo.all(
      from ri in fragment("recipes_fts5(?)", ^search_term),
        order_by: random(),
        limit: ^count,
        join: r in RecipeSchema,
        on: r.rowid == ri.rowid,
        select: r
    )
  end

  @spec add(atom(), String.t(), URI.t(), String.t()) ::
          {:ok, RecipeSchema.t()} | {:error, Changeset.t()}
  def add(repo, name, photo_url, ingredients) do
    %RecipeSchema{}
    |> Changeset.change(%{name: name, photo_url: photo_url, ingredients: ingredients})
    |> repo.insert()
  end

  @spec update(atom(), String.t(), String.t(), URI.t(), String.t()) ::
          {:ok, RecipeSchema.t()} | {:error, Changeset.t()}
  def update(repo, id, name, photo_url, ingredients) do
    %RecipeSchema{id: id}
    |> Changeset.change(%{name: name, photo_url: photo_url, ingredients: ingredients})
    |> repo.update()
  end
end
