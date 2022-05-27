defmodule RecipeBook.MixProject do
  use Mix.Project

  def project do
    [
      app: :recipe_book,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:boundary, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      boundary: boundary()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {RecipeBookApplication, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp boundary do
    [
      default: [
        check: [
          apps: [
            :phoenix,
            :ecto,
            {:mix, :runtime}
          ]
        ]
      ]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "== 1.6.8"},
      {:phoenix_ecto, "== 4.4.0"},
      {:ecto_sql, "== 3.8.1"},
      {:ecto_sqlite3, "== 0.7.5"},
      {:postgrex, "== 0.16.3"},
      {:phoenix_html, "== 3.2.0"},
      {:phoenix_live_reload, "== 1.3.3", only: :dev},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view", override: true},
      {:floki, "== 0.32.1", only: :test},
      {:phoenix_live_dashboard, "== 0.6.5"},
      {:esbuild, "== 0.4.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "== 0.6.1"},
      {:telemetry_poller, "== 1.0.0"},
      {:gettext, "== 0.19.1"},
      {:jason, "== 1.3.0"},
      {:plug_cowboy, "== 2.5.2"},
      {:credo, "== 1.6.4", only: [:dev], runtime: false},
      {:dialyxir, "== 1.1.0", only: [:dev], runtime: false},
      {:boundary, "== 0.9.2", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
