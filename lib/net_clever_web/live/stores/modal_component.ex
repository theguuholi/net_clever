defmodule NetCleverWeb.Stores.ModalComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "modal.html", assigns)
  end

  @impl true
  def handle_info({:store_updated, _store}, socket) do
    active_stores = Stores.get_active_store_numbers(true)
    inactive_stores = Stores.get_active_store_numbers(false)
    socket = assign(socket, active_stores: active_stores, inactive_stores: inactive_stores)
    {:noreply, socket}
  end
end
