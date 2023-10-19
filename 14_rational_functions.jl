### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 850b5e72-53c1-11ec-134d-6d9997587c43
begin
	using CalculusWithJulia
	using SymPy
	using Plots
	import Polynomials
	using RealPolynomialRoots
end

# ╔═╡ 850b73e4-53c1-11ec-2d15-35344b8695c6
begin
	using CalculusWithJulia.WeaveSupport
	using Roots
	__DIR__, __FILE__ = :precalc, :rational_functions
	nothing
end

# ╔═╡ 850f7354-53c1-11ec-2a9e-c3534dfb16f8
using PlutoUI

# ╔═╡ 850f732c-53c1-11ec-2732-39f5bad92666
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 850b2998-53c1-11ec-1b4d-51ecf243e6e6
md"""# Rational functions
"""

# ╔═╡ 850b2a06-53c1-11ec-01bf-1fa0294989c2
md"""This section uses the following add-on packages:
"""

# ╔═╡ 850b6e10-53c1-11ec-1138-75ee793c1fe9
md"""The `Polynomials` package is "imported" to avoid naming collisions with `SymPy`; names will need to be qualified.
"""

# ╔═╡ 850b74b4-53c1-11ec-2f34-dfa53d80ee7f
md"""---
"""

# ╔═╡ 850b74d4-53c1-11ec-2afb-e1d0585ccda8
md"""A rational expression is the ratio of two polynomial expressions. Such expressions arise in many modeling situations. As well, as many facts are known about polynomial expressions, much can be determined about rational expressions.  This section covers some additional details that arise when graphing such expressions.
"""

# ╔═╡ 850b752e-53c1-11ec-3f7c-f3cc78d2eefc
md"""## Rational functions
"""

# ╔═╡ 850b75a6-53c1-11ec-28da-c30586919e77
md"""The rational numbers are simply ratios of integers, of the form $p/q$ for non-zero $q$. A rational function is a ratio of *polynomial* *functions* of the form $p(x)/q(x)$, again $q$ is non-zero, but may have zeros.
"""

# ╔═╡ 850b75bc-53c1-11ec-00b3-c1a734541d9c
md"""We know that polynomials have nice behaviors due to the following facts:
"""

# ╔═╡ 850b78d0-53c1-11ec-32e3-d381933dd523
md"""  * Behaviors at $-\infty$, $\infty$ are known just from the leading term.
  * There are possible wiggles up and down, the exact behavior depends on intermediate terms, but there can be no more than $n-1$ wiggles.
  * The number of real zeros is no more than $n$, the degree of the polynomial.
"""

# ╔═╡ 850b78da-53c1-11ec-08f0-7196b41b1579
md"""Rational functions are not quite so nice:
"""

# ╔═╡ 850b7970-53c1-11ec-2dd0-9becd62a4333
md"""  * behavior at $-\infty$ and  $\infty$ can be like a polynomial of any degree, including constants
  * behaviour at any value x can blow up due to division by 0 - rational functions, unlike polynomials, need not be always defined
  * The function may or may not cross zero, even if the range includes every other point, as the graph of $f(x) =1/x$ will show.
"""

# ╔═╡ 850b7984-53c1-11ec-294f-1fd8436b95bd
md"""Here, as with our discussion on polynomials, we are interested for now in just a few properties:
"""

# ╔═╡ 850b7a06-53c1-11ec-3a70-ddd4f5eadbde
md"""  * What happens to $f(x)$ when $x$ gets really big or really small (towards $\infty$ or $-\infty$)?
  * What happens near the values where $q(x) = 0$?
  * When is $f(x) = 0$?
"""

# ╔═╡ 850b7a10-53c1-11ec-3d35-f9a59175b89a
md"""These questions can often be answered with a graph, but with rational functions we will see that care must be taken to produce a useful graph.
"""

# ╔═╡ 850b7a1a-53c1-11ec-0062-a9d7c9e8e116
md"""For example, consider this graph generated from a simple rational function:
"""

# ╔═╡ 850b7a74-53c1-11ec-3ec2-25cb15cbbe8a
md"""```math
f(x) = \frac{(x-1)^2 \cdot (x-2)}{(x+3) \cdot (x-3)}.
```
"""

# ╔═╡ 850b8bfe-53c1-11ec-3db1-1d8ae14c45d3
begin
	f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
	plot(f, -10, 10)
end

# ╔═╡ 850b8c38-53c1-11ec-0a8f-899f813441c0
md"""We would be hard pressed to answer any of the three questions above from the graph, though, on inspection, we might think the strange spikes have something to do with $x$ values where $q(x)=0$.
"""

# ╔═╡ 850b8c58-53c1-11ec-1508-791467c4ece3
md"""The question of big or small $x$ is not answered well with this graph, as the spikes dominate the scale of the $y$-axis. Setting a much larger viewing window illuminates this question:
"""

# ╔═╡ 850b909a-53c1-11ec-0796-5341450567b6
plot(f, -100, 100)

# ╔═╡ 850b90cc-53c1-11ec-34c1-ebe1e934bf43
md"""We can see from this, that the function eventually looks like a slanted straight line. The *eventual* shape of the graph is something that can be determined just from the two leading terms.
"""

# ╔═╡ 850b913a-53c1-11ec-302e-65ac05e1ec09
md"""The spikes haven't vanished completely. It is just that with only a few hundred points to make the graph, there aren't any values near enough to the problem to make a large spike. The spikes happen because the function has a *vertical asymptote* at these values. Though not quite right, it is reasonable to think of the graph being made by selecting a few hundred points in the specified domain, computing the corresponding $y$ values, plotting the pairs, and finally connecting the points with straight line segments.  Near a vertical asymptote the function values can be arbitrarily large in absolute values, though at the vertical asymptote the function is undefined. This graph doesn't show such detail.
"""

# ╔═╡ 850b914e-53c1-11ec-0e37-015d43c54832
md"""The spikes will be related to the points where $q(x) = 0$, though not necessarily, as not all such points will produce a vertical asymptote.
"""

# ╔═╡ 850b9174-53c1-11ec-0f9f-6d78effccbff
md"""Where the function crosses $0$ is very hard to tell from these two graphs. As well, other finer features, such as local peaks or valleys, when present, can be hard to identify as the $y$-scale is set to accommodate the  asymptotes. Working around the asymptotes requires some extra effort. Strategies are discussed herein.
"""

# ╔═╡ 850b918a-53c1-11ec-2d03-bb19aee881dc
md"""## Asymptotes
"""

# ╔═╡ 850b9202-53c1-11ec-0729-031a6ce6fdb9
md"""Formally, an [asymptote](http://en.wikipedia.org/wiki/Asymptote) of a curve is a line such that the distance between the curve and the line approaches $0$ as they tend to infinity. Tending to infinity can happen as $x \rightarrow \pm \infty$ *or* $y \rightarrow \pm \infty$, the former being related to *horizontal asymptotes* or *slant asymptotes*, the latter being related to *vertical asymptotes*.
"""

# ╔═╡ 850b9266-53c1-11ec-2bdc-4b9f18d59c25
md"""### Behaviour as $x \rightarrow \infty$ or $x \rightarrow -\infty$.
"""

# ╔═╡ 850b927c-53c1-11ec-26fe-8db87f8c6149
md"""Let's look more closely at our example rational function using symbolic math.
"""

# ╔═╡ 850b928e-53c1-11ec-2c27-592f043a5726
md"""In particular, let's rewrite the expression in terms of its numerator and denominator:
"""

# ╔═╡ 850b975c-53c1-11ec-384a-95f0577371b5
begin
	@syms x::real
	num = (x-1)^2 * (x-2)
	den = (x+3) * (x-3)
end

# ╔═╡ 850b97ca-53c1-11ec-3a22-8f91dad5bcd9
md"""Euclid's [division](https://en.wikipedia.org/wiki/Polynomial_greatest_common_divisor#Euclidean_division) algorithm can be used for polynomials $a(x)$ and $b(x)$ to produce $q(x)$ and $r(x)$ with $a = b\cdot q + r$ *and* the degree of $r(x)$ is less than the degree of $b(x)$. This is in direct analogy to the division algorithm of integers, only there the value of the remainder, $r(x)$, satisfies $0 \leq r < b$. Given $q(x)$ and $r(x)$ as above, we can reexpress the rational function
"""

# ╔═╡ 850b97de-53c1-11ec-2022-cd3c5025d570
md"""```math
\frac{a(x)}{b(x)} = q(x)  + \frac{r(x)}{b(x)}.
```
"""

# ╔═╡ 850b97f2-53c1-11ec-0b1e-2115ba9b8da4
md"""The rational expression on the right-hand side has larger degree in the denominator.
"""

# ╔═╡ 850b9818-53c1-11ec-13fc-fff011550ce0
md"""The division algorithm is implemented in `Julia` generically through the `divrem` method:
"""

# ╔═╡ 850b9c5c-53c1-11ec-29a1-d9f597ea356f
q, r = divrem(num, den)

# ╔═╡ 850b9c7a-53c1-11ec-2d82-87aac18549a8
md"""This yields the decomposition of `num/den`:
"""

# ╔═╡ 850b9e78-53c1-11ec-016b-61c5254c8149
q + r/den

# ╔═╡ 850b9e96-53c1-11ec-2f87-4338ecd9bc63
md"""A similar result can be found using the `apart` function, which can be easier to use if the expression is not given in terms of a separate numerator and denominator.
"""

# ╔═╡ 850ba8f8-53c1-11ec-3dde-ef4d21566a00
begin
	g(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3))  # as a function
	h = g(x)                                # a symbolic expression
	apart(h)
end

# ╔═╡ 850ba936-53c1-11ec-3b50-51183b884cdc
md"""This decomposition breaks the rational expression into two pieces: $x-4$ and $40/(3x+9) + 2/(3x-9)$. The first piece would have a graph that is the line with slope $1$ and $y$-intercept $4$. As $x$ goes to $\infty$, the second piece will clearly go towards 0, as this simple graph shows:
"""

