import os
import psutil
import duckdb
import threading
import subprocess
import argparse
import time
import duckdb
import glob
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode
from duckdb_thread import duckdb_thread


TPCH_DATABASE = "tpch-sf100.duckdb"
TMM_DATABASE = "tmm.duckdb"
HYPER_DATABASE = "tpch-sf100.hyper"

VALID_SYSTEMS = ['duckdb', 'hyper']

DROP_ANSWER_SQL = "Drop table if exists ans;"

HYPER_FAILING_OPERATOR_QUERIES = [
'aggr-l_orderkey-l_partkey.sql',
'aggr-l_orderkey-l_suppkey.sql',
'aggr-l_suppkey-l_partkey-l_orderkey.sql',
'aggr-l_suppkey-l_partkey-l_shipinstruct.sql',
'aggr-l_suppkey-l_partkey-l_returnflag-l_linestatus.sql',
'aggr-l_suppkey-l_partkey-l_shipinstruct-l_shipmode.sql',
'aggr-l_suppkey-l_partkey-l_shipmode.sql',
'hash-join-large.sql'
]

def get_mem_lock_file(query_file):
    return query_file.replace('.sql', '_lock')

def get_mem_usage_db_file(benchmark_name, benchmark):
    return benchmark_name + "/" + benchmark + "/data.duckdb"

def create_mem_poll_lock(query_file):
    file_name = query_file.replace('.sql', '_lock')
    try:
        # Open the file in write mode, creating it if it doesn't exist
        # it is a lock file so we don't do anything once the file is created.
        with open(file_name, 'w'):
            pass
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


def start_polling_mem(query_file, system, benchmark_name, benchmark, run, hyper_pid):
    def run_script():
        try:
            mem_db = get_mem_usage_db_file(benchmark_name, benchmark)

            if not os.path.exists(benchmark_name + "/" + benchmark):
                os.makedirs(f"{benchmark_name}/{benchmark}")

            # create db if it does not yet exist.
            if not os.path.exists(mem_db):
                con = duckdb.connect(mem_db)
                with open('memory_utils/data_schema.sql') as f: schema = f.read()
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


def run_query(query_file, system, benchmark, config):
    if query_file in HYPER_FAILING_OPERATOR_QUERIES:
        print(f"hyper fails, skipping query")
        return
    
    if system == "duckdb":
        run_duckdb_hot_cold(query_file, benchmark, config)
    elif system == "hyper":
        run_hyper_hot_cold(query_file, benchmark, config)
    else:
        print("System must be hyper or duckdb")
        exit(1)

def set_duckdb_memory_limit(connections, memory_limit):
    if memory_limit > 0:
        for con in connections:
            memory_limit_str = f"'{memory_limit}GB'"
            con.sql(f"SET memory_limit={memory_limit_str}")

def execute_query_on_con(con, query):
    thread_name = str(threading.current_thread().name)
    res = con.sql(query).execute()
    print(f"{thread_name} done")

def run_duckdb_hot_cold(query_file, benchmark, config):
    for concurrent_connections in config.connections_list:
        try:

            # setup connections here.
            connections = []
            db_file = TMM_DATABASE if benchmark == "tmm" else TPCH_DATABASE
            read_only = benchmark == "tmm"
            if not os.path.isfile(db_file):
                print(f"Could not find database file {db_file}. Please create the database file")

            for i in range(concurrent_connections):
                con = duckdb.connect(db_file, read_only=read_only)
                connections.append(con)

            # set memory limit for the connections

            set_duckdb_memory_limit(connections, config.memory_limit)
            
            query = get_query_from_file(f"benchmark-queries/{benchmark}-queries/{query_file}")
            pid = os.getpid()

            for run in ["cold", "hot"]:
                print(f"{run} run")

                if benchmark == 'operators' and query_file.find("join") >= 1:
                    for con in connections:
                        con.sql(DROP_ANSWER_SQL)
                        time.sleep(3)

                # Create Threads
                threads = []
                for i in range(concurrent_connections):
                    con = connections[i]
                    threads.append(threading.Thread(target=execute_query_on_con, args=(con, query,), name=f'thread with con {i}'))


                query_file_for_memory_polling = query_file
                query_file_for_memory_polling = query_file_for_memory_polling.replace(".sql", "")
                query_file_for_memory_polling += f"_{str(concurrent_connections).zfill(2)}_connections"
                start_polling_mem(query_file_for_memory_polling, "duckdb", config.benchmark_name, benchmark, run, pid)

                # Start threads
                for t in threads:
                    t.start()

                # stop Threads
                for t in threads:
                    t.join()

                # stop polling memory
                stop_polling_mem(query_file_for_memory_polling)
                
                time.sleep(4)

            if benchmark == 'operators' and query_file.find("join") >= 1:
                for con in connections:
                    con.sql(DROP_ANSWER_SQL)
                    time.sleep(3)
            
        except Exception as e:
            print(f"Error: {e}")
        finally:
            for con in connections:
                con.close()
        print(f"done.")
        time.sleep(5)

