### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 12f572c8-70e0-11ec-05b7-53a347568035
begin
	using CalculusWithJulia
	using Plots
	using Roots
	using QuadGK
	using SymPy
end

# ╔═╡ 12f57610-70e0-11ec-1dfa-812d7099d48a
begin
	using CalculusWithJulia.WeaveSupport
	using LaTeXStrings
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 12fa8a7e-70e0-11ec-074a-4d0623d29013
using PlutoUI

# ╔═╡ 12fa8a60-70e0-11ec-1a50-3ba6409cb85e
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 12f56cba-70e0-11ec-2d5b-fd2fa5d27dc3
md"""# Area between two curves
"""

# ╔═╡ 12f56cec-70e0-11ec-0b1e-6f383be2d557
md"""This section uses these add-on packages:
"""

# ╔═╡ 12f57642-70e0-11ec-3e18-d5d4fd9499ee
md"""---
"""

# ╔═╡ 12f57692-70e0-11ec-1598-9bc48d51c456
md"""The definite integral gives the "signed" area between the function $f(x)$ and the $x$-axis over $[a,b]$. Conceptually, this is the area between two curves, $f(x)$ and $g(x)=0$. More generally, this integral:
"""

# ╔═╡ 12f576ba-70e0-11ec-1550-4ff197c2927c
md"""```math
\int_a^b (f(x) - g(x)) dx
```
"""

# ╔═╡ 12f576e0-70e0-11ec-1ad0-0fe7e21b6fb5
md"""can be interpreted as the "signed" area between $f(x)$ and $g(x)$ over $[a,b]$. If on this interval $[a,b]$ it is true that $f(x) \geq g(x)$, then this would just be the area, as seen in this figure. The rectangle in the figure has area: $(f(a)-g(a)) \cdot (b-a)$ which could be a term in a left Riemann sum of the integral of $f(x) - g(x)$:
"""

# ╔═╡ 12f57c32-70e0-11ec-1848-553d48e7b68c
let
	f1(x) = x^2
	g1(x) = sqrt(x)
	a,b = 1/4, 3/4
	
	xs = range(a, stop=b, length=250)
	ss = vcat(xs, reverse(xs))
	ts = vcat(f1.(xs), g1.(reverse(xs)))
	
	plot(f1, 0, 1, legend=false)
	plot!(g1)
	plot!(ss, ts, fill=(0, :red))
	plot!(xs, f1.(xs), linewidth=5, color=:green)
	plot!(xs, g1.(xs), linewidth=5, color=:green)
	
	
	plot!(xs, f1.(xs), legend=false, linewidth=5, color=:blue)
	plot!(xs, g1.(xs), linewidth=5, color=:blue)
	u,v = .4, .5
	plot!([u,v,v,u,u], [f1(u), f1(u), g1(u), g1(u), f1(u)], color=:black, linewidth=3)
end

# ╔═╡ 12f57c64-70e0-11ec-0a37-81f0c83655b4
md"""For the figure, we have $f(x) = \sqrt{x}$, $g(x)= x^2$ and $[a,b] = [1/4, 3/4]$. The shaded area is then found by:
"""

# ╔═╡ 12f57c78-70e0-11ec-04a1-4dd5e5756fcf
md"""```math
\int_{1/4}^{3/4} (x^{1/2} - x^2) dx = (\frac{x^{3/2}}{3/2} - \frac{x^3}{3})\big|_{1/4}^{3/4} = \frac{\sqrt{3}}{4} -\frac{7}{32}.
```
"""

# ╔═╡ 12f82cdc-70e0-11ec-0221-8151582f7a04
md"""#### Examples
"""

# ╔═╡ 12f82d4c-70e0-11ec-2280-53e0df6e4e66
md"""Find the area bounded by the line $y=2x$ and the curve $y=2 - x^2$.
"""

# ╔═╡ 12f82d60-70e0-11ec-1491-23ce83fd714e
md"""We can plot to see the area in question:
"""

# ╔═╡ 12f834d6-70e0-11ec-1522-d7fa68212890
begin
	f(x) = 2 - x^2
	g(x) = 2x
	plot(f, -3,3)
	plot!(g)
end

# ╔═╡ 12f83512-70e0-11ec-3977-0f7167187d39
md"""For this problem we need to identify $a$ and $b$. These are found numerically through:
"""

# ╔═╡ 12f83ae4-70e0-11ec-1619-75086e39bb98
a,b = find_zeros(x -> f(x) - g(x), -3, 3)

# ╔═╡ 12f83b02-70e0-11ec-002b-b98d9ac2d2ef
md"""The answer then can be found numerically:
"""

# ╔═╡ 12f83eb8-70e0-11ec-3652-7f83abe12b85
quadgk(x -> f(x) - g(x), a, b)[1]

# ╔═╡ 12f83ef2-70e0-11ec-36da-2d57e6dfd9e4
md"""##### Example
"""

# ╔═╡ 12f83f26-70e0-11ec-3bc7-f740056ad263
md"""Find the integral between $f(x) = \sin(x)$ and $g(x)=\cos(x)$ over $[0,2\pi]$ where $f(x) \geq g(x)$.
"""

# ╔═╡ 12f83f30-70e0-11ec-3aeb-adbb6443bb61
md"""A plot shows the areas:
"""

# ╔═╡ 12f8430e-70e0-11ec-0fd3-d13bb13b2d31
begin
	𝒇(x) = sin(x)
	𝒈(x) = cos(x)
	plot(𝒇, 0, 2pi)
	plot!(𝒈)
end

# ╔═╡ 12f8432c-70e0-11ec-1538-77deeeacbcee
md"""There is a single interval when $f \geq g$ and this can be found algebraically using basic trigonometry, or numerically:
"""

# ╔═╡ 12f84a5c-70e0-11ec-0cd3-c3911535f174
begin
	𝒂,𝒃 = find_zeros(x -> 𝒇(x) - 𝒈(x), 0, 2pi)  # pi/4, 5pi/4
	quadgk(x -> 𝒇(x) - 𝒈(x), 𝒂, 𝒃)[1]
end

# ╔═╡ 12f84a7a-70e0-11ec-1484-e53a8e80be3f
md"""##### Example
"""

# ╔═╡ 12f84aa4-70e0-11ec-3ff4-1353fecd1dc2
md"""Find the area between $x^n$ and $x^{n+1}$ over $[0,1]$ for $n=1,2,\dots$.
"""

# ╔═╡ 12f84ac0-70e0-11ec-34b5-c1a640bb7167
md"""We have on this interval $x^n \geq x^{n+1}$, so the integral can be found symbolically through:
"""

