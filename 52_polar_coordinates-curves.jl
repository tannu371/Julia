### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 2392d0cc-7657-11ec-27c3-478758bba72e
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
	using QuadGK
end

# ╔═╡ 2392d43c-7657-11ec-1d35-93231d7e0dc3
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	using LaTeXStrings
	
	nothing
end

# ╔═╡ 23b86094-7657-11ec-2e4d-a13efd825ff2
using PlutoUI

# ╔═╡ 23b8606c-7657-11ec-20bc-bbea59557f7d
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 23762c88-7657-11ec-3f79-2dfe3c9f1445
md"""# Polar Coordinates and Curves
"""

# ╔═╡ 23789ba0-7657-11ec-3e97-f5276bfd4053
md"""This section uses these add-on packages:
"""

# ╔═╡ 2394c33e-7657-11ec-078c-d32bcbf0a624
md"""---
"""

# ╔═╡ 23978bbc-7657-11ec-2679-7f58b4056c73
md"""The description of the $x$-$y$ plane via Cartesian coordinates is not the only possible way, though one that is most familiar. Here we discuss a different means. Instead of talking about over and up from an origin, we focus on a direction and a distance from the origin.
"""

# ╔═╡ 239a2066-7657-11ec-0d21-3dab2522f3b3
md"""## Definition of polar coordinates
"""

# ╔═╡ 239a20de-7657-11ec-1032-693f5a02fa66
md"""Polar coordinates parameterize the plane though an angle $\theta$ made from the positive ray of the $x$ axis and a radius $r$.
"""

# ╔═╡ 239a2886-7657-11ec-2611-533af20bfea8
let
	theta = pi/6
	rr = 1
	
	p = plot(xticks=nothing, yticks=nothing, border=:none, aspect_ratio=:equal, xlim=(-.1,1), ylim=(-.1,3/4))
	plot!([0,rr*cos(theta)], [0, rr*sin(theta)], legend=false, color=:blue, linewidth=2)
	scatter!([rr*cos(theta)],[rr*sin(theta)], markersize=3, color=:blue)
	arrow!([0,0], [0,3/4], color=:black)
	arrow!([0,0], [1,0], color=:black)
	ts = range(0, theta, length=50)
	rr = 1/6
	plot!(rr*cos.(ts), rr*sin.(ts), color=:black)
	plot!([cos(theta),cos(theta)],[0, sin(theta)], linestyle=:dash, color=:gray)
	plot!([0,cos(theta)],[sin(theta), sin(theta)], linestyle=:dash, color=:gray)
	annotate!([
	        (1/5*cos(theta/2), 1/5*sin(theta/2), L"\theta"),
	        (1/2*cos(theta*1.2), 1/2*sin(theta*1.2), L"r"),
	        (cos(theta), sin(theta)+.05, L"(x,y)"),
	        (cos(theta),-.05, L"x"),
	        (-.05, sin(theta),L"y")
	        ])
end

# ╔═╡ 239bdfd4-7657-11ec-294b-9b8c9609a67e
md"""To recover the Cartesian coordinates from the pair $(r,\theta)$, we have these formulas from [right](http://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates) triangle geometry:
"""

# ╔═╡ 239ddb02-7657-11ec-14fd-79c04c8f61c9
md"""```math
x = r \cos(\theta),~ y = r \sin(\theta).
```
"""

# ╔═╡ 239ddbac-7657-11ec-1c8b-e32d30b333e1
md"""Each point $(x,y)$ corresponds to several possible values of $(r,\theta)$, as any integer multiple of $2\pi$ added to $\theta$ will describe the same point. Except for the origin, there is only one pair when we restrict to $r > 0$ and $0 \leq \theta < 2\pi$.
"""

# ╔═╡ 239ddbca-7657-11ec-3f6e-73efeb8221f2
md"""For values in the first and fourth quadrants (the range of $\tan^{-1}(x)$), we have:
"""

# ╔═╡ 239ddbe8-7657-11ec-0fcc-87602fbf8667
md"""```math
r = \sqrt{x^2 + y^2},~ \theta=\tan^{-1}(y/x).
```
"""

# ╔═╡ 23a414f4-7657-11ec-1b52-ab8ae6ae2a7d
md"""For the other two quadrants, the signs of $y$ and $x$ must be considered. This is done with the function `atan` when two arguments are used.
"""

# ╔═╡ 23a4159e-7657-11ec-23ad-854d9dc9c1f5
md"""For example, $(-3, 4)$ would have polar coordinates:
"""

# ╔═╡ 23a41de6-7657-11ec-2ad4-2b6638e48131
begin
	x,y = -3, 4
	rad, theta = sqrt(x^2 + y^2), atan(y, x)
end

# ╔═╡ 23a41e04-7657-11ec-1a14-67ad6916403e
md"""And reversing
"""

# ╔═╡ 23a42214-7657-11ec-266a-53379364b234
rad*cos(theta), rad*sin(theta)

# ╔═╡ 23a42228-7657-11ec-3fe8-b5e4f407554a
md"""This figure illustrates:
"""

# ╔═╡ 23a42b6a-7657-11ec-152e-8d2bcbe803db
let
	p = plot([-5,5], [0,0],  color=:blue, legend=false)
	plot!([0,0],  [-5,5], color=:blue)
	plot!([-3,0], [4,0])
	scatter!([-3], [4])
	title!("(-3,4) Cartesian or (5, 2.21...) polar")
	
	p
end

# ╔═╡ 23a42b9c-7657-11ec-2a50-8dfb20a92f77
md"""The case where $r < 0$ is handled by going $180$ degrees in the opposite direction, in other words the point $(r, \theta)$ can be described as well by $(-r,\theta+\pi)$.
"""

# ╔═╡ 23a42bc4-7657-11ec-111c-27f7cc76cd49
md"""## Parameterizing curves using polar coordinates
"""

# ╔═╡ 23a42be2-7657-11ec-0a38-87aa5c378b94
md"""If $r=r(\theta)$, then the parameterized curve $(r(\theta), \theta)$ is just the set of points generated as $\theta$ ranges over some set of values. There are many examples of parameterized curves that simplify what might be a complicated presentation in Cartesian coordinates.
"""

# ╔═╡ 23a42bf6-7657-11ec-133e-4d9e28d31be4
md"""For example, a circle has the form $x^2 + y^2 = R^2$. Whereas parameterized by polar coordinates it is just $r(\theta) = R$, or a constant function.
"""

# ╔═╡ 23a42c0a-7657-11ec-3b2b-37ec6a563e55
md"""The circle centered at $(r_0, \gamma)$ (in polar coordinates) with radius $R$ has a more involved description in polar coordinates:
"""

# ╔═╡ 23a42c28-7657-11ec-1250-bb3bcd92b20f
md"""```math
r(\theta) = r_0 \cos(\theta - \gamma)  + \sqrt{R^2 - r_0^2\sin^2(\theta - \gamma)}.
```
"""

# ╔═╡ 23a42c46-7657-11ec-282b-15f6a0abc6ca
md"""The case where $r_0 > R$ will not be defined for all values of $\theta$, only when $|\sin(\theta-\gamma)| \leq R/r_0$.
"""

