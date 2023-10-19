### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 7ebf37fa-c18a-11ec-0de9-57a77834774f
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 7ebf6504-c18a-11ec-1ac9-b7c6164b0cc1
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
	
	## used in other blocks
	_bar(x) = sum(x)/length(x)
	_shrink(x, xbar, offset) = xbar .+ (1-offset/100)*(x .- xbar)
	function _poly!(plt::Plots.Plot, ps; offset=5, kwargs...)
	    push!(ps, first(ps))
	    xs, ys = unzip(ps)
	    xbar, ybar = _bar.((xs, ys))
	    xs, ys = _shrink.(xs, xbar, offset), _shrink.(ys, ybar, offset)
	
	    plot!(plt, xs, ys; kwargs...)
	#    xn = [xs[end],ys[end]]
	#    x0 = [xs[1], ys[1]]
	#    dxn = 0.95*(x0 - xn)
	
	#    plot!(plt, xn, dxn; kwargs...)
	
	    plt
	end
	_poly!(ps;offset=5,kwargs...) = _poly!(Plots.current(), ps; offset=offset, kwargs...)
	
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
	
	nothing
end

# ╔═╡ 7ec20e50-c18a-11ec-0ac2-7ff277a872fb
using PlutoUI

# ╔═╡ 7ec20e30-c18a-11ec-190c-4587c15a85a2
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 7ebf2fee-c18a-11ec-27fc-f9811921caa7
md"""# The Gradient, Divergence, and Curl
"""

# ╔═╡ 7ebf3034-c18a-11ec-27df-3d44aba01cb9
md"""This section uses these add-on packages:
"""

# ╔═╡ 7ebf659a-c18a-11ec-12a9-0b575c8232f0
md"""---
"""

# ╔═╡ 7ebf664e-c18a-11ec-0bc1-692e95fbfda8
md"""The gradient of a scalar function $f:R^n \rightarrow R$ is a vector field of partial derivatives. In $R^2$, we have:
"""

# ╔═╡ 7ebf669e-c18a-11ec-10a2-81d12dedcd48
md"""```math
~
\nabla{f} = \langle \frac{\partial{f}}{\partial{x}},
\frac{\partial{f}}{\partial{y}} \rangle.
~
```
"""

# ╔═╡ 7ebf66d0-c18a-11ec-156d-ad3c8b5bb7b2
md"""It has the interpretation of pointing out the direction of greatest ascent for the surface $z=f(x,y)$.
"""

# ╔═╡ 7ebf6748-c18a-11ec-33cd-6b67c59f2631
md"""We move now to two other operations, the divergence and the curl, which combine to give a language to describe vector fields in $R^3$.
"""

# ╔═╡ 7ebf677a-c18a-11ec-04ed-5b85c8ddad03
md"""## The divergence
"""

# ╔═╡ 7ebf67de-c18a-11ec-2daf-8fc1a5cf5efb
md"""Let $F:R^3 \rightarrow R^3 = \langle F_x, F_y, F_z\rangle$  be a vector field. Consider now a small box-like region, $R$, with surface, $S$, on the cartesian grid, with sides of length $\Delta x$, $\Delta y$, and $\Delta z$ with $(x,y,z)$ being one corner. The outward pointing unit normals are $\pm \hat{i}, \pm\hat{j},$ and $\pm\hat{k}$.
"""

# ╔═╡ 7ebf7026-c18a-11ec-36fa-fd9819dae158
let
	dx = .5
	dy = .250
	offset=5
	p = plot(;ylim=(0-.2, 1+dy+.4), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
	plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
	plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
	plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)
	
	ps = [[1,1], [0,1],[0,0],[1,0]]
	_poly!(ps, linewidth=3, color=:blue)
	
	ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
	_poly!(ps,  linewidth=3, color=:red)
	
	ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
	_poly!(ps,  linewidth=3, color=:green)
	arrow!([.55,.6],.3*[-1,-1/2], color=:blue)
	arrow!([1+.6dx, .6], .3*[1,0], color=:blue)
	arrow!([.75, 1+.5*dy], .3*[0,1], color=:blue)
	annotate!([
	        (.5, -.1, "Δy"),
	        (1+.75dx, .1, "Δx"),
	        (1+dx+.1, .75, "Δz"),
	        (.5,.15,L"(x,y,z)"),
	        (.45,.6, "î"),
	        (1+.8dx, .7, "ĵ"),
	        (.8, 1+dy+.1, "k̂")
	        ])
	p
end

# ╔═╡ 7ebf70b2-c18a-11ec-2e9b-a3cbcdd87e58
md"""Consider the sides with outward normal $\hat{i}$. The contribution to the surface  integral, $\oint_S (F\cdot\hat{N})dS$, could be *approximated* by
"""

# ╔═╡ 7ebf70dc-c18a-11ec-3bc4-739b723821bc
md"""```math
~
\left(F(x + \Delta x, y, z) \cdot \hat{i}\right) \Delta y \Delta z,
~
```
"""

# ╔═╡ 7ebf710e-c18a-11ec-34fe-cbcc1011a04f
md"""whereas, the contribution for the face with outward normal $-\hat{i}$ could be approximated by:
"""

# ╔═╡ 7ebf712a-c18a-11ec-108d-e93f0e4441ac
md"""```math
~
\left(F(x, y, z) \cdot (-\hat{i}) \right) \Delta y \Delta z.
~
```
"""

# ╔═╡ 7ebf7148-c18a-11ec-05cb-d1a03375c4fb
md"""The functions are being evaluated at a point on the face of the surface. For Riemann integrable functions, any point in a partition may be chosen, so our choice will not restrict the generality.
"""

# ╔═╡ 7ebf715c-c18a-11ec-2d3e-fda8f220f032
md"""The total contribution of the two would be:
"""

# ╔═╡ 7ebf717a-c18a-11ec-18f0-cb9c8868e372
md"""```math
~
\left(F(x + \Delta x, y, z) \cdot \hat{i}\right) \Delta y \Delta z +
\left(F(x, y, z) \cdot (-\hat{i})\right) \Delta y \Delta z =
\left(F_x(x + \Delta x, y, z) - F_x(x, y, z)\right) \Delta y \Delta z,
~
```
"""

# ╔═╡ 7ebf71a0-c18a-11ec-0132-6f92b232c292
md"""as $F \cdot \hat{i} = F_x$.
"""

# ╔═╡ 7ebf71f2-c18a-11ec-2cb2-f113903838b9
md"""*Were* we to divide by $\Delta V = \Delta x \Delta y \Delta z$ *and* take a limit as the volume shrinks, the limit would be $\partial{F}/\partial{x}$.
"""

# ╔═╡ 7ebf721a-c18a-11ec-0a45-df4905acc317
md"""If this is repeated for the other two pair of matching faces, we get a definition for the *divergence*:
"""

# ╔═╡ 7ebf73a0-c18a-11ec-0a5b-1d40e02176ce
md"""> The *divergence* of a vector field $F:R^3 \rightarrow R^3$ is given by $~ \text{divergence}(F) = \lim \frac{1}{\Delta V} \oint_S F\cdot\hat{N} dS = \frac{\partial{F_x}}{\partial{x}} +\frac{\partial{F_y}}{\partial{y}}  +\frac{\partial{F_z}}{\partial{z}}. ~$

"""

# ╔═╡ 7ebf73d2-c18a-11ec-1959-c95e3a7c5533
md"""The limit expression for the divergence will hold for any smooth closed surface, $S$, converging on $(x,y,z)$, not just box-like ones.
"""

# ╔═╡ 7ebf742c-c18a-11ec-2c63-4b4a4c0627f0
md"""### General $n$
"""

# ╔═╡ 7ebf745e-c18a-11ec-1c9b-6ba75baf415e
md"""The derivation of the divergence is done for $n=3$, but could also have easily been done for two dimensions ($n=2$) or higher dimensions $n>3$. The formula in general would be: for $F(x_1, x_2, \dots, x_n): R^n \rightarrow R^n$:
"""

# ╔═╡ 7ebf7470-c18a-11ec-1f29-33ce6c93ef6d
md"""```math
~
\text{divergence}(F) = \sum_{i=1}^n \frac{\partial{F_i}}{\partial{x_i}}.
~
```
"""

# ╔═╡ 7ebf7490-c18a-11ec-251d-4f4021510df8
md"""---
"""

# ╔═╡ 7ebf74d6-c18a-11ec-19ae-510d20a47e87
md"""In `Julia`, the divergence can be implemented different ways depending on how the problem is presented. Here are two functions from the `CalculusWithJulia` package for when the problem is symbolic or numeric:
"""

# ╔═╡ 7ebf751c-c18a-11ec-0fac-7db71d83b666
md"""```
divergence(F::Vector{Sym}, vars) = sum(diff.(F, vars))
divergence(F::Function, pt) = sum(diag(ForwardDiff.jacobian(F, pt)))
```"""

# ╔═╡ 7ebf7546-c18a-11ec-1b44-77e6fa4775d6
md"""The latter being a bit inefficient, as all $n^2$ partial derivatives are found, but only the $n$ diagonal ones are used.
"""

# ╔═╡ 7ebf7562-c18a-11ec-3e6b-3722115799d9
md"""## The curl
"""

# ╔═╡ 7ebf7594-c18a-11ec-09c0-c5152b5caae3
md"""Before considering the curl for $n=3$, we derive a related quantity in $n=2$. The "curl" will be a measure of the microscopic circulation of a vector field. To that end we consider a microscopic box-region in $R^2$:
"""

# ╔═╡ 7ebf8f68-c18a-11ec-0fda-1d10f18aadb0
let
	p = plot(legend=false, xticks=nothing, yticks=nothing, border=:none, xlim=(-1/4, 1+1/4),ylim=(-1/4, 1+1/4))
	apoly!([[0,0],[1,0], [1,1], [0, 1]], linewidth=3, color=:blue)
	
	dx = .025
	arrow!([1/2, dx], .01 *[1,0], linewidth=3, color=:blue)
	arrow!([1/2, 1-dx], .01 *[-1,0], linewidth=3, color=:blue)
	arrow!([1-dx, 1/2], .01 *[0, 1], linewidth=3, color=:blue)
	
	annotate!([
	        (0,-1/16,L"(x,y)"),
	        (1, -1/16, L"(x+\Delta{x},y)"),
	        (0, 1+1/16, L"(x,y+\Delta{y})"),
	        (1/2, 4dx, L"\hat{i}"),
	        (1/2, 1-4dx, L"-\hat{i}"),
	        (3dx, 1/2, L"-\hat{j}"),
	        (1-3dx, 1/2, L"\hat{j}")
	        ])
end

# ╔═╡ 7ebf8fc8-c18a-11ec-3d9d-7dce9b2b98d1
md"""Let $F=\langle F_x, F_y\rangle$. For small enough values of $\Delta{x}$ and $\Delta{y}$ the line integral, $\oint_C F\cdot d\vec{r}$ can be *approximated* by $4$ terms:
"""

# ╔═╡ 7ebf9006-c18a-11ec-013a-2d26d6f0bc61
md"""```math
~
\begin{align}
\left(F(x,y) \cdot \hat{i}\right)\Delta{x} &+
\left(F(x+\Delta{x},y) \cdot \hat{j}\right)\Delta{y} +
\left(F(x,y+\Delta{y}) \cdot (-\hat{i})\right)\Delta{x} +
\left(F(x,y) \cdot (-\hat{j})\right)\Delta{x}\\
&=
F_x(x,y) \Delta{x} + F_y(x+\Delta{x},y)\Delta{y} +
F_x(x, y+\Delta{y}) (-\Delta{x}) + F_y(x,y) (-\Delta{y})\\
&=
(F_y(x + \Delta{x}, y) - F_y(x, y))\Delta{y} -
(F_x(x, y+\Delta{y})-F_x(x,y))\Delta{x}.
\end{align}
~
```
"""

# ╔═╡ 7ebf904c-c18a-11ec-212d-03f611a53121
md"""The Riemann approximation allows a choice of evaluation point for Riemann integrable functions, and the choice here lends itself to further analysis. Were the above divided by $\Delta{x}\Delta{y}$, the area of the box, and a limit taken, partial derivatives appear to suggest this formula:
"""

# ╔═╡ 7ebf906c-c18a-11ec-0b84-9f95f0545e2b
md"""```math
~
\lim \frac{1}{\Delta{x}\Delta{y}} \oint_C F\cdot d\vec{r} =
\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}.
~
```
"""

# ╔═╡ 7ebf9092-c18a-11ec-2009-43b86be2ecda
md"""The scalar function on the right hand side is called the (two-dimensional) curl of $F$ and the left-hand side lends itself as a measure of the microscopic circulation of the vector field, $F:R^2 \rightarrow R^2$.
"""

# ╔═╡ 7ebf90a6-c18a-11ec-16c8-8517ec8ddf2d
md"""---
"""

# ╔═╡ 7ebf90ec-c18a-11ec-0c3d-2fd26a09caef
md"""Consider now a similar scenario for the $n=3$ case. Let $F=\langle F_x, F_y,F_z\rangle$ be a vector field and  $S$ a box-like region with side lengths $\Delta x$, $\Delta y$, and $\Delta z$, anchored at $(x,y,z)$.
"""

# ╔═╡ 7ebf9646-c18a-11ec-2f2d-410375de4ee5
let
	dx = .5
	dy = .250
	offset=5
	p = plot(;ylim=(0-.2, 1+dy+.4), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
	plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
	plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
	plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)
	
	ps = [[1,1], [0,1],[0,0],[1,0]]
	apoly!(ps, linewidth=3, color=:blue)
	
	ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
	apoly!(ps,  linewidth=3, color=:red)
	
	ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
	apoly!(ps,  linewidth=3, color=:green)
	arrow!([.55,.6],.3*[-1,-1/2], color=:blue)
	arrow!([1+.6dx, .6], .3*[1,0], color=:blue)
	arrow!([.75, 1+.5*dy], .3*[0,1], color=:blue)
	annotate!([
	        (.5, -.1, "Δy"),
	        (1+.75dx, .1, "Δx"),
	        (1+dx+.1, .75, "Δz"),
	        (.5,.15,L"(x,y,z)"),
	        (.45,.6, "î"),
	        (1+.8dx, .667, "ĵ"),
	        (.8, 1+dy+.067, "k̂"),
	        (.9, 1.1, "S₁")
	        ])
	p
end

# ╔═╡ 7ebf969e-c18a-11ec-0fb6-014cf5811b77
md"""The box-like volume in space with the top area, with normal $\hat{k}$, designated as $S_1$. The curve $C_1$ traces around $S_1$ in a counter clockwise manner, consistent with the right-hand rule pointing in the outward normal direction. The face $S_1$ with unit normal $\hat{k}$ looks like:
"""

