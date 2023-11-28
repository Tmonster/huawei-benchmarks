# script to format mount and copy data.

# remove a leftover instance mount
rm -rf huawei-benchmarks-metal

# format the mount
sudo mkfs -t xfs /dev/nvme2n1

mkdir huawei-benchmarks-metal
# mount the nvme volumn
sudo mount /dev/nvme2n1 huawei-benchmarks-metal
# change ownsership of the volume
sudo chown -R ubuntu huawei-benchmarks-metal/

git clone https://github.com/Tmonster/huawei-benchmarks.git huawei-benchmarks-metal

# if you have an EBS volume, you can generate the data once, save it on the ebs volume, and transfer it
# each time.

if [[ $# -gt 0 ]]
then
	echo "Creating data"
	cd huawei-benchmarks
	duckdb tpch-sf100.duckdb -c "install httpfs; load httpfs; call dbgen(sf=100);"
	duckdb tpch-sf100.duckdb -c "export database 'tpch_data' (FORMAT CSV, HEADER 1);"
	python3 hyper/load.py
	cd ../huawei-benchmarks-metal
	cp ../huawei-benchmarks/tpch-sf100.duckdb .
	cp ../huawei-benchmarks/tpch-sf100.hyper .
elif [[ ! -d "huawei-benchmarks-metal" ]]
then
	echo "no arguments passed. Copying data..."
	echo "ERROR: directory ./huawei-benchmarks-metal does not exist"
else
	cd huawei-benchmarks-metal/
	cp ../huawei-benchmarks/tpch-sf100.duckdb .
	cp ../huawei-benchmarks/tpch-sf100.hyper .
	cd ..
fi
