# DSL – ASSIGNMENT 6 – B16

def partition(arr, index, low, high):
    i = (low - 1)
    pivot = arr[high]

    for j in range(low , high):
        if arr[j] < pivot:
            i = i + 1
            arr[i], arr[j] = arr[j], arr[i]
            index[i], index[j] = index[j], index[i]

    arr[i + 1], arr[high] = arr[high], arr[i + 1]
    index[i + 1], index[high] = index[high], index[i + 1]

    return i + 1

def quickSort(arr, index, low, high):

    if low < high:
        pi = partition(arr, index, low, high)
        quickSort(arr, index, low, pi - 1)
        quickSort(arr, index, pi + 1, high)

    return index


def putdata(arr, n):
    print('\n\nFollowing are the percentages of all the students...\n')
    print('**********************************')
    print('|    Roll No    |   Percentage   |')
    print('**********************************')

    for i in range(n):
        print(f'|\t{i + 1}\t|\t{arr[i]}%\t |')
    print('----------------------------------\n\n')


def putsorteddata(arr, n):
    print('\n**********************************')
    print('|    Roll No    |   Percentage   |')
    print('**********************************')

    for i in range(n):
        print(f'|\t{arr[i][0]}\t|\t{arr[i][1]}%\t |')
    print('----------------------------------\n\n')


def main():
    n = int(input('\nEnter number of student in 1st year: '))
    arr = []

    for i in range(n):
        arr.append(int(input(f'Enter percentage of roll no {i + 1}: ')))

    putdata(arr, n)
    n = len(arr)
    index = list(range(1, n + 1))

    print('Sorting all the percentages using Quick Sort:')
    index = quickSort(arr, index, 0, n - 1)
    putsorteddata(list(zip(index, arr)), n)


if __name__ == "__main__":
    main()


"""

----------------- OUTPUT -----------------

Following are the percentages of all the students...

**********************************
|    Roll No    |   Percentage   |
**********************************
|       1       |      85.6%     |
|       2       |      82.8%     |
|       3       |      77.7%     |
|       4       |      91.9%     |
|       5       |      89.08%    |
|       6       |      45.88%    |
|       7       |      62.4%     |
|       8       |      73.5%     |
|       9       |      99.02%    |
|       10      |      95.6%     |
----------------------------------


Sorting all the percentages using Quick Sort:

**********************************
|    Roll No    |   Percentage   |
**********************************
|       6       |      45.88%    |
|       7       |      62.4%     |
|       8       |      73.5%     |
|       3       |      77.7%     |
|       2       |      82.8%     |
|       1       |      85.6%     |
|       5       |      89.08%    |
|       4       |      91.9%     |
|       10      |      95.6%     |
|       9       |      99.02%    |
----------------------------------

"""
