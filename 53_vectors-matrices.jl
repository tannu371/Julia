### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 640fc238-77d1-11ec-1bb3-ed96ea3fc81c
begin
	using CalculusWithJulia
	using Plots
	using LinearAlgebra
	using SymPy
end

# ╔═╡ 640fc9a4-77d1-11ec-20dc-59e51a11ac88
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 649f04ca-77d1-11ec-3fa4-8d8d3ef51e6c
using PlutoUI

# ╔═╡ 649f04ac-77d1-11ec-079a-59c1ebb14d70
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 640f6f40-77d1-11ec-2a62-9b82c327e94f
md"""# Vectors and matrices
"""

# ╔═╡ 640f8390-77d1-11ec-0c2b-83f20be35a2a
md"""This section uses these add-on package:
"""

# ╔═╡ 640fc9f4-77d1-11ec-346d-6f5dd04ee798
md"""---
"""

# ╔═╡ 640fcb02-77d1-11ec-24a5-2362600beb0e
md"""In [vectors](../precalc/vectors.html) we introduced the concept of a vector.  For `Julia`, vectors are a useful storage container and are used to hold, for example, zeros of functions or the coefficients of a polynomial. This section is about their mathematical properties.  A [vector](https://en.wikipedia.org/wiki/Euclidean_vector) mathematically is a geometric object with two attributes a magnitude and a direction. (The direction is undefined in the case the magnitude is $0$.) Vectors are typically visualized with an arrow, where the anchoring of the arrow is context dependent and is not particular to a given vector.
"""

# ╔═╡ 640fcb70-77d1-11ec-3b41-813b167368c6
md"""Vectors and points are related, but distinct. Let's focus on $3$ dimensions. Mathematically, the notation for a point is $p=(x,y,z)$ while the notation for a vector is $\vec{v} = \langle x, y, z \rangle$. The $i$th component in a vector is referenced by a subscript: $v_i$. With this, we may write a typical vector as $\vec{v} = \langle v_1, v_2, \dots, v_n \rangle$ and a vector in $n=3$ as $\vec{v} =\langle v_1, v_2, v_3 \rangle$. The different grouping notation distinguishes the two objects. As another example, the notation $\{x, y, z\}$ indicates a set. Vectors and points may be *identified* by anchoring the vector at the origin. Set's are quite different from both, as the order of their entries is not unique.
"""

# ╔═╡ 640fcbb6-77d1-11ec-1e9a-93baa44f435b
md"""In `Julia`, the notation to define a point and a vector would be identical, using square brackets to group like-type values: `[x, y, z]`. The notation `(x,y,z)` would form a [tuple](https://en.wikipedia.org/wiki/Euclidean_vector) which though similar in many respects, tuples do not have the operations associated with a point or a vector defined for them.
"""

# ╔═╡ 640fcbde-77d1-11ec-294c-51e48d8062f3
md"""The square bracket constructor has some subtleties:
"""

# ╔═╡ 641229ee-77d1-11ec-3bbd-59e600cb5148
md"""  * `[x,y,z]` calls `vect` and creates a 1-dimensional array
  * `[x; y; z]` calls `vcat` to **v**ertically con**cat**enate values together. With simple numbers the two are identical, but not in other cases. (For example, is `A` is a matrix then `[A, A]` is a vector of matrices, `[A; A]` is a matrix combined from the two pieces.
  * `[x y z]`	 calls `hcat` to **h**orizontally con**cat**enate values together. If `x`, `y` are numbers then `[x y]` is *not* a vector, but rather a $2$D array with a single row and two columns.
  * finally `[w x; y z]` calls `hvcat` to horizontally and vertically concatenate values together to create a container in two dimensions, like a matrix.
"""

# ╔═╡ 64123fcc-77d1-11ec-2241-c3393c3c0fc8
md"""(A vector, mathematically, is a one-dimensional collection of numbers, a matrix a two-dimensional *rectangular* collection of numbers, and an array an $n$-dimensional rectangular-like collection of numbers. In `Julia`, a vector can hold a collection of objects of arbitrary type, though generally all of the same type.)
"""

# ╔═╡ 64124094-77d1-11ec-3eb0-b1efbedeb0f3
md"""## Vector addition, scalar multiplication
"""

# ╔═╡ 64124120-77d1-11ec-11f0-2b9855dc8072
md"""As seen earlier, vectors have some arithmetic operations defined for them. As a typical use of vectors, mathematically, is to collect the $x$, $y$, and  $z$ (in $3$D) components together, operations like addition and subtraction operate component wise. With this, addition can be visualized geometrically: put the tail of $\vec{v}$ at the tip of $\vec{u}$ and draw a vector from the tail of $\vec{u}$ to the tip of $\vec{v}$ and you have $\vec{u}+\vec{v}$. This is identical by $\vec{v} + \vec{u}$ as vector addition is commutative. Unless $\vec{u}$ and $\vec{v}$ are parallel or one has $0$ length, the addition will create a vector with a different direction from the two.
"""

# ╔═╡ 6412417a-77d1-11ec-2126-77cc15d50098
md"""Another operation for vectors is *scalar* multiplication. Geometrically this changes the magnitude, but not the direction of a vector, when the *scalar* is positive. Scalar multiplication is defined component wise, like addition so the $i$th component of $c \vec{v}$ is $c$ times the $i$th component of $\vec{v}$. When the scalar is negative, the direction is "reversed."
"""

# ╔═╡ 641241c0-77d1-11ec-1f47-7d3e1637c8ba
md"""To illustrate we first load our package and define two $3$D vectors:
"""

# ╔═╡ 64127b5e-77d1-11ec-05b6-d39ec7962874
u, v = [1, 2, 3], [4, 3, 2]

# ╔═╡ 64127bb6-77d1-11ec-0952-a58e04db528d
md"""The sum is component-wise summation (`1+4, 2+3, 3+2`):
"""

# ╔═╡ 64127de8-77d1-11ec-32af-a5377118a2cc
u + v

# ╔═╡ 64127e1a-77d1-11ec-03ea-bf4ee007b37b
md"""For addition, as the components must pair off, the two vectors being added must be the same dimension.
"""

# ╔═╡ 64127e42-77d1-11ec-2da4-cf218c869b3e
md"""Scalar multiplication by `2`, say, multiplies each entry by `2`:
"""

# ╔═╡ 64128068-77d1-11ec-1d28-3161199f3b3a
2 * u

# ╔═╡ 6412809a-77d1-11ec-0c10-e9a4356a3942
md"""## The length and direction of a vector
"""

# ╔═╡ 641280ea-77d1-11ec-3626-41b1b3528e82
md"""If a vector $\vec{v} = \langle v_1, v_2, \dots, v_n\rangle$ then the *norm* (also Euclidean norm or length) of $\vec{v}$ is defined by:
"""

# ╔═╡ 64128112-77d1-11ec-2c6b-856d33b6d8f6
md"""```math
\| \vec{v} \| = \sqrt{ v_1^2 + v_2^2 + \cdots + v_n^2}.
```
"""

# ╔═╡ 6412816c-77d1-11ec-0e3a-77a4d6d0f7a1
md"""The definition of a norm leads to a few properties. First, if $c$ is a scalar, $\| c\vec{v} \| = |c| \| \vec{v} \|$ - which says scalar multiplication by $c$ changes the length by $|c|$. (Sometimes, scalar multiplication is described as "scaling by....") The other property is an analog of the triangle inequality, in which for any two vectors $\| \vec{v} + \vec{w} \| \leq \| \vec{v} \| + \| \vec{w} \|$. The right hand side is equal only when the two vectors are parallel and addition is viewed as laying them end to end.
"""

# ╔═╡ 6412819e-77d1-11ec-2970-6d1dafd914bd
md"""A vector with length $1$ is called a *unit* vector. Dividing a non-zero vector by its norm will yield a unit vector, a consequence of the first property above. Unit vectors are often written with a "hat:" $\hat{v}$.
"""

# ╔═╡ 64128220-77d1-11ec-1eb1-eb7884e940ea
md"""The direction indicated by $\vec{v}$ can be visualized as an angle in $2$ or $3$ dimensions, but in higher dimensions, visualization is harder. For $2$-dimensions, we might associate with a vector, it's unit vector. This in turn may be identified with a point on the unit circle, which from basic trigonometry can be associated with an angle. Something similar, can be done in $3$ dimensions, using two angles. However, the "direction" of a vector is best thought of in terms of its associated unit vector. With this, we have a decomposition of a vector $\vec{v}$ into a magnitude  and a direction when we write $\vec{v} = \|\vec{v}\| \cdot (\vec{v} / \|\vec{v}\|)=\|\vec{v}\| \hat{v}$.
"""

# ╔═╡ 6412823e-77d1-11ec-0768-912e8e4a4f10
md"""## Visualization of vectors
"""

# ╔═╡ 641282a2-77d1-11ec-105a-e503b9494e1a
md"""Vectors may be visualized in $2$ or $3$ dimensions using `Plots`. In $2$ dimensions, the `quiver` function may be used. To graph a vector, it must have its tail placed at a point, so two values are needed.
"""

# ╔═╡ 641282de-77d1-11ec-1dbe-ab4e51a55856
md"""To plot `u=[1,2]` from `p=[0,0]` we have the following usage:
"""

# ╔═╡ 64128b80-77d1-11ec-3ebc-0bbf69e99d23
quiver([0],[0], quiver=([1],[2]))

# ╔═╡ 64128bce-77d1-11ec-1e38-510552f90336
md"""The cumbersome syntax is typical here. We naturally describe vectors and points using `[a,b,c]` to combine them, but the plotting functions want to plot many such at a time and expect vectors containing just the `x` values, just the `y` values, etc. The above usage looks a bit odd, as these vectors of `x` and `y` values have only one entry. Converting from the one representation to the other requires reshaping the data. We will use the `unzip` function from `CalculusWithJulia` which in turn just uses the the `invert` function of the `SplitApplyCombine` package ("return a new nested container by reversing the order of the nested container") for the bulk of its work.
"""

# ╔═╡ 64128c70-77d1-11ec-2cd2-e15d93da693c
md"""This function takes a vector of vectors, and returns a vector containing the `x` values, the `y` values, etc. So if  `u=[1,2,3]` and `v=[4,5,6]`, then `unzip([u,v])` becomes `[[1,4],[2,5],[3,6]]`, etc. (The `zip` function in base does essentially the reverse operation, hence the name). Notationally, `A = [u,v]` can have the thirrd element of the first vector (`u`) accessed by `A[1][3]`, where as `unzip(A)[3][1]` will do the same. We use`unzip([u])` in the following, which for this `u` returns `([1],[2],[3])`. (Note the `[u]` to make a vector of a vector.)
"""

# ╔═╡ 64128ca4-77d1-11ec-0d3c-bb131c0d8efe
md"""With `unzip` defined, we can plot a $2$D vector `v` anchored at point `p` through `quiver(unzip([p])..., quiver=unzip([v]))`.
"""

# ╔═╡ 64128cca-77d1-11ec-2db5-bb1dcf0de79b
md"""To illustrate, the following defines $3$ vectors (the third through addition), then graphs all three, though in different starting points to emphasize the geometric interpretation of vector addition.
"""

# ╔═╡ 64129224-77d1-11ec-0dec-d7b0bd877698
let
	u = [1, 2]
	v = [4, 2]
	w = u + v
	p = [0,0]
	quiver(unzip([p])..., quiver=unzip([u]))
	quiver!(unzip([u])..., quiver=unzip([v]))
	quiver!(unzip([p])..., quiver=unzip([w]))
end

# ╔═╡ 6412929c-77d1-11ec-3bc4-3bb5c191c8f2
md"""Plotting a 3-d vector is not supported in all toolkits with `quiver`. A line segment may be substituted and can be produced with `plot(unzip([p,p+v])...)`. To avoid all these details, the `CalculusWithJulia` provides the `arrow!` function to *add* a vector to an existing plot. The function requires a point, `p`, and the vector, `v`:
"""

# ╔═╡ 641292c4-77d1-11ec-23f9-a56ae157e647
md"""With this, the above simplifies to:
"""

# ╔═╡ 6412970e-77d1-11ec-30ab-cf56a0de3245
let
	u = [1, 2]
	v = [4, 2]
	w = u + v
	p = [0,0]
	plot(legend=false)
	arrow!(p, u)
	arrow!(u, v)
	arrow!(p, w)
end

# ╔═╡ 6412976a-77d1-11ec-3736-97d257e3c0d7
md"""The distinction between a point and a vector within `Julia` is only mental. We use the same storage type. Mathematically, we can **identify** a point and a vector, by considering the vector with its tail placed at the origin. In this case, the tip of the arrow is located at the point. But this is only an identification, though a useful one. It allows us to "add" a point and a vector (e.g., writing $P + \vec{v}$) by imagining the point as a vector anchored at the origin.
"""

# ╔═╡ 64129788-77d1-11ec-282f-513bc8cb5b61
md"""To see that a unit vector has the same "direction" as the vector, we might draw them with different widths:
"""

# ╔═╡ 64129b8e-77d1-11ec-28c0-bd1233149d4b
let
	v = [2, 3]
	u = v / norm(v)
	p = [0, 0]
	plot(legend=false)
	arrow!(p, v)
	arrow!(p, u, linewidth=5)
end

# ╔═╡ 64129bde-77d1-11ec-2778-bfbdaccd82ab
md"""The `norm` function is in the standard library, `LinearAlgebra`, which must be loaded first through the command `using LinearAlgebra`. (Though here it is redundant, as that package is loaded when the `CalculusWithJulia` package is loaded.)
"""

# ╔═╡ 64129bfc-77d1-11ec-0b71-61b1e145a5ae
md"""## Aside: review of `Julia`'s use of dots to work with containers
"""

# ╔═╡ 64129c24-77d1-11ec-17e8-534e4c77776a
md"""`Julia` makes use of the dot, "`.`", in a few ways to simplify usage when containers, such as vectors, are involved:
"""

