import codecs
import os
import sys

from nltk.tokenize import TreebankWordTokenizer
from spacy import displacy

# --------------------------------------------------------------------------
# Global Variables definition
# --------------------------------------------------------------------------
tags = [
    "C0",
    "C1",
    "C2",
    "C3",
    "C4",
    "C5",
    "C6",
    "C7",
    "C8",
    "C9",
    "C10",
    "C11",
    "C12",
    "C13",
    "C14",
    "C15",
    "C16",
    "C17",
    "C18",
    "C19",
    "C20",
    "C21",
    "C22",
    "C23",
    "C24",
    "C25",
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
def main(language, test_file_path):
    exclude = ["<s>", "</s>", "START", "END"]
    filepath = [
        "./data/hindi_training_unsupervised.txt",
        "./data/telugu_training_unsupervised.txt",
        "./data/kannada_training_unsupervised.txt",
        "./data/tamil_training_unsupervised.txt",
    ]
    languages = ["hindi", "telugu", "kannada", "tamil"]
    f = codecs.open(filepath[language], "r", encoding="utf-8")
    file_contents = f.readlines()
    wordtypes = []
    tagscount = []
    for x in range(len(tags)):
        tagscount.append(0)
    for x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")
        for i, word in enumerate(line):
            if i == 0:
                if word not in wordtypes and word not in exclude:
                    wordtypes.append(word)
            else:
                if word in tags and word not in exclude:
                    tagscount[tags.index(word)] += 1
    f.close()
    emission_matrix = []
    transmission_matrix = []
    for x in range(len(tags)):
        emission_matrix.append([])
        for y in range(len(wordtypes)):
            emission_matrix[x].append(0)
    for x in range(len(tags)):
        transmission_matrix.append([])
        for y in range(len(tags)):
            transmission_matrix[x].append(0)
    f = codecs.open(filepath[language], "r", encoding="utf-8")
    file_contents = f.readlines()
    row_id = -1
    for x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")
        if line[0] not in exclude and len(line) >= 2:
            col_id = wordtypes.index(line[0])
            prev_row_id = row_id
            row_id = tags.index(line[1])
            emission_matrix[row_id][col_id] += 1
            if prev_row_id != -1:
                transmission_matrix[prev_row_id][row_id] += 1
        else:
            row_id = -1
    for x in range(len(tags)):
        for y in range(len(wordtypes)):
            if tagscount[x] != 0:
                emission_matrix[x][y] = float(emission_matrix[x][y]) / tagscount[x]
    for x in range(len(tags)):
        for y in range(len(tags)):
            if tagscount[x] != 0:
                transmission_matrix[x][y] = float(transmission_matrix[x][y]) / tagscount[x]
    testpath = test_file_path
    file_test = codecs.open(testpath, "r", encoding="utf-8")
    test_input = file_test.readlines()
    test_words = []
    pos_tags = []
    file_output = codecs.open("./output/" + languages[int(sys.argv[1])] + "_tags_unsupervised.txt", "w", "utf-8")
    file_output.close()
    for j in range(len(test_input)):
        test_words = []
        pos_tags = []
        line = test_input.pop(0).strip().split(" ")
        for word in line:
            test_words.append(word)
            pos_tags.append(-1)
        viterbi_matrix = []
        viterbi_path = []
        for x in range(len(tags)):
            viterbi_matrix.append([])
            viterbi_path.append([])
            for y in range(len(test_words)):
                viterbi_matrix[x].append(0)
                viterbi_path[x].append(0)
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
        maxval = -999999
        maxs = -1
        for x in range(len(tags)):
            if viterbi_matrix[x][len(test_words) - 1] > maxval:
                maxval = viterbi_matrix[x][len(test_words) - 1]
                maxs = x
        for x in range(len(test_words) - 1, -1, -1):
            pos_tags[x] = maxs
            maxs = viterbi_path[maxs][x]
        # print pos_tags
        file_output = codecs.open("./output/" + languages[int(sys.argv[1])] + "_tags_unsupervised.txt", "a", "utf-8")
        for i, x in enumerate(pos_tags):
            file_output.write(test_words[i] + "_" + tags[x] + " ")
        file_output.write(" ._.\n")
    f.close()
    file_output.close()
    file_test.close()
    print("Kindly check ./output/" + languages[int(sys.argv[1])] + "_tags_unsupervised.txt file for POS tags.")


def visualize_pos(tags_list):
    text = " ".join(_[0] for _ in tags_list)
    colors = {
        "NN": "#eebebe",
        "NST": "#ca9ee6",
        "NNP": "#e78284",
        "PRP": "#ea999c",
        "DEM": "#e5c890",
        "VM": "#f4b8e4",
        "VAUX": "#a6d189",
        "JJ": "#99d1db",
        "RB": "#81c8be",
        "PSP": "#e5c890",
        "RP": "#8caaee",
        "CC": "#e5c890",
        "WQ": "#737994",
        "QF": "#eebebe",
        "QC": "#ca9ee6",
        "QO": "#8caaee",
        "CL": "#babbf1",
        "INTF": "#81c8be",
        "INJ": "#737994",
        "NEG": "#babbf1",
        "UT": "#f4b8e4",
        "SYM": "#e78284",
        "COMP": "#ea999c",
        "RDP": "#99d1db",
        "ECH": "#a6d189",
        "UNK": "#737994",
        "XC": "#ef9f76",
    }

    # Get start and end index (span) for each token
    span_generator = TreebankWordTokenizer().span_tokenize(text)
    spans = list(span_generator)

    # Create dictionary with start index, end index,
    # pos_tag for each token
    pos_tags = colors.keys()
    ents = []
    for tag, span in zip(tags_list, spans):
        if tag[1] in pos_tags:
            ents.append({"start": span[0], "end": span[1], "label": tag[1]})

    doc = {"text": text, "ents": ents}

    options = {"ents": pos_tags, "colors": colors}

    displacy.serve(
        doc,
        style="ent",
        options=options,
        manual=True,
    )
