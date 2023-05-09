<!--
Credits:
https://github.com/AP-Atul/Huffman-Compression
-->

# Huffman-Compression
Huffman encoding and decoding with simple Serial and Parallel implementations for CPU and GPU (cuda)


## Algorithm
1. Compression
```
* Read the input data
* Get the frequencies for each symbol
* Build a tree from the frequencies
* Build a dictionary that store which letter has what frequency
* Check the sequence in the dictionary
    * write bits starting from the root node
    * one byte is written to file
* Write the frequency and compressed data to the output file
```

2. De-compression
```
* Read the frequency and compressed data from the file
* Build a tree from the frequencies
* Build a dictionary that store which letter has what frequency
* Check the sequence in the dictionary
    * get letter for the bits
    * get one byte data
* Write the letters to the output file
```

## Execution
1. Run the makefile for the serial
```console
$ make serial
or
$ make -B serial
```
2. Run the binary files on input file to compress
```console
$ ./bin/compress input.txt input.compressed
```
3. Decompression (both)
```console
$ ./bin/decompress input.compressed input_decompressed.txt
```

### For parallel with cuda
```console
$ make -B cuda
```
* Compression
```console
$ ./bin/compress_cuda input.txt input.compressed
```

## Output

```bash
$ ./bin/compress input.txt input.compressed

Compressed file length :: 64746748
Input file length :: 144498367
Merged Huffman Nodes :: 20
Distinct character count :: 12
Time taken: 2:937 s

$ ./bin/compress_cuda input.txt input.compressed
Free Memory :: 4017291264

Input File Size :: 144498367
Output Size :: 64746748
Number of Kernels :: 1
Integer Overflow flag :: 0

Free Mem: 2773680128
Error Kernel 1 :: no error

Time taken :: 1:32 s

$ ./bin/decompress input.compressed input_decompressed.txt

Compressed file length :: 64746748
Output file length counter :: 149033759
Output file length :: 144498367
Merged Huffman Nodes :: 20
Distinct character count :: 12
Time taken: 1:608 s
```
