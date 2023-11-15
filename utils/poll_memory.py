import time
import sys
import os

def parse_memory_info(file_path):
    result = {}

    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Split each line into name and value using whitespace as a separator
                parts = line.split()
                
                # Skip lines that don't have the expected format
                if len(parts) == 2:
                    name, value = parts
                if len(parts) == 3:
                    name, value, kb = parts
                    value = str(value) + str(kb)
                
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

        csv_string = f"{parsed_mem_info[sorted_keys[0]]},"
        # Convert the sorted values to a comma-separated string
        for key in sorted_keys[1:]:
            csv_string += f",{parsed_mem_info[key]}"

        return csv_string
    except Exception as e:
        print(f"Error: {e}")
        return None


def poll_meminfo(mem_file, lock_file):
    # write the header
    mem_info = list(parse_memory_info('tmp_meminfo').keys())
    mem_info.sort()
    header = "time," + ",".join(mem_info) + "\n"
    with open(mem_file, 'a+') as file:
            file.write(header)

    while os.path.exists(lock_file):
        parsed_mem_info = parse_memory_info('tmp_meminfo')

        now = time.time()
        log = str(now) + "," + get_csv_line(parsed_mem_info)

        with open(mem_file, 'a+') as file:
            file.write(log)

        # Wait for one second before polling again
        time.sleep(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python poll_memory.py mem_file lock_file")
    poll_meminfo(sys.argv[1], sys.argv[2])
