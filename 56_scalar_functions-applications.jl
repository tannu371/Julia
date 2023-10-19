### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ ccabc37c-7b01-11ec-09ef-41e0c5d822af
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
	import Contour: contours, levels, level, lines, coordinates
end

# ╔═╡ ccabc8b8-7b01-11ec-20aa-0756142a12e6
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ cce04b54-7b01-11ec-3cb2-0be2e9201680
using PlutoUI

# ╔═╡ cce04b38-7b01-11ec-3c7d-91dea3ee299c
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ cc9284ac-7b01-11ec-0e30-4bf2b8b8af81
md"""# Applications with scalar functions
"""

# ╔═╡ cc94acdc-7b01-11ec-1eb1-13a377c3c361
md"""This section uses these add-on packages:
"""

# ╔═╡ ccabc9ba-7b01-11ec-3c4c-6f8877edd3ad
md"""This section presents different applications of scalar functions.
"""

# ╔═╡ ccae74c8-7b01-11ec-2cd2-f7926da95d9e
md"""## Tangent planes, linearization
"""

# ╔═╡ ccb14e9e-7b01-11ec-0e81-21f9498d4707
md"""Consider the case $f:R^2 \rightarrow R$. We visualize $z=f(x,y)$ through a surface. At a point $(a, b)$, this surface, if $f$ is sufficiently smooth, can be approximated by a flat area, or a plane. For example, the Northern hemisphere of the earth, might be modeled simplistically by $z = \sqrt{R^2 - (x^2 + y^2)}$ for some $R$ and with the origin at the earth's core. The ancient view of a "flat earth," can be more generously seen as identifying this tangent plane with the sphere. More apt for current times, is the use of GPS coordinates to describe location. The difference between any two coordinates is technically a distance on a curved, nearly spherical, surface. But if the two points are reasonably closes (miles, not tens of miles) and accuracy isn't of utmost importance (i.e., not used for self-driving cars), then the distance can be found from the Euclidean distance formula, $\sqrt{(\Delta\text{latitude})^2 + \Delta\text{longitude})^2}$. That is, as if the points were on a plane, not a curved surface.
"""

# ╔═╡ ccb14efa-7b01-11ec-2255-7be93b1544a7
md"""For the univariate case, the tangent line has many different uses. Here we see the tangent plane also does.
"""

# ╔═╡ ccb40a08-7b01-11ec-0be0-fd5ac64f5345
md"""### Equation of the tangent plane
"""

# ╔═╡ ccb40a82-7b01-11ec-21fb-8b7bbff2f641
md"""The partial derivatives have the geometric view of being the derivative of the univariate functions $f(\vec\gamma_x(t))$ and $f(\vec\gamma_y(t))$, where $\vec\gamma_x$ moves just parallel to the $x$ axis (e.g. $\langle t + a, b\rangle$). and $\vec\gamma_y$ moves just parallel to the $y$ axis. The partial derivatives then are slopes of tangent lines to each curve. The tangent plane, should it exist, should match both slopes at a given point. With this observation, we can identify it.
"""

# ╔═╡ ccb40ab4-7b01-11ec-24b4-351a640d9b35
md"""Consider $f(\vec\gamma_x)$ at a point $(a,b)$. The path has a tangent vector, which has "slope" $\frac{\partial f}{\partial x}$. and in the direction of the $x$ axis, but not the $y$ axis, as does this vector:  $\langle 1, 0, \frac{\partial f}{\partial x} \rangle$. Similarly, this vector $\langle 0, 1, \frac{\partial f}{\partial y} \rangle$ describes the tangent line to $f(\vec\gamma_y)$ a the point.
"""

# ╔═╡ ccb40abe-7b01-11ec-14c2-9dbb8b58257f
md"""These two vectors will lie in the plane. The normal vector is found by their cross product:
"""

# ╔═╡ ccb41158-7b01-11ec-1bd8-dd7cfff68dcd
begin
	@syms f_x f_y
	n = [1, 0, f_x] × [0, 1, f_y]
end

# ╔═╡ ccb41194-7b01-11ec-2138-c5e1ddc0aa95
md"""Let $\vec{x} = \langle a, b, f(a,b)$. The tangent plane at $\vec{x}$ then is described by all vectors $\vec{v}$ with $\vec{n}\cdot(\vec{v} - \vec{x})  = 0$. Using $\vec{v} = \langle x,y,z\rangle$, we have:
"""

# ╔═╡ ccb60510-7b01-11ec-23ab-bf562de702e2
md"""```math
[-\frac{\partial f}{\partial x}, -\frac{\partial f}{\partial y}, 1] \cdot [x-a, y-b, z - f(a,b)] = 0,
```
"""

# ╔═╡ ccb6056c-7b01-11ec-3930-e920cd4bc82b
md"""or,
"""

# ╔═╡ ccb6058a-7b01-11ec-0d1c-0fdb207ca438
md"""```math
z = f(a,b) + \frac{\partial f}{\partial x} (x-a) + \frac{\partial f}{\partial y} (y-b),
```
"""

# ╔═╡ ccb60594-7b01-11ec-2de2-2fc7fb5ac7a8
md"""which is more compactly expressed as
"""

# ╔═╡ ccb605a8-7b01-11ec-1dad-4b410d3e7021
md"""```math
z = f(a,b) + \nabla(f) \cdot \langle x-a, y-b \rangle.
```
"""

# ╔═╡ ccb605d0-7b01-11ec-2d89-31e25dc75a53
md"""This form would then generalize to scalar functions from $R^n \rightarrow R$. This is consistent with the definition of $f$ being differentiable, where $\nabla{f}$ plays the role of the slope in the formulas.
"""

# ╔═╡ ccb605e6-7b01-11ec-2d5d-4b0e389ccaed
md"""The following figure illustrates the above for the function $f(x,y) = 6 - x^2 - y^2$:
"""

# ╔═╡ ccb8c540-7b01-11ec-1753-07de40b56863
md"""#### Alternate forms
"""

# ╔═╡ ccb8c5c2-7b01-11ec-2854-a11da76f3b7e
md"""The equation for the tangent plane is often expressed in a more explicit form. For $n=2$, if we set $dx = x-a$ and $dy=y-a$, then the equation for the plane becomes:
"""

# ╔═╡ ccb8c5d6-7b01-11ec-1563-adc8a541c328
md"""```math
f(a,b) + \frac{\partial f}{\partial x} dx + \frac{\partial f}{\partial y} dy,
```
"""

# ╔═╡ ccc1c848-7b01-11ec-3e4f-312dea27e1ef
md"""which is a common form for the equation, though possibly confusing, as $\partial x$ and $dx$ need to be distinguished. For $n > 2$, additional terms follow this pattern. This explicit form is helpful when doing calculations by hand, but much less so when working on the computer, say with `Julia`, as the representations using vectors (or matrices) can be readily implemented and their representation much closer to the formulas. For example, consider these two possible functions to find the tangent plane (returned as a function) at a point in 2 dimensions
"""

# ╔═╡ ccc1d68a-7b01-11ec-17eb-9f88d7248e67
function tangent_plane_1st_crack(f, pt)
  fx, fy = ForwardDiff.gradient(f, pt)
  x -> f(x...) + fx * (x[1]-pt[1]) + fy * (x[2]-pt[2])
end

# ╔═╡ ccc1d6d0-7b01-11ec-0424-f9f70b9b49a9
md"""It isn't so bad, but as written, we specialized to the number of dimensions, used indexing,  and with additional dimensions, it clearly would get tedious to generalize. Using vectors, we might have:
"""

# ╔═╡ ccc1dd4c-7b01-11ec-0d7e-d38627b699a9
function tangent_plane(f, pt)
  ∇f = ForwardDiff.gradient(f, pt) # using a variable ∇f
  x -> f(pt) + ∇f ⋅ (x - pt)
end

# ╔═╡ ccc1dd6a-7b01-11ec-0191-2927d236349c
md"""This is much more like the compact formula and able to handle higher dimensions without rewriting.
"""

# ╔═╡ ccc1dd92-7b01-11ec-372c-dd4a9b0579fe
md"""### Tangent plane for level curves
"""

# ╔═╡ ccc3997a-7b01-11ec-06dc-65e81caa8ced
md"""Consider the surface described by $f(x,y,z) = c$, a constant. This is more general than surfaces described by $z = f(x,y)$. The concept of a tangent plane should still be applicable though. Suppose, $\vec{\gamma}(t)$ is a curve in the $x-y-z$ plane, then we have $(f\circ\vec\gamma)(t)$ is a curve on the surface and its derivative is given by the chain rule through: $\nabla{f}(\vec\gamma(t))\cdot \vec\gamma'(t)$. But this composition is constantly the same value, so the derivative is $0$. This says that $\nabla{f}(\vec\gamma(t))$ is *orthogonal* to $\vec\gamma'(t)$ for any curve. As these tangential vectors to $\vec\gamma$ lie in the tangent plane, the tangent plane can be characterized by having $\nabla{f}$ as the normal.
"""

# ╔═╡ ccc399ca-7b01-11ec-27b4-e357a9afa31b
md"""This computation was previously done in two dimensions, and showed the gradient is orthogonal to the contour lines (and points in the direction of greatest ascent). It can be generalized to higher dimensions.
"""

# ╔═╡ ccc399e8-7b01-11ec-3f48-859851232f5d
md"""The surface $F(x,y,z) = z - f(x,y) = 0$ has gradient given by $\langle -\partial{f}/\partial{x}, -\partial{f}/\partial{y}, 1\rangle$, and as seen above, this vector is normal to the tangent plane, so this generalization agrees on the easier case.
"""

# ╔═╡ ccc399f2-7b01-11ec-13d5-3d53be156788
md"""For clarity:
"""

# ╔═╡ ccccdb70-7b01-11ec-1717-d3117b42f2bb
md"""  * The scalar function $z = f(x,y)$ describes a surface, $(x,y,f(x,y)$; the gradient, $\nabla{f}$ is $2$ dimensional and points in the direction of greatest ascent for the surface.
  * The scalar function $f(x,y,z)$ *also* describes a surface, through level curves $f(x,y,z) = c$, for some *constant* $c$. The gradient $\nabla{f}$ is $3$ dimensional and *orthogonal* to the surface.
"""

# ╔═╡ cccf9be2-7b01-11ec-3bd3-2d2c76bab47c
md"""##### Example
"""

# ╔═╡ cccf9c5c-7b01-11ec-2b24-ef86fa02ee7f
md"""Let $z = f(x,y) = \sin(x)\cos(x-y)$. Find an equation for the tangent plane at $(\pi/4, \pi/3)$.
"""

# ╔═╡ cccf9c70-7b01-11ec-0d43-33e8290b99d7
md"""We have many possible forms to express this in, but we will use the functional description:
"""

# ╔═╡ cccfa04c-7b01-11ec-3118-e902a03763b2
@syms x, y

# ╔═╡ cccfa6d4-7b01-11ec-01ac-ddd0554aac1d
let
	f(x,y) = sin(x) * cos(x-y)
	f(x) = f(x...)
	vars = [x, y]
	
	gradf = diff.(f(x,y), vars)  # or use gradient(f, vars) or ∇((f,vars))
	
	pt = [PI/4, PI/3]
	gradfa = subs.(gradf, x.=>pt[1], y.=>pt[2])
	
	f(pt) + gradfa ⋅ (vars - pt)
end

# ╔═╡ cccfa6fc-7b01-11ec-27fe-33f0792ec44a
md"""##### Example
"""

# ╔═╡ cccfa72e-7b01-11ec-00a1-715a0f73e59c
md"""A cylinder $f(x,y,z) = (x-a)^2 + y^2 = (2a)^2$ is intersected with a sphere $g(x,y,z) = x^2 + y^2 + z^2 = a^2$. Let $V$ be the line of intersection. (Viviani's curve). Let $P$ be a point on the curve. Describe the tangent to the curve.
"""

# ╔═╡ cccfa742-7b01-11ec-12bb-3362971c9bf0
md"""We have the line of intersection will have tangent line  lying in the tangent plane to both surfaces. These two surfaces have normal vectors given by the gradient, or $\vec{n}_1 = \langle 2(x-a), 2y, 0 \rangle$ and $\vec{n}_2 = \langle 2x, 2y, 2z \rangle$. The cross product of these two vectors will lie in both tangent planes, so we have:
"""

# ╔═╡ cccfa760-7b01-11ec-2229-25db4b15d636
md"""```math
P + t (\vec{n}_1 \times \vec{n}_2),
```
"""

# ╔═╡ cccfa774-7b01-11ec-0225-55f4b2c5171f
md"""will describe the tangent.
"""

# ╔═╡ cccfa788-7b01-11ec-2e87-1b5470baf515
md"""The curve may be described parametrically by $\vec\gamma(t) = a \langle 1 + \cos(t), \sin(t), 2\sin(t/2) \rangle$. Let's see that the above is correct by verifying that the cross product of the tangent vector computed two ways is $0$:
"""

# ╔═╡ cccfab20-7b01-11ec-1e63-ff4e3cee815f
let
	a = 1
	gamma(t) = a * [1 + cos(t), sin(t), 2sin(t/2) ]
	P = gamma(1/2)
	n1(x,y,z)= [2*(x-a), 2y, 0]
	n2(x,y,z) = [2x,2y,2z]
	n1(x) = n1(x...)
	n2(x) = n2(x...)
	
	t = 1/2
	(n1(gamma(t)) × n2(gamma(t))) × gamma'(t)
end

# ╔═╡ cccfab5c-7b01-11ec-0916-b9d93e80b9f4
md"""#### Plotting level curves of $F(x,y,z) = c$
"""

# ╔═╡ ccd0d2ca-7b01-11ec-0007-678213f4bb8a
md"""The `wireframe` plot can be used to a surface of the type `z=f(x,y)`, as previously illustrated. However we have no way of plotting $3$-dimensional implicit surfaces (of the type $F(x,y,z)=c$) as we do for $2$-dimensional implicit surfaces with `Plots`. (The `MDBM` or  `IntervalConstraintProgramming` packages can be used along with `Makie` plotting package to produce one.)
"""

# ╔═╡ ccd0d338-7b01-11ec-322b-451897dc9689
md"""The `CalculusWithJulia` package provides a stop-gap function, `plot_implicit_surface` for this task. The basic idea is to slice an axis, by default the $z$ axis up and for each level plot the contours of $(x,y) \rightarrow f(x,y,z)-c$, which becomes a $2$-dimensional problem. The function allows any of 3 different axes to be chosen to slice over, the default being just the $z$ axis.
"""

# ╔═╡ ccd2825a-7b01-11ec-29b9-eb250c14a976
md"""We demonstrate with an example from a February 14, 2019 article in the [New York Times](https://www.nytimes.com/2019/02/14/science/math-algorithm-valentine.html). It shows an equation for a "heart," as the graphic will illustrate:
"""

# ╔═╡ ccd28996-7b01-11ec-1679-8f59f75c0ccc
md"""## Linearization
"""

# ╔═╡ ccd289a8-7b01-11ec-2bb0-cd896e7c4c2f
md"""The tangent plane is the best "linear approximation" to a function at a point. "Linear" refers to mathematical properties of the tangent plane, but at a practical level it means easy to compute, as it will involve only multiplication and addition. "Approximation" is useful in that if a bit of error is an acceptable tradeoff for computational ease, the tangent plane may be used in place of the function. In the univariate case, this is known as linearization, and the tradeoff is widely used in the derivation of theoretical relationships, as well as in practice to get reasonable numeric values.
"""

# ╔═╡ ccd289bc-7b01-11ec-3c6b-c19012475ea0
md"""Formally, this is saying:
"""

# ╔═╡ ccd289da-7b01-11ec-08eb-49494b2554f3
md"""```math
f(\vec{x}) \approx f(\vec{a}) + ∇f(\vec{a}) ⋅ (\vec{x} - \vec{a}).
```
"""

# ╔═╡ ccd28a16-7b01-11ec-37a0-7f6968f9928c
md"""The explicit meaning of $\approx$ will be made clear when the generalization of Taylor's theorem is to be stated.
"""

# ╔═╡ ccd28a48-7b01-11ec-22e4-4df2699461fc
md"""##### Example: Linear approximation
"""

# ╔═╡ ccd28a70-7b01-11ec-0620-2fd9bff344fd
md"""The volume of a cylinder is $V=\pi r^2 h$. It is thought a cylinder has $r=1$ and $h=2$. If instead, the amounts are $r=1.01, h=2.01$, what is the difference in volume?
"""

# ╔═╡ ccd28a84-7b01-11ec-11c7-0185efbd5128
md"""That is, if $V(r,h) = \pi r^2 h$, what is $V(1.01, 2.01) - V(1,2)$?
"""

# ╔═╡ ccd3a400-7b01-11ec-100d-7d5683d11e22
md"""We can use linear approximation to see that this difference is *approximately* $\nabla{V} \cdot \langle 0.01, 0.01 \rangle$. This is:
"""

# ╔═╡ ccd3ac2a-7b01-11ec-0e78-13a7e28e3ccf
md"""The exact difference can be computed:
"""

# ╔═╡ ccd3afb8-7b01-11ec-2945-d5aee2b921a6
md"""##### Example
"""

# ╔═╡ ccd3afde-7b01-11ec-1e5d-f58ec4a271cc
md"""Let $f(x,y) = \sin(\pi x y^2)$. Estimate $f(1.1, 0.9)$.
"""

# ╔═╡ ccd3aff4-7b01-11ec-1dd7-cf6444c34c69
md"""Using linear approximation with $dx=0.1$ and $dy=-0.1$, this is
"""

# ╔═╡ ccd3b012-7b01-11ec-1c98-eba31faf8fb8
md"""```math
f(1,1) + \nabla{f}(1,1) \cdot \langle 0.1, -0.1\rangle,
```
"""

# ╔═╡ ccd3b026-7b01-11ec-1abb-b99f30300330
md"""where $f(1,1) = sin(\pi) = 0$ and $\nabla{f} = \langle y^2\cos(\pi x y^2), \cos(\pi x y^2) 2y\rangle = \cos(\pi x y^2)\langle x,2y\rangle$. So, the answer is:
"""

# ╔═╡ ccd3b03a-7b01-11ec-10d1-490d1fdde802
md"""```math
0 + \cos(\pi) \langle 1,2\rangle\cdot \langle 0.1, -0.1 \rangle =
(-1)(0.1 - 2(0.1)) = 0.1.
```
"""

# ╔═╡ ccd3b044-7b01-11ec-360a-23fbaa9530bf
md"""##### Example
"""

# ╔═╡ ccd3b082-7b01-11ec-21c5-131832a71aca
md"""A [piriform](http://www.math.harvard.edu/~knill/teaching/summer2011/handouts/32-linearization.pdf) is described by the quartic surface $f(x,y,z) = x^4 -x^3 + y^2+z^2 = 0$. Find the tangent line at the point $\langle 2,2,2 \rangle$.
"""

# ╔═╡ ccd3b0b4-7b01-11ec-2907-ddd8fdd9f47e
md"""Here, $\nabla{f}$ describes a *normal* to the tangent plane. The description of a plane may be  described by $\hat{N}\cdot(\vec{x} - \vec{x}_0) = 0$, where $\vec{x}_0$ is identified with a point on the plane (the point $(2,2,2)$ here). With this, we have $\hat{N}\cdot\vec{x} = ax + by + cz = \hat{N}\cdot\langle 2,2,2\rangle = 2(a+b+c)$. For ths problem, $\nabla{f}(2,2,2) = \langle a, b, c\rangle$ is given by:
"""

# ╔═╡ ccd3b77e-7b01-11ec-3dde-2b33d0761bf7
md"""### Newton's method to solve $f(x,y) = 0$ and $g(x,y)=0$.
"""

# ╔═╡ ccd3b79c-7b01-11ec-35cc-cd516a2a6174
md"""The level curve $f(x,y)=0$ and the level curve $g(x,y)=0$ may intersect. Solving algebraically for the intersection may be difficult in most cases, though the linear case is not. (The linear case being the intersection of two lines).
"""

# ╔═╡ ccd3b7a6-7b01-11ec-245d-6383b6310dc3
md"""To elaborate, consider two linear equations written in a general form:
"""

# ╔═╡ ccd3b7b8-7b01-11ec-307d-3bc5d3ffaf91
md"""```math
\begin{align}
ax + by &= u\\
cx + dy &= v
\end{align}
```
"""

# ╔═╡ ccd3b7ea-7b01-11ec-3f5b-99f5ae71cda8
md"""A method to solve this by hand would be to solve for $y$ from one equation, replace this expression into the second equation and then solve for $x$. From there, $y$ can be found. A more advanced method expresses the problem in a matrix formulation of the form $Mx=b$ and solves that equation. This form of solving is implemented in `Julia`, through the "backslash" operator. Here is the general solution:
"""

# ╔═╡ ccd3bd46-7b01-11ec-0ef2-b5fb1d2e4c25
let
	@syms a b c d u v
	M = [a b; c d]
	B = [u, v]
	M \ B .|> simplify
end

# ╔═╡ ccd3bd64-7b01-11ec-0fe5-7362790c26c8
md"""The term $\det(M) = ad-bc$ term is important, as evidenced by its appearance in the denominator of each term. When this is zero there is not a unique solution, as in the typical case.
"""

# ╔═╡ ccd3bd8a-7b01-11ec-012d-89a9c96aa0fe
md"""Using Newton's method to solve for intersection points, uses linearization of the surfaces to replace the problem to the intersection of level curves for tangent planes. This is the linear case that can be readily solved. As with Newton's method for the univariate case, the new answer is generally a better *approximation* to the answer, and the process is iterated to get a *good enough* approximation, as defined through some tolerance.
"""

# ╔═╡ ccd3bdaa-7b01-11ec-021b-b324d691fc9d
md"""Consider the functions $f(x,y) =2 - x^2 - y^2$ and $g(x,y) = 3 - 2x^2 - (1/3)y^2$. These graphs show their surfaces with the level sets for $c=0$ drawn and just the levels sets, showing they intersect in 4 places.
"""

# ╔═╡ ccd3c32a-7b01-11ec-15bf-67126b03854e
md"""We look to find the intersection point near $(1,1)$ using Newton's method
"""