# ╔═╡ 7ebfa850-c18a-11ec-24bf-79e14e3d5ca4
let
	p = plot(xlim=(-.1,1.25), ylim=(-.2, 1.25),legend=false, xticks=nothing, yticks=nothing, border=:none)
	ps = [[1,0],[1,1],[0,1],[0,0]]
	#push!(ps, first(ps))
	apoly!(p, ps, linewidth=3, color=:red)
	#plot!(p, unzip(ps), linewidth=3, color=:red)
	dx = .025
	arrow!([1/2,dx], .01*[1,0], color=:red, linewidth=3)
	arrow!([1/2,1-dx],  .01*[-1,0], color=:red, linewidth=3)
	arrow!([1-dx,1/2], .01*[0,1], color=:red, linewidth=3)
	arrow!([dx,1/2], .01*[0,-1], color=:red, linewidth=3)
	dx = .05
	annotate!([
	        (0, 1/2, "A"),
	        (1/2,2dx, "B"),
	        (1-(3/2)dx,1/2, "C"),
	        (1/2,1-2dx, "D"),
	
	        (.9, 1+dx, "C₁"),
	
	        (2*dx, 1/2, L"\hat{T}=\hat{i}"),
	        (1+2*dx,1/2, L"\hat{T}=-\hat{i}"),
	        (1/2,-3/2*dx, L"\hat{T}=\hat{j}"),
	        (1/2, 1+(3/2)*dx, L"\hat{T}=-\hat{j}"),
	
	        (3dx,1-2dx, "(x,y,z+Δz)"),
	        (4dx,2dx, "(x+Δx,y,z+Δz)"),
	        (1-4dx, 1-2dx, "(x,y+Δy,z+Δz)"),
			(1-2dx, 2dx, "S₁")
	        ])
	
	p
end

# ╔═╡ 7ebfa906-c18a-11ec-1306-6fe671e5bbad
md"""Now we compute the *line integral*. Consider the top face, $S_1$, connecting $(x,y,z+\Delta z), (x + \Delta x, y, z + \Delta z),  (x + \Delta x, y + \Delta y, z + \Delta z),  (x, y + \Delta y, z + \Delta z)$, Using the *right hand rule*, parameterize the boundary curve, $C_1$, in a counter clockwise direction so the right hand rule yields the outward pointing normal ($\hat{k}$). Then the integral $\oint_{C_1} F\cdot \hat{T} ds$ is *approximated* by the following Riemann sum of $4$ terms:
"""

# ╔═╡ 7ebfa92e-c18a-11ec-37a0-498000f02780
md"""```math
~
F(x,y, z+\Delta{z}) \cdot \hat{i}\Delta{x} +
F(x+\Delta x, y, z+\Delta{z}) \cdot \hat{j}  \Delta y +
F(x, y+\Delta y, z+\Delta{z}) \cdot (-\hat{i}) \Delta{x}  +
F(x, y, z+\Delta{z}) \cdot (-\hat{j}) \Delta{y}.
~
```
"""

# ╔═╡ 7ebfa958-c18a-11ec-0bb8-05589fa54a8c
md"""(The points $c_i$ are chosen from the endpoints of the line segments.)
"""

# ╔═╡ 7ebfa96a-c18a-11ec-0303-1bd929a89f68
md"""```math
~
\oint_{C_1} F\cdot \hat{T} ds \approx
(F_y(x+\Delta x, y, z+\Delta{z}) - F_y(x, y, z+\Delta{z})) \Delta{y} -
(F_x(x,y + \Delta{y}, z+\Delta{z}) - F_x(x, y, z+\Delta{z})) \Delta{x}
~
```
"""

# ╔═╡ 7ebfa99c-c18a-11ec-2928-63272442a36a
md"""As before, were this divided by the *area* of the surface, we have after rearranging and cancellation:
"""

# ╔═╡ 7ebfa9b0-c18a-11ec-2a22-5ff57803e5d3
md"""```math
~
\frac{1}{\Delta{S_1}} \oint_{C_1} F \cdot \hat{T} ds \approx
\frac{F_y(x+\Delta x, y, z+\Delta{z}) - F_y(x, y, z+\Delta{z})}{\Delta{x}}
-
\frac{F_x(x, y+\Delta y, z+\Delta{z})-F_x(x, y, z+\Delta{z})}{\Delta{y}}.
~
```
"""

# ╔═╡ 7ebfa9ce-c18a-11ec-07cc-3de2045f05d4
md"""In the limit, as  $\Delta{S} \rightarrow 0$, this will converge to $\partial{F_y}/\partial{x}-\partial{F_x}/\partial{y}$.
"""

# ╔═╡ 7ebfa9ea-c18a-11ec-02bf-154361831f66
md"""Had the bottom of the box been used, a similar result would be found, up to a minus sign.
"""

# ╔═╡ 7ebfaa14-c18a-11ec-2b45-a1f052ef5139
md"""Unlike the two dimensional case, there are other directions to consider and here the other sides will yield different answers. Consider now the face connecting $(x,y,z), (x+\Delta{x}, y, z), (x+\Delta{x}, y, z + \Delta{z})$, and $ (x,y,z+\Delta{z})$ with outward pointing normal $-\hat{j}$. Let $S_2$ denote this face and $C_2$ describe its boundary. Orient this curve so that the right hand rule points in the $-\hat{j}$ direction (the outward pointing normal). Then, as before, we can approximate:
"""

# ╔═╡ 7ebfaa32-c18a-11ec-3d5d-c50807060257
md"""```math
~
\begin{align}
\oint_{C_2} F \cdot \hat{T} ds
&\approx
F(x,y,z) \cdot \hat{i} \Delta{x} +
F(x+\Delta{x},y,z) \cdot \hat{k} \Delta{z} +
F(x,y,z+\Delta{z}) \cdot (-\hat{i}) \Delta{x} +
F(x, y, z) \cdot (-\hat{k}) \Delta{z}\\
&= (F_z(x+\Delta{x},y,z) - F_z(x, y, z))\Delta{z} -
(F_x(x,y,z+\Delta{z}) - F(x,y,z)) \Delta{x}.
\end{align}
~
```
"""

# ╔═╡ 7ebfaa50-c18a-11ec-38da-ef0fe5e1fe2b
md"""Dividing by $\Delta{S}=\Delta{x}\Delta{z}$ and taking a limit will give:
"""

# ╔═╡ 7ebfaa64-c18a-11ec-04de-eb46d3a530d2
md"""```math
~
\lim \frac{1}{\Delta{S}} \oint_{C_2} F \cdot \hat{T} ds =
\frac{\partial{F_z}}{\partial{x}} - \frac{\partial{F_x}}{\partial{z}}.
~
```
"""

# ╔═╡ 7ebfaa82-c18a-11ec-2789-d56de0c7d49a
md"""Had, the opposite face with outward normal $\hat{j}$ been chosen, the answer would differ by a factor of $-1$.
"""

# ╔═╡ 7ebfaab4-c18a-11ec-3e8e-250fce7d7859
md"""Similarly, let $S_3$ be the face with outward normal $\hat{i}$ and curve $C_3$ bounding it with parameterization chosen so that the right hand rule points in the direction of $\hat{i}$. This will give
"""

# ╔═╡ 7ebfaac8-c18a-11ec-3ad5-0ff58d6a9c96
md"""```math
~
\lim \frac{1}{\Delta{S}} \oint_{C_3} F \cdot \hat{T} ds =
\frac{\partial{F_z}}{\partial{y}} - \frac{\partial{F_y}}{\partial{z}}.
~
```
"""

# ╔═╡ 7ebfaadc-c18a-11ec-3410-d99181638b7d
md"""In short, depending on the face chosen, a different answer is given, but all have the same type.
"""

# ╔═╡ 7ebfabb8-c18a-11ec-005e-9dfe806f614e
md"""> Define the *curl* of a $3$-dimensional vector field $F=\langle F_x,F_y,F_z\rangle$ by: $~ \text{curl}(F) = \langle \frac{\partial{F_z}}{\partial{y}} - \frac{\partial{F_y}}{\partial{z}}, \frac{\partial{F_x}}{\partial{z}} - \frac{\partial{F_z}}{\partial{x}}, \frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}} \rangle. ~$

"""

# ╔═╡ 7ebfabea-c18a-11ec-30b2-7f78b98f8bf5
md"""If $S$ is some surface with closed boundary $C$ oriented so that the unit normal, $\hat{N}$, of $S$ is given by the right hand rule about $C$, then
"""

# ╔═╡ 7ebfac08-c18a-11ec-184d-7f43cc06c89c
md"""```math
~
\hat{N} \cdot \text{curl}(F) = \lim \frac{1}{\Delta{S}} \oint_C F \cdot \hat{T} ds.
~
```
"""

# ╔═╡ 7ebfac28-c18a-11ec-3996-a198ffa055f3
md"""The curl has a formal representation in terms of a $3\times 3$ determinant, similar to that used to compute the cross product, that is useful for computation:
"""

# ╔═╡ 7ebfac44-c18a-11ec-1015-253c5775a1b4
md"""```math
~
\text{curl}(F) = \det\left[
\begin{array}{}
\hat{i} & \hat{j} & \hat{k}\\
\frac{\partial}{\partial{x}} & \frac{\partial}{\partial{y}} & \frac{\partial}{\partial{z}}\\
F_x & F_y & F_z
\end{array}
\right]
~
```
"""

# ╔═╡ 7ebfac56-c18a-11ec-3c6a-61336bb4cf43
md"""---
"""

# ╔═╡ 7ebfac94-c18a-11ec-0ef2-cd1dc78d79e9
md"""In `Julia`, the curl can be implemented different ways depending on how the problem is presented. We will use the Jacobian matrix to compute the required partials. If the Jacobian is known, this function from the `CalculusWithJulia` package will combine the off-diagonal terms appropriately:
"""

# ╔═╡ 7ebfacd0-c18a-11ec-2a3c-694be4099005
md"""```
function curl(J::Matrix)
    Mx, Nx, Px, My, Ny, Py, Mz, Nz, Pz = J
    [Py-Nz, Mz-Px, Nx-My] # ∇×VF
end
```"""

# ╔═╡ 7ebfacf8-c18a-11ec-12d4-79c6747f8f4d
md"""The computation of the Jacobian differs whether the problem is treated numerically or symbolically. Here are two functions:
"""

# ╔═╡ 7ebfad16-c18a-11ec-16ec-9d08ee11d1c2
md"""```
curl(F::Vector{Sym}, vars=free_symbols(F)) = curl(F.jacobian(vars))
curl(F::Function, pt) = curl(ForwardDiff.jacobian(F, pt))
```"""

# ╔═╡ 7ebfad48-c18a-11ec-1758-617a0cecaa6c
md"""### The $\nabla$ (del) operator
"""

# ╔═╡ 7ebfadac-c18a-11ec-2204-1f37f207a929
md"""The divergence, gradient, and curl all involve partial derivatives. There is a notation employed that can express the operations more succinctly. Let the [Del operator](https://en.wikipedia.org/wiki/Del) be defined in Cartesian coordinates by the formal expression:
"""

# ╔═╡ 7ebfae42-c18a-11ec-0c21-7396b5067659
md"""> ```math
> ~
> \nabla = \langle
> \frac{\partial}{\partial{x}},
> \frac{\partial}{\partial{y}},
> \frac{\partial}{\partial{z}}
> \rangle.
> ~
> ```

"""

# ╔═╡ 7ebfae74-c18a-11ec-07a3-1f273e260dd3
md"""This is a *vector differential operator* that acts on functions and vector fields through the typical notation to yield the three operations:
"""

# ╔═╡ 7ebfaf1e-c18a-11ec-088b-17ddca3de153
md"""```math
~
\begin{align}
\nabla{f} &= \langle
\frac{\partial{f}}{\partial{x}},
\frac{\partial{f}}{\partial{y}},
\frac{\partial{f}}{\partial{z}}
\rangle, \quad\text{the gradient;}\\
\nabla\cdot{F} &= \langle
\frac{\partial}{\partial{x}},
\frac{\partial}{\partial{y}},
\frac{\partial}{\partial{z}}
\rangle \cdot F =
\langle
\frac{\partial}{\partial{x}},
\frac{\partial}{\partial{y}},
\frac{\partial}{\partial{z}}
\rangle \cdot
\langle F_x, F_y, F_z \rangle =
\frac{\partial{F_x}}{\partial{x}} +
\frac{\partial{F_y}}{\partial{y}} +
\frac{\partial{F_z}}{\partial{z}},\quad\text{the divergence;}\\
\nabla\times F &= \langle
\frac{\partial}{\partial{x}},
\frac{\partial}{\partial{y}},
\frac{\partial}{\partial{z}}
\rangle \times F =
\det\left[
\begin{array}{}
\hat{i} & \hat{j} & \hat{k} \\
\frac{\partial}{\partial{x}}&
\frac{\partial}{\partial{y}}&
\frac{\partial}{\partial{z}}\\
F_x & F_y & F_z
\end{array}
\right],\quad\text{the curl}.
\end{align}
~
```
"""

# ╔═╡ 7ebfc602-c18a-11ec-0e16-9ff4475cf275
note("""
Mathematically operators have not been seen previously, but the concept of an operation on a function that returns another function is a common one when using `Julia`. We have seen many examples (`plot`, `D`, `quadgk`, etc.). In computer science such functions are called *higher order* functions, as they accept arguments which are also functions.
""")

# ╔═╡ 7ebfc634-c18a-11ec-0b14-55563dc6c4a6
md"""---
"""

# ╔═╡ 7ebfc684-c18a-11ec-1ff2-1b82f2975a6d
md"""In the `CalculusWithJulia` package, the constant `\nabla[\tab]`, producing $\nabla$ implements this operator for functions and symbolic expressions.
"""

# ╔═╡ 7ebfcbac-c18a-11ec-297f-61e46ad58dc7
@syms x::real y::real z::real

# ╔═╡ 7ebfd2d2-c18a-11ec-3ca6-3da16d88f08a
begin
	f(x,y,z) = x*y*z
	f(v) = f(v...)
	F(x,y,z) = [x, y, z]
	F(v) = F(v...)
	
	∇(f(x,y,z))  # symbolic operation on the symbolic expression f(x,y,z)
end

# ╔═╡ 7ebfd318-c18a-11ec-0667-7d1c6a181eab
md"""This usage of `∇` takes partial derivatives according to the order given by:
"""

# ╔═╡ 7ebfd61a-c18a-11ec-2775-fb3097d1e835
free_symbols(f(x,y,z))

# ╔═╡ 7ebfd66a-c18a-11ec-3366-81907e05ec87
md"""which may **not** be as desired. In this case, the variables can be specified using a tuple to pair up the expression with the variables to differentiate against:
"""

# ╔═╡ 7ebfdb1a-c18a-11ec-2f72-8508dcd0d74f
∇( (f(x,y,z), [x,y,z]) )

