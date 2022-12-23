defmodule RecipeBookWeb.Live.RecipesLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, :live}

  alias RecipeBook.Recipes
  alias RecipeBookSchemas.EctoHttpURL
  alias RecipeBookWeb.Components.ErrorTag
  alias RecipeBookWeb.Components.Recipe
  alias RecipeBookWeb.Normalization
  alias Surface.Components.Form
  alias Surface.Components.Form.Field
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.Submit
  alias Surface.Components.Form.TextArea
  alias Surface.Components.Form.TextInput

  @recipe_normalization_schema %{
    name: %{type: :string, required?: true},
    photo_url: %{
      type: EctoHttpURL,
      required?: true
    },
    ingredients: %{
      type: :string,
      required?: true
    }
  }

  data recipes, :list, default: []
  data changeset, :changeset
  data editing, :string, default: nil

  @impl true
  def mount(_params, _session, socket) do
    recipes =
      if connected?(socket) do
        Recipes.all()
      else
        []
      end

    {:ok, assign(socket, recipes: recipes, changeset: Normalization.empty_changeset())}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <style>
      .recipe-list {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(min(350px, 100%), 1fr));
      margin-top: 32px;
      gap: 8px;
      justify-content: space-between;
      }

      .recipe-list > :deep(*) {
      width: revert;
      }
    </style>

    <Form for={@changeset} as={:recipe} submit="submit_recipe">
      <Field name={:name}>
        <Label>
          Nom
          <TextInput />
          <ErrorTag />
        </Label>
      </Field>
      <Field name={:photo_url}>
        <Label>
          Url de la photo
          <TextInput />
          <ErrorTag />
        </Label>
      </Field>
      <Field name={:ingredients}>
        <Label>
          Ingrédients
          <TextArea />
          <ErrorTag />
        </Label>
      </Field>
      <Submit>{submit_label(@editing)}</Submit>
    </Form>

    <ul class="recipe-list">
      {#for recipe <- @recipes}
        <Recipe
          id={recipe.id}
          photo_url={recipe.photo_url}
          name={recipe.name}
          ingredients={recipe.ingredients}
          on_edit="edit_recipe"
        />
      {/for}
    </ul>
    """
  end

  @impl true
  def handle_event("submit_recipe", params, socket) do
    if socket.assigns.editing == nil do
      save_new_recipe(params, socket)
    else
      update_recipe(params, socket, socket.assigns.editing)
    end
  end

  def handle_event("edit_recipe", params, socket) do
    edited_recipe_id = Map.fetch!(params, "recipe_id")

    changeset =
      socket.assigns.recipes
      |> Enum.find(fn recipe -> recipe.id == edited_recipe_id end)
      |> Normalization.changeset_from(@recipe_normalization_schema)

    {:noreply, assign(socket, changeset: changeset, editing: edited_recipe_id)}
  end

  defp submit_label(nil), do: "Ajouter"
  defp submit_label(_), do: "Sauvegarder"

  defp update_recipe(params, socket, recipe_id) do
    params = params["recipe"]

    with {:ok, normalized_input} <- Normalization.normalize(params, @recipe_normalization_schema),
         {:ok, updated_recipe} <-
           Recipes.update(
             recipe_id,
             normalized_input.name,
             normalized_input.photo_url,
             normalized_input.ingredients
           ) do
      updated_recipes =
        Enum.map(socket.assigns.recipes, fn recipe ->
          if recipe.id == recipe_id do
            updated_recipe
          else
            recipe
          end
        end)

      {:noreply,
       assign(socket,
         recipes: updated_recipes,
         changeset: Normalization.empty_changeset(),
         editing: nil
       )}
    else
      {:error, changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_new_recipe(params, socket) do
    params = params["recipe"]

    with {:ok, normalized_input} <- Normalization.normalize(params, @recipe_normalization_schema),
         {:ok, new_recipe} <-
           Recipes.add(
             normalized_input.name,
             normalized_input.photo_url,
             normalized_input.ingredients
           ) do
      {:noreply,
       assign(socket,
         recipes: [new_recipe | socket.assigns.recipes],
         changeset: Normalization.empty_changeset()
       )}
    else
      {:error, changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