def run_hyper_hot_cold(query_file, benchmark, config):
    db_path = f"{HYPER_DATABASE}"

    memory_limit_str = f"{config.memory_limit}g"
    if config.memory_limit == 0:
        # default value as quoted here https://help.tableau.com/current/server/en-us/cli_configuration-set_tsm.htm?_gl=1*1lb2mz5*_ga*NjExMDIxMzgzLjE3MDAyMjE1Mjc.*_ga_8YLN0SNXVS*MTcwNDgwMTAwNC40LjEuMTcwNDgwMjE1OC4wLjAuMA
        memory_limit_str = "80%"

    process_parameters = {"default_database_version": "2", "memory_limit": memory_limit_str}
    query = get_query_from_file(f"benchmark-queries/{benchmark}-queries/{query_file}")
    with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=process_parameters) as hyper:
        with Connection(hyper.endpoint, db_path, CreateMode.CREATE_IF_NOT_EXISTS) as con:
            current_process = psutil.Process()
            children = current_process.children(recursive=True)
            if len(children) > 1:
                print("hyper has too many child processes. aborting")
                exit(0)

            hyper_pid = children[0].pid
                
            for run in ["cold", "hot"]:
                print(f"{run} run")
                if benchmark == 'operators':
                    con.execute_command(DROP_ANSWER_SQL)
                    time.sleep(3)
                start_polling_mem(query_file, "hyper", config.benchmark_name, benchmark, run, hyper_pid)
                res = con.execute_command(query)
                stop_polling_mem(query_file)
                time.sleep(4)
            if benchmark == 'operators':
                con.execute_command(DROP_ANSWER_SQL)
    print(f"done.")
    time.sleep(5)


def continuous_benchmark_run(query_file_names, benchmark, config):
    if benchmark == 'operators' and query_file.find("join") >= 1:
        print("Cannot run continous benchmark on operators queries")
        exit(1)
    if config.systems[0] != 'duckdb' or len(config.systems) > 1:
        print("config.systems is wrong for continuous benchmark.")
    for concurrent_connections in config.connections_list:
        try:
            # setup connections here.
            connections = []
            
            db_file = TMM_DATABASE if benchmark == "tmm" else TPCH_DATABASE

            # continuous benchmark read only is always true
            read_only = True
            if not os.path.isfile(db_file):
                print(f"Could not find database file {db_file}. Please create the database file")

            for i in range(concurrent_connections):
                con = duckdb.connect(db_file, read_only=read_only)
                connections.append(con)

            # set memory limit for the connections

            set_duckdb_memory_limit(connections, config.memory_limit)
            queries = []
            for query_file in query_file_names:
                queries.append(get_query_from_file(f"benchmark-queries/{benchmark}-queries/{query_file}"))

            pid = os.getpid()

            # Create Threads
            threads = []
            for i in range(concurrent_connections):
                con = connections[i]
                threads.append(duckdb_thread(f"thread_{i}", con, config.continuous, queries))


            query_file_for_memory_polling = config.benchmark_name + "_continuous_memory_profile.sql"
            query_file_for_memory_polling = query_file_for_memory_polling.replace(".sql", "")
            query_file_for_memory_polling += f"_{str(concurrent_connections).zfill(2)}_connections"
            # start_polling_mem(query_file_for_memory_polling, "duckdb", config.benchmark_name, benchmark, 'hot', pid)

            # Start threads
            for t in threads:
                print(f"starting thread {t.name}")
                t.start()

            time.sleep(config.continuous_time_limit)

            # stop Threads
            for t in threads:
                print(f"stopping thread {t.name}")
                t.stop()

            # join Threads
            for t in threads:
                t.join()

            # stop polling memory
            # stop_polling_mem(query_file_for_memory_polling)
            mem_db = get_mem_usage_db_file(config.benchmark_name, benchmark)

            con = duckdb.connect(mem_db)
            table_name = f"thread_performance_{concurrent_connections}_threads"
            con.sql(f"create table {table_name} as (select * from read_parquet('*_performance.parquet', UNION_BY_NAME=TRUE))")
            for f in glob.glob('_performance.parquet'):
                os.remove(f)
            con.close()

        except Exception as e:
            print(f"Error: {e}")
        finally:
            for con in connections:
                con.close()
        print(f"done.")
        time.sleep(5)

