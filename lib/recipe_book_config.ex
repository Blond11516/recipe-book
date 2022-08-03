defmodule RecipeBookConfig do
  use Boundary, type: :strict, deps: [DotenvParser]

  require Config

  @spec load_env() :: :ok
  def load_env() do
    env_file_path = "env/.#{Atom.to_string(Config.config_env())}.env"

    if File.exists?(env_file_path) do
      DotenvParser.load_file(env_file_path)
    end
  end

  @spec database_path() :: String.t()
  def database_path(), do: System.fetch_env!("DATABASE_PATH")

  @spec secret_key_base() :: String.t()
  def secret_key_base(), do: System.fetch_env!("SECRET_KEY_BASE")

  @spec phx_server() :: boolean()
  def phx_server(), do: get_boolean("PHX_SERVER", false)

  @spec pool_size() :: integer()
  def pool_size(), do: get_integer("POOL_SIZE", 10)

  @spec phx_host() :: String.t()
  def phx_host(), do: System.fetch_env!("PHX_HOST")

  @spec port() :: integer()
  def port(), do: get_integer("PORT", 4000)

  @spec get_boolean(String.t(), boolean()) :: boolean()
  defp get_boolean(var_name, default) do
    case System.get_env(var_name) do
      "true" -> true
      "false" -> false
      _ -> default
    end
  end

  @spec get_integer(String.t(), integer()) :: integer()
  defp get_integer(var_name, default) do
    with {:ok, value} <- System.fetch_env(var_name),
         int <- String.to_integer(value) do
      int
    else
      _ -> default
    end
  end
end
