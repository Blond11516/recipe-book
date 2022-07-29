defmodule RecipeBookWeb.Components.Recipe do
  use Surface.Component

  prop photo_url, :string, required: true
  prop name, :string, required: true

  def render(assigns) do
    ~F"""
    <style>
      .recipe-item {
        display: flex;
        flex-direction: column;
      }
    </style>

    <li class="recipe-item">
      <img src={@photo_url} />
      {@name}
    </li>
    """
  end
end
