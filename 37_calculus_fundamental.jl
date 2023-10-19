### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 7d0288f2-70d3-11ec-1974-fd8469203a9e
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
	using QuadGK
end

# ╔═╡ 7d028c44-70d3-11ec-265a-554b817ff28d
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size = (600, 400)
	nothing
end

# ╔═╡ 7d072f24-70d3-11ec-2ee5-6f6fef343cd1
using PlutoUI

# ╔═╡ 7d072f10-70d3-11ec-3e27-672bf625b6a7
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 7d0283f2-70d3-11ec-0a55-419c3107f99e
md"""# Fundamental Theorem or Calculus
"""

# ╔═╡ 7d028424-70d3-11ec-3908-17f7ca604eac
md"""This section uses these add-on packages:
"""

# ╔═╡ 7d028c76-70d3-11ec-1b1c-bfceee6689b2
md"""---
"""

# ╔═╡ 7d028cbc-70d3-11ec-2816-4d8a37b10c6b
md"""We refer to the example from the section on [transformations](../precalc/transformations.html#two_operators_D_S) where two operators on functions were defined:
"""

# ╔═╡ 7d028ce4-70d3-11ec-2723-c7ea7cbc9bb5
md"""```math
D(f)(k) = f(k) - f(k-1), \quad S(f)(k) = f(1) + f(2) + \cdots + f(k).
```
"""

# ╔═╡ 7d028d34-70d3-11ec-32c4-ad861361b0b3
md"""It was remarked that these relationships hold: $D(S(f))(k) = f(k)$ and $S(D(f))(k) = f(k) - f(0)$. These being a consequence of the inverse relationship between addition and subtraction.  These two relationships are examples of a more general pair of relationships known as the [Fundamental theorem of calculus](http://en.wikipedia.org/wiki/Fundamental_theorem_of_calculus) or FTC.
"""

# ╔═╡ 7d028d66-70d3-11ec-01fe-afbaeeaf2c2c
md"""We will see that with suitable rewriting, the derivative of a function is related to a certain limit of `D(f)` and the definite integral of a function is related to a certain limit of `S(f)`. The addition and subtraction rules encapsulated in the relations of $D(S(f))(k) = f(k)$ and $S(D(f))(k) = f(k) - f(0)$ then generalize to these calculus counterparts.
"""

# ╔═╡ 7d028d6e-70d3-11ec-03c4-ab7a6d8b4cad
md"""The FTC details the interconnectivity between the operations of integration and differentiation.
"""

# ╔═╡ 7d028d7a-70d3-11ec-3c39-51cd643282c3
md"""For example:
"""

# ╔═╡ 7d028e44-70d3-11ec-1268-ad0a6e307d64
md"""> What is the definite integral of the derivative?

"""

# ╔═╡ 7d028e60-70d3-11ec-1406-d95deadc4eeb
md"""That is, what is $A = \int_a^b f'(x) dx$? (Assume $f'$ is continuous.)
"""

# ╔═╡ 7d028e76-70d3-11ec-092d-ada9b09e6943
md"""To investigate, we begin with the right Riemann sum using $h = (b-a)/n$:
"""

# ╔═╡ 7d028e7e-70d3-11ec-2628-f9ed6548454f
md"""```math
A \approx S_n = \sum_{i=1}^n f'(a + ih) \cdot h.
```
"""

# ╔═╡ 7d028e9c-70d3-11ec-2cea-7d840a74a619
md"""But the mean value theorem says that for small $h$ we have $f'(x) \approx (f(x) - f(x-h))/h$. Using this approximation with $x=a+ih$ gives:
"""

# ╔═╡ 7d028ea8-70d3-11ec-148e-5bc39eabea16
md"""```math
A \approx
\sum_{i=1}^n \left(f(a + ih) - f(a + (i-1)h)\right).
```
"""

# ╔═╡ 7d028eba-70d3-11ec-1d74-d7c88a93fbd3
md"""If we let $g(i) = f(a + ih)$, then the summand above is just $g(i) - g(i-1) = D(g)(i)$ and the above then is just the sum of the $D(g)(i)$s, or:
"""

# ╔═╡ 7d028ec4-70d3-11ec-25b8-b7cebb926cdb
md"""```math
A \approx S(D(g))(n) = g(n) - g(0).
```
"""

# ╔═╡ 7d028ed6-70d3-11ec-33d5-37c18ffd9aa4
md"""But $g(n) - g(0) = f(a + nh) - f(a + 0h) = f(b) - f(a)$. That is, we expect that the $\approx$ in the limit becomes $=$, or:
"""

# ╔═╡ 7d028ef6-70d3-11ec-2f44-352a6595cbd9
md"""```math
\int_a^b f'(x) dx = f(b) - f(a).
```
"""

# ╔═╡ 7d028f08-70d3-11ec-3a5b-45d94b2cec8b
md"""This is indeed the case.
"""

# ╔═╡ 7d028f08-70d3-11ec-0793-533140d6165f
md"""The other question would be
"""

# ╔═╡ 7d028f46-70d3-11ec-2fbd-b511de615f3a
md"""> What is the derivative of the integral?

"""

# ╔═╡ 7d028f64-70d3-11ec-0c13-371173d7187d
md"""That is, can we find the derivative of $\int_0^x f(u) du$? (The derivative in $x$, the variable $u$ is a dummy variable of integration.)
"""

# ╔═╡ 7d028f78-70d3-11ec-1515-9bca21da305e
md"""Let's look first at the integral using the right-Riemann sum, again using $h=(b-a)/n$:
"""

# ╔═╡ 7d028f82-70d3-11ec-0809-7f79fc8cc6c8
md"""```math
\int_a^b f(u) du \approx f(a + 1h)h + f(a + 2h)h + \cdots f(a +nh)h = S(g)(n),
```
"""

# ╔═╡ 7d028fac-70d3-11ec-31e4-e183f6df3198
md"""where we define $g(i) = f(a + ih)h$. In the above, $n$ relates to $b$, but we could have stopped accumulating at any value. The analog for $S(g)(k)$ would be $\int_a^x f(u) du$ where $x = a + kh$. That is we can make a function out of integration by considering the mapping $(x, \int_a^x f(u) du)$. This might be written as $F(x) = \int_a^x f(u)du$.  With this definition, can we take a derivative in $x$?
"""

# ╔═╡ 7d028fc8-70d3-11ec-2ef2-c9c7dc0fb1d8
md"""Again, we fix a large $n$ and let $h=(b-a)/n$. And suppose $x = a + Mh$ for some $M$. Then writing out the approximations to both the definite integral and the derivative we have
"""

# ╔═╡ 7d028fde-70d3-11ec-053f-916a6103201d
md"""```math
\begin{align*}
F'(x) = & \frac{d}{dx} \int_a^x f(u) du \\
& \approx \frac{F(x) - F(x-h)}{h} = \frac{\int_a^x f(u) du - \int_a^{x-h} f(u) du}{h}\\
& \approx \frac{\left(f(a + 1h)h + f(a + 2h)h + \cdots + f(a + (M-1)h)h + f(a + Mh)h\right)}{h} -
\frac{\left(f(a + 1h)h + f(a + 2h)h + \cdots + f(a + (M-1)h)h \right)}{h} \\
& = \left(f(a + 1h) + f(a + 2h) + \cdots + f(a + (M-1)h) + f(a + Mh)\right) -
\left(f(a + 1h) + f(a + 2h) + \cdots + f(a + (M-1)h) \right)
\end{align*}
```
"""

# ╔═╡ 7d028fe6-70d3-11ec-39a1-f3fdd4c72828
md"""If $g(i) = f(a + ih)$, then the above becomes
"""

# ╔═╡ 7d028ff0-70d3-11ec-39d6-03b5d863ead0
md"""```math
\begin{align*}
F'(x) & \approx D(S(g))(M) \\
&= f(a + Mh)\\
&= f(x).
\end{align*}
```
"""

# ╔═╡ 7d029004-70d3-11ec-1746-6ba2dfc081ee
md"""That is $F'(x) \approx f(x)$.
"""

# ╔═╡ 7d02900c-70d3-11ec-19df-cfa9d5b209f6
md"""In the limit, then, we would expect that
"""

# ╔═╡ 7d029018-70d3-11ec-0963-5fc7fc396921
md"""```math
\frac{d}{dx} \int_a^x f(u) du = f(x).
```
"""

# ╔═╡ 7d029022-70d3-11ec-19bf-cf2b7ad749f3
md"""With these heuristics, we now have:
"""

# ╔═╡ 7d0290f4-70d3-11ec-040f-57827412f142
md"""> **The fundamental theorem of calculus**
>
> Part 1: Let $f$ be a continuous function on a closed interval $[a,b]$ and define $F(x) = \int_a^x f(u) du$ for $a \leq x \leq b$. Then $F$ is continuous on $[a,b]$, differentiable on $(a,b)$ and moreover, $F'(x) =f(x)$.
>
> Part 2: Now suppose $f$ is any integrable function on a closed interval $[a,b]$ and $F(x)$ is *any* differentiable function on $[a,b]$ with $F'(x) = f(x)$. Then $\int_a^b f(x)dx=F(b)-F(a)$.

"""

# ╔═╡ 7d02a652-70d3-11ec-003a-032bb91b8dc3
note(L"""

In Part 1, the integral $F(x) = \int_a^x f(u) du$ is defined for any
Riemann integrable function, $f$. If the function is not continuous,
then it is true the $F$ will be continuous, but it need not be true
that it is differentiable at all points in $(a,b)$. Forming $F$ from
$f$ is a form of *smoothing*. It makes a continuous function out of an
integrable one, a differentiable function from a continuous one, and a
$k+1$-times differentiable function from a $k$-times differentiable
one.

""")

# ╔═╡ 7d02a68e-70d3-11ec-1732-3b51ff3b3f93
md"""## Using the fundamental theorem of calculus to evaluate definite integrals
"""

# ╔═╡ 7d02a6ca-70d3-11ec-3dd8-a192a5668359
md"""The major use of the FTC is the computation of $\int_a^b f(x) dx$. Rather then resort to Riemann sums or geometric arguments, there is an alternative - *when possible*, find a function $F$ with $F'(x) = f(x)$ and compute $F(b) - F(a)$.
"""

# ╔═╡ 7d02a6d4-70d3-11ec-070e-690cd722e9a6
md"""Some examples:
"""

# ╔═╡ 7d02bfea-70d3-11ec-37ea-bdbffbfe0b23
md"""  * Consider the problem of Archimedes, $\int_0^1 x^2 dx$. Clearly, we have with $f(x) = x^2$ that $F(x)=x^3/3$ will satisfy the assumptions of the FTC, so that:
"""

# ╔═╡ 7d02c074-70d3-11ec-0ac0-7bdae6a9a7e4
md"""```math
\int_0^1 x^2 dx = F(1) - F(0) = \frac{1^3}{3} - \frac{0^3}{3} = \frac{1}{3}.
```
"""

# ╔═╡ 7d02c0f6-70d3-11ec-1194-a9b625a31bce
md"""  * More generally, we know if $n\neq-1$ that if $f(x) = x^{n}$, that
"""

# ╔═╡ 7d02c10a-70d3-11ec-1b43-9f725dee8bbe
md"""```math
F(x) = x^{n+1}/(n+1)
```
"""

# ╔═╡ 7d02c128-70d3-11ec-1f24-1fb0b9f45a61
md"""will satisfy $F'(x)=f(x)$, so that
"""

# ╔═╡ 7d02c146-70d3-11ec-1eb3-975b33ad7c31
md"""```math
\int_a^b x^n dx = \frac{b^{n+1} - a^{n+1}}{n+1}, \quad n\neq -1.
```
"""

# ╔═╡ 7d02c164-70d3-11ec-03a9-c3eaa43e5da0
md"""(Well almost! We must be careful to know that $a \cdot b > 0$, as otherwise we will encounter a place where $f(x)$ may not be integrable.)
"""

