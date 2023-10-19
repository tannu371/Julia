### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ a83a3246-53c0-11ec-0448-ed907aa96f93
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
	using Polynomials # some name clash with SymPy
end

# ╔═╡ a83a4a6e-53c0-11ec-2d6f-e1f2506adc27
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size=(600, 400)
	nothing
end

# ╔═╡ a8719f12-53c0-11ec-1d7a-d10cd57501c7
using PlutoUI

# ╔═╡ a8719eea-53c0-11ec-1448-2983df7d1a76
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ a80ca6f2-53c0-11ec-29b0-37f28e61fb73
md"""# Curve Sketching
"""

# ╔═╡ a80fbeca-53c0-11ec-1485-239b33ccef4f
md"""This section uses the following add-on packages:
"""

# ╔═╡ a83a45da-53c0-11ec-01df-ff919f43c8dd
begin
	# in CalculusWithJulia, but not this version
	rangeclamp(f, c=20) = x -> abs(f(x)) < c ? f(x) : NaN
	nothing
end

# ╔═╡ a83c87a0-53c0-11ec-33bc-bd2cac9d198e
md"""---
"""

# ╔═╡ a8400c18-53c0-11ec-2051-9b060839075c
md"""The figure illustrates a means to *sketch* a sine curve - identify as many of the following values as you can:
"""

# ╔═╡ a84e69fc-53c0-11ec-1524-a1acd1004027
md"""  * asymptotic behaviour (as $x \rightarrow \pm \infty$),
  * periodic behaviour,
  * vertical asymptotes,
  * the $y$ intercept,
  * any $x$ intercept(s),
  * local peaks and valleys (relative extrema).
  * concavity
"""

# ╔═╡ a84e6ab0-53c0-11ec-0a59-4f6935435b50
md"""With these, a sketch fills in between the points/lines associated with these values.
"""

# ╔═╡ a84ed1bc-53c0-11ec-2d40-75b0e7ff76e2
let
	### {{{ sketch_sin_plot }}}
	
	
	function sketch_sin_plot_graph(i)
	    f(x) = 10*sin(pi/2*x)  # [0,4]
	    deltax = 1/10
	    deltay = 5/10
	
	    zs = find_zeros(f, 0-deltax, 4+deltax)
	    cps = find_zeros(D(f), 0-deltax, 4+deltax)
	    xs = range(0, stop=4*(i-2)/6, length=50)
	    if i == 1
	        ## plot zeros
	        title = "Plot the zeros"
	        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
	    elseif i == 2
	        ## plot extrema
	        title = "Plot the local extrema"
	        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
	        scatter!(p, cps, f.(cps))
	    else
	        ##  sketch graph
	        title = "sketch the graph"
	        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
	        scatter!(p, cps, f.(cps))
	        plot!(p, xs, f.(xs))
	    end
	    p
	end
	
	
	caption = L"""
	
	After identifying asymptotic behaviours,
	a curve sketch involves identifying the $y$ intercept, if applicable; the $x$ intercepts, if possible; and the local extrema. From there a sketch fills in between the points. In this example, the periodic function $f(x) = 10\cdot\sin(\pi/2\cdot x)$ is sketched over $[0,4]$.
	
	"""
	
	
	
	n = 8
	anim = @animate for i=1:n
	    sketch_sin_plot_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a84ed28c-53c0-11ec-0da0-ad2f43647823
md"""Though this approach is most useful for hand-sketches, the underlying concepts are important for properly framing graphs made with the computer.
"""

# ╔═╡ a850e2c2-53c0-11ec-1be8-d9fd349cf69d
md"""We can easily make a graph of a function over a specified interval. What is not always so easy is to pick an interval that shows off the feature of interest. In the section on [rational](../precalc/rational_functions.html) functions there was a discussion about how to draw graphs for rational functions so that horizontal and vertical asymptotes can be seen. These are properties of the "large." In this section, we build on this, but concentrate now on more local properties of a function.
"""

# ╔═╡ a8540542-53c0-11ec-3fe2-f35e720a57d6
md"""##### Example
"""

# ╔═╡ a85405ba-53c0-11ec-3a14-a539e0467ad6
md"""Produce a graph of the function $f(x) = x^4 -13x^3 + 56x^2-92x + 48$.
"""

# ╔═╡ a854069e-53c0-11ec-1eef-cff06b75a625
md"""We identify this as a fourth-degree polynomial with postive leading coefficient. Hence it will eventually look $U$-shaped. If we graph over a too-wide interval, that is all we will see. Rather, we do some work to produce a graph that shows the zeros, peaks, and valleys of $f(x)$. To do so, we need to know the extent of the zeros. We can try some theory, but instead we just guess and if that fails, will work harder:
"""

