### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ a59e8154-c190-11ec-37ec-074774fdc539
begin
	using CalculusWithJulia
	using Plots
	using QuadGK
	using SymPy
	using HCubature
end

# ╔═╡ a59e84f6-c190-11ec-3df9-6b714d468d61
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ a5a133e2-c190-11ec-35a9-899ca194b9fa
using PlutoUI

# ╔═╡ a5a133b0-c190-11ec-2cff-fd41f801ef23
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ a59e7b00-c190-11ec-1cd9-595a9f7c7907
md"""# Line and Surface Integrals
"""

# ╔═╡ a59e7b3c-c190-11ec-09ea-8d5a3ae1a7d6
md"""This section uses these add-on packages:
"""

# ╔═╡ a59e8528-c190-11ec-3127-ffc32a663f1d
md"""---
"""

# ╔═╡ a59e8596-c190-11ec-1983-210ff4ec5d9a
md"""This section discusses generalizations to the one- and two-dimensional definite integral. These two integrals integrate a function over a one or two dimensional region (e.g., $[a,b]$ or $[a,b]\times[c,d]$). The generalization is to change this region to a one-dimensional piece of path in $R^n$ or a two-dimensional surface in $R^3$.
"""

# ╔═╡ a59e862c-c190-11ec-1084-5beb90f67867
md"""To fix notation, consider $\int_a^b f(x)dx$ and $\int_a^b\int_c^d g(x,y) dy dx$. In defining both, a Riemann sum is involved, these involve a partition of $[a,b]$ or $[a,b]\times[c,d]$ and terms like $f(c_i) \Delta{x_i}$ and $g(c_i, d_j) \Delta{x_i}\Delta{y_j}$. The $\Delta$s the diameter of an intervals $I_i$ or $J_j$.  Consider now two parameterizations: $\vec{r}(t)$ for $t$ in $[a,b]$ and $\Phi(u,v)$ for $(u,v)$ in $[a,b]\times[c,d]$. One is a parameterization of a space curve, $\vec{r}:R\rightarrow R^n$; the other a parameterization of a surface, $\Phi:R^2 \rightarrow R^3$. The *image* of $I_i$ or $I_i\times{J_j}$ under $\vec{r}$ and $\Phi$, respectively, will look *almost* linear if the intervals are small enough, so, at least on the microscopic level. A Riemann term can be based around this fact, provided it is understood how much the two parameterizations change the interval $I_i$ or region $I_i\times{J_j}$.
"""

# ╔═╡ a59e8652-c190-11ec-087e-33af565b168c
md"""This chapter will quantify this change, describing it in terms of associated vectors to $\vec{r}$ and $\Phi$, yielding formulas for an integral of a *scalar* function along a path or over a surface. Furthermore, these integrals will be generalized to give meaning to  physically useful interactions between the path or surface and a vector field.
"""

# ╔═╡ a59e8684-c190-11ec-0b4a-c55fab6c40e7
md"""## Line integrals
"""

# ╔═╡ a59e86e0-c190-11ec-305c-ad02a31a2b26
md"""In [arc length](../integrals/arc-length.html) a formula to give the arc-length of the graph of a univariate function or parameterized curve in $2$ dimensions is given in terms of an integral. The intuitive approximation involved segments of the curve. To review, let $\vec{r}(t)$, $a \leq t \leq b$, describe a curve, $C$, in $R^n$, $n \geq 2$. Partition $[a,b]$ into $a=t_0 < t_1 < \cdots < t_{n-1} < t_n = b$.
"""

# ╔═╡ a59e8712-c190-11ec-3d54-1b2555b3de49
md"""Consider the path segment  connecting $\vec{r}(t_{i-1})$ to $\vec{r}(t_i)$. If the partition of $[a,b]$ is microscopically small, this path will be *approximated* by $\vec{r}(t_i) - \vec{r}(t_{i-1})$. This difference in turn is approximately $\vec{r}'(t_i) (t_i - t_{i-1}) = \vec{r}'(t_i) \Delta{t}_i$, provided $\vec{r}$ is differentiable.
"""

# ╔═╡ a59e8730-c190-11ec-2bc9-b1d388dfba38
md"""If $f:R^n \rightarrow R$ is a scalar function. Taking right-hand end points, we can consider the Riemann sum $\sum (f\circ\vec{r})(t_i) \|\vec{r}'(t_i)\| \Delta{t}_i$.  For integrable functions, this sum converges to the *line integral* defined as a one-dimensional integral for a given parameterization:
"""

# ╔═╡ a59e876c-c190-11ec-0739-0d77785addae
md"""```math
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt.
```
"""

# ╔═╡ a59e8794-c190-11ec-3b90-03e8d8900f78
md"""The weight $\| \vec{r}'(t) \|$ can be interpreted by how much the parameterization stretches (or contracts) an interval $[t_{i-1},t_i]$ when mapped to its corresponding path segment.
"""

# ╔═╡ a59e87a8-c190-11ec-3d65-49e011cdb796
md"""---
"""

# ╔═╡ a59e87ec-c190-11ec-27a8-1d1fa81c03df
md"""The curve $C$ can be parameterized many different ways by introducing a function $s(t)$ to change the time. If we use the arc-length parameterization with $\gamma(0) = a$ and $\gamma(l) = b$, where $l$ is the arc-length of $C$, then we have by change of variables $t = \gamma(s)$ that
"""

# ╔═╡ a59e8802-c190-11ec-00f6-41fd0033d64e
md"""```math
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) \| \frac{d\vec{r}}{dt}\mid_{t = \gamma(s)}\| \gamma'(s) ds.
```
"""

# ╔═╡ a59e8816-c190-11ec-20da-5b1e3b1c7a65
md"""But, by the chain rule:
"""

# ╔═╡ a59e8834-c190-11ec-196f-0d4a88c512ef
md"""```math
\frac{d(\vec{r} \circ\gamma)}{du}(s) = \frac{d\vec{r}}{dt}\mid_{t=\gamma(s)} \frac{d\gamma}{du}.
```
"""

# ╔═╡ a59e8852-c190-11ec-1a92-e502216e843c
md"""Since $\gamma$ is increasing, $\gamma' \geq 0$, so we get:
"""

# ╔═╡ a59e8866-c190-11ec-3d0d-1bfed1f39591
md"""```math
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) \|\frac{d(\vec{r}\circ\gamma)}{ds}\| ds =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) ds.
```
"""

# ╔═╡ a59e8884-c190-11ec-28fb-1725c5ae7a4b
md"""The last line, as the derivative is the unit tangent vector, $T$, with norm $1$.
"""

# ╔═╡ a59e88b6-c190-11ec-0a9d-f150281196e9
md"""This shows that the line integral is *not* dependent on the parameterization. The notation $\int_C f ds$ is used to represent the line integral of a scalar function, the $ds$ emphasizing an implicit parameterization of $C$ by arc-length. When $C$ is a closed curve, the $\oint_C fds$ is used to indicate that.
"""

# ╔═╡ a59e88e8-c190-11ec-158c-55fc220de783
md"""### Example
"""

# ╔═╡ a59e891a-c190-11ec-2ebc-2d63fdd89910
md"""When $f$ is identically $1$, the line integral returns the arc length. When $f$ varies, then the line integral can be interpreted a few ways. First, if $f \geq 0$ and we consider a sheet hung from the curve $f\circ \vec{r}$ and cut to just touch the ground, the line integral gives the area of this sheet, in the same way an integral gives the area under a positive curve.
"""

# ╔═╡ a59e8938-c190-11ec-32d7-cb92d5fc4858
md"""If the composition $f \circ \vec{r}$ is viewed as a density of the arc (as though it were constructed out of some non-uniform material), then the line integral can be seen to return the mass of the arc.
"""

# ╔═╡ a59e8954-c190-11ec-15bc-69ca76de203f
md"""Suppose $\rho(x,y,z) = 5 - z$ gives the density of an arc where the arc is parameterized by $\vec{r}(t) = \langle \cos(t), 0, \sin(t) \rangle$, $0 \leq t \leq \pi$. (A half-circular arc.) Find the mass of the arc.
"""

# ╔═╡ a59e8f8c-c190-11ec-0e32-e123b2c74f3c
begin
	rho(x,y,z) = 5 - z
	rho(v) = rho(v...)
	r(t) = [cos(t), 0, sin(t)]
	
	@syms t
	rp = diff.(r(t),t)  # r'
	area = integrate((rho ∘ r)(t) * norm(rp), (t, 0, PI))
end

# ╔═╡ a59e8fbe-c190-11ec-0ef4-a12503e8b714
md"""Continuing, we could find the center of mass by integrating $\int_C z (f\circ \vec{r}) \|r'\| dt$:
"""

# ╔═╡ a59e9932-c190-11ec-2f06-31f74bbcfa18
begin
	Mz = integrate(r(t)[3] * (rho ∘ r)(t) * norm(rp), (t, 0, PI))
	Mz
end

# ╔═╡ a59e995a-c190-11ec-02cc-59dd6a48fbee
md"""Finally, we get the center of mass by
"""

# ╔═╡ a59e9afe-c190-11ec-2bf3-4f47cf08618a
Mz / area

# ╔═╡ a59e9b30-c190-11ec-3b7b-edbc28704300
md"""##### Example
"""

# ╔═╡ a59e9b62-c190-11ec-3457-9113ea7f93cb
md"""Let $f(x,y,z) = x\sin(y)\cos(z)$ and $C$ the path described by $\vec{r}(t) = \langle t, t^2, t^3\rangle$ for $0 \leq t \leq \pi$. Find the line integral $\int_C fds$.
"""

# ╔═╡ a59e9b76-c190-11ec-3ba4-7b956c92e0e9
md"""We find the numeric value with:
"""