# ╔═╡ 64145334-77d1-11ec-2b30-0bfa77f9576b
md"""  * **Splatting**. The use of three dots, "`...`", to "splat" the values from a container like a vector (or tuple) into *arguments* of a function can be very convenient. It was used above in the definition for the `arrow!` function: essentially `quiver!(unzip([p])..., quiver=unzip([v]))`. The `quiver` function expects $2$ (or $3$) arguments describing the `xs` and `ys` (and sometimes `zs`). The `unzip` function returns these in a container, so splatting is used to turn the values in the container into distinct arguments of the function. Whereas the `quiver` argument expects a tuple of vectors, so no splatting is used for that part of the definition. Another use of splatting we will see is with functions of vectors. These can be defined in terms of the vector's components or the vector as a whole, as below:
"""

# ╔═╡ 64147620-77d1-11ec-13e4-6128d4394a68
begin
	f(x, y, z) = x^2 + y^2 + z^2
	f(v) = v[1]^2 + v[2]^2 + v[3]^2
end

# ╔═╡ 641476ac-77d1-11ec-23fb-8fee943c31d3
md"""The first uses the components and is arguably, much easier to read. The second uses indexing in the function body to access the components. It has an advantage, as it can more easily handle different length vectors (e.g. using `sum(v.^2)`). Both uses have their merits, though the latter is more idiomatic throughout `Julia`.
"""

# ╔═╡ 641476e8-77d1-11ec-36db-a31398b2d88d
md"""If a function is easier to write in terms of its components, but an interface expects a vector of components as it argument, then splatting can be useful, to go from one style to another, similar to this:
"""

# ╔═╡ 64147f6c-77d1-11ec-1dd2-9190cc6d77be
begin
	g(x, y, z) = x^2 + y^2 + z^2
	g(v) = g(v...)
end

# ╔═╡ 64147fc6-77d1-11ec-2e8c-0d6d8aaae7d1
md"""The splatting will mean `g(v)` eventually calls `g(x, y, z)` through `Julia`'s multiple dispatch machinery when `v = [x, y, z]`.
"""

# ╔═╡ 64147fee-77d1-11ec-30cf-959076c91df4
md"""(The three dots can also appear in the definition of the arguments to a function, but there the usage is not splatting but rather a specification of a variable number of arguments.)
"""

# ╔═╡ 6414812e-77d1-11ec-15bf-437f22c5e7f8
md"""  * **Broadcasting**. For a univariate function, `f`, and vector, `xs`, the call `f.(xs)` *broadcasts* `f` over each value of `xs` and returns a container holding all the values. This is a compact alternative to a comprehension when a function is defined.  When `f` depends on more than one value, broadcasting can still be used: `f.(xs, ys)` will broadcast `f` over values formed from *both* `xs` and `ys`. Broadcasting has the extra feature (over `map`) of attempting to match up the shapes of `xs` and `ys` when they are not identical. (See the help page for `broadcast` for more details.)
"""

# ╔═╡ 641494c0-77d1-11ec-3ba2-052786ed9985
md"""For example, if `xs` is a vector and `ys` a scalar, then the value in `ys` is repeated many times to match up with the values of `xs`. Or if `xs` and `ys` have different dimensions, the values of one will be repeated. Consider this:
"""

# ╔═╡ 641498f8-77d1-11ec-0613-93fc08d69c04
𝐟(x,y) = x + y

# ╔═╡ 6414c756-77d1-11ec-1399-fd14a918ab48
let
	xs = ys = [0, 1]
	𝐟.(xs, ys)
end

# ╔═╡ 6414c7ec-77d1-11ec-1e2a-17ae01466e9f
md"""This matches `xs` and `ys` to pass `(0,0)` and then `(1,1)` to `f`, returning `0` and `2`. Now consider
"""

# ╔═╡ 6414d05c-77d1-11ec-1a72-0d8518898928
let
	xs = [0, 1]; ys = [0 1]  # xs is a column vector, ys a row vector
	𝐟.(xs, ys)
end

# ╔═╡ 6414d0e8-77d1-11ec-39b9-eb49b95f3689
md"""The two dimensions are different so for each value of `xs` the vector of `ys` is broadcast. This returns a matrix now. This will be important for some plotting usages where a grid (matrix) of values is needed.
"""

# ╔═╡ 6414d110-77d1-11ec-1517-4dbbb3610196
md"""At times using the "apply" notation: `x |> f`, in place of using `f(x)` is useful, as it can move the wrapping function to the right of the expression. To broadcast,  `.|>` is available.
"""

# ╔═╡ 6414d142-77d1-11ec-0af1-81db4d0a9815
md"""## The dot product
"""

# ╔═╡ 6414d160-77d1-11ec-0e8e-83cc88aaeb44
md"""There is no concept of multiplying two vectors, or for that matter dividing two vectors. However, there are two operations between vectors that are somewhat similar to multiplication, these being the dot product and the cross product. Each has an algebraic definition, but their geometric properties are what motivate their usage. We begin by discussing the dot product.
"""

# ╔═╡ 6414d1ba-77d1-11ec-2d52-4f8e374e94f1
md"""The dot product between two vectors can be viewed algebraically in terms of the following product. If $\vec{v} = \langle v_1, v_2, \dots, v_n\rangle$ and $\vec{w} = \langle w_1, w_2, \dots, w_n\rangle$, then the *dot product* of $\vec{v}$ and $\vec{w}$ is defined by:
"""

# ╔═╡ 6414d1ec-77d1-11ec-11b6-49a4cb515047
md"""```math
\vec{v} \cdot \vec{w} = v_1 w_1 + v_2 w_2 + \cdots + v_n w_n.
```
"""

# ╔═╡ 6414d214-77d1-11ec-0433-234db8578e53
md"""From this, we can see the relationship between the norm, or Euclidean length of a vector: $\vec{v} \cdot \vec{v} = \| \vec{v} \|^2$. We can also see that the dot product is commutative, that is $\vec{v} \cdot \vec{w} = \vec{w} \cdot \vec{v}$.
"""

# ╔═╡ 6414d250-77d1-11ec-1d80-edda477a2735
md"""The dot product has an important geometrical interpolation. Two (non-parallel) vectors will lie in the same "plane", even in higher dimensions. Within this plane, there will be an angle between them within $[0, \pi]$. Call this angle $\theta$. (This means the angle between the two vectors is the same regardless of their order of consideration.) Then
"""

# ╔═╡ 6414d282-77d1-11ec-0fb9-3f8ab6872830
md"""```math
\vec{v} \cdot \vec{w} = \|\vec{v}\| \|\vec{w}\| \cos(\theta).
```
"""

# ╔═╡ 6414d2aa-77d1-11ec-2cf6-ad2cdc18ff72
md"""If we denoted $\hat{v} = \vec{v} / \| \vec{v} \|$, the unit vector in the direction of $\vec{v}$, then by dividing, we see that $\cos(\theta) = \hat{v} \cdot \hat{w}$. That is the angle does not depend on the magnitude of the vectors involved.
"""

# ╔═╡ 6414d2e6-77d1-11ec-3d5f-89afad58e452
md"""The dot product is computed in `Julia` by the `dot` function, which is in the `LinearAlgebra` package of the standard library. This must be loaded (as above) before its use either directly or through the `CalculusWithJulia` package:
"""

# ╔═╡ 6414d8d6-77d1-11ec-37af-cde3e75e257f
begin
	𝒖 = [1, 2]
	𝒗 = [2, 1]
	dot(𝒖, 𝒗)
end

# ╔═╡ 64210a8e-77d1-11ec-0456-0d32e230efff
md"""!!! note
    In `Julia`, the unicode operator entered by `\cdot[tab]` can also be used to mirror the math notation:

"""

# ╔═╡ 64210f5c-77d1-11ec-04ec-295b6e0ee1f1
𝒖 ⋅ 𝒗   # u \cdot[tab] v

# ╔═╡ 64210fac-77d1-11ec-2e50-e1baee26b74c
md"""Continuing, to find the angle between $\vec{u}$ and $\vec{v}$, we might do this:
"""

# ╔═╡ 64211c22-77d1-11ec-226c-59b06fd56356
begin
	𝒄theta = dot(𝒖/norm(𝒖), 𝒗/norm(𝒗))
	acos(𝒄theta)
end

# ╔═╡ 64211c90-77d1-11ec-2e9d-a1b4d7101e85
md"""The cosine of $\pi/2$ is $0$, so two vectors which are at right angles to each other will have a dot product of  $0$:
"""

# ╔═╡ 642121a4-77d1-11ec-17b7-2bfed3963a38
let
	u = [1, 2]
	v = [2, -1]
	u ⋅ v
end

# ╔═╡ 64212212-77d1-11ec-18ba-9f2f71ea982f
md"""In two dimensions, we learn that a perpendicular line to a line with slope $m$ will have slope $-1/m$. From a 2-dimensional vector, say $\vec{u} = \langle u_1, u_2 \rangle$ the slope is $u_2/u_1$ so a perpendicular vector to $\vec{u}$ will be $\langle u_2, -u_1 \rangle$, as above. For higher dimensions, where the angle is harder to visualize, the dot product defines perpendicularness, or *orthogonality*.
"""

# ╔═╡ 64212250-77d1-11ec-004d-8da4a11e35f0
md"""For example, these two vectors are orthogonal, as their dot product is $0$, even though we can't readily visualize them:
"""

# ╔═╡ 64212744-77d1-11ec-1334-578e4d73ff96
let
	u = [1, 2, 3, 4, 5]
	v = [-30, 4, 3, 2, 1]
	u ⋅ v
end

# ╔═╡ 642452d4-77d1-11ec-0056-154b201bbff5
md"""#### Projection
"""

# ╔═╡ 64245374-77d1-11ec-1a8e-1302cda7dcb5
md"""From right triangle trigonometry, we learn that $\cos(\theta) = \text{adjacent}/\text{hypotenuse}$. If we use a vector, $\vec{h}$ for the hypotenuse, and $\vec{a} = \langle 1, 0 \rangle$, we have this picture:
"""

# ╔═╡ 64245a68-77d1-11ec-1361-05139bf659f2
let
	h = [2, 3]
	a = [1, 0]  # unit vector
	h_hat = h / norm(h)
	theta = acos(h_hat ⋅ a)
	
	plot(legend=false)
	arrow!([0,0], h)
	arrow!([0,0], norm(h) * cos(theta) * a)
	arrow!([0,0], a, linewidth=3)
end

# ╔═╡ 64245b24-77d1-11ec-2a68-09077ba1b03f
md"""We used vectors to find the angle made by `h`, and from there, using the length of the hypotenuse is `norm(h)`, we can identify the length of the adjacent side, it being the length of the hypotenuse times the cosine of $\theta$. Geometrically, we call the vector `norm(h) * cos(theta) * a` the *projection* of $\vec{h}$ onto $\vec{a}$, the word coming from the shadow $\vec{h}$ would cast on the direction of $\vec{a}$ were there light coming perpendicular to $\vec{a}$.
"""

# ╔═╡ 64245b56-77d1-11ec-2634-57fa5fccebc5
md"""The projection can be made for any pair of vectors, and in any dimension $n > 1$. The projection of $\vec{u}$ on $\vec{v}$ would be a vector of length $\vec{u}$ (the hypotenuse) times the cosine of the angle in the direction of $\vec{v}$. In dot-product notation:
"""

# ╔═╡ 64245b9e-77d1-11ec-249f-adae664399fe
md"""```math
proj_{\vec{v}}(\vec{u}) = \| \vec{u} \| \frac{\vec{u}\cdot\vec{v}}{\|\vec{u}\|\|\vec{v}\|} \frac{\vec{v}}{\|\vec{v}\|}.
```
"""

# ╔═╡ 64245bb2-77d1-11ec-192d-e136035c2d6f
md"""This can simplify. After cancelling, and expressing norms in terms of dot products, we have:
"""

# ╔═╡ 64245bbc-77d1-11ec-12b2-b33c01c11c64
md"""```math
proj_{\vec{v}}(\vec{u}) = \frac{\vec{u} \cdot \vec{v}}{\vec{v} \cdot \vec{v}} \vec{v} = (\vec{u} \cdot \hat{v}) \hat{v},
```
"""

# ╔═╡ 64245c34-77d1-11ec-3193-197139aa2a23
md"""where $\hat{v}$ is the unit vector in the direction of $\vec{v}$.
"""

# ╔═╡ 64245cac-77d1-11ec-36aa-a5831c18baca
md"""##### Example
"""

# ╔═╡ 64245cd4-77d1-11ec-2a19-bf55529e74be
md"""A pendulum, a bob on a string, swings back and forth due to the force of gravity. When the bob is displaced from rest by an angle $\theta$, then the tension force of the string on the bob is directed along the string and has magnitude given by the *projection* of the force due to gravity.
"""

# ╔═╡ 64245d1a-77d1-11ec-15e7-658c8a1296e0
md"""A [force diagram](https://en.wikipedia.org/wiki/Free_body_diagram) is a useful visualization device of physics to illustrate the applied forces involved in a scenario. In this case the bob has two forces acting on it: a force due to tension in the string of unknown magnitude, but in the direction of the string; and a force due to gravity. The latter is in the downward direction and has magnitude $mg$, $g=9.8m/sec^2$ being the gravitational constant.
"""

# ╔═╡ 6424630a-77d1-11ec-175e-7b0931d926ef
begin
	𝗍heta = pi/12
	𝗆ass, 𝗀ravity = 1/9.8, 9.8
	
	𝗅 = [-sin(𝗍heta), cos(𝗍heta)]
	𝗉 = -𝗅
	𝖥g = [0, -𝗆ass * 𝗀ravity]
	plot(legend=false)
	arrow!(𝗉, 𝗅)
	arrow!(𝗉, 𝖥g)
	scatter!(𝗉[1:1], 𝗉[2:2], markersize=5)
end

# ╔═╡ 6424635a-77d1-11ec-1846-35020e2a0562
md"""The magnitude of the tension force is exactly that of the force of gravity projected onto $\vec{l}$, as the bob is not accelerating in that direction. The component of the gravity force in the perpendicular direction is the part of the gravitational force that causes acceleration in the pendulum. Here we find the projection onto $\vec{l}$ and visualize the two components of the gravitational force.
"""

