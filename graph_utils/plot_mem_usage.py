import pandas as pd
import matplotlib.pyplot as plt

def plot_memory_data(benchmark_name):
    # Read CSV file into a pandas DataFrame
    for i in range(22):
        query_num = i+1
        zfilled = 'q' + str(query_num).zfill(2)
        df = pd.read_csv(f"benchmarks/{benchmark_name}/{zfilled}_mem_usage.csv", index_col=False)

        if len(df) < 6:
            print(f"Query {query_num} ran for less than 5 seconds. Skipping plot")
            continue

        df["normalized-time"] = df["Time"] - df["Time"].min()

        plt.figure(figsize=(12, 6))
        plt.plot(df['normalized-time'], ((df['MemTotal'] - df['MemAvailable']) / 1000000), label='MemUsed')

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



 # Convert 'time' column to datetime format for better plotting
    # df['Time'] = df['Time']

    # fig, axes = plt.subplots(nrows=6, ncols=1, figsize=(12,10))
    # fig.suptitle('Memory usage over time', fontsize=16)

    # for i, ax in enumerate(axes.flatten()):
    #     mem_file_name = 'q' + str(i+10).zfill(2) + '_mem_usage.csv'
    #     df = pd.read_csv(f"benchmarks/{benchmark_name}/{mem_file_name}", index_col=False)
    #     df["MemUsed"] = ((df['MemTotal'] - df['MemFree']) / 1000000)
    #     column_name = 'q' + str(i+1).zfill(2)
    #     ax.set_xlim([df['Time'].min(), df['Time'].max()])
    #     ax.set_ylim([0, 156])
    #     ax.plot(df['Time'],  df["MemUsed"], label=column_name)