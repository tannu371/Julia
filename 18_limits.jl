### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 528d4f5e-539f-11ec-2567-9f7f2cab1cc9
begin
	using CalculusWithJulia
	using Plots
	using Richardson  # for extrapolation
	using SymPy       # for symbolic limits
end

# ╔═╡ 528d538c-539f-11ec-1416-314c796cd145
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	fig_size=(400, 300)
	nothing
end

# ╔═╡ 52939efe-539f-11ec-1a1f-dd6c8508882f
using PlutoUI

# ╔═╡ 52939ee0-539f-11ec-1acb-3bc2016c9c4f
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 528cbf1c-539f-11ec-32f6-55de3c3084bd
md"""# Limits
"""

# ╔═╡ 528cc0e8-539f-11ec-2395-639d63584853
md"""This section uses the following add-on packages:
"""

# ╔═╡ 528d540e-539f-11ec-24f9-83c8479f1a30
md"""---
"""

# ╔═╡ 528d5472-539f-11ec-366a-bf3b87e1d4a6
md"""An historic problem in the history of math was to find the area under the graph of $f(x)=x^2$ between $[0,1]$.
"""

# ╔═╡ 528d5508-539f-11ec-09c6-2111c373abef
md"""There wasn't a ready-made formula for the area of this shape, as was known for a triangle or a square. However, [Archimedes](http://en.wikipedia.org/wiki/The_Quadrature_of_the_Parabola) found a method to compute areas enclosed by a parabola and line segments that cross the parabola.
"""

# ╔═╡ 528d59c2-539f-11ec-1d3a-137230999d31
let
	###{{{archimedes_parabola}}}
	pyplot()
	
	f(x) = x^2
	colors = [:black, :blue, :orange, :red, :green, :orange, :purple]
	
	## Area of parabola
	function make_triangle_graph(n)
	    title = "Area of parabolic cup ..."
	    n==1 && (title = "\${Area = }1/2\$")
	    n==2 && (title = "\${Area = previous }+ 1/8\$")
	    n==3 && (title = "\${Area = previous }+ 2\\cdot(1/8)^2\$")
	    n==4 && (title = "\${Area = previous }+ 4\\cdot(1/8)^3\$")
	    n==5 && (title = "\${Area = previous }+ 8\\cdot(1/8)^4\$")
	    n==6 && (title = "\${Area = previous }+ 16\\cdot(1/8)^5\$")
	    n==7 && (title = "\${Area = previous }+ 32\\cdot(1/8)^6\$")
	
	
	
	    plt = plot(f, 0, 1, legend=false, size = fig_size, linewidth=2)
	    annotate!(plt, [(0.05, 0.9, text(title,:left))])  # if in title, it grows funny with gr
	    n >= 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linetype=:polygon, fill=colors[1], alpha=.2)
	    n == 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linewidth=2)
	    for k in 2:n
	        xs = range(0,stop=1, length=1+2^(k-1))
	        ys = map(f, xs)
	        k < n && plot!(plt, xs, ys, linetype=:polygon, fill=:black, alpha=.2)
	        if k == n
	            plot!(plt, xs, ys, color=colors[k], linetype=:polygon, fill=:black, alpha=.2)
	            plot!(plt, xs, ys, color=:black, linewidth=2)
	        end
	    end
	    plt
	end
	
	
	n = 7
	anim = @animate for i=1:n
	    make_triangle_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	The first triangle has area $1/2$, the second has area $1/8$, then $2$ have area $(1/8)^2$, $4$ have area $(1/8)^3$, ...
	With some algebra, the total area then should be $1/2 \cdot (1 + (1/4) + (1/4)^2 + \cdots) = 2/3$.
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 528d59fe-539f-11ec-0031-b7d9b0adcc60
md"""The figure illustrates a means to compute the area bounded by the parabola, the line $y=1$ and the line $x=0$ using triangles. It suggests that this area can be found by adding the following sum
"""

# ╔═╡ 528d5a76-539f-11ec-2160-2fdca30b4183
md"""```math
A = 1/2 + 1/8 + 2 \cdot (1/8)^2 + 4 \cdot (1/8)^3 + \cdots
```
"""

# ╔═╡ 528d5ab2-539f-11ec-39f3-6d457e4adefb
md"""This value is $2/3$, so the area under the curve would be $1/3$. Forget about this specific value - which through more modern machinery becomes uneventful - and focus for a minute on the method: a problem is solved by a suggestion of an infinite process, in this case the creation of more triangles to approximate the unaccounted for area. This is the so-call method of [exhaustion](http://en.wikipedia.org/wiki/Method_of_exhaustion) known since the 5th century BC.
"""

# ╔═╡ 528d5ac6-539f-11ec-3626-81569abb34ea
md"""Archimedes used this method to solve a wide range of area problems related to basic geometric shapes, including a more general statement of what we described above.
"""

# ╔═╡ 528d5b02-539f-11ec-2fe9-89a02a548528
md"""The $\cdots$ in the sum expression are the indication that this process continues and that the answer is at the end of an *infinite* process. To make this line of reasoning rigorous requires the concept of a limit. The concept of a limit is then an old one, but it wasn't until the age of calculus that it was formalized.
"""

# ╔═╡ 528d5b1e-539f-11ec-103e-df61545e4253
md"""Next, we illustrate how Archimedes approximated $\pi$ – the ratio of the circumference of a circle to its diameter – using interior and exterior $n$-gons whose perimeters could be computed.
"""

# ╔═╡ 528d5e68-539f-11ec-272a-03f336774119
let
	## Archimedes approximation for pi
	
	pyplot()
	blue, green, purple, red = :royalblue, :forestgreen, :mediumorchid3, :brown3
	
	
	function archimedes!(p, n, xy=(0,0), radius=1; color=blue)
	
	    x₀,y₀=xy
	    ts = range(0, 2pi, length=100)
	
	
	
	    plot!(p, x₀ .+ sin.(ts), y₀ .+ cos.(ts), linewidth=2)
	
	    α = ((2π)/n)/2
	    αs = (-pi/2 + α):2α:(3pi/2 + α)
	    r = radius/cos(α)
	
	    xs = x₀ .+ r*cos.(αs)
	    ys = y₀ .+ r*sin.(αs)
	
	    plot!(p, xs, ys, linewidth=2, alpha=0.6)
	    plot!(p, xs, ys,
	          fill=true,
	          fillcolor=color,
	          alpha=0.4)
	
	    r = radius
	    xs = x₀ .+ r*cos.(αs)
	    ys = y₀ .+ r*sin.(αs)
	
	    plot!(p, xs, ys, linewidth=2, alpha=0.6)
	    plot!(p, xs, ys,
	          fill=true,
	          fillcolor=color,
	          alpha=0.8)
	
	    p
	end
	
	ns = [4,5,7,9]
	xs = [1, 3.5, 1, 3.5]
	ys = [3.5, 3.5, 1, 1]
	p = plot(;xlims=(-.25, 4.75), ylims=(-0.25, 4.75),
	         axis=nothing,
	         xaxis=false,
	         yaxis=false,
	         legend=false,
	         padding = (0.0, 0.0),
	             background_color = :transparent,
	         foreground_color = :black,
	         aspect_ratio=:equal)
	
	for (x, y, n, col) ∈ zip(xs, ys, ns, (blue, green, purple, red))
	    archimedes!(p, n, (x, y), color=col)
	end
	
	caption = L"""
	The ratio of the circumference of a circle to its diameter, $\pi$, can be approximated from above and below by computing the perimeters of the inscribed $n$-gons. Archimedes computed the perimeters for $n$ being $12$, $24$, $48$, and $96$ to determine that $3~1/7 \leq \pi \leq 3~10/71$.
	"""
	
	ImageFile(p, caption)
end

# ╔═╡ 528d5eb8-539f-11ec-0753-b74b8f6fc827
md"""Here Archimedes uses *bounds* to constrain an unknown value. Had he been able to compute these bounds for larger and larger $n$ the value of $\pi$ could be more accurately determined. In a "limit" it would be squeezed in to have a specific value, which we now know is an irrational number.
"""

# ╔═╡ 528d5ee0-539f-11ec-2bd7-ef4c94d6cb70
md"""Continuing these concepts, [Fermat](http://en.wikipedia.org/wiki/Adequality) in the 1600s essentially took a limit to find the slope of a tangent line to a polynomial curve. Newton in the late 1600s, exploited the idea in his development of calculus (as did Leibniz). Yet it wasn't until the 1800s that [Bolzano](http://en.wikipedia.org/wiki/Limit_of_a_function#History), Cauchy and Weierstrass put the idea on a firm footing.
"""

# ╔═╡ 528d5ef2-539f-11ec-323f-a5940533e75e
md"""To make things more precise, we begin by discussing the limit of a univariate function as $x$ approaches $c$.
"""

# ╔═╡ 528d5f12-539f-11ec-0c2e-594390726af0
md"""Informally, if a limit exists it is the value that $f(x)$ gets close to as $x$ gets close to - but not equal to - $c$.
"""

# ╔═╡ 528d5f1c-539f-11ec-18e8-7ba6b3c55146
md"""The modern formulation is due to Weirstrass:
"""

# ╔═╡ 528d75a6-539f-11ec-3c51-dda585b503f7
md"""> The limit of $f(x)$ as $x$ approaches $c$ is $L$ if for every real $\epsilon > 0$, there exists a real $\delta > 0$ such that for all real $x$, $0 < \lvert x − c \rvert < \delta$ implies $\lvert f(x) − L \rvert < \epsilon$. The notation used is $\lim_{x \rightarrow c}f(x) = L$.

"""

# ╔═╡ 528d75ce-539f-11ec-12a5-91f254529cd0
md"""We comment on this later.
"""

# ╔═╡ 528d760a-539f-11ec-1757-479d3f5ab0af
md"""Cauchy begins his incredibly influential [treatise](http://gallica.bnf.fr/ark:/12148/bpt6k90196z/f17.image) on calculus considering two examples, the limit as $x$ goes to $0$ of
"""

# ╔═╡ 528d761e-539f-11ec-10f5-612bb0b90a13
md"""```math
\frac{\sin(x)}{x} \quad\text{and}\quad (1 + x)^{1/x}.
```
"""

# ╔═╡ 528d763c-539f-11ec-3cbf-4d4fb6fad552
md"""These take the indeterminate forms $0/0$ and $1^\infty$, which are found by just putting $0$ in for $x$. An expression does not need to be defined at $c$, as these two aren't, to discuss its limit. Cauchy illustrates two methods to approach the questions above. The first is to pull out an inequality:
"""

# ╔═╡ 528d7650-539f-11ec-3c46-55c002353216
md"""```math
\frac{\sin(x)}{\sin(x)} > \frac{\sin(x)}{x} > \frac{\sin(x)}{\tan(x)}
```
"""

# ╔═╡ 528d7664-539f-11ec-31b2-f5dbd6b8211e
md"""which is equivalent to:
"""

# ╔═╡ 528d766e-539f-11ec-16d6-8312f83edf7f
md"""```math
1 > \frac{\sin(x)}{x} > \cos(x)
```
"""

# ╔═╡ 528d76a0-539f-11ec-0cba-09a1a06aca8a
md"""This bounds the expression $\sin(x)/x$ between $1$ and $\cos(x)$ and as $x$ gets close to $0$, the value of $\cos(x)$ "clearly" goes to $1$, hence $L$ must be $1$. This is an application of the squeeze theorem, the same idea Archimedes implied when bounding the value for $\pi$ above and below.
"""

# ╔═╡ 528d76b4-539f-11ec-3a97-6bcfb0878f3f
md"""The above bound comes from this figure, for small $x > 0$:
"""

# ╔═╡ 528dbbec-539f-11ec-043d-81263d6b4a33
let
	p = plot(x -> sqrt(1 - x^2), 0, 1, legend=false, aspect_ratio=:equal,
	     linewidth=3, color=:black)
	θ = π/6
	y,x = sincos(θ)
	col=RGBA(0.0,0.0,1.0, 0.25)
	plot!(range(0,x, length=2), zero, fillrange=u->y/x*u, color=col)
	plot!(range(x, 1, length=50), zero, fillrange = u -> sqrt(1 - u^2), color=col)
	plot!([x,x],[0,y], linestyle=:dash, linewidth=3, color=:black)
	plot!([x,1],[y,0], linestyle=:dot, linewidth=3, color=:black)
	plot!([1,1], [0,y/x], linewidth=3, color=:black)
	plot!([0,1], [0,y/x], linewidth=3, color=:black)
	plot!([0,1], [0,0], linewidth=3, color=:black)
	Δ = 0.05
	annotate!([(0,0+Δ,"A"), (x-Δ,y+Δ/4, "B"), (1+Δ/2,y/x, "C"),
	           (1+Δ/2,0+Δ/2,"D")])
	annotate!([(.2*cos(θ/2), 0.2*sin(θ/2), "θ")])
	imgfile = tempname() * ".png"
	savefig(p, imgfile)
	caption = "Triangle  ABD has less area than the shaded wedge, which has less area than triangle ACD. Their respective areas are ``(1/2)\\sin(\\theta)``, ``(1/2)\\theta``, and ``(1/2)\\tan(\\theta)``. The inequality used to show ``\\sin(x)/x`` is bounded below by ``\\cos(x)`` and above by ``1`` comes from a division by ``(1/2) \\sin(x)`` and taking reciprocals.
	"
	CalculusWithJulia.WeaveSupport.ImageFile(imgfile, caption)
end

