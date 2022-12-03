# Noaatides

Download a NOAA tide table and convert to CSV that can be imported
into google cal.

## Build

```
mix deps.get
mix escript.build
```

## Run

This enables debug, medium-high verbosity and fetches 2022 data.

```
./noaatides --debug -vvv --from="2022-01-01" --to="2022-12-31"
```

Note debug and vebose output from hackney mixes into stdout, so disable that.

## Use

Here's an example for just 2 days

```
$ mix escript.build && ./noaatides --from="2022-12-01" --to="2022-12-02" 2> /dev/null
Generated escript noaatides with MIX_ENV=dev
Subject,Start Date,Start Time,End Date,End Time,Description,Location,Private
High Tide: 5.48 feet,2022/12/01,06:33,2022/12/01,06:33,San Francisco CA,"High Tide: 5.48 feet from station 9414290 in San Francisco CA"
Low Tide: 2.07 feet,2022/12/01,12:28,2022/12/01,12:28,San Francisco CA,"Low Tide: 2.07 feet from station 9414290 in San Francisco CA"
High Tide: 4.5 feet,2022/12/01,18:03,2022/12/01,18:03,San Francisco CA,"High Tide: 4.5 feet from station 9414290 in San Francisco CA"
Low Tide: 0.58 feet,2022/12/02,00:10,2022/12/02,00:10,San Francisco CA,"Low Tide: 0.58 feet from station 9414290 in San Francisco CA"
High Tide: 5.78 feet,2022/12/02,07:16,2022/12/02,07:16,San Francisco CA,"High Tide: 5.78 feet from station 9414290 in San Francisco CA"
Low Tide: 1.33 feet,2022/12/02,13:32,2022/12/02,13:32,San Francisco CA,"Low Tide: 1.33 feet from station 9414290 in San Francisco CA"
High Tide: 4.35 feet,2022/12/02,19:26,2022/12/02,19:26,San Francisco CA,"High Tide: 4.35 feet from station 9414290 in San Francisco CA"
```

* Pipe into a file
* Goto google calendar
* Using the "+" on "Other calendars"
* Create a new calendar titled "SF Tides" or such
* Now import the CSV into the new calendar
* voila...

## Todo

* Support output file by name instead of stdout, less mess.
* Parameter for station id

## Resources

This uses a [cgibin script hosted at NOAA](https://tidesandcurrents.noaa.gov/cgi-bin/predictiondownload.cgi?&stnid=9414290&threshold=&thresholdDirection=&bdate=20220101&edate=20220131&units=standard&timezone=LST/LDT&datum=MLLW&interval=hilo&clock=12hour&type=txt&annual=false).

You can find station ids [here](https://tidesandcurrents.noaa.gov/tide_predictions.html)