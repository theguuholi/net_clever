defmodule NetCleverWeb.StoreLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Stores.subscribe()
    {:ok, socket, temporary_assigns: [stores: []]}
  end

  def get_categories do
    Stores.get_categories()
  end

  defp load(socket, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    paginate = %{page: page, per_page: per_page}

    sort_by = (params["sort_by"] || "name") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()
    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    stores = Stores.list_stores_with_filters(paginate: paginate, sort: sort_options)

    params =
      [
        stores: stores,
        options: Map.merge(paginate, sort_options),
        name: nil, loading: false, matches: [], page: page, per_page: per_page
      ]

    assign(
      socket,
      params
    )
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "index.html", assigns)
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket = load(socket, params)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:store_updated, _store}, socket) do
    send(:"store-info", :update_store_info)
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


  @impl true
  def handle_info({:store_created, store}, socket) do
    socket = put_flash(socket, :info, "Loja #{store.name} foi criada!")
    {:noreply, socket}
  end

  @impl true
  def handle_event("filter-category", %{"category" => category}, socket) do
    stores = Stores.list_stores_with_filters(category: category)
    {:noreply, assign(socket, stores: stores)}
  end

  @impl true
  def handle_event("suggest-store", %{"name" => name}, socket) do
    matches = Stores.list_suggest_stores_by_name(name)
    {:noreply, assign(socket, matches: matches)}
  end

  @impl true
  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)
    paginate = %{page: socket.assigns.options.page, per_page: per_page}
    socket =
      push_patch(socket,
        to: Routes.store_path(socket, :index,
        page: paginate.page,
        per_page: per_page,
        sort_by: socket.assigns.options.sort_by,
        sort_order: socket.assigns.options.sort_order)
      )

    {:noreply, socket}
  end
end
