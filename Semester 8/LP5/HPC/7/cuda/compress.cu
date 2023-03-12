/*
 * Compression using the parallel functions and GPU
 */

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "../include/color.h"
#include "../include/parallel.h"

#define BLOCK_SIZE 1024
#define MIN_SCRATCH_SIZE 50 * 1024 * 1024
#define DEBUG 1

struct huffmanNode *huffmanTreeNode_head;
struct huffmanDictionary huffmanDictionary;
struct huffmanNode huffmanTreeNode[512];
unsigned char bitSequenceConstMemory[256][255];
unsigned int constMemoryFlag = 0;

int main(int argc, char **argv) {
    unsigned int distinctCharacterCount, mergedHuffmanNodes, inputFileLength;
    unsigned int frequency[256];
    unsigned char *inputFileData, bitSequenceLength = 0, bitSequence[255];
    unsigned int *compressedDataOffset, cpuTimeUsed;
    unsigned int integerOverflowFlag;
    long unsigned int memFree, memTotal, memRequired, memOffset, memData;
    int numberOfKernels;
    clock_t start, end;

    FILE *inputFile, *compressedFile;

    // check the arguments
    if (argc != 3) {
        printf("Arguments should be input file and output file");
        return -1;
    }

    // read input file, get length and data
    inputFile = fopen(argv[1], "rb");
    fseek(inputFile, 0, SEEK_END);
    inputFileLength = ftell(inputFile);
    fseek(inputFile, 0, SEEK_SET);
    inputFileData = (unsigned char *)malloc(inputFileLength * sizeof(unsigned char));
    fread(inputFileData, sizeof(unsigned char), inputFileLength, inputFile);
    fclose(inputFile);

    // starting the clock, tick tick
    start = clock();

    // find frequency of each symbols
    for (int i = 0; i < 256; i++) frequency[i] = 0;
    for (int i = 0; i < inputFileLength; i++) frequency[inputFileData[i]]++;

    // initialize the nodes
    distinctCharacterCount = 0;
    for (int i = 0; i < 256; i++) {
        if (frequency[i] > 0) {
            huffmanTreeNode[distinctCharacterCount].frequency = frequency[i];
            huffmanTreeNode[distinctCharacterCount].letter = i;
            huffmanTreeNode[distinctCharacterCount].left = NULL;
            huffmanTreeNode[distinctCharacterCount].right = NULL;
            distinctCharacterCount++;
        }
    }

    // build the huffman tree
    for (int i = 0; i < distinctCharacterCount - 1; i++) {
        mergedHuffmanNodes = 2 * i;
        sortHuffmanTree(i, distinctCharacterCount, mergedHuffmanNodes);
        buildHuffmanTree(i, distinctCharacterCount, mergedHuffmanNodes);
    }
    if (distinctCharacterCount == 1) {
        huffmanTreeNode_head = &huffmanTreeNode[0];
    }

    // build the huffman dictionary
    buildHuffmanDictionary(huffmanTreeNode_head, bitSequence, bitSequenceLength);

    // calculating memory requirements
    // gpu memory
    cudaMemGetInfo(&memFree, &memTotal);

    // debug
    if (DEBUG) printf("Free Memory :: %lu \n", memFree);

    // offset array requirements
    memOffset = 0;
    for (int i = 0; i < 256; i++)
        memOffset += frequency[i] * huffmanDictionary.bitSequenceLength[i];
    memOffset = memOffset % 8 == 0 ? memOffset : memOffset + 8 - memOffset % 8;

    // other memory requirements
    memData =
        inputFileLength + (inputFileLength + 1) * sizeof(unsigned int) + sizeof(huffmanDictionary);

    if (memFree - memData < MIN_SCRATCH_SIZE) {
        printf("\n%sExiting not enough memory on GPU :: \nMem Free :: %lu\nMin Required :: %lu\n",
               COLOR_ERROR, memFree, memData + MIN_SCRATCH_SIZE);
        return -1;
    }

    memRequired = memFree - memData - 10 * 1024 * 1024;
    numberOfKernels = ceil((double)memOffset / memRequired);
    integerOverflowFlag = memRequired + 255 <= UINT_MAX || memOffset + 255 <= UINT_MAX ? 0 : 1;

    if (DEBUG) {
        printf(
            "\n%sInput File Size :: %u\nOutput Size :: %lu\nNumber of Kernels :: "
            "%d\nInteger Overflow flag :: %d\n",
            COLOR_DEBUG, inputFileLength, memOffset / 8, numberOfKernels, integerOverflowFlag);
    }

    // generate offset data array
    compressedDataOffset = (unsigned int *)malloc((inputFileLength + 1) * sizeof(unsigned int));

    // launch kernel
    launchCudaHuffmanCompress(inputFileData, compressedDataOffset, inputFileLength, numberOfKernels,
                              integerOverflowFlag, memRequired);

    // end the clock, tick tick
    end = clock();

    // writing the compressed file to the output
    compressedFile = fopen(argv[2], "wb");
    fwrite(&inputFileLength, sizeof(unsigned int), 1, compressedFile);
    fwrite(frequency, sizeof(unsigned int), 256, compressedFile);
    fwrite(inputFileData, sizeof(unsigned char), memOffset / 8, compressedFile);
    fclose(compressedFile);

    cpuTimeUsed = ((end - start)) * 1000 / CLOCKS_PER_SEC;
    printf("\n\nTime taken :: %d:%d s\n", cpuTimeUsed / 1000, cpuTimeUsed % 1000);

    free(inputFileData);
    free(compressedDataOffset);

    return 0;
}
