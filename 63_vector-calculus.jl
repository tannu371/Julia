### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ f434e448-c190-11ec-2d49-3fb2439a45cc
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using Plots
	nothing
end

# ╔═╡ f4351864-c190-11ec-13ac-fd379263186e
using PlutoUI

# ╔═╡ f435183c-c190-11ec-3f26-cf5ed0305ed6
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ f434de58-c190-11ec-0d6c-15e6c5c3f801
md"""# Quick Review of Vector Calculus
"""

# ╔═╡ f434e4b6-c190-11ec-1a3e-cd66a72b76d4
md"""This section considers functions from $R^n$ into $R^m$ where one or both of $n$ or $m$ is greater than $1$:
"""

# ╔═╡ f434e63e-c190-11ec-0487-933ffb535b0f
md"""  * functions $f:R \rightarrow R^m$ are called univariate functions.
  * functions $f:R^n \rightarrow R$ are called scalar-valued functions.
  * function $f:R \rightarrow R$ are univariate, scalar-valued functions.
  * functions $\vec{r}:R\rightarrow R^m$ are parameterized curves. The trace of a parameterized curve is a path.
  * functions $F:R^n \rightarrow R^m$, may be called vector fields in applications. They are also used to describe transformations.
"""

# ╔═╡ f434e678-c190-11ec-2f54-d1b7afb2abb0
md"""When $m>1$ a function is called *vector valued*.
"""

# ╔═╡ f434e696-c190-11ec-1c0a-ab18d7a76283
md"""When $n>1$ the argument may be given in terms of components, e.g. $f(x,y,z)$; with a point as an argument, $F(p)$; or with a vector as an argument, $F(\vec{a})$. The identification of a point with a vector is done frequently.
"""

# ╔═╡ f434e6b4-c190-11ec-3ac0-e1010babd3fb
md"""## Limits
"""

# ╔═╡ f434e6c8-c190-11ec-33c1-9b7776582040
md"""Limits when $m > 1$ depend on the limits of each component existing.
"""

# ╔═╡ f434e6f0-c190-11ec-087f-a7c593c10c8e
md"""Limits when $n > 1$ are more complicated. One characterization is a limit at a point $c$ exists if and only if for *every* continuous path going to $c$ the limit along the path for every component exists in the univariate sense.
"""

# ╔═╡ f434e6fa-c190-11ec-345c-7197c8351da5
md"""## Derivatives
"""

# ╔═╡ f434e718-c190-11ec-0092-e5a66b5b9752
md"""The derivative of a univariate function, $f$, at a point $c$ is defined by a limit:
"""

# ╔═╡ f434e74a-c190-11ec-0c15-3d899961f9d2
md"""```math
f'(c) = \lim_{h\rightarrow 0} \frac{f(c+h)-f(c)}{h},
```
"""

# ╔═╡ f4350720-c190-11ec-3b2b-038b0c1f1da7
md"""and as a function by considering the mapping $c$ into $f'(c)$. A characterization is it is the value for which
"""

# ╔═╡ f43507c8-c190-11ec-0a19-0701809076c3
md"""```math
|f(c+h) - f(h) - f'(c)h| = \mathcal{o}(|h|),
```
"""

# ╔═╡ f435089e-c190-11ec-244c-f3f9c404bfc0
md"""That is,  after dividing the left-hand side by $|h|$ the expression goes to $0$ as $|h|\rightarrow 0$. This characterization will generalize with the norm replacing the absolute value, as needed.
"""

# ╔═╡ f43508e2-c190-11ec-39e0-1b508e00576f
md"""### Parameterized curves
"""

# ╔═╡ f4350914-c190-11ec-048b-a3b1e205d452
md"""The derivative of a function $\vec{r}: R \rightarrow R^m$, $\vec{r}'(t)$, is found by taking the derivative of each component. (The function consisting of just one component is univariate.)
"""

# ╔═╡ f4350928-c190-11ec-1678-d3ae7e5bad4f
md"""The derivative satisfies
"""

# ╔═╡ f4350930-c190-11ec-29e2-7975a1ba6bc6
md"""```math
\| \vec{r}(t+h) - \vec{r}(t) - \vec{r}'(t) h \| = \mathcal{o}(|h|).
```
"""

# ╔═╡ f4350964-c190-11ec-0b7d-2f985e1b39f2
md"""The derivative is *tangent* to the curve and indicates the direction of travel.
"""

# ╔═╡ f435098c-c190-11ec-3602-174c89db65b4
md"""The **tangent** vector is the unit vector in the direction of $\vec{r}'(t)$:
"""

# ╔═╡ f43509a2-c190-11ec-3be8-cf7d3b366d8b
md"""```math
\hat{T} = \frac{\vec{r}'(t)}{\|\vec{r}(t)\|}.
```
"""

# ╔═╡ f43509c8-c190-11ec-0f50-13b2376a61d2
md"""The path is parameterized by *arc* length if $\|\vec{r}'(t)\| = 1$ for all $t$. In this case an "$s$" is used for the parameter, as a notational hint: $\hat{T} = d\vec{r}/ds$.
"""

# ╔═╡ f43509e6-c190-11ec-00dc-33016e62b17c
md"""The **normal** vector is the unit vector in the direction of the derivative of the tangent vector:
"""

# ╔═╡ f43509fa-c190-11ec-2244-21d0b4730bf4
md"""```math
\hat{N} = \frac{\hat{T}'(t)}{\|\hat{T}'(t)\|}.
```
"""

# ╔═╡ f4350a22-c190-11ec-2584-610fac55212a
md"""In dimension $m=2$, if $\hat{T} = \langle a, b\rangle$ then $\hat{N} = \langle -b, a\rangle$ or $\langle b, -a\rangle$ and $\hat{N}'(t)$ is parallel to $\hat{T}$.
"""

