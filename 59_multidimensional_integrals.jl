### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 3b0564fc-c190-11ec-094c-8175f3e1a827
begin
	using CalculusWithJulia
	using Plots
	using QuadGK
	using SymPy
	using HCubature
end

# ╔═╡ 3b056d08-c190-11ec-3dc9-2d519df46694
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 3b1215bc-c190-11ec-27a3-6fcbe18fa4f8
using PlutoUI

# ╔═╡ 3b121594-c190-11ec-0476-43496024f3bf
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 3b054738-c190-11ec-09ee-8fbee92e3a5e
md"""# Multi-dimensional integrals
"""

# ╔═╡ 3b0548e6-c190-11ec-215e-1f02ad877e32
md"""This section uses these add-on packages:
"""

# ╔═╡ 3b056fa6-c190-11ec-27d5-01d404b1225c
md"""---
"""

# ╔═╡ 3b05747e-c190-11ec-114a-0b85faa11668
md"""The definition of the definite integral, $\int_a^b f(x)dx$, is based on Riemann sums.
"""

# ╔═╡ 3b057604-c190-11ec-0ecd-33b903d8f2b9
md"""We review, using a more general form than [previously](../integrals/area.html). Consider a bounded function $f$ over $[a,b]$.  A partition, $P$, is based on $a = x_0 < x_1 < \cdots < x_n = b$. For each subinterval $[x_{i-1}, x_{i}]$ take $m_i(f) = \inf_{u \text{ in } [x_{i-1},x_i]} f(u)$ and $M_i(f) = \sup_{u \text{ in } [x_{i-1},x_i]} f(u)$. (When $f$ is continuous, $m_i$ and $M_i$ are realized at points of $[x_{i-1},x_i]$, though that isn't assumed here. The use of "$\sup$" and "$\inf$" is a mathematically formal means to replace this in general.) Let $\Delta x_i = x_i - x_{i-1}$. Form the sums $m(f, P) = \sum_i m_i(f) \Delta x_i$ and $M(f, P) = \sum_i M_i(f) \Delta x_i$. These are the *lower* and *upper* Riemann sums for a partition. A general Riemann sum would be formed by selecting $c_i$ from $[x_{i-1}, x_i]$ and forming $S(f,P) = \sum f(c_i) \Delta x_i$. It will be the case that $m(f,P) \leq S(f,P) \leq M(f,P)$, as this is true for *each* sub-interval of the partition.
"""

# ╔═╡ 3b057672-c190-11ec-39f6-695a200cffe9
md"""If, as the largest diameter ($\Delta x_i$) of the partition $P$ goes to $0$, the upper and lower sums converge to the same limit, then $f$ is called Riemann integrable over $[a,b]$. If $f$ is Riemann integrable, any Riemann sum will converge to the definite integral as the partitioning shrinks.
"""

# ╔═╡ 3b05769a-c190-11ec-16a7-7345f28b2bfb
md"""Continuous functions are known to be Riemann integrable, as are functions with only finitely many discontinuities, though this isn't the most general case of integrable functions, which will be stated below.
"""

# ╔═╡ 3b0576b8-c190-11ec-33df-3b3ad75b83e2
md"""In practice, we don't typically compute integrals using a limit of a partition, though the approach may provide direction to numeric answers, as the Fundamental Theorem of Calculus relates the definite integral with an antiderivative of the integrand.
"""

# ╔═╡ 3b057776-c190-11ec-1bea-3934f22d0531
md"""The multidimensional case will prove to be similar where a Riemann sum is used to define the value being discussed, but a theorem of Fubini will allow the computation of integrals using the Fundamental Theorem of Calculus.
"""

# ╔═╡ 3b057792-c190-11ec-0674-a7f1608940cf
md"""---
"""

# ╔═╡ 3b057988-c190-11ec-203c-ab6fb2e6dab8
md"""## Integration theory
"""

# ╔═╡ 3b05b3e2-c190-11ec-1152-7585e2e11f94
let
	imgfile = "figures/chrysler-building-in-new-york.jpg"
	caption = """How to estimate the volume contained within the Chrysler Building? One way might be to break the building up into tall vertical blocks based on its skyline;  compute the volume of each block using the formula of volume as area of the base times the height; and, finally, adding up the computed volumes This is the basic idea of finding volumes under surfaces using Riemann integration."""
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 3b05bda8-c190-11ec-306c-a361fa594b82
let
	imgfile ="figures/chrysler-nano-block.png"
	caption = """
	Computing the volume of a nano-block construction of the Chrysler building is easier than trying to find an actual tree at the Chrysler building, as we can easily compute the volume of columns of equal-sized blocks. Riemann sums are similar.
	"""
	
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 3b05bf1a-c190-11ec-1456-89181885f5db
md"""The definition of the  multi-dimensional integral is more involved then the one-dimensional case due to the possibly increased complexity of the region. This will require additional [steps](https://math.okstate.edu/people/lebl/osu4153-s16/chapter10-ver1.pdf). The basic approach is as follows.
"""

# ╔═╡ 3b05c096-c190-11ec-1158-355a43bc2960
md"""First, let $R = [a_1, b_1] \times [a_2, b_2] \times \cdots \times [a_n, b_n]$ be a closed rectangular region. If $n=2$, this is a rectangle, and if $n=3$, a box. We begin by defining integration over closed rectangular regions. For each side, a partition $P_i$ is chosen based on $a_i = x_{i0} < x_{i1} < \cdots < x_{ik} = b_i$. Then a sub-rectangular region would be of the form $R' = P_{1j_1} \times P_{2j_2} \times \cdots \times P_{nj_n}$, where $P_{ij_i}$ is one of the partitioning sub intervals of $[a_i, b_i]$. Set $\Delta R' = \Delta P_{1j_1} \cdot \Delta P_{2j_2} \cdot\cdots\cdot\Delta P_{nj_n}$ to be the $n$-dimensional volume of the sub-rectangular region.
"""

# ╔═╡ 3b05c14a-c190-11ec-38a2-33673d3ac525
md"""For each sub-rectangular region, we can define $m(f,R')$ to be $\inf_{u \text{ in } R'} f(u)$ and $M(f, R') = \sup_{u \text{ in } R'} f(u)$. If we enumerate all the sub-rectangular regions, we can define $m(f, P) = \sum_i m(f, R_i) \Delta R_i$ and $M(f,P) = \sum_i M(f, R_i)\Delta R_i$, as in the one-dimensional case. These are upper and lower sums, and, as before, would bound the Riemann sum formed by choosing any $c_i$ in $R_i$ and computing $S(f,P) = \sum_i f(c_i) \Delta R_i$.
"""

# ╔═╡ 3b05c186-c190-11ec-2e39-054bfe9128b7
md"""As with the one-dimensional case, $f$ is Riemann integrable over $R$ if the limits of $m(f,P)$ and $M(f,P)$ exist and are identical as the diameter of the partition (defined as the largest diameter of each side) goes to $0$. If the limits are equal, then so is the limit of any Riemann sum.
"""

# ╔═╡ 3b05c1ae-c190-11ec-2601-0d204c30a704
md"""When $f$ is Riemann integrable over a rectangular region $R$, we denote the limit by any of:
"""

# ╔═╡ 3b05eb7a-c190-11ec-18e0-41881be595a5
md"""```math
~
\iint_R f(x) dV, \quad \iint_R fdV, \quad \iint_R f(x_1, \dots, x_n) dx_1 \cdot\cdots\cdot dx_n, \quad\iint_R f(\vec{x}) d\vec{x}.
~
```
"""

# ╔═╡ 3b05ec38-c190-11ec-1a7c-dfdd731c6a88
md"""A key fact, requiring proof, is:
"""

# ╔═╡ 3b062324-c190-11ec-0bda-33c1b3bb322a
md"""> Any continuous function, $f$, is Riemann integrable over a closed, bounded rectangular region.

"""

# ╔═╡ 3b0623a6-c190-11ec-20c3-8b6f1d7c5a3f
md"""---
"""

# ╔═╡ 3b062400-c190-11ec-1354-950ba006bc61
md"""As with one-dimensional integrals, from the Riemann sum definition, several familiar properties for integrals follow. Let $V(R)$ be the volume of $R$ found by multiplying the side-lengths together.
"""

# ╔═╡ 3b0647b4-c190-11ec-28e0-cd35af4bfb31
md"""**Constants:**
"""

# ╔═╡ 3b064b74-c190-11ec-3311-3552fbe9db26
md"""  * A constant is Riemann integrable and: $\iint_R c dV = c V(R)$.
"""

# ╔═╡ 3b064ba6-c190-11ec-0ad4-39a52a8766f9
md"""**Linearity:**
"""

# ╔═╡ 3b064c28-c190-11ec-30d5-733eb8a4d9c7
md"""  * For integrable $f$ and $g$ and constants $a$ and $b$:
"""

# ╔═╡ 3b064c5a-c190-11ec-009b-4171a04d484d
md"""```math
~
\iint_R (af(x) + bg(x))dV = a\iint_R f(x)dV + b\iint_R g(x) dV.
~
```
"""

# ╔═╡ 3b064c8c-c190-11ec-3e07-a9b84209d638
md"""**Disjoint:**
"""

# ╔═╡ 3b064d5e-c190-11ec-06b7-3b63abde3267
md"""  * If $R$ and $R'$ are *disjoint* rectangular regions (possibly sharing a boundary), then the integral over the union is defined by linearity:
"""

# ╔═╡ 3b064dfe-c190-11ec-0a08-edc61d2adb03
md"""```math
~
\iint_{R \cup R'} f(x) dV = \iint_R f(x)dV + \iint_{R'} f(x) dV.
~
```
"""

# ╔═╡ 3b064e26-c190-11ec-187f-f500c4f04afe
md"""**Monotonicity:**
"""

# ╔═╡ 3b064e94-c190-11ec-11a6-3f9821f2cc33
md"""  * As $f$ is bounded, let $m \leq f(x) \leq M$ for all $x$ in $R$. Then
"""

# ╔═╡ 3b064eb0-c190-11ec-02b7-492eb1af086b
md"""```math
~
m V(R) \leq \iint_R f(x) dV \leq MV(R).
~
```
"""

# ╔═╡ 3b065018-c190-11ec-2733-0bbc744218ad
md"""  * If $f$ and $g$ are integrable *and* $f(x) \leq g(x)$, then the integrals have the same property, namely $\iint_R f dV \leq \iint_R gdV$.
  * If $S \subset R$, both closed rectangles, then if $f$ is integrable over $R$ it will be also over $S$ and, when $f\geq 0$, $\iint_S f dV \leq \iint_R fdV$.
"""

# ╔═╡ 3b065038-c190-11ec-3e2c-29b10a899417
md"""**Triangle inequality:**
"""

# ╔═╡ 3b065100-c190-11ec-2414-33cb37259ba9
md"""  * If $f$ is bounded and integrable, then $|\iint_R fdV| \leq \iint_R |f| dV$.
"""

# ╔═╡ 3b06536c-c190-11ec-0660-e5a8ac074bab
md"""### HCubature
"""

# ╔═╡ 3b0653e4-c190-11ec-3e4d-a1017dcb3240
md"""To numerically compute multidimensional integrals over rectangular regions in `Julia` is  efficiently done with the `HCubature` package. The `hcubature` function is defined for $n$-dimensional integrals, so the integrand is specified through a function which takes a vector as an input. The region to integrate over is of rectangular form. It is specified by a tuple of left endpoints and a tuple of right endpoints. The order is in terms of the order of the vector.
"""

# ╔═╡ 3b065498-c190-11ec-3ffe-a7d6133e8012
md"""To elaborate, if we think of $f(\vec{x}) = f(x_1, x_2, \dots, x_n)$ and we are integrating over $[a_1, b_1] \times \cdots \times [a_n, b_n]$, then the region would be specified through two tuples: `(a1, a2, ..., an)` and `(b1, b2, ..., bn)`.
"""

# ╔═╡ 3b065538-c190-11ec-3594-d701cb3145e1
md"""To illustrate, to integrate the function $f(x,y) = x^2 + 5y^2$ over the region $[0,1] \times [0,2]$ using `HCubature`'s `hcubature` function, we would proceed as follows:
"""

# ╔═╡ 3b066c94-c190-11ec-28a2-8599510c8afd
let
	f(x,y) = x^2 + 5y^2
	f(v) = f(v...)  # f accepts a vector
	a0, b0 = 0, 1
	a1, b1 = 0, 2
	hcubature(f, (a0, a1), (b0, b1))
end

# ╔═╡ 3b066d02-c190-11ec-11d5-5767116940c4
md"""The computed value and a worst case estimate for the error is returned, in a manner similar to the `quadgk` function (from the `QuadGK` package) used previously for one-dimensional numeric integrals.
"""

# ╔═╡ 3b066d3c-c190-11ec-1bce-e18a34f927f8
md"""The order above is `x` then `y`, which is clear from the first definition of `f` and as belabored in the tuples passed to `hcubature`. A more convenient use is to just put the constants into the function call, as in `hcubature(f, (0,0), (1,2))`.
"""

# ╔═╡ 3b066e60-c190-11ec-3f76-ed81c6e631ed
md"""##### Example
"""

# ╔═╡ 3b066e7e-c190-11ec-06fc-4b063d451250
md"""Let's verify the numeric approach works for figures where an answer is known from the geometry of the problem.
"""

# ╔═╡ 3b066f3c-c190-11ec-0ccc-db7907c4e5d5
md"""  * A constant function $c=f(x,y)$. In this case, the volume is simply a box, so the volume will come from multiplying the three dimensions. Here is an example:
"""

# ╔═╡ 3b0677ac-c190-11ec-3e5e-1fec01cd4a97
let
	f(x,y) = 3
	f(v) = f(v...)
	a0, b0 = 0, 4
	a1, b1 = 0, 5  # R is area 20, so V = 60 = 3 ⋅ 20
	hcubature(f, (a0, a1), (b0, b1))
end

# ╔═╡ 3b067892-c190-11ec-3c28-5f729c02aa4e
md"""  * A wedge. Let $f(x,y) = x$ and $R= [0,1] \times [0,1]$. The the volume is a wedge, and should be half the value of the unit cube, or simply $1/2$:
"""

# ╔═╡ 3b06801c-c190-11ec-2eb9-459d4ed5dbdc
let
	f(x,y) = x
	f(v) = f(v...)
	a0, b0 = 0, 1
	a1, b1 = 0, 1
	hcubature(f, (a0, a1), (b0, b1))
end

# ╔═╡ 3b0684cc-c190-11ec-244e-7b673c41c81d
md"""  * The volume of a right square pyramid is $V=(1/3)a^2 h$, or a third of an enclosing box. We computed this area previously using the method of [slices](../integrals/volumes_slice.html). Here we do it thinking of the pyramid as the volume formed by the surface over the region $[-a,a] \times [-a,a]$ generated by $f(x,y) = h \cdot (l(x,y) - d(x,y))/l(x,y)$ where $d(x,y)$ is the distance to the origin, or $\sqrt{x^2 + y^2}$ and $l(x,y)$ is the length of the line segment from the origin to the boundary of $R$ that goes through $(x,y)$.
"""

# ╔═╡ 3b068544-c190-11ec-2ec9-c78d351b27aa
md"""Identifying a formula for this is a bit tricky. Here we use a brute force approach; later we will simplify this. Using polar coordinates, we know $r\cos(\theta) = a$ describes the line $x=a$ and $r\sin(\theta)=a$ describes the line $y=a$. Using the square, we have to alternate between these depending on where $\theta$ is (e.g., between $-\pi/4$ and $\pi/4$ it would be $r\cos(\theta)=a$ or $a/\cos(\theta)$ is $l(x,y)$. We write a function for this:
"""

# ╔═╡ 3b06e112-c190-11ec-1729-27341e2eb63c
begin
	𝒅(x, y)  = sqrt(x^2 + y^2)
	function 𝒍(x, y, a)
	    theta = atan(y,x)
	    atheta = abs(theta)
	    if (pi/4 <= atheta < 3pi/4) # this is the y=a or y=-a case
	        (a/2)/sin(atheta)
	    else
	        (a/2)/abs(cos(atheta))
	    end
	end
end

# ╔═╡ 3b06e1ba-c190-11ec-2e8a-5567f8cdf307
md"""And then
"""

# ╔═╡ 3b06f8d0-c190-11ec-0b36-43a0abcf6150
begin
	𝒇(x,y,a,h) = h * (𝒍(x,y,a) - 𝒅(x,y))/𝒍(x,y,a)
	𝒂, 𝒉 = 2, 3
	𝒇(x,y) = 𝒇(x, y, 𝒂, 𝒉)   # fix a and h
	𝒇(v) = 𝒇(v...)
end

# ╔═╡ 3b06f90c-c190-11ec-104c-55efc195a162
md"""We can visualize the volume to be computed, as follows:
"""

# ╔═╡ 3b07094c-c190-11ec-0058-bf5f44fdeb98
let
	xs = ys = range(-1, 1, length=20)
	surface(xs, ys, 𝒇)
end

# ╔═╡ 3b070988-c190-11ec-2284-9730ee1ef594
md"""Trying this, we have:
"""

# ╔═╡ 3b0742ae-c190-11ec-01ad-b139261736be
hcubature(𝒇, (-𝒂/2, -𝒂/2), (𝒂/2, 𝒂/2))

# ╔═╡ 3b0744c0-c190-11ec-12e1-67fd22c6785e
md"""The answer agrees with that known from the  formula, $4 = (1/3)a^2 h$, but the answer takes a long time to be produce. The `hcubature` function is  slow with functions defined in terms of conditions. For this problem, volumes by [slicing](../integrals/volumes_slice.html) is more direct. But also symmetry can be used, were we able to compute the volume above the triangular region formed by the $x$-axis, the line $x=a/2$ and the line $y=x$, which would be $1/8$th the total volume. (As then $l(x,y,a) = (a/2)/\sin(\tan^{-1}(y,x))$.).
"""

# ╔═╡ 3b074650-c190-11ec-1ad4-d321d60c3814
md"""  * The volume of a sphere is $4/3 \pi r^3$. We could verify this by integrating $z = f(x,y) = \sqrt{r^2 - (x^2 + y^2)}$ over $R = \{(x,y): x^2 + y^2 \leq r^2\}$. *However*, this is not a *rectangular* region, so we couldn't directly proceed.
"""

# ╔═╡ 3b074682-c190-11ec-0350-8ff9858a7c72
md"""We might try integrating a function with a condition:
"""

