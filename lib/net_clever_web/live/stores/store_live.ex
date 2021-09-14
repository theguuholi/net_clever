defmodule NetCleverWeb.StoreLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Stores.subscribe()
    params = [name: nil, loading: false, matches: []]
    {:ok, load(socket, params), temporary_assigns: [stores: []]}
  end

  defp load(socket, params) do
    stores = Stores.list_stores()
    active_stores = Stores.get_active_store_numbers(true)
    inactive_stores = Stores.get_active_store_numbers(false)

    assign(
      socket,
      [stores: stores, active_stores: active_stores, inactive_stores: inactive_stores] ++ params
    )
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "index.html", assigns)
  end

  @impl true
  def handle_info({:store_updated, _store}, socket) do
    active_stores = Stores.get_active_store_numbers(true)
    inactive_stores = Stores.get_active_store_numbers(false)
    socket = assign(socket, active_stores: active_stores, inactive_stores: inactive_stores)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:search_by_name, name}, socket) do
    stores = Stores.list_stores_by_name(name)

    socket =
      case stores do
        [] ->
          socket
          |> put_flash(:info, "Nao existe lojas com: \"#{name}\"")
          |> assign(stores: stores, loading: false)

        stores ->
          assign(socket, stores: stores, loading: false)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("name-search", %{"name" => name}, socket) do
    send(self(), {:search_by_name, name})
    {:noreply, assign(socket, stores: [], loading: true, name: name)}
  end

  @impl true
  def handle_event("suggest-store", %{"name" => name}, socket) do
    matches = Stores.list_suggest_stores_by_name(name)

    {:noreply, assign(socket, matches: matches)}
  end
end
