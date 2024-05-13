#install.packages(c("ggplot2", "tidyverse", "plyr", "stringr", "scales", "duckdb"))

library(ggplot2)
library(tidyverse)
library(dplyr)
library(stringr)
library(scales)
library(duckdb)

con <- dbConnect(duckdb(''))


for (query_name in c('01_build_table', '02_build_tables', '03_build_tables')) {

  dbExecute(con, sprintf("CREATE OR REPLACE TABLE filtered_data AS \
                         SELECT execution_time, memory_limit, num_connections::VARCHAR as connections , \
                          query \
                        from 'tmm_GOOD_data.parquet' where query = '%s'", query_name));

  aggregated <- dbGetQuery(con, "FROM filtered_data")

  # ggplot(aggregated, aes(x=memory_limit, y=time)) +
  #   geom_line() +
  #   facet_wrap(~query, ncol=5, scales="free_y") +
  #   xlab("Memory limit [GB]") +
  #   ylab("Execution time [s]") +
  #   ylim(0, 110) +
  #   theme_bw()

  ggplot(aggregated, aes(x=memory_limit, y=execution_time, color=connections)) +
    geom_point(size=1) +
    facet_wrap(~query, ncol=4, scales="free_y") +
    xlab("Memory limit [GB]") +
    ylab("Execution time [s]") +
    ylim(0, NA) +
    theme_bw()


  ggsave(sprintf("tpc-sf100-mem-limit-GOOD-connections-%s.pdf", query_name), width=10, height=6)
}