# ╔═╡ 3b076216-c190-11ec-0280-97b24ae8417a
md"""**But** `hcubature` is **very** slow to integrate such functions. We will see our instincts are good – this is the approach taken to discuss integrals over general regions – but this is not practical here. There are two alternative approaches to be discussed: approach the integral *iteratively*  or *transform* the circular region into a rectangular region and integrate. Before doing so, we discuss how the integral is developed for more general regions.
"""

# ╔═╡ 3b0777da-c190-11ec-163e-57c3355fc2d8
note("""
The approach above takes a nice smooth function and makes it non smooth at the boundary. In general this is not a good idea for numeric solutions, as many algorithms work better with assumptions of smoothness.
""")

# ╔═╡ 3b07864a-c190-11ec-17a3-f9e4b4bbe29f
note("""
The `Quadrature` package provides a uniform interface for `QuadGK`, `HCubature`, and other numeric integration routines available in `Julia`.""")

# ╔═╡ 3b0786a6-c190-11ec-0a0f-b1b7c43b6257
md"""## Integrals over more general regions
"""

# ╔═╡ 3b0786ee-c190-11ec-0ce5-235b9b4dae2e
md"""To proceed further, it is necessary to discuss certain types of sets that will be used to describe the boundaries of regions that can be integrated over, though we don't dig into the details.
"""

# ╔═╡ 3b0787a0-c190-11ec-101f-a9d9bcd9dfde
md"""Let the *measure* of a rectangular region be its volume and for any subset of $S \subset R^n$, define the *outer* measure of $S$ by $m^*(S) = \inf\sum_{j=1}^\infty V(R_j)$ where the infimum is taken over all closed, countable, rectangles with $S \subset \cup_{j=1}^\infty R_j$.
"""

# ╔═╡ 3b0787f0-c190-11ec-3f7d-b5da2390063d
md"""In two dimensions, if $S$ is viewed on a grid, then this would be *area* of the smallest collection of cells that contain any part of $S$. This is the smallest this value takes as the grid becomes infinite.
"""

# ╔═╡ 3b078818-c190-11ec-18bd-655e41bb1053
md"""For the following graph, there are $100$ cells each of area $8/100$. Their are 58 cells covering the curve and its interior. So the outer measure is less than $58\cdot 8/100$, as this is just one possible covering.
"""

# ╔═╡ 3b07b414-c190-11ec-2934-d906f17132e7
let
	function cassini(theta)
	    a, b = .75, 1
	    A = 1; B = -2a^2*cos(2theta)
	    C = a^4 - b^4
	    (-B - sqrt(B^2 - 4*A*C))/(2A)
	end
	
	polar_plot(r, a, b) = plot(t -> r(t)*cos(t), t->r(t)*sin(t), a, b, legend=false, linewidth=3)
	p = polar_plot(cassini, 0, 8pi)
	n=10
	a1,b1 = -1, 1
	a2, b2 = -2, 2
	for a in range(a1, b1, length=n+1)
	    for b in range(a2, b2, length=n+1)
	        plot!(p, [a,a],[a2, b2], alpha=0.75)
	        plot!(p, [a1,b1],[b,b], alpha=0.75)
	    end
	end
	p
end

# ╔═╡ 3b07b482-c190-11ec-05bf-b9cc87ed321f
md"""A set has measure $0$ if the outer measure is $0$. An alternate definition, among other characterizations, is a set has measure $0$ if for any $\epsilon > 0$ there exists rectangular regions $R_1, R_2, \dots, R_n$ (for some $n$) with $\sum V(R_i) < \epsilon$. Measure zero sets have many properties not discussed here.
"""

# ╔═╡ 3b07b4ee-c190-11ec-3451-adebb0930d3c
md"""For now, let's see that graph of $y=f(x)$ over $[a,b]$, as a two dimensional set, has measure zero when $f(x)$ has a bounded derivative ($|f'|$ bounded by $M$). Fix some $\epsilon>0$. Take $n$ with $2M(b-a)^2/n < \epsilon$, then divide $[a,b]$ into $n$ equal length intervals (of length $\delta = (b-a)/n)$. For each interval, we consider the box $[a_i, b_i] \times [f(a_i)-\delta M, f(a_i) + \delta M]$. By the mean value theorem, we have $|f(x) - f(a_i)| \leq |b_i-a_i|M$ so $f(a_i) - \delta M \leq f(x) \leq f(a_i) + \delta M$, so the curve will stay in the boxes. These boxes have total area $n \cdot \delta \cdot 2\delta M = 2M(b-a)^2/n$, an area less than $\epsilon$.
"""

# ╔═╡ 3b07b50e-c190-11ec-0a65-fb73e31a5645
md"""The above can be extended to any graph of a continuous function over $[a,b]$.
"""

# ╔═╡ 3b07b540-c190-11ec-3f3b-2b5bcd896667
md"""For a function $f$ the set of discontinuities in $R$ is all points where $f$ is not continuous. A formal definition is often given in terms of oscillation. Let $o(f, \vec{x}, \delta) = \sup_{\{\vec{y} : \| \vec{y}-\vec{x}\| < \delta\}}f(\vec{y}) - \inf_{\{\vec{y}: \|\vec{y}-\vec{x}\|<\delta\}}f(\vec{y})$. A function is discontinuous at $\vec{x}$ if the limit as $\delta \rightarrow 0+$ (which must exist) is not $0$.
"""

# ╔═╡ 3b07b554-c190-11ec-121b-d7cbe0dc26af
md"""With this, we can state the Riemann-Lebesgue theorem on integrable functions:
"""

# ╔═╡ 3b07b66c-c190-11ec-027e-776649e3bce0
md"""> Let $R$ be a closed, rectangular region, and $f:R^n \rightarrow R$ a bounded function. Then $f$ is Riemann integrable over $R$ if and only if the set of discontinuities is a set of measure $0$.

"""

# ╔═╡ 3b07b6fa-c190-11ec-2d6d-b7b0722a5ad2
md"""It was said at the outset we would generalize the regions we can integrate over, but this theorem generalizes the functions. We can tie the two together as follows. Define the integral over any *bounded* set $S$ with boundary of measure $0$. Bounded means $S$ is contained in some bounded rectangle $R$. Let $f$ be defined on $S$ and extend it to be $0$ on points in $R$ that are not in $S$. If this extended function is integrable over $R$, then we can define the integral over $S$ in terms of that. This is why the *boundary* of $S$ must have measure zero, as in general it is among the set of discontinuities of the extend function $f$. Such regions are also called Jordan regions.
"""

# ╔═╡ 3b07b716-c190-11ec-009a-1398eb1e128e
md"""## Fubini's theorem
"""

# ╔═╡ 3b07b72c-c190-11ec-169e-6d089c0d8068
md"""Consider again this figure
"""

# ╔═╡ 3b07d53e-c190-11ec-29d3-2fa2f619a5af
let
	function cassini(theta)
	    a, b = .75, 1
	    A = 1; B = -2a^2*cos(2theta)
	    C = a^4 - b^4
	    (-B - sqrt(B^2 - 4*A*C))/(2A)
	end
	
	polar_plot(r, a, b) = plot(t -> r(t)*cos(t), t->r(t)*sin(t), a, b, legend=false, linewidth=3)
	p = polar_plot(cassini, 0, 8pi)
	n=10
	a1,b1 = -1, 1
	a2, b2 = -2, 2
	for a in range(a1, b1, length=n+1)
	    for b in range(a2, b2, length=n+1)
	        plot!(p, [a,a],[a2, b2], alpha=0.75)
	        plot!(p, [a1,b1],[b,b], alpha=0.75)
	    end
	end
	p
end

# ╔═╡ 3b07d606-c190-11ec-1722-ed0e63b40308
md"""Let $C_i$ enumerate all the cells shown,  assume $f$ is extended to be $0$ outside the region,  and let $c_i$ be a point in the cell. Then the Riemann sum $\sum_i f(c_i) V(C_i)$ can be visualized three identical ways:
"""

# ╔═╡ 3b07d74e-c190-11ec-2976-effcc41b4c45
md"""  * as a linear sum over the indices $i$, as written, leading to $\iint_R f(x) dV$.
  * by indexing the cells by row ($i$) and column ($j$) and summing as $\sum_i (\sum_j f(x_{ij}, y_{ij}) \Delta y_j) \Delta x_i$.
  * by indexing the cells by row ($i$) and column ($j$) and summing as $\sum_j (\sum_i f(x_{ij}, y_{ij}) \Delta x_i) \Delta y_j$.
"""

# ╔═╡ 3b07d796-c190-11ec-3447-bff77b6d4748
md"""The last two suggest that their limit will be *iterated* integrals of the form $\int_{-1}^1 (\int_{-2}^2 f(x,y) dy) dx$ and $\int_{-2}^2 (\int_{-1}^1 f(x,y) dx) dy$.
"""

# ╔═╡ 3b07d7c8-c190-11ec-3743-ad129381b3fe
md"""By "iterated" we mean performing two different definite integrals. For example, to compute $\int_{-1}^1 (\int_{-2}^2 f(x,y) dy) dx$ the first task would be to compute $I(x) =  \int_{-2}^2 f(x,y) dy$. Like partial derivatives, this integrates in $y$ while treating $x$ as a constant. Once the interior integral is computed, then the integral $\int_{-1}^1 I(x) dx$ would be computed to find the answer.
"""

# ╔═╡ 3b07d840-c190-11ec-2dd3-51168a64b06b
md"""The question then: under what conditions will the three integrals be equal?
"""

# ╔═╡ 3b07d94e-c190-11ec-31ca-69ca258cc7be
md"""> [Fubini](https://math.okstate.edu/people/lebl/osu4153-s16/chapter10-ver1.pdf). Let $R \times S$ be a closed rectangular region in $R^n \times R^m$. Suppose $f$ is bounded. Define $f_x(y) = f(x,y)$ and $f^y(x) = f(x,y)$ where $x$ is in $R^n$ and $y$ in $R^m$.  *If* $f_x$ and $f^y$ are integrable then $~ \iint_{R\times S}fdV = \iint_R \left(\iint_S f_x(y) dy\right) dx = \iint_S \left(\iint_R f^y(x) dx\right) dy. ~$

"""

# ╔═╡ 3b07d976-c190-11ec-232c-3bbe6d02100e
md"""Similarly, if $f^y$ is integrable for all $y$, then $\iint_{R\times S}fdV =\iint_S \iint_R f(x,y) dx dy$.
"""

# ╔═╡ 3b07d99e-c190-11ec-2437-c9350879f4ba
md"""An immediate corollary is that the above holds for continuous functions when $R$ and $S$ are bounded, the case described here.
"""

# ╔═╡ 3b07d9e4-c190-11ec-2ef0-4da9afa97a00
md"""The case of continuous functions was known to [Euler](https://en.wikipedia.org/wiki/Fubini%27s_theorem#History), Lebesgue (1904) discussed bounded functions, as in our statement, and Fubini and Tonnelli (1907 and 1909) generalized the statement to more general functions than continuous functions, thereby earning naming rights.
"""

# ╔═╡ 3b07da66-c190-11ec-0ed5-bd57d2183481
md"""In [Ferzola](https://doi.org/10.2307/2687130) we can read a summary of Euler's thinking of 1769 when trying to understand the integral of a function $f(x,y)$ over a bounded domain $R$ enclosed by arcs in the $x$-$y$ plane. (That is, the area below $g(x)$ and above $h(x)$ over the interval $[a,b]$.) Euler wrote the answer as $\int_a^b dx (\int_{g(x)}^{h(x)} f(x,y)dy)$. Ferzola writes that Euler saw this integral yielding a *volume* as the integral $\int_{g(x)}^{h(x)} f(x,y)dy$ gives the area of a slice (parallel to the $y$ axis) and integrating in $x$ adds these slices to give a volume. This is the typical usage of Fubini's theorem today.
"""

# ╔═╡ 3b07e1e6-c190-11ec-1201-b7c00256b90e
let
	imgfile ="figures/strang-slicing.png"
	caption = L"""Figure 14.2 of Strang illustrating the slice when either $x$ is fixed or $y$ is fixed. The inner integral computes the shared area, the outer integral adds the areas up to compute volume."""
	
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 3b07e24a-c190-11ec-3f60-cbd8e966e7e5
md"""In [Volumes](../integrals/volumes_slice.html) the formula for a volume with a known cross-sectional area is given by $V = \int_a^b CA(x) dx$. The inner integral, $\int_{R_x} f(x,y) dy$ is a function depending on $x$ that yields the area of the slice (where $R_x$ is the region sliced by the line of constant $x$ value). This is consistent with Euler's view of the iterated integral.
"""

# ╔═╡ 3b07e2d6-c190-11ec-3e40-532fa88c996d
md"""A domain, as described above, is known as a [normal](https://en.wikipedia.org/wiki/Multiple_integral#Normal_domains_on_R2) domain. Using Fubini's theorem to integrate iteratively, employing the fundamental theorem of calculus at each step, is the standard approach.
"""

# ╔═╡ 3b07e300-c190-11ec-2c28-2786c61fbfe3
md"""For example, we return to the problem of a square pyramid, only now using symmetry, we integrate only over the triangular region between $0 \leq x \leq a/2$ and $0 \leq y \leq x$. The answer is then (the $8$ by symmetry)
"""

# ╔═╡ 3b07e34e-c190-11ec-30cf-b57300a54158
md"""```math
~
V = 8 \int_0^{a/2} \int_0^x h(l(x,y) - d(x,y))/l(x,y) dy dx.
~
```
"""

# ╔═╡ 3b07e376-c190-11ec-1f97-13760572b4f8
md"""But, using similar triangles, we have $d/x = l/(a/2)$ so $(l-d)/l = 1 - 2x/a$. Continuing, our answer becomes
"""

# ╔═╡ 3b07e38a-c190-11ec-3694-8558cbedb342
md"""```math
~
V = 8 \int_0^{a/2} (\int_0^x h(1-\frac{2x}{a}) dy) dx =
8 \int_0^{a/2} (h(1-2x/a) \cdot x) dx =
8 (hx^2_2 \big\lvert_{0}^{a/2} - \frac{2}{a}\frac{x^3}{3}\big\lvert_0^{a/2})=
8 h(\frac{a^2}{8} - \frac{2}{24}a^2) = \frac{a^2h}{3}.
~
```
"""

# ╔═╡ 3b07e3da-c190-11ec-09bb-1718d1a47a2b
md"""### `SymPy`'s `integrate`
"""

# ╔═╡ 3b07e420-c190-11ec-0f8d-857cce01a7df
md"""The `integrate` function of `SymPy` uses various algorithms to symbolically integrate definite (and indefinite) integrals. In the section on [integrals](../integrals/ftc.html) its use for one-dimensional integrals was shown. For multi-dimensional integrals the usage is similar, the syntax following, somewhat, the Fubini-like notation.
"""

# ╔═╡ 3b07e436-c190-11ec-06f8-a34a29831e6e
md"""For example, to perform the integral
"""

# ╔═╡ 3b07e448-c190-11ec-1065-3daa53a1bb19
md"""```math
~
\int_a^b \int_{h(x)}^{g(x)} f(x,y) dy dx
~
```
"""

# ╔═╡ 3b07e468-c190-11ec-397c-e32aa3a6795f
md"""the call would look like:
"""

# ╔═╡ 3b07e4a2-c190-11ec-0834-7bcc46e01ae3
md"""```
integrate(f(x,y), (y, h(x), g(x)), (x, a, b))
```"""

# ╔═╡ 3b07e4f2-c190-11ec-3517-d9f8067882cb
md"""That is, the variable to integrate and the endpoints are passed as tuples. (Unlike `hcubature` which always uses two tuples to specify the bounds, `integrate` uses $n$ tuples to specify an $n$-dimensional integral.) The iteration happens from left to write, so in the above the `y` integral is done (and, as seen, may depend on the variable `x`) and then the `x` integral is performed. The above uses `f(x,y)`, `h(x)` and `g(x)`, but these may be simple symbolic expressions and not function calls using symbolic variables.
"""

# ╔═╡ 3b07e51a-c190-11ec-060b-bf84531563fd
md"""We define `x` and `y` below for use throughout:
"""

# ╔═╡ 3b08081a-c190-11ec-3056-17d91529ba23
@syms x::real y::real z::real

# ╔═╡ 3b076040-c190-11ec-1683-3b93a7abb61a
let
	function f(x,y, r)
	    if x^2 + y^2 < r
	        sqrt(z - x^2 + y^2)
	    else
	        0.0
	    end
	end
end

# ╔═╡ 3b080890-c190-11ec-2d82-93ac9869cf4c
md"""##### Example
"""

# ╔═╡ 3b0808b0-c190-11ec-3983-4be4fe8a3486
md"""For example, the last integral to compute the volume of a square pyramid, could be computed through
"""

# ╔═╡ 3b082b74-c190-11ec-26cd-a534a444d969
let
	@syms a height
	8 * integrate(height * (1 - 2x/a), (y, 0, x), (x, 0, a/2))
end

# ╔═╡ 3b082bc6-c190-11ec-2771-07fcbf4d843e
md"""##### Example
"""

# ╔═╡ 3b082c0a-c190-11ec-0042-97fc511aa114
md"""Find the integral $\int_0^1\int_{y^2}^1 y \sin(x^2) dx dy$.
"""

# ╔═╡ 3b082c1e-c190-11ec-0313-b74415446ca7
md"""Without concerning ourselves with what or why, we just translate:
"""

# ╔═╡ 3b083aec-c190-11ec-20e4-393376b55c08
let
	integrate( y * sin(x^2), (x, y^2, 1), (y, 0, 1))
end

# ╔═╡ 3b083b3a-c190-11ec-18df-05800ee45af0
md"""##### Example
"""

# ╔═╡ 3b083c18-c190-11ec-12a0-3128c7492d9e
md"""Find the volume enclosed by $y = x^2$, $y = 5$, $z = x^2$, and $z = 0$.
"""

# ╔═╡ 3b083c68-c190-11ec-0368-f3a13679a1a8
md"""The limits on $z$ say this is the volume under the surface $f(x,y) = x^2$, over the region defined by $y=5$ and $y = x^2$. The region is a parabola with $y$ running from $x^2$ to $5$, while $x$ ranges from $-\sqrt{5}$ to $\sqrt{5}$.
"""

# ╔═╡ 3b08441c-c190-11ec-1d2c-79ee917fc86d
let
	f(x, y) = x^2
	h(x) = x^2
	g(x) = 5
	integrate(f(x,y), (y, h(x), g(x)), (x, -sqrt(Sym(5)), sqrt(Sym(5))))
end

# ╔═╡ 3b084456-c190-11ec-279a-f743fadb09ca
md"""##### Example
"""

