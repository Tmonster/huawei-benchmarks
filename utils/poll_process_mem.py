import time
import sys
import os
import duckdb
import re

def get_proc_status_file(pid):
    return f"/proc/{pid}/status"

known_keys = ['Name', 'Umask', 'State', 'Tgid', 'Ngid', 'Pid', 'PPid', 'TracerPid', 'Uid', 'Gid', 'FDSize', 'Groups', 'NStgid', 'NSpid', 'NSpgid', 'NSsid', 'VmPeak', 'VmSize', 'VmLck', 'VmPin', 'VmHWM', 'VmRSS', 'RssAnon', 'RssFile', 'RssShmem', 'VmData', 'VmStk', 'VmExe', 'VmLib', 'VmPTE', 'VmSwap', 'HugetlbPages', 'CoreDumping', 'THP_enabled', 'Threads', 'SigQ', 'SigPnd', 'ShdPnd', 'SigBlk', 'SigIgn', 'SigCgt', 'CapInh', 'CapPrm', 'CapEff', 'CapBnd', 'CapAmb', 'NoNewPrivs', 'Seccomp', 'Seccomp_filters', 'Speculation_Store_Bypass', 'SpeculationIndirectBranch', 'Cpus_allowed', 'Cpus_allowed_list', 'Mems_allowed', 'Mems_allowed_list', 'voluntary_ctxt_switches', 'nonvoluntary_ctxt_switches']


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
                    continue
                value = str(value)
                name = name.replace(":", "")
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
        separator = ","
        # Convert the sorted values to some separated thing
        for key in known_keys:
            if key in parsed_mem_info:
                csv_string += f"'{parsed_mem_info[key]}'" + separator
            else:
                csv_string += "''" + separator
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


def poll_meminfo_duckdb(data_db, lock_file, benchmark_name, benchmark, system, run, query, pid):
    # create the table if not exists

    con = duckdb.connect(data_db)

    benchmark_identifiers = get_query_specific_values(benchmark_name, benchmark, system, run, query)
    while os.path.exists(lock_file):
        process_status_file = get_proc_status_file(pid)
        parsed_mem_info = parse_memory_info(process_status_file)

        now = time.time()
        log = benchmark_identifiers + "," + str(now) + "," + get_csv_line(parsed_mem_info) + "\n"
        con.sql(f"INSERT INTO proc_mem_info VALUES ({log})")

        # Wait for 0.2 seconds before polling again
        time.sleep(0.2)

    con.close()


if __name__ == "__main__":
    if len(sys.argv) != 9:
        print("Usage: python poll_process_mem.py data_db lock_file benchark_name benchmark system run query pid")

    data_db = sys.argv[1]
    lock_file = sys.argv[2]
    benchmark_name = sys.argv[3]
    benchmark = sys.argv[4]
    system = sys.argv[5]
    run = sys.argv[6]
    query = sys.argv[7]
    pid = sys.argv[8]
    poll_meminfo_duckdb(data_db, lock_file, benchmark_name, benchmark, system, run, query, pid)