# ╔═╡ 23a6fc80-7657-11ec-011e-712b2bee7475
md"""#### Examples
"""

# ╔═╡ 23a82bdc-7657-11ec-106f-6bb117e08a1e
md"""The `Plots.jl` package provides a means to visualize polar plots through `plot(thetas, rs, proj=:polar)`. For example, to plot a circe with $r_0=1/2$ and $\gamma=\pi/6$ we would have:
"""

# ╔═╡ 23a838a4-7657-11ec-2a7e-bfd15770bee7
let
	R, r0, gamma = 1, 1/2, pi/6
	r(theta) = r0 * cos(theta-gamma) + sqrt(R^2 - r0^2*sin(theta-gamma)^2)
	ts = range(0, 2pi, length=100)
	rs = r.(ts)
	plot(ts, rs, proj=:polar, legend=false)
end

# ╔═╡ 23a8391c-7657-11ec-241b-43ab035c9e56
md"""To avoid having to create values for $\theta$ and values for $r$, the `CalculusWithJulia` package provides a helper function, `plot_polar`. To distinguish it from other functions provided by `Plots`, the calling pattern is different. It specifies an interval to plot over by `a..b` and puts that first, followed by `r`. Other keyword arguments are passed onto a `plot` call.
"""

# ╔═╡ 23a83930-7657-11ec-3ea2-ff0c56b58496
md"""We will use this in the following, as the graphs are a bit more familiar and the calling pattern similar to how we have plotted functions.
"""

# ╔═╡ 23a8394e-7657-11ec-3ffc-b1f198c0ca9f
md"""As `Plots` will make a parametric plot when called as `plot(function, function, a,b)`, the above function creates two such functions using the relationship $x=r\cos(\theta)$ and $y=r\sin(\theta)$.
"""

# ╔═╡ 23a83962-7657-11ec-3e47-6d2638047614
md"""Using `plot_polar`,  we can plot circles with the following. We have to be a bit careful for the general circle, as when the center is farther away from the origin that the radius ($R$), then not all angles will be acceptable and there are two functions needed to describe the radius, as this comes from a quadratic equation and both the "plus" and "minus" terms are used.
"""

# ╔═╡ 23a84038-7657-11ec-1831-535b0a49f3b9
let
	R=4; r(t) = R;
	
	function plot_general_circle!(r0, gamma, R)
	    # law of cosines has if gamma=0, |theta| <= asin(R/r0)
	    # R^2 = a^2 + r^2 - 2a*r*cos(theta); solve for a
	    r(t) = r0 * cos(t - gamma) + sqrt(R^2 - r0^2*sin(t-gamma)^2)
	    l(t) = r0 * cos(t - gamma) - sqrt(R^2 - r0^2*sin(t-gamma)^2)
	
	    if R < r0
	        theta = asin(R/r0)-1e-6                 # avoid round off issues
	        plot_polar!((gamma-theta)..(gamma+theta), r)
	        plot_polar!((gamma-theta)..(gamma+theta), l)
		else
			plot_polar!(0..2pi, r)
		end
	end
	
	plot_polar(0..2pi, r, aspect_ratio=:equal, legend=false)
	plot_general_circle!(2, 0, 2)
	plot_general_circle!(3, 0, 1)
end

# ╔═╡ 23a96cf6-7657-11ec-3718-1d34e14cee48
md"""There are many interesting examples of curves described by polar coordinates. An interesting [compilation](http://www-history.mcs.st-and.ac.uk/Curves/Curves.html) of famous curves is found at the MacTutor History of Mathematics archive, many of which have formulas in polar coordinates.
"""

# ╔═╡ 23ac3e7c-7657-11ec-389f-4fa1f19acaeb
md"""##### Example
"""

# ╔═╡ 23ac3f08-7657-11ec-313e-936966e50ceb
md"""The [rhodenea](http://www-history.mcs.st-and.ac.uk/Curves/Rhodonea.html) curve has
"""

# ╔═╡ 23ac3f30-7657-11ec-335a-5f946e062fb0
md"""```math
r(\theta) = a \sin(k\theta)
```
"""

# ╔═╡ 23ac494c-7657-11ec-2ebc-db1695eb1a8f
let
	a, k = 4, 5
	r(theta) = a * sin(k * theta)
	plot_polar(0..pi, r)
end

# ╔═╡ 23ac49f0-7657-11ec-3940-652b7188f0e4
md"""This graph has radius $0$ whenever $\sin(k\theta) = 0$ or $k\theta =n\pi$. Solving means that it is $0$ at integer multiples of $\pi/k$. In the above, with $k=5$, there will $5$ zeroes in $[0,\pi]$. The entire curve is traced out over this interval, the values from $\pi$ to $2\pi$ yield negative value of $r$, so are related to values within $0$ to $\pi$ via the relation $(r,\pi +\theta) = (-r, \theta)$.
"""

# ╔═╡ 23ac4a16-7657-11ec-041c-3b9135a00be5
md"""##### Example
"""

# ╔═╡ 23ac4a3e-7657-11ec-0a80-0bc8fa8d9610
md"""The [folium](http://www-history.mcs.st-and.ac.uk/Curves/Folium.html) is a somewhat similar looking curve, but has this description:
"""

# ╔═╡ 23ac4a5c-7657-11ec-1ea9-25020d684d64
md"""```math
r(\theta) = -b \cos(\theta) + 4a \cos(\theta) \sin(2\theta)
```
"""

# ╔═╡ 23ac51b4-7657-11ec-1c6b-8582d78f1463
begin
	𝒂, 𝒃 = 4, 2
	𝒓(theta) = -𝒃 * cos(theta) + 4𝒂 * cos(theta) * sin(2theta)
	plot_polar(0..2pi, 𝒓)
end

# ╔═╡ 23ac522e-7657-11ec-2884-db418a98de8f
md"""The folium has radial part $0$ when $\cos(\theta) = 0$ or $\sin(2\theta) = b/4a$. This could be used to find out what values correspond to which loop. For our choice of $a$ and $b$ this gives $\pi/2$, $3\pi/2$ or, as $b/4a = 1/8$, when $\sin(2\theta) = 1/8$ which happens at $a_0=\sin^{-1}(1/8)/2=0.0626...$ and $\pi/2 - a_0$, $\pi+a_0$ and $3\pi/2 - a_0$. The first folium can be plotted with:
"""

# ╔═╡ 23ac5be6-7657-11ec-2700-71819cbda1d1
begin
	𝒂0 = (1/2) * asin(1/8)
	plot_polar(𝒂0..(pi/2-𝒂0), 𝒓)
end

# ╔═╡ 23ac5c0e-7657-11ec-2a48-35b8623f15fe
md"""The second - which is too small to appear in the initial plot without zooming in - with
"""

# ╔═╡ 23ac633c-7657-11ec-0198-1b248b957d85
plot_polar((pi/2 - 𝒂0)..(pi/2), 𝒓)

# ╔═╡ 23ac635c-7657-11ec-0dc8-0defc3511d5a
md"""The third with
"""

# ╔═╡ 23ac6938-7657-11ec-1709-892ec547005b
plot_polar((pi/2)..(pi + 𝒂0), 𝒓)

