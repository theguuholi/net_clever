defmodule NetCleverWeb.Page.StoreComponentTest do
  use NetCleverWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias NetCleverWeb.Page.StoreComponent

  test "should test a store component" do
    assigns = %{
      store: %{
        name: "Test Store Name",
        description: "Test Store Description",
        phone: "123123123",
        lat: "321",
        lng: "222"
      }
    }

    html = render_component(StoreComponent, assigns)
    assert html =~ "Test Store Name"
    assert html =~ "Test Store Description"
    assert html =~ "123123123"
  end
end
