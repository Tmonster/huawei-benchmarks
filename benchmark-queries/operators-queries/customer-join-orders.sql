-- sf * 1_500_000 joined with sf * 150_000
create table ans as (select * from orders, customer where o_custkey = c_custkey);