### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 2b1f1640-c187-11ec-2237-69d16e247d7e
begin
	using CalculusWithJulia
	using Plots
	import Contour: contours, levels, level, lines, coordinates
	using LinearAlgebra
	using ForwardDiff
end

# ╔═╡ 2b1f1dca-c187-11ec-0d73-bb401eb6b9be
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 2b20bd10-c187-11ec-3391-addc988ae0d9
using PlutoUI

# ╔═╡ 2b20bc98-c187-11ec-263b-8bbe0d2fa59f
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 2b1f0ada-c187-11ec-128e-43b7ce724a4d
md"""# 2D and 3D plots in Julia with Plots
"""

# ╔═╡ 2b1f0b50-c187-11ec-0aea-57760ea87cd3
md"""This section uses these add-on packages:
"""

# ╔═╡ 2b1f1e4c-c187-11ec-36c1-bd2ff3aa159d
md"""---
"""

# ╔═╡ 2b1f1ece-c187-11ec-27ca-4d8edebb9c24
md"""This covers plotting the typical 2D and 3D plots in Julia with the `Plots` package.
"""

# ╔═╡ 2b1f1f5c-c187-11ec-333e-d524a46c5b0a
md"""We will make use of some helper functions that will simplify plotting provided by the `CalculusWithJulia` package. As well, we will need to manipulate contours directly, so pull in the `Contours` package, using `import` to avoid name collisions and explicitly listing the methods we will use.
"""

# ╔═╡ 2b1f1fc8-c187-11ec-3fe1-135f4db69d7f
md"""## Parametrically described curves in space
"""

# ╔═╡ 2b1f20b8-c187-11ec-37a5-3778d266fe4f
md"""Let $r(t)$ be a vector-valued function with values in $R^d$, $d$ being $2$ or $3$. A familiar example is the equation for a line that travels in the direction of $\vec{v}$ and goes through the point $P$: $r(t) = P + t \cdot \vec{v}$. A *parametric plot* over $[a,b]$ is the collection of all points $r(t)$ for $a \leq t \leq b$.
"""

# ╔═╡ 2b1f2156-c187-11ec-03a0-eda02166a3b8
md"""In `Plots`, parameterized curves can be plotted through two interfaces, here illustrated for $d=2$: `plot(f1, f2, a, b)` or `plot(xs, ys)`. The former is convenient for some cases, but typically we will have a function `r(t)` which is vector-valued, as opposed to a vector of functions. As such, we only discuss the latter.
"""

# ╔═╡ 2b1f21a8-c187-11ec-31bc-591a4388d4e6
md"""An example helps illustrate. Suppose $r(t) = \langle \sin(t), 2\cos(t) \rangle$ and the goal is to plot the full ellipse by plotting over $0 \leq t \leq 2\pi$. As with plotting of curves, the goal would be to take many points between `a` and `b` and from there generate the $x$ values and $y$ values.
"""

# ╔═╡ 2b1f21da-c187-11ec-019e-0f006834cdfe
md"""Let's see this with 5 points, the first and last being identical due to the curve:
"""

# ╔═╡ 2b1f30ee-c187-11ec-3e57-7fee99666f1c
begin
	r₂(t) = [sin(t), 2cos(t)]
	ts = range(0, stop=2pi, length=5)
end

# ╔═╡ 2b1f317a-c187-11ec-33e5-f37af0b1b476
md"""Then we can create the $5$ points easily through broadcasting:
"""

# ╔═╡ 2b1f35e4-c187-11ec-1d64-6944a9c298d8
vs = r₂.(ts)

# ╔═╡ 2b1f3670-c187-11ec-1658-31c3ad5e0a4e
md"""This returns a vector of points (stored as vectors). The plotting function wants two collections: the set of $x$ values for the points and the set of $y$ values. The data needs to be generated differently or reshaped. The function `unzip` above takes data in this style and returns the desired format, returning a tuple with the $x$ values and $y$ values pulled out:
"""

