### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 034c1524-53c2-11ec-306c-cd7c49e165d2
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 034c2760-53c2-11ec-2cd5-853d04311ef5
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	__DIR__, __FILE__ = :precalc, :trig_functions
	nothing
end

# ╔═╡ 034da272-53c2-11ec-099a-4f11cd94b39f
using PlutoUI

# ╔═╡ 034da254-53c2-11ec-3914-677331802fa7
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 034c0f84-53c2-11ec-1cfb-0994d4ed6114
md"""# Trigonometric functions
"""

# ╔═╡ 034c0fb6-53c2-11ec-2b85-75a4cf08d9d6
md"""This section uses the following add-on packages:
"""

# ╔═╡ 034c2794-53c2-11ec-32c0-6b216fbfa7ba
md"""---
"""

# ╔═╡ 034c27f8-53c2-11ec-1e40-635a82813551
md"""We have informally used some of the trigonometric functions in examples so far. In this section we quickly review their definitions and some basic properties.
"""

# ╔═╡ 034c28c8-53c2-11ec-3059-c70fa732dc10
md"""The trigonometric functions are used to describe relationships between triangles and circles as well as oscillatory motions. With such a wide range of utility it is no wonder that they pop up in many places and their [origins](https://en.wikipedia.org/wiki/Trigonometric_functions#History) date to Hipparcus and Ptolemy over $2000$ years ago.
"""

# ╔═╡ 034c28fc-53c2-11ec-1456-f73b553083cb
md"""## The 6 basic trigonometric functions
"""

# ╔═╡ 034c293a-53c2-11ec-2e06-671f3d9206e5
md"""We measure angles in radians, where $360$ degrees is $2\pi$ radians. By proportions, $180$ degrees is $\pi$ radian, $90$ degrees is $\pi/2$ radians, $60$ degrees is $\pi/3$ radians, etc. In general, $x$ degrees is $2\pi \cdot x / 360$ radians (or, with cancellation, $x \cdot \frac{\pi}{180}$).
"""

# ╔═╡ 034c2956-53c2-11ec-07f8-4fb5ce812f3e
md"""For a right triangle with angles $\theta$, $\pi/2 - \theta$, and $\pi/2$ we call the side opposite $\theta$ the "opposite" side, the shorter adjacent side the "adjacent" side and the longer adjacent side the hypotenuse.
"""

# ╔═╡ 034c2c9c-53c2-11ec-0835-ebbd23890e60
begin
	pyplot()
	p = plot(legend=false, xlim=(0,5), ylim=(-1/2, 3),
	         xticks=nothing, yticks=nothing, border=:none)
	plot!([0,4,4,0],[0,0,3,0], linewidth=3)
	del = .25
	plot!([4-del, 4-del,4], [0, del, del], color=:black, linewidth=3)
	annotate!([(.75, .35, "θ"), (4.0, 1.25, "opposite"), (2, -.25, "adjacent"), (1.5, 1.25, "hypotenuse")])
end

# ╔═╡ 034c2cb2-53c2-11ec-2c6e-29fefaf9c047
md"""With these, the basic definitions for the primary trigonometric functions are
"""

# ╔═╡ 034c2ce4-53c2-11ec-1c41-4bc68a3d71be
md"""```math
\begin{align*}
\sin(\theta) &= \frac{\text{opposite}}{\text{hypotenuse}} &\quad(\text{the sine function})\\
\cos(\theta) &= \frac{\text{adjacent}}{\text{hypotenuse}} &\quad(\text{the cosine function})\\
\tan(\theta) &= \frac{\text{opposite}}{\text{adjacent}}.  &\quad(\text{the tangent function})
\end{align*}
```
"""

# ╔═╡ 034c352c-53c2-11ec-2fe0-fbe470e717cb
note("""Many students remember these through [SOH-CAH-TOA](http://mathworld.wolfram.com/SOHCAHTOA.html).""")

# ╔═╡ 034c3554-53c2-11ec-03b5-77a17b5f8410
md"""Some algebra shows that $\tan(\theta) = \sin(\theta)/\cos(\theta)$. There are also 3 reciprocal functions, the cosecant, secant and cotangent.
"""

# ╔═╡ 034c3590-53c2-11ec-1c49-032806f5509f
md"""These definitions in terms of sides only apply for $0 \leq \theta \leq \pi/2$. More generally, if we relate any angle taken in the counter clockwise direction for the $x$-axis with a point $(x,y)$ on the *unit* circle, then we can extend these definitions - the point $(x,y)$ is also $(\cos(\theta), \sin(\theta))$.
"""

# ╔═╡ 034c39a0-53c2-11ec-2e41-172cf3707dc7
let
	## {{{radian_to_trig}}}
	
	#gr()
	pyplot()
	fig_size = (400, 300)
	
	function plot_angle(m)
	    r = m*pi
	
	    ts = range(0, stop=2pi, length=100)
	    tit = "$m * pi -> ($(round(cos(r), digits=2)), $(round(sin(r), digits=2)))"
	    p = plot(cos.(ts), sin.(ts), legend=false, aspect_ratio=:equal,title=tit)
	    plot!(p, [-1,1], [0,0], color=:gray30)
	    plot!(p,  [0,0], [-1,1], color=:gray30)
	
	    if r > 0
	        ts = range(0, stop=r, length=100)
	    else
	        ts = range(r, stop=0, length=100)
	    end
	
	    plot!(p, (1/2 .+ abs.(ts)/10pi).* cos.(ts), (1/2 .+ abs.(ts)/10pi) .* sin.(ts), color=:red, linewidth=3)
	    l = 1 #1/2 + abs(r)/10pi
	    plot!(p, [0,l*cos(r)], [0,l*sin(r)], color=:green, linewidth=4)
	
	    scatter!(p, [cos(r)], [sin(r)], markersize=5)
	    annotate!(p, [(1/4+cos(r), sin(r), "(x,y)")])
	
	    p
	end
	
	
	
	## different linear graphs
	anim = @animate for m in  -4//3:1//6:10//3
	    plot_angle(m)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	caption = "An angle in radian measure corresponds to a point on the unit circle, whose coordinates define the sine and cosine of the angle. That is ``(x,y) = (\\cos(\\theta), \\sin(\\theta)``."
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 034c39d2-53c2-11ec-0de4-0b05b9b321a5
md"""### The trigonometric functions in Julia
"""

# ╔═╡ 034c3a0e-53c2-11ec-17f3-03dcba259e40
md"""Julia has the 6 basic trigonometric functions defined through the functions `sin`, `cos`, `tan`, `csc`, `sec`, and `cot`.
"""

# ╔═╡ 034c3a2c-53c2-11ec-208d-2111c680cc76
md"""Two right triangles - the one with equal, $\pi/4$, angles; and the one with angles $\pi/6$ and $\pi/3$ can have the ratio of their sides computed from basic geometry. In particular, this leads to the following values, which are usually committed to memory:
"""

# ╔═╡ 034c3a40-53c2-11ec-3f40-1593c8877099
md"""```math
\begin{align*}
\sin(0) &= 0, \quad \sin(\pi/6) = \frac{1}{2}, \quad \sin(\pi/4) = \frac{\sqrt{2}}{2}, \quad\sin(\pi/3) = \frac{\sqrt{3}}{2},\text{ and } \sin(\pi/2) = 1\\
\cos(0) &= 1, \quad \cos(\pi/6) =  \frac{\sqrt{3}}{2}, \quad \cos(\pi/4) = \frac{\sqrt{2}}{2}, \quad\cos(\pi/3) = \frac{1}{2},\text{ and } \cos(\pi/2) = 0.
\end{align*}
```
"""

# ╔═╡ 034c3a54-53c2-11ec-1d59-df7611f4e273
md"""Using the circle definition allows these basic values to inform us of values throughout the unit circle.
"""

# ╔═╡ 034c3a5e-53c2-11ec-0162-013d2e311ec6
md"""These all follow from the definition involving the unit circle:
"""

