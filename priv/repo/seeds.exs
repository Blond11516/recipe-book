# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RecipeBook.Repo.insert!(%RecipeBook.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for _ <- 1..10//1 do
  name = Faker.Food.dish()
  url = Faker.Internet.url() |> URI.new!()
  ingredients = Faker.Lorem.paragraph()
  {:ok, _} = RecipeBook.Recipes.add(name, url, ingredients)
end
