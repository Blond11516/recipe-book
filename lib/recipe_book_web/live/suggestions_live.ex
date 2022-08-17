defmodule RecipeBookWeb.Live.SuggestionsLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, "live.html"}

  alias RecipeBook.Recipes
  alias RecipeBookWeb.Components.Recipe

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

    <div class="recipe-list">
      {#for recipe <- @recipes}
        <Recipe photo_url={recipe.photo_url} name={recipe.name} ingredients={recipe.ingredients} />
      {/for}
    </div>
    """
  end
end
