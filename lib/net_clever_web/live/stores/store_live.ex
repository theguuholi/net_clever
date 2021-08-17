defmodule NetCleverWeb.StoreLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, load(socket), temporary_assigns: [stores: []]}
  end

  defp load(socket) do
    stores = Stores.list_stores()
    assign(socket, stores: stores)
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "index.html", assigns)
  end
end
