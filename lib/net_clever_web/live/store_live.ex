defmodule NetCleverWeb.StoreLive do
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
    Phoenix.View.render(NetCleverWeb.StoreView, "index.html", assigns)
  end

  defp get_store(socket, id) do
    Enum.find(socket.assigns.stores, &(&1.id == id))
  end

  @impl true
  def handle_info({:store_created, store}, socket) do
    socket =
      socket
      |> update(:stores, &[store | &1])
      |> assign(selected_store: store)
      |> push_event("add-marker", store)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select-store", %{"id" => id}, socket) do
    store = get_store(socket, id)
    params = [selected_store: store]

    socket =
      socket
      |> assign(params)
      |> push_event("highlight-marker", store)

    {:noreply, socket}
  end

  @impl true
  def handle_event("get-incidents", _, socket) do
    {:reply, %{stores: socket.assigns.stores}, socket}
  end

  @impl true
  def handle_event("store-clicked", store_id, socket) do
    store = get_store(socket, store_id)
    # {:noreply, assign(socket, selected_store: store)}
    {:reply, %{store: store}, assign(socket, selected_store: store)}
  end
end
