import os
import duckdb
import threading
import subprocess
import argparse
import time
import duckdb
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode


TPCH_DATABASE = "tpch-sf100.duckdb"
HYPER_DATABASE = "hyper-sf100.hyper"


def get_mem_lock_file(query_file):
    return query_file.replace('.sql', '_lock')

def get_mem_usage_db_file(benchmark_name, benchmark):
    return benchmark_name + "/" + benchmark + "/data.duckdb"

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
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
    except Exception as e:
        print(f"Error: {e}")

def start_polling_mem(query_file, system, benchmark_name, benchmark, run):
    def run_script():
        try:
            mem_db = get_mem_usage_db_file(benchmark_name, benchmark)

            if not os.path.exists(benchmark_name + "/" + benchmark):
                os.makedirs(f"{benchmark_name}/{benchmark}")

            # create db if it does not yet exist.
            if not os.path.exists(mem_db):
                con = duckdb.connect(mem_db)
                with open('utils/data_schema.sql') as f: schema = f.read()
                con.sql(f"{schema}")
                con.close()

            query = query_file.replace('.sql', '')
            mem_lock_file = get_mem_lock_file(query_file)
            args = ['python3', 'utils/poll_memory.py', mem_db, mem_lock_file, benchmark_name, benchmark, system, run, query]
            
            # Run the script using subprocess.Popen
            subprocess.run(args, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running script: {e}")

    create_mem_poll_lock(query_file)
    # Create a new thread and run the script inside it
    script_thread = threading.Thread(target=run_script)
    script_thread.start()

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


def run_query(query_file, system, benchmark_name, benchmark):
    if system == "duckdb":
        run_duckdb_hot_cold(query_file, benchmark_name, benchmark)
    elif system == "hyper":
        run_hyper_hot_cold(query_file, benchmark_name, benchmark)
    else:
        print("System must be hyper or duckdb")
        exit(1)

def run_duckdb_hot_cold(query_file, benchmark_name, benchmark):
    for run in ["cold", "hot"]:
        print(f"{run} run")
        try:
            connection = duckdb.connect(TPCH_DATABASE)

            query = get_query_from_file(f"benchmark-queries/{benchmark}-queries/{query_file}")

            # Create a cursor to execute SQL queries
            cursor = connection.cursor()
            start_polling_mem(query_file, "duckdb", benchmark_name, benchmark, run)
            # Execute the query
            cursor.execute(query)
            
            # stop polling memory
            stop_polling_mem(query_file)

            # Fetch the result
            result = cursor.fetchall()
        except Exception as e:
            print(f"Error: {e}")
        finally:
            connection.close()
        print(f"done.")
        time.sleep(5)

def run_hyper_hot_cold(query_file, benchmark_name, benchmark):
    db_path = f"{HYPER_DATABASE}"
    process_parameters = {"default_database_version": "2"}
    query = get_query_from_file(f"{benchmark}/{query_file}")
    for run in ["cold", "hot"]:
        print(f"{run} run")
        with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=process_parameters) as hyper:
            with Connection(hyper.endpoint, db_path, CreateMode.CREATE_IF_NOT_EXISTS) as con:
                start_polling_mem(query_file, "hyper", benchmark_name, benchmark, run)
                with con.execute_query(query) as results:
                    rows = list(results)
                stop_polling_mem(query_file)
        print(f"done.")
        time.sleep(5)

def profile_query_mem(query_file, systems, benchmark_name, benchmark):
    for system in systems:
        print(f"profiling memory for {system}. query {query_file}")
        run_query(query_file, system, benchmark_name, benchmark)
        print(f"done profiling")

def get_query_file_names(benchmark):
    # Get the absolute path to the specified directory
    directory_path = os.path.abspath(f"./benchmark-queries/{benchmark}-queries/")

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
    parser.add_argument('--benchmark_name', type=str, help='Specify the benchmark name. Benchmark files are stored in this directory')
    parser.add_argument('--benchmark', type=str, help='list of benchmarks to run. \'all\', \'tpch\', etc.')
    parser.add_argument('--system', type=str, help='System to benchmark. Either duckdb or hyper')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Access the values using dot notation (args.argument_name)
    benchmark_name = "benchmarks/" + args.benchmark_name
    if args.system not in ["hyper", "duckdb", "all"]:
        print("Usage: python3 utils/run_benchmark.py --benchmark_name=[name] --benchmark=[tpch|aggr-thin|aggr-wide|join] --system=[duckdb|hyper|all]")
        exit(1)

    benchmarks = args.benchmark
    benchmarks = ['join']

    systems = [args.system]
    if systems[0] == "all":
        systems = ["duckdb", "hyper"]

    if benchmark_name is None:
        # create benchmark name
        print("please pass benchmark name")
        exit(1)

    if os.path.isdir(benchmark_name):
        print(f"benchmark {benchmark_name} already exists.")
        exit(1)
    else:
        os.makedirs(benchmark_name)

    for benchmark in benchmarks:
        query_file_names = get_query_file_names(benchmark)
        import pdb
        pdb.set_trace()
        for query_file in query_file_names:
            profile_query_mem(query_file, systems, benchmark_name, benchmark)


if __name__ == "__main__":
    run_all_queries()
