### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 14534e26-70d4-11ec-1467-87e8a42dc920
begin
	using CalculusWithJulia
	using SymPy
end

# ╔═╡ 145351be-70d4-11ec-346c-3b73855c6e9a
begin
	using CalculusWithJulia.WeaveSupport
	using LaTeXStrings
	nothing
end

# ╔═╡ 1454841c-70d4-11ec-2e07-fdc8cd51dbd0
using PlutoUI

# ╔═╡ 145483f4-70d4-11ec-02a6-8b117f33e883
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 1453487c-70d4-11ec-273c-830e64fc618d
md"""# Partial Fractions
"""

# ╔═╡ 145351fa-70d4-11ec-1cd8-a918edc93637
md"""---
"""

# ╔═╡ 1453524a-70d4-11ec-1fc1-29e3fe2c7edf
md"""Integration is facilitated when an antiderivative for $f$ can be found, as then definite integrals can be evaluated through the fundamental theorem of calculus.
"""

# ╔═╡ 145352a4-70d4-11ec-08ad-a91be3e9ca19
md"""However, despite integration being an algorithmic procedure, integration is not. There are "tricks" to try, such as substitution and integration by parts. These work in some cases. However, there are classes of functions for which algorithms exist. For example, the `SymPy` `integrate` function mostly implements an algorithm that decides if an elementary function has an antiderivative. The [elementary](http://en.wikipedia.org/wiki/Elementary_function) functions include exponentials, their inverses (logarithms), trigonometric functions, their inverses, and powers, including $n$th roots. Not every elementary function will have an antiderivative comprised of (finite) combinations of elementary functions. The typical example is $e^{x^2}$, which has no simple antiderivative, despite its ubiquitousness.
"""

# ╔═╡ 145352c2-70d4-11ec-3875-576441324602
md"""There are classes of functions where an (elementary) antiderivative can always be found. Polynomials provide a case. More surprisingly, so do their ratios, *rational functions*.
"""

# ╔═╡ 145352ea-70d4-11ec-0327-47a7991350ce
md"""## Partial fraction decomposition
"""

# ╔═╡ 1453531c-70d4-11ec-0717-a720ac7fbf03
md"""Let $f(x) = p(x)/q(x)$, where  $p$ and $q$ are polynomial functions with real coefficients. Further, we assume without comment that $p$ and $q$ have no common factors. (If they did, we can divide them out, an act which has no effect on the integrability of $f(x)$.
"""

# ╔═╡ 14535342-70d4-11ec-2ee1-57e6f116f552
md"""The function $q(x)$ will factor over the real numbers. The fundamental theorem of algebra can be applied to say that $q(x)=q_1(x)^{n_1} \cdots q_k(x)^{n_k}$ where $q_i(x)$ is a linear or quadratic polynomial and $n_k$ a positive integer.
"""

# ╔═╡ 1453545c-70d4-11ec-022c-cd76d79800ba
md"""> **Partial Fraction Decomposition**: There are unique polynomials $a_{ij}$ with degree $a_{ij} <$ degree $q_i$ such that
>
> ```math
> \frac{p(x)}{q(x)} = a(x) + \sum_{i=1}^k \sum_{j=1}^{n_i} \frac{a_{ij}(x)}{q_i(x)^j}.
> ```

"""

# ╔═╡ 14535470-70d4-11ec-394e-1dc29c221aa8
md"""The method is attributed to John Bernoulli, one of the prolific Bernoulli brothers who put a stamp on several areas of math. This Bernoulli was a mentor to Euler.
"""

# ╔═╡ 1453548e-70d4-11ec-36d4-fb13c21c7f17
md"""This basically says that each factor $q_i(x)^{n_i}$ contributes a term like:
"""

# ╔═╡ 145354aa-70d4-11ec-3b35-71715e69388c
md"""```math
\frac{a_{i1}(x)}{q_i(x)^1} + \frac{a_{i2}(x)}{q_i(x)^2} + \cdots + \frac{a_{in_i}(x)}{q_i(x)^{n_i}},
```
"""

# ╔═╡ 145354ca-70d4-11ec-37df-bf3784fbd077
md"""where each $a_{ij}(x)$ has degree less than the degree of $q_i(x)$.
"""

# ╔═╡ 145354de-70d4-11ec-1dd8-b5385f36d9a7
md"""The value of this decomposition is that the terms $a_{ij}(x)/q_i(x)^j$ each have an antiderivative, and so the sum of them will also have an antiderivative.
"""

# ╔═╡ 1453603c-70d4-11ec-240a-f7a9309e2d76
note("""

Many calculus texts will give some examples for finding a partial
fraction decomposition. We push that work off to `SymPy`, as for all
but the easiest cases - a few are in the problems - it can be a bit tedious.

""")

# ╔═╡ 14536168-70d4-11ec-1229-9d9baf982127
md"""In `SymPy`, the `apart` function will find the partial fraction decomposition when a factorization is available. For example, here we see $n_i$ terms for each power of $q_i$
"""

