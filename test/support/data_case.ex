defmodule RecipeBook.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use RecipeBook.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    repo_module = Module.concat([RecipeBook.Test, __CALLER__.module, Repo])

    quote do
      defmodule unquote(repo_module) do
        use Ecto.Repo,
          otp_app: :recipe_book,
          adapter: Ecto.Adapters.SQLite3
      end

      alias unquote(repo_module), as: Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import RecipeBook.DataCase

      setup_all do
        RecipeBook.DataCase.setup_repo(unquote(repo_module))
        :ok
      end

      setup tags do
        RecipeBook.DataCase.setup_sandbox(unquote(repo_module))

        # Sleep for one millisecond to avoid a race condition where some tests in a suite sometimes fail with a
        # "database busy" error
        Process.sleep(1)

        :ok
      end
    end
  end

  def setup_repo(repo_module) do
    test_db_path = setup_db_file(repo_module)

    Application.put_env(
      :recipe_book,
      repo_module,
      database: test_db_path,
      pool: Sandbox
    )

    start_supervised(repo_module)

    Sandbox.mode(repo_module, :manual)

    repo_module.__adapter__.storage_up(repo_module.config)

    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(repo_module) do
    pid = Sandbox.start_owner!(repo_module, shared: false)
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  @spec setup_db_file(atom()) :: String.t()
  defp setup_db_file(repo_module) do
    reference_db_path =
      Application.get_env(:recipe_book, RecipeBook.Repo)
      |> Keyword.get(:database)

    db_directory = Path.dirname(reference_db_path)
    test_db_path = Path.join([db_directory, "#{repo_module}.sqlite"])

    clean_db_files(repo_module, db_directory)
    File.copy(reference_db_path, test_db_path)
    on_exit(fn -> clean_db_files(repo_module, db_directory) end)

    test_db_path
  end

  defp clean_db_files(repo_module, db_directory) do
    [db_directory, "#{repo_module}*"]
    |> Path.wildcard()
    |> Enum.each(fn file_path -> File.rm(file_path) end)
  end
end
