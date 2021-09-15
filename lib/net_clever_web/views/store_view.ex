defmodule NetCleverWeb.StoreView do
  use NetCleverWeb, :view
  alias Phoenix.LiveView.Helpers

  def pagination_link(socket, text, option_page, options) do
    Helpers.live_patch(text,
      to:
        Routes.store_path(socket, :index,
          page: option_page,
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        )
    )
  end

  def sort_link(socket, text, field, options) do
    text =
      if field == options.sort_by do
        text <> emoji(options.sort_order)
      else
        text
      end

    Helpers.live_patch(text,
      to:
        Routes.store_path(socket, :index,
          sort_by: field,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  @spec toggle_sort_order(:asc | :desc) :: :asc | :desc
  def toggle_sort_order(:asc), do: :desc
  def toggle_sort_order(:desc), do: :asc
  def emoji(:asc), do: "👆"
  def emoji(:desc), do: "👇"
end
