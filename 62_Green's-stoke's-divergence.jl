### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 036ec5fa-c191-11ec-29d1-872194acd003
begin
	using CalculusWithJulia
	using Plots
	using QuadGK
	using SymPy
end

# ╔═╡ 036ec9ba-c191-11ec-0cf2-c51111e66493
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	
	# some useful helpers for drawing
	_bar(x) = sum(x)/length(x)
	_shrink(x, xbar, offset) = xbar + (1-offset/100)*(x-xbar)
	
	function drawf!(p,f, m, dx)
	    a,b = m-dx, m+dx
	    xs = range(a,b,length=100)
	    plot!(p, [a,a,b,b],[f(a),0,0,f(b)], color=:black, linewidth=2)
	    plot!(p, xs, f.(xs), color=:blue, linewidth=3)
	    p
	end
	
	function apoly!(plt::Plots.Plot, ps; offset=5, kwargs...)
	    xs, ys = unzip(ps)
	    xbar, ybar = _bar.((xs, ys))
	    xs, ys = _shrink.(xs, xbar, offset), _shrink.(ys, ybar, offset)
	
	    plot!(plt, xs, ys; kwargs...)
	    xn = [xs[end],ys[end]]
	    x0 = [xs[1], ys[1]]
	    dxn = 0.95*(x0 - xn)
	
	    arrow!(plt, xn, dxn; kwargs...)
	
	    plt
	end
	apoly!(ps;offset=5,kwargs...) = apoly!(Plots.current(), ps; offset=offset, kwargs...)
	
	# arrow square
	# start 1,2,3,4: 1 upper left, 2 lower left
	function cpoly!(p, c, r, st=1, orient=:ccw; linewidth=1,linealpha=1.0, color=[:red,:red,:red,:black])
	
	    ps = [[-1,1], [1,1],[1,-1],[-1,-1]]
	    if orient == :ccw
	        ps = [[-1,1],[-1,-1],[1,-1],[1,1]]
	    end
	    k = 1
	    for i in st:(st+2)
	        plot!(p, unzip([c+r*ps[mod1(i,4)], c+r*ps[mod1(i+1,4)]])..., linewidth=linewidth, linealpha=linealpha, color=color[mod1(k,length(color))])
	        k = k+1
	    end
	        i = mod1(st+3,4)
	        j = mod1(i+1, 4)
	        arrow!(p, c+r*ps[i], 0.95*r*(ps[j]-ps[i]), linewidth=linewidth, linealpha= linealpha, color=color[mod1(k,length(color))])
	    p
	end
	
	
	nothing
end

# ╔═╡ 03705df2-c191-11ec-0651-3d97bc27de5f
using PlutoUI

# ╔═╡ 03705dcc-c191-11ec-2791-37df108552e1
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 036ebef2-c191-11ec-1a00-ff975d9b4df6
md"""# Green's Theorem, Stokes' Theorem, and the Divergence Theorem
"""

# ╔═╡ 036ebf24-c191-11ec-01f0-5beaea0911b4
md"""This section uses these add-on packages:
"""

# ╔═╡ 036ec9f6-c191-11ec-0bf3-c538ef2ca2be
md"""---
"""

# ╔═╡ 036eca84-c191-11ec-3390-e5f3f344e1be
md"""The fundamental theorem of calculus is a fan favorite, as it reduces a definite integral, $\int_a^b f(x) dx$, into the evaluation of a *related* function at two points: $F(b)-F(a)$, where the relation is $F$ is an *antiderivative* of $f$. It is a favorite, as it makes life much easier than the alternative of computing a limit of a Riemann sum.
"""

# ╔═╡ 036ecab6-c191-11ec-078b-c9a4b4753963
md"""This relationship can be generalized. The key is to realize that the interval $[a,b]$ has boundary $\{a, b\}$ (a set) and then expressing the theorem as: the integral around some region of $f$ is the integral, suitably defined, around the *boundary* of the region for a function *related* to $f$.
"""

# ╔═╡ 036ecad2-c191-11ec-34ee-09052b07d41b
md"""In an abstract setting, Stokes' theorem says exactly this with the relationship being the *exterior* derivative. Here we are not as abstract, we discuss below:
"""

# ╔═╡ 036ecc3a-c191-11ec-2b26-af86bc63450b
md"""  * Green's theorem, a $2$-dimensional theorem, where the region is a planar region, $D$, and the boundary a simple curve $C$;
  * Stokes' theorem in $3$ dimensions, where the region is an open surface, $S$, in $R^3$ with boundary, $C$;
  * The Divergence theorem in $3$ dimensions, where the region is a volume in three dimensions and the boundary its $2$-dimensional closed surface.
"""

# ╔═╡ 036ecc44-c191-11ec-3304-0bafa369f82a
md"""The related functions will involve the divergence and the curl, previously discussed.
"""

# ╔═╡ 036ecc8a-c191-11ec-2dc8-2bdb2ba2e217
md"""Many of the the examples in this section come from either [Strang](https://ocw.mit.edu/resources/res-18-001-calculus-online-textbook-spring-2005/) or [Schey](https://www.amazon.com/Div-Grad-Curl-All-That/dp/0393925161/).
"""

# ╔═╡ 036ecca8-c191-11ec-00d5-77e267a2959e
md"""To make the abstract concrete, consider the one dimensional case of finding the definite integral $\int_a^b F'(x) dx$. The Riemann sum picture at the *microscopic* level considers a figure like:
"""

# ╔═╡ 036ed432-c191-11ec-01c9-a1a79a2631cd
let
	a, b,n = 1/10,2, 10
	dx = (b-a)/n
	f(x) = x^x
	xs = range(a-dx/2, b+dx/2, length=251)
	ms = a:dx:b
	
	p = plot(legend=false, xticks=nothing, yticks=nothing, border=:none, ylim=(-1/2, f(b)+1/2))
	#plot!(p, xs, f.(xs), color=:blue, linewidth=3)
	for m in ms
	    drawf!(p, f, m, 0.9*dx/2)
	end
	annotate!([(ms[6]-dx/2,-0.3, L"x_{i-1}"), (ms[6]+dx/2,-0.3, L"x_{i}")])
	p
end

# ╔═╡ 036ed464-c191-11ec-1599-33af05e3d900
md"""The total area under the blue curve from $a$ to $b$, is found by adding the area of each segment of the figure.
"""

# ╔═╡ 036ed4aa-c191-11ec-0293-413cd241b439
md"""Let's consider now what an integral over the boundary would mean. The region, or interval, $[x_{i-1}, x_i]$ has a boundary that clearly consists of the two points $x_{i-1}$ and $x_i$. If we *orient* the boundary, as we need to for higher dimensional boundaries, using the outward facing direction, then the oriented boundary at the right-hand end point, $x_i$, would point towards $+\infty$ and the left-hand end point, $x_{i-1}$, would be oriented to point to $-\infty$. An "integral" on the boundary of $F$ would naturally be $F(b) \times 1$ plus $F(a) \times -1$, or $F(b)-F(a)$.
"""

# ╔═╡ 036ed4bc-c191-11ec-3a78-fb1519abffce
md"""With this choice of integral over the boundary, we can see much cancellation arises were we to compute this integral for each piece, as we would have with $a=x_0 < x_1 < \cdots x_{n-1} < x_n=b$:
"""

# ╔═╡ 036ed4ee-c191-11ec-2c89-b7a99cc458d2
md"""```math
~
(F(x_1) - F(x_0)) + (F(x_2)-F(x_1)) + \cdots + (F(x_n) - F(x_{n-1})) = F(x_n) - F(x_0) = F(b) - F(a).
~
```
"""

# ╔═╡ 036ed504-c191-11ec-3672-6b4980a88a80
md"""That is, with this definition for a boundary integral, the interior pieces of the microscopic approximation cancel and the total is just the integral over the oriented macroscopic boundary $\{a, b\}$.
"""

# ╔═╡ 036ed50e-c191-11ec-08a3-b570451d2c53
md"""But each microscopic piece can be reimagined, as
"""

# ╔═╡ 036ed522-c191-11ec-1b56-8fdf1c87fb1a
md"""```math
~
F(x_{i}) - F(x_{i-1}) = \left(\frac{F(x_{i}) - F(x_{i-1})}{\Delta{x}}\right)\Delta{x}
\approx F'(x_i)\Delta{x}.
~
```
"""

# ╔═╡ 036ed54a-c191-11ec-0cd5-cbf9476253ca
md"""The approximation could be exact were the mean value theorem used to identify a point in the interval, but we don't pursue that, as the key point is the right hand side is a Riemann sum approximation for a *different* integral, in this case the integral $\int_a^b F'(x) dx$. Passing from the microscopic view to an infinitesimal view, the picture gives two interpretations, leading to the Fundamental Theorem of Calculus:
"""

# ╔═╡ 036ed554-c191-11ec-2d17-9b1cd8ac81e8
md"""```math
~
\int_a^b F'(x) dx = F(b) - F(a).
~
```
"""

# ╔═╡ 036ed572-c191-11ec-02f0-f745035b31db
md"""The three theorems of this section, Green's theorem, Stokes' theorem, and the divergence theorem, can all be seen in this manner: the sum of microscopic boundary integrals leads to a macroscopic boundary integral of the entire region; whereas, by reinterpretation, the microscopic boundary integrals are viewed as Riemann sums, which in the limit become integrals of a *related* function over the region.
"""

# ╔═╡ 036ed592-c191-11ec-2431-abb09d8d6157
md"""## Green's theorem
"""

# ╔═╡ 036ed5a4-c191-11ec-25aa-d726f13c6549
md"""To continue the above analysis for a higher dimension, we consider the following figure hinting at a decomposition of a macroscopic square into subsequent microscopic sub-squares. The boundary of each square is oriented so that the right hand rule comes out of the picture.
"""

# ╔═╡ 036ed978-c191-11ec-1816-1934185b7627
let
	a = 1
	ps = [[0,a],[0,0],[a,0],[a,a]]
	p = plot(; legend=false, aspect_ratio=:equal, xticks=nothing, yticks=nothing,  border=:none)
	apoly!(p, ps, linewidth=3, color=:blue)
	a = 1/2
	ps = [[0,a],[0,0],[a,0],[a,a]]
	del = 2/100
	apoly!(p, ([del,del],) .+ ps, linewidth=3, color=:red, offset=20)
	apoly!(p, ([0+del,a-del],) .+ ps, linewidth=3, color=:red, offset=20)
	apoly!(p, ([a-del,0+del],) .+ ps, linewidth=3, color=:red, offset=20)
	apoly!(p, ([a-del,a-del],) .+ ps, linewidth=3, color=:red, offset=20)
	
	a = 1/4
	ps = [[del,del]] .+ [[0,a],[0,0],[a,0],[a,a]]
	del = 4/100
	apoly!(p, ([del,del],) .+ ps, linewidth=3, color=:green, offset=40)
	apoly!(p, ([0+del,a-del],) .+ ps, linewidth=3, color=:green, offset=40)
	apoly!(p, ([a-del,0+del],) .+ ps, linewidth=3, color=:green, offset=40)
	apoly!(p, ([a-del,a-del],) .+ ps, linewidth=3, color=:green, offset=40)
	
	p
end

# ╔═╡ 036ed9d2-c191-11ec-3ced-57eaec9ae14a
md"""Consider the boundary integral $\oint_c F\cdot\vec{T} ds$ around the smallest (green) squares. We have seen that the *curl* at a point in a direction is given in terms of the limit. Let the plane be the $x-y$ plane, and the $\hat{k}$ direction be the one coming out of the figure. In the derivation of the curl, we saw that the line integral for circulation around the square satisfies:
"""

# ╔═╡ 036ed9e6-c191-11ec-3326-41118c33ed43
md"""```math
~
\lim \frac{1}{\Delta{x}\Delta{y}} \oint_C F \cdot\hat{T}ds =
 \frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}.
~
```
"""

# ╔═╡ 036ed9f0-c191-11ec-0bf8-5327536a0e65
md"""If the green squares are small enough, then the line integrals satisfy:
"""

# ╔═╡ 036eda04-c191-11ec-01bf-e13b9d6e569b
md"""```math
~
\oint_C F \cdot\hat{T}ds
\approx
\left(
\frac{\partial{F_y}}{\partial{x}}
-
\frac{\partial{F_x}}{\partial{y}}
\right) \Delta{x}\Delta{y} .
~
```
"""

# ╔═╡ 036eda18-c191-11ec-008c-ad4d208f8727
md"""We interpret the right hand side as a Riemann sum approximation for the $2$ dimensional integral of the function $f(x,y) = \frac{\partial{F_x}}{\partial{y}} - \frac{\partial{F_y}}{\partial{x}}=\text{curl}(F)$, the two-dimensional curl. Were the green squares continued to fill out the large blue square, then the sum of these terms would approximate the integral
"""

# ╔═╡ 036eda40-c191-11ec-347b-3fbb76990483
md"""```math
~
\iint_S f(x,y) dA = \iint_S
\left(\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}\right) dA
= \iint_S \text{curl}(F) dA.
~
```
"""

# ╔═╡ 036eda68-c191-11ec-0279-9b6cb52ac757
md"""However, the microscopic boundary integrals have cancellations that lead to a macroscopic boundary integral.  The sum of $\oint_C F \cdot\hat{T}ds$ over the $4$ green squares will be equal to $\oint_{C_r} F\cdot\hat{T}ds$, where $C_r$ is the red square, as the interior line integral pieces will all cancel off. The sum of $\oint_{C_r} F \cdot\hat{T}ds$ over the $4$ red squares will equal $\oint_{C_b} F \cdot\hat{T}ds$, where $C_b$ is the oriented path around the blue square, as again the interior line pieces will cancel off. Etc.
"""

# ╔═╡ 036eda90-c191-11ec-2642-1b666bc9afcb
md"""This all suggests that the flow integral around the surface of the larger region (the blue square) is equivalent to the integral of the curl component over the region. This is [Green](https://en.wikipedia.org/wiki/Green%27s_theorem)'s theorem, as stated by Wikipedia:
"""

# ╔═╡ 036edb9e-c191-11ec-3d21-8d922724a42a
md"""> **Green's theorem**: Let $C$ be a positively oriented, piecewise smooth, simple closed curve in the plane, and let $D$ be the region bounded by $C$. If $F=\langle F_x, F_y\rangle$, is a vector field on an open region containing $D$  having continuous partial derivatives then:
>
> ```math
> \oint_C F\cdot\hat{T}ds =
> \iint_D \left(
> \frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}
> \right) dA=
> \iint_D \text{curl}(F)dA.
> ```

"""

# ╔═╡ 036edba8-c191-11ec-04dc-43a7499b95e7
md"""The statement of the theorem applies only to regions whose boundaries are simple closed curves. Not all simple regions have such boundaries. An annulus for example. This is a restriction that will be generalized.
"""

# ╔═╡ 036edbda-c191-11ec-2609-5fc5d9cffd37
md"""### Examples
"""

# ╔═╡ 036edbe4-c191-11ec-17a2-71a705fcd3e3
md"""Some examples, following Strang, are:
"""

# ╔═╡ 036edc0c-c191-11ec-39fe-fb4eb6bee943
md"""#### Computing area
"""

# ╔═╡ 036edc2a-c191-11ec-063a-c74ae8e51510
md"""Let $F(x,y) = \langle -y, x\rangle$. Then $\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}=2$, so
"""

# ╔═╡ 036edc3e-c191-11ec-257d-8384f2d34f06
md"""```math
~
\frac{1}{2}\oint_C F\cdot\hat{T}ds = \frac{1}{2}\oint_C (xdy - ydx) =
\iint_D dA = A(D).
~
```
"""

