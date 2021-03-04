all: rocksdb libuv
	@g++ -O2 -std=c++11 $(FLAGS) \
		-DROCKSDB_VERSION="\"6.15.5"\" \
		-DSERVER_VERSION="\"0.1.0"\" \
		-DLIBUV_VERSION="\"1.10.1"\" \
		-Isrc/rocksdb-6.15.5/include/ \
		-Isrc/libuv-1.10.1/build/include/ \
		-pthread \
		-o rocksdb-server \
		src/server.cc src/client.cc src/exec.cc src/match.cc src/util.cc \
		src/rocksdb-6.15.5/librocksdb.a \
		src/rocksdb-6.15.5/libbz2.a \
		src/rocksdb-6.15.5/libz.a \
		src/rocksdb-6.15.5/libsnappy.a \
		src/rocksdb-6.15.5/libzstd.a \
		src/libuv-1.10.1/build/lib/libuv.a
clean:
	rm -f rocksdb-server
	rm -rf src/libuv-1.10.1/
	rm -rf src/rocksdb-6.15.5/
install: all
	cp rocksdb-server /usr/local/bin
uninstall: 
	rm -f /usr/local/bin/rocksdb-server

# libuv
libuv: src/libuv-1.10.1/build/lib/libuv.a
src/libuv-1.10.1/build/lib/libuv.a:
	cd src && tar xf libuv-1.10.1.tar.gz
	cd src/libuv-1.10.1 && sh autogen.sh
	mkdir -p src/libuv-1.10.1/build
	cd src/libuv-1.10.1/build && ../configure --prefix=$$(pwd)
	make -C src/libuv-1.10.1/build install


# rocksdb
rocksdb: src/rocksdb-6.15.5 \
	src/rocksdb-6.15.5/librocksdb.a \
	src/rocksdb-6.15.5/libz.a \
	src/rocksdb-6.15.5/libbz2.a \
	src/rocksdb-6.15.5/libsnappy.a \
	src/rocksdb-6.15.5/libzstd.a
src/rocksdb-6.15.5:
	cd src && tar xf rocksdb-6.15.5.tar.gz
src/rocksdb-6.15.5/librocksdb.a:
	DEBUG_LEVEL=0 make -C src/rocksdb-6.15.5 static_lib
src/rocksdb-6.15.5/libz.a:
	DEBUG_LEVEL=0 make -C src/rocksdb-6.15.5 libz.a
src/rocksdb-6.15.5/libbz2.a:
	DEBUG_LEVEL=0 make -C src/rocksdb-6.15.5 libbz2.a
src/rocksdb-6.15.5/libsnappy.a:
	DEBUG_LEVEL=0 make -C src/rocksdb-6.15.5 libsnappy.a
src/rocksdb-6.15.5/libzstd.a:
	DEBUG_LEVEL=0 make -C src/rocksdb-6.15.5 libzstd.a

