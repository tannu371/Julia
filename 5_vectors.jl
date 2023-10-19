### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 5e7f9bc8-53c2-11ec-056c-7f1ce73948e1
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using Plots
	using Measures
	using LaTeXStrings
	gr()
	fig_size = (400, 300)
	__DIR__, __FILE__ = :precalc, :vectors
	nothing
end

# ╔═╡ 5e86a76c-53c2-11ec-397d-69e2b18b205f
using PlutoUI

# ╔═╡ 5e86a742-53c2-11ec-115f-7fa8979d182c
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 5e7f7dd2-53c2-11ec-0729-15e8fd5f9fef
md"""# Vectors
"""

# ╔═╡ 5e7f9c72-53c2-11ec-21eb-49d79839f362
md"""One of the first models learned in physics are the equations governing the laws of motion with constant acceleration: $x(t) = x_0 + v_0 t + 1/2 \cdot a t^2$. This is a consequence of Newton's second [law](http://tinyurl.com/8ylk29t) of motion applied to the constant acceleration case. A related formula for the velocity is $v(t) = v_0 + at$. The following figure is produced using these formulas applied to both the vertical position and the horizontal position:
"""

# ╔═╡ 5e7fa244-53c2-11ec-3322-d16a91eff16f
md"""For the motion in the above figure, the object's $x$ and $y$ values change according to the same rule, but, as the acceleration is different in each direction, we get different formula, namely: $x(t) = x_0 + v_{0x} t$ and $y(t) = y_0 + v_{0y}t - 1/2 \cdot gt^2$.
"""

# ╔═╡ 5e7fa28a-53c2-11ec-3bc0-fb587c0c2f96
md"""It is common to work with *both* formulas at once. Mathematically, when graphing, we naturally pair off two values using Cartesian coordinates (e.g., $(x,y)$). Another means of combining related values is to use a *vector*. The notation for a vector varies, but to distinguish them from a point we will use $\langle x,~ y\rangle$. With this notation, we can use it to represent the position, the velocity, and the acceleration at time $t$ through:
"""

# ╔═╡ 5e7fa2b2-53c2-11ec-19d9-27b93eed235a
md"""```math
\begin{align}
\vec{x} &= \langle x_0 + v_{0x}t,~ -(1/2) g t^2 + v_{0y}t  + y_0 \rangle,\\
\vec{v} &= \langle v_{0x},~ -gt + v_{0y} \rangle, \text{ and }\\
\vec{a} &= \langle 0,~ -g \rangle.
\end{align}
```
"""

# ╔═╡ 5e7fa2d0-53c2-11ec-389e-a166f4ae6227
md"""Don't spend time thinking about the formulas if they are unfamiliar. The point emphasized here is that we have used the notation $\langle x,~ y \rangle$ to collect the two values into a single object, which we indicate through a label on the variable name. These are vectors, and we shall see they find use far beyond this application.
"""

# ╔═╡ 5e7fa2e4-53c2-11ec-14fd-3dc22a99f656
md"""Initially, our primary use of vectors will be as containers, but it is worthwhile to spend some time to discuss properties of vectors and their visualization.
"""

# ╔═╡ 5e7fa334-53c2-11ec-117d-09e95154aac8
md"""A line segment in the plane connects two points $(x_0, y_0)$ and $(x_1, y_1)$. The length of a line segment (its magnitude) is given by the distance formula $\sqrt{(x_1 - x_0)^2 + (y_1 - y_0)^2}$.  A line segment can be given a direction by assigning an initial point and a terminal point. A directed line segment has both a direction and a magnitude. A vector is an abstraction where just these two properties $-$ a **direction** and a **magnitude** $-$ are intrinsic. While a directed line segment can be represented by a vector, a single vector describes all such line segments found by translation. That is, how the the vector is located when visualized is for convenience, it is not a characteristic of the vector. In the figure above, all vectors are drawn with their tails at the position of the projectile over time.
"""

# ╔═╡ 5e7fa350-53c2-11ec-11ab-f37a3bd001c9
md"""We can visualize a (two-dimensional) vector as an arrow in space. This arrow has two components. We represent a vector mathematically as $\langle x,~ y \rangle$. For example, the vector connecting the point $(x_0, y_0)$ to $(x_1, y_1)$ is $\langle x_1 - x_0,~ y_1 - y_0 \rangle$.
"""

# ╔═╡ 5e7fa366-53c2-11ec-02df-8f4a800e1081
md"""The magnitude of a vector comes from the distance formula applied to a line segment, and is $\| \vec{v} \| = \sqrt{x^2 + y^2}$.
"""

# ╔═╡ 5e7fa7da-53c2-11ec-3778-d9e0622ae064
md"""We call the values $x$ and $y$ of the vector $\vec{v} = \langle x,~ y \rangle$ the components of the $v$.
"""

# ╔═╡ 5e7fa7ee-53c2-11ec-2b5b-f9fc7a353a83
md"""Two operations on vectors are fundamental.
"""

# ╔═╡ 5e7fc118-53c2-11ec-19f0-619c6a9f8256
md"""  * Vectors can be multiplied by a scalar (a real number): $c\vec{v} = \langle cx,~ cy \rangle$. Geometrically this scales the vector by a factor of $\lvert c \rvert$ and switches the direction of the vector by 180 degrees (in the $2$-dimensional case) when $c < 0$. A *unit vector* is one with magnitude 1, and, except for the $\vec{0}$ vector, can be formed from $\vec{v}$ by dividing $\vec{v}$ by its magnitude. A vector's two parts are summarized by its direction given by a unit vector gives and its norm given by the magnitude.
"""

# ╔═╡ 5e7fc1de-53c2-11ec-2688-a18a0a27daf0
md"""  * Vectors can be added: $\vec{v} + \vec{w} = \langle v_x + w_x,~ v_y + w_y \rangle$. That is, each corresponding component adds to form a new vector. Similarly for subtraction. The $\vec{0}$ vector then would be just $\langle 0,~ 0 \rangle$ and would satisfy $\vec{0} + \vec{v} = \vec{v}$ for any vector $\vec{v}$. The vector addition $\vec{v} + \vec{w}$ is visualized by placing the tail of $\vec{w}$ at the tip of $\vec{v}$ and then considering the new vector with tail coming from $\vec{v}$ and tip coming from the position of the tip of $\vec{w}$. Subtraction is different, place both the tails of $\vec{v}$ and $\vec{w}$ at the same place and the new vector has tail at the tip of $\vec{v}$ and tip at the tip of $\vec{w}$.
"""

# ╔═╡ 5e7fc6d4-53c2-11ec-1e3d-b190ed9677b7
let
	## vector_addition_image
	
	p0 = [0,0]
	a1 = [4,1]
	b1 = [-2,2]
	
	
	plt = Plots.plot(legend=false, size=fig_size)
	arrow!(p0, a1, color="blue")
	arrow!(p0+a1, b1, color="red")
	arrow!(p0, a1+b1, color="black")
	annotate!([(2, .25, L"a"), (3, 2.25, L"b"), (1.35, 1.5, L"a+b")])
	
	imgfile = tempname() * ".png"
	png(plt, imgfile)
	
	caption = "The sum of two vectors can be visualized by placing the tail of one at the tip of the other"
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e7fcc92-53c2-11ec-1deb-af04572c1e61
let
	## vector_subtraction_image
	
	p0 = [0,0]
	a1 = [4,1]
	b1 = [-2,2]
	
	plt = plot(legend=false, size=fig_size)
	arrow!(p0, a1, color="blue")
	arrow!(p0, b1, color="red")
	arrow!(b1, a1-b1, color="black")
	annotate!(plt, [(-1, .5, L"a"), (2.45, .5, L"b"), (1, 1.75, L"a-b")])
	
	
	imgfile = tempname() * ".png"
	png(plt, imgfile)
	
	caption = "The difference of two vectors can be visualized by placing the tail of one at the tip of the other"
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e7fcd0a-53c2-11ec-2add-4540a8611196
md"""The concept of scalar multiplication and addition, allow the decomposition of vectors into standard vectors. The standard unit vectors in two dimensions are $e_x = \langle 1,~ 0 \rangle$ and $e_y = \langle 0,~ 1 \rangle$. Any two dimensional vector can be written uniquely as $a e_x + b e_y$ for some pair of scalars $a$ and $b$ (or as, $\langle a, b \rangle$). This is true more generally where the two vectors are not the standard unit vectors - they can be *any* two non-parallel vectors.
"""

