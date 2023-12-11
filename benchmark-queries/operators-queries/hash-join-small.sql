-- 25 join sf * 10_000 
create table ans as (select * from supplier, nation where s_nationkey = n_nationkey);