import random
import sys
from contextlib import contextmanager
from multiprocessing import Manager, Pool
from timeit import default_timer as time


class Timer:
    """
    Record timing information.
    """

    def __init__(self, *steps):
        self._time_per_step = dict.fromkeys(steps)

    def __getitem__(self, item):
        return self.time_per_step[item]

    @property
    def time_per_step(self):
        return {
            step: elapsed_time
            for step, elapsed_time in self._time_per_step.items()
            if elapsed_time is not None and elapsed_time > 0
        }

    def start_for(self, step):
        self._time_per_step[step] = -time()

    def stop_for(self, step):
        self._time_per_step[step] += time()


def merge_sort_multiple(results, array):
    """Async parallel merge sort."""
    results.append(merge_sort(array))


def merge_multiple(results, array_part_left, array_part_right):
    """Merge two sorted lists in parallel."""
    results.append(merge(array_part_left, array_part_right))


def merge_sort(array):
    """Perform merge sort."""
    array_length = len(array)

    if array_length <= 1:
        return array

    middle_index = array_length // 2
    left = array[:middle_index]
    right = array[middle_index:]
    left = merge_sort(left)
    right = merge_sort(right)
    return merge(left, right)


def merge(left, right):
    """Merge two sorted lists."""
    sorted_list = [0] * (len(left) + len(right))
    i = j = k = 0

    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            sorted_list[k] = left[i]
            i += 1
        else:
            sorted_list[k] = right[j]
            j += 1
        k += 1

    while i < len(left):
        sorted_list[k] = left[i]
        i += 1
        k += 1

    while j < len(right):
        sorted_list[k] = right[j]
        j += 1
        k += 1

    return sorted_list


@contextmanager
def process_pool(size):
    """Create a process pool and block until all processes have completed."""
    pool = Pool(size)
    yield pool
    pool.close()
    pool.join()


def parallel_merge_sort(array, ps_count):
    """Perform parallel merge sort."""
    timer = Timer("sort", "merge", "total")
    timer.start_for("total")
    timer.start_for("sort")

    # Divide the list in chunks
    step = int(length / ps_count)

    # Instantiate a multiprocessing.Manager object to store the output of each process.
    manager = Manager()
    results = manager.list()

    with process_pool(size=ps_count) as pool:
        for i in range(ps_count):
            # We create a new Process object and assign the
            # merge_sort_multiple function to it,
            # using as input a sublist
            if i < ps_count - 1:
                chunk = array[i * step : (i + 1) * step]
            else:
                # Get the remaining elements in the list
                chunk = array[i * step :]
            pool.apply_async(merge_sort_multiple, (results, chunk))

    timer.stop_for("sort")

    print("Performing final merge.")

    timer.start_for("merge")

    # For a core count greater than 2, we can use multiprocessing
    # again to merge sub-lists in parallel.
    while len(results) > 1:
        with process_pool(size=ps_count) as pool:
            pool.apply_async(merge_multiple, (results, results.pop(0), results.pop(0)))

    timer.stop_for("merge")
    timer.stop_for("total")

    final_sorted_list = results[0]

    return timer, final_sorted_list


def get_command_line_parameters():
    """Get the process count from command line parameters."""
    if len(sys.argv) > 1:
        # Check if the desired number of concurrent processes
        # has been given as a command-line parameter.
        total_processes = int(sys.argv[1])
        if total_processes > 1:
            # Restrict process count to even numbers
            if total_processes % 2 != 0:
                print("Process count should be an even number.")
                sys.exit(1)
        print(f"Using {total_processes} cores")
    else:
        total_processes = 1

    return {"process_count": total_processes}


if __name__ == "__main__":
    parameters = get_command_line_parameters()

    process_count = parameters["process_count"]

    main_timer = Timer("single_core", "list_generation")
    main_timer.start_for("list_generation")

    # Randomize the length of our list
    length = random.randint(3 * 10**6, 4 * 10**6)

    # Create an unsorted list with random numbers
    randomized_array = [random.randint(0, i * 100) for i in range(length)]
    main_timer.stop_for("list_generation")

    print(f"List length: {length}")
    print(f"Random list generated in {main_timer['list_generation']:.6f}")

    # Start timing the single-core procedure
    main_timer.start_for("single_core")
    single = merge_sort(randomized_array)
    main_timer.stop_for("single_core")

    # Create a copy first due to mutation
    randomized_array_sorted = randomized_array[:]
    randomized_array_sorted.sort()

    # Comparison with Python list sort method
    # serves also as validation of our implementation.
    print("Verification of sorting algorithm:", randomized_array_sorted == single)
    print(f"Single Core elapsed time: {main_timer['single_core']:.6f} sec")

    print("Starting parallel sort.")

    parallel_timer, parallel_sorted_list = parallel_merge_sort(
        randomized_array, process_count
    )

    print(f"Final merge duration: {parallel_timer['merge']:.6f} sec")
    print("Sorted arrays equal:", parallel_sorted_list == randomized_array_sorted)
    print(f"{process_count}-Core elapsed time: {parallel_timer['total']:.6f} sec")

"""
OUTPUT:

Using 16 cores
List length: 3252321
Random list generated in 1.787607
Verification of sorting algorithm: True
Single Core elapsed time: 14.204555 sec
Starting parallel sort.
Performing final merge.
Final merge duration: 4.764258 sec
Sorted arrays equal: True
16-Core elapsed time: 6.984671 sec
"""