# ╔═╡ f4350a54-c190-11ec-310f-bf14ef8a03b8
md"""In dimension $m=3$, the **binormal** vector, $\hat{B}$, is the unit vector $\hat{T}\times\hat{N}$.
"""

# ╔═╡ f4350ab8-c190-11ec-03fa-c3ca089f570b
md"""The [Frenet-Serret]() formulas define the **curvature**, $\kappa$,  and the **torsion**, $\tau$, by
"""

# ╔═╡ f4350acc-c190-11ec-084b-05fcf5f3bb3f
md"""```math
\begin{align}
\frac{d\hat{T}}{ds} &=  & \kappa \hat{N} &\\
\frac{d\hat{N}}{ds} &= -\kappa\hat{T} & & + \tau\hat{B}\\
\frac{d\hat{B}}{ds} &= & -\tau\hat{N}&
\end{align}
```
"""

# ╔═╡ f4350aea-c190-11ec-1142-6f2e372e855b
md"""These formulas apply in dimension $m=2$ with $\hat{B}=\vec{0}$.
"""

# ╔═╡ f4350b0a-c190-11ec-2db5-17c5d9b2e353
md"""The curvature, $\kappa$, can be visualized by imagining a circle of radius $r=1/\kappa$ best approximating the path at a point. (A straight line would have a circle of infinite radius and curvature $0$.)
"""

# ╔═╡ f4350b12-c190-11ec-1d7f-9150bf7f65bc
md"""The chain rule says $(\vec{r}(g(t))' = \vec{r}'(g(t)) g'(t)$.
"""

# ╔═╡ f4350b26-c190-11ec-1770-87ed01ccbf56
md"""### Scalar functions
"""

# ╔═╡ f4350b4e-c190-11ec-3a17-df174788bda3
md"""A scalar function, $f:R^n\rightarrow R$, $n > 1$ has a **partial derivative** defined. For $n=2$, these are:
"""

# ╔═╡ f4350b62-c190-11ec-07da-6b4bb159a4fc
md"""```math
\begin{align}
\frac{\partial{f}}{\partial{x}}(x,y) &=
\lim_{h\rightarrow 0} \frac{f(x+h,y)-f(x,y)}{h}\\
\frac{\partial{f}}{\partial{y}}(x,y) &=
\lim_{h\rightarrow 0} \frac{f(x,y+h)-f(x,y)}{h}.
\end{align}
```
"""

# ╔═╡ f4350b80-c190-11ec-2b88-4f5145c8a46b
md"""The generalization to $n>2$ is clear - the partial derivative in $x_i$ is the derivative of $f$ when the *other* $x_j$ are held constant.
"""

# ╔═╡ f4350ba8-c190-11ec-17ac-01e3d270211e
md"""This may be viewed as the derivative of the univariate function $(f\circ\vec{r})(t)$ where $\vec{r}(t) = p + t \hat{e}_i$, $\hat{e}_i$ being the unit vector of all $0$s except a $1$ in the $i$th component.
"""

# ╔═╡ f4350bce-c190-11ec-018c-97c1a0e6555d
md"""The **gradient** of $f$, when the limits exist, is the vector-valued function for $R^n$ to $R^n$:
"""

# ╔═╡ f4350be4-c190-11ec-25d7-1bc147b16911
md"""```math
\nabla{f} = \langle
\frac{\partial{f}}{\partial{x_1}},
\frac{\partial{f}}{\partial{x_2}},
\dots
\frac{\partial{f}}{\partial{x_n}}
\rangle.
```
"""

# ╔═╡ f4350bee-c190-11ec-28b9-451e3a9930a8
md"""The gradient satisfies:
"""

# ╔═╡ f4350c2a-c190-11ec-1911-a3c17a838d0a
md"""```math
\|f(\vec{x}+\Delta{\vec{x}}) - f(\vec{x}) - \nabla{f}\cdot\Delta{\vec{x}}\| = \mathcal{o}(\|\Delta{\vec{x}\|}).
```
"""

# ╔═╡ f4350c3e-c190-11ec-0556-dbeb2851a957
md"""The gradient is viewed as a column vector. If the dot product above is viewed as matrix multiplication, then it would be written $\nabla{f}' \Delta{\vec{x}}$.
"""

# ╔═╡ f4350c5c-c190-11ec-08be-e1fbdaaac3a7
md"""**Linearization** is the *approximation*
"""

# ╔═╡ f4350c72-c190-11ec-1ad1-0d5512e8042b
md"""```math
f(\vec{x}+\Delta{\vec{x}}) \approx f(\vec{x}) + \nabla{f}\cdot\Delta{\vec{x}}.
```
"""

# ╔═╡ f4350c98-c190-11ec-120c-25e0e03a256a
md"""The **directional derivative** of $f$ in the direction $\vec{v}$ is $\vec{v}\cdot\nabla{f}$, which can be seen as the derivative of the univariate function $(f\circ\vec{r})(t)$ where $\vec{r}(t) = p + t \vec{v}$.
"""

# ╔═╡ f4350cb6-c190-11ec-2f1c-7b00c361e423
md"""For the function $z=f(x,y)$ the gradient points in the direction of steepest ascent. Ascent is seen in the $3$d surface, the gradient is $2$ dimensional.
"""

# ╔═╡ f4350cf2-c190-11ec-005c-27ac47fdd3a9
md"""For a function $f(\vec{x})$, a **level curve** is the set of values for which $f(\vec{x})=c$, $c$ being some constant. Plotted, this may give a curve or surface (in $n=2$ or $n=3$). The gradient at a point $\vec{x}$ with $f(\vec{x})=c$ will be *orthogonal* to the level curve $f=c$.
"""

