# script to format mount and copy data.

cwd=$(pwd)

parent=$(pwd)/..

if [[ ! -d "$parent/memory-pressure-benchmarks" ]]
then
	echo "Please rename current directory to memory-pressure-benchmarks"
	exit 0
fi

# remove a leftover instance mount
rm -rf $parent/memory-pressure-benchmarks-metal

# format the mount
sudo mkfs -t xfs -f /dev/nvme2n1

mkdir -p $parent/memory-pressure-benchmarks-metal
# mount the nvme volumn
sudo mount /dev/nvme2n1 $parent/memory-pressure-benchmarks-metal
# change ownsership of the volume
sudo chown -R ubuntu $parent/memory-pressure-benchmarks-metal/

git clone https://github.com/Tmonster/memory-pressure-benchmarks.git $parent/memory-pressure-benchmarks-metal

# if you have an EBS volume, you can generate the data once, save it on the ebs volume, and transfer it
# each time.

if [[ $# -gt 0 ]]
then
	echo "Creating data"
	cd $parent/memory-pressure-benchmarks
	wget https://duckdb-blobs.s3.amazonaws.com/data/tpch-sf100.db --output-document=tpch-sf100.duckdb
	mv tpch-sf100.db tpch-sf100.duckdb
	duckdb tpch-sf100.duckdb -c "export database 'tpch_data' (FORMAT CSV, HEADER 1);"
	python3 hyper/load.py
	cd $parent/memory-pressure-benchmarks-metal
	cp $parent/memory-pressure-benchmarks/tpch-sf100.duckdb .
	cp $parent/memory-pressure-benchmarks/tpch-sf100.hyper .
elif [[ ! -d "$parent/memory-pressure-benchmarks-metal" ]]
then
	echo "ERROR: directory $parent/memory-pressure-benchmarks-metal does not exist"
else
	echo "no arguments passed. Copying data..."
	cd $parent/memory-pressure-benchmarks-metal/
	cp $parent/memory-pressure-benchmarks/tpch-sf100.duckdb .
	cp $parent/memory-pressure-benchmarks/tpch-sf100.hyper .
	cd ..
fi