# ╔═╡ 036edc52-c191-11ec-2d16-6b95a1fb29c3
md"""This gives a means to compute the area of a region by integrating around its boundary.
"""

# ╔═╡ 036edc68-c191-11ec-09cc-1b5a25e08cf6
md"""---
"""

# ╔═╡ 036edc70-c191-11ec-03db-9da639d27727
md"""To compute the area of an ellipse, we have:
"""

# ╔═╡ 036ee1ca-c191-11ec-1af7-8be1026c3258
md"""To compute the area of the triangle with vertices $(0,0)$, $(a,0)$ and $(0,b)$ we can orient the boundary counter clockwise. Let $A$ be the line segment from $(0,b)$ to $(0,0)$, $B$ be the line segment from $(0,0)$ to $(a,0)$, and $C$ be the other. Then
"""

# ╔═╡ 036ee1e8-c191-11ec-3bf3-1122682cdc39
md"""```math
~
\begin{align}
\frac{1}{2} \int_A F\cdot\hat{T} ds &=\frac{1}{2} \int_A -ydx = 0\\
\frac{1}{2} \int_B F\cdot\hat{T} ds &=\frac{1}{2} \int_B xdy = 0,
\end{align}
~
```
"""

# ╔═╡ 036ee210-c191-11ec-3d21-e5c177c3cb51
md"""as on $A$, $y=0$ and $dy=0$ and on $B$, $x=0$ and $dx=0$.
"""

# ╔═╡ 036ee224-c191-11ec-26b5-5bc0793aa68a
md"""On $C$ we have $\vec{r}(t) = (0, b) + t\cdot(1,-b/a) =\langle t, b-(bt)/a\rangle$ from $t=a$ to $0$
"""

# ╔═╡ 036ee24c-c191-11ec-1aac-ef15f6dc51d9
md"""```math
~
\int_C F\cdot \frac{d\vec{r}}{dt} dt =
\int_a^0 \langle -b + (bt)/a), t\rangle\cdot\langle 1, -b/a\rangle dt
= \int_a^0 -b dt = -bt\mid_{a}^0 = ba.
~
```
"""

# ╔═╡ 036ee268-c191-11ec-1bd4-f7bc23187a02
md"""Dividing by $1/2$ give the familiar answer $A=(1/2) a b$.
"""

# ╔═╡ 036ee27e-c191-11ec-1e03-2f42167bcf24
md"""#### Conservative fields
"""

# ╔═╡ 036ee292-c191-11ec-2ac9-359f1c736a2c
md"""A vector field is conservative if path integrals for work are independent of the path. We have seen that a vector field that is the gradient of a scalar field will be conservative and vice versa. This led to the vanishing identify $\nabla\times\nabla(f) = 0$ for a scalar field $f$.
"""

# ╔═╡ 036ee2ce-c191-11ec-3340-bdaba09dc85a
md"""Is the converse true? Namely, *if* for some vector field $F$, $\nabla\times{F}$ is identically $0$ is the field conservative?
"""

# ╔═╡ 036ee2ec-c191-11ec-3ef6-83010fdb3c02
md"""The answer is yes – if the vector field has continuous partial derivatives and the curl is $0$ in a simply connected domain.
"""

# ╔═╡ 036ee30c-c191-11ec-3c95-4fe02f5c662b
md"""For the two dimensional case the curl is a scalar. *If* $F = \langle F_x, F_y\rangle = \nabla{f}$ is conservative, then $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y} = 0$.
"""

# ╔═╡ 036ee350-c191-11ec-3756-d58423488de3
md"""Now assume $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y} = 0$. Let $P$ and $Q$ be two points in the plane. Take any path, $C_1$ from $P$ to $Q$ and any return path, $C_2$, from $Q$ to $P$ that do not cross and such that $C$, the concatenation of the two paths, satisfies Green's theorem. Then, as $F$ is continuous on an open interval containing $D$, we have:
"""

# ╔═╡ 036ee364-c191-11ec-3057-cd57202c843f
md"""```math
~
0 = \iint_D 0 dA =
\iint_D \left(\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y}\right)dA =
\oint_C F \cdot \hat{T} ds =
\int_{C_1} F \cdot \hat{T} ds + \int_{C_2}F \cdot \hat{T} ds.
~
```
"""

# ╔═╡ 036ee382-c191-11ec-0f1e-efdc62eab92a
md"""Reversing $C_2$ to go from $P$ to $Q$, we see the two work integrals are identical, that is the field is conservative.
"""

# ╔═╡ 036ee3aa-c191-11ec-35a1-f5506813b4ea
md"""Summarizing:
"""

# ╔═╡ 036ee440-c191-11ec-2e76-c97bad11673b
md"""  * If $F=\nabla{f}$ then $F$ is conservative.
  * If $F=\langle F_x, F_y\rangle$ has *continuous* partial derivatives in a simply connected open region with $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y}=0$, then in that region $F$ is conservative and can be represented as the gradient of a scalar function.
"""

# ╔═╡ 036ee468-c191-11ec-050c-ff74502b29e8
md"""For example, let $F(x,y) = \langle \sin(xy), \cos(xy) \rangle$. Is this a conservative vector field?
"""

# ╔═╡ 036ee474-c191-11ec-0d57-bdcf93840701
md"""We can check by taking partial derivatives. Those of interest are:
"""

# ╔═╡ 036ee490-c191-11ec-30ce-d37779dd80a2
md"""```math
~
\begin{align}
\frac{\partial{F_y}}{\partial{x}} &= \frac{\partial{(\cos(xy))}}{\partial{x}} =
-\sin(xy) y,\\
\frac{\partial{F_x}}{\partial{y}} &= \frac{\partial{(\sin(xy))}}{\partial{y}} =
\cos(xy)x.
\end{align}
~
```
"""

# ╔═╡ 036ee4ae-c191-11ec-0049-318cb168fd7d
md"""It is not the case that  $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y}=0$, so this vector field is *not* conservative.
"""

# ╔═╡ 036ee4c2-c191-11ec-0c20-55e5857221ac
md"""---
"""

# ╔═╡ 036ee4e0-c191-11ec-314d-ed28839e584c
md"""The conditions of Green's theorem are important, as this next example shows.
"""

# ╔═╡ 036ee4f4-c191-11ec-1256-775e936d442a
md"""Let $D$ be the unit disc, $C$ the unit circle parameterized counter clockwise.
"""

# ╔═╡ 036ee4fe-c191-11ec-1a80-212e1ee1d9f3
md"""Let $R(x,y) = \langle -y, x\rangle$ be a rotation field and $F(x,y) = R(x,y)/(R(x,y)\cdot R(x,y))$. Then:
"""

# ╔═╡ 036eeae4-c191-11ec-3d2e-8928fe03ae26
@syms x::real y::real z::real t::real

