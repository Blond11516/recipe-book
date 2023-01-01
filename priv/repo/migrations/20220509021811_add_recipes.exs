defmodule RecipeBook.Repo.Migrations.AddRecipes do
  use Ecto.Migration

  def change do
    create table("recipes", primary_key: [name: :id, type: :binary_id], options: "WITHOUT ROWID") do
      add :name, :text, null: false

      timestamps()
    end
  end
end
