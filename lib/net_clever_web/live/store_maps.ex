defmodule NetCleverWeb.StoreMapsLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Stores.subscribe()
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, select_store(socket, params["selected_store"])}
  end

  defp select_store(socket, nil) do
    assign(socket,
      stores: Stores.list_stores(),
      selected_store: nil
    )
  end

  defp select_store(socket, selected_store) do
    selected_store = Stores.get_store(selected_store)

    socket
    |> assign(
      stores: Stores.list_stores(),
      selected_store: selected_store
    )
    |> push_event("highlight-marker", selected_store)
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreMapsView, "index.html", assigns)
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
  def handle_event("store-clicked", %{"store_id" => store_id}, socket) do
    store = get_store(socket, store_id)
    {:noreply, assign(socket, selected_store: store)}
  end
end