# ╔═╡ 7d02c180-70d3-11ec-3bd5-113097d85dfd
md"""We note that the above includes the case of a constant, or $n=0$.
"""

# ╔═╡ 7d02c1b2-70d3-11ec-21a7-a7056b7542f3
md"""What about the case $n=-1$, or $f(x) = 1/x$, that is not covered by the above? For this special case, it is known that $F(x) = \log(x)$ (natural log) will have $F'(x) = 1/x$. This gives for $0 < a < b$:
"""

# ╔═╡ 7d02c1be-70d3-11ec-345d-3fc026848dd2
md"""```math
\int_a^b \frac{1}{x} dx = \log(b) - \log(a).
```
"""

# ╔═╡ 7d02c20e-70d3-11ec-0176-7b03c8cff924
md"""  * Let $f(x) = \cos(x)$. How much area is between $-\pi/2$ and $\pi/2$? We have that $F(x) = \sin(x)$ will have $F'(x) = f(x)$, so:
"""

# ╔═╡ 7d02c218-70d3-11ec-2001-2d391f80ea19
md"""```math
\int_{-\pi/2}^{\pi/2} \cos(x) dx = F(\pi/2) - F(-\pi/2) = 1 - (-1) = 2.
```
"""

# ╔═╡ 7d02c25e-70d3-11ec-1290-d1360efa8334
md"""### An alternate notation for $F(b) - F(a)$
"""

# ╔═╡ 7d02c272-70d3-11ec-1162-0b9dbdfac49b
md"""The expression $F(b) - F(a)$ is often written in this more compact form:
"""

# ╔═╡ 7d02c288-70d3-11ec-1111-176f874cc9ab
md"""```math
\int_a^b f(x) dx = F(b) - F(a) = F(x)\big|_{x=a}^b, \text{ or just expr}\big|_{x=a}^b.
```
"""

# ╔═╡ 7d02c2ae-70d3-11ec-053d-a770d4d266e0
md"""The vertical bar is used for the *evaluation* step, in this case the $a$ and $b$ mirror that of the definite integral. This notation lends itself to working inline, as we illustrate with this next problem where we "know" a function "$F$", so just express it "inline":
"""

# ╔═╡ 7d02c2c2-70d3-11ec-1def-25c742a386d5
md"""```math
\int_0^{\pi/4} \sec^2(x) dx = \tan(x) \big|_{x=0}^{\pi/4} = 1 - 0 = 1.
```
"""

# ╔═╡ 7d02c2cc-70d3-11ec-0c1a-21aa66f52cf2
md"""A consequence of this notation is:
"""

# ╔═╡ 7d02c2d6-70d3-11ec-1070-b77b16fd1245
md"""```math
F(x) \big|_{x=a}^b = -F(x) \big|_{x=b}^a.
```
"""

# ╔═╡ 7d02c2f4-70d3-11ec-38ed-d9dae92a19a7
md"""This says nothing more than $F(b)-F(a) = -F(a) - (-F(b))$, though more compactly.
"""

# ╔═╡ 7d02c308-70d3-11ec-2f01-476f476143a2
md"""## The indefinite integral
"""

# ╔═╡ 7d02c33a-70d3-11ec-31e1-9792a4e81b4a
md"""A function $F(x)$ with $F'(x) = f(x)$ is known as an *antiderivative* of $f$. For a given $f$, there are infinitely many antiderivatives: if $F(x)$ is one, then so is $G(x) = F(x) + C$. But - due to the mean value theorem - all antiderivatives for $f$ differ at most by a constant.
"""

# ╔═╡ 7d02c36c-70d3-11ec-3fbb-d5b94397a2bf
md"""The **indefinite integral** of $f(x)$ is denoted by:
"""

# ╔═╡ 7d02c376-70d3-11ec-3a84-0999226f1dfb
md"""```math
\int f(x) dx.
```
"""

# ╔═╡ 7d02c394-70d3-11ec-22e0-f31497d00e45
md"""(There are no limits of integration.) There are two possible definitions: this refers to the set of *all* antiderivatives, or is just one of the set of all antiderivatives for $f$. The former gives rise to expressions such as
"""

# ╔═╡ 7d02c39e-70d3-11ec-0275-e3ee1f3cbff5
md"""```math
\int x^2 dx = \frac{x^3}{3} + C
```
"""

# ╔═╡ 7d02c3e4-70d3-11ec-22de-11ad81fa92bb
md"""where $C$ is the *constant of integration* and isn't really a fixed constant, but any possible constant. These notes will follow the lead of `SymPy` and not give a $C$ in the expression, but instead rely on the reader to understand that there could be many other possible expressions given, though all differ by no more than a constant. This means, that $\int f(x) dx$ refers to *an* antiderivative, not *the* collection of all antiderivatives.
"""

# ╔═╡ 7d02c402-70d3-11ec-0a4c-cb79e36f309a
md"""### The `integrate` function from `SymPy`
"""

# ╔═╡ 7d05c2a6-70d3-11ec-0298-51cfec063d34
md"""`SymPy` provides the `integrate` function to perform integration. There are two usages:
"""

# ╔═╡ 7d05c40e-70d3-11ec-3210-f54f0b678b94
md"""  * `integrate(ex, var)` to find an antiderivative
  * `integrate(ex, (var, a, b))` to find the definite integral. This integrates the expression in the variable `var` from `a` to `b`.
"""

# ╔═╡ 7d05c436-70d3-11ec-07f9-3fbfe036d460
md"""To illustrate, we have, this call finds an antiderivative:
"""

# ╔═╡ 7d05c9ba-70d3-11ec-1e4c-5930c3f8ae39
begin
	@syms x
	integrate(sin(x),x)
end

# ╔═╡ 7d05ca12-70d3-11ec-1c43-37a013bcd974
md"""Whereas this call computes the "area" under $f(x)$ between `a` and `b`:
"""

# ╔═╡ 7d05cdc0-70d3-11ec-186d-cbd6a6b7b270
integrate(sin(x), (x, 0, pi))

# ╔═╡ 7d05cddc-70d3-11ec-0ba4-5939763c2188
md"""As does this for a different function:
"""

# ╔═╡ 7d05d258-70d3-11ec-185c-eb4eb331ffbc
integrate(acos(1-x), (x, 0, 2))

# ╔═╡ 7d05d282-70d3-11ec-11a4-69bcc9760097
md"""Answers may depend on conditions, as here, where the case $n=-1$ breaks a pattern:
"""

# ╔═╡ 7d05d6d8-70d3-11ec-2a15-cf61affc3aa2
let
	@syms x::real n::real
	integrate(x^n, x)          # indefinite integral
end

# ╔═╡ 7d05d6ec-70d3-11ec-13c8-4d1b2a617c23
md"""Answers may depend on specific assumptions:
"""

# ╔═╡ 7d05daf2-70d3-11ec-1a1c-6d77c5941a93
let
	@syms u
	integrate(abs(u),u)
end

# ╔═╡ 7d05db10-70d3-11ec-18f1-33f99621a1e1
md"""Yet
"""

# ╔═╡ 7d05df40-70d3-11ec-3489-d70758e633d7
let
	@syms u::real
	integrate(abs(u),u)
end

# ╔═╡ 7d05df52-70d3-11ec-22c4-0385c5825c75
md"""Answers may not be available as elementary functions, but there may be special functions that have special cases.
"""

# ╔═╡ 7d05e5c4-70d3-11ec-157f-9fe44da0ab91
let
	@syms x::real
	integrate(x / sqrt(1-x^3), x)
end

# ╔═╡ 7d05e616-70d3-11ec-35f5-5f1f619c5655
md"""The different cases explored by `integrate` are after the questions.
"""

# ╔═╡ 7d05e632-70d3-11ec-1a1c-bd5b0de7c2bd
md"""## Rules of integration
"""

# ╔═╡ 7d05e648-70d3-11ec-1ecb-15937748556d
md"""There are some "rules" of integration that allow integrals to be re-expressed. These follow from the rules of derivatives.
"""

# ╔═╡ 7d05e768-70d3-11ec-3aba-055d680d86a1
md"""  * The integral of a constant times a function:
"""

# ╔═╡ 7d05e79a-70d3-11ec-01fb-87538a9146e7
md"""```math
\int c \cdot f(x) dx = c \cdot \int f(x) dx.
```
"""

# ╔═╡ 7d05e7c2-70d3-11ec-2af9-cb962416554b
md"""This follows as if $F(x)$ is an antiderivative of $f(x)$, then $[cF(x)]' = c f(x)$ by rules of derivatives.
"""

# ╔═╡ 7d05e7f4-70d3-11ec-3000-774713f9581d
md"""  * The integral of a sum of functions:
"""

# ╔═╡ 7d05e7fe-70d3-11ec-3327-9dbe6d49fa8f
md"""```math
\int (f(x) + g(x)) dx = \int f(x) dx + \int g(x) dx.
```
"""

# ╔═╡ 7d05e81c-70d3-11ec-3df0-f9284c792fa7
md"""This follows immediately as if $F(x)$ and $G(x)$ are antiderivatives of $f(x)$ and $g(x)$, then $[F(x) + G(x)]' = f(x) + g(x)$, so the right hand side will have a derivative of $f(x) + g(x)$.
"""

# ╔═╡ 7d05e830-70d3-11ec-1adc-114507efdbd8
md"""In fact, this more general form where $c$ and $d$ are constants covers both cases:
"""

# ╔═╡ 7d05e862-70d3-11ec-2995-83ebb981c3e5
md"""```math
\int (cf(x) + dg(x)) dx = c \int f(x) dx + d \int g(x) dx.
```
"""

# ╔═╡ 7d05e894-70d3-11ec-33fa-9314bbc12259
md"""This statement is nothing more than the derivative formula $[cf(x) + dg(x)]' = cf'(x) + dg'(x)$. The product rule gives rise to a technique called *integration by parts* and the chain rule gives rise to a technique of *integration by substitution*, but we defer those discussions to other sections.
"""

# ╔═╡ 7d05e8bc-70d3-11ec-3008-b539adcd8dc6
md"""##### Examples
"""

# ╔═╡ 7d05e902-70d3-11ec-0ca7-4b40921fcf22
md"""  * The antiderivative of the polynomial $p(x) = a_n x^n + \cdots a_1 x + a_0$ follows from the linearity of the integral and the general power rule:
"""

# ╔═╡ 7d05e918-70d3-11ec-27c6-75969ae7c221
md"""```math
\begin{align}
\int (a_n x^n + \cdots a_1 x + a_0) dx
&= \int a_nx^n dx + \cdots \int a_1 x dx + \int a_0 dx                   \\
&= a_n \int x^n dx + \cdots +  a_1 \int x dx + a_0 \int dx                   \\
&= a_n\frac{x^{n+1}}{n+1} + \cdots +  a_1 \frac{x^2}{2} +  a_0 \frac{x}{1}.
\end{align}
```
"""

# ╔═╡ 7d05e95c-70d3-11ec-3223-f7a4dd425f3e
md"""  * More generally, a [Laurent](https://en.wikipedia.org/wiki/Laurent_polynomial) polynomial allows for terms with negative powers. These too can be handled by the above. For example
"""

# ╔═╡ 7d05e970-70d3-11ec-30e0-7f1685838313
md"""```math
\begin{align}
\int (\frac{2}{x} + 2 + 2x) dx
&= \int \frac{2}{x} dx + \int 2 dx + \int 2x dx \\
&= 2\int \frac{1}{x} dx + 2 \int dx + 2 \int xdx\\
&= 2\log(x) + 2x + 2\frac{x^2}{2}.
\end{align}
```
"""

# ╔═╡ 7d05e998-70d3-11ec-18e4-e530dc8a56f4
md"""  * Consider this integral:
"""

# ╔═╡ 7d05e9a2-70d3-11ec-3532-8b5b6eba0b75
md"""```math
\int_0^\pi 100 \sin(x) dx = F(\pi) - F(0),
```
"""

