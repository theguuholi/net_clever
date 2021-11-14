defmodule NetCleverWeb.Page.StoreComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.PageView, "store.html", assigns)
  end
end
