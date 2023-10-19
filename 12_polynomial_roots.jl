### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ d1279f74-53c0-11ec-2f21-fdfa70caa1fa
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ d127a49a-53c0-11ec-1e93-b3be91d1fc3a
begin
	using CalculusWithJulia.WeaveSupport
	using Roots
	import LinearAlgebra: norm
	__DIR__, __FILE__ = :precalc, :polynomial_roots
	nothing
end

# ╔═╡ d12add80-53c0-11ec-1577-7f0cf9354e38
using PlutoUI

# ╔═╡ d12add56-53c0-11ec-12a8-a374c7150074
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ d1277c9a-53c0-11ec-2a1a-7bf1906a368e
md"""# Roots of a polynomial
"""

# ╔═╡ d127906a-53c0-11ec-3dfd-ed2446aff329
md"""In this section we use the following add on packages:
"""

# ╔═╡ d127a570-53c0-11ec-198f-87b252bb3055
md"""---
"""

# ╔═╡ d127a618-53c0-11ec-0429-a9abf6f85a20
md"""The [roots](http://en.wikipedia.org/wiki/Properties_of_polynomial_roots) of a polynomial are the values of $x$ that when substituted into the expression yield $0$. For example, the polynomial $x^2 - x$ has two roots, $0$ and $1$. A simple graph verifies this:
"""

# ╔═╡ d127afe6-53c0-11ec-193f-b3bf8ceb13c5
let
	f(x) = x^2 - x
	plot(f, -2, 2)
	plot!(zero, -2, 2)
end

# ╔═╡ d127b022-53c0-11ec-0810-05167379a84e
md"""The graph crosses the $x$-axis at both $0$ and $1$.
"""

# ╔═╡ d127b036-53c0-11ec-03c4-2729b7cc629c
md"""What is known about polynomial roots? Some simple questions might be:
"""

# ╔═╡ d127b4f0-53c0-11ec-106e-dbdefedfe89c
md"""  * Will we always have a root?
  * How many roots can there be?
  * How large can the roots be?
"""

# ╔═╡ d127b50e-53c0-11ec-3249-ff190c667563
md"""We look at such questions here.
"""

# ╔═╡ d127b522-53c0-11ec-2236-c518608989ed
md"""We begin with a comment that ties together two concepts related to polynomials. It allows us to speak of roots or factors interchangeably:
"""

# ╔═╡ d127b662-53c0-11ec-2838-418e3152fb81
md"""> The [factor theorem](http://en.wikipedia.org/wiki/Factor_theorem) relates the *roots* of a polynomial with its *factors*: $r$ is a root of $p$ if *and* only if $(x-r)$ is a factor of the polynomial $p$.

"""

# ╔═╡ d127b67e-53c0-11ec-0cfa-b9337c930c3b
md"""Clearly, if $p$ is factored as $a(x-r_1) \cdot (x-r_2) \cdots (x - r_k)$ then each $r_i$ is a root, as a product involving at least one 0 term will be 0. The other implication is a consequence of polynomial division.
"""

# ╔═╡ d127b6da-53c0-11ec-24a3-055983b9304c
md"""### Polynomial Division
"""

# ╔═╡ d127b722-53c0-11ec-2204-f5aa6d8a6682
md"""[Euclidean division](http://en.wikipedia.org/wiki/Euclidean_division) division of integers $a, b$ uniquely writes $a = b\cdot q + r$ where $0 \leq r < |b|$. The quotient is $q$ and the remainder $r$. There is an analogy for polynomial division, where for two polynomial functions $f(x)$ and $g(x)$ it is possible to write
"""

# ╔═╡ d127c4ae-53c0-11ec-1ec8-b3a815668d65
md"""```math
f(x) = g(x) \cdot q(x) + r(x)
```
"""

# ╔═╡ d127c53a-53c0-11ec-2d2f-4b0096340703
md"""where the degree of $r$ is less than the degree of $g(x)$. The [long-division algorithm](http://en.wikipedia.org/wiki/Long_division) can be used to find both $q(x)$ and $r(x)$.
"""

# ╔═╡ d127c560-53c0-11ec-27db-fb531d2ac5b2
md"""For the special case of a linear factor where $g(x) = x - c$,  the remainder must be of degree $0$ (a constant) or the $0$ polynomial. The above simplifies to
"""

# ╔═╡ d127c580-53c0-11ec-1242-cbf752e1e320
md"""```math
f(x) = (x-c) \cdot q(x) + r
```
"""

# ╔═╡ d127c59e-53c0-11ec-0728-bd7384e976f1
md"""From this, we see that $f(c) = r$. Hence, when $c$ is a root of $f(x)$, then it must be that $r=0$ and so, $(x-c)$ is a factor.
"""

# ╔═╡ d127c5bc-53c0-11ec-2615-b1a34332cdf1
md"""---
"""

# ╔═╡ d127c5ee-53c0-11ec-3b62-396f7b27cc60
md"""The division algorithm for the case of linear term, $(x-c)$, can be carried out by the [synthetic division](http://en.wikipedia.org/wiki/Synthetic_division) algorithm. This algorithm produces  $q(x)$ and $r$, a.k.a $f(c)$.  The Wikipedia page describes the algorithm well.
"""

# ╔═╡ d127c60c-53c0-11ec-3424-3b6575270bcc
md"""The following is an example where $f(x) = x^4 + 2x^2 + 5$ and $g(x) = x-2$:
"""

# ╔═╡ d127c652-53c0-11ec-0516-9df7cb832e27
md"""```
2 | 1 0 2  0  5
  |   2 4 12 24
  -------------
    1 2 6 12 29
```"""

# ╔═╡ d127c6a2-53c0-11ec-3257-cf47614be398
md"""The polynomial $f(x)$ is coded in terms of its coefficients ($a_n$, $a_{n-1}$, $\dots$, $a_1$, $a_0$) and is written on the top row. The algorithm then proceeds from left to right. The number just produced on the bottom row is multiplied by $c$ and placed under the coefficient of $f(x)$. Then values are then added to produce the next number. The sequence produced above is `1 2 6 12 29`. The last value (`29`) is $r=f(c)$, the others encode the coefficients of `q(x)`, which for this problem is $q(x)=x^3 + 2x + 6 + 12$.  That is, we have written:
"""

# ╔═╡ d127c6b6-53c0-11ec-06c4-6f1396e30beb
md"""```math
x^4 + 2x^2 + 5 = (x-2) \cdot (x^3 + 2x + 6 + 12) + 29.
```
"""

# ╔═╡ d127c6d4-53c0-11ec-2c9b-8fc32319c0c6
md"""As $r$ is not $0$, we can say that $2$ is not a root of $f(x)$.
"""

# ╔═╡ d127c6f2-53c0-11ec-0f94-a138858baa07
md"""If we were to track down the computation that produced $f(2) = 29$, we would have
"""

# ╔═╡ d127c6fa-53c0-11ec-11c4-19bf8ceb87d7
md"""```math
5 + 2 \cdot (0 + 2 \cdot (2 + 2 \cdot (0 + (2 \cdot 1))))
```
"""

# ╔═╡ d127c71a-53c0-11ec-07db-239f556dbbad
md"""In terms of $c$ and the coefficients $x_0, x_1, x_2, x_3$, and $x_4$ this is
"""

# ╔═╡ d127c72e-53c0-11ec-3d7f-bde4c4d66f91
md"""```math
x_0 + c\cdot(x_1 + c\cdot(x_2 + c\cdot(x_3 + c\cdot x_4))),
```
"""

# ╔═╡ d127c74c-53c0-11ec-31bd-17dffba654fc
md"""The above pattern provides a means to compute $f(c)$ and could easily be generalized for higher degree polynomials.  This generalization is called [Horner's](http://en.wikipedia.org/wiki/Horner%27s_method) method. Horner's method has the advantage of also being faster and more accurate when floating point issues are accounted for.
"""

# ╔═╡ d127c76c-53c0-11ec-0ae5-7b837a8dbdaf
md"""A simple implementation of Horner's algorithm would look like this, if indexing were `0`-based:
"""

# ╔═╡ d127f212-53c0-11ec-0970-fde17023bdee
function horner(p, x)
    n = degree(p)
    Σ = p[n]
    for i in (n-1):-1:0
       Σ = Σ * x + p[i]
    end
    return(Σ)
end

# ╔═╡ d127f280-53c0-11ec-0731-e570d9108149
md"""`Julia` has a built-in method, `evalpoly`, to compute polynomial evaluations this way. To illustrate:
"""

# ╔═╡ d127f5fa-53c0-11ec-0b0f-8f6a9eb3c287
@syms x::real       # assumes x is real

# ╔═╡ d127fec4-53c0-11ec-32a7-89e6ac7659d0
let
	p = (1, 2, 3, 4, 5) # 1 + 2x + 3x^2 + 4x^3 + 5x^4
	evalpoly(x, p)
end

# ╔═╡ d127ff1e-53c0-11ec-1def-db95a143fb8e
md"""Recording the different values of `Σ` would recover the polynomial `q`.
"""

# ╔═╡ d127ff32-53c0-11ec-0bdb-1d6509fcf7f2
md"""---
"""

# ╔═╡ d127ff50-53c0-11ec-2139-97e1bad1caa9
md"""The `SymPy` package can carry out polynomial long division.
"""

# ╔═╡ d127ff5a-53c0-11ec-0515-47b4d43cb3ca
md"""This naive attempt to divide won't "just work" though:
"""

# ╔═╡ d1280914-53c0-11ec-0c30-93b669240fe4
(x^4 + 2x^2 + 5) / (x-2)

# ╔═╡ d1280950-53c0-11ec-3ea9-61805a524dd9
md"""`SymPy` is fairly conservative in how it simplifies answers, and, as written, there is no compelling reason to change the expressions, though in our example we want it done.
"""