# ╔═╡ 850c53fe-53c1-11ec-132e-85fa1d585444
plot(apart(h) - (x - 4), 10, 100)

# ╔═╡ 850c549e-53c1-11ec-2c8b-d304dd11a50f
md"""Similarly, a plot over $[-100, -10]$ would show decay towards $0$, though in that case from below. Combining these two facts then, it is now no surprise that the graph of the rational function $f(x)$ should approach a straight line, in this case $y=x-4$ as $x \rightarrow \pm \infty$.
"""

# ╔═╡ 850c5520-53c1-11ec-2bfe-798592ecbdd8
md"""We can easily do most of this analysis without needing a computer or algebra. First, we should know the four eventual shapes of a polynomial, that the graph of $y=mx$ is a line with slope $m$, the graph of $y = c$ is a constant line at height $c$, and the graph of $y=c/x^m$, $m > 0$ will decay towards $0$ as $x \rightarrow \pm\infty$. The latter should be clear, as $x^m$ gets big, so its reciprocal goes towards $0$.
"""

# ╔═╡ 850c5552-53c1-11ec-3f44-e1d591519395
md"""The factored form, as $p$ is presented, is a bit hard to work with, rather we use the expanded form, which we get through the `cancel` function
"""

# ╔═╡ 850c5728-53c1-11ec-0285-d33cb52d8da7
cancel(h)

# ╔═╡ 850c5750-53c1-11ec-01b1-b124d7f7fa3a
md"""We can see that the numerator is of degree 3 and the denominator of degree $2$. The leading terms are $x^3$ and $x^2$ respectively. If we were to pull those out we would get:
"""

# ╔═╡ 850c576e-53c1-11ec-364e-13836ab27102
md"""```math
\frac{x^3 \cdot (1 - 4/x + 5/x^2 - 2/x^3)}{x^2 \cdot (1 - 9/x^2)}.
```
"""

# ╔═╡ 850c57a0-53c1-11ec-3d2e-9b12f869ade4
md"""The terms $(1 - 4/x + 5/x^2 - 2/x^3)$ and $(1 - 9/x^2)$ go towards $1$ as $x \rightarrow \pm \infty$, as each term with $x$ goes towards $0$. So the dominant terms comes from the ratio of the leading terms, $x^3$ and $x^2$. This ratio is $x$, so their will be an asymptote around a line with slope $1$. (The fact that the asymptote is $y=x-4$ takes a bit more work, as a division step is needed.)
"""

# ╔═╡ 850c57b6-53c1-11ec-3354-11ab732afb74
md"""Just by looking at the ratio of the two leading terms, the behaviour as $x \rightarrow \pm \infty$ can be discerned. If this ratio is of:
"""

# ╔═╡ 850c5926-53c1-11ec-0cbf-37167f52dea9
md"""  * the form $c x^m$ with $m > 1$ then the shape will follow the polynomial growth of of the monomial $c x^m$.
  * the form $c x^m$ with  $m=1$ then there will be a line with slope $c$ as a *slant asymptote*.
  * the form $cx^0$ with  $m=0$ (or just $c$) then there will be a *horizontal asymptote* $y=c$.
  * the form $c/x^{m}$ with $m  >  0$ then there will be a horizontal asymptote $y=0$, or the $y$ axis.
"""

# ╔═╡ 850c5962-53c1-11ec-1168-61937109f758
md"""To expand on the first points where the degree of the numerator is greater than that of the denominator, we have from the division algorithm that if $a(x)$ is the numerator and $b(x)$ the denominator, then $a(x)/b(x) = q(x) + r(x)/b(x)$ where the degree of $b(x)$ is greater than the degree of $r(x)$, so the rightmost term will have a horizontal asymptote of $0$. This says that the graph will eventually approach the graph of $q(x)$, giving more detail than just saying it follows the shape of the leading term of $q(x)$, at the expense of the work required to find $q(x)$.
"""

# ╔═╡ 850c5994-53c1-11ec-3328-1f713102658b
md"""##### Examples
"""

# ╔═╡ 850c59a8-53c1-11ec-3946-9bfb4ac90252
md"""Consider the rational expression
"""

# ╔═╡ 850c59bc-53c1-11ec-040c-e57c24986258
md"""```math
\frac{17x^5 - 300x^4 - 1/2}{x^5 - 2x^4 + 3x^3 - 4x^2 + 5}.
```
"""

# ╔═╡ 850c59e2-53c1-11ec-275e-21740de85531
md"""The leading term of the numerator is $17x^5$ and the leading term of the denominator is $x^5$. The ratio is $17$ (or $17x^0 = 17x^{5-5}$). As such, we would have a horizontal asymptote $y=17$.
"""

# ╔═╡ 850c5a02-53c1-11ec-21d7-89bfefe3fe2a
md"""---
"""

# ╔═╡ 850c5a16-53c1-11ec-1fd2-3d93c56b3b8a
md"""If we consider instead this rational expression:
"""

# ╔═╡ 850c5a34-53c1-11ec-1e68-e3b723ca9a24
md"""```math
\frac{x^5 - 2x^4 + 3x^3 - 4x^2 + 5}{5x^4 + 4x^3 + 3x^2 + 2x + 1}
```
"""

# ╔═╡ 850c5a54-53c1-11ec-2e0e-09584ba5d49d
md"""Then we can see that the ratio of the leading terms is $x^5 / (5x^4) = (1/5)x$. We expect a slant asymptote with slope $1/5$, though we would need to divide to see the exact intercept. This is found with, say:
"""

# ╔═╡ 850c9cb0-53c1-11ec-1f40-714c35aa77bc
let
	p = (x^5 - 2x^4 + 3x^3 - 4x^2 + 5) / (5x^4 + 4x^3 + 3x^2 + 2x + 1)
	divrem(numerator(p), denominator(p))  # or apart(p)
end

# ╔═╡ 850c9cec-53c1-11ec-2b4b-a73182b437e5
md"""---
"""

# ╔═╡ 850c9d1e-53c1-11ec-1dd0-8529037bc8ed
md"""The rational function
"""

# ╔═╡ 850c9d32-53c1-11ec-1d20-cb15ff7cdce0
md"""```math
\frac{5x^3 + 6x^2 + 2}{x-1}
```
"""

# ╔═╡ 850c9d82-53c1-11ec-0f56-890df5b3dcfe
md"""has decomposition $5x^2 + 11x + 11 + 13/(x-1)$:
"""

# ╔═╡ 850ca476-53c1-11ec-0c9c-fb77a8601e4a
begin
	top = 5x^3 + 6x^2 +2
	bottom = x-1
	quo, rem = divrem(top, bottom)
end

# ╔═╡ 850ca4a8-53c1-11ec-1838-7766edb8d74a
md"""The graph of has nothing in common with the graph of the quotient for small $x$
"""

# ╔═╡ 850caa66-53c1-11ec-33da-77f06557782b
begin
	plot(top/bottom, -3, 3)
	plot!(quo, -3, 3)
end

# ╔═╡ 850caa98-53c1-11ec-063b-7f039e6096b9
md"""But the graphs do match for large $x$:
"""

# ╔═╡ 850caf70-53c1-11ec-210c-8f22917d1949
begin
	plot(top/bottom, 5, 10)
	plot!(quo, 5, 10)
end

# ╔═╡ 850caf84-53c1-11ec-215a-3f70c6cc4a98
md"""---
"""

# ╔═╡ 850caf98-53c1-11ec-17e9-c312bd0d1cd7
md"""Finally, consider this rational expression in factored form:
"""

# ╔═╡ 850cafb6-53c1-11ec-0f9f-219949258bd1
md"""```math
\frac{(x-2)^3\cdot(x-4)\cdot(x-3)}{(x-5)^4 \cdot (x-6)^2}.
```
"""

# ╔═╡ 850cafde-53c1-11ec-253e-41db74827eb4
md"""By looking at the powers we can see that the leading term of the numerator will the $x^5$ and the leading term of the denominator $x^6$. The ratio is $1/x^1$. As such, we expect the $y$-axis as a horizontal asymptote:
"""

# ╔═╡ 850cb060-53c1-11ec-13f4-454f9e72ffa9
md"""#### Partial fractions
"""

# ╔═╡ 850cb0ce-53c1-11ec-0c30-050d108f8367
md"""The `apart` function was useful to express a rational function in terms of a polynomial plus additional rational functions whose horizontal asymptotes are $0$.  This function computes the partial fraction [decomposition](https://en.wikipedia.org/wiki/Partial_fraction_decomposition) of a rational function. Outside of the initial polynomial, this decomposition is a reexpression of a rational function into a sum of rational functions, where the denominators are *irreducible*, or unable to be further factored (non-trivially) and the numerators have lower degree than the denominator. Hence the horizontal asymptotes of $0$.
"""

# ╔═╡ 850cb0e2-53c1-11ec-297e-11b424831ca7
md"""To see another example we have:
"""

# ╔═╡ 850cb6f8-53c1-11ec-0328-ff4ffb482ec8
let
	p = (x-1)*(x-2)
	q = (x-3)^3 * (x^2 - x - 1)
	apart(p/q)
end

# ╔═╡ 850cb72a-53c1-11ec-1c50-f1563966b932
md"""The denominator, $q$, has factors $x-3$ and $x^2 - x - 1$, each irreducible. The answer is expressed in terms of a sum of rational functions each with a denominator coming from one of these factors, possibly with a power.
"""

# ╔═╡ 850cb754-53c1-11ec-1784-3dd29f80a674
md"""### Vertical asymptotes
"""

# ╔═╡ 850cb772-53c1-11ec-3d3d-2d73ccd6e8d1
md"""As just discussed, the graph of $1/x$ will have a horizontal asymptote. However it will also show a spike at $0$:
"""

