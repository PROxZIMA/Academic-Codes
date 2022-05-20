#include <iostream>
using namespace std;

class Heap{
public:
    void maxHeapify (int [], int, int);
    void buildMaxHeap (int [], int);
    void heapsort (int [], int);
    void accept ();
    void display (int [],int);
};

void Heap::maxHeapify (int marks[], int i, int n) {       //reheapdown - deleting element from top location
    int l, r, largest;
    l = 2 * i;
    r = (2 * i + 1);

    largest = ((l <= n) && marks[l] > marks[i]) ? l : i;

    if ((r <= n) && (marks[r] > marks[largest]))
        largest=r;

    if (largest != i) {
        swap(marks[largest], marks[i]);
        maxHeapify (marks, largest,n);
    }
}

void Heap::buildMaxHeap (int marks[], int n) {
    for (int k = n / 2; k >= 1; k--)
        maxHeapify (marks, k, n);
}

void Heap::heapsort (int marks[], int n) {
    buildMaxHeap (marks,n);
    for (int i = n; i >= 2; i--) {
        swap (marks[i], marks[1]);
        maxHeapify (marks, 1, i - 1);
    }
}

void Heap::accept (){
    int n;
    cout << "Enter the number of students: ";
    cin >> n;
    int marks[n];
    cout << "\nEnter the marks of the students: ";
    for (int i = 1; i <= n; i++)
        cin >> marks[i];

    heapsort (marks, n);
    display (marks, n);
}

void Heap::display (int marks[],int n) {
    cout << "\n:::::::SORTED MARKS::::::\n\n";

    for (int i = 1; i <= n; i++)
        cout << marks[i] << endl;

    cout << "\nMinimum marks obtained: " << marks[1];
    cout << "\nMaximum marks obtained: " << marks[n];
}

int main () {
       Heap h;
    h.accept ();
    return 0;
}

/*
Enter the number of students: 8

Enter the marks of the students: 12 74 84 19 52 41 22 93

:::::::SORTED MARKS::::::

12
19
22
41
52
74
84
93

Minimum marks obtained: 12
Maximum marks obtained: 93
*/