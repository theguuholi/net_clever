defmodule NetCleverWeb.Stores.StoreLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "test store" do
    setup :register_and_log_in_user

    test "check if store exist", %{conn: conn} do
      {:ok, store} = NetClever.StoresFixtures.create_store()

      {:ok, view, _html} = live(conn, "/stores")

      assert has_element?(view, "##{store.id}")
    end
  end
end
