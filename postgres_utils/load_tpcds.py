import os
import sys
import psycopg2


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

def copy_tpch(con):
    print("copying tpch data from csv")
    con.execute("""START TRANSACTION;""").close()
    con.execute(f"""Copy customer FROM '/mount/memory-pressure-benchmarks/tpch_data/customer.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy lineitem FROM '/mount/memory-pressure-benchmarks/tpch_data/lineitem.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy nation FROM '/mount/memory-pressure-benchmarks/tpch_data/nation.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy orders FROM '/mount/memory-pressure-benchmarks/tpch_data/orders.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy part FROM '/mount/memory-pressure-benchmarks/tpch_data/part.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy partsupp FROM '/mount/memory-pressure-benchmarks/tpch_data/partsupp.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy region FROM '/mount/memory-pressure-benchmarks/tpch_data/region.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute(f"""Copy supplier FROM '/mount/memory-pressure-benchmarks/tpch_data/supplier.csv' WITH (FORMAT CSV, HEADER 1);""")
    con.execute("""COMMIT;""")

def copy_tpcds(con):
    print("copying tpcds data from csv")
    con.execute(f"""Copy call_center FROM '/mount/memory-pressure-benchmarks/tpcds-data/call_center.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy catalog_page FROM '/mount/memory-pressure-benchmarks/tpcds-data/catalog_page.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy catalog_returns FROM '/mount/memory-pressure-benchmarks/tpcds-data/catalog_returns.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy catalog_sales FROM '/mount/memory-pressure-benchmarks/tpcds-data/catalog_sales.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy customer FROM '/mount/memory-pressure-benchmarks/tpcds-data/customer.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy customer_address FROM '/mount/memory-pressure-benchmarks/tpcds-data/customer_address.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy customer_demographics FROM '/mount/memory-pressure-benchmarks/tpcds-data/customer_demographics.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy date_dim FROM '/mount/memory-pressure-benchmarks/tpcds-data/date_dim.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy household_demographics FROM '/mount/memory-pressure-benchmarks/tpcds-data/household_demographics.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy income_band FROM '/mount/memory-pressure-benchmarks/tpcds-data/income_band.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy inventory FROM '/mount/memory-pressure-benchmarks/tpcds-data/inventory.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy item FROM '/mount/memory-pressure-benchmarks/tpcds-data/item.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy promotion FROM '/mount/memory-pressure-benchmarks/tpcds-data/promotion.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy reason FROM '/mount/memory-pressure-benchmarks/tpcds-data/reason.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy ship_mode FROM '/mount/memory-pressure-benchmarks/tpcds-data/ship_mode.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy store FROM '/mount/memory-pressure-benchmarks/tpcds-data/store.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy store_returns FROM '/mount/memory-pressure-benchmarks/tpcds-data/store_returns.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy store_sales FROM '/mount/memory-pressure-benchmarks/tpcds-data/store_sales.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy time_dim FROM '/mount/memory-pressure-benchmarks/tpcds-data/time_dim.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy warehouse FROM '/mount/memory-pressure-benchmarks/tpcds-data/warehouse.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy web_page FROM '/mount/memory-pressure-benchmarks/tpcds-data/web_page.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy web_returns FROM '/mount/memory-pressure-benchmarks/tpcds-data/web_returns.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy web_sales FROM '/mount/memory-pressure-benchmarks/tpcds-data/web_sales.csv' DELIMITER ',' CSV HEADER;""")
    con.execute(f"""Copy web_site FROM '/mount/memory-pressure-benchmarks/tpcds-data/web_site.csv' DELIMITER ',' CSV HEADER;""")



def main(benchmark):
    psql_path = f''
    
    if benchmark == "tpch":
        db_name = "tpch"
        con = psycopg2.connect(database=db_name, user="postgres", password="password", host="localhost", port=5432)
        cursor = con.cursor()
        print("creating tpch schema")
        schema = get_query_from_file(f"tpch/{benchmark}-schema.sql")
        cursor.execute(schema)
        con.commit()
        copy_tpch(con)
    if benchmark == "tpcds":
        db_name = "tpcds"
        con = psycopg2.connect(database=db_name, user="postgres", password="password", host="localhost", port=5432)
        cursor = con.cursor()
        print("creating tpcds schema")
        schema = get_query_from_file(f"tpch/{benchmark}-schema.sql")
        cursor.execute(schema)
        con.commit()
        copy_tpcds(con)

    print(f'Loading {benchmark} done.')
    con.execute_query("""COMMIT;""").close()


if __name__ == '__main__':
    if len(sys.argv) == 1:
        print("copying data for tpch and tpcds")
        main("tpch")
        main("tpcds")
    else:
        benchmark = sys.argv[1]
        main(benchmark)