# ╔═╡ f4350d36-c190-11ec-36fb-8f172f3e5535
md"""Partial derivatives are scalar functions, so will themselves have partial derivatives when the limits are defined. The notation $f_{xy}$ stands for the partial derivative in $y$ of the partial derivative of $f$ in $x$. [Schwarz]()'s theorem says the order of partial derivatives will not matter (e.g., $f_{xy} = f_{yx}$) provided the higher-order derivatives are continuous.
"""

# ╔═╡ f4350d4c-c190-11ec-35b9-6f0626772212
md"""The chain rule applied to $(f\circ\vec{r})(t)$ says:
"""

# ╔═╡ f4350d56-c190-11ec-25ea-ab8665c0ecd1
md"""```math
\frac{d(f\circ\vec{r})}{dt} = \nabla{f}(\vec{r}) \cdot \vec{r}'.
```
"""

# ╔═╡ f4350d60-c190-11ec-0db2-6f8157ee2999
md"""### Vector-valued functions
"""

# ╔═╡ f4350d88-c190-11ec-0530-cbef243f3345
md"""For a function $F:R^n \rightarrow R^m$, the **total derivative** of $F$ is the linear operator $d_F$ satisfying:
"""

# ╔═╡ f4350d92-c190-11ec-2c43-c17fba58b03c
md"""```math
\|F(\vec{x} + \vec{h})-F(\vec{x}) - d_F \vec{h}\| = \mathcal{o}(\|\vec{h}\|)
```
"""

# ╔═╡ f4350db0-c190-11ec-074b-37793383efa7
md"""For $F=\langle f_1, f_2, \dots, f_m\rangle$ the total derivative is the  **Jacobian**, a $m \times n$ matrix of partial derivatives:
"""

# ╔═╡ f4350dc4-c190-11ec-1af9-9f12a1887657
md"""```math
J_f = \left[
\begin{align}{}
\frac{\partial f_1}{\partial x_1} &\quad \frac{\partial f_1}{\partial x_2} &\dots&\quad\frac{\partial f_1}{\partial x_n}\\
\frac{\partial f_2}{\partial x_1} &\quad \frac{\partial f_2}{\partial x_2} &\dots&\quad\frac{\partial f_2}{\partial x_n}\\
&&\vdots&\\
\frac{\partial f_m}{\partial x_1} &\quad \frac{\partial f_m}{\partial x_2} &\dots&\quad\frac{\partial f_m}{\partial x_n}
\end{align}
\right].
```
"""

# ╔═╡ f4350dda-c190-11ec-0a94-bde8d407714d
md"""This can be viewed as being comprised of row vectors, each being the individual gradients; or as column vectors each being the vector of partial derivatives for a given variable.
"""

# ╔═╡ f4350df6-c190-11ec-38ed-ddf04e5269d4
md"""The **chain rule** for $F:R^n \rightarrow R^m$ composed with $G:R^k \rightarrow R^n$ is:
"""

# ╔═╡ f4350e00-c190-11ec-0571-8b5b055a3273
md"""```math
d_{F\circ G}(a) = d_F(G(a)) d_G(a),
```
"""

# ╔═╡ f4350e3e-c190-11ec-2639-b545a5201481
md"""That is the total derivative of $F$ at the point $G(a)$ times (matrix multiplication) the total derivative of $G$ at $a$.  The dimensions work out as $d_F$ is $m\times n$ and $d_G$ is $n\times k$, so $d_(F\circ G)$ will be $m\times k$ and $F\circ{G}: R^k\rightarrow R^m$.
"""

# ╔═╡ f4350e5a-c190-11ec-08e3-a1de807b550b
md"""A scalar function $f:R^n \rightarrow R$ and a parameterized curve $\vec{r}:R\rightarrow R^n$ composes to yield a univariate function. The total derivative of $f\circ\vec{r}$ satisfies:
"""

# ╔═╡ f4350e64-c190-11ec-1bae-ed65f45e1aa4
md"""```math
d_f(\vec{r}) d_\vec{r} = \nabla{f}(\vec{r}(t))' \vec{r}'(t) =
\nabla{f}(\vec{r}(t)) \cdot \vec{r}'(t),
```
"""

# ╔═╡ f4350e78-c190-11ec-2575-6f262baa4f42
md"""as above. (There is an identification of a $1\times 1$ matrix with a scalar in re-expressing as a dot product.)
"""

# ╔═╡ f4350e82-c190-11ec-32df-cf8f93896e66
md"""### The divergence, curl, and their vanishing properties
"""

# ╔═╡ f4350e9e-c190-11ec-2dfa-4fe86ed7d33b
md"""Define the **divergence** of a vector-valued function $F:R^n \rightarrow R^n$ by:
"""

# ╔═╡ f4350eaa-c190-11ec-1745-f3f856a4ad84
md"""```math
\text{divergence}(F) =
\frac{\partial{F_{x_1}}}{\partial{x_1}} +
\frac{\partial{F_{x_2}}}{\partial{x_2}} + \cdots
\frac{\partial{F_{x_n}}}{\partial{x_n}}.
```
"""

# ╔═╡ f4350ebe-c190-11ec-1a94-31a5a0713542
md"""The divergence is a scalar function. For a vector field $F$, it measures the microscopic flow out of a region.
"""

# ╔═╡ f4350edc-c190-11ec-394d-b7c5e21c0081
md"""A vector field whose divergence is identically $0$ is called **incompressible**.
"""

# ╔═╡ f4350f04-c190-11ec-363e-3959643aaffd
md"""Define the **curl** of a *two*-dimensional vector field, $F:R^2 \rightarrow R^2$, by:
"""

