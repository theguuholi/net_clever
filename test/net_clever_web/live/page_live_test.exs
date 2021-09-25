defmodule NetCleverWeb.PageLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    NetClever.StoresFixtures.create_store()
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Lagoinha"
    render(page_live) =~ "Lagoinha"
  end

  test "test load page", %{conn: conn} do
    Enum.map(1..30, fn _ -> NetClever.StoresFixtures.create_store() end)
    {:ok, view, _} = live(conn, "/")

    assert render(view) |> :binary.matches("Lagoinha") |> length() == 12

    view
    |> element("#store-loading")
    |> render_hook("load-stores", %{})

    assert render(view) |> :binary.matches("Lagoinha") |> length() == 21
  end
end
