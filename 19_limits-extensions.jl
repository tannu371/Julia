### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 98dd17be-539f-11ec-2e52-7765436dfacd
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 98dd1bb0-539f-11ec-0eb6-6f6965bf7709
begin
	using CalculusWithJulia.WeaveSupport
	using DataFrames
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 98e3f0fc-539f-11ec-249e-a72375a3c68d
using PlutoUI

# ╔═╡ 98e3f0ca-539f-11ec-06fa-5d869da7bd89
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 98dcf87e-539f-11ec-0ab4-81ba14d77f53
md"""# Limits, issues, extensions of the concept
"""

# ╔═╡ 98dcf964-539f-11ec-1ca8-efd65312d3e0
md"""This section uses the following add-on packages:
"""

# ╔═╡ 98dd1c3c-539f-11ec-151e-2d08b6a903ec
md"""---
"""

# ╔═╡ 98dd1cc8-539f-11ec-2d69-4177808929e3
md"""The limit of a function at $c$ need not exist for one of many different reasons. Some of these reasons can be handled with extensions to the concept of the limit, others are just problematic in terms of limits. This section covers examples of each.
"""

# ╔═╡ 98dd1cdc-539f-11ec-1771-b393d01fe0dd
md"""Let's begin with a function that is just problematic. Consider
"""

# ╔═╡ 98dd1dd6-539f-11ec-00e7-554c6fa48c0c
md"""```math
f(x) = \sin(1/x)
```
"""

# ╔═╡ 98dd1e12-539f-11ec-0f40-1977306af354
md"""As this is a composition of nice functions it will have a limit everywhere except possibly when $x=0$, as then $1/x$ may not have a limit. So rather than talk about where it is nice, let's consider the question of whether a limit exists at $c=0$.
"""

# ╔═╡ 98dd1e1a-539f-11ec-22ec-af3641a637b2
md"""A graph shows the issue:
"""

# ╔═╡ 98dd4626-539f-11ec-3cee-d15a32285679
let
	f(x) = sin(1/x)
	plot(f, range(-1, stop=1, length=1000))
end

# ╔═╡ 98dd46ec-539f-11ec-3d47-d151edc6f020
md"""The graph oscillates between $-1$ and $1$ infinitely many times on this interval - so many times, that no matter how close one zooms in, the graph on the screen will fail to capture them all. Graphically, there is no single value of $L$ that the function gets close to, as it varies between all the values in $[-1,1]$ as $x$ gets close to $0$. A simple proof that there is no limit, is to take any $\epsilon$ less than $1$, then with any $\delta > 0$, there are infinitely many $x$ values where $f(x)=1$ and infinitely many where $f(x) = -1$. That is, there is no $L$ with $|f(x) - L| < \epsilon$ when $\epsilon$ is less than $1$ for all $x$ near $0$.
"""

# ╔═╡ 98dd472a-539f-11ec-304e-8ba7294e6ab0
md"""This function basically has too many values it gets close to. Another favorite example of such a function is the function that is $0$ if $x$ is rational and $1$ if not. This function will have no limit anywhere, not just at $0$, and for basically the same reason as above.
"""

# ╔═╡ 98dd475c-539f-11ec-1df0-735af4ee5845
md"""The issue isn't oscillation though. Take, for example, the function $f(x) = x \cdot \sin(1/x)$. This function again has a limit everywhere save possibly $0$. But in this case, there is a limit at $0$ of $0$. This is because, the following is true:
"""

# ╔═╡ 98dd477a-539f-11ec-0c9d-adfe861c21c8
md"""```math
-|x| \leq x \sin(1/x) \leq |x|.
```
"""

# ╔═╡ 98dd4798-539f-11ec-09a7-2793bae1b3b0
md"""The following figure illustrates:
"""

# ╔═╡ 98dd4fc2-539f-11ec-0746-ad95f5e3b61e
let
	f(x) = x * sin(1/x)
	plot(f, -1, 1)
	plot!(abs)
	plot!(x -> -abs(x))
end

# ╔═╡ 98dd50ee-539f-11ec-0f69-e36ef5f820e9
md"""The [squeeze](http://en.wikipedia.org/wiki/Squeeze_theorem) theorem of calculus is the formal reason $f$ has a limit at $0$, as as both the upper function, $|x|$, and the lower function, $-|x|$, have a limit of $0$ at $0$.
"""

# ╔═╡ 98dd521a-539f-11ec-1ad1-9d3886797f11
md"""## Right and left limits
"""

# ╔═╡ 98dd5256-539f-11ec-0337-33ec5418dc7c
md"""Another example where $f(x)$ has no limit is the  function $f(x) = x /|x|, x \neq 0$. This function is $-1$ for negative $x$ and $1$ for positive $x$. Again, this function will have a limit everywhere except possibly at $x=0$, where division by $0$ is possible.
"""

# ╔═╡ 98dd526a-539f-11ec-1e9a-69097e248edb
md"""It's graph is
"""

# ╔═╡ 98dd56fc-539f-11ec-1d81-63dfd6cf2a33
let
	f(x) = abs(x)/x
	plot(f, -2, 2)
end

# ╔═╡ 98dd5742-539f-11ec-155c-7dadec1094d1
md"""The sharp jump at $0$ is misleading - again, the plotting algorithm just connects the points, it doesn't handle what is a fundamental discontinuity well - the function is not defined at $0$ and jumps from $-1$ to $1$ there. Similarly to our example of $\sin(1/x)$, near $0$ the function get's close to both $1$ and $-1$, so will have no limit. (Again, just take $\epsilon$ smaller than $1$.)
"""

# ╔═╡ 98dd5788-539f-11ec-25ef-cf78e5a3773d
md"""But unlike the previous example, this function *would* have a limit if the definition didn't consider values of $x$ on both sides of $c$. The limit on the right side would be $1$, the limit on the left side would be $-1$. This distinction is useful, so there is an extension of the idea of a limit to *one-sided limits*.
"""

# ╔═╡ 98dd5792-539f-11ec-19e5-599c95e1ea33
md"""Let's loosen up the language in the definition of a limit to read:
"""

# ╔═╡ 98dd5a76-539f-11ec-34bd-dd968fdc8607
md"""> The limit of $f(x)$ as $x$ approaches $c$ is $L$ if for every  neighborhood, $V$, of $L$ there is a neighborhood, $U$, of $c$ for  which $f(x)$ is in $V$ for every $x$ in $U$, except possibly $x=c$.

"""

# ╔═╡ 98dd5aa8-539f-11ec-08d6-73b44ce5bab4
md"""The $\epsilon-\delta$ definition has $V = (L-\epsilon, L + \epsilon)$ and $U=(c-\delta, c+\delta)$. This is a rewriting of $L-\epsilon < f(x) < L + \epsilon$ as $|f(x) - L| < \epsilon$.
"""

# ╔═╡ 98dd5ab2-539f-11ec-0967-bf3055281c1b
md"""Now for the defintion:
"""

# ╔═╡ 98dd5b2a-539f-11ec-207f-fb973c3c3426
md"""> A function $f(x)$ has a limit on the right of $c$, written $\lim_{x  \rightarrow c+}f(x) = L$ if for every $\epsilon > 0$, there exists a  $\delta > 0$ such that whenever $0 < x - c < \delta$ it holds that  $|f(x) - L| < \epsilon$. That is, $U$ is $(c, c+\delta)$

"""

# ╔═╡ 98dd5b40-539f-11ec-15b2-a73b80dd35f5
md"""Similarly, a limit on the left is defined where $U=(c-\delta, c)$.
"""

# ╔═╡ 98dd5b84-539f-11ec-1330-e5ebc2e6ed5d
md"""The `SymPy` function `limit` has a keyword argument `dir="+"` or `dir="-"` to request that a one-sided limit be formed. The default is `dir="+"`. Passing `dir="+-"` will compute both one side limits, and throw an error if the two are not equal, in agreement with no limit existing.
"""

# ╔═╡ 98dd73b2-539f-11ec-0759-11a0ed926ec5
@syms x

# ╔═╡ 98dd7860-539f-11ec-1a9d-f35168a037e4
let
	f(x) = abs(x)/x
	limit(f(x), x=>0, dir="+"), limit(f(x), x=>0, dir="-")
end

# ╔═╡ 98dd812c-539f-11ec-3f2a-f70f5bf98973
alert("""
That means the mathematical limit need not exist when `SymPy`'s `limit` returns an answer, as `SymPy` is only carrying out a one sided limit. Explicitly passing `dir="+-"` or checking that both `limit(ex, x=>c)` and `limit(ex, x=>c, dir="-")` are equal would be needed to confirm a limit exists mathematically.
""")

# ╔═╡ 98dd8174-539f-11ec-2bac-49ff33df2d7f
md"""The relation between the two concepts is that a function has a limit at $c$ if an only if the left and right limits exist and are equal. This function $f$ has both existing, but the two limits are not equal.
"""

