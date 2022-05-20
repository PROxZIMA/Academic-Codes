/* DSL – EXPERIMENT 8 – C21 */

#include<iostream>
#include<cstring>
using namespace std;

struct node {
    string name;
    int time;
    struct node *next;
    struct node *prev;
};

class App {
    struct node *head,*p,*temp,*q;
    int size = 0;

    public:
        App() {
            head = NULL;
            p = NULL;
            temp = NULL;
        }

        void bookappment() {

            // If head isn't initialized yet
            if (p == NULL) {
                p = new (struct node);
                cout << "Enter your name: ";
                cin >> p->name;
                cout << "Enter slot time: ";
                cin >> p->time;
                p->next = NULL;
                p->prev = NULL;
                head = p;
            }

            // Every next node other than head
            else {
                temp = new (struct node);
                cout << "Enter your name: ";
                cin >> temp->name;
                cout << "Enter slot time: ";
                cin >> temp->time;
                if (p->next != NULL) p = p->next;
                temp->prev = p;
                p->next = temp;
                temp->next = NULL;
            }
            size += 1;
        }

        void freeslot() {
            int h = 12, x;
            cout << "\n";

            while (h <= 18) {
                p = head;
                x = 0;

                while(p!=NULL) {
                    if (p->time == h) x = 1;
                    p = p->next;
                }

                if (x == 0) cout << "Time slot " << h << " is free\n";
                h++;
            }
        }

        void cancelappment()
        {
            cout << "\nEnter your name to cancel your appointment: ";
            string n;
            cin >> n;
            p = head;

            while (p != NULL) {
                if (p->name == n) {

                    // deleting head node
                    if (p == head) {
                        head = p->next;
                        if (head != NULL) head->prev = NULL;
                    }

                    // delete last node
                    else if (p->next == NULL) {
                        temp = p->prev;
                        if (temp != NULL) temp->next = NULL;
                    }

                    // delete random position
                    else {
                        p->next->prev = p->prev;
                        p->prev->next = p->next;
                    }

                    size -= 1;
                    cout << "Appointment cancelled successfully!!\n";
                    free(p);
                    break;
                }

                p = p->next;
            }

            if (p == NULL) cout << "No name found. Try entering proper name\n";
        }

        void display() {
            int i, j, t;
            string s;
            struct node *sort;

            for (i = 0; i < size; i++) {
                sort = head;

                while (sort->next != NULL) {
                    if (sort->time < sort->next->time) {

                        t = sort->time;
                        sort->time = sort->next->time;
                        sort->next->time = t;

                        s = sort->name;
                        sort->name = sort->next->name;
                        sort->next->name = s;
                    }

                    sort = sort->next;
                }
            }

            cout << "\n";

            while(sort != NULL) {
                cout << sort->name << " has an appointment at " << sort->time << " PM\n";
                sort = sort->prev;
            }
        }
};
int main() {
    App d;
    int ch;
    char opt;

    do {
        cout << "\n******** DOCTOR APPOINTMENT *******\n";
        cout << "1. Book appointment\n2. Freeslots\n3. Cancel Appointment\n4. Display appointment list\n";
        cout << "\nEnter your choice: ";
        cin >> ch;
        switch (ch) {
            case 1:
                cout << "\nEnter slots from 12PM to 18PM and each slots of one hour\n";
                d.bookappment();
                break;
            case 2:
                d.freeslot();
                break;
            case 3:
                d.cancelappment();
                break;
            case 4:
                d.display();
                break;
        }

        cout << "\nDo you want to continue? [Y/n] ";
        cin >> opt;
    } while (opt == 'y' || opt == 'Y');

    return 0;
}


/*

---------------- OUTPUT -----------------

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 1

Enter slots from 12PM to 18PM and each slots of one hour
Enter your name: Ram
Enter slot time: 13

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 1

Enter slots from 12PM to 18PM and each slots of one hour
Enter your name: Karan
Enter slot time: 17

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 1

Enter slots from 12PM to 18PM and each slots of one hour
Enter your name: Sita
Enter slot time: 15

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 2

Time slot 12 is free
Time slot 14 is free
Time slot 16 is free
Time slot 18 is free

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 4

Ram has an appointment at 13 PM
Sita has an appointment at 15 PM
Karan has an appointment at 17 PM

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 3

Enter your name to cancel your appointment: Karan
Appointment cancelled successfully!!

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 3

Enter your name to cancel your appointment: Sita
Appointment cancelled successfully!!

Do you want to continue? [Y/n] y

******** DOCTOR APPOINTMENT *******
1. Book appointment
2. Freeslots
3. Cancel Appointment
4. Display appointment list

Enter your choice: 4

Ram has an appointment at 13 PM

Do you want to continue? [Y/n] n

*/
