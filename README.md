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