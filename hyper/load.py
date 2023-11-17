import os
import sys
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode

def get_query_from_file(file_name):
    try:
        # Open the file in read mode and read the contents
        with open(file_name, 'r') as file:
            query = file.read()
            return query
    except FileNotFoundError:
        print(f"Error: File '{file_name}' not found.")
        return None
    except Exception as e:
        print(f"Error: {e}")
        return None

def execute_multi_query(query, con):
    queries = query.split(";")
    con.execute_query("""START TRANSACTION;""").close()
    
    for q in queries:
        print(f"query is {q}\n")
        con.execute_query(q).close()

    con.execute_query("""COMMIT;""").close()


def main():
    hyper_path = f''
    db_path = f"mydb.hyper"
    process_parameters = {"default_database_version": "2"}
    with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=process_parameters) as hyper:
        with Connection(hyper.endpoint, db_path, CreateMode.CREATE_IF_NOT_EXISTS) as con:
            con.execute_query("""START TRANSACTION;""").close()
            num_lineitem_rows = 0
            try:
                rows = con.execute_list_query(query=f"""SELECT count(*) FROM lineitem;""")
                num_lineitem_rows = rows[0][0]
            except Exception as e:
                if str(e).find("does not exist") > 1:
                    # lineitem doesn't exist?
                    pass
                else:
                    print(f"Hyper error {e}")
                    exit(1)

            if num_lineitem_rows > 0:
                print("lineitem has rows. Exiting")
                exit(0)

            con.execute_query("""COMMIT;""").close()

            print("creating schema")

            schema = get_query_from_file('../tpch/tpch-schema.sql')
            execute_multi_query(schema, con)
            # con.execute_query(schema)

            print("adding primary keys")

            # no support for named constraints
            # pks = get_query_from_file('../tpch/tpch-pkeys.sql')
            # execute_multi_query(pks, con)
            # con.execute_query(pks)

            print("adding indexes")

            # index support is disabled in hyper
            # indexes = get_query_from_file('../tpch/tpch-index.sql')
            # execute_multi_query(indexes, con)

            # can't read from external sources.
            print("copying data from parquet")
            con.execute_query("""START TRANSACTION;""").close()
            con.execute_query(f"""Copy customer FROM '../../coiled-benchmarks/tpch-data/customer-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy lineitem FROM '../../coiled-benchmarks/tpch-data/lineitem-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy nation FROM '../../coiled-benchmarks/tpch-data/nation-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy orders FROM '../../coiled-benchmarks/tpch-data/orders-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy part FROM '../../coiled-benchmarks/tpch-data/part-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy partsupp FROM '../../coiled-benchmarks/tpch-data/partsupp-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy region FROM '../../coiled-benchmarks/tpch-data/region-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query(f"""Copy supplier FROM '../../coiled-benchmarks/tpch-data/supplier-sf-100.csv' WITH (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
            con.execute_query("""COMMIT;""").close()
            
            # named constraint support not supported
            # print("adding foreign keys")
            # fks = get_query_from_file('../tpch/tpch-fkeys.sql')
            # execute_multi_query(fks, con)

            print(f'Loading tpch done.')
            con.execute_query("""COMMIT;""").close()


if __name__ == '__main__':
    main()