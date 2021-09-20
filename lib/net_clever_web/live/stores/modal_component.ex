defmodule NetCleverWeb.Stores.ModalComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "modal.html", assigns)
  end

end