# ╔═╡ f4350f18-c190-11ec-180c-b5afd847b761
md"""```math
\text{curl}(F) = \frac{\partial{F_y}}{\partial{x}} -
\frac{\partial{F_x}}{\partial{y}}.
```
"""

# ╔═╡ f4350f2c-c190-11ec-0190-d132673da2d3
md"""The curl for $n=2$ is a scalar function.
"""

# ╔═╡ f4350f54-c190-11ec-0cee-5d528505cd41
md"""For $n=3$ define the **curl** of $F:R^3 \rightarrow R^3$ to be the *vector field*:
"""

# ╔═╡ f4350f68-c190-11ec-15d3-63a169634efc
md"""```math
\text{curl}(F) =
\langle \
\frac{\partial{F_z}}{\partial{y}} - \frac{\partial{F_y}}{\partial{z}},
\frac{\partial{F_x}}{\partial{z}} - \frac{\partial{F_z}}{\partial{x}},
\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}
\rangle.
```
"""

# ╔═╡ f4350f86-c190-11ec-161c-c7207bb8586c
md"""The curl measures the circulation in a vector field. In dimension $n=3$ it *points* in the direction of the normal of the plane of maximum circulation with direction given by the right-hand rule.
"""

# ╔═╡ f4350f9a-c190-11ec-02fe-a9541c3538e1
md"""A vector field whose curl is identically of magnitude $0$ is called **irrotational**.
"""

# ╔═╡ f4350fb8-c190-11ec-11a6-9f1ba31c2616
md"""The $\nabla$ operator is the *formal* vector
"""

# ╔═╡ f4350fcc-c190-11ec-2b41-75a4eb428e03
md"""```math
\nabla = \langle
\frac{\partial}{\partial{x}},
\frac{\partial}{\partial{y}},
\frac{\partial}{\partial{z}}
\rangle.
```
"""

# ╔═╡ f4350fd4-c190-11ec-1804-a71c683c5cf8
md"""The gradient is then scalar "multiplication" on the left: $\nabla{f}$.
"""

# ╔═╡ f4350fea-c190-11ec-383c-cdb3ccb27c6a
md"""The divergence is the dot product on the left: $\nabla\cdot{F}$.
"""

# ╔═╡ f4350ffe-c190-11ec-26b7-61b065aeb1f3
md"""The curl is the the cross product on the left: $\nabla\times{F}$.
"""

# ╔═╡ f4351006-c190-11ec-2aa9-dfe630b430a3
md"""These operations satisfy two vanishing properties:
"""

# ╔═╡ f4351120-c190-11ec-2801-4bbfdc2c798b
md"""  * The curl of a gradient is the zero vector: $\nabla\times\nabla{f}=\vec{0}$
  * The divergence of a curl is $0$: $\nabla\cdot(\nabla\times F)=0$
"""

# ╔═╡ f4351152-c190-11ec-3a14-cb26a17bb502
md"""[Helmholtz]() decomposition theorem says a vector field ($n=3$) which vanishes rapidly enough can be expressed in terms of $F = -\nabla\phi + \nabla\times{A}$. The left term will be irrotational (no curl) and the right term will be incompressible (no divergence).
"""

# ╔═╡ f435116e-c190-11ec-3299-cdb6491eb574
md"""## Integrals
"""

# ╔═╡ f43511b6-c190-11ec-01e9-456288671525
md"""The definite integral, $\int_a^b f(x) dx$, for a bounded univariate function is defined in terms Riemann sums, $\lim \sum f(c_i)\Delta{x_i}$ as the maximum *partition* size goes to $0$. Similarly the integral of a bounded scalar function $f:R^n \rightarrow R$ over a box-like region $[a_1,b_1]\times[a_2,b_2]\times\cdots\times[a_n,b_n]$ can be defined in terms of a limit of Riemann sums. A Riemann integrable function is one for which the upper and lower Riemann sums agree in the limit. A characterization of a Riemann integrable function is that the set of discontinuities has measure $0$.
"""

# ╔═╡ f43511e0-c190-11ec-1a27-b78a0a81766e
md"""If $f$ and the partial functions ($x \rightarrow f(x,y)$ and $y \rightarrow f(x,y)$) are Riemann integrable, then Fubini's theorem allows the definite integral to be performed iteratively:
"""

# ╔═╡ f4351206-c190-11ec-34a6-95815799f262
md"""```math
\iint_{R\times S}fdV = \int_R \left(\int_S f(x,y) dy\right) dx
= \int_S \left(\int_R f(x,y) dx\right) dy.
```
"""

# ╔═╡ f4351212-c190-11ec-104d-e1560565427b
md"""The integral satisfies linearity and monotonicity properties that follow from the definitions:
"""

# ╔═╡ f4351260-c190-11ec-1ba5-1bea2e2516c3
md"""  * For integrable $f$ and $g$ and constants $a$ and $b$:
"""

# ╔═╡ f435126a-c190-11ec-0762-8970269d4e8b
md"""```math
\iint_R (af(x) + bg(x))dV = a\iint_R f(x)dV + b\iint_R g(x) dV.
```
"""

# ╔═╡ f43512ba-c190-11ec-27f6-858e6a1233ae
md"""  * If $R$ and $R'$ are *disjoint* rectangular regions (possibly sharing a boundary), then the integral over the union is defined by linearity:
"""

# ╔═╡ f43512ce-c190-11ec-0191-ebf96dd9e5ff
md"""```math
\iint_{R \cup R'} f(x) dV = \iint_R f(x)dV + \iint_{R'} f(x) dV.
```
"""

# ╔═╡ f435130a-c190-11ec-0fa4-a1e639f1ff16
md"""  * As $f$ is bounded, let $m \leq f(x) \leq M$ for all $x$ in $R$. Then
"""

