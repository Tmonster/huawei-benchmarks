rm -rf mount
sudo mkfs -t xfs -f /dev/nvme1n1
sudo mkdir /mount
sudo mount /dev/nvme1n1 /mount
sudo chown -R ubuntu /mount
cd /mount
git clone https://github.com/Tmonster/memory-pressure-benchmarks.git
cd memory-pressure-benchmarks
# wget https://duckdb-blobs.s3.amazonaws.com/data/tpch-sf100.db --output-document=tpch-sf100.duckdb
# wget https://duckdb-blobs.s3.amazonaws.com/data/tpcds_sf100.db --output-document=tpcds-sf100.duckdb

# after this download postgres and move all the files to /mount/postgres
# modify the sudo vi /etc/postgresql/9.5/main/postgresql.conf file and change the value for data_directory = ''
# to equal something in the mount.

# change all permissions in the mount to postgres, otherwise files cannot be read.
# sudo chown -R postgres:postgres /mount

# this post helped a lot (https://dsmr-reader.readthedocs.io/en/v5/how-to/database/postgresql-change-storage-location.html)