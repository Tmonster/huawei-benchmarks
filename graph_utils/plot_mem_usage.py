import pandas as pd
import matplotlib.pyplot as plt
import argparse
import os

def plot_memory_data(benchmark_name):
    # Read CSV file into a pandas DataFrame
    for i in range(22):
        query_num = i+1
        zfilled = 'q' + str(query_num).zfill(2)
        hyper_cold_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_hyper_cold_mem.csv", index_col=False)
        duckdb_cold_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_duckdb_cold_mem.csv", index_col=False)
        hyper_hot_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_hyper_hot_mem.csv", index_col=False)
        duckdb_hot_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_duckdb_hot_mem.csv", index_col=False)

        if len(hyper_cold_df) < 6 and len(duckdb_cold_df) < 6:
            print(f"Query {query_num} ran for less than 5 seconds on hyper and duckdb. Skipping plot")
            continue

        hyper_cold_df["normalized-time"] = hyper_cold_df["Time"] - hyper_cold_df["Time"].min()
        hyper_hot_df["normalized-time"] = hyper_hot_df["Time"] - hyper_hot_df["Time"].min()
        duckdb_cold_df["normalized-time"] = duckdb_cold_df["Time"] - duckdb_cold_df["Time"].min()
        duckdb_hot_df["normalized-time"] = duckdb_hot_df["Time"] - duckdb_hot_df["Time"].min()

        plt.figure(figsize=(12, 6))
        plt.plot(hyper_cold_df['normalized-time'], ((hyper_cold_df['MemTotal'] - hyper_cold_df['MemAvailable']) / 1000000), label='Hyper Memory Cold')
        plt.plot(duckdb_cold_df['normalized-time'], ((duckdb_cold_df['MemTotal'] - duckdb_cold_df['MemAvailable']) / 1000000), label='DuckDB Memory Cold')
        plt.plot(hyper_hot_df['normalized-time'], ((hyper_hot_df['MemTotal'] - hyper_hot_df['MemAvailable']) / 1000000), label='Hyper Memory Hot')
        plt.plot(duckdb_hot_df['normalized-time'], ((duckdb_hot_df['MemTotal'] - duckdb_hot_df['MemAvailable']) / 1000000), label='DuckDB Memory Hot')

        # Set labels and title
        plt.xlabel('Time')
        plt.ylabel(f"Memory Usage {zfilled} (GB)")
        plt.title('Memory Usage Over Time')
        
        # Add legend
        plt.legend()

        print(f"Saving plot for query {query_num}.")
        # Save the plot
        plt.savefig(f"benchmarks/{benchmark_name}/{zfilled}_plot")
        plt.clf()


def plot_graphs():
    parser = argparse.ArgumentParser(description='Plot memory usage of Tpch results over time')

    parser.add_argument('--benchmark', type=str, help='Specify the benchmark name. Memory files are stored in this directory')

    args = parser.parse_args()

    benchmark_name = args.benchmark

    if not os.path.isdir(benchmark_name):
        print("Usage: python3 utils/plot_mem_usage.py --benchmark=[name]")

    plot_memory_data(benchmark_name)


if __name__ == "__main__":
    plot_graphs()

    