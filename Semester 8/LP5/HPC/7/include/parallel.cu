/*
 * Parallel function implementations
 * nvcc supported file won't compile with gcc
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parallel.h"

/*
 * Sorting the nodes based on the frequency
 * The man frequency is represented by the distinct char count
 */
void sortHuffmanTree(int a, int distinctCharacterCount, int combinedHuffmanNodes) {
    for (int i = combinedHuffmanNodes; i < distinctCharacterCount - 1 + a; i++) {
        for (int j = combinedHuffmanNodes; j < distinctCharacterCount - 1 + a; j++) {
            // perform swapping
            if (huffmanTreeNode[j].frequency > huffmanTreeNode[j + 1].frequency) {
                struct huffmanNode tempNode = huffmanTreeNode[j];
                huffmanTreeNode[j] = huffmanTreeNode[j + 1];
                huffmanTreeNode[j + 1] = tempNode;
            }
        }
    }
}

/*
 * Build the tree from the sorted results
 * The tree here is the min heap
 */
void buildHuffmanTree(int i, int distinctCharacterCount, int combinedHuffmanNodes) {
    huffmanTreeNode[distinctCharacterCount + i].frequency =
        huffmanTreeNode[combinedHuffmanNodes].frequency +
        huffmanTreeNode[combinedHuffmanNodes + 1].frequency;
    huffmanTreeNode[distinctCharacterCount + i].left = &huffmanTreeNode[combinedHuffmanNodes];
    huffmanTreeNode[distinctCharacterCount + i].right = &huffmanTreeNode[combinedHuffmanNodes + 1];
    huffmanTreeNode_head = &(huffmanTreeNode[distinctCharacterCount + i]);
}

/*
 * Build the dictionary for the huffman tree
 * It will store the bit sequence and their respective lengths
 */
void buildHuffmanDictionary(struct huffmanNode* root, unsigned char* bitSequence,
                            unsigned char bitSequenceLength) {
    if (root->left) {
        bitSequence[bitSequenceLength] = 0;
        buildHuffmanDictionary(root->left, bitSequence, bitSequenceLength + 1);
    }

    if (root->right) {
        bitSequence[bitSequenceLength] = 1;
        buildHuffmanDictionary(root->right, bitSequence, bitSequenceLength + 1);
    }

    // copy the bit sequence and the length to the dictionary
    if (root->right == NULL && root->left == NULL) {
        huffmanDictionary.bitSequenceLength[root->letter] = bitSequenceLength;
        if (bitSequenceLength < 192) {
            memcpy(huffmanDictionary.bitSequence[root->letter], bitSequence,
                   bitSequenceLength * sizeof(unsigned char));
        } else {
            memcpy(bitSequenceConstMemory[root->letter], bitSequence,
                   bitSequenceLength * sizeof(unsigned char));
            memcpy(huffmanDictionary.bitSequence[root->letter], bitSequence, 191);
            constMemoryFlag = 1;
        }
    }
}

/*
 * Generate data offset array
 * Case :- Single run, no overflow
 */
void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength) {
    compressedDataOffset[0] = 0;
    for (int i = 0; i < inputFileLength; i++) {
        compressedDataOffset[i + 1] =
            huffmanDictionary.bitSequenceLength[inputFileData[i]] + compressedDataOffset[i];
    }
    // not a byte & remaining values
    if (compressedDataOffset[inputFileLength] % 8 != 0) {
        compressedDataOffset[inputFileLength] = compressedDataOffset[inputFileLength] +
                                                (8 - (compressedDataOffset[inputFileLength] % 8));
    }
}

/*
 * Generate data offset array
 * Case :- Single run, with overflow
 * note : calculate compressed data offset - (1048576 is a safe number that will ensure there is no
 * integer overflow in GPU, it should be minimum 8 * number of threads)
 */
void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* integerOverflowIndex,
                           unsigned int* bitPaddingFlag, int numBytes) {
    int j = 0;
    compressedDataOffset[0] = 0;

    for (int i = 0; i < inputFileLength; i++) {
        compressedDataOffset[i + 1] =
            huffmanDictionary.bitSequenceLength[inputFileData[i]] + compressedDataOffset[i];

        if (compressedDataOffset[i + 1] + numBytes < compressedDataOffset[i]) {
            integerOverflowIndex[j] = i;

            if (compressedDataOffset[j] % 8 != 0) {
                bitPaddingFlag[j] = 1;
                compressedDataOffset[i + 1] = (compressedDataOffset[i] % 8) +
                                              huffmanDictionary.bitSequenceLength[inputFileData[i]];
                compressedDataOffset[i] =
                    compressedDataOffset[i] + (8 - (compressedDataOffset[i] % 8));
            } else {
                compressedDataOffset[i + 1] = huffmanDictionary.bitSequenceLength[inputFileData[i]];
            }
            j++;
        }
    }

    if (compressedDataOffset[inputFileLength] % 8 != 0) {
        compressedDataOffset[inputFileLength] = compressedDataOffset[inputFileLength] +
                                                (8 - (compressedDataOffset[inputFileLength] % 8));
    }
}