# ╔═╡ 528dbc50-539f-11ec-398d-751b6300b4a0
md"""To discuss the case of $(1+x)^{1/x}$ it proved convenient to assume $x = 1/m$ for integer values of $m$. At the time of Cauchy, log tables were available to identify the approximate value of the limit. Cauchy computed the following value from logarithm tables. approximate value:
"""

# ╔═╡ 528dc148-539f-11ec-177c-b153eb488554
let
	x = 1/10000
	(1 + x)^(1/x)
end

# ╔═╡ 528dc164-539f-11ec-0669-478ad4957fde
md"""A table can show the progression to this value:
"""

# ╔═╡ 528dc830-539f-11ec-2116-41069de560bf
let
	f(x) = (1 + x)^(1/x)
	xs = [1/10^i for i in 1:5]
	[xs f.(xs)]
end

# ╔═╡ 528dc858-539f-11ec-3b91-f37362ec1f8c
md"""This progression can be seen to be increasing. Cauchy, in his treatise, can see this through:
"""

# ╔═╡ 528dc876-539f-11ec-0e08-359d8d07a8ae
md"""```math
\begin{align*}
(1 + \frac{1}{m})^n &= 1 + \frac{1}{1} + \frac{1}{1\cdot 2}(1 = \frac{1}{m}) +  \\
& \frac{1}{1\cdot 2\cdot 3}(1 - \frac{1}{m})(1 -  \frac{2}{m}) + \cdots +
& \frac{1}{1 \cdot 2 \cdot \cdots \cdot m}(1 - \frac{1}{m}) \cdot \cdots \cdot (1 - \frac{m-1}{m}).
\end{align*}
```
"""

# ╔═╡ 528dc89e-539f-11ec-2204-7bee55b34aa8
md"""These values are clearly increasing as $m$ increases. Cauchy showed the value was bounded between $2$ and $3$ and had the approximate value above. Then he showed the restriction to integers was not necessary. Later we will use this definition for the exponential function:
"""

# ╔═╡ 528dc8b0-539f-11ec-2807-2923ed651552
md"""```math
e^x = \lim_{n \rightarrow \infty} (1 + x/n)^n,
```
"""

# ╔═╡ 528dc8bc-539f-11ec-0ddc-4d71ca5a9c81
md"""with a suitably defined limit.
"""

# ╔═╡ 528dc8d0-539f-11ec-1428-590cab5b5847
md"""These two cases illustrate that though the definition of the limit exists, the computation of a limit is generally found by other means and the intuition of the value of the limit can be gained numerically.
"""

# ╔═╡ 528dc95c-539f-11ec-096c-7bbc2dbb691d
md"""### Indeterminate forms
"""

# ╔═╡ 528dc9b8-539f-11ec-105e-1bb5b9a92b52
md"""First it should be noted that for most of the functions encountered, the concepts of a limit at a typical point $c$ is nothing more than just function evaluation at $c$. This is because, at a typical point, the functions are nicely behaved (what we will soon call "*continuous*"). However, most questions asked about limits find points that are not typical. For these, the result of evaluating the function at $c$ is typically undefined, and the value comes in one of several *indeterminate forms*: $0/0$, $\infty/\infty$, $0 \cdot \infty$, $\infty - \infty$, $0^0$, $1^\infty$, and $\infty^0$.
"""

# ╔═╡ 528f5312-539f-11ec-1377-a771530cc319
md"""`Julia` can help - at times - identify these indeterminate forms, as many such operations produce `NaN`. For example:
"""

# ╔═╡ 528f5b78-539f-11ec-13dc-1ff8a95fb756
0/0, Inf/Inf, 0 * Inf, Inf - Inf

# ╔═╡ 528f5be6-539f-11ec-0b3b-dd975c62769b
md"""However, the values with powers generally do not help, as the IEEE standard has `0^0` evaluating to 1:
"""

# ╔═╡ 528f74b2-539f-11ec-025b-3d2aea3f3f0f
0^0, 1^Inf, Inf^0

# ╔═╡ 528f755e-539f-11ec-2e47-5b5a340d56d4
md"""However, this can be unreliable, as floating point issues may mask the true evaluation. However, as a cheap trick it can work. So, the limit as $x$ goes to $1$ of $\sin(x)/x$ is simply found by evaluation:
"""

# ╔═╡ 528f7a0e-539f-11ec-2709-f7da9af9358b
let
	x = 1
	sin(x) / x
end

# ╔═╡ 528f7a4a-539f-11ec-04b0-b16d18ddc9aa
md"""But at $x=0$ we get an indicator that there is an issue with just evaluating the function:
"""

# ╔═╡ 528f7d88-539f-11ec-22f7-69cc0f60e6ee
let
	x = 0
	sin(x) / x
end

# ╔═╡ 528f7de2-539f-11ec-20b4-4b439f686942
md"""The above is really just a heuristic. For some functions this is just not true. For example, the $f(x) = \sqrt{x}$ is only defined on $[0, \infty)$ There is technically no limit at $0$, per se, as the function is not defined around $0$. Other functions jump at values, and will not have a limit, despite having well defined values. The `floor` function is the function that rounds down to the nearest integer. At integer values there will be a jump (and hence have no limit), even though the function is defined.
"""

# ╔═╡ 528f7eca-539f-11ec-16c8-594aca538ad6
md"""## Graphical approaches to limits
"""

# ╔═╡ 528f7f2e-539f-11ec-1eac-4f322095b8d3
md"""Let's return to the function $f(x) = \sin(x)/x$. This function was studied by Euler as part of his solution to the [Basel](http://en.wikipedia.org/wiki/Basel_problem) problem. He knew that near $0$, $\sin(x) \approx x$, so the ratio is close to $1$ if $x$ is near $0$. Hence, the intuition is $\lim_{x \rightarrow 0} \sin(x)/x = 1$, as Cauchy wrote. We can verify this limit graphically two ways. First, a simple graph shows no issue at $0$:
"""

# ╔═╡ 528f842c-539f-11ec-0b78-8f323d9fa4d7
let
	f(x) = sin(x)/x
	xs, ys = unzip(f, -pi/2, pi/2)  # get points used to plot `f`
	plot(xs,  ys)
	scatter!(xs, ys)
end

# ╔═╡ 528f8490-539f-11ec-0ce7-87127cd48170
md"""The $y$ values of the graph seem to go to $1$ as the $x$ values get close to 0. (That the graph looks defined at $0$ is due to the fact that the points sampled to graph do not include $0$, as shown through the `scatter!` command – which can be checked via `minimum(abs, xs)`.)
"""

# ╔═╡ 528f849c-539f-11ec-0308-47434ee8a871
md"""We can also verify Euler's intuition through this graph:
"""

# ╔═╡ 528f8c38-539f-11ec-0dff-aff75d3a6146
let
	plot(sin, -pi/2,  pi/2)
	plot!(identity)    # the function y = x, like how zero is y = 0
end

# ╔═╡ 528f8c88-539f-11ec-3dc4-cf765c2d0dcd
md"""That the two are indistinguishable near $0$ makes it easy to see that their ratio should be going towards $1$.
"""

# ╔═╡ 528f8cc4-539f-11ec-06f7-7769376b8348
md"""A parametric plot shows the same, we see below the slope at $(0,0)$ is *basically* $1$, because the two functions are varying at the same rate when they are each near $0$
"""

# ╔═╡ 528f91b0-539f-11ec-24cb-17444535eea6
let
	plot(sin, identity, -pi/2, pi/2)  # parametric plot
end

# ╔═╡ 528f91e2-539f-11ec-30c9-312352a65e32
md"""The graphical approach to limits - plotting $f(x)$ around $c$ and observing if the $y$ values seem to converge to an $L$ value when $x$ get close to $c$ - allows us to gather quickly if a function seems to have a limit at $c$, though the precise value of $L$ may be hard to identify.
"""

# ╔═╡ 528f9264-539f-11ec-0ed8-7f2b77f49e44
md"""##### Example
"""

# ╔═╡ 528f9282-539f-11ec-33e3-09414808289e
md"""Consider now the following limit
"""

# ╔═╡ 528f92a8-539f-11ec-280c-69342f7f2fd3
md"""```math
\lim_{x \rightarrow 2} \frac{x^2 - 5x + 6}{x^2 +x - 6}
```
"""

# ╔═╡ 528f92be-539f-11ec-02af-0f9084ffbc69
md"""Noting that this is a ratio of nice polynomial functions, we first check whether there is anything to do:
"""

# ╔═╡ 528fae32-539f-11ec-023f-ed2430d43454
let
	f(x) = (x^2 - 5x + 6) / (x^2 + x - 6)
	c = 2
	f(c)
end

# ╔═╡ 528fae8e-539f-11ec-2573-5b6837dc498b
md"""The `NaN` indicates that this function is indeterminate at $c=2$. A quick plot gives us an idea that the limit exists and is roughly $-0.2$:
"""

# ╔═╡ 528fb41a-539f-11ec-1a53-cff9d2b4e8ef
let
	c, delta = 2, 1
	plot(x -> (x^2 - 5x + 6) / (x^2 + x - 6), c - delta, c + delta)
end

# ╔═╡ 528fb460-539f-11ec-3dfa-61fda75b5452
md"""The graph looks "continuous." In fact, the value $c=2$ is termed a *removable singularity* as redefining $f(x)$ to be $-0.2$ when $x=2$ results in a "continuous" function.
"""

# ╔═╡ 528fb47e-539f-11ec-215f-0be94571998a
md"""As an aside, we can redefine `f` using the "ternary operator":
"""

# ╔═╡ 528fb4a8-539f-11ec-0b13-03588a1c92e6
md"""```
f(x) = x == 2.0 ? -0.2 :  (x^2 - 5x + 6) / (x^2 + x - 6)
```"""

# ╔═╡ 528fb4c4-539f-11ec-07ae-1b1c5261741c
md"""This particular case is a textbook example: one can easily factor $f(x)$ to get:
"""

# ╔═╡ 528fb4e2-539f-11ec-3e78-ff91b9d38489
md"""```math
f(x) = \frac{(x-2)(x-3)}{(x-2)(x+3)}
```
"""

# ╔═╡ 528fb508-539f-11ec-1811-a1d145cfcf38
md"""Written in this form, we clearly see that this is the same function as $g(x) = (x-3)/(x+3)$ when $x \neq 2$. The function $g(x)$ is "continuous" at $x=2$. So were one to redefine $f(x)$ at $x=2$ to be $g(2) = (2 - 3)/(2 + 3) = -0.2$ it would be made continuous, hence the term removable singularity.
"""

# ╔═╡ 528fb528-539f-11ec-2976-7b97827e5543
md"""## Numerical approaches to limits
"""

# ╔═╡ 528fb546-539f-11ec-2e60-7fb0fa52d1fd
md"""The investigation of $\lim_{x \rightarrow 0}(1 + x)^{1/x}$ by evaluating the function at $1/10000$ by Cauchy can be done much more easily nowadays. As does a graphical approach, a numerical approach can give insight into a limit and often a good numeric estimate.
"""

# ╔═╡ 528fb564-539f-11ec-2f94-3d017baafbd5
md"""The basic idea is to create a sequence of $x$ values going towards $c$ and then investigate if the corresponding $y$ values are eventually near some $L$.
"""

# ╔═╡ 528fb578-539f-11ec-2669-7fbbc7ad3286
md"""Best, to see by example. Suppose we are asked to investigate
"""

# ╔═╡ 528fb582-539f-11ec-3462-7df120c4cc43
md"""```math
\lim_{x \rightarrow 25} \frac{\sqrt{x} - 5}{\sqrt{x - 16} - 3}.
```
"""

# ╔═╡ 528fb596-539f-11ec-13d2-17128d778226
md"""We first define a function and check if there are issues at 25:
"""

# ╔═╡ 528fbcb4-539f-11ec-1798-5df4660cd905
f(x) = (sqrt(x) - 5) / (sqrt(x-16) - 3)

# ╔═╡ 528fbfd2-539f-11ec-27cd-3d7f690e3f6e
begin
	c = 25
	f(c)
end

# ╔═╡ 528fc00e-539f-11ec-0c60-278930c2dbb3
md"""So yes, an issue of the indeterminate form $0/0$. We investigate numerically by making a set of numbers getting close to $c$. This is most easily done making numbers getting close to $0$ and adding them to or subtracting them from $c$. Some natural candidates are negative powers of 10:
"""

# ╔═╡ 528fc7c2-539f-11ec-21cb-1dc5d1b57491
hs = [1/10^i for i in 1:8]

# ╔═╡ 528fc7f4-539f-11ec-314a-698636879275
md"""We can add these to $c$ and then evaluate:
"""

# ╔═╡ 528fcbee-539f-11ec-2729-d701cccbc986
begin
	xs = c .+ hs
	ys = f.(xs)
end

# ╔═╡ 528fcc20-539f-11ec-0c25-53780bb1a492
md"""To visualize, we can put in a table using `[xs ys]` notation:
"""

# ╔═╡ 528fcf68-539f-11ec-1d48-492d4ef7266e
[xs ys]

# ╔═╡ 528fcfa4-539f-11ec-05c9-7db79b225c32
md"""The $y$-values seem to be getting near $0.6$.
"""

# ╔═╡ 528fcfd6-539f-11ec-321a-a11aec0b0740
md"""Since limits are defined by the expression $0 < \lvert x-c\rvert < \delta$, we should also look at values smaller than $c$. There isn't much difference (note the `.-` sign in `c .- hs`):
"""

# ╔═╡ 528fd330-539f-11ec-071b-65cf38e52b06
let
	xs = c .- hs
	ys = f.(xs)
	[xs ys]
