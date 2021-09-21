defmodule NetCleverWeb.Stores.TableComponent do
  use NetCleverWeb, :live_component
  alias NetClever.Stores

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "table.html", assigns)
  end


  @impl true
  def handle_event("filter-category", %{"category" => category}, socket) do
    stores = Stores.list_stores_with_filters(category: category)
    {:noreply, assign(socket, stores: stores)}
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

  @impl true
  def handle_event("suggest-store", %{"name" => name}, socket) do
    matches = Stores.list_suggest_stores_by_name(name)
    {:noreply, assign(socket, matches: matches)}
  end

end
