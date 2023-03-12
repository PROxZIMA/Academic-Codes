/*
 * GPU wrapper implementations
 * GPU launch function implementation
 * loads the data on the device
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../include/color.h"
#include "../include/parallel.h"

#define BLOCK_SIZE 1024
#define DEBUG 1
#define NUM_BYTES 10240

__constant__ unsigned char device_bitSequenceConstMemory[256][255];

/*
 * Main launching function to load the data on the device
 */
void launchCudaHuffmanCompress(unsigned char *inputFileData, unsigned int *compressedDataOffset,
                               unsigned int inputFileLength, int numberOfKernels,
                               unsigned int integerOverflowFlag, long unsigned int memoryRequired) {
    struct huffmanDictionary *device_huffmanDictionary;
    unsigned char *device_inputFileData, *device_byteCompressedData;
    unsigned int *device_compressedDataOffset;
    unsigned int *gpuBitPaddingFlag, *bitPaddingFlag;
    unsigned int *gpuMemoryOverflowIndex, *integerOverflowIndex;
    long unsigned int memoryFree, memoryTotal;
    cudaError_t error;

    // generating the offset
    // no integer overflow
    if (integerOverflowFlag == 0) {
        // single run no overflow
        if (numberOfKernels == 1) {
            createDataOffsetArray(compressedDataOffset, inputFileData, inputFileLength);
        }

        // multiple run with no overflow [big files]
        else {
            gpuBitPaddingFlag = (unsigned int *)calloc(numberOfKernels, sizeof(unsigned int));
            gpuMemoryOverflowIndex =
                (unsigned int *)calloc(numberOfKernels * 2, sizeof(unsigned int));
            createDataOffsetArray(compressedDataOffset, inputFileData, inputFileLength,
                                  gpuMemoryOverflowIndex, gpuBitPaddingFlag, memoryRequired);
        }
    }

    // integer overflow
    else {
        // single run overflow
        if (numberOfKernels == 1) {
            bitPaddingFlag = (unsigned int *)calloc(numberOfKernels, sizeof(unsigned int));
            integerOverflowIndex =
                (unsigned int *)calloc(numberOfKernels * 2, sizeof(unsigned int));
            createDataOffsetArray(compressedDataOffset, inputFileData, inputFileLength);
        }

        // multiple run overflow
        else {
            gpuBitPaddingFlag = (unsigned int *)calloc(numberOfKernels, sizeof(unsigned int));
            bitPaddingFlag = (unsigned int *)calloc(numberOfKernels, sizeof(unsigned int));
            integerOverflowIndex =
                (unsigned int *)calloc(numberOfKernels * 2, sizeof(unsigned int));
            gpuMemoryOverflowIndex =
                (unsigned int *)calloc(numberOfKernels * 2, sizeof(unsigned int));
            createDataOffsetArray(compressedDataOffset, inputFileData, inputFileLength,
                                  integerOverflowIndex, bitPaddingFlag, gpuMemoryOverflowIndex,
                                  gpuBitPaddingFlag, NUM_BYTES, memoryRequired);
        }
    }

    // gpu initiation
    {
        // memory allocation
        error = cudaMalloc((void **)&device_inputFileData, inputFileLength * sizeof(unsigned char));
        if (error != cudaSuccess)
            printf("\n%sError 1 :: %s", COLOR_ERROR, cudaGetErrorString(error));

        error = cudaMalloc((void **)&device_compressedDataOffset,
                           (inputFileLength + 1) * sizeof(unsigned int));
        if (error != cudaSuccess) printf("\nError 2 :: %s", cudaGetErrorString(error));

        error = cudaMalloc((void **)&device_huffmanDictionary, sizeof(huffmanDictionary));
        if (error != cudaSuccess) printf("\nError 3 :: %s", cudaGetErrorString(error));

        // memory copy to device
        error = cudaMemcpy(device_inputFileData, inputFileData,
                           inputFileLength * sizeof(unsigned char), cudaMemcpyHostToDevice);
        if (error != cudaSuccess) printf("\nError 4 :: %s", cudaGetErrorString(error));

        error = cudaMemcpy(device_compressedDataOffset, compressedDataOffset,
                           (inputFileLength + 1) * sizeof(unsigned int), cudaMemcpyHostToDevice);
        if (error != cudaSuccess) printf("\nError 5 :: %s", cudaGetErrorString(error));

        error = cudaMemcpy(device_huffmanDictionary, &huffmanDictionary, sizeof(huffmanDictionary),
                           cudaMemcpyHostToDevice);
        if (error != cudaSuccess) printf("\nError 6 :: %s", cudaGetErrorString(error));

        // constant memory if required
        if (constMemoryFlag == 1) {
            error = cudaMemcpyToSymbol(device_bitSequenceConstMemory, bitSequenceConstMemory,
                                       265 * 255 * sizeof(unsigned char));
            if (error != cudaSuccess) printf("\nError Constant :: %s", cudaGetErrorString(error));
        }
    }

    // Single run
    if (numberOfKernels == 1) {
        // no overflow
        if (integerOverflowFlag == 0) {
            error = cudaMalloc((void **)&device_byteCompressedData,
                               (compressedDataOffset[inputFileLength]) * sizeof(unsigned char));
            if (error != cudaSuccess) printf("\nError 7 :: %s", cudaGetErrorString(error));

            // initialize device_byteCompressedData
            error = cudaMemset(device_byteCompressedData, 0,
                               compressedDataOffset[inputFileLength] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("\nError 8 :: %s", cudaGetErrorString(error));

            // debug
            if (1) {
                cudaMemGetInfo(&memoryFree, &memoryTotal);
                printf("\nFree Mem: %lu", memoryFree);
            }

            // run kernel
            compress<<<1, BLOCK_SIZE>>>(device_inputFileData, device_compressedDataOffset,
                                        device_huffmanDictionary, device_byteCompressedData,
                                        inputFileLength, constMemoryFlag);
            cudaError_t error_kernel = cudaGetLastError();
            if (error_kernel != cudaSuccess)
                printf("\nError Kernel 1 :: %s", cudaGetErrorString(error));

            // copy compressed data from GPU to CPU memory
            error =
                cudaMemcpy(inputFileData, device_inputFileData,
                           ((compressedDataOffset[inputFileLength] / 8)) * sizeof(unsigned char),
                           cudaMemcpyDeviceToHost);
            if (error != cudaSuccess) printf("\nError 9 :: %s", cudaGetErrorString(error));

            // free allocated memory
            cudaFree(device_inputFileData);
            cudaFree(device_compressedDataOffset);
            cudaFree(device_huffmanDictionary);
            cudaFree(device_byteCompressedData);
        }

        // with overflow
        else {
            // additional variable to store offset data after integer oveflow
            unsigned char *device_byteCompressedDataOverflow;

            // allocate memory to store offset information
            error =
                cudaMalloc((void **)&device_byteCompressedData,
                           compressedDataOffset[integerOverflowIndex[0]] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 10 :: %s\n", cudaGetErrorString(error));

            error = cudaMalloc((void **)&device_byteCompressedDataOverflow,
                               compressedDataOffset[inputFileLength] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 11 :: %s\n", cudaGetErrorString(error));

            // initialize offset data
            error =
                cudaMemset(device_byteCompressedData, 0,
                           compressedDataOffset[integerOverflowIndex[0]] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 12 :: %s\n", cudaGetErrorString(error));

            error = cudaMemset(device_byteCompressedDataOverflow, 0,
                               compressedDataOffset[inputFileLength] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 13 :: %s\n", cudaGetErrorString(error));

            // debug
            if (1) {
                cudaMemGetInfo(&memoryFree, &memoryTotal);
                printf("Free Mem :: %lu\n", memoryFree);
            }

            // launch kernel
            compress<<<1, BLOCK_SIZE>>>(device_inputFileData, device_compressedDataOffset,
                                        device_huffmanDictionary, device_byteCompressedData,
                                        device_byteCompressedDataOverflow, inputFileLength,
                                        constMemoryFlag, integerOverflowIndex[0]);

            // check status
            cudaError_t error_kernel = cudaGetLastError();
            if (error_kernel != cudaSuccess)
                printf("\nError Kernel 2: %s", cudaGetErrorString(error_kernel));

            // get output data
            if (bitPaddingFlag[0] == 0) {
                error = cudaMemcpy(
                    inputFileData, device_inputFileData,
                    (compressedDataOffset[integerOverflowIndex[0]] / 8) * sizeof(unsigned char),
                    cudaMemcpyDeviceToHost);
                if (error != cudaSuccess) printf("Error 14 :: %s\n", cudaGetErrorString(error));

                error = cudaMemcpy(
                    &inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8)],
                    &device_inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8)],
                    ((compressedDataOffset[inputFileLength] / 8)) * sizeof(unsigned char),
                    cudaMemcpyDeviceToHost);
                if (error != cudaSuccess) printf("Error 15 :: %s\n", cudaGetErrorString(error));
            } else {
                error = cudaMemcpy(
                    inputFileData, device_inputFileData,
                    (compressedDataOffset[integerOverflowIndex[0]] / 8) * sizeof(unsigned char),
                    cudaMemcpyDeviceToHost);
                if (error != cudaSuccess) printf("Error 16 :: %s\n", cudaGetErrorString(error));

                unsigned char temp_compByte =
                    inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8) - 1];

                error = cudaMemcpy(
                    &inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8) - 1],
                    &device_inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8)],
                    ((compressedDataOffset[inputFileLength] / 8)) * sizeof(unsigned char),
                    cudaMemcpyDeviceToHost);
                if (error != cudaSuccess) printf("Error 17 :: %s\n", cudaGetErrorString(error));

                inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8) - 1] =
                    temp_compByte |
                    inputFileData[(compressedDataOffset[integerOverflowIndex[0]] / 8) - 1];
            }

            // free allocated memory
            cudaFree(device_inputFileData);
            cudaFree(device_compressedDataOffset);
            cudaFree(device_huffmanDictionary);
            cudaFree(device_byteCompressedData);
            cudaFree(device_byteCompressedDataOverflow);
        }
    }

    // multiple run
    else {
        // no overflow
        if (integerOverflowFlag == 0) {
            error = cudaMalloc(
                (void **)&device_byteCompressedData,
                (compressedDataOffset[gpuMemoryOverflowIndex[1]]) * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 18 :: %s\n", cudaGetErrorString(error));

            // debug
            if (1) {
                cudaMemGetInfo(&memoryFree, &memoryTotal);
                printf("\nFree Mem: %lu\n", memoryFree);
            }

            unsigned int pos = 0;
            for (unsigned int i = 0; i < numberOfKernels; i++) {
                // initialize d_byteCompressedData
                error = cudaMemset(
                    device_byteCompressedData, 0,
                    compressedDataOffset[gpuMemoryOverflowIndex[1]] * sizeof(unsigned char));
                if (error != cudaSuccess) printf("Error 19 :: %s\n", cudaGetErrorString(error));

                compress<<<1, BLOCK_SIZE>>>(device_inputFileData, device_compressedDataOffset,
                                            device_huffmanDictionary, device_byteCompressedData,
                                            gpuMemoryOverflowIndex[i * 2], constMemoryFlag,
                                            gpuMemoryOverflowIndex[i * 2 + 1]);
                cudaError_t error_kernel = cudaGetLastError();
                if (error != cudaSuccess) printf("Error 20 :: %s\n", cudaGetErrorString(error));

                if (gpuBitPaddingFlag[i] == 0) {
                    error =
                        cudaMemcpy(&inputFileData[pos], device_inputFileData,
                                   (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) *
                                       sizeof(unsigned char),
                                   cudaMemcpyDeviceToHost);
                    if (error != cudaSuccess) printf("Error 21 :: %s\n", cudaGetErrorString(error));

                    pos += (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8);
                } else {
                    unsigned char temp_compByte = inputFileData[pos - 1];
                    error =
                        cudaMemcpy(&inputFileData[pos - 1], device_inputFileData,
                                   ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                       sizeof(unsigned char),
                                   cudaMemcpyDeviceToHost);
                    if (error != cudaSuccess) printf("Error 22 :: %s\n", cudaGetErrorString(error));

                    inputFileData[pos - 1] = temp_compByte | inputFileData[pos - 1];
                    pos += (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) - 1;
                }
            }

            // free allocated memory
            cudaFree(device_inputFileData);
            cudaFree(device_compressedDataOffset);
            cudaFree(device_huffmanDictionary);
            cudaFree(device_byteCompressedData);
        }

        else {
            // additional variable to store offset data after integer oveflow
            unsigned char *device_byteCompressedDataOverflow;
            error =
                cudaMalloc((void **)&device_byteCompressedDataOverflow,
                           (compressedDataOffset[integerOverflowIndex[0]]) * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 23 :: %s\n", cudaGetErrorString(error));

            error =
                cudaMalloc((void **)&device_byteCompressedDataOverflow,
                           compressedDataOffset[gpuMemoryOverflowIndex[1]] * sizeof(unsigned char));
            if (error != cudaSuccess) printf("Error 22 :: %s\n", cudaGetErrorString(error));

            // debug
            if (1) {
                cudaMemGetInfo(&memoryFree, &memoryTotal);
                printf("Free Mem: %lu\n", memoryFree);
            }

            unsigned int pos = 0;
            for (unsigned int i = 0; i < numberOfKernels; i++) {
                if (integerOverflowIndex[i] != 0) {
                    // initialize device_byteCompressedData
                    error = cudaMemset(
                        device_byteCompressedData, 0,
                        compressedDataOffset[integerOverflowIndex[0]] * sizeof(unsigned char));
                    if (error != cudaSuccess) printf("Error 22 :: %s\n", cudaGetErrorString(error));

                    error = cudaMemset(
                        device_byteCompressedDataOverflow, 0,
                        compressedDataOffset[gpuMemoryOverflowIndex[1]] * sizeof(unsigned char));
                    if (error != cudaSuccess) printf("Error 23 :: %s\n", cudaGetErrorString(error));

                    compress<<<1, BLOCK_SIZE>>>(
                        device_inputFileData, device_compressedDataOffset, device_huffmanDictionary,
                        device_byteCompressedData, device_byteCompressedDataOverflow,
                        gpuMemoryOverflowIndex[i * 2], constMemoryFlag,
                        gpuMemoryOverflowIndex[i * 2 + 1], integerOverflowIndex[i]);
                    cudaError_t error_kernel = cudaGetLastError();
                    if (error_kernel != cudaSuccess)
                        printf("Error kernel 3 :: %s\n", cudaGetErrorString(error_kernel));

                    if (gpuBitPaddingFlag[i] == 0) {
                        if (bitPaddingFlag[i] == 0) {
                            error = cudaMemcpy(&inputFileData[pos], device_inputFileData,
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8) *
                                                   sizeof(unsigned char),
                                               cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 24 :: %s\n", cudaGetErrorString(error));

                            error = cudaMemcpy(
                                &inputFileData[pos +
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                &device_inputFileData[(
                                    compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                    sizeof(unsigned char),
                                cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 25 :: %s\n", cudaGetErrorString(error));

                            pos += (compressedDataOffset[integerOverflowIndex[i]] / 8) +
                                   (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8);
                        } else {
                            error = cudaMemcpy(&inputFileData[pos], device_inputFileData,
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8) *
                                                   sizeof(unsigned char),
                                               cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 26 :: %s\n", cudaGetErrorString(error));

                            unsigned char temp_compByte =
                                inputFileData[pos +
                                              (compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                              1];

                            error = cudaMemcpy(
                                &inputFileData[pos +
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                               1],
                                &device_inputFileData[(
                                    compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                    sizeof(unsigned char),
                                cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 27 :: %s\n", cudaGetErrorString(error));

                            inputFileData[pos +
                                          (compressedDataOffset[integerOverflowIndex[i]] / 8) - 1] =
                                temp_compByte |
                                inputFileData[pos +
                                              (compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                              1];
                            pos += (compressedDataOffset[integerOverflowIndex[i]] / 8) +
                                   (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) -
                                   1;
                        }
                    }

                    // padding is done
                    else {
                        unsigned char temp_gpuCompByte = inputFileData[pos - 1];

                        if (bitPaddingFlag[i] == 0) {
                            error = cudaMemcpy(&inputFileData[pos - 1], device_inputFileData,
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8) *
                                                   sizeof(unsigned char),
                                               cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 28 :: %s\n", cudaGetErrorString(error));

                            error = cudaMemcpy(
                                &inputFileData[pos - 1 +
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                &device_inputFileData[(
                                    compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                    sizeof(unsigned char),
                                cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 29 :: %s\n", cudaGetErrorString(error));

                            inputFileData[pos - 1] = temp_gpuCompByte | inputFileData[pos - 1];
                            pos += (compressedDataOffset[integerOverflowIndex[i]] / 8) +
                                   (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) -
                                   1;
                        } else {
                            error = cudaMemcpy(&inputFileData[pos - 1], device_inputFileData,
                                               (compressedDataOffset[integerOverflowIndex[i]] / 8) *
                                                   sizeof(unsigned char),
                                               cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 30 :: %s\n", cudaGetErrorString(error));

                            unsigned char temp_compByte =
                                inputFileData[pos - 1 +
                                              (compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                              1];

                            error = cudaMemcpy(
                                &inputFileData[(compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                               1],
                                &device_inputFileData[(
                                    compressedDataOffset[integerOverflowIndex[i]] / 8)],
                                ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                    sizeof(unsigned char),
                                cudaMemcpyDeviceToHost);
                            if (error != cudaSuccess)
                                printf("Error 31 :: %s\n", cudaGetErrorString(error));

                            inputFileData[(compressedDataOffset[pos - 1 + integerOverflowIndex[i]] /
                                           8) -
                                          1] =
                                temp_compByte |
                                inputFileData[pos - 1 +
                                              (compressedDataOffset[integerOverflowIndex[i]] / 8) -
                                              1];
                            inputFileData[pos - 1] = temp_gpuCompByte | inputFileData[pos - 1];
                            pos += (compressedDataOffset[integerOverflowIndex[i]] / 8) +
                                   (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) -
                                   2;
                        }
                    }
                } else {
                    // initialize device_byteCompressedData
                    error = cudaMemset(
                        device_byteCompressedData, 0,
                        compressedDataOffset[integerOverflowIndex[0]] * sizeof(unsigned char));
                    if (error != cudaSuccess) printf("Error 32 :: %s\n", cudaGetErrorString(error));

                    compress<<<1, BLOCK_SIZE>>>(device_inputFileData, device_compressedDataOffset,
                                                device_huffmanDictionary, device_byteCompressedData,
                                                gpuMemoryOverflowIndex[i * 2], constMemoryFlag,
                                                gpuMemoryOverflowIndex[i * 2 + 1]);
                    cudaError_t error_kernel = cudaGetLastError();
                    if (error_kernel != cudaSuccess)
                        printf("Error Kernel 4 :: %s\n", cudaGetErrorString(error_kernel));

                    if (gpuBitPaddingFlag[i] == 0) {
                        error = cudaMemcpy(
                            &inputFileData[pos], device_inputFileData,
                            (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) *
                                sizeof(unsigned char),
                            cudaMemcpyDeviceToHost);
                        if (error != cudaSuccess)
                            printf("Error 33 :: %s\n", cudaGetErrorString(error));

                        pos += (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8);
                    } else {
                        unsigned char temp_huffmanTreeNode = inputFileData[pos - 1];
                        error = cudaMemcpy(
                            &inputFileData[pos - 1], device_inputFileData,
                            ((compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8)) *
                                sizeof(unsigned char),
                            cudaMemcpyDeviceToHost);
                        if (error != cudaSuccess)
                            printf("Error 34 :: %s\n", cudaGetErrorString(error));

                        inputFileData[pos - 1] = temp_huffmanTreeNode | inputFileData[pos - 1];
                        pos += (compressedDataOffset[gpuMemoryOverflowIndex[i * 2 + 1]] / 8) - 1;
                    }
                }
            }

            // free allocated memory
            cudaFree(device_inputFileData);
            cudaFree(device_compressedDataOffset);
            cudaFree(device_huffmanDictionary);
            cudaFree(device_byteCompressedData);
        }
    }
}
