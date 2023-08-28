defmodule RecipeBook.MixProject do
  use Mix.Project

  def project do
    [
      app: :recipe_book,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      boundary: boundary(),
      dialyzer: dialyzer(),
      releases: [
        recipe_book: [
          applications: [recipe_book: :permanent, opentelemetry: :temporary]
        ]
      ]
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

  defp dialyzer do
    [plt_add_apps: [:mix, :ex_unit]]
  end

  defp compilers do
    if Mix.env() in [:dev, :test] do
      [:boundary] ++ Mix.compilers() ++ [:surface]
    else
      Mix.compilers() ++ [:surface]
    end
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "== 1.7.7"},
      {:phoenix_ecto, "== 4.4.2"},
      {:ecto_sql, "== 3.10.2"},
      {:ecto_sqlite3, "== 0.10.3"},
      {:phoenix_html, "== 3.3.2"},
      {:phoenix_live_reload, "== 1.4.1", only: :dev},
      {:phoenix_live_view, "== 0.19.5"},
      {:phoenix_live_dashboard, "== 0.8.1"},
      {:esbuild, "== 0.7.1", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "== 0.6.1"},
      {:telemetry_poller, "== 1.0.0"},
      {:gettext, "== 0.23.1"},
      {:jason, "== 1.4.1"},
      {:bandit, "== 0.7.7"},
      {:dotenv_parser, "== 2.0.0"},
      {:surface, "== 0.11.0"},
      {:opentelemetry, "== 1.3.1",
       runtime: Mix.env() == :prod or System.get_env("DEBUG_OPENTELEMETRY") == "true"},
      {:opentelemetry_api, "== 1.2.2"},
      {:opentelemetry_exporter, "== 1.6.0"},
      {:opentelemetry_ecto, "== 1.1.1"},
      {:opentelemetry_liveview, "== 1.0.0-rc.4"},
      {:opentelemetry_phoenix, "== 1.1.1"},
      {:faker, "== 0.17.0", only: [:dev, :test]},
      {:boundary, "== 0.10.0", runtime: false},
      {:gradient, github: "esl/gradient", only: [:dev, :test], runtime: false},
      {:credo, "== 1.7.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "== 1.4.0", only: [:dev, :test], runtime: false},
      {:mix_audit, "== 2.1.1", only: [:dev, :test], runtime: false},
      {:sobelow, "== 0.13.0", only: [:dev, :test], runtime: false}
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
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
