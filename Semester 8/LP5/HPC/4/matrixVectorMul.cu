#include <time.h>

#include <cmath>
#include <cstdlib>
#include <iostream>
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
    int n = 32;

    a = new int[n * n];
    b = new int[n];
    c = new int[n];
    int *d = new int[n];
    int size = n * sizeof(int);
    cudaMalloc(&a_dev, size * size);
    cudaMalloc(&b_dev, size);
    cudaMalloc(&c_dev, size);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i * n + j] = i * n + j + 1;  // rand()%n;
        }

        b[i] = i + 1;  // rand()%n;
        // cout<<a[i]<<" ";
        // d[i]=a[i]+b[i];
    }

    cudaEvent_t start, end;

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    cudaMemcpy(a_dev, a, size * size, cudaMemcpyHostToDevice);
    cudaMemcpy(b_dev, b, size, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(n, n);
    dim3 blocksPerGrid(1, 1);

    if (n * n > 512) {
        threadsPerBlock.x = 512;
        threadsPerBlock.y = 512;
        blocksPerGrid.x = ceil((double)n / (double)threadsPerBlock.x);
        blocksPerGrid.y = ceil((double)n / (double)threadsPerBlock.y);
    }

    cudaEventRecord(start);
    matrixVectorMultiplication<<<blocksPerGrid, threadsPerBlock>>>(a_dev, b_dev, c_dev, n);

    cudaEventRecord(end);
    cudaEventSynchronize(end);

    float time = 0.0;
    cudaEventElapsedTime(&time, start, end);

    cudaMemcpy(c, c_dev, size, cudaMemcpyDeviceToHost);
    cout << "\nGPU Time Elapsed:  " << time;

    // CPU matrixVector multiplication
    clock_t t = clock();
    int sum = 0;
    for (int row = 0; row < n; row++) {
        sum = 0;
        for (int col = 0; col < n; col++) {
            sum = sum + a[row * n + col] * b[col];
        }
        d[row] = sum;
    }
    t = clock() - t;
    cout << "\nCPU Time Elapsed:  " << ((double)t);  //((double)t)/CLOCKS_PER_SEC;

    int error = 0;
    for (int i = 0; i < n; i++) {
        error += d[i] - c[i];
        // cout<<" gpu "<<c[i]<<" CPU "<<d[i]<<endl;
    }

    cout << "Error : " << error;

    return 0;
}
