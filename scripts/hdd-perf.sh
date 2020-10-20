#!/bin/bash

echo "Doing tests in $(pwd)"
echo ""
sleep 20

apk add coreutils > /dev/null

echo "###########################################"
echo "# Streaming IO tests with dd              #"
echo "###########################################"
echo ""
echo "Test 1: Write 1GB with dd (use direct I/O for data)"
dd if=/dev/zero of=./testfile bs=1G count=1 oflag=direct | grep copied
echo ""
echo "Test 2: Write 1GB with dd (use synchronized I/O for data)"
dd if=/dev/zero of=./testfile bs=1G count=1 oflag=dsync | grep copied
echo ""
# Für den Test werden 1 GB geschrieben. sync (likewise, but also for metadata)
echo "Test 3: Write 1GB with dd (likewise, but also for metadata)"
dd if=/dev/zero of=./testfile bs=1G count=1 oflag=sync | grep copied
echo ""
echo ""
echo ""


echo "###########################################"
echo "# Latency tests with dd                   #"
echo "###########################################"
echo ""
echo "Test 1: Write 1000x 512 byte with dd (use direct I/O for data)"
dd if=/dev/zero of=./testfile bs=512 count=1000 oflag=direct
echo ""
echo "Test 2: Write 1000x 512 byte with dd (use synchronized I/O for data)"
dd if=/dev/zero of=./testfile bs=512 count=1000 oflag=dsync
echo ""
echo "Test 3: Write 1000x 512 byte with dd (likewise, but also for metadata)"
dd if=/dev/zero of=./testfile bs=512 count=1000 oflag=sync
echo ""
echo ""
echo ""

rm -f ./testfile

echo "###########################################"
echo "# fio tests                               #"
echo "###########################################"
echo ""

echo "Test 1: This will create a 4 GB file, and perform 4KB reads and writes using a 75%/25% (ie 3 reads are performed for every 1 write) split within the file, with 64 operations running at a time. The 3:1 ratio is a rough approximation of your typical database."
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=./test --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75
echo ""

echo "Test 2: To measure random reads, use slightly altered FIO command."
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=./test --bs=4k --iodepth=64 --size=4G --readwrite=randread
echo ""

echo "Test 3: Again, just modify the FIO command slightly so we perform randwrite instead of randread"
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=./test --bs=4k --iodepth=64 --size=4G --readwrite=randwrite
echo ""
echo ""
echo ""

rm -f ./test

echo "###########################################"
echo "# IOPing test                             #"
echo "###########################################"
echo ""

echo "Test 1: Measuring latency with IOPing"
ioping -c 10 .
echo ""
echo ""
echo ""

echo "###########################################"
echo "# ioZone test                             #"
echo "###########################################"
echo ""


# ioZone
echo "Test 1: Doing a ioZone test in automatic mode. This creates temporary test files from sizes 64k to 512MB for performance testing. This mode also uses 4k to 16M of record sizes for read and write (more on this later) testing. Export as ./result.xls"
iozone -a -b result.xls