# ╔═╡ 642484a2-77d1-11ec-2d1e-ef1484501b36
begin
	plot(legend=false, aspect_ratio=:equal)
	arrow!(𝗉, 𝗅)
	arrow!(𝗉, 𝖥g)
	scatter!(𝗉[1:1], 𝗉[2:2], markersize=5)
	
	𝗉roj = (𝖥g ⋅ 𝗅) / (𝗅 ⋅ 𝗅) * 𝗅   # force of gravity in direction of tension
	𝗉orth = 𝖥g - 𝗉roj              # force of gravity perpendicular to tension
	
	arrow!(𝗉, 𝗉roj)
	arrow!(𝗉, 𝗉orth, linewidth=3)
end

# ╔═╡ 642484e8-77d1-11ec-35d4-0568c0df21c8
md"""##### Example
"""

# ╔═╡ 64248510-77d1-11ec-2091-3d2bfd90d93f
md"""Starting with three vectors, we can create three orthogonal vectors using projection and subtraction. The creation of `porth` above is the pattern we will exploit.
"""

# ╔═╡ 64248542-77d1-11ec-323c-e9a9c9525931
md"""Let's begin with three vectors in $R^3$:
"""

# ╔═╡ 64248aec-77d1-11ec-01be-011c59dd26de
begin
	u⃗ = [1, 2, 3]
	v⃗ = [1, 1, 2]
	w⃗ = [1, 2, 4]
end

# ╔═╡ 64248b28-77d1-11ec-28e1-ebdc8eceb298
md"""We can find a vector from `v` orthogonal to `u` using:
"""

# ╔═╡ 6424905a-77d1-11ec-189f-03dda8808596
begin
	unit_vec(u) = u / norm(u)
	projection(u, v) = (u ⋅ unit_vec(v)) * unit_vec(v)
	
	v⃗orth = v⃗ - projection(v⃗, u⃗)
	w⃗orth = w⃗ - projection(w⃗, u⃗) - projection(w⃗, v⃗orth)
end

# ╔═╡ 6424908c-77d1-11ec-3895-691ab115b4cd
md"""We can verify the orthogonality through:
"""

# ╔═╡ 64249492-77d1-11ec-1e0c-47bba4ecd803
u⃗ ⋅ v⃗orth, u⃗ ⋅ w⃗orth, v⃗orth ⋅ w⃗orth

# ╔═╡ 642494d6-77d1-11ec-3f35-e94169396885
md"""This only works when the three vectors do not all lie in the same plane. In general, this is the beginnings of the [Gram-Schmidt](https://en.wikipedia.org/wiki/Gram-Schmidt_process) process for creating *orthogonal* vectors from a collection of vectors.
"""

# ╔═╡ 64249500-77d1-11ec-218d-3b1d297c159d
md"""#### Algebraic properties
"""

# ╔═╡ 64249528-77d1-11ec-2b57-434a9a80a931
md"""The dot product is similar to multiplication, but different, as it is an operation defined between vectors of the same dimension. However, many algebraic properties carry over:
"""

# ╔═╡ 6424965e-77d1-11ec-2622-c3d4c23a96e8
md"""  * commutative: $\vec{u} \cdot \vec{v} = \vec{v} \cdot \vec{u}$
  * scalar multiplication: $(c\vec{u})\cdot\vec{v} = c(\vec{u}\cdot\vec{v})$.
  * distributive $\vec{u} \cdot (\vec{v} + \vec{w}) = \vec{u} \cdot \vec{v} + \vec{u} \cdot \vec{w}$
"""

# ╔═╡ 64249690-77d1-11ec-295d-0fa79fa1f0dc
md"""The last two can be combined: $\vec{u}\cdot(s \vec{v} + t \vec{w}) = s(\vec{u}\cdot\vec{v}) + t (\vec{u}\cdot\vec{w})$.
"""

# ╔═╡ 642496a4-77d1-11ec-1c2e-bdeb6c055e03
md"""But associative does not make sense, as $(\vec{u} \cdot \vec{v}) \cdot \vec{w}$ does not make sense as two dot products: the result of the first is not a vector, but a scalar.
"""

# ╔═╡ 642496d6-77d1-11ec-34d1-bdff2b557e72
md"""## Matrices
"""

# ╔═╡ 6424971c-77d1-11ec-3dfa-fbcaef51f957
md"""Algebraically, the dot product of two vectors - pair off by components, multiply these, then add - is a common operation. Take for example, the general equation of a line, or a plane:
"""

# ╔═╡ 6424973a-77d1-11ec-37a5-ebaa3d925352
md"""```math
ax + by  = c, \quad ax + by + cz = d.
```
"""

# ╔═╡ 6424974e-77d1-11ec-0d3d-5d568e367711
md"""The left hand sides are in the form of a dot product, in this case $\langle a,b \rangle \cdot \langle x, y\rangle$ and  $\langle a,b,c \rangle \cdot \langle x, y, z\rangle$ respectively. When there is a system of equations, something like:
"""

# ╔═╡ 64249780-77d1-11ec-10d3-cd0956129c1b
md"""```math
\begin{array}{}
3x  &+& 4y  &- &5z &= 10\\
3x  &-& 5y  &+ &7z &= 11\\
-3x &+& 6y  &+ &9z &= 12,
\end{array}
```
"""

# ╔═╡ 642497b2-77d1-11ec-1d4a-53e7300695bf
md"""Then we might think of $3$ vectors $\langle 3,4,-5\rangle$, $\langle 3,-5,7\rangle$, and $\langle -3,6,9\rangle$ being dotted with $\langle x,y,z\rangle$. Mathematically, matrices and their associated algebra are used to represent this. In this example, the system of equations above would be represented by a matrix and two vectors:
"""

# ╔═╡ 642497bc-77d1-11ec-30e6-53b76a76bd1b
md"""```math
M = \left[
\begin{array}{}
3 & 4 & -5\\
5 &-5 &  7\\
-3& 6 & 9
\end{array}
\right],\quad
\vec{x} = \langle x, y , z\rangle,\quad
\vec{b} = \langle 10, 11, 12\rangle,
```
"""

# ╔═╡ 64249834-77d1-11ec-113b-8781d7f5e666
md"""and the expression $M\vec{x} = \vec{b}$. The matrix $M$ is a rectangular collection of numbers or expressions arranged in rows and columns with certain algebraic definitions. There are $m$ rows and $n$ columns in an $m\times n$ matrix. In this example $m=n=3$, and in such a case the matrix is called square. A vector, like $\vec{x}$ is usually identified with the $n \times 1$ matrix (a column vector). Were that done, the system of equations would be written $Mx=b$.
"""

# ╔═╡ 642498a2-77d1-11ec-229b-5b68533f4f63
md"""If we refer to a matrix $M$ by its components, a convention is to use $(M)_{ij}$ or $m_{ij}$ to denote the entry in the $i$th *row* and $j$th *column*. Following `Julia`'s syntax, we would use $m_{i:}$ to refer to *all* entries in the $i$th row, and $m_{:j}$ to denote *all* entries in the $j$ column.
"""

# ╔═╡ 642498d4-77d1-11ec-12e4-2db42c94d741
md"""In addition to square matrices, there are some other common types of matrices worth naming: square matrices with $0$ entries below the diagonal are called upper triangular; square matrices with $0$ entries above the diagonal are called lower triangular matrices; square matrices which are $0$ except possibly along the diagonal are diagonal matrices; and a diagonal matrix whose diagonal entries are all $1$ is called an identify matrix.
"""

# ╔═╡ 642498f2-77d1-11ec-2f0a-b3d95308ba88
md"""Matrices, like vectors, have scalar multiplication defined for them. then scalar multiplication of a matrix $M$ by $c$ just multiplies each entry by $c$, so the new matrix would have components defined by $cm_{ij}$.
"""

# ╔═╡ 6424991a-77d1-11ec-12a4-1912bfcb4ae9
md"""Matrices of the same size, like vectors, have addition defined for them. As with scalar multiplication, addition is defined component wise. So $A+B$ is the matrix with $ij$ entry $A_{ij} + B_{ij}$.
"""

# ╔═╡ 6424b03a-77d1-11ec-2d98-33f32266aab9
md"""### Matrix multiplication
"""

# ╔═╡ 6424b0bc-77d1-11ec-0656-2f7f851ac252
md"""Matrix multiplication may be viewed as a collection of dot product operations. First, matrix multiplication is only  defined between $A$ and $B$, as $AB$, if the size of $A$ is $m\times n$ and the size of $B$ is $n \times k$. That is the number of columns of $A$ must match the number of rows of $B$ for the left multiplication of $AB$ to be defined. If this is so, then we have the $ij$ entry of $AB$ is:
"""

# ╔═╡ 6424b0f8-77d1-11ec-11af-b5a470a02ee3
md"""```math
(AB)_{ij} = A_{i:} \cdot B_{:j}.
```
"""

# ╔═╡ 6424b148-77d1-11ec-1b19-254306629c4d
md"""That is, if we view the $i$th row of $A$ and the $j$th column of B as  *vectors*, then the $ij$ entry is the dot product.
"""

# ╔═╡ 6424b17a-77d1-11ec-1e74-c9d0a5ec40b7
md"""This is why $M$ in the example above, has the coefficients for each equation in a row and not a column, and why $\vec{x}$ is thought of as a $n\times 1$ matrix (a column vector) and not as a row vector.
"""

# ╔═╡ 6424b1c0-77d1-11ec-39dd-196c4a5dcc33
md"""Matrix multiplication between $A$ and $B$ is not, in general, commutative. Not only may the sizes not permit $BA$ to be found when $AB$ may be, there is just no guarantee when the sizes match that the components will be the same.
"""

# ╔═╡ 6424b224-77d1-11ec-095f-bf6895dbf2cc
md"""---
"""

# ╔═╡ 6424b23a-77d1-11ec-0cec-6599c024b865
md"""Matrices have other operations defined on them. We mention three here:
"""

# ╔═╡ 6424b3be-77d1-11ec-1a97-6353887be442
md"""  * The *transpose* of a matrix flips the difference between row and column, so the $ij$ entry of the transpose is the $ji$ entry of the matrix. This means the transpose will have size $n \times m$ when $M$ has size $m \times n$. Mathematically, the transpose is denoted $M^t$.
  * The *determinant* of a *square* matrix is a number that can be used to characterize the matrix. The determinant may be computed different ways, but its [definition](https://en.wikipedia.org/wiki/Leibniz_formula_for_determinants) by the Leibniz formula is common. Two special cases are all we need. The $2\times 2$ case and the $3 \times 3$ case:
"""

# ╔═╡ 6424b40e-77d1-11ec-3e6b-d363954ad765
md"""```math
\left|
\begin{array}{}
a&b\\
c&d
\end{array}
\right| =
ad - bc, \quad
\left|
\begin{array}{}
a&b&c\\
d&e&f\\
g&h&i
\end{array}
\right| =
a \left|
\begin{array}{}
e&f\\
h&i
\end{array}
\right|
- b \left|
\begin{array}{}
d&f\\
g&i
\end{array}
\right|
+c \left|
\begin{array}{}
d&e\\
g&h
\end{array}
\right|.
```
"""

# ╔═╡ 6424b44a-77d1-11ec-1702-e3d36d8b9c34
md"""The $3\times 3$ case shows how determinants may be [computed recursively](https://en.wikipedia.org/wiki/Determinant#Definition), using "cofactor" expansion.
"""

# ╔═╡ 6424b4d8-77d1-11ec-3005-7f53a3cf5ef7
md"""  * The *inverse* of a square matrix. If $M$ is a square matrix and its determinant is non-zero, then there is an *inverse* matrix, denoted $M^{-1}$, with the properties that $MM^{-1} = M^{-1}M = I$, where $I$ is the diagonal matrix of all $1$s called the identify matrix.
"""

# ╔═╡ 6424b4fe-77d1-11ec-0d21-7171947fd8c2
md"""### Matrices in Julia
"""

# ╔═╡ 6424b530-77d1-11ec-190a-258bb9376776
md"""As mentioned previously, a matrix in `Julia` is defined component by component with `[]`. We separate row entries with spaces and columns with semicolons:
"""

# ╔═╡ 6424c0f2-77d1-11ec-381a-274208806ce3
ℳ = [3 4 -5; 5 -5 7; -3 6 9]

# ╔═╡ 6424c124-77d1-11ec-0a4e-7faad9a50394
md"""Space is the separator, which means computing a component during definition (i.e., writing `2 + 3` in place of `5`) can be problematic, as no space can be used in the computation, lest it be parsed as a separator.
"""

# ╔═╡ 6424c16a-77d1-11ec-2046-71835743a40a
md"""Vectors are defined similarly. As they are identified with *column* vectors, we use a semicolon (or a comma) to separate:
"""

# ╔═╡ 6424c618-77d1-11ec-3e04-6783d33de647
𝒷 = [10, 11, 12]   # not 𝒷 = [10 11 12], which would be a row vector.

# ╔═╡ 6424c66a-77d1-11ec-288b-9371b25e886f
md"""In `Julia`, entries in a matrix (or a vector) are stored in a container with a type wide enough accomodate each entry. Here the type is SymPy's `Sym` type:
"""

# ╔═╡ 6424ce12-77d1-11ec-1552-e51bf19c3dd9
begin
	@syms x1 x2 x3
	𝓍 = [x1, x2, x3]
end

# ╔═╡ 6424ce3a-77d1-11ec-23e0-01443d1e5d65
md"""Matrices may also be defined from blocks. This example shows how to make two column vectors into a matrix:
"""

# ╔═╡ 6424d948-77d1-11ec-1a76-9540f05b5fad
begin
	𝓊 = [10, 11, 12]
	𝓋 = [13, 14, 15]
	[𝓊 𝓋]   # horizontally combine
end

# ╔═╡ 6424d9b6-77d1-11ec-078a-eb36e0693285
md"""Vertically combining the two will stack them:
"""

# ╔═╡ 6424ddc6-77d1-11ec-1371-19109970aa38
[𝓊; 𝓋]

# ╔═╡ 6424de20-77d1-11ec-3e0d-73834e7b191b
md"""Scalar multiplication will just work as expected:
"""

# ╔═╡ 6424e0e6-77d1-11ec-0675-35b5369f4e13
2 * ℳ