# ╔═╡ d128096e-53c0-11ec-27cf-4b2d871378ee
md"""For this task, `divrem` is available:
"""

# ╔═╡ d128138c-53c0-11ec-1f5b-23fff3e4c7d0
quotient, remainder = divrem(x^4 + 2x^2 + 5, x - 2)

# ╔═╡ d12813dc-53c0-11ec-049c-074ec6c3c14f
md"""The answer is a tuple containing the quotient and remainder. The quotient itself could be found with `div` or `÷` and the remainder with `rem`.
"""

# ╔═╡ d1281f6c-53c0-11ec-1dc9-b5dade295ee0
note("""For those who have worked with SymPy within Python, `divrem` is the `div` method renamed, as `Julia`'s `div` method has the generic meaning of returning the quotient.""")

# ╔═╡ d1281fd0-53c0-11ec-04f3-e7076f6e8688
md"""As well, the `apart` function could  be used for this task. This function computes the [partial fraction](http://en.wikipedia.org/wiki/Partial_fraction_decomposition)  decomposition of a ratio of polynomial functions.
"""

# ╔═╡ d1282d7c-53c0-11ec-3da8-4f1d8346269a
apart((x^4 + 2x^2 + 5) / (x-2))

# ╔═╡ d1282e08-53c0-11ec-32d7-adeb95f248ae
md"""The function `together` would combine such terms, as an "inverse" to `apart`. This isn't so much of interest at the moment, but will be when techniques of integration are looked at.
"""

# ╔═╡ d1282e4e-53c0-11ec-095d-8d235c5ea444
md"""### The rational root test
"""

# ╔═╡ d1282ef8-53c0-11ec-16bd-215db19fed01
md"""Factoring polynomials to find roots is a task that most all readers here will recognize, and, perhaps, remember not so fondly. One helpful trick to find possible roots *by hand* is the [rational root theorem](http://en.wikipedia.org/wiki/Rational_root_theorem): if a polynomial has integer coefficients with $a_0 \neq 0$, than any rational root, $p/q$, must have $p$ dividing the constant $a_0$ and $q$ dividing the leading term $a_n$.
"""

# ╔═╡ d1282f34-53c0-11ec-2472-a58c49c7fd0c
md"""To glimpse why, suppose we have a polynomial with a rational root and integer coefficients. With this in mind, a polynomial with identical roots may be written as $(qx -p)(a_{n-1}x^{n-1}+\cdots a_1 x + a_0)$, where each coefficient is an integer. Multiplying through, we get that the polynomial is $qa_{n-1}x^n + \cdots + pa_0$. So $q$ is a factor of the leading coefficient and $p$ is a factor of the constant.
"""

# ╔═╡ d1282f48-53c0-11ec-35d5-fdf403bc3e6e
md"""An immediate consequence is that if the polynomial with integer coefficients is monic, then any rational root must be an integer.
"""

# ╔═╡ d1282f70-53c0-11ec-3ddf-472e9a78839c
md"""This gives a finite - though possibly large - set of values that can be checked to exhaust the possibility of a rational root. By hand this process can be tedious, though may be speeded up using synthetic division. This task is one of the mainstays of high school algebra where problems are chosen judiciously to avoid too many possibilities.
"""

# ╔═╡ d1282f8e-53c0-11ec-2054-73bb493c195f
md"""However, one of the great triumphs of computer algebra is the ability to factor polynomials with integer (or rational) coefficients over the rational numbers. This is typically done by first factoring over modular numbers (akin to those on a clock face) and has nothing to do with the rational root test.
"""

# ╔═╡ d1282fb6-53c0-11ec-0461-7f3e23e68f42
md"""`SymPy` can quickly find such a factorization, even for quite large polynomials with rational or integer coefficients.
"""

# ╔═╡ d1283026-53c0-11ec-242b-b33fdff78fa6
md"""For example, factoring $p = 2x^4 + x^3 -19x^2 -9x +9$. This has *possible* rational roots of plus or minus $1$ or $2$ divided by $1$, $3$, or $9$ - $12$ possible answers for this modest question. By hand that can be a bit of work, but `factor` does it without fuss:
"""

# ╔═╡ d128415e-53c0-11ec-157b-3da1f743e429
let
	p = 2x^4 + x^3 - 19x^2 - 9x + 9
	factor(p)
end

# ╔═╡ d12841c2-53c0-11ec-005b-eb7fe0d5a84f
md"""### Fundamental theorem of algebra
"""

# ╔═╡ d128426a-53c0-11ec-25ca-4b11d1610bfa
md"""There is a basic fact about the roots of a polynomial of degree $n$. Before formally stating it, we consider the earlier observation that a polynomial of degree $n$ for large values of $x$ has a graph that looks like the leading term. However, except at $0$, monomials do not cross the $x$ axis, the roots must be the result of the interaction of lower order terms. Intuitively, since each term can contribute only one basic shape up or down, there can not be arbitrarily many roots. In fact, a consequence of the [Fundamental Theorem of Algebra](http://en.wikipedia.org/wiki/Fundamental_theorem_of_algebra) (Gauss) is:
"""

# ╔═╡ d128438e-53c0-11ec-06fd-9330cc844832
md"""> A polynomial of degree $n$ with real or complex coefficients has at most $n$ real roots.

"""

# ╔═╡ d12843ac-53c0-11ec-1374-a11020bee37d
md"""This statement can be proved with the factor theorem and the division algorithm.
"""

# ╔═╡ d1285414-53c0-11ec-10b3-03c88568ef53
md"""In fact the fundamental theorem states that there are exactly $n$ roots, though, in general, one must consider multiple roots and possible complex roots to get all $n$. (Consider $x^2$ to see why multiplicity must be accounted for and $x^2 + 1$ to see why complex values may be necessary.)
"""

# ╔═╡ d12873de-53c0-11ec-175d-d9dcb020dd71
alert(raw"""
The special case of the ``0`` polynomial having no degree defined
eliminates needing to exclude it, as it has infinitely many roots. Otherwise, the language would be qualified to have ``n \geq 0``.
""")

# ╔═╡ d1287520-53c0-11ec-12e1-f19dee583841
md"""## Finding roots of a polynomial
"""

# ╔═╡ d12875ac-53c0-11ec-2e96-ef7bb552a6f5
md"""Knowing that a certain number of roots exist and actually finding those roots are different matters. For the simplest cases (the linear case) with $a_0 + a_1x$, we know by solving algebraically that the root is $-a_0/a_1$. (We assume $a_1\neq 0$.) Of course, when $a_1 \neq 0$, the graph of the polynomial will be a line with some non-zero slope, so will cross the $x$-axis as the line and this axis are not parallel.
"""

# ╔═╡ d12875fc-53c0-11ec-0e79-81c930346527
md"""For the quadratic case, there is the famous [quadratic formula](http://en.wikipedia.org/wiki/Quadratic_formula) (known since 2000 BC) to find the two roots guaranteed by the formula:
"""

# ╔═╡ d1287638-53c0-11ec-2642-29f1db7493d6
md"""```math
\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}.
```
"""

# ╔═╡ d1287688-53c0-11ec-3bc9-97d2d01676fb
md"""The discriminant is defined as $b^2 - 4ac$. When this is negative, the square root requires the concept of complex numbers to be defined, and the formula shows the two complex roots are conjugates. When the discriminant is $0$, then the root has multiplicity two, e.g., the polynomial will factor as $a_2(x-r)^2$. Finally, when the discriminant is positive, there will be two distinct, real roots. This figure shows the 3 cases, that are illustrated by $x^2 -1$, $x^2$ and $x^2 + 1$:
"""

# ╔═╡ d1288530-53c0-11ec-129b-fd5fac5fc00c
begin
	plot(x^2 - 1,  -2, 2, legend=false)  # two roots
	plot!(x^2, -2, 2)                           # one (double) root
	plot!(x^2 + 1, -2, 2)                       # no real root
	plot!(zero, -2, 2)
end

# ╔═╡ d12885b0-53c0-11ec-2d9a-8935bd761d56
md"""There are similar formulas for the [cubic](http://en.wikipedia.org/wiki/Cubic_function#General_formula_for_roots) and [quartic](http://en.wikipedia.org/wiki/Quartic_function#General_formula_for_roots) cases. (The [cubic formula](http://arxiv.org/pdf/math/0005026v1.pdf) was known to Cardano in 1545, though through Tartagli, and the quartic was solved by Ferrari, Cardano's roommate.)
"""

# ╔═╡ d12885e2-53c0-11ec-387a-3d51aa311380
md"""In general, there is no such formula using radicals for 5th degree polynomials or higher, a proof first given by Ruffini in 1803 with improvement by Abel in 1824. Even though the fundamental theorem shows that any polynomial can be factored into linear and quadratic terms, there is no general method as to how. (It is the case that *some* such polynomials may be solvable by radicals, just not all of them.)
"""

# ╔═╡ d128860a-53c0-11ec-0cf9-951ec1249f48
md"""The `factor` function of `SymPy` only finds factors of polynomials with integer or rational coefficients corresponding to rational roots. There are alternatives.
"""

# ╔═╡ d1288628-53c0-11ec-24b1-a51ff9842959
md"""Finding roots with `SymPy` can also be done through its `solve` function, a function which also has a more general usage, as it can solve simple expressions or more than one expression. Here we illustrate that `solve` can easily handle quadratic expressions:
"""

# ╔═╡ d1288b6e-53c0-11ec-184e-bbb8bbd92584
solve(x^2 + 2x - 3)

# ╔═╡ d1288bc8-53c0-11ec-363f-1d8828330a69
md"""The answer is a vector of values that when substituted in for the free variable `x` produce 0. The call to `solve` does not have an equals sign. To solve a more complicated expression of the type $f(x) = g(x)$, one can solve $f(x) - g(x) = 0$, use the `Eq` function, or use `f ~ g`.
"""