# ╔═╡ 850cbaec-53c1-11ec-376f-4382cfb3f0c8
plot(1/x, -1, 1)

# ╔═╡ 850cbb1e-53c1-11ec-3442-b97eba6b65e2
md"""Again, this spike is an artifact of the plotting algorithm. The $y$ values for $x$-values just smaller than $0$ are large negative values and the $x$ values just larger than $0$ produce large, positive $y$ values.
"""

# ╔═╡ 850cbb46-53c1-11ec-0146-f5e42384e983
md"""The two points with $x$ components closest to $0$ are connected with a line, though that is misleading.  Here we deliberately use far fewer points to plot $1/x$ to show how this happens:
"""

# ╔═╡ 850cbfb0-53c1-11ec-1b3f-7f822b3b9457
let
	f(x) = 1/x
	xs = range(-1, 1, length=12)
	ys = f.(xs)
	plot(xs, ys)
	scatter!(xs, ys)
end

# ╔═╡ 850cbff6-53c1-11ec-0e21-4d3568675112
md"""The line $x = 0$ is a *vertical asymptote* for the graph of $1/x$. As $x$ values get close to $0$ from the right, the $y$ values go towards $\infty$ and as the $x$ values get close to $0$ on the left, the $y$ values go towards $-\infty$.
"""

# ╔═╡ 850cc014-53c1-11ec-3a43-49b549e221ba
md"""This has everything to do with the fact that $0$ is a root of the denominator.
"""

# ╔═╡ 850cc032-53c1-11ec-3c22-47983de6d70b
md"""For a rational function $p(x)/q(x)$, the roots of $q(x)$ may or may not lead to vertical asymptotes. For a root $c$ if $p(c)$ is not zero then the line $x=c$ will be a vertical asymptote. If $c$ is a root of both $p(x)$ and $q(x)$, then we can rewrite the expression as:
"""

# ╔═╡ 850cc050-53c1-11ec-3718-293c46c35906
md"""```math
\frac{p(x)}{q(x)} = \frac{(x-c)^m r(x)}{(x-c)^n s(x)},
```
"""

# ╔═╡ 850cc06c-53c1-11ec-157a-fb97196750d1
md"""where both $r(c)$ and $s(c)$ are non zero. Knowing $m$ and $n$ (the multiplicities of the root $c$) allows the following to be said:
"""

# ╔═╡ 850cc1b8-53c1-11ec-0ba0-fb7bf74efcc3
md"""  * If $m < n$ then $x=c$ will be a vertical asymptote.
  * If $m \geq n$ then $x=c$ will not be vertical asymptote. (The value $c$ will be known as a removable singularity). In this case, the graph of $p(x)/q(x)$ and the graph of $(x-c)^{m-n}r(x)/s(x)$ will differ, as the latter will include a value for $x=c$, whereas $x=c$ is not in the domain of $p(x)/q(x)$.
"""

# ╔═╡ 850cc1f4-53c1-11ec-2bdb-d109718a9dba
md"""Finding the multiplicity may or may not be hard, but there is a very kludgy quick check that is often correct. With `Julia`, if you have a rational function that has `f(c)` evaluate to `Inf` or `-Inf` then there will be a vertical asymptote. If the expression evaluates to `NaN`, more analysis is needed. (The value of `0/0` is `NaN`, where as `1/0` is `Inf`.)
"""

# ╔═╡ 850cc212-53c1-11ec-041f-6b7f605e66cb
md"""For example, the function $f(x) = ((x-1)^2 \cdot (x-2)) / ((x+3) \cdot(x-3))$ has vertical asymptotes at $-3$ and $3$, as its graph illustrated. Without the graph we could see this as well:
"""

# ╔═╡ 850ce35a-53c1-11ec-3a14-e381f6d4c15c
let
	f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
	f(3), f(-3)
end

# ╔═╡ 850ce38c-53c1-11ec-39ac-e36119ec15f1
md"""#### Graphing with vertical asymptotes
"""

# ╔═╡ 850ce3be-53c1-11ec-3d9f-afbbba9818e6
md"""As seen in several graphs, the basic plotting algorithm does a poor job with vertical asymptotes. For example, it may erroneously connect their values with a steep vertical line, or the $y$-axis scale can get so large as to make reading the rest of the graph impossible. There are some tricks to work around this.
"""

# ╔═╡ 850ce3dc-53c1-11ec-3658-4f8748008237
md"""Consider again the function $f(x) = ((x-1)^2 \cdot (x-2)) / ((x+3) \cdot(x-3))$. Without much work, we can see that $x=3$ and $x=-3$ will be vertical asymptotes and there will be a slant asymptote with slope 1. How to graph this?
"""

# ╔═╡ 850ce3fa-53c1-11ec-2e9f-b322ea733ed6
md"""We can avoid the vertical asymptotes in our viewing window. For example we could look at the area between the vertical asymptotes, by plotting over $(-2.9, 2.9)$, say:
"""

