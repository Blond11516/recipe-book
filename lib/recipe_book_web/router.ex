defmodule RecipeBookWeb.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RecipeBookWeb.LayoutView, :root}
    plug :protect_from_forgery

    plug RecipeBookWeb.Plug.SecureBrowserHeaders
  end

  scope "/", RecipeBookWeb do
    pipe_through :browser

    live_session :default do
      live "/", Live.SuggestionsLive
      live "/recettes", Live.RecipesLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecipeBookWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: RecipeBookWeb.Telemetry,
        csp_nonce_assign_key: :csp_nonce
    end
  end
end
