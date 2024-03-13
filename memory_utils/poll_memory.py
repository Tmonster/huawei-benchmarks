import time
import sys
import os
import duckdb

MEM_INFO_FILE = "/proc/meminfo"

known_keys = ['Active', 'Active(anon)', 'Active(file)', 'AnonHugePages', 'AnonPages', 'Bounce', 'Buffers', 'Cached', 'CommitLimit', 'Committed_AS', 'DirectMap1G', 'DirectMap2M', 'DirectMap4k', 'Dirty', 'FileHugePages', 'FilePmdMapped', 'HardwareCorrupted', 'HugePages_Free', 'HugePages_Rsvd', 'HugePages_Surp', 'HugePages_Total', 'Hugepagesize', 'Hugetlb', 'Inactive', 'Inactive(anon)', 'Inactive(file)', 'KReclaimable', 'KernelStack', 'Mapped', 'MemAvailable', 'MemFree', 'MemTotal', 'Mlocked', 'NFS_Unstable', 'PageTables', 'Percpu', 'SReclaimable', 'SUnreclaim', 'SecPageTables', 'Shmem', 'ShmemHugePages', 'ShmemPmdMapped', 'Slab', 'SwapCached', 'SwapFree', 'SwapTotal', 'Unevictable', 'VmallocChunk', 'VmallocTotal', 'VmallocUsed', 'Writeback', 'WritebackTmp', 'Zswap', 'Zswapped']


def parse_memory_info(file_path):
    result = {}
    try:
        with open(file_path, 'r') as file:
            for line in file:
                parts = line.split()
                
                if len(parts) == 2:
                    name, value = parts
                if len(parts) == 3:
                    name, value, kb = parts
                if len(parts) > 3:
                    name = parts[0]
                    value = ' '.join(parts[1:])

                value = str(value)
                name = name.replace(":", "")
                # Append to the result list
                result[name] = value
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"Error: {e}")

    return result


def get_csv_line(parsed_mem_info):
    try:
        # Get the sorted values from the dictionary
        sorted_keys = sorted(parsed_mem_info.keys())

        csv_string = ""
        separator = ""
        # Convert the sorted values to some separated thing
        for key in known_keys:
            if key in parsed_mem_info:
                csv_string += separator + f"'{parsed_mem_info[key]}'"
            else:
                csv_string += separator + separator
            separator = ","

        return csv_string
    except Exception as e:
        print(f"Error: {e}")
        return None

def get_query_specific_values(benchmark_name, benchmark, system, run, query):
    benchmark_name_quoted = f"\'{benchmark_name}'"
    benchmark_quoted = f"'{benchmark}'"
    system_quoted = f"'{system}'"
    run_quoted = f"'{run}'"
    query_quoted = f"'{query}'"
    return ",".join([benchmark_name_quoted, benchmark_quoted, system_quoted, run_quoted, query_quoted])


def poll_meminfo_duckdb(data_db, lock_file, benchmark_name, benchmark, system, run, query):
    # create the table if not exists

    con = duckdb.connect(data_db)

    benchmark_identifiers = get_query_specific_values(benchmark_name, benchmark, system, run, query)
    while os.path.exists(lock_file):
        parsed_mem_info = parse_memory_info(MEM_INFO_FILE)

        now = time.time()
        log = benchmark_identifiers + "," + str(now) + "," + get_csv_line(parsed_mem_info) + "\n"
        con.sql(f"INSERT INTO time_info VALUES ({log})")

        # Wait for 0.2 seconds before polling again
        time.sleep(0.2)

    con.close()


if __name__ == "__main__":
    if len(sys.argv) != 8:
        print("Usage: python poll_memory.py data_db lock_file benchark_name benchmark system run query")

    data_db = sys.argv[1]
    lock_file = sys.argv[2]
    benchmark_name = sys.argv[3]
    benchmark = sys.argv[4]
    system = sys.argv[5]
    run = sys.argv[6]
    query = sys.argv[7]
    poll_meminfo_duckdb(data_db, lock_file, benchmark_name, benchmark, system, run, query)