# ╔═╡ ccd3c336-7b01-11ec-3238-e1d3923a529d
md"""We have by linearization:
"""

# ╔═╡ ccd3c34a-7b01-11ec-2073-eb2a420640b7
md"""```math
\begin{align}
f(x,y) &\approx f(x_n, y_n)  + \frac{\partial f}{\partial x}\Delta x + \frac{\partial f}{\partial y}\Delta y \\
g(x,y) &\approx g(x_n, y_n)  + \frac{\partial g}{\partial x}\Delta x + \frac{\partial g}{\partial y}\Delta y,
\end{align}
```
"""

# ╔═╡ ccd3c368-7b01-11ec-08c1-95193c0c8901
md"""where $\Delta x = x- x_n$ and $\Delta y = y-y_n$. Setting $f(x,y)=0$ and $g(x,y)=0$, leaves these two linear equations in $\Delta x$ and $\Delta y$:
"""

# ╔═╡ ccd3c37c-7b01-11ec-0bb0-1545192088d4
md"""```math
\begin{align}
\frac{\partial f}{\partial x} \Delta x + \frac{\partial f}{\partial y} \Delta y &= -f(x_n, y_n)\\
\frac{\partial g}{\partial x} \Delta x + \frac{\partial g}{\partial y} \Delta y &= -g(x_n, y_n).
\end{align}
```
"""

# ╔═╡ ccd3c390-7b01-11ec-3811-632e053dd20b
md"""One step of Newton's method defines $(x_{n+1}, y_{n+1})$ to be the values $(x,y)$ that make the linearized functions about $(x_n, y_n)$ both equal to $\vec{0}$.
"""

# ╔═╡ ccd3c3ae-7b01-11ec-0130-97f757ec0660
md"""As just described, we can use `Julia`'s `\` operation to solve the above system of equations, if we express them in matrix form. With this, one step of Newton's method can be coded as follows:
"""

# ╔═╡ ccd3cdb8-7b01-11ec-11d6-159115283c10
function newton_step(f, g, xn)
    M = [ForwardDiff.gradient(f, xn)'; ForwardDiff.gradient(g, xn)']
    b = -[f(xn), g(xn)]
    Delta = M \ b
    xn + Delta
end

# ╔═╡ ccd3cdd4-7b01-11ec-0ce0-8378adf76581
md"""We investigate what happens starting at $(1,1)$ after one step:
"""

# ╔═╡ ccd3d33a-7b01-11ec-28b9-138d46c43c28
md"""The new function values are
"""

# ╔═╡ ccd3d56a-7b01-11ec-3440-63fd983d9895
md"""We can get better approximations by iterating. Here we hard code 4 more steps:
"""

# ╔═╡ ccd3d8ee-7b01-11ec-1afb-838c46c87a7f
md"""We see that at the new point, `x5`, both functions  are basically the same value, $0$, so we have approximated the intersection point.
"""

# ╔═╡ ccd3d902-7b01-11ec-3631-d9070f1388bc
md"""For nearby initial guesses and reasonable functions, Newton's method is *quadratic*, so should take few steps for convergence, as above.
"""

# ╔═╡ ccd3d914-7b01-11ec-150c-b34f9397c740
md"""Here is a simplistic method to iterate $n$ steps:
"""

# ╔═╡ ccd3df9c-7b01-11ec-2a80-75a83c1b8406
function nm(f, g, x, n=5)
    for i in 1:n
      x = newton_step(f, g, x)
    end
    x
end

# ╔═╡ ccd3dfc4-7b01-11ec-2f41-a72f8e72204e
md"""##### Example
"""

# ╔═╡ ccd3dff6-7b01-11ec-323e-4d6816a9bff8
md"""Consider the [bicylinder](https://blogs.scientificamerican.com/roots-of-unity/a-few-of-my-favorite-spaces-the-bicylinder/) the intersection of two perpendicular cylinders of the same radius. If the radius is $1$, we might express these by the functions:
"""

# ╔═╡ ccd3e00a-7b01-11ec-19a8-95e2542be89e
md"""```math
f(x,y) = \sqrt{1 - y^2}, \quad g(x,y) = \sqrt{1 - x^2}.
```
"""

# ╔═╡ ccd3e03c-7b01-11ec-073f-196e00371ebb
md"""We see that $(1,1)$, $(-1,1)$, $(1,-1)$ and $(-1,-1)$ are solutions to $f(x,y)=0$, $g(x,y)=0$ *and* $(0,0)$ is a solution to $f(x,y)=1$ and $g(x,y)=1$. What about a level like $1/2$, say?
"""

# ╔═╡ ccd3e050-7b01-11ec-1885-45573875ac30
md"""Rather than work with $f(x,y) = c$ we solve $f(x,y)^2 = c^2$, as that will be avoid issues with the square root not being defined. Here is one way to solve:
"""

# ╔═╡ ccd3e422-7b01-11ec-02e4-815485c42590
md"""That $x=y$ is not so surprising, and in fact, this problem can more easily be solved analytically through $x^2 = y^2 = 1 - c^2$.
"""

# ╔═╡ ccd3e442-7b01-11ec-1918-cf65a888c7c4
md"""## Implicit differentiation
"""

# ╔═╡ ccd3e474-7b01-11ec-109a-133688e0e397
md"""Implicit differentiation of an equation of two variables (say $x$ and $y$) is performed by *assuming* $y$ is a function of $x$ and when differentiating an expression with $y$, use the chain rule. For example, the slope of the tangent line, $dy/dx$, for the general ellipse $x^2/a + y^2/b = 1$ can be found through this calculation:
"""

# ╔═╡ ccd3e488-7b01-11ec-1c04-f19be535a931
md"""```math
\frac{d}{dx}(\frac{x^2}{a} + \frac{y^2}{b}) =
\frac{d}{dx}(1),
```
"""

# ╔═╡ ccd3e494-7b01-11ec-365b-098e142d8deb
md"""or, using $d/dx(y^2) = 2y dy/dx$:
"""

# ╔═╡ ccd3e49c-7b01-11ec-13c7-8fa9d31cb276
md"""```math
\frac{2x}{a} + \frac{2y \frac{dy}{dx}}{b} = 0.
```
"""

# ╔═╡ ccd3e4b0-7b01-11ec-1ac1-d9dbffff4001
md"""From this, solving for $dy/dx$ is routine,  as the equation is linear in that unknown: $dy/dx = -(b/a)(x/y)$
"""

# ╔═╡ ccd3e4ce-7b01-11ec-160d-8d3213b72fcc
md"""With more variables, the same technique may be used. Say we have variables $x$, $y$, and $z$ in a relation like $F(x,y,z) = 0$. If we assume $z=z(x,y)$ for some differentiable function (we mention later what conditions will ensure this assumption is valid for some open set), then we can proceed as before, using the chain rule as necessary.
"""

# ╔═╡ ccd3e4e2-7b01-11ec-1c80-abbd95d0022b
md"""For example, consider the ellipsoid: $x^2/a + y^2/b + z^2/c = 1$. What is $\partial z/\partial x$ and $\partial{z}/\partial{y}$, as needed to describe the tangent plane as above?
"""

# ╔═╡ ccd3e4f8-7b01-11ec-2616-9747c4194512
md"""To find $\partial/\partial{x}$ we have:
"""

# ╔═╡ ccd3e500-7b01-11ec-25d2-ff220da7de41
md"""```math
\frac{\partial}{\partial{x}}(x^2/a + y^2/b + z^2/c) =
\frac{\partial}{\partial{x}}1,
```
"""

# ╔═╡ ccd3e50a-7b01-11ec-0316-055223523043
md"""or
"""

# ╔═╡ ccd3e514-7b01-11ec-171b-c39700bbc097
md"""```math
\frac{2x}{a} + \frac{0}{b} + \frac{2z\frac{\partial{z}}{\partial{x}}}{c} = 0.
```
"""

# ╔═╡ ccd3e51e-7b01-11ec-3cf0-17826328f568
md"""Again the desired unknown is within a linear equation so can readily be solved:
"""

# ╔═╡ ccd3e526-7b01-11ec-2e18-7f18e122784f
md"""```math
\frac{\partial{z}}{\partial{x}} = -\frac{c}{a} \frac{x}{z}.
```
"""

# ╔═╡ ccd3e532-7b01-11ec-21ec-6de9c4299a56
md"""A similar approach can be used for $\partial{z}/\partial{y}$.
"""

# ╔═╡ ccd3e550-7b01-11ec-3adc-112dba3d4a57
md"""##### Example
"""

# ╔═╡ ccd3e56e-7b01-11ec-38e9-133e5f73f824
md"""Let $f(x,y,z) = x^4 -x^3 + y^2 + z^2 = 0$ be a surface with point $(2,2,2)$. Find $\partial{z}/\partial{x}$ and $\partial{z}/\partial{y}$.
"""

# ╔═╡ ccd3e578-7b01-11ec-1f80-1d91cbceec60
md"""To find $\partial{z}/\partial{x}$ and $\partial{z}/\partial{y}$ we have:
"""

# ╔═╡ ccd3e99c-7b01-11ec-0ead-af72acea2a3c
md"""## Optimization
"""

# ╔═╡ ccd3e9ba-7b01-11ec-2617-53afad6b8220
md"""For a continuous univariate  function $f:R \rightarrow R$ over an interval $I$ the question of finding a maximum or minimum value is aided by two theorems:
"""

# ╔═╡ ccd512ba-7b01-11ec-2e7a-4775c5aac7d1
md"""  * The Extreme Value Theorem, which states that if $I$ is closed (e.g, $I=[a,b]$) then $f$ has a maximum (minimum) value $M$ and there is at least one value  $c$ with $a \leq c \leq b$ with $M = f(x)$.
  * [Fermat](https://tinyurl.com/nfgz8fz)'s theorem on critical points, which states that if $f:(a,b) \rightarrow R$ and $x_0$ is such that $a < x_0 < b$ and $f(x_0)$ is a *local* extremum. If $f$ is differentiable at $x_0$, then $f'(x_0) = 0$. That is, local extrema of $f$ happen at points where the derivative does not exist or is $0$ (critical points).
"""

# ╔═╡ ccd512e8-7b01-11ec-26e4-0fe6fbba43ca
md"""These two theorems provide an algorithm to find the extreme values of a continuous function over a closed interval: find the critical points, check these and the end points for the maximum and minimum value.
"""

# ╔═╡ ccd512fe-7b01-11ec-1877-3db9527af507
md"""These checks can be reduced by two theorems that can classify critical points as local extrema, the first and second derivative tests.
"""

# ╔═╡ ccd51312-7b01-11ec-2bbd-f1a85d7a3e9a
md"""These theorems have generalizations to scalar functions, allowing a similar study of extrema.
"""

# ╔═╡ ccd5134e-7b01-11ec-03c5-c71ac7bd1935
md"""First, we define a *local* maximum for $f:R^n \rightarrow R$ over a region $U$: a point $\vec{a}$ in $U$ is a *local* maximum if $f(\vec{a}) \geq f(\vec{u})$ for all $u$ in some ball about $\vec{a}$. A *local* minimum would have $\leq$ instead.
"""

# ╔═╡ ccd51380-7b01-11ec-39b6-dbe4508afdde
md"""An *absolute* maximum over $U$, should it exist, would be $f(\vec{a})$ if there exists a value $\vec{a}$ in $U$ with the property $f(\vec{a}) \geq f(\vec{u})$ for all $\vec{u}$ in $U$.
"""

# ╔═╡ ccd51394-7b01-11ec-367c-e998baa1354c
md"""The difference is the same as the one-dimensional case: local is a statement about nearby points only, absolute a statement about all the points in the specified set.
"""

# ╔═╡ ccd8408c-7b01-11ec-30b7-aded27b7b294
md"""> The [Extreme Value Theorem](https://tinyurl.com/yyhgxu8y) Let $f:R^n \rightarrow R$ be continuous and defined on *closed* set $V$. Then $f$ has a minimum value $m$ and maximum value $M$ over $V$ and there exists at least two points $\vec{a}$ and $\vec{b}$ with $m = f(\vec{a})$ and $M = f(\vec{b})$.

"""

# ╔═╡ ccd8414a-7b01-11ec-357c-63400a46e6ea
md"""> [Fermat](https://tinyurl.com/nfgz8fz)'s theorem on critical points. Let $f:R^n \rightarrow R$ be a continuous function defined on an *open* set $U$. If $x \in U$ is a point where $f$ has a local extrema *and* $f$ is differentiable, then the gradient of $f$ at $x$ is $\vec{0}$.

"""

# ╔═╡ ccd84184-7b01-11ec-1540-c5f652ba44b8
md"""Call a point in the domain of $f$ where the function is differentiable and the  gradient is zero a *stationary point* and a point in the domain where the function is either not differentiable or is a stationary point a *critical point*. The local extrema can only happen at critical points by Fermat.
"""

# ╔═╡ ccd8419a-7b01-11ec-18ed-e7ece4c959ae
md"""Consider the function $f(x,y) = e^{-(x^2 + y^2)/5} \cos(x^2 + y^2)$.
"""

# ╔═╡ ccd84d70-7b01-11ec-22f9-a5c93eb6a651
md"""This function is differentiable and the gradient is given by:
"""

# ╔═╡ ccd84d8e-7b01-11ec-28de-cd3687d1762c
md"""```math
\nabla{f} = -2/5e^{-(x^2 + y^2)/5} (5\sin(x^2 + y^2) + \cos(x^2 + y^2)) \langle x, y \rangle.
```
"""

# ╔═╡ ccd84dc8-7b01-11ec-1fed-add50c80a93c
md"""This is zero at the origin, or when $ 5\sin(x^2 + y^2) = -\cos(x^2 + y^2)$. The latter is $0$ on circles of radius $r$ where $5\sin(r) = \cos(r)$ or $r = \tan^{-1}(-1/5) + k\pi$ for $k = 1, 2, \dots$. This matches the graph, where the extrema are on circles by symmetry. Imagine now, picking a value where the function takes a maximum and adding the tangent plane. As the gradient is $\vec{0}$, this will be flat. The point at the origin will have the surface fall off from the tangent plane in each direction, whereas the other points, will have a circle where the tangent plane rests on the surface, but otherwise will fall off from the tangent plane. Characterizing this "falling off" will help to identify local maxima that are distinct.
"""

# ╔═╡ ccda2ee4-7b01-11ec-115b-f5c3a0531f6d
md"""---
"""

# ╔═╡ ccda2f76-7b01-11ec-00d7-cd045d0f3c56
md"""Now consider the differentiable function $f(x,y) = xy$, graphed below with the projections of the $x$ and $y$ axes:
"""

# ╔═╡ ccda35c2-7b01-11ec-0070-c5842398efe9
let
	f(x,y) = x*y
	xs = ys = range(-3, 3, length=100)
	surface(xs, ys, f, legend=false)
	
	plot_parametric!(-4..4, t -> [t, 0, f(t, 0)], linewidth=5)
	plot_parametric!(-4..4, t -> [0, t, f(0, t)], linewidth=5)
end

# ╔═╡ ccda361a-7b01-11ec-0690-c9654a64b4a8
md"""The extrema happen at the edges of the region. The gradient is $\nabla{f} = \langle y, x \rangle$. This is $\vec{0}$ only at the origin. At the origin, were we to imagine a tangent plane, the surface falls off in one direction but falls *above* in the other direction. Such a point is referred to as a *saddle point*. A saddle point for a continuous $f:R^n \rightarrow R$ would be a critical point, $\vec{a}$ where for any ball with non-zero radius about $\vec{a}$, there are values where the function is greater than $f(\vec{a})$ and values where the function is less.
"""

# ╔═╡ ccda3630-7b01-11ec-36e3-f74593da668c
md"""To identify these through formulas, and not graphically, we could try and use the first derivative test along all paths through $\vec{a}$, but this approach is better at showing something isn't the case, like two paths to show non-continuity.
"""

# ╔═╡ ccda364c-7b01-11ec-1601-95ff7720dfcf
md"""The generalization of the *second* derivative test is more concrete though. Recall, the second derivative test is about the concavity of the function at the critical point. When the concavity can be determined as non-zero, the test is conclusive; when the concavity is zero, the test is not conclusive. Similarly here:
"""

# ╔═╡ ccda384c-7b01-11ec-2f3b-ffe80cdb8849
md"""> The [second](https://en.wikipedia.org/wiki/Second_partial_derivative_test) Partial Derivative Test for $f:R^2 \rightarrow R$.
>
> Assume the first and second partial derivatives of $f$ are defined and continuous; $\vec{a}$ be a critical point of $f$; $H$ is the hessian matrix, $[f_{xx}\quad f_{xy};f_{xy}\quad f_{yy}]$, and $d = \det(H) = f_{xx} f_{yy} - f_{xy}^2$ is the determinant of the Hessian matrix. Then:
>
>   * The function $f$ has a local minimum at $\vec{a}$ if $f_{xx} > 0$ *and* $d>0$,
>   * The function $f$ has a local maximum at $\vec{a}$ if $f_{xx} < 0$ *and* $d>0$,
>   * The function $f$ has a saddle point at $\vec{a}$ if $d < 0$,
>   * Nothing can be said if $d=0$.

"""

# ╔═╡ ccda386a-7b01-11ec-3862-b1002df70e20
md"""---
"""

# ╔═╡ ccda38b0-7b01-11ec-2f86-6f371ae05b76
md"""The intuition behind a  proof follows. The case when $f_{xx} > 0$ and $d > 0$ uses a consequence of these assumptions that for any non-zero vector $\vec{x}$ it *must* be that $x\cdot(Hx) > 0$ ([positive definite](https://en.wikipedia.org/wiki/Definiteness_of_a_matrix)) *and* the quadratic approximation $f(\vec{a}+d\vec{x}) \approx f(\vec{a}) + \nabla{f}(\vec{a}) \cdot d\vec{x} + d\vec{x} \cdot (Hd\vec{x}) = f(\vec{a}) + d\vec{x} \cdot (Hd\vec{x})$, so for any $d\vec{x}$ small enough, $f(\vec{a}+d\vec{x}) \geq f(\vec{a})$. That is $f(\vec{a})$ is a local minimum. Similarly, a proof for the local maximum follows by considering $-f$. Finally, if $d < 0$, then there are vectors, $d\vec{x}$, for which  $ d\vec{x} \cdot (Hd\vec{x})$ will have different signs, and along these vectors the function will be concave up/concave down.
"""

# ╔═╡ ccda38ce-7b01-11ec-3801-61074486ef4c
md"""Apply this to $f(x,y) = xy$ at $\vec{a} = \vec{0}$ we have $f_{xx} = f_{yy} = 0$ and $f_{xy} = 1$, so the determinant of the Hessian is $-1$. By the second partial derivative test, this critical point is a saddle point, as seen from the previous graph.
"""

# ╔═╡ ccda38ea-7b01-11ec-0ed1-fde4fe45c2c8
md"""Applying this to $f(x,y) = e^{-(x^2 + y^2)/5} \cos(x^2 + y^2)$, we will use `SymPy` to compute the derivatives, as they get a bit involved:
"""

# ╔═╡ ccda433c-7b01-11ec-3591-11679c7ee1a2
md"""This is messy, but we only consider it at critical points. The point $(0,0)$ is graphically a local maximum. We can see from the Hessian, that the second partial derivative test will give the same characterization:
"""

# ╔═╡ ccda47d8-7b01-11ec-0128-a3f3229453e3
md"""Which satisfies:
"""

# ╔═╡ ccda4bc0-7b01-11ec-11e4-7b7e75c85d11
md"""Now consider $\vec{a} = \langle \sqrt{2\pi + \tan^{-1}(-1/5)}, 0 \rangle$, a point on the first visible ring on the graph. The gradient vanishes here:
"""

# ╔═╡ ccda507a-7b01-11ec-071d-7955fd906387
md"""But the test is *inconclusive*, as the determinant of the Hessian is $0$:
"""

# ╔═╡ ccda5764-7b01-11ec-0ca6-f126dd451730
md"""(The test is inconclusive, as it needs the function to "fall away" from the tangent plane in all directions, in this case, along a circular curve, the function touches the tangent plane, so it doesn't fall away.)
"""

# ╔═╡ ccda5796-7b01-11ec-036a-dbcbc92a7305
md"""##### Example
"""

# ╔═╡ ccda57b4-7b01-11ec-1d0a-759abbbbb789
md"""Characterize the critical points of $f(x,y) = 4xy - x^4 - y^4$.
"""

# ╔═╡ ccda57c8-7b01-11ec-132e-7dc13d4b2f8c
md"""The critical points may be found by solving when the gradient is $\vec{0}$:
"""

# ╔═╡ ccda61dc-7b01-11ec-3aa5-8bff7ba373e7
md"""There are $3$ real critical points. To classify them we need the sign of $f_{xx}$ and the determinant of the Hessian. We make a simple function to compute these, then apply it to each point using a comprehension:
"""

# ╔═╡ ccda66dc-7b01-11ec-111d-bbacb738db8a
md"""We see the first and third points have positive determinant and negative $f_{xx}$, so are relative maxima, and the second point has negative derivative, so is a saddle point. We graphically confirm this:
"""

# ╔═╡ ccda6dee-7b01-11ec-0373-f55af475d134
md"""##### Example
"""

# ╔═╡ ccda6e0c-7b01-11ec-0459-0366e9fb88cc
md"""Consider the function $f(x,y) = x^2 + 3y^2 -x$ over the region $x^2 + y^2 \leq 1$. This is a continuous function over a closed set, so will have both an absolute maximum and minimum. Find these from an investigation of the critical points and the boundary points.
"""

# ╔═╡ ccda6e20-7b01-11ec-2dbb-2ded95ec71d7
md"""The gradient is easily found: $\nabla{f} = \langle 2x - 1, 6y \rangle$, and is $\vec{0}$ only at $\vec{a} = \langle 1/2, 0 \rangle$. The Hessian is:
"""

# ╔═╡ ccda6e3e-7b01-11ec-1a6b-b5ca5b0703a7
md"""```math
H = \left[
\begin{array}{}
2 & 0\\
0 & 6
\end{array}
\right].
```
"""

