library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(scales)
library(duckdb)

con <- dbConnect(duckdb())

args = commandArgs(trailingOnly=TRUE)

benchmark_name = args[1]

dbExecute(con, sprintf("CREATE TABLE results AS FROM read_csv_auto('benchmarks/%s/*.csv', union_by_name=true)", benchmark_name))


for (benchmark_type in c('tpch', 'operators')) {

	if (!file.exists(sprintf('benchmarks/%s/%s', benchmark_name, benchmark_type))) {
		print(sprintf("skipping benchmark type %s", benchmark_type))
		next
	}

  dbExecute(con, sprintf("create or replace table StartTimes as select min(Time) as start_time, system, run_type, benchmark, benchmark_name, query_name as query from results where run_type = 'hot' and benchmark = '%s' group by all", benchmark_type));


  dbExecute(con, "
    Create or replace table results_x_y as select (MemTotal - MemAvailable)/1000000 as MemUsed, Time - StartTimes.start_time as time, results.query_name as query, results.system as system from results, StartTimes where StartTimes.system = results.system and  StartTimes.query = results.query_name and  StartTimes.run_type = results.run_type and StartTimes.benchmark = results.benchmark and StartTimes.benchmark_name = results.benchmark_name;")

  dbExecute(con, "
    create or replace table single_points as select query, max(time) as time, max(MemUsed) mem_used, count(*) as num_vals, system from results_x_y group by all having num_vals <= 1;")

  single_points_duckdb <- dbGetQuery(con, "FROM single_points where system = 'duckdb'")
  single_points_hyper <- dbGetQuery(con, "FROM single_points where system = 'hyper'")

  results <- dbGetQuery(con, "FROM results_x_y")


  ggplot(results, aes(x=time, y=MemUsed, col=system)) +
    geom_line() +
    geom_point(data=single_points_duckdb, aes(x=time, y=mem_used, col=system), color="red", shape=4, size=2) +
    geom_point(data=single_points_hyper, aes(x=time, y=mem_used, col=system), color="#00B8E7", shape=4, size=2) +
    facet_wrap(~query, ncol=5, scales="free_x") +
    ylim(0,NA) + 
    xlab("time [s]") +
    ylab("Memory Used [GB]") +
    theme_bw()
 	print(sprintf("saving file benchmarks/%s/%s/summary_hot.pd", benchmark_name, benchmark_type))
  ggsave(sprintf("benchmarks/%s/%s/summary_hot.pdf", benchmark_name, benchmark_type), width=14, height=12)
}
