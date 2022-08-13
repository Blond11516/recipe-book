defmodule RecipeBookWeb.Normalization do
  alias Ecto.Changeset
  alias RecipeBookSchemas.EctoHttpURL

  @type schema_field :: atom()
  @type schema_field_type :: :string | EctoHttpURL
  @type schema_field_value :: String.t()
  @type validation_error :: {schema_field(), String.t()}
  @type field_validator :: (schema_field(), schema_field_value() -> [validation_error()])
  @type value_caster :: (schema_field_value() -> any())
  @type field_options :: %{
          :type => schema_field_type(),
          optional(:required?) => boolean()
        }
  @type normalization_schema() :: %{
          schema_field() => field_options()
        }

  @spec normalize(map(), normalization_schema()) :: {:ok, map()} | {:error, Changeset.t()}
  def normalize(params, schema) do
    types = Map.new(schema, fn {field, options} -> {field, options.type} end)

    {%{}, types}
    |> Changeset.cast(params, Map.keys(types))
    |> apply_required_validations(schema)
    |> Changeset.apply_action(:insert)
  end

  @spec empty_changeset() :: Changeset.t(%{})
  def empty_changeset, do: Changeset.cast({%{}, %{}}, %{}, [])

  @spec apply_required_validations(Changeset.t(), normalization_schema()) :: Changeset.t()
  defp apply_required_validations(changeset, schema) do
    required_fields =
      schema
      |> Map.filter(fn {_, options} -> options.required? == true end)
      |> Map.keys()

    Changeset.validate_required(changeset, required_fields)
  end
end