# ╔═╡ 7ebfdb38-c18a-11ec-1673-1d0d4cc190a8
md"""For numeric expressions, we have:
"""

# ╔═╡ 7ebfdf04-c18a-11ec-0700-6d60a98dc12b
∇(f)(1,2,3) # a numeric computation. Also can call with a point [1,2,3]

# ╔═╡ 7ebfdf3e-c18a-11ec-01bb-ed5398773e75
md"""(The extra parentheses are unfortunate. Here `∇` is called like a function.)
"""

# ╔═╡ 7ebfdf52-c18a-11ec-0db6-6f2069d68205
md"""The  divergence can be found symbolically:
"""

# ╔═╡ 7ebfe20e-c18a-11ec-3f08-014d1b92e39e
∇ ⋅ F(x,y,z)

# ╔═╡ 7ebfe234-c18a-11ec-09b4-1f40c6ee89fa
md"""Or numerically:
"""

# ╔═╡ 7ebfe6be-c18a-11ec-3b53-23067be460ff
(∇ ⋅ F)(1,2,3)   # a numeric computation. Also can call (∇ ⋅ F)([1,2,3])

# ╔═╡ 7ebfe6de-c18a-11ec-3be6-152254a32e01
md"""Similarly, the curl. Symbolically:
"""

# ╔═╡ 7ebfe984-c18a-11ec-14c7-23e3937ed8cc
∇ × F(x,y,z)

# ╔═╡ 7ebfe9a2-c18a-11ec-0178-85f3e8ef4144
md"""and numerically:
"""

# ╔═╡ 7ebfee02-c18a-11ec-0931-ffbdf0b13d79
(∇ × F)(1,2,3)  # numeric. Also can call (∇ × F)([1,2,3])

# ╔═╡ 7ebfee52-c18a-11ec-3627-4b35ab378f31
md"""There is a subtle difference in usage. Symbolically the evaluation of `F(x,y,z)` first is desired, numerically the evaluation of `∇ ⋅ F` or `∇ × F` first is desired. As `⋅` and `×` have lower precedence than function evaluation, parentheses must be used in the numeric case.
"""

# ╔═╡ 7ec016c0-c18a-11ec-18bb-6b3619b3ca6f
note("""
As mentioned, for the symbolic evaluations, a specification of three variables (here `x`, `y`, and `z`) is necessary. This use takes `free_symbols` to identify three free symbols which may not always be the case. (It wouldn't be for, say, `F(x,y,z) = [a*x,b*y,0]`, `a` and `b` constants.) In those cases, the notation accepts a tuple to specify the function or vector field and the variables, e.g. (`∇( (f(x,y,z), [x,y,z]) )`, as illustrated;  `∇ × (F(x,y,z), [x,y,z])`; or `∇ ⋅ (F(x,y,z), [x,y,z])` where this is written using function calls to produce the symbolic expression in the first positional argument, though a direct expression could also be used. In these cases, the named versions `gradient`, `curl`, and `divergence` may be preferred.
""")

# ╔═╡ 7ec016ea-c18a-11ec-237c-27205bf8788a
md"""## Interpretation
"""

# ╔═╡ 7ec01706-c18a-11ec-18da-41616c03d627
md"""The divergence and curl measure complementary aspects of a vector field. The divergence is defined in terms of flow out of an infinitesimal box, the curl is about rotational flow around an infinitesimal area patch.
"""

# ╔═╡ 7ec0177c-c18a-11ec-039a-a79c1d3e52e0
md"""Let $F(x,y,z) = [x, 0, 0]$, a vector field pointing in just the $\hat{i}$ direction. The divergence is simply $1$. If $V$ is a box, as in the derivation, then the divergence measures the flow into the side with outward normal $-\hat{i}$ and through the side with outward normal $\hat{i}$ which will clearly be positive as the flow passes through the region $V$, increasing as $x$ increases, when $x > 0$.
"""

# ╔═╡ 7ec017a6-c18a-11ec-02b4-019d62170c5b
md"""The radial vector field $F(x,y,z) = \langle x, y, z \rangle$ is also an example of a divergent field. The divergence is:
"""

# ╔═╡ 7ec01cbc-c18a-11ec-17c1-7fa2bce06753
let
	F(x,y,z) = [x,y,z]
	∇ ⋅ F(x,y,z)
end

# ╔═╡ 7ec01ce2-c18a-11ec-3512-8f6f22b18421
md"""There is a constant outward flow, emanating from the origin. Here we picture the field when $z=0$:
"""

# ╔═╡ 7ec020ca-c18a-11ec-288a-998b28e81d3d
let
	gr()
	F12(x,y) = [x,y]
	F12(v) = F12(v...)
	p = plot(legend=false)
	vectorfieldplot!(p, F12, xlim=(-5,5), ylim=(-5,5), nx=10, ny=10)
	t0, dt = -pi/6, 2pi/6
	r0, dr = 3, 1
	plot!(p, unzip(r -> r * [cos(t0), sin(t0)], r0, r0 + dr)..., linewidth=3)
	plot!(p, unzip(r -> r * [cos(t0+dt), sin(t0+dt)], r0, r0 + dr)..., linewidth=3)
	plot!(p, unzip(t -> r0 * [cos(t), sin(t)], t0, t0 + dt)..., linewidth=3)
	plot!(p, unzip(t -> (r0+dr) * [cos(t), sin(t)], t0, t0 + dt)..., linewidth=3)
	
	p
end

# ╔═╡ 7ec020e8-c18a-11ec-30a9-41b5685aa5dd
md"""Consider the limit definition of the divergence:
"""

# ╔═╡ 7ec02106-c18a-11ec-2829-895ec22ae906
md"""```math
~
\nabla\cdot{F} = \lim \frac{1}{\Delta{V}} \oint_S F\cdot\hat{N} dA.
~
```
"""

# ╔═╡ 7ec0212e-c18a-11ec-3d8b-47600feb2f72
md"""In the vector field above, the shape along the curved edges has constant magnitude field. On the left curved edge, the length is smaller and the field is smaller than on the right. The flux across the left edge will be less than the flux across the right edge, and a net flux will exist. That is, there is divergence.
"""

# ╔═╡ 7ec02142-c18a-11ec-33fd-01f9e99a2c27
md"""Now, were the field on the right edge less, it might be that the two balance out and there is no divergence. This occurs with the inverse square laws, such as for gravity and electric field:
"""

# ╔═╡ 7ec025a2-c18a-11ec-15d4-93905797b091
let
	R = [x,y,z]
	Rhat = R/norm(R)
	VF = (1/norm(R)^2) * Rhat
	∇ ⋅ VF  |> simplify
end

# ╔═╡ 7ec025c0-c18a-11ec-2767-d1fc20530bb0
md"""---
"""

# ╔═╡ 7ec025e8-c18a-11ec-0c5e-85c2b303f626
md"""The vector field $F(x,y,z) = \langle -y, x, 0 \rangle$ is an example of a rotational field. It's curl can be computed symbolically through:
"""

# ╔═╡ 7ec02a52-c18a-11ec-2518-1d5a637c4c61
curl([-y,x,0], [x,y,z])

# ╔═╡ 7ec02a84-c18a-11ec-3ee6-df4709209940
md"""This vector field rotates as seen in  this figure showing slices for different values of $z$:
"""

# ╔═╡ 7ec03068-c18a-11ec-152c-2788f3e25e18
let
	V(x,y,z) = [-y, x,0]
	V(v) = V(v...)
	p = plot([NaN],[NaN],[NaN], legend=false)
	ys = xs = range(-2,2, length=10 )
	zs = range(0, 4, length=3)
	CalculusWithJulia.vectorfieldplot3d!(p, V, xs, ys, zs, nz=3)
	plot!(p, [0,0], [0,0],[-1,5], linewidth=3)
	p
end

# ╔═╡ 7ec030c4-c18a-11ec-3d54-4160780cd6fc
md"""The field has a clear rotation about the $z$ axis (illustrated with a line), the curl is a vector that points in the direction of the *right hand* rule as the right hand fingers follow the flow with magnitude given by the amount of rotation.
"""

# ╔═╡ 7ec030f6-c18a-11ec-106e-396d3d867cc6
md"""This is a bit misleading though, the curl is defined by a limit, and not in terms of a large box. The key point for this field is that the strength of the field is stronger as the points get farther away, so for a properly oriented small box, the integral along the closer edge will be less than that along the outer edge.
"""

# ╔═╡ 7ec0310c-c18a-11ec-344a-a7687bb14d68
md"""Consider a related field where the strength gets smaller as the point gets farther away but otherwise has the same circular rotation pattern
"""

# ╔═╡ 7ec03646-c18a-11ec-374d-e9082ae14495
let
	R = [-y, x, 0]
	VF = R / norm(R)^2
	curl(VF, [x,y,z]) .|> simplify
end

# ╔═╡ 7ec036a0-c18a-11ec-38b2-5d1ef0b4303f
md"""Further, the curl of `R/norm(R)^3` now points in the *opposite* direction of the curl of `R`. This example isn't typical, as dividing by `norm(R)` with a power greater than $1$ makes the vector field discontinuous at the origin.
"""

# ╔═╡ 7ec036c8-c18a-11ec-1e55-19ddb2e2e721
md"""The curl of the  vector field $F(x,y,z) = \langle 0, 1+y^2, 0\rangle$ is $0$, as there is clearly no rotation as seen in this slice where $z=0$:
"""

# ╔═╡ 7ec06062-c18a-11ec-0dd3-cf063bc50ae8
let
	vectorfieldplot((x,y) -> [0, 1+y^2], xlim=(-1,1), ylim=(-1,1), nx=10, ny=8)
end

# ╔═╡ 7ec0609e-c18a-11ec-19ed-2138e559127f
md"""Algebraically, this is so:
"""

# ╔═╡ 7ec082ea-c18a-11ec-027b-410667e62657
curl(Sym[0,1+y^2,0], [x,y,z])

# ╔═╡ 7ec08378-c18a-11ec-2927-ed1318432fdf
md"""Now consider a similar field  $F(x,y,z) = \langle 0, 1+x^2, 0,\rangle$. A slice is somewhat similar, in that the flow lines are all in the $\hat{j}$ direction:
"""

# ╔═╡ 7ec093b6-c18a-11ec-3c76-9b96743acc22
let
	vectorfieldplot((x,y) -> [0, 1+x^2], xlim=(-1,1), ylim=(-1,1), nx=10, ny=8)
end

# ╔═╡ 7ec09442-c18a-11ec-3f5f-515ca620868f
md"""However, this vector field has a curl:
"""

# ╔═╡ 7ec09e92-c18a-11ec-3a58-03cc984573a1
curl([0, 1+x^2,0], [x,y,z])

# ╔═╡ 7ec0a006-c18a-11ec-3f26-49774dcfa82a
md"""The curl points in the $\hat{k}$ direction (out of the figure). A useful visualization is to mentally place a small paddlewheel at a point and imagine if it will turn. In the constant field case, there is equal flow on both sides of the axis, so it any forces on the wheel blades will balance out. In the latter example, if $x > 0$, the force on the right side will be greater than the force on the left so the paddlewheel would rotate counter clockwise. The right hand rule for this rotation will point in the upward, or $\hat{k}$ direction, as seen algebraically in the curl.
"""

# ╔═╡ 7ec0a086-c18a-11ec-1e20-b116d7f6155e
md"""Following Strang, in general the curl can point in any direction, so the amount the paddlewheel will spin will be related to how the paddlewheel is oriented. The angular velocity of the wheel will be $(1/2)(\nabla\times{F})\cdot\hat{N}$, $\hat{N}$ being the normal for the paddlewheel.
"""

# ╔═╡ 7ec0a0e0-c18a-11ec-0084-cdcac81561c6
md"""If $\vec{a}$ is some vector and $\hat{r} = \langle x, y, z\rangle$ is the radial vector, then $\vec{a} \times \vec{r}$ has a curl, which is given by:
"""

# ╔═╡ 7ec0fb1c-c18a-11ec-3c52-dd15ed1fcc40
let
	@syms a1 a2 a3
	a = [a1, a2, a3]
	r = [x, y, z]
	curl(a × r, [x,y, z])
end

# ╔═╡ 7ec0fc34-c18a-11ec-2317-b3de24aa3ad8
md"""The angular velocity then is $\vec{a} \cdot \hat{N}$. The curl is constant. As the dot product involves the cosine of the angle between the two vectors, we see the turning speed is largest when $\hat{N}$ is parallel to $\vec{a}$. This gives a similar statement for the curl like the gradient does for steepest growth rate: the maximum rotation rate of $F$ is $(1/2)\|\nabla\times{F}\|$ in the direction of $\nabla\times{F}$.
"""

# ╔═╡ 7ec0fc5c-c18a-11ec-0b8c-275c021048d9
md"""The curl of the radial vector field, $F(x,y,z) = \langle x, y, z\rangle$ will be $\vec{0}$:
"""

# ╔═╡ 7ec10292-c18a-11ec-22c5-8543be3c7487
curl([x,y,z], [x,y,z])

# ╔═╡ 7ec102ce-c18a-11ec-32e1-77bc7de42acf
md"""We will see that this can be anticipated, as $F = (1/2) \nabla(x^2+y^2+z^2)$ is a gradient field.
"""

# ╔═╡ 7ec102ee-c18a-11ec-39f7-9b0a75d7dbab
md"""In fact, the curl of any radial field will be $\vec{0}$. Here we represent a radial field as a scalar function of $\vec{r}$ time $\hat{r}$:
"""

# ╔═╡ 7ec10850-c18a-11ec-188c-3f3557e66a17
let
	@syms H()
	R = sqrt(x^2 + y^2 + z^2)
	Rhat = [x, y, z]/R
	curl(H(R) * Rhat, [x, y, z])
end

# ╔═╡ 7ec108fa-c18a-11ec-1fca-a1d0380cca48
md"""Were one to represent the curl in [spherical](https://en.wikipedia.org/wiki/Del_in_cylindrical_and_spherical_coordinates) coordinates (below), this follows algebraically from the formula easily enough. To anticipate this, due to symmetry, the curl would need to be the same along any ray emanating from the origin and again by symmetry could only possible point along the ray.  Mentally place a paddlewheel along the $x$ axis oriented along $\hat{i}$. There will be no rotational forces that could make the wheel spin around the $x$-axis, hence the curl must be $0$.
"""

# ╔═╡ 7ec1092c-c18a-11ec-1ac6-f395e9354962
md"""## The Maxwell equations
"""

# ╔═╡ 7ec1099a-c18a-11ec-3734-1fb4bc83a7c8
md"""The divergence and curl appear in [Maxwell](https://en.wikipedia.org/wiki/Maxwell%27s_equations)'s equations describing the relationships of electromagnetism. In the formulas below the notation is $E$ is the electric field; $B$ is the magnetic field; $\rho$ is the charge *density* (charge per unit volume); $J$ the electric current density (current per unit area); and $\epsilon_0$, $\mu_0$, and $c$ are universal constants.
"""

