#include <iostream>
#include <fstream>
using namespace std;

class Record {
    int rollno;
    string name;
    int division;
    string address;

public:
    Record();
    int getRollno();
    void getData();
    void putData();
};

Record::Record() {
    rollno = 0;
    name = ' ';
    address = ' ';
    division = 0;
}

int Record::getRollno() {
    return (rollno);
}

void Record::getData() {
    cout << "\nEnter Details: ";
    cout << "\nRoll no: ";
    cin >> rollno;
    cout << "Name: ";
    cin >> name;
    cout << "Division Code: ";
    cin >> division;
    cout << "Address: ";
    cin >> address;
}

void Record::putData() {
    cout << "\nRoll No.: ";
    cout << rollno;
    cout << "\t\tName: ";
    cout << name;
    cout << "\nDivision Code: ";
    cout << division;
    cout << "\tAddress: ";
    cout << address;
}

class File {
    ifstream fin;
    ofstream fout;
    fstream fs;

public:
    void insert();
    void display();
    void search(int);
    int Delete(int);
    int edit(int);
};

void File::insert() {
    Record r;
    r.getData();
    fout.open("StudentDB", ios::ate | ios::app);
    fout.write((char *)&r, sizeof(r));
    fout.close();
}

void File::display() {
    Record r;
    fin.open("StudentDB");
    fin.seekg(0, ios::beg);
    while (fin.read((char *)&r, sizeof(r)))
        r.putData();

    fin.close();
}

void File::search(int rollno) {
    Record r;
    int flag = 0;
    fin.open("StudentDB");
    fin.seekg(0, ios::beg);
    while (fin.read((char *)&r, sizeof(r))) {
        if (r.getRollno() == rollno) {
            flag = 1;
            break;
        }
    }

    fin.close();
    if (flag == 1) {
        cout << "\nRecord Found:";
        r.putData();
    }
    else
        cout << "\nRecord not Found ";
}

int File::Delete(int rollno) {
    Record r;
    int flag = 0;
    fin.open("StudentDB");
    fout.open("Temp", ios::ate | ios::app);
    fin.seekg(0, ios::beg);
    while (fin.read((char *)&r, sizeof(r))) {
        if (r.getRollno() == rollno) {
            flag = 1;
        }
        else {
            fout.write((char *)&r, sizeof(r));
        }
    }
    fin.close();
    fout.close();
    remove("StudentDB");
    rename("Temp", "StudentDB");
    return (flag);
}

int File::edit(int rollno) {
    Record r;
    int flag = 0;
    fs.open("StudentDB");
    fs.seekg(0, ios::beg);
    while (fs.read((char *)&r, sizeof(r))) {
        if (r.getRollno() == rollno) {
            flag = 1;
            cout << "\nEnter New Details: ";
            r.getData();
            fs.seekp((int)fs.tellg() - sizeof(r), ios::beg);
            fs.write((char *)&r, sizeof(r));
        }
    }
    fs.close();
    return (flag);
}

int main() {
    File f;
    int ch, n, i, flag = 0;
    do {
        cout << "\n\n\t-----M E N U-----";
        cout << "\n\n1. Build A Master Table";
        cout << "\n2. List A Table";
        cout << "\n3. Insert a New Entry";
        cout << "\n4. Delete Old Entry";
        cout << "\n5. Edit an Entry";
        cout << "\n6. Search for a Record";
        cout << "\n7. Quit";
        cout << "\nEnter your Choice: ";
        cin >> ch;
        switch (ch) {
            case 1:
                if (flag == 0) {
                    cout << "\nEnter No of Records to insert : ";
                    cin >> n;
                    for (i = 0; i < n; i++) {
                        f.insert();
                    }
                    flag = 1;
                }
                else {
                    cout << "\nSorry.. Table is Already build... \n If want to add record please select Insert a New Entry in option.....";
                }
                break;
            case 2:
                f.display();
                break;
            case 3:
                f.insert();
                break;
            case 4:
                cout << "\nEnter Roll No of Student Whose Record is to be Deleted: ";
                cin >> n;
                i = f.Delete(n);
                if (i == 1)
                    cout << "\nRecord Deleted Successfully";
                else
                    cout << "\nRecord not Found";
                break;
            case 5:
                cout << "\nEnter Roll No of Student Whose Record is to be Edit: ";
                cin >> n;
                i = f.edit(n);
                if (i == 1)
                    cout << "\nRecord Modified Successfully";
                else
                    cout << "\nRecord not Found";
                break;
            case 6:
                cout << "\nEnter Roll No of Student Whose Record is to be Searched: ";
                cin >> n;
                f.search(n);
                break;
            case 7:
                break;
            default:
                cout << "\nEnter Valid Choice.....";
        }
    } while (ch != 7);
    return (0);
}


/*
----------------------- OUTPUT -----------------------

        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 1

Enter No of Records to insert : 3

Enter Details:
Roll no: 123
Name: Alex
Division Code: 4001
Address: Pune

Enter Details:
Roll no: 456
Name: Loro
Division Code: 4002
Address: Mumbai

Enter Details:
Roll no: 789
Name: Pratik
Division Code: 4003
Address: Delhi


        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 2

Roll No.: 123          Name: Alex
Division Code: 4001     Address: Pune


Roll No.: 456          Name: Loro
Division Code: 4002     Address: Mumbai


Roll No.: 789          Name: Pratik
Division Code: 4003     Address: Delhi



        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 3

Enter Details:
Roll no: 159
Name: Yami
Division Code: 4004
Address: Pune


        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 2

Roll No.: 123          Name: Alex
Division Code: 4001     Address: Pune


Roll No.: 456          Name: Loro
Division Code: 4002     Address: Mumbai


Roll No.: 789          Name: Pratik
Division Code: 4003     Address: Delhi


Roll No.: 159          Name: Yami
Division Code: 4004     Address: Pune



        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 4

Enter Roll No of Student Whose Record is to be Deleted: 789

Record Deleted Successfully

        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 2

Roll No.: 123          Name: Alex
Division Code: 4001     Address: Pune


Roll No.: 456          Name: Loro
Division Code: 4002     Address: Mumbai


Roll No.: 159          Name: Yami
Division Code: 4004     Address: Pune



        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 5

Enter Roll No of Student Whose Record is to be Edit: 123

Enter New Details :
Enter Details:
Roll no: 123
Name: Alex
Division Code: 4001
Address: Pune

Record Modified Successfully

        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 2

Roll No.: 123          Name: Alex
Division Code: 4001     Address: Pune


Roll No.: 456          Name: Loro
Division Code: 4002     Address: Mumbai


Roll No.: 159          Name: Yami
Division Code: 4004     Address: Pune



        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 6

Enter Roll No of Student Whose Record is to be Searched: 159

Record Found:
Roll No.: 159          Name: Yami
Division Code: 4004     Address: Pune



        -----M E N U-----

1. Build A Master Table
2. List A Table
3. Insert a New Entry
4. Delete Old Entry
5. Edit an Entry
6. Search for a Record
7. Quit
Enter your Choice: 7
*/