# ╔═╡ 034c3be2-53c2-11ec-0760-6de5c35e74a5
md"""  * If the angle $\theta$ corresponds to a point $(x,y)$ on the unit circle, then the angle $-\theta$ corresponds to $(x, -y)$. So $\sin(\theta) = - \sin(-\theta)$ (an odd function), but $\cos(\theta) = \cos(-\theta)$ (an even function).
  * If the angle $\theta$ corresponds to a point $(x,y)$ on the unit circle, then rotating by $\pi$ moves the points to $(-x, -y)$. So $\cos(\theta) = x = - \cos(\theta + \pi)$, and $\sin(\theta) = y = -\sin(\theta + \pi)$.
  * If the angle $\theta$ corresponds to a point $(x,y)$ on the unit circle, then rotating by $\pi/2$ moves the points to $(-y, x)$. So $\cos(\theta) = x = \sin(\theta + \pi/2)$.
"""

# ╔═╡ 034c3bf8-53c2-11ec-1725-d7adb066fd3a
md"""The fact that $x^2 + y^2 = 1$ for the unit circle leads to the "Pythagorean identity" for trigonometric functions:
"""

# ╔═╡ 034c3c20-53c2-11ec-0e21-6b5c432efc4f
md"""```math
\sin(\theta)^2 + \cos(\theta)^2 = 1.
```
"""

# ╔═╡ 034c3c34-53c2-11ec-1b19-61d72a5df6f0
md"""This basic fact can be manipulated many ways. For example, dividing through by $\cos(\theta)^2$ gives the related identity: $\tan(\theta)^2 + 1 = \sec(\theta)^2$.
"""

# ╔═╡ 034c3c5c-53c2-11ec-1728-65568ff4fd27
md"""`Julia`'s functions can compute values for any angles, including these fundamental ones:
"""

# ╔═╡ 034c585e-53c2-11ec-2b3a-49e560c6a5f7
[cos(theta) for theta in [0, pi/6, pi/4, pi/3, pi/2]]

# ╔═╡ 034c58cc-53c2-11ec-2207-61506209792c
md"""These are floating point approximations, as can be seen clearly in the last value. Symbolic math can be used if exactness matters:
"""

# ╔═╡ 034c639e-53c2-11ec-1419-7b4badcd5242
cos.([0, PI/6, PI/4, PI/3, PI/2])

# ╔═╡ 034c77f8-53c2-11ec-39d7-997e78430765
note(L"""

For really large values, round off error can play a big role. For example, the *exact* value of $\sin(1000000 \pi)$ is $0$, but the returned value is not quite $0$ `sin(1_000_000 * pi) = -2.231912181360871e-10`. For exact multiples of $\pi$ with large multiples the `sinpi` and  `cospi` functions are useful.

(Both functions are computed by first employing periodicity to reduce the problem to a smaller angle. However, for large multiples the floating-point roundoff becomes a problem with the usual functions.)

""")

# ╔═╡ 034c7852-53c2-11ec-0733-550e1cf9911e
md"""##### Example
"""

# ╔═╡ 034c78c0-53c2-11ec-0d61-b105140106b1
md"""Measuring the height of a [tree](https://lifehacker.com/5875184/is-there-an-easy-way-to-measure-the-height-of-a-tree) may be a real-world task for some, but a typical task for nearly all trigonometry students. How might it be done? If a right triangle can be formed where the angle and adjacent side length are known, then the opposite side (the height of the tree) can be solved for with the tangent function. For example, if standing $100$ feet from the base of the tree the tip makes a 15 degree angle the height is given by:
"""

# ╔═╡ 034c811c-53c2-11ec-0ce8-d36818c2c35f
let
	theta = 15 * pi / 180
	adjacent = 100
	opposite = adjacent * tan(theta)
end

# ╔═╡ 034c8146-53c2-11ec-06f5-29629cc502e9
md"""Having some means to compute an angle and then a tangent of that angle handy is not a given, so the linked to article provides a few other methods taking advantage of similar triangles.
"""

# ╔═╡ 034c8194-53c2-11ec-29f4-0168eda5dc52
md"""You can also measure distance with your [thumb](http://www.vendian.org/mncharity/dir3/bodyruler_angle/) or fist. How? The fist takes up about $10$ degrees of view when held straight out. So, pacing off backwards until the fist completely occludes the tree will give the distance of the adjacent side of a right triangle. If that distance is $30$ paces what is the height of the tree? Well, we need some facts. Suppose your pace is $3$ feet. Then the adjacent length is $90$ feet. The multiplier is the tangent of $10$ degrees, or:
"""

# ╔═╡ 034c851a-53c2-11ec-25d4-3f58af5fa625
tan(10 * pi/180)

# ╔═╡ 034c855e-53c2-11ec-0ab3-4d6cdb766f1a
md"""Which for sake of memory we will say is $1/6$ (a $5$ percent error). So that answer is *roughly* $15$ feet:
"""

# ╔═╡ 034c87f2-53c2-11ec-0dc2-9d4487a840e6
30 * 3 / 6

# ╔═╡ 034c881c-53c2-11ec-3b11-571a634f613f
md"""Similarly, you can use your thumb instead of your first. To use your first you can multiply by $1/6$ the adjacent side, to use your thumb about $1/30$ as this approximates the tangent of $2$ degrees:
"""

# ╔═╡ 034c8cc0-53c2-11ec-3077-ed9a8c0c085c
1/30, tan(2*pi/180)

# ╔═╡ 034c8cd4-53c2-11ec-192a-ede567cc4836
md"""This could be reversed. If you know the height of something a distance away that is covered by your thumb or fist, then you would multiply that height by the appropriate amount to find your distance.
"""

# ╔═╡ 034c8cfc-53c2-11ec-0371-29be3473ca58
md"""### Basic properties
"""

# ╔═╡ 034c8d4c-53c2-11ec-253e-f9746816f1ef
md"""The sine function is defined for all real $\theta$ and has a range of $[-1,1]$. Clearly as $\theta$ winds around the $x$-axis, the position of the $y$ coordinate begins to repeat itself. We say the sine function is *periodic* with period $2\pi$. A graph will illustrate:
"""

# ╔═╡ 034c8ffe-53c2-11ec-2476-dfc7fedbec74
plot(sin, 0, 4pi)

# ╔═╡ 034c908c-53c2-11ec-382c-b7444dad315a
md"""The graph shows two periods. The wavy aspect of the graph is why this function is used to model periodic motions, such as the amount of sunlight in a day, or the alternating current powering a computer.
"""

# ╔═╡ 034c910c-53c2-11ec-2b56-071c16680be7
md"""From this graph - or considering when the $y$ coordinate is $0$ - we see that the sine function has zeros at any integer multiple of $\pi$, or $k\pi$, $k$ in $\dots,-2,-1, 0, 1, 2, \dots$.
"""

# ╔═╡ 034c912a-53c2-11ec-0ee2-1161908238fe
md"""The cosine function is similar, in that it has the same domain and range, but is "out of phase" with the sine curve. A graph of both shows the two are related:
"""

# ╔═╡ 034c9990-53c2-11ec-17d8-3bfc18d5f945
begin
	plot(sin, 0, 4pi, label="sin")
	plot!(cos, 0, 4pi, label="cos")
end

# ╔═╡ 034c99ea-53c2-11ec-1457-fd321954372d
md"""The cosine function is just a shift of the sine function (or vice versa). We see that the zeros of the cosine function happen at points of the form $\pi/2 + k\pi$, $k$ in $\dots,-2,-1, 0, 1, 2, \dots$.
"""

# ╔═╡ 034c9a12-53c2-11ec-2407-adbac3049411
md"""The tangent function does not have all $\theta$ for its domain, rather those points where division by $0$ occurs are excluded. These occur when the cosine is $0$, or again at $\pi/2 + k\pi$, $k$ in $\dots,-2,-1, 0, 1, 2, \dots$. The range of the tangent function will be all real $y$.
"""

# ╔═╡ 034c9a32-53c2-11ec-223f-83b3b9d48711
md"""The tangent function is also periodic, but not with period $2\pi$, but rather just $\pi$. A graph will show this. Here we avoid the vertical asymptotes by keeping them out of the plot domain and layering several plots.
"""

# ╔═╡ 034c9f62-53c2-11ec-3236-81509d301db0
let
	k = -2
	pt = plot(tan, k*pi - pi/2+.1, k*pi + pi/2 - .1, legend=false, color=:blue)
	for k in -1:2
	  plot!(pt, tan,  k*pi - pi/2+.1, k*pi + pi/2 - .1, color=:blue)
	end
	pt