# ╔═╡ f435131e-c190-11ec-14f4-9755847e14b1
md"""```math
m V(R) \leq \iint_R f(x) dV \leq MV(R).
```
"""

# ╔═╡ f43513da-c190-11ec-1d83-87347897539b
md"""  * If $f$ and $g$ are integrable *and* $f(x) \leq g(x)$, then the integrals have the same property, namely $\iint_R f dV \leq \iint_R gdV$.
  * If $S \subset R$, both closed rectangles, then if $f$ is integrable over $R$ it will be also over $S$ and, when $f\geq 0$, $\iint_S f dV \leq \iint_R fdV$.
  * If $f$ is bounded and integrable, then $|\iint_R fdV| \leq \iint_R |f| dV$.
"""

# ╔═╡ f43513e6-c190-11ec-0a85-ddbb618d777d
md"""In two dimensions, we have the following interpretations:
"""

# ╔═╡ f43513fa-c190-11ec-3b2d-d3a50afc43c1
md"""```math
\begin{align}
\iint_R dA &= \text{area of } R\\
\iint_R \rho dA &= \text{mass with constant density }\rho\\
\iint_R \rho(x,y) dA &= \text{mass of region with density }\rho\\
\frac{1}{\text{area}}\iint_R x \rho(x,y)dA &= \text{centroid of region in } x \text{ direction}\\
\frac{1}{\text{area}}\iint_R y \rho(x,y)dA &= \text{centroid of region in } y \text{ direction}
\end{align}
```
"""

# ╔═╡ f4351404-c190-11ec-1dd2-51cf5b33eb41
md"""In three dimensions, we have the following interpretations:
"""

# ╔═╡ f4351422-c190-11ec-1737-0b6c089c46b7
md"""```math
\begin{align}
\iint_VdV &= \text{volume of } V\\
\iint_V \rho dV &= \text{mass with constant density }\rho\\
\iint_V \rho(x,y) dV &= \text{mass of volume with density }\rho\\
\frac{1}{\text{volume}}\iint_V x \rho(x,y)dV &= \text{centroid of volume in } x \text{ direction}\\
\frac{1}{\text{volume}}\iint_V y \rho(x,y)dV &= \text{centroid of volume in } y \text{ direction}\\
\frac{1}{\text{volume}}\iint_V z \rho(x,y)dV &= \text{centroid of volume in } z \text{ direction}
\end{align}
```
"""

# ╔═╡ f435143e-c190-11ec-1338-b551356a4797
md"""To compute integrals over non-box-like regions, Fubini's theorem may be utilized. Alternatively, a **transformation** of variables
"""

# ╔═╡ f4351454-c190-11ec-351a-231efaef635d
md"""### Line integrals
"""

# ╔═╡ f4351490-c190-11ec-2654-d3f94cdafe79
md"""For a parameterized curve, $\vec{r}(t)$, the **line integral** of a scalar function between $a \leq  t \leq b$ is defined by: $\int_a^b f(\vec{r}(t)) \| \vec{r}'(t)\| dt$. For a path parameterized by arc-length, the integral is expressed by $\int_C f(\vec{r}(s)) ds$ or simply $\int_C f ds$, as the norm is $1$ and $C$ expresses the path.
"""

# ╔═╡ f43514b8-c190-11ec-1b3a-93ffc29781ec
md"""A Jordan curve in two dimensions is a non-intersecting continuous loop in the plane. The Jordan curve theorem states that such a curve divides the plane into a bounded and unbounded region. The curve is *positively* parameterized if the the bounded region is kept on the left. A line integral over a Jordan curve is denoted $\oint_C f ds$.
"""

# ╔═╡ f43514e2-c190-11ec-0eb5-eb38ad73876f
md"""Some interpretations: $\int_a^b \| \vec{r}'(t)\| dt$ computes the *arc-length*. If the path represents a wire with density $\rho(\vec{x})$ then $\int_a^b \rho(\vec{r}(t)) \|\vec{r}'(t)\| dt$ computes the mass of the wire.
"""

# ╔═╡ f4351514-c190-11ec-2937-3347668fed4c
md"""The line integral is also defined for a vector field $F:R^n \rightarrow R^n$ through $\int_a^b F(\vec{r}(t)) \cdot \vec{r}'(t) dt$. When parameterized by arc length, this becomes $\int_C F(\vec{r}(s)) \cdot \hat{T} ds$ or more simply $\int_C F\cdot\hat{T}ds$. In dimension $n=2$ if $\hat{N}$ is the normal, then this line integral (the flow) is also of interest $\int_a^b F(\vec{r}(t)) \cdot \hat{N} dt$ (this is also expressed by $\int_C F\cdot\hat{N} ds$).
"""

# ╔═╡ f4351542-c190-11ec-1089-3d73ae6e7bdb
md"""When $F$ is a *force field*, then the interpretation of $\int_a^b F(\vec{r}(t)) \cdot \vec{r}'(t) dt$ is the amount of *work* to move an object from $\vec{r}(a)$ to $\vec{r}(b)$. (Work measures force applied times distance moved.)
"""

# ╔═╡ f4351574-c190-11ec-2165-67ea06931269
md"""A **conservative force** is a force field within an open region $R$ with the property that the total work done in moving a particle between two points is independent of the path taken. (Similarly, integrals over Jordan curves are zero.)
"""

# ╔═╡ f43515b2-c190-11ec-2a72-37140402a263
md"""The gradient theorem or **fundamental theorem of line integrals** states if $\phi$ is a scalar function then the vector field $\nabla{\phi}$ (if continuous in $R$) is a conservative field. That is if $q$ and $p$ are points, $C$ any curve in $R$, and $\vec{r}$ a parameterization of $C$ over $[a,b]$ that $\phi(p) - \phi(q) = \int_a^b \nabla{f}(\vec{r}(t)) \cdot \vec{r}'(t) dt$.
"""

