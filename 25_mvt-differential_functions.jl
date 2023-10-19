### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ b8e1ee4a-575a-11ec-1f1e-630a42ad10f4
begin
	using CalculusWithJulia
	using Plots
	using Roots
end

# ╔═╡ b8e1f372-575a-11ec-307f-c317a138de1e
begin
	using CalculusWithJulia.WeaveSupport
	using Printf
	using SymPy
	
	import PyPlot
	pyplot()
	fig_size = (600, 400)
	
	# keep until CwJ bumps version
	function _ImageFile(f, caption, alt="A figure", width=nothing)
	    data = CalculusWithJulia.WeaveSupport.base64encode(read(f, String))
	    content = CalculusWithJulia.WeaveSupport.Mustache.render(CalculusWithJulia.WeaveSupport.gif_to_img_tpl, data=data, alt=alt)
	    caption = CalculusWithJulia.WeaveSupport.Markdown.parse(caption)
	    CalculusWithJulia.WeaveSupport.ImageFile(f, caption, alt, width, content)
	end
	
	# using Downloads
	# function JSXGraph(fname, caption)
	#     url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/"
	#     content = read(Downloads.download(joinpath(url, fname)), String)
	#     CalculusWithJulia.WeaveSupport.JSXGRAPH(content, caption,
	#                                             "jsxgraph", "jsxgraph",
	#                                             500, 300)
	# end
	nothing
end

# ╔═╡ b90d5968-575a-11ec-299e-136596396529
using PlutoUI

# ╔═╡ b90d5954-575a-11ec-2365-d7a927232494
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ b8c8b358-575a-11ec-36ea-4191abf1e30e
md"""# The mean value theorem and other facts about differentiable functions.
"""

# ╔═╡ b8cad534-575a-11ec-353f-d957ac210712
md"""This section uses these add-on packages:
"""

# ╔═╡ b8e3ddfe-575a-11ec-29e6-53e319df9d8a
md"""---
"""

# ╔═╡ b8e873b6-575a-11ec-2b2c-b7564e8b4dfa
md"""A function is *continuous* at $c$ if $f(c+h) - f(c) \rightarrow 0$ as $h$ goes to $0$. We can right that as $f(c+h) - f(x) = \epsilon_h$, with $\epsilon_h$ denoting a function going to $0$ as $h \rightarrow 0$. With this notion, differentiability could be written as $f(c+h) - f(c) - f'(c)h = \epsilon_h \cdot h$.  This is clearly a more demanding requirement that mere continuity at $c$.
"""

# ╔═╡ b8e8745e-575a-11ec-2f0c-6728c9aa0c91
md"""We defined a function to be *continuous* on an interval $I=(a,b)$ if it was continuous at each point $c$ in $I$. Similarly, we define a function to be *differentiable* on the interval $I$ it it is differentiable at each point $c$ in $I$.
"""

# ╔═╡ b8e87468-575a-11ec-0dc7-1dff7a6fc64c
md"""This section looks at properties of differentiable functions. As there is a more stringent definitions, perhaps more properties are a consequence of the definition.
"""

# ╔═╡ b8eb229e-575a-11ec-2dfe-054766a129f3
md"""## Differentiable is more restrictive than continuous.
"""

# ╔═╡ b8ec3882-575a-11ec-128d-b1cafa9c2e3e
md"""Let $f$ be a differentiable function on $I=(a,b)$. We see that $f(c+h) - f(c) = f'(c)h + \epsilon_h\cdot h = h(f'(c) + \epsilon_h)$. The right hand side will clearly go to $0$ as $h\rightarrow 0$, so $f$ will be continuous. In short:
"""

# ╔═╡ b8f305ae-575a-11ec-1721-0d620044df9f
md"""> A differentiable function on $I=(a,b)$ is continuous on $I$.

"""

# ╔═╡ b8f305f4-575a-11ec-1f98-7b5928011250
md"""Is it possible that all continuous functions are differentiable?
"""

# ╔═╡ b8f3061c-575a-11ec-2f8a-cd5af3d37e78
md"""The fact that the derivative is related to the tangent line's slope might give an indication that this won't be the case - we just need a function which is continuous but has a point with no tangent line. The usual suspect is $f(x) = \lvert x\rvert$ at $0$.
"""

# ╔═╡ b8f30cac-575a-11ec-19c8-a5d784700d95
let
	f(x) = abs(x)
	plot(f, -1,1)
end

# ╔═╡ b8f30cea-575a-11ec-33cc-b7abb13d0f7c
md"""We can see formally that the secant line expression will not have a limit when $c=0$ (the left limit is $-1$, the right limit $1$). But more insight is gained by looking a the shape of the graph.  At the origin, the graph always is vee-shaped. There is no linear function that approximates this function well. The function is just not smooth enough, as it has a kink.
"""

# ╔═╡ b8f30cfc-575a-11ec-311f-bbffe80b6464
md"""There are other functions that have kinks. These are often associated with powers. For example, at $x=0$ this function will not have a derivative:
"""

# ╔═╡ b8f31490-575a-11ec-2a4d-ffa646d031df
let
	f(x) = (x^2)^(1/3)
	plot(f, -1, 1)
end

# ╔═╡ b8f314b8-575a-11ec-0d57-01c93ae3b5ba
md"""Other functions have tangent lines that become vertical. The natural slope would be $\infty$, but this isn't a limiting answer (except in the extended sense we don't apply to the definition of derivatives). A candidate for this case is the cube root function:
"""

# ╔═╡ b8f3171a-575a-11ec-0764-69c3b1802c4e
plot(cbrt, -1, 1)

# ╔═╡ b8f3174c-575a-11ec-1eb6-518445daf658
md"""The derivative at $0$ would need to be $+\infty$ to match the graph. This is implied by the formula for the derivative from the power rule: $f'(x) = 1/3 \cdot x^{-2/3}$, which has a vertical asymptote at $x=0$.
"""

# ╔═╡ b8f32a48-575a-11ec-062a-81925275d289
note("""

The `cbrt` function is used above, instead of `f(x) = x^(1/3)`, as the
latter is not defined for negative `x`. Though it can be for the exact
power `1/3`, it can't be for an exact power like `1/2`. This means the
value of the argument is important in determining the type of the
output - and not just the type of the argument. Having type-stable
functions is part of the magic to making `Julia` run fast, so `x^c` is
not defined for negative `x` and most floating point exponents.

""")

# ╔═╡ b8f51100-575a-11ec-240a-b7ed94ef0424
md"""Lest you think that continuous functions always have derivatives except perhaps at exceptional points, this isn't the case. The functions used to [model](http://tinyurl.com/cpdpheb) the stock market are continuous but have no points where they are differentiable.
"""