# ╔═╡ ccda6e64-7b01-11ec-1eff-6d63da74c586
md"""At $\vec{a}$ this has positive determinant and $f_{xx} > 0$, so $\vec{a}$ corresponds to a *local* minimum with values $f(\vec{a}) = (1/2)^2 + 3(0) - 1/2 = -1/4$. The absolute maximum and minimum may occur here (well, not the maximum) or on the boundary, so that must be considered. In this case we can easily parameterize the boundary and turn this into the univariate case:
"""

# ╔═╡ ccda746a-7b01-11ec-38c6-a181cba78dee
md"""We see that maximum value is `2.25` and that the interior point, $\vec{a}$, will be where the minimum value occurs. To see exactly where the maximum occurs, we look at the values of gamma:
"""

# ╔═╡ ccda780a-7b01-11ec-2774-0771fc0ff2a6
md"""These are multiples of $\pi$:
"""

# ╔═╡ ccda79e2-7b01-11ec-2136-618e9cd28b60
md"""So we have the maximum occurs at the angles $2\pi/3$ and $4\pi/3$. Here we visualize, using a hacky trick of assigning `NaN` values to the function to avoid plotting outside the circle:
"""

# ╔═╡ ccda8556-7b01-11ec-0c23-9b3c17ba1bf9
md"""A contour plot also shows that some - and only one - extrema happens on the interior:
"""

# ╔═╡ ccda8aea-7b01-11ec-1861-c57c70131377
md"""The extrema are identified by the enclosing regions, in this case the one around the point $(1/2, 0)$.
"""

# ╔═╡ ccda8afe-7b01-11ec-2e06-57a7dc53d36c
md"""##### Example: Steiner's problem
"""

# ╔═╡ ccda8b24-7b01-11ec-0712-df44d16e2e17
md"""This is from [Strang](https://ocw.mit.edu/resources/res-18-001-calculus-online-textbook-spring-2005/textbook/MITRES_18_001_strang_13.pdf) p 506.
"""

# ╔═╡ ccda8b4e-7b01-11ec-2e38-db039d9f6191
md"""We have three points in the plane, $(x_1, y_1)$, $(x_2, y_2)$, and $(x_3,y_3)$. A point $p=(p_x, p_y)$ will have $3$ distances $d_1$, $d_2$, and $d_3$. Broadly speaking we want to minimize to find the point $p$ "nearest" the three fixed points within the triangle. Locating a facility so that it can service 3 separate cities might be one application. The answer depends on the notion of what measure of distance to use.
"""

# ╔═╡ ccda8b62-7b01-11ec-146f-e34961d21434
md"""If the measure is the Euclidean distance, then $d_i^2 = (p_x - x_i)^2 + (p_y - y_i)^2$. If we sought to minimize $d_1^2 + d_2^2 + d_3^2$, then we would proceed as follows:
"""

# ╔═╡ ccda9096-7b01-11ec-342b-27d04022a67d
md"""We then find the gradient, and solve for when it is $\vec{0}$:
"""

# ╔═╡ ccda947c-7b01-11ec-3183-871cc4220291
md"""There is only one critical point, so must be a minimum.
"""

# ╔═╡ ccda949c-7b01-11ec-2740-3da8372658c4
md"""We confirm this by looking at the Hessian and noting $H_{11} > 0$:
"""

# ╔═╡ ccda9a12-7b01-11ec-2d34-a3dd1c88b423
md"""As it occurs at $(\bar{x}, \bar{y})$ where $\bar{x} = (x_1 + x_2 + x_3)/3$ and $\bar{y} = (y_1+y_2+y_3)/3$ - the averages of the three values - the critical point is an interior point of the triangle.
"""

# ╔═╡ ccda9a30-7b01-11ec-1b6f-65165fcf8a8b
md"""As mentioned by Strang, the real problem is to minimize $d_1 + d_2 + d_3$. A direct approach with `SymPy` - just replacing `d2` above with the square root` fails. Consider instead the gradient of $d_1$, say. To avoid square roots, this is taken implicitly from $d_1^2$:
"""

# ╔═╡ ccda9a44-7b01-11ec-3ffe-cb06e63296dd
md"""```math
\frac{\partial}{\partial{x}}(d_1^2) = 2 d_1 \frac{\partial{d_1}}{\partial{x}}.
```
"""

# ╔═╡ ccda9a58-7b01-11ec-06ee-01ba150d3145
md"""But computing directly from the expression yields $2(x - x_1)$ Solving, yields:
"""

# ╔═╡ ccda9a6a-7b01-11ec-04d4-33603efc0b23
md"""```math
\frac{\partial{d_1}}{\partial{x}} = \frac{(x-x_1)}{d_1}, \quad
\frac{\partial{d_1}}{\partial{y}} = \frac{(y-y_1)}{d_1}.
```
"""

# ╔═╡ ccda9a94-7b01-11ec-2cb6-177ea2e7c245
md"""The gradient is then $(\vec{p} - \vec{x}_1)/\|\vec{p} - \vec{x}_1\|$, a *unit* vector, call it $\hat{u}_1$. Similarly for $\hat{u}_2$ and $\hat{u}_3$.
"""

# ╔═╡ ccda9aa8-7b01-11ec-1270-61fe842d7bf5
md"""Let $f = d_1 + d_2 + d_3$. Then $\nabla{f} = \hat{u}_1 + \hat{u}_2 + \hat{u}_3$. At the minimum, the gradient is $\vec{0}$, so the three unit vectors must cancel. This can only happen if the three make a "peace" sign with angles $120^\circ$ between them. To find the minimum then within the triangle, this point and the boundary must be considered, when this point falls outside the triangle.
"""

# ╔═╡ ccda9ab2-7b01-11ec-2225-6b0fc01b7fe1
md"""Here is a triangle, where the minimum would be within the triangle:
"""

# ╔═╡ ccdaa3a4-7b01-11ec-2603-5f8265744c1f
begin
	usₛ = [[cos(t), sin(t)] for t in (0, 2pi/3, 4pi/3)]
	polygon(ps) = unzip(vcat(ps, ps[1:1])) # easier way to plot a polygon
	
	pₛ = scatter([0],[0], markersize=2, legend=false, aspect_ratio=:equal)
	
	asₛ = (1,2,3)
	plot!(polygon([a*u for (a,u) in zip(asₛ, usₛ)])...)
	[arrow!([0,0], a*u, alpha=0.5) for (a,u) in zip(asₛ, usₛ)]
	pₛ
end

# ╔═╡ ccdaa3b8-7b01-11ec-3fe4-4b680484f036
md"""For this triangle we find the Steiner point outside of the triangle.
"""

# ╔═╡ ccdaa836-7b01-11ec-26af-072a6fad81e6
begin
	asₛ₁ = (1, -1, 3)
	scatter([0],[0], markersize=2, legend=false)
	psₛₗ = [a*u for (a,u) in zip(asₛ₁, usₛ)]
	plot!(polygon(psₛₗ)...)
end

# ╔═╡ ccdaa85e-7b01-11ec-2c5c-83c36530b8d2
md"""Let's see where the minimum distance point is by constructing a plot. The minimum must be on the boundary, as the only point where the gradient vanishes is the origin, not in the triangle. The plot of the triangle has a contour plot of the distance function, so we see clearly that the minimum happens at the point `[0.5, -0.866025]`. On this plot, we drew the gradient at some points along the boundary. The gradient points in the direction of greatest increase - away from the minimum. That the gradient vectors have a non-zero projection onto the edges of the triangle in a direction pointing away from the point indicates that the function `d` would increase if moved along the boundary in that direction, as indeed it does.
"""

# ╔═╡ ccdaaf16-7b01-11ec-2aeb-39ff4860d4be
begin
	euclid_dist(x; ps=psₛₗ) = sum(norm(x-p) for p in ps)
	euclid_dist(x,y; ps=psₛₗ) = euclid_dist([x,y]; ps=ps)
end

# ╔═╡ ccdab466-7b01-11ec-10ca-e5ad02d4631e
let
	xs = range(-1.5, 1.5, length=100)
	ys = range(-3, 1.0, length=100)
	
	p = plot(polygon(psₛₗ)..., linewidth=3, legend=false)
	scatter!(p, unzip(psₛₗ)..., markersize=3)
	contour!(p, xs, ys, euclid_dist)
	
	# add some gradients along boundary
	li(t, p1, p2) = p1 + t*(p2-p1)  # t in [0,1]
	for t in range(1/100, 1/2, length=3)
	    pt = li(t, psₛₗ[2], psₛₗ[3])
	    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
	    pt = li(t, psₛₗ[2], psₛₗ[1])
	    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
	end
	
	p
end

# ╔═╡ ccdab47a-7b01-11ec-0a15-63122a93f642
md"""The following graph, shows distance along each edge:
"""

# ╔═╡ ccdab97a-7b01-11ec-0e13-41e94fda472a
let
	li(t, p1, p2) = p1 + t*(p2-p1)
	p = plot(legend=false)
	for i in 1:2, j in (i+1):3
	  plot!(p, t -> euclid_dist(li(t, psₛₗ[i], psₛₗ[j]); ps=psₛₗ), 0, 1)
	end
	p
end

# ╔═╡ ccdab9ac-7b01-11ec-2da1-fd0fbfb979da
md"""The smallest value is when $t=0$ or $t=1$, so at one of the points, as `li` is defined above.
"""

# ╔═╡ ccdab9c0-7b01-11ec-3f1a-dfb6f18e0e4a
md"""##### Example: least squares
"""

# ╔═╡ ccdab9e8-7b01-11ec-1abe-f74472333af3
md"""We know that two points determine a line. What happens when there are more than two points? This is common in statistics where a bivariate data set (pairs of points $(x,y)$) are summarized through a linear model $\mu_{y|x} = \alpha + \beta x$, That is the average value for $y$ given a particular $x$ value is given through the equation of a line. The data is used to identify what the slope and intercept are for this line. We consider a simple case - $3$ points. The case of $n \geq 3$ being similar.
"""

# ╔═╡ ccdaba10-7b01-11ec-062a-9f4eee7bcd65
md"""We have a line $l(x) = \alpha + \beta(x)$ and three points $(x_1, y_1)$, $(x_2, y_2)$, and $(x_3, y_3)$. Unless these three points *happen* to be collinear, they can't possibly all lie on the same line. So to *approximate* a relationship by a line requires some inexactness. One measure of inexactness is the *vertical* distance to the line:
"""

# ╔═╡ ccdaba24-7b01-11ec-0b02-9f41970c7386
md"""```math
d1(\alpha, \beta) = |y_1 - l(x_1)| + |y_2 - l(x_2)| + |y_3 - l(x_3)|.
```
"""

# ╔═╡ ccdaba2c-7b01-11ec-2d92-eb858d7b61ae
md"""Another might be the vertical squared distance to the line:
"""

# ╔═╡ ccdaba42-7b01-11ec-2228-a5590f472dfc
md"""```math
d2(\alpha, \beta) = (y_1 - l(x_1))^2 + (y_2 - l(x_2))^2 + (y_3 - l(x_3))^2 =
(y1 - (\alpha + \beta x_1))^2 + (y3 - (\alpha + \beta x_3))^2 + (y3 - (\alpha + \beta x_3))^2
```
"""

# ╔═╡ ccdaba60-7b01-11ec-10f9-4d56827f35d9
md"""Another might be the *shortest* distance to the line:
"""

# ╔═╡ ccdaba6a-7b01-11ec-0bf4-2100e7613009
md"""```math
d3(\alpha, \beta) = \frac{\beta x_1 - y_1 + \alpha}{\sqrt{1 + \beta^2}} + \frac{\beta x_2 - y_2 + \alpha}{\sqrt{1 + \beta^2}} + \frac{\beta x_3 - y_3 + \alpha}{\sqrt{1 + \beta^2}}.
```
"""

# ╔═╡ ccdaba7e-7b01-11ec-0938-ab8cb082f7a3
md"""The method of least squares minimizes the second one of these. That is, it chooses $\alpha$ and $\beta$ that make the expression a minimum.
"""

# ╔═╡ ccdac262-7b01-11ec-1638-e1a06e9732d7
md"""To identify $\alpha$ and $\beta$ we find the gradient:
"""

# ╔═╡ ccdac834-7b01-11ec-2d50-a7807fc4896a
md"""As found, the formulas aren't pretty. If $x_1 + x_2 + x_3 = 0$ they simplify. For example:
"""

# ╔═╡ ccdacb72-7b01-11ec-2745-bffbf0c47a81
md"""Let $\vec{x} = \langle x_1, x_2, x_3 \rangle$ and $\vec{y} = \langle y_1, y_2, y_3 \rangle$ this is simply $(\vec{x} \cdot \vec{y})/(\vec{x}\cdot \vec{x})$, a formula that will generalize to $n > 3$. The assumption is not a restriction - it comes about by subtracting the mean, $\bar{x} = (x_1 + x_2 + x_3)/3$, from each $x$ term (and similarly subtract $\bar{y}$ from each $y$ term). A process called "centering."
"""

# ╔═╡ ccdacb86-7b01-11ec-3556-dbec75258c30
md"""With this observation, the formulas can be re-expressed through:
"""

# ╔═╡ ccdacb9a-7b01-11ec-0266-b100cae6ac6b
md"""```math
\beta = \frac{\sum{x_i - \bar{x}}(y_i - \bar{y})}{\sum(x_i-\bar{x})^2},
\quad
\alpha = \bar{y} - \beta \bar{x}.
```
"""

# ╔═╡ ccdacbac-7b01-11ec-0669-ad910d6b6fcd
md"""Relative to the centered values, this may be viewed as a line through $(\bar{x}, \bar{y})$ with slope given by $(\vec{x}-\bar{x})\cdot(\vec{y}-\bar{y}) / \|\vec{x}-\bar{x}\|$.
"""

# ╔═╡ ccdacbc2-7b01-11ec-1bc9-d37e5fe65f52
md"""As an example, if the point are $(1,1), (2,3), (5,8)$ we get:
"""

# ╔═╡ ccdad854-7b01-11ec-296c-970f055b20db
md"""### Gradient descent
"""

# ╔═╡ ccdad874-7b01-11ec-1365-319c226cbca7
md"""As seen in the examples above, extrema may be identified analytically by solving for when the gradient is $0$. Here we discuss some numeric algorithms for finding extrema.
"""

# ╔═╡ ccdad89c-7b01-11ec-2ff5-dd407c616a34
md"""An algorithm to identify where a surface is at its minimum is [gradient descent](https://en.wikipedia.org/wiki/Gradient_descent). The gradient points in the direction of the steepest ascent of the surface and the negative gradient the direction of the steepest descent. To move to a minimum then, it make intuitive sense to move in the direction of the negative gradient. How far? That is a different question and one with different answers. Let's formulate the movement first, then discuss how far.
"""

# ╔═╡ ccdad8ba-7b01-11ec-3d97-7162d922ccd8
md"""Let $\vec{x}_0$, $\vec{x}_1$, $\dots$, $\vec{x}_n$ be the position of the algorithm for $n$ steps starting from an initial point $\vec{x}_0$. The difference between these points is given by:
"""

# ╔═╡ ccdad8ce-7b01-11ec-14ab-b5d4ba8a9549
md"""```math
\vec{x}_{n+1} = \vec{x}_n - \gamma \nabla{f}(\vec{x}_n),
```
"""

# ╔═╡ ccdad8ec-7b01-11ec-1062-c36246981ed1
md"""where $\gamma$ is some scaling factor for the gradient. The above quantifies the idea: to go from $\vec{x}_n$ to $\vec{x}_{n+1}$, move along $-\nabla{f}$ by a certain amount.
"""

# ╔═╡ ccdad900-7b01-11ec-2b9d-a38702c6ddff
md"""Let $\Delta_x =\vec{x}_{n}- \vec{x}_{n-1}$ and $\Delta_y =  \nabla{f}(\vec{x}_{n}) -  \nabla{f}(\vec{x}_{n-1})$ A variant of the Barzilai-Borwein method is to take $\gamma_n = | \Delta_x \cdot \Delta_y / \Delta_y \cdot \Delta_y |$.
"""

# ╔═╡ ccdad91e-7b01-11ec-0bfa-9dfc8592d699
md"""To illustrate, take $f(x,y) = -(x^2 + y^2) \cdot e^{-(2x^2 + y^2)}$ and a starting point $\langle 1, 1 \rangle$. We have, starting with $\gamma_0 = 1$ there are $5$ steps taken:
"""

# ╔═╡ ccdae1de-7b01-11ec-02e7-433e022096c6
md"""We now visualize, using the `Contour` package to draw the contour lines in the $x-y$ plane:
"""

# ╔═╡ ccdaf8e0-7b01-11ec-32cb-b1368ed7cd71
md"""### Newton's method for minimization
"""

# ╔═╡ ccdaf912-7b01-11ec-2bae-9b1370dc5718
md"""A variant of Newton's method can be used to minimize a function $f:R^2 \rightarrow R$. We look for points where both partial derivatives of $f$ vanish. Let $g(x,y) = \partial f/\partial x(x,y)$ and $h(x,y) = \partial f/\partial y(x,y)$. Then applying Newton's method, as above to solve simultaneously for when $g=0$ and $h=0$, we considered this matrix:
"""

# ╔═╡ ccdaf926-7b01-11ec-2c2b-4bd5e4900540
md"""```math
M = [\nabla{g}'; \nabla{h}'],
```
"""

# ╔═╡ ccdaf94c-7b01-11ec-249a-ebf510c326d0
md"""and had a step expressible in terms of the inverse of $M$ as $M^{-1} [g; h]$. In terms of the function $f$, this step is $H^{-1}\nabla{f}$, where $H$ is the Hessian matrix. [Newton](https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization#Higher_dimensions)'s method then becomes:
"""

# ╔═╡ ccdaf958-7b01-11ec-2be4-53795e26a0d2
md"""```math
\vec{x}_{n+1} = \vec{x}_n - [H_f(\vec{x}_n]^{-1} \nabla(f)(\vec{x}_n).
```
"""

# ╔═╡ ccdaf96c-7b01-11ec-1b6e-7747ea2d8733
md"""The Wikipedia page states where applicable, Newton's method converges much faster towards a local maximum or minimum than gradient descent.
"""

# ╔═╡ ccdaf980-7b01-11ec-37a1-b9035218bc04
md"""We apply it to the task of characterizing the following function, which has a few different peaks over the region $[-3,3] \times [-2,2]$:
"""

# ╔═╡ ccdb1438-7b01-11ec-3f63-675eb46c6ccf
md"""As we will solve for the critical points numerically, we consider the contour plot as well, as it shows better where the critical points are.
"""

# ╔═╡ ccdb1460-7b01-11ec-1780-abdcec8d92ed
md"""Over this region we see clearly 5 peaks or valleys: near $(0, 1.5)$, near $(1.2, 0)$, near $(0.2, -1.8)$, near $(-0.5, -0.8)$, and near $(-1.2, 0.2)$. To classify the $5$ critical points we need to first identify them, then compute the Hessian, and then, possibly compute $f_xx$ at the point. Here we do so for one of them using a numeric approach.
"""

# ╔═╡ ccdb1472-7b01-11ec-2c22-49eb2534db4e
md"""For concreteness, consider the peak or valley near $(0,1.5)$. We use Newton's method to numerically compute the critical point. The Newton step, specialized here is:
"""

# ╔═╡ ccdb1a28-7b01-11ec-03f8-537aa74174b9
function newton_stepₚ(f, x)
  M = ForwardDiff.hessian(f, x)
  b = ForwardDiff.gradient(f, x)
  x - M \ b
end

# ╔═╡ ccdb1a3c-7b01-11ec-226f-8dc438209e75
md"""We perform 3 steps of Newton's method, and see that it has found a critical point.
"""

# ╔═╡ ccdb1df2-7b01-11ec-02d0-816e95041e3e
md"""The Hessian at this point is given by:
"""

# ╔═╡ ccdb2004-7b01-11ec-0daf-d753ba467ebe
md"""From which we see:
"""

# ╔═╡ ccdb23c4-7b01-11ec-226c-cd42181ae434
md"""Consequently we have a local maximum at this critical point.
"""

# ╔═╡ ccdb2964-7b01-11ec-18ae-11cae0aaa9df
note(""" The `Optim.jl` package provides efficient implementations of these two numeric methods, and others. """)

# ╔═╡ ccdb298c-7b01-11ec-2132-2bde738ab10a
md"""## Constrained optimization, Lagrange multipliers
"""

# ╔═╡ ccdb29b4-7b01-11ec-33ee-39870c0fa3fa
md"""We considered the problem of maximizing a function over a closed region. This maximum is achieved at a critical point *or* a boundary point. Investigating the critical points isn't so difficult and the second partial derivative test can help characterize the points along the way, but characterizing the boundary points usually involves parameterizing the boundary, which is not always so easy. However, if we put this problem into a more general setting a different technique becomes available.
"""

# ╔═╡ ccdb29d2-7b01-11ec-18a5-e1397fddb124
md"""The different setting is: maximize $f(x,y)$ subject to the constraint $g(x,y) = k$. The constraint can be used to describe the boundary used previously.
"""

# ╔═╡ ccdb29fc-7b01-11ec-106a-a125e4eb3a3d
md"""Why does this help? The key is something we have seen prior: If $g$ is differentiable, and we take $\nabla{g}$, then it will point at directions *orthogonal* to the level curve $g(x,y) = 0$. (Parameterize the curve, then $(g\circ\vec{r})(t) = 0$ and so the chain rule has $\nabla{g}(\vec{r}(t)) \cdot \vec{r}'(t) = 0$.) For example, consider the function $g(x,y) = x^2 +2y^2 - 1$. The level curve $g(x,y) = 0$ is an ellipse. Here we plot the level curve, along with a few gradient vectors at points satisfying $g(x,y) = 0$:
"""

# ╔═╡ ccdb2fae-7b01-11ec-00e3-b9a13b939a62
md"""From the plot we see the key property that $g$ is orthogonal to the level curve.
"""

