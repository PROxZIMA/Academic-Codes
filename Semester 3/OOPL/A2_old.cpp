/* OOPL - ASSIGNMENT - A2 */

#include<iostream>
using namespace std;

class calculator {
    int num1,num2;
    float result;

    public:
        void getData();
        void putData();
        void add();
        void sub();
        void mul();
        void div();
        void mod();
};

void calculator::getData() {
    cout << "Enter two numbers: ";
    cin >> num1 >> num2;
}

void calculator::putData() {
    cout << "Num1 = " << num1 << "\tNum2 = " << num2 << "\tResult = " << result;
}

void calculator::add() {
    result = num1 + num2;
}

void calculator::sub() {
    result = num1 - num2;
}

void calculator::mul() {
    result = num1 * num2;
}

void calculator::mod() {
    result = num1 % num2;
}

void calculator::div() {
    result = num1 / float(num2);
}

int main() {
    calculator c;
    char choice,ans;

    do {
        cout << "\n**********MENU**********\n";
        cout << "1. +\n2. - \n3. * \n4. / \n5. %\nEnter your operator: ";
        cin >> choice;
        c.getData();

        switch(choice) {
            case '+':
                c.add();
                break;
            case '-':
                c.sub();
                break;
            case '*':
                c.mul();
                break;
            case '/':
                c.div();
                break;
            case '%':
                c.mod();
                break;
        }
        c.putData();
        cout << "\nDo you want to continue(Y/N): ";
        cin >> ans;
    } while(ans == 'Y' || ans == 'y');

    return 0;
}

/*

----------------- OUTPUT -----------------

**********MENU**********
1. +
2. -
3. *
4. /
5. %
Enter your operator: +
Enter two numbers: 8 5
Num1 = 8        Num2 = 5        Result = 13
Do you want to continue(Y/N): Y

**********MENU**********
1. +
2. -
3. *
4. /
5. %
Enter your operator: -
Enter two numbers: 5 10
Num1 = 5        Num2 = 10       Result = -5
Do you want to continue(Y/N): Y

**********MENU**********
1. +
2. -
3. *
4. /
5. %
Enter your operator: *
Enter two numbers: 8 1
Num1 = 8        Num2 = 1        Result = 8
Do you want to continue(Y/N): Y

**********MENU**********
1. +
2. -
3. *
4. /
5. %
Enter your operator: /
Enter two numbers: 10 4
Num1 = 10       Num2 = 4        Result = 2.5
Do you want to continue(Y/N): Y

**********MENU**********
1. +
2. -
3. *
4. /
5. %
Enter your operator: %
Enter two numbers: 12 7
Num1 = 12       Num2 = 7        Result = 5
Do you want to continue(Y/N): N

*/
