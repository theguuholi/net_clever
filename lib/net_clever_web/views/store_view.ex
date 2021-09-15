defmodule NetCleverWeb.StoreView do
  use NetCleverWeb, :view
  alias Phoenix.LiveView.Helpers

  def pagination_link(socket, text, option_page, per_page) do
    Helpers.live_patch(text, to: Routes.store_path(socket, :index, page: option_page, per_page: per_page))
  end
end
