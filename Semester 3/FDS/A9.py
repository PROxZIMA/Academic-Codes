# DSL – ASSIGNMENT 3 – A9

class Matrix:
    def __init__(self, row, col):
        self.row = row
        self.col = col
        self.matrix_A = [i[:] for i in [[0]*self.col]*self.row]
        self.matrix_B = [i[:] for i in [[0]*self.col]*self.row]
        self.matrix_C = [i[:] for i in [[0]*self.col]*self.row]


    def getinp(self, mat):
        for i in range(self.row):
            for j in range(self.col):
                mat[i][j] = int(input(f'Enter the element of row {i+1} and column {j+1}: '))

    def printmat(self, mat):
        for i in mat:
            print('\t'.join(map(str, i)))

    def getmatrix(self):
        print('\n\nEnter Matrix A data: ')
        self.getinp(self.matrix_A)

        print('\nEnter Matrix B data: ')
        self.getinp(self.matrix_B)

        print('\n\nMatrix A')
        self.printmat(self.matrix_A)

        print('\nMatrix B')
        self.printmat(self.matrix_B)


    def addition(self):
        for i in range(self.row):
            for j in range(self.col):
                self.matrix_C[i][j] = self.matrix_A[i][j] + self.matrix_B[i][j]

        print("\n\nAddition matrix: ")
        self.printmat(self.matrix_C)


    def subtraction(self):
        for i in range(self.row):
            for j in range(self.col):
                self.matrix_C[i][j] = self.matrix_A[i][j] - self.matrix_B[i][j]

        print("\n\nSubtraction matrix: ")
        self.printmat(self.matrix_C)


    def multiply(self):
        for i in range(self.row):
            for j in range(self.col):
                self.matrix_C[i][j] = 0
                for k in range(self.row):
                    self.matrix_C[i][j] += self.matrix_A[i][k] * self.matrix_B[k][j]

        print("\n\nMultiplication matrix: ")
        self.printmat(self.matrix_C)


    def transpose(self):
        for i in range(self.row):
            for j in range(self.col):
                self.matrix_C[i][j] = self.matrix_A[j][i]

        print("\n\nTranspose of Matrix A: ")
        self.printmat(self.matrix_C)

        for i in range(self.row):
            for j in range(self.col):
                self.matrix_C[i][j] = self.matrix_B[j][i]

        print("\n\nTranspose of Matrix B: ")
        self.printmat(self.matrix_C)

def main():
    row = int(input('\nEnter number of rows: '))
    col = int(input('Enter number of columns: '))
    mat = Matrix(row, col)
    mat.getmatrix()
    mat.addition()
    mat.subtraction()
    mat.multiply()
    mat.transpose()

if __name__ == "__main__":
    main()


"""

---------------- OUTPUT -----------------

Enter number of rows: 3
Enter number of columns: 3


Enter Matrix A data:
Enter the element of row 1 and column 1: 1
Enter the element of row 1 and column 2: 5
Enter the element of row 1 and column 3: 2
Enter the element of row 2 and column 1: 4
Enter the element of row 2 and column 2: 3
Enter the element of row 2 and column 3: 2
Enter the element of row 3 and column 1: 7
Enter the element of row 3 and column 2: 4
Enter the element of row 3 and column 3: 5

Enter Matrix B data:
Enter the element of row 1 and column 1: 5
Enter the element of row 1 and column 2: 4
Enter the element of row 1 and column 3: 1
Enter the element of row 2 and column 1: 2
Enter the element of row 2 and column 2: 7
Enter the element of row 2 and column 3: 4
Enter the element of row 3 and column 1: 3
Enter the element of row 3 and column 2: 6
Enter the element of row 3 and column 3: 1


Matrix A
1       5       2
4       3       2
7       4       5

Matrix B
5       4       1
2       7       4
3       6       1


Addition matrix:
6       9       3
6       10      6
10      10      6


Subtraction matrix:
-4      1       1
2       -4      -2
4       -2      4


Multiplication matrix:
21      51      23
32      49      18
58      86      28


Transpose of Matrix A:
1       4       7
5       3       4
2       2       5


Transpose of Matrix B:
5       2       3
4       7       6
1       4       1

"""
