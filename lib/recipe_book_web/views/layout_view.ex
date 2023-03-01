defmodule RecipeBookWeb.LayoutView do
  use Phoenix.Template,
    root: "lib/recipe_book_web/templates",
    namespace: RecipeBookWeb

  use Phoenix.HTML

  use Surface.View, root: "lib/recipe_book_web/templates"

  import Phoenix.Controller,
    only: [get_flash: 2]

  import Phoenix.Component,
    only: [live_flash: 2]

  import Phoenix.LiveView.Helpers

  alias RecipeBookWeb.Router.Helpers, as: Routes

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
