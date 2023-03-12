all:
	mkdir -p ../bin
	gcc -o ../bin/compress compress.c ../include/serial.c
	gcc -o ../bin/decompress decompress.c ../include/serial.c

clean:
	rm -f ../bin/compress
	rm -f ../bin/decompress
