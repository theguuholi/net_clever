defmodule NetCleverWeb.Stores.TableComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "table.html", assigns)
  end

end