# ╔═╡ 7d05e9b6-70d3-11ec-37d3-4d4e889b97d1
md"""where $F(x)$ is an antiderivative of $100\sin(x)$. But:
"""

# ╔═╡ 7d05e9c0-70d3-11ec-19e1-4985c74ca6e5
md"""```math
\int 100 \sin(x) dx = 100 \int \sin(x) dx = 100 (-\cos(x)).
```
"""

# ╔═╡ 7d05e9ca-70d3-11ec-1ba0-ed6f4f70c184
md"""So the answer to the question is
"""

# ╔═╡ 7d05e9d4-70d3-11ec-3c77-8dc6a65378d0
md"""```math
\int_0^\pi 100 \sin(x) dx = (100 (-\cos(\pi)))  - (100(-\cos(0))) = (100(-(-1))) - (100(-1)) = 200.
```
"""

# ╔═╡ 7d05e9e8-70d3-11ec-292c-6b1d41962408
md"""This seems like a lot of work, and indeed it is more than is needed. The following would be more typical once the rules are learned:
"""

# ╔═╡ 7d05e9f2-70d3-11ec-01cf-293b715f7718
md"""```math
\int_0^\pi 100 \sin(x) dx = -100(-\cos(x)) \big|_0^{\pi} = 100 \cos(x) \big|_{\pi}^0 = 100(1) - 100(-1) = 200.
```
"""

# ╔═╡ 7d05ea06-70d3-11ec-12f0-fdb328f959f8
md"""## The derivative of the integral
"""

# ╔═╡ 7d05ea24-70d3-11ec-1705-a938e21fc91b
md"""The relationship that $[\int_a^x f(u) du]' = f(x)$ is a bit harder to appreciate, as it doesn't help answer many ready made questions. Here we give some examples of its use.
"""

# ╔═╡ 7d05ea38-70d3-11ec-2430-cf36bea782d9
md"""First, the expression defining an antiderivative, or indefinite integral, is given in term of a definite integral:
"""

# ╔═╡ 7d05ea42-70d3-11ec-0cdf-836025fd58cf
md"""```math
F(x) = \int_a^x f(u) du.
```
"""

# ╔═╡ 7d05ea56-70d3-11ec-0038-2748ec37bd20
md"""The value of $a$ does not matter, as long as the integral is defined.
"""

# ╔═╡ 7d061e68-70d3-11ec-39e7-5b0c5509239c
let
	##{{{ftc_graph}}}
	
	function make_ftc_graph(n)
	    a, b = 2, 3
	    ts = range(0, stop=b, length=50)
	    xs = range(a, stop=b, length=8)
	    g(x) = x
	    G(x) = x^2/2
	
	    xn,xn1 = xs[n:(n+1)]
	    xbar = (xn+xn1)/2
	    rxs = collect(range(xn, stop=xn1, length=2))
	    rys = map(g, rxs)
	
	    p = plot(g, 0, b, legend=false, size=fig_size, xlim=(0,3.25), ylim=(0,5))
	    plot!(p, [xn, rxs..., xn1], [0,rys...,0], linetype=:polygon, color=:orange)
	    plot!(p, [xn1, xn1], [G(xn), G(xn1)], color=:orange, alpha = 0.25)
	    annotate!(p, collect(zip([xn1, xn1], [G(xn1)/2, G(xn1)], ["A", "A"])))
	
	    p
	end
	
	caption = L"""
	
	Illustration showing $F(x) = \int_a^x f(u) du$ is a function that
	accumulates area. The value of $A$ is the area over $[x_{n-1}, x_n]$
	and also the difference $F(x_n) - F(x_{n-1})$.
	
	"""
	
	n = 7
	
	anim = @animate for i=1:n
	    make_ftc_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7d061e9a-70d3-11ec-1140-83dd5e4ca696
md"""The picture for this, for non-negative $f$, is of accumulating area as $x$ increases. It can be used to give insight into some formulas:
"""

# ╔═╡ 7d061eb8-70d3-11ec-283c-2d98c467d3e5
md"""For any function, we know that $F(b) - F(c) + F(c) - F(a) = F(b) - F(a)$. For this specific function, this translates into this property of the integral:
"""

# ╔═╡ 7d061ecc-70d3-11ec-16ed-e98cf4905778
md"""```math
\int_a^b f(x) dx = \int_a^c f(x) dx + \int_c^b f(x) dx.
```
"""

# ╔═╡ 7d061ee0-70d3-11ec-0e44-095f039b342c
md"""Similarly, $\int_a^a f(x) dx = F(a) - F(a) = 0$ follows.
"""

# ╔═╡ 7d061ef2-70d3-11ec-2c6b-2b84bbc9f4e2
md"""To see that the value of $a$ does not matter,  consider $a_0 < a_1$. Then we have with
"""

# ╔═╡ 7d061efe-70d3-11ec-25e4-23b12e9acef0
md"""```math
F(x) = \int_{a_0}^x f(u)du, \quad G(x) = \int_{a_0}^x f(u)du,
```
"""

# ╔═╡ 7d061f1c-70d3-11ec-16cd-4bdb5f2e2cdd
md"""That $F(x) = G(x) + \int_{a_0}^{a_1} f(u) du$. The additional part may look complicated, but the point is that as far as $x$ is involved, it is a constant. Hence both $F$ and $G$ are antiderivatives if either one is.
"""

# ╔═╡ 7d061f30-70d3-11ec-18da-d96722fb1b92
md"""##### Example
"""

# ╔═╡ 7d061f44-70d3-11ec-0101-3d909a51ec6c
md"""From the familiar formula rate $\times$ time $=$ distance, we "know," for example, that a car traveling 60 miles an hour for one hour will have traveled 60 miles. This allows us to translate statements about the speed (or more generally velocity) into statements about position at a given time. If the speed is not constant, we don't have such an easy conversion.
"""

# ╔═╡ 7d061fa8-70d3-11ec-11f3-17be32fe71cb
md"""Suppose our velocity at time $t$ is $v(t)$, and always positive. We want to find the position at time $t$, $x(t)$. Let's assume $x(0) = 0$. Let $h$ be some small time step, say $h=(t - 0)/n$ for some large $n>0$. Then we can *approximate* $v(t)$ between $[ih, (i+1)h)$ by $v(ih)$.  This is a constant so the change in position over the time interval $[ih, (i+1)h)$ would simply be $v(ih) \cdot h$, and ignoring the accumulated errors, the approximate position at time $t$ would be found by adding this pieces together: $x(t) \approx v(0h)\cdot h + v(1h)\cdot h + v(2h) \cdot h + \cdots + v(nh)h$. But we recognize this (as did [Beeckman](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits/bressoud/) in 1618) as nothing more than an approximation for the Riemann sum of $v$ over the interval $[0, t]$. That is, we expect:
"""

# ╔═╡ 7d061fbc-70d3-11ec-2bf6-b1a0d80e880e
md"""```math
x(t) = \int_0^t v(u) du.
```
"""

# ╔═╡ 7d061fc8-70d3-11ec-1ab2-39d888b6e5a0
md"""Hopefully this makes sense: our position is the result of accumulating our change in position over small units of time. The old one-foot-in-front-of-another approach to walking out the door.
"""

# ╔═╡ 7d061ffa-70d3-11ec-09b5-bd0e94d318f7
md"""The above was simplified by the assumption that $x(0) = 0$. What if $x(0) = x_0$ for some non-zero value. Then the above is not exactly correct, as $\int_0^0 v(u) du = 0$. So instead, we might write this more concretely as:
"""

# ╔═╡ 7d062002-70d3-11ec-3a06-51cf31b1f947
md"""```math
x(t) = x_0 + \int_0^t v(u) du.
```
"""

# ╔═╡ 7d062016-70d3-11ec-0be0-65241ba5e1d1
md"""There is a similar relationship between velocity and acceleration, but let's think about it formally. If we know that the acceleration is the rate of change of velocity, then we have $a(t) = v'(t)$. By the FTC, then
"""

# ╔═╡ 7d062020-70d3-11ec-3ae2-b5c2024e201b
md"""```math
\int_0^t a(u) du = \int_0^t v'(t) = v(t) - v(0).
```
"""

# ╔═╡ 7d062028-70d3-11ec-28e4-8dbe71476a5e
md"""Rewriting gives a similar statement as before:
"""

# ╔═╡ 7d062034-70d3-11ec-1879-03d900969ac4
md"""```math
v(t) = v_0 + \int_0^t a(u) du.
```
"""

# ╔═╡ 7d06203e-70d3-11ec-3982-a90267db0542
md"""##### Example
"""

# ╔═╡ 7d062052-70d3-11ec-2b32-85956aaf0269
md"""In probability theory, for a positive, continuous random variable, the probability that the random value is less than $a$ is given by $P(X \leq a) = F(a) = \int_{0}^a f(x) dx$. (Positive means the integral starts at $0$, whereas in general it could be $-\infty$, a minor complication that we haven't yet  discussed.)
"""

# ╔═╡ 7d062066-70d3-11ec-1ee2-17d2ded341a7
md"""For example, the exponential distribution with rate $1$ has $f(x) = e^{-x}$. Compute $F(x)$.
"""

# ╔═╡ 7d06208c-70d3-11ec-0391-f5b2fae1531f
md"""This is just $F(x) = \int_0^x e^{-u} du = -e^{-u}\big|_0^x = 1 - e^{-x}$.
"""

# ╔═╡ 7d0620a2-70d3-11ec-32ae-977c3532a98c
md"""The "uniform" distribution on $[a,b]$ has
"""

# ╔═╡ 7d0620ac-70d3-11ec-2107-51890cc81daa
md"""```math
F(x) =
\begin{cases}
0               & x < a\\
\frac{x-a}{b-a} & a \leq x \leq b\\
1               & x > b
\end{cases}
```
"""

# ╔═╡ 7d0620ca-70d3-11ec-0cfc-bd7533e66c98
md"""Find $f(x)$. There are some subtleties here. If we assume that $F(x) = \int_0^x f(u) du$ then we know if $f(x)$ is continuous that $F'(x) = f(x)$. Differentiating we get
"""

# ╔═╡ 7d0620de-70d3-11ec-0e27-877dd1ce7a89
md"""```math
f(x) = \begin{cases}
0             & x < a\\
\frac{1}{b-a} & a < x < b\\
0             & x > b
\end{cases}
```
"""

# ╔═╡ 7d06211a-70d3-11ec-0a12-f7401e796455
md"""However, the function  $f$  is *not* continuous on $[a,b]$ and $F'(x)$ is not differentiable on $(a,b)$. It is true that $f$ is integrable, and where $F$ is differentiable $F'=f$. So $f$ is determined except possibly at the points $x=a$ and $x=b$.
"""

# ╔═╡ 7d062124-70d3-11ec-2d4c-23063ce4b9c1
md"""##### Example
"""

# ╔═╡ 7d062142-70d3-11ec-0bc9-dbb9dbbfbd84
md"""The error function is defined by $\text{erf}(x) = 2/\sqrt{\pi}\int_0^x e^{-u^2} du$. It is implemented in `Julia` through `erf`. Suppose, we were to ask where it takes on it's maximum value, what would we find?
"""

# ╔═╡ 7d062156-70d3-11ec-1993-41a0ab8a62cf
md"""The answer will either be at a critical point, at $0$ or as $x$ goes to $\infty$. We can differentiate to find critical points:
"""

# ╔═╡ 7d062162-70d3-11ec-0fa6-f597c78971d7
md"""```math
[\text{erf}(x)] = \frac{2}{\pi}e^{-x^2}.
```
"""

# ╔═╡ 7d062188-70d3-11ec-3cad-4588c2adfc4b
md"""Oh, this is never $0$, so there are no critical points. The maximum occurs at $0$ or as $x$ goes to $\infty$. Clearly at $0$, we have $\text{erf}(0)=0$, so the answer will be as $x$ goes to $\infty$.
"""

