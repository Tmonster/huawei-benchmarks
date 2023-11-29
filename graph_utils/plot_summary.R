library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(scales)
library("duckdb")

con <- dbConnect(duckdb())

args = commandArgs(trailingOnly=TRUE)

benchmark = args[1]

dbExecute(con, sprintf("CREATE TABLE results AS FROM read_csv_auto('benchmarks/%s/q01_duckdb_cold_mem.csv')", benchmark))
dbExecute(con, "alter table results add column system Varchar(20)")
dbExecute(con, "alter table results add column run_type Varchar(5)")
dbExecute(con, "alter table results add column query INTEGER")
dbExecute(con, "Delete from results where 1=1;")


for (query in c(1:22)) {
	for (system in c("hyper", "duckdb")) {
		for (run_type in c("hot", "cold")) {
			filename = sprintf("benchmarks/%s/q%02d_%s_%s_mem.csv", benchmark, query, system, run_type)
			if (file.exists(filename)) {
				dbExecute(con, sprintf("INSERT INTO results SELECT *, '%s', '%s', %s from read_csv_auto('%s')", system, run_type, query, filename))
			}
		}
	}
}


dbExecute(con, "create table StartTimes as select min(Time) as start_time, system, run_type, query from results where run_type = 'hot' group by all");


dbExecute(con, "
	Create table results_x_y as select (MemTotal - MemAvailable)/1000000 as MemUsed, Time - StartTimes.start_time as time, results.query, results.system from results, StartTimes where  StartTimes.system = results.system and  StartTimes.query = results.query and  StartTimes.run_type = results.run_type;")

results <- dbGetQuery(con, "FROM results_x_y")

ggplot(results, aes(x=time, y=MemUsed, col=system)) +
  geom_line() +
  facet_wrap(~query, ncol=5, scales="free_x") +
  ylim(0,NA) + 
  xlab("time [s]") +
  ylab("Memory Used [GB]") +
  theme_bw()

ggsave(sprintf("benchmarks/%s/summary_hot.pdf", benchmark), width=14, height=12)
