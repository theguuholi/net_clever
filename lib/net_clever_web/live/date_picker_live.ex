defmodule NetCleverWeb.DatePickerLive do
  use NetCleverWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: nil)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <form>
        <input id="date-picker-input" type="text"
               class="form-input" value="<%= @date %>"
               placeholder="Pick a date">
      </form>

      <%= if @date do %>
        <p class="mt-6 text-xl">
          See you on <%= @date %>!
        </p>
      <% end %>
    </div>

    <input id="date-picker-input" type="text"
              class="form-input" value="<%= @date %>"
              placeholder="Pick a date"
              phx-hook="DatePicker">
    """
  end

  def handle_event("dates-picked", date, socket) do
    {:noreply, assign(socket, date: date)}
  end
end
