# Overview

Benchmark repo to keep track of progress on memory pressure. 

## Dependencies

With pip you can install the dependencies

```
python3 -m pip install -r dependencies.txt
```
You can also install duckdb for the command line https://duckdb.org/docs/installation/?version=latest&environment=cli&installer=binary&platform=macos

## Creating the data 
Then you can create the data with the following commands
```
~/memory-pressure-benchmarks$	duckdb tpch-sf100.duckdb -c "install httpfs; load httpfs; call dbgen(sf=100);"
~/memory-pressure-benchmarks$	duckdb tpch-sf100.duckdb -c "export database 'tpch_data' (FORMAT CSV, HEADER 1);"
~/memory-pressure-benchmarks$	python3 hyper/load.py
```


## Running the benchmark
Give the benchmark a name. The name defines a directory in the benchmarks directory where the data is stored.
If you are running the benchmark on AWS, see if you can use instance storage to reduce variability introduced by EBS. This can be done by running the command below
```
./utils/format_and_mount.sh
```
This will format and mount a copy of the benchmarks at `~/memory-pressure-benchmarks-metal` on instance storage. Change into this directory when running the benchmarks

To run the benchmark
```
python3 utils/run_benchmark.py --benchmark_name={benchmark_name} --benchmark={benchmark} --system=all
```

example
```
python3 utils/run_benchmark.py --benchmark_name=jan-1-duckdb-dev --benchmark=tpch --system=duckdb
```


## Summary

With this command you can plot the summary of the benchmark.
```
Rscript graph_utils/plot_summary.R {benchmark_name}
```
