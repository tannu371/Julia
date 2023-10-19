### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 02a163dc-797b-11ec-1c80-2556577bd076
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
	using DifferentialEquations
	using LinearAlgebra
	using QuadGK
end

# ╔═╡ 02a16974-797b-11ec-167a-d73f96efafc6
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 02d6d9f8-797b-11ec-21fd-a9cc6c60f007
using PlutoUI

# ╔═╡ 02d6d9ba-797b-11ec-33ea-c53419988a14
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 0287616e-797b-11ec-0c84-e18105525db4
md"""# Vector-valued functions, $f:R \rightarrow R^n$
"""

# ╔═╡ 0289ecb8-797b-11ec-3a0f-4d6181fa22d6
md"""This section uses these add-on packages:
"""

# ╔═╡ 02a36b7a-797b-11ec-28b4-d51e182605c7
md"""---
"""

# ╔═╡ 02a50f98-797b-11ec-2acb-2904f766cde2
md"""We discuss functions of a single variable that return a vector in $R^n$. There are many parallels to univariate functions (when $n=1$) and differences.
"""

# ╔═╡ 02a7bb14-797b-11ec-2530-bbe052567e82
md"""## Definition
"""

# ╔═╡ 02a7bb8a-797b-11ec-3dad-0d81bc2ef139
md"""A function $\vec{f}: R \rightarrow R^n$, $n > 1$ is called a vector-valued function. Some examples:
"""

# ╔═╡ 02a9bbd8-797b-11ec-3f62-e7e110b18853
md"""```math
\vec{f}(t) = \langle \sin(t), 2\cos(t) \rangle, \quad
\vec{g}(t) = \langle \sin(t), \cos(t), t \rangle, \quad
\vec{h}(t) = \langle 2, 3 \rangle + t \cdot \langle 1, 2 \rangle.
```
"""

# ╔═╡ 02a9bc5a-797b-11ec-3f0c-17e417f8dc3a
md"""The components themselves are also functions of $t$, in this case univariate functions. Depending on the context, it can be useful to view vector-valued functions as a function that returns a vector, or a vector of the component functions.
"""

# ╔═╡ 02a9bc80-797b-11ec-09c7-09adb58bce2f
md"""The above example functions have $n$ equal $2$, $3$, and $2$ respectively. We will see that many concepts of calculus for univariate functions ($n=1$) have direct counterparts.
"""

# ╔═╡ 02a9bc96-797b-11ec-304b-c7c9a61d1c43
md"""(We use $\vec{f}$ above to emphasize the return value is a vector, but will quickly drop that notation and let context determine if $f$ refers to a scalar- or vector-valued function.)
"""

# ╔═╡ 02a9bcc8-797b-11ec-1c90-7b6c9b5ebbea
md"""## Representation in Julia
"""

# ╔═╡ 02b147f4-797b-11ec-2203-e19b0bb51937
md"""In `Julia`, the representation of a vector-valued function is straightforward: we define a function of a single variable that returns a vector. For example, the three functions above would be represented by:
"""

# ╔═╡ 02b15262-797b-11ec-3ed3-dddf5c3294da
begin
	f(t) = [sin(t), 2*cos(t)]
	g(t) = [sin(t), cos(t), t]
	h(t) = [2, 3] + t * [1, 2]
end

# ╔═╡ 02b152ba-797b-11ec-3d02-63969ec1e780
md"""For a given `t`, these evaluate to a vector. For example:
"""

# ╔═╡ 02b154b0-797b-11ec-23d0-4192d193db82
h(2)

# ╔═╡ 02b154e2-797b-11ec-07ba-a15c3203649b
md"""We can create a vector of functions, e.g., `F = [cos, sin, identity]`, but calling this object, as in `F(t)`, would require some work, such as `t = 1; [f(t) for f in F]` or `1 .|> F`.
"""

# ╔═╡ 02b1588c-797b-11ec-36a0-2330362df1ea
begin
	F = [cos, sin, identity]
	[f(1) for f in F]
end

# ╔═╡ 02b158a2-797b-11ec-10be-f13d6651b287
md"""or
"""

# ╔═╡ 02b15abe-797b-11ec-0ac5-01ecba2c5e17
1 .|> F

# ╔═╡ 02b15adc-797b-11ec-10d2-df8092f57b35
md"""## Space curves
"""

# ╔═╡ 02b30532-797b-11ec-00d7-65c8f070aab1
md"""A vector-valued function is typically visualized as a curve. That is, for some range, $a \leq t \leq b$ the set of points $\{\vec{f}(t): a \leq t \leq b\}$ are plotted. If, say in $n=2$, we have $x(t)$ and $y(t)$ as the component functions, then the graph would also be the parametric plot of $x$ and $y$. The term *planar* curve is common for the $n=2$ case and *space* curve for the $n \geq 3$ case.
"""

# ╔═╡ 02b30580-797b-11ec-258c-d1220d4d83a6
md"""This plot represents the vectors with their tails at the origin.
"""

# ╔═╡ 02b305bc-797b-11ec-1b2e-b35c7119f8ac
md"""There is a convention for plotting the component functions to yield a parametric plot within the `Plots` package (e.g., `plot(x, y, a, b)`). This can be used to make polar plots, where `x` is  `t -> r(t)*cos(t)` and `y` is `t -> r(t)*sin(t)`.
"""

# ╔═╡ 02b305e4-797b-11ec-27fb-53ea72741ba7
md"""However,  we will use a different approach, as the component functions are not naturally produced from the vector-valued function.
"""

# ╔═╡ 02b30620-797b-11ec-0d29-358fec11cb36
md"""In `Plots`, the command `plot(xs, ys)`, where, say, `xs=[x1, x2, ..., xn]` and `ys=[y1, y2, ..., yn]`, will make a connect-the-dot plot between corresponding pairs of points. As previously discussed, this can be used as an alternative to plotting a function through `plot(f, a, b)`: first make a set of $x$ values, say `xs=range(a, b, length=100)`; then the corresponding $y$ values, say `ys = f.(xs)`; and then plotting through `plot(xs, ys)`.
"""

# ╔═╡ 02b3063e-797b-11ec-1bd1-91bba71aa5b6
md"""Similarly, were a third vector, `zs`, for $z$ components used, `plot(xs, ys, zs)` will make a $3$-dimensional connect the dot plot
"""

# ╔═╡ 02b3065c-797b-11ec-2915-010fe9624f5a
md"""However, our representation of vector-valued functions naturally generates a vector of points: `[[x1,y1], [x2, y2], ..., [xn, yn]]`, as this comes from broadcasting `f` over some time values. That is, for a collection of time values, `ts` the command `f.(ts)` will produce a vector of points. (Technically a vector of vectors, but points if you identify the $2-d$ vectors as points.)
"""

# ╔═╡ 02b3069a-797b-11ec-3f79-5b2a9983bffa
md"""To get the `xs` and `ys` from this, is conceptually easy: just iterate over all the points and extract the corresponding component. For example, to get `xs` we would have a command like `[p[1] for p in f.(ts)]`. Similarly, the `ys` would use `p[2]` in place of `p[1]`. The `unzip` function from the `CalculusWithJulia` package does this for us. The name comes from how the `zip` function in base `Julia` takes two vectors and returns a vector of the values paired off. This is the reverse. As previously mentioned, `unzip` uses the `invert` function of the `SplitApplyCombine` package to invert the indexing (the $j$th component of the $i$th point can be referenced by `vs[i][j]` or `invert(vs)[j][i]`).
"""

# ╔═╡ 02b306ac-797b-11ec-3610-ef3ce745fd97
md"""Visually, we have `unzip` performing this reassociation:
"""

# ╔═╡ 02b306fa-797b-11ec-1f51-c9912b399f1e
md"""```
[[x1, y1, z1],         (⌈x1⌉,  ⌈y1⌉, ⌈z1⌉,
 [x2, y2, z2],          |x2|, |y2|, |z2|,
 [x3, y3, z3],   -->    |x3|, |y3|, |z3|,
     ⋮                         ⋮
 [xn, yn, zn]]          ⌊xn⌋,  ⌊yn⌋, ⌊zn⌋ )
```"""

# ╔═╡ 02b30710-797b-11ec-2f08-bfe9c54d1fe4
md"""To turn a collection of vectors into separate arguments for a function, splatting (the `...`) is used.
"""

# ╔═╡ 02b30738-797b-11ec-2283-eb1772920ceb
md"""---
"""

# ╔═╡ 02b30742-797b-11ec-3c29-df558a104d3e
md"""Finally, with these definitions, we can visualize the three functions we have defined.
"""

# ╔═╡ 02b30760-797b-11ec-1785-278a6c4187a2
md"""Here we show the plot of `f` over the values between $0$ and $2\pi$ and also add a vector anchored at the origin defined by `f(1)`.
"""

# ╔═╡ 02b313ae-797b-11ec-0a5f-350aa0f75eb7
let
	ts = range(0, 2pi, length=200)
	xs, ys = unzip(f.(ts))
	plot(xs, ys)
	arrow!([0, 0], f(1))
end

# ╔═╡ 02b31414-797b-11ec-1ff9-39fd62fd474c
md"""The trace of the plot is an ellipse. If we describe the components as $\vec{f}(t) = \langle x(t), y(t) \rangle$, then we have $x(t)^2 + y(t)^2/4 = 1$. That is, for any value of $t$, the resulting point satisfies the equation $x^2 + y^2/4 =1$ for an ellipse.
"""

# ╔═╡ 02b31430-797b-11ec-3365-dbaeef9fdbd2
md"""The plot of $g$ needs $3$-dimensions to render. For most plotting backends, the following should work with no differences, save the additional vector is anchored in 3 dimensions now:
"""

# ╔═╡ 02b31be2-797b-11ec-2b2c-319b585d5b53
let
	ts = range(0, 6pi, length=200)
	plot(unzip(g.(ts))...) # use splatting to avoid xs,ys,zs = unzip(g.(ts))
	arrow!([0, 0, 0], g(2pi))
end

# ╔═╡ 02b31c3c-797b-11ec-2027-3bb2b467c08a
md"""Here the graph is a helix; three turns are plotted. If we write $g(t) = \langle x(t), y(t), z(t) \rangle$, as the $x$ and $y$ values trace out a circle, the $z$ value increases. When the graph is viewed from above, as below, we see only $x$ and $y$ components, and the view is circular.
"""

# ╔═╡ 02b3252e-797b-11ec-166c-ad40925bb7ce
let
	ts = range(0, 6pi, length=200)
	plot(unzip(g.(ts))..., camera=(0, 90))
end

# ╔═╡ 02b3257e-797b-11ec-2b8e-0fa6bab2b51c
md"""The graph of $h$ shows that this function parameterizes a line in space. The line segment for $-2 \leq t \leq 2$ is shown below:
"""

# ╔═╡ 02b32e20-797b-11ec-19bb-499fc4023419
let
	ts = range(-2, 2, length=200)
	plot(unzip(h.(ts))...)
end

# ╔═╡ 02b60078-797b-11ec-0375-2599fb90ebbb
md"""### The `plot_parametric` function
"""

# ╔═╡ 02b6078a-797b-11ec-05ac-e3a13ad531d2
md"""While the `unzip` function is easy to understand as a function that reshapes data from one format into one that `plot` can use, it's usage is a bit cumbersome. The `CalculusWithJulia` package provides a function `plot_parametric` which hides the use of `unzip` and the splatting within a function definition.
"""

# ╔═╡ 02b607da-797b-11ec-0c31-2574b9dab2aa
md"""The function borrows a calling style for `Makie`. The interval to plot over is specified first using `a..b` notation (from `IntervalSets`),  then the function is specified. Additional keyword arguments are passed along to `plot`.
"""

# ╔═╡ 02b60dc8-797b-11ec-1023-37b59384c141
plot_parametric(-2..2, h)

# ╔═╡ 02b63a34-797b-11ec-2171-c7fd91f2d092
note("""
Defining plotting functions in `Julia` for `Plots` is facilitated by the `RecipesBase` package. There are two common choices: creating a new function for plotting, as is done with `plot_parametric` and `plot_polar`; or creating a new type so that `plot` can dispatch to an appropriate plotting method. The latter would also be a reasonable choice, but wasn't taken here. In any case, each can be avoided by creating the appropriate values for `xs` and `ys` (and possibly `zs`).
""")

# ╔═╡ 02bd3582-797b-11ec-3a27-d35f759814fd
md"""##### Example
"""

# ╔═╡ 02bd35e6-797b-11ec-3486-d78c542979d7
md"""Familiarity with equations for lines, circles, and ellipses is important, as these fundamental geometric shapes are often building blocks in the description of other more complicated things.
"""

# ╔═╡ 02bd3636-797b-11ec-3a34-c98169bb980f
md"""The point-slope equation of a line, $y = y_0 + m \cdot (x - x_0)$ finds an analog. The slope, $m$, is replaced with a vector $\vec{v}$ and the point, $(x_0, y_0)$ is replaced with a vector $\vec{p}$ identified with a point in the plane. A parameterization would then be $\vec{f}(t) = \vec{p} + (t - t_0) \vec{v}$. From this, we have $\vec{f}(t_0) = \vec{p}$.
"""

# ╔═╡ 02bd3686-797b-11ec-2f6e-0f4460229349
md"""The unit circle is instrumental in introducing the trigonometric functions though the identification of an angle $t$ with a point on the unit circle $(x,y)$ through $y = \sin(t)$ and $x=\cos(t)$. With this identification certain properties of the trigonometric functions are immediately seen, such as the period of $\sin$ and $\cos$ being $2\pi$, or the angles for which $\sin$ and $\cos$ are positive or even increasing. Further, this gives a natural parameterization for a vector-valued function whose plot yields the unit circle, namely $\vec{f}(t) = \langle \cos(t), \sin(t) \rangle$. This parameterization starts (at $t=0$) at the point $(1, 0)$. More generally, we might have additional parameters $\vec{f}(t) = \vec{p} + R \cdot \langle \cos(\omega(t-t_0)), \sin(\omega(t-t_0)) \rangle$ to change the origin, $\vec{p}$; the radius, $R$; the starting angle, $t_0$; and the rotational frequency, $\omega$.
"""

# ╔═╡ 02bd36b8-797b-11ec-2d1e-83ba4d68e937
md"""An ellipse has a slightly more general equation than a circle and in simplest forms may satisfy the equation $x^2/a^2 +  y^2/b^2 = 1$, where *when* $a=b$ a circle is being described. A vector-valued function of the form $\vec{f}(t) = \langle a\cdot\cos(t),  b\cdot\sin(t) \rangle$ will trace out an ellipse.
"""

# ╔═╡ 02be7c28-797b-11ec-33fa-31c1976770a0
md"""The above description of an ellipse is useful, but it can also be useful to re-express the ellipse so that one of the foci is at the origin. With this, the ellipse can be given in *polar* coordinates through a description of the radius:
"""

# ╔═╡ 02be7c88-797b-11ec-1d83-2b78257c5101
md"""```math
r(\theta) = \frac{a (1 - e^2)}{1 + e \cos(\theta)}.
```
"""

# ╔═╡ 02be7ce4-797b-11ec-31e1-a59b96a89c49
md"""Here, $a$ is the semi-major axis ($a > b$); $e$ is the *eccentricity* given by $b = a \sqrt{1 - e^2}$; and $\theta$ a polar angle.
"""

# ╔═╡ 02be7d0c-797b-11ec-16f3-b5cbf540e487
md"""Using the conversion to Cartesian equations, we have $\vec{f}(\theta) = \langle r(\theta) \cos(\theta), r(\theta) \sin(\theta)\rangle$.
"""

# ╔═╡ 02be7d20-797b-11ec-2af5-e92422f43ea3
md"""For example:
"""

# ╔═╡ 02be89fa-797b-11ec-0e7a-417ba951e2f3
let
	a, ecc = 20, 3/4
	f(t) = a*(1-ecc^2)/(1 + ecc*cos(t)) * [cos(t), sin(t)]
	plot_parametric(0..2pi, f, legend=false)
	scatter!([0],[0], markersize=4)
end

# ╔═╡ 02be8a5e-797b-11ec-1b77-cd617a083f2a
md"""##### Example
"""

# ╔═╡ 02c08610-797b-11ec-09cd-1fce9c38c6a2
md"""The [Spirograph](https://en.wikipedia.org/wiki/Spirograph) is "... a geometric drawing toy that produces mathematical roulette curves of the variety technically known as hypotrochoids and epitrochoids. It was developed by British engineer Denys Fisher and first sold in $1965$." These can be used to make interesting geometrical curves.
"""

# ╔═╡ 02c08688-797b-11ec-0f97-1554de2d1c63
md"""Following Wikipedia: Consider a fixed outer circle $C_o$ of radius $R$ centered at the origin. A smaller inner circle  $C_i$ of radius $r < R$ rolling inside $C_o$ and is continuously tangent to it. $C_i$ will be assumed never to slip on $C_o$ (in a real Spirograph, teeth on both circles prevent such slippage). Now assume that a point $A$ lying somewhere inside $C_{i}$ is located a distance $\rho < r$ from $C_i$'s center.
"""

# ╔═╡ 02c086b0-797b-11ec-3f60-69b1fabdcfcc
md"""The center of the inner circle will move in a circular manner with radius $R-r$. The fixed point on the inner circle will rotate about this center. The accumulated angle may be described by the angle the point of contact of the inner circle with the outer circle. Call this angle $t$.
"""

# ╔═╡ 02c086e2-797b-11ec-1e1e-619b2fdf0b0e
md"""Suppose the outer circle is centered at the origin and the inner circle starts ($t=0$) with center $(R-r, 0)$ and rotates around counterclockwise. Then if the point of contact makes angle $t$, the arc length along the outer circle is $Rt$. The inner circle will have moved a distance $r t'$ in the opposite direction, so $Rt =-r t'$ and solving the angle will be $t' = -(R/r)t$.
"""

# ╔═╡ 02c086f6-797b-11ec-213b-c9acd6032bd8
md"""If the initial position of the fixed point is at $(\rho, 0)$ relative to the origin, then the following function will describe the motion:
"""

# ╔═╡ 02c08714-797b-11ec-15a8-6b7e9c92d2c2
md"""```math
\vec{s}(t) = (R-r) \cdot \langle \cos(t), \sin(t) \rangle +
\rho \cdot \langle \cos(-\frac{R}{r}t), \sin(-\frac{R}{r}t) \rangle.
```
"""

# ╔═╡ 02c08728-797b-11ec-2c87-7135d69ed2ac
md"""To visualize this we first define a helper function to draw a circle at point $P$ with radius $R$:
"""

# ╔═╡ 02c0964e-797b-11ec-094f-f70e941accb2
circle!(P, R; kwargs...) = plot_parametric!(0..2pi, t -> P + R * [cos(t), sin(t)]; kwargs...)

# ╔═╡ 02c0968c-797b-11ec-348a-65db46ff0fca
md"""Then we have this function to visualize the spirograph for different $t$ values:
"""

# ╔═╡ 02c0b8c4-797b-11ec-28e0-f1605ca9ba36
function spiro(t; r=2, R=5, rho=0.8*r)

    cent(t) = (R-r) * [cos(t), sin(t)]

    p = plot(legend=false, aspect_ratio=:equal)
    circle!([0,0], R, color=:blue)
    circle!(cent(t), r, color=:black)

    tp(t) = -R/r * t

    s(t) = cent(t) + rho * [cos(tp(t)), sin(tp(t))]
    plot_parametric!(0..t, s, color=:red)

    p
end

# ╔═╡ 02c0b8f6-797b-11ec-2059-53d0bd807e10
md"""And we can see the trace for $t=\pi$:
"""

# ╔═╡ 02c0ba68-797b-11ec-256a-3b6cf6e17652
spiro(pi)

# ╔═╡ 02c0ba90-797b-11ec-1076-33597535aaf2
md"""The point of contact is at $(-R, 0)$, as expected. Carrying this forward to a full circle's worth is done through:
"""

# ╔═╡ 02c0bcde-797b-11ec-285d-fd1c27ef5400
spiro(2pi)

# ╔═╡ 02c0bcfc-797b-11ec-16aa-3fe68bb8d216
md"""The curve does not match up at the start. For that, a second time around the outer circle is needed:
"""

# ╔═╡ 02c0bf18-797b-11ec-21b0-d789d3957ff9
spiro(4pi)

# ╔═╡ 02c0bf36-797b-11ec-3992-655ac057d063
md"""Whether the curve will have a period or not is decided by the ratio of $R/r$ being rational or irrational.
"""

# ╔═╡ 02c0bf56-797b-11ec-3b35-29a9ee9935fe
md"""##### Example
"""

# ╔═╡ 02c1f734-797b-11ec-2a8b-a7ba1d01f332
md"""[Ivars Peterson](http://www.phschool.com/science/science_news/articles/tilt_a_whirl.html) described the carnival ride "tilt-a-whirl" as a chaotic system, whose equations of motion are presented in [American Journal of Physics](https://doi.org/10.1119/1.17742) by Kautz and Huggard. The tilt-a-whirl has a platform that moves in a circle that also moves up and down. To describe the  motion of a point on the platform assuming it has radius $R$ and period $T$ and rises twice in that period could be done with the function:
"""

# ╔═╡ 02c1f77a-797b-11ec-0e0a-d1fdfc69f4c4
md"""```math
\vec{u}(t) = \langle R \sin(2\pi t/T), R \cos(2\pi t/T), h + h \cdot \sin(2\pi t/ T) \rangle.
```
"""

# ╔═╡ 02c1f7b6-797b-11ec-1691-610c250fc0e1
md"""A passenger sits on a circular platform with radius $r$ attached at some point on the larger platform. The dynamics of the person on the tilt-a-whirl depend on physics, but for simplicity, let's assume the platform moves at a constant rate with period $S$ and has no relative $z$ component. The motion of the platform in relation to the point it is attached would be modeled by:
"""

# ╔═╡ 02c1f7ca-797b-11ec-2fb0-e977968c7a40
md"""```math
\vec{v}(t) = \langle r \sin(2\pi t/S), r \sin(2\pi t/S), 0 \rangle.
```
"""

# ╔═╡ 02c1f7d4-797b-11ec-3cd3-f7cd6be75437
md"""And the motion relative to the origin would be the vector sum, or superposition:
"""

# ╔═╡ 02c1f7de-797b-11ec-32e6-c54033ae0ce3
md"""```math
\vec{f}(t) = \vec{u}(t) + \vec{v}(t).
```
"""

# ╔═╡ 02c1f7f4-797b-11ec-3e43-f1b14f6675cf
md"""To visualize for some parameters, we have:
"""

# ╔═╡ 02c1ff72-797b-11ec-3d38-2dce1f80bf89
let
	M, m = 25, 5
	height = 5
	S, T = 8, 2
	outer(t) = [M * sin(2pi*t/T), M * cos(2pi*t/T), height*(1 +sin(2pi * (t-pi/2)/T))]
	inner(t) = [m * sin(2pi*t/S), m * cos(2pi*t/S), 0]
	f(t) = outer(t) + inner(t)
	plot_parametric(0..8, f)
end

# ╔═╡ 02c1ffb8-797b-11ec-24c8-61e1795224d7
md"""## Limits and continuity
"""

# ╔═╡ 02c20008-797b-11ec-360f-0dd8b1ba9c9e
md"""The definition of a limit for a univariate function is: For every $\epsilon > 0$ there exists a $\delta > 0$ such that *if* $0 < |x-c| < \delta$ *then* $|f(x) - L | < \epsilon$.
"""

# ╔═╡ 02c2001c-797b-11ec-0718-7348ef949fd6
md"""If  the notion of "$\vec{f}$ is close to $L$" is replaced by close in the sense of a norm, or vector distance, then the same limit definition can be used, with the new wording "... $\| \vec{f}(x) - L \| < \epsilon$".
"""

# ╔═╡ 02c20044-797b-11ec-189c-6554612110dd
md"""The notion of continuity is identical: $\vec{f}(t)$ is continuous at $t_0$ if $\lim_{t \rightarrow t_0}\vec{f}(t) = \vec{f}(t_0)$. More informally $\| \vec{f}(t) - \vec{f}(t_0)\| \rightarrow 0$.
"""

# ╔═╡ 02c2004e-797b-11ec-1915-43137b918982
md"""A consequence of the triangle inequality is that a vector-valued function is continuous or has a limit if and only it its component functions do.
"""

# ╔═╡ 02c2006c-797b-11ec-2a1d-330c283c07e2
md"""### Derivatives
"""

# ╔═╡ 02c2008a-797b-11ec-3f3a-d159d404cfeb
md"""If $\vec{f}(t)$ is  vector valued,  and $\Delta t > 0$ then we can consider the vector:
"""

# ╔═╡ 02c2009e-797b-11ec-30fc-95bdf67d9783
md"""```math
\vec{f}(t + \Delta t) - \vec{f}(t)
```
"""

# ╔═╡ 02c200bc-797b-11ec-0136-3b93545d40fd
md"""For example, if $\vec{f}(t) = \langle 3\cos(t), 2\sin(t) \rangle$ and $t=\pi/4$ and $\Delta t = \pi/16$ we have this picture:
"""

# ╔═╡ 02c20800-797b-11ec-13a1-fb2eefc829cb
let
	f(t) = [3cos(t), 2sin(t)]
	t, Δt = pi/4, pi/16
	df = f(t + Δt) - f(t)
	
	plot(legend=false)
	arrow!([0,0], f(t))
	arrow!([0,0], f(t + Δt))
	arrow!(f(t), df)
