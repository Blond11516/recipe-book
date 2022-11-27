defmodule RecipeBookWeb.Components.Recipe do
  use Surface.Component

  prop id, :string, required: true
  prop photo_url, :uri, required: true
  prop name, :string, required: true
  prop ingredients, :string, required: true

  @impl true
  def render(assigns) do
    ~F"""
    <style>
      .recipe-item {
      display: flex;
      flex-direction: column;
      flex: 1;
      width: 0;
      }

      .recipe-item :deep(img) {
      object-fit: cover;
      height: 400px;
      width: 100%;
      }

      .name {
      font-weight: bold;
      }

      .ingredients {
      overflow-x: auto;
      }
    </style>

    <li class="recipe-item" aria-labelledby={name_label_id(@id)}>
      <img class="test" src={URI.to_string(@photo_url)}>
      <p id={name_label_id(@id)} class="name">{@name}</p>
      <pre class="ingredients">{@ingredients}</pre>
    </li>
    """
  end

  defp name_label_id(id) do
    "recipe-name_" <> id
  end
end
