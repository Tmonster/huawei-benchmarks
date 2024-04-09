-- create table big_table as select range a, range b, range c from range(10000);

select * from big_table ta, big_table tb, big_table tc
where 
	ta.a = tb.a and
	tb.a = tc.a;