# ╔═╡ ccdb2fd6-7b01-11ec-0d41-977181dc0d38
md"""Now consider $f(x,y)$, a function we wish to maximize. The gradient points in the direction of *greatest* increase, provided $f$ is smooth. We are interested in the value of this gradient along the level curve of $g$. Consider this figure representing a portion of the level curve, it's tangent, normal, the gradient of $f$, and the contours of $f$:
"""

# ╔═╡ ccdb356a-7b01-11ec-3229-b728b9b7fdb0
md"""We can identify the tangent, the normal, and subsequently the gradient of $f$. Is the point drawn a maximum of $f$ subject to the constraint $g$?
"""

# ╔═╡ ccdb3594-7b01-11ec-00d3-89820a86a9d2
md"""The answer is no, but why? By adding the contours of $f$, we see that moving along the curve from this point will increase or decrease $f$, depending on which direction we move in. As the *gradient* is the direction of greatest increase, we can see that the *projection* of the gradient on the tangent will point in a direction of *increase*.
"""

# ╔═╡ ccdb35a8-7b01-11ec-3bb9-19f6200cc36e
md"""It isn't just because the point picked was chosen to make a pretty picture, and not be a maximum. Rather, the fact that $\nabla{f}$ has a non-trivial projection onto the tangent vector. What does it say if we move the point in the direction of this projection?
"""

# ╔═╡ ccdb35bc-7b01-11ec-1c7f-aba49d8dc010
md"""The gradient points in the direction of greatest increase. If we first move in one component of the gradient we will increase, just not as fast. This is because the directional derivative in the direction of the tangent will be non-zero. In the picture, if we were to move the point to the right along the curve $f(x,y)$ will increase.
"""

# ╔═╡ ccdb35c6-7b01-11ec-0fd7-b3a94f1e0679
md"""Now consider this figure at a different point of the figure:
"""

# ╔═╡ ccdb3b2a-7b01-11ec-12c6-9f7a5a392f72
md"""We can still identify the tangent and normal directions. What is different about this point is that local movement on the constraint curve is also local movement on the contour line of $f$, so $f$ doesn't increase or decrease here, as it would if this point were an extrema along the contraint. The key to seeing this is the contour lines of $f$ are *tangent* to the constraint. The respective gradients are *orthogonal* to their tangent lines, and in dimension $2$, this implies they are parallel to each other.
"""

# ╔═╡ ccdccb22-7b01-11ec-3940-cd97af59bd80
md"""> *The method of Lagrange multipliers*: To optimize $f(x,y)$ subject to a constraint $g(x,y) = k$ we solve for all *simultaneous* solutions to
>
> ```math
> \begin{align}
> \nabla{f}(x,y) &= \lambda \nabla{g}(x,y), \text{and}\\
> g(x,y) &= k.
> \end{align}
> ```
>
> These *possible* points are evaluated to see if they are maxima or minima.

"""

# ╔═╡ ccdccb70-7b01-11ec-2adb-7d588eba80d4
md"""The method will not work if $\nabla{g} = \vec{0}$ or if $f$ and $g$ are not differentiable.
"""

# ╔═╡ ccdccbac-7b01-11ec-32c6-2b0caceece01
md"""---
"""

# ╔═╡ ccdccbd4-7b01-11ec-2c62-c536a615686b
md"""##### Example
"""

# ╔═╡ ccdccc06-7b01-11ec-0a25-0b4679b3c464
md"""We consider [again]("../derivatives/optimization.html") the problem of maximizing all rectangles subject to the perimeter being $20$. We have seen this results in a square. This time we use the Lagrange multiplier technique. We have two equations:
"""

# ╔═╡ ccdccc26-7b01-11ec-0d64-cd82a56ccbcd
md"""```math
A(x,y) = xy, \quad P(x,y) = 2x + 2y = 25.
```
"""

# ╔═╡ ccdccc42-7b01-11ec-3b9e-fbc75a33108d
md"""We see $\nabla{A} = \lambda \nabla{P}$, or $\langle y, x \rangle = \lambda \langle 2, 2\rangle$. We see the solution has $x = y$ and from the constraint $x=y = 5$.
"""

# ╔═╡ ccdccc4c-7b01-11ec-3679-73cab6893bc3
md"""This is clearly the maximum for this problem, though the Lagrange technique does not imply that, it only identifies possible extrema.
"""

# ╔═╡ ccdccc58-7b01-11ec-32f3-3d282861b234
md"""##### Example
"""

# ╔═╡ ccdccc6a-7b01-11ec-0d4e-91d44654d6fc
md"""We can reverse the question: what are the ranges for the perimeter when the area is a fixed value of $25$? We have:
"""

# ╔═╡ ccdccc74-7b01-11ec-1349-6fd8966667c8
md"""```math
P(x,y) = 2x + 2y, \quad A(x,y) = xy = 25.
```
"""

# ╔═╡ ccdccc92-7b01-11ec-206c-15ed130fcb66
md"""Now we look for $\nabla{P} = \lambda \nabla{A}$ and will get,  as the last example, that $\langle 2, 2 \rangle = \lambda \langle y, x\rangle$. So $x=y$ and from the constraint $x=y=5$.
"""

# ╔═╡ ccdcccb8-7b01-11ec-0cb3-313b8818fb49
md"""However this is *not* the maximum perimeter, but rather the minimal perimeter. The maximum is $\infty$, which comes about in the limit by considering long skinny rectangles.
"""

# ╔═╡ ccdcccc4-7b01-11ec-327d-29576093090c
md"""##### Example: A rephrasing
"""

# ╔═╡ ccdcccce-7b01-11ec-1a3f-9fce7f696d7d
md"""An slightly different formulation of the Lagrange method is to combine the equation and the constraint into one equation:
"""

# ╔═╡ ccdccce2-7b01-11ec-077a-95cf44c473e3
md"""```math
L(x,y,\lambda) = f(x,y) - \lambda (g(x,y)  -  k).
```
"""

# ╔═╡ ccdcccea-7b01-11ec-014b-6349e660140d
md"""The we have
"""

# ╔═╡ ccdcccf6-7b01-11ec-1b53-0fd8edc253bb
md"""```math
\begin{align}
\frac{\partial L}{\partial{x}} &= \frac{\partial{f}}{\partial{x}} - \lambda \frac{\partial{g}}{\partial{x}}\\
\frac{\partial L}{\partial{y}} &= \frac{\partial{f}}{\partial{y}} - \lambda \frac{\partial{g}}{\partial{y}}\\
\frac{\partial L}{\partial{\lambda}} &= 0 + (g(x,y)  -  k).
\end{align}
```
"""

# ╔═╡ ccdccd14-7b01-11ec-3d61-df7e96a5dcce
md"""But if the Lagrange condition holds, each term is $0$, so Lagrange's method can be seen as solving for point $\nabla{L} = \vec{0}$. The optimization problem in two variables with a constraint becomes a problem of finding and classifying  zeros of a function with *three* variables.
"""

# ╔═╡ ccdccd1e-7b01-11ec-2805-3fd2636e92c3
md"""Apply this to the optimization problem:
"""

# ╔═╡ ccdccd32-7b01-11ec-1bfe-a94146132748
md"""Find the extrema of $f(x,y) = x^2 - y^2$ subject to the constraint $g(x,y) = x^2 + y^2 = 1$.
"""

# ╔═╡ ccdccd3c-7b01-11ec-0b1d-915810aa32c9
md"""We have:
"""

# ╔═╡ ccdccd46-7b01-11ec-1d2f-6bd3de38c6fc
md"""```math
L(x, y, \lambda) = f(x,y) - \lambda(g(x,y) - 1)
```
"""

# ╔═╡ ccdccd5a-7b01-11ec-1013-6182c03ce418
md"""We can solve for $\nabla{L} = \vec{0}$ by hand, but we do so symbolically:
"""

# ╔═╡ ccdcd2e6-7b01-11ec-21e5-c95b3845f759
md"""This has $4$ easy solutions, here are the values at each point:
"""

# ╔═╡ ccdcd7dc-7b01-11ec-3c48-273ccb00f702
md"""So $1$ is a maximum value and $-1$ a minimum value.
"""

# ╔═╡ ccdcd7f8-7b01-11ec-034e-811429dc9565
md"""##### Example: Dido's problem
"""

# ╔═╡ ccdcd8d6-7b01-11ec-3a58-cb655938b374
md"""Consider a slightly different problem:  What shape should a rope (curve) of fixed length make to *maximize* the area between the rope and $x$ axis?
"""

# ╔═╡ ccdcd8f4-7b01-11ec-0c0b-613405430a94
md"""Let $L$ be the length of the rope and suppose $y(x)$ describes the curve. Then we wish to
"""

# ╔═╡ ccdcd8fc-7b01-11ec-35f6-cda9f7b00b02
md"""```math
\text{Maximize } \int y(x) dx, \quad\text{subject to }
\int \sqrt{1 + y'(x)^2} dx = L.
```
"""

# ╔═╡ ccdcd9a8-7b01-11ec-0c39-41d682a9e58b
md"""The latter being the formula for arc length. This is very much like a optimization problem that Lagrange's method could help solve, but with one big difference: the answer is *not* a point but a *function*.
"""

# ╔═╡ ccdcd9c6-7b01-11ec-33ae-a57524f94c2e
md"""This is a variant of  [Dido](http://www.ams.org/publications/journals/notices/201709/rnoti-p980.pdf)'s problem, described by Bandle as
"""

# ╔═╡ ccdcdab6-7b01-11ec-04fe-3fcc0968600f
md"""> *Dido’s problem*: The Roman poet Publius Vergilius Maro (70–19 B.C.) tells in his epic Aeneid the story of queen Dido, the daughter of the Phoenician king of the 9th century B.C. After the assassination of her husband by her brother she fled to a haven near Tunis. There she asked the local leader, Yarb, for as much land as could be enclosed by the hide of a bull. Since the deal seemed very modest, he agreed. Dido cut the hide into narrow strips, tied them together and encircled a large tract of land which became the city of Carthage. Dido faced the following mathematical problem, which is also known as the isoperimetric problem: Find among all curves of given length the one which encloses maximal area.  Dido found intuitively the right answer.

"""

# ╔═╡ ccdcdac8-7b01-11ec-300c-43dd6d22029e
md"""The problem as stated above and method of solution follows notes by [Wang](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.368.1522&rep=rep1&type=pdf) though Bandle attributes the ideas  back to a 19-year old Lagrange in a letter to Euler.
"""

# ╔═╡ ccdcdade-7b01-11ec-10f2-f36e2bb6fea7
md"""The method of solution will be to *assume* we have the function and then characterize this function in such a way that it can be identified.
"""

# ╔═╡ ccdcdaf2-7b01-11ec-24db-0fa9998db8b5
md"""Following Lagrange, we generalize the problem to the following: maximize $\int_{x_0}^{x_1} f(x, y(x), y'(x)) dx$ subject to a constraint $\int_{x_0}^{x_1} g(x,y(x), y'(x)) dx = K$. Suppose $y(x)$ is a solution.
"""

# ╔═╡ ccdcdb2e-7b01-11ec-1599-bdaa5bcdec83
md"""The starting point is a *perturbation*: $\hat{y}(x) = y(x) + \epsilon_1 \eta_1(x) + \epsilon_2 \eta_2(x)$. There are two perturbation terms, were only one term added, then the perturbation may make $\hat{y}$ not satisfy the constraint, the second term is used to ensure the constraint is not violated. If $\hat{y}$ is to be a possible solution to our problem, we would want $\hat{y}(x_0) = \hat{y}(x_1) = 0$, as it does for $y(x)$, so we *assume*  $\eta_1$ and $\eta_2$ satisfy this boundary condition.
"""

# ╔═╡ ccdcdb42-7b01-11ec-3cab-6df55016505d
md"""With this notation, and fixing $y$ we can re-express the equations in terms ot $\epsilon_1$ and $\epsilon_2$:
"""

# ╔═╡ ccdcdb56-7b01-11ec-21fe-dbd645af044d
md"""```math
\begin{align}
F(\epsilon_1, \epsilon_2) &= \int f(x, \hat{y}, \hat{y}') dx =
\int f(x, y + \epsilon_1 \eta_1 + \epsilon_2 \eta_2, y' + \epsilon_1 \eta_1' + \epsilon_2 \eta_2') dx,\\
G(\epsilon_1, \epsilon_2) &= \int g(x, \hat{y}, \hat{y}') dx =
\int g(x, y + \epsilon_1 \eta_1 + \epsilon_2 \eta_2, y' + \epsilon_1 \eta_1' + \epsilon_2 \eta_2') dx.
\end{align}
```
"""

# ╔═╡ ccdcdb60-7b01-11ec-2c2c-5f33b4adb92b
md"""Then our problem is restated as:
"""

# ╔═╡ ccdcdb6c-7b01-11ec-1b65-998f666ad11d
md"""```math
\text{Maximize } F(\epsilon_1, \epsilon_2) \text{ subject to }
G(\epsilon_1, \epsilon_2) = L.
```
"""

# ╔═╡ ccdcdb74-7b01-11ec-3dc5-6bdc7d2ecd92
md"""Now, Lagrange's method can be employed. This will be fruitful - even though we know the answer - it being $\epsilon_1 = \epsilon_2 = 0$!
"""

# ╔═╡ ccdcdb92-7b01-11ec-39ab-af9d7b3c8a6c
md"""Forging ahead, we compute $\nabla{F}$ and $\lambda \nabla{G}$ and set $\epsilon_1 = \epsilon_2 = 0$ where the two  are equal. This will lead to a description of $y$ in terms of $y'$.
"""

# ╔═╡ ccdcdb9e-7b01-11ec-288c-15309987a287
md"""Lagrange's method has:
"""

# ╔═╡ ccdcdbb0-7b01-11ec-2877-210b6e7860ce
md"""```math
\frac{\partial{F}}{\partial{\epsilon_1}}(0,0) - \lambda \frac{\partial{G}}{\partial{\epsilon_1}}(0,0) = 0, \text{ and }
\frac{\partial{F}}{\partial{\epsilon_2}}(0,0) - \lambda \frac{\partial{G}}{\partial{\epsilon_2}}(0,0) = 0.
```
"""

# ╔═╡ ccdcdbba-7b01-11ec-3111-adb2c78bb4b1
md"""Computing just the first one, we have using the chain rule and assuming interchanging the derivative and integral is possible:
"""

# ╔═╡ ccdcdbcc-7b01-11ec-3ebc-d5fc0a8728d5
md"""```math
\begin{align}
\frac{\partial{F}}{\partial{\epsilon_1}}
&= \int \frac{\partial}{\partial{\epsilon_1}}(
f(x, y + \epsilon_1 \eta_1 + \epsilon_2 \eta_2, y' + \epsilon_1 \eta_1' + \epsilon_2 \eta_2')) dx\\
&= \int \left(\frac{\partial{f}}{\partial{y}} \eta_1 + \frac{\partial{f}}{\partial{y'}} \eta_1'\right) dx\quad\quad(\text{from }\nabla{f} \cdot \langle 0, \eta_1, \eta_1'\rangle)\\
&=\int \eta_1 \left(\frac{\partial{f}}{\partial{y}} - \frac{d}{dx}\frac{\partial{f}}{\partial{y'}}\right) dx.
\end{align}
```
"""

# ╔═╡ ccdcdbec-7b01-11ec-38b2-135cc9b1531b
md"""The last line by integration by parts: $\int u'(x) v(x) dx = (u \cdot v)(x)\mid_{x_0}^{x_1} - \int u(x) \frac{d}{dx} v(x) dx = - \int u(x) \frac{d}{dx} v(x) dx $. The last lines, as $\eta_1 = 0$ at $x_0$ and $x_1$ by assumption. We get:
"""

# ╔═╡ ccdcdbf6-7b01-11ec-0f16-c144e0f3f6ad
md"""```math
0 = \int \eta_1\left(\frac{\partial{f}}{\partial{y}} - \frac{d}{dx}\frac{\partial{f}}{\partial{y'}}\right).
```
"""

# ╔═╡ ccdcdc0a-7b01-11ec-034a-5fca4daab0cf
md"""Similarly were $G$ considered, we would find a similar statement. Setting $L(x, y, y') = f(x, y, y') - \lambda g(x, y, y')$, the combination of terms gives:
"""

# ╔═╡ ccdcdc14-7b01-11ec-3538-5f33a490a6cb
md"""```math
0 = \int \eta_1\left(\frac{\partial{L}}{\partial{y}} - \frac{d}{dx}\frac{\partial{L}}{\partial{y'}}\right) dx.
```
"""

# ╔═╡ ccdcdc28-7b01-11ec-08fb-07ad8b53556f
md"""Since $\eta_1$ is arbitrary save for its boundary conditions, under smoothness conditions on $L$ this will imply the rest of the integrand *must* be $0$.
"""

# ╔═╡ ccdcdc46-7b01-11ec-0c4e-1fec64a51e11
md"""That is, If $y(x)$ is a maximizer of $\int_{x_0}^{x_1} f(x, y, y')dx$ and sufficiently smooth over $[x_0, x_1]$ and $y(x)$ satisfies the constraint $\int_{x_0}^{x_1} g(x, y, y')dx = K$ then there exists a constant $\lambda$ such that $L = f -\lambda g$ will satisfy:
"""

# ╔═╡ ccdcdc5a-7b01-11ec-2ef6-3dad1c1a268d
md"""```math
\frac{d}{dx}\frac{\partial{L}}{\partial{y'}} - \frac{\partial{L}}{\partial{y}}  = 0.
```
"""

# ╔═╡ ccdcdc78-7b01-11ec-0ebb-77c78ae05ad6
md"""If $\partial{L}/\partial{x} = 0$, this simplifies to the [Beltrami](https://en.wikipedia.org/wiki/Beltrami_identity) identity:
"""

# ╔═╡ ccdcdc82-7b01-11ec-3f18-af0903f81ac9
md"""```math
L - y' \frac{\partial{L}}{\partial{y'}} = C.\quad(\text{Beltrami identity})
```
"""

# ╔═╡ ccdcdc96-7b01-11ec-1366-754414bb6cde
md"""---
"""

# ╔═╡ ccdcdcb4-7b01-11ec-243e-192a778570c9
md"""For Dido's problem, $f(x,y,y') = y$ and $g(x, y, y') = \sqrt{1 + y'^2}$, so $L = y - \lambda\sqrt{1 + y'^2}$ will have $0$ partial derivative with respect to $x$.  Using the Beltrami identify we have:
"""

# ╔═╡ ccdcdcbe-7b01-11ec-10d6-e7c98a849a0a
md"""```math
(y - \lambda\sqrt{1 + y'^2}) - \lambda y' \frac{2y'}{2\sqrt{1 + y'^2}} = C.
```
"""

# ╔═╡ ccdcdcd4-7b01-11ec-33c6-6d5164d85f4d
md"""by multiplying through by the denominator and squaring to remove the square root, a quadratic equation in $y'^2$ can be found. This can be solved to give:
"""

# ╔═╡ ccdcdcdc-7b01-11ec-1c5e-d7d628837e50
md"""```math
y' = \frac{dy}{dx} = \sqrt{\frac{\lambda^2 -(y + C)^2}{(y+C)^2}}.
```
"""

# ╔═╡ ccdcdd02-7b01-11ec-3bed-e1b3d162a0bd
md"""Here is a snippet of `SymPy` code to verify the above:
"""

# ╔═╡ ccdce274-7b01-11ec-0ce9-2d7dce5b9e98
md"""Now $y'$ can be integrated using the substitution $y + C = \lambda \cos\theta$ to give: $-\lambda\int\cos\theta d\theta = x + D$, $D$ some constant. That is:
"""

# ╔═╡ ccdce27c-7b01-11ec-1f24-d165b0e81798
md"""```math
\begin{align}
x + D &=  - \lambda \sin\theta\\
y + C &= \lambda\cos\theta.
\end{align}
```
"""

# ╔═╡ ccdce290-7b01-11ec-2ccc-e5787fcec995
md"""Squaring gives the equation of a circle: $(x +D)^2 + (y+C)^2 = \lambda^2$.
"""

# ╔═╡ ccdce2ae-7b01-11ec-1a25-0539d2a006fb
md"""We center and *rescale* the problem so that $x_0 = -1, x_1 = 1$. Then $L > 2$ as otherwise the rope is too short. From here, we describe the radius and center of the circle.
"""

# ╔═╡ ccdce2c2-7b01-11ec-124c-47d7eb493046
md"""We have $y=0$ at $x=1$ and $-1$ giving:
"""

# ╔═╡ ccdce2cc-7b01-11ec-2397-a96f326b2f7e
md"""```math
\begin{align}
(-1 + D)^2 + (0 + C)^2 &= \lambda^2\\
(+1 + D)^2 + (0 + C)^2 &= \lambda^2.
\end{align}
```
"""

# ╔═╡ ccdce2ea-7b01-11ec-0aed-9dac86868505
md"""Squaring out and solving gives $D=0$, $1 + C^2 = \lambda^2$. That is, an arc of circle with radius $1+C^2$ and centered at $(0, -C)$.
"""

# ╔═╡ ccdce2f4-7b01-11ec-3893-e3aac9110b2e
md"""```math
x^2 + (y + C)^2 = 1 + C^2.
```
"""

# ╔═╡ ccdce31c-7b01-11ec-38ec-514d4bac38e1
md"""Now to identify $C$ in terms of $L$. $L$ is the length of arc of circle of radius $r =\sqrt{1 + C^2}$ and angle $2\theta$, so $L = 2r\theta$ But using the boundary conditions in the equations for $x$ and $y$ gives $\tan\theta = 1/C$, so $L = 2\sqrt{1 + C^2}\tan^{-1}(1/C)$ which can be solved for $C$ provided $L \geq 2$.
"""

# ╔═╡ ccdce33a-7b01-11ec-14ff-67cbb720f6ee
md"""##### Example: more constraints
"""