# ╔═╡ f43515ee-c190-11ec-0c2a-9109fd3b2bca
md"""If $\phi$ is a scalar function producing a field $\nabla{\phi}$ then in dimensions $2$ and $3$ the curl of $\nabla{\phi}$ is zero when the functions involved are continuous. Conversely, if the curl of a force field, $F$, is zero *and* the derivatives are continuous in a *simply connected* domain, then there exists a scalar potential function, $\phi,$ with $F = -\nabla{\phi}$.
"""

# ╔═╡ f435160c-c190-11ec-2cd8-7ffdf4223def
md"""In dimension $2$, if $F$ describes a flow field, the integral $\int_C F \cdot\hat{N}ds$ is interpreted as the flow across the curve $C$; when $C$ is a closed curve $\oint_C F\cdot\hat{N}ds$ is interpreted as the flow out of the region, when $C$ is positively parameterized.
"""

# ╔═╡ f4351634-c190-11ec-24c0-5f805a98370a
md"""**Green's theorem** states if $C$ is a positively oriented Jordan curve in the plane bounding a region $D$ and $F$ is a vector field $F:R^2 \rightarrow R^2$ then $\oint_C F\cdot\hat{T}ds = \iint_D \text{curl}(F) dA$.
"""

# ╔═╡ f435164a-c190-11ec-1abb-392d8c50775a
md"""Green's theorem can be re-expressed in flow form: $\oint_C F\cdot\hat{N}ds=\iint_D\text{divergence}(F)dA$.
"""

# ╔═╡ f4351678-c190-11ec-3326-8bbd166ad0a2
md"""For $F=\langle -y,x\rangle$, Green's theorem says the area of $D$ is given by $(1/2)\oint_C F\cdot\vec{r}' dt$. Similarly, if $F=\langle 0,x\rangle$ or $F=\langle -y,0\rangle$ then the area is given by $\oint_C F\cdot\vec{r}'dt$. The above follows as $\text{curl}(F)$ is $2$ or $1$. Similar formulas can be given to compute the centroids, by identifying a vector field with  $\text{curl}(F) = x$ or $y$.
"""

# ╔═╡ f435168e-c190-11ec-3779-8983167cb214
md"""### Surface integrals
"""

# ╔═╡ f43516dc-c190-11ec-2ddc-075304a38375
md"""A surface in $3$ dimensions can be described by a scalar function $z=f(x,y)$, a parameterization $F:R^2 \rightarrow R^3$ or as a level curve of a scalar function $f(x,y,z)$. The second case, covers the first through the parameterization $(x,y) \rightarrow (x,y,f(x,y)$. For a parameterization of a surface, $\Phi(u,v) = \langle \Phi_x, \Phi_y, \Phi_z\rangle$, let $\partial{\Phi}/\partial{u}$ be the $3$-d vector $\langle \partial{\Phi_x}/\partial{u}, \partial{\Phi_y}/\partial{u}, \partial{\Phi_z}/\partial{u}\rangle$, similarly define $\partial{\Phi}/\partial{v}$. As vectors, these lie in the tangent plane to the surface and this plane has normal vector $\vec{N}=\partial{\Phi}/\partial{u}\times\partial{\Phi}/\partial{v}$. For a closed surface, the parametrization is positive if $\vec{N}$ is an outward pointing normal. Let the *surface element* be defined by $\|\vec{N}\|$.
"""

# ╔═╡ f43516fc-c190-11ec-2372-a9e165a11329
md"""The surface integral of a scalar function $f:R^3 \rightarrow R$ for a parameterization $\Phi:R \rightarrow S$ is defined by
"""

# ╔═╡ f4351706-c190-11ec-0f63-410bdfd17ae9
md"""```math
\iint_R f(\Phi(u,v))
\|\frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}}\|
du dv
```
"""

# ╔═╡ f435171a-c190-11ec-3594-2584092e3392
md"""If $F$ is a vector field, the surface integral may be defined as a flow across the boundary through
"""

# ╔═╡ f435172e-c190-11ec-1e70-f9c45e60a4d5
md"""```math
\iint_R F(\Phi(u,v)) \cdot \vec{N} du dv =
\iint_R (F \cdot \hat{N}) \|\frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}}\| du dv = \iint_S (F\cdot\hat{N})dS
```
"""

# ╔═╡ f4351738-c190-11ec-033a-c9c31ea7860c
md"""### Stokes' theorem, divergence theorem
"""

# ╔═╡ f435176a-c190-11ec-1171-8108d59ade2a
md"""**Stokes' theorem** states that in dimension $3$ if $S$ is a smooth surface with boundary $C$ – *oriented* so the right-hand rule gives the choice of normal for $S$ – and $F$ is a vector field with continuous partial derivatives then:
"""

# ╔═╡ f4351780-c190-11ec-2fdc-491540474932
md"""```math
\iint_S (\nabla\times{F}) \cdot \hat{N} dS = \oint_C F ds.
```
"""

# ╔═╡ f4351792-c190-11ec-296c-771ac10964d6
md"""Stokes' theorem has the same formulation as Green's theorem in dimension $2$, where the surface integral is just the $2$-dimensional integral.
"""

# ╔═╡ f43517a6-c190-11ec-256c-c9920a2e5349
md"""Stokes' theorem is used to show a vector field $F$ with zero curl is conservative if $F$ is continuous in a simply connected region.
"""

# ╔═╡ f43517ba-c190-11ec-042f-8568963ec608
md"""Stokes' theorem is used in Physics, for example, to relate the differential and integral forms of $2$ of Maxwell's equations.
"""

# ╔═╡ f43517d8-c190-11ec-02c1-d7accafef2e6
md"""---
"""