# ╔═╡ 7ec109ae-c18a-11ec-1ba1-c35dc56bbf0b
md"""The equations in differential form are:
"""

# ╔═╡ 7ec10ad0-c18a-11ec-34bf-8b2149786e3b
md"""> Gauss's law: $\nabla\cdot{E} = \rho/\epsilon_0$.

"""

# ╔═╡ 7ec10b02-c18a-11ec-1a8a-e76d1294a7e8
md"""That is, the divergence of the electric field  is proportional to the density. We have already mentioned this in *integral* form.
"""

# ╔═╡ 7ec10b52-c18a-11ec-06c5-d1d4c5334e73
md"""> Gauss's law of magnetism: $\nabla\cdot{B} = 0$

"""

# ╔═╡ 7ec10b98-c18a-11ec-11b0-c788ce3c0e64
md"""The magnetic field has no divergence. This says that there no magnetic charges (a magnetic monopole) unlike electric charge, according to Maxwell's laws.
"""

# ╔═╡ 7ec10bde-c18a-11ec-3851-556fc1decf60
md"""> Faraday's law of induction: $\nabla\times{E} = - \partial{B}/\partial{t}$.

"""

# ╔═╡ 7ec10c1a-c18a-11ec-1ee4-15e1f62b6ba0
md"""The curl of the *time-varying* electric field is in the direction of the partial derivative of the magnetic field. For example, if a magnet is in motion in the in the  $z$ axis, then the electric field has  rotation in the $x-y$ plane *induced* by the motion of the magnet.
"""

# ╔═╡ 7ec10c62-c18a-11ec-1470-fb2eb91fe704
md"""> Ampere's circuital law: $\nabla\times{B} = \mu_0J + \mu_0\epsilon_0 \partial{E}/\partial{t}$

"""

# ╔═╡ 7ec10c6a-c18a-11ec-3694-bfa361895c63
md"""The curl of the magnetic field is related to the sum of the electric current density and the change in time of the electric field.
"""

# ╔═╡ 7ec10c88-c18a-11ec-0fbb-615f30ccee72
md"""---
"""

# ╔═╡ 7ec10cba-c18a-11ec-0490-5351d0948659
md"""In a region with no charges ($\rho=0$) and no currents ($J=\vec{0}$), such as a vacuum, these equations reduce to two divergences being $0$: $\nabla\cdot{E} = 0$ and $\nabla\cdot{B}=0$; and two curl relationships with time derivatives: $\nabla\times{E}= -\partial{B}/\partial{t}$ and $\nabla\times{B} = \mu_0\epsilon_0 \partial{E}/\partial{t}$.
"""

# ╔═╡ 7ec10cce-c18a-11ec-22de-ef37f35be9d3
md"""We will see later how these are differential forms are consequences of related integral forms.
"""

# ╔═╡ 7ec10ce2-c18a-11ec-113b-bd779aa6b8b7
md"""## Algebra of vector calculus
"""

# ╔═╡ 7ec10d0a-c18a-11ec-19f4-7d76b83c0542
md"""The divergence, gradient, and curl satisfy several algebraic [properties](https://en.wikipedia.org/wiki/Vector_calculus_identities).
"""

# ╔═╡ 7ec10d3c-c18a-11ec-365f-1fc1c30b9b05
md"""Let $f$ and $g$ denote scalar functions, $R^3 \rightarrow R$ and $F$ and $G$ be vector fields, $R^3 \rightarrow R^3$.
"""

# ╔═╡ 7ec10d82-c18a-11ec-0173-49c0edbbae3f
md"""### Linearity
"""

# ╔═╡ 7ec10da0-c18a-11ec-2d69-3b4ac57dac7f
md"""As with the sum rule of univariate derivatives, these operations satisfy:
"""

# ╔═╡ 7ec10dd2-c18a-11ec-193b-fdc8c5aff015
md"""```math
~
\begin{align}
\nabla(f + g) &= \nabla{f} + \nabla{g}\\
\nabla\cdot(F+G) &= \nabla\cdot{F} + \nabla\cdot{G}\\
\nabla\times(F+G) &= \nabla\times{F} + \nabla\times{G}.
\end{align}
~
```
"""

# ╔═╡ 7ec10df0-c18a-11ec-3275-859ef5317e22
md"""### Product rule
"""

# ╔═╡ 7ec10e04-c18a-11ec-1e8d-abf8903dd81f
md"""The product rule $(uv)' = u'v + uv'$ has related formulas:
"""

# ╔═╡ 7ec10e22-c18a-11ec-1673-bf20d091deb5
md"""```math
~
\begin{align}
\nabla{(fg)} &= (\nabla{f}) g + f\nabla{g} = g\nabla{f}  + f\nabla{g}\\
\nabla\cdot{fF} &= (\nabla{f})\cdot{F} +  f(\nabla\cdot{F})\\
\nabla\times{fF} &= (\nabla{f})\times{F} +  f(\nabla\times{F}).
\end{align}
~
```
"""

# ╔═╡ 7ec10e36-c18a-11ec-3ba0-8f90800ebdcf
md"""### Rules over cross products
"""

# ╔═╡ 7ec10e4a-c18a-11ec-29a6-d1b9014f5791
md"""The cross product of two vector fields is a vector field for which the divergence and curl may be taken. There are formulas to relate to the individual terms:
"""

# ╔═╡ 7ec10e5c-c18a-11ec-1b48-4119f5864ff4
md"""```math
~
\begin{align}
\nabla\cdot(F \times G) &= (\nabla\times{F})\cdot G - F \cdot (\nabla\times{G})\\
\nabla\times(F \times G) &= F(\nabla\cdot{G}) - G(\nabla\cdot{F} + (G\cdot\nabla)F-(F\cdot\nabla)G\\
&= \nabla\cdot(BA^t - AB^t).
\end{align}
~
```
"""

# ╔═╡ 7ec10e72-c18a-11ec-04ce-3ff0372b7e42
md"""The curl formula is more involved.
"""

# ╔═╡ 7ec10e7c-c18a-11ec-3114-fb67c66b8b40
md"""### Vanishing properties
"""

# ╔═╡ 7ec10e8e-c18a-11ec-3be5-29f615e9ac5b
md"""Surprisingly, the curl and divergence satisfy two vanishing properties. First
"""

# ╔═╡ 7ec10ee0-c18a-11ec-3665-856ebfe0f7d6
md"""> The curl of a gradient field is $\vec{0}$ $~ \nabla \times \nabla{f} = \vec{0}, ~$

"""

# ╔═╡ 7ec10efe-c18a-11ec-1f25-97ed7213b327
md"""if the scalar function $f$ is has continuous second derivatives (so the mixed partials do not depend on order).
"""

# ╔═╡ 7ec10f26-c18a-11ec-2d3b-e58155abe2e2
md"""Vector fields where $F = \nabla{f}$ are conservative. Conservative fields have path independence, so any line integral, $\oint F\cdot \hat{T} ds$,  around a closed loop will be $0$.  But the curl is defined as a limit of such integrals, so it too will be $\vec{0}$. In short,  conservative fields have no rotation.
"""

# ╔═╡ 7ec10f58-c18a-11ec-0420-07665a27e09e
md"""What about the converse? If a vector field has zero curl, then integrals around infinitesimally small loops are $0$. Does this *also* mean that integrals around larger closed loops will also be $0$, and hence the field is conservative? The answer will be yes, *under assumptions*. But the discussion will wait for later.
"""

# ╔═╡ 7ec10f8a-c18a-11ec-0a75-1d261613311a
md"""The combination $\nabla\cdot\nabla{f}$ is defined and is called the Laplacian. This is denoted $\Delta{f}$. The equation $\Delta{f} = 0$ is called Laplace's equation. It is *not* guaranteed for any scalar function $f$, but the $f$ for which it holds are important.
"""

# ╔═╡ 7ec10f92-c18a-11ec-2412-a9fbf92b8140
md"""Second,
"""

# ╔═╡ 7ec10fee-c18a-11ec-300a-6f9a095d6708
md"""> The divergence of a curl field is $0$: $~ \nabla \cdot(\nabla\times{F}) = 0. ~$

"""

# ╔═╡ 7ec11002-c18a-11ec-2e64-5fe9afaf7179
md"""This is not as clear, but can be seen algebraically as terms cancel. First:
"""

# ╔═╡ 7ec11020-c18a-11ec-070f-1b575088e0d0
md"""```math
~
\nabla\cdot(\nabla\times{F}) =
\langle
\frac{\partial}{\partial{x}},
\frac{\partial}{\partial{y}},
\frac{\partial}{\partial{z}}\rangle \cdot
\langle
\frac{\partial{F_z}}{\partial{y}} - \frac{\partial{F_y}}{\partial{z}},
\frac{\partial{F_x}}{\partial{z}} - \frac{\partial{F_z}}{\partial{x}},
\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}
\rangle
=
\left(\frac{\partial^2{F_z}}{\partial{y}\partial{x}} - \frac{\partial^2{F_y}}{\partial{z}\partial{x}}\right) +
\left(\frac{\partial^2{F_x}}{\partial{z}\partial{y}} - \frac{\partial^2{F_z}}{\partial{x}\partial{y}}\right) +
\left(\frac{\partial^2{F_y}}{\partial{x}\partial{z}} - \frac{\partial^2{F_x}}{\partial{y}\partial{z}}\right)
~
```
"""

# ╔═╡ 7ec1103e-c18a-11ec-220c-bbce10572784
md"""Focusing on one component function, $F_z$ say, we see this contribution:
"""

# ╔═╡ 7ec11052-c18a-11ec-1721-81c60b9efcd7
md"""```math
~
\frac{\partial^2{F_z}}{\partial{y}\partial{x}} -
\frac{\partial^2{F_z}}{\partial{x}\partial{y}}.
~
```
"""

# ╔═╡ 7ec11068-c18a-11ec-1c2a-95c202d70ab1
md"""This is zero under the assumption that the second partial derivatives are continuous.
"""

# ╔═╡ 7ec1109a-c18a-11ec-20bb-53a10aadc20d
md"""From the microscopic picture of a box this can also be seen. Again we focus on just the appearance of the $F_z$ component function. Let the faces with normals $\hat{i}, \hat{j},-\hat{i}, -\hat{j}$ be labeled $A, B, C$, and $D$. This figure shows $A$ (enclosed in blue) and $B$ (enclosed in green):
"""

# ╔═╡ 7ec116c4-c18a-11ec-2b43-d93348f33de3
let
	dx = .5
	dy = .250
	offset=5
	p = plot(;ylim=(0-.1, 1+dy+.1), legend=false, aspect_ratio=:equal,xticks=nothing,yticks=nothing, border=:none)
	plot!(p, [dx,dx],[dy,1+dy-offset/100], linestyle=:dash)
	plot!(p, [0+offset/100,dx],[0+offset/100,dy], linestyle=:dash)
	plot!(p, [dx,1+dx-2offset/100],[dy,dy], linestyle=:dash)
	
	ps = [[1,1], [0,1],[0,0],[1,0]]
	apoly!(ps, linewidth=3, color=:blue)
	
	ps = [[1,1], [1+dx, 1+dy], [dx, 1+dy],[0,1]]
	apoly!(ps,  linewidth=3, color=:red)
	
	ps = [[1,0],[1+dx, dy],[1+dx, 1+dy],[1,1]]
	apoly!(ps,  linewidth=3, color=:green)
	annotate!(dx+.02, dy-0.05, L"P_1")
	annotate!(0+0.05, 0 - 0.02, L"P_2")
	annotate!(1+0.05, 0 - 0.02, L"P_3")
	annotate!(1+dx+.02, dy-0.05, L"P_4")
	p
end

# ╔═╡ 7ec11714-c18a-11ec-1fdf-dd2699eb3a42
md"""We will get from the *approximate* surface integral of the *approximate* curl the following terms:
"""

# ╔═╡ 7ec11ef8-c18a-11ec-39c3-c3d0254e8886
let
	@syms x y z Δx Δy Δz
	p1, p2, p3, p4=(x, y, z), (x + Δx, y, z), (x + Δx, y + Δy, z), (x, y + Δy, z)
	@syms F_z()
	global exₐ = (-F_z(p2...) + F_z(p3...))*Δz +   # face A
	(-F_z(p3...) + F_z(p4...))*Δz +   # face B
	(F_z(p1...) - F_z(p4...))*Δz  +   # face C
	(F_z(p2...) - F_z(p1...))*Δz      # face D
end

# ╔═╡ 7ec11f3e-c18a-11ec-0572-0d2f60af5b0f
md"""The term for face $A$, say, should be divided by $\Delta{y}\Delta{z}$ for the curl approximation, but this will be multiplied by the same amount for the divergence calculation, so it isn't written.
"""

# ╔═╡ 7ec11f52-c18a-11ec-044a-0114a44a0d9f
md"""The expression above simplifies to:
"""

# ╔═╡ 7ec12182-c18a-11ec-1bdb-8765f93ab18e
simplify(exₐ)

# ╔═╡ 7ec121a0-c18a-11ec-327e-f7acc51d8b24
md"""This is because of how the line integrals are oriented so that the right-hand rule gives outward pointing normals. For each up stroke for one face, there is a downstroke for a different face, and so the corresponding terms cancel each other out. So providing the limit of these two approximations holds, the vanishing identity can be anticipated from the microscopic picture.
"""

# ╔═╡ 7ec121e6-c18a-11ec-1e4c-eb557172073f
md"""##### Example
"""

# ╔═╡ 7ec1222c-c18a-11ec-2200-6b8e0f62af31
md"""The [invariance of charge](https://en.wikipedia.org/wiki/Maxwell%27s_equations#Charge_conservation) can be derived as a corollary of Maxwell's equation. The divergence of the curl of the magnetic field is $0$, leading to:
"""

# ╔═╡ 7ec12254-c18a-11ec-06d4-f9ba20543efd
md"""```math
~
0 = \nabla\cdot(\nabla\times{B}) =
\mu_0(\nabla\cdot{J} + \epsilon_0 \nabla\cdot{\frac{\partial{E}}{\partial{t}}}) =
\mu_0(\nabla\cdot{J} + \epsilon_0 \frac{\partial}{\partial{t}}(\nabla\cdot{E}))
= \mu_0(\nabla\cdot{J} + \frac{\partial{\rho}}{\partial{t}}).
~
```
"""

# ╔═╡ 7ec1227e-c18a-11ec-2fe5-15ebf30471d1
md"""That is $\nabla\cdot{J} = -\partial{\rho}/\partial{t}$. This says any change in the charge density in time ($\partial{\rho}/\partial{t}$) is balanced off by a divergence in the electric current density ($\nabla\cdot{J}$). That is, charge can't be created or destroyed in an isolated system.
"""

