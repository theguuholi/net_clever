defmodule NetCleverWeb.Stores.InfoComponent do
  use NetCleverWeb, :live_component
  alias NetClever.Stores

  def update(_assigns, socket) do
    active_stores = Stores.get_active_store_numbers(true)
    inactive_stores = Stores.get_active_store_numbers(false)

    socket =
      assign(socket,
        active_stores: active_stores,
        inactive_stores: inactive_stores,
        total_stores: active_stores + inactive_stores
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "info.html", assigns)
  end

  @impl true
  def handle_info({:update_store_info}, socket) do
    active_stores = Stores.get_active_store_numbers(true)
    inactive_stores = Stores.get_active_store_numbers(false)
    socket = assign(socket, active_stores: active_stores, inactive_stores: inactive_stores)
    {:noreply, socket}
  end
end
