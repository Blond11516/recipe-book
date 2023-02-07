defmodule RecipeBookWeb.Plug.SecureBrowserHeaders do
  def init(options), do: options

  def call(conn, _opts) do
    nonce = generate_nonce()
    headers = generate_csp_headers(nonce)

    conn
    |> Plug.Conn.assign(:csp_nonce, nonce)
    |> Phoenix.Controller.put_secure_browser_headers(headers)
  end

  defp generate_nonce() do
    10
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end

  defp generate_csp_headers(nonce) do
    content =
      [
        "default-src 'self' 'nonce-#{nonce}'",
        "img-src *"
      ]
      |> Enum.join("; ")
      |> then(&(&1 <> ";"))

    %{
      "content-security-policy" => content
    }
  end
end
