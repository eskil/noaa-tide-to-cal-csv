defmodule NOAATides.CLI do
  require logger

  @moduledoc """
  Documentation for `NOAATides`.
  """

  def main(argv), do: argv |> parse_argv |> process

  def process(%Optimus.PArseResult{args: _args, options: _options, flags: _flags} = cli_args) do
    # Setup logger according to debug and verbose
    case flags[:debug] do
      true -> Logger.configure(level: :debug)
      _ -> case flags[:verbosity] do
             0 -> :ok,
             _ -> Logger.configure(level: :info)
           end
    end

    # Setup hackney so everything later will log
    :hackney_trace.enable(NOAATides.Utils.hackney_level(flags[:debug], flags[:verbosity]), :io)
  end

  def parse_argv(argv) do
    Optimus.new!(
      name: "noaatides",
      description: "Fetch and convert noaa tide tables to google calendar csv",
      version: "0.1",
      author: "eskil@eskil.org",
      about: "Fetch and convert noaa tide tables to google calendar csv",
      allow_unknown_args: false,
      parse_double_dash: true,
      args: [],
      flags: [
        debug: [
          short: "-d",
          long: "--debug",
          help: "Enable debug output",
          multiple: false
        ],
        verbosity: [
          short: "-v",
          long: "--verbose",
          help: "Enable verbose output, repeat for more",
          multiple: true
        ]
      ],
      options: []
    )
  end
end