# ╔═╡ 1453683e-70d4-11ec-1e64-456ba32bf6ca
@syms a::real b::real c::real A::real B::real x::real

# ╔═╡ 1453746e-70d4-11ec-294a-71e04d03f2de
apart((x-2)*(x-3) / (x*(x-1)^2*(x^2 + 2)^3))

# ╔═╡ 14538e36-70d4-11ec-2143-e18e828e9bd6
md"""### Sketch of proof
"""

# ╔═╡ 14538f3a-70d4-11ec-0f93-9d2ce642a7ac
md"""A standard proof uses two facts of number systems: the division algorithm and a representation of the greatest common divisor in terms of sums, extended to polynomials. Our sketch shows how these are used.
"""

# ╔═╡ 14538f6c-70d4-11ec-0770-e370b4ac8469
md"""Take one of the factors of the denominators, and consider this representation of the rational function $P(x)/(q(x)^k Q(x))$ where there are no common factors to any of the three polynomials.
"""

# ╔═╡ 14538fa8-70d4-11ec-27a8-0b80625ec7b0
md"""Since $q(x)$ and $Q(x)$ share no factors, [Bezout's](http://tinyurl.com/kd6prns) identity says there exists polynomials $a(x)$ and $b(x)$  with:
"""

# ╔═╡ 14538fc4-70d4-11ec-0166-c52eb3861983
md"""```math
a(x) Q(x) + b(x) q(x) = 1.
```
"""

# ╔═╡ 14538fda-70d4-11ec-1292-1324ffae4e25
md"""Then dividing by $q^k(x)Q(x)$ gives the decomposition
"""

# ╔═╡ 14538fee-70d4-11ec-111a-3b00061c20ae
md"""```math
\frac{1}{q(x)^k Q(x)} = \frac{a(x)}{q(x)^k} + \frac{b(x)}{q(x)^{k-1}Q(x)}.
```
"""

# ╔═╡ 14539002-70d4-11ec-3ce4-2bac40aae508
md"""So we get by multiplying the $P(x)$:
"""

# ╔═╡ 14539016-70d4-11ec-01e2-9d70246f0f0f
md"""```math
\frac{P(x)}{q(x)^k Q(x)} = \frac{A(x)}{q(x)^k} + \frac{B(x)}{q(x)^{k-1}Q(x)}.
```
"""

# ╔═╡ 14539036-70d4-11ec-3f5f-d90b305a45a9
md"""This may look more complicated, but what it does is peel off one term (The first) and leave something which is smaller, in this case by a factor of $q(x)$. This process can be repeated pulling off a power of a factor at a time until nothing is left to do.
"""

# ╔═╡ 14539052-70d4-11ec-226b-93fe28f3927d
md"""What remains is to establish that we can take $A(x) = a(x)\cdot P(x)$ with a degree less than that of $q(x)$.
"""

# ╔═╡ 14539084-70d4-11ec-3cc7-97cf0707e255
md"""In Proposition 3.8 of [Bradley](http://www.m-hikari.com/imf/imf-2012/29-32-2012/cookIMF29-32-2012.pdf) and Cook we can see how. Recall the division algorithm, for example, says there are $q_k$ and $r_k$ with $A=q\cdot q_k + r_k$ where the degree of $r_k$ is less than that of $q$, which is linear or quadratic. This is repeatedly applied below:
"""

# ╔═╡ 1453909a-70d4-11ec-171e-976e7d502724
md"""```math
\begin{align*}
\frac{A}{q^k} &= \frac{q\cdot q_k + r_k}{q^k}\\
&= \frac{r_k}{q^k} + \frac{q_k}{q^{k-1}}\\
&= \frac{r_k}{q^k} + \frac{q \cdot q_{k-1} + r_{k-1}}{q^{k-1}}\\
&= \frac{r_k}{q^k} + \frac{r_{k-1}}{q^{k-1}} + \frac{q_{k-1}}{q^{k-2}}\\
&= \frac{r_k}{q^k} + \frac{r_{k-1}}{q^{k-1}} + \frac{q\cdot q_{k-2} + r_{k-2}}{q^{k-2}}\\
&= \cdots\\
&= \frac{r_k}{q^k} + \frac{r_{k-1}}{q^{k-1}} + \cdots + q_1.
\end{align*}
```
"""

# ╔═╡ 145390c0-70d4-11ec-14ff-abe6f0d74b3f
md"""So the term $A(x)/q(x)^k$ can be expressed in terms of a sum where the numerators or each term have degree less than $q(x)$, as expected by the statement of the theorem.
"""

# ╔═╡ 145390de-70d4-11ec-3805-a9a86ca48b98
md"""## Integrating the terms in a partial fraction decomposition
"""

# ╔═╡ 14539124-70d4-11ec-1144-8dd1075ad801
md"""We discuss, by example, how each type of possible term in a partial fraction decomposition has an antiderivative. Hence, rational functions will *always* have an antiderivative that can be computed.
"""

