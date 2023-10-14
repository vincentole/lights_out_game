defmodule LightsOutGameWeb.Board do
  use LightsOutGameWeb, :live_view

  def mount(_params, _session, socket) do
    grid = for x <- 0..4, y <- 0..4, into: %{}, do: {{x, y}, false}
    level_1 = %{{2, 0} => true, {2, 2} => true, {2, 4} => true}
    grid = Map.merge(grid, level_1)

    {:ok, assign(socket, grid: grid, win: false)}
  end

  def handle_event("toggle", %{"x" => strX, "y" => strY}, socket) do
    grid = socket.assigns.grid
    grid_x = String.to_integer(strX)
    grid_y = String.to_integer(strY)

    updated_grid =
      find_adjacent_tiles(grid_x, grid_y)
      |> Enum.reduce(%{}, fn point, acc -> Map.put(acc, point, !grid[point]) end)
      |> then(fn toggled_grid -> Map.merge(grid, toggled_grid) end)

    win = check_win(updated_grid)

    socket = assign(socket, grid: updated_grid, win: win)

    case win do
      true -> {:noreply, push_event(socket, "gameover", %{win: win})}
      _ -> {:noreply, socket}
    end
  end

  defp find_adjacent_tiles(x, y) do
    prev_x = Kernel.max(0, x - 1)
    next_x = Kernel.min(4, x + 1)
    prev_y = Kernel.max(0, y - 1)
    next_y = Kernel.min(4, y + 1)

    [{x, y}, {prev_x, y}, {next_x, y}, {x, prev_y}, {x, next_y}]
  end

  defp check_win(grid) do
    grid
    |> Map.values()
    |> Enum.all?(&(!&1))
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col max-w-lg mx-auto">
      <div class="grid grid-rows-5 grid-cols-5 gap-2 mb-4">
        <%= for {{x, y}, value} <- @grid do %>
          <button
            class="block h-20 px-4 py-6 text-center border rounded bg-stone-300 data-[on]:bg-red-400"
            phx-click="toggle"
            phx-value-x={x}
            phx-value-y={y}
            data-on={value}
          >
          </button>
        <% end %>
      </div>
      <p :if={@win} class="text-3xl text-center">You won!</p>
    </div>
    """
  end
end
