import os
import sys
from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode


SYSTEM_DIR = os.path.dirname(__name__)
sys.path.append(f'{SYSTEM_DIR}/..')


def main():
    hyper_path = f'{SYSTEM_DIR}/hyper/'
    db_path = f"{SYSTEM_DIR}/hyper/mydb.hyper"
process_parameters = {"default_database_version": "2"}
with HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=process_parameters) as hyper:
    with Connection(hyper.endpoint, db_path, CreateMode.CREATE_IF_NOT_EXISTS) as con:
        print(hyper.endpoint)
        print(db_path)
        con.execute_query("""START TRANSACTION;""").close()
        rows = con.execute_list_query(query=f"""SELECT count(*) FROM lineitem;""")
        if rows[0][0] == 0:
           print(f'Loading hyper SF{sf} ...')
           con.execute_query(f"""COPY lineitem{sf} FROM '{get_csv_path(sf)}' (FORMAT CSV, HEADER TRUE, QUOTE '"', DELIMITER ',');""").close()
           print(f'Loading hyper SF{sf} done.')
        con.execute_query("""COMMIT;""").close()


if __name__ == '__main__':
    main()