# ╔═╡ 6424e12c-77d1-11ec-207d-4d720d084c0b
md"""Matrix addition is also straightforward:
"""

# ╔═╡ 6424e37c-77d1-11ec-07d9-a1115ca35e7f
ℳ + ℳ

# ╔═╡ 6424e40e-77d1-11ec-2612-afaf43637dbf
md"""Matrix addition expects matrices of the same size. An error will otherwise be thrown. However, if addition is *broadcasted* then the sizes need only be commensurate. For example, this will add `1` to each entry of `M`:
"""

# ╔═╡ 6424e6f4-77d1-11ec-32d8-cfed16ba8504
ℳ .+ 1

# ╔═╡ 6424e780-77d1-11ec-1e3f-775afb3b1d33
md"""Matrix multiplication is defined by `*`:
"""

# ╔═╡ 642506c0-77d1-11ec-316d-f330d763ea5a
ℳ * ℳ

# ╔═╡ 642506f2-77d1-11ec-24d4-41b878b11ba3
md"""We can then see how the system of equations is represented with matrices:
"""

# ╔═╡ 64250968-77d1-11ec-22c8-ef62bc773718
ℳ * 𝓍 - 𝒷

# ╔═╡ 642509a4-77d1-11ec-3737-d79666b6ad66
md"""Here we use `SymPy` to verify the above:
"""

# ╔═╡ 64251796-77d1-11ec-2f8f-e906dd2cf072
begin
	𝒜 = [symbols("A$i$j", real=true) for i in 1:3, j in 1:2]
	ℬ = [symbols("B$i$j", real=true) for i in 1:2, j in 1:2]
end

# ╔═╡ 642517e6-77d1-11ec-0d55-37dc9df5456c
md"""The matrix product has the expected size: the number of rows of `A` (3) by the number of columns of `B` (2):
"""

# ╔═╡ 642519c6-77d1-11ec-34e4-692db112042d
𝒜 * ℬ

# ╔═╡ 64251a02-77d1-11ec-1415-ab9301108ce2
md"""This confirms how each entry (`(A*B)[i,j]`) is from a dot product (`A[i,:]  ⋅ B[:,j]`):
"""

# ╔═╡ 642523a8-77d1-11ec-1490-dfd507b7d1bd
[ (𝒜 * ℬ)[i,j] == 𝒜[i,:] ⋅ ℬ[:,j] for i in 1:3, j in 1:2]

# ╔═╡ 642523e4-77d1-11ec-3daa-0b97a7d836d0
md"""When the multiplication is broadcasted though, with `.*`, the operation will be component wise:
"""

# ╔═╡ 64252646-77d1-11ec-17d5-d1ef7184f169
ℳ .* ℳ   # component wise (Hadamard product)

# ╔═╡ 6425266e-77d1-11ec-2a44-539092cea164
md"""---
"""

# ╔═╡ 642526c8-77d1-11ec-2e0c-dfce6941f130
md"""The determinant is found through `det` provided by the built-in `LinearAlgebra` package:
"""

# ╔═╡ 64252894-77d1-11ec-0caa-0dc68db1671b
det(ℳ)

# ╔═╡ 642528bc-77d1-11ec-0395-d103dc4ca7d0
md"""---
"""

# ╔═╡ 642528e4-77d1-11ec-22d2-198ba906adbf
md"""The transpose of a matrix is found through `transpose` which doesn't create a new object, but rather an object which knows to switch indices when referenced:
"""

# ╔═╡ 64252a60-77d1-11ec-2f04-f5ce48268138
transpose(ℳ)

# ╔═╡ 64252ae2-77d1-11ec-0bde-95cf8d2b9904
md"""For matrices with *real* numbers, the transpose can be performed with the postfix operation `'`:
"""

# ╔═╡ 64252bfa-77d1-11ec-183c-6392ff282599
ℳ'

# ╔═╡ 64252c2c-77d1-11ec-2609-816dd6324744
md"""(However, this is not true for matrices with complex numbers as `'` is the "adjoint," that is, the transpose of the matrix *after* taking complex conjugates.)
"""

# ╔═╡ 64252c68-77d1-11ec-0645-2f3a8db17848
md"""With `u` and `v`, vectors from above, we have:
"""

# ╔═╡ 64254696-77d1-11ec-2b1e-497180545085
[𝓊' 𝓋']   # [𝓊 𝓋] was a 3 × 2 matrix, above

# ╔═╡ 642546f6-77d1-11ec-1b90-fb1f4530a025
md"""and
"""

# ╔═╡ 64254a2c-77d1-11ec-0dff-f9ea0a597061
[𝓊'; 𝓋']

# ╔═╡ 64256c98-77d1-11ec-121d-35725689dd3b
note("""
The adjoint is defined *recursively* in `Julia`. In the `CalculusWithJulia` package, we overload the `'` notation for *functions* to yield a univariate derivative found with automatic differentiation. This can lead to problems: if we have a matrix of functions, `M`, and took the transpose with `M'`, then the entries of `M'` would be the derivatives of the functions in `M` - not the original functions. This is very much likely to not be what is desired. The `CalculusWithJulia` package commits **type piracy** here *and* abuses the generic idea for `'` in Julia. In general type piracy is very much frowned upon, as it can change expected behaviour. It is defined in `CalculusWithJulia`, as that package is intended only to act as a means to ease users into the wider package ecosystem of `Julia`.
""")

# ╔═╡ 64256cdc-77d1-11ec-24f8-5d2a15a0cb0f
md"""---
"""

# ╔═╡ 64256d5c-77d1-11ec-22cf-233ed675d61d
md"""The dot product and matrix multiplication are related, and mathematically  identified through the relation: $\vec{u} \cdot \vec{v} = u^t v$, where the right hand side identifies $\vec{u}$ and $\vec{v}$ with a $n\times 1$ column matrix, and $u^t$ is the transpose, or a $1\times n$ row matrix. However, mathematically the left side is a scalar, but the right side a $1\times 1$ matrix. While distinct, the two are identified as the same. This is similar to the useful identification of a point and a vector. Within `Julia`, these identifications are context dependent. `Julia` stores vectors as $1$-dimensional arrays, transposes as $1$-dimensional objects, and matrices as $2$-dimensional arrays. The product of a transpose and a vector is a scalar:
"""

# ╔═╡ 6425742a-77d1-11ec-08a9-69aba82c22b5
let
	u, v = [1,1,2], [3,5,8]
	u' * v   # a scalar
end

# ╔═╡ 642574c0-77d1-11ec-1294-9376de1e6a9e
md"""But if we make `u` a matrix (here  by "`reshape`ing" in a matrix with $1$ row and $3$ columns), we will get a matrix (actually a vector) in return:
"""

# ╔═╡ 64257b50-77d1-11ec-192f-c118e4058bce
let
	u, v = [1,1,2], [3,5,8]
	reshape(u,(1,3)) * v
end

# ╔═╡ 64257b78-77d1-11ec-0006-fb54a8cc27de
md"""## Cross product
"""

# ╔═╡ 64257ba0-77d1-11ec-2ca3-d515f22745bf
md"""In three dimensions, there is a another operation between vectors that is similar to multiplication, though we will see with many differences.
"""

# ╔═╡ 64257bf0-77d1-11ec-159a-03492ed1851e
md"""Let $\vec{u}$ and $\vec{v}$ be two $3$-dimensional vectors, then the *cross* product, $\vec{u} \times \vec{v}$, is defined as a vector with length:
"""

# ╔═╡ 64257c18-77d1-11ec-08e2-75b37761c740
md"""```math
\| \vec{u} \times \vec{v} \| = \| \vec{u} \| \| \vec{v} \| \sin(\theta),
```
"""

# ╔═╡ 64257c54-77d1-11ec-0457-852419f90d83
md"""with $\theta$ being the angle in $[0, \pi]$ between $\vec{u}$ and $\vec{v}$. Consequently, $\sin(\theta) \geq 0$.
"""

# ╔═╡ 64257cc2-77d1-11ec-1202-59a3ce9dd85b
md"""The direction of the cross product is such that it is *orthogonal* to *both* $\vec{u}$ and $\vec{v}$. To identify this, the [right-hand rule](https://en.wikipedia.org/wiki/Cross_product#Definition) is used. This rule points the right hand fingers in the direction of $\vec{u}$ and curls them towards $\vec{v}$ (so that the angle between the two vectors is in $[0, \pi]$). The thumb will point in the direction. Call this direction $\hat{n}$, a normal unit vector. Then the cross product can be defined by:
"""

# ╔═╡ 64257ce0-77d1-11ec-1e63-ed52132f5fab
md"""```math
\vec{u} \times \vec{v} =  \| \vec{u} \| \| \vec{v} \| \sin(\theta) \hat{n}.
```
"""

# ╔═╡ 64258a1c-77d1-11ec-1eb2-d9c3c05db61d
note("""
The right-hand rule is also useful to understand how standard household screws will behave when twisted with a screwdriver. If the right hand fingers curl in the direction of the twisting screwdriver, then the screw will go in or out following the direction pointed to by the thumb.
""")

# ╔═╡ 6426e738-77d1-11ec-032d-c14da5bfaf10
md"""The right-hand rule depends on the order of consideration of the vectors. If they are reversed, the opposite direction is determined. A consequence is that the cross product is **anti**-commutative, unlike multiplication:
"""

# ╔═╡ 6426e7b0-77d1-11ec-28fb-fd3adbe9de1b
md"""```math
\vec{u} \times \vec{v} = - \vec{v} \times \vec{u}.
```
"""

# ╔═╡ 6426e7c4-77d1-11ec-012c-d9b040627933
md"""Mathematically, the definition in terms of its components is a bit involved:
"""

# ╔═╡ 6426e864-77d1-11ec-0f16-15d3a03af35e
md"""```math
\vec{u} \times \vec{v} = \langle u_2 v_3 - u_3 v_2, u_3 v_1 - u_1 v_3, u_1 v_2 - u_2 v_1 \rangle.
```
"""

# ╔═╡ 6426e90e-77d1-11ec-24eb-11039526beac
md"""There is a matrix notation that can simplify this computation. If we *formally* define $\hat{i}$, $\hat{j}$, and $\hat{k}$ to represent unit vectors in the $x$, $y$, and $z$ direction, then a vector $\langle u_1, u_2, u_3 \rangle$ could be written $u_1\hat{i} + u_2\hat{j} + u_3\hat{k}$. With this the cross product of $\vec{u}$ and $\vec{v}$ is the vector associated with the *determinant* of the matrix
"""

# ╔═╡ 6426e97c-77d1-11ec-12be-b5719a492a8c
md"""```math
\left[
\begin{array}{}
\hat{i} & \hat{j} & \hat{k}\\
u_1   & u_2   & u_3\\
v_1   & v_2   & v_3
\end{array}
\right] =
```
"""

# ╔═╡ 6426e9b8-77d1-11ec-06e2-652cefbe76ae
md"""From the $\sin(\theta)$ term in the definition, we see that $\vec{u}\times\vec{u}=0$. In fact, the cross product is $0$ only if the two vectors involved are parallel or there is a zero vector.
"""

# ╔═╡ 6426e9f6-77d1-11ec-29b7-ef6f68dd59c5
md"""In `Julia`, the `cross` function from the `LinearAlgebra` package (part of the standard library) implements the cross product. For example:
"""

# ╔═╡ 6426f188-77d1-11ec-3273-3f570bd592b2
begin
	𝓪 = [1, 2, 3]
	𝓫 = [4, 2, 1]
	cross(𝓪, 𝓫)
end

# ╔═╡ 6426f234-77d1-11ec-29da-7bac14fce82f
md"""There is also the *infix* unicode operator `\times[tab]` that can be used for similarity to traditional mathematical syntax.
"""

# ╔═╡ 6426f48a-77d1-11ec-3257-b5010d4f610c
𝓪 × 𝓫

# ╔═╡ 6426f4b2-77d1-11ec-3894-295b326fb32e
md"""We can see the cross product is anti-commutative by comparing the last answer with:
"""

# ╔═╡ 6426f5f2-77d1-11ec-1a4a-b9a03e2c9df0
𝓫 × 𝓪

# ╔═╡ 6426f642-77d1-11ec-0409-2f6e9736dc76
md"""Using vectors of size different than $n=3$ produces a dimension mismatch error:
"""

# ╔═╡ 6426f9f8-77d1-11ec-1da5-6f969ad2fdc7
[1, 2] × [3, 4]

# ╔═╡ 6426fa3e-77d1-11ec-3980-495da5bd604d
md"""(It can prove useful to pad 2-dimensional vectors into 3-dimensional vectors by adding a $0$ third component. We will see this in the discussion on curvature in the plane.)
"""

# ╔═╡ 6426fa66-77d1-11ec-13d5-07fa26eb2a75
md"""Let's see that the matrix definition will be identical (after identifications) to `cross`:
"""

# ╔═╡ 6427010a-77d1-11ec-034a-3b175be4de39
begin
	@syms î ĵ k̂
	𝓜 = [î ĵ k̂; 3 4 5; 3 6 7]
	det(𝓜) |> simplify
end

# ╔═╡ 64270128-77d1-11ec-2dfe-61ffa8ffbb46
md"""Compare with
"""

# ╔═╡ 642706aa-77d1-11ec-21dd-dfe9d6682552
𝓜[2,:] × 𝓜[3,:]

# ╔═╡ 642706dc-77d1-11ec-0e0f-03bf6262cf0c
md"""---
"""

# ╔═╡ 64270768-77d1-11ec-3d21-7d2a153d58ac
md"""Consider this extended picture involving two vectors $\vec{u}$ and $\vec{v}$ drawn in two dimensions:
"""

# ╔═╡ 64270d30-77d1-11ec-1ee0-bb4c8639ed03
begin
	u₁ = [1, 2]
	v₁ = [2, 1]
	p₁ = [0,0]
	
	plot(aspect_ratio=:equal)
	arrow!(p₁, u₁)
	arrow!(p₁, v₁)
	arrow!(u₁, v₁)
	arrow!(v₁, u₁)
	
	puv₁ = (u₁ ⋅ v₁) / (v₁ ⋅ v₁) * v₁
	porth₁ = u₁ - puv₁
	arrow!(puv₁, porth₁)
end

