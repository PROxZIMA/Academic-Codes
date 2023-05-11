mm:
	mkdir -p ./bin

	nvcc -dc matrixMul.cu
	nvcc *.o -o ./bin/matrixMul && ./bin/matrixMul
	rm -rf *.o

mvm:
	mkdir -p ./bin

	nvcc -dc matrixVectorMul.cu
	nvcc *.o -o ./bin/matrixVectorMul && ./bin/matrixVectorMul
	rm -rf *.o

va:
	mkdir -p ./bin

	nvcc -dc vectorAdd.cu
	nvcc *.o -o ./bin/vectorAdd && ./bin/vectorAdd
	rm -rf *.o

clean:
	rm -rd ./bin/