end

# ╔═╡ 02c20832-797b-11ec-045a-979c079d83f8
md"""The length of the difference appears to be related to the length of $\Delta t$, in a similar manner as the univariate derivative. The following limit defines the *derivative* of a vector-valued function:
"""

# ╔═╡ 02c20846-797b-11ec-2b2a-27173c7324f5
md"""```math
\vec{f}'(t) = \lim_{\Delta t \rightarrow 0} \frac{f(t + \Delta t) - f(t)}{\Delta t}.
```
"""

# ╔═╡ 02c20864-797b-11ec-21b1-a1b1b4c005ba
md"""The limit exists if the component limits do. The component limits are just the derivatives of the component functions. So, if $\vec{f}(t) = \langle x(t), y(t) \rangle$, then $\vec{f}'(t) = \langle x'(t), y'(t) \rangle$.
"""

# ╔═╡ 02c20896-797b-11ec-2004-9b8691f0064b
md"""If the derivative is never $\vec{0}$, the curve is called *regular*. For a regular curve the derivative is a tangent vector to the parameterized curve, akin to the case for a univariate function. We can use `ForwardDiff` to compute the derivative in the exact same manner as was done for univariate functions:
"""

# ╔═╡ 02c208be-797b-11ec-1743-11e1b8e0d750
md"""```
using ForwardDiff
D(f,n=1) = n > 1 ? D(D(f),n-1) : x -> ForwardDiff.derivative(f, float(x))
Base.adjoint(f::Function) = D(f)         # allow f' to compute derivative
```"""

# ╔═╡ 02c208dc-797b-11ec-36e8-f94241140458
md"""(This is already done by the `CalculusWithJulia` package.)
"""

# ╔═╡ 02c208e6-797b-11ec-332b-37bf828a033f
md"""We can visualize the tangential property through a graph:
"""

# ╔═╡ 02c20f6c-797b-11ec-0b6b-197c3f5a04aa
let
	f(t) = [3cos(t), 2sin(t)]
	p = plot_parametric(0..2pi, f, legend=false, aspect_ratio=:equal)
	for t in [1,2,3]
	    arrow!(f(t), f'(t))   # add arrow with tail on curve, in direction of derivative
	end
	p
end

# ╔═╡ 02c20f94-797b-11ec-3cb9-59e539f9383f
md"""### Symbolic representation
"""

# ╔═╡ 02c20fb2-797b-11ec-0627-7d09827c9685
md"""Were symbolic expressions used in place of functions, the vector-valued function would naturally be represented as a vector of expressions:
"""

# ╔═╡ 02c2139a-797b-11ec-1803-b1c6f35e1c86
begin
	@syms 𝒕
	𝒗vf = [cos(𝒕), sin(𝒕), 𝒕]
end

# ╔═╡ 02c213ac-797b-11ec-0e22-0dc20f0f5e76
md"""We will see working with these expressions is not identical to working with a vector-valued function.
"""

# ╔═╡ 02c213cc-797b-11ec-2415-dfc2df60c2c2
md"""To plot, we can avail ourselves of the the parametric plot syntax. The following expands to `plot(cos(t), sin(t), t, 0, 2pi)`:
"""

# ╔═╡ 02c217be-797b-11ec-2ec3-f1c1fc59cd0b
plot(𝒗vf..., 0, 2pi)

# ╔═╡ 02c217e4-797b-11ec-3a6c-5d08cb14db25
md"""The `unzip` usage, as was done above, could be used, but it would be  more trouble in this case.
"""

# ╔═╡ 02c21804-797b-11ec-375e-35a8c96aa6fb
md"""To evaluate the function at a given value, say $t=2$, we can use `subs` with broadcasting to substitute into each component:
"""

# ╔═╡ 02c21b42-797b-11ec-3c4e-0f14e99a5ebf
subs.(𝒗vf, 𝒕=>2)

# ╔═╡ 02c21b58-797b-11ec-39aa-4d01b61263f3
md"""Limits are performed component by component, and can also be defined by broadcasting, again with the need to adjust the values:
"""

# ╔═╡ 02c21f02-797b-11ec-263c-8f01119760dc
begin
	@syms Δ
	limit.((subs.(𝒗vf, 𝒕 => 𝒕 + Δ) - 𝒗vf) / Δ, Δ => 0)
end

# ╔═╡ 02c21f16-797b-11ec-1b7c-c50431238d78
md"""Derivatives, as was just done through a limit, are a bit more straightforward than evaluation or limit taking, as we won't bump into the shape mismatch when broadcasting:
"""

# ╔═╡ 02c22074-797b-11ec-2174-27edac65d562
diff.(𝒗vf, 𝒕)

# ╔═╡ 02c22088-797b-11ec-31d0-19a382131c2c
md"""The second derivative, can be found through:
"""

# ╔═╡ 02c221fa-797b-11ec-0571-cbb8ca69572c
diff.(𝒗vf, 𝒕, 𝒕)

# ╔═╡ 02c2220e-797b-11ec-3e35-5dbc0c194c65
md"""### Applications of the derivative
"""

# ╔═╡ 02c22218-797b-11ec-0511-a153eba47ac8
md"""Here are some sample applications of the derivative.
"""

# ╔═╡ 02c22240-797b-11ec-2a03-b1bef30c2848
md"""##### Example: equation of the tangent line
"""

# ╔═╡ 02c22254-797b-11ec-359f-6194ccf80277
md"""The derivative of a vector-valued function is similar to that of a univariate function, in that it indicates a direction tangent to a curve. The point-slope form offers a straightforward parameterization. We have a point given through the vector-valued function and a direction given by its derivative. (After identifying a vector with its tail at the origin with the point that is the head of the vector.)
"""

# ╔═╡ 02c22272-797b-11ec-028a-dbd6f803d8a6
md"""With this, the equation is simply $\vec{tl}(t) = \vec{f}(t_0) + \vec{f}'(t_0) \cdot (t - t_0)$, where the dot indicates scalar multiplication.
"""

# ╔═╡ 02c22286-797b-11ec-1859-478ac74b4fd6
md"""##### Example: parabolic motion
"""

# ╔═╡ 02c247de-797b-11ec-1551-09f4115f2101
md"""In physics, we learn that the equation $F=ma$ can be used to derive a formula for postion, when acceleration, $a$, is a constant. The resulting equation of motion is $x = x_0 + v_0t + (1/2) at^2$. Similarly, if $x(t)$ is a vector-valued postion vector, and the *second* derivative, $x''(t) =\vec{a}$, a constant, then we have: $x(t) = \vec{x_0} + \vec{v_0}t + (1/2) \vec{a} t^2$.
"""

# ╔═╡ 02c24856-797b-11ec-3ed1-61f119e082f6
md"""For two dimensions, we have the force due to gravity acts downward, only in the $y$ direction. The acceleration is then $\vec{a} = \langle 0, -g \rangle$. If we start at the origin, with initial velocity $\vec{v_0} = \langle 2, 3\rangle$, then we can plot the trajectory until the object returns to ground ($y=0$) as follows:
"""

# ╔═╡ 02c24d88-797b-11ec-2c20-3148f926f7f6
let
	gravity = 9.8
	x0, v0, a = [0,0], [2, 3], [0, -gravity]
	xpos(t) = x0 + v0*t + (1/2)*a*t^2
	
	t_0 = find_zero(t -> xpos(t)[2], (1/10, 100))  # find when y=0
	
	plot_parametric(0..t_0, xpos)
end

# ╔═╡ 02c24db0-797b-11ec-02dc-eb7df2246cc0
md"""##### Example: a tractrix
"""

# ╔═╡ 02c253b4-797b-11ec-0902-7f3bee359884
# https://en.wikipedia.org/wiki/Tractrix
# https://sinews.siam.org/Details-Page/a-bike-and-a-catenary
# https://www.math.psu.edu/tabachni/talks/BicycleDouble.pdf
# https://www.tandfonline.com/doi/abs/10.4169/amer.math.monthly.120.03.199
# https://projecteuclid.org/download/pdf_1/euclid.em/1259158427
nothing

# ╔═╡ 02c25422-797b-11ec-1282-75aff34335e5
md"""A [tractrix](https://en.wikipedia.org/wiki/Tractrix), studied by Perrault, Newton, Huygens, and many others, is the curve along which an object moves when pulled in a horizontal plane by a line segment attached to a pulling point (Wikipedia). If the object is placed at $(a,0)$ and the puller at the origin, and the puller moves along the positive $x$ axis, then the line will always be tangent to the curve and of fixed length, so determinable from the motion of the puller. In this example $dy/dx = -\sqrt{a^2-x^2}/x$.
"""

# ╔═╡ 02c25440-797b-11ec-14da-dd455130973e
md"""This is the key property: "Due to the geometrical way it was defined, the tractrix has the property that the segment of its tangent, between the asymptote and the point of tangency, has constant length $a$."
"""

# ╔═╡ 02c254ae-797b-11ec-0b85-731d50a53ba9
md"""The tracks made by the front and rear bicycle wheels also have this same property and similarly afford a mathematical description. We follow [Dunbar, Bosman, and Nooij](https://doi.org/10.2307/2691097) from *The Track of a Bicycle Back Tire* below, though [Levi and Tabachnikov](https://projecteuclid.org/download/pdf_1/euclid.em/1259158427) and [Foote, Levi, and Tabachnikov](https://www.tandfonline.com/doi/abs/10.4169/amer.math.monthly.120.03.199) were also consulted.  Let $a$ be the distance between the front and back wheels, whose positions are parameterized by $\vec{F}(t)$ and $\vec{B}(t)$, respectively. The key property is the distance between the two is always $a$, and, as the back wheel is always moving in the direction of the front wheel, we have $\vec{B}'(t)$ is in the direction of $\vec{F}(t) - \vec{B}(t)$, that is the vector $(\vec{F}(t)-\vec{B}(t))/a$ is a unit vector in the direction of the derivative of $\vec{B}$. How long is the derivative vector? That would be answered by the speed of the back wheel, which is related to the velocity of the front wheel. But only the component of the velocity in the direction of $\vec{F}(t)-\vec{B}(t)$, so the speed of the back wheel is the length of the projection of $\vec{F}'(t)$ onto the unit vector $(\vec{F}(t)-\vec{B}(t))/a$, which is identified through the dot product.
"""

# ╔═╡ 02c254c2-797b-11ec-0a54-05868edea082
md"""Combined, this gives the following equations relating $\vec{F}(t)$ to $\vec{B}(t)$:
"""

# ╔═╡ 02c254e0-797b-11ec-248b-d1b57ea96ecb
md"""```math
s_B(t) = \vec{F}'(t) \cdot \frac{\vec{F}(t)-\vec{B}(t)}{a}, \quad
\vec{B}'(t) = s_B(t) \frac{\vec{F}(t)-\vec{B}(t)}{a}.
```
"""

# ╔═╡ 02c254f4-797b-11ec-36ce-a794850ea4a9
md"""This is a *differential* equation describing the motion of the back wheel in terms of the front wheel.
"""

# ╔═╡ 02c2551c-797b-11ec-0089-75ba69f23bc5
md"""If the back wheel trajectory is known, the relationship is much easier, as the two differ by a vector of length $a$ in the direction of $\vec{B}'(t)$, or:
"""

# ╔═╡ 02c25530-797b-11ec-08c4-bfe10179cb12
md"""```math
F(t) = \vec{B}(t) + a \frac{\vec{B'(t)}}{\|\vec{B}'(t)\|}.
```
"""

# ╔═╡ 02c2554e-797b-11ec-24d7-5fe0e1aa6043
md"""We don't discuss when a differential equation has a solution, or if it is unique when it does, but note that the differential equation above may be solved numerically, in a manner somewhat similar to what was discussed in [ODEs](../ODEs/odes.html). Though here we will use the `DifferentialEquations` package for finding the numeric solution.
"""

# ╔═╡ 02c25576-797b-11ec-3056-8bf07f6cb7b8
md"""We can define our equation as follows, using `p` to pass in the two parameters: the wheel-base length $a$, and $F(t)$, the parameterization of the front wheel in time:
"""

# ╔═╡ 02c26804-797b-11ec-0ec2-dd0925d91ae9
function bicycle(dB, B, p, t)

  a, F = p   # unpack parameters

  speed =  F'(t) ⋅ (F(t) - B) / a
  dB[1], dB[2] = speed * (F(t) - B) / a

end

# ╔═╡ 02d1d1cc-797b-11ec-25c8-6153a82570f9
let
	a = 1
	F(t) = [cos(pi/2 - t), 2sin(pi/2-t)]
	p = (a, F)
	
	t0, t1 = -pi/6, pi/2.75
	tspan = (t0, t1)
	
	t = 7pi/6
	B0 = F(t0) + a*[cos(t), sin(t)]
	prob = ODEProblem(bicycle, B0, tspan, p)
	
	out = solve(prob, reltol=1e-6, Tsit5())
	plt = plot_parametric(t0..t1, F, linewidth=3,
	                      xticks=nothing, yticks=nothing, border=:none,
	                      legend=false, aspect_ratio=:equal)
	plot_parametric!(t0..t1, t -> out(t),  linewidth=3)
	
	t = pi/4
	arrow!(out(t), 2*(F(t) - out(t)))
	plot!(unzip([out(t), F(t)])..., linewidth=2)
	arrow!(F(t), F'(t)/norm(F'(t)))
	Fphat(t) = F'(t)/norm(F'(t))
	arrow!( F(t), -Fphat'(t)/norm(Fphat'(t)))
	using LaTeXStrings
	annotate!([(-.5,1.5,L"k"),
	(.775,1.55,L"\kappa"),
	(.85, 1.3, L"\alpha")])
	
	plt
end

# ╔═╡ 02c26890-797b-11ec-242a-91f8c23a403d
md"""Let's consider a few simple cases first. We suppose $a=1$ and the front wheel moves in a circle of radius $3$. Here is how we can plot two loops:
"""

# ╔═╡ 02c2711e-797b-11ec-1d9d-85ce068af919
begin
	t₀, t₁ = 0.0, 4pi
	
	tspan₁ = (t₀, t₁)  # time span to consider
	
	a₁ = 1
	F₁(t) = 3 * [cos(t), sin(t)]
	p₁ = (a₁, F₁)      # combine parameters
	
	B₁0 = F₁(0) - [0, a₁]  # some initial position for the back
	prob₁ = ODEProblem(bicycle, B₁0, tspan₁, p₁)
	
	out₁ = solve(prob₁, reltol=1e-6, Tsit5())
end

# ╔═╡ 02c2716e-797b-11ec-1bf2-574942c1ff08
md"""The object `out` holds the answer. This object is callable, in that `out(t)` will return the numerically computed value for the answer to our equation at time point `t`.
"""

# ╔═╡ 02c27198-797b-11ec-1e93-1bb8ded36006
md"""To plot the two trajectories, we could use that `out.u` holds the $x$ and $y$ components of the computed trajectory, but more simply, we  call `out` like a function.
"""

# ╔═╡ 02c277b8-797b-11ec-2d2f-b30431fa2a9c
begin
	plt₁ = plot_parametric(t₀..t₁, F₁, legend=false)
	plot_parametric!(t₀..t₁, out₁,   linewidth=3)
	
	## add the bicycle as a line segment at a few times along the path
	for t in range(t₀, t₁, length=11)
	    plot!(unzip([out₁(t), F₁(t)])..., linewidth=3, color=:black)
	end
	plt₁
end

# ╔═╡ 02c277d6-797b-11ec-209e-0137a7e84235
md"""That the rear wheel track appears shorter, despite the rear wheel starting outside the circle, is typical of bicycle tracks and also a reason to rotate tires on car, as the front ones move a bit more than the rear, so presumably wear faster.
"""

# ╔═╡ 02c277fc-797b-11ec-0856-c5bfc11a9fc9
md"""Let's look what happens if the front wheel wobbles back and forth following a sine curve. Repeating the above, only with $F$ redefined, we have:
"""

# ╔═╡ 02c27baa-797b-11ec-0974-5f9e600289f3
begin
	a₂ = 1
	F₂(t) = [t, 2sin(t)]
	p₂ = (a₂, F₂)
	
	B₂0 = F₂(0) - [0, a₂]  # some initial position for the back
	prob₂ = ODEProblem(bicycle, B₂0, tspan₁, p₂)
	
	out₂ = solve(prob₂, reltol=1e-6, Tsit5())
	
	plot_parametric(t₀..t₁, F₂, legend=false)
	plot_parametric!(t₀..t₁, t -> out₂(t),  linewidth=3)
end

# ╔═╡ 02c27bbe-797b-11ec-1c2c-132fe2ca2058
md"""Again, the back wheel moves less than the front.
"""

# ╔═╡ 02c27bc8-797b-11ec-2923-bdcdeba42464
md"""The motion of the back wheel need not be smooth, even if the motion of the front wheel is, as this curve illustrates:
"""

# ╔═╡ 02c27f7e-797b-11ec-3f36-f9fa31e33a08
begin
	a₃ = 1
	F₃(t) = [cos(t), sin(t)] + [cos(2t), sin(2t)]
	p₃ = (a₃, F₃)
	
	B₃0 = F₃(0) - [0,a₃]
	prob₃ = ODEProblem(bicycle, B₃0, tspan₁, p₃)
	
	out₃ = solve(prob₃, reltol=1e-6, Tsit5())
	plot_parametric(t₀..t₁, F₃, legend=false)
	plot_parametric!(t₀..t₁, t -> out₃(t), linewidth=3)
end

# ╔═╡ 02c27f92-797b-11ec-0253-69449a602b71
md"""The back wheel is moving backwards for part of the above trajectory.
"""

# ╔═╡ 02c27fa8-797b-11ec-0d32-935fb46fec80
md"""This effect can happen even for a front wheel motion as simple as a circle when the front wheel radius is less than the wheelbase:
"""

# ╔═╡ 02c2832a-797b-11ec-29ad-eb175e8e795c
begin
	a₄ = 1
	F₄(t) = a₄/3 * [cos(t), sin(t)]
	p₄ = (a₄, F₄)
	
	t₀₄, t₁₄ = 0.0, 25pi
	tspan₄ = (t₀₄, t₁₄)
	
	B₄0 = F₄(0) - [0, a₄]
	prob₄ = ODEProblem(bicycle, B₄0, tspan₄, p₄)
	
	out₄ = solve(prob₄, reltol=1e-6, Tsit5())
	plot_parametric(t₀₄..t₁₄, F₄, legend=false, aspect_ratio=:equal)
	plot_parametric!(t₀₄..t₁₄, t -> out₄(t), linewidth=3)
end

# ╔═╡ 02c2833e-797b-11ec-1191-038df388370e
md"""Later we will characterize when there are cusps in the rear-wheel trajectory.
"""

# ╔═╡ 02c28370-797b-11ec-3293-bf5c0a727f16
md"""## Derivative rules.
"""

# ╔═╡ 02c28398-797b-11ec-2f0d-79b94ac9d0cc
md"""From the definition, as it is for univariate functions, for vector-valued functions $\vec{f}, \vec{g}: R \rightarrow R^n$:
"""

# ╔═╡ 02c283b6-797b-11ec-312e-0b43bbb523eb
md"""```math
[\vec{f} + \vec{g}]'(t) = \vec{f}'(t) + \vec{g}'(t), \quad\text{and }
[a\vec{f}]'(t) = a \vec{f}'(t).
```
"""

# ╔═╡ 02c283d4-797b-11ec-3707-992b32610ef6
md"""If $a(t)$ is a univariate (scalar) function of $t$, then a product rule holds:
"""

# ╔═╡ 02c283e8-797b-11ec-3101-c513d2e688ad
md"""```math
[a(t) \vec{f}(t)]' = a'(t)\vec{f}(t) + a(t)\vec{f}'(t).
```
"""

# ╔═╡ 02c283fc-797b-11ec-081a-45324a4dc590
md"""If $s$ is a univariate function, then the composition $\vec{f}(s(t))$ can be differentiated. Each component would satisfy the chain rule, and consequently:
"""

# ╔═╡ 02c28406-797b-11ec-2029-f9790604e252
md"""```math
\frac{d}{dt}\left(\vec{f}(s(t))\right) = \vec{f}'(s(t)) \cdot s'(t),
```
"""

# ╔═╡ 02c2841a-797b-11ec-2c5d-ebe93eb08b18
md"""The dot being scalar multiplication by the derivative of the univariate function $s$.
"""

# ╔═╡ 02c28424-797b-11ec-2b93-638764c6f003
md"""Vector-valued functions do not have multiplication or division defined for them, so there are no ready analogues of the product and quotient rule. However, the dot product and the cross product produce new functions that may have derivative rules available.
"""

# ╔═╡ 02c28440-797b-11ec-3ab8-f79218610e5a
md"""For the dot product, the combination $\vec{f}(t) \cdot \vec{g}(t)$ we have a univariate function of $t$, so we know a derivative is well defined. Can it be represented in terms of the vector-valued functions? In terms of the component functions, we have this calculation specific to $n=2$, but that which can be generalized:
"""

# ╔═╡ 02c28456-797b-11ec-3fee-2b010c319dee
md"""```math
\begin{align*}
\frac{d}{dt}(\vec{f}(t) \cdot \vec{g}(t)) &=
\frac{d}{dt}(f_1(t) g_1(t) + f_2(t) g_2(t))\\
&= f_1'(t) g_1(t) + f_1(t) g_1'(t) + f_2'(t) g_2(t) + f_2(t) g_2'(t)\\
&= f_1'(t) g_1(t) + f_2'(t) g_2(t) + f_1(t) g_1'(t)  + f_2(t) g_2'(t)\\
&= \vec{f}'(t)\cdot \vec{g}(t) + \vec{f}(t) \cdot \vec{g}'(t).
\end{align*}
```
"""

# ╔═╡ 02c28460-797b-11ec-1eee-c5bc6f368c4c
md"""Suggesting the that a product rule like formula applies for dot products.
"""

# ╔═╡ 02c28472-797b-11ec-1aa7-07d9c4533de8
md"""For the cross product, we let `SymPy` derive a formula for us.
"""

# ╔═╡ 02c28dc0-797b-11ec-1727-9f048acef0d5
begin
	@syms tₛ us()[1:3] vs()[1:3]
	uₛ = tₛ .|> us  # evaluate each of us at t
	vₛ = tₛ .|> vs
end

# ╔═╡ 02c28dde-797b-11ec-0fda-eb2c57e42f09
md"""Then the cross product has a derivative:
"""

# ╔═╡ 02c2913a-797b-11ec-2ee2-41d1a83e2437
diff.(uₛ × vₛ, tₛ)

# ╔═╡ 02c29162-797b-11ec-17ba-557f145be1d8
md"""Admittedly, that isn't very clear. With a peek at the answer, we show that the derivative is the same as the product rule would suggest ($\vec{u}' \times \vec{v} + \vec{u} \times \vec{v}'$):
"""

# ╔═╡ 02c2966c-797b-11ec-1395-f126d782989c
diff.(uₛ × vₛ, tₛ) - (diff.(uₛ, tₛ) × vₛ + uₛ × diff.(vₛ, tₛ))

# ╔═╡ 02c29694-797b-11ec-23eb-8d341a541902
md"""In summary, these two derivative formulas hold for vector-valued functions $R \rightarrow R^n$:
"""

# ╔═╡ 02c296a8-797b-11ec-29e9-9947fe0ec77a
md"""```math
\begin{align}
(\vec{u} \cdot \vec{v})' &= \vec{u}' \cdot \vec{v} + \vec{u} \cdot \vec{v}',\\
(\vec{u} \times \vec{v})' &= \vec{u}' \times \vec{v} + \vec{u} \times \vec{v}'.
\end{align}
```
"""

# ╔═╡ 02c296c8-797b-11ec-0055-c93d9716e218
md"""##### Application. Circular motion and the tangent vector.
"""

# ╔═╡ 02c296e4-797b-11ec-23ce-e1ae54dfc145
md"""The parameterization $\vec{r}(t) = \langle \cos(t), \sin(t) \rangle$ describes a circle. Characteristic of this motion is a constant radius, or in terms of a norm: $\| \vec{r}(t) \| = c$. The norm squared, can be expressed in terms of the dot product:
"""

# ╔═╡ 02c296fa-797b-11ec-390a-f38e5d665cc0
md"""```math
\| \vec{r}(t) \|^2 = \vec{r}(t) \cdot \vec{r}(t).
```
"""

# ╔═╡ 02c2970c-797b-11ec-2bc7-39787ed9378c
md"""Differentiating this for the case of a constant radius yields the equation $0 = [\vec{r}\cdot\vec{r}]'(t)$, which simplifies through the product rule and commutativity of the dot product to $0 = 2 \vec{r}(t) \cdot \vec{r}'(t)$. That is, the two vectors are orthogonal to each other. This observation proves to be very useful, as will be seen.
"""

# ╔═╡ 02c29720-797b-11ec-0867-6b54e22c56bf
md"""##### Example: Kepler's laws
"""

# ╔═╡ 02c2973e-797b-11ec-1da5-03fd2383dd04
md"""[Kepler](https://tinyurl.com/y38wragh)'s laws of planetary motion are summarized by:
"""

# ╔═╡ 02cc5684-797b-11ec-217e-77fd26e8a4d6
md"""  * The orbit of a planet is an ellipse with the Sun at one of the two foci.
  * A line segment joining a planet and the Sun sweeps out equal areas during equal intervals of time.
  * The square of the orbital period of a planet is directly proportional to the cube of the semi-major axis of its orbit.
"""

