defmodule NetClever.StoresTest do
  use NetClever.DataCase

  alias NetClever.Stores

  describe "stores" do
    alias NetClever.Stores.Store

    @valid_attrs %{
      description: "some description",
      lat: 120.5,
      lng: 120.5,
      name: "some name",
      phone: "some phone",
      photos_url: []
    }
    @update_attrs %{
      description: "some updated description",
      lat: 456.7,
      lng: 456.7,
      name: "some updated name",
      phone: "some updated phone",
      photos_url: []
    }
    @invalid_attrs %{description: nil, lat: nil, lng: nil, name: nil, phone: nil, photos_url: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stores.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Stores.list_stores() == [store]
    end
    test "list_suggest_stores_by_name/1 returns all stores" do
      store_fixture()
      assert Stores.list_suggest_stores_by_name("so") == ["some name"]
    end

    test "list_stores_with_filters/0 returns all stores" do
      store = store_fixture()

      assert Stores.list_stores_with_filters(
               paginate: %{page: 1, per_page: 3},
               sort: %{sort_by: :name, sort_order: :asc},
               category: "comercio",
               name: "some"
             ) == [store]
    end

    test "get_active_store_numbers!/1 return active stores" do
      store_fixture()
      assert Stores.get_active_store_numbers(true) == 0
    end

    test "get_categories/0" do
      assert Stores.get_categories() == [
               :comercio,
               :alimenticio,
               :acougue,
               :vestuario,
               :marketing,
               :estetica
             ]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Stores.get_store!(store.id) == store
      assert Stores.get_store(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Stores.create_store(@valid_attrs)
      assert store.description == "some description"
      assert store.lat == 120.5
      assert store.lng == 120.5
      assert store.name == "some name"
      assert store.phone == "some phone"
      assert store.photos_url == []
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stores.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, %Store{} = store} = Stores.update_store(store, @update_attrs)
      assert store.description == "some updated description"
      assert store.lat == 456.7
      assert store.lng == 456.7
      assert store.name == "some updated name"
      assert store.phone == "some updated phone"
      assert store.photos_url == []
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Stores.update_store(store, @invalid_attrs)
      assert store == Stores.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Stores.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Stores.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Stores.change_store(store)
    end
  end
end
