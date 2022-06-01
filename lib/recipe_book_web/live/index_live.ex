defmodule RecipeBookWeb.Live.IndexLive do
  use Phoenix.LiveView

  alias RecipeBook.Recipes

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
    ~H"""
    <div style="display: flex; flex-direction: row; justify-content: center; gap: 8px;">
      <%= for recipe <- @recipes do %>
        <li class="recipe-item">
          <img src={recipe.photo_url} />
          <%= recipe.name %>
        </li>
      <% end %>
    </div>
    """
  end
end