# ╔═╡ 02cc56f2-797b-11ec-019f-4bbc5bd40556
md"""Kepler was a careful astronomer, and derived these laws empirically. We show next how to derive these laws using vector calculus assuming some facts on Newtonian motion, as postulated by Newton. This approach is borrowed from [Joyce](https://mathcs.clarku.edu/~djoyce/ma131/kepler.pdf).
"""

# ╔═╡ 02cc572e-797b-11ec-38d5-b38b0103ac6b
md"""We adopt a sun-centered view of the universe, placing the sun at the origin and letting $\vec{x}(t)$ be the position of a planet relative to this origin. We can express this in terms of a magnitude and direction through $r(t) \hat{x}(t)$.
"""

# ╔═╡ 02cc5738-797b-11ec-3f04-6b03f22f1c5a
md"""Newton's law of gravitational force between the sun and this planet is then expressed by:
"""

# ╔═╡ 02cc5756-797b-11ec-149a-b3a41e356846
md"""```math
\vec{F} = -\frac{G M m}{r^2} \hat{x}(t).
```
"""

# ╔═╡ 02cc576a-797b-11ec-00c9-95c000356699
md"""Newton's famous law relating force and acceleration is
"""

# ╔═╡ 02cc5772-797b-11ec-2f94-ad6a5a74fc0d
md"""```math
\vec{F} = m \vec{a} = m \ddot{\vec{x}}.
```
"""

# ╔═╡ 02cc5788-797b-11ec-0ea4-db6b824d5e97
md"""Combining, Newton states $\vec{a} = -(GM/r^2) \hat{x}$.
"""

# ╔═╡ 02cc579c-797b-11ec-2536-49ea1584a43d
md"""Now to show the first law. Consider $\vec{x} \times \vec{v}$. It is constant, as:
"""

# ╔═╡ 02cc57b0-797b-11ec-29e6-d949cd9a3c9c
md"""```math
\begin{align}
(\vec{x} \times \vec{v})' &= \vec{x}' \times \vec{v} + \vec{x} \times \vec{v}'\\
&= \vec{v} \times \vec{v} + \vec{x} \times \vec{a}.
\end{align}
```
"""

# ╔═╡ 02cc57ce-797b-11ec-2cb4-3b6177413636
md"""Both terms are $\vec{0}$, as $\vec{a}$ is parallel to $\vec{x}$ by the above, and clearly $\vec{v}$ is parallel to itself.
"""

# ╔═╡ 02cc57ec-797b-11ec-235f-e7ea88aeefd6
md"""This says, $\vec{x} \times \vec{v} = \vec{c}$ is a constant vector, meaning, the motion of $\vec{x}$ must lie in a plane, as $\vec{x}$ is always orthogonal to the fixed vector $\vec{c}$.
"""

# ╔═╡ 02cc57f6-797b-11ec-066a-37520d22b040
md"""Now, by differentiating $\vec{x} = r \hat{x}$ we have:
"""

# ╔═╡ 02cc580a-797b-11ec-31aa-7b4a016e99b5
md"""```math
\begin{align}
\vec{v} &= \vec{x}'\\
&= (r\hat{x})'\\
&= r' \hat{x} + r \hat{x}',
\end{align}
```
"""

# ╔═╡ 02cc5814-797b-11ec-21a9-d3709d1f917a
md"""and so
"""

# ╔═╡ 02cc5828-797b-11ec-2c2a-9bf8a234e059
md"""```math
\begin{align}
\vec{c} &= \vec{x} \times \vec{v}\\
&= (r\hat{x}) \times (r'\hat{x} + r \hat{x}')\\
&= r^2 (\hat{x} \times \hat{x}').
\end{align}
```
"""

# ╔═╡ 02cc5832-797b-11ec-1366-2d1df0c52d66
md"""From this, we can compute $\vec{a} \times \vec{c}$:
"""

# ╔═╡ 02cc5848-797b-11ec-0272-bbebe9932506
md"""```math
\begin{align}
\vec{a} \times \vec{c} &= (-\frac{GM}{r^2})\hat{x} \times r^2(\hat{x} \times \hat{x}')\\
&= -GM \hat{x} \times (\hat{x} \times \hat{x}') \\
&= GM (\hat{x} \times \hat{x}')\times \hat{x}.
\end{align}
```
"""

# ╔═╡ 02cc5850-797b-11ec-0211-4dcaf08501d6
md"""The last line by anti-commutativity.
"""

# ╔═╡ 02cc5864-797b-11ec-3cca-e31dc481673e
md"""But, the triple cross product can be simplified through the identify $(\vec{u}\times\vec{v})\times\vec{w} = (\vec{u}\cdot\vec{w})\vec{v} - (\vec{v}\cdot\vec{w})\vec{u}$. So, the above becomes:
"""

# ╔═╡ 02cc586e-797b-11ec-0dbf-0982005186e8
md"""```math
\begin{align}
\vec{a} \times \vec{c} &=  GM ((\hat{x}\cdot\hat{x})\hat{x}' - (\hat{x} \cdot \hat{x}')\hat{x})\\
&= GM (1 \hat{x}' - 0 \hat{x}).
\end{align}
```
"""

# ╔═╡ 02cc5882-797b-11ec-1311-67e6218d8781
md"""Now, since $\vec{c}$ is constant, we have:
"""

# ╔═╡ 02cc588c-797b-11ec-20f5-2f165fcaf0f4
md"""```math
\begin{align}
(\vec{v} \times \vec{c})' &= (\vec{a} \times \vec{c})\\
&= GM \hat{x}'\\
&= (GM\hat{x})'.
\end{align}
```
"""

# ╔═╡ 02cc5896-797b-11ec-14b1-1992d938f76b
md"""The two sides have the same derivative, hence differ by a constant:
"""

# ╔═╡ 02cc58a0-797b-11ec-076c-d34d0c018205
md"""```math
\vec{v} \times \vec{c} = GM \hat{x} + \vec{d}.
```
"""

# ╔═╡ 02cc58da-797b-11ec-332d-67c5df6a2ccd
md"""As $\vec{u}$ and $\vec{v}\times\vec{c}$ lie in the same plane - orthogonal to $\vec{c}$ - so does $\vec{d}$. With a suitable re-orientation, so that $\vec{d}$ is along the $x$ axis, $\vec{c}$ is along the $z$-axis, then we have $\vec{c} = \langle 0,0,c\rangle$ and $\vec{d} = \langle d ,0,0 \rangle$, and $\vec{x} = \langle x, y, 0 \rangle$. Set $\theta$ to be the angle, then $\hat{x} = \langle \cos(\theta), \sin(\theta), 0\rangle$.
"""

# ╔═╡ 02cc58e6-797b-11ec-3ccc-d965389e62bc
md"""Now
"""

# ╔═╡ 02cc58fa-797b-11ec-0ab3-c9dee5a71bbd
md"""```math
\begin{align}
c^2 &= \|\vec{c}\|^2 \\
&= \vec{c} \cdot \vec{c}\\
&= (\vec{x} \times \vec{v}) \cdot \vec{c}\\
&= \vec{x} \cdot (\vec{v} \times \vec{c})\\
&= r\hat{x} \cdot (GM\hat{x} + \vec{d})\\
&= GMr + r \hat{x} \cdot \vec{d}\\
&= GMr + rd \cos(\theta).
\end{align}
```
"""

# ╔═╡ 02cc5904-797b-11ec-0fba-2369a6bd6cf3
md"""Solving, this gives the radial distance in the form of an ellipse:
"""

# ╔═╡ 02cc5918-797b-11ec-1227-435292647944
md"""```math
r = \frac{c^2}{GM + d\cos(\theta)} =
\frac{c^2/(GM)}{1 + (d/GM) \cos(\theta)}.
```
"""

# ╔═╡ 02cc593e-797b-11ec-016c-8961d878717d
md"""Kepler's second law can also be derived from vector calculus. This derivation follows that given at [MIT OpenCourseWare](https://ocw.mit.edu/courses/mathematics/18-02sc-multivariable-calculus-fall-2010/1.-vectors-and-matrices/part-c-parametric-equations-for-curves/session-21-keplers-second-law/MIT18_02SC_MNotes_k.pdf) and [OpenCourseWare](https://ocw.mit.edu/courses/mathematics/18-02sc-multivariable-calculus-fall-2010/index.htm).
"""

# ╔═╡ 02cc5954-797b-11ec-352c-3bf0fc356455
md"""The second law states that the area being swept out during a time duration only depends on the duration of time, not the time. Let $\Delta t$ be this duration. Then if $\vec{x}(t)$ is the position vector, as above, we have the area swept out between $t$ and $t + \Delta t$ is visualized along the lines of:
"""

# ╔═╡ 02cc62c8-797b-11ec-25e2-2d87f9944906
let
	x1(t) = [cos(t), 2 * sin(t)]
	t0, t1, Delta = 1.0, 2.0, 1/10
	plot_parametric(0..pi/2, x1)
	
	arrow!([0,0], x1(t0)); arrow!([0,0], x1(t0 + Delta))
	arrow!(x1(t0), x1(t0+Delta)- x1(t0), linewidth=5)
end

# ╔═╡ 02cc62fa-797b-11ec-2360-f187c73e33a3
md"""The area swept out, is basically the half the area of the parallelogram formed by $\vec{x}(t)$ and $\Delta \vec{x}(t) = \vec{x}(t + \Delta t) - \vec{x}(t))$. This area is $(1/2) (\vec{x} \times \Delta\vec{x}(t))$.
"""

# ╔═╡ 02cc630e-797b-11ec-3458-350c9f9d6701
md"""If we divide through by $\Delta t$, and take a limit we have:
"""

# ╔═╡ 02cc6322-797b-11ec-05f5-b38c14dc7362
md"""```math
\frac{dA}{dt} = \| \frac{1}{2}\lim_{\Delta t \rightarrow 0} (\vec{x} \times \frac{\vec{x}(t + \Delta t) - \vec{x}(t)}{\Delta t})\| =
\frac{1}{2}\|\vec{x} \times \vec{v}\|.
```
"""

# ╔═╡ 02cc6340-797b-11ec-3c29-6788128690c6
md"""But we saw above, that for the motion of a planet, that $\vec{x} \times \vec{v} = \vec{c}$, a constant. This says, $dA$ is a constant independent of $t$, and consequently, the area swept out over a duration of time will not depend on the particular times involved, just the duration.
"""

# ╔═╡ 02cc635e-797b-11ec-0fcc-47296021bff6
md"""The third law relates the period to a parameter of the ellipse. We have from the above a strong suggestion that area of the ellipse can be found by integrating $dA$ over the period, say $T$. Assuming that is the case and letting $a$ be the semi-major axis length, and $b$ the semi-minor axis length, then
"""

# ╔═╡ 02cc6372-797b-11ec-2f23-cb0eccadf22b
md"""```math
\pi a b = \int_0^T dA = \int_0^T (1/2) \|\vec{x} \times \vec{v}\| dt = \| \vec{x} \times \vec{v}\| \frac{T}{2}.
```
"""

# ╔═╡ 02cc6390-797b-11ec-070a-fda35535d77e
md"""As $c = \|\vec{x} \times \vec{v}\|$ is a constant, this allows us to express $c$ by: $2\pi a b/T$.
"""

# ╔═╡ 02cc639a-797b-11ec-2b5a-175358d136b7
md"""But, we have
"""

# ╔═╡ 02cc63a4-797b-11ec-338d-2bfb7b39eb29
md"""```math
r(\theta) = \frac{c^2}{GM + d\cos(\theta)} = \frac{c^2/(GM)}{1 + d/(GM) \cos(\theta)}.
```
"""

# ╔═╡ 02cc63ba-797b-11ec-0316-0748983bb668
md"""So, $e = d/(GM)$ and $a (1 - e^2) = c^2/(GM)$. Using $b = a \sqrt{1-e^2}$ we have:
"""

# ╔═╡ 02cc63c2-797b-11ec-0209-6fd9532bd24c
md"""```math
a(1-e^2) = c^2/(GM) = (\frac{2\pi a b}{T})^2 \frac{1}{GM} =
\frac{(2\pi)^2}{GM} \frac{a^2 (a^2(1-e^2))}{T^2},
```
"""

# ╔═╡ 02cc63d6-797b-11ec-3614-61aaa05e5be3
md"""or after cancelling $(1-e^2)$ from each side:
"""

# ╔═╡ 02cc63e0-797b-11ec-0f73-e9cbc024d35a
md"""```math
T^2 = \frac{(2\pi)^2}{GM} \frac{a^4}{a} = \frac{(2\pi)^2}{GM} a^3.
```
"""

# ╔═╡ 02cc6408-797b-11ec-1be2-913873d6820a
md"""---
"""

# ╔═╡ 02cc6426-797b-11ec-220a-73dce0e42325
md"""The above shows how Newton might have derived Kepler's observational facts. Next we show, that assuming the laws of Kepler can anticipate Newton's equation for gravitational force. This follows [Wikipedia](https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Planetary_acceleration).
"""

# ╔═╡ 02cc644c-797b-11ec-3a18-3b758eb2aef4
md"""Now let $\vec{r}(t)$ be the position of the planet relative to the Sun at the origin, in two dimensions (we used $\vec{x}(t)$ above). Assume $\vec{r}(0)$ points in the $x$ direction. Write $\vec{r} = r \hat{r}$. Define $\hat{\theta(t)}$ to be the mapping from time $t$ to the angle  defined by $\hat{r}$ through the unit circle.
"""

# ╔═╡ 02cc646c-797b-11ec-1f51-091908ddad99
md"""Then we express the velocity ($\dot{\vec{r}}$) and acceleration ($\ddot{\vec{r}}$) in terms of the orthogonal vectors $\hat{r}$ and $\hat{\theta}$, as follows:
"""

# ╔═╡ 02cc6476-797b-11ec-2821-03646e83b026
md"""```math
\frac{d}{dt}(r \hat{r}) = \dot{r} \hat{r} + r \dot{\hat{r}} =  \dot{r} \hat{r} + r \dot{\theta}\hat{\theta}.
```
"""

# ╔═╡ 02cc648a-797b-11ec-252e-e3776511cadc
md"""The last equality from expressing $\hat{r}(t) = \hat{r}(\theta(t))$ and using the chain rule, noting $d(\hat{r}(\theta))/d\theta = \hat{\theta}$.
"""

# ╔═╡ 02cc649e-797b-11ec-17bc-51bd7109c96e
md"""Continuing,
"""

# ╔═╡ 02cc64a8-797b-11ec-0370-25bfb68d17d3
md"""```math
\frac{d^2}{dt^2}(r \hat{r}) =
(\ddot{r} \hat{r} + \dot{r} \dot{\hat{r}}) +
(\dot{r} \dot{\theta}\hat{\theta} + r \ddot{\theta}\hat{\theta} + r \dot{\theta}\dot{\hat{\theta}}).
```
"""

# ╔═╡ 02cc64c6-797b-11ec-153f-0f2458eb48c5
md"""Noting, similar to above, $\dot{\hat{\theta}}  = d\hat{\theta}/dt = d\hat{\theta}/d\theta \cdot d\theta/dt = -\dot{\theta} \hat{r}$ we can express the above in terms of $\hat{r}$ and $\hat{\theta}$ as:
"""

# ╔═╡ 02cc64da-797b-11ec-3602-91f530b4f665
md"""```math
\vec{a} = \frac{d^2}{dt^2}(r \hat{r}) = (\ddot{r} - r (\dot{\theta})^2) \hat{r}  + (r\ddot{\theta}  + 2\dot{r}\dot{\theta}) \hat{\theta}.
```
"""

# ╔═╡ 02cc64e4-797b-11ec-0d50-33708e8371c0
md"""That is, in general, the acceleration has a radial component and a transversal component.
"""

# ╔═╡ 02cc6502-797b-11ec-111a-231e01f13a27
md"""Kepler's second law says that the area increment over time is constant ($dA/dt$), but this area increment is approximated by the following wedge in polar coordinates: $dA = (1/2) r \cdot rd\theta$. We have then $dA/dt = r^2 \dot{\theta}$ is constant.
"""

# ╔═╡ 02cc650c-797b-11ec-2bf6-ff9adda5bdcf
md"""Differentiating, we have:
"""

# ╔═╡ 02cc6522-797b-11ec-13e4-5f33098043ca
md"""```math
0 = \frac{d(r^2 \dot{\theta})}{dt} = 2r\dot{r}\dot{\theta} + r^2 \ddot{\theta},
```
"""

# ╔═╡ 02cc652a-797b-11ec-2372-15f95dc86c81
md"""which is the tranversal component of the acceleration times $r$, as decomposed above. This means, that the acceleration of the planet is completely towards the Sun at the origin.
"""

# ╔═╡ 02cc653e-797b-11ec-3733-c389aa4991e2
md"""Kepler's first law, relates $r$ and $\theta$ through the polar equation of an ellipse:
"""

# ╔═╡ 02cc6548-797b-11ec-3e02-67567183ec41
md"""```math
r = \frac{p}{1 + \epsilon \cos(\theta)}.
```
"""

# ╔═╡ 02cc6566-797b-11ec-1f65-cddf561f1141
md"""Expressing in terms of $p/r$ and differentiating in $t$ gives:
"""

# ╔═╡ 02cc6570-797b-11ec-39a3-8d285b3264b9
md"""```math
-\frac{p \dot{r}}{r^2} = -\epsilon\sin(\theta) \dot{\theta}.
```
"""

# ╔═╡ 02cc657a-797b-11ec-3a4a-f1946277b492
md"""Or
"""

# ╔═╡ 02cc6582-797b-11ec-2a22-8d356e6cfe10
md"""```math
p\dot{r} = \epsilon\sin(\theta) r^2 \dot{\theta} = \epsilon \sin(\theta) C,
```
"""

# ╔═╡ 02cc6598-797b-11ec-17fd-edd5946bcec8
md"""For a constant $C$, used above, as the second law implies $r^2 \dot{\theta}$ is constant. (This constant can be expressed in terms of parameters describing the ellipse.)
"""

# ╔═╡ 02cc65a2-797b-11ec-38f5-5f301854c9d9
md"""Differentiating again in $t$, gives:
"""

# ╔═╡ 02cc65ac-797b-11ec-3fd3-29114a5b4e52
md"""```math
p \ddot{r} = C\epsilon \cos(\theta) \dot{\theta} = C\epsilon \cos(\theta)\frac{C}{r^2}.
```
"""

# ╔═╡ 02cc65c0-797b-11ec-0d6a-4138d486be8a
md"""So $\ddot{r} = (C^2 \epsilon / p) \cos{\theta} (1/r^2)$.
"""

# ╔═╡ 02cc65ca-797b-11ec-2b72-51fcf29e9caf
md"""The radial acceleration from above is:
"""

# ╔═╡ 02cc65d4-797b-11ec-2a99-5deac168c8c2
md"""```math
\ddot{r} - r (\dot{\theta})^2 =
(C^2 \epsilon/p) \cos{\theta} \frac{1}{r^2} - r\frac{C^2}{r^4} = \frac{C^2}{pr^2}(\epsilon \cos(\theta) - \frac{p}{r}).
```
"""

# ╔═╡ 02cc65e8-797b-11ec-11cb-dff6455b1f19
md"""Using $p/r = 1 + \epsilon\cos(\theta)$, we have the radial acceleration is $C^2/p \cdot (1/r^2)$. That is the acceleration, is proportional to the inverse square of the position, and using the relation between $F$, force, and acceleration, we see the force on the planet follows the inverse-square law of Newton.
"""

# ╔═╡ 02cc661a-797b-11ec-1491-17ca9f5cd0fa
md"""### Moving frames of reference
"""

# ╔═╡ 02cc662e-797b-11ec-2081-5b4e258ffc01
md"""In the last example, it proved useful to represent vectors in terms of other unit vectors, in that case $\hat{r}$ and $\hat{\theta}$. Here we discuss a coordinate system defined intrinsically by the motion along the trajectory of a curve.
"""

# ╔═╡ 02cc666a-797b-11ec-3989-6571afacc6cc
md"""Let $r(t)$ be a smooth vector-valued function in $R^3$. It gives rise to a space curve, through its graph. This curve has tangent vector $\vec{r}'(t)$, indicating the direction of travel along $\vec{r}$ as $t$ increases. The length of $\vec{r}'(t)$ depends on the parameterization of $\vec{r}$, as for any increasing, differentiable function $s(t)$, the composition $\vec{r}(s(t))$ will have derivative, $\vec{r}'(s(t)) s'(t)$, having the same direction as $\vec{r}'(t)$ (at suitably calibrated points), but not the same magnitude, the factor of $s(t)$ being involved.
"""

# ╔═╡ 02cc6674-797b-11ec-0d27-6dee5e3b4d2c
md"""To discuss properties intrinsic to the curve, the unit vector is considered:
"""

# ╔═╡ 02cc6686-797b-11ec-2e76-6fc86db2074a
md"""```math
\hat{T}(t) = \frac{\vec{r}'(t)}{\|\vec{r}'(t)\|}.
```
"""

# ╔═╡ 02cc66a6-797b-11ec-3280-3d3bbb0847d5
md"""The function $\hat{T}(t)$ is the unit tangent vector. Now define the unit *normal*, $\hat{N}(t)$, by:
"""

# ╔═╡ 02cc66b0-797b-11ec-03c4-e9cbd964078d
md"""```math
\hat{N}(t) = \frac{\hat{T}'(t)}{\| \hat{T}'(t) \|}.
```
"""

# ╔═╡ 02cc66ce-797b-11ec-20f1-9152156a0c35
md"""Since $\|\hat{T}(t)\| = 1$, a constant, it must be that $\hat{T}'(t) \cdot \hat{T}(t) = 0$, that is, the $\hat{N}$ and $\hat{T}$ are orthogonal.
"""

# ╔═╡ 02cc66ea-797b-11ec-1543-75b71f953555
md"""Finally, define the *binormal*, $\hat{B}(t) = \hat{T}(t) \times \hat{N}(t)$. At each time $t$, the three unit vectors are orthogonal to each other. They form a moving coordinate system for the motion along the curve that does not depend on the parameterization.
"""

# ╔═╡ 02cc6714-797b-11ec-3e76-f1994e1f8dcb
md"""We can visualize this, for example along a [Viviani](https://tinyurl.com/y4lo29mv) curve, as is done in a [Wikipedia](https://en.wikipedia.org/wiki/Frenet%E2%80%93Serret_formulas) animation:
"""

# ╔═╡ 02cc73da-797b-11ec-34e9-757e25e15dea
let
	function viviani(t, a=1)
	    [a*(1-cos(t)), a*sin(t), 2a*sin(t/2)]
	end
	
	
	Tangent(t) = viviani'(t)/norm(viviani'(t))
	Normal(t) = Tangent'(t)/norm(Tangent'(t))
	Binormal(t) = Tangent(t) × Normal(t)
	
	p = plot(legend=false)
	plot_parametric!(-2pi..2pi, viviani)
	
	t0, t1 = -pi/3, pi/2 + 2pi/5
	r0, r1 = viviani(t0), viviani(t1)
	arrow!(r0, Tangent(t0)); arrow!(r0, Binormal(t0)); arrow!(r0, Normal(t0))
	arrow!(r1, Tangent(t1)); arrow!(r1, Binormal(t1)); arrow!(r1, Normal(t1))
	p
end

# ╔═╡ 02cc73f8-797b-11ec-39dd-4f8ec1257364
md"""---
"""

# ╔═╡ 02cc742a-797b-11ec-0701-09cfc852c170
md"""The *curvature* of a $3$-dimensional space curve is defined by:
"""

# ╔═╡ 02d1012a-797b-11ec-3372-0985bd224d31
md"""> *The curvature*: For a $3-D$ curve the curvature is defined by:
>
> $\kappa = \frac{\| r'(t) \times r''(t) \|}{\| r'(t) \|^3}.$

"""

# ╔═╡ 02d1018e-797b-11ec-0192-7539a93c9b77
md"""For $2$-dimensional space curves, the same formula applies after embedding a $0$ third component. It can also be expressed directly as
"""

# ╔═╡ 02d101b6-797b-11ec-1a00-4b16f55890a9
md"""```math
\kappa = (x'y''-x''y')/\|r'\|^3. \quad (r(t) =\langle x(t), y(t) \rangle)
```
"""

# ╔═╡ 02d101fc-797b-11ec-3a3a-834c6967e937
md"""Curvature can also be defined as derivative of the tangent vector, $\hat{T}$, *when* the curve is parameterized by arc length, a topic still to be taken up.  The vector $\vec{r}'(t)$ is the direction of motion, whereas $\vec{r}''(t)$ indicates how fast and in what direction this is changing. For curves with little curve in them, the two will be nearly parallel and the cross product small (reflecting the presence of $\cos(\theta)$ in the definition). For "curvy" curves, $\vec{r}''$ will be in a direction opposite of $\vec{r}'$ to the $\cos(\theta)$ term in the cross product will be closer to $1$.
"""

# ╔═╡ 02d10210-797b-11ec-292b-f709baff0750
md"""Let $\vec{r}(t) = k \cdot \langle \cos(t), \sin(t), 0 \rangle$. This will have curvature:
"""

# ╔═╡ 02d109fe-797b-11ec-33a5-a5a95772b6bc
let
	@syms k::positive t::real
	r1 = k * [cos(t), sin(t), 0]
	norm(diff.(r1,t) × diff.(r1,t,t)) / norm(diff.(r1,t))^3 |> simplify
end

