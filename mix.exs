defmodule RecipeBook.MixProject do
  use Mix.Project

  def project do
    [
      app: :recipe_book,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:boundary] ++ Mix.compilers() ++ [:surface],
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
      extra_applications: [:logger, :runtime_tools, :os_mon]
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
      {:phoenix, "== 1.6.11"},
      {:phoenix_ecto, "== 4.4.0"},
      {:ecto_sql, "== 3.8.3"},
      {:ecto_sqlite3, "== 0.7.7"},
      {:postgrex, "== 0.16.3"},
      {:phoenix_html, "== 3.2.0"},
      {:phoenix_live_reload, "== 1.3.3", only: :dev},
      {:phoenix_live_view, "== 0.17.11"},
      {:phoenix_live_dashboard, "== 0.6.5"},
      {:esbuild, "== 0.5.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "== 0.6.1"},
      {:telemetry_poller, "== 1.0.0"},
      {:gettext, "== 0.20.0"},
      {:jason, "== 1.3.0"},
      {:plug_cowboy, "== 2.5.2"},
      {:dotenv_parser, "== 2.0.0"},
      {:surface, github: "surface-ui/surface", ref: "2bf353e1d129ccf786655dfe220f4f077aaca7a4"},
      {:credo, "== 1.6.5", only: [:dev], runtime: false},
      {:dialyxir, "== 1.2.0", only: [:dev], runtime: false},
      {:boundary, "== 0.9.3", only: [:dev, :test], runtime: false}
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