# ╔═╡ 12f84f52-70e0-11ec-20d7-41353c203b7c
begin
	@syms x::positive n::positive
	ex = integrate(x^n - x^(n+1), (x, 0, 1))
	together(ex)
end

# ╔═╡ 12f84f70-70e0-11ec-37df-ab99e6f879e5
md"""Based on this answer, what is the value of this
"""

# ╔═╡ 12f84f8e-70e0-11ec-0103-1f7bdf11d5a4
md"""```math
\frac{1}{2\cdot 3} + \frac{1}{3\cdot 4} + \frac{1}{4\cdot 5} + \cdots?
```
"""

# ╔═╡ 12f84fac-70e0-11ec-24bc-07042abe662c
md"""This should should be no surprise, given how the areas computed carve up the area under the line $y=x^1$ over $[0,1]$, so the answer should be $1/2$.
"""

# ╔═╡ 12f8548e-70e0-11ec-0584-819c0fd118ff
begin
	p = plot(x, 0, 1, legend=false)
	[plot!(p, x^n, 0, 1) for n in 2:20]
	p
end

# ╔═╡ 12f854c0-70e0-11ec-324d-4ffdb3117f4a
md"""We can check using the `summation` function of `SymPy` which is similar in usage to `integrate`:
"""

# ╔═╡ 12f85abc-70e0-11ec-2644-61ed82545e3a
summation(1/(n+1)/(n+2), (n, 1, oo))

# ╔═╡ 12f85ace-70e0-11ec-12ad-3d4edf73f714
md"""##### Example
"""

# ╔═╡ 12f85b20-70e0-11ec-26ca-eb816a0fceff
md"""Verify [Archimedes'](http://en.wikipedia.org/wiki/The_Quadrature_of_the_Parabola) finding that the area of the parabolic segment is $4/3$rds that of the triangle joining $a$, $(a+b)/2$ and $b$.
"""

# ╔═╡ 12f85f7e-70e0-11ec-2244-3d05d8496fdc
let
	f(x) = 2 - x^2
	a,b = -1, 1/2
	c = (a + b)/2
	xs = range(-sqrt(2), stop=sqrt(2), length=50)
	rxs = range(a, stop=b, length=50)
	rys = map(f, rxs)
	
	
	plot(f, a, b, legend=false, linewidth=3)
	xs = [a,c,b,a]
	plot!(xs, f.(xs), linewidth=3)
end

# ╔═╡ 12f85fa6-70e0-11ec-3cc4-4ff5a0ae5329
md"""For concreteness, let $f(x) = 2-x^2$ and $[a,b] = [-1, 1/2]$, as in the figure. Then the area of the triangle can be computed through:
"""

# ╔═╡ 12f86424-70e0-11ec-0734-977e6a8ce38f
begin
	𝐟(x) = 2 - x^2
	𝐚, 𝐛 = -1, 1/2
	𝐜 = (𝐚 + 𝐛)/2
	
	sac, sab, scb = secant(𝐟, 𝐚, 𝐜), secant(𝐟, 𝐚, 𝐛), secant(𝐟, 𝐜, 𝐛)
	f1(x) = min(sac(x), scb(x))
	f2(x) = sab(x)
	
	A1 = quadgk(x -> f1(x) - f2(x), 𝐚, 𝐛)[1]
end

# ╔═╡ 12f86462-70e0-11ec-3b3c-df7fa0a20e4a
md"""As we needed three secant lines, we used the `secant` function from `CalculusWithJulia` to create functions representing each. Once that was done, we used the `max` function to facilitate integrating over the top bounding curve, alternatively, we could break the integral over $[a,c]$ and $[c,b]$.
"""

# ╔═╡ 12f8647e-70e0-11ec-022a-7f42d208ef94
md"""The area of the parabolic segment is more straightforward.
"""

# ╔═╡ 12f868de-70e0-11ec-15e0-4b61d193277d
A2 = quadgk(x -> 𝐟(x) - f2(x), 𝐚, 𝐛)[1]

# ╔═╡ 12f86906-70e0-11ec-31a3-77379eebcaac
md"""Finally, if Archimedes was right, this relationship should bring about $0$ (or something within round-off error):
"""

# ╔═╡ 12f86b72-70e0-11ec-1361-67867f187878
A1 * 4/3 - A2

# ╔═╡ 12f86b86-70e0-11ec-2b45-3b1c8fc31199
md"""##### Example
"""

# ╔═╡ 12f86bae-70e0-11ec-355c-796e165eb430
md"""Find the area bounded by $y=x^4$ and $y=e^x$ when $x^4 \geq e^x$ and $x > 0$.
"""

# ╔═╡ 12f86bc2-70e0-11ec-1858-2f29e540f49c
md"""A graph  over $[0,10]$ shows clearly the largest zero, for afterwards the exponential dominates the power.
"""

# ╔═╡ 12f86f96-70e0-11ec-2429-f328bf2b6b9e
begin
	h1(x) = x^4
	h2(x) = exp(x)
	plot(h1, 0, 10)
	plot!(h2)
end

# ╔═╡ 12f86fc8-70e0-11ec-108d-4bd8c4b718e0
md"""There must be another zero, though it is hard to see from the graph over $[0,10]$, as $0^4=0$ and $e^0=1$, so the polynomial must cross below the exponential to the left of $5$. (Otherwise, plotting over $[0,2]$ will clearly reveal the other zero.) We now find these intersection points numerically and then integrate:
"""

# ╔═╡ 12f875d6-70e0-11ec-0eda-c7c8f88ca656
let
	a,b = find_zeros(x -> h1(x) - h2(x), 0, 10)
	quadgk(x -> h1(x) - h2(x), a, b)[1]
end

# ╔═╡ 12f875ea-70e0-11ec-1f41-57e70ab80101
md"""##### Examples
"""

# ╔═╡ 12f87626-70e0-11ec-012d-d128a5589aa6
md"""The area between $y=\sin(x)$ and $y=m\cdot x$ between $0$ and the first positive intersection depends on $m$ (where $0 \leq m \leq 1$. The extremes are when $m=0$, the area is $2$ and when $m=1$ (the line is tangent at $x=0$), the area is $0$. What is it for other values of $m$? The picture for $m=1/2$ is:
"""

# ╔═╡ 12f879e6-70e0-11ec-051a-a182b60d0cf2
begin
	m = 1/2
	plot(sin, 0, pi)
	plot!(x -> m*x)
end