# ╔═╡ d1288be6-53c0-11ec-3def-a993f10fb819
md"""When the expression to solve has more than one free variable, the variable to solve for should be explicitly stated with a second argument. For example, here we show that `solve` is aware of the quadratic formula:
"""

# ╔═╡ d128a21e-53c0-11ec-2a03-99a1371fb1f7
begin
	@syms a b::real c::positive
	solve(a*x^2 + b*x + c, x)
end

# ╔═╡ d128a282-53c0-11ec-17d7-8103dbc97b7f
md"""The `solve` function will respect assumptions made when a variable is defined through `symbols` or `@syms`:
"""

# ╔═╡ d128a752-53c0-11ec-2232-c39e3fd10a22
solve(a^2 + 1)     # works, as a can be complex

# ╔═╡ d128acfa-53c0-11ec-0046-1bdb038c723b
solve(b^2 + 1)     # fails, as b is assumed real

# ╔═╡ d128b2c4-53c0-11ec-3694-df91626f42c5
solve(c + 1)       # fails, as c is assumed positive

# ╔═╡ d128b328-53c0-11ec-2cb3-6b9b6efe75ce
md"""Previously, it was mentioned that `factor` only factors polynomials with integer coefficients over rational roots. However, `solve` can be used to factor. Here is an example:
"""

# ╔═╡ d128b94a-53c0-11ec-3c31-d17f5db1c9f6
factor(x^2 - 2)

# ╔═╡ d128b99a-53c0-11ec-1849-f9c8be315674
md"""Nothing is found, as the roots are $\pm \sqrt{2}$, irrational numbers.
"""

# ╔═╡ d128c2be-53c0-11ec-14d0-89d550c9c5c2
begin
	rts = solve(x^2 - 2)
	prod(x-r for r in rts)
end

# ╔═╡ d128c2e8-53c0-11ec-1a0b-cf92ba9334f4
md"""Solving cubics and quartics can be done exactly using radicals. For example, here we see the solutions to a quartic equation can be quite involved, yet still explicit. (We use `y` so that complex-valued solutions, if any, will be found.)
"""

# ╔═╡ d128c74e-53c0-11ec-311a-b9307e9f964c
begin
	@syms y # possibly complex
	solve(y^4 - 2y - 1)
end

# ╔═╡ d128c764-53c0-11ec-2128-fbd02cc9ff9d
md"""Third- and fourth-degree polynomials can be solved in general, with increasingly more complicated answers. The following finds one of the answers for a general third-degre polynomial:
"""

# ╔═╡ d128ce12-53c0-11ec-1dc4-2b7c69139225
let
	@syms a[0:3]
	p = sum(a*x^(i-1) for (i,a) in enumerate(a))
	rts = solve(p, x)
	rts[1]   # there are three roots
end

# ╔═╡ d128ce44-53c0-11ec-0410-71c1c6f4ace6
md"""Some fifth degree polynomials are solvable in terms of radicals, however, `solve` will not seem to have luck with this particular fifth degree polynomial:
"""

# ╔═╡ d128d222-53c0-11ec-3607-3fa54386e16b
solve(x^5 - x + 1)

# ╔═╡ d128d268-53c0-11ec-151c-17bccd5585af
md"""(Though there is no formula involving only radicals like the quadratic equation, there is a formula for the roots in terms of a function called the [Bring radical](http://en.wikipedia.org/wiki/Bring_radical).)
"""

# ╔═╡ d128d2a4-53c0-11ec-0f24-2d0d0fa7bd60
md"""### The `roots` function
"""

# ╔═╡ d128d2b8-53c0-11ec-0a38-67636c1c3979
md"""Related to `solve` is the specialized `roots` function for identifying roots, Unlike solve, it will identify multiplicities.
"""

# ╔═╡ d128d2cc-53c0-11ec-0f0b-673d93f07fde
md"""For a polynomial with only one ideterminate the usage is straightfoward:
"""

# ╔═╡ d128d8ee-53c0-11ec-0c96-61754b85a9d8
roots((x-1)^2 * (x-2)^2)  # solve doesn't identify multiplicities

# ╔═╡ d128d916-53c0-11ec-2df6-01ab68a8e4ab
md"""For a polynomial with symbolic coefficients, the different between the symbol and the coefficients must be identified. `SymPy` has a `Poly` type to do so. The following call illustrates:
"""

# ╔═╡ d128dd9e-53c0-11ec-0bb7-5533fb53d716
let
	@syms a b c
	p = a*x^2 + b*x + c
	q = sympy.Poly(p, x)  # identify `x` as indeterminate; alternatively p.as_poly(x)
	roots(q)
end

# ╔═╡ d128ddee-53c0-11ec-19de-77d0fa8e4385
md"""The sympy `Poly` function must be found within the underlying `sympy` module, a Python object, hence is qualified as `sympy.Poly`. This is common when using `SymPy`, as only a small handful of the many functions available are turned into `Julia` functions, the rest are used as would be done in Python. (This is similar, but different than qualifying by a `Julia` module when there are two conflicting names. An example will be the use of the name `roots` in both `SymPy` and `Polynomials` to refer to a function that finds the roots of a polynomial. If both functions were loaded, then the last line in the above example would need to be `SymPy.roots(q)` (note the capitalization.)
"""

# ╔═╡ d128de02-53c0-11ec-11b2-5b915c38326a
md"""### Numerically finding roots
"""

# ╔═╡ d128de20-53c0-11ec-2889-65a889993655
md"""The `solve` function can be used to get numeric approximations to the roots. It is as easy as calling `N` on the solutions:
"""

# ╔═╡ d128e40e-53c0-11ec-394c-8debc7491cb5
let
	rts = solve(x^5 - x + 1)
	N.(rts)     # note the `.(` to broadcast over all values in rts
end

# ╔═╡ d128e424-53c0-11ec-1422-435c8b717c20
md"""Here we see another example:
"""

# ╔═╡ d128f234-53c0-11ec-3390-b3d2ed22539f
begin
	ex = x^7 -3x^6 +  2x^5 -1x^3 +  2x^2 + 1x^1  - 2
	solve(ex)
end

# ╔═╡ d128f252-53c0-11ec-0602-51a7c973fec3
md"""This finds two of the seven roots, the remainder can be found numerically:
"""

# ╔═╡ d128f504-53c0-11ec-3390-d1be2f0c0333
N.(solve(ex))

# ╔═╡ d128f522-53c0-11ec-3d7b-57dd22a9c95f
md"""### The solveset function
"""

# ╔═╡ d128f554-53c0-11ec-183d-0b84e048c842
md"""SymPy is phasing in the `solveset` function to replace `solve`. The main reason being that `solve` has too many different output types (a vector, a dictionary, ...). The output of `solveset` is always a set. For tasks like this, which return a finite set, we use the `elements` function to access the individual answers. To illustrate:
"""

# ╔═╡ d128fec8-53c0-11ec-3701-176b6da99888
begin
	𝒑 = 8x^4 - 8x^2  + 1
	𝒑_rts = solveset(𝒑)
end

# ╔═╡ d128fef0-53c0-11ec-3d03-4132f257bc01
md"""The `rts` object does not allow immediate access to its elements. For that `elements` will work to return a vector:
"""

# ╔═╡ d1290f8a-53c0-11ec-314e-51fe8e2328eb
elements(𝒑_rts)

# ╔═╡ d1291046-53c0-11ec-251c-4fe1755c5606
md"""So to get the numeric approximation we compose these function calls:
"""

# ╔═╡ d12914be-53c0-11ec-3b71-63f036a7d6fd
N.(elements(solveset(𝒑)))

# ╔═╡ d12914f0-53c0-11ec-2fde-fd3a2c980952
md"""## Do numeric methods matter when you can just graph?
"""

# ╔═╡ d129150c-53c0-11ec-14bd-c96ab99a542a
md"""It may seem that certain practices related to roots of polynomials are unnecessary as we could just graph the equation and look for the roots. This feeling is perhaps motivated by the examples given in textbooks to be worked by hand, which necessarily focus on smallish solutions. But, in general, without some sense of where the roots are, an informative graph itself can be hard to produce. That is, technology doesn't displace thinking - it only supplements it.
"""

# ╔═╡ d129155c-53c0-11ec-2440-637d29e5a365
md"""For another example, consider the polynomial $(x-20)^5 - (x-20) + 1$. In this form we might think the roots are near 20. However, were we presented with this polynomial in expanded form: $x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979$, we might be tempted to just graph it to find roots.  A naive graph might be to plot over $[-10, 10]$:
"""

# ╔═╡ d1292240-53c0-11ec-053f-ad81492fff69
begin
	𝐩 =   x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979
	plot(𝐩, -10, 10)
end

# ╔═╡ d1292290-53c0-11ec-2015-8ba0f8318d44
md"""This seems to indicate a root near 10. But look at the scale of the $y$ axis. The value at $-10$ is around $-25,000,000$ so it is really hard to tell if $f$ is near $0$ when $x=10$, as the range is too large.
"""

# ╔═╡ d12922a4-53c0-11ec-336a-b3e1a48210fe
md"""A graph over $[10,20]$ is still unclear:
"""

# ╔═╡ d129266e-53c0-11ec-3239-d5d309934e9d
plot(𝐩, 10,20)

# ╔═╡ d12926b4-53c0-11ec-1974-b90e90945451
md"""We see that what looked like a zero near 10, was actually a number around $-100,000$.
"""

# ╔═╡ d1292706-53c0-11ec-387e-2131452b87cb
md"""Continuing, a plot over $[15, 20]$ still isn't that useful. It isn't until we get close to 18 that the large values of the polynomial allow a clear vision of the values near $0$. That being said, plotting anything bigger than 22 quickly makes the large values hide those near $0$, and might make us think where the function dips back down there is a second or third zero, when only 1 is the case. (We know that, as this is the same $x^5 - x + 1$ shifted to the right by 20 units.)
"""

