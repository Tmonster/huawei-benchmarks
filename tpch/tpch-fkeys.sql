-- foreign keys

   alter table supplier
add constraint supplier_nation_fkey
   foreign key (s_nationkey) references nation(n_nationkey);

   alter table partsupp
add constraint partsupp_part_fkey
   foreign key (ps_partkey) references part(p_partkey);
   
   alter table partsupp
add constraint partsupp_supplier_fkey
   foreign key (ps_suppkey) references supplier(s_suppkey);

   alter table customer
add constraint customer_nation_fkey
   foreign key (c_nationkey) references nation(n_nationkey);

   alter table orders
add constraint orders_customer_fkey
   foreign key (o_custkey) references customer(c_custkey);

   alter table lineitem
add constraint lineitem_orders_fkey
   foreign key (l_orderkey) references orders(o_orderkey);

   alter table lineitem
add constraint lineitem_partsupp_fkey
   foreign key (l_partkey,l_suppkey)
    references partsupp(ps_partkey,ps_suppkey);

   alter table nation
add constraint nation_region_fkey
   foreign key (n_regionkey) references region(r_regionkey);