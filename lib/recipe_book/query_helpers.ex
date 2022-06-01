defmodule RecipeBook.QueryHelpers do
  defmacro random do
    quote do
      fragment("RANDOM()")
    end
  end
end
