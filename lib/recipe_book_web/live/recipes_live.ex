defmodule RecipeBookWeb.Live.RecipesLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, "live.html"}

  alias RecipeBook.Recipes
  alias RecipeBookSchemas.EctoHttpURL
  alias RecipeBookWeb.Components.ErrorTag
  alias RecipeBookWeb.Components.Recipe
  alias RecipeBookWeb.Normalization
  alias Surface.Components.Form
  alias Surface.Components.Form.Field
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.Submit
  alias Surface.Components.Form.TextInput

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
      grid-template-columns: repeat(auto-fill, min(350px, 30%));
      margin: min(100px, 200px);
      gap: 8px;
      justify-content: center;
      }
    </style>

    <Form for={@changeset} as={:recipe} submit="add_recipe">
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
      <Submit>Ajouter</Submit>
    </Form>

    <ul class="recipe-list">
      {#for recipe <- @recipes}
        <Recipe photo_url={recipe.photo_url} name={recipe.name} />
      {/for}
    </ul>
    """
  end

  @impl true
  def handle_event("add_recipe", params, socket) do
    input_schema = %{
      name: %{type: :string, required?: true},
      photo_url: %{
        type: EctoHttpURL,
        required?: true
      }
    }

    params = params["recipe"]

    with {:ok, normalized_input} <- Normalization.normalize(params, input_schema),
         {:ok, new_recipe} <- Recipes.add(normalized_input.name, normalized_input.photo_url) do
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
