# DSL – ASSIGNMENT 4 – B11

def linearSearch(arr, n):
    val = int(input('Enter the Roll no you want to search using linear search: '))

    for i in range(n):
        if arr[i] == val:
            print(f'Roll no {val} found at position {i + 1}')
            return

    print(f'Roll no {val} not found')
    return

def sentinelSearch(arr, n):
    val = int(input('\n\nEnter the Roll no you want to search using sentinal search: '))

    last = arr[n - 1]

    arr[n - 1] = val
    i = 0

    while (arr[i] != val):
        i += 1

    arr[n - 1] = last

    if ((i < n - 1) or (val == arr[n - 1])):
        print(f'Roll no {val} found at position {i + 1}')
        return
    else:
        print(f'Roll no {val} not found')
        return

def binarySearch(arr, n):
    val = int(input('Enter the Roll no you want to search using binary search: '))

    s = 0
    while s <= n:
        mid = (s + n) // 2
        if arr[mid] == val:
            print(f'Roll no {val} found at position {mid + 1}')
            return

        elif arr[mid] < val:
            s = mid + 1

        else:
            n = mid - 1

    print(f'Roll no {val} not found')
    return

def fibonacciSearch(arr, n):
    val = int(input('\n\nEnter the Roll no you want to search using fibonacci search: '))

    fib_2 = 0
    fib_1 = 1
    fib_N = fib_1 + fib_2

    if n == 0:
        return 0

    while fib_N < n:
        fib_2 = fib_1
        fib_1 = fib_N
        fib_N = fib_1 + fib_2
    index = -1

    while fib_N > 1:
        i = min(index + fib_2, (n - 1))
        if arr[i] < val:
            fib_N = fib_1
            fib_1 = fib_2
            fib_2 = fib_N - fib_1
            index = i
        elif arr[i] > val:
            fib_N = fib_2
            fib_1 = fib_1 - fib_2
            fib_2 = fib_N - fib_1
        else:
            print(f'Roll no {val} found at position {i + 1}')
            return

    if (fib_1 and index < n - 1) and (arr[index + 1] == val):
        print(f'Roll no {val} found at position {index + 2}')
        return

    print(f'Roll no {val} not found')
    return


def putdata(arr, n):
    print('\n\nFollowing are the student\'s roll no who have attended training program...\n')
    print('*********************************')
    print('|   Position    |    Roll No    |')
    print('*********************************')

    for i in range(n):
        print(f'|\t{i + 1}\t|\t{arr[i]}\t|')
    print('---------------------------------\n\n')


def main():
    n = int(input('\nEnter the total strenght that have attended training program: '))
    arr = []

    for i in range(n):
        arr.append(int(input(f'Enter the roll numbers: ')))
    putdata(arr, n)

    linearSearch(arr, n)

    sentinelSearch(arr, n)

    arr.sort()
    print('\n\nSorting the roll numbers gives:')
    putdata(arr, n)

    binarySearch(arr, n - 1)

    fibonacciSearch(arr, n)


if __name__ == "__main__":
    main()


"""

----------------- OUTPUT -----------------

Enter the total strenght that have attended training program: 10

Enter the roll numbers: 12
Enter the roll numbers: 82
Enter the roll numbers: 73
Enter the roll numbers: 34
Enter the roll numbers: 14
Enter the roll numbers: 98
Enter the roll numbers: 89
Enter the roll numbers: 11
Enter the roll numbers: 45
Enter the roll numbers: 29


Following are the student's roll no who have attended training program...

*********************************
|   Position    |    Roll No    |
*********************************
|       1       |       12      |
|       2       |       82      |
|       3       |       73      |
|       4       |       34      |
|       5       |       14      |
|       6       |       98      |
|       7       |       89      |
|       8       |       11      |
|       9       |       45      |
|       10      |       29      |
---------------------------------


Enter the Roll no you want to search using linear search: 11
Roll no 11 found at position 8


Enter the Roll no you want to search using sentinal search: 14
Roll no 14 found at position 5


Sorting the roll numbers gives:


Following are the student's roll no who have attended training program...

*********************************
|   Position    |    Roll No    |
*********************************
|       1       |       11      |
|       2       |       12      |
|       3       |       14      |
|       4       |       29      |
|       5       |       34      |
|       6       |       45      |
|       7       |       73      |
|       8       |       82      |
|       9       |       89      |
|       10      |       98      |
---------------------------------


Enter the Roll no you want to search using binary search: 12
Roll no 12 found at position 2


Enter the Roll no you want to search using fibonacci search: 98
Roll no 98 found at position 10

"""