# ╔═╡ ccdce36c-7b01-11ec-2ef4-33fd05ba514b
md"""Consider now the case of maximizing $f(x,y,z)$ subject to $g(x,y,z)=c$ and $h(x,y,z) = d$. Can something similar be said to characterize potential values for this to occur? Trying to describe where $g(x,y,z) = c$ and $h(x,y,z)=d$ in general will prove difficult. The easy case would be it the two equations were linear, in which case they would describe planes. Two non-parallel planes would intersect in a line. If the general case, imagine the surfaces locally replaced by their tangent planes, then their intersection would be a line, and this line would point in along the curve given by the intersection of the surfaces formed by the contraints. This line is similar to the tangent line in the $2$-variable case. Now if $\nabla{f}$, which points in the direction of greatest increase of $f$, had a non-zero projection onto this line, then moving the point in that direction along the line would increase $f$ and still leave the point following the contraints. That is, if there is a non-zero directional derivative the point is not a maximum.
"""

# ╔═╡ ccdce39e-7b01-11ec-3126-5321a08caaf2
md"""The tangent planes are *orthogonal* to the vectors $\nabla{g}$ and $\nabla{h}$, so in this case parallel to $\nabla{g} \times \nabla{h}$. The condition that $\nabla{f}$ be *orthogonal* to this vector, means that $\nabla{f}$ *must* sit in the plane described by $\nabla{g}$ and $\nabla{h}$ - the plane of orthogonal vectors to $\nabla{g} \times \nabla{h}$. That is, this condition is needed:
"""

# ╔═╡ ccdce3b2-7b01-11ec-1198-af88c9c7d928
md"""```math
\nabla{f}(x,y,z) = \lambda_1 \nabla{g}(x,y,z) + \lambda_2 \nabla{h}(x,y,z).
```
"""

# ╔═╡ ccdce3c6-7b01-11ec-069b-dd5556718c63
md"""At a point satisfying the above, we would have the tangent "plane" of $f$ is contained in the intersection of the tangent "plane"s to $g$ and $h$.
"""

# ╔═╡ ccdce3d0-7b01-11ec-097c-ab35e7a0c439
md"""---
"""

# ╔═╡ ccdce3e4-7b01-11ec-219b-079e0d05e444
md"""Consider a curve given through the intersection of two expressions: $g_1(x,y,z) = x^2 + y^2 - z^2 = 0$ and $g_2(x,y,z) = x - 2z = 3$. What is the minimum distance to the origin along this curve?
"""

# ╔═╡ ccdce3f8-7b01-11ec-1cdb-3d9374e96581
md"""We have $f(x,y,z) = \text{distance}(\vec{x},\vec{0}) = \sqrt{x^2 + y^2 + z^2}$, subject to the two constraints. As the square root is increasing, we can actually just consider $f(x,y,z) = x^2 + y^2 + z^2$, ignoring the square root. The Lagrange multiplier technique instructs us to look for solutions to:
"""

# ╔═╡ ccdce40a-7b01-11ec-1ce2-f777e260bff3
md"""```math
\langle 2x, 2y ,2x \rangle = \lambda_1\langle 2x, 2y, -2z\rangle + \lambda_2 \langle 1, 0, -2 \rangle.
```
"""

# ╔═╡ ccdce420-7b01-11ec-0581-f774c09d10fc
md"""Here we use `SymPy`:
"""

# ╔═╡ ccdce874-7b01-11ec-2dcf-85a0a19ac369
md"""Before trying to solve for $\nabla{L} = \vec{0}$ we see from the second equation that *either* $\lambda_1 = 1$ or $y = 0$. First we solve with $\lambda_1 = 1$:
"""

# ╔═╡ ccdcec68-7b01-11ec-252d-2d414e16b6be
md"""There are no real solutions. Next when $y = 0$ we get:
"""

# ╔═╡ ccdcf00a-7b01-11ec-1f73-bff671d69569
md"""The two solutions have values  yielding the extrema:
"""

# ╔═╡ ccdcf454-7b01-11ec-09e2-238117483271
md"""## Taylor's theorem
"""

# ╔═╡ ccdcf47e-7b01-11ec-0c56-fddb443a51ed
md"""Taylor's theorem for a univariate function states that if $f$ has $k+1$ derivatives in an open interval around $a$, $f^{(k)}$ is continuous between the closed interval from $a$ to $x$ then:
"""

# ╔═╡ ccdcf492-7b01-11ec-349b-d5bd28e16c95
md"""```math
f(x) = \sum_{j=0}^k \frac{f^{j}(a)}{j!} (x-a)^k + R_k(x),
```
"""

# ╔═╡ ccdcf4a6-7b01-11ec-3b11-9552a549fa33
md"""where $R_k(x) = f^{k+1}(\xi)/(k+1)!(x-a)^{k+1}$ for some $\xi$ between $a$ and $x$.
"""

# ╔═╡ ccdcf4d8-7b01-11ec-13e0-f95e946795f6
md"""This theorem can be generalized to scalar functions, but the notation can be cumbersome. Following [Folland](https://sites.math.washington.edu/~folland/Math425/taylor2.pdf) we use *multi-index* notation. Suppose $f:R^n \rightarrow R$, and let $\alpha=(\alpha_1, \alpha_2, \dots, \alpha_n)$. Then define the following notation:
"""

# ╔═╡ ccdcf4e2-7b01-11ec-1815-1d70f2d3cda9
md"""```math
|\alpha| = \alpha_1 + \cdots + \alpha_n, \quad
\alpha! = \alpha_1!\alpha_2!\cdot\cdots\cdot\alpha_n!,\quad
\vec{x}^\alpha = x_1^{\alpha_1}x_2^{\alpha_2}\cdots x_n^{\alpha^n}, \quad
\partial^\alpha f = \partial_1^{\alpha_1}\partial_2^{\alpha_2}\cdots \partial_n^{\alpha_n} f =
\frac{\partial^{|\alpha|}f}{\partial x_1^{\alpha_1} \partial x_2^{\alpha_2} \cdots \partial x_n^{\alpha_n}}.
```
"""

# ╔═╡ ccdcf4ec-7b01-11ec-2fa2-a745df6efd6c
md"""This notation makes many formulas from one dimension carry over to higher dimensions. For example, the binomial theorem says:
"""

# ╔═╡ ccdcf4f6-7b01-11ec-070d-f540bfe5775d
md"""```math
(a+b)^n = \sum_{k=0}^n \frac{n!}{k!(n-k)!}a^kb^{n-k},
```
"""

# ╔═╡ ccdcf500-7b01-11ec-2da3-d5a8b30f998d
md"""and this becomes:
"""

# ╔═╡ ccdcf50a-7b01-11ec-1456-5340b0765f51
md"""```math
(x_1 + x_2 + \cdots + x_n)^n = \sum_{|\alpha|=k} \frac{k!}{\alpha!} \vec{x}^\alpha.
```
"""

# ╔═╡ ccdcf514-7b01-11ec-3333-a783a4515d9c
md"""Taylor's theorem then becomes:
"""

# ╔═╡ ccdcf532-7b01-11ec-27c5-3d32ce69bab8
md"""If $f: R^n \rightarrow R$ is sufficiently smooth ($C^{k+1}$) on an open convex set $S$ about $\vec{a}$ then if $\vec{a}$ and $\vec{a}+\vec{h}$ are in $S$,
"""

# ╔═╡ ccdcf546-7b01-11ec-3fb9-7f0ea3060420
md"""```math
f(\vec{a} + \vec{h}) = \sum_{|\alpha| \leq k}\frac{\partial^\alpha f(\vec{a})}{\alpha!}\vec{h}^\alpha + R_{\vec{a},k}(\vec{h}),
```
"""

# ╔═╡ ccdcf55c-7b01-11ec-1e03-af39102f1188
md"""where $R_{\vec{a},k} = \sum_{|\alpha|=k+1}\partial^\alpha \frac{f(\vec{a} + c\vec{h})}{\alpha!} \vec{h}^\alpha$ for some $c$ in $(0,1)$.
"""

# ╔═╡ ccdcf56e-7b01-11ec-0c8a-7f09f557a707
md"""##### Example
"""

# ╔═╡ ccdcf582-7b01-11ec-3112-6dedff75dcc8
md"""The elegant notation masks what can be complicated expressions. Consider the simple case $f:R^2 \rightarrow R$ and $k=2$. Then this says:
"""

# ╔═╡ ccdcf596-7b01-11ec-37d4-45c263fd8108
md"""```math
\begin{align*}
f(x + dx, y+dy) &= f(x, y) + \frac{\partial f}{\partial x} dx + \frac{\partial f}{\partial y} dy \\
&+ \frac{\partial^2 f}{\partial x^2} \frac{dx^2}{2} +  2\frac{\partial^2 f}{\partial x\partial y} \frac{dx dy}{2}\\
&+ \frac{\partial^2 f}{\partial y^2} \frac{dy^2}{2} + R_{\langle x, y \rangle, k}(\langle dx, dy \rangle).
\end{align*}
```
"""

# ╔═╡ ccdcf5aa-7b01-11ec-0db2-716ee5032f9b
md"""Using $\nabla$ and $H$ for the Hessian and $\vec{x} = \langle x, y \rangle$ and $d\vec{x} = \langle dx, dy \rangle$, this can be expressed as:
"""

# ╔═╡ ccdcf5b4-7b01-11ec-0b01-2faceddf0529
md"""```math
f(\vec{x} + d\vec{x}) = f(\vec{x}) + \nabla{f} \cdot d\vec{x} +  d\vec{x} \cdot (H d\vec{x}) +R_{\vec{x}, k}d\vec{x}.
```
"""

# ╔═╡ ccdcf5d2-7b01-11ec-08d6-d504903e3a73
md"""As for $R$, the full term involves terms for $\alpha = (3,0), (2,1), (1,2)$, and $(0,3)$. Using $\vec{a} = \langle x, y\rangle$ and $\vec{h}=\langle dx, dy\rangle$:
"""

# ╔═╡ ccdcf5dc-7b01-11ec-1b8b-1facadd304a6
md"""```math
\frac{\partial^3 f(\vec{a}+c\vec{h})}{\partial x^3} \frac{dx^3}{3!}+
\frac{\partial^3 f(\vec{a}+c\vec{h})}{\partial x^2\partial y} \frac{dx^2 dy}{2!1!} +
\frac{\partial^3 f(\vec{a}+c\vec{h})}{\partial x\partial y^2} \frac{dxdy^2}{1!2!} +
\frac{\partial^3 f(\vec{a}+c\vec{h})}{\partial y^3} \frac{dy^3}{3!}.
```
"""

# ╔═╡ ccdcf5ee-7b01-11ec-10df-a53b2ecb3a71
md"""The exact answer is usually not as useful as the bound: $|R| \leq M/(k+1)! \|\vec{h}\|^{k+1}$, for some finite constant $M$.
"""

# ╔═╡ ccdcf5fa-7b01-11ec-21e8-6dda5f940ba4
md"""##### Example
"""

# ╔═╡ ccdcf618-7b01-11ec-039d-e5d3fa81e94e
md"""We can encode multiindices using `SymPy`. The basic definitions are fairly straightforward using `zip` to pair variables with components of $\alpha$. We define a new type so that we can overload the familiar notation:
"""

# ╔═╡ ccdcfa96-7b01-11ec-0177-0ff189c4ec1a
begin
	struct MultiIndex
	  alpha::Vector{Int}
	  end
	Base.show(io::IO, α::MultiIndex) = println(io, "α = ($(join(α.alpha, ", ")))")
	
	## |α| = α_1 + ... + α_m
	Base.length(α::MultiIndex) = sum(α.alpha)
	
	## factorial(α) computes α!
	Base.factorial(α::MultiIndex) = prod(factorial(Sym(a)) for a in α.alpha)
	
	## x^α = x_1^α_1 * x_2^α^2 * ... * x_n^α_n
	import Base: ^
	^(x, α::MultiIndex) = prod(u^a for (u,a) in zip(x, α.alpha))
	
	## ∂^α(ex) = ∂_1^α_1 ∘ ∂_2^α_2 ∘ ... ∘ ∂_n^α_n (ex)
	partial(ex::SymPy.SymbolicObject, α::MultiIndex, vars=free_symbols(ex)) = diff(ex, zip(vars, α.alpha)...)
end

# ╔═╡ ccb60e18-7b01-11ec-2567-5f1d3a65f531
let
	f(x,y) = 6 - x^2 -y^2
	f(x)= f(x...)
	
	a,b = 1, -1/2
	
	
	# draw surface
	xr = 7/4
	xs = ys = range(-xr, xr, length=100)
	surface(xs, ys, f, legend=false)
	
	# visualize tangent plane as 3d polygon
	pt = [a,b]
	tplane(x) = f(pt) + gradient(f)(pt) ⋅ (x - [a,b])
	
	pts = [[a-1,b-1], [a+1, b-1], [a+1, b+1], [a-1, b+1], [a-1, b-1]]
	plot!(unzip([[pt..., tplane(pt)] for pt in pts])...)
	
	# plot paths in x and y direction through (a,b)
	γ_x(t) = pt + t*[1,0]
	γ_y(t) = pt + t*[0,1]
	
	plot_parametric!((-xr-a)..(xr-a), t -> [γ_x(t)..., (f∘γ_x)(t)],  linewidth=3)
	plot_parametric!((-xr-b)..(xr-b), t -> [γ_y(t)..., (f∘γ_y)(t)],  linewidth=3)
	
	# draw directional derivatives in 3d and normal
	pt = [a, b, f(a,b)]
	fx, fy = gradient(f)(a,b)
	arrow!(pt, [1, 0, fx], linewidth=3)
	arrow!(pt, [0, 1, fy], linewidth=3)
	arrow!(pt, [-fx, -fy, 1], linewidth=3) # normal
	
	# draw point in base, x-y, plane
	pt = [a, b, 0]
	scatter!(unzip([pt])...)
	arrow!(pt, [1,0,0], linestyle=:dash)
	arrow!(pt, [0,1,0], linestyle=:dash)
end

# ╔═╡ ccd2894e-7b01-11ec-3984-0bcb14cee7d5
let
	a,b = 1,3
	f(x,y,z) = (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3
	
	CalculusWithJulia.plot_implicit_surface(f, xlim=-2..2, ylim=-1..1, zlim=-1..2)
end

# ╔═╡ ccd3abee-7b01-11ec-0308-0db321f85afe
begin
	V(r, h) = pi * r^2 * h
	V(v) = V(v...)
	a₁ = [1,2]
	dx₁ = [0.01, 0.01]
	ForwardDiff.gradient(V, a₁) ⋅ dx₁   # or use ∇(V)(a)
end

# ╔═╡ ccd3af90-7b01-11ec-348d-55fbe0225230
V(a₁ + dx₁) - V(a₁)

# ╔═╡ ccd3b742-7b01-11ec-377c-2dabec7a7d8c
let
	f(x,y,z) = x^4 -x^3 + y^2 + z^2
	f(v) = f(v...)
	a, b,c = ∇(f)(2,2,2)
	"$a x + $b y  + $c z = $([a,b,c] ⋅ [2,2,2])"
end

# ╔═╡ ccd3c304-7b01-11ec-049e-0d2c982ac755
let
	f(x,y) = 2 - x^2 - y^2
	g(x,y) = 3 - 2x^2 - (1/3)y^2
	xs = ys = range(-3, stop=3, length=100)
	zfs = [f(x,y) for x in xs, y in ys]
	zgs = [g(x,y) for x in xs, y in ys]
	
	
	ps = Any[]
	pf = surface(xs, ys, f, alpha=0.5, legend=false)
	
	for cl in levels(contours(xs, ys, zfs, [0.0]))
	    for line in lines(cl)
	        _xs, _ys = coordinates(line)
	        plot!(pf, _xs, _ys, 0*_xs, linewidth=3, color=:blue)
	    end
	end
	
	
	pg = surface(xs, ys, g, alpha=0.5, legend=false)
	for cl in levels(contours(xs, ys, zgs, [0.0]))
	    for line in lines(cl)
	        _xs, _ys = coordinates(line)
	        plot!(pg, _xs, _ys, 0*_xs, linewidth=3, color=:red)
	    end
	end
	
	pcnt = plot(legend=false)
	for cl in levels(contours(xs, ys, zfs, [0.0]))
	    for line in lines(cl)
	        _xs, _ys = coordinates(line)
	        plot!(pcnt, _xs, _ys, linewidth=3, color=:blue)
	    end
	end
	
	for cl in levels(contours(xs, ys, zgs, [0.0]))
	    for line in lines(cl)
	        _xs, _ys = coordinates(line)
	        plot!(pcnt, _xs, _ys, linewidth=3, color=:red)
	    end
	end
	
	l = @layout([a b c])
	plot(pf, pg, pcnt, layout=l)
end

# ╔═╡ ccd3d326-7b01-11ec-0679-a14ceee75b80
begin
	𝒇(x,y) = 2 - x^2 - y^2
	𝒈(x,y) = 3 - 2x^2 - (1/3)y^2
	𝒇(v) = 𝒇(v...); 𝒈(v) = 𝒈(v...)
	𝒙₀ = [1,1]
	𝒙₁ = newton_step(𝒇, 𝒈, 𝒙₀)
end

# ╔═╡ ccd3d556-7b01-11ec-31a5-8f59f42424e4
𝒇(𝒙₁), 𝒈(𝒙₁)

# ╔═╡ ccd3d8c6-7b01-11ec-190b-8b2c8dfe260a
begin
	𝒙₂ = newton_step(𝒇, 𝒈, 𝒙₁)
	𝒙₃ = newton_step(𝒇, 𝒈, 𝒙₂)
	𝒙₄ = newton_step(𝒇, 𝒈, 𝒙₃)
	𝒙₅ = newton_step(𝒇, 𝒈, 𝒙₄)
	𝒙₅, 𝒇(𝒙₅), 𝒈(𝒙₅)
end

# ╔═╡ ccd3e406-7b01-11ec-23e2-b326a77b06a1
let
	c = 1/2
	f(x,y) = 1 - y^2 - c^2
	g(x,y) = (1 - x^2) - c^2
	f(v) = f(v...); g(v) = g(v...)
	nm(f, g, [1/2, 1/3])
end

# ╔═╡ ccd3e97e-7b01-11ec-0314-312b64d15864
let
	@syms x, y, Z()
	∂x = solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, x), diff(Z(x,y),x))
	∂y = solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, x), diff(Z(x,y),y))
	∂x, ∂y
end

# ╔═╡ ccd84d52-7b01-11ec-0258-5de2dffb6d57
let
	f(x,y)= exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
	xs = ys = range(-4, 4, length=100)
	surface(xs, ys, f, legend=false)
end

# ╔═╡ ccda4314-7b01-11ec-34e0-43c5ac6e0315
begin
	fₖ(x,y) =  exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
	Hₖ = sympy.hessian(fₖ(x,y), (x,y))
end

# ╔═╡ ccda47c4-7b01-11ec-25eb-1f1c187e275a
H₀₀ = subs.(Hₖ, x=>0, y=>0)

# ╔═╡ ccda4b98-7b01-11ec-116d-192a06a9f918
H₀₀[1,1] < 0 && det(H₀₀) > 0