end

# ╔═╡ 034c9fb2-53c2-11ec-37d6-33a5c547c666
md"""### Functions using degrees
"""

# ╔═╡ 034c9fee-53c2-11ec-168e-a5f7b86d8495
md"""Trigonometric function are functions of angles which have two common descriptions: in terms of degrees or radians. Degrees are common when right triangles are considered, radians much more common in general, as the relationship with arc-length holds in that $r\theta = l$, where $r$ is the radius of a circle and $l$ the length of the arc formed by angle $\theta$.
"""

# ╔═╡ 034ca02a-53c2-11ec-37b0-a1cf52dd8008
md"""The two are related, as a circle has both  $2\pi$ radians and $360$ degrees. So to convert from degrees into radians it takes multiplying by $2\pi/360$ and to convert from radians to degrees it takes multiplying by $360/(2\pi)$. The `deg2rad` and `rad2deg` functions are available for this task.
"""

# ╔═╡ 034ca070-53c2-11ec-2f4d-59c8b62dc102
md"""In `Julia`, the functions `sind`, `cosd`, `tand`, `cscd`, `secd`, and `cotd` are available to simplify the task of composing the two operations (that is `sin(deg2rad(x))` is the essentially same as `sind(x)`).
"""

# ╔═╡ 034ca0a4-53c2-11ec-0aff-73429f64e2fc
md"""## The sum-and-difference formulas
"""

# ╔═╡ 034ca0d6-53c2-11ec-1211-abdf138897f3
md"""Consider the point on the unit circle $(x,y) = (\cos(\theta), \sin(\theta))$. In terms of $(x,y)$ (or $\theta$) is there a way to represent the angle found by rotating an additional $\theta$, that is what is $(\cos(2\theta), \sin(2\theta))$?
"""

# ╔═╡ 034ca0f2-53c2-11ec-2688-c168478c6df8
md"""More generally, suppose we have two angles $\alpha$ and $\beta$, can we represent the values of $(\cos(\alpha + \beta), \sin(\alpha + \beta))$ using the values just involving $\beta$ and $\alpha$ separately?
"""

# ╔═╡ 034ca124-53c2-11ec-3b88-510434990f78
md"""According to [Wikipedia](https://en.wikipedia.org/wiki/Trigonometric_functions#Identities) the following figure (from [mathalino.com](http://www.mathalino.com/reviewer/derivation-of-formulas/derivation-of-sum-and-difference-of-two-angles)) has ideas that date to Ptolemy:
"""

# ╔═╡ 034ca142-53c2-11ec-079c-f33eb5fb54ff
md"""![Relations between angles](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/precalc/figures/summary-sum-and-difference-of-two-angles.jpg)
"""

# ╔═╡ 034ca426-53c2-11ec-04ec-4b2f397db67e
#ImageFile("figures/summary-sum-and-difference-of-two-angles.jpg", "Relations between angles")

# ╔═╡ 034ca4dc-53c2-11ec-2abb-a5d1588e3873
md"""To read this, there are three triangles: the bigger (green with pink part) has hypotenuse $1$ (and adjacent and opposite sides that form the hypotenuses of the other two); the next biggest (yellow) hypotenuse $\cos(\beta)$,  adjacent side (of angle $\alpha$) $\cos(\beta)\cdot \cos(\alpha)$, and opposite side $\cos(\beta)\cdot\sin(\alpha)$; and  the smallest (pink) hypotenuse $\sin(\beta)$, adjacent side (of angle $\alpha$) $\sin(\beta)\cdot \cos(\alpha)$, and opposite side $\sin(\beta)\sin(\alpha)$.
"""

# ╔═╡ 034ca4ee-53c2-11ec-17b2-89858235e405
md"""This figure shows the following sum formula for sine and cosine:
"""

# ╔═╡ 034ca584-53c2-11ec-2708-8be8fdf596c2
md"""```math
\begin{align*}
\sin(\alpha + \beta) &= \sin(\alpha)\cos(\beta) + \cos(\alpha)\sin(\beta), & (\overline{CE} + \overline{DF})\\
\cos(\alpha + \beta) &= \cos(\alpha)\cos(\beta) - \sin(\alpha)\sin(\beta). & (\overline{AC} - \overline{DE})
\end{align*}
```
"""

# ╔═╡ 034ca5b6-53c2-11ec-0b78-7377559dee17
md"""Using the fact that $\sin$ is an odd function and $\cos$ an even function, related formulas for the difference $\alpha - \beta$ can be derived.
"""

# ╔═╡ 034ca5c0-53c2-11ec-35ae-2bf4bbbe11b2
md"""Taking $\alpha = \beta$ we immediately get the "double-angle" formulas:
"""

# ╔═╡ 034ca5d4-53c2-11ec-0080-8d8f4aa6766c
md"""```math
\begin{align*}
\sin(2\alpha) &= 2\sin(\alpha)\cos(\alpha)\\
\cos(2\alpha) &= \cos(\alpha)^2 - \sin(\alpha)^2.
\end{align*}
```
"""

# ╔═╡ 034ca5f2-53c2-11ec-37d9-87c38abc11c1
md"""The latter looks like the Pythagorean identify, but has a minus sign. In fact, the Pythagorean identify is often used to rewrite this, for example $\cos(2\alpha) = 2\cos(\alpha)^2 - 1$ or $1 - 2\sin(\alpha)^2$.
"""

# ╔═╡ 034ca612-53c2-11ec-0198-c1249878dc11
md"""Applying the above with $\alpha = \beta/2$, we get that $\cos(\beta) = 2\cos(\beta/2)^2 -1$, which rearranged yields the "half-angle" formula: $\cos(\beta/2)^2 = (1 + \cos(\beta))/2$.
"""

# ╔═╡ 034ca638-53c2-11ec-0f30-b73dc06cae63
md"""##### Example
"""

# ╔═╡ 034ca656-53c2-11ec-23be-9d7435d9a20c
md"""Consider the expressions $\cos((n+1)\theta)$ and $\cos((n-1)\theta)$. These can be re-expressed as:
"""

# ╔═╡ 034ca66a-53c2-11ec-20bf-1dc0b1a2e898
md"""```math
\begin{align*}
\cos((n+1)\theta) &= \cos(n\theta + \theta) = \cos(n\theta) \cos(\theta) - \sin(n\theta)\sin(\theta), \text{ and}\\
\cos((n-1)\theta) &= \cos(n\theta - \theta) = \cos(n\theta) \cos(-\theta) - \sin(n\theta)\sin(-\theta).
\end{align*}
```
"""

# ╔═╡ 034ca6d6-53c2-11ec-2377-ef7506eaf647
md"""But $\cos(-\theta) = \cos(\theta)$, whereas $\sin(-\theta) = -\sin(\theta)$. Using this, we add the two formulas above to get:
"""

# ╔═╡ 034ca6ec-53c2-11ec-2262-01b53e557bb0
md"""```math
\cos((n+1)\theta) = 2\cos(n\theta) \cos(\theta)  - \cos((n-1)\theta).
```
"""

# ╔═╡ 034ca71e-53c2-11ec-17e1-bdfd2c6818dc
md"""That is the angle for a multiple of $n+1$ can be expressed in terms of the angle with a multiple of $n$ and $n-1$. This can be used recursively to find expressions for $\cos(n\theta)$ in terms of polynomials in $\cos(\theta)$.
"""

# ╔═╡ 034ca7a0-53c2-11ec-1a92-ff139929a971
md"""## Inverse trigonometric functions
"""

# ╔═╡ 034ca7e6-53c2-11ec-0328-e93c2b50dd35
md"""The  trigonometric functions are all periodic. In particular they are not monotonic over their entire domain. This means there is no *inverse* function applicable. However, by restricting the domain to where the functions are monotonic, inverse functions can be defined:
"""

# ╔═╡ 034cab9c-53c2-11ec-2921-2bcc36075f2c
md"""  * For $\sin(x)$, the restricted domain of $[-\pi/2, \pi/2]$ allows for the arcsine function to be defined. In `Julia` this is implemented with `asin`.
  * For $\cos(x)$, the restricted domain of $[0,\pi]$ allows for the arccosine function to be defined. In `Julia` this is implemented with `acos`.
  * For $\tan(x)$, the restricted domain of $(-\pi/2, \pi/2)$ allows for the arctangent function to be defined. In `Julia` this is implemented with `atan`.
"""