# ╔═╡ 2b1f39de-c187-11ec-1b89-d3c06e2dbdf3
unzip(vs)

# ╔═╡ 2b1f3a42-c187-11ec-12ac-2bb69c89bc5e
md"""To plot this, we "splat" the tuple so that `plot` gets the arguments separately:
"""

# ╔═╡ 2b1f3dfa-c187-11ec-2944-1fdff676e75c
plot(unzip(vs)...)

# ╔═╡ 2b1f3e54-c187-11ec-2dc3-912bca453095
md"""This  basic plot is lacking, of course, as there are not enough points. Using more initially is a remedy.
"""

# ╔═╡ 2b1f48b8-c187-11ec-3234-bbbdb5da3f24
let
	ts = range(0, 2pi, length=100)
	plot(unzip(r₂.(ts))...)
end

# ╔═╡ 2b1f491c-c187-11ec-1047-e76b4fcc1a0a
md"""As a convenience, `CalculusWithJulia` provides `plot_parametric` to produce this plot. The interval is specified with the  `a..b` notation, the points to plot are adaptively chosen:
"""

# ╔═╡ 2b1f4eee-c187-11ec-181b-854ed9556766
plot_parametric(0..2pi, r₂)  # interval first

# ╔═╡ 2b1f4f84-c187-11ec-1e16-df436ac090c8
md"""### Plotting a space curve in 3 dimensions
"""

# ╔═╡ 2b1f501a-c187-11ec-0db8-b16f3dfb91d1
md"""A parametrically described curve in 3D is similarly created. For example, a helix is described mathematically by $r(t) = \langle \sin(t), \cos(t), t \rangle$. Here we graph two turns:
"""

# ╔═╡ 2b1f5a24-c187-11ec-25b0-994b469ae9ad
begin
	r₃(t) = [sin(t), cos(t), t]
	plot_parametric(0..4pi, r₃)
end

# ╔═╡ 2b1f5a60-c187-11ec-0519-d9c9484493c6
md"""### Adding a vector
"""

# ╔═╡ 2b1f5ad6-c187-11ec-17c2-4b1fee16fe32
md"""The tangent vector indicates the instantaneous direction one would travel were they walking along the space curve. We can add a tangent vector to the graph. The `quiver!` function would be used to add a 2D vector, but `Plots` does not currently have a `3D` analog. In addition, `quiver!` has a somewhat cumbersome calling pattern when adding just one vector. The `CalculusWithJulia` package defines an `arrow!` function that uses `quiver` for 2D arrows and a simple line for 3D arrows. As a vector incorporates magnitude and direction, but not a position, `arrow!` needs both a point for the position and a vector.
"""

# ╔═╡ 2b1f5af6-c187-11ec-05e6-61625754e28d
md"""Here is how we can visualize the tangent vector at a few points on the helix:
"""

