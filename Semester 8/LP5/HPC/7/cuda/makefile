all:
	mkdir -p ../bin
	nvcc -dc compress.cu ../include/parallel.cu kernel.cu gpu_wrapper.cu
	nvcc *.o -o ../bin/compress_cuda
	rm -rf *.o

clean:
	rm -f ../bin/compress_cuda
