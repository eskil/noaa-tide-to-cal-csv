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

* Pipe into a file
* Goto google calendar
* Using the "+" on "Other calendars"
* Create a new calendar titled "SF Tides" or such
* Now import the CSV into the new calendar
* voila...