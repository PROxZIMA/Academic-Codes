/* OOPL – ASSIGNMENT – A3 */

#include<iostream>
#include<cstring>
#include<cstdlib>
using namespace std;

class Student {
    private:
        char *name, *class1, *div, *dob, *bldgrp,  *address, *drv;
        int rno, phone;
        static int counter;
    public:
        Student();
        Student(char *, int, char *, int, char *, char *, char *, char *, char *);
        ~Student();
        inline void getDetails();
        inline void showDetails();
        static void count();
};

int Student::counter;

Student::Student() {
    name = new char[1];
    class1 = new char[1];
    div = new char[1];
    dob = new char[1];
    bldgrp = new char[1];
    address = new char[1];
    drv = new char[1];
    rno = 0;
    phone = 0;
}

Student::Student(char *name, int rno,  char *address, int phone, char *class1, char *div, char *dob, char *bldgrp, char *drv) {
    int len = strlen(name);
    this->name = new char[len+1];
    strcpy(this->name, name);

    len = strlen(class1);
    this->class1 = new char[len+1];
    strcpy(this->class1, class1);

    len = strlen(div);
    this->div = new char[len+1];
    strcpy(this->div, div);

    len = strlen(dob);
    this->dob = new char[len+1];
    strcpy(this->dob, dob);

    len = strlen(bldgrp);
    this->bldgrp = new char[len+1];
    strcpy(this->bldgrp, bldgrp);

    len = strlen(address);
    this->address = new char[len+1];
    strcpy(this->address, address);

    len = strlen(drv);
    this->drv = new char[len+1];
    strcpy(this->drv, drv);

    this->rno = rno;
    this->phone = 0;
}

Student::~Student() {
    delete name;
    delete address;
    delete dob;
    delete drv;
    delete bldgrp;
    delete class1;
    delete div;

    rno = 0;
    phone = 0;
    cout<<"\nThank you for deleting details\n";
}

void Student::getDetails() {
    cout<<"\n*******Enter Details of Student ********\n";
    cout<<"Name : ";
    cin>>name;

    cout<<"Roll No. : ";
    cin>>rno;

    cout<<"Class : ";
    cin>>class1;

    cout<<"Div : ";
    cin>>div;

    cout<<"Address: ";
    cin>>address;

    cout<<"Phone : ";
    cin>>phone;

    cout<<"Date of Birth : ";
    cin>>dob;

    cout<<"Driving License : ";
    cin>>drv;

    cout<<"Blood Group : ";
    cin>>bldgrp;
}

void Student::showDetails() {
    Student::count();
    cout<<"\nName : "<<name;
    cout<<"\tRoll No. : "<<rno;
    cout<<"\nClass : "<<class1;
    cout<<"\tDiv : "<<div;
    cout<<"\nAddress: "<<address;
    cout<<"\tPhone : "<<phone;
    cout<<"\nDate of Birth : "<<dob;
    cout<<"\tDriving License : "<<drv;
    cout<<"\tBlood Group : "<<bldgrp<<endl;

}

void Student::count() {
    counter++;
    cout<<"\n**************** Details of Student "<<counter<<"****************\n";
}

int main() {
    cout<<"\n*************** Student Information System ***********\n";
    cout<<"How many student you have? ";
    int num;
    cin>>num;

    Student s[num];
    for(int i = 0;i<num;i++) {
        s[i].getDetails();
    }

    system("clear");
    cout<<"\n*************** Student Information System ***********\n";

    for(int i = 0;i<num;i++) {
        s[i].showDetails();
    }

    return 0;
}


/*
----------------- OUTPUT -------------------


*************** Student Information System ***********

**************** Details of Student 1****************

Name : Pratik   Roll No. : 56
Class : 1       Div : 4
Address: Pune,Maharashtra,India Phone : 568457986
Date of Birth : 27/10/2001      Driving License : Yes   Blood Group : A+

**************** Details of Student 2****************

Name : Shama    Roll No. : 61
Class : 2       Div : 1
Address: Mumbai Phone : 45865436
Date of Birth : 04/01/2001      Driving License : No    Blood Group : B-ve

Thank you for deleting details

Thank you for deleting details

*/