# ╔═╡ 14539138-70d4-11ec-0fe9-dbf5a072488f
md"""### Linear factors
"""

# ╔═╡ 1453914c-70d4-11ec-35e0-af87eb26ae76
md"""For $j=1$, if $q_i$ is linear, then $a_{ij}/q_i^j$ must look like a constant over a linear term, or something like:
"""

# ╔═╡ 14539516-70d4-11ec-1579-db9457e6ab37
p = a/(x-c)

# ╔═╡ 1453952a-70d4-11ec-13e6-61d57ce50c24
md"""This has a logarithmic antiderivative:
"""

# ╔═╡ 145396d8-70d4-11ec-20b5-b7bf75a7546c
integrate(p, x)

# ╔═╡ 14539700-70d4-11ec-28c2-350cc2848aad
md"""For $j > 1$, we have powers.
"""

# ╔═╡ 14539b2e-70d4-11ec-02f4-b3ad34ab4a2b
begin
	@syms j::positive
	integrate(a/(x-c)^j, x)
end

# ╔═╡ 14539b4c-70d4-11ec-05ca-a50976b36093
md"""### Quadratic factors
"""

# ╔═╡ 14539b76-70d4-11ec-06d8-ef14ecc7b59e
md"""When $q_i$ is quadratic, it looks like $ax^2 + bx + c$. Then $a_{ij}$ can be a constant or a linear polynomial. The latter can be written as $Ax + B$.
"""

# ╔═╡ 14539b88-70d4-11ec-34d0-bd651924d81a
md"""The integral of the following general form is presented below:
"""

# ╔═╡ 14539b9c-70d4-11ec-355e-a1c9b17f585c
md"""```math
\frac{Ax +B }{(ax^2  + bx + c)^j},
```
"""

# ╔═╡ 14539bc4-70d4-11ec-1962-0736c1a2e3cb
md"""With `SymPy`, we consider a few cases of the following form, which results from a shift of `x`
"""

# ╔═╡ 14539bce-70d4-11ec-3bc4-ed67449480ed
md"""```math
\frac{Ax + B}{((ax)^2 \pm 1)^j}
```
"""

# ╔═╡ 14539bec-70d4-11ec-0b7a-69e85c576439
md"""This can be done by finding a $d$ so that $a(x-d)^2 + b(x-d) + c = dx^2 + e = e((\sqrt{d/e}x^2 \pm 1)$.
"""

# ╔═╡ 14539c08-70d4-11ec-0231-f14b48dca5f5
md"""The integrals of the type $Ax/((ax)^2 \pm 1)$ can completed by $u$-substitution, with $u=(ax)^2 \pm 1$.
"""

# ╔═╡ 14539c14-70d4-11ec-0fef-e74b4eb61984
md"""For example,
"""

# ╔═╡ 1453a240-70d4-11ec-2e9d-8145595bca23
integrate(A*x/((a*x)^2 + 1)^4, x)

# ╔═╡ 1453a272-70d4-11ec-3bae-2155ab20a3de
md"""The integrals of the type $B/((ax)^2\pm 1)$ are completed by trigonometric substitution and various reduction formulas. They can get involved, but are tractable. For example:
"""

# ╔═╡ 1453a7c2-70d4-11ec-1ecc-13961b49a854
integrate(B/((a*x)^2 + 1)^4, x)

# ╔═╡ 1453a7ec-70d4-11ec-2a4e-c50b845dfa6e
md"""and
"""

# ╔═╡ 1453adba-70d4-11ec-0c32-7f87df736434
integrate(B/((a*x)^2 - 1)^4, x)

# ╔═╡ 1453ade4-70d4-11ec-021d-f7aa53299ac1
md"""---
"""

# ╔═╡ 1453ae34-70d4-11ec-3892-ff2be09d1099
md"""In [Bronstein](http://www-sop.inria.fr/cafe/Manuel.Bronstein/publications/issac98.pdf) this characterization can be found - "This method, which dates back to Newton, Leibniz and Bernoulli, should not be used in practice, yet it remains the method found in most calculus texts and is often taught. Its major drawback is the factorization of the denominator of the integrand over the real or complex numbers." We can also find the following formulas which formalize the above exploratory calculations ($j>1$ and $b^2 - 4c < 0$ below):
"""

# ╔═╡ 1453ae52-70d4-11ec-14e1-8150679de56f
md"""```math
\begin{align*}
\int \frac{A}{(x-a)^j} &= \frac{A}{1-j}\frac{1}{(x-a)^{1-j}}\\
\int \frac{A}{x-a}     &= A\log(x-a)\\
\int \frac{Bx+C}{x^2 + bx + c}     &= \frac{B}{2} \log(x^2 + bx + c) + \frac{2C-bB}{\sqrt{4c-b^2}}\cdot \arctan\left(\frac{2x+b}{\sqrt{4c-b^2}}\right)\\
\int \frac{Bx+C}{(x^2 + bx + c)^j} &= \frac{B' x + C'}{(x^2 + bx + c)^{j-1}} + \int \frac{C''}{(x^2 + bx + c)^{j-1}}
\end{align*}
```
"""

