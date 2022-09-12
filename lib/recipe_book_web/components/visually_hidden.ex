defmodule RecipeBookWeb.Components.VisuallyHidden do
  use Surface.Component

  prop class, :css_class, default: []

  prop opts, :map, default: %{}

  slot default, required: true

  def render(assigns) do
    ~F"""
    <style>
      .visually-hidden {
      border: 0;
      clip: rect(0 0 0 0);
      height: auto;
      margin: 0;
      overflow: hidden;
      padding: 0;
      position: absolute;
      width: 1px;
      white-space: nowrap;
      }
    </style>

    <div class={["visually-hidden" | @class]} {...@opts}>
      <#slot />
    </div>
    """
  end
end
