/* OOPL – ASSIGNMENT – A6 */

#include <iostream>
using namespace std;

class Personal {
    protected:
        char name[50];
        char address[50];
        char birthdate[50];
        char gender;
    public:
        void get_Personal(int x);
};

class Academic {
    protected:
        char clgname[50];
        int marks;
        int percentage;
        char Class[50];
    public:
        void get_Academic();
};

class Professional {
    protected:
        int yearsofexp;
        char orgname[50];
        char projname[50];
        char salary[50];
    public:
        void get_Professional();
};

class Biodata: public Personal,public Academic,public Professional {
    public:
        void display();
};

void Personal::get_Personal(int x) {
    cout << "\n\nEmployee no: " << x + 1 << "\n\n---Personal Details---\n";
    cout << "Enter name: ";
    cin.ignore();
    cin.getline(name, 50);
    cout << "Enter address: ";
    cin.getline(address, 50);
    cout << "Enter birthdate (dd/mm/yyyy): ";
    cin >> birthdate;
    cout << "Enter gender(M/F): ";
    cin >> gender;
}

void Academic::get_Academic() {
    cout << "\n---Academic Details---\n";
    cout << "College name: ";
    cin.ignore();
    cin.getline(clgname, 50);
    cout << "Enter total marks: ";
    cin >> marks;
    cout << "Enter percentage: ";
    cin >> percentage;
    cout << "Enter college year: ";
    cin >> Class;
}

void Professional::get_Professional() {
    cout << "\n---Professional Details---\n";
    cout << "Enter number of years of exp: ";
    cin >> yearsofexp;
    cout << "Enter organization name: ";
    cin.ignore();
    cin.getline(orgname, 50);
    cout << "Enter project name: ";
    cin >> projname;
    cout << "Enter salary: ";
    cin >> salary;
}

void Biodata::display() {
    cout << "\n\n\n---------------------Employee Biodata---------------------" << endl;
    cout << "\n_____________________Personal Details_____________________" << endl;
    cout << "\nName: " << name << endl;
    cout << "Address: " << address << endl;
    cout << "Birthdate: " << birthdate << endl;
    cout << "Gender: " << gender << endl;
    cout << "\n_____________________Academic Details_____________________" << endl;
    cout << "\nCollege name     \t" << "Marks " << "Percentage " << "Year " << endl;
    cout << clgname << "\t" << marks << "\t  " << percentage << "\t " << Class << endl;
    cout << "\n___________________Professional Details___________________" << endl;
    cout << "\nOrganization Name: " << orgname;
    cout << "\nYears of Experince: " << yearsofexp;
    cout << "\nProject Done: " << projname;
    cout << "\nProject Details: " << salary;
}

int main() {
    int n;
    cout << "\nNUMBER OF EMPLOYEES : ";
    cin >> n;
    Biodata b[n];

    for(int i = 0; i < n; i++){
        b[i].get_Personal(i);
        b[i].get_Academic();
        b[i].get_Professional();
    }

    cout << "\n\nWhich employee data you want to print: ";
    cin >> n;
    b[n - 1].display();
}


/*
----------------- OUTPUT -----------------

NUMBER OF EMPLOYEES : 3


Employee no: 1

---Personal Details---
Enter name: Jayesh Singh
Enter address: Nashik, Maharashtra
Enter birthdate (dd/mm/yyyy): 05/09/2020
Enter gender(M/F): M

---Academic Details---
College name: Nashik, Maharashtra
Enter total marks: 438
Enter percentage: 76
Enter college year: 2020

---Professional Details---
Enter number of years of exp: 0
Enter organization name: None
Enter project name: None
Enter salary: 0


Employee no: 2

---Personal Details---
Enter name: Pratik Pingale
Enter address: Pune, Maharashtra
Enter birthdate (dd/mm/yyyy): 27/10/2001
Enter gender(M/F): M

---Academic Details---
College name: AISSMS COE, Pune
Enter total marks: 639
Enter percentage: 93
Enter college year: 2020

---Professional Details---
Enter number of years of exp: 2
Enter organization name: Slack
Enter project name: Arc
Enter salary: 200000


Employee no: 3

---Personal Details---
Enter name: Ashika Shetty
Enter address: Mumbai, Maharashtra
Enter birthdate (dd/mm/yyyy): 28/02/2001
Enter gender(M/F): F

---Academic Details---
College name: St. Xavier's College
Enter total marks: 486
Enter percentage: 80
Enter college year: 2020

---Professional Details---
Enter number of years of exp: 1
Enter organization name: Minux
Enter project name: Beta
Enter salary: 15000


Which employee data you want to print: 2



---------------------Employee Biodata---------------------

_____________________Personal Details_____________________

Name: Pratik Pingale
Address: Pune, Maharashtra
Birthdate: 27/10/2001
Gender: M

_____________________Academic Details_____________________

College name            Marks Percentage Year
AISSMS COE, Pune        639       93     2020

___________________Professional Details___________________

Organization Name: Slack
Years of Experince: 2
Project Done: Arc
Project Details: 200000

*/
