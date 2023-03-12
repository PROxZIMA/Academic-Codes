/*
 * Parallel function implementations
 * GPU kernel functions runs on the device
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../include/parallel.h"

/*
 * Compression function
 * Single run and no overflow
 */
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned int device_inputFileLength, unsigned int constMemoryFlag) {
    __shared__ struct huffmanDictionary table;
    memcpy(&table, device_huffmanDictionary, sizeof(struct huffmanDictionary));
    unsigned int inputFileLength = device_inputFileLength;
    unsigned int pos = blockIdx.x * blockDim.x + threadIdx.x;

    // when shared memory is sufficient
    if (constMemoryFlag == 0) {
        for (int i = pos; i < inputFileLength; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                device_byteCompressedData[device_compressedDataOffset[i] + k] =
                    table.bitSequence[device_inputFileData[i]][k];
            }
        }
    }

    // use the shared and constant memory
    else {
        for (int i = pos; i < inputFileLength; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                if (k < 191) {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        table.bitSequence[device_inputFileData[i]][k];
                } else {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i]][k];
                }
            }
        }
    }

    __syncthreads();

    for (int i = pos * 8; i < device_compressedDataOffset[inputFileLength]; i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_byteCompressedData[i + j] == 0) {
                device_inputFileData[i / 8] = device_inputFileData[i / 8] << 1;
            } else {
                device_inputFileData[i / 8] = (device_inputFileData[i / 8] << 1) | 1;
            }
        }
    }
}

/*
 * Compression function
 * Single run with overflow
 */
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned char* device_tempOverflow, unsigned int device_inputFileLength,
                         unsigned int constMemoryFlag, unsigned int overflowPosition) {
    __shared__ struct huffmanDictionary table;
    memcpy(&table, device_huffmanDictionary, sizeof(struct huffmanDictionary));
    unsigned int inputFileLength = device_inputFileLength;
    unsigned int pos = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int offsetOverflow;

    // when shared memory is sufficient
    if (constMemoryFlag == 0) {
        for (int i = pos; i < overflowPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                device_byteCompressedData[device_compressedDataOffset[i] + k] =
                    table.bitSequence[device_inputFileData[i]][k];
            }
        }
        for (int i = overflowPosition + pos; i < inputFileLength - 1; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i + 1]]; k++) {
                device_tempOverflow[device_compressedDataOffset[i + 1] + k] =
                    table.bitSequence[device_inputFileData[i + 1]][k];
            }
        }
        if (pos == 0) {
            memcpy(&device_tempOverflow
                       [device_compressedDataOffset[(overflowPosition + 1)] -
                        table.bitSequenceLength[device_inputFileData[overflowPosition]]],
                   &table.bitSequenceLength[device_inputFileData[overflowPosition]],
                   table.bitSequenceLength[device_inputFileData[overflowPosition]]);
        }
    }

    // use the shared and constant memory
    else {
        for (int i = pos; i < overflowPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                if (k < 191) {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        table.bitSequence[device_inputFileData[i]][k];
                } else {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i]][k];
                }
            }
        }
        for (int i = overflowPosition + pos; i < inputFileLength - 1; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i + 1]]; k++) {
                if (k < 191) {
                    device_tempOverflow[device_compressedDataOffset[i + 1] + k] =
                        table.bitSequence[device_inputFileData[i + 1]][k];
                } else {
                    device_tempOverflow[device_compressedDataOffset[i + 1] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i + 1]][k];
                }
            }
        }
        if (pos == 0) {
            memcpy(&device_tempOverflow
                       [device_compressedDataOffset[(overflowPosition + 1)] -
                        table.bitSequenceLength[device_inputFileData[overflowPosition]]],
                   &table.bitSequenceLength[device_inputFileData[overflowPosition]],
                   table.bitSequenceLength[device_inputFileData[overflowPosition]]);
        }
    }

    __syncthreads();

    for (int i = pos * 8; i < device_compressedDataOffset[inputFileLength]; i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_byteCompressedData[i + j] == 0) {
                device_inputFileData[i / 8] = device_inputFileData[i / 8] << 1;
            } else {
                device_inputFileData[i / 8] = (device_inputFileData[i / 8] << 1) | 1;
            }
        }
    }

    offsetOverflow = device_compressedDataOffset[overflowPosition] / 8;

    for (int i = pos * 8; i < device_compressedDataOffset[inputFileLength]; i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_tempOverflow[i + j] == 0) {
                device_inputFileData[(i / 8) + offsetOverflow] =
                    device_inputFileData[(i / 8) + offsetOverflow] << 1;
            } else {
                device_inputFileData[(i / 8) + offsetOverflow] =
                    (device_inputFileData[(i / 8) + offsetOverflow] << 1) | 1;
            }
        }
    }
}

