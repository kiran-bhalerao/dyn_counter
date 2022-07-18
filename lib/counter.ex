defmodule Counter do
  use GenServer

  # Public Apis
  def start_link(args) do
    count = Keyword.get(args, :count, 0)
    name = Keyword.get(args, :name)

    GenServer.start_link(__MODULE__, count, name: name)
  end

  def increment(pid) do
    GenServer.call(pid, :inc)
  end

  def decrement(pid) do
    GenServer.call(pid, :dec)
  end

  def current(pid) do
    GenServer.call(pid, :current)
  end

  def divide(pid, divisor) do
    GenServer.call(pid, {:divide, divisor})
  end

  # Private functions
  defp name() do
    {:registered_name, name} = Process.info(self(), :registered_name)
    name
  end

  # Callbacks

  def init(initial_count) do
    count =
      case Cache.lookup(name()) do
        {:ok, count} -> count
        _ -> initial_count
      end

    {:ok, count}
  end

  def terminate(_reason, count) do
    Cache.save(name(), count)
  end

  def handle_call(:inc, _from, count) do
    updated_count = count + 1
    {:reply, updated_count, updated_count}
  end

  def handle_call(:dec, _from, count) do
    updated_count = count - 1
    {:reply, updated_count, updated_count}
  end

  def handle_call(:current, _from, count) do
    {:reply, count, count}
  end

  def handle_call({:divide, divisor}, _from, count) do
    {:reply, div(count, divisor), count}
  end
end
