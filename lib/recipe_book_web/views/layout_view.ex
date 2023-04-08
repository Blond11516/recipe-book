defmodule RecipeBookWeb.LayoutView do
  use Phoenix.Template,
    root: "lib/recipe_book_web/templates",
    namespace: RecipeBookWeb

  use Phoenix.HTML

  use Surface.View, root: "lib/recipe_book_web/templates"

  use Phoenix.VerifiedRoutes,
    endpoint: RecipeBookWeb.Endpoint,
    router: RecipeBookWeb.Router,
    statics: RecipeBookWeb.static_paths()

  import Phoenix.LiveView.Helpers

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}
end