# ╔═╡ 1453ae70-70d4-11ec-11fb-eb9ac895f7b9
md"""The first returns a rational function; the second yields a logarithm term; the third yields a logarithm and an arctangent term; while the last, which has explicit constants available, provides a reduction that can be recursively applied;
"""

# ╔═╡ 1453ae84-70d4-11ec-284d-7302e2da4aa5
md"""That is integrating $f(x)/g(x)$, a rational function, will yield an output that looks like the following, where the functions are polynomials:
"""

# ╔═╡ 1453ae98-70d4-11ec-0b73-e3d33ef04793
md"""```math
\int f(x)/g(x) = P(x) + \frac{C(x)}{D{x}} + \sum v_i \log(V_i(x)) + \sum w_j \arctan(W_j(x))
```
"""

# ╔═╡ 1453aeca-70d4-11ec-324e-1fd2dde180a4
md"""(Bronstein also sketches the modern method which is to use a Hermite reduction to express $\int (f/g) dx = p/q + \int (g/h) dx$, where $h$ is square free (the "`j`" are all $1$). The latter can be written over the complex numbers as logarithmic terms of the form $\log(x-a)$, the "`a`s"found following a method due to Trager and Lazard, and Rioboo, which is mentioned in the SymPy documentation as the method used.)
"""

# ╔═╡ 1453aef0-70d4-11ec-3972-317b863c9574
md"""#### Examples
"""

# ╔═╡ 1453af10-70d4-11ec-35ed-5d46a3103caa
md"""Find an antiderivative for $1/(x\cdot(x^2+1)^2)$.
"""

# ╔═╡ 1453af1a-70d4-11ec-2d5d-c5de4afae4fb
md"""We have a partial fraction decomposition is:
"""

# ╔═╡ 1453ce46-70d4-11ec-2149-9998c553649b
begin
	q = (x * (x^2 + 1)^2)
	apart(1/q)
end

# ╔═╡ 1453ce96-70d4-11ec-38d2-479b3c816f76
md"""We see three terms. The first and second will be done by $u$-substitution, the third by a logarithm:
"""

# ╔═╡ 1453e9aa-70d4-11ec-1583-a52fb3b99670
integrate(1/q, x)

# ╔═╡ 1453e9d0-70d4-11ec-3771-1f0e1b618484
md"""---
"""

# ╔═╡ 1453ea02-70d4-11ec-2538-2f22778a946f
md"""Find an antiderivative of $1/(x^2 - 2x-3)$.
"""

# ╔═╡ 1453ea2a-70d4-11ec-2677-dff6b79905be
md"""We again just let `SymPy` do the work. A partial fraction decomposition is given by:
"""

# ╔═╡ 1453f0ba-70d4-11ec-2aaa-e38097d6a538
begin
	𝒒 =  (x^2 - 2x - 3)
	apart(1/𝒒)
end

# ╔═╡ 1453f0d8-70d4-11ec-2658-53511a4d18bd
md"""We see what should yield two logarithmic terms:
"""

# ╔═╡ 1453f376-70d4-11ec-251e-e52f017a595c
integrate(1/𝒒, x)

# ╔═╡ 1453f9fc-70d4-11ec-0b41-95699fa247cc
note(L"""

`SymPy` will find $\log(x)$ as an antiderivative for $1/x$, but more
generally, $\log(\lvert x\rvert)$ is one.

""")

# ╔═╡ 1453fa42-70d4-11ec-1313-255b02759259
md"""##### Example
"""

# ╔═╡ 1453fa74-70d4-11ec-192d-43718c8606c7
md"""The answers found can become quite involved. [Corless](https://arxiv.org/pdf/1712.01752.pdf), Moir, Maza, and Xie use this example which at first glance seems tame enough:
"""

# ╔═╡ 14541702-70d4-11ec-269b-c38ac83d5625
ex = (x^2 - 1) / (x^4 + 5x^2 + 7)

# ╔═╡ 14541734-70d4-11ec-3be1-c176a7dcb1f5
md"""But the integral is something best suited to a computer algebra system:
"""

# ╔═╡ 1454190a-70d4-11ec-3327-69eddc94a696
integrate(ex, x)

# ╔═╡ 1454193c-70d4-11ec-31f3-c558ab6fa89a
md"""## Questions
"""

# ╔═╡ 14541964-70d4-11ec-27e3-0dea3545a947
md"""###### Question
"""

# ╔═╡ 14541996-70d4-11ec-265c-4bb2aad0b0dc
md"""The partial fraction decomposition of $1/(x(x-1))$ must be of the form $A/x + B/(x-1)$.
"""

# ╔═╡ 145419be-70d4-11ec-2ddf-f5b69dd21b39
md"""What is $A$? (Use `SymPy` or just put the sum over a common denominator and solve for $A$ and $B$.)
"""