# ╔═╡ 98dd8186-539f-11ec-1caa-ab6793702825
md"""There are other such functions that jump. Another useful one is the floor function, which just rounds down to the nearest integer. A graph shows the basic shape:
"""

# ╔═╡ 98dd85ac-539f-11ec-342c-3f733bafc6cb
plot(floor, -5,5)

# ╔═╡ 98dd85d2-539f-11ec-081f-7d0773a3e8bf
md"""Again, the (nearly) vertical lines are an artifact of the graphing algorithm and not actual points that solve $y=f(x)$. The floor function has limits except at the integers. There the left and right limits differ.
"""

# ╔═╡ 98dd8604-539f-11ec-043f-e708960cd552
md"""Consider the limit at $c=0$. If $0 < x < 1/2$, say, then $f(x) = 0$ as we round down, so the right limit will be $0$. However, if $-1/2 < x < 0$, then the $f(x) = -1$, again as we round down, so the left limit will be $-1$. Again, with this example both the left and right limits exists, but at the integer values they are not equal, as they differ by 1.
"""

# ╔═╡ 98dd862c-539f-11ec-32e8-77802b1444be
md"""Some functions only have one-sided limits as they are not defined in an interval around $c$. There are many examples, but we will take $f(x) = x^x$ and consider $c=0$. This function is not well defined for all $x < 0$, so it is typical to just take the domain to be $x > 0$. Still it has a right limit $\lim_{x \rightarrow 0+} x^x = 1$. `SymPy` can verify:
"""

# ╔═╡ 98dd8ab4-539f-11ec-13ff-87be20f4e50d
limit(x^x, x, 0, dir="+")

# ╔═╡ 98dd8adc-539f-11ec-3643-a7c3f514847b
md"""This agrees with the IEEE convention of assigning `0^0` to be `1`.
"""

# ╔═╡ 98dd8b72-539f-11ec-0e04-6f7da0a98211
md"""However, not all such functions with indeterminate forms of $0^0$ will have a limit of $1$.
"""

# ╔═╡ 98dd8c58-539f-11ec-2071-17c0f3e48514
md"""##### Example
"""

# ╔═╡ 98dd8c76-539f-11ec-262d-c143fa545233
md"""Consider this funny graph:
"""

# ╔═╡ 98dd9e66-539f-11ec-1118-1fb056109aa1
let
	xs = range(0,stop=1, length=50)
	
	plot(x->x^2, -2, -1, legend=false)
	plot!(exp, -1,0)
	plot!(x -> 1-2x, 0, 1)
	plot!(sqrt, 1, 2)
	plot!(x -> 1-x, 2,3)
end

# ╔═╡ 98dd9ebe-539f-11ec-0674-9b3e32fc2c49
md"""Describe the limits at $-1$, $0$, and $1$.
"""

# ╔═╡ 98dda09e-539f-11ec-3b6f-b3ce1cdef293
md"""  * At $-1$ we see a jump, there is no limit but instead a left limit of 1 and a right limit appearing to be $1/2$.
  * At $0$ we see a limit of $1$.
  * Finally, at $1$ again there is a jump, so no limit. Instead the left limit is about $-1$ and the right limit $1$.
"""

# ╔═╡ 98dda0c6-539f-11ec-3149-45077d07bb29
md"""## Limits at infinity
"""

# ╔═╡ 98dda104-539f-11ec-017b-cd395bf65e5c
md"""The loose definition of a horizontal asymptote is "a line such that the distance between the curve and the line approaches $0$ as they tend to infinity." This sounds like it should be defined by a limit. The issue is, that the limit would be at $\pm\infty$ and not some finite $c$. This requires the idea of a neighborhood of $c$, $0 < |x-c| < \delta$ to be reworked.
"""

# ╔═╡ 98dda12a-539f-11ec-1931-9169975dcce5
md"""The basic idea for a limit at $+\infty$ is that for any $\epsilon$, there exists an $M$ such that when $x > M$ it must be that $|f(x) - L| < \epsilon$. For a horizontal asymptote, the line would be $y=L$. Similarly a limit at $-\infty$ can be defined with $x < M$ being the condition.
"""

# ╔═╡ 98dda13e-539f-11ec-268a-09db5008d2c1
md"""Let's consider some cases.
"""

# ╔═╡ 98dda15c-539f-11ec-3e5b-b369f81a4f41
md"""The function $f(x) = \sin(x)$ will not have a limit at $+\infty$ for exactly the same reason that $f(x) = \sin(1/x)$ does not have a limit at $c=0$ - it just oscillates between $-1$ and $1$ so never eventually gets close to a single value.
"""

# ╔═╡ 98dda1ac-539f-11ec-1222-1714797f772f
md"""`SymPy` gives an odd answer here indicating the range of values:
"""

# ╔═╡ 98dda6f2-539f-11ec-0b5d-8935703546f5
limit(sin(x), x => oo)

# ╔═╡ 98dda736-539f-11ec-16dc-8ba3397519fb
md"""(We used `SymPy`'s `oo` for $\infty$ and not `Inf`.)
"""

# ╔═╡ 98dda756-539f-11ec-0779-2927d9ebe8a9
md"""---
"""

# ╔═╡ 98dda774-539f-11ec-253e-535ddf48277b
md"""However, a damped oscillation, such as $f(x) = e^{-x} \sin(x)$ will have a limit:
"""

# ╔═╡ 98ddad50-539f-11ec-330d-5768001a695d
limit(exp(-x)*sin(x), x => oo)

# ╔═╡ 98ddad6e-539f-11ec-237c-b33b6b26826a
md"""---
"""

# ╔═╡ 98ddad96-539f-11ec-0a4a-ad78d390ada4
md"""We have rational functions will have the expected limit. In this example $m = n$, so we get a horizontal asymptote that is not $y=0$:
"""

# ╔═╡ 98ddfa9e-539f-11ec-1fc8-bbbf0fb56ce5
limit((x^2 - 2x +2)/(4x^2 + 3x - 2), x=>oo)

# ╔═╡ 98ddfac6-539f-11ec-2d57-7ffde38b3def
md"""---
"""

# ╔═╡ 98ddfb0c-539f-11ec-1991-65a0fed41050
md"""Though rational functions can have only one (at most) horizontal asymptote, this isn't true for all functions. Consider the following $f(x) = x / \sqrt{x^2 + 4}$. It has different limits depending if $x$ goes to $\intfy$ or negative $\infty$:
"""

# ╔═╡ 98de01a6-539f-11ec-2a10-fd1891a011a6
let
	f(x) = x / sqrt(x^2 + 4)
	limit(f(x), x=>oo), limit(f(x), x=>-oo)
end

# ╔═╡ 98de01e2-539f-11ec-348a-8321aa7f0608
md"""(A simpler example showing this behavior is just the function $x/|x|$ considered earlier.)
"""

# ╔═╡ 98de0214-539f-11ec-0ad7-43424c20b508
md"""##### Example: Limits at infinity and right limits at $0$
"""

# ╔═╡ 98de0228-539f-11ec-05d0-137f0dfbb58c
md"""Given a function $f$ the question of whether this exists:
"""

# ╔═╡ 98de0252-539f-11ec-3b83-47afdf116ac5
md"""```math
\lim_{x \rightarrow \infty} f(x)
```
"""

# ╔═╡ 98de025a-539f-11ec-0973-4d74de4aeecd
md"""can be reduced to the question of whether this limit exists:
"""

# ╔═╡ 98de026e-539f-11ec-3ffa-917b38fb0409
md"""```math
\lim_{x \rightarrow 0+} f(1/x)
```
"""

# ╔═╡ 98de028c-539f-11ec-3b5a-c30e2c2b3a9d
md"""So whether $\lim_{x \rightarrow 0+} \sin(1/x)$ exists is equivalent to whether  $\lim_{x\rightarrow \infty} \sin(x)$ exists, which clearly does not due to the oscillatory nature of $\sin(x)$.
"""

# ╔═╡ 98de0296-539f-11ec-3284-8be2f9261276
md"""Similarly, one can make this reduction
"""

# ╔═╡ 98de02aa-539f-11ec-0a9f-99eb6884fa83
md"""```math
\lim_{x \rightarrow c+} f(x) =
\lim_{x \rightarrow 0+} f(c + x) =
\lim_{x \rightarrow \infty} f(c + \frac{1}{x}).
```
"""

# ╔═╡ 98de02be-539f-11ec-2880-2bdd5e1a0f80
md"""That is, right limits can be analyzed as limits at $\infty$ or right limits at $0$, should that prove more convenient.
"""

# ╔═╡ 98de02dc-539f-11ec-23d3-796adc94fff3
md"""## Limits of infinity
"""