# ╔═╡ 036ee184-c191-11ec-05c7-eda5a244277d
let
	F(x,y) = [-y,x]
	F(v) = F(v...)
	
	r(t) = [a*cos(t),b*sin(t)]
	
	@syms a::positive b::positive
	(1//2) * integrate( F(r(t)) ⋅ diff.(r(t),t), (t, 0, 2PI))
end

# ╔═╡ 036eef9e-c191-11ec-152e-a3c4e307bcff
let
	R(x,y) = [-y,x]
	F(x,y) = R(x,y)/(R(x,y)⋅R(x,y))
	
	Fx, Fy = F(x,y)
	diff(Fy, x) - diff(Fx, y) |> simplify
end

# ╔═╡ 036eefc6-c191-11ec-3fae-6941995f5a0c
md"""As the integrand is $00$,  $\iint_D \left( \partial{F_y}/{\partial{x}}-\partial{F_xy}/{\partial{y}}\right)dA = 0$, as well. But,
"""

# ╔═╡ 036eefe2-c191-11ec-0e48-0f74c7c87253
md"""```math
~
F\cdot\hat{T} = \frac{R}{R\cdot{R}} \cdot \frac{R}{R\cdot{R}} = \frac{R\cdot{R}}{(R\cdot{R})^2} = \frac{1}{R\cdot{R}},
~
```
"""

# ╔═╡ 036eeff8-c191-11ec-1c2e-7b5a1ce84bef
md"""so $\oint_C F\cdot\hat{T}ds = 2\pi$, $C$ being the unit circle so $R\cdot{R}=1$.
"""

# ╔═╡ 036ef046-c191-11ec-1aa0-490624be0413
md"""That is, for this example, Green's theorem does **not** apply, as the two integrals are not the same. What isn't satisfied in the theorem?  $F$ is not continuous at the origin and our curve $C$ defining $D$ encircles the origin. So, $F$ does not have continuous partial derivatives, as is required for the theorem.
"""

# ╔═╡ 036ef066-c191-11ec-05fd-21c75c47fc0a
md"""#### More complicated boundary curves
"""

# ╔═╡ 036ef07a-c191-11ec-2538-91d4122c7a49
md"""A simple closed curve is one that does not cross itself. Green's theorem applies to regions bounded by curves which have finitely many crosses provided the orientation used is consistent throughout.
"""

# ╔═╡ 036ef0b8-c191-11ec-18e8-91238b4ba357
md"""Consider the curve $y = f(x)$, $a \leq x \leq b$, assuming $f$ is continuous, $f(a) > 0$, and $f(b) < 0$. We can use Green's theorem to compute the signed "area" under under $f$ if we consider the curve in $R^2$ from $(b,0)$ to $(a,0)$ to $(a, f(a))$, to $(b, f(b))$ and back to $(b,0)$ in that orientation. This will cross at each zero of $f$.
"""

# ╔═╡ 036ef6ea-c191-11ec-034d-bf4e3ac166ff
let
	a, b = pi/2, 3pi/2
	f(x) = sin(x)
	p = plot(f, a, b, legend=false,  xticks=nothing,  border=:none, color=:green)
	arrow!(p, [3pi/4, f(3pi/4)], 0.01*[1,cos(3pi/4)], color = :green)
	arrow!(p, [5pi/4, f(5pi/4)], 0.01*[1,cos(5pi/4)], color = :green)
	arrow!(p, [a,0], [0, f(a)], color=:red)
	arrow!(p, [b, f(b)], [0, -f(b)], color=:blue)
	arrow!(p, [b, 0], [a-b, 0], color=:black)
	del = -0.1
	annotate!(p, [(a,del, "a"), (b,-del,"b")])
	p
end

# ╔═╡ 036ef732-c191-11ec-3ff5-a51bc68d206b
md"""Let $A$ label the red line, $B$ the green curve, $C$ the blue line, and $D$ the black line. Then the area is given from Green's theorem by considering half of the the line integral of $F(x,y) = \langle -y, x\rangle$ or $\oint_C (xdy - ydx)$. To that matter we have:
"""

# ╔═╡ 036ef746-c191-11ec-0dc1-f17b77398106
md"""```math
~
\begin{align}
\int_A (xdy - ydx) &= a f(a)\\
\int_C (xdy - ydx) &= b(-f(b))\\
\int_D (xdy - ydx) &= 0\\
\end{align}
~
```
"""

# ╔═╡ 036ef76e-c191-11ec-18bb-cbf909dd536d
md"""Finally the integral over $B$, using integration by parts:
"""

# ╔═╡ 036ef796-c191-11ec-01c4-ed8167e2efb8
md"""```math
~
\begin{align}
\int_B F(\vec{r}(t))\cdot \frac{d\vec{r}(t)}{dt} dt &=
\int_b^a \langle -f(t),t)\rangle\cdot\langle 1, f'(t)\rangle dt\\
&= \int_a^b f(t)dt - \int_a^b tf'(t)dt\\
&= \int_a^b f(t)dt - \left(tf(t)\mid_a^b - \int_a^b f(t) dt\right).
\end{align}
~
```
"""

# ╔═╡ 036ef7b4-c191-11ec-3293-1186eac9eb90
md"""Combining, we have after cancellation $\oint (xdy - ydx) = 2\int_a^b f(t) dt$, or after dividing by $2$ the signed area under the curve.
"""

# ╔═╡ 036ef7c0-c191-11ec-31fc-6fb7c3d65741
md"""---
"""

# ╔═╡ 036ef7e6-c191-11ec-1bbd-41799799748e
md"""The region may not be simply connected. A simple case might be the disc: $1 \leq x^2 + y^2 \leq 4$. In this figure we introduce a cut to make a simply connected region.
"""

# ╔═╡ 036efcaa-c191-11ec-0afd-0149ef3207ed
let
	a, b = 1, 2
	theta = pi/48
	alpha = asin(b/a*sin(theta))
	f1(t) = b*[cos(t), sin(t)]
	f2(t) = a*[cos(t), sin(t)]
	yflip(x) = [x[1],-x[2]]
	p = plot(unzip(f1, theta, 2pi-theta)..., legend=false, aspect_ratio=:equal, color=:blue)
	plot!(p, unzip(f2, alpha, 2pi-alpha)..., color=:red)
	arrow!(p, [0,2], [-.1,0], color=:blue)
	arrow!(p, [0,1], [.1,0], color=:red)
	arrow!(p, yflip(f1(theta)), yflip(f2(alpha)) - yflip(f1(theta)), color=:green)
	arrow!(p, f2(alpha), f1(theta) - f2(alpha), color=:black)
	p
end

# ╔═╡ 036efcdc-c191-11ec-20a6-fbcc0edaba0a
md"""The cut leads to a counter-clockwise orientation  on the outer ring and a clockwise orientation on the inner ring. If this cut becomes so thin as to vanish, then the line integrals along the lines introducing the cut will cancel off and we have a boundary consisting of two curves with opposite orientations. (If we follow either orientation the closed figure is on the left.)
"""

# ╔═╡ 036efd04-c191-11ec-1624-51216538e725
md"""To see that the area integral of $F(x,y) = (1/2)\langle -y, x\rangle$ produces the area for this orientation we have, using $C_1$ as the outer ring, and $C_2$ as the inner ring:
"""

# ╔═╡ 036efd2e-c191-11ec-3a01-535d0dcbb7bb
md"""```math
~
\begin{align}
\oint_{C_1} F \cdot \hat{T} ds &=
\int_0^{2\pi} (1/2)(2)\langle -\sin(t), \cos(t)\rangle \cdot (2)\langle-\sin(t), \cos(t)\rangle dt
= (1/2) (2\pi) 4 = 4\pi\\
\oint_{C_2} F \cdot \hat{T} ds &=
\int_{0}^{2\pi}  (1/2) \langle \sin(t), \cos(t)\rangle \cdot \langle-\sin(t), -\cos(t)\rangle dt\\
&= -(1/2)(2\pi) = -\pi.
\end{align}
~
```
"""

# ╔═╡ 036efd4a-c191-11ec-233b-49e969b3b477
md"""(Using $\vec{r}(t) = 2\langle \cos(t), \sin(t)\rangle$ for the outer ring and $\vec{r}(t) = 1\langle \cos(t), -\sin(t)\rangle$ for the inner ring.)
"""

# ╔═╡ 036efd60-c191-11ec-120e-c3ebd633aa56
md"""Adding the two gives $4\pi - \pi = \pi \cdot(b^2 - a^2)$, with $b=2$ and $a=1$.
"""

# ╔═╡ 036efd8e-c191-11ec-2781-8969e4ad082f
md"""#### Flow not flux
"""

# ╔═╡ 036efdb8-c191-11ec-3c54-4bd9c3e1ee31
md"""Green's theorem has a complement in terms of flow across $C$. As $C$ is positively oriented (so the bounded interior piece is on the left of $\hat{T}$ as the curve is traced), a normal comes by rotating $90^\circ$ counterclockwise. That is if $\hat{T} = \langle a, b\rangle$, then $\hat{N} = \langle b, -a\rangle$.
"""

# ╔═╡ 036efdcc-c191-11ec-02bc-874a409b2ec8
md"""Let $F = \langle F_x, F_y \rangle$ and $G = \langle F_y, -F_x \rangle$, then $G\cdot\hat{T} = -F\cdot\hat{N}$. The curl formula applied to $G$ becomes
"""

# ╔═╡ 036efde0-c191-11ec-1699-112206b6caed
md"""```math
~
\frac{\partial{G_y}}{\partial{x}} - \frac{\partial{G_x}}{\partial{y}} =
\frac{\partial{-F_x}}{\partial{x}}-\frac{\partial{(F_y)}}{\partial{y}}
=
-\left(\frac{\partial{F_x}}{\partial{x}} + \frac{\partial{F_y}}{\partial{y}}\right)=
-\nabla\cdot{F}.
~
```
"""

# ╔═╡ 036efe08-c191-11ec-1bda-abf11e4b05ae
md"""Green's theorem applied to $G$ then gives this formula for $F$:
"""

# ╔═╡ 036efe12-c191-11ec-217d-7b939b854596
md"""```math
~
\oint_C F\cdot\hat{N} ds =
-\oint_C G\cdot\hat{T} ds =
-\iint_D (-\nabla\cdot{F})dA =
\iint_D \nabla\cdot{F}dA.
~
```
"""

# ╔═╡ 036efe30-c191-11ec-3606-41b34454115b
md"""The right hand side integral is the $2$-dimensional divergence, so this has the interpretation that the flux through $C$ ($\oint_C F\cdot\hat{N} ds$) is the integral of the divergence. (The divergence is defined in terms of a limit of this picture, so this theorem extends the microscopic view to a bigger view.)
"""

# ╔═╡ 036efe58-c191-11ec-3761-b9ceb1ce4a03
md"""Rather than leave this as an algebraic consequence, we sketch out how this could be intuitively argued from a microscopic picture, the reason being similar to that for the curl, where we considered the small green boxes. In the generalization to dimension $3$ both arguments are needed for our discussion:
"""

# ╔═╡ 036f0b50-c191-11ec-32ca-bb32f8876248
let
	## This isn't used
	r4(t) = cos(2t) + sqrt(1.5^4 - sin(2t)^2)
	ts = range(0, pi/2, length=100)
	f(t) = r4(t) * [cos(t),sin(t)]
	plot(unzip(f, 0, pi/2)..., xticks=nothing, yticks=nothing,  border=:none, legend=false, aspect_ratio=:equal)
	t0 = pi/6
	xs = f.(t0)
	ys = f'.(t0)
	plot!(unzip([f(t0)+1/5*ys, f(t0)-1/5*ys])..., color=:red)
	arrow!(f(t0),1/5*xs, color=:red)
	arrow!(f(t0), -1/10*[-ys[2],ys[1]], color=:black)
	arrow!(f(t0),-1/5*xs, color=:red, linestyle=:dash)
	arrow!(f(t0), 1/10*[-ys[2],ys[1]], color=:black, linestyle=:dash)
	nothing
end

# ╔═╡ 036f0baa-c191-11ec-008c-f156c82729f7
md"""Consider now a $2$-dimensional region  split into microscopic boxes;  we focus now on two adjacent boxes, $A$ and $B$:
"""

# ╔═╡ 036f0f9c-c191-11ec-1d61-5fadef8ca827
let
	a = 1
	ps = [[0,a],[0,0],[a,0],[a,a]]
	p = plot(; legend=false, aspect_ratio=:equal, xticks=nothing,  border=:none, yticks=nothing)
	apoly!(p, ps, linewidth=3, color=:blue)
	apoly!(p, ([1,0],) .+ ps, linewidth=3, color=:red)
	pt = [1, 1/4]
	scatter!(unzip([pt])..., markersize=4, color=:green)
	arrow!(pt, [1/2,1/4], linewidth=3, color=:green)
	arrow!(pt, [1/4,0], color=:blue )
	arrow!(pt, -[1/4, 0], color=:red)
	annotate!([(7/8, 1/8, "A"), (1+7/8, 1/8, "B")])
	p
end

# ╔═╡ 036f0fe2-c191-11ec-151c-c768c18256b2
md"""The integrand $F\cdot\hat{N}$ for $A$ will differ from that for $B$ by a minus sign, as the field is the same, but the  normal carries an opposite sign. Hence the contribution to the line integral around $A$ along this part of the box partition will cancel out with that around $B$. The only part of the line integral that will not cancel out for such a partition will be the boundary pieces of the overall shape.
"""

# ╔═╡ 036f0ff6-c191-11ec-0559-df3acb136e9f
md"""This figure shows in red the parts of the line integrals that will cancel for a more refined grid.
"""

# ╔═╡ 036f1886-c191-11ec-3d9a-d74a8a13b9dd
let
	p = plot( legend=false, xticks=nothing, yticks=nothing,  border=:none)
	for i in 1:8
	
	    for j in 1:8
	        color = repeat([:red],4)
	        st = 1
	        if i == 1
	            color[1] = :black
	            st = 2
	        elseif i==8
	            color[3] = :black
	            st = 4
	        end
	        if j == 1
	            color[2] = :black
	            st = 3
	        elseif j == 8
	            color[4] = :black
	            st = 1
	        end
	    cpoly!(p, [i-1/2, j-1/2], .8*1/2,1, :ccw, linewidth=3,linealpha=0.5, color=color)
	    end
	end
	p
end

# ╔═╡ 036f18ac-c191-11ec-0878-efa24c224c16
md"""Again, the microscopic boundary integrals when added will give a macroscopic boundary integral due to cancellations.
"""

# ╔═╡ 036f18ca-c191-11ec-3489-bdf607aa97a5
md"""But, as seen in the derivation of the divergence, only modified for $2$ dimensions, we have $\nabla\cdot{F} = \lim \frac{1}{\Delta S} \oint_C F\cdot\hat{N}$, so for each cell
"""

# ╔═╡ 036f18ea-c191-11ec-2cfb-d1459217d9ca
md"""```math
~
\oint_{C_i} F\cdot\hat{N} \approx \left(\nabla\cdot{F}\right)\Delta{x}\Delta{y},
~
```
"""

# ╔═╡ 036f18fc-c191-11ec-338c-616ce9ca83db
md"""an approximating Riemann sum for $\iint_D \nabla\cdot{F} dA$. This yields:
"""

# ╔═╡ 036f1910-c191-11ec-0d98-5bd9f03f407d
md"""```math
~
\oint_C (F \cdot\hat{N}) dA =
\sum_i \oint_{C_i}  (F \cdot\hat{N}) dA \approx
\sum \left(\nabla\cdot{F}\right)\Delta{x}\Delta{y} \approx
\iint_S \nabla\cdot{F}dA,
~
```
"""

# ╔═╡ 036f1918-c191-11ec-199e-c5391568650a
md"""the approximation signs becoming equals signs in the limit.
"""

# ╔═╡ 036f194a-c191-11ec-2fba-01b3e5b1a3e3
md"""##### Example
"""

# ╔═╡ 036f196a-c191-11ec-22f7-b7db167dfc18
md"""Let $F(x,y) = \langle ax , by\rangle$, and $D$ be the square with side length $2$ centered at the origin. Verify that the flow form of Green's theorem holds.
"""

# ╔═╡ 036f1988-c191-11ec-2389-135157829897
md"""We have the divergence is simply $a + b$ so $\iint_D (a+b)dA = (a+b)A(D) = 4(a+b)$.
"""

# ╔═╡ 036f19a6-c191-11ec-1dd6-5d911b80074a
md"""The integral of the flow across $C$ consists of $4$ parts. By symmetry, they all should be similar. We consider the line segment connecting $(1,-1)$ to $(1,1)$ (which has the proper counterclockwise orientation):
"""

# ╔═╡ 036f19b0-c191-11ec-3c57-49f96cc34a62
md"""```math
~
\int_C F \cdot \hat{N} ds=
\int_{-1}^1 \langle F_x, F_y\rangle\cdot\langle 0, 1\rangle ds =
\int_{-1}^1 b dy = 2b.
~
```
"""

# ╔═╡ 036f19ce-c191-11ec-22fa-0bd0d727be21
md"""Integrating across the top will give $2a$, along the bottom $2a$, and along the left side $2b$ totaling $4(a+b)$.
"""

# ╔═╡ 036f19e2-c191-11ec-1295-ad7d54d87d75
md"""---
"""

# ╔═╡ 036f1a20-c191-11ec-18eb-65e3a7d0e411
md"""Next, let $F(x,y) = \langle -y, x\rangle$. This field rotates, and we see has no divergence, as $\partial{F_x}/\partial{x} = \partial{(-y)}/\partial{x} = 0$ and $\partial{F_y}/\partial{y} = \partial{x}/\partial{y} = 0$. As such, the area integral in Green's theorem is $0$. As well, $F$ is parallel to $\hat{T}$ so *orthogonal* to $\hat{N}$, hence $\oint F\cdot\hat{N}ds = \oint 0ds = 0$. For any region $S$ there is no net flow across the boundary and no source or sink of flow inside.
"""

# ╔═╡ 036f1a28-c191-11ec-3d45-bbe7a8663fdc
md"""##### Example: stream functions
"""

# ╔═╡ 036f1a46-c191-11ec-1c63-211104081bec
md"""Strang compiles the following equivalencies (one implies the others) for when the total flux is $0$ for a vector field with continuous partial derivatives:
"""

# ╔═╡ 036f1b88-c191-11ec-1ec3-f56f028e5a48
md"""  * ```math
    \oint F\cdot\hat{N} ds = 0
    ```
  * for all curves connecting $P$ to $Q$, $\int_C F\cdot\hat{N}$ has the same value
  * There is a *stream* function $g(x,y)$ for which $F_x = \partial{g}/\partial{y}$ and $F_y = -\partial{g}/\partial{x}$. (This says $\nabla{g}$ is *orthogonal* to $F$.)
  * the components have zero divergence: $\partial{F_x}/\partial{x} + \partial{F_y}/\partial{y} = 0$.
"""

# ╔═╡ 036f1ba4-c191-11ec-0d81-b9d980ba3dcb
md"""Strang calls these fields *source* free as the divergence is $0$.
"""

# ╔═╡ 036f1bfe-c191-11ec-1463-218ff034000c
md"""A [stream](https://en.wikipedia.org/wiki/Stream_function) function plays the role of a scalar potential, but note the minus sign and order of partial derivatives. These are accounted for by saying $\langle F_x, F_y, 0\rangle = \nabla\times\langle 0, 0, g\rangle$, in Cartesian coordinates. Streamlines are tangent to the flow of the velocity  vector of the flow and in two dimensions are perpendicular to field lines formed by the gradient of a scalar function.
"""

# ╔═╡ 036f1c3a-c191-11ec-220a-8985f7a5df4a
md"""[Potential](https://en.wikipedia.org/wiki/Potential_flow) flow uses a scalar potential function to describe the velocity field through $\vec{v} = \nabla{f}$. As such, potential flow is irrotational due to the curl of a conservative field being the zero vector. Restricting to two dimensions, this says the partials satisfy $\partial{v_y}/\partial{x} - \partial{v_x}/\partial{y} = 0$. For an incompressible flow (like water) the velocity will have $0$ divergence too. That is $\nabla\cdot\nabla{f} = 0$ - $f$ satisfies Laplace's equation.
"""

# ╔═╡ 036f1c58-c191-11ec-19b9-b3dedcbb553f
md"""By the equivalencies above, an incompressible potential flow means in addition to a potential function, $f$, there is a stream function $g$ satisfying $v_x = \partial{g}/\partial{y}$ and $v_y=-\partial{g}/\partial{x}$.
"""

# ╔═╡ 036f1c94-c191-11ec-0fe9-7dbf08ea5375
md"""The gradient of $f=\langle v_x, v_y\rangle$ is orthogonal to the contour lines of $f$. The gradient of $g=\langle -v_y, v_x\rangle$ is orthogonal to the gradient of $f$, so are tangents to the contour lines of $f$. Reversing, the gradient of $f$ is tangent to the contour lines of $g$. If the flow follows the velocity field, then the contour lines of $g$ indicate the flow of the fluid.
"""

# ╔═╡ 036f1cbe-c191-11ec-1df6-fbb2ae46473c
md"""As an [example](https://en.wikipedia.org/wiki/Potential_flow#Examples_of_two-dimensional_flows) consider the following in polar coordinates:
"""

# ╔═╡ 036f1cda-c191-11ec-1763-2559722873ce
md"""```math
~
f(r, \theta) = A r^n \cos(n\theta),\quad
g(r, \theta) = A r^n \sin(n\theta).
~
```
"""

# ╔═╡ 036f1d0c-c191-11ec-103a-1533a10918c2
md"""The constant $A$ just sets the scale, the parameter $n$ has a qualitative effect on the contour lines. Consider $n=2$ visualized below:
"""

# ╔═╡ 036f20d6-c191-11ec-1f1a-e93b6859a6e8
let
	gr() # pyplot doesn't like the color as specified below.
	n = 2
	f(r,theta) = r^n * cos(n*theta)
	g(r, theta) = r^n * sin(n*theta)
	
	f(v) = f(v...); g(v)= g(v...)
	
	Φ(x,y) = [sqrt(x^2 + y^2), atan(y,x)]
	Φ(v) = Φ(v...)
	
	xs = ys = range(-2,2, length=50)
	p = contour(xs, ys, f∘Φ, color=:red, legend=false, aspect_ratio=:equal)
	contour!(p, xs, ys, g∘Φ, color=:blue, linewidth=3)
	pyplot()
	p
end

# ╔═╡ 036f20f6-c191-11ec-0139-573c961687ce
md"""The fluid would flow along the blue (stream) lines. The red lines have equal potential along the line.
"""

# ╔═╡ 036f2128-c191-11ec-252b-bfa2804a7412
md"""## Stokes' theorem
"""

# ╔═╡ 036f48a4-c191-11ec-0e50-8df2ec66a93d
let
	# https://en.wikipedia.org/wiki/Jiffy_Pop#/media/File:JiffyPop.jpg
	imgfile ="figures/jiffy-pop.png"
	caption ="""
	The Jiffy Pop popcorn design has a top surface that is designed to expand to accommodate the popped popcorn. Viewed as a surface, the surface area grows, but the boundary - where the surface meets the pan - stays the same. This is an example that many different surfaces can have the same bounding curve. Stokes' theorem will relate a surface integral over the surface to a line integral about the bounding curve.
	"""
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 036f4a5e-c191-11ec-32b8-d3e14ab846f1
md"""Were the figure of Jiffy Pop popcorn animated, the surface of foil would slowly expand due to pressure of popping popcorn until the popcorn was ready. However, the boundary would remain the same. Many different surfaces can have the same boundary. Take for instance the upper half unit sphere in $R^3$ it having the curve $x^2 + y^2 = 1$ as a boundary curve. This is the same curve as the surface of the cone $z = 1 - (x^2 + y^2)$ that lies above the $x-y$ plane. This would also be the same curve as the surface formed by a Mickey Mouse glove if the collar were scaled and positioned onto the unit circle.
"""

# ╔═╡ 036f4a8c-c191-11ec-3bee-2d26c99dce48
md"""Imagine if instead of the retro labeling,  a rectangular grid were drawn on the surface of the Jiffy Pop popcorn before popping. By Green's theorem, the integral of the curl of a vector field $F$ over this surface reduces to just an accompanying line integral over the boundary, $C$, where the orientation of $C$ is in the $\hat{k}$ direction. The intuitive derivation being that the curl integral over the grid will have cancellations due to adjacent cells having shared paths being traversed in both directions.
"""

# ╔═╡ 036f4aac-c191-11ec-20f3-65d0af796bf9
md"""Now imagine the popcorn expanding, but rather than worry about burning, focusing instead on what happens to the integral of the curl in the direction of the normal, we have
"""

# ╔═╡ 036f4ade-c191-11ec-2782-3dd5c0f78660
md"""```math
~
\nabla\times{F} \cdot\hat{N} = \lim \frac{1}{\Delta{S}} \oint_C F\cdot\hat{T} ds
\approx \frac{1}{\Delta{S}} F\cdot\hat{T} \Delta{s}.
~
```
"""

# ╔═╡ 036f4af2-c191-11ec-192b-f36651678f35
md"""This gives the series of approximations:
"""

# ╔═╡ 036f4b06-c191-11ec-3f59-fb33d5b66a44
md"""```math
~
\oint_C F\cdot\hat{T} ds =
\sum \oint_{C_i} F\cdot\hat{T} ds \approx
\sum F\cdot\hat{T} \Delta s \approx
\sum \nabla\times{F}\cdot\hat{N} \Delta{S} \approx
\iint_S \nabla\times{F}\cdot\hat{N} dS.
~
```
"""

# ╔═╡ 036f4b2e-c191-11ec-0d5d-a51508559ca6
md"""In terms of our expanding popcorn, the boundary integral - after accounting for cancellations, as in Green's theorem - can be seen as a microscopic sum of boundary integrals each of which is approximated by a term $\nabla\times{F}\cdot\hat{N} \Delta{S}$ which is viewed as a Riemann sum approximation for the the integral of the curl over the surface. The cancellation depends on a proper choice of orientation, but with that we have:
"""

# ╔═╡ 036f4d22-c191-11ec-221e-25db90074693
md"""> **Stokes' theorem**: Let $S$ be an orientable smooth surface in $R^3$ with boundary $C$, $C$ oriented so that the chosen normal for $S$ agrees with the right-hand rule for $C$'s orientation. Then *if* $F$ has continuous partial derivatives $~ \oint_C F \cdot\hat{T} ds = \iint_S (\nabla\times{F})\cdot\hat{N} dA. ~$

"""

# ╔═╡ 036f4d4a-c191-11ec-358a-ab6f4318de5b
md"""Green's theorem is an immediate consequence upon viewing the region in $R^2$ as a surface in $R^3$ with normal $\hat{k}$.
"""

# ╔═╡ 036f4da4-c191-11ec-3548-8d38fd86692e
md"""### Examples
"""

# ╔═╡ 036f4dd6-c191-11ec-1f2f-a3f5b4b516e2
md"""##### Example
"""

# ╔═╡ 036f4e00-c191-11ec-2566-dd7ef873c33f
md"""Our first example involves just an observation. For any simply connected surface $S$ without boundary (such as a sphere) the integral $\oint_S \nabla\times{F}dS=0$, as the line integral around the boundary must be $0$, as there is no boundary.
"""

# ╔═╡ 036f4e12-c191-11ec-0f89-cf86eb10104e
md"""##### Example
"""

# ╔═╡ 036f4e3a-c191-11ec-0529-a7c6b29b9449
md"""Let $F(x,y,z) = \langle x^2, 0, y^2\rangle$ and $C$ be the circle $x^2 + z^2 = 1$ with $y=0$. Find $\oint_C F\cdot\hat{T}ds$.
"""

# ╔═╡ 036f4e58-c191-11ec-3754-6977c6c2776b
md"""We can use Stoke's theorem with the surface being just the disc, so that $\hat{N} = \hat{j}$. This makes the computation easy:
"""

# ╔═╡ 036f5a6a-c191-11ec-027b-193186d68e0e
begin
	Fₛ(x,y,z) = [x^2, 0, y^2]
	CurlFₛ = curl(Fₛ(x,y,z), [x,y,z])
end

# ╔═╡ 036f5ab0-c191-11ec-28cb-0bfcf3837203
md"""We have $\nabla\times{F}\cdot\hat{N} = 0$, so the answer is $0$.
"""

# ╔═╡ 036f5ac4-c191-11ec-3bf0-1b584c8c515a
md"""We could have directly computed this. Let $r(t) = \langle \cos(t), 0, \sin(t)\rangle$. Then we have:
"""

# ╔═╡ 036f61c2-c191-11ec-39a4-f130533afe2f
begin
	rₛ(t) = [cos(t), 0, sin(t)]
	rpₛ = diff.(rₛ(t), t)
	integrandₛ = Fₛ(rₛ(t)...) ⋅ rpₛ
end

# ╔═╡ 036f61ea-c191-11ec-3335-7345e54f8559
md"""The integrand isn't obviously going to yield $0$ for the integral, but through symmetry:
"""

# ╔═╡ 036f6622-c191-11ec-0986-fb000a38e3f8
integrate(integrandₛ, (t, 0, 2PI))

# ╔═╡ 036f6648-c191-11ec-0799-adfc5f45a778
md"""##### Example: Ampere's circuital law
"""

# ╔═╡ 036f6672-c191-11ec-1fc1-21e815827472
md"""(Schey) Suppose a current $I$ flows along a line and $C$ is a path encircling the current with orientation such that the right hand rule points in the direction of the current flow.
"""

# ╔═╡ 036f6690-c191-11ec-07eb-e9b71edfb659
md"""Ampere's circuital law relates the line integral of the magnetic field to the induced current through:
"""

# ╔═╡ 036f66c2-c191-11ec-1a56-29d03b368833
md"""```math
~
\oint_C B\cdot\hat{T} ds = \mu_0 I.
~
```
"""

# ╔═╡ 036f66fe-c191-11ec-16dc-eb9550954f30
md"""The goal here is to re-express this integral law to produce a law at each point of the field. Let $S$ be a surface with boundary $C$, Let $J$ be the current density - $J=\rho v$, with $\rho$ the density of the current (not time-varying) and $v$ the velocity. The current can be re-expressed as $I = \iint_S J\cdot\hat{n}dA$. (If the current flows through a wire and $S$ is much bigger than the wire, this is still valid as $\rho=0$ outside of the wire.)
"""

# ╔═╡ 036f6712-c191-11ec-21a6-ed818e6fbb3f
md"""We then have:
"""

# ╔═╡ 036f6726-c191-11ec-3c8d-e16e57cdda27
md"""```math
~
\mu_0 \iint_S J\cdot\hat{N}dA =
\mu_0 I =
\oint_C B\cdot\hat{T} ds =
\iint_S (\nabla\times{B})\cdot\hat{N}dA.
~
```
"""

# ╔═╡ 036f6744-c191-11ec-1fcb-cf5c0af016cb
md"""As $S$ and $C$ are arbitrary, this implies the integrands of the surface integrals are equal, or:
"""

# ╔═╡ 036f674c-c191-11ec-2734-bf057cc757d8
md"""```math
~
\nabla\times{B} = \mu_0 J.
~
```
"""

# ╔═╡ 036f6762-c191-11ec-15ca-cbb9618f5508
md"""##### Example: Faraday's law
"""

# ╔═╡ 036f67a8-c191-11ec-00fd-f7a9dbf5ef23
md"""(Strang) Suppose $C$ is a wire and there is a time-varying magnetic field $B(t)$. Then Faraday's law says the *flux* passing within $C$ through a surface $S$ with boundary $C$ of the magnetic field, $\phi = \iint B\cdot\hat{N}dS$, induces an electric field $E$ that does work:
"""

# ╔═╡ 036f67bc-c191-11ec-33fc-6347b85e0e00
md"""```math
~
\oint_C E\cdot\hat{T}ds = -\frac{\partial{\phi}}{\partial{t}}.
~
```
"""

# ╔═╡ 036f67d0-c191-11ec-04da-9b6c99a3a94b
md"""Faraday's law is an empirical statement. Stokes' theorem can be used to produce one of Maxwell's equations. For any surface $S$, as above with its boundary being $C$, we have both:
"""

# ╔═╡ 036f67e4-c191-11ec-2f0b-2153a96137ea
md"""```math
~
-\iint_S \left(\frac{\partial{B}}{\partial{t}}\cdot\hat{N}\right)dS =
-\frac{\partial{\phi}}{\partial{t}} =
\oint_C E\cdot\hat{T}ds =
\iint_S (\nabla\times{E}) dS.
~
```
"""

# ╔═╡ 036f6802-c191-11ec-0423-03d41f9ab76a
md"""This is true for any capping surface for $C$. Shrinking $C$ to a point means it will hold for each point in $R^3$. That  is:
"""

# ╔═╡ 036f680c-c191-11ec-227d-17aaa08505c2
md"""```math
~
\nabla\times{E} = -\frac{\partial{B}}{\partial{t}}.
~
```
"""

# ╔═╡ 036f6822-c191-11ec-18f5-95cafc905247
md"""##### Example: Conservative fields
"""

# ╔═╡ 036f6834-c191-11ec-052b-91236599e8a1
md"""Green's theorem gave a characterization of $2$-dimensional conservative fields, Stokes' theorem provides a characterization for $3$ dimensional conservative fields (with continuous derivatives):
"""

# ╔═╡ 036f696a-c191-11ec-12f5-e3ed77925b3b
md"""  * The work $\oint_C F\cdot\hat{T} ds = 0$ for every closed path
  * The work $\int_P^Q F\cdot\hat{T} ds$ is independent of the path between $P$ and $Q$
  * for a scalar potential function $\phi$, $F = \nabla{\phi}$
  * The curl satisfies: $\nabla\times{F} = \vec{0}$ (and the domain is simply connected).
"""

# ╔═╡ 036f698a-c191-11ec-36ce-23ea9305c413
md"""Stokes's theorem can be used to show the first and fourth are equivalent.
"""

# ╔═╡ 036f69b0-c191-11ec-07b5-63b7884754ae
md"""First, if $0 = \oint_C F\cdot\hat{T} ds$, then by Stokes' theorem $0 = \int_S \nabla\times{F} dS$ for any orientable surface $S$ with boundary $C$. For a given point, letting $C$ shrink to that point can be used to see that the cross product must be $0$ at that point.
"""

# ╔═╡ 036f6a28-c191-11ec-0a06-9399775b891d
md"""Conversely, if the cross product is zero in a simply connected region, then take any simple closed curve, $C$ in the region. If the region is [simply connected](http://math.mit.edu/~jorloff/suppnotes/suppnotes02/v14.pdf) then there exists an orientable surface, $S$ in the region with boundary $C$ for which: $\oint_C F\cdot{N} ds = \iint_S (\nabla\times{F})\cdot\hat{N}dS=  \iint_S \vec{0}\cdot\hat{N}dS = 0$.
"""

# ╔═╡ 036f6a3c-c191-11ec-348c-a156d7b15f98
md"""The construction of a scalar potential function from the field can be done as illustrated in this next example.
"""

# ╔═╡ 036f6a5a-c191-11ec-28b4-a77fd0325ffa
md"""Take $F = \langle yz^2, xz^2, 2xyz \rangle$. Verify $F$ is conservative and find a scalar potential $\phi$.
"""

# ╔═╡ 036f6a6e-c191-11ec-3e71-89878d84d10a
md"""To verify that $F$ is conservative, we find its curl to see that it is $\vec{0}$:
"""

# ╔═╡ 036f73ce-c191-11ec-1bee-e10809fe3cab
let
	F(x,y,z) = [y*z^2, x*z^2, 2*x*y*z]
	curl(F(x,y,z), [x,y,z])
end

# ╔═╡ 036f7400-c191-11ec-0c15-fd6bcef68fca
md"""We need $\phi$ with $\partial{\phi}/\partial{x} = F_x = yz^2$. To that end, we integrate in $x$:
"""

# ╔═╡ 036f7414-c191-11ec-02f2-f125feacd4a5
md"""```math
~
\phi(x,y,z) = \int yz^2 dx = xyz^2 + g(y,z),
~
```
"""

# ╔═╡ 036f7450-c191-11ec-0f28-09d696fac383
md"""the function $g(y,z)$ is a "constant" of integration (it doesn't depend on $x$). That $\partial{\phi}/\partial{x} = F_x$ is true is easy to verify. Now, consider the partial in $y$:
"""

# ╔═╡ 036f7466-c191-11ec-3942-c561b082d3c3
md"""```math
~
\frac{\partial{\phi}}{\partial{y}} = xz^2 + \frac{\partial{g}}{\partial{y}} = F_y = xz^2.
~
```
"""

# ╔═╡ 036f7482-c191-11ec-01ff-192521e3c5b8
md"""So we have $\frac{\partial{g}}{\partial{y}}=0$ or $g(y,z) = h(z)$, some constant in $y$. Finally, we must have $\partial{\phi}/\partial{z} = F_z$, or
"""

# ╔═╡ 036f748c-c191-11ec-1eaf-cfff6b3654b7
md"""```math
~
\frac{\partial{\phi}}{\partial{z}} = 2xyz + h'(z) = F_z = 2xyz,
~
```
"""

# ╔═╡ 036f74ca-c191-11ec-1e9a-83d5ed5918fa
md"""So $h'(z) = 0$. This value can be any constant, even $0$ which we take, so that $g(y,z) = 0$ and $\phi(x,y,z) = xyz^2$ is a scalar potential for $F$.
"""

# ╔═╡ 036f74f0-c191-11ec-1b74-87e4a8e84535
md"""##### Example
"""

# ╔═╡ 036f7518-c191-11ec-0cfb-21e596402fc3
md"""Let $F(x,y,z) = \nabla(xy^2z^3) = \langle y^2z^3, 2xyz^3, 3xy^2z^2\rangle$. Show that the line integrals around the unit circle in the $x-y$ plane and the $y-z$ planes are $0$, as $F$ is conservative.
"""

# ╔═╡ 036f79b4-c191-11ec-2c24-e1ced027c203
Fxyz = ∇(x*y^2*z^3)

# ╔═╡ 036f7fa6-c191-11ec-06ec-fd44b3678985
let
	r(t) = [cos(t), sin(t), 0]
	rp = diff.(r(t), t)
	Ft = subs.(Fxyz, x .=> r(t)[1], y.=> r(t)[2], z .=> r(t)[3])
	integrate(Ft ⋅ rp, (t, 0, 2PI))
end

# ╔═╡ 036f8012-c191-11ec-27d6-b3ca5943f936
md"""(This is trivial, as `Ft` is $0$, as each term has a $z$ factor of $0$.)
"""

# ╔═╡ 036f8030-c191-11ec-16dc-49f1ca5be55f
md"""In the $y-z$ plane we have:
"""

# ╔═╡ 036f85e4-c191-11ec-1425-25f8336c7eac
let
	r(t) = [0, cos(t), sin(t)]
	rp = diff.(r(t), t)
	Ft = subs.(Fxyz, x .=> r(t)[1], y.=> r(t)[2], z .=> r(t)[3])
	integrate(Ft ⋅ rp, (t, 0, 2PI))
end

# ╔═╡ 036f8620-c191-11ec-1c98-2d3d8a503e45
md"""This is also easy, as `Ft` has only an `x` component and `rp` has only `y` and `z` components, so the two are orthogonal.
"""

# ╔═╡ 036f8634-c191-11ec-0a6a-49d4a3759fe0
md"""##### Example
"""

# ╔═╡ 036f868e-c191-11ec-280d-336cd9039d44
md"""In two dimensions the vector field $F(x,y) = \langle -y, x\rangle/(x^2+y^2) = S(x,y)/\|R\|^2$ is irrotational ($0$ curl) and has $0$ divergence, but is *not* conservative in $R^2$, as with $C$ being the unit disk we have $\oint_C F\cdot\hat{T}ds = \int_0^{2\pi} \langle -\sin(\theta),\cos(\theta)\rangle \cdot \langle-\sin(\theta), \cos(\theta)\rangle/1 d\theta = 2\pi$. This is because $F$ is not continuously differentiable at the origin, so the path $C$ is not in a simply connected domain where $F$ is continuously differentiable. (Were $C$ to avoid the origin, the integral would be $0$.)
"""

# ╔═╡ 036f86b6-c191-11ec-0434-299172363153
md"""In three dimensions, removing a single point in a domain does change simple connectedness, but removing an entire line will. So the function $F(x,y,z) =\langle -y,x,0\rangle/(x^2+y^2)\rangle$ will have $0$ curl, $0$ divergence, but won't be conservative in a domain that includes the $z$ axis.
"""

# ╔═╡ 036f86dc-c191-11ec-0064-e3493c46a926
md"""However, the function $F(x,y,z) = \langle x, y,z\rangle/\sqrt{x^2+y^2+z^2}$ has curl $0$, except at the origin. However, $R^3$ less the origin, as a domain, is simply connected, so $F$ will be conservative.
"""

# ╔═╡ 036f86fc-c191-11ec-1016-35040e1c138d
md"""## Divergence theorem
"""

# ╔═╡ 036f8774-c191-11ec-2ae7-9f41392795ee
md"""The divergence theorem is a consequence of a simple observation. Consider two adjacent cubic regions that share a common face. The boundary integral, $\oint_S F\cdot\hat{N} dA$, can be computed for each cube. The surface integral requires a choice of normal, and the convention is to use the outward pointing normal. The common face of the two cubes has *different* outward pointing normals, the difference being a minus sign. As such, the contribution of the surface integral over this face for one cube is *cancelled* out by the contribution of the surface integral over this face for the adjacent cube. As with Green's theorem, this means for a cubic partition, that only the contribution over the boundary is needed to compute the boundary integral. In formulas, if $V$ is a $3$ dimensional cubic region with boundary $S$ and it is partitioned into smaller cubic subregions, $V_i$ with surfaces $S_i$, we have:
"""

# ╔═╡ 036f8788-c191-11ec-31d7-4383864f167b
md"""```math
~
\oint_S F\cdot{N} dA = \sum \oint_{S_i} F\cdot{N} dA.
~
```
"""

# ╔═╡ 036f879c-c191-11ec-277b-a18027b2c472
md"""If the partition provides a microscopic perspective, then the divergence approximation $\nabla\cdot{F} \approx (1/\Delta{V_i}) \oint_{S_i} F\cdot{N} dA$ can be used to say:
"""

# ╔═╡ 036f87b2-c191-11ec-090c-412c6538683a
md"""```math
~
\oint_S F\cdot{N} dA =
\sum \oint_{S_i} F\cdot{N} dA \approx
\sum (\nabla\cdot{F})\Delta{V_i} \approx
\iiint_V \nabla\cdot{F} dV,
~
```
"""

# ╔═╡ 036f87ba-c191-11ec-32f3-51f201831864
md"""the last approximation through a Riemann sum approximation. This heuristic leads to:
"""

# ╔═╡ 036f88aa-c191-11ec-1bef-c150a61c327a
md"""> **The divergence theorem**: Suppose $V$ is a $3$-dimensional volume which is bounded (compact) and has a boundary, $S$, that is piecewise smooth. If $F$ is a continuously differentiable vector field defined on an open set containing $V$, then:
>
> ```math
> \iiint_V (\nabla\cdot{F}) dV = \oint_S (F\cdot\hat{N})dS.
> ```

"""

# ╔═╡ 036f88c8-c191-11ec-359c-8728549b71bd
md"""That is, the volume integral of the divergence can be computed from the flux integral over the boundary of $V$.
"""

# ╔═╡ 036f88e6-c191-11ec-1d22-9b68dc6a04b3
md"""### Examples of the divergence theorem
"""

# ╔═╡ 036f88fa-c191-11ec-0ad8-4fbc184dd877
md"""##### Example
"""

# ╔═╡ 036f8922-c191-11ec-2ca6-31354839abdd
md"""Verify the divergence theorem for the vector field $F(x,y,z) = \langle xy, yz, zx\rangle$ for the cubic box centered at the origin with side lengths $2$.
"""

# ╔═╡ 036f892c-c191-11ec-3978-bbd633a0cffe
md"""We need to compute two terms and show they are equal. We begin with the volume integral:
"""

# ╔═╡ 036f8ff8-c191-11ec-39fa-efbc41b66a5f
begin
	F₁(x,y,z) = [x*y, y*z, z*x]
	DivF₁ = divergence(F₁(x,y,z), [x,y,z])
	integrate(DivF₁, (x, -1,1), (y,-1,1), (z, -1,1))
end

# ╔═╡ 036f902a-c191-11ec-03bc-6b07584e8bd2
md"""The total integral is $0$ by symmetry, not due to the divergence being $0$, as it is $x+y+z$.
"""

# ╔═╡ 036f9050-c191-11ec-3dc2-9706632c2f0a
md"""As for the surface integral, we have $6$ sides to consider. We take the sides with $\hat{N}$ being $\pm\hat{i}$:
"""

# ╔═╡ 036f9516-c191-11ec-20d1-8546edddffe9
let
	Nhat = [1,0,0]
	integrate((F₁(x,y,z) ⋅ Nhat), (y, -1, 1), (z, -1,1)) # at x=1
end

# ╔═╡ 036f9566-c191-11ec-0af2-cd576d4b2798
md"""In fact, all $6$ sides will be $0$, as in this case $F \cdot \hat{i} = xy$ and at $x=1$ the surface integral is just $\int_{-1}^1\int_{-1}^1 y dy dz = 0$, as $y$ is an odd function.
"""

# ╔═╡ 036f957a-c191-11ec-37eb-f369070f735e
md"""As such, the two sides of the Divergence theorem are both $0$, so the theorem is verified.
"""

# ╔═╡ 036f95b6-c191-11ec-3850-5f1a5d202207
md"""###### Example
"""

# ╔═╡ 036f95f0-c191-11ec-02d0-276ec3d0284a
md"""(From Strang) If the temperature inside the sun is $T = \log(1/\rho)$ find the *heat* flow $F=-\nabla{T}$; the source, $\nabla\cdot{F}$; and the flux, $\iint F\cdot\hat{N}dS$. Model the  sun as a ball of radius $\rho_0$.
"""

# ╔═╡ 036f95fc-c191-11ec-1825-55bc291112b9
md"""We have the heat flow is simply:
"""

# ╔═╡ 036f9b30-c191-11ec-3639-6325c2838da5
begin
	Rₗ(x,y,z) = norm([x,y,z])
	Tₗ(x,y,z) = log(1/Rₗ(x,y,z))
	HeatFlow = -diff.(Tₗ(x,y,z), [x,y,z])
end

# ╔═╡ 036f9b4c-c191-11ec-2e03-1d7c01f12776
md"""We may recognize this as $\rho/\|\rho\|^2 = \hat{\rho}/\|\rho\|$.
"""

# ╔═╡ 036f9b74-c191-11ec-284b-fbb2264a8ccf
md"""The source is
"""

# ╔═╡ 036f9f48-c191-11ec-0773-9f33783f7f24
Divₗ = divergence(HeatFlow, [x,y,z]) |> simplify

# ╔═╡ 036f9f7a-c191-11ec-318f-93208b2d9fb7
md"""Which would simplify to $1/\rho^2$.
"""

# ╔═╡ 036f9fa2-c191-11ec-140e-c56a99ea0f0b
md"""Finally, the surface integral over the surface of the sun is an integral over a sphere of radius $\rho_0$. We could use spherical coordinates to compute this, but note instead that the normal is $\hat{\rho}$ so, $F \cdot \hat{N} = 1/\rho = 1/\rho_0$ over this surface. So the surface integral is simple the surface area times $1/\rho_0$: $4\pi\rho_0^2/\rho_0 = 4\pi\rho_0$.
"""

# ╔═╡ 036f9fc0-c191-11ec-2bcb-717e1596a958
md"""Finally, though $F$ is not continuous at the origin, the divergence theorem's result holds. Using spherical coordinates we have:
"""

# ╔═╡ 036fa69e-c191-11ec-1730-79e18c4bc920
let
	@syms rho::real rho_0::real phi::real theta::real
	Jac = rho^2 * sin(phi)
	integrate(1/rho^2 * Jac, (rho, 0, rho_0), (theta, 0, 2PI), (phi, 0, PI))
end

# ╔═╡ 036fa6be-c191-11ec-19df-851b07d8f36d
md"""##### Example: Continuity equation (Schey)
"""

# ╔═╡ 036fa736-c191-11ec-2901-f7cde59c9377
md"""Imagine a venue with a strict cap on the number of persons at one time. Two ways to monitor this are: at given times, a count, or census, of all the people in the venue can be made. Or, when possible, a count of people coming in can be compared to a count of people coming out and the difference should yield the number within. Either works well when access is limited and the venue small, but the latter can also work well on a larger scale. For example, for the subway system of New York it would be impractical to attempt to count all the people at a given time using a census, but from turnstile data an accurate count can be had, as turnstiles can be used to track people coming in and going out. But turnstiles can be restricting and cause long(ish) lines. At some stores, new technology is allowing checkout-free shopping. Imagine if each customer had an app on their phone that can be used to track location. As they enter a store, they can be recorded, as they exit they can be recorded and if RFID tags are on each item in the store, their "purchases" can be tallied up and billed through the app. (As an added bonus to paying fewer cashiers, stores can also track on a step-by-step basis how a customer interacts with the store.) In any of these three scenarios, a simple thing applies: the total number of people in a confined region can be counted by counting how many crossed the boundary (and in which direction) and the change in time of the count can be related to the change in time of the people crossing.
"""

# ╔═╡ 036fa768-c191-11ec-2a77-5929e690f0fe
md"""For a more real world example, the [New York Times]( https://www.nytimes.com/interactive/2019/07/03/world/asia/hong-kong-protest-crowd-ai.html) ran an article about estimating the size of a large protest in Hong Kong:
"""

# ╔═╡ 036fa806-c191-11ec-3210-8f0024d4028d
md"""> Crowd estimates for Hong Kong’s large pro-democracy protests have been a point of contention for years. The organizers and the police often release vastly divergent estimates. This year’s annual pro-democracy protest on Monday, July 1, was no different. Organizers announced 550,000 people attended; the police said 190,000 people were there at the peak.

"""

# ╔═╡ 036fa858-c191-11ec-3275-5d3790eb4d10
md"""> But for the first time in the march’s history, a group of researchers combined artificial intelligence and manual counting techniques to estimate the size of the crowd, concluding that 265,000 people marched.

"""

# ╔═╡ 036fa8b2-c191-11ec-2756-2f9726a2ed72
md"""> On Monday, the A.I. team attached seven iPads to two major footbridges along the march route. Volunteers doing manual counts were also stationed next to the cameras, to help verify the computer count.

"""

# ╔═╡ 036fa8c6-c191-11ec-23d7-73673d52be1a
md"""The article describes some issues in counting such a large group:
"""

# ╔═╡ 036fa916-c191-11ec-02e9-8d99a03b9c19
md"""> The high density of the crowd and the moving nature of these protests make estimating the turnout very challenging. For more than a decade, groups have stationed teams along the route and manually counted the rate of people passing through to derive the total number of participants.

"""

# ╔═╡ 036fa92a-c191-11ec-3188-833eccd12378
md"""As there are no turnstiles to do an accurate count and too many points to come and go, this technique can be too approximate. The article describes how artificial intelligence was used to count the participants. The Times tried their own hand:
"""

# ╔═╡ 036fa984-c191-11ec-33e5-fde9f1ad0046
md"""> Analyzing a short video clip recorded on Monday, The Times’s model tried to detect people based on color and shape, and then tracked the figures as they moved across the screen. This method helps avoid double counting because the crowd generally flowed in one direction.

"""

# ╔═╡ 036fa98e-c191-11ec-2ecf-897f823ffae0
md"""The divergence theorem provides two means to compute a value, the point here is to illustrate that there are (at least) two possible ways to compute crowd size. Which is better depends on the situation.
"""

# ╔═╡ 036fa9b6-c191-11ec-2584-fda21119e4af
md"""---
"""

# ╔═╡ 036fa9e8-c191-11ec-19b5-afc6ea236040
md"""Following Schey, we now consider a continuous analog to the crowd counting problem through a flow with a non-uniform density that may vary in time. Let $\rho(x,y,z;t)$ be the time-varying density and $v(x,y,z;t)$ be a vector field indicating the direction of flow. Consider some three-dimensional volume, $V$, with boundary $S$ (though two-dimensional would also be applicable). Then these integrals have interpretations:
"""

# ╔═╡ 036fa9fc-c191-11ec-079b-eb724ab3802e
md"""```math
~
\begin{align}
\iiint_V \rho dV &&\quad\text{Amount contained within }V\\
\frac{\partial}{\partial{t}} \iiint_V \rho dV &=
\iiint_V \frac{\partial{\rho}}{\partial{t}} dV &\quad\text{Change in time of amount contained within }V
\end{align}
~
```
"""

# ╔═╡ 036faa2e-c191-11ec-2904-2f460708a1fc
md"""Moving the derivative inside the integral requires an assumption of continuity. Assume the material is *conserved*, meaning that if the amount in the volume $V$ changes it must  flow in and out through the boundary. The flow out through $S$, the boundary of $V$, is
"""

# ╔═╡ 036faa44-c191-11ec-27b7-4f43c4fb1883
md"""```math
~
\oint_S (\rho v)\cdot\hat{N} dS,
~
```
"""

# ╔═╡ 036faa60-c191-11ec-2d92-eb598bd079d4
md"""using the customary outward pointing normal for the orientation of $S$.
"""

# ╔═╡ 036faa6a-c191-11ec-26eb-7dc568f871e9
md"""So we have:
"""

# ╔═╡ 036faa7e-c191-11ec-266a-adc496b44846
md"""```math
~
\iiint_V \frac{\partial{\rho}}{\partial{t}} dV =
-\oint_S (\rho v)\cdot\hat{N} dS = - \iiint_V \nabla\cdot\left(\rho v\right)dV.
~
```
"""

# ╔═╡ 036faa9c-c191-11ec-1080-ff977b37904d
md"""The last equality by the divergence theorem, the minus sign as a positive change in amount within $V$ means flow *opposite* the outward pointing normal for $S$.
"""

# ╔═╡ 036faaba-c191-11ec-374b-3b796dd96430
md"""The volume $V$ was arbitrary. While it isn't the case that two integrals being equal implies the integrands are equal, it is the case that if the two integrals are equal for all volumes and the two integrands are continuous, then they are equal.
"""

# ╔═╡ 036faace-c191-11ec-16cb-6ffedabcb4cb
md"""That is, under the *assumptions* that material is conserved and density is continuous a continuity equation can be derived from the divergence theorem:
"""

# ╔═╡ 036faae2-c191-11ec-2a34-bb4126d2db36
md"""```math
~
\nabla\cdot(\rho v) = - \frac{\partial{\rho}}{dt}.
~
```
"""

# ╔═╡ 036faaf6-c191-11ec-3ab2-4f6e48b5229c
md"""##### Example: The divergence theorem can fail to apply
"""

# ╔═╡ 036fab1e-c191-11ec-2d23-f1067797b41b
md"""The assumption of the divergence theorem that the vector field be *continuously* differentiable is important, as otherwise it may not hold. With $R(x,y,z) = \langle x,y,z\rangle$ take for example $F = (R/\|R\|) / \|R\|^2)$. This has divergence
"""

# ╔═╡ 036fafba-c191-11ec-15a4-bfe0eb71997b
let
	R(x,y,z) = [x,y,z]
	F(x,y,z) = R(x,y,z) / norm(R(x,y,z))^3
	
	
	divergence(F(x,y,z), [x,y,z]) |> simplify
end

# ╔═╡ 036fafec-c191-11ec-1a8c-21cfac303193
md"""The simplification done by SymPy masks the presence of $R^{-5/2}$ when taking the partial derivatives, which means the field is *not* continuously differentiable at the origin.
"""

# ╔═╡ 036fb012-c191-11ec-1bd4-7f79c4c88131
md"""*Were* the divergence theorem applicable, then the integral of $F$ over the unit sphere would mean:
"""

# ╔═╡ 036fb028-c191-11ec-3351-a342fc29c576
md"""```math
~
0 = \iiint_V \nabla\cdot{F} dV =
\oint_S F\cdot{N}dS = \oint_S \frac{R}{\|R\|^3} \cdot{R} dS =
\oint_S 1 dS = 4\pi.
~
```
"""

# ╔═╡ 036fb044-c191-11ec-137f-6791dc3c5edd
md"""Clearly, as $0$ is not equal to $4\pi$, the divergence theorem can not apply.
"""

# ╔═╡ 036fb0b6-c191-11ec-21d6-4ba98d9def08
md"""However, it *does* apply to any volume not enclosing the origin. So without any calculation, if $V$ were shifted over by $2$ units the volume integral over $V$ would be $0$ and the surface integral over $S$ would be also.
"""

# ╔═╡ 036fb0c8-c191-11ec-3794-0fda15f16b93
md"""As already seen, the inverse square law here arises in the electrostatic force formula, and this same observation was made in the context of Gauss's law.
"""

# ╔═╡ 036fb104-c191-11ec-2149-5f09695c41a7
md"""## Questions
"""

# ╔═╡ 036fb122-c191-11ec-3c4b-07d2a9b98762
md"""###### Question
"""

# ╔═╡ 036fb154-c191-11ec-2d04-bb3afb095abb
md"""(Schey) What conditions on $F: R^2 \rightarrow R^2$ imply $\oint_C F\cdot d\vec{r} = A$? ($A$ is the area bounded by the simple, closed curve $C$)
"""

# ╔═╡ 036fbba4-c191-11ec-005c-df6f87ffdb35
let
	choices = [
	L"We must have $\text{curl}(F) = 1$",
	L"We must have $\text{curl}(F) = 0$",
	L"We must have $\text{curl}(F) = x$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 036fbbc4-c191-11ec-066f-2d1fc1415c07
md"""###### Question
"""

# ╔═╡ 036fbbfe-c191-11ec-323c-eb2d2f278624
md"""For $C$, a simple, closed curve parameterized by $\vec{r}(t) = \langle x(t), y(t) \rangle$, $a \leq t \leq b$. The area contained can be computed by $\int_a^b x(t) y'(t) dt$. Let $\vec{r}(t) = \sin(t) \cdot \langle \cos(t), \sin(t)\rangle$.
"""

# ╔═╡ 036fbc12-c191-11ec-38c5-fde49f063e94
md"""Find the area inside $C$
"""

# ╔═╡ 036fc732-c191-11ec-2312-35a34f70bd65
let
	val, err = quadgk(t -> (sin(t)*cos(t)* ForwardDiff.derivative(u->sin(u)^2, t)), 0, 2pi)
	numericq(val)
end

# ╔═╡ 036fc752-c191-11ec-281f-bbb11748ae70
md"""###### Question
"""

# ╔═╡ 036fc77a-c191-11ec-1202-696c165addeb
md"""Let $\hat{N} = \langle \cos(t), \sin(t) \rangle$ and $\hat{T} = \langle -\sin(t), \cos(t)\rangle$. Then polar coordinates can be viewed as the parametric curve $\vec{r}(t) = r(t) \hat{N}$.
"""

# ╔═╡ 036fc7ac-c191-11ec-0fae-e1413d0d9f37
md"""Applying Green's theorem to the vector field $F = \langle -y, x\rangle$ which along the curve is $r(t) \hat{T}$ we know the area formula $(1/2) (\int xdy - \int y dx)$. What is this in polar coordinates (using $\theta=t$?) (Using $(r\hat{N}' = r'\hat{N} + r \hat{N}' = r'\hat{N} +r\hat{T}$ is useful.)
"""

# ╔═╡ 036fd0f8-c191-11ec-0eb7-930804bf4e67
let
	choices = [
	raw" ``\int rd\theta``",
	raw" ``(1/2) \int r d\theta``",
	raw" ``\int r^2 d\theta``",
	raw" ``(1/2) \int r^2d\theta``"
	]
	ans=4
	radioq(choices, ans)
end

# ╔═╡ 036fd116-c191-11ec-1a6d-d78ec0e90c4b
md"""###### Question
"""

# ╔═╡ 036fd13c-c191-11ec-1e4c-adadde937f1d
md"""Let $\vec{r}(t) = \langle \cos^3(t), \sin^3(t)\rangle$, $0\leq t \leq 2\pi$. (This describes a hypocycloid.) Compute the area enclosed by the curve $C$ using Green's theorem.
"""

# ╔═╡ 036fd7e0-c191-11ec-0891-0ff074dc91df
let
	r(t) = [cos(t)^3, sin(t)^3]
	F(x,y) = [-y,x]/2
	F_t = subs.(F(x,y), x.=>r(t)[1], y.=>r(t)[2])
	Tangent = diff.(r(t),t)
	integrate(F_t ⋅ Tangent, (t, 0, 2PI))
	choices = [
	raw" ``3\pi/8``",
	raw" ``\pi/4``",
	raw" ``\pi/2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 036fd800-c191-11ec-21dc-3124a85dacaf
md"""###### Question
"""

# ╔═╡ 036fd81e-c191-11ec-0761-3f109b231bd6
md"""Let $F(x,y) = \langle y, x\rangle$. We verify Green's theorem holds when $S$ is the unit square, $[0,1]\times[0,1]$.
"""

# ╔═╡ 036fd83c-c191-11ec-3f0c-9b15a32536f2
md"""The curl of $F$ is
"""

# ╔═╡ 036fde7c-c191-11ec-1052-670eb1feeee1
let
	choices = [
	raw" ``0``",
	raw" ``1``",
	raw" ``2``"
	]
	ans =1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 036fdea4-c191-11ec-36ea-59a67bf2569f
md"""As the curl is a constant, say $c$, we have $\iint_S (\nabla\times{F}) dS = c \cdot 1$. This is?
"""

# ╔═╡ 036fe4bc-c191-11ec-3020-5f4c5638ef70
let
	choices = [
	raw" ``0``",
	raw" ``1``",
	raw" ``2``"
	]
	ans =1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 036fe53e-c191-11ec-1aeb-1f8a4754a79a
md"""To integrate around the boundary we have $4$ terms: the path $A$ connecting $(0,0)$ to $(1,0)$ (on the $x$ axis), the path $B$ connecting $(1,0)$ to $(1,1)$, the path $C$ connecting $(1,1)$ to $(0,1)$, and the path $D$ connecting $(0,1)$ to $(0,0)$ (along the $y$ axis).
"""

# ╔═╡ 036fe552-c191-11ec-1105-4fccd65243eb
md"""Which path has tangent $\hat{j}$?
"""

# ╔═╡ 036fec46-c191-11ec-22c2-7191bd5bb038
let
	choices = ["`` A``","`` B``"," ``C``"," ``D``"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 036fec8c-c191-11ec-1206-d1cba0cef808
md"""Along  path $C$, $F(x,y) = [1,x]$ and $\hat{T}=-\hat{i}$ so $F\cdot\hat{T} = -1$. The path integral $\int_C (F\cdot\hat{T})ds = -1$. What is the value of the path integral over $A$?
"""

# ╔═╡ 036ff2c2-c191-11ec-1f08-2d46c6eb78f7
let
	choices = [
	raw" ``-1``",
	raw" ``0``",
	raw" ``1``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 036ff2fe-c191-11ec-2c66-09f8454a1a76
md"""What is the integral over the oriented boundary of $S$?
"""

# ╔═╡ 036ff90a-c191-11ec-391b-a922ae7310cf
let
	choices = [
	raw" ``0``",
	raw" ``1``",
	raw" ``2``"
	]
	ans =1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 036ff93e-c191-11ec-0188-6f72a2ea723d
md"""###### Question
"""

# ╔═╡ 036ff984-c191-11ec-33f5-af4d3015815a
md"""Suppose $F: R^2 \rightarrow R^2$ is a vector field such that $\nabla\cdot{F}=0$ *except* at the origin. Let $C_1$ and $C_2$ be the unit circle and circle with radius $2$ centered at the origin, both parameterized counterclockwise. What is the relationship between $\oint_{C_2} F\cdot\hat{N}ds$ and $\oint_{C_1} F\cdot\hat{N}ds$?
"""

# ╔═╡ 037006a4-c191-11ec-0ce5-43a2e4d271e4
let
	choices = [
	L"They are the same, as Green's theorem applies to the area, $S$, between $C_1$ and $C_2$ so $\iint_S \nabla\cdot{F}dA = 0$."
	L"They  differ by a minus sign, as Green's theorem applies to the area, $S$, between $C_1$ and $C_2$ so $\iint_S \nabla\cdot{F}dA = 0$."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 037006cc-c191-11ec-28d5-ef5991c8082f
md"""###### Question
"""

# ╔═╡ 03700708-c191-11ec-3167-63852943e56a
md"""Let $F(x,y) = \langle x, y\rangle/(x^2+y^2)$. Though this has divergence $0$ away from the origin, the flow integral around the unit circle, $\oint_C (F\cdot\hat{N})ds$, is $2\pi$, as Green's theorem in divergence form does not apply. Consider the integral around the square centered at the origin, with side lengths $2$. What is the flow integral around this closed curve?
"""

# ╔═╡ 0370181a-c191-11ec-313a-1724eb8dbb3e
let
	choices = [
	L"Also $2\pi$, as Green's theorem applies to the region formed by the square minus the circle and so the overall flow integral around the boundary is $0$, so the two will be the same.",
	L"It is $-2\pi$, as Green's theorem applies to the region formed by the square minus the circle and so the overall flow integral around the boundary is $0$, so the two will have opposite signs, but the same magnitude."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 03701836-c191-11ec-2108-6d0f1b1f0d39
md"""###### Question
"""

# ╔═╡ 03701860-c191-11ec-35b4-99a3fe337cac
md"""Using the divergence theorem, compute $\iint F\cdot\hat{N} dS$ where $F(x,y,z) = \langle x, x, y \rangle$ and $V$ is the unit sphere.
"""

# ╔═╡ 03701f04-c191-11ec-20c1-9b0ff36aff41
let
	choices = [
	raw" ``4/3 \pi``",
	raw" ``4\pi``",
	raw" ``\pi``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 03701f36-c191-11ec-1130-e9108aa64add
md"""###### Question
"""

# ╔═╡ 03701f5e-c191-11ec-119b-057f3c55e410
md"""Using the divergence theorem, compute $\iint F\cdot\hat{N} dS$ where $F(x,y,z) = \langle y, y,x \rangle$ and $V$ is the unit cube $[0,1]\times[0,1]\times[0,1]$.
"""

# ╔═╡ 03702576-c191-11ec-1abf-5b3c60eb3747
let
	choices = [
	raw" ``1``",
	raw" ``2``",
	raw" ``3``"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 03702594-c191-11ec-0522-d3a5be09c3bd
md"""###### Question
"""

# ╔═╡ 037025bc-c191-11ec-3ef9-1b61fa924dd6
md"""Let $R(x,y,z) = \langle x, y, z\rangle$ and $\rho = \|R\|^2$. If $F = 2R/\rho^2$ then $F$ is the gradient of a potential. Which one?
"""

# ╔═╡ 03702c7e-c191-11ec-3b29-7d80c0b17d02
let
	choices = [
	raw" ``\log(\rho)``",
	raw" ``1/\rho``",
	raw" ``\rho``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 03702cb0-c191-11ec-3be8-e70ed9f90cdd
md"""Based on this information, for $S$ a surface not including the origin with boundary $C$, a simple closed curve, what is $\oint_C F\cdot\hat{T}ds$?
"""

# ╔═╡ 03703700-c191-11ec-212c-5d1647e4e4de
let
	choices = [
	L"It is $0$, as, by Stoke's theorem, it is equivalent to $\iint_S (\nabla\times\nabla{\phi})dS = \iint_S 0 dS = 0$.",
	L"It is $2\pi$, as this is the circumference of the unit circle"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 0370371e-c191-11ec-17b1-f35dfd61ecb3
md"""###### Question
"""

# ╔═╡ 03703750-c191-11ec-0f93-833c81261de2
md"""Consider the circle, $C$ in $R^3$ parameterized by $\langle \cos(t), \sin(t), 0\rangle$. The upper half sphere and the unit disc in the $x-y$ plane are both surfaces with this boundary. Let $F(x,y,z) = \langle -y, x, z\rangle$. Compute $\oint_C F\cdot\hat{T}ds$ using Stokes' theorem. The value is:
"""

# ╔═╡ 03703d90-c191-11ec-16af-cf7b0e12c089
let
	choices = [
	raw" ``2\pi``",
	raw" ``2``",
	raw" ``0``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 03703dae-c191-11ec-09fe-91cda026f140
md"""###### Question
"""

# ╔═╡ 03703dea-c191-11ec-2c70-8f66a7f82d76
md"""From [Illinois](https://faculty.math.illinois.edu/~franklan/Math241_165_ConservativeR3.pdf) comes this advice to check if a vector field $F:R^3 \rightarrow R^3$ is conservative:
"""

# ╔═╡ 03703f00-c191-11ec-3e34-110096226eb7
md"""  * If $\nabla\times{F}$ is non -zero the field is not conservative
  * If $\nabla\times{F}$ is zero *and* the domain of $F$ is simply connected (e.g., all of $R^3$, then $F$ is conservative
  * If $\nabla\times{F}$ is zero *but* the domain of $F$ is *not* simply connected then ...
"""

# ╔═╡ 03703f16-c191-11ec-318d-2f73f4fa49f0
md"""What should finish the last sentence?
"""

# ╔═╡ 03704a1a-c191-11ec-3461-53271aa7e8bc
let
	choices = [
	"the field could be conservative or not. One must work harder to answer the question.",
	"the field is *not* conservative.",
	"the field *is* conservative"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 03704a38-c191-11ec-3c55-358d96c0d7be
md"""###### Question
"""

# ╔═╡ 03704a6a-c191-11ec-38fb-859ecfa5d667
md"""[Knill]() provides the following chart showing what happens under the three main operations on vector-valued functions:
"""

# ╔═╡ 03704a9c-c191-11ec-343a-43ad7f83e182
md"""```
                     1
              1 -> grad -> 1
       1 -> grad -> 2 -> curl -> 1
1 -> grad -> 3 -> curl -> 3 -> div -> 1
```"""

# ╔═╡ 03704ac4-c191-11ec-1528-c1c3f7c9e450
md"""In the first row, the gradient is just the regular derivative and takes a function $f:R^1 \rightarrow R^1$ into another such function, $f':R \rightarrow R^1$.
"""

# ╔═╡ 03704ae0-c191-11ec-3ed1-31551781e382
md"""In the second row, the gradient is an operation that takes a function $f:R^2 \rightarrow R$ into one $\nabla{f}:R^2 \rightarrow R^2$, whereas the curl takes $F:R^2\rightarrow R^2$ into $\nabla\times{F}:R^2 \rightarrow R^1$.
"""

# ╔═╡ 03704b12-c191-11ec-08f9-eb4a10f124d5
md"""In the third row, the gradient is an operation that takes a function $f:R^3 \rightarrow R$ into one $\nabla{f}:R^3 \rightarrow R^3$, whereas the curl takes $F:R^3\rightarrow R^3$ into $\nabla\times{F}:R^3 \rightarrow R^3$, and the divergence takes $F:R^3 \rightarrow R^3$ into $\nabla\cdot{F}:R^3 \rightarrow R$.
"""

# ╔═╡ 03704b44-c191-11ec-101e-016282c1f910
md"""The diagram emphasizes a few different things:
"""

# ╔═╡ 03704baa-c191-11ec-13de-31168bf19907
md"""  * The number of integral theorems is implied here. The ones for the gradient are the fundamental theorem of line integrals, namely $\int_C \nabla{f}\cdot d\vec{r}=\int_{\partial{C}} f$, a short hand notation for $f$ evaluated at the end points.
"""

# ╔═╡ 03704bc8-c191-11ec-04d3-ebe4e15e8329
md"""The one for the curl in $n=2$ is Green's theorem: $\iint_S \nabla\times{F}dA = \oint_{\partial{S}} F\cdot d\vec{r}$.
"""

# ╔═╡ 03704be8-c191-11ec-01af-5743e428be4c
md"""The one for the curl in $n=3$ is Stoke's theorem: $\iint S \nabla\times{F}dA = \oint_{\partial{S}} F\cdot d\vec{r}$. Finally, the divergence for $n=3$ is the divergence theorem $\iint_V \nabla\cdot{F} dV = \iint_{\partial{V}} F dS$.
"""

# ╔═╡ 03704c22-c191-11ec-3c7e-e94693353f67
md"""  * Working left to right along a row of the diagram, applying two steps of these operations yields:
"""

# ╔═╡ 03705550-c191-11ec-2589-3de1cadf9542
let
	choices = [
	"Zero, by the vanishing properties of these operations",
	"The maximum number in a row",
	"The row number plus 1"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 0370556e-c191-11ec-33c9-234fe136b62c
md"""###### Question
"""

# ╔═╡ 037055a0-c191-11ec-30a8-8976d61f6104
md"""[Katz](https://www.jstor.org/stable/2690275) provides details on the history of Green, Gauss (divergence), and Stokes. The first paragraph says that each theorem was not original to the attributed name. Part of the reason being the origins dating back to the 17th century, their usage by Lagrange in Laplace in the 18th century, and their formalization in the 19th century. Other reasons are the applications were different "Gauss was interested in the theory of magnetic attraction, Ostrogradsky in the theory of heat, Green in electricity and magnetism, Poisson in elastic bodies, and Sarrus in floating bodies." Finally, in nearly all the cases the theorems were thought of as tools toward some physical end.
"""

# ╔═╡ 037055b4-c191-11ec-362d-c79c99da8c05
md"""In 1846, Cauchy proved
"""

# ╔═╡ 037055e6-c191-11ec-1e11-ed8e58e87138
md"""```math
~
\int\left(p\frac{dx}{ds} + q \frac{dy}{ds}\right)ds =
\pm\iint\left(\frac{\partial{p}}{\partial{y}} - \frac{\partial{q}}{\partial{x}}\right)dx dy.
~
```
"""

# ╔═╡ 037055fa-c191-11ec-02b6-d9a3ccaa1028
md"""This is a form of:
"""

# ╔═╡ 03705dac-c191-11ec-24d5-59ee84a58817
let
	choices = [
	"Green's theorem",
	"The divergence (Gauss') theorem",
	"Stokes' theorem"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 03705de8-c191-11ec-1554-69bcd3676108
HTML("""<div class="markdown"><blockquote>
<p><a href="../integral_vector_calculus/div_grad_curl.html">◅ previous</a>  <a href="../integral_vector_calculus/review.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integral_vector_calculus/stokes_theorem.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 03705dfe-c191-11ec-321b-89c1d109a3c2
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.17"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
SymPy = "~1.1.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
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
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "QuizQuestions", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "18ea2c014776f6e5cdc94b5620ca0d353b207301"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.17"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

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
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

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
git-tree-sha1 = "0340cee29e3456a7de968736ceeb705d591875a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.20"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "dd933c4ef7b4c270aacd4eb88fa64c147492acf0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.10.0"

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
git-tree-sha1 = "d064b0340db45d48893e7604ec95e7a2dc9da904"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.5.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

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
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

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
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

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
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "bcf640979ee55b652f3b01650444eb7bbe3ea837"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

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
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

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
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

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
git-tree-sha1 = "a970d55c2ad8084ca317a4658ba6ce99b7523571"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.12"

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
git-tree-sha1 = "bfbd6fb946d967794498790aa7a0e6cdf1120f41"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.13"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

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
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

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
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6f2dd1cf7a4bbf4f305a0d8750e351cb46dfbe80"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

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

[[deps.QuizQuestions]]
deps = ["Base64", "Markdown", "Mustache", "Random"]
git-tree-sha1 = "9e56e8b527c96c96d7a9ad9c060aca9b5c402b1a"
uuid = "612c44de-1021-4a21-84fb-7261cf5eb2d4"
version = "0.3.11"

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
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

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
git-tree-sha1 = "e382260f6482c27b5062eba923e36fde2f5ab0b9"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.0"

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
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

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
git-tree-sha1 = "cbf21db885f478e4bd73b286af6e67d1beeebe4c"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.4"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "8d7530a38dbd2c397be7ddd01a424e4f411dcc41"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.2"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "1763d267a68a4e58330925b7ce8b9ea2ec06c882"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.4"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

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
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

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
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

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
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

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
# ╟─03705dcc-c191-11ec-2791-37df108552e1
# ╟─036ebef2-c191-11ec-1a00-ff975d9b4df6
# ╟─036ebf24-c191-11ec-01f0-5beaea0911b4
# ╠═036ec5fa-c191-11ec-29d1-872194acd003
# ╟─036ec9ba-c191-11ec-0cf2-c51111e66493
# ╟─036ec9f6-c191-11ec-0bf3-c538ef2ca2be
# ╟─036eca84-c191-11ec-3390-e5f3f344e1be
# ╟─036ecab6-c191-11ec-078b-c9a4b4753963
# ╟─036ecad2-c191-11ec-34ee-09052b07d41b
# ╟─036ecc3a-c191-11ec-2b26-af86bc63450b
# ╟─036ecc44-c191-11ec-3304-0bafa369f82a
# ╟─036ecc8a-c191-11ec-2dc8-2bdb2ba2e217
# ╟─036ecca8-c191-11ec-00d5-77e267a2959e
# ╟─036ed432-c191-11ec-01c9-a1a79a2631cd
# ╟─036ed464-c191-11ec-1599-33af05e3d900
# ╟─036ed4aa-c191-11ec-0293-413cd241b439
# ╟─036ed4bc-c191-11ec-3a78-fb1519abffce
# ╟─036ed4ee-c191-11ec-2c89-b7a99cc458d2
# ╟─036ed504-c191-11ec-3672-6b4980a88a80
# ╟─036ed50e-c191-11ec-08a3-b570451d2c53
# ╟─036ed522-c191-11ec-1b56-8fdf1c87fb1a
# ╟─036ed54a-c191-11ec-0cd5-cbf9476253ca
# ╟─036ed554-c191-11ec-2d17-9b1cd8ac81e8
# ╟─036ed572-c191-11ec-02f0-f745035b31db
# ╟─036ed592-c191-11ec-2431-abb09d8d6157
# ╟─036ed5a4-c191-11ec-25aa-d726f13c6549
# ╟─036ed978-c191-11ec-1816-1934185b7627
# ╟─036ed9d2-c191-11ec-3ced-57eaec9ae14a
# ╟─036ed9e6-c191-11ec-3326-41118c33ed43
# ╟─036ed9f0-c191-11ec-0bf8-5327536a0e65
# ╟─036eda04-c191-11ec-01bf-e13b9d6e569b
# ╟─036eda18-c191-11ec-008c-ad4d208f8727
# ╟─036eda40-c191-11ec-347b-3fbb76990483
# ╟─036eda68-c191-11ec-0279-9b6cb52ac757
# ╟─036eda90-c191-11ec-2642-1b666bc9afcb
# ╟─036edb9e-c191-11ec-3d21-8d922724a42a
# ╟─036edba8-c191-11ec-04dc-43a7499b95e7
# ╟─036edbda-c191-11ec-2609-5fc5d9cffd37
# ╟─036edbe4-c191-11ec-17a2-71a705fcd3e3
# ╟─036edc0c-c191-11ec-39fe-fb4eb6bee943
# ╟─036edc2a-c191-11ec-063a-c74ae8e51510
# ╟─036edc3e-c191-11ec-257d-8384f2d34f06
# ╟─036edc52-c191-11ec-2d16-6b95a1fb29c3
# ╟─036edc68-c191-11ec-09cc-1b5a25e08cf6
# ╟─036edc70-c191-11ec-03db-9da639d27727
# ╠═036ee184-c191-11ec-05c7-eda5a244277d
# ╟─036ee1ca-c191-11ec-1af7-8be1026c3258
# ╟─036ee1e8-c191-11ec-3bf3-1122682cdc39
# ╟─036ee210-c191-11ec-3d21-e5c177c3cb51
# ╟─036ee224-c191-11ec-26b5-5bc0793aa68a
# ╟─036ee24c-c191-11ec-1aac-ef15f6dc51d9
# ╟─036ee268-c191-11ec-1bd4-f7bc23187a02
# ╟─036ee27e-c191-11ec-1e03-2f42167bcf24
# ╟─036ee292-c191-11ec-2ac9-359f1c736a2c
# ╟─036ee2ce-c191-11ec-3340-bdaba09dc85a
# ╟─036ee2ec-c191-11ec-3ef6-83010fdb3c02
# ╟─036ee30c-c191-11ec-3c95-4fe02f5c662b
# ╟─036ee350-c191-11ec-3756-d58423488de3
# ╟─036ee364-c191-11ec-3057-cd57202c843f
# ╟─036ee382-c191-11ec-0f1e-efdc62eab92a
# ╟─036ee3aa-c191-11ec-35a1-f5506813b4ea
# ╟─036ee440-c191-11ec-2e76-c97bad11673b
# ╟─036ee468-c191-11ec-050c-ff74502b29e8
# ╟─036ee474-c191-11ec-0d57-bdcf93840701
# ╟─036ee490-c191-11ec-30ce-d37779dd80a2
# ╟─036ee4ae-c191-11ec-0049-318cb168fd7d
# ╟─036ee4c2-c191-11ec-0c20-55e5857221ac
# ╟─036ee4e0-c191-11ec-314d-ed28839e584c
# ╟─036ee4f4-c191-11ec-1256-775e936d442a
# ╟─036ee4fe-c191-11ec-1a80-212e1ee1d9f3
# ╠═036eeae4-c191-11ec-3d2e-8928fe03ae26
# ╠═036eef9e-c191-11ec-152e-a3c4e307bcff
# ╟─036eefc6-c191-11ec-3fae-6941995f5a0c
# ╟─036eefe2-c191-11ec-0e48-0f74c7c87253
# ╟─036eeff8-c191-11ec-1c2e-7b5a1ce84bef
# ╟─036ef046-c191-11ec-1aa0-490624be0413
# ╟─036ef066-c191-11ec-05fd-21c75c47fc0a
# ╟─036ef07a-c191-11ec-2538-91d4122c7a49
# ╟─036ef0b8-c191-11ec-18e8-91238b4ba357
# ╟─036ef6ea-c191-11ec-034d-bf4e3ac166ff
# ╟─036ef732-c191-11ec-3ff5-a51bc68d206b
# ╟─036ef746-c191-11ec-0dc1-f17b77398106
# ╟─036ef76e-c191-11ec-18bb-cbf909dd536d
# ╟─036ef796-c191-11ec-01c4-ed8167e2efb8
# ╟─036ef7b4-c191-11ec-3293-1186eac9eb90
# ╟─036ef7c0-c191-11ec-31fc-6fb7c3d65741
# ╟─036ef7e6-c191-11ec-1bbd-41799799748e
# ╟─036efcaa-c191-11ec-0afd-0149ef3207ed
# ╟─036efcdc-c191-11ec-20a6-fbcc0edaba0a
# ╟─036efd04-c191-11ec-1624-51216538e725
# ╟─036efd2e-c191-11ec-3a01-535d0dcbb7bb
# ╟─036efd4a-c191-11ec-233b-49e969b3b477
# ╟─036efd60-c191-11ec-120e-c3ebd633aa56
# ╟─036efd8e-c191-11ec-2781-8969e4ad082f
# ╟─036efdb8-c191-11ec-3c54-4bd9c3e1ee31
# ╟─036efdcc-c191-11ec-02bc-874a409b2ec8
# ╟─036efde0-c191-11ec-1699-112206b6caed
# ╟─036efe08-c191-11ec-1bda-abf11e4b05ae
# ╟─036efe12-c191-11ec-217d-7b939b854596
# ╟─036efe30-c191-11ec-3606-41b34454115b
# ╟─036efe58-c191-11ec-3761-b9ceb1ce4a03
# ╟─036f0b50-c191-11ec-32ca-bb32f8876248
# ╟─036f0baa-c191-11ec-008c-f156c82729f7
# ╟─036f0f9c-c191-11ec-1d61-5fadef8ca827
# ╟─036f0fe2-c191-11ec-151c-c768c18256b2
# ╟─036f0ff6-c191-11ec-0559-df3acb136e9f
# ╟─036f1886-c191-11ec-3d9a-d74a8a13b9dd
# ╟─036f18ac-c191-11ec-0878-efa24c224c16
# ╟─036f18ca-c191-11ec-3489-bdf607aa97a5
# ╟─036f18ea-c191-11ec-2cfb-d1459217d9ca
# ╟─036f18fc-c191-11ec-338c-616ce9ca83db
# ╟─036f1910-c191-11ec-0d98-5bd9f03f407d
# ╟─036f1918-c191-11ec-199e-c5391568650a
# ╟─036f194a-c191-11ec-2fba-01b3e5b1a3e3
# ╟─036f196a-c191-11ec-22f7-b7db167dfc18
# ╟─036f1988-c191-11ec-2389-135157829897
# ╟─036f19a6-c191-11ec-1dd6-5d911b80074a
# ╟─036f19b0-c191-11ec-3c57-49f96cc34a62
# ╟─036f19ce-c191-11ec-22fa-0bd0d727be21
# ╟─036f19e2-c191-11ec-1295-ad7d54d87d75
# ╟─036f1a20-c191-11ec-18eb-65e3a7d0e411
# ╟─036f1a28-c191-11ec-3d45-bbe7a8663fdc
# ╟─036f1a46-c191-11ec-1c63-211104081bec
# ╟─036f1b88-c191-11ec-1ec3-f56f028e5a48
# ╟─036f1ba4-c191-11ec-0d81-b9d980ba3dcb
# ╟─036f1bfe-c191-11ec-1463-218ff034000c
# ╟─036f1c3a-c191-11ec-220a-8985f7a5df4a
# ╟─036f1c58-c191-11ec-19b9-b3dedcbb553f
# ╟─036f1c94-c191-11ec-0fe9-7dbf08ea5375
# ╟─036f1cbe-c191-11ec-1df6-fbb2ae46473c
# ╟─036f1cda-c191-11ec-1763-2559722873ce
# ╟─036f1d0c-c191-11ec-103a-1533a10918c2
# ╠═036f20d6-c191-11ec-1f1a-e93b6859a6e8
# ╟─036f20f6-c191-11ec-0139-573c961687ce
# ╟─036f2128-c191-11ec-252b-bfa2804a7412
# ╟─036f48a4-c191-11ec-0e50-8df2ec66a93d
# ╟─036f4a5e-c191-11ec-32b8-d3e14ab846f1
# ╟─036f4a8c-c191-11ec-3bee-2d26c99dce48
# ╟─036f4aac-c191-11ec-20f3-65d0af796bf9
# ╟─036f4ade-c191-11ec-2782-3dd5c0f78660
# ╟─036f4af2-c191-11ec-192b-f36651678f35
# ╟─036f4b06-c191-11ec-3f59-fb33d5b66a44
# ╟─036f4b2e-c191-11ec-0d5d-a51508559ca6
# ╟─036f4d22-c191-11ec-221e-25db90074693
# ╟─036f4d4a-c191-11ec-358a-ab6f4318de5b
# ╟─036f4da4-c191-11ec-3548-8d38fd86692e
# ╟─036f4dd6-c191-11ec-1f2f-a3f5b4b516e2
# ╟─036f4e00-c191-11ec-2566-dd7ef873c33f
# ╟─036f4e12-c191-11ec-0f89-cf86eb10104e
# ╟─036f4e3a-c191-11ec-0529-a7c6b29b9449
# ╟─036f4e58-c191-11ec-3754-6977c6c2776b
# ╠═036f5a6a-c191-11ec-027b-193186d68e0e
# ╟─036f5ab0-c191-11ec-28cb-0bfcf3837203
# ╟─036f5ac4-c191-11ec-3bf0-1b584c8c515a
# ╠═036f61c2-c191-11ec-39a4-f130533afe2f
# ╟─036f61ea-c191-11ec-3335-7345e54f8559
# ╠═036f6622-c191-11ec-0986-fb000a38e3f8
# ╟─036f6648-c191-11ec-0799-adfc5f45a778
# ╟─036f6672-c191-11ec-1fc1-21e815827472
# ╟─036f6690-c191-11ec-07eb-e9b71edfb659
# ╟─036f66c2-c191-11ec-1a56-29d03b368833
# ╟─036f66fe-c191-11ec-16dc-eb9550954f30
# ╟─036f6712-c191-11ec-21a6-ed818e6fbb3f
# ╟─036f6726-c191-11ec-3c8d-e16e57cdda27
# ╟─036f6744-c191-11ec-1fcb-cf5c0af016cb
# ╟─036f674c-c191-11ec-2734-bf057cc757d8
# ╟─036f6762-c191-11ec-15ca-cbb9618f5508
# ╟─036f67a8-c191-11ec-00fd-f7a9dbf5ef23
# ╟─036f67bc-c191-11ec-33fc-6347b85e0e00
# ╟─036f67d0-c191-11ec-04da-9b6c99a3a94b
# ╟─036f67e4-c191-11ec-2f0b-2153a96137ea
# ╟─036f6802-c191-11ec-0423-03d41f9ab76a
# ╟─036f680c-c191-11ec-227d-17aaa08505c2
# ╟─036f6822-c191-11ec-18f5-95cafc905247
# ╟─036f6834-c191-11ec-052b-91236599e8a1
# ╟─036f696a-c191-11ec-12f5-e3ed77925b3b
# ╟─036f698a-c191-11ec-36ce-23ea9305c413
# ╟─036f69b0-c191-11ec-07b5-63b7884754ae
# ╟─036f6a28-c191-11ec-0a06-9399775b891d
# ╟─036f6a3c-c191-11ec-348c-a156d7b15f98
# ╟─036f6a5a-c191-11ec-28b4-a77fd0325ffa
# ╟─036f6a6e-c191-11ec-3e71-89878d84d10a
# ╠═036f73ce-c191-11ec-1bee-e10809fe3cab
# ╟─036f7400-c191-11ec-0c15-fd6bcef68fca
# ╟─036f7414-c191-11ec-02f2-f125feacd4a5
# ╟─036f7450-c191-11ec-0f28-09d696fac383
# ╟─036f7466-c191-11ec-3942-c561b082d3c3
# ╟─036f7482-c191-11ec-01ff-192521e3c5b8
# ╟─036f748c-c191-11ec-1eaf-cfff6b3654b7
# ╟─036f74ca-c191-11ec-1e9a-83d5ed5918fa
# ╟─036f74f0-c191-11ec-1b74-87e4a8e84535
# ╟─036f7518-c191-11ec-0cfb-21e596402fc3
# ╠═036f79b4-c191-11ec-2c24-e1ced027c203
# ╠═036f7fa6-c191-11ec-06ec-fd44b3678985
# ╟─036f8012-c191-11ec-27d6-b3ca5943f936
# ╟─036f8030-c191-11ec-16dc-49f1ca5be55f
# ╠═036f85e4-c191-11ec-1425-25f8336c7eac
# ╟─036f8620-c191-11ec-1c98-2d3d8a503e45
# ╟─036f8634-c191-11ec-0a6a-49d4a3759fe0
# ╟─036f868e-c191-11ec-280d-336cd9039d44
# ╟─036f86b6-c191-11ec-0434-299172363153
# ╟─036f86dc-c191-11ec-0064-e3493c46a926
# ╟─036f86fc-c191-11ec-1016-35040e1c138d
# ╟─036f8774-c191-11ec-2ae7-9f41392795ee
# ╟─036f8788-c191-11ec-31d7-4383864f167b
# ╟─036f879c-c191-11ec-277b-a18027b2c472
# ╟─036f87b2-c191-11ec-090c-412c6538683a
# ╟─036f87ba-c191-11ec-32f3-51f201831864
# ╟─036f88aa-c191-11ec-1bef-c150a61c327a
# ╟─036f88c8-c191-11ec-359c-8728549b71bd
# ╟─036f88e6-c191-11ec-1d22-9b68dc6a04b3
# ╟─036f88fa-c191-11ec-0ad8-4fbc184dd877
# ╟─036f8922-c191-11ec-2ca6-31354839abdd
# ╟─036f892c-c191-11ec-3978-bbd633a0cffe
# ╠═036f8ff8-c191-11ec-39fa-efbc41b66a5f
# ╟─036f902a-c191-11ec-03bc-6b07584e8bd2
# ╟─036f9050-c191-11ec-3dc2-9706632c2f0a
# ╠═036f9516-c191-11ec-20d1-8546edddffe9
# ╟─036f9566-c191-11ec-0af2-cd576d4b2798
# ╟─036f957a-c191-11ec-37eb-f369070f735e
# ╟─036f95b6-c191-11ec-3850-5f1a5d202207
# ╟─036f95f0-c191-11ec-02d0-276ec3d0284a
# ╟─036f95fc-c191-11ec-1825-55bc291112b9
# ╠═036f9b30-c191-11ec-3639-6325c2838da5
# ╟─036f9b4c-c191-11ec-2e03-1d7c01f12776
# ╟─036f9b74-c191-11ec-284b-fbb2264a8ccf
# ╠═036f9f48-c191-11ec-0773-9f33783f7f24
# ╟─036f9f7a-c191-11ec-318f-93208b2d9fb7
# ╟─036f9fa2-c191-11ec-140e-c56a99ea0f0b
# ╟─036f9fc0-c191-11ec-2bcb-717e1596a958
# ╠═036fa69e-c191-11ec-1730-79e18c4bc920
# ╟─036fa6be-c191-11ec-19df-851b07d8f36d
# ╟─036fa736-c191-11ec-2901-f7cde59c9377
# ╟─036fa768-c191-11ec-2a77-5929e690f0fe
# ╟─036fa806-c191-11ec-3210-8f0024d4028d
# ╟─036fa858-c191-11ec-3275-5d3790eb4d10
# ╟─036fa8b2-c191-11ec-2756-2f9726a2ed72
# ╟─036fa8c6-c191-11ec-23d7-73673d52be1a
# ╟─036fa916-c191-11ec-02e9-8d99a03b9c19
# ╟─036fa92a-c191-11ec-3188-833eccd12378
# ╟─036fa984-c191-11ec-33e5-fde9f1ad0046
# ╟─036fa98e-c191-11ec-2ecf-897f823ffae0
# ╟─036fa9b6-c191-11ec-2584-fda21119e4af
# ╟─036fa9e8-c191-11ec-19b5-afc6ea236040
# ╟─036fa9fc-c191-11ec-079b-eb724ab3802e
# ╟─036faa2e-c191-11ec-2904-2f460708a1fc
# ╟─036faa44-c191-11ec-27b7-4f43c4fb1883
# ╟─036faa60-c191-11ec-2d92-eb598bd079d4
# ╟─036faa6a-c191-11ec-26eb-7dc568f871e9
# ╟─036faa7e-c191-11ec-266a-adc496b44846
# ╟─036faa9c-c191-11ec-1080-ff977b37904d
# ╟─036faaba-c191-11ec-374b-3b796dd96430
# ╟─036faace-c191-11ec-16cb-6ffedabcb4cb
# ╟─036faae2-c191-11ec-2a34-bb4126d2db36
# ╟─036faaf6-c191-11ec-3ab2-4f6e48b5229c
# ╟─036fab1e-c191-11ec-2d23-f1067797b41b
# ╠═036fafba-c191-11ec-15a4-bfe0eb71997b
# ╟─036fafec-c191-11ec-1a8c-21cfac303193
# ╟─036fb012-c191-11ec-1bd4-7f79c4c88131
# ╟─036fb028-c191-11ec-3351-a342fc29c576
# ╟─036fb044-c191-11ec-137f-6791dc3c5edd
# ╟─036fb0b6-c191-11ec-21d6-4ba98d9def08
# ╟─036fb0c8-c191-11ec-3794-0fda15f16b93
# ╟─036fb104-c191-11ec-2149-5f09695c41a7
# ╟─036fb122-c191-11ec-3c4b-07d2a9b98762
# ╟─036fb154-c191-11ec-2d04-bb3afb095abb
# ╟─036fbba4-c191-11ec-005c-df6f87ffdb35
# ╟─036fbbc4-c191-11ec-066f-2d1fc1415c07
# ╟─036fbbfe-c191-11ec-323c-eb2d2f278624
# ╟─036fbc12-c191-11ec-38c5-fde49f063e94
# ╟─036fc732-c191-11ec-2312-35a34f70bd65
# ╟─036fc752-c191-11ec-281f-bbb11748ae70
# ╟─036fc77a-c191-11ec-1202-696c165addeb
# ╟─036fc7ac-c191-11ec-0fae-e1413d0d9f37
# ╟─036fd0f8-c191-11ec-0eb7-930804bf4e67
# ╟─036fd116-c191-11ec-1a6d-d78ec0e90c4b
# ╟─036fd13c-c191-11ec-1e4c-adadde937f1d
# ╟─036fd7e0-c191-11ec-0891-0ff074dc91df
# ╟─036fd800-c191-11ec-21dc-3124a85dacaf
# ╟─036fd81e-c191-11ec-0761-3f109b231bd6
# ╟─036fd83c-c191-11ec-3f0c-9b15a32536f2
# ╟─036fde7c-c191-11ec-1052-670eb1feeee1
# ╟─036fdea4-c191-11ec-36ea-59a67bf2569f
# ╟─036fe4bc-c191-11ec-3020-5f4c5638ef70
# ╟─036fe53e-c191-11ec-1aeb-1f8a4754a79a
# ╟─036fe552-c191-11ec-1105-4fccd65243eb
# ╟─036fec46-c191-11ec-22c2-7191bd5bb038
# ╟─036fec8c-c191-11ec-1206-d1cba0cef808
# ╟─036ff2c2-c191-11ec-1f08-2d46c6eb78f7
# ╟─036ff2fe-c191-11ec-2c66-09f8454a1a76
# ╟─036ff90a-c191-11ec-391b-a922ae7310cf
# ╟─036ff93e-c191-11ec-0188-6f72a2ea723d
# ╟─036ff984-c191-11ec-33f5-af4d3015815a
# ╟─037006a4-c191-11ec-0ce5-43a2e4d271e4
# ╟─037006cc-c191-11ec-28d5-ef5991c8082f
# ╟─03700708-c191-11ec-3167-63852943e56a
# ╟─0370181a-c191-11ec-313a-1724eb8dbb3e
# ╟─03701836-c191-11ec-2108-6d0f1b1f0d39
# ╟─03701860-c191-11ec-35b4-99a3fe337cac
# ╟─03701f04-c191-11ec-20c1-9b0ff36aff41
# ╟─03701f36-c191-11ec-1130-e9108aa64add
# ╟─03701f5e-c191-11ec-119b-057f3c55e410
# ╟─03702576-c191-11ec-1abf-5b3c60eb3747
# ╟─03702594-c191-11ec-0522-d3a5be09c3bd
# ╟─037025bc-c191-11ec-3ef9-1b61fa924dd6
# ╟─03702c7e-c191-11ec-3b29-7d80c0b17d02
# ╟─03702cb0-c191-11ec-3be8-e70ed9f90cdd
# ╟─03703700-c191-11ec-212c-5d1647e4e4de
# ╟─0370371e-c191-11ec-17b1-f35dfd61ecb3
# ╟─03703750-c191-11ec-0f93-833c81261de2
# ╟─03703d90-c191-11ec-16af-cf7b0e12c089
# ╟─03703dae-c191-11ec-09fe-91cda026f140
# ╟─03703dea-c191-11ec-2c70-8f66a7f82d76
# ╟─03703f00-c191-11ec-3e34-110096226eb7
# ╟─03703f16-c191-11ec-318d-2f73f4fa49f0
# ╟─03704a1a-c191-11ec-3461-53271aa7e8bc
# ╟─03704a38-c191-11ec-3c55-358d96c0d7be
# ╟─03704a6a-c191-11ec-38fb-859ecfa5d667
# ╟─03704a9c-c191-11ec-343a-43ad7f83e182
# ╟─03704ac4-c191-11ec-1528-c1c3f7c9e450
# ╟─03704ae0-c191-11ec-3ed1-31551781e382
# ╟─03704b12-c191-11ec-08f9-eb4a10f124d5
# ╟─03704b44-c191-11ec-101e-016282c1f910
# ╟─03704baa-c191-11ec-13de-31168bf19907
# ╟─03704bc8-c191-11ec-04d3-ebe4e15e8329
# ╟─03704be8-c191-11ec-01af-5743e428be4c
# ╟─03704c22-c191-11ec-3c7e-e94693353f67
# ╟─03705550-c191-11ec-2589-3de1cadf9542
# ╟─0370556e-c191-11ec-33c9-234fe136b62c
# ╟─037055a0-c191-11ec-30a8-8976d61f6104
# ╟─037055b4-c191-11ec-362d-c79c99da8c05
# ╟─037055e6-c191-11ec-1e11-ed8e58e87138
# ╟─037055fa-c191-11ec-02b6-d9a3ccaa1028
# ╟─03705dac-c191-11ec-24d5-59ee84a58817
# ╟─03705de8-c191-11ec-1554-69bcd3676108
# ╟─03705df2-c191-11ec-0651-3d97bc27de5f
# ╟─03705dfe-c191-11ec-321b-89c1d109a3c2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