# ╔═╡ 7d06219c-70d3-11ec-0070-45844b684075
md"""In retrospect, this is a silly question. As $f(x) > 0$ for all $x$, we *must* have that $F(x)$ is strictly increasing, so never gets to a local maximum.
"""

# ╔═╡ 7d0621b0-70d3-11ec-34fc-eb9d4d9828ff
md"""##### Example
"""

# ╔═╡ 7d0621c2-70d3-11ec-00cf-3bac29f19d9f
md"""The [Dawson](http://en.wikipedia.org/wiki/Dawson_function) function is
"""

# ╔═╡ 7d0621ce-70d3-11ec-28f3-778b0547c568
md"""```math
F(x) = e^{-x^2} \int_0^x e^{t^2} dt
```
"""

# ╔═╡ 7d0621e2-70d3-11ec-247f-73e206d181f7
md"""Characterize any local maxima or minima.
"""

# ╔═╡ 7d0621f4-70d3-11ec-37fc-657b797c945a
md"""For this we need to consider the product rule. The fundamental theorem of calculus will help with the right-hand side. We have:
"""

# ╔═╡ 7d06220a-70d3-11ec-2cf8-c3161a8d8958
md"""```math
F'(x) = (-2x)e^{-x^2} \int_0^x e^{t^2} dt + e^{-x^2} e^{x^2} = -2x F(x) + 1
```
"""

# ╔═╡ 7d062214-70d3-11ec-0c27-110763934ab5
md"""We need to figure out when this is $0$. For that, we use some numeric math.
"""

# ╔═╡ 7d062a70-70d3-11ec-3380-4bf90060530f
begin
	F(x) = exp(-x^2) * quadgk(t -> exp(t^2), 0, x)[1]
	Fp(x) = -2x*F(x) + 1
	cps = find_zeros(Fp, -4,4)
end

# ╔═╡ 7d062a98-70d3-11ec-0f88-69b8510ac714
md"""We could take a second derivative to characterize. For that we use $F''(x) = [-2xF(x) + 1]' = -2F(x) + -2x(-2xF(x) + 1)$, so
"""

# ╔═╡ 7d06317a-70d3-11ec-1bcc-83cc3cd216db
begin
	Fpp(x) = -2F(x) + 4x^2*F(x) - 2x
	Fpp.(cps)
end

# ╔═╡ 7d0631a0-70d3-11ec-0b6d-0d16f0aa0999
md"""The first value being positive says there is a relative minimum at $-0.924139$, at $0.924139$ there is a relative maximum.
"""

# ╔═╡ 7d0631b4-70d3-11ec-30f7-07767018dc84
md"""##### Example
"""

# ╔═╡ 7d0631f0-70d3-11ec-3181-db0144dc5e91
md"""Returning to probability, suppose there are $n$ positive random numbers $X_1$, $X_2$, ..., $X_n$. A natural question might be to ask what formulas describes the largest of these values, assuming each is identical in some way. A description that is helpful is to define $F(a) = P(X \leq a)$ for some random number $X$. That is the probability that $X$ is less than or equal to $a$ is $F(a)$. For many situations, there is a *density* function, $f$, for which $F(a) = \int_0^a f(x) dx$.
"""

# ╔═╡ 7d06320c-70d3-11ec-2e1f-0ba196342965
md"""Under assumptions that the $X$ are identical and independent, the largest value, $M$, may b characterized by $P(M \leq a) = \left[F(a)\right]^n$. Using $f$ and $F$ describe the derivative of this expression.
"""

# ╔═╡ 7d063268-70d3-11ec-20f2-f3d41c2b5882
md"""This problem is constructed to take advantage of the FTC, and we have:
"""

# ╔═╡ 7d063286-70d3-11ec-3783-c366fbe28083
md"""```math
\begin{align*}
\left[P(M \leq a)\right]'
&= \left[F(a)^n\right]'\\
&= n \cdot F(a)^{n-1} \left[F(a)\right]'\\
&= n F(a)^{n-1}f(a)
\end{align*}
```
"""

# ╔═╡ 7d06329a-70d3-11ec-16c3-773cea607ea4
md"""##### Example
"""

# ╔═╡ 7d0632e2-70d3-11ec-32f6-2bde0b8fdaeb
md"""Suppose again probabilities of a random number between $0$ and $1$, say, are given by a positive, continuous function $f(x)$on $(0,1)$ by $F(a) = P(X \leq a) = \int_0^a f(x) dx$. The median value of the random number is a value of $a$ for which $P(X \leq a) = 1/2$. Such an $a$ makes $X$ a coin toss – betting if $X$ is less than $a$ is like betting on heads to come up. More generally the $q$th quantile of $X$ is a number $a$ with $P(X \leq a) = q$. The definition is fine, but for a given $f$ and $q$ can we find $a$?
"""

# ╔═╡ 7d063314-70d3-11ec-343f-ab882a52c4b7
md"""Abstractly, we are solving $F(a) = q$ or $F(a)-q = 0$ for $a$. That is, this is a zero-finding question. We have discussed different options for this problem: bisection, a range of derivative free methods, and Newton's method. As evaluating $F$ involves an integral, which may involve many evaluations of $f$, a method which converges quickly is preferred. For that, Newton's method is a good idea, it having quadratic convergence in this case, as $a$ is a simple zero given that $F$ is increasing under the assumptions above.
"""

# ╔═╡ 7d063330-70d3-11ec-0977-d7174c57051a
md"""Newton's method involves the update step `x = x - f(x)/f'(x)`. For this "$f$" is $h(x) = \int_0^x f(u) du - q$. The derivative is easy, the FTC just applies: $h'(x) = f(x)$; no need for automatic differentiation, which may not even apply to this setup.
"""

# ╔═╡ 7d063358-70d3-11ec-1b73-97a1f80c7848
md"""To do a concrete example, we take the [Beta](https://en.wikipedia.org/wiki/Beta_distribution)($\alpha, \beta$) distribution ($\alpha, \beta > 0$)  which has density, $f$, over $[0,1]$ given by
"""

# ╔═╡ 7d063362-70d3-11ec-3bad-e70543f7839c
md"""```math
f(x) = x^{\alpha-1}\cdot (1-x)^{\beta-1} \cdot \frac{\Gamma(\alpha+\beta)}{\Gamma(\alpha)\Gamma(\beta)}
```
"""

# ╔═╡ 7d06338a-70d3-11ec-3d1a-6f40fd6f867b
md"""The Wikipedia link above gives an approximate answer for the median of $(\alpha-1/3)/(\alpha+\beta-2/3)$ when $\alpha,\beta > 1$. Let's see how correct this is when $\alpha=5$ and $\beta=6$. The `gamma` function used below implements $\Gamma$. It is in the `SpecialFunctions` package, which is loaded with the `CalculusWithJulia` package.
"""

# ╔═╡ 7d0637fe-70d3-11ec-160a-11ac1e4bd759
begin
	alpha, beta = 5,6
	f(x) = x^(alpha-1)*(1-x)^(beta-1) * gamma(alpha + beta) / (gamma(alpha) * gamma(beta))
	q = 1/2
	h(x) = first(quadgk(f, 0, x)) - q
	hp(x) =  f(x)
	
	x0 = (alpha-1/3)/(alpha + beta - 2/3)
	xstar = find_zero((h, hp), x0, Roots.Newton())
	
	xstar, x0
end

# ╔═╡ 7d063812-70d3-11ec-13cd-db7dd88b5c61
md"""The asymptotic answer agrees with the answer in the first four decimal places.
"""

# ╔═╡ 7d063830-70d3-11ec-0b6f-3fbcef45d958
md"""As an aside, we ask how many function evaluations were taken? We can track this with a trick - using a closure to record when $f$ is called:
"""

# ╔═╡ 7d063db2-70d3-11ec-08e9-ade87a42d81e
function FnWrapper(f)
    ctr = 0
    function(x)
        ctr += 1
        f(x)
    end
end

# ╔═╡ 7d063dda-70d3-11ec-2bde-f7424dbe52b1
md"""Then we have the above using `FnWrapper(f)` in place of `f`:
"""

# ╔═╡ 7d064184-70d3-11ec-04d9-db337a8a3393
let
	ff = FnWrapper(f)
	F(x) = first(quadgk(ff, 0, x))
	h(x) = F(x) - q
	hp(x) =  ff(x)
	xstar = find_zero((h, hp), x0, Roots.Newton())
	xstar, ff.ctr
end

# ╔═╡ 7d0641a4-70d3-11ec-1484-5578283ace34
md"""So the answer is the same. Newton's method converged in 3 steps, and called `h` or `hp` 5 times.
"""

# ╔═╡ 7d0641cc-70d3-11ec-336f-afe51495c03d
md"""Assuming the number inside `Core.Box` is the value of `ctr`, we see not so many function calls, just $48$.
"""

# ╔═╡ 7d0641ea-70d3-11ec-3eb9-4fc06f1141ba
md"""Were `f` very expensive to compute or `h` expensive to compute (which can happen if, say, `f` were highly oscillatory) then steps could be made to cut this number down, such as evaluating $F(x_n) = \int_{x_0}^{x_n} f(x) dx$, using linearity, as $\int_0^{x_0} f(x) dx + \int_{x_0}^{x_1}f(x)dx + \int_{x_1}^{x_2}f(x)dx + \cdots + \int_{x_{n-1}}^{x_n}f(x)dx$. Then all but the last term could be stored from the previous steps of Newton's method. The last term presumably being less costly as it would typically involve a small interval.
"""

# ╔═╡ 7d065086-70d3-11ec-0cbb-c77fbe7e2af4
note("""
The trick using a closure relies on an internal way of accessing elements in a closure. The same trick could be implemented many different ways which aren't reliant on undocumented internals, this approach was just a tad more convenient. It shouldn't be copied for work intended for distribution, as the internals may change without notice or deprecation.
""")

# ╔═╡ 7d0650a4-70d3-11ec-2e05-911e019dc146
md"""##### Example
"""

# ╔═╡ 7d0650cc-70d3-11ec-12e1-9b26bbae0c67
md"""A junior engineer at `Treadmillz.com` is tasked with updating the display of calories burned for an older-model treadmill. The old display involved a sequence of LED "dots" that updated each minute. The last 10 minutes were displayed. Each dot corresponded to one calorie burned, so the total number of calories burned in the past 10 minutes was the number of dots displayed, or the sum of each column of dots. An example might be:
"""

# ╔═╡ 7d0650f4-70d3-11ec-2fce-496ca1387737
md"""```
  **
  ****
  *****
 ********
**********
```"""

# ╔═╡ 7d06511c-70d3-11ec-3eab-7363df28f02a
md"""In this example display there was 1 calorie burned in the first minute, then 2, then 5, 5, 4, 3, 2, 2, 1. The total is $24$.
"""

# ╔═╡ 7d065126-70d3-11ec-3394-1f87129dc833
md"""In her work the junior engineer found this old function for updating the display
"""

# ╔═╡ 7d06513c-70d3-11ec-2ed1-7f3896d6adb3
md"""```
function cnew = update(Cnew, Cold)
  cnew = Cnew - Cold
end
```"""

# ╔═╡ 7d065176-70d3-11ec-170a-697f73fd64cb
md"""She discovered that the function was written awhile ago, and in MATLAB. The function receives the values `Cnew` and `Cold` which indicate the *total* number of calories burned up until that time frame. The value `cnew` is the number of calories burned in the minute. (Some other engineer has cleverly figured out how many calories have been burned during the time on the machine.)
"""

# ╔═╡ 7d06518a-70d3-11ec-33df-216514863411
md"""The new display will have twice as many dots, so the display can be updated every 30 seconds and still display 10 minutes worth of data. What should the `update` function now look like?
"""

# ╔═╡ 7d06519c-70d3-11ec-3ccc-0bce137e745f
md"""Her first attempt was simply to rewrite the function in `Julia`:
"""

# ╔═╡ 7d06554a-70d3-11ec-37e1-0de04b4e1de8
function update₁(Cnew, Cold)
  cnew = Cnew - Cold
