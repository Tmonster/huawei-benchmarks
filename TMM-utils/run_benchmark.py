import os
import sys
import duckdb
import argparse
from threading import Thread, current_thread


DUCKDB_DATABASE_FILE = "TMM_test.duckdb"


def db_exists():
	return os.path.exists(DUCKDB_DATABASE_FILE)


def create_db():
	con = duckdb.connect(DUCKDB_DATABASE_FILE)
	con.execute("create table t1 as select range a from range(1000000)")
	con.close()



# test queries when running via cursors (in python)
# test queries when running multiple connections


def execute_query_on_con(con):
	thread_name = str(current_thread().name)
	res = con.execute("Select * from t1 ta, t1 tb where ta.a = tb.a").fetchall()
	print(f"{thread_name} received {len(res)} results")

def get_connections(num_connections):
	connections = []
	for i in range(num_connections):
		con = duckdb.connect(DUCKDB_DATABASE_FILE, read_only=True)
		connections.append(con)
	return connections


def run_benchmark(num_connections):
	if not db_exists():
		create_db()

	connections = get_connections(num_connections)
	threads = []
	# every connection now needs to spin a new thread and run the same query
	for i in range(num_connections):
		con = connections[i]
		threads.append(Thread(target=execute_query_on_con, args=(con,), name=f'thread with con {i}'))

	for t in threads:
		t.start()

	for t in threads:
		t.join()


def parse_args():
	parser = argparse.ArgumentParser(description='Run tpch on hyper or duckdb')

	# Add command-line arguments
	parser.add_argument('--num_connections', type=int, help='Number of read connections ocnnected to duckdb')

	# Parse the command-line arguments
	args = parser.parse_args()
	return args    


def main():
	args = parse_args()
	num_connections = args.num_connections

	run_benchmark(num_connections)


if __name__ == "__main__":
	main()