/*
 * Compression using the serial functions and CPU
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "../include/color.h"
#include "../include/serial.h"

struct huffmanDictionary huffmanDictionary[256];
struct huffmanNode* huffmanNode_head;
struct huffmanNode huffmanTreeNode[512];

#define DEBUG 1

int main(int argc, char** argv) {
    clock_t start, end;
    unsigned int cpuTime;
    unsigned int distinctCharacterCount, mergedHuffmanNodes;
    unsigned int inputFileLength, compressedFileLength;
    unsigned int frequency[256];

    unsigned char *inputFileData, *compressedData;
    unsigned char writeBit = 0, bitsFilled = 0, bitSequence[255], bitSequenceLength = 0;

    FILE *inputFile, *compressedFile;

    // read the input file, get file length and the data
    inputFile = fopen(argv[1], "rb");
    fseek(inputFile, 0, SEEK_END);
    inputFileLength = ftell(inputFile);
    fseek(inputFile, 0, SEEK_SET);
    inputFileData = malloc(inputFileLength * sizeof(unsigned char));
    fread(inputFileData, sizeof(unsigned char), inputFileLength, inputFile);
    fclose(inputFile);

    // starting the clock, tick tick
    start = clock();

    // finding the frequency for each symbol
    for (int i = 0; i < 256; i++) frequency[i] = 0;
    for (int i = 0; i < inputFileLength; i++) frequency[inputFileData[i]]++;

    // initializing the nodes for the huffman tree
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

    // building the tree
    for (int i = 0; i < distinctCharacterCount - 1; i++) {
        mergedHuffmanNodes = 2 * i;
        sortHuffmanTreeNodes(i, distinctCharacterCount, mergedHuffmanNodes);
        buildHuffmanTreeNodes(i, distinctCharacterCount, mergedHuffmanNodes);
    }
    // setting the head
    if (distinctCharacterCount == 1) {
        huffmanNode_head = &huffmanTreeNode[0];
    }

    // building the dictionary for the bit sequence and its length
    buildHuffmanDictionary(huffmanNode_head, bitSequence, bitSequenceLength);

    /*
     * Starting the compression process
     */
    compressedData = malloc(inputFileLength * sizeof(unsigned char));
    compressedFileLength = 0;
    for (int i = 0; i < inputFileLength; i++) {
        for (int j = 0; j < huffmanDictionary[inputFileData[i]].bitSequenceLength; j++) {
            // root
            if (huffmanDictionary[inputFileData[i]].bitSequence[j] == 0) {
                writeBit = writeBit << 1;
                bitsFilled += 1;
            } else {
                writeBit = (writeBit << 1) | 01;
                bitsFilled += 1;
            }
            if (bitsFilled == 8) {
                compressedData[compressedFileLength] = writeBit;
                bitsFilled = 0;
                writeBit = 0;
                compressedFileLength += 1;
            }
        }
    }

    if (bitsFilled != 0) {
        for (int i = 0; (unsigned char)i < 8 - bitsFilled; i++) {
            writeBit = writeBit << 1;
        }
        compressedData[compressedFileLength] = writeBit;
        compressedFileLength++;
    }

    // end the clock. tick tick
    end = clock();

    // write the metadata and the compressed data to the file
    compressedFile = fopen(argv[2], "wb");
    fwrite(&inputFileLength, sizeof(unsigned int), 1, compressedFile);
    fwrite(frequency, sizeof(unsigned int), 256, compressedFile);
    fwrite(compressedData, sizeof(unsigned char), compressedFileLength, compressedFile);
    fclose(compressedFile);

    // printing debug info if debug is on
    if (DEBUG) {
        printf("\n%sCompressed file length :: %d", COLOR_DEBUG, compressedFileLength);
        printf("\nInput file length :: %d", inputFileLength);
        printf("\nMerged Huffman Nodes :: %d", mergedHuffmanNodes);
        printf("\nDistinct character count :: %d", distinctCharacterCount);
    }

    // printing the time taken
    cpuTime = ((end - start)) * 1000 / CLOCKS_PER_SEC;
    printf("\nTime taken: %d:%d s\n", cpuTime / 1000, cpuTime % 1000);

    // clean up
    free(inputFileData);
    free(compressedData);

    return 0;
}
