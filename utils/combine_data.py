import duckdb


class execution_result:
    def __init__(self):
        self.memory_limit
        self.query_name
        self.execution_time
        self.connections



def get_execution_time(con, connection_count, query, memory_limit):
    database_name = f"memory_limit_{str(memory_limit)}"
    benchmark_name = f"april-15-tmm-memory-limit-{memory_limit}"
    query_name = f"{query}_{str(connection_count).zfill(2)}_connections"
    system = "duckdb"
    run = "hot"
    res = con.sql(f"Select \
                max(Time) - min(Time) as execution_time, \
                {connection_count}::INT as connection_count \
                {query_name} as query_name \
            from \
                {database_name}.??? \
            where \
                benchmark_name = {benchmark_name} and \
                query = {query_name}  and \
                system = {system} and \
                run_type = {run} \
            group by \
                query, \
                system, \
                run_type, \
                benchmark_name\
            ")
    return res


def getcon():
    con = duckdb.connect()
    # attach every database
    # create the memory_limit_to_time table
    con.sql("create table if not exists main.memory_to_exec_time ( \
            execution_time double, \
            connections int, \
            query_name Varchar \
        );")
    return con


def main():
    con = getcon()

    for connection_count in [1, 2, 4]:
        for query in ['one_agg_table', 'one_build_table', 'two_build_tables', 'three_build_tables']:
            results = []
            for memory_limit in range(5,21):
                add_execution_time(con, connection_count, query, memory_limit)
            # get the execution time for every query.
            # 



if __name__ == "__main__":
	main()