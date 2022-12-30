defmodule RecipeBookWeb.Live.SuggestionsLive do
  use Surface.LiveView, layout: {RecipeBookWeb.LayoutView, :live}

  alias RecipeBookWeb.Normalization
  alias RecipeBook.Recipes
  alias RecipeBookWeb.Components.Recipe
  alias RecipeBookWeb.Components.VisuallyHidden
  alias RecipeBookWeb.Components.ErrorTag
  alias Surface.Components.Form
  alias Surface.Components.Form.Field
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.TextInput

  data recipes, :list
  data changeset, :changeset, default: Normalization.empty_changeset()

  @impl true
  def mount(_params, _session, socket) do
    recipes =
      if connected?(socket) do
        Recipes.get_random(3)
      else
        []
      end

    {:ok, assign(socket, recipes: recipes)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <style>
      .recipe-list {
      display: flex;
      flex-direction: row;
      justify-content: center;
      gap: 8px;
      }
    </style>

    <VisuallyHidden opts={%{id: "suggestions-title"}}>Suggestions de recettes</VisuallyHidden>

    <Form for={@changeset} as={:search} change="search">
      <Field name={:term}>
        <Label>
          Je cherche
          <TextInput opts={placeholder: "poulet"} />
          <ErrorTag />
        </Label>
      </Field>
    </Form>

    <ul class="recipe-list" aria-labelledby="suggestions-title">
      {#for recipe <- @recipes}
        <Recipe
          id={recipe.id}
          photo_url={recipe.photo_url}
          name={recipe.name}
          ingredients={recipe.ingredients}
        />
      {/for}
    </ul>
    """
  end

  @impl true
  def handle_event("search", %{"search" => params}, socket) do
    schema = %{
      term: %{type: :string, required?: true, length: %{min: 3}}
    }

    socket =
      with {:ok, normalized_input} <- Normalization.normalize(params, schema),
           suggestions <- Recipes.get_random(3, normalized_input.term) do
        assign(socket,
          changeset: Normalization.changeset_from(normalized_input, schema),
          recipes: suggestions
        )
      else
        {:error, changeset} -> assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end
end
