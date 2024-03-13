import duckdb
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode


process_parameters = {"default_database_version": "2"}
db_path = 'tpch-sf100.duckdb'



with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=process_parameters) as hyper:
    with Connection(hyper.endpoint) as con:
        con.execute_query("""START TRANSACTION;""").close()
       
        res = con.execute_list_query(f"""select * from external('customer.parquet') limit 10;""")
        print(res)

        con.execute_query("""COMMIT;""").close()

        
        # named constraint support not supported
        # print("adding foreign keys")
        # fks = get_query_from_file('../tpch/tpch-fkeys.sql')
        # execute_multi_query(fks, con)

        print(f'Loading tpch done.')
        con.execute_query("""COMMIT;""").close()
print(f"done.")