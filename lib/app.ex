defmodule App do
  use Application

  def start(_type, _args) do
    children = [
      Cache,
      CounterSupervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
