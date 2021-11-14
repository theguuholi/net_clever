defmodule NetCleverWeb.Stores.StoreLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "test store" do
    setup :register_and_log_in_user

    test "test name-search", %{conn: conn} do
      {:ok, store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      rendered =
        view
        |> form("#form-suggest-store", %{name: "kdfsjksdljk"})
        |> render_submit()

      assert rendered =~ "Loading..."
      refute has_element?(view, "#store-#{store.id}", "Lagoinha")
      send(view.pid, {:search_by_name, "Lag"})
      assert has_element?(view, "#store-#{store.id}", "Lagoinha")

      view
      |> form("#form-suggest-store", %{name: "kdfsjksdljk"})
      |> render_submit()

      assert has_element?(view, "#info-alert", "kdfsjksdljk")
    end

    test "test create store", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/stores")
      {:ok, store} = NetClever.StoresFixtures.create_store()

      send(view.pid, {:store_created, store})
      assert has_element?(view, "#info-alert", "Loja #{store.name} foi criada!")
    end

    test "test store suggestion", %{conn: conn} do
      {:ok, _store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      view
      |> form("#form-suggest-store", %{name: "Lag"})
      |> render_change()

      assert has_element?(view, "#matches", "Lagoinha")
    end

    test "check if store exist", %{conn: conn} do
      {:ok, store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      assert has_element?(view, "#store-#{store.id}")
    end

    test "should filter by category", %{conn: conn} do
      {:ok, store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      rendered =
        view
        |> element("#form-filter-by-category")
        |> render_change(%{category: "comercio"})

      assert has_element?(view, "#store-#{store.id}", "Lagoinha")
      assert rendered =~ "Lagoinha"

      rendered =
        view
        |> form("#form-filter-by-category", %{category: "acougue"})
        |> render_change()

      refute has_element?(view, "#store-#{store.id}", "Lagoinha")
      refute rendered =~ "Lagoinha"
    end

    test "should select-per-page", %{conn: conn} do
      {:ok, store_1} = NetClever.StoresFixtures.create_store()
      {:ok, store_2} = NetClever.StoresFixtures.create_store()
      {:ok, store_3} = NetClever.StoresFixtures.create_store()
      {:ok, store_4} = NetClever.StoresFixtures.create_store()
      {:ok, store_5} = NetClever.StoresFixtures.create_store()
      {:ok, store_6} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      view
      |> form("#form-select-per-page", %{"per-page": "5"})
      |> render_change()

      assert has_element?(view, "#store-#{store_1.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_2.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_3.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_4.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_5.id}", "Lagoinha")
      refute has_element?(view, "#store-#{store_6.id}", "Lagoinha")

      view
      |> form("#form-select-per-page", %{"per-page": "10"})
      |> render_change()

      assert has_element?(view, "#store-#{store_1.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_2.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_3.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_4.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_5.id}", "Lagoinha")
      assert has_element?(view, "#store-#{store_6.id}", "Lagoinha")
    end
  end
end
