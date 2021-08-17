defmodule NetCleverWeb.StoreMapsLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "check if store exist", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    assert has_element?(view, "#store-#{store.id}")
  end

  test "store clicked", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    refute view |> element("#store-#{store.id}") |> render() =~ "active"
    render_click(view, "store-clicked", %{store_id: store.id})
    assert view |> element("#store-#{store.id}") |> render() =~ "active"
  end

  test "store created", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    refute view |> element("#store-#{store.id}") |> render() =~ "active"
    render_click(view, "store-clicked", %{store_id: store.id})
    assert view |> element("#store-#{store.id}") |> render() =~ "active"
  end

  test "handle_info/2", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/maps")
    refute view |> element("#store-123") |> has_element?()
    send(view.pid, {:store_created, %{id: 123, name: 123}})
    assert view |> element("#store-123") |> has_element?()
  end
end
