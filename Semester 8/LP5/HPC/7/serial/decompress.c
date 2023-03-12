/*
 * De-compression using the serial functions and CPU
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
    unsigned int compressedFileLength, outputFileLengthCounter, outputFileLength;
    unsigned int mergedHuffmanNodes, distinctCharacterCount;
    unsigned int frequency[256];

    unsigned char currentInputBit, currentInputByte, bitSequenceLength = 0, bitSequence[255];
    unsigned char *compressedData, *outputData;
    struct huffmanNode* huffmanNode_current;

    FILE *compressedFile, *outputFile;

    // read input file get length, frequency and data
    compressedFile = fopen(argv[1], "rb");
    fread(&outputFileLength, sizeof(unsigned int), 1, compressedFile);
    fread(frequency, 256 * sizeof(unsigned int), 1, compressedFile);

    // find length of the compressed file
    fseek(compressedFile, 0, SEEK_END);
    compressedFileLength = ftell(compressedFile) - 1028;
    fseek(compressedFile, 1028, SEEK_SET);

    // allocate the required memory, read the file
    compressedData = malloc((compressedFileLength) * sizeof(unsigned char));
    fread(compressedData, sizeof(unsigned char), compressedFileLength, compressedFile);

    // start the clock, tick tick
    start = clock();

    // initialize the huffman tree
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

    // build the tree
    for (int i = 0; i < distinctCharacterCount - 1; i++) {
        mergedHuffmanNodes = 2 * i;
        sortHuffmanTreeNodes(i, distinctCharacterCount, mergedHuffmanNodes);
        buildHuffmanTreeNodes(i, distinctCharacterCount, mergedHuffmanNodes);
    }

    // build the huffman dictionary with the bit sequence and its length
    buildHuffmanDictionary(huffmanNode_head, bitSequence, bitSequenceLength);

    // write data to the file
    outputData = malloc(outputFileLength * sizeof(unsigned char));
    huffmanNode_current = huffmanNode_head;
    outputFileLengthCounter = 0;
    for (int i = 0; i < compressedFileLength; i++) {
        currentInputByte = compressedData[i];
        for (int j = 0; j < 8; j++) {
            currentInputBit = currentInputByte & 0200;
            currentInputByte = currentInputByte << 1;

            // value is 0 then left sub tree
            if (currentInputBit == 0) {
                huffmanNode_current = huffmanNode_current->left;
                if (huffmanNode_current->left == NULL) {
                    outputData[outputFileLengthCounter] = huffmanNode_current->letter;
                    huffmanNode_current = huffmanNode_head;
                    outputFileLengthCounter++;
                }
            }
            // value is 1 the right sub tree
            else {
                huffmanNode_current = huffmanNode_current->right;
                if (huffmanNode_current->right == NULL) {
                    outputData[outputFileLengthCounter] = huffmanNode_current->letter;
                    huffmanNode_current = huffmanNode_head;
                    outputFileLengthCounter++;
                }
            }
        }
    }

    // end the clock, tick tick
    end = clock();

    // write the data to the output file
    outputFile = fopen(argv[2], "wb");
    fwrite(outputData, sizeof(unsigned char), outputFileLength, outputFile);
    fclose(outputFile);

    // printing debug info if debug is on
    if (DEBUG) {
        printf("\n%sCompressed file length :: %d", COLOR_DEBUG, compressedFileLength);
        printf("\nOutput file length counter :: %d", outputFileLengthCounter);
        printf("\nOutput file length :: %d", outputFileLength);
        printf("\nMerged Huffman Nodes :: %d", mergedHuffmanNodes);
        printf("\nDistinct character count :: %d", distinctCharacterCount);
    }

    cpuTime = (end - start) * 1000 / CLOCKS_PER_SEC;
    printf("\nTime taken: %d:%d s\n", cpuTime / 1000, cpuTime % 1000);

    // clean up
    free(outputData);
    free(compressedData);

    return 0;
}
