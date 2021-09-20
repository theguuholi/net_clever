defmodule NetCleverWeb.StoreLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Stores.subscribe()
    {:ok, socket, temporary_assigns: [stores: []]}
  end

  @spec get_categories :: any
  def get_categories do
    Stores.get_categories()
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "index.html", assigns)
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, assign(socket, params: params)}
  end

  @impl true
  def handle_info({:store_updated, _store}, socket) do
    send(:"store-info", :update_store_info)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:store_created, store}, socket) do
    socket = put_flash(socket, :info, "Loja #{store.name} foi criada!")
    {:noreply, socket}
  end

end
