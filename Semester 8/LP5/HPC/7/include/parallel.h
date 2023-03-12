/*
 * Parallel implementation for the Huffman tree
 * Used for Parallel implementation over the GPU
 * nvcc supported file, won't compile with gcc
 */

// structure for dictionary
struct huffmanDictionary {
    unsigned char bitSequence[256][191];
    unsigned char bitSequenceLength[256];
};

// structure for node
struct huffmanNode {
    unsigned char letter;
    unsigned int frequency;
    struct huffmanNode *left, *right;
};

// configs
extern struct huffmanNode* huffmanTreeNode_head;
extern struct huffmanNode huffmanTreeNode[512];
extern struct huffmanDictionary huffmanDictionary;

// constants
extern unsigned char bitSequenceConstMemory[256][255];
extern unsigned int constMemoryFlag;
extern __constant__ unsigned char device_bitSequenceConstMemory[256][255];

// functions
void sortHuffmanTree(int i, int distinctCharacterCount, int mergedHuffmanNodes);
void buildHuffmanTree(int i, int distinctCharacterCount, int mergedHuffmanNodes);
void buildHuffmanDictionary(struct huffmanNode* root, unsigned char* bitSequence,
                            unsigned char bitSequenceLength);

// gpu wrapper
int wrapperGpu(char** file, unsigned char* inputFileData, int inputFileLength);

// device functions
// 1. Single run, no overflow
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned int device_inputFileLength, unsigned int constMemoryFlag);

// 2. Single run, with overflow
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned char* device_tempOverflow, unsigned int device_inputFileLength,
                         unsigned int constMemoryFlag, unsigned int overflowPosition);

// 3. Multiple run, no overflow
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned int device_lowerPosition, unsigned int constMemoryFlag,
                         unsigned int device_upperPosition);

// 4. Multiple run with overflow
__global__ void compress(unsigned char* device_inputFileData,
                         unsigned int* device_compressedDataOffset,
                         struct huffmanDictionary* device_huffmanDictionary,
                         unsigned char* device_byteCompressedData,
                         unsigned char* device_tempOverflow, unsigned int device_lowerPosition,
                         unsigned int constMemoryFlag, unsigned int device_upperPosition,
                         unsigned int overflowPosition);

// offset array functions
void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength);

void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* gpuMemoryOverflow,
                           unsigned int* gpuBitPaddingFlag, long unsigned int memoryRequired);

void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* integerOverflowIndex,
                           unsigned int* bitPaddingFlag, int numBytes);

void createDataOffsetArray(unsigned int* compressedDataOffset, unsigned char* inputFileData,
                           unsigned int inputFileLength, unsigned int* integerOverflowIndex,
                           unsigned int* bitPaddingFlag, unsigned int* gpuMemoryOverflowIndex,
                           unsigned int* gpuBitPaddingFlag, int numBytes,
                           long unsigned int memoryRequired);

// cuda compression
void launchCudaHuffmanCompress(unsigned char* inputFileData, unsigned int* compressedDataOffset,
                               unsigned int inputFileLength, int numberOfKernels,
                               unsigned int integerOverflowFlag, long unsigned int memoryRequired);
