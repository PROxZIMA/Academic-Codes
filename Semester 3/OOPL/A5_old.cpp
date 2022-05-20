/* OOPL – ASSIGNMENT – A5 */

#include <iostream>
#include <string>
using namespace std;

class book {
    string author, title, publisher;
    int price, stock;

    public:
        book();
        void get_data();
        void display_data();
        int search(string, string);
        void copies(int);
};

book::book() {
    string * author = new string;
    string * title = new string;
    string * publisher = new string;
    price = 0;
    stock = 0;
}

void book::get_data() {
    cout << "\nEnter name of the author: ";
    cin.ignore();
    getline(cin, author);
    cout << "\nEnter title of the book: ";
    getline(cin, title);
    cout << "\nEnter publisher of the book: ";
    getline(cin, publisher);
    cout << "\nEnter price of the book: ";
    cin >> price;
    cout << "\nEnter stock of book: ";
    cin >> stock;
}

void book::display_data() {
    printf("%-17s %-22s %-18s %-7d %-6d\n", author.c_str(), title.c_str(), publisher.c_str(), price, stock);
}

int book::search(string a, string b) {
    if (author == a && title == b)
        return 1;
    else
        return 0;
}

void book::copies(int cop) {
    if (stock >= cop)
        cout << "\nPrice for " << cop << " copies is: " << (price * cop);
    else
        cout << "\n*Not available*";
}

int main() {
    cout << "\t\t***Book Inventory***";

    int i, choice, flag, n, key, c;
    char con;
    string s_author, s_title;
    book b[50];

    do {
        cout << "\n1)Upgrade the inventory\n2)Display\n3)Search the book\n";
        cout << "\nEnter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1: {
                cout << "\nHow many books do you want to involve: ";
                cin >> n;

                for (i = 0; i < n; i++) {
                    cout << "\n\nEnter details of book number " << i + 1 << "\n";
                    b[i].get_data();
                }
                break;
            }
            case 2: {
                printf("\n%-17s %-22s %-18s %-7s %-6s\n", "Author", "Title", "Publisher", "Price", "Stock");
                for (i = 0; i < n; i++) {
                    b[i].display_data();
                }
                break;
            }
            case 3: {
                cout << "\nEnter the name of the author: ";
                cin.ignore();
                getline(cin, s_author);
                cout << "\nEnter the title of the book: ";
                getline(cin, s_title);

                for (i = 0; i < n; i++) {
                    if (b[i].search(s_author, s_title)) {
                        key = i;
                        flag = 1;
                        if (flag == 1)
                            cout << "\nBook is available";
                        else {
                            cout << "\nNo such book in the inventory";
                            break;
                        }
                    }
                }

                if (flag == 1) {
                    cout << "\nEnter no. of copies you want: ";
                    cin >> c;
                    b[key].copies(c);
                }
                break;
            }
        }

        cout << "\nDo you want to continue(y/n): ";
        cin >> con;
    } while (con != 'n');

    return 0;
}





/*

----------------- OUTPUT ------------------

                ***Book Inventory***
1)Upgrade the inventory
2)Display
3)Search the book

Enter your choice: 1

How many books do you want to involve: 3


Enter details of book number 1

Enter name of the author: Robin Cook

Enter title of the book: Abduction

Enter publisher of the book: Pac Man Millian

Enter price of the book: 349

Enter stock of book: 4


Enter details of book number 2

Enter name of the author: Chetan Bhagat

Enter title of the book: Revolution 2020

Enter publisher of the book: Rupa

Enter price of the book: 499

Enter stock of book: 6


Enter details of book number 3

Enter name of the author: Jeffery Archer

Enter title of the book: Only Time Will Tell

Enter publisher of the book: Pac Man Millian

Enter price of the book: 699

Enter stock of book: 2

Do you want to continue(y/n): y

1)Upgrade the inventory
2)Display
3)Search the book

Enter your choice: 2

Author            Title                  Publisher          Price   Stock

Robin Cook        Abduction              Pac Man Millian    349     4
Chetan Bhagat     Revolution 2020        Rupa               499     6
Jeffery Archer    Only Time Will Tell    Pac Man Millian    699     2

Do you want to continue(y/n): y

1)Upgrade the inventory
2)Display
3)Search the book

Enter your choice: 3

Enter the name of the author: Robin Cook

Enter the title of the book: Abduction

Book is available
Enter no. of copies you want: 3

Price for 3 copies is: 1047
Do you want to continue(y/n): n

*/
