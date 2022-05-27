defmodule RecipeBookWeb.Live.Recipes do
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
    <ul>
      <%= for recipe <- @recipes do %>
        <li><%= recipe.name %></li>
      <% end %>
    </ul>
    """
  end
end
