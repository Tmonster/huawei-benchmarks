attach 'benchmarks/april-16-tmm-GOOD-memory-limit-4/tmm/data.duckdb' as april_16_tmm_memory_limit_4 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-5/tmm/data.duckdb' as april_16_tmm_memory_limit_5 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-6/tmm/data.duckdb' as april_16_tmm_memory_limit_6 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-7/tmm/data.duckdb' as april_16_tmm_memory_limit_7 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-8/tmm/data.duckdb' as april_16_tmm_memory_limit_8 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-9/tmm/data.duckdb' as april_16_tmm_memory_limit_9 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-10/tmm/data.duckdb' as april_16_tmm_memory_limit_10 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-11/tmm/data.duckdb' as april_16_tmm_memory_limit_11 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-12/tmm/data.duckdb' as april_16_tmm_memory_limit_12 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-13/tmm/data.duckdb' as april_16_tmm_memory_limit_13 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-14/tmm/data.duckdb' as april_16_tmm_memory_limit_14 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-15/tmm/data.duckdb' as april_16_tmm_memory_limit_15 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-16/tmm/data.duckdb' as april_16_tmm_memory_limit_16 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-17/tmm/data.duckdb' as april_16_tmm_memory_limit_17 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-18/tmm/data.duckdb' as april_16_tmm_memory_limit_18 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-19/tmm/data.duckdb' as april_16_tmm_memory_limit_19 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-20/tmm/data.duckdb' as april_16_tmm_memory_limit_20 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-21/tmm/data.duckdb' as april_16_tmm_memory_limit_21 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-22/tmm/data.duckdb' as april_16_tmm_memory_limit_22 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-23/tmm/data.duckdb' as april_16_tmm_memory_limit_23 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-24/tmm/data.duckdb' as april_16_tmm_memory_limit_24 (READ_ONLY);
attach 'benchmarks/april-16-tmm-GOOD-memory-limit-25/tmm/data.duckdb' as april_16_tmm_memory_limit_25 (READ_ONLY);

create or replace table table_all_time_info as 
-- memory limit 4
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        4 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_4.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        4 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_4.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        4 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_4.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        4 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_4.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 5
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        5 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_5.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        5 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_5.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        5 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_5.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        5 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_5.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 6
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        6 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_6.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        6 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_6.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        6 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_6.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        6 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_6.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 7
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        7 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_7.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        7 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_7.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        7 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_7.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        7 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_7.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 8
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        8 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_8.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        8 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_8.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        8 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_8.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        8 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_8.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 9
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        9 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_9.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        9 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_9.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        9 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_9.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        9 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_9.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 10
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        10 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_10.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        10 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_10.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        10 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_10.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        10 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_10.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 11
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        11 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_11.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        11 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_11.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        11 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_11.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        11 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_11.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 12
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        12 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_12.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        12 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_12.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        12 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_12.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        12 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_12.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 13
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        13 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_13.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        13 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_13.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        13 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_13.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        13 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_13.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 14
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        14 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_14.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        14 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_14.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        14 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_14.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        14 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_14.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 15
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        15 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_15.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        15 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_15.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        15 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_15.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        15 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_15.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 16
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        16 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_16.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        16 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_16.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        16 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_16.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        16 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_16.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 17
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        17 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_17.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        17 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_17.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        17 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_17.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        17 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_17.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 18
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        18 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_18.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        18 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_18.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        18 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_18.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        18 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_18.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 19
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        19 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_19.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        19 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_19.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        19 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_19.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        19 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_19.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 20
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        20 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_20.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        20 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_20.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        20 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_20.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        20 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_20.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 21
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        21 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_21.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        21 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_21.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        21 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_21.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        21 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_21.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 22
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        22 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_22.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        22 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_22.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        22 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_22.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        22 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_22.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 23
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        23 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_23.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        23 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_23.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        23 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_23.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        23 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_23.three_build_tables_thread_performance_4_threads
    ) 
    UNION BY NAME
-- memory limit 24
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        24 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_24.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        24 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_24.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        24 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_24.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        24 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_24.three_build_tables_thread_performance_4_threads
    )
    -- memory limit 25
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        25 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_25.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        25 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_25.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        25 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_25.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        25 as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_25.three_build_tables_thread_performance_4_threads
    );

