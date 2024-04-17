attach 'benchmarks/april-16-tmm-memory-limit-15/tmm/data.duckdb' as april_16_tmm_memory_limit_15 (READ_ONLY);
attach 'benchmarks/april-16-tmm-memory-limit-16/tmm/data.duckdb' as april_16_tmm_memory_limit_16 (READ_ONLY);
attach 'benchmarks/april-16-tmm-memory-limit-17/tmm/data.duckdb' as april_16_tmm_memory_limit_17 (READ_ONLY);
attach 'benchmarks/april-16-tmm-memory-limit-18/tmm/data.duckdb' as april_16_tmm_memory_limit_18 (READ_ONLY);
attach 'benchmarks/april-16-tmm-memory-limit-19/tmm/data.duckdb' as april_16_tmm_memory_limit_19 (READ_ONLY);
attach 'benchmarks/april-16-tmm-memory-limit-20/tmm/data.duckdb' as april_16_tmm_memory_limit_20 (READ_ONLY);


create or replace table table_all_time_info as 
    select
        '01_build_table' as query,
        2 as num_connections,
        15 as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_15.one_build_table_thread_performance_2_threads
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
-- memory limit 16
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
-- memory limit 17
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
-- memory limit 18
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
-- memory limit 19
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
-- memory limit 20
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
    );