# ╔═╡ 64270dbe-77d1-11ec-3c08-7f49d703e3c7
md"""The enclosed shape is a parallelogram. To this we added the projection of $\vec{u}$ onto $\vec{v}$ (`puv`) and then the *orthogonal* part (`porth`).
"""

# ╔═╡ 64270e34-77d1-11ec-31c5-9b0cb21b95fa
md"""The *area* of a parallelogram is the length of one side times the perpendicular height. The perpendicular height could be found from `norm(porth)`, so the area is:
"""

# ╔═╡ 642711ea-77d1-11ec-1026-b16aa5806bd6
norm(v₁) * norm(porth₁)

# ╔═╡ 64271262-77d1-11ec-084d-1fcfdf42af95
md"""However, from trigonometry we have the height would also be the norm of $\vec{u}$ times $\sin(\theta)$, a value that is given through the length of the cross product of $\vec{u}$ and $\hat{v}$, the unit vector, were these vectors viewed as $3$ dimensional by adding a $0$ third component. In formulas, this is also the case:
"""

# ╔═╡ 64271280-77d1-11ec-2937-b504e40e33ad
md"""```math
\text{area of the parallelogram} = \| \vec{u} \times \hat{v} \| \| \vec{v} \| = \| \vec{u} \times \vec{v} \|.
```
"""

# ╔═╡ 642712ba-77d1-11ec-2c69-1f8582a80594
md"""We have, for our figure, after extending `u` and `v` to be three dimensional the area of the parallelogram:
"""

# ╔═╡ 642717bc-77d1-11ec-23a2-17fe2591d8f3
begin
	u₂ = [1, 2, 0]
	v₂ = [2, 1, 0]
	norm(u₂ × v₂)
end

# ╔═╡ 642717da-77d1-11ec-1bfe-9d42d5395dce
md"""---
"""

# ╔═╡ 64271802-77d1-11ec-3a70-dd746645a8fb
md"""This analysis can be extended to the case of 3 vectors, which - when not co-planar - will form a *parallelepiped*.
"""

# ╔═╡ 642720e0-77d1-11ec-3903-59262cb991fe
begin
	u₃, v₃, w₃ = [1,2,3], [2,1,0], [1,1,2]
	plot()
	p₃ = [0,0,0]
	
	plot(legend=false)
	arrow!(p₃, u₃); arrow!(p₃, v₃); arrow!(p₃, w₃)
	arrow!(u₃, v₃); arrow!(u₃, w₃)
	arrow!(v₃, u₃); arrow!(v₃, w₃)
	arrow!(w₃, u₃); arrow!(w₃, v₃)
	arrow!(u₃ + v₃, w₃); arrow!(u₃ + w₃, v₃); arrow!(v₃ + w₃, u₃)
end

# ╔═╡ 64272130-77d1-11ec-0cc2-e13ee47485cd
md"""The volume of a parallelepiped is the area of a base parallelogram times the height of a perpendicular. If $\vec{u}$ and $\vec{v}$ form the base parallelogram, then the perpendicular will have height $\|\vec{w}\| \cos(\theta)$ where the angle is the one made by $\vec{w}$ with the normal, $\vec{n}$. Since $\vec{u} \times \vec{v} = \| \vec{u} \times \vec{v}\|  \hat{n} = \hat{n}$ times the area of the base parallelogram, we have if we dot this answer with $\vec{w}$:
"""

# ╔═╡ 64272162-77d1-11ec-020d-6fc43d8eb775
md"""```math
(\vec{u} \times \vec{v}) \cdot \vec{w} =
\|\vec{u} \times \vec{v}\| (\vec{n} \cdot \vec{w}) =
\|\vec{u} \times \vec{v}\| \| \vec{w}\| \cos(\theta),
```
"""

# ╔═╡ 642721ce-77d1-11ec-2610-33f8221e7e9b
md"""that is, the area of the parallelepiped. Wait, what about $(\vec{v}\times\vec{u})\cdot\vec{w}$? That will have an opposite sign. Yes, in the above, there is an assumption that $\vec{n}$ and $\vec{w}$ have a an angle between them within $[0, \pi/2]$, otherwise an absolute value must be used, as volume is non-negative.
"""

# ╔═╡ 64273468-77d1-11ec-3086-31552d8b98d0
note(L"""
The triple-scalar product, $\vec{u}\cdot(\vec{v}\times\vec{w})$, gives the volume of the parallelepiped up to sign. If the sign of this is positive, the ``3`` vectors are said to have a *positive* orientation, if the triple-scalar product is negative, the vectors have a *negative* orientation.
""", title="Orientation")

# ╔═╡ 64273512-77d1-11ec-3842-6757c76e93cc
md"""#### Algebraic properties
"""

# ╔═╡ 64273544-77d1-11ec-1dda-29232d9069ec
md"""The cross product has many properties, some different from regular multiplication:
"""

# ╔═╡ 6428fc42-77d1-11ec-0ad9-936d6f4baf47
md"""  * scalar multiplication: $(c\vec{u})\times\vec{v} = c(\vec{u}\times\vec{v})$
  * distributive over addition: $\vec{u} \times (\vec{v} + \vec{w}) = \vec{u}\times\vec{v} + \vec{u}\times\vec{w}$.
  * *anti*-commutative: $\vec{u} \times \vec{v} = - \vec{v} \times \vec{u}$
  * *not* associative: that is there is no guarantee that $(\vec{u}\times\vec{v})\times\vec{w}$ will be equivalent to $\vec{u}\times(\vec{v}\times\vec{w})$.
  * The triple cross product $(\vec{u}\times\vec{v}) \times \vec{w}$ must be orthogonal to $\vec{u}\times\vec{v}$ so lies in a plane with this as a normal vector. But, $\vec{u}$ and $\vec{v}$ will generate this plane, so it should be possible to express this triple product in terms of a sum involving $\vec{u}$ and $\vec{v}$ and indeed:
"""

# ╔═╡ 6428fc9e-77d1-11ec-392b-8b081ef50bf1
md"""```math
(\vec{u}\times\vec{v})\times\vec{w} = (\vec{u}\cdot\vec{w})\vec{v} - (\vec{v}\cdot\vec{w})\vec{u}.
```
"""

# ╔═╡ 6428fcbc-77d1-11ec-2afc-bd4b6433daaf
md"""---
"""

# ╔═╡ 6428fd5c-77d1-11ec-1b4a-bd4086a7a4a4
md"""The following shows the algebraic properties stated above hold for symbolic vectors. First the linearity of the dot product:
"""

# ╔═╡ 642925ea-77d1-11ec-1294-8d6450f341f9
begin
	@syms s₄ t₄ u₄[1:3]::real v₄[1:3]::real w₄[1:3]::real
	
	u₄ ⋅ (s₄ * v₄ + t₄ * w₄) - (s₄ * (u₄ ⋅ v₄) + t₄ * (u₄ ⋅ w₄)) |> simplify
end

# ╔═╡ 64292642-77d1-11ec-2cb4-8196f22ce78f
md"""This shows the dot product is commutative:
"""

# ╔═╡ 64292c8c-77d1-11ec-3ad8-9d58a5d37f4a
(u₄ ⋅ v₄) - (v₄ ⋅ u₄) |> simplify

# ╔═╡ 64292cc0-77d1-11ec-1a3d-ed1123f75025
md"""This shows the linearity of the cross product over scalar multiplication and vector addition:
"""

# ╔═╡ 642935b0-77d1-11ec-3778-6f292c7b4d2c
u₄ × (s₄* v₄ + t₄ * w₄) - (s₄ * (u₄ × v₄) + t₄ * (u₄ × w₄)) .|> simplify

# ╔═╡ 6429360a-77d1-11ec-3418-8fcdcf115109
md"""(We use `.|>` to broadcast `simplify` over each component.)
"""

# ╔═╡ 64293632-77d1-11ec-34d0-170821bebfba
md"""The cross product is anti-commutative:
"""

# ╔═╡ 64293970-77d1-11ec-0da5-e5891f59e063
u₄ × v₄ + v₄ × u₄ .|> simplify

# ╔═╡ 642939e8-77d1-11ec-2420-5d04f596476f
md"""but not associative:
"""

# ╔═╡ 64293efc-77d1-11ec-388b-21df51db973c
u₄ × (v₄ × w₄) - (u₄ × v₄) × w₄ .|> simplify

# ╔═╡ 64293fc4-77d1-11ec-0bff-95cd7691d215
md"""Finally we verify the decomposition of the triple cross product:
"""

# ╔═╡ 6429473a-77d1-11ec-28c4-b7f2ae863445
(u₄ × v₄) × w₄ - ( (u₄ ⋅ w₄) * v₄ - (v₄ ⋅ w₄) * u₄) .|> simplify

# ╔═╡ 64294794-77d1-11ec-17de-877bdc0fef30
md"""---
"""

# ╔═╡ 64294802-77d1-11ec-3bde-45da736306cd
md"""This table shows common usages of the symbols for various multiplication types: `*`, $\cdot$, and $\times$:
"""

# ╔═╡ 649a28f6-77d1-11ec-1b16-795f9190636c
md"""|  Symbol  | inputs         | output      | type                   |
|:--------:|:-------------- |:----------- |:---------------------- |
|   `*`    | scalar, scalar | scalar      | regular multiplication |
|   `*`    | scalar, vector | vector      | scalar multiplication  |
|   `*`    | vector, vector | *undefined* |                        |
| $\cdot$  | scalar, scalar | scalar      | regular multiplication |
| $\cdot$  | scalar, vector | vector      | scalar multiplication  |
| $\cdot$  | vector, vector | scalar      | dot product            |
| $\times$ | scalar, scalar | scalar      | regular multiplication |
| $\times$ | scalar, vector | undefined   |                        |
| $\times$ | vector, vector | vector      | cross product ($3$D)   |
"""

# ╔═╡ 649a2982-77d1-11ec-1f3f-39414fb3b730
md"""##### Example: lines and planes
"""

# ╔═╡ 649a29fa-77d1-11ec-0369-4d79a30df985
md"""A line in two dimensions satisfies the equation $ax + by = c$. Suppose $a$ and $b$ are non-zero. This can be represented in vector form, as the collection of all points associated to the vectors: $p + t \vec{v}$ where $p$ is a point on the line, say $(0,c/b)$, and v is the vector $\langle b, -a \rangle$. We can verify, this for values of `t` as follows:
"""

# ╔═╡ 649a330a-77d1-11ec-10fa-473441da2ab2
let
	@syms a b c x y t
	
	eq = c - (a*x + b*y)
	
	p = [0, c/b]
	v = [-b, a]
	li = p + t * v
	
	eq(x=>li[1], y=>li[2]) |> simplify
end

# ╔═╡ 649a3350-77d1-11ec-1a4d-55adb342b2f3
md"""Let $\vec{n} = \langle a , b \rangle$, taken from the coefficients in the equation. We can see directly that $\vec{n}$ is orthogonal to $\vec{v}$. The line may then be seen as the collection of all vectors that are orthogonal to $\vec{n}$ that have their tail at the point $p$.
"""

# ╔═╡ 649a3382-77d1-11ec-3ea3-85257e82a845
md"""In three dimensions, the equation of a plane is $ax + by + cz = d$. Suppose, $a$, $b$, and $c$ are non-zero, for simplicity. Setting $\vec{n} = \langle a,b,c\rangle$ by comparison, it can be seen that plane is identified with the set of all vectors orthogonal to $\vec{n}$ that are anchored at $p$.
"""

# ╔═╡ 649a33aa-77d1-11ec-01e6-1346b7ef9778
md"""First, let $p = (0, 0, d/c)$ be a point on the plane. We find two vectors $u = \langle -b, a, 0 \rangle$ and $v = \langle 0, c, -b \rangle$. Then any point on the plane may be identified with the vector $p + s\vec{u} + t\vec{v}$. We can verify this algebraically through:
"""

# ╔═╡ 649a3ae4-77d1-11ec-1432-a14d1f77b430
let
	@syms a b c d x y z s t
	
	eq = d - (a*x + b*y + c * z)
	
	p = [0, 0, d/c]
	u, v = [-b, a, 0], [0, c, -b]
	pl = p + t * u + s * v
	
	subs(eq, x=>pl[1], y=>pl[2], z=>pl[3]) |> simplify
end

# ╔═╡ 649a3af6-77d1-11ec-0ecf-dfeb7e9a0fa1
md"""The above viewpoint can be reversed:
"""

# ╔═╡ 649dab48-77d1-11ec-3a20-4de7d644f7a7
md"""> a plane is determined by two (non-parallel) vectors and a point.

"""

# ╔═╡ 649dabd4-77d1-11ec-1fe3-57c730f18a44
md"""The parameterized version of the plane would be $p + t \vec{u} + s \vec{v}$, as used above.
"""

# ╔═╡ 649dac2e-77d1-11ec-2412-73d1fe6a6a67
md"""The equation of the plane can be given from $\vec{u}$ and $\vec{v}$. Let $\vec{n} = \vec{u} \times \vec{v}$. Then $\vec{n} \cdot \vec{u} = \vec{n} \cdot \vec{v} = 0$, from the properties of the cross product. As such, $\vec{n} \cdot (s \vec{u} + t \vec{v}) = 0$. That is, the cross product is orthogonal to any *linear* combination of the two vectors. This figure shows one such linear combination:
"""

# ╔═╡ 649db41c-77d1-11ec-3ae6-1d9208c361f2
let
	u = [1,2,3]
	v = [2,3,1]
	n = u × v
	p = [0,0,1]
	
	plot(legend=false)
	
	arrow!(p, u)
	arrow!(p, v)
	arrow!(p + u, v)
	arrow!(p + v, u)
	arrow!(p, n)
	
	s, t = 1/2, 1/4
	arrow!(p, s*u + t*v)
end

# ╔═╡ 649db46c-77d1-11ec-2ba9-93af0f3b441b
md"""So if $\vec{n} \cdot p = d$ (identifying the point $p$ with a vector so the dot product is defined), we will have for any vector $\vec{v} = \langle x, y, z \rangle = s \vec{u} + t \vec{v}$ that
"""

