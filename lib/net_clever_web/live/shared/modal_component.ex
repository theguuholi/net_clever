defmodule NetCleverWeb.Shared.ModalComponent do
  use NetCleverWeb, :live_component

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.SharedView, "modal.html", assigns)
  end
end
