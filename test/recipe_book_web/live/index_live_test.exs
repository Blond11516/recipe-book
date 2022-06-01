defmodule RecipeBookWeb.Live.IndexTest do
  @moduledoc false

  alias RecipeBook.Repo
  alias RecipeBookSchemas.RecipeSchema

  use RecipeBookWeb.ConnCase

  import Phoenix.LiveViewTest

  test "renders 3 random recipes", %{conn: conn} do
    recipe_names = ["my awesome recipe", "some bad recipe", "a third recipe", "a fourth recipe"]

    Enum.each(recipe_names, fn name ->
      Repo.insert!(%RecipeSchema{name: name, photo_url: name})
    end)

    conn = get(conn, "/")
    {:ok, _live, html} = live(conn)

    number_of_recipes_displayed =
      recipe_names
      |> Enum.map(&(html =~ &1))
      |> Enum.filter(& &1)
      |> Enum.count()

    assert number_of_recipes_displayed == 3
  end
end
