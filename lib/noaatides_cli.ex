defmodule NOAATides.CLI do
  require Logger
  import SweetXml

  @moduledoc """
  """

  def main(argv), do: argv |> parse_argv |> process

  def hl_to_string(hl) when hl == 'H', do: "high"
  def hl_to_string(hl) when hl == 'L', do: "low"

  def process(%Optimus.ParseResult{args: _args, options: options, flags: flags} = cli_args) do
    # Setup logger according to debug and verbose
    case flags[:debug] do
      true -> Logger.configure(level: :debug)
      _ -> case flags[:verbosity] do
             0 -> :ok
             1 -> Logger.configure(level: :warning)
             2 -> Logger.configure(level: :notice)
             3 -> Logger.configure(level: :info)
             _ -> Logger.configure(level: :debug)
           end
    end

    # Setup hackney so everything later will log
    :hackney_trace.enable(NOAATides.Utils.hackney_level(flags[:debug], flags[:verbosity]), :io)

    Logger.info("Configuration: #{inspect cli_args}")

    for pid <- Process.list, do: Logger.debug("process: #{inspect {pid, Process.info(pid, :registered_name)}}")

    doc = NOOATides.Client.retrying_query(options[:from_date], options[:to_date])

    location =
      Enum.at(doc
      |> SweetXml.xpath(~x"."l,
        stationname: ~x"./stationname/text()",
        state: ~x"./state/text()",
        stationid: ~x"./stationid/text()"
        ), 0)

    items =
      doc
      |> SweetXml.xpath(
        ~x"//item"l,
        date: ~x"./date/text()",
        time: ~x"./time/text()",
        pred: ~x"./pred/text()"f,
        highlow: ~x"./highlow/text()"
      )

    IO.puts("Subject,Start Date,Start Time,End Date,End Time,Description,Location,Private")
    for item <- items do
      hl = hl_to_string(item[:highlow]) |> String.capitalize
      IO.puts("#{hl} Tide: #{item[:pred]} feet,#{item[:date]},#{item[:time]},#{item[:date]},#{item[:time]},#{location[:stationname]} #{location[:state]},\"#{hl} Tide: #{item[:pred]} feet from station #{location[:stationid]} in #{location[:stationname]} #{location[:state]}\"")
    end
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
      options: [
        from_date: [
          value_name: "FROM_DATE",
          short: "-f",
          long: "--from",
          help: "Download tides from this date",
          parser: fn(s) ->
            case Date.from_iso8601(s) do
              {:error, _} -> {:error, "invalid 'from' date"}
              {:ok, _} = ok -> ok
            end
          end,
          required: true
        ],
        to_date: [
          value_name: "TO_DATE",
          short: "-t",
          long: "--to",
          help: "Download tides to this date",
          parser: fn(s) ->
            case Date.from_iso8601(s) do
              {:error, _} -> {:error, "invalid 'to' date"}
              {:ok, _} = ok -> ok
            end
          end,
          required: true
        ]
      ]
    )
    |> Optimus.parse!(argv)
  end
end
