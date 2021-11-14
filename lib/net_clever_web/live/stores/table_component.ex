defmodule NetCleverWeb.Stores.TableComponent do
  use NetCleverWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "table.html", assigns)
  end

  @impl true
  def handle_event("nex-page", %{"key" => "ArrowDown"}, socket) do
    socket =
      if socket.assigns.page == 1 do
        socket
      else
        next_page(socket, socket.assigns.page - 1)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("nex-page", %{"key" => "ArrowUp"}, socket) do
    {:noreply, next_page(socket, socket.assigns.page + 1)}
  end

  defp next_page(socket, page) do
    push_patch(socket,
      to:
        Routes.store_path(socket, :index,
          page: page,
          per_page: socket.assigns.per_page,
          sort_by: socket.assigns.options.sort_by,
          sort_order: socket.assigns.options.sort_order
        )
    )
  end

  @impl true
  def handle_event("nex-page", _, socket) do
    {:noreply, socket}
  end
end