# ╔═╡ 98de034a-539f-11ec-367a-c93fe38761ff
md"""Vertical asymptotes are nicely defined with horizontal asymptotes by the graph getting close to some line. However, the formal definition of a limit won't be the same. For a vertical asymptote, the value of $f(x)$ heads towards positive or negative infinity, not some finite $L$. As such, a neighborhood like $(L-\epsilon, L+\epsilon)$ will no longer make sense, rather we replace it with an expression like $(M, \infty)$ or $(-\infty, M)$. As in: the limit of $f(x)$ as $x$ approaches $c$ is *infinity* if for every $M > 0$ there exists a $\delta>0$ such that if $0 < |x-c| < \delta$ then $f(x) > M$. Approaching $-\infty$ would conclude with $f(x) < -M$ for all $M>0$.
"""

# ╔═╡ 98de035e-539f-11ec-245a-9996f5778ae6
md"""##### Examples
"""

# ╔═╡ 98de039a-539f-11ec-313f-1b923f3439b8
md"""Consider the function $f(x) = 1/x^2$. This will have a limit at every point except possibly $0$, where division by $0$ is possible. In this case, there is a vertical asymptote, as seen in the following graph. The limit at $0$ is $\infty$, in the extended sense above. For $M>0$, we can take any $0 < \delta < 1/\sqrt{M}$. The following graph shows $M=25$ where the function values are outside of the box, as $f(x) > M$ for those $x$ values with $0 < |x-0| < 1/\sqrt{M}$.
"""

# ╔═╡ 98de09e4-539f-11ec-3449-311bf9d9cc8b
let
	f(x) = 1/x^2
	M = 25
	delta = 1/sqrt(M)
	
	f(x) = 1/x^2 > 50 ? NaN : 1/x^2
	plot(f, -1, 1, legend=false)
	plot!([-delta, delta],	[M,M], color=colorant"orange")
	plot!([-delta, -delta], [0,M], color=colorant"red")
	plot!([delta, delta], [0,M], color=colorant"red")
end

# ╔═╡ 98de0a20-539f-11ec-0904-dbe6c917d4ae
md"""---
"""

# ╔═╡ 98de0a7a-539f-11ec-169f-a97e1e63a882
md"""The function $f(x)=1/x$ requires us to talk about left and right limits of infinity, with the natural generalization. We can see that the left limit at $0$ is $-\infty$ and the right limit $\infty$:
"""

# ╔═╡ 98de11be-539f-11ec-3e37-cf518c5a0e3c
let
	f(x) = 1/x
	plot(f, 1/50, 1,    color=:blue, legend=false)
	plot!(f, -1, -1/50, color=:blue)
end

# ╔═╡ 98de1204-539f-11ec-114b-7f06e32f60a6
md"""`SymPy` agrees:
"""

# ╔═╡ 98de1a88-539f-11ec-324e-b3e0c0c1567a
let
	f(x) = 1/x
	limit(f(x), x=>0, dir="-"), limit(f(x), x=>0, dir="+")
end

# ╔═╡ 98de1ab0-539f-11ec-26d5-abc0a066ccaa
md"""---
"""

# ╔═╡ 98de1b3e-539f-11ec-3381-8dc3f5d1dcfe
md"""Consider the function $g(x) = x^x(1 + \log(x)), x > 0$. Does this have a *right* limit at $0$?
"""

# ╔═╡ 98de1b96-539f-11ec-085c-d99df6ac91d9
md"""A quick graph shows that a limit may be $-\infty$:
"""

# ╔═╡ 98de2f1e-539f-11ec-3136-8fba5b51aff7
begin
	g(x) = x^x * (1 + log(x))
	plot(g, 1/100, 1)
end

# ╔═╡ 98de2f82-539f-11ec-36f2-573a54d64f28
md"""We can check with `SymPy`:
"""

# ╔═╡ 98de3702-539f-11ec-18b1-3f309123b861
limit(g(x), x=>0, dir="+")

# ╔═╡ 98de375c-539f-11ec-3bd8-8d531870b834
md"""## Limits of sequences
"""

# ╔═╡ 98de37ac-539f-11ec-1de5-1f61cdfd1ef5
md"""After all this, we still can't formalize the basic question asked in the introduction to limits: what is the area contained in a parabola. For that we developed a sequence of sums: $s_n = 1/2 \dot((1/4)^0 + (1/4)^1 + (1/4)^2 + \cdots + (1/4)^n)$. This isn't a function of $x$, but rather depends only on non-negative integer values of $n$. However, the same idea as a limit at infinity can be used to define a limit.
"""

# ╔═╡ 98de3946-539f-11ec-1b48-e55ccc3b975f
md"""> Let $a_0,a_1, a_2, \dots, a_n, \dots$ be a sequence of values indexed by $n$. We have $\lim_{n \rightarrow \infty} a_n = L$ if for every $\epsilon > 0$ there exists an $M>0$ where if $n > M$ then $|a_n - L| < \epsilon$.

"""

# ╔═╡ 98de3994-539f-11ec-205a-919bd863238a
md"""Common language is the sequence *converges* when the limit exists and otherwise *diverges*.
"""

# ╔═╡ 98de39be-539f-11ec-0f2d-670e088a3f93
md"""The above is essentially the same as a limit *at* infinity for a function, but in this case the function's domain is only the non-negative integers.
"""

# ╔═╡ 98de39f8-539f-11ec-3a45-331a88b635f9
md"""`SymPy` is happy to compute limits of sequences. Defining this one involving a sum is best done with the `summation` function:
"""

# ╔═╡ 98de5908-539f-11ec-390c-7dac12e9d5fe
begin
	@syms i::integer n::(integer, positive)
	s(n) = 1//2 * summation((1//4)^i, (i, 0, n))    # rationals make for an exact answer
	limit(s(n), n=>oo)
end

# ╔═╡ 98de5976-539f-11ec-0f42-c1e3013feac6
md"""##### Example
"""

# ╔═╡ 98de5994-539f-11ec-24be-f7bd9a2e1444
md"""The limit
"""

# ╔═╡ 98de59c6-539f-11ec-1af0-3562f9550b07
md"""```math
\lim_{x \rightarrow 0} \frac{e^x - 1}{x} = 1,
```
"""

# ╔═╡ 98de5a02-539f-11ec-0b13-2f697aca0d0a
md"""is an important limit. Using the definition of $e^x$ by an infinite sequence:
"""

# ╔═╡ 98de5a20-539f-11ec-0fa7-a758cae646d4
md"""```math
e^x = \lim_{n \rightarrow \infty} (1 + \frac{x}{n})^n,
```
"""

# ╔═╡ 98de5a34-539f-11ec-3cf8-070a0b5b28f6
md"""we can establish the limit using the squeeze theorem. First,
"""

# ╔═╡ 98de5a52-539f-11ec-052f-99e4c8d5feea
md"""```math
A = |(1 + \frac{x}{n})^2 - 1 - x| = |\Sigma_{k=0}^n {n \choose k}(\frac{x}{n})^k - 1 - x| = |\Sigma_{k=2}^n {n \choose k}(\frac{x}{n})^k|,
```
"""

# ╔═╡ 98de5a70-539f-11ec-0e79-8d8d0d98f4a3
md"""the first two sums cancelling off. The above comes from the binomial expansion theorem for a polynomial. Now ${n \choose k} \leq n^k$so we have
"""

# ╔═╡ 98de5a84-539f-11ec-034e-07408604e81d
md"""```math
A \leq \Sigma_{k=2}^n |x|^k = |x|^2 \frac{1 - |x|^{n+1}}{1 - |x|} \leq
\frac{|x|^2}{1 - |x|}.
```
"""

# ╔═╡ 98de5abe-539f-11ec-2b92-0ff120d1cb37
md"""using the *geometric* sum formula with $x \approx 0$ (and not $1$):
"""

# ╔═╡ 98de6182-539f-11ec-0478-3be8f50708b1
let
	@syms x n i
	summation(x^i, (i,0,n))
end

# ╔═╡ 98de61d2-539f-11ec-1363-8de561dec16f
md"""As this holds for all $n$, as $n$ goes to $\infty$ we have:
"""

# ╔═╡ 98de61f0-539f-11ec-321a-c518b38b930e
md"""```math
|e^x - 1 - x| \leq \frac{|x|^2}{1 - |x|}
```
"""

# ╔═╡ 98de622c-539f-11ec-3c03-c5f2b102f413
md"""Dividing both sides by $x$ and noting that as $x \rightarrow 0$, $|x|/(1-|x|)$ goes to $0$ by continuity, the squeeze theorem gives the limit:
"""

# ╔═╡ 98de6240-539f-11ec-349a-1feb46fabe44
md"""```math
\lim_{x \rightarrow 0} \frac{e^x -1}{x} - 1 = 0.
```
"""

# ╔═╡ 98de62ae-539f-11ec-1fa5-47aa9c8948ca
md"""That ${n \choose k} \leq n^k$ can be viewed as the left side counts the number of combinations of $k$ choices from $n$ distinct items, which is less than the number of permutations of $k$ choices, which is less than the number of choices of $k$ items from $n$ distinct ones without replacement – what $n^k$ counts.
"""

