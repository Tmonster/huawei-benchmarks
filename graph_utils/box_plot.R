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


for (thread_count in c(1, 2, 4, 8)) {
	thread_count_table_name <- sprintf("thread_performance_%s_threads", thread_count)

  	thread_results <- dbGetQuery(con, sprintf("select actual_query_number as query_number, thread_name, execution_time from %s order by query_number", thread_count_table_name))
  	if (nrow(thread_results) == 0) {
  		print(sprintf("no results for thread count = %s", thread_count))
  		next
  	}

	ggplot(thread_results, aes(x=thread_name, y=execution_time)) +
	geom_boxplot(notch=FALSE) +
	facet_wrap(~query_number, ncol=4, scales="free_y") +
	xlab("thread number") +
	ylab("Execution time [s]") +
	theme_bw()


	print(sprintf("saving file benchmarks/%s/%s/box_plot_thread_performance_%s_threads.pdf", benchmark_name, benchmark_type, thread_count))
	ggsave(sprintf("benchmarks/%s/%s/box_plot_thread_performance_%s_threads.pdf", benchmark_name, benchmark_type, thread_count), width=20, height=12)
 }



# print(sprintf("saving file benchmarks/%s/%s/summary_thread_performance.pd", benchmark_name, benchmark_type))
# ggsave(sprintf("benchmarks/%s/%s/summary_thread_performance.pdf", benchmark_name, benchmark_type), width=20, height=12)
 