# ╔═╡ 850d0ab0-53c1-11ec-1aa7-93b6bb9a92d7
begin
	𝒇(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
	plot(𝒇, -2.9, 2.9)
end

# ╔═╡ 850d0b00-53c1-11ec-3e02-d12dc39771ac
md"""This backs off by $\delta = 0.1$. As we have that $3 - 2.9$ is $\delta$ and $1/\delta$ is 10, the $y$ axis won't get too large, and indeed it doesn't.
"""

# ╔═╡ 850d0b1e-53c1-11ec-3ac1-a12339ac5f31
md"""This graph doesn't show well the two zeros at $x=1$ and $x=2$, for that a narrower viewing window is needed.  By successively panning throughout the interesting part of the graph, we can get a view of the function.
"""

# ╔═╡ 850d0b3e-53c1-11ec-17f9-394284e61ffe
md"""We can also clip the `y` axis. The `plot` function can be passed an argument `ylims=(lo, hi)` to limit which values are plotted. With this, we can have:
"""

# ╔═╡ 850d1170-53c1-11ec-3106-b5305e7958bb
let
	plot(𝒇, -5, 5, ylims=(-20, 20))
end

# ╔═╡ 850d1190-53c1-11ec-19cb-1d1877576199
md"""This isn't ideal, as the large values are still computed, just the viewing window is clipped. This leaves the vertical asymptotes still effecting the graph.
"""

# ╔═╡ 850d11c2-53c1-11ec-38be-23ea437b6dd0
md"""There is another way, we could ask `Julia` to not plot $y$ values that get too large. This is not a big request.  If instead of the value of `f(x)` - when it is large - -we use `NaN` instead, then the connect-the-dots algorithm will skip those values.
"""

# ╔═╡ 850d11e0-53c1-11ec-19c2-f50642bae23b
md"""This was discussed in an earlier section where the `rangeclamp` function was introduced to replace large values of `f(x)` (in absolute values) with `NaN`.
"""

# ╔═╡ 850d2d56-53c1-11ec-05b8-1576ad7c2937
plot(rangeclamp(𝒇, 30), -25, 25)  # rangeclamp is in the CalculusWithJulia package

# ╔═╡ 850d2d9e-53c1-11ec-3f0c-9f5f518f3ad2
md"""We can see the general shape of 3 curves broken up by the vertical asymptotes. The two on the side heading off towards the line $x-4$ and the one in the middle. We still can't see the precise location of the zeros, but that wouldn't be the case with most graphs that show asymptotic behaviors. However, we can clearly tell where to "zoom in" were those of interest.
"""

# ╔═╡ 850d2dba-53c1-11ec-3414-f56db0b5269f
md"""### Sign charts
"""

# ╔═╡ 850d2de2-53c1-11ec-2934-4f150c7d636c
md"""When sketching graphs of rational functions by hand, it is useful to use sign charts. A sign chart of a function indicates when the function is positive, negative, $0$, or undefined. It typically is represented along the lines of this one for $f(x) = x^3 - x$:
"""

# ╔═╡ 850d2e28-53c1-11ec-2ea0-33c0cef141fe
md"""```
    -    0   +   0   -   0   +
< ----- -1 ----- 0 ----- 1 ----- >
```"""

# ╔═╡ 850d2e3c-53c1-11ec-3d53-59d6eb133f00
md"""The usual recipe for construction follows these steps:
"""

# ╔═╡ 850d2f38-53c1-11ec-200c-63602efb48b6
md"""  * Identify when the function is $0$ or undefined. Place those values on a number line.
  * Identify "test points" within each implied interval (these are $(-\infty, -1)$, $(-1,0)$, $(0,1)$, and $(1, \infty)$ in the example) and check for the sign of $f(x)$ at these test points. Write in `-`, `+`, `0`, or `*`, as appropriate. The value comes from the fact that "continuous" functions may only change sign when they cross $0$ or are undefined.
"""

# ╔═╡ 850d2f5e-53c1-11ec-09ec-9b85b3d2cd50
md"""With the computer, where it is convenient to draw a graph, it might be better to emphasize the sign on the graph of the function. The `sign_chart` function from `CalculusWithJulia` does this by numerically identifying points where the function is $0$ or $\infty$ and indicating the sign as $x$ crosses over these points.
"""

# ╔═╡ 850de3ae-53c1-11ec-0583-29fe4f0588b0
# in CalculusWithJuia
function sign_chart(f, a, b; atol=1e-6)
    pm(x) = x < 0 ? "-" : x > 0 ? "+" : "0"
    summarize(f,cp,d) = (∞0=cp, sign_change=pm(f(cp-d)) * " → " * pm(f(cp+d)))

    zs = find_zeros(f, a, b)
    pts = vcat(a, zs, b)
    for (u,v) ∈ zip(pts[1:end-1], pts[2:end])
        zs′ = find_zeros(x -> 1/f(x), u, v)
        for z′ ∈ zs′
            flag = false
            for z ∈ zs
                if isapprox(z′, z, atol=atol)
                    flag = true
                    break
                end
            end
            !flag && push!(zs, z′)
        end
    end
    sort!(zs)

    length(zs) == 0 && return []
    m,M = extrema(zs)
    d = min((m-a)/2, (b-M)/2)
    if length(zs) > 0
        d′ = minimum(diff(zs))/2
        d = min(d, d′ )
    end
    summarize.(f, zs, d)
end

# ╔═╡ 850de980-53c1-11ec-1ab5-1d140b6f36ff
let
	f(x) = x^3 - x
	sign_chart(f, -3/2, 3/2)
end

# ╔═╡ 850de9c8-53c1-11ec-142f-21df2458dc66
md"""## Pade approximate
"""

# ╔═╡ 850dea28-53c1-11ec-334b-cf8081fd7acb
md"""One area where rational functions are employed is in approximating functions. Later, the Taylor polynomial will be seen to be a polynomial that approximates well a function (where "well" will be described later). The Pade approximation is similar, though uses a rational function for the form $p(x)/q(x)$, where $q(0)=1$ is customary.
"""

# ╔═╡ 850dea3e-53c1-11ec-0bea-c9925d6ee14a
md"""Some example approximations are
"""

# ╔═╡ 850dea70-53c1-11ec-017c-5d19b95a9fca
md"""```math
\sin(x) \approx \frac{x - 7/60 \cdot x^3}{1 + 1/20 \cdot x^2}
```
"""

# ╔═╡ 850dea84-53c1-11ec-013d-f17e1a20f08a
md"""and
"""

# ╔═╡ 850dea98-53c1-11ec-1ec9-795e8816f629
md"""```math
\tan(x) \approx \frac{x - 1/15 \cdot x^3}{1 - 2/5 \cdot x^2}
```
"""

# ╔═╡ 850deaac-53c1-11ec-2498-53ee319c8544
md"""We can look graphically at these approximations:
"""

# ╔═╡ 850df63e-53c1-11ec-094b-1da926ed87ea
begin
	sin_p(x) = (x - (7/60)*x^3) / (1 + (1/20)*x^2)
	tan_p(x) = (x - (1/15)*x^3) / (1 - (2/5)*x^2)
	plot(sin, -pi, pi)
	plot!(sin_p, -pi, pi)
end

# ╔═╡ 850dfdd0-53c1-11ec-0720-3767ff4c0d23
begin
	plot(tan, -pi/2 + 0.2, pi/2 - 0.2)
	plot!(tan_p, -pi/2 + 0.2, pi/2 - 0.2)
end

# ╔═╡ 850dfe0c-53c1-11ec-30af-45e8583a55d3
md"""## The `Polynomials` package for rational functions
"""

# ╔═╡ 850dfe3e-53c1-11ec-220f-f111fc9100a9
md"""In the following, we import some functions from the `Polynomials` package. We avoided loading the entire namespace, as there are conflicts with `SymPy`. Here we import some useful functions and the `Polynomial` constructor:
"""

# ╔═╡ 850e00dc-53c1-11ec-2fdc-bfe5cb13dff6
import Polynomials: Polynomial, variable, lowest_terms, fromroots, coeffs

# ╔═╡ 850e0104-53c1-11ec-03c6-a7e53df6362f
md"""The `Polynomials` package has support for rational functions. The `//` operator can be used to create rational expressions:
"""

# ╔═╡ 850e0514-53c1-11ec-2a69-8507708ce348
begin
	𝒙 = variable()
	𝒑 = (𝒙-1)*(𝒙-2)^2
	𝒒 = (𝒙-2)*(𝒙-3)
	𝒑𝒒 = 𝒑 // 𝒒
end

# ╔═╡ 850e053c-53c1-11ec-3c12-8d592ee3d1cd
md"""A rational expression is a formal object; a rational function the viewpoint that this object will be evaluated by substituting  values for the indeterminate. Rational expressions made within `Polynomials` are evaluated just like functions:
"""

# ╔═╡ 850e078a-53c1-11ec-009c-b3622feb8dca
𝒑𝒒(4)  # p(4)/q(4)

# ╔═╡ 850e07a8-53c1-11ec-1c5d-65eb67c0a86a
md"""The rational expressions are not in lowest terms unless requested through the `lowest_terms` method:
"""

# ╔═╡ 850e0926-53c1-11ec-2988-a508dd9a8717
lowest_terms(𝒑𝒒)

# ╔═╡ 850e0958-53c1-11ec-02d3-c791988d3a05
md"""For polynomials as simple as these, this computation is not a problem, but there is the very real possibility that the lowest term computation may be incorrect. Unlike `SymPy` which factors symbolically, `lowest_terms` uses a numeric algorithm and does not, as would be done by hand or with `SymPy`, factor the polynomial and then cancel common factors.
"""

# ╔═╡ 850e097e-53c1-11ec-272a-9bdb81b1838e
md"""The distinction between the two expressions is sometimes made; the initial expression is not defined at $x=2$; the reduced one is, so the two are not identical when viewed as functions of the variable $x$.
"""

# ╔═╡ 850e09b0-53c1-11ec-16c0-857598abbee1
md"""Rational expressions include polynomial expressions, just as the rational numbers include the integers. The identification there is to divide by $1$, thinking of $3$ as $3/1$. In `Julia`, we would just use
"""

# ╔═╡ 850e0c30-53c1-11ec-01f6-553758a745e8
3//1

# ╔═╡ 850e0c56-53c1-11ec-3a55-af922543d573
md"""The integer can be recovered from the rational number using `numerator`:
"""

# ╔═╡ 850e258a-53c1-11ec-1a92-4d9b1e1d0392
numerator(3//1)

# ╔═╡ 850e25da-53c1-11ec-2a50-09d907080620
md"""Similarly, we can divide a polynomial by the polynomial $1$, which in `Julia` is returned by `one(p)`, to produce a rational expression:
"""

# ╔═╡ 850e4100-53c1-11ec-145d-391694de214c
pp = 𝒑 // one(𝒑)

# ╔═╡ 850e413e-53c1-11ec-2ad7-591bb210112e
md"""And as with rational numbers, `p` is recovered by `numerator`:
"""

# ╔═╡ 850e4362-53c1-11ec-1d1a-f174c9cd0b0d
numerator(pp)

# ╔═╡ 850e439c-53c1-11ec-24d8-23ce9dff7faf
md"""One difference is the rational number `3//1` also represents other expressions, say `6/2` or `12/4`, as `Julia`'s rational numbers are presented in lowest terms, unlike the rational expressions in `Polynomials`.
"""

# ╔═╡ 850e43b2-53c1-11ec-0437-1d180830b62c
md"""Rational functions also have a plot recipe defined for them that attempts to ensure the basic features are identifiable. As previously discussed, a plot of a rational function can require some effort to avoid the values associated to vertical asymptotes taking up too many of the available vertical pixels in a graph.
"""

# ╔═╡ 850e43da-53c1-11ec-094b-bd00020bd962
md"""For the polynomial `pq` above, we have from observation that $1$ and $2$ will be zeros and $x=3$ a vertical asymptote. We also can identify a slant asymptote with slope $1$. These are hinted at in this graph:
"""

# ╔═╡ 850e456a-53c1-11ec-0ba9-1d758b3dc274
plot(𝒑𝒒)

# ╔═╡ 850e459c-53c1-11ec-0a91-7596bacc03b0
md"""To better see the zeros, a plot over a narrower interval, say $[0,2.5]$, would be encouraged; to better see the slant asymptote, a plot over a wider interval, say $[-10,10]$, would be encouraged.
"""

# ╔═╡ 850e45ba-53c1-11ec-0f6b-ada3c6816522
md"""For one more example of the default plot recipe, we redo the graphing of the rational expression we earlier plotted with `rangeclamp`:
"""

# ╔═╡ 850e4d9e-53c1-11ec-3415-cfc895e22fd6
let
	p,q = fromroots([1,1,2]), fromroots([-3,3])
	plot(p//q)
end

# ╔═╡ 850e4dda-53c1-11ec-10ce-bb397b49eb9b
md"""##### Example: transformations of polynomials; real roots
"""

# ╔═╡ 850e4dee-53c1-11ec-0e89-414d6d27e605
md"""We have seen some basic transformations of functions such as shifts and scales. For a polynomial expression we can implement these as follows, taking advantage of polynomial evaluation:
"""

# ╔═╡ 850e5186-53c1-11ec-3b3a-b365db974c74
let
	x = variable()
	p = 3 + 4x + 5x^2
	a = 2
	p(a*x), p(x+a) # scale, shift
end

# ╔═╡ 850e51ba-53c1-11ec-1975-1530133b340d
md"""A different polynomial transformation is inversion, or the mapping $x^d \cdot p(1/x)$ where $d$ is the degree of $p$. This will yield a polynomial, as perhaps this example will convince you:
"""

# ╔═╡ 850e574e-53c1-11ec-13bf-5f3a0a63043d
let
	p = Polynomial([1, 2, 3, 4, 5])
	d = Polynomials.degree(p)  # degree is in SymPy and Polynomials, indicate which
	pp = p // one(p)
	x = variable(pp)
	q = x^d * pp(1/x)
	lowest_terms(q)
end

# ╔═╡ 850e57f8-53c1-11ec-2ea1-8313b10f4b1c
md"""We had to use a rational expression so that division by the variable was possible. The above indicates that the new polynomial, $q$, is constructed from $p$ by **reversing** the coefficients.
"""

# ╔═╡ 850e582a-53c1-11ec-2a00-4972743152cf
md"""Inversion is like a funhouse mirror, flipping around parts of the polynomial. For example, the interval $[1/4,1/2]$ is related to the interval $[2,4]$. Of interest here, is that if $p(x)$ had a root, $r$, in $[1/4,1/2]$ then $q(x) = x^d \cdot p(1/x)$ would have a root in $[2,4]$ at $1/r$.
"""

# ╔═╡ 850e675c-53c1-11ec-2da7-894495ac20c1
md"""So these three transformations – scale, shift, and inversion – can be defined for polynomials.
"""

# ╔═╡ 850e67ca-53c1-11ec-197a-876f5f473728
md"""Combined, the three can be used to create a [Mobius transformation](https://en.wikipedia.org/wiki/M%C3%B6bius_transformation). For two values $a$ and $b$, consider the polynomial derived from $p$ (again `d=degree(p)`) by:
"""

# ╔═╡ 850e67de-53c1-11ec-1e51-e7c8894465b6
md"""```math
q = (x+1)^d \cdot p(\frac{ax + b}{x + 1}).
```
"""

# ╔═╡ 850e67fc-53c1-11ec-39bf-813bd70e3b9f
md"""Here is a non-performant implementation as a `Julia` function:
"""

# ╔═╡ 850e85ac-53c1-11ec-2f50-1fb961bfb26a
function mobius_transformation(p, a, b)
  x = variable(p)
  p = p(x + a)   # shift
  p = p((b-a)*x) # scale
  p = Polynomial(reverse(coeffs(p))) # invert
  p = p(x + 1)   # shift
  p
end

# ╔═╡ 850e85f2-53c1-11ec-1301-03c4e4353e96
md"""We can verify this does what we want through example with the previously defined `p`:
"""

# ╔═╡ 850ea118-53c1-11ec-1e13-d5af3651629a
md"""As contrasted with
"""

# ╔═╡ 850ea64a-53c1-11ec-2401-a7d66f179c47
md"""---
"""

# ╔═╡ 850ea65e-53c1-11ec-0b77-27a257a14b09
md"""Now, why is this of any interest?
"""

# ╔═╡ 850ea6b8-53c1-11ec-3441-2341a06a69fe
md"""Mobius transforms are used to map regions into other regions. In this special case, the transform $\phi(x) = (ax + b)/(x + 1)$ takes the interval $[0,\infty]$ and sends it to $[a,b]$  ($0$ goes to $(a\cdot 0 + b)/(0+1) = b$, whereas $\infty$ goes to $ax/x \rightarrow a$). Using this, if $p(u) = 0$, with $q(x) = (x-1)^d p(\phi(x))$,  then setting $u = \phi(x)$ we have $q(x) = (\phi^{-1}(u)+1)^d p(\phi(\phi^{-1}(u))) =  (\phi^{-1}(u)+1)^d \cdot  p(u) =  (\phi^{-1}(u)+1)^d \cdot 0 = 0$. That is, a zero of $p$ in $[a,b]$ will appear as a zero of $q$ in $[0,\infty)$ at $\phi^{-1}(u)$.
"""

# ╔═╡ 850ea728-53c1-11ec-0334-cbdfc15556ee
md"""The Descartes rule of signs applied to $q$ then will give a bound on the number of possible roots of $p$ in the interval $[a,b]$. In the example we did, the Mobius transform for $a=4, b=6$ is $15 - x - 11x^2 - 3x^3$ with $1$ sign change, so there must be exactly $1$ real root of $p=(x-1)(x-3)(x-5)$ in the interval $[4,6]$, as we can observe from the factored form of $p$.
"""

# ╔═╡ 850ea744-53c1-11ec-250b-59d2a5e09fd0
md"""Similarly, we can see there are $2$ or $0$ roots for $p$ in the interval $[2,6]$ by counting the two sign changes here:
"""

# ╔═╡ 850ea9ec-53c1-11ec-3824-5d134188a02c
md"""This observation, along with a detailed analysis provided by [Kobel, Rouillier, and Sagraloff](https://dl.acm.org/doi/10.1145/2930889.2930937) provides a means to find intervals that enclose the real roots of a polynomial.
"""

# ╔═╡ 850eaa32-53c1-11ec-3448-c3a2d93ada26
md"""The basic algorithm, as presented next, is fairly simple to understand, and hints at the bisection algorithm to come. It is due to Akritas and Collins. Suppose you know the only possible positive real roots are between $0$ and $M$ *and* no roots are repeated. Find the transformed polynomial over $[0,M]$:
"""

# ╔═╡ 850eab54-53c1-11ec-0da7-913ee2e5f6a0
md"""  * If there are no sign changes, then there are no roots of $p$ in $[0,M]$.
  * If there is one sign change, then there is a single root of $p$ in $[0,M]$. The interval $[0,M]$ is said to isolate the root (and the actual root can then be found by other means)
  * If there is more than one sign change, divide the interval in two ($[0,M/2]$ and $[M/2,M]$, say) and apply the same consideration to each.
"""

# ╔═╡ 850eab72-53c1-11ec-09e1-d352d020b8b9
md"""Eventually, **mathematically** this will find isolating intervals for each positive real root. (The negative ones can be similarly isolated.)
"""

# ╔═╡ 850eab8e-53c1-11ec-1eee-dde67be14e7c
md"""Applying these steps to $p$ with an initial interval, say $[0,9]$, we would have:
"""

# ╔═╡ 850eb0ea-53c1-11ec-35ed-91cb3ee0b148
let
	p = fromroots([1,3,5])               #  (x-1)⋅(x-3)⋅(x-5) = -15 + 23*x - 9*x^2 + x^3
	mobius_transformation(p, 0, 9) # 3
	mobius_transformation(p, 0, 9//2)    # 2
	mobius_transformation(p, 9//2, 9)    # 1 (and done)
	mobius_transformation(p, 0, 9//4)    # 1 (and done)
	mobius_transformation(p, 9//4, 9//2) # 1 (and done)
end

# ╔═╡ 850eb12e-53c1-11ec-1855-f5a543e1148e
md"""So the three roots ($1$, $3$, $5$) are isolated by $[0, 9/4]$, $[9/4, 9/2]$, and $[9/2, 9]$.
"""

# ╔═╡ 850eb16c-53c1-11ec-19fc-f933491ce31e
md"""### The `RealPolynomialRoots` package.
"""

# ╔═╡ 850eb194-53c1-11ec-3336-0300ee2de007
md"""For square-free polynomials, the `RealPolynomialRoots` package implements a basic version of the  paper of [Kobel, Rouillier, and Sagraloff](https://dl.acm.org/doi/10.1145/2930889.2930937) to identify the real roots of a polynomial using the Descartes rule of signs and the Möbius transformations just described.
"""

# ╔═╡ 850eb1b2-53c1-11ec-21fc-37c9a613b243
md"""The `ANewDsc` function takes a collection of coefficients representing a polynomial and returns isolating intervals for each real root. For example:
"""

# ╔═╡ 850eb6ce-53c1-11ec-17e2-f1f3b0cfd4eb
begin
	p₀ = fromroots([1,3,5])
	st = ANewDsc(coeffs(p₀))
end

# ╔═╡ 850eb6e4-53c1-11ec-287b-1f071bf3e9ae
md"""These intervals can be refined to give accurate approximations to the roots:
"""

# ╔═╡ 850eb8da-53c1-11ec-2681-55c713c3db73
refine_roots(st)

# ╔═╡ 850eb8f6-53c1-11ec-3ed2-6987f4ada52b
md"""More challenging problems can be readily handled by this package. The following polynomial
"""

# ╔═╡ 850ea618-53c1-11ec-0667-2f7e158bc2e0
let
	a, b = 4, 6
	
	pq = 𝐩 // one(𝐩)
	x = variable(pq)
	d = Polynomials.degree(𝐩)
	numerator(lowest_terms( (x + 1)^2 * pq((a*x + b)/(x + 1))))
end

# ╔═╡ 850ea9c6-53c1-11ec-1a4f-15a00dbf1ce6
mobius_transformation(𝐩, 2,6)

# ╔═╡ 850ebe32-53c1-11ec-2c06-a178cc5e742f
md"""has three real roots, two of which are clustered very close to each other:
"""

# ╔═╡ 850ec13e-53c1-11ec-1f81-095564830158
𝐬𝐭 = ANewDsc(coeffs(𝐩))

# ╔═╡ 850ec152-53c1-11ec-378c-13f3da57155c
md"""and
"""

# ╔═╡ 850ec2ba-53c1-11ec-3aa4-99552dba9350
refine_roots(𝐬𝐭)

# ╔═╡ 850ec300-53c1-11ec-3543-1b9ec20391d7
md"""The SymPy package (`sympy.real_roots`) can accurately identify the three roots but it can take a **very** long time. The `Polynomials.roots` function from the `Polynomials` package identifies the cluster as complex valued. Though the implementation in `RealPolynomialRoots` doesn't handle such large polynomials, the authors of the algorithm have implementations that can quickly solve polynomials with degrees as high as 10,000.
"""

# ╔═╡ 850ec31e-53c1-11ec-3be8-49ab555d3fc6
md"""## Questions
"""

# ╔═╡ 850ec396-53c1-11ec-3d6f-533c401fc5c3
md"""###### Question
"""

# ╔═╡ 850ec3be-53c1-11ec-2481-5118c9087737
md"""The rational expression $(x^3 - 2x + 3) / (x^2 - x + 1)$ would have
"""

# ╔═╡ 850ecbf4-53c1-11ec-26aa-6d11aa17e017
let
	choices = [L"A horizontal asymptote $y=0$",
	L"A horizontal asymptote $y=1$",
	L"A slant asymptote with slope $m=1$"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 850ecc10-53c1-11ec-1d90-8301b315d38f
md"""###### Question
"""

# ╔═╡ 850ecc2e-53c1-11ec-37f6-530856b58dff
md"""The rational expression $(x^2 - x + 1)/ (x^3 - 2x + 3)$ would have
"""

# ╔═╡ 850ed400-53c1-11ec-103c-e7ec1e9fcdb8
let
	choices = [L"A horizontal asymptote $y=0$",
	L"A horizontal asymptote $y=1$",
	L"A slant asymptote with slope $m=1$"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 850ed41c-53c1-11ec-2d34-471dd98cfa6f
md"""###### Question
"""

# ╔═╡ 850ed43a-53c1-11ec-109b-9994622fcde9
md"""The rational expression $(x^2 - x + 1)/ (x^2 - 3x + 3)$ would have
"""

# ╔═╡ 850edc32-53c1-11ec-1177-0fa37a2bea6f
let
	choices = [L"A horizontal asymptote $y=0$",
	L"A horizontal asymptote $y=1$",
	L"A slant asymptote with slope $m=1$"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 850edc50-53c1-11ec-11ae-cf2b364d607f
md"""###### Question
"""

# ╔═╡ 850edc5a-53c1-11ec-028e-7767b4319b08
md"""The rational expression
"""

# ╔═╡ 850edc78-53c1-11ec-30fa-2b87843d80d7
md"""```math
\frac{(x-1)\cdot(x-2)\cdot(x-3)}{(x-4)\cdot(x-5)\cdot(x-6)}
```
"""

# ╔═╡ 850edc8c-53c1-11ec-2fb7-29c1f67ca910
md"""would have
"""

# ╔═╡ 850ee498-53c1-11ec-0c90-97af4eb5cd61
let
	choices = [L"A horizontal asymptote $y=0$",
	L"A horizontal asymptote $y=1$",
	L"A slant asymptote with slope $m=1$"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 850ee4ae-53c1-11ec-1541-7b3b0e0555a3
md"""###### Question
"""

# ╔═╡ 850ee4c0-53c1-11ec-3a89-3f18071c17c4
md"""The rational expression
"""

# ╔═╡ 850ee4e0-53c1-11ec-2c1e-31c69234f46c
md"""```math
\frac{(x-1)\cdot(x-2)\cdot(x-3)}{(x-4)\cdot(x-5)\cdot(x-6)}
```
"""

# ╔═╡ 850ee4e8-53c1-11ec-0774-0d2a88e5303a
md"""would have
"""

# ╔═╡ 850eeccc-53c1-11ec-39ad-d9ac4513c2c6
let
	choices = [L"A vertical asymptote $x=1$",
	L"A slant asymptote with slope $m=1$",
	L"A vertical asymptote $x=5$"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 850eecec-53c1-11ec-2b04-fbef0897d15e
md"""###### Question
"""

# ╔═╡ 850eecfe-53c1-11ec-3574-1d33e6ac9fd9
md"""The rational expression
"""

# ╔═╡ 850eed12-53c1-11ec-208f-0f44fd1908a9
md"""```math
\frac{x^3 - 3x^2 + 2x}{3x^2 - 6x + 2}
```
"""

# ╔═╡ 850eed26-53c1-11ec-2382-bd5435a1146b
md"""has a slant asymptote. What is the equation of that line?
"""

# ╔═╡ 850ef3e8-53c1-11ec-1429-2545ab1e6838
let
	choices = [
	    "``y = 3x``",
	    "``y = (1/3)x``",
	    "``y = (1/3)x - (1/3)``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 850ef3fc-53c1-11ec-0b2a-37fad1960c98
md"""###### Question
"""

# ╔═╡ 850ef422-53c1-11ec-10bd-a77e1937c796
md"""Look at the graph of the function $f(x) = ((x-1)\cdot(x-2)) / ((x-3)\cdot(x-4))$
"""

# ╔═╡ 850efe60-53c1-11ec-1655-39f464093e96
let
	f(x) = ((x-1) * (x-2)) / ((x-3) *(x-4))
	delta = 1e-1
	col = :blue
	p = plot(f, -1, 3-delta, color=col, legend=false)
	plot!(p, f, 3+delta, 4-3delta, color=col)
	plot!(p,f, 4 + 5delta, 9, color=col)
	p
end

# ╔═╡ 850efe7e-53c1-11ec-23aa-c9e17644c904
md"""Is the following common conception true: "The graph of a function never crosses its asymptotes."
"""

# ╔═╡ 850f0574-53c1-11ec-2bb8-9d1c256b3db5
let
	choices = ["No, the graph clearly crosses the drawn asymptote",
	"Yes, this is true"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 850f059a-53c1-11ec-33a3-ad046fccae29
md"""(The wikipedia page indicates that the term "asymptote" was introduced by Apollonius of Perga in his work on conic sections, but in contrast to its modern meaning, he used it to mean any line that does not intersect the given curve. It can sometimes take a while to change perception.)
"""

# ╔═╡ 850f05b8-53c1-11ec-2458-65a4a6f1bf2f
md"""###### Question
"""

# ╔═╡ 850f05e0-53c1-11ec-2710-030595bea5bd
md"""Consider the two graphs of $f(x) = 1/x$ over $[10,20]$ and $[100, 200]$:
"""

# ╔═╡ 850f09d2-53c1-11ec-39ad-e95105a3f596
let
	plot(x -> 1/x, 10, 20)
end

# ╔═╡ 850f0db2-53c1-11ec-017e-73dde82e7bda
let
	plot(x -> 1/x, 100, 200)
end

# ╔═╡ 850f0de4-53c1-11ec-3804-61ba5de0ceba
md"""The two shapes are basically identical and do not look like straight lines. How does this reconcile with the fact that $f(x)=1/x$ has a horizontal asymptote $y=0$?
"""

# ╔═╡ 850f307e-53c1-11ec-0a18-e3e27cbb6013
let
	choices = ["The horizontal asymptote is not a straight line.",
	L"The $y$-axis scale shows that indeed the $y$ values are getting close to $0$.",
	L"The graph is always decreasing, hence it will eventually reach $-\infty$."
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 850f30a4-53c1-11ec-1f0a-4338f9aab93d
md"""###### Question
"""

# ╔═╡ 850f30ce-53c1-11ec-05f9-c32a6d9373c2
md"""The amount of drug in a bloodstream after $t$ hours is modeled by the rational function
"""

# ╔═╡ 850f30e2-53c1-11ec-0d33-a9dffafd605f
md"""```math
r(t) = \frac{50t^2}{t^3 + 20}, \quad t \geq  0.
```
"""

# ╔═╡ 850f3100-53c1-11ec-31b0-8f65ebb6f626
md"""What is the amount of the drug after $1$ hour?
"""

# ╔═╡ 850f37ac-53c1-11ec-3183-5fc64942da7e
r1(t) = 50t^2 / (t^3 + 20)

# ╔═╡ 850f3b5a-53c1-11ec-1309-dbdaa7bcaf75
let
	val = r1(1)
	numericq(val)
end

# ╔═╡ 850f3b78-53c1-11ec-0014-d33ab94e9d0a
md"""What is the amount of drug in the bloodstream after 24 hours?
"""

# ╔═╡ 850f3f58-53c1-11ec-2771-d91aa42da3d7
let
	val = r1(24)
	numericq(val)
end

# ╔═╡ 850f3f6a-53c1-11ec-2c49-59394d3e48a0
md"""What is more accurate: the peak amount is
"""

# ╔═╡ 850f572a-53c1-11ec-32f2-0bed57640884
let
	choices = ["between 0 and 8 hours", "between 8 and 16 hours", "between 16 and 24 hours", "after one day"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 850f5752-53c1-11ec-3b4e-954a7ba7e062
md"""This graph has
"""

# ╔═╡ 850f6170-53c1-11ec-0761-a5d9a8670bda
let
	choices = [L"a slant asymptote with slope $50$",
	L"a horizontal asymptote $y=20$",
	L"a horizontal asymptote $y=0$",
	L"a vertical asymptote with $x = 20^{1/3}$"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 850f618e-53c1-11ec-03f1-8901fdc81fa0
md"""###### Question
"""

# ╔═╡ 850f61d4-53c1-11ec-15a6-9d4ff133bb6a
md"""The (low-order) Pade approximation for $\sin(x)$ was seen to be $(x - 7/60 \cdot x^3)/(1 + 1/20 \cdot x^2)$. The graph showed that this approximation was fairly close over $[-\pi, \pi]$. Without graphing would you expect the behaviour of the function and its approximation to be similar for *large* values of $x$?
"""

# ╔═╡ 850f63c8-53c1-11ec-39f1-3194271268ab
let
	yesnoq(false)
end

# ╔═╡ 850f63dc-53c1-11ec-333c-7f92d3d0084e
md"""Why?
"""

# ╔═╡ 850f7322-53c1-11ec-3b78-317e71c652c5
let
	choices = [
	L"The $\sin(x)$ oscillates, but the rational function eventually follows $7/60 \cdot x^3$",
	L"The $\sin(x)$ oscillates, but the rational function has a slant asymptote",
	L"The $\sin(x)$ oscillates, but the rational function has a non-zero horizontal asymptote",
	L"The $\sin(x)$ oscillates, but the rational function has a horizontal asymptote of $0$"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 850f7354-53c1-11ec-2484-d1dc21548be2
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/polynomials_package.html">◅ previous</a>  <a href="../precalc/exp_log_functions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/rational_functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 850f735e-53c1-11ec-3581-63b678782ea2
PlutoUI.TableOfContents()

# ╔═╡ 850ebe1e-53c1-11ec-0ab7-cde749ee140c
begin
	𝐱 = Polynomial([0,1]) # also just variable(Polynomial{Int})
	𝐩 = -1 + 254*𝐱 - 16129*𝐱^2 + 𝐱^15
end

# ╔═╡ 850ea0f0-53c1-11ec-2a62-1949532e6cd5
begin
	𝐩 = Polynomial([1, 2, 3, 4, 5])
	𝐪 = mobius_transformation(𝐩, 4, 5)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
RealPolynomialRoots = "87be438c-38ae-47c4-9398-763eabe5c3be"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Polynomials = "~2.0.18"
RealPolynomialRoots = "~0.1.0"
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

[[deps.ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[deps.Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

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

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

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

[[deps.Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "79bcbb379205f1c62913fa9ebecb413c7a35f8b0"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.18"

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

[[deps.RealPolynomialRoots]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "aa5acc17f15ff874bea3dc4edea424ea93e7256f"
uuid = "87be438c-38ae-47c4-9398-763eabe5c3be"
version = "0.1.0"

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

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

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
# ╟─850f732c-53c1-11ec-2732-39f5bad92666
# ╟─850b2998-53c1-11ec-1b4d-51ecf243e6e6
# ╟─850b2a06-53c1-11ec-01bf-1fa0294989c2
# ╠═850b5e72-53c1-11ec-134d-6d9997587c43
# ╟─850b6e10-53c1-11ec-1138-75ee793c1fe9
# ╟─850b73e4-53c1-11ec-2d15-35344b8695c6
# ╟─850b74b4-53c1-11ec-2f34-dfa53d80ee7f
# ╟─850b74d4-53c1-11ec-2afb-e1d0585ccda8
# ╟─850b752e-53c1-11ec-3f7c-f3cc78d2eefc
# ╟─850b75a6-53c1-11ec-28da-c30586919e77
# ╟─850b75bc-53c1-11ec-00b3-c1a734541d9c
# ╟─850b78d0-53c1-11ec-32e3-d381933dd523
# ╟─850b78da-53c1-11ec-08f0-7196b41b1579
# ╟─850b7970-53c1-11ec-2dd0-9becd62a4333
# ╟─850b7984-53c1-11ec-294f-1fd8436b95bd
# ╟─850b7a06-53c1-11ec-3a70-ddd4f5eadbde
# ╟─850b7a10-53c1-11ec-3d35-f9a59175b89a
# ╟─850b7a1a-53c1-11ec-0062-a9d7c9e8e116
# ╟─850b7a74-53c1-11ec-3ec2-25cb15cbbe8a
# ╠═850b8bfe-53c1-11ec-3db1-1d8ae14c45d3
# ╟─850b8c38-53c1-11ec-0a8f-899f813441c0
# ╟─850b8c58-53c1-11ec-1508-791467c4ece3
# ╠═850b909a-53c1-11ec-0796-5341450567b6
# ╟─850b90cc-53c1-11ec-34c1-ebe1e934bf43
# ╟─850b913a-53c1-11ec-302e-65ac05e1ec09
# ╟─850b914e-53c1-11ec-0e37-015d43c54832
# ╟─850b9174-53c1-11ec-0f9f-6d78effccbff
# ╟─850b918a-53c1-11ec-2d03-bb19aee881dc
# ╟─850b9202-53c1-11ec-0729-031a6ce6fdb9
# ╟─850b9266-53c1-11ec-2bdc-4b9f18d59c25
# ╟─850b927c-53c1-11ec-26fe-8db87f8c6149
# ╟─850b928e-53c1-11ec-2c27-592f043a5726
# ╠═850b975c-53c1-11ec-384a-95f0577371b5
# ╟─850b97ca-53c1-11ec-3a22-8f91dad5bcd9
# ╟─850b97de-53c1-11ec-2022-cd3c5025d570
# ╟─850b97f2-53c1-11ec-0b1e-2115ba9b8da4
# ╟─850b9818-53c1-11ec-13fc-fff011550ce0
# ╠═850b9c5c-53c1-11ec-29a1-d9f597ea356f
# ╟─850b9c7a-53c1-11ec-2d82-87aac18549a8
# ╠═850b9e78-53c1-11ec-016b-61c5254c8149
# ╟─850b9e96-53c1-11ec-2f87-4338ecd9bc63
# ╠═850ba8f8-53c1-11ec-3dde-ef4d21566a00
# ╟─850ba936-53c1-11ec-3b50-51183b884cdc
# ╠═850c53fe-53c1-11ec-132e-85fa1d585444
# ╟─850c549e-53c1-11ec-2c8b-d304dd11a50f
# ╟─850c5520-53c1-11ec-2bfe-798592ecbdd8
# ╟─850c5552-53c1-11ec-3f44-e1d591519395
# ╠═850c5728-53c1-11ec-0285-d33cb52d8da7
# ╟─850c5750-53c1-11ec-01b1-b124d7f7fa3a
# ╟─850c576e-53c1-11ec-364e-13836ab27102
# ╟─850c57a0-53c1-11ec-3d2e-9b12f869ade4
# ╟─850c57b6-53c1-11ec-3354-11ab732afb74
# ╟─850c5926-53c1-11ec-0cbf-37167f52dea9
# ╟─850c5962-53c1-11ec-1168-61937109f758
# ╟─850c5994-53c1-11ec-3328-1f713102658b
# ╟─850c59a8-53c1-11ec-3946-9bfb4ac90252
# ╟─850c59bc-53c1-11ec-040c-e57c24986258
# ╟─850c59e2-53c1-11ec-275e-21740de85531
# ╟─850c5a02-53c1-11ec-21d7-89bfefe3fe2a
# ╟─850c5a16-53c1-11ec-1fd2-3d93c56b3b8a
# ╟─850c5a34-53c1-11ec-1e68-e3b723ca9a24
# ╟─850c5a54-53c1-11ec-2e0e-09584ba5d49d
# ╠═850c9cb0-53c1-11ec-1f40-714c35aa77bc
# ╟─850c9cec-53c1-11ec-2b4b-a73182b437e5
# ╟─850c9d1e-53c1-11ec-1dd0-8529037bc8ed
# ╟─850c9d32-53c1-11ec-1d20-cb15ff7cdce0
# ╟─850c9d82-53c1-11ec-0f56-890df5b3dcfe
# ╠═850ca476-53c1-11ec-0c9c-fb77a8601e4a
# ╟─850ca4a8-53c1-11ec-1838-7766edb8d74a
# ╠═850caa66-53c1-11ec-33da-77f06557782b
# ╟─850caa98-53c1-11ec-063b-7f039e6096b9
# ╠═850caf70-53c1-11ec-210c-8f22917d1949
# ╟─850caf84-53c1-11ec-215a-3f70c6cc4a98
# ╟─850caf98-53c1-11ec-17e9-c312bd0d1cd7
# ╟─850cafb6-53c1-11ec-0f9f-219949258bd1
# ╟─850cafde-53c1-11ec-253e-41db74827eb4
# ╟─850cb060-53c1-11ec-13f4-454f9e72ffa9
# ╟─850cb0ce-53c1-11ec-0c30-050d108f8367
# ╟─850cb0e2-53c1-11ec-297e-11b424831ca7
# ╠═850cb6f8-53c1-11ec-0328-ff4ffb482ec8
# ╟─850cb72a-53c1-11ec-1c50-f1563966b932
# ╟─850cb754-53c1-11ec-1784-3dd29f80a674
# ╟─850cb772-53c1-11ec-3d3d-2d73ccd6e8d1
# ╠═850cbaec-53c1-11ec-376f-4382cfb3f0c8
# ╟─850cbb1e-53c1-11ec-3442-b97eba6b65e2
# ╟─850cbb46-53c1-11ec-0146-f5e42384e983
# ╠═850cbfb0-53c1-11ec-1b3f-7f822b3b9457
# ╟─850cbff6-53c1-11ec-0e21-4d3568675112
# ╟─850cc014-53c1-11ec-3a43-49b549e221ba
# ╟─850cc032-53c1-11ec-3c22-47983de6d70b
# ╟─850cc050-53c1-11ec-3718-293c46c35906
# ╟─850cc06c-53c1-11ec-157a-fb97196750d1
# ╟─850cc1b8-53c1-11ec-0ba0-fb7bf74efcc3
# ╟─850cc1f4-53c1-11ec-2bdb-d109718a9dba
# ╟─850cc212-53c1-11ec-041f-6b7f605e66cb
# ╠═850ce35a-53c1-11ec-3a14-e381f6d4c15c
# ╟─850ce38c-53c1-11ec-39ac-e36119ec15f1
# ╟─850ce3be-53c1-11ec-3d9f-afbbba9818e6
# ╟─850ce3dc-53c1-11ec-3658-4f8748008237
# ╟─850ce3fa-53c1-11ec-2e9f-b322ea733ed6
# ╠═850d0ab0-53c1-11ec-1aa7-93b6bb9a92d7
# ╟─850d0b00-53c1-11ec-3e02-d12dc39771ac
# ╟─850d0b1e-53c1-11ec-3ac1-a12339ac5f31
# ╟─850d0b3e-53c1-11ec-17f9-394284e61ffe
# ╠═850d1170-53c1-11ec-3106-b5305e7958bb
# ╟─850d1190-53c1-11ec-19cb-1d1877576199
# ╟─850d11c2-53c1-11ec-38be-23ea437b6dd0
# ╟─850d11e0-53c1-11ec-19c2-f50642bae23b
# ╠═850d2d56-53c1-11ec-05b8-1576ad7c2937
# ╟─850d2d9e-53c1-11ec-3f0c-9f5f518f3ad2
# ╟─850d2dba-53c1-11ec-3414-f56db0b5269f
# ╟─850d2de2-53c1-11ec-2934-4f150c7d636c
# ╟─850d2e28-53c1-11ec-2ea0-33c0cef141fe
# ╟─850d2e3c-53c1-11ec-3d53-59d6eb133f00
# ╟─850d2f38-53c1-11ec-200c-63602efb48b6
# ╟─850d2f5e-53c1-11ec-09ec-9b85b3d2cd50
# ╟─850de3ae-53c1-11ec-0583-29fe4f0588b0
# ╠═850de980-53c1-11ec-1ab5-1d140b6f36ff
# ╟─850de9c8-53c1-11ec-142f-21df2458dc66
# ╟─850dea28-53c1-11ec-334b-cf8081fd7acb
# ╟─850dea3e-53c1-11ec-0bea-c9925d6ee14a
# ╟─850dea70-53c1-11ec-017c-5d19b95a9fca
# ╟─850dea84-53c1-11ec-013d-f17e1a20f08a
# ╟─850dea98-53c1-11ec-1ec9-795e8816f629
# ╟─850deaac-53c1-11ec-2498-53ee319c8544
# ╠═850df63e-53c1-11ec-094b-1da926ed87ea
# ╠═850dfdd0-53c1-11ec-0720-3767ff4c0d23
# ╟─850dfe0c-53c1-11ec-30af-45e8583a55d3
# ╟─850dfe3e-53c1-11ec-220f-f111fc9100a9
# ╠═850e00dc-53c1-11ec-2fdc-bfe5cb13dff6
# ╟─850e0104-53c1-11ec-03c6-a7e53df6362f
# ╠═850e0514-53c1-11ec-2a69-8507708ce348
# ╟─850e053c-53c1-11ec-3c12-8d592ee3d1cd
# ╠═850e078a-53c1-11ec-009c-b3622feb8dca
# ╟─850e07a8-53c1-11ec-1c5d-65eb67c0a86a
# ╠═850e0926-53c1-11ec-2988-a508dd9a8717
# ╟─850e0958-53c1-11ec-02d3-c791988d3a05
# ╟─850e097e-53c1-11ec-272a-9bdb81b1838e
# ╟─850e09b0-53c1-11ec-16c0-857598abbee1
# ╠═850e0c30-53c1-11ec-01f6-553758a745e8
# ╟─850e0c56-53c1-11ec-3a55-af922543d573
# ╠═850e258a-53c1-11ec-1a92-4d9b1e1d0392
# ╟─850e25da-53c1-11ec-2a50-09d907080620
# ╠═850e4100-53c1-11ec-145d-391694de214c
# ╟─850e413e-53c1-11ec-2ad7-591bb210112e
# ╠═850e4362-53c1-11ec-1d1a-f174c9cd0b0d
# ╟─850e439c-53c1-11ec-24d8-23ce9dff7faf
# ╟─850e43b2-53c1-11ec-0437-1d180830b62c
# ╟─850e43da-53c1-11ec-094b-bd00020bd962
# ╠═850e456a-53c1-11ec-0ba9-1d758b3dc274
# ╟─850e459c-53c1-11ec-0a91-7596bacc03b0
# ╟─850e45ba-53c1-11ec-0f6b-ada3c6816522
# ╠═850e4d9e-53c1-11ec-3415-cfc895e22fd6
# ╟─850e4dda-53c1-11ec-10ce-bb397b49eb9b
# ╟─850e4dee-53c1-11ec-0e89-414d6d27e605
# ╠═850e5186-53c1-11ec-3b3a-b365db974c74
# ╟─850e51ba-53c1-11ec-1975-1530133b340d
# ╠═850e574e-53c1-11ec-13bf-5f3a0a63043d
# ╟─850e57f8-53c1-11ec-2ea1-8313b10f4b1c
# ╟─850e582a-53c1-11ec-2a00-4972743152cf
# ╟─850e675c-53c1-11ec-2da7-894495ac20c1
# ╟─850e67ca-53c1-11ec-197a-876f5f473728
# ╟─850e67de-53c1-11ec-1e51-e7c8894465b6
# ╟─850e67fc-53c1-11ec-39bf-813bd70e3b9f
# ╠═850e85ac-53c1-11ec-2f50-1fb961bfb26a
# ╟─850e85f2-53c1-11ec-1301-03c4e4353e96
# ╠═850ea0f0-53c1-11ec-2a62-1949532e6cd5
# ╟─850ea118-53c1-11ec-1e13-d5af3651629a
# ╠═850ea618-53c1-11ec-0667-2f7e158bc2e0
# ╟─850ea64a-53c1-11ec-2401-a7d66f179c47
# ╟─850ea65e-53c1-11ec-0b77-27a257a14b09
# ╟─850ea6b8-53c1-11ec-3441-2341a06a69fe
# ╟─850ea728-53c1-11ec-0334-cbdfc15556ee
# ╟─850ea744-53c1-11ec-250b-59d2a5e09fd0
# ╠═850ea9c6-53c1-11ec-1a4f-15a00dbf1ce6
# ╟─850ea9ec-53c1-11ec-3824-5d134188a02c
# ╟─850eaa32-53c1-11ec-3448-c3a2d93ada26
# ╟─850eab54-53c1-11ec-0da7-913ee2e5f6a0
# ╟─850eab72-53c1-11ec-09e1-d352d020b8b9
# ╟─850eab8e-53c1-11ec-1eee-dde67be14e7c
# ╠═850eb0ea-53c1-11ec-35ed-91cb3ee0b148
# ╟─850eb12e-53c1-11ec-1855-f5a543e1148e
# ╟─850eb16c-53c1-11ec-19fc-f933491ce31e
# ╟─850eb194-53c1-11ec-3336-0300ee2de007
# ╟─850eb1b2-53c1-11ec-21fc-37c9a613b243
# ╠═850eb6ce-53c1-11ec-17e2-f1f3b0cfd4eb
# ╟─850eb6e4-53c1-11ec-287b-1f071bf3e9ae
# ╠═850eb8da-53c1-11ec-2681-55c713c3db73
# ╟─850eb8f6-53c1-11ec-3ed2-6987f4ada52b
# ╠═850ebe1e-53c1-11ec-0ab7-cde749ee140c
# ╟─850ebe32-53c1-11ec-2c06-a178cc5e742f
# ╠═850ec13e-53c1-11ec-1f81-095564830158
# ╟─850ec152-53c1-11ec-378c-13f3da57155c
# ╠═850ec2ba-53c1-11ec-3aa4-99552dba9350
# ╟─850ec300-53c1-11ec-3543-1b9ec20391d7
# ╟─850ec31e-53c1-11ec-3be8-49ab555d3fc6
# ╟─850ec396-53c1-11ec-3d6f-533c401fc5c3
# ╟─850ec3be-53c1-11ec-2481-5118c9087737
# ╟─850ecbf4-53c1-11ec-26aa-6d11aa17e017
# ╟─850ecc10-53c1-11ec-1d90-8301b315d38f
# ╟─850ecc2e-53c1-11ec-37f6-530856b58dff
# ╟─850ed400-53c1-11ec-103c-e7ec1e9fcdb8
# ╟─850ed41c-53c1-11ec-2d34-471dd98cfa6f
# ╟─850ed43a-53c1-11ec-109b-9994622fcde9
# ╟─850edc32-53c1-11ec-1177-0fa37a2bea6f
# ╟─850edc50-53c1-11ec-11ae-cf2b364d607f
# ╟─850edc5a-53c1-11ec-028e-7767b4319b08
# ╟─850edc78-53c1-11ec-30fa-2b87843d80d7
# ╟─850edc8c-53c1-11ec-2fb7-29c1f67ca910
# ╟─850ee498-53c1-11ec-0c90-97af4eb5cd61
# ╟─850ee4ae-53c1-11ec-1541-7b3b0e0555a3
# ╟─850ee4c0-53c1-11ec-3a89-3f18071c17c4
# ╟─850ee4e0-53c1-11ec-2c1e-31c69234f46c
# ╟─850ee4e8-53c1-11ec-0774-0d2a88e5303a
# ╟─850eeccc-53c1-11ec-39ad-d9ac4513c2c6
# ╟─850eecec-53c1-11ec-2b04-fbef0897d15e
# ╟─850eecfe-53c1-11ec-3574-1d33e6ac9fd9
# ╟─850eed12-53c1-11ec-208f-0f44fd1908a9
# ╟─850eed26-53c1-11ec-2382-bd5435a1146b
# ╟─850ef3e8-53c1-11ec-1429-2545ab1e6838
# ╟─850ef3fc-53c1-11ec-0b2a-37fad1960c98
# ╟─850ef422-53c1-11ec-10bd-a77e1937c796
# ╟─850efe60-53c1-11ec-1655-39f464093e96
# ╟─850efe7e-53c1-11ec-23aa-c9e17644c904
# ╟─850f0574-53c1-11ec-2bb8-9d1c256b3db5
# ╟─850f059a-53c1-11ec-33a3-ad046fccae29
# ╟─850f05b8-53c1-11ec-2458-65a4a6f1bf2f
# ╟─850f05e0-53c1-11ec-2710-030595bea5bd
# ╟─850f09d2-53c1-11ec-39ad-e95105a3f596
# ╟─850f0db2-53c1-11ec-017e-73dde82e7bda
# ╟─850f0de4-53c1-11ec-3804-61ba5de0ceba
# ╟─850f307e-53c1-11ec-0a18-e3e27cbb6013
# ╟─850f30a4-53c1-11ec-1f0a-4338f9aab93d
# ╟─850f30ce-53c1-11ec-05f9-c32a6d9373c2
# ╟─850f30e2-53c1-11ec-0d33-a9dffafd605f
# ╟─850f3100-53c1-11ec-31b0-8f65ebb6f626
# ╟─850f37ac-53c1-11ec-3183-5fc64942da7e
# ╟─850f3b5a-53c1-11ec-1309-dbdaa7bcaf75
# ╟─850f3b78-53c1-11ec-0014-d33ab94e9d0a
# ╟─850f3f58-53c1-11ec-2771-d91aa42da3d7
# ╟─850f3f6a-53c1-11ec-2c49-59394d3e48a0
# ╟─850f572a-53c1-11ec-32f2-0bed57640884
# ╟─850f5752-53c1-11ec-3b4e-954a7ba7e062
# ╟─850f6170-53c1-11ec-0761-a5d9a8670bda
# ╟─850f618e-53c1-11ec-03f1-8901fdc81fa0
# ╟─850f61d4-53c1-11ec-15a6-9d4ff133bb6a
# ╟─850f63c8-53c1-11ec-39f1-3194271268ab
# ╟─850f63dc-53c1-11ec-333c-7f92d3d0084e
# ╟─850f7322-53c1-11ec-3b78-317e71c652c5
# ╟─850f7354-53c1-11ec-2484-d1dc21548be2
# ╟─850f7354-53c1-11ec-2a9e-c3534dfb16f8
# ╟─850f735e-53c1-11ec-3581-63b678782ea2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
