defmodule RecipeBook.Repo.Migrations.AddRecipePhotoUrl do
  use Ecto.Migration

  def change do
    alter table("recipes") do
      add :photo_url, :string, null: false
    end
  end
end