# ╔═╡ a854144a-53c0-11ec-30c6-4f5b63d1e7e7
begin
	f(x) = x^4 - 13x^3 + 56x^2 -92x + 48
	rts = find_zeros(f, -10, 10)
end

# ╔═╡ a85414c4-53c0-11ec-302c-dd9030d19c63
md"""As we found $4$ roots, we know by the fundamental theorem of algebra we have them all. This means, our graph need not focus on values much larger than $6$ or much smaller than $1$.
"""

# ╔═╡ a85414d8-53c0-11ec-2fd8-b7f4efa60ac2
md"""To know where the peaks and valleys are, we look for the critical points:
"""

# ╔═╡ a8541898-53c0-11ec-20bc-e129bf8c21fa
cps = find_zeros(f', 1, 6)

# ╔═╡ a8541906-53c0-11ec-3ad6-2b7017c9528e
md"""Because we have the $4$ distinct zeros, we must have the peaks and valleys appear in an interleaving manner, so a search over $[1,6]$ finds all three critical points and without checking, they must correspond to relative extrema.
"""

# ╔═╡ a854191a-53c0-11ec-2e96-17a797fbe297
md"""We finally check that if we were to just use $[0,7]$ as a domain to plot over that the function doesn't get too large to mask the oscillations. This could happen if the $y$ values at the end points are too much larger than the $y$ values at the peaks and valleys, as only so many pixels can be used within a graph. For this we have:
"""

# ╔═╡ a8541d52-53c0-11ec-0c7a-2bb692a7476c
f.([0, cps..., 7])

# ╔═╡ a8541e10-53c0-11ec-2c45-1d7d7e4e4de7
md"""The values at $0$ and at $7$ are a bit large, as compared to the relative extrema, and since we know the graph is eventually $U$-shaped, this offers no insight. So we narrow the range a bit for the graph:
"""

# ╔═╡ a85420cc-53c0-11ec-215e-23322b21a828
plot(f, 0.5, 6.5)

# ╔═╡ a8542176-53c0-11ec-2921-910b5d1ed73a
md"""---
"""

# ╔═╡ a868704a-53c0-11ec-1e1a-1da71b4ff328
md"""This sort of analysis can be automated. The plot "recipe" for polynomials from the `Polynomials` package does similar considerations to choose a viewing window:
"""

# ╔═╡ a8687932-53c0-11ec-3f6b-9d02c694af71
begin
	xₚ = variable(Polynomial)
	plot(f(xₚ))   # f(xₚ) of Polynomial type
end

# ╔═╡ a8687982-53c0-11ec-2b4f-df37e1be89c0
md"""##### Example
"""

# ╔═╡ a8687996-53c0-11ec-0a29-714b90e9eaba
md"""Graph  the function
"""

# ╔═╡ a86a7e12-53c0-11ec-1c2a-a95ed7bd8c76
md"""```math
f(x) = \frac{(x-1)\cdot(x-3)^2}{x \cdot (x-2)}.
```
"""

# ╔═╡ a86a7e8c-53c0-11ec-33b6-979cb066803c
md"""Not much to do here if you are satisfied with a graph that only gives insight into the asymptotes of this rational function:
"""

# ╔═╡ a86a8f10-53c0-11ec-32ae-a925804694af
begin
	𝒇(x) = ( (x-1)*(x-3)^2 ) / (x * (x-2) )
	plot(𝒇, -50, 50)
end

# ╔═╡ a86a8f60-53c0-11ec-01d7-659e7dbcc9b8
md"""We can see the slant asymptote and hints of vertical asymptotes, but, we'd like to see more of the basic features of the graph.
"""

# ╔═╡ a86a8fb0-53c0-11ec-0b0d-7be93a68e055
md"""Previously, we have discussed rational functions and their asymptotes. This function has numerator of degree 3 and denominator of degree 2, so will have a slant asymptote. As well, the zeros of the denominator, $0$ and $-2$, will lead to vertical asymptotes.
"""

# ╔═╡ a86a8fce-53c0-11ec-024d-39a80150df82
md"""To identify how wide a viewing window should be, for the rational function the asymptotic behaviour is determined after the concavity is done changing and we are past all relative extrema, so we should take an interval that include all potential inflection points and critical points:
"""

# ╔═╡ a86a98c0-53c0-11ec-1211-0d5eedfdfa80
begin
	𝒇cps = find_zeros(𝒇', -10, 10)
	poss_ips = find_zero(𝒇'', (-10, 10))
	extrema(union(𝒇cps, poss_ips))
end

# ╔═╡ a86a990e-53c0-11ec-0a76-3deb00696162
md"""So a range over $[-5,5]$ should display the key features including the slant asymptote.
"""

# ╔═╡ a86a9956-53c0-11ec-1958-6bc3a16006e9
md"""Previously we used the `rangeclamp` function defined in `CalculusWithJulia` to avoid the distortion that vertical asymptotes can have:
"""

# ╔═╡ a86a9e4a-53c0-11ec-0c51-a1369a7aed2f
plot(rangeclamp(𝒇), -5, 5)

# ╔═╡ a86a9eae-53c0-11ec-396e-236a82a737ec
md"""With this graphic, we can now clearly see in the graph the two zeros at $x=1$ and $x=3$, the vertical asymptotes at $x=0$ and $x=2$, and the slant asymptote.
"""

# ╔═╡ a86a9ee2-53c0-11ec-3d3e-87d675b022a8
md"""---
"""

# ╔═╡ a86a9f0a-53c0-11ec-0a95-bdecef726694
md"""Again, this sort of analysis can be systematized. The rational function type in the `Polynomials` package takes a stab at that, but isn't quite so good at capturing the slant asymptote:
"""

# ╔═╡ a86abea4-53c0-11ec-14fe-37ee55b278bd
begin
	xᵣ = variable(RationalFunction)
	plot(𝒇(xᵣ))  # f(x) of RationalFunction type
end

# ╔═╡ a86abf08-53c0-11ec-1f17-7fe496680e66
md"""##### Example
"""

# ╔═╡ a86abf58-53c0-11ec-29c7-85d650b9bb6d
md"""Consider the function $V(t) = 170 \sin(2\pi\cdot 60 \cdot t)$, a model for the alternating current waveform for an outlet in the United States. Create a graph.
"""

# ╔═╡ a86abf74-53c0-11ec-3318-2769cf0587e0
md"""Blindly trying to graph this, we will see immediate issues:
"""

# ╔═╡ a86acaca-53c0-11ec-3c65-85212b9ffa4b
begin
	V(t) = 170 * sin(2*pi*60*t)
	plot(V, -2pi, 2pi)
end

# ╔═╡ a86acb74-53c0-11ec-18c9-9f18a1b83b3e
md"""Ahh, this periodic function is *too* rapidly oscillating to be plotted without care. We recognize this as being of the form $V(t) = a\cdot\sin(c\cdot t)$, so where the sine functin has a period of $2\pi$, this will have a period of $2\pi/c$, or $1/60$. So instead of using $(-2\pi, 2\pi)$ as the interval to plot over, we need something much smaller:
"""

# ╔═╡ a86ad1aa-53c0-11ec-1057-81adabef213f
plot(V, -1/60, 1/60)

# ╔═╡ a86ad1dc-53c0-11ec-09bf-a56e743dfac5
md"""##### Example
"""

# ╔═╡ a86ad20e-53c0-11ec-2640-ef8d919b5580
md"""Plot the function $f(x) = \ln(x/100)/x$.
"""

# ╔═╡ a86ad240-53c0-11ec-2419-157b1ab4d1e6
md"""We guess that this function has a *vertical* asymptote at $x=0+$  and a horizontal asymptote as $x \rightarrow 0$, we verify through:
"""

# ╔═╡ a86ad772-53c0-11ec-2ba1-8fe4d34638f9
begin
	@syms x
	ex = log(x/100)/x
	limit(ex, x=>0, dir="+"), limit(ex, x=>oo)
end

# ╔═╡ a86ad7ce-53c0-11ec-0fc7-a35c202168b0
md"""The $\ln(x/100)$ part of $f$ goes $-\infty$ as $x \rightarrow 0+$; yet $f(x)$ is eventually positive as $x \rightarrow 0$. So a graph should
"""

# ╔═╡ a86ad90c-53c0-11ec-293c-e51e931d6383
md"""  * not show too much of the vertical asymptote
  * capture the point where $f(x)$ must cross $0$
  * capture the point where $f(x)$ has a relative maximum
  * show enough past this maximum to indicate to the reader the eventual horizontal asyptote.
"""

# ╔═╡ a86ad936-53c0-11ec-23a5-75086a747e12
md"""For that, we need to get the $x$ intercepts and the critical points. The $x/100$ means this graph has some scaling to it, so we first look between $0$ and ``200`:
"""

# ╔═╡ a86adcae-53c0-11ec-2075-8fef28948cd2
find_zeros(ex, 0, 200)  # domain is (0, oo)

# ╔═╡ a86adcfe-53c0-11ec-2c10-518dc5421960
md"""Trying the same for the critical points comes up empty. We know there is one, but it is past $200$. Scanning wider, we see:
"""

# ╔═╡ a86ae0e6-53c0-11ec-225d-05fd35348f1b
find_zeros(diff(ex,x), 0, 500)

# ╔═╡ a86ae118-53c0-11ec-1385-b1f2b0efe873
md"""So maybe graphing over $[50, 300]$ will be a good start:
"""

# ╔═╡ a86ae3b6-53c0-11ec-0157-3d72539ff7bf
plot(ex, 50, 300)

# ╔═╡ a86ae412-53c0-11ec-2721-bdd17d6579e4
md"""But it isn't! The function takes its time getting back towards $0$. We know that there must be a change of concavity as $x \rightarrow \infty$, as there is a horizontal asymptote. We looks for the anticipated inflection point to ensure our graph includes that:
"""

# ╔═╡ a86ae83e-53c0-11ec-37ed-6bc9b8f4b43a
find_zeros(diff(ex, x, x), 1, 5000)

# ╔═╡ a86ae870-53c0-11ec-3ee5-23ab1c2e1920
md"""So a better plot is found by going well beyond that inflection point:
"""

# ╔═╡ a86aeb2c-53c0-11ec-123c-031e79e0d34c
plot(ex, 75, 1500)

# ╔═╡ a86e0d66-53c0-11ec-2acd-67a241148aca
md"""## Questions
"""

# ╔═╡ a870cea2-53c0-11ec-3eab-8f9bdbae83d3
md"""###### Question
"""

# ╔═╡ a870cf06-53c0-11ec-0b13-717b9fa41ade
md"""Consider this graph
"""

# ╔═╡ a870de9c-53c0-11ec-0c00-59591239791e
let
	f(x) = (x-2)* (x-2.5)*(x-3) / ((x-1)*(x+1))
	p = plot(f, -20, -1-.3, legend=false, xlim=(-15, 15), color=:blue)
	plot!(p, f, -1 + .2, 1 - .02, color=:blue)
	plot!(p, f, 1 + .05, 20, color=:blue)
end

# ╔═╡ a870deec-53c0-11ec-206d-b7c1a201da4a
md"""What kind of *asymptotes* does it appear to have?
"""

# ╔═╡ a870ecfc-53c0-11ec-2341-2d5e286534e6
let
	choices = [
	L"Just a horizontal asymptote, $y=0$",
	L"Just vertical asymptotes at $x=-1$ and $x=1$",
	L"Vertical asymptotes at $x=-1$ and $x=1$ and a horizontal asymptote $y=1$",
	L"Vertical asymptotes at $x=-1$ and $x=1$ and a slant asymptote"
	]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ a870ed24-53c0-11ec-228d-339070ea49be
md"""###### Question
"""

# ╔═╡ a870ed6a-53c0-11ec-1ead-a5d2ce5ee094
md"""Consider the function $p(x) = x + 2x^3 + 3x^3 + 4x^4 + 5x^5 +6x^6$. Which interval shows more than a $U$-shaped graph that dominates for large $x$ due to the leading term being $6x^6$?
"""

# ╔═╡ a870ed7e-53c0-11ec-3579-4116fa0a6477
md"""(Find an interval that contains the zeros, critical points, and inflection points.)
"""

# ╔═╡ a870fe56-53c0-11ec-0c30-9b8632a59947
let
	choices = ["``(-5,5)``, the default bounds of a calculator",
	"``(-3.5, 3.5)``, the bounds given by Cauchy for the real roots of ``p``",
	"``(-1, 1)``, as many special polynomials have their roots in this interval",
	"``(-1.1, .25)``, as this constains all the roots, the critical points, and inflection points and just a bit more"
	]
	radioq(choices, 4, keep_order=true)
end

# ╔═╡ a870fe72-53c0-11ec-2662-fb3f485d90f4
md"""###### Question
"""

# ╔═╡ a870fe90-53c0-11ec-208f-35e423f01be9
md"""Let $f(x) = x^3/(9-x^2)$.
"""

# ╔═╡ a870feae-53c0-11ec-3a9a-eb051afc8278
md"""What points are *not* in the domain of $f$?
"""

# ╔═╡ a8711128-53c0-11ec-2566-21cc3f572516
begin
	qchoices = [
	    "The values of `find_zeros(f, -10, 10)`: `[-3, 0, 3]`",
	    "The values of `find_zeros(f', -10, 10)`: `[-5.19615, 0, 5.19615]`",
	    "The values of `find_zeros(f'', -10, 10)`: `[-3, 0, 3]`",
	    "The zeros of the numerator: `[0]`",
	    "The zeros of the denominator: `[-3, 3]`",
	    "The value of `f(0)`: `0`",
	    "None of these choices"
	]
	radioq(qchoices, 5, keep_order=true)
end

# ╔═╡ a8711146-53c0-11ec-24d9-c58825425c59
md"""The $x$-intercepts are:
"""

# ╔═╡ a8711484-53c0-11ec-1e5a-9f02e0a4faac
let
	radioq(qchoices, 4, keep_order=true)
end

# ╔═╡ a87114a0-53c0-11ec-35ea-050e1c12c60f
md"""The $y$-intercept is:
"""

# ╔═╡ a871177c-53c0-11ec-30f5-71d52ab12567
let
	radioq(qchoices, 6, keep_order=true)
end

# ╔═╡ a87117ae-53c0-11ec-24a4-e1d1c3e31c1a
md"""There are *vertical asymptotes* at $x=\dots$?
"""

# ╔═╡ a8711970-53c0-11ec-0a71-15f9e1a2550b
let
	radioq(qchoices, 5)
end

# ╔═╡ a8711998-53c0-11ec-2b12-4bc8df9df5a3
md"""The *slant* asymptote has slope?
"""

# ╔═╡ a8711b50-53c0-11ec-0524-f977ff6321f3
let
	numericq(1)
end

# ╔═╡ a8711b6e-53c0-11ec-1dd9-a33a951f1476
md"""The function has critical points at
"""

# ╔═╡ a8711e0c-53c0-11ec-1716-7dfffe36cf87
let
	radioq(qchoices, 2, keep_order=true)
end

# ╔═╡ a8711e20-53c0-11ec-38d1-73125946b025
md"""The function has relative extrema at
"""

# ╔═╡ a87120be-53c0-11ec-1146-95eef8ddb63c
let
	radioq(qchoices, 7, keep_order=true)
end

# ╔═╡ a87120dc-53c0-11ec-167c-c385573b7a7a
md"""The function has inflection points at
"""

# ╔═╡ a871238e-53c0-11ec-2cf5-a148746c1b51
let
	radioq(qchoices, 7, keep_order=true)
end

# ╔═╡ a87123a2-53c0-11ec-1630-934509279bb3
md"""###### Question
"""

# ╔═╡ a87123c0-53c0-11ec-395d-93bd974b2a11
md"""A function $f$ has
"""

# ╔═╡ a87124bc-53c0-11ec-14f5-952a697fb3c3
md"""  * zeros of $\{-0.7548\dots, 2.0\}$,
  * critical points at $\{-0.17539\dots, 1.0, 1.42539\dots\}$,
  * inflection points at $\{0.2712\dots,1.2287\}$.
"""

# ╔═╡ a87124ce-53c0-11ec-2f72-93ea573b0aa4
md"""Is this a possible graph of $f$?
"""

# ╔═╡ a8712ce4-53c0-11ec-259a-cd96c0cd20dc
let
	f(x) = x^4 - 3x^3 + 2x^2 + x - 2
	plot(f, -1, 2.5, legend=false)
end

# ╔═╡ a8712f98-53c0-11ec-224b-afd9fbfc5dba
let
	yesnoq("yes")
end

# ╔═╡ a8712fb4-53c0-11ec-1825-dd24949368a4
md"""###### Question
"""

# ╔═╡ a8713018-53c0-11ec-39cd-a9558d7e8861
md"""Two models for population growth are *exponential* growth: $P(t) = P_0 a^t$ and [logistic growth](https://en.wikipedia.org/wiki/Logistic_function#In_ecology:_modeling_population_growth): $P(t) = K P_0 a^t / (K + P_0(a^t - 1))$. The exponential growth model has growth rate proportional to the current population. The logistic model has growth rate depending on the current population *and* the available resources (which can limit growth).
"""

# ╔═╡ a871304a-53c0-11ec-1906-6ff9a4d07fee
md"""Letting $K=10$, $P_0=5$, and $a= e^{1/4}$. A plot over $[0,5]$ shows somewhat similar behaviour:
"""

# ╔═╡ a87137d6-53c0-11ec-3e69-158d1b563fcc
begin
	K, P0, a = 50, 5, exp(1/4)
	exponential_growth(t) = P0 * a^t
	logistic_growth(t) = K * P0 * a^t / (K + P0*(a^t-1))
	
	plot(exponential_growth, 0, 5)
	plot!(logistic_growth)
end

# ╔═╡ a87137fc-53c0-11ec-0e63-896af6aff6bb
md"""Does a plot over $[0,50]$ show qualitatively	 similar behaviour?
"""

# ╔═╡ a87139c8-53c0-11ec-20e8-a3ec744ef1b8
let
	yesnoq(true)
end

# ╔═╡ a87139e6-53c0-11ec-26c2-5bc95bfeb82f
md"""Exponential growth has $P''(t) = P_0 a^t \log(a)^2 > 0$, so has no inflection point. By plotting over a sufficiently wide interval, can you answer: does the logistic growth model have an inflection point?
"""

# ╔═╡ a8713b9e-53c0-11ec-358b-a52d769cb16a
let
	yesnoq(true)
end

# ╔═╡ a8713bb2-53c0-11ec-251e-193bad4ab989
md"""If yes, find it numerically:
"""

# ╔═╡ a87142f6-53c0-11ec-2c9b-85e213343948
let
	val = find_zero(D(logistic_growth,2), (0, 20))
	numericq(val)
end

# ╔═╡ a8714328-53c0-11ec-395c-fb73a116e1eb
md"""The available resources are quantified by $K$. As $K \rightarrow \infty$ what is the limit of the logistic growth model:
"""

# ╔═╡ a8714b2a-53c0-11ec-03f4-59f2ae706d04
let
	choices = [
	"The exponential growth model",
	"The limit does not exist",
	"The limit is ``P_0``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a8714b66-53c0-11ec-34b2-45d125819315
md"""##### Question
"""

# ╔═╡ a8714b8e-53c0-11ec-2829-b1b573692864
md"""The plotting algorithm for plotting functions  starts with a small initial set of points over the specified interval ($21$) and then refines those sub-intervals where the second derivative is determined to be large.
"""

# ╔═╡ a8714b98-53c0-11ec-215f-f523f73f5bae
md"""Why are sub-intervals where the second derivative is large different than those where the second derivative is small?
"""

# ╔═╡ a8715fc0-53c0-11ec-118e-c7412068b46d
let
	choices = [
	"The function will increase (or decrease) rapidly when the second derivative is large, so there needs to be more points to capture the shape",
	"The function will have more curvature when the second derivative is large, so there  needs to be more points to capture the shape",
	"The function will be much larger (in absolute value) when the second derivative is large, so there needs to be more points to capture the shape",
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ a8715fde-53c0-11ec-14d6-cd2d2365cf1e
md"""##### Question
"""

# ╔═╡ a871601a-53c0-11ec-0e0c-59bbff314291
md"""Is there a nice algorithm to identify what domain a function should be plotted over to produce an informative graph? [Wilkinson](https://www.cs.uic.edu/~wilkinson/Publications/plotfunc.pdf) has some suggestions. (Wilkinson is well known to the `R` community as the specifier of the grammar of graphics.) It is mentioned that "finding an informative domain for a given function depends on at least three features: periodicity, asymptotics, and monotonicity."
"""

# ╔═╡ a8716024-53c0-11ec-39ae-fb6f964220db
md"""Why would periodicity matter?
"""

# ╔═╡ a871747e-53c0-11ec-3bd8-55944495452a
let
	choices = [
	"An informative graph only needs to show one or two periods, as others can be inferred.",
	"An informative graph need only show a part of the period, as the rest can be inferred.",
	L"An informative graph needs to show several periods, as that will allow proper computation for the $y$ axis range."]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a87174c4-53c0-11ec-3dc4-4fab62579c47
md"""Why should asymptotics matter?
"""

# ╔═╡ a8718a9a-53c0-11ec-3ceb-c3c0ed0ae507
let
	choices = [
	L"A vertical asymptote can distory the $y$ range, so it is important to avoid too-large values",
	L"A horizontal asymptote must be plotted from $-\infty$ to $\infty$",
	"A slant asymptote must be plotted over a very wide domain so that it can be identified."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a8718ae0-53c0-11ec-2779-e1e1ea26f2b0
md"""Monotonicity means increasing or decreasing. This is important for what reason?
"""

# ╔═╡ a8719ed6-53c0-11ec-35fc-c11c406b8b9b
let
	choices = [
	"For monotonic regions, a large slope or very concave function might require more care to plot",
	"For monotonic regions, a function is basically a straight line",
	"For monotonic regions, the function will have a vertical asymptote, so the region should not be plotted"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a8719f08-53c0-11ec-0aee-cd3c86a0241c
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/first_second_derivatives.html">◅ previous</a>  <a href="../derivatives/linearization.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/curve_sketching.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ a8719f12-53c0-11ec-1fef-51a3d7c025b9
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Polynomials = "~2.0.18"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
SymPy = "~1.1.2"
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
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

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

[[deps.ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[deps.Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

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

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

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

[[deps.Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "79bcbb379205f1c62913fa9ebecb413c7a35f8b0"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.18"

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

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

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

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

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
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

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

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

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

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

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
# ╟─a8719eea-53c0-11ec-1448-2983df7d1a76
# ╟─a80ca6f2-53c0-11ec-29b0-37f28e61fb73
# ╟─a80fbeca-53c0-11ec-1485-239b33ccef4f
# ╠═a83a3246-53c0-11ec-0448-ed907aa96f93
# ╟─a83a45da-53c0-11ec-01df-ff919f43c8dd
# ╟─a83a4a6e-53c0-11ec-2d6f-e1f2506adc27
# ╟─a83c87a0-53c0-11ec-33bc-bd2cac9d198e
# ╟─a8400c18-53c0-11ec-2051-9b060839075c
# ╟─a84e69fc-53c0-11ec-1524-a1acd1004027
# ╟─a84e6ab0-53c0-11ec-0a59-4f6935435b50
# ╟─a84ed1bc-53c0-11ec-2d40-75b0e7ff76e2
# ╟─a84ed28c-53c0-11ec-0da0-ad2f43647823
# ╟─a850e2c2-53c0-11ec-1be8-d9fd349cf69d
# ╟─a8540542-53c0-11ec-3fe2-f35e720a57d6
# ╟─a85405ba-53c0-11ec-3a14-a539e0467ad6
# ╟─a854069e-53c0-11ec-1eef-cff06b75a625
# ╠═a854144a-53c0-11ec-30c6-4f5b63d1e7e7
# ╟─a85414c4-53c0-11ec-302c-dd9030d19c63
# ╟─a85414d8-53c0-11ec-2fd8-b7f4efa60ac2
# ╠═a8541898-53c0-11ec-20bc-e129bf8c21fa
# ╟─a8541906-53c0-11ec-3ad6-2b7017c9528e
# ╟─a854191a-53c0-11ec-2e96-17a797fbe297
# ╠═a8541d52-53c0-11ec-0c7a-2bb692a7476c
# ╟─a8541e10-53c0-11ec-2c45-1d7d7e4e4de7
# ╠═a85420cc-53c0-11ec-215e-23322b21a828
# ╟─a8542176-53c0-11ec-2921-910b5d1ed73a
# ╟─a868704a-53c0-11ec-1e1a-1da71b4ff328
# ╠═a8687932-53c0-11ec-3f6b-9d02c694af71
# ╟─a8687982-53c0-11ec-2b4f-df37e1be89c0
# ╟─a8687996-53c0-11ec-0a29-714b90e9eaba
# ╟─a86a7e12-53c0-11ec-1c2a-a95ed7bd8c76
# ╟─a86a7e8c-53c0-11ec-33b6-979cb066803c
# ╠═a86a8f10-53c0-11ec-32ae-a925804694af
# ╟─a86a8f60-53c0-11ec-01d7-659e7dbcc9b8
# ╟─a86a8fb0-53c0-11ec-0b0d-7be93a68e055
# ╟─a86a8fce-53c0-11ec-024d-39a80150df82
# ╠═a86a98c0-53c0-11ec-1211-0d5eedfdfa80
# ╟─a86a990e-53c0-11ec-0a76-3deb00696162
# ╟─a86a9956-53c0-11ec-1958-6bc3a16006e9
# ╠═a86a9e4a-53c0-11ec-0c51-a1369a7aed2f
# ╟─a86a9eae-53c0-11ec-396e-236a82a737ec
# ╟─a86a9ee2-53c0-11ec-3d3e-87d675b022a8
# ╟─a86a9f0a-53c0-11ec-0a95-bdecef726694
# ╠═a86abea4-53c0-11ec-14fe-37ee55b278bd
# ╟─a86abf08-53c0-11ec-1f17-7fe496680e66
# ╟─a86abf58-53c0-11ec-29c7-85d650b9bb6d
# ╟─a86abf74-53c0-11ec-3318-2769cf0587e0
# ╠═a86acaca-53c0-11ec-3c65-85212b9ffa4b
# ╟─a86acb74-53c0-11ec-18c9-9f18a1b83b3e
# ╠═a86ad1aa-53c0-11ec-1057-81adabef213f
# ╟─a86ad1dc-53c0-11ec-09bf-a56e743dfac5
# ╟─a86ad20e-53c0-11ec-2640-ef8d919b5580
# ╟─a86ad240-53c0-11ec-2419-157b1ab4d1e6
# ╠═a86ad772-53c0-11ec-2ba1-8fe4d34638f9
# ╟─a86ad7ce-53c0-11ec-0fc7-a35c202168b0
# ╟─a86ad90c-53c0-11ec-293c-e51e931d6383
# ╟─a86ad936-53c0-11ec-23a5-75086a747e12
# ╠═a86adcae-53c0-11ec-2075-8fef28948cd2
# ╟─a86adcfe-53c0-11ec-2c10-518dc5421960
# ╠═a86ae0e6-53c0-11ec-225d-05fd35348f1b
# ╟─a86ae118-53c0-11ec-1385-b1f2b0efe873
# ╠═a86ae3b6-53c0-11ec-0157-3d72539ff7bf
# ╟─a86ae412-53c0-11ec-2721-bdd17d6579e4
# ╠═a86ae83e-53c0-11ec-37ed-6bc9b8f4b43a
# ╟─a86ae870-53c0-11ec-3ee5-23ab1c2e1920
# ╠═a86aeb2c-53c0-11ec-123c-031e79e0d34c
# ╟─a86e0d66-53c0-11ec-2acd-67a241148aca
# ╟─a870cea2-53c0-11ec-3eab-8f9bdbae83d3
# ╟─a870cf06-53c0-11ec-0b13-717b9fa41ade
# ╟─a870de9c-53c0-11ec-0c00-59591239791e
# ╟─a870deec-53c0-11ec-206d-b7c1a201da4a
# ╟─a870ecfc-53c0-11ec-2341-2d5e286534e6
# ╟─a870ed24-53c0-11ec-228d-339070ea49be
# ╟─a870ed6a-53c0-11ec-1ead-a5d2ce5ee094
# ╟─a870ed7e-53c0-11ec-3579-4116fa0a6477
# ╟─a870fe56-53c0-11ec-0c30-9b8632a59947
# ╟─a870fe72-53c0-11ec-2662-fb3f485d90f4
# ╟─a870fe90-53c0-11ec-208f-35e423f01be9
# ╟─a870feae-53c0-11ec-3a9a-eb051afc8278
# ╟─a8711128-53c0-11ec-2566-21cc3f572516
# ╟─a8711146-53c0-11ec-24d9-c58825425c59
# ╟─a8711484-53c0-11ec-1e5a-9f02e0a4faac
# ╟─a87114a0-53c0-11ec-35ea-050e1c12c60f
# ╟─a871177c-53c0-11ec-30f5-71d52ab12567
# ╟─a87117ae-53c0-11ec-24a4-e1d1c3e31c1a
# ╟─a8711970-53c0-11ec-0a71-15f9e1a2550b
# ╟─a8711998-53c0-11ec-2b12-4bc8df9df5a3
# ╟─a8711b50-53c0-11ec-0524-f977ff6321f3
# ╟─a8711b6e-53c0-11ec-1dd9-a33a951f1476
# ╟─a8711e0c-53c0-11ec-1716-7dfffe36cf87
# ╟─a8711e20-53c0-11ec-38d1-73125946b025
# ╟─a87120be-53c0-11ec-1146-95eef8ddb63c
# ╟─a87120dc-53c0-11ec-167c-c385573b7a7a
# ╟─a871238e-53c0-11ec-2cf5-a148746c1b51
# ╟─a87123a2-53c0-11ec-1630-934509279bb3
# ╟─a87123c0-53c0-11ec-395d-93bd974b2a11
# ╟─a87124bc-53c0-11ec-14f5-952a697fb3c3
# ╟─a87124ce-53c0-11ec-2f72-93ea573b0aa4
# ╟─a8712ce4-53c0-11ec-259a-cd96c0cd20dc
# ╟─a8712f98-53c0-11ec-224b-afd9fbfc5dba
# ╟─a8712fb4-53c0-11ec-1825-dd24949368a4
# ╟─a8713018-53c0-11ec-39cd-a9558d7e8861
# ╟─a871304a-53c0-11ec-1906-6ff9a4d07fee
# ╠═a87137d6-53c0-11ec-3e69-158d1b563fcc
# ╟─a87137fc-53c0-11ec-0e63-896af6aff6bb
# ╟─a87139c8-53c0-11ec-20e8-a3ec744ef1b8
# ╟─a87139e6-53c0-11ec-26c2-5bc95bfeb82f
# ╟─a8713b9e-53c0-11ec-358b-a52d769cb16a
# ╟─a8713bb2-53c0-11ec-251e-193bad4ab989
# ╟─a87142f6-53c0-11ec-2c9b-85e213343948
# ╟─a8714328-53c0-11ec-395c-fb73a116e1eb
# ╟─a8714b2a-53c0-11ec-03f4-59f2ae706d04
# ╟─a8714b66-53c0-11ec-34b2-45d125819315
# ╟─a8714b8e-53c0-11ec-2829-b1b573692864
# ╟─a8714b98-53c0-11ec-215f-f523f73f5bae
# ╟─a8715fc0-53c0-11ec-118e-c7412068b46d
# ╟─a8715fde-53c0-11ec-14d6-cd2d2365cf1e
# ╟─a871601a-53c0-11ec-0e0c-59bbff314291
# ╟─a8716024-53c0-11ec-39ae-fb6f964220db
# ╟─a871747e-53c0-11ec-3bd8-55944495452a
# ╟─a87174c4-53c0-11ec-3dc4-4fab62579c47
# ╟─a8718a9a-53c0-11ec-3ceb-c3c0ed0ae507
# ╟─a8718ae0-53c0-11ec-2779-e1e1ea26f2b0
# ╟─a8719ed6-53c0-11ec-35fc-c11c406b8b9b
# ╟─a8719f08-53c0-11ec-0aee-cd3c86a0241c
# ╟─a8719f12-53c0-11ec-1d7a-d10cd57501c7
# ╟─a8719f12-53c0-11ec-1fef-51a3d7c025b9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