# ╔═╡ 12f87a0e-70e0-11ec-2bce-533dd8d6d676
md"""For a given $m$, the area is found after computing $b$, the intersection point. We express this as a function of $m$ for later reuse:
"""

# ╔═╡ 12f8808a-70e0-11ec-08ad-4372b6a6bf5d
begin
	intersection_point(m) = maximum(find_zeros(x -> sin(x) - m*x, 0, pi))
	a1 = 0
	b1 = intersection_point(m)
	quadgk(x -> sin(x) - m*x, a1, b1)[1]
end

# ╔═╡ 12f880a8-70e0-11ec-12c1-4de2ac6563bf
md"""In general, the area then as a function of `m` is found by substituting `intersection_point(m)` for `b`:
"""

# ╔═╡ 12f88602-70e0-11ec-2402-ffd8f649af45
area(m) = quadgk(x -> sin(x) - m*x, 0, intersection_point(m))[1]

# ╔═╡ 12f8861e-70e0-11ec-3083-0bfd81528621
md"""A plot shows the relationship:
"""

# ╔═╡ 12f887d8-70e0-11ec-163d-09e4bc6f33ad
plot(area, 0, 1)

# ╔═╡ 12f88800-70e0-11ec-199e-ade418e9c1c3
md"""While here, let's also answer the question of which $m$ gives an area of $1$, or one-half the total? This can be done as follows:
"""

# ╔═╡ 12f88c24-70e0-11ec-387f-25d025ddb854
find_zero(m -> area(m) - 1, (0, 1))

# ╔═╡ 12f88c4c-70e0-11ec-051d-1da81ee01a97
md"""(Which is a nice combination of using `find_zeros`, `quadgk` and `find_zero` to answer a problem.)
"""

# ╔═╡ 12f88c62-70e0-11ec-1de0-f1afa107b618
md"""##### Example
"""

# ╔═╡ 12f88c7e-70e0-11ec-3487-e3e0ea8e1b2a
md"""Find the area bounded by the $x$ axis, the line $x-1$ and the function $\log(x+1)$.
"""

# ╔═╡ 12f88c94-70e0-11ec-1fe8-bbafaffa60e7
md"""A plot shows us the basic area:
"""

# ╔═╡ 12f8911a-70e0-11ec-3678-13c6a20f56d0
begin
	j1(x) = log(x+1)
	j2(x) = x - 1
	plot(j1, 0, 3)
	plot!(j2)
	plot!(zero)
end

# ╔═╡ 12f89142-70e0-11ec-3cf4-7955b6714dad
md"""The value for "$b$" is found from the intersection point of  $\log(x+1)$ and $x-1$, which is near $2$:
"""

# ╔═╡ 12f89494-70e0-11ec-0029-d9147b3b4d4c
begin
	ja = 0
	jb = find_zero(x -> j1(x) - j2(x), 2)
end

# ╔═╡ 12f894bc-70e0-11ec-17b5-6391318fd5ee
md"""We see that the lower part of the area has a condition: if $x < 1$ then use $0$, otherwise use $g(x)$. We can handle this many different ways:
"""

# ╔═╡ 12f89584-70e0-11ec-0d5a-3fdcc9dafbc5
md"""  * break the integral into two pieces and add:
"""

# ╔═╡ 12f89cc8-70e0-11ec-0367-61dfb611d411
quadgk(x -> j1(x) - zero(x), ja, 1)[1] + quadgk(x -> j1(x) - j2(x), 1, jb)[1]

# ╔═╡ 12f89d18-70e0-11ec-321c-85117535c5c5
md"""  * make a new function for the bottom bound:
"""

# ╔═╡ 12f8a2ea-70e0-11ec-0109-27bee21cd290
begin
	j3(x) = x < 1 ? 0.0 : j2(x)
	quadgk(x -> j1(x) - j3(x), ja, jb)[1]
end

# ╔═╡ 12f8a34e-70e0-11ec-0b09-5fa271980fdd
md"""  * Turn the picture on its side and integrate in the $y$ variable. To do this, we need to solve for inverse functions:
"""

# ╔═╡ 12f8a6a0-70e0-11ec-0bc3-3b485ce21d62
let
	a1=j1(ja)
	b1=j1(jb)
	f1(y)=y+1                # y=x-1, so x=y+1
	g1(y)=exp(y)-1           # y=log(x+1) so e^y = x + 1, x = e^y - 1
	quadgk(y -> f1(y) - g1(y), a1, b1)[1]
end

# ╔═╡ 12f8b082-70e0-11ec-1cf8-95ed8681dce9
note("""

When doing problems by hand this latter style can often reduce the complications, but when approaching the task numerically, the first two styles are generally easier, though computationally more expensive.

""")

# ╔═╡ 12f8b0b4-70e0-11ec-1e15-21fff63911b3
md"""#### Integrating in different directions
"""

# ╔═╡ 12f8b0d2-70e0-11ec-17b4-3d136438ad55
md"""The last example suggested integrating in the $y$ variable. This could have more explanation.
"""

# ╔═╡ 12f8b0f0-70e0-11ec-2c2c-91ac973faac3
md"""It has been noted that different symmetries can aid in computing integrals through their interpretation as areas. For example, if $f(x)$ is odd, then $\int_{-b}^b f(x)dx=0$ and if $f(x)$ is even, $\int_{-b}^b f(x) dx = 2\int_0^b f(x) dx$.
"""

# ╔═╡ 12f8b118-70e0-11ec-15eb-e5696fcd053f
md"""Another symmetry of the $x-y$ plane is the reflection through the line $y=x$. This has the effect of taking the graph of $f(x)$ to the graph of $f^{-1}(x)$ and vice versa. Here is an example with $f(x) = x^3$ over $[-1,1]$.
"""

# ╔═╡ 12f8b4e2-70e0-11ec-1ebe-0b8970f47fc6
let
	f(x) = x^3
	xs = range(-1, stop=1, length=50)
	ys = f.(xs)
	plot(ys, xs)
end

# ╔═╡ 12f8b50a-70e0-11ec-2f7c-3d816e363707
md"""By switching the order of the `xs` and `ys` we "flip" the graph through the line $x=y$.
"""

# ╔═╡ 12f8b528-70e0-11ec-1a6f-b1936f4d179c
md"""We can use this symmetry to our advantage. Suppose instead of being given an equation $y=f(x)$, we are given it in "inverse" style: $x = f(y)$, for example suppose we have $x = y^3$. We can plot this as above via:
"""

# ╔═╡ 12f8bb54-70e0-11ec-3a41-8bf2330aebce
let
	ys = range(-1, stop=1, length=50)
	xs = [y^3 for y in ys]
	plot(xs, ys)
