### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 73382fc8-53a2-11ec-3b3e-cbe001720a5e
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Unitful
end

# ╔═╡ 73385160-53a2-11ec-1d3d-758f75e53230
begin
	using CalculusWithJulia.WeaveSupport
	using Roots
	import PyPlot
	pyplot()
	fig_size = (600, 400)
	nothing
end

# ╔═╡ 733e4932-53a2-11ec-1009-499cb17555d9
using PlutoUI

# ╔═╡ 733e488e-53a2-11ec-39e5-e1b805f36c38
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 733964a6-53a2-11ec-396c-67b41ba67b4a
begin
	divided_differences(f, x) = f(x)
	
	function divided_differences(f, x, xs...)
	    xs = sort(vcat(x, xs...))
	    (divided_differences(f, xs[2:end]...) - divided_differences(f, xs[1:end-1]...)) / (xs[end] - xs[1])
	end
end

# ╔═╡ 73398c56-53a2-11ec-11ea-b33a05de58c5
begin
	Base.getindex(u::SymFunction, xs...) = divided_differences(u, xs...)
	
	@syms x::real c::real h::positive u()
	ex = u[c, c+h]
end

# ╔═╡ 73374a9a-53a2-11ec-1eac-fbcc035135ed
md"""# Taylor Polynomials and other Approximating Polynomials
"""

# ╔═╡ 73377ad8-53a2-11ec-1328-a7e200f24885
md"""This section uses these add-on packages:
"""

# ╔═╡ 7338570a-53a2-11ec-1a68-bb36e816ef40
md"""The tangent line was seen to be the "best" linear approximation to a function at a point $c$. Approximating a function by a linear function gives an easier to use approximation at the expense of accuracy. It suggests a tradeoff between ease and accuracy. Is there a way to gain more accuracy at the expense of ease?
"""

# ╔═╡ 733857be-53a2-11ec-3107-6d18a0a1b3ef
md"""Quadratic functions are still fairly easy to work with. Is it possible to find the best "quadratic" approximation to a function at a point $c$.
"""

# ╔═╡ 733857dc-53a2-11ec-26b3-4d906a5f73c1
md"""More generally, for a given $n$, what would be the best polynomial of degree $n$ to approximate $f(x)$ at $c$?
"""

# ╔═╡ 7338587c-53a2-11ec-388e-ab31646a1ef0
md"""We will see in this section how the Taylor polynomial answers these questions, and is the appropriate generalization of the tangent line approximation.
"""