# ╔═╡ 034cad40-53c2-11ec-38fc-ff529a0bf736
md"""For example, the arcsine function is defined for $-1 \leq x \leq 1$ and has a range of $-\pi/2$ to $\pi/2$:
"""

# ╔═╡ 034cb25e-53c2-11ec-2508-6b2604898290
plot(asin, -1, 1)

# ╔═╡ 034cb29a-53c2-11ec-1af6-fb9ccd72c6ed
md"""The arctangent has domain of all real $x$. It has shape given by:
"""

# ╔═╡ 034cb8ee-53c2-11ec-1ba1-f919dd2db1fe
plot(atan, -10, 10)

# ╔═╡ 034cb952-53c2-11ec-2ac2-2f6605b31d99
md"""The horizontal asymptotes are $y=\pi/2$ and $y=-\pi/2$.
"""

# ╔═╡ 034cb990-53c2-11ec-2892-edac399859b4
md"""### Implications of a restricted domain
"""

# ╔═╡ 034cb9be-53c2-11ec-013c-f54c84b220be
md"""Notice that $\sin(\arcsin(x)) = x$ for any $x$ in $[-1,1]$, but, of course,  not for all $x$, as the output of the sine function can't be arbitrarily large.
"""

# ╔═╡ 034cb9f0-53c2-11ec-309c-f1af929285be
md"""However, $\arcsin(\sin(x))$ is defined for all $x$, but only equals $x$ when $x$ is in $[-\pi/2, \pi/2]$. The output, or range, of the $\arcsin$ function is restricted to that interval.
"""

# ╔═╡ 034cbb14-53c2-11ec-106b-af26b7605e7f
md"""This can be limiting at times. A common case is to find the angle in $[0, 2\pi)$ corresponding to a point $(x,y)$. In the simplest case (the first and fourth quadrants) this is just given by $\arctan(y/x)$. But with some work, the correct angle can be found for any pair $(x,y)$. As this is a common desire, the `atan` function with two arguments, `atan(y,x)`, is available. This function returns a value in $(-\pi, \pi]$.
"""

# ╔═╡ 034cbb3c-53c2-11ec-37a2-9de430e5fc9b
md"""For example, this will not give back $\theta$ without more work to identify the quadrant:
"""

# ╔═╡ 034cc370-53c2-11ec-1128-a9582b01086e
begin
	theta = 3pi/4                     # 2.35619...
	x,y = (cos(theta), sin(theta))    # -0.7071..., 0.7071...
	atan(y/x)
end

# ╔═╡ 034cc396-53c2-11ec-3b82-b1d8ed9b0d1f
md"""But,
"""

# ╔═╡ 034cc618-53c2-11ec-185f-dd07a437e2dd
atan(y, x)

# ╔═╡ 034cc654-53c2-11ec-26a5-dd45d6ad4967
md"""##### Example
"""

# ╔═╡ 034cc6c2-53c2-11ec-054a-dbb125c1fc90
md"""A (white) light shining through a [prism](http://tinyurl.com/y8sczg4t) will be deflected depending on the material of the prism and the angles involved (refer to the link for a figure). The relationship can be analyzed by tracing a ray through the figure and utilizing Snell's law. If the prism has index of refraction $n$ then the ray will deflect by an amount $\delta$ that depends on the angle, $\alpha$ of the prism and the initial angle ($\theta_0$) according to:
"""

# ╔═╡ 034cc6fe-53c2-11ec-18dc-f1e31208e0ad
md"""```math
\delta = \theta_0 - \alpha  + \arcsin(n \sin(\alpha - \arcsin(\frac{1}{n}\sin(\theta_0)))).
```
"""

# ╔═╡ 034cc730-53c2-11ec-1252-793e52938d43
md"""If $n=1.5$ (glass), $\alpha = \pi/3$ and $\theta_0=\pi/6$, find the deflection (in radians).
"""

# ╔═╡ 034cc74e-53c2-11ec-1fbf-af46662395eb
md"""We have:
"""

# ╔═╡ 034cd004-53c2-11ec-11d3-b3d2ac916b9d
let
	n, alpha, theta0 = 1.5, pi/3, pi/6
	delta = theta0 - alpha + asin(n * sin(alpha - asin(sin(theta0)/n)))
end

# ╔═╡ 034cd05e-53c2-11ec-0e95-0908b46bab36
md"""For small $\theta_0$ and $\alpha$ the deviation is approximated by $(n-1)\alpha$. Compare this approximation to the actual value when $\theta_0 = \pi/10$ and $\alpha=\pi/15$.
"""

# ╔═╡ 034cd0f4-53c2-11ec-11a2-d98c509e33a5
md"""We have:
"""

# ╔═╡ 034cdc2a-53c2-11ec-2b3b-d9dffb71e5a1
let
	n, alpha, theta0 = 1.5, pi/15, pi/10
	delta = theta0 - alpha + asin(n * sin(alpha - asin(sin(theta0)/n)))
	delta, (n-1)*alpha
end

# ╔═╡ 034cdc48-53c2-11ec-1d44-3f9ad087bb74
md"""The approximation error is about 2.7 percent.
"""

# ╔═╡ 034cdc5c-53c2-11ec-2d1a-a73ffef7faa7
md"""##### Example
"""

# ╔═╡ 034cf430-53c2-11ec-0c82-35de091ed365
md"""The AMS has an interesting column on [rainbows](http://www.ams.org/publicoutreach/feature-column/fcarc-rainbows) the start of which uses some formulas from the previous example. Click through to see a ray of light passing through a spherical drop of water, as analyzed by Descartes. The deflection of the ray occurs when the incident light hits the drop of water, then there is an *internal* deflection of the light, and finally when the light leaves, there is another deflection. The total deflection (in radians) is $D = (i-r) + (\pi - 2r) + (i-r) = \pi - 2i - 4r$. However, the incident angle $i$ and the refracted angle $r$ are related by Snell's law: $\sin(i) = n \sin(r)$. The value $n$ is the index of refraction and is $4/3$ for water. (It was $3/2$ for glass in the previous example.) This gives
"""

# ╔═╡ 034cf480-53c2-11ec-0363-8fb089afda9b
md"""```math
D = \pi + 2i - 4 \arcsin(\frac{1}{n} \sin(i)).
```
"""

# ╔═╡ 034cf4d0-53c2-11ec-3b8f-8161e8124ad6
md"""Graphing this for incident angles between $0$ and $\pi/2$ we have:
"""

# ╔═╡ 034cfb6a-53c2-11ec-1886-5d8a8ae7fb96
let
	n = 4/3
	D(i) = pi + 2i - 4 * asin(sin(i)/n)
	plot(D, 0, pi/2)
end

# ╔═╡ 034cfba6-53c2-11ec-2602-039b00791b90
md"""Descartes was interested in the minimum value of this graph, as it relates to where the light concentrates. This is roughly at $1$ radian or about $57$ degrees:
"""

# ╔═╡ 034cfdec-53c2-11ec-1370-8518c530fe6c
rad2deg(1.0)

# ╔═╡ 034cfe12-53c2-11ec-2218-83c3a399d50b
md"""(Using calculus it can be seen to be $\arccos(((n^2-1)/3)^{1/2})$.)
"""

# ╔═╡ 034cfe26-53c2-11ec-06a7-a9f88efdf8d3
md"""##### Example: The Chebyshev Polynomials
"""

# ╔═╡ 034cfe50-53c2-11ec-00a8-0bc7dd332cdb
md"""Consider again this equation derived with the sum-and-difference formula:
"""

# ╔═╡ 034cfe62-53c2-11ec-1c25-d19ae86b2982
md"""```math
\cos((n+1)\theta) = 2\cos(n\theta) \cos(\theta)  - \cos((n-1)\theta).
```
"""

# ╔═╡ 034cfe7e-53c2-11ec-0597-13bed17d3a97
md"""Let $T_n(x) = \cos(n \arccos(x))$. Calling $\theta = \arccos(x)$ for $-1 \leq x \leq x$ we get a relation between these functions:
"""

# ╔═╡ 034cfe8a-53c2-11ec-0b22-5903344fbca1
md"""```math
T_{n+1}(x) = 2x T_n(x) - T_{n-1}(x).
```
"""

