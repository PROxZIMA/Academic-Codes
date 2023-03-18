def get_tokens(file_path):

    file_pointer = codecs.open(file_path, "r", encoding="utf-8")
    file_contents = file_pointer.readlines()

    tokens = []

    for _x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")

        for word in line:
            if word != "":
                tokens.append(word)

    file_pointer.close()

    return tokens


def get_unique_words(file_path):

    file_pointer = codecs.open(file_path, "r", encoding="utf-8")
    file_contents = file_pointer.readlines()

    word_types = []

    for _x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")

        for word in line:
            if word != "" and word not in word_types:
                word_types.append(word)

    file_pointer.close()

    return word_types


def get_frequent_words(file_path, n):

    chop_off_distance = 25

    file_pointer = codecs.open(file_path, "r", encoding="utf-8")
    file_contents = file_pointer.readlines()

    word_list = {}

    for _x in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")

        for word in line:
            if word != "":
                if word not in word_list:
                    word_list[word] = 1
                else:
                    word_list[word] += 1

    word_list = sorted(word_list.items(), key=lambda item: item[1], reverse=True)

    top_n_words = []

    for x in range(n):
        top_n_words.append(word_list[x + chop_off_distance][0])

    file_pointer.close()

    return top_n_words


def get_feature_vectors(tokens, unique_words, feature_words):

    feature_vectors = []

    for each in range(len(unique_words)):
        feature_vectors.append([])
        for _x in range(2 * len(feature_words)):
            feature_vectors[each].append(0)

    for i in range(len(tokens)):
        if i < len(tokens) - 4:
            if tokens[i + 1] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][feature_words.index(tokens[i + 1])] += 1
            if tokens[i + 2] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][feature_words.index(tokens[i + 2])] += 1
            if tokens[i + 3] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][feature_words.index(tokens[i + 3])] += 1
            if tokens[i + 4] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][feature_words.index(tokens[i + 4])] += 1
        if i > 3:
            if tokens[i - 1] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][
                    len(feature_words) + feature_words.index(tokens[i - 1])
                ] += 1
            if tokens[i - 2] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][
                    len(feature_words) + feature_words.index(tokens[i - 2])
                ] += 1
            if tokens[i - 3] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][
                    len(feature_words) + feature_words.index(tokens[i - 3])
                ] += 1
            if tokens[i - 4] in feature_words:
                feature_vectors[unique_words.index(tokens[i])][
                    len(feature_words) + feature_words.index(tokens[i - 4])
                ] += 1

    return feature_vectors


def map_clusters_with_data(centroids, feature_vectors):
    cluster_data_map = []
    for _x in range(len(centroids)):
        cluster_data_map.append([])

    error = 0

    for i, data_point in enumerate(feature_vectors):
        max_distance = 999999
        closest_cluster = -1
        for j, centriod in enumerate(centroids):
            if dist(data_point, centriod) < max_distance:
                max_distance = dist(data_point, centriod)
                closest_cluster = j
        cluster_data_map[closest_cluster].append(i)
        error += max_distance

    return cluster_data_map, error


def dist(data_point, centriod):

    distance = 0

    for x in range(len(data_point)):
        distance += (data_point[x] - centriod[x]) ** 2

    distance = math.sqrt(distance)

    return distance


def recompute_centroids(feature_vectors, cluster_data_map):

    centroids = []

    for each in cluster_data_map:
        centroids.append(mean_of_data_points(feature_vectors, each))

    return centroids


def mean_of_data_points(feature_vectors, list_of_points):

    mean = []
    for _x in range(len(feature_vectors[0])):
        mean.append(0)

    for each in list_of_points:
        for i, _x in enumerate(feature_vectors[each]):
            mean[i] += feature_vectors[each][i]

    for x in range(len(mean)):
        if len(list_of_points) != 0:
            mean[x] = mean[x] / len(list_of_points)

    return mean


def main():

    print("Processing... It may takes few second(s)\n")

    # Path of actual text files.
    textfiles = ["./data/hindi.txt", "./data/telugu.txt", "./data/kannada.txt", "./data/tamil.txt"]
    languages = ["hindi", "telugu", "kannada", "tamil"]
    file_path = textfiles[int(sys.argv[1])]

    # Number of feature words to be used for calculating feature vectors
    number_of_top_words = 100
    tokens = get_tokens(file_path)
    word_types = get_unique_words(file_path)
    top_n_words = get_frequent_words(file_path, number_of_top_words)
    feature_vectors = get_feature_vectors(tokens, word_types, top_n_words)

    clusters = [
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
    ]
    number_of_clusters = len(clusters)

    # Random word index used to get feature vectors as centroids in K means clustering
    selected_word_index = [
        1,
        94,
        109,
        44,
        77,
        131,
        156,
        406,
        244,
        444,
        14,
        29,
        295,
        806,
        157,
        362,
        855,
        781,
        100,
        494,
        2017,
        222,
        199,
        40,
        400,
        689,
    ]
    centroids = []
    for x in range(number_of_clusters):
        centroids.append(feature_vectors[selected_word_index[x]])

    # K Means Clustering
    for _loop in range(10):
        cluster_data_map, total_error = map_clusters_with_data(centroids, feature_vectors)
        print(total_error)
        centroids = recompute_centroids(feature_vectors, cluster_data_map)

    # Output clusters to the output file
    file_output = codecs.open("./output/" + languages[int(sys.argv[1])] + "_clusters.txt", "w", "utf-8")
    for x in range(len(cluster_data_map)):
        file_output.write("BEGIN CLUSTER\n")
        for each in cluster_data_map[x]:
            file_output.write(word_types[each] + "\n")
        file_output.write("END CLUSTER\n\n")
    file_output.close()

    print(
        "Kindly check ./output/"
        + languages[int(sys.argv[1])]
        + "_clusters.txt for clusters and words in that cluster\n"
    )

    # Create training file based on the clusters created above
    file_output = codecs.open("./data/" + languages[int(sys.argv[1])] + "_training_unsupervised.txt", "w", "utf-8")
    file_pointer = codecs.open(file_path, "r", encoding="utf-8")
    file_contents = file_pointer.readlines()

    for _ in range(len(file_contents)):
        line = file_contents.pop(0).strip().split(" ")
        file_output.write("<s> START\n")
        for word in line:
            for i in range(len(cluster_data_map)):
                for j in cluster_data_map[i]:
                    if word_types[j] == word:
                        file_output.write(word + " C" + str(i) + "\n")
                        break
        file_output.write("</s> END\n")

    file_pointer.close()

    # Perform HMM based tagging on the test sentences using above training file
    helper.main(int(sys.argv[1]), sys.argv[2])


# --------------------------------------------------------------------------
# Execution begins here
# --------------------------------------------------------------------------
#     Description
#
#    If all the libraries are available in target system, main() is called,
#    else program exits gracefully by displaying dependancies.
#
# --------------------------------------------------------------------------
if __name__ == "__main__":
    try:
        import codecs
        import math
        import os
        import random
        import sys

        import helper

        if len(sys.argv) == 3:
            main()
        else:
            print("Usage: python unsupervised.py <language> <test_file_path>")
            print("Example: python unsupervised.py 0 ./data/hindi_testing.txt")
            print("More Info: Check ./Readme - Unsupervised.txt for detailed information")

    except ImportError as error:
        print(f"Couldn't find the module - {error.message[16:]}, kindly install before proceeding.")
