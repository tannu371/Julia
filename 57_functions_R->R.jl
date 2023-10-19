### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 534e611e-7b02-11ec-1762-ff925f732136
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using ForwardDiff
	using LinearAlgebra
end

# ╔═╡ 534e6452-7b02-11ec-1a5f-1bdf8b5fd089
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 53cfc68c-7b02-11ec-3b3a-61c5537a409e
using PlutoUI

# ╔═╡ 53cfc664-7b02-11ec-1ca0-9da67f711129
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 53342c54-7b02-11ec-01d1-db5046555423
md"""# Functions $R^n \rightarrow R^m$
"""

# ╔═╡ 5336948c-7b02-11ec-00ed-c71f3f499d75
md"""This section uses these add-on packages:
"""

# ╔═╡ 5351870e-7b02-11ec-0b07-9de55b7b102a
md"""For a scalar function $f: R^n \rightarrow R$, the gradient of $f$, $\nabla{f}$, is a function from $R^n \rightarrow R^n$. Specializing to $n=2$, a function that for each point, $(x,y)$, assigns a vector $\vec{v}$. This is an example of vector field. More generally, we  could have a [function](https://en.wikipedia.org/wiki/Multivariable_calculus) $f: R^n \rightarrow R^m$, of which we have discussed many already:
"""

# ╔═╡ 53a2c9ac-7b02-11ec-357a-c5e92bd693f4
md"""|         Mapping         |     Name      |       Visualize with        |       Notation       |
|:-----------------------:|:-------------:|:---------------------------:|:--------------------:|
|   $f: R\rightarrow R$   |  univariate   | familiar graph of function  |         $f$          |
|  $f: R\rightarrow R^m$  | vector-valued |  space curve when n=2 or 3  | $\vec{r}$, $\vec{N}$ |
|  $f: R^n\rightarrow R$  |    scalar     |     a surface when n=2      |         $f$          |
| $F: R^n\rightarrow R^n$ | vector field  |   a vector field when n=2   |         $F$          |
| $F: R^n\rightarrow R^m$ | multivariable | n=2,m=3 describes a surface |     $F$, $\Phi$      |
"""

# ╔═╡ 53a2ca10-7b02-11ec-0551-f1207bbad2d4
md"""After an example where the use of a multivariable function is of necessity, we discuss differentiation in general for a multivariable functions.
"""

# ╔═╡ 53a554e2-7b02-11ec-3dcf-67e9c18d1c53
md"""## Vector fields
"""

# ╔═╡ 53ae6bc4-7b02-11ec-32b4-fd9c6f1aabeb
md"""We have seen that the gradient of a scalar function, $f:R^2 \rightarrow R$, takes a point in $R^2$ and associates a vector in $R^2$. As such $\nabla{f}:R^2 \rightarrow R^2$ is a vector field. A vector field  can be visualized by sampling a region and representing the field at those points. The details, as previously mentioned, are in the `vectorfieldplot` function of `CalculusWithJulia`.
"""

# ╔═╡ 53ae73f6-7b02-11ec-0bbe-6592eda1c045
begin
	F(u,v) = [-v, u]
	vectorfieldplot(F, xlim=(-5,5), ylim=(-5,5), nx=10, ny=10)
end

# ╔═╡ 53af99d4-7b02-11ec-24ee-b363543a9ce3
md"""The optional arguments `nx=10` and `ny=10` determine the number of points on the grid that a vector will be plotted. These vectors are scaled to not overlap.
"""

# ╔═╡ 53af9a38-7b02-11ec-1e99-d7626a83e354
md"""Vector field plots are useful for visualizing velocity fields, where a velocity vector is associated to each point; or streamlines, curves whose tangents are follow the velocity vector of a flow.  Vector fields are used in physics to model the electric field and the magnetic field. These are used to describe forces on objects within the field.
"""

# ╔═╡ 53af9a74-7b02-11ec-250c-f1bce954d2e5
md"""The three dimensional vector field is one way to illustrate a vector field, but there is an alternate using field lines. Like Euler's method, imagine starting at some point, $\vec{r}$ in $R^3$. The field at that point is a vector indicating a direction of motion. Follow that vector for some infinitesimal amount, $d\vec{r}$. From here repeat. The field curve would satisfy $\vec{r}'(t) = F(\vec{r}(t))$. Field curves only show direction, to indicate magnitude at a point, the convention is to use denser lines when the field is stronger.
"""

# ╔═╡ 53afa29e-7b02-11ec-0429-3f2a9153894c
let
	#out download("https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/VFPt_Earths_Magnetic_Field_Confusion.svg/320px-VFPt_Earths_Magnetic_Field_Confusion.svg.png")
	#cp(out, "figures/magnetic-field.png")
	
	imgfile = "figures/magnetic-field.png"
	caption = """
	Illustration of the magnetic field of the earth using field lines to indicate the field. From
	[Wikipedia](https://en.wikipedia.org/wiki/Magnetic_field).
	"""
	ImageFile(:differentiable_vector_calculus, imgfile, caption)
end

# ╔═╡ 53b1c736-7b02-11ec-1d33-51502da723f8
md"""---
"""

# ╔═╡ 53b1c79c-7b02-11ec-06fd-6784f86a9258
md"""Vector fields are also useful for other purposes, such as transformations, examples of which are a rotation or the conversion from polar to rectangular coordinates.
"""

# ╔═╡ 53b1c7d6-7b02-11ec-38e9-69b5b5467637
md"""For transformations, a useful visualization is to plot curves where one variables is fixed. Consider the transformation from polar coordinates to cartesian coordinates $F(r, \theta) = r \langle\cos(\theta),\sin(\theta)\rangle$. The following plot will show in blue fixed values of $r$ (circles) and in red fixed values of $\theta$ (rays).
"""