# ╔═╡ 034cfeb0-53c2-11ec-1a00-c53b689b468d
md"""We can simplify a few: For example, when $n=0$ we see immediately that $T_0(x) = 1$, the constant function. Whereas with $n=1$ we get $T_1(x) = \cos(\arccos(x)) = x$. Things get more interesting as we get bigger $n$, for example using the equation above we get $T_2(x) = 2xT_1(x) - T_0(x) = 2x\cdot x - 1 = 2x^2 - 1$. Continuing, we'd get $T_3(x) = 2 x T_2(x) - T_1(x) = 2x(2x^2 - 1) - x = 4x^3 -3x$.
"""

# ╔═╡ 034cfebc-53c2-11ec-311f-8bd3af65a463
md"""A few things become clear from the above two representations:
"""

# ╔═╡ 034cffe6-53c2-11ec-31f0-0da66e05a2bc
md"""  * Starting from $T_0(x) = 1$ and $T_1(x)=x$ and using the recursive defintion of $T_{n+1}$ we get a family of polynomials where $T_n(x)$ is a degree $n$ polynomial. These are defined for all $x$, not just $-1 \leq x \leq 1$.
  * Using the initial definition, we see that the zeros of $T_n(x)$ all occur within $[-1,1]$ and happen when $n\arccos(x) = k\pi + \pi/2$, or $x=\cos((2k+1)/n \cdot \pi/2)$ for $k=0, 1, \dots, n-1$.
"""

# ╔═╡ 034d0006-53c2-11ec-1b40-ab882bb02aff
md"""Other properties of this polynomial family are not at all obvious. One is that amongst all polynomials of degree $n$ with roots in $[-1,1]$, $T_n(x)$ will be the smallest in magnitude (after we divide by the leading coefficient to make all polynomials considered to be monic). We check this for one case. Take $n=4$, then we have: $T_4(x) = 8x^4 - 8x^2 + 1$. Compare this with $q(x) = (x+3/5)(x+1/5)(x-1/5)(x-3/5)$ (evenly spaced zeros):
"""

# ╔═╡ 034d09be-53c2-11ec-1b8d-97de1ed2e2a5
begin
	T4(x) = (8x^4 - 8x^2 + 1) / 8
	q(x) = (x+3/5)*(x+1/5)*(x-1/5)*(x-3/5)
	plot(abs ∘ T4, -1,1)
	plot!(abs ∘ q, -1,1)
end

# ╔═╡ 034d09fc-53c2-11ec-3afa-bf864bf88af1
md"""##### Example sums of sines
"""

# ╔═╡ 034d0a24-53c2-11ec-0170-21778b8744e4
md"""For the function $f(x) = \sin(x)$ we have an understanding of the related family of functions defined by linear transformations:
"""

# ╔═╡ 034d0a42-53c2-11ec-0a3a-c95100a8ff2b
md"""```math
g(x) = a + b \sin((2\pi n)x)
```
"""

# ╔═╡ 034d0a56-53c2-11ec-2e50-2f339bc761e3
md"""That is $g$ is shifted up by $a$ units, scaled vertically by $b$ units and has a period of $1/n$. We see a simple plot here where we can verify the transformation:
"""

# ╔═╡ 034d18fc-53c2-11ec-3290-2bf5aac6cb39
begin
	g(x;  b=1,n=1) = b*sin(2pi*n*x)
	g1(x) = 1 + g(x, b=2, n=3)
	plot(g1, 0, 1)
end

# ╔═╡ 034d191a-53c2-11ec-10bb-e3445b16c382
md"""We can consider the sum of such functions, for example
"""

# ╔═╡ 034d248c-53c2-11ec-3689-a722a4b68b71
begin
	g2(x) = 1 + g(x, b=2, n=3) + g(x, b=4, n=5)
	plot(g2, 0, 1)
end

# ╔═╡ 034d24aa-53c2-11ec-3ea3-df1d895c2155
md"""Though still periodic, we can see with this simple example that sums of different sine functions can have somewhat complicated graphs.
"""

# ╔═╡ 034d2504-53c2-11ec-107c-e559295e607f
md"""Sine functions can be viewed as the `x` position of a point traveling around a circle so `g(x, b=2, n=3)` is the `x` position of point traveling around a circle of radius $2$ that completes a circuit in $1/3$ units of time.
"""

# ╔═╡ 034d254a-53c2-11ec-022a-83fb4092f788
md"""The superposition of the two sine functions that `g2` represents could be viewed as the position of a circle moving around a point that is moving around another circle. The following graphic, with $b_1=1/3, n_1=3, b_2=1/4$, and $n_2=4$, shows an example that produces the related cosine sum (moving right along the $x$ axis), the sine sum (moving down along the $y$ axis, *and* the trace of the position of the point generating these two plots.
"""

# ╔═╡ 034d32ba-53c2-11ec-2c53-cfec9dc9bb9b
let
	unzip(vs::Vector) = Tuple([[vs[i][j] for i in eachindex(vs)] for j in eachindex(vs[1])])
	function makegraph(t, b₁,n₁, b₂=0, n₂=1)
	
	    f₁ = x -> b₁*[sin(2pi*n₁*x), cos(2pi*n₁*x)]
	    f₂ = x -> b₂*[sin(2pi*n₂*x), cos(2pi*n₂*x)]
	    h = x -> f₁(x) + f₂(x)
	
	    ts = range(0, 2pi, length=1000)
	
	
	    ylims = (-b₁-b₂-2, b₁ + b₂)
	    xlims = (-b₁-b₂, b₁ + b₂ + 2)
	
	    p = plot(; xlim=xlims, ylim=ylims,
	             legend=false,
	             aspect_ratio=:equal)
	
	    α = 0.3
	    # circle 1
	    plot!(p, unzip(f₁.(range(0, 2pi/n₁, length=100))), alpha=α)
	    scatter!(p, unzip([f₁(t)]), markersize=1, alpha=α)
	
	    # circle 2
	    us, vs = unzip(f₂.(range(0, 2pi/n₂, length=100)))
	    a,b = f₁(t)
	    plot!(p, a .+ us, b .+ vs, alpha=α)
	    scatter!(p, unzip([h(t)]), markersize=5)
	
	    # graph of (x,y) over [0,t]
	    ts = range(0, t, length=200)
	    plot!(p, unzip(h.(ts)), linewidth=1, alpha=0.5, linestyle=:dash)
	
	    # graph of x over [0,t]
	    ys′ = -ts
	    xs′ = unzip(h.(ts))[1]
	    plot!(p, xs′, ys′, linewidth=2)
	
	    # graph of y over [0,t]
	    xs′ = ts
	    ys′ = unzip(h.(ts))[2]
	    plot!(p, xs′, ys′, linewidth=2)
	
	
	    p
	end
	
	# create animoation
	b₁=1/3; n₁=3; b₂=1/4; n₂=4
	pyplot()
	fig_size = (400, 300)
	anim = @animate for t ∈ range(0, 2.5, length=50)
	    makegraph(t, b₁, n₁, b₂, n₂)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 5)
	
	caption = "Superposition of sines and cosines represented by an epicycle"
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 034d3346-53c2-11ec-1a85-998ed67d61ba
md"""As can be seen, even a somewhat simple combination can produce complicated graphs (a fact known to [Ptolemy](https://en.wikipedia.org/wiki/Deferent_and_epicycle)) . How complicated can such a graph get? This won't be answered here, but for fun enjoy this video produced by the same technique using more moving parts from the [`Javis.jl`](https://github.com/Wikunia/Javis.jl/blob/master/examples/fourier.jl) package:
"""

# ╔═╡ 034d42ac-53c2-11ec-3b87-c989d519a57d
begin
	txt ="""
	<iframe width="560" height="315" src="https://www.youtube.com/embed/rrmx2Q3sO1Y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
	"""
	tpl = CalculusWithJulia.WeaveSupport.centered_content_tpl
	txt = CalculusWithJulia.WeaveSupport.Mustache.render(tpl, content=txt, caption="Julia logo animated")
	CalculusWithJulia.WeaveSupport.HTMLoutput(txt)
end

# ╔═╡ 034d42e6-53c2-11ec-0a9d-f54a978b548b
md"""## Hyperbolic trigonometric functions
"""

