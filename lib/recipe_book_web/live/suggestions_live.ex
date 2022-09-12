defmodule RecipeBookWeb.Live.SuggestionsLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, "live.html"}

  alias RecipeBook.Recipes
  alias RecipeBookWeb.Components.Recipe
  alias RecipeBookWeb.Components.VisuallyHidden

  @impl true
  def mount(_params, _session, socket) do
    recipes =
      if connected?(socket) do
        Recipes.get_random(3)
      else
        []
      end

    {:ok, assign(socket, recipes: recipes)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <style>
      .recipe-list {
      display: flex;
      flex-direction: row;
      justify-content: center;
      gap: 8px;
      }
    </style>

    <VisuallyHidden opts={%{id: "suggestions-title"}}>Suggestions de recettes</VisuallyHidden>
    <ul class="recipe-list" aria-labelledby="suggestions-title">
      {#for recipe <- @recipes}
        <Recipe photo_url={recipe.photo_url} name={recipe.name} ingredients={recipe.ingredients} />
      {/for}
    </ul>
    """
  end
end
