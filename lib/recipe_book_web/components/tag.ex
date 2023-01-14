defmodule RecipeBookWeb.Components.Tag do
  use Surface.Component

  prop content, :string
  prop on_remove, :event

  @impl true
  def render(assigns) do
    ~F"""
    <style>
      .tag-wrapper {
      font-family: 'Fira Sans';
      background-color: #0069d9;
      font-weight: bold;
      color: white;
      text-transform: uppercase;
      font-size: 1.2rem;

      width: fit-content;
      padding: 2px 4px;
      border: 4px solid navy;
      border-radius: 4px;
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 4px;
      }

      .remove-button {
      height: revert;
      padding: 0px;
      border: none;
      font-size: 3rem;
      }

      .remove-button:hover, .remove-button:focus {
      background-color: transparent;
      border: none;
      }
    </style>

    <div class="tag-wrapper">
      <span>{@content}</span>
      <button class="remove-button" :on-click={@on_remove}>×</button>
    </div>
    """
  end
end
