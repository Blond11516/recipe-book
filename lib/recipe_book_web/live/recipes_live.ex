defmodule RecipeBookWeb.Live.RecipesLive do
  use Surface.LiveView

  alias RecipeBook.Recipes
  alias RecipeBookWeb.Components.Recipe

  @impl true
  def mount(_params, _session, socket) do
    recipes =
      if connected?(socket) do
        Recipes.all()
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
      display: grid;
      grid-template-columns: repeat(auto-fill, min(350px, 30%));
      margin: min(100px, 200px);
      gap: 8px;
      justify-content: center;
      }
    </style>

    <ul class="recipe-list">
      {#for recipe <- @recipes}
        <Recipe photo_url={recipe.photo_url} name={recipe.name} />
      {/for}
    </ul>
    """
  end
end
