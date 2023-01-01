defmodule RecipeBookApplication do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Boundary, deps: [RecipeBook, RecipeBookWeb]

  @impl true
  def start(_type, _args) do
    # Migrate on app start because fly deploy commands run in a different container than the app, so they don't have
    # access to the database: https://community.fly.io/t/migration-in-sqlite3-on-volume-fails/3818/4
    migrate_if_prod()
    setup_opentelemetry()

    children = [
      # Start the Ecto repository
      RecipeBook.Repo,
      # Start the Telemetry supervisor
      RecipeBookWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RecipeBook.PubSub},
      # Start the Endpoint (http/https)
      RecipeBookWeb.Endpoint
      # Start a worker by calling: RecipeBook.Worker.start_link(arg)
      # {RecipeBook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RecipeBook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RecipeBookWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp setup_opentelemetry do
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:recipe_book, :repo])
  end

  if Mix.env() == :prod do
    defp migrate_if_prod do
      RecipeBookRelease.migrate()
    end
  else
    defp migrate_if_prod, do: :ok
  end
end