# ╔═╡ 5e7fd138-53c2-11ec-1e13-6d4713105453
let
	### {{{vector_decomp}}}
	
	p0 = [0,0]
	aa = [1,2]
	bb = [2,1]
	cc = [4,3]
	alpha = 2/3
	beta = 5/3
	
	plt = plot(legend=false, size=fig_size)
	arrow!(p0, cc, color="black", width=1)
	arrow!(p0, aa, color="black", width=1)
	arrow!(alpha*aa, bb, color="black", width=1)
	arrow!(p0, alpha*aa, color="orange", width=4, opacity=0.5)
	arrow!(alpha*aa, beta*bb, color="orange", width=4, opacity=0.5)
	#annotate!(collect(zip([2, .5, 1.75], [1.25,1.0,2.25], [L"c",L"2/3 \cdot a", L"5/3 \cdot b"])))
	
	
	imgfile = tempname() * ".png"
	png(plt, imgfile)
	
	caption = L"""
	
	The vector $\langle 4,3 \rangle$ is written as
	$2/3 \cdot\langle 1,2 \rangle + 5/3 \cdot\langle 2,1 \rangle$. Any vector $\vec{c}$ can be
	written uniquely as $\alpha\cdot\vec{a} + \beta \cdot \vec{b}$ provided
	$\vec{a}$ and $\vec{b}$ are not parallel.
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e7fd156-53c2-11ec-3353-f930db261abb
md"""The two operations of scalar multiplication and vector addition are defined in a component-by-component basis. We will see that there are many other circumstances where performing the same action on each component in a vector is desirable.
"""

# ╔═╡ 5e7fffbe-53c2-11ec-3adc-19af702d9a02
md"""---
"""

# ╔═╡ 5e80000e-53c2-11ec-1532-691069d91ff2
md"""When a vector is placed with its tail at the origin, it can be described in terms of the angle it makes with the $x$ axis, $\theta$, and its length, $r$. The following formulas apply:
"""

# ╔═╡ 5e800038-53c2-11ec-2598-a15bdd14a754
md"""```math
r = \sqrt{x^2 + y^2}, \quad \tan(\theta) = y/x.
```
"""

# ╔═╡ 5e80005e-53c2-11ec-0aa2-834b0c475559
md"""If we are given $r$ and $\theta$, then the vector is $v = \langle r \cdot \cos(\theta),~ r \cdot \sin(\theta) \rangle$.
"""

# ╔═╡ 5e8004f0-53c2-11ec-0243-f5548b079763
let
	## vector_rtheta
	p0 = [0,0]
	
	plt = plot(legend=false, size=fig_size)
	arrow!(p0, [2,3], color="black")
	arrow!(p0, [2,0], color="orange")
	arrow!(p0+[2,0], [0,3], color="orange")
	annotate!(plt, collect(zip([.25, 1,1,1.75], [.35, 1.9,.25,1], [L"t",L"r", L"r \cdot \cos(t)", L"r \cdot \sin(t)"]))) #["θ","r", "r ⋅ cos(θ)", "r ⋅ sin(θ)"]
	
	imgfile = tempname() * ".png"
	png(plt, imgfile)
	
	caption = raw"""
	
	A vector ``\langle x, y \rangle`` can be written as ``\langle r\cdot
	\cos(\theta), r\cdot\sin(\theta) \rangle`` for values ``r`` and
	``\theta``. The value ``r`` is a magnitude, the direction parameterized by
	``\theta``."""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e800522-53c2-11ec-02a1-419d4dcc77bb
md"""## Vectors in Julia
"""

# ╔═╡ 5e800554-53c2-11ec-0638-1b301120aa40
md"""A vector in `Julia` can be represented by its individual components, but it is more convenient to combine them into a collection using the `[,]` notation:
"""

# ╔═╡ 5e800a36-53c2-11ec-2af8-7967e1222fb7
begin
	x, y = 1, 2
	v = [x, y]        # square brackets, not angles
end

# ╔═╡ 5e800a5e-53c2-11ec-0065-e9a89c5ae426
md"""The basic vector operations are implemented for vector objects. For example, the vector `v` has scalar multiplication defined for it:
"""

# ╔═╡ 5e800cae-53c2-11ec-08a1-c3f6f0c36728
10 * v

# ╔═╡ 5e800cd4-53c2-11ec-137a-cd5b3fcd73b5
md"""The `norm` function returns the magnitude of the vector (by default):
"""

# ╔═╡ 5e800e6e-53c2-11ec-1771-87442b05bfae
import LinearAlgebra: norm

# ╔═╡ 5e7fa212-53c2-11ec-0c3f-b92e157bad61
let
	px = 0.26mm
	x0 = [0, 64]
	v0 = [20, 0]
	g  = [0, -32]
	
	unit(v::Vector) = v / norm(v)
	x_ticks = collect(0:10:80)
	y_ticks = collect(0:10:80)
	
	
	function make_plot(t)
	
	    xn = (t) -> x0 + v0*t + 1/2*g*t^2
	    vn = (t) -> v0 + g*t
	    an = (t) -> g
	
	
	    t = 1/10 + t*2/10
	
	    ts = range(0, stop=2, length=100)
	    xys = map(xn, ts)
	
	    xs, ys = [p[1] for p in xys], [p[2] for p in xys]
	
	    plt = Plots.plot(xs, ys, legend=false, size=fig_size, xlims=(0,45), ylims=(0,70))
	    plot!(plt, zero, extrema(xs)...)
	    arrow!(xn(t), 10*unit(xn(t)), color="black")
	    arrow!(xn(t), 10*unit(vn(t)), color="red")
	    arrow!(xn(t), 10*unit(an(t)), color="green")
	
	    plt
	
	
	end
	
	imgfile = tempname() * ".gif"
	caption = """
	
	Position, velocity, and acceleration vectors (scaled) for projectile
	motion. Vectors are drawn with tail on the projectile. The position
	vector (black) points from the origin to the projectile, the velocity
	vector (red) is in the direction of the trajectory, and the
	acceleration vector (green) is a constant pointing downward.
	
	"""
	
	n = 8
	anim = @animate for i=1:n
	    make_plot(i)
	end
	
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e7fa7a8-53c2-11ec-192b-1dc88f9ff452
let
	## generic vector
	p0 = [0,0]
	a1 = [4,1]
	b1 = [-2,2]
	unit(v::Vector) = v / norm(v)
	
	plt = plot(legend=false, size=fig_size)
	arrow!(p0, a1, color="blue")
	arrow!([1,1], unit(a1), color="red")
	annotate!([(2, .4, L"v"), (1.6, 1.05, L"\hat{v}")])
	
	imgfile = tempname() * ".png"
	png(plt, imgfile)
	
	caption = "A vector and its unit vector. They share the same direction, but the unit vector has a standardized magnitude."
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 5e800fde-53c2-11ec-1227-0fb549a0148f
norm(v)

# ╔═╡ 5e800ffe-53c2-11ec-17f0-5334ce40dd5b
md"""A unit vector is then found by scaling by the reciprocal of the magnitude:
"""

# ╔═╡ 5e801198-53c2-11ec-0cc4-f9e806014d6d
v / norm(v)

# ╔═╡ 5e8011b8-53c2-11ec-296e-2f60c2a1f4cb
md"""In addition, if `w` is another vector, we can add and subtract:
"""

# ╔═╡ 5e8015da-53c2-11ec-1c41-bbd133d3d521
begin
	w = [3, 2]
	v + w, v - 2w
end

# ╔═╡ 5e8015f8-53c2-11ec-0d1a-75c088fbf0f5
md"""We see above that scalar multiplication, addition, and subtraction can be done without new notation. This is because the usual operators have methods defined for vectors.
"""

# ╔═╡ 5e801634-53c2-11ec-3a72-59799e6947b9
md"""Finally, to find an angle $\theta$ from a vector $\langle x,~ y\rangle$, we can employ the `atan` function using two arguments:
"""

# ╔═╡ 5e8018a0-53c2-11ec-378b-574d4e92f2dc
norm(v), atan(y, x) # v  = [x, y]

# ╔═╡ 5e8018b4-53c2-11ec-34be-5300c60430f6
md"""## Higher dimensional vectors
"""

# ╔═╡ 5e8018c8-53c2-11ec-3cbf-bbdbc7add420
md"""Mathematically, vectors can be generalized to more than 2 dimensions. For example, using 3-dimensional vectors are common when modeling events happening in space, and 4-dimensional vectors are common when modeling space and time.
"""

# ╔═╡ 5e8018e6-53c2-11ec-360d-bfee514a0421
md"""In `Julia` there are many uses for vectors outside of physics applications. A vector in `Julia` is just a one-dimensional collection of similarly typed values. Such objects find widespread usage. For example:
"""

# ╔═╡ 5e8019d6-53c2-11ec-0aee-0516ceb86cd2
md"""  * In plotting graphs with `Julia`, vectors are used to hold the $x$ and $y$ coordinates of a collection of points to plot and connect with straight lines. There can be hundreds of such points in a plot.
  * Vectors are a natural container to hold the roots of a polynomial or zeros of a function.
  * Vectors may be used to record the state of an iterative process.
  * Vectors are naturally used to represent a data set, such as arise when collecting survey data.
