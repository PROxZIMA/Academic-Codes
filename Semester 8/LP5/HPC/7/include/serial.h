/*
 * Serial implementation for the Huffman tree
 * Used for Serial implementation over the CPU
 */

// struct for dictionary
struct huffmanDictionary {
    unsigned char bitSequence[255];
    unsigned char bitSequenceLength;
};

// struct for node
struct huffmanNode {
    unsigned char letter;       // char to store
    unsigned int frequency;     // frequency of the char
    struct huffmanNode* left;   // left sub tree
    struct huffmanNode* right;  // right sub tree
};

// default configs
extern struct huffmanDictionary huffmanDictionary[256];
extern struct huffmanNode* huffmanNode_head;
extern struct huffmanNode huffmanTreeNode[512];

// functions
void sortHuffmanTreeNodes(int i, int distinctCharacterCount, int combinedHuffmanNodes);
void buildHuffmanTreeNodes(int i, int distinctCharacterCount, int combinedHuffmanNodes);
void buildHuffmanDictionary(struct huffmanNode* root, unsigned char* bitSequence,
                            unsigned char bitSequenceLength);
