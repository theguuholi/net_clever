defmodule NetCleverWeb.StoreLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "check if store exist", %{conn: conn} do
    {:ok, store} = NetClever.StoresFixtures.create_store()

    {:ok, view, _html} = live(conn, "/maps")

    assert has_element?(view, "#store-#{store.id}")
  end
end
