import pandas as pd
import matplotlib.pyplot as plt

def plot_memory_data(csv_file):
    # Read CSV file into a pandas DataFrame
    df = pd.read_csv(csv_file, index_col=False)

    # Convert 'time' column to datetime format for better plotting
    df['Time'] = df['Time']

    # Plot MemAvailable, MemFree, and MemTotal values over time
    plt.figure(figsize=(12, 6))
    plt.plot(df['Time'], (df['MemAvailable'] / 1000000), label='MemAvailable')
    plt.plot(df['Time'], ((df['MemTotal'] - df['MemFree']) / 1000000), label='MemUsed')

    # Set labels and title
    plt.xlabel('Time')
    plt.ylabel('Memory Size (GB)')
    plt.title('Memory Usage Over Time')
    
    # Add legend
    plt.legend()

    # Show the plot
    plt.show()

# Example usage:
csv_file_path = 'benchmarks/test-benchmark/q21.csv'
plot_memory_data(csv_file_path)