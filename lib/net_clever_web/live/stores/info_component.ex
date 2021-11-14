defmodule NetCleverWeb.Stores.InfoComponent do
  use NetCleverWeb, :live_component
  alias NetClever.Stores

  @impl true
  def update(assigns, socket) do
    socket =
      assign(socket,
        active_stores: assigns.active_stores,
        inactive_stores: assigns.inactive_stores,
        total_stores: assigns.active_stores + assigns.inactive_stores
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "info.html", assigns)
  end
end
