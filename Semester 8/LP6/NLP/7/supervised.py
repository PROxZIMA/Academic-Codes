# --------------------------------------------------------------------------
# Global Variables definition
# --------------------------------------------------------------------------
tags = [
    "NN",
    "NST",
    "NNP",
    "PRP",
    "DEM",
    "VM",
    "VAUX",
    "JJ",
    "RB",
    "PSP",
    "RP",
    "CC",
    "WQ",
    "QF",
    "QC",
    "QO",
    "CL",
    "INTF",
    "INJ",
    "NEG",
    "UT",
    "SYM",
    "COMP",
    "RDP",
    "ECH",
    "UNK",
    "XC",
]

# --------------------------------------------------------------------------
# Function: max_connect
# --------------------------------------------------------------------------
# 	Description
#
# 	max_connect function performs the viterbi decoding. Choosing which tag
# 	for the current word leads to a better tag sequence.
#
# --------------------------------------------------------------------------
def max_connect(x, y, viterbi_matrix, emission, transmission_matrix):
    max = -99999
    path = -1

    for k in range(len(tags)):
        val = viterbi_matrix[k][x - 1] * transmission_matrix[k][y]
        if val * emission > max:
            max = val
            path = k
    return max, path


# --------------------------------------------------------------------------
# Function: main
# --------------------------------------------------------------------------
# 	Description
#
# 	1) Unique words are extracted from the training data.
# 	2) Count of occurence of each tag is calculated.
# 	3) Emission & Transmission matrix are initialized and computed.
# 	4) Testing data is read.
# 	5) Trellis for viterbi decoding is computed.
# 	6) Path is printed on to output file.
#
# --------------------------------------------------------------------------
def main():

    # --------------------------------------------------------------------------
    # Start of Training Phase
    # --------------------------------------------------------------------------

    start_time = time.time()

    # Path of training files
    filepath = [
        "./data/hindi_training.txt",
        "./data/telugu_training.txt",
        "./data/kannada_training.txt",
        "./data/tamil_training.txt",
    ]
    languages = ["hindi", "telugu", "kannada", "tamil"]
    exclude = ["<s>", "</s>", "START", "END"]
    wordtypes = []
    tagscount = []

    # Open training file to read the contents
    f = codecs.open(filepath[int(sys.argv[1])], "r", encoding="utf-8")
    file_contents = f.readlines()

    # Initialize count of each tag to Zero's
    for _x in range(len(tags)):
        tagscount.append(0)

    # Calculate count of each tag in the training corpus and also the wordtypes in the corpus
    for _x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")
        for i, word in enumerate(line):
            if i == 0:
                if word not in wordtypes and word not in exclude:
                    wordtypes.append(word)
            else:
                if word in tags and word not in exclude:
                    tagscount[tags.index(word)] += 1
    f.close()

    # Declare variables for emission and transmission matrix
    emission_matrix = []
    transmission_matrix = []

    # Initialize emission matrix
    for x in range(len(tags)):
        emission_matrix.append([])
        for _y in range(len(wordtypes)):
            emission_matrix[x].append(0)

    # Initialize transmission matrix
    for x in range(len(tags)):
        transmission_matrix.append([])
        for _y in range(len(tags)):
            transmission_matrix[x].append(0)

    # Open training file to update emission and transmission matrix
    f = codecs.open(filepath[int(sys.argv[1])], "r", encoding="utf-8")
    file_contents = f.readlines()

    # Update emission and transmission matrix with appropriate counts
    row_id = -1
    for _ in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")

        if line[0] not in exclude:
            col_id = wordtypes.index(line[0])
            prev_row_id = row_id
            row_id = tags.index(line[1])
            emission_matrix[row_id][col_id] += 1
            if prev_row_id != -1:
                transmission_matrix[prev_row_id][row_id] += 1
        else:
            row_id = -1

    # Divide each entry in emission matrix by appropriate tag count to store probabilities in each entry instead of just count
    for x in range(len(tags)):
        for y in range(len(wordtypes)):
            if tagscount[x] != 0:
                emission_matrix[x][y] = float(emission_matrix[x][y]) / tagscount[x]

    # Divide each entry in transmission matrix by appropriate tag count to store probabilities in each entry instead of just count
    for x in range(len(tags)):
        for y in range(len(tags)):
            if tagscount[x] != 0:
                transmission_matrix[x][y] = float(transmission_matrix[x][y]) / tagscount[x]

    print(time.time() - start_time, "seconds for training")

    # --------------------------------------------------------------------------
    # End of Training Phase
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Start of Testing Phase
    # --------------------------------------------------------------------------

    start_time = time.time()

    # Open the testing file to read test sentences
    testpath = sys.argv[2]
    file_test = codecs.open(testpath, "r", encoding="utf-8")
    test_input = file_test.readlines()

    # Declare variables for test words and pos tags
    test_words = []
    pos_tags = []
    tags_list = []

    # Create an output file to write the output tags for each sentences
    file_output = codecs.open("./output/" + languages[int(sys.argv[1])] + "_tags.txt", "w", "utf-8")
    file_output.close()

    # For each line POS tags are computed
    for _j in range(len(test_input)):

        test_words = []
        pos_tags = []

        line = test_input.pop(0).strip().split(" ")

        for word in line:
            test_words.append(word)
            pos_tags.append(-1)

        viterbi_matrix = []
        viterbi_path = []

        # Initialize viterbi matrix of size |tags| * |no of words in test sentence|
        for x in range(len(tags)):
            viterbi_matrix.append([])
            viterbi_path.append([])
            for _ in range(len(test_words)):
                viterbi_matrix[x].append(0)
                viterbi_path[x].append(0)

        # Update viterbi matrix column wise
        for x in range(len(test_words)):
            for y in range(len(tags)):
                if test_words[x] in wordtypes:
                    word_index = wordtypes.index(test_words[x])
                    tag_index = tags.index(tags[y])
                    emission = emission_matrix[tag_index][word_index]
                else:
                    emission = 0.001

                if x > 0:
                    max, viterbi_path[y][x] = max_connect(x, y, viterbi_matrix, emission, transmission_matrix)
                else:
                    max = 1
                viterbi_matrix[y][x] = emission * max

        # Identify the max probability in last column i.e. best tag for last word in test sentence
        maxval = -999999
        maxs = -1
        for x in range(len(tags)):
            if viterbi_matrix[x][len(test_words) - 1] > maxval:
                maxval = viterbi_matrix[x][len(test_words) - 1]
                maxs = x

        # Backtrack and identify best tags for each words
        for x in range(len(test_words) - 1, -1, -1):
            pos_tags[x] = maxs
            maxs = viterbi_path[maxs][x]

        # Display POS Tags in the console.
        # print pos_tags

        # Print output to the file.
        file_output = codecs.open("./output/" + languages[int(sys.argv[1])] + "_tags.txt", "a", "utf-8")
        for i, x in enumerate(pos_tags):
            tags_list.append((test_words[i], tags[x]))
            file_output.write(test_words[i] + "_" + tags[x] + " ")
        file_output.write(" ._.\n")

    f.close()
    file_output.close()
    file_test.close()

    print(time.time() - start_time, "seconds for testing 100 Sentences")

    print("\nKindly check ./output/" + languages[int(sys.argv[1])] + "_tags.txt file for POS tags.")
    visualize_pos(tags_list)


# --------------------------------------------------------------------------
# Execution begins here
# --------------------------------------------------------------------------
# 	Description
#
# 	If all the libraries are available in target system, main() is called,
# 	else program exits gracefully by displaying dependancies.
#
# --------------------------------------------------------------------------
if __name__ == "__main__":
    try:
        import codecs
        import os
        import sys
        import time

        from helper import visualize_pos

        if len(sys.argv) == 3:
            main()
        else:
            print("Usage: python supervised.py <language> <test_file_path>")
            print("Example: python supervised.py 0 ./data/hindi_testing.txt")
            print("More Info: Check ./Readme - Supervised.txt for detailed information")

    except ImportError as error:
        print(f"Couldn't find the module - {error.message[16:]}, kindly install before proceeding.")
