import Config

config :swarm,
  distribution_strategy: Swarm.Distribution.StaticQuorumRing,
  static_quorum_size: 5

import_config "#{Mix.env()}.exs"