end

# ╔═╡ 7d065568-70d3-11ec-36be-7b1339d07d43
md"""This has the advantage that each "dot" still represents a calorie burned, so that a user can still count the dots to see the total burned in the past 10 minutes.
"""

# ╔═╡ 7d065590-70d3-11ec-2921-c9e75e956149
md"""```
     * *
    ****** *
 ************* *
```"""

# ╔═╡ 7d0655ae-70d3-11ec-2fc3-ad13a95f2ae4
md"""Sadly though, users didn't like it. Instead of a set of dots being, say, 5 high, they were now 3 high and 2 high. It "looked" like they were doing less work! What to do?
"""

# ╔═╡ 7d0655d4-70d3-11ec-0e95-3776e50166a9
md"""The users actually were not responding to the number of dots, which hadn't changed, but rather the *area* that they represented - and this shrank in half. (It is much easier to visualize area than count dots when tired.) How to adjust for that?
"""

# ╔═╡ 7d0655ea-70d3-11ec-22bb-2b7fc7ad6b01
md"""Well our engineer knew - double the dots and count each as half a calorie. This makes the "area" constant.  She also generalized letting `n` be the number of updates per minute, in anticipation of even further improvements in the display technology:
"""

# ╔═╡ 7d065996-70d3-11ec-29ab-ed12c12c3bee
function update(Cnew, Cold, n)
   cnew = (Cnew - Cold) * n
end

# ╔═╡ 7d0659ac-70d3-11ec-2253-b36f9b2810d4
md"""Then the "area" represented by the dots stays fixed over this time frame.
"""

# ╔═╡ 7d0659da-70d3-11ec-300b-377b825b5737
md"""The engineer then thought a bit more, as the form of her answer seemed familiar. She decides to parameterize it in terms of $t$ and found with $h=1/n$: `c(t) = (C(t) - C(t-h))/h`. Ahh - the derivative approximation. But then what is the "area"? It is no longer just the sum of the dots, but in terms of the functions she finds that each column represents $c(t)\cdot h$, and the sum is just $c(t_1)h + c(t_2)h + \cdots c(t_n)h$ which looks like an approximate integral.
"""

# ╔═╡ 7d0659fa-70d3-11ec-270a-fd0b6b747bac
md"""If the display were to reach the modern age and replace LED "dots" with a higher-pixel display, then the function to display would be $c(t) = C'(t)$ and the area displayed would be $\int_{t-10}^t c(u) du$.
"""

# ╔═╡ 7d065a22-70d3-11ec-0ffb-5f5853f8c611
md"""Thinking a bit harder, she knows that her `update` function is getting $C(t)$, and displaying the *rate* of calorie burn leads to the area displayed being interpretable as the total calories burned between $t$ and $t-10$ (or $C(t)-C(t-10)$) by the fundamental theorem of calculus.
"""

# ╔═╡ 7d065a3e-70d3-11ec-35f5-eb71b7db39b5
md"""## Questions
"""

# ╔═╡ 7d065a72-70d3-11ec-3de6-437aa06eeb26
md"""###### Question
"""

# ╔═╡ 7d065a86-70d3-11ec-21aa-6dc482e89c7c
md"""If $F(x) = e^{x^2}$ is an antiderivative for $f$, find $\int_0^2 f(x) dx$.
"""

# ╔═╡ 7d065f0e-70d3-11ec-194f-f1b992ed59d2
let
	F(x) = exp(x^2)
	val = F(2) - F(0)
	numericq(val)
end

# ╔═╡ 7d065f22-70d3-11ec-1c79-f504741f2e31
md"""###### Question
"""

# ╔═╡ 7d065f40-70d3-11ec-2f52-6fe6205db977
md"""If $\sin(x) - x\cos(x)$ is an antiderivative for $x\sin(x)$, find the following integral $\int_0^\pi x\sin(x) dx$.
"""

# ╔═╡ 7d0664e0-70d3-11ec-3811-b34a336b8954
let
	F(x) = sin(x) - x*cos(x)
	a, b= 0, pi
	val = F(b) - F(a)
	numericq(val)
end

# ╔═╡ 7d06651a-70d3-11ec-0d20-4d4b13c649eb
md"""###### Question
"""

# ╔═╡ 7d06653a-70d3-11ec-3a55-0b84781b3013
md"""Find an antiderivative then evaluate $\int_0^1 x(1-x) dx$.
"""

# ╔═╡ 7d066a28-70d3-11ec-1267-c5336e97f410
let
	f(x) = x*(1-x)
	a,b = 0, 1
	F(x) = x^2/2 - x^3/3
	val = F(b) - F(a)
	numericq(val)
end

# ╔═╡ 7d066a3a-70d3-11ec-2eea-8d0b8d936300
md"""###### Question
"""

# ╔═╡ 7d066a62-70d3-11ec-0a80-711ab87cde0a
md"""Use the fact that $[e^x]' = e^x$ to evaluate $\int_0^e (e^x - 1) dx$.
"""

# ╔═╡ 7d066e9a-70d3-11ec-2b22-d9c66939ec85
let
	f(x) = exp(x) - 1
	a, b = 0, exp(1)
	F(x) = exp(x) - x
	val = F(b) - F(a)
	numericq(val)
end

# ╔═╡ 7d066eb8-70d3-11ec-2644-a9a8b9b1eee5
md"""###### Question
"""

# ╔═╡ 7d066ecc-70d3-11ec-1027-0bef9dc346f9
md"""Find the value of $\int_0^1 (1-x^2/2 + x^4/24) dx$.
"""

# ╔═╡ 7d0675a2-70d3-11ec-21ab-a1c23c827959
let
	f(x) = 1 - x^2/2 + x^4/24
	a, b = 0, 1
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ 7d0675ca-70d3-11ec-0a6f-639a24cdb7ed
md"""###### Question
"""

# ╔═╡ 7d0675f2-70d3-11ec-3018-8f77df6f63de
md"""Using `SymPy`, what is an antiderivative for $x^2 \sin(x)$?
"""

