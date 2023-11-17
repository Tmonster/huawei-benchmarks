import pandas as pd
import matplotlib.pyplot as plt

def plot_memory_data(benchmark_name):
    # Read CSV file into a pandas DataFrame
    for i in range(22):
        query_num = i+1
        zfilled = 'q' + str(query_num).zfill(2)
        hyper_mem_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_hyper_mem_usage.csv", index_col=False)
        duckdb_mem_df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_duckdb_mem_usage.csv", index_col=False)

        if len(hyper_mem_df) < 6 && len(duckdb_mem_df) < 6:
            print(f"Query {query_num} ran for less than 5 seconds on hyper and duckdb. Skipping plot")
            continue

        hyper_mem_df["normalized-time"] = hyper_mem_df["Time"] - hyper_mem_df["Time"].min()
        duckdb_mem_df["normalized-time"] = duckdb_mem_df["Time"] - duckdb_mem_df["Time"].min()

        plt.figure(figsize=(12, 6))
        plt.plot(hyper_mem_df['normalized-time'], ((hyper_mem_df['MemTotal'] - hyper_mem_df['MemAvailable']) / 1000000), label='Hyper Memory')
        plt.plot(duckdb_mem_df['normalized-time'], ((duckdb_mem_df['MemTotal'] - duckdb_mem_df['MemAvailable']) / 1000000), label='DuckDB Memory')

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

    # Plot MemAvailable, MemFree, and MemTotal values over time
    

# Example usage:
benchmark_name = "throw-away"
plot_memory_data(benchmark_name)