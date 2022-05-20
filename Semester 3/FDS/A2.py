# DSL – ASSIGNMENT 1 – A2

class Test:
    def __init__(self):
        self.fds = []
        self.n = 0


    def getdata(self):
        self.n = int(input('\nEnter the class strength of SE Comp A: '))
        print('\n(Note: Enter -1 for absent students)\n')
        print('---------------------------------------------------------')
        print('Enter the marks scored in Fundamental of Data Structure: ')
        print('---------------------------------------------------------\n\n')

        for i in range(self.n):
            self.fds.append(int(input(f'Enter marks of roll no {i + 1}: ')))


    def putdata(self):
        print('\n\nTest Marks of Fundamental of Data Structure are as follows...\n')
        print('*********************************')
        print('|    Roll No    |   DSA Marks   |')
        print('*********************************')

        for i in range(self.n):
            print(f'|\t{i + 1}\t|\t{self.fds[i]}\t|')
        print('---------------------------------\n\n')


    def avg(self):
        total = 0
        present = 0
        for i in self.fds:
            if i != -1:
                total += i
                present += 1

        print(f'Average marks of the class: {round(total / present, 3)}\n\n')


    def absstud(self):
        print('Students absent for Fundamental of Data Structure test are: \n')
        absent = 0
        for i in range(self.n):
            if self.fds[i] == -1:
                print(f'Roll No: {i + 1} absent')
                absent += 1

        print(f'\nTotal absent students are: {absent}\n\n')


    def maxmin(self):
        maxi, max_rollno, mini, min_rollno = 0, [], 10, []
        for i, val in enumerate(self.fds):
            if val != -1:
                if maxi == val:
                    max_rollno.append(i + 1)
                elif maxi < val:
                    max_rollno = [i + 1]
                    maxi = val

                if mini == val:
                    min_rollno.append(i + 1)
                elif mini >= val:
                    min_rollno = [i + 1]
                    mini = val

        max_rollno, min_rollno = ', '.join(map(str, max_rollno)), ', '.join(map(str, min_rollno))

        print(f'Highest Test Score : Roll No : ({max_rollno}) with Marks = {maxi}\n')
        print(f'Lowest Test Score : Roll No : ({min_rollno}) with Marks = {mini}\n\n')


    def frequency(self):
        max_marks = 10
        freq = [0] * (max_marks + 1)
        stud, marks, index = 0, 0, []

        for val in self.fds:
            if val != -1:
                freq[val] += 1

        for i, val in enumerate(freq):
            if stud <= val:
                marks = i
                stud = val

        for i, val in enumerate(self.fds):
            if val == marks:
                index.append(i + 1)

        index = ', '.join(map(str, index))
        print(f'Maximum of {marks} marks are scored by {stud} students with Roll No: ({index})')


def main():
    test = Test()
    test.getdata()
    test.putdata()
    test.avg()
    test.absstud()
    test.maxmin()
    test.frequency()

if __name__ == "__main__":
    main()


"""

----------------- OUTPUT -----------------

Enter the class strength of SE Comp A: 10

(Note: Enter -1 for absent students)

---------------------------------------------------------
Enter the marks scored in Fundamental of Data Structure:
---------------------------------------------------------


Enter marks of roll no 1: 2
Enter marks of roll no 2: 5
Enter marks of roll no 3: -1
Enter marks of roll no 4: 4
Enter marks of roll no 5: 2
Enter marks of roll no 6: 10
Enter marks of roll no 7: 6
Enter marks of roll no 8: 4
Enter marks of roll no 9: 10
Enter marks of roll no 10: 4


Test Marks of Fundamental of Data Structure are as follows...

*********************************
|    Roll No    |   DSA Marks   |
*********************************
|       1       |       2       |
|       2       |       5       |
|       3       |       -1      |
|       4       |       4       |
|       5       |       2       |
|       6       |       10      |
|       7       |       6       |
|       8       |       4       |
|       9       |       10      |
|       10      |       4       |
---------------------------------


Average marks of the class: 5.222


Students absent for Fundamental of Data Structure test are:

Roll No: 3 absent

Total absent students are: 1


Highest Test Score : Roll No : (6, 9) with Marks = 10

Lowest Test Score : Roll No : (1, 5) with Marks = 2


Maximum of 4 marks are scored by 3 students with Roll No: (4, 8, 10)

"""