# ╔═╡ 98de6376-539f-11ec-1cad-d93b85e57303
md"""### Some limit theorems for sequences
"""

# ╔═╡ 98de63a0-539f-11ec-1693-4147d7236f67
md"""The limit discussion first defined limits of scalar univariate functions at a point $c$ and then added generalizations. The pedagogical approach can be reversed by starting the discussion with limits of sequences and then generalizing from there. This approach relies on a few theorems to be gathered along the way that are mentioned here for the curious reader:
"""

# ╔═╡ 98de6568-539f-11ec-32a7-f50c147b25f8
md"""  * Convergent sequences are bounded.
  * All *bounded* monotone sequences converge.
  * Every bounded sequence has a convergent subsequence. (Bolzano-Weirstrass)
  * The limit of $f$ at $c$ exists and equals $L$ if and only if for *every* sequence $x_n$ in the domain of $f$ converging to $c$ the sequence $s_n = f(x_n)$ converges to $L$.
"""

# ╔═╡ 98de659a-539f-11ec-3408-dd3c20fa49d6
md"""## Summary
"""

# ╔═╡ 98de65ba-539f-11ec-348c-6f446507a295
md"""The following table captures the various changes to the definition of the limit to accommodate some of the possible behaviors.
"""

# ╔═╡ 98de76a4-539f-11ec-3738-4324d462d72a
begin
	limit_type=[
	"limit",
	"right limit",
	"left limit",
	L"limit at $\infty$",
	L"limit at $-\infty$",
	L"limit of $\infty$",
	L"limit of $-\infty$",
	"limit of a sequence"
	]
	
	Notation=[
	L"\lim_{x\rightarrow c}f(x) = L",
	L"\lim_{x\rightarrow c+}f(x) = L",
	L"\lim_{x\rightarrow c-}f(x) = L",
	L"\lim_{x\rightarrow \infty}f(x) = L",
	L"\lim_{x\rightarrow -\infty}f(x) = L",
	L"\lim_{x\rightarrow c}f(x) = \infty",
	L"\lim_{x\rightarrow c}f(x) = -\infty",
	L"\lim_{n \rightarrow \infty} a_n = L"
	]
	
	Vs = [
	L"(L-\epsilon, L+\epsilon)",
	L"(L-\epsilon, L+\epsilon)",
	L"(L-\epsilon, L+\epsilon)",
	L"(L-\epsilon, L+\epsilon)",
	L"(L-\epsilon, L+\epsilon)",
	L"(M, \infty)",
	L"(-\infty, M)",
	L"(L-\epsilon, L+\epsilon)"
	]
	
	Us = [
	L"(c - \delta, c+\delta)",
	L"(c, c+\delta)",
	L"(c - \delta, c)",
	L"(M, \infty)",
	L"(-\infty, M)",
	L"(c - \delta, c+\delta)",
	L"(c - \delta, c+\delta)",
	L"(M, \infty)"
	]
	
	d = DataFrame(Type=limit_type, Notation=Notation, V=Vs, U=Us)
	table(d)
end

# ╔═╡ 98e07742-539f-11ec-32bc-e9f8f42cef3d
md"""[Ross](https://doi.org/10.1007/978-1-4614-6271-2) summarizes this by enumerating the 15 different *related* definitions for $\lim_{x \rightarrow a} f(x) = L$ that arise from $L$ being either finite, $-\infty$, or $+\infty$ and $a$ being any of $c$, $c-$, $c+$, $-\infty$, or $+\infty$.
"""

# ╔═╡ 98e07792-539f-11ec-394e-cd1a7962f01c
md"""## Rates of growth
"""

# ╔═╡ 98e077d8-539f-11ec-1731-d7c043e83ea6
md"""Consider two functions $f$ and $g$ to be *comparable* if there are positive integers $m$ and $n$ with *both*
"""

# ╔═╡ 98e0781e-539f-11ec-2455-c18cca85546f
md"""```math
\lim_{x \rightarrow \infty} \frac{f(x)^m}{g(x)} = \infty \quad\text{and }
\lim_{x \rightarrow \infty} \frac{g(x)^n}{f(x)} = \infty.
```
"""

# ╔═╡ 98e0783c-539f-11ec-293a-45b5d3f36201
md"""The first says $g$ is eventually bounded by a power of $f$, the second that $f$ is eventually bounded by a power of $g$.
"""

# ╔═╡ 98e07858-539f-11ec-1f11-a354176d0553
md"""Here we consider which families of functions are *comparable*.
"""

# ╔═╡ 98e07878-539f-11ec-3d26-f18fef6e01c2
md"""First consider $f(x) = x^3$ and $g(x) = x^4$. We can take $m=2$ and $n=1$ to verify $f$ and $g$ are comparable:
"""

# ╔═╡ 98e0817e-539f-11ec-0567-69e4b4c86d5c
begin
	fx, gx = x^3, x^4
	limit(fx^2/gx, x=>oo), limit(gx^1 / fx, x=>oo)
end

# ╔═╡ 98e0826e-539f-11ec-2bb8-458cc64daab8
md"""Similarly for any pairs of powers, so we could conclude $f(x) = x^n$ and $g(x) =x^m$ are comparable. (However, as is easily observed, for $m$ and $n$ both positive integers $\lim_{x \rightarrow \infty} x^{m+n}/x^m = \infty$ and $\lim_{x \rightarrow \infty} x^{m}/x^{m+n} = 0$, consistent with our discussion on rational functions that higher-order polynomials dominate lower-order polynomials.)
"""

# ╔═╡ 98e082b4-539f-11ec-0b32-7f9423750df4
md"""Now consider $f(x) = x$ and $g(x) = \log(x)$. These are not compatible as there will be no $n$ large enough. We might say $x$ dominates $\log(x)$.
"""

# ╔═╡ 98e08796-539f-11ec-1ea4-4fc84b48ee5d
limit(log(x)^n / x, x => oo)

# ╔═╡ 98e087d0-539f-11ec-31c4-93910047e655
md"""As $x$ could be replaced by any monomial $x^k$, we can say "powers" grow faster than "logarithms".
"""

# ╔═╡ 98e087f0-539f-11ec-29c6-d55340900476
md"""Now consider $f(x)=x$ and $g(x) = e^x$. These are not compatible as there will be no $m$ large enough:
"""

# ╔═╡ 98e08c28-539f-11ec-315c-89e121ff444c
begin
	@syms m::(positive, integer)
	limit(x^m / exp(x), x => oo)
end

# ╔═╡ 98e08c50-539f-11ec-23b6-cb7aaf6eafcb
md"""That is $e^x$ grows faster than any power of $x$.
"""

# ╔═╡ 98e08c82-539f-11ec-3a8e-5f85519b5918
md"""Now, if $a, b > 1$ then $f(x) = a^x$ and $g(x) = b^x$ will be comparable. Take $m$ so that $a^m > b$ and $n$ so that $b^n > x$ as then, say,
"""

# ╔═╡ 98e08ca0-539f-11ec-1087-0f47c6477488
md"""```math
\frac{(a^x)^m}{b^x} = \frac{a^{xm}}{b^x} = \frac{(a^m)^x}{b^x} = (\frac{a^m}{b})^x,
```
"""

# ╔═╡ 98e08cb4-539f-11ec-117d-712fcd24bd6c
md"""which will go to $\infty$ as $x \rightarrow \infty$ as $a^m/b > 1$.
"""

# ╔═╡ 98e08cd2-539f-11ec-214b-c3f72c640ac0
md"""Finally, consider $f(x) = \exp(x^2)$ and $g(x) = \exp(x)^2$. Are these comparable? No, as no $n$ is large enough:
"""

# ╔═╡ 98e09144-539f-11ec-37a7-97adc25818f9
let
	@syms x n::(positive, integer)
	fx, gx = exp(x^2), exp(x)^2
	limit(gx^n / fx, x => oo)
end

# ╔═╡ 98e0915a-539f-11ec-2558-f1e0185bf80f
md"""A negative test for compatability is the following: if
"""

# ╔═╡ 98e0916e-539f-11ec-2bde-9541ec9c7af8
md"""```math
\lim_{x \rightarrow \infty} \frac{\log(|f(x)|)}{\log(|g(x)|)} = 0,
```
"""

# ╔═╡ 98e091a0-539f-11ec-1cc8-2f7df77ca5e0
md"""Then $f$ and $g$ are not compatible (and $g$ grows faster than $f$. Applying this to the last two values of $f$ and $g$, we have
"""

# ╔═╡ 98e091b4-539f-11ec-0cc6-c7335f4e0d69
md"""```math
\lim_{x \rightarrow \infty}\frac{\log(\exp(x)^2)}{\log(\exp(x^2))} =
\lim_{x \rightarrow \infty}\frac{2\log(\exp(x))}{x^2} =
\lim_{x \rightarrow \infty}\frac{2x}{x^2} = 0,
```
"""

