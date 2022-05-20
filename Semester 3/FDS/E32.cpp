/* DSL – EXPERIMENT 13 – E32 */

#include <iostream>
using namespace std;

#define MAX 5


string arr[3] = {"Veg Soya Pizza", "Veg butter Pizza", "Chicken Pizza"};

class Pizza {
    int order[MAX];
    int front,rear;

    public:
        Pizza() {
            front = rear = -1;
        }

        int isFull() {
            return ((front == 0) && (rear == (MAX - 1)) || (front == (rear + 1) % MAX));
        }

        int isEmpty() {
            return (front == -1);
        }

        void accept_order(int);
        void make_payment(int);
        void order_in_queue();
};


void Pizza::accept_order(int item) {

    if (isFull())
        cout<<"\nVery Sorry !!!! No more orders....\n";

    else {
        if (front == -1)
            front = rear = 0;

        else
            rear = (rear + 1) % MAX;

        order[rear] = item;
    }
}


void Pizza::make_payment(int n) {
    int item;
    char ans;

    if (isEmpty())
        cout<<"\nSorry !!! There are no pending orders....\n";

    else {
        cout<<"\nDeliverd orders as follows...\n";

        for(int i = 0; i < n; i++) {

            item = order[front];

            if(front == rear)
                front = rear = -1;

            else
                front = (front + 1) % MAX;

            cout << arr[item - 1] << " ,  ";
        }
        cout << "\n\nTotal amount to pay = " << n * 100;
        cout << "\nThank you visit Again....\n";
    }
}


void Pizza::order_in_queue() {
    int i;

    if (isEmpty())
        cout << "\nSorry !! There is no pending order...\n";

    else {
        i = front;
        cout << "\nPending Order as follows..\n";

        while (i != rear) {
            cout << arr[order[i] - 1] << " ,  ";
            i = (i + 1) % MAX;
        }

        cout << arr[order[i] - 1] << "\n";
    }
}


int main()
{
    Pizza pizza;
    int ch,k,n;

    do {
        cout<< "\n\n\t***** Welcome To Pizza Parlor *******\n"
            << "\n1. Accept order\n2. Make_payment\n3. Pending Orders\n4. Exit"
            << "\nEnter your choice: ";
        cin >> ch;

        switch(ch) {
            case 1:
                cout<< "\nWhich Pizza do u like most....\n"
                    << "\n1. Veg Soya Pizza\n2. Veg butter Pizza\n3. Chicken Pizza"
                    << "\nPlease enter your order: ";
                cin >> k;
                pizza.accept_order(k);
                break;

            case 2:
                cout << "\nHow many Pizza do you want? ";
                cin >> n;
                pizza.make_payment(n);
                break;


            case 3:
                cout << "\nFollowing orders are in queue to deliver....as follows..\n";
                pizza.order_in_queue();
                break;
        }
    } while (ch != 4);

    return 0;
}



/*

------------------ OUTPUT -------------------


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 1


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 2


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 3


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 1


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 2


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 1

Which Pizza do u like most....

1. Veg Soya Pizza
2. Veg butter Pizza
3. Chicken Pizza
Please enter your order: 3

Very Sorry !!!! No more orders....


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 3

Following orders are in queue to deliver....as follows..

Pending Order as follows..
Veg Soya Pizza ,  Veg butter Pizza ,  Chicken Pizza ,  Veg Soya Pizza ,  Veg butter Pizza


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 2

How many Pizza do you want? 3

Deliverd orders as follows...
Veg Soya Pizza ,  Veg butter Pizza ,  Chicken Pizza

Total amount to pay = 300
Thank you visit Again....


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 3

Following orders are in queue to deliver....as follows..

Pending Order as follows..
Veg Soya Pizza ,  Veg butter Pizza


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 2

How many Pizza do you want? 2

Deliverd orders as follows...
Veg Soya Pizza ,  Veg butter Pizza

Total amount to pay = 200
Thank you visit Again....


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 3

Following orders are in queue to deliver....as follows..

Sorry !! There is no pending order...


        ***** Welcome To Pizza Parlor *******

1. Accept order
2. Make_payment
3. Pending Orders
4. Exit
Enter your choice: 4

*/