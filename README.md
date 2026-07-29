# dwc-dp-analyser Homebrew tap

Homebrew tap for [`dwc-dp-analyser`](https://github.com/gbif/dwc-dp-analyser), a validator and
analysis CLI for [Darwin Core Data Packages (DwC-DP)](https://rs.tdwg.org/dwc-dp/), built on
[Frictionless Data Package v1](https://specs.frictionlessdata.io/) and [DuckDB](https://duckdb.org/).

It runs a data package through several layers of checks — structural validation, DwC-DP profile
and table schema conformance, EML metadata, and DuckDB-backed data analysis (foreign keys, primary
key uniqueness, field type checks, column statistics) — and reports the results as text or JSON.

See the [main repository](https://github.com/gbif/dwc-dp-analyser) for full documentation,
architecture notes, and source.

## Installation

```bash
brew install wisienkas/dwc-dp-analyser/dwc-dp-analyser
```

Installing by this fully-qualified name automatically trusts just this formula — no extra step
needed.

If you'd rather tap first and install by short name, Homebrew (6.0+) requires third-party taps to
be explicitly trusted before it will run their formula code:

```bash
brew tap wisienkas/dwc-dp-analyser
brew trust --formula wisienkas/dwc-dp-analyser/dwc-dp-analyser
brew install dwc-dp-analyser
```

(`brew trust wisienkas/dwc-dp-analyser` trusts the whole tap instead, if you'd prefer — only
worth it if you're comfortable trusting anything we add here in the future too.)

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "wisienkas/dwc-dp-analyser", trusted: true
brew "dwc-dp-analyser"
```

Shell completions for bash and zsh are installed automatically alongside the formula.

## Usage

```bash
dwc-dp-analyser /path/to/datapackage.json
```

```
Usage: dwc-dp-analyser [-hV] [--quiet] [--verbose] [--duckdb-max-temp=<duckdbMaxTemp>]
           [--duckdb-memory=<duckdbMemory>] [--duckdb-temp-dir=<duckdbTempDir>]
           [--duckdb-threads=<duckdbThreads>] [--duckdb-url=<duckdbUrl>]
           [--log-dir=<logDir>] [--output-format=<outputFormat>]
           [--report=<reportMode>] <descriptorPath>
      <descriptorPath>     Path to datapackage.json
      --duckdb-max-temp=<duckdbMaxTemp>
                           DuckDB max temp size
      --duckdb-memory=<duckdbMemory>
                           DuckDB memory limit
      --duckdb-temp-dir=<duckdbTempDir>
                           DuckDB temp directory
      --duckdb-threads=<duckdbThreads>
                           DuckDB threads
      --duckdb-url=<duckdbUrl>
                           DuckDB JDBC URL
  -h, --help               Show this help message and exit.
      --log-dir=<logDir>   Directory for logs
      --output-format=<outputFormat>
                           Output format: TEXT or JSON
      --quiet              Only show errors
      --report=<reportMode>
                           Report sections: FULL, STATS, VERIFY
  -V, --version            Print version information and exit.
      --verbose            Enable debug logging
```

### Examples

```bash
# Full validation and statistics, text output (default)
dwc-dp-analyser /path/to/datapackage.json

# JSON output
dwc-dp-analyser /path/to/datapackage.json --output-format JSON

# Verification only (no statistics)
dwc-dp-analyser /path/to/datapackage.json --report VERIFY

# Statistics only
dwc-dp-analyser /path/to/datapackage.json --report STATS

# Large datasets — increase memory and spill to disk
mkdir -p /tmp/duckdb
dwc-dp-analyser /path/to/datapackage.json \
  --duckdb-memory 4GB \
  --duckdb-temp-dir /tmp/duckdb \
  --duckdb-max-temp 20GB
```

> **Note:** DuckDB memory is controlled entirely by `--duckdb-memory` — JVM heap flags have no
> effect on it.

### Exit codes

| Code | Meaning                             |
|------|--------------------------------------|
| `0`  | All checks passed                     |
| `1`  | Program error (bad arguments, etc.)   |
| `2`  | Validation or data violations found   |

## Documentation

`brew help`, `man brew`, or check [Homebrew's documentation](https://docs.brew.sh).