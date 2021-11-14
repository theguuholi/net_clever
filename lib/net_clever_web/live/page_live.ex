defmodule NetCleverWeb.PageLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 4)
      |> load_stores()

    {:ok, socket, temporary_assigns: [stores: []]}
  end

  defp load_stores(socket) do
    assign(socket,
      stores: Stores.list_stores(page: socket.assigns.page, per_page: socket.assigns.per_page)
    )
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.PageView, "index.html", assigns)
  end

  @impl true
  def handle_event("load-stores", _, socket) do
    :timer.sleep(1000)
    socket = socket |> update(:page, &(&1 + 1)) |> load_stores()
    {:noreply, socket}
  end
end
