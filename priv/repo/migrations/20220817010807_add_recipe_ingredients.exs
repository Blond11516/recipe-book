defmodule RecipeBook.Repo.Migrations.AddRecipeIngredients do
  use Ecto.Migration

  def change do
    alter table("recipes") do
      add :ingredients, :string, null: false, default: ""
    end
  end
end