# ╔═╡ d1292934-53c0-11ec-23cf-937da033c770
plot(𝐩, 18, 22)

# ╔═╡ d1292966-53c0-11ec-32ae-e12f9e261ded
md"""Not that it can't be done, but graphically solving for a root here can require some judicious choice of viewing window. Even worse is the case where something might graphically look like a root, but in fact not be a root. Something like $(x-100)^2 + 0.1$ will demonstrate.
"""

# ╔═╡ d129297a-53c0-11ec-3b53-577047f9d762
md"""For another example, the following polynomial when plotted over $[-5,7]$ appears to have two real roots:
"""

# ╔═╡ d12930fa-53c0-11ec-2367-39d424f95bfb
begin
	h = x^7 - 16129x^2 + 254x - 1
	plot(h, -5, 7)
end

# ╔═╡ d1293140-53c0-11ec-2253-a3a60200bc14
md"""in fact there are three, two are *very* close together:
"""

# ╔═╡ d1293398-53c0-11ec-3897-c593dacbf403
N.(solve(h))

# ╔═╡ d12941da-53c0-11ec-11b5-a1dee13cb3a5
note("""
The difference of the two roots is around `1e-10`. For the graph over the interval of ``[-5,7]`` there are about 800 "pixels" used, so each pixel represents a size of about `1.5e-2`. So the cluster of roots would safely be hidden under a single "pixel."
""")

# ╔═╡ d1294202-53c0-11ec-38e5-43468c9a6b49
md"""The point of this is to say, that it is useful to know where to look for roots, even if graphing calculators or graphing programs make drawing graphs relatively painless. A better way in this case would be to find the real roots first, and then incorporate that information into the choice of plot window.
"""

# ╔═╡ d1294220-53c0-11ec-262f-6963e3057732
md"""## Some facts about the real roots of a polynomial
"""

# ╔═╡ d1294252-53c0-11ec-2950-a1142286b66b
md"""A polynomial with real coefficients may or may not have real roots. The following discusses some simple checks on the number of real roots and bounds on how big they can be. This can be *roughly* used to narrow viewing windows when graphing polynomials.
"""

# ╔═╡ d1294266-53c0-11ec-22d4-835e556a8caf
md"""### Descartes' rule of signs
"""

# ╔═╡ d129428c-53c0-11ec-1f16-ad4bfd6a41ac
md"""The study of polynomial roots is an old one. In 1637 Descartes published a *simple* method to determine an upper bound on the number of *positive* real roots of a polynomial.
"""

# ╔═╡ d1294388-53c0-11ec-3605-450483861fae
md"""> [Descartes' rule of signs](http://en.wikipedia.org/wiki/Descartes%27_rule_of_signs). if  $p=a_n x^n + a_{n-1}x^{n-1} + \cdots a_1x + a_0$ then the number of  positive real roots is  either equal to the number of  sign differences between consecutive nonzero coefficients, or is  less than it by an even number. Repeated roots are counted separately.

"""

# ╔═╡ d12943b0-53c0-11ec-3c6f-5d398047f9c6
md"""One method of proof (sketched at the end of this section) first shows that in synthetic division by $(x-c)$ with $c > 0$, we must have that any sign change in $q$ is related to a sign change in $p$ and there must be at least one more in $p$. This is then used to show that there can be only as many positive roots as sign changes. That the difference comes in pairs is related to complex roots of real polynomials always coming in pairs.
"""

# ╔═╡ d12943c6-53c0-11ec-3831-1b72f7675714
md"""An immediate consequence, is that a polynomial whose coefficients are all non-negative will have no positive real roots.
"""

# ╔═╡ d129440a-53c0-11ec-3924-51a63e9320fc
md"""Applying this to the polynomial $x^5 -x + 1$ we get that the sign pattern is `+`, `-`, `+` which has two changes of sign. The number of *positive* real roots is either 2 or 0. In fact there are $0$ for this case.
"""

# ╔═╡ d1294446-53c0-11ec-39da-39475fc28105
md"""What about negative roots? Cleary, any negative root of $p$ is a positive root of $q(x) = p(-x)$, as the graph of $q$ is just that of $p$ flipped through the $y$ axis. But the coefficients of $q$ are the same as $p$, except for the odd-indexed coefficients ($a_1, a_3, \dots$) have a changed sign.  Continuing with our example, for $q(x) = -x^5 + x + 1$ we get the new sign pattern `-`, `+`, `+` which yields one sign change. That is, there *must* be a negative real root, and indeed there is, $x \approx -1.1673$.
"""

# ╔═╡ d129446e-53c0-11ec-0387-3bd57779a3d5
md"""With this knowledge, we could have known that in an earlier example the graph of `p = x^7 - 16129x^2 + 254x - 1` – which indicated two positive real roots – was misleading, as there must be $1$ or $3$ by a count of the sign changes.
"""

# ╔═╡ d1294496-53c0-11ec-0210-53d81144bb7e
md"""For another example, if we looked at $f(x) = x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979$ again, we see that there could be 1, 3, or 5 *positive* roots. However, changing the signs of the odd powers leaves all "-" signs, so there are $0$ negative roots. From the graph, we saw just 1 real root, not 3 or 5. We can verify numerically with:
"""

# ╔═╡ d1294ffe-53c0-11ec-2033-b9af47a8fd41
begin
	j =  x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979
	N.(solve(j))
end

# ╔═╡ d129506a-53c0-11ec-1788-fba1f4a375ee
md"""### Cauchy's bound on the magnitude of the real roots.
"""

# ╔═╡ d12950a8-53c0-11ec-1256-75e94f8ad774
md"""Descartes' rule gives a bound on how many real roots there may be. Cauchy provided a bound on how large they can be. Assume our polynomial is monic (if not, divide by $a_n$ to make it so, as this won't effect the roots). Then any real root is no larger in absolute value than $|a_0| + |a_1| + |a_2| + \cdots + |a_n|$, (this is expressed in different ways.)
"""

# ╔═╡ d12950e4-53c0-11ec-18cb-4fe1b8d5342f
md"""To see precisely [why](https://captainblack.wordpress.com/2009/03/08/cauchys-upper-bound-for-the-roots-of-a-polynomial/) this bound works, suppose $x$ is a root with $|x| > 1$ and let $h$ be the bound. Then since $x$ is a root, we can solve for $x^n$ as:
"""

# ╔═╡ d129510e-53c0-11ec-2f84-2f58cce0d722
md"""```math
x_n = -(a_0 + a_1 x + \cdots a_{n-1}x^{n-1})
```
"""

# ╔═╡ d1295120-53c0-11ec-24a5-a9565da00c17
md"""Which after taking absolute values of both sides, yields:
"""

# ╔═╡ d1295140-53c0-11ec-32f0-95d84fafe08c
md"""```math
|x_n| \leq |a_0| + |a_1||x| + |a_2||x^2| + \cdots |a_{n-1}| |x^{n-1}| \leq (h-1) (1 + |x| + |x^2| + \cdots |x^{n-1}|).
```
"""

# ╔═╡ d1295152-53c0-11ec-3f61-c714ac897935
md"""The last sum can be computed using a formula for geometric sums, $(|x^n| - 1)/(|x|-1)$. Rearranging, gives the inequality:
"""

# ╔═╡ d129515c-53c0-11ec-1d8e-450b9e3d8bbc
md"""```math
|x| - 1 \leq (h-1) \cdot (1 - \frac{1}{|x^n|} ) \leq (h-1)
```
"""

# ╔═╡ d1295172-53c0-11ec-2593-cb858db17773
md"""from which it follows that $|x| \leq h$, as desired.
"""

# ╔═╡ d129518e-53c0-11ec-096b-d72b1a72a1e8
md"""For our polynomial $x^5 -x + 1$ we have the sum above is $3$. The lone real root is approximately $-1.1673$ which satisfies $|-1.1673| \leq 3$.
"""

# ╔═╡ d12951ac-53c0-11ec-0412-0feb9677b117
md"""## Questions
"""

# ╔═╡ d129522e-53c0-11ec-1e92-a1f83a16c131
md"""###### Question
"""

# ╔═╡ d1295256-53c0-11ec-1fd9-e32bedb9d64a
md"""What is the remainder of dividing $x^4 - x^3 - x^2 + 2$ by $x-2$?
"""

