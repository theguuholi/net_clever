defmodule NetCleverWeb.PageLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    NetClever.StoresFixtures.create_store()
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Lagoinha"
    assert render(page_live) =~ "Lagoinha"
  end
end