# ╔═╡ ccda5052-7b01-11ec-203f-539f2bd26074
let
	gradfₖ = diff.(fₖ(x,y), [x,y])
	a = [sqrt(2PI + atan(-Sym(1)//5)), 0]
	subs.(gradfₖ, x => a[1], y => a[2])
end

# ╔═╡ ccda5750-7b01-11ec-2fea-4f06e29fa8ed
let
	a = [sqrt(PI + atan(-Sym(1)//5)), 0]
	H_a = subs.(Hₖ, x => a[1], y => a[2])
	det(H_a)
end

# ╔═╡ ccda5d90-7b01-11ec-1b6f-795a1bbce121
begin
	fⱼ(x,y) = 4x*y - x^4 - y^4
	gradfⱼ = diff.(fⱼ(x,y), [x,y])
end

# ╔═╡ ccda61aa-7b01-11ec-0b71-3f60977d0526
begin
	all_ptsⱼ = solve(gradfⱼ, [x,y])
	ptsⱼ = filter(u -> all(isreal.(u)), all_ptsⱼ)
end

# ╔═╡ ccda66b4-7b01-11ec-0a44-931f0e554766
begin
	Hⱼ = sympy.hessian(fⱼ(x,y), (x,y))
	function classify(H, pt)
	  Ha = subs.(H, x .=> pt[1], y .=> pt[2])
	  (det=det(Ha), f_xx=Ha[1,1])
	end
	[classify(Hⱼ, pt) for pt in ptsⱼ]
end

# ╔═╡ ccda6dda-7b01-11ec-0134-932190373aa0
let
	xs = ys = range(-3/2, 3/2, length=100)
	p = surface(xs, ys, fⱼ, legend=false)
	for pt ∈ ptsⱼ
	    scatter!(p, unzip([N.([pt...,fⱼ(pt...)])])...,
	             markercolor=:black, markersize=5)  # add each pt on surface
	end
	p
end

# ╔═╡ ccda7436-7b01-11ec-3c69-231ddf5abbfa
begin
	fₗ(x,y) = x^2 + 2y^2 - x
	fₗ(v) = fₗ(v...)
	gammaₗ(t) = [cos(t), sin(t)]  # traces out x^2 + y^2 = 1 over [0, 2pi]
	gₗ = fₗ ∘ gammaₗ
	
	cpsₗ = find_zeros(gₗ', 0, 2pi) # critical points of g
	append!(cpsₗ, [0, 2pi])
	unique!(cpsₗ)
	gₗ.(cpsₗ)
end

# ╔═╡ ccda77ee-7b01-11ec-03d0-553a79305526
begin
	inds = [2,4]
	cpsₗ[inds]
end

# ╔═╡ ccda79ba-7b01-11ec-2792-bb09115379da
cpsₗ[inds]/pi

# ╔═╡ ccda7fbe-7b01-11ec-3d65-6163ff0ceeaf
hₗ(x,y) = fₗ(x,y) * (x^2 + y^2 <= 1 ? 1 : NaN)

# ╔═╡ ccda8540-7b01-11ec-24ba-35726caf2a15
let
	xs = ys = range(-1,1, length=100)
	surface(xs, ys, hₗ)
	
	ts = cpsₗ  # 2pi/3 and 4pi/3 by above
	xs, ys = cos.(ts), sin.(ts)
	scatter!(xs, ys, fₗ)
end

# ╔═╡ ccda8acc-7b01-11ec-0f71-ad16198e906e
let
	xs = ys = range(-1,1, length=100)
	contour(xs, ys, hₗ)
end

# ╔═╡ ccda906c-7b01-11ec-090e-03bff8206f02
begin
	@syms x1 y1 x2 y2 x3 y3
	d2(p,x) = (p[1] - x[1])^2 + (p[2]-x[2])^2
	d2_1, d2_2, d2_3 = d2((x,y), (x1, y1)), d2((x,y), (x2, y2)), d2((x,y), (x3, y3))
	exₛ = d2_1 + d2_2 + d2_3
end

# ╔═╡ ccda946a-7b01-11ec-21b1-334475dee6f9
begin
	gradfₛ = diff.(exₛ, [x,y])
	xstarₛ = solve(gradfₛ, [x,y])
end

# ╔═╡ ccda99ea-7b01-11ec-0182-6dd109189698
Hₛ = subs.(hessian(exₛ, [x,y]), x=>xstarₛ[x], y=>xstarₛ[y])

# ╔═╡ ccdac238-7b01-11ec-1382-c1dad589c888
begin
	@syms xₗₛ[1:3] yₗₛ[1:3] α β
	li(x, alpha, beta) =  alpha + beta * x
	d₂(alpha, beta) = sum((y - li(x, alpha, beta))^2 for (y,x) in zip(yₗₛ, xₗₛ))
	d₂(α, β)
end

# ╔═╡ ccdac5be-7b01-11ec-22fc-81790f2b7745
grad_d₂ = diff.(d₂(α, β), [α, β])

# ╔═╡ ccdac816-7b01-11ec-17b8-a9ea02c5b8bc
outₗₛ = solve(grad_d₂, [α, β])

# ╔═╡ ccdacb40-7b01-11ec-3b80-89e6659e0411
subs(outₗₛ[β], sum(xₗₛ) => 0)

# ╔═╡ ccdad82e-7b01-11ec-2f33-e786b861fc4d
[k => subs(v, xₗₛ[1]=>1, yₗₛ[1]=>1, xₗₛ[2]=>2, yₗₛ[2]=>3,
           xₗₛ[3]=>5, yₗₛ[3]=>8) for (k,v) in outₗₛ]

# ╔═╡ ccdae1b6-7b01-11ec-3c88-d135edc1745b
begin
	f₂(x,y) = -exp(-((x-1)^2 + 2(y-1/2)^2))
	f₂(x) = f₂(x...)
	
	xs₂ = [[0.0, 0.0]] # we store a vector
	gammas₂ = [1.0]
	
	for n in 1:5
	    xn = xs₂[end]
	    gamma = gammas₂[end]
	    xn1 = xn - gamma * gradient(f₂)(xn)
	    dx, dy = xn1 - xn, gradient(f₂)(xn1) - gradient(f₂)(xn)
	    gamman1 = abs( (dx ⋅ dy) / (dy ⋅ dy) )
	
	    push!(xs₂, xn1)
	    push!(gammas₂, gamman1)
	end
	
	[(x, f₂(x)) for x in xs₂]
end

# ╔═╡ ccdaf8c2-7b01-11ec-3a1a-19398ac8ecd7
let
	function surface_contour(xs, ys, f; offset=0)
	  p = surface(xs, ys, f, legend=false, fillalpha=0.5)
	
	  ## we add to the graphic p, then plot
	  zs = [f(x,y) for x in xs, y in ys]  # reverse order for use with Contour package
	  for cl in levels(contours(xs, ys, zs))
	    lvl = level(cl) # the z-value of this contour level
	    for line in lines(cl)
	        _xs, _ys = coordinates(line) # coordinates of this line segment
	        _zs = offset * _xs
	        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add curve on x-y plane
	    end
	  end
	  p
	end
	
	
	offset = 0
	us = vs = range(-1, 2, length=100)
	surface_contour(vs, vs, f₂, offset=offset)
	pts = [[pt..., offset] for pt in xs₂]
	scatter!(unzip(pts)...)
	plot!(unzip(pts)..., linewidth=3)
end

# ╔═╡ ccdb0e48-7b01-11ec-0a32-31a0f957244c
begin
	function peaks(x, y)
	    z = 3 * (1 - x)^2 * exp(-x^2 - (y + 1)^2)
	    z += -10 * (x / 5 - x^3 - y^5) * exp(-x^2 - y^2)
	    z += -1/3 * exp(-(x+1)^2 - y^2)
	    return z
	end
	peaks(v) = peaks(v...)
end

# ╔═╡ ccdb141a-7b01-11ec-23e2-2be1ba6ab8e0
let
	xs = range(-3, stop=3, length=100)
	ys = range(-2, stop=2, length=100)
	Ps = surface(xs, ys, peaks, legend=false)
	Pc = contour(xs, ys, peaks, legend=false)
	plot(Ps, Pc, layout=2) # combine plots
end

# ╔═╡ ccdb1dde-7b01-11ec-1d03-c765a8427a5e
begin
	xₚ = [0, 1.5]
	xₚ = newton_stepₚ(peaks, xₚ)
	xₚ = newton_stepₚ(peaks, xₚ)
	xₚ = newton_stepₚ(peaks, xₚ)
	xₚ, ForwardDiff.gradient(peaks, xₚ)
end

# ╔═╡ ccdb1ff0-7b01-11ec-2f0b-41f75f160197
Hₚ = ForwardDiff.hessian(peaks, xₚ)

# ╔═╡ ccdb23b0-7b01-11ec-3916-815750aa608f
let
	fxx = Hₚ[1,1]
	d = det(Hₚ)
	fxx, d
end

# ╔═╡ ccdb2f90-7b01-11ec-2ba0-974886636af9
let
	g(x,y) = x^2 + 2y^2 -1
	g(v) = g(v...)
	
	xs = range(-3, 3, length=100)
	ys = range(-1, 4, length=100)
	
	p = plot(aspect_ratio=:equal, legend=false)
	contour!(xs, ys, g, levels=[0])
	
	gi(x) = sqrt(1/2*(1-x^2)) # solve for y in terms of x
	pts = [[x, gi(x)] for x in (-3/4, -1/4, 1/4, 3/4)]
	
	for pt in pts
	  arrow!(pt, ForwardDiff.gradient(g, pt) )
	end
	
	p
end

# ╔═╡ ccdb3544-7b01-11ec-236c-1b42cbd72904
let
	r(t) = [cos(t), sin(t)/2]
	plot_parametric(pi/12..pi/3, r, legend=false, aspect_ratio=true, linewidth=3)
	T(t) = -r'(t) / norm(r'(t))
	No(t) = T'(t) / norm(T'(t))
	t = pi/4
	lambda=1/10
	scatter!(unzip([r(t)])...)
	arrow!(r(t), T(t)*lambda)
	arrow!(r(t), No(t)* lambda)
	
	f(x,y)= x^2 + y^2
	f(v) = f(v...)
	arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))
	
	xs = range(0.5,1, length=100)
	ys = range(0.1, 0.5, length=100)
	contour!(xs, ys, f)
end

# ╔═╡ ccdb3aee-7b01-11ec-3aa2-495b8b9c8559
let
	r(t) = [cos(t), sin(t)/2]
	plot_parametric(-pi/6..pi/6,r, legend=false, aspect_ratio=true, linewidth=3)
	T(t) = -r'(t) / norm(r'(t))
	No(t) = T'(t) / norm(T'(t))
	t = 0
	lambda=1/10
	scatter!(unzip([r(t)])...)
	arrow!(r(t), T(t)*lambda)
	arrow!(r(t), No(t)* lambda)
	
	f(x,y)= x^2 + y^2
	f(v) = f(v...)
	arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))
	
	xs = range(0.5,1.5, length=100)
	ys = range(-0.5, 0.5, length=100)
	contour!(xs, ys, f,  levels = [.7, .85, 1, 1.15, 1.3])
end

# ╔═╡ ccdcd2c8-7b01-11ec-10c8-0938c7637c48
begin
	@syms lambda
	fₗₐ(x, y) = x^2 - y^2
	gₗₐ(x, y) = x^2 + y^2
	Lₗₐ(x, y, lambda) = fₗₐ(x,y) - lambda * (gₗₐ(x,y) - 1)
	dsₗₐ = solve(diff.(Lₗₐ(x, y, lambda), [x, y, lambda]))
end

# ╔═╡ ccdcd7b4-7b01-11ec-24a2-35719d4e2e7a
[fₗₐ(d[x], d[y]) for d in dsₗₐ]

# ╔═╡ ccdce236-7b01-11ec-0d1a-1527e5efeb1a
let
	@vars y y′ λ C
	ex = Eq(-λ*y′^2/sqrt(1 + y′^2) + λ*sqrt(1 + y′^2), C + y)
	Δ = sqrt(1 + y′^2) / (C+y)
	ex1 = Eq(simplify(ex.lhs()*Δ), simplify(ex.rhs() * Δ))
	ex2 = Eq(ex1.lhs()^2 - 1, simplify(ex1.rhs()^2) - 1)
end

# ╔═╡ ccdce842-7b01-11ec-227f-c94a522af36a
begin
	@syms z lambda1 lambda2
	g1(x, y, z) = x^2 + y^2 - z^2
	g2(x, y, z) = x - 2z - 3
	fₘ(x,y,z)= x^2 + y^2 + z^2
	Lₘ(x,y,z,lambda1, lambda2) = fₘ(x,y,z) - lambda1*(g1(x,y,z) - 0) - lambda2*(g2(x,y,z) - 0)
	
	∇Lₘ = diff.(Lₘ(x,y,z,lambda1, lambda2), [x, y, z,lambda1, lambda2])
end

# ╔═╡ ccdcec48-7b01-11ec-3c72-23419b4c6f6d
solve(subs.(∇Lₘ, lambda1 .=> 1))

# ╔═╡ ccdcefee-7b01-11ec-18b8-a59858683dd3
outₘ = solve(subs.(∇Lₘ, y .=> 0))

# ╔═╡ ccdcf426-7b01-11ec-14e3-71c0daf794c7
[fₘ(d[x], 0, d[z]) for d in outₘ]

# ╔═╡ ccdcfdc0-7b01-11ec-3ca3-4b773c9cf70e
md"""The remainder term needs to know information about sets like $|\alpha| =k$. This is a combinatoric problem, even to identify the length. Here we define an iterator to iterate over all possible MultiIndexes. This is low level, and likely could be done in a much better style, so shouldn't be parsed unless there is curiosity. It manually chains together iterators.
"""

# ╔═╡ ccdd0232-7b01-11ec-1017-63314be3601d
begin
	struct MultiIndices
	    n::Int
	    k::Int
	end
	
	function Base.length(as::MultiIndices)
	  n,k = as.n, as.k
	  n == 1 && return 1
	  sum(length(MultiIndices(n-1, j)) for j in 0:k)  # recursively identify length
	end
	
	function Base.iterate(alphas::MultiIndices)
	    k, n = alphas.k, alphas.n
	    n == 1 && return ([k],(0, MultiIndices(0,0), nothing))
	
	    m = zeros(Int, n)
	    m[1] = k
	    betas = MultiIndices(n-1, 0)
	    stb = iterate(betas)
	    st = (k, MultiIndices(n-1, 0), stb)
	    return (m, st)
	end
	
	function Base.iterate(alphas::MultiIndices, st)
	
	    st == nothing && return nothing
	    k,n = alphas.k, alphas.n
	    k == 0 && return nothing
	    n == 1 && return nothing
	
	    # can we iterate the next on
	    bk, bs, stb = st
	
	    if stb==nothing
	        bk = bk-1
	        bk < 0 && return nothing
	        bs = MultiIndices(bs.n, bs.k+1)
	        val, stb = iterate(bs)
	        return (vcat(bk,val), (bk, bs, stb))
	    end
	
	    resp = iterate(bs, stb)
	    if resp == nothing
	        bk = bk-1
	        bk < 0 && return nothing
	        bs = MultiIndices(bs.n, bs.k+1)
	        val, stb = iterate(bs)
	        return (vcat(bk, val), (bk, bs, stb))
	    end
	
	    val, stb = resp
	    return (vcat(bk, val), (bk, bs, stb))
	
	end
end

# ╔═╡ ccdcfda2-7b01-11ec-2dd0-9b652a46434a
begin
	@syms w
	alpha = MultiIndex([1,2,1,3])
	length(alpha)  # 1 + 2 + 1 + 3=7
	[1,2,3,4]^alpha
	exₜ = x^3 * cos(w*y*z)
	partial(exₜ, alpha, [w,x,y,z])
end

# ╔═╡ ccdd025c-7b01-11ec-1fb8-557be300d1d3
md"""This returns a vector, not a `MultiIndex`. Here we get all multiindices in two variables of size $3$
"""

# ╔═╡ ccdd04aa-7b01-11ec-3025-93ba3d9e6784
collect(MultiIndices(2, 3))

# ╔═╡ ccdd04c8-7b01-11ec-272e-4b8a4832740b
md"""To get all of size $3$ or less, we could do something like this:
"""

# ╔═╡ ccdd09de-7b01-11ec-2469-d755778d2423
union((collect(MultiIndices(2, i)) for i in 0:3)...)

# ╔═╡ ccdd0a04-7b01-11ec-199c-d7f40322ebc0
md"""To see the computational complexity. Suppose we had $3$ variables and were interested in the error for order $4$:
"""

# ╔═╡ ccdd0d06-7b01-11ec-28a6-db7e307890c6
begin
	k = 4
	length(MultiIndices(3, k+1))
end

# ╔═╡ ccdd0d2e-7b01-11ec-28d2-3f6935dc9f43
md"""Finally, to see how compact the notation issue, suppose $f:R^3 \rightarrow R$, we have the third-order Taylor series expands to $20$ terms as follows:
"""

# ╔═╡ ccdd142c-7b01-11ec-2b62-ffd35e8034fb
let
	@syms F() a[1:3] dx[1:3]
	
	sum(partial(F(a...), α, a) / factorial(α) * dx^α for k in 0:3 for α in MultiIndex.(MultiIndices(3, k)))  # 3rd order
end

# ╔═╡ ccdd1448-7b01-11ec-28f6-a1ae2341df70
md"""## Questions
"""

# ╔═╡ ccdfa8ec-7b01-11ec-3b7f-77ce20ffeaba
md"""###### Question
"""

# ╔═╡ ccdfa962-7b01-11ec-102b-7fd3f994b1e7
md"""Let $f(x,y) = \sqrt{x + y}$. Find the tangent plane approximation for $f(2.1, 2.2)$?
"""

# ╔═╡ ccdfb0a6-7b01-11ec-0d32-cb22b57a2373
let
	f(x,y) = sqrt(x + y)
	f(v) = f(v...)
	pt = [2,2]
	dxdy = [.1, .2]
	val = f(pt) + dot(ForwardDiff.gradient(f, pt), dxdy)
	numericq(val)
end

# ╔═╡ ccdfb0ce-7b01-11ec-3246-19a2090f05b9
md"""###### Question
"""

# ╔═╡ ccdfb100-7b01-11ec-1c76-376befdb4ab6
md"""Let $f(x,y,z) = xy + yz + zx$. Using a *linear approximation* estimate $f(1.1, 1.0, 0.9)$.
"""

# ╔═╡ ccdfb650-7b01-11ec-3b37-cff5529810dc
let
	f(x,y,z) = x*y + y*z + z*x
	f(v) = f(v...)
	pt = [1,1,1]
	dx = [0.1, 0.0, -0.1]
	val = f(pt) + ∇(f)(pt) ⋅ dx
	numericq(val)
end

# ╔═╡ ccdfb666-7b01-11ec-11e5-ab85032818e4
md"""###### Question
"""

# ╔═╡ ccdfb682-7b01-11ec-242a-fddc5899cb0d
md"""Let $f(x,y,z) = xy + yz + zx - 3$. What equation describes the tangent approximation at $(1,1,1)$?
"""

