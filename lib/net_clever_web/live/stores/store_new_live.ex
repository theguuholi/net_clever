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

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  defp create_photos_urls(socket, store) do
    consume_uploaded_entries(socket, :photos, fn meta, entry ->
      # process uploads
      # IO.inspect(meta, label: "meta")
      # IO.inspect(entry, label: "entry")
      # dest = Path.join("priv/statis/uploads", entry.uuid)
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
      # %{image_url: Routes.static_path(socket, "/uploads/#{filename(entry)}")}
    end)
    {:ok, store}
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
    # 1. Copy temp files
    # 2. Assign photos url
    # urls = create_photos_urls(socket)
    # store = Map.put(store, "photos", urls)

    {completed, []} = uploaded_entries(socket, :photos)

    urls =
      for entry <- completed do
        %{image_url: Routes.static_path(socket, "/uploads/#{filename(entry)}")}
      end
    store = Map.put(store, "photos", urls)

    case Stores.create_store(store, &create_photos_urls(socket, &1))do
      {:ok, _store} ->
        # create_photos_urls(socket, store)

        {:noreply,
         socket
         |> put_flash(:info, "Loja cadastrada")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
