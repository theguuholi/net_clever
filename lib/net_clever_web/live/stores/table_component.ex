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

end