end

# ╔═╡ 528fd35a-539f-11ec-2498-338547f4c2ea
md"""Same story. The numeric evidence supports a limit of $L=0.6$.
"""

# ╔═╡ 528fd36e-539f-11ec-10d9-351981d5193d
md"""##### Example, the secant line
"""

# ╔═╡ 528fd38c-539f-11ec-2da9-53229a0ce465
md"""Let $f(x) = x^x$ and consider the ratio:
"""

# ╔═╡ 528fd3a0-539f-11ec-0e92-51b86d840127
md"""```math
\frac{f(c + h) - f(c)}{h}
```
"""

# ╔═╡ 528fd3d4-539f-11ec-014e-7f83fd3d8175
md"""As $h$ goes to $0$, this will take the form $0/0$ in most cases, and in the particular case of $f(x) = x^x$ and $c=1$ it will be. The expression has a geometric interpretation of being the slope of the secant line connecting the two points $(c,f(c))$ and $(c+h, f(c+h))$.
"""

# ╔═╡ 528fd3e6-539f-11ec-26b1-5187c3d350b2
md"""To look at the limit in this example, we have (recycling the values in `hs`):
"""

# ╔═╡ 528fd710-539f-11ec-1e30-777d16f16254
let
	c = 1
	f(x) = x^x
	ys = [(f(c + h) - f(c)) / h for  h in hs]
	[hs ys]
end

# ╔═╡ 528fd72e-539f-11ec-1563-e301051a2e74
md"""The limit looks like $L=1$. A similar check on the left will confirm this numerically.
"""

# ╔═╡ 528fd756-539f-11ec-295d-ab6f73993f87
md"""### Issues with the numeric approach
"""

# ╔═╡ 528fd768-539f-11ec-39df-8757c42f3be4
md"""The numeric approach often gives a good intuition as to the existence of a limit and its value. However, it can be misleading. Consider this limit question:
"""

# ╔═╡ 528fd77e-539f-11ec-3606-cd14f54fce28
md"""```math
\lim_{x \rightarrow 0} \frac{1 - \cos(x)}{x^2}.
```
"""

# ╔═╡ 528fd792-539f-11ec-2b19-310888a6d1e7
md"""We can see that it is indeterminate of the form $0/0$:
"""

# ╔═╡ 528fddb4-539f-11ec-0afb-eff723768e9e
begin
	g(x) = (1 - cos(x)) / x^2
	g(0)
end

# ╔═╡ 528fddde-539f-11ec-1deb-adb6e6661152
md"""What is the value of $L$, if it exists? A quick attempt numerically yields:
"""

# ╔═╡ 528fe26e-539f-11ec-1cc3-b15f65111887
begin
	𝒙s = 0 .+ hs
	𝒚s = [g(x) for x in 𝒙s]
	[𝒙s 𝒚s]
end

# ╔═╡ 528ff556-539f-11ec-24ff-d7e817fc8561
md"""Hmm, the values in `ys` appear to be going to $0.5$, but then end up at $0$. Is the limit $0$ or $1/2$? The answer is $1/2$. The last $0$ is an artifact of floating point arithmetic and the last few deviations from `0.5` due to loss of precision in subtraction. To investigate, we look more carefully at the two ratios:
"""

# ╔═╡ 528ffe3e-539f-11ec-1e1a-431553d972b3
begin
	y1s = [1 - cos(x) for x in 𝒙s]
	y2s = [x^2 for x in 𝒙s]
	[𝒙s y1s y2s]
end

# ╔═╡ 528ffeca-539f-11ec-2b35-b561c499b94f
md"""Looking at the bottom of the second column reveals the error. The value of `1 - cos(1.0e-8)` is `0` and not a value around `5e-17`, as would be expected from the pattern above it. This is because the smallest floating point value less than `1.0` is more than `5e-17` units away, so `cos(1e-8)` is evaluated to be `1.0`. There just isn't enough granularity to get this close to $0$.
"""

# ╔═╡ 528ffede-539f-11ec-2cc0-17b5cb8858a1
md"""Not that we needed to. The answer would have been clear if we had stopped with `x=1e-6`, say.
"""

# ╔═╡ 528ffef2-539f-11ec-082f-9384177f14dd
md"""In general, some functions will frustrate the numeric approach. It is best to be wary of results. At a minimum they should confirm what a quick graph shows, though even that isn't enough, as this next example shows.
"""

# ╔═╡ 528fff10-539f-11ec-3f54-911d2ae9b32a
md"""##### Example
"""

# ╔═╡ 528fff36-539f-11ec-3470-435c190e9654
md"""Let $h(x)$ be defined by
"""

# ╔═╡ 528fff56-539f-11ec-3a84-63b0da827f06
md"""```math
h(x) = x^2 + 1 + \log(| 11 \cdot x - 15 |)/99.
```
"""

# ╔═╡ 528fff60-539f-11ec-3ae4-9bc758a17d6a
md"""The question is to investigate
"""

# ╔═╡ 528fff74-539f-11ec-1766-f718eac58fcb
md"""```math
\lim_{x \rightarrow 15/11} h(x)
```
"""

# ╔═╡ 528fff7e-539f-11ec-071c-dd7c17584462
md"""A plot shows the answer appears to be straightforward:
"""

# ╔═╡ 52902170-539f-11ec-0932-3b2fcd98c5aa
begin
	h(x) = x^2 + 1 + log(abs(11*x - 15))/99
	plot(h, 15/11 - 1, 15/11 + 1)
end

# ╔═╡ 529021e8-539f-11ec-1945-d7e5a2c12e90
md"""Taking values near $15/11$ shows nothing too unusual:
"""

# ╔═╡ 52902672-539f-11ec-382e-c3b3061c1656
let
	c = 15/11
	hs = [1/10^i for i in 4:3:16]
	xs = c .+ hs
	[xs h.(xs)]
end

# ╔═╡ 52902698-539f-11ec-302b-ad708f9db5c8
md"""(Though both the graph and the table hint at something a bit odd.)
"""

# ╔═╡ 529026ca-539f-11ec-25db-3335b50a4187
md"""However the limit in this case is $-\infty$ (or DNE), as there is an aysmptote at $c=15/11$. The problem is the asymptote due to the logarithm is extremely narrow and happens between floating point values to the left and right of $15/11$.
"""

# ╔═╡ 5290277e-539f-11ec-057e-4b5298c66763
md"""### Richardson extrapolation
"""

# ╔═╡ 529027ce-539f-11ec-21b3-9305c9a7aa5b
md"""The [`Richardson`](https://github.com/JuliaMath/Richardson.jl) package provides a function to extrapolate a function `f(x)` to `f(x0)`, as the numeric limit does. We illustrate its use by example:
"""

# ╔═╡ 52902bc0-539f-11ec-3d2b-b96b08bc3a0a
let
	f(x) = sin(x)/x
	extrapolate(f, 1)
end

# ╔═╡ 52902be8-539f-11ec-07cf-45d559df8b1e
md"""The answer involves two terms, the second being an estimate for the error in the estimation of `f(0)`.
"""

# ╔═╡ 52902bfc-539f-11ec-23ae-5754c971639d
md"""The values the method chooses could be viewed as follows:
"""

# ╔═╡ 529036a6-539f-11ec-0544-6f13cac85b55
with_terminal() do
	extrapolate(1) do x  # using `do` notation for the function
	    @show x
	    sin(x)/x
	end
end

# ╔═╡ 529036ce-539f-11ec-259b-03176bce0fc7
md"""The `extrapolate` function avoids the numeric problems encountered in the following example
"""

# ╔═╡ 52903c82-539f-11ec-39c9-b536a93ce5d5
let
	f(x) = (1 - cos(x)) / x^2
	extrapolate(f, 1)
end

# ╔═╡ 52903cb4-539f-11ec-0817-73e09c2a953c
md"""To find limits at a value of `c` not equal to `0`, we set the `x_0` argument. For example,
"""

# ╔═╡ 52904448-539f-11ec-24b1-61122c1467c4
let
	f(x) = (sqrt(x) - 5) / (sqrt(x-16) - 3)
	c = 25
	extrapolate(f, 26, x0=25)
end

# ╔═╡ 5290447a-539f-11ec-2c04-7f6491c841da
md"""This value can also be `Inf`, in anticipation of infinite limits to be discussed in a subsequent section:
"""

# ╔═╡ 52908480-539f-11ec-2608-1bc0e90dfa98
let
	f(x) = (x^2 - 2x + 1)/(x^3 - 3x^2 + 2x + 1)
	extrapolate(f, 10, x0=Inf)
end

# ╔═╡ 529084da-539f-11ec-25b5-af153e32cdfb
md"""(The starting value should be to the right of any zeros of the denominator.)
"""

# ╔═╡ 52908502-539f-11ec-08d8-5796865dfabe
md"""## Symbolic approach to limits
"""

# ╔═╡ 5290855c-539f-11ec-0972-1556469cb783
md"""The `SymPy` package provides a `limit` function for finding the limit of an expression in a given variable. It must be loaded, as was done initially. The `limit` function's use requires the expression, the variable and a value for $c$. (Similar to the three things in the notation $\lim_{x \rightarrow c}f(x)$.)
"""

# ╔═╡ 52908582-539f-11ec-2517-b5276e3ac854
md"""For example, the limit at $0$ of $(1-\cos(x))/x^2$ is easily handled:
"""

# ╔═╡ 52908cf0-539f-11ec-033c-7b5eab4dc8ea
begin
	@syms x::real
	limit((1 - cos(x)) / x^2, x => 0)
end

# ╔═╡ 52908d18-539f-11ec-1544-975c2748e994
md"""The pair notation (`x => 0`) is used to indicate the variable and the value it is going to.
"""

# ╔═╡ 52908d40-539f-11ec-1b8f-436ab2daec3a
md"""##### Example
"""

# ╔═╡ 52908d60-539f-11ec-127d-9df88c98a447
md"""We look again at this function which despite having a vertical asymptote at $x=15/11$ has the property that it is positive for all floating point values, making both a numeric and graphical approach impossible:
"""

# ╔═╡ 52908e12-539f-11ec-3b6c-37e0dd39d099
md"""```math
f(x) = x^2 + 1 + \log(| 11 \cdot x - 15 |)/99.
```
"""

# ╔═╡ 52908f16-539f-11ec-0931-b72152892323
md"""We find the limit symbolically at $c=15/11$ as follows, taking care to use the exact value `15//11` and not the *floating point* approximation returned by `15/11`:
"""

