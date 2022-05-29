defmodule RecipeBookWeb.Live.RecipesLive do
  use Phoenix.LiveView

  alias RecipeBook.Recipes

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
    ~H"""
    <ul class="recipe-list">
      <%= for recipe <- @recipes do %>
        <li class="recipe-item">
          <img src={recipe.photo_url} />
          <%= recipe.name %>
        </li>
      <% end %>
    </ul>
    """
  end
end