# ╔═╡ 7338b81c-53a2-11ec-2726-e329062aea33
let
	###{{{taylor_animation}}}
	taylor(f, x, c, n) = series(f, x, c, n+1).removeO()
	function make_taylor_plot(u, a, b, k)
	    k = 2k
	    plot(u, a, b, title="plot of T_$k", linewidth=5, legend=false, size=fig_size, ylim=(-2,2.5))
	    if k == 1
	        plot!(zero, range(a, stop=b, length=100))
	    else
	        plot!(taylor(u, x, 0, k), range(a, stop=b, length=100))
	    end
	end
	
	
	
	@syms x
	u = 1 - cos(x)
	a, b = -2pi, 2pi
	n = 8
	anim = @animate for i=1:n
	    make_taylor_plot(u, a, b, i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	
	Illustration of the Taylor polynomial of degree $k$, $T_k(x)$, at $c=0$ and its graph overlayed on that of the function $1 - \cos(x)$.
	
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7338d59a-53a2-11ec-3aa6-631373462317
md"""## The secant line and the tangent line
"""

# ╔═╡ 7338dd88-53a2-11ec-0a47-8140b10ad1ba
md"""We approach this general problem **much** more indirectly than is needed. We introducing notations that are attributed to Newton and proceed from there. By leveraging `SymPy` we avoid tedious computations and *hopefully* gain some insight.
"""

# ╔═╡ 7338ddfe-53a2-11ec-3061-03669abc0db3
md"""Suppose $f(x)$ is a function which is defined in a neighborhood of $c$ and has as many continuous derivatives as we care to take at $c$.
"""

# ╔═╡ 7338de6e-53a2-11ec-090b-331815c39ce8
md"""We have two related formulas:
"""

# ╔═╡ 733944c6-53a2-11ec-2eae-a778132841e8
md"""  * The *secant line* connecting $(c, f(c))$ and $(c+h, f(c+h))$ for a value of $h>0$ is given in point-slope form by
"""

# ╔═╡ 733948cc-53a2-11ec-1bd3-1bd3662304b4
md"""```math
sl(x) = f(c) + \frac{(f(c+h) - f(c))}{h} \cdot (x-c).
```
"""

# ╔═╡ 733948fe-53a2-11ec-0cd3-731e2e083895
md"""The slope is the familiar approximation to the derivative: $(f(c+h)-f(c))/h$.
"""

# ╔═╡ 73394a16-53a2-11ec-2557-1190c0def7c3
md"""  * The *tangent line* to the graph of $f(x)$ at $x=c$ is described by the function
"""

# ╔═╡ 73394a66-53a2-11ec-26bd-839493b66875
md"""```math
tl(x) = f(c) + f'(c) \cdot(x - c).
```
"""

# ╔═╡ 73394a98-53a2-11ec-1cd8-097d14528500
md"""The key is the term multiplying $(x-c)$ for the secant line is an approximation to the related term for the tangent line. That is, the secant line approximates the tangent line, which is the linear function that best approximates the function at the point $(c, f(c))$. This is quantified by the *mean value theorem* which states under our assumptions on $f(x)$ that there exists some $\xi$ between $x$ and $c$ for which:
"""

# ╔═╡ 73394b38-53a2-11ec-1278-f12dc7908773
md"""```math
f(x) - tl(x) = \frac{f''(\xi)}{2} \cdot (x-c)^2.
```
"""

# ╔═╡ 73394c34-53a2-11ec-1f48-c5f719c4e74e
md"""The term "best" is deserved, as any other straight line will differ at least in an $(x-c)$ term, which in general is larger than an $(x-c)^2$ term for $x$ "near" $c$.
"""

# ╔═╡ 73394c82-53a2-11ec-212d-cfbb086128de
md"""(This is a consequence of Cauchy's mean value theorem with $F(c) = f(c) - f'(c)\cdot(c-x)$ and $G(c) = (c-x)^2$
"""

# ╔═╡ 73394c8c-53a2-11ec-1dd0-65bc4d2f185c
md"""```math
\begin{align*}
\frac{F'(\xi)}{G'(\xi)} &=
\frac{f'(\xi) - f''(\xi)(\xi-x) - f(\xi)\cdot 1}{2(\xi-x)} \\
&= -f''(\xi)/2\\
&= \frac{F(c) - F(x)}{G(c) - G(x)}\\
&= \frac{f(c) - f'(c)(c-x) - (f(x) - f'(x)(x-x))}{(c-x)^2 - (x-x)^2} \\
&= \frac{f(c) + f'(c)(x-c) - f(x)}{(x-c)^2}
\end{align*}
```
"""

# ╔═╡ 73394cd2-53a2-11ec-0be6-d51c0258dbc9
md"""That is, $f(x) = f(c) + f'(c)(x-c) + f''(\xi)/2\cdot(x-c)^2$, or $f(x)-tl(x)$ is as described.)
"""

# ╔═╡ 73394dc2-53a2-11ec-3eb7-ed40aae112c5
md"""The secant line also has an interpretation that will generalize - it is the smallest order polynomial that goes through, or *interpolates*, the points $(c,f(c))$ and $(c+h, f(c+h))$. This is obvious from the construction - as this is how the slope is derived - but from the formula itself requires showing $tl(c) = f(c)$ and $tl(c+h) = f(c+h)$. The former is straightforward, as $(c-c) = 0$, so clearly $tl(c) = f(c)$. The latter requires a bit of algebra.
"""

# ╔═╡ 73394dce-53a2-11ec-2aaa-d700ed8f0846
md"""We have:
"""

# ╔═╡ 73395472-53a2-11ec-0282-8d839683322e
md"""> The best *linear* approximation at a point $c$ is related to the *linear* polynomial interpolating the points $c$ and $c+h$ as $h$ goes to $0$.

"""

# ╔═╡ 733954b6-53a2-11ec-35e8-bdc83ce2a999
md"""This is the relationship we seek to generalize through our round about approach below:
"""

# ╔═╡ 7339551a-53a2-11ec-1d85-adb882e8b75f
md"""> The best approximation at a point $c$ by a polynomial of degree $n$ or less is related to the polynomial interpolating through the points $c, c+h, \dots, c+nh$ as $h$ goes to $0$.

"""

# ╔═╡ 73395524-53a2-11ec-05d2-6d18f90d24bb
md"""As in the linear case, there is flexibility in the exact points chosen for the interpolation.
"""

# ╔═╡ 733957fe-53a2-11ec-2885-fb70be29f50a
md"""---
"""

# ╔═╡ 733958dc-53a2-11ec-29f8-77ab793e361c
md"""Now, we take a small detour to define some notation. Instead of writing our two points as $c$ and $c+h,$ we use $x_0$ and $x_1$. For any set of points $x_0, x_1, \dots, x_n$, define the **divided differences** of $f$ inductively, as follows:
"""

# ╔═╡ 7339592a-53a2-11ec-2bf4-f541558adafa
md"""```math
\begin{align}
f[x_0] &= f(x_0) \\
f[x_0, x_1] &= \frac{f[x_1] - f[x_0]}{x_1 - x_0}\\
\cdots &\\
f[x_0, x_1, x_2, \dots, x_n] &= \frac{f[x_1, \dots, x_n] - f[x_0, x_1, x_2, \dots, x_{n-1}]}{x_n - x_0}.
\end{align}
```
"""

# ╔═╡ 7339597a-53a2-11ec-1ae9-617422c00663
md"""We see the first two values look familiar, and to generate more we just take certain ratios akin to those formed when finding a secant line.
"""

# ╔═╡ 73395984-53a2-11ec-2d88-69adb55a651d
md"""With this notation the secant line can be re-expressed as:
"""

# ╔═╡ 73395a1a-53a2-11ec-387a-7bb48d157a22
md"""```math
sl(x) = f[c] + f[c, c+h] \cdot (x-c).
```
"""

# ╔═╡ 73395aba-53a2-11ec-354c-d3033d98393b
md"""If we think of $f[c, c+h]$ as an approximate *first* derivative, we have an even stronger parallel between a secant line $x=c$ and the tangent line at $x=c$: $tl(x) = f(c) + f'(c)\cdot (x-c)$.
"""

# ╔═╡ 73395c7c-53a2-11ec-0f15-a558a8384cb1
md"""We use `SymPy` to investigate. First we create a *recursive* function to compute the divided differences:
"""

# ╔═╡ 73396578-53a2-11ec-225a-27df01caef9b
md"""In the following, by adding a `getindex` method, we enable the  `[]` notation of Newton to work with symbolic functions, like `u()` defined below, which is used in place of $f$:
"""

# ╔═╡ 73398d00-53a2-11ec-0716-d73def700383
md"""We can take a limit and see the familiar (yet differently represented) value of $u'(c)$:
"""

# ╔═╡ 7339ab76-53a2-11ec-2072-39b656521457
limit(ex, h => 0)

# ╔═╡ 7339abfa-53a2-11ec-3ec0-e9950411db89
md"""The choice of points is flexible. Here we use $c-h$ and $c+h$:
"""

# ╔═╡ 7339b302-53a2-11ec-2a4c-05c0594f8a09
limit(u[c-h, c+h], h=>0)

# ╔═╡ 7339b3ca-53a2-11ec-1cdd-455bfeba1592
md"""Now, let's look at:
"""

# ╔═╡ 7339e5de-53a2-11ec-2e56-c9f778308add
begin
	ex₂ = u[c, c+h, c+2h]
	simplify(ex₂)
end

# ╔═╡ 7339e6f6-53a2-11ec-0a10-61d6e8401ee4
md"""Not so bad after simplification. The limit shows this to be an approximation to the second derivative divided by $2$:
"""

# ╔═╡ 7339eb88-53a2-11ec-17ef-1b7126ca1971
limit(ex₂, h => 0)

# ╔═╡ 7339edcc-53a2-11ec-2212-956b1d8982bf
md"""(The expression is, up to a divisor of $2$, the second order forward [difference equation](http://tinyurl.com/n4235xy), a well-known approximation to $f''$.)
"""

# ╔═╡ 7339eeb2-53a2-11ec-14b5-c9791eceaef0
md"""This relationship between higher-order divided differences and higher-order derivatives generalizes. This is expressed in this [theorem](http://tinyurl.com/zjogv83):
"""

# ╔═╡ 7339effc-53a2-11ec-3894-f9266ed2c615
md"""> Suppose $m=x_0 < x_1 < x_2 < \dots < x_n=M$ are distinct points. If $f$ has $n$ continuous derivatives then there exists a value $\xi$, where $m < \xi < M$, satisfying:

"""

# ╔═╡ 7339f02e-53a2-11ec-08e5-27fdaac6815d
md"""```math
f[x_0, x_1, \dots, x_n] = \frac{1}{n!} \cdot f^{(n)}(\xi).
```
"""

# ╔═╡ 7339f100-53a2-11ec-1ec0-1bc7e03c2b5c
md"""This immediately applies to the above, where we parameterized by $h$: $x_0=c, x_1=c+h, x_2 = c+2h$. For then, as $h$ goes to $0$, it must be that $m, M \rightarrow c$, and so the limit of the divided differences must converge to $(1/2!) \cdot f^{(2)}(c)$, as $f^{(2)}(\xi)$ converges to $f^{(2)}(c)$.
"""

# ╔═╡ 7339f10c-53a2-11ec-01c2-cff31e4520a4
md"""A proof based on Rolle's theorem appears in the appendix.
"""

# ╔═╡ 7339f1dc-53a2-11ec-1118-a38c994f0768
md"""## Quadratic approximations
"""

# ╔═╡ 7339f2ae-53a2-11ec-0909-fb0d58fab083
md"""Why the fuss? The answer comes from a result of Newton on *interpolating* polynomials. Consider a function $f$ and $n+1$ points $x_0$, $x_1, \dots, x_n$. Then an interpolating polynomial is a polynomial of least degree that goes through each point $(x_i, f(x_i))$. The [Newton form](https://en.wikipedia.org/wiki/Newton_polynomial) of such a polynomial can be written as:
"""

# ╔═╡ 7339f34e-53a2-11ec-1525-c7e3c5b0b467
md"""```math
\begin{align*}
f[x_0] &+ f[x_0,x_1] \cdot (x-x_0) + f[x_0, x_1, x_2] \cdot (x-x_0) \cdot (x-x_1) + \\
& \cdots + f[x_0, x_1, \dots, x_n] \cdot (x-x_0)\cdot \cdots \cdot (x-x_{n-1}).
\end{align*}
```
"""

# ╔═╡ 7339f39e-53a2-11ec-3620-b9e371f148c2
md"""The case $n=0$ gives the value $f[x_0] = f(c)$, which can be interpreted as the slope-$0$ line that goes through the point $(c,f(c))$.
"""

# ╔═╡ 7339f43c-53a2-11ec-0230-5919e6f432d3
md"""We are familiar with the case $n=1$, with $x_0=c$ and $x_1=c+h$, this becomes our secant-line formula:
"""

# ╔═╡ 7339f498-53a2-11ec-367c-a5450d101e78
md"""```math
f[c] + f[c, c+h](x-c).
```
"""

# ╔═╡ 7339f4fc-53a2-11ec-11a1-799ce5c94958
md"""As mentioned, we can verify directly that it interpolates the points $(c,f(c))$ and $(c+h, f(c+h))$. He we let `SymPy` do the algebra:
"""

# ╔═╡ 7339feea-53a2-11ec-2232-f591a2577718
begin
	p₁ = u[c] + u[c, c+h] * (x-c)
	p₁(x => c) - u(c), p₁(x => c+h) - u(c+h)
end

# ╔═╡ 7339ff24-53a2-11ec-320f-e57383e45f97
md"""Now for something new. Take the $n=2$ case with $x_0 = c$, $x_1 = c + h$, and $x_2 = c+2h$. Then the interpolating polynomial is:
"""

# ╔═╡ 733a0000-53a2-11ec-26ac-ef96a149b9e8
md"""```math
f[c] + f[c, c+h](x-c) + f[c, c+h, c+2h](x-c)(x-(c+h)).
```
"""

# ╔═╡ 733a0014-53a2-11ec-03bb-c98f531bc942
md"""We add the next term to our previous polynomial and simplify
"""

# ╔═╡ 733a0c1c-53a2-11ec-1d7b-d55a44cef739
begin
	p₂ = p₁ + u[c, c+h, c+2h] * (x-c) * (x-(c+h))
	simplify(p₂)
end

# ╔═╡ 733a0cd0-53a2-11ec-1e49-5f3db916872f
md"""We can check that this interpolates the three points. Notice that at $x_0=c$ and $x_1=c+h$, the last term, $f[x_0, x_1, x_2]\cdot(x-x_0)(x-x_1)$, vanishes, so we already have the polynomial interpolating there. Only the value $x_2=c+2h$ remains to be checked:
"""

# ╔═╡ 733a131a-53a2-11ec-3db4-75d939600288
p₂(x => c+2h) - u(c+2h)

# ╔═╡ 733a1392-53a2-11ec-3be1-8d2a0241d22e
md"""Hmm, doesn't seem correct - that was supposed to be $0$. The issue isn't the math, it is that SymPy needs to be encouraged to simplify:
"""

# ╔═╡ 733a32f0-53a2-11ec-2543-49de4d8c8784
simplify(p₂(x => c+2h) - u(c+2h))

# ╔═╡ 733a3386-53a2-11ec-38c6-1b2f15e23fc9
md"""By contrast, at the point $x=c+3h$ we have no guarantee of interpolation, and indeed don't, as this expression is non always zero:
"""

# ╔═╡ 733a51e0-53a2-11ec-0bc7-cd7ee3c84ac3
simplify(p₂(x => c+3h) - u(c+3h))

# ╔═╡ 733a53f4-53a2-11ec-08c0-7599f5d5f01c
md"""Interpolating polynomials are of interest in their own right,  but for now we want to use them as motivation for the best polynomial approximation of a certain degree for a function. Motivated by how the secant line leads to the tangent line, we note that coefficients of the quadratic interpolating polynomial above have limits as $h$ goes to $0$, leaving this polynomial:
"""

# ╔═╡ 733a5422-53a2-11ec-04a9-4b2ff33193a3
md"""```math
f(c) + f'(c) \cdot (x-c) + \frac{1}{2!} \cdot f''(c) (x-c)^2.
```
"""

# ╔═╡ 733a54b0-53a2-11ec-1893-1fe762d73499
md"""This is clearly related to the tangent line approximation of $f(x)$ at $x=c$, but carrying an extra quadratic term.
"""

# ╔═╡ 733a5578-53a2-11ec-1f5e-ff4a7320c9f7
md"""Here we visualize the approximations with the function $f(x) = \cos(x)$ at $c=0$.
"""

# ╔═╡ 733a7062-53a2-11ec-3132-cb7c27919490
let
	f(x) = cos(x)
	a, b = -pi/2, pi/2
	c = 0
	h = 1/4
	
	fp = -sin(c)  # by hand, or use diff(f), ...
	fpp = -cos(c)
	
	
	p = plot(f, a, b, linewidth=5, legend=false, color=:blue)
	plot!(p, x->f(c) + fp*(x-c), a, b; color=:green, alpha=0.25, linewidth=5)                     # tangent line is flat
	plot!(p, x->f(c) + fp*(x-c) + (1/2)*fpp*(x-c)^2, a, b; color=:green, alpha=0.25, linewidth=5)  # a parabola
	p
end

# ╔═╡ 733a7094-53a2-11ec-0638-a7f69ad643da
md"""This graph illustrates that the extra quadratic term can track the curvature of the function, whereas the tangent line itself can't. So, we have a polynomial which is a "better" approximation, is it the best approximation?
"""

# ╔═╡ 733a717a-53a2-11ec-0d70-95c55c9836e1
md"""The Cauchy mean value theorem, as in the case of the tangent line, will guarantee the existence of $\xi$ between $c$ and $x$, for which
"""

# ╔═╡ 733a71d4-53a2-11ec-3aee-a53802bf9250
md"""```math
f(x) - \left(f(c) + f'(c) \cdot(x-c) + (1/2)\cdot f''(c) \cdot (x-c)^2 \right) =
\frac{1}{3!}f'''(\xi) \cdot (x-c)^3.
```
"""

# ╔═╡ 733a72ba-53a2-11ec-2c7b-b1204aaa5c48
md"""In this sense, the above quadratic polynomial, called the Taylor Polynomial of degree 2, is the best *quadratic* approximation to $f$, as the difference goes to $0$.
"""

# ╔═╡ 733a7320-53a2-11ec-231b-b949c5598cb0
md"""The graphs of the secant line and approximating parabola for $h=1/4$ are similar:
"""

# ╔═╡ 733a78e6-53a2-11ec-16d7-59fe194acdba
let
	f(x) = cos(x)
	a, b = -pi/2, pi/2
	c = 0
	h = 1/4
	
	x0, x1, x2 = c-h, c, c+h
	
	f0 = divided_differences(f, x0)
	fd = divided_differences(f, x0, x1)
	fdd = divided_differences(f, x0, x1, x2)
	
	p = plot(f, a, b, color=:blue, linewidth=5, legend=false)
	plot!(p, x -> f0 + fd*(x-x0), a, b, color=:green, alpha=0.25, linewidth=5);
	plot!(p, x -> f0 + fd*(x-x0) + fdd * (x-x0)*(x-x1), a,b, color=:green, alpha=0.25, linewidth=5);
	p
end

# ╔═╡ 733a7990-53a2-11ec-0740-0759d27da1a6
md"""Though similar, the graphs are **not** identical, as the interpolating polynomials aren't the best approximations.  For example, in the tangent-line graph the parabola only intersects the cosine graph at $x=0$, whereas for the secant-line graph - by definition - the parabola intersects the graph at least $2$ times and the interpolating polynomial $3$ times (at $x_0$, $x_1$, and $x_2$).
"""

# ╔═╡ 733a7d00-53a2-11ec-06b5-b7af9837b53e
md"""##### Example
"""

# ╔═╡ 733a7d96-53a2-11ec-1373-371f7b56cf65
md"""Consider the function $f(t) = \log(1 + t)$. We have mentioned that for $t$ small, the value $t$ is a good approximation. A better one becomes:
"""

# ╔═╡ 733a7daa-53a2-11ec-2794-fbe25425af07
md"""```math
f(0) + f'(0) \cdot t + \frac{1}{2} \cdot f''(0) \cdot t^2 = 0 + 1t - \frac{t^2}{2}
```
"""

# ╔═╡ 733a7db4-53a2-11ec-0aaa-1983d2c005c3
md"""A graph shows the difference:
"""

# ╔═╡ 733a841c-53a2-11ec-0ef9-a9199b7e040d
let
	f(t) = log(1 + t)
	a, b = -1/2, 1
	plot(f, a, b, legend=false, linewidth=5)
	plot!(t -> t, a, b)
	plot!(t -> t - t^2/2, a, b)
end

# ╔═╡ 733a84ee-53a2-11ec-13d3-8f48d34833aa
md"""Though we can see that the tangent line is a good approximation, the quadratic polynomial tracks the logarithm better farther from $c=0$.
"""

# ╔═╡ 733a8596-53a2-11ec-1619-f17624daa4d9
md"""##### Example
"""

# ╔═╡ 733a85b6-53a2-11ec-0e4f-bd5c429efd2c
md"""A wire is bent in the form of a half circle with radius $R$ centered at $(0,R)$, so the bottom of the wire is at the origin. A bead is released on the wire at angle $\theta$. As time evolves, the bead will slide back and forth. How? (Ignoring friction.)
"""

# ╔═╡ 733a867e-53a2-11ec-25c6-258a9a2a5d48
md"""Let $U$ be the potential energy, $U=mgh = mgR \cdot (1 - \cos(\theta))$. The velocity of the object will depend on $\theta$ - it will be $0$ at the high point, and largest in magnitude at the bottom - and is given by $v(\theta) = R \cdot d\theta/ dt$. (The bead moves along the wire so its distance traveled is $R\cdot \Delta \theta$, this, then, is just the time derivative of distance.)
"""

# ╔═╡ 733a8688-53a2-11ec-10da-b573f2f7ae77
md"""By ignoring friction, the total energy is conserved giving:
"""

# ╔═╡ 733a86a6-53a2-11ec-3606-8d120f7fa07c
md"""```math
K = \frac{1}{2}m v^2 + mgR \cdot (1 - \cos(\theta) =
\frac{1}{2} m R^2 (\frac{d\theta}{dt})^2 +  mgR \cdot (1 - \cos(\theta)).
```
"""

# ╔═╡ 733a86f6-53a2-11ec-3fb5-173a5ce9caa1
md"""The value of $1-\cos(\theta)$ inhibits further work which would be possible were there an easier formula there. In fact, we could try the excellent approximation $1 - \theta^2/2$ from the quadratic approximation. Then we have:
"""

# ╔═╡ 733a870a-53a2-11ec-1371-b5bf52bdbc37
md"""```math
K \approx \frac{1}{2} m R^2 (\frac{d\theta}{dt})^2 +  mgR \cdot (1 - \theta^2/2).
```
"""

# ╔═╡ 733a871e-53a2-11ec-0b67-297cd29cd056
md"""Assuming equality and differentiating in $t$ gives by the chain rule:
"""

# ╔═╡ 733a87be-53a2-11ec-03ed-199a12ab4e99
md"""```math
0 = \frac{1}{2} m R^2 2\frac{d\theta}{dt} \cdot \frac{d^2\theta}{dt^2} - mgR \theta\cdot \frac{d\theta}{dt}.
```
"""

# ╔═╡ 733a885e-53a2-11ec-2b34-632a2802edc4
md"""This can be solved to give this relationship:
"""

# ╔═╡ 733a88fe-53a2-11ec-37f4-a1866553e56f
md"""```math
\frac{d^2\theta}{dt^2} = - \frac{g}{R}\theta.
```
"""

# ╔═╡ 733a8926-53a2-11ec-04fa-b738a81f86ed
md"""The solution to this "equation" can be written (in some parameterization) as $\theta(t)=A\cos \left(\omega t+\phi \right)$. This motion is the well-studied simple [harmonic oscillator](https://en.wikipedia.org/wiki/Harmonic_oscillator), a model for a simple pendulum.
"""

# ╔═╡ 733a8994-53a2-11ec-2b8b-259f4330e7b2
md"""## The Taylor polynomial of degree $n$
"""

# ╔═╡ 733a8a0c-53a2-11ec-0214-552d3ff22a2d
md"""Starting with the Newton form of the interpolating polynomial of smallest degree:
"""

# ╔═╡ 733a8b4c-53a2-11ec-1eac-158ccf4f1ee0
md"""```math
\begin{align*}
f[x_0] &+ f[x_0,x_1] \cdot (x - x_0) + f[x_0, x_1, x_2] \cdot (x - x_0)\cdot(x-x_1) + \\
& \cdots + f[x_0, x_1, \dots, x_n] \cdot (x-x_0) \cdot \cdots \cdot (x-x_{n-1}).
\end{align*}
```
"""

# ╔═╡ 733a8c46-53a2-11ec-0c3d-290fd080362b
md"""and taking $x_i = c + i\cdot h$, for a given $n$, we have in the limit as $h > 0$ goes to zero that coefficients of this polynomial converge to the coefficients of the *Taylor Polynomial of degree n*:
"""

# ╔═╡ 733a8c9e-53a2-11ec-067f-0f7705eb3a27
md"""```math
f(c) + f'(c)\cdot(x-c) + \frac{f''(c)}{2!}(x-c)^2 + \cdots + \frac{f^{(n)}(c)}{n!} (x-c)^n.
```
"""

# ╔═╡ 733a8cbe-53a2-11ec-335f-118ebbca77e9
md"""This polynomial will be the best approximation of degree $n$ or less to the function $f$, near $c$. The error will be given - again by an application of the Cauchy mean value theorem:
"""

# ╔═╡ 733a8cfa-53a2-11ec-3b9e-af82492c0a55
md"""```math
\frac{1}{(n+1)!} \cdot f^{(n+1)}(\xi) \cdot (x-c)^n
```
"""

# ╔═╡ 733a8d0e-53a2-11ec-063d-2d4edbffae80
md"""for some $\xi$ between $c$ and $x$.
"""

# ╔═╡ 733a8d90-53a2-11ec-3f09-17a0139987d2
md"""The Taylor polynomial for $f$ about $c$ of degree $n$ can be computed by taking $n$ derivatives. For such a task, the computer is very helpful. In `SymPy` the `series` function will compute the Taylor polynomial for a given $n$. For example, here is the series expansion to 10 terms of the function $\log(1+x)$ about $c=0$:
"""

# ╔═╡ 733a9418-53a2-11ec-2ee4-23dd6fed8876
let
	c, n = 0, 10
	l = series(log(1 + x), x, c, n+1)
end

# ╔═╡ 733a9434-53a2-11ec-25e0-0b7704922ebd
md"""A pattern can be observed.
"""

# ╔═╡ 733a945c-53a2-11ec-3b74-49d66f28469e
md"""Using `series`, we can see Taylor polynomials for several familiar functions:
"""

# ╔═╡ 733a9a24-53a2-11ec-3877-fb7860bd3e3f
series(1/(1-x), x, 0, 10)   # sum x^i for i in 0:n

# ╔═╡ 733a9e34-53a2-11ec-3c59-67546a99e5e1
series(exp(x), x, 0, 10)    # sum x^i/i! for i in 0:n

# ╔═╡ 733aa1cc-53a2-11ec-2bc5-3f39866d6c4c
series(sin(x), x, 0, 10)    # sum (-1)^i * x^(2i+1) / (2i+1)! for i in 0:n

# ╔═╡ 733aa8a2-53a2-11ec-07b7-27d81c5454ea
series(cos(x), x, 0, 10)    # sum (-1)^i * x^(2i) / (2i)! for i in 0:n

# ╔═╡ 733aa8fe-53a2-11ec-3697-33d6731d1903
md"""Each of these last three have a pattern that can be expressed quite succinctly if the denominator is recognized as $n!$.
"""

# ╔═╡ 733aa97e-53a2-11ec-3d52-5151550627b2
md"""The output of `series` includes a big "Oh" term, which identifies the scale of the error term, but also gets in the way of using the output. `SymPy` provides the `removeO` method to strip this. (It is called as `object.removeO()`, as it is a method of an object in SymPy.)
"""

# ╔═╡ 733aceea-53a2-11ec-38f1-157d866d6303
note("""

A Taylor polynomial of degree ``n`` consists of ``n+1`` terms and an error term.
The "Taylor series" is an *infinite* collection of terms, the first ``n+1`` matching the Taylor polynomial of degree ``n``. The fact that series are *infinite* means care must be taken when even talking about their existence, unlike a Tyalor polynomial, which is just a polynomial and exists as long as a sufficient number of derivatives are available.

""")

# ╔═╡ 733acf9e-53a2-11ec-0a0e-63abf55766ce
md"""We define a function to compute Taylor polynomials from a function. The following returns a function, not a symbolic object, using `D`, from `CalculusWithJulia`, which is based on `ForwardDiff.derivative`, to find higher-order derivatives:
"""

# ╔═╡ 733b1e5e-53a2-11ec-0a0a-43bf1eeacf85
function taylor_poly(f, c=0, n=2)
     x -> f(c) + sum(D(f, i)(c) * (x-c)^i / factorial(i) for i in 1:n)
end

# ╔═╡ 733b1ece-53a2-11ec-1c46-e9fada3cd04a
md"""With a function, we can compare values. For example, here we see the difference between the Taylor polynomial and the answer for a small value of $x$:
"""

# ╔═╡ 733b23ea-53a2-11ec-1488-bfea5318a16a
let
	a = .1
	f(x) = log(1+x)
	Tn = taylor_poly(f, 0, 5)
	Tn(a) - f(a)
end

# ╔═╡ 733b28e0-53a2-11ec-1024-c56f8b903184
md"""### Plotting
"""

# ╔═╡ 733b293a-53a2-11ec-125b-ab97fd11d3df
md"""Let's now visualize a function and the two approximations - the Taylor polynomial and the interpolating polynomial. We use this function to generate the interpolating polynomial as a function:
"""

# ╔═╡ 733b7a84-53a2-11ec-35b4-e9000e74fd4c
function newton_form(f, xs)
  x -> begin
     tot = divided_differences(f, xs[1])
     for i in 2:length(xs)
        tot += divided_differences(f, xs[1:i]...) * prod([x-xs[j] for j in 1:(i-1)])
     end
     tot
  end
end

# ╔═╡ 733b7c00-53a2-11ec-3ee1-a581534ea077
md"""To see a plot, we have
"""

# ╔═╡ 733b9e10-53a2-11ec-0589-af1fbcf8daae
begin
	𝒇(x) = sin(x)
	𝒄, 𝒉, 𝒏 = 0, 1/4, 4
	int_poly = newton_form(𝒇, [𝒄 + i*𝒉 for i in 0:𝒏])
	tp = taylor_poly(𝒇, 𝒄, 𝒏)
	𝒂, 𝒃 = -pi, pi
	plot(𝒇, 𝒂, 𝒃; linewidth=5, label="f")
	plot!(int_poly; color=:green, label="interpolating")
	plot!(tp; color=:red, label="Taylor")
end

# ╔═╡ 733b9ece-53a2-11ec-040c-fff6c94c9a75
md"""To get a better sense, we plot the residual differences here:
"""

# ╔═╡ 733bc2dc-53a2-11ec-2cc8-4b65e632854a
begin
	d1(x) = 𝒇(x) - int_poly(x)
	d2(x) = 𝒇(x) - tp(x)
	plot(d1, 𝒂, 𝒃; color=:blue, label="interpolating")
	plot!(d2; color=:green, label="Taylor")
end

# ╔═╡ 733bc3fe-53a2-11ec-3bb3-d9b6505cb0df
md"""The graph should be $0$ at each of the the points in `xs`, which we can verify in the graph above. Plotting over a wider region shows a common phenomenon that these polynomials approximate the function near the values, but quickly deviate away:
"""

# ╔═╡ 733bc494-53a2-11ec-0574-cb9887c1adc9
md"""In this graph we make a plot of the Taylor polynomial for different sizes of $n$ for the function $f(x) = 1 - \cos(x)$:
"""

# ╔═╡ 733bcf14-53a2-11ec-13c6-019f73dc279f
let
	f(x) = 1 - cos(x)
	a, b = -pi, pi
	plot(f, a, b, linewidth=5, label="f")
	plot!(taylor_poly(f, 0, 2), label="T₂")
	plot!(taylor_poly(f, 0, 4), label="T₄")
	plot!(taylor_poly(f, 0, 6), label="T₆")
end

# ╔═╡ 733bcf98-53a2-11ec-3e08-5f704f37c609
md"""Though all are good approximations near $c=0$, as more terms are included, the Taylor polynomial becomes a better approximation over a wider range of values.
"""

# ╔═╡ 733bd018-53a2-11ec-34ba-45f20adab02c
md"""##### Example: Period of an orbiting satellite
"""

# ╔═╡ 733bd0ee-53a2-11ec-245a-a986ae61c7db
md"""Kepler's third [law](http://tinyurl.com/y7oa4x2g) of planetary motion states:
"""

# ╔═╡ 733bd272-53a2-11ec-1ff2-518942f22c34
md"""> The square of the orbital period of a planet is directly proportional to the cube of the semi-major axis of its orbit.

"""

# ╔═╡ 733bd38a-53a2-11ec-0912-d52ed8c8026c
md"""In formulas, $P^2 = a^3 \cdot (4\pi^2) / (G\cdot(M + m))$, where $M$ and $m$ are the respective masses. Suppose a satellite is in low earth orbit with a constant height, $a$. Use a Taylor polynomial to approximate the period using Kepler's third law to relate the quantities.
"""

# ╔═╡ 733bd41e-53a2-11ec-0093-eb06ffd396df
md"""Suppose $R$ is the radius of the earth and $h$ the height above the earth assuming $h$ is much smaller than $R$. The mass $m$ of a satellite is negligible to that of the earth, so $M+m=M$ for this purpose. We have:
"""

# ╔═╡ 733bd45c-53a2-11ec-10b4-5df2dc1798e2
md"""```math
P = \frac{2\pi}{\sqrt{G\cdot M}} \cdot (h+R)^{3/2} =  \frac{2\pi}{\sqrt{G\cdot M}} \cdot R^{3/2} \cdot (1 + h/R)^{3/2} = P_0 \cdot  (1 + h/R)^{3/2},
```
"""

# ╔═╡ 733bd4ca-53a2-11ec-286e-4f850c0f8b1d
md"""where $P_0$ collects terms that involve the constants.
"""

# ╔═╡ 733bd4de-53a2-11ec-110e-95a72203499d
md"""We can expand $(1+x)^{3/2}$ to fifth order, to get:
"""

# ╔═╡ 733bd4fc-53a2-11ec-32f5-01be8a3a947f
md"""```math
(1+x)^{3/2} \approx 1 + \frac{3x}{2} + \frac{3x^2}{8} - \frac{1x^3}{16} + \frac{3x^4}{128} -\frac{3x^5}{256}
```
"""

# ╔═╡ 733bd56a-53a2-11ec-0111-af9b3d28f90c
md"""Our approximation becomes:
"""

# ╔═╡ 733bd628-53a2-11ec-02d0-cf312a9d26f0
md"""```math
P \approx P_0 \cdot (1 + \frac{3(h/R)}{2} + \frac{3(h/R)^2}{8} - \frac{(h/R)^3}{16} + \frac{3(h/R)^4}{128} - \frac{3(h/R)^5}{256}).
```
"""

# ╔═╡ 733bd6dc-53a2-11ec-3b70-a5efb3b08ded
md"""Typically, if $h$ is much smaller than $R$ the first term is enough giving a formula like $P \approx P_0 \cdot(1 + \frac{3h}{2R})$.
"""

# ╔═╡ 733bd830-53a2-11ec-20b4-7d78d1c0e0d2
md"""A satellite phone utilizes low orbit satellites to relay phone communications. The [Iridium](http://www.kddi.com/english/business/cloud-network-voice/satellite/iridium/mobile/) system uses satellites with an elevation $h=780km$. The radius of the earth is $3,959 miles$, the mass of the earth is $5.972 × 10^{24} kg$, and the gravitational [constant](https://en.wikipedia.org/wiki/Gravitational_constant), $G$ is $6.67408 \cdot 10^{-11}$ $m^3/(kg \cdot s^2)$.
"""

# ╔═╡ 733bd84e-53a2-11ec-18e6-0b1e0a1b301f
md"""Compare the approximate value with $1$ term to the exact value.
"""

# ╔═╡ 733be0b4-53a2-11ec-1819-11d371427ee4
begin
	G = 6.67408e-11
	H = 780 * 1000
	R = 3959 * 1609.34   # 1609 meters per mile
	M = 5.972e24
	P0, HR = (2pi)/sqrt(G*M) * R^(3/2), H/R
	
	Preal = P0 * (1 + HR)^(3/2)
	P1 = P0 * (1 + 3*HR/2)
	Preal, P1
end

# ╔═╡ 733be0e6-53a2-11ec-2fde-69997f2e6e87
md"""With terms out to the fifth power, we get a better approximation:
"""

# ╔═╡ 733c268a-53a2-11ec-17de-814397b66a35
P5 = P0 * (1 + 3*HR/2 + 3*HR^2/8 - HR^3/16 + 3*HR^4/128 - 3*HR^5/256)

# ╔═╡ 733c2830-53a2-11ec-154c-ddc74b332142
md"""The units of the period above are in seconds. That answer here is about $100$ minutes:
"""

# ╔═╡ 733c2d8a-53a2-11ec-39df-9b0732b94ce7
Preal/60

# ╔═╡ 733c2e52-53a2-11ec-0b1f-9f1629c51008
md"""When $H$ is much smaller than $R$ the approximation with $5$th order is really good, and serviceable with just $1$ term. Next we check if this is the same when $H$ is larger than $R$.
"""

# ╔═╡ 733c2ec0-53a2-11ec-0238-d5d439c103a2
md"""---
"""

# ╔═╡ 733c2f06-53a2-11ec-06b7-e785b10ae989
md"""The height of a [GPS satellite](http://www.gps.gov/systems/gps/space/) is about $12,550$ miles. Compute the period of a circular orbit and compare with the estimates.
"""

# ╔═╡ 733c3622-53a2-11ec-1eff-1f201d027cde
begin
	Hₛ = 12250 * 1609.34   # 1609 meters per mile
	HRₛ = Hₛ/R
	
	Prealₛ = P0 * (1 + HRₛ)^(3/2)
	P1ₛ = P0 * (1 + 3*HRₛ/2)
	P5ₛ = P0 * (1 + 3*HRₛ/2 + 3*HRₛ^2/8 - HRₛ^3/16 + 3*HRₛ^4/128 - 3*HRₛ^5/256)
	
	Prealₛ, P1ₛ, P5ₛ
end

# ╔═╡ 733c36f4-53a2-11ec-09c6-a77f0520682a
md"""We see the Taylor polynomial underestimates badly in this case. A reminder that these approximations are locally good, but may not be good on all scales. Here $h \approx 3R$. We can see from this graph of $(1+x)^{3/2}$ and its $5$th degree Taylor polynomial $T_5$ that it is a bad approximation when $x > 2$.
"""

# ╔═╡ 733c4054-53a2-11ec-11d8-87d5249063f2
begin
	f1(x) = (1+x)^(3/2)
	p2(x) = 1 + 3x/2 + 3x^2/8 - x^3/16 + 3x^4/128 - 3x^5/256
	plot(f1, -1, 3, linewidth=4, legend=false)
	plot!(p2, -1, 3)
end

# ╔═╡ 733c40c2-53a2-11ec-23c8-b13babedc50b
md"""---
"""

# ╔═╡ 733c4150-53a2-11ec-3e0a-3571784edb0a
md"""Finally, we show how to use the `Unitful` package. This package allows us to define different units, carry these units through computations, and convert between similar units with `uconvert`. In this example, we define several units, then show how they can then be used as constants.
"""

# ╔═╡ 733c51ac-53a2-11ec-0d17-2b9a857c3550
let
	m, mi, kg, s, hr = u"m", u"mi", u"kg", u"s", u"hr"
	
	G = 6.67408e-11 * m^3 / kg / s^2
	H = uconvert(m, 12250 * mi)   # unit convert miles to meter
	R = uconvert(m,  3959 * mi)
	M = 5.972e24 * kg
	
	P0, HR = (2pi)/sqrt(G*M) * R^(3/2), H/R
	Preal = P0 * (1 + HR)^(3/2)    # in seconds
	Preal, uconvert(hr, Preal)     # ≈ 11.65 hours
end

# ╔═╡ 733c51f2-53a2-11ec-0dc8-d3673757fa2e
md"""We see `Preal` has the right units - the units of mass and distance cancel leaving a measure of time - but it is hard to sense how long this is. Converting to hours, helps us see the satellite orbits about twice per day.
"""

# ╔═╡ 733c5274-53a2-11ec-29c6-1f904abfa2f3
md"""##### Example Computing $\log(x)$
"""

# ╔═╡ 733c53aa-53a2-11ec-096d-b74e41a66a4d
md"""Where exactly does the value assigned to $\log(5)$ come from? The value needs to be computed. At some level, many questions resolve down to the basic operations of addition, subtraction, multiplication, and division. Preferably not the latter, as division is slow. Polynomials then should be fast to compute, and so computing logarithms using a polynomial becomes desirable.
"""

# ╔═╡ 733c544a-53a2-11ec-2da7-cd26636c2a26
md"""But how? One can see details of a possible way [here](https://github.com/musm/Amal.jl/blob/master/src/log.jl).
"""

# ╔═╡ 733c6bba-53a2-11ec-2b55-5b11908eedb5
md"""First, there is usually a reduction stage. In this phase, the problem is transformed in a manner to one involving only a fixed interval of values. For this, function values of $k$ and $m$ are found so that $x = 2^k \cdot (1+m)$ *and* $\sqrt{2}/2 < 1+m < \sqrt{2}$. If these are found, then $\log(x)$ can be computed with $k \cdot \log(2) + \log(1+m)$. The first value - a multiplication - can easily be computed using  pre-computed value of $\log(2)$, the second then *reduces* the problem to an interval.
"""

# ╔═╡ 733c6cdc-53a2-11ec-1439-f3ad1cbf4e75
md"""Now, for this problem a further trick is utilized, writing $s= f/(2+f)$ so that $\log(1+m)=\log(1+s)-\log(1-s)$ for some small range of $s$ values. These combined make it possible to compute $\log(x)$ for any real $x$.
"""

# ╔═╡ 733c6d18-53a2-11ec-2f63-0192b71dbe9c
md"""To compute $\log(1\pm s)$, we can find a Taylor polynomial. Let's go out to degree $19$ and use `SymPy` to do the work:
"""

# ╔═╡ 733c731c-53a2-11ec-00bb-b56743ea038b
begin
	@syms s
	aₗ = series(log(1 + s), s, 0, 19)
	bₗ = series(log(1 - s), s, 0, 19)
	a_b = (aₗ - bₗ).removeO()  # remove"Oh" not remove"zero"
end

# ╔═╡ 733c8be2-53a2-11ec-347a-3500dc8d0eb4
md"""This is re-expressed as $2s + s \cdot p$ with $p$ given by:
"""

# ╔═╡ 733c9234-53a2-11ec-3aa7-0dda4404da9d
cancel(a_b - 2s/s)

# ╔═╡ 733c927a-53a2-11ec-2000-7b0005618222
md"""Now, $2s = m - s\cdot m$, so the above can be reworked to be $\log(1+m) = m - s\cdot(m-p)$.
"""

# ╔═╡ 733c92d4-53a2-11ec-0793-a19cfffb63df
md"""(For larger values of $m$, a similar, but different approximation, can be used to minimize floating point errors.)
"""

# ╔═╡ 733c93f6-53a2-11ec-3023-8dfbecb6b78c
md"""How big can the error be between this *approximations* and $\log(1+m)$? We plot to see how big $s$ can be:
"""

# ╔═╡ 733c9946-53a2-11ec-2df7-73bd5f9262c7
begin
	@syms v
	plot(v/(2+v), sqrt(2)/2 - 1, sqrt(2)-1)
end

# ╔═╡ 733c996e-53a2-11ec-397c-af9c5ee3cc58
md"""This shows, $s$ is as big as
"""

# ╔═╡ 733cc100-53a2-11ec-061e-f95366b14a5f
Max = (v/(2+v))(v => sqrt(2) - 1)

# ╔═╡ 733cc178-53a2-11ec-225d-9d3ee920c3ca
md"""The error term is like $2/19 \cdot \xi^{19}$ which  is largest at this value of $M$. Large is relative - it is really small:
"""

# ╔═╡ 733cc8a8-53a2-11ec-1c1b-4719848f5814
(2/19)*Max^19

# ╔═╡ 733cc936-53a2-11ec-1754-432e1c27df5a
md"""Basically that is machine precision. Which means, that as far as can be told on the computer, the value produced by $2s + s \cdot p$ is about as accurate as can be done.
"""

# ╔═╡ 733cc9b6-53a2-11ec-11ff-fb579a054371
md"""To try this out to compute $\log(5)$. We have $5 = 2^2(1+0.25)$, so $k=2$ and $m=0.25$.
"""

# ╔═╡ 733cd09e-53a2-11ec-2601-8b24f2dfd544
begin
	k, m = 2, 0.25
	𝒔 = m / (2+m)
	pₗ = 2 * sum(𝒔^(2i)/(2i+1) for i in 1:8)  # where the polynomial approximates the logarithm...
	
	log(1 + m), m - 𝒔*(m-pₗ), log(1 + m) - ( m - 𝒔*(m-pₗ))
end

# ╔═╡ 733cd118-53a2-11ec-0a6d-97af6baf7e0f
md"""The two values differ by less than $10^{-16}$, as advertised. Re-assembling then, we compare the computed values:
"""

# ╔═╡ 733cf422-53a2-11ec-277c-0b67c0334767
Δ = k * log(2) + (m - 𝒔*(m-pₗ)) - log(5)

# ╔═╡ 733cf490-53a2-11ec-0e68-b1a31ba32348
md"""The actual  code is different, as the Taylor polynomial isn't used. The Taylor polynomial is a great approximation near a point, but there might be better polynomial approximations for all values in an interval. In this case there is, and that polynomial is used in the production setting. This makes things a bit more efficient, but the basic idea remains - for a prescribed accuracy, a polynomial approximation can be found over a given interval, which can be cleverly utilized to solve for all applicable values.
"""

# ╔═╡ 733cf4f4-53a2-11ec-2f3a-416bc67f055c
md"""##### Example Higher order derivatives of the inverse function
"""

# ╔═╡ 733cf576-53a2-11ec-052d-07564d9876a4
md"""For notational purposes, let $g(x)$ be the inverse function for $f(x)$. Assume *both* functions have a Taylor polynomial expansion:
"""

# ╔═╡ 733cf5ee-53a2-11ec-1523-991574cbaa9a
md"""```math
\begin{align*}
f(x_0 + \Delta_x) &= f(x_0) + a_1 \Delta_x + a_2 (\Delta_x)^2 + \cdots a_n (\Delta_x)^n + \dots\\
g(y_0 + \Delta_y) &= g(y_0) + b_1 \Delta_y + b_2 (\Delta_y)^2 + \cdots b_n (\Delta_y)^n + \dots
\end{align*}
```
"""

# ╔═╡ 733cf648-53a2-11ec-0ddf-e57a84439370
md"""Then using $x = g(f(x))$, we have expanding the terms and using $\approx$ to drop the $\dots$:
"""

# ╔═╡ 733cf65c-53a2-11ec-2103-b12b692eff6d
md"""```math
\begin{align*}
x_0 + \Delta_x &= g(f(x_0 + \Delta_x)) \\
&\approx g(f(x_0) + \sum_{j=1}^n a_j (\Delta_x)^j) \\
&\approx g(f(x_0)) + \sum_{i=1}^n b_i \left(\sum_{j=1}^n a_j (\Delta_x)^j \right)^i \\
&\approx x_0 + \sum_{i=1}^{n-1} b_i \left(\sum_{j=1}^n a_j (\Delta_x)^j\right)^i + b_n \left(\sum_{j=1}^n a_j (\Delta_x)^j\right)^n
\end{align*}
```
"""

# ╔═╡ 733cf6a4-53a2-11ec-165b-bfe438639d63
md"""That is:
"""

# ╔═╡ 733cf742-53a2-11ec-1754-b18800a7899e
md"""```math
b_n \left(\sum_{j=1}^n a_j (\Delta_x)^j \right)^n =
(x_0 + \Delta_x) - \left( x_0 + \sum_{i=1}^{n-1} b_i \left(\sum_{j=1}^n a_j (\Delta_x)^j \right)^i \right)
```
"""

# ╔═╡ 733cf7ce-53a2-11ec-331c-a7caa4f3e438
md"""Solving for $b_n = g^{(n)}(y_0) / n!$ gives the formal expression:
"""

# ╔═╡ 733cf904-53a2-11ec-1384-956b3694c250
md"""```math
g^{(n)}(y_0) = n! \cdot \lim_{\Delta_x \rightarrow 0}
\frac{\Delta_x -  \sum_{i=1}^{n-1} b_i \left(\sum_{j=1}^n a_j (\Delta_x)^j \right)^i}{
\left(\sum_{j=1}^n a_j \left(\Delta_x^j\right)^i\right)^n}
```
"""

# ╔═╡ 733cf942-53a2-11ec-0959-b70de2ecb773
md"""(This is following [Liptaj](https://vixra.org/pdf/1703.0295v1.pdf)).
"""

# ╔═╡ 733cf974-53a2-11ec-0e59-c30fbbe96f11
md"""We will use `SymPy` to take this limit for the first `4` derivatives. Here is some code that expands $x + \Delta_x = g(f(x_0 + \Delta_x))$ and then uses `SymPy` to solve:
"""

# ╔═╡ 733d249c-53a2-11ec-006c-53c4e5893f14
begin
	@syms x₀ Δₓ f′[1:4] g′[1:4]
	
	as(i) = f′[i]/factorial(i)
	bs(i) = g′[i]/factorial(i)
	
	gᵏs = Any[]
	eqns = Any[]
	for n ∈ 1:4
	    Δy = sum(as(j) * Δₓ^j for j ∈ 1:n)
	    left = x₀ + Δₓ
	    right = x₀ + sum(bs(i)*Δy^i for i ∈ 1:n)
	
	    eqn = left ~ right
	    push!(eqns, eqn)
	
	    gⁿ = g′[n]
	    ϕ = solve(eqn, gⁿ)[1]
	
	    # replace g′ᵢs in terms of computed f′ᵢs
	    for j ∈ 1:n-1
	        ϕ = subs(ϕ, g′[j] => gᵏs[j])
	    end
	
	    L = limit(ϕ, Δₓ => 0)
	    push!(gᵏs, L)
	
	end
	gᵏs
end

# ╔═╡ 733d2532-53a2-11ec-3dc6-33704cdacdc6
md"""We can see the expected `g' = 1/f'` (where the point of evalution is $g(y) = 1/f'(f^{-1}(y))$ is not written). In addition, we get 3 more formulas, hinting that the answers grow rapidly in terms of their complexity.
"""

# ╔═╡ 733d2564-53a2-11ec-2c14-b77bbb223253
md"""In the above, for each `n`, the code above sets up the two sides, `left` and `right`, of an equation involving the higher-order derivatives of $g$. For example, when `n=2` we have:
"""

# ╔═╡ 733d2a78-53a2-11ec-37e5-7bc5d188fee1
eqns[2]

# ╔═╡ 733d2ac8-53a2-11ec-3dd1-3fc58656a290
md"""The `solve` function is used to identify $g^{(n)}$ represented in terms of lower-order derivatives of $g$. These values have been computed and stored and are then substituted into `ϕ`. Afterwards a limit is taken and the answer recorded.
"""

# ╔═╡ 733d2b40-53a2-11ec-1360-47407e9f9c6c
md"""## Questions
"""

# ╔═╡ 733d2cda-53a2-11ec-1092-ef0b22f78a93
md"""###### Question
"""

# ╔═╡ 733d2d5c-53a2-11ec-39aa-19bcd6685fb0
md"""Compute the Taylor polynomial  of degree $10$ for $\sin(x)$ about $c=0$ using `SymPy`. Based on the form, which formula seems appropriate:
"""

# ╔═╡ 733d406e-53a2-11ec-0f5b-e961d7b7aee8
let
	choices = [
	"``\\sum_{k=0}^{10} x^k``",
	"``\\sum_{k=1}^{10} (-1)^{n+1} x^n/n``",
	"``\\sum_{k=0}^{4} (-1)^k/(2k+1)! \\cdot x^{2k+1}``",
	"``\\sum_{k=0}^{10} x^n/n!``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 733d42cc-53a2-11ec-3ff3-69601d32b987
md"""###### Question
"""

# ╔═╡ 733d43f0-53a2-11ec-20a7-a9237d15a4a1
md"""Compute the Taylor polynomial  of degree 10 for $e^x$ about $c=0$ using `SymPy`. Based on the form, which formula seems appropriate:
"""

# ╔═╡ 733d4be0-53a2-11ec-3572-ab1149e35600
let
	choices = [
	"``\\sum_{k=0}^{10} x^k``",
	"``\\sum_{k=1}^{10} (-1)^{n+1} x^n/n``",
	"``\\sum_{k=0}^{4} (-1)^k/(2k+1)! \\cdot x^{2k+1}``",
	"``\\sum_{k=0}^{10} x^n/n!``"
	]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ 733d4c06-53a2-11ec-20f6-e31c64ef9cb6
md"""###### Question
"""

# ╔═╡ 733d4c92-53a2-11ec-1d78-c5f1032e881d
md"""Compute the Taylor polynomial  of degree 10 for $1/(1-x)$ about $c=0$ using `SymPy`. Based on the form, which formula seems appropriate:
"""

# ╔═╡ 733d80f6-53a2-11ec-3127-037a4c1b26a2
let
	choices = [
	"``\\sum_{k=0}^{10} x^k``",
	"``\\sum_{k=1}^{10} (-1)^{n+1} x^n/n``",
	"``\\sum_{k=0}^{4} (-1)^k/(2k+1)! \\cdot x^{2k+1}``",
	"``\\sum_{k=0}^{10} x^n/n!``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 733d8180-53a2-11ec-1777-ad48c6d5298a
md"""###### Question
"""

# ╔═╡ 733d8266-53a2-11ec-0a19-affa94f58cb5
md"""Let $T_5(x)$ be the Taylor polynomial of degree 5 for the function $\sqrt{1+x}$ about $x=0$. What is the coefficient of the $x^5$ term?
"""

# ╔═╡ 733d8978-53a2-11ec-3c2b-3bcbcd846689
let
	choices = [
	"``7/256``",
	"``-5/128``",
	"``1/5!``",
	"``2/15``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 733d89a0-53a2-11ec-0395-319a06225099
md"""###### Question
"""

# ╔═╡ 733d8aae-53a2-11ec-0546-6d4d61548b52
md"""The 5th order Taylor polynomial for $\sin(x)$ about $c=0$ is: $x - x^3/3! + x^5/5!$. Use this to find the first 3 terms of the Taylor polynomial of $\sin(x^2)$ about $c=0$.
"""

# ╔═╡ 733d8ab8-53a2-11ec-2538-8df3f8d01ce3
md"""They are:
"""

# ╔═╡ 733d90c6-53a2-11ec-27ab-b12d7f4bb6fa
let
	choices = [
	"``x^2 - x^6/3! + x^{10}/5!``",
	"``x^2``",
	"``x^2 \\cdot (x - x^3/3! + x^5/5!)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 733d912a-53a2-11ec-1d4e-5f85921896b9
md"""###### Question
"""

# ╔═╡ 733da820-53a2-11ec-36fa-abeaacf34f7b
md"""A more direct derivation of the form of the Taylor polynomial (here taken about $c=0$) is to *assume* a polynomial form that matches $f$:
"""

# ╔═╡ 733da868-53a2-11ec-0fb4-214b656d30f1
md"""```math
f(x) = a + bx + cx^2 + dx^3 + ex^4 + \cdots
```
"""

# ╔═╡ 733da8f6-53a2-11ec-2dd4-1f5bad414f3a
md"""If this is true, then formally evaluating at $x=0$ gives $f(0) = a$, so $a$ is determined. Similarly, formally differentiating and evaluating at $0$ gives $f'(0) = b$. What is the result of formally differentiating $4$ times and evaluating at $0$:
"""

# ╔═╡ 733dc7e2-53a2-11ec-1a8c-6134f3fead89
let
	choices = ["``f''''(0) = e``",
	"``f''''(0) = 4 \\cdot 3 \\cdot 2 e = 4! e``",
	"``f''''(0) = 0``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 733dc854-53a2-11ec-3841-01e03828f5a8
md"""###### Question
"""

# ╔═╡ 733dc918-53a2-11ec-0e81-09eb7a231989
md"""How big an error is there in approximating $e^x$ by its 5th degree Taylor polynomial about $c=0$, $1 + x + x^2/2! + x^3/3! + x^4/4! + x^5/5!$?, over $[-1,1]$.
"""

# ╔═╡ 733dc938-53a2-11ec-21e5-773f7a2c2c9b
md"""The error is known to be $(  f^{(6)}(\xi)/6!) \cdot x^6$ for some $\xi$ in $[-1,1]$.
"""

# ╔═╡ 733dca32-53a2-11ec-2f73-cb61da15b210
md"""  * The 6th derivative of $e^x$ is still $e^x$:
"""

# ╔═╡ 733dce1a-53a2-11ec-3490-57ced91f9b90
let
	yesnoq(true)
end

# ╔═╡ 733dcece-53a2-11ec-194b-0f2c3da381fb
md"""  * Which is true about the function $e^x$:
"""

# ╔═╡ 733dd664-53a2-11ec-084b-013dd3320877
let
	choices =["It is increasing", "It is decreasing", "It both increases and decreases"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 733dd6e4-53a2-11ec-06fe-4bed1fb739cd
md"""  * The maximum value of $e^x$ over $[-1,1]$ occurs at
"""

# ╔═╡ 733ddd7e-53a2-11ec-38ca-290e518c8c77
let
	choices=["A critical point", "An end point"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 733dde96-53a2-11ec-3583-5317cf1d9fac
md"""  * Which theorem tells you that for a *continuous* function over  *closed* interval, a maximum value will exist?
"""

# ╔═╡ 733de4ae-53a2-11ec-36dd-2da33470c394
let
	choices = [
	"The intermediate value theorem",
	"The mean value theorem",
	"The extreme value theorem"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 733de578-53a2-11ec-363d-bddadb07a4ab
md"""  * What is the *largest* possible value of the error:
"""

# ╔═╡ 733deaf8-53a2-11ec-114a-9ff146ba3d9b
let
	choices = [
	"``1/6!\\cdot e^1 \\cdot 1^6``",
	"``1^6 \\cdot 1 \\cdot 1^6``"]
	ans = 1
	radioq(choices,ans)
end

# ╔═╡ 733deb66-53a2-11ec-0cee-7b9faf6af5de
md"""###### Question
"""

# ╔═╡ 733dec1c-53a2-11ec-0abb-8dfe4f10714d
md"""The error in using $T_k(x)$ to approximate $e^x$ over the interval $[-1/2, 1/2]$ is $(1/(k+1)!) e^\xi x^{k+1}$, for some $\xi$ in the interval. This is *less* than $1/((k+1)!) e^{1/2} (1/2)^{k+1}$.
"""

# ╔═╡ 733dec60-53a2-11ec-39b6-05be7588df27
md"""  * Why?
"""

# ╔═╡ 733e0d46-53a2-11ec-1ae2-1bf714e5f461
let
	choices = [
	L"The function $e^x$ is increasing, so takes on its largest value at the endpoint and the function $|x^n| \leq |x|^n \leq (1/2)^n$",
	L"The function has a critical point at $x=1/2$",
	L"The function is monotonic in $k$, so achieves its maximum at $k+1$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 733e0d94-53a2-11ec-2ff4-45c5c8ec7eee
md"""Assuming the above is right, find the smallest value $k$ guaranteeing a error no more than $10^{-16}$.
"""

# ╔═╡ 733e30bc-53a2-11ec-2081-5705e2af30dd
let
	f(k) = 1/factorial(k+1) * exp(1/2) * (1/2)^(k+1)
	(f(13) > 1e-16 && f(14) < 1e-16) && numericq(14)
end

# ╔═╡ 733e3256-53a2-11ec-2837-3345b9f96002
md"""  * The function $f(x) = (1 - x + x^2) \cdot e^x$ has a Taylor polynomial about 0 such that all coefficients are rational numbers. Is it true that the numerators are all either 1 or prime? (From the 2014 [Putnam](http://kskedlaya.org/putnam-archive/2014.pdf) exam.)
"""

# ╔═╡ 733e32ba-53a2-11ec-2fa2-a7c71de582f8
md"""Here is one way to get all the values bigger than 1:
"""

# ╔═╡ 733e3968-53a2-11ec-1e84-29853bfb279d
let
	ex = (1 - x + x^2)*exp(x)
	Tn = series(ex, x, 0, 100).removeO()
	ps = sympy.Poly(Tn, x).coeffs()
	qs = numer.(ps)
	qs[qs .> 1]  |> Tuple # format better for output
end

# ╔═╡ 733e3a08-53a2-11ec-07d7-a7d3753bea9b
md"""Verify by hand that each of the remaining values is a prime number to answer the question (Or you can use `sympy.isprime.(qs)`).
"""

# ╔═╡ 733e3a1e-53a2-11ec-0c11-d7669b751f25
md"""Are they all prime or $1$?
"""

# ╔═╡ 733e3c7c-53a2-11ec-0170-154debbad1c2
let
	yesnoq(true)
end

# ╔═╡ 733e3d5a-53a2-11ec-115a-bb0724dd355b
md"""## Appendix
"""

# ╔═╡ 733e3e04-53a2-11ec-3678-71d6992c6f2a
md"""We mentioned two facts that could use a proof: the Newton form of the interpolating polynomial and the mean value theorem for divided differences. Our explanation tries to emphasize a parallel with the secant line's relationship with the tangent line. The standard way to discuss  Taylor polynomials is different and so these two proofs are not in most calculus texts.
"""

# ╔═╡ 733e3f1a-53a2-11ec-2839-a303880581e0
md"""A [proof](https://www.math.uh.edu/~jingqiu/math4364/interpolation.pdf) of the Newton form can be done knowing that the interpolating polynomial is unique and can be expressed either as $g(x)=a_0 + a_1 (x-x_0) + \cdots + a_n (x-x_0)\cdot\cdots\cdot(x-x_{n-1})$ *or* in this reversed form $h(x)=b_0 + b_1 (x-x_n) + b_2(x-x_n)(x-x_{n-1}) + \cdots + b_n (x-x_n)(x-x_{n-1})\cdot\cdots\cdot(x-x_1).$ These two polynomials are of degree $n$ at most and have $u(x) = h(x)-g(x)=0$, by uniqueness. So the coefficients of $u(x)$ are $0$. We have that the coefficient of $x^n$ must be $a_n-b_n$ so $a_n=b_n$. Our goal is to express $a_n$ in terms of $a_{n-1}$ and $b_{n-1}$. Focusing on the $x^{n-1}$ term, we have:
"""

# ╔═╡ 733e3f76-53a2-11ec-12d0-87ae5f0e27d8
md"""```math
\begin{align*}
b_n(x-x_n)(x-x_{n-1})\cdot\cdots\cdot(x-x_1)
&- a_n\cdot(x-x_0)\cdot\cdots\cdot(x-x_{n-1}) \\
&=
a_n [(x-x_1)\cdot\cdots\cdot(x-x_{n-1})] [(x- x_n)-(x-x_0)] \\
&= -a_n \cdot(x_n - x_0) x^{n-1} + p_{n-2},
\end{align*}
```
"""

# ╔═╡ 733e3fa8-53a2-11ec-3f3c-e910f9edc4ac
md"""where $p_{n-2}$ is a polynomial of at most degree $n-2$. (The expansion of $(x-x_1)\cdot\cdots\cdot(x-x_{n-1}))$ leaves $x^{n-1}$ plus some lower degree polynomial.) Similarly, we have $a_{n-1}(x-x_0)\cdot\cdots\cdot(x-x_{n-2}) = a_{n-1}x^{n-1} + q_{n-2}$ and $b_{n-1}(x-x_n)\cdot\cdots\cdot(x-x_2) = b_{n-1}x^{n-1}+r_{n-2}$. Combining, we get that the $x^{n-1}$ term of $u(x)$ is
"""

# ╔═╡ 733e3fb2-53a2-11ec-2dd6-05f0720d3d2b
md"""```math
(b_{n-1}-a_{n-1}) - a_n(x_n-x_0) = 0.
```
"""

# ╔═╡ 733e4016-53a2-11ec-1a29-af22c2ae94ec
md"""On rearranging, this yields $a_n = (b_{n-1}-a_{n-1}) / (x_n - x_0)$. By *induction* - that $a_i=f[x_0, x_1, \dots, x_i]$ and $b_i = f[x_n, x_{n-1}, \dots, x_{n-i}]$ (which has trivial base case) - this is $(f[x_1, \dots, x_n] - f[x_0,\dots x_{n-1}])/(x_n-x_0)$.
"""

# ╔═╡ 733e4048-53a2-11ec-26e8-2366f672e02c
md"""Now, assuming the Newton form is correct, a [proof](http://tinyurl.com/zjogv83) of the mean value theorem for divided differences comes down to Rolle's theorem. Starting from the Newton form of the polynomial and expanding in terms of $1, x, \dots, x^n$ we see that $g(x) = p_{n-1}(x) + f[x_0, x_1, \dots,x_n]\cdot x^n$, where now $p_{n-1}(x)$ is a polynomial of degree  at most $n-1$. That is, the coefficient of $x^n$ is $f[x_0, x_1, \dots, x_n]$. Consider  the function $h(x)=f(x) - g(x)$. It has zeros $x_0, x_1, \dots, x_n$.
"""

# ╔═╡ 733e4070-53a2-11ec-3245-71c2390ca71e
md"""By Rolle's theorem, between any two such zeros $x_i, x_{i+1}$, $0 \leq i < n$ there must be a zero of the derivative of $h(x)$, say $\xi^1_i$. So $h'(x)$ has zeros $\xi^1_0 < \xi^1_1 < \dots < \xi^1_{n-1}$.
"""

# ╔═╡ 733e4126-53a2-11ec-0c67-8bc8a55a4807
md"""We visualize this with $f(x) = \sin(x)$ and $x_i = i$ for $i=0, 1, 2, 3$, The $x_i$ values are indicated with circles, the $\xi^1_i$ values indicated with squares:
"""

# ╔═╡ 733e4688-53a2-11ec-2804-4733ab15c28e
let
	f(x) = sin(x)
	xs = 0:3
	dd = divided_differences
	g(x) = dd(f,0) + dd(f, 0,1)*x + dd(f, 0,1,2)*x*(x-1) + dd(f, 0,1,2,3)*x*(x-1)*(x-2)
	h1(x) = f(x) - g(x)
	cps = find_zeros(D(h1), -1, 4)
	plot(h1, -1/4, 3.25, linewidth=3, legend=false)
	scatter!(xs, h1.(xs), markersize=5)
	scatter!(cps, h1.(cps), markersize=5, marker=:square)
end

# ╔═╡ 733e47be-53a2-11ec-265f-af5f36f49c75
md"""Again by Rolle's theorem, between any pair of adjacent zeros $\xi^1_i, \xi^1_{i+1}$ there must be a zero $\xi^2_i$ of $h''(x)$. So there are $n-1$ zeros of $h''(x)$. Continuing, we see that there will be $n+1-3$ zeros of $h^{(3)}(x)$, $n+1-4$ zeros of $h^{4}(x)$, $\dots$, $n+1-(n-1)$ zeros of $h^{n-1}(x)$, and finally $n+1-n$ ($1$) zeros of $h^{(n)}(x)$. Call this last zero $\xi$. It satisfies $x_0 \leq \xi \leq x_n$. Further, $0 = h^{(n)}(\xi) = f^{(n)}(\xi)  - g^{(n)}(\xi)$. But $g$ is a degree $n$ polynomial, so the $n$th derivative is the coefficient of $x^n$ times $n!$. In this case we have $0 = f^{(n)}(\xi) - f[x_0, \dots, x_n] n!$. Rearranging yields the result.
"""

# ╔═╡ 733e4926-53a2-11ec-3d0b-77c5c4fd2193
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/related_rates.html">◅ previous</a>  <a href="../integrals/area.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/taylor_series_polynomials.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 733e4932-53a2-11ec-1efb-b1cf95f628ff
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
SymPy = "~1.1.2"
Unitful = "~1.9.2"
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

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

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

[[Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

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

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "0992ed0c3ef66b0390e5752fe60054e5ff93b908"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.9.2"

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
# ╟─733e488e-53a2-11ec-39e5-e1b805f36c38
# ╟─73374a9a-53a2-11ec-1eac-fbcc035135ed
# ╟─73377ad8-53a2-11ec-1328-a7e200f24885
# ╠═73382fc8-53a2-11ec-3b3e-cbe001720a5e
# ╟─73385160-53a2-11ec-1d3d-758f75e53230
# ╟─7338570a-53a2-11ec-1a68-bb36e816ef40
# ╟─733857be-53a2-11ec-3107-6d18a0a1b3ef
# ╟─733857dc-53a2-11ec-26b3-4d906a5f73c1
# ╟─7338587c-53a2-11ec-388e-ab31646a1ef0
# ╟─7338b81c-53a2-11ec-2726-e329062aea33
# ╟─7338d59a-53a2-11ec-3aa6-631373462317
# ╟─7338dd88-53a2-11ec-0a47-8140b10ad1ba
# ╟─7338ddfe-53a2-11ec-3061-03669abc0db3
# ╟─7338de6e-53a2-11ec-090b-331815c39ce8
# ╟─733944c6-53a2-11ec-2eae-a778132841e8
# ╟─733948cc-53a2-11ec-1bd3-1bd3662304b4
# ╟─733948fe-53a2-11ec-0cd3-731e2e083895
# ╟─73394a16-53a2-11ec-2557-1190c0def7c3
# ╟─73394a66-53a2-11ec-26bd-839493b66875
# ╟─73394a98-53a2-11ec-1cd8-097d14528500
# ╟─73394b38-53a2-11ec-1278-f12dc7908773
# ╟─73394c34-53a2-11ec-1f48-c5f719c4e74e
# ╟─73394c82-53a2-11ec-212d-cfbb086128de
# ╟─73394c8c-53a2-11ec-1dd0-65bc4d2f185c
# ╟─73394cd2-53a2-11ec-0be6-d51c0258dbc9
# ╟─73394dc2-53a2-11ec-3eb7-ed40aae112c5
# ╟─73394dce-53a2-11ec-2aaa-d700ed8f0846
# ╟─73395472-53a2-11ec-0282-8d839683322e
# ╟─733954b6-53a2-11ec-35e8-bdc83ce2a999
# ╟─7339551a-53a2-11ec-1d85-adb882e8b75f
# ╟─73395524-53a2-11ec-05d2-6d18f90d24bb
# ╟─733957fe-53a2-11ec-2885-fb70be29f50a
# ╟─733958dc-53a2-11ec-29f8-77ab793e361c
# ╟─7339592a-53a2-11ec-2bf4-f541558adafa
# ╟─7339597a-53a2-11ec-1ae9-617422c00663
# ╟─73395984-53a2-11ec-2d88-69adb55a651d
# ╟─73395a1a-53a2-11ec-387a-7bb48d157a22
# ╟─73395aba-53a2-11ec-354c-d3033d98393b
# ╟─73395c7c-53a2-11ec-0f15-a558a8384cb1
# ╠═733964a6-53a2-11ec-396c-67b41ba67b4a
# ╟─73396578-53a2-11ec-225a-27df01caef9b
# ╠═73398c56-53a2-11ec-11ea-b33a05de58c5
# ╟─73398d00-53a2-11ec-0716-d73def700383
# ╠═7339ab76-53a2-11ec-2072-39b656521457
# ╟─7339abfa-53a2-11ec-3ec0-e9950411db89
# ╠═7339b302-53a2-11ec-2a4c-05c0594f8a09
# ╟─7339b3ca-53a2-11ec-1cdd-455bfeba1592
# ╠═7339e5de-53a2-11ec-2e56-c9f778308add
# ╟─7339e6f6-53a2-11ec-0a10-61d6e8401ee4
# ╠═7339eb88-53a2-11ec-17ef-1b7126ca1971
# ╟─7339edcc-53a2-11ec-2212-956b1d8982bf
# ╟─7339eeb2-53a2-11ec-14b5-c9791eceaef0
# ╟─7339effc-53a2-11ec-3894-f9266ed2c615
# ╟─7339f02e-53a2-11ec-08e5-27fdaac6815d
# ╟─7339f100-53a2-11ec-1ec0-1bc7e03c2b5c
# ╟─7339f10c-53a2-11ec-01c2-cff31e4520a4
# ╟─7339f1dc-53a2-11ec-1118-a38c994f0768
# ╟─7339f2ae-53a2-11ec-0909-fb0d58fab083
# ╟─7339f34e-53a2-11ec-1525-c7e3c5b0b467
# ╟─7339f39e-53a2-11ec-3620-b9e371f148c2
# ╟─7339f43c-53a2-11ec-0230-5919e6f432d3
# ╟─7339f498-53a2-11ec-367c-a5450d101e78
# ╟─7339f4fc-53a2-11ec-11a1-799ce5c94958
# ╠═7339feea-53a2-11ec-2232-f591a2577718
# ╟─7339ff24-53a2-11ec-320f-e57383e45f97
# ╟─733a0000-53a2-11ec-26ac-ef96a149b9e8
# ╟─733a0014-53a2-11ec-03bb-c98f531bc942
# ╠═733a0c1c-53a2-11ec-1d7b-d55a44cef739
# ╟─733a0cd0-53a2-11ec-1e49-5f3db916872f
# ╠═733a131a-53a2-11ec-3db4-75d939600288
# ╟─733a1392-53a2-11ec-3be1-8d2a0241d22e
# ╠═733a32f0-53a2-11ec-2543-49de4d8c8784
# ╟─733a3386-53a2-11ec-38c6-1b2f15e23fc9
# ╠═733a51e0-53a2-11ec-0bc7-cd7ee3c84ac3
# ╟─733a53f4-53a2-11ec-08c0-7599f5d5f01c
# ╟─733a5422-53a2-11ec-04a9-4b2ff33193a3
# ╟─733a54b0-53a2-11ec-1893-1fe762d73499
# ╟─733a5578-53a2-11ec-1f5e-ff4a7320c9f7
# ╠═733a7062-53a2-11ec-3132-cb7c27919490
# ╟─733a7094-53a2-11ec-0638-a7f69ad643da
# ╟─733a717a-53a2-11ec-0d70-95c55c9836e1
# ╟─733a71d4-53a2-11ec-3aee-a53802bf9250
# ╟─733a72ba-53a2-11ec-2c7b-b1204aaa5c48
# ╟─733a7320-53a2-11ec-231b-b949c5598cb0
# ╠═733a78e6-53a2-11ec-16d7-59fe194acdba
# ╟─733a7990-53a2-11ec-0740-0759d27da1a6
# ╟─733a7d00-53a2-11ec-06b5-b7af9837b53e
# ╟─733a7d96-53a2-11ec-1373-371f7b56cf65
# ╟─733a7daa-53a2-11ec-2794-fbe25425af07
# ╟─733a7db4-53a2-11ec-0aaa-1983d2c005c3
# ╠═733a841c-53a2-11ec-0ef9-a9199b7e040d
# ╟─733a84ee-53a2-11ec-13d3-8f48d34833aa
# ╟─733a8596-53a2-11ec-1619-f17624daa4d9
# ╟─733a85b6-53a2-11ec-0e4f-bd5c429efd2c
# ╟─733a867e-53a2-11ec-25c6-258a9a2a5d48
# ╟─733a8688-53a2-11ec-10da-b573f2f7ae77
# ╟─733a86a6-53a2-11ec-3606-8d120f7fa07c
# ╟─733a86f6-53a2-11ec-3fb5-173a5ce9caa1
# ╟─733a870a-53a2-11ec-1371-b5bf52bdbc37
# ╟─733a871e-53a2-11ec-0b67-297cd29cd056
# ╟─733a87be-53a2-11ec-03ed-199a12ab4e99
# ╟─733a885e-53a2-11ec-2b34-632a2802edc4
# ╟─733a88fe-53a2-11ec-37f4-a1866553e56f
# ╟─733a8926-53a2-11ec-04fa-b738a81f86ed
# ╟─733a8994-53a2-11ec-2b8b-259f4330e7b2
# ╟─733a8a0c-53a2-11ec-0214-552d3ff22a2d
# ╟─733a8b4c-53a2-11ec-1eac-158ccf4f1ee0
# ╟─733a8c46-53a2-11ec-0c3d-290fd080362b
# ╟─733a8c9e-53a2-11ec-067f-0f7705eb3a27
# ╟─733a8cbe-53a2-11ec-335f-118ebbca77e9
# ╟─733a8cfa-53a2-11ec-3b9e-af82492c0a55
# ╟─733a8d0e-53a2-11ec-063d-2d4edbffae80
# ╟─733a8d90-53a2-11ec-3f09-17a0139987d2
# ╠═733a9418-53a2-11ec-2ee4-23dd6fed8876
# ╟─733a9434-53a2-11ec-25e0-0b7704922ebd
# ╟─733a945c-53a2-11ec-3b74-49d66f28469e
# ╠═733a9a24-53a2-11ec-3877-fb7860bd3e3f
# ╠═733a9e34-53a2-11ec-3c59-67546a99e5e1
# ╠═733aa1cc-53a2-11ec-2bc5-3f39866d6c4c
# ╠═733aa8a2-53a2-11ec-07b7-27d81c5454ea
# ╟─733aa8fe-53a2-11ec-3697-33d6731d1903
# ╟─733aa97e-53a2-11ec-3d52-5151550627b2
# ╟─733aceea-53a2-11ec-38f1-157d866d6303
# ╟─733acf9e-53a2-11ec-0a0e-63abf55766ce
# ╠═733b1e5e-53a2-11ec-0a0a-43bf1eeacf85
# ╟─733b1ece-53a2-11ec-1c46-e9fada3cd04a
# ╠═733b23ea-53a2-11ec-1488-bfea5318a16a
# ╟─733b28e0-53a2-11ec-1024-c56f8b903184
# ╟─733b293a-53a2-11ec-125b-ab97fd11d3df
# ╠═733b7a84-53a2-11ec-35b4-e9000e74fd4c
# ╟─733b7c00-53a2-11ec-3ee1-a581534ea077
# ╠═733b9e10-53a2-11ec-0589-af1fbcf8daae
# ╟─733b9ece-53a2-11ec-040c-fff6c94c9a75
# ╠═733bc2dc-53a2-11ec-2cc8-4b65e632854a
# ╟─733bc3fe-53a2-11ec-3bb3-d9b6505cb0df
# ╟─733bc494-53a2-11ec-0574-cb9887c1adc9
# ╠═733bcf14-53a2-11ec-13c6-019f73dc279f
# ╟─733bcf98-53a2-11ec-3e08-5f704f37c609
# ╟─733bd018-53a2-11ec-34ba-45f20adab02c
# ╟─733bd0ee-53a2-11ec-245a-a986ae61c7db
# ╟─733bd272-53a2-11ec-1ff2-518942f22c34
# ╟─733bd38a-53a2-11ec-0912-d52ed8c8026c
# ╟─733bd41e-53a2-11ec-0093-eb06ffd396df
# ╟─733bd45c-53a2-11ec-10b4-5df2dc1798e2
# ╟─733bd4ca-53a2-11ec-286e-4f850c0f8b1d
# ╟─733bd4de-53a2-11ec-110e-95a72203499d
# ╟─733bd4fc-53a2-11ec-32f5-01be8a3a947f
# ╟─733bd56a-53a2-11ec-0111-af9b3d28f90c
# ╟─733bd628-53a2-11ec-02d0-cf312a9d26f0
# ╟─733bd6dc-53a2-11ec-3b70-a5efb3b08ded
# ╟─733bd830-53a2-11ec-20b4-7d78d1c0e0d2
# ╟─733bd84e-53a2-11ec-18e6-0b1e0a1b301f
# ╠═733be0b4-53a2-11ec-1819-11d371427ee4
# ╟─733be0e6-53a2-11ec-2fde-69997f2e6e87
# ╠═733c268a-53a2-11ec-17de-814397b66a35
# ╟─733c2830-53a2-11ec-154c-ddc74b332142
# ╠═733c2d8a-53a2-11ec-39df-9b0732b94ce7
# ╟─733c2e52-53a2-11ec-0b1f-9f1629c51008
# ╟─733c2ec0-53a2-11ec-0238-d5d439c103a2
# ╟─733c2f06-53a2-11ec-06b7-e785b10ae989
# ╠═733c3622-53a2-11ec-1eff-1f201d027cde
# ╟─733c36f4-53a2-11ec-09c6-a77f0520682a
# ╟─733c4054-53a2-11ec-11d8-87d5249063f2
# ╟─733c40c2-53a2-11ec-23c8-b13babedc50b
# ╟─733c4150-53a2-11ec-3e0a-3571784edb0a
# ╠═733c51ac-53a2-11ec-0d17-2b9a857c3550
# ╟─733c51f2-53a2-11ec-0dc8-d3673757fa2e
# ╟─733c5274-53a2-11ec-29c6-1f904abfa2f3
# ╟─733c53aa-53a2-11ec-096d-b74e41a66a4d
# ╟─733c544a-53a2-11ec-2da7-cd26636c2a26
# ╟─733c6bba-53a2-11ec-2b55-5b11908eedb5
# ╟─733c6cdc-53a2-11ec-1439-f3ad1cbf4e75
# ╟─733c6d18-53a2-11ec-2f63-0192b71dbe9c
# ╠═733c731c-53a2-11ec-00bb-b56743ea038b
# ╟─733c8be2-53a2-11ec-347a-3500dc8d0eb4
# ╠═733c9234-53a2-11ec-3aa7-0dda4404da9d
# ╟─733c927a-53a2-11ec-2000-7b0005618222
# ╟─733c92d4-53a2-11ec-0793-a19cfffb63df
# ╟─733c93f6-53a2-11ec-3023-8dfbecb6b78c
# ╠═733c9946-53a2-11ec-2df7-73bd5f9262c7
# ╟─733c996e-53a2-11ec-397c-af9c5ee3cc58
# ╠═733cc100-53a2-11ec-061e-f95366b14a5f
# ╟─733cc178-53a2-11ec-225d-9d3ee920c3ca
# ╠═733cc8a8-53a2-11ec-1c1b-4719848f5814
# ╟─733cc936-53a2-11ec-1754-432e1c27df5a
# ╟─733cc9b6-53a2-11ec-11ff-fb579a054371
# ╠═733cd09e-53a2-11ec-2601-8b24f2dfd544
# ╟─733cd118-53a2-11ec-0a6d-97af6baf7e0f
# ╠═733cf422-53a2-11ec-277c-0b67c0334767
# ╟─733cf490-53a2-11ec-0e68-b1a31ba32348
# ╟─733cf4f4-53a2-11ec-2f3a-416bc67f055c
# ╟─733cf576-53a2-11ec-052d-07564d9876a4
# ╟─733cf5ee-53a2-11ec-1523-991574cbaa9a
# ╟─733cf648-53a2-11ec-0ddf-e57a84439370
# ╟─733cf65c-53a2-11ec-2103-b12b692eff6d
# ╟─733cf6a4-53a2-11ec-165b-bfe438639d63
# ╟─733cf742-53a2-11ec-1754-b18800a7899e
# ╟─733cf7ce-53a2-11ec-331c-a7caa4f3e438
# ╟─733cf904-53a2-11ec-1384-956b3694c250
# ╟─733cf942-53a2-11ec-0959-b70de2ecb773
# ╟─733cf974-53a2-11ec-0e59-c30fbbe96f11
# ╠═733d249c-53a2-11ec-006c-53c4e5893f14
# ╟─733d2532-53a2-11ec-3dc6-33704cdacdc6
# ╟─733d2564-53a2-11ec-2c14-b77bbb223253
# ╠═733d2a78-53a2-11ec-37e5-7bc5d188fee1
# ╟─733d2ac8-53a2-11ec-3dd1-3fc58656a290
# ╟─733d2b40-53a2-11ec-1360-47407e9f9c6c
# ╟─733d2cda-53a2-11ec-1092-ef0b22f78a93
# ╟─733d2d5c-53a2-11ec-39aa-19bcd6685fb0
# ╟─733d406e-53a2-11ec-0f5b-e961d7b7aee8
# ╟─733d42cc-53a2-11ec-3ff3-69601d32b987
# ╟─733d43f0-53a2-11ec-20a7-a9237d15a4a1
# ╟─733d4be0-53a2-11ec-3572-ab1149e35600
# ╟─733d4c06-53a2-11ec-20f6-e31c64ef9cb6
# ╟─733d4c92-53a2-11ec-1d78-c5f1032e881d
# ╟─733d80f6-53a2-11ec-3127-037a4c1b26a2
# ╟─733d8180-53a2-11ec-1777-ad48c6d5298a
# ╟─733d8266-53a2-11ec-0a19-affa94f58cb5
# ╟─733d8978-53a2-11ec-3c2b-3bcbcd846689
# ╟─733d89a0-53a2-11ec-0395-319a06225099
# ╟─733d8aae-53a2-11ec-0546-6d4d61548b52
# ╟─733d8ab8-53a2-11ec-2538-8df3f8d01ce3
# ╟─733d90c6-53a2-11ec-27ab-b12d7f4bb6fa
# ╟─733d912a-53a2-11ec-1d4e-5f85921896b9
# ╟─733da820-53a2-11ec-36fa-abeaacf34f7b
# ╟─733da868-53a2-11ec-0fb4-214b656d30f1
# ╟─733da8f6-53a2-11ec-2dd4-1f5bad414f3a
# ╟─733dc7e2-53a2-11ec-1a8c-6134f3fead89
# ╟─733dc854-53a2-11ec-3841-01e03828f5a8
# ╟─733dc918-53a2-11ec-0e81-09eb7a231989
# ╟─733dc938-53a2-11ec-21e5-773f7a2c2c9b
# ╟─733dca32-53a2-11ec-2f73-cb61da15b210
# ╟─733dce1a-53a2-11ec-3490-57ced91f9b90
# ╟─733dcece-53a2-11ec-194b-0f2c3da381fb
# ╟─733dd664-53a2-11ec-084b-013dd3320877
# ╟─733dd6e4-53a2-11ec-06fe-4bed1fb739cd
# ╟─733ddd7e-53a2-11ec-38ca-290e518c8c77
# ╟─733dde96-53a2-11ec-3583-5317cf1d9fac
# ╟─733de4ae-53a2-11ec-36dd-2da33470c394
# ╟─733de578-53a2-11ec-363d-bddadb07a4ab
# ╟─733deaf8-53a2-11ec-114a-9ff146ba3d9b
# ╟─733deb66-53a2-11ec-0cee-7b9faf6af5de
# ╟─733dec1c-53a2-11ec-0abb-8dfe4f10714d
# ╟─733dec60-53a2-11ec-39b6-05be7588df27
# ╟─733e0d46-53a2-11ec-1ae2-1bf714e5f461
# ╟─733e0d94-53a2-11ec-2ff4-45c5c8ec7eee
# ╟─733e30bc-53a2-11ec-2081-5705e2af30dd
# ╟─733e3256-53a2-11ec-2837-3345b9f96002
# ╟─733e32ba-53a2-11ec-2fa2-a7c71de582f8
# ╠═733e3968-53a2-11ec-1e84-29853bfb279d
# ╟─733e3a08-53a2-11ec-07d7-a7d3753bea9b
# ╟─733e3a1e-53a2-11ec-0c11-d7669b751f25
# ╟─733e3c7c-53a2-11ec-0170-154debbad1c2
# ╟─733e3d5a-53a2-11ec-115a-bb0724dd355b
# ╟─733e3e04-53a2-11ec-3678-71d6992c6f2a
# ╟─733e3f1a-53a2-11ec-2839-a303880581e0
# ╟─733e3f76-53a2-11ec-12d0-87ae5f0e27d8
# ╟─733e3fa8-53a2-11ec-3f3c-e910f9edc4ac
# ╟─733e3fb2-53a2-11ec-2dd6-05f0720d3d2b
# ╟─733e4016-53a2-11ec-1a29-af22c2ae94ec
# ╟─733e4048-53a2-11ec-26e8-2366f672e02c
# ╟─733e4070-53a2-11ec-3245-71c2390ca71e
# ╟─733e4126-53a2-11ec-0c67-8bc8a55a4807
# ╟─733e4688-53a2-11ec-2804-4733ab15c28e
# ╟─733e47be-53a2-11ec-265f-af5f36f49c75
# ╟─733e4926-53a2-11ec-3d0b-77c5c4fd2193
# ╟─733e4932-53a2-11ec-1009-499cb17555d9
# ╟─733e4932-53a2-11ec-1efb-b1cf95f628ff
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
