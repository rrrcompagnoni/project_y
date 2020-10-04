import Config

config :logger,
  level: :warn

config :project_y,
  http_port: 4001

config :libcluster,
  topologies: []

config :plug, :validate_header_keys_during_test, true
