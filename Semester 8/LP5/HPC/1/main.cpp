/*
Credits: https://github.com/3rror/aca_pathfinding_project
TODO: Add BFS
*/

#include <array>
#include <chrono>
#include <functional>
#include <string>
#include <vector>

#include "graph.hpp"

using std::chrono::duration_cast;
using std::chrono::high_resolution_clock;
using std::chrono::milliseconds;

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

void full_bench(Graph& graph) {
    int num_test = 1;
    std::array<int, 6> num_threads{{1, 2, 4, 8, 16, 32}};

    std::vector<Graph::Node> visited(graph.size(), false);
    Graph::Node src = 0;

    // Explicitly disable dynamic teams as we are going to set a fixed number of
    // threads
    omp_set_dynamic(0);

    // TODO: find a better way to avoid code repetition

    std::cout << "Number of nodes: " << graph.size() << "\n\n";

    for (int i = 0; i < num_test; i++) {
        std::cout << "\t"
                  << "Execution " << i + 1 << std::endl;

        std::cout << "Sequential iterative DFS: "
                  << bench_traverse([&] { graph.dfs(src, visited); }) << "ms\n";

        // We cannot pass a copy of the vector, so we "reset" it every time
        std::fill(visited.begin(), visited.end(), false);

        std::cout << "Sequential recursive DFS: "
                  << bench_traverse([&]() { graph.rdfs(src, visited); }) << "ms\n";

        std::cout << "Dijkstra: " << bench_traverse([&] { graph.dijkstra(0); }) << "ms\n";

        for (const auto n : num_threads) {
            std::fill(visited.begin(), visited.end(), false);

            std::cout << "Using " << n << " threads..." << std::endl;

            // Set to use N threads
            omp_set_num_threads(n);

            // Should we change also this?
            // graph.task_threshold = n;

            std::cout << "Parallel iterative DFS: "
                      << bench_traverse([&] { graph.p_dfs(src, visited); }) << "ms\n";

            std::fill(visited.begin(), visited.end(), false);

            std::cout << "Parallel recursive DFS: "
                      << bench_traverse([&] { graph.p_rdfs(src, visited); }) << "ms\n";

            std::cout << "Parallel Dijkstra: " << bench_traverse([&] { graph.p_dijkstra(0); })
                      << "ms\n";
        }

        std::fill(visited.begin(), visited.end(), false);

        std::cout << std::endl;
    }
}

int main(int argc, const char** argv) {
    // TODO: Add a CLI? Also, we should accept more input files and process them separately
    if (argc < 2) {
        std::cout << "Input file not specified.\n";
        return 1;
    }

    std::string file_path = argv[1];

    auto graph = import_graph(file_path);

    full_bench(graph);

    return 0;
}

/*

OUTPUT:

Number of nodes: 1000

        Execution 1
Sequential iterative DFS: 64ms
Sequential recursive DFS: 39ms
Dijkstra: 72ms
Using 1 threads...
Parallel iterative DFS: 61ms
Parallel recursive DFS: 63ms
Parallel Dijkstra: 79ms
Using 2 threads...
Parallel iterative DFS: 44ms
Parallel recursive DFS: 37ms
Parallel Dijkstra: 89ms
Using 4 threads...
Parallel iterative DFS: 37ms
Parallel recursive DFS: 25ms
Parallel Dijkstra: 256ms
Using 8 threads...
Parallel iterative DFS: 36ms
Parallel recursive DFS: 15ms
Parallel Dijkstra: 257ms
Using 16 threads...
Parallel iterative DFS: 80ms
Parallel recursive DFS: 15ms
Parallel Dijkstra: 532ms
Using 32 threads...
Parallel iterative DFS: 186ms
Parallel recursive DFS: 21ms
Parallel Dijkstra: 481ms

*/
