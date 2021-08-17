defmodule NetCleverWeb.StoreRow do
  use NetCleverWeb, :live_component
  alias NetClever.Stores

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "store-row.html", assigns)
  end

  @impl true
  def handle_event("change-availability", %{"id" => id}, socket) do
    {:ok, store} = Stores.change_status(id)
    {:noreply, assign(socket, :store, store)}
  end
end
