all:
	mkdir -p ./bin

	# nvcc -dc matrixMul.cu
	# nvcc *.o -o ./bin/matrixMul
	# rm -rf *.o

	# nvcc -dc matrixVectorMul.cu
	# nvcc *.o -o ./bin/matrixVectorMul
	# rm -rf *.o

	nvcc -dc vectorAdd.cu
	nvcc *.o -o ./bin/vectorAdd
	rm -rf *.o

clean:
	rm -f ./bin/compress_cuda
	rm -f ./bin/matrixVectorMul
	rm -f ./bin/vectorAdd