# ╔═╡ 14541e28-70d4-11ec-1edf-a986d94c2eb5
let
	val = -1
	numericq(val)
end

# ╔═╡ 14541e46-70d4-11ec-0061-7d3547c06569
md"""What is $B$?
"""

# ╔═╡ 145421d4-70d4-11ec-2c5a-8946824a3f29
let
	val = 1
	numericq(val)
end

# ╔═╡ 145421f4-70d4-11ec-1682-6feaf468dfbc
md"""###### Question
"""

# ╔═╡ 14542206-70d4-11ec-04e1-19ed3af4e782
md"""The following gives the partial fraction decomposition for a rational expression:
"""

# ╔═╡ 14542222-70d4-11ec-2f9f-c5ddd56467b9
md"""```math
\frac{3x+5}{(1-2x)^2} = \frac{A}{1-2x} + \frac{B}{(1-2x)^2}.
```
"""

# ╔═╡ 14542242-70d4-11ec-04cc-bf80969841ae
md"""Find $A$ (being careful with the sign):
"""

# ╔═╡ 14543d54-70d4-11ec-3beb-492bf925fb35
let
	numericq(-3/2)
end

# ╔═╡ 14543dac-70d4-11ec-3799-1fd4258896b0
md"""Find $B$:
"""

# ╔═╡ 1454413c-70d4-11ec-3bbc-af6888533786
let
	numericq(13/2)
end

# ╔═╡ 14544164-70d4-11ec-2949-fd83705e7e1c
md"""###### Question
"""

# ╔═╡ 14544178-70d4-11ec-3bfa-2f53237f024d
md"""The following specifies the general partial fraction decomposition for a rational expression:
"""

# ╔═╡ 14544196-70d4-11ec-0924-4d2e79c6fb9b
md"""```math
\frac{1}{(x+1)(x-1)^2} = \frac{A}{x+1} + \frac{B}{x-1} + \frac{C}{(x-1)^2}.
```
"""

# ╔═╡ 145441aa-70d4-11ec-3281-0b6392e6cabc
md"""Find $A$:
"""

# ╔═╡ 1454448e-70d4-11ec-2b31-43cafadd23ab
let
	numericq(1/4)
end

# ╔═╡ 145444b4-70d4-11ec-0731-c3888aedcf72
md"""Find $B$:
"""

# ╔═╡ 14544768-70d4-11ec-188f-e923aeb78316
let
	numericq(-1/4)
end

# ╔═╡ 14544790-70d4-11ec-136d-b3559bee7206
md"""Find $C$:
"""

# ╔═╡ 14544a42-70d4-11ec-1ecb-c71ae1330c73
let
	numericq(1/2)
end

# ╔═╡ 14544a60-70d4-11ec-1d4e-95b1723e1976
md"""###### Question
"""

# ╔═╡ 14544a74-70d4-11ec-2755-9714117e1e54
md"""Compute the following exactly:
"""

# ╔═╡ 14544a92-70d4-11ec-1d3c-99192c13b2a1
md"""```math
\int_0^1 \frac{(x-2)(x-3)}{(x-4)^2\cdot(x-5)} dx
```
"""

# ╔═╡ 14544ab0-70d4-11ec-0bca-45e1bb171125
md"""Is $-6\log(5) - 5\log(3) - 1/6 + 11\log(4)$ the answer?
"""

# ╔═╡ 14544cea-70d4-11ec-1d58-0bf9586d2511
let
	yesnoq("yes")
end

# ╔═╡ 14544d12-70d4-11ec-0e95-efff74f9bf3e
md"""###### Question
"""

# ╔═╡ 14544d3a-70d4-11ec-1d55-33177bb8a317
md"""In the assumptions for the partial fraction decomposition is the fact that $p(x)$ and $q(x)$ share no common factors. Suppose, this isn't the case and in fact we have:
"""

# ╔═╡ 14544d4e-70d4-11ec-271d-d33d3f347361
md"""```math
\frac{p(x)}{q(x)} = \frac{(x-c)^m s(x)}{(x-c)^n t(x)}.
```
"""

# ╔═╡ 14544d76-70d4-11ec-069f-7b89e1620abd
md"""Here $s$ and $t$ are polynomials such that $s(c)$ and $t(c)$ are non-zero.
"""

# ╔═╡ 14544d8a-70d4-11ec-2bc3-97fd7a5814b7
md"""If $m > n$, then why can we cancel out the $(x-c)^n$ and not have a concern?
"""