def profile_query_mem(query_file, benchmark, config): #systems, memory_limit, benchmark_name, benchmark, connections_list):
    for system in config.systems:
        print(f"profiling memory for {system}. query {query_file}")
        run_query(query_file, system, benchmark, config)
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


def main(config):
    overwrite = False
    if os.path.isdir(config.benchmark_name):
        print(f"benchmark {config.benchmark_name} already exists. Going to overwrite")
        overwrite = True
    else:
        os.makedirs(config.benchmark_name)

    for benchmark in config.benchmarks:
        query_file_names = get_query_file_names(benchmark)
        
        mem_db = get_mem_usage_db_file(config.benchmark_name, benchmark)
        if overwrite and os.path.exists(mem_db):
            os.remove(mem_db)

        # if we are continuously running the benchmark,
        if config.continuous:
            continuous_benchmark_run(query_file_names, benchmark, config)
        else:
            for query_file in query_file_names:
                profile_query_mem(query_file, benchmark, config)

        # write the duckdb to csv 
        con = duckdb.connect(mem_db)
        print("copying data to csv")
        csv_result_file_duckdb = f"{config.benchmark_name}/{benchmark}-duckdb-results"
        csv_result_file_hyper = f"{config.benchmark_name}/{benchmark}-hyper-results"
        con.sql(f"copy time_info to '{csv_result_file_duckdb}.csv' (FORMAT CSV, HEADER 1)")
        con.sql(f"copy proc_mem_info to '{csv_result_file_hyper}.csv' (FORMAT CSV, HEADER 1)")
        # os.remove(mem_db)
        con.close()



class BenchmarkConfig:
    
    def __init__(self):
        parser = argparse.ArgumentParser(description='Run tpch on hyper or duckdb')

        # Add command-line arguments
        parser.add_argument('--benchmark_name', type=str, help='Specify the benchmark name. Benchmark files are stored in this directory')
        parser.add_argument('--benchmark', type=str, help='list of benchmarks to run. \'all\', \'tpch\', etc.')
        parser.add_argument('--system', type=str, help='System to benchmark. Either duckdb or hyper')
        parser.add_argument('--memory_limit', type=int, help="memory limit for both systems", default=0)
        parser.add_argument('--connections_list', nargs="+", help="number of concurrent connections", default=['1'])
        parser.add_argument('--continuous', type=bool, help='run queries continuously for some time limit', default=False)
        parser.add_argument('--continuous_time_limit', type=int, help='time limit (in seconds) for continuous queries', default=600)
        self.args = parser.parse_args()

    def parse_args_and_setup(self):
        self.benchmark_name = "benchmarks/" + self.args.benchmark_name
        
        if self.args.system not in ["hyper", "duckdb", "all"]:
            print("Usage: python3 duckdb_vs_hyper/run_benchmark.py --benchmark_name=[name] --benchmark=[tpch|aggr-thin|aggr-wide|join] --system=[duckdb|hyper|all]")
            exit(1)

        self.benchmarks = self.args.benchmark.split(",")
        if self.args.benchmark == 'all':
            benchmarks = ['tpch', 'operators']


        self.memory_limit = self.args.memory_limit

        self.systems = self.args.system.split(",")
        if len(self.systems) == 0:
            print("please pass valid system names. Valid systems are " + VALID_SYSTEMS)

        if self.systems[0] == "all":
            systems = ["duckdb", "hyper"]

        for system_ in self.systems:
            if system_ not in VALID_SYSTEMS:
                print("please pass valid system names. Valid systems are " + VALID_SYSTEMS)

        if self.benchmark_name is None:
            # create benchmark name
            print("please pass benchmark name")
            exit(1)

        self.connections_list = list(map(lambda x: int(x), self.args.connections_list))
        self.continuous = self.args.continuous

        self.continuous_time_limit = self.args.continuous_time_limit
        if self.continuous_time_limit < 1:
            print("continuous time limit must be greater than or equal to 1 second. Deafult is 600 seconds.")
            exit(1)

        ### extra checks
        if self.continuous and (len(self.systems) > 1 and self.systems[0] == 'hyper'):
            print("cannot continuously run hyper queries.. yet")
            exit(1)


if __name__ == "__main__":
    config = BenchmarkConfig()
    config.parse_args_and_setup()
    main(config)


