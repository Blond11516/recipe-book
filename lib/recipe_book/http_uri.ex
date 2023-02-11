defmodule RecipeBook.HttpURI do
  @type t() :: %__MODULE__{
          userinfo: nil | binary,
          host: nil | binary,
          port: nil | :inet.port_number(),
          path: nil | binary,
          query: nil | binary,
          fragment: nil | binary,
          secure?: boolean()
        }

  @enforce_keys [:host, :secure?]
  defstruct [:userinfo, :host, :port, :path, :query, :fragment, :secure?]

  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(raw_uri) do
    with {:ok, uri} <- URI.new(raw_uri) do
      from_uri(uri)
    end
  end

  @spec from_uri(URI.t()) :: {:ok, t()} | {:error, String.t()}
  def from_uri(uri) do
    case uri.scheme do
      "http" -> {:ok, build_from_uri(uri, false)}
      "https" -> {:ok, build_from_uri(uri, true)}
      _ -> {:error, "Invalid scheme"}
    end
  end

  @spec to_string(t()) :: String.t()
  def to_string(%__MODULE__{} = http_uri) do
    http_uri
    |> to_uri()
    |> URI.to_string()
  end

  @spec get_scheme(t()) :: String.t()
  defp get_scheme(%__MODULE__{secure?: true}), do: "https"
  defp get_scheme(%__MODULE__{secure?: false}), do: "http"

  @spec build_from_uri(URI.t(), boolean()) :: t()
  defp build_from_uri(%URI{} = uri, secure?) do
    %__MODULE__{
      fragment: uri.fragment,
      host: uri.host,
      path: uri.path,
      port: uri.port,
      query: uri.query,
      userinfo: uri.userinfo,
      secure?: secure?
    }
  end

  @spec to_uri(t()) :: URI.t()
  defp to_uri(%__MODULE__{} = http_uri) do
    %URI{
      fragment: http_uri.fragment,
      host: http_uri.host,
      path: http_uri.path,
      port: http_uri.port,
      query: http_uri.query,
      userinfo: http_uri.userinfo,
      scheme: get_scheme(http_uri)
    }
  end
end
