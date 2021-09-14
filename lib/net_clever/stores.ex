defmodule NetClever.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias NetClever.Repo

  alias NetClever.Stores.Store

  def list_stores do
    Repo.all(Store)
  end

  def get_active_store_numbers(active) do
    Store
    |> where([s], s.active == ^active)
    |> select([s], count(s.id))
    |> Repo.all()
    |> hd()
  end

  def list_suggest_stores_by_name(name) do
    name = "#{name}%"
    Store
    |> where([s], ilike(s.name, ^name))
    |> order_by([{:desc, :inserted_at}])
    |> select([s], s.name)
    |> Repo.all()
  end

  def list_stores_by_name(name) do
    name = "#{name}%"
    Store
    |> where([s], ilike(s.name, ^name))
    |> order_by([{:desc, :inserted_at}])
    |> Repo.all()
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

  def change_status(id) do
    store = get_store!(id)
    update_store(store, %{active: !store.active})
  end

  def update_store(%Store{} = store, attrs) do
    IO.inspect "here!!"
    store
    |> Store.changeset(attrs)
    |> Repo.update()
    |> broadcast(:store_updated)
  end

  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end
end
