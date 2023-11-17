import os
import duckdb
import threading
import subprocess
import argparse
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode

SYSTEM_DIR = os.path.dirname(__file__)
sys.path.append(f'{SYSTEM_DIR}/..')
from util.util import *

QUERIES_DIR = "queries"
TPCH_DATABASE = "tpch-sf100.duckdb"

def create_mem_poll_lock(query_file):
    file_name = query_file.replace('.sql', '_lock')
    try:
        # Open the file in write mode, creating it if it doesn't exist
        with open(file_name, 'w'):
            pass  # No need to do anything inside the block, just want to create the file
        return
    except Exception as e:
        print(f"Error: {e}")

def stop_polling_mem(query_file):
    try:
        # Remove the file
        file_name = query_file.replace('.sql', '_lock')
        os.remove(file_name)
        print(f"File '{file_name}' removed successfully.")
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
    except Exception as e:
        print(f"Error: {e}")

def start_polling_mem(query_file, system, benchmark_name):
    def run_script():
        try:
            mem_file = benchmark_name + "/" + query_file.replace('.sql', f"_{system}_mem_usage.csv")
            mem_lock_file = query_file.replace('.sql', '_lock')
            args = ['python3', 'utils/poll_memory.py', mem_file, mem_lock_file]
            
            # Run the script using subprocess.Popen
            subprocess.run(args, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running script: {e}")

    # Create a new thread and run the script inside it
    script_thread = threading.Thread(target=run_script)
    script_thread.start()
    print("started polling /proc/meminfo")

def get_query_from_file(file_name):
    try:
        # Open the file in read mode and read the contents
        with open(file_name, 'r') as file:
            query = file.read()
            return query
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None


def run_query(query_file, system):
    if system == "duckdb":
        run_duckdb_query(query_file)
    elif system == "hyper":
        run_hyper_query(query_file)
    elif system == "all":
        run_duckdb_query(query_file)
        run_hyper_query(query_file)
    else:
        print("System must be hyper or duckdb")
        exit(1)

def run_duckdb_query(query_file):
    try:
        connection = duckdb.connect(TPCH_DATABASE)

        query = get_query_from_file(f"queries/{query_file}")

        # Create a cursor to execute SQL queries
        cursor = connection.cursor()

        # Execute the query
        cursor.execute(query)

        # Fetch and print the result
        result = cursor.fetchall()
    except Exception as e:
        print(f"Error: {e}")
    finally:
        connection.close()

def run_hyper_query(query_file):
    db_path = f"hyper/mydb"
    process_parameters = {"default_database_version": "2"}
    query = get_query_from_file(f"queries/{query_file}")
    with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, hyper_path=hyper_path, parameters=process_parameters) as hyper:
        with Connection(hyper.endpoint, db_path, CreateMode.CREATE_IF_NOT_EXISTS) as con:
            con.execute_query("""START TRANSACTION;""").close()
            con.execute_query(query).close()
            con.execute_query("""COMMIT;""").close()

def profile_query_mem(query_file, system, benchmark_name):
    create_mem_poll_lock(query_file)
    start_polling_mem(query_file, system, benchmark_name)
    run_query(query_file, system)
    stop_polling_mem(query_file)

def get_query_file_names():
    # Get the absolute path to the specified directory
    directory_path = os.path.abspath(QUERIES_DIR)

    # Initialize an empty list to store file names
    file_list = []

    try:
        # List all files in the directory
        files = os.listdir(directory_path)

        # Filter out directories, keep only files
        file_list = [file for file in files if os.path.isfile(os.path.join(directory_path, file))]
    except FileNotFoundError:
        # Handle the case where the directory does not exist
        print(f"Error: Directory '{directory_path}' not found.")

    file_list.sort()
    return file_list

def run_all_queries():
    parser = argparse.ArgumentParser(description='Run tpch on hyper or duckdb')

    # Add command-line arguments
    parser.add_argument('--benchmark', type=str, help='Specify the benchmark name. Benchmark files are stored in this directory')
    parser.add_argument('--system', type=str, help='System to benchmark. Either duckdb or hyper')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the values using dot notation (args.argument_name)
    benchmark_name = "benchmarks/" + args.benchmark
    system = args.system
    syste = "duckdb"

    if benchmark_name is None:
        # create benchmark name
        print("please pass benchmark name")
        exit(1)


    if os.path.isdir(benchmark_name):
        print(f"benchmark {benchmark_name} already exists!")
        exit(1)
    else:
        os.makedirs(benchmark_name)

    all_query_files = get_query_file_names()
    for query_file in all_query_files:
        profile_query_mem(query_file, system, benchmark_name)


if __name__ == "__main__":
    run_all_queries()