# ╔═╡ 7d067ed8-70d3-11ec-2e05-5d812df6b878
let
	choices = [
	"``-x^2\\cos(x)``",
	"``-x^2\\cos(x) + 2x\\sin(x)``",
	"``-x^2\\cos(x) + 2x\\sin(x) + 2\\cos(x)``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d067eee-70d3-11ec-053b-636644b6dd28
md"""###### Question
"""

# ╔═╡ 7d067f16-70d3-11ec-2492-03dce316388f
md"""Using `SymPy`, what is an antiderivative for $xe^{-x}$?
"""

# ╔═╡ 7d068862-70d3-11ec-2743-e9e60a556c05
let
	choices = [
	"``-e^{-x}``",
	"``-xe^{-x}``",
	"``-(1+x) e^{-x}``",
	"``-(1 + x + x^2) e^{-x}``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06887e-70d3-11ec-3196-b75daa499635
md"""###### Question
"""

# ╔═╡ 7d06889e-70d3-11ec-0ee1-bbbe82c9118b
md"""Using `SymPy`, integrate the function $\int_0^{2\pi} e^x \cdot \sin(x) dx$.
"""

# ╔═╡ 7d068c7c-70d3-11ec-3e79-671dcbce1809
let
	@syms x
	val = N(integrate(exp(x) * sin(x), (x, 0, 2pi)))
	numericq(val)
end

# ╔═╡ 7d068c90-70d3-11ec-17b3-15c2e3e8da4f
md"""###### Question
"""

# ╔═╡ 7d068cb6-70d3-11ec-15db-b17a03d4bf92
md"""A particle has velocity $v(t) = 2t^2 - t$ between $0$ and $1$. If $x(0) = 0$, find the position $x(1)$.
"""

# ╔═╡ 7d069168-70d3-11ec-2fcb-a59d3ebc4e99
let
	v(t) = 2t^2 - t
	f(x) = quadgk(v, 0, x)[1] - 0
	numericq(f(1))
end

# ╔═╡ 7d06917c-70d3-11ec-3440-a33705e5d0bd
md"""###### Question
"""

# ╔═╡ 7d0691b8-70d3-11ec-01d8-f121910c7a9a
md"""A particle has acceleration given by $\sin(t)$ between $0$ and $\pi$. If the initial velocity is $v(0) = 0$, find $v(\pi/2)$.
"""

# ╔═╡ 7d06969a-70d3-11ec-3e68-4b0265c3af8a
let
	f(x) = quadgk(sin, 0, x)[1] - 0
	numericq(f(pi/2))
end

# ╔═╡ 7d0696ae-70d3-11ec-190f-dfcb294774f8
md"""###### Question
"""

# ╔═╡ 7d0696d6-70d3-11ec-2688-5515ca4681d9
md"""The position of a particle is given by $x(t) = \int_0^t g(u) du$, where $x(0)=0$ and $g(u)$ is given by this piecewise linear graph:
"""

# ╔═╡ 7d06a392-70d3-11ec-30bb-ad005e705445
let
	function g1(x)
	  if x < 2
	    -1 + x
	  elseif 2 < x < 3
	    1
	  else
	    1 + (1/2)*(x-3)
	  end
	  end
	plot(g1, 0, 5)
end

# ╔═╡ 7d06a41e-70d3-11ec-1d63-1b86fc53e73a
md"""  * The velocity of the particle is positive over:
"""

# ╔═╡ 7d06ad10-70d3-11ec-37dd-d9f9af9d04c7
let
	choices = [
	"It is always positive",
	"It is always negative",
	L"Between $0$ and $1$",
	L"Between $1$ and $5$"
	]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06ad74-70d3-11ec-1023-0d183519164b
md"""  * The position of the particle is $0$ at $t=0$ and:
"""

# ╔═╡ 7d06b3c0-70d3-11ec-2ac8-d55b989eb42f
let
	choices = [
	"``t=1``",
	"``t=2``",
	"``t=3``",
	"``t=4``"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06b40e-70d3-11ec-232d-6337c0bd402c
md"""  * The position of the particle at time $t=5$ is?
"""

# ╔═╡ 7d06b74c-70d3-11ec-07a0-c5e18d52f423
let
	val = 4
	numericq(val)
end

# ╔═╡ 7d06b792-70d3-11ec-343e-9dff5ef4b128
md"""  * On the interval $[2,3]$:
"""

# ╔═╡ 7d06c2fa-70d3-11ec-1f1b-85283c0257df
let
	choices = [
	L"The position, $x(t)$, stays constant",
	L"The position, $x(t)$, increases with a slope of $1$",
	L"The position, $x(t)$, increases quadratically from $-1/2$ to $1$",
	L"The position, $x(t)$, increases quadratically from $0$ to $1$"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06c318-70d3-11ec-2fb8-4f8d5795e155
md"""###### Question
"""

# ╔═╡ 7d06c372-70d3-11ec-376c-03e6679ac374
md"""Let $F(x) = \int_{t-10}^t f(u) du$ for $f(u)$ a positive, continuous function. What is $F'(t)$?
"""

# ╔═╡ 7d06c980-70d3-11ec-30d9-75a313d77dc5
let
	choices = [
	"``f(t)``",
	"``-f(t-10)``",
	"``f(t) - f(t-10)``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06c99e-70d3-11ec-262a-c3e97be218e1
md"""###### Question
"""

# ╔═╡ 7d06c9c6-70d3-11ec-2c9e-fb059adbfbc8
md"""Suppose $f(x) \geq 0$ and $F(x) = \int_0^x f(u) du$. $F(x)$ is continuous and so has a maximum value on the interval $[0,1]$ taken at some $c$ in $[0,1]$. It is
"""

# ╔═╡ 7d06d07e-70d3-11ec-359a-09ae3cd44ab6
let
	choices = [
	"At a critical point",
	L"At the endpoint $0$",
	L"At the endpoint $1$"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06d09c-70d3-11ec-31ec-975801d48029
md"""###### Question
"""

# ╔═╡ 7d06d0e4-70d3-11ec-2374-711ff6eeff62
md"""Let $F(x) = \int_0^x f(u) du$, where $f(x)$ is given by the graph below. Identify the $x$ values of all *relative maxima* of $F(x)$. Explain why you know these are the values.
"""

# ╔═╡ 7d06d66e-70d3-11ec-2d5c-27fd4e21bccc
let
	xs = [0,1,2,3,4,5,6,7,8,9,10]
	ys = [-1,0,1,0,-1,0,1/2, 0, 1/2, 0, -1]
	plot(xs, ys , linewidth=3, legend=false, xticks=0:10)
end

# ╔═╡ 7d06e4e2-70d3-11ec-1b8f-8b35d8c81817
let
	choices = [
	"The derivative of ``F`` is ``f``, so by the first derivative test, ``x=1,5``",
	"The derivative of ``F`` is ``f``, so by the first derivative test, ``x=3, 9``",
	"The derivative of ``F`` is ``f``, so by the second derivative test, ``x=7``",
	"The graph of ``f`` has relative maxima at ``x=2,6,8``"
	]
	answer = 2
	radioq(choices, answer)
end

# ╔═╡ 7d06e4f6-70d3-11ec-34ae-e1c5af4d96ca
md"""###### Question
"""

# ╔═╡ 7d06e546-70d3-11ec-21b9-05c4b9d5137d
md"""Suppose $f(x)$ is monotonically decreasing with $f(0)=1$, $f(1/2) = 0$ and $f(1) = -1$. Let $F(x) = \int_0^x f(u) du$. $F(x)$ is continuous and so has a maximum value on the interval $[0,1]$ taken at some $c$ in $[0,1]$. It is
"""

# ╔═╡ 7d06ed84-70d3-11ec-3f50-75bda6275f6f
let
	choices = [
	L"At a critical point, either $0$ or $1$",
	L"At a critical point, $1/2$",
	L"At the endpoint $0$",
	L"At the endpoint $1$"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06ed98-70d3-11ec-3a25-274732df2ddb
md"""###### Question
"""

# ╔═╡ 7d06edca-70d3-11ec-1bf2-61401407d50f
md"""Barrow presented a version of the fundamental theorem of calculus in a 1670 volume edited by Newton, Barrow's student (cf. [Wagner](http://www.maa.org/sites/default/files/0746834234133.di020795.02p0640b.pdf)). His version can be stated as follows (cf. [Jardine](http://www.maa.org/publications/ebooks/mathematical-time-capsules)):
"""

# ╔═╡ 7d06ee10-70d3-11ec-2657-ad4162909028
md"""Consider the following figure where $f$ is a strictly increasing function with $f(0) = 0$. and $x > 0$. The function $A(x) = \int_0^x f(u) du$ is also plotted. The point $Q$ is $f(x)$, and the point $P$ is $A(x)$. The point $T$ is chosen to so that the length between $T$ and $x$ times the length between $Q$ and $x$ equals the length from $P$ to $x$. ($\lvert Tx \rvert \cdot \lvert Qx \rvert = \lvert Px \rvert$.) Barrow showed that the line segment $PT$ is tangent to the graph of $A(x)$. This figure illustrates the labeling for some function:
"""

# ╔═╡ 7d06f344-70d3-11ec-1a45-81b2efaf21e1
let
	f(x) = x^(2/3)
	x = 2
	A(x) = quadgk(f, 0, x)[1]
	m=f(x)
	T = x - A(x)/f(x)
	Q = f(x)
	P = A(x)
	secpt = u -> 0 + P/(x-T) * (u-T)
	xs = range(0, stop=x+1/4, length=50
	)
	p = plot(f, 0, x + 1/4, legend=false)
	plot!(p, A, 0, x + 1/4, color=:red)
	scatter!(p, [T, x, x, x], [0, 0, Q, P], color=:orange)
	annotate!(p, collect(zip([T, x, x+.1, x+.1], [0-.15, 0-.15, Q-.1, P], ["T", "x", "Q", "P"])))
	plot!(p,  [T-1/4, x+1/4], map(secpt, [T-1/4, x + 1/4]), color=:orange)
	plot!(p, [T, x, x], [0, 0, P], color=:green)
	
	p
end

# ╔═╡ 7d06f372-70d3-11ec-3eae-bb60f7962acd
md"""The fact that $\lvert Tx \rvert \cdot \lvert Qx \rvert = \lvert Px \rvert$ says what in terms of $f(x)$, $A(x)$ and $A'(x)$?
"""

# ╔═╡ 7d06fb94-70d3-11ec-2989-856c66f9430b
let
	choices = [
	"``\\lvert Tx \\rvert \\cdot f(x) = A(x)``",
	"``A(x) / \\lvert Tx \\rvert = A'(x)``",
	"``A(x) \\cdot A'(x) = f(x)``"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d06fbc6-70d3-11ec-020b-e172815ab08e
md"""The fact that $\lvert PT \rvert$ is tangent says what in terms of $f(x)$, $A(x)$ and $A'(x)$?
"""

# ╔═╡ 7d070420-70d3-11ec-3427-fd88c7ebadd4
let
	choices = [
	"``\\lvert Tx \\rvert \\cdot f(x) = A(x)``",
	"``A(x) / \\lvert Tx \\rvert = A'(x)``",
	"``A(x) \\cdot A'(x) = f(x)``"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d070436-70d3-11ec-0194-adc84c79e3c2
md"""Solving, we get:
"""

# ╔═╡ 7d070bd4-70d3-11ec-1d6e-4d7a475b7e70
let
	choices = [
	"``A'(x) = f(x)``",
	"``A(x) = A^2(x) / f(x)``",
	"``A'(x) = A(x)``",
	"``A(x) = f(x)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 7d070be8-70d3-11ec-1992-d12cf4236899
md"""###### Question
"""

# ╔═╡ 7d070c10-70d3-11ec-0ef5-a9100723c264
md"""According to [Bressoud](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits/bressoud/) "Newton observes that the rate of change of an accumulated quantity is the rate at which that quantity is accumulating". Which part of the FTC does this refer to:
"""

# ╔═╡ 7d071278-70d3-11ec-1a7d-f9a54dca1a93
let
	choices = [
	L"Part 1: $[\int_a^x f(u) du]' = f$",
	L"Part 2: $\int_a^b f(u) du = F(b)- F(a)$."]
	ans=1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7d0712aa-70d3-11ec-3443-ad7b4af9240f
md"""## More on SymPy's `integrate`
"""

# ╔═╡ 7d0712e6-70d3-11ec-0a08-7d3020686f49
md"""Finding the value of a definite integral through the fundamental theorem of calculus relies on the algebraic identification of an antiderivative. This is difficult to do by hand and by computer, and is complicated by the fact that not every [elementary ](https://en.wikipedia.org/wiki/Elementary_function)function has an elementary antiderivative. `SymPy`'s documentation on integration indicates that several different means to integrate a function are used internally. As it is of interest here, it is copied with just minor edits below:
"""

# ╔═╡ 7d071340-70d3-11ec-3e50-d70a2005647c
md"""#### Simple heuristics (based on pattern matching and integral table):
"""

# ╔═╡ 7d071386-70d3-11ec-0ea9-69b3e63ebd0e
md"""  * most frequently used functions (e.g. polynomials, products of trigonemetric functions)
"""

# ╔═╡ 7d07139a-70d3-11ec-2128-c315f136d3d9
md"""#### Integration of rational functions:
"""

# ╔═╡ 7d071412-70d3-11ec-3708-01c1ea7c3858
md"""  * A complete algorithm for integrating rational functions is        implemented (the Lazard-Rioboo-Trager algorithm).  The        algorithm also uses the partial fraction decomposition        algorithm implemented in `apart` as a preprocessor to make        this process faster.  Note that the integral of a rational        function is always elementary, but in general, it may include        a `RootSum`.
"""

# ╔═╡ 7d07141c-70d3-11ec-0b32-11b987329c53
md"""#### Full Risch algorithm:
"""

# ╔═╡ 7d072cb8-70d3-11ec-2e43-8bd519000a95
md"""  * The Risch algorithm is a complete decision procedure for integrating        elementary functions, which means that given any elementary        function, it will either compute an elementary        antiderivative, or else prove that none exists.  Currently,        part of transcendental case is implemented, meaning        elementary integrals containing exponentials, logarithms, and        (soon!) trigonometric functions can be computed.  The        algebraic case, e.g., functions containing roots, is much        more difficult and is not implemented yet.
  * If the routine fails (because the integrand is not elementary, or        because a case is not implemented yet), it continues on to        the next algorithms below.  If the routine proves that the        integrals is nonelementary, it still moves on to the        algorithms below, because we might be able to find a        closed-form solution in terms of special functions.  If        `risch=true`, however, it will stop here.
"""

# ╔═╡ 7d072ce0-70d3-11ec-18e6-ab8a2f87bd8a
md"""#### The Meijer G-Function algorithm:
"""

# ╔═╡ 7d072dc6-70d3-11ec-3751-1d2482b5513f
md"""  * This algorithm works by first rewriting the integrand in terms of        very general Meijer G-Function (`meijerg` in `SymPy`),        integrating it, and then rewriting the result back, if        possible.  This algorithm is particularly powerful for        definite integrals (which is actually part of a different        method of Integral), since it can compute closed-form        solutions of definite integrals even when no closed-form        indefinite integral exists.  But it also is capable of        computing many indefinite integrals as well.
  * Another advantage of this method is that it can use some results        about the Meijer G-Function to give a result in terms of a        Piecewise expression, which allows to express conditionally        convergent integrals.
  * Setting `meijerg=true` will cause `integrate` to use only this        method.
"""

# ╔═╡ 7d072dd0-70d3-11ec-3c63-8b208b3cbab2
md"""#### The "manual integration" algorithm:
"""

# ╔═╡ 7d072e66-70d3-11ec-357e-d1d6a6e6a2da
md"""  * This algorithm tries to mimic how a person would find an        antiderivative by hand, for example by looking for a        substitution or applying integration by parts. This algorithm        does not handle as many integrands but can return results in a        more familiar form.
  * Sometimes this algorithm can evaluate parts of an integral; in        this case `integrate` will try to evaluate the rest of the        integrand using the other methods here.
  * Setting `manual=true` will cause `integrate` to use only this        method.
"""

# ╔═╡ 7d072e7a-70d3-11ec-129a-cf447cd1bc24
md"""#### The Heuristic Risch algorithm:
"""

# ╔═╡ 7d072f06-70d3-11ec-2e63-1bb63265e83f
md"""  * This is a heuristic version of the Risch algorithm, meaning that        it is not deterministic.  This is tried as a last resort because        it can be very slow.  It is still used because not enough of the        full Risch algorithm is implemented, so that there are still some        integrals that can only be computed using this method.  The goal        is to implement enough of the Risch and Meijer G-function methods        so that this can be deleted.        Setting `heurisch=true` will cause `integrate` to use only this        method. Set `heurisch=false  to not use it.
"""

# ╔═╡ 7d072f24-70d3-11ec-03b4-3f0cac090fce
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/area.html">◅ previous</a>  <a href="../integrals/substitution.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/ftc.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 7d072f30-70d3-11ec-2a95-993eefc0da07
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.13"
Plots = "~1.25.4"
PlutoUI = "~0.7.29"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
Roots = "~1.3.14"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "1ee88c4c76caa995a885dc2f22a5d548dfbbc0ba"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.2"

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
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "ae958b53cc06c6b3d5d5b0847a3d858075136417"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.13"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "926870acb6cbcf029396f2f2de030282b6bc1941"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.4"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

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
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

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

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

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
git-tree-sha1 = "9bc5dac3c8b6706b58ad5ce24cffd9861f07c94f"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.9.0"

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
git-tree-sha1 = "2b72a5624e289ee18256111657663721d59c143e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.24"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "b9a93bcdf34618031891ee56aad94cfff0843753"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f97acd98255568c3c9b416c5a3cf246c1315771b"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.0+0"

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
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

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

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

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
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

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

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[deps.NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

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
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

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
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "71d65e9242935132e71c4fbf084451579491166a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "7711172ace7c40dc8449b7aed9d2d6f1cf56a5bd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.29"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "71fd4022ecd0c6d20180e23ff1b3e05a143959c2"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.0"

[[deps.PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

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

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "0abe7fc220977da88ad86d339335a4517944fea2"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.14"

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
git-tree-sha1 = "0afd9e6c623e379f593da01f20590bacc26d1d14"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.1"

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
git-tree-sha1 = "7f5a513baec6f122401abfc8e9c074fdac54f6c1"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "88a559da57529581472320892576a486fa2377b9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "51383f2d367eb3b444c961d485c565e4c0cf4ba0"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.14"

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

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

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

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

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
# ╟─7d072f10-70d3-11ec-3e27-672bf625b6a7
# ╟─7d0283f2-70d3-11ec-0a55-419c3107f99e
# ╟─7d028424-70d3-11ec-3908-17f7ca604eac
# ╠═7d0288f2-70d3-11ec-1974-fd8469203a9e
# ╟─7d028c44-70d3-11ec-265a-554b817ff28d
# ╟─7d028c76-70d3-11ec-1b1c-bfceee6689b2
# ╟─7d028cbc-70d3-11ec-2816-4d8a37b10c6b
# ╟─7d028ce4-70d3-11ec-2723-c7ea7cbc9bb5
# ╟─7d028d34-70d3-11ec-32c4-ad861361b0b3
# ╟─7d028d66-70d3-11ec-01fe-afbaeeaf2c2c
# ╟─7d028d6e-70d3-11ec-03c4-ab7a6d8b4cad
# ╟─7d028d7a-70d3-11ec-3c39-51cd643282c3
# ╟─7d028e44-70d3-11ec-1268-ad0a6e307d64
# ╟─7d028e60-70d3-11ec-1406-d95deadc4eeb
# ╟─7d028e76-70d3-11ec-092d-ada9b09e6943
# ╟─7d028e7e-70d3-11ec-2628-f9ed6548454f
# ╟─7d028e9c-70d3-11ec-2cea-7d840a74a619
# ╟─7d028ea8-70d3-11ec-148e-5bc39eabea16
# ╟─7d028eba-70d3-11ec-1d74-d7c88a93fbd3
# ╟─7d028ec4-70d3-11ec-25b8-b7cebb926cdb
# ╟─7d028ed6-70d3-11ec-33d5-37c18ffd9aa4
# ╟─7d028ef6-70d3-11ec-2f44-352a6595cbd9
# ╟─7d028f08-70d3-11ec-3a5b-45d94b2cec8b
# ╟─7d028f08-70d3-11ec-0793-533140d6165f
# ╟─7d028f46-70d3-11ec-2fbd-b511de615f3a
# ╟─7d028f64-70d3-11ec-0c13-371173d7187d
# ╟─7d028f78-70d3-11ec-1515-9bca21da305e
# ╟─7d028f82-70d3-11ec-0809-7f79fc8cc6c8
# ╟─7d028fac-70d3-11ec-31e4-e183f6df3198
# ╟─7d028fc8-70d3-11ec-2ef2-c9c7dc0fb1d8
# ╟─7d028fde-70d3-11ec-053f-916a6103201d
# ╟─7d028fe6-70d3-11ec-39a1-f3fdd4c72828
# ╟─7d028ff0-70d3-11ec-39d6-03b5d863ead0
# ╟─7d029004-70d3-11ec-1746-6ba2dfc081ee
# ╟─7d02900c-70d3-11ec-19df-cfa9d5b209f6
# ╟─7d029018-70d3-11ec-0963-5fc7fc396921
# ╟─7d029022-70d3-11ec-19bf-cf2b7ad749f3
# ╟─7d0290f4-70d3-11ec-040f-57827412f142
# ╟─7d02a652-70d3-11ec-003a-032bb91b8dc3
# ╟─7d02a68e-70d3-11ec-1732-3b51ff3b3f93
# ╟─7d02a6ca-70d3-11ec-3dd8-a192a5668359
# ╟─7d02a6d4-70d3-11ec-070e-690cd722e9a6
# ╟─7d02bfea-70d3-11ec-37ea-bdbffbfe0b23
# ╟─7d02c074-70d3-11ec-0ac0-7bdae6a9a7e4
# ╟─7d02c0f6-70d3-11ec-1194-a9b625a31bce
# ╟─7d02c10a-70d3-11ec-1b43-9f725dee8bbe
# ╟─7d02c128-70d3-11ec-1f24-1fb0b9f45a61
# ╟─7d02c146-70d3-11ec-1eb3-975b33ad7c31
# ╟─7d02c164-70d3-11ec-03a9-c3eaa43e5da0
# ╟─7d02c180-70d3-11ec-3bd5-113097d85dfd
# ╟─7d02c1b2-70d3-11ec-21a7-a7056b7542f3
# ╟─7d02c1be-70d3-11ec-345d-3fc026848dd2
# ╟─7d02c20e-70d3-11ec-0176-7b03c8cff924
# ╟─7d02c218-70d3-11ec-2001-2d391f80ea19
# ╟─7d02c25e-70d3-11ec-1290-d1360efa8334
# ╟─7d02c272-70d3-11ec-1162-0b9dbdfac49b
# ╟─7d02c288-70d3-11ec-1111-176f874cc9ab
# ╟─7d02c2ae-70d3-11ec-053d-a770d4d266e0
# ╟─7d02c2c2-70d3-11ec-1def-25c742a386d5
# ╟─7d02c2cc-70d3-11ec-0c1a-21aa66f52cf2
# ╟─7d02c2d6-70d3-11ec-1070-b77b16fd1245
# ╟─7d02c2f4-70d3-11ec-38ed-d9dae92a19a7
# ╟─7d02c308-70d3-11ec-2f01-476f476143a2
# ╟─7d02c33a-70d3-11ec-31e1-9792a4e81b4a
# ╟─7d02c36c-70d3-11ec-3fbb-d5b94397a2bf
# ╟─7d02c376-70d3-11ec-3a84-0999226f1dfb
# ╟─7d02c394-70d3-11ec-22e0-f31497d00e45
# ╟─7d02c39e-70d3-11ec-0275-e3ee1f3cbff5
# ╟─7d02c3e4-70d3-11ec-22de-11ad81fa92bb
# ╟─7d02c402-70d3-11ec-0a4c-cb79e36f309a
# ╟─7d05c2a6-70d3-11ec-0298-51cfec063d34
# ╟─7d05c40e-70d3-11ec-3210-f54f0b678b94
# ╟─7d05c436-70d3-11ec-07f9-3fbfe036d460
# ╠═7d05c9ba-70d3-11ec-1e4c-5930c3f8ae39
# ╟─7d05ca12-70d3-11ec-1c43-37a013bcd974
# ╠═7d05cdc0-70d3-11ec-186d-cbd6a6b7b270
# ╟─7d05cddc-70d3-11ec-0ba4-5939763c2188
# ╠═7d05d258-70d3-11ec-185c-eb4eb331ffbc
# ╟─7d05d282-70d3-11ec-11a4-69bcc9760097
# ╠═7d05d6d8-70d3-11ec-2a15-cf61affc3aa2
# ╟─7d05d6ec-70d3-11ec-13c8-4d1b2a617c23
# ╠═7d05daf2-70d3-11ec-1a1c-6d77c5941a93
# ╟─7d05db10-70d3-11ec-18f1-33f99621a1e1
# ╠═7d05df40-70d3-11ec-3489-d70758e633d7
# ╟─7d05df52-70d3-11ec-22c4-0385c5825c75
# ╠═7d05e5c4-70d3-11ec-157f-9fe44da0ab91
# ╟─7d05e616-70d3-11ec-35f5-5f1f619c5655
# ╟─7d05e632-70d3-11ec-1a1c-bd5b0de7c2bd
# ╟─7d05e648-70d3-11ec-1ecb-15937748556d
# ╟─7d05e768-70d3-11ec-3aba-055d680d86a1
# ╟─7d05e79a-70d3-11ec-01fb-87538a9146e7
# ╟─7d05e7c2-70d3-11ec-2af9-cb962416554b
# ╟─7d05e7f4-70d3-11ec-3000-774713f9581d
# ╟─7d05e7fe-70d3-11ec-3327-9dbe6d49fa8f
# ╟─7d05e81c-70d3-11ec-3df0-f9284c792fa7
# ╟─7d05e830-70d3-11ec-1adc-114507efdbd8
# ╟─7d05e862-70d3-11ec-2995-83ebb981c3e5
# ╟─7d05e894-70d3-11ec-33fa-9314bbc12259
# ╟─7d05e8bc-70d3-11ec-3008-b539adcd8dc6
# ╟─7d05e902-70d3-11ec-0ca7-4b40921fcf22
# ╟─7d05e918-70d3-11ec-27c6-75969ae7c221
# ╟─7d05e95c-70d3-11ec-3223-f7a4dd425f3e
# ╟─7d05e970-70d3-11ec-30e0-7f1685838313
# ╟─7d05e998-70d3-11ec-18e4-e530dc8a56f4
# ╟─7d05e9a2-70d3-11ec-3532-8b5b6eba0b75
# ╟─7d05e9b6-70d3-11ec-37d3-4d4e889b97d1
# ╟─7d05e9c0-70d3-11ec-19e1-4985c74ca6e5
# ╟─7d05e9ca-70d3-11ec-1ba0-ed6f4f70c184
# ╟─7d05e9d4-70d3-11ec-3c77-8dc6a65378d0
# ╟─7d05e9e8-70d3-11ec-292c-6b1d41962408
# ╟─7d05e9f2-70d3-11ec-01cf-293b715f7718
# ╟─7d05ea06-70d3-11ec-12f0-fdb328f959f8
# ╟─7d05ea24-70d3-11ec-1705-a938e21fc91b
# ╟─7d05ea38-70d3-11ec-2430-cf36bea782d9
# ╟─7d05ea42-70d3-11ec-0cdf-836025fd58cf
# ╟─7d05ea56-70d3-11ec-0038-2748ec37bd20
# ╟─7d061e68-70d3-11ec-39e7-5b0c5509239c
# ╟─7d061e9a-70d3-11ec-1140-83dd5e4ca696
# ╟─7d061eb8-70d3-11ec-283c-2d98c467d3e5
# ╟─7d061ecc-70d3-11ec-16ed-e98cf4905778
# ╟─7d061ee0-70d3-11ec-0e44-095f039b342c
# ╟─7d061ef2-70d3-11ec-2c6b-2b84bbc9f4e2
# ╟─7d061efe-70d3-11ec-25e4-23b12e9acef0
# ╟─7d061f1c-70d3-11ec-16cd-4bdb5f2e2cdd
# ╟─7d061f30-70d3-11ec-18da-d96722fb1b92
# ╟─7d061f44-70d3-11ec-0101-3d909a51ec6c
# ╟─7d061fa8-70d3-11ec-11f3-17be32fe71cb
# ╟─7d061fbc-70d3-11ec-2bf6-b1a0d80e880e
# ╟─7d061fc8-70d3-11ec-1ab2-39d888b6e5a0
# ╟─7d061ffa-70d3-11ec-09b5-bd0e94d318f7
# ╟─7d062002-70d3-11ec-3a06-51cf31b1f947
# ╟─7d062016-70d3-11ec-0be0-65241ba5e1d1
# ╟─7d062020-70d3-11ec-3ae2-b5c2024e201b
# ╟─7d062028-70d3-11ec-28e4-8dbe71476a5e
# ╟─7d062034-70d3-11ec-1879-03d900969ac4
# ╟─7d06203e-70d3-11ec-3982-a90267db0542
# ╟─7d062052-70d3-11ec-2b32-85956aaf0269
# ╟─7d062066-70d3-11ec-1ee2-17d2ded341a7
# ╟─7d06208c-70d3-11ec-0391-f5b2fae1531f
# ╟─7d0620a2-70d3-11ec-32ae-977c3532a98c
# ╟─7d0620ac-70d3-11ec-2107-51890cc81daa
# ╟─7d0620ca-70d3-11ec-0cfc-bd7533e66c98
# ╟─7d0620de-70d3-11ec-0e27-877dd1ce7a89
# ╟─7d06211a-70d3-11ec-0a12-f7401e796455
# ╟─7d062124-70d3-11ec-2d4c-23063ce4b9c1
# ╟─7d062142-70d3-11ec-0bc9-dbb9dbbfbd84
# ╟─7d062156-70d3-11ec-1993-41a0ab8a62cf
# ╟─7d062162-70d3-11ec-0fa6-f597c78971d7
# ╟─7d062188-70d3-11ec-3cad-4588c2adfc4b
# ╟─7d06219c-70d3-11ec-0070-45844b684075
# ╟─7d0621b0-70d3-11ec-34fc-eb9d4d9828ff
# ╟─7d0621c2-70d3-11ec-00cf-3bac29f19d9f
# ╟─7d0621ce-70d3-11ec-28f3-778b0547c568
# ╟─7d0621e2-70d3-11ec-247f-73e206d181f7
# ╟─7d0621f4-70d3-11ec-37fc-657b797c945a
# ╟─7d06220a-70d3-11ec-2cf8-c3161a8d8958
# ╟─7d062214-70d3-11ec-0c27-110763934ab5
# ╠═7d062a70-70d3-11ec-3380-4bf90060530f
# ╟─7d062a98-70d3-11ec-0f88-69b8510ac714
# ╠═7d06317a-70d3-11ec-1bcc-83cc3cd216db
# ╟─7d0631a0-70d3-11ec-0b6d-0d16f0aa0999
# ╟─7d0631b4-70d3-11ec-30f7-07767018dc84
# ╟─7d0631f0-70d3-11ec-3181-db0144dc5e91
# ╟─7d06320c-70d3-11ec-2e1f-0ba196342965
# ╟─7d063268-70d3-11ec-20f2-f3d41c2b5882
# ╟─7d063286-70d3-11ec-3783-c366fbe28083
# ╟─7d06329a-70d3-11ec-16c3-773cea607ea4
# ╟─7d0632e2-70d3-11ec-32f6-2bde0b8fdaeb
# ╟─7d063314-70d3-11ec-343f-ab882a52c4b7
# ╟─7d063330-70d3-11ec-0977-d7174c57051a
# ╟─7d063358-70d3-11ec-1b73-97a1f80c7848
# ╟─7d063362-70d3-11ec-3bad-e70543f7839c
# ╟─7d06338a-70d3-11ec-3d1a-6f40fd6f867b
# ╠═7d0637fe-70d3-11ec-160a-11ac1e4bd759
# ╟─7d063812-70d3-11ec-13cd-db7dd88b5c61
# ╟─7d063830-70d3-11ec-0b6f-3fbcef45d958
# ╠═7d063db2-70d3-11ec-08e9-ade87a42d81e
# ╟─7d063dda-70d3-11ec-2bde-f7424dbe52b1
# ╠═7d064184-70d3-11ec-04d9-db337a8a3393
# ╟─7d0641a4-70d3-11ec-1484-5578283ace34
# ╟─7d0641cc-70d3-11ec-336f-afe51495c03d
# ╟─7d0641ea-70d3-11ec-3eb9-4fc06f1141ba
# ╟─7d065086-70d3-11ec-0cbb-c77fbe7e2af4
# ╟─7d0650a4-70d3-11ec-2e05-911e019dc146
# ╟─7d0650cc-70d3-11ec-12e1-9b26bbae0c67
# ╟─7d0650f4-70d3-11ec-2fce-496ca1387737
# ╟─7d06511c-70d3-11ec-3eab-7363df28f02a
# ╟─7d065126-70d3-11ec-3394-1f87129dc833
# ╟─7d06513c-70d3-11ec-2ed1-7f3896d6adb3
# ╟─7d065176-70d3-11ec-170a-697f73fd64cb
# ╟─7d06518a-70d3-11ec-33df-216514863411
# ╟─7d06519c-70d3-11ec-3ccc-0bce137e745f
# ╠═7d06554a-70d3-11ec-37e1-0de04b4e1de8
# ╟─7d065568-70d3-11ec-36be-7b1339d07d43
# ╟─7d065590-70d3-11ec-2921-c9e75e956149
# ╟─7d0655ae-70d3-11ec-2fc3-ad13a95f2ae4
# ╟─7d0655d4-70d3-11ec-0e95-3776e50166a9
# ╟─7d0655ea-70d3-11ec-22bb-2b7fc7ad6b01
# ╠═7d065996-70d3-11ec-29ab-ed12c12c3bee
# ╟─7d0659ac-70d3-11ec-2253-b36f9b2810d4
# ╟─7d0659da-70d3-11ec-300b-377b825b5737
# ╟─7d0659fa-70d3-11ec-270a-fd0b6b747bac
# ╟─7d065a22-70d3-11ec-0ffb-5f5853f8c611
# ╟─7d065a3e-70d3-11ec-35f5-eb71b7db39b5
# ╟─7d065a72-70d3-11ec-3de6-437aa06eeb26
# ╟─7d065a86-70d3-11ec-21aa-6dc482e89c7c
# ╟─7d065f0e-70d3-11ec-194f-f1b992ed59d2
# ╟─7d065f22-70d3-11ec-1c79-f504741f2e31
# ╟─7d065f40-70d3-11ec-2f52-6fe6205db977
# ╟─7d0664e0-70d3-11ec-3811-b34a336b8954
# ╟─7d06651a-70d3-11ec-0d20-4d4b13c649eb
# ╟─7d06653a-70d3-11ec-3a55-0b84781b3013
# ╟─7d066a28-70d3-11ec-1267-c5336e97f410
# ╟─7d066a3a-70d3-11ec-2eea-8d0b8d936300
# ╟─7d066a62-70d3-11ec-0a80-711ab87cde0a
# ╟─7d066e9a-70d3-11ec-2b22-d9c66939ec85
# ╟─7d066eb8-70d3-11ec-2644-a9a8b9b1eee5
# ╟─7d066ecc-70d3-11ec-1027-0bef9dc346f9
# ╟─7d0675a2-70d3-11ec-21ab-a1c23c827959
# ╟─7d0675ca-70d3-11ec-0a6f-639a24cdb7ed
# ╟─7d0675f2-70d3-11ec-3018-8f77df6f63de
# ╟─7d067ed8-70d3-11ec-2e05-5d812df6b878
# ╟─7d067eee-70d3-11ec-053b-636644b6dd28
# ╟─7d067f16-70d3-11ec-2492-03dce316388f
# ╟─7d068862-70d3-11ec-2743-e9e60a556c05
# ╟─7d06887e-70d3-11ec-3196-b75daa499635
# ╟─7d06889e-70d3-11ec-0ee1-bbbe82c9118b
# ╟─7d068c7c-70d3-11ec-3e79-671dcbce1809
# ╟─7d068c90-70d3-11ec-17b3-15c2e3e8da4f
# ╟─7d068cb6-70d3-11ec-15db-b17a03d4bf92
# ╟─7d069168-70d3-11ec-2fcb-a59d3ebc4e99
# ╟─7d06917c-70d3-11ec-3440-a33705e5d0bd
# ╟─7d0691b8-70d3-11ec-01d8-f121910c7a9a
# ╟─7d06969a-70d3-11ec-3e68-4b0265c3af8a
# ╟─7d0696ae-70d3-11ec-190f-dfcb294774f8
# ╟─7d0696d6-70d3-11ec-2688-5515ca4681d9
# ╟─7d06a392-70d3-11ec-30bb-ad005e705445
# ╟─7d06a41e-70d3-11ec-1d63-1b86fc53e73a
# ╟─7d06ad10-70d3-11ec-37dd-d9f9af9d04c7
# ╟─7d06ad74-70d3-11ec-1023-0d183519164b
# ╟─7d06b3c0-70d3-11ec-2ac8-d55b989eb42f
# ╟─7d06b40e-70d3-11ec-232d-6337c0bd402c
# ╟─7d06b74c-70d3-11ec-07a0-c5e18d52f423
# ╟─7d06b792-70d3-11ec-343e-9dff5ef4b128
# ╟─7d06c2fa-70d3-11ec-1f1b-85283c0257df
# ╟─7d06c318-70d3-11ec-2fb8-4f8d5795e155
# ╟─7d06c372-70d3-11ec-376c-03e6679ac374
# ╟─7d06c980-70d3-11ec-30d9-75a313d77dc5
# ╟─7d06c99e-70d3-11ec-262a-c3e97be218e1
# ╟─7d06c9c6-70d3-11ec-2c9e-fb059adbfbc8
# ╟─7d06d07e-70d3-11ec-359a-09ae3cd44ab6
# ╟─7d06d09c-70d3-11ec-31ec-975801d48029
# ╟─7d06d0e4-70d3-11ec-2374-711ff6eeff62
# ╟─7d06d66e-70d3-11ec-2d5c-27fd4e21bccc
# ╟─7d06e4e2-70d3-11ec-1b8f-8b35d8c81817
# ╟─7d06e4f6-70d3-11ec-34ae-e1c5af4d96ca
# ╟─7d06e546-70d3-11ec-21b9-05c4b9d5137d
# ╟─7d06ed84-70d3-11ec-3f50-75bda6275f6f
# ╟─7d06ed98-70d3-11ec-3a25-274732df2ddb
# ╟─7d06edca-70d3-11ec-1bf2-61401407d50f
# ╟─7d06ee10-70d3-11ec-2657-ad4162909028
# ╟─7d06f344-70d3-11ec-1a45-81b2efaf21e1
# ╟─7d06f372-70d3-11ec-3eae-bb60f7962acd
# ╟─7d06fb94-70d3-11ec-2989-856c66f9430b
# ╟─7d06fbc6-70d3-11ec-020b-e172815ab08e
# ╟─7d070420-70d3-11ec-3427-fd88c7ebadd4
# ╟─7d070436-70d3-11ec-0194-adc84c79e3c2
# ╟─7d070bd4-70d3-11ec-1d6e-4d7a475b7e70
# ╟─7d070be8-70d3-11ec-1992-d12cf4236899
# ╟─7d070c10-70d3-11ec-0ef5-a9100723c264
# ╟─7d071278-70d3-11ec-1a7d-f9a54dca1a93
# ╟─7d0712aa-70d3-11ec-3443-ad7b4af9240f
# ╟─7d0712e6-70d3-11ec-0a08-7d3020686f49
# ╟─7d071340-70d3-11ec-3e50-d70a2005647c
# ╟─7d071386-70d3-11ec-0ea9-69b3e63ebd0e
# ╟─7d07139a-70d3-11ec-2128-c315f136d3d9
# ╟─7d071412-70d3-11ec-3708-01c1ea7c3858
# ╟─7d07141c-70d3-11ec-0b32-11b987329c53
# ╟─7d072cb8-70d3-11ec-2e43-8bd519000a95
# ╟─7d072ce0-70d3-11ec-18e6-ab8a2f87bd8a
# ╟─7d072dc6-70d3-11ec-3751-1d2482b5513f
# ╟─7d072dd0-70d3-11ec-3c63-8b208b3cbab2
# ╟─7d072e66-70d3-11ec-357e-d1d6a6e6a2da
# ╟─7d072e7a-70d3-11ec-129a-cf447cd1bc24
# ╟─7d072f06-70d3-11ec-2e63-1bb63265e83f
# ╟─7d072f24-70d3-11ec-03b4-3f0cac090fce
# ╟─7d072f24-70d3-11ec-2ee5-6f6fef343cd1
# ╟─7d072f30-70d3-11ec-2a95-993eefc0da07
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