# ╔═╡ 23ac696a-7657-11ec-3cba-e9d13ccda11e
md"""The plot repeats from there, so the initial plot could have been made over $[0, \pi + a_0]$.
"""

# ╔═╡ 23ac6988-7657-11ec-24ae-c3cac5d83058
md"""##### Example
"""

# ╔═╡ 23ac69a6-7657-11ec-314f-8fb50b08b9f5
md"""The [Limacon of Pascal](http://www-history.mcs.st-and.ac.uk/Curves/Limacon.html) has
"""

# ╔═╡ 23ac69ce-7657-11ec-2481-8d2d049c52d9
md"""```math
r(\theta) = b + 2a\cos(\theta)
```
"""

# ╔═╡ 23ac7022-7657-11ec-3fb9-1564bad4f07b
let
	a,b = 4, 2
	r(theta) = b + 2a*cos(theta)
	plot_polar(0..2pi, r)
end

# ╔═╡ 23ac7040-7657-11ec-3239-5db578dcd136
md"""##### Example
"""

# ╔═╡ 23ac7068-7657-11ec-1e5b-6b85f62bb877
md"""Some curves require a longer parameterization, such as this where we plot over $[0, 8\pi]$ so that the cosine term can range over an entire half period:
"""

# ╔═╡ 23ac78f8-7657-11ec-37ed-457608a1da29
let
	r(theta) = sqrt(abs(cos(theta/8)))
	plot_polar(0..8pi, r)
end

# ╔═╡ 23ac7932-7657-11ec-254c-314da19a1eee
md"""## Area of polar graphs
"""

# ╔═╡ 23ac796e-7657-11ec-374d-adc361b52eab
md"""Consider the [cardioid](http://www-history.mcs.st-and.ac.uk/Curves/Cardioid.html) described by $r(\theta) = 2(1 + \cos(\theta))$:
"""

# ╔═╡ 23ac8116-7657-11ec-312d-fb786d3bd745
let
	r(theta) = 2(1 + cos(theta))
	plot_polar(0..2pi, r)
end

# ╔═╡ 23ac8136-7657-11ec-3908-e5491d4b4432
md"""How much area is contained in the graph?
"""

# ╔═╡ 23ac8152-7657-11ec-25e7-6de1f1bc24c2
md"""In some cases it might be possible to translate back into Cartesian coordinates and compute from there. In practice, this is not usually the best solution.
"""

# ╔═╡ 23ac8164-7657-11ec-058d-11ccde5518b5
md"""The area can be approximated by wedges (not rectangles). For example, here we see that the area over a given angle is well approximated by the wedge for each of the sectors:
"""

# ╔═╡ 23ac8b84-7657-11ec-23bf-8d989e636b4e
let
	r(theta) = 1/(1 + (1/3)cos(theta))
	p = plot_polar(0..pi/2, r,  legend=false, linewidth=3, aspect_ratio=:equal)
	t0, t1, t2, t3 = collect(range(pi/12, pi/2 - pi/12, length=4))
	
	for s in (t0,t1,t2,t3)
	  plot!(p, [0, r(s)*cos(s)], [0, r(s)*sin(s)], linewidth=3)
	end
	
	for (s0,s1) in ((t0,t1), (t1, t2), (t2,t3))
	    s = (s0 + s1)/2
	    plot!(p, [0, ])
	    plot!(p, [0,r(s)*cos(s)], [0, r(s)*sin(s)])
	    ts = range(s0, s1, length=25)
	    xs, ys = r(s)*cos.(ts), r(s)*sin.(ts)
	    plot!(p, xs, ys)
	    plot!(p, [0,xs[1]],[0,ys[1]])
	end
	p
end

# ╔═╡ 23ac8bc0-7657-11ec-18ab-75b07db99166
md"""As well, see this part of a [Wikipedia](http://en.wikipedia.org/wiki/Polar_coordinate_system#Integral_calculus_.28area.29) page for a figure.
"""

# ╔═╡ 23ac8c12-7657-11ec-3b00-8bc0fa5e79c9
md"""Imagine we have $a < b$ and a partition $a=t_0 < t_1 < \cdots < t_n = b$. Let $\phi_i = (1/2)(t_{i-1} + t_{i})$ be the midpoint. Then the wedge of radius $r(\phi_i)$ with angle between $t_{i-1}$ and $t_i$ will have area $\pi r(\phi_i)^2 (t_i-t_{i-1}) / (2\pi) = (1/2) r(\phi_i)(t_i-t_{i-1})$, the ratio $(t_i-t_{i-1}) / (2\pi)$ being the angle to the total angle of a circle.  Summing the area of these wedges over the partition gives a Riemann sum approximation for the integral $(1/2)\int_a^b r(\theta)^2 d\theta$. This limit of this sum defines the area in polar coordinates.
"""

# ╔═╡ 23b527c6-7657-11ec-37e4-f3a99781ca72
md"""> *Area of polar regions*. Let $R$ denote the region bounded by the curve $r(\theta)$ and bounded by the rays $\theta=a$ and $\theta=b$ with $b-a \leq 2\pi$, then the area of $R$ is given by:
>
> $A = \frac{1}{2}\int_a^b r(\theta)^2 d\theta.$

"""

# ╔═╡ 23b52820-7657-11ec-003a-a70846081f6b
md"""So the area of the cardioid, which is parameterized over $[0, 2\pi]$ is found by
"""