# ╔═╡ 7ec122a4-c18a-11ec-085f-69c07fc15632
md"""## Fundamental theorem of vector calculus
"""

# ╔═╡ 7ec122b8-c18a-11ec-2f21-3582be4123a5
md"""The divergence and curl are complementary ideas. Are there other distinct ideas to sort a vector field by? The Helmholtz decomposition says not really. It states that vector fields that decay rapidly enough can be expressed in terms of two pieces: one with no curl and one with no divergence.
"""

# ╔═╡ 7ec122de-c18a-11ec-3396-239d51173145
md"""From [Wikipedia](https://en.wikipedia.org/wiki/Helmholtz_decomposition) we have this formulation:
"""

# ╔═╡ 7ec12326-c18a-11ec-173a-5f86008dd302
md"""Let $F$ be a vector field on a **bounded** domain $V$ which is twice continuously differentiable. Let $S$ be the surface enclosing $V$. Then $F$ can be decomposed into a curl-free  component and a divergence-free component:
"""

# ╔═╡ 7ec1233a-c18a-11ec-0e60-e73f4ca9b9e7
md"""```math
~
F = -\nabla(\phi) + \nabla\times A.
~
```
"""

# ╔═╡ 7ec1234e-c18a-11ec-1ac6-e77dabfcaf8b
md"""Without explaining why, these values can be computed using volume and surface integrals:
"""

# ╔═╡ 7ec12362-c18a-11ec-0416-fb44b2566776
md"""```math
~
\begin{align}
\phi(\vec{r}') &=
\frac{1}{4\pi} \int_V \frac{\nabla \cdot F(\vec{r})}{\|\vec{r}'-\vec{r} \|} dV -
\frac{1}{4\pi} \oint_S \frac{F(\vec{r})}{\|\vec{r}'-\vec{r} \|} \cdot \hat{N} dS\\
A(\vec{r}') &= \frac{1}{4\pi} \int_V \frac{\nabla \times F(\vec{r})}{\|\vec{r}'-\vec{r} \|} dV +
\frac{1}{4\pi} \oint_S \frac{F(\vec{r})}{\|\vec{r}'-\vec{r} \|} \times \hat{N} dS.
\end{align}
~
```
"""

# ╔═╡ 7ec123a8-c18a-11ec-3471-83bdac87be88
md"""If $V = R^3$, an unbounded domain, *but* $F$ *vanishes* faster than $1/r$, then the theorem still holds with just the volume integrals:
"""

# ╔═╡ 7ec123bc-c18a-11ec-248d-df741825bedd
md"""```math
~
\begin{align}
\phi(\vec{r}') &=\frac{1}{4\pi} \int_V \frac{\nabla \cdot F(\vec{r})}{\|\vec{r}'-\vec{r} \|} dV\\
A(\vec{r}') &= \frac{1}{4\pi} \int_V \frac{\nabla \times F(\vec{r})}{\|\vec{r}'-\vec{r}\|} dV.
\end{align}
~
```
"""

# ╔═╡ 7ec123d0-c18a-11ec-269f-51862288abfe
md"""## Change of variable
"""

# ╔═╡ 7ec1240c-c18a-11ec-2bf4-ff8354af3c5c
md"""The divergence and curl are defined in a manner independent of the coordinate system, though the method to compute them depends on the Cartesian coordinate system. If that is inconvenient, then it is possible to develop the ideas in different coordinate systems.
"""

# ╔═╡ 7ec1243e-c18a-11ec-09a4-8708942c598d
md"""Some details are [here](https://en.wikipedia.org/wiki/Curvilinear_coordinates), the following is based on [some lecture notes](https://www.jfoadi.me.uk/documents/lecture_mathphys2_05.pdf).
"""

# ╔═╡ 7ec1248e-c18a-11ec-1081-39b59ceb3ea8
md"""We restrict to $n=3$ and use $(x,y,z)$ for Cartesian coordinates and $(u,v,w)$ for an *orthogonal* curvilinear coordinate system, such as spherical or cylindrical. If $\vec{r} = \langle x,y,z\rangle$, then
"""

# ╔═╡ 7ec124b6-c18a-11ec-3427-b5d27fa3007c
md"""```math
~
\begin{align}
d\vec{r} &= \langle dx,dy,dz \rangle = J \langle du,dv,dw\rangle\\
&=
\left[ \frac{\partial{\vec{r}}}{\partial{u}} \vdots
\frac{\partial{\vec{r}}}{\partial{v}} \vdots
\frac{\partial{\vec{r}}}{\partial{w}} \right] \langle du,dv,dw\rangle\\
&= \frac{\partial{\vec{r}}}{\partial{u}} du +
\frac{\partial{\vec{r}}}{\partial{v}} dv
\frac{\partial{\vec{r}}}{\partial{w}} dw.
\end{align}
~
```
"""

# ╔═╡ 7ec124fc-c18a-11ec-04e5-bdc9916cb693
md"""The term ${\partial{\vec{r}}}/{\partial{u}}$ is tangent to the curve formed by *assuming* $v$ and $w$ are constant and letting $u$ vary. Similarly for the other partial derivatives. Orthogonality assumes that at every point, these tangent vectors are orthogonal.
"""

# ╔═╡ 7ec12524-c18a-11ec-1ddb-65c3b5ff7557
md"""As ${\partial{\vec{r}}}/{\partial{u}}$ is a vector it has a magnitude and direction. Define the scale factors as the magnitudes:
"""

# ╔═╡ 7ec12556-c18a-11ec-0bc1-015627c0ebff
md"""```math
~
h_u = \| \frac{\partial{\vec{r}}}{\partial{u}} \|,\quad
h_v = \| \frac{\partial{\vec{r}}}{\partial{v}} \|,\quad
h_w = \| \frac{\partial{\vec{r}}}{\partial{w}} \|.
~
```
"""

# ╔═╡ 7ec12592-c18a-11ec-1154-879e0e34c41e
md"""and let $\hat{e}_u$, $\hat{e}_v$, and $\hat{e}_w$ be the unit, direction vectors.
"""

# ╔═╡ 7ec125ba-c18a-11ec-0ed5-a170ed8bf2c6
md"""This gives the following notation:
"""

# ╔═╡ 7ec125d8-c18a-11ec-325b-7f1abf13ee47
md"""```math
~
d\vec{r} = h_u du \hat{e}_u +  h_v dv \hat{e}_v +  h_w dw \hat{e}_w.
~
```
"""

# ╔═╡ 7ec12600-c18a-11ec-35dd-717dd08f2b8b
md"""From here, we can express different formulas.
"""

# ╔═╡ 7ec1261e-c18a-11ec-3b1b-235f5c1d3ddc
md"""For line integrals, we have the line element:
"""

# ╔═╡ 7ec12646-c18a-11ec-31e3-479bf3bda41b
md"""```math
~
dl = \sqrt{d\vec{r}\cdot d\vec{r}} = \sqrt{(h_ud_u)^2 + (h_vd_v)^2 + (h_wd_w)^2}.
~
```
"""

# ╔═╡ 7ec12684-c18a-11ec-1759-3f55f7148bfb
md"""Consider the surface for constant $u$. The vector $\hat{e}_v$ and $\hat{e}_w$ lie in the surface's tangent plane, and the surface element will be:
"""

# ╔═╡ 7ec126a0-c18a-11ec-07c0-2906775e911a
md"""```math
~
dS_u = \|  h_v dv \hat{e}_v \times  h_w dw \hat{e}_w \| = h_v h_w dv dw \| \hat{e}_v \| = h_v h_w dv dw.
~
```
"""

# ╔═╡ 7ec126dc-c18a-11ec-12e1-3b5d23792495
md"""This uses orthogonality, so $\hat{e}_v \times \hat{e}_w$ is parallel to $\hat{e}_u$ and has unit length. Similarly, $dS_v = h_u h_w du dw$ and $dS_w = h_u h_v du dv$ .
"""

# ╔═╡ 7ec12748-c18a-11ec-0886-91f2ac5cf5e0
md"""The volume element is found by *projecting* $d\vec{r}$ onto the $\hat{e}_u$, $\hat{e}_v$, $\hat{e}_w$ coordinate system through $(d\vec{r} \cdot\hat{e}_u) \hat{e}_u$, $(d\vec{r} \cdot\hat{e}_v) \hat{e}_v$, and $(d\vec{r} \cdot\hat{e}_w) \hat{e}_w$. Then forming the triple scalar product to compute the volume of the parallelepiped:
"""

# ╔═╡ 7ec1277c-c18a-11ec-32f0-f3ae840a6624
md"""```math
~
\left[(d\vec{r} \cdot\hat{e}_u) \hat{e}_u\right] \cdot
\left(
\left[(d\vec{r} \cdot\hat{e}_v) \hat{e}_v\right] \times
\left[(d\vec{r} \cdot\hat{e}_w) \hat{e}_w\right]
\right) =
(h_u h_v h_w) ( du dv dw ) (\hat{e}_u \cdot (\hat{e}_v \times \hat{e}_w) =
h_u h_v h_w  du dv dw,
~
```
"""

# ╔═╡ 7ec127ae-c18a-11ec-1166-754ae0f726ea
md"""as the unit vectors are orthonormal, their triple scalar product is $1$ and $d\vec{r}\cdot\hat{e}_u = h_u du$, etc.
"""

# ╔═╡ 7ec12812-c18a-11ec-1529-87fea0d89f46
md"""### Example
"""

# ╔═╡ 7ec12830-c18a-11ec-2311-11708369ee1d
md"""We consider spherical coordinates with
"""

# ╔═╡ 7ec12862-c18a-11ec-189b-9d4fb8ba13c1
md"""```math
~
F(r, \theta, \phi) = \langle
r \sin(\phi) \cos(\theta),
r \sin(\phi) \sin(\theta),
r \cos(\phi)
\rangle.
~
```
"""

# ╔═╡ 7ec128b0-c18a-11ec-29e1-7b3a85c121ca
md"""The following figure draws curves starting at $(r_0, \theta_0, \phi_0)$ formed by holding $2$ of the $3$ variables constant. The tangent vectors are added in blue. The surface $S_r$ formed by a constant value of $r$ is illustrated.
"""

