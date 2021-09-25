defmodule NetCleverWeb.ChartLive do
  use NetCleverWeb, :live_view

  def mount(_p, _s, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :update)
    labels = 1..12 |> Enum.to_list()
    values = Enum.map(labels, fn _ -> get_reading() end)

    {:ok,
     assign(socket,
       chart_data: %{labels: labels, values: values},
       current_reading: List.last(labels)
     )}
  end

  defp get_reading() do
    Enum.random(70..180)
  end

  def handle_info(:update, socket) do
    {:noreply, create_point(socket)}
  end

  def render(assigns) do
    ~L"""

      <div id="charting">

      <div phx-update="ignore">
      # events with javascript update hsould be ignores
      <canvas id="chart-canvas" phx-hook="ChartTest" data-chart-data="<%= Jason.encode!(@chart_data) %>">
      </canvas>
      </div>

      <button phx-click="get-reading">
        Get Reading
      </button>

      <div>
      Total Readings: <%= @current_reading %>
      </div>
      </div>
    """
  end

  def handle_event("get-reading", _, socket) do
    socket = create_point(socket)
    {:noreply, socket}
  end

  defp create_point(socket) do
    socket = update(socket, :current_reading, &(&1 + 1))
    point = %{label: socket.assigns.current_reading, value: get_reading()}
    push_event(socket, "new-point", point)
  end
end
