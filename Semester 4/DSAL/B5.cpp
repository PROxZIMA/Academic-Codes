#include <iostream>
#include <string>
using namespace std;

struct node {
    string label;
    int count;
    node *child[50];
} *root;

class Tree {
public:
    void insert();
    void display();

    Tree() {
        root == NULL;
    }
};

void Tree::insert() {
    root = new node();
    cout <<"\nEnter the name of book: ";
    getline(cin >> ws, root->label);

    cout <<"Enter the total number of chapters in book: ";
    cin >> root->count;

    for (int i = 0; i < root->count; i++) {
        root->child[i] = new node();

        cout <<"\nEnter the name of chapters " << i + 1 << ": ";
        getline(cin >> ws, root->child[i]->label);

        cout <<"Enter the number of sections: ";
        cin >> root->child[i]->count;

        for (int j = 0; j < root->child[i]->count; j++) {
            root->child[i]->child[j] = new node();

            cout <<"\nEnter the name of section " << i + 1 << '.' << j + 1 << ": ";
            getline(cin >> ws, root->child[i]->child[j]->label);

            cout <<"Enter the number of sub sections: ";
            cin >> root->child[i]->child[j]->count;
            cout << '\n';

            for (int k = 0; k < root->child[i]->child[j]->count; k++) {
                root->child[i]->child[j]->child[k] = new node();

                cout <<"Enter the name of sub section " << i + 1 << '.' << j + 1 << '.' << k + 1 << ": ";
                getline(cin >> ws, root->child[i]->child[j]->child[k]->label);
            }
        }
    }
}

void Tree::display() {
    if (root != NULL) {
        cout <<"\n\n--------------- Hierarchy of Book ---------------\n\n";
        cout <<"Book Name: "<< root->label << endl;
        for (int i = 0; i < root->count; i++) {
            cout <<"\n> "<< root->child[i]->label << endl;
            for (int j = 0; j < root->child[i]->count; j++) {
                cout <<"---> "<< root->child[i]->child[j]->label << endl;
                for (int k = 0; k < root->child[i]->child[j]->count; k++) {
                    cout <<"------> "<< root->child[i]->child[j]->child[k]->label << endl;
                }
            }
        }
    }
}

int main() {
    Tree g;
    int ch;
    do {
        cout <<"\nEnter choice\n1.input  2.display\nChoice [1/2] ";
        cin >> ch;

        switch (ch) {
            case 1:
                g.insert();
                break;
            case 2:
                g.display();
                break;
        }
    } while (ch < 3);
    return 0;
}


/*
Enter choice
1.input  2.display
Choice [1/2] 1

Enter the name of book: Data Structure & Algorithm
Enter the total number of chapters in book: 2

Enter the name of chapters 1: Hashing
Enter the number of sections: 2

Enter the name of section 1.1: Hash Function
Enter the number of sub sections: 2

Enter the name of sub section 1.1.1: Division Method
Enter the name of sub section 1.1.2: Mid Square

Enter the name of section 1.2: Collision Resolution
Enter the number of sub sections: 2

Enter the name of sub section 1.2.1: Probing
Enter the name of sub section 1.2.2: Chaining

Enter the name of chapters 2: Trees
Enter the number of sections: 2

Enter the name of section 2.1: Properties of Trees
Enter the number of sub sections: 2

Enter the name of sub section 2.1.1: Height
Enter the name of sub section 2.1.2: Depth

Enter the name of section 2.2: Traversals
Enter the number of sub sections: 2

Enter the name of sub section 2.2.1: Depth First Search
Enter the name of sub section 2.2.2: Breadth First Search

Enter choice
1.input  2.display
Choice [1/2] 2


--------------- Hierarchy of Book ---------------

Book Name: Data Structure & Algorithm

> Hashing
---> Hash Function
------> Division Method
------> Mid Square
---> Collision Resolution
------> Probing
------> Chaining

> Trees
---> Properties of Trees
------> Height
------> Depth
---> Traversals
------> Depth First Search
------> Breadth First Search

Enter choice
1.input  2.display
Choice [1/2] 3
*/