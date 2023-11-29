# script to format mount and copy data.

# remove a leftover instance mount
rm -rf memory-pressure-benchmarks-metal

# format the mount
sudo mkfs -t xfs /dev/nvme2n1

mkdir memory-pressure-benchmarks-metal
# mount the nvme volumn
sudo mount /dev/nvme2n1 memory-pressure-benchmarks-metal
# change ownsership of the volume
sudo chown -R ubuntu memory-pressure-benchmarks-metal/

git clone https://github.com/Tmonster/memory-pressure-benchmarks.git memory-pressure-benchmarks-metal

# if you have an EBS volume, you can generate the data once, save it on the ebs volume, and transfer it
# each time.

if [[ $# -gt 0 ]]
then
	echo "Creating data"
	cd memory-pressure-benchmarks
	duckdb tpch-sf100.duckdb -c "install httpfs; load httpfs; call dbgen(sf=100);"
	duckdb tpch-sf100.duckdb -c "export database 'tpch_data' (FORMAT CSV, HEADER 1);"
	python3 hyper/load.py
	cd ../memory-pressure-benchmarks-metal
	cp ../memory-pressure-benchmarks/tpch-sf100.duckdb .
	cp ../memory-pressure-benchmarks/tpch-sf100.hyper .
elif [[ ! -d "memory-pressure-benchmarks-metal" ]]
then
	echo "no arguments passed. Copying data..."
	echo "ERROR: directory ./memory-pressure-benchmarks-metal does not exist"
else
	cd memory-pressure-benchmarks-metal/
	cp ../memory-pressure-benchmarks/tpch-sf100.duckdb .
	cp ../memory-pressure-benchmarks/tpch-sf100.hyper .
	cd ..
fi