# ╔═╡ 7ec173f8-c18a-11ec-2347-f34086b1ca75
let
	Fx(r, theta, phi) = r * cos(theta) * sin(phi)
	Fy(r, theta, phi) = r * sin(theta) * sin(phi)
	Fz(r, theta, phi) = r * cos(phi)
	F(r, theta, phi) = [Fx(r,theta,phi), Fy(r, theta, phi), Fz(r, theta, phi)]
	Ftp(theta, phi;r = r0) = F(r, theta, phi)
	
	r0, t0, p0 = 1, pi/4, pi/4
	dr, dt, dp = 0.15, pi/8, pi/24
	nr = nt = np = 5
	rs = range(r0, r0+dr, length=nr)
	ts = range(t0, t0+dt, length=nt)
	ps = range(p0, p0 + dp, length=np)
	
	
	# plot lines for fixed r, theta, phi
	p = plot(unzip(r -> F(r,t0,p0), r0, r0+dr)..., legend=false, linewidth=2, color=:black, camera=(50, 60))
	plot!(p, unzip(t -> F(r0,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
	plot!(p, unzip(p -> F(r0,t0,p), p0, p0+dp)..., linewidth=2, color=:black)
	
	for theta in ts[2:end]
	   plot!(p, unzip(phi -> Ftp(theta, phi), p0, p0+dp)...)
	end
	for phi in ps[2:end]
	   plot!(p, unzip(theta -> Ftp(theta, phi), t0, t0+dt)...)
	end
	
	∂Fr(r, theta, phi) = [cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi)]
	∂Fθ(r, theta, phi) = [-r*sin(theta)*sin(phi), r*cos(theta)*sin(phi), 0]
	∂Fϕ(r, theta, phi) = [r*cos(theta)*cos(phi), r*sin(theta)*cos(phi), -r*sin(phi)]
	
	pt = (r0, t0, p0)
	arrow!(p, F(pt...), (1/15) * ∂Fr(pt...), color=:blue, linewidth=4)
	arrow!(p, F(pt...), (1/4) * ∂Fθ(pt...), color=:blue, linewidth=4)
	arrow!(p, F(pt...), (1/10) * ∂Fϕ(pt...), color=:blue, linewidth=4)
	p
end

# ╔═╡ 7ec17600-c18a-11ec-39a5-7bd943e0d2f6
md"""The tangent vectors found from the partial derivatives of $\vec{r}$:
"""

# ╔═╡ 7ec17696-c18a-11ec-37ef-a38ff36ebf8a
md"""```math
~
\begin{align}
\frac{\partial{\vec{r}}}{\partial{r}} &=
\langle \cos(\theta) \cdot \sin(\phi), \sin(\theta) \cdot \sin(\phi), \cos(\phi)\rangle,\\
\frac{\partial{\vec{r}}}{\partial{\theta}} &=
\langle -r\cdot\sin(\theta)\cdot\sin(\phi), r\cdot\cos(\theta)\cdot\sin(\phi), 0\rangle,\\
\frac{\partial{\vec{r}}}{\partial{\phi}} &=
\langle r\cdot\cos(\theta)\cdot\cos(\phi), r\cdot\sin(\theta)\cdot\cos(\phi), -r\cdot\sin(\phi) \rangle.
\end{align}
~
```
"""

# ╔═╡ 7ec176dc-c18a-11ec-2f19-5953331c2695
md"""With this, we have $h_r=1$, $h_\theta=r\sin(\phi)$, and $h_\phi = r$. So that
"""

# ╔═╡ 7ec17718-c18a-11ec-2060-6757fe886517
md"""```math
~
dl = \sqrt{dr^2 + (r\sin(\phi)d\theta^2) + (rd\phi)^2},\quad
dS_r = r^2\sin(\phi)d\theta d\phi,\quad
dS_\theta = rdr d\phi,\quad
dS_\phi = r\sin(\phi)dr d\theta, \quad\text{and}\quad
dV = r^2\sin(\phi) drd\theta d\phi.
~
```
"""

# ╔═╡ 7ec17740-c18a-11ec-291c-9944e4584453
md"""The following visualizes the volume and the surface elements.
"""

# ╔═╡ 7ec185b4-c18a-11ec-3405-9308197aee1d
let
	Fx(r, theta, phi) = r * cos(theta) * sin(phi)
	Fy(r, theta, phi) = r * sin(theta) * sin(phi)
	Fz(r, theta, phi) = r * cos(phi)
	F(r, theta, phi) = [Fx(r,theta,phi), Fy(r, theta, phi), Fz(r, theta, phi)]
	Ftp(theta, phi;r = r0) = F(r, theta, phi)
	
	r0, t0, p0 = 1, pi/4, pi/4
	dr, dt, dp = 0.15, pi/8, pi/24
	nr = nt = np = 5
	rs = range(r0, r0+dr, length=nr)
	ts = range(t0, t0+dt, length=nt)
	ps = range(p0, p0 + dp, length=np)
	
	
	# plot lines for fixed r, theta, phi
	p = plot(unzip(r -> F(r,t0,p0), r0, r0+dr)..., legend=false, linewidth=2, color=:black, camera=(50, 60))
	plot!(p, unzip(r -> F(r,t0+dt,p0), r0, r0+dr)..., linewidth=2, color=:black)
	plot!(p, unzip(r -> F(r,t0,p0+dp), r0, r0+dr)..., linewidth=2, color=:black)
	plot!(p, unzip(r -> F(r,t0+dt,p0+dp), r0, r0+dr)..., linewidth=2, color=:black)
	
	plot!(p, unzip(t -> F(r0,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
	plot!(p, unzip(t -> F(r0+dr,t,p0), t0, t0+dt)..., linewidth=2, color=:black)
	plot!(p, unzip(t -> F(r0,t,p0+dp), t0, t0+dt)..., linewidth=2, color=:black)
	plot!(p, unzip(t -> F(r0+dr,t,p0+dp), t0, t0+dt)..., linewidth=2, color=:black)
	
	plot!(p, unzip(p -> F(r0,t0,p), p0, p0+dp)..., linewidth=2, color=:black)
	plot!(p, unzip(p -> F(r0+dr,t0,p), p0, p0+dp)..., linewidth=2, color=:black)
	plot!(p, unzip(p -> F(r0,t0+dt,p), p0, p0+dp)..., linewidth=2, color=:black)
	plot!(p, unzip(p -> F(r0+dr,t0+dt,p), p0, p0+dp)..., linewidth=2, color=:black)
	
	
	∂Fr(r, theta, phi) = [cos(theta) * sin(phi), sin(theta) * sin(phi), cos(phi)]
	∂Fθ(r, theta, phi) = [-r*sin(theta)*sin(phi), r*cos(theta)*sin(phi), 0]
	∂Fϕ(r, theta, phi) = [r*cos(theta)*cos(phi), r*sin(theta)*cos(phi), -r*sin(phi)]
	
	pt = (r0, t0, p0)
	arrow!(p, F(pt...), (1/15) * ∂Fr(pt...), color=:blue, linewidth=4)
	arrow!(p, F(pt...), (1/4) * ∂Fθ(pt...), color=:blue, linewidth=4)
	arrow!(p, F(pt...), (1/10) * ∂Fϕ(pt...), color=:blue, linewidth=4)
	p
end

# ╔═╡ 7ec18690-c18a-11ec-01b7-650ce2cced11
md"""### The gradient in a new coordinate system
"""

# ╔═╡ 7ec18712-c18a-11ec-3b7d-93f34f6a9143
md"""If $f$ is a scalar function then $df = \nabla{f} \cdot d\vec{r}$ by the chain rule. Using the curvilinear coordinates:
"""

# ╔═╡ 7ec1878a-c18a-11ec-33c0-6f3508aff417
md"""```math
~
df =
\frac{\partial{f}}{\partial{u}} du +
\frac{\partial{f}}{\partial{v}} dv +
\frac{\partial{f}}{\partial{w}} dw
=
\frac{1}{h_u}\frac{\partial{f}}{\partial{u}} h_udu +
\frac{1}{h_v}\frac{\partial{f}}{\partial{v}} h_vdv +
\frac{1}{h_w}\frac{\partial{f}}{\partial{w}} h_wdw.
~
```
"""

# ╔═╡ 7ec187da-c18a-11ec-1436-9f7e3e2d1a55
md"""But, as was used above, $d\vec{r} \cdot \hat{e}_u = h_u du$, etc. so $df$ can be re-expressed as:
"""

# ╔═╡ 7ec1882a-c18a-11ec-1565-f39604dae337
md"""```math
~
df = (\frac{1}{h_u}\frac{\partial{f}}{\partial{u}}\hat{e}_u +
\frac{1}{h_v}\frac{\partial{f}}{\partial{v}}\hat{e}_v +
\frac{1}{h_w}\frac{\partial{f}}{\partial{w}}\hat{e}_w) \cdot d\vec{r} =
\nabla{f} \cdot d\vec{r}.
~
```
"""

# ╔═╡ 7ec1885c-c18a-11ec-0871-05968dd29f78
md"""The gradient is the part within the parentheses.
"""

# ╔═╡ 7ec188de-c18a-11ec-3589-c185d78e1830
md"""---
"""

# ╔═╡ 7ec1893a-c18a-11ec-1e78-1bdd461bc62b
md"""As an example, in cylindrical coordinates, we have $h_r =1$, $h_\theta=r$, and $h_z=1$, giving:
"""

# ╔═╡ 7ec18974-c18a-11ec-1cd5-a9d0586fde1a
md"""```math
~
\nabla{f} = \frac{\partial{f}}{\partial{r}}\hat{e}_r +
\frac{1}{r}\frac{\partial{f}}{\partial{\theta}}\hat{e}_\theta +
\frac{\partial{f}}{\partial{z}}\hat{e}_z
~
```
"""

# ╔═╡ 7ec189ba-c18a-11ec-240f-d79db9d0bc6e
md"""### The divergence in a new coordinate system
"""

# ╔═╡ 7ec189f6-c18a-11ec-0f68-cd8356c8720c
md"""The divergence is a result of the limit of a surface integral,
"""

# ╔═╡ 7ec18a46-c18a-11ec-16b9-3d234db277b3
md"""```math
~
\nabla \cdot F = \lim \frac{1}{\Delta{V}}\oint_S F \cdot \hat{N} dS.
~
```
"""

# ╔═╡ 7ec18ac8-c18a-11ec-3557-910faaa0d869
md"""Taking $V$ as a box in the curvilinear coordinates, with side lengths $h_udu$, $h_vdv$, and $h_wdw$ the surface integral is computed by projecting $F$ onto each normal area element and multiplying by the area. The task is similar to how the the divergence was derived above, only now the terms are like $\partial{(F_uh_vh_w)}/\partial{u}$ due to the scale factors ($F_u$ is the u component of $F$.) The result is:
"""

# ╔═╡ 7ec18ae6-c18a-11ec-129a-316d0ce25df9
md"""```math
~
\nabla\cdot F = \frac{1}{h_u h_v h_w}\left[
\frac{\partial{(F_uh_vh_w)}}{\partial{u}} +
\frac{\partial{(h_uF_vh_w)}}{\partial{v}} +
\frac{\partial{(h_uh_vF_w)}}{\partial{w}} \right].
~
```
"""

# ╔═╡ 7ec18b0e-c18a-11ec-126b-778e858a2808
md"""---
"""

# ╔═╡ 7ec18b2c-c18a-11ec-2c93-0d3d54e537ca
md"""For example, in cylindrical coordinates, we have
"""

# ╔═╡ 7ec18b4a-c18a-11ec-26e1-3540ff7a07fc
md"""```math
~
\nabla \cdot F = \frac{1}{r}
\left[
\frac{\partial{F_r r}}{\partial{r}} +
\frac{\partial{F_\theta}}{\partial{\theta}} +
\frac{\partial{F_x}}{\partial{z}}
\right].
~
```
"""

# ╔═╡ 7ec18b72-c18a-11ec-3212-89af436929b2
md"""### The curl in a new coordinate system
"""

# ╔═╡ 7ec18b86-c18a-11ec-30c4-67df6b12ce74
md"""The curl, like the divergence, can be expressed as the limit of an integral:
"""

# ╔═╡ 7ec18bb8-c18a-11ec-09f6-9f26cf0b319c
md"""```math
~
(\nabla \times F) \cdot \hat{N} = \lim \frac{1}{\Delta{S}} \oint_C F \cdot d\vec{r},
~
```
"""

# ╔═╡ 7ec18c0a-c18a-11ec-26c5-3b5865baae92
md"""where $S$ is a surface perpendicular to $\hat{N}$ with boundary $C$. For a small rectangular surface, the derivation is similar to above, only the scale factors are included. This gives, say, for the $\hat{e}_u$ normal, $\frac{\partial{(h_zF_z)}}{\partial{y}} - \frac{\partial{(h_yF_y)}}{\partial{z}}$. The following determinant form combines the terms compactly:
"""

# ╔═╡ 7ec18c26-c18a-11ec-2a48-836ca166e58f
md"""```math
~
\nabla\times{F} = \det \left[
\begin{array}{}
h_u\hat{e}_u & h_v\hat{e}_v & h_w\hat{e}_w \\
\frac{\partial}{\partial{u}} & \frac{\partial}{\partial{v}} & \frac{\partial}{\partial{w}} \\
h_uF_u & h_v F_v & h_w F_w
\end{array}
\right].
~
```
"""

# ╔═╡ 7ec18c44-c18a-11ec-3ed0-d1714c34eda3
md"""---
"""

# ╔═╡ 7ec18c62-c18a-11ec-1c37-5ff27e683da9
md"""For example, in cylindrical coordinates, the curl is:
"""

# ╔═╡ 7ec18c94-c18a-11ec-2540-6971e74f69aa
md"""```math
~
\det\left[
\begin{array}{}
\hat{r} & r\hat{\theta} & \hat{k} \\
\frac{\partial}{\partial{r}} & \frac{\partial}{\partial{\theta}} & \frac{\partial}{\partial{z}} \\
F_r & rF_\theta & F_z
\end{array}
\right]
~
```
"""

# ╔═╡ 7ec18cbc-c18a-11ec-3214-ef548dee5340
md"""Applying this to the function $F(r,\theta, z) = \hat{\theta}$ we get:
"""

# ╔═╡ 7ec18ce4-c18a-11ec-2454-f728611aec36
md"""```math
~
\text{curl}(F) = \det\left[
\begin{array}{}
\hat{r} & r\hat{\theta} & \hat{k} \\
\frac{\partial}{\partial{r}} & \frac{\partial}{\partial{\theta}} & \frac{\partial}{\partial{z}} \\
0 & r & 0
\end{array}
\right] =
\hat{k} \det\left[
\begin{array}{}
\frac{\partial}{\partial{r}} & \frac{\partial}{\partial{\theta}}\\
0 & r
\end{array}
\right] =
\hat{k}.
~
```
"""

# ╔═╡ 7ec18d34-c18a-11ec-1122-c71d02fc276f
md"""As $F$ represents a vector field that rotates about the $z$ axis at a constant rate, the magnitude of the curl should be a constant and it should point in the $\hat{k}$ direction, as we found.
"""

# ╔═╡ 7ec18d7a-c18a-11ec-2f72-d357c9d15dfb
md"""## Questions
"""

# ╔═╡ 7ec18dde-c18a-11ec-11c2-cf645438a1a4
md"""###### Question
"""

# ╔═╡ 7ec18e04-c18a-11ec-2493-598e5f50ae33
md"""Numerically find the divergence of $F(x,y,z) = \langle xy, yz, zx\rangle$ at the point $\langle 1,2,3\rangle$.
"""

# ╔═╡ 7ec1973e-c18a-11ec-1b5e-25c676b1d35c
let
	F(x,y,z) = [x*y, y*z, z*x]
	pt = [1,2,3]
	Jac = ForwardDiff.jacobian(pt -> F(pt...), pt)
	val = sum(diag(Jac))
	numericq(val)
end

# ╔═╡ 7ec19770-c18a-11ec-12c2-a7c0429a3bc6
md"""###### Question
"""

# ╔═╡ 7ec197b6-c18a-11ec-31c2-2fe02df010c7
md"""Numerically find the curl of $F(x,y,z) = \langle xy, yz, zx\rangle$ at the point $\langle 1,2,3\rangle$. What is the $x$ component?
"""

# ╔═╡ 7ec1a012-c18a-11ec-292c-b9f59354a9bf
let
	F(x,y,z) = [x*y, y*z, z*x]
	F(v) = F(v...)
	pt = [1,2,3]
	vals = (∇×F)(pt)
	val = vals[1]
	numericq(val)
end

# ╔═╡ 7ec1a044-c18a-11ec-3a76-45d9e1406114
md"""###### Question
"""

# ╔═╡ 7ec1a094-c18a-11ec-267d-13aca30e40d4
md"""Let $F(x,y,z) = \langle \sin(x), e^{xy}, xyz\rangle$. Find the divergence of $F$ symbolically.
"""

# ╔═╡ 7ec1afa8-c18a-11ec-3a98-d9b2733c9d87
let
	choices = [
	raw" ``x y + x e^{x y} + \cos{\left (x \right )}``",
	raw" ``x y + x e^{x y}``",
	raw" ``x e^{x y} + \cos{\left (x \right )}``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 7ec1afe4-c18a-11ec-3e74-8da776dc3c33
md"""###### Question
"""

# ╔═╡ 7ec1b020-c18a-11ec-2ca5-814ed7e67ac5
md"""Let $F(x,y,z) = \langle \sin(x), e^{xy}, xyz\rangle$. Find the curl of $F$ symbolically. What is the $x$ component?
"""

# ╔═╡ 7ec1b85e-c18a-11ec-3aa2-cdc98adcebce
let
	choices = [
	raw" ``xz``",
	raw" ``-yz``",
	raw" ``ye^{xy}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 7ec1b886-c18a-11ec-1eec-2b1c5e7987e0
md"""###### Question
"""

# ╔═╡ 7ec1b8b8-c18a-11ec-200f-2df700c6d0e6
md"""Let $\phi(x,y,z) = x + 2y + 3z$. We know that $\nabla\times\nabla{\phi}$ is zero by the vanishing property. Compute $\nabla\cdot\nabla{\phi}$.
"""

# ╔═╡ 7ec1c056-c18a-11ec-3989-a5ed1bdc7837
let
	choices=[
	raw" ``0``",
	raw" ``\vec{0}``",
	raw" ``6``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 7ec1c074-c18a-11ec-05ac-0b28b1dd0224
md"""###### Question
"""

# ╔═╡ 7ec1c088-c18a-11ec-3ff1-fb4d79c88b13
md"""In two dimension's the curl of a gradient field simplifies to:
"""

# ╔═╡ 7ec1c0ba-c18a-11ec-27ce-5d9889b2628b
md"""```math
~
\nabla\times\nabla{f} = \nabla\times
\langle\frac{\partial{f}}{\partial{x}},
\frac{\partial{f}}{\partial{y}}\rangle =
\frac{\partial{\frac{\partial{f}}{\partial{y}}}}{\partial{x}} -
\frac{\partial{\frac{\partial{f}}{\partial{x}}}}{\partial{y}}.
~
```
"""

# ╔═╡ 7ec1ce3e-c18a-11ec-04a5-85f4e6adf155
let
	choices = [
	L"This is $0$ if the partial derivatives are continuous by Schwarz's (Clairault's) theorem",
	L"This is $0$ for any $f$, as $\nabla\times\nabla$ is $0$ since the cross product of vector with itself is the $0$ vector."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 7ec1ce5a-c18a-11ec-1f0f-9b4759323798
md"""###### Question
"""

# ╔═╡ 7ec1ce7a-c18a-11ec-1313-a36c3df9f853
md"""Based on this vector-field plot
"""

# ╔═╡ 7ec1d226-c18a-11ec-3595-0d37a08f5167
let
	gr()
	F(x,y) = [-y,x]/sqrt(0.0000001 + x^2+y^2)
	vectorfieldplot(F, xlim=(-5,5),ylim=(-5,5), nx=15, ny=15)
end

# ╔═╡ 7ec1d23a-c18a-11ec-1227-b30239585cc4
md"""which seems likely
"""

# ╔═╡ 7ec1de38-c18a-11ec-16a9-cb38134ea634
let
	choices=[
	"The field is incompressible (divergence free)",
	"The field is irrotational (curl free)",
	"The field has a non-trivial curl and divergence"
	]
	ans=1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7ec1de60-c18a-11ec-25ce-ad8d79e5949d
md"""###### Question
"""

# ╔═╡ 7ec1de76-c18a-11ec-30d4-5d1c5a661f39
md"""Based on this vectorfield plot
"""

# ╔═╡ 7ec1e1ee-c18a-11ec-3b1c-375018bff1bb
let
	gr()
	F(x,y) = [x,y]/sqrt(0.0000001 + x^2+y^2)
	vectorfieldplot(F, xlim=(-5,5),ylim=(-5,5), nx=15, ny=15)
end

# ╔═╡ 7ec1e20c-c18a-11ec-174c-39a8711734fb
md"""which seems likely
"""

# ╔═╡ 7ec1edd8-c18a-11ec-30dd-511c232de15d
let
	choices=[
	"The field is incompressible (divergence free)",
	"The field is irrotational (curl free)",
	"The field has a non-trivial curl and divergence"
	]
	ans=2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7ec1edf6-c18a-11ec-3d94-f377a45be4ef
md"""###### Question
"""

# ╔═╡ 7ec1ee1c-c18a-11ec-3573-d1313a02240c
md"""The electric field $E$ (by Maxwell's equations) satisfies:
"""

# ╔═╡ 7ec1fa60-c18a-11ec-3ba8-9ba8f1ce4aeb
let
	choices=[
	"The field is incompressible (divergence free)",
	"The field is irrotational (curl free)",
	"The field has a non-trivial curl and divergence"
	]
	ans=3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7ec1fa80-c18a-11ec-1083-377edc3fd12c
md"""###### Question
"""

# ╔═╡ 7ec1faa8-c18a-11ec-2c71-33446b83f68b
md"""The magnetic field $B$ (by Maxwell's equations) satisfies:
"""

# ╔═╡ 7ec205b6-c18a-11ec-2334-6da22a5c1496
let
	choices=[
	"The field is incompressible (divergence free)",
	"The field is irrotational (curl free)",
	"The field has a non-trivial curl and divergence"
	]
	ans=1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7ec205d4-c18a-11ec-19f4-df58a2b2e839
md"""###### Question
"""

# ╔═╡ 7ec205fc-c18a-11ec-3c8c-abdf0aef9d94
md"""For spherical coordinates, $\Phi(r, \theta, \phi)=r \langle \sin\phi\cos\theta,\sin\phi\sin\theta,\cos\phi\rangle$,  the scale factors are $h_r = 1$, $h_\theta=r\sin\phi$, and $h_\phi=r$.
"""

# ╔═╡ 7ec20612-c18a-11ec-082c-712b4112c222
md"""The curl then will then be
"""

# ╔═╡ 7ec2062e-c18a-11ec-2120-2dff3b7da5ed
md"""```math
~
\nabla\times{F} = \det \left[
\begin{array}{}
\hat{e}_r & r\sin\phi\hat{e}_\theta & r\hat{e}_\phi \\
\frac{\partial}{\partial{r}} & \frac{\partial}{\partial{\theta}} & \frac{\partial}{\partial{phi}} \\
F_r & r\sin\phi F_\theta & r F_\phi
\end{array}
\right].
~
```
"""

# ╔═╡ 7ec2066a-c18a-11ec-0585-d71ecf91bdf4
md"""For a *radial* function $F = h(r)e_r$. (That is $F_r = h(r)$, $F_\theta=0$, and $F_\phi=0$. What is the curl of $F$?
"""

# ╔═╡ 7ec20e26-c18a-11ec-27d4-2bf58870abbc
let
	choices = [
	raw" ``\vec{0}``",
	raw" ``re_\phi``",
	raw" ``rh'(r)e_\phi``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 7ec20e50-c18a-11ec-0fe3-bde82701fd4c
HTML("""<div class="markdown"><blockquote>
<p><a href="../integral_vector_calculus/line_integrals.html">◅ previous</a>  <a href="../integral_vector_calculus/stokes_theorem.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integral_vector_calculus/div_grad_curl.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 7ec20e58-c18a-11ec-2424-5f5a7cd0bf3d
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.17"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
PyPlot = "~2.10.0"
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
# ╟─7ec20e30-c18a-11ec-190c-4587c15a85a2
# ╟─7ebf2fee-c18a-11ec-27fc-f9811921caa7
# ╟─7ebf3034-c18a-11ec-27df-3d44aba01cb9
# ╠═7ebf37fa-c18a-11ec-0de9-57a77834774f
# ╟─7ebf6504-c18a-11ec-1ac9-b7c6164b0cc1
# ╟─7ebf659a-c18a-11ec-12a9-0b575c8232f0
# ╟─7ebf664e-c18a-11ec-0bc1-692e95fbfda8
# ╟─7ebf669e-c18a-11ec-10a2-81d12dedcd48
# ╟─7ebf66d0-c18a-11ec-156d-ad3c8b5bb7b2
# ╟─7ebf6748-c18a-11ec-33cd-6b67c59f2631
# ╟─7ebf677a-c18a-11ec-04ed-5b85c8ddad03
# ╟─7ebf67de-c18a-11ec-2daf-8fc1a5cf5efb
# ╟─7ebf7026-c18a-11ec-36fa-fd9819dae158
# ╟─7ebf70b2-c18a-11ec-2e9b-a3cbcdd87e58
# ╟─7ebf70dc-c18a-11ec-3bc4-739b723821bc
# ╟─7ebf710e-c18a-11ec-34fe-cbcc1011a04f
# ╟─7ebf712a-c18a-11ec-108d-e93f0e4441ac
# ╟─7ebf7148-c18a-11ec-05cb-d1a03375c4fb
# ╟─7ebf715c-c18a-11ec-2d3e-fda8f220f032
# ╟─7ebf717a-c18a-11ec-18f0-cb9c8868e372
# ╟─7ebf71a0-c18a-11ec-0132-6f92b232c292
# ╟─7ebf71f2-c18a-11ec-2cb2-f113903838b9
# ╟─7ebf721a-c18a-11ec-0a45-df4905acc317
# ╟─7ebf73a0-c18a-11ec-0a5b-1d40e02176ce
# ╟─7ebf73d2-c18a-11ec-1959-c95e3a7c5533
# ╟─7ebf742c-c18a-11ec-2c63-4b4a4c0627f0
# ╟─7ebf745e-c18a-11ec-1c9b-6ba75baf415e
# ╟─7ebf7470-c18a-11ec-1f29-33ce6c93ef6d
# ╟─7ebf7490-c18a-11ec-251d-4f4021510df8
# ╟─7ebf74d6-c18a-11ec-19ae-510d20a47e87
# ╟─7ebf751c-c18a-11ec-0fac-7db71d83b666
# ╟─7ebf7546-c18a-11ec-1b44-77e6fa4775d6
# ╟─7ebf7562-c18a-11ec-3e6b-3722115799d9
# ╟─7ebf7594-c18a-11ec-09c0-c5152b5caae3
# ╟─7ebf8f68-c18a-11ec-0fda-1d10f18aadb0
# ╟─7ebf8fc8-c18a-11ec-3d9d-7dce9b2b98d1
# ╟─7ebf9006-c18a-11ec-013a-2d26d6f0bc61
# ╟─7ebf904c-c18a-11ec-212d-03f611a53121
# ╟─7ebf906c-c18a-11ec-0b84-9f95f0545e2b
# ╟─7ebf9092-c18a-11ec-2009-43b86be2ecda
# ╟─7ebf90a6-c18a-11ec-16c8-8517ec8ddf2d
# ╟─7ebf90ec-c18a-11ec-0c3d-2fd26a09caef
# ╟─7ebf9646-c18a-11ec-2f2d-410375de4ee5
# ╟─7ebf969e-c18a-11ec-0fb6-014cf5811b77
# ╟─7ebfa850-c18a-11ec-24bf-79e14e3d5ca4
# ╟─7ebfa906-c18a-11ec-1306-6fe671e5bbad
# ╟─7ebfa92e-c18a-11ec-37a0-498000f02780
# ╟─7ebfa958-c18a-11ec-0bb8-05589fa54a8c
# ╟─7ebfa96a-c18a-11ec-0303-1bd929a89f68
# ╟─7ebfa99c-c18a-11ec-2928-63272442a36a
# ╟─7ebfa9b0-c18a-11ec-2a22-5ff57803e5d3
# ╟─7ebfa9ce-c18a-11ec-07cc-3de2045f05d4
# ╟─7ebfa9ea-c18a-11ec-02bf-154361831f66
# ╟─7ebfaa14-c18a-11ec-2b45-a1f052ef5139
# ╟─7ebfaa32-c18a-11ec-3d5d-c50807060257
# ╟─7ebfaa50-c18a-11ec-38da-ef0fe5e1fe2b
# ╟─7ebfaa64-c18a-11ec-04de-eb46d3a530d2
# ╟─7ebfaa82-c18a-11ec-2789-d56de0c7d49a
# ╟─7ebfaab4-c18a-11ec-3e8e-250fce7d7859
# ╟─7ebfaac8-c18a-11ec-3ad5-0ff58d6a9c96
# ╟─7ebfaadc-c18a-11ec-3410-d99181638b7d
# ╟─7ebfabb8-c18a-11ec-005e-9dfe806f614e
# ╟─7ebfabea-c18a-11ec-30b2-7f78b98f8bf5
# ╟─7ebfac08-c18a-11ec-184d-7f43cc06c89c
# ╟─7ebfac28-c18a-11ec-3996-a198ffa055f3
# ╟─7ebfac44-c18a-11ec-1015-253c5775a1b4
# ╟─7ebfac56-c18a-11ec-3c6a-61336bb4cf43
# ╟─7ebfac94-c18a-11ec-0ef2-cd1dc78d79e9
# ╟─7ebfacd0-c18a-11ec-2a3c-694be4099005
# ╟─7ebfacf8-c18a-11ec-12d4-79c6747f8f4d
# ╟─7ebfad16-c18a-11ec-16ec-9d08ee11d1c2
# ╟─7ebfad48-c18a-11ec-1758-617a0cecaa6c
# ╟─7ebfadac-c18a-11ec-2204-1f37f207a929
# ╟─7ebfae42-c18a-11ec-0c21-7396b5067659
# ╟─7ebfae74-c18a-11ec-07a3-1f273e260dd3
# ╟─7ebfaf1e-c18a-11ec-088b-17ddca3de153
# ╟─7ebfc602-c18a-11ec-0e16-9ff4475cf275
# ╟─7ebfc634-c18a-11ec-0b14-55563dc6c4a6
# ╟─7ebfc684-c18a-11ec-1ff2-1b82f2975a6d
# ╠═7ebfcbac-c18a-11ec-297f-61e46ad58dc7
# ╠═7ebfd2d2-c18a-11ec-3ca6-3da16d88f08a
# ╟─7ebfd318-c18a-11ec-0667-7d1c6a181eab
# ╠═7ebfd61a-c18a-11ec-2775-fb3097d1e835
# ╟─7ebfd66a-c18a-11ec-3366-81907e05ec87
# ╠═7ebfdb1a-c18a-11ec-2f72-8508dcd0d74f
# ╟─7ebfdb38-c18a-11ec-1673-1d0d4cc190a8
# ╠═7ebfdf04-c18a-11ec-0700-6d60a98dc12b
# ╟─7ebfdf3e-c18a-11ec-01bb-ed5398773e75
# ╟─7ebfdf52-c18a-11ec-0db6-6f2069d68205
# ╠═7ebfe20e-c18a-11ec-3f08-014d1b92e39e
# ╟─7ebfe234-c18a-11ec-09b4-1f40c6ee89fa
# ╠═7ebfe6be-c18a-11ec-3b53-23067be460ff
# ╟─7ebfe6de-c18a-11ec-3be6-152254a32e01
# ╠═7ebfe984-c18a-11ec-14c7-23e3937ed8cc
# ╟─7ebfe9a2-c18a-11ec-0178-85f3e8ef4144
# ╠═7ebfee02-c18a-11ec-0931-ffbdf0b13d79
# ╟─7ebfee52-c18a-11ec-3627-4b35ab378f31
# ╟─7ec016c0-c18a-11ec-18bb-6b3619b3ca6f
# ╟─7ec016ea-c18a-11ec-237c-27205bf8788a
# ╟─7ec01706-c18a-11ec-18da-41616c03d627
# ╟─7ec0177c-c18a-11ec-039a-a79c1d3e52e0
# ╟─7ec017a6-c18a-11ec-02b4-019d62170c5b
# ╠═7ec01cbc-c18a-11ec-17c1-7fa2bce06753
# ╟─7ec01ce2-c18a-11ec-3512-8f6f22b18421
# ╟─7ec020ca-c18a-11ec-288a-998b28e81d3d
# ╟─7ec020e8-c18a-11ec-30a9-41b5685aa5dd
# ╟─7ec02106-c18a-11ec-2829-895ec22ae906
# ╟─7ec0212e-c18a-11ec-3d8b-47600feb2f72
# ╟─7ec02142-c18a-11ec-33fd-01f9e99a2c27
# ╠═7ec025a2-c18a-11ec-15d4-93905797b091
# ╟─7ec025c0-c18a-11ec-2767-d1fc20530bb0
# ╟─7ec025e8-c18a-11ec-0c5e-85c2b303f626
# ╠═7ec02a52-c18a-11ec-2518-1d5a637c4c61
# ╟─7ec02a84-c18a-11ec-3ee6-df4709209940
# ╟─7ec03068-c18a-11ec-152c-2788f3e25e18
# ╟─7ec030c4-c18a-11ec-3d54-4160780cd6fc
# ╟─7ec030f6-c18a-11ec-106e-396d3d867cc6
# ╟─7ec0310c-c18a-11ec-344a-a7687bb14d68
# ╠═7ec03646-c18a-11ec-374d-e9082ae14495
# ╟─7ec036a0-c18a-11ec-38b2-5d1ef0b4303f
# ╟─7ec036c8-c18a-11ec-1e55-19ddb2e2e721
# ╟─7ec06062-c18a-11ec-0dd3-cf063bc50ae8
# ╟─7ec0609e-c18a-11ec-19ed-2138e559127f
# ╠═7ec082ea-c18a-11ec-027b-410667e62657
# ╟─7ec08378-c18a-11ec-2927-ed1318432fdf
# ╟─7ec093b6-c18a-11ec-3c76-9b96743acc22
# ╟─7ec09442-c18a-11ec-3f5f-515ca620868f
# ╠═7ec09e92-c18a-11ec-3a58-03cc984573a1
# ╟─7ec0a006-c18a-11ec-3f26-49774dcfa82a
# ╟─7ec0a086-c18a-11ec-1e20-b116d7f6155e
# ╟─7ec0a0e0-c18a-11ec-0084-cdcac81561c6
# ╠═7ec0fb1c-c18a-11ec-3c52-dd15ed1fcc40
# ╟─7ec0fc34-c18a-11ec-2317-b3de24aa3ad8
# ╟─7ec0fc5c-c18a-11ec-0b8c-275c021048d9
# ╠═7ec10292-c18a-11ec-22c5-8543be3c7487
# ╟─7ec102ce-c18a-11ec-32e1-77bc7de42acf
# ╟─7ec102ee-c18a-11ec-39f7-9b0a75d7dbab
# ╠═7ec10850-c18a-11ec-188c-3f3557e66a17
# ╟─7ec108fa-c18a-11ec-1fca-a1d0380cca48
# ╟─7ec1092c-c18a-11ec-1ac6-f395e9354962
# ╟─7ec1099a-c18a-11ec-3734-1fb4bc83a7c8
# ╟─7ec109ae-c18a-11ec-1ba1-c35dc56bbf0b
# ╟─7ec10ad0-c18a-11ec-34bf-8b2149786e3b
# ╟─7ec10b02-c18a-11ec-1a8a-e76d1294a7e8
# ╟─7ec10b52-c18a-11ec-06c5-d1d4c5334e73
# ╟─7ec10b98-c18a-11ec-11b0-c788ce3c0e64
# ╟─7ec10bde-c18a-11ec-3851-556fc1decf60
# ╟─7ec10c1a-c18a-11ec-1ee4-15e1f62b6ba0
# ╟─7ec10c62-c18a-11ec-1470-fb2eb91fe704
# ╟─7ec10c6a-c18a-11ec-3694-bfa361895c63
# ╟─7ec10c88-c18a-11ec-0fbb-615f30ccee72
# ╟─7ec10cba-c18a-11ec-0490-5351d0948659
# ╟─7ec10cce-c18a-11ec-22de-ef37f35be9d3
# ╟─7ec10ce2-c18a-11ec-113b-bd779aa6b8b7
# ╟─7ec10d0a-c18a-11ec-19f4-7d76b83c0542
# ╟─7ec10d3c-c18a-11ec-365f-1fc1c30b9b05
# ╟─7ec10d82-c18a-11ec-0173-49c0edbbae3f
# ╟─7ec10da0-c18a-11ec-2d69-3b4ac57dac7f
# ╟─7ec10dd2-c18a-11ec-193b-fdc8c5aff015
# ╟─7ec10df0-c18a-11ec-3275-859ef5317e22
# ╟─7ec10e04-c18a-11ec-1e8d-abf8903dd81f
# ╟─7ec10e22-c18a-11ec-1673-bf20d091deb5
# ╟─7ec10e36-c18a-11ec-3ba0-8f90800ebdcf
# ╟─7ec10e4a-c18a-11ec-29a6-d1b9014f5791
# ╟─7ec10e5c-c18a-11ec-1b48-4119f5864ff4
# ╟─7ec10e72-c18a-11ec-04ce-3ff0372b7e42
# ╟─7ec10e7c-c18a-11ec-3114-fb67c66b8b40
# ╟─7ec10e8e-c18a-11ec-3be5-29f615e9ac5b
# ╟─7ec10ee0-c18a-11ec-3665-856ebfe0f7d6
# ╟─7ec10efe-c18a-11ec-1f25-97ed7213b327
# ╟─7ec10f26-c18a-11ec-2d3b-e58155abe2e2
# ╟─7ec10f58-c18a-11ec-0420-07665a27e09e
# ╟─7ec10f8a-c18a-11ec-0a75-1d261613311a
# ╟─7ec10f92-c18a-11ec-2412-a9fbf92b8140
# ╟─7ec10fee-c18a-11ec-300a-6f9a095d6708
# ╟─7ec11002-c18a-11ec-2e64-5fe9afaf7179
# ╟─7ec11020-c18a-11ec-070f-1b575088e0d0
# ╟─7ec1103e-c18a-11ec-220c-bbce10572784
# ╟─7ec11052-c18a-11ec-1721-81c60b9efcd7
# ╟─7ec11068-c18a-11ec-1c2a-95c202d70ab1
# ╟─7ec1109a-c18a-11ec-20bb-53a10aadc20d
# ╟─7ec116c4-c18a-11ec-2b43-d93348f33de3
# ╟─7ec11714-c18a-11ec-1fdf-dd2699eb3a42
# ╠═7ec11ef8-c18a-11ec-39c3-c3d0254e8886
# ╟─7ec11f3e-c18a-11ec-0572-0d2f60af5b0f
# ╟─7ec11f52-c18a-11ec-044a-0114a44a0d9f
# ╠═7ec12182-c18a-11ec-1bdb-8765f93ab18e
# ╟─7ec121a0-c18a-11ec-327e-f7acc51d8b24
# ╟─7ec121e6-c18a-11ec-1e4c-eb557172073f
# ╟─7ec1222c-c18a-11ec-2200-6b8e0f62af31
# ╟─7ec12254-c18a-11ec-06d4-f9ba20543efd
# ╟─7ec1227e-c18a-11ec-2fe5-15ebf30471d1
# ╟─7ec122a4-c18a-11ec-085f-69c07fc15632
# ╟─7ec122b8-c18a-11ec-2f21-3582be4123a5
# ╟─7ec122de-c18a-11ec-3396-239d51173145
# ╟─7ec12326-c18a-11ec-173a-5f86008dd302
# ╟─7ec1233a-c18a-11ec-0e60-e73f4ca9b9e7
# ╟─7ec1234e-c18a-11ec-1ac6-e77dabfcaf8b
# ╟─7ec12362-c18a-11ec-0416-fb44b2566776
# ╟─7ec123a8-c18a-11ec-3471-83bdac87be88
# ╟─7ec123bc-c18a-11ec-248d-df741825bedd
# ╟─7ec123d0-c18a-11ec-269f-51862288abfe
# ╟─7ec1240c-c18a-11ec-2bf4-ff8354af3c5c
# ╟─7ec1243e-c18a-11ec-09a4-8708942c598d
# ╟─7ec1248e-c18a-11ec-1081-39b59ceb3ea8
# ╟─7ec124b6-c18a-11ec-3427-b5d27fa3007c
# ╟─7ec124fc-c18a-11ec-04e5-bdc9916cb693
# ╟─7ec12524-c18a-11ec-1ddb-65c3b5ff7557
# ╟─7ec12556-c18a-11ec-0bc1-015627c0ebff
# ╟─7ec12592-c18a-11ec-1154-879e0e34c41e
# ╟─7ec125ba-c18a-11ec-0ed5-a170ed8bf2c6
# ╟─7ec125d8-c18a-11ec-325b-7f1abf13ee47
# ╟─7ec12600-c18a-11ec-35dd-717dd08f2b8b
# ╟─7ec1261e-c18a-11ec-3b1b-235f5c1d3ddc
# ╟─7ec12646-c18a-11ec-31e3-479bf3bda41b
# ╟─7ec12684-c18a-11ec-1759-3f55f7148bfb
# ╟─7ec126a0-c18a-11ec-07c0-2906775e911a
# ╟─7ec126dc-c18a-11ec-12e1-3b5d23792495
# ╟─7ec12748-c18a-11ec-0886-91f2ac5cf5e0
# ╟─7ec1277c-c18a-11ec-32f0-f3ae840a6624
# ╟─7ec127ae-c18a-11ec-1166-754ae0f726ea
# ╟─7ec12812-c18a-11ec-1529-87fea0d89f46
# ╟─7ec12830-c18a-11ec-2311-11708369ee1d
# ╟─7ec12862-c18a-11ec-189b-9d4fb8ba13c1
# ╟─7ec128b0-c18a-11ec-29e1-7b3a85c121ca
# ╟─7ec173f8-c18a-11ec-2347-f34086b1ca75
# ╟─7ec17600-c18a-11ec-39a5-7bd943e0d2f6
# ╟─7ec17696-c18a-11ec-37ef-a38ff36ebf8a
# ╟─7ec176dc-c18a-11ec-2f19-5953331c2695
# ╟─7ec17718-c18a-11ec-2060-6757fe886517
# ╟─7ec17740-c18a-11ec-291c-9944e4584453
# ╟─7ec185b4-c18a-11ec-3405-9308197aee1d
# ╟─7ec18690-c18a-11ec-01b7-650ce2cced11
# ╟─7ec18712-c18a-11ec-3b7d-93f34f6a9143
# ╟─7ec1878a-c18a-11ec-33c0-6f3508aff417
# ╟─7ec187da-c18a-11ec-1436-9f7e3e2d1a55
# ╟─7ec1882a-c18a-11ec-1565-f39604dae337
# ╟─7ec1885c-c18a-11ec-0871-05968dd29f78
# ╟─7ec188de-c18a-11ec-3589-c185d78e1830
# ╟─7ec1893a-c18a-11ec-1e78-1bdd461bc62b
# ╟─7ec18974-c18a-11ec-1cd5-a9d0586fde1a
# ╟─7ec189ba-c18a-11ec-240f-d79db9d0bc6e
# ╟─7ec189f6-c18a-11ec-0f68-cd8356c8720c
# ╟─7ec18a46-c18a-11ec-16b9-3d234db277b3
# ╟─7ec18ac8-c18a-11ec-3557-910faaa0d869
# ╟─7ec18ae6-c18a-11ec-129a-316d0ce25df9
# ╟─7ec18b0e-c18a-11ec-126b-778e858a2808
# ╟─7ec18b2c-c18a-11ec-2c93-0d3d54e537ca
# ╟─7ec18b4a-c18a-11ec-26e1-3540ff7a07fc
# ╟─7ec18b72-c18a-11ec-3212-89af436929b2
# ╟─7ec18b86-c18a-11ec-30c4-67df6b12ce74
# ╟─7ec18bb8-c18a-11ec-09f6-9f26cf0b319c
# ╟─7ec18c0a-c18a-11ec-26c5-3b5865baae92
# ╟─7ec18c26-c18a-11ec-2a48-836ca166e58f
# ╟─7ec18c44-c18a-11ec-3ed0-d1714c34eda3
# ╟─7ec18c62-c18a-11ec-1c37-5ff27e683da9
# ╟─7ec18c94-c18a-11ec-2540-6971e74f69aa
# ╟─7ec18cbc-c18a-11ec-3214-ef548dee5340
# ╟─7ec18ce4-c18a-11ec-2454-f728611aec36
# ╟─7ec18d34-c18a-11ec-1122-c71d02fc276f
# ╟─7ec18d7a-c18a-11ec-2f72-d357c9d15dfb
# ╟─7ec18dde-c18a-11ec-11c2-cf645438a1a4
# ╟─7ec18e04-c18a-11ec-2493-598e5f50ae33
# ╟─7ec1973e-c18a-11ec-1b5e-25c676b1d35c
# ╟─7ec19770-c18a-11ec-12c2-a7c0429a3bc6
# ╟─7ec197b6-c18a-11ec-31c2-2fe02df010c7
# ╟─7ec1a012-c18a-11ec-292c-b9f59354a9bf
# ╟─7ec1a044-c18a-11ec-3a76-45d9e1406114
# ╟─7ec1a094-c18a-11ec-267d-13aca30e40d4
# ╟─7ec1afa8-c18a-11ec-3a98-d9b2733c9d87
# ╟─7ec1afe4-c18a-11ec-3e74-8da776dc3c33
# ╟─7ec1b020-c18a-11ec-2ca5-814ed7e67ac5
# ╟─7ec1b85e-c18a-11ec-3aa2-cdc98adcebce
# ╟─7ec1b886-c18a-11ec-1eec-2b1c5e7987e0
# ╟─7ec1b8b8-c18a-11ec-200f-2df700c6d0e6
# ╟─7ec1c056-c18a-11ec-3989-a5ed1bdc7837
# ╟─7ec1c074-c18a-11ec-05ac-0b28b1dd0224
# ╟─7ec1c088-c18a-11ec-3ff1-fb4d79c88b13
# ╟─7ec1c0ba-c18a-11ec-27ce-5d9889b2628b
# ╟─7ec1ce3e-c18a-11ec-04a5-85f4e6adf155
# ╟─7ec1ce5a-c18a-11ec-1f0f-9b4759323798
# ╟─7ec1ce7a-c18a-11ec-1313-a36c3df9f853
# ╟─7ec1d226-c18a-11ec-3595-0d37a08f5167
# ╟─7ec1d23a-c18a-11ec-1227-b30239585cc4
# ╟─7ec1de38-c18a-11ec-16a9-cb38134ea634
# ╟─7ec1de60-c18a-11ec-25ce-ad8d79e5949d
# ╟─7ec1de76-c18a-11ec-30d4-5d1c5a661f39
# ╟─7ec1e1ee-c18a-11ec-3b1c-375018bff1bb
# ╟─7ec1e20c-c18a-11ec-174c-39a8711734fb
# ╟─7ec1edd8-c18a-11ec-30dd-511c232de15d
# ╟─7ec1edf6-c18a-11ec-3d94-f377a45be4ef
# ╟─7ec1ee1c-c18a-11ec-3573-d1313a02240c
# ╟─7ec1fa60-c18a-11ec-3ba8-9ba8f1ce4aeb
# ╟─7ec1fa80-c18a-11ec-1083-377edc3fd12c
# ╟─7ec1faa8-c18a-11ec-2c71-33446b83f68b
# ╟─7ec205b6-c18a-11ec-2334-6da22a5c1496
# ╟─7ec205d4-c18a-11ec-19f4-df58a2b2e839
# ╟─7ec205fc-c18a-11ec-3c8c-abdf0aef9d94
# ╟─7ec20612-c18a-11ec-082c-712b4112c222
# ╟─7ec2062e-c18a-11ec-2120-2dff3b7da5ed
# ╟─7ec2066a-c18a-11ec-0585-d71ecf91bdf4
# ╟─7ec20e26-c18a-11ec-27d4-2bf58870abbc
# ╟─7ec20e50-c18a-11ec-0fe3-bde82701fd4c
# ╟─7ec20e50-c18a-11ec-0ac2-7ff277a872fb
# ╟─7ec20e58-c18a-11ec-2424-5f5a7cd0bf3d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
