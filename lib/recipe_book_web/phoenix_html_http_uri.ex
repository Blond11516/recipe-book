defmodule RecipeBookWeb.PhoenixHtmlUri do
  alias RecipeBook.HttpURI

  defimpl Phoenix.HTML.Safe, for: HttpURI do
    @spec to_iodata(HttpURI.t()) :: String.t()
    def to_iodata(uri), do: HttpURI.to_string(uri)
  end
end