# ╔═╡ 02d10a30-797b-11ec-022a-c304685771e1
md"""For larger circles (bigger $\|k\|$) there is less curvature. The limit being a line with curvature $0$.
"""

# ╔═╡ 02d10a4e-797b-11ec-041e-2d89a0d86fcf
md"""If a curve is imagined to have a tangent "circle" (second order Taylor series approximation), then the curvature of that circle matches the curvature of the curve.
"""

# ╔═╡ 02d10a74-797b-11ec-0386-67ccbbbe15d5
md"""The [torsion](https://en.wikipedia.org/wiki/Torsion_of_a_curve), $\tau$, of a space curve ($n=3$), is a measure of how sharply the curve is twisting out of the plane of curvature.
"""

# ╔═╡ 02d10a8a-797b-11ec-01ab-33fa8aaa63f2
md"""The torsion is defined for smooth curves by
"""

# ╔═╡ 02d10b4a-797b-11ec-234f-4d268ed9131c
md"""> *The torsion*:
>
> $\tau = \frac{(\vec{r}' \times \vec{r}'') \cdot \vec{r}'''}{\|\vec{r}' \times \vec{r}''\|^2}.$

"""

# ╔═╡ 02d10b66-797b-11ec-194b-6906b2a4a46f
md"""For the torsion to be defined, the cross product $\vec{r}' \times \vec{r}''$ must be non zero, that is the two must not be parallel or zero.
"""

# ╔═╡ 02d10b98-797b-11ec-3b36-afc61772f835
md"""## Arc length
"""

# ╔═╡ 02d10bb6-797b-11ec-1e4d-d3c68f17de06
md"""In [Arc length](../integrals/arc_length.html) there is a discussion of how to find the arc length of a parameterized curve in $2$ dimensions. The general case is discussed by [Destafano](https://randomproofs.files.wordpress.com/2010/11/arc_length.pdf) who shows:
"""

# ╔═╡ 02d17736-797b-11ec-0a4e-7bbf32e7ea66
md"""> *Arc-length*: if a curve $C$ is parameterized by a smooth function $\vec{r}(t)$ over an interval $I$, then the arc length of $C$ is:
>
> ```math
> \int_I \| \vec{r}'(t)  \| dt.
> ```

"""

# ╔═╡ 02d177c2-797b-11ec-0f52-d7f33ab502b1
md"""If we associate $\vec{r}'(t)$ with the velocity, then this is the integral of the speed (the magnitude of the velocity).
"""

# ╔═╡ 02d177ea-797b-11ec-305c-1bf26a1e44e0
md"""Let $I=[a,b]$ and $s(t): [v,w] \rightarrow [a,b]$ such that $s$ is increasing and differentiable. Then $\vec{\phi} = \vec{r} \circ s$ will have have
"""

# ╔═╡ 02d17806-797b-11ec-0720-dd5baa03a5f8
md"""```math
\text{arc length} =
\int_v^w \| \vec{\phi}'(t)\| dt =
\int_v^w \| \vec{r}'(s(t))\| s'(t) dt =
\int_a^b \| \vec{r}'(u) \| du,
```
"""

# ╔═╡ 02d1781c-797b-11ec-3fa2-39a05a10fc1d
md"""by a change of variable $u=s(t)$. As such the arc length is a property of the curve and not the parameterization of the curve.
"""

# ╔═╡ 02d17830-797b-11ec-2be5-01170f0e280c
md"""For some parameterization, we can define
"""

# ╔═╡ 02d17838-797b-11ec-097c-d70734e01f82
md"""```math
s(t) = \int_0^t \| \vec{r}'(u) \| du
```
"""

# ╔═╡ 02d17858-797b-11ec-00d2-c1665656bc6e
md"""Then by the fundamental theorem of calculus, $s(t)$ is non-decreasing. If $\vec{r}'$ is assumed to be non-zero and continuous (regular), then $s(t)$ has a derivative and an inverse which is monotonic. Using the inverse function $s^{-1}$ to change variables ($\vec{\phi} = \vec{r} \circ s^{-1}$) has
"""

# ╔═╡ 02d1786a-797b-11ec-333f-49bc4d5887e0
md"""```math
\int_0^c \| \phi'(t) \| dt =
\int_{s^{-1}(0)}^{s^{-1}(c)} \| \vec{r}'(u) \| du =
s(s^{-1}(c)) - s(s^{-1}(0)) =
c
```
"""

# ╔═╡ 02d17880-797b-11ec-0b91-41a5f029a47d
md"""That is, the arc length from $[0,c]$ for $\phi$ is just $c$; the curve $C$ is parameterized by arc length.
"""

# ╔═╡ 02d178b2-797b-11ec-3f51-9b8bea569cd6
md"""##### Example
"""

# ╔═╡ 02d178d0-797b-11ec-3041-255b3829f70c
md"""Viviani's curve is the intersection of sphere of radius $a$ with a cylinder of radius $a$. A parameterization was given previously by:
"""

# ╔═╡ 02d184e0-797b-11ec-0ef7-19209a119401
function viviani(t, a=1)
    [a*(1-cos(t)), a*sin(t), 2a*sin(t/2)]
end

# ╔═╡ 02d18514-797b-11ec-30c7-8d62ee09c16c
md"""The curve is traced out over the interval $[0, 4\pi]$. We try to find the arc-length:
"""

# ╔═╡ 02d18a3c-797b-11ec-1124-5f1e1f088d8e
let
	@syms t::positive a::positive
	speed = simplify(norm(diff.(viviani(t, a), t)))
	integrate(speed, (t, 0, 4*PI))
end

# ╔═╡ 02d18a78-797b-11ec-1e8f-b70ef12cd812
md"""We see that the answer depends linearly on $a$, but otherwise is a constant expressed as an integral. We use `QuadGk` to provide a numeric answer for the case $a=1$:
"""