"""

# ╔═╡ 5e8019ea-53c2-11ec-00da-975255413531
md"""Creating higher-dimensional vectors is similar to creating a two-dimensional vector, we just include more components:
"""

# ╔═╡ 5e803682-53c2-11ec-3fca-cfe2d84a1d74
fibs = [1,1,2,3,5,8,13]

# ╔═╡ 5e8036b4-53c2-11ec-04f8-51e71acf2341
md"""Later we will discuss different ways to modify the values of a vector to create new ones, similar to how scalar multiplication does.
"""

# ╔═╡ 5e8036d2-53c2-11ec-317b-aff635c6f242
md"""As mentioned, vectors in  `Julia`  are comprised of elements of a similar type, but the type is not limited to numeric values. For example, a vector of strings might be useful for text processing, a vector of Boolean values can naturally arise, some applications are even naturally represented in terms of vectors of vectors. Look at the output of these two vectors:
"""

# ╔═╡ 5e803b6e-53c2-11ec-262b-61fd75272faf
["one", "two", "three"]  # Array{T, 1} is shorthand for Vector{T}. Here T - the type - is String

# ╔═╡ 5e8058b0-53c2-11ec-092b-1b6c44b254e1
[true, false, true]		# vector of Bool values

# ╔═╡ 5e80595a-53c2-11ec-3ab5-b7218265bb6f
md"""Finally, we mention that if `Julia` has values of different types it will promote them to a common type if possible. Here we combine three types of numbers, and see that each is promoted to `Float64`:
"""

# ╔═╡ 5e8089f2-53c2-11ec-0d64-b1eeb1396696
[1, 2.0, 3//1]

# ╔═╡ 5e808a42-53c2-11ec-0ed9-79b6fe4be666
md"""Whereas, in this example where there is no common type to promote the values to, a catch-all type of `Any` is used to hold the components.
"""

# ╔═╡ 5e808fa6-53c2-11ec-3c30-45e8001aa4b7
["one", 2, 3.0, 4//1]

# ╔═╡ 5e808fe2-53c2-11ec-2ac6-df0546fd468c
md"""## Indexing
"""

# ╔═╡ 5e809000-53c2-11ec-2376-1fb690160771
md"""Getting the components out of a vector can be done in a manner similar to multiple assignment:
"""

# ╔═╡ 5e809488-53c2-11ec-25d7-996484034400
begin
	vs = [1, 2]
	v₁, v₂ = vs
end

# ╔═╡ 5e8094a6-53c2-11ec-2b81-192778ebb423
md"""When the same number of variable names are on the left hand side of the assignment as in the container on the right, each is assigned in order.
"""

# ╔═╡ 5e809500-53c2-11ec-3a10-eb1dfe160f45
md"""Though this is convenient for small vectors, it is far from being so if the vector has a large number of components. However, the vector is stored in order with a first, second, third, $\dots$ component. `Julia` allows these values to be referred to by *index*. This too uses the `[]` notation, though differently. Here is how we get the second component of `vs`:
"""

# ╔═╡ 5e8096ae-53c2-11ec-16e5-fb5de58edd37
vs[2]

# ╔═╡ 5e8096f4-53c2-11ec-17c1-179e3fd4ba97
md"""The last value of a vector is usually denoted by $v_n$. In `Julia`, the `length` function will return $n$, the number of items in the container. So `v[length(v)]` will refer to the last component. However, the special keyword `end` will do so as well, when put into the context of indexing. So `v[end]` is more idiomatic. (Similarly, there is a `begin` keyword that is useful when the vector is not $1$-based, as is typical but not mandatory.)
"""

# ╔═╡ 5e80c0a2-53c2-11ec-3a6a-ebf0288e8f23
note("""
There is [much more](http://julia.readthedocs.org/en/latest/manual/arrays/#indexing)
to indexing than just indexing by a single integer value. For example, the following can be used for indexing:

* a scalar integer (as seen)

* a range

* a vector of integers

* a boolean vector

Some add-on packages extend this further.
""",
title="More on indexing", label="More on indexing")

# ╔═╡ 5e80c0fc-53c2-11ec-1ac9-416f8e60ca2c
md"""### Assignment and indexing
"""

# ╔═╡ 5e80c11a-53c2-11ec-3499-8ddd6f1924d8
md"""This notation can also be used for assignment. The following expression replaces the second component with a new value:
"""

# ╔═╡ 5e80c3ea-53c2-11ec-1fed-955aae7032cd
vs[2] = 10

# ╔═╡ 5e80c430-53c2-11ec-33d8-a9d270c016c0
md"""The right hand side is returned, not the value for `vs`. We can check that `vs` is then $\langle 1,~ 10 \rangle$ by showing it:
"""

# ╔═╡ 5e80c818-53c2-11ec-0d38-f1100818b190
let
	vs = [1,2]
	vs[2] = 10
	vs
end

# ╔═╡ 5e80c87c-53c2-11ec-273b-e5ddbc6036ea
md"""The assignment `vs[2]` is different than the initial assignment `vs=[1,2]` in that, `vs[2]=10` **modifies** the container that `vs` points to, whereas `v=[1,2]` **replaces** the binding for `vs`. The indexed assignment is then more memory efficient when vectors are large. This point is also of interest when passing vectors to functions, as a function may modify components of the vector passed to it, though can't replace the container itself.
"""

# ╔═╡ 5e80c890-53c2-11ec-14e2-c954f1a96edb
md"""## Some  useful  functions for working with vectors.
"""

# ╔═╡ 5e80c8ae-53c2-11ec-10a9-e7b9935e23df
md"""As mentioned, the `length` function returns the number of components in a vector. It is one of several useful functions for vectors.
"""

# ╔═╡ 5e80c8cc-53c2-11ec-1ecb-c3378c9d5fe9
md"""The `sum` and `prod` function will add and multiply the elements in a vector:
"""

# ╔═╡ 5e80cfd4-53c2-11ec-1189-85456d37f1e8
begin
	v1 = [1,1,2,3,5,8]
	sum(v1), prod(v1)
end

# ╔═╡ 5e80cffc-53c2-11ec-1e3d-c98e75124b46
md"""The `unique` function will throw out any duplicates:
"""

# ╔═╡ 5e80d1dc-53c2-11ec-3bc0-dbd44fb52f0b
unique(v1) # drop a `1`

# ╔═╡ 5e80d204-53c2-11ec-15c2-9903c1d5521e
md"""The functions `maximum` and `minimum` will return the largest and smallest values of an appropriate vector.
"""

# ╔═╡ 5e80d326-53c2-11ec-3953-abe6896e489c
maximum(v1)

# ╔═╡ 5e80d344-53c2-11ec-11fe-6da9a2a7231b
md"""(These should not be confused with `max` and `min` which give the largest or smallest value over all their arguments.)
"""

# ╔═╡ 5e80d358-53c2-11ec-1dbd-6fe0eb1db20b
md"""The `extrema` function returns both the smallest and largest value of a collection:
"""

# ╔═╡ 5e80d4a2-53c2-11ec-3e8f-4b69d42b2f76
extrema(v1)

# ╔═╡ 5e80d4ac-53c2-11ec-0270-65888e86bbcb
md"""Consider now
"""

# ╔═╡ 5e80d86c-53c2-11ec-072c-7d17d605a771
𝒗 = [1,4,2,3]

# ╔═╡ 5e80d894-53c2-11ec-135e-75fe971e746e
md"""The `sort` function will rearrange the values in `𝒗`:
"""

# ╔═╡ 5e80d9ca-53c2-11ec-39aa-e552977f1fa1
sort(𝒗)

# ╔═╡ 5e80d9f4-53c2-11ec-2922-1b098ae158c9
md"""The keyword argument, `rev=false` can be given to get values in decreasing order:
"""

# ╔═╡ 5e80dc9a-53c2-11ec-0adb-ff002bd6efdf
sort(𝒗, rev=false)

# ╔═╡ 5e80dcb8-53c2-11ec-05f8-3dd09bd00ff9
md"""For adding a new element to a vector the `push!` method can be used, as in
"""

# ╔═╡ 5e80de70-53c2-11ec-3a15-f5573eceed35
push!(𝒗, 5)

# ╔═╡ 5e80de90-53c2-11ec-0c3d-5d20a2fa5064
md"""To append more than one value, the `append!` function can be used:
"""

# ╔═╡ 5e80e15c-53c2-11ec-3604-c950e4848e5a
append!(v1, [6,8,7])

# ╔═╡ 5e80e19a-53c2-11ec-204a-77c63a4a3800
md"""These two functions modify or mutate the values stored within the vector `𝒗` that passed as an argument. In the `push!` example above, the value `5` is added to the vector of 4 elements. In `Julia`, a convention is to name mutating functions with a trailing exclamation mark. (Again, these do not mutate the binding of `𝒗` to the container, but do mutate the contents of the container.) There are functions with mutating and non-mutating definitions, an example is `sort` and `sort!`.
"""

# ╔═╡ 5e80e1c0-53c2-11ec-0aba-175a0c7d7eb2
md"""If only a mutating function is available, like `push!`, and this is not desired a copy of the vector can be made. It is not enough to copy by assignment, as with `w = 𝒗`. As both `w` and `𝒗` will be bound to the same memory location. Rather, you call `copy` to make a new container with copied contents, as in `w = copy(𝒗)`.
"""

# ╔═╡ 5e80e1e0-53c2-11ec-3d62-25ea142f9819
md"""Creating new vectors of a given size is common for programming, though not much use will be made here. There are many different functions to do so: `ones` to make a vector of ones, `zeros` to make a vector of zeros, `trues` and `falses` to make Boolean vectors of a given size, and `similar` to make a similar-sized vector (with no particular values assigned).
"""

# ╔═╡ 5e80e1f4-53c2-11ec-02f0-4f497dc4e71b
md"""## Applying functions element by element to values in a vector
"""

# ╔═╡ 5e80e23a-53c2-11ec-2a53-73ef5d5e7e09
md"""Functions such as `sum` or `length` are known as *reductions* as they reduce the "dimensionality" of the data: a vector is in some sense $1$-dimensional, the sum or length are $0$-dimensional numbers.  Applying a reduction is straightforward – it is just a regular function call.
"""

# ╔═╡ 5e80f734-53c2-11ec-1196-89791df66515
let
	v = [1, 2, 3, 4]
	sum(v), length(v)
end

# ╔═╡ 5e80f7a2-53c2-11ec-143c-955d943cf6c9
md"""Other desired operations with vectors act differently. Rather than reduce a collection of values using some formula, the goal is to apply some formula to *each* of the values, returning a modified vector. A simple example might be to square each element, or subtract the average value from each element. An example comes from statistics. When computing a variance, we start with data $x_1, x_2, \dots, x_n$ and along the way form the values $(x_1-\bar{x})^2, (x_2-\bar{x})^2, \dots, (x_n-\bar{x})^2$.
"""

# ╔═╡ 5e80f7c0-53c2-11ec-1641-0b81683eea1b
md"""Such things can be done in *many* differents ways. Here we describe two, but will primarily utilize the first.
"""

# ╔═╡ 5e80f7d4-53c2-11ec-3528-73c16fd8d25e
md"""### Broadcasting a function call
"""

# ╔═╡ 5e80f806-53c2-11ec-16ed-aba2e58228c7
md"""If we have a vector, `xs`, and a function, `f`, to apply to each value, there is a simple means to achieve this task. By adding a "dot" between the function name and the parenthesis that enclose the arguments, instructs `Julia` to "broadcast" the function call. The details allow for more flexibility, for this purpose, broadcasting will take each value in `xs` and apply `f` to it, returning a vector of the same size as `xs`. When more than one argument is involved, broadcasting will try to fill out different sized objects.
"""

# ╔═╡ 5e80f824-53c2-11ec-0e57-4f400a3312ed
md"""For example, the following will find,  using `sqrt`, the square root each value in a vector:
"""

# ╔═╡ 5e80fd88-53c2-11ec-2751-41ed6e8ff8de
begin
	xs = [1, 1, 3, 4, 7]
	sqrt.(xs)
end

# ╔═╡ 5e80fdb0-53c2-11ec-1b17-49f4f16d9adb
md"""This would find the sine of each number in `xs`:
"""

# ╔═╡ 5e80ff4a-53c2-11ec-1e24-c778223002c0
sin.(xs)

# ╔═╡ 5e80ff7c-53c2-11ec-2f99-ed86771eea07
md"""For each function, the `.(` (and not `(`) after the name is the surface syntax for broadcasting.
"""

# ╔═╡ 5e80ffa4-53c2-11ec-07cd-77110798e6d0
md"""The `^` operator is an *infix* operator. Infix operators can be broadcast, as well, by using the form `.` prior to the operator, as in:
"""

# ╔═╡ 5e812e3e-53c2-11ec-20f1-8fffce0a5dc9
xs .^ 2

# ╔═╡ 5e812eca-53c2-11ec-129b-b9154f924d59
md"""Here is an example involving the logarithm of a set of numbers. In astronomy, a logarithm with base $100^{1/5}$ is used for star [brightness](http://tinyurl.com/ycp7k8ay). We can use broadcasting to find this value for several values at once through:
"""

# ╔═╡ 5e813924-53c2-11ec-169e-db1264ce5874
begin
	ys = [1/5000, 1/500, 1/50, 1/5, 5, 50]
	base = (100)^(1/5)
	log.(base, ys)
end

# ╔═╡ 5e813942-53c2-11ec-37d5-5177fd59656b
md"""Broadcasting with multiple arguments allows for mixing of vectors and scalar values, as above, making it convenient when parameters are used.
"""

# ╔═╡ 5e813974-53c2-11ec-3ea3-0391770c2c4b
md"""As a final example, the task from statistics of centering and then squaring can be done with broadcasting. We go a bit further, showing how to compute the (unbiased) [sample variance](http://tinyurl.com/p6wa4r8) of a data set. This has the formula
"""

# ╔═╡ 5e8139a6-53c2-11ec-1cc5-d1b8d55aa3ba
md"""```math
\frac{1}{n-1}\cdot ((x_1-\bar{x})^2 + \cdots + (x_n - \bar{x})^2).
```
"""

# ╔═╡ 5e8139ba-53c2-11ec-1887-93b5aa5c1ca2
md"""This can be computed, with broadcasting, through:
"""

# ╔═╡ 5e813d3c-53c2-11ec-32fb-a3ff03c54291
let
	import Statistics: mean
	xs = [1, 1, 2, 3, 5, 8, 13]
	n = length(xs)
	(1/(n-1)) * sum(abs2.(xs .- mean(xs)))
end

# ╔═╡ 5e813d8e-53c2-11ec-168d-4f16f91a2f2d
md"""This shows many of the manipulations that can be made with vectors. Rather than write `.^2`, we follow the  defintion of `var` and chose the possibly more performant `abs2` function which, in general, efficiently finds $|x|^2$ for various number types. The `.-` uses broadcasting to subtract a scalar (`mean(xs)`) from a vector (`xs`). Without the `.`, this would error.
"""

# ╔═╡ 5e814edc-53c2-11ec-24eb-4d2a9f8ad889
note("""The `map` function is very much related to broadcasting and similarly named functions are found in many different programming languages. (The "dot" broadcast is mostly limited to `Julia` and mirrors on a similar usage of a dot in `MATLAB`.) For those familiar with other programming languages, using `map` may seem more natural. Its syntax is `map(f, xs)`.
""")

# ╔═╡ 5e814f04-53c2-11ec-153e-6d42b0a67081
md"""### Comprehensions
"""

# ╔═╡ 5e814f18-53c2-11ec-2c45-17e627c037f6
md"""In mathematics, set notation is often used to describe elements in a set.
"""

# ╔═╡ 5e814f2c-53c2-11ec-1626-ede36a2bcb54
md"""For example, the first $5$ cubed numbers can be described by:
"""

# ╔═╡ 5e814f40-53c2-11ec-0120-7f556752759c
md"""```math
\{x^3: x \text{ in } 1, 2,\dots, 5\}
```
"""

# ╔═╡ 5e814f5e-53c2-11ec-25d4-6dfdb7be6bed
md"""Comprehension notation is similar. The above could be created in `Julia` with:
"""

# ╔═╡ 5e815486-53c2-11ec-3209-d1bb22d1e094
begin
	𝒙s = [1,2,3,4,5]
	[x^3 for x in 𝒙s]
end

# ╔═╡ 5e81549a-53c2-11ec-32c8-dd96b240b13c
md"""Something similar can be done more succinctly:
"""

# ╔═╡ 5e815670-53c2-11ec-253d-fb2b3e321bfa
𝒙s .^ 3

# ╔═╡ 5e815698-53c2-11ec-3eb9-3b0eb0d61562
md"""However, comprehensions have a value when more complicated expressions are desired as they work with an expression of `𝒙s`, and not a pre-defined or user-defined function.
"""

# ╔═╡ 5e8156b6-53c2-11ec-32b5-13595edd7b41
md"""Another typical example of set notation might include a condition, such as, the numbers divisible by $7$ between $1$ and $100$. Set notation might be:
"""

# ╔═╡ 5e8156cc-53c2-11ec-11ab-bb02018f16b9
md"""```math
\{x: \text{rem}(x, 7) = 0 \text{ for } x \text{ in } 1, 2, \dots, 100\}.
```
"""

# ╔═╡ 5e8156e8-53c2-11ec-3459-5546c2352a48
md"""This would be read: "the set of $x$ such that the remainder on division by $7$ is $0$ for all x in $1, 2, \dots, 100$."
"""

# ╔═╡ 5e815730-53c2-11ec-0df5-d58085189c06
md"""In `Julia`, a comprehension can include an `if` clause to mirror, somewhat, the math notation. For example, the above would become (using `1:100` as a means to create the numbers $1,2,\dots, 100$, as will be described in an upcoming section):
"""

# ╔═╡ 5e8175b8-53c2-11ec-292b-e92006c3b87d
[x for x in 1:100 if rem(x,7) == 0]

# ╔═╡ 5e8175f6-53c2-11ec-0a37-9d70988355b5
md"""Comprehensions can be a convenient means to describe a collection of numbers, especially when no function is defined, but the simplicity of the broadcast notation (just adding a judicious ".") leads to its more common use in these notes.
"""

# ╔═╡ 5e817632-53c2-11ec-09a5-b9c4d9a79f8e
md"""##### Example: creating a "T" table for creating a graph
"""

# ╔═╡ 5e817678-53c2-11ec-28a2-c7e2360f3dea
md"""The process of plotting a function is usually first taught by generating a "T" table: values of $x$ and corresponding values of $y$. These pairs are then plotted on a Cartesian grid and the points are connected with lines to form the graph. Generating a "T" table in `Julia` is easy: create the $x$ values, then create the $y$ values for each $x$.
"""

# ╔═╡ 5e8176a0-53c2-11ec-38d3-6178d1e63a0e
md"""To be concrete, let's generate $7$ points to plot $f(x) = x^2$ over $[-1,1]$.
"""

# ╔═╡ 5e8176b4-53c2-11ec-1bb8-afb00e81b189
md"""The first task is to create the data. We will soon see more convenient ways to generate patterned data, but for now, we do this by hand:
"""

# ╔═╡ 5e817d1c-53c2-11ec-0dea-994c0634ffdf
begin
	a,b, n = -1, 1, 7
	d = (b-a) // (n-1)
	𝐱s = [a, a+d, a+2d, a+3d, a+4d, a+5d, a+6d]  # 7 points
end

# ╔═╡ 5e817d4e-53c2-11ec-2d94-67a786bf596c
md"""To get the corresponding $y$ values, we can use a compression (or define a function and broadcast):
"""

# ╔═╡ 5e8181ae-53c2-11ec-0a60-25f3473fef08
𝐲s = [x^2 for x in 𝐱s]

# ╔═╡ 5e8181ce-53c2-11ec-0e09-fbb9b51af419
md"""Vectors can be compared together by combining them into a separate container, as follows:
"""

# ╔═╡ 5e819b8c-53c2-11ec-08a6-b342809c06cd
[𝐱s 𝐲s]

# ╔═╡ 5e819be4-53c2-11ec-38e7-3922f128433c
md"""(If there is a space between objects they are horizontally combined. In our construction of vectors using `[]` we used a comma for vertical combination. More generally we should use a `;` for vertical concatenation.)
"""

# ╔═╡ 5e819bf8-53c2-11ec-37cc-491a1b031d97
md"""In the sequel, we will typically use broadcasting for this task using two steps: one to define a function the second to broadcast it.
"""

# ╔═╡ 5e85ee06-53c2-11ec-0894-393dbbe40b89
note(L"""

The style generally employed here is to use plural variable names for a collection
of values, such as the vector of $y$ values and singular names when a
single value is being referred to, leading to expressions like "`x in xs`".

""")

# ╔═╡ 5e85ee92-53c2-11ec-0b45-7bbceb5795c8
md"""## Other container types
"""

# ╔═╡ 5e85ef46-53c2-11ec-3782-9f1f5bc861d1
md"""Vectors in `Julia` are a container, one of many different types. Another useful type for programming purposes are *tuples*. If a vector is formed by placing comma-separated values within a `[]` pair (e.g., `[1,2,3]`), a tuple is formed by placing comma-separated values withing a `()` pair. A tuple of length $1$ uses a convention of a trailing comma to distinguish it from a parethesized expression (e.g. `(1,)` is a tuple, `(1)` is just the value `1`).
"""

# ╔═╡ 5e85ef78-53c2-11ec-10a8-2910aa606e99
md"""Tuples are used in programming, as they don't typically require allocated memory to be used so they can be faster. Internal usages are for function arguments and function return types. Unlike vectors, tuples can be heterogeneous collections. (When commas are used to combine more than one output into a cell, a tuple is being used.) (Also, a big technical distinction is that tuples are also different from vectors and other containers in that tuple types are *covariant* in their parameters, not *invariant*.)
"""

# ╔═╡ 5e85ef96-53c2-11ec-2cab-2b3504e432f6
md"""Unlike vectors, tuples can have names which can be used for referencing a value, similar to indexing but possibly more convenient. Named tuples are similar to *dictionaries* which are used to associate a key (like a name) with a value.
"""

# ╔═╡ 5e85efac-53c2-11ec-2f52-3b6c77bac547
md"""For example, here a named tuple is constructed, and then its elements referenced:
"""

# ╔═╡ 5e85fa04-53c2-11ec-21d6-97fed13947e2
begin
	nt = (one=1, two="two", three=:three)  # heterogeneous values (Int, String, Symbol)
	nt.one, nt[2], n[end]                  # named tuples have name or index access
end

# ╔═╡ 5e85fa22-53c2-11ec-2ca8-e5433f8a32af
md"""## Questions
"""

# ╔═╡ 5e85fa4a-53c2-11ec-390d-1989939b3842
md"""###### Question
"""

# ╔═╡ 5e85fa72-53c2-11ec-0c8b-b1157580fbb9
md"""Which command will create the vector $\vec{v} = \langle 4,~ 3 \rangle$?
"""

# ╔═╡ 5e86031e-53c2-11ec-2d45-b5a7413bbd43
let
	choices = [
	q"v = [4,3]",
	q"v = {4, 3}",
	q"v = '4, 3'",
	q"v = (4,3)",
	q"v = <4,3>"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 5e86033c-53c2-11ec-09ee-af162edb3975
md"""###### Question
"""

# ╔═╡ 5e860350-53c2-11ec-243c-4d51b05f11c3
md"""Which command will create the vector with components "4,3,2,1"?
"""

# ╔═╡ 5e860c1a-53c2-11ec-1032-27ca95b4fbd8
let
	choices = [q"v = [4,3,2,1]", q"v = (4,3,2,1)", q"v = {4,3,2,1}", q"v = '4, 3, 2, 1'", q"v = <4,3,2,1>"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 5e860c38-53c2-11ec-01a3-255b02c896f7
md"""###### Question
"""

# ╔═╡ 5e860c56-53c2-11ec-1fff-8d826670c8c5
md"""What is the magnitude of the vector $\vec{v} = \langle 10,~ 15 \rangle$?
"""

# ╔═╡ 5e861098-53c2-11ec-3650-9b7f8e1d3df7
let
	v = [10, 15]
	val = norm(v)
	numericq(val)
end

# ╔═╡ 5e8610b6-53c2-11ec-32f8-3bb01b5cfdb5
md"""###### Question
"""

# ╔═╡ 5e8610de-53c2-11ec-3840-8980b84abf4f
md"""Which of the following is the unit vector in the direction of $\vec{v} = \langle 3,~ 4 \rangle$?
"""

# ╔═╡ 5e8617fa-53c2-11ec-3bfc-9f5598306a8f
let
	choices = [q"[3, 4]", q"[0.6, 0.8]", q"[1.0, 1.33333]", q"[1, 1]"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 5e86180c-53c2-11ec-1d0f-13fb7d167462
md"""###### Question
"""

# ╔═╡ 5e86182c-53c2-11ec-15e7-4155b2e55ca2
md"""What vector is in the same direction as $\vec{v} = \langle 3,~ 4 \rangle$ but is 10 times as long?
"""

# ╔═╡ 5e861f52-53c2-11ec-00d6-cfbdd547c13b
let
	choices = [q"[3, 4]", q"[30, 40]", q"[9.48683, 12.6491 ]", q"[10, 10]"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 5e861f66-53c2-11ec-0334-1dbfa846bcd7
md"""###### Question
"""

# ╔═╡ 5e861fa2-53c2-11ec-0ea3-bff65c2f0a59
md"""If $\vec{v} = \langle 3,~ 4 \rangle$ and $\vec{w} = \langle 1,~ 2 \rangle$  find $2\vec{v} + 5 \vec{w}$.
"""

# ╔═╡ 5e862664-53c2-11ec-269a-d14063b02fd0
let
	choices = [q"[4, 6]", q"[6, 8]", q"[11, 18]", q"[5, 10]"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5e862678-53c2-11ec-20a7-e58707c3cab2
md"""###### Question
"""

# ╔═╡ 5e8626a0-53c2-11ec-074e-639df8acdf3d
md"""Let `v` be defined by:
"""

# ╔═╡ 5e8626d2-53c2-11ec-0c6c-e5ee06348c99
md"""```
v = [1, 1, 2, 3, 5, 8, 13, 21]
```"""

# ╔═╡ 5e8626e6-53c2-11ec-07ad-cde0c82858e0
md"""What is the length of `v`?
"""

# ╔═╡ 5e862ca4-53c2-11ec-0281-418bbc88c251
let
	v = [1, 1, 2, 3, 5, 8, 13, 21]
	val = length(v)
	numericq(val)
end

# ╔═╡ 5e862ccc-53c2-11ec-0e7d-39e600b5768e
md"""What is the `sum` of `v`?
"""

# ╔═╡ 5e863276-53c2-11ec-1152-59e9deb84d3f
let
	v = [1, 1, 2, 3, 5, 8, 13, 21]
	val = sum(v)
	numericq(val)
end

# ╔═╡ 5e86329e-53c2-11ec-3c30-6d0ce567fcf3
md"""What is the `prod` of `v`?
"""

# ╔═╡ 5e865024-53c2-11ec-3881-c7a5eb91153f
let
	v = [1,1,2,3,5,8,13,21]
	val = prod(v)
	numericq(val)
end

# ╔═╡ 5e86504e-53c2-11ec-1fd4-bfb08b15a989
md"""###### Question
"""

# ╔═╡ 5e865088-53c2-11ec-1d5f-af9b666ba00b
md"""From [transum.org](http://www.transum.org/Maths/Exam/Online_Exercise.asp?Topic=Vectors).
"""

# ╔═╡ 5e865b7a-53c2-11ec-05f8-d194465b58c8
let
	#gr()
	
	p = plot(xlim=(0,10), ylim=(0,5), legend=false, framestyle=:none)
	for j in (-3):10
	    plot!(p, [j, j + 5], [0, 5*sqrt(3)], color=:blue, alpha=0.5)
	    plot!(p, [j - 5, j], [5*sqrt(3), 0], color=:blue, alpha=0.5)
	end
	for i in 1/2:1/2:3
	    plot!(p, [0,10],sqrt(3)*[i,i], color=:blue, alpha=0.5)
	end
	
	quiver!(p, [(3/2, 3/2*sqrt(3))], quiver=[(1,0)], color=:black,  linewidth=5)        # a
	quiver!(p, [(2, sqrt(3))], quiver=[(1/2,-sqrt(3)/2)], color=:black,  linewidth=5)   # b
	
	quiver!(p, [(3 + 3/2, 3/2*sqrt(3))], quiver=[(3,0)], color=:black,  linewidth=5)        # c
	quiver!(p, [(4 , sqrt(3))], quiver=[(3/2,-sqrt(3)/2)], color=:black,  linewidth=5)        # d
	quiver!(p, [(6+1/2 , sqrt(3)/2)], quiver=[(1/2, sqrt(3)/2)], color=:black,  linewidth=5)        # e
	
	delta = 1/4
	annotate!(p, [(2, 3/2*sqrt(3) -delta, L"a"),
	              (2+1/4, sqrt(3), L"b"),
	              (3+3/2+3/2, 3/2*sqrt(3)-delta, L"c"),
	              (4+3/4, sqrt(3) - sqrt(3)/4-delta, L"d"),
	              (6+3/4+delta, sqrt(3)/2 + sqrt(3)/4-delta, L"e")
	              ])
	
	
	p
end

# ╔═╡ 5e865bac-53c2-11ec-3999-45ed153bec6e
md"""The figure shows $5$ vectors.
"""

# ╔═╡ 5e865be8-53c2-11ec-0c13-cdebc58c4443
md"""Express vector **c** in terms of **a** and **b**:
"""

# ╔═╡ 5e866322-53c2-11ec-24e8-4341677f0acd
let
	choices = ["3a", "3b", "a + b", "a - b", "b-a"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 5e866354-53c2-11ec-25f8-a5c9a1eb0909
md"""Express vector **d** in terms of **a** and **b**:
"""

# ╔═╡ 5e866a70-53c2-11ec-0105-57ab4c766cd9
let
	choices = ["3a", "3b", "a + b", "a - b", "b-a"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5e866aa2-53c2-11ec-2e35-97c2b35d1a1c
md"""Express vector **e** in terms of **a** and **b**:
"""

# ╔═╡ 5e8671b4-53c2-11ec-272d-b30e047edef0
let
	choices = ["3a", "3b", "a + b", "a - b", "b-a"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ 5e8671d2-53c2-11ec-2b0f-19a4e74b768a
md"""###### Question
"""

# ╔═╡ 5e8671fa-53c2-11ec-3614-831e565e23f8
md"""If `xs=[1, 2, 3, 4]` and `f(x) = x^2` which of these will not produce the vector `[1, 4, 9, 16]`?
"""

# ╔═╡ 5e8679ca-53c2-11ec-3335-259df3d92d65
let
	choices = [q"f.(xs)", q"map(f, xs)", q"[f(x) for x in xs]", "All three of them work"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 5e8679e8-53c2-11ec-349b-e3f28d5953c1
md"""###### Question
"""

# ╔═╡ 5e867a1a-53c2-11ec-1ef6-f90787a7e393
md"""Let $f(x) = \sin(x)$ and $g(x) = \cos(x)$. In the interval $[0, 2\pi]$ the zeros of $g(x)$ are given by
"""

# ╔═╡ 5e867eb6-53c2-11ec-3d4c-7db31b012e81
zs = [pi/2, 3pi/2]

# ╔═╡ 5e867ede-53c2-11ec-084d-3d3feba847f8
md"""What construct will give the function values of $f$ at the zeros of $g$?
"""

# ╔═╡ 5e8685c8-53c2-11ec-0853-9f4fa7ed6b68
let
	choices = [q"sin(zs)", q"sin.(zs)", q"sin(.zs)", q".sin(zs)"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 5e8685e6-53c2-11ec-1aff-7bb79e1c22e6
md"""###### Question
"""

# ╔═╡ 5e868602-53c2-11ec-1840-61af27a973e5
md"""If `zs = [1,4,9,16]` which of these commands will return `[1.0, 2.0, 3.0, 4.0]`?
"""

# ╔═╡ 5e86a738-53c2-11ec-3966-d972d2d87c56
let
	choices = [
	q"sqrt(zs)",
	q"sqrt.(zs)",
	q"zs^(1/2)",
	q"zs^(1./2)"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 5e86a760-53c2-11ec-0a67-c1131f90b526
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/logical_expressions.html">◅ previous</a>  <a href="../precalc/ranges.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/vectors.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 5e86a774-53c2-11ec-0aeb-7349e5ab5780
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Measures = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
CalculusWithJulia = "~0.0.10"
LaTeXStrings = "~1.3.0"
Measures = "~0.3.1"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
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

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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
# ╟─5e86a742-53c2-11ec-115f-7fa8979d182c
# ╟─5e7f7dd2-53c2-11ec-0729-15e8fd5f9fef
# ╟─5e7f9bc8-53c2-11ec-056c-7f1ce73948e1
# ╟─5e7f9c72-53c2-11ec-21eb-49d79839f362
# ╟─5e7fa212-53c2-11ec-0c3f-b92e157bad61
# ╟─5e7fa244-53c2-11ec-3322-d16a91eff16f
# ╟─5e7fa28a-53c2-11ec-3bc0-fb587c0c2f96
# ╟─5e7fa2b2-53c2-11ec-19d9-27b93eed235a
# ╟─5e7fa2d0-53c2-11ec-389e-a166f4ae6227
# ╟─5e7fa2e4-53c2-11ec-14fd-3dc22a99f656
# ╟─5e7fa334-53c2-11ec-117d-09e95154aac8
# ╟─5e7fa350-53c2-11ec-11ab-f37a3bd001c9
# ╟─5e7fa366-53c2-11ec-02df-8f4a800e1081
# ╟─5e7fa7a8-53c2-11ec-192b-1dc88f9ff452
# ╟─5e7fa7da-53c2-11ec-3778-d9e0622ae064
# ╟─5e7fa7ee-53c2-11ec-2b5b-f9fc7a353a83
# ╟─5e7fc118-53c2-11ec-19f0-619c6a9f8256
# ╟─5e7fc1de-53c2-11ec-2688-a18a0a27daf0
# ╟─5e7fc6d4-53c2-11ec-1e3d-b190ed9677b7
# ╟─5e7fcc92-53c2-11ec-1deb-af04572c1e61
# ╟─5e7fcd0a-53c2-11ec-2add-4540a8611196
# ╟─5e7fd138-53c2-11ec-1e13-6d4713105453
# ╟─5e7fd156-53c2-11ec-3353-f930db261abb
# ╟─5e7fffbe-53c2-11ec-3adc-19af702d9a02
# ╟─5e80000e-53c2-11ec-1532-691069d91ff2
# ╟─5e800038-53c2-11ec-2598-a15bdd14a754
# ╟─5e80005e-53c2-11ec-0aa2-834b0c475559
# ╟─5e8004f0-53c2-11ec-0243-f5548b079763
# ╟─5e800522-53c2-11ec-02a1-419d4dcc77bb
# ╟─5e800554-53c2-11ec-0638-1b301120aa40
# ╠═5e800a36-53c2-11ec-2af8-7967e1222fb7
# ╟─5e800a5e-53c2-11ec-0065-e9a89c5ae426
# ╠═5e800cae-53c2-11ec-08a1-c3f6f0c36728
# ╟─5e800cd4-53c2-11ec-137a-cd5b3fcd73b5
# ╠═5e800e6e-53c2-11ec-1771-87442b05bfae
# ╠═5e800fde-53c2-11ec-1227-0fb549a0148f
# ╟─5e800ffe-53c2-11ec-17f0-5334ce40dd5b
# ╠═5e801198-53c2-11ec-0cc4-f9e806014d6d
# ╟─5e8011b8-53c2-11ec-296e-2f60c2a1f4cb
# ╠═5e8015da-53c2-11ec-1c41-bbd133d3d521
# ╟─5e8015f8-53c2-11ec-0d1a-75c088fbf0f5
# ╟─5e801634-53c2-11ec-3a72-59799e6947b9
# ╠═5e8018a0-53c2-11ec-378b-574d4e92f2dc
# ╟─5e8018b4-53c2-11ec-34be-5300c60430f6
# ╟─5e8018c8-53c2-11ec-3cbf-bbdbc7add420
# ╟─5e8018e6-53c2-11ec-360d-bfee514a0421
# ╟─5e8019d6-53c2-11ec-0aee-0516ceb86cd2
# ╟─5e8019ea-53c2-11ec-00da-975255413531
# ╠═5e803682-53c2-11ec-3fca-cfe2d84a1d74
# ╟─5e8036b4-53c2-11ec-04f8-51e71acf2341
# ╟─5e8036d2-53c2-11ec-317b-aff635c6f242
# ╠═5e803b6e-53c2-11ec-262b-61fd75272faf
# ╠═5e8058b0-53c2-11ec-092b-1b6c44b254e1
# ╟─5e80595a-53c2-11ec-3ab5-b7218265bb6f
# ╠═5e8089f2-53c2-11ec-0d64-b1eeb1396696
# ╟─5e808a42-53c2-11ec-0ed9-79b6fe4be666
# ╠═5e808fa6-53c2-11ec-3c30-45e8001aa4b7
# ╟─5e808fe2-53c2-11ec-2ac6-df0546fd468c
# ╟─5e809000-53c2-11ec-2376-1fb690160771
# ╠═5e809488-53c2-11ec-25d7-996484034400
# ╟─5e8094a6-53c2-11ec-2b81-192778ebb423
# ╟─5e809500-53c2-11ec-3a10-eb1dfe160f45
# ╠═5e8096ae-53c2-11ec-16e5-fb5de58edd37
# ╟─5e8096f4-53c2-11ec-17c1-179e3fd4ba97
# ╟─5e80c0a2-53c2-11ec-3a6a-ebf0288e8f23
# ╟─5e80c0fc-53c2-11ec-1ac9-416f8e60ca2c
# ╟─5e80c11a-53c2-11ec-3499-8ddd6f1924d8
# ╠═5e80c3ea-53c2-11ec-1fed-955aae7032cd
# ╟─5e80c430-53c2-11ec-33d8-a9d270c016c0
# ╠═5e80c818-53c2-11ec-0d38-f1100818b190
# ╟─5e80c87c-53c2-11ec-273b-e5ddbc6036ea
# ╟─5e80c890-53c2-11ec-14e2-c954f1a96edb
# ╟─5e80c8ae-53c2-11ec-10a9-e7b9935e23df
# ╟─5e80c8cc-53c2-11ec-1ecb-c3378c9d5fe9
# ╠═5e80cfd4-53c2-11ec-1189-85456d37f1e8
# ╟─5e80cffc-53c2-11ec-1e3d-c98e75124b46
# ╠═5e80d1dc-53c2-11ec-3bc0-dbd44fb52f0b
# ╟─5e80d204-53c2-11ec-15c2-9903c1d5521e
# ╠═5e80d326-53c2-11ec-3953-abe6896e489c
# ╟─5e80d344-53c2-11ec-11fe-6da9a2a7231b
# ╟─5e80d358-53c2-11ec-1dbd-6fe0eb1db20b
# ╠═5e80d4a2-53c2-11ec-3e8f-4b69d42b2f76
# ╟─5e80d4ac-53c2-11ec-0270-65888e86bbcb
# ╠═5e80d86c-53c2-11ec-072c-7d17d605a771
# ╟─5e80d894-53c2-11ec-135e-75fe971e746e
# ╠═5e80d9ca-53c2-11ec-39aa-e552977f1fa1
# ╟─5e80d9f4-53c2-11ec-2922-1b098ae158c9
# ╠═5e80dc9a-53c2-11ec-0adb-ff002bd6efdf
# ╟─5e80dcb8-53c2-11ec-05f8-3dd09bd00ff9
# ╠═5e80de70-53c2-11ec-3a15-f5573eceed35
# ╟─5e80de90-53c2-11ec-0c3d-5d20a2fa5064
# ╠═5e80e15c-53c2-11ec-3604-c950e4848e5a
# ╟─5e80e19a-53c2-11ec-204a-77c63a4a3800
# ╟─5e80e1c0-53c2-11ec-0aba-175a0c7d7eb2
# ╟─5e80e1e0-53c2-11ec-3d62-25ea142f9819
# ╟─5e80e1f4-53c2-11ec-02f0-4f497dc4e71b
# ╟─5e80e23a-53c2-11ec-2a53-73ef5d5e7e09
# ╠═5e80f734-53c2-11ec-1196-89791df66515
# ╟─5e80f7a2-53c2-11ec-143c-955d943cf6c9
# ╟─5e80f7c0-53c2-11ec-1641-0b81683eea1b
# ╟─5e80f7d4-53c2-11ec-3528-73c16fd8d25e
# ╟─5e80f806-53c2-11ec-16ed-aba2e58228c7
# ╟─5e80f824-53c2-11ec-0e57-4f400a3312ed
# ╠═5e80fd88-53c2-11ec-2751-41ed6e8ff8de
# ╟─5e80fdb0-53c2-11ec-1b17-49f4f16d9adb
# ╠═5e80ff4a-53c2-11ec-1e24-c778223002c0
# ╟─5e80ff7c-53c2-11ec-2f99-ed86771eea07
# ╟─5e80ffa4-53c2-11ec-07cd-77110798e6d0
# ╠═5e812e3e-53c2-11ec-20f1-8fffce0a5dc9
# ╟─5e812eca-53c2-11ec-129b-b9154f924d59
# ╠═5e813924-53c2-11ec-169e-db1264ce5874
# ╟─5e813942-53c2-11ec-37d5-5177fd59656b
# ╟─5e813974-53c2-11ec-3ea3-0391770c2c4b
# ╟─5e8139a6-53c2-11ec-1cc5-d1b8d55aa3ba
# ╟─5e8139ba-53c2-11ec-1887-93b5aa5c1ca2
# ╠═5e813d3c-53c2-11ec-32fb-a3ff03c54291
# ╟─5e813d8e-53c2-11ec-168d-4f16f91a2f2d
# ╟─5e814edc-53c2-11ec-24eb-4d2a9f8ad889
# ╟─5e814f04-53c2-11ec-153e-6d42b0a67081
# ╟─5e814f18-53c2-11ec-2c45-17e627c037f6
# ╟─5e814f2c-53c2-11ec-1626-ede36a2bcb54
# ╟─5e814f40-53c2-11ec-0120-7f556752759c
# ╟─5e814f5e-53c2-11ec-25d4-6dfdb7be6bed
# ╠═5e815486-53c2-11ec-3209-d1bb22d1e094
# ╟─5e81549a-53c2-11ec-32c8-dd96b240b13c
# ╠═5e815670-53c2-11ec-253d-fb2b3e321bfa
# ╟─5e815698-53c2-11ec-3eb9-3b0eb0d61562
# ╟─5e8156b6-53c2-11ec-32b5-13595edd7b41
# ╟─5e8156cc-53c2-11ec-11ab-bb02018f16b9
# ╟─5e8156e8-53c2-11ec-3459-5546c2352a48
# ╟─5e815730-53c2-11ec-0df5-d58085189c06
# ╠═5e8175b8-53c2-11ec-292b-e92006c3b87d
# ╟─5e8175f6-53c2-11ec-0a37-9d70988355b5
# ╟─5e817632-53c2-11ec-09a5-b9c4d9a79f8e
# ╟─5e817678-53c2-11ec-28a2-c7e2360f3dea
# ╟─5e8176a0-53c2-11ec-38d3-6178d1e63a0e
# ╟─5e8176b4-53c2-11ec-1bb8-afb00e81b189
# ╠═5e817d1c-53c2-11ec-0dea-994c0634ffdf
# ╟─5e817d4e-53c2-11ec-2d94-67a786bf596c
# ╠═5e8181ae-53c2-11ec-0a60-25f3473fef08
# ╟─5e8181ce-53c2-11ec-0e09-fbb9b51af419
# ╠═5e819b8c-53c2-11ec-08a6-b342809c06cd
# ╟─5e819be4-53c2-11ec-38e7-3922f128433c
# ╟─5e819bf8-53c2-11ec-37cc-491a1b031d97
# ╟─5e85ee06-53c2-11ec-0894-393dbbe40b89
# ╟─5e85ee92-53c2-11ec-0b45-7bbceb5795c8
# ╟─5e85ef46-53c2-11ec-3782-9f1f5bc861d1
# ╟─5e85ef78-53c2-11ec-10a8-2910aa606e99
# ╟─5e85ef96-53c2-11ec-2cab-2b3504e432f6
# ╟─5e85efac-53c2-11ec-2f52-3b6c77bac547
# ╠═5e85fa04-53c2-11ec-21d6-97fed13947e2
# ╟─5e85fa22-53c2-11ec-2ca8-e5433f8a32af
# ╟─5e85fa4a-53c2-11ec-390d-1989939b3842
# ╟─5e85fa72-53c2-11ec-0c8b-b1157580fbb9
# ╟─5e86031e-53c2-11ec-2d45-b5a7413bbd43
# ╟─5e86033c-53c2-11ec-09ee-af162edb3975
# ╟─5e860350-53c2-11ec-243c-4d51b05f11c3
# ╟─5e860c1a-53c2-11ec-1032-27ca95b4fbd8
# ╟─5e860c38-53c2-11ec-01a3-255b02c896f7
# ╟─5e860c56-53c2-11ec-1fff-8d826670c8c5
# ╟─5e861098-53c2-11ec-3650-9b7f8e1d3df7
# ╟─5e8610b6-53c2-11ec-32f8-3bb01b5cfdb5
# ╟─5e8610de-53c2-11ec-3840-8980b84abf4f
# ╟─5e8617fa-53c2-11ec-3bfc-9f5598306a8f
# ╟─5e86180c-53c2-11ec-1d0f-13fb7d167462
# ╟─5e86182c-53c2-11ec-15e7-4155b2e55ca2
# ╟─5e861f52-53c2-11ec-00d6-cfbdd547c13b
# ╟─5e861f66-53c2-11ec-0334-1dbfa846bcd7
# ╟─5e861fa2-53c2-11ec-0ea3-bff65c2f0a59
# ╟─5e862664-53c2-11ec-269a-d14063b02fd0
# ╟─5e862678-53c2-11ec-20a7-e58707c3cab2
# ╟─5e8626a0-53c2-11ec-074e-639df8acdf3d
# ╟─5e8626d2-53c2-11ec-0c6c-e5ee06348c99
# ╟─5e8626e6-53c2-11ec-07ad-cde0c82858e0
# ╟─5e862ca4-53c2-11ec-0281-418bbc88c251
# ╟─5e862ccc-53c2-11ec-0e7d-39e600b5768e
# ╟─5e863276-53c2-11ec-1152-59e9deb84d3f
# ╟─5e86329e-53c2-11ec-3c30-6d0ce567fcf3
# ╟─5e865024-53c2-11ec-3881-c7a5eb91153f
# ╟─5e86504e-53c2-11ec-1fd4-bfb08b15a989
# ╟─5e865088-53c2-11ec-1d5f-af9b666ba00b
# ╟─5e865b7a-53c2-11ec-05f8-d194465b58c8
# ╟─5e865bac-53c2-11ec-3999-45ed153bec6e
# ╟─5e865be8-53c2-11ec-0c13-cdebc58c4443
# ╟─5e866322-53c2-11ec-24e8-4341677f0acd
# ╟─5e866354-53c2-11ec-25f8-a5c9a1eb0909
# ╟─5e866a70-53c2-11ec-0105-57ab4c766cd9
# ╟─5e866aa2-53c2-11ec-2e35-97c2b35d1a1c
# ╟─5e8671b4-53c2-11ec-272d-b30e047edef0
# ╟─5e8671d2-53c2-11ec-2b0f-19a4e74b768a
# ╟─5e8671fa-53c2-11ec-3614-831e565e23f8
# ╟─5e8679ca-53c2-11ec-3335-259df3d92d65
# ╟─5e8679e8-53c2-11ec-349b-e3f28d5953c1
# ╟─5e867a1a-53c2-11ec-1ef6-f90787a7e393
# ╠═5e867eb6-53c2-11ec-3d4c-7db31b012e81
# ╟─5e867ede-53c2-11ec-084d-3d3feba847f8
# ╟─5e8685c8-53c2-11ec-0853-9f4fa7ed6b68
# ╟─5e8685e6-53c2-11ec-1aff-7bb79e1c22e6
# ╟─5e868602-53c2-11ec-1840-61af27a973e5
# ╟─5e86a738-53c2-11ec-3966-d972d2d87c56
# ╟─5e86a760-53c2-11ec-0a67-c1131f90b526
# ╟─5e86a76c-53c2-11ec-397d-69e2b18b205f
# ╟─5e86a774-53c2-11ec-0aeb-7349e5ab5780
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
