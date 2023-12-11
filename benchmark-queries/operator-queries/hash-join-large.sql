-- sf * 6_000_000 join sf * 1_500_000
create table ans as (select * from lineitem, orders where l_orderkey = c_orderkey);