# ╔═╡ 649db496-77d1-11ec-0a5e-e9d71e1f6e61
md"""```math
\vec{n} \cdot (p + s\vec{u} + t \vec{v}) = \vec{n} \cdot p + \vec{n} \cdot (s \vec{u} + t \vec{v}) = d + 0 = d,
```
"""

# ╔═╡ 649db4c8-77d1-11ec-12bf-d3473adb8e9c
md"""But if $\vec{n} = \langle a, b, c \rangle$, then this says $d = ax + by + cz$, so from $\vec{n}$ and $p$ the equation of the plane is given.
"""

# ╔═╡ 649db4e4-77d1-11ec-1f05-db723a3bff63
md"""In summary:
"""

# ╔═╡ 649db674-77d1-11ec-32f1-dfb303fb5c71
md"""| Object |      Equation      | vector equation                  |
|:------ |:------------------:|:-------------------------------- |
| Line   |   $ax + by = c$    | line: $p + t\vec{u}$             |
| Plane  | $ax + by + cz = d$ | plane: $p + s\vec{u} + t\vec{v}$ |
"""

# ╔═╡ 649db6a6-77d1-11ec-3e76-3be7790f5be6
md"""---
"""

# ╔═╡ 649db6ce-77d1-11ec-2b34-4ba7c1c313b3
md"""##### Example
"""

# ╔═╡ 649db6ec-77d1-11ec-0818-299b38d360ef
md"""You are given that the vectors $\vec{u} =\langle 6, 3, 1 \rangle$ and $\vec{v} = \langle 3, 2, 1 \rangle$ describe a plane through the point $p=[1,1,2]$. Find the equation of the plane.
"""

# ╔═╡ 649db700-77d1-11ec-33c7-df9f74cc762e
md"""The key is to find the normal vector to the plane, $\vec{n} = \vec{u} \times \vec{v}$:
"""

# ╔═╡ 649dbfac-77d1-11ec-10d6-d1eea2925905
let
	u, v, p = [6,3,1], [3,2,1], [1,1,2]
	n = u × v
	a, b, c = n
	d = n ⋅ p
	"equation of plane: $a x + $b y + $c z = $d"
end

# ╔═╡ 649dbfde-77d1-11ec-036d-e3cb54d4571f
md"""## Questions
"""

# ╔═╡ 649dd8ac-77d1-11ec-001f-b54c77cde2fa
md"""###### Question
"""

# ╔═╡ 649dd91a-77d1-11ec-340d-15bd75a69b8c
md"""Let `u=[1,2,3]`, `v=[4,3,2]`, and `w=[5,2,1]`.
"""

# ╔═╡ 649dd956-77d1-11ec-1fed-1912919f3191
md"""Find `u ⋅ v`:
"""

# ╔═╡ 649de32e-77d1-11ec-3d51-9f109dd86063
let
	u,v,w = [1,2,3], [4,3,2], [5,2,1]
	numericq(dot(u,v))
end

# ╔═╡ 649de360-77d1-11ec-2fe2-03a0b8da70e3
md"""Are `v` and `w` orthogonal?
"""

# ╔═╡ 649deb94-77d1-11ec-2dfb-97e2790233f9
let
	u,v,w = [1,2,3], [4,3,2], [5,2,1]
	ans = dot(v,w) == 0
	yesnoq(ans)
end

# ╔═╡ 649debd0-77d1-11ec-069a-6b4f6c2da63d
md"""Find the angle between `u` and `w`:
"""

# ╔═╡ 649df3f0-77d1-11ec-12e5-037f6932a004
let
	u,v,w = [1,2,3], [4,3,2], [5,2,1]
	ctheta = (u ⋅ w)/norm(u)/norm(w)
	val = acos(ctheta)
	numericq(val)
end

# ╔═╡ 649df42c-77d1-11ec-0d99-8f74f54acb9b
md"""Find `u ×  v`:
"""

