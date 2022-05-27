defmodule RecipeBook.Repo do
  use Ecto.Repo,
    otp_app: :recipe_book,
    adapter: Ecto.Adapters.SQLite3
end
