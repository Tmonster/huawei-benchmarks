

for i in range(4, 25):
    string_to_print = f"""-- memory limit {i}
    (
    select 
        '01_build_table' as query,
        1 as num_connections,
        {i} as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_{i}.one_build_table_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        1 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.two_build_tables_thread_performance_1_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        1 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.three_build_tables_thread_performance_1_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        2 as num_connections,
        {i} as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_{i}.one_build_table_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        2 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.two_build_tables_thread_performance_2_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        2 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.three_build_tables_thread_performance_2_threads
    ) 
    UNION BY NAME
    (
    select 
        '01_build_table' as query,
        4 as num_connections,
        {i} as memory_limit,
        execution_time,
    from april_16_tmm_memory_limit_{i}.one_build_table_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '02_build_tables' as query,
        4 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.two_build_tables_thread_performance_4_threads
    )
    UNION BY NAME
    (
    select 
        '03_build_tables' as query,
        4 as num_connections,
        {i} as memory_limit,
        execution_time
    from april_16_tmm_memory_limit_{i}.three_build_tables_thread_performance_4_threads
    ) """
    print(string_to_print)