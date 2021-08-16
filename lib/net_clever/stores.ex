defmodule NetClever.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias NetClever.Repo

  alias NetClever.Stores.Store

  def list_stores() do
    Repo.all(Store)
  end

  def list_stores(page: page, per_page: per_page) do
    Store
    |> offset(^((page - 1) * per_page))
    |> limit(^per_page)
    |> where([s], s.active == true)
    |> order_by([{:desc, :inserted_at}])
    |> Repo.all()
  end

  def get_store!(id), do: Repo.get!(Store, id)
  def get_store(id), do: Repo.get(Store, id)

  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:store_created)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(NetClever.PubSub, "stores")
  end

  def broadcast({:error, _} = error, _event), do: error

  def broadcast({:ok, store}, event) do
    Phoenix.PubSub.broadcast(NetClever.PubSub, "stores", {event, store})
    {:ok, store}
  end

  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end
end
