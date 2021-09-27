defmodule NetCleverWeb.Stores.NewStoreComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "new-store.html", assigns)
  end

end
