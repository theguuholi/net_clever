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
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    paginate = %{page: page, per_page: per_page}

    sort_by = (params["sort_by"] || "name") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()
    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    stores = Stores.list_stores_with_filters(paginate: paginate, sort: sort_options)

    {:noreply,
     assign(socket,
       stores: stores,
       name:  nil,
       loading: false,
       matches: [],
       options: Map.merge(paginate, sort_options),
       page: page,
       per_page: per_page
     )}
  end

  @impl true
  def handle_info({:store_created, store}, socket) do
    socket = put_flash(socket, :info, "Loja #{store.name} foi criada!")
    {:noreply, socket}
  end

  @impl true
  def handle_info({:search_by_name, name}, socket) do
    :timer.sleep(1000)
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
end
