library(ggplot2)
library(duckdb)

con <- dbConnect(duckdb())

args = commandArgs(trailingOnly=TRUE)

benchmark_name = args[1]

# dbExecute(con, sprintf("CREATE TABLE results AS FROM read_csv_auto('benchmarks/%s/*.csv', union_by_name=true)", benchmark_name))


for (benchmark_type in c('tpch', 'operators', 'tmm', 'tpcds')) {

	if (!file.exists(sprintf('benchmarks/%s/%s', benchmark_name, benchmark_type))) {
		print(sprintf("skipping benchmark type %s", benchmark_type))
		next
	}

  con <- dbConnect(duckdb(sprintf("benchmarks/%s/%s/data.duckdb", benchmark_name, benchmark_type)))
  dbExecute(con, "attach 'benchmarks/postgres-results-tpcds/tpcds/data.duckdb' as postgres_results_db")
  dbExecute(con, "attach 'benchmarks/sept17-hyper/tpch/data.duckdb' as hyper_tpch_results")
  dbExecute(con, "attach 'benchmarks/sept17-hyper-tpcds/tpcds/data.duckdb' as hyper_tpcds_results")
  
  dbExecute(con, "create or replace view postgres_results_db.postgres_results as select * from postgres_results_db.proc_mem_info where system='postgres'")
  dbExecute(con, "create or replace view hyper_results as (select * from hyper_tpch_results.proc_mem_info where system='hyper' union select * from hyper_tpcds_results.proc_mem_info)")

  dbExecute(con, "create or replace view duckdb_results as select * from proc_mem_info where system='duckdb'")
  
  
  for (run_type in c('hot', 'cold')) {  

    dbExecute(con, sprintf("create or replace temporary table duckdb_start_times as select min(Time) as start_time, system, run_type, benchmark, benchmark_name, query_name as query from duckdb_results where run_type = '%s' and benchmark = '%s' group by all", run_type, benchmark_type));
    dbExecute(con, sprintf("create or replace temporary table hyper_start_times as select min(Time) as start_time, system, run_type, benchmark, benchmark_name, query_name as query from hyper_results where run_type = '%s' and benchmark = '%s' group by all", run_type, benchmark_type));
    dbExecute(con, sprintf("create or replace temporary table postgres_start_times as select min(Time) as start_time, system, run_type, benchmark, benchmark_name, query_name as query from postgres_results_db.postgres_results where run_type = '%s' and benchmark = '%s' group by all", run_type, benchmark_type));

    dbExecute(con, "
      Create or replace temporary table duckdb_results_x_y as select VmRSS/1000000 as MemUsed, Time - duckdb_start_times.start_time as time, results.query_name as query, results.system from duckdb_results results, duckdb_start_times where duckdb_start_times.system = results.system and  duckdb_start_times.query = results.query_name and  duckdb_start_times.run_type = results.run_type and duckdb_start_times.benchmark = results.benchmark and duckdb_start_times.benchmark_name = results.benchmark_name;")
    dbExecute(con, "
      Create or replace temporary table hyper_results_x_y as select VmRSS/1000000 as MemUsed, Time - hyper_start_times.start_time as time, results.query_name as query, results.system from hyper_results results, hyper_start_times where hyper_start_times.system = results.system and hyper_start_times.query = results.query_name and hyper_start_times.run_type = results.run_type and hyper_start_times.benchmark = results.benchmark and hyper_start_times.benchmark_name = results.benchmark_name;")
    dbExecute(con, "
      Create or replace temporary table postgres_results_x_y as select VmRSS/1000000 as MemUsed, Time - postgres_start_times.start_time as time, results.query_name as query, results.system from postgres_results_db.postgres_results results, postgres_start_times where postgres_start_times.system = results.system and postgres_start_times.query = results.query_name and postgres_start_times.run_type = results.run_type and postgres_start_times.benchmark = results.benchmark and postgres_start_times.benchmark_name = results.benchmark_name;")

    dbExecute(con, "
      create or replace temporary table missing_duckdb_single_points as select query, max(time) as time, max(MemUsed) mem_used, count(*) as num_vals, system from duckdb_results_x_y group by all having num_vals <= 1;")
    dbExecute(con, "
      create or replace temporary table missing_hyper_single_points as select query, max(time) as time, max(MemUsed) mem_used, count(*) as num_vals, system from hyper_results_x_y group by all having num_vals <= 1;")
    dbExecute(con, "
      create or replace temporary table single_points as select * from missing_duckdb_single_points union all (select * from missing_hyper_single_points)")

    single_points_duckdb <- dbGetQuery(con, "FROM single_points where system = 'duckdb'")
    single_points_hyper <- dbGetQuery(con, "FROM single_points where system = 'hyper'")

    dbExecute(con, "create or replace temporary table single_point_queries as select query from (select query from single_points where system = 'duckdb' INTERSECT select query from single_points where system = 'hyper')")


    results <- dbGetQuery(con, "select * from (select * FROM duckdb_results_x_y union all (select * from hyper_results_x_y) union all (select * from postgres_results_x_y)) where query not in (select query from single_point_queries)")
    if (run_type == 'hot') {
      dbExecute(con, "create or replace table hot_results as select * from (select * FROM duckdb_results_x_y union all (select * from hyper_results_x_y)) where query not in (select query from single_point_queries)")
    }
    if (run_type == 'cold') {
      dbExecute(con, "create or replace table cold_results as select * from (select * FROM duckdb_results_x_y union all (select * from hyper_results_x_y)) where query not in (select query from single_point_queries)")
    }

    ggplot(results, aes(x=time, y=MemUsed, col=system)) +
      geom_line() +
      # geom_point(data=single_points_duckdb, aes(x=time, y=mem_used, col=system), color="red", shape=4, size=2) +
      # geom_point(data=single_points_hyper, aes(x=time, y=mem_used, col=system), color="#00B8E7", shape=4, size=2) +
      facet_wrap(~query, ncol=5, scales="free_x") +
      ylim(0,NA) + 
      xlab("time [s]") +
      ylab("Memory Used [GB]") +
      theme_bw()

   	print(sprintf("saving file benchmarks/%s/%s/summary_%s.pd", benchmark_name, benchmark_type, run_type))
    ggsave(sprintf("benchmarks/%s/%s/summary_%s.pdf", benchmark_name, benchmark_type, run_type), width=14, height=49)
  }
}
