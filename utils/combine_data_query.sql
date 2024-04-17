attach 'benchmarks/april-15-tmm-memory-limit-5/tmm/data.duckdb' as april_15_tmm_memory_limit_5 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-6/tmm/data.duckdb' as april_15_tmm_memory_limit_6 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-7/tmm/data.duckdb' as april_15_tmm_memory_limit_7 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-8/tmm/data.duckdb' as april_15_tmm_memory_limit_8 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-9/tmm/data.duckdb' as april_15_tmm_memory_limit_9 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-10/tmm/data.duckdb' as april_15_tmm_memory_limit_10 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-11/tmm/data.duckdb' as april_15_tmm_memory_limit_11 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-12/tmm/data.duckdb' as april_15_tmm_memory_limit_12 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-13/tmm/data.duckdb' as april_15_tmm_memory_limit_13 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-14/tmm/data.duckdb' as april_15_tmm_memory_limit_14 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-15/tmm/data.duckdb' as april_15_tmm_memory_limit_15 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-16/tmm/data.duckdb' as april_15_tmm_memory_limit_16 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-17/tmm/data.duckdb' as april_15_tmm_memory_limit_17 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-18/tmm/data.duckdb' as april_15_tmm_memory_limit_18 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-19/tmm/data.duckdb' as april_15_tmm_memory_limit_19 (READ_ONLY);
attach 'benchmarks/april-15-tmm-memory-limit-20/tmm/data.duckdb' as april_15_tmm_memory_limit_20 (READ_ONLY);



create or replace table all_time_info as (
select * from 
    april_15_tmm_memory_limit_5.proc_mem_info
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_6.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_7.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_8.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_9.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_10.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_11.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_12.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_13.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_14.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_15.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_16.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_17.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_18.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_19.proc_mem_info )
UNION BY NAME 
( Select * from april_15_tmm_memory_limit_20.proc_mem_info )
);

Select 
    max(Time) - min(Time) as time, 
    replace(benchmark_name, 'benchmarks/april-15-tmm-memory-limit-', '')::INT as memory_limit, 
    regexp_replace(query_name, '_0._connections', '') as query,
    CASE WHEN query_name like '%01_connections%' then 1
         WHEN query_name like '%02_connections%' then 2
         WHEN query_name like '%04_connections%' then 4 
         ELSE 100 END AS num_connections
from 
   all_time_info
where 
    system = 'duckdb' and 
    run_type = 'hot' and
    num_connections = 1
group by 
    query_name, 
    system, 
    run_type, 
    memory_limit
order by memory_limit, query, num_connections;