/*
 * Compression function
 * Multiple run with no overflow
 */
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned int device_lowerPosition, unsigned int constMemoryFlag,
                         unsigned int device_upperPosition) {
    __shared__ struct huffmanDictionary table;
    memcpy(&table, device_huffmanDictionary, sizeof(struct huffmanDictionary));
    unsigned int pos = blockIdx.x * blockDim.x + threadIdx.x;

    // when shared memory is sufficient
    if (constMemoryFlag == 0) {
        for (int i = pos + device_lowerPosition; i < device_upperPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                device_byteCompressedData[device_compressedDataOffset[i] + k] =
                    table.bitSequence[device_inputFileData[i]][k];
            }
        }
        if (pos == 0 && device_lowerPosition != 0) {
            memcpy(&device_byteCompressedData
                       [device_compressedDataOffset[device_lowerPosition] -
                        table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]],
                   &table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]],
                   table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]);
        }
    }

    // use shared and constant memory
    else {
        for (int i = pos + device_lowerPosition; i < device_upperPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                if (k < 191) {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        table.bitSequence[device_inputFileData[i]][k];
                } else {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i]][k];
                }
            }
        }
        if (pos == 0 && device_lowerPosition != 0) {
            memcpy(&device_byteCompressedData
                       [device_compressedDataOffset[device_lowerPosition] -
                        table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]],
                   &table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]],
                   table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]);
        }
    }

    __syncthreads();

    for (int i = pos * 8; i < device_compressedDataOffset[device_upperPosition];
         i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_byteCompressedData[i + j] == 0) {
                device_inputFileData[(i / 8)] = device_inputFileData[(i / 8)] << 1;
            } else {
                device_inputFileData[(i / 8)] = (device_inputFileData[(i / 8)] << 1) | 1;
            }
        }
    }
}

/*
 * Compression function
 * Multiple run with overflow
 */
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned char* device_tempOverflow, unsigned int device_lowerPosition,
                         unsigned int constMemoryFlag, unsigned int device_upperPosition,
                         unsigned int overflowPosition) {
    __shared__ struct huffmanDictionary table;
    memcpy(&table, device_huffmanDictionary, sizeof(struct huffmanDictionary));
    unsigned int pos = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int offsetOverflow;

    // when shared memory is sufficient
    if (constMemoryFlag == 0) {
        for (int i = pos + device_lowerPosition; i < overflowPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                device_byteCompressedData[device_compressedDataOffset[i] + k] =
                    table.bitSequence[device_inputFileData[i]][k];
            }
        }
        for (int i = pos + overflowPosition; i < device_upperPosition - 1; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i + 1]]; k++) {
                device_tempOverflow[device_compressedDataOffset[i + 1] + k] =
                    table.bitSequence[device_inputFileData[i + 1]][k];
            }
        }

        if (pos == 0) {
            memcpy(&device_tempOverflow
                       [device_compressedDataOffset[overflowPosition + 1] -
                        table.bitSequenceLength[device_inputFileData[overflowPosition]]],
                   &table.bitSequenceLength[device_inputFileData[overflowPosition - 1]],
                   table.bitSequenceLength[device_inputFileData[overflowPosition]]);
        }
        if (pos == 0 && device_lowerPosition != 0) {
            memcpy(&device_byteCompressedData
                       [device_compressedDataOffset[device_lowerPosition] -
                        table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]],
                   &table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]],
                   table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]);
        }
    }

    // use shared and constant memory
    else {
        for (int i = pos + device_lowerPosition; i < device_upperPosition; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i]]; k++) {
                if (k < 191) {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        table.bitSequence[device_inputFileData[i]][k];
                } else {
                    device_byteCompressedData[device_compressedDataOffset[i] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i]][k];
                }
            }
        }
        for (int i = overflowPosition + pos; i < device_upperPosition - 1; i += blockDim.x) {
            for (int k = 0; k < table.bitSequenceLength[device_inputFileData[i + 1]]; k++) {
                if (k < 191) {
                    device_tempOverflow[device_compressedDataOffset[i] + k] =
                        table.bitSequence[device_inputFileData[i]][k];
                } else {
                    device_tempOverflow[device_compressedDataOffset[i] + k] =
                        device_bitSequenceConstMemory[device_inputFileData[i]][k];
                }
            }
        }
        if (pos == 0) {
            memcpy(&device_tempOverflow
                       [device_compressedDataOffset[(overflowPosition + 1)] -
                        table.bitSequenceLength[device_inputFileData[overflowPosition]]],
                   &table.bitSequenceLength[device_inputFileData[overflowPosition]],
                   table.bitSequenceLength[device_inputFileData[overflowPosition]]);
        }
        if (pos == 0 && device_lowerPosition != 0) {
            memcpy(&device_byteCompressedData
                       [device_compressedDataOffset[device_lowerPosition] -
                        table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]],
                   &table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]],
                   table.bitSequenceLength[device_inputFileData[device_lowerPosition - 1]]);
        }
    }

    __syncthreads();

    for (int i = pos * 8; i < device_compressedDataOffset[overflowPosition]; i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_byteCompressedData[i + j] == 0) {
                device_inputFileData[i / 8] = device_inputFileData[i / 8] << 1;
            } else {
                device_inputFileData[i / 8] = (device_inputFileData[i / 8] << 1) | 1;
            }
        }
    }

    offsetOverflow = device_compressedDataOffset[overflowPosition] / 8;

    for (int i = pos * 8; i < device_compressedDataOffset[device_upperPosition];
         i += blockDim.x * 8) {
        for (int j = 0; j < 8; j++) {
            if (device_tempOverflow[i + j] == 0) {
                device_inputFileData[(i / 8) + offsetOverflow] =
                    device_inputFileData[(i / 8) + offsetOverflow] << 1;
            } else {
                device_inputFileData[(i / 8) + offsetOverflow] =
                    (device_inputFileData[(i / 8) + offsetOverflow] << 1) | 1;
            }
        }
    }
}