# ╔═╡ b8f51182-575a-11ec-14b8-31843f3e35ec
md"""## Derivatives and maxima.
"""

# ╔═╡ b8f511e6-575a-11ec-3172-c50e9397e72b
md"""We have defined an *absolute maximum* of $f(x)$ over an interval to be a value $f(c)$ for a point $c$ in the interval that is as large as any other value in the interval. Just specifying a function and an interval does not guarantee an absolute maximum, but specifying a *continuous* function and a *closed* interval does, by the extreme value theorem.
"""

# ╔═╡ b8f5122e-575a-11ec-01ee-b799f263213b
md"""We say $f(x)$ has a *relative maximum* at $c$ if there exists some interval $I=(a,b)$ with $a < c < b$ for which $f(c)$ is an absolute maximum for $f$ and $I$.
"""

# ╔═╡ b8f51240-575a-11ec-0bd2-19a4dc2fa3ff
md"""The difference is a bit subtle, for an absolute maximum the interval must also  be specified, for a relative maximum there just needs to exist some interval, possibly really small, but must be bigger than a point.
"""

# ╔═╡ b8f51baa-575a-11ec-39a3-519a094b30db
note("""

A hiker can appreciate the difference. A relative maximum would be the
crest of any hill, but an absolute maximum would be the summit.

""")

# ╔═╡ b8f51bd4-575a-11ec-0234-f37706912e79
md"""What does this have to do with derivatives?
"""

# ╔═╡ b8f6458c-575a-11ec-0b4c-c70095501584
md"""[Fermat](http://science.larouchepac.com/fermat/fermat-maxmin.pdf), perhaps with insight from Kepler, was interested in maxima of polynomial functions. As a warm up, he considered a line segment $AC$ and a point $E$ with the task of choosing $E$ so that $(E-A) \times (C-A)$ being a maximum. We might recognize this as finding the maximum of $f(x) = (x-A)\cdot(C-x)$ for some $A < C$. Geometrically, we know this to be at the midpoint, as the equation is a parabola, but Fermat was interested in an algebraic solution that led to more generality.
"""

# ╔═╡ b8f64610-575a-11ec-0f55-0d7026c7769f
md"""He takes $b=AC$ and  $a=AE$. Then the product is $a \cdot (b-a) = ab - a^2$. He then perturbs this writing $AE=a+e$, then this new product is $(a+e) \cdot (b - a - e)$. Equating the two, and canceling like terms gives $be = 2ae + e^2$. He cancels the $e$ and basically comments that this must be true for all $e$ even as $e$ goes to $0$, so $b = 2a$ and the value is at the midpoint.
"""

# ╔═╡ b8f7f21c-575a-11ec-058e-0b8f73eb5177
md"""In a more modern approach, this would be the same as looking at this expression:
"""

# ╔═╡ b8fa1ac4-575a-11ec-22d6-c5d4237c454d
md"""```math
\frac{f(x+e) - f(x)}{e} = 0.
```
"""

# ╔═╡ b8fa1bd0-575a-11ec-16aa-9f8a34918795
md"""Working on the left hand side, for non-zero $e$ we can cancel the common $e$ terms, and then let $e$ become $0$.  This becomes a problem in solving $f'(x)=0$. Fermat could compute the derivative for any polynomial by taking a limit, a task we would do now by the power rule and the sum and difference of function rules.
"""

# ╔═╡ b8fa1be6-575a-11ec-0fe1-75ce88fedc51
md"""This insight holds for other types of functions:
"""

# ╔═╡ b8fa1d38-575a-11ec-3856-135cfbc8305d
md"""> If $f(c)$ is a relative maximum then either $f'(c) = 0$ or the  derivative at $c$ does not exist.

"""

# ╔═╡ b8fa1d4e-575a-11ec-19b1-4b62eb7c2fa1
md"""When the derivative exists, this says the tangent line is flat. (If it had a slope, then the the function would increase by moving left or right, as appropriate, a point we pursue later.)
"""

# ╔═╡ b8fa9a58-575a-11ec-2456-fd73fcb9852f
md"""For a continuous function $f(x)$, call a point $c$ in the domain of $f$ where either $f'(c)=0$ or the derivative does not exist a **critical** **point**.
"""

# ╔═╡ b8fa9abc-575a-11ec-3739-559d462e49d3
md"""We can combine Bolzano's extreme value theorem with Fermat's insight to get the following:
"""

# ╔═╡ b8fa9bca-575a-11ec-380e-83269db4d1d1
md"""> A continuous function on $[a,b]$ has an absolute maximum that occurs at a critical point $c$, $a < c < b$, or an endpoint, $a$ or $b$.

"""

# ╔═╡ b8fa9bd4-575a-11ec-1f51-81907526f139
md"""A similar statement holds for an absolute minimum.  This gives a restricted set of places to look for absolute maximum and minimum values - all the critical points and the endpoints.
"""

# ╔═╡ b8fa9bfc-575a-11ec-2119-219edf2176d0
md"""It is also the case that all relative extrema occur at a critical point, *however* not all critical points correspond to relative extrema. We will see *derivative tests* that help characterize when that occurs.
"""

# ╔═╡ b8faa356-575a-11ec-358d-95d855cc73d3
let
	### {{{lhopital_32}}}
	imgfile = "figures/lhopital-32.png"
	caption =  L"""
	Image number 32 from L'Hopitals calculus book (the first) showing that
	at a relative minimum, the tangent line is parallel to the
	$x$-axis. This of course is true when the tangent line is well defined
	by Fermat's observation.
	"""
	#ImageFile(imgfile, caption)
	nothing
end

# ╔═╡ b8fb89e0-575a-11ec-0f06-d94f46be0efa
md"""![Image number 32 from L'Hopitals calculus book (the first) showing that at a relative minimum, the tangent line is parallel to the $x$-axis. This of course is true when the tangent line is well defined by Fermat's observation.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/lhopital-32.png)
"""

# ╔═╡ b8fe24e8-575a-11ec-3887-d1f8e1558337
md"""### Numeric derivatives
"""

# ╔═╡ b9063048-575a-11ec-0ca0-999e84fa7d80
md"""The `ForwardDiff` package provides a means to numerically compute derivatives without approximations at a point. In `CalculusWithJulia` this is extended to find derivatives of functions and the `'` notation is overloaded for function objects. Hence these two give nearly identical answers, the difference being only the type of number used:
"""

