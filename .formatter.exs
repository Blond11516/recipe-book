[
  plugins: [Phoenix.LiveView.HTMLFormatter, Surface.Formatter.Plugin],
  import_deps: [:ecto, :phoenix, :surface],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "{lib,test}/**/*.sface"
  ],
  subdirectories: ["priv/*/migrations"]
]