# ╔═╡ 23b531c6-7657-11ec-12ba-e59333b03d0d
let
	r(theta) = 2(1 + cos(theta))
	@syms theta
	(1//2) * integrate(r(theta)^2, (theta, 0, 2PI))
end

# ╔═╡ 23b53202-7657-11ec-1bca-09924b2f4eb6
md"""##### Example
"""

# ╔═╡ 23b53234-7657-11ec-060a-4f844f63cd0c
md"""The folium has general formula $r(\theta) = -b \cos(\theta) +4a\cos(\theta)\sin(\theta)^2$. When $a=1$ and $b=1$ a leaf of the folium is traced out between $\pi/6$ and $\pi/2$. What is the area of that leaf?
"""

# ╔═╡ 23b53246-7657-11ec-182a-6bc05887d1c9
md"""An antiderivative exists for arbitrary $a$ and $b$:
"""

# ╔═╡ 23b53838-7657-11ec-20a1-8d3add4efe66
begin
	@syms 𝐚 𝐛 𝐭heta
	𝐫(theta) = -𝐛*cos(theta) + 4𝐚*cos(theta)*sin(theta)^2
	integrate(𝐫(𝐭heta)^2, 𝐭heta) / 2
end

# ╔═╡ 23b53860-7657-11ec-1a37-c545a26931d4
md"""For our specific values, the answer can be computed with:
"""

# ╔═╡ 23b541f2-7657-11ec-29ae-a37d42d5a1d9
begin
	ex = integrate(𝐫(𝐭heta)^2, (𝐭heta, PI/6, PI/2)) / 2
	ex(𝐚 => 1, 𝐛=>1)
end

# ╔═╡ 23b7d14c-7657-11ec-299a-5fc300117bd7
md"""###### Example
"""

# ╔═╡ 23b7d1d8-7657-11ec-3556-e5511ea18d8f
md"""Pascal's [limacon](http://www-history.mcs.st-and.ac.uk/Curves/Limacon.html) is like the cardioid, but contains an extra loop. When $a=1$ and $b=1$ we have this graph.
"""

# ╔═╡ 23b7d980-7657-11ec-26e9-556f4c2f1dae
let
	a,b = 1,1
	r(theta) = b + 2a*cos(theta)
	p = plot(t->r(t)*cos(t), t->r(t)*sin(t), 0, pi/2 + pi/6,  legend=false, color=:blue)
	plot!(p, t->r(t)*cos(t), t->r(t)*sin(t), 3pi/2 - pi/6, pi/2 + pi/6, color=:orange)
	plot!(p, t->r(t)*cos(t), t->r(t)*sin(t), 3pi/2 - pi/6, 2pi, color=:blue)
	
	p
end

# ╔═╡ 23b7d9a8-7657-11ec-07dd-77caa915239c
md"""What is the area contained in the outer loop, that is not in the inner loop?
"""

# ╔═╡ 23b7d9ee-7657-11ec-3912-57d61473cb06
md"""To answer, we need to find out what range of values in $[0, 2\pi]$ the inner and outer loops are traced. This will be when $r(\theta) = 0$, which for the choice of $a$ and $b$ solves $1 + 2\cos(\theta) = 0$, or $\cos(\theta) = -1/2$. This is $\pi/2 + \pi/6$ and $3\pi/2 - \pi/6$. The inner loop is traversed between those values and has area:
"""

# ╔═╡ 23b7df84-7657-11ec-3e0d-290fe49c7f66
begin
	@syms 𝖺 𝖻 𝗍heta
	𝗋(theta) =  𝖻 + 2𝖺*cos(𝗍heta)
	𝖾x = integrate(𝗋(𝗍heta)^2 / 2, (𝗍heta, PI/2 + PI/6, 3PI/2 - PI/6))
	𝗂nner = 𝖾x(𝖺=>1, 𝖻=>1)
end

# ╔═╡ 23b7dfac-7657-11ec-368a-11725ca645a9
md"""The outer area (including the inner loop) is the integral from $0$ to $\pi/2 + \pi/6$ plus that from $3\pi/2 - \pi/6$ to $2\pi$. These areas are equal, so we double the first:
"""

# ╔═╡ 23b7ea6a-7657-11ec-175f-3d495ab51703
begin
	𝖾x1 = 2 * integrate(𝗋(𝗍heta)^2 / 2, (𝗍heta, 0, PI/2 + PI/6))
	𝗈uter = 𝖾x1(𝖺=>1, 𝖻=>1)
end

# ╔═╡ 23b7ea88-7657-11ec-0bfc-8b88e84cb0d9
md"""The answer is the difference:
"""

# ╔═╡ 23b7ec68-7657-11ec-077d-ff9e1a84e6e4
𝗈uter - 𝗂nner

# ╔═╡ 23b7ec86-7657-11ec-0f81-f37638dd2639
md"""## Arc length
"""

# ╔═╡ 23b7ecb8-7657-11ec-26a2-7f899333c9fd
md"""The length of the arc traced by a polar graph can also be expressed using an integral. Again, we partition the interval $[a,b]$ and consider the wedge from $(r(t_{i-1}), t_{i-1})$ to $(r(t_i), t_i)$. The curve this wedge approximates will have its arc length approximated by the line segment connecting the points. Expressing the points in Cartesian coordinates and simplifying gives the distance squared as:
"""

# ╔═╡ 23b7ecec-7657-11ec-0d5b-a311c3b7984a
md"""```math
\begin{align}
d_i^2 &= (r(t_i) \cos(t_i) - r(t_{i-1})\cos(t_{i-1}))^2 + (r(t_i) \sin(t_i) - r(t_{i-1})\sin(t_{i-1}))^2\\
&= r(t_i)^2 - 2r(t_i)r(t_{i-1}) \cos(t_i - t_{i-1}) +  r(t_{i-1})^2 \\
&\approx r(t_i)^2 - 2r(t_i)r(t_{i-1}) (1 - \frac{(t_i - t_{i-1})^2}{2})+  r(t_{i-1})^2 \quad(\text{as} \cos(x) \approx 1 - x^2/2)\\
&= (r(t_i) - r(t_{i-1}))^2 + r(t_i)r(t_{i-1}) (t_i - t_{i-1})^2.
\end{align}
```
"""

# ╔═╡ 23b7ed08-7657-11ec-14a9-4d2bbb102263
md"""As was done with arc length we multiply $d_i$ by $(t_i - t_{i-1})/(t_i - t_{i-1})$ and move the bottom factor under the square root:
"""

# ╔═╡ 23b7ed1e-7657-11ec-0273-11dc5475c328
md"""```math
\begin{align}
d_i
&= d_i \frac{t_i - t_{i-1}}{t_i - t_{i-1}} \\
&\approx \sqrt{\frac{(r(t_i) - r(t_{i-1}))^2}{(t_i - t_{i-1})^2} +
\frac{r(t_i)r(t_{i-1}) (t_i - t_{i-1})^2}{(t_i - t_{i-1})^2}} \cdot (t_i - t_{i-1})\\
&= \sqrt{(r'(\xi_i))^2 + r(t_i)r(t_{i-1})} \cdot (t_i - t_{i-1}).\quad(\text{the mean value theorem})
\end{align}
```
"""

# ╔═╡ 23b7ed30-7657-11ec-0a8f-dd773cc47ae6
md"""Adding the approximations to the $d_i$ looks like a Riemann sum approximation to the integral $\int_a^b \sqrt{(r'(\theta)^2) + r(\theta)^2} d\theta$ (with the extension to the Riemann sum formula needed to derive the arc length for a parameterized curve). That is:
"""

# ╔═╡ 23b7ee48-7657-11ec-00b7-651de17469eb
md"""> *Arc length of a polar curve*. The arc length of the curve described in polar coordinates by $r(\theta)$ for $a \leq \theta \leq b$ is given by:
>
> $\int_a^b \sqrt{r'(\theta)^2 + r(\theta)^2} d\theta.$

"""

# ╔═╡ 23b7ee8e-7657-11ec-3d1f-0b94b39e6640
md"""We test this out on a circle with $r(\theta) = R$, a constant. The integrand simplifies to just $\sqrt{R^2}$ and the integral is from $0$ to $2\pi$, so the arc length is $2\pi R$, precisely the formula for the circumference.
"""

# ╔═╡ 23b7eeac-7657-11ec-16a0-b7ffc891d5cd
md"""##### Example
"""

# ╔═╡ 23b7eed4-7657-11ec-312c-477c26986777
md"""A cardioid is described by $r(\theta) = 2(1 + \cos(\theta))$. What is the arc length from $0$ to $2\pi$?
"""

# ╔═╡ 23b7eefc-7657-11ec-1788-973cbf121104
md"""The integrand is integrable with antiderivative $4\sqrt{2\cos(\theta) + 2} \cdot \tan(\theta/2)$, but `SymPy` isn't able to find the integral. Instead we give a numeric answer:
"""

# ╔═╡ 23b7f546-7657-11ec-308d-d70bab39c17f
let
	r(theta) = 2*(1 + cos(theta))
	quadgk(t -> sqrt(r'(t)^2 + r(t)^2), 0, 2pi)[1]
end

# ╔═╡ 23b7f564-7657-11ec-15e3-df68254dc1f0
md"""##### Example
"""

# ╔═╡ 23b7f596-7657-11ec-07fd-f994cbbe119d
md"""The [equiangular](http://www-history.mcs.st-and.ac.uk/Curves/Equiangular.html) spiral has polar representation
"""

# ╔═╡ 23b7f5aa-7657-11ec-3bb5-79369c53f15d
md"""```math
r(\theta) = a e^{\theta \cot(b)}
```
"""

# ╔═╡ 23b7f5d2-7657-11ec-1642-ddeed0723647
md"""With $a=1$ and $b=\pi/4$, find the arc length traced out from $\theta=0$ to $\theta=1$.
"""

# ╔═╡ 23b7fafc-7657-11ec-2ab5-d32dde2ba55c
let
	a, b = 1, PI/4
	@syms θ
	r(theta) = a * exp(theta * cot(b))
	ds = sqrt(diff(r(θ), θ)^2 + r(θ)^2)
	integrate(ds, (θ, 0, 1))
end

# ╔═╡ 23b7fb0e-7657-11ec-1885-ef062d5e5a20
md"""##### Example
"""

# ╔═╡ 23b7fb2a-7657-11ec-089e-8d5ed8b4d165
md"""An Archimedean [spiral](http://en.wikipedia.org/wiki/Archimedean_spiral) is defined in polar form by
"""

# ╔═╡ 23b7fb40-7657-11ec-03e7-13d8d5b849c2
md"""```math
r(\theta) = a + b \theta
```
"""

# ╔═╡ 23b7fb5c-7657-11ec-1622-374e0faca0d2
md"""That is, the radius increases linearly. The crossings of the positive $x$ axis occur at $a + b n 2\pi$, so are evenly spaced out by $2\pi b$. These could be a model for such things as coils of materials of uniform thickness.
"""

# ╔═╡ 23b7fb86-7657-11ec-2e7c-0370e566bae4
md"""For example, a roll of toilet paper promises 1000 sheets with the [smaller](http://www.phlmetropolis.com/2011/03/the-incredible-shrinking-toilet-paper.php) $4.1 \times 3.7$ inch size. This $3700$ inch long connected sheet of paper is wrapped around a paper tube in an Archimedean spiral with $r(\theta) = d_{\text{inner}}/2 + b\theta$. The entire roll must fit in a standard dimension, so the outer diameter will be $d_{\text{outer}} = 5~1/4$ inches. Can we figure out $b$?
"""

# ╔═╡ 23b7fbae-7657-11ec-138d-53677f796acf
md"""Let $n$ be the number of windings and assume the starting and ending point is on the positive $x$ axis, $r(2\pi n) = d_{\text{outer}}/2 = d_{\text{inner}}/2 + b (2\pi n)$. Solving for $n$ in terms of $b$ we get: $n = ( d_{\text{outer}} - d_{\text{inner}})/2 / (2\pi b)$. With this, the following must hold as the total arc length is $3700$ inches.
"""

# ╔═╡ 23b7fbc2-7657-11ec-34f5-ed713a334142
md"""```math
\int_0^{n\cdot 2\pi} \sqrt{r(\theta)^2 + r'(\theta)^2} d\theta = 3700
```
"""

# ╔═╡ 23b7fbe0-7657-11ec-1e7f-91842280a38a
md"""Numerically then we have:
"""

# ╔═╡ 23b800ca-7657-11ec-26e4-e7cb0ec29bf8
let
	dinner = 1 + 5/8
	douter = 5 + 1/4
	r(b,t) = dinner/2 + b*t
	rp(b,t) = b
	integrand(b,t) = sqrt((r(b,t))^2 + rp(b,t)^2)  # sqrt(r^2 + r'^2)
	n(b) = (douter - dinner)/2/(2*pi*b)
	b = find_zero(b -> quadgk(t->integrand(b,t), 0, n(b)*2*pi)[1] - 3700, (1/100000, 1/100))
	b, b*25.4
end

# ╔═╡ 23b800f4-7657-11ec-08c0-d33078dbc2ea
md"""The value `b` gives a value in inches, the latter in millimeters.
"""

# ╔═╡ 23b80112-7657-11ec-2ef7-112cd5c6930e
md"""## Questions
"""

# ╔═╡ 23b8013a-7657-11ec-10d2-fb2a33ec3d58
md"""###### Question
"""

# ╔═╡ 23b80162-7657-11ec-2501-7d66824bdfac
md"""Let $r=3$ and $\theta=\pi/8$. In Cartesian coordinates what is $x$?
"""

# ╔═╡ 23b809d2-7657-11ec-2681-352a74ae1018
let
	x,y = 3 * [cos(pi/8), sin(pi/8)]
	numericq(x)
end

# ╔═╡ 23b809fa-7657-11ec-2a01-5d9165f2f5cf
md"""What is $y$?
"""

# ╔═╡ 23b80b8a-7657-11ec-01fa-715e95c6049c
let
	numericq(y)
end

# ╔═╡ 23b80b9e-7657-11ec-3b74-6f83a96b0d48
md"""###### Question
"""

# ╔═╡ 23b80bd8-7657-11ec-12c9-534b4deec227
md"""A point in Cartesian coordinates is given by $(-12, -5)$. In has a polar coordinate representation with an angle $\theta$ in $[0,2\pi]$ and $r > 0$. What is $r$?
"""

# ╔═╡ 23b81076-7657-11ec-3258-61f9bd70cacf
let
	x,y = -12, -5
	r1, theta1 = sqrt(x^2 + y^2), atan(y,x)
	numericq(r1)
end

# ╔═╡ 23b81094-7657-11ec-0e74-b58aae3ca875
md"""What is $\theta$?
"""

# ╔═╡ 23b81508-7657-11ec-1e50-350e87bf1ee9
let
	x,y = -12, -5
	r1, theta1 = sqrt(x^2 + y^2), atan(y,x)
	numericq(theta1)
end

# ╔═╡ 23b81526-7657-11ec-266e-eb0f89bd97f9
md"""###### Question
"""

# ╔═╡ 23b81544-7657-11ec-2680-d739a48e2699
md"""Does $r(\theta) = a \sec(\theta - \gamma)$ describe a line for $0$ when $a=3$ and $\gamma=\pi/4$?
"""

# ╔═╡ 23b817bc-7657-11ec-3528-0df49ec58315
let
	yesnoq("yes")
end

# ╔═╡ 23b817ee-7657-11ec-1d96-d7929a7f57b1
md"""If yes, what is the $y$ intercept
"""

# ╔═╡ 23b81e22-7657-11ec-3035-a7ee53f5de11
let
	r(theta) = 3 * sec(theta -pi/4)
	val = r(pi/2)
	numericq(val)
end

# ╔═╡ 23b81e36-7657-11ec-343d-19c5ee83454d
md"""What is slope of the line?
"""

# ╔═╡ 23b82460-7657-11ec-2e44-eda85d2dcb7c
let
	r(theta) == 3 * sec(theta -pi/4)
	val = (r(pi/2)*sin(pi/2) - r(pi/4)*sin(pi/4)) / (r(pi/2)*cos(pi/2) - r(pi/4)*cos(pi/4))
	numericq(val)
end

# ╔═╡ 23b82492-7657-11ec-2109-e9c8d00dd08b
md"""Does this seem likely: the slope is $-1/\tan(\gamma)$?
"""

# ╔═╡ 23b826e2-7657-11ec-15ef-9d542eabaecb
let
	yesnoq("yes")
end

# ╔═╡ 23b826f6-7657-11ec-02e6-4d40d42350e3
md"""###### Question
"""

# ╔═╡ 23b8270a-7657-11ec-3f3b-4d07c651b90b
md"""The polar curve $r(\theta) = 2\cos(\theta)$ has tangent lines at most points. This differential representation of the chain rule
"""

# ╔═╡ 23b82728-7657-11ec-17be-fd37595b70b7
md"""```math
\frac{dy}{dx} = \frac{dy}{d\theta} / \frac{dx}{d\theta},
```
"""

# ╔═╡ 23b8273c-7657-11ec-0f66-1171f1077766
md"""allows the slope to be computed when $y$ and $x$ are the Cartesian form of the polar curve. For this curve, we have
"""

# ╔═╡ 23b82750-7657-11ec-1991-dfaa731cbcfe
md"""```math
\frac{dy}{d\theta} = \frac{d}{d\theta}(2\cos(\theta) \cdot \cos(\theta)),~ \text{ and }
\frac{dx}{d\theta} = \frac{d}{d\theta}(2\sin(\theta) \cdot \cos(\theta)).
```
"""

# ╔═╡ 23b8276e-7657-11ec-3343-939680f36565
md"""Numerically, what is the slope of the tangent line when $\theta = \pi/4$?
"""

# ╔═╡ 23b82c0c-7657-11ec-180a-ad7d55c81d9f
let
	r(theta) = 2cos(theta)
	g(theta) = r(theta)*cos(theta)
	f(theta) = r(theta)*sin(theta)
	c = pi/4
	val = D(g)(c) / D(f)(c)
	numericq(val)
end

# ╔═╡ 23b82c28-7657-11ec-1f64-670cf96953f3
md"""###### Question
"""

# ╔═╡ 23b82c46-7657-11ec-20b4-3d77de5b9ae8
md"""For different values $k > 0$ and $e > 0$ the polar equation
"""

# ╔═╡ 23b82c64-7657-11ec-2673-5919fac03792
md"""```math
r(\theta) = \frac{ke}{1 + e\cos(\theta)}
```
"""

# ╔═╡ 23b82c82-7657-11ec-1de0-3f8d2a2f2d82
md"""has a familiar form. The value of $k$ is just a scale factor, but different values of $e$ yield different shapes.
"""

# ╔═╡ 23b82c96-7657-11ec-3f5a-d75c5881d9fc
md"""When $0 < e < 1$ what is the shape of the curve? (Answer by making a plot and guessing.)
"""

# ╔═╡ 23b834f2-7657-11ec-1d97-4d79ea7dc893
let
	choices = [
	"an ellipse",
	"a parabola",
	"a hyperbola",
	"a circle",
	"a line"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 23b8351a-7657-11ec-0747-8184c52864f7
md"""When $e = 1$ what is the shape of the curve?
"""

# ╔═╡ 23b83d30-7657-11ec-2af3-0517305b913d
let
	choices = [
	"an ellipse",
	"a parabola",
	"a hyperbola",
	"a circle",
	"a line"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 23b83d58-7657-11ec-11d2-835bc2517830
md"""When $1 < e$ what is the shape of the curve?
"""

# ╔═╡ 23b8456e-7657-11ec-189a-057e8f063336
let
	choices = [
	"an ellipse",
	"a parabola",
	"a hyperbola",
	"a circle",
	"a line"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 23b84582-7657-11ec-134f-e7de9bc45500
md"""###### Question
"""

# ╔═╡ 23b845be-7657-11ec-143c-a93120cac10b
md"""Find the area of a lobe of the [lemniscate](http://www-history.mcs.st-and.ac.uk/Curves/Lemniscate.html) curve traced out by $r(\theta) = \sqrt{\cos(2\theta)}$ between $-\pi/4$ and $\pi/4$. What is the answer?
"""

# ╔═╡ 23b84c00-7657-11ec-3012-7f2aee27579c
let
	choices = [
	"``1/2``",
	"``\\pi/2``",
	"``1``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 23b84c12-7657-11ec-2c3b-f740b99d3c1f
md"""###### Question
"""

# ╔═╡ 23b84c3a-7657-11ec-0d1a-35419edbbf3f
md"""Find the area of a lobe of the [eight](http://www-history.mcs.st-and.ac.uk/Curves/Eight.html) curve traced out by $r(\theta) = \cos(2\theta)\sec(\theta)^4$ from $-\pi/4$ to $\pi/4$. Do this numerically.
"""

# ╔═╡ 23b85356-7657-11ec-3594-b702d1dffd39
let
	r(theta) = sqrt(cos(2theta) * sec(theta)^4)
	val, _ = quadgk(t -> r(t)^2/2, -pi/4, pi/4)
	numericq(val)
end

# ╔═╡ 23b85374-7657-11ec-3a63-3724522891c7
md"""###### Question
"""

# ╔═╡ 23b8539c-7657-11ec-2184-e1f9e34e7038
md"""Find the arc length of a lobe of the [lemniscate](http://www-history.mcs.st-and.ac.uk/Curves/Lemniscate.html) curve traced out by $r(\theta) = \sqrt{\cos(2\theta)}$ between $-\pi/4$ and $\pi/4$. What is the answer (numerically)?
"""

# ╔═╡ 23b85950-7657-11ec-17f6-edc1349fa622
let
	r(theta) = sqrt(cos(2theta))
	val, _ = quadgk(t -> sqrt(D(r)(t)^2 + r(t)^2), -pi/4, pi/4)
	numericq(val)
end

# ╔═╡ 23b85964-7657-11ec-0549-f799a23e60ea
md"""###### Question
"""

# ╔═╡ 23b859a0-7657-11ec-2775-995a4a75ca3f
md"""Find the arc length of a lobe of the [eight](http://www-history.mcs.st-and.ac.uk/Curves/Eight.html) curve traced out by $r(\theta) = \cos(2\theta)\sec(\theta)^4$ from $-\pi/4$ to $\pi/4$. Do this numerically.
"""

# ╔═╡ 23b86062-7657-11ec-1e8b-7f6f0db5c86f
let
	r(theta) = sqrt(cos(2theta) * sec(theta)^4)
	val, _ = quadgk(t -> sqrt(D(r)(t)^2 + r(t)^2), -pi/4, pi/4)
	numericq(val)
end

# ╔═╡ 23b86082-7657-11ec-08a2-e78fa890566b
HTML("""<div class="markdown"><blockquote>
<p><a href="../ODEs/differential_equations.html">◅ previous</a>  <a href="../differentiable_vector_calculus/vectors.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/polar_coordinates.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 23b8609e-7657-11ec-0ef9-0dfabbc55ce8
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
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
git-tree-sha1 = "ffc6588e17bcfcaa79dfa5b4f417025e755f83fc"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "4.0.1"

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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "07608d027a73593e867b5c10e4907b86d25959af"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.14"

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
git-tree-sha1 = "6b6f04f93710c71550ec7e16b650c1b9a612d0b6"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.16.0"

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

[[deps.Dictionaries]]
deps = ["Indexing", "Random"]
git-tree-sha1 = "66bde31636301f4d217a161cabe42536fa754ec8"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.17"

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
git-tree-sha1 = "d7ab55febfd0907b285fbf8dc0c73c0825d9d6aa"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.3.0"

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
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "4a740db447aae0fbeb3ee730de1afbb14ac798a1"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.1"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "aa22e1ee9e722f1da183eb33370df4c1aeb6c2cd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.1+0"

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

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

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
git-tree-sha1 = "22df5b96feef82434b07327e2d3c770a9b21e023"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.0"

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
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

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
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

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
git-tree-sha1 = "db7393a80d0e5bef70f2b518990835541917a544"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

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
git-tree-sha1 = "37c1631cb3cc36a535105e6d5557864c82cd8c2b"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.0"

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
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

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

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "dec0812af1547a54105b4a6615f341377da92de6"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.0"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "b4912cd034cdf968e06ca5f943bb54b17b97793a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.5.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2ae4fe21e97cd13efd857462c1869b73c9f61be3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.2"

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
git-tree-sha1 = "d21f2c564b21a202f4677c0fba5b5ee431058544"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.4"

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
# ╟─23b8606c-7657-11ec-20bc-bbea59557f7d
# ╟─23762c88-7657-11ec-3f79-2dfe3c9f1445
# ╟─23789ba0-7657-11ec-3e97-f5276bfd4053
# ╠═2392d0cc-7657-11ec-27c3-478758bba72e
# ╟─2392d43c-7657-11ec-1d35-93231d7e0dc3
# ╟─2394c33e-7657-11ec-078c-d32bcbf0a624
# ╟─23978bbc-7657-11ec-2679-7f58b4056c73
# ╟─239a2066-7657-11ec-0d21-3dab2522f3b3
# ╟─239a20de-7657-11ec-1032-693f5a02fa66
# ╟─239a2886-7657-11ec-2611-533af20bfea8
# ╟─239bdfd4-7657-11ec-294b-9b8c9609a67e
# ╟─239ddb02-7657-11ec-14fd-79c04c8f61c9
# ╟─239ddbac-7657-11ec-1c8b-e32d30b333e1
# ╟─239ddbca-7657-11ec-3f6e-73efeb8221f2
# ╟─239ddbe8-7657-11ec-0fcc-87602fbf8667
# ╟─23a414f4-7657-11ec-1b52-ab8ae6ae2a7d
# ╟─23a4159e-7657-11ec-23ad-854d9dc9c1f5
# ╠═23a41de6-7657-11ec-2ad4-2b6638e48131
# ╟─23a41e04-7657-11ec-1a14-67ad6916403e
# ╠═23a42214-7657-11ec-266a-53379364b234
# ╟─23a42228-7657-11ec-3fe8-b5e4f407554a
# ╟─23a42b6a-7657-11ec-152e-8d2bcbe803db
# ╟─23a42b9c-7657-11ec-2a50-8dfb20a92f77
# ╟─23a42bc4-7657-11ec-111c-27f7cc76cd49
# ╟─23a42be2-7657-11ec-0a38-87aa5c378b94
# ╟─23a42bf6-7657-11ec-133e-4d9e28d31be4
# ╟─23a42c0a-7657-11ec-3b2b-37ec6a563e55
# ╟─23a42c28-7657-11ec-1250-bb3bcd92b20f
# ╟─23a42c46-7657-11ec-282b-15f6a0abc6ca
# ╟─23a6fc80-7657-11ec-011e-712b2bee7475
# ╟─23a82bdc-7657-11ec-106f-6bb117e08a1e
# ╠═23a838a4-7657-11ec-2a7e-bfd15770bee7
# ╟─23a8391c-7657-11ec-241b-43ab035c9e56
# ╟─23a83930-7657-11ec-3ea2-ff0c56b58496
# ╟─23a8394e-7657-11ec-3ffc-b1f198c0ca9f
# ╟─23a83962-7657-11ec-3e47-6d2638047614
# ╠═23a84038-7657-11ec-1831-535b0a49f3b9
# ╟─23a96cf6-7657-11ec-3718-1d34e14cee48
# ╟─23ac3e7c-7657-11ec-389f-4fa1f19acaeb
# ╟─23ac3f08-7657-11ec-313e-936966e50ceb
# ╟─23ac3f30-7657-11ec-335a-5f946e062fb0
# ╠═23ac494c-7657-11ec-2ebc-db1695eb1a8f
# ╟─23ac49f0-7657-11ec-3940-652b7188f0e4
# ╟─23ac4a16-7657-11ec-041c-3b9135a00be5
# ╟─23ac4a3e-7657-11ec-0a80-0bc8fa8d9610
# ╟─23ac4a5c-7657-11ec-1ea9-25020d684d64
# ╠═23ac51b4-7657-11ec-1c6b-8582d78f1463
# ╟─23ac522e-7657-11ec-2884-db418a98de8f
# ╠═23ac5be6-7657-11ec-2700-71819cbda1d1
# ╟─23ac5c0e-7657-11ec-2a48-35b8623f15fe
# ╠═23ac633c-7657-11ec-0198-1b248b957d85
# ╟─23ac635c-7657-11ec-0dc8-0defc3511d5a
# ╠═23ac6938-7657-11ec-1709-892ec547005b
# ╟─23ac696a-7657-11ec-3cba-e9d13ccda11e
# ╟─23ac6988-7657-11ec-24ae-c3cac5d83058
# ╟─23ac69a6-7657-11ec-314f-8fb50b08b9f5
# ╟─23ac69ce-7657-11ec-2481-8d2d049c52d9
# ╠═23ac7022-7657-11ec-3fb9-1564bad4f07b
# ╟─23ac7040-7657-11ec-3239-5db578dcd136
# ╟─23ac7068-7657-11ec-1e5b-6b85f62bb877
# ╠═23ac78f8-7657-11ec-37ed-457608a1da29
# ╟─23ac7932-7657-11ec-254c-314da19a1eee
# ╟─23ac796e-7657-11ec-374d-adc361b52eab
# ╠═23ac8116-7657-11ec-312d-fb786d3bd745
# ╟─23ac8136-7657-11ec-3908-e5491d4b4432
# ╟─23ac8152-7657-11ec-25e7-6de1f1bc24c2
# ╟─23ac8164-7657-11ec-058d-11ccde5518b5
# ╟─23ac8b84-7657-11ec-23bf-8d989e636b4e
# ╟─23ac8bc0-7657-11ec-18ab-75b07db99166
# ╟─23ac8c12-7657-11ec-3b00-8bc0fa5e79c9
# ╟─23b527c6-7657-11ec-37e4-f3a99781ca72
# ╟─23b52820-7657-11ec-003a-a70846081f6b
# ╠═23b531c6-7657-11ec-12ba-e59333b03d0d
# ╟─23b53202-7657-11ec-1bca-09924b2f4eb6
# ╟─23b53234-7657-11ec-060a-4f844f63cd0c
# ╟─23b53246-7657-11ec-182a-6bc05887d1c9
# ╠═23b53838-7657-11ec-20a1-8d3add4efe66
# ╟─23b53860-7657-11ec-1a37-c545a26931d4
# ╠═23b541f2-7657-11ec-29ae-a37d42d5a1d9
# ╟─23b7d14c-7657-11ec-299a-5fc300117bd7
# ╟─23b7d1d8-7657-11ec-3556-e5511ea18d8f
# ╟─23b7d980-7657-11ec-26e9-556f4c2f1dae
# ╟─23b7d9a8-7657-11ec-07dd-77caa915239c
# ╟─23b7d9ee-7657-11ec-3912-57d61473cb06
# ╠═23b7df84-7657-11ec-3e0d-290fe49c7f66
# ╟─23b7dfac-7657-11ec-368a-11725ca645a9
# ╠═23b7ea6a-7657-11ec-175f-3d495ab51703
# ╟─23b7ea88-7657-11ec-0bfc-8b88e84cb0d9
# ╠═23b7ec68-7657-11ec-077d-ff9e1a84e6e4
# ╟─23b7ec86-7657-11ec-0f81-f37638dd2639
# ╟─23b7ecb8-7657-11ec-26a2-7f899333c9fd
# ╟─23b7ecec-7657-11ec-0d5b-a311c3b7984a
# ╟─23b7ed08-7657-11ec-14a9-4d2bbb102263
# ╟─23b7ed1e-7657-11ec-0273-11dc5475c328
# ╟─23b7ed30-7657-11ec-0a8f-dd773cc47ae6
# ╟─23b7ee48-7657-11ec-00b7-651de17469eb
# ╟─23b7ee8e-7657-11ec-3d1f-0b94b39e6640
# ╟─23b7eeac-7657-11ec-16a0-b7ffc891d5cd
# ╟─23b7eed4-7657-11ec-312c-477c26986777
# ╟─23b7eefc-7657-11ec-1788-973cbf121104
# ╠═23b7f546-7657-11ec-308d-d70bab39c17f
# ╟─23b7f564-7657-11ec-15e3-df68254dc1f0
# ╟─23b7f596-7657-11ec-07fd-f994cbbe119d
# ╟─23b7f5aa-7657-11ec-3bb5-79369c53f15d
# ╟─23b7f5d2-7657-11ec-1642-ddeed0723647
# ╠═23b7fafc-7657-11ec-2ab5-d32dde2ba55c
# ╟─23b7fb0e-7657-11ec-1885-ef062d5e5a20
# ╟─23b7fb2a-7657-11ec-089e-8d5ed8b4d165
# ╟─23b7fb40-7657-11ec-03e7-13d8d5b849c2
# ╟─23b7fb5c-7657-11ec-1622-374e0faca0d2
# ╟─23b7fb86-7657-11ec-2e7c-0370e566bae4
# ╟─23b7fbae-7657-11ec-138d-53677f796acf
# ╟─23b7fbc2-7657-11ec-34f5-ed713a334142
# ╟─23b7fbe0-7657-11ec-1e7f-91842280a38a
# ╠═23b800ca-7657-11ec-26e4-e7cb0ec29bf8
# ╟─23b800f4-7657-11ec-08c0-d33078dbc2ea
# ╟─23b80112-7657-11ec-2ef7-112cd5c6930e
# ╟─23b8013a-7657-11ec-10d2-fb2a33ec3d58
# ╟─23b80162-7657-11ec-2501-7d66824bdfac
# ╟─23b809d2-7657-11ec-2681-352a74ae1018
# ╟─23b809fa-7657-11ec-2a01-5d9165f2f5cf
# ╟─23b80b8a-7657-11ec-01fa-715e95c6049c
# ╟─23b80b9e-7657-11ec-3b74-6f83a96b0d48
# ╟─23b80bd8-7657-11ec-12c9-534b4deec227
# ╟─23b81076-7657-11ec-3258-61f9bd70cacf
# ╟─23b81094-7657-11ec-0e74-b58aae3ca875
# ╟─23b81508-7657-11ec-1e50-350e87bf1ee9
# ╟─23b81526-7657-11ec-266e-eb0f89bd97f9
# ╟─23b81544-7657-11ec-2680-d739a48e2699
# ╟─23b817bc-7657-11ec-3528-0df49ec58315
# ╟─23b817ee-7657-11ec-1d96-d7929a7f57b1
# ╟─23b81e22-7657-11ec-3035-a7ee53f5de11
# ╟─23b81e36-7657-11ec-343d-19c5ee83454d
# ╟─23b82460-7657-11ec-2e44-eda85d2dcb7c
# ╟─23b82492-7657-11ec-2109-e9c8d00dd08b
# ╟─23b826e2-7657-11ec-15ef-9d542eabaecb
# ╟─23b826f6-7657-11ec-02e6-4d40d42350e3
# ╟─23b8270a-7657-11ec-3f3b-4d07c651b90b
# ╟─23b82728-7657-11ec-17be-fd37595b70b7
# ╟─23b8273c-7657-11ec-0f66-1171f1077766
# ╟─23b82750-7657-11ec-1991-dfaa731cbcfe
# ╟─23b8276e-7657-11ec-3343-939680f36565
# ╟─23b82c0c-7657-11ec-180a-ad7d55c81d9f
# ╟─23b82c28-7657-11ec-1f64-670cf96953f3
# ╟─23b82c46-7657-11ec-20b4-3d77de5b9ae8
# ╟─23b82c64-7657-11ec-2673-5919fac03792
# ╟─23b82c82-7657-11ec-1de0-3f8d2a2f2d82
# ╟─23b82c96-7657-11ec-3f5a-d75c5881d9fc
# ╟─23b834f2-7657-11ec-1d97-4d79ea7dc893
# ╟─23b8351a-7657-11ec-0747-8184c52864f7
# ╟─23b83d30-7657-11ec-2af3-0517305b913d
# ╟─23b83d58-7657-11ec-11d2-835bc2517830
# ╟─23b8456e-7657-11ec-189a-057e8f063336
# ╟─23b84582-7657-11ec-134f-e7de9bc45500
# ╟─23b845be-7657-11ec-143c-a93120cac10b
# ╟─23b84c00-7657-11ec-3012-7f2aee27579c
# ╟─23b84c12-7657-11ec-2c3b-f740b99d3c1f
# ╟─23b84c3a-7657-11ec-0d1a-35419edbbf3f
# ╟─23b85356-7657-11ec-3594-b702d1dffd39
# ╟─23b85374-7657-11ec-3a63-3724522891c7
# ╟─23b8539c-7657-11ec-2184-e1f9e34e7038
# ╟─23b85950-7657-11ec-17f6-edc1349fa622
# ╟─23b85964-7657-11ec-0549-f799a23e60ea
# ╟─23b859a0-7657-11ec-2775-995a4a75ca3f
# ╟─23b86062-7657-11ec-1e8b-7f6f0db5c86f
# ╟─23b86082-7657-11ec-08a2-e78fa890566b
# ╟─23b86094-7657-11ec-2e4d-a13efd825ff2
# ╟─23b8609e-7657-11ec-0ef9-0dfabbc55ce8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
