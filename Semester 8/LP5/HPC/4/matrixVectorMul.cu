#include <time.h>

#include <cmath>
#include <cstdlib>
#include <iostream>

#define checkCudaErrors(call)                                                                 \
    do {                                                                                      \
        cudaError_t err = call;                                                               \
        if (err != cudaSuccess) {                                                             \
            printf("CUDA error at %s %d: %s\n", __FILE__, __LINE__, cudaGetErrorString(err)); \
            exit(EXIT_FAILURE);                                                               \
        }                                                                                     \
    } while (0)

using namespace std;

__global__ void matrixVectorMultiplication(int *a, int *b, int *c, int n) {
    int row = threadIdx.x + blockDim.x * blockIdx.x;
    int sum = 0;

    if (row < n)
        for (int j = 0; j < n; j++) {
            sum = sum + a[row * n + j] * b[j];
        }

    c[row] = sum;
}

int main() {
    int *a, *b, *c;
    int *a_dev, *b_dev, *c_dev;
    int n = 10;

    a = new int[n * n];
    b = new int[n];
    c = new int[n];
    int *d = new int[n];
    int size = n * sizeof(int);
    checkCudaErrors(cudaMalloc(&a_dev, size * size));
    checkCudaErrors(cudaMalloc(&b_dev, size));
    checkCudaErrors(cudaMalloc(&c_dev, size));

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i * n + j] = rand() % 10;
        }
        b[i] = rand() % 10;
    }

    cout << "Given matrix is =>\n";
    for (int row = 0; row < n; row++) {
        for (int col = 0; col < n; col++) {
            cout << a[row * n + col] << " ";
        }
        cout << "\n";
    }
    cout << "\n";

    cout << "Given vector is =>\n";
    for (int i = 0; i < n; i++) {
        cout << b[i] << ", ";
    }
    cout << "\n\n";

    cudaEvent_t start, end;

    checkCudaErrors(cudaEventCreate(&start));
    checkCudaErrors(cudaEventCreate(&end));

    checkCudaErrors(cudaMemcpy(a_dev, a, size * size, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaMemcpy(b_dev, b, size, cudaMemcpyHostToDevice));

    dim3 threadsPerBlock(n, n);
    dim3 blocksPerGrid(1, 1);

    checkCudaErrors(cudaEventRecord(start));
    matrixVectorMultiplication<<<blocksPerGrid, threadsPerBlock>>>(a_dev, b_dev, c_dev, n);

    checkCudaErrors(cudaEventRecord(end));
    checkCudaErrors(cudaEventSynchronize(end));

    float time = 0.0;
    checkCudaErrors(cudaEventElapsedTime(&time, start, end));

    checkCudaErrors(cudaMemcpy(c, c_dev, size, cudaMemcpyDeviceToHost));

    // CPU matrixVector multiplication
    int sum = 0;
    for (int row = 0; row < n; row++) {
        sum = 0;
        for (int col = 0; col < n; col++) {
            sum = sum + a[row * n + col] * b[col];
        }
        d[row] = sum;
    }

    cout << "CPU product is =>\n";
    for (int i = 0; i < n; i++) {
        cout << d[i] << ", ";
    }
    cout << "\n\n";

    cout << "GPU product is =>\n";
    for (int i = 0; i < n; i++) {
        cout << c[i] << ", ";
    }
    cout << "\n\n";

    int error = 0;
    for (int i = 0; i < n; i++) {
        error += d[i] - c[i];
        if (0 != (d[i] - c[i])) {
            cout << "Error at (" << i << ") => GPU: " << c[i] << ", CPU: " << d[i] << "\n";
        }
    }

    cout << "Error: " << error;
    cout << "\nTime Elapsed: " << time;

    return 0;
}

/*

OUTPUT:

Given matrix is =>
3 6 7 5 3 5 6 2 9 1
7 0 9 3 6 0 6 2 6 1
7 9 2 0 2 3 7 5 9 2
8 9 7 3 6 1 2 9 3 1
4 7 8 4 5 0 3 6 1 0
3 2 0 6 1 5 5 4 7 6
6 9 3 7 4 5 2 5 4 7
4 3 0 7 8 6 8 8 4 3
4 9 2 0 6 8 9 2 6 6
9 5 0 4 8 7 1 7 2 7

Given vector is =>
2, 8, 2, 9, 6, 5, 4, 1, 4, 2,

CPU product is =>
220, 147, 190, 201, 168, 171, 245, 235, 234, 210,

GPU product is =>
220, 147, 190, 201, 168, 171, 245, 235, 234, 210,

Error: 0
Time Elapsed: 0.014336

*/