# ╔═╡ 2b1f6532-c187-11ec-00c0-b5d65b09b697
let
	plot_parametric(0..4pi, r₃, legend=false)
	ts = range(0, 4pi, length=5)
	for t in ts
	   arrow!(r₃(t), r₃'(t))
	end
end

# ╔═╡ 2b1f6c76-c187-11ec-3cab-9120593bc138
note("""Adding many arrows this way would be inefficient.""")

# ╔═╡ 2b1f6cd0-c187-11ec-0657-05ad2e36a356
md"""### Setting a viewing angle for 3D plots
"""

# ╔═╡ 2b1f6d66-c187-11ec-09ca-d157eed113d7
md"""For 3D plots, the viewing angle can make the difference in visualizing the key features. In `Plots`, some backends allow the viewing angle to be set with the mouse by clicking and dragging. Not all do. For such, the `camera` argument is used, as in `camera(azimuthal, elevation)` where the angles are given in degrees. If the $x$-$y$-$z$ coorinates are given, then `elevation` or *inclination*, is the angle between the $z$ axis and the $x-y$ plane (so `90` is a top view) and `azimuthal` is the angle in the $x-y$ plane from the $x$ axes.
"""

# ╔═╡ 2b1f6dd4-c187-11ec-12d2-fb7d6b3b1c30
md"""## Visualizing functions from $R^2 \rightarrow R$
"""

# ╔═╡ 2b1f6e6a-c187-11ec-0389-4d1c1dd69bb2
md"""If a function $f: R^2 \rightarrow R$ then a graph of $(x,y,f(x,y))$ can be represented in 3D. It will form a surface. Such graphs can be most simply made by specifying a set of $x$ values, a set of $y$ values and a function $f$, as with:
"""

# ╔═╡ 2b1f7a34-c187-11ec-1194-f5531d4871d4
begin
	xs = range(-2, stop=2, length=100)
	ys = range(-pi, stop=pi, length=100)
	f(x,y) = x*sin(y)
	surface(xs, ys, f)
end

# ╔═╡ 2b1f7aae-c187-11ec-3f2e-9134b509d8f8
md"""Rather than pass in a function, values can be passed in. Here they are generated with a list comprehension. The `y` values are innermost to match the graphic when passing in a function object:
"""

# ╔═╡ 2b1f84b0-c187-11ec-33a6-af31df5463e5
let
	zs = [f(x,y) for y in ys, x in xs]
	surface(xs, ys, zs)
end

# ╔═╡ 2b1f8562-c187-11ec-279c-ebc374463a61
md"""Remembering if the `ys` or `xs` go first in the above can be hard. Alternatively, broadcasting can be used. The command `f.(xs,ys)` would return a vector, as the `xs` and `ys` match in shape–they are both column vectors. But the *transpose* of `xs` looks like a *row* vector and `ys` looks like a column vector, so broadcasting will create a matrix of values, as desired here:
"""

# ╔═╡ 2b1fb276-c187-11ec-2dba-057b5b09038f
surface(xs, ys, f.(xs', ys))

# ╔═╡ 2b1fb3d4-c187-11ec-266b-6dd61837deb3
md"""This graph shows the tessalation algorithm. Here only the grid in the $x$-$y$ plane is just one cell:
"""

# ╔═╡ 2b1fc324-c187-11ec-0ad1-f3bf01873fab
let
	xs = ys = range(-1, 1, length=2)
	f(x,y) = x*y
	surface(xs, ys, f)
end

# ╔═╡ 2b1fc37e-c187-11ec-2c83-e5600a4d6f63
md"""A more accurate graph, can be seen here:
"""

# ╔═╡ 2b1fcfe0-c187-11ec-3391-e1085a2877d1
let
	xs = ys = range(-1, 1, length=100)
	f(x,y) = x*y
	surface(xs, ys, f)
end

# ╔═╡ 2b1fd046-c187-11ec-2438-cbc63e5a8972
md"""### Contour plots
"""

# ╔═╡ 2b1fd078-c187-11ec-07fc-47bb12cff27f
md"""Returning to the
"""

# ╔═╡ 2b1fd0bc-c187-11ec-3d89-ffcc7ff3317d
md"""The contour plot of $f:R^2 \rightarrow R$ draws level curves, $f(x,y)=c$, for different values of $c$ in the $x-y$ plane. They are produced in a similar manner as the surface plots:
"""

# ╔═╡ 2b20097e-c187-11ec-3fa1-111c12599376
let
	xs = ys = range(-2,2, length=100)
	f(x,y) = x*y
	contour(xs, ys, f)
end

# ╔═╡ 2b200b0e-c187-11ec-0ebd-9d1e703f0360
md"""The cross in the middle corresponds to $c=0$, as when $x=0$ or $y=0$ then $f(x,y)=0$.
"""

# ╔═╡ 2b200b86-c187-11ec-3bc5-ab800b387c65
md"""Similarly, computed values for $f(x,y)$ can be passed in. Here we change the function:
"""

# ╔═╡ 2b201de2-c187-11ec-0f15-813226f00f9a
let
	f(x,y) = 2 - (x^2 + y^2)
	xs = ys = range(-2,2, length=100)
	
	zs = [f(x,y) for y in ys, x in xs]
	
	contour(xs, ys, zs)
end

# ╔═╡ 2b201ea0-c187-11ec-2612-e73712887355
md"""The chosen levels can be specified by the user through the `levels` argument, as in:
"""

# ╔═╡ 2b202d82-c187-11ec-1099-9d799a1da83c
let
	f(x,y) = 2 - (x^2 + y^2)
	xs = ys = range(-2,2, length=100)
	
	zs = [f(x,y) for y in ys, x in xs]
	
	contour(xs, ys, zs, levels = [-1.0, 0.0, 1.0])
end

# ╔═╡ 2b202ee0-c187-11ec-34f3-17550a9aca85
md"""If only a single level is desired, as scalar value can be specified. Though not with all backends for `Plots`. For example, this next graphic shows the $0$-level of the [devil](http://www-groups.dcs.st-and.ac.uk/~history/Curves/Devils.html)'s curve.
"""

# ╔═╡ 2b2039bc-c187-11ec-24ea-71fa9ea1300e
let
	gr()  # PyPlot, our default, has issues with just 1 level
	a, b = -1, 2
	f(x,y) = y^4 - x^4 + a*y^2 + b*x^2
	xs = ys = range(-5, stop=5, length=100)
	contour(xs, ys, f, levels=[0.0])
end

# ╔═╡ 2b203af2-c187-11ec-0070-f9be97211978
md"""Contour plots are well known from the presence of contour lines on many maps. Contour lines indicate constant elevations. A peak is characterized by a series of nested closed paths. The following graph shows this for the peak at $(x,y)=(0,0)$.
"""

# ╔═╡ 2b2040f6-c187-11ec-1956-b1d0598fb21b
let
	pyplot()
	xs = ys = range(-pi/2, stop=pi/2, length=100)
	f(x,y) = sinc(sqrt(x^2 + y^2))   # sinc(x) is sin(x)/x
	contour(xs, ys, f)
end

# ╔═╡ 2b204196-c187-11ec-06f0-f32cec6d4377
md"""Contour plots can be filled with colors through the `contourf` function:
"""

# ╔═╡ 2b205370-c187-11ec-0673-bba54c4f90f1
let
	xs = ys = range(-pi/2, stop=pi/2, length=100)
	f(x,y) = sinc(sqrt(x^2 + y^2))
	
	contourf(xs, ys, f)
end

# ╔═╡ 2b2053ca-c187-11ec-3f09-f3b4f5e6a9f0
md"""### Combining surface plots and contour plots
"""

# ╔═╡ 2b20544c-c187-11ec-1e95-bd62fd3c6926
md"""In `PyPlot` it is possible to add a contour lines to the surface, or projected onto an axis. To replicate something similar, though not as satisfying, in `Plots` we use the `Contour` package.
"""

# ╔═╡ 2b205fb4-c187-11ec-1df9-bd5c72bd29cf
let
	f(x,y) = 2 + x^2 + y^2
	xs = ys = range(-2, stop=2, length=100)
	zs = [f(x,y) for y in ys, x in xs]
	
	p = surface(xs, ys, zs, legend=false, fillalpha=0.5)
	
	## we add to the graphic p, then plot
	for cl in levels(contours(xs, ys, zs))
	    lvl = level(cl) # the z-value of this contour level
	    for line in lines(cl)
	        _xs, _ys = coordinates(line) # coordinates of this line segment
	        _zs = 0 * _xs
	        plot!(p, _xs, _ys, lvl .+ _zs, alpha=0.5) # add on surface
	        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add on x-y plane
	    end
	end
	p
end

# ╔═╡ 2b20600e-c187-11ec-3434-f9e994bd2e6c
md"""There is no hidden line calculuation, in place we give the contour lines a transparency through the argument `alpha=0.5`.
"""

# ╔═╡ 2b20604a-c187-11ec-2bb9-8d2b77365fff
md"""### Gradient and surface plots
"""

# ╔═╡ 2b2060d6-c187-11ec-2473-0ffce58d64e9
md"""The surface plot of $f: R^2 \rightarrow R$ plots $(x, y, f(x,y))$ as a surface. The *gradient* of $f$ is $\langle \partial f/\partial x, \partial f/\partial y\rangle$. It is a two-dimensional object indicating the direction at a point $(x,y)$ where the surface has the greatest ascent. Illurating the gradient and the surface on the same plot requires embedding the 2D gradient into the 3D surface. This can be done by adding a constant $z$ value to the gradient, such as $0$.
"""

# ╔═╡ 2b206d60-c187-11ec-3899-615aa29087d0
let
	f(x,y) = 2 - (x^2 + y^2)
	xs = ys = range(-2, stop=2, length=100)
	zs = [f(x,y) for y in ys, x in xs]
	
	surface(xs, ys, zs, camera=(40, 25), legend=false)
	p = [-1, 1] # in the region graphed, [-2,2] × [-2, 2]
	
	f(x) = f(x...)
	v = ForwardDiff.gradient(f, p)
	
	
	# add 0 to p and v (two styles)
	push!(p, -15)
	scatter!(unzip([p])..., markersize=3)
	
	v = vcat(v, 0)
	arrow!(p, v)
end

# ╔═╡ 2b206da6-c187-11ec-09aa-6d3ff0f5d0fb
md"""### The tangent plane
"""

# ╔═╡ 2b206e0a-c187-11ec-3ab6-d773d06c394f
md"""Let $z = f(x,y)$ describe a surface, and $F(x,y,z) = f(x,y) - z$. The the gradient of $F$ at a point $p$ on the surface, $\nabla F(p)$, will be normal to the surface and for a function, $f(p) + \nabla f \cdot (x-p)$ describes the tangent plane. We can visualize each, as follows:
"""

# ╔═╡ 2b207990-c187-11ec-39e9-5d51330fe0bb
let
	f(x,y) = 2 - x^2 - y^2
	f(v) = f(v...)
	F(x,y,z) = z - f(x,y)
	F(v) = F(v...)
	p = [1/10, -1/10]
	global p1 = vcat(p, f(p...)) # note F(p1) == 0
	global n⃗ = ForwardDiff.gradient(F, p1)
	global tl(x) = f(p) +  ForwardDiff.gradient(f, p) ⋅ (x - p)
	tl(x,y) = tl([x,y])
	
	xs = ys = range(-2, stop=2, length=100)
	surface(xs, ys, f)
	surface!(xs, ys, tl)
	arrow!(p1, 5n⃗)
end

# ╔═╡ 2b207a44-c187-11ec-163d-6f91a98ca68d
md"""From some viewing angles, the normal does not look perpendicular to the tangent plane. This is a quick verification for a randomly chosen point in the $x-y$ plane:
"""

# ╔═╡ 2b208162-c187-11ec-1ebd-2b5b378ba8d4
begin
	a, b = randn(2)
	dot(n⃗, (p1 - [a,b, tl(a,b)]))
end

# ╔═╡ 2b2081b0-c187-11ec-2012-27859b247334
md"""### Parameterized surface plots
"""

# ╔═╡ 2b20821e-c187-11ec-2b48-7de5b710694f
md"""As illustrated, we can plot surfaces of the form $(x,y,f(x,y)$. However, not all surfaces are so readily described. For example, if $F(x,y,z)$ is a function from $R^3 \rightarrow R$, then $F(x,y,z)=c$ is a surface of interest. For example, the sphere of radius one is a solution to $F(x,y,z)=1$ where $F(x,y,z) =  x^2 + y^2 + z^2$.
"""

# ╔═╡ 2b2082be-c187-11ec-3c83-114bff196a5b
md"""Plotting such generally described surfaces is not so easy, but *parameterized* surfaces can be represented. For example, the sphere as a surface is not represented as a surface of a function, but can be represented in spherical coordinates as parameterized by two angles, essentially an "azimuth" and and "elevation", as used with the `camera` argument.
"""

# ╔═╡ 2b2082e6-c187-11ec-1cd9-8f68159dc4f3
md"""Here we define functions that represent $(x,y,z)$ coordinates in terms of the corresponding spherical coordinates $(r, \theta, \phi)$.
"""

# ╔═╡ 2b208bce-c187-11ec-2ff4-fda4d0d80292
begin
	# spherical: (radius r, inclination θ, azimuth φ)
	X(r,theta,phi) = r * sin(theta) * sin(phi)
	Y(r,theta,phi) = r * sin(theta) * cos(phi)
	Z(r,theta,phi) = r * cos(theta)
end

# ╔═╡ 2b208c32-c187-11ec-3258-214df1f47609
md"""We can parameterize the sphere by plotting values for $x$, $y$, and $z$ produced by a sequence of values for $\theta$ and $\phi$, holding $r=1$:
"""

# ╔═╡ 2b209600-c187-11ec-061a-1787c263ccc5
let
	thetas = range(0, stop=pi,   length=50)
	phis   = range(0, stop=pi/2, length=50)
	
	xs = [X(1, theta, phi) for theta in thetas, phi in phis]
	ys = [Y(1, theta, phi) for theta in thetas, phi in phis]
	zs = [Z(1, theta, phi) for theta in thetas, phi in phis]
	
	surface(xs, ys, zs)
end

# ╔═╡ 2b209e54-c187-11ec-02e9-8d290eacb45a
note("The above may not work with all backends for `Plots`, even if those that support 3D graphics.")

# ╔═╡ 2b209eb4-c187-11ec-3465-0347527c3124
md"""For convenience, the `plot_parametric` function from `CalculusWithJulia` can produce these plots using interval notation and a function:
"""

# ╔═╡ 2b20aa00-c187-11ec-15af-5f35db358551
let
	F(theta, phi) = [X(1, theta, phi), Y(1, theta, phi), Z(1, theta, phi)]
	plot_parametric(0..pi, 0..pi/2, F)
end

# ╔═╡ 2b20aa66-c187-11ec-0800-bdfbe80c8f56
md"""### Plotting  F(x,y, z) = c
"""

# ╔═╡ 2b20ab04-c187-11ec-1661-f5e85ea60f5a
md"""There is no built in functionality in `Plots` to create surface described by $F(x,y,z) = c$. An example of how to provide some such functionality for `PyPlot` appears [here](https://stackoverflow.com/questions/4680525/plotting-implicit-equations-in-3d ). The non-exported `plot_implicit_surface` function can be used to approximate this.
"""

# ╔═╡ 2b20ab2a-c187-11ec-000e-773f4254d53f
md"""To use it, we see what happens when a sphere if rendered:
"""

# ╔═╡ 2b20b504-c187-11ec-2c59-d376c8fcc6fc
let
	f(x,y,z) = x^2 + y^2 + z^2 - 25
	CalculusWithJulia.plot_implicit_surface(f)
end

# ╔═╡ 2b20b590-c187-11ec-2100-c3fbab2118a8
md"""This figure comes from a February 14, 2019 article in the [New York Times](https://www.nytimes.com/2019/02/14/science/math-algorithm-valentine.html). It shows an equation for a "heart," as the graphic will illustrate:
"""

# ╔═╡ 2b20bc70-c187-11ec-063e-576dcb363483
let
	a,b = 1,3
	f(x,y,z) = (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3
	CalculusWithJulia.plot_implicit_surface(f, xlim=-2..2, ylim=-1..1, zlim=-1..2)
end

# ╔═╡ 2b20bd06-c187-11ec-2c9b-95b47902b893
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/vector_fields.html">◅ previous</a>  <a href="../alternatives/makie_plotting.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/plots_plotting.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 2b20bd56-c187-11ec-1284-550c04e68d3b
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Contour = "d38c429a-6771-53c6-b99e-75d170b6e991"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"

[compat]
CalculusWithJulia = "~0.0.17"
Contour = "~0.5.7"
ForwardDiff = "~0.10.25"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
PyPlot = "~2.10.0"
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
# ╟─2b20bc98-c187-11ec-263b-8bbe0d2fa59f
# ╟─2b1f0ada-c187-11ec-128e-43b7ce724a4d
# ╟─2b1f0b50-c187-11ec-0aea-57760ea87cd3
# ╠═2b1f1640-c187-11ec-2237-69d16e247d7e
# ╟─2b1f1dca-c187-11ec-0d73-bb401eb6b9be
# ╟─2b1f1e4c-c187-11ec-36c1-bd2ff3aa159d
# ╟─2b1f1ece-c187-11ec-27ca-4d8edebb9c24
# ╟─2b1f1f5c-c187-11ec-333e-d524a46c5b0a
# ╟─2b1f1fc8-c187-11ec-3fe1-135f4db69d7f
# ╟─2b1f20b8-c187-11ec-37a5-3778d266fe4f
# ╟─2b1f2156-c187-11ec-03a0-eda02166a3b8
# ╟─2b1f21a8-c187-11ec-31bc-591a4388d4e6
# ╟─2b1f21da-c187-11ec-019e-0f006834cdfe
# ╠═2b1f30ee-c187-11ec-3e57-7fee99666f1c
# ╟─2b1f317a-c187-11ec-33e5-f37af0b1b476
# ╠═2b1f35e4-c187-11ec-1d64-6944a9c298d8
# ╟─2b1f3670-c187-11ec-1658-31c3ad5e0a4e
# ╠═2b1f39de-c187-11ec-1b89-d3c06e2dbdf3
# ╟─2b1f3a42-c187-11ec-12ac-2bb69c89bc5e
# ╠═2b1f3dfa-c187-11ec-2944-1fdff676e75c
# ╟─2b1f3e54-c187-11ec-2dc3-912bca453095
# ╠═2b1f48b8-c187-11ec-3234-bbbdb5da3f24
# ╟─2b1f491c-c187-11ec-1047-e76b4fcc1a0a
# ╠═2b1f4eee-c187-11ec-181b-854ed9556766
# ╟─2b1f4f84-c187-11ec-1e16-df436ac090c8
# ╟─2b1f501a-c187-11ec-0db8-b16f3dfb91d1
# ╠═2b1f5a24-c187-11ec-25b0-994b469ae9ad
# ╟─2b1f5a60-c187-11ec-0519-d9c9484493c6
# ╟─2b1f5ad6-c187-11ec-17c2-4b1fee16fe32
# ╟─2b1f5af6-c187-11ec-05e6-61625754e28d
# ╠═2b1f6532-c187-11ec-00c0-b5d65b09b697
# ╟─2b1f6c76-c187-11ec-3cab-9120593bc138
# ╟─2b1f6cd0-c187-11ec-0657-05ad2e36a356
# ╟─2b1f6d66-c187-11ec-09ca-d157eed113d7
# ╟─2b1f6dd4-c187-11ec-12d2-fb7d6b3b1c30
# ╟─2b1f6e6a-c187-11ec-0389-4d1c1dd69bb2
# ╠═2b1f7a34-c187-11ec-1194-f5531d4871d4
# ╟─2b1f7aae-c187-11ec-3f2e-9134b509d8f8
# ╠═2b1f84b0-c187-11ec-33a6-af31df5463e5
# ╟─2b1f8562-c187-11ec-279c-ebc374463a61
# ╠═2b1fb276-c187-11ec-2dba-057b5b09038f
# ╟─2b1fb3d4-c187-11ec-266b-6dd61837deb3
# ╠═2b1fc324-c187-11ec-0ad1-f3bf01873fab
# ╟─2b1fc37e-c187-11ec-2c83-e5600a4d6f63
# ╠═2b1fcfe0-c187-11ec-3391-e1085a2877d1
# ╟─2b1fd046-c187-11ec-2438-cbc63e5a8972
# ╟─2b1fd078-c187-11ec-07fc-47bb12cff27f
# ╟─2b1fd0bc-c187-11ec-3d89-ffcc7ff3317d
# ╠═2b20097e-c187-11ec-3fa1-111c12599376
# ╟─2b200b0e-c187-11ec-0ebd-9d1e703f0360
# ╟─2b200b86-c187-11ec-3bc5-ab800b387c65
# ╠═2b201de2-c187-11ec-0f15-813226f00f9a
# ╟─2b201ea0-c187-11ec-2612-e73712887355
# ╠═2b202d82-c187-11ec-1099-9d799a1da83c
# ╟─2b202ee0-c187-11ec-34f3-17550a9aca85
# ╠═2b2039bc-c187-11ec-24ea-71fa9ea1300e
# ╟─2b203af2-c187-11ec-0070-f9be97211978
# ╠═2b2040f6-c187-11ec-1956-b1d0598fb21b
# ╟─2b204196-c187-11ec-06f0-f32cec6d4377
# ╠═2b205370-c187-11ec-0673-bba54c4f90f1
# ╟─2b2053ca-c187-11ec-3f09-f3b4f5e6a9f0
# ╟─2b20544c-c187-11ec-1e95-bd62fd3c6926
# ╠═2b205fb4-c187-11ec-1df9-bd5c72bd29cf
# ╟─2b20600e-c187-11ec-3434-f9e994bd2e6c
# ╟─2b20604a-c187-11ec-2bb9-8d2b77365fff
# ╟─2b2060d6-c187-11ec-2473-0ffce58d64e9
# ╠═2b206d60-c187-11ec-3899-615aa29087d0
# ╟─2b206da6-c187-11ec-09aa-6d3ff0f5d0fb
# ╟─2b206e0a-c187-11ec-3ab6-d773d06c394f
# ╠═2b207990-c187-11ec-39e9-5d51330fe0bb
# ╟─2b207a44-c187-11ec-163d-6f91a98ca68d
# ╠═2b208162-c187-11ec-1ebd-2b5b378ba8d4
# ╟─2b2081b0-c187-11ec-2012-27859b247334
# ╟─2b20821e-c187-11ec-2b48-7de5b710694f
# ╟─2b2082be-c187-11ec-3c83-114bff196a5b
# ╟─2b2082e6-c187-11ec-1cd9-8f68159dc4f3
# ╠═2b208bce-c187-11ec-2ff4-fda4d0d80292
# ╟─2b208c32-c187-11ec-3258-214df1f47609
# ╠═2b209600-c187-11ec-061a-1787c263ccc5
# ╟─2b209e54-c187-11ec-02e9-8d290eacb45a
# ╟─2b209eb4-c187-11ec-3465-0347527c3124
# ╠═2b20aa00-c187-11ec-15af-5f35db358551
# ╟─2b20aa66-c187-11ec-0800-bdfbe80c8f56
# ╟─2b20ab04-c187-11ec-1661-f5e85ea60f5a
# ╟─2b20ab2a-c187-11ec-000e-773f4254d53f
# ╠═2b20b504-c187-11ec-2c59-d376c8fcc6fc
# ╟─2b20b590-c187-11ec-2100-c3fbab2118a8
# ╠═2b20bc70-c187-11ec-063e-576dcb363483
# ╟─2b20bd06-c187-11ec-2c9b-95b47902b893
# ╟─2b20bd10-c187-11ec-3391-addc988ae0d9
# ╟─2b20bd56-c187-11ec-1284-550c04e68d3b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