# ╔═╡ a59ea0e4-c190-11ec-1dd3-c554ea79555a
let
	f(x,y,z) = x*sin(y)*cos(z)
	f(v) = f(v...)
	r(t) = [t, t^2, t^3]
	integrand(t) = (f ∘ r)(t) * norm(r'(t))
	quadgk(integrand, 0, pi)
end

# ╔═╡ a59ea10c-c190-11ec-070c-159180dc39e8
md"""##### Example
"""

# ╔═╡ a59ea166-c190-11ec-32ad-6d1031c904e0
md"""Imagine the $z$ axis is a wire and in the $x$-$y$ plane the unit circle is a path. If there is a magnetic field, $B$, then the field will induce a current to flow along the wire. [Ampere's]https://tinyurl.com/y4gl9pgu) circuital law states $\oint_C B\cdot\hat{T} ds = \mu_0 I$, where $\mu_0$ is a constant and $I$ the current. If the magnetic field is given by $B=(x^2+y^2)^{1/2}\langle -y,x,0\rangle$ compute $I$ in terms of $\mu_0$.
"""

# ╔═╡ a59ea18e-c190-11ec-1ddc-fdc61d7de1d1
md"""We have the path is parameterized by $\vec{r}(t) = \langle \cos(t), \sin(t), 0\rangle$, and so $\hat{T} = \langle -\sin(t), \cos(t), 0\rangle$ and the integrand, $B\cdot\hat{T}$ is
"""

# ╔═╡ a59ea1ae-c190-11ec-0db2-8dc485fa4b68
md"""```math
(x^2 + y^2)^{-1/2}\langle -\sin(t), \cos(t), 0\rangle\cdot
\langle -\sin(t), \cos(t), 0\rangle = (x^2 + y^2)(-1/2),
```
"""

# ╔═╡ a59ea1ca-c190-11ec-2aa7-69105f63d359
md"""which is $1$ on the path $C$. So $\int_C B\cdot\hat{T} ds = \int_C ds = 2\pi$. So the current satisfies $2\pi = \mu_0 I$, so $I = (2\pi)/\mu_0$.
"""

# ╔═╡ a59ea1f2-c190-11ec-384f-4f4b22421585
md"""(Ampere's law is more typically used to find $B$ from an current, then $I$ from $B$, for special circumstances. The Biot-Savart does this more generally.)
"""

# ╔═╡ a59ea20e-c190-11ec-1901-132812560dea
md"""### Line integrals and vector fields; work and flow
"""

# ╔═╡ a59ea22e-c190-11ec-3fc8-411e975ff2f4
md"""As defined above, the line integral is defined for a scalar function, but this can be generalized. If $F:R^n \rightarrow R^n$ is a vector field, then each component is a scalar function, so the integral $\int (F\circ\vec{r}) \|\vec{r}'\| dt$ can be defined component by component to yield a vector.
"""

# ╔═╡ a59ea242-c190-11ec-121d-37da983a6392
md"""However, it proves more interesting to define an integral incorporating how properties of the path interact with the vector field. The key is $\vec{r}'(t) dt = \hat{T} \| \vec{r}'(t)\|dt$ describes both the magnitude of how the parameterization stretches an interval but also a direction the path is taking. This direction allows interaction with the vector field.
"""

# ╔═╡ a59ea292-c190-11ec-3a88-b57953fb2e9c
md"""The canonical example is [work](https://en.wikipedia.org/wiki/Work_(physics)), which is a measure of a force times a distance. For an object following a path, the work done is still a force times a distance, but only that force in the direction of the motion is considered. (The *constraint force* keeping the object on the path does no work.) Mathematically, $\hat{T}$ describes the direction of motion along a path, so the work done in moving an object over a small segment of the path is $(F\cdot\hat{T}) \Delta{s}$. Adding up incremental amounts of work leads to a Riemann sum for a line integral involving a vector field.
"""

# ╔═╡ a59ea3d2-c190-11ec-0d78-5b7b00a83290
md"""> The *work* done in moving an object along a path $C$ by a force field, $F$, is given by the integral
>
> ```math
> \int_C (F \cdot \hat{T}) ds = \int_C F\cdot d\vec{r} = \int_a^b ((F\circ\vec{r}) \cdot \frac{d\vec{r}}{dt})(t) dt.
> ```

"""

# ╔═╡ a59ea3f0-c190-11ec-01e0-75bddab47e22
md"""---
"""

# ╔═╡ a59ea422-c190-11ec-39d5-690819c281f0
md"""In the $n=2$ case, there is another useful interpretation of the line integral. In this dimension the normal vector, $\hat{N}$, is well defined in terms of the tangent vector, $\hat{T}$, through a rotation: $\langle a,b\rangle^t = \langle b,-a\rangle^t$. (The negative, $\langle -b,a\rangle$ is also a candidate, the difference in this choice would lead to a sign difference in  in the answer.) This allows the definition of a different line integral, called a flow integral, as detailed later:
"""

# ╔═╡ a59ea490-c190-11ec-1ddf-bb6b0962dbca
md"""> The *flow* across a curve $C$ is given by
>
> ```math
> \int_C (F\cdot\hat{N}) ds = \int_a^b (F \circ \vec{r})(t) \cdot (\vec{r}'(t))^t dt.
> ```

"""

# ╔═╡ a59ea4a4-c190-11ec-09e4-19b09b3b86ea
md"""### Examples
"""

# ╔═╡ a59ea4c2-c190-11ec-3e45-d93fd063896c
md"""##### Example
"""

# ╔═╡ a59ea4ea-c190-11ec-0d30-4b7bf6e58fe4
md"""Let $F(x,y,z) = \langle x - y, x^2 - y^2, x^2 - z^2 \rangle$ and $\vec{r}(t) = \langle t, t^2, t^3 \rangle$. Find the work required to move an object along the curve described by $\vec{r}$ between $0$ and $1$.
"""

# ╔═╡ a59eae5e-c190-11ec-25ab-294e8cbad712
let
	F(x,y,z) = [x-y, x^2 - y^2, x^2 - z^2]
	F(v) = F(v...)
	r(t) = [t, t^2, t^3]
	
	@syms t::real
	integrate((F ∘ r)(t) ⋅ diff.(r(t), t), (t, 0, 1))
end

# ╔═╡ a59eae84-c190-11ec-33aa-03eff5ab8a03
md"""##### Example
"""

# ╔═╡ a59eaec2-c190-11ec-317d-9d1273eea3d4
md"""Let $C$ be a closed curve. For a closed curve, the work integral is also termed the *circulation*. For the vector field $F(x,y) = \langle -y, x\rangle$ compute the circulation around the triangle with vertices $(-1,0)$, $(1,0)$, and $(0,1)$.
"""

# ╔═╡ a59eaeea-c190-11ec-1ead-75d753df14e8
md"""We have three integrals using $\vec{r}_1(t) = \langle -1+2t, 0\rangle$, $\vec{r}_2(t) = \langle 1-t, t\rangle$ and $\vec{r}_3(t) = \langle -t, 1-t \rangle$, all from $0$ to $1$. (Check that the parameterization is counter clockwise.)
"""

# ╔═╡ a59eaefe-c190-11ec-1726-55fbc38e6b52
md"""The circulation then is:
"""

# ╔═╡ a59eb4d0-c190-11ec-2392-d59bc378949b
let
	r1(t) = [-1 + 2t, 0]
	r2(t) = [1-t, t]
	r3(t) = [-t, 1-t]
	F(x,y) = [-y, x]
	F(v) = F(v...)
	integrand(r) = t -> (F ∘ r)(t) ⋅ r'(t)
	C1 = quadgk(integrand(r1), 0, 1)[1]
	C2 = quadgk(integrand(r2), 0, 1)[1]
	C3 = quadgk(integrand(r3), 0, 1)[1]
	C1 + C2 + C3
end

# ╔═╡ a59eb4f6-c190-11ec-297f-33482cec8051
md"""That this is non-zero reflects a feature of the vector field. In this case, the vector field spirals around the origin, and the circulation is non zero.
"""

# ╔═╡ a59eb50c-c190-11ec-33f3-3d8b6bdea559
md"""##### Example
"""

# ╔═╡ a59eb534-c190-11ec-188c-e9bdf01ddd5c
md"""Let $F$ be the force of gravity exerted by a mass $M$ on a mass $m$ a distance $\vec{r}$ away, that is $F(\vec{r}) = -(GMm/\|\vec{r}\|^2)\hat{r}$.
"""

# ╔═╡ a59eb55a-c190-11ec-334d-497ad84a5746
md"""Let $\vec{r}(t) = \langle 1-t, 0, t\rangle$, $0 \leq t \leq 1$. For concreteness, we take $G M m$ to be $10$. Then the work to move the mass is given by:
"""

# ╔═╡ a59eb9e4-c190-11ec-00f0-ad40a3b332f3
begin
	uvec(v) = v/norm(v) # unit vector
	GMm = 10
	Fₘ(r) = - GMm /norm(r)^2 * uvec(r)
	rₘ(t) = [1-t, 0, t]
	quadgk(t -> (Fₘ ∘ rₘ)(t) ⋅ rₘ'(t), 0, 1)
end

# ╔═╡ a59eba0c-c190-11ec-2ca4-a188a9406d00
md"""Hmm, a value of $0$. That's a bit surprising at first glance. Maybe it had something to do with the specific path chosen. To investigate, we connect the start and endpoints with a circular arc, instead of a straight line:
"""

# ╔═╡ a59ebfac-c190-11ec-1f0b-5f5265e2ee22
begin
	rₒ(t) = [cos(t), 0, sin(t)]
	quadgk(t -> (Fₘ ∘ rₒ)(t) ⋅ rₒ'(t), 0, 1)
end

# ╔═╡ a59ebfde-c190-11ec-1708-d3d475c62212
md"""Still $0$. We will see next that this is not surprising if something about $F$ is known.
"""

# ╔═╡ a59ee040-c190-11ec-36a1-a716234491cc
note("""
The [Washington Post](https://www.washingtonpost.com/outlook/everything-you-thought-you-knew-about-gravity-is-wrong/2019/08/01/627f3696-a723-11e9-a3a6-ab670962db05_story.html") had an article by Richard Panek with the quote "Well, yes — depending on what we mean by 'attraction.' Two bodies of mass don’t actually exert some mysterious tugging on each other. Newton himself tried to avoid the word 'attraction' for this very reason. All (!) he was trying to do was find the math to describe the motions both down here on Earth and up there among the planets (of which Earth, thanks to Copernicus and Kepler and Galileo, was one)." The point being the formula above is a mathematical description of the force, but not an explanation of how the force actually is transferred.
""")

# ╔═╡ a59ee09c-c190-11ec-37da-1b401df1a5ea
md"""#### Work in a *conservative* vector field
"""

# ╔═╡ a59ee0ca-c190-11ec-2850-9daa2895688e
md"""Let $f: R^n \rightarrow R$ be a scalar function. Its gradient, $\nabla f$ is a *vector field*. For a *scalar* function, we have by the chain rule:
"""

# ╔═╡ a59ee0ea-c190-11ec-3087-510e039608a4
md"""```math
\frac{d(f \circ \vec{r})}{dt} = \nabla{f}(\vec{r}(t)) \cdot \frac{d\vec{r}}{dt}.
```
"""

# ╔═╡ a59ee0fc-c190-11ec-0d45-cd5c48908a5f
md"""If we integrate, we see:
"""

# ╔═╡ a59ee11c-c190-11ec-17be-556d9fe0b961
md"""```math
W = \int_a^b  \nabla{f}(\vec{r}(t)) \cdot \frac{d\vec{r}}{dt} dt =
\int_a^b \frac{d(f \circ \vec{r})}{dt} dt =
(f\circ\vec{r})\mid_{t = a}^b =
(f\circ\vec{r})(b) - (f\circ\vec{r})(a),
```
"""

# ╔═╡ a59ee12e-c190-11ec-1f65-c398010e29c1
md"""using the Fundamental Theorem of Calculus.
"""

# ╔═╡ a59ee14e-c190-11ec-33f2-d11a631d4829
md"""The main point above is that *if* the vector field is the gradient of a scalar field, then the work done depends *only* on the endpoints of the path and not the path itself.
"""

# ╔═╡ a59ee23e-c190-11ec-2b8c-b11290ed83c3
md"""> **Conservative vector field**:  If $F$ is a vector field defined in an *open* region $R$; $A$ and $B$ are points in $R$ and *if* for *any* curve $C$ in $R$ connecting $A$ to $B$, the line integral of $F \cdot \vec{T}$ over $C$ depends *only* on the endpoint $A$ and $B$ and not the path, then the line integral is called *path indenpendent* and the field is called a *conservative field*.

"""

# ╔═╡ a59ee270-c190-11ec-121e-eb4df120121e
md"""The force of gravity is the gradient of a scalar field. As such, the two integrals above which yield $0$ could have been computed more directly. The particular scalar field is $f = -GMm/\|\vec{r}\|$, which goes by the name the gravitational *potential* function. As seen, $f$ depends only on magnitude, and as the endpoints of the path in the example have the same distance to the origin, the work integral, $(f\circ\vec{r})(b) - (f\circ\vec{r})(a)$ will be $0$.
"""

# ╔═╡ a59ee28e-c190-11ec-3ac9-6bbef065b6fb
md"""##### Example
"""

# ╔═╡ a59ee2ac-c190-11ec-19d8-5dd4f0b1b029
md"""Coulomb's law states that the electrostatic force between two charged particles is proportional to the product of their charges and *inversely* proportional to square of the distance between the two particles. That is,
"""

# ╔═╡ a59ee2c0-c190-11ec-1c3b-d545afc542d7
md"""```math
F = k\frac{ q q_0}{\|\vec{r}\|^2}\frac{\vec{r}}{\|\vec{r}\|}.
```
"""

# ╔═╡ a59ee2e8-c190-11ec-0eae-8b3711cc80ce
md"""This is similar to gravitational force and is a *conservative force*. We saw that a line integral for work in a conservative force depends only on the endpoints. Verify, that for a closed loop the work integral will yield $0$.
"""

# ╔═╡ a59ee308-c190-11ec-2643-31ba2a5612df
md"""Take as a closed loop the unit circle, parameterized by arc-length by $\vec{r}(t) = \langle \cos(t), \sin(t)\rangle$. The unit tangent will be $\hat{T} = \vec{r}'(t) = \langle -\sin(t), \cos(t) \rangle$. The work to move a particle of charge $q_0$ about a partical of charge $q$ at the origin around the unit circle would be computed through:
"""

# ╔═╡ a59ee838-c190-11ec-32f4-1dced35c1159
let
	@syms k q q0 t
	F(r) = k*q*q0 * r / norm(r)^3
	r(t) = [cos(t), sin(t)]
	T(r) = [-r[2], r[1]]
	W = integrate(F(r(t)) ⋅ T(r(t)), (t, 0, 2PI))
end

# ╔═╡ a59ee860-c190-11ec-2f67-b38086863075
md"""### Closed curves and regions;
"""

# ╔═╡ a59ee874-c190-11ec-1f59-3345490d5d75
md"""There are technical assumptions about curves and regions that are necessary for some statements to be made:
"""

# ╔═╡ a59eea22-c190-11ec-20d1-4d4b9cf823dc
md"""  * Let $C$ be a [Jordan](https://en.wikipedia.org/wiki/Jordan_curve_theorem) curve -  a non-self-intersecting continuous loop in the plane. Such a curve divides the plane into two regions, one bounded and one unbounded. The normal to a Jordan curve is assumed to be in the direction of the unbounded part.
  * Further, we will assume that our curves are *piecewise smooth*. That is comprised of finitely many smooth pieces, continuously connected.
  * The region enclosed by a closed curve has an *interior*, $D$, which we assume is an *open* set (one for which every point in $D$ has some "ball" about it entirely within $D$ as well.)
  * The region $D$ is *connected* meaning between any two points there is a continuous path in $D$ between the two points.
  * The region $D$ is *simply connected*. This means it has no "holes." Technically, any path in $D$ can be contracted to a point. Connected means one piece, simply connected means no holes.
"""

# ╔═╡ a59eea36-c190-11ec-106a-5b18db15a8ec
md"""### The fundamental theorem of line integrals
"""

# ╔═╡ a59eea68-c190-11ec-0313-216d5f454721
md"""The fact that work in a potential field is path independent is a consequence of the Fundamental Theorem of Line [Integrals](https://en.wikipedia.org/wiki/Gradient_theorem):
"""

# ╔═╡ a59eeb1c-c190-11ec-0014-f15ff94f46c2
md"""> Let $U$ be an open subset of $R^n$, $f: U \rightarrow R$ a *differentiable* function and $\vec{r}: R \rightarrow R^n$ a differentiable function such that the the path $C = \vec{r}(t)$, $a\leq t\leq b$ is contained in $U$. Then
>
> ```math
> \int_C  \nabla{f} \cdot d\vec{r} =
> \int_a^b \nabla{f}(\vec{r}(t)) \cdot \vec{r}'(t) dt =
> f(\vec{r}(b)) - f(\vec{r}(a)).
> ```

"""

# ╔═╡ a59eeb3a-c190-11ec-037c-a58a47a7ccc6
md"""That is, a line integral through a gradient field can be evaluated by evaluating the original scalar field at the endpoints of the curve. In other words, line integrals through gradient fields are conservative.
"""

# ╔═╡ a59eeb4e-c190-11ec-0215-fdf5b292168a
md"""Are conservative fields gradient fields? The answer is yes.
"""

# ╔═╡ a59eeb6c-c190-11ec-1e24-dd21282bb1ba
md"""Assume $U$ is an open region in $R^n$ and $F$ is  a continuous and conservative vector field in $U$.
"""

# ╔═╡ a59eeb8a-c190-11ec-2ede-714f198af165
md"""Let $a$ in $U$ be some fixed point. For $\vec{x}$ in $U$, define:
"""

# ╔═╡ a59f08ca-c190-11ec-0de0-8721cdc7bb81
md"""```math
\phi(\vec{x}) = \int_{\vec\gamma[a,\vec{x}]} F \cdot \frac{d\vec\gamma}{dt}dt,
```
"""

# ╔═╡ a59f0b42-c190-11ec-2930-9507b95a97f6
md"""where $\vec\gamma$ is *any* differentiable path in $U$ connecting $a$ to $\vec{x}$ (as a point in $U$). The function $\phi$ is uniquely defined, as the integral only depends on the endpoints, not the choice of path.
"""

# ╔═╡ a59f0bec-c190-11ec-0e56-29d42cd7be86
md"""It is [shown](https://en.wikipedia.org/wiki/Gradient_theorem#Converse_of_the_gradient_theorem) that the directional derivative $\nabla{\phi} \cdot \vec{v}$ is equal to $F \cdot \vec{v}$ by showing
"""

# ╔═╡ a59f0c28-c190-11ec-2da5-8b25dc447f2b
md"""```math
\lim_{t \rightarrow 0}\frac{\phi(\vec{x} + t\vec{v}) - \phi(\vec{x})}{t}
= \lim_{t \rightarrow 0} \frac{1}{t} \int_{\vec\gamma[\vec{x},\vec{x}+t\vec{v}]} F \cdot \frac{d\vec\gamma}{dt}dt
= F(\vec{x}) \cdot \vec{v}.
```
"""

# ╔═╡ a59f0c5a-c190-11ec-19cf-ab6e9ab17322
md"""This is so for all $\vec{v}$, so in particular for the coordinate vectors. So $\nabla\phi = F$.
"""

# ╔═╡ a59f0caa-c190-11ec-2340-bb0dc8159f04
md"""##### Example
"""

# ╔═╡ a59f0d2c-c190-11ec-1525-19e274e0cc35
md"""Let $Radial(x,y) = \langle x, y\rangle$. This is a conservative field. Show the work integral over the half circle in the upper half plane is the same as the work integral over the $x$ axis connecting $-1$ to $1$.
"""

# ╔═╡ a59f0d4a-c190-11ec-2043-f5a611ad84f7
md"""We have:
"""

# ╔═╡ a59f16dc-c190-11ec-3cfe-e7ef2f3f962e
begin
	Radial(x,y) = [x,y]
	Radial(v) = Radial(v...)
	
	r₁(t) = [-1 + t, 0]
	quadgk(t -> Radial(r₁(t)) ⋅ r₁'(t), 0, 2)
end

# ╔═╡ a59f172c-c190-11ec-0f35-075308f26018
md"""Compared to
"""

# ╔═╡ a59f1fe2-c190-11ec-06d2-eb4411541a29
begin
	r₂(t) = [-cos(t), sin(t)]
	quadgk(t -> Radial(r₂(t)) ⋅ r₂'(t), 0, pi)
end

# ╔═╡ a59f2028-c190-11ec-0e3b-8184f156b7c5
md"""##### Example
"""

# ╔═╡ a59f205a-c190-11ec-241d-a57a6b5b2549
md"""---
"""

# ╔═╡ a59f20c8-c190-11ec-2adb-6b0d0c951753
md"""Not all vector fields are conservative.  How can a vector field in $U$ be identified as conservative? For now, this would require either finding a scalar potential *or* showing all line integrals are path independent.
"""

# ╔═╡ a59f210e-c190-11ec-1fd2-0fd77c1157d4
md"""In dimension $2$ there is an easy to check method assuming $U$ is *simply connected*: If $F=\langle F_x, F_y\rangle$ is continuously differentiable in an simply connected region *and* $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y} = 0$ then $F$ is conservative. A similarly statement is available in dimension $3$. The reasoning behind this will come from the upcoming Green's theorem.
"""

# ╔═╡ a59f214a-c190-11ec-0fa0-7bea4f9d427a
md"""### Flow across a curve
"""

# ╔═╡ a59f2172-c190-11ec-1253-ff9c1a418cea
md"""The flow integral in the $n=2$ case was
"""

# ╔═╡ a59f21a4-c190-11ec-1fc6-870f8677db17
md"""```math
\int_C (F\cdot\hat{N}) ds = \int_a^b (F \circ \vec{r})(t) \cdot (\vec{r}'(t))^{t} dt,
```
"""

# ╔═╡ a59f21c2-c190-11ec-3fe0-e538cb0d69cc
md"""where $\langle a,b\rangle^t = \langle b, -a\rangle$.
"""

# ╔═╡ a59f21f4-c190-11ec-1e06-31a16936ba76
md"""For a given section of $C$, the vector field breaks down into a tangential and normal component. The tangential component moves along the curve and so doesn't contribute to any flow *across* the curve, only the normal component will contribute. Hence the $F\cdot\hat{N}$ integrand.  The following figure indicates the flow of a vector field by horizontal lines, the closeness of the lines representing strength, though these are all evenly space. The two line segments have equal length, but the one captures more flow than the other, as its normal vector is more parallel to the flow lines:
"""

# ╔═╡ a59f29f4-c190-11ec-105c-d78d74adfe8f
let
	p = plot(legend=false, aspect_ratio=:equal)
	for y in range(0, 1, length=15)
	    arrow!( [0,y], [3,0])
	end
	plot!(p, [2,2],[.6, .9], linewidth=3)
	arrow!( [2,.75],1/2*[1,0], linewidth=3)
	theta = pi/3
	l = .3/2
	plot!(p, [2-l*cos(theta), 2+l*cos(theta)], [.25-l*sin(theta), .25+l*sin(theta)], linewidth=3)
	arrow!( [2, 0.25], 1/2*[sin(theta), -cos(theta)], linewidth=3)
	
	p
end

# ╔═╡ a59f2a5a-c190-11ec-2867-61e264df1471
md"""The flow integral is typically computed for a closed (Jordan) curve, measuring the total flow out of a region. In this case, the integral is written $\oint_C (F\cdot\hat{N})ds$.
"""

# ╔═╡ a59f3824-c190-11ec-29f8-cdf0634abd29
note(L"""
For a Jordan curve, the positive orientation of the curve is such that the normal direction (proportional to $\hat{T}'$) points away from the bounded interior. For a non-closed path, the choice of parameterization will determine the normal and the integral for flow across a curve is dependent - up to its sign - on this choice.
""")

# ╔═╡ a59f386a-c190-11ec-3cab-43a3c9b64399
md"""##### Example
"""

# ╔═╡ a59f38c4-c190-11ec-33bc-97c10385f71f
md"""The [New York Times](https://www.nytimes.com/interactive/2019/06/20/world/asia/hong-kong-protest-size.html) showed aerial photos to estimate the number of protest marchers in Hong Kong. This is a more precise way to estimate crowd size, but requires a drone or some such to take photos. If one is on the ground, the number of marchers could be *estimated* by finding the flow of marchers across a given width. In the Times article, we see "Protestors packed the width of Hennessy Road for more than 5 hours. If this road is 50 meters wide and the rate of the marchers is 3 kilometers per hour, estimate the number of marchers.
"""

# ╔═╡ a59f38e2-c190-11ec-3d79-0b81ec8cf68c
md"""The basic idea is to compute the rate of flow *across* a part of the street and then multiply by time. For computational sake, say the marchers are on a grid of 1 meters (that is in a 40m wide street, there is room for 40 marchers at a time. In one minute, the marchers move 50 meters:
"""

# ╔═╡ a59f3b26-c190-11ec-16a2-8d7751ff81fc
3000/60

# ╔═╡ a59f3b62-c190-11ec-30f6-61fb3c3cad1b
md"""This means the rate of marchers per minute is `40 * 50`. If this is steady over 5 hours, this *simple* count gives:
"""

# ╔═╡ a59f3e64-c190-11ec-3472-3fd4ad829a64
40 * 50 * 5 * 60

# ╔═╡ a59f3e8c-c190-11ec-285b-29b427d74538
md"""This is short of the estimate 2M marchers, but useful for a rough estimate. The point is from rates of  flow, which can be calculated locally, amounts over bigger scales can be computed. The word "*across*" is used, as only the direction across the part of the street counts in the computation. Were the marchers in total unison and then told to take a step to the left and a step to the right, they would have motion, but since it wasn't across the line in the road (rather along the line) there would be no contribution to the count. The dot product with the normal vector formalizes this.
"""

# ╔═╡ a59f3eaa-c190-11ec-3f2d-fbcc30260b06
md"""##### Example
"""

# ╔═╡ a59f3ee8-c190-11ec-18a6-69bb08301e53
md"""Let a path $C$ be parameterized by $\vec{r}(t) = \langle \cos(t), 2\sin(t)\rangle$, $0 \leq t \leq \pi/2$ and $F(x,y) = \langle \cos(x), \sin(xy)\rangle$. Compute the flow across $C$.
"""

# ╔═╡ a59f3efa-c190-11ec-316e-e70a6168b3b5
md"""We have
"""

# ╔═╡ a59f44f4-c190-11ec-1c5b-39dad2d4b5c6
let
	r(t) = [cos(t), 2sin(t)]
	F(x,y) = [cos(x), sin(x*y)]
	F(v) = F(v...)
	normal(a,b) = [b, -a]
	G(t) = (F ∘ r)(t) ⋅ normal(r(t)...)
	a, b = 0, pi/2
	quadgk(G, a, b)[1]
end

# ╔═╡ a59f4512-c190-11ec-0543-a13f3113c71f
md"""##### Example
"""

# ╔═╡ a59f453a-c190-11ec-2050-7b05e4c9d7f3
md"""Example, let $F(x,y) = \langle -y, x\rangle$ be a vector field. (It represents an rotational flow.) What is the flow across the unit circle?
"""

# ╔═╡ a59f4936-c190-11ec-28fd-971760647424
let
	@syms t::real
	F(x,y) = [-y,x]
	F(v) = F(v...)
	r(t) = [cos(t),sin(t)]
	T(t) = diff.(r(t), t)
	normal(a,b) = [b,-a]
	integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))
end

# ╔═╡ a59f4952-c190-11ec-0780-61b6aa34a225
md"""##### Example
"""

# ╔═╡ a59f4984-c190-11ec-399f-fda8a1d8fa16
md"""Let $F(x,y) = \langle x,y\rangle$ be a vector field. (It represents a *source*.) What is the flow across the unit circle?
"""

# ╔═╡ a59f4d26-c190-11ec-1e04-75c30f71d8dd
let
	@syms t::real
	F(x,y) = [x, y]
	F(v) = F(v...)
	r(t) = [cos(t),sin(t)]
	T(t) = diff.(r(t), t)
	normal(a,b) = [b,-a]
	integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))
end

# ╔═╡ a59f4d46-c190-11ec-3df2-c1614cb2d58e
md"""##### Example
"""

# ╔═╡ a59f4d6e-c190-11ec-0452-0d9acef85b32
md"""Let $F(x,y) = \langle x, y\rangle / \| \langle x, y\rangle\|^3$:
"""

# ╔═╡ a59f5354-c190-11ec-1370-0b49ccd27d63
begin
	F₁(x,y) = [x,y] / norm([x,y])^2
	F₁(v) = F₁(v...)
end

# ╔═╡ a59f53ae-c190-11ec-2dc9-7959e9fa5c91
md"""Consider $C$ to be the square with vertices at $(-1,-1)$, $(1,-1)$, $(1,1)$, and $(-1, 1)$. What is the flow across $C$ for this vector field? The region has simple outward pointing *unit* normals, these being $\pm\hat{i}$ and $\pm\hat{j}$, the unit vectors in the $x$ and $y$ direction. The integral can be computed in 4 parts. The first (along the bottom):
"""

# ╔═╡ a59f5782-c190-11ec-3538-4ff07224e13c
let
	@syms s::real
	
	r(s) = [-1 + s, -1]
	n = [0,-1]
	A1 = integrate(F₁(r(s)) ⋅ n, (s, 0, 2))
	
	#The other three sides are related as each parameterization and normal is similar:
	
	r(s) = [1, -1 + s]
	n = [1, 0]
	A2 = integrate(F₁(r(s)) ⋅ n, (s, 0, 2))
	
	
	r(s) = [1 - s, 1]
	n = [0, 1]
	A3 = integrate(F₁(r(s)) ⋅ n, (s, 0, 2))
	
	
	r(s) = [-1, 1-s]
	n = [-1, 0]
	A4 = integrate(F₁(r(s)) ⋅ n, (s, 0, 2))
	
	A1 +  A2 +  A3 + A4
end

# ╔═╡ a59f57be-c190-11ec-0bd8-bd4d48627bd7
md"""As could have been anticipated by symmetry, the answer is simply `4A1` or $2\pi$. What likely is not anticipated, is that this integral will be the same as that found by integrating over the unit circle (an easier integral):
"""

# ╔═╡ a59f5b60-c190-11ec-3086-c342b8265f75
let
	@syms t::real
	r(t) = [cos(t), sin(t)]
	N(t) = r(t)
	integrate(F₁(r(t)) ⋅ N(t), (t, 0, 2PI))
end

# ╔═╡ a59f5b7e-c190-11ec-0005-2596fd67a21b
md"""This equivalence is a consequence of the upcoming Green's theorem, as the vector field satisfies a particular equation.
"""

# ╔═╡ a59f5ba6-c190-11ec-3e04-c755fc67a61c
md"""## Surface integrals
"""

# ╔═╡ a59f6148-c190-11ec-247a-bb178ece0137
let
	#out = download("https://upload.wikimedia.org/wikipedia/en/c/c1/Cloud_Gate_%28The_Bean%29_from_east%27.jpg")
	#cp(out, "figures/kapoor-cloud-gate.jpg")
	imgfile = "figures/kapoor-cloud-gate.jpg"
	caption = """
	The Anish Kapoor sculpture Cloud Gate maps the Cartesian grid formed by its concrete resting pad onto a curved surface showing the local distortions.  Knowing the areas of the reflected grid after distortion would allow the computation of the surface area of the sculpture through addition. (Wikipedia)
	"""
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ a59f6196-c190-11ec-3ea3-11db6bc50855
md"""We next turn attention to a generalization of line integrals to surface integrals. Surfaces were described in one of three ways: directly through a function as $z=f(x,y)$, as a level curve through $f(x,y,z) = c$, and parameterized through a function $\Phi: R^2 \rightarrow R^3$. The level curve description is locally a function description, and the function description leads to a parameterization ($\Phi(u,v) = \langle u,v,f(u,v)\rangle$) so we restrict to the parameterized case.
"""

# ╔═╡ a59f61be-c190-11ec-3239-2df587af01be
md"""Consider the figure of the surface described by $\Phi(u,v) = \langle u,v,f(u,v)\rangle$:
"""

# ╔═╡ a59f6934-c190-11ec-311b-45091936f659
let
	f(x,y) = 2 - (x+1/2)^2 - y^2
	xs = ys = range(0, 1/2, length=10)
	p = surface(xs, ys, f, legend=false, camera=(45,45))
	for x in xs
	    plot!(p, unzip(y -> [x, y, f(x,y)], 0, 1/2)..., linewidth=3)
	    plot!(p, unzip(y -> [x, y, 0], 0, 1/2)..., linewidth=3)
	end
	for y in ys
	    plot!(p, unzip(x -> [x, y, f(x,y)], 0, 1/2)..., linewidth=3)
	    plot!(p, unzip(x -> [x, y, 0], 0, 1/2)..., linewidth=3)
	end
	p
end

# ╔═╡ a59f698e-c190-11ec-2c06-31f1a6638fa0
md"""The partitioning of the $u-v$ plane into a grid, lends itself to a partitioning of the surface. To compute the total *surface area* of the surface, it would be natural to begin by *approximating* the area of each cell of this partition and add. As with other sums, we would expect that as the cells got smaller in diameter, the sum would approach an integral, in this case an integral yielding the surface area.
"""

# ╔═╡ a59f69a2-c190-11ec-2c9d-7114634f4f59
md"""Consider a single cell:
"""

# ╔═╡ a59f6d4e-c190-11ec-164c-1d464c7c59b5
let
	# from https://commons.wikimedia.org/wiki/File:Surface_integral1.svg
	#cp(download("https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Surface_integral1.svg/500px-Surface_integral1.svg.png"), "figures/surface-integral-cell.png", force=true)
	#imgfile = "figures/surface-integral-cell.png"
	#caption = "The rectangular region maps to a piece of the surface approximated by #a parallelogram whose area can be computed. (Wikipedia)"
	#ImageFile(:integral_vector_calculus, imgfile, caption)
	nothing
end

# ╔═╡ a59f771c-c190-11ec-173f-ffd3acd260f9
let
	f(x,y)= .5 - ((x-2)/4)^2 - ((y-1)/3)^2
	Phi(uv) = [uv[1],uv[2],f(uv...)]
	
	xs = range(0, 3.5, length=50)
	ys = range(0, 2.5, length=50)
	surface(xs,ys, f, legend=false)
	Δx = 0.5; Δy = 0.5
	x0 = 2.5; y0 = 0.25
	
	ps = [[x0,y0,0], [x0+Δx,y0,0],[x0+Δx,y0+Δy,0],[x0, y0+Δy, 0],[x0,y0,0]]
	plot!(unzip(ps)..., seriestype=:shape, color =:blue)
	
	fx = t -> [x0+t, y0, f(x0+t, y0)]
	fy = t -> [x0, y0+t, f(x0, y0+t)]
	plot!(unzip(fx.(xs.-x0))..., color=:green)
	plot!(unzip(fy.(ys.-y0))..., color=:green)
	fx = t -> [x0+t, y0+Δy, f(x0+t, y0+Δy)]
	fy = t -> [x0+Δx, y0+t, f(x0+Δx, y0+t)]
	ts = range(0, 1, length=20)
	plot!(unzip(fx.(ts*Δx))..., color=:green)
	plot!(unzip(fy.(ts*Δy))..., color=:green)
	
	Pt = [x0,y0,f(x0,y0)]
	Jac = ForwardDiff.jacobian(Phi, Pt[1:2])
	v1 = Jac[:,1]; v2 = Jac[:,2]
	arrow!(Pt, v1/2, linewidth=5, color=:red)
	arrow!(Pt, v2/2, linewidth=5, color=:red)
	arrow!(Pt + v1/2, v2/2, linewidth=1, linetype=:dashed, color=:red)
	arrow!(Pt + v2/2, v1/2, linewidth=1, linetype=:dashed, color=:red)
	arrow!(Pt, (1/4)*(v1 × v2), linewidth=3, color=:blue)
end

# ╔═╡ a59f776c-c190-11ec-3c31-61a9c08c4b48
md"""The figure shows that a cell on the grid in the $u-v$ plane of area $\Delta{u}\Delta{v}$ maps to a cell of the partition with surface area $\Delta{S}$ which can be *approximated* by a part of the tangent plane described by two vectors $\vec{v}_1 = \partial{\Phi}/\partial{u}$ and $\vec{v}_2 = \partial{\Phi}/\partial{v}$. These two vectors have cross product which a) points in the direction of the normal vector, and b) has magnitude yielding the approximation $\Delta{S} \approx \|\vec{v}_1 \times \vec{v}_2\|\Delta{u}\Delta{v}$.
"""

# ╔═╡ a59f779e-c190-11ec-21e8-c555b25a4164
md"""If we were to integrate the function $G(x,y, z)$ over the *surface* $S$, then an approximating Riemann sum could be produced by $G(c) \| \vec{v}_1 \times \vec{v}_2\| \Delta u \Delta v$, for some point $c$ on the surface.
"""

# ╔═╡ a59f77d0-c190-11ec-19b4-73b1af2ab83c
md"""In the limit a definition of an *integral* over a surface $S$ in $R^3$ is found by a two-dimensional integral over $R$ in $R^2$:
"""

# ╔═╡ a59f77ee-c190-11ec-0c1f-e143bf6f5adf
md"""```math
\int_S G(x,y,z) dS = \int_R G(\Phi(u,v))
\| \frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}} \| du dv.
```
"""

# ╔═╡ a59f7820-c190-11ec-287f-4749f72b3755
md"""In the case that the surface is described by $z = f(x,y)$, then the formula's become $\vec{v}_1 = \langle 1,0,\partial{f}/\partial{x}\rangle$ and $\vec{v}_2 = \langle 0, 1, \partial{f}/\partial{y}\rangle$ with cross product $\vec{v}_1\times\vec{v}_2 =\langle -\partial{f}/\partial{x},  -\partial{f}/\partial{y},1\rangle$.
"""

# ╔═╡ a59f7852-c190-11ec-1ae8-6330b1112ed2
md"""The value $\| \frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{y}} \|$ is called the *surface element*. As seen, it is the scaling between a unit area in the $u-v$ plane and the approximating area on the surface after the parameterization.
"""

# ╔═╡ a59f7884-c190-11ec-3699-91e4b752899b
md"""### Examples
"""

# ╔═╡ a59f789a-c190-11ec-04a2-c9a0e54055ef
md"""Let us see that the formula holds for some cases where the answer is known by other means.
"""

# ╔═╡ a59f78b6-c190-11ec-3bc8-b3e53c82a9db
md"""##### A cone
"""

# ╔═╡ a59f78d4-c190-11ec-0e24-372de774018c
md"""The surface area of cone is a known quantity. In cylindrical coordinates, the cone may be described by $z = a - br$, so the parameterization $(r, \theta) \rightarrow \langle r\cos(\theta), r\sin(\theta), a - br \rangle$ maps $T = [0, a/b] \times [0, 2\pi]$ onto the surface (less the bottom).
"""

# ╔═╡ a59f78f2-c190-11ec-1f8b-a9a54ef5da99
md"""The surface element is the cross product $\langle \cos(\theta), \sin(\theta), -b\rangle$ and $\langle -r\sin(\theta), r\cos(\theta), 0\rangle$, which is:
"""

# ╔═╡ a59f9896-c190-11ec-27e6-fb425caebc8b
begin
	@syms 𝑹::postive θ::positive 𝒂::positive 𝒃::positive
	𝒏 = [cos(θ), sin(θ), -𝒃] × [-𝑹*sin(θ), 𝑹*cos(θ), 0]
	𝒔𝒆 = simplify(norm(𝒏))
end

# ╔═╡ a59f98dc-c190-11ec-3f0d-9fe6070b4797
md"""(To do this computationally, one might compute:
"""

# ╔═╡ a59fa1b0-c190-11ec-1a11-adae8e7748a4
let
	Phi(r, theta) = [r*cos(theta), r*sin(theta), 𝒂 - 𝒃*r]
	Phi(𝑹, θ).jacobian([𝑹, θ])
end

# ╔═╡ a59fa1d0-c190-11ec-2bfa-49249fe5a77a
md"""and from here pull out the two vectors to take a cross product.)
"""

# ╔═╡ a59fa20a-c190-11ec-00da-0f502703851e
md"""The surface area is then found by integrating $G(\vec{x}) = 1$:
"""

# ╔═╡ a59fa91c-c190-11ec-37a3-1b68d068da49
integrate(1 * 𝒔𝒆, (𝑹, 0, 𝒂/𝒃), (θ, 0, 2PI))

# ╔═╡ a59fa96a-c190-11ec-0a3c-23fabca23562
md"""A formula from a *quick* Google search is $A = \pi r(r^2  + \sqrt{h^2 + r^2}$. Does this match up?
"""

# ╔═╡ a59fae6c-c190-11ec-011a-91f5072cdef6
let
	𝑹 = 𝒂/𝒃; 𝒉 = 𝒂
	pi * 𝑹 * (𝑹 + sqrt(𝑹^2 + 𝒉^2)) |> simplify
end

# ╔═╡ a59fae9e-c190-11ec-2684-f7c82e632af8
md"""Nope, off by a summand of $\pi(a/b)^2 = \pi r^2$, which may be recognized as the area of the base, which we did not compute, but which the Google search did. So yes, the formulas do agree.
"""

# ╔═╡ a59faebc-c190-11ec-00e2-ab7688d3a844
md"""##### Example
"""

# ╔═╡ a59faee4-c190-11ec-2584-1d7a0cd24457
md"""The sphere has known surface area $4\pi r^2$. Let's see if we can compute this. With the parameterization from spherical coordinates $(\theta, \phi) \rightarrow \langle r\sin\phi\cos\theta, r\sin\phi\sin\theta,r\cos\phi\rangle$, we have approaching this *numerically*:
"""

# ╔═╡ a59fb2de-c190-11ec-322b-29799ef15275
let
	Rad = 1
	Phi(theta, phi) = Rad * [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
	Phi(v) = Phi(v...)
	
	function surface_element(pt)
	  Jac = ForwardDiff.jacobian(Phi, pt)
	  v1, v2 = Jac[:,1], Jac[:,2]
	  norm(v1 × v2)
	end
	out = hcubature(surface_element, (0, 0), (2pi, 1pi))
	out[1] - 4pi*Rad^2  # *basically* zero
end

# ╔═╡ a59fb308-c190-11ec-060c-a571b31c76d4
md"""##### Example
"""

# ╔═╡ a59fb34e-c190-11ec-1d14-117f02e8d326
md"""In [Surface area](../integrals/surface_area.mmd) the following formula for the surface area of a surface of *revolution* about the $x$ axis is described by $r=f(x)$ is given:
"""

# ╔═╡ a59fb382-c190-11ec-3cb7-c717270ff20f
md"""```math
\int_a^b 2\pi f(x) \cdot \sqrt{1 + f'(x)^2} dx.
```
"""

# ╔═╡ a59fb3b4-c190-11ec-0fdc-5996d865d26a
md"""Consider the transformation $(x, \theta) \rightarrow \langle x, f(x)\cos(\theta), f(x)\sin(\theta)$. This maps the region $[a,b] \times [0, 2\pi]$ *onto* the surface of revolution. As such, the surface element would be:
"""

# ╔═╡ a59fb9a2-c190-11ec-2d14-a58a58793b7b
let
	@syms f()::positive x::real theta::real
	
	Phi(x, theta) = [x, f(x)*cos(theta), f(x)*sin(theta)]
	Jac = Phi(x, theta).jacobian([x, theta])
	v1, v2 = Jac[:,1], Jac[:,2]
	se = norm(v1 × v2)
	se .|> simplify
end

# ╔═╡ a59fb9ca-c190-11ec-2535-95a4d4f041cf
md"""This in agreement with the previous formula.
"""

# ╔═╡ a59fb9e6-c190-11ec-0420-0fb692d51ad1
md"""##### Example
"""

# ╔═╡ a59fba1a-c190-11ec-156d-8f6b68a97e2a
md"""Consider the *upper* half sphere, $S$. Compute $\int_S z dS$.
"""

# ╔═╡ a59fba38-c190-11ec-3020-1b24a59f05df
md"""Were the half sphere made of a thin uniform material, this would be computed to find the $z$ direction of the centroid.
"""

# ╔═╡ a59fba4c-c190-11ec-119d-475957f0e9c5
md"""We use the spherical coordinates to parameterize:
"""

# ╔═╡ a59fba60-c190-11ec-007a-3f65f50c6c86
md"""```math
\Phi(\theta, \phi) = \langle \cos(\phi)\cos(\theta), \cos(\phi)\sin(\theta), \sin(\phi) \rangle
```
"""

# ╔═╡ a59fba74-c190-11ec-2e8e-cb3316bab9e8
md"""The Jacobian and surface element are computed and then the integral is performed:
"""

# ╔═╡ a59fbf42-c190-11ec-1aaf-897e5bfb69f6
let
	@syms theta::real phi::real
	Phi(theta, phi) = [cos(phi)*cos(theta), cos(phi)*sin(theta), sin(phi)]
	Jac = Phi(theta,phi).jacobian([theta, phi])
	
	v1, v2 = Jac[:,1], Jac[:,2]
	SurfElement = norm(v1 × v2) |> simplify
	
	z = sin(phi)
	integrate(z * SurfElement, (theta, 0, 2PI), (phi, 0, PI/2))
end

# ╔═╡ a59fbf6a-c190-11ec-2e22-6d76358b4a22
md"""### Orientation
"""

# ╔═╡ a59fbfba-c190-11ec-26d5-d3a269b36678
md"""A smooth surface $S$ is *orientable* if it possible to define a unit normal vector, $\vec{N}$ that varies continuously with position. For example, a sphere has a normal vector that does this. On the other hand, a Mobius strip does not, as a normal when moved around the surface may necessarily be reversed as it returns to its starting point. For a closed, orientable smooth surface there are two possible choices for a normal, and convention chooses the one that points away from the contained region, such as the outward pointing normal for the sphere or torus.
"""

# ╔═╡ a59fbfce-c190-11ec-1807-5bca09faeb51
md"""### Surface integrals in vector fields
"""

# ╔═╡ a59fc014-c190-11ec-198e-4912b7002ea3
md"""Beyond finding surface area, surface integrals can also compute interesting physical phenomena. These are often associated to a vector field (in this case a function $\vec{F}: R^3 \rightarrow R^3$), and the typical case is the *flux* through a surface defined locally by $\vec{F} \cdot \hat{N}$, that is the *magnitude* of the *projection* of the field onto the *unit* normal vector.
"""

# ╔═╡ a59fc03c-c190-11ec-29c6-85de0b036375
md"""Consider the flow of water through an opening in a time period $\Delta t$. The amount of water mass to flow through would be the area of the opening times the velocity of the flow perpendicular to the surface times the density times the time period; symbolically: $dS \cdot ((\rho \vec{v}) \cdot \vec{N}) \cdot \Delta t$. Dividing by $\Delta t$ gives a rate of flow as $((\rho \vec{v}) \cdot \vec{N}) dS$. With $F = \rho \vec{v}$, the flux integral can be seen as the rate of flow through a surface.
"""

# ╔═╡ a59fc064-c190-11ec-2cb6-bd0d1c7992b5
md"""To find the normal for a surface element arising from a parameterization $\Phi$, we have the two *partial* derivatives $\vec{v}_1=\partial{\Phi}/\partial{u}$ and $\vec{v}_2 = \partial{\Phi}/\partial{v}$, the two column vectors of the Jacobian matrix of $\Phi(u,v)$. These describe the tangent plane, and even more their cross product will be a) *normal* to the tangent plane and b) have magnitude yielding the surface element of the transformation.
"""

# ╔═╡ a59fc082-c190-11ec-3a5f-7107c9959b7d
md"""From this, for a given parameterization, $\Phi(u,v):T \rightarrow S$, the following formula is suggested for orientable surfaces:
"""

# ╔═╡ a59fc096-c190-11ec-0779-4929c7aa4da9
md"""```math
\int_S \vec{F} \cdot \hat{N} dS =
\int_T \vec{F}(\Phi(u,v)) \cdot
(\frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}})
du dv.
```
"""

# ╔═╡ a59fc0dc-c190-11ec-179f-67dd808e8dfb
md"""When the surface is described by a function, $z=f(x,y)$, the parameterization is $(u,v) \rightarrow \langle u, v, f(u,v)\rangle$, and the two vectors are $\vec{v}_1 = \langle 1, 0, \partial{f}/\partial{u}\rangle$ and $\vec{v}_2 = \langle 0, 1, \partial{f}/\partial{v}\rangle$ and their cross product is $\vec{v}_1\times\vec{v}_1=\langle -\partial{f}/\partial{u}, -\partial{f}/\partial{v}, 1\rangle$.
"""

# ╔═╡ a59fc0f0-c190-11ec-1ed1-fd2604208770
md"""##### Example
"""

# ╔═╡ a59fc122-c190-11ec-1b42-a3f205bbea1e
md"""Suppose a vector field $F(x,y,z) = \langle 0, y, -z \rangle$ is given. Let $S$ be the surface of the paraboloid $y = x^2 + z^2$ between $y=0$ and $y=4$. Compute the surface integral $\int_S F\cdot \hat{N} dS$.
"""

# ╔═╡ a59fc140-c190-11ec-1042-5db1abf4b758
md"""This is a surface of revolution about the $y$ axis, so a parameterization is $\Phi(y,\theta) = \langle \sqrt{y} \cos(\theta), y, \sqrt{y}\sin(\theta) \rangle$. The surface normal is given by:
"""

# ╔═╡ a59fc604-c190-11ec-018b-d18988112db0
let
	@syms y::positive theta::positive
	Phi(y,theta) = [sqrt(y)*cos(theta), y, sqrt(y)*sin(theta)]
	Jac = Phi(y, theta).jacobian([y, theta])
	v1, v2 = Jac[:,1], Jac[:,2]
	Normal = v1 × v2
	
	# With this, the surface integral becomes:
	
	F(x,y,z) = [0, y, -z]
	F(v) = F(v...)
	integrate(F(Phi(y,theta)) ⋅ Normal, (theta, 0, 2PI), (y, 0, 4))
end

# ╔═╡ a59fc622-c190-11ec-0d83-2bcc2d5b297c
md"""##### Example
"""

# ╔═╡ a59fc654-c190-11ec-036c-0feba535e318
md"""Let $S$ be the closed surface bounded by the cylinder $x^2 + y^2 = 1$, the plane $z=0$, and the plane $z = 1+x$. Let $F(x,y,z) =  \langle 1, y, -z \rangle$. Compute $\oint_S F\cdot\vec{N} dS$.
"""

# ╔═╡ a59fcb38-c190-11ec-3fcf-6b46253ff374
begin
	𝐅(x,y,z) = [1, y, z]
	𝐅(v) = 𝐅(v...)
end

# ╔═╡ a59fcb72-c190-11ec-2dfa-b3a658093988
md"""The surface has three faces, with different outward pointing normals for each. Let $S_1$ be the unit disk in the $x-y$ plane with normal $-\hat{k}$; $S_2$ be the top part, with normal $\langle \langle-1, 0, 1\rangle$ (as the plane is $-1x + 0y + 1z = 1$); and $S_3$ be the cylindrical part with outward pointing normal $\vec{r}$.
"""

# ╔═╡ a59fcb90-c190-11ec-134b-7539c333fadd
md"""Integrating over $S_1$, we have the parameterization $\Phi(r,\theta) = \langle r\cos(\theta), r\sin(\theta), 0\rangle$:
"""

# ╔═╡ a59fd0d4-c190-11ec-3700-5b7e91d62780
begin
	@syms 𝐑::positive 𝐭heta::positive
	𝐏hi₁(r,theta) = [r*cos(theta), r*sin(theta), 0]
	𝐉ac₁ = 𝐏hi₁(𝐑, 𝐭heta).jacobian([𝐑, 𝐭heta])
	𝐯₁, 𝐰₁ = 𝐉ac₁[:,1], 𝐉ac₁[:,2]
	𝐍ormal₁ = 𝐯₁ × 𝐰₁ .|> simplify
end

# ╔═╡ a59fd98c-c190-11ec-0101-e1baf1db35a8
A₁ = integrate(𝐅(𝐏hi₁(𝐑, 𝐭heta)) ⋅ (-𝐍ormal₁), (𝐭heta, 0, 2PI), (𝐑, 0, 1))  # use -Normal for outward pointing

# ╔═╡ a59fd9be-c190-11ec-1cd7-61003d026436
md"""Integrating over $S_2$ we use the parameterization $\Phi(r, \theta) = \langle r\cos(\theta), r\sin(\theta), 1 + r\cos(\theta)\rangle$.
"""

# ╔═╡ a59ff79e-c190-11ec-1be0-27704de0f98a
begin
	𝐏hi₂(r, theta) = [r*cos(theta), r*sin(theta), 1 + r*cos(theta)]
	𝐉ac₂ = 𝐏hi₂(𝐑, 𝐭heta).jacobian([𝐑, 𝐭heta])
	𝐯₂, 𝐰₂ = 𝐉ac₂[:,1], 𝐉ac₂[:,2]
	𝐍ormal₂ = 𝐯₂ × 𝐰₂ .|> simplify  # has correct orientation
end

# ╔═╡ a59ff7e6-c190-11ec-0f9b-e108b0419428
md"""With this, the contribution for $S_2$ is:
"""

# ╔═╡ a5a0001a-c190-11ec-3364-050686fa1040
A₂ = integrate(𝐅(𝐏hi₂(𝐑, 𝐭heta)) ⋅ (𝐍ormal₂), (𝐭heta, 0, 2PI), (𝐑, 0, 1))

# ╔═╡ a5a00056-c190-11ec-245f-5b308d508816
md"""Finally for $S_3$, the parameterization used is $\Phi(z, \theta) = \langle \cos(\theta), \sin(\theta), z\rangle$, but this is over a non-rectangular region, as $z$ is between $0$ and $1 + x$.
"""

# ╔═╡ a5a00074-c190-11ec-2135-676ebaaf2b66
md"""This parameterization gives a normal computed through:
"""

# ╔═╡ a5a004a2-c190-11ec-3c31-d9a992d36bfe
begin
	@syms 𝐳::positive
	𝐏hi₃(z, theta) = [cos(theta), sin(theta), 𝐳]
	𝐉ac₃ = 𝐏hi₃(𝐳, 𝐭heta).jacobian([𝐳, 𝐭heta])
	𝐯₃, 𝐰₃ = 𝐉ac₃[:,1], 𝐉ac₃[:,2]
	𝐍ormal₃ = 𝐯₃ × 𝐰₃ .|> simplify  # wrong orientation, so we change sign below
end

# ╔═╡ a5a004c0-c190-11ec-11b1-4933e257ec23
md"""The contribution is
"""

# ╔═╡ a5a00e20-c190-11ec-02b2-6f3f82aa38c6
A₃ = integrate(𝐅(𝐏hi₃(𝐑, 𝐭heta)) ⋅ (-𝐍ormal₃), (𝐳, 0, 1 + cos(𝐭heta)), (𝐭heta, 0, 2PI))

# ╔═╡ a5a00e3e-c190-11ec-026e-b98ff5bffd4c
md"""In total, the surface integral is
"""

# ╔═╡ a5a0101e-c190-11ec-308c-d9c70c09df2c
A₁ + A₂ + A₃

# ╔═╡ a5a0103c-c190-11ec-397a-07f804ebdc68
md"""##### Example
"""

# ╔═╡ a5a0108c-c190-11ec-3df4-039be7a47aa9
md"""Two point charges with charges $q$ and $q_0$ will exert an electrostatic force of attraction or repulsion according to [Coulomb](https://en.wikipedia.org/wiki/Coulomb%27s_law)'s law. The Coulomb force is $kqq_0\vec{r}/\|\vec{r}\|^3$. This force is proportional to the product of the charges, $qq_0$, and inversely proportional to the square of the distance between them.
"""

# ╔═╡ a5a010b4-c190-11ec-3f93-ffe0c0bbf883
md"""The electric field is a vector field is the field generated by the force on a test charge, and is given by $E = kq\vec{r}/\|\vec{r}\|^3$.
"""

# ╔═╡ a5a010d2-c190-11ec-1bcc-af221e179d77
md"""Let $S$ be the unit sphere $\|\vec{r}\|^2 = 1$. Compute the surface integral of the electric field over the closed surface, $S$.
"""

# ╔═╡ a5a010f0-c190-11ec-0a9e-49c2193acfca
md"""We have (using $\oint$ for a surface integral over a closed surface):
"""

# ╔═╡ a5a0110e-c190-11ec-3457-093e2731a962
md"""```math
\oint_S S \cdot \vec{N} dS =
\oint_S \frac{kq}{\|\vec{r}\|^2} \hat{r} \cdot \hat{r} dS =
\oint_S \frac{kq}{\|\vec{r}\|^2} dS =
kqq_0 \cdot SA(S) =
4\pi k q
```
"""

# ╔═╡ a5a01122-c190-11ec-34f4-2370fff49407
md"""Now consider the electric field generated by a point charge within the unit sphere, but not at the origin. The integral now will not fall in place by symmetry considerations, so we will approach the problem numerically.
"""

# ╔═╡ a5a0180c-c190-11ec-3c04-317bda85ede4
begin
	E(r) = (1/norm(r)^2) * uvec(r) # kq = 1
	
	Phiₑ(theta, phi) = 1*[sin(phi)*cos(theta), sin(phi) * sin(theta), cos(phi)]
	Phiₑ(r) = Phiₑ(r...)
	
	normal(r) = Phiₑ(r)/norm(Phiₑ(r))
	
	function SE(r)
	    Jac = ForwardDiff.jacobian(Phiₑ, r)
	    v1, v2 = Jac[:,1], Jac[:,2]
	    v1 × v2
	end
	
	a = rand() * Phiₑ(2pi*rand(), pi*rand())
	A1 = hcubature(r -> E(Phiₑ(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, 1pi))
	A1[1]
end

# ╔═╡ a5a01864-c190-11ec-0c04-870c602a6978
md"""The answer is $4\pi$, regardless of the choice of `a`, as long as it is *inside* the surface. (We see above, some fussiness in the limits of integration. `HCubature` does some conversion of the limits, but does not *currently* do well with mixed types, so in the above only floating point values are used.)
"""

# ╔═╡ a5a01896-c190-11ec-3677-155c4b8615a9
md"""When `a` is *outside* the surface, the answer is *always* a constant:
"""

# ╔═╡ a5a02042-c190-11ec-31da-e95d6a30db3e
let
	a = 2 * Phiₑ(2pi*rand(), pi*rand())  # random point with radius 2
	A1 = hcubature(r -> E(Phiₑ(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, pi/2))
	A2 = hcubature(r -> E(Phiₑ(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,pi/2), (2pi, 1pi))
	A1[1] + A2[1]
end

# ╔═╡ a5a0207c-c190-11ec-06d4-9dadd3e2ab01
md"""That constant being $0$.
"""

# ╔═╡ a5a020c2-c190-11ec-3d21-4d821b0a46d6
md"""This is a consequence of [Gauss's law](https://en.wikipedia.org/wiki/Gauss%27s_law), which states that for an electric field $E$, the electric flux through a closed surface is proportional to the total charge contained. (Gauss's law is related to the upcoming divergence theorem.) When `a` is inside the surface, the total charge is the same regardless of exactly where, so the integral's value is always the same. When `a` is outside the surface, the total charge inside the sphere is $0$, so the flux integral is as well.
"""

# ╔═╡ a5a02112-c190-11ec-2985-b76a24b19c17
md"""Gauss's law is typically used to identify the electric field by choosing a judicious surface where the surface integral can be computed. For example, suppose a ball of radius $R_0$ has a *uniform* charge. What is the electric field generated? *Assuming* it is dependent only on the distance from the center of the charged ball, we can, first, take a sphere of radius $R > R_0$ and note that $E(\vec{r})\cdot\hat{N}(r) = \|E(R)\|$, the magnitude a distance $R$ away. So the surface integral is simply $\|E(R)\|4\pi R^2$ and by Gauss's law a constant depending on the total charge. So $\|E(R)\| ~ 1/R^2$. When $R < R_0$, the same applies, but the total charge within the surface will be like $(R/R_0 )^3$, so the result will be *linear* in $R$, as:
"""

# ╔═╡ a5a02130-c190-11ec-3872-8b017500e529
md"""```math
4 \pi \|E(R)\| R^2 = k 4\pi \left(\frac{R}{R_0}\right)^3.
```
"""

# ╔═╡ a5a0214e-c190-11ec-2897-93d6c4d7dd19
md"""## Questions
"""

# ╔═╡ a5a02178-c190-11ec-145e-15d2d1f5674f
md"""###### Question
"""

# ╔═╡ a5a02194-c190-11ec-2708-d1079de4cc9e
md"""Let $\vec{r}(t) = \langle e^t\cos(t), e^{-t}\sin(t) \rangle$.
"""

# ╔═╡ a5a021aa-c190-11ec-31ac-134cf0ca5dbf
md"""What is $\|\vec{r}'(1/2)\|$?
"""

# ╔═╡ a5a0293c-c190-11ec-3612-2fd529e75cef
let
	r(t) = [exp(t)*cos(t), exp(-t)*sin(t)]
	val = norm(r'(1/2))
	numericq(val)
end

# ╔═╡ a5a0296e-c190-11ec-0e23-37254a3648b5
md"""What is the $x$ (first) component of $\hat{N}(t) = \hat{T}'(t)/\|\hat{T}'(t)\|$ at $t=1/2$?
"""

# ╔═╡ a5a030be-c190-11ec-0eed-87abd41d9022
let
	r(t) = [exp(t)*cos(t), exp(-t)*sin(t)]
	T(t) = r'(t)/norm(r'(t))
	N(t) = T'(t)/norm(T'(t))
	val = N(1/2)[1]
	numericq(val)
end

# ╔═╡ a5a030da-c190-11ec-053a-a1c6026523e5
md"""###### Question
"""

# ╔═╡ a5a0310c-c190-11ec-31aa-3d881b8055f7
md"""Let $\Phi(u,v) = \langle u,v,u^2+v^2\rangle$ parameterize a surface. Find the magnitude of $\| \partial{\Phi}/\partial{u} \times  \partial{\Phi}/\partial{v} \|$ at $u=1$ and $v=2$.
"""

# ╔═╡ a5a03774-c190-11ec-287b-453bc16caf5d
let
	Phi(u,v) = [u, v, u^2 + v^2]
	Jac = ForwardDiff.jacobian(uv -> Phi(uv...), [1,2])
	val = norm(Jac[:,1] × Jac[:,2])
	numericq(val)
end

# ╔═╡ a5a03794-c190-11ec-1acc-150b296d0c60
md"""###### Question
"""

# ╔═╡ a5a037b0-c190-11ec-20e7-5da89825b5ef
md"""For a plane $ax+by+cz=d$ find the unit normal.
"""

# ╔═╡ a5a04278-c190-11ec-25cf-cffc18081089
let
	choices = [
	raw" ``\langle a, b, c\rangle / \| \langle a, b, c\rangle\|``",
	raw" ``\langle a, b, c\rangle``",
	raw" ``\langle d-a, d-b, d-c\rangle / \| \langle d-a, d-b, d-c\rangle\|``",
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a042a2-c190-11ec-35e2-61c011e4cd1b
md"""Does it depend on $d$?
"""

# ╔═╡ a5a0529a-c190-11ec-2c54-538e1f6213c7
let
	choices = [
	L"No. Moving $d$ just shifts the plane up or down the $z$ axis, but won't change the normal vector",
	L"Yes. Of course. Different values for $d$ mean different values for $x$, $y$, and $z$ are needed.",
	L"Yes. The gradient of $F(x,y,z) = ax + by + cz$ will be normal to the level curve $F(x,y,z)=d$, and so this will depend on $d$."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a052ba-c190-11ec-084f-8ddebd333127
md"""###### Question
"""

# ╔═╡ a5a052e0-c190-11ec-2541-f3433a8b8056
md"""Let $\vec{r}(t) = \langle \cos(t), \sin(t), t\rangle$ and let $F(x,y,z) = \langle -y, x, z\rangle$
"""

# ╔═╡ a5a052f4-c190-11ec-325c-35a54700fa76
md"""Numerically compute $\int_0^{2\pi} F(\vec{r}(t)) \cdot \vec{r}'(t) dt$.
"""

# ╔═╡ a5a057ea-c190-11ec-0c1b-674edd76346f
let
	F(x,y,z) = [-y, x, z]
	r(t) = [cos(t), sin(t), t]
	val = quadgk(t -> F(r(t)...) ⋅ r'(t), 0, 2pi)[1]
	numericq(val)
end

# ╔═╡ a5a05808-c190-11ec-3d35-1bbdd585c178
md"""Compute the value symbolically:
"""

# ╔═╡ a5a05f10-c190-11ec-3896-a9cf2ccde0aa
let
	choices = [
	raw" ``2\pi + 2\pi^2``",
	raw" ``2\pi^2``",
	raw" ``4\pi``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a05f30-c190-11ec-23f6-53a55b2fb037
md"""###### Question
"""

# ╔═╡ a5a05f62-c190-11ec-1ff8-a130d9ea1351
md"""Let $F(x,y) = \langle 2x^3y^2, xy^4 + 1\rangle$. What is the work done in integrating $F$ along the parabola $y=x^2$ between $(-1,1)$ and $(1,1)$? Give a numeric answer:
"""

# ╔═╡ a5a0680c-c190-11ec-17cc-9f97ad14fb76
let
	F(x,y) = [2x^3*y^2, x*y^4 + 1]
	r(t) = [t, t^2]
	val = quadgk(t -> F(r(t)...) ⋅ r'(t), -1, 1)[1]
	numericq(val)
end

# ╔═╡ a5a0682a-c190-11ec-1c5e-bb2985068344
md"""###### Question
"""

# ╔═╡ a5a06866-c190-11ec-0437-6545cfd39167
md"""Let $F = \nabla{f}$ where $f:R^2 \rightarrow R$. The level curves of $f$ are curves in the $x-y$ plane where $f(x,y)=c$, for some constant $c$. Suppose $\vec{r}(t)$ describes a path on the level curve of $f$. What is the value of $\int_C F \cdot d\vec{r}$?
"""

# ╔═╡ a5a07234-c190-11ec-107e-0f6a872b9cec
let
	choices =[
	L"It will be $0$, as $\nabla{f}$ is orthogonal to the level curve and $\vec{r}'$ is tangent to the level curve",
	L"It will $f(b)-f(a)$ for any $b$ or $a$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a07252-c190-11ec-243e-891a7b4d098b
md"""###### Question
"""

# ╔═╡ a5a0727c-c190-11ec-0dbf-c1a51c1ae881
md"""Let $F(x,y) = (x^2+y^2)^{-k/2} \langle x, y \rangle$ be a radial field. The work integral around the unit circle simplifies:
"""

# ╔═╡ a5a072a2-c190-11ec-0c29-b58989caccf8
md"""```math
\int_C F\cdot \frac{dr}{dt} dt = \int_0^{2pi} \langle (1)^{-k/2} \cos(t), \sin(t) \rangle \cdot \langle-\sin(t), \cos(t)\rangle dt.
```
"""

# ╔═╡ a5a072c0-c190-11ec-2bc5-2dac31bf04e4
md"""For any $k$, this integral will be:
"""

# ╔═╡ a5a07496-c190-11ec-1b3a-3114d5978644
let
	numericq(0)
end

# ╔═╡ a5a074aa-c190-11ec-21d1-0fb8e3cb27b9
md"""###### Question
"""

# ╔═╡ a5a074d2-c190-11ec-35bb-57d4516d28ca
md"""Let $f(x,y) = \tan^{-1}(y/x)$. We will integrate $\nabla{f}$ over the unit circle. The integrand wil be:
"""

# ╔═╡ a5a07a5e-c190-11ec-1b62-81175263df58
let
	@syms t::real x::real y::real
	f(x,y) =  atan(y/x)
	r(t) = [cos(t), sin(t)]
	∇f = subs.(∇(f(x,y)), x .=> r(t)[1], y .=> r(t)[2]) .|> simplify
	drdt = diff.(r(t), t)
	∇f ⋅ drdt |> simplify
end

# ╔═╡ a5a07a88-c190-11ec-082d-b3fb00c20eae
md"""So $\int_C \nabla{f}\cdot d\vec{r} = \int_0^{2\pi} \nabla{f}\cdot d\vec{r}/dt dt = 2\pi$.
"""

# ╔═╡ a5a07a9a-c190-11ec-11c1-715a8fe7558d
md"""Why is this surprising?
"""

# ╔═╡ a5a0849a-c190-11ec-2e5f-43f495c51c69
let
	choices = [
	L"The field is a potential field, but the path integral around $0$ is not path dependent.",
	L"The value of $d/dt(f\circ\vec{r})=0$, so the integral should be $0$."
	]
	ans =1
	radioq(choices, ans)
end

# ╔═╡ a5a084c0-c190-11ec-2d12-4147650330f5
md"""The function $F = \nabla{f}$ is
"""

# ╔═╡ a5a08b84-c190-11ec-159b-790ae280bb5f
let
	choices = [
	"Not continuous everywhere",
	"Continuous everywhere"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a08ba2-c190-11ec-39c4-fd37c8879447
md"""###### Question
"""

# ╔═╡ a5a08bc0-c190-11ec-1eb7-fbd7ad6bfc61
md"""Let $F(x,y) = \langle F_x, F_y\rangle = \langle 2x^3y^2, xy^4 + 1\rangle$. Compute
"""

# ╔═╡ a5a08bde-c190-11ec-0e2e-4f94169dedba
md"""```math
\frac{\partial{F_y}}{\partial{x}}- \frac{\partial{F_x}}{\partial{y}}.
```
"""

# ╔═╡ a5a08bf2-c190-11ec-0890-db4388d8e5f8
md"""Is this $0$?
"""

# ╔═╡ a5a08fee-c190-11ec-110b-95a15eaa34ed
let
	@syms x y
	F(x,y) = [2x^3*y^2, x*y^4 + 1]
	val = iszero(diff(F(x,y)[2],x) - diff(F(x,y)[1],y))
	yesnoq(val)
end

# ╔═╡ a5a0900c-c190-11ec-06de-9f408760292a
md"""###### Question
"""

# ╔═╡ a5a0902a-c190-11ec-0967-911aa50f9346
md"""Let $F(x,y) = \langle F_x, F_y\rangle = \langle 2x^3, y^4 + 1\rangle$. Compute
"""

# ╔═╡ a5a09048-c190-11ec-20d5-2146a746d7d9
md"""```math
\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}.
```
"""

# ╔═╡ a5a0905c-c190-11ec-17c3-2768df27e1d8
md"""Is this $0$?
"""

# ╔═╡ a5a09462-c190-11ec-0958-7b39eedbd629
let
	@syms x y
	F(x,y) = [2x^3, y^4 + 1]
	val = iszero(diff(F(x,y)[2],x) - diff(F(x,y)[1],y))
	yesnoq(val)
end

# ╔═╡ a5a09480-c190-11ec-35c5-6337fcc3435c
md"""###### Question
"""

# ╔═╡ a5a09548-c190-11ec-29f1-5510a19da7fa
md"""It is not unusual to see a line integral, $\int F\cdot d\vec{r}$, where $F=\langle M, N \rangle$ expressed as $\int Mdx + Ndy$. This uses the notation for a differential form, so is familiar in some theoretical usages, but does not readily lend itself to computation. It does yield pleasing formulas, such as $\oint_C x dy$ to give the area of a two-dimensional region, $D$, in terms of a line integral around its perimeter. To see that this is so, let $\vec{r}(t) = \langle a\cos(t), b\sin(t)\rangle$, $0 \leq t \leq 2\pi$. This parameterizes an ellipse. Let $F(x,y) = \langle 0,x\rangle$. What does $\oint_C xdy$ become when translated into $\int_a^b (F\circ\vec{r})\cdot\vec{r}' dt$?
"""

# ╔═╡ a5a09f20-c190-11ec-0012-bd841bf99feb
let
	choices = [
	raw" ``\int_0^{2\pi} (a\cos(t)) \cdot (b\cos(t)) dt``",
	raw" ``\int_0^{2\pi} (-b\sin(t)) \cdot (b\cos(t)) dt``",
	raw" ``\int_0^{2\pi} (a\cos(t)) \cdot (a\cos(t)) dt``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ a5a09f48-c190-11ec-366a-897e28b46f12
md"""###### Question
"""

# ╔═╡ a5a09f66-c190-11ec-099d-15faa55a448c
md"""Let a surface be parameterized by $\Phi(u,v) = \langle u\cos(v), u\sin(v), u\rangle$.
"""

# ╔═╡ a5a09f86-c190-11ec-1d26-f713feb7b56d
md"""Compute $\vec{v}_1 = \partial{\Phi}/\partial{u}$
"""

# ╔═╡ a5a0a8bc-c190-11ec-0302-c386d0f640af
let
	choices = [
	raw" ``\langle \cos(v), \sin(v), 1\rangle``",
	raw" ``\langle -u\sin(v), u\cos(v), 0\rangle``",
	raw" ``u\langle -\cos(v), -\sin(v), 1\rangle``"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a5a0aa06-c190-11ec-3703-f197397f5ceb
md"""Compute $\vec{v}_2 = \partial{\Phi}/\partial{u}$
"""

# ╔═╡ a5a0b30c-c190-11ec-32fc-b9b3a89a95fc
let
	choices = [
	raw" ``\langle \cos(v), \sin(v), 1\rangle``",
	raw" ``\langle -u\sin(v), u\cos(v), 0\rangle``",
	raw" ``u\langle -\cos(v), -\sin(v), 1\rangle``"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a5a0b332-c190-11ec-3043-01f9941ed816
md"""Compute $\vec{v}_1 \times \vec{v}_2$
"""

# ╔═╡ a5a0bc46-c190-11ec-0d68-91d06b852233
let
	choices = [
	raw" ``\langle \cos(v), \sin(v), 1\rangle``",
	raw" ``\langle -u\sin(v), u\cos(v), 0\rangle``",
	raw" ``u\langle -\cos(v), -\sin(v), 1\rangle``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a5a0bc6c-c190-11ec-037a-9b18cc247740
md"""###### Question
"""

# ╔═╡ a5a0bc9e-c190-11ec-3b5a-2771c4f65382
md"""For the surface parameterized by $\Phi(u,v) = \langle uv, u^2v, uv^2\rangle$ for $(u,v)$ in $[0,1]\times[0,1]$, numerically find the surface area.
"""

# ╔═╡ a5a0c40a-c190-11ec-03a6-87efb27ff975
let
	Phi(u,v) = [u*v, u^2*v, u*v^2]
	Phi(v) = Phi(v...)
	function SurfaceElement(u,v)
	  pt = [u,v]
	  Jac = ForwardDiff.jacobian(Phi, pt)
	  v1, v2 = Jac[:,1], Jac[:,2]
	  cross(v1, v2)
	end
	a,err = hcubature(uv -> norm(SurfaceElement(uv...)), (0,0), (1,1))
	numericq(a)
end

# ╔═╡ a5a0c432-c190-11ec-3469-d7326c489f7b
md"""###### Question
"""

# ╔═╡ a5a0c484-c190-11ec-1d1f-67b6e146eddd
md"""For the surface parameterized by $\Phi(u,v) = \langle uv, u^2v, uv^2\rangle$ for $(u,v)$ in $[0,1]\times[0,1]$ and vector field $F(x,y,z) =\langle y^2, x, z\langle$, numerically find $\iint_S (F\cdot\hat{N}) dS$.
"""

# ╔═╡ a5a11c70-c190-11ec-21c7-c35331da2754
let
	Phi(u,v) = [u*v, u^2*v, u*v^2]
	Phi(v) = Phi(v...)
	function SurfaceElement(u,v)
	  pt = [u,v]
	  Jac = ForwardDiff.jacobian(Phi, pt)
	  v1, v2 = Jac[:,1], Jac[:,2]
	  cross(v1, v2)
	end
	F(x,y,z) = [y^2,x,z]
	F(v) = F(v...)
	integrand(uv) = dot(F(Phi(uv)...), SurfaceElement(uv...))
	a, err = hcubature(integrand, (0,0), (1,1))
	numericq(a)
end

# ╔═╡ a5a11cac-c190-11ec-35fb-2b45a5bc493b
md"""###### Question
"""

# ╔═╡ a5a11cf0-c190-11ec-3cab-e9e3c5969889
md"""Let $F=\langle 0,0,1\rangle$ and $S$ be the upper-half unit sphere, parameterized by $\Phi(\theta, \phi) = \langle \sin(\phi)\cos(\theta), \sin(\phi)\sin(\theta), \cos(\phi)\rangle$. Compute $\iint_S (F\cdot\hat{N}) dS$ numerically. Choose the normal direction so that the answer is postive.
"""

# ╔═╡ a5a1221a-c190-11ec-04ba-adb1f016a70d
let
	F(v) = [0,0,1]
	Phi(theta, phi) = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
	Phi(v) = Phi(v...)
	function SurfaceElement(u,v)
	  pt = [u,v]
	  Jac = ForwardDiff.jacobian(Phi, pt)
	  v1, v2 = Jac[:,1], Jac[:,2]
	  cross(v1, v2)
	end
	integrand(uv) = dot(F(Phi(uv)), SurfaceElement(uv...))
	a, err = hcubature(integrand, (0, 0), (2pi, pi/2))
	numericq(abs(a))
end

# ╔═╡ a5a12242-c190-11ec-29ac-e5dd3756b667
md"""###### Question
"""

# ╔═╡ a5a1227e-c190-11ec-1117-51ca9d058606
md"""Let $\phi(x,y,z) = xy$ and $S$ be the triangle $x+y+z=1$, $x,y,z \geq 0$. The surface may be described by $z=f(x,y) = 1 - (x + y)$, $0\leq y \leq 1-x, 0 \leq x \leq 1$ is useful in describing the surface. With this, the following integral will compute $\int_S \phi dS$:
"""

# ╔═╡ a5a1229c-c190-11ec-2a41-71d40e122146
md"""```math
\int_0^1 \int_0^{1-x} xy \sqrt{1 + \left(\frac{\partial{f}}{\partial{x}}\right)^2 + \left(\frac{\partial{f}}{\partial{y}}\right)^2} dy dx.
```
"""

# ╔═╡ a5a122b0-c190-11ec-2621-b7bc7c1fdb06
md"""Compute this.
"""

# ╔═╡ a5a12a6e-c190-11ec-3f45-217b7182e711
let
	#@syms x y real=true
	#phi = 1 - (x+y)
	#SE = sqrt(1 + diff(phi,x)^2, diff(phi,y)^2)
	#integrate(x*y*S_, (y, 0, 1-x), (x,0,1)) # \sqrt{2}/24
	choices = [
	raw" ``\sqrt{2}/24``",
	raw" ``2/\sqrt{24}``",
	raw" ``1/12``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a12a94-c190-11ec-06f7-71d4faf9f2f0
md"""###### Question
"""

# ╔═╡ a5a12abc-c190-11ec-2295-6127a2600890
md"""Let $\Phi(u,v) = \langle u^2, uv, v^2\rangle$, $(u,v)$ in $[0,1]\times[0,1]$ and $F(x,y,z) = \langle x,y^2,z^3\rangle$. Find  $\int_S (F\cdot\hat{N})dS$
"""

# ╔═╡ a5a133a4-c190-11ec-2ad8-599d365a24fc
let
	#Phi(u,v) = [u^2, u*v, v^2]
	#F(x,y,z) = [x,y^2,z^3]
	#Phi(v) = Phi(v...); F(v) = F(v...)
	#@syms u::real v::real
	#function SurfaceElement(u,v)
	#  pt = [u,v]
	#  Jac = Phi(u,v).jacobian([u,v])
	#  v1, v2 = Jac[:,1], Jac[:,2]
	#  cross(v1, v2)
	#end
	#integrate(F(Phi(u,v)) ⋅ SurfaceElement(u,v), (u,0,1), (v,0,1)) # 17/252
	choices = [
	raw" ``17/252``",
	raw" ``0``",
	raw" ``7/36``",
	raw" ``1/60``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a5a133d6-c190-11ec-2e24-f9c7c7aea166
HTML("""<div class="markdown"><blockquote>
<p><a href="../integral_vector_calculus/double_triple_integrals.html">◅ previous</a>  <a href="../integral_vector_calculus/div_grad_curl.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integral_vector_calculus/line_integrals.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ a5a133ea-c190-11ec-14b1-ef061186e413
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
HCubature = "19dc6840-f33b-545b-b366-655c7e3ffd49"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.17"
HCubature = "~1.5.0"
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
# ╟─a5a133b0-c190-11ec-2cff-fd41f801ef23
# ╟─a59e7b00-c190-11ec-1cd9-595a9f7c7907
# ╟─a59e7b3c-c190-11ec-09ea-8d5a3ae1a7d6
# ╠═a59e8154-c190-11ec-37ec-074774fdc539
# ╟─a59e84f6-c190-11ec-3df9-6b714d468d61
# ╟─a59e8528-c190-11ec-3127-ffc32a663f1d
# ╟─a59e8596-c190-11ec-1983-210ff4ec5d9a
# ╟─a59e862c-c190-11ec-1084-5beb90f67867
# ╟─a59e8652-c190-11ec-087e-33af565b168c
# ╟─a59e8684-c190-11ec-0b4a-c55fab6c40e7
# ╟─a59e86e0-c190-11ec-305c-ad02a31a2b26
# ╟─a59e8712-c190-11ec-3d54-1b2555b3de49
# ╟─a59e8730-c190-11ec-2bc9-b1d388dfba38
# ╟─a59e876c-c190-11ec-0739-0d77785addae
# ╟─a59e8794-c190-11ec-3b90-03e8d8900f78
# ╟─a59e87a8-c190-11ec-3d65-49e011cdb796
# ╟─a59e87ec-c190-11ec-27a8-1d1fa81c03df
# ╟─a59e8802-c190-11ec-00f6-41fd0033d64e
# ╟─a59e8816-c190-11ec-20da-5b1e3b1c7a65
# ╟─a59e8834-c190-11ec-196f-0d4a88c512ef
# ╟─a59e8852-c190-11ec-1a92-e502216e843c
# ╟─a59e8866-c190-11ec-3d0d-1bfed1f39591
# ╟─a59e8884-c190-11ec-28fb-1725c5ae7a4b
# ╟─a59e88b6-c190-11ec-0a9d-f150281196e9
# ╟─a59e88e8-c190-11ec-158c-55fc220de783
# ╟─a59e891a-c190-11ec-2ebc-2d63fdd89910
# ╟─a59e8938-c190-11ec-32d7-cb92d5fc4858
# ╟─a59e8954-c190-11ec-15bc-69ca76de203f
# ╠═a59e8f8c-c190-11ec-0e32-e123b2c74f3c
# ╟─a59e8fbe-c190-11ec-0ef4-a12503e8b714
# ╠═a59e9932-c190-11ec-2f06-31f74bbcfa18
# ╟─a59e995a-c190-11ec-02cc-59dd6a48fbee
# ╠═a59e9afe-c190-11ec-2bf3-4f47cf08618a
# ╟─a59e9b30-c190-11ec-3b7b-edbc28704300
# ╟─a59e9b62-c190-11ec-3457-9113ea7f93cb
# ╟─a59e9b76-c190-11ec-3ba4-7b956c92e0e9
# ╠═a59ea0e4-c190-11ec-1dd3-c554ea79555a
# ╟─a59ea10c-c190-11ec-070c-159180dc39e8
# ╟─a59ea166-c190-11ec-32ad-6d1031c904e0
# ╟─a59ea18e-c190-11ec-1ddc-fdc61d7de1d1
# ╟─a59ea1ae-c190-11ec-0db2-8dc485fa4b68
# ╟─a59ea1ca-c190-11ec-2aa7-69105f63d359
# ╟─a59ea1f2-c190-11ec-384f-4f4b22421585
# ╟─a59ea20e-c190-11ec-1901-132812560dea
# ╟─a59ea22e-c190-11ec-3fc8-411e975ff2f4
# ╟─a59ea242-c190-11ec-121d-37da983a6392
# ╟─a59ea292-c190-11ec-3a88-b57953fb2e9c
# ╟─a59ea3d2-c190-11ec-0d78-5b7b00a83290
# ╟─a59ea3f0-c190-11ec-01e0-75bddab47e22
# ╟─a59ea422-c190-11ec-39d5-690819c281f0
# ╟─a59ea490-c190-11ec-1ddf-bb6b0962dbca
# ╟─a59ea4a4-c190-11ec-09e4-19b09b3b86ea
# ╟─a59ea4c2-c190-11ec-3e45-d93fd063896c
# ╟─a59ea4ea-c190-11ec-0d30-4b7bf6e58fe4
# ╠═a59eae5e-c190-11ec-25ab-294e8cbad712
# ╟─a59eae84-c190-11ec-33aa-03eff5ab8a03
# ╟─a59eaec2-c190-11ec-317d-9d1273eea3d4
# ╟─a59eaeea-c190-11ec-1ead-75d753df14e8
# ╟─a59eaefe-c190-11ec-1726-55fbc38e6b52
# ╠═a59eb4d0-c190-11ec-2392-d59bc378949b
# ╟─a59eb4f6-c190-11ec-297f-33482cec8051
# ╟─a59eb50c-c190-11ec-33f3-3d8b6bdea559
# ╟─a59eb534-c190-11ec-188c-e9bdf01ddd5c
# ╟─a59eb55a-c190-11ec-334d-497ad84a5746
# ╠═a59eb9e4-c190-11ec-00f0-ad40a3b332f3
# ╟─a59eba0c-c190-11ec-2ca4-a188a9406d00
# ╠═a59ebfac-c190-11ec-1f0b-5f5265e2ee22
# ╟─a59ebfde-c190-11ec-1708-d3d475c62212
# ╟─a59ee040-c190-11ec-36a1-a716234491cc
# ╟─a59ee09c-c190-11ec-37da-1b401df1a5ea
# ╟─a59ee0ca-c190-11ec-2850-9daa2895688e
# ╟─a59ee0ea-c190-11ec-3087-510e039608a4
# ╟─a59ee0fc-c190-11ec-0d45-cd5c48908a5f
# ╟─a59ee11c-c190-11ec-17be-556d9fe0b961
# ╟─a59ee12e-c190-11ec-1f65-c398010e29c1
# ╟─a59ee14e-c190-11ec-33f2-d11a631d4829
# ╟─a59ee23e-c190-11ec-2b8c-b11290ed83c3
# ╟─a59ee270-c190-11ec-121e-eb4df120121e
# ╟─a59ee28e-c190-11ec-3ac9-6bbef065b6fb
# ╟─a59ee2ac-c190-11ec-19d8-5dd4f0b1b029
# ╟─a59ee2c0-c190-11ec-1c3b-d545afc542d7
# ╟─a59ee2e8-c190-11ec-0eae-8b3711cc80ce
# ╟─a59ee308-c190-11ec-2643-31ba2a5612df
# ╠═a59ee838-c190-11ec-32f4-1dced35c1159
# ╟─a59ee860-c190-11ec-2f67-b38086863075
# ╟─a59ee874-c190-11ec-1f59-3345490d5d75
# ╟─a59eea22-c190-11ec-20d1-4d4b9cf823dc
# ╟─a59eea36-c190-11ec-106a-5b18db15a8ec
# ╟─a59eea68-c190-11ec-0313-216d5f454721
# ╟─a59eeb1c-c190-11ec-0014-f15ff94f46c2
# ╟─a59eeb3a-c190-11ec-037c-a58a47a7ccc6
# ╟─a59eeb4e-c190-11ec-0215-fdf5b292168a
# ╟─a59eeb6c-c190-11ec-1e24-dd21282bb1ba
# ╟─a59eeb8a-c190-11ec-2ede-714f198af165
# ╟─a59f08ca-c190-11ec-0de0-8721cdc7bb81
# ╟─a59f0b42-c190-11ec-2930-9507b95a97f6
# ╟─a59f0bec-c190-11ec-0e56-29d42cd7be86
# ╟─a59f0c28-c190-11ec-2da5-8b25dc447f2b
# ╟─a59f0c5a-c190-11ec-19cf-ab6e9ab17322
# ╟─a59f0caa-c190-11ec-2340-bb0dc8159f04
# ╟─a59f0d2c-c190-11ec-1525-19e274e0cc35
# ╟─a59f0d4a-c190-11ec-2043-f5a611ad84f7
# ╠═a59f16dc-c190-11ec-3cfe-e7ef2f3f962e
# ╟─a59f172c-c190-11ec-0f35-075308f26018
# ╠═a59f1fe2-c190-11ec-06d2-eb4411541a29
# ╟─a59f2028-c190-11ec-0e3b-8184f156b7c5
# ╟─a59f205a-c190-11ec-241d-a57a6b5b2549
# ╟─a59f20c8-c190-11ec-2adb-6b0d0c951753
# ╟─a59f210e-c190-11ec-1fd2-0fd77c1157d4
# ╟─a59f214a-c190-11ec-0fa0-7bea4f9d427a
# ╟─a59f2172-c190-11ec-1253-ff9c1a418cea
# ╟─a59f21a4-c190-11ec-1fc6-870f8677db17
# ╟─a59f21c2-c190-11ec-3fe0-e538cb0d69cc
# ╟─a59f21f4-c190-11ec-1e06-31a16936ba76
# ╟─a59f29f4-c190-11ec-105c-d78d74adfe8f
# ╟─a59f2a5a-c190-11ec-2867-61e264df1471
# ╟─a59f3824-c190-11ec-29f8-cdf0634abd29
# ╟─a59f386a-c190-11ec-3cab-43a3c9b64399
# ╟─a59f38c4-c190-11ec-33bc-97c10385f71f
# ╟─a59f38e2-c190-11ec-3d79-0b81ec8cf68c
# ╠═a59f3b26-c190-11ec-16a2-8d7751ff81fc
# ╟─a59f3b62-c190-11ec-30f6-61fb3c3cad1b
# ╠═a59f3e64-c190-11ec-3472-3fd4ad829a64
# ╟─a59f3e8c-c190-11ec-285b-29b427d74538
# ╟─a59f3eaa-c190-11ec-3f2d-fbcc30260b06
# ╟─a59f3ee8-c190-11ec-18a6-69bb08301e53
# ╟─a59f3efa-c190-11ec-316e-e70a6168b3b5
# ╠═a59f44f4-c190-11ec-1c5b-39dad2d4b5c6
# ╟─a59f4512-c190-11ec-0543-a13f3113c71f
# ╟─a59f453a-c190-11ec-2050-7b05e4c9d7f3
# ╠═a59f4936-c190-11ec-28fd-971760647424
# ╟─a59f4952-c190-11ec-0780-61b6aa34a225
# ╟─a59f4984-c190-11ec-399f-fda8a1d8fa16
# ╠═a59f4d26-c190-11ec-1e04-75c30f71d8dd
# ╟─a59f4d46-c190-11ec-3df2-c1614cb2d58e
# ╟─a59f4d6e-c190-11ec-0452-0d9acef85b32
# ╠═a59f5354-c190-11ec-1370-0b49ccd27d63
# ╟─a59f53ae-c190-11ec-2dc9-7959e9fa5c91
# ╠═a59f5782-c190-11ec-3538-4ff07224e13c
# ╟─a59f57be-c190-11ec-0bd8-bd4d48627bd7
# ╠═a59f5b60-c190-11ec-3086-c342b8265f75
# ╟─a59f5b7e-c190-11ec-0005-2596fd67a21b
# ╟─a59f5ba6-c190-11ec-3e04-c755fc67a61c
# ╟─a59f6148-c190-11ec-247a-bb178ece0137
# ╟─a59f6196-c190-11ec-3ea3-11db6bc50855
# ╟─a59f61be-c190-11ec-3239-2df587af01be
# ╟─a59f6934-c190-11ec-311b-45091936f659
# ╟─a59f698e-c190-11ec-2c06-31f1a6638fa0
# ╟─a59f69a2-c190-11ec-2c9d-7114634f4f59
# ╟─a59f6d4e-c190-11ec-164c-1d464c7c59b5
# ╟─a59f771c-c190-11ec-173f-ffd3acd260f9
# ╟─a59f776c-c190-11ec-3c31-61a9c08c4b48
# ╟─a59f779e-c190-11ec-21e8-c555b25a4164
# ╟─a59f77d0-c190-11ec-19b4-73b1af2ab83c
# ╟─a59f77ee-c190-11ec-0c1f-e143bf6f5adf
# ╟─a59f7820-c190-11ec-287f-4749f72b3755
# ╟─a59f7852-c190-11ec-1ae8-6330b1112ed2
# ╟─a59f7884-c190-11ec-3699-91e4b752899b
# ╟─a59f789a-c190-11ec-04a2-c9a0e54055ef
# ╟─a59f78b6-c190-11ec-3bc8-b3e53c82a9db
# ╟─a59f78d4-c190-11ec-0e24-372de774018c
# ╟─a59f78f2-c190-11ec-1f8b-a9a54ef5da99
# ╠═a59f9896-c190-11ec-27e6-fb425caebc8b
# ╟─a59f98dc-c190-11ec-3f0d-9fe6070b4797
# ╠═a59fa1b0-c190-11ec-1a11-adae8e7748a4
# ╟─a59fa1d0-c190-11ec-2bfa-49249fe5a77a
# ╟─a59fa20a-c190-11ec-00da-0f502703851e
# ╠═a59fa91c-c190-11ec-37a3-1b68d068da49
# ╟─a59fa96a-c190-11ec-0a3c-23fabca23562
# ╠═a59fae6c-c190-11ec-011a-91f5072cdef6
# ╟─a59fae9e-c190-11ec-2684-f7c82e632af8
# ╟─a59faebc-c190-11ec-00e2-ab7688d3a844
# ╟─a59faee4-c190-11ec-2584-1d7a0cd24457
# ╠═a59fb2de-c190-11ec-322b-29799ef15275
# ╟─a59fb308-c190-11ec-060c-a571b31c76d4
# ╟─a59fb34e-c190-11ec-1d14-117f02e8d326
# ╟─a59fb382-c190-11ec-3cb7-c717270ff20f
# ╟─a59fb3b4-c190-11ec-0fdc-5996d865d26a
# ╠═a59fb9a2-c190-11ec-2d14-a58a58793b7b
# ╟─a59fb9ca-c190-11ec-2535-95a4d4f041cf
# ╟─a59fb9e6-c190-11ec-0420-0fb692d51ad1
# ╟─a59fba1a-c190-11ec-156d-8f6b68a97e2a
# ╟─a59fba38-c190-11ec-3020-1b24a59f05df
# ╟─a59fba4c-c190-11ec-119d-475957f0e9c5
# ╟─a59fba60-c190-11ec-007a-3f65f50c6c86
# ╟─a59fba74-c190-11ec-2e8e-cb3316bab9e8
# ╠═a59fbf42-c190-11ec-1aaf-897e5bfb69f6
# ╟─a59fbf6a-c190-11ec-2e22-6d76358b4a22
# ╟─a59fbfba-c190-11ec-26d5-d3a269b36678
# ╟─a59fbfce-c190-11ec-1807-5bca09faeb51
# ╟─a59fc014-c190-11ec-198e-4912b7002ea3
# ╟─a59fc03c-c190-11ec-29c6-85de0b036375
# ╟─a59fc064-c190-11ec-2cb6-bd0d1c7992b5
# ╟─a59fc082-c190-11ec-3a5f-7107c9959b7d
# ╟─a59fc096-c190-11ec-0779-4929c7aa4da9
# ╟─a59fc0dc-c190-11ec-179f-67dd808e8dfb
# ╟─a59fc0f0-c190-11ec-1ed1-fd2604208770
# ╟─a59fc122-c190-11ec-1b42-a3f205bbea1e
# ╟─a59fc140-c190-11ec-1042-5db1abf4b758
# ╠═a59fc604-c190-11ec-018b-d18988112db0
# ╟─a59fc622-c190-11ec-0d83-2bcc2d5b297c
# ╟─a59fc654-c190-11ec-036c-0feba535e318
# ╠═a59fcb38-c190-11ec-3fcf-6b46253ff374
# ╟─a59fcb72-c190-11ec-2dfa-b3a658093988
# ╟─a59fcb90-c190-11ec-134b-7539c333fadd
# ╠═a59fd0d4-c190-11ec-3700-5b7e91d62780
# ╠═a59fd98c-c190-11ec-0101-e1baf1db35a8
# ╟─a59fd9be-c190-11ec-1cd7-61003d026436
# ╠═a59ff79e-c190-11ec-1be0-27704de0f98a
# ╟─a59ff7e6-c190-11ec-0f9b-e108b0419428
# ╠═a5a0001a-c190-11ec-3364-050686fa1040
# ╟─a5a00056-c190-11ec-245f-5b308d508816
# ╟─a5a00074-c190-11ec-2135-676ebaaf2b66
# ╠═a5a004a2-c190-11ec-3c31-d9a992d36bfe
# ╟─a5a004c0-c190-11ec-11b1-4933e257ec23
# ╠═a5a00e20-c190-11ec-02b2-6f3f82aa38c6
# ╟─a5a00e3e-c190-11ec-026e-b98ff5bffd4c
# ╠═a5a0101e-c190-11ec-308c-d9c70c09df2c
# ╟─a5a0103c-c190-11ec-397a-07f804ebdc68
# ╟─a5a0108c-c190-11ec-3df4-039be7a47aa9
# ╟─a5a010b4-c190-11ec-3f93-ffe0c0bbf883
# ╟─a5a010d2-c190-11ec-1bcc-af221e179d77
# ╟─a5a010f0-c190-11ec-0a9e-49c2193acfca
# ╟─a5a0110e-c190-11ec-3457-093e2731a962
# ╟─a5a01122-c190-11ec-34f4-2370fff49407
# ╠═a5a0180c-c190-11ec-3c04-317bda85ede4
# ╟─a5a01864-c190-11ec-0c04-870c602a6978
# ╟─a5a01896-c190-11ec-3677-155c4b8615a9
# ╠═a5a02042-c190-11ec-31da-e95d6a30db3e
# ╟─a5a0207c-c190-11ec-06d4-9dadd3e2ab01
# ╟─a5a020c2-c190-11ec-3d21-4d821b0a46d6
# ╟─a5a02112-c190-11ec-2985-b76a24b19c17
# ╟─a5a02130-c190-11ec-3872-8b017500e529
# ╟─a5a0214e-c190-11ec-2897-93d6c4d7dd19
# ╟─a5a02178-c190-11ec-145e-15d2d1f5674f
# ╟─a5a02194-c190-11ec-2708-d1079de4cc9e
# ╟─a5a021aa-c190-11ec-31ac-134cf0ca5dbf
# ╟─a5a0293c-c190-11ec-3612-2fd529e75cef
# ╟─a5a0296e-c190-11ec-0e23-37254a3648b5
# ╟─a5a030be-c190-11ec-0eed-87abd41d9022
# ╟─a5a030da-c190-11ec-053a-a1c6026523e5
# ╟─a5a0310c-c190-11ec-31aa-3d881b8055f7
# ╟─a5a03774-c190-11ec-287b-453bc16caf5d
# ╟─a5a03794-c190-11ec-1acc-150b296d0c60
# ╟─a5a037b0-c190-11ec-20e7-5da89825b5ef
# ╟─a5a04278-c190-11ec-25cf-cffc18081089
# ╟─a5a042a2-c190-11ec-35e2-61c011e4cd1b
# ╟─a5a0529a-c190-11ec-2c54-538e1f6213c7
# ╟─a5a052ba-c190-11ec-084f-8ddebd333127
# ╟─a5a052e0-c190-11ec-2541-f3433a8b8056
# ╟─a5a052f4-c190-11ec-325c-35a54700fa76
# ╟─a5a057ea-c190-11ec-0c1b-674edd76346f
# ╟─a5a05808-c190-11ec-3d35-1bbdd585c178
# ╟─a5a05f10-c190-11ec-3896-a9cf2ccde0aa
# ╟─a5a05f30-c190-11ec-23f6-53a55b2fb037
# ╟─a5a05f62-c190-11ec-1ff8-a130d9ea1351
# ╟─a5a0680c-c190-11ec-17cc-9f97ad14fb76
# ╟─a5a0682a-c190-11ec-1c5e-bb2985068344
# ╟─a5a06866-c190-11ec-0437-6545cfd39167
# ╟─a5a07234-c190-11ec-107e-0f6a872b9cec
# ╟─a5a07252-c190-11ec-243e-891a7b4d098b
# ╟─a5a0727c-c190-11ec-0dbf-c1a51c1ae881
# ╟─a5a072a2-c190-11ec-0c29-b58989caccf8
# ╟─a5a072c0-c190-11ec-2bc5-2dac31bf04e4
# ╟─a5a07496-c190-11ec-1b3a-3114d5978644
# ╟─a5a074aa-c190-11ec-21d1-0fb8e3cb27b9
# ╟─a5a074d2-c190-11ec-35bb-57d4516d28ca
# ╠═a5a07a5e-c190-11ec-1b62-81175263df58
# ╟─a5a07a88-c190-11ec-082d-b3fb00c20eae
# ╟─a5a07a9a-c190-11ec-11c1-715a8fe7558d
# ╟─a5a0849a-c190-11ec-2e5f-43f495c51c69
# ╟─a5a084c0-c190-11ec-2d12-4147650330f5
# ╟─a5a08b84-c190-11ec-159b-790ae280bb5f
# ╟─a5a08ba2-c190-11ec-39c4-fd37c8879447
# ╟─a5a08bc0-c190-11ec-1eb7-fbd7ad6bfc61
# ╟─a5a08bde-c190-11ec-0e2e-4f94169dedba
# ╟─a5a08bf2-c190-11ec-0890-db4388d8e5f8
# ╟─a5a08fee-c190-11ec-110b-95a15eaa34ed
# ╟─a5a0900c-c190-11ec-06de-9f408760292a
# ╟─a5a0902a-c190-11ec-0967-911aa50f9346
# ╟─a5a09048-c190-11ec-20d5-2146a746d7d9
# ╟─a5a0905c-c190-11ec-17c3-2768df27e1d8
# ╟─a5a09462-c190-11ec-0958-7b39eedbd629
# ╟─a5a09480-c190-11ec-35c5-6337fcc3435c
# ╟─a5a09548-c190-11ec-29f1-5510a19da7fa
# ╟─a5a09f20-c190-11ec-0012-bd841bf99feb
# ╟─a5a09f48-c190-11ec-366a-897e28b46f12
# ╟─a5a09f66-c190-11ec-099d-15faa55a448c
# ╟─a5a09f86-c190-11ec-1d26-f713feb7b56d
# ╟─a5a0a8bc-c190-11ec-0302-c386d0f640af
# ╟─a5a0aa06-c190-11ec-3703-f197397f5ceb
# ╟─a5a0b30c-c190-11ec-32fc-b9b3a89a95fc
# ╟─a5a0b332-c190-11ec-3043-01f9941ed816
# ╟─a5a0bc46-c190-11ec-0d68-91d06b852233
# ╟─a5a0bc6c-c190-11ec-037a-9b18cc247740
# ╟─a5a0bc9e-c190-11ec-3b5a-2771c4f65382
# ╟─a5a0c40a-c190-11ec-03a6-87efb27ff975
# ╟─a5a0c432-c190-11ec-3469-d7326c489f7b
# ╟─a5a0c484-c190-11ec-1d1f-67b6e146eddd
# ╟─a5a11c70-c190-11ec-21c7-c35331da2754
# ╟─a5a11cac-c190-11ec-35fb-2b45a5bc493b
# ╟─a5a11cf0-c190-11ec-3cab-e9e3c5969889
# ╟─a5a1221a-c190-11ec-04ba-adb1f016a70d
# ╟─a5a12242-c190-11ec-29ac-e5dd3756b667
# ╟─a5a1227e-c190-11ec-1117-51ca9d058606
# ╟─a5a1229c-c190-11ec-2a41-71d40e122146
# ╟─a5a122b0-c190-11ec-2621-b7bc7c1fdb06
# ╟─a5a12a6e-c190-11ec-3f45-217b7182e711
# ╟─a5a12a94-c190-11ec-06f7-71d4faf9f2f0
# ╟─a5a12abc-c190-11ec-2295-6127a2600890
# ╟─a5a133a4-c190-11ec-2ad8-599d365a24fc
# ╟─a5a133d6-c190-11ec-2e24-f9c7c7aea166
# ╟─a5a133e2-c190-11ec-35a9-899ca194b9fa
# ╟─a5a133ea-c190-11ec-14b1-ef061186e413
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
