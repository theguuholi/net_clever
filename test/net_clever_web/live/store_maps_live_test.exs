defmodule NetCleverWeb.StoreMapsLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "check if store exist", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    assert has_element?(view, "#select-store-#{store.id}")
  end

  test "store clicked", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    refute view |> element("#select-store-#{store.id}") |> render() =~ "active"
    render_click(view, "store-clicked", %{store_id: store.id})

    assert view |> element("#select-store-#{store.id}") |> render() =~ "active"
    # assert_patched(view, "/maps?id=#{store.id}")
  end

  test "test select store in the map", %{conn: conn} do
    [{:ok, _s1}, {:ok, s2}] = Enum.map(1..2, fn _ -> NetClever.StoresFixtures.create_store() end)
    {:ok, view, _} = live(conn, "/maps")

    refute view |> element("#select-store-#{s2.id}") |> render() =~ "active"

    view
    |> element("#map")
    |> render_hook("select-store", %{id: s2.id})

    assert view |> element("#select-store-#{s2.id}") |> render() =~ "active"
  end

  test "store created", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    refute view |> element("#select-store-#{store.id}") |> render() =~ "active"
    render_click(view, "store-clicked", %{store_id: store.id})
    assert view |> element("#select-store-#{store.id}") |> render() =~ "active"
  end

  test "handle_info/2", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/maps")
    refute view |> element("#select-store-123") |> has_element?()
    send(view.pid, {:store_created, %{id: 123, name: 123}})
    assert view |> element("#select-store-123") |> has_element?()
  end
end
