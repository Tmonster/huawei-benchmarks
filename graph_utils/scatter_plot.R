# Create a scatter plot for thread performance
# x axis is query number
# y axis is execution time
# color is thread.


library(ggplot2)
library(duckdb)


args = commandArgs(trailingOnly=TRUE)

benchmark_name = args[1]


benchmark_type <- 'tpch'
if (!file.exists(sprintf('benchmarks/%s/%s', benchmark_name, benchmark_type))) {
	print(sprintf("skipping benchmark type %s", benchmark_type))
	next
}
con <- dbConnect(duckdb(sprintf("benchmarks/%s/%s/data.duckdb", benchmark_name, benchmark_type)))
temp_view_all_threads <- "all_thread_performance"
dbExecute(con, sprintf("create or replace temporary table %s (thread_count int, thread_name varchar, query_number varchar, execution_time double)", temp_view_all_threads))



for (thread_count in c(1, 2, 4, 8)) {
	thread_count_table_name <- sprintf("thread_performance_%s_threads", thread_count)
  	
  	dbExecute(con, sprintf("Create table if not exists %s (thread_name varchar, query_number varchar, execution_time double)", thread_count_table_name))

  	dbExecute(con, sprintf("create or replace temp table thread_results_queries_normalized as select thread_name, (query_number::INT %% 22) + 1 as query_number, execution_time from %s", thread_count_table_name))

  	dbExecute(con, sprintf("insert into %s select %s, * from thread_results_queries_normalized", temp_view_all_threads, thread_count))

  	print(sprintf("updated %s", thread_count_table_name))
 }

all_results <- dbGetQuery(con, sprintf("select query_number::INT query_number, thread_name, execution_time, thread_count from %s order by query_number", temp_view_all_threads))

ggplot(all_results, aes(x=query_number, y=execution_time, color=thread_name)) +
geom_point(size=1) +
facet_wrap(~thread_count, ncol=1, scales="free_y") +
scale_x_continuous(breaks=c(1:22), labels=c(1:22)) +
xlab("Tpch Query [GB]") +
ylab("Execution time [s]") +
ylim(0, NA) +
theme_bw()

print(sprintf("saving file benchmarks/%s/%s/summary_thread_performance.pd", benchmark_name, benchmark_type))
ggsave(sprintf("benchmarks/%s/%s/summary_thread_performance.pdf", benchmark_name, benchmark_type), width=20, height=12)
 