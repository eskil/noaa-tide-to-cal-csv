defmodule NOOATides.Client do
  require Logger

  @moduledoc """
  Client for fetching NOAA tide tables
  """

  def build_url(from_date, to_date, station_id) do
    %URI{
      scheme: "https",
      host: "tidesandcurrents.noaa.gov",
      path: "/cgi-bin/predictiondownload.cgi"
    }
    |> URI.append_query(URI.encode_query(stnid: station_id))
    |> URI.append_query(URI.encode_query(threshold: ""))
    |> URI.append_query(URI.encode_query(thresholdDirection: ""))
    |> URI.append_query(URI.encode_query(bdate: Calendar.strftime(from_date, "%Y%m%d")))
    |> URI.append_query(URI.encode_query(edate: Calendar.strftime(to_date, "%Y%m%d")))
    |> URI.append_query(URI.encode_query(units: "standard"))
    |> URI.append_query(URI.encode_query(timezone: "LST/LDT"))
    |> URI.append_query(URI.encode_query(datum: "MLLW"))
    |> URI.append_query(URI.encode_query(interval: "hilo"))
    |> URI.append_query(URI.encode_query(clock: "24hour"))
    |> URI.append_query(URI.encode_query(type: "xml")) # or txt and parse?
    |> URI.append_query(URI.encode_query(annual: "false"))
    |> URI.to_string
  end

  def query(from_date, to_date) do
    headers = %{}
    url = build_url(from_date, to_date, 9414290)
    options = [
      timeout: 10_000,
      recv_timeout: 10_000,
      follow_redirect: true,
    ]
    Logger.debug("url = #{url}")
    case HTTPoison.get(url, headers, options) do
      {:ok, %{body: raw, status_code: code}} ->
        Logger.warn("query success: #{code}")
        raw
      {:error, %{reason: reason}} ->
        Logger.warn("query error: #{reason}")
        {:error, reason}
    end
  end

  def retrying_query(from_date, to_date, retries \\ 3, reason \\ nil)

  def retrying_query(_from_date, _to_date, 0, reason) do
    Logger.warn("out of retries, last reason: #{inspect reason}")
    {:error, reason}
  end

  def retrying_query(from_date, to_date, retries, _reason) do
    Logger.info("trying query from #{inspect from_date} to #{inspect to_date}, retries=#{retries}")
    case query(from_date, to_date) do
      {:error, reason} ->
        Logger.warn("query from #{inspect from_date} to #{inspect to_date}, failed, reason=#{reason}")
        Process.sleep(1000)
        retrying_query(from_date, to_date, retries-1, reason)
      result -> result
    end
  end
end
