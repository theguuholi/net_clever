defmodule NetCleverWeb.StoreMapsLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Stores.subscribe()
    socket = assign(socket, stores: Stores.list_stores(), selected_store: nil)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreMapsView, "index.html", assigns)
  end

  def handle_info({:store_created, store}, socket) do
    socket =
      socket
      |> update(:stores, &[store | &1])
      |> assign(selected_store: store)
      |> push_event("add-marker", store)

    {:noreply, socket}
  end
end
