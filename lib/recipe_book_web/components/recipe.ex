defmodule RecipeBookWeb.Components.Recipe do
  use Surface.Component

  prop photo_url, :uri, required: true
  prop name, :string, required: true

  def render(assigns) do
    ~F"""
    <style>
      .recipe-item {
      display: flex;
      flex-direction: column;
      flex: 1;
      }
    </style>

    <li class="recipe-item">
      <img src={URI.to_string(@photo_url)}>
      {@name}
    </li>
    """
  end
end