# ╔═╡ 034d433e-53c2-11ec-1d26-37823ef520f2
md"""Related to the trigonometric functions are the hyperbolic trigonometric functions. Instead of associating a point $(x,y)$ on the unit circle with an angle $\theta$, we associate a point $(x,y)$ on the unit *hyperbola* ($x^2 - y^2 = 1$). We define the hyperbolic sine ($\sinh$) and hyperbolic cosine ($\cosh$) through $(\cosh(\theta), \sinh(\theta)) = (x,y)$.
"""

# ╔═╡ 034d4a5c-53c2-11ec-08d0-518c76a91e7e
let
	## inspired by https://en.wikipedia.org/wiki/Hyperbolic_function
	# y^2 = x^2 - 1
	top(x) = sqrt(x^2 - 1)
	
	p = plot(; legend=false, aspect_ratio=:equal)
	
	x₀ = 2
	xs = range(1, x₀, length=100)
	ys = top.(xs)
	plot!(p, xs,  ys, color=:red)
	plot!(p, xs, -ys, color=:red)
	
	xs = -reverse(xs)
	ys = top.(xs)
	plot!(p, xs,  ys, color=:red)
	plot!(p, xs, -ys, color=:red)
	
	xs = range(-x₀, x₀, length=3)
	plot!(p, xs, xs, linestyle=:dash, color=:blue)
	plot!(p, xs, -xs, linestyle=:dash, color=:blue)
	
	a = 1.2
	plot!(p, [0,cosh(a)], [sinh(a), sinh(a)])
	annotate!(p, sinh(a)/2, sinh(a)+0.25,"cosh(a)")
	plot!(p, [cosh(a),cosh(a)], [sinh(a), 0])
	annotate!(p, sinh(a) + 1, cosh(a)/2,"sinh(a)")
	scatter!(p, [cosh(a)], [sinh(a)], markersize=5)
	
	
	ts = range(0, a, length=100)
	xs′ = cosh.(ts)
	ys′ = sinh.(ts)
	
	xs = [0, 1, xs′..., 0]
	ys = [0, 0, ys′..., 0]
	plot!(p, xs, ys, fillcolor=:red, fill=true, alpha=.3)
	
	p
end

# ╔═╡ 034d4a70-53c2-11ec-2798-7521872ca0b9
md"""These values are more commonly expressed using the exponential function as:
"""

# ╔═╡ 034d4a8e-53c2-11ec-30fd-719237f64617
md"""```math
\begin{align*}
\sinh(x) &= \frac{e^x - e^{-x}}{2}\\
\cosh(x) &= \frac{e^x + e^{-x}}{2}.
\end{align*}
```
"""

# ╔═╡ 034d4aac-53c2-11ec-00f8-6d4ae61c90c8
md"""The hyperbolic tangent is then the ratio of $\sinh$ and $\cosh$. As well, three inverse hyperbolic functions can be defined.
"""

# ╔═╡ 034d4aca-53c2-11ec-376f-3bb90fb4047c
md"""The `Julia` functions to compute these values are named `sinh`, `cosh`, and `tanh`.
"""

# ╔═╡ 034d4af2-53c2-11ec-3174-b72c0190484f
md"""## Questions
"""

# ╔═╡ 034d4b1c-53c2-11ec-1541-fb2f0d2b523a
md"""###### Question
"""

# ╔═╡ 034d4b38-53c2-11ec-39eb-efa280667d4c
md"""What is bigger $\sin(1.23456)$ or $\cos(6.54321)$?
"""

# ╔═╡ 034d511c-53c2-11ec-03ba-431f21d2c084
let
	a = sin(1.23456) > cos(6.54321)
	choices = [raw"``\sin(1.23456)``", raw"``\cos(6.54321)``"]
	ans = a ? 1 : 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d5132-53c2-11ec-2452-a35cf8d13012
md"""###### Question
"""

# ╔═╡ 034d51b4-53c2-11ec-3087-918aeffa2557
md"""Let $x=\pi/4$. What is bigger $\cos(x)$ or $x$?
"""

# ╔═╡ 034d5594-53c2-11ec-1fc2-e5b9434e1538
let
	x = pi/4
	a = cos(x) > x
	choices = [raw"``\cos(x)``", "``x``"]
	ans = a ? 1 : 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d55a6-53c2-11ec-1643-676fc336f048
md"""###### Question
"""

# ╔═╡ 034d55ba-53c2-11ec-3dc4-4f24b0360f69
md"""The cosine function is a simple tranformation of the sine function. Which one?
"""

