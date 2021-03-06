defmodule NetClever.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias NetClever.Repo

  alias NetClever.Stores.Store

  def get_categories, do: Ecto.Enum.values(Store, :category)

  def list_stores_with_filters(criteria) when is_list(criteria) do
    query = from(s in Store)

    criteria
    |> Enum.reduce(query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query, offset: ^((page - 1) * per_page), limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]

      {:category, category}, query ->
        from q in query, where: q.category == ^category

      {:name, name}, query ->
        name = "#{name}%"
        from q in query, where: ilike(q.name, ^name)
    end)
    |> Repo.all()
  end

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

  def create_store(attrs \\ %{}, fun) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
    |> after_save(fun)
    |> broadcast(:store_created)
  end

  defp after_save({:ok, store}, fun) do
    {:ok, _store} = fun.(store)
  end

  defp after_save(error, _) do
    error
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
