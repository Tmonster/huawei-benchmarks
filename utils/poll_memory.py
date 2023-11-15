import time

def poll_meminfo():
    # instead of while true, make it 
    # while some_tpch_run_file_exists:
    while True:
        # Open and read the contents of '/proc/meminfo'
        with open('/proc/meminfo', 'r') as meminfo_file:
            meminfo_data = meminfo_file.read()

        # Print the contents (you can modify this part as per your needs)
        print(meminfo_data)

        # Wait for one second before polling again
        time.sleep(1)

if __name__ == "__main__":
    poll_meminfo()