# ╔═╡ d1295e40-53c0-11ec-2b96-eb8a9c3a5bc2
let
	choices = [
	    "``x^3 + x^2 + x + 2``",
	    "``x-2``",
	    "``6``",
	    "``0``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ d1295eec-53c0-11ec-3727-f99c2c3fb554
md"""###### Question
"""

# ╔═╡ d1295f26-53c0-11ec-1f41-59c01b21acf9
md"""What is the remainder of dividing $x^4 - x^3 - x^2 + 2$ by $x^3 - 2x$?
"""

# ╔═╡ d129675c-53c0-11ec-1b18-677275f04643
let
	choices = [
	    "``x - 1``",
	    "``x^2 - 2x + 2``",
	    "``2``"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ d12968a4-53c0-11ec-0f4d-91229f4f564b
md"""###### Question
"""

# ╔═╡ d12968e0-53c0-11ec-2a7c-af0e896a16af
md"""We have that $x^5 - x + 1 = (x^3 + x^2 - 1) \cdot (x^2 - x + 1) + (-2x + 2)$.
"""

# ╔═╡ d12968fe-53c0-11ec-3229-59c2aab06c3e
md"""What is the remainder of dividing $x^5 - x + 1$ by $x^2 - x + 1$?
"""

# ╔═╡ d1297222-53c0-11ec-18c2-bfa9b50c1404
let
	choices = [
	"``x^2 - x + 1``",
	"``x^3 + x^2 - 1``",
	"``-2x + 2``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ d1297240-53c0-11ec-0827-f3f0b15e60e3
md"""###### Question
"""

# ╔═╡ d1297254-53c0-11ec-015a-2b5d11d3e336
md"""Consider this output from synthetic division
"""

# ╔═╡ d1297286-53c0-11ec-1760-7d2b3974e56e
md"""```
2 | 1 0 0 0 -1  1
  |   2 4 8 16 30
  ---------------
    1 2 4 8 15 31
```"""

# ╔═╡ d12972a4-53c0-11ec-22c4-f3f53da915be
md"""representing $p(x) = q(x)\cdot(x-c) + r$.
"""

# ╔═╡ d12972b8-53c0-11ec-126a-fff0eab44933
md"""What is $p(x)$?
"""

# ╔═╡ d129826c-53c0-11ec-1b57-a504349a8cde
let
	choices = [
	"``x^5 - x + 1``",
	"``2x^4 + 4x^3 + 8x^2 + 16x + 30``",
	"``x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31``",
	"``x^4 +2x^3 + 4x^2 + 8x + 15``",
	"``31``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d12982b4-53c0-11ec-13b6-affa8e54cdef
md"""What is $q(x)$?
"""

# ╔═╡ d129911c-53c0-11ec-2c1a-bd0979fbea43
let
	choices = [
	"``x^5 - x + 1``",
	"``2x^4 + 4x^3 + 8x^2 + 16x + 30``",
	"``x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31``",
	"``x^4 +2x^3 + 4x^2 + 8x + 15``",
	"``31``"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ d1299162-53c0-11ec-2f54-cf5dcf039c7c
md"""What is $r$?
"""

# ╔═╡ d129a080-53c0-11ec-0612-7562582df632
let
	choices = [
	"``x^5 - x + 1``",
	"``2x^4 + 4x^3 + 8x^2 + 16x + 30``",
	"``x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31``",
	"``x^4 +2x^3 + 4x^2 + 8x + 15``",
	"``31``"]
	ans = 5
	radioq(choices, ans)
end

# ╔═╡ d129a0b2-53c0-11ec-163d-256a846f7948
md"""###### Question
"""

# ╔═╡ d129a0e4-53c0-11ec-253e-b1950f254343
md"""Let $p=x^4 -9x^3 +30x^2 -44x + 24$
"""

# ╔═╡ d129a0f8-53c0-11ec-38a6-a1e7a0b24aad
md"""Factor $p$. What are the factors?
"""

# ╔═╡ d129a9a4-53c0-11ec-0f76-f38b25121f98
let
	choices = [
	L" $2$ and  $3$",
	L" $(x-2)$ and $(x-3)$",
	L" $(x+2)$ and $(x+3)$"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ d129a9c2-53c0-11ec-1bd9-1f2502d833da
md"""###### Question
"""

# ╔═╡ d129a9ea-53c0-11ec-15d4-5b018051874f
md"""Does the expression $x^4 - 5$ factor over the rational numbers?
"""

# ╔═╡ d129ad80-53c0-11ec-0405-8f7bf8154334
let
	yesnoq(false)
end

# ╔═╡ d129adb2-53c0-11ec-3b8b-b562f389ae21
md"""Using `solve`, how many real roots does $x^4 - 5$ have:
"""

# ╔═╡ d129b00c-53c0-11ec-19b1-25ec302cb65b
let
	numericq(2)
end

# ╔═╡ d129b022-53c0-11ec-11a7-d9af4454c957
md"""###### Question
"""

# ╔═╡ d129b05c-53c0-11ec-2fcb-93803a828c66
md"""The Soviet historian I. Y. Depman claimed that in $1486$, Spanish mathematician Valmes was burned at the stake for claiming to have solved the [quartic equation](https://en.wikipedia.org/wiki/Quartic_function). Here we don't face such consequences.
"""

# ╔═╡ d129b07a-53c0-11ec-1c63-872366f92b22
md"""Find the largest real root of $x^4 - 10x^3 + 32x^2 - 38x + 15$.
"""

# ╔═╡ d129b52c-53c0-11ec-3584-2128ab11afa1
let
	@syms x
	p = x^4 - 10x^3 + 32x^2 - 38x + 15
	rts = sympy.real_roots(p)
	numericq(N(maximum(rts)))
end

# ╔═╡ d129b566-53c0-11ec-2c4e-8b7f83510d38
md"""###### Question
"""

# ╔═╡ d129b61a-53c0-11ec-1f0f-3d6e5f9b0218
md"""What are the numeric values of the real roots of $f(x) = x^6 - 5x^5 + x^4 - 3x^3 + x^2 - x + 1$?
"""

# ╔═╡ d129dc80-53c0-11ec-1533-79e91acc517d
let
	choices = [
	q"[-0.434235, -0.434235,  0.188049, 0.188049, 0.578696, 4.91368]",
	q"[-0.434235, -0.434235,  0.188049, 0.188049]",
	q"[0.578696, 4.91368]",
	q"[-0.434235+0.613836im, -0.434235-0.613836im]"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ d129dcb2-53c0-11ec-05f2-355619ae5888
md"""###### Question
"""

# ╔═╡ d129dcc6-53c0-11ec-3d7f-5d063a129bc2
md"""Odd polynomials must have at least one real root.
"""

# ╔═╡ d129dcfa-53c0-11ec-3b5d-6f14908b69e0
md"""Consider the polynomial $x^5 - 3x + 1$. Does it have more than one real root?
"""

# ╔═╡ d129e874-53c0-11ec-1809-47474e790091
let
	xs = find_zeros(x -> x^5 - 3x + 1, -10..10)
	yesnoq(length(xs) > 1)
end

# ╔═╡ d129e8a6-53c0-11ec-3f7f-419bd7610f26
md"""Consider the polynomial $x^5 - 1.5x + 1$. Does it have more than one real root?
"""

# ╔═╡ d129f2b0-53c0-11ec-3323-6559e299afb5
let
	xs = find_zeros(x -> x^5 - 1.5x + 1, -10..10)
	yesnoq(length(xs) > 1)
end

# ╔═╡ d129f2ce-53c0-11ec-2087-4b8c354f9a7d
md"""###### Question
"""

# ╔═╡ d129f2f6-53c0-11ec-09c8-3378184ce558
md"""What is the maximum number of positive, real roots that Descarte's bound says $p=x^5 + x^4 - x^3 + x^2 + x + 1$ can have?
"""

# ╔═╡ d129f4b8-53c0-11ec-3942-0b7d7f8666c4
let
	numericq(2)
end

# ╔═╡ d129f4cc-53c0-11ec-2539-b13403fffd1f
md"""How many positive, real roots does it actually have?
"""

# ╔═╡ d129f65c-53c0-11ec-087b-7f65644baecc
let
	numericq(0)
end

# ╔═╡ d129f684-53c0-11ec-2fc0-9be06a16065d
md"""What is the maximum number of negative, real roots  that Descarte's bound says $p=x^5 + x^4 - x^3 + x^2 + x + 1$ can have?
"""

# ╔═╡ d129f81e-53c0-11ec-14c8-f96c433455fc
let
	numericq(3)
end

# ╔═╡ d129f83c-53c0-11ec-2cc4-d1f36c365290
md"""How many negative, real roots does it actually have?
"""

# ╔═╡ d129f9c2-53c0-11ec-0bb9-dda36eade23d
let
	numericq(1)
end

# ╔═╡ d129f9d6-53c0-11ec-2b70-7352c87f9c46
md"""###### Question
"""

# ╔═╡ d129f9fe-53c0-11ec-050e-035e6fbafff3
md"""Let $f(x) = x^5 - 4x^4 + x^3 - 2x^2 + x$. What does Cauchy's bound say is the largest possible magnitude of a root?
"""

# ╔═╡ d12a00e8-53c0-11ec-0bf1-256b5f42dbd9
let
	ans = 1 + 4 + 1 + 2 + 1
	numericq(ans)
end

# ╔═╡ d12a00fc-53c0-11ec-3261-8f964f2bb98b
md"""What is the largest magnitude of a real root?
"""

# ╔═╡ d12a0976-53c0-11ec-1207-45c73a227691
let
	f(x) = x^5 - 4x^4 + x^3 - 2x^2 + x
	rts = find_zeros(f, -5..5)
	ans = maximum(abs.(rts))
	numericq(ans)
end

# ╔═╡ d12a098a-53c0-11ec-177a-b1046b062a3a
md"""###### Question
"""

# ╔═╡ d12a09bc-53c0-11ec-2077-1d7af978c5e7
md"""As $1 + 2 + 3 + 4$ is $10$, Cauchy's bound says that the magnitude of the largest real root of $x^3 - ax^2 + bx - c$ is $10$ where $a,b,c$ is one of $2,3,4$. By considering all 6 such possible polynomials (such as $x^3 - 3x^2 + 2x - 4$) what is the largest magnitude or a root?
"""

# ╔═╡ d12a36ce-53c0-11ec-3a0c-11340f5aa64a
let
	function mag()
	    p = Permutation(0,2)
	    q = Permutation(1,2)
	    m = 0
	    for perm in (p, q, q*p, p*q, p*q*p, p^2)
	        as =  perm([2,3,4])
	        fn = x -> x^3 - as[1]*x^2 + as[2]*x - as[3]
	        rts_ = find_zeros(fn, -10..10)
		    a1 = maximum(abs.(rts_))
		    m = a1 > m ? a1 : m
	    end
	    m
	end
	numericq(mag())
end

# ╔═╡ d12a372a-53c0-11ec-15de-43cfbfe92f56
md"""###### Question
"""

# ╔═╡ d12a37ac-53c0-11ec-0426-b55ddc6e181d
md"""The roots of the [Chebyshev](https://en.wikipedia.org/wiki/Chebyshev_polynomials) polynomials are helpful for some numeric algorithms. These are a family of polynomials related by $T_{n+1}(x) = 2xT_n(x) - T_{n-1}(x)$ (a recurrence relation in the manner of the Fibonacci sequence). The first two are $T_0(x) = 1$ and $T_1(x) =x$.
"""

# ╔═╡ d12a389c-53c0-11ec-3945-63553f580f70
md"""  * Based on the relation, figure out $T_2(x)$. It is
"""

# ╔═╡ d12a430a-53c0-11ec-2d60-076f39b08da7
let
	choices = [
	    "``4x^2 - 1``",
	    "``2x^2``",
	    "``x``",
	    "``2x``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d12a43f0-53c0-11ec-0563-3918408323b8
md"""  * True or false, the $degree$ of $T_n(x)$ is $n$: (Look at the defining relation and reason this out).
"""

# ╔═╡ d12a4648-53c0-11ec-166c-893ade3a2647
let
	yesnoq(true)
end

# ╔═╡ d12a46c0-53c0-11ec-1785-43c024d32630
md"""  * The fifth one is $T_5(x) = 32x^5 - 32x^3 + 6x$. Cauchy's bound says that the largest root has absolute value
"""

# ╔═╡ d12a4af0-53c0-11ec-074a-0d0311f7c247
1 + 1 + 6/32

# ╔═╡ d12a4b3e-53c0-11ec-0072-a131e60380da
md"""The Chebyshev polynomials have the property that in fact all $n$ roots are real, distinct, and in $[-1, 1]$. Using `SymPy`, find the magnitude of the largest root:
"""

# ╔═╡ d12abcae-53c0-11ec-3aab-3d82b6a32ee1
let
	@syms x
	p = 16x^5 - 20x^3 + 5x
	rts = N.(solve(p))
	ans = maximum(norm.(rts))
	numericq(ans)
end

# ╔═╡ d12abe22-53c0-11ec-0946-33ba25253e94
md"""  * Plotting `p` over the interval $[-2,2]$ does not help graphically identify the roots:
"""

# ╔═╡ d12ad342-53c0-11ec-061a-3b0a9c78899a
let
	plot(16x^5 - 20x^3 + 5x, -2, 2)
end

# ╔═╡ d12ad3da-53c0-11ec-10a2-3753a1e61002
md"""Does graphing over $[-1,1]$ show clearly the $5$ roots?
"""

# ╔═╡ d12ad676-53c0-11ec-063e-ab2479afa882
let
	yesnoq(true)
end

# ╔═╡ d12ad6b2-53c0-11ec-1522-dd55414e46b4
md"""## Appendix: Proof of Descartes' rule of signs
"""

# ╔═╡ d12ad6f8-53c0-11ec-30cf-25c3824d39be
md"""[Proof modified from this post](http://www.cut-the-knot.org/fta/ROS2.shtml).
"""

# ╔═╡ d12ad7f2-53c0-11ec-1509-f116862deb89
md"""First, we can assume $p$ is monic ($p_n=1$), and $p_0$ is non zero. The latter, as we can easily deflate the polynomial by dividing by $x$ if $p_0$ is zero.
"""

# ╔═╡ d12ad838-53c0-11ec-0a3f-3b8a95efa2c0
md"""Let `var(p)` be the number of sign changes and `pos(p)` the number of positive real roots of `p`.
"""

# ╔═╡ d12ad876-53c0-11ec-1c02-33c57b5c5cd5
md"""First: For a monic $p$ if  $p_0 < 0$ then `var(p)` is odd and if $p_0 > 0$ then `var(p)` is even.
"""

# ╔═╡ d12ad8d6-53c0-11ec-24e0-3d6eb41cbb52
md"""This is true for degree $n=1$ the two sign patterns under the assumption are `+-` ($p_0 < 0$) or `++` ($p_0 > 0$). If it is true for degree $n-1$, then the we can consider the sign pattern of such a $n$ degree polynomial having one of these patterns: `+....+-` or `+...--` (if $p_0 < 0$) or `+...++` or `+...-+` if ($p_0>0$). An induction step applied to all but the last sign for these four patterns leads to even, odd, even, odd as the number of sign changes. Incorporating the last sign leads to odd, odd, even, even as the number of sign changes.
"""

# ╔═╡ d12ad928-53c0-11ec-1e62-d3640618306d
md"""Second: For a monic $p$ if `p_0 < 0` then `pos(p)` is *odd*, if `p_0 > 0` then `pos(p)` is even.
"""

# ╔═╡ d12ad9ac-53c0-11ec-3bd2-c30827114123
md"""This is clearly true for **monic** degree $1$ polynomials: if $c$ is positive $p = x - c$ has one real root (an odd number) and $p = x + c$ has $0$ real roots (an even number). Now, suppose $p$ has degree $n$ and is monic. Then as $x$ goes to $\infty$, it must be $p$ goes to $\infty$.
"""

# ╔═╡ d12ada22-53c0-11ec-1c88-6bde5971d301
md"""If $p_0 < 0$ then there must be a positive real root, say $r$, (Bolzano). Dividing $p$ by $(x-r)$ to produce $q$ requires $q_0$ to be *positive* and of lower degree. By *induction* $q$ will have an even number of roots. Add in the root $r$ to see that $p$ will have an **odd** number of roots.
"""

# ╔═╡ d12adab0-53c0-11ec-1611-4d67293cd1db
md"""Now consider the case $p_0 > 0$. There are two possibilities either `pos(p)` is zero or positive. If `pos(p)` is $0$ then there are an even number of roots. If `pos(p)` is positive, then call $r$ one of the real positive roots. Again divide by $x-r$ to produce $p = (x-r) \cdot q$. Then $q_0$ must be *negative* for $p_0$ to be positive. By *induction* $q$ must have an odd number or roots, meaning $p$ must have an even numbers
"""

# ╔═╡ d12adafe-53c0-11ec-1012-f18a0e548a61
md"""So there is parity between `var(p)` and `pos(p)`: if $p$ is monic and $p_0 < 0$ then both `var(p)` and `pos(p)` are both odd; and if $p_0 > 0$ both `var(p)` and `pos(p)` are both even.
"""

# ╔═╡ d12adb58-53c0-11ec-1a43-a90a7e22d945
md"""Descartes' rule of signs will be established if it can be shown that `var(p)` is at least as big as `pos(p)`. Supppose $r$ is a positive real root of $p$ with $p = (x-r)q$. We show that `var(p) > var(q)` which can be repeatedly applied to show that if $p=(x-r_1)\cdot(x-r_2)\cdot \cdots \cdot (x-r_l) q$, where the $r_i$s are the postive real roots, then `var(p) >= l + var(q) >= l = pos(p)`.
"""

# ╔═╡ d12adb9e-53c0-11ec-3808-8dbaf334e387
md"""As $p = (x-c)q$ we must have the leading term is $p_nx^n = x \cdot q_{n-1} x^{n-1}$ so $q_{n_1}$ will also be `+` under our monic assumption. Looking at a possible pattern for the signs of $q$, we might see the following unfinished synthetic division table for a specific $q$:
"""

# ╔═╡ d12adbee-53c0-11ec-280e-6f42e499cf9a
md"""```
  + ? ? ? ? ? ? ? ?
+   ? ? ? ? ? ? ? ?
  -----------------
  + - - - + - + + 0
```"""

# ╔═╡ d12adc18-53c0-11ec-36ad-b7b02f2374f5
md"""But actually, we can fill in more, as the second row is formed by multiplying a postive $c$:
"""

# ╔═╡ d12adc3e-53c0-11ec-3294-03c28a05b956
md"""```
  + ? ? ? ? ? ? ? ?
+   + - - - + - + +
  -----------------
  + - - - + - + + 0
```"""

# ╔═╡ d12adc84-53c0-11ec-2f8d-a1bd92c29e58
md"""What's more, using the fact that to get `0` the two summands must differ in sign and to have a `?` plus `+` yield a `-`, the `?` must be `-` (and reverse), the following must be the case for the signs of `p`:
"""

# ╔═╡ d12adcaa-53c0-11ec-3e15-33d22feeaa71
md"""```
  + - ? ? + - + ? -
+   + - - - + - + +
  -----------------
  + - - - + - + + 0
```"""

# ╔═╡ d12add1a-53c0-11ec-2ce3-65fc607d71cb
md"""If the bottom row represents $q_7, q_6, \dots, q_0$  and the top row $p_8, p_7, \dots, p_0$, then the sign changes in $q$ from `+` to `-` are matched by sign changes in $p$. The ones in $q$ from $-$ to $+$ are also matched regardless of the sign of the first two question marks (though $p$ could possibly have more). The last sign change in $p$ between $p_2$ and $p_0$ has no counterpart in $q$, so there is at least one more sign change in $p$ than $q$.
"""

# ╔═╡ d12add42-53c0-11ec-24d1-099b085b94de
md"""As such, the `var(p)` $\geq 1 +$ `var(q)`.
"""

# ╔═╡ d12add74-53c0-11ec-2552-b5eab61e1b04
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/polynomial.html">◅ previous</a>  <a href="../precalc/polynomials_package.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/polynomial_roots.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ d12add92-53c0-11ec-1cc6-1bc504a95738
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Roots = "~1.3.11"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[deps.CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Pluto", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "7adfe1a4e3f52fc356dfa2b0b26457f0acf81aa2"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.10"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[deps.ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "d8f468c5cd4d94e86816603f7d18ece910b4aaf1"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.5.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[deps.ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "6406b5112809c08b1baa5703ad274e1dded0652f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.23"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "f823a2d04fb233d52812c8024a6d46d9581904a4"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.4.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[deps.NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "d73736030a094e8d24fdf3629ae980217bf1d59d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.3"

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "Sockets", "TableIOInterface", "Tables", "UUIDs"]
git-tree-sha1 = "a5b3fee95de0c0a324bab53a03911395936d15d9"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.17.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableIOInterface]]
git-tree-sha1 = "9a0d3ab8afd14f33a35af7391491ff3104401a35"
uuid = "d1efa939-5518-4425-949f-ab857e148477"
version = "0.1.6"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[deps.Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─d12add56-53c0-11ec-12a8-a374c7150074
# ╟─d1277c9a-53c0-11ec-2a1a-7bf1906a368e
# ╟─d127906a-53c0-11ec-3dfd-ed2446aff329
# ╠═d1279f74-53c0-11ec-2f21-fdfa70caa1fa
# ╟─d127a49a-53c0-11ec-1e93-b3be91d1fc3a
# ╟─d127a570-53c0-11ec-198f-87b252bb3055
# ╟─d127a618-53c0-11ec-0429-a9abf6f85a20
# ╠═d127afe6-53c0-11ec-193f-b3bf8ceb13c5
# ╟─d127b022-53c0-11ec-0810-05167379a84e
# ╟─d127b036-53c0-11ec-03c4-2729b7cc629c
# ╟─d127b4f0-53c0-11ec-106e-dbdefedfe89c
# ╟─d127b50e-53c0-11ec-3249-ff190c667563
# ╟─d127b522-53c0-11ec-2236-c518608989ed
# ╟─d127b662-53c0-11ec-2838-418e3152fb81
# ╟─d127b67e-53c0-11ec-0cfa-b9337c930c3b
# ╟─d127b6da-53c0-11ec-24a3-055983b9304c
# ╟─d127b722-53c0-11ec-2204-f5aa6d8a6682
# ╟─d127c4ae-53c0-11ec-1ec8-b3a815668d65
# ╟─d127c53a-53c0-11ec-2d2f-4b0096340703
# ╟─d127c560-53c0-11ec-27db-fb531d2ac5b2
# ╟─d127c580-53c0-11ec-1242-cbf752e1e320
# ╟─d127c59e-53c0-11ec-0728-bd7384e976f1
# ╟─d127c5bc-53c0-11ec-2615-b1a34332cdf1
# ╟─d127c5ee-53c0-11ec-3b62-396f7b27cc60
# ╟─d127c60c-53c0-11ec-3424-3b6575270bcc
# ╟─d127c652-53c0-11ec-0516-9df7cb832e27
# ╟─d127c6a2-53c0-11ec-3257-cf47614be398
# ╟─d127c6b6-53c0-11ec-06c4-6f1396e30beb
# ╟─d127c6d4-53c0-11ec-2c9b-8fc32319c0c6
# ╟─d127c6f2-53c0-11ec-0f94-a138858baa07
# ╟─d127c6fa-53c0-11ec-11c4-19bf8ceb87d7
# ╟─d127c71a-53c0-11ec-07db-239f556dbbad
# ╟─d127c72e-53c0-11ec-3d7f-bde4c4d66f91
# ╟─d127c74c-53c0-11ec-31bd-17dffba654fc
# ╟─d127c76c-53c0-11ec-0ae5-7b837a8dbdaf
# ╠═d127f212-53c0-11ec-0970-fde17023bdee
# ╟─d127f280-53c0-11ec-0731-e570d9108149
# ╠═d127f5fa-53c0-11ec-0b0f-8f6a9eb3c287
# ╠═d127fec4-53c0-11ec-32a7-89e6ac7659d0
# ╟─d127ff1e-53c0-11ec-1def-db95a143fb8e
# ╟─d127ff32-53c0-11ec-0bdb-1d6509fcf7f2
# ╟─d127ff50-53c0-11ec-2139-97e1bad1caa9
# ╟─d127ff5a-53c0-11ec-0515-47b4d43cb3ca
# ╠═d1280914-53c0-11ec-0c30-93b669240fe4
# ╟─d1280950-53c0-11ec-3ea9-61805a524dd9
# ╟─d128096e-53c0-11ec-27cf-4b2d871378ee
# ╠═d128138c-53c0-11ec-1f5b-23fff3e4c7d0
# ╟─d12813dc-53c0-11ec-049c-074ec6c3c14f
# ╟─d1281f6c-53c0-11ec-1dc9-b5dade295ee0
# ╟─d1281fd0-53c0-11ec-04f3-e7076f6e8688
# ╠═d1282d7c-53c0-11ec-3da8-4f1d8346269a
# ╟─d1282e08-53c0-11ec-32d7-adeb95f248ae
# ╟─d1282e4e-53c0-11ec-095d-8d235c5ea444
# ╟─d1282ef8-53c0-11ec-16bd-215db19fed01
# ╟─d1282f34-53c0-11ec-2472-a58c49c7fd0c
# ╟─d1282f48-53c0-11ec-35d5-fdf403bc3e6e
# ╟─d1282f70-53c0-11ec-3ddf-472e9a78839c
# ╟─d1282f8e-53c0-11ec-2054-73bb493c195f
# ╟─d1282fb6-53c0-11ec-0461-7f3e23e68f42
# ╟─d1283026-53c0-11ec-242b-b33fdff78fa6
# ╠═d128415e-53c0-11ec-157b-3da1f743e429
# ╟─d12841c2-53c0-11ec-005b-eb7fe0d5a84f
# ╟─d128426a-53c0-11ec-25ca-4b11d1610bfa
# ╟─d128438e-53c0-11ec-06fd-9330cc844832
# ╟─d12843ac-53c0-11ec-1374-a11020bee37d
# ╟─d1285414-53c0-11ec-10b3-03c88568ef53
# ╟─d12873de-53c0-11ec-175d-d9dcb020dd71
# ╟─d1287520-53c0-11ec-12e1-f19dee583841
# ╟─d12875ac-53c0-11ec-2e96-ef7bb552a6f5
# ╟─d12875fc-53c0-11ec-0e79-81c930346527
# ╟─d1287638-53c0-11ec-2642-29f1db7493d6
# ╟─d1287688-53c0-11ec-3bc9-97d2d01676fb
# ╠═d1288530-53c0-11ec-129b-fd5fac5fc00c
# ╟─d12885b0-53c0-11ec-2d9a-8935bd761d56
# ╟─d12885e2-53c0-11ec-387a-3d51aa311380
# ╟─d128860a-53c0-11ec-0cf9-951ec1249f48
# ╟─d1288628-53c0-11ec-24b1-a51ff9842959
# ╠═d1288b6e-53c0-11ec-184e-bbb8bbd92584
# ╟─d1288bc8-53c0-11ec-363f-1d8828330a69
# ╟─d1288be6-53c0-11ec-3def-a993f10fb819
# ╠═d128a21e-53c0-11ec-2a03-99a1371fb1f7
# ╟─d128a282-53c0-11ec-17d7-8103dbc97b7f
# ╠═d128a752-53c0-11ec-2232-c39e3fd10a22
# ╠═d128acfa-53c0-11ec-0046-1bdb038c723b
# ╠═d128b2c4-53c0-11ec-3694-df91626f42c5
# ╟─d128b328-53c0-11ec-2cb3-6b9b6efe75ce
# ╠═d128b94a-53c0-11ec-3c31-d17f5db1c9f6
# ╟─d128b99a-53c0-11ec-1849-f9c8be315674
# ╠═d128c2be-53c0-11ec-14d0-89d550c9c5c2
# ╟─d128c2e8-53c0-11ec-1a0b-cf92ba9334f4
# ╠═d128c74e-53c0-11ec-311a-b9307e9f964c
# ╟─d128c764-53c0-11ec-2128-fbd02cc9ff9d
# ╠═d128ce12-53c0-11ec-1dc4-2b7c69139225
# ╟─d128ce44-53c0-11ec-0410-71c1c6f4ace6
# ╠═d128d222-53c0-11ec-3607-3fa54386e16b
# ╟─d128d268-53c0-11ec-151c-17bccd5585af
# ╟─d128d2a4-53c0-11ec-0f24-2d0d0fa7bd60
# ╟─d128d2b8-53c0-11ec-0a38-67636c1c3979
# ╟─d128d2cc-53c0-11ec-0f0b-673d93f07fde
# ╠═d128d8ee-53c0-11ec-0c96-61754b85a9d8
# ╟─d128d916-53c0-11ec-2df6-01ab68a8e4ab
# ╠═d128dd9e-53c0-11ec-0bb7-5533fb53d716
# ╟─d128ddee-53c0-11ec-19de-77d0fa8e4385
# ╟─d128de02-53c0-11ec-11b2-5b915c38326a
# ╟─d128de20-53c0-11ec-2889-65a889993655
# ╠═d128e40e-53c0-11ec-394c-8debc7491cb5
# ╟─d128e424-53c0-11ec-1422-435c8b717c20
# ╠═d128f234-53c0-11ec-3390-b3d2ed22539f
# ╟─d128f252-53c0-11ec-0602-51a7c973fec3
# ╠═d128f504-53c0-11ec-3390-d1be2f0c0333
# ╟─d128f522-53c0-11ec-3d7b-57dd22a9c95f
# ╟─d128f554-53c0-11ec-183d-0b84e048c842
# ╠═d128fec8-53c0-11ec-3701-176b6da99888
# ╟─d128fef0-53c0-11ec-3d03-4132f257bc01
# ╠═d1290f8a-53c0-11ec-314e-51fe8e2328eb
# ╟─d1291046-53c0-11ec-251c-4fe1755c5606
# ╠═d12914be-53c0-11ec-3b71-63f036a7d6fd
# ╟─d12914f0-53c0-11ec-2fde-fd3a2c980952
# ╟─d129150c-53c0-11ec-14bd-c96ab99a542a
# ╟─d129155c-53c0-11ec-2440-637d29e5a365
# ╠═d1292240-53c0-11ec-053f-ad81492fff69
# ╟─d1292290-53c0-11ec-2015-8ba0f8318d44
# ╟─d12922a4-53c0-11ec-336a-b3e1a48210fe
# ╠═d129266e-53c0-11ec-3239-d5d309934e9d
# ╟─d12926b4-53c0-11ec-1974-b90e90945451
# ╟─d1292706-53c0-11ec-387e-2131452b87cb
# ╠═d1292934-53c0-11ec-23cf-937da033c770
# ╟─d1292966-53c0-11ec-32ae-e12f9e261ded
# ╟─d129297a-53c0-11ec-3b53-577047f9d762
# ╠═d12930fa-53c0-11ec-2367-39d424f95bfb
# ╟─d1293140-53c0-11ec-2253-a3a60200bc14
# ╠═d1293398-53c0-11ec-3897-c593dacbf403
# ╟─d12941da-53c0-11ec-11b5-a1dee13cb3a5
# ╟─d1294202-53c0-11ec-38e5-43468c9a6b49
# ╟─d1294220-53c0-11ec-262f-6963e3057732
# ╟─d1294252-53c0-11ec-2950-a1142286b66b
# ╟─d1294266-53c0-11ec-22d4-835e556a8caf
# ╟─d129428c-53c0-11ec-1f16-ad4bfd6a41ac
# ╟─d1294388-53c0-11ec-3605-450483861fae
# ╟─d12943b0-53c0-11ec-3c6f-5d398047f9c6
# ╟─d12943c6-53c0-11ec-3831-1b72f7675714
# ╟─d129440a-53c0-11ec-3924-51a63e9320fc
# ╟─d1294446-53c0-11ec-39da-39475fc28105
# ╟─d129446e-53c0-11ec-0387-3bd57779a3d5
# ╟─d1294496-53c0-11ec-0210-53d81144bb7e
# ╠═d1294ffe-53c0-11ec-2033-b9af47a8fd41
# ╟─d129506a-53c0-11ec-1788-fba1f4a375ee
# ╟─d12950a8-53c0-11ec-1256-75e94f8ad774
# ╟─d12950e4-53c0-11ec-18cb-4fe1b8d5342f
# ╟─d129510e-53c0-11ec-2f84-2f58cce0d722
# ╟─d1295120-53c0-11ec-24a5-a9565da00c17
# ╟─d1295140-53c0-11ec-32f0-95d84fafe08c
# ╟─d1295152-53c0-11ec-3f61-c714ac897935
# ╟─d129515c-53c0-11ec-1d8e-450b9e3d8bbc
# ╟─d1295172-53c0-11ec-2593-cb858db17773
# ╟─d129518e-53c0-11ec-096b-d72b1a72a1e8
# ╟─d12951ac-53c0-11ec-0412-0feb9677b117
# ╟─d129522e-53c0-11ec-1e92-a1f83a16c131
# ╟─d1295256-53c0-11ec-1fd9-e32bedb9d64a
# ╟─d1295e40-53c0-11ec-2b96-eb8a9c3a5bc2
# ╟─d1295eec-53c0-11ec-3727-f99c2c3fb554
# ╟─d1295f26-53c0-11ec-1f41-59c01b21acf9
# ╟─d129675c-53c0-11ec-1b18-677275f04643
# ╟─d12968a4-53c0-11ec-0f4d-91229f4f564b
# ╟─d12968e0-53c0-11ec-2a7c-af0e896a16af
# ╟─d12968fe-53c0-11ec-3229-59c2aab06c3e
# ╟─d1297222-53c0-11ec-18c2-bfa9b50c1404
# ╟─d1297240-53c0-11ec-0827-f3f0b15e60e3
# ╟─d1297254-53c0-11ec-015a-2b5d11d3e336
# ╟─d1297286-53c0-11ec-1760-7d2b3974e56e
# ╟─d12972a4-53c0-11ec-22c4-f3f53da915be
# ╟─d12972b8-53c0-11ec-126a-fff0eab44933
# ╟─d129826c-53c0-11ec-1b57-a504349a8cde
# ╟─d12982b4-53c0-11ec-13b6-affa8e54cdef
# ╟─d129911c-53c0-11ec-2c1a-bd0979fbea43
# ╟─d1299162-53c0-11ec-2f54-cf5dcf039c7c
# ╟─d129a080-53c0-11ec-0612-7562582df632
# ╟─d129a0b2-53c0-11ec-163d-256a846f7948
# ╟─d129a0e4-53c0-11ec-253e-b1950f254343
# ╟─d129a0f8-53c0-11ec-38a6-a1e7a0b24aad
# ╟─d129a9a4-53c0-11ec-0f76-f38b25121f98
# ╟─d129a9c2-53c0-11ec-1bd9-1f2502d833da
# ╟─d129a9ea-53c0-11ec-15d4-5b018051874f
# ╟─d129ad80-53c0-11ec-0405-8f7bf8154334
# ╟─d129adb2-53c0-11ec-3b8b-b562f389ae21
# ╟─d129b00c-53c0-11ec-19b1-25ec302cb65b
# ╟─d129b022-53c0-11ec-11a7-d9af4454c957
# ╟─d129b05c-53c0-11ec-2fcb-93803a828c66
# ╟─d129b07a-53c0-11ec-1c63-872366f92b22
# ╟─d129b52c-53c0-11ec-3584-2128ab11afa1
# ╟─d129b566-53c0-11ec-2c4e-8b7f83510d38
# ╟─d129b61a-53c0-11ec-1f0f-3d6e5f9b0218
# ╟─d129dc80-53c0-11ec-1533-79e91acc517d
# ╟─d129dcb2-53c0-11ec-05f2-355619ae5888
# ╟─d129dcc6-53c0-11ec-3d7f-5d063a129bc2
# ╟─d129dcfa-53c0-11ec-3b5d-6f14908b69e0
# ╟─d129e874-53c0-11ec-1809-47474e790091
# ╟─d129e8a6-53c0-11ec-3f7f-419bd7610f26
# ╟─d129f2b0-53c0-11ec-3323-6559e299afb5
# ╟─d129f2ce-53c0-11ec-2087-4b8c354f9a7d
# ╟─d129f2f6-53c0-11ec-09c8-3378184ce558
# ╟─d129f4b8-53c0-11ec-3942-0b7d7f8666c4
# ╟─d129f4cc-53c0-11ec-2539-b13403fffd1f
# ╟─d129f65c-53c0-11ec-087b-7f65644baecc
# ╟─d129f684-53c0-11ec-2fc0-9be06a16065d
# ╟─d129f81e-53c0-11ec-14c8-f96c433455fc
# ╟─d129f83c-53c0-11ec-2cc4-d1f36c365290
# ╟─d129f9c2-53c0-11ec-0bb9-dda36eade23d
# ╟─d129f9d6-53c0-11ec-2b70-7352c87f9c46
# ╟─d129f9fe-53c0-11ec-050e-035e6fbafff3
# ╟─d12a00e8-53c0-11ec-0bf1-256b5f42dbd9
# ╟─d12a00fc-53c0-11ec-3261-8f964f2bb98b
# ╟─d12a0976-53c0-11ec-1207-45c73a227691
# ╟─d12a098a-53c0-11ec-177a-b1046b062a3a
# ╟─d12a09bc-53c0-11ec-2077-1d7af978c5e7
# ╟─d12a36ce-53c0-11ec-3a0c-11340f5aa64a
# ╟─d12a372a-53c0-11ec-15de-43cfbfe92f56
# ╟─d12a37ac-53c0-11ec-0426-b55ddc6e181d
# ╟─d12a389c-53c0-11ec-3945-63553f580f70
# ╟─d12a430a-53c0-11ec-2d60-076f39b08da7
# ╟─d12a43f0-53c0-11ec-0563-3918408323b8
# ╟─d12a4648-53c0-11ec-166c-893ade3a2647
# ╟─d12a46c0-53c0-11ec-1785-43c024d32630
# ╠═d12a4af0-53c0-11ec-074a-0d0311f7c247
# ╟─d12a4b3e-53c0-11ec-0072-a131e60380da
# ╟─d12abcae-53c0-11ec-3aab-3d82b6a32ee1
# ╟─d12abe22-53c0-11ec-0946-33ba25253e94
# ╠═d12ad342-53c0-11ec-061a-3b0a9c78899a
# ╟─d12ad3da-53c0-11ec-10a2-3753a1e61002
# ╟─d12ad676-53c0-11ec-063e-ab2479afa882
# ╟─d12ad6b2-53c0-11ec-1522-dd55414e46b4
# ╟─d12ad6f8-53c0-11ec-30cf-25c3824d39be
# ╟─d12ad7f2-53c0-11ec-1509-f116862deb89
# ╟─d12ad838-53c0-11ec-0a3f-3b8a95efa2c0
# ╟─d12ad876-53c0-11ec-1c02-33c57b5c5cd5
# ╟─d12ad8d6-53c0-11ec-24e0-3d6eb41cbb52
# ╟─d12ad928-53c0-11ec-1e62-d3640618306d
# ╟─d12ad9ac-53c0-11ec-3bd2-c30827114123
# ╟─d12ada22-53c0-11ec-1c88-6bde5971d301
# ╟─d12adab0-53c0-11ec-1611-4d67293cd1db
# ╟─d12adafe-53c0-11ec-1012-f18a0e548a61
# ╟─d12adb58-53c0-11ec-1a43-a90a7e22d945
# ╟─d12adb9e-53c0-11ec-3808-8dbaf334e387
# ╟─d12adbee-53c0-11ec-280e-6f42e499cf9a
# ╟─d12adc18-53c0-11ec-36ad-b7b02f2374f5
# ╟─d12adc3e-53c0-11ec-3294-03c28a05b956
# ╟─d12adc84-53c0-11ec-2f8d-a1bd92c29e58
# ╟─d12adcaa-53c0-11ec-3e15-33d22feeaa71
# ╟─d12add1a-53c0-11ec-2ce3-65fc607d71cb
# ╟─d12add42-53c0-11ec-24d1-099b085b94de
# ╟─d12add74-53c0-11ec-2552-b5eab61e1b04
# ╟─d12add80-53c0-11ec-1577-7f0cf9354e38
# ╟─d12add92-53c0-11ec-1cc6-1bc504a95738
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
