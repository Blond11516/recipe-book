defmodule RecipeBookWeb.Components.ErrorTag do
  use Surface.Component

  alias Surface.Components.Form.ErrorTag

  def render(assigns) do
    ~F"""
    <style>
      .error-tag-wrapper :deep(.error-tag) {
      color: red;
      font-weight: bolder;
      }
    </style>

    <div class="error-tag-wrapper">
      <ErrorTag class="error-tag" />
    </div>
    """
  end
end
