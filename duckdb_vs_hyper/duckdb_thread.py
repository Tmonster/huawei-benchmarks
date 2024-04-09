import duckdb
import threading
import time


class QueryPerformance():
    def __init__(self, query_number, execution_time, thread_name):
        self.query_number = query_number
        self.execution_time = execution_time
        self.thread_name = thread_name

    def get_header():
        return "thread_name,query_number,execution_time"
    
    def __str__(self):
        return f"{self.thread_name},{self.query_number},{self.execution_time}"

class ThreadPerformance():
    def __init__(self, thread_name):
        self.thread_name = thread_name
        self.stats = []

    def add_execution(self, query_number, execution_time):
        self.stats.append(QueryPerformance(query_number, execution_time, self.thread_name))

    def dump_performance(self):
        con = duckdb.connect()
        csv_results = QueryPerformance.get_header() + "\n"
        for stat in self.stats:
            csv_results += str(stat) + "\n"

        csv_file_name = f"{self.thread_name}_performance.csv"
        with open(csv_file_name, "w+") as f:
            f.write(csv_results)

        csv_columns = "columns = { \
            'thread_name' : 'VARCHAR', \
            'query_number': 'VARCHAR', \
            'execution_time': 'DOUBLE' \
        }"
        con.sql(f"copy (SELECT * FROM read_csv('{csv_file_name}', {csv_columns})) to '{csv_file_name.replace('.csv', '.parquet')}' (FORMAT PARQUET)")
        con.close()

class duckdb_thread(threading.Thread):
    def __init__(self, name, con, continuous, queries):
        threading.Thread.__init__(self)
        self._stop_event = threading.Event()
        self.name = name
        self.con = con
        self.continuous = continuous
        self.queries = queries
        self.performance = ThreadPerformance(self.name.strip())
        if len(self.queries) == 0:
            print("you must pass at least 1 query to a duckdb_thread")
            exit(1)

    def stop(self):
        self._stop_event.set()


    def run(self):
        try:
            if not self.continuous:
                query = self.queries[0]
                self.con.sql(query).execute()
            else:
                num_queries = len(self.queries)
                i = 0
                while(i < 10000000):
                    query = self.queries[i % num_queries]
                    start = time.time()
                    self.con.sql(query).execute()
                    end = time.time()
                    self.performance.add_execution(i, round(end-start, 2))
                    if self._stop_event.is_set():
                        break 
                    i+=1
                self.performance.dump_performance()
        except Exception as e:
            print(f"{self.name} raised an exception")
            print(f"{e}")
        finally:
            print(f"{self.name} finished")
