defmodule RecipeBookWeb.Live.RecipesTest do
  @moduledoc false

  alias RecipeBook.Repo
  alias RecipeBookSchemas.RecipeSchema

  use RecipeBookWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders all recipe names", %{conn: conn} do
    recipe_names = ["my awesome recipe", "some bad recipe"]

    Enum.each(recipe_names, &Repo.insert!(%RecipeSchema{name: &1}))

    conn = get(conn, "/recettes")
    {:ok, _live, html} = live(conn)

    for name <- recipe_names do
      assert html =~ name
    end
  end
end
