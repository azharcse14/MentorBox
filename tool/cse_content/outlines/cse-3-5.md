# Course: Theory of Computation  (level id "deep-cse-3-5", lesson ids "deep-cse-3-5-01".."-25")
Builds on Discrete Mathematics (deep-cse-1-3: sets, relations, functions, proofs, induction, graphs) and Algorithms (deep-cse-3-1: big-O, reductions idea, P/NP intro) — only recapped briefly.
Parsing techniques (LL, LR, parse tables) are left for Compiler Design (cse-4-5); only mentioned here.
01 What theory of computation is: the three big questions (automata, computability, complexity), models of machines, why a model, course map, quick math recap (sets, functions, proof by induction and contradiction)
02 Alphabets, strings and languages: alphabet Sigma, strings, length, empty string epsilon, concatenation, reversal, prefixes/suffixes, Sigma*, Sigma+, languages as sets, union/concatenation/Kleene star of languages, counting strings
03 Deterministic finite automata (DFA): 5-tuple (Q, Sigma, delta, q0, F), state diagrams and tables, extended transition function, acceptance, traces, designing DFAs (even number of 0s, ends with "ab", divisible by 3), dead state
04 Regular languages and DFA design patterns: definition of regular language, complement by swapping accept states, product construction for union/intersection, counting mod k, substring checks, closure properties preview
05 Nondeterministic finite automata (NFA): nondeterminism, several or no moves, accepting if some path accepts, 5-tuple with delta into the power set, computation trees, NFA for "third symbol from the end is 1"
06 Epsilon-NFA and epsilon-closure: epsilon moves, epsilon-closure computation, removing epsilon moves, NFA union/concatenation/star using epsilon
07 Subset construction (NFA to DFA): the power-set idea, step-by-step worked conversion, only reachable subsets, the 2^n blow-up example, equivalence of DFA and NFA
08 DFA minimization: equivalent and distinguishable states, unreachable states, table-filling (Myhill-Nerode style marking) and partition refinement, worked example, uniqueness of the minimal DFA, Myhill-Nerode theorem idea
09 Regular expressions: syntax (union, concatenation, star, plus, epsilon, empty set), precedence, examples, algebraic identities, regex in real tools (grep, form validation) vs theory regex
10 Regex and finite automata equivalence: Thompson's construction (regex to epsilon-NFA), state elimination / GNFA (DFA to regex), Arden's theorem, Kleene's theorem
11 Pumping lemma for regular languages: pigeonhole idea, statement (p, xyz, |xy| <= p, |y| >= 1), the adversary game, proving a^n b^n, palindromes and a^(n^2) non-regular, common mistakes; closure properties and Myhill-Nerode as other tools
12 Context-free grammars: variables, terminals, productions, start symbol, 4-tuple, grammars for a^n b^n, palindromes, balanced parentheses, arithmetic expressions, context-free languages, BNF in programming languages
13 Derivations, parse trees and ambiguity: leftmost/rightmost derivations, parse trees, yield, ambiguous grammars (expression grammar, dangling else), removing ambiguity with precedence levels, inherent ambiguity
14 Simplifying CFGs: removing useless symbols (non-generating, unreachable), epsilon-productions, unit productions, order of steps
15 Chomsky normal form: definition, step-by-step conversion, worked example, derivations of length 2n-1, CYK algorithm with a small table
16 Greibach normal form: definition, removing left recursion, substitution, worked example, why GNF matters (one terminal per step, link to PDAs)
17 Pushdown automata: stack as memory, 7-tuple, transitions (read, pop, push), instantaneous descriptions, PDA for a^n b^n and ww^R, acceptance by final state vs empty stack, deterministic vs nondeterministic PDA
18 PDA and CFG equivalence + CFL properties: CFG to PDA construction, PDA to CFG idea, closure under union/concatenation/star, not under intersection/complement, intersection with a regular language, DCFLs and why parsers use them (details in Compiler Design)
19 Pumping lemma for context-free languages: uvxyz, conditions, proof idea from parse-tree height, proving a^n b^n c^n and ww not context-free, Ogden's lemma mention
20 Turing machines: tape, head, 7-tuple, transitions, configurations, TM for a^n b^n c^n or 0^n 1^n with trace, accept/reject/loop, recognizable vs decidable languages
21 Turing machine variants and the Church-Turing thesis: multitape, nondeterministic, multi-track, two-way infinite tape, enumerators, equivalence, encoding machines as strings, universal Turing machine, Church-Turing thesis
22 Decidability: decidable problems (A_DFA, A_CFG, E_DFA, EQ_DFA), countable vs uncountable, diagonalization, existence of non-recognizable languages
23 The halting problem and undecidability: A_TM undecidable proof by diagonalization, HALT_TM, complement not recognizable, co-recognizable, real-life consequences
24 Reductions and the Chomsky hierarchy: mapping reductions, reducing A_TM to HALT_TM, E_TM, Rice's theorem, PCP mention; Chomsky hierarchy types 0-3 with grammars and machines (TM, LBA, PDA, FA)
25 Complexity: P, NP and NP-completeness: time complexity on TMs, class P, NP via verifiers and NTMs, polynomial-time reductions, Cook-Levin, SAT, 3-SAT, CLIQUE, vertex cover, NP-hard, P vs NP, course wrap-up
