defmodule RecipeBookWeb.PhoenixHtmlUri do
  defimpl Phoenix.HTML.Safe, for: URI do
    @spec to_iodata(URI.t()) :: String.t()
    def to_iodata(uri), do: URI.to_string(uri)
  end
end