end

# ╔═╡ 12f8bb90-70e0-11ec-1e12-e9a5c0912893
md"""Suppose we wanted the area in the first quadrant between this graph, the $y$ axis and the line $y=1$. What to do? With the problem "flipped" through the $y=x$ line, this would just be $\int_0^1 x^3dx$. Rather than mentally flipping the picture to integrate, instead we can just integrate in the $y$ variable. That is, the area is  $\int_0^1 y^3 dy$. The mental picture for Riemann sums would be have the approximating rectangles laying flat and as a function of $y$, are given a length of $y^3$ and height of "$dy$".
"""

# ╔═╡ 12f8bbae-70e0-11ec-165e-5985852c9af8
md"""---
"""

# ╔═╡ 12f8c090-70e0-11ec-3815-1192b21920a5
let
	f(x) = x^(1/3)
	f⁻¹(x) = x^3
	plot(f, 0, 1, label="f", linewidth=5, color=:blue, aspect_ratio=:equal)
	plot!([0,1,1],[0,0,1], linewidth=1, linestyle=:dash, label="")
	x₀ = 2/3
	Δ = 1/16
	col = RGBA(0,0,1,0.25)
	function box(x,y,Δₓ, Δ, color=col)
		plot!([x,x+Δₓ, x+Δₓ, x, x], [y,y,y+Δ,y+Δ,y], color=:black, label="")
		plot!(x:Δₓ:(x+Δₓ), u->y, fillto = u->y+Δ, color=col, label="")
	end
	box(x₀, 0, Δ, f(x₀), col)
	box(x₀+Δ, 0, Δ, f(x₀+Δ), col)
	box(x₀+2Δ, 0, Δ, f(x₀+2Δ), col)
	colᵣ = RGBA(1,0,0,0.25)
	box(f⁻¹(x₀-0Δ), x₀-1Δ, 1 - f⁻¹(x₀-0Δ), Δ, colᵣ)
	box(f⁻¹(x₀-1Δ), x₀-2Δ, 1 - f⁻¹(x₀-1Δ), Δ, colᵣ)
	box(f⁻¹(x₀-2Δ), x₀-3Δ, 1 - f⁻¹(x₀-2Δ), Δ, colᵣ)
end

# ╔═╡ 12f8c0b8-70e0-11ec-1bc4-4bc8ce1799f8
md"""The figure above suggests that the area under $f(x)$ over $[a,b]$ could be represented as the area between the curves $f^{-1}(y)$ and $y=b$ from $[f(a), f(b)]$.
"""

# ╔═╡ 12f8c0cc-70e0-11ec-34d9-cf9afcdc61af
md"""---
"""

# ╔═╡ 12f8c0e0-70e0-11ec-312b-1ffe5e1a4104
md"""For a less trivial problem, consider the area between $x = y^2$ and $x = 2-y$ in the first quadrant.
"""

# ╔═╡ 12f8c69e-70e0-11ec-3820-71b1872bf166
let
	ys = range(0, stop=2, length=50)
	xs = [y^2 for y in ys]
	plot(xs, ys)
	xs = [2-y for y in ys]
	plot!(xs, ys)
	plot!(zero)
end

# ╔═╡ 12f8c6da-70e0-11ec-380e-b96a1662834b
md"""We see the bounded area could be described in the "$x$" variable in terms of two integrals, but in the $y$ variable in terms of the difference of two functions with the limits of integration running from $y=0$ to $y=1$. So, this area may be found as follows:
"""

# ╔═╡ 12f8cac2-70e0-11ec-1b9b-9b1b3ee62bd9
let
	f(y) = 2-y
	g(y) = y^2
	a, b = 0, 1
	quadgk(y -> f(y) - g(y), a, b)[1]
end

# ╔═╡ 12f8caf4-70e0-11ec-2ad8-636c0317b418
md"""## Questions
"""

# ╔═╡ 12f8cb26-70e0-11ec-050f-f19be0ec49cf
md"""###### Question
"""

# ╔═╡ 12f8cb44-70e0-11ec-24e5-f3925cb866a4
md"""Find the area enclosed by the curves $y=2-x^2$ and $y=x^2 - 3$.
"""

