defmodule RecipeBook.Recipes do
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
end