# ╔═╡ b90638a6-575a-11ec-28ce-d392763ec0d0
let
	f(x) = 3x^3 - 2x
	fp(x) = 9x^2 - 2
	f'(3), fp(3)
end

# ╔═╡ b908b908-575a-11ec-1e50-b5435c466b96
md"""##### Example
"""

# ╔═╡ b908b988-575a-11ec-2d20-dba9b9badc70
md"""For the function $f(x) = x^2 \cdot e^{-x}$ find the absolute maximum over the interval $[0, 5]$.
"""

# ╔═╡ b908b9a8-575a-11ec-1949-67bcedea56d4
md"""We have that $f(x)$ is continuous on the closed interval of the question, and in fact differentiable on $(0,5)$, so any critical point will be a zero of the derivative. We can check for these with:
"""

# ╔═╡ b908c1f0-575a-11ec-371a-0d97dfadaa9c
begin
	f(x) = x^2 * exp(-x)
	cps = find_zeros(f', -1, 6)     # find_zeros in `Roots`
end

# ╔═╡ b908c236-575a-11ec-1d4f-9dd67a741b51
md"""We get $0$ and $2$ are critical points. The endpoints are $0$ and $5$. So the absolute maximum over this interval is either at $0$, $2$ or $5$:
"""

# ╔═╡ b908c57e-575a-11ec-10d9-01a63b598026
f(0), f(2), f(5)

# ╔═╡ b908c59a-575a-11ec-1c2f-9bea1ef1f90f
md"""We see that $f(2)$ is then the maximum.
"""

# ╔═╡ b908c5d8-575a-11ec-2277-dd3e21df3b02
md"""A few things. First, `find_zeros` can miss some roots, in particular endpoints and roots that just touch $0$. We should graph to verify it didn't. Second, it can be easier sometimes to check the values using the "dot" notation. If `f`, `a`,`b` are the function and the interval, then this would typically follow this pattern:
"""

# ╔═╡ b908cae2-575a-11ec-3556-090ebbaaea22
begin
	a, b = 0, 5
	critical_pts = find_zeros(f', a, b)
	f.(critical_pts), f(a), f(b)
end

# ╔═╡ b908cb00-575a-11ec-0c23-8fb81d05e26a
md"""For this problem, we have the left endpoint repeated, but in general this won't be a point where the derivative is zero.
"""

# ╔═╡ b908cb0c-575a-11ec-3b5e-2d193b21e9a9
md"""As an aside, the output above is not a single container. To achieve that, the values can be combined before the broadcasting:
"""

# ╔═╡ b908cd30-575a-11ec-0728-83a053aef0f0
f.(vcat(a, critical_pts, b))

# ╔═╡ b908cd58-575a-11ec-0a8c-11e7c86d3574
md"""##### Example
"""

# ╔═╡ b908cd80-575a-11ec-27d8-d178cb928ebb
md"""For the function $g(x) = e^x\cdot(x^3 - x)$ find the  absolute maximum over the interval $[0, 2]$.
"""

# ╔═╡ b908cd9e-575a-11ec-3d35-f59a610e575a
md"""We follow the same pattern. Since $f(x)$ is continuous on the closed interval and differentiable on the open interval we know that the absolute maximum must occur at an endpoint ($0$ or $2$) or a critical point where $f'(c)=0$. To solve for these, we have again:
"""

# ╔═╡ b908d2a8-575a-11ec-0964-bd7edeb5bcda
begin
	g(x) = exp(x) * (x^3 - x)
	gcps = find_zeros(g', 0, 2)
end

# ╔═╡ b908d2c6-575a-11ec-1b29-09686af89ae5
md"""And checking values gives:
"""

# ╔═╡ b908d53c-575a-11ec-013d-15c1fe1dd547
g.(vcat(0, gcps, 2))

# ╔═╡ b908d564-575a-11ec-0a72-8deae58c6afe
md"""Here the maximum occurs at an endpoint. The critical point $c=0.67\dots$ does not produce a maximum value. Rather $f(0.67\dots)$ is an absolute minimum.
"""

# ╔═╡ b908e34c-575a-11ec-12c4-a5de61af743d
note(L"""

**Absolute minimum** We haven't discussed the parallel problem of
  absolute minima over a closed interval. By considering the function
  $h(x) = - f(x)$, we see that the any thing true for an absolute
  maximum should hold in a related manner for an absolute minimum, in
  particular an absolute minimum on a closed interval will only occur
  at a critical point or an end point.

""")

# ╔═╡ b908e388-575a-11ec-3930-ad58a7108a3f
md"""## Rolle's theorem
"""

# ╔═╡ b908e3ba-575a-11ec-1f03-23e5d749eaf8
md"""Let $f(x)$ be differentiable on $(a,b)$ and continuous on $[a,b]$. Then the absolute maximum occurs at an endpoint or where the derivative is $0$ (as the derivative is always defined). This gives rise to:
"""

# ╔═╡ b90a1d9a-575a-11ec-2863-7d9d5e102880
md"""> *[Rolle's](http://en.wikipedia.org/wiki/Rolle%27s_theorem) theorem*: For $f$ differentiable on $(a,b)$ and continuous on $[a,b]$, if $f(a)=f(b)$, then there exists some $c$ in $(a,b)$ with $f'(c) = 0$.

"""

# ╔═╡ b90a1dfa-575a-11ec-0ae2-bf5b4910fe3c
md"""This modest observation opens the door to many relationships between a function and its derivative, as it ties the two together in one statement.
"""

# ╔═╡ b90a1e38-575a-11ec-3b4e-f10f5b1fb2a7
md"""To see why Rolle's theorem is true, we assume that $f(a)=0$, otherwise consider $g(x)=f(x)-f(a)$. By the extreme value theorem, there must be an absolute maximum and minimum. If $f(x)$ is ever positive, then the absolute maximum occurs in $(a,b)$ - not at an endpoint - so at a critical point where the derivative is $0$. Similarly if $f(x)$ is ever negative. Finally, if $f(x)$ is just $0$, then take any $c$ in $(a,b)$.
"""

# ╔═╡ b90a1e74-575a-11ec-37d1-336cfdcfbb7d
md"""The statement in Rolle's theorem speaks to existence. It doesn't give a recipe to find $c$. It just guarantees that there is *one* or *more* values in the interval $(a,b)$ where the derivative is $0$ if we assume differentiability on $(a,b)$ and continuity on $[a,b]$.
"""

# ╔═╡ b90a1e9c-575a-11ec-1550-c9f5f080567b
md"""##### Example
"""

# ╔═╡ b90a1ed0-575a-11ec-34d0-f1810fd78ebe
md"""Let $j(x) = e^x \cdot x \cdot (x-1)$. We know $j(0)=0$ and $j(1)=0$, so on $[0,1]$. Rolle's theorem guarantees that we can find *at* *least* one answer (unless numeric issues arise):
"""

# ╔═╡ b90a270e-575a-11ec-04a6-6b8ced9059f1
begin
	j(x) = exp(x) * x * (x-1)
	find_zeros(j', 0, 1)
end

# ╔═╡ b90a2748-575a-11ec-08b9-5bd89daa753b
md"""This graph illustrates the lone value for $c$ for this problem
"""

# ╔═╡ b90a2c5c-575a-11ec-349a-5b2c10606d8d
begin
	x0 = find_zero(j', (0, 1))
	plot([j, x->j(x0) + 0*(x-x0)], 0, 1)
end

# ╔═╡ b90a2c7c-575a-11ec-2582-d3eca3ae1fdb
md"""## The mean value theorem
"""

# ╔═╡ b90a2ca2-575a-11ec-36c7-f1b98415195d
md"""We are driving south and in one hour cover 70 miles. If the speed limit is 65 miles per hour, were we ever speeding? We'll we averaged more than the speed limit so we know the answer is yes, but why? Speeding would mean our instantaneous speed was more than the speed limit, yet we only know for sure our *average* speed was more than the speed limit. The mean value tells us that if some conditions are met, then at some point (possibly more than one) we must have that our instantaneous speed is equal to our average speed.
"""

# ╔═╡ b90a2cb6-575a-11ec-3252-eb25ea4e50f4
md"""The mean value theorem is a direct generalization of Rolle's theorem.
"""

# ╔═╡ b90a2d72-575a-11ec-1233-ffaa92ce7e21
md"""> *Mean value theorem*: Let $f(x)$ be differentiable on $(a,b)$ and continuous on $[a,b]$. Then there exists a value $c$ in $(a,b)$ where $f'(c) = (f(b) - f(a)) / (b - a)$.

"""

# ╔═╡ b90a2d92-575a-11ec-12a4-a782d2c1a9a8
md"""This says for any secant line between $a < b$ there will be a parallel tangent line at some $c$ with $a < c < b$ (all provided $f$ is differentiable on $(a,b)$ and continuous on $[a,b]$).
"""

# ╔═╡ b90a2da6-575a-11ec-286a-2133619e49c5
md"""This graph illustrates the theorem. The orange line is the secant line. A parallel line tangent to the graph is guaranteed by the mean value theorem. In this figure, there are two such lines, rendered using red.
"""

# ╔═╡ b90a31ca-575a-11ec-14fe-9db6d33123ae
let
	f(x) = x^3 - x
	a, b = -2, 1.75
	m = (f(b) - f(a)) / (b-a)
	cps = find_zeros(x -> f'(x) - m, a, b)
	
	p = plot(f, a-1, b+1,         linewidth=3, legend=false)
	plot!(x -> f(a) + m*(x-a),  a-1, b+1,   linewidth=3, color=:orange)
	scatter!([a,b], [f(a), f(b)])
	
	for cp in cps
	  plot!(x -> f(cp) + f'(cp)*(x-cp), a-1, b+1, color=:red)
	end
	p
end

# ╔═╡ b90a31de-575a-11ec-1ae5-65a477cea3a0
md"""Like Rolle's theorem this is a guarantee that something exists, not a recipe to find it. In fact, the mean value theorem is just Rolle's theorem applied to:
"""

# ╔═╡ b90a3206-575a-11ec-1cc8-23758a61d4e1
md"""```math
g(x) = f(x) - (f(a) + (f(b) - f(a)) / (b-a) \cdot (x-a))
```
"""

# ╔═╡ b90a321c-575a-11ec-2a5f-29449b0fc99e
md"""That is the function $f(x)$, minus the secant line between $(a,f(a))$ and $(b, f(b))$.
"""

# ╔═╡ b90a4536-575a-11ec-08af-c7cce532a4bf
let
	# Need to bring jsxgraph into PLUTO
	caption = """
	Illustration of the mean value theorem from https://jsxgraph.uni-bayreuth.de/.
	The polynomial function interpolates  the points ``A``,``B``,``C``, and ``D``. Adjusting these creates different functions. Regardless of the function -- which as a polynomial will always be continuous and differentiable -- the slope of the secant line between ``A`` and ``B`` is always matched by some tangent line betweent the points ``A`` and ``B``.
	"""
	#CalculusWithJulia.WeaveSupport.JSXGraph(joinpath(@__DIR__, "mean-value.js"), caption)
	
	url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/mean-value.js"
	JSXGraph(url, caption)
end

# ╔═╡ b90a455c-575a-11ec-3292-df1c9de4d209
md"""##### Example
"""

# ╔═╡ b90a457a-575a-11ec-2f70-3db44612629a
md"""The mean value theorem is an extremely useful tool to relate properties of a function with properties of its derivative, as, like Rolle's theorem, it includes both $f$ and $f'$ in its statement.
"""

# ╔═╡ b90a45a2-575a-11ec-08e1-8987e7e39271
md"""For example, suppose we have a function $f(x)$ and we know that the derivative is **always** $0$. What can we say about the function?
"""

# ╔═╡ b90a45c0-575a-11ec-3fb2-d92efec80755
md"""Well, constant functions have derivatives that are constantly $0$. But do others? We will see the answer is no: If a function has a zero derivative in $(a,b)$ it must be a constant. We can readily see that if $f$ is a polynomial function this is the case, as we can differentiate a polynomial function and this will be zero only if **all** its coefficients are $0$, which would mean there is no non-constant leading term in the polynomial. But polynomials are not representative of all functions, and so a proof requires a bit more effort.
"""

# ╔═╡ b90a45fa-575a-11ec-2f87-21f499c47865
md"""Suppose it is known that $f'(x)=0$ on some interval $I$ and we take any $a < b$ in $I$. Since $f'(x)$ always exists, $f(x)$ is always differentiable, and hence always continuous. So on $[a,b]$ the conditions of the mean value theorem apply. That is, there is a $c$ in $(a,b)$ with $(f(b) - f(a)) / (b-a) = f'(c) = 0$. But this would imply $f(b) - f(a)=0$. That is $f(x)$ is a constant, as for any $a$ and $b$, we see $f(a)=f(b)$.
"""

# ╔═╡ b90a462c-575a-11ec-03da-9f9be7bba84b
md"""### The Cauchy mean value theorem
"""

# ╔═╡ b90a4656-575a-11ec-3205-15eaf6147588
md"""[Cauchy](http://en.wikipedia.org/wiki/Mean_value_theorem#Cauchy.27s_mean_value_theorem) offered an extension to the mean value theorem above. Suppose both $f$ and $g$ satisfy the conditions of the mean value theorem on $[a,b]$ with $g(b)-g(a) \neq 0$, then there exists at least one $c$ with $a < c < b$ such that
"""

# ╔═╡ b90a466a-575a-11ec-2e92-93a33d4cd4b2
md"""```math
f'(c)  = g'(c) \cdot \frac{f(b) - f(a)}{g(b) - g(a)}.
```
"""

# ╔═╡ b90a4688-575a-11ec-0653-3522435feee7
md"""The proof follows by considering $h(x) = f(x) - r\cdot g(x)$, with $r$ chosen so that $h(a)=h(b)$. Then Rolle's theorem applies so that there is a $c$ with $h'(c)=0$, so $f'(c) = r g'(c)$, but $r$ can be seen to be $(f(b)-f(a))/(g(b)-g(a))$, which proves the theorem.
"""

# ╔═╡ b90a469e-575a-11ec-2d36-cb56b0157384
md"""Letting $g(x) = x$ demonstrates that the mean value theorem is a special case.
"""

# ╔═╡ b90a46b0-575a-11ec-07ba-7ff0f6bc1a89
md"""##### Example
"""

# ╔═╡ b90a46c4-575a-11ec-3728-115e88d748b6
md"""Suppose $f(x)$ and $g(x)$ satisfy the Cauchy mean value theorem on $[0,x]$, $g'(x)$ is non-zero on $(0,x)$, and $f(0)=g(0)=0$. Then we have:
"""

# ╔═╡ b90a46d8-575a-11ec-0c46-631bade1c73b
md"""```math
\frac{f(x) - f(0)}{g(x) - g(0)} = \frac{f(x)}{g(x)} = \frac{f'(c)}{g'(c)},
```
"""

# ╔═╡ b90a46ec-575a-11ec-2c79-e50eccb657be
md"""For some $c$ in $[0,x]$. If $\lim_{x \rightarrow 0} f'(x)/g'(x) = L$, then the right hand side will have a limit of $L$, and hence the left hand side will too. That is, when the limit exists, we have under these conditions that $\lim_{x\rightarrow 0}f(x)/g(x) = \lim_{x\rightarrow 0}f'(x)/g'(x)$.
"""

# ╔═╡ b90a470a-575a-11ec-0a5c-639d27797037
md"""This could be used to prove the limit of $\sin(x)/x$ as $x$ goes to $0$ just by showing the limit of $\cos(x)/1$ is $1$, as is known by continuity.
"""

# ╔═╡ b90a4714-575a-11ec-2d8d-75c862ac56a7
md"""### Visualizing the Cauchy mean value theorem
"""

# ╔═╡ b90a473c-575a-11ec-26d6-85a7b64fb1e0
md"""The Cauchy mean value theorem can be visualized in terms of a tangent line and a *parallel* secant line in a similar manner as the mean value theorem as long as a *parametric* graph is used. A parametric graph plots the points $(g(t), f(t))$ for some range of $t$. That is, it graphs *both* functions at the same time. The following illustrates the construction of such a graph:
"""

# ╔═╡ b90a6fe6-575a-11ec-27be-fd430f53d11c
let
	### {{{parametric_fns}}}
	
	
	
	function parametric_fns_graph(n)
	    f = (x) -> sin(x)
	    g = (x) -> x
	
	    ns = (1:10)/10
	    ts = range(-pi/2, stop=-pi/2 + ns[n] * pi, length=100)
	
	    plt = plot(f, g, -pi/2, -pi/2 + ns[n] * pi, legend=false, size=fig_size,
	               xlim=(-1.1,1.1), ylim=(-pi/2-.1, pi/2+.1))
	    scatter!(plt, [f(ts[end])], [g(ts[end])], color=:orange, markersize=5)
	    val = @sprintf("% 0.2f", ts[end])
	    annotate!(plt, [(0, 1, "t = $val")])
	end
	caption = L"""
	
	Illustration of parametric graph of $(g(t), f(t))$ for $-\pi/2 \leq t
	\leq \pi/2$ with $g(x) = \sin(x)$ and  $f(x) = x$. Each point on the
	graph is from some value $t$ in the interval. We can see that the
	graph goes through $(0,0)$ as that is when $t=0$. As well, it must go
	through $(1, \pi/2)$ as that is when $t=\pi/2$
	
	"""
	
	
	n = 10
	anim = @animate for i=1:n
	    parametric_fns_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	_ImageFile(imgfile, caption)
end

# ╔═╡ b90a7034-575a-11ec-0107-7b8ca4bd9612
md"""With $g(x) = \sin(x)$ and $f(x) = x$, we can take $I=[a,b] = [0, \pi/2]$. In the figure below, the *secant line* is drawn in red which connects $(g(a), f(a))$ with the point $(g(b), f(b))$, and hence has slope $\Delta f/\Delta g$. The parallel lines drawn show the *tangent* lines with slope $f'(c)/g'(c)$. Two exist for this problem, the mean value theorem guarantees at least one will.
"""

# ╔═╡ b90a73a6-575a-11ec-284b-7d11cf4d6186
let
	g(x) = sin(x)
	f(x) = x
	ts = range(-pi/2, stop=pi/2, length=50)
	a,b = 0, pi/2
	m = (f(b) - f(a))/(g(b) - g(a))
	cps = find_zeros(x -> f'(x)/g'(x) - m, -pi/2, pi/2)
	c = cps[1]
	Delta = (0 + m * (c - 0)) - (g(c))
	
	p = plot(g, f, -pi/2, pi/2, linewidth=3, legend=false)
	plot!(x -> f(a) + m * (x - g(a)), -1, 1, linewidth=3, color=:red)
	scatter!([g(a),g(b)], [f(a), f(b)])
	for c in cps
	  plot!(x -> f(c) + m * (x - g(c)), -1, 1, color=:orange)
	end
	
	p
end

# ╔═╡ b90a73c4-575a-11ec-3f7f-1dda0ed92146
md"""## Questions
"""

# ╔═╡ b90d0026-575a-11ec-23c0-df14356fac64
md"""###### Question
"""

# ╔═╡ b90d00d2-575a-11ec-29d0-d952b5326e89
md"""Rolle's theorem is a guarantee of a value, but does not provide a recipe to find it. For the function $1 - x^2$ over the interval $[-5,5]$, find a value $c$ that satisfies the result.
"""

# ╔═╡ b90d06c0-575a-11ec-2165-619092a42550
let
	c = 0
	numericq(c)
end

# ╔═╡ b90d06e8-575a-11ec-0565-412a4576a921
md"""###### Question
"""

# ╔═╡ b90d071a-575a-11ec-2b0c-2957d544aad5
md"""The extreme value theorem is a guarantee of a value, but does not provide a recipe to find it. For the function $f(x) = \sin(x)$ on $I=[0, \pi]$ find a value $c$ satisfying the theorem for an absolute maximum.
"""

# ╔═╡ b90d0ac6-575a-11ec-134d-195757a51f27
let
	c = pi/2
	numericq(c)
end

# ╔═╡ b90d0ad8-575a-11ec-0e02-3f7076c07f32
md"""###### Question
"""

# ╔═╡ b90d0af8-575a-11ec-1e5e-416a290aef18
md"""The extreme value theorem is a guarantee of a value, but does not provide a recipe to find it. For the function $f(x) = \sin(x)$ on $I=[\pi, 3\pi/2]$ find a value $c$ satisfying the theorem for an absolute maximum.
"""

# ╔═╡ b90d0da8-575a-11ec-1384-8fac8a7d9408
let
	c = pi
	numericq(c)
end

# ╔═╡ b90d0dc8-575a-11ec-279a-512f0ecf644e
md"""###### Question
"""

# ╔═╡ b90d0de6-575a-11ec-16fb-b97d4b420d62
md"""The mean value theorem is a guarantee of a value, but does not provide a recipe to find it. For $f(x) = x^2$ on $[0,2]$ find a value of $c$ satisfying the theorem.
"""

# ╔═╡ b90d10ca-575a-11ec-134e-f9f91dece5e0
let
	c = 1
	numericq(c)
end

# ╔═╡ b90d10de-575a-11ec-2a61-19b7751e4e21
md"""###### Question
"""

# ╔═╡ b90d10fc-575a-11ec-1c0d-e9093efc7d18
md"""The Cauchy mean value theorem is a guarantee of a value, but does not provide a recipe to find it. For $f(x) = x^3$ and $g(x) = x^2$ find a value $c$ in the interval $[1, 2]$
"""

# ╔═╡ b90d167e-575a-11ec-34e8-4f2c6996297f
let
	c,x = symbols("c, x", real=true)
	val = solve(3c^2 / (2c) - (2^3 - 1^3) / (2^2 - 1^2), c)[1]
	numericq(float(val))
end

# ╔═╡ b90d1692-575a-11ec-0e28-5996012f471e
md"""###### Question
"""

# ╔═╡ b90d16b0-575a-11ec-0bfa-d1304f88a906
md"""Will the function $f(x) = x + 1/x$ satisfy the conditions of the mean value theorem over $[-1/2, 1/2]$?
"""

# ╔═╡ b90d19f8-575a-11ec-2f78-87993e26b30b
let
	radioq(["Yes", "No"], 2)
end

# ╔═╡ b90d1a0c-575a-11ec-112f-61ff90c90f4f
md"""###### Question
"""

# ╔═╡ b90d1a3e-575a-11ec-31a6-f7a603523fff
md"""Just as it is a fact that $f'(x) = 0$ (for all $x$ in $I$) implies $f(x)$ is a constant, so too is it a fact that if $f'(x) = g'(x)$ that $f(x) - g(x)$ is a constant. What function would you consider, if you wanted to prove this with the mean value theorem?
"""

# ╔═╡ b90d27e0-575a-11ec-1eca-152a2b2ab825
let
	choices = [
	"``h(x) = f(x) - (f(b) - f(a)) / (b - a)``",
	"``h(x) = f(x) - (f(b) - f(a)) / (b - a) \\cdot g(x)``",
	"``h(x) = f(x) - g(x)``",
	"``h(x) = f'(x) - g'(x)``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ b90d27f4-575a-11ec-229a-b9dbd4821470
md"""###### Question
"""

# ╔═╡ b90d2812-575a-11ec-3598-03b3f1643128
md"""Suppose $f''(x) > 0$ on $I$. Why is it impossible that $f'(x) = 0$ at more than one value in $I$?
"""

# ╔═╡ b90d3532-575a-11ec-2410-6912dda7d5ab
let
	choices = [
	L"It isn't. The function $f(x) = x^2$ has two zeros and $f''(x) = 2 > 0$",
	"By the Rolle's theorem, there is at least one, and perhaps more",
	L"By the mean value theorem, we must have $f'(b) - f'(a) > 0$ when ever $b > a$. This means $f'(x)$ is increasing and can't double back to have more than one zero."
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ b90d3544-575a-11ec-21ef-5b5865224c94
md"""###### Question
"""

# ╔═╡ b90d356e-575a-11ec-2371-a5ee7e1838a0
md"""Let $f(x) = 1/x$. For $0 < a < b$, find $c$ so that $f'(c) = (f(b) - f(a)) / (b-a)$.
"""

# ╔═╡ b90d3d8e-575a-11ec-0809-c17d643b0c8c
let
	choices = [
	"``c = (a+b)/2``",
	"``c = \\sqrt{ab}``",
	"``c = 1 / (1/a + 1/b)``",
	"``c = a + (\\sqrt{5} - 1)/2 \\cdot (b-a)``"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ b90d3da2-575a-11ec-3bbd-112ae8d19410
md"""###### Question
"""

# ╔═╡ b90d3dc0-575a-11ec-2b70-27ef9064e104
md"""Let $f(x) = x^2$. For $0 < a < b$, find $c$ so that $f'(c) = (f(b) - f(a)) / (b-a)$.
"""

# ╔═╡ b90d45fe-575a-11ec-2dff-59015bc50ca5
let
	choices = [
	"``c = (a+b)/2``",
	"``c = \\sqrt{ab}``",
	"``c = 1 / (1/a + 1/b)``",
	"``c = a + (\\sqrt{5} - 1)/2 \\cdot (b-a)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ b90d4612-575a-11ec-1b0d-0b55313a046a
md"""###### Question
"""

# ╔═╡ b90d4644-575a-11ec-397a-fde07bf0ec7a
md"""In an example, we used the fact that if $0 < c < x$, for some $c$ given by the mean value theorem and $f(x)$ goes to $0$ as $x$ goes to zero then $f(c)$ will also go to zero. Suppose we say that $c=g(x)$ for some function $c$.
"""

# ╔═╡ b90d4658-575a-11ec-16f6-2d818a129603
md"""Why is it known that $g(x)$ goes to $0$ as $x$ goes to zero (from the right)?
"""

# ╔═╡ b90d504e-575a-11ec-000c-0d982793525c
let
	choices = [L"The squeeze theorem applies, as $0 < g(x) < x$.",
	L"As $f(x)$ goes to zero by Rolle's theorem it must be that $g(x)$ goes to $0$.",
	L"This follows by the extreme value theorem, as there must be some $c$ in $[0,x]$."]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ b90d5080-575a-11ec-39d2-b5e1ff30b23e
md"""Since $g(x)$ goes to zero, why is it true that if $f(x)$ goes to $L$ as $x$ goes to zero that $f(g(x))$ must also have a limit $L$?
"""

# ╔═╡ b90d594a-575a-11ec-2ab7-233c43162883
let
	choices = ["It isn't true. The limit must be 0",
	L"The squeeze theorem applies, as $0 < g(x) < x$",
	"This follows from the limit rules for composition of functions"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ b90d5968-575a-11ec-2930-5d454a828e90
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/symbolic_derivatives.html">◅ previous</a>  <a href="../derivatives/optimization.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/mean_value_theorem.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ b90d5970-575a-11ec-16e5-d580f1d5c7cc
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.12"
Plots = "~1.25.0"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "a27b8f527652c6c06c0857319878b22563238102"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.12"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

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
git-tree-sha1 = "8789439a899b77f4fbb4d7298500a6a5781205bc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

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
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

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
# ╟─b90d5954-575a-11ec-2365-d7a927232494
# ╟─b8c8b358-575a-11ec-36ea-4191abf1e30e
# ╟─b8cad534-575a-11ec-353f-d957ac210712
# ╠═b8e1ee4a-575a-11ec-1f1e-630a42ad10f4
# ╟─b8e1f372-575a-11ec-307f-c317a138de1e
# ╟─b8e3ddfe-575a-11ec-29e6-53e319df9d8a
# ╟─b8e873b6-575a-11ec-2b2c-b7564e8b4dfa
# ╟─b8e8745e-575a-11ec-2f0c-6728c9aa0c91
# ╟─b8e87468-575a-11ec-0dc7-1dff7a6fc64c
# ╟─b8eb229e-575a-11ec-2dfe-054766a129f3
# ╟─b8ec3882-575a-11ec-128d-b1cafa9c2e3e
# ╟─b8f305ae-575a-11ec-1721-0d620044df9f
# ╟─b8f305f4-575a-11ec-1f98-7b5928011250
# ╟─b8f3061c-575a-11ec-2f8a-cd5af3d37e78
# ╠═b8f30cac-575a-11ec-19c8-a5d784700d95
# ╟─b8f30cea-575a-11ec-33cc-b7abb13d0f7c
# ╟─b8f30cfc-575a-11ec-311f-bbffe80b6464
# ╠═b8f31490-575a-11ec-2a4d-ffa646d031df
# ╟─b8f314b8-575a-11ec-0d57-01c93ae3b5ba
# ╠═b8f3171a-575a-11ec-0764-69c3b1802c4e
# ╟─b8f3174c-575a-11ec-1eb6-518445daf658
# ╟─b8f32a48-575a-11ec-062a-81925275d289
# ╟─b8f51100-575a-11ec-240a-b7ed94ef0424
# ╟─b8f51182-575a-11ec-14b8-31843f3e35ec
# ╟─b8f511e6-575a-11ec-3172-c50e9397e72b
# ╟─b8f5122e-575a-11ec-01ee-b799f263213b
# ╟─b8f51240-575a-11ec-0bd2-19a4dc2fa3ff
# ╟─b8f51baa-575a-11ec-39a3-519a094b30db
# ╟─b8f51bd4-575a-11ec-0234-f37706912e79
# ╟─b8f6458c-575a-11ec-0b4c-c70095501584
# ╟─b8f64610-575a-11ec-0f55-0d7026c7769f
# ╟─b8f7f21c-575a-11ec-058e-0b8f73eb5177
# ╟─b8fa1ac4-575a-11ec-22d6-c5d4237c454d
# ╟─b8fa1bd0-575a-11ec-16aa-9f8a34918795
# ╟─b8fa1be6-575a-11ec-0fe1-75ce88fedc51
# ╟─b8fa1d38-575a-11ec-3856-135cfbc8305d
# ╟─b8fa1d4e-575a-11ec-19b1-4b62eb7c2fa1
# ╟─b8fa9a58-575a-11ec-2456-fd73fcb9852f
# ╟─b8fa9abc-575a-11ec-3739-559d462e49d3
# ╟─b8fa9bca-575a-11ec-380e-83269db4d1d1
# ╟─b8fa9bd4-575a-11ec-1f51-81907526f139
# ╟─b8fa9bfc-575a-11ec-2119-219edf2176d0
# ╟─b8faa356-575a-11ec-358d-95d855cc73d3
# ╟─b8fb89e0-575a-11ec-0f06-d94f46be0efa
# ╟─b8fe24e8-575a-11ec-3887-d1f8e1558337
# ╟─b9063048-575a-11ec-0ca0-999e84fa7d80
# ╠═b90638a6-575a-11ec-28ce-d392763ec0d0
# ╟─b908b908-575a-11ec-1e50-b5435c466b96
# ╟─b908b988-575a-11ec-2d20-dba9b9badc70
# ╟─b908b9a8-575a-11ec-1949-67bcedea56d4
# ╠═b908c1f0-575a-11ec-371a-0d97dfadaa9c
# ╟─b908c236-575a-11ec-1d4f-9dd67a741b51
# ╠═b908c57e-575a-11ec-10d9-01a63b598026
# ╟─b908c59a-575a-11ec-1c2f-9bea1ef1f90f
# ╟─b908c5d8-575a-11ec-2277-dd3e21df3b02
# ╠═b908cae2-575a-11ec-3556-090ebbaaea22
# ╟─b908cb00-575a-11ec-0c23-8fb81d05e26a
# ╟─b908cb0c-575a-11ec-3b5e-2d193b21e9a9
# ╠═b908cd30-575a-11ec-0728-83a053aef0f0
# ╟─b908cd58-575a-11ec-0a8c-11e7c86d3574
# ╟─b908cd80-575a-11ec-27d8-d178cb928ebb
# ╟─b908cd9e-575a-11ec-3d35-f59a610e575a
# ╠═b908d2a8-575a-11ec-0964-bd7edeb5bcda
# ╟─b908d2c6-575a-11ec-1b29-09686af89ae5
# ╠═b908d53c-575a-11ec-013d-15c1fe1dd547
# ╟─b908d564-575a-11ec-0a72-8deae58c6afe
# ╟─b908e34c-575a-11ec-12c4-a5de61af743d
# ╟─b908e388-575a-11ec-3930-ad58a7108a3f
# ╟─b908e3ba-575a-11ec-1f03-23e5d749eaf8
# ╟─b90a1d9a-575a-11ec-2863-7d9d5e102880
# ╟─b90a1dfa-575a-11ec-0ae2-bf5b4910fe3c
# ╟─b90a1e38-575a-11ec-3b4e-f10f5b1fb2a7
# ╟─b90a1e74-575a-11ec-37d1-336cfdcfbb7d
# ╟─b90a1e9c-575a-11ec-1550-c9f5f080567b
# ╟─b90a1ed0-575a-11ec-34d0-f1810fd78ebe
# ╠═b90a270e-575a-11ec-04a6-6b8ced9059f1
# ╟─b90a2748-575a-11ec-08b9-5bd89daa753b
# ╟─b90a2c5c-575a-11ec-349a-5b2c10606d8d
# ╟─b90a2c7c-575a-11ec-2582-d3eca3ae1fdb
# ╟─b90a2ca2-575a-11ec-36c7-f1b98415195d
# ╟─b90a2cb6-575a-11ec-3252-eb25ea4e50f4
# ╟─b90a2d72-575a-11ec-1233-ffaa92ce7e21
# ╟─b90a2d92-575a-11ec-12a4-a782d2c1a9a8
# ╟─b90a2da6-575a-11ec-286a-2133619e49c5
# ╟─b90a31ca-575a-11ec-14fe-9db6d33123ae
# ╟─b90a31de-575a-11ec-1ae5-65a477cea3a0
# ╟─b90a3206-575a-11ec-1cc8-23758a61d4e1
# ╟─b90a321c-575a-11ec-2a5f-29449b0fc99e
# ╟─b90a4536-575a-11ec-08af-c7cce532a4bf
# ╟─b90a455c-575a-11ec-3292-df1c9de4d209
# ╟─b90a457a-575a-11ec-2f70-3db44612629a
# ╟─b90a45a2-575a-11ec-08e1-8987e7e39271
# ╟─b90a45c0-575a-11ec-3fb2-d92efec80755
# ╟─b90a45fa-575a-11ec-2f87-21f499c47865
# ╟─b90a462c-575a-11ec-03da-9f9be7bba84b
# ╟─b90a4656-575a-11ec-3205-15eaf6147588
# ╟─b90a466a-575a-11ec-2e92-93a33d4cd4b2
# ╟─b90a4688-575a-11ec-0653-3522435feee7
# ╟─b90a469e-575a-11ec-2d36-cb56b0157384
# ╟─b90a46b0-575a-11ec-07ba-7ff0f6bc1a89
# ╟─b90a46c4-575a-11ec-3728-115e88d748b6
# ╟─b90a46d8-575a-11ec-0c46-631bade1c73b
# ╟─b90a46ec-575a-11ec-2c79-e50eccb657be
# ╟─b90a470a-575a-11ec-0a5c-639d27797037
# ╟─b90a4714-575a-11ec-2d8d-75c862ac56a7
# ╟─b90a473c-575a-11ec-26d6-85a7b64fb1e0
# ╟─b90a6fe6-575a-11ec-27be-fd430f53d11c
# ╟─b90a7034-575a-11ec-0107-7b8ca4bd9612
# ╟─b90a73a6-575a-11ec-284b-7d11cf4d6186
# ╟─b90a73c4-575a-11ec-3f7f-1dda0ed92146
# ╟─b90d0026-575a-11ec-23c0-df14356fac64
# ╟─b90d00d2-575a-11ec-29d0-d952b5326e89
# ╟─b90d06c0-575a-11ec-2165-619092a42550
# ╟─b90d06e8-575a-11ec-0565-412a4576a921
# ╟─b90d071a-575a-11ec-2b0c-2957d544aad5
# ╟─b90d0ac6-575a-11ec-134d-195757a51f27
# ╟─b90d0ad8-575a-11ec-0e02-3f7076c07f32
# ╟─b90d0af8-575a-11ec-1e5e-416a290aef18
# ╟─b90d0da8-575a-11ec-1384-8fac8a7d9408
# ╟─b90d0dc8-575a-11ec-279a-512f0ecf644e
# ╟─b90d0de6-575a-11ec-16fb-b97d4b420d62
# ╟─b90d10ca-575a-11ec-134e-f9f91dece5e0
# ╟─b90d10de-575a-11ec-2a61-19b7751e4e21
# ╟─b90d10fc-575a-11ec-1c0d-e9093efc7d18
# ╟─b90d167e-575a-11ec-34e8-4f2c6996297f
# ╟─b90d1692-575a-11ec-0e28-5996012f471e
# ╟─b90d16b0-575a-11ec-0bfa-d1304f88a906
# ╟─b90d19f8-575a-11ec-2f78-87993e26b30b
# ╟─b90d1a0c-575a-11ec-112f-61ff90c90f4f
# ╟─b90d1a3e-575a-11ec-31a6-f7a603523fff
# ╟─b90d27e0-575a-11ec-1eca-152a2b2ab825
# ╟─b90d27f4-575a-11ec-229a-b9dbd4821470
# ╟─b90d2812-575a-11ec-3598-03b3f1643128
# ╟─b90d3532-575a-11ec-2410-6912dda7d5ab
# ╟─b90d3544-575a-11ec-21ef-5b5865224c94
# ╟─b90d356e-575a-11ec-2371-a5ee7e1838a0
# ╟─b90d3d8e-575a-11ec-0809-c17d643b0c8c
# ╟─b90d3da2-575a-11ec-3bbd-112ae8d19410
# ╟─b90d3dc0-575a-11ec-2b70-27ef9064e104
# ╟─b90d45fe-575a-11ec-2dff-59015bc50ca5
# ╟─b90d4612-575a-11ec-1b0d-0b55313a046a
# ╟─b90d4644-575a-11ec-397a-fde07bf0ec7a
# ╟─b90d4658-575a-11ec-16f6-2d818a129603
# ╟─b90d504e-575a-11ec-000c-0d982793525c
# ╟─b90d5080-575a-11ec-39d2-b5e1ff30b23e
# ╟─b90d594a-575a-11ec-2ab7-233c43162883
# ╟─b90d5968-575a-11ec-2930-5d454a828e90
# ╟─b90d5968-575a-11ec-299e-136596396529
# ╟─b90d5970-575a-11ec-16e5-d580f1d5c7cc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
