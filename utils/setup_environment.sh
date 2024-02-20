

git clone https://github.com/Tmonster/memory-pressure-benchmarks

git clone https://github.com/duckdb/duckdb
sudo apt-get install -y -qq ninja-build build-essential make cmake
cd duckdb
GEN=ninja BUILD_TPCH=1 make 
cd ..