defmodule RecipeBook.Recipes do
  alias RecipeBook.Repo
  alias RecipeBookSchemas.RecipeSchema

  @spec all :: [RecipeBookSchemas.RecipeSchema]
  def all, do: Repo.all(RecipeSchema)
end
