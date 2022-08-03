defmodule RecipeBookWeb.Live.RecipesLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, "live.html"}

  alias RecipeBook.Recipes
  alias RecipeBookWeb.Components.ErrorTag
  alias RecipeBookWeb.Components.Recipe
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

    {:ok, assign(socket, recipes: recipes, changeset: recipe_changeset())}
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
    case Recipes.add(params["recipe"]["name"], params["recipe"]["photo_url"]) do
      {:ok, new_recipe} ->
        {:noreply,
         assign(socket,
           recipes: [new_recipe | socket.assigns.recipes],
           changeset: recipe_changeset()
         )}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp recipe_changeset, do: Recipes.add_changeset(nil, nil)
end
