defmodule NetCleverWeb.Stores.StoreRowTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "test store row" do
    setup :register_and_log_in_user

    test "set active or inactive", %{conn: conn} do
      {:ok, store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")
      assert view |> element("#store-#{store.id}-change-visibility") |> render() =~ "Ativo"
      view |> element("#store-#{store.id}-change-visibility") |> render_click()
      assert view |> element("#store-#{store.id}-change-visibility") |> render() =~ "Inativo"
    end
  end
end
