# Course: Numerical Methods  (level id "deep-cse-3-4", lesson ids "deep-cse-3-4-01".."-25")
Builds on Calculus (deep-cse-1-4: derivatives, integrals, Taylor series, ODEs) and Linear Algebra (deep-cse-2-5: matrices,
elimination by hand). Those are only recapped; here the focus is how a computer gets approximate answers, step by step, and how wrong they are.
01 Why numerical methods exist: problems with no formula (x = cos x, integral of e^(-x^2)), exact vs approximate, iterate-and-improve idea, history (Babylonian sqrt, log tables), course map
02 Errors I: true value vs approximation, absolute/relative/percentage error, significant digits, accurate vs precise, sources of error (data, model, round-off, truncation, blunders)
03 Errors II: Taylor series as the engine of methods, truncation error and the remainder term, big-O of step size h, error propagation through + - x /, loss of significance (subtracting near-equal numbers) and rewriting formulas
04 Floating point: binary fractions, IEEE 754 single/double layout (sign, exponent, mantissa), machine epsilon, why 0.1+0.2 != 0.3, overflow/underflow, never compare floats with ==
05 Root finding basics + bisection: what a root is, sign change and intermediate value theorem, bracketing, bisection algorithm worked, number of iterations formula, stopping criteria
06 False position (regula falsi): secant line through bracket ends, formula, worked example, comparison with bisection, one-sided stagnation, Illinois fix idea
07 Newton-Raphson: tangent line idea, derivation from Taylor, worked sqrt and cube examples, quadratic convergence (digits double), failure cases (f'=0, cycling, bad start)
08 Secant method: replacing the derivative with a difference, formula, worked example, order about 1.618, secant vs false position vs Newton
09 Fixed-point iteration: rewriting f(x)=0 as x=g(x), cobweb picture, convergence condition |g'(x)|<1, good vs bad rearrangements, rate of convergence and order comparison table
10 Roots of polynomials and systems: Horner's method, deflation, multiple roots slow Newton down, Newton for two equations (Jacobian) idea
11 Linear systems + Gauss elimination: Ax=b, why not Cramer/inverse, forward elimination, back substitution, worked 3x3, operation count about (2/3)n^3
12 Pivoting and ill-conditioning: zero/tiny pivot problem, partial pivoting worked, scaling, condition number idea, residual vs error
13 Gauss-Jordan and matrix inverse: reduced form, inverse by [A|I], when inverse is actually needed, cost comparison
14 LU decomposition: A=LU, Doolittle worked 3x3, solve Ly=b then Ux=y, reuse for many b, Crout and Cholesky mention, determinant from LU
15 Iterative methods: Gauss-Jacobi and Gauss-Seidel, worked iterations, diagonal dominance for convergence, Seidel usually faster, when iterative beats direct (large sparse)
16 Finite differences: forward, backward, central difference operators, difference table, error spotting in tables, shift operator E idea
17 Newton forward and backward interpolation: equal spacing, p = (x-x0)/h, worked examples, which to use where
18 Unequal spacing: Lagrange interpolation and Newton divided differences, worked examples, uniqueness of the interpolating polynomial, inverse interpolation idea
19 Interpolation error and splines: error term, Runge phenomenon, piecewise linear, cubic spline idea (smooth joins), natural spline
20 Curve fitting by least squares: interpolation vs fitting, residuals, normal equations for a straight line worked, parabola, exponential fit via logs, r^2 idea
21 Numerical differentiation: derivatives from difference formulas, forward/central errors O(h) vs O(h^2), second derivative, step size trade-off (truncation vs round-off), Richardson idea
22 Numerical integration: trapezoidal rule and Simpson's 1/3 rule, composite forms, worked integral, error orders, Simpson's 3/8 mention
23 More integration: Romberg idea, Gaussian quadrature 2-point worked, when to use what
24 ODEs I: initial value problems, Euler's method worked, local vs global error, modified Euler (Heun) worked
25 ODEs II + wrap-up: Runge-Kutta 4th order worked, comparison table, stability and step size, stiff equations idea, convergence vs stability vs accuracy, course recap and what next