# ╔═╡ 98e091c8-539f-11ec-3137-2b97250f5c5c
md"""so $f(x) = \exp(x^2)$ grows faster than $g(x) = \exp(x)^2$.
"""

# ╔═╡ 98e091f0-539f-11ec-0174-cd09832aef3d
md"""---
"""

# ╔═╡ 98e0920e-539f-11ec-3ef9-5da525c42f95
md"""Keeping in mind that logarithms grow slower than powers which grow slower than exponentials ($a > 1$) can help understand growth at $\infty$ as a comparison of leading terms does for rational functions.
"""

# ╔═╡ 98e09222-539f-11ec-2232-47872c8fdeeb
md"""We can immediately put this to use to compute $\lim_{x\rightarrow 0+} x^x$. We first express this problem using $x^x = (\exp(\ln(x)))^x = e^{x\ln(x)}$. Rewriting $u(x) = \exp(\ln(u(x)))$, which only uses the basic inverse relation between the two functions, can often be a useful step.
"""

# ╔═╡ 98e09254-539f-11ec-3151-d9ba5ae287b0
md"""As $f(x) = e^x$ is a suitably nice function (continuous) so that the limit of a composition can be computed through the limit of the inside function, $x\ln(x)$, it is enough to see what $\lim_{x\rightarrow 0+} x\ln(x)$ is. We *re-express* this as a limit at $\infty$
"""

# ╔═╡ 98e09268-539f-11ec-30f8-abf5c1d9e964
md"""```math
\lim_{x\rightarrow 0+} x\ln(x) = \lim_{x \rightarrow \infty} (1/x)\ln(1/x) =
\lim_{x \rightarrow \infty} \frac{-\ln(x)}{x} = 0
```
"""

# ╔═╡ 98e09286-539f-11ec-13cb-819219b4827b
md"""The last equality follows, as the function $x$ dominates the function $\ln(x)$. So by the limit rule involving compositions we have: $\lim_{x\rightarrow 0+} x^x = e^0 = 1$.
"""

# ╔═╡ 98e092a4-539f-11ec-0d7c-d71970839a2d
md"""## Questions
"""

# ╔═╡ 98e0a76c-539f-11ec-1c16-5f7c3dbfceb7
md"""###### Question
"""

# ╔═╡ 98e0a79e-539f-11ec-33a7-75aa01c37d37
md"""Consider the function $f(x) = \sqrt{x}$.
"""

# ╔═╡ 98e0a7b2-539f-11ec-2122-6fb5ab36fa8c
md"""Does this function have a limit at every $c > 0$?
"""

# ╔═╡ 98e0ad66-539f-11ec-3388-db6e718d2761
let
	booleanq(true, labels=["Yes", "No"])
end

# ╔═╡ 98e0ad98-539f-11ec-059e-53e5b406a051
md"""Does this function have a limit at $c=0$?
"""

# ╔═╡ 98e0b1ee-539f-11ec-0b53-59c610708093
let
	booleanq(false, labels=["Yes", "No"])
end

# ╔═╡ 98e0b216-539f-11ec-21a4-f358aa088efe
md"""Does this function have a right limit at $c=0$?
"""

# ╔═╡ 98e0b70c-539f-11ec-16c9-5df989a3aea1
let
	booleanq(true, labels=["Yes", "No"])
end

# ╔═╡ 98e0b734-539f-11ec-1c6b-3f6e65c3f80f
md"""Does this function have a left limit at $c=0$?
"""

# ╔═╡ 98e0bba8-539f-11ec-07d0-6bdf2b9ce663
let
	booleanq(false, labels=["Yes", "No"])
end

# ╔═╡ 98e0bbee-539f-11ec-0eeb-03772285e187
md"""##### Question
"""

# ╔═╡ 98e0bc0c-539f-11ec-3e77-633340c19d4e
md"""Find $\lim_{x \rightarrow \infty} \sin(x)/x$.
"""

# ╔═╡ 98e0be0a-539f-11ec-2d84-f703d445992b
let
	numericq(0)
end

# ╔═╡ 98e0be32-539f-11ec-02bf-370c956c562a
md"""###### Question
"""

# ╔═╡ 98e0be4e-539f-11ec-326c-930b37780b03
md"""Find $\lim_{x \rightarrow \infty} (1-\cos(x))/x^2$.
"""

# ╔═╡ 98e0c008-539f-11ec-09df-2f2a847bf802
let
	numericq(0)
end

# ╔═╡ 98e0c026-539f-11ec-37d1-8748c8210791
md"""###### Question
"""

# ╔═╡ 98e0c04e-539f-11ec-111e-d3e73e30e478
md"""Find $\lim_{x \rightarrow \infty} \log(x)/x$.
"""

# ╔═╡ 98e0c21a-539f-11ec-1e49-1b1f5e11d202
let
	numericq(0)
end

# ╔═╡ 98e0c238-539f-11ec-3402-3fc0bf222497
md"""###### Question
"""

# ╔═╡ 98e0c254-539f-11ec-3570-e1ff057037a7
md"""Find $\lim_{x \rightarrow 2+} (x-3)/(x-2)$.
"""