# ╔═╡ 14545968-70d4-11ec-2206-b710b0f08eb1
let
	choices = [
	"`SymPy` allows it.",
	L"The value $c$ is a removable singularity, so the integral will be identical.",
	L"The resulting function has an identical domain and is equivalent for all $x$."
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 14545992-70d4-11ec-1f4c-afa65b07a83e
md"""If $m = n$, then why can we cancel out the $(x-c)^n$ and not have a concern?
"""

# ╔═╡ 145464e8-70d4-11ec-149a-99a2df243cf9
let
	choices = [
	"`SymPy` allows it.",
	L"The value $c$ is a removable singularity, so the integral will be identical.",
	L"The resulting function has an identical domain and is equivalent for all $x$."
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 1454651a-70d4-11ec-0289-dbdde0ddc9aa
md"""If $m < n$, then why can we cancel out the $(x-c)^n$ and not have a concern?
"""

# ╔═╡ 14546fae-70d4-11ec-2e66-f1ac7fce1f20
let
	choices = [
	"`SymPy` allows it.",
	L"The value $c$ is a removable singularity, so the integral will be identical.",
	L"The resulting function has an identical domain and is equivalent for all $x$."
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 14546fe0-70d4-11ec-2bda-0f401abb3e7e
md"""##### Question
"""

# ╔═╡ 14546ff6-70d4-11ec-118f-7f5c878175dd
md"""The partial fraction decomposition, as presented, factors the denominator polynomial into linear and quadratic factors over the real numbers. Alternatively, factoring over the complex numbers is possible, resulting in terms like:
"""

# ╔═╡ 14547012-70d4-11ec-1de9-57ec3ae82a97
md"""```math
\frac{a + ib}{x - (\alpha + i \beta)} + \frac{a - ib}{x - (\alpha - i \beta)}
```
"""

# ╔═╡ 1454701c-70d4-11ec-0c8b-a74df6b5678c
md"""How to see that these give rise to real answers on integration is the point of this question.
"""

# ╔═╡ 1454703a-70d4-11ec-3aba-d525e07b5bbc
md"""Breaking the terms up over $a$ and $b$ we have:
"""

# ╔═╡ 1454704e-70d4-11ec-1a54-339a17579c7d
md"""```math
\begin{align*}
I &= \frac{a}{x - (\alpha + i \beta)} + \frac{a}{x - (\alpha - i \beta)} \\
II &= i\frac{b}{x - (\alpha + i \beta)} - i\frac{b}{x - (\alpha - i \beta)}
\end{align*}
```
"""

# ╔═╡ 14547062-70d4-11ec-2a8a-31c37a25677e
md"""Integrating $I$ leads to two logarithmic terms, which are combined to give:
"""

# ╔═╡ 14547076-70d4-11ec-32c2-db133f6bd591
md"""```math
\int I dx = a\cdot \log((x-(\alpha+i\beta)) \cdot (x - (\alpha-i\beta)))
```
"""

# ╔═╡ 14547080-70d4-11ec-15b4-794f23e9bd25
md"""This involves no complex numbers, as:
"""

# ╔═╡ 14547c1a-70d4-11ec-2a9b-5dc4f157f291
let
	choices = ["The complex numbers are complex conjugates, so the term in the logarithm will simply be ``x - 2\\alpha x + \\alpha^2 + \\beta^2``",
	           "The ``\\beta`` are ``0``, as the polynomials in question are real"]
	radioq(choices, 1)
end

# ╔═╡ 14547c4c-70d4-11ec-3cdb-33c81a3c860c
md"""The term $II$ benefits from this computation (attributed to Rioboo by [Corless et. al](https://arxiv.org/pdf/1712.01752.pdf))
"""

# ╔═╡ 14547c6c-70d4-11ec-1eee-b1fdb3ba5457
md"""```math
\frac{d}{dx} i \log(\frac{X+iY}{X-iY}) = 2\frac{d}{dx}\arctan(\frac{X}{Y})
```
"""

# ╔═╡ 14547c7e-70d4-11ec-18ef-e17440a59aef
md"""Applying this with $X=x - \alpha$ and $Y=-\beta$ shows that $\int II dx$ will be
"""

# ╔═╡ 145483ea-70d4-11ec-0a40-296b4d117db7
let
	choices = ["``-2b\\arctan((x - \\alpha)/(\\beta))``",
	           "``2b\\sec^2(-(x-\\alpha)/(-\\beta))``"]
	radioq(choices, 1)
end

# ╔═╡ 14548412-70d4-11ec-23fd-072526cff36f
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/integration_by_parts.html">◅ previous</a>  <a href="../integrals/improper_integrals.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/partial_fractions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 1454841c-70d4-11ec-021b-c3b11d14ebe0
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.13"
LaTeXStrings = "~1.3.0"
PlutoUI = "~0.7.29"
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

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

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

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

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

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

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

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─145483f4-70d4-11ec-02a6-8b117f33e883
# ╟─1453487c-70d4-11ec-273c-830e64fc618d
# ╠═14534e26-70d4-11ec-1467-87e8a42dc920
# ╟─145351be-70d4-11ec-346c-3b73855c6e9a
# ╟─145351fa-70d4-11ec-1cd8-a918edc93637
# ╟─1453524a-70d4-11ec-1fc1-29e3fe2c7edf
# ╟─145352a4-70d4-11ec-08ad-a91be3e9ca19
# ╟─145352c2-70d4-11ec-3875-576441324602
# ╟─145352ea-70d4-11ec-0327-47a7991350ce
# ╟─1453531c-70d4-11ec-0717-a720ac7fbf03
# ╟─14535342-70d4-11ec-2ee1-57e6f116f552
# ╟─1453545c-70d4-11ec-022c-cd76d79800ba
# ╟─14535470-70d4-11ec-394e-1dc29c221aa8
# ╟─1453548e-70d4-11ec-36d4-fb13c21c7f17
# ╟─145354aa-70d4-11ec-3b35-71715e69388c
# ╟─145354ca-70d4-11ec-37df-bf3784fbd077
# ╟─145354de-70d4-11ec-1dd8-b5385f36d9a7
# ╟─1453603c-70d4-11ec-240a-f7a9309e2d76
# ╟─14536168-70d4-11ec-1229-9d9baf982127
# ╠═1453683e-70d4-11ec-1e64-456ba32bf6ca
# ╠═1453746e-70d4-11ec-294a-71e04d03f2de
# ╟─14538e36-70d4-11ec-2143-e18e828e9bd6
# ╟─14538f3a-70d4-11ec-0f93-9d2ce642a7ac
# ╟─14538f6c-70d4-11ec-0770-e370b4ac8469
# ╟─14538fa8-70d4-11ec-27a8-0b80625ec7b0
# ╟─14538fc4-70d4-11ec-0166-c52eb3861983
# ╟─14538fda-70d4-11ec-1292-1324ffae4e25
# ╟─14538fee-70d4-11ec-111a-3b00061c20ae
# ╟─14539002-70d4-11ec-3ce4-2bac40aae508
# ╟─14539016-70d4-11ec-01e2-9d70246f0f0f
# ╟─14539036-70d4-11ec-3f5f-d90b305a45a9
# ╟─14539052-70d4-11ec-226b-93fe28f3927d
# ╟─14539084-70d4-11ec-3cc7-97cf0707e255
# ╟─1453909a-70d4-11ec-171e-976e7d502724
# ╟─145390c0-70d4-11ec-14ff-abe6f0d74b3f
# ╟─145390de-70d4-11ec-3805-a9a86ca48b98
# ╟─14539124-70d4-11ec-1144-8dd1075ad801
# ╟─14539138-70d4-11ec-0fe9-dbf5a072488f
# ╟─1453914c-70d4-11ec-35e0-af87eb26ae76
# ╠═14539516-70d4-11ec-1579-db9457e6ab37
# ╟─1453952a-70d4-11ec-13e6-61d57ce50c24
# ╠═145396d8-70d4-11ec-20b5-b7bf75a7546c
# ╟─14539700-70d4-11ec-28c2-350cc2848aad
# ╠═14539b2e-70d4-11ec-02f4-b3ad34ab4a2b
# ╟─14539b4c-70d4-11ec-05ca-a50976b36093
# ╟─14539b76-70d4-11ec-06d8-ef14ecc7b59e
# ╟─14539b88-70d4-11ec-34d0-bd651924d81a
# ╟─14539b9c-70d4-11ec-355e-a1c9b17f585c
# ╟─14539bc4-70d4-11ec-1962-0736c1a2e3cb
# ╟─14539bce-70d4-11ec-3bc4-ed67449480ed
# ╟─14539bec-70d4-11ec-0b7a-69e85c576439
# ╟─14539c08-70d4-11ec-0231-f14b48dca5f5
# ╟─14539c14-70d4-11ec-0fef-e74b4eb61984
# ╠═1453a240-70d4-11ec-2e9d-8145595bca23
# ╟─1453a272-70d4-11ec-3bae-2155ab20a3de
# ╠═1453a7c2-70d4-11ec-1ecc-13961b49a854
# ╟─1453a7ec-70d4-11ec-2a4e-c50b845dfa6e
# ╠═1453adba-70d4-11ec-0c32-7f87df736434
# ╟─1453ade4-70d4-11ec-021d-f7aa53299ac1
# ╟─1453ae34-70d4-11ec-3892-ff2be09d1099
# ╟─1453ae52-70d4-11ec-14e1-8150679de56f
# ╟─1453ae70-70d4-11ec-11fb-eb9ac895f7b9
# ╟─1453ae84-70d4-11ec-284d-7302e2da4aa5
# ╟─1453ae98-70d4-11ec-0b73-e3d33ef04793
# ╟─1453aeca-70d4-11ec-324e-1fd2dde180a4
# ╟─1453aef0-70d4-11ec-3972-317b863c9574
# ╟─1453af10-70d4-11ec-35ed-5d46a3103caa
# ╟─1453af1a-70d4-11ec-2d5d-c5de4afae4fb
# ╠═1453ce46-70d4-11ec-2149-9998c553649b
# ╟─1453ce96-70d4-11ec-38d2-479b3c816f76
# ╠═1453e9aa-70d4-11ec-1583-a52fb3b99670
# ╟─1453e9d0-70d4-11ec-3771-1f0e1b618484
# ╟─1453ea02-70d4-11ec-2538-2f22778a946f
# ╟─1453ea2a-70d4-11ec-2677-dff6b79905be
# ╠═1453f0ba-70d4-11ec-2aaa-e38097d6a538
# ╟─1453f0d8-70d4-11ec-2658-53511a4d18bd
# ╠═1453f376-70d4-11ec-251e-e52f017a595c
# ╟─1453f9fc-70d4-11ec-0b41-95699fa247cc
# ╟─1453fa42-70d4-11ec-1313-255b02759259
# ╟─1453fa74-70d4-11ec-192d-43718c8606c7
# ╠═14541702-70d4-11ec-269b-c38ac83d5625
# ╟─14541734-70d4-11ec-3be1-c176a7dcb1f5
# ╠═1454190a-70d4-11ec-3327-69eddc94a696
# ╟─1454193c-70d4-11ec-31f3-c558ab6fa89a
# ╟─14541964-70d4-11ec-27e3-0dea3545a947
# ╟─14541996-70d4-11ec-265c-4bb2aad0b0dc
# ╟─145419be-70d4-11ec-2ddf-f5b69dd21b39
# ╟─14541e28-70d4-11ec-1edf-a986d94c2eb5
# ╟─14541e46-70d4-11ec-0061-7d3547c06569
# ╟─145421d4-70d4-11ec-2c5a-8946824a3f29
# ╟─145421f4-70d4-11ec-1682-6feaf468dfbc
# ╟─14542206-70d4-11ec-04e1-19ed3af4e782
# ╟─14542222-70d4-11ec-2f9f-c5ddd56467b9
# ╟─14542242-70d4-11ec-04cc-bf80969841ae
# ╟─14543d54-70d4-11ec-3beb-492bf925fb35
# ╟─14543dac-70d4-11ec-3799-1fd4258896b0
# ╟─1454413c-70d4-11ec-3bbc-af6888533786
# ╟─14544164-70d4-11ec-2949-fd83705e7e1c
# ╟─14544178-70d4-11ec-3bfa-2f53237f024d
# ╟─14544196-70d4-11ec-0924-4d2e79c6fb9b
# ╟─145441aa-70d4-11ec-3281-0b6392e6cabc
# ╟─1454448e-70d4-11ec-2b31-43cafadd23ab
# ╟─145444b4-70d4-11ec-0731-c3888aedcf72
# ╟─14544768-70d4-11ec-188f-e923aeb78316
# ╟─14544790-70d4-11ec-136d-b3559bee7206
# ╟─14544a42-70d4-11ec-1ecb-c71ae1330c73
# ╟─14544a60-70d4-11ec-1d4e-95b1723e1976
# ╟─14544a74-70d4-11ec-2755-9714117e1e54
# ╟─14544a92-70d4-11ec-1d3c-99192c13b2a1
# ╟─14544ab0-70d4-11ec-0bca-45e1bb171125
# ╟─14544cea-70d4-11ec-1d58-0bf9586d2511
# ╟─14544d12-70d4-11ec-0e95-efff74f9bf3e
# ╟─14544d3a-70d4-11ec-1d55-33177bb8a317
# ╟─14544d4e-70d4-11ec-271d-d33d3f347361
# ╟─14544d76-70d4-11ec-069f-7b89e1620abd
# ╟─14544d8a-70d4-11ec-2bc3-97fd7a5814b7
# ╟─14545968-70d4-11ec-2206-b710b0f08eb1
# ╟─14545992-70d4-11ec-1f4c-afa65b07a83e
# ╟─145464e8-70d4-11ec-149a-99a2df243cf9
# ╟─1454651a-70d4-11ec-0289-dbdde0ddc9aa
# ╟─14546fae-70d4-11ec-2e66-f1ac7fce1f20
# ╟─14546fe0-70d4-11ec-2bda-0f401abb3e7e
# ╟─14546ff6-70d4-11ec-118f-7f5c878175dd
# ╟─14547012-70d4-11ec-1de9-57ec3ae82a97
# ╟─1454701c-70d4-11ec-0c8b-a74df6b5678c
# ╟─1454703a-70d4-11ec-3aba-d525e07b5bbc
# ╟─1454704e-70d4-11ec-1a54-339a17579c7d
# ╟─14547062-70d4-11ec-2a8a-31c37a25677e
# ╟─14547076-70d4-11ec-32c2-db133f6bd591
# ╟─14547080-70d4-11ec-15b4-794f23e9bd25
# ╟─14547c1a-70d4-11ec-2a9b-5dc4f157f291
# ╟─14547c4c-70d4-11ec-3cdb-33c81a3c860c
# ╟─14547c6c-70d4-11ec-1eee-b1fdb3ba5457
# ╟─14547c7e-70d4-11ec-18ef-e17440a59aef
# ╟─145483ea-70d4-11ec-0a40-296b4d117db7
# ╟─14548412-70d4-11ec-23fd-072526cff36f
# ╟─1454841c-70d4-11ec-2e07-fdc8cd51dbd0
# ╟─1454841c-70d4-11ec-021b-c3b11d14ebe0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
