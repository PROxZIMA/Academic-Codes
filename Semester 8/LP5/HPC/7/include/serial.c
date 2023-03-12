/*
 * Serial function implementations
 */

#include "serial.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Sorting the nodes based on the frequency
 * The man frequency is represented by the distinct char count
 */
void sortHuffmanTreeNodes(int a, int distinctCharacterCount, int combinedHuffmanNodes) {
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
void buildHuffmanTreeNodes(int i, int distinctCharacterCount, int combinedHuffmanNodes) {
    huffmanTreeNode[distinctCharacterCount + i].frequency =
        huffmanTreeNode[combinedHuffmanNodes].frequency +
        huffmanTreeNode[combinedHuffmanNodes + 1].frequency;
    huffmanTreeNode[distinctCharacterCount + i].left = &huffmanTreeNode[combinedHuffmanNodes];
    huffmanTreeNode[distinctCharacterCount + i].right = &huffmanTreeNode[combinedHuffmanNodes + 1];
    huffmanNode_head = &(huffmanTreeNode[distinctCharacterCount + i]);
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
        huffmanDictionary[root->letter].bitSequenceLength = bitSequenceLength;
        memcpy(huffmanDictionary[root->letter].bitSequence, bitSequence,
               bitSequenceLength * sizeof(unsigned char));
    }
}
