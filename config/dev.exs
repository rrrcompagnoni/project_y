import Config

config :project_y,
  http_port: String.to_integer(System.get_env("HTTP_PORT", "4000"))

config :libcluster,
  topologies: [
    project_y_cluster: [
      strategy: Cluster.Strategy.Epmd,
      config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1", :"c@127.0.0.1", :"d@127.0.0.1"]],
      connect: {:net_kernel, :connect_node, []},
      disconnect: {:erlang, :disconnect_node, []},
      list_nodes: {:erlang, :nodes, [:connected]}
    ]
  ]
