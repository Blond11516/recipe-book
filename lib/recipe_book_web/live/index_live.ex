defmodule RecipeBookWeb.Live.IndexLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span>hello</span>
    """
  end
end
