defmodule RecipeBook.Repo.Migrations.AddRecipes do
  use Ecto.Migration

  def change do
    create table("recipes") do
      add :name, :text, null: false

      timestamps()
    end
  end
end