# ╔═╡ 02d18fb4-797b-11ec-3e36-05c363cab459
quadgk(t -> norm(viviani'(t)), 0, 4pi)

# ╔═╡ 02d18fd2-797b-11ec-3e27-b3e2bbd594c7
md"""##### Example
"""

# ╔═╡ 02d18ff0-797b-11ec-1a90-a1c65815f128
md"""Very few parameterized curves admit a closed-form expression for parameterization by arc-length. Let's consider the helix expressed by $\langle a\cos(t), a\sin(t), bt\rangle$, as this does allow such a parameterization.
"""

# ╔═╡ 02d1972a-797b-11ec-26b6-5fa0129e3eeb
begin
	@syms aₕ::positive bₕ::positive tₕ::positive alₕ::positive
	helix = [aₕ * cos(tₕ), aₕ * sin(tₕ), bₕ * tₕ]
	speed = simplify( norm(diff.(helix, tₕ)) )
	s = integrate(speed, (tₕ, 0, alₕ))
end

# ╔═╡ 02d19768-797b-11ec-3925-3f9ea5576050
md"""So `s` is a linear function. We can re-parameterize by:
"""

# ╔═╡ 02d19f0e-797b-11ec-1911-79bae6d21bfe
eqnₕ = subs.(helix, tₕ => alₕ/sqrt(aₕ^2 + bₕ^2))

# ╔═╡ 02d19f4a-797b-11ec-02da-4142a9be2711
md"""To see that the speed, $\| \vec{\phi}' \|$, is constantly $1$:
"""

# ╔═╡ 02d1a31e-797b-11ec-08f3-e97206f1c0bf
simplify(norm(diff.(eqnₕ, alₕ)))

# ╔═╡ 02d1a346-797b-11ec-3646-c10784ea9b0f
md"""From this, we have the arc length is:
"""

# ╔═╡ 02d1a36e-797b-11ec-2f97-f931a7807337
md"""```math
\int_0^t \| \vec{\phi}'(u) \| du = \int_0^t 1 du = t
```
"""

# ╔═╡ 02d1a38c-797b-11ec-1805-6d45cc3f3b50
md"""---
"""

# ╔═╡ 02d1a3be-797b-11ec-32cb-813ff70d78fe
md"""Parameterizing by arc-length is only explicitly possible for a few examples, however knowing it can be done in theory, is important. Some formulas are simplified, such as the tangent, normal, and binormal. Let $\vec{r}(s)$ be parameterized by arc length, then:
"""

# ╔═╡ 02d1a3c8-797b-11ec-36a9-95785634b08e
md"""```math
\hat{T}(s)= \vec{r}'(s) / \| \vec{r}'(s) \| = \vec{r}'(s),\quad
\hat{N}(s) = \hat{T}'(s) / \| \hat{T}'(s)\| = \hat{T}'(s)/\kappa,\quad
\hat{B} = \hat{T} \times \hat{N},
```
"""

# ╔═╡ 02d1a3f0-797b-11ec-1487-618f6ea6a6ed
md"""As before, but further, we have if $\kappa$ is the curvature and $\tau$ the torsion, these relationships expressing the derivatives with respect to $s$ in terms of the components in the frame:
"""

# ╔═╡ 02d1a3fa-797b-11ec-1301-9b182943313b
md"""```math
\begin{align*}
\hat{T}'(s) &=                    &\kappa \hat{N}(s)  &\\
\hat{N}'(s) &= -\kappa \hat{T}(s) &                   &+ \tau \hat{B}(s)\\
\hat{B}'(s) &=                    &-\tau \hat{N}(s)   &
\end{align*}
```
"""

# ╔═╡ 02d1a422-797b-11ec-256e-7b4b9161bd1e
md"""These are the [Frenet-Serret](https://en.wikipedia.org/wiki/Frenet%E2%80%93Serret_formulas) formulas.
"""

# ╔═╡ 02d1a436-797b-11ec-0268-654a47776929
md"""##### Example
"""

# ╔═╡ 02d1a44a-797b-11ec-0f93-4ffa9e07b5f1
md"""Continuing with our parameterization of a helix by arc length, we can compute the curvature and torsion by differentiation:
"""

# ╔═╡ 02d1b106-797b-11ec-1599-817a11db2cdb
begin
	gammaₕ = subs.(helix, tₕ => alₕ/sqrt(aₕ^2 + bₕ^2))   # gamma parameterized by arc length
	@syms uₕ::positive
	gammaₕ₁ = subs.(gammaₕ, alₕ .=> uₕ)                  # u is arc-length parameterization
end

# ╔═╡ 02d1b76e-797b-11ec-1269-f1471e19362b
begin
	Tₕ = diff.(gammaₕ₁, uₕ)
	norm(Tₕ)  |> simplify
end

# ╔═╡ 02d1b7b4-797b-11ec-3590-05dc74453a1b
md"""The length is one, as the speed of a curve parameterized by arc-length is 1.
"""

# ╔═╡ 02d1bbd8-797b-11ec-0f52-8f508361e799
outₕ = diff.(Tₕ, uₕ)

# ╔═╡ 02d1bc34-797b-11ec-2f96-5fc48fb5674e
md"""This should be $\kappa \hat{N}$, so we do:
"""

# ╔═╡ 02d1c298-797b-11ec-292c-352dce601ddf
begin
	κₕ = norm(outₕ) |> simplify
	Normₕ = outₕ / κₕ
	κₕ, Normₕ
end

# ╔═╡ 02d1c2ea-797b-11ec-272c-d35832e53b7d
md"""Interpreting, $a$ is the radius of the circle and $b$ how tight the coils are. If $a$ gets much larger than $b$, then the curvature is like $1/a$, just as with a circle. If $b$ gets very big, then the trajectory looks more stretched out and the curvature gets smaller.
"""

# ╔═╡ 02d1c2fe-797b-11ec-261a-cbc248766e8b
md"""To find the torsion, we find, $\hat{B}$ then differentiate:
"""

# ╔═╡ 02d1c806-797b-11ec-1ec5-2b5eac059cc5
begin
	Bₕ = Tₕ × Normₕ
	outₕ₁ = diff.(Bₕ, uₕ)
	τₕ = norm(outₕ₁)
end

# ╔═╡ 02d1c830-797b-11ec-2f85-d32cfc282927
md"""This looks complicated, as does `Norm`:
"""

# ╔═╡ 02d1c934-797b-11ec-00b1-5f4a4b7ae88b
Normₕ

# ╔═╡ 02d1c948-797b-11ec-1dcf-a16ba7c46dd7
md"""However, the torsion, up to a sign, simplifies nicely:
"""

# ╔═╡ 02d1cc9a-797b-11ec-1a67-47ae832f8aac
τₕ |> simplify

# ╔═╡ 02d1ccea-797b-11ec-2adf-d18191f2c619
md"""Here, when $b$ gets large, the curve looks more and more "straight" and the torsion decreases. Similarly, if $a$ gets big, the torsion decreases.
"""

# ╔═╡ 02d1cd08-797b-11ec-17f6-b519f3332164
md"""##### Example
"""

# ╔═╡ 02d1cd58-797b-11ec-197f-15b5fc49f369
md"""[Levi and Tabachnikov](https://projecteuclid.org/download/pdf_1/euclid.em/1259158427) consider the trajectories of the front and rear bicycle wheels. Recall the notation previously used: $\vec{F}(t)$ for the front wheel, and $\vec{B}(t)$ for the rear wheel trajectories. Consider now their parameterization by arc length, using $u$ for the arc-length parameter for $\vec{F}$ and $v$ for $\vec{B}$. We define $\alpha(u)$ to be the steering angle of the bicycle. This can be found as the angle between the tangent vector of the path of $\vec{F}$ with the vector $\vec{B} - \vec{F}$. Let $\kappa$ be the curvature of the front wheel and $k$ the curvature of the back wheel.
"""

# ╔═╡ 02d1d1e0-797b-11ec-260d-bd4fb46482d1
md"""Levi and Tabachnikov prove in their Proposition 2.4:
"""

# ╔═╡ 02d1d208-797b-11ec-005c-df9aa2904b0a
md"""```math
\begin{align*}
\kappa(u) &= \frac{d\alpha(u)}{du} + \frac{\sin(\alpha(u))}{a},\\
|\frac{du}{dv}| &= |\cos(\alpha)|, \quad \text{and}\\
k &= \frac{\tan(\alpha)}{a}.
\end{align*}
```
"""

# ╔═╡ 02d1d230-797b-11ec-09fa-b702259f78c2
md"""The first equation relates the steering angle with the curvature. If the steering angle is not changed ($d\alpha/du=0$) then the curvature is constant and the motion is circular. It will be greater for larger angles (up to $\pi/2$). As the curvature is the reciprocal of the radius, this means the radius of the circular trajectory will be smaller. For the same constant steering angle, the curvature will be smaller for longer wheelbases, meaning the circular trajectory will have a larger radius. For cars, which have similar dynamics, this means longer wheelbase cars will take more room to make a U turn.
"""

# ╔═╡ 02d1d258-797b-11ec-389f-218bff4d471e
md"""The second equation may be interpreted in ratio of arc lengths. The infinitesimal arc length of the rear wheel is proportional to that of the front wheel only scaled down by $\cos(\alpha)$. When $\alpha=0$ - the bike is moving in a straight line - and the two are the same. At the other extreme - when $\alpha=\pi/2$ - the bike must be pivoting on its rear wheel and the rear wheel has no arc length. This cosine, is related to the speed of the back wheel relative to the speed of the front wheel, which was used in the initial differential equation.
"""

# ╔═╡ 02d1d26c-797b-11ec-000e-4d3c3f6cd33d
md"""The last equation, relates the curvature of the back wheel track to the steering angle of the front wheel. When $\alpha=\pm\pi/2$, the rear-wheel curvature, $k$, is infinite, resulting in a cusp (no circle with non-zero radius will approximate the trajectory). This occurs when the front wheel is steered orthogonal to the direction of motion. As was seen in previous graphs of the trajectories, a cusp can happen for quite regular front wheel trajectories.
"""

# ╔═╡ 02d1d28a-797b-11ec-0275-bb3583722379
md"""To derive the first one, we have previously noted that when a curve is parameterized by arc length, the curvature is more directly computed: it is the magnitude of the derivative of the tangent vector. The tangent vector is of unit length, when parametrized by arc length. This implies it's derivative will be orthogonal. If $\vec{r}(t)$ is a parameterization by arc length, then the curvature formula simplifies as:
"""

# ╔═╡ 02d1d294-797b-11ec-23fe-998a1fb44aac
md"""```math
\kappa(s) = \frac{\| \vec{r}'(s) \times \vec{r}''(s) \|}{\|\vec{r}'(s)\|^3} =
\frac{\| \vec{r}'(s) \times \vec{r}''(s) \|}{1} =
\| \vec{r}'(s) \| \| \vec{r}''(s) \| \sin(\theta) =
1 \| \vec{r}''(s) \| 1 = \| \vec{r}''(s) \|.
```
"""

# ╔═╡ 02d1d2b0-797b-11ec-032f-5f15ca0cecb1
md"""So in the above, the curvature is $\kappa = \| \vec{F}''(u) \|$ and $k = \|\vec{B}''(v)\|$.
"""

# ╔═╡ 02d1d2d0-797b-11ec-3b6a-878d037e99ae
md"""On the figure, the tangent vector $\vec{F}'(u)$ is drawn, along with this unit vector rotated by $\pi/2$. We call these, for convenience, $\vec{U}$ and $\vec{V}$. We have $\vec{U} = \vec{F}'(u)$ and $\vec{V} = -(1/\kappa) \vec{F}''(u)$.
"""

# ╔═╡ 02d1d2ee-797b-11ec-193e-fbd588773fab
md"""The key decomposition, is to express a unit vector in the direction of the line segment, as the vector $\vec{U}$ rotated by $\alpha$ degrees. Mathematically, this is usually expressed in matrix notation, but more explicitly by
"""

# ╔═╡ 02d1d2f8-797b-11ec-12b1-51531a5b64b4
md"""```math
\langle \cos(\alpha) \vec{U}_1 - \sin(\alpha) \vec{U}_2,
\sin(\alpha) \vec{U}_1 + \cos(\alpha) \vec{U}_2 =
\vec{U} \cos(\alpha) - \vec{V} \sin(\alpha).
```
"""

# ╔═╡ 02d1d30c-797b-11ec-0483-475cf608200e
md"""With this, the mathematical relationship between $F$ and $B$ is just a multiple of this unit vector:
"""

# ╔═╡ 02d1d314-797b-11ec-3747-a58f9f92fb08
md"""```math
\vec{B}(u) = \vec{F}(u) - a \vec{U} \cos(\alpha) + a \vec{V} \sin(\alpha).
```
"""

# ╔═╡ 02d1d33e-797b-11ec-2aa1-79a4ff153f54
md"""It must be that the tangent line of $\vec{B}$ is parallel to $\vec{U} \cos(\alpha) + \vec{V} \sin(\alpha)$. To utilize this, we differentiate $\vec{B}$ using the facts that $\vec{U}' = \kappa \vec{V}$ and $\vec{V}' = -\kappa \vec{U}$. These coming from $\vec{U} = \vec{F}'$ and so it's derivative in $u$ has magnitude yielding the curvature, $\kappa$, and direction orthogonal to $\vec{U}$.
"""

# ╔═╡ 02d1d352-797b-11ec-2ea8-95adcc769d00
md"""```math
\begin{align}
\vec{B}'(u) &= \vec{F}'(u)
-a \vec{U}' \cos(\alpha) -a \vec{U} (-\sin(\alpha)) \alpha'
+a \vec{V}' \sin(\alpha) + a \vec{V} \cos(\alpha) \alpha'\\
& =  \vec{U}
-a (\kappa) \vec{V} \cos(\alpha) + a \vec{U} \sin(\alpha) \alpha' +
a (-\kappa) \vec{U} \sin(\alpha) + a \vec{V} \cos(\alpha) \alpha' \\
&= \vec{U}
+ a(\alpha' - \kappa) \sin(\alpha) \vec{U}
+ a(\alpha' - \kappa) \cos(\alpha)\vec{V}.
\end{align}
```
"""

# ╔═╡ 02d1d366-797b-11ec-3cee-1b730a6013d6
md"""Extend the $2$-dimensional vectors to $3$-D, by adding a zero $z$ component, then:
"""

# ╔═╡ 02d1d37a-797b-11ec-2c0c-9b1479e2a80c
md"""```math
\begin{align}
\vec{0} &= (\vec{U}
+ a(\alpha' - \kappa) \sin(\alpha) \vec{U}
+ a(\alpha' - \kappa) \cos(\alpha)\vec{V}) \times
(-\vec{U} \cos(\alpha) +  \vec{V} \sin(\alpha)) \\
&= (\vec{U} \times \vec{V}) \sin(\alpha) +
a(\alpha' - \kappa) \sin(\alpha) \vec{U} \times  \vec{V} \sin(\alpha)) -
a(\alpha' - \kappa) \cos(\alpha)\vec{V} \times \vec{U} \cos(\alpha) \\
&= (\sin(\alpha) + a(\alpha'-\kappa) \sin^2(\alpha) +
a(\alpha'-\kappa) \cos^2(\alpha)) \vec{U} \times \vec{V} \\
&= (\sin(\alpha) + a (\alpha' - \kappa)) \vec{U} \times \vec{V}.
\end{align}
```
"""

# ╔═╡ 02d1d398-797b-11ec-0a37-5d6fdae4ac64
md"""The terms $\vec{U} \times\vec{U}$ and $\vec{V}\times\vec{V}$ being $\vec{0}$, due to properties of the cross product. This says the scalar part must be $0$, or
"""

# ╔═╡ 02d1d3ac-797b-11ec-2575-c5c962535f3b
md"""```math
\frac{\sin(\alpha)}{a} + \alpha' = \kappa.
```
"""

# ╔═╡ 02d1d3c0-797b-11ec-2ac2-91d52d59f678
md"""As for the second equation, from the expression for $\vec{B}'(u)$, after setting $a(\alpha'-\kappa) = -\sin(\alpha)$:
"""

# ╔═╡ 02d1d3ca-797b-11ec-2a74-f3b3fa7836b7
md"""```math
\begin{align}
\|\vec{B}'(u)\|^2
&= \| (1 -\sin(\alpha)\sin(\alpha)) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
&= \| \cos^2(\alpha) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
&= (\cos^2(\alpha))^2 + (\sin(\alpha)\cos(\alpha))^2\quad\text{using } \vec{U}\cdot\vec{V}=0\\
&= \cos^2(\alpha)(\cos^2(\alpha) + \sin^2(\alpha))\\
&= \cos^2(\alpha).
\end{align}
```
"""

# ╔═╡ 02d1d3ea-797b-11ec-167d-e3f11447e18f
md"""From this $\|\vec{B}(u)\| = |\cos(\alpha)\|$. But $1 = \|d\vec{B}/dv\| = \|d\vec{B}/du \| \cdot |du/dv|$ and $|dv/du|=|\cos(\alpha)|$ follows.
"""

# ╔═╡ 02d1d9ce-797b-11ec-0dae-4581859cc6da
#How to compute the curvature k?
#```math
#\begin{align}
#\frac{d^2\hat{B}}{dv}
#&= \frac{d^2\hat{B}}{du^2} \cdot (\frac{dv}{du})^2 + \frac{d^2v}{du^2} \cdot \hat{B}'(u)\\
#&= \cos^2(\alpha) \cdot (-2\sin(\alpha)\cos(\alpha}\alpha'\vec{U} + \cos^2(\alpha) \kappa \vec{V} - (\cos^2(\alph#a)-\sin^2(\alpha))\alpha'\vec{V} + \sin(\alpha)\cos(\alpha)\kappa \vec{U}) + \frac{\sin(\alpha)}{\cos^2(\alpha) \#cdot (\cos^2(\alpha)\vec{U} - \sin(\alpha)\cos(\alpha) \vec{V})\\
#&=
#
#
#&= \| (1 -\sin(alpha)\sin(\alpha) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
#&= \| \cos^2(\alpha) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
#&= ((\cos^2(alpha))^2 + (\sin(\alpha)\cos(\alpha))^2\quad\text{using } \vec{U}\cdot\vec{V}=0\\
#&= \cos(\alpha)^2.
#\end{align}
#```
nothing

# ╔═╡ 02d1d9ea-797b-11ec-2f27-77b543987733
md"""##### Example: evolutes and involutes
"""

# ╔═╡ 02d1da14-797b-11ec-1bf9-db70586bf3d9
md"""Following [Fuchs](https://doi.org/10.4169/amer.math.monthly.120.03.217) we discuss a geometric phenomenon known and explored by Huygens, and likely earlier. We stick to the two-dimensional case, Fuchs extends this to three dimensions. The following figure
"""

# ╔═╡ 02d1df64-797b-11ec-04b2-3baef9d4f379
begin
	Xₑ(t)= 2 * cos(t)
	Yₑ(t) = sin(t)
	rₑ(t) = [Xₑ(t), Yₑ(t)]
	unit_vec(x) = x / norm(x)
	plot(legend=false, aspect_ratio=:equal)
	ts = range(0, 2pi, length=50)
	for t in ts
	    Pₑ, Vₑ = rₑ(t), unit_vec([-Yₑ'(t), Xₑ'(t)])
	    plot_parametric!(-4..4, x -> Pₑ + x*Vₑ)
	end
	plot!(Xₑ, Yₑ, 0, 2pi, linewidth=5)
end

# ╔═╡ 02d1df96-797b-11ec-2bf7-258ed4904088
md"""is that of an ellipse with many *normal* lines drawn to it. The normal lines appear to intersect in a somewhat diamond-shaped curve. This curve is the evolute of the ellipse. We can characterize this using the language of planar curves.
"""

# ╔═╡ 02d1dfd2-797b-11ec-3fa0-19e50c00529a
md"""Consider a parameterization of a curve by arc-length, $\vec\gamma(s) = \langle u(s), v(s) \rangle$. The unit *tangent* to this curve is $\vec\gamma'(s) = \hat{T}(s) = \langle u'(s), v'(s) \rangle$ and by simple geometry the unit *normal* will be $\hat{N}(s) = \langle -v'(s), u'(s) \rangle$. At a time $t$, a line through the curve parameterized by $\vec\gamma$ is given by $l_t(a) = \vec\gamma(t) + a \hat{N}(t)$.
"""

# ╔═╡ 02d1dffc-797b-11ec-02ee-97aa268a6b07
md"""Consider two nearby points $t$ and $t+\epsilon$ and the intersection of $l_t$ and $l_{t+\epsilon}$. That is, we need points $a$ and $b$ with: $l_t(a) = l_{t+\epsilon}(b)$. Setting the components equal, this is:
"""

# ╔═╡ 02d1e00e-797b-11ec-0dbb-0d025127571b
md"""```math
\begin{align}
u(t) - av'(t) &= u(t+\epsilon) - bv'(t+\epsilon) \\
v(t) - au'(t) &= v(t+\epsilon) - bu'(t+\epsilon).
\end{align}
```
"""

# ╔═╡ 02d1e02e-797b-11ec-1fdf-7ffcc5800721
md"""This is a linear equation in two unknowns ($a$ and $b$) which can be solved. Here is the value for `a`:
"""

# ╔═╡ 02d1e662-797b-11ec-1bd1-dde531471c7e
begin
	@syms u() v() t epsilon w
	@syms a b
	γ(t) = [u(t),v(t)]
	n(t) = subs.(diff.([-v(w), u(w)], w), w.=>t)
	l(a, t) = γ(t) + a * n(t)
	out = solve(l(a, t) - l(b, t+epsilon), [a,b])
	out[a]
end

# ╔═╡ 02d1e6a8-797b-11ec-2afa-89231da05825
md"""Letting $\epsilon \rightarrow 0$ we get an expression for $a$ that will describe the evolute at time $t$ in terms of the function $\gamma$. Looking at the expression above, we can see that dividing the *numerator* by $\epsilon$ and taking a limit will yield $u'(t)^2 + v'(t)^2$. If the *denominator* has a limit after dividing by $\epsilon$, then we can find the description sought. Pursuing this leads to:
"""

# ╔═╡ 02d1e6bc-797b-11ec-30ae-1114945b717d
md"""```math
\begin{align*}
\frac{u'(t) v'(t+\epsilon) - v'(t) u'(t+\epsilon)}{\epsilon}
&= \frac{u'(t) v'(t+\epsilon) -u'(t)v'(t) + u'(t)v'(t)- v'(t) u'(t+\epsilon)}{\epsilon} \\
&= \frac{u'(t)(v'(t+\epsilon) -v'(t))}{\epsilon} + \frac{(u'(t)- u'(t+\epsilon))v'(t)}{\epsilon},
\end{align*}
```
"""

# ╔═╡ 02d1e6da-797b-11ec-2d02-f3200709e08e
md"""which in the limit will give $u'(t)v''(t) - u''(t) v'(t)$. All told, in the limit as $\epsilon \rightarrow 0$ we get
"""

# ╔═╡ 02d1e6e4-797b-11ec-2845-cb4e8c3839fe
md"""```math
\begin{align*}
a &= \frac{u'(t)^2 + v'(t)^2}{u'(t)v''(t) - v'(t) u''(t)} \\
&= 1/(\|\vec\gamma'\|\kappa) \\
&= 1/(\|\hat{T}\|\kappa) \\
&= 1/\kappa,
\end{align*}
```
"""

# ╔═╡ 02d1e6f8-797b-11ec-32dc-c74a8a6835a8
md"""with $\kappa$ being the curvature of the planar curve. That is, the evolute of $\vec\gamma$ is described by:
"""

# ╔═╡ 02d1e70c-797b-11ec-22f5-d94ebf6c6950
md"""```math
\vec\beta(s) = \vec\gamma(s) + \frac{1}{\kappa(s)}\hat{N}(s).
```
"""

# ╔═╡ 02d1e720-797b-11ec-2472-c5b414ccf9c7
md"""Revisualizing:
"""

# ╔═╡ 02d1edec-797b-11ec-1fa3-097e57bdbbad
begin
	rₑ₃(t) = [2cos(t), sin(t), 0]
	Tangent(r, t) = unit_vec(r'(t))
	Normal(r, t) = unit_vec((𝒕 -> Tangent(r, 𝒕))'(t))
	curvature(r, t) = norm(r'(t) × r''(t) ) / norm(r'(t))^3
	
	plot_parametric(0..2pi, t -> rₑ₃(t)[1:2], legend=false, aspect_ratio=:equal)
	plot_parametric!(0..2pi, t -> (rₑ₃(t) + Normal(rₑ₃, t)/curvature(rₑ₃, t))[1:2])
end

# ╔═╡ 02d1ee46-797b-11ec-1a42-5f491c26569c
md"""We computed the above illustration using $3$ dimensions (hence the use of `[1:2]...`) as the curvature formula is easier to express. Recall, the curvature also appears in the [Frenet-Serret](https://en.wikipedia.org/wiki/Frenet%E2%80%93Serret_formulas) formulas: $d\hat{T}/ds = \kappa \hat{N}$ and $d\hat{N}/ds = -\kappa \hat{T}+ \tau \hat{B}$. In a planar curve, as under consideration, the binormal is $\vec{0}$. This allows the computation of $\vec\beta(s)'$:
"""

# ╔═╡ 02d1ee5a-797b-11ec-3102-433d224f69ad
md"""```math
\begin{align}
\vec{\beta}' &= \frac{d(\vec\gamma + (1/k) \hat{N})}{dt}\\
&= \hat{T} + (-\frac{k'}{k^2}\hat{N} + \frac{1}{k} \hat{N}')\\
&= \hat{T} - \frac{k'}{k^2}\hat{N} + \frac{1}{k} (-\kappa \hat{T})\\
&= - \frac{k'}{k^2}\hat{N}.
\end{align}
```
"""

# ╔═╡ 02d1ee78-797b-11ec-08ce-e31a121a4b0c
md"""We see $\vec\beta'$ is zero (the curve is non-regular) when $\kappa'(s) = 0$. The curvature changes from increasing to decreasing, or vice versa at each of the $4$ crossings of the major and minor axes - there are $4$ non-regular points, and we see $4$ cusps in the evolute.
"""

# ╔═╡ 02d1ee96-797b-11ec-1207-55938283c603
md"""The curve parameterized by $\vec{r}(t) = 2(1 - \cos(t)) \langle \cos(t), \sin(t)\rangle$ over $[0,2\pi]$ is cardiod. It is formed by rolling a circle of radius $r$ around another similar sized circle. The following graphically shows the evolute is a smaller cardiod (one-third the size). For fun, the evolute of the evolute is drawn:
"""

# ╔═╡ 02d1f45e-797b-11ec-1913-6bca89bea7d1
function evolute(r)
    t -> r(t) + 1/curvature(r, t) * Normal(r, t)
end

# ╔═╡ 02d1fc9c-797b-11ec-1acc-77c91feb32ea
begin
	r(t) = 2*(1 - cos(t)) * [cos(t), sin(t), 0]
	
	plot(legend=false, aspect_ratio=:equal)
	plot_parametric!(0..2pi, t -> r(t)[1:2])
	plot_parametric!(0..2pi, t -> evolute(r)(t)[1:2])
	plot_parametric!(0..2pi, t -> ((evolute∘evolute)(r)(t))[1:2])
end

# ╔═╡ 02d1fcbc-797b-11ec-2fba-112ce8de0aa2
md"""---
"""

# ╔═╡ 02d26736-797b-11ec-2bd8-a5bcbc51160b
md"""If $\vec\beta$ is *the* **evolute** of $\vec\gamma$, then $\vec\gamma$ is *an* **involute** of $\beta$. For a given curve, there is a parameterized family of involutes. While this definition has a pleasing self-referentialness, it doesn't have an immediately clear geometric interpretation. For that, consider the image of a string of fixed length $a$ attached to the curve $\vec\gamma$ at some point $t_0$. As this curve wraps around the curve traced by $\vec\gamma$ it is held taut so that it makes a tangent at the point of contact. The end of the string will trace out a curve and this is the trace of an *involute*.
"""

# ╔═╡ 02d26eac-797b-11ec-01a5-f167514eae70
let
	r(t) = [t, cosh(t)]
	t0, t1 = -2, 0
	a = t1
	
	beta(r, t) = r(t) - Tangent(r, t) * quadgk(t -> norm(r'(t)), a, t)[1]
	
	p = plot_parametric(-2..2, r, legend=false)
	plot_parametric!(t0..t1, t -> beta(r, t))
	for t in range(t0,-0.2, length=4)
	    arrow!(r(t), -Tangent(r, t) * quadgk(t -> norm(r'(t)), a, t)[1])
	    scatter!(unzip([r(t)])...)
	end
	p
end

# ╔═╡ 02d26efc-797b-11ec-079d-b7d74a843632
md"""This lends itself to this mathematical description, if $\vec\gamma(t)$ parameterizes the planar curve, then an involute for $\vec\gamma(t)$ is described by:
"""

# ╔═╡ 02d26f18-797b-11ec-391b-ab4e17589332
md"""```math
\vec\beta(t) = \vec\gamma(t) + \left(a - \int_{t_0}^t \| \vec\gamma'(t)\| dt) \hat{T}(t)\right),
```
"""

# ╔═╡ 02d26f6a-797b-11ec-3e4c-81520e18a27e
md"""where $\hat{T}(t) = \vec\gamma'(t)/\|\vec\gamma'(t)\|$ is the unit tangent vector. The above uses two parameters ($a$ and $t_0$), but only one is needed, as there is an obvious redundancy (a point can *also* be expressed by $t$ and the shortened length of string). [Wikipedia](https://en.wikipedia.org/wiki/Involute) uses this definition for $a$ and $t$ values in an interval $[t_0, t_1]$:
"""

# ╔═╡ 02d26f7e-797b-11ec-3d4d-ddf6fd77e7d8
md"""```math
\vec\beta_a(t) = \vec\gamma(t) - \frac{\vec\gamma'(t)}{\|\vec\gamma'(t)\|}\int_a^t \|\vec\gamma'(t)\| dt.
```
"""

# ╔═╡ 02d26f9c-797b-11ec-10f0-ad4b95a61323
md"""If $\vec\gamma(s)$ is parameterized by arc length, then this simplifies quite a bit, as the unit tangent is just $\vec\gamma'(s)$ and the remaining arc length just $(s-a)$:
"""

# ╔═╡ 02d26fb0-797b-11ec-1538-d3cf11097cd8
md"""```math
\begin{align*}
\vec\beta_a(s) &= \vec\gamma(s) - \vec\gamma'(s) (s-a) \\
&=\vec\gamma(s) - \hat{T}_{\vec\gamma}(s)(s-a).\quad (a \text{ is the arc-length parameter})
\end{align*}
```
"""

# ╔═╡ 02d26fbc-797b-11ec-0440-71cd24664d78
md"""With this characterization, we see several properties:
"""

# ╔═╡ 02d270fa-797b-11ec-0824-3f3785c69743
md"""  * From $\vec\beta_a'(s) = \hat{T}(s) - (\kappa(s) \hat{N}(s) (s-a) + \hat{T}(s)) = -\kappa_{\vec\gamma}(s) \cdot (s-a) \cdot \hat{N}_{\vec\gamma}(s)$,  the involute is *not* regular at $s=a$, as its derivative is zero.
  * As $\vec\beta_a(s) = \vec\beta_0(s) + a\hat{T}(s)$, the family of curves is parallel.
  * The evolute of $\vec\beta_a(s)$, $s$ the arc-length parameter of $\vec\gamma$, can be shown to be $\vec\gamma$. This requires more work:
"""

# ╔═╡ 02d2710e-797b-11ec-3ebd-8b6fc6a01e82
md"""The evolute for $\vec\beta_a(s)$ is:
"""

# ╔═╡ 02d27118-797b-11ec-22c6-4f8ae145320b
md"""```math
\vec\beta_a(s) + \frac{1}{\kappa_{\vec\beta_a}(s)}\hat{N}_{\vec\beta_a}(s).
```
"""

# ╔═╡ 02d2712c-797b-11ec-3496-1bccecc6a65e
md"""In the following we show that:
"""

# ╔═╡ 02d27136-797b-11ec-0a8f-eb37e1e718e7
md"""```math
\begin{align}
\kappa_{\vec\beta_a}(s) &= 1/(s-a),\\
\hat{N}_{\vec\beta_a}(s) &= \hat{T}_{\vec\beta_a}'(s)/\|\hat{T}_{\vec\beta_a}'(s)\| = -\hat{T}_{\vec\gamma}(s).
\end{align}
```
"""

# ╔═╡ 02d2714a-797b-11ec-1869-cbe75b9395fe
md"""The first shows in a different way that when $s=a$ the curve is not regular, as the curvature fails to exists. In the above figure, when the involute touches $\vec\gamma$, there will be a cusp.
"""

# ╔═╡ 02d2715e-797b-11ec-0efb-9171d0fe0224
md"""With these two identifications and using $\vec\gamma'(s) = \hat{T}_{\vec\gamma(s)}$, we have the evolute simplifies to
"""

# ╔═╡ 02d27172-797b-11ec-2764-0b1834118555
md"""```math
\begin{align*}
\vec\beta_a(s) + \frac{1}{\kappa_{\vec\beta_a}(s)}\hat{N}_{\vec\beta_a}(s)
&=
\vec\gamma(s) + \vec\gamma'(s)(s-a)  + \frac{1}{\kappa_{\vec\beta_a}(s)}\hat{N}_{\vec\beta_a}(s) \\
&=
\vec\gamma(s) + \hat{T}_{\vec\gamma}(s)(s-a) + \frac{1}{1/(s-a)} (-\hat{T}_{\vec\gamma}(s)) \\
&= \vec\gamma(s).
\end{align*}
```
"""

# ╔═╡ 02d27190-797b-11ec-1899-f31d36a115c4
md"""That is the evolute an an involute of $\vec\gamma(s)$ is $\vec\gamma(s)$.
"""

# ╔═╡ 02d2719a-797b-11ec-1f7c-534a1984179f
md"""We have:
"""

# ╔═╡ 02d271ae-797b-11ec-1127-bf68a5e8b13d
md"""```math
\begin{align}
\beta_a(s) &= \vec\gamma - \vec\gamma'(s)(s-a)\\
\beta_a'(s) &= -\kappa_{\vec\gamma}(s)(s-a)\hat{N}_{\vec\gamma}(s)\\
\beta_a''(s) &= (-\kappa_{\vec\gamma}(s)(s-a))' \hat{N}_{\vec\gamma}(s) + (-\kappa_{\vec\gamma}(s)(s-a))(-\kappa_{\vec\gamma}\hat{T}_{\vec\gamma}(s)),
\end{align}
```
"""

# ╔═╡ 02d271d6-797b-11ec-22f9-c35104072bba
md"""the last line by the Frenet-Serret  formula for *planar* curves which show $\hat{T}'(s) = \kappa(s) \hat{N}$ and $\hat{N}'(s) = -\kappa(s)\hat{T}(s)$.
"""

# ╔═╡ 02d271e8-797b-11ec-2e67-5fa7a89c7d28
md"""To compute the curvature of $\vec\beta_a$, we need to compute both:
"""

# ╔═╡ 02d271f4-797b-11ec-3f28-5fe38228774d
md"""```math
\begin{align}
\| \vec\beta' \|^3 &= |\kappa^3 (s-a)^3|\\
\| \vec\beta' \times \vec\beta'' \| &= |\kappa(s)^3 (s-a)^2|,
\end{align}
```
"""

# ╔═╡ 02d27212-797b-11ec-1ae8-07ef7f57e4c6
md"""the last line using both $\hat{N}\times\hat{N} = \vec{0}$ and $\|\hat{N}\times\hat{T}\| = 1$. The curvature then is $\kappa_{\vec\beta_a}(s) = 1/(s-a)$.
"""

# ╔═╡ 02d27230-797b-11ec-1d08-11251009f320
md"""Using the formula for $\vec\beta'$ above, we get $\hat{T}_\beta(s)=\hat{N}_{\vec\gamma}(s)$ so $\hat{T}_\beta(s)' = -\kappa_{\vec\gamma}(s) \hat{T}_{\vec\gamma}(s)$ with unit vector just $\hat{N}_{\vec\beta_a} = -\hat{T}_{\vec\gamma}(s)$.
"""

# ╔═╡ 02d2723a-797b-11ec-0347-61d7f7b77f29
md"""---
"""

# ╔═╡ 02d2724e-797b-11ec-228b-73470e9d3a36
md"""Show that *an* involute of the cycloid $\vec{r}(t) = \langle t - \sin(t), 1 - \cos(t) \rangle$ is also a cycloid. We do so graphically:
"""

# ╔═╡ 02d279ce-797b-11ec-1eca-77228dc847ed
let
	r(t) = [t - sin(t), 1 - cos(t)]
	## find *involute*: r - r'/|r'| * int(|r'|, a, t)
	t0, t1, a = 2PI, PI, PI
	@syms t::real
	rp = diff.(r(t), t)
	speed = 2sin(t/2)
	
	ex = r(t) - rp/speed * integrate(speed, a, t)
	
	plot_parametric(0..4pi, r, legend=false)
	plot_parametric!(0..4pi, u -> SymPy.N.(subs.(ex, t .=> u)))
end

# ╔═╡ 02d27a00-797b-11ec-145b-b74587be5d24
md"""The expression `ex` is secretly `[t + sin(t), 3 + cos(t)]`, another cycloid.
"""

# ╔═╡ 02d27a1e-797b-11ec-09d6-d96d13c8aa28
md"""##### Example: Tubular surface
"""

# ╔═╡ 02d27a50-797b-11ec-1c74-c5112eb032e7
md"""This last example comes from a collection of several [examples](https://github.com/empet/3D-Viz-with-PlotlyJS.jl/blob/main/5-Tubular-surface.ipynb) provided by Discourse user `@empet` to illustrate `plotlyjs`. We adopt it to `Plots` with some minor changes below.
"""

# ╔═╡ 02d27a82-797b-11ec-30d2-99567f1093a2
md"""The task is to illustrate a space curve, $c(t)$, using a tubular surface. At each time point $t$, assume the curve has tangent, $e_1$; normal, $e_2$; and binormal, $e_3$. (This assumes the defining derivatives exist and are non-zero and the cross product in the torsion is non zero.) The tubular surface is a circle of radius $\epsilon$ in the plane determined by the normal and binormal. This curve would be parameterized by $r(t,u) = c(t) + \epsilon (e_2(t) \cdot \cos(u) + e_3(t) \cdot \sin(u))$ for varying $u$.
"""

# ╔═╡ 02d27aa0-797b-11ec-0c97-5d878475983e
md"""The Frenet-Serret equations setup a system of differential equations driven by the curvature and torsion. We use the `DifferentialEquations` package to solve this equation for two specific functions and a given initial condition. The equations when expanded into coordinates become $12$ different equations:
"""

# ╔═╡ 02d2a5c0-797b-11ec-18dc-eb5f62f1426a
# e₁, e₂, e₃, (x,y,z)
function Frenet_eq!(du, u, p, s)  #system of ODEs
    κ, τ = p
    du[1] =  κ(s) * u[4]               # e₁′ = κ ⋅ e₂
    du[2] =  κ(s) * u[5]
    du[3] =  κ(s) * u[6]
    du[4] = -κ(s) * u[1] + τ(s) * u[7] # e₂′ = - κ ⋅ e₁ + τ ⋅ e₃
    du[5] = -κ(s) * u[2] + τ(s) * u[8]
    du[6] = -κ(s) * u[3] + τ(s) * u[9]
    du[7] = -τ(s) * u[4]               # e₃′ = - τ ⋅ e₂
    du[8] = -τ(s) * u[5]
    du[9] = -τ(s) * u[6]
    du[10] = u[1]                      # c′ = e₁
    du[11] = u[2]
    du[12] = u[3]
end

# ╔═╡ 02d2a5fa-797b-11ec-2ac8-8b1489b1459a
md"""The last set of equations describe the motion of the spine. It follows from specifying the tangent to the curve is $e_1$, as desired; it is parameterized by arc length, as $\mid c'(t) \mid = 1$.
"""

# ╔═╡ 02d2a61a-797b-11ec-2f58-f38d4d2a506c
md"""Following the example of `@empet`, we define a curvature function and torsion function, the latter a constant:
"""

# ╔═╡ 02d2adcc-797b-11ec-1e27-87f5e069b13c
begin
	κ(s) = 3 * sin(s/10) * sin(s/10)
	τ(s) = 0.35
end

# ╔═╡ 02d2ade0-797b-11ec-2866-9724f89a071e
md"""The initial condition and time span are set with:
"""

# ╔═╡ 02d2b6b4-797b-11ec-30c5-61ef53cf5309
begin
	e₁₀, e₂₀, e₃₀ = [1,0,0], [0,1,0], [0,0,1]
	u₀ = [0, 0, 0]
	u0 = vcat(e₁₀, e₂₀, e₃₀, u₀) # initial condition for the system of ODE
	t_span = (0.0,  150.0)          # time interval for solution
end

# ╔═╡ 02d2b6c8-797b-11ec-262d-8f1139548593
md"""With this set up, the problem can be solved:
"""

# ╔═╡ 02d2bbe4-797b-11ec-0358-cff080af3c19
begin
	prob = ODEProblem(Frenet_eq!, u0, t_span, (κ, τ))
	sol = solve(prob, Tsit5());
end

# ╔═╡ 02d2bc0e-797b-11ec-22d1-b90d7aac64d8
md"""The "spine" is the center axis of the tube and is the $10$th, $11$th, and $12$th coordinates:
"""

# ╔═╡ 02d2c028-797b-11ec-2044-3f8b78f19159
spine(t) = sol(t)[10:12]

# ╔═╡ 02d2c04e-797b-11ec-22d4-c548fab26f11
md"""The tangent, normal, and binormal can be similarly defined using the other $9$ indices:
"""

# ╔═╡ 02d2c5b4-797b-11ec-37da-e33f9c1b3735
begin
	e₁(t) = sol(t)[1:3]
	e₂(t) = sol(t)[4:6]
	e₃(t) = sol(t)[7:9]
end

# ╔═╡ 02d2c5d2-797b-11ec-1393-9b407ce4928e
md"""We fix a small time range and show the trace of the spine and the frame at a single point in time:
"""

# ╔═╡ 02d2cad2-797b-11ec-123d-8739dca25fac
begin
	a_0, b_0 = 50, 60
	ts_0 = range(a_0, b_0, length=251)
	
	t_0 = (a_0 + b_0) / 2
	ϵ = 1/5
	
	plot_parametric(a_0..b_0, spine)
	
	arrow!(spine(t_0), e₁(t_0))
	arrow!(spine(t_0), e₂(t_0))
	arrow!(spine(t_0), e₃(t_0))
	
	r_0(t, θ) = spine(t) + ϵ * (e₂(t)*cos(θ) + e₃(t)*sin(θ))
	plot_parametric!(0..2pi, θ -> r_0(t_0, θ))
end

# ╔═╡ 02d2cb04-797b-11ec-3325-1bb830fdf8e5
md"""The `ϵ` value determines the radius of the tube; we see it above as the radius of the drawn circle. The function `r` for a fixed `t` traces out such a circle centered at a point on the spine. For a fixed `θ`, the function `r` describes a line on the surface of the tube paralleling the spine.
"""

# ╔═╡ 02d2cb0e-797b-11ec-1c90-e3fe07918733
md"""The tubular surface is now ready to be rendered along the entire time span using a pattern for parametrically defined surfaces:
"""

# ╔═╡ 02d2d0a4-797b-11ec-1b9e-7d340e2cf2d8
let
	ts = range(t_span..., length=1001)
	θs = range(0, 2pi, length=100)
	surface(unzip(r_0.(ts, θs'))...)
end

# ╔═╡ 02d2d0e0-797b-11ec-3a94-8750ec6a87d4
md"""## Questions
"""

# ╔═╡ 02d57180-797b-11ec-1aae-191f0cf66c6f
md"""###### Question
"""

# ╔═╡ 02d5720a-797b-11ec-1995-8d5bd68a8ed8
md"""A cycloid is formed by pushing a wheel on a surface without slipping. The position of a fixed point on the outer rim of the wheel traces out the cycloid. Suppose the wheel has radius $R$ and the initial position of the point is at the bottom, $(0,0)$. Let $t$ measure angle measurement, in radians. Then the point of contact of the wheel will be at $Rt$, as that is the distance the wheel will have rotated. That is, the hub of the wheel will move according to $\langle Rt,~ R\rangle$. Relative to the hub, the point on the rim will have coordinates $\langle -R\sin(t), -R\cos(t) \rangle$, so the superposition gives:
"""

# ╔═╡ 02d5723c-797b-11ec-0a1f-4969f4b5b8e1
md"""```math
\vec{r}(t) = \langle Rt - R\sin(t), R - R\cos(t) \rangle.
```
"""

# ╔═╡ 02d5725a-797b-11ec-30f2-2f1d1b061620
md"""What is the position at $t=\pi/4$?
"""

# ╔═╡ 02d57da4-797b-11ec-3573-8d0b5c47432e
let
	choices = [
	q"[0.0782914, 0.292893 ]",
	q"[0.181172, 0.5]",
	q"[0.570796, 1.0]"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d57de0-797b-11ec-2d01-3b60a35f1e96
md"""And the position at $\pi/2$?
"""

# ╔═╡ 02d5852c-797b-11ec-1509-a579f526770a
let
	choices = [
	q"[0.0782914, 0.292893 ]",
	q"[0.181172, 0.5]",
	q"[0.570796, 1.0]"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 02d58556-797b-11ec-1af0-a77217b4a0e1
md"""###### Question
"""

# ╔═╡ 02d585a6-797b-11ec-2790-e5864c47ab65
md"""Suppose instead of keeping track of a point on the outer rim of the wheel, a point a distance $r < R$ from the hub is chosen in the above description of a cycloid (a [Curtate](http://mathworld.wolfram.com/CurtateCycloid.html) cycloid). If we start at $\langle 0,~ R-r \rangle$, what will be the position at $t$?
"""

# ╔═╡ 02d5903a-797b-11ec-2947-93a099b0984b
let
	choices = [
	" ``\\langle Rt - r\\sin(t),~ R - r\\cos(t) \\rangle``",
	" ``\\langle Rt - R\\sin(t),~ R - R\\cos(t) \\rangle``",
	" ``\\langle -r\\sin(t),~ -r\\cos(t) \\rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d59050-797b-11ec-282b-5f5506f26665
md"""###### Question
"""

# ╔═╡ 02d59078-797b-11ec-2e5a-95f6ca8a3f53
md"""For the  cycloid $\vec{r}(t) = \langle t - \sin(t),~ 1 - \cos(t) \rangle$, find a simplified expression for $\| \vec{r}'(t)\|$.
"""

# ╔═╡ 02d59a64-797b-11ec-187a-4f0b99840624
let
	choices = [
	    " ``\\sqrt{2 - 2\\cos(t)}``",
	    " ``1``",
	    " ``1 - \\cos(t)``",
	    " ``1 + \\cos(t) + \\cos(2t)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d59a84-797b-11ec-069b-a5c9d65977d5
md"""###### Question
"""

# ╔═╡ 02d59aaa-797b-11ec-044e-9132c4a173db
md"""The cycloid $\vec{r}(t) = \langle t - \sin(t),~ 1 - \cos(t) \rangle$ has a formula for the arc length from $0$ to $t$ given by: $l(t) = 4 - 4\cos(t/2)$.
"""

# ╔═╡ 02d59ac8-797b-11ec-2f68-a1911564a82e
md"""Plot the following two equations over $[0,8]$ which are a reparameterization of the cycloid by $l^{-1}(t)$.
"""

# ╔═╡ 02d5a266-797b-11ec-28e2-f3e11fecc093
let
	γ(s) = 2 * acos(1-s/4)
	x1(s) = γ(s) - sin(γ(s))
	y1(s) = 1 - cos(γ(s))
end

# ╔═╡ 02d5a27a-797b-11ec-3508-f921f5ca0ebf
md"""How many arches of the cycloid are traced out?
"""

# ╔═╡ 02d5a702-797b-11ec-0ae3-f1e84a2b0adf
let
	radioq(1:3, 1, keep_order=true)
end

# ╔═╡ 02d5a720-797b-11ec-1f90-cf20f616c154
md"""###### Question
"""

# ╔═╡ 02d5a73e-797b-11ec-0fec-b7e0d2303545
md"""Consider the cycloid  $\vec{r}(t) = \langle t - \sin(t),~ 1 - \cos(t) \rangle$
"""

# ╔═╡ 02d5a752-797b-11ec-3e9f-5b1903e41289
md"""What is the derivative at $t=\pi/2$?
"""

# ╔═╡ 02d5ae8c-797b-11ec-0969-f3b64893443e
let
	choices = [
	q"[1,1]",
	q"[2,0]",
	q"[0,0]"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d5aebe-797b-11ec-352c-0f1dbccb64a2
md"""What is the derivative at $t=\pi$?
"""

# ╔═╡ 02d5b4b8-797b-11ec-0298-c9d9798a81f6
let
	choices = [
	q"[1,1]",
	q"[2,0]",
	q"[0,0]"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 02d5b4d8-797b-11ec-167c-0dcfc2c9cda4
md"""###### Question
"""

# ╔═╡ 02d5b4fe-797b-11ec-24c8-9bc20c8d7b5d
md"""Consider the circle $\vec{r}(t) = R \langle \cos(t),~ \sin(t) \rangle$, $R > 0$. Find the norm of $\vec{r}'(t)$:
"""

# ╔═╡ 02d5bc4c-797b-11ec-1ca4-fdef80396970
let
	choices = [
	    " ``1``",
	    " ``1/R``",
	    " ``R``",
	    " ``R^2``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 02d5bc60-797b-11ec-065d-3fbbec405e2d
md"""###### Question
"""

# ╔═╡ 02d5bc7e-797b-11ec-04f4-eb6906275513
md"""The curve described by $\vec{r}(t) = \langle 10t,~ 10t - 16t^2\rangle$ models the flight of an arrow. Compute the length traveled from when it is launched to when it returns to the ground.
"""

# ╔═╡ 02d5c0ac-797b-11ec-0875-e5db32796931
let
	x(t) = 10t
	y(t) = 10t - 16t^2
	a,b = sort(find_zeros(y, -10, 10))
	f(x,y) = 1
	val, _ = quadgk(t -> f(x(t), y(t)) * sqrt(D(x)(t)^2 + D(y)(t)^2), a, b)
	numericq(val)
end

# ╔═╡ 02d5c0d4-797b-11ec-09ba-11c83796b21a
md"""##### Question
"""

# ╔═╡ 02d5c0fc-797b-11ec-26be-87210f603b3a
md"""Let $\vec{r}(t) = \langle t, t^2 \rangle$ describe a parabola. What is the arc length between $0 \leq t \leq 1$? First, what is a formula for the speed ($\| \vec{r}'(t)\|$)?
"""

# ╔═╡ 02d5ef00-797b-11ec-1ae8-3939580eca58
let
	choices = [
	    " ``\\sqrt{1 + 4t^2}``",
	    " ``1 + 4t^2``",
	    " ``1``",
	    " ``t + t^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d5ef28-797b-11ec-2847-f705388d89c3
md"""Numerically find the arc length.
"""

# ╔═╡ 02d5f98c-797b-11ec-13fa-6931c255d836
let
	val,err = quadgk(t -> (1 + 4t^2)^(1/2), 0, 1)
	numericq(val)
end

# ╔═╡ 02d5f9aa-797b-11ec-1341-a15d33549624
md"""##### Question
"""

# ╔═╡ 02d5f9dc-797b-11ec-2c27-859e47e8ee33
md"""Let $\vec{r}(t) = \langle t, t^2 \rangle$ describe a parabola. What is the curvature of $\vec{r}(t)$ at $t=0$?
"""

# ╔═╡ 02d5fde2-797b-11ec-3cfe-47cb9fbe9d6f
let
	@syms t::positive
	rt = [t, t^2, 0]
	rp = diff.(rt, t)
	rpp = diff.(rt, t, t)
	kappa =  norm(rp × rpp) / norm(rp)^3
	#val = N(kappa(t=>0)) #2
	val = 2
	numericq(val)
end

# ╔═╡ 02d5fe0a-797b-11ec-0643-87cb12535942
md"""The curvature at $1$ will be
"""

# ╔═╡ 02d60738-797b-11ec-05b1-736e1194a783
let
	choices = [
	"greater than the curvature at ``t=0``",
	"less than the curvature at ``t=0``",
	"the same as the curvature at ``t=0``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 02d60760-797b-11ec-0d19-d9ed69465631
md"""The curvature as $t\rightarrow \infty$ will be
"""

# ╔═╡ 02d60da0-797b-11ec-2cfc-d3bc03007748
let
	choices = [
	    " ``0``",
	    " ``\\infty``",
	    " ``1``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d60dc8-797b-11ec-03c4-3b5b2a80cd83
md"""---
"""

# ╔═╡ 02d60dfa-797b-11ec-08af-a10ff2c0f0d5
md"""Now, if we have a more general parabola by introducing a parameter $a>0$: $\vec{r}(t) = \langle t, a\cdot t^2 \rangle$, What is the curvature of $\vec{r}(t)$ at $t=0$?
"""

# ╔═╡ 02d6151e-797b-11ec-3764-5b82f1e1c5e3
let
	choices = [
	    " ``2a``",
	    " ``2/a``",
	    " ``2``",
	    " ``1``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6153e-797b-11ec-300c-21508134389b
md"""###### Question
"""

# ╔═╡ 02d615c0-797b-11ec-2172-3f02073c8a8a
md"""Projectile motion with constant acceleration is expressed parametrically by $\vec{x}(t) = \vec{x}_0 + \vec{v}_0 t + (1/2) \vec{a} t^2$, where $\vec{x}_0$ and $\vec{v}_0$ are initial positions and velocity respectively. In [Strang](https://ocw.mit.edu/resources/res-18-001-calculus-online-textbook-spring-2005/textbook/MITRES_18_001_strang_12.pdf) p451, we find an example utilizing this formula to study the curve of a baseball. Place the pitcher at the origin, the batter along the $x$ axis, then a baseball thrown with spin around its $z$ axis will have acceleration in the $y$ direction in addition to the acceration due to gravity in the $z$ direction. Suppose the ball starts $5$ feet above the ground when pitched ($\vec{x}_0 = \langle 0,0, 5\rangle$), and has initial velocity $\vec{v}_0 = \langle 120, -2, 2 \rangle$. ($120$ feet per second is about $80$ miles per hour). Suppose the pitcher can produce an acceleration in the $y$ direction of $16ft/sec^2$, then $\vec{a} = \langle 0, 16, -32\rangle$ in these units. (Gravity is $9.8m/s^2$ or $32ft/s^2$.)
"""

# ╔═╡ 02d615de-797b-11ec-0a95-9b9575eb39e2
md"""The plate is $60$ feet away. How long will it take for the ball to reach the batter? (When the first component is $60$?)
"""

# ╔═╡ 02d61a52-797b-11ec-11a3-27f454b93f71
let
	x0 = [0,0,5]
	v0 = [120, -2, 2]
	a = [0, 16, -32]
	r(t) = x0 + v0*t + 1/2*a*t^2
	ans = 60/v0[1]
	numericq(ans)
end

# ╔═╡ 02d61a7a-797b-11ec-21ba-bff9e625b307
md"""At $t=1/4$ the ball is half-way to home. If the batter reads the ball at this point, where in the $y$ direction is the ball?
"""

# ╔═╡ 02d61f0c-797b-11ec-2ebb-39c0b3cbf900
let
	x0 = [0,0,5]
	v0 = [120, -2, 2]
	a = [0, 16, -32]
	r(t) = x0 + v0*t + 1/2*a*t^2
	t = 1/4
	ans = r(t)[2]
	numericq(ans)
end

# ╔═╡ 02d61f34-797b-11ec-1252-cfeff189f063
md"""At $t=1/2$ has the ball moved more than $1/2$ foot in the $y$ direction?
"""

# ╔═╡ 02d6238a-797b-11ec-07e0-8b546525052b
let
	x0 = [0,0,5]
	v0 = [120, -2, 2]
	a = [0, 16, -32]
	r(t) = x0 + v0*t + 1/2*a*t^2
	t = 1/2
	ans = abs(r(t)[2]) > 1/2
	yesnoq(ans)
end

# ╔═╡ 02d623a0-797b-11ec-003f-a9c7db84b43b
md"""###### Question
"""

# ╔═╡ 02d623d2-797b-11ec-34b9-d927ec194dd2
md"""In [Strang](https://ocw.mit.edu/resources/res-18-001-calculus-online-textbook-spring-2005/textbook/MITRES_18_001_strang_12.pdf) we see this picture describing  a curve:
"""

# ╔═╡ 02d62768-797b-11ec-12b6-d1356002461e
let
	a = 1
	
	plot(t -> 0, -2, 2,aspect_ratio=:equal, legend=false)
	plot!(t -> 2a)
	r(t) = [0, a] + a*[cos(t), sin(t)]
	plot!(unzip(r, 0, 2pi)...)
	theta = pi/3
	plot!([0, 2a/tan(theta)], [0, 2a], linestyle=:dash)
	A = [2a*cot(theta), 2a]
	B = 2a*sin(theta)^2 *[ 1/tan(theta),1]
	scatter!(unzip([A,B])...)
	plot!([B[1],A[1],A[1]], [B[2],B[2],A[2]], linestyle=:dash)
	delta = 0.2
	annotate!([(B[1],B[2]-delta,"B"),(A[1]+delta,A[2]-delta,"A")])
	r(theta) = [2a*cot(theta), 2a*sin(theta)^2 ]
	theta0 = pi/4
	plot!(unzip(r, theta0, pi-theta0)..., linewidth=3)
	P = r(theta)
	annotate!([(P[1],P[2]-delta, "P")])
end

# ╔═╡ 02d6277c-797b-11ec-2530-bb47d834e895
md"""Strang notes that the curve is called the "witch of Agnesi" after Maria Agnesi, the author of the first three-semester calculus book. (L'Hopital's book did not contain integration.)
"""

# ╔═╡ 02d627a6-797b-11ec-3646-15bde376a73b
md"""We wish to identify the parameterization. Using $\theta$ an angle in standard position, we can see that the component functions $x(\theta)$ and $y(\theta)$ may be found using trigonometric analysis.
"""

# ╔═╡ 02d627c2-797b-11ec-1282-738ff6b82c31
md"""What is the $x$ coordinate of point $A$? (Also the $x$ coordinate of $P$.)
"""

# ╔═╡ 02d630b4-797b-11ec-05c2-d3ee5d46f687
let
	choices = [
	           " ``2̧\\cot(\\theta)``",
	           " ``\\cot(\\theta)``",
	           " ``2\\tan(\\theta)``",
	           " ``\\tan(\\theta)``"
	       ]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d630da-797b-11ec-38ef-730af2ae01e7
md"""Using the polar form of a circle, the length between the origin and $B$ is given by $2\cos(\theta-\pi/2) = 2\sin(\theta)$. Using this, what is the $y$ coordinate of $B$?
"""

# ╔═╡ 02d6399c-797b-11ec-28f8-41f8f0fa3904
let
	choices = [
	    " ``2\\sin^2(\\theta)``",
	    " ``2\\sin(\\theta)``",
	    " ``2``",
	    " ``\\sin(\\theta)``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 02d639c4-797b-11ec-18b6-5b10366cc331
md"""###### Question
"""

# ╔═╡ 02d639ee-797b-11ec-31e9-09c3788adff8
md"""Let $n > 0$, $\vec{r}(t) = \langle t^(n+1),t^n\rangle$. Find the speed, $\|\vec{r}'(t)\|$.
"""

# ╔═╡ 02d6439c-797b-11ec-354f-1391f1f70d9e
let
	choices = [
	    " ``\\frac{\\sqrt{n^{2} t^{2 n} + t^{2 n + 2} \\left(n + 1\\right)^{2}}}{t}``",
	    " ``t^n + t^{n+1}``",
	    " ``\\sqrt{n^2 + t^2}``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 02d643c2-797b-11ec-2024-537e73219f5f
md"""For $n=2$, the arc length of $\vec{r}$ can be found exactly. What is the arc-length between $0 \leq t \leq a$?
"""

# ╔═╡ 02d64e14-797b-11ec-28ba-25cdfbca1fac
let
	choices = [
	    " ``\\frac{a^{2} \\sqrt{9 a^{2} + 4}}{3} + \\frac{4 \\sqrt{9 a^{2} + 4}}{27} - \\frac{8}{27}``",
	    " ``\\frac{2 a^{\\frac{5}{2}}}{5}``",
	    " ``\\sqrt{a^2 + 4}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d64e32-797b-11ec-3a34-6522108254c9
md"""###### Question
"""

# ╔═╡ 02d64e64-797b-11ec-3fbd-1de570d2cc9e
md"""The [astroid](http://www-history.mcs.st-and.ac.uk/Curves/Astroid.html) is one of the few curves with an exactly computable arc-length. The curve is parametrized by $\vec{r}(t) = \langle a\cos^3(t), a\sin^3(t)\rangle$. For $a=1$ find the arc-length between $0 \leq t \leq \pi/2$.
"""

# ╔═╡ 02d655e4-797b-11ec-373f-e339ebdda465
let
	choices = [
	    " ``\\sqrt{2}``",
	    " ``3/2``",
	    " ``\\pi/2``",
	    " ``2``"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 02d655f8-797b-11ec-2cc8-4145911a3762
md"""###### Question
"""

# ╔═╡ 02d65bca-797b-11ec-0f4c-dd7d2bbe7b9c
let
	t0, t1 = pi/12, pi/3
	tspan = (t0, t1)  # time span to consider
	
	a = 1
	r(theta) = -cos(theta) + 4*2cos(theta)*sin(theta)^2
	F(t) = r(t) * [cos(t), sin(t)]
	p = (a, F)      # combine parameters
	
	B0 = F(0) - [0, a]  # some initial position for the back
	prob = ODEProblem(bicycle, B0, tspan, p)
	
	out = solve(prob, reltol=1e-6, Tsit5())
	
	plt = plot(unzip(F, t0, t1)..., legend=false, color=:red)
	plot!(plt, unzip(t->out(t),  t0, t1)..., color=:blue)
end

# ╔═╡ 02d65bf2-797b-11ec-1fc6-e5eb73a90017
md"""Let $F$ and $B$ be pictured above. Which is the red curve?
"""

# ╔═╡ 02d662f2-797b-11ec-11d8-07b0e4258d40
let
	choices = [
	"The front wheel",
	"The back wheel"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 02d66320-797b-11ec-1931-f98ef237c214
md"""###### Question
"""

# ╔═╡ 02d668a4-797b-11ec-1d7d-056f735047db
let
	t0, t1 = 0.0, pi/3
	tspan = (t0, t1)  # time span to consider
	
	a = 1
	r(t) = 3a * cos(2t)cos(t)
	F(t) = r(t) * [cos(t), sin(t)]
	p = (a, F)      # combine parameters
	
	B0 = F(0) - [0, a]  # some initial position for the back
	prob = ODEProblem(bicycle, B0, tspan, p)
	
	out = solve(prob, reltol=1e-6, Tsit5())
	
	plt = plot(unzip(F, t0, t1)..., legend=false, color=:blue)
	plot!(plt, unzip(t->out(t),  t0, t1)..., color=:red)
end

# ╔═╡ 02d668d6-797b-11ec-2680-4dec005c13ff
md"""Let $F$ and $B$ be pictured above. Which is the red curve?
"""

# ╔═╡ 02d66e76-797b-11ec-0efd-3d1be79006eb
let
	choices = [
	"The front wheel",
	"The back wheel"
	]
	ans=2
	radioq(choices, ans)
end

# ╔═╡ 02d66e92-797b-11ec-19e7-e564bb90b306
md"""###### Question
"""

# ╔═╡ 02d66ebc-797b-11ec-3236-45f006c1e936
md"""Let $\vec{\gamma}(s)$ be a parameterization of a curve by arc length and $s(t)$ some continuous increasing function of $t$. Then $\vec{\gamma} \circ s$ also parameterizes the curve. We have
"""

# ╔═╡ 02d66ee4-797b-11ec-2d5c-7d4ae78e4053
md"""```math
\text{velocity}  = \frac{d (\vec{\gamma} \circ s)}{dt} = \frac{d\vec{\gamma}}{ds} \frac{ds}{dt} = \hat{T} \frac{ds}{dt}.
```
"""

# ╔═╡ 02d66ef8-797b-11ec-23d4-891a6dd37b7c
md"""Continuing with a second derivative
"""

# ╔═╡ 02d66f04-797b-11ec-068f-9dd590d35054
md"""```math
\text{acceleration} = \frac{d^2(\vec{\gamma}\circ s)}{dt^2} =
\frac{d\hat{T}}{ds} \frac{ds}{dt} \frac{ds}{dt} + \hat{T} \frac{d^2s}{dt^2} = \frac{d^2s}{dt^2}\hat{T} + \kappa (\frac{ds}{dt})^2 \hat{N},
```
"""

# ╔═╡ 02d66f16-797b-11ec-3519-2b6710e49268
md"""Using $d\hat{T}{ds} = \kappa\hat{N}$ when parameterized by arc length.
"""

# ╔═╡ 02d66f3e-797b-11ec-33bd-bd969854ba68
md"""This expresses the acceleration in terms of the tangential part and the normal part. [Strang](https://ocw.mit.edu/resources/res-18-001-calculus-online-textbook-spring-2005/textbook/MITRES_18_001_strang_12.pdf) views this in terms of driving where the car motion is determined by the gas pedal and the brake pedal only giving acceleration in the $\hat{T}$ direction) and the steering wheel (giving acceleration in the $\hat{N}$ direction).
"""

# ╔═╡ 02d66f52-797b-11ec-00af-017c8a79330f
md"""If a car is on a straight road, then $\kappa=0$. Is the acceleration along the $\hat{T}$ direction or the $\hat{N}$ direction?
"""

# ╔═╡ 02d675f6-797b-11ec-2fbf-ad07f0c9816c
let
	choices = [
	    "The ``\\hat{T}`` direction",
	    "The ``\\hat{N}`` direction"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6761e-797b-11ec-0331-e1f58d9cda1a
md"""Suppose no gas or brake is applied for a duration of time. The tangential acceleration will be $0$. During this time, which of these must  be $0$?
"""

# ╔═╡ 02d67d62-797b-11ec-2161-979dc98ef832
let
	choices = [
	    " ``\\vec{\\gamma} \\circ s``",
	    " ``ds/dt``",
	    " ``d^2s/dt^2``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 02d67d74-797b-11ec-3da9-8d2ccbaf52cf
md"""In going around a corner (with non-zero curvature), which is true?
"""

# ╔═╡ 02d693e2-797b-11ec-0895-b3ca5852d763
let
	choices = [
	"The acceleration in the normal direction depends on both the curvature and the speed (``ds/dt``)",
	"The acceleration in the normal direction depends only on the curvature and not the speed (``ds/dt``)",
	"The acceleration in the normal direction depends only on the speed (``ds/dt``) and not the curvature"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d69428-797b-11ec-300c-5755160f965a
md"""###### Question
"""

# ╔═╡ 02d6945a-797b-11ec-0eef-af6aa9c6eef6
md"""The evolute comes from the formula $\vec\gamma(T) - (1/\kappa(t)) \hat{N}(t)$. For hand computation, this formula can be explicitly given by two components $\langle X(t), Y(t) \rangle$ through:
"""

# ╔═╡ 02d69478-797b-11ec-1f38-01537a9b8406
md"""```math
\begin{align}
r(t) &= x'(t)^2 + y'(t)^2\\
k(t) &= x'(t)y''(t) - x''(t) y'(t)\\
X(t) &= x(t) - y'(t) r(t)/k(t)\\
Y(t) &= x(t) + x'(t) r(t)/k(t)
\end{align}
```
"""

# ╔═╡ 02d69494-797b-11ec-3245-e7c948c8296f
md"""Let $\vec\gamma(t) = \langle t, t^2 \rangle = \langle x(t), y(t)\rangle$ be a parameterization of a parabola.
"""

# ╔═╡ 02d695e0-797b-11ec-02f6-955d2f650807
md"""  * Compute $r(t)$
"""

# ╔═╡ 02d6a17a-797b-11ec-04a7-9304d8b178fd
let
	choices = [
	    " ``1 + 4t^2``",
	    " ``1 - 4t^2``",
	    " ``1 + 2t``",
	    " ``1 - 2t``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6a21a-797b-11ec-02ed-7d52cc5a1ef6
md"""  * Compute $k(t)$
"""

# ╔═╡ 02d6aa94-797b-11ec-1065-1136626da55d
let
	choices = [
	    " ``2``",
	    " ``-2``",
	    " ``8t``",
	    " ``-8t``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6ab02-797b-11ec-0d78-4b967a72650e
md"""  * Compute $X(t)$
"""

# ╔═╡ 02d6b4ee-797b-11ec-077e-936c48d9f23b
let
	choices = [
	    " ``t - 2t(1 + 4t^2)/2``",
	    " ``t - 4t(1+2t)/2``",
	    " ``t - 2(8t)/(1-2t)``",
	    " ``t - 1(1+4t^2)/2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6b548-797b-11ec-1a71-5f9c23d6f750
md"""  * Compute $Y(t)$
"""

# ╔═╡ 02d6c13e-797b-11ec-0cf9-13718ff844df
let
	choices = [
	    " ``t^2 + 1(1 + 4t^2)/2``",
	    " ``t^2 + 2t(1+4t^2)/2``",
	    " ``t^2 - 1(1+4t^2)/2``",
	    " ``t^2 - 2t(1+4t^2)/2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6c182-797b-11ec-1e88-9947eaeceaf1
md"""###### Question
"""

# ╔═╡ 02d6c196-797b-11ec-3bc8-bdcfe94955f8
md"""The following will compute the evolute of an ellipse:
"""

# ╔═╡ 02d6c1e6-797b-11ec-0648-09c5800f92c6
md"""```
@syms t a b
x = a * cos(t)
y = b * sin(t)
xp, xpp, yp, ypp = diff(x, t), diff(x,t,t), diff(y,t), diff(y,t,t)
r2 = xp^2 + yp^2
k = xp * ypp - xpp * yp
X = x - yp * r2 / k |> simplify
Y = y + xp * r2 / k |> simplify
[X, Y]
```"""

# ╔═╡ 02d6c1fa-797b-11ec-26ae-65eb868d1bcb
md"""What is the resulting curve?
"""

# ╔═╡ 02d6d9a6-797b-11ec-0cf3-6d2d756441bd
let
	choices = [
	"An astroid of the form ``c \\langle \\cos^3(t), \\sin^3(t) \\rangle``",
	"An cubic parabola of the form ``\\langle ct^3, dt^2\\rangle``",
	"An ellipse of the form ``\\langle a\\cos(t), b\\sin(t)``",
	"A cyloid of the form ``c\\langle t + \\sin(t), 1 - \\cos(t)\\rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 02d6d9e2-797b-11ec-0f8f-3574526b24d2
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/vectors.html">◅ previous</a>  <a href="../differentiable_vector_calculus/scalar_functions.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/vector_valued_functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 02d6da00-797b-11ec-0eaa-d3acbb93d9a2
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
DifferentialEquations = "~7.1.0"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
Roots = "~1.3.14"
SymPy = "~1.1.3"
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

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "1ee88c4c76caa995a885dc2f22a5d548dfbbc0ba"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.2"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e1ba79094cae97b688fb42d31cbbfd63a69706e4"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "0.7.8"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "ce68f8c2162062733f9b4c9e3700d5efc4a8ec47"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.16.11"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "bc1317f71de8dce26ea67fcdf7eccc0d0693b75b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.1"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SparseArrays"]
git-tree-sha1 = "fe34902ac0c3a35d016617ab7032742865756d7d"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.7.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[deps.CPUSummary]]
deps = ["Hwloc", "IfElse", "Static"]
git-tree-sha1 = "87b0c9c6ee0124d6c1f4ce8cb035dcaf9f90b803"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.1.6"

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
git-tree-sha1 = "6e39c91fb4b84dcb870813c91674bdebb9145895"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.5"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CloseOpenIntervals]]
deps = ["ArrayInterface", "Static"]
git-tree-sha1 = "7b8f09d58294dc8aa13d91a8544b37c8a1dcbc06"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.4"

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

[[deps.DEDataArrays]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "31186e61936fbbccb41d809ad4338c9f7addf7ae"
uuid = "754358af-613d-5f8d-9788-280bf1605d4c"
version = "0.2.0"

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

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "UnPack"]
git-tree-sha1 = "fd0ef97b21b6eea22a917ada02ebe38a85e08197"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.33.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Dictionaries]]
deps = ["Indexing", "Random"]
git-tree-sha1 = "66bde31636301f4d217a161cabe42536fa754ec8"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.17"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DEDataArrays", "DataStructures", "Distributions", "DocStringExtensions", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "IterativeSolvers", "LabelledArrays", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "PreallocationTools", "Printf", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "StaticArrays", "Statistics", "SuiteSparse", "ZygoteRules"]
git-tree-sha1 = "15e43e11701b8c0b6250d7996b5768751f5a10c2"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.81.0"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "NLsolve", "OrdinaryDiffEq", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArrays"]
git-tree-sha1 = "e57ecaf9f7875714c164ccca3c802711589127cf"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.20.1"

[[deps.DiffEqJump]]
deps = ["ArrayInterface", "Compat", "DataStructures", "DiffEqBase", "FunctionWrappers", "Graphs", "LinearAlgebra", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "628ddc7e2b44e214232e747b22f1a1d9a8f14467"
uuid = "c894b116-72e5-5b58-be3c-e6d8d4ac2b12"
version = "8.1.0"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "LinearAlgebra", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArrays", "Statistics"]
git-tree-sha1 = "d6839a44a268c69ef0ed927b22a6f43c8a4c2e73"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.9.0"

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

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqJump", "DiffEqNoiseProcess", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "3f3db9365fedd5fdbecebc3cce86dfdfe5c43c50"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.1.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "08f8555cb66936b871dcfdad09a4f89e754181db"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.40"

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

[[deps.ExponentialUtilities]]
deps = ["ArrayInterface", "LinearAlgebra", "Printf", "Requires", "SparseArrays"]
git-tree-sha1 = "3e1289d9a6a54791c1ee60da0850f4fd71188da6"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.11.0"

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

[[deps.FastBroadcast]]
deps = ["LinearAlgebra", "Polyester", "Static"]
git-tree-sha1 = "0f8ef5dcb040dbb9edd98b1763ac10882ee1ff03"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.1.12"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "8756f9935b7ccc9064c6eef0bff0ad643df733a3"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.7"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "6eae72e9943d8992d14359c32aed5f892bda1569"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.10.0"

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

[[deps.FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

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

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "d727758173afef0af878b29ac364a0eca299fc6b"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.5.1"

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

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8f0dc80088981ab55702b04bba38097a44a1a3a9"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.5"

[[deps.Hwloc]]
deps = ["Hwloc_jll"]
git-tree-sha1 = "92d99146066c5c6888d5a3abc871e6a214388b91"
uuid = "0e44f5e4-bd66-52a0-8798-143a42290a1d"
version = "2.0.0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d8bccde6fc8300703673ef9e1383b11403ac1313"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.7.0+0"

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

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

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

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

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

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "1ed18ccf6292d89abf85beba35b9399aeddff9b2"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.2.3"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "2906bbe840175708e9fc33e5067bdab4bfe42bd2"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.7.10"

[[deps.KrylovKit]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "0328ad9966ae29ccefb4e1b9bfd8c8867e4360df"
uuid = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
version = "0.5.3"

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

[[deps.LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "41158dee1d434944570b02547d404e075da15690"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.7.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static"]
git-tree-sha1 = "83b56449c39342a47f3fcdb3bc782bd6d66e1d97"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.4"

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

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "DocStringExtensions", "IterativeSolvers", "KLU", "Krylov", "KrylovKit", "LinearAlgebra", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "SuiteSparse", "UnPack"]
git-tree-sha1 = "51f1c4420932a544d153e536956716363bbc8291"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "1.7.0"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "SIMDDualNumbers", "SLEEFPirates", "SpecialFunctions", "Static", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "67c0dfeae307972b50009ce220aae5684ea852d1"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.101"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.ManualMemory]]
git-tree-sha1 = "9cb207b18148b2199db259adfa923b45593fe08e"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.6"

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

[[deps.MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "b61c51cd5b9d8b197dfcbbf2077a0a4e1505278d"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.14"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

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

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "916077e0f0f8966eb0dc98a5c39921fdb8f49eb4"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.6.0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.OrdinaryDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastClosures", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "Polyester", "PreallocationTools", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "5099c31d4814859b9adc418e2ded64ad56890c66"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.4.2"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "ee26b350276c51697c9c2d88a072b339f9f03d73"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.5"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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

[[deps.PoissonRandom]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "44d018211a56626288b5d3f8c6497d28c26dc850"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.0"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "3c44fc250c04352839cea8d5b9d94bcb7b3de420"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.6.2"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "a3ff99bf561183ee20386aec98ab8f4a12dc724a"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.1.2"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "LabelledArrays"]
git-tree-sha1 = "e4cb8d4a2edf9b3804c1fb2c2de57d634ff3f36e"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.2.3"

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

[[deps.Random123]]
deps = ["Libdl", "Random", "RandomNumbers"]
git-tree-sha1 = "0e8b146557ad1c6deb1367655e052276690e71a3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.4.2"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "37c1631cb3cc36a535105e6d5557864c82cd8c2b"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.0"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "ChainRulesCore", "DocStringExtensions", "FillArrays", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "6b96eb51a22af7e927d9618eaaf135a3520f8e2f"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.24.0"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "832379c5df67f4bab32ed0253ac299cf1e9c36e6"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.8"

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

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "0abe7fc220977da88ad86d339335a4517944fea2"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.14"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMDDualNumbers]]
deps = ["ForwardDiff", "IfElse", "SLEEFPirates", "VectorizationBase"]
git-tree-sha1 = "62c2da6eb66de8bb88081d20528647140d4daa0e"
uuid = "3cdde19b-5bb0-4aaf-8931-af3e248e098b"
version = "0.1.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "1410aad1c6b35862573c01b96cd1f6dbe3979994"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.28"

[[deps.SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "40c1c606543c0130cd3673f0dd9e11f2b5d76cd0"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.26.0"

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

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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

[[deps.SparseDiffTools]]
deps = ["Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays", "VertexSafeGraphs"]
git-tree-sha1 = "75c89362201983c500dd34923b015dbecdae7a90"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "1.20.0"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "7f5a513baec6f122401abfc8e9c074fdac54f6c1"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.1"

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

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "bedb3e17cc1d94ce0e6e66d3afa47157978ba404"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.14"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "3e057e1f9f12d18cac32011aed9e61eef6c1c0ce"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.6.6"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqJump", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "5f88440e7470baad99f559eed674a46d2b6b96f7"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.44.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "Requires", "SIMDTypes", "Static", "ThreadingUtilities"]
git-tree-sha1 = "12cf3253ebd8e2a3214ae171fbfe51e7e8d8ad28"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.2.9"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "d21f2c564b21a202f4677c0fba5b5ee431058544"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.4"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "Reexport", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "ce11202f487f429dbe7f937c40ff54f6a7e7259e"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.9.1"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "571bf3b61bcd270c33e22e2e459e9049866a2d1f"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.3"

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

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "884539ba8c4584a3a8173cb4ee7b61049955b79c"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.4.7"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "c3ab8b77b82fd92e2b6eea8a275a794d5a6e4011"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "Hwloc", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static"]
git-tree-sha1 = "6e261bff5c9f2537776165dea3067df9de4440cf"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.23"

[[deps.VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

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

[[deps.ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─02d6d9ba-797b-11ec-33ea-c53419988a14
# ╟─0287616e-797b-11ec-0c84-e18105525db4
# ╟─0289ecb8-797b-11ec-3a0f-4d6181fa22d6
# ╠═02a163dc-797b-11ec-1c80-2556577bd076
# ╟─02a16974-797b-11ec-167a-d73f96efafc6
# ╟─02a36b7a-797b-11ec-28b4-d51e182605c7
# ╟─02a50f98-797b-11ec-2acb-2904f766cde2
# ╟─02a7bb14-797b-11ec-2530-bbe052567e82
# ╟─02a7bb8a-797b-11ec-3dad-0d81bc2ef139
# ╟─02a9bbd8-797b-11ec-3f62-e7e110b18853
# ╟─02a9bc5a-797b-11ec-3f0c-17e417f8dc3a
# ╟─02a9bc80-797b-11ec-09c7-09adb58bce2f
# ╟─02a9bc96-797b-11ec-304b-c7c9a61d1c43
# ╟─02a9bcc8-797b-11ec-1c90-7b6c9b5ebbea
# ╟─02b147f4-797b-11ec-2203-e19b0bb51937
# ╠═02b15262-797b-11ec-3ed3-dddf5c3294da
# ╟─02b152ba-797b-11ec-3d02-63969ec1e780
# ╠═02b154b0-797b-11ec-23d0-4192d193db82
# ╟─02b154e2-797b-11ec-07ba-a15c3203649b
# ╠═02b1588c-797b-11ec-36a0-2330362df1ea
# ╟─02b158a2-797b-11ec-10be-f13d6651b287
# ╠═02b15abe-797b-11ec-0ac5-01ecba2c5e17
# ╟─02b15adc-797b-11ec-10d2-df8092f57b35
# ╟─02b30532-797b-11ec-00d7-65c8f070aab1
# ╟─02b30580-797b-11ec-258c-d1220d4d83a6
# ╟─02b305bc-797b-11ec-1b2e-b35c7119f8ac
# ╟─02b305e4-797b-11ec-27fb-53ea72741ba7
# ╟─02b30620-797b-11ec-0d29-358fec11cb36
# ╟─02b3063e-797b-11ec-1bd1-91bba71aa5b6
# ╟─02b3065c-797b-11ec-2915-010fe9624f5a
# ╟─02b3069a-797b-11ec-3f79-5b2a9983bffa
# ╟─02b306ac-797b-11ec-3610-ef3ce745fd97
# ╟─02b306fa-797b-11ec-1f51-c9912b399f1e
# ╟─02b30710-797b-11ec-2f08-bfe9c54d1fe4
# ╟─02b30738-797b-11ec-2283-eb1772920ceb
# ╟─02b30742-797b-11ec-3c29-df558a104d3e
# ╟─02b30760-797b-11ec-1785-278a6c4187a2
# ╠═02b313ae-797b-11ec-0a5f-350aa0f75eb7
# ╟─02b31414-797b-11ec-1ff9-39fd62fd474c
# ╟─02b31430-797b-11ec-3365-dbaeef9fdbd2
# ╠═02b31be2-797b-11ec-2b2c-319b585d5b53
# ╟─02b31c3c-797b-11ec-2027-3bb2b467c08a
# ╠═02b3252e-797b-11ec-166c-ad40925bb7ce
# ╟─02b3257e-797b-11ec-2b8e-0fa6bab2b51c
# ╠═02b32e20-797b-11ec-19bb-499fc4023419
# ╟─02b60078-797b-11ec-0375-2599fb90ebbb
# ╟─02b6078a-797b-11ec-05ac-e3a13ad531d2
# ╟─02b607da-797b-11ec-0c31-2574b9dab2aa
# ╠═02b60dc8-797b-11ec-1023-37b59384c141
# ╟─02b63a34-797b-11ec-2171-c7fd91f2d092
# ╟─02bd3582-797b-11ec-3a27-d35f759814fd
# ╟─02bd35e6-797b-11ec-3486-d78c542979d7
# ╟─02bd3636-797b-11ec-3a34-c98169bb980f
# ╟─02bd3686-797b-11ec-2f6e-0f4460229349
# ╟─02bd36b8-797b-11ec-2d1e-83ba4d68e937
# ╟─02be7c28-797b-11ec-33fa-31c1976770a0
# ╟─02be7c88-797b-11ec-1d83-2b78257c5101
# ╟─02be7ce4-797b-11ec-31e1-a59b96a89c49
# ╟─02be7d0c-797b-11ec-16f3-b5cbf540e487
# ╟─02be7d20-797b-11ec-2af5-e92422f43ea3
# ╠═02be89fa-797b-11ec-0e7a-417ba951e2f3
# ╟─02be8a5e-797b-11ec-1b77-cd617a083f2a
# ╟─02c08610-797b-11ec-09cd-1fce9c38c6a2
# ╟─02c08688-797b-11ec-0f97-1554de2d1c63
# ╟─02c086b0-797b-11ec-3f60-69b1fabdcfcc
# ╟─02c086e2-797b-11ec-1e1e-619b2fdf0b0e
# ╟─02c086f6-797b-11ec-213b-c9acd6032bd8
# ╟─02c08714-797b-11ec-15a8-6b7e9c92d2c2
# ╟─02c08728-797b-11ec-2c87-7135d69ed2ac
# ╠═02c0964e-797b-11ec-094f-f70e941accb2
# ╟─02c0968c-797b-11ec-348a-65db46ff0fca
# ╠═02c0b8c4-797b-11ec-28e0-f1605ca9ba36
# ╟─02c0b8f6-797b-11ec-2059-53d0bd807e10
# ╠═02c0ba68-797b-11ec-256a-3b6cf6e17652
# ╟─02c0ba90-797b-11ec-1076-33597535aaf2
# ╠═02c0bcde-797b-11ec-285d-fd1c27ef5400
# ╟─02c0bcfc-797b-11ec-16aa-3fe68bb8d216
# ╠═02c0bf18-797b-11ec-21b0-d789d3957ff9
# ╟─02c0bf36-797b-11ec-3992-655ac057d063
# ╟─02c0bf56-797b-11ec-3b35-29a9ee9935fe
# ╟─02c1f734-797b-11ec-2a8b-a7ba1d01f332
# ╟─02c1f77a-797b-11ec-0e0a-d1fdfc69f4c4
# ╟─02c1f7b6-797b-11ec-1691-610c250fc0e1
# ╟─02c1f7ca-797b-11ec-2fb0-e977968c7a40
# ╟─02c1f7d4-797b-11ec-3cd3-f7cd6be75437
# ╟─02c1f7de-797b-11ec-32e6-c54033ae0ce3
# ╟─02c1f7f4-797b-11ec-3e43-f1b14f6675cf
# ╠═02c1ff72-797b-11ec-3d38-2dce1f80bf89
# ╟─02c1ffb8-797b-11ec-24c8-61e1795224d7
# ╟─02c20008-797b-11ec-360f-0dd8b1ba9c9e
# ╟─02c2001c-797b-11ec-0718-7348ef949fd6
# ╟─02c20044-797b-11ec-189c-6554612110dd
# ╟─02c2004e-797b-11ec-1915-43137b918982
# ╟─02c2006c-797b-11ec-2a1d-330c283c07e2
# ╟─02c2008a-797b-11ec-3f3a-d159d404cfeb
# ╟─02c2009e-797b-11ec-30fc-95bdf67d9783
# ╟─02c200bc-797b-11ec-0136-3b93545d40fd
# ╠═02c20800-797b-11ec-13a1-fb2eefc829cb
# ╟─02c20832-797b-11ec-045a-979c079d83f8
# ╟─02c20846-797b-11ec-2b2a-27173c7324f5
# ╟─02c20864-797b-11ec-21b1-a1b1b4c005ba
# ╟─02c20896-797b-11ec-2004-9b8691f0064b
# ╟─02c208be-797b-11ec-1743-11e1b8e0d750
# ╟─02c208dc-797b-11ec-36e8-f94241140458
# ╟─02c208e6-797b-11ec-332b-37bf828a033f
# ╠═02c20f6c-797b-11ec-0b6b-197c3f5a04aa
# ╟─02c20f94-797b-11ec-3cb9-59e539f9383f
# ╟─02c20fb2-797b-11ec-0627-7d09827c9685
# ╠═02c2139a-797b-11ec-1803-b1c6f35e1c86
# ╟─02c213ac-797b-11ec-0e22-0dc20f0f5e76
# ╟─02c213cc-797b-11ec-2415-dfc2df60c2c2
# ╠═02c217be-797b-11ec-2ec3-f1c1fc59cd0b
# ╟─02c217e4-797b-11ec-3a6c-5d08cb14db25
# ╟─02c21804-797b-11ec-375e-35a8c96aa6fb
# ╠═02c21b42-797b-11ec-3c4e-0f14e99a5ebf
# ╟─02c21b58-797b-11ec-39aa-4d01b61263f3
# ╠═02c21f02-797b-11ec-263c-8f01119760dc
# ╟─02c21f16-797b-11ec-1b7c-c50431238d78
# ╠═02c22074-797b-11ec-2174-27edac65d562
# ╟─02c22088-797b-11ec-31d0-19a382131c2c
# ╠═02c221fa-797b-11ec-0571-cbb8ca69572c
# ╟─02c2220e-797b-11ec-3e35-5dbc0c194c65
# ╟─02c22218-797b-11ec-0511-a153eba47ac8
# ╟─02c22240-797b-11ec-2a03-b1bef30c2848
# ╟─02c22254-797b-11ec-359f-6194ccf80277
# ╟─02c22272-797b-11ec-028a-dbd6f803d8a6
# ╟─02c22286-797b-11ec-1859-478ac74b4fd6
# ╟─02c247de-797b-11ec-1551-09f4115f2101
# ╟─02c24856-797b-11ec-3ed1-61f119e082f6
# ╠═02c24d88-797b-11ec-2c20-3148f926f7f6
# ╟─02c24db0-797b-11ec-02dc-eb7df2246cc0
# ╟─02c253b4-797b-11ec-0902-7f3bee359884
# ╟─02c25422-797b-11ec-1282-75aff34335e5
# ╟─02c25440-797b-11ec-14da-dd455130973e
# ╟─02c254ae-797b-11ec-0b85-731d50a53ba9
# ╟─02c254c2-797b-11ec-0a54-05868edea082
# ╟─02c254e0-797b-11ec-248b-d1b57ea96ecb
# ╟─02c254f4-797b-11ec-36ce-a794850ea4a9
# ╟─02c2551c-797b-11ec-0089-75ba69f23bc5
# ╟─02c25530-797b-11ec-08c4-bfe10179cb12
# ╟─02c2554e-797b-11ec-24d7-5fe0e1aa6043
# ╟─02c25576-797b-11ec-3056-8bf07f6cb7b8
# ╠═02c26804-797b-11ec-0ec2-dd0925d91ae9
# ╟─02c26890-797b-11ec-242a-91f8c23a403d
# ╠═02c2711e-797b-11ec-1d9d-85ce068af919
# ╟─02c2716e-797b-11ec-1bf2-574942c1ff08
# ╟─02c27198-797b-11ec-1e93-1bb8ded36006
# ╠═02c277b8-797b-11ec-2d2f-b30431fa2a9c
# ╟─02c277d6-797b-11ec-209e-0137a7e84235
# ╟─02c277fc-797b-11ec-0856-c5bfc11a9fc9
# ╠═02c27baa-797b-11ec-0974-5f9e600289f3
# ╟─02c27bbe-797b-11ec-1c2c-132fe2ca2058
# ╟─02c27bc8-797b-11ec-2923-bdcdeba42464
# ╠═02c27f7e-797b-11ec-3f36-f9fa31e33a08
# ╟─02c27f92-797b-11ec-0253-69449a602b71
# ╟─02c27fa8-797b-11ec-0d32-935fb46fec80
# ╠═02c2832a-797b-11ec-29ad-eb175e8e795c
# ╟─02c2833e-797b-11ec-1191-038df388370e
# ╟─02c28370-797b-11ec-3293-bf5c0a727f16
# ╟─02c28398-797b-11ec-2f0d-79b94ac9d0cc
# ╟─02c283b6-797b-11ec-312e-0b43bbb523eb
# ╟─02c283d4-797b-11ec-3707-992b32610ef6
# ╟─02c283e8-797b-11ec-3101-c513d2e688ad
# ╟─02c283fc-797b-11ec-081a-45324a4dc590
# ╟─02c28406-797b-11ec-2029-f9790604e252
# ╟─02c2841a-797b-11ec-2c5d-ebe93eb08b18
# ╟─02c28424-797b-11ec-2b93-638764c6f003
# ╟─02c28440-797b-11ec-3ab8-f79218610e5a
# ╟─02c28456-797b-11ec-3fee-2b010c319dee
# ╟─02c28460-797b-11ec-1eee-c5bc6f368c4c
# ╟─02c28472-797b-11ec-1aa7-07d9c4533de8
# ╠═02c28dc0-797b-11ec-1727-9f048acef0d5
# ╟─02c28dde-797b-11ec-0fda-eb2c57e42f09
# ╠═02c2913a-797b-11ec-2ee2-41d1a83e2437
# ╟─02c29162-797b-11ec-17ba-557f145be1d8
# ╠═02c2966c-797b-11ec-1395-f126d782989c
# ╟─02c29694-797b-11ec-23eb-8d341a541902
# ╟─02c296a8-797b-11ec-29e9-9947fe0ec77a
# ╟─02c296c8-797b-11ec-0055-c93d9716e218
# ╟─02c296e4-797b-11ec-23ce-e1ae54dfc145
# ╟─02c296fa-797b-11ec-390a-f38e5d665cc0
# ╟─02c2970c-797b-11ec-2bc7-39787ed9378c
# ╟─02c29720-797b-11ec-0867-6b54e22c56bf
# ╟─02c2973e-797b-11ec-1da5-03fd2383dd04
# ╟─02cc5684-797b-11ec-217e-77fd26e8a4d6
# ╟─02cc56f2-797b-11ec-019f-4bbc5bd40556
# ╟─02cc572e-797b-11ec-38d5-b38b0103ac6b
# ╟─02cc5738-797b-11ec-3f04-6b03f22f1c5a
# ╟─02cc5756-797b-11ec-149a-b3a41e356846
# ╟─02cc576a-797b-11ec-00c9-95c000356699
# ╟─02cc5772-797b-11ec-2f94-ad6a5a74fc0d
# ╟─02cc5788-797b-11ec-0ea4-db6b824d5e97
# ╟─02cc579c-797b-11ec-2536-49ea1584a43d
# ╟─02cc57b0-797b-11ec-29e6-d949cd9a3c9c
# ╟─02cc57ce-797b-11ec-2cb4-3b6177413636
# ╟─02cc57ec-797b-11ec-235f-e7ea88aeefd6
# ╟─02cc57f6-797b-11ec-066a-37520d22b040
# ╟─02cc580a-797b-11ec-31aa-7b4a016e99b5
# ╟─02cc5814-797b-11ec-21a9-d3709d1f917a
# ╟─02cc5828-797b-11ec-2c2a-9bf8a234e059
# ╟─02cc5832-797b-11ec-1366-2d1df0c52d66
# ╟─02cc5848-797b-11ec-0272-bbebe9932506
# ╟─02cc5850-797b-11ec-0211-4dcaf08501d6
# ╟─02cc5864-797b-11ec-3cca-e31dc481673e
# ╟─02cc586e-797b-11ec-0dbf-0982005186e8
# ╟─02cc5882-797b-11ec-1311-67e6218d8781
# ╟─02cc588c-797b-11ec-20f5-2f165fcaf0f4
# ╟─02cc5896-797b-11ec-14b1-1992d938f76b
# ╟─02cc58a0-797b-11ec-076c-d34d0c018205
# ╟─02cc58da-797b-11ec-332d-67c5df6a2ccd
# ╟─02cc58e6-797b-11ec-3ccc-d965389e62bc
# ╟─02cc58fa-797b-11ec-0ab3-c9dee5a71bbd
# ╟─02cc5904-797b-11ec-0fba-2369a6bd6cf3
# ╟─02cc5918-797b-11ec-1227-435292647944
# ╟─02cc593e-797b-11ec-016c-8961d878717d
# ╟─02cc5954-797b-11ec-352c-3bf0fc356455
# ╠═02cc62c8-797b-11ec-25e2-2d87f9944906
# ╟─02cc62fa-797b-11ec-2360-f187c73e33a3
# ╟─02cc630e-797b-11ec-3458-350c9f9d6701
# ╟─02cc6322-797b-11ec-05f5-b38c14dc7362
# ╟─02cc6340-797b-11ec-3c29-6788128690c6
# ╟─02cc635e-797b-11ec-0fcc-47296021bff6
# ╟─02cc6372-797b-11ec-2f23-cb0eccadf22b
# ╟─02cc6390-797b-11ec-070a-fda35535d77e
# ╟─02cc639a-797b-11ec-2b5a-175358d136b7
# ╟─02cc63a4-797b-11ec-338d-2bfb7b39eb29
# ╟─02cc63ba-797b-11ec-0316-0748983bb668
# ╟─02cc63c2-797b-11ec-0209-6fd9532bd24c
# ╟─02cc63d6-797b-11ec-3614-61aaa05e5be3
# ╟─02cc63e0-797b-11ec-0f73-e9cbc024d35a
# ╟─02cc6408-797b-11ec-1be2-913873d6820a
# ╟─02cc6426-797b-11ec-220a-73dce0e42325
# ╟─02cc644c-797b-11ec-3a18-3b758eb2aef4
# ╟─02cc646c-797b-11ec-1f51-091908ddad99
# ╟─02cc6476-797b-11ec-2821-03646e83b026
# ╟─02cc648a-797b-11ec-252e-e3776511cadc
# ╟─02cc649e-797b-11ec-17bc-51bd7109c96e
# ╟─02cc64a8-797b-11ec-0370-25bfb68d17d3
# ╟─02cc64c6-797b-11ec-153f-0f2458eb48c5
# ╟─02cc64da-797b-11ec-3602-91f530b4f665
# ╟─02cc64e4-797b-11ec-0d50-33708e8371c0
# ╟─02cc6502-797b-11ec-111a-231e01f13a27
# ╟─02cc650c-797b-11ec-2bf6-ff9adda5bdcf
# ╟─02cc6522-797b-11ec-13e4-5f33098043ca
# ╟─02cc652a-797b-11ec-2372-15f95dc86c81
# ╟─02cc653e-797b-11ec-3733-c389aa4991e2
# ╟─02cc6548-797b-11ec-3e02-67567183ec41
# ╟─02cc6566-797b-11ec-1f65-cddf561f1141
# ╟─02cc6570-797b-11ec-39a3-8d285b3264b9
# ╟─02cc657a-797b-11ec-3a4a-f1946277b492
# ╟─02cc6582-797b-11ec-2a22-8d356e6cfe10
# ╟─02cc6598-797b-11ec-17fd-edd5946bcec8
# ╟─02cc65a2-797b-11ec-38f5-5f301854c9d9
# ╟─02cc65ac-797b-11ec-3fd3-29114a5b4e52
# ╟─02cc65c0-797b-11ec-0d6a-4138d486be8a
# ╟─02cc65ca-797b-11ec-2b72-51fcf29e9caf
# ╟─02cc65d4-797b-11ec-2a99-5deac168c8c2
# ╟─02cc65e8-797b-11ec-11cb-dff6455b1f19
# ╟─02cc661a-797b-11ec-1491-17ca9f5cd0fa
# ╟─02cc662e-797b-11ec-2081-5b4e258ffc01
# ╟─02cc666a-797b-11ec-3989-6571afacc6cc
# ╟─02cc6674-797b-11ec-0d27-6dee5e3b4d2c
# ╟─02cc6686-797b-11ec-2e76-6fc86db2074a
# ╟─02cc66a6-797b-11ec-3280-3d3bbb0847d5
# ╟─02cc66b0-797b-11ec-03c4-e9cbd964078d
# ╟─02cc66ce-797b-11ec-20f1-9152156a0c35
# ╟─02cc66ea-797b-11ec-1543-75b71f953555
# ╟─02cc6714-797b-11ec-3e76-f1994e1f8dcb
# ╠═02cc73da-797b-11ec-34e9-757e25e15dea
# ╟─02cc73f8-797b-11ec-39dd-4f8ec1257364
# ╟─02cc742a-797b-11ec-0701-09cfc852c170
# ╟─02d1012a-797b-11ec-3372-0985bd224d31
# ╟─02d1018e-797b-11ec-0192-7539a93c9b77
# ╟─02d101b6-797b-11ec-1a00-4b16f55890a9
# ╟─02d101fc-797b-11ec-3a3a-834c6967e937
# ╟─02d10210-797b-11ec-292b-f709baff0750
# ╠═02d109fe-797b-11ec-33a5-a5a95772b6bc
# ╟─02d10a30-797b-11ec-022a-c304685771e1
# ╟─02d10a4e-797b-11ec-041e-2d89a0d86fcf
# ╟─02d10a74-797b-11ec-0386-67ccbbbe15d5
# ╟─02d10a8a-797b-11ec-01ab-33fa8aaa63f2
# ╟─02d10b4a-797b-11ec-234f-4d268ed9131c
# ╟─02d10b66-797b-11ec-194b-6906b2a4a46f
# ╟─02d10b98-797b-11ec-3b36-afc61772f835
# ╟─02d10bb6-797b-11ec-1e4d-d3c68f17de06
# ╟─02d17736-797b-11ec-0a4e-7bbf32e7ea66
# ╟─02d177c2-797b-11ec-0f52-d7f33ab502b1
# ╟─02d177ea-797b-11ec-305c-1bf26a1e44e0
# ╟─02d17806-797b-11ec-0720-dd5baa03a5f8
# ╟─02d1781c-797b-11ec-3fa2-39a05a10fc1d
# ╟─02d17830-797b-11ec-2be5-01170f0e280c
# ╟─02d17838-797b-11ec-097c-d70734e01f82
# ╟─02d17858-797b-11ec-00d2-c1665656bc6e
# ╟─02d1786a-797b-11ec-333f-49bc4d5887e0
# ╟─02d17880-797b-11ec-0b91-41a5f029a47d
# ╟─02d178b2-797b-11ec-3f51-9b8bea569cd6
# ╟─02d178d0-797b-11ec-3041-255b3829f70c
# ╠═02d184e0-797b-11ec-0ef7-19209a119401
# ╟─02d18514-797b-11ec-30c7-8d62ee09c16c
# ╠═02d18a3c-797b-11ec-1124-5f1e1f088d8e
# ╟─02d18a78-797b-11ec-1e8f-b70ef12cd812
# ╠═02d18fb4-797b-11ec-3e36-05c363cab459
# ╟─02d18fd2-797b-11ec-3e27-b3e2bbd594c7
# ╟─02d18ff0-797b-11ec-1a90-a1c65815f128
# ╠═02d1972a-797b-11ec-26b6-5fa0129e3eeb
# ╟─02d19768-797b-11ec-3925-3f9ea5576050
# ╠═02d19f0e-797b-11ec-1911-79bae6d21bfe
# ╟─02d19f4a-797b-11ec-02da-4142a9be2711
# ╠═02d1a31e-797b-11ec-08f3-e97206f1c0bf
# ╟─02d1a346-797b-11ec-3646-c10784ea9b0f
# ╟─02d1a36e-797b-11ec-2f97-f931a7807337
# ╟─02d1a38c-797b-11ec-1805-6d45cc3f3b50
# ╟─02d1a3be-797b-11ec-32cb-813ff70d78fe
# ╟─02d1a3c8-797b-11ec-36a9-95785634b08e
# ╟─02d1a3f0-797b-11ec-1487-618f6ea6a6ed
# ╟─02d1a3fa-797b-11ec-1301-9b182943313b
# ╟─02d1a422-797b-11ec-256e-7b4b9161bd1e
# ╟─02d1a436-797b-11ec-0268-654a47776929
# ╟─02d1a44a-797b-11ec-0f93-4ffa9e07b5f1
# ╠═02d1b106-797b-11ec-1599-817a11db2cdb
# ╠═02d1b76e-797b-11ec-1269-f1471e19362b
# ╟─02d1b7b4-797b-11ec-3590-05dc74453a1b
# ╠═02d1bbd8-797b-11ec-0f52-8f508361e799
# ╟─02d1bc34-797b-11ec-2f96-5fc48fb5674e
# ╠═02d1c298-797b-11ec-292c-352dce601ddf
# ╟─02d1c2ea-797b-11ec-272c-d35832e53b7d
# ╟─02d1c2fe-797b-11ec-261a-cbc248766e8b
# ╠═02d1c806-797b-11ec-1ec5-2b5eac059cc5
# ╟─02d1c830-797b-11ec-2f85-d32cfc282927
# ╠═02d1c934-797b-11ec-00b1-5f4a4b7ae88b
# ╟─02d1c948-797b-11ec-1dcf-a16ba7c46dd7
# ╠═02d1cc9a-797b-11ec-1a67-47ae832f8aac
# ╟─02d1ccea-797b-11ec-2adf-d18191f2c619
# ╟─02d1cd08-797b-11ec-17f6-b519f3332164
# ╟─02d1cd58-797b-11ec-197f-15b5fc49f369
# ╟─02d1d1cc-797b-11ec-25c8-6153a82570f9
# ╟─02d1d1e0-797b-11ec-260d-bd4fb46482d1
# ╟─02d1d208-797b-11ec-005c-df9aa2904b0a
# ╟─02d1d230-797b-11ec-09fa-b702259f78c2
# ╟─02d1d258-797b-11ec-389f-218bff4d471e
# ╟─02d1d26c-797b-11ec-000e-4d3c3f6cd33d
# ╟─02d1d28a-797b-11ec-0275-bb3583722379
# ╟─02d1d294-797b-11ec-23fe-998a1fb44aac
# ╟─02d1d2b0-797b-11ec-032f-5f15ca0cecb1
# ╟─02d1d2d0-797b-11ec-3b6a-878d037e99ae
# ╟─02d1d2ee-797b-11ec-193e-fbd588773fab
# ╟─02d1d2f8-797b-11ec-12b1-51531a5b64b4
# ╟─02d1d30c-797b-11ec-0483-475cf608200e
# ╟─02d1d314-797b-11ec-3747-a58f9f92fb08
# ╟─02d1d33e-797b-11ec-2aa1-79a4ff153f54
# ╟─02d1d352-797b-11ec-2ea8-95adcc769d00
# ╟─02d1d366-797b-11ec-3cee-1b730a6013d6
# ╟─02d1d37a-797b-11ec-2c0c-9b1479e2a80c
# ╟─02d1d398-797b-11ec-0a37-5d6fdae4ac64
# ╟─02d1d3ac-797b-11ec-2575-c5c962535f3b
# ╟─02d1d3c0-797b-11ec-2ac2-91d52d59f678
# ╟─02d1d3ca-797b-11ec-2a74-f3b3fa7836b7
# ╟─02d1d3ea-797b-11ec-167d-e3f11447e18f
# ╟─02d1d9ce-797b-11ec-0dae-4581859cc6da
# ╟─02d1d9ea-797b-11ec-2f27-77b543987733
# ╟─02d1da14-797b-11ec-1bf9-db70586bf3d9
# ╟─02d1df64-797b-11ec-04b2-3baef9d4f379
# ╟─02d1df96-797b-11ec-2bf7-258ed4904088
# ╟─02d1dfd2-797b-11ec-3fa0-19e50c00529a
# ╟─02d1dffc-797b-11ec-02ee-97aa268a6b07
# ╟─02d1e00e-797b-11ec-0dbb-0d025127571b
# ╟─02d1e02e-797b-11ec-1fdf-7ffcc5800721
# ╠═02d1e662-797b-11ec-1bd1-dde531471c7e
# ╟─02d1e6a8-797b-11ec-2afa-89231da05825
# ╟─02d1e6bc-797b-11ec-30ae-1114945b717d
# ╟─02d1e6da-797b-11ec-2d02-f3200709e08e
# ╟─02d1e6e4-797b-11ec-2845-cb4e8c3839fe
# ╟─02d1e6f8-797b-11ec-32dc-c74a8a6835a8
# ╟─02d1e70c-797b-11ec-22f5-d94ebf6c6950
# ╟─02d1e720-797b-11ec-2472-c5b414ccf9c7
# ╠═02d1edec-797b-11ec-1fa3-097e57bdbbad
# ╟─02d1ee46-797b-11ec-1a42-5f491c26569c
# ╟─02d1ee5a-797b-11ec-3102-433d224f69ad
# ╟─02d1ee78-797b-11ec-08ce-e31a121a4b0c
# ╟─02d1ee96-797b-11ec-1207-55938283c603
# ╠═02d1f45e-797b-11ec-1913-6bca89bea7d1
# ╠═02d1fc9c-797b-11ec-1acc-77c91feb32ea
# ╟─02d1fcbc-797b-11ec-2fba-112ce8de0aa2
# ╟─02d26736-797b-11ec-2bd8-a5bcbc51160b
# ╠═02d26eac-797b-11ec-01a5-f167514eae70
# ╟─02d26efc-797b-11ec-079d-b7d74a843632
# ╟─02d26f18-797b-11ec-391b-ab4e17589332
# ╟─02d26f6a-797b-11ec-3e4c-81520e18a27e
# ╟─02d26f7e-797b-11ec-3d4d-ddf6fd77e7d8
# ╟─02d26f9c-797b-11ec-10f0-ad4b95a61323
# ╟─02d26fb0-797b-11ec-1538-d3cf11097cd8
# ╟─02d26fbc-797b-11ec-0440-71cd24664d78
# ╟─02d270fa-797b-11ec-0824-3f3785c69743
# ╟─02d2710e-797b-11ec-3ebd-8b6fc6a01e82
# ╟─02d27118-797b-11ec-22c6-4f8ae145320b
# ╟─02d2712c-797b-11ec-3496-1bccecc6a65e
# ╟─02d27136-797b-11ec-0a8f-eb37e1e718e7
# ╟─02d2714a-797b-11ec-1869-cbe75b9395fe
# ╟─02d2715e-797b-11ec-0efb-9171d0fe0224
# ╟─02d27172-797b-11ec-2764-0b1834118555
# ╟─02d27190-797b-11ec-1899-f31d36a115c4
# ╟─02d2719a-797b-11ec-1f7c-534a1984179f
# ╟─02d271ae-797b-11ec-1127-bf68a5e8b13d
# ╟─02d271d6-797b-11ec-22f9-c35104072bba
# ╟─02d271e8-797b-11ec-2e67-5fa7a89c7d28
# ╟─02d271f4-797b-11ec-3f28-5fe38228774d
# ╟─02d27212-797b-11ec-1ae8-07ef7f57e4c6
# ╟─02d27230-797b-11ec-1d08-11251009f320
# ╟─02d2723a-797b-11ec-0347-61d7f7b77f29
# ╟─02d2724e-797b-11ec-228b-73470e9d3a36
# ╠═02d279ce-797b-11ec-1eca-77228dc847ed
# ╟─02d27a00-797b-11ec-145b-b74587be5d24
# ╟─02d27a1e-797b-11ec-09d6-d96d13c8aa28
# ╟─02d27a50-797b-11ec-1c74-c5112eb032e7
# ╟─02d27a82-797b-11ec-30d2-99567f1093a2
# ╟─02d27aa0-797b-11ec-0c97-5d878475983e
# ╠═02d2a5c0-797b-11ec-18dc-eb5f62f1426a
# ╟─02d2a5fa-797b-11ec-2ac8-8b1489b1459a
# ╟─02d2a61a-797b-11ec-2f58-f38d4d2a506c
# ╠═02d2adcc-797b-11ec-1e27-87f5e069b13c
# ╟─02d2ade0-797b-11ec-2866-9724f89a071e
# ╠═02d2b6b4-797b-11ec-30c5-61ef53cf5309
# ╟─02d2b6c8-797b-11ec-262d-8f1139548593
# ╠═02d2bbe4-797b-11ec-0358-cff080af3c19
# ╟─02d2bc0e-797b-11ec-22d1-b90d7aac64d8
# ╠═02d2c028-797b-11ec-2044-3f8b78f19159
# ╟─02d2c04e-797b-11ec-22d4-c548fab26f11
# ╠═02d2c5b4-797b-11ec-37da-e33f9c1b3735
# ╟─02d2c5d2-797b-11ec-1393-9b407ce4928e
# ╠═02d2cad2-797b-11ec-123d-8739dca25fac
# ╟─02d2cb04-797b-11ec-3325-1bb830fdf8e5
# ╟─02d2cb0e-797b-11ec-1c90-e3fe07918733
# ╠═02d2d0a4-797b-11ec-1b9e-7d340e2cf2d8
# ╟─02d2d0e0-797b-11ec-3a94-8750ec6a87d4
# ╟─02d57180-797b-11ec-1aae-191f0cf66c6f
# ╟─02d5720a-797b-11ec-1995-8d5bd68a8ed8
# ╟─02d5723c-797b-11ec-0a1f-4969f4b5b8e1
# ╟─02d5725a-797b-11ec-30f2-2f1d1b061620
# ╟─02d57da4-797b-11ec-3573-8d0b5c47432e
# ╟─02d57de0-797b-11ec-2d01-3b60a35f1e96
# ╟─02d5852c-797b-11ec-1509-a579f526770a
# ╟─02d58556-797b-11ec-1af0-a77217b4a0e1
# ╟─02d585a6-797b-11ec-2790-e5864c47ab65
# ╟─02d5903a-797b-11ec-2947-93a099b0984b
# ╟─02d59050-797b-11ec-282b-5f5506f26665
# ╟─02d59078-797b-11ec-2e5a-95f6ca8a3f53
# ╟─02d59a64-797b-11ec-187a-4f0b99840624
# ╟─02d59a84-797b-11ec-069b-a5c9d65977d5
# ╟─02d59aaa-797b-11ec-044e-9132c4a173db
# ╟─02d59ac8-797b-11ec-2f68-a1911564a82e
# ╠═02d5a266-797b-11ec-28e2-f3e11fecc093
# ╟─02d5a27a-797b-11ec-3508-f921f5ca0ebf
# ╟─02d5a702-797b-11ec-0ae3-f1e84a2b0adf
# ╟─02d5a720-797b-11ec-1f90-cf20f616c154
# ╟─02d5a73e-797b-11ec-0fec-b7e0d2303545
# ╟─02d5a752-797b-11ec-3e9f-5b1903e41289
# ╟─02d5ae8c-797b-11ec-0969-f3b64893443e
# ╟─02d5aebe-797b-11ec-352c-0f1dbccb64a2
# ╟─02d5b4b8-797b-11ec-0298-c9d9798a81f6
# ╟─02d5b4d8-797b-11ec-167c-0dcfc2c9cda4
# ╟─02d5b4fe-797b-11ec-24c8-9bc20c8d7b5d
# ╟─02d5bc4c-797b-11ec-1ca4-fdef80396970
# ╟─02d5bc60-797b-11ec-065d-3fbbec405e2d
# ╟─02d5bc7e-797b-11ec-04f4-eb6906275513
# ╟─02d5c0ac-797b-11ec-0875-e5db32796931
# ╟─02d5c0d4-797b-11ec-09ba-11c83796b21a
# ╟─02d5c0fc-797b-11ec-26be-87210f603b3a
# ╟─02d5ef00-797b-11ec-1ae8-3939580eca58
# ╟─02d5ef28-797b-11ec-2847-f705388d89c3
# ╟─02d5f98c-797b-11ec-13fa-6931c255d836
# ╟─02d5f9aa-797b-11ec-1341-a15d33549624
# ╟─02d5f9dc-797b-11ec-2c27-859e47e8ee33
# ╟─02d5fde2-797b-11ec-3cfe-47cb9fbe9d6f
# ╟─02d5fe0a-797b-11ec-0643-87cb12535942
# ╟─02d60738-797b-11ec-05b1-736e1194a783
# ╟─02d60760-797b-11ec-0d19-d9ed69465631
# ╟─02d60da0-797b-11ec-2cfc-d3bc03007748
# ╟─02d60dc8-797b-11ec-03c4-3b5b2a80cd83
# ╟─02d60dfa-797b-11ec-08af-a10ff2c0f0d5
# ╟─02d6151e-797b-11ec-3764-5b82f1e1c5e3
# ╟─02d6153e-797b-11ec-300c-21508134389b
# ╟─02d615c0-797b-11ec-2172-3f02073c8a8a
# ╟─02d615de-797b-11ec-0a95-9b9575eb39e2
# ╟─02d61a52-797b-11ec-11a3-27f454b93f71
# ╟─02d61a7a-797b-11ec-21ba-bff9e625b307
# ╟─02d61f0c-797b-11ec-2ebb-39c0b3cbf900
# ╟─02d61f34-797b-11ec-1252-cfeff189f063
# ╟─02d6238a-797b-11ec-07e0-8b546525052b
# ╟─02d623a0-797b-11ec-003f-a9c7db84b43b
# ╟─02d623d2-797b-11ec-34b9-d927ec194dd2
# ╟─02d62768-797b-11ec-12b6-d1356002461e
# ╟─02d6277c-797b-11ec-2530-bb47d834e895
# ╟─02d627a6-797b-11ec-3646-15bde376a73b
# ╟─02d627c2-797b-11ec-1282-738ff6b82c31
# ╟─02d630b4-797b-11ec-05c2-d3ee5d46f687
# ╟─02d630da-797b-11ec-38ef-730af2ae01e7
# ╟─02d6399c-797b-11ec-28f8-41f8f0fa3904
# ╟─02d639c4-797b-11ec-18b6-5b10366cc331
# ╟─02d639ee-797b-11ec-31e9-09c3788adff8
# ╟─02d6439c-797b-11ec-354f-1391f1f70d9e
# ╟─02d643c2-797b-11ec-2024-537e73219f5f
# ╟─02d64e14-797b-11ec-28ba-25cdfbca1fac
# ╟─02d64e32-797b-11ec-3a34-6522108254c9
# ╟─02d64e64-797b-11ec-3fbd-1de570d2cc9e
# ╟─02d655e4-797b-11ec-373f-e339ebdda465
# ╟─02d655f8-797b-11ec-2cc8-4145911a3762
# ╟─02d65bca-797b-11ec-0f4c-dd7d2bbe7b9c
# ╟─02d65bf2-797b-11ec-1fc6-e5eb73a90017
# ╟─02d662f2-797b-11ec-11d8-07b0e4258d40
# ╟─02d66320-797b-11ec-1931-f98ef237c214
# ╟─02d668a4-797b-11ec-1d7d-056f735047db
# ╟─02d668d6-797b-11ec-2680-4dec005c13ff
# ╟─02d66e76-797b-11ec-0efd-3d1be79006eb
# ╟─02d66e92-797b-11ec-19e7-e564bb90b306
# ╟─02d66ebc-797b-11ec-3236-45f006c1e936
# ╟─02d66ee4-797b-11ec-2d5c-7d4ae78e4053
# ╟─02d66ef8-797b-11ec-23d4-891a6dd37b7c
# ╟─02d66f04-797b-11ec-068f-9dd590d35054
# ╟─02d66f16-797b-11ec-3519-2b6710e49268
# ╟─02d66f3e-797b-11ec-33bd-bd969854ba68
# ╟─02d66f52-797b-11ec-00af-017c8a79330f
# ╟─02d675f6-797b-11ec-2fbf-ad07f0c9816c
# ╟─02d6761e-797b-11ec-0331-e1f58d9cda1a
# ╟─02d67d62-797b-11ec-2161-979dc98ef832
# ╟─02d67d74-797b-11ec-3da9-8d2ccbaf52cf
# ╟─02d693e2-797b-11ec-0895-b3ca5852d763
# ╟─02d69428-797b-11ec-300c-5755160f965a
# ╟─02d6945a-797b-11ec-0eef-af6aa9c6eef6
# ╟─02d69478-797b-11ec-1f38-01537a9b8406
# ╟─02d69494-797b-11ec-3245-e7c948c8296f
# ╟─02d695e0-797b-11ec-02f6-955d2f650807
# ╟─02d6a17a-797b-11ec-04a7-9304d8b178fd
# ╟─02d6a21a-797b-11ec-02ed-7d52cc5a1ef6
# ╟─02d6aa94-797b-11ec-1065-1136626da55d
# ╟─02d6ab02-797b-11ec-0d78-4b967a72650e
# ╟─02d6b4ee-797b-11ec-077e-936c48d9f23b
# ╟─02d6b548-797b-11ec-1a71-5f9c23d6f750
# ╟─02d6c13e-797b-11ec-0cf9-13718ff844df
# ╟─02d6c182-797b-11ec-1e88-9947eaeceaf1
# ╟─02d6c196-797b-11ec-3bc8-bdcfe94955f8
# ╟─02d6c1e6-797b-11ec-0648-09c5800f92c6
# ╟─02d6c1fa-797b-11ec-26ae-65eb868d1bcb
# ╟─02d6d9a6-797b-11ec-0cf3-6d2d756441bd
# ╟─02d6d9e2-797b-11ec-0f8f-3574526b24d2
# ╟─02d6d9f8-797b-11ec-21fd-a9cc6c60f007
# ╟─02d6da00-797b-11ec-0eaa-d3acbb93d9a2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
