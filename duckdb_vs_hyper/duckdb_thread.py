import duckdb
import threading

class duckdb_thread(threading.Thread):
    def __init__(self, name, con, continuous, queries):
        threading.Thread.__init__(self)
        self._stop_event = threading.Event()
        self.name = name
        self.con = con
        self.continuous = continuous
        self.queries = queries
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
                    self.con.sql(query).execute()
                    if self._stop_event.is_set():
                        break 
                    i+=1
                print(f"thread {threading.current_thread().name} ran {i+1} queries")
        except Exception as e:
            print(f"{threading.current_thread().name} raised an exception")
            print(f"{e}")
        finally:
            print(f"{threading.current_thread().name} finished")