# ╔═╡ ccdfbc34-7b01-11ec-3f19-0990d4e6e5fd
let
	f(x,y,z) = x*y + y*z + z*x - 8
	f(v) = f(v...)
	pt = [1,1,1]
	n = ∇(f)(pt)
	d = dot(n, pt)
	choices = [
	    raw"`` x + y + z = 3``",
	    raw"`` 2x + y - 2z = 1``",
	    raw"`` x + 2y + 3z = 6``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ ccdfbc54-7b01-11ec-2d6d-2d2a020bcccf
md"""###### Question
"""

# ╔═╡ ccdfbc7c-7b01-11ec-0c83-bd478a7af174
md"""([Knill](http://www.math.harvard.edu/~knill/teaching/summer2018/handouts/week4.pdf)) Let $f(x,y) = xy + x^2y + xy^2$.
"""

# ╔═╡ ccdfbc90-7b01-11ec-1056-ef445dcb7b3e
md"""Find the gradient of $f$:
"""

# ╔═╡ ccdfc4ba-7b01-11ec-02da-29e130ce07a4
let
	choices = [
	    raw"`` \langle 2xy + y^2 + y, 2xy + x^2 + x\rangle``",
	    raw"`` y^2 + y, x^2 + x``",
	    raw"`` \langle 2y + y^2, 2x + x^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ ccdfc4d6-7b01-11ec-3a9b-bd4cebfdd78d
md"""Is this the Hessian of $f$?
"""

# ╔═╡ ccdfc4f6-7b01-11ec-3c0b-21213fbeed2e
md"""```math
\left[\begin{matrix}2 y & 2 x + 2 y + 1\\2 x + 2 y + 1 & 2 x\end{matrix}\right]
```
"""

# ╔═╡ ccdfc6c2-7b01-11ec-2606-7f428a1bcd7b
let
	yesnoq(true)
end

# ╔═╡ ccdfc6f4-7b01-11ec-1e6d-637753ab908e
md"""The point $(-1/3, -1/3)$ is a solution to the $\nabla{f} = 0$. What is the *determinant*, $d$, of the Hessian at this point?
"""

# ╔═╡ ccdfcce2-7b01-11ec-2169-5fb49952b07d
let
	f(x,y) = x*y + x*y^2 + x^2 * y
	f(v) = f(v...)
	val = det(ForwardDiff.hessian(f, [-1/3, -1/3]))
	numericq(val)
end

# ╔═╡ ccdfcd0c-7b01-11ec-0743-d1e8951692a0
md"""Which is true of $f$ at $(-1/3, 1/3)$:
"""

# ╔═╡ ccdfd842-7b01-11ec-0845-4794aa63ac65
let
	choices = [
	    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
	    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
	    L"The function $f$ has a saddle point, as $d  < 0$",
	    L"Nothing can be said, as $d=0$"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ ccdfd874-7b01-11ec-1690-33f9586c4441
md"""##### Question
"""

# ╔═╡ ccdfd8a6-7b01-11ec-1495-11b56c187dfc
md"""([Knill](http://www.math.harvard.edu/~knill/teaching/summer2018/handouts/week4.pdf)) Let the Tutte polynomial be $f(x,y) = x + 2x^2 + x^3 + y + 2xy + y^2$.
"""

# ╔═╡ ccdfd8ba-7b01-11ec-30c6-cd4d0a5f6360
md"""Does this accurately find the gradient of $f$?
"""

# ╔═╡ ccdfdff4-7b01-11ec-0ae3-bb43b788d556
let
	f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
	@syms x::real y::real
	gradf = gradient(f(x,y), [x,y])
end

# ╔═╡ ccdfe17a-7b01-11ec-3604-e71f357db597
let
	yesnoq(true)
end

# ╔═╡ ccdfe1a2-7b01-11ec-110f-d7bfcdafdb19
md"""How many answers does this find to $\nabla{f} = \vec{0}$?
"""

# ╔═╡ ccdfe8be-7b01-11ec-0bfe-c13bd86be184
let
	f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
	@syms x::real y::real
	gradf = gradient(f(x,y), [x,y])
	
	solve(gradf, [x,y])
end

# ╔═╡ ccdfea46-7b01-11ec-2e8c-c5f38d20311c
let
	numericq(2)
end

# ╔═╡ ccdfea58-7b01-11ec-378b-d336757cec05
md"""The Hessian is found by
"""

# ╔═╡ ccdff16a-7b01-11ec-317a-b9387e9bda59
let
	f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
	@syms x::real y::real
	gradf = gradient(f(x,y), [x,y])
	
	sympy.hessian(f(x,y), [x,y])
end

# ╔═╡ ccdff188-7b01-11ec-10d1-2d6da884e389
md"""Which is true of $f$ at $(-1/3, 1/3)$:
"""

# ╔═╡ ccdffee4-7b01-11ec-27c6-95485dbf0625
let
	choices = [
	    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
	    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
	    L"The function $f$ has a saddle point, as $d  < 0$",
	    L"Nothing can be said, as $d=0$",
	    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ ccdfff0c-7b01-11ec-0237-fb2160f55ae7
md"""Which is true of $f$ at $(0, -1/2)$:
"""

# ╔═╡ cce00cae-7b01-11ec-3d17-a77ca80857d3
let
	choices = [
	    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
	    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
	    L"The function $f$ has a saddle point, as $d  < 0$",
	    L"Nothing can be said, as $d=0$",
	    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ cce00cd8-7b01-11ec-224f-e94e5fbba22f
md"""Which is true of $f$ at $(1/2, 0)$:
"""

# ╔═╡ cce01a32-7b01-11ec-2754-733879808484
let
	choices = [
	    L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
	    L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
	    L"The function $f$ has a saddle point, as $d  < 0$",
	    L"Nothing can be said, as $d=0$",
	    L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
	]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ cce01a46-7b01-11ec-346c-3d47dc10af70
md"""###### Question
"""

# ╔═╡ cce01a6e-7b01-11ec-1e7e-5b0287d1e4d1
md"""(Strang p509) Consider the quadratic function $f(x,y) = ax^2 + bxy +cy^2$. Since the second partial derivative test is essentially done by replacing the function at a critical point by a quadratic function, understanding this $f$ is of some interest.
"""

# ╔═╡ cce01a84-7b01-11ec-0a12-7d1a1d7b53c8
md"""Is this the Hessian of $f$?
"""

# ╔═╡ cce01aa0-7b01-11ec-2b2f-a3f82ae3c7d8
md"""```math
\left[
\begin{array}{}
2a & 2b\\
2b  & 2c
\end{array}
\right]
```
"""

# ╔═╡ cce01c26-7b01-11ec-2ddc-bfa6144f63c8
let
	yesnoq(true)
end

# ╔═╡ cce01c44-7b01-11ec-12ef-b162a7bfa736
md"""Or is this the Hessian of $f$?
"""

# ╔═╡ cce01c4c-7b01-11ec-053c-dfc259fa586a
md"""```math
\left[
\begin{array}{}
2ax & by\\
bx  & 2cy
\end{array}
\right]
```
"""

# ╔═╡ cce01db4-7b01-11ec-1868-cbdd68e35019
let
	yesnoq(false)
end

# ╔═╡ cce01dd4-7b01-11ec-1b68-21541f35f47d
md"""Explain why $ac - b^2$ is of any interest here:
"""

# ╔═╡ cce024aa-7b01-11ec-2f0a-578cf8b8d372
let
	choices =[
	    "It is the determinant of the Hessian",
	    L"It isn't, $b^2-4ac$ is from the quadratic formula"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ cce024dc-7b01-11ec-0e00-d99e79259518
md"""Which condition on $a$, $b$, and $c$ will ensure a *local maximum*:
"""

# ╔═╡ cce02b92-7b01-11ec-23a4-ebe76effd32b
let
	choices = [
	    L"That $a>0$ and $ac-b^2 > 0$",
	    L"That $a<0$ and $ac-b^2 > 0$",
	    L"That $ac-b^2 < 0$"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ cce02bbc-7b01-11ec-13d6-85686f5600f8
md"""Which condition on $a$, $b$, and $c$ will ensure a saddle point?
"""

# ╔═╡ cce0329a-7b01-11ec-1d8e-afba06ad2dea
let
	choices = [
	    L"That $a>0$ and $ac-b^2 > 0$",
	    L"That $a<0$ and $ac-b^2 > 0$",
	    L"That $ac-b^2 < 0$"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ cce032b0-7b01-11ec-3efb-fd665c4720eb
md"""###### Question
"""

# ╔═╡ cce032ce-7b01-11ec-2618-93a94142a188
md"""Let $f(x,y) = e^{-x^2 - y^2} (2x^2 + y^2)$. Use Lagrange's method to find the absolute maximum and absolute minimum over $x^2 + y^2 = 3$.
"""

# ╔═╡ cce032e2-7b01-11ec-2957-fb6c9818ff1c
md"""Is $\nabla{f}$ given by the following?
"""

# ╔═╡ cce032f6-7b01-11ec-3a50-3f7cdac7541d
md"""```math
\nabla{f} =2 e^{-x^2 - y^2} \langle x(2 - 2x^2 - y^2), y(1 - 2x^2 - y^2)\rangle.
```
"""

# ╔═╡ cce03468-7b01-11ec-33c1-039867e36aed
let
	yesnoq(true)
end

# ╔═╡ cce03486-7b01-11ec-126d-b70d5a109ea2
md"""Which vector is orthogonal to the contour line $x^2 + y^2 = 3$?
"""

# ╔═╡ cce03b8e-7b01-11ec-113f-150b1cdbd17e
let
	choices = [
	    raw"`` \langle 2x, 2y\rangle``",
	    raw"`` \langle 2x, y^2\rangle``",
	    raw"`` \langle x^2, 2y \rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ cce03bb6-7b01-11ec-05a9-0133ebe62c71
md"""Due to the form of the gradient of the constraint, finding when $\nabla{f} = \lambda \nabla{g}$ is the same as identifying when this ratio $|f_x/f_y|$ is $1$. The following solves for this by checking each point on the constraint:
"""

# ╔═╡ cce04390-7b01-11ec-3cf8-4f8554775232
let
	f(x,y) = exp(-x^2-y^2) * (2x^2 + y^2)
	f(v) = f(v...)
	r(t) = 3*[cos(t), sin(t)]
	rat(x) = abs(x[1]/x[2]) - 1
	fn = rat ∘ ∇(f) ∘ r
	ts = fzeros(fn, 0, 2pi)
end

# ╔═╡ cce043a4-7b01-11ec-38d1-2fb85748fbb2
md"""Using these points, what is the largest value on the boundary?
"""

# ╔═╡ cce04b2e-7b01-11ec-1055-cd6d1434ccfb
let
	f(x,y) = exp(-x^2-y^2) * (2x^2 + y^2)
	f(v) = f(v...)
	r(t) = 3*[cos(t), sin(t)]
	rat(x) = abs(x[1]/x[2]) - 1
	fn = rat ∘ ∇(f) ∘ r
	ts = fzeros(fn, 0, 2pi)
	
	val = maximum((f∘r).(ts))
	numericq(val)
end

# ╔═╡ cce04b4c-7b01-11ec-0a30-1f5bde9d709a
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/scalar_functions.html">◅ previous</a>  <a href="../differentiable_vector_calculus/vector_fields.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/scalar_functions_applications.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ cce04b54-7b01-11ec-1232-6d4c8e9ee1fb
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Contour = "d38c429a-6771-53c6-b99e-75d170b6e991"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
Contour = "~0.5.7"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
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
git-tree-sha1 = "54fc4400de6e5c3e27be6047da2ef6ba355511f8"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.6"

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
git-tree-sha1 = "6f1b25e8ea06279b5689263cc538f51331d7ca17"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.3"

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
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "b4912cd034cdf968e06ca5f943bb54b17b97793a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.5.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2884859916598f974858ff01df7dfc6c708dd895"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.3"

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
# ╟─cce04b38-7b01-11ec-3c7d-91dea3ee299c
# ╟─cc9284ac-7b01-11ec-0e30-4bf2b8b8af81
# ╟─cc94acdc-7b01-11ec-1eb1-13a377c3c361
# ╠═ccabc37c-7b01-11ec-09ef-41e0c5d822af
# ╟─ccabc8b8-7b01-11ec-20aa-0756142a12e6
# ╟─ccabc9ba-7b01-11ec-3c4c-6f8877edd3ad
# ╟─ccae74c8-7b01-11ec-2cd2-f7926da95d9e
# ╟─ccb14e9e-7b01-11ec-0e81-21f9498d4707
# ╟─ccb14efa-7b01-11ec-2255-7be93b1544a7
# ╟─ccb40a08-7b01-11ec-0be0-fd5ac64f5345
# ╟─ccb40a82-7b01-11ec-21fb-8b7bbff2f641
# ╟─ccb40ab4-7b01-11ec-24b4-351a640d9b35
# ╟─ccb40abe-7b01-11ec-14c2-9dbb8b58257f
# ╠═ccb41158-7b01-11ec-1bd8-dd7cfff68dcd
# ╟─ccb41194-7b01-11ec-2138-c5e1ddc0aa95
# ╟─ccb60510-7b01-11ec-23ab-bf562de702e2
# ╟─ccb6056c-7b01-11ec-3930-e920cd4bc82b
# ╟─ccb6058a-7b01-11ec-0d1c-0fdb207ca438
# ╟─ccb60594-7b01-11ec-2de2-2fc7fb5ac7a8
# ╟─ccb605a8-7b01-11ec-1dad-4b410d3e7021
# ╟─ccb605d0-7b01-11ec-2d89-31e25dc75a53
# ╟─ccb605e6-7b01-11ec-2d5d-4b0e389ccaed
# ╠═ccb60e18-7b01-11ec-2567-5f1d3a65f531
# ╟─ccb8c540-7b01-11ec-1753-07de40b56863
# ╟─ccb8c5c2-7b01-11ec-2854-a11da76f3b7e
# ╟─ccb8c5d6-7b01-11ec-1563-adc8a541c328
# ╟─ccc1c848-7b01-11ec-3e4f-312dea27e1ef
# ╠═ccc1d68a-7b01-11ec-17eb-9f88d7248e67
# ╟─ccc1d6d0-7b01-11ec-0424-f9f70b9b49a9
# ╠═ccc1dd4c-7b01-11ec-0d7e-d38627b699a9
# ╟─ccc1dd6a-7b01-11ec-0191-2927d236349c
# ╟─ccc1dd92-7b01-11ec-372c-dd4a9b0579fe
# ╟─ccc3997a-7b01-11ec-06dc-65e81caa8ced
# ╟─ccc399ca-7b01-11ec-27b4-e357a9afa31b
# ╟─ccc399e8-7b01-11ec-3f48-859851232f5d
# ╟─ccc399f2-7b01-11ec-13d5-3d53be156788
# ╟─ccccdb70-7b01-11ec-1717-d3117b42f2bb
# ╟─cccf9be2-7b01-11ec-3bd3-2d2c76bab47c
# ╟─cccf9c5c-7b01-11ec-2b24-ef86fa02ee7f
# ╟─cccf9c70-7b01-11ec-0d43-33e8290b99d7
# ╠═cccfa04c-7b01-11ec-3118-e902a03763b2
# ╠═cccfa6d4-7b01-11ec-01ac-ddd0554aac1d
# ╟─cccfa6fc-7b01-11ec-27fe-33f0792ec44a
# ╟─cccfa72e-7b01-11ec-00a1-715a0f73e59c
# ╟─cccfa742-7b01-11ec-12bb-3362971c9bf0
# ╟─cccfa760-7b01-11ec-2229-25db4b15d636
# ╟─cccfa774-7b01-11ec-0225-55f4b2c5171f
# ╟─cccfa788-7b01-11ec-2e87-1b5470baf515
# ╠═cccfab20-7b01-11ec-1e63-ff4e3cee815f
# ╟─cccfab5c-7b01-11ec-0916-b9d93e80b9f4
# ╟─ccd0d2ca-7b01-11ec-0007-678213f4bb8a
# ╟─ccd0d338-7b01-11ec-322b-451897dc9689
# ╟─ccd2825a-7b01-11ec-29b9-eb250c14a976
# ╠═ccd2894e-7b01-11ec-3984-0bcb14cee7d5
# ╟─ccd28996-7b01-11ec-1679-8f59f75c0ccc
# ╟─ccd289a8-7b01-11ec-2bb0-cd896e7c4c2f
# ╟─ccd289bc-7b01-11ec-3c6b-c19012475ea0
# ╟─ccd289da-7b01-11ec-08eb-49494b2554f3
# ╟─ccd28a16-7b01-11ec-37a0-7f6968f9928c
# ╟─ccd28a48-7b01-11ec-22e4-4df2699461fc
# ╟─ccd28a70-7b01-11ec-0620-2fd9bff344fd
# ╟─ccd28a84-7b01-11ec-11c7-0185efbd5128
# ╟─ccd3a400-7b01-11ec-100d-7d5683d11e22
# ╠═ccd3abee-7b01-11ec-0308-0db321f85afe
# ╟─ccd3ac2a-7b01-11ec-0e78-13a7e28e3ccf
# ╠═ccd3af90-7b01-11ec-348d-55fbe0225230
# ╟─ccd3afb8-7b01-11ec-2945-d5aee2b921a6
# ╟─ccd3afde-7b01-11ec-1e5d-f58ec4a271cc
# ╟─ccd3aff4-7b01-11ec-1dd7-cf6444c34c69
# ╟─ccd3b012-7b01-11ec-1c98-eba31faf8fb8
# ╟─ccd3b026-7b01-11ec-1abb-b99f30300330
# ╟─ccd3b03a-7b01-11ec-10d1-490d1fdde802
# ╟─ccd3b044-7b01-11ec-360a-23fbaa9530bf
# ╟─ccd3b082-7b01-11ec-21c5-131832a71aca
# ╟─ccd3b0b4-7b01-11ec-2907-ddd8fdd9f47e
# ╠═ccd3b742-7b01-11ec-377c-2dabec7a7d8c
# ╟─ccd3b77e-7b01-11ec-3dde-2b33d0761bf7
# ╟─ccd3b79c-7b01-11ec-35cc-cd516a2a6174
# ╟─ccd3b7a6-7b01-11ec-245d-6383b6310dc3
# ╟─ccd3b7b8-7b01-11ec-307d-3bc5d3ffaf91
# ╟─ccd3b7ea-7b01-11ec-3f5b-99f5ae71cda8
# ╠═ccd3bd46-7b01-11ec-0ef2-b5fb1d2e4c25
# ╟─ccd3bd64-7b01-11ec-0fe5-7362790c26c8
# ╟─ccd3bd8a-7b01-11ec-012d-89a9c96aa0fe
# ╟─ccd3bdaa-7b01-11ec-021b-b324d691fc9d
# ╟─ccd3c304-7b01-11ec-049e-0d2c982ac755
# ╟─ccd3c32a-7b01-11ec-15bf-67126b03854e
# ╟─ccd3c336-7b01-11ec-3238-e1d3923a529d
# ╟─ccd3c34a-7b01-11ec-2073-eb2a420640b7
# ╟─ccd3c368-7b01-11ec-08c1-95193c0c8901
# ╟─ccd3c37c-7b01-11ec-0bb0-1545192088d4
# ╟─ccd3c390-7b01-11ec-3811-632e053dd20b
# ╟─ccd3c3ae-7b01-11ec-0130-97f757ec0660
# ╠═ccd3cdb8-7b01-11ec-11d6-159115283c10
# ╟─ccd3cdd4-7b01-11ec-0ce0-8378adf76581
# ╠═ccd3d326-7b01-11ec-0679-a14ceee75b80
# ╟─ccd3d33a-7b01-11ec-28b9-138d46c43c28
# ╠═ccd3d556-7b01-11ec-31a5-8f59f42424e4
# ╟─ccd3d56a-7b01-11ec-3440-63fd983d9895
# ╠═ccd3d8c6-7b01-11ec-190b-8b2c8dfe260a
# ╟─ccd3d8ee-7b01-11ec-1afb-838c46c87a7f
# ╟─ccd3d902-7b01-11ec-3631-d9070f1388bc
# ╟─ccd3d914-7b01-11ec-150c-b34f9397c740
# ╠═ccd3df9c-7b01-11ec-2a80-75a83c1b8406
# ╟─ccd3dfc4-7b01-11ec-2f41-a72f8e72204e
# ╟─ccd3dff6-7b01-11ec-323e-4d6816a9bff8
# ╟─ccd3e00a-7b01-11ec-19a8-95e2542be89e
# ╟─ccd3e03c-7b01-11ec-073f-196e00371ebb
# ╟─ccd3e050-7b01-11ec-1885-45573875ac30
# ╠═ccd3e406-7b01-11ec-23e2-b326a77b06a1
# ╟─ccd3e422-7b01-11ec-02e4-815485c42590
# ╟─ccd3e442-7b01-11ec-1918-cf65a888c7c4
# ╟─ccd3e474-7b01-11ec-109a-133688e0e397
# ╟─ccd3e488-7b01-11ec-1c04-f19be535a931
# ╟─ccd3e494-7b01-11ec-365b-098e142d8deb
# ╟─ccd3e49c-7b01-11ec-13c7-8fa9d31cb276
# ╟─ccd3e4b0-7b01-11ec-1ac1-d9dbffff4001
# ╟─ccd3e4ce-7b01-11ec-160d-8d3213b72fcc
# ╟─ccd3e4e2-7b01-11ec-1c80-abbd95d0022b
# ╟─ccd3e4f8-7b01-11ec-2616-9747c4194512
# ╟─ccd3e500-7b01-11ec-25d2-ff220da7de41
# ╟─ccd3e50a-7b01-11ec-0316-055223523043
# ╟─ccd3e514-7b01-11ec-171b-c39700bbc097
# ╟─ccd3e51e-7b01-11ec-3cf0-17826328f568
# ╟─ccd3e526-7b01-11ec-2e18-7f18e122784f
# ╟─ccd3e532-7b01-11ec-21ec-6de9c4299a56
# ╟─ccd3e550-7b01-11ec-3adc-112dba3d4a57
# ╟─ccd3e56e-7b01-11ec-38e9-133e5f73f824
# ╟─ccd3e578-7b01-11ec-1f80-1d91cbceec60
# ╠═ccd3e97e-7b01-11ec-0314-312b64d15864
# ╟─ccd3e99c-7b01-11ec-0ead-af72acea2a3c
# ╟─ccd3e9ba-7b01-11ec-2617-53afad6b8220
# ╟─ccd512ba-7b01-11ec-2e7a-4775c5aac7d1
# ╟─ccd512e8-7b01-11ec-26e4-0fe6fbba43ca
# ╟─ccd512fe-7b01-11ec-1877-3db9527af507
# ╟─ccd51312-7b01-11ec-2bbd-f1a85d7a3e9a
# ╟─ccd5134e-7b01-11ec-03c5-c71ac7bd1935
# ╟─ccd51380-7b01-11ec-39b6-dbe4508afdde
# ╟─ccd51394-7b01-11ec-367c-e998baa1354c
# ╟─ccd8408c-7b01-11ec-30b7-aded27b7b294
# ╟─ccd8414a-7b01-11ec-357c-63400a46e6ea
# ╟─ccd84184-7b01-11ec-1540-c5f652ba44b8
# ╟─ccd8419a-7b01-11ec-18ed-e7ece4c959ae
# ╠═ccd84d52-7b01-11ec-0258-5de2dffb6d57
# ╟─ccd84d70-7b01-11ec-22f9-a5c93eb6a651
# ╟─ccd84d8e-7b01-11ec-28de-cd3687d1762c
# ╟─ccd84dc8-7b01-11ec-1fed-add50c80a93c
# ╟─ccda2ee4-7b01-11ec-115b-f5c3a0531f6d
# ╟─ccda2f76-7b01-11ec-00d7-cd045d0f3c56
# ╠═ccda35c2-7b01-11ec-0070-c5842398efe9
# ╟─ccda361a-7b01-11ec-0690-c9654a64b4a8
# ╟─ccda3630-7b01-11ec-36e3-f74593da668c
# ╟─ccda364c-7b01-11ec-1601-95ff7720dfcf
# ╟─ccda384c-7b01-11ec-2f3b-ffe80cdb8849
# ╟─ccda386a-7b01-11ec-3862-b1002df70e20
# ╟─ccda38b0-7b01-11ec-2f86-6f371ae05b76
# ╟─ccda38ce-7b01-11ec-3801-61074486ef4c
# ╟─ccda38ea-7b01-11ec-0ed1-fde4fe45c2c8
# ╠═ccda4314-7b01-11ec-34e0-43c5ac6e0315
# ╟─ccda433c-7b01-11ec-3591-11679c7ee1a2
# ╠═ccda47c4-7b01-11ec-25eb-1f1c187e275a
# ╟─ccda47d8-7b01-11ec-0128-a3f3229453e3
# ╠═ccda4b98-7b01-11ec-116d-192a06a9f918
# ╟─ccda4bc0-7b01-11ec-11e4-7b7e75c85d11
# ╠═ccda5052-7b01-11ec-203f-539f2bd26074
# ╟─ccda507a-7b01-11ec-071d-7955fd906387
# ╠═ccda5750-7b01-11ec-2fea-4f06e29fa8ed
# ╟─ccda5764-7b01-11ec-0ca6-f126dd451730
# ╟─ccda5796-7b01-11ec-036a-dbcbc92a7305
# ╟─ccda57b4-7b01-11ec-1d0a-759abbbbb789
# ╟─ccda57c8-7b01-11ec-132e-7dc13d4b2f8c
# ╠═ccda5d90-7b01-11ec-1b6f-795a1bbce121
# ╠═ccda61aa-7b01-11ec-0b71-3f60977d0526
# ╟─ccda61dc-7b01-11ec-3aa5-8bff7ba373e7
# ╠═ccda66b4-7b01-11ec-0a44-931f0e554766
# ╟─ccda66dc-7b01-11ec-111d-bbacb738db8a
# ╠═ccda6dda-7b01-11ec-0134-932190373aa0
# ╟─ccda6dee-7b01-11ec-0373-f55af475d134
# ╟─ccda6e0c-7b01-11ec-0459-0366e9fb88cc
# ╟─ccda6e20-7b01-11ec-2dbb-2ded95ec71d7
# ╟─ccda6e3e-7b01-11ec-1a6b-b5ca5b0703a7
# ╟─ccda6e64-7b01-11ec-1eff-6d63da74c586
# ╠═ccda7436-7b01-11ec-3c69-231ddf5abbfa
# ╟─ccda746a-7b01-11ec-38c6-a181cba78dee
# ╠═ccda77ee-7b01-11ec-03d0-553a79305526
# ╟─ccda780a-7b01-11ec-2774-0771fc0ff2a6
# ╠═ccda79ba-7b01-11ec-2792-bb09115379da
# ╟─ccda79e2-7b01-11ec-2136-618e9cd28b60
# ╠═ccda7fbe-7b01-11ec-3d65-6163ff0ceeaf
# ╠═ccda8540-7b01-11ec-24ba-35726caf2a15
# ╟─ccda8556-7b01-11ec-0c23-9b3c17ba1bf9
# ╠═ccda8acc-7b01-11ec-0f71-ad16198e906e
# ╟─ccda8aea-7b01-11ec-1861-c57c70131377
# ╟─ccda8afe-7b01-11ec-2e06-57a7dc53d36c
# ╟─ccda8b24-7b01-11ec-0712-df44d16e2e17
# ╟─ccda8b4e-7b01-11ec-2e38-db039d9f6191
# ╟─ccda8b62-7b01-11ec-146f-e34961d21434
# ╠═ccda906c-7b01-11ec-090e-03bff8206f02
# ╟─ccda9096-7b01-11ec-342b-27d04022a67d
# ╠═ccda946a-7b01-11ec-21b1-334475dee6f9
# ╟─ccda947c-7b01-11ec-3183-871cc4220291
# ╟─ccda949c-7b01-11ec-2740-3da8372658c4
# ╠═ccda99ea-7b01-11ec-0182-6dd109189698
# ╟─ccda9a12-7b01-11ec-2d34-a3dd1c88b423
# ╟─ccda9a30-7b01-11ec-1b6f-65165fcf8a8b
# ╟─ccda9a44-7b01-11ec-3ffe-cb06e63296dd
# ╟─ccda9a58-7b01-11ec-06ee-01ba150d3145
# ╟─ccda9a6a-7b01-11ec-04d4-33603efc0b23
# ╟─ccda9a94-7b01-11ec-2cb6-177ea2e7c245
# ╟─ccda9aa8-7b01-11ec-1270-61fe842d7bf5
# ╟─ccda9ab2-7b01-11ec-2225-6b0fc01b7fe1
# ╠═ccdaa3a4-7b01-11ec-2603-5f8265744c1f
# ╟─ccdaa3b8-7b01-11ec-3fe4-4b680484f036
# ╠═ccdaa836-7b01-11ec-26af-072a6fad81e6
# ╟─ccdaa85e-7b01-11ec-2c5c-83c36530b8d2
# ╠═ccdaaf16-7b01-11ec-2aeb-39ff4860d4be
# ╠═ccdab466-7b01-11ec-10ca-e5ad02d4631e
# ╟─ccdab47a-7b01-11ec-0a15-63122a93f642
# ╠═ccdab97a-7b01-11ec-0e13-41e94fda472a
# ╟─ccdab9ac-7b01-11ec-2da1-fd0fbfb979da
# ╟─ccdab9c0-7b01-11ec-3f1a-dfb6f18e0e4a
# ╟─ccdab9e8-7b01-11ec-1abe-f74472333af3
# ╟─ccdaba10-7b01-11ec-062a-9f4eee7bcd65
# ╟─ccdaba24-7b01-11ec-0b02-9f41970c7386
# ╟─ccdaba2c-7b01-11ec-2d92-eb858d7b61ae
# ╟─ccdaba42-7b01-11ec-2228-a5590f472dfc
# ╟─ccdaba60-7b01-11ec-10f9-4d56827f35d9
# ╟─ccdaba6a-7b01-11ec-0bf4-2100e7613009
# ╟─ccdaba7e-7b01-11ec-0938-ab8cb082f7a3
# ╠═ccdac238-7b01-11ec-1382-c1dad589c888
# ╟─ccdac262-7b01-11ec-1638-e1a06e9732d7
# ╠═ccdac5be-7b01-11ec-22fc-81790f2b7745
# ╠═ccdac816-7b01-11ec-17b8-a9ea02c5b8bc
# ╟─ccdac834-7b01-11ec-2d50-a7807fc4896a
# ╠═ccdacb40-7b01-11ec-3b80-89e6659e0411
# ╟─ccdacb72-7b01-11ec-2745-bffbf0c47a81
# ╟─ccdacb86-7b01-11ec-3556-dbec75258c30
# ╟─ccdacb9a-7b01-11ec-0266-b100cae6ac6b
# ╟─ccdacbac-7b01-11ec-0669-ad910d6b6fcd
# ╟─ccdacbc2-7b01-11ec-1bc9-d37e5fe65f52
# ╠═ccdad82e-7b01-11ec-2f33-e786b861fc4d
# ╟─ccdad854-7b01-11ec-296c-970f055b20db
# ╟─ccdad874-7b01-11ec-1365-319c226cbca7
# ╟─ccdad89c-7b01-11ec-2ff5-dd407c616a34
# ╟─ccdad8ba-7b01-11ec-3d97-7162d922ccd8
# ╟─ccdad8ce-7b01-11ec-14ab-b5d4ba8a9549
# ╟─ccdad8ec-7b01-11ec-1062-c36246981ed1
# ╟─ccdad900-7b01-11ec-2b9d-a38702c6ddff
# ╟─ccdad91e-7b01-11ec-0bfa-9dfc8592d699
# ╠═ccdae1b6-7b01-11ec-3c88-d135edc1745b
# ╟─ccdae1de-7b01-11ec-02e7-433e022096c6
# ╠═ccdaf8c2-7b01-11ec-3a1a-19398ac8ecd7
# ╟─ccdaf8e0-7b01-11ec-32cb-b1368ed7cd71
# ╟─ccdaf912-7b01-11ec-2bae-9b1370dc5718
# ╟─ccdaf926-7b01-11ec-2c2b-4bd5e4900540
# ╟─ccdaf94c-7b01-11ec-249a-ebf510c326d0
# ╟─ccdaf958-7b01-11ec-2be4-53795e26a0d2
# ╟─ccdaf96c-7b01-11ec-1b6e-7747ea2d8733
# ╟─ccdaf980-7b01-11ec-37a1-b9035218bc04
# ╠═ccdb0e48-7b01-11ec-0a32-31a0f957244c
# ╠═ccdb141a-7b01-11ec-23e2-2be1ba6ab8e0
# ╟─ccdb1438-7b01-11ec-3f63-675eb46c6ccf
# ╟─ccdb1460-7b01-11ec-1780-abdcec8d92ed
# ╟─ccdb1472-7b01-11ec-2c22-49eb2534db4e
# ╠═ccdb1a28-7b01-11ec-03f8-537aa74174b9
# ╟─ccdb1a3c-7b01-11ec-226f-8dc438209e75
# ╠═ccdb1dde-7b01-11ec-1d03-c765a8427a5e
# ╟─ccdb1df2-7b01-11ec-02d0-816e95041e3e
# ╠═ccdb1ff0-7b01-11ec-2f0b-41f75f160197
# ╟─ccdb2004-7b01-11ec-0daf-d753ba467ebe
# ╠═ccdb23b0-7b01-11ec-3916-815750aa608f
# ╟─ccdb23c4-7b01-11ec-226c-cd42181ae434
# ╟─ccdb2964-7b01-11ec-18ae-11cae0aaa9df
# ╟─ccdb298c-7b01-11ec-2132-2bde738ab10a
# ╟─ccdb29b4-7b01-11ec-33ee-39870c0fa3fa
# ╟─ccdb29d2-7b01-11ec-18a5-e1397fddb124
# ╟─ccdb29fc-7b01-11ec-106a-a125e4eb3a3d
# ╠═ccdb2f90-7b01-11ec-2ba0-974886636af9
# ╟─ccdb2fae-7b01-11ec-00e3-b9a13b939a62
# ╟─ccdb2fd6-7b01-11ec-0d41-977181dc0d38
# ╟─ccdb3544-7b01-11ec-236c-1b42cbd72904
# ╟─ccdb356a-7b01-11ec-3229-b728b9b7fdb0
# ╟─ccdb3594-7b01-11ec-00d3-89820a86a9d2
# ╟─ccdb35a8-7b01-11ec-3bb9-19f6200cc36e
# ╟─ccdb35bc-7b01-11ec-1c7f-aba49d8dc010
# ╟─ccdb35c6-7b01-11ec-0fd7-b3a94f1e0679
# ╟─ccdb3aee-7b01-11ec-3aa2-495b8b9c8559
# ╟─ccdb3b2a-7b01-11ec-12c6-9f7a5a392f72
# ╟─ccdccb22-7b01-11ec-3940-cd97af59bd80
# ╟─ccdccb70-7b01-11ec-2adb-7d588eba80d4
# ╟─ccdccbac-7b01-11ec-32c6-2b0caceece01
# ╟─ccdccbd4-7b01-11ec-2c62-c536a615686b
# ╟─ccdccc06-7b01-11ec-0a25-0b4679b3c464
# ╟─ccdccc26-7b01-11ec-0d64-cd82a56ccbcd
# ╟─ccdccc42-7b01-11ec-3b9e-fbc75a33108d
# ╟─ccdccc4c-7b01-11ec-3679-73cab6893bc3
# ╟─ccdccc58-7b01-11ec-32f3-3d282861b234
# ╟─ccdccc6a-7b01-11ec-0d4e-91d44654d6fc
# ╟─ccdccc74-7b01-11ec-1349-6fd8966667c8
# ╟─ccdccc92-7b01-11ec-206c-15ed130fcb66
# ╟─ccdcccb8-7b01-11ec-0cb3-313b8818fb49
# ╟─ccdcccc4-7b01-11ec-327d-29576093090c
# ╟─ccdcccce-7b01-11ec-1a3f-9fce7f696d7d
# ╟─ccdccce2-7b01-11ec-077a-95cf44c473e3
# ╟─ccdcccea-7b01-11ec-014b-6349e660140d
# ╟─ccdcccf6-7b01-11ec-1b53-0fd8edc253bb
# ╟─ccdccd14-7b01-11ec-3d61-df7e96a5dcce
# ╟─ccdccd1e-7b01-11ec-2805-3fd2636e92c3
# ╟─ccdccd32-7b01-11ec-1bfe-a94146132748
# ╟─ccdccd3c-7b01-11ec-0b1d-915810aa32c9
# ╟─ccdccd46-7b01-11ec-1d2f-6bd3de38c6fc
# ╟─ccdccd5a-7b01-11ec-1013-6182c03ce418
# ╠═ccdcd2c8-7b01-11ec-10c8-0938c7637c48
# ╟─ccdcd2e6-7b01-11ec-21e5-c95b3845f759
# ╠═ccdcd7b4-7b01-11ec-24a2-35719d4e2e7a
# ╟─ccdcd7dc-7b01-11ec-3c48-273ccb00f702
# ╟─ccdcd7f8-7b01-11ec-034e-811429dc9565
# ╟─ccdcd8d6-7b01-11ec-3a58-cb655938b374
# ╟─ccdcd8f4-7b01-11ec-0c0b-613405430a94
# ╟─ccdcd8fc-7b01-11ec-35f6-cda9f7b00b02
# ╟─ccdcd9a8-7b01-11ec-0c39-41d682a9e58b
# ╟─ccdcd9c6-7b01-11ec-33ae-a57524f94c2e
# ╟─ccdcdab6-7b01-11ec-04fe-3fcc0968600f
# ╟─ccdcdac8-7b01-11ec-300c-43dd6d22029e
# ╟─ccdcdade-7b01-11ec-10f2-f36e2bb6fea7
# ╟─ccdcdaf2-7b01-11ec-24db-0fa9998db8b5
# ╟─ccdcdb2e-7b01-11ec-1599-bdaa5bcdec83
# ╟─ccdcdb42-7b01-11ec-3cab-6df55016505d
# ╟─ccdcdb56-7b01-11ec-21fe-dbd645af044d
# ╟─ccdcdb60-7b01-11ec-2c2c-5f33b4adb92b
# ╟─ccdcdb6c-7b01-11ec-1b65-998f666ad11d
# ╟─ccdcdb74-7b01-11ec-3dc5-6bdc7d2ecd92
# ╟─ccdcdb92-7b01-11ec-39ab-af9d7b3c8a6c
# ╟─ccdcdb9e-7b01-11ec-288c-15309987a287
# ╟─ccdcdbb0-7b01-11ec-2877-210b6e7860ce
# ╟─ccdcdbba-7b01-11ec-3111-adb2c78bb4b1
# ╟─ccdcdbcc-7b01-11ec-3ebc-d5fc0a8728d5
# ╟─ccdcdbec-7b01-11ec-38b2-135cc9b1531b
# ╟─ccdcdbf6-7b01-11ec-0f16-c144e0f3f6ad
# ╟─ccdcdc0a-7b01-11ec-034a-5fca4daab0cf
# ╟─ccdcdc14-7b01-11ec-3538-5f33a490a6cb
# ╟─ccdcdc28-7b01-11ec-08fb-07ad8b53556f
# ╟─ccdcdc46-7b01-11ec-0c4e-1fec64a51e11
# ╟─ccdcdc5a-7b01-11ec-2ef6-3dad1c1a268d
# ╟─ccdcdc78-7b01-11ec-0ebb-77c78ae05ad6
# ╟─ccdcdc82-7b01-11ec-3f18-af0903f81ac9
# ╟─ccdcdc96-7b01-11ec-1366-754414bb6cde
# ╟─ccdcdcb4-7b01-11ec-243e-192a778570c9
# ╟─ccdcdcbe-7b01-11ec-10d6-e7c98a849a0a
# ╟─ccdcdcd4-7b01-11ec-33c6-6d5164d85f4d
# ╟─ccdcdcdc-7b01-11ec-1c5e-d7d628837e50
# ╟─ccdcdd02-7b01-11ec-3bed-e1b3d162a0bd
# ╠═ccdce236-7b01-11ec-0d1a-1527e5efeb1a
# ╟─ccdce274-7b01-11ec-0ce9-2d7dce5b9e98
# ╟─ccdce27c-7b01-11ec-1f24-d165b0e81798
# ╟─ccdce290-7b01-11ec-2ccc-e5787fcec995
# ╟─ccdce2ae-7b01-11ec-1a25-0539d2a006fb
# ╟─ccdce2c2-7b01-11ec-124c-47d7eb493046
# ╟─ccdce2cc-7b01-11ec-2397-a96f326b2f7e
# ╟─ccdce2ea-7b01-11ec-0aed-9dac86868505
# ╟─ccdce2f4-7b01-11ec-3893-e3aac9110b2e
# ╟─ccdce31c-7b01-11ec-38ec-514d4bac38e1
# ╟─ccdce33a-7b01-11ec-14ff-67cbb720f6ee
# ╟─ccdce36c-7b01-11ec-2ef4-33fd05ba514b
# ╟─ccdce39e-7b01-11ec-3126-5321a08caaf2
# ╟─ccdce3b2-7b01-11ec-1198-af88c9c7d928
# ╟─ccdce3c6-7b01-11ec-069b-dd5556718c63
# ╟─ccdce3d0-7b01-11ec-097c-ab35e7a0c439
# ╟─ccdce3e4-7b01-11ec-219b-079e0d05e444
# ╟─ccdce3f8-7b01-11ec-1cdb-3d9374e96581
# ╟─ccdce40a-7b01-11ec-1ce2-f777e260bff3
# ╟─ccdce420-7b01-11ec-0581-f774c09d10fc
# ╠═ccdce842-7b01-11ec-227f-c94a522af36a
# ╟─ccdce874-7b01-11ec-2dcf-85a0a19ac369
# ╠═ccdcec48-7b01-11ec-3c72-23419b4c6f6d
# ╟─ccdcec68-7b01-11ec-252d-2d414e16b6be
# ╠═ccdcefee-7b01-11ec-18b8-a59858683dd3
# ╟─ccdcf00a-7b01-11ec-1f73-bff671d69569
# ╠═ccdcf426-7b01-11ec-14e3-71c0daf794c7
# ╟─ccdcf454-7b01-11ec-09e2-238117483271
# ╟─ccdcf47e-7b01-11ec-0c56-fddb443a51ed
# ╟─ccdcf492-7b01-11ec-349b-d5bd28e16c95
# ╟─ccdcf4a6-7b01-11ec-3b11-9552a549fa33
# ╟─ccdcf4d8-7b01-11ec-13e0-f95e946795f6
# ╟─ccdcf4e2-7b01-11ec-1815-1d70f2d3cda9
# ╟─ccdcf4ec-7b01-11ec-2fa2-a745df6efd6c
# ╟─ccdcf4f6-7b01-11ec-070d-f540bfe5775d
# ╟─ccdcf500-7b01-11ec-2da3-d5a8b30f998d
# ╟─ccdcf50a-7b01-11ec-1456-5340b0765f51
# ╟─ccdcf514-7b01-11ec-3333-a783a4515d9c
# ╟─ccdcf532-7b01-11ec-27c5-3d32ce69bab8
# ╟─ccdcf546-7b01-11ec-3fb9-7f0ea3060420
# ╟─ccdcf55c-7b01-11ec-1e03-af39102f1188
# ╟─ccdcf56e-7b01-11ec-0c8a-7f09f557a707
# ╟─ccdcf582-7b01-11ec-3112-6dedff75dcc8
# ╟─ccdcf596-7b01-11ec-37d4-45c263fd8108
# ╟─ccdcf5aa-7b01-11ec-0db2-716ee5032f9b
# ╟─ccdcf5b4-7b01-11ec-0b01-2faceddf0529
# ╟─ccdcf5d2-7b01-11ec-08d6-d504903e3a73
# ╟─ccdcf5dc-7b01-11ec-1b8b-1facadd304a6
# ╟─ccdcf5ee-7b01-11ec-10df-a53b2ecb3a71
# ╟─ccdcf5fa-7b01-11ec-21e8-6dda5f940ba4
# ╟─ccdcf618-7b01-11ec-039d-e5d3fa81e94e
# ╠═ccdcfa96-7b01-11ec-0177-0ff189c4ec1a
# ╠═ccdcfda2-7b01-11ec-2dd0-9b652a46434a
# ╟─ccdcfdc0-7b01-11ec-3ca3-4b773c9cf70e
# ╠═ccdd0232-7b01-11ec-1017-63314be3601d
# ╟─ccdd025c-7b01-11ec-1fb8-557be300d1d3
# ╠═ccdd04aa-7b01-11ec-3025-93ba3d9e6784
# ╟─ccdd04c8-7b01-11ec-272e-4b8a4832740b
# ╠═ccdd09de-7b01-11ec-2469-d755778d2423
# ╟─ccdd0a04-7b01-11ec-199c-d7f40322ebc0
# ╠═ccdd0d06-7b01-11ec-28a6-db7e307890c6
# ╟─ccdd0d2e-7b01-11ec-28d2-3f6935dc9f43
# ╠═ccdd142c-7b01-11ec-2b62-ffd35e8034fb
# ╟─ccdd1448-7b01-11ec-28f6-a1ae2341df70
# ╟─ccdfa8ec-7b01-11ec-3b7f-77ce20ffeaba
# ╟─ccdfa962-7b01-11ec-102b-7fd3f994b1e7
# ╟─ccdfb0a6-7b01-11ec-0d32-cb22b57a2373
# ╟─ccdfb0ce-7b01-11ec-3246-19a2090f05b9
# ╟─ccdfb100-7b01-11ec-1c76-376befdb4ab6
# ╟─ccdfb650-7b01-11ec-3b37-cff5529810dc
# ╟─ccdfb666-7b01-11ec-11e5-ab85032818e4
# ╟─ccdfb682-7b01-11ec-242a-fddc5899cb0d
# ╟─ccdfbc34-7b01-11ec-3f19-0990d4e6e5fd
# ╟─ccdfbc54-7b01-11ec-2d6d-2d2a020bcccf
# ╟─ccdfbc7c-7b01-11ec-0c83-bd478a7af174
# ╟─ccdfbc90-7b01-11ec-1056-ef445dcb7b3e
# ╟─ccdfc4ba-7b01-11ec-02da-29e130ce07a4
# ╟─ccdfc4d6-7b01-11ec-3a9b-bd4cebfdd78d
# ╟─ccdfc4f6-7b01-11ec-3c0b-21213fbeed2e
# ╟─ccdfc6c2-7b01-11ec-2606-7f428a1bcd7b
# ╟─ccdfc6f4-7b01-11ec-1e6d-637753ab908e
# ╟─ccdfcce2-7b01-11ec-2169-5fb49952b07d
# ╟─ccdfcd0c-7b01-11ec-0743-d1e8951692a0
# ╟─ccdfd842-7b01-11ec-0845-4794aa63ac65
# ╟─ccdfd874-7b01-11ec-1690-33f9586c4441
# ╟─ccdfd8a6-7b01-11ec-1495-11b56c187dfc
# ╟─ccdfd8ba-7b01-11ec-30c6-cd4d0a5f6360
# ╠═ccdfdff4-7b01-11ec-0ae3-bb43b788d556
# ╟─ccdfe17a-7b01-11ec-3604-e71f357db597
# ╟─ccdfe1a2-7b01-11ec-110f-d7bfcdafdb19
# ╠═ccdfe8be-7b01-11ec-0bfe-c13bd86be184
# ╟─ccdfea46-7b01-11ec-2e8c-c5f38d20311c
# ╟─ccdfea58-7b01-11ec-378b-d336757cec05
# ╠═ccdff16a-7b01-11ec-317a-b9387e9bda59
# ╟─ccdff188-7b01-11ec-10d1-2d6da884e389
# ╟─ccdffee4-7b01-11ec-27c6-95485dbf0625
# ╟─ccdfff0c-7b01-11ec-0237-fb2160f55ae7
# ╟─cce00cae-7b01-11ec-3d17-a77ca80857d3
# ╟─cce00cd8-7b01-11ec-224f-e94e5fbba22f
# ╟─cce01a32-7b01-11ec-2754-733879808484
# ╟─cce01a46-7b01-11ec-346c-3d47dc10af70
# ╟─cce01a6e-7b01-11ec-1e7e-5b0287d1e4d1
# ╟─cce01a84-7b01-11ec-0a12-7d1a1d7b53c8
# ╟─cce01aa0-7b01-11ec-2b2f-a3f82ae3c7d8
# ╟─cce01c26-7b01-11ec-2ddc-bfa6144f63c8
# ╟─cce01c44-7b01-11ec-12ef-b162a7bfa736
# ╟─cce01c4c-7b01-11ec-053c-dfc259fa586a
# ╟─cce01db4-7b01-11ec-1868-cbdd68e35019
# ╟─cce01dd4-7b01-11ec-1b68-21541f35f47d
# ╟─cce024aa-7b01-11ec-2f0a-578cf8b8d372
# ╟─cce024dc-7b01-11ec-0e00-d99e79259518
# ╟─cce02b92-7b01-11ec-23a4-ebe76effd32b
# ╟─cce02bbc-7b01-11ec-13d6-85686f5600f8
# ╟─cce0329a-7b01-11ec-1d8e-afba06ad2dea
# ╟─cce032b0-7b01-11ec-3efb-fd665c4720eb
# ╟─cce032ce-7b01-11ec-2618-93a94142a188
# ╟─cce032e2-7b01-11ec-2957-fb6c9818ff1c
# ╟─cce032f6-7b01-11ec-3a50-3f7cdac7541d
# ╟─cce03468-7b01-11ec-33c1-039867e36aed
# ╟─cce03486-7b01-11ec-126d-b70d5a109ea2
# ╟─cce03b8e-7b01-11ec-113f-150b1cdbd17e
# ╟─cce03bb6-7b01-11ec-05a9-0133ebe62c71
# ╠═cce04390-7b01-11ec-3cf8-4f8554775232
# ╟─cce043a4-7b01-11ec-38d1-2fb85748fbb2
# ╟─cce04b2e-7b01-11ec-1055-cd6d1434ccfb
# ╟─cce04b4c-7b01-11ec-0a30-1f5bde9d709a
# ╟─cce04b54-7b01-11ec-3cb2-0be2e9201680
# ╟─cce04b54-7b01-11ec-1232-6d4c8e9ee1fb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
