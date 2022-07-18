# defmodule CounterSupervisor do
#   use Supervisor

#   def start_link(args) do
#     Supervisor.start_link(__MODULE__, args)
#   end

#   def init(initial_args) do
#     childrens = [
#       Cache,
#       {Counter, initial_args}
#     ]

#     Supervisor.init(childrens, strategy: :one_for_one)
#   end
# end

defmodule CounterSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(count, name) do
    DynamicSupervisor.start_child(__MODULE__, {Counter, count: count, name: name})
  end
end
