### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 2c5c21de-53a2-11ec-2f5b-85a338a9b908
begin
	using CalculusWithJulia
	using Plots
	using Roots
	using SymPy
end

# ╔═╡ 2c5c9e68-53a2-11ec-0192-ad69c8ee4080
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	
	# keep until CwJ bumps version
	using Downloads
	function JSXGraph(fname, caption)
	    url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/"
	    content = read(Downloads.download(joinpath(url, fname)), String)
	    CalculusWithJulia.WeaveSupport.JSXGRAPH(content, caption,
	                                            "jsxgraph", "jsxgraph",
	                                            500, 300)
	end
	nothing
end

# ╔═╡ 2ca9da7a-53a2-11ec-078a-c93ddbaaed4d
using PlutoUI

# ╔═╡ 2ca9bda6-53a2-11ec-07e3-15828f089956
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 2c5a022a-53a2-11ec-3c4a-f10410457718
md"""# Optimization
"""

# ╔═╡ 2c5a584c-53a2-11ec-1403-df253a63302d
md"""This section uses these add-on packages:
"""

# ╔═╡ 2c5ce666-53a2-11ec-174f-eb4feb5a933d
md"""---
"""

# ╔═╡ 2c5ce724-53a2-11ec-2b2e-955a50fcf282
md"""A basic application of calculus is to answer questions which relate to the largest or smallest a function can be given some constraints.
"""

# ╔═╡ 2c5ce792-53a2-11ec-104e-85544f27a3d5
md"""For example,
"""

# ╔═╡ 2c5e2f12-53a2-11ec-0083-b70e782c954b
md"""> Of all rectangles with perimeter 20, which has of the largest area?

"""

# ╔═╡ 2c5e62fc-53a2-11ec-1baf-99446b8d0bde
md"""The main tool is the extreme value theorem of Bolzano and Fermat's theorem about critical points: If the function $f(x)$ is continuous on $[a,b]$ and differentiable on $(a,b)$, then the extrema exist and must occur at either an end point or a critical point.
"""

# ╔═╡ 2c5e63ce-53a2-11ec-394b-299d0d3817cf
md"""Though not all of our problems lend themselves to a description of a continuous function on a closed interval, if they do, we have an algorithmic prescription to find the absolute extrema of a function:
"""

# ╔═╡ 2c5ed1e2-53a2-11ec-1156-6f9b0ab93274
md"""1. Find the critical points. For this we can use a root-finding algorithm like `find_zero`.
2. Evaluate the function values at the critical points and at the end points.
3. Identify the largest and smallest values.
"""

# ╔═╡ 2c5ed232-53a2-11ec-1c88-a5ffb43bf636
md"""With the computer we can take some shortcuts, as we will be able to graph our function to see where the extreme values will be.
"""

# ╔═╡ 2c5f142a-53a2-11ec-3936-69b926075b26
md"""## Fixed perimeter and area
"""

# ╔═╡ 2c5f14d6-53a2-11ec-0b33-1b72b9040dc3
md"""The simplest way to investigate the maximum or minimum value of a function over a closed interval is to just graph it and look.
"""

# ╔═╡ 2c5f1526-53a2-11ec-24f1-ddca0ec39da9
md"""We began with the question of which rectangles of perimeter 20 have the largest area? The figure shows a few different rectangles with this perimeter and their respective areas.
"""

# ╔═╡ 2c5f65da-53a2-11ec-3575-436d885af12c
let
	### {{{perimeter_area_graphic}}}
	pyplot()
	fig_size = (400, 400)
	
	
	function perimeter_area_graphic_graph(n)
	    h = 1 + 2n
	    w = 10-h
	    plt = plot([0,0,w,w,0], [0,h,h,0,0], legend=false, size=fig_size,
	               xlim=(0,10), ylim=(0,10))
	    scatter!(plt, [w], [h], color=:orange, markersize=5)
	    annotate!(plt, [(w/2, h/2, "Area=$(round(w*h,digits=1))")])
	    plt
	end
	
	caption = """
	
	Some possible rectangles that satisfy the constraint on the perimeter and their area.
	
	"""
	n = 6
	anim = @animate for i=1:n
	    perimeter_area_graphic_graph(i-1)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 2c5f66c8-53a2-11ec-08b5-278f31613b0b
md"""The basic mathematical approach is to find a function of a single variable to maximize or minimize. In this case we have two variables describing a rectangle: a base $b$ and height $h$. Our formulas are the area of a rectangle:
"""

# ╔═╡ 2c5f923c-53a2-11ec-02f2-35a431d14125
md"""```math
A = bh,
```
"""

# ╔═╡ 2c5f930c-53a2-11ec-3ca3-a56dccacbd24
md"""and the formula for the perimeter of a rectangle:
"""

# ╔═╡ 2c5f9320-53a2-11ec-2509-35cd4020f2cb
md"""```math
P = 2b + 2h = 20.
```
"""

# ╔═╡ 2c5f93ac-53a2-11ec-21ec-e9ddd0123dde
md"""From this last one, we see that $b$ can be no bigger than 10 and no smaller than 0 from the restriction put in place through the perimeter. Solving for $h$ in terms of $b$ then yields this restatement of the problem:
"""

# ╔═╡ 2c5f93ca-53a2-11ec-33ca-bd32d4a9a46c
md"""Maximize $A(b) = b \cdot (10 - b)$ over the interval $[0,10]$.
"""

# ╔═╡ 2c5f9442-53a2-11ec-379d-39cf1644ff80
md"""This is exactly the form needed to apply our theorem about the existence of extrema (a continuous function on a closed interval). Rather than solve analytically by taking a derivative, we simply graph to find the value:
"""

# ╔═╡ 2c5fb9a6-53a2-11ec-2650-f19dbe6b6a31
begin
	Area(b) = b * (10 - b)
	plot(Area, 0, 10)
end

# ╔═╡ 2c5fd260-53a2-11ec-3631-b3e15468c3f2
md"""You should see the maximum occurs at $b=5$ by symmetry, so $h=5$ as well, and the maximum area is then $25$. This gives the satisfying answer that among all rectangles of fixed perimeter, that with the largest area is a square. As well, this indicates a common result: there is often some underlying symmetry in the answer.
"""

# ╔═╡ 2c60356e-53a2-11ec-3b1f-ade436ae0869
md"""### Exploiting polymorphism
"""

# ╔═╡ 2c604e1e-53a2-11ec-1317-f7ba456a1b06
md"""Before moving on, let's see a slightly different way to do this problem with `Julia`, where we trade off some algebra for a bit of abstraction. This was discussed in the section on [functions](../precalc/functions.html). Let's first write area as a function of both base and height:
"""

# ╔═╡ 2c607d94-53a2-11ec-110d-7d21c3588b73
A(b, h) = b*h

# ╔═╡ 2c607e7a-53a2-11ec-14fb-0903556fd2c3
md"""Here we write area, quite naturally, as a function of two variables.
"""

# ╔═╡ 2c607f56-53a2-11ec-27f1-0b494232d476
md"""Then from the constraint given by the perimeter being a fixed value we can solve for `h` in terms of `b`. We write this as a function:
"""

# ╔═╡ 2c6086fe-53a2-11ec-239b-4383e404b756
h(b) = (20 - 2b) / 2

# ╔═╡ 2c6087ee-53a2-11ec-3b63-8344b176104a
md"""Then to get `A(b)` we simply need to substitute `h(b)` into our formula for the area, `A`. However, instead of doing the substitution ourselves using algebra we let `Julia` do it through composition of functions:
"""

# ╔═╡ 2c608b68-53a2-11ec-0c2f-532616a2dece
A(b) = A(b, h(b))

# ╔═╡ 2c608b88-53a2-11ec-15f7-bb6e82174313
md"""From this we can solve graphically as before, or numerically. We search for zeros of the derivative:
"""