/*
 * Generate data offset array
 * Case :- Multiple run, with no overflow
 */
void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* gpuMemoryOverflow,
                           unsigned int* gpuBitPaddingFlag, long unsigned int memoryRequired) {
    int j = 0;
    gpuMemoryOverflow[0] = 0;
    gpuBitPaddingFlag[0] = 0;
    compressedDataOffset[0] = 0;

    for (int i = 0; i < inputFileLength; i++) {
        compressedDataOffset[i + 1] =
            huffmanDictionary.bitSequenceLength[inputFileData[i]] + compressedDataOffset[i];

        if (compressedDataOffset[i + 1] > memoryRequired) {
            gpuMemoryOverflow[j * 2 + 1] = i;
            gpuMemoryOverflow[j * 2 + 2] = i + 1;

            if (compressedDataOffset[i] % 8 != 0) {
                gpuBitPaddingFlag[j + 1] = 1;
                compressedDataOffset[i + 1] = (compressedDataOffset[i] % 8) +
                                              huffmanDictionary.bitSequenceLength[inputFileData[i]];
                compressedDataOffset[i] =
                    compressedDataOffset[i] + (8 - (compressedDataOffset[i] % 8));
            } else {
                compressedDataOffset[i + 1] = huffmanDictionary.bitSequenceLength[inputFileData[i]];
            }

            j++;
        }
    }

    if (compressedDataOffset[inputFileLength] % 8 != 0) {
        compressedDataOffset[inputFileLength] = compressedDataOffset[inputFileLength] +
                                                (8 - (compressedDataOffset[inputFileLength] % 8));
    }

    gpuMemoryOverflow[j * 2 + 1] = inputFileLength;
}

/*
 * Generate data offset array
 * Case :- Multiple run, with overflow
 */
void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* integerOverflowIndex,
                           unsigned int* bitPaddingFlag, unsigned int* gpuMemoryOverflowIndex,
                           unsigned int* gpuBitPaddingFlag, int numBytes,
                           long unsigned int memoryRequired) {
    int j = 0, k = 0;
    compressedDataOffset[0] = 0;

    for (int i = 0; i < inputFileLength; i++) {
        compressedDataOffset[i + 1] =
            huffmanDictionary.bitSequenceLength[inputFileData[i]] + compressedDataOffset[i];
        if (j != 0 && (long unsigned int)compressedDataOffset[i + 1] +
                              compressedDataOffset[integerOverflowIndex[j - 1]] >
                          memoryRequired) {
            gpuMemoryOverflowIndex[k * 2 + 1] = i;
            gpuMemoryOverflowIndex[k * 2 + 2] = i + 1;

            if (compressedDataOffset[i] % 8 != 0) {
                gpuBitPaddingFlag[k + 1] = 1;
                compressedDataOffset[i + 1] = (compressedDataOffset[i] % 8) +
                                              huffmanDictionary.bitSequenceLength[inputFileData[i]];
                compressedDataOffset[i] =
                    compressedDataOffset[i] + (8 - (compressedDataOffset[i] % 8));
            } else {
                compressedDataOffset[i + 1] = huffmanDictionary.bitSequenceLength[inputFileData[i]];
            }

            k++;
        } else if (compressedDataOffset[i + 1] + numBytes < compressedDataOffset[i]) {
            integerOverflowIndex[j] = i;

            // if not a byte
            if (compressedDataOffset[i] % 8 != 0) {
                bitPaddingFlag[j] = 1;
                compressedDataOffset[i + 1] = (compressedDataOffset[i] % 8) +
                                              huffmanDictionary.bitSequenceLength[inputFileData[i]];
                compressedDataOffset[i] =
                    compressedDataOffset[i] + (8 - (compressedDataOffset[i] % 8));
            } else {
                compressedDataOffset[i + 1] = huffmanDictionary.bitSequenceLength[inputFileData[i]];
            }

            j++;
        }
    }

    // remaining values
    if (compressedDataOffset[inputFileLength] % 8 != 0) {
        compressedDataOffset[inputFileLength] = compressedDataOffset[inputFileLength] +
                                                (8 - (compressedDataOffset[inputFileLength] % 8));
    }

    gpuMemoryOverflowIndex[j * 2 + 1] = inputFileLength;
}
