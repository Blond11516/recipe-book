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

  @spec add(String.t(), String.t()) :: {:ok, RecipeSchema.t()} | {:error, Changeset.t()}
  def add(name, photo_url) do
    add_changeset(name, photo_url)
    |> Repo.insert()
  end

  def add_changeset(name, photo_url) do
    %RecipeSchema{}
    |> Changeset.cast(%{name: name, photo_url: photo_url}, [:name, :photo_url])
    |> Changeset.validate_required([:name, :photo_url])
    |> Changeset.validate_change(:photo_url, &validate_url/2)
  end

  @spec validate_url(atom(), String.t()) :: [String.t()]
  defp validate_url(field, url) do
    case URI.new(url) do
      {:ok, uri} when uri.scheme in ["http", "https"] -> []
      {:ok, _} -> ["Not a web url"]
      {:error, error} -> [error]
    end
    |> Enum.map(fn error -> {field, error} end)
  end
end
