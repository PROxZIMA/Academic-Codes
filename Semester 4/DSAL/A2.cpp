#include <iostream>
#include <cstring>
#define size 7
using namespace std;

class Hashtable {
public:
    char key[size], value[size], k[size];
    string h[size][2];
    int count, ch;
    void input();
    void display();
    void hashf(char[]);
    void linearp(string key, int);
    void search();
    void Delete();
    Hashtable() {
        for (int i = 0; i < size; i++)
            for (int j = 0; j < 2; j++)
                h[i][j] = "---";

        count = 0;
    }
};

void Hashtable ::input() {
    cout << "\nEnter the key: ";
    cin >> key;
    cout << "Enter the value: ";
    cin >> value;
    hashf(key);
}

void Hashtable ::hashf(char key[]) {
    int sum = 0;
    for (int i = 0; i < strlen(key); i++)
        sum = sum + int(key[i]);

    ch = sum % size;
    linearp(key, ch);
}

void Hashtable ::linearp(string key, int ch) {
    if (count == size)
        cout << "Table is Full";

    else {
        while (h[ch][0] != "---" && count != size)
            ch = ++ch % size;

        h[ch][0] = key;
        h[ch][1] = value;
        count++;
    }
}

void Hashtable ::display() {
    cout << "\n\t[Key]\t[Value]\n";
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < 2; j++)
            cout << "\t" << h[i][j];

        cout << "\n";
    }
}

void Hashtable ::search() {
    cout << "\nEnter the string to search: ";
    cin >> k;
    int sum = 0;
    for (int i = 0; i < strlen(k); i++)
        sum = sum + int(k[i]);

    ch = sum % size;
    if (count == size)
        cout << "\nSearch is not found \n";

    else {
        while (h[ch][0] != k && count != size)
            ch = ++ch % size;

        count++;
        if (h[ch][0] == k)
            cout << "String '" << k << "' found at index " << ch << "\n";
    }
}

void Hashtable ::Delete() {
    cout << "\nEnter the string to delete: ";
    cin >> k;
    int sum = 0;
    for (int i = 0; i < strlen(k); i++)
        sum = sum + int(k[i]);

    ch = sum % size;
    if (count == size)
        cout << "Search is not found \n";

    else
        while (h[ch][0] != k && count != size)
            ch = ++ch % size;

    h[ch][0] = "---";
    h[ch][1] = "---";
    cout << "String '" << k << "' deleted from index " << ch << "\n";
}

int main() {
    int ch;
    Hashtable h1;
    do {
        cout << "\nEnter choice\n1.input  2.display  3.search  4.Delete\nChoice [1/2/3/4] ";
        cin >> ch;
        switch (ch) {
            case 1:
                h1.input();
                break;
            case 2:
                h1.display();
                break;
            case 3:
                h1.search();
                break;
            case 4:
                h1.Delete();
                break;
        }
    } while (ch < 5);
    return 0;
}


/*
Enter choice
1.input  2.display  3.search  4.Delete
Choice [1/2/3/4] 1

Enter the key: name
Enter the value: Pratik

        [Key]   [Value]
        ---     ---
        ---     ---
        ---     ---
        ---     ---
        name    Pratik
        ---     ---
        ---     ---


Enter choice
1.input  2.display  3.search  4.Delete
Choice [1/2/3/4] 1

Enter the key: roll
Enter the value: 56

        [Key]   [Value]
        roll    56
        ---     ---
        ---     ---
        ---     ---
        name    Pratik
        ---     ---
        ---     ---


Enter choice
1.input  2.display  3.search  4.Delete
Choice [1/2/3/4] 3

Enter the string to search: roll
String 'roll' found at index 0


Enter choice
1.input  2.display  3.search  4.Delete
Choice [1/2/3/4] 4

Enter the string to delete: name
String 'name' deleted from index 4


Enter choice
1.input  2.display  3.search  4.Delete
Choice [1/2/3/4] 2

        [Key]   [Value]
        roll    56
        ---     ---
        ---     ---
        ---     ---
        ---     ---
        ---     ---
        ---     ---
*/