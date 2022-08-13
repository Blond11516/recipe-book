defmodule RecipeBookSchemas.EctoHttpURL do
  use Ecto.Type

  @impl true
  def type, do: :string

  @impl true
  def cast(raw_url) when is_binary(raw_url) do
    case parse_http_url(raw_url) do
      {:ok, url} -> {:ok, url}
      {:error, error} -> {:error, message: error}
    end
  end

  def cast(%URI{} = uri), do: {:ok, uri}

  def cast(_), do: :error

  @impl true
  def load(raw_url) when is_binary(raw_url) do
    case parse_http_url(raw_url) do
      {:ok, uri} -> {:ok, uri}
      {:error, _} -> :error
    end
  end

  @impl true
  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}
  def dump(_), do: :error

  defp parse_http_url(raw_url) do
    case URI.new(raw_url) do
      {:ok, %URI{scheme: scheme, host: host} = uri}
      when scheme in ["http", "https"] and is_binary(host) ->
        {:ok, uri}

      {:error, error} ->
        {:error, error}

      {:ok, _} ->
        {:error, "not an HTTP url"}
    end
  end
end