# ╔═╡ 98e0c940-539f-11ec-0e9b-8b9f4aa70ad3
let
	choices=["``L=-\\infty``", "``L=-1``", "``L=0``", "``L=\\infty``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 98e0c972-539f-11ec-3cea-cdbfb39e6f6d
md"""Find $\lim_{x \rightarrow -3-} (x-3)/(x+3)$.
"""

# ╔═╡ 98e0d0ac-539f-11ec-0e2b-dd8dc6e946b9
let
	choices=["``L=-\\infty``", "``L=-1``", "``L=0``", "``L=\\infty``"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ 98e0d0de-539f-11ec-17ad-dd45093b2a23
md"""###### Question
"""

# ╔═╡ 98e0d11a-539f-11ec-17d5-5d97bd3f20f3
md"""Let $f(x) = \exp(x + \exp(-x^2))$ and $g(x) = \exp(-x^2)$. Compute:
"""

# ╔═╡ 98e0d14c-539f-11ec-1ed5-b36d23fc903b
md"""```math
\lim_{x \rightarrow \infty} \frac{\ln(f(x))}{\ln(g(x))}.
```
"""

# ╔═╡ 98e0d516-539f-11ec-23a2-b3bebcb5f777
let
	@syms x
	ex = log(exp(x + exp(-x^2))) / log(exp(-x^2))
	val = N(limit(ex, x => oo))
	numericq(val)
end

# ╔═╡ 98e0d540-539f-11ec-1788-4d8ea64e1048
md"""###### Question
"""

# ╔═╡ 98e0d552-539f-11ec-01fa-f1a9ad7f393b
md"""Consider the following expression:
"""

# ╔═╡ 98e0dbc4-539f-11ec-0399-0f8d055c81db
ex = 1/(exp(-x + exp(-x))) - exp(x)

# ╔═╡ 98e0dc00-539f-11ec-0add-67848d5770f8
md"""We want to find the limit, $L$, as $x \rightarrow \infty$, which we assume exists below.
"""

# ╔═╡ 98e0dc3c-539f-11ec-145f-53ef9ca27068
md"""We first rewrite `ex` using `w` as `exp(-x)`:
"""

# ╔═╡ 98e0dfb6-539f-11ec-0ac3-0bb241cfa9ed
begin
	@syms w
	ex1 = ex(exp(-x) => w)
end

# ╔═╡ 98e0e006-539f-11ec-1ace-67456fdd8754
md"""As $x \rightarrow \infty$, $w \rightarrow 0+$, so the limit at $0+$ of `ex1` is of interest.
"""

# ╔═╡ 98e0e01c-539f-11ec-3115-4f9020fb0ae2
md"""Use this fact, to find $L$
"""

# ╔═╡ 98e0e6dc-539f-11ec-3e1c-1b1aaed07e44
limit(ex1 - (w/2 - 1), w=>0)

# ╔═╡ 98e34a82-539f-11ec-2abc-77028b9d39e2
md"""$L$ is:
"""

# ╔═╡ 98e34f76-539f-11ec-0cf8-390ab26f643c
let
	numericq(-1)
end

# ╔═╡ 98e34ff8-539f-11ec-3a19-35f680e1ba4d
md"""(This awkward approach is  generalizable: replacing the limit as $w \rightarrow 0$ of an expression with the limit of a polynomial in `w` that is easy to identify.)
"""

# ╔═╡ 98e35016-539f-11ec-34c7-85debdb01681
md"""###### Question
"""

# ╔═╡ 98e35048-539f-11ec-007c-ab8c39b5df19
md"""As mentioned, for limits that depend on specific values of parameters `SymPy` may have issues. As an example, `SymPy` has an issue with this limit, whose answer  depends on the value of $k$"
"""

# ╔═╡ 98e35070-539f-11ec-127f-4966b0502083
md"""```math
\lim_{x \rightarrow 0+} \frac{\sin(\sin(x^2))}{x^k}.
```
"""

# ╔═╡ 98e35082-539f-11ec-31ef-1f45eb5afb73
md"""Note, regardless of $k$ you find:
"""

# ╔═╡ 98e35674-539f-11ec-3d3e-97cdded0d913
let
	@syms x::real k::integer
	limit(sin(sin(x^2))/x^k, x=>0)
end

# ╔═╡ 98e356ba-539f-11ec-021a-09ecfb176b33
md"""For which value(s) of $k$ in $1,2,3$ is this actually the correct answer? (Do the above $3$ times using a specific value of `k`, not a numeric one.
"""

# ╔═╡ 98e37672-539f-11ec-009b-1326b39d3a8e
begin
	choices = ["``1``", "``2``", "``3``", "``1,2``", "``1,3``", "``2,3``", "``1,2,3``"]
	radioq(choices, 1, keep_order=true)
end

# ╔═╡ 98e376a4-539f-11ec-1a28-55684660a348
md"""###### Question: No limit
"""

# ╔═╡ 98e376e8-539f-11ec-38b0-c74ea6396250
md"""Some functions do not have a limit. Make a graph of $\sin(1/x)$ from $0.0001$ to $1$ and look at the output. Why does a limit not exist?
"""

# ╔═╡ 98e37f1e-539f-11ec-05e0-19bee90b94bd
let
	choices=["The limit does exist - it is any number from -1 to 1",
	  "Err, the limit does exists and is 1",
	  "The function oscillates too much and its y values do not get close to any one value",
	  "Any function that oscillates does not have a limit."]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 98e37f6e-539f-11ec-3da6-eb33db6168b6
md"""###### Question $0^0$ is not *always* $1$
"""

# ╔═╡ 98e37f96-539f-11ec-1765-af544e421378
md"""Is the form $0^0$ really indeterminate? As mentioned `0^0` evaluates to `1`.
"""

# ╔═╡ 98e37faa-539f-11ec-1eca-83220295bac4
md"""Consider this limit:
"""

# ╔═╡ 98e37fbe-539f-11ec-078f-61e4841307f6
md"""```math
\lim_{x \rightarrow 0+} x^{k\cdot x} = L.
```
"""

# ╔═╡ 98e37fdc-539f-11ec-2383-31b5545897c9
md"""Consider different values of $k$ to see if this limit depends on $k$ or not. What is $L$?
"""

# ╔═╡ 98e3a246-539f-11ec-0d10-3df91bbf74cd
let
	choices = ["``1``", "``k``", "``\\log(k)``", "The limit does not exist"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 98e3a28e-539f-11ec-38c6-d73b573d3683
md"""Now, consider this limit:
"""

# ╔═╡ 98e3a2b4-539f-11ec-0b05-ed8f3d74e22d
md"""```math
\lim_{x \rightarrow 0+} x^{1/\log_k(x)} = L.
```
"""

# ╔═╡ 98e3a304-539f-11ec-326d-8f7f0cd57418
md"""In `julia`, $\log_k(x)$ is found with `log(k,x)`. The default, `log(x)` takes $k=e$ so gives the natural log. So, we would define `h`, for a given `k`, with
"""

# ╔═╡ 98e3a732-539f-11ec-2f23-976f7e9b2e54
begin
	k = 10				# say. Replace with actual value
	h(x) = x^(1/log(k, x))
end

# ╔═╡ 98e3a76e-539f-11ec-0d10-b9c8e554e74d
md"""Consider different values of $k$ to see if the limit depends on $k$ or not. What is $L$?
"""

# ╔═╡ 98e3ad9c-539f-11ec-10f9-33cab47b56dd
let
	choices = ["``1``", "``k``", "``\\log(k)``", "The limit does not exist"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 98e3adc2-539f-11ec-0c6f-e5b950cda2c6
md"""###### Question
"""

# ╔═╡ 98e3ae08-539f-11ec-208b-5b33c1e67f5f
md"""Limits *of* infinity *at* infinity. We could define this concept quite easily mashing together the two definitions. Suppose we did. Which of these ratios would have a limit of infinity at infinity:
"""

# ╔═╡ 98e3ae26-539f-11ec-0251-5b23a6d04641
md"""```math
x^4/x^3,\quad x^{100+1}/x^{100}, \quad x/\log(x), \quad 3^x / 2^x, \quad e^x/x^{100}
```
"""

# ╔═╡ 98e3b7cc-539f-11ec-124d-8b3d5e0dbb17
let
	choices=[
	"the first one",
	"the first and second ones",
	"the first, second and third ones",
	"the first, second, third, and fourth ones",
	"all of them"]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 98e3b830-539f-11ec-0cf1-9761b975c1a5
md"""###### Question
"""

# ╔═╡ 98e3b86c-539f-11ec-3fe6-4d6014cbc24c
md"""A slant asymptote is a line $mx + b$ for which the graph of $f(x)$ gets close to as $x$ gets large. We can't express this directly as a limit, as "$L$" is not a number. How might we?
"""

# ╔═╡ 98e3da54-539f-11ec-1189-09da2513ae1e
let
	choices = [
	L"We can talk about the limit at $\infty$ of $f(x) - (mx + b)$ being $0$",
	L"We can talk about the limit at $\infty$ of $f(x) - mx$ being $b$",
	L"We can say $f(x) - (mx+b)$ has a horizontal asymptote $y=0$",
	L"We can say $f(x) - mx$ has a horizontal asymptote $y=b$",
	"Any of the above"]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 98e3da90-539f-11ec-1312-5b85fb4bde83
md"""###### Question
"""

# ╔═╡ 98e3db44-539f-11ec-32e0-cd0b8dd82b2b
md"""Suppose a sequence of points $x_n$ converges to $a$ in the limiting sense. For a function $f(x)$, the sequence of points $f(x_n)$ may or may not converge.  One alternative definition of a [limit](https://en.wikipedia.org/wiki/Limit_of_a_function#In_terms_of_sequences) due to Heine is that $\lim_{x \rightarrow a}f(x) = L$ if *and* only if **all** sequences $x_n \rightarrow a$ have $f(x_n) \rightarrow L$.
"""

# ╔═╡ 98e3db6a-539f-11ec-3e38-431539e4f343
md"""Consider the function $f(x) = \sin(1/x)$, $a=0$, and the two sequences implicitly defined by $1/x_n = \pi/2 + n \cdot (2\pi)$ and $y_n = 3\pi/2 + n \cdot(2\pi)$, $n = 0, 1, 2, \dots$.
"""

# ╔═╡ 98e3db80-539f-11ec-2a64-155ba7f73c32
md"""What is $\lim_{x_n \rightarrow 0} f(x_n)$?
"""

# ╔═╡ 98e3e198-539f-11ec-2aff-0b06eb61d4f4
let
	numericq(1)
end

# ╔═╡ 98e3e1e8-539f-11ec-028c-b5bf65dcf5b6
md"""What is $\lim_{y_n \rightarrow 0} f(y_n)$?
"""

# ╔═╡ 98e3e562-539f-11ec-37b7-5f6c362862b8
let
	numericq(-1)
end

# ╔═╡ 98e3e59e-539f-11ec-10d1-2d7c3dbb5d7f
md"""This shows that
"""

# ╔═╡ 98e3f05c-539f-11ec-1314-6375943a9149
let
	choices = [L" $f(x)$ has a limit of $1$ as $x \rightarrow 0$",
	L" $f(x)$ has a limit of $-1$ as $x \rightarrow 0$",
	L" $f(x)$ does not have a limit as $x \rightarrow 0$"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 98e3f0f4-539f-11ec-3a62-bf721ab75cc3
HTML("""<div class="markdown"><blockquote>
<p><a href="../limits/limits.html">◅ previous</a>  <a href="../limits/continuity.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/limits/limits_extensions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 98e3f106-539f-11ec-09c8-5d48fb43dd42
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
DataFrames = "~1.2.2"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Pluto", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "7adfe1a4e3f52fc356dfa2b0b26457f0acf81aa2"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.10"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "d8f468c5cd4d94e86816603f7d18ece910b4aaf1"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.5.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "6406b5112809c08b1baa5703ad274e1dded0652f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.23"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "f823a2d04fb233d52812c8024a6d46d9581904a4"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.4.5"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "d73736030a094e8d24fdf3629ae980217bf1d59d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.3"

[[Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "Sockets", "TableIOInterface", "Tables", "UUIDs"]
git-tree-sha1 = "a5b3fee95de0c0a324bab53a03911395936d15d9"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.17.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableIOInterface]]
git-tree-sha1 = "9a0d3ab8afd14f33a35af7391491ff3104401a35"
uuid = "d1efa939-5518-4425-949f-ab857e148477"
version = "0.1.6"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─98e3f0ca-539f-11ec-06fa-5d869da7bd89
# ╟─98dcf87e-539f-11ec-0ab4-81ba14d77f53
# ╟─98dcf964-539f-11ec-1ca8-efd65312d3e0
# ╠═98dd17be-539f-11ec-2e52-7765436dfacd
# ╟─98dd1bb0-539f-11ec-0eb6-6f6965bf7709
# ╟─98dd1c3c-539f-11ec-151e-2d08b6a903ec
# ╟─98dd1cc8-539f-11ec-2d69-4177808929e3
# ╟─98dd1cdc-539f-11ec-1771-b393d01fe0dd
# ╟─98dd1dd6-539f-11ec-00e7-554c6fa48c0c
# ╟─98dd1e12-539f-11ec-0f40-1977306af354
# ╟─98dd1e1a-539f-11ec-22ec-af3641a637b2
# ╟─98dd4626-539f-11ec-3cee-d15a32285679
# ╟─98dd46ec-539f-11ec-3d47-d151edc6f020
# ╟─98dd472a-539f-11ec-304e-8ba7294e6ab0
# ╟─98dd475c-539f-11ec-1df0-735af4ee5845
# ╟─98dd477a-539f-11ec-0c9d-adfe861c21c8
# ╟─98dd4798-539f-11ec-09a7-2793bae1b3b0
# ╠═98dd4fc2-539f-11ec-0746-ad95f5e3b61e
# ╟─98dd50ee-539f-11ec-0f69-e36ef5f820e9
# ╟─98dd521a-539f-11ec-1ad1-9d3886797f11
# ╟─98dd5256-539f-11ec-0337-33ec5418dc7c
# ╟─98dd526a-539f-11ec-1e9a-69097e248edb
# ╠═98dd56fc-539f-11ec-1d81-63dfd6cf2a33
# ╟─98dd5742-539f-11ec-155c-7dadec1094d1
# ╟─98dd5788-539f-11ec-25ef-cf78e5a3773d
# ╟─98dd5792-539f-11ec-19e5-599c95e1ea33
# ╟─98dd5a76-539f-11ec-34bd-dd968fdc8607
# ╟─98dd5aa8-539f-11ec-08d6-73b44ce5bab4
# ╟─98dd5ab2-539f-11ec-0967-bf3055281c1b
# ╟─98dd5b2a-539f-11ec-207f-fb973c3c3426
# ╟─98dd5b40-539f-11ec-15b2-a73b80dd35f5
# ╟─98dd5b84-539f-11ec-1330-e5ebc2e6ed5d
# ╠═98dd73b2-539f-11ec-0759-11a0ed926ec5
# ╠═98dd7860-539f-11ec-1a9d-f35168a037e4
# ╟─98dd812c-539f-11ec-3f2a-f70f5bf98973
# ╟─98dd8174-539f-11ec-2bac-49ff33df2d7f
# ╟─98dd8186-539f-11ec-1caa-ab6793702825
# ╠═98dd85ac-539f-11ec-342c-3f733bafc6cb
# ╟─98dd85d2-539f-11ec-081f-7d0773a3e8bf
# ╟─98dd8604-539f-11ec-043f-e708960cd552
# ╟─98dd862c-539f-11ec-32e8-77802b1444be
# ╠═98dd8ab4-539f-11ec-13ff-87be20f4e50d
# ╟─98dd8adc-539f-11ec-3643-a7c3f514847b
# ╟─98dd8b72-539f-11ec-0e04-6f7da0a98211
# ╟─98dd8c58-539f-11ec-2071-17c0f3e48514
# ╟─98dd8c76-539f-11ec-262d-c143fa545233
# ╟─98dd9e66-539f-11ec-1118-1fb056109aa1
# ╟─98dd9ebe-539f-11ec-0674-9b3e32fc2c49
# ╟─98dda09e-539f-11ec-3b6f-b3ce1cdef293
# ╟─98dda0c6-539f-11ec-3149-45077d07bb29
# ╟─98dda104-539f-11ec-017b-cd395bf65e5c
# ╟─98dda12a-539f-11ec-1931-9169975dcce5
# ╟─98dda13e-539f-11ec-268a-09db5008d2c1
# ╟─98dda15c-539f-11ec-3e5b-b369f81a4f41
# ╟─98dda1ac-539f-11ec-1222-1714797f772f
# ╠═98dda6f2-539f-11ec-0b5d-8935703546f5
# ╟─98dda736-539f-11ec-16dc-8ba3397519fb
# ╟─98dda756-539f-11ec-0779-2927d9ebe8a9
# ╟─98dda774-539f-11ec-253e-535ddf48277b
# ╠═98ddad50-539f-11ec-330d-5768001a695d
# ╟─98ddad6e-539f-11ec-237c-b33b6b26826a
# ╟─98ddad96-539f-11ec-0a4a-ad78d390ada4
# ╠═98ddfa9e-539f-11ec-1fc8-bbbf0fb56ce5
# ╟─98ddfac6-539f-11ec-2d57-7ffde38b3def
# ╟─98ddfb0c-539f-11ec-1991-65a0fed41050
# ╠═98de01a6-539f-11ec-2a10-fd1891a011a6
# ╟─98de01e2-539f-11ec-348a-8321aa7f0608
# ╟─98de0214-539f-11ec-0ad7-43424c20b508
# ╟─98de0228-539f-11ec-05d0-137f0dfbb58c
# ╟─98de0252-539f-11ec-3b83-47afdf116ac5
# ╟─98de025a-539f-11ec-0973-4d74de4aeecd
# ╟─98de026e-539f-11ec-3ffa-917b38fb0409
# ╟─98de028c-539f-11ec-3b5a-c30e2c2b3a9d
# ╟─98de0296-539f-11ec-3284-8be2f9261276
# ╟─98de02aa-539f-11ec-0a9f-99eb6884fa83
# ╟─98de02be-539f-11ec-2880-2bdd5e1a0f80
# ╟─98de02dc-539f-11ec-23d3-796adc94fff3
# ╟─98de034a-539f-11ec-367a-c93fe38761ff
# ╟─98de035e-539f-11ec-245a-9996f5778ae6
# ╟─98de039a-539f-11ec-313f-1b923f3439b8
# ╟─98de09e4-539f-11ec-3449-311bf9d9cc8b
# ╟─98de0a20-539f-11ec-0904-dbe6c917d4ae
# ╟─98de0a7a-539f-11ec-169f-a97e1e63a882
# ╟─98de11be-539f-11ec-3e37-cf518c5a0e3c
# ╟─98de1204-539f-11ec-114b-7f06e32f60a6
# ╠═98de1a88-539f-11ec-324e-b3e0c0c1567a
# ╟─98de1ab0-539f-11ec-26d5-abc0a066ccaa
# ╟─98de1b3e-539f-11ec-3381-8dc3f5d1dcfe
# ╟─98de1b96-539f-11ec-085c-d99df6ac91d9
# ╠═98de2f1e-539f-11ec-3136-8fba5b51aff7
# ╟─98de2f82-539f-11ec-36f2-573a54d64f28
# ╠═98de3702-539f-11ec-18b1-3f309123b861
# ╟─98de375c-539f-11ec-3bd8-8d531870b834
# ╟─98de37ac-539f-11ec-1de5-1f61cdfd1ef5
# ╟─98de3946-539f-11ec-1b48-e55ccc3b975f
# ╟─98de3994-539f-11ec-205a-919bd863238a
# ╟─98de39be-539f-11ec-0f2d-670e088a3f93
# ╟─98de39f8-539f-11ec-3a45-331a88b635f9
# ╠═98de5908-539f-11ec-390c-7dac12e9d5fe
# ╟─98de5976-539f-11ec-0f42-c1e3013feac6
# ╟─98de5994-539f-11ec-24be-f7bd9a2e1444
# ╟─98de59c6-539f-11ec-1af0-3562f9550b07
# ╟─98de5a02-539f-11ec-0b13-2f697aca0d0a
# ╟─98de5a20-539f-11ec-0fa7-a758cae646d4
# ╟─98de5a34-539f-11ec-3cf8-070a0b5b28f6
# ╟─98de5a52-539f-11ec-052f-99e4c8d5feea
# ╟─98de5a70-539f-11ec-0e79-8d8d0d98f4a3
# ╟─98de5a84-539f-11ec-034e-07408604e81d
# ╟─98de5abe-539f-11ec-2b92-0ff120d1cb37
# ╠═98de6182-539f-11ec-0478-3be8f50708b1
# ╟─98de61d2-539f-11ec-1363-8de561dec16f
# ╟─98de61f0-539f-11ec-321a-c518b38b930e
# ╟─98de622c-539f-11ec-3c03-c5f2b102f413
# ╟─98de6240-539f-11ec-349a-1feb46fabe44
# ╟─98de62ae-539f-11ec-1fa5-47aa9c8948ca
# ╟─98de6376-539f-11ec-1cad-d93b85e57303
# ╟─98de63a0-539f-11ec-1693-4147d7236f67
# ╟─98de6568-539f-11ec-32a7-f50c147b25f8
# ╟─98de659a-539f-11ec-3408-dd3c20fa49d6
# ╟─98de65ba-539f-11ec-348c-6f446507a295
# ╟─98de76a4-539f-11ec-3738-4324d462d72a
# ╟─98e07742-539f-11ec-32bc-e9f8f42cef3d
# ╟─98e07792-539f-11ec-394e-cd1a7962f01c
# ╟─98e077d8-539f-11ec-1731-d7c043e83ea6
# ╟─98e0781e-539f-11ec-2455-c18cca85546f
# ╟─98e0783c-539f-11ec-293a-45b5d3f36201
# ╟─98e07858-539f-11ec-1f11-a354176d0553
# ╟─98e07878-539f-11ec-3d26-f18fef6e01c2
# ╠═98e0817e-539f-11ec-0567-69e4b4c86d5c
# ╟─98e0826e-539f-11ec-2bb8-458cc64daab8
# ╟─98e082b4-539f-11ec-0b32-7f9423750df4
# ╠═98e08796-539f-11ec-1ea4-4fc84b48ee5d
# ╟─98e087d0-539f-11ec-31c4-93910047e655
# ╟─98e087f0-539f-11ec-29c6-d55340900476
# ╠═98e08c28-539f-11ec-315c-89e121ff444c
# ╟─98e08c50-539f-11ec-23b6-cb7aaf6eafcb
# ╟─98e08c82-539f-11ec-3a8e-5f85519b5918
# ╟─98e08ca0-539f-11ec-1087-0f47c6477488
# ╟─98e08cb4-539f-11ec-117d-712fcd24bd6c
# ╟─98e08cd2-539f-11ec-214b-c3f72c640ac0
# ╠═98e09144-539f-11ec-37a7-97adc25818f9
# ╟─98e0915a-539f-11ec-2558-f1e0185bf80f
# ╟─98e0916e-539f-11ec-2bde-9541ec9c7af8
# ╟─98e091a0-539f-11ec-1cc8-2f7df77ca5e0
# ╟─98e091b4-539f-11ec-0cc6-c7335f4e0d69
# ╟─98e091c8-539f-11ec-3137-2b97250f5c5c
# ╟─98e091f0-539f-11ec-0174-cd09832aef3d
# ╟─98e0920e-539f-11ec-3ef9-5da525c42f95
# ╟─98e09222-539f-11ec-2232-47872c8fdeeb
# ╟─98e09254-539f-11ec-3151-d9ba5ae287b0
# ╟─98e09268-539f-11ec-30f8-abf5c1d9e964
# ╟─98e09286-539f-11ec-13cb-819219b4827b
# ╟─98e092a4-539f-11ec-0d7c-d71970839a2d
# ╟─98e0a76c-539f-11ec-1c16-5f7c3dbfceb7
# ╟─98e0a79e-539f-11ec-33a7-75aa01c37d37
# ╟─98e0a7b2-539f-11ec-2122-6fb5ab36fa8c
# ╟─98e0ad66-539f-11ec-3388-db6e718d2761
# ╟─98e0ad98-539f-11ec-059e-53e5b406a051
# ╟─98e0b1ee-539f-11ec-0b53-59c610708093
# ╟─98e0b216-539f-11ec-21a4-f358aa088efe
# ╟─98e0b70c-539f-11ec-16c9-5df989a3aea1
# ╟─98e0b734-539f-11ec-1c6b-3f6e65c3f80f
# ╟─98e0bba8-539f-11ec-07d0-6bdf2b9ce663
# ╟─98e0bbee-539f-11ec-0eeb-03772285e187
# ╟─98e0bc0c-539f-11ec-3e77-633340c19d4e
# ╟─98e0be0a-539f-11ec-2d84-f703d445992b
# ╟─98e0be32-539f-11ec-02bf-370c956c562a
# ╟─98e0be4e-539f-11ec-326c-930b37780b03
# ╟─98e0c008-539f-11ec-09df-2f2a847bf802
# ╟─98e0c026-539f-11ec-37d1-8748c8210791
# ╟─98e0c04e-539f-11ec-111e-d3e73e30e478
# ╟─98e0c21a-539f-11ec-1e49-1b1f5e11d202
# ╟─98e0c238-539f-11ec-3402-3fc0bf222497
# ╟─98e0c254-539f-11ec-3570-e1ff057037a7
# ╟─98e0c940-539f-11ec-0e9b-8b9f4aa70ad3
# ╟─98e0c972-539f-11ec-3cea-cdbfb39e6f6d
# ╟─98e0d0ac-539f-11ec-0e2b-dd8dc6e946b9
# ╟─98e0d0de-539f-11ec-17ad-dd45093b2a23
# ╟─98e0d11a-539f-11ec-17d5-5d97bd3f20f3
# ╟─98e0d14c-539f-11ec-1ed5-b36d23fc903b
# ╟─98e0d516-539f-11ec-23a2-b3bebcb5f777
# ╟─98e0d540-539f-11ec-1788-4d8ea64e1048
# ╟─98e0d552-539f-11ec-01fa-f1a9ad7f393b
# ╠═98e0dbc4-539f-11ec-0399-0f8d055c81db
# ╟─98e0dc00-539f-11ec-0add-67848d5770f8
# ╟─98e0dc3c-539f-11ec-145f-53ef9ca27068
# ╠═98e0dfb6-539f-11ec-0ac3-0bb241cfa9ed
# ╟─98e0e006-539f-11ec-1ace-67456fdd8754
# ╟─98e0e01c-539f-11ec-3115-4f9020fb0ae2
# ╠═98e0e6dc-539f-11ec-3e1c-1b1aaed07e44
# ╟─98e34a82-539f-11ec-2abc-77028b9d39e2
# ╟─98e34f76-539f-11ec-0cf8-390ab26f643c
# ╟─98e34ff8-539f-11ec-3a19-35f680e1ba4d
# ╟─98e35016-539f-11ec-34c7-85debdb01681
# ╟─98e35048-539f-11ec-007c-ab8c39b5df19
# ╟─98e35070-539f-11ec-127f-4966b0502083
# ╟─98e35082-539f-11ec-31ef-1f45eb5afb73
# ╠═98e35674-539f-11ec-3d3e-97cdded0d913
# ╟─98e356ba-539f-11ec-021a-09ecfb176b33
# ╟─98e37672-539f-11ec-009b-1326b39d3a8e
# ╟─98e376a4-539f-11ec-1a28-55684660a348
# ╟─98e376e8-539f-11ec-38b0-c74ea6396250
# ╟─98e37f1e-539f-11ec-05e0-19bee90b94bd
# ╟─98e37f6e-539f-11ec-3da6-eb33db6168b6
# ╟─98e37f96-539f-11ec-1765-af544e421378
# ╟─98e37faa-539f-11ec-1eca-83220295bac4
# ╟─98e37fbe-539f-11ec-078f-61e4841307f6
# ╟─98e37fdc-539f-11ec-2383-31b5545897c9
# ╟─98e3a246-539f-11ec-0d10-3df91bbf74cd
# ╟─98e3a28e-539f-11ec-38c6-d73b573d3683
# ╟─98e3a2b4-539f-11ec-0b05-ed8f3d74e22d
# ╟─98e3a304-539f-11ec-326d-8f7f0cd57418
# ╟─98e3a732-539f-11ec-2f23-976f7e9b2e54
# ╟─98e3a76e-539f-11ec-0d10-b9c8e554e74d
# ╟─98e3ad9c-539f-11ec-10f9-33cab47b56dd
# ╟─98e3adc2-539f-11ec-0c6f-e5b950cda2c6
# ╟─98e3ae08-539f-11ec-208b-5b33c1e67f5f
# ╟─98e3ae26-539f-11ec-0251-5b23a6d04641
# ╟─98e3b7cc-539f-11ec-124d-8b3d5e0dbb17
# ╟─98e3b830-539f-11ec-0cf1-9761b975c1a5
# ╟─98e3b86c-539f-11ec-3fe6-4d6014cbc24c
# ╟─98e3da54-539f-11ec-1189-09da2513ae1e
# ╟─98e3da90-539f-11ec-1312-5b85fb4bde83
# ╟─98e3db44-539f-11ec-32e0-cd0b8dd82b2b
# ╟─98e3db6a-539f-11ec-3e38-431539e4f343
# ╟─98e3db80-539f-11ec-2a64-155ba7f73c32
# ╟─98e3e198-539f-11ec-2aff-0b06eb61d4f4
# ╟─98e3e1e8-539f-11ec-028c-b5bf65dcf5b6
# ╟─98e3e562-539f-11ec-37b7-5f6c362862b8
# ╟─98e3e59e-539f-11ec-10d1-2d7c3dbb5d7f
# ╟─98e3f05c-539f-11ec-1314-6375943a9149
# ╟─98e3f0f4-539f-11ec-3a62-bf721ab75cc3
# ╟─98e3f0fc-539f-11ec-249e-a72375a3c68d
# ╟─98e3f106-539f-11ec-09c8-5d48fb43dd42
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
