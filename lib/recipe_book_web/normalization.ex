defmodule RecipeBookWeb.Normalization do
  alias Ecto.Changeset
  alias RecipeBookSchemas.EctoHttpURL

  @type schema_field :: atom()
  @type schema_field_type :: :string | EctoHttpURL
  @type schema_field_value :: String.t()
  @type validation_error :: {schema_field(), String.t()}
  @type field_validator :: (schema_field(), schema_field_value() -> [validation_error()])
  @type value_caster :: (schema_field_value() -> any())
  @type length_options :: %{optional(:min) => integer(), optional(:max) => integer()}
  @type field_options :: %{
          :type => schema_field_type(),
          optional(:required?) => boolean(),
          optional(:length) => length_options()
        }
  @type normalization_schema() :: %{
          schema_field() => field_options()
        }

  @spec normalize(map(), normalization_schema()) :: {:ok, map()} | {:error, Changeset.t()}
  def normalize(params, schema) do
    params
    |> changeset_from(schema)
    |> apply_required_validations(schema)
    |> apply_length_validations(schema)
    |> Changeset.apply_action(:insert)
  end

  @spec changeset_from(map() | struct(), normalization_schema()) :: Changeset.t()
  def changeset_from(%_{} = params, schema) do
    params
    |> Map.from_struct()
    |> changeset_from(schema)
  end

  def changeset_from(params, schema) do
    types = Map.new(schema, fn {field, options} -> {field, options.type} end)

    Changeset.cast({%{}, types}, params, Map.keys(types))
  end

  @spec empty_changeset() :: Changeset.t(%{})
  def empty_changeset, do: Changeset.cast({%{}, %{}}, %{}, [])

  @spec apply_required_validations(Changeset.t(), normalization_schema()) :: Changeset.t()
  defp apply_required_validations(changeset, schema) do
    required_fields =
      schema
      |> Map.filter(fn {_, options} -> options[:required?] == true end)
      |> Map.keys()

    Changeset.validate_required(changeset, required_fields)
  end

  @spec apply_length_validations(Changeset.t(), normalization_schema()) :: Changeset.t()
  defp apply_length_validations(changeset, schema) do
    schema
    |> Map.filter(fn {_, options} -> Map.has_key?(options, :length) end)
    |> Enum.reduce(changeset, fn {field, options}, changeset ->
      Changeset.validate_length(changeset, field, Map.to_list(options.length))
    end)
  end
end