# ╔═╡ 53b1cfec-7b02-11ec-31f4-c7b7629c28c3
let
	F(r,theta) = r*[cos(theta), sin(theta)]
	F(v) = F(v...)
	
	rs = range(0, 2, length=5)
	thetas = range(0, pi/2, length=9)
	
	plot(legend=false, aspect_ratio=:equal)
	plot!(unzip(F.(rs, thetas'))..., color=:red)
	plot!(unzip(F.(rs', thetas))..., color=:blue)
	
	pt = [1, pi/4]
	J = ForwardDiff.jacobian(F, pt)
	arrow!(F(pt...), J[:,1], linewidth=5, color=:red)
	arrow!(F(pt...), J[:,2], linewidth=5, color=:blue)
end

# ╔═╡ 53b1d028-7b02-11ec-0982-631834cd20ec
md"""To the plot, we added the partial derivatives with respect to $r$ (in red) and with respect to $\theta$ (in blue). These are found with the soon-to-be discussed Jacobian. From the graph, you can see that these vectors are tangent vectors to the drawn curves.
"""

# ╔═╡ 53b1d05a-7b02-11ec-31bc-c5ae17afbd6d
md"""## Parametrically defined surfaces
"""

# ╔═╡ 53b1d078-7b02-11ec-3519-d1c03547b331
md"""For a one-dimensional curve we have several descriptions. For example, as the graph of a function $y=f(x)$; as a parametrically defined curve $\vec{r}(t) = \langle x(t), y(t)\rangle$; or as a level curve of a scalar function $f(x,y) = c$.
"""

# ╔═╡ 53b1d08c-7b02-11ec-3d4d-9f6c77ffdbb4
md"""For two-dimensional surfaces in three dimensions, we have discussed describing these in terms of a function $z = f(x,y)$ and as level curves of scalar functions: $c = f(x,y,z)$. They can also be described parametrically.
"""

# ╔═╡ 53b1d096-7b02-11ec-1889-0f9b3efc91de
md"""We pick a familiar case, to make this concrete: the unit sphere in $R^3$. We have
"""

# ╔═╡ 53bd0498-7b02-11ec-0c42-731fe9b40492
md"""  * It is described by two functions through $f(x,y) = \pm \sqrt{1 - (x^2 + y^2)}$.
  * It is described by $f(x,y,z) = 1$, where $f(x,y,z) = x^2 + y^2 + z^2$.
  * It can be described in terms of [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system):
"""

# ╔═╡ 53bf1d3c-7b02-11ec-3762-091fbda1a662
md"""```math
\Phi(\theta, \phi) = \langle \sin(\phi)\cos(\theta), \sin(\phi)\sin(\theta), \cos(\phi) \rangle,
```
"""

# ╔═╡ 53bfb03a-7b02-11ec-1e28-65e2ccf3da1a
md"""with $\theta$ the *azimuthal* angle and $\phi$ the polar angle (measured down from the $z$ axis).
"""

# ╔═╡ 53bfb09e-7b02-11ec-2833-3f22e3e937c0
md"""The function $\Phi$ takes $R^2$ into $R^3$, so is a multivariable function.
"""

# ╔═╡ 53bfb0bc-7b02-11ec-2f14-7140a7c37f26
md"""When a surface is described by a function, $z=f(x,y)$, then the gradient points (in the $x-y$ plane) in the direction of greatest increase of $f$. The vector $\langle -f_x, -f_y, 1\rangle$ is a normal.
"""

# ╔═╡ 53bfb0e4-7b02-11ec-3063-e3d3ba23bf95
md"""When a surface is described as a level curve, $f(x,y,z) = c$, then the gradient is *normal* to the surface.
"""

# ╔═╡ 53c0d898-7b02-11ec-2251-15f7f365eaaf
md"""When a surface is described parametrically, there is no "gradient." The *partial* derivatives are of interest, e.g., $\partial{F}/\partial{\theta}$ and $\partial{F}/\partial{\phi}$, vectors defined componentwise. These will be lie in the tangent plane of the surface, as they can be viewed as tangent vectors for parametrically defined curves on the surface. Their cross product will be *normal* to the surface. The magnitude of the cross product, which reflects the angle between the two partial derivatives, will be informative as to the surface area.
"""

# ╔═╡ 53c38afc-7b02-11ec-2275-3d84c72845f5
md"""### Plotting parametrized surfaces in `Julia`
"""

# ╔═╡ 53c38b72-7b02-11ec-06d9-4b75c4356ebc
md"""Consider the parametrically described surface above. How would it be plotted? Using the `Plots` package, the process is quite similar to how a surface described by a function is plotted, but the $z$ values must be computed prior to plotting.
"""

# ╔═╡ 53c38b7e-7b02-11ec-068f-59b2dda4cd26
md"""Here we define the parameterization using functions to represent each component:
"""

# ╔═╡ 53c3936c-7b02-11ec-1ef1-7559c3bb9bfc
begin
	X(theta,phi) = sin(phi) * cos(theta)
	Y(theta,phi) = sin(phi) * sin(theta)
	Z(theta,phi) = cos(phi)
end

# ╔═╡ 53c3938a-7b02-11ec-2cf6-9778c564bdb6
md"""Then:
"""

# ╔═╡ 53c39aa6-7b02-11ec-12c8-7343d075d73b
begin
	thetas = range(0, stop=pi/2, length=50)
	phis   = range(0, stop=pi,   length=50)
	
	xs = [X(theta, phi) for theta in thetas, phi in phis]
	ys = [Y(theta, phi) for theta in thetas, phi in phis]
	zs = [Z(theta, phi) for theta in thetas, phi in phis]
	
	surface(xs, ys, zs)  ## see note
end

# ╔═╡ 53c3a14a-7b02-11ec-1880-e521087e183d
note("""Only *some* backends for `Plots` will produce this type of plot. Both `plotly()` and `pyplot()` will, but not `gr()`.
""")

# ╔═╡ 53c3a726-7b02-11ec-1edd-f7b5d8f629c6
note("""Note: PyPlot can  be used directly to make these surface plots: `import PyPlot; PyPlot.plot_surface(xs,ys,zs)`""")

# ╔═╡ 53c3a744-7b02-11ec-1a0e-217660d7ae53
md"""Instead of the comprehension, broadcasting can be used
"""

# ╔═╡ 53c3acc6-7b02-11ec-18fc-175ad6d3269c
surface(X.(thetas, phis'), Y.(thetas, phis'), Z.(thetas, phis'))

# ╔═╡ 53c3ace4-7b02-11ec-11a5-85f9059cf77f
md"""If the parameterization is presented as a function, broadcasting can be used to succintly plot
"""

# ╔═╡ 53c3b2a2-7b02-11ec-229a-49a9b8772071
begin
	Phi(theta, phi) = [X(theta, phi), Y(theta, phi), Z(theta, phi)]
	
	surface(unzip(Phi.(thetas, phis'))...)
end

# ╔═╡ 53c3b2dc-7b02-11ec-10e4-6f96ea38acd3
md"""The partial derivatives of each component, $\partial{\Phi}/\partial{\theta}$ and $\partial{\Phi}/\partial{\phi}$, can be computed directly:
"""

# ╔═╡ 53c3b30e-7b02-11ec-0dc9-cf144a0cf3ce
md"""```math
\begin{align*}
\partial{\Phi}/\partial{\theta} &= \langle -\sin(\phi)\sin(\theta), \sin(\phi)\cos(\theta),0 \rangle,\\
\partial{\Phi}/\partial{\phi} &= \langle \cos(\phi)\cos(\theta), \cos(\phi)\sin(\theta), -\sin(\phi) \rangle.
\end{align*}
```
"""

# ╔═╡ 53c3b32e-7b02-11ec-2239-5138c556660c
md"""Using `SymPy`, we can compute through:
"""

# ╔═╡ 53c3b702-7b02-11ec-1e22-536594234dda
begin
	@syms theta phi
	out = [diff.(Phi(theta, phi), theta) diff.(Phi(theta, phi), phi)]
end

# ╔═╡ 53c3b72a-7b02-11ec-0b29-77067a55e098
md"""At the point $(\theta, \phi) = (\pi/12, \pi/6)$ this evaluates to the following.
"""

# ╔═╡ 53c3bcac-7b02-11ec-14d5-8b267a1e1675
subs.(out, theta.=> PI/12, phi.=>PI/6) .|> N

# ╔═╡ 53c3bcd4-7b02-11ec-2967-05d5eaff9b03
md"""We found numeric values, so that we can compare to the numerically identical values computed by the `jacobian` function from `ForwardDiff`:
"""

# ╔═╡ 53c3c1e8-7b02-11ec-19d5-6d18eacccfcb
begin
	pt = [pi/12, pi/6]
	out₁ = ForwardDiff.jacobian(v -> Phi(v...), pt)
end

# ╔═╡ 53c3c1fc-7b02-11ec-3565-af59e9bfc755
md"""What this function computes exactly will be described next, but here we visualize the partial derivatives and see they lie in the tangent plane at the point:
"""

# ╔═╡ 53c3ca80-7b02-11ec-1986-9b9350c810a6
let
	us, vs = range(0, pi/2, length=25), range(0, pi, length=25)
	xs, ys, zs = unzip(Phi.(us, vs'))
	surface(xs, ys, zs, legend=false)
	arrow!(Phi(pt...), out₁[:,1], linewidth=3)
	arrow!(Phi(pt...), out₁[:,2], linewidth=3)
end

# ╔═╡ 53c3cab2-7b02-11ec-0ff2-47a5b01e19de
md"""## The total derivative
"""

# ╔═╡ 53c3caf8-7b02-11ec-334e-09bb8db2607b
md"""Informally, the [total derivative](https://en.wikipedia.org/wiki/Total_derivative) at $a$ is the best linear approximation of the value of a function, $F$, near $a$ with respect to its arguments. If it exists, denote it $dF_a$.
"""

# ╔═╡ 53c3cb2a-7b02-11ec-39ea-7bc7014c675b
md"""For a function $F: R^n \rightarrow R^m$ we have the total derivative at $\vec{a}$ (a point or vector in $R^n$) is a matrix $J$ (a linear transformation)  taking vectors in $R^n$ and returning, under multiplication, vectors in $R^m$ (this matrix will be $m \times n$), such that for some neighborhood of $\vec{a}$, we have:
"""

# ╔═╡ 53c3cb36-7b02-11ec-3a2a-ff0fddd52ecf
md"""```math
\lim_{\vec{x} \rightarrow \vec{a}} \frac{\|F(\vec{x}) - F(\vec{a}) - J\cdot(\vec{x}-\vec{a})\|}{\|\vec{x} - \vec{a}\|} = \vec{0}.
```
"""

# ╔═╡ 53c3cb48-7b02-11ec-058b-5db8fb144a5e
md"""(That is $ \|F(\vec{x}) - F(\vec{a}) - J\cdot(\vec{x}-\vec{a})\|=\mathcal{o}(\|\vec{x}-\vec{a}\|)$.)
"""

# ╔═╡ 53c3cb64-7b02-11ec-2bc5-9b31968cc6c7
md"""If for some $J$ the above holds, the function $F$ is said to be totally differentiable, and the matrix $J =J_F=dF_a$ is the total derivative.
"""

# ╔═╡ 53c3cb84-7b02-11ec-313e-039411f71889
md"""For a multivariable function $F:R^n \rightarrow R^m$, we may express the function in vector-valued form $F(\vec{x}) = \langle f_1(\vec{x}), f_2(\vec{x}),\dots,f_m(\vec{x})\rangle$, each component a scalar function. Then, if the total derivative exists, it can be expressed by the [Jacobian](https://en.wikipedia.org/wiki/Jacobian_matrix_and_determinant):
"""

# ╔═╡ 53c3cb96-7b02-11ec-163d-4fe6e4db845c
md"""```math
J = \left[
\begin{align*}
\frac{\partial f_1}{\partial x_1} &\quad \frac{\partial f_1}{\partial x_2} &\dots&\quad\frac{\partial f_1}{\partial x_n}\\
\frac{\partial f_2}{\partial x_1} &\quad \frac{\partial f_2}{\partial x_2} &\dots&\quad\frac{\partial f_2}{\partial x_n}\\
&&\vdots&\\
\frac{\partial f_m}{\partial x_1} &\quad \frac{\partial f_m}{\partial x_2} &\dots&\quad\frac{\partial f_m}{\partial x_n}
\end{align*}
\right].
```
"""

# ╔═╡ 53c3cbac-7b02-11ec-3bae-0137f913c6cc
md"""This may also be viewed as:
"""

# ╔═╡ 53c3cbb6-7b02-11ec-36dc-b10efcdfaf81
md"""```math
J = \left[
\begin{align*}
&\nabla{f_1}'\\
&\nabla{f_2}'\\
&\quad\vdots\\
&\nabla{f_m}'
\end{align*}
\right] =
\left[
\frac{\partial{F}}{\partial{x_1}}\quad
\frac{\partial{F}}{\partial{x_2}} \cdots
\frac{\partial{F}}{\partial{x_n}}
\right].
```
"""

# ╔═╡ 53c3cbd4-7b02-11ec-3b99-6d84de5a24a4
md"""The latter representing a matrix of $m$ row vectors, each with $n$ components or as a matrix of $n$ column vectors, each with $m$ components.
"""

# ╔═╡ 53c3cbfc-7b02-11ec-1a05-5b13237ffda5
md"""---
"""

# ╔═╡ 53c3cc06-7b02-11ec-179d-a3112c7849f7
md"""After specializing the total derivative to the cases already discussed, we have:
"""

# ╔═╡ 53c3cdb4-7b02-11ec-08ac-abed73f3ea50
md"""  * Univariate functions. Here $f'(t)$ is also univariate. Identifying $J$ with the $1 \times 1$ matrix with component $f'(t)$, then the total derivative is just a restatement of the derivative existing.
  * Vector-valued functions $\vec{f}(t) = \langle f_1(t), f_2(t), \dots, f_m(t) \rangle$, each component univariate. Then the derivative, $\vec{f}'(t) = \langle \frac{df_1}{dt}, \frac{df_2}{dt}, \dots, \frac{df_m}{dt} \rangle$. The total derivative in this case, is a a $m \times 1$ vector of partial derivatives, and since there is only $1$ variable, would be written without partials. So the two agree.
  * Scalar functions $f(\vec{x}) = a$ of type $R^n \rightarrow R$. The definition of differentiability for $f$ involved existence of the partial derivatives and moreover, the fact that a limit like the above held with $ \nabla{f}(C) \cdot \vec{h}$ in place of $J\cdot(\vec{x}-\vec{a})$. Here $\vec{h}$ and $\vec{x}-\vec{a}$ are vectors in $R^n$. Were the dot product in $ \nabla{f}(C) \cdot \vec{h}$ expressed in matrix multiplication we would have for this case a $1 \times n$ matrix of the correct form:
"""

# ╔═╡ 53c3cdc8-7b02-11ec-06b8-b9e060909cd1
md"""```math
J = [\nabla{f}'].
```
"""

# ╔═╡ 53c3ce06-7b02-11ec-2d8f-c95549e723aa
md"""  * For $f:R^2 \rightarrow R$, the Hessian matrix, was the matrix of 2nd partial derivatives. This may be viewed as the total derivative of the the gradient function, $\nabla{f}$:
"""

# ╔═╡ 53c3ce18-7b02-11ec-0373-7187fb6ebc1a
md"""```math
\text{Hessian} =
\left[
\begin{align*}
\frac{\partial^2 f}{\partial x^2}          &\quad \frac{\partial^2 f}{\partial x \partial y}\\
\frac{\partial^2 f}{\partial y \partial x} &\quad \frac{\partial^2 f}{\partial y \partial y}
\end{align*}
\right]
```
"""

# ╔═╡ 53c3ce2c-7b02-11ec-2890-1d737ed264fd
md"""This is equivalent to:
"""

# ╔═╡ 53c3ce34-7b02-11ec-3874-9b371cc4ee5e
md"""```math
\left[
\begin{align*}
\frac{\partial \frac{\partial f}{\partial x}}{\partial x} &\quad \frac{\partial \frac{\partial f}{\partial x}}{\partial y}\\
\frac{\partial \frac{\partial f}{\partial y}}{\partial x} &\quad \frac{\partial \frac{\partial f}{\partial y}}{\partial y}\\
\end{align*}
\right].
```
"""

# ╔═╡ 53c3ce4a-7b02-11ec-26f5-15445730c245
md"""As such, the total derivative is a generalization of what we have previously discussed.
"""

# ╔═╡ 53c3ce5e-7b02-11ec-3ac1-9762bd746565
md"""## The chain rule
"""

# ╔═╡ 53c3ce7c-7b02-11ec-39e3-abf42b17c8ee
md"""If $G:R^k \rightarrow R^n$ and $F:R^n \rightarrow R^m$, then the composition $F\circ G$ takes $R^k \rightarrow R^m$. If all three functions are totally differentiable, then a chain rule will hold (total derivative of $F\circ G$ at point $a$):
"""

# ╔═╡ 53c3ce86-7b02-11ec-2096-4ba94b74461d
md"""```math
d(F\circ G)_a = dF_{G(a)} \cdot dG_a

```
"""

# ╔═╡ 53c3ceae-7b02-11ec-338c-0f5919062636
md"""If correct, this has the same formulation as the chain rule for the univariate case: derivative of outer at the inner *times* the derivative of the inner.
"""

# ╔═╡ 53c3ced6-7b02-11ec-3b4a-7dd604cf3db2
md"""First we check that the dimensions are correct: We have $dF_{G(a)}$ (the total derivative of $F$ at the point $G(a)$) is an $m \times n$ matrix and $dG_a$ (the total derivative of $G$ at the point $a$) is a $n \times k$ matrix. The product of a $m \times n$ matrix with a $n \times k$ matrix is defined, and is a $m \times k$ matrix, as is $d(F \circ G)_a$.
"""

# ╔═╡ 53c3ceea-7b02-11ec-36ea-ada40ffc9b00
md"""The proof that the formula is correct uses the definition of totally differentiable written as
"""

# ╔═╡ 53c3cef4-7b02-11ec-0665-27828ba5f9b0
md"""```math
F(b + \vec{h}) - F(b) - dF_b\cdot \vec{h} = \epsilon(\vec{h}) \vec{h},
```
"""

# ╔═╡ 53c3cf0a-7b02-11ec-0cf4-e17677436e7b
md"""where $\epsilon(h) \rightarrow \vec{0}$ as $h \rightarrow \vec{0}$.
"""

# ╔═╡ 53c3cf26-7b02-11ec-3f9e-1f51144ba7f3
md"""We have, using this for *both* $F$ and $G$:
"""

# ╔═╡ 53c3cf30-7b02-11ec-12a0-33751f14ca82
md"""```math
\begin{align*}
F(G(a + \vec{h})) - F(G(a)) &=
F(G(a) + (dG_a \cdot \vec{h} + \epsilon_G \vec{h})) - F(G(a))\\
&= F(G(a)) + dF_{G(a)} \cdot (dG_a \cdot \vec{h} + \epsilon_G \vec{h}) \\
&+ \quad\epsilon_F (dG_a \cdot \vec{h} + \epsilon_G \vec{h}) - F(G(a))\\
&= dF_{G(a)} \cdot (dG_a \cdot \vec{h})  +  dF_{G(a)} \cdot (\epsilon_G \vec{h}) + \epsilon_F (dG_a \cdot \vec{h}) + (\epsilon_F \cdot \epsilon_G\vec{h})
\end{align*}
```
"""

# ╔═╡ 53c3cf44-7b02-11ec-1eea-bff6bcaf2210
md"""The last line uses the linearity of $dF$ to isolate $dF_{G(a)} \cdot (dG_a \cdot \vec{h})$. Factoring out $\vec{h}$ and taking norms gives:
"""

# ╔═╡ 53c3cf4e-7b02-11ec-32e8-8d6a1ba676df
md"""```math
\begin{align*}
\frac{\| F(G(a+\vec{h})) - F(G(a)) - dF_{G(a)}dG_a \cdot \vec{h} \|}{\| \vec{h} \|} &=
\frac{\|  dF_{G(a)}\cdot(\epsilon_G\vec{h}) + \epsilon_F (dG_a\cdot \vec{h}) + (\epsilon_F\cdot\epsilon_G\vec{h}) \|}{\| \vec{h} \|} \\
&\leq \|  dF_{G(a)}\cdot\epsilon_G + \epsilon_F (dG_a) + \epsilon_F\cdot\epsilon_G \|\frac{\|\vec{h}\|}{\| \vec{h} \|}\\
&\rightarrow 0.
\end{align*}
```
"""

# ╔═╡ 53c3cf6e-7b02-11ec-274b-878d4cbee6c8
md"""### Examples
"""

# ╔═╡ 53c3cf80-7b02-11ec-2a70-55c8f8e47c37
md"""Our main use of the total derivative will be the change of variables in integration.
"""

# ╔═╡ 53c6963e-7b02-11ec-241e-4d7ec80a2d90
md"""##### Example: polar coordinates
"""

# ╔═╡ 53c696c0-7b02-11ec-1ef3-37fa6da339b6
md"""A point $(a,b)$ in the plane can be described in polar coordinates by a radius $r$ and polar angle $\theta$. We can express this formally by $F:(a,b) \rightarrow (r, \theta)$ with
"""

# ╔═╡ 53c696ea-7b02-11ec-1b6a-eff54cb61394
md"""```math
r(a,b) = \sqrt{a^2 + b^2}, \quad
\theta(a,b) = \tan^{-1}(b/a),
```
"""

# ╔═╡ 53c69724-7b02-11ec-1956-51add25ae024
md"""the latter assuming the point is in quadrant I or IV (though `atan(y,x)` will properly handle the other quadrants). The Jacobian of this transformation may be found with
"""

# ╔═╡ 53c69e72-7b02-11ec-148c-511ac0b5baf3
begin
	@syms a::real b::real
	
	rⱼ = sqrt(a^2 + b^2)
	θⱼ = atan(b/a)
	
	Jac = Sym[diff.(rⱼ, [a,b])';        # [∇f_1'; ∇f_2']
	          diff.(θⱼ, [a,b])']
	
	simplify.(Jac)
end

# ╔═╡ 53c7d258-7b02-11ec-2f47-414fd02424cf
md"""`SymPy` array objects have a `jacobian` method to make this easier to do. The calling style is Python-like, using `object.method(...)`:
"""

# ╔═╡ 53c7d754-7b02-11ec-1b19-f7c73f8095fd
[rⱼ, θⱼ].jacobian([a, b])

# ╔═╡ 53c7d792-7b02-11ec-3975-87a54fd7a345
md"""The determinant, of geometric interest, will be
"""

# ╔═╡ 53c7d9cc-7b02-11ec-0e61-df85493801c7
det(Jac) |> simplify

# ╔═╡ 53c7d9ea-7b02-11ec-0d62-950399482c02
md"""The determinant is of interest, as the linear mapping represented by the Jacobian changes the area of the associated coordinate vectors. The determinant describes ow this area changes, as a multiplying factor.
"""

# ╔═╡ 53c7da12-7b02-11ec-1a21-71cea9773f07
md"""##### Example Spherical Coordinates
"""

# ╔═╡ 53c7da24-7b02-11ec-0eac-6f327bc6d18e
md"""In 3 dimensions a point can be described by (among other ways):
"""

# ╔═╡ 53c7db98-7b02-11ec-13a6-ed5e8081864a
md"""  * Cartesian coordinates: three coordinates relative to the $x$, $y$, and $z$ axes as $(a,b,c)$.
  * Spherical coordinates: a radius, $r$, an azimuthal angle $\theta$, and a polar angle $\phi measured down from the $z$ axes.  (We use the mathematics naming convention, the physics one has $\phi$ and $\theta$ reversed.)
  * Cylindrical coordinates: a radius, $r$, a polar angle $\theta$, and height $z$.
"""

# ╔═╡ 53c7dbac-7b02-11ec-2edf-3db2075f6ffd
md"""Some mappings are:
"""

# ╔═╡ 53c7dd28-7b02-11ec-1a04-01a505578e40
md"""| Cartesian (x,y,z) | Spherical ($r$, $\theta$, $\phi$) | Cylindrical ($r$, $\theta$, $z$) |
|:-----------------:|:---------------------------------:|:--------------------------------:|
|     (1, 1, 0)     |    $(\sqrt{2}, \pi/4, \pi/2)$     |      $(\sqrt{2},\pi/4, 0)$       |
|     (0, 1, 1)     |      $(\sqrt{2}, 0, \pi/4)$       |        $(\sqrt{2}, 0, 1)$        |
"""

# ╔═╡ 53c7dd50-7b02-11ec-09c9-d52c9eb81452
md"""---
"""

# ╔═╡ 53c7dd66-7b02-11ec-05f0-0f1712ec6715
md"""Formulas can be found to convert between the different systems, here are a few written as multivariable functions:
"""

# ╔═╡ 53c7ead4-7b02-11ec-2cbc-45daa9a176d8
begin
	function spherical_from_cartesian(x,y,z)
	    r = sqrt(x^2 + y^2 + z^2)
	    theta = atan(y/x)
	    phi = acos(z/r)
	    [r, theta, phi]
	end
	
	function cartesian_from_spherical(r, theta, phi)
	    x = r*sin(phi)*cos(theta)
	    y = r*sin(phi)*sin(theta)
	    z = r*cos(phi)
	    [x, y, z]
	end
	
	function cylindrical_from_cartesian(x, y, z)
	    r = sqrt(x^2 + y^2)
	    theta = atan(y/x)
	    z = z
	    [r, theta, z]
	end
	
	function cartesian_from_cylindrical(r, theta, z)
	    x = r*cos(theta)
	    y = r*sin(theta)
	    z = z
	    [x, y, z]
	end
	
	spherical_from_cartesian(v) = spherical_from_cartesian(v...)
	cartesian_from_spherical(v) = cartesian_from_spherical(v...)
	cylindrical_from_cartesian(v)= cylindrical_from_cartesian(v...)
	cartesian_from_cylindrical(v) = cartesian_from_cylindrical(v...)
end

# ╔═╡ 53c7eaf2-7b02-11ec-2c40-a78139b1d41a
md"""The Jacobian of a transformation can be found from these conversions. For example, the conversion from spherical to cartesian would have Jacobian computed by:
"""

# ╔═╡ 53c7ee94-7b02-11ec-119e-cbb400c44b6e
begin
	@syms r::real
	
	ex1 = cartesian_from_spherical(r, theta, phi)
	J1 = ex1.jacobian([r, theta, phi])
end

# ╔═╡ 53c7eeb2-7b02-11ec-2f6a-4fa31102baa4
md"""This has determinant:
"""

# ╔═╡ 53c7f0c4-7b02-11ec-17f3-1da4ca041e4c
det(J1) |> simplify

# ╔═╡ 53c7f100-7b02-11ec-0828-5fc9483c6806
md"""There is no function to convert from spherical to cylindrical above, but clearly one can be made by *composition*:
"""

# ╔═╡ 53c7f614-7b02-11ec-307f-057b0068b0ee
begin
	cylindrical_from_spherical(r, theta, phi) =
	    cylindrical_from_cartesian(cartesian_from_spherical(r, theta, phi)...)
	cylindrical_from_spherical(v) = cylindrical_from_spherical(v...)
end

# ╔═╡ 53c7f628-7b02-11ec-02e1-a37454ea9cfe
md"""From this composition, we could compute the Jacobian directly, as with:
"""

# ╔═╡ 53c7f9a2-7b02-11ec-2ceb-33e857451efb
begin
	ex2 = cylindrical_from_spherical(r, theta, phi)
	J2 = ex2.jacobian([r, theta, phi])
end

# ╔═╡ 53c7f9d4-7b02-11ec-090c-e7de0ac7445a
md"""Now to see that this last expression could have been found by the *chain rule*. To do this we need to find the Jacobian of each function; evaluate them at the proper places; and, finally, multiply the matrices. The `J1` object, found above, does one Jacobian. We now need to find that of `cylindrical_from_cartesian`:
"""

# ╔═╡ 53c7fe7a-7b02-11ec-1605-211878be018e
begin
	@syms x::real y::real z::real
	ex3 = cylindrical_from_cartesian(x, y, z)
	J3 = ex3.jacobian([x,y,z])
end

# ╔═╡ 53c7feac-7b02-11ec-0e4a-0f662ce803a4
md"""The chain rule is not simply `J3 * J1` in the notation above, as the `J3` matrix must be evaluated at "`G(a)`", which is `ex1` from above:
"""

# ╔═╡ 53c805e6-7b02-11ec-1f9b-11e5ee335db0
J3_Ga = subs.(J3, x .=> ex1[1], y .=> ex1[2], z .=> ex1[3]) .|> simplify  # the dots are important

# ╔═╡ 53c80604-7b02-11ec-2002-c73d4eb037bf
md"""The chain rule now says this product should be equivalent to `J2` above:
"""

# ╔═╡ 53c80744-7b02-11ec-2df8-ff98cd58d4c9
J3_Ga * J1

# ╔═╡ 53c80758-7b02-11ec-1715-b3b36714592c
md"""The two are equivalent after simplification, as seen here:
"""

# ╔═╡ 53c80956-7b02-11ec-0ec2-8b6b1d6d1451
J3_Ga * J1 - J2 .|> simplify

# ╔═╡ 53c8097e-7b02-11ec-3d95-83fc2c8ffd63
md"""##### Example
"""

# ╔═╡ 53c809a6-7b02-11ec-37da-99f8ef56c978
md"""The above examples were done symbolically. Performing the calculation numerically is quite similar. The `ForwardDiff` package has a gradient function to find the gradient at a point. The `CalculusWithJulia` package extends this to take a gradient of a function and return a function, also called `gradient`. This is defined along the lines of:
"""

# ╔═╡ 53c809cc-7b02-11ec-15f3-b34c04aee89a
md"""```
gradient(f::Function) = x -> ForwardDiff.gradient(f, x)
```"""

# ╔═╡ 53c809d8-7b02-11ec-2b53-cfff4e7fadff
md"""(though more flexibly, as either  vector or a separate arguments can be used.)
"""

# ╔═╡ 53c809f6-7b02-11ec-0541-1dbab65415ab
md"""With this, defining a Jacobian function *could* be done like:
"""

# ╔═╡ 53c80a0a-7b02-11ec-3a89-5116cea8604a
md"""```
function Jacobian(F, x)
    n = length(F(x...))
    grads = [gradient(x -> F(x...)[i])(x) for i in 1:n]
    vcat(grads'...)
end
```"""

# ╔═╡ 53c80a30-7b02-11ec-2e78-c307ffff7e93
md"""But, like `SymPy`, `ForwardDiff` provides a `jacobian` function directly, so we will use that; it requires a function definition where a vector is passed in and is called by `ForwardDiff.jacobian`. (The `ForwardDiff` package does not export its methods, they are qualified using the module name.)
"""

# ╔═╡ 53c80a3c-7b02-11ec-2bb3-bfafd972b1b9
md"""Using the above functions, we can verify the last example at a point:
"""

# ╔═╡ 53c80fe6-7b02-11ec-1057-3b3203793e9f
begin
	rtp = [1, pi/3, pi/4]
	ForwardDiff.jacobian(cylindrical_from_spherical, rtp)
end

# ╔═╡ 53c81004-7b02-11ec-2a69-592eadc67998
md"""The chain rule gives the same answer up to roundoff error:
"""

# ╔═╡ 53c8134c-7b02-11ec-04ec-b53595a29f8b
ForwardDiff.jacobian(cylindrical_from_cartesian, cartesian_from_spherical(rtp)) * ForwardDiff.jacobian(cartesian_from_spherical, rtp)

# ╔═╡ 53c81372-7b02-11ec-0fe9-e104e0a3f5bb
md"""##### Example: The Inverse Function Theorem
"""

# ╔═╡ 53c813ba-7b02-11ec-200a-e9b45ab29f3b
md"""For a change of variable problem, $F:R^n \rightarrow R^n$, the determinant of the Jacobian quantifies how volumes get modified under the transformation. When this determinant is *non*zero, then more can be said. The [Inverse Function Theorem](https://en.wikipedia.org/wiki/Inverse_function_theorem) states
"""

# ╔═╡ 53cb7442-7b02-11ec-1ebb-39a3326cc052
md"""> if  $F$ is a continuously differentiable function from an open set of $R^n$ into $R^n$and the total derivative is invertible at a point $p$ (i.e., the Jacobian determinant of $F$ at $p$ is non-zero), then $F$ is invertible near $p$. That is, an inverse function to $F$ is defined on some neighborhood of $q$, where $q=F(p)$. Further, $F^{-1}$ will be continuously differentiable at $q$ with $J_{F^{-1}}(q) = [J_F(p)]^{-1}$, the latter being the matrix inverse. Taking determinants, $\det(J_{F^{-1}}(q)) = 1/\det(J_F(p))$.

"""

# ╔═╡ 53cb7492-7b02-11ec-2729-1b2a56eac959
md"""Assuming $F^{-1}$ exists, we can verify the last part from the chain rule, in an identical manner to the univariate case, starting with $F^{-1} \circ F$ being the identity, we would have:
"""

# ╔═╡ 53cb74c4-7b02-11ec-0735-27b8a13e5476
md"""```math
J_{F^{-1}\circ F}(p) = I,
```
"""

# ╔═╡ 53cb74f6-7b02-11ec-20d5-39718e7136f6
md"""where $I$ is the *identity* matrix with entry $a_{ij} = 1$ when $i=j$ and $0$ otherwise.
"""

# ╔═╡ 53cb750a-7b02-11ec-3e8e-2159771a6664
md"""But the chain rule then says $J_{F^{-1}}(F(p)) J_F(p) = I$. This implies the two matrices are inverses to each other, and using the multiplicative mapping property of the determinant will also imply the determinant relationship.
"""

# ╔═╡ 53cb751c-7b02-11ec-31a5-4d7c5650eabc
md"""The theorem is an existential theorem, in that it implies $F^{-1}$ exists, but doesn't indicate how to find it. When we have an inverse though, we can verify the properties implied.
"""

# ╔═╡ 53cb7528-7b02-11ec-07cd-513b4ce34d36
md"""The transformation examples have inverses indicated. Using one of these we can verify things at a point, as done in the following:
"""

# ╔═╡ 53cb7fdc-7b02-11ec-3d88-0b904895e460
begin
	p = [1, pi/3, pi/4]
	q = cartesian_from_spherical(p)
	
	A1 = ForwardDiff.jacobian(spherical_from_cartesian, q)    # J_F⁻¹(q)
	A2 = ForwardDiff.jacobian(cartesian_from_spherical, p)    # J_F(p)
	
	A1 * A2
end

# ╔═╡ 53cb7ff8-7b02-11ec-1716-87a6eb806172
md"""Up to roundoff error, this is the identity matrix. As for the relationship between the determinants, up to roundoff error the two are related, as expected:
"""

# ╔═╡ 53cb8356-7b02-11ec-0242-0f2c2654b5e7
det(A1), 1/det(A2)

# ╔═╡ 53cb837e-7b02-11ec-2e64-5f10cf020e32
md"""##### Example: Implicit Differentiation, the Implicit Function Theorem
"""

# ╔═╡ 53cb83c4-7b02-11ec-0e36-832100a239d1
md"""The technique of *implicit differentiation* is a useful one, as it allows derivatives of more complicated expressions to be found. The main idea, expressed here with three variables is if an equation may be viewed as $F(x,y,z) = c$, $c$ a constant, then $z=\phi(x,y)$ may be viewed as a function of $x$ and $y$. Hence, we can use the chain rule to find: $\partial z / \partial x$ and $\partial z /\partial x$. Let $G(x,y) = \langle x, y, \phi(x,y) \rangle$ and then differentiation $(F \circ G)(x,y) = c$:
"""

# ╔═╡ 53cb83e2-7b02-11ec-1daf-2b035a889f3f
md"""```math
\begin{align*}
0 &= dF_{G(x,y)} \circ dG_{\langle x, y\rangle}\\
&= [\frac{\partial F}{\partial x}\quad \frac{\partial F}{\partial y}\quad \frac{\partial F}{\partial z}](G(x,y)) \cdot
\left[\begin{array}{}
1 & 0\\
0 & 1\\
\frac{\partial \phi}{\partial x} & \frac{\partial \phi}{\partial y}
\end{array}\right].
\end{align*}
```
"""

# ╔═╡ 53cb83ec-7b02-11ec-0624-ad476b87cdc9
md"""Solving yields
"""

# ╔═╡ 53cb83fe-7b02-11ec-19ba-b5aafb136c7f
md"""```math
\frac{\partial \phi}{\partial x} = -\frac{\partial F/\partial x}{\partial F/\partial z},\quad
\frac{\partial \phi}{\partial y} = -\frac{\partial F/\partial y}{\partial F/\partial z}.
```
"""

# ╔═╡ 53cb8414-7b02-11ec-1b07-eb56f5f542a6
md"""Where the right hand side of each is evaluated at $G(x,y)$.
"""

# ╔═╡ 53cb8428-7b02-11ec-25cb-bb6ac55f15f2
md"""When can it be reasonably assumed that such a function $z= \phi(x,y)$ exists?
"""

# ╔═╡ 53cb8450-7b02-11ec-32a1-217002c34b6e
md"""The [Implicit Function Theorem](https://en.wikipedia.org/wiki/Implicit_function_theorem) provides a statement (slightly abridged here):
"""

# ╔═╡ 53cb854a-7b02-11ec-3009-bf81e36ebfc0
md"""> Let $F:R^{n+m} \rightarrow R^m$ be a continuously differentiable function and let $R^{n+m}$ have (compactly defined) coordinates $\langle \vec{x}, \vec{y} \rangle$, Fix a point $\langle \vec{a}, \vec{b} \rangle$ with $F(\vec{a}, \vec{b}) = \vec{0}$. Let $J_{F, \vec{y}}(\vec{a}, \vec{b})$ be the Jacobian restricted to *just* the $y$ variables. ($J$ is $m \times m$.) If this matrix has non-zero determinant (it is invertible), then there exists an open set $U$ containing $\vec{a}$ and a *unique* continuously differentiable function $G: U \subset R^n \rightarrow R^m$ such that $G(\vec{a}) = \vec{b}$, $F(\vec{x}, G(\vec{x})) = 0$ for $\vec x$ in $U$. Moreover, the partial derivatives of $G$ are given by the matrix product:

"""

# ╔═╡ 53cb8554-7b02-11ec-3737-971e05333250
md"""```math
\frac{\partial G}{\partial x_j}(\vec{x}) = - [J_{F, \vec{y}}(x, F(\vec{x}))]^{-1} \left[\frac{\partial F}{\partial x_j}(x, G(\vec{x}))\right].
```
"""

# ╔═╡ 53cb857c-7b02-11ec-0ab8-696d3bb0d6d2
md"""---
"""

# ╔═╡ 53cb8598-7b02-11ec-28bd-fbf47a187b11
md"""Specializing to our case above, we have $f:R^{2+1}\rightarrow R^1$ and $\vec{x} = \langle a, b\rangle$ and $\phi:R^2 \rightarrow R$. Then
"""

# ╔═╡ 53cb85a4-7b02-11ec-36ad-27a4fc10cbee
md"""```math
[J_{f, \vec{y}}(x, g(\vec{x}))] = [\frac{\partial f}{\partial z}(a, b, \phi(a,b)],
```
"""

# ╔═╡ 53cb85b8-7b02-11ec-374b-2997527adae5
md"""a $1\times 1$ matrix, identified as a scalar, so inversion is just the reciprocal. So the formula, becomes, say for $x_1 = x$:
"""

# ╔═╡ 53cb85cc-7b02-11ec-367d-99924012b215
md"""```math
\frac{\partial \phi}{\partial x}(a, b) = - \frac{\frac{\partial{f}}{\partial{x}}(a, b,\phi(a,b))}{\frac{\partial{f}}{\partial{z}}(a, b, \phi(a,b))},
```
"""

# ╔═╡ 53cb85e0-7b02-11ec-08e5-a70eae2dd71b
md"""as expressed above. Here invertibility is simply a non-zero value, and is needed for the division. In general, we see inverse (the $J^{-1}$) is necessary to express the answer.
"""

# ╔═╡ 53cb85ea-7b02-11ec-3867-d5d6ba78a308
md"""Using this, we can answer questions like the following (as we did before) on a more solid ground:
"""

# ╔═╡ 53cb85fe-7b02-11ec-0fae-c509ee48d8e0
md"""Let $x^2/a^2 + y^2/b^2 + z^2/c^2 = 1$ be an equation describing an ellipsoid. Describe the tangent plane at a point on the ellipse.
"""

# ╔═╡ 53cb860a-7b02-11ec-3cd8-85567c30c0fc
md"""We would like to express the tangent plane in terms of $\partial{z}/\partial{x}$ and $\partial{z}/\partial{y}$, which we can do through:
"""

# ╔═╡ 53cb861c-7b02-11ec-0e50-bd38fd3c306e
md"""```math
\frac{2x}{a^2} + \frac{2z}{c^2} \frac{\partial{z}}{\partial{x}} = 0, \quad
\frac{2y}{a^2} + \frac{2z}{c^2} \frac{\partial{z}}{\partial{y}} = 0.
```
"""

# ╔═╡ 53cb8626-7b02-11ec-1eb7-d16883561645
md"""Solving, we get
"""

# ╔═╡ 53cb8630-7b02-11ec-27cd-154c6bafb8b1
md"""```math
\frac{\partial{z}}{\partial{x}} = -\frac{2x}{a^2}\frac{c^2}{2z},
\quad
\frac{\partial{z}}{\partial{y}} = -\frac{2y}{a^2}\frac{c^2}{2z},
```
"""

# ╔═╡ 53cca844-7b02-11ec-21e3-bbc23eee0d21
md"""*provided* $z \neq 0$. At $z=0$ the tangent plane exists, but we can't describe it in this manner, as it is vertical. However, the choice of variables to use is not fixed in the theorem, so if $x \neq 0$ we can express $x = x(y,z)$ and express the tangent plane in terms of $\partial{x}/\partial{y}$ and $\partial{x}/\partial{z}$. The answer is similar to the above, and we won't repeat. Similarly, should $x = z = 0$, the $y \neq 0$ and we can use an implicit definition $y = y(x,z)$ and express the tangent plane through  $\partial{y}/\partial{x}$ and $\partial{y}/\partial{z}$.
"""

# ╔═╡ 53cca8bc-7b02-11ec-16b3-b3389875c7fe
md"""##### Example: Lagrange multipliers in more dimensions
"""

# ╔═╡ 53cca90c-7b02-11ec-003d-e7fafd602bd6
md"""Consider now the problem of maximizing $f:R^n \rightarrow R$ subject to $k < n$ constraints $g_1(\vec{x}) = c_1, g_2(\vec{x}) = c_2, \dots, g_{k}(\vec{x}) = c_{k}$. For $n=1$ and $2$, we saw that if all derivatives exist, then a *necessary* condition to be at a maximum is that $\nabla{f}$ can be written as $\lambda_1 \nabla{g_1}$ ($n=1$) or $\lambda_1 \nabla{g_1} + \lambda_2 \nabla{g_2}$. The key observation is that the gradient of $f$ must have no projection on the intersection of the tangent planes found by linearizing $g_i$.
"""

# ╔═╡ 53cca92a-7b02-11ec-3a00-6529601eef66
md"""The same thing holds in dimension $n > 2$: Let $\vec{x}_0$ be a point where $f(\vec{x})$ is maximum subject to the $p$ constraints. We want to show that $\vec{x}_0$ must satisfy:
"""

# ╔═╡ 53cca948-7b02-11ec-3e4f-095e06462d95
md"""```math
\nabla{f}(\vec{x}_0) = \sum \lambda_i \nabla{g_i}(\vec{x}_0).
```
"""

# ╔═╡ 53cca95c-7b02-11ec-0e61-8bc35a4baf3a
md"""By considering $-f$, the same holds for a minimum.
"""

# ╔═╡ 53cca982-7b02-11ec-006f-577f484d033d
md"""We follow the sketch of [Sawyer](https://www.math.wustl.edu/~sawyer/handouts/LagrangeMult.pdf).
"""

# ╔═╡ 53cca998-7b02-11ec-23a0-e3aead5a70a2
md"""Using Taylor's theorem, we have $f(\vec{x} + h \vec{y}) = f(\vec{x}) + h \vec{y}\cdot\nabla{f} + h^2\vec{c}$, for some $\vec{c}$. If $h$ is small enough, this term can be ignored.
"""

# ╔═╡ 53cca9ca-7b02-11ec-3f44-25a73c80e729
md"""The tangent "plane" for each constraint, $g_i(\vec{x}) = c_i$, is orthogonal to the gradient vector $\nabla{g_i}(\vec{x})$. That is, $\nabla{g_i}(\vec{x})$ is orthogonal to the level-surface formed by the constraint $g_i(\vec{x}) = 0$. Let $A$ be the set of all *linear* combinations of $\nabla{g_i}$, that are possible: $\lambda_1 g_1(\vec{x}) + \lambda_2 g_2(\vec{x}) + \cdots + \lambda_p g_p(\vec{x})$, as in the statement. Through projection, we can write $\nabla{f}(\vec{x}_0) = \vec{a} + \vec{b}$, where $\vec{a}$ is in $A$ and $\vec{b}$ is *orthogonal* to $A$.
"""

# ╔═╡ 53cca9f2-7b02-11ec-21ff-e1e964f3943d
md"""Let $\vec{r}(t)$ be a parameterization of a path through the intersection of the $p$ tangent planes that goes through $\vec{x}_0$ at $t_0$ *and* $\vec{b}$ is parallel to  $\vec{x}_0'(t_0)$. (The implicit function theorem would guarantee this path.)
"""

# ╔═╡ 53ccaa1a-7b02-11ec-03b0-6d0b7b13cd61
md"""If we consider $f(\vec{x}_0 + h \vec{b})$ for small $h$, then unless $\vec{b} \cdot \nabla{f} = 0$, the function would increase in the direction of $\vec{b}$ due to the $h \vec{b}\cdot\nabla{f}$ term in the approximating Taylor series. That is, $\vec{x}_0$ would not be a maximum on the constraint. So at $\vec{x}_0$ this directional derivative is $0$.
"""

# ╔═╡ 53ccaa2e-7b02-11ec-2f13-296f90b103ed
md"""Then we have the directional derivative in the direction of $b$ is $\vec{0}$, as the gradient
"""

# ╔═╡ 53ccaa38-7b02-11ec-3a31-7df228109ac8
md"""```math
\vec{0} = \vec{b} \cdot \nabla{f}(\vec{x}_0) = \vec{b} \cdot (\vec{a} + \vec{b}) = \vec{b}\cdot \vec{a} + \vec{b}\cdot\vec{b} = \vec{b}\cdot\vec{b},
```
"""

# ╔═╡ 53ccaa4c-7b02-11ec-36a5-7f6f56fc8593
md"""or $\| \vec{b} \| = 0$ and $\nabla{f}(\vec{x}_0)$ must lie in the plane $A$.
"""

# ╔═╡ 53ccaa58-7b02-11ec-02d4-8d7ca99d9ccd
md"""---
"""

# ╔═╡ 53ccaa74-7b02-11ec-2e59-f1b5b2a589bc
md"""How does the implicit function theorem guarantee a parameterization of a curve along the constraint in the direction of $b$?
"""

# ╔═╡ 53ccaaea-7b02-11ec-326f-b9fc59637e4e
md"""A formal proof requires a bit of linear algebra, but here we go. Let $G(\vec{x}) = \langle g_1(\vec{x}), g_2(\vec{x}), \dots, g_k(\vec{x}) \rangle$. Then $G(\vec{x}) = \vec{c}$ encodes the constraint. The tangent planes are orthogonal to each $\nabla{g_i}$, so using matrix notation, the intersection of the tangent planes is any vector $\vec{h}$ satisfying $J_G(\vec{x}_0) \vec{h} = 0$. Let $k = n - 1 - p$. If $k > 0$, there will be $k$ vectors *orthogonal* to each of $\nabla{g_i}$ and $\vec{b}$. Call these $\vec{v}_j$. Then define additional constraints $h_j(\vec{x}) = \vec{v}_j \cdot \vec{x} = 0$. Let $H(x1, x2, \dots, x_n) = \langle g_1, g_2, \dots, g_p, h_1, \dots, h_{n-1-p}\rangle$. $H:R^{1 + (n-1)} \rightarrow R^{n-1}$. Let $H(x1, \dots, x_n) = H(x, \vec{y})$ The $H$ *restricted* to the $\vec{y}$ variables is a function from $R^{n-1}\rightarrow R^{n-1}$. *If* this restricted function has a Jacobian with non-zero determinant, then there exists a $\vec\phi(x): R \rightarrow R^{n-1}$ with $H(x, \vec\phi(x)) = \vec{c}$. Let $\vec{r}(t) = \langle t, \phi_1(t), \dots, \phi_{n-1}(t)\rangle$. Then $(H\circ\vec{r})(t) = \vec{c}$, so by the chain rule $d_H(\vec{r}) d\vec{r} = 0$. But $dH = [\nabla{g_1}'; \nabla{g_2}' \dots;\nabla{g_p}', v_1';\dots;v_{n-1-p}']$ (A matrix of row vectors). The condition $dH(\vec{r}) d\vec{r} = \vec{0}$ is equivalent to saying $d\vec{r}$ is *orthogonal* to the row vectors in $dH$. A *basis* for $R^n$ are these vectors and $\vec{b}$, so $\vec{r}$ and $\vec{b}$ must be parallel.
"""

# ╔═╡ 53ccab00-7b02-11ec-0ca4-47a235aaf99d
md"""##### Example
"""

# ╔═╡ 53ccab14-7b02-11ec-06c3-91c22ed37821
md"""We apply this to two problems, also from Sawyer. First, let $n > 1$ and $f(x_1, \dots, x_n) = \sum x_i^2$. Minimize this subject to the constraint $\sum x_i = 1$. This one constraint means an answer must satisfy $\nabla{L} = \vec{0}$ where
"""

# ╔═╡ 53ccab28-7b02-11ec-12c0-a739c792e016
md"""```math
L(x_1, \dots, x_n, \lambda) = \sum x_i^2 + \lambda \sum x_i - 1.
```
"""

# ╔═╡ 53ccab46-7b02-11ec-21c6-158b92543fb6
md"""Taking $\partial/\partial{x_i}$ we have $2x_i + \lambda = 0$, so $x_i = \lambda/2$, a constant. From the constraint, we see $x_i = 1/n$. This does not correspond to a  maximum, but a minimum. A maximum would be at point on the constraint such as $\langle 1, 0, \dots, 0\rangle$, which gives a value of $1$ for $f$, not $n \times 1/n^2 = 1/n$.
"""

# ╔═╡ 53ccab50-7b02-11ec-34bf-23bcae366f01
md"""##### Example
"""

# ╔═╡ 53ccab82-7b02-11ec-1001-01157cfdc62a
md"""In statistics, there are different ways to define the best estimate for a population parameter based on the data. That is, suppose $X_1, X_2, \dots, X_n$ are random variables. The population parameters of interest here are the mean $E(X_i) = \mu$ and the variance $Var(X_i) = \sigma_i^2$. (The mean is assumed to be the same for all, but the variance need not be.) What should someone use to *estimate* $\mu$ using just the sample values $X_1, X_2, \dots, X_n$? The average, $(X_1 + \cdots + X_n)/n$ is a well known estimate, but is it the "best" in some sense for this set up? Here some variables are more variable, should they count the same, more, or less in the weighting for the estimate?
"""

# ╔═╡ 53ccab96-7b02-11ec-3317-2ba040211497
md"""In Sawyer, we see an example of applying the Lagrange multiplier method to the best linear unbiased estimator (BLUE).  The BLUE is a choice of coefficients $a_i$ such that $Var(\sum a_i X_i)$ is smallest subject to the constraint $E(\sum a_i X_i) = \mu$.
"""

# ╔═╡ 53ccabc0-7b02-11ec-3353-ed479e018ccd
md"""The BLUE *minimizes* the *variance* of the estimator. (This is the *B*est part of BLUE). The estimator, $\sum a_i X_i$, is *L*inear. The constraint is that the estimator has theoretical mean given by $\mu$. (This is the *Un*biased part of BLUE.)
"""

# ╔═╡ 53ccabd2-7b02-11ec-1954-c98bca66e094
md"""Going from statistics to mathematics, we use formulas for *independent* random variables to restate this problem mathematically as:
"""

# ╔═╡ 53ccabdc-7b02-11ec-1447-ed4537b7bb72
md"""```math
\text{Minimize } \sum a_i^2 \sigma_i^2 \text{ subject to } \sum a_i = 1.
```
"""

# ╔═╡ 53ccabf2-7b02-11ec-3c3b-314529151c14
md"""This problem is similar now to the last one, save the sum to minimize includes the sigmas. Set $L = \sum a_i^2 \sigma_i^2  + \lambda\sum a_i - 1$
"""

# ╔═╡ 53ccac04-7b02-11ec-39d9-b588a3ed6f75
md"""Taking $\partial/\partial{a_i}$ gives equations $2a_i\sigma_i^2 + \lambda = 0$, $a_i = -\lambda/(2\sigma_i^2) = c/\sigma_i^2$. The constraint implies $c = 1/\sum(1/\sigma_i)^2$. So variables with *more* variance, get smaller weights.
"""

# ╔═╡ 53ccac18-7b02-11ec-15a3-596778221380
md"""For the special case of a common variance, $\sigma_i=\sigma$, the above simplifies to $a_i = 1/n$ and the estimator is $\sum X_i/n$, the familiar sample mean, $\bar{X}$.
"""

# ╔═╡ 53ccac4a-7b02-11ec-0cb8-f5448c6966ab
md"""## Questions
"""

# ╔═╡ 53cf4a04-7b02-11ec-2e69-17964824ac1f
md"""###### Question
"""

# ╔═╡ 53cf4a5e-7b02-11ec-26dc-31659fce01de
md"""The following plots a surface defined by a (hidden) function $F: R^2 \rightarrow R^3$:
"""

# ╔═╡ 53cf526a-7b02-11ec-1610-b15bf0c8c30b
𝑭(u, v) = [u*cos(v), u*sin(v), 2v]

# ╔═╡ 53cf5bca-7b02-11ec-24dc-3587a128ef3f
let
	us, vs = range(0, 1, length=25), range(0, 2pi, length=25)
	xs, ys, zs = unzip(𝑭.(us, vs'))
	surface(xs, ys, zs)
end

# ╔═╡ 53cf5bfc-7b02-11ec-09b6-61bce80900c7
md"""Is this the surface generated by $F(u,v) = \langle u\cos(v), u\sin(v), 2v\rangle$? This function's surface is termed a helicoid.
"""

# ╔═╡ 53cf5daa-7b02-11ec-1754-2f0a665aad69
let
	yesnoq(true)
end

# ╔═╡ 53cf5dd2-7b02-11ec-01fe-93502de5f335
md"""###### Question
"""

# ╔═╡ 53cf5dfa-7b02-11ec-3df4-2f6ae4653f00
md"""The following plots a surface defined by a (hidden) function $F: R^2 \rightarrow R^3$ of the form $F(u,v) = \langle r(u)\cos(v), r(u)\sin(v), u\rangle$
"""

# ╔═╡ 53cf62d2-7b02-11ec-29cb-f3608e68deb8
begin
	𝓇ad(u) = 1 + u^2
	ℱ(u, v) = [𝓇ad(u)*cos(v), 𝓇ad(u)*sin(v), u]
end

# ╔═╡ 53cf6b30-7b02-11ec-38f1-eb669acb5fbe
let
	us, vs = range(-1, 1, length=25), range(0, 2pi, length=25)
	xs, ys, zs = unzip(ℱ.(us, vs'))
	surface(xs, ys, zs)
end

# ╔═╡ 53cf6b56-7b02-11ec-1e62-5168d4c3c443
md"""Is this the surface generated by $r(u) = 1+u^2$? This form of a function is for a surface of revolution about the $z$ axis.
"""

# ╔═╡ 53cf6cdc-7b02-11ec-06d0-9348a1233b9f
let
	yesnoq(true)
end

# ╔═╡ 53cf6cf0-7b02-11ec-106d-8dae9fc75cf0
md"""###### Question
"""

# ╔═╡ 53cf6d2a-7b02-11ec-19d8-67df83a52b40
md"""The transformation $F(x, y) = \langle 2x + 3y + 1, 4x + y + 2\rangle$ is an example of an affine transformation. Is this the *Jacobian* of $F$
"""

# ╔═╡ 53cf6d54-7b02-11ec-282e-75f985c370a2
md"""```math
J = \left[
\begin{array}{}
2 & 4\\
3 & 1
\end{array}
\right].
```
"""

# ╔═╡ 53cf72b8-7b02-11ec-2b7f-59fe83363d8d
let
	choices = [
	"Yes",
	"No, it is the transpose"
	]
	ans=2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 53cf72ca-7b02-11ec-17c0-016d0a45b733
md"""###### Question
"""

# ╔═╡ 53cf72ea-7b02-11ec-373e-eff13ba718ed
md"""Does the transformation $F(u,v) = \langle u^2 - v^2, u^2 + v^2 \rangle$ have Jacobian
"""

# ╔═╡ 53cf72fc-7b02-11ec-086c-7d094a4cbd5f
md"""```math
J = \left[
\begin{array}{}
2u & -2v\\
2u & 2v
\end{array}
\right]?
```
"""

# ╔═╡ 53cf7838-7b02-11ec-353d-1fe883064e48
let
	choices = [
	"Yes",
	"No, it is the transpose"
	]
	ans=1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 53cf7858-7b02-11ec-1c87-2b456504d32d
md"""###### Question
"""

# ╔═╡ 53cf7880-7b02-11ec-27f2-5b7adbb40d85
md"""Fix constants $\lambda_0$ and $\phi_0$ and define a transformation
"""

# ╔═╡ 53cf7894-7b02-11ec-2f27-5bfec76076ec
md"""```math
F(\lambda, \phi) = \langle \cos(\phi)\sin(\lambda - \lambda_0),
\cos(\phi_0)\sin(\phi) - \sin(\phi_0)\cos(\phi)\cos(\lambda - \lambda_0) \rangle
```
"""

# ╔═╡ 53cf78bc-7b02-11ec-07d0-1fdced22d2b3
md"""What does the following `SymPy` code compute?
"""

# ╔═╡ 53cf7d58-7b02-11ec-2557-e719dbf31cd1
let
	@syms lambda lambda_0 phi phi_0
	F(lambda,phi) = [cos(phi)*sin(lambda-lambda_0), cos(phi_0)*sin(phi) - sin(phi_0)*cos(phi)*cos(lambda-lambda_0)]
	
	out = [diff.(F(lambda, phi), lambda) diff.(F(lambda, phi), phi)]
	det(out) |> simplify
end

# ╔═╡ 53cf853c-7b02-11ec-3b8a-51b8705d68d7
let
	choices = [
	"The determinant of the Jacobian.",
	"The determinant of the Hessian.",
	"The determinant of the gradient."
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 53cf8552-7b02-11ec-1f6f-f11dd5fad66a
md"""What would be a more direct method:
"""

# ╔═╡ 53cf8e60-7b02-11ec-016e-47c1cd1abd42
let
	choices = [
	"`det(F(lambda, phi).jacobian([lambda, phi]))`",
	"`det(hessian(F(lambda, phi), [lambda, phi]))`",
	"`det(gradient(F(lambda, phi), [lambda, phi]))`"
	]
	ans=1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 53cf8e7e-7b02-11ec-28a5-fb5e9af72cbf
md"""###### Question
"""

# ╔═╡ 53cf8e9c-7b02-11ec-34b4-7d17668c10db
md"""Let $z\sin(z) = x^3y^2 + z$. Compute $\partial{z}/\partial{x}$ implicitly.
"""

# ╔═╡ 53cf9600-7b02-11ec-1178-a5ba09f9d896
let
	choices = [
	    raw"`` 3x^2y^2/(z\cos(z) + \sin(z) + 1)``",
	    raw"`` 2x^3y/ (z\cos(z) + \sin(z) + 1)``",
	    raw"`` 3x^2y^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cf9612-7b02-11ec-1c42-d75e78b596ce
md"""###### Question
"""

# ╔═╡ 53cf9632-7b02-11ec-3679-1def8ebd6e1c
md"""Let $x^4 + y^4 + z^4 + x^2y^2z^2 = 1$. Compute $\partial{z}/\partial{y}$ implicitly.
"""

# ╔═╡ 53cfab14-7b02-11ec-1f47-b194c9dc2285
let
	choices = [
	    raw"`` \frac{y \left(- x^{2} z^{2}{\left (x,y \right )} + 2 y^{2}\right)}{\left(x^{2} y^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}``",
	    raw"`` \frac{x \left(2 x^{2} - y^{2} z^{2}{\left (x,y \right )}\right)}{\left(x^{2} y^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}``",
	    raw"`` \frac{x \left(2 x^{2} - z^{2}{\left (x,y \right )}\right)}{\left(x^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cfab34-7b02-11ec-2ba0-ed59dcf1a5e5
md"""###### Question
"""

# ╔═╡ 53cfab66-7b02-11ec-19db-53ba0e52ac33
md"""Consider the vector field $R:R^2 \rightarrow R^2$ defined by $R(x,y) = \langle x, y\rangle$ and the vector field $S:R^2\rightarrow R^2$ defined by $S(x,y) = \langle -y, x\rangle$. Let $r = \|R\| = \sqrt{x^2 + y^2}$. $R$ is a radial field, $S$ a spin field.
"""

# ╔═╡ 53cfab7a-7b02-11ec-27f1-ef4f02ab612e
md"""What is $\nabla{r}$?
"""

# ╔═╡ 53cfb11a-7b02-11ec-3db9-0b01bc00b5d0
let
	choices = [
	    raw"`` R/r``",
	    raw"`` S/r``",
	    raw"`` R``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cfb138-7b02-11ec-1bba-bdfcc792d96f
md"""Let $\phi = r^k$. What is $\nabla{\phi}$?
"""

# ╔═╡ 53cfb758-7b02-11ec-0467-21ef4ee0c0e7
let
	choices = [
	    raw"`` k r^{k-2} R``",
	    raw"`` kr^k R``",
	    raw"`` k r^{k-2} S``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cfb782-7b02-11ec-1ca3-67565eeb8345
md"""Based on your last answer, are all radial fields $R/r^n$, $n\geq 0$ gradients of scalar functions?
"""

# ╔═╡ 53cfb912-7b02-11ec-028c-85166f0783f1
let
	yesnoq(true)
end

# ╔═╡ 53cfb93a-7b02-11ec-1ed3-cd46d9a928d5
md"""Let $\phi = \tan^{-1}(y/x)$. What is $\nabla{\phi}$?
"""

# ╔═╡ 53cfbea8-7b02-11ec-0f15-ef460b97de6c
let
	choices = [
	    raw"`` S/r^2``",
	    raw"`` S/r``",
	    raw"`` S``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cfbed0-7b02-11ec-11e0-09760cfa8576
md"""Express $S/r^n = \langle F_x, F_y\rangle$. For which $n$ is $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y} = 0$?
"""

# ╔═╡ 53cfc63a-7b02-11ec-2299-b371b2dc7001
let
	choices = [
	L"As the left-hand side becomes $(-n+2)r^{-n}$, only $n=2$.",
	L"All $n \geq 0$",
	L"No values of $n$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 53cfc65a-7b02-11ec-39e7-514a0c93bb37
md"""(The latter is of interest, as only when the expression is $0$ will the vector field be the gradient of a scalar function.)
"""

# ╔═╡ 53cfc682-7b02-11ec-3530-c5bd07aade4d
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/scalar_functions_applications.html">◅ previous</a>  <a href="../differentiable_vector_calculus/plots_plotting.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/vector_fields.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 53cfc68c-7b02-11ec-3ca9-518242c84624
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
ForwardDiff = "~0.10.25"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
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
# ╟─53cfc664-7b02-11ec-1ca0-9da67f711129
# ╟─53342c54-7b02-11ec-01d1-db5046555423
# ╟─5336948c-7b02-11ec-00ed-c71f3f499d75
# ╠═534e611e-7b02-11ec-1762-ff925f732136
# ╟─534e6452-7b02-11ec-1a5f-1bdf8b5fd089
# ╟─5351870e-7b02-11ec-0b07-9de55b7b102a
# ╟─53a2c9ac-7b02-11ec-357a-c5e92bd693f4
# ╟─53a2ca10-7b02-11ec-0551-f1207bbad2d4
# ╟─53a554e2-7b02-11ec-3dcf-67e9c18d1c53
# ╟─53ae6bc4-7b02-11ec-32b4-fd9c6f1aabeb
# ╠═53ae73f6-7b02-11ec-0bbe-6592eda1c045
# ╟─53af99d4-7b02-11ec-24ee-b363543a9ce3
# ╟─53af9a38-7b02-11ec-1e99-d7626a83e354
# ╟─53af9a74-7b02-11ec-250c-f1bce954d2e5
# ╟─53afa29e-7b02-11ec-0429-3f2a9153894c
# ╟─53b1c736-7b02-11ec-1d33-51502da723f8
# ╟─53b1c79c-7b02-11ec-06fd-6784f86a9258
# ╟─53b1c7d6-7b02-11ec-38e9-69b5b5467637
# ╠═53b1cfec-7b02-11ec-31f4-c7b7629c28c3
# ╟─53b1d028-7b02-11ec-0982-631834cd20ec
# ╟─53b1d05a-7b02-11ec-31bc-c5ae17afbd6d
# ╟─53b1d078-7b02-11ec-3519-d1c03547b331
# ╟─53b1d08c-7b02-11ec-3d4d-9f6c77ffdbb4
# ╟─53b1d096-7b02-11ec-1889-0f9b3efc91de
# ╟─53bd0498-7b02-11ec-0c42-731fe9b40492
# ╟─53bf1d3c-7b02-11ec-3762-091fbda1a662
# ╟─53bfb03a-7b02-11ec-1e28-65e2ccf3da1a
# ╟─53bfb09e-7b02-11ec-2833-3f22e3e937c0
# ╟─53bfb0bc-7b02-11ec-2f14-7140a7c37f26
# ╟─53bfb0e4-7b02-11ec-3063-e3d3ba23bf95
# ╟─53c0d898-7b02-11ec-2251-15f7f365eaaf
# ╟─53c38afc-7b02-11ec-2275-3d84c72845f5
# ╟─53c38b72-7b02-11ec-06d9-4b75c4356ebc
# ╟─53c38b7e-7b02-11ec-068f-59b2dda4cd26
# ╠═53c3936c-7b02-11ec-1ef1-7559c3bb9bfc
# ╟─53c3938a-7b02-11ec-2cf6-9778c564bdb6
# ╠═53c39aa6-7b02-11ec-12c8-7343d075d73b
# ╟─53c3a14a-7b02-11ec-1880-e521087e183d
# ╟─53c3a726-7b02-11ec-1edd-f7b5d8f629c6
# ╟─53c3a744-7b02-11ec-1a0e-217660d7ae53
# ╠═53c3acc6-7b02-11ec-18fc-175ad6d3269c
# ╟─53c3ace4-7b02-11ec-11a5-85f9059cf77f
# ╠═53c3b2a2-7b02-11ec-229a-49a9b8772071
# ╟─53c3b2dc-7b02-11ec-10e4-6f96ea38acd3
# ╟─53c3b30e-7b02-11ec-0dc9-cf144a0cf3ce
# ╟─53c3b32e-7b02-11ec-2239-5138c556660c
# ╠═53c3b702-7b02-11ec-1e22-536594234dda
# ╟─53c3b72a-7b02-11ec-0b29-77067a55e098
# ╠═53c3bcac-7b02-11ec-14d5-8b267a1e1675
# ╟─53c3bcd4-7b02-11ec-2967-05d5eaff9b03
# ╠═53c3c1e8-7b02-11ec-19d5-6d18eacccfcb
# ╟─53c3c1fc-7b02-11ec-3565-af59e9bfc755
# ╠═53c3ca80-7b02-11ec-1986-9b9350c810a6
# ╟─53c3cab2-7b02-11ec-0ff2-47a5b01e19de
# ╟─53c3caf8-7b02-11ec-334e-09bb8db2607b
# ╟─53c3cb2a-7b02-11ec-39ea-7bc7014c675b
# ╟─53c3cb36-7b02-11ec-3a2a-ff0fddd52ecf
# ╟─53c3cb48-7b02-11ec-058b-5db8fb144a5e
# ╟─53c3cb64-7b02-11ec-2bc5-9b31968cc6c7
# ╟─53c3cb84-7b02-11ec-313e-039411f71889
# ╟─53c3cb96-7b02-11ec-163d-4fe6e4db845c
# ╟─53c3cbac-7b02-11ec-3bae-0137f913c6cc
# ╟─53c3cbb6-7b02-11ec-36dc-b10efcdfaf81
# ╟─53c3cbd4-7b02-11ec-3b99-6d84de5a24a4
# ╟─53c3cbfc-7b02-11ec-1a05-5b13237ffda5
# ╟─53c3cc06-7b02-11ec-179d-a3112c7849f7
# ╟─53c3cdb4-7b02-11ec-08ac-abed73f3ea50
# ╟─53c3cdc8-7b02-11ec-06b8-b9e060909cd1
# ╟─53c3ce06-7b02-11ec-2d8f-c95549e723aa
# ╟─53c3ce18-7b02-11ec-0373-7187fb6ebc1a
# ╟─53c3ce2c-7b02-11ec-2890-1d737ed264fd
# ╟─53c3ce34-7b02-11ec-3874-9b371cc4ee5e
# ╟─53c3ce4a-7b02-11ec-26f5-15445730c245
# ╟─53c3ce5e-7b02-11ec-3ac1-9762bd746565
# ╟─53c3ce7c-7b02-11ec-39e3-abf42b17c8ee
# ╟─53c3ce86-7b02-11ec-2096-4ba94b74461d
# ╟─53c3ceae-7b02-11ec-338c-0f5919062636
# ╟─53c3ced6-7b02-11ec-3b4a-7dd604cf3db2
# ╟─53c3ceea-7b02-11ec-36ea-ada40ffc9b00
# ╟─53c3cef4-7b02-11ec-0665-27828ba5f9b0
# ╟─53c3cf0a-7b02-11ec-0cf4-e17677436e7b
# ╟─53c3cf26-7b02-11ec-3f9e-1f51144ba7f3
# ╟─53c3cf30-7b02-11ec-12a0-33751f14ca82
# ╟─53c3cf44-7b02-11ec-1eea-bff6bcaf2210
# ╟─53c3cf4e-7b02-11ec-32e8-8d6a1ba676df
# ╟─53c3cf6e-7b02-11ec-274b-878d4cbee6c8
# ╟─53c3cf80-7b02-11ec-2a70-55c8f8e47c37
# ╟─53c6963e-7b02-11ec-241e-4d7ec80a2d90
# ╟─53c696c0-7b02-11ec-1ef3-37fa6da339b6
# ╟─53c696ea-7b02-11ec-1b6a-eff54cb61394
# ╟─53c69724-7b02-11ec-1956-51add25ae024
# ╠═53c69e72-7b02-11ec-148c-511ac0b5baf3
# ╟─53c7d258-7b02-11ec-2f47-414fd02424cf
# ╠═53c7d754-7b02-11ec-1b19-f7c73f8095fd
# ╟─53c7d792-7b02-11ec-3975-87a54fd7a345
# ╠═53c7d9cc-7b02-11ec-0e61-df85493801c7
# ╟─53c7d9ea-7b02-11ec-0d62-950399482c02
# ╟─53c7da12-7b02-11ec-1a21-71cea9773f07
# ╟─53c7da24-7b02-11ec-0eac-6f327bc6d18e
# ╟─53c7db98-7b02-11ec-13a6-ed5e8081864a
# ╟─53c7dbac-7b02-11ec-2edf-3db2075f6ffd
# ╟─53c7dd28-7b02-11ec-1a04-01a505578e40
# ╟─53c7dd50-7b02-11ec-09c9-d52c9eb81452
# ╟─53c7dd66-7b02-11ec-05f0-0f1712ec6715
# ╠═53c7ead4-7b02-11ec-2cbc-45daa9a176d8
# ╟─53c7eaf2-7b02-11ec-2c40-a78139b1d41a
# ╠═53c7ee94-7b02-11ec-119e-cbb400c44b6e
# ╟─53c7eeb2-7b02-11ec-2f6a-4fa31102baa4
# ╠═53c7f0c4-7b02-11ec-17f3-1da4ca041e4c
# ╟─53c7f100-7b02-11ec-0828-5fc9483c6806
# ╠═53c7f614-7b02-11ec-307f-057b0068b0ee
# ╟─53c7f628-7b02-11ec-02e1-a37454ea9cfe
# ╠═53c7f9a2-7b02-11ec-2ceb-33e857451efb
# ╟─53c7f9d4-7b02-11ec-090c-e7de0ac7445a
# ╠═53c7fe7a-7b02-11ec-1605-211878be018e
# ╟─53c7feac-7b02-11ec-0e4a-0f662ce803a4
# ╠═53c805e6-7b02-11ec-1f9b-11e5ee335db0
# ╟─53c80604-7b02-11ec-2002-c73d4eb037bf
# ╠═53c80744-7b02-11ec-2df8-ff98cd58d4c9
# ╟─53c80758-7b02-11ec-1715-b3b36714592c
# ╠═53c80956-7b02-11ec-0ec2-8b6b1d6d1451
# ╟─53c8097e-7b02-11ec-3d95-83fc2c8ffd63
# ╟─53c809a6-7b02-11ec-37da-99f8ef56c978
# ╟─53c809cc-7b02-11ec-15f3-b34c04aee89a
# ╟─53c809d8-7b02-11ec-2b53-cfff4e7fadff
# ╟─53c809f6-7b02-11ec-0541-1dbab65415ab
# ╟─53c80a0a-7b02-11ec-3a89-5116cea8604a
# ╟─53c80a30-7b02-11ec-2e78-c307ffff7e93
# ╟─53c80a3c-7b02-11ec-2bb3-bfafd972b1b9
# ╠═53c80fe6-7b02-11ec-1057-3b3203793e9f
# ╟─53c81004-7b02-11ec-2a69-592eadc67998
# ╠═53c8134c-7b02-11ec-04ec-b53595a29f8b
# ╟─53c81372-7b02-11ec-0fe9-e104e0a3f5bb
# ╟─53c813ba-7b02-11ec-200a-e9b45ab29f3b
# ╟─53cb7442-7b02-11ec-1ebb-39a3326cc052
# ╟─53cb7492-7b02-11ec-2729-1b2a56eac959
# ╟─53cb74c4-7b02-11ec-0735-27b8a13e5476
# ╟─53cb74f6-7b02-11ec-20d5-39718e7136f6
# ╟─53cb750a-7b02-11ec-3e8e-2159771a6664
# ╟─53cb751c-7b02-11ec-31a5-4d7c5650eabc
# ╟─53cb7528-7b02-11ec-07cd-513b4ce34d36
# ╠═53cb7fdc-7b02-11ec-3d88-0b904895e460
# ╟─53cb7ff8-7b02-11ec-1716-87a6eb806172
# ╠═53cb8356-7b02-11ec-0242-0f2c2654b5e7
# ╟─53cb837e-7b02-11ec-2e64-5f10cf020e32
# ╟─53cb83c4-7b02-11ec-0e36-832100a239d1
# ╟─53cb83e2-7b02-11ec-1daf-2b035a889f3f
# ╟─53cb83ec-7b02-11ec-0624-ad476b87cdc9
# ╟─53cb83fe-7b02-11ec-19ba-b5aafb136c7f
# ╟─53cb8414-7b02-11ec-1b07-eb56f5f542a6
# ╟─53cb8428-7b02-11ec-25cb-bb6ac55f15f2
# ╟─53cb8450-7b02-11ec-32a1-217002c34b6e
# ╟─53cb854a-7b02-11ec-3009-bf81e36ebfc0
# ╟─53cb8554-7b02-11ec-3737-971e05333250
# ╟─53cb857c-7b02-11ec-0ab8-696d3bb0d6d2
# ╟─53cb8598-7b02-11ec-28bd-fbf47a187b11
# ╟─53cb85a4-7b02-11ec-36ad-27a4fc10cbee
# ╟─53cb85b8-7b02-11ec-374b-2997527adae5
# ╟─53cb85cc-7b02-11ec-367d-99924012b215
# ╟─53cb85e0-7b02-11ec-08e5-a70eae2dd71b
# ╟─53cb85ea-7b02-11ec-3867-d5d6ba78a308
# ╟─53cb85fe-7b02-11ec-0fae-c509ee48d8e0
# ╟─53cb860a-7b02-11ec-3cd8-85567c30c0fc
# ╟─53cb861c-7b02-11ec-0e50-bd38fd3c306e
# ╟─53cb8626-7b02-11ec-1eb7-d16883561645
# ╟─53cb8630-7b02-11ec-27cd-154c6bafb8b1
# ╟─53cca844-7b02-11ec-21e3-bbc23eee0d21
# ╟─53cca8bc-7b02-11ec-16b3-b3389875c7fe
# ╟─53cca90c-7b02-11ec-003d-e7fafd602bd6
# ╟─53cca92a-7b02-11ec-3a00-6529601eef66
# ╟─53cca948-7b02-11ec-3e4f-095e06462d95
# ╟─53cca95c-7b02-11ec-0e61-8bc35a4baf3a
# ╟─53cca982-7b02-11ec-006f-577f484d033d
# ╟─53cca998-7b02-11ec-23a0-e3aead5a70a2
# ╟─53cca9ca-7b02-11ec-3f44-25a73c80e729
# ╟─53cca9f2-7b02-11ec-21ff-e1e964f3943d
# ╟─53ccaa1a-7b02-11ec-03b0-6d0b7b13cd61
# ╟─53ccaa2e-7b02-11ec-2f13-296f90b103ed
# ╟─53ccaa38-7b02-11ec-3a31-7df228109ac8
# ╟─53ccaa4c-7b02-11ec-36a5-7f6f56fc8593
# ╟─53ccaa58-7b02-11ec-02d4-8d7ca99d9ccd
# ╟─53ccaa74-7b02-11ec-2e59-f1b5b2a589bc
# ╟─53ccaaea-7b02-11ec-326f-b9fc59637e4e
# ╟─53ccab00-7b02-11ec-0ca4-47a235aaf99d
# ╟─53ccab14-7b02-11ec-06c3-91c22ed37821
# ╟─53ccab28-7b02-11ec-12c0-a739c792e016
# ╟─53ccab46-7b02-11ec-21c6-158b92543fb6
# ╟─53ccab50-7b02-11ec-34bf-23bcae366f01
# ╟─53ccab82-7b02-11ec-1001-01157cfdc62a
# ╟─53ccab96-7b02-11ec-3317-2ba040211497
# ╟─53ccabc0-7b02-11ec-3353-ed479e018ccd
# ╟─53ccabd2-7b02-11ec-1954-c98bca66e094
# ╟─53ccabdc-7b02-11ec-1447-ed4537b7bb72
# ╟─53ccabf2-7b02-11ec-3c3b-314529151c14
# ╟─53ccac04-7b02-11ec-39d9-b588a3ed6f75
# ╟─53ccac18-7b02-11ec-15a3-596778221380
# ╟─53ccac4a-7b02-11ec-0cb8-f5448c6966ab
# ╟─53cf4a04-7b02-11ec-2e69-17964824ac1f
# ╟─53cf4a5e-7b02-11ec-26dc-31659fce01de
# ╟─53cf526a-7b02-11ec-1610-b15bf0c8c30b
# ╠═53cf5bca-7b02-11ec-24dc-3587a128ef3f
# ╟─53cf5bfc-7b02-11ec-09b6-61bce80900c7
# ╟─53cf5daa-7b02-11ec-1754-2f0a665aad69
# ╟─53cf5dd2-7b02-11ec-01fe-93502de5f335
# ╟─53cf5dfa-7b02-11ec-3df4-2f6ae4653f00
# ╠═53cf62d2-7b02-11ec-29cb-f3608e68deb8
# ╠═53cf6b30-7b02-11ec-38f1-eb669acb5fbe
# ╟─53cf6b56-7b02-11ec-1e62-5168d4c3c443
# ╟─53cf6cdc-7b02-11ec-06d0-9348a1233b9f
# ╟─53cf6cf0-7b02-11ec-106d-8dae9fc75cf0
# ╟─53cf6d2a-7b02-11ec-19d8-67df83a52b40
# ╟─53cf6d54-7b02-11ec-282e-75f985c370a2
# ╟─53cf72b8-7b02-11ec-2b7f-59fe83363d8d
# ╟─53cf72ca-7b02-11ec-17c0-016d0a45b733
# ╟─53cf72ea-7b02-11ec-373e-eff13ba718ed
# ╟─53cf72fc-7b02-11ec-086c-7d094a4cbd5f
# ╟─53cf7838-7b02-11ec-353d-1fe883064e48
# ╟─53cf7858-7b02-11ec-1c87-2b456504d32d
# ╟─53cf7880-7b02-11ec-27f2-5b7adbb40d85
# ╟─53cf7894-7b02-11ec-2f27-5bfec76076ec
# ╟─53cf78bc-7b02-11ec-07d0-1fdced22d2b3
# ╠═53cf7d58-7b02-11ec-2557-e719dbf31cd1
# ╟─53cf853c-7b02-11ec-3b8a-51b8705d68d7
# ╟─53cf8552-7b02-11ec-1f6f-f11dd5fad66a
# ╟─53cf8e60-7b02-11ec-016e-47c1cd1abd42
# ╟─53cf8e7e-7b02-11ec-28a5-fb5e9af72cbf
# ╟─53cf8e9c-7b02-11ec-34b4-7d17668c10db
# ╟─53cf9600-7b02-11ec-1178-a5ba09f9d896
# ╟─53cf9612-7b02-11ec-1c42-d75e78b596ce
# ╟─53cf9632-7b02-11ec-3679-1def8ebd6e1c
# ╟─53cfab14-7b02-11ec-1f47-b194c9dc2285
# ╟─53cfab34-7b02-11ec-2ba0-ed59dcf1a5e5
# ╟─53cfab66-7b02-11ec-19db-53ba0e52ac33
# ╟─53cfab7a-7b02-11ec-27f1-ef4f02ab612e
# ╟─53cfb11a-7b02-11ec-3db9-0b01bc00b5d0
# ╟─53cfb138-7b02-11ec-1bba-bdfcc792d96f
# ╟─53cfb758-7b02-11ec-0467-21ef4ee0c0e7
# ╟─53cfb782-7b02-11ec-1ca3-67565eeb8345
# ╟─53cfb912-7b02-11ec-028c-85166f0783f1
# ╟─53cfb93a-7b02-11ec-1ed3-cd46d9a928d5
# ╟─53cfbea8-7b02-11ec-0f15-ef460b97de6c
# ╟─53cfbed0-7b02-11ec-11e0-09760cfa8576
# ╟─53cfc63a-7b02-11ec-2299-b371b2dc7001
# ╟─53cfc65a-7b02-11ec-39e7-514a0c93bb37
# ╟─53cfc682-7b02-11ec-3530-c5bd07aade4d
# ╟─53cfc68c-7b02-11ec-3b3a-61c5537a409e
# ╟─53cfc68c-7b02-11ec-3ca9-518242c84624
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
