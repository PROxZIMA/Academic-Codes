#include <iostream>
#include <iomanip>
using namespace std;

#define size 13

class linear_probing {
    int hash[size], flag[size];

public:
    linear_probing() {
        int i;
        for (i = 0; i < size; i++) {
            flag[i] = 0;
        }
    }

    void insert(int x) {
        int i, loc;
        loc = x % size;
        for (i = 0; i < size; i++) {
            if (flag[loc] == 0) {
                hash[loc] = x;
                flag[loc] = 1;
                break;
            }
            else {
                loc = (loc + 1) % size;
            }
        }
    }

    void create() {
        int x, i, n;
        cout << "\nEnter the number of phone numbers to be inserted:\n";
        cin >> n;
        cout << "\nEnter the Phone numbers to be inserted in Hash table ->\n";
        for (i = 0; i < n; i++) {
            cin >> x;
            insert(x);
        }
    }

    int find(int x) {
        int loc = x % size;
        int i;
        for (i = 0; i < size; i++) {
            if (flag[loc] == 1 && hash[loc] == x) {
                return loc;
            }
            else
                loc = (loc + 1) % size;
        }
        return -1;
    }

    void search() {
        int x, loc;
        cout << "\nEnter the phone number to be search:\n";
        cin >> x;
        if ((loc = find(x)) == -1)
            cout << "\nPhone number is not found\n";
        else
            cout << "\nPhone number " << x << " is found at " << loc << "th location\n\n";
    }

    void print() {
        int i;
        cout << "\nHash Table is ->"
             << endl;
        for (i = 0; i < size; i++) {
            cout << "(" << i << ") -> ";
            if (flag[i] == 1) {
                cout << hash[i] << "\n";
            }
            else if (flag[i] == 0)
                cout << "----\n";
        }
    }
};


struct node {
    node *next;
    int phone;
};

class Chaining {
    node *hash[size];

public:
    Chaining() {
        int i;
        for (i = 0; i < size; i++)
            hash[i] = NULL;
    }

    void create() {
        int x, n, i;
        cout << "\nEnter the number of phone numbers to be inserted :\n";
        cin >> n;
        cout << "\nEnter the Phone numbers to be inserted in Hash table ->\n";
        for (i = 0; i < n; i++) {
            cin >> x;
            insert(x);
        }
    }

    void insert(int key) {
        int loc = key % size;
        node *p = new node;
        p->phone = key;
        p->next = NULL;
        if (hash[loc] == NULL) {
            hash[loc] = p;
        }
        else {
            node *q = hash[loc];
            while (q->next != NULL) {
                q = q->next;
            }
            q->next = p;
        }
    }

    void display() {
        int i;
        cout << "\nHash Table is -> :\n";
        for (i = 0; i < size; i++) {
            node *q = hash[i];
            cout << "(" << i << ") -> ";
            while (q) {
                cout << q->phone;
                if (q->next)
                    cout << " -> ";
                q = q->next;
            }
            cout << "\n";
        }
    }
};


int main() {
    cout << "----------------- Linear Probing -----------------\n";
    linear_probing lp;
    lp.create();
    lp.print();
    lp.search();

    cout << "\n----------------- Separate Chaining -----------------\n";
    Chaining h;
    h.create();
    h.display();
    return 0;
}


/*
----------------- Linear Probing -----------------

Enter the number of phone numbers to be inserted:
5

Enter the phone numbers to be inserted in hash table ->
123 136 284 297 448

Hash Table is ->
(0) -> ----
(1) -> ----
(2) -> ----
(3) -> ----
(4) -> ----
(5) -> ----
(6) -> 123
(7) -> 136
(8) -> 448
(9) -> ----
(10) -> ----
(11) -> 284
(12) -> 297

Enter the phone number to be search:
448

Phone number 448 is found at 8th location


----------------- Separate Chaining -----------------

Enter the number of phone numbers to be inserted :
5

Enter the Phone numbers to be inserted in Hash table
123 136 284 297 448

Hash Table is -> :
(0) ->
(1) ->
(2) ->
(3) ->
(4) ->
(5) ->
(6) -> 123 -> 136 -> 448
(7) ->
(8) ->
(9) ->
(10) ->
(11) -> 284 -> 297
(12) ->
*/