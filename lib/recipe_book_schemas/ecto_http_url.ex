defmodule RecipeBookSchemas.EctoHttpURL do
  use Ecto.Type

  alias RecipeBook.HttpURI

  @impl true
  def type, do: :string

  @impl true
  def cast(raw_url) when is_binary(raw_url) do
    case HttpURI.from_string(raw_url) do
      {:ok, url} -> {:ok, url}
      {:error, error} -> {:error, message: error}
    end
  end

  def cast(%HttpURI{} = uri), do: {:ok, uri}

  def cast(_), do: :error

  @impl true
  def load(raw_url) when is_binary(raw_url) do
    case HttpURI.from_string(raw_url) do
      {:ok, uri} -> {:ok, uri}
      {:error, _} -> :error
    end
  end

  @impl true
  def dump(%HttpURI{} = uri), do: {:ok, HttpURI.to_string(uri)}
  def dump(_), do: :error
end
