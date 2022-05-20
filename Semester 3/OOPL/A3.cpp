/* OOPL – ASSIGNMENT – A4 */

#include <iostream>
using namespace std;

class Marketing {
    public:
        Marketing() {
            title = "";
            price = 0.0;
        }

        Marketing(string title, float price) {
            this->title = title;
            this->price = price;
        }

        void getData() {
            cout << "\nEnter title and price\n";
            cin >> title >> price;
        }

        void putData() {
            try {
                if(title.length()<3)
                    throw title;
                if(price <= 0.0)
                    throw price;
            }
            catch(string) {
                cout << "\nError: Title below 3 characters is not allowed";
                title = "";
            }
            catch(float f) {
                cout << "\nError: Price not valid: \t" << f;
                price = 0.0;
            }
            cout << "\nTitle is :" << title;
            cout << "\nPrice is :" << price;
        }

    private:
        string title;
        float price;
};

class Book: public Marketing {
    public:
        Book():Marketing() {
            pages = 0;
        }

        Book(string title, float price, int pages):Marketing(title,price) {
            this->pages = pages;
        }

        void getData() {
            Marketing::getData();
            cout << "\nEnter no. of pages in book\n";
            cin >> pages;
        }

        void putData() {
            Marketing::putData();
            try {
                if(pages<0)
                    throw pages;
            }
            catch(int f) {
                cout << "\nError: Pages not valid: \t" << f;
                pages = 0;
            }
            cout << "\nPages are :" << pages;
        }

    private:
        int pages;
};

class Cassette: public Marketing {
    public:
        Cassette():Marketing() {
            playtime = 0.0;
        }

        Cassette(string title, float price, float playtime):Marketing(title,price) {
            this->playtime = playtime;
        }

        void getData() {
            Marketing::getData();
            cout << "\nEnter play time of cassette\n";
            cin >> playtime;
        }

        void putData() {
            Marketing::putData();
            try {
                if(playtime<0.0)
                    throw playtime;
            }
            catch(float f) {
                cout << "\nError: Playtime not valid: \t" << f;
                playtime = 0.0;
            }
            cout << "\nPlaytime is :" << playtime;
        }

    private:
        float playtime;
};

int main() {
    Book book;
    cout << "\n***************BOOK**************\n";
    book.getData();

    cout << "\n***************CASSETTE**************\n";
    Cassette cassette;
    cassette.getData();

    cout << "\n***************BOOK**************\n";
    book.putData();

    cout << "\n***************CASSETTE**************\n";
    cassette.putData();

    return 0;
}





/*
----------------- OUTPUT ------------------

***************BOOK**************
Enter title and price
c++
111.44
Enter no. of pages in book
234
***************CASSETTE**************
Enter title and price
ddlj
100
Enter play time of cassette
23.4
***************BOOK**************
Title is :c++
Price is :111.44
Pages are :234
***************CASSETTE**************
Title is :ddlj
Price is :100
Playtime is :23.4
OUTPUT 2:
***************BOOK**************

Enter title and price
C
100
Enter no. of pages in book
-34
***************CASSETTE**************
Enter title and price
DDLJ
-100
Enter play time of cassette
23.4
***************BOOK**************
Error: Title below 3 characters is not allowed
Title is :
Price is :100
Error: Pages not valid: -34
Pages are :0
***************CASSETTE**************
Error: Price not valid: -100
Title is :DDLJ
Price is :0
Playtime is :23.4

*/
