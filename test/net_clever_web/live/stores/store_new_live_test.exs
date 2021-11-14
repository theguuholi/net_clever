defmodule NetCleverWeb.Stores.StoreNewLiveTest do
  use NetCleverWeb.ConnCase

  import Phoenix.LiveViewTest

  test "check if store exist", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, Routes.store_new_path(conn, :index))

    assert index_live
           |> form("#new-store-form", store: %{name: nil})
           |> render_change() =~ "preencher o campo acima"

    assert index_live
           |> form("#new-store-form", store: %{name: nil})
           |> render_submit()

    store = %{
      name: "Business 2",
      description: "lorem ipsum",
      lat: -22.64639202136818,
      lng: -47.24120244169937,
      phone: "5519974039477"
    }

    upload =
      file_input(index_live, "#new-store-form", :photos, [
        %{
          last_modified: 1_594_171_879_000,
          name: "text.jpeg",
          content: " ",
          type: "image/jpeg",
          size: 1_396_009
        }
      ])
    assert render_upload(upload, "text.txt") =~ "100%"

    {:ok, _, html} =
      index_live
      |> form("#new-store-form", store: store)
      |> render_submit()
      |> follow_redirect(conn, Routes.page_path(conn, :index))

    assert html =~ "Loja cadastrada"
  end
end