# ╔═╡ 529098bc-539f-11ec-26a7-7f4ffe4d6675
let
	f(x) = x^2 + 1 + log(abs(11x - 15))/99
	limit(f(x), x => 15 // 11)
end

# ╔═╡ 529098e4-539f-11ec-3404-ab8ea094f0e4
md"""##### Example
"""

# ╔═╡ 52909916-539f-11ec-22db-f7e7211739bc
md"""Find the [limits](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule):
"""

# ╔═╡ 52909934-539f-11ec-22ab-cd4bb476f0c6
md"""```math
\lim_{x \rightarrow 0} \frac{2\sin(x) - \sin(2x)}{x - \sin(x)}, \quad
\lim_{x \rightarrow 0} \frac{e^x - 1 - x}{x^2}, \quad
\lim_{\rho \rightarrow 0} \frac{x^{1-\rho} - 1}{1 - \rho}.
```
"""

# ╔═╡ 52909948-539f-11ec-3b10-3bc613e870ab
md"""We have for the first:
"""

# ╔═╡ 5290a17c-539f-11ec-3a02-9b4ac3da3a1a
limit( (2sin(x) - sin(2x)) / (x - sin(x)), x => 0)

# ╔═╡ 5290a19a-539f-11ec-18ce-6582078bd7a9
md"""The second is similarly done, though here we define a function for variety:
"""

# ╔═╡ 5290c558-539f-11ec-2ea1-f9903fc9c7cc
let
	f(x) = (exp(x) - 1 - x) / x^2
	limit(f(x), x => 0)
end

# ╔═╡ 5290c58a-539f-11ec-350d-e18aecb3b210
md"""Finally, for the third we define a new variable and proceed:
"""

# ╔═╡ 5290c97e-539f-11ec-0a22-d9e278a6620c
begin
	@syms rho::real
	limit( (x^(1-rho) - 1) / (1 - rho), rho => 1)
end

# ╔═╡ 5290c9c2-539f-11ec-3898-2d945e75c059
md"""This last limit demonstrates that the `limit` function of `SymPy` can readily evaluate limits that involve parameters, though at times some assumptions on the parameters may be needed, as was done through `rho::real`
"""

# ╔═╡ 5290c9d6-539f-11ec-3740-85a9b7fa3500
md"""However, for some cases, the assumptions will not be enough, as they are broad. (E.g., something might be true for some values of the parameter and not others and these values aren't captured in the assumptions.)  So the user must be mindful that when parameters are involved, the answer may not reflect all possible cases.
"""

# ╔═╡ 5290c9ea-539f-11ec-31b5-ffb94997fb83
md"""##### Example, floating point conversion issues
"""

# ╔═╡ 5290ca1c-539f-11ec-2140-2dc9632f3da4
md"""The Gruntz [algorithm](http://www.cybertester.com/data/gruntz.pdf) implemented in `SymPy` for symbolic limits is quite powerful. However, some care must be exercised to avoid undesirable conversions from exact values to floating point values.
"""

# ╔═╡ 5290ca4e-539f-11ec-1034-1d9a6ae3dd98
md"""In a previous example, we used `15//11` and not `15/11`, as the former converts to an *exact* symbolic value for use in `SymPy`, but the latter would be approximated in floating point *before* this conversion so the exactness would be lost.
"""

# ╔═╡ 5290ca80-539f-11ec-1206-21b56b6e4ca6
md"""To illustrate further, let's look at the limit as $x$ goes to $\pi/2$ of $j(x) = \cos(x) / (x - \pi/2)$. We follow our past practice:
"""

# ╔═╡ 5290d034-539f-11ec-255f-a97b441a7fc3
begin
	j(x) = cos(x) / (x - pi/2)
	j(pi/2)
end

# ╔═╡ 5290d070-539f-11ec-07d9-8dbdb76594e5
md"""The value is not `NaN`, rather `Inf`. This is because `cos(pi/2)` is not exactly $0$ as it should be, as `pi/2` is rounded. This minor differaence is important. If we try and correct for this by using `PI` we have:
"""

# ╔═╡ 5290d49e-539f-11ec-0c35-d5ef9dcedcb9
limit(j(x), x => PI/2)

# ╔═╡ 5290d4c6-539f-11ec-2c16-6dafed7cfb91
md"""The value is not right, as this simple graph suggests the limit is in fact $-1$:
"""

# ╔═╡ 5290d924-539f-11ec-0313-5963795d7208
plot(j,  pi/4, 3pi/4)

# ╔═╡ 5290d956-539f-11ec-2e1a-ef232545088c
md"""The difference between `pi` and `PI` can be significant, and though usually `pi` is silently converted to `PI`, it doesn't happen here as the division by `2` happens first, which turns the symbol into an approximate floating point number. Hence, `SymPy` is giving the correct answer for the problem it is given, it just isn't the problem we wanted to look at.
"""

# ╔═╡ 5290d96c-539f-11ec-2949-63464dfa2d17
md"""Trying again, being more aware of how `pi` and `PI` differ, we have:
"""

# ╔═╡ 5290e178-539f-11ec-249c-cddf2aaae914
let
	f(x) = cos(x) / (x - PI/2)
	limit(f(x), x => PI/2)
end

# ╔═╡ 5290e1d2-539f-11ec-0823-8f48d54fdf58
md"""(The value `pi` is able to be exactly converted to `PI` when used in `SymPy`, as it is of type `Irrational`, and is not a floating point value. However, the expression `pi/2` converts `pi` to a floating point value and then divides by `2`, hence the loss of exactness when used symbolically.)
"""

# ╔═╡ 5290e1fa-539f-11ec-3ed4-b3039f3a4240
md"""##### Example: left and right limits
"""

# ╔═╡ 5290e254-539f-11ec-12d7-9b00e0ff4ca8
md"""Right and left limits will be discussed in the next section; here we give an example of the idea.  The mathematical convention is to say a limit exists if both the left *and* right limits exist and are equal. Informally a right (left) limit at $c$ only considers values of $x$ less (more) than $c$. The `limit` function of `SymPy`  finds directional limits by default, a right limit, where $x > c$.
"""

# ╔═╡ 5290e272-539f-11ec-20bc-9551aa96c677
md"""The left limit can be found by passing the argument `dir="-"`. Passing `dir="+-"` (and not `"-+"`) will compute the mathematical limit, throwing an error in `Python` if no limit exists.
"""

# ╔═╡ 5290eb08-539f-11ec-368a-13aae14d0df4
limit(ceil(x), x => 0), limit(ceil(x), x => 0, dir="-")

# ╔═╡ 5290eb28-539f-11ec-019c-87c3a6d1b223
md"""This accurately shows the limit does not exist mathematically, but `limit(ceil(x), x => 0)` does exist (as it finds a right limit).
"""

# ╔═╡ 5290eb50-539f-11ec-386d-4193bf9a0153
md"""## Rules for limits
"""

# ╔═╡ 5290ebac-539f-11ec-2b5e-3f2a00fca8a9
md"""The `limit` function doesn't compute limits from the definition, rather it applies some known facts about functions within a set of rules. Some of these rules are the following. Suppose the individual limits of $f$ and $g$ always exist (and are finite) below.
"""

# ╔═╡ 5290ebd2-539f-11ec-2477-87a048012def
md"""```math
\begin{align*}
\lim_{x \rightarrow c} (a \cdot f(x) + b \cdot g(x)) &= a \cdot
  \lim_{x \rightarrow c} f(x) + b \cdot \lim_{x \rightarrow c} g(x)
  &\\
%%
\lim_{x \rightarrow c} f(x) \cdot g(x) &= \lim_{x \rightarrow c}
  f(x) \cdot \lim_{x \rightarrow c} g(x)
  &\\
%%
\lim_{x \rightarrow c} \frac{f(x)}{g(x)} &=
  \frac{\lim_{x \rightarrow c} f(x)}{\lim_{x \rightarrow c} g(x)}
  &(\text{provided }\lim_{x \rightarrow c} g(x) \neq 0)\\
\end{align*}
```
"""

# ╔═╡ 5290ebde-539f-11ec-13a9-917afdca917d
md"""These are verbally described as follows, when the individual limits exist and are finite then:
"""

# ╔═╡ 529105d6-539f-11ec-1990-5be8e84947cb
md"""  * Limits involving sums, differences or scalar multiples of functions *exist* **and** can be **computed** by first doing the individual limits and then combining the answers appropriately.
  * Limits of products exist and can be found by computing the limits of the individual factors and then combining.
  * Limits of ratios *exist* and can be found by computing the limit of the individual terms and then dividing **provided** you don't divide by $0$. The last part is really important, as this rule is no help with the common indeterminate form $0/0$
"""

# ╔═╡ 52910608-539f-11ec-11dc-73682181bada
md"""In addition, consider the composition:
"""

# ╔═╡ 5291061c-539f-11ec-17fd-311c693fbee2
md"""```math
\lim_{x \rightarrow c} f(g(x))
```
"""

# ╔═╡ 5291062e-539f-11ec-3fd5-1161c0a0de92
md"""Suppose that
"""

# ╔═╡ 529106da-539f-11ec-080e-0937f1129e40
md"""  * The outer limit, $\lim_{x \rightarrow b} f(x) = L$, exists, and
  * the inner limit, $\lim_{x \rightarrow c} g(x) = b$, exists **and**
  * for some neighborhood around $c$ (not including $c$) $g(x)$ is not $b$,
"""

# ╔═╡ 529106ee-539f-11ec-3e96-b3863bde421b
md"""Then the limit exists and equals $L$:
"""

# ╔═╡ 52910704-539f-11ec-1b56-b5a40842420f
md"""$\lim_{x \rightarrow c} f(g(x)) = \lim_{u \rightarrow b} f(u) = L.$
"""

# ╔═╡ 5291072a-539f-11ec-355b-970196f9023e
md"""An alternative, is to assume $f(x)$ is defined at $b$ and equal to $L$ (which is the definition of continuity), but that isn't the assumption above, hence the need to exclude $g$ from taking on a value of $b$ (where $f$ may not be defined) near $c$.
"""

# ╔═╡ 5291073e-539f-11ec-01a9-a325781a1589
md"""These rules, together with the fact that our basic algebraic functions have limits that can be found by simple evaluation, mean that many limits are easy to compute.
"""

# ╔═╡ 52910752-539f-11ec-19ec-4772bf55e413
md"""##### Example, composition
"""

# ╔═╡ 52910770-539f-11ec-1b25-b52b7919a8b0
md"""For example, consider for some non-zero $k$ the following limit:
"""

# ╔═╡ 5291077a-539f-11ec-36f6-bf773a125b27
md"""```math
\lim_{x \rightarrow 0} \frac{\sin(kx)}{x}.
```
"""

# ╔═╡ 529107ac-539f-11ec-020d-e59b8819f200
md"""This is clearly related to the function $f(x) = \sin(x)/x$, which has a limit of $1$ as $x \rightarrow 0$. We see $g(x) = k f(kx)$ is the limit in question. As $kx \rightarrow 0$, though not taking a value of $0$ except when $x=0$, the limit above is $k \lim_{x \rightarrow 0} f(kx) = k \lim_{u \rightarrow 0} f(u) = 1$.
"""

# ╔═╡ 529107d4-539f-11ec-2428-3fb22d7b46a8
md"""Basically when taking a limit as $x$ goes to $0$ we can multiply $x$ by any constant and figure out the limit for that. (It is as though we "go to" $0$ faster or slower. but are still going to $0$.
"""

# ╔═╡ 529107de-539f-11ec-1bfd-2f49dea251e6
md"""Similarly,
"""

# ╔═╡ 529107f2-539f-11ec-0416-7f02ca22807b
md"""```math
\lim_{x \rightarrow 0} \frac{\sin(x^2)}{x^2} = 1,
```
"""

# ╔═╡ 52910810-539f-11ec-34d4-25c9f43be4e4
md"""as this is the limit of $f(g(x))$ with $f$ as above and  $g(x) = x^2$. We need $x \rightarrow 0$, $g$is only $0$ at $x=0$, which is the case.
"""

# ╔═╡ 52910824-539f-11ec-301a-31ce033d4f20
md"""##### Example, products
"""

# ╔═╡ 52910842-539f-11ec-1cf7-6b52efb8d183
md"""Consider this complicated limit found on this [Wikipedia](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule) page.
"""

# ╔═╡ 5291084c-539f-11ec-1459-413a6f9cd272
md"""```math
\lim_{x \rightarrow 1/2} \frac{\sin(\pi x)}{\pi x} \cdot \frac{\cos(\pi x)}{1 - (2x)^2}.
```
"""

# ╔═╡ 52910860-539f-11ec-0ad7-d3dce4ee9a9a
md"""We know the first factor has a limit found by evaluation: $2/\pi$, so it is really just a constant. The second we can compute:
"""

# ╔═╡ 5291113c-539f-11ec-3265-154826e01f0f
begin
	l(x) = cos(PI*x) / (1 - (2x)^2)
	limit(l, 1//2)
end

# ╔═╡ 5291116e-539f-11ec-177e-b371fca30b24
md"""Putting together, we would get $1/2$. Which we could have done directly in this case:
"""

# ╔═╡ 52911922-539f-11ec-2b1f-2120410938be
limit(sin(PI*x)/(PI*x) * l(x), x => 1//2)

# ╔═╡ 52911940-539f-11ec-1aa2-95862fb971c8
md"""##### Example, ratios
"""

# ╔═╡ 52911968-539f-11ec-16da-79d0ee19c215
md"""Consider again the limit of $\cos(\pi x) / (1 - (2x)^2)$ at $c=1/2$. A graph of both the top and bottom functions shows the indeterminate, $0/0$, form:
"""

# ╔═╡ 52911f3a-539f-11ec-26d1-655276d95573
begin
	plot(cos(pi*x), 0.4, 0.6)
	plot!(1 - (2x)^2)
end

# ╔═╡ 52911f80-539f-11ec-0b43-1741ab9e6731
md"""However, following Euler's insight that $\sin(x)/x$ will have a limit at $0$ of $1$ as $\sin(x) \approx x$, and $x/x$ has a limit of $1$ at $c=0$, we can see that $\cos(\pi x)$ looks like $-\pi\cdot (x - 1/2)$ and $(1 - (2x)^2)$ looks like $-4(x-1/2)$ around $x=1/2$:
"""

# ╔═╡ 5291249e-539f-11ec-274a-5d98edafb49c
begin
	plot(cos(pi*x), 0.4, 0.6)
	plot!(-pi*(x - 1/2))
end

# ╔═╡ 52913b00-539f-11ec-18fe-232d81f2b063
begin
	plot(1 - (2x)^2, 0.4, 0.6)
	plot!(-4(x - 1/2))
end

# ╔═╡ 52913b48-539f-11ec-24e8-27cf9e3b0b4c
md"""So around $c=1/2$ the ratio should look like $-\pi (x-1/2) / ( -4(x -	 1/2)) = \pi/4$, which indeed it does, as that is the limit.
"""

# ╔═╡ 52913b5a-539f-11ec-13d1-55fa993cc99c
md"""This is the basis of L'Hôpital's rule, which we will return to once the derivative is discussed.
"""

# ╔═╡ 52913b6e-539f-11ec-142e-5d3ee03d1187
md"""##### Example sums
"""

# ╔═╡ 52913b82-539f-11ec-1854-f5eb3da29c03
md"""If it is known that the following limit exists by some means:
"""

# ╔═╡ 52913ba0-539f-11ec-3786-1b823cf13604
md"""```math
L = 0 = \lim_{x \rightarrow 0} \frac{e^{\csc(x)}}{e^{\cot(x)}} - (1 + \frac{1}{2}x  + \frac{1}{8}x^2)
```
"""

# ╔═╡ 52913ba8-539f-11ec-2f62-8f70d355a44a
md"""Then this limit will exist
"""

# ╔═╡ 52913bbe-539f-11ec-2f5f-dff87f40abd0
md"""```math
M = \lim_{x \rightarrow 0} \frac{e^{\csc(x)}}{e^{\cot(x)}}
```
"""

# ╔═╡ 52913bda-539f-11ec-0d89-bda903aa6fbd
md"""Why? We can express the function $e^{\csc(x)}/e^{\cot(x)}$ as the above function plus the polynomial $1 + x/2 + x^2/8$. The above is then the sum of two functions whose limits exist and are finite, hence, we can conclude that $M = 0 + 1$.
"""

# ╔═╡ 52913bfa-539f-11ec-2ef7-ef281c9683b5
md"""## Limits from the definition
"""

# ╔═╡ 52913c36-539f-11ec-0a7e-575dc453628c
md"""The formal definition of a limit involves clarifying what it means for $f(x)$ to be "close to $L$" when $x$ is "close to $c$". These are quantified by the inequalities $0 < \lvert x-c\rvert < \delta$ and the $\lvert f(x) - L\rvert < \epsilon$. The second does not have the restriction that it is greater than $0$, as indeed $f(x)$ can equal $L$. The order is important: it says for any idea of close for $f(x)$ to $L$, an idea of close must be found for $x$ to $c$.
"""

# ╔═╡ 52913c4a-539f-11ec-12c5-49769f344344
md"""The key is identifying a value for $\delta$  for a given value of $\epsilon$.
"""

# ╔═╡ 52913c5e-539f-11ec-2e12-5d9201a13a81
md"""A simple case is the linear case. Consider the function $f(x) = 3x + 2$. Verify that the limit at $c=1$ is $5$.
"""

# ╔═╡ 52913c72-539f-11ec-1a77-5faf704af097
md"""We show "numerically" that $\delta = \epsilon/3$.
"""

# ╔═╡ 5291593c-539f-11ec-35a0-e3d6433e2e36
let
	f(x) = 3x + 2
	c, L = 1, 5
	epsilon = rand()                 # some number in (0,1)
	delta = epsilon / 3
	xs = c .+ delta * rand(100)       # 100 numbers, c < x < c + delta
	as = [abs(f(x) - L) < epsilon for x in xs]
	all(as)                          # are all the as true?
end

# ╔═╡ 529159b4-539f-11ec-3aae-0700212768d4
md"""These lines produce a random $\epsilon$, the resulting $\delta$, and then verify for 100 numbers within $(c, c+\delta)$ that the inequality $\lvert f(x) - L \rvert < \epsilon$ holds for each. Running them again and again should always produce `true` if $L$ is the limit and $\delta$ is chosen properly.
"""

# ╔═╡ 529159d4-539f-11ec-20fc-b39909356719
md"""(Of course, we should also verify values to the left of $c$.)
"""

# ╔═╡ 529159fa-539f-11ec-34ec-559d4f09d50f
md"""(The random numbers are technically in $[0,1)$, so in theory `epsilon` could be `0`. So the above approach would be more solid if some guard, such as  `epsilon = max(eps(), rand())`, was used. As the formal definition is the domain of paper-and-pencil, we don't fuss.)
"""

# ╔═╡ 52915a2c-539f-11ec-1ab6-cbae026e7aa7
md"""In this case, $\delta$ is easy to guess, as the function is linear and has slope $3$. This basically says the $y$ scale is 3 times the $x$ scale. For non-linear functions, finding $\delta$ for a given $\epsilon$ can be a challenge. For the function $f(x) = x^3$, illustrated below, a value of $\delta=\epsilon^{1/3}$ is used for $c=0$:
"""

# ╔═╡ 52915dec-539f-11ec-1197-45605693d54d
let
	## {{{ limit_e_d }}}
	pyplot()
	function make_limit_e_d(n)
	    f(x) = x^3
	
	    xs = range(-.9, stop=.9, length=50)
	    ys = map(f, xs)
	
	
	    plt = plot(f, -.9, .9, legend=false, size=fig_size)
	    if n == 0
	        nothing
	    else
	        k = div(n+1,2)
	        epsilon = 1/2^k
	        delta = cbrt(epsilon)
	        if isodd(n)
	            plot!(plt, xs, 0*xs .+ epsilon, color=:orange)
	            plot!(plt, xs, 0*xs .- epsilon, color=:orange)
	        else
	            plot!(delta * [-1,  1], epsilon * [ 1, 1], color=:orange)
	            plot!(delta * [ 1, -1], epsilon * [-1,-1], color=:orange)
	            plot!(delta * [-1, -1], epsilon * [-1, 1], color=:red)
	            plot!(delta * [ 1,  1], epsilon * [-1, 1], color=:red)
	        end
	    end
	    plt
	end
	
	
	n = 11
	anim = @animate for i=1:n
	    make_limit_e_d(i-1)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	
	Demonstration of $\epsilon$-$\delta$ proof of $\lim_{x \rightarrow 0}
	x^3 = 0$. For any $\epsilon>0$ (the orange lines) there exists a
	$\delta>0$ (the red lines of the box) for which the function $f(x)$
	does not leave the top or bottom of the box (except possibly at the
	edges). In this example $\delta^3=\epsilon$.
	
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 52915e14-539f-11ec-1d87-ad97003f9059
md"""## Questions
"""

# ╔═╡ 52915f54-539f-11ec-3a80-933f954a67b0
md"""###### Question
"""

# ╔═╡ 52915f68-539f-11ec-2aaf-3344d4ddcf52
md"""From the graph, find the limit:
"""

# ╔═╡ 52915f86-539f-11ec-2c82-4f28e5788116
md"""```math
L = \lim_{x\rightarrow 1}  \frac{x^2−3x+2}{x^2−6x+5}
```
"""

# ╔═╡ 52918524-539f-11ec-16f0-8b1d60e046dd
let
	f(x) = (x^2 - 3x +2) / (x^2 - 6x + 5)
	plot(f, 0,2)
end

# ╔═╡ 52918a60-539f-11ec-2e5d-539be553e98a
let
	ans = 1/4
	numericq(ans, 1e-1)
end

# ╔═╡ 52918aba-539f-11ec-05fc-fd8ed3628111
md"""###### Question
"""

# ╔═╡ 52918b16-539f-11ec-0cc7-09215feec102
md"""From the graph, find the limit $L$:
"""

# ╔═╡ 52918b32-539f-11ec-01de-ed49771e5758
md"""```math
L = \lim_{x \rightarrow -2} \frac{x}{x+1} \frac{x^2}{x^2 + 4}
```
"""

# ╔═╡ 5291affe-539f-11ec-3ade-f1472eb4c5c8
let
	f(x) = x/(x+1)*x^2/(x^2+4)
	plot(f, -3, -1.25)
end

# ╔═╡ 5291d1d2-539f-11ec-238a-853b11eae9ca
let
	f(x) = x/(x+1)*x^2/(x^2+4)
	val = f(-2)
	numericq(val, 1e-1)
end

# ╔═╡ 5291d24a-539f-11ec-2fc2-a133404587f2
md"""###### Question
"""

# ╔═╡ 5291d25e-539f-11ec-2252-d59f5e6c9d49
md"""Graphically investigate the limit
"""

# ╔═╡ 5291d286-539f-11ec-3e01-4bafe7969c92
md"""```math
L = \lim_{x \rightarrow 0} \frac{e^x - 1}{x}.
```
"""

# ╔═╡ 5291d2d4-539f-11ec-2c1b-fdcc419c266d
md"""What is the value of $L$?
"""

# ╔═╡ 5291d902-539f-11ec-310b-5fc933820922
let
	f(x) = (exp(x) - 1)/x
	p = plot(f, -1, 1)
end

# ╔═╡ 5291e15e-539f-11ec-1dd1-61a25252c990
let
	val = N(limit((exp(x)-1)/x, x => 0))
	numericq(val, 1e-1)
end

# ╔═╡ 5291e17c-539f-11ec-0ebf-6d3be461a92e
md"""###### Question
"""

# ╔═╡ 5291e190-539f-11ec-1068-91a01bb41c2c
md"""Graphically investigate the limit
"""

# ╔═╡ 5291e1a4-539f-11ec-3414-416566d7f026
md"""```math
\lim_{x \rightarrow 0} \frac{\cos(x) - 1}{x}.
```
"""

# ╔═╡ 5291e1b6-539f-11ec-2fd3-f913a7a28419
md"""The limit exists, what is the value?
"""

# ╔═╡ 5291e550-539f-11ec-207a-3d2f9d7939c2
let
	val = 0
	numericq(val, 1e-2)
end

# ╔═╡ 5291e564-539f-11ec-3ba1-4346f0f1f3c4
md"""###### Question
"""

# ╔═╡ 5291e578-539f-11ec-30c2-bbade2d58b90
md"""The following limit is commonly used:
"""

# ╔═╡ 5291e596-539f-11ec-131c-43ad02c1e7ef
md"""```math
\lim_{h \rightarrow 0} \frac{e^{x + h} - e^x}{h} = L.
```
"""

# ╔═╡ 5291e5b4-539f-11ec-1516-6d6f0ee27ee8
md"""Factoring out $e^x$ from the top and using rules of limits this becomes,
"""

# ╔═╡ 5291e5c8-539f-11ec-226f-3b6c502bf6d5
md"""```math
L = e^x \lim_{h \rightarrow 0} \frac{e^h - 1}{h}.
```
"""

# ╔═╡ 5291e5dc-539f-11ec-2262-4725a66eb212
md"""What is $L$?
"""

# ╔═╡ 5291ec44-539f-11ec-168f-6b308c1485cd
let
	choices = ["``0``", "``1``", "``e^x``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5291ec6c-539f-11ec-1859-6db51673b36e
md"""###### Question
"""

# ╔═╡ 5291ec80-539f-11ec-1952-e1fac711a191
md"""The following limit is commonly used:
"""

# ╔═╡ 5291ec96-539f-11ec-09f7-adeb97ea5e63
md"""```math
\lim_{h \rightarrow 0} \frac{\sin(x + h) - \sin(x)}{h} = L.
```
"""

# ╔═╡ 5291ecbc-539f-11ec-2ea1-617a3b7bc9d0
md"""The answer should depend on $x$, though it is possible it is a constant.  Using a double angle formula and the rules of limits, this can be written as:
"""

# ╔═╡ 5291ecd0-539f-11ec-0fdc-2b07e7521c57
md"""```math
L = \cos(x) \lim_{h \rightarrow 0}\frac{\sin(h)}{h} + \sin(x) \lim_{h \rightarrow 0}\frac{\cos(h)-1}{h}.
```
"""

# ╔═╡ 5291ece4-539f-11ec-008c-fbbea8be0dff
md"""Using the last result, what is the value of $L$?
"""

# ╔═╡ 5291f464-539f-11ec-0204-0b4a8084e3c3
let
	choices = ["``\\cos(x)``", "``\\sin(x)``", "``1``", "``0``", "``\\sin(h)/h``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 5291f478-539f-11ec-1a95-ef2f02ae6555
md"""###### Question
"""

# ╔═╡ 5291f4aa-539f-11ec-3ed3-bb51d3575a1a
md"""Find the limit as $x$ goes to $2$ of
"""

# ╔═╡ 5291f4b4-539f-11ec-3d2f-51edea099359
md"""```math
f(x) = \frac{3x^2 - x -10}{x^2 - 4}
```
"""

# ╔═╡ 52921520-539f-11ec-0de8-9d20f3eb56d7
let
	f(x) = (3x^2 - x - 10)/(x^2 - 4);
	val = convert(Float64, N(limit(f(x), x => 2)))
	numericq(val)
end

# ╔═╡ 52921552-539f-11ec-1ab0-9f398ac15a32
md"""###### Question
"""

# ╔═╡ 52921584-539f-11ec-2902-fd325c41c40d
md"""Find the limit as $x$ goes to $-2$ of
"""

# ╔═╡ 529215a2-539f-11ec-35de-e770b7cd9489
md"""```math
f(x) = \frac{\frac{1}{x} + \frac{1}{2}}{x^3 + 8}
```
"""

# ╔═╡ 52921ffc-539f-11ec-29d1-27da90a98fa7
let
	f(x) = ((1/x) + (1/2))/(x^3 + 8)
	numericq(-1/48, .001)
end

# ╔═╡ 52922024-539f-11ec-37fb-f9fad307293c
md"""###### Question
"""

# ╔═╡ 5292204c-539f-11ec-1bf9-4997a109850c
md"""Find the limit as $x$ goes to $27$ of
"""

# ╔═╡ 52922060-539f-11ec-261d-ebce82c17244
md"""```math
f(x) = \frac{x - 27}{x^{1/3} - 3}
```
"""

# ╔═╡ 52922970-539f-11ec-0ebc-2d4936891e26
let
	f(x) = (x - 27)/(x^(1//3) - 3)
	val = N(limit(f(x), x => 27))
	numericq(val)
end

# ╔═╡ 5292298e-539f-11ec-36b0-1d4cd8ab0640
md"""###### Question
"""

# ╔═╡ 529229a2-539f-11ec-03f7-df0da4d50901
md"""Find the limit
"""

# ╔═╡ 529229c0-539f-11ec-3650-01e38da4f395
md"""```math
L = \lim_{x \rightarrow \pi/2} \frac{\tan (2x)}{x - \pi/2}
```
"""

# ╔═╡ 529247e8-539f-11ec-0fd7-f17b2bdc00da
let
	f(x) = tan(2x)/(x-PI/2)
	val = N(limit(f(x), x => PI/2))
	numericq(val)
end

# ╔═╡ 52924812-539f-11ec-128d-1dce12a1722c
md"""###### Question
"""

# ╔═╡ 52924856-539f-11ec-1126-c1f3872de861
md"""The limit of $\sin(x)/x$ at $0$ has a numeric value. This depends upon the fact that $x$ is measured in radians. Try to find this limit: `limit(sind(x)/x, x => 0)`. What is the value?
"""

# ╔═╡ 5292662e-539f-11ec-25ce-27b93ca5014b
let
	choices = [q"0", q"1", q"pi/180", q"180/pi"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5292667e-539f-11ec-11ce-471c559bd8ff
md"""What is the limit `limit(sinpi(x)/x, x => 0)`?
"""

# ╔═╡ 52928438-539f-11ec-2aa5-393c6b8f12cc
let
	choices = [q"0", q"1", q"pi", q"1/pi"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5292846a-539f-11ec-2b30-596920bd1970
md"""###### Question: limit properties
"""

# ╔═╡ 52928488-539f-11ec-0d3b-6377975a6c47
md"""There are several properties of limits that allow one to break down more complicated problems into smaller subproblems. For example,
"""

# ╔═╡ 529284b0-539f-11ec-3c98-0f8cb26c7a09
md"""```math
\lim (f(x) + g(x)) = \lim f(x) + \lim g(x)
```
"""

# ╔═╡ 529284ba-539f-11ec-2c44-b102321651e3
md"""is notation to indicate that one can take a limit of the sum of two function or take the limit of each first, then add and the answer will be unchanged, provided all the limits in question exist.
"""

# ╔═╡ 529284e2-539f-11ec-3ffe-d51560d1a4ec
md"""Use one or the either to find the limit of $f(x) = \sin(x) + \tan(x) + \cos(x)$ as $x$ goes to $0$.
"""

# ╔═╡ 52928a3c-539f-11ec-112d-13d682bf756c
let
	f(x) = sin(x) + tan(x) + cos(x)
	numericq(f(0), 1e-5)
end

# ╔═╡ 52928a62-539f-11ec-092d-615961eaeb9a
md"""###### Question
"""

# ╔═╡ 52928a78-539f-11ec-2d22-19a8a4e0e9b0
md"""The key assumption made above in being able to write
"""

# ╔═╡ 52928a8c-539f-11ec-281d-1f3c0747446b
md"""```math
\lim_{x\rightarrow c} f(g(x)) = L,
```
"""

# ╔═╡ 52928abe-539f-11ec-3d18-19b6e069a698
md"""when $\lim_{x\rightarrow b} f(x) = L$ and $\lim_{x\rightarrow c}g(x) = b$ is *continuity*.
"""

# ╔═╡ 52928af0-539f-11ec-1266-5d1097169a6a
md"""This [example](https://en.wikipedia.org/wiki/Limit_of_a_function#Limits_of_compositions_of_functions) shows why it is important.
"""

# ╔═╡ 52928afa-539f-11ec-0edf-0f521cf4a867
md"""Take
"""

# ╔═╡ 52928b0e-539f-11ec-36f0-010ed112a0c2
md"""```math
f(x) = \begin{cases}
0 & x \neq 0\\
1 & x = 0
\end{cases}
```
"""

# ╔═╡ 52928b38-539f-11ec-2698-e369c709d819
md"""We have $\lim_{x\rightarrow 0}f(x) = 0$, as $0$ is clearly a removable discontinuity. So were the above applicable we would have $\lim_{x \rightarrow 0}f(f(x)) = 0$. But this is not true. What is the limit at $0$ of $f(f(x))$?
"""

# ╔═╡ 52928d3e-539f-11ec-2ea6-55f200015d5c
numericq(1)

# ╔═╡ 52928d52-539f-11ec-236c-4141b7bf1268
md"""###### Question
"""

# ╔═╡ 52928d70-539f-11ec-3985-1fb8654d639b
md"""Does this function have a limit as $h$ goes to $0$ from the right (that is, assume $h>0$)?
"""

# ╔═╡ 52928d84-539f-11ec-3f35-0930fa5c8adc
md"""```math
\frac{h^h - 1}{h}
```
"""

# ╔═╡ 5292abe8-539f-11ec-01dd-97dc7c55d477
let
	choices = [
	"Yes, the value is `-9.2061`",
	"Yes, the value is `-11.5123`",
	"No, the value heads to negative infinity"
	];
	ans = 3;
	radioq(choices, ans)
end

# ╔═╡ 5292ac1a-539f-11ec-020a-4556a432c0e9
md"""###### Question
"""

# ╔═╡ 5292ac30-539f-11ec-2824-c719bb373522
md"""Compute the limit
"""

# ╔═╡ 5292ac4c-539f-11ec-179b-5bafd043a4c2
md"""```math
\lim_{x \rightarrow 1} \frac{x}{x-1} - \frac{1}{\ln(x)}.
```
"""

# ╔═╡ 5292c922-539f-11ec-36ec-a9a3eac33fb1
let
	f(x) = x/(x-1) - 1/log(x)
	val = convert(Float64, N(limit(f(x), x => 1)))
	numericq(val)
end

# ╔═╡ 5292c954-539f-11ec-2719-7dae1aefb0de
md"""###### Question
"""

# ╔═╡ 5292c970-539f-11ec-1016-954e4f959c5b
md"""Compute the limit
"""

# ╔═╡ 5292c982-539f-11ec-246c-f19c292b9569
md"""```math
\lim_{x \rightarrow 1/2} \frac{1}{\pi} \frac{\cos(\pi x)}{1 - (2x)^2}.
```
"""

# ╔═╡ 5292e9b4-539f-11ec-39bf-f17b1c127fcd
let
	f(x) =  1/PI * cos(PI*x)/(1 - (2x)^2)
	val = N(limit(f(x), x => 1//2))
	numericq(val)
end

# ╔═╡ 5292e9e8-539f-11ec-2110-458b2319fe94
md"""###### Question
"""

# ╔═╡ 5292ea1a-539f-11ec-26c8-9be32cecc27f
md"""Some limits involve parameters. For example, suppose we define `ex` as follows:
"""

# ╔═╡ 5292eed2-539f-11ec-1d63-c5d340995777
let
	@syms m::real k::real
	ex = (1 + k*x)^(m/x)
end

# ╔═╡ 5292eefa-539f-11ec-0fc8-17a002f15bc1
md"""What is `limit(ex, x => 0)`?
"""

# ╔═╡ 52930d86-539f-11ec-01b8-733f012cf06d
let
	choices = ["``e^{km}``", "``e^{k/m}``", "``k/m``", "``m/k``", "``0``"]
	answer = 1
	radioq(choices, answer)
end

# ╔═╡ 52930db8-539f-11ec-135d-f3f5e296a7df
md"""###### Question
"""

# ╔═╡ 52930dea-539f-11ec-2123-0bc8ffae3778
md"""For a given $a$, what is
"""

# ╔═╡ 52930dfe-539f-11ec-1025-dd6c33217df1
md"""```math
L = \lim_{x \rightarrow 0+} (1 + a\cdot (e^{-x} -1))^{(1/x)}
```
"""

# ╔═╡ 52931416-539f-11ec-1c30-9590e36142a9
let
	choices = ["``e^{-a}``", "``e^a``", "``a``", "``L`` does not exist"]
	radioq(choices, 1)
end

# ╔═╡ 5293143e-539f-11ec-3360-efd6ab0845d8
md"""###### Question
"""

# ╔═╡ 52931466-539f-11ec-21e3-27ca535ae6b6
md"""For positive integers $m$ and $n$ what is
"""

# ╔═╡ 5293147a-539f-11ec-3d41-3d7440082a4d
md"""```math
\lim_{x \rightarrow 1} \frac{x^{1/m}-1}{x^{1/n}-1}?
```
"""

# ╔═╡ 52931a6a-539f-11ec-205d-a97c37a88a3d
let
	choices = ["``m/n``", "``n/m``", "``mn``", "The limit does not exist"]
	radioq(choices, 1)
end

# ╔═╡ 52931a86-539f-11ec-09c0-690f4a26a5ce
md"""###### Question
"""

# ╔═╡ 52931ab8-539f-11ec-0112-17cd1a8a6d1d
md"""What does `SymPy` find for the limit of `ex` (`limit(ex, x => 0)`), as defined here:
"""

# ╔═╡ 52931e66-539f-11ec-2259-85b622803eac
let
	@syms x a
	ex = (a^x - 1)/x
end

# ╔═╡ 5293241a-539f-11ec-1683-23bb69f60a37
let
	choices = ["``\\log(a)``", "``a``", "``e^a``", "``e^{-a}``"]
	radioq(choices, 1)
end

# ╔═╡ 52932442-539f-11ec-33dc-9d1b7f89affa
md"""Should `SymPy` have needed an assumption like
"""

# ╔═╡ 5293273a-539f-11ec-2d71-eb9b77130d5c
@syms a::postive

# ╔═╡ 529329cc-539f-11ec-3968-55009481e08d
yesnoq("yes")

# ╔═╡ 529329ec-539f-11ec-3b80-3925646dc0cb
md"""###### Question: The squeeze theorem
"""

# ╔═╡ 52932a14-539f-11ec-1732-3598b6a069b1
md"""Let's look at the function $f(x) = x \sin(1/x)$. A graph around $0$ can be made with:
"""

# ╔═╡ 52934ddc-539f-11ec-35ca-ab9f0da84f0f
let
	f(x) = x == 0 ? NaN : x * sin(1/x)
	c, delta = 0, 1/4
	plot(f, c - delta, c + delta)
	plot!(abs)
	plot!(x -> -abs(x))
end

# ╔═╡ 52934eb8-539f-11ec-2957-e1a92d5da8c1
md"""This graph clearly oscillates near $0$. To the graph of $f$, we added graphs of both $g(x) = \lvert x\rvert$ and $h(x) = - \lvert x\rvert$. From this graph it is easy to see by the "squeeze theorem" that the limit at $x=0$ is $0$. Why?
"""

# ╔═╡ 52935886-539f-11ec-1873-07409549463b
let
	choices=[L"""The functions $g$ and $h$ both have a limit of $0$ at $x=0$ and the function $f$ is in
	between both $g$ and $h$, so must to have a limit of $0$.
	""",
		L"The functions $g$ and $h$ squeeze each other as $g(x) > h(x)$",
	         L"The function $f$ has no limit - it oscillates too much near $0$"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 529358c2-539f-11ec-3109-bda2bf3e367f
md"""(The [Wikipedia](https://en.wikipedia.org/wiki/Squeeze_theorem) entry for the squeeze theorem has this unverified, but colorful detail:
"""

# ╔═╡ 52935994-539f-11ec-0181-f9a2f66745c7
md"""> In many languages (e.g. French, German, Italian, Hungarian and Russian), the squeeze theorem is also known as the two policemen (and a drunk) theorem, or some variation thereof. The story is that if two policemen are escorting a drunk prisoner between them, and both officers go to a cell, then (regardless of the path taken, and the fact that the prisoner may be wobbling about between the policemen) the prisoner must also end up in the cell.

"""

# ╔═╡ 529359a6-539f-11ec-233b-9fd64bc88454
md"""A slightly informal statement of the squeeze theorem might be:
"""

# ╔═╡ 52935a20-539f-11ec-0d2a-c738eb93f5f6
md"""> Squeeze Theorem: Suppose for all $x$ near $c$ that $l(x) \leq f(x) \leq u(x)$ and *both* $l(x)$ and $u(x)$ have a limit $L$ at $x=c$. Then $L = \lim_{x \rightarrow c}f(x)$.

"""

# ╔═╡ 52935a34-539f-11ec-20d2-912fad8ad4f9
md"""###### Question
"""

# ╔═╡ 52935a98-539f-11ec-13d6-73640e9af0f2
md"""Archimedes, in finding bounds on the value of $\pi$ used $n$-gons with sides $12, 24, 48,$ and $96$. This was so the trigonometry involved could be solved exactly for the interior angles (e.g. $n=12$ is an interior angle of $\pi/6$ which has `sin` and `cos` computable by simple geometry. See [Damini and Abhishek](https://arxiv.org/pdf/2008.07995.pdf)) These exact solutions led to subsequent bounds. A more modern approach to bound the circumference of a circle of radius $r$ using a $n$-gon with interior angle $\theta$ would be to use the trigonometric functions. An upper bound would be found with (using the triangle with angle $\theta/2$, opposite side $x$ and adjacent side $r$:
"""

# ╔═╡ 529376ea-539f-11ec-1e7a-3f4f3c3fe90b
@syms theta::real r::real

# ╔═╡ 529396a2-539f-11ec-1131-61ab545ff1f6
let
	x = r * tan(theta/2)
	n = 2PI/theta     # using PI to avoid floaing point roundoff in 2pi
	# C < n * 2x
	upper = n*2x
end

# ╔═╡ 52939706-539f-11ec-214a-3ddb7255255f
md"""A lower bound would use the triangle with angle $\theta/2$, hypotenuse $r$ and opposite side $x$:
"""

# ╔═╡ 52939bf2-539f-11ec-05ba-e5422c9fa8bd
let
	x = r*sin(theta/2)
	n = 2PI/theta
	# C > n * 2x
	lower = n*2x
end

# ╔═╡ 52939c3a-539f-11ec-3133-09d72a738c2a
md"""Using the above, find the limit of `upper` and `lower`. Are the two equal and equal to a familiar value?
"""

# ╔═╡ 52939e5e-539f-11ec-0b0f-c186c73d59aa
let
	yesnoq("yes")
end

# ╔═╡ 52939e86-539f-11ec-0e69-2d9b9c2c9ed1
md"""(If so, then the squeeze theorem would say that $\pi$ is the common limit.)
"""

# ╔═╡ 52939ef4-539f-11ec-2c11-139d3feafd1f
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/julia_overview.html">◅ previous</a>  <a href="../limits/limits_extensions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/limits/limits.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 52939f0a-539f-11ec-25ad-b386c5a8611d
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Richardson = "708f8203-808e-40c0-ba2d-98a6953ed40d"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Richardson = "~1.4.0"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Pluto", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "7adfe1a4e3f52fc356dfa2b0b26457f0acf81aa2"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.10"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "d8f468c5cd4d94e86816603f7d18ece910b4aaf1"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.5.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "6406b5112809c08b1baa5703ad274e1dded0652f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.23"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "f823a2d04fb233d52812c8024a6d46d9581904a4"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.4.5"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "d73736030a094e8d24fdf3629ae980217bf1d59d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.3"

[[Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "Sockets", "TableIOInterface", "Tables", "UUIDs"]
git-tree-sha1 = "a5b3fee95de0c0a324bab53a03911395936d15d9"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.17.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Richardson]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "e03ca566bec93f8a3aeb059c8ef102f268a38949"
uuid = "708f8203-808e-40c0-ba2d-98a6953ed40d"
version = "1.4.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableIOInterface]]
git-tree-sha1 = "9a0d3ab8afd14f33a35af7391491ff3104401a35"
uuid = "d1efa939-5518-4425-949f-ab857e148477"
version = "0.1.6"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─52939ee0-539f-11ec-1acb-3bc2016c9c4f
# ╟─528cbf1c-539f-11ec-32f6-55de3c3084bd
# ╟─528cc0e8-539f-11ec-2395-639d63584853
# ╠═528d4f5e-539f-11ec-2567-9f7f2cab1cc9
# ╟─528d538c-539f-11ec-1416-314c796cd145
# ╟─528d540e-539f-11ec-24f9-83c8479f1a30
# ╟─528d5472-539f-11ec-366a-bf3b87e1d4a6
# ╟─528d5508-539f-11ec-09c6-2111c373abef
# ╟─528d59c2-539f-11ec-1d3a-137230999d31
# ╟─528d59fe-539f-11ec-0031-b7d9b0adcc60
# ╟─528d5a76-539f-11ec-2160-2fdca30b4183
# ╟─528d5ab2-539f-11ec-39f3-6d457e4adefb
# ╟─528d5ac6-539f-11ec-3626-81569abb34ea
# ╟─528d5b02-539f-11ec-2fe9-89a02a548528
# ╟─528d5b1e-539f-11ec-103e-df61545e4253
# ╟─528d5e68-539f-11ec-272a-03f336774119
# ╟─528d5eb8-539f-11ec-0753-b74b8f6fc827
# ╟─528d5ee0-539f-11ec-2bd7-ef4c94d6cb70
# ╟─528d5ef2-539f-11ec-323f-a5940533e75e
# ╟─528d5f12-539f-11ec-0c2e-594390726af0
# ╟─528d5f1c-539f-11ec-18e8-7ba6b3c55146
# ╟─528d75a6-539f-11ec-3c51-dda585b503f7
# ╟─528d75ce-539f-11ec-12a5-91f254529cd0
# ╟─528d760a-539f-11ec-1757-479d3f5ab0af
# ╟─528d761e-539f-11ec-10f5-612bb0b90a13
# ╟─528d763c-539f-11ec-3cbf-4d4fb6fad552
# ╟─528d7650-539f-11ec-3c46-55c002353216
# ╟─528d7664-539f-11ec-31b2-f5dbd6b8211e
# ╟─528d766e-539f-11ec-16d6-8312f83edf7f
# ╟─528d76a0-539f-11ec-0cba-09a1a06aca8a
# ╟─528d76b4-539f-11ec-3a97-6bcfb0878f3f
# ╟─528dbbec-539f-11ec-043d-81263d6b4a33
# ╟─528dbc50-539f-11ec-398d-751b6300b4a0
# ╠═528dc148-539f-11ec-177c-b153eb488554
# ╟─528dc164-539f-11ec-0669-478ad4957fde
# ╠═528dc830-539f-11ec-2116-41069de560bf
# ╟─528dc858-539f-11ec-3b91-f37362ec1f8c
# ╟─528dc876-539f-11ec-0e08-359d8d07a8ae
# ╟─528dc89e-539f-11ec-2204-7bee55b34aa8
# ╟─528dc8b0-539f-11ec-2807-2923ed651552
# ╟─528dc8bc-539f-11ec-0ddc-4d71ca5a9c81
# ╟─528dc8d0-539f-11ec-1428-590cab5b5847
# ╟─528dc95c-539f-11ec-096c-7bbc2dbb691d
# ╟─528dc9b8-539f-11ec-105e-1bb5b9a92b52
# ╟─528f5312-539f-11ec-1377-a771530cc319
# ╠═528f5b78-539f-11ec-13dc-1ff8a95fb756
# ╟─528f5be6-539f-11ec-0b3b-dd975c62769b
# ╠═528f74b2-539f-11ec-025b-3d2aea3f3f0f
# ╟─528f755e-539f-11ec-2e47-5b5a340d56d4
# ╠═528f7a0e-539f-11ec-2709-f7da9af9358b
# ╟─528f7a4a-539f-11ec-04b0-b16d18ddc9aa
# ╠═528f7d88-539f-11ec-22f7-69cc0f60e6ee
# ╟─528f7de2-539f-11ec-20b4-4b439f686942
# ╟─528f7eca-539f-11ec-16c8-594aca538ad6
# ╟─528f7f2e-539f-11ec-1eac-4f322095b8d3
# ╠═528f842c-539f-11ec-0b78-8f323d9fa4d7
# ╟─528f8490-539f-11ec-0ce7-87127cd48170
# ╟─528f849c-539f-11ec-0308-47434ee8a871
# ╠═528f8c38-539f-11ec-0dff-aff75d3a6146
# ╟─528f8c88-539f-11ec-3dc4-cf765c2d0dcd
# ╟─528f8cc4-539f-11ec-06f7-7769376b8348
# ╠═528f91b0-539f-11ec-24cb-17444535eea6
# ╟─528f91e2-539f-11ec-30c9-312352a65e32
# ╟─528f9264-539f-11ec-0ed8-7f2b77f49e44
# ╟─528f9282-539f-11ec-33e3-09414808289e
# ╟─528f92a8-539f-11ec-280c-69342f7f2fd3
# ╟─528f92be-539f-11ec-02af-0f9084ffbc69
# ╠═528fae32-539f-11ec-023f-ed2430d43454
# ╟─528fae8e-539f-11ec-2573-5b6837dc498b
# ╠═528fb41a-539f-11ec-1a53-cff9d2b4e8ef
# ╟─528fb460-539f-11ec-3dfa-61fda75b5452
# ╟─528fb47e-539f-11ec-215f-0be94571998a
# ╟─528fb4a8-539f-11ec-0b13-03588a1c92e6
# ╟─528fb4c4-539f-11ec-07ae-1b1c5261741c
# ╟─528fb4e2-539f-11ec-3e78-ff91b9d38489
# ╟─528fb508-539f-11ec-1811-a1d145cfcf38
# ╟─528fb528-539f-11ec-2976-7b97827e5543
# ╟─528fb546-539f-11ec-2e60-7fb0fa52d1fd
# ╟─528fb564-539f-11ec-2f94-3d017baafbd5
# ╟─528fb578-539f-11ec-2669-7fbbc7ad3286
# ╟─528fb582-539f-11ec-3462-7df120c4cc43
# ╟─528fb596-539f-11ec-13d2-17128d778226
# ╠═528fbcb4-539f-11ec-1798-5df4660cd905
# ╠═528fbfd2-539f-11ec-27cd-3d7f690e3f6e
# ╟─528fc00e-539f-11ec-0c60-278930c2dbb3
# ╠═528fc7c2-539f-11ec-21cb-1dc5d1b57491
# ╟─528fc7f4-539f-11ec-314a-698636879275
# ╠═528fcbee-539f-11ec-2729-d701cccbc986
# ╟─528fcc20-539f-11ec-0c25-53780bb1a492
# ╠═528fcf68-539f-11ec-1d48-492d4ef7266e
# ╟─528fcfa4-539f-11ec-05c9-7db79b225c32
# ╟─528fcfd6-539f-11ec-321a-a11aec0b0740
# ╠═528fd330-539f-11ec-071b-65cf38e52b06
# ╟─528fd35a-539f-11ec-2498-338547f4c2ea
# ╟─528fd36e-539f-11ec-10d9-351981d5193d
# ╟─528fd38c-539f-11ec-2da9-53229a0ce465
# ╟─528fd3a0-539f-11ec-0e92-51b86d840127
# ╟─528fd3d4-539f-11ec-014e-7f83fd3d8175
# ╟─528fd3e6-539f-11ec-26b1-5187c3d350b2
# ╠═528fd710-539f-11ec-1e30-777d16f16254
# ╟─528fd72e-539f-11ec-1563-e301051a2e74
# ╟─528fd756-539f-11ec-295d-ab6f73993f87
# ╟─528fd768-539f-11ec-39df-8757c42f3be4
# ╟─528fd77e-539f-11ec-3606-cd14f54fce28
# ╟─528fd792-539f-11ec-2b19-310888a6d1e7
# ╠═528fddb4-539f-11ec-0afb-eff723768e9e
# ╟─528fddde-539f-11ec-1deb-adb6e6661152
# ╠═528fe26e-539f-11ec-1cc3-b15f65111887
# ╟─528ff556-539f-11ec-24ff-d7e817fc8561
# ╠═528ffe3e-539f-11ec-1e1a-431553d972b3
# ╟─528ffeca-539f-11ec-2b35-b561c499b94f
# ╟─528ffede-539f-11ec-2cc0-17b5cb8858a1
# ╟─528ffef2-539f-11ec-082f-9384177f14dd
# ╟─528fff10-539f-11ec-3f54-911d2ae9b32a
# ╟─528fff36-539f-11ec-3470-435c190e9654
# ╟─528fff56-539f-11ec-3a84-63b0da827f06
# ╟─528fff60-539f-11ec-3ae4-9bc758a17d6a
# ╟─528fff74-539f-11ec-1766-f718eac58fcb
# ╟─528fff7e-539f-11ec-071c-dd7c17584462
# ╟─52902170-539f-11ec-0932-3b2fcd98c5aa
# ╟─529021e8-539f-11ec-1945-d7e5a2c12e90
# ╠═52902672-539f-11ec-382e-c3b3061c1656
# ╟─52902698-539f-11ec-302b-ad708f9db5c8
# ╟─529026ca-539f-11ec-25db-3335b50a4187
# ╟─5290277e-539f-11ec-057e-4b5298c66763
# ╟─529027ce-539f-11ec-21b3-9305c9a7aa5b
# ╠═52902bc0-539f-11ec-3d2b-b96b08bc3a0a
# ╟─52902be8-539f-11ec-07cf-45d559df8b1e
# ╟─52902bfc-539f-11ec-23ae-5754c971639d
# ╠═529036a6-539f-11ec-0544-6f13cac85b55
# ╟─529036ce-539f-11ec-259b-03176bce0fc7
# ╠═52903c82-539f-11ec-39c9-b536a93ce5d5
# ╟─52903cb4-539f-11ec-0817-73e09c2a953c
# ╠═52904448-539f-11ec-24b1-61122c1467c4
# ╟─5290447a-539f-11ec-2c04-7f6491c841da
# ╠═52908480-539f-11ec-2608-1bc0e90dfa98
# ╟─529084da-539f-11ec-25b5-af153e32cdfb
# ╟─52908502-539f-11ec-08d8-5796865dfabe
# ╟─5290855c-539f-11ec-0972-1556469cb783
# ╟─52908582-539f-11ec-2517-b5276e3ac854
# ╠═52908cf0-539f-11ec-033c-7b5eab4dc8ea
# ╟─52908d18-539f-11ec-1544-975c2748e994
# ╟─52908d40-539f-11ec-1b8f-436ab2daec3a
# ╟─52908d60-539f-11ec-127d-9df88c98a447
# ╟─52908e12-539f-11ec-3b6c-37e0dd39d099
# ╟─52908f16-539f-11ec-0931-b72152892323
# ╠═529098bc-539f-11ec-26a7-7f4ffe4d6675
# ╟─529098e4-539f-11ec-3404-ab8ea094f0e4
# ╟─52909916-539f-11ec-22db-f7e7211739bc
# ╟─52909934-539f-11ec-22ab-cd4bb476f0c6
# ╟─52909948-539f-11ec-3b10-3bc613e870ab
# ╠═5290a17c-539f-11ec-3a02-9b4ac3da3a1a
# ╟─5290a19a-539f-11ec-18ce-6582078bd7a9
# ╠═5290c558-539f-11ec-2ea1-f9903fc9c7cc
# ╟─5290c58a-539f-11ec-350d-e18aecb3b210
# ╠═5290c97e-539f-11ec-0a22-d9e278a6620c
# ╟─5290c9c2-539f-11ec-3898-2d945e75c059
# ╟─5290c9d6-539f-11ec-3740-85a9b7fa3500
# ╟─5290c9ea-539f-11ec-31b5-ffb94997fb83
# ╟─5290ca1c-539f-11ec-2140-2dc9632f3da4
# ╟─5290ca4e-539f-11ec-1034-1d9a6ae3dd98
# ╟─5290ca80-539f-11ec-1206-21b56b6e4ca6
# ╠═5290d034-539f-11ec-255f-a97b441a7fc3
# ╟─5290d070-539f-11ec-07d9-8dbdb76594e5
# ╠═5290d49e-539f-11ec-0c35-d5ef9dcedcb9
# ╟─5290d4c6-539f-11ec-2c16-6dafed7cfb91
# ╠═5290d924-539f-11ec-0313-5963795d7208
# ╟─5290d956-539f-11ec-2e1a-ef232545088c
# ╟─5290d96c-539f-11ec-2949-63464dfa2d17
# ╠═5290e178-539f-11ec-249c-cddf2aaae914
# ╟─5290e1d2-539f-11ec-0823-8f48d54fdf58
# ╟─5290e1fa-539f-11ec-3ed4-b3039f3a4240
# ╟─5290e254-539f-11ec-12d7-9b00e0ff4ca8
# ╟─5290e272-539f-11ec-20bc-9551aa96c677
# ╠═5290eb08-539f-11ec-368a-13aae14d0df4
# ╟─5290eb28-539f-11ec-019c-87c3a6d1b223
# ╟─5290eb50-539f-11ec-386d-4193bf9a0153
# ╟─5290ebac-539f-11ec-2b5e-3f2a00fca8a9
# ╟─5290ebd2-539f-11ec-2477-87a048012def
# ╟─5290ebde-539f-11ec-13a9-917afdca917d
# ╟─529105d6-539f-11ec-1990-5be8e84947cb
# ╟─52910608-539f-11ec-11dc-73682181bada
# ╟─5291061c-539f-11ec-17fd-311c693fbee2
# ╟─5291062e-539f-11ec-3fd5-1161c0a0de92
# ╟─529106da-539f-11ec-080e-0937f1129e40
# ╟─529106ee-539f-11ec-3e96-b3863bde421b
# ╟─52910704-539f-11ec-1b56-b5a40842420f
# ╟─5291072a-539f-11ec-355b-970196f9023e
# ╟─5291073e-539f-11ec-01a9-a325781a1589
# ╟─52910752-539f-11ec-19ec-4772bf55e413
# ╟─52910770-539f-11ec-1b25-b52b7919a8b0
# ╟─5291077a-539f-11ec-36f6-bf773a125b27
# ╟─529107ac-539f-11ec-020d-e59b8819f200
# ╟─529107d4-539f-11ec-2428-3fb22d7b46a8
# ╟─529107de-539f-11ec-1bfd-2f49dea251e6
# ╟─529107f2-539f-11ec-0416-7f02ca22807b
# ╟─52910810-539f-11ec-34d4-25c9f43be4e4
# ╟─52910824-539f-11ec-301a-31ce033d4f20
# ╟─52910842-539f-11ec-1cf7-6b52efb8d183
# ╟─5291084c-539f-11ec-1459-413a6f9cd272
# ╟─52910860-539f-11ec-0ad7-d3dce4ee9a9a
# ╠═5291113c-539f-11ec-3265-154826e01f0f
# ╟─5291116e-539f-11ec-177e-b371fca30b24
# ╠═52911922-539f-11ec-2b1f-2120410938be
# ╟─52911940-539f-11ec-1aa2-95862fb971c8
# ╟─52911968-539f-11ec-16da-79d0ee19c215
# ╠═52911f3a-539f-11ec-26d1-655276d95573
# ╟─52911f80-539f-11ec-0b43-1741ab9e6731
# ╠═5291249e-539f-11ec-274a-5d98edafb49c
# ╠═52913b00-539f-11ec-18fe-232d81f2b063
# ╟─52913b48-539f-11ec-24e8-27cf9e3b0b4c
# ╟─52913b5a-539f-11ec-13d1-55fa993cc99c
# ╟─52913b6e-539f-11ec-142e-5d3ee03d1187
# ╟─52913b82-539f-11ec-1854-f5eb3da29c03
# ╟─52913ba0-539f-11ec-3786-1b823cf13604
# ╟─52913ba8-539f-11ec-2f62-8f70d355a44a
# ╟─52913bbe-539f-11ec-2f5f-dff87f40abd0
# ╟─52913bda-539f-11ec-0d89-bda903aa6fbd
# ╟─52913bfa-539f-11ec-2ef7-ef281c9683b5
# ╟─52913c36-539f-11ec-0a7e-575dc453628c
# ╟─52913c4a-539f-11ec-12c5-49769f344344
# ╟─52913c5e-539f-11ec-2e12-5d9201a13a81
# ╟─52913c72-539f-11ec-1a77-5faf704af097
# ╠═5291593c-539f-11ec-35a0-e3d6433e2e36
# ╟─529159b4-539f-11ec-3aae-0700212768d4
# ╟─529159d4-539f-11ec-20fc-b39909356719
# ╟─529159fa-539f-11ec-34ec-559d4f09d50f
# ╟─52915a2c-539f-11ec-1ab6-cbae026e7aa7
# ╟─52915dec-539f-11ec-1197-45605693d54d
# ╟─52915e14-539f-11ec-1d87-ad97003f9059
# ╟─52915f54-539f-11ec-3a80-933f954a67b0
# ╟─52915f68-539f-11ec-2aaf-3344d4ddcf52
# ╟─52915f86-539f-11ec-2c82-4f28e5788116
# ╟─52918524-539f-11ec-16f0-8b1d60e046dd
# ╟─52918a60-539f-11ec-2e5d-539be553e98a
# ╟─52918aba-539f-11ec-05fc-fd8ed3628111
# ╟─52918b16-539f-11ec-0cc7-09215feec102
# ╟─52918b32-539f-11ec-01de-ed49771e5758
# ╟─5291affe-539f-11ec-3ade-f1472eb4c5c8
# ╟─5291d1d2-539f-11ec-238a-853b11eae9ca
# ╟─5291d24a-539f-11ec-2fc2-a133404587f2
# ╟─5291d25e-539f-11ec-2252-d59f5e6c9d49
# ╟─5291d286-539f-11ec-3e01-4bafe7969c92
# ╟─5291d2d4-539f-11ec-2c1b-fdcc419c266d
# ╟─5291d902-539f-11ec-310b-5fc933820922
# ╟─5291e15e-539f-11ec-1dd1-61a25252c990
# ╟─5291e17c-539f-11ec-0ebf-6d3be461a92e
# ╟─5291e190-539f-11ec-1068-91a01bb41c2c
# ╟─5291e1a4-539f-11ec-3414-416566d7f026
# ╟─5291e1b6-539f-11ec-2fd3-f913a7a28419
# ╟─5291e550-539f-11ec-207a-3d2f9d7939c2
# ╟─5291e564-539f-11ec-3ba1-4346f0f1f3c4
# ╟─5291e578-539f-11ec-30c2-bbade2d58b90
# ╟─5291e596-539f-11ec-131c-43ad02c1e7ef
# ╟─5291e5b4-539f-11ec-1516-6d6f0ee27ee8
# ╟─5291e5c8-539f-11ec-226f-3b6c502bf6d5
# ╟─5291e5dc-539f-11ec-2262-4725a66eb212
# ╟─5291ec44-539f-11ec-168f-6b308c1485cd
# ╟─5291ec6c-539f-11ec-1859-6db51673b36e
# ╟─5291ec80-539f-11ec-1952-e1fac711a191
# ╟─5291ec96-539f-11ec-09f7-adeb97ea5e63
# ╟─5291ecbc-539f-11ec-2ea1-617a3b7bc9d0
# ╟─5291ecd0-539f-11ec-0fdc-2b07e7521c57
# ╟─5291ece4-539f-11ec-008c-fbbea8be0dff
# ╟─5291f464-539f-11ec-0204-0b4a8084e3c3
# ╟─5291f478-539f-11ec-1a95-ef2f02ae6555
# ╟─5291f4aa-539f-11ec-3ed3-bb51d3575a1a
# ╟─5291f4b4-539f-11ec-3d2f-51edea099359
# ╟─52921520-539f-11ec-0de8-9d20f3eb56d7
# ╟─52921552-539f-11ec-1ab0-9f398ac15a32
# ╟─52921584-539f-11ec-2902-fd325c41c40d
# ╟─529215a2-539f-11ec-35de-e770b7cd9489
# ╟─52921ffc-539f-11ec-29d1-27da90a98fa7
# ╟─52922024-539f-11ec-37fb-f9fad307293c
# ╟─5292204c-539f-11ec-1bf9-4997a109850c
# ╟─52922060-539f-11ec-261d-ebce82c17244
# ╟─52922970-539f-11ec-0ebc-2d4936891e26
# ╟─5292298e-539f-11ec-36b0-1d4cd8ab0640
# ╟─529229a2-539f-11ec-03f7-df0da4d50901
# ╟─529229c0-539f-11ec-3650-01e38da4f395
# ╟─529247e8-539f-11ec-0fd7-f17b2bdc00da
# ╟─52924812-539f-11ec-128d-1dce12a1722c
# ╟─52924856-539f-11ec-1126-c1f3872de861
# ╟─5292662e-539f-11ec-25ce-27b93ca5014b
# ╟─5292667e-539f-11ec-11ce-471c559bd8ff
# ╟─52928438-539f-11ec-2aa5-393c6b8f12cc
# ╟─5292846a-539f-11ec-2b30-596920bd1970
# ╟─52928488-539f-11ec-0d3b-6377975a6c47
# ╟─529284b0-539f-11ec-3c98-0f8cb26c7a09
# ╟─529284ba-539f-11ec-2c44-b102321651e3
# ╟─529284e2-539f-11ec-3ffe-d51560d1a4ec
# ╟─52928a3c-539f-11ec-112d-13d682bf756c
# ╟─52928a62-539f-11ec-092d-615961eaeb9a
# ╟─52928a78-539f-11ec-2d22-19a8a4e0e9b0
# ╟─52928a8c-539f-11ec-281d-1f3c0747446b
# ╟─52928abe-539f-11ec-3d18-19b6e069a698
# ╟─52928af0-539f-11ec-1266-5d1097169a6a
# ╟─52928afa-539f-11ec-0edf-0f521cf4a867
# ╟─52928b0e-539f-11ec-36f0-010ed112a0c2
# ╟─52928b38-539f-11ec-2698-e369c709d819
# ╟─52928d3e-539f-11ec-2ea6-55f200015d5c
# ╟─52928d52-539f-11ec-236c-4141b7bf1268
# ╟─52928d70-539f-11ec-3985-1fb8654d639b
# ╟─52928d84-539f-11ec-3f35-0930fa5c8adc
# ╟─5292abe8-539f-11ec-01dd-97dc7c55d477
# ╟─5292ac1a-539f-11ec-020a-4556a432c0e9
# ╟─5292ac30-539f-11ec-2824-c719bb373522
# ╟─5292ac4c-539f-11ec-179b-5bafd043a4c2
# ╟─5292c922-539f-11ec-36ec-a9a3eac33fb1
# ╟─5292c954-539f-11ec-2719-7dae1aefb0de
# ╟─5292c970-539f-11ec-1016-954e4f959c5b
# ╟─5292c982-539f-11ec-246c-f19c292b9569
# ╟─5292e9b4-539f-11ec-39bf-f17b1c127fcd
# ╟─5292e9e8-539f-11ec-2110-458b2319fe94
# ╟─5292ea1a-539f-11ec-26c8-9be32cecc27f
# ╠═5292eed2-539f-11ec-1d63-c5d340995777
# ╟─5292eefa-539f-11ec-0fc8-17a002f15bc1
# ╟─52930d86-539f-11ec-01b8-733f012cf06d
# ╟─52930db8-539f-11ec-135d-f3f5e296a7df
# ╟─52930dea-539f-11ec-2123-0bc8ffae3778
# ╟─52930dfe-539f-11ec-1025-dd6c33217df1
# ╟─52931416-539f-11ec-1c30-9590e36142a9
# ╟─5293143e-539f-11ec-3360-efd6ab0845d8
# ╟─52931466-539f-11ec-21e3-27ca535ae6b6
# ╟─5293147a-539f-11ec-3d41-3d7440082a4d
# ╟─52931a6a-539f-11ec-205d-a97c37a88a3d
# ╟─52931a86-539f-11ec-09c0-690f4a26a5ce
# ╟─52931ab8-539f-11ec-0112-17cd1a8a6d1d
# ╠═52931e66-539f-11ec-2259-85b622803eac
# ╟─5293241a-539f-11ec-1683-23bb69f60a37
# ╟─52932442-539f-11ec-33dc-9d1b7f89affa
# ╠═5293273a-539f-11ec-2d71-eb9b77130d5c
# ╟─529329cc-539f-11ec-3968-55009481e08d
# ╟─529329ec-539f-11ec-3b80-3925646dc0cb
# ╟─52932a14-539f-11ec-1732-3598b6a069b1
# ╠═52934ddc-539f-11ec-35ca-ab9f0da84f0f
# ╟─52934eb8-539f-11ec-2957-e1a92d5da8c1
# ╟─52935886-539f-11ec-1873-07409549463b
# ╟─529358c2-539f-11ec-3109-bda2bf3e367f
# ╟─52935994-539f-11ec-0181-f9a2f66745c7
# ╟─529359a6-539f-11ec-233b-9fd64bc88454
# ╟─52935a20-539f-11ec-0d2a-c738eb93f5f6
# ╟─52935a34-539f-11ec-20d2-912fad8ad4f9
# ╟─52935a98-539f-11ec-13d6-73640e9af0f2
# ╠═529376ea-539f-11ec-1e7a-3f4f3c3fe90b
# ╠═529396a2-539f-11ec-1131-61ab545ff1f6
# ╟─52939706-539f-11ec-214a-3ddb7255255f
# ╠═52939bf2-539f-11ec-05ba-e5422c9fa8bd
# ╟─52939c3a-539f-11ec-3133-09d72a738c2a
# ╟─52939e5e-539f-11ec-0b0f-c186c73d59aa
# ╟─52939e86-539f-11ec-0e69-2d9b9c2c9ed1
# ╟─52939ef4-539f-11ec-2c11-139d3feafd1f
# ╟─52939efe-539f-11ec-1a1f-dd6c8508882f
# ╟─52939f0a-539f-11ec-25ad-b386c5a8611d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