# ╔═╡ f4351800-c190-11ec-136f-7947805bc66b
md"""The **divergence theorem** states if $V$ is a compact volume in $R^3$ with piecewise smooth boundary $S=\partial{V}$ and $F$ is a vector field with continuous partial derivatives then:
"""

# ╔═╡ f435180a-c190-11ec-0143-cb56284e2707
md"""```math
\iint_V (\nabla\cdot{F})dV = \oint_S (F\cdot\hat{N})dS.
```
"""

# ╔═╡ f4351828-c190-11ec-29c1-f91e46757d59
md"""The divergence theorem is available for other dimensions. In the $n=2$ case, it is the alternate (flow) form of  Green's theorem.
"""

# ╔═╡ f4351832-c190-11ec-2f9e-c9834b5400bb
md"""The divergence theorem is used in Physics to express physical laws in either integral or differential form.
"""

# ╔═╡ f435185a-c190-11ec-10f0-673c168eeb7e
HTML("""<div class="markdown"><blockquote>
<p><a href="../integral_vector_calculus/stokes_theorem.html">◅ previous</a>  <a href="../alternatives/symbolics.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integral_vector_calculus/review.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ f435186e-c190-11ec-0e19-6bb3aa351961
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.17"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
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
# ╟─f435183c-c190-11ec-3f26-cf5ed0305ed6
# ╟─f434de58-c190-11ec-0d6c-15e6c5c3f801
# ╟─f434e448-c190-11ec-2d49-3fb2439a45cc
# ╟─f434e4b6-c190-11ec-1a3e-cd66a72b76d4
# ╟─f434e63e-c190-11ec-0487-933ffb535b0f
# ╟─f434e678-c190-11ec-2f54-d1b7afb2abb0
# ╟─f434e696-c190-11ec-1c0a-ab18d7a76283
# ╟─f434e6b4-c190-11ec-3ac0-e1010babd3fb
# ╟─f434e6c8-c190-11ec-33c1-9b7776582040
# ╟─f434e6f0-c190-11ec-087f-a7c593c10c8e
# ╟─f434e6fa-c190-11ec-345c-7197c8351da5
# ╟─f434e718-c190-11ec-0092-e5a66b5b9752
# ╟─f434e74a-c190-11ec-0c15-3d899961f9d2
# ╟─f4350720-c190-11ec-3b2b-038b0c1f1da7
# ╟─f43507c8-c190-11ec-0a19-0701809076c3
# ╟─f435089e-c190-11ec-244c-f3f9c404bfc0
# ╟─f43508e2-c190-11ec-39e0-1b508e00576f
# ╟─f4350914-c190-11ec-048b-a3b1e205d452
# ╟─f4350928-c190-11ec-1678-d3ae7e5bad4f
# ╟─f4350930-c190-11ec-29e2-7975a1ba6bc6
# ╟─f4350964-c190-11ec-0b7d-2f985e1b39f2
# ╟─f435098c-c190-11ec-3602-174c89db65b4
# ╟─f43509a2-c190-11ec-3be8-cf7d3b366d8b
# ╟─f43509c8-c190-11ec-0f50-13b2376a61d2
# ╟─f43509e6-c190-11ec-00dc-33016e62b17c
# ╟─f43509fa-c190-11ec-2244-21d0b4730bf4
# ╟─f4350a22-c190-11ec-2584-610fac55212a
# ╟─f4350a54-c190-11ec-310f-bf14ef8a03b8
# ╟─f4350ab8-c190-11ec-03fa-c3ca089f570b
# ╟─f4350acc-c190-11ec-084b-05fcf5f3bb3f
# ╟─f4350aea-c190-11ec-1142-6f2e372e855b
# ╟─f4350b0a-c190-11ec-2db5-17c5d9b2e353
# ╟─f4350b12-c190-11ec-1d7f-9150bf7f65bc
# ╟─f4350b26-c190-11ec-1770-87ed01ccbf56
# ╟─f4350b4e-c190-11ec-3a17-df174788bda3
# ╟─f4350b62-c190-11ec-07da-6b4bb159a4fc
# ╟─f4350b80-c190-11ec-2b88-4f5145c8a46b
# ╟─f4350ba8-c190-11ec-17ac-01e3d270211e
# ╟─f4350bce-c190-11ec-018c-97c1a0e6555d
# ╟─f4350be4-c190-11ec-25d7-1bc147b16911
# ╟─f4350bee-c190-11ec-28b9-451e3a9930a8
# ╟─f4350c2a-c190-11ec-1911-a3c17a838d0a
# ╟─f4350c3e-c190-11ec-0556-dbeb2851a957
# ╟─f4350c5c-c190-11ec-08be-e1fbdaaac3a7
# ╟─f4350c72-c190-11ec-1ad1-0d5512e8042b
# ╟─f4350c98-c190-11ec-120c-25e0e03a256a
# ╟─f4350cb6-c190-11ec-2f1c-7b00c361e423
# ╟─f4350cf2-c190-11ec-005c-27ac47fdd3a9
# ╟─f4350d36-c190-11ec-36fb-8f172f3e5535
# ╟─f4350d4c-c190-11ec-35b9-6f0626772212
# ╟─f4350d56-c190-11ec-25ea-ab8665c0ecd1
# ╟─f4350d60-c190-11ec-0db2-6f8157ee2999
# ╟─f4350d88-c190-11ec-0530-cbef243f3345
# ╟─f4350d92-c190-11ec-2c43-c17fba58b03c
# ╟─f4350db0-c190-11ec-074b-37793383efa7
# ╟─f4350dc4-c190-11ec-1af9-9f12a1887657
# ╟─f4350dda-c190-11ec-0a94-bde8d407714d
# ╟─f4350df6-c190-11ec-38ed-ddf04e5269d4
# ╟─f4350e00-c190-11ec-0571-8b5b055a3273
# ╟─f4350e3e-c190-11ec-2639-b545a5201481
# ╟─f4350e5a-c190-11ec-08e3-a1de807b550b
# ╟─f4350e64-c190-11ec-1bae-ed65f45e1aa4
# ╟─f4350e78-c190-11ec-2575-6f262baa4f42
# ╟─f4350e82-c190-11ec-32df-cf8f93896e66
# ╟─f4350e9e-c190-11ec-2dfa-4fe86ed7d33b
# ╟─f4350eaa-c190-11ec-1745-f3f856a4ad84
# ╟─f4350ebe-c190-11ec-1a94-31a5a0713542
# ╟─f4350edc-c190-11ec-394d-b7c5e21c0081
# ╟─f4350f04-c190-11ec-363e-3959643aaffd
# ╟─f4350f18-c190-11ec-180c-b5afd847b761
# ╟─f4350f2c-c190-11ec-0190-d132673da2d3
# ╟─f4350f54-c190-11ec-0cee-5d528505cd41
# ╟─f4350f68-c190-11ec-15d3-63a169634efc
# ╟─f4350f86-c190-11ec-161c-c7207bb8586c
# ╟─f4350f9a-c190-11ec-02fe-a9541c3538e1
# ╟─f4350fb8-c190-11ec-11a6-9f1ba31c2616
# ╟─f4350fcc-c190-11ec-2b41-75a4eb428e03
# ╟─f4350fd4-c190-11ec-1804-a71c683c5cf8
# ╟─f4350fea-c190-11ec-383c-cdb3ccb27c6a
# ╟─f4350ffe-c190-11ec-26b7-61b065aeb1f3
# ╟─f4351006-c190-11ec-2aa9-dfe630b430a3
# ╟─f4351120-c190-11ec-2801-4bbfdc2c798b
# ╟─f4351152-c190-11ec-3a14-cb26a17bb502
# ╟─f435116e-c190-11ec-3299-cdb6491eb574
# ╟─f43511b6-c190-11ec-01e9-456288671525
# ╟─f43511e0-c190-11ec-1a27-b78a0a81766e
# ╟─f4351206-c190-11ec-34a6-95815799f262
# ╟─f4351212-c190-11ec-104d-e1560565427b
# ╟─f4351260-c190-11ec-1ba5-1bea2e2516c3
# ╟─f435126a-c190-11ec-0762-8970269d4e8b
# ╟─f43512ba-c190-11ec-27f6-858e6a1233ae
# ╟─f43512ce-c190-11ec-0191-ebf96dd9e5ff
# ╟─f435130a-c190-11ec-0fa4-a1e639f1ff16
# ╟─f435131e-c190-11ec-14f4-9755847e14b1
# ╟─f43513da-c190-11ec-1d83-87347897539b
# ╟─f43513e6-c190-11ec-0a85-ddbb618d777d
# ╟─f43513fa-c190-11ec-3b2d-d3a50afc43c1
# ╟─f4351404-c190-11ec-1dd2-51cf5b33eb41
# ╟─f4351422-c190-11ec-1737-0b6c089c46b7
# ╟─f435143e-c190-11ec-1338-b551356a4797
# ╟─f4351454-c190-11ec-351a-231efaef635d
# ╟─f4351490-c190-11ec-2654-d3f94cdafe79
# ╟─f43514b8-c190-11ec-1b3a-93ffc29781ec
# ╟─f43514e2-c190-11ec-0eb5-eb38ad73876f
# ╟─f4351514-c190-11ec-2937-3347668fed4c
# ╟─f4351542-c190-11ec-1089-3d73ae6e7bdb
# ╟─f4351574-c190-11ec-2165-67ea06931269
# ╟─f43515b2-c190-11ec-2a72-37140402a263
# ╟─f43515ee-c190-11ec-0c2a-9109fd3b2bca
# ╟─f435160c-c190-11ec-2cd8-7ffdf4223def
# ╟─f4351634-c190-11ec-24c0-5f805a98370a
# ╟─f435164a-c190-11ec-1abb-392d8c50775a
# ╟─f4351678-c190-11ec-3326-8bbd166ad0a2
# ╟─f435168e-c190-11ec-3779-8983167cb214
# ╟─f43516dc-c190-11ec-2ddc-075304a38375
# ╟─f43516fc-c190-11ec-2372-a9e165a11329
# ╟─f4351706-c190-11ec-0f63-410bdfd17ae9
# ╟─f435171a-c190-11ec-3594-2584092e3392
# ╟─f435172e-c190-11ec-1e70-f9c45e60a4d5
# ╟─f4351738-c190-11ec-033a-c9c31ea7860c
# ╟─f435176a-c190-11ec-1171-8108d59ade2a
# ╟─f4351780-c190-11ec-2fdc-491540474932
# ╟─f4351792-c190-11ec-296c-771ac10964d6
# ╟─f43517a6-c190-11ec-256c-c9920a2e5349
# ╟─f43517ba-c190-11ec-042f-8568963ec608
# ╟─f43517d8-c190-11ec-02c1-d7accafef2e6
# ╟─f4351800-c190-11ec-136f-7947805bc66b
# ╟─f435180a-c190-11ec-0143-cb56284e2707
# ╟─f4351828-c190-11ec-29c1-f91e46757d59
# ╟─f4351832-c190-11ec-2f9e-c9834b5400bb
# ╟─f435185a-c190-11ec-10f0-673c168eeb7e
# ╟─f4351864-c190-11ec-13ac-fd379263186e
# ╟─f435186e-c190-11ec-0e19-6bb3aa351961
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
