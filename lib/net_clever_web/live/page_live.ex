defmodule NetCleverWeb.PageLive do
  use NetCleverWeb, :live_view
  alias NetClever.Stores

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, stores: Stores.list_stores())}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.PageView, "index.html", assigns)
  end
end
