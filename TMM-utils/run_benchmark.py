import os
import sys
import duckdb
import argparse
from threading import Thread, current_thread


DUCKDB_DATABASE_FILE = "TMM_test.duckdb"


CREATE_DATA_QUERY = "Create table table_1 as select range a from range(20000000)"


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

def get_mem_lock_file(query_file):
    return query_file.replace('.sql', '_lock')

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

def start_polling_mem(query_file, system, benchmark_name, benchmark, run, pid):
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

            args = ['python3', 'memory_utils/poll_process_mem.py', mem_db, mem_lock_file, benchmark_name, benchmark, system, run, query, str(hyper_pid)]
            
            # Run the script using subprocess.Popen
            subprocess.run(args, check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error running script: {e}")

    create_mem_poll_lock(query_file)
    # Create a new thread and run the script inside it
    script_thread = threading.Thread(target=run_script)
    script_thread.start()

def stop_polling_mem(query_file):
    try:
        # Remove the file
        file_name = query_file.replace('.sql', '_lock')
        os.remove(file_name)
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
    except Exception as e:
        print(f"Error: {e}")

def db_exists():
	return os.path.exists(DUCKDB_DATABASE_FILE)

def create_db():
	con = duckdb.connect(DUCKDB_DATABASE_FILE)
	con.execute("create table t1 as select range a from range(1000000)")
	con.close()


# test queries when running via cursors (in python)
# test queries when running multiple connections


def execute_query_on_con(con, query):
	thread_name = str(current_thread().name)
	res = con.execute(query).fetchall()
	print(f"{thread_name} received {len(res)} results")

def get_connections(num_connections):
	connections = []
	for i in range(num_connections):
		con = duckdb.connect(DUCKDB_DATABASE_FILE, read_only=True)
		connections.append(con)
	return connections

def run_concurrent_queries(num_connections, query_file):

	query = get_query_from_file(query_file)

	connections = get_connections(num_connections)
	threads = []
	# every connection now needs to spin a new thread and run the same query
	for i in range(num_connections):
		con = connections[i]
		threads.append(Thread(target=execute_query_on_con, args=(con, query,), name=f'thread with con {i}'))

	start_polling_mem(query_file, "duckdb", benchmark_name, "tmm", "cold", os.getpid())
	for t in threads:
		t.start()

	for t in threads:
		t.join()

	stop_polling_mem()

	for con in connections:
		con.close()


def run_benchmark(num_connections, query_file_names):
	if not db_exists():
		create_db()

	for query in query_file_names:
		run_concurrent_queries(num_connections, query_file)

def parse_args():
	parser = argparse.ArgumentParser(description='Run tpch on hyper or duckdb')

	# Add command-line arguments
	parser.add_argument('--num_connections', type=int, help='Number of read connections ocnnected to duckdb')
	parser.add_argument('--benchmark', type=str, help='The benchmark you would like to run')

	# Parse the command-line arguments
	args = parser.parse_args()
	return args    


def main():
	args = parse_args()
	num_connections = args.num_connections
	benchmark = args.benchmark

	query_file_names = get_query_file_names(benchmark)

	run_benchmark(num_connections, query_file_names)


if __name__ == "__main__":
	main()