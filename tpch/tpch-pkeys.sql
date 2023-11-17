alter table part
  add constraint part_kpey
     primary key (p_partkey);

alter table supplier
  add constraint supplier_pkey
     primary key (s_suppkey);

alter table partsupp
  add constraint partsupp_pkey
     primary key (ps_partkey, ps_suppkey);

alter table customer
  add constraint customer_pkey
     primary key (c_custkey);

alter table orders
  add constraint orders_pkey
     primary key (o_orderkey);

alter table lineitem
  add constraint lineitem_pkey
     primary key (l_orderkey, l_linenumber);

alter table nation
  add constraint nation_pkey
     primary key (n_nationkey);

alter table region
  add constraint region_pkey
     primary key (r_regionkey);