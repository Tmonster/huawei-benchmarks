import os
import duckdb
import threading
import subprocess

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

def start_polling_mem(query_file):
    def run_script():
        try:
            args = ['python3', 'utils/poll_memory.py', query_file.replace('.sql', '_mem_usage.csv'), query_file.replace('.sql', '_lock')]
            
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


def run_query(query_file):
    try:
        connection = duckdb.connect(TPCH_DATABASE)

        query = get_query_from_file(f"queries/{query_file}")

        # Create a cursor to execute SQL queries
        cursor = connection.cursor()

        # Execute the query
        cursor.execute(query)

        # Fetch and print the result
        result = cursor.fetchall()
        print(result)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        connection.close()

def profile_query_mem(query_file):
    create_mem_poll_lock(query_file)
    start_polling_mem(query_file)
    run_query(query_file)
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
    all_query_files = get_query_file_names()
    for query_file in all_query_files:
        profile_query_mem(query_file)


if __name__ == "__main__":
    run_all_queries()
