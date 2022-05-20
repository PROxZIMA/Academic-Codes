/* OOPL – ASSIGNMENT – B3 */

#include<iostream>

using namespace std;

template < typename T >
    void input(T * a, int size) {
        cout << "\nEnter " << size << " elements in array: ";
        for (int i = 0; i < size; i++)
            cin >> a[i];
    }

template < typename T >
    void sorting(T * a, int size) {
        int min;
        for (int i = 0; i < size; i++) {
            min = i;
            for (int j = i + 1; j < size; j++)
                if (a[j] < a[min])
                    min = j;

            swap(a[i], a[min]);
        }
        cout << "\n";
    }

template < typename T >
    void display(T * a, int size) {
        for (int i = 0; i < size; i++)
            cout << a[i] << "\t";
    }

int main() {
    cout << "\nHow many elements you want to sort: ";
    int size;
    cin >> size;
    if (size < 1) {
        cout << "\nArray size can not be less than 0. Initializing size to 1";
        size = 1;
    }
    int a[size];
    input(a, size);
    cout << "\nElements before sorting\n";

    display(a, size);
    cout << "\nElements after sorting\n";

    sorting(a, size);
    display(a, size);
    float b[size];
    input(b, size);
    cout << "\nElements before sorting\n";

    display(b, size);
    cout << "\nElements after sorting\n";

    sorting(b, size);
    display(b, size);
    return 0;
}


/*

----------------- OUTPUT ------------------

How many elements you want to sort: 5

Enter 5 elements in array: 5 8 1 2 12

Elements before sorting
5       8       1       2       12
Elements after sorting
1       2       5       8       12

Enter 5 elements in array: 1.2 5.4 1.9 4.3 9.5

Elements before sorting
1.2     5.4     1.9     4.3     9.5
Elements after sorting
1.2     1.9     4.3     5.4     9.5

*/
