#include <omp.h>
#include <stdlib.h>

#include <array>
#include <chrono>
#include <functional>
#include <iostream>
#include <string>
#include <vector>

using std::chrono::duration_cast;
using std::chrono::high_resolution_clock;
using std::chrono::milliseconds;
using namespace std;

void p_mergesort(int a[], int i, int j);
void s_mergesort(int a[], int i, int j);
void merge(int a[], int i1, int j1, int i2, int j2);

void p_mergesort(int a[], int i, int j) {
    int mid;
    if (i < j) {
        if ((j - i) > 1000) {
            mid = (i + j) / 2;

#pragma omp task firstprivate(a, i, mid)
            p_mergesort(a, i, mid);
#pragma omp task firstprivate(a, mid, j)
            p_mergesort(a, mid + 1, j);

#pragma omp taskwait
            merge(a, i, mid, mid + 1, j);
        }
    } else {
        s_mergesort(a, i, j);
    }
}

void parallel_mergesort(int a[], int i, int j) {
#pragma omp parallel num_threads(16)
    {
#pragma omp single
        { p_mergesort(a, i, j); }
    }
}

void s_mergesort(int a[], int i, int j) {
    int mid;
    if (i < j) {
        mid = (i + j) / 2;
        s_mergesort(a, i, mid);
        s_mergesort(a, mid + 1, j);
        merge(a, i, mid, mid + 1, j);
    }
}

void merge(int a[], int i1, int j1, int i2, int j2) {
    int temp[1000000];
    int i, j, k;
    i = i1;
    j = i2;
    k = 0;
    while (i <= j1 && j <= j2) {
        if (a[i] < a[j]) {
            temp[k++] = a[i++];
        } else {
            temp[k++] = a[j++];
        }
    }
    while (i <= j1) {
        temp[k++] = a[i++];
    }
    while (j <= j2) {
        temp[k++] = a[j++];
    }
    for (i = i1, j = 0; i <= j2; i++, j++) {
        a[i] = temp[j];
    }
}

std::string bench_traverse(std::function<void()> traverse_fn) {
    auto start = high_resolution_clock::now();
    traverse_fn();
    auto stop = high_resolution_clock::now();

    // Subtract stop and start timepoints and cast it to required unit.
    // Predefined units are nanoseconds, microseconds, milliseconds, seconds,
    // minutes, hours. Use duration_cast() function.
    auto duration = duration_cast<milliseconds>(stop - start);

    // To get the value of duration use the count() member function on the
    // duration object
    return std::to_string(duration.count());
}

int main(int argc, const char **argv) {
    if (argc < 2) {
        std::cout << "Specify array length.\n";
        return 1;
    }
    int *a, n, i;

    n = stoi(argv[1]);
    a = new int[n];

    for (int i = 0; i < n; i++) {
        a[i] = rand() % n;
    }

    int *b = new int[n];
    copy(a, a + n, b);
    cout << "Generated random array of length " << n << "\n\n";

    std::cout << "Sequential Merge sort: " << bench_traverse([&] { s_mergesort(a, 0, n - 1); })
              << "ms\n";

    omp_set_num_threads(16);
    std::cout << "Parallel (16) Merge sort: "
              << bench_traverse([&] { parallel_mergesort(b, 0, n - 1); }) << "ms\n";

    // cout << "\nSorted array is =>";
    // for (i = 0; i < n; i++) {
    //     cout << "\n" << a[i];
    // }
    return 0;
}

/*

OUTPUT:

Generated random array of length 1000000

Sequential Merge sort: 532ms
Parallel (16) Merge sort: 62ms

*/
