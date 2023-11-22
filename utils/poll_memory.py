import time
import sys
import os

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
        comma = ""
        # Convert the sorted values to a comma-separated string
        for key in known_keys:
            if key in parsed_mem_info:
                csv_string += comma + f"{parsed_mem_info[key]}"
            else:
                csv_string += comma + comma
            comma = ","

        return csv_string
    except Exception as e:
        print(f"Error: {e}")
        return None


def poll_meminfo(mem_file, lock_file):
    # write the header
    mem_info = list(parse_memory_info(MEM_INFO_FILE).keys())
    mem_info.sort()
    header = "Time," + ",".join(mem_info) + "\n"
    with open(mem_file, 'a+') as file:
            file.write(header)

    while os.path.exists(lock_file):
        parsed_mem_info = parse_memory_info(MEM_INFO_FILE)

        now = time.time()
        log = str(now) + "," + get_csv_line(parsed_mem_info) + "\n"

        with open(mem_file, 'a+') as file:
            file.write(log)

        # Wait for 0.2 seconds before polling again
        time.sleep(0.2)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python poll_memory.py mem_file lock_file")
    poll_meminfo(sys.argv[1], sys.argv[2])
