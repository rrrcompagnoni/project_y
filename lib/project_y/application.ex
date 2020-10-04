defmodule ProjectY.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor,
       [Application.get_env(:libcluster, :topologies), [name: ProjectY.ClusterSupervisor]]},
      {DynamicSupervisor, strategy: :one_for_one, name: ProjectY.Supervisors.DecodeSession},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ProjectYWeb.Endpoint,
        options: [port: Application.get_env(:project_y, :http_port)]
      )
    ]

    opts = [strategy: :one_for_one, name: ProjectY.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