# ╔═╡ 3b08465e-c190-11ec-3b65-cb78ef6fc55e
md"""Find the volume above the $x$-$y$ plane when a cylinder, $x^2 + y^2 = 2^2$ is intersected by a plane $3x + 4y + 5z = 6$.
"""

# ╔═╡ 3b084690-c190-11ec-3fc1-37064419461e
md"""We solve for $z = (1/5)\cdot(6 - 3x - 4y)$ and take $R$ as the disk at the origin of radius $2$:
"""

# ╔═╡ 3b0850d6-c190-11ec-3884-eb647d1b89cd
let
	f(x,y) = 6 - 3x - 4y
	g(x) = sqrt(2^2 - x^2)
	h(x) = -sqrt(2^2 - x^2)
	(1//5) * integrate(f(x,y), (y, h(x), g(x)), (x, -2, 2))
end

# ╔═╡ 3b085108-c190-11ec-1889-e330cda37633
md"""##### Example
"""

# ╔═╡ 3b08514e-c190-11ec-3106-f51b27c7b474
md"""Find the volume:
"""

# ╔═╡ 3b08525a-c190-11ec-1f71-abbec498ba62
md"""  * in the first octant
  * bounded by $x+y+z = 10$, $2x + 3y = 20$, and $x + 3y = 10$
"""

# ╔═╡ 3b08528c-c190-11ec-1ddb-fd961fcdb24b
md"""The first plane can be expressed as $z = f(x,y) = 10 - x - y$ and the volume is that below the surface of $f$ over the region $R$ formed by the two lines and the $x$ and $y$ axes. Plotting that we have:
"""

# ╔═╡ 3b087660-c190-11ec-1049-87244cc1718c
let
	g1(x) = (20 - 2x)/3
	g2(x) = (10 - x)/3
	plot(g1, 0, 20)
	plot!(g2, 0, 20)
end

# ╔═╡ 3b0876c4-c190-11ec-1c16-23c26dd89372
md"""We see the intersection is when $x=10$, so this becomes
"""

# ╔═╡ 3b087f68-c190-11ec-27c3-3bd13979e5d8
let
	f(x,y) = 10 - x - y
	h(x) = (10 - x)/3
	g(x) = (20 - 3x)/3
	integrate(f(x,y), (y, h(x), g(x)), (x, 0, 10))
end

# ╔═╡ 3b087fb6-c190-11ec-0957-ab6e65bb2ee0
md"""##### Example
"""

# ╔═╡ 3b088092-c190-11ec-32b0-8bcea673866e
md"""Let $r=1$ and define three cylinders along the $x$, $y$, and $z$ axes by: $y^2+z^2 = r^2$, $x^2 + z^2 = r^2$, and $x^2 + y^2 = r^2$. What is the enclosed [volume](http://mathworld.wolfram.com/SteinmetzSolid.html)?
"""

# ╔═╡ 3b0880c4-c190-11ec-0734-15fb22e10195
md"""Using the cylinder along the $z$ axis, we have the volume sits above and below the disk $R = x^2 + y^2 \leq r^2$. By symmetry, we can double the volume that sits above the disk to answer the question.
"""

# ╔═╡ 3b0880fe-c190-11ec-2917-b50fe5e1b612
md"""Using symmetry, we can tell that the the wedge between $x=0$, $y=x$, and $x^2 + y^2 \leq 1$ (corresponding to a polar angle in $[0,\pi/4]$ in $R$ contains $1/8$ the volume of the top, so $1/16$ of the total.
"""

# ╔═╡ 3b0887b8-c190-11ec-07c2-c9eff612af87
let
	rad(theta) = 1
	plot(t -> rad(t)*cos(t), t -> rad(t)*sin(t), 0, pi/4, legend=false, linewidth=3)
	plot!([0,cos(pi/4)], [0, sin(pi/4)], linewidth=3)
	plot!([0, 1], [0, 0], linewidth=3)
	plot!([cos(pi/4), cos(pi/4)], [0, sin(pi/4)], linewidth=3)
end

# ╔═╡ 3b08881c-c190-11ec-33ac-5db5019a8c2e
md"""Over this wedge the height is given by the cylinder along the $y$ axis, $x^2 + z^2 = r^2$. We *could*  break this wedge into a triangle and a semicircle to integrate piece by piece. However, from the figure we can integrate in the $y$ direction on the outside, and use only one intergral:
"""

# ╔═╡ 3b088e70-c190-11ec-32b9-7febae5b6e42
let
	r = 1 # if using r as a symbolic variable specify `positive=true`
	f(x,y) = sqrt(r^2 - x^2)
	16 * integrate(f(x,y), (x, y, sqrt(r^2-y^2)), (y, 0, r*cos(PI/4)))
end

# ╔═╡ 3b088f0e-c190-11ec-3172-1fc90f0e997c
md"""##### Example
"""

# ╔═╡ 3b088f60-c190-11ec-1c4e-33357cb3bad2
md"""Find the volume under $f(x,y) = xy$ in the cone swept out by $r(\theta) = 1$ as $\theta$ goes between $[0, \pi/4]$.
"""

# ╔═╡ 3b088f92-c190-11ec-18e5-558580d5b246
md"""The region $R$, the same as the last one. As seen, it can be described in two pieces as a function of $x$, but needs only $1$ as a function of $y$, so we use that below:
"""

# ╔═╡ 3b0895c8-c190-11ec-2a5e-d3d15852e598
let
	f(x,y) = x*y
	g(y) = sqrt(1 - y^2)
	h(y) = y
	integrate(f(x,y), (x, h(y), g(y)), (y, 0, sin(PI/4)))
end

# ╔═╡ 3b0895f0-c190-11ec-3d57-fb4cddab3707
md"""##### Example: Average value
"""

# ╔═╡ 3b0896a4-c190-11ec-39c4-3d7359c4e787
md"""The average value of a function, $f(x,y)$, over a region $R$ is the integral of $f$ over $R$ divided by the area of $R$. It can be computed through two integrals, as below.
"""

# ╔═╡ 3b0896cc-c190-11ec-04a3-75f031ca335d
md"""let $R$ be the region in the first quadrant bounded by $x - y = 0$ and $f(x,y) = x^2 + y^2$. Find the average value.
"""

# ╔═╡ 3b08c5ca-c190-11ec-2ee0-e7e4ccedd310
let
	f(x,y) = x^2 + y^2
	g(x) = x  # solve x - y = 0 for y
	h(x) = 0
	A = integrate(f(x,y), (y, h(x), g(x)), (x, 0, 1))
	B = integrate(Sym(1), (y, h(x), g(x)), (x, 0, 1))
	A/B
end

# ╔═╡ 3b08c69c-c190-11ec-3e1a-8b3447aaeb88
md"""(We integrate `Sym(1)` and not just `1`, as we either need to have a symbolic value for the first argument or use the `sympy.integrate` method directly.)
"""

# ╔═╡ 3b08c6ce-c190-11ec-3788-2b7c141894c6
md"""##### Example: Density
"""

# ╔═╡ 3b08c7be-c190-11ec-0295-758f437c8d1a
md"""The area of a region $R$ can be computed by $\iint_R 1 dA$. If the region is physical, say a disc, then its mass can be of interest. If the mass is uniform with density $\rho$, then the mass would be $\iint_R \rho dA$. If the mass is non uniform, say it is a function $\rho(x,y)$, then the integral to find the mass becomes $\iint_R \rho(x,y) dA$. (In a Riemann sum, the term $\rho(c_{ij}) \Delta x_i\Delta y_j$ would be the mass of a constant-density solid, the integral just adds these up to find total mass.)
"""

# ╔═╡ 3b08c7f0-c190-11ec-21ac-31daada5dccd
md"""Find the mass of a disc bounded by the two parabolas $y=2 - x^2$ and $y = -3 + 2x^2$ with density function given by $\rho(x,y) = x^2y^2$.
"""

# ╔═╡ 3b08c818-c190-11ec-0382-7f8e64c0724e
md"""First we need the intersection points of the two parabolas. Solving $2-x^2 = -3 + 2x^2$ for $x$ yields: $5 = x^2$.
"""

# ╔═╡ 3b08c82e-c190-11ec-3d00-a7f39db956e1
md"""So we get a mass of:
"""

# ╔═╡ 3b08d3bc-c190-11ec-0fba-0b758cb70572
let
	rho(x,y) = x^2*y^2
	g(x) = 2 - x^2
	h(x) = -3 + 2x^2
	a = sqrt(Sym(5))
	integrate(rho(x,y), (y, h(x), g(x)), (x, -a, a))
end

# ╔═╡ 3b08d3ee-c190-11ec-036f-e314d382fdb4
md"""##### Example (Strang)
"""

# ╔═╡ 3b08d466-c190-11ec-3959-597531013bc0
md"""Integrate $\int_0^1 \int_y^1 \cos(x^2) dx dy$ avoiding the *impossible* integral of $\cos(x^2)$. As the integrand is continuous, Fubini's Theorem allows the interchange of the variable of integraton. The region, $R$, is a triangle in the first quadrant below the line $y=x$ and left of the line $x=1$. So we have:
"""

# ╔═╡ 3b08d4ac-c190-11ec-3912-955bc575dbb7
md"""```math
~
\int_0^1 \int_0^x \cos(x^2) dy dx
~
```
"""

# ╔═╡ 3b08d4fc-c190-11ec-291f-a70560162604
md"""We can integrate this, as the interior integral leaves $x \cos(x^2)$ to integrate:
"""

# ╔═╡ 3b08dea2-c190-11ec-13d2-230320d51066
integrate(cos(x^2), (y, 0, x), (x, 0, 1))

# ╔═╡ 3b08dee8-c190-11ec-30f1-0bdc05a233ca
md"""### A "Fubini" function
"""

# ╔═╡ 3b08df9c-c190-11ec-3006-9949c222d574
md"""The computationally efficient way to perform multiple integrals numerically would be to use `hcubature`. However, this function is defined only for *rectangular* regions. In the event of non-rectangular regions, the suggested performant way would be to find a suitable transformation (below).
"""

# ╔═╡ 3b08dfce-c190-11ec-2e70-3d67c864b3e0
md"""However, for simple problems, where ease of expressing a region is preferred to computational efficiency, something can be implemented using repeated uses of `quadgk`. Again, this isn't recommended, save for its relationship to how iteration is approached algebraically.
"""

# ╔═╡ 3b09022e-c190-11ec-3f6e-236b268d14d6
md"""In the `CalculusWithJulia` package, the `fubini` function is provided. For these notes, we define three operations using Unicode operators entered with `\int[tab]`, `\iint[tab]`, `\iiint[tab]`. (Using this, better shows the mechanics involved.)
"""

# ╔═╡ 3b090e90-c190-11ec-07d8-a11c5369b4cd
begin
	# adjust endpoints when expressed as a functions of outer variables
	callf(f::Number, x) = f
	callf(f, x) = f(x...)
	endpoints(ys, x) = callf.(ys, Ref(x))
	
	# integrate f(x) dx
	∫(@nospecialize(f), xs) = quadgk(f, xs...)[1] # @nospecialize is not necessary, but offers a speed boost
	
	# integrate int_a^b int_h(x)^g(y) f(x,y) dy dx
	∬(f, ys, xs) = ∫(x -> ∫(y -> f(x,y), endpoints(ys, x)), xs)
	
	# integrate f(x,y,z) dz dy dx
	∭(f, zs, ys, xs) = ∫(
	    x -> ∫(
	        y -> ∫(
	            z -> f(x,y,z),
	        	endpoints(zs, (x,y))),
	        endpoints(ys,x)),
	    xs)
end

# ╔═╡ 3b090efe-c190-11ec-18af-512f6804b3dc
md"""##### Example
"""

# ╔═╡ 3b090f6c-c190-11ec-3a88-a713d796dd7b
md"""Compare the integral of $f(x,y) = \exp(-x^2 -2y^2)$ over the region $R=[0,3]\times[0,3]$ using `hcubature` and the above.
"""

# ╔═╡ 3b091b74-c190-11ec-000a-93b3c82f7536
let
	f(x,y) = exp(-x^2 - 2y^2)
	f(v) = f(v...)
	hcubature(f, (0,0), (3,3))  # (a0, a1), (b0, b1)
end

# ╔═╡ 3b0925f6-c190-11ec-3dec-bb19b4c65785
let
	f(x,y) = exp(-x^2 - 2y^2)
	∬(f, (0,3), (0,3))     # (a1, b1), (a0, b0)
end

# ╔═╡ 3b092628-c190-11ec-36a8-25e971ca8792
md"""##### Example
"""

# ╔═╡ 3b092664-c190-11ec-26b7-93991bbedda7
md"""Show the area of the unit circle is $\pi$ using the "Fubini" function.
"""

# ╔═╡ 3b092c7a-c190-11ec-3577-fba5087f4653
let
	f(x,y) = 1
	a = ∬(f, (x-> -sqrt(1-x^2), x-> sqrt(1-x^2)), (-1, 1))
	a, a - pi   # answer and error
end

# ╔═╡ 3b092cb8-c190-11ec-2f72-79273e063615
md"""(The error is similar to that returned by `quadgk(x -> sqrt(1-x^2), -1, 1)`.)
"""

# ╔═╡ 3b092d1c-c190-11ec-2152-1f7002bf94e0
md"""###### Example
"""

# ╔═╡ 3b092d50-c190-11ec-35a2-0f61f13fbcbc
md"""Show the volume of a sphere of radius $1$ is $4/3\pi = 4/3\pi\cdot 1^3$ by doubling the integral of $f(x,y) = \sqrt{1-x^2-y^2}$ over $R$, the unit disk.
"""

# ╔═╡ 3b09379e-c190-11ec-0476-97c6e3f25e8c
let
	f(x,y) = sqrt(1 - x^2 - y^2)
	a = 2 * ∬(f, (x-> -sqrt(1-x^2), x-> sqrt(1-x^2)), (-1, 1))
	a, a - 4/3*pi
end

# ╔═╡ 3b0937d0-c190-11ec-1f16-337525d75434
md"""##### Example
"""

# ╔═╡ 3b093802-c190-11ec-3dc4-9726b16c104a
md"""Numeric integrals don't need to worry about integrands without antiderivatives. Their concerns are highly oscillatory integrands. Here we compute $\int_0^1 \int_y^1 \cos(x^2) dx dy$ directly. The limits are in a different order than the "Fubini" function expects, so we switch the variables:
"""

# ╔═╡ 3b0944be-c190-11ec-1fff-cb8575d92619
∬((y,x) -> cos(x^2), (y -> y, 1), (0, 1))

# ╔═╡ 3b0944e6-c190-11ec-1084-6f13bf213698
md"""Compare to
"""

# ╔═╡ 3b096a7a-c190-11ec-39c2-f9b5ebdb7784
sin(1)/2

# ╔═╡ 3b096b3a-c190-11ec-144f-594b5c354688
md"""## Triple integrals
"""

# ╔═╡ 3b096bc4-c190-11ec-3f85-e9af8aa33eeb
md"""Triple integrals are identical in theory to double integrals, though the computations can be more involved and the regions more complicated to describe. The main regions (emphasized by Strang) to understand are: box, prism, cylinder, cone, tetrahedron, and sphere.
"""

# ╔═╡ 3b0977fe-c190-11ec-2d1c-09884c031b97
let
	ts = range(0, pi/2, length=50)
		O = [0,0,0]
		bx, by,bz = [1, 0, 0], [0,2,0], [0,0,3]
	
		p = plot(unzip([O])..., legend=false, title="box",
			axis=nothing)
		arrow!(p, O, bx), arrow!(p, O, by), arrow!(p, O, bz)
		arrow!(p, bx, bz), arrow!(p, bx, by)
		arrow!(p, by, bx), arrow!(p, by, bz)
		arrow!(p, bz, bx), arrow!(p, bz, by)
		arrow!(p, bx+by, bz),
		arrow!(p, bx+by+bz, -bx), arrow!(p, bx+by+bz, -by)
		ps = [p]
	
		p = plot(unzip([O])..., legend=false, title="prism",
			axis=nothing)
		arrow!(p, O, bx), arrow!(p, O, by),
		arrow!(p, bx, by), arrow!(p, by, bx),
		arrow!(p, O, bz), arrow!(p, by, bz)
		arrow!(p, bz, by)
		arrow!(p, bx, bz-bx), arrow!(p, bx + by, by+bz - (bx + by))
		push!(ps, p)
	
		p = plot(unzip([O])..., legend=false, title="tetrahedron",
			axis=nothing)
		arrow!(p, O, bx), arrow!(p, O, by), arrow!(p, O, bz)
		arrow!(p, bx, by-bx)
		arrow!(p, bx, bz-bx), arrow!(p, by, bz-by)
		push!(ps, p)
	
		p = plot(unzip([O])..., legend=false, title="cone",
			camera=(70,20), axis=nothing)
		arrow!(p, O, bx), arrow!(p, O, by/2), arrow!(p, O, bz)
		arrow!(p, bx, bz-bx), arrow!(p, by/2, bz-by/2)
	
		for h in range(0.1, 0.9, length=5)
			z = 3*h
			r = 1 - h
			plot!(p, r*cos.(ts), r*sin.(ts), z .+ 0*ts)
		end
		push!(ps, p)
	
		p = plot(unzip([O])..., legend=false, title="sphere",
			camera=(70,20), axis=nothing)
		Os = 0 * ts
		plot!(p, cos.(ts), sin.(ts), Os)
		plot!(p, cos.(ts), Os, sin.(ts))
		plot!(p, Os, cos.(ts), sin.(ts))
		for h in .2:.2:.8
			r = sqrt(1 - h^2)
			plot!(p, r*cos.(ts), r*sin.(ts), h .+ Os)
		end
		push!(ps, p)
	
	    l = @layout [a b; c d; e]
	plot(ps..., layout=l)
end

# ╔═╡ 3b09788a-c190-11ec-323f-bb9cf7b12260
md"""Here we compute the volumes of these using a triple integral of the form $\iint_R 1 dV$.
"""

# ╔═╡ 3b0979de-c190-11ec-2958-2128305d0c62
md"""  * Box. Consider the box-like, or "rectangular," region $[0,a]\times [0,b] \times [0,c]$. This has volume $abc$ which we see here using Fubini's theorem:
"""

# ╔═╡ 3b09828c-c190-11ec-2d3c-094b5bd81451
let
	@syms a b c
	f(x,y,z) = Sym(1)   # need to integrate a symbolic object in integrand or call `sympy.integrate`
	integrate(f(x,y,z), (x, 0, a), (y, 0, b), (z, 0, c))
end

# ╔═╡ 3b09835c-c190-11ec-2b30-4dbf00bb8c20
md"""  * Prism. Consider a prism or wedge formed by $ay + bz = 1$ with $a,b > 0$ and over the region in the first quadrant $0 \leq x \leq c$. Find its area.
"""

# ╔═╡ 3b098398-c190-11ec-2edf-b325d2e40d70
md"""The function to integrate is $f(x,y) = (1 - ay)/b$ over the region bounded by $[0,c] \times [0,1/a]$:
"""

# ╔═╡ 3b098ab4-c190-11ec-1588-871a17e61d15
let
	@syms a b c
	f(x,y,z) = Sym(1)
	integrate(f(x,y,z), (z, 0, (1 - a*y)/b), (y, 0, 1/a), (x, 0, c))
end

# ╔═╡ 3b098b5c-c190-11ec-0ec5-03607e644e5f
md"""Which, as expected, is half the volume of the box $[0,c] \times [0, 1/a] \times [0, 1/b]$.
"""

# ╔═╡ 3b098c12-c190-11ec-293e-ebc53835c773
md"""  * Tetrahedron. Consider the volume formed by $x,y,z \geq 0$ and bounded by $ax+by+cz = 1$ where $a,b,c \geq 0$. The volume is a tetrahedron. The base in the $x$-$y$ plane is a triangle with vertices $(1/a, 0, 0)$ and $(0, 1/b, 0)$.
"""

# ╔═╡ 3b098c44-c190-11ec-2dc9-3b0ea4800a6f
md"""(The third easy-to-find point is $(0, 0, 1/c)$). The line connecting the points in the $x$-$y$ plane is $ax + by = 1$. With this, the integral to compute the volume is
"""

# ╔═╡ 3b0992b6-c190-11ec-0f7f-0d6153845485
let
	@syms a b c
	f(x,y,z) = Sym(1)
	integrate(f(x,y,z), (z, 0, (1 - a*x - b*y)/c), (y, 0, (1 - a*x)/b), (x, 0, 1/a))
end

# ╔═╡ 3b0992f2-c190-11ec-0da7-13b77bf692eb
md"""This is $1/6$th the volume of the box.
"""

# ╔═╡ 3b0993f6-c190-11ec-2ff8-6932f697a21f
md"""  * Cone. Consider a cone formed by the function $z = f(x,y) = a - b(x^2+y^2)^{1/2}$ ($a,b > 0$) and the $x$-$y$ plane. This will have radius $r = a/b$ and height $a$. The volume is given by this integral:
"""

# ╔═╡ 3b099446-c190-11ec-1cf1-a9b1f74b955e
md"""```math
~
\int_{x=-r}^r \int_{y=-\sqrt{r^2 - x^2}}^{\sqrt{r^2-x^2}} \int_0^{a - b(x^2 + y^2)} 1 dz dy dx.
~
```
"""

# ╔═╡ 3b099478-c190-11ec-2039-b1bb828cc1d3
md"""This integral is doable, but `SymPy` has trouble with it. We will return to this when cylindrical coordinates are defined.
"""

# ╔═╡ 3b0994f0-c190-11ec-1b49-4bc7fa5df45f
md"""  * Sphere. The sphere $x^2 + y^2 + z^2 \leq 1$ has a known volume. Can we compute it using integration? In Cartesian coordinates, we can describe the region $x^2 + y^2 \leq 1$ and then the $z$-limits will follow:
"""

# ╔═╡ 3b099534-c190-11ec-1017-bd72b749a703
md"""```math
~
\int_{x=-1}^1 \int_{y=-\sqrt{1-x^2}}^{\sqrt{1-x^2}} \int_{z=-\sqrt{1 - x^2 - y^2}}^{\sqrt{1-x^2 - y^2}} 1 dz dy dx.
~
```
"""

# ╔═╡ 3b0995b8-c190-11ec-1411-8de0b851dbff
md"""This integral is doable, but `SymPy` has trouble with it. We will return to this when spherical coordinates are defined.
"""

# ╔═╡ 3b0995d8-c190-11ec-19cd-bb7f5c7bbbdb
md"""## Change of variables
"""

# ╔═╡ 3b0995ea-c190-11ec-2471-677247530860
md"""The change of variables, or substitution, formula from first-semester calculus is expressed, under assumptions, by:
"""

# ╔═╡ 3b0995fe-c190-11ec-1003-a985a28f981e
md"""```math
~
\int_{g(R)} f(x) dx = \int_R (f\circ g)(u)g'(u) du.
~
```
"""

# ╔═╡ 3b099630-c190-11ec-1278-637f57834193
md"""The derivation comes from reversing the chain rule. When using it, we start on the right hand side and typically write $x = g(u)$ and from here derive an expression involving differentials: $dx = g'(u) du$ and the rest follows. In practice, this is used to simplify the integrand in the search for an antiderivative, as $(f\circ g)$ is generally more complicated than $f$ alone.
"""

# ╔═╡ 3b09966a-c190-11ec-3245-2168c7662e75
md"""In higher dimensions, we will see that change of variables can not only simplify the integrand, but is also of great use to simplify the region to integrate over. We mentioned, for example, that to use `hcubature` efficiently over a non-rectangular region, a transformation–-or change of variables–-is needed. The key to the multi-dimensional formula is understanding what should replace $dx = g'(u) du$. We take a bit of a circuitous route to get there.
"""

# ╔═╡ 3b0996b2-c190-11ec-24eb-454cdd157b69
md"""In [Katz](http://www.jstor.org/stable/2689856) a review of the history of "change of variables" from Euler to Cartan is given. We follow Lagrange's formal analysis to derive the change of variable formula in two dimensions.
"""

# ╔═╡ 3b0996e4-c190-11ec-0700-0d1e239d48a1
md"""We view $R$ in two coordinate systems $(x,y)$ and $(u,v)$. We have that
"""

# ╔═╡ 3b099766-c190-11ec-2d98-492f8b0579b9
md"""```math
~
\begin{align}
dx &= A du + B dv\\
dy &= C du + D dv,
\end{align}
~
```
"""

# ╔═╡ 3b0997ca-c190-11ec-3520-b19793997f6a
md"""where $A = \partial{x}/\partial{u}$, $B = \partial{x}/\partial{v}$, $C= \partial{y}/\partial{u}$, and $D = \partial{y}/\partial{v}$. Lagrange, following Euler, first sets $x$ to be constant (as is done in iterated integration). Hence, $dx = 0$ and so $du = -C(B/A) dv$ and, after substitution,  $dy = (D-C(B/A))dv$. Then Lagrange set $y$ to be a constant, so $dy = 0$ and hence $dv=0$ so $dx = Adu$. The area "element" $dx dy = A du \cdot (D - (B/A)) dv = (AD - BC) du dv$. Since areas and volumes are non-negative, the absolute value is used. With this, we have "$dxdy = |AD-BC|du dv$" as the analog of $dx = g'(u) du$.
"""

# ╔═╡ 3b099856-c190-11ec-21f7-119c4851cc50
md"""The expression $AD - BC$ was also derived by Euler, by related means. Lagrange extended the analysis to 3 dimensions. Before doing so, it is helpful to understand the problem from a geometric perspective. Euler was attempting to understand the effects of the following change of variable:
"""

# ╔═╡ 3b0998d6-c190-11ec-0f57-57820e8f897f
md"""```math
~
\begin{align}
x &= a + mt + \sqrt{1-m^2} v\\
y & = b + \sqrt{1-m^2}t -mv
\end{align}
~
```
"""

# ╔═╡ 3b099950-c190-11ec-30f9-3373431a913d
md"""Euler knew this to be a clockwise *rotation* by an angle $\theta$ with $\cos(\theta) = m$,  a *reflection* through the $x$ axis, and a translation by $\langle a, b\rangle$. All these *should* preserve the area represented by $dx dy$, so he was *expecting* $dx dy = dt dv$.
"""

# ╔═╡ 3b09a0e6-c190-11ec-1c86-a52856edddb9
let
	imgfile ="figures/euler-rotation.png"
	caption = "Figure from Katz showing rotation of Euler."
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 3b09a10c-c190-11ec-2d06-1d2bc737b494
md"""The figure, taken from Katz, shows the translation, and rotation that should preserve area on a differential scale.
"""

# ╔═╡ 3b09a15c-c190-11ec-17ac-4d9789b75a73
md"""However Euler knew $dx = (\partial{g_1}/\partial{t}) dt + (\partial{g_1}/\partial{v}) dv$ and $dy = (\partial{g_2}/{\partial{t}}) dt + (\partial{g_2}/\partial{v}) dv$. Just multiplying gives $dx dy = m\sqrt{1-m^2} dt dt + (1-m^2) dv dt -m^2 dt dv -m\sqrt{1-m^2} dv dv$, a result that didn't make sense physically as $dt dt$ and $dv dv$ have no meaning in integration and $1 - m^2 - m^2$ is not $1$ as expected. Euler, like Lagrange, used a formal trick to proceed, but the geometric insight that the incremental areas for a change of variable should be related and for this change of variable identical is correct.
"""

# ╔═╡ 3b09a178-c190-11ec-0d04-a7a787b8a1a7
md"""The following illustrates the polar-coordinate transformation $\langle x,y\rangle = G(r, \theta) = r \langle \cos\theta, \sin\theta\rangle$.
"""

# ╔═╡ 3b09ae54-c190-11ec-1695-f1d7db82222b
let
	G(u, v) = u * [cos(v), sin(v)]
	
	G(v) = G(v...)
	J(v) = ForwardDiff.jacobian(G, v)  # [∇g1', ∇g2']
	
	n = 6
	us = range(0, 1, length=3n)     # radius
	vs = range(0, 2pi, length=3n)   # angle
	
	plot(unzip(G.(us', vs))..., legend = false, aspect_ratio=:equal)  # plots constant u lines
	plot!(unzip(G.(us, vs'))...)                                      # plots constant v lines
	
	pt = [us[n],vs[n]]
	
	
	arrow!(G(pt), J(pt)*[1,0], color=:blue)
	arrow!(G(pt), J(pt)*[0,1], color=:blue)
end

# ╔═╡ 3b09aee0-c190-11ec-08fd-e7e8b11b45e7
md"""This graphic shows the image of the box $[0,1] \times [0, 2\pi]$ under the transformation. The `plot` commands draw lines for values of constant `u` or constant `v`. If $G(u,v) = \langle g_1(u,v), g_2(u,v)\rangle$, then the Taylor expansion for $g_i$ is $g_i(u+du, v+dv) \approx g_i(u,v) + (\nabla{g_i})^T \cdot \langle du, dv \rangle$ and combining $G(u+du, v+dv) \approx G(u,v) + J_G(u,v) \langle du, dv \rangle$. The vectors added above represent the images when $u$ is constant (so $du=0$) and when $v$ is constant (so $dv=0$). The two arrows define a parallelogram whose area gives the change of area undergone by the unit square under the transformation. The area is $|\det(J_G)|$, the absolute value of the determinant of the Jacobian.
"""

# ╔═╡ 3b0a3e52-c190-11ec-1c7b-05a44e2eda1e
function showG(G, a=1, b=1;a0=0, b0=0, an = 3, bn=3, n=5, lambda=1/2, k1=1, k2=1)

J(v) = ForwardDiff.jacobian(v -> G(v...), v)  # [∇g1', ∇g2']

us = range(0, a, length=an*n)     # radius
vs = range(0, b, length=bn*n)   # angle

p = plot(unzip(G.(us', vs))..., legend = false, aspect_ratio=:equal)  # plots constant u lines
plot!(p,unzip(G.(us, vs'))...)                                      # plots constant v lines

pt = [us[k1 * n],vs[k2*n]]
P, U, V = G(pt...), lambda * J(pt)*[1,0], lambda *  J(pt)*[0,1]
arrow!(P, U, color=:blue, linewidth=2)
arrow!(P+V, U, color=:red, linewidth=1)
arrow!(P, V, color=:blue, linewidth=2)
arrow!(P+U, V, color=:red, linewidth=1)
p
end

# ╔═╡ 3b0a3f54-c190-11ec-3637-c3620c622342
md"""The tranformation to elliptical coordinates, $G(u,v) = \langle \cosh(u)\cos(v), \sinh(u)\sin(v)\rangle$, may be viewed similarly:
"""

# ╔═╡ 3b0a4bf2-c190-11ec-03d4-c521e71e85cf
let
	G(u,v) = [cosh(u)*cos(v), sinh(u)*sin(v)]
	showG(G, 1, 2pi)
end

# ╔═╡ 3b0a4c38-c190-11ec-0b94-335fb1fdd41f
md"""The transformation  $G(u,v) = v \langle e^u, e^{-u} \rangle$ uses hyperbolic coordinates:
"""

# ╔═╡ 3b0a56a6-c190-11ec-2d1e-8f478878123c
let
	G(u,v) = v * [exp(u), exp(-u)]
	showG(G, 1, 2pi, bn = 6, k2=4)
end

# ╔═╡ 3b0a56e2-c190-11ec-2679-a18c43959dcd
md"""The transformation $G(u,v) = \langle u^2-v^2, u\cdot v \rangle$  yields a partition of the plane:
"""

# ╔═╡ 3b0a5f84-c190-11ec-0f73-21ce8cae3555
let
	G(u,v) = [u^2 - v^2, u*v]
	showG(G, 1, 1)
end

# ╔═╡ 3b0a5fd4-c190-11ec-0ecd-2bf95dfaf851
md"""The arrows are the images of the standard unit vectors. We see some transformations leave these *orthogonal* and some change the respective lengths. The area of the associated parallelogram can be found using the determinant of an accompanying matrix. For two dimensions, using the cross product formulation on the embedded vectors, the area is
"""

# ╔═╡ 3b0a6006-c190-11ec-26ff-43fc924313d1
md"""```math
~
\| \det\left(\left[
\begin{array}{}
\hat{i} & \hat{j} & \hat{k}\\
u_1 & u_2 & 0\\
v_1 & v_2 & 0
\end{array}
\right]
\right) \|
=
\| \hat{k} \det\left(\left[
\begin{array}{}
u_1 & u_2\\
v_1 & v_2
\end{array}
\right]
\right) \|
= | \det\left(\left[
\begin{array}{}
u_1 & u_2\\
v_1 & v_2
\end{array}
\right]
\right)|.
~
```
"""

# ╔═╡ 3b0a6038-c190-11ec-0506-1f4bdb93f76b
md"""Using the fact that the two vectors involved are columns in the Jacobian of the transformation, this is just $|\det(J_G)|$. For $3$ dimensions, the determinant gives the volume of the 3-dimensional parallelepiped in the same manner. This holds for higher dimensions.
"""

# ╔═╡ 3b0a606a-c190-11ec-0a4c-8f415e7a1c6d
md"""The absolute value of the determinant of the Jacobian is the multiplying factor that is seen in the change of variable formula for all dimensions:
"""

# ╔═╡ 3b0a6222-c190-11ec-134c-bdc31a1fb40f
md"""> [Change of variable](https://en.wikipedia.org/wiki/Integration_by_substitution#Substitution_for_multiple_variables) Let $U$ be an open set in $R^n$, $G:U \rightarrow R^n$ be an *injective* differentiable function with *continuous* partial derivatives. If $f$ is continuous and compactly supported, then $~ \iint_{G(S)} f(\vec{x}) dV = \iint_S (f \circ G)(\vec{u}) |\det(J_G)(\vec{u})| dU. ~$

"""

# ╔═╡ 3b0a6240-c190-11ec-3201-0bc8c6eda15b
md"""For the one-dimensional case, there is no absolute value, but there the interval is reversed, producing "negative" area. This is not the case here, where $S$ is parameterized to give positive volume.
"""

# ╔═╡ 3b0a6f22-c190-11ec-2c8e-17f8f78e6c6d
note(L"""

The term "functional determinant" is found for the value $\det(J_G)$, as is the notation $\partial(x_1, x_2, \dots x_n)/\partial(u_1, u_2, \dots, u_n)$.

""")

# ╔═╡ 3b0a6f74-c190-11ec-089e-c16d56017ea1
md"""### Two dimensional change of variables
"""

# ╔═╡ 3b0a6f9c-c190-11ec-0aa9-9d2ee0893ff2
md"""Now we see several examples of two-dimensional transformations.
"""

# ╔═╡ 3b0a7046-c190-11ec-1644-496b8d15a673
md"""#### Polar integrals
"""

# ╔═╡ 3b0a70dc-c190-11ec-1c30-7bd09aea610f
md"""We have [seen](../differentiable_vector_calculus/polar_coordinates.html) how to compute area in polar coordinates through the formula $A = \int (1/2) r^2(\theta) d\theta$. This formula can be derived as follows. Consider a region $R$ parameterized in polar coordinates by $r(\theta)$ for $a \leq \theta \leq b$. The area of this region would be $\iint_R fdA$. Let $G(r, \theta) = r \langle \cos\theta, \sin\theta\rangle$. Then
"""

# ╔═╡ 3b0a710e-c190-11ec-1004-ff0c43419f64
md"""```math
~
J_G = \left[
\begin{array}{}
\cos(\theta) & - r\sin(\theta)\\
\sin(\theta) & r\cos(\theta)
\end{array}
\right],
~
```
"""

# ╔═╡ 3b0a712e-c190-11ec-393f-d1f942a0a58c
md"""with determinant $r$.
"""

# ╔═╡ 3b0a7168-c190-11ec-0e39-332f69c60ed9
md"""That is, for *polar coordinates* $dx dy = r dr d\theta$ ($r \geq 0$).
"""

# ╔═╡ 3b0a71c0-c190-11ec-041b-63023476eeae
md"""So by the change of variable formula, we have:
"""

# ╔═╡ 3b0a71d6-c190-11ec-3479-2b6920366a50
md"""```math
~
A = \iint_R 1 dx dy = \int_a^b \int_0^{r(\theta)} 1 r dr d\theta = \int_a^b \frac{r^2(\theta)}{2} d\theta.
~
```
"""

# ╔═╡ 3b0a7212-c190-11ec-1921-c594222fb1a6
md"""The key is noting that the region, $S$, described by $\theta$ running from $a$ to $b$ and $r$ running from $0$ to $r(\theta)$, maps onto $R$ through the change of variables. As polar coordinates is just a renaming, this is clear to see.
"""

# ╔═╡ 3b0a7244-c190-11ec-131b-b1e42414a72f
md"""---
"""

# ╔═╡ 3b0a7258-c190-11ec-0402-f1ea9da86626
md"""Now consider finding the volume of a sphere using polar coordinates. We have, with $\rho$ being the radius:
"""

# ╔═╡ 3b0a726c-c190-11ec-1fe1-41c8abd252ec
md"""```math
~
V = 2 \iint_R \sqrt{\rho^2 - x^2 - y^2} dy dx,
~
```
"""

# ╔═╡ 3b0a7296-c190-11ec-19ef-ff10b7f03a6b
md"""where $R$ is the disc of radius $\rho$. Using polar coordinates, we have $x^2 + y^2 = r^2$ and the expression becomes:
"""

# ╔═╡ 3b0a7316-c190-11ec-0fc3-31cb03e92b9f
md"""```math
~
V = 2 \int_0^{2\pi} \int_0^\rho \sqrt{\rho^2 - r^2} r dr d\theta = 2 \int_0^{2\pi} -(1 - r^2)^{3/2}\frac{1}{3} \mid_0^\rho d\theta = 2\int_0^{2\pi} \frac{\rho^3}{3}d\theta = \frac{4\pi\rho^3}{3}.
~
```
"""

# ╔═╡ 3b0a7348-c190-11ec-0d37-0b1f70914398
md"""##### Linear transformations
"""

# ╔═╡ 3b0a737a-c190-11ec-3492-99d4fee8a532
md"""Some [transformations](https://en.wikipedia.org/wiki/Transformation_matrix#Examples_in_2D_computer_graphics) from $2$D computer graphics are represented in matrix notation:
"""

# ╔═╡ 3b0a738e-c190-11ec-3bfa-19378fe91639
md"""```math
~
\left[
\begin{array}{}
x\\
y
\end{array}
\right] =
\left[
\begin{array}{}
a & b\\
c & d
\end{array}
\right]
\left[
\begin{array}{}
u\\
v
\end{array}
\right],
~
```
"""

# ╔═╡ 3b0a73b6-c190-11ec-2e89-1f8780a0915d
md"""or $G(u,v) = \langle au+bv, cu+dv\rangle$. The Jacobian of this *linear* transformation is the matrix itself.
"""

# ╔═╡ 3b0a73cc-c190-11ec-1d51-5fabc3197aa8
md"""Some common transformations are:
"""

# ╔═╡ 3b0a749c-c190-11ec-2898-4fcb71da4fed
md"""  * **Stretching** or $G(u,v) = \langle ku, v \rangle$ or $G(u,v) = \langle u, kv\rangle$ for some $k >0$. The former stretching the $x$ axis, the latter the $y$. These have Jacobian determinant $k$
"""

# ╔═╡ 3b0a7992-c190-11ec-3dbe-f3702c80070f
let
	k = 2
	G(u,v) = [k*u, v]
	showG(G, 1, 1)
end

# ╔═╡ 3b0a7a3c-c190-11ec-20d9-27f66fbfa90a
md"""  * **Rotation**. Let $\theta$ be a clockwise rotation parameter, then $G(u,v) = \langle\cos\theta u + \sin\theta v, -\sin\theta u + \cos\theta v\rangle$ will be the transform. The Jacobian is $1$. This figure rotates by $\pi/6$:
"""

# ╔═╡ 3b0a8036-c190-11ec-391e-b5eccd101df1
let
	theta = pi/6
	G(u,v) = [cos(theta)*u + sin(theta)*v, -sin(theta)*u + cos(theta)*v]
	showG(G, 1, 1)
end

# ╔═╡ 3b0a80ea-c190-11ec-1208-8b9fa239fc34
md"""  * **Shearing**. Let $k > 0$ and $G(u,v) = \langle u + kv, v \rangle$. This transformation is shear parallel to the $x$ axis. (Use $G(u,v) = \langle u, ku+v\rangle$ for the $y$ axis). A shear has Jacobian $1$.
"""

# ╔═╡ 3b0a85a4-c190-11ec-0bf6-c9106d792e63
let
	k = 2
	G(u, v) = [u + 2v, v]
	showG(G)
end

# ╔═╡ 3b0a988c-c190-11ec-1054-7708e8877acd
md"""  * **Reflection** If $\vec{l} = \langle l_x, l_y \rangle$ with norm $\|\vec{l}\|$. The reflection through the line in the direction of $\vec{l}$ through the origin is defined, using a matrix, by:
"""

# ╔═╡ 3b0a98d2-c190-11ec-0bf2-af5173f57241
md"""```math
~
\frac{1}{\| \vec{l} \|^2}
\left[
\begin{array}{}
l_x^2 - l_y^2 & 2 l_x l_y\\
2l_x l_y & l_y^2 - l_x^2
\end{array}
\right]
~
```
"""

# ╔═╡ 3b0a998e-c190-11ec-3c4e-abbe5d521ee0
md"""For some simple cases: $\langle l_x, l_y \rangle = \langle 1, 1\rangle$, the diagonal, this is $G(u,v) = (1/2) \langle 2v, 2u \rangle$; $\langle l_x, l_y \rangle = \langle 0, 1\rangle$ (the $y$-axis) this is $G(u,v) = \langle -u, v\rangle$.
"""

# ╔═╡ 3b0a9a3a-c190-11ec-13a5-371d91d4c5f8
md"""  * A translation by $\langle a ,b \rangle$ would be given by $G(u,v) = \langle u+a, y+b \rangle$ and would have Jacobian determinant $1$.
"""

# ╔═╡ 3b0a9ab2-c190-11ec-029a-a3c64c00be0c
md"""As an example, consider the transformation of reflecting through the line $x = 1/2$. Let $\vec{ab} = \langle 1/2, 0\rangle$. This would be found by translating by $-\vec{ab}$ then reflecting through the $y$ axis, then translating by $\vec{ab}$:
"""

# ╔═╡ 3b0aa39a-c190-11ec-082c-d74f8d385837
let
	T(u, v, a, b) = [u+a, v+b]
	G(u, v) = [-u, v]
	@syms u v
	a,b = 1//2, 0
	x1, y1 = T(u,v, -a, -b)
	x2, y2 = G(x1, y1)
	x, y = T(x2, y2, a, b)
end

# ╔═╡ 3b0aa3e0-c190-11ec-1b76-6b7299cc5c1f
md"""##### Triangle
"""

# ╔═╡ 3b0aa444-c190-11ec-08f9-07a20b4ee098
md"""Consider the problem of integrating $f(x,y)$ over the triangular region bounded by $y=x$, $y=0$, and $x=1$. Such an integral may be computed through Fubini's theorem through $\int_0^1 \int_0^x f(x,y) dy dx$ or $\int_0^1 \int_y^1 f(x,y) dx dy$, but *if* these can not be computed, and a numeric option is preferred, a transformation so that the integral is over a rectangle is preferred.
"""

# ╔═╡ 3b0aa476-c190-11ec-0e69-73ea223295fb
md"""For this, the transformation $x = u$, $y=uv$ for $(u,v)$ in $[0,1] \times [0,1]$ is possible:
"""

# ╔═╡ 3b0aab88-c190-11ec-1232-0714963ebe6e
let
	G(u,v) = [u,u*v]
	showG(G, lambda=1/3)
end

# ╔═╡ 3b0aabec-c190-11ec-107b-7130ad0e2759
md"""The determinant of the Jacobian is
"""

# ╔═╡ 3b0aac16-c190-11ec-3c81-8d49e5d81082
md"""```math
~
\det(J_G) = \det\left(
\left[
\begin{array}{}
1 & 0\\
v & u
\end{array}
\right]
\right) = u.
~
```
"""

# ╔═╡ 3b0aac48-c190-11ec-0f2a-5f6df85b99bc
md"""So,  $\iint_R f(x,y) dA = \int_0^1\int_0^1 f(u, uv) u du dv$. Here we illustrate with a generic monomial:
"""

# ╔═╡ 3b0ab402-c190-11ec-3ae1-cd47e4588744
begin
	@syms n::positive m::positive
	monomial(x,y) = x^n*y^m
	integrate(monomial(x,y), (y, 0, x), (x, 0, 1))
end

# ╔═╡ 3b0ab42a-c190-11ec-06f4-b1f71643eb7f
md"""And compare with:
"""

# ╔═╡ 3b0aba06-c190-11ec-06d0-873487a898ce
let
	@syms u v
	integrate(monomial(u, u*v)*u, (u,0,1), (v,0,1))
end

# ╔═╡ 3b0aba60-c190-11ec-3418-1f9393c80696
md"""###### Composition of transformations
"""

# ╔═╡ 3b0aba92-c190-11ec-3dc2-3f80392ca9dd
md"""What about other triangles, say the triangle bounded by $x=0$, $y=0$ and $y-x=1$?
"""

# ╔═╡ 3b0abb3c-c190-11ec-1892-258130c628fb
md"""This can be seen as a reflection through the line $x=1/2$ of the triangle above. If $G_1$ represents the mapping from $U [0,1]\times[0,1]$ into the triangle of the last problem, and $G_2$ represents the reflection through the line $x=1/2$, then the transformation $G_2 \circ G_1$ will map the box $U$ into the desired region. By the chain rule, we have:
"""

# ╔═╡ 3b0abb64-c190-11ec-1588-9d5ff1e2d6c6
md"""```math
~
\int_{(G_2\circ G_1)(U))} f dx = \int_U (f\circ G_2 \circ G_1) |\det(J_{G_2 \circ G_1}| du =
\int_U (f\circ G_2 \circ G_1) |\det(J_{G_2}(G_1(u))||\det J_{G_1}(u)| du.
~
```
"""

# ╔═╡ 3b0abba0-c190-11ec-204e-134f6c227c49
md"""(In  [Katz](http://www.jstor.org/stable/2689856) it is mentioned that Jacobi showed this in 1841.)
"""

# ╔═╡ 3b0abbc8-c190-11ec-36ed-afe009d16cb7
md"""The flip through the $x=1/2$ line was done above and  is $\langle u, v\rangle \rightarrow \langle 1-u, v\rangle$ which has Jacobian determinant $-1$.
"""

# ╔═╡ 3b0abc04-c190-11ec-11ed-ed71b45c6562
md"""We compare now using and `hcubature` and our "Fubini" function:
"""

# ╔═╡ 3b0ac2e4-c190-11ec-111f-e9848adb77cd
let
	G1(u,v) = [u, u*v]
	G1(v) = G1(v...)
	G2(u,v) = [1-u, v]
	G2(v) = G2(v...)
	f(x,y) = x^2*y^3
	f(v) = f(v...)
	A = ∬((y,x) -> f(x,y), (0, x -> 1 - x), (0, 1))
	B = hcubature(v -> (f∘G2∘G1)(v) * v[1] * 1, (0,0), (1, 1))
	A, B[1], A - B[1]
end

# ╔═╡ 3b0ac320-c190-11ec-20aa-d1be422ce9f3
md"""##### Hyperbolic transformation
"""

# ╔═╡ 3b0ac38e-c190-11ec-28d8-83345807fc87
md"""Consider the region, $R$, bounded by $y=0$, $x=e^{-n}$, $x=e^n$, and $y=1/x$. An integral over this region may be computed with the help of the transform $G(u,v) = v \langle e^u, e^{-u}\rangle$ which takes the box $[-n, n] \times [0,1]$ onto $R$.
"""

# ╔═╡ 3b0ac3c0-c190-11ec-0c29-a1c0dc8a0932
md"""With this, we compute $\iint_R x^2 y^3 dA$ using `SymPy` to compute the Jacobian:
"""

# ╔═╡ 3b0ac97e-c190-11ec-0077-b7df06bbca07
let
	@syms u v n
	G(u,v) = v * [exp(u), exp(-u)]
	Jac = G(u,v).jacobian([u,v])
	f(x,y) = x^2 * y^3
	f(v) = f(v...)
	integrate(f(G(u,v)) * abs(det(Jac)), (u, -n, n), (v, 0, 1))
end

# ╔═╡ 3b0ac9a6-c190-11ec-34ac-bb2a390c554f
md"""---
"""

# ╔═╡ 3b0ac9d8-c190-11ec-37b8-514d4b233bc3
md"""This collection shows a summary of the above $2$D transformations:
"""

# ╔═╡ 3b0ad340-c190-11ec-1b50-51db6879edab
let
	transform(u,v) = [u+2, v+3]
	ps = [showG(transform)]
	xlabel!(ps[end], "transformation")
	
	rotation(u,v, θ=pi/3) = [cos(θ) sin(θ); -sin(θ) cos(θ)]*[u,v]
	push!(ps, showG(rotation))
	xlabel!(ps[end], "rotation")
	
	shear(u,v) = [u+v, v]
	push!(ps, showG(shear))
	xlabel!(ps[end], "shear")
	
	triangle(u,v) =  [u, u*v]
	push!(ps, showG(triangle))
	xlabel!(ps[end], "triangle")
	
	shear(v) = shear(v...)
	push!(ps, showG(shear ∘ triangle))
	xlabel!(ps[end], "shear ∘ triangle")
	
	circle(u, v) = v*[sin(2pi*u), cos(2pi*u)]
	push!(ps, showG(circle))
	xlabel!(ps[end], "polar")
	
	
	ellipse(u, v) = [cosh(u)*cos(v), sinh(u)*sin(v)]
	push!(ps, showG(ellipse))
	xlabel!(ps[end], "ellipse")
	
	
	hyperbolic(u, v) = v * [exp(u), exp(-u)]
	push!(ps, showG(hyperbolic))
	xlabel!(ps[end], "hyperbolic")
	
	partition(u,v) = [ u^2-v^2, u*v ]
	push!(ps, showG(partition))
	xlabel!(ps[end], "partition")
	
	l = @layout [a b c;
	             d e f;
				 g h i]
	
	plot(ps..., layout=l)
end

# ╔═╡ 3b0ad388-c190-11ec-0b40-f7e4571c4b30
md"""### Examples
"""

# ╔═╡ 3b0ad3a6-c190-11ec-1e4f-e599ab6a8fa0
md"""##### Centroid:
"""

# ╔═╡ 3b0ad3e4-c190-11ec-3b8c-bb0e7f2052c8
md"""The center of mass is a balancing point of a region with density $\rho(x,y)$. In two dimensions it is a point $\langle \bar{x}, \bar{y}\rangle$. These are found by the following formulas:
"""

# ╔═╡ 3b0ad400-c190-11ec-2980-958f8ad3a0af
md"""```math
~
A = \iint_R \rho(x,y) dA, \quad \bar{x} = \frac{1}{A} \iint_R x \rho(x,y) dA, \quad
\bar{y} = \frac{1}{A} \iint_R y \rho(x,y) dA.
~
```
"""

# ╔═╡ 3b0ad41e-c190-11ec-177a-3ba61f0d0786
md"""The $x$ value can be seen in terms of Fubini by integrating in $y$ first:
"""

# ╔═╡ 3b0ad4a0-c190-11ec-0b93-fb8eeaa47349
md"""```math
~
\iint_R x \rho(x,y) dA = \int_{x=a}^b (\int_{y=h(x)}^{g(x)} \rho(x,y) dy) dx.
~
```
"""

# ╔═╡ 3b0ad4c8-c190-11ec-25c0-937dc077cb1d
md"""The inner integral is the mass of a slice at a value along the $x$ axis. The center of mass is formed then by the mass times the distance from the origin. The center of mass is a "balance" point, in the sense that $\iint_R (x - \bar{x}) dA = 0$ and $\iint_R (y-\bar{y})dA = 0$.
"""

# ╔═╡ 3b0ad4fa-c190-11ec-02e8-31136c6e06f8
md"""For example, the center of mass of the upper half *unit* disc will have a centroid with $\bar{x} = 0$, by symmetry. We can see this by integrating in *Cartesian* coordinates, as follows
"""

# ╔═╡ 3b0ad50e-c190-11ec-2be1-8d4c1088ce02
md"""```math
~
\iint_R x dA = \int_{y=0}^1 \int_{x=-\sqrt{1-y^2}}^{\sqrt{1 - y^2}} x dx dy.
~
```
"""

# ╔═╡ 3b0ad590-c190-11ec-3f16-f9a9217d0e80
md"""The inner integral is $0$ as it an integral of an *odd* function over an interval symmetric about $0$.
"""

# ╔═╡ 3b0ad5ac-c190-11ec-326e-21e68310025b
md"""The value of $\bar{y}$ is found using polar coordinate transformation from:
"""

# ╔═╡ 3b0ad5c2-c190-11ec-127c-4d1e1ebf5818
md"""```math
~
\iint_R y dA = \int_{r=0}^1 \int_{\theta=0}^{\pi} (r\sin(\theta))r d\theta dr =
\int_{r=0}^1 r^2 dr \int_{\theta=0}^{\pi}\sin(\theta) = \frac{1}{3} \cdot 2.
~
```
"""

# ╔═╡ 3b0ad5f4-c190-11ec-15f0-25a8bac82bfc
md"""The third equals sign uses separability. The answer for $\bar{ is this value divided by the area, or $2/(3\pi)$.
"""

# ╔═╡ 3b0ad608-c190-11ec-0bb9-81d112246462
md"""##### Example: Moment of inertia
"""

# ╔═╡ 3b0ad68a-c190-11ec-2a79-83cb672f9449
md"""The moment of [inertia](https://en.wikipedia.org/wiki/Moment_of_inertia) of a point mass about an axis is $I = mr^2$ where $m$ is the mass and $r$ the distance to the axis. The moment of inertia of a body is the sum of the moment of inertia of each piece. If $R$ is a region in the $x$-$y$ plane with density $\rho(x,y)$ and the axis is the $y$ axis, then an approximate moment of inertia would be $\sum (x_i)^2\rho(x_i, y_i)\Delta x_i \Delta y_i$ which would lead to $I = \iint_R x^2\rho(x,y) dA$.
"""

# ╔═╡ 3b0ad6b4-c190-11ec-0fed-c5f897128c51
md"""Let $R$ be the half disc contained by $x^2 + y^2 = 1$ and $y \geq 0$. Let $\rho(x,y) = xy^2$. Find the moment of inertia.
"""

# ╔═╡ 3b0ad6bc-c190-11ec-0795-958e7cb5095d
md"""```math
R
```
"""

# ╔═╡ 3b0ad6d0-c190-11ec-1e62-f7bea7861a15
md"""is best described in polar coordinates, so we try to compute
"""

# ╔═╡ 3b0ad6e6-c190-11ec-109e-031ef3c867c8
md"""```math
~
\int_0^1 \int_{-\pi/2}^{\pi/2} (r\cos(\theta))^2 (r\cos(\theta))(r\sin(\theta)) r d\theta dr.
~
```
"""

# ╔═╡ 3b0ad6f8-c190-11ec-2d58-797e016d45f9
md"""That requires integrating $\sin^2(\theta)\cos^3(\theta)$, a doable task, but best left to SymPy:
"""

# ╔═╡ 3b0adc7a-c190-11ec-0615-07330101830d
let
	@syms r theta
	x = r*cos(theta)
	y = r*sin(theta)
	rho(x,y) = x*y^2
	integrate(x^2 * rho(x, y), (theta, -PI/2, PI/2), (r, 0, 1))
end

# ╔═╡ 3b0adc98-c190-11ec-2e51-a97db8ac576a
md"""##### Example
"""

# ╔═╡ 3b0adcca-c190-11ec-3397-f9f0295b6993
md"""(Strang) Find the moment of inertia about the $y$ axis of the unit square tilted *counter*-clockwise an angle $0 \leq \alpha \leq \pi/2$.
"""

# ╔═╡ 3b0adcf2-c190-11ec-2c23-339ee86fd120
md"""The counterclockwise rotation of the unit square is $G(u,v) = \langle \cos(\alpha)u-\sin(\alpha)v, \sin(\alpha)u + \cos(\alpha) v\rangle$. This comes from the above formula for clockwise rotation using $-\alpha$. This transformation has Jacobian determinant $1$, as the area is not deformed. With this, we have
"""

# ╔═╡ 3b0add06-c190-11ec-27e4-dbbdee92c5de
md"""```math
~
\iint_R x^2 dA = \iint_{G(U)} (f\circ G)(u) |\det(J_G(u))| dU,
~
```
"""

# ╔═╡ 3b0add1a-c190-11ec-2910-d7b34818e63c
md"""which is computed with:
"""

# ╔═╡ 3b0ae2b0-c190-11ec-34f3-a7ab843e2ba6
let
	@syms u v alpha
	f(x,y) = x^2
	G(u,v) = [cos(alpha)*u - sin(alpha)*v, sin(alpha)*u + cos(alpha)*v]
	Jac = det(G(u,v).jacobian([u,v])) |> simplify
	integrate(f(G(u,v)...) * Jac , (u,  0, 1), (v, 0, 1))
end

# ╔═╡ 3b0ae2ce-c190-11ec-232b-a5ca3d5b4477
md"""##### Example
"""

# ╔═╡ 3b0ae300-c190-11ec-1a6f-994a161bbde7
md"""Let $R$ be a ring with inner radius $4$ and outer radius $5$. Find its moment of inertia about the $y$ axis.
"""

# ╔═╡ 3b0ae314-c190-11ec-08cc-d5f03a8bdeea
md"""The integral to compute is:
"""

# ╔═╡ 3b0ae32a-c190-11ec-3b6a-7f18ee59968d
md"""```math
~
\iint_R x^2 dA,
~
```
"""

# ╔═╡ 3b0ae33c-c190-11ec-346c-494c6787415a
md"""with domain that is easy to describe in polar coordinates:
"""

# ╔═╡ 3b0ae7f4-c190-11ec-0dd4-790af6de51e1
let
	@syms r theta
	x = r*cos(theta)
	integrate(x^2 * r, (r, 4, 5), (theta, 0, 2PI))
end

# ╔═╡ 3b0ae88c-c190-11ec-18c9-d1717149b4fb
md"""### Three dimensional change of variables
"""

# ╔═╡ 3b0ae8f0-c190-11ec-3c8a-4f00a69f1616
md"""The change of variables formula is no different between dimensions $2$ and $3$ (or higher), but the question of suitable transformation is more involved as the dimensions increase. We stick here to a few widely used ones.
"""

# ╔═╡ 3b0ae922-c190-11ec-26e7-e5196a55d846
md"""#### Cylindrical coordinates
"""

# ╔═╡ 3b0ae95c-c190-11ec-37ee-ab7a4cdd8fc0
md"""Polar coordinates describe the $x$-$y$ plane in terms of a radius $r$ and angle $\theta$. *Cylindrical* coordinates describe the $x-y-z$ plane in terms of $r, \theta$, and $z$. A transformation is:
"""

# ╔═╡ 3b0ae97c-c190-11ec-0508-bd92a40dfaf9
md"""```math
~
G(r,\theta, z) = \langle r\cos(\theta), r\sin(\theta), z\rangle.
~
```
"""

# ╔═╡ 3b0ae99a-c190-11ec-3ca3-7ff502dcb1d6
md"""This has Jacobian determinant $r$, similar to polar coordinates.
"""

# ╔═╡ 3b0ae9ae-c190-11ec-11ec-cf8edd281aa7
md"""##### Example
"""

# ╔═╡ 3b0ae9ce-c190-11ec-2f54-273255b1cefc
md"""Returning to the volume of a cone above the $x$-$y$ plane under $z = a - b(x^2 + y^2)^{12}$. This yielded the integral in Cartesian coordinates:
"""

# ╔═╡ 3b0aea3a-c190-11ec-37ec-53769ac2f2de
md"""```math
~
\int_{x=-r}^r \int_{y=-\sqrt{r^2 - x^2}}^{\sqrt{r^2-x^2}} \int_0^{a - b(x^2 + y^2)} 1 dz dy dx,
~
```
"""

# ╔═╡ 3b0aea76-c190-11ec-01a8-9deb72346929
md"""where $r=a/b$. This is *much* simpler in Cylindrical coordinates, as the region is described by the rectangle in $(r, \theta)$: $[0, \sqrt{b/a}] \times [0, 2\pi]$ and the $z$ range is from $0$ to $a - b r$.
"""

# ╔═╡ 3b0aea8a-c190-11ec-0de6-956fc1425bd4
md"""The volume then is:
"""

# ╔═╡ 3b0aea92-c190-11ec-1f9b-1b4d081b973f
md"""```math
~
\int_{theta=0}^{2\pi} \int_{r=0}^{a/b} \int_{z=0}^{a - br} 1 r dz dr d\theta =
2\pi \int_{r=0}^{a/b} (a-br)r dr = \frac{\pi a^3}{3b^2}.
~
```
"""

# ╔═╡ 3b0aeab2-c190-11ec-01b3-37bdb332ccbe
md"""This is in agreement with $\pi r^2 h/3$.
"""

# ╔═╡ 3b0aeac6-c190-11ec-1d5a-cb13d8b773aa
md"""---
"""

# ╔═╡ 3b0aeae4-c190-11ec-38f1-f75fc425399e
md"""Find the centroid for the cone. First in the $x$ direction, $\iint_R x dV$ is found by:
"""

# ╔═╡ 3b0af17e-c190-11ec-3622-2daff2ebf229
let
	@syms r theta z a b
	f(x,y,z) = x
	x = r*cos(theta)
	y = r*sin(theta)
	Jac = r
	integrate(f(x,y,z) * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))
end

# ╔═╡ 3b0af214-c190-11ec-31ab-2fe7305cb56c
md"""That this is $0$ is no surprise. The same will be true for the $y$ direction, as the figure is symmetric about the plane $y=0$ and $x=0$. However, the $z$ direction is different:
"""

# ╔═╡ 3b0b1d5c-c190-11ec-04c7-d1200b9e0673
let
	@syms r theta z a b
	f(x,y,z) = z
	x = r*cos(theta)
	y = r*sin(theta)
	Jac = r
	A = integrate(f(x,y,z) * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))
	B = integrate(1 * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))
	A, B, A/B
end

# ╔═╡ 3b0b1e7e-c190-11ec-087b-9b31a05159ad
md"""The answer depends on the height through $a$, but *not* the size of the base, parameterized by $b$. To finish, the centroid is $\langle 0, 0, a/4\rangle$.
"""

# ╔═╡ 3b0b1eb0-c190-11ec-2f2e-c3d3924b0320
md"""##### Example
"""

# ╔═╡ 3b0b1ee2-c190-11ec-37e1-a555bde266e2
md"""A sphere of radius $2$ is intersected by a cylinder of radius $1$ along the $z$ axis. Find the volume of the intersection.
"""

# ╔═╡ 3b0b1f00-c190-11ec-1364-43e3d72b6f58
md"""We have $x^2 + y^2 + z^2 = 4$ or $z^2 = 4 - r^2$ in cylindrical coordinates. The integral then is:
"""

# ╔═╡ 3b0b27c0-c190-11ec-0369-73cb47e00f6a
let
	@syms r::real theta::real z::real
	integrate(1 * r, (z, -sqrt(4-r^2), sqrt(4-r^2)), (r, 0, 1), (theta, 0, 2PI))
end

# ╔═╡ 3b0b27fc-c190-11ec-14cf-6fd36b2d837c
md"""If instead of a fixed radius of $1$ we use $0 \leq a \leq 2$ we have:
"""

# ╔═╡ 3b0b2dea-c190-11ec-299e-355d6899fc29
let
	@syms a r theta
	integrate(1 * r, (z, -sqrt(4-r^2), sqrt(4-r^2)), (r, 0, a), (theta,0, 2PI))
end

# ╔═╡ 3b0b2e64-c190-11ec-1472-3beb0ba6e6c2
md"""#### Spherical integrals
"""

# ╔═╡ 3b0b2f36-c190-11ec-2edc-f78a2c04ce7c
md"""Spherical coordinates describe a point in space by a radius from the origin, $r$ or $\rho$; a azimuthal angle $\theta$ in $[0, 2\pi]$ and an *inclination* angle $\phi$ (also called polar angle) in $[0, \pi]$. The $z$ axis is the direction of the zenith and gives a reference line to define the inclination angle. The $x$-$y$ plane is the reference plane, with the $x$ axis giving a reference direction for the azimuth measurement.
"""

# ╔═╡ 3b0b2f5e-c190-11ec-03ad-05d2fcb81e6c
md"""The exact formula to relate $(\rho, \theta, \phi)$ to $(x,y,z)$ is given by
"""

# ╔═╡ 3b0b2fae-c190-11ec-01dd-bb12acdad2c9
md"""```math
~
G(\rho, \theta, \phi) = \rho \langle
\sin(\phi)\cos(\theta),
\sin(\phi)\sin(\theta),
\cos(\phi)
\rangle.
~
```
"""

# ╔═╡ 3b0b3670-c190-11ec-17df-e552d3715971
let
	imgfile = "figures/spherical-coordinates.png"
	caption = "Figure showing the parameterization by spherical coordinates. (Wikipedia)"
	
	ImageFile(:integral_vector_calculus, imgfile, caption)
end

# ╔═╡ 3b0b36a2-c190-11ec-0184-1589eedbfc35
md"""The Jacobian can be computed to be $\rho^2\sin(\phi)$.
"""

# ╔═╡ 3b0b6622-c190-11ec-1ecb-2b85c92edbc9
let
	@syms ρ theta phi
	G(ρ, theta, phi) = ρ * [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
	det(G(ρ, theta, phi).jacobian([ρ, theta, phi])) |> simplify |> abs
end

# ╔═╡ 3b0b66d8-c190-11ec-18f1-7f3d69018588
md"""##### Example
"""

# ╔═╡ 3b0b6744-c190-11ec-1a18-2b8f61426e3e
md"""Computing the volume of a sphere is a challenge (for SymPy) in Cartesian coordinates, but a breeze in spherical coordinates. Using $r^2\sin(\phi)$ as the multiplying factor, the volume is simply:
"""

# ╔═╡ 3b0b6776-c190-11ec-05b2-1de4b960993c
md"""```math
~
\int_{\theta=0}^{2\pi} \int_{\phi=0}^{\pi} \int_{r=0}^R 1 \cdot r^2 \sin(\phi) dr d\phi d\theta =
\int_{\theta=0}^{2\pi} d\theta \int_{\phi=0}^{\pi} \sin(\phi)d\phi \int_{r=0}^R  r^2 dr = (2\pi)(2)\frac{R^3}{3} = \frac{4\pi R^3}{3}.
~
```
"""

# ╔═╡ 3b0b67b2-c190-11ec-337e-052db1f77f31
md"""##### Example
"""

# ╔═╡ 3b0b67dc-c190-11ec-153f-ed95d151a212
md"""Compute the volume of the ellipsoid, $R$, described by $(x/a)^2 + (y/v)^2 + (z/c)^2 \leq 1$.
"""

# ╔═╡ 3b0b6802-c190-11ec-3a74-a168415997a1
md"""We first change variables via $G(u,v,w) = \langle ua, vb, wc \rangle$. This maps the unit sphere, $S$, given by $u^2 + v^2 + w^2 \leq 1$ into the ellipsoid. Then
"""

# ╔═╡ 3b0b6816-c190-11ec-3180-e9dadaa3ac8a
md"""```math
~
\iint_R 1 dV = \iint_S 1 |\det(J_G)| dU
~
```
"""

# ╔═╡ 3b0b6834-c190-11ec-3ca1-6fa5aa5ff71b
md"""But the Jacobian is a constant:
"""

# ╔═╡ 3b0b7126-c190-11ec-050e-2b1ddd5da189
let
	@syms u v w a b c
	G(u,v,w) = [u*a, v*b, w*c]
	det(G(u,v,w).jacobian([u,v,w]))
end

# ╔═╡ 3b0b7162-c190-11ec-21e8-67b4a3ea7d54
md"""So the answer is $abc V(S) = 4\pi abc/3$
"""

# ╔═╡ 3b0b7194-c190-11ec-3d52-6306e1d843b7
md"""## Questions
"""

# ╔═╡ 3b0b71d0-c190-11ec-1c14-e7177878c8bb
md"""###### Question
"""

# ╔═╡ 3b0b71f8-c190-11ec-1897-295cb837c0a2
md"""Suppose $f(x,y) = f_1(x)f_2(y)$ and $R = [a_1, b_1] \times [a_2,b_2]$ is a rectangular region. Is this true?
"""

# ╔═╡ 3b0b722a-c190-11ec-0a27-3788f2436a7b
md"""```math
~
\iint_R f dA = (\int_{a_1}^{b_1} f_1(x) dx) \cdot (\int_{a_2}^{b_2} f_2(y) dy).
~
```
"""

# ╔═╡ 3b0b7d60-c190-11ec-10fc-9df1ac04dfac
let
	choices = [
	L"Yes. As an inner integral $\int_{a^2}^{b_2} f(x,y) dy = f_1(x) \int_{a_2}^{b_2} f_2(y) dy$.",
	"No."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b0b7d88-c190-11ec-2a7c-a93d9f5960e2
md"""###### Question
"""

# ╔═╡ 3b0b7e14-c190-11ec-110b-39f08147a911
md"""Which integrals of the following are $0$ by symmetry? Let $R$ be the unit disc.
"""

# ╔═╡ 3b0b7e2a-c190-11ec-0a34-6723924d47e7
md"""```math
~
a = \iint_R x dA, \quad b = \iint_R (x^2 + y^2) dA, \quad c = \iint_R xy dA
~
```
"""

# ╔═╡ 3b0b879e-c190-11ec-3508-39d515bab867
let
	choices = [
	L"Both $a$ and $b$",
	L"Both $a$ and $c$",
	L"Both $b$ and $c$"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 3b0b87ba-c190-11ec-3486-3f147fd4ed51
md"""###### Question
"""

# ╔═╡ 3b0b87ec-c190-11ec-1663-f19304f2591f
md"""Let $R$ be the unit disc. Which integrals can be found from common geometric formulas (e.g., known formulas for the sphere, cone, pyramid, ellipse, ...)
"""

# ╔═╡ 3b0b87fe-c190-11ec-3419-fd097607122a
md"""```math
~
a = \iint_R (1 - (x^2+y2)) dA, \quad
b = \iint_R (1 - \sqrt{x^2 + y^2}) dA, \quad
c = \iint_R (1 - (x^2 + y^2)^2 dA
~
```
"""

# ╔═╡ 3b0b9106-c190-11ec-0ddb-af2dd2f76e16
let
	choices = [
	L"Both $a$ and $b$",
	L"Both $a$ and $c$",
	L"Both $b$ and $c$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b0b912e-c190-11ec-0468-7f0ce3dc4df0
md"""###### Question
"""

# ╔═╡ 3b0b91ba-c190-11ec-114a-d9d0d9745386
md"""Let the region $R$ be described by: in the first quadrant and bounded by $x^3 + y^3 = 1$. What integral below will **not** find the area of $R$?
"""

# ╔═╡ 3b0bc7a2-c190-11ec-1254-61b99a7dfc26
let
	choices = [
	raw" ``\int_0^1 \int_0^{(1-x^3)^{1/3}} 1\cdot dy dx``",
	raw" ``\int_0^1 \int_0^{(1-y^3)^{1/3}} 1\cdot dx dy``",
	raw" ``\int_0^1 \int_0^{(1-y^3)^{1/3}} 1\cdot dy dx``"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 3b0bc84c-c190-11ec-2466-7fa17c503046
md"""###### Question
"""

# ╔═╡ 3b117a4e-c190-11ec-1014-5b0e15c1a9fc
md"""Let $R$ be a triangular region with vertices $(0,0), (2,0), (1, b)$ where $b \geq 0$. What integral below computes the area of :R?
"""

# ╔═╡ 3b118d0e-c190-11ec-0b0c-87a342967877
let
	choices = [
	raw" ``\int_0^b\int_{y/b}^{2-y/b} dx dy``",
	raw" ``\int_0^2\int_0^{bx} dy dx``",
	raw" ``\int_0^2 \int_0^{2b - bx} dy dx``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b118d86-c190-11ec-2050-2d8d36dab9db
md"""###### Question
"""

# ╔═╡ 3b118dfe-c190-11ec-306b-270f4d59961a
md"""Let $f(x) \geq 0$ be an integrable function. The area under $f(x)$ over $[a,b]$, $\int_a^b f(x) dx$, is equivalent to?
"""

# ╔═╡ 3b119e8e-c190-11ec-0f65-8bda7ee4f0f4
let
	choices = [
	raw" ``\int_a^b \int_0^{f(x)} dy dx``",
	raw" ``\int_a^b \int_0^{f(x)} dx dy``",
	raw" ``\int_0^{f(x)} \int_a^b dx dy``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b119eca-c190-11ec-2722-0120c781bf0a
md"""###### Question
"""

# ╔═╡ 3b119f12-c190-11ec-21f3-ebb69c712034
md"""The region $R$ contained within  $|x| + |y| = 1$ is square, but not rectangular (in the sense of integration). What transformation of $S = [-1/2,1/2] \times [-1/2,1/2]$ will have $G(S) = R$?
"""

# ╔═╡ 3b11ac12-c190-11ec-328c-51f37807b6ba
let
	choices = [
	raw" ``G(u,v) = \langle u-v, u+v \rangle``",
	raw" ``G(u,v) = \langle u^2-v^2, u^2+v^2 \rangle``",
	raw" ``G(u,v) = \langle u-v, u \rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b11ac3a-c190-11ec-1627-6956eaec806f
md"""###### Question
"""

# ╔═╡ 3b11acb2-c190-11ec-33bb-df94fdc6ec7a
md"""Let $G(u,v) = \langle \cosh(u)\cos(v), \sinh(u)\sin(v) \rangle$. Using `ForwardDiff` find the determinant of the Jacobian at $[1,2]$.
"""

# ╔═╡ 3b11b680-c190-11ec-064f-4d4299b268a9
let
	G(u,v) = [cosh(u)*cos(v), sinh(u)*sin(v)]
	pt = [1,2]
	val = det(ForwardDiff.jacobian(v -> G(v...), [1,2]))
	numericq(val)
end

# ╔═╡ 3b11b6a8-c190-11ec-344c-0507c7e44e1b
md"""###### Question
"""

# ╔═╡ 3b11b6d0-c190-11ec-3c4b-ebd6720b3643
md"""Let $G(u, v) = \langle \cosh(u)\cos(v), \sinh(u)\sin(v) \rangle$. Compute the determinant of the Jacobian symbolically:
"""

# ╔═╡ 3b11d988-c190-11ec-1de7-3bca764a8289
let
	choices = [
	raw" ``\sin^{2}{\left (v \right )} \cosh^{2}{\left (u \right )} + \cos^{2}{\left (v \right )} \sinh^{2}{\left (u \right )}",
	raw" ``1``",
	raw" ``\sinh(u)\cosh(v)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b11d9c6-c190-11ec-335d-4bb9d60e177e
md"""###### Question
"""

# ╔═╡ 3b11db1a-c190-11ec-0be9-3fd631aa9353
md"""Compute the determinant of the Jacobian of the composition of a clockwise rotation by $\theta$, a reflection through the $x$ axis, and then a translation by $\langle a,b\rangle$, using the fact that the Jacobian determinant of *compositions* can be written as product of determinants of the individual Jacobians.
"""

# ╔═╡ 3b11e89c-c190-11ec-2402-a515a1fd8f99
let
	choices = [
	L"It is $1$, as each is area preserving",
	L"It is $r$, as the rotation uses polar coordinates",
	L"It is $r^2 \sin(\phi)$, as the rotations use spherical coordinates"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b11e8c6-c190-11ec-2105-89377d9a30ee
md"""###### Question
"""

# ╔═╡ 3b11e8f8-c190-11ec-3612-090baf12574c
md"""A wedge, $R$, is specified by $0 \leq r \leq a$, $0 \leq \theta \leq b$.
"""

# ╔═╡ 3b11efba-c190-11ec-1451-eda8a688a4a5
let
	@syms r theta a b
	x = r*cos(theta)
	y = r*sin(theta)
	A = integrate(r, (r, 0, a), (theta, 0, b))
	B = integrate(x * r, (r, 0, a), (theta, 0, b))
	C = integrate(y * r, (r, 0, a), (theta, 0, b))
end

# ╔═╡ 3b11efec-c190-11ec-0705-1511922d6814
md"""What does `A` compute?
"""

# ╔═╡ 3b11fd16-c190-11ec-3049-b9ba547723bf
let
	choices = [
	L"The area of $R$",
	L"The value $\bar{x}$ of the centroid",
	L"The value $\bar{y}$ of the centroid",
	L"The moment of inertia of $R$ about the $x$ axis"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 3b11fd48-c190-11ec-340e-afa857980343
md"""What does $B/A$ compute?
"""

# ╔═╡ 3b120a98-c190-11ec-272b-9d055de28d43
let
	choices = [
	L"The area of $R$",
	L"The value $\bar{x}$ of the centroid",
	L"The value $\bar{y}$ of the centroid",
	L"The moment of inertia of $R$ about the $x$ axis"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 3b120ab8-c190-11ec-0006-cffdee96e4dd
md"""###### Question
"""

# ╔═╡ 3b120b26-c190-11ec-1ca8-53bb8ec29fc3
md"""According to [Katz](http://www.jstor.org/stable/2689856) in 1899 Cartan formalized the subject of differential forms (elements such as $dx$ or $du$). Using the rules $dtdt = 0 = dv=dv$ and $dv dt = - dt dv$, what is the product of $dx=mdt + dv\sqrt{1-m^2}$ and $dy=dt\sqrt{1-m^2}-mdv$?
"""

# ╔═╡ 3b121580-c190-11ec-3690-c3f985a37a74
let
	choices = [
	raw" ``dtdv``",
	raw" ``(1-2m^2)dt dv``",
	raw" ``m\sqrt{1-m^2}dt^2+(1-2m^2)dtdv -m\sqrt{1-m^2}dv^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 3b1215b2-c190-11ec-307f-2dd6976b95e1
HTML("""<div class="markdown"><blockquote>
<p><a href="../alternatives/plotly_plotting.html">◅ previous</a>  <a href="../integral_vector_calculus/line_integrals.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integral_vector_calculus/double_triple_integrals.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 3b12160c-c190-11ec-3961-53e0c3ce1bee
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
# ╟─3b121594-c190-11ec-0476-43496024f3bf
# ╟─3b054738-c190-11ec-09ee-8fbee92e3a5e
# ╟─3b0548e6-c190-11ec-215e-1f02ad877e32
# ╠═3b0564fc-c190-11ec-094c-8175f3e1a827
# ╟─3b056d08-c190-11ec-3dc9-2d519df46694
# ╟─3b056fa6-c190-11ec-27d5-01d404b1225c
# ╟─3b05747e-c190-11ec-114a-0b85faa11668
# ╟─3b057604-c190-11ec-0ecd-33b903d8f2b9
# ╟─3b057672-c190-11ec-39f6-695a200cffe9
# ╟─3b05769a-c190-11ec-16a7-7345f28b2bfb
# ╟─3b0576b8-c190-11ec-33df-3b3ad75b83e2
# ╟─3b057776-c190-11ec-1bea-3934f22d0531
# ╟─3b057792-c190-11ec-0674-a7f1608940cf
# ╟─3b057988-c190-11ec-203c-ab6fb2e6dab8
# ╟─3b05b3e2-c190-11ec-1152-7585e2e11f94
# ╟─3b05bda8-c190-11ec-306c-a361fa594b82
# ╟─3b05bf1a-c190-11ec-1456-89181885f5db
# ╟─3b05c096-c190-11ec-1158-355a43bc2960
# ╟─3b05c14a-c190-11ec-38a2-33673d3ac525
# ╟─3b05c186-c190-11ec-2e39-054bfe9128b7
# ╟─3b05c1ae-c190-11ec-2601-0d204c30a704
# ╟─3b05eb7a-c190-11ec-18e0-41881be595a5
# ╟─3b05ec38-c190-11ec-1a7c-dfdd731c6a88
# ╟─3b062324-c190-11ec-0bda-33c1b3bb322a
# ╟─3b0623a6-c190-11ec-20c3-8b6f1d7c5a3f
# ╟─3b062400-c190-11ec-1354-950ba006bc61
# ╟─3b0647b4-c190-11ec-28e0-cd35af4bfb31
# ╟─3b064b74-c190-11ec-3311-3552fbe9db26
# ╟─3b064ba6-c190-11ec-0ad4-39a52a8766f9
# ╟─3b064c28-c190-11ec-30d5-733eb8a4d9c7
# ╟─3b064c5a-c190-11ec-009b-4171a04d484d
# ╟─3b064c8c-c190-11ec-3e07-a9b84209d638
# ╟─3b064d5e-c190-11ec-06b7-3b63abde3267
# ╟─3b064dfe-c190-11ec-0a08-edc61d2adb03
# ╟─3b064e26-c190-11ec-187f-f500c4f04afe
# ╟─3b064e94-c190-11ec-11a6-3f9821f2cc33
# ╟─3b064eb0-c190-11ec-02b7-492eb1af086b
# ╟─3b065018-c190-11ec-2733-0bbc744218ad
# ╟─3b065038-c190-11ec-3e2c-29b10a899417
# ╟─3b065100-c190-11ec-2414-33cb37259ba9
# ╟─3b06536c-c190-11ec-0660-e5a8ac074bab
# ╟─3b0653e4-c190-11ec-3e4d-a1017dcb3240
# ╟─3b065498-c190-11ec-3ffe-a7d6133e8012
# ╟─3b065538-c190-11ec-3594-d701cb3145e1
# ╠═3b066c94-c190-11ec-28a2-8599510c8afd
# ╟─3b066d02-c190-11ec-11d5-5767116940c4
# ╟─3b066d3c-c190-11ec-1bce-e18a34f927f8
# ╟─3b066e60-c190-11ec-3f76-ed81c6e631ed
# ╟─3b066e7e-c190-11ec-06fc-4b063d451250
# ╟─3b066f3c-c190-11ec-0ccc-db7907c4e5d5
# ╠═3b0677ac-c190-11ec-3e5e-1fec01cd4a97
# ╟─3b067892-c190-11ec-3c28-5f729c02aa4e
# ╠═3b06801c-c190-11ec-2eb9-459d4ed5dbdc
# ╟─3b0684cc-c190-11ec-244e-7b673c41c81d
# ╟─3b068544-c190-11ec-2ec9-c78d351b27aa
# ╠═3b06e112-c190-11ec-1729-27341e2eb63c
# ╟─3b06e1ba-c190-11ec-2e8a-5567f8cdf307
# ╠═3b06f8d0-c190-11ec-0b36-43a0abcf6150
# ╟─3b06f90c-c190-11ec-104c-55efc195a162
# ╠═3b07094c-c190-11ec-0058-bf5f44fdeb98
# ╟─3b070988-c190-11ec-2284-9730ee1ef594
# ╠═3b0742ae-c190-11ec-01ad-b139261736be
# ╟─3b0744c0-c190-11ec-12e1-67fd22c6785e
# ╟─3b074650-c190-11ec-1ad4-d321d60c3814
# ╟─3b074682-c190-11ec-0350-8ff9858a7c72
# ╠═3b076040-c190-11ec-1683-3b93a7abb61a
# ╟─3b076216-c190-11ec-0280-97b24ae8417a
# ╟─3b0777da-c190-11ec-163e-57c3355fc2d8
# ╟─3b07864a-c190-11ec-17a3-f9e4b4bbe29f
# ╟─3b0786a6-c190-11ec-0a0f-b1b7c43b6257
# ╟─3b0786ee-c190-11ec-0ce5-235b9b4dae2e
# ╟─3b0787a0-c190-11ec-101f-a9d9bcd9dfde
# ╟─3b0787f0-c190-11ec-3f7d-b5da2390063d
# ╟─3b078818-c190-11ec-18bd-655e41bb1053
# ╟─3b07b414-c190-11ec-2934-d906f17132e7
# ╟─3b07b482-c190-11ec-05bf-b9cc87ed321f
# ╟─3b07b4ee-c190-11ec-3451-adebb0930d3c
# ╟─3b07b50e-c190-11ec-0a65-fb73e31a5645
# ╟─3b07b540-c190-11ec-3f3b-2b5bcd896667
# ╟─3b07b554-c190-11ec-121b-d7cbe0dc26af
# ╟─3b07b66c-c190-11ec-027e-776649e3bce0
# ╟─3b07b6fa-c190-11ec-2d6d-b7b0722a5ad2
# ╟─3b07b716-c190-11ec-009a-1398eb1e128e
# ╟─3b07b72c-c190-11ec-169e-6d089c0d8068
# ╟─3b07d53e-c190-11ec-29d3-2fa2f619a5af
# ╟─3b07d606-c190-11ec-1722-ed0e63b40308
# ╟─3b07d74e-c190-11ec-2976-effcc41b4c45
# ╟─3b07d796-c190-11ec-3447-bff77b6d4748
# ╟─3b07d7c8-c190-11ec-3743-ad129381b3fe
# ╟─3b07d840-c190-11ec-2dd3-51168a64b06b
# ╟─3b07d94e-c190-11ec-31ca-69ca258cc7be
# ╟─3b07d976-c190-11ec-232c-3bbe6d02100e
# ╟─3b07d99e-c190-11ec-2437-c9350879f4ba
# ╟─3b07d9e4-c190-11ec-2ef0-4da9afa97a00
# ╟─3b07da66-c190-11ec-0ed5-bd57d2183481
# ╟─3b07e1e6-c190-11ec-1201-b7c00256b90e
# ╟─3b07e24a-c190-11ec-3f60-cbd8e966e7e5
# ╟─3b07e2d6-c190-11ec-3e40-532fa88c996d
# ╟─3b07e300-c190-11ec-2c28-2786c61fbfe3
# ╟─3b07e34e-c190-11ec-30cf-b57300a54158
# ╟─3b07e376-c190-11ec-1f97-13760572b4f8
# ╟─3b07e38a-c190-11ec-3694-8558cbedb342
# ╟─3b07e3da-c190-11ec-09bb-1718d1a47a2b
# ╟─3b07e420-c190-11ec-0f8d-857cce01a7df
# ╟─3b07e436-c190-11ec-06f8-a34a29831e6e
# ╟─3b07e448-c190-11ec-1065-3daa53a1bb19
# ╟─3b07e468-c190-11ec-397c-e32aa3a6795f
# ╟─3b07e4a2-c190-11ec-0834-7bcc46e01ae3
# ╟─3b07e4f2-c190-11ec-3517-d9f8067882cb
# ╟─3b07e51a-c190-11ec-060b-bf84531563fd
# ╠═3b08081a-c190-11ec-3056-17d91529ba23
# ╟─3b080890-c190-11ec-2d82-93ac9869cf4c
# ╟─3b0808b0-c190-11ec-3983-4be4fe8a3486
# ╠═3b082b74-c190-11ec-26cd-a534a444d969
# ╟─3b082bc6-c190-11ec-2771-07fcbf4d843e
# ╟─3b082c0a-c190-11ec-0042-97fc511aa114
# ╟─3b082c1e-c190-11ec-0313-b74415446ca7
# ╠═3b083aec-c190-11ec-20e4-393376b55c08
# ╟─3b083b3a-c190-11ec-18df-05800ee45af0
# ╟─3b083c18-c190-11ec-12a0-3128c7492d9e
# ╟─3b083c68-c190-11ec-0368-f3a13679a1a8
# ╠═3b08441c-c190-11ec-1d2c-79ee917fc86d
# ╟─3b084456-c190-11ec-279a-f743fadb09ca
# ╟─3b08465e-c190-11ec-3b65-cb78ef6fc55e
# ╟─3b084690-c190-11ec-3fc1-37064419461e
# ╠═3b0850d6-c190-11ec-3884-eb647d1b89cd
# ╟─3b085108-c190-11ec-1889-e330cda37633
# ╟─3b08514e-c190-11ec-3106-f51b27c7b474
# ╟─3b08525a-c190-11ec-1f71-abbec498ba62
# ╟─3b08528c-c190-11ec-1ddb-fd961fcdb24b
# ╠═3b087660-c190-11ec-1049-87244cc1718c
# ╟─3b0876c4-c190-11ec-1c16-23c26dd89372
# ╠═3b087f68-c190-11ec-27c3-3bd13979e5d8
# ╟─3b087fb6-c190-11ec-0957-ab6e65bb2ee0
# ╟─3b088092-c190-11ec-32b0-8bcea673866e
# ╟─3b0880c4-c190-11ec-0734-15fb22e10195
# ╟─3b0880fe-c190-11ec-2917-b50fe5e1b612
# ╟─3b0887b8-c190-11ec-07c2-c9eff612af87
# ╟─3b08881c-c190-11ec-33ac-5db5019a8c2e
# ╠═3b088e70-c190-11ec-32b9-7febae5b6e42
# ╟─3b088f0e-c190-11ec-3172-1fc90f0e997c
# ╟─3b088f60-c190-11ec-1c4e-33357cb3bad2
# ╟─3b088f92-c190-11ec-18e5-558580d5b246
# ╠═3b0895c8-c190-11ec-2a5e-d3d15852e598
# ╟─3b0895f0-c190-11ec-3d57-fb4cddab3707
# ╟─3b0896a4-c190-11ec-39c4-3d7359c4e787
# ╟─3b0896cc-c190-11ec-04a3-75f031ca335d
# ╠═3b08c5ca-c190-11ec-2ee0-e7e4ccedd310
# ╟─3b08c69c-c190-11ec-3e1a-8b3447aaeb88
# ╟─3b08c6ce-c190-11ec-3788-2b7c141894c6
# ╟─3b08c7be-c190-11ec-0295-758f437c8d1a
# ╟─3b08c7f0-c190-11ec-21ac-31daada5dccd
# ╟─3b08c818-c190-11ec-0382-7f8e64c0724e
# ╟─3b08c82e-c190-11ec-3d00-a7f39db956e1
# ╠═3b08d3bc-c190-11ec-0fba-0b758cb70572
# ╟─3b08d3ee-c190-11ec-036f-e314d382fdb4
# ╟─3b08d466-c190-11ec-3959-597531013bc0
# ╟─3b08d4ac-c190-11ec-3912-955bc575dbb7
# ╟─3b08d4fc-c190-11ec-291f-a70560162604
# ╠═3b08dea2-c190-11ec-13d2-230320d51066
# ╟─3b08dee8-c190-11ec-30f1-0bdc05a233ca
# ╟─3b08df9c-c190-11ec-3006-9949c222d574
# ╟─3b08dfce-c190-11ec-2e70-3d67c864b3e0
# ╟─3b09022e-c190-11ec-3f6e-236b268d14d6
# ╠═3b090e90-c190-11ec-07d8-a11c5369b4cd
# ╟─3b090efe-c190-11ec-18af-512f6804b3dc
# ╟─3b090f6c-c190-11ec-3a88-a713d796dd7b
# ╠═3b091b74-c190-11ec-000a-93b3c82f7536
# ╠═3b0925f6-c190-11ec-3dec-bb19b4c65785
# ╟─3b092628-c190-11ec-36a8-25e971ca8792
# ╟─3b092664-c190-11ec-26b7-93991bbedda7
# ╠═3b092c7a-c190-11ec-3577-fba5087f4653
# ╟─3b092cb8-c190-11ec-2f72-79273e063615
# ╟─3b092d1c-c190-11ec-2152-1f7002bf94e0
# ╟─3b092d50-c190-11ec-35a2-0f61f13fbcbc
# ╠═3b09379e-c190-11ec-0476-97c6e3f25e8c
# ╟─3b0937d0-c190-11ec-1f16-337525d75434
# ╟─3b093802-c190-11ec-3dc4-9726b16c104a
# ╠═3b0944be-c190-11ec-1fff-cb8575d92619
# ╟─3b0944e6-c190-11ec-1084-6f13bf213698
# ╠═3b096a7a-c190-11ec-39c2-f9b5ebdb7784
# ╟─3b096b3a-c190-11ec-144f-594b5c354688
# ╟─3b096bc4-c190-11ec-3f85-e9af8aa33eeb
# ╟─3b0977fe-c190-11ec-2d1c-09884c031b97
# ╟─3b09788a-c190-11ec-323f-bb9cf7b12260
# ╟─3b0979de-c190-11ec-2958-2128305d0c62
# ╠═3b09828c-c190-11ec-2d3c-094b5bd81451
# ╟─3b09835c-c190-11ec-2b30-4dbf00bb8c20
# ╟─3b098398-c190-11ec-2edf-b325d2e40d70
# ╠═3b098ab4-c190-11ec-1588-871a17e61d15
# ╟─3b098b5c-c190-11ec-0ec5-03607e644e5f
# ╟─3b098c12-c190-11ec-293e-ebc53835c773
# ╟─3b098c44-c190-11ec-2dc9-3b0ea4800a6f
# ╠═3b0992b6-c190-11ec-0f7f-0d6153845485
# ╟─3b0992f2-c190-11ec-0da7-13b77bf692eb
# ╟─3b0993f6-c190-11ec-2ff8-6932f697a21f
# ╟─3b099446-c190-11ec-1cf1-a9b1f74b955e
# ╟─3b099478-c190-11ec-2039-b1bb828cc1d3
# ╟─3b0994f0-c190-11ec-1b49-4bc7fa5df45f
# ╟─3b099534-c190-11ec-1017-bd72b749a703
# ╟─3b0995b8-c190-11ec-1411-8de0b851dbff
# ╟─3b0995d8-c190-11ec-19cd-bb7f5c7bbbdb
# ╟─3b0995ea-c190-11ec-2471-677247530860
# ╟─3b0995fe-c190-11ec-1003-a985a28f981e
# ╟─3b099630-c190-11ec-1278-637f57834193
# ╟─3b09966a-c190-11ec-3245-2168c7662e75
# ╟─3b0996b2-c190-11ec-24eb-454cdd157b69
# ╟─3b0996e4-c190-11ec-0700-0d1e239d48a1
# ╟─3b099766-c190-11ec-2d98-492f8b0579b9
# ╟─3b0997ca-c190-11ec-3520-b19793997f6a
# ╟─3b099856-c190-11ec-21f7-119c4851cc50
# ╟─3b0998d6-c190-11ec-0f57-57820e8f897f
# ╟─3b099950-c190-11ec-30f9-3373431a913d
# ╟─3b09a0e6-c190-11ec-1c86-a52856edddb9
# ╟─3b09a10c-c190-11ec-2d06-1d2bc737b494
# ╟─3b09a15c-c190-11ec-17ac-4d9789b75a73
# ╟─3b09a178-c190-11ec-0d04-a7a787b8a1a7
# ╠═3b09ae54-c190-11ec-1695-f1d7db82222b
# ╟─3b09aee0-c190-11ec-08fd-e7e8b11b45e7
# ╟─3b0a3e52-c190-11ec-1c7b-05a44e2eda1e
# ╟─3b0a3f54-c190-11ec-3637-c3620c622342
# ╟─3b0a4bf2-c190-11ec-03d4-c521e71e85cf
# ╟─3b0a4c38-c190-11ec-0b94-335fb1fdd41f
# ╟─3b0a56a6-c190-11ec-2d1e-8f478878123c
# ╟─3b0a56e2-c190-11ec-2679-a18c43959dcd
# ╟─3b0a5f84-c190-11ec-0f73-21ce8cae3555
# ╟─3b0a5fd4-c190-11ec-0ecd-2bf95dfaf851
# ╟─3b0a6006-c190-11ec-26ff-43fc924313d1
# ╟─3b0a6038-c190-11ec-0506-1f4bdb93f76b
# ╟─3b0a606a-c190-11ec-0a4c-8f415e7a1c6d
# ╟─3b0a6222-c190-11ec-134c-bdc31a1fb40f
# ╟─3b0a6240-c190-11ec-3201-0bc8c6eda15b
# ╟─3b0a6f22-c190-11ec-2c8e-17f8f78e6c6d
# ╟─3b0a6f74-c190-11ec-089e-c16d56017ea1
# ╟─3b0a6f9c-c190-11ec-0aa9-9d2ee0893ff2
# ╟─3b0a7046-c190-11ec-1644-496b8d15a673
# ╟─3b0a70dc-c190-11ec-1c30-7bd09aea610f
# ╟─3b0a710e-c190-11ec-1004-ff0c43419f64
# ╟─3b0a712e-c190-11ec-393f-d1f942a0a58c
# ╟─3b0a7168-c190-11ec-0e39-332f69c60ed9
# ╟─3b0a71c0-c190-11ec-041b-63023476eeae
# ╟─3b0a71d6-c190-11ec-3479-2b6920366a50
# ╟─3b0a7212-c190-11ec-1921-c594222fb1a6
# ╟─3b0a7244-c190-11ec-131b-b1e42414a72f
# ╟─3b0a7258-c190-11ec-0402-f1ea9da86626
# ╟─3b0a726c-c190-11ec-1fe1-41c8abd252ec
# ╟─3b0a7296-c190-11ec-19ef-ff10b7f03a6b
# ╟─3b0a7316-c190-11ec-0fc3-31cb03e92b9f
# ╟─3b0a7348-c190-11ec-0d37-0b1f70914398
# ╟─3b0a737a-c190-11ec-3492-99d4fee8a532
# ╟─3b0a738e-c190-11ec-3bfa-19378fe91639
# ╟─3b0a73b6-c190-11ec-2e89-1f8780a0915d
# ╟─3b0a73cc-c190-11ec-1d51-5fabc3197aa8
# ╟─3b0a749c-c190-11ec-2898-4fcb71da4fed
# ╟─3b0a7992-c190-11ec-3dbe-f3702c80070f
# ╟─3b0a7a3c-c190-11ec-20d9-27f66fbfa90a
# ╟─3b0a8036-c190-11ec-391e-b5eccd101df1
# ╟─3b0a80ea-c190-11ec-1208-8b9fa239fc34
# ╠═3b0a85a4-c190-11ec-0bf6-c9106d792e63
# ╟─3b0a988c-c190-11ec-1054-7708e8877acd
# ╟─3b0a98d2-c190-11ec-0bf2-af5173f57241
# ╟─3b0a998e-c190-11ec-3c4e-abbe5d521ee0
# ╟─3b0a9a3a-c190-11ec-13a5-371d91d4c5f8
# ╟─3b0a9ab2-c190-11ec-029a-a3c64c00be0c
# ╠═3b0aa39a-c190-11ec-082c-d74f8d385837
# ╟─3b0aa3e0-c190-11ec-1b76-6b7299cc5c1f
# ╟─3b0aa444-c190-11ec-08f9-07a20b4ee098
# ╟─3b0aa476-c190-11ec-0e69-73ea223295fb
# ╟─3b0aab88-c190-11ec-1232-0714963ebe6e
# ╟─3b0aabec-c190-11ec-107b-7130ad0e2759
# ╟─3b0aac16-c190-11ec-3c81-8d49e5d81082
# ╟─3b0aac48-c190-11ec-0f2a-5f6df85b99bc
# ╠═3b0ab402-c190-11ec-3ae1-cd47e4588744
# ╟─3b0ab42a-c190-11ec-06f4-b1f71643eb7f
# ╠═3b0aba06-c190-11ec-06d0-873487a898ce
# ╟─3b0aba60-c190-11ec-3418-1f9393c80696
# ╟─3b0aba92-c190-11ec-3dc2-3f80392ca9dd
# ╟─3b0abb3c-c190-11ec-1892-258130c628fb
# ╟─3b0abb64-c190-11ec-1588-9d5ff1e2d6c6
# ╟─3b0abba0-c190-11ec-204e-134f6c227c49
# ╟─3b0abbc8-c190-11ec-36ed-afe009d16cb7
# ╟─3b0abc04-c190-11ec-11ed-ed71b45c6562
# ╠═3b0ac2e4-c190-11ec-111f-e9848adb77cd
# ╟─3b0ac320-c190-11ec-20aa-d1be422ce9f3
# ╟─3b0ac38e-c190-11ec-28d8-83345807fc87
# ╟─3b0ac3c0-c190-11ec-0c29-a1c0dc8a0932
# ╠═3b0ac97e-c190-11ec-0077-b7df06bbca07
# ╟─3b0ac9a6-c190-11ec-34ac-bb2a390c554f
# ╟─3b0ac9d8-c190-11ec-37b8-514d4b233bc3
# ╟─3b0ad340-c190-11ec-1b50-51db6879edab
# ╟─3b0ad388-c190-11ec-0b40-f7e4571c4b30
# ╟─3b0ad3a6-c190-11ec-1e4f-e599ab6a8fa0
# ╟─3b0ad3e4-c190-11ec-3b8c-bb0e7f2052c8
# ╟─3b0ad400-c190-11ec-2980-958f8ad3a0af
# ╟─3b0ad41e-c190-11ec-177a-3ba61f0d0786
# ╟─3b0ad4a0-c190-11ec-0b93-fb8eeaa47349
# ╟─3b0ad4c8-c190-11ec-25c0-937dc077cb1d
# ╟─3b0ad4fa-c190-11ec-02e8-31136c6e06f8
# ╟─3b0ad50e-c190-11ec-2be1-8d4c1088ce02
# ╟─3b0ad590-c190-11ec-3f16-f9a9217d0e80
# ╟─3b0ad5ac-c190-11ec-326e-21e68310025b
# ╟─3b0ad5c2-c190-11ec-127c-4d1e1ebf5818
# ╟─3b0ad5f4-c190-11ec-15f0-25a8bac82bfc
# ╟─3b0ad608-c190-11ec-0bb9-81d112246462
# ╟─3b0ad68a-c190-11ec-2a79-83cb672f9449
# ╟─3b0ad6b4-c190-11ec-0fed-c5f897128c51
# ╟─3b0ad6bc-c190-11ec-0795-958e7cb5095d
# ╟─3b0ad6d0-c190-11ec-1e62-f7bea7861a15
# ╟─3b0ad6e6-c190-11ec-109e-031ef3c867c8
# ╟─3b0ad6f8-c190-11ec-2d58-797e016d45f9
# ╠═3b0adc7a-c190-11ec-0615-07330101830d
# ╟─3b0adc98-c190-11ec-2e51-a97db8ac576a
# ╟─3b0adcca-c190-11ec-3397-f9f0295b6993
# ╟─3b0adcf2-c190-11ec-2c23-339ee86fd120
# ╟─3b0add06-c190-11ec-27e4-dbbdee92c5de
# ╟─3b0add1a-c190-11ec-2910-d7b34818e63c
# ╠═3b0ae2b0-c190-11ec-34f3-a7ab843e2ba6
# ╟─3b0ae2ce-c190-11ec-232b-a5ca3d5b4477
# ╟─3b0ae300-c190-11ec-1a6f-994a161bbde7
# ╟─3b0ae314-c190-11ec-08cc-d5f03a8bdeea
# ╟─3b0ae32a-c190-11ec-3b6a-7f18ee59968d
# ╟─3b0ae33c-c190-11ec-346c-494c6787415a
# ╠═3b0ae7f4-c190-11ec-0dd4-790af6de51e1
# ╟─3b0ae88c-c190-11ec-18c9-d1717149b4fb
# ╟─3b0ae8f0-c190-11ec-3c8a-4f00a69f1616
# ╟─3b0ae922-c190-11ec-26e7-e5196a55d846
# ╟─3b0ae95c-c190-11ec-37ee-ab7a4cdd8fc0
# ╟─3b0ae97c-c190-11ec-0508-bd92a40dfaf9
# ╟─3b0ae99a-c190-11ec-3ca3-7ff502dcb1d6
# ╟─3b0ae9ae-c190-11ec-11ec-cf8edd281aa7
# ╟─3b0ae9ce-c190-11ec-2f54-273255b1cefc
# ╟─3b0aea3a-c190-11ec-37ec-53769ac2f2de
# ╟─3b0aea76-c190-11ec-01a8-9deb72346929
# ╟─3b0aea8a-c190-11ec-0de6-956fc1425bd4
# ╟─3b0aea92-c190-11ec-1f9b-1b4d081b973f
# ╟─3b0aeab2-c190-11ec-01b3-37bdb332ccbe
# ╟─3b0aeac6-c190-11ec-1d5a-cb13d8b773aa
# ╟─3b0aeae4-c190-11ec-38f1-f75fc425399e
# ╠═3b0af17e-c190-11ec-3622-2daff2ebf229
# ╟─3b0af214-c190-11ec-31ab-2fe7305cb56c
# ╠═3b0b1d5c-c190-11ec-04c7-d1200b9e0673
# ╟─3b0b1e7e-c190-11ec-087b-9b31a05159ad
# ╟─3b0b1eb0-c190-11ec-2f2e-c3d3924b0320
# ╟─3b0b1ee2-c190-11ec-37e1-a555bde266e2
# ╟─3b0b1f00-c190-11ec-1364-43e3d72b6f58
# ╠═3b0b27c0-c190-11ec-0369-73cb47e00f6a
# ╟─3b0b27fc-c190-11ec-14cf-6fd36b2d837c
# ╠═3b0b2dea-c190-11ec-299e-355d6899fc29
# ╟─3b0b2e64-c190-11ec-1472-3beb0ba6e6c2
# ╟─3b0b2f36-c190-11ec-2edc-f78a2c04ce7c
# ╟─3b0b2f5e-c190-11ec-03ad-05d2fcb81e6c
# ╟─3b0b2fae-c190-11ec-01dd-bb12acdad2c9
# ╟─3b0b3670-c190-11ec-17df-e552d3715971
# ╟─3b0b36a2-c190-11ec-0184-1589eedbfc35
# ╠═3b0b6622-c190-11ec-1ecb-2b85c92edbc9
# ╟─3b0b66d8-c190-11ec-18f1-7f3d69018588
# ╟─3b0b6744-c190-11ec-1a18-2b8f61426e3e
# ╟─3b0b6776-c190-11ec-05b2-1de4b960993c
# ╟─3b0b67b2-c190-11ec-337e-052db1f77f31
# ╟─3b0b67dc-c190-11ec-153f-ed95d151a212
# ╟─3b0b6802-c190-11ec-3a74-a168415997a1
# ╟─3b0b6816-c190-11ec-3180-e9dadaa3ac8a
# ╟─3b0b6834-c190-11ec-3ca1-6fa5aa5ff71b
# ╠═3b0b7126-c190-11ec-050e-2b1ddd5da189
# ╟─3b0b7162-c190-11ec-21e8-67b4a3ea7d54
# ╟─3b0b7194-c190-11ec-3d52-6306e1d843b7
# ╟─3b0b71d0-c190-11ec-1c14-e7177878c8bb
# ╟─3b0b71f8-c190-11ec-1897-295cb837c0a2
# ╟─3b0b722a-c190-11ec-0a27-3788f2436a7b
# ╟─3b0b7d60-c190-11ec-10fc-9df1ac04dfac
# ╟─3b0b7d88-c190-11ec-2a7c-a93d9f5960e2
# ╟─3b0b7e14-c190-11ec-110b-39f08147a911
# ╟─3b0b7e2a-c190-11ec-0a34-6723924d47e7
# ╟─3b0b879e-c190-11ec-3508-39d515bab867
# ╟─3b0b87ba-c190-11ec-3486-3f147fd4ed51
# ╟─3b0b87ec-c190-11ec-1663-f19304f2591f
# ╟─3b0b87fe-c190-11ec-3419-fd097607122a
# ╟─3b0b9106-c190-11ec-0ddb-af2dd2f76e16
# ╟─3b0b912e-c190-11ec-0468-7f0ce3dc4df0
# ╟─3b0b91ba-c190-11ec-114a-d9d0d9745386
# ╟─3b0bc7a2-c190-11ec-1254-61b99a7dfc26
# ╟─3b0bc84c-c190-11ec-2466-7fa17c503046
# ╟─3b117a4e-c190-11ec-1014-5b0e15c1a9fc
# ╟─3b118d0e-c190-11ec-0b0c-87a342967877
# ╟─3b118d86-c190-11ec-2050-2d8d36dab9db
# ╟─3b118dfe-c190-11ec-306b-270f4d59961a
# ╟─3b119e8e-c190-11ec-0f65-8bda7ee4f0f4
# ╟─3b119eca-c190-11ec-2722-0120c781bf0a
# ╟─3b119f12-c190-11ec-21f3-ebb69c712034
# ╟─3b11ac12-c190-11ec-328c-51f37807b6ba
# ╟─3b11ac3a-c190-11ec-1627-6956eaec806f
# ╟─3b11acb2-c190-11ec-33bb-df94fdc6ec7a
# ╟─3b11b680-c190-11ec-064f-4d4299b268a9
# ╟─3b11b6a8-c190-11ec-344c-0507c7e44e1b
# ╟─3b11b6d0-c190-11ec-3c4b-ebd6720b3643
# ╟─3b11d988-c190-11ec-1de7-3bca764a8289
# ╟─3b11d9c6-c190-11ec-335d-4bb9d60e177e
# ╟─3b11db1a-c190-11ec-0be9-3fd631aa9353
# ╟─3b11e89c-c190-11ec-2402-a515a1fd8f99
# ╟─3b11e8c6-c190-11ec-2105-89377d9a30ee
# ╟─3b11e8f8-c190-11ec-3612-090baf12574c
# ╟─3b11efba-c190-11ec-1451-eda8a688a4a5
# ╟─3b11efec-c190-11ec-0705-1511922d6814
# ╟─3b11fd16-c190-11ec-3049-b9ba547723bf
# ╟─3b11fd48-c190-11ec-340e-afa857980343
# ╟─3b120a98-c190-11ec-272b-9d055de28d43
# ╟─3b120ab8-c190-11ec-0006-cffdee96e4dd
# ╟─3b120b26-c190-11ec-1ca8-53bb8ec29fc3
# ╟─3b121580-c190-11ec-3690-c3f985a37a74
# ╟─3b1215b2-c190-11ec-307f-2dd6976b95e1
# ╟─3b1215bc-c190-11ec-27a3-6fcbe18fa4f8
# ╟─3b12160c-c190-11ec-3961-53e0c3ce1bee
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
