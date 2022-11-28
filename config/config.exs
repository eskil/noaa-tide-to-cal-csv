import Config

config :logger, :console,
  format: "$time ($metadata)[$level] $message\n",
  metadata: [:pid, :file, :function, :line],
  device: :standard_error