# ╔═╡ 12f8cf9a-70e0-11ec-3d2c-039ae6256c41
let
	f(x) = 2 - x^2
	g(x) = x^2 - 3
	a,b = find_zeros(x -> f(x) - g(x), -10,10)
	val, _ = quadgk(x -> f(x) - g(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8cfba-70e0-11ec-0fb4-bd720d71de5e
md"""###### Question
"""

# ╔═╡ 12f8cfe0-70e0-11ec-1792-e3cbc7e2ce9a
md"""Find the area between $f(x) = \cos(x)$, $g(x) = x$ and the $y$ axis.
"""

# ╔═╡ 12f8d364-70e0-11ec-16b9-8922f821e85a
let
	f(x) = cos(x)
	g(x) = x
	a = 0
	b = find_zero(x -> f(x) - g(x), 1)
	val, _ = quadgk(x -> f(x) - g(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8d378-70e0-11ec-3e9c-ddf3b9cff2da
md"""###### Question
"""

# ╔═╡ 12f8d396-70e0-11ec-28fc-c9355a4ff75e
md"""Find the area between the line $y=1/2(x+1)$ and half circle $y=\sqrt{1 - x^2}$.
"""

# ╔═╡ 12f8da44-70e0-11ec-0f16-a3b3566a5d24
let
	f(x) = sqrt(1 - x^2)
	g(x) = 1/2 * (x + 1)
	a,b = find_zeros(x -> f(x) - g(x), -1, 1)
	val, _ = quadgk(x -> f(x) - g(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8da76-70e0-11ec-0da7-f731ad8c5352
md"""###### Question
"""

# ╔═╡ 12f8daa8-70e0-11ec-1d9d-e5d9bd2274d9
md"""Find the area in the first quadrant between the lines $y=x$, $y=1$, and the curve $y=x^2 + 4$.
"""

# ╔═╡ 12f8e016-70e0-11ec-0e21-2d2997ad063e
let
	f(x) = x
	g(x) = 1.0
	h(x) = min(f(x), g(x))
	j(x) = x^2 / 4
	a,b = find_zeros(x -> h(x) - j(x), 0, 3)
	val, _ = quadgk(x -> h(x) - j(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8e03e-70e0-11ec-1f42-17400248de8c
md"""###### Question
"""

# ╔═╡ 12f8e05c-70e0-11ec-0192-cb8263c8cf26
md"""Find the area between $y=x^2$ and $y=-x^4$ for $\lvert x \rvert \leq 1$.
"""

# ╔═╡ 12f8e476-70e0-11ec-1f96-7f9a1137d927
let
	f(x) = x^2
	g(x) = -x^4
	a,b = -1, 1
	val, _ = quadgk(x -> f(x) - g(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8e494-70e0-11ec-0d31-7f7581ca063d
md"""###### Question
"""

# ╔═╡ 12f8e4b2-70e0-11ec-026a-d5436531db1b
md"""Let `f(x) = 1/(sqrt(pi)*gamma(1/2)) * (1 + t^2)^(-1)` and `g(x) = 1/sqrt(2*pi) * exp(-x^2/2)`. These graphs intersect in two points. Find the area bounded by them.
"""

# ╔═╡ 12f8e7d2-70e0-11ec-2a47-55df454a8340
let
	import SpecialFunctions: gamma
	f(x) = 1/(sqrt(pi)*gamma(1/2)) * (1 + x^2)^(-1)
	g(x) = 1/sqrt(2*pi) * exp(-x^2/2)
	a,b =  find_zeros(x -> f(x) - g(x), -3, 3)
	val, _ = quadgk(x -> f(x) - g(x), a, b)
	numericq(val)
end

# ╔═╡ 12f8e804-70e0-11ec-2ea3-79951ba44cc8
md"""(Where `gamma(1/2)` is a call to the [gamma](http://en.wikipedia.org/wiki/Gamma_function) function.)
"""

# ╔═╡ 12f8e818-70e0-11ec-2a93-6f91a64e1194
md"""###### Question
"""

# ╔═╡ 12f8e836-70e0-11ec-1a1d-43bef1ea9c22
md"""Find the area in the first quadrant bounded by the graph of $x = (y-1)^2$, $x=3-y$ and $x=2\sqrt{y}$. (Hint: integrate in the $y$ variable.)
"""

# ╔═╡ 12f8ed0c-70e0-11ec-3ef0-6f9838a12c5c
let
	f(y) = (y-1)^2
	g(y) = 3 - y
	h(y) = 2sqrt(y)
	a = 0
	b = find_zero(y -> f(y) - g(y), 2)
	f1(y) = max(f(y), zero(y))
	g1(y) = min(g(y), h(y))
	val, _ = quadgk(y -> g1(y) - f1(y), a, b)
	numericq(val)
end

# ╔═╡ 12f8ed22-70e0-11ec-32e6-179816964a92
md"""###### Question
"""

# ╔═╡ 12f8ed40-70e0-11ec-39c5-e5f7c466bbde
md"""Find the total area bounded by the lines $x=0$, $x=2$ and the curves $y=x^2$ and $y=x$. This would be $\int_a^b \lvert f(x) - g(x) \rvert dx$.
"""

# ╔═╡ 12f8f11e-70e0-11ec-1489-e7a206290ac1
let
	f(x) = x^2
	g(x) = x
	a, b = 0, 2
	val, _ = quadgk(x -> abs(f(x) - g(x)), a, b)
	numericq(val)
end

# ╔═╡ 12f8f13c-70e0-11ec-1482-79d751eb398e
md"""###### Question
"""

# ╔═╡ 12f8f164-70e0-11ec-151b-abd814091e12
md"""Look at the sculpture [Le Tamanoir](https://www.google.com/search?q=Le+Tamanoir+by+Calder.&num=50&tbm=isch&tbo=u&source=univ&sa=X&ved=0ahUKEwiy8eO2tqzVAhVMPz4KHXmgBpgQsAQILQ&biw=1556&bih=878) by Calder. A large scale work. How much does it weigh? Approximately?
"""

# ╔═╡ 12f8f196-70e0-11ec-1185-c13eff5c3feb
md"""Let's try to answer that with an educated guess. The right most figure looks to be about 1/5th the total amount. So if we estimate that piece and multiply by 5 we get a good guess. That part looks like an area of metal bounded by two quadratic polynomials. If we compute that area in square inches, then multiply by an assumed thickness of one inch, we have the cubic volume. The density of galvanized steel is 7850 kg/$m^3$ which we convert into pounds/in$^3$ via:
"""

# ╔═╡ 12f8f59c-70e0-11ec-36c1-f3a9bfb37764
7850 * 2.2 * (1/39.3)^3

# ╔═╡ 12f8f5bc-70e0-11ec-06ee-bf0cade30d40
md"""The two parabolas, after rotating, might look like the following (with $x$ in inches):
"""

# ╔═╡ 12f8f5e2-70e0-11ec-31ec-f36246789c0b
md"""```math
f(x) = x^2/70, \quad g(x) = 35 + x^2/140
```
"""

# ╔═╡ 12f8f5ee-70e0-11ec-3598-51c46035d2b6
md"""Put this altogether to give an estimated weight in pounds.
"""

# ╔═╡ 12f8fa42-70e0-11ec-24b9-ededb8ae29c8
let
	f(x) = x^2/70
	g(x) = 35 + x^2/140
	a,b = find_zeros(x -> f(x) - g(x), -100, 100)
	ar, _ = quadgk(x -> abs(f(x) - g(x)), a, b)
	val = 5 * ar * 7850 * 2.2 * (1/39.3)^3
	numericq(val)
end

# ╔═╡ 12f8fa54-70e0-11ec-20c8-71b4ba17ad40
md"""Is the guess that the entire sculpture is more than two tons?
"""

# ╔═╡ 12f8ffec-70e0-11ec-29c5-53a54e688d65
let
	choices=["Less than two tons", "More than two tons"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 12f9157e-70e0-11ec-03e6-f95777ad4cdc
let
	note("""
	We used area to estimate weight in this example, but Galileo used weight to estimate area. It is [mentioned](https://www.maa.org/sites/default/files/pdf/cmj_ftp/CMJ/January%202010/3%20Articles/3%20Martin/08-170.pdf) by Martin that in order to estimate the area enclosed by one arch of a cycloid, Galileo cut the arch from from some material and compared the weight to the weight of the generating circle. He concluded the area is close to ``3`` times that of the circle, a conjecture proved by Roberval in 1634.
	""")
end

# ╔═╡ 12f915a4-70e0-11ec-36ce-abce5fb81e23
md"""###### Question
"""

# ╔═╡ 12f915d6-70e0-11ec-275b-6daa7bfb0458
md"""Formulas from the business world say that revenue is the integral of *marginal revenue* or the additional money from  selling 1 more unit. (This is basically the derivative of profit). Cost is the integral of *marginal cost*, or the cost to produce 1 more. Suppose we have
"""

# ╔═╡ 12f915ea-70e0-11ec-3cd0-a5df945f01a1
md"""```math
\text{mr}(x) = 2 - \frac{e^{-x/10}}{1 + e^{-x/10}}, \quad
\text{mc}(x) = 1 - \frac{1}{2} \cdot \frac{e^{-x/5}}{1 + e^{-x/5}}.
```
"""

# ╔═╡ 12f91608-70e0-11ec-24e9-c178a35f147b
md"""Find the profit to produce 100 units: $P = \int_0^{100} (\text{mr}(x) - \text{mc}(x)) dx$.
"""

# ╔═╡ 12f91f84-70e0-11ec-290f-4b5d9e7e0b2b
let
	mr(x) = 2 + exp((-x/10)) / (1 + exp(-x/10))
	mc(x) = 1 + (1/2) * exp(-x/5) / (1 + exp(-x/5))
	a, b = 0, 100
	val, _ = quadgk(x -> mr(x) - mc(x), 0, 100)
	numericq(val)
end

# ╔═╡ 12f91fa4-70e0-11ec-2400-eb55a98857db
md"""###### Question
"""

# ╔═╡ 12f91fcc-70e0-11ec-093c-8d2073d655ef
md"""Can `SymPy` do what Archimedes did?
"""

# ╔═╡ 12f91fe0-70e0-11ec-2efa-af4153fa1a09
md"""Consider the following code which sets up the area of an inscribed triangle, `A1`, and the area of a parabolic segment, `A2` for a general parabola:
"""

# ╔═╡ 12f92706-70e0-11ec-132f-6f9614667c34
let
	@syms x::real A::real B::real C::real a::real b::real
	c = (a + b) / 2
	f(x) = A*x^2 + B*x + C
	Secant(f, a, b) = f(a) + (f(b)-f(a))/(b-a) * (x - a)
	A1 = integrate(Secant(f, a, c) - Secant(f,a,b), (x,a,c)) + integrate(Secant(f,c,b)-Secant(f,a,b), (x, c, b))
	A2 = integrate(f(x) - Secant(f,a,b), (x, a, b))
	out = 4//3 * A1 - A2
end

# ╔═╡ 12f92738-70e0-11ec-26b6-e70ece9ce40b
md"""Does `SymPy` get the correct output, $0$, after calling `simplify`?
"""

# ╔═╡ 12f928f8-70e0-11ec-00a9-c9d12d91251a
let
	yesnoq(true)
end

# ╔═╡ 12f92918-70e0-11ec-332e-63e2a6aefa47
md"""###### Question
"""

# ╔═╡ 12f92936-70e0-11ec-353d-75c56f7b0175
md"""In [Martin](https://www.maa.org/sites/default/files/pdf/cmj_ftp/CMJ/January%202010/3%20Articles/3%20Martin/08-170.pdf) a fascinating history of the cycloid can be read.
"""

# ╔═╡ 12f92d94-70e0-11ec-29ce-93e14c64d57c
let
	imgfile="figures/cycloid-companion-curve.png"
	caption = """
	Figure from Martin  showing the companion curve to the cycloid. As the generating circle rolls, from ``A`` to ``C``, the original point of contact, ``D``, traces out an arch of the cycloid. The companion curve is that found by congruent line segments. In the figure, when ``D`` was at point ``P`` the line segment ``PQ`` is congruent to ``EF`` (on the original position of the generating circle).
	"""
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ 12f92db4-70e0-11ec-14b0-33d74c501b22
md"""In particular, it can be read that Roberval proved that the area between the cycloid and its companion curve is half the are of the generating circle. Roberval didn't know integration, so finding the area between two curves required other tricks. One is called "Cavalieri's principle." From the figure above, which of the following would you guess this principle to be:
"""

# ╔═╡ 12f93ea8-70e0-11ec-3dd0-d13c8aa4b029
let
	choices = ["""
	If two regions bounded by parallel lines are such that any parallel between them cuts each region in segments of equal length, then the regions have equal area.
	""",
	           """
	The area of the cycloid is nearly the area of a semi-ellipse with known values, so one can approximate the area of the cycloid with formula for the area of an ellipse
	"""]
	radioq(choices, 1)
end

# ╔═╡ 12f93eee-70e0-11ec-17aa-79cb565371f4
md"""Suppose the generating circle has radius $1$, so the area shown is $\pi/2$. The companion curve is then  $1-\cos(\theta)$ (a fact not used by Roberval). The area *under* this curve is then
"""

# ╔═╡ 12f94240-70e0-11ec-2b77-f710c38ee087
let
	@syms theta
	integrate(1 - cos(theta), (theta, 0, SymPy.PI))
end

# ╔═╡ 12fa7bb0-70e0-11ec-15ab-d93fd8723d8b
md"""That means the area under **one-half** arch of the cycloid is
"""

# ╔═╡ 12fa84e8-70e0-11ec-1c1d-39c74ccfd707
let
	choices = ["``\\pi``",
	           "``(3/2)\\cdot \\pi``",
	           "``2\\pi``"
	           ]
	radioq(choices, 2, keep_order=true)
end

# ╔═╡ 12fa8510-70e0-11ec-12c4-bd6c0c9337eb
md"""Doubling the answer above gives a value that Galileo had struggled with for many years.
"""

# ╔═╡ 12fa8a56-70e0-11ec-3b9d-cf450fd53d0b
let
	imgfile="figures/companion-curve-bisects-rectangle.png"
	caption = """
	Roberval, avoiding a trignometric integral, instead used symmetry to show that the area under the companion curve was half the area of the rectangle, which in this figure is ``2\\pi``.
	"""
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ 12fa8a74-70e0-11ec-0d70-83e266d6bad6
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/mean_value_theorem.html">◅ previous</a>  <a href="../integrals/center_of_mass.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/area_between_curves.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 12fa8a88-70e0-11ec-0959-1d9c6de924d4
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.13"
LaTeXStrings = "~1.3.0"
Plots = "~1.25.4"
PlutoUI = "~0.7.29"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
Roots = "~1.3.14"
SpecialFunctions = "~1.8.1"
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
git-tree-sha1 = "1ee88c4c76caa995a885dc2f22a5d548dfbbc0ba"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.2"

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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "ae958b53cc06c6b3d5d5b0847a3d858075136417"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.13"

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
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

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
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

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
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "b9a93bcdf34618031891ee56aad94cfff0843753"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f97acd98255568c3c9b416c5a3cf246c1315771b"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.0+0"

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
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

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
git-tree-sha1 = "71d65e9242935132e71c4fbf084451579491166a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "7711172ace7c40dc8449b7aed9d2d6f1cf56a5bd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.29"

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
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

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

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "7f5a513baec6f122401abfc8e9c074fdac54f6c1"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "88a559da57529581472320892576a486fa2377b9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.1"

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
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

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
# ╟─12fa8a60-70e0-11ec-1a50-3ba6409cb85e
# ╟─12f56cba-70e0-11ec-2d5b-fd2fa5d27dc3
# ╟─12f56cec-70e0-11ec-0b1e-6f383be2d557
# ╠═12f572c8-70e0-11ec-05b7-53a347568035
# ╟─12f57610-70e0-11ec-1dfa-812d7099d48a
# ╟─12f57642-70e0-11ec-3e18-d5d4fd9499ee
# ╟─12f57692-70e0-11ec-1598-9bc48d51c456
# ╟─12f576ba-70e0-11ec-1550-4ff197c2927c
# ╟─12f576e0-70e0-11ec-1ad0-0fe7e21b6fb5
# ╟─12f57c32-70e0-11ec-1848-553d48e7b68c
# ╟─12f57c64-70e0-11ec-0a37-81f0c83655b4
# ╟─12f57c78-70e0-11ec-04a1-4dd5e5756fcf
# ╟─12f82cdc-70e0-11ec-0221-8151582f7a04
# ╟─12f82d4c-70e0-11ec-2280-53e0df6e4e66
# ╟─12f82d60-70e0-11ec-1491-23ce83fd714e
# ╠═12f834d6-70e0-11ec-1522-d7fa68212890
# ╟─12f83512-70e0-11ec-3977-0f7167187d39
# ╠═12f83ae4-70e0-11ec-1619-75086e39bb98
# ╟─12f83b02-70e0-11ec-002b-b98d9ac2d2ef
# ╠═12f83eb8-70e0-11ec-3652-7f83abe12b85
# ╟─12f83ef2-70e0-11ec-36da-2d57e6dfd9e4
# ╟─12f83f26-70e0-11ec-3bc7-f740056ad263
# ╟─12f83f30-70e0-11ec-3aeb-adbb6443bb61
# ╠═12f8430e-70e0-11ec-0fd3-d13bb13b2d31
# ╟─12f8432c-70e0-11ec-1538-77deeeacbcee
# ╠═12f84a5c-70e0-11ec-0cd3-c3911535f174
# ╟─12f84a7a-70e0-11ec-1484-e53a8e80be3f
# ╟─12f84aa4-70e0-11ec-3ff4-1353fecd1dc2
# ╟─12f84ac0-70e0-11ec-34b5-c1a640bb7167
# ╠═12f84f52-70e0-11ec-20d7-41353c203b7c
# ╟─12f84f70-70e0-11ec-37df-ab99e6f879e5
# ╟─12f84f8e-70e0-11ec-0103-1f7bdf11d5a4
# ╟─12f84fac-70e0-11ec-24bc-07042abe662c
# ╠═12f8548e-70e0-11ec-0584-819c0fd118ff
# ╟─12f854c0-70e0-11ec-324d-4ffdb3117f4a
# ╠═12f85abc-70e0-11ec-2644-61ed82545e3a
# ╟─12f85ace-70e0-11ec-12ad-3d4edf73f714
# ╟─12f85b20-70e0-11ec-26ca-eb816a0fceff
# ╟─12f85f7e-70e0-11ec-2244-3d05d8496fdc
# ╟─12f85fa6-70e0-11ec-3cc4-4ff5a0ae5329
# ╠═12f86424-70e0-11ec-0734-977e6a8ce38f
# ╟─12f86462-70e0-11ec-3b3c-df7fa0a20e4a
# ╟─12f8647e-70e0-11ec-022a-7f42d208ef94
# ╠═12f868de-70e0-11ec-15e0-4b61d193277d
# ╟─12f86906-70e0-11ec-31a3-77379eebcaac
# ╠═12f86b72-70e0-11ec-1361-67867f187878
# ╟─12f86b86-70e0-11ec-2b45-3b1c8fc31199
# ╟─12f86bae-70e0-11ec-355c-796e165eb430
# ╟─12f86bc2-70e0-11ec-1858-2f29e540f49c
# ╠═12f86f96-70e0-11ec-2429-f328bf2b6b9e
# ╟─12f86fc8-70e0-11ec-108d-4bd8c4b718e0
# ╠═12f875d6-70e0-11ec-0eda-c7c8f88ca656
# ╟─12f875ea-70e0-11ec-1f41-57e70ab80101
# ╟─12f87626-70e0-11ec-012d-d128a5589aa6
# ╠═12f879e6-70e0-11ec-051a-a182b60d0cf2
# ╟─12f87a0e-70e0-11ec-2bce-533dd8d6d676
# ╠═12f8808a-70e0-11ec-08ad-4372b6a6bf5d
# ╟─12f880a8-70e0-11ec-12c1-4de2ac6563bf
# ╠═12f88602-70e0-11ec-2402-ffd8f649af45
# ╟─12f8861e-70e0-11ec-3083-0bfd81528621
# ╠═12f887d8-70e0-11ec-163d-09e4bc6f33ad
# ╟─12f88800-70e0-11ec-199e-ade418e9c1c3
# ╠═12f88c24-70e0-11ec-387f-25d025ddb854
# ╟─12f88c4c-70e0-11ec-051d-1da81ee01a97
# ╟─12f88c62-70e0-11ec-1de0-f1afa107b618
# ╟─12f88c7e-70e0-11ec-3487-e3e0ea8e1b2a
# ╟─12f88c94-70e0-11ec-1fe8-bbafaffa60e7
# ╠═12f8911a-70e0-11ec-3678-13c6a20f56d0
# ╟─12f89142-70e0-11ec-3cf4-7955b6714dad
# ╠═12f89494-70e0-11ec-0029-d9147b3b4d4c
# ╟─12f894bc-70e0-11ec-17b5-6391318fd5ee
# ╟─12f89584-70e0-11ec-0d5a-3fdcc9dafbc5
# ╠═12f89cc8-70e0-11ec-0367-61dfb611d411
# ╟─12f89d18-70e0-11ec-321c-85117535c5c5
# ╠═12f8a2ea-70e0-11ec-0109-27bee21cd290
# ╟─12f8a34e-70e0-11ec-0b09-5fa271980fdd
# ╠═12f8a6a0-70e0-11ec-0bc3-3b485ce21d62
# ╟─12f8b082-70e0-11ec-1cf8-95ed8681dce9
# ╟─12f8b0b4-70e0-11ec-1e15-21fff63911b3
# ╟─12f8b0d2-70e0-11ec-17b4-3d136438ad55
# ╟─12f8b0f0-70e0-11ec-2c2c-91ac973faac3
# ╟─12f8b118-70e0-11ec-15eb-e5696fcd053f
# ╠═12f8b4e2-70e0-11ec-1ebe-0b8970f47fc6
# ╟─12f8b50a-70e0-11ec-2f7c-3d816e363707
# ╟─12f8b528-70e0-11ec-1a6f-b1936f4d179c
# ╠═12f8bb54-70e0-11ec-3a41-8bf2330aebce
# ╟─12f8bb90-70e0-11ec-1e12-e9a5c0912893
# ╟─12f8bbae-70e0-11ec-165e-5985852c9af8
# ╟─12f8c090-70e0-11ec-3815-1192b21920a5
# ╟─12f8c0b8-70e0-11ec-1bc4-4bc8ce1799f8
# ╟─12f8c0cc-70e0-11ec-34d9-cf9afcdc61af
# ╟─12f8c0e0-70e0-11ec-312b-1ffe5e1a4104
# ╠═12f8c69e-70e0-11ec-3820-71b1872bf166
# ╟─12f8c6da-70e0-11ec-380e-b96a1662834b
# ╠═12f8cac2-70e0-11ec-1b9b-9b1b3ee62bd9
# ╟─12f8caf4-70e0-11ec-2ad8-636c0317b418
# ╟─12f8cb26-70e0-11ec-050f-f19be0ec49cf
# ╟─12f8cb44-70e0-11ec-24e5-f3925cb866a4
# ╟─12f8cf9a-70e0-11ec-3d2c-039ae6256c41
# ╟─12f8cfba-70e0-11ec-0fb4-bd720d71de5e
# ╟─12f8cfe0-70e0-11ec-1792-e3cbc7e2ce9a
# ╟─12f8d364-70e0-11ec-16b9-8922f821e85a
# ╟─12f8d378-70e0-11ec-3e9c-ddf3b9cff2da
# ╟─12f8d396-70e0-11ec-28fc-c9355a4ff75e
# ╟─12f8da44-70e0-11ec-0f16-a3b3566a5d24
# ╟─12f8da76-70e0-11ec-0da7-f731ad8c5352
# ╟─12f8daa8-70e0-11ec-1d9d-e5d9bd2274d9
# ╟─12f8e016-70e0-11ec-0e21-2d2997ad063e
# ╟─12f8e03e-70e0-11ec-1f42-17400248de8c
# ╟─12f8e05c-70e0-11ec-0192-cb8263c8cf26
# ╟─12f8e476-70e0-11ec-1f96-7f9a1137d927
# ╟─12f8e494-70e0-11ec-0d31-7f7581ca063d
# ╟─12f8e4b2-70e0-11ec-026a-d5436531db1b
# ╟─12f8e7d2-70e0-11ec-2a47-55df454a8340
# ╟─12f8e804-70e0-11ec-2ea3-79951ba44cc8
# ╟─12f8e818-70e0-11ec-2a93-6f91a64e1194
# ╟─12f8e836-70e0-11ec-1a1d-43bef1ea9c22
# ╟─12f8ed0c-70e0-11ec-3ef0-6f9838a12c5c
# ╟─12f8ed22-70e0-11ec-32e6-179816964a92
# ╟─12f8ed40-70e0-11ec-39c5-e5f7c466bbde
# ╟─12f8f11e-70e0-11ec-1489-e7a206290ac1
# ╟─12f8f13c-70e0-11ec-1482-79d751eb398e
# ╟─12f8f164-70e0-11ec-151b-abd814091e12
# ╟─12f8f196-70e0-11ec-1185-c13eff5c3feb
# ╠═12f8f59c-70e0-11ec-36c1-f3a9bfb37764
# ╟─12f8f5bc-70e0-11ec-06ee-bf0cade30d40
# ╟─12f8f5e2-70e0-11ec-31ec-f36246789c0b
# ╟─12f8f5ee-70e0-11ec-3598-51c46035d2b6
# ╟─12f8fa42-70e0-11ec-24b9-ededb8ae29c8
# ╟─12f8fa54-70e0-11ec-20c8-71b4ba17ad40
# ╟─12f8ffec-70e0-11ec-29c5-53a54e688d65
# ╟─12f9157e-70e0-11ec-03e6-f95777ad4cdc
# ╟─12f915a4-70e0-11ec-36ce-abce5fb81e23
# ╟─12f915d6-70e0-11ec-275b-6daa7bfb0458
# ╟─12f915ea-70e0-11ec-3cd0-a5df945f01a1
# ╟─12f91608-70e0-11ec-24e9-c178a35f147b
# ╟─12f91f84-70e0-11ec-290f-4b5d9e7e0b2b
# ╟─12f91fa4-70e0-11ec-2400-eb55a98857db
# ╟─12f91fcc-70e0-11ec-093c-8d2073d655ef
# ╟─12f91fe0-70e0-11ec-2efa-af4153fa1a09
# ╠═12f92706-70e0-11ec-132f-6f9614667c34
# ╟─12f92738-70e0-11ec-26b6-e70ece9ce40b
# ╟─12f928f8-70e0-11ec-00a9-c9d12d91251a
# ╟─12f92918-70e0-11ec-332e-63e2a6aefa47
# ╟─12f92936-70e0-11ec-353d-75c56f7b0175
# ╟─12f92d94-70e0-11ec-29ce-93e14c64d57c
# ╟─12f92db4-70e0-11ec-14b0-33d74c501b22
# ╟─12f93ea8-70e0-11ec-3dd0-d13c8aa4b029
# ╟─12f93eee-70e0-11ec-17aa-79cb565371f4
# ╠═12f94240-70e0-11ec-2b77-f710c38ee087
# ╟─12fa7bb0-70e0-11ec-15ab-d93fd8723d8b
# ╟─12fa84e8-70e0-11ec-1c1d-39c74ccfd707
# ╟─12fa8510-70e0-11ec-12c4-bd6c0c9337eb
# ╟─12fa8a56-70e0-11ec-3b9d-cf450fd53d0b
# ╟─12fa8a74-70e0-11ec-0d70-83e266d6bad6
# ╟─12fa8a7e-70e0-11ec-074a-4d0623d29013
# ╟─12fa8a88-70e0-11ec-0959-1d9c6de924d4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