# ╔═╡ 034d5e84-53c2-11ec-0fc7-6bb14470ac97
let
	choices = [
	raw"``\cos(x) = \sin(x - \pi/2)``",
	raw"``\cos(x) = \sin(x + \pi/2)``",
	raw"``\cos(x) = \pi/2 \cdot \sin(x)``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 034d5e96-53c2-11ec-2b9a-fd4d53191004
md"""###### Question
"""

# ╔═╡ 034d5eac-53c2-11ec-2c32-533e304abd8b
md"""Graph the secant function. The vertical asymptotes are at?
"""

# ╔═╡ 034d6b4a-53c2-11ec-207e-8dec68fc3857
let
	choices = [
	L"The values $k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$",
	L"The values $\pi/2 + k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$",
	L"The values $2k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d6b72-53c2-11ec-0463-29269ecb6982
md"""###### Question
"""

# ╔═╡ 034d6ba4-53c2-11ec-2b00-81cedd3710cb
md"""A formula due to [Bhaskara I](http://tinyurl.com/k89ux5q) dates to around 650AD and gives a rational function approximation to the sine function. In degrees, we have
"""

# ╔═╡ 034d6bcc-53c2-11ec-138b-135b69817972
md"""```math
\sin(x^\circ) \approx \frac{4x(180-x)}{40500 - x(180-x)}, \quad 0 \leq x \leq 180.
```
"""

# ╔═╡ 034d6bf4-53c2-11ec-2b62-8d58c5ec65de
md"""Plot both functions over $[0, 180]$. What is the maximum difference between the two to two decimal points? (You may need to plot the difference of the functions to read off an approximate answer.)
"""

# ╔═╡ 034d7cbe-53c2-11ec-20f5-651d33e8fa6b
let
	numericq(.0015, .01)
end

# ╔═╡ 034d7cf0-53c2-11ec-37c9-a59ff76e7645
md"""###### Question
"""

# ╔═╡ 034d7d1a-53c2-11ec-00da-2d41b7b04600
md"""Solve the following equation for a value of $x$ using `acos`:
"""

# ╔═╡ 034d7d2e-53c2-11ec-04be-13cf3c48358b
md"""```math
\cos(x/3) = 1/3.
```
"""

# ╔═╡ 034d8362-53c2-11ec-2ae8-7be79cf78e78
let
	val = 3*acos(1/3)
	numericq(val)
end

# ╔═╡ 034d8382-53c2-11ec-3b6a-0170082fbb13
md"""###### Question
"""

# ╔═╡ 034d83aa-53c2-11ec-37c4-f1dc004844bf
md"""For any postive integer $n$ the equation $\cos(x) - nx = 0$ has a solution in $[0, \pi/2]$. Graphically estimate the value when $n=10$.
"""

# ╔═╡ 034d879a-53c2-11ec-2752-c7196ead6bb9
let
	val = 0.1
	numericq(val)
end

# ╔═╡ 034d885a-53c2-11ec-3668-9f983a5c0ac1
md"""###### Question
"""

# ╔═╡ 034d888c-53c2-11ec-3e0f-81b7ff9bcc6c
md"""The sine function is an *odd* function.
"""

# ╔═╡ 034d899a-53c2-11ec-301b-a3fb06f05db2
md"""  * The hyperbolic sine is:
"""

# ╔═╡ 034d900a-53c2-11ec-368b-654b0a5cf910
let
	choices = ["odd", "even", "neither"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d905c-53c2-11ec-0a72-3fb01d0bf9ec
md"""  * The hyperbolic cosine is:
"""

# ╔═╡ 034d9692-53c2-11ec-1cd1-47860b6b010c
let
	choices = ["odd", "even", "neither"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d96ce-53c2-11ec-3d61-df85e0f8e00a
md"""  * The hyperbolic tangent is:
"""

# ╔═╡ 034d9ce6-53c2-11ec-2ba3-7f264d34d717
let
	choices = ["odd", "even", "neither"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 034d9d0e-53c2-11ec-28b2-b37625ef6b50
md"""###### Question
"""

# ╔═╡ 034d9d24-53c2-11ec-22b8-8d41841aeeeb
md"""The hyperbolic sine satisfies this formula:
"""

# ╔═╡ 034d9d40-53c2-11ec-2d16-432443899363
md"""```math
\sinh(\theta + \beta) = \sinh(\theta)\cosh(\beta) + \sinh(\beta)\cosh(\theta).
```
"""

# ╔═╡ 034d9d4a-53c2-11ec-2e10-4163959f173d
md"""Is this identical to the pattern for the regular sine function?
"""

# ╔═╡ 034d9fe8-53c2-11ec-00ff-1b35b36237f9
let
	yesnoq(true)
end

# ╔═╡ 034da010-53c2-11ec-0644-c1171b61bbc7
md"""The hyperbolic cosine satisfies this formula:
"""

# ╔═╡ 034da02e-53c2-11ec-00ac-afc1120e4795
md"""```math
\cosh(\theta + \beta) = \cosh(\theta)\cosh(\beta) + \sinh(\beta)\sinh(\theta).
```
"""

# ╔═╡ 034da042-53c2-11ec-1431-ad682848326b
md"""Is this identical to the pattern for the regular sine function?
"""

# ╔═╡ 034da24a-53c2-11ec-3aa6-57ce11b71ba1
let
	yesnoq(false)
end

# ╔═╡ 034da272-53c2-11ec-3e89-5b8e5885bdc0
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/exp_log_functions.html">◅ previous</a>  <a href="../precalc/julia_overview.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/trig_functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 034da27c-53c2-11ec-0001-894a034695bf
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
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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
# ╟─034da254-53c2-11ec-3914-677331802fa7
# ╟─034c0f84-53c2-11ec-1cfb-0994d4ed6114
# ╟─034c0fb6-53c2-11ec-2b85-75a4cf08d9d6
# ╠═034c1524-53c2-11ec-306c-cd7c49e165d2
# ╟─034c2760-53c2-11ec-2cd5-853d04311ef5
# ╟─034c2794-53c2-11ec-32c0-6b216fbfa7ba
# ╟─034c27f8-53c2-11ec-1e40-635a82813551
# ╟─034c28c8-53c2-11ec-3059-c70fa732dc10
# ╟─034c28fc-53c2-11ec-1456-f73b553083cb
# ╟─034c293a-53c2-11ec-2e06-671f3d9206e5
# ╟─034c2956-53c2-11ec-07f8-4fb5ce812f3e
# ╟─034c2c9c-53c2-11ec-0835-ebbd23890e60
# ╟─034c2cb2-53c2-11ec-2c6e-29fefaf9c047
# ╟─034c2ce4-53c2-11ec-1c41-4bc68a3d71be
# ╟─034c352c-53c2-11ec-2fe0-fbe470e717cb
# ╟─034c3554-53c2-11ec-03b5-77a17b5f8410
# ╟─034c3590-53c2-11ec-1c49-032806f5509f
# ╟─034c39a0-53c2-11ec-2e41-172cf3707dc7
# ╟─034c39d2-53c2-11ec-0de4-0b05b9b321a5
# ╟─034c3a0e-53c2-11ec-17f3-03dcba259e40
# ╟─034c3a2c-53c2-11ec-208d-2111c680cc76
# ╟─034c3a40-53c2-11ec-3f40-1593c8877099
# ╟─034c3a54-53c2-11ec-1d59-df7611f4e273
# ╟─034c3a5e-53c2-11ec-0162-013d2e311ec6
# ╟─034c3be2-53c2-11ec-0760-6de5c35e74a5
# ╟─034c3bf8-53c2-11ec-1725-d7adb066fd3a
# ╟─034c3c20-53c2-11ec-0e21-6b5c432efc4f
# ╟─034c3c34-53c2-11ec-1b19-61d72a5df6f0
# ╟─034c3c5c-53c2-11ec-1728-65568ff4fd27
# ╠═034c585e-53c2-11ec-2b3a-49e560c6a5f7
# ╟─034c58cc-53c2-11ec-2207-61506209792c
# ╠═034c639e-53c2-11ec-1419-7b4badcd5242
# ╟─034c77f8-53c2-11ec-39d7-997e78430765
# ╟─034c7852-53c2-11ec-0733-550e1cf9911e
# ╟─034c78c0-53c2-11ec-0d61-b105140106b1
# ╠═034c811c-53c2-11ec-0ce8-d36818c2c35f
# ╟─034c8146-53c2-11ec-06f5-29629cc502e9
# ╟─034c8194-53c2-11ec-29f4-0168eda5dc52
# ╠═034c851a-53c2-11ec-25d4-3f58af5fa625
# ╟─034c855e-53c2-11ec-0ab3-4d6cdb766f1a
# ╠═034c87f2-53c2-11ec-0dc2-9d4487a840e6
# ╟─034c881c-53c2-11ec-3b11-571a634f613f
# ╠═034c8cc0-53c2-11ec-3077-ed9a8c0c085c
# ╟─034c8cd4-53c2-11ec-192a-ede567cc4836
# ╟─034c8cfc-53c2-11ec-0371-29be3473ca58
# ╟─034c8d4c-53c2-11ec-253e-f9746816f1ef
# ╠═034c8ffe-53c2-11ec-2476-dfc7fedbec74
# ╟─034c908c-53c2-11ec-382c-b7444dad315a
# ╟─034c910c-53c2-11ec-2b56-071c16680be7
# ╟─034c912a-53c2-11ec-0ee2-1161908238fe
# ╠═034c9990-53c2-11ec-17d8-3bfc18d5f945
# ╟─034c99ea-53c2-11ec-1457-fd321954372d
# ╟─034c9a12-53c2-11ec-2407-adbac3049411
# ╟─034c9a32-53c2-11ec-223f-83b3b9d48711
# ╟─034c9f62-53c2-11ec-3236-81509d301db0
# ╟─034c9fb2-53c2-11ec-37d6-33a5c547c666
# ╟─034c9fee-53c2-11ec-168e-a5f7b86d8495
# ╟─034ca02a-53c2-11ec-37b0-a1cf52dd8008
# ╟─034ca070-53c2-11ec-2f4d-59c8b62dc102
# ╟─034ca0a4-53c2-11ec-0aff-73429f64e2fc
# ╟─034ca0d6-53c2-11ec-1211-abdf138897f3
# ╟─034ca0f2-53c2-11ec-2688-c168478c6df8
# ╟─034ca124-53c2-11ec-3b88-510434990f78
# ╟─034ca142-53c2-11ec-079c-f33eb5fb54ff
# ╟─034ca426-53c2-11ec-04ec-4b2f397db67e
# ╟─034ca4dc-53c2-11ec-2abb-a5d1588e3873
# ╟─034ca4ee-53c2-11ec-17b2-89858235e405
# ╟─034ca584-53c2-11ec-2708-8be8fdf596c2
# ╟─034ca5b6-53c2-11ec-0b78-7377559dee17
# ╟─034ca5c0-53c2-11ec-35ae-2bf4bbbe11b2
# ╟─034ca5d4-53c2-11ec-0080-8d8f4aa6766c
# ╟─034ca5f2-53c2-11ec-37d9-87c38abc11c1
# ╟─034ca612-53c2-11ec-0198-c1249878dc11
# ╟─034ca638-53c2-11ec-0f30-b73dc06cae63
# ╟─034ca656-53c2-11ec-23be-9d7435d9a20c
# ╟─034ca66a-53c2-11ec-20bf-1dc0b1a2e898
# ╟─034ca6d6-53c2-11ec-2377-ef7506eaf647
# ╟─034ca6ec-53c2-11ec-2262-01b53e557bb0
# ╟─034ca71e-53c2-11ec-17e1-bdfd2c6818dc
# ╟─034ca7a0-53c2-11ec-1a92-ff139929a971
# ╟─034ca7e6-53c2-11ec-0328-e93c2b50dd35
# ╟─034cab9c-53c2-11ec-2921-2bcc36075f2c
# ╟─034cad40-53c2-11ec-38fc-ff529a0bf736
# ╠═034cb25e-53c2-11ec-2508-6b2604898290
# ╟─034cb29a-53c2-11ec-1af6-fb9ccd72c6ed
# ╠═034cb8ee-53c2-11ec-1ba1-f919dd2db1fe
# ╟─034cb952-53c2-11ec-2ac2-2f6605b31d99
# ╟─034cb990-53c2-11ec-2892-edac399859b4
# ╟─034cb9be-53c2-11ec-013c-f54c84b220be
# ╟─034cb9f0-53c2-11ec-309c-f1af929285be
# ╟─034cbb14-53c2-11ec-106b-af26b7605e7f
# ╟─034cbb3c-53c2-11ec-37a2-9de430e5fc9b
# ╠═034cc370-53c2-11ec-1128-a9582b01086e
# ╟─034cc396-53c2-11ec-3b82-b1d8ed9b0d1f
# ╠═034cc618-53c2-11ec-185f-dd07a437e2dd
# ╟─034cc654-53c2-11ec-26a5-dd45d6ad4967
# ╟─034cc6c2-53c2-11ec-054a-dbb125c1fc90
# ╟─034cc6fe-53c2-11ec-18dc-f1e31208e0ad
# ╟─034cc730-53c2-11ec-1252-793e52938d43
# ╟─034cc74e-53c2-11ec-1fbf-af46662395eb
# ╠═034cd004-53c2-11ec-11d3-b3d2ac916b9d
# ╟─034cd05e-53c2-11ec-0e95-0908b46bab36
# ╟─034cd0f4-53c2-11ec-11a2-d98c509e33a5
# ╠═034cdc2a-53c2-11ec-2b3b-d9dffb71e5a1
# ╟─034cdc48-53c2-11ec-1d44-3f9ad087bb74
# ╟─034cdc5c-53c2-11ec-2d1a-a73ffef7faa7
# ╟─034cf430-53c2-11ec-0c82-35de091ed365
# ╟─034cf480-53c2-11ec-0363-8fb089afda9b
# ╟─034cf4d0-53c2-11ec-3b8f-8161e8124ad6
# ╠═034cfb6a-53c2-11ec-1886-5d8a8ae7fb96
# ╟─034cfba6-53c2-11ec-2602-039b00791b90
# ╠═034cfdec-53c2-11ec-1370-8518c530fe6c
# ╟─034cfe12-53c2-11ec-2218-83c3a399d50b
# ╟─034cfe26-53c2-11ec-06a7-a9f88efdf8d3
# ╟─034cfe50-53c2-11ec-00a8-0bc7dd332cdb
# ╟─034cfe62-53c2-11ec-1c25-d19ae86b2982
# ╟─034cfe7e-53c2-11ec-0597-13bed17d3a97
# ╟─034cfe8a-53c2-11ec-0b22-5903344fbca1
# ╟─034cfeb0-53c2-11ec-1a00-c53b689b468d
# ╟─034cfebc-53c2-11ec-311f-8bd3af65a463
# ╟─034cffe6-53c2-11ec-31f0-0da66e05a2bc
# ╟─034d0006-53c2-11ec-1b40-ab882bb02aff
# ╠═034d09be-53c2-11ec-1b8d-97de1ed2e2a5
# ╟─034d09fc-53c2-11ec-3afa-bf864bf88af1
# ╟─034d0a24-53c2-11ec-0170-21778b8744e4
# ╟─034d0a42-53c2-11ec-0a3a-c95100a8ff2b
# ╟─034d0a56-53c2-11ec-2e50-2f339bc761e3
# ╠═034d18fc-53c2-11ec-3290-2bf5aac6cb39
# ╟─034d191a-53c2-11ec-10bb-e3445b16c382
# ╠═034d248c-53c2-11ec-3689-a722a4b68b71
# ╟─034d24aa-53c2-11ec-3ea3-df1d895c2155
# ╟─034d2504-53c2-11ec-107c-e559295e607f
# ╟─034d254a-53c2-11ec-022a-83fb4092f788
# ╟─034d32ba-53c2-11ec-2c53-cfec9dc9bb9b
# ╟─034d3346-53c2-11ec-1a85-998ed67d61ba
# ╟─034d42ac-53c2-11ec-3b87-c989d519a57d
# ╟─034d42e6-53c2-11ec-0a9d-f54a978b548b
# ╟─034d433e-53c2-11ec-1d26-37823ef520f2
# ╟─034d4a5c-53c2-11ec-08d0-518c76a91e7e
# ╟─034d4a70-53c2-11ec-2798-7521872ca0b9
# ╟─034d4a8e-53c2-11ec-30fd-719237f64617
# ╟─034d4aac-53c2-11ec-00f8-6d4ae61c90c8
# ╟─034d4aca-53c2-11ec-376f-3bb90fb4047c
# ╟─034d4af2-53c2-11ec-3174-b72c0190484f
# ╟─034d4b1c-53c2-11ec-1541-fb2f0d2b523a
# ╟─034d4b38-53c2-11ec-39eb-efa280667d4c
# ╟─034d511c-53c2-11ec-03ba-431f21d2c084
# ╟─034d5132-53c2-11ec-2452-a35cf8d13012
# ╟─034d51b4-53c2-11ec-3087-918aeffa2557
# ╟─034d5594-53c2-11ec-1fc2-e5b9434e1538
# ╟─034d55a6-53c2-11ec-1643-676fc336f048
# ╟─034d55ba-53c2-11ec-3dc4-4f24b0360f69
# ╟─034d5e84-53c2-11ec-0fc7-6bb14470ac97
# ╟─034d5e96-53c2-11ec-2b9a-fd4d53191004
# ╟─034d5eac-53c2-11ec-2c32-533e304abd8b
# ╟─034d6b4a-53c2-11ec-207e-8dec68fc3857
# ╟─034d6b72-53c2-11ec-0463-29269ecb6982
# ╟─034d6ba4-53c2-11ec-2b00-81cedd3710cb
# ╟─034d6bcc-53c2-11ec-138b-135b69817972
# ╟─034d6bf4-53c2-11ec-2b62-8d58c5ec65de
# ╟─034d7cbe-53c2-11ec-20f5-651d33e8fa6b
# ╟─034d7cf0-53c2-11ec-37c9-a59ff76e7645
# ╟─034d7d1a-53c2-11ec-00da-2d41b7b04600
# ╟─034d7d2e-53c2-11ec-04be-13cf3c48358b
# ╟─034d8362-53c2-11ec-2ae8-7be79cf78e78
# ╟─034d8382-53c2-11ec-3b6a-0170082fbb13
# ╟─034d83aa-53c2-11ec-37c4-f1dc004844bf
# ╟─034d879a-53c2-11ec-2752-c7196ead6bb9
# ╟─034d885a-53c2-11ec-3668-9f983a5c0ac1
# ╟─034d888c-53c2-11ec-3e0f-81b7ff9bcc6c
# ╟─034d899a-53c2-11ec-301b-a3fb06f05db2
# ╟─034d900a-53c2-11ec-368b-654b0a5cf910
# ╟─034d905c-53c2-11ec-0a72-3fb01d0bf9ec
# ╟─034d9692-53c2-11ec-1cd1-47860b6b010c
# ╟─034d96ce-53c2-11ec-3d61-df85e0f8e00a
# ╟─034d9ce6-53c2-11ec-2ba3-7f264d34d717
# ╟─034d9d0e-53c2-11ec-28b2-b37625ef6b50
# ╟─034d9d24-53c2-11ec-22b8-8d41841aeeeb
# ╟─034d9d40-53c2-11ec-2d16-432443899363
# ╟─034d9d4a-53c2-11ec-2e10-4163959f173d
# ╟─034d9fe8-53c2-11ec-00ff-1b35b36237f9
# ╟─034da010-53c2-11ec-0644-c1171b61bbc7
# ╟─034da02e-53c2-11ec-00ac-afc1120e4795
# ╟─034da042-53c2-11ec-1431-ad682848326b
# ╟─034da24a-53c2-11ec-3aa6-57ce11b71ba1
# ╟─034da272-53c2-11ec-3e89-5b8e5885bdc0
# ╟─034da272-53c2-11ec-099a-4f11cd94b39f
# ╟─034da27c-53c2-11ec-0001-894a034695bf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
