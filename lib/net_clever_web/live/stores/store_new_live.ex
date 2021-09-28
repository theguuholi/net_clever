defmodule NetCleverWeb.StoreNewLive do
  use NetCleverWeb, :live_view
  alias Ecto.Enum
  alias NetClever.Stores
  alias NetClever.Stores.Store

  @impl true
  def mount(_params, _session, socket) do
    changeset = Stores.change_store(%Store{}, %{})

    socket =
      allow_upload(socket, :photos,
        accept: ~w/.png .jpeg .jpg/,
        max_entries: 3,
        max_file_size: 10_000_000
      )

    {:ok, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(NetCleverWeb.StoreView, "new.html", assigns)
  end

  def load_categories do
    Enum.values(Store, :category)
  end

  @impl true
  def handle_event("validate", %{"store" => store}, socket) do
    changeset =
      %Store{}
      |> Store.changeset(store)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  @impl true
  def handle_event("save", %{"store" => store}, socket) do
    case Stores.create_store(store) do
      {:ok, _store} ->
        {:noreply,
         socket
         |> put_flash(:info, "Loja cadastrada")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
