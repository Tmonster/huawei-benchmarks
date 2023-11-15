import pandas as pd
import matplotlib.pyplot as plt

def plot_memory_data(csv_file):
    # Read CSV file into a pandas DataFrame
    df = pd.read_csv(csv_file)

    # Convert 'time' column to datetime format for better plotting
    df['time'] = pd.to_datetime(df['time'], unit='s')

    # Plot MemAvailable, MemFree, and MemTotal values over time
    plt.figure(figsize=(12, 6))
    plt.plot(df['time'], df['MemAvailable'], label='MemAvailable')
    plt.plot(df['time'], df['MemFree'], label='MemFree')
    plt.plot(df['time'], df['MemTotal'], label='MemTotal')

    # Set labels and title
    plt.xlabel('Time')
    plt.ylabel('Memory Size (kB)')
    plt.title('Memory Usage Over Time')
    
    # Add legend
    plt.legend()

    # Show the plot
    plt.show()

# Example usage:
csv_file_path = 'graph_utils/test_meminfo.csv'
plot_memory_data(csv_file_path)