# ╔═╡ 2c60c47a-53a2-11ec-0759-75d3a3cd60a1
find_zeros(A', 0, 10)   # find_zeros in `Roots`,

# ╔═╡ 2c60f86e-53a2-11ec-0b86-d3c21d2813b9
alert("""

Look at the last definition of `A`. The function `A` appears on both sides, though on the left side with one argument and on the right with two. These are two "methods" of a *generic* function, `A`. `Julia` allows multiple definitions for the same name as long as the arguments (their number and type) can disambiguate which to use. In this instance, when one argument is passed in then the last defintion is used (`A(b,h(b))`), whereas if two are passed in, then the method that multiplies both arguments is used. The advantage of multiple dispatch is illustrated: the same concept - area - has one function name, though there may be different ways to compute the area, so there is more than one implementation.

""")

# ╔═╡ 2c60f968-53a2-11ec-0cd1-fb761513157a
md"""### Norman Windows
"""

# ╔═╡ 2c60fb3e-53a2-11ec-3567-eddd41c93aa6
md"""Here is a similar, though more complicated, example where the analytic approach can be a bit more tedious, but the graphical one mostly satisfying, though we do use  a numerical algorithm to find an exact final answer.
"""

# ╔═╡ 2c60fc2e-53a2-11ec-0859-e14b13aa0a17
md"""Let a "[Norman](https://en.wikipedia.org/wiki/Norman_architecture)" window consist of a rectangular window of top length $x$ and side length $y$ and a half circle on top. The goal is to maximize the area for a fixed value of the perimeter. Again, assume this perimeter is 20 units.
"""

# ╔═╡ 2c60fd32-53a2-11ec-231a-9f9cc0da88d9
md"""This figure shows two such windows, one with base length given by $x=4$, the other with base length given by $x=3$. The one with base length $4$ seems to have much bigger area, what value of $x$ will lead to the largest area?
"""

# ╔═╡ 2c6141b6-53a2-11ec-3fa0-8d65b291ed97
let
	ts = range(0, stop=pi, length=50)
	x1,y1 = 4, 4.85840
	x2,y2 = 3, 6.1438
	delta = 4
	p = plot(delta .+ x1*[0, 1,1,0], y1*[0,0,1,1],          linetype=:polygon, fillcolor=:blue, legend=false)
	plot!(p, x2*[0, 1,1,0], y2*[0,0,1,1],                linetype=:polygon, fillcolor=:blue)
	
	plot!(p, delta .+ x1/2 .+ x1/2*cos.(ts), y1.+x1/2*sin.(ts), linetype=:polygon, fillcolor=:red)
	plot!(p, x2/2 .+ x2/2*cos.(ts), y2 .+ x2/2*sin.(ts),         linetype=:polygon, fillcolor=:red)
	p
end

# ╔═╡ 2c614256-53a2-11ec-2564-f9108d5b7a67
md"""For this problem, we have two equations.
"""

# ╔═╡ 2c614364-53a2-11ec-1c1d-bba800b08eb1
md"""The area is the area of the rectangle plus the area of the half circle ($\pi r^2/2$ with $r=x/2$).
"""

# ╔═╡ 2c6143be-53a2-11ec-1aa6-c3e61473a34a
md"""```math
A = xy + \pi(x/2)^2/2
```
"""

# ╔═╡ 2c6143e6-53a2-11ec-1705-c50fe8aa2013
md"""In `Julia` this is
"""

# ╔═╡ 2c619240-53a2-11ec-3629-dd2be3577199
Aᵣ(x, y) = x*y + pi*(x/2)^2 / 2

# ╔═╡ 2c619328-53a2-11ec-1e5f-e3979d4c7b83
md"""The perimeter consists of 3 sides of the rectangle and the perimeter of half a circle ($\pi r$, with $r=x/2$):
"""

# ╔═╡ 2c6193b4-53a2-11ec-1f5a-b791f0b0eae9
md"""```math
P = 2y + x + \pi(x/2) = 20
```
"""

# ╔═╡ 2c6193fa-53a2-11ec-08f9-dde4d8f8ed0c
md"""We solve for $y$ in the first with $y = (20 - x - \pi(x/2))/2$ so that in `Julia` we have:
"""

# ╔═╡ 2c619b70-53a2-11ec-1af2-af512e29b4b2
y(x) = (20 - x - pi * x/2) / 2

# ╔═╡ 2c619bac-53a2-11ec-34fa-a71918912b46
md"""And then we substitute in `y(x)` for `y` in the area formula through:
"""

# ╔═╡ 2c61b83a-53a2-11ec-352a-9d0f786dcf89
Aᵣ(x) = Aᵣ(x, y(x))

# ╔═╡ 2c61b98e-53a2-11ec-0b6b-e1e3364c4730
md"""Of course both $x$ and $y$ are non-negative. The latter forces $x$ to be no more than $x=20/(1+\pi/2)$.
"""

# ╔═╡ 2c61ba0e-53a2-11ec-1403-b5b7336f4b3c
md"""This leaves us the calculus problem of finding an absolute maximum of a continuous function over the closed interval $[0, 20/(1+\pi/2)]$. Our theorem tells us this maximum must occur, we now proceed to find it.
"""

# ╔═╡ 2c61ba7e-53a2-11ec-248b-9dbb71361490
md"""We begin by simply graphing and estimating the values of the maximum and where it occurs.
"""

# ╔═╡ 2c61d93a-53a2-11ec-2699-b10320761ef0
plot(Aᵣ, 0, 20/(1+pi/2))

# ╔═╡ 2c61d9f0-53a2-11ec-2542-296997d0a4a0
md"""The naked eye sees that maximum value is somewhere around $27$ and occurs at $x\approx 5.6$. Clearly from the graph, we know the maximum value happens at the critical point and there is only one such critical point.
"""

# ╔═╡ 2c61da74-53a2-11ec-3497-09ba19a629ef
md"""As reading the maximum from the graph is more difficult than reading a $0$ of a function, we plot the derivative using our approximate derivative.
"""

# ╔═╡ 2c620d44-53a2-11ec-0c22-d10821ceb819
plot(Aᵣ', 5.5, 5.7)

# ╔═╡ 2c620de2-53a2-11ec-2dc7-a76e358230fd
md"""We confirm that the critical point is around $5.6$.
"""

# ╔═╡ 2c620e16-53a2-11ec-2da1-83defd1f46da
md"""(As a reminder, the notation `Aᵣ'` is defined in `CalculusWithJulia` using the `derivative` function from the `ForwardDiff` package.)
"""

# ╔═╡ 2c97a53a-53a2-11ec-1019-bb10ff1249af
md"""#### Using `find_zero` to locate critical points.
"""

# ╔═╡ 2c97c0f6-53a2-11ec-12ec-41f97208a848
md"""Rather than zoom in graphically, we now use a root-finding algorithm, to find a more precise value. We know that the maximum will occur at a critical point, a zero of the derivative. The `find_zero` function from the `Roots` package provides a non-linear root-finding algorithm based on the bisection method. The only thing to keep track of is that solving $f'(x) = 0$ means we use the derivative and not the original function.
"""

# ╔═╡ 2c97c1aa-53a2-11ec-21cc-ebf9c91b80fc
md"""We see from the graph that $[0, 20/(1+\pi/2)]$ will provide a bracket, as there is only one relative maximum:
"""

# ╔═╡ 2c98005c-53a2-11ec-34f5-471467086aa0
x′ = find_zero(A', (0, 20/(1+pi/2)))

# ╔═╡ 2c980110-53a2-11ec-220b-b95d187f9cc3
md"""The value `x` is the critical point, and in this case gives the position of the value that will maximize the function.  The value and maximum area is then given by:
"""

# ╔═╡ 2c980426-53a2-11ec-0e9b-b3cfc0cacd05
(x′, A(x′))

# ╔═╡ 2c981de4-53a2-11ec-0a04-79478aa01daa
md"""(Compare this answer to the previous, is the square the figure of greatest area for a fixed perimeter, or just the figure amongst all rectangles? See [Isoperimetric inequality](https://en.wikipedia.org/wiki/Isoperimetric_inequality) for an answer.)
"""

# ╔═╡ 2c982d16-53a2-11ec-349a-f1121f7aa47d
md"""### Using `argmax` to identify where a function is maximized
"""

# ╔═╡ 2c982e92-53a2-11ec-2f69-b3f0bd75d87d
md"""This value that maximizes a function is sometimes referred to as the *argmax*, or argument which maximizes the function. In `Julia` the `argmax(f,domain)` function is defined to "Return a value $x$ in the domain of $f$ for which $f(x)$ is maximized. If there are multiple maximal values for $f(x)$ then the first one will be found." The domain is some iterable collection. In the mathematical world this would be an interval $[a,b]$, but on the computer it is an approximation, such as is returned by `range` below. Without out having to take a derivative, as above, but sacrificing some accuracy, the task of identifying `x` for where `A` is maximum, could be done with
"""

# ╔═╡ 2c985bec-53a2-11ec-2622-8b8de9315fe2
argmax(Aᵣ, range(0, 20/(1+pi/2), length=10000))

# ╔═╡ 2c985c6e-53a2-11ec-2f1d-835d652018ad
md"""#### A symbolic approach
"""

# ╔═╡ 2c985d04-53a2-11ec-386b-ff1104fc0aaf
md"""We could also do the above problem symbolically with the aid of `SymPy`. Here are the steps:
"""

# ╔═╡ 2c98cece-53a2-11ec-103e-c724c9068851
begin
	@syms 𝒘::real 𝒉::real
	
	𝑨₀    = 𝒘 * 𝒉 + pi * (𝒘/2)^2 / 2
	𝑷erim = 2*𝒉 + 𝒘 + pi * 𝒘/2
	𝒉₀    = solve(𝑷erim - 20, 𝒉)[1]
	𝑨₁     = 𝑨₀(𝒉 => 𝒉₀)
	𝒘₀    = solve(diff(𝑨₁,𝒘), 𝒘)[1]
end

# ╔═╡ 2c98cfc8-53a2-11ec-0066-3b9ccb437e6b
md"""We know that `𝒘₀` is the maximum in this example from our previous work. We shall see soon, that just knowing that the second derivative is negative at `𝒘₀` would suffice to know this. Here we check that condition:
"""

# ╔═╡ 2c991b0e-53a2-11ec-3f7c-bf0094996793
diff(𝑨₁, 𝒘, 𝒘)(𝒘 => 𝒘₀)

# ╔═╡ 2c991bd6-53a2-11ec-3025-ed5f4dbd02a3
md"""As an aside, compare the steps involved above for a symbolic solution to those of previous work for a numeric solution:
"""

# ╔═╡ 2c9954fe-53a2-11ec-2eca-fda1f4bd3e7f
let
	Aᵣ(w, h) = w*h + pi*(w/2)^2 / 2
	h(w)     = (20 - w - pi * w/2) / 2
	Aᵣ(w)    =  A(w, h(w))
	find_zero(A', (0, 20/(1+pi/2)))  # 40 / (pi + 4)
end

# ╔═╡ 2c99565a-53a2-11ec-27be-137ffe969927
md"""They are similar, except we solved for `h0` symbolically, rather than by hand, when we solved for `h(w)`.
"""

# ╔═╡ 2c997088-53a2-11ec-2b22-5311d502273e
md"""##### Example
"""

# ╔═╡ 2c9992fa-53a2-11ec-2906-1b66d4987ccf
let
	caption = """
	The figure shows a trapezoid inscribed in a circle. By adjusting the point ``P_3 = (x,y)`` on the upper-half circle, the area of the trapezoid changes. What value of ``x`` will produce the maximum area for a given ``r`` (from ``P_4``, which can also be adjusted)? By playing around with different values of ``P_3`` and ``P_4`` the answer can be guessed.
	"""
	#CalculusWithJulia.WeaveSupport.JSXGraph(joinpath(@__DIR__, "optimization-trapezoid.js"), caption)
	JSXGraph("optimization-trapezoid.js", caption)
	nothing
end

# ╔═╡ 2c999340-53a2-11ec-1f65-3fba01889547
md"""---
"""

# ╔═╡ 2c999408-53a2-11ec-3acb-bf1f1b960a4d
md"""A trapezoid is *inscribed* in the upper-half circle of radius $r$. The trapezoid is found be connecting the points $(x,y)$ (in the first quadrant) with $(r, 0)$, $(-r,0)$, and $(-x, y)$. Find the maximum area.
"""

# ╔═╡ 2c999444-53a2-11ec-0006-0df2153e8578
md"""Here the constraint is simply $r^2 = x^2 + y^2$ with $x$ and $y$ being non-negative. The area is then found through the average of the two lengths times the height. Using `height` for `y`, we have:
"""

# ╔═╡ 2c99dc92-53a2-11ec-0218-bddeb1241860
begin
	@syms x::positive r::positive
	hₜ = sqrt(r^2 - x^2)
	aₜ = (2x + 2r)/2 * hₜ
	possible_sols = solve(diff(aₜ, x) ~ 0, x) # possibly many solutions
	x0 = first(possible_sols)  # only solution is also found from first or [1] indexing
end

# ╔═╡ 2c99dcf6-53a2-11ec-1a29-49376c2dd2f6
md"""The other values of interest can be found through substitution. For example:
"""

# ╔═╡ 2c99e322-53a2-11ec-2e07-35cd27f732bd
hₜ(x => x0)

# ╔═╡ 2c99e368-53a2-11ec-2673-bf0aafe024ad
md"""## Trigonometry
"""

# ╔═╡ 2c99e3fe-53a2-11ec-3b7b-e36acb494e80
md"""Many maximization and minimization problems involve triangles, which in turn use trigonometry in their description. Here is an example, the "ladder corner problem." (There are many other [ladder](http://www.mathematische-basteleien.de/ladder.htm) problems.)
"""

# ╔═╡ 2c99e458-53a2-11ec-245b-8fa7d0944586
md"""A ladder is to be moved through a two-dimensional hallway which has a bend and gets narrower after the bend. The hallway is 8 feet wide then 5 feet wide. What is the longest such ladder that can be navigated around the corner?
"""

# ╔═╡ 2c99e522-53a2-11ec-3ac0-a77a6c6b1815
md"""The figure shows a ladder of length $l_1 + l_2$ that got stuck - it was too long.
"""

# ╔═╡ 2c9a0384-53a2-11ec-1616-c9469a0cbdc6
let
	p = plot([0, 0, 15], [15, 0, 0], color=:blue, legend=false)
	plot!(p, [5, 5, 15], [15, 8, 8], color=:blue)
	plot!(p, [0,14.53402874075368], [12.1954981558864, 0], linewidth=3)
	plot!(p, [0,5], [8,8], color=:orange)
	plot!(p, [5,5], [0,8], color=:orange)
	annotate!(p, [(13, 1/2, "θ"),
	              (2.5, 11, "l2"), (10, 5, "l1"), (2.5, 7.0, "l2 * cos(θ)"),
		      (5.1, 5, "l1 * sin(θ)")])
end

# ╔═╡ 2c9a0456-53a2-11ec-0dc1-570ea5167a1a
md"""We approach this problem in reverse. It is easy to see when a ladder is too long. It gets stuck at some angle $\theta$. So for each $\theta$ we find that ladder length that is just too long. Then we find the minimum length of all these ladders that are too long. If a ladder is this length or more it will get stuck for some angle. However, if it is less than this length it will not get stuck. So to maximize a ladder length, we minimize a different function. Neat.
"""

# ╔═╡ 2c9a0474-53a2-11ec-3e81-6d502e9ec57b
md"""Now, to find the length $l = l_1 + l_2$ as a function of $\theta$.
"""

# ╔═╡ 2c9a04d8-53a2-11ec-1c2d-a78dec067d50
md"""We need to brush off our trigonometry, in particular right triangle trigonometry. We see from the figure that $l_1$ is the hypotenuse of a right triangle with opposite side $8$ and $l_2$ is the hypotenuse of a right triangle with adjacent side $5$. So, $8/l_1 = \sin\theta$ and $5/l_2 = \cos\theta$.
"""

# ╔═╡ 2c9a0512-53a2-11ec-2fbc-e5d013f99968
md"""That is, we have
"""

# ╔═╡ 2c9a0c4e-53a2-11ec-0dad-03e89b8e2a77
begin
	l(l1, l2) = l1 + l2
	l1(t) = 8/sin(t)
	l2(t) = 5/cos(t)
	
	l(t) = l(l1(t), l2(t))		# or simply l(t) = 8/sin(t) + 5/cos(t)
end

# ╔═╡ 2c9a0c8c-53a2-11ec-1fab-eb797b8c4aaa
md"""Our goal is to minimize this function for all angles between $0$ and $90$ degrees, or $0$ and $\pi/2$ radians.
"""

# ╔═╡ 2c9a0ce4-53a2-11ec-248d-4d66d8488946
md"""This is not a continuous function on a closed interval - it is undefined at the endpoints. That being said, a quick plot will convince us that the minimum occurs at a critical point and there is only one critical point in $(0, \pi/2)$.
"""

# ╔═╡ 2c9a29f4-53a2-11ec-2395-edea73e9c48f
begin
	delta = 0.2
	plot(l, delta, pi/2 - delta)
end

# ╔═╡ 2c9a2a8a-53a2-11ec-31df-7da718b0ea55
md"""The minimum occurs between 0.5 and 1.0 radians, a bracket for the derivative. Here we find $x$ and the minimum value:
"""

# ╔═╡ 2c9a3110-53a2-11ec-30cb-03f94535fef3
let
	x = find_zero(l', (0.5, 1.0))
	x, l(x)
end

# ╔═╡ 2c9a317e-53a2-11ec-2206-e147d8886ba7
md"""That is, any ladder less than this length can get around the hallway.
"""

# ╔═╡ 2c9a3200-53a2-11ec-3d93-d349132543a4
md"""## Rate times time
"""

# ╔═╡ 2c9a32a0-53a2-11ec-31a7-75c89709f136
md"""Ethan Hunt, a top secret spy, has a mission to chase a bad guy. Here is what we know:
"""

# ╔═╡ 2c9a3444-53a2-11ec-350b-af57b93d53f1
md"""  * Ethan likes to run. He can run at 10 miles per hour.
  * He can drive a car - usually some concept car by BMW - at 30 miles per hour, but only on the road.
"""

# ╔═╡ 2c9a344e-53a2-11ec-258a-5721ca8f60c3
md"""For his mission, he needs to go 10 miles west and 5 miles north. He can do this by:
"""

# ╔═╡ 2c9a350c-53a2-11ec-3276-636541d26170
md"""  * just driving 10 miles west then 5 miles north, or
  * just running the diagonal distance, or
  * driving $0 < x < 10$ miles west, then running on the diagonal
"""

# ╔═╡ 2c9a3570-53a2-11ec-2544-878393780136
md"""A quick analysis says:
"""

# ╔═╡ 2c9a36c4-53a2-11ec-04a4-51a2ee5caede
md"""  * It would take $(10+5)/30$ hours to just drive
  * It would take $\sqrt{10^2 + 5^2}/10$ hours to just run
"""

# ╔═╡ 2c9a36f6-53a2-11ec-0095-1da103559fb0
md"""Now, if he drives $x$ miles west ($0 < x < 10$) he would run an amount given by the hypotenuse of a triangle with lengths $5$ and $10-x$. His time driving would be $x/30$ and his time running would be $\sqrt{5^2+(10-x)^2}/10$ for a total of:
"""

# ╔═╡ 2c9a376e-53a2-11ec-21cb-6bfd87daa140
md"""```math
T(x) = x/30 + \sqrt{5^2 + (10-x)^2}/10, \quad 0 < x < 10
```
"""

# ╔═╡ 2c9a37bc-53a2-11ec-1abe-45e524708b85
md"""With the endpoints given by $T(0) = \sqrt{10^2 + 5^2}/10$ and $T(10) = (10 + 5)/30$.
"""

# ╔═╡ 2c9a3818-53a2-11ec-0209-8b06e72fa6fd
md"""Let's plot $T(x)$ over the interval $(0,10)$ and look:
"""

# ╔═╡ 2c9a4a6a-53a2-11ec-066f-bfe850e4a36a
T(x) = x/30 + sqrt(5^2 + (10-x)^2)/10

# ╔═╡ 2c9a6504-53a2-11ec-14c2-ddadcffab47e
plot(T, 0, 10)

# ╔═╡ 2c9a6536-53a2-11ec-2fad-212c2671a6ba
md"""The minimum happens way out near 8. We zoom in a bit:
"""

# ╔═╡ 2c9a6f86-53a2-11ec-21e4-79a78126c73d
plot(T, 7, 9)

# ╔═╡ 2c9a7058-53a2-11ec-0f29-3d2a8f4034e0
md"""It appears to be around 8.3. We now use `find_zero` to refine our guess at the critical point using $[7,9]$:
"""

# ╔═╡ 2c9a9f42-53a2-11ec-0b82-27a1cf3ccbed
α = find_zero(T', (7, 9))

# ╔═╡ 2c9a9fba-53a2-11ec-3f9e-b1b348f9bc6d
md"""Okay, got it. Around 8.23. So is  our minimum time
"""

# ╔═╡ 2c9aa186-53a2-11ec-2715-6bdbf9948cde
T(α)

# ╔═╡ 2c9aa1e0-53a2-11ec-0565-31b4e6908956
md"""We know this is a relative minimum, but not that it is the global minimum over the closed time interlal. For that we must also check the endpoints:
"""

# ╔═╡ 2c9aaaaa-53a2-11ec-2508-d97aeb313120
sqrt(10^2 + 5^2)/10, T(α), (10+5)/30

# ╔═╡ 2c9aab2c-53a2-11ec-3b65-c77d7b451c72
md"""Ahh, we see that $T(x)$ is not continuous on $[0, 10]$, as it jumps at $x=10$ down to an even smaller amount of $1/2$.  It may not look as impressive as a miles-long sprint, but Mr. Hunt is advised by Benji to drive the whole way.
"""

# ╔═╡ 2c9aaba4-53a2-11ec-2658-9b1540cae82f
md"""## Rate times time ... the origin story
"""

# ╔═╡ 2c9ab11c-53a2-11ec-3662-970c17e7b9f9
let
	### {{{lhopital_43}}}
	
	imgfile = "figures/fcarc-may2016-fig43-250.gif"
	caption = L"""
	
	Image number $43$ from l'Hospital's calculus book (the first). A
	traveler leaving location $C$ to go to location $F$ must cross two
	regions separated by the straight line $AEB$. We suppose that in the
	region on the side of $C$, he covers distance $a$ in time $c$, and
	that on the other, on the side of $F$, distance $b$ in the same time
	$c$. We ask through which point $E$ on the line $AEB$ he should pass,
	so as to take the least possible time to get from $C$ to $F$? (From
	http://www.ams.org/samplings/feature-column/fc-2016-05.)
	
	
	"""
	#ImageFile(imgfile, caption)
end

# ╔═╡ 2ca52130-53a2-11ec-2891-03d5a25286f6
md"""![Image number $43$ from l'Hospital's calculus book (the first). A traveler leaving location $C$ to go to location $F$ must cross two regions separated by the straight line $AEB$. We suppose that in the region on the side of $C$, he covers distance $a$ in time $c$, and that on the other, on the side of $F$, distance $b$ in the same time $c$. We ask through which point $E$ on the line $AEB$ he should pass, so as to take the least possible time to get from $C$ to $F$? (From http://www.ams.org/samplings/feature-column/fc-2016-05.)](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/fcarc-may2016-fig43-250.gif)
"""

# ╔═╡ 2ca5226e-53a2-11ec-0bb7-292eccc1bd4b
md"""The last example is a modern day illustration of a problem of calculus dating back to l'Hospital. His parameterization is a bit different. Let's change his by taking two points $(0, a)$ and $(L,-b)$, with $a,b,L$ positive values. Above the $x$ axis travel happens at rate $r_0$, and below, travel happens at rate $r_1$, again, both positive. What value $x$ in $[0,L]$ will minimize the total travel time?
"""

# ╔═╡ 2ca52304-53a2-11ec-026e-05ee0e1ab8c4
md"""We approach this symbolically with `SymPy`:
"""

# ╔═╡ 2ca5473a-53a2-11ec-0240-8fcf54774058
begin
	@syms a::positive b::positive L::positive r0::positive r1::positive
	
	d0 = sqrt(x^2 + a^2)
	d1 = sqrt((L-x)^2 + b^2)
	
	t = d0/r0 + d1/r1   # time = distance/rate
	dt = diff(t, x)     # look for critical points
end

# ╔═╡ 2ca54796-53a2-11ec-2dde-a116f3f16e7a
md"""The answer will occur at a critical point or an endpoint, either $x=0$ or $x=L$.
"""

# ╔═╡ 2ca5487a-53a2-11ec-3b16-2778a1a437da
md"""The structure of `dt` is too complicated for simply calling `solve` to find the critical points. Instead we help `SymPy` out a bit. We are solving an equation of the form $a/b + c/d = 0$. These solutions will also be solutions of $(a/b)^2 - (c/d)^2=0$ or even $a^2d^2 - c^2b^2 = 0$. This follows as solutions to $u+v=0$, also solve $(u+v)\cdot(u-v)=0$, or $u^2 - v^2=0$. Setting $u=a/b$ and $v=c/d$ completes the comparison.
"""

# ╔═╡ 2ca54898-53a2-11ec-17c2-d96b839b306d
md"""We can get these terms - $a$, $b$, $c$, and $d$ - as follows:
"""

# ╔═╡ 2ca54ed8-53a2-11ec-2042-f7a308cc0e24
t1, t2 = dt.args # the `args` property returns the arguments to the outer function (+ in this case)

# ╔═╡ 2ca54fb4-53a2-11ec-2c2a-eb193b17ad8b
md"""The equivalent of $a^2d^2 - c^2 b^2$ is found using the generic functions `numerator` and `denominator` to access the numerator and denominator of the fractions:
"""

# ╔═╡ 2ca57174-53a2-11ec-3939-d5d02cfe5f07
ex = numerator(t1^2)*denominator(t2^2) - denominator(t1^2)*numerator(t2^2)

# ╔═╡ 2ca571d8-53a2-11ec-0b6d-49e6cee47f50
md"""This is a polynomial in the `x` variable of degree $4$, as seen here where the `sympy.Poly` function is used to identify the symbols of the polynomial from the parameters:
"""

# ╔═╡ 2ca5912c-53a2-11ec-2173-5175c864562b
begin
	p = sympy.Poly(ex, x) # a0 + a1⋅x + a2⋅x^2 + a3⋅x^3 + a4⋅x^4
	p.coeffs()
end

# ╔═╡ 2ca5928a-53a2-11ec-3839-8f42264af328
md"""Fourth degree polynomials can be solved. The critical points of the original equation will be among the 4 solutions given. However, the result is complicated.  The [article](http://www.ams.org/samplings/feature-column/fc-2016-05) – from which the figure came – states that "In today's textbooks the problem, usually involving a river, involves walking along one bank and then swimming across; this corresponds to setting $g=0$ in l'Hospital's example, and leads to a quadratic equation." Let's see that case, which we can get in our notation by taking $b=0$:
"""

# ╔═╡ 2ca597e4-53a2-11ec-260f-097a1aaa486a
begin
	q = ex(b=>0)
	factor(q)
end

# ╔═╡ 2ca5987a-53a2-11ec-00d2-d11afbbd8b0a
md"""We see two terms: one with $x=L$ and another quadratic. For the simple case $r_0=r_1$, a straight line is the best solution, and this corresponds to $x=L$, which is clear from the formula above, as we only have one solution to the following:
"""

# ╔═╡ 2ca5bf1c-53a2-11ec-28b1-1d29b700228d
solve(q(r1=>r0), x)

# ╔═╡ 2ca5bfbc-53a2-11ec-1ed0-d5758cb66479
md"""Well, not so fast. We need to check the other endpoint, $x=0$:
"""

# ╔═╡ 2ca5c7b4-53a2-11ec-34bb-f500c7ae6a2c
begin
	ta = t(b=>0, r1=>r0)
	ta(x=>0), ta(x=>L)
end

# ╔═╡ 2ca5c8cc-53a2-11ec-10c5-1b4c872cb310
md"""The value at $x=L$ is smaller, as $L^2 + a^2 \leq (L+a)^2$. (Well, that was a bit pedantic. The travel rates being identical means the fastest path will also be the shortest path and that is clearly $x=L$ and not $x=0$.)
"""

# ╔═╡ 2ca5c8ea-53a2-11ec-00bf-9743d301fea5
md"""Now, if, say, travel above the line is half as slow as travel along, then $2r_0 = r_1$, and the critical points will be:
"""

# ╔═╡ 2ca5e3f2-53a2-11ec-307b-fb61b5cd59af
out = solve(q(r1 => 2r0), x)

# ╔═╡ 2ca5e528-53a2-11ec-20f7-67e6665edf36
md"""It is hard to tell which would minimize time without more work. To check a case ($a=1, L=2, r_0=1$) we might have
"""

# ╔═╡ 2ca6072e-53a2-11ec-1a79-67d008b6f9e6
x_straight = t(r1 =>2r0, b=>0, x=>out[1], a=>1, L=>2, r0 => 1)  # for x=L

# ╔═╡ 2ca6080a-53a2-11ec-335f-fba4c0d4493a
md"""Compared to the smaller ($x=\sqrt{3}a/3$):
"""

# ╔═╡ 2ca66340-53a2-11ec-08b4-050441b13fe5
x_angle = t(r1 =>2r0, b=>0, x=>out[2], a=>1, L=>2, r0 => 1)

# ╔═╡ 2ca663fe-53a2-11ec-3f63-0b8a306a1fe3
md"""What about $x=0$?
"""

# ╔═╡ 2ca68622-53a2-11ec-17c4-eb395bc64e6a
x_bent = t(r1 =>2r0, b=>0, x=>0, a=>1, L=>2, r0 => 1)

# ╔═╡ 2ca68690-53a2-11ec-04ad-f7600a407d49
md"""The value of $x=\sqrt{3}a/3$ minimizes time:
"""

# ╔═╡ 2ca68898-53a2-11ec-2143-c96de894449e
min(x_straight, x_angle, x_bent)

# ╔═╡ 2ca6897e-53a2-11ec-2c3a-09488832c6b4
md"""The traveler in this case is advised to head to the $x$ axis at $x=\sqrt{3}a/3$  and then travel along the $x$ axis.
"""

# ╔═╡ 2ca6899c-53a2-11ec-002d-2113153a4559
md"""Will this approach always be true?  Consider different parameters, say we switch the values of $a$ and $L$ so $a > L$:
"""

# ╔═╡ 2ca6b5b6-53a2-11ec-1d77-ad9bc9aac487
begin
	pts = [0, out...]
	m,i = findmin([t(r1 =>2r0, b=>0, x=>u, a=>2, L=>1, r0 => 1) for u in pts]) # min, index
	m, pts[i]
end

# ╔═╡ 2ca6b656-53a2-11ec-3415-2deeed081121
md"""Here traveling directly to the point $(L,0)$ is fastest. Though travel is slower, the route is more direct and there is no time saved by taking the longer route with faster travel for part of it.
"""

# ╔═╡ 2ca6b672-53a2-11ec-1163-cf846bbb5347
md"""## Unbounded domains
"""

# ╔═╡ 2ca6b6ce-53a2-11ec-2f67-cdcf00eddf9d
md"""Maximize the function $xe^{-(1/2) x^2}$ over the interval $[0, \infty)$.
"""

# ╔═╡ 2ca6ba70-53a2-11ec-127b-d118cc2363a4
md"""Here the extreme value theorem doesn't technically apply, as we don't have a closed interval. However, **if** we can eliminate the endpoints as candidates, then we should be able to convince ourselves the maximum must occur at a critical point of $f(x)$. (If not, then convince yourself for all sufficiently large $M$ the maximum over $[0,M]$ occurs at a critical point, not an endpoint. Then let $M$ go to infinity.)
"""

# ╔═╡ 2ca6bb1c-53a2-11ec-1bcf-2d8e72b9a774
md"""So to approach this problem we first graph it over a wide interval.
"""

# ╔═╡ 2ca6d744-53a2-11ec-130e-73337547ac48
begin
	f(x) = x * exp(-x^2)
	plot(f, 0, 100)
end

# ╔═╡ 2ca6d79e-53a2-11ec-3ed5-edfe301b60f0
md"""Clearly the action is nearer to 1 than 100. We try graphing the derivative near that area:
"""

# ╔═╡ 2ca6daac-53a2-11ec-3715-b1fce3ced96c
plot(f', 0, 5)

# ╔═╡ 2ca6db36-53a2-11ec-241b-6bb7a15d82a5
md"""This shows the value of interest near $0.7$ for a critical point. We use `find_zero` with $[0,1]$ as a bracket
"""

# ╔═╡ 2ca6dfc8-53a2-11ec-2747-153b1c78106c
c = find_zero(f', (0, 1))

# ╔═╡ 2ca6e022-53a2-11ec-2015-854e81684a17
md"""The maximum is then at
"""

# ╔═╡ 2ca6e25c-53a2-11ec-3c55-43b8b802623f
f(c)

# ╔═╡ 2ca6e2f2-53a2-11ec-050f-6f95487b4585
md"""### Minimize the surface area of a can
"""

# ╔═╡ 2ca6e36a-53a2-11ec-27cd-67a86f9e109d
md"""For a more applied problem of this type (infinite domain), consider a can of some soft drink that is to contain 355ml which is 355 cubic centimeters.  We use metric units, as the relationship between volume (cubic centimeters) and fluid amount (ml) is clear.  A can to hold this amount is produced in the shape of cylinder with radius $r$ and height $h$. The materials involved give the surface area, which would be:
"""

# ╔═╡ 2ca6e392-53a2-11ec-1ae0-c50cc3b93185
md"""```math
SA = h \cdot 2\pi r + 2 \cdot \pi r^2
```
"""

# ╔═╡ 2ca6fa94-53a2-11ec-211f-730c1c55d251
md"""The volume satisfies:
"""

# ╔═╡ 2ca6fb48-53a2-11ec-1003-0fad6a425bfe
md"""```math
V = 355 = h \cdot \pi r^2
```
"""

# ╔═╡ 2ca6fc1a-53a2-11ec-1b24-9b0ebcab6579
md"""Find the values of $r$ and $h$ which minimize the surface area.
"""

# ╔═╡ 2ca6fc60-53a2-11ec-2043-61a736d87ab0
md"""First the surface area in both variables is given by
"""

# ╔═╡ 2ca71164-53a2-11ec-17f3-35a483e72f76
SA(h, r) = h * 2pi * r + 2pi * r^2

# ╔═╡ 2ca727bc-53a2-11ec-2cd9-9d7cebd9d9fa
md"""Solving from the constraint on the volume for `h` in terms of `r` yields:
"""

# ╔═╡ 2ca72d5c-53a2-11ec-33c9-15306319552b
canheight(r) = 355 / (pi * r^2)

# ╔═╡ 2ca72dd4-53a2-11ec-0055-5f02d0e6ccb4
md"""Composing gives a function of `r` alone:
"""

# ╔═╡ 2ca74562-53a2-11ec-1261-b31a1d261264
SA(r) = SA(canheight(r), r)

# ╔═╡ 2ca745b2-53a2-11ec-3654-a39ce79b3168
md"""This is minimized subject to the constraint that $r \geq 0$. A quick glance shows that as $r$ gets close to $0$, the can must get infinitely tall to contain that fixed volume, and would have infinite surface area as the $1/r^2$ in the first term implies. On the other hand, as $r$ goes to infinity, the height must go to 0 to make a really flat can. Again, we would have infinite surface area, as the $r^2$ term at the end indicates. With this observation, we can rule out the endpoints as possible minima, so any minima must occur at a critical point.
"""

# ╔═╡ 2ca745bc-53a2-11ec-08ab-21de334235c7
md"""We start by making a graph, making an educated guess that the answer is somewhere near a real life answer, or around 3-5 cms in radius:
"""

# ╔═╡ 2ca74882-53a2-11ec-2414-238a3f6e99ca
plot(SA, 2, 10)

# ╔═╡ 2ca748be-53a2-11ec-08d0-c7aee5bea700
md"""The minimum looks to be around $4$cm and is clearly between $2$cm and $6$cm. We can use `find_zero` to zero in on the value of the critical point:
"""

# ╔═╡ 2ca74e04-53a2-11ec-236a-67cde9ae3b50
rₛₐ = find_zero(SA', (2, 6))

# ╔═╡ 2ca74ecc-53a2-11ec-3f8e-9750fbee6afa
md"""Okay, $3.837...$ is our answer for $r$. Use this to get $h$:
"""

# ╔═╡ 2ca750b6-53a2-11ec-0c25-d9b43936cf20
canheight(rₛₐ)

# ╔═╡ 2ca75112-53a2-11ec-283c-65ed688b740f
md"""This produces a can which is about square in profile. This is not how most cans look though. Perhaps our model is too simple, or the cans are optimized for some other purpose than minimizing materials.
"""

# ╔═╡ 2ca75138-53a2-11ec-3150-431d8d361ff2
md"""## Questions
"""

# ╔═╡ 2ca75304-53a2-11ec-234e-0314b876ed46
md"""###### Question
"""

# ╔═╡ 2ca7532c-53a2-11ec-0b0a-a1920623b8d6
md"""A geometric figure has area given in terms of two measurements by $A=\pi a b$ and perimeter $P = \pi (a + b)$. If the perimeter is fixed to be 20 units long, what is the maximal area the figure can be?
"""

# ╔═╡ 2ca76c22-53a2-11ec-3309-2d6daecf7a2b
let
	A(a,b) = pi*a*b
	P = 20
	b1(a) = 20/pi - a
	A(a) = A(a, b1(a))
	x = find_zero(A', (0, 10))
	val = A(x)
	numericq(val)
end

# ╔═╡ 2ca76c4a-53a2-11ec-2d54-2577fda748be
md"""###### Question
"""

# ╔═╡ 2ca76c7c-53a2-11ec-329d-09051f8c9328
md"""A geometric figure has area given in terms of two measurements by $A=\pi a b$ and perimeter $P=\pi \cdot \sqrt{a^2 + b^2}/2$. If the perimeter is 20 units long, what is the maximal area?
"""

# ╔═╡ 2ca77168-53a2-11ec-3651-5de6194add6e
let
	A(a,b) = pi*a*b
	P = 20
	b1(a) = sqrt((P*2/pi)^2 - a^2)
	A(a) = A(a, b1(a))
	x = find_zero(A', (0, 10))
	val = A(x)
	numericq(val)
end

# ╔═╡ 2ca771d8-53a2-11ec-07fc-b527471cf9a3
md"""###### Question
"""

# ╔═╡ 2ca78536-53a2-11ec-2d6f-c16af1e0c76a
md"""A rancher with 10 meters of fence wishes to make a pen adjacent to an existing fence. The pen will be a rectangle with one edge using the existing fence. Say that has length $x$, then $10 = 2y + x$, with $y$ the other dimension of the pen. What is the maximum area that can be made?
"""

# ╔═╡ 2ca78cde-53a2-11ec-21b3-4bfec2f857d8
let
	Ar(y) = (10-2y)*y;
	val = Ar(find_zero(Ar',  5))
	numericq(val, 1e-3)
end

# ╔═╡ 2ca78d1a-53a2-11ec-299c-23fd5a284fb0
md"""Is there "symmetry" in the answer between $x$ and $y$?
"""

# ╔═╡ 2ca79080-53a2-11ec-39ad-a54d0fff100c
let
	yesnoq("no")
end

# ╔═╡ 2ca790ee-53a2-11ec-13e6-7dc002cf655c
md"""What is you were do do two pens like this back to back, then the answer would involve a rectangle. Is there symmetry in the answer now?
"""

# ╔═╡ 2ca7a9f0-53a2-11ec-05f8-593149d3482c
let
	yesnoq("yes")
end

# ╔═╡ 2ca7aac0-53a2-11ec-0068-2316afd545d2
md"""###### Question
"""

# ╔═╡ 2ca7c168-53a2-11ec-0a05-4d8ab255ead6
md"""A rectangle of sides $w$ and $h$ has fixed area $20$. What is the *smallest* perimeter it can have?
"""

# ╔═╡ 2ca7df54-53a2-11ec-3923-d593d1e9721e
let
	Prim(x,y) = 2x + 2y
	Prim(x) = Prim(x, 20/x)
	xstar = find_zero(Prim', 5)
	val = Prim(xstar)
	numericq(val)
end

# ╔═╡ 2ca7dfd6-53a2-11ec-01cd-4f0d99504f8f
md"""###### Question
"""

# ╔═╡ 2ca7e080-53a2-11ec-34fe-8155157a9024
md"""A rectangle of sides $w$ and $h$ has fixed area $20$. What is the *largest* perimeter it can have?
"""

# ╔═╡ 2ca7e864-53a2-11ec-351b-2d512c7cacd9
let
	choices = [
	"It can be infinite",
	"It is also 20",
	"``17.888``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 2ca7e8e6-53a2-11ec-1fbf-4f49246d5453
md"""###### Question
"""

# ╔═╡ 2ca7e954-53a2-11ec-2137-cb2860842645
md"""A rain gutter is constructed from a 30" wide sheet of tin by bending it into thirds. If the sides are bent 90 degrees, then the cross-sectional area would be $100 = 10^2$. This is not the largest possible amount. For example, if the sides are bent by 45 degrees, the cross sectional area is:
"""

# ╔═╡ 2ca8207c-53a2-11ec-2cb5-0fde7024f49f
let
	2 * (1/2 * 10*cos(pi/4) * 10 * sin(pi/4)) + 10*sin(pi/4) * 10
end

# ╔═╡ 2ca820fe-53a2-11ec-3f72-a7fbb49b30e1
md"""Find a value in degrees that gives the maximum. (The first task is to write the area in terms of $\theta$.
"""

# ╔═╡ 2ca857e0-53a2-11ec-192b-df92b5329ad9
let
	function Ar(t)
		 opp = 10 * sin(t)
		 adj = 10 * cos(t)
		 2 * opp * adj/2 + opp * 10
	end
	t = find_zero(Ar', pi/4);	## Has issues with order=8 algorithm, tol > 1e-14 is needed
	val = t * 180/pi;
	numericq(val, 1e-3)
end

# ╔═╡ 2ca8586e-53a2-11ec-3bec-fdee9ec3ee4a
md"""###### Question Non-Norman windows
"""

# ╔═╡ 2ca858b2-53a2-11ec-3401-597fab087589
md"""Suppose our new "Norman" window has half circular tops at the top and bottom? If the perimeter is fixed at $20$ and the dimensions of the rectangle are $x$ for the width and $y$ for the height.
"""

# ╔═╡ 2ca8590c-53a2-11ec-3580-9dcd4e176eea
md"""What is the value of $y$ that maximizes the area?
"""

# ╔═╡ 2ca85daa-53a2-11ec-1d6b-7d49ea46b5d1
let
	P = 20
	A(x,y) = x*y + pi * (x/2)^2
	y(x) = (P - pi*x)/2 # P = 2y + 2pi*x/2
	A(x) = A(x,y(x))
	x0 = find_zero(D(A), (0, 10))
	val = y(x0)
	numericq(val) # 0
end

# ╔═╡ 2ca87342-53a2-11ec-185f-7fbc62075dde
md"""###### Question (Thanks https://www.math.ucdavis.edu/~kouba)
"""

# ╔═╡ 2ca873c6-53a2-11ec-3fba-4387478f7c8a
md"""A movie screen projects on a wall 20 feet high beginning 10 feet above the floor.  This figure shows $\theta$ for $x=30$:
"""

# ╔═╡ 2ca88dbe-53a2-11ec-1b8f-07fb3414bf4e
let
	p = plot([0, 30,30], [0,0,10], xlim=(0, 32), color=:blue, legend=false)
	plot!(p, [30, 30], [10, 30], color=:blue, linewidth=4)
	plot!(p, [0, 30,30,0], [0,10,30,0], color=:orange)
	annotate!(p, [(x,y,l) for (x,y,l) in zip([15, 5, 31, 31], [1.5, 3.5, 5, 20], ["x=30", "θ", "10", "20"])])
end

# ╔═╡ 2ca88e22-53a2-11ec-1814-d7a54dfeb6eb
md"""What value of $x$ gives the largest angle $\theta$? (In degrees.)
"""

# ╔═╡ 2ca897a0-53a2-11ec-24e4-f70db64c24db
let
	theta(x) = atan(30/x) - atan(10/x)
	val = find_zero(D(theta), 20); ## careful where one starts
	val = theta(val) * 180/pi
	numericq(val, 1e-1)
end

# ╔═╡ 2ca897c8-53a2-11ec-1428-81e3ab060f58
md"""###### Question
"""

# ╔═╡ 2ca8987c-53a2-11ec-2cdc-1bd0da57dac2
md"""A maximum likelihood estimator is a value derived by maximizing a function. For example, if
"""

# ╔═╡ 2ca8a24a-53a2-11ec-2241-856a586b2b99
Likhood(t) = t^3 * exp(-3t) * exp(-2t) * exp(-4t) ## 0 <= t <= 10

# ╔═╡ 2ca8a298-53a2-11ec-20a6-b194c6c8581a
md"""Then `Likhood(t)` is continuous and has single peak, so the maximum occurs at the lone critical point. It turns out that this problem is bit sensitive to an initial condition, so we bracket
"""

# ╔═╡ 2ca8bee2-53a2-11ec-3165-f5770aa5b307
find_zero(Likhood',  (0.1, 0.5))

# ╔═╡ 2ca8bf96-53a2-11ec-39ea-7f9aa56312e0
md"""Now if $Likhood(t) = \exp(-3t) \cdot \exp(-2t) \cdot \exp(-4t), \quad 0 \leq t \leq 10$, by graphing, explain why the same approach won't work:
"""

# ╔═╡ 2ca8c874-53a2-11ec-3d07-e575379a3650
let
	choices=["It does work and the answer is x = 2.27...",
		 L" $Likhood(t)$ is not continuous on $0$ to $10$",
	         L" $Likhood(t)$ takes its maximum at a boundary point - not a critical point"];
	ans = 3;
	radioq(choices, ans)
end

# ╔═╡ 2ca8c8fe-53a2-11ec-3d8b-f93d2c844d1d
md"""##### Question
"""

# ╔═╡ 2ca8c9c8-53a2-11ec-2951-35deb4c5c54a
md"""Let $x_1$, $x_2$, $x_n$ be a set of unspecified numbers in a data set. Form the expression $s(x) = (x-x_1)^2 + \cdots (x-x_n)^2$. What is the smallest this can be (in $x$)?
"""

# ╔═╡ 2ca8c9f0-53a2-11ec-2afb-adc4910ce5d1
md"""We approach this using `SymPy` and $n=10$
"""

# ╔═╡ 2ca8ca7c-53a2-11ec-01ca-9f476e88bd78
md"""```
@syms s xs[1:10]
s(x) = sum((x-xi)^2 for xi in xs)
cps = solve(diff(s(x), x), x)
```"""

# ╔═╡ 2ca8cae0-53a2-11ec-169b-8d603e45fc54
md"""Run the above code. Baseed on the critical points found, what do you guess will be the minimum value in terms of the values $x_1$, $x_2, \dots$?
"""

# ╔═╡ 2ca8e796-53a2-11ec-2631-29707438163b
let
	choices=[
	"The mean, or average, of the values",
	"The median, or middle number, of the values",
	L"The square roots of the values squared, $(x_1^2 + \cdots x_n^2)^2$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 2ca8e82e-53a2-11ec-0ada-add78b55247d
md"""###### Question
"""

# ╔═╡ 2ca8e89a-53a2-11ec-0798-3154c3a5cf6c
md"""Minimize the function $f(x) = 2x + 3/x$ over $(0, \infty)$.
"""

# ╔═╡ 2ca8f434-53a2-11ec-2a7e-8baad932c605
let
	f(x) = 2x + 3/x;
	val = find_zero(f', 1);
	numericq(val, 1e-3)
end

# ╔═╡ 2ca8f696-53a2-11ec-0c7a-2bbdc73cf515
md"""###### Question
"""

# ╔═╡ 2ca8f6f0-53a2-11ec-1988-13346fbf2b96
md"""Of all rectangles of area 4, find the one with smallest perimeter. What is the perimeter?
"""

# ╔═╡ 2ca9030c-53a2-11ec-3ed8-01516b4e64b7
let
	# 4 = xy
	Prim(x) = 2x + 2*(4/x);
	val = find_zero(D(Prim), 1);
	numericq(Prim(val), 1e-3)		## a square!
end

# ╔═╡ 2ca9032a-53a2-11ec-1745-254d36a0a7e1
md"""###### Question
"""

# ╔═╡ 2ca90656-53a2-11ec-2a15-a9422c1cbf12
md"""A running track is in the shape of two straight aways and two half circles. The total distance (perimeter) is 400 meters. Suppose $w$ is the width (twice the radius of the circles) and $h$ is the height. What dimensions minimize the sum $w + h$?
"""

# ╔═╡ 2ca907be-53a2-11ec-3c91-29762594e6c6
md"""You have $P(w, h) = 2\pi \cdot (w/2) + 2\cdot(h-w)$.
"""

# ╔═╡ 2ca90e88-53a2-11ec-1ea5-2365cc618c81
let
	Ar(w,h) = w + h
	h(w) = (400 - 2pi*w/2 + 2w) / 2
	Ar(w) = Ar(w, h(w)) ## linear
	val = Ar(0)
	numericq(val)
end

# ╔═╡ 2ca91180-53a2-11ec-3fb3-173eee8713c4
md"""###### Question
"""

# ╔═╡ 2ca911da-53a2-11ec-1d33-9f79cac70e1b
md"""A cell phone manufacturer wishes to make a rectangular phone with total surface area of 12,000 $mm^2$ and maximal screen area. The screen is surrounded by bezels with sizes of 8$mm$ on the long sides and 32$mm$ on the short sides. (So, for example, the screen width is shorter by $2\cdot 8$ mm than the phone width.)
"""

# ╔═╡ 2ca9299a-53a2-11ec-2772-59bc63e18c3a
md"""What are the dimensions (width and height) that allow the maximum screen area?
"""

# ╔═╡ 2ca929ae-53a2-11ec-0941-891555ad893c
md"""The width is:
"""

# ╔═╡ 2ca930f4-53a2-11ec-1beb-b38d8d7943ac
let
	#A = w*h = 12000
	w(h) = 12_000 / h
	S(w, h) = (w- 2*8) * (h - 2*32)
	S(h) = S(w(h), h)
	hstar =find_zero(D(S), 500)
	wstar = w(hstar)
	numericq(wstar)
end

# ╔═╡ 2ca93110-53a2-11ec-2a2e-d10fefdb0446
md"""The height is?
"""

# ╔═╡ 2ca9393a-53a2-11ec-343c-3f41a4f4044c
let
	w(h) = 12_000 / h
	S(w, h) = (w- 2*8) * (h - 2*32)
	S(h) = S(w(h), h)
	hstar =find_zero(D(S), 500)
	numericq(hstar)
end

# ╔═╡ 2ca93d2c-53a2-11ec-1e82-89b624835797
md"""###### Question
"""

# ╔═╡ 2ca93d5e-53a2-11ec-2c89-35fb7aade96d
md"""Find the value $x > 0$ which minimizes the distance from the graph of $f(x) = \log_e(x) - x$ to the origin $(0,0)$.
"""

# ╔═╡ 2ca94ab2-53a2-11ec-1207-4d7f60194891
let
	f(x) = log(x) - x
	p = plot(f, 0.2, 2, ylim=(-2,0.25), legend=false, linewidth=3)
	plot!(p, [0,0], [-2, 0.25], color=:blue)
	plot!(p, [0,2],[0,0], color=:blue)
	xs = [0,1]; ys = [0, f(1)]
	scatter!(p, xs,ys, color=:orange)
	plot!(p, xs, ys, color=:orange, linewidth=3)
	annotate!(p, [(.75, f(.5)/2, "d = $(round(sqrt(.5^2 + f(.5)^2), digits=2))")])
	p
end

# ╔═╡ 2ca971fc-53a2-11ec-17ef-eb40c7f81e7a
let
	d2(x) = sqrt((0-x)^2 + (0 - f(x))^2)
	xstar = find_zero(D(d2), 1)
	val = d2(xstar)
	numericq(val)
end

# ╔═╡ 2ca9744c-53a2-11ec-1df9-cfabeb20c1f1
md"""###### Question
"""

# ╔═╡ 2ca97ec2-53a2-11ec-3691-bb1779a6979b
let
	### {{{lhopital_40}}}
	imgfile ="figures/fcarc-may2016-fig40-300.gif"
	caption = L"""
	
	Image number $40$ from l'Hospital's calculus book (the first calculus book). Among all the cones that can be inscribed in a sphere, determine which one has the largest lateral area. (From http://www.ams.org/samplings/feature-column/fc-2016-05)
	
	"""
	#ImageFile(imgfile, caption)
end

# ╔═╡ 2ca98106-53a2-11ec-049b-45fa81b62397
md"""![Image number ``40`` from l'Hospital's calculus book (the first calculus book). Among all the cones that can be inscribed in a sphere, determine which one has the largest lateral area. (From http://www.ams.org/samplings/feature-column/fc-2016-05)](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/fcarc-may2016-fig40-300.gif)
"""

# ╔═╡ 2ca982d2-53a2-11ec-2164-a922e8b4a58a
md"""The figure above poses a problem about cones in spheres, which can be reduced to a two-dimensional problem. Take a sphere of radius $r=1$, and imagine a secant line of length $l$ connecting $(-r, 0)$ to another point $(x,y)$ with $y>0$. Rotating that line around the $x$ axis produces a cone and its lateral surface is given by $SA=\pi \cdot y \cdot l$. Write $SA$ as a function of $x$ and solve.
"""

# ╔═╡ 2ca982e6-53a2-11ec-37be-3146150c3ccd
md"""The largest lateral surface area is:
"""

# ╔═╡ 2ca98a8e-53a2-11ec-0660-39dd9739c6bd
let
	r = 1
	SA(r,l) = pi * r * l
	y(x) = sqrt(1 - x^2)
	l(x) = sqrt((x-(-1))^2 +  y(x)^2)
	SA(x) = SA(y(x), l(x))
	cp = find_zero(SA', (-1/2, 1/2))
	val = SA(cp)
	numericq(val)
end

# ╔═╡ 2ca98ad4-53a2-11ec-0798-0b5972164066
md"""The surface area of a sphere of radius $1$ is $4\pi r^2 = 4 \pi$. This is how many times greater than that of the largest cone?
"""

# ╔═╡ 2ca992cc-53a2-11ec-382c-d1f4c397a2c7
let
	choices = ["exactly four times",
	L"exactly $\pi$ times",
	L"about $2.6$ times as big",
	"about the same"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 2ca99326-53a2-11ec-1490-811f0d32478e
md"""###### Question
"""

# ╔═╡ 2ca99768-53a2-11ec-02d4-e3e1bbc93b78
md"""In the examples the functions `argmax(f, itr)` and `findmin(collection)` were used. These have mathematical analogs. What is `argmax(f,itr)` in terms of math notation, where $vs$ is the iterable collection of values:
"""

# ╔═╡ 2ca9a884-53a2-11ec-00a2-5fcd52d9fba5
let
	choices = [
	    raw"``\{v    \mid v \text{ in } vs,   f(v) = \max(f(vs))\}``",
	    raw"``\{f(v) \mid v \text{ in } vs,   f(v) = \max(f(vs))\}``",
	    raw"``\{i    \mid v_i \text{ in } vs, f(v_i) = \max(f(vs))\}``"
	           ]
	radioq(choices, 1)
end

# ╔═╡ 2ca9a8d4-53a2-11ec-17e3-5b6e5dd7e0ab
md"""The functions are related: `findmax` returns the maximum value and an index in the collection for which the value will be largest; `argmax` returns an element of the set for which the function is largest, so `argmax(identify, itr)` should correspond to the index found by `findmax` (through `itr[findmax(itr)[2]`)
"""

# ╔═╡ 2ca9d886-53a2-11ec-3f7c-99e7741bb776
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/mean_value_theorem.html">◅ previous</a>  <a href="../derivatives/first_second_derivatives.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/optimization.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 2ca9dc78-53a2-11ec-1049-1d12788d653b
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
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
# ╟─2ca9bda6-53a2-11ec-07e3-15828f089956
# ╟─2c5a022a-53a2-11ec-3c4a-f10410457718
# ╟─2c5a584c-53a2-11ec-1403-df253a63302d
# ╠═2c5c21de-53a2-11ec-2f5b-85a338a9b908
# ╟─2c5c9e68-53a2-11ec-0192-ad69c8ee4080
# ╟─2c5ce666-53a2-11ec-174f-eb4feb5a933d
# ╟─2c5ce724-53a2-11ec-2b2e-955a50fcf282
# ╟─2c5ce792-53a2-11ec-104e-85544f27a3d5
# ╟─2c5e2f12-53a2-11ec-0083-b70e782c954b
# ╟─2c5e62fc-53a2-11ec-1baf-99446b8d0bde
# ╟─2c5e63ce-53a2-11ec-394b-299d0d3817cf
# ╟─2c5ed1e2-53a2-11ec-1156-6f9b0ab93274
# ╟─2c5ed232-53a2-11ec-1c88-a5ffb43bf636
# ╟─2c5f142a-53a2-11ec-3936-69b926075b26
# ╟─2c5f14d6-53a2-11ec-0b33-1b72b9040dc3
# ╟─2c5f1526-53a2-11ec-24f1-ddca0ec39da9
# ╟─2c5f65da-53a2-11ec-3575-436d885af12c
# ╟─2c5f66c8-53a2-11ec-08b5-278f31613b0b
# ╟─2c5f923c-53a2-11ec-02f2-35a431d14125
# ╟─2c5f930c-53a2-11ec-3ca3-a56dccacbd24
# ╟─2c5f9320-53a2-11ec-2509-35cd4020f2cb
# ╟─2c5f93ac-53a2-11ec-21ec-e9ddd0123dde
# ╟─2c5f93ca-53a2-11ec-33ca-bd32d4a9a46c
# ╟─2c5f9442-53a2-11ec-379d-39cf1644ff80
# ╠═2c5fb9a6-53a2-11ec-2650-f19dbe6b6a31
# ╟─2c5fd260-53a2-11ec-3631-b3e15468c3f2
# ╟─2c60356e-53a2-11ec-3b1f-ade436ae0869
# ╟─2c604e1e-53a2-11ec-1317-f7ba456a1b06
# ╠═2c607d94-53a2-11ec-110d-7d21c3588b73
# ╟─2c607e7a-53a2-11ec-14fb-0903556fd2c3
# ╟─2c607f56-53a2-11ec-27f1-0b494232d476
# ╠═2c6086fe-53a2-11ec-239b-4383e404b756
# ╟─2c6087ee-53a2-11ec-3b63-8344b176104a
# ╠═2c608b68-53a2-11ec-0c2f-532616a2dece
# ╟─2c608b88-53a2-11ec-15f7-bb6e82174313
# ╠═2c60c47a-53a2-11ec-0759-75d3a3cd60a1
# ╟─2c60f86e-53a2-11ec-0b86-d3c21d2813b9
# ╟─2c60f968-53a2-11ec-0cd1-fb761513157a
# ╟─2c60fb3e-53a2-11ec-3567-eddd41c93aa6
# ╟─2c60fc2e-53a2-11ec-0859-e14b13aa0a17
# ╟─2c60fd32-53a2-11ec-231a-9f9cc0da88d9
# ╟─2c6141b6-53a2-11ec-3fa0-8d65b291ed97
# ╟─2c614256-53a2-11ec-2564-f9108d5b7a67
# ╟─2c614364-53a2-11ec-1c1d-bba800b08eb1
# ╟─2c6143be-53a2-11ec-1aa6-c3e61473a34a
# ╟─2c6143e6-53a2-11ec-1705-c50fe8aa2013
# ╠═2c619240-53a2-11ec-3629-dd2be3577199
# ╟─2c619328-53a2-11ec-1e5f-e3979d4c7b83
# ╟─2c6193b4-53a2-11ec-1f5a-b791f0b0eae9
# ╟─2c6193fa-53a2-11ec-08f9-dde4d8f8ed0c
# ╠═2c619b70-53a2-11ec-1af2-af512e29b4b2
# ╟─2c619bac-53a2-11ec-34fa-a71918912b46
# ╠═2c61b83a-53a2-11ec-352a-9d0f786dcf89
# ╟─2c61b98e-53a2-11ec-0b6b-e1e3364c4730
# ╟─2c61ba0e-53a2-11ec-1403-b5b7336f4b3c
# ╟─2c61ba7e-53a2-11ec-248b-9dbb71361490
# ╠═2c61d93a-53a2-11ec-2699-b10320761ef0
# ╟─2c61d9f0-53a2-11ec-2542-296997d0a4a0
# ╟─2c61da74-53a2-11ec-3497-09ba19a629ef
# ╠═2c620d44-53a2-11ec-0c22-d10821ceb819
# ╟─2c620de2-53a2-11ec-2dc7-a76e358230fd
# ╟─2c620e16-53a2-11ec-2da1-83defd1f46da
# ╟─2c97a53a-53a2-11ec-1019-bb10ff1249af
# ╟─2c97c0f6-53a2-11ec-12ec-41f97208a848
# ╟─2c97c1aa-53a2-11ec-21cc-ebf9c91b80fc
# ╠═2c98005c-53a2-11ec-34f5-471467086aa0
# ╟─2c980110-53a2-11ec-220b-b95d187f9cc3
# ╠═2c980426-53a2-11ec-0e9b-b3cfc0cacd05
# ╟─2c981de4-53a2-11ec-0a04-79478aa01daa
# ╟─2c982d16-53a2-11ec-349a-f1121f7aa47d
# ╟─2c982e92-53a2-11ec-2f69-b3f0bd75d87d
# ╠═2c985bec-53a2-11ec-2622-8b8de9315fe2
# ╟─2c985c6e-53a2-11ec-2f1d-835d652018ad
# ╟─2c985d04-53a2-11ec-386b-ff1104fc0aaf
# ╠═2c98cece-53a2-11ec-103e-c724c9068851
# ╟─2c98cfc8-53a2-11ec-0066-3b9ccb437e6b
# ╠═2c991b0e-53a2-11ec-3f7c-bf0094996793
# ╟─2c991bd6-53a2-11ec-3025-ed5f4dbd02a3
# ╠═2c9954fe-53a2-11ec-2eca-fda1f4bd3e7f
# ╟─2c99565a-53a2-11ec-27be-137ffe969927
# ╟─2c997088-53a2-11ec-2b22-5311d502273e
# ╟─2c9992fa-53a2-11ec-2906-1b66d4987ccf
# ╟─2c999340-53a2-11ec-1f65-3fba01889547
# ╟─2c999408-53a2-11ec-3acb-bf1f1b960a4d
# ╟─2c999444-53a2-11ec-0006-0df2153e8578
# ╠═2c99dc92-53a2-11ec-0218-bddeb1241860
# ╟─2c99dcf6-53a2-11ec-1a29-49376c2dd2f6
# ╠═2c99e322-53a2-11ec-2e07-35cd27f732bd
# ╟─2c99e368-53a2-11ec-2673-bf0aafe024ad
# ╟─2c99e3fe-53a2-11ec-3b7b-e36acb494e80
# ╟─2c99e458-53a2-11ec-245b-8fa7d0944586
# ╟─2c99e522-53a2-11ec-3ac0-a77a6c6b1815
# ╟─2c9a0384-53a2-11ec-1616-c9469a0cbdc6
# ╟─2c9a0456-53a2-11ec-0dc1-570ea5167a1a
# ╟─2c9a0474-53a2-11ec-3e81-6d502e9ec57b
# ╟─2c9a04d8-53a2-11ec-1c2d-a78dec067d50
# ╟─2c9a0512-53a2-11ec-2fbc-e5d013f99968
# ╠═2c9a0c4e-53a2-11ec-0dad-03e89b8e2a77
# ╟─2c9a0c8c-53a2-11ec-1fab-eb797b8c4aaa
# ╟─2c9a0ce4-53a2-11ec-248d-4d66d8488946
# ╠═2c9a29f4-53a2-11ec-2395-edea73e9c48f
# ╟─2c9a2a8a-53a2-11ec-31df-7da718b0ea55
# ╠═2c9a3110-53a2-11ec-30cb-03f94535fef3
# ╟─2c9a317e-53a2-11ec-2206-e147d8886ba7
# ╟─2c9a3200-53a2-11ec-3d93-d349132543a4
# ╟─2c9a32a0-53a2-11ec-31a7-75c89709f136
# ╟─2c9a3444-53a2-11ec-350b-af57b93d53f1
# ╟─2c9a344e-53a2-11ec-258a-5721ca8f60c3
# ╟─2c9a350c-53a2-11ec-3276-636541d26170
# ╟─2c9a3570-53a2-11ec-2544-878393780136
# ╟─2c9a36c4-53a2-11ec-04a4-51a2ee5caede
# ╟─2c9a36f6-53a2-11ec-0095-1da103559fb0
# ╟─2c9a376e-53a2-11ec-21cb-6bfd87daa140
# ╟─2c9a37bc-53a2-11ec-1abe-45e524708b85
# ╟─2c9a3818-53a2-11ec-0209-8b06e72fa6fd
# ╠═2c9a4a6a-53a2-11ec-066f-bfe850e4a36a
# ╠═2c9a6504-53a2-11ec-14c2-ddadcffab47e
# ╟─2c9a6536-53a2-11ec-2fad-212c2671a6ba
# ╠═2c9a6f86-53a2-11ec-21e4-79a78126c73d
# ╟─2c9a7058-53a2-11ec-0f29-3d2a8f4034e0
# ╠═2c9a9f42-53a2-11ec-0b82-27a1cf3ccbed
# ╟─2c9a9fba-53a2-11ec-3f9e-b1b348f9bc6d
# ╠═2c9aa186-53a2-11ec-2715-6bdbf9948cde
# ╟─2c9aa1e0-53a2-11ec-0565-31b4e6908956
# ╠═2c9aaaaa-53a2-11ec-2508-d97aeb313120
# ╟─2c9aab2c-53a2-11ec-3b65-c77d7b451c72
# ╟─2c9aaba4-53a2-11ec-2658-9b1540cae82f
# ╟─2c9ab11c-53a2-11ec-3662-970c17e7b9f9
# ╟─2ca52130-53a2-11ec-2891-03d5a25286f6
# ╟─2ca5226e-53a2-11ec-0bb7-292eccc1bd4b
# ╟─2ca52304-53a2-11ec-026e-05ee0e1ab8c4
# ╠═2ca5473a-53a2-11ec-0240-8fcf54774058
# ╟─2ca54796-53a2-11ec-2dde-a116f3f16e7a
# ╟─2ca5487a-53a2-11ec-3b16-2778a1a437da
# ╟─2ca54898-53a2-11ec-17c2-d96b839b306d
# ╠═2ca54ed8-53a2-11ec-2042-f7a308cc0e24
# ╟─2ca54fb4-53a2-11ec-2c2a-eb193b17ad8b
# ╠═2ca57174-53a2-11ec-3939-d5d02cfe5f07
# ╟─2ca571d8-53a2-11ec-0b6d-49e6cee47f50
# ╠═2ca5912c-53a2-11ec-2173-5175c864562b
# ╟─2ca5928a-53a2-11ec-3839-8f42264af328
# ╠═2ca597e4-53a2-11ec-260f-097a1aaa486a
# ╟─2ca5987a-53a2-11ec-00d2-d11afbbd8b0a
# ╠═2ca5bf1c-53a2-11ec-28b1-1d29b700228d
# ╟─2ca5bfbc-53a2-11ec-1ed0-d5758cb66479
# ╠═2ca5c7b4-53a2-11ec-34bb-f500c7ae6a2c
# ╟─2ca5c8cc-53a2-11ec-10c5-1b4c872cb310
# ╟─2ca5c8ea-53a2-11ec-00bf-9743d301fea5
# ╠═2ca5e3f2-53a2-11ec-307b-fb61b5cd59af
# ╟─2ca5e528-53a2-11ec-20f7-67e6665edf36
# ╠═2ca6072e-53a2-11ec-1a79-67d008b6f9e6
# ╟─2ca6080a-53a2-11ec-335f-fba4c0d4493a
# ╠═2ca66340-53a2-11ec-08b4-050441b13fe5
# ╟─2ca663fe-53a2-11ec-3f63-0b8a306a1fe3
# ╠═2ca68622-53a2-11ec-17c4-eb395bc64e6a
# ╟─2ca68690-53a2-11ec-04ad-f7600a407d49
# ╠═2ca68898-53a2-11ec-2143-c96de894449e
# ╟─2ca6897e-53a2-11ec-2c3a-09488832c6b4
# ╟─2ca6899c-53a2-11ec-002d-2113153a4559
# ╠═2ca6b5b6-53a2-11ec-1d77-ad9bc9aac487
# ╟─2ca6b656-53a2-11ec-3415-2deeed081121
# ╟─2ca6b672-53a2-11ec-1163-cf846bbb5347
# ╟─2ca6b6ce-53a2-11ec-2f67-cdcf00eddf9d
# ╟─2ca6ba70-53a2-11ec-127b-d118cc2363a4
# ╟─2ca6bb1c-53a2-11ec-1bcf-2d8e72b9a774
# ╠═2ca6d744-53a2-11ec-130e-73337547ac48
# ╟─2ca6d79e-53a2-11ec-3ed5-edfe301b60f0
# ╠═2ca6daac-53a2-11ec-3715-b1fce3ced96c
# ╟─2ca6db36-53a2-11ec-241b-6bb7a15d82a5
# ╠═2ca6dfc8-53a2-11ec-2747-153b1c78106c
# ╟─2ca6e022-53a2-11ec-2015-854e81684a17
# ╠═2ca6e25c-53a2-11ec-3c55-43b8b802623f
# ╟─2ca6e2f2-53a2-11ec-050f-6f95487b4585
# ╟─2ca6e36a-53a2-11ec-27cd-67a86f9e109d
# ╟─2ca6e392-53a2-11ec-1ae0-c50cc3b93185
# ╟─2ca6fa94-53a2-11ec-211f-730c1c55d251
# ╟─2ca6fb48-53a2-11ec-1003-0fad6a425bfe
# ╟─2ca6fc1a-53a2-11ec-1b24-9b0ebcab6579
# ╟─2ca6fc60-53a2-11ec-2043-61a736d87ab0
# ╠═2ca71164-53a2-11ec-17f3-35a483e72f76
# ╟─2ca727bc-53a2-11ec-2cd9-9d7cebd9d9fa
# ╠═2ca72d5c-53a2-11ec-33c9-15306319552b
# ╟─2ca72dd4-53a2-11ec-0055-5f02d0e6ccb4
# ╠═2ca74562-53a2-11ec-1261-b31a1d261264
# ╟─2ca745b2-53a2-11ec-3654-a39ce79b3168
# ╟─2ca745bc-53a2-11ec-08ab-21de334235c7
# ╠═2ca74882-53a2-11ec-2414-238a3f6e99ca
# ╟─2ca748be-53a2-11ec-08d0-c7aee5bea700
# ╠═2ca74e04-53a2-11ec-236a-67cde9ae3b50
# ╟─2ca74ecc-53a2-11ec-3f8e-9750fbee6afa
# ╠═2ca750b6-53a2-11ec-0c25-d9b43936cf20
# ╟─2ca75112-53a2-11ec-283c-65ed688b740f
# ╟─2ca75138-53a2-11ec-3150-431d8d361ff2
# ╟─2ca75304-53a2-11ec-234e-0314b876ed46
# ╟─2ca7532c-53a2-11ec-0b0a-a1920623b8d6
# ╟─2ca76c22-53a2-11ec-3309-2d6daecf7a2b
# ╟─2ca76c4a-53a2-11ec-2d54-2577fda748be
# ╟─2ca76c7c-53a2-11ec-329d-09051f8c9328
# ╟─2ca77168-53a2-11ec-3651-5de6194add6e
# ╟─2ca771d8-53a2-11ec-07fc-b527471cf9a3
# ╟─2ca78536-53a2-11ec-2d6f-c16af1e0c76a
# ╟─2ca78cde-53a2-11ec-21b3-4bfec2f857d8
# ╟─2ca78d1a-53a2-11ec-299c-23fd5a284fb0
# ╟─2ca79080-53a2-11ec-39ad-a54d0fff100c
# ╟─2ca790ee-53a2-11ec-13e6-7dc002cf655c
# ╟─2ca7a9f0-53a2-11ec-05f8-593149d3482c
# ╟─2ca7aac0-53a2-11ec-0068-2316afd545d2
# ╟─2ca7c168-53a2-11ec-0a05-4d8ab255ead6
# ╟─2ca7df54-53a2-11ec-3923-d593d1e9721e
# ╟─2ca7dfd6-53a2-11ec-01cd-4f0d99504f8f
# ╟─2ca7e080-53a2-11ec-34fe-8155157a9024
# ╟─2ca7e864-53a2-11ec-351b-2d512c7cacd9
# ╟─2ca7e8e6-53a2-11ec-1fbf-4f49246d5453
# ╟─2ca7e954-53a2-11ec-2137-cb2860842645
# ╟─2ca8207c-53a2-11ec-2cb5-0fde7024f49f
# ╟─2ca820fe-53a2-11ec-3f72-a7fbb49b30e1
# ╟─2ca857e0-53a2-11ec-192b-df92b5329ad9
# ╟─2ca8586e-53a2-11ec-3bec-fdee9ec3ee4a
# ╟─2ca858b2-53a2-11ec-3401-597fab087589
# ╟─2ca8590c-53a2-11ec-3580-9dcd4e176eea
# ╟─2ca85daa-53a2-11ec-1d6b-7d49ea46b5d1
# ╟─2ca87342-53a2-11ec-185f-7fbc62075dde
# ╟─2ca873c6-53a2-11ec-3fba-4387478f7c8a
# ╟─2ca88dbe-53a2-11ec-1b8f-07fb3414bf4e
# ╟─2ca88e22-53a2-11ec-1814-d7a54dfeb6eb
# ╟─2ca897a0-53a2-11ec-24e4-f70db64c24db
# ╟─2ca897c8-53a2-11ec-1428-81e3ab060f58
# ╟─2ca8987c-53a2-11ec-2cdc-1bd0da57dac2
# ╠═2ca8a24a-53a2-11ec-2241-856a586b2b99
# ╟─2ca8a298-53a2-11ec-20a6-b194c6c8581a
# ╠═2ca8bee2-53a2-11ec-3165-f5770aa5b307
# ╟─2ca8bf96-53a2-11ec-39ea-7f9aa56312e0
# ╟─2ca8c874-53a2-11ec-3d07-e575379a3650
# ╟─2ca8c8fe-53a2-11ec-3d8b-f93d2c844d1d
# ╟─2ca8c9c8-53a2-11ec-2951-35deb4c5c54a
# ╟─2ca8c9f0-53a2-11ec-2afb-adc4910ce5d1
# ╟─2ca8ca7c-53a2-11ec-01ca-9f476e88bd78
# ╟─2ca8cae0-53a2-11ec-169b-8d603e45fc54
# ╟─2ca8e796-53a2-11ec-2631-29707438163b
# ╟─2ca8e82e-53a2-11ec-0ada-add78b55247d
# ╟─2ca8e89a-53a2-11ec-0798-3154c3a5cf6c
# ╟─2ca8f434-53a2-11ec-2a7e-8baad932c605
# ╟─2ca8f696-53a2-11ec-0c7a-2bbdc73cf515
# ╟─2ca8f6f0-53a2-11ec-1988-13346fbf2b96
# ╟─2ca9030c-53a2-11ec-3ed8-01516b4e64b7
# ╟─2ca9032a-53a2-11ec-1745-254d36a0a7e1
# ╟─2ca90656-53a2-11ec-2a15-a9422c1cbf12
# ╟─2ca907be-53a2-11ec-3c91-29762594e6c6
# ╟─2ca90e88-53a2-11ec-1ea5-2365cc618c81
# ╟─2ca91180-53a2-11ec-3fb3-173eee8713c4
# ╟─2ca911da-53a2-11ec-1d33-9f79cac70e1b
# ╟─2ca9299a-53a2-11ec-2772-59bc63e18c3a
# ╟─2ca929ae-53a2-11ec-0941-891555ad893c
# ╟─2ca930f4-53a2-11ec-1beb-b38d8d7943ac
# ╟─2ca93110-53a2-11ec-2a2e-d10fefdb0446
# ╟─2ca9393a-53a2-11ec-343c-3f41a4f4044c
# ╟─2ca93d2c-53a2-11ec-1e82-89b624835797
# ╟─2ca93d5e-53a2-11ec-2c89-35fb7aade96d
# ╟─2ca94ab2-53a2-11ec-1207-4d7f60194891
# ╟─2ca971fc-53a2-11ec-17ef-eb40c7f81e7a
# ╟─2ca9744c-53a2-11ec-1df9-cfabeb20c1f1
# ╟─2ca97ec2-53a2-11ec-3691-bb1779a6979b
# ╟─2ca98106-53a2-11ec-049b-45fa81b62397
# ╟─2ca982d2-53a2-11ec-2164-a922e8b4a58a
# ╟─2ca982e6-53a2-11ec-37be-3146150c3ccd
# ╟─2ca98a8e-53a2-11ec-0660-39dd9739c6bd
# ╟─2ca98ad4-53a2-11ec-0798-0b5972164066
# ╟─2ca992cc-53a2-11ec-382c-d1f4c397a2c7
# ╟─2ca99326-53a2-11ec-1490-811f0d32478e
# ╟─2ca99768-53a2-11ec-02d4-e3e1bbc93b78
# ╟─2ca9a884-53a2-11ec-00a2-5fcd52d9fba5
# ╟─2ca9a8d4-53a2-11ec-17e3-5b6e5dd7e0ab
# ╟─2ca9d886-53a2-11ec-3f7c-99e7741bb776
# ╟─2ca9da7a-53a2-11ec-078a-c93ddbaaed4d
# ╟─2ca9dc78-53a2-11ec-1049-1d12788d653b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
