# Course: Algorithms (Design & Analysis)  (level id "deep-cse-3-1", lesson ids "deep-cse-3-1-01".."-26")
Builds on Data Structures (deep-cse-2-2): simple sorts, BST/AVL, heaps, hashing and plain BFS/DFS are assumed, only recapped.
01 What an algorithm is: definition, properties (input, output, definiteness, finiteness, effectiveness), correctness vs efficiency, RAM model, course map
02 Asymptotic notation: formal O, Omega, Theta with c and n0, little-o/omega, growth-rate ladder, proving bounds, limits trick
03 Analysing iterative algorithms: counting loops, nested/dependent loops, best/worst/average case, insertion sort analysis, loop invariants
04 Recurrences I: writing recurrences from recursive code, substitution method, iteration (unrolling), recursion-tree method
05 Recurrences II: master theorem (3 cases), worked examples, when it fails, common recurrences table
06 Divide and conquer: the paradigm, merge sort analysis, binary search as D&C, maximum subarray, counting inversions
07 Quick sort: Lomuto and Hoare partition, best/worst/average case, randomized quick sort, stability, in-place
08 More divide and conquer: fast exponentiation, Karatsuba multiplication, Strassen matrix multiply, closest pair of points (idea)
09 Sorting lower bound and linear sorts: decision trees and Omega(n log n), counting sort, radix sort, bucket sort
10 Order statistics: min/max with fewer comparisons, randomized select (quickselect), median of medians in linear worst case
11 Amortized analysis: aggregate, accounting and potential methods; stack multipop, binary counter, dynamic table
12 Greedy method I: greedy choice + optimal substructure, activity selection, exchange-argument proofs, when greedy fails (coins 1,3,4)
13 Greedy method II: fractional knapsack, Huffman coding (build + prefix codes), job sequencing with deadlines
14 Dynamic programming I: overlapping subproblems, optimal substructure, memoization vs tabulation, Fibonacci, min coin change, counting ways
15 Dynamic programming II: 0/1 knapsack table, reconstructing the choice, space optimisation, pseudo-polynomial time
16 Dynamic programming III: longest common subsequence, edit distance, tracing back the answer
17 Dynamic programming IV: matrix chain multiplication, rod cutting, longest increasing subsequence (O(n^2) and O(n log n) idea)
18 Graph search for algorithms: BFS shortest edges, DFS discovery/finish times, edge classification, topological sort, strongly connected components (Kosaraju)
19 Minimum spanning trees: cut property, Kruskal with union-find (rank, path compression), Prim with a heap, complexity
20 Single-source shortest paths: relaxation, Dijkstra, why negative edges break it, Bellman-Ford and negative cycles, DAG shortest paths
21 All-pairs shortest paths: Floyd-Warshall DP, path reconstruction, transitive closure, Johnson's idea
22 Maximum flow: flow networks, residual graph, augmenting paths, Ford-Fulkerson, Edmonds-Karp, max-flow min-cut, bipartite matching
23 Backtracking and branch and bound: state-space tree, N-queens, subset sum, graph colouring, bounding with 0/1 knapsack, TSP idea
24 String matching: naive, Rabin-Karp rolling hash, KMP prefix function, complexity comparison
25 P, NP and NP-completeness: decision problems, polynomial verification, reductions, SAT and Cook-Levin, classic NP-complete problems, NP-hard
26 Approximation and randomized algorithms + wrap-up: vertex cover 2-approx, metric TSP 2-approx idea, Las Vegas vs Monte Carlo, paradigm cheat-sheet, what next