# ╔═╡ 649dfb8e-77d1-11ec-1e5d-0938094d1ae8
let
	choices = [
	"`[-5, 10, -5]`",
	"`[-1, 6, -7]`",
	"`[-4, 14, -8]`"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649dfbb6-77d1-11ec-25a2-e3b6060f4dbc
md"""Find the area of the parallelogram formed by `v` and `w`
"""

# ╔═╡ 649e1a6a-77d1-11ec-26bf-89a49500a08d
let
	u,v,w = [1,2,3], [4,3,2], [5,2,1]
	val = norm(v  × w)
	numericq(val)
end

# ╔═╡ 649e1aba-77d1-11ec-2b08-07b5ebf43409
md"""Find the  volume of the parallelepiped formed by `u`, `v`, and `w`:
"""

# ╔═╡ 649e53ce-77d1-11ec-3e68-ed7c8eb0317f
let
	u,v,w = [1,2,3], [4,3,2], [5,2,1]
	val = abs((u × v) ⋅ w)
	numericq(val)
end

# ╔═╡ 649e5426-77d1-11ec-0cab-41cfa8bd56d2
md"""###### Question
"""

# ╔═╡ 649e5460-77d1-11ec-1bf3-d9a3ce823212
md"""The dot product of two vectors may be described in words: pair off the corresponding values, multiply them, then add. In `Julia` the `zip` command will pair off two iterable objects, like vectors, so it seems like this command: `sum(prod.(zip(u,v)))` will find a dot product. Investigate  if it is does or doesn't by testing the following command and comparing to the dot product:
"""

# ╔═╡ 649e54b2-77d1-11ec-0c16-cf5aaa3f8a9d
md"""```
u,v = [1,2,3], [5,4,2]
sum(prod.(zip(u,v)))
```"""

# ╔═╡ 649e54d0-77d1-11ec-2643-bf7bb5a49180
md"""Does this return the same answer:
"""

# ╔═╡ 649e56fe-77d1-11ec-0b06-7f789787afff
let
	yesnoq(true)
end

# ╔═╡ 649e5730-77d1-11ec-20e5-254c849c0ac9
md"""What does command `zip(u,v)` return?
"""

# ╔═╡ 649e607e-77d1-11ec-19c5-b12292b06379
let
	choices = [
	"An object of type `Base.Iterators.Zip` that is only realized when used",
	"A vector of values `[(1, 5), (2, 4), (3, 2)]`"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649e60ba-77d1-11ec-26f0-93f099cd4d10
md"""What does `prod.(zip(u,v))` return?
"""

# ╔═╡ 649e6998-77d1-11ec-0da8-15dca8d607c7
let
	choices = [
	"A vector of values `[5, 8, 6]`",
	"An object of type `Base.Iterators.Zip` that when realized will produce a vector of values"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649e69ac-77d1-11ec-161e-b92f8a38ffba
md"""###### Question
"""

# ╔═╡ 649e6a06-77d1-11ec-0880-d170a3b72a82
md"""Let $\vec{u}$ and $\vec{v}$ be 3-dimensional **unit** vectors. What is the value of
"""

# ╔═╡ 649e6a92-77d1-11ec-0723-2164c0edda67
md"""```math
(\vec{u} \times \vec{v}) \cdot (\vec{u} \times \vec{v}) + (\vec{u} \cdot \vec{v})^2?
```
"""

# ╔═╡ 649e72c6-77d1-11ec-118a-8bb9c962c161
let
	choices = [
	"``1``",
	"``0``",
	"Can't say in general"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649e730c-77d1-11ec-0327-d917639245b9
md"""###### Question
"""

# ╔═╡ 649e733e-77d1-11ec-001c-5f5dfc0c4632
md"""Consider the projection of $\langle 1, 2, 3\rangle$ on $\langle 3, 2, 1\rangle$. What is its length?
"""

# ╔═╡ 649e79c4-77d1-11ec-140e-a54df5e44b36
let
	u,v = [1,2,3], [3,2,1]
	val = (u ⋅ v)/norm(v)
	numericq(val)
end

# ╔═╡ 649e79f6-77d1-11ec-393a-59d99cda3460
md"""###### Question
"""

# ╔═╡ 649e7a46-77d1-11ec-0b39-916232385766
md"""Let $\vec{u} = \langle 1, 2, 3 \rangle$ and $\vec{v} = \langle 3, 2, 1 \rangle$. Describe the plane created by these two non-parallel vectors going through the origin.
"""

# ╔═╡ 649e81e4-77d1-11ec-1b21-b31eebc31dee
let
	choices = [
	"``-4x + 8y - 4z = 0``",
	"``x + 2y + z = 0``",
	"``x + 2y + 3z = 6``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649e8220-77d1-11ec-0eb7-255ff0b42afd
md"""###### Question
"""

# ╔═╡ 649e8284-77d1-11ec-223e-d355038ac981
md"""A plane $P_1$ is *orthogonal* to $\vec{n}_1$, a plane $P_2$ is *orthogonal* to $\vec{n}_2$. Explain why vector $\vec{v} = \vec{n}_1 \times \vec{n}_2$ is parallel to the *intersection* of $P_1$ and $P_2$.
"""

# ╔═╡ 649e93b2-77d1-11ec-12a8-07bd98d9274b
let
	choices = [
	" ``\\vec{v}`` is in plane ``P_1``, as it is orthogonal to ``\\vec{n}_1`` and ``P_2`` as it is orthogonal to ``\\vec{n}_2``, hence it is parallel to both planes.",
	" ``\\vec{n}_1`` and ``\\vec{n_2}`` are unit vectors, so the cross product gives the projection, which must be orthogonal to each vector, hence in the intersection"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649e93d2-77d1-11ec-0623-5dd019928d08
md"""###### Question
"""

# ╔═╡ 649e93e6-77d1-11ec-2842-ed2be8b1f656
md"""(From Strang). For an (analog) clock draw vectors from the center out to each of the 12 hours marked on the clock. What is the vector sum of these 12 vectors?
"""

# ╔═╡ 649eb4e8-77d1-11ec-1858-8b3307572e3e
let
	choices = [
	"``\\vec{0}``",
	"``\\langle 12, 12 \\rangle``",
	"``12 \\langle 1, 0 \\rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649eb542-77d1-11ec-015e-a1581e6b322a
md"""If the vector to 3 o'clock is removed, (call this $\langle 1, 0 \rangle$) what expresses the sum of *all* the remaining vectors?
"""

# ╔═╡ 649ebf38-77d1-11ec-17fb-cb2e2f914f98
let
	choices = [
	"``\\langle -1, 0 \\rangle``",
	"``\\langle 1, 0 \\rangle``",
	"``\\langle 11, 11 \\rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649ebf54-77d1-11ec-10a1-d77a1f362f7b
md"""###### Question
"""

# ╔═╡ 649ebf92-77d1-11ec-3eab-efc952749cae
md"""Let $\vec{u}$ and $\vec{v}$ be unit vectors. Let $\vec{w} = \vec{u} + \vec{v}$. Then $\vec{u} \cdot \vec{w} = \vec{v} \cdot \vec{w}$. What is the value?
"""

# ╔═╡ 649ecb38-77d1-11ec-2dde-212ec8c24396
let
	choices = [
	"``1 + \\vec{u}\\cdot\\vec{v}``",
	"``\\vec{u} + \\vec{v}``",
	"``\\vec{u}\\cdot\\vec{v} + \\vec{v}\\cdot \\vec{v}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649ecb54-77d1-11ec-3dd2-49f0596b774d
md"""As the two are equal, which interpretation is true?
"""

# ╔═╡ 649ed64e-77d1-11ec-0e1f-69c3b4b57cbb
let
	choices = [
	"The angle they make with ``\\vec{w}`` is the same",
	"The vector ``\\vec{w}`` must also be a unit vector",
	"the two are orthogonal"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 649ed680-77d1-11ec-062b-3b3f12a88b5f
md"""###### Question
"""

# ╔═╡ 649ed69e-77d1-11ec-1662-79e87e7ef1bb
md"""Suppose $\| \vec{u} + \vec{v} \|^2 = \|\vec{u}\|^2 + \|\vec{v}\|^2$. What is $\vec{u}\cdot\vec{v}$?
"""

# ╔═╡ 649ed6bc-77d1-11ec-28a6-8d6bcd97062b
md"""We have $(\vec{u} + \vec{v})\cdot(\vec{u} + \vec{v}) = \vec{u}\cdot \vec{u} + 2 \vec{u}\cdot\vec{v} + \vec{v}\cdot\vec{v}$. From this, we can infer that:
"""

# ╔═╡ 649ee102-77d1-11ec-0157-b74aff8f0fe8
let
	choices = [
	"``\\vec{u}\\cdot\\vec{v} = 0``",
	"``\\vec{u}\\cdot\\vec{v} = 2``",
	"``\\vec{u}\\cdot\\vec{v} = -(\\vec{u}\\cdot\\vec{u} \\vec{v}\\cdot\\vec{v})``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649ee12a-77d1-11ec-27cd-5f44376fc302
md"""###### Question
"""

# ╔═╡ 649ee13e-77d1-11ec-0a38-4b3243464964
md"""Give a geometric reason for this identity:
"""

# ╔═╡ 649ee170-77d1-11ec-1c15-9ddf9806bded
md"""```math
\vec{u} \cdot (\vec{v} \times \vec{w}) =
\vec{v} \cdot (\vec{w} \times \vec{u}) =
\vec{w} \cdot (\vec{u} \times \vec{v})
```
"""

# ╔═╡ 649eed82-77d1-11ec-2f9d-57ee32a97f65
let
	choices = [
	"The triple product describes a volume up to sign, this combination preserves the sign",
	"The vectors are *orthogonal*, so these are all zero",
	"The vectors are all unit lengths, so these are all 1"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649eeda0-77d1-11ec-0901-f751391c59ae
md"""###### Question
"""

# ╔═╡ 649eedc6-77d1-11ec-0597-796fe171ef05
md"""Snell's law in planar form is $n_1\sin(\theta_1) = n_2\sin(\theta_2)$ where $n_i$ is a constant depending on the medium.
"""

# ╔═╡ 649ef250-77d1-11ec-2d97-594b80359794
let
	f(t) = sin(t)
	p = plot(ylim=(.2,1.5), xticks=nothing, yticks=nothing, border=:none, legend=false, aspect_ratio=:equal)
	plot!(f, pi/6, pi/2, linewidth=4, color=:blue)
	t0 = pi/3
	p0 = [t0, f(t0)]
	Normal = [f'(t0), -t0]
	arrow!(p0, .5 * Normal, linewidth=4, color=:red )
	incident = (Normal + [.5, 0]) * .5
	arrow!(p0 - incident, incident, linewidth=4, color=:black)
	out = -incident + [.1,0]
	arrow!(p0, -out, linewidth=4, color=:black)
	annotate!([(0.8, 1.0, L"\hat{v}_1"),
	        (.6, .75, L"n_1"),
	        (1.075, 0.7, L"\hat{N}"),
	        (1.25, 0.7, L"\hat{v}_2"),
	        (1.5, .75, L"n_2")
	        ])
	
	p
end

# ╔═╡ 649ef282-77d1-11ec-3b24-fb4e11fc6d52
md"""In vector form, we can express it using *unit* vectors through:
"""

# ╔═╡ 649efc28-77d1-11ec-0a9e-3d4786876da0
let
	choices = [
	"``n_1 (\\hat{v_1}\\times\\hat{N}) = n_2  (\\hat{v_2}\\times\\hat{N})``",
	"``n_1 (\\hat{v_1}\\times\\hat{N}) = -n_2  (\\hat{v_2}\\times\\hat{N})``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649efc50-77d1-11ec-3fec-d713767e2c0f
md"""###### Question
"""

# ╔═╡ 649efc82-77d1-11ec-2856-1d2593f39a95
md"""The Jacobi relationship show that for *any* $3$ randomly chosen vectors:
"""

# ╔═╡ 649efca0-77d1-11ec-090e-11b135cda063
md"""```math
\vec{a}\times(\vec{b}\times\vec{c})+
\vec{b}\times(\vec{c}\times\vec{a})+
\vec{c}\times(\vec{a}\times\vec{b})
```
"""

# ╔═╡ 649efcfa-77d1-11ec-2c9c-43e907825987
md"""simplifies. To what? (Use `SymPy` or randomly generated vectors to see.)
"""

# ╔═╡ 649f0498-77d1-11ec-3af9-01f9d3865782
let
	choices = [
	"``\\vec{0}``",
	"``\\vec{a}``",
	"``\\vec{a} + \\vec{b} + \\vec{c}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 649f04c0-77d1-11ec-044b-2dabd316cc4b
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/polar_coordinates.html">◅ previous</a>  <a href="../differentiable_vector_calculus/vector_valued_functions.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/vectors.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 649f04ca-77d1-11ec-3b47-81cc60eeb7ed
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
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
# ╟─649f04ac-77d1-11ec-079a-59c1ebb14d70
# ╟─640f6f40-77d1-11ec-2a62-9b82c327e94f
# ╟─640f8390-77d1-11ec-0c2b-83f20be35a2a
# ╠═640fc238-77d1-11ec-1bb3-ed96ea3fc81c
# ╟─640fc9a4-77d1-11ec-20dc-59e51a11ac88
# ╟─640fc9f4-77d1-11ec-346d-6f5dd04ee798
# ╟─640fcb02-77d1-11ec-24a5-2362600beb0e
# ╟─640fcb70-77d1-11ec-3b41-813b167368c6
# ╟─640fcbb6-77d1-11ec-1e9a-93baa44f435b
# ╟─640fcbde-77d1-11ec-294c-51e48d8062f3
# ╟─641229ee-77d1-11ec-3bbd-59e600cb5148
# ╟─64123fcc-77d1-11ec-2241-c3393c3c0fc8
# ╟─64124094-77d1-11ec-3eb0-b1efbedeb0f3
# ╟─64124120-77d1-11ec-11f0-2b9855dc8072
# ╟─6412417a-77d1-11ec-2126-77cc15d50098
# ╟─641241c0-77d1-11ec-1f47-7d3e1637c8ba
# ╠═64127b5e-77d1-11ec-05b6-d39ec7962874
# ╟─64127bb6-77d1-11ec-0952-a58e04db528d
# ╠═64127de8-77d1-11ec-32af-a5377118a2cc
# ╟─64127e1a-77d1-11ec-03ea-bf4ee007b37b
# ╟─64127e42-77d1-11ec-2da4-cf218c869b3e
# ╠═64128068-77d1-11ec-1d28-3161199f3b3a
# ╟─6412809a-77d1-11ec-0c10-e9a4356a3942
# ╟─641280ea-77d1-11ec-3626-41b1b3528e82
# ╟─64128112-77d1-11ec-2c6b-856d33b6d8f6
# ╟─6412816c-77d1-11ec-0e3a-77a4d6d0f7a1
# ╟─6412819e-77d1-11ec-2970-6d1dafd914bd
# ╟─64128220-77d1-11ec-1eb1-eb7884e940ea
# ╟─6412823e-77d1-11ec-0768-912e8e4a4f10
# ╟─641282a2-77d1-11ec-105a-e503b9494e1a
# ╟─641282de-77d1-11ec-1dbe-ab4e51a55856
# ╠═64128b80-77d1-11ec-3ebc-0bbf69e99d23
# ╟─64128bce-77d1-11ec-1e38-510552f90336
# ╟─64128c70-77d1-11ec-2cd2-e15d93da693c
# ╟─64128ca4-77d1-11ec-0d3c-bb131c0d8efe
# ╟─64128cca-77d1-11ec-2db5-bb1dcf0de79b
# ╠═64129224-77d1-11ec-0dec-d7b0bd877698
# ╟─6412929c-77d1-11ec-3bc4-3bb5c191c8f2
# ╟─641292c4-77d1-11ec-23f9-a56ae157e647
# ╠═6412970e-77d1-11ec-30ab-cf56a0de3245
# ╟─6412976a-77d1-11ec-3736-97d257e3c0d7
# ╟─64129788-77d1-11ec-282f-513bc8cb5b61
# ╠═64129b8e-77d1-11ec-28c0-bd1233149d4b
# ╟─64129bde-77d1-11ec-2778-bfbdaccd82ab
# ╟─64129bfc-77d1-11ec-0b71-61b1e145a5ae
# ╟─64129c24-77d1-11ec-17e8-534e4c77776a
# ╟─64145334-77d1-11ec-2b30-0bfa77f9576b
# ╠═64147620-77d1-11ec-13e4-6128d4394a68
# ╟─641476ac-77d1-11ec-23fb-8fee943c31d3
# ╟─641476e8-77d1-11ec-36db-a31398b2d88d
# ╠═64147f6c-77d1-11ec-1dd2-9190cc6d77be
# ╟─64147fc6-77d1-11ec-2e8c-0d6d8aaae7d1
# ╟─64147fee-77d1-11ec-30cf-959076c91df4
# ╟─6414812e-77d1-11ec-15bf-437f22c5e7f8
# ╟─641494c0-77d1-11ec-3ba2-052786ed9985
# ╠═641498f8-77d1-11ec-0613-93fc08d69c04
# ╠═6414c756-77d1-11ec-1399-fd14a918ab48
# ╟─6414c7ec-77d1-11ec-1e2a-17ae01466e9f
# ╠═6414d05c-77d1-11ec-1a72-0d8518898928
# ╟─6414d0e8-77d1-11ec-39b9-eb49b95f3689
# ╟─6414d110-77d1-11ec-1517-4dbbb3610196
# ╟─6414d142-77d1-11ec-0af1-81db4d0a9815
# ╟─6414d160-77d1-11ec-0e8e-83cc88aaeb44
# ╟─6414d1ba-77d1-11ec-2d52-4f8e374e94f1
# ╟─6414d1ec-77d1-11ec-11b6-49a4cb515047
# ╟─6414d214-77d1-11ec-0433-234db8578e53
# ╟─6414d250-77d1-11ec-1d80-edda477a2735
# ╟─6414d282-77d1-11ec-0fb9-3f8ab6872830
# ╟─6414d2aa-77d1-11ec-2cf6-ad2cdc18ff72
# ╟─6414d2e6-77d1-11ec-3d5f-89afad58e452
# ╠═6414d8d6-77d1-11ec-37af-cde3e75e257f
# ╟─64210a8e-77d1-11ec-0456-0d32e230efff
# ╠═64210f5c-77d1-11ec-04ec-295b6e0ee1f1
# ╟─64210fac-77d1-11ec-2e50-e1baee26b74c
# ╠═64211c22-77d1-11ec-226c-59b06fd56356
# ╟─64211c90-77d1-11ec-2e9d-a1b4d7101e85
# ╠═642121a4-77d1-11ec-17b7-2bfed3963a38
# ╟─64212212-77d1-11ec-18ba-9f2f71ea982f
# ╟─64212250-77d1-11ec-004d-8da4a11e35f0
# ╠═64212744-77d1-11ec-1334-578e4d73ff96
# ╟─642452d4-77d1-11ec-0056-154b201bbff5
# ╟─64245374-77d1-11ec-1a8e-1302cda7dcb5
# ╠═64245a68-77d1-11ec-1361-05139bf659f2
# ╟─64245b24-77d1-11ec-2a68-09077ba1b03f
# ╟─64245b56-77d1-11ec-2634-57fa5fccebc5
# ╟─64245b9e-77d1-11ec-249f-adae664399fe
# ╟─64245bb2-77d1-11ec-192d-e136035c2d6f
# ╟─64245bbc-77d1-11ec-12b2-b33c01c11c64
# ╟─64245c34-77d1-11ec-3193-197139aa2a23
# ╟─64245cac-77d1-11ec-36aa-a5831c18baca
# ╟─64245cd4-77d1-11ec-2a19-bf55529e74be
# ╟─64245d1a-77d1-11ec-15e7-658c8a1296e0
# ╠═6424630a-77d1-11ec-175e-7b0931d926ef
# ╟─6424635a-77d1-11ec-1846-35020e2a0562
# ╠═642484a2-77d1-11ec-2d1e-ef1484501b36
# ╟─642484e8-77d1-11ec-35d4-0568c0df21c8
# ╟─64248510-77d1-11ec-2091-3d2bfd90d93f
# ╟─64248542-77d1-11ec-323c-e9a9c9525931
# ╠═64248aec-77d1-11ec-01be-011c59dd26de
# ╟─64248b28-77d1-11ec-28e1-ebdc8eceb298
# ╠═6424905a-77d1-11ec-189f-03dda8808596
# ╟─6424908c-77d1-11ec-3895-691ab115b4cd
# ╠═64249492-77d1-11ec-1e0c-47bba4ecd803
# ╟─642494d6-77d1-11ec-3f35-e94169396885
# ╟─64249500-77d1-11ec-218d-3b1d297c159d
# ╟─64249528-77d1-11ec-2b57-434a9a80a931
# ╟─6424965e-77d1-11ec-2622-c3d4c23a96e8
# ╟─64249690-77d1-11ec-295d-0fa79fa1f0dc
# ╟─642496a4-77d1-11ec-1c2e-bdeb6c055e03
# ╟─642496d6-77d1-11ec-34d1-bdff2b557e72
# ╟─6424971c-77d1-11ec-3dfa-fbcaef51f957
# ╟─6424973a-77d1-11ec-37a5-ebaa3d925352
# ╟─6424974e-77d1-11ec-0d3d-5d568e367711
# ╟─64249780-77d1-11ec-10d3-cd0956129c1b
# ╟─642497b2-77d1-11ec-1d4a-53e7300695bf
# ╟─642497bc-77d1-11ec-30e6-53b76a76bd1b
# ╟─64249834-77d1-11ec-113b-8781d7f5e666
# ╟─642498a2-77d1-11ec-229b-5b68533f4f63
# ╟─642498d4-77d1-11ec-12e4-2db42c94d741
# ╟─642498f2-77d1-11ec-2f0a-b3d95308ba88
# ╟─6424991a-77d1-11ec-12a4-1912bfcb4ae9
# ╟─6424b03a-77d1-11ec-2d98-33f32266aab9
# ╟─6424b0bc-77d1-11ec-0656-2f7f851ac252
# ╟─6424b0f8-77d1-11ec-11af-b5a470a02ee3
# ╟─6424b148-77d1-11ec-1b19-254306629c4d
# ╟─6424b17a-77d1-11ec-1e74-c9d0a5ec40b7
# ╟─6424b1c0-77d1-11ec-39dd-196c4a5dcc33
# ╟─6424b224-77d1-11ec-095f-bf6895dbf2cc
# ╟─6424b23a-77d1-11ec-0cec-6599c024b865
# ╟─6424b3be-77d1-11ec-1a97-6353887be442
# ╟─6424b40e-77d1-11ec-3e6b-d363954ad765
# ╟─6424b44a-77d1-11ec-1702-e3d36d8b9c34
# ╟─6424b4d8-77d1-11ec-3005-7f53a3cf5ef7
# ╟─6424b4fe-77d1-11ec-0d21-7171947fd8c2
# ╟─6424b530-77d1-11ec-190a-258bb9376776
# ╠═6424c0f2-77d1-11ec-381a-274208806ce3
# ╟─6424c124-77d1-11ec-0a4e-7faad9a50394
# ╟─6424c16a-77d1-11ec-2046-71835743a40a
# ╠═6424c618-77d1-11ec-3e04-6783d33de647
# ╟─6424c66a-77d1-11ec-288b-9371b25e886f
# ╠═6424ce12-77d1-11ec-1552-e51bf19c3dd9
# ╟─6424ce3a-77d1-11ec-23e0-01443d1e5d65
# ╠═6424d948-77d1-11ec-1a76-9540f05b5fad
# ╟─6424d9b6-77d1-11ec-078a-eb36e0693285
# ╠═6424ddc6-77d1-11ec-1371-19109970aa38
# ╟─6424de20-77d1-11ec-3e0d-73834e7b191b
# ╠═6424e0e6-77d1-11ec-0675-35b5369f4e13
# ╟─6424e12c-77d1-11ec-207d-4d720d084c0b
# ╠═6424e37c-77d1-11ec-07d9-a1115ca35e7f
# ╟─6424e40e-77d1-11ec-2612-afaf43637dbf
# ╠═6424e6f4-77d1-11ec-32d8-cfed16ba8504
# ╟─6424e780-77d1-11ec-1e3f-775afb3b1d33
# ╠═642506c0-77d1-11ec-316d-f330d763ea5a
# ╟─642506f2-77d1-11ec-24d4-41b878b11ba3
# ╠═64250968-77d1-11ec-22c8-ef62bc773718
# ╟─642509a4-77d1-11ec-3737-d79666b6ad66
# ╠═64251796-77d1-11ec-2f8f-e906dd2cf072
# ╟─642517e6-77d1-11ec-0d55-37dc9df5456c
# ╠═642519c6-77d1-11ec-34e4-692db112042d
# ╟─64251a02-77d1-11ec-1415-ab9301108ce2
# ╠═642523a8-77d1-11ec-1490-dfd507b7d1bd
# ╟─642523e4-77d1-11ec-3daa-0b97a7d836d0
# ╠═64252646-77d1-11ec-17d5-d1ef7184f169
# ╟─6425266e-77d1-11ec-2a44-539092cea164
# ╟─642526c8-77d1-11ec-2e0c-dfce6941f130
# ╠═64252894-77d1-11ec-0caa-0dc68db1671b
# ╟─642528bc-77d1-11ec-0395-d103dc4ca7d0
# ╟─642528e4-77d1-11ec-22d2-198ba906adbf
# ╠═64252a60-77d1-11ec-2f04-f5ce48268138
# ╟─64252ae2-77d1-11ec-0bde-95cf8d2b9904
# ╠═64252bfa-77d1-11ec-183c-6392ff282599
# ╟─64252c2c-77d1-11ec-2609-816dd6324744
# ╟─64252c68-77d1-11ec-0645-2f3a8db17848
# ╠═64254696-77d1-11ec-2b1e-497180545085
# ╟─642546f6-77d1-11ec-1b90-fb1f4530a025
# ╠═64254a2c-77d1-11ec-0dff-f9ea0a597061
# ╟─64256c98-77d1-11ec-121d-35725689dd3b
# ╟─64256cdc-77d1-11ec-24f8-5d2a15a0cb0f
# ╟─64256d5c-77d1-11ec-22cf-233ed675d61d
# ╠═6425742a-77d1-11ec-08a9-69aba82c22b5
# ╟─642574c0-77d1-11ec-1294-9376de1e6a9e
# ╠═64257b50-77d1-11ec-192f-c118e4058bce
# ╟─64257b78-77d1-11ec-0006-fb54a8cc27de
# ╟─64257ba0-77d1-11ec-2ca3-d515f22745bf
# ╟─64257bf0-77d1-11ec-159a-03492ed1851e
# ╟─64257c18-77d1-11ec-08e2-75b37761c740
# ╟─64257c54-77d1-11ec-0457-852419f90d83
# ╟─64257cc2-77d1-11ec-1202-59a3ce9dd85b
# ╟─64257ce0-77d1-11ec-1e63-ed52132f5fab
# ╟─64258a1c-77d1-11ec-1eb2-d9c3c05db61d
# ╟─6426e738-77d1-11ec-032d-c14da5bfaf10
# ╟─6426e7b0-77d1-11ec-28fb-fd3adbe9de1b
# ╟─6426e7c4-77d1-11ec-012c-d9b040627933
# ╟─6426e864-77d1-11ec-0f16-15d3a03af35e
# ╟─6426e90e-77d1-11ec-24eb-11039526beac
# ╟─6426e97c-77d1-11ec-12be-b5719a492a8c
# ╟─6426e9b8-77d1-11ec-06e2-652cefbe76ae
# ╟─6426e9f6-77d1-11ec-29b7-ef6f68dd59c5
# ╠═6426f188-77d1-11ec-3273-3f570bd592b2
# ╟─6426f234-77d1-11ec-29da-7bac14fce82f
# ╠═6426f48a-77d1-11ec-3257-b5010d4f610c
# ╟─6426f4b2-77d1-11ec-3894-295b326fb32e
# ╠═6426f5f2-77d1-11ec-1a4a-b9a03e2c9df0
# ╟─6426f642-77d1-11ec-0409-2f6e9736dc76
# ╠═6426f9f8-77d1-11ec-1da5-6f969ad2fdc7
# ╟─6426fa3e-77d1-11ec-3980-495da5bd604d
# ╟─6426fa66-77d1-11ec-13d5-07fa26eb2a75
# ╠═6427010a-77d1-11ec-034a-3b175be4de39
# ╟─64270128-77d1-11ec-2dfe-61ffa8ffbb46
# ╠═642706aa-77d1-11ec-21dd-dfe9d6682552
# ╟─642706dc-77d1-11ec-0e0f-03bf6262cf0c
# ╟─64270768-77d1-11ec-3d21-7d2a153d58ac
# ╠═64270d30-77d1-11ec-1ee0-bb4c8639ed03
# ╟─64270dbe-77d1-11ec-3c08-7f49d703e3c7
# ╟─64270e34-77d1-11ec-31c5-9b0cb21b95fa
# ╠═642711ea-77d1-11ec-1026-b16aa5806bd6
# ╟─64271262-77d1-11ec-084d-1fcfdf42af95
# ╟─64271280-77d1-11ec-2937-b504e40e33ad
# ╟─642712ba-77d1-11ec-2c69-1f8582a80594
# ╠═642717bc-77d1-11ec-23a2-17fe2591d8f3
# ╟─642717da-77d1-11ec-1bfe-9d42d5395dce
# ╟─64271802-77d1-11ec-3a70-dd746645a8fb
# ╠═642720e0-77d1-11ec-3903-59262cb991fe
# ╟─64272130-77d1-11ec-0cc2-e13ee47485cd
# ╟─64272162-77d1-11ec-020d-6fc43d8eb775
# ╟─642721ce-77d1-11ec-2610-33f8221e7e9b
# ╟─64273468-77d1-11ec-3086-31552d8b98d0
# ╟─64273512-77d1-11ec-3842-6757c76e93cc
# ╟─64273544-77d1-11ec-1dda-29232d9069ec
# ╟─6428fc42-77d1-11ec-0ad9-936d6f4baf47
# ╟─6428fc9e-77d1-11ec-392b-8b081ef50bf1
# ╟─6428fcbc-77d1-11ec-2afc-bd4b6433daaf
# ╟─6428fd5c-77d1-11ec-1b4a-bd4086a7a4a4
# ╠═642925ea-77d1-11ec-1294-8d6450f341f9
# ╟─64292642-77d1-11ec-2cb4-8196f22ce78f
# ╠═64292c8c-77d1-11ec-3ad8-9d58a5d37f4a
# ╟─64292cc0-77d1-11ec-1a3d-ed1123f75025
# ╠═642935b0-77d1-11ec-3778-6f292c7b4d2c
# ╟─6429360a-77d1-11ec-3418-8fcdcf115109
# ╟─64293632-77d1-11ec-34d0-170821bebfba
# ╠═64293970-77d1-11ec-0da5-e5891f59e063
# ╟─642939e8-77d1-11ec-2420-5d04f596476f
# ╠═64293efc-77d1-11ec-388b-21df51db973c
# ╟─64293fc4-77d1-11ec-0bff-95cd7691d215
# ╠═6429473a-77d1-11ec-28c4-b7f2ae863445
# ╟─64294794-77d1-11ec-17de-877bdc0fef30
# ╟─64294802-77d1-11ec-3bde-45da736306cd
# ╟─649a28f6-77d1-11ec-1b16-795f9190636c
# ╟─649a2982-77d1-11ec-1f3f-39414fb3b730
# ╟─649a29fa-77d1-11ec-0369-4d79a30df985
# ╠═649a330a-77d1-11ec-10fa-473441da2ab2
# ╟─649a3350-77d1-11ec-1a4d-55adb342b2f3
# ╟─649a3382-77d1-11ec-3ea3-85257e82a845
# ╟─649a33aa-77d1-11ec-01e6-1346b7ef9778
# ╠═649a3ae4-77d1-11ec-1432-a14d1f77b430
# ╟─649a3af6-77d1-11ec-0ecf-dfeb7e9a0fa1
# ╟─649dab48-77d1-11ec-3a20-4de7d644f7a7
# ╟─649dabd4-77d1-11ec-1fe3-57c730f18a44
# ╟─649dac2e-77d1-11ec-2412-73d1fe6a6a67
# ╠═649db41c-77d1-11ec-3ae6-1d9208c361f2
# ╟─649db46c-77d1-11ec-2ba9-93af0f3b441b
# ╟─649db496-77d1-11ec-0a5e-e9d71e1f6e61
# ╟─649db4c8-77d1-11ec-12bf-d3473adb8e9c
# ╟─649db4e4-77d1-11ec-1f05-db723a3bff63
# ╟─649db674-77d1-11ec-32f1-dfb303fb5c71
# ╟─649db6a6-77d1-11ec-3e76-3be7790f5be6
# ╟─649db6ce-77d1-11ec-2b34-4ba7c1c313b3
# ╟─649db6ec-77d1-11ec-0818-299b38d360ef
# ╟─649db700-77d1-11ec-33c7-df9f74cc762e
# ╠═649dbfac-77d1-11ec-10d6-d1eea2925905
# ╟─649dbfde-77d1-11ec-036d-e3cb54d4571f
# ╟─649dd8ac-77d1-11ec-001f-b54c77cde2fa
# ╟─649dd91a-77d1-11ec-340d-15bd75a69b8c
# ╟─649dd956-77d1-11ec-1fed-1912919f3191
# ╟─649de32e-77d1-11ec-3d51-9f109dd86063
# ╟─649de360-77d1-11ec-2fe2-03a0b8da70e3
# ╟─649deb94-77d1-11ec-2dfb-97e2790233f9
# ╟─649debd0-77d1-11ec-069a-6b4f6c2da63d
# ╟─649df3f0-77d1-11ec-12e5-037f6932a004
# ╟─649df42c-77d1-11ec-0d99-8f74f54acb9b
# ╟─649dfb8e-77d1-11ec-1e5d-0938094d1ae8
# ╟─649dfbb6-77d1-11ec-25a2-e3b6060f4dbc
# ╟─649e1a6a-77d1-11ec-26bf-89a49500a08d
# ╟─649e1aba-77d1-11ec-2b08-07b5ebf43409
# ╟─649e53ce-77d1-11ec-3e68-ed7c8eb0317f
# ╟─649e5426-77d1-11ec-0cab-41cfa8bd56d2
# ╟─649e5460-77d1-11ec-1bf3-d9a3ce823212
# ╟─649e54b2-77d1-11ec-0c16-cf5aaa3f8a9d
# ╟─649e54d0-77d1-11ec-2643-bf7bb5a49180
# ╟─649e56fe-77d1-11ec-0b06-7f789787afff
# ╟─649e5730-77d1-11ec-20e5-254c849c0ac9
# ╟─649e607e-77d1-11ec-19c5-b12292b06379
# ╟─649e60ba-77d1-11ec-26f0-93f099cd4d10
# ╟─649e6998-77d1-11ec-0da8-15dca8d607c7
# ╟─649e69ac-77d1-11ec-161e-b92f8a38ffba
# ╟─649e6a06-77d1-11ec-0880-d170a3b72a82
# ╟─649e6a92-77d1-11ec-0723-2164c0edda67
# ╟─649e72c6-77d1-11ec-118a-8bb9c962c161
# ╟─649e730c-77d1-11ec-0327-d917639245b9
# ╟─649e733e-77d1-11ec-001c-5f5dfc0c4632
# ╟─649e79c4-77d1-11ec-140e-a54df5e44b36
# ╟─649e79f6-77d1-11ec-393a-59d99cda3460
# ╟─649e7a46-77d1-11ec-0b39-916232385766
# ╟─649e81e4-77d1-11ec-1b21-b31eebc31dee
# ╟─649e8220-77d1-11ec-0eb7-255ff0b42afd
# ╟─649e8284-77d1-11ec-223e-d355038ac981
# ╟─649e93b2-77d1-11ec-12a8-07bd98d9274b
# ╟─649e93d2-77d1-11ec-0623-5dd019928d08
# ╟─649e93e6-77d1-11ec-2842-ed2be8b1f656
# ╟─649eb4e8-77d1-11ec-1858-8b3307572e3e
# ╟─649eb542-77d1-11ec-015e-a1581e6b322a
# ╟─649ebf38-77d1-11ec-17fb-cb2e2f914f98
# ╟─649ebf54-77d1-11ec-10a1-d77a1f362f7b
# ╟─649ebf92-77d1-11ec-3eab-efc952749cae
# ╟─649ecb38-77d1-11ec-2dde-212ec8c24396
# ╟─649ecb54-77d1-11ec-3dd2-49f0596b774d
# ╟─649ed64e-77d1-11ec-0e1f-69c3b4b57cbb
# ╟─649ed680-77d1-11ec-062b-3b3f12a88b5f
# ╟─649ed69e-77d1-11ec-1662-79e87e7ef1bb
# ╟─649ed6bc-77d1-11ec-28a6-8d6bcd97062b
# ╟─649ee102-77d1-11ec-0157-b74aff8f0fe8
# ╟─649ee12a-77d1-11ec-27cd-5f44376fc302
# ╟─649ee13e-77d1-11ec-0a38-4b3243464964
# ╟─649ee170-77d1-11ec-1c15-9ddf9806bded
# ╟─649eed82-77d1-11ec-2f9d-57ee32a97f65
# ╟─649eeda0-77d1-11ec-0901-f751391c59ae
# ╟─649eedc6-77d1-11ec-0597-796fe171ef05
# ╟─649ef250-77d1-11ec-2d97-594b80359794
# ╟─649ef282-77d1-11ec-3b24-fb4e11fc6d52
# ╟─649efc28-77d1-11ec-0a9e-3d4786876da0
# ╟─649efc50-77d1-11ec-3fec-d713767e2c0f
# ╟─649efc82-77d1-11ec-2856-1d2593f39a95
# ╟─649efca0-77d1-11ec-090e-11b135cda063
# ╟─649efcfa-77d1-11ec-2c9c-43e907825987
# ╟─649f0498-77d1-11ec-3af9-01f9d3865782
# ╟─649f04c0-77d1-11ec-044b-2dabd316cc4b
# ╟─649f04ca-77d1-11ec-3fa4-8d8d3ef51e6c
# ╟─649f04ca-77d1-11ec-3b47-81cc60eeb7ed
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
