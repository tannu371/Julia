### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ b4eaacda-548c-11ec-18cb-07d903e1fbec
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ b4eab2f2-548c-11ec-0a3e-7fc343ece080
begin
	using CalculusWithJulia.WeaveSupport
	using DataFrames
	import PyPlot
	pyplot()
	fig_size=(600, 400)
	
	nothing
end

# ╔═╡ b51dff90-548c-11ec-1484-a710322fa338
using PlutoUI

# ╔═╡ b51dff6a-548c-11ec-2e7b-7d31ca2a8cc0
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ b4d25860-548c-11ec-25e9-2fa6558c2ccf
md"""# Derivatives
"""

# ╔═╡ b4d4803e-548c-11ec-29d7-975d2593b2f7
md"""This section uses these add-on packages:
"""

# ╔═╡ b4ec7c36-548c-11ec-1476-27331b19e2b9
md"""---
"""

# ╔═╡ b4ec7cb8-548c-11ec-02de-b303b97f7199
md"""Before defining the derivative of a function, let's begin with two motivating examples.
"""

# ╔═╡ b4eefbde-548c-11ec-1de5-e573fc987622
md"""##### Example: Driving
"""

# ╔═╡ b4eefc36-548c-11ec-2003-b74977c6b5b5
md"""Imagine motoring along down highway 61 leaving Minnesota on the way to New Orleans; though lost in listening to music, still mindful of the speedometer and odometer, both prominently placed on the dashboard of the car.
"""

# ╔═╡ b4f1c5ec-548c-11ec-1759-150d07287427
md"""The speedometer reads $60$ miles per hour, what is the odometer doing? Besides recording total distance traveled, it is incrementing dutifully every hour by $60$ miles. Why? Well, the well-known formula relating distance, time and rate of travel is
"""

# ╔═╡ b4f3a838-548c-11ec-36ef-590935ead43c
md"""```math
\text{distance} = \text{ rate } \times \text{ time.}
```
"""

# ╔═╡ b4f3a8d0-548c-11ec-2cc1-2d555f5be72d
md"""If the rate is a constant $60$ miles/hour, then in one hour the distance traveled is $60$ miles.
"""

# ╔═╡ b4f3a8ee-548c-11ec-12dc-6b4bc653339c
md"""Of course, the odometer isn't just incrementing once per hour, it is incrementing once every $1/10$th of a mile. How much time does that take? Well, we would need to solve $1/10=60 \cdot t$ which means $t=1/600$ hours, better known as once every 6 seconds.
"""

# ╔═╡ b4f3a90e-548c-11ec-033f-a38c14b34f3a
md"""Using some mathematical notation, would give $x(t) = v\cdot t$, where $x$ is position at time $t$, $v$ is the velocity and $t$ the time traveled in hours. A simple graph of the first three hours of travel would show:
"""

# ╔═╡ b4f3b03c-548c-11ec-0a05-13238a7b1b26
let
	position(t) = 60 * t
	plot(position, 0, 3)
end

# ╔═╡ b4f672d6-548c-11ec-2bb6-c12d009c52b8
md"""Oh no, we hit traffic. In the next 30 minutes we only traveled 15 miles. We were so busy looking out for traffic, the speedometer was not checked. What would the average speed have been? Though in the 30 minutes of stop-and-go traffic, the displayed speed may have varied, the *average speed* would simply be the change in distance over the change in time, or $\Delta x / \Delta t$. That is
"""

# ╔═╡ b4f678da-548c-11ec-1954-3976c8a7047a
15/(1/2)

# ╔═╡ b4f679e8-548c-11ec-1193-77a3606b06e5
md"""Now suppose that after $6$ hours of travel the GPS in the car gives us a readout of distance traveled as a function of time. The graph looks like this:
"""

# ╔═╡ b4f690a4-548c-11ec-0712-3d15907e6ee4
let
	function position(t)
	    t <= 3   ? 60*t :
	    t <= 3.5 ? position(3) + 30*(t-3) :
	    t <= 4   ? position(3.5) + 75 * (t-3.5) :
	    t <= 4.5 ? position(4) : position(4.5) + 60*(t-4.5)
	end
	plot(position, 0, 6)
end

# ╔═╡ b4f690de-548c-11ec-09c3-efcc57264cca
md"""We can see with some effort that the slope is steady for the first three hours, is slightly less between $3$ and $3.5$ hours, then is a bit steeper for the next half hour. After that, it is flat for the about half an hour, then the slope continues on with same value as in the first 3 hours. What does that say about our speed during our trip?
"""

# ╔═╡ b4f690f4-548c-11ec-0f98-0398b14e400e
md"""Based on the graph, what was the average speed over the first three hours? Well, we traveled 180 miles, and took 3 hours:
"""

# ╔═╡ b4f692a2-548c-11ec-3f50-6b385582b388
180/3

# ╔═╡ b4f692c0-548c-11ec-04e4-595aec80cd6d
md"""What about the next half hour? Squinting shows the amount traveled was 15 miles (195 - 180) and it took 1/2 an hour:
"""

# ╔═╡ b4f6952c-548c-11ec-2467-2fc82540813d
15/(1/2)

# ╔═╡ b4f69540-548c-11ec-19b0-bf39be188b6b
md"""And the half hour after that? The average speed is found from the distance traveled, 37.5 miles, divided by the time, 1/2 hour:
"""

# ╔═╡ b4f697b4-548c-11ec-1981-dda5b1b962d4
37.5 / (1/2)

# ╔═╡ b4f697d4-548c-11ec-2fd4-49e201ef25de
md"""Okay, so there was some speeding involved.
"""

# ╔═╡ b4f697e6-548c-11ec-2cc8-333b362a3cc6
md"""The next half hour the car did not move. What was the average speed? Well the change in position was 0, but the time was 1/2 hour, so the average was 0.
"""

# ╔═╡ b4f697f2-548c-11ec-253b-6b858aeea214
md"""Perhaps a graph of the speed is a bit more clear. We can do this based on the above:
"""

# ╔═╡ b4f6a382-548c-11ec-2026-9f221cd7e722
begin
	function speed(t)
	    0 < t <= 3  ? 60  :
	        t <= 3.5 ? 30 :
	        t <= 4   ? 75 :
	        t <= 4.5 ? 0  : 60
	end
	plot(speed, 0, 6)
end

# ╔═╡ b4fea76c-548c-11ec-2848-85d8989b9ec9
md"""The jumps, as discussed before, are artifacts of the graphing algorithm. What is interesting, is we could have derived the graph of `speed` from that of `x` by just finding the slopes of the line segments, and we could have derived the graph of `x` from that of `speed`, just using the simple formula relating distance, rate, and time.
"""

# ╔═╡ b4fec0ee-548c-11ec-084d-6f400e56ffc3
note("""

We were pretty loose with some key terms. There is a distinction
between "speed" and "velocity", this being the speed is the absolute
value of velocity. Velocity incorporates a direction as well as a
magnitude. Similarly, distance traveled and change in position are not
the same thing when there is back tracking involved. The total
distance traveled is computed with the speed, the change in position
is computed with the velocity. When there is no change of sign, it is
a bit more natural, perhaps, to use the language of speed and
distance.

""")

# ╔═╡ b4fec166-548c-11ec-1ff8-e7d77dcae5e5
md"""##### Example: Galileo's ball and ramp experiment
"""

# ╔═╡ b50075a6-548c-11ec-3d5d-2191ebd4a4a3
md"""One of history's most famous experiments was performed by [Galileo](http://en.wikipedia.org/wiki/History_of_experiments) where he rolled balls down inclined ramps, making note of distance traveled with respect to time. As Galileo had no ultra-accurate measuring device, he needed to slow movement down by controlling the angle of the ramp. With this, he could measure units of distance per units of time. (Click through to *Galileo and Perspective* [Dauben](http://www.mcm.edu/academic/galileo/ars/arshtml/mathofmotion1.html).)
"""

# ╔═╡ b500761e-548c-11ec-151f-c71ceab55703
md"""Suppose that no matter what the incline was, Galileo observed that in units of the distance traveled in the first second that the distance traveled between subsequent seconds was $3$ times, then $5$ times, then $7$ times, ... This table summarizes.
"""

# ╔═╡ b5007d4e-548c-11ec-2c8a-59e1a372cb72
let
	ts = [0,1,2,3,4,5]
	dxs = [0,1,3, 5, 7, 9]
	ds = [0,1,4,9,16,25]
	d = DataFrame(t=ts, delta=dxs, distance=ds)
	table(d)
end

# ╔═╡ b5007d76-548c-11ec-3df5-4d8e12c90aa1
md"""A graph of distance versus time could be found by interpolating between the measured points:
"""

# ╔═╡ b50081ea-548c-11ec-0802-0d6de9dfc630
begin
	ts = [0,1,2,3,4, 5]
	xs = [0,1,4,9,16,25]
	plot(ts, xs)
end

# ╔═╡ b50081fe-548c-11ec-2b5e-219ce834959a
md"""The graph looks almost quadratic. What would the following questions have yielded?
"""

# ╔═╡ b509bad2-548c-11ec-15f4-814ddc08d47c
md"""  * What is the average speed between $0$ and $3$?
"""

# ╔═╡ b509c124-548c-11ec-04f1-734cf92df0f9
(9-0) / (3-0)  # (xs[4] - xs[1]) / (ts[4] - ts[1])

# ╔═╡ b509c1ec-548c-11ec-2993-6b243d471bf8
md"""  * What is the average speed between $2$ and $3$?
"""

# ╔═╡ b509c5ae-548c-11ec-3c3a-3f6da113ef9c
(9-4) / (3-2)  # (xs[4] - xs[3]) / (ts[4] - ts[3])

# ╔═╡ b509c5e8-548c-11ec-2376-8f210b8aae4c
md"""From the graph, we can tell that the slope of the line connecting $(2,4)$ and $(3,9)$ will be greater than that connecting $(0,0)$ and $(3,9)$. In fact, given the shape of the graph (concave up), the line connecting $(0,0)$ with any point will have a slope less than or equal to any of the line segments.
"""

# ╔═╡ b509c5fc-548c-11ec-0f44-812e938c18ba
md"""The average speed between $k$ and $k+1$ for this graph is:
"""

# ╔═╡ b509cc96-548c-11ec-3b63-597da2d567ef
xs[2]-xs[1], xs[3] - xs[2], xs[4] - xs[3], xs[5] - xs[4]

# ╔═╡ b509ccbe-548c-11ec-1b18-e394f46aa852
md"""We see it increments by $2$. The acceleration is the rate of change of speed. We see the rate of change of speed is constant, as the speed increments by 2 each time unit.
"""

# ╔═╡ b509ccc8-548c-11ec-2d8c-af78c0d730cb
md"""Based on this - and given Galileo's insight - it appears the acceleration will be a constant and the position as a function of time will be quadratic.
"""

# ╔═╡ b50c58a6-548c-11ec-0f9e-ffee2169a922
md"""## The slope of the secant line
"""

# ╔═╡ b50c5934-548c-11ec-335a-17e9548c55bf
md"""In the above examples, we see that the average speed is computed using the slope formula. This can be generalized for any univariate function $f(x)$:
"""

# ╔═╡ b50f892e-548c-11ec-1198-6f3f670184cb
md"""> The average rate of change between $a$ and $b$ is $(f(b) - f(a)) / (b - a)$. It is typical to express this as $\Delta y/ \Delta x$, where $\Delta$ means "change".

"""

# ╔═╡ b50f89a6-548c-11ec-2888-1721bddeeed0
md"""Geometrically, this is the slope of the line connecting the points $(a, f(a))$ and $(b, f(b))$. This line is called a [secant](http://en.wikipedia.org/wiki/Secant_line) line, which is just a line intersecting two specified points on a curve.
"""

# ╔═╡ b50f89c4-548c-11ec-3d64-8768613fd47c
md"""Rather than parameterize this problem using $a$ and $b$, we let $c$ and $c+h$ represent the two values for $x$, then the secant-line-slope formula becomes
"""

# ╔═╡ b50f8a00-548c-11ec-2ee6-7f823da7af83
md"""```math
m = \frac{f(c+h) - f(c)}{h}.
```
"""

# ╔═╡ b50f8a1e-548c-11ec-1b37-77868bb8187f
md"""## The slope of the tangent line
"""

# ╔═╡ b50f8a46-548c-11ec-0a69-cb0a97538eeb
md"""The slope of the secant line represents the average rate of change over a given period, $h$. What if this rate is so variable, that it makes sense to take smaller and smaller periods $h$? In fact, what if $h$ goes to $0$?
"""

# ╔═╡ b50fc286-548c-11ec-3151-7d902863157c
let
	function secant_line_tangent_line_graph(n)
	    f(x) = sin(x)
	    c = pi/3
	    h = 2.0^(-n) * pi/4
	    m = (f(c+h) - f(c))/h
	
	    xs = range(0, stop=pi, length=50)
	    plt = plot(f, 0, pi, legend=false, size=fig_size)
	    plot!(plt, xs, f(c) .+ cos(c)*(xs .- c), color=:orange)
	    plot!(plt, xs, f(c) .+ m*(xs .- c), color=:black)
	    scatter!(plt, [c,c+h], [f(c), f(c+h)], color=:orange, markersize=5)
	
	    plot!(plt, [c, c+h, c+h], [f(c), f(c), f(c+h)], color=:gray30)
	    annotate!(plt, [(c+h/2, f(c), text("h", :top)), (c + h + .05, (f(c) + f(c + h))/2, text("f(c+h) - f(c)", :left))])
	
	    plt
	end
	caption = L"""
	
	The slope of each secant line represents the *average* rate of change between $c$ and $c+h$. As $h$ goes towards $0$, we recover the slope of the tangent line, which represents the *instantatneous* rate of change.
	
	"""
	
	
	
	n = 5
	anim = @animate for i=0:n
	    secant_line_tangent_line_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ b50fc2ce-548c-11ec-1cb3-d361e0ab1ad1
md"""The graphic suggests that the slopes of the secant line converge to the slope of a "tangent" line. That is, for a given $c$, this limit exists:
"""

# ╔═╡ b50fc2ea-548c-11ec-0e5e-295ebb3194b7
md"""```math
\lim_{h \rightarrow 0} \frac{f(c+h) - f(c)}{h}.
```
"""

# ╔═╡ b50fc300-548c-11ec-2748-d37f1c9bd3ba
md"""We will define the tangent line at $(c, f(c))$ to be the line through the point with the slope from the limit above - provided that limit exists. Informally, the tangent line is the line through the point that best approximates the function.
"""

# ╔═╡ b50fe298-548c-11ec-11d9-af64d8b8ac17
let
	function line_approx_fn_graph(n)
	    f(x) = sin(x)
	    c = pi/3
	    h = round(2.0^(-n) * pi/2, digits=2)
	    m = cos(c)
	
	    Delta = max(f(c) - f(c-h), f(min(c+h, pi/2)) - f(c))
	
	    p = plot(f, c-h, c+h, legend=false, xlims=(c-h,c+h), ylims=(f(c)-Delta,f(c)+Delta ))
	    plot!(p, x -> f(c) + m*(x-c))
	    scatter!(p, [c], [f(c)])
	    p
	end
	caption = L"""
	
	The tangent line is the best linear approximation to the function at the point $(c, f(c))$. As the viewing window zooms in on $(c,f(c))$ we
	    can see how the graph and its tangent line get more similar.
	
	"""
	
	pyplot()
	n = 6
	anim = @animate for i=1:n
	    line_approx_fn_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ b50fe2b6-548c-11ec-01f6-fd49c4441099
md"""The tangent line is not just a line that intersects the graph in one point, nor does it need only intersect the line in just one point.
"""

# ╔═╡ b50ff044-548c-11ec-1544-1bebafc332c5
note("""
This last point was certainly not obvious at
first. [Barrow](http://www.maa.org/sites/default/files/0746834234133.di020795.02p0640b.pdf),
who had Newton as a pupil and was the first to sketch a proof of part
of the Fundamental Theorem of Calculus, understood a tangent line to
be a line that intersects a curve at only one point.
""")

# ╔═╡ b50ff080-548c-11ec-386a-33f4ef510c06
md"""##### Example
"""

# ╔═╡ b50ff0a8-548c-11ec-18fc-8bc811c44725
md"""What is the slope of the tangent line to $f(x) = \sin(x)$ at $c=0$?
"""

# ╔═╡ b50ff0c6-548c-11ec-32ad-674239d21bef
md"""We need to compute the limit $(\sin(c+h) - \sin(c))/h$ which is the limit as $h$ goes to $0$ of $\sin(h)/h$. We know this to be 1.
"""

# ╔═╡ b50ff422-548c-11ec-3df6-892da7f33139
let
	f(x) = sin(x)
	c = 0
	tl(x) = f(c) + 1 * (x - c)
	plot(f, -pi/2, pi/2)
	plot!(tl, -pi/2, pi/2)
end

# ╔═╡ b50ff442-548c-11ec-1898-95b4c7d036bf
md"""## The derivative
"""

# ╔═╡ b50ff486-548c-11ec-217f-a50f047a1eb7
md"""The limit of the slope of the secant line gives an operation: for each $c$ in the domain of $f$ there is a number (the slope of the tangent line) or it does not exist. That is, there is a derived function from $f$. Call this function the *derivative* of $f$. There are many notations for the derivative, here we use the "prime" notation:
"""

# ╔═╡ b50ff49a-548c-11ec-0318-43441913f313
md"""```math
f'(x) = \lim_{h \rightarrow 0} \frac{f(x+h) - f(x)}{h}.
```
"""

# ╔═╡ b50ff4ae-548c-11ec-33da-211850d457c8
md"""The limit above is identical, only it uses $x$ instead of $c$ to emphasize that we are thinking of a function now, and not just a value at a point.
"""

# ╔═╡ b50ff4c2-548c-11ec-0fec-cff2f3458816
md"""The derivative is related to a function, but at times it is more convenient to write only the expression defining the rule of the function. In that case, we use this notation for the derivative $[\text{expression}]'$.
"""

# ╔═╡ b51273b4-548c-11ec-0cef-e13683f485a9
md"""### Some basic derivatives
"""

# ╔═╡ b513fe82-548c-11ec-309d-49416d5871fb
md"""  * **The power rule**. What is the derivative of the monomial $f(x) = x^n$? We need to look at $(x+h)^n - x^n$ for positive, integer-value $n$. Let's look at a case, $n=5$
"""

# ╔═╡ b51405ce-548c-11ec-39f8-cd53d22bd478
begin
	@syms x::real h::real
	n = 5
	ex = expand((x+h)^n - x^n)
end

# ╔═╡ b5140632-548c-11ec-3a47-1f33ea7fc4dd
md"""All terms have an `h` in them, so we cancel it out:
"""

# ╔═╡ b514089e-548c-11ec-10f2-499aeaa37862
cancel(ex/h, h)

# ╔═╡ b51408dc-548c-11ec-1326-8f35ccb0b21f
md"""We see the lone term `5x^4` without an $h$, so as we let $h$ go to $0$, this will be the limit. That is, $f'(x) = 5x^4$.
"""

# ╔═╡ b5140918-548c-11ec-30f3-7d51c1335220
md"""For  integer-valued, positive, $n$, the binomial theorem gives an expansion $(x+h)^n = x^n + nx^{n-1}\cdot h^1 + n\cdot(n-1)x^{n-2}\cdot h^2 + \cdots$. Subtracting $x^n$ then dividing by $h$ leaves just the term $nx^{n-1}$ without a power of $h$, so the limit, in general, is just this term. That is $[x^n]' = nx^{n-1}$.
"""

# ╔═╡ b5140936-548c-11ec-111b-0b8863f11123
md"""It isn't a special case, but when $n=0$, we also have the above formula applies, as $x^0$ is the constant $1$, and all constant functions will have a derivative of $0$ at all $x$. We will see that in general, the power rule applies for any $n$ where $x^n$ is defined.
"""

# ╔═╡ b51409d4-548c-11ec-10d3-bd53ff7416bd
md"""  * What is the derivative of $f(x) = \sin(x)$? We know that $f'(0)= 1$ by an earlier example ($(\sin(0+h)-\sin(0))/h = \sin(h)/h$), here we solve in general.
"""

# ╔═╡ b51409ea-548c-11ec-3f1e-d99cf3208d76
md"""We need to consider the difference $\sin(x+h) - \sin(x)$:
"""

# ╔═╡ b5140db4-548c-11ec-3ffe-e9c11a5d84c2
sympy.expand_trig(sin(x+h) - sin(x))  # expand_trig is not exposed in `SymPy`

# ╔═╡ b5140dde-548c-11ec-3fe1-5958c0f4e6cd
md"""That used the formula $\sin(x+h) = \sin(x)\cos(h) + \sin(h)\cos(x)$.
"""

# ╔═╡ b5140de6-548c-11ec-1f3f-e3c482bf36e2
md"""We could then rearrange the secant line slope formula to become:
"""

# ╔═╡ b5140e0c-548c-11ec-19d9-91a0019bebcb
md"""```math
\cos(x) \cdot \frac{\sin(h)}{h} + \sin(x) \cdot \frac{\cos(h) - 1}{h}
```
"""

# ╔═╡ b5140e36-548c-11ec-1035-073b29ddde22
md"""and take a limit. If the answer isn't clear, we can let `SymPy` do this work:
"""

# ╔═╡ b5141336-548c-11ec-2d3b-dd2d2f74b94b
limit((sin(x+h) - sin(x))/ h, h => 0)

# ╔═╡ b5141372-548c-11ec-359f-b30385f2984b
md"""From the formula $[\sin(x)]' = \cos(x)$ we can easily get the *slope* of the tangent line to $f(x) = \sin(x)$ at $x=0$ by simply evaluation $\cos(0) = 1$.
"""

# ╔═╡ b51413cc-548c-11ec-1632-f9e387e71bc8
md"""  * Let's see what the derivative of $\ln(x) = \log(x)$ is (using base $e$ for $\log$ unless otherwise indicated). We have
"""

# ╔═╡ b51413de-548c-11ec-2b29-6d6dac447ae6
md"""```math
\frac{\log(x+h) - \log(x)}{h} = \frac{1}{h}\log(\frac{x+h}{x}) = \log((1+h/x)^{1/h}).
```
"""

# ╔═╡ b5141412-548c-11ec-178f-2d707e9cbcba
md"""As noted earlier, Cauchy saw the limit as $u$ goes to $0$ of $f(u) = (1 + u)^{1/u}$ is $e$. Re-expressing the above we can get $1/x \cdot \log(f(h/x))$. The limit as $h$ goes to $0$ of this is found from the composition rules for limits: as $\lim_{h \rightarrow 0} f(h/x) = e$, and since $\log(e)$ is continuous at $1$ we get this expression has a limit of $1/x$.
"""

# ╔═╡ b514141c-548c-11ec-2032-2faf25d3eb36
md"""We verify through:
"""

# ╔═╡ b51418cc-548c-11ec-2967-5557b182dd91
limit((log(x+h) - log(x))/h, h => 0)

# ╔═╡ b514191a-548c-11ec-1cc8-0b41b0535e53
md"""  * The derivative of $f(x) = e^x$ can also be done from a limit. We have
"""

# ╔═╡ b5141930-548c-11ec-0036-f18950c185d3
md"""```math
\frac{e^{x+h} - e^x}{h} = \frac{e^x \cdot(e^h -1)}{h}.
```
"""

# ╔═╡ b514194c-548c-11ec-2f7e-eb0611ba712a
md"""Earlier,  we saw that $\lim_{h \rightarrow 0}(e^h - 1)/h = 1$. With this, we get $[e^x]' = e^x$, that is it is a function satisfying $f'=f$.
"""

# ╔═╡ b514196c-548c-11ec-0754-156e0d6c811e
md"""---
"""

# ╔═╡ b51419a8-548c-11ec-2087-4f873508155e
md"""There are several different [notations](http://en.wikipedia.org/wiki/Notation_for_differentiation) for derivatives. Some are historical, some just add flexibility. We use the prime notation of Lagrange: $f'(x)$, $u'$ and $[\text{expr}]'$, where the first emphasizes that the derivative is a function with a value at $x$, the second emphasizes the derivative operates on functions, the last emphasize that we are taking the derivative of some expression.
"""

# ╔═╡ b51419b2-548c-11ec-06a7-cbba94e70079
md"""There are many other notations:
"""

# ╔═╡ b5141a0c-548c-11ec-3f11-4da6f589e862
md"""  * The Leibniz notation uses the infinitesimals: $dy/dx$ to relate to $\Delta y/\Delta x$. This notation is very common, and especially useful when more than one variable is involved.  `SymPy` uses Leibniz notation in some of its output, expressing somethings such as:
"""

# ╔═╡ b5141a22-548c-11ec-33f9-97bb3762d7ef
md"""```math
f'(x) = \frac{d}{d\xi}(f(\xi)) \big|_{\xi=x}.
```
"""

# ╔═╡ b5141a34-548c-11ec-1329-5f19013d73ca
md"""The notation - $\big|$ - on the right-hand side separates the tasks of finding the   derivative and evaluating the derivative at a specific value.
"""

# ╔═╡ b5141aac-548c-11ec-316a-613608ffa8ca
md"""  * Euler used `D` for the operator `D(f)`. This was initially used by [Argobast](http://jeff560.tripod.com/calculus.html).
  * Newton used a "dot" above the variable, $\dot{x}(t)$, which is still widely used in physics to indicate  a derivative in time.
"""

# ╔═╡ b5141ad4-548c-11ec-01f0-35ef9a4dca7b
md"""## Rules of derivatives
"""

# ╔═╡ b514f09c-548c-11ec-01fb-558e59177b2e
md"""We could proceed in a similar manner – using limits to find other derivatives, but let's not. If we have a function $f(x) = x^5 \sin(x)$, it would be nice to leverage our previous work on the derivatives of $f(x) =x^5$ and $g(x) = \sin(x)$, rather than derive an answer from scratch.
"""

# ╔═╡ b514f10e-548c-11ec-242b-c541ad3c8ce4
md"""As with limits and continuity, it proves very useful to consider rules that make the process of finding derivatives of combinations of functions a matter of combining derivatives of the individual functions in some manner.
"""

# ╔═╡ b514f116-548c-11ec-258b-9d30dcf8b369
md"""We already have one such rule:
"""

# ╔═╡ b514f15c-548c-11ec-1cbb-fd39b35e2e20
md"""### The power rule
"""

# ╔═╡ b514f17a-548c-11ec-1cac-d35664b870ea
md"""We have seen for integer $n \geq 0$ the formula:
"""

# ╔═╡ b514f198-548c-11ec-1fdc-e583c5d4b41e
md"""```math
[x^n]' = n x^{n-1}.
```
"""

# ╔═╡ b514f1b6-548c-11ec-049c-0503d6a631c8
md"""This will be shown true for all real exponents.
"""

# ╔═╡ b514f1c0-548c-11ec-33ea-91bd7f00cabc
md"""### Sum rule
"""

# ╔═╡ b514f1de-548c-11ec-2a6c-0373d4adc884
md"""Let's consider $k(x) = a\cdot f(x) + b\cdot g(x)$, what is its derivative? That is, in terms of $f$, $g$ and their derivatives, can we express $k'(x)$?
"""

# ╔═╡ b514f1e8-548c-11ec-0185-c7c49523cb31
md"""We can rearrange $(k(x+h) - k(x))$ as follows:
"""

# ╔═╡ b514f1fc-548c-11ec-3a5a-755d62bc2452
md"""```math
(a\cdot f(x+h) + b\cdot g(x+h)) - (a\cdot f(x) + b \cdot g(x)) =
a\cdot (f(x+h) - f(x)) + b \cdot (g(x+h) - g(x)).
```
"""

# ╔═╡ b514f204-548c-11ec-1d6e-3dc1bb471ecd
md"""Dividing by $h$, we see that this becomes
"""

# ╔═╡ b514f21a-548c-11ec-0f36-f9dc66a17705
md"""```math
a\cdot \frac{f(x+h) - f(x)}{h} + b \cdot \frac{g(x+h) - g(x)}{h} \rightarrow a\cdot f'(x) + b\cdot g'(x).
```
"""

# ╔═╡ b514f22e-548c-11ec-0c42-4bd106bca18b
md"""That is $[a\cdot f(x) + b \cdot g(x)]' = a\cdot f'(x) + b\cdot g'(x)$.
"""

# ╔═╡ b514f238-548c-11ec-066e-5bd0e0288c82
md"""This holds two rules: the derivative of a constant times a function is the constant times the derivative of the function; and the derivative of a sum of functions is the sum of the derivative of the functions.
"""

# ╔═╡ b514f242-548c-11ec-2136-e3b48832586d
md"""### Product rule
"""

# ╔═╡ b514f276-548c-11ec-09ea-6787b9449ddf
md"""Other rules can be similarly derived. `SymPy` can give us them as well. Here we define two symbolic functions `u` and `v` and let `SymPy` derive a formula for the derivative of a product of functions:
"""

# ╔═╡ b514f90e-548c-11ec-0404-5f730b830709
let
	@syms u() v()
	f(x) = u(x) * v(x)
	limit((f(x+h) - f(x))/h, h => 0)
end

# ╔═╡ b514f94c-548c-11ec-2c9a-11781fcfe3df
md"""The output uses some new notation to represent that the derivative of $u(x) \cdot v(x)$ is the $u$ times the derivative of $v$ plus $v$ times the derivative of $u$. A common shorthand is $[uv]' = u'v + uv'$.
"""

# ╔═╡ b514f95e-548c-11ec-1ad2-19036a2e1cd8
md"""### Quotient rule
"""

# ╔═╡ b514f972-548c-11ec-24ac-51353c3d8ce6
md"""The derivative of $f(x) = u(x)/v(x)$ - a ratio of functions - can be similarly computed. The result will be $[u/v]' = (u'v - uv')/u^2$:
"""

# ╔═╡ b514fd46-548c-11ec-3521-953ad944f00b
let
	@syms u() v()
	f(x) = u(x) / v(x)
	limit((f(x+h) - f(x))/h, h => 0)
end

# ╔═╡ b514fd84-548c-11ec-154a-318be490a5e1
md"""##### Examples
"""

# ╔═╡ b514fda0-548c-11ec-09d3-c745b33d8a33
md"""Compute the derivative of $f(x) = (1 + \sin(x)) + (1 + x^2)$.
"""

# ╔═╡ b514fdb6-548c-11ec-1c5d-19de5f498990
md"""As written we can identify $f(x) = u(x) + v(x)$ with $u=(1 + \sin(x))$, $v=(1 + x^2)$. The sum rule immediately applies to give:
"""

# ╔═╡ b514fdc8-548c-11ec-36e7-67ebc896d6e1
md"""```math
f'(x) = (\cos(x)) + (2x).
```
"""

# ╔═╡ b514fddc-548c-11ec-1bd3-993ac123f7a1
md"""---
"""

# ╔═╡ b514fdf0-548c-11ec-297e-9905d0c12826
md"""Compute the derivative of $f(x) = (1 + \sin(x)) \cdot (1 + x^2)$.
"""

# ╔═╡ b514fe0e-548c-11ec-32ab-77182bdec037
md"""The same $u$ and $v$ my be identified. The product rule readily applies to yield:
"""

# ╔═╡ b514fe16-548c-11ec-1ebe-7332702ccb29
md"""```math
f'(x) = u'v + uv' = \cos(x) \cdot (1 + x^2) + (1 + \sin(x)) \cdot (2x).
```
"""

# ╔═╡ b514fe22-548c-11ec-2e13-fb3c0a6531f8
md"""---
"""

# ╔═╡ b514fe36-548c-11ec-255f-955ef132782f
md"""Compute the derivative of $f(x) = (1 + \sin(x)) / (1 + x^2)$.
"""

# ╔═╡ b514fe48-548c-11ec-1d07-d31f259ece57
md"""The same $u$ and $v$ my be identified. The quotient rule readily applies to yield:
"""

# ╔═╡ b514fe54-548c-11ec-1bf6-fb4c2e4a5109
md"""```math
f'(x) = u'v - uv' = \frac{\cos(x) \cdot (1 + x^2) - (1 + \sin(x)) \cdot (2x)}{(1+x^2)^2}.
```
"""

# ╔═╡ b514fe5e-548c-11ec-1f78-71b52320b2db
md"""---
"""

# ╔═╡ b514fe68-548c-11ec-0f49-e95829873f10
md"""Compute the derivative of $f(x) = (x-1) \cdot (x-2)$.
"""

# ╔═╡ b514fe9a-548c-11ec-1dd0-2978e5b18007
md"""This can be done using the product rule *or* by expanding the polynomial and using the power and sum rule. As this polynomial is easy to expand, we do both and compare:
"""

# ╔═╡ b514feae-548c-11ec-07c9-a9eccfecaac3
md"""```math
[(x-1)(x-2)]' = [x^2 - 3x + 2]' = 2x -3.
```
"""

# ╔═╡ b514feb8-548c-11ec-14b8-61e21625304c
md"""Whereas the product rule gives:
"""

# ╔═╡ b514fec2-548c-11ec-05ad-8f77b91604e0
md"""```math
[(x-1)(x-2)]' = 1\cdot (x-2) + (x-1)\cdot 1 = 2x - 3.
```
"""

# ╔═╡ b514fecc-548c-11ec-0f4b-11d559a1ef54
md"""---
"""

# ╔═╡ b514fed6-548c-11ec-2597-a1ce306ac7af
md"""Find the derivative of $f(x) = (x-1)(x-2)(x-3)(x-4)(x-5)$.
"""

# ╔═╡ b514feec-548c-11ec-2382-0322021ecaf5
md"""We could expand this, as above, but without computer assistance the potential for error is high. Instead we will use the product rule on the product of $5$ terms.
"""

# ╔═╡ b514fef4-548c-11ec-0296-bde05a27f405
md"""Let's first treat the case of $3$ products:
"""

# ╔═╡ b514fefe-548c-11ec-037f-b3a4acb59ca8
md"""```math
[u\cdot v\cdot w]' =[ u \cdot (vw)]' = u' (vw) + u [vw]' = u'(vw) + u[v' w + v w'] =
u' vw + u v' w + uvw'.
```
"""

# ╔═╡ b514ff08-548c-11ec-1ea0-85574ef71c2c
md"""This pattern generalizes, clearly, to:
"""

# ╔═╡ b514ff1e-548c-11ec-034c-c98ca949957b
md"""```math
[f_1\cdot f_2 \cdots f_n]' = f_1' f_2 \cdots f_n + f_1 \cdot f_2' \cdot (f_3 \cdots f_n) + \dots +
f_1 \cdots f_{n-1} \cdot f_n'.
```
"""

# ╔═╡ b514ff30-548c-11ec-05d3-031afb2ed531
md"""There are $n$ terms, each where one of the $f_i$s have a derivative. Were we to multiply top and bottom by $f_i$, we would get each term looks like: $f \cdot f_i'/f_i$.
"""

# ╔═╡ b514ff4c-548c-11ec-1089-d389b45065df
md"""With this, we can proceed. Each term $x-i$ has derivative $1$, so the answer to $f'(x)$, with $f$ as above, is $f'(x) = f(x)/(x-1) + f(x)/(x-2) + f(x)/(x-3) + f(x)/(x-4) + f(x)/(x-5)$, that is:
"""

# ╔═╡ b514ff58-548c-11ec-16f6-7b4dbc2271bf
md"""```math
f'(x) = (x-2)(x-3)(x-4)(x-5) + (x-1)(x-3)(x-4)(x-5) + (x-1)(x-2)(x-4)(x-5) + (x-1)(x-2)(x-3)(x-5) + (x-1)(x-2)(x-3)(x-4).
```
"""

# ╔═╡ b514ff6c-548c-11ec-26b7-af0087699809
md"""### Chain rule
"""

# ╔═╡ b514ff7e-548c-11ec-23bb-03e5f4241b38
md"""Finally, the derivative of a composition of functions can be computed. This gives a rule called the *chain rule*. Before deriving, let's give a slight motivation.
"""

# ╔═╡ b514ff9e-548c-11ec-0bd7-c136e09319d2
md"""Consider the output of a factory for some widget. It depends on two steps: an initial manufacturing step and a finishing step. The number of employees is important in how much is initially manufactured. Suppose $x$ is the number of employees and $g(x)$ is the amount initially manufactured. Adding more employees increases the amount made by the made-up rule $g(x) = \sqrt{x}$. The finishing step depends on how much is made by the employees. If $y$ is the amount made, then $f(y)$ is the number of widgets finished. Suppose for some reason that $f(y) = y^2.$
"""

# ╔═╡ b514ffb0-548c-11ec-167f-e9f922a56aff
md"""How many widgets are made as a function of employees? The composition $u(x) = f(g(x))$ would provide that. Changes in the initial manufacturing step lead to changes in how much is initially made; changes in the initial amount made leads to changes in the finished products. Each change contributes to the overall change.
"""

# ╔═╡ b514ffc6-548c-11ec-2277-7d63b2884882
md"""What is the effect of adding employees on the rate of output of widgets? In this specific case we know the answer, as $(f \circ g)(x) = x$, so the answer is just the rate is $1$.
"""

# ╔═╡ b514ffd0-548c-11ec-342b-978239d13186
md"""In general, we want to express $\Delta f / \Delta x$ in a form so that we can take a limit.
"""

# ╔═╡ b514ffee-548c-11ec-13bc-afa3a1944195
md"""But what do we know? We know $\Delta g / \Delta x$ and $\Delta f/\Delta y$. Using $y=g(x)$, this suggests that we might have luck with the right side of this equation:
"""

# ╔═╡ b514fff8-548c-11ec-30f8-63ce726156fd
md"""```math
\frac{\Delta f}{\Delta x} = \frac{\Delta f}{\Delta y} \cdot \frac{\Delta y}{\Delta x}.
```
"""

# ╔═╡ b515002a-548c-11ec-0b53-69ad8bcc85f0
md"""Interpreting this, we get the *average* rate of change in the composition can be thought of as a product: The *average* rate of change of the initial step ($\Delta y/ \Delta x$) times the *average* rate of the change of the second step evaluated not at $x$, but at $y$, $\Delta f/ \Delta y$.
"""

# ╔═╡ b5150034-548c-11ec-39f6-352027856ea5
md"""Re-expressing using derivative notation with $h$ would be:
"""

# ╔═╡ b515003e-548c-11ec-3ff6-05da4e6b815e
md"""```math
\frac{f(g(x+h)) - f(g(x))}{h} = \frac{f(g(x+h)) - f(g(x))}{g(x+h) - g(x)} \cdot \frac{g(x+h) - g(x)}{h}.
```
"""

# ╔═╡ b5150054-548c-11ec-12b1-816b4c4825b1
md"""The left hand side will converge to the derivative of $u(x)$ or $[f(g(x))]'$.
"""

# ╔═╡ b5150066-548c-11ec-1115-8549ad196034
md"""The right most part of the right side would have a limit $g'(x)$, were we to let $h$ go to $0$.
"""

# ╔═╡ b51500b4-548c-11ec-173e-495797fa6abe
md"""It isn't obvious, but the left part of the right side has the limit $f'(g(x))$. This would be clear if *only* $g(x+h) = g(x) + h$, for then the expression would be exactly the limit expression with $c=g(x)$. But, alas, except to some hopeful students and some special cases, it is definitely not the case in general that $g(x+h) = g(x) + h$ - that right parentheses actually means something. However, it is *nearly* the case that $g(x+h) = g(x) + kh$ for some $k$ and this can be used to formulate a proof (one of the two detailed [here](http://en.wikipedia.org/wiki/Chain_rule#Proofs) and [here](http://kruel.co/math/chainrule.pdf)).
"""

# ╔═╡ b51500c0-548c-11ec-2801-93864154ef01
md"""Combined, we would end up with:
"""

# ╔═╡ b5163422-548c-11ec-1183-1bf40a435ff9
md"""> *The chain rule*: $[f(g(x))]' = f'(g(x)) \cdot g'(x)$. That is the derivative of the outer function evaluated at the inner function times the derivative of the inner function.

"""

# ╔═╡ b516349a-548c-11ec-36e7-dd0900347cba
md"""To see that this works in our specific case, we assume the general power rule that $[x^n]' = n x^{n-1}$ to get: $g'(x) = (1/2)x^{-1/2}$, $f'(x)=2x$, and $f'(g(x)) = 2(\sqrt{x})$. Together, the product is:
"""

# ╔═╡ b51634ae-548c-11ec-0abc-138c133ac833
md"""```math
2\sqrt{x} \cdot (1/2) 1/\sqrt{x} = 1
```
"""

# ╔═╡ b51634c2-548c-11ec-13af-d33828aa36e6
md"""Which is the same as the derivative of $x$ found by first evaluating the composition.
"""

# ╔═╡ b51634f4-548c-11ec-38f9-b17f5a99d722
md"""##### Examples
"""

# ╔═╡ b516351e-548c-11ec-1bda-5f447f2936ae
md"""Find the derivative of $f(x) = \sqrt{1 - x^2}$. We identify the composition of $\sqrt{x}$ – with derivative $(1/2)(x)^{-1/2}$  and $(1-x^2)$ – with derivative $-2x$ and get
"""

# ╔═╡ b5163530-548c-11ec-106c-1fabc06c29fe
md"""```math
(1/2)(1-x^2)^{-1/2} \cdot (-2x).
```
"""

# ╔═╡ b5163544-548c-11ec-13c2-450dc7859003
md"""---
"""

# ╔═╡ b516356c-548c-11ec-009e-53176d20babd
md"""Find the derivative of $\log(2 + \sin(x))$. This is a composition $\log(x)$ – with derivative $1/x$ and  $2 + \sin(x)$ – with derivative $\cos(x)$. We get $(1/\sin(x)) \cos(x)$.
"""

# ╔═╡ b5163576-548c-11ec-217b-7b195832d2c7
md"""In general,
"""

# ╔═╡ b516357e-548c-11ec-2112-cd35a9a59f50
md"""```math
[\log(f(x))]' \frac{f'(x)}{f(x)}.
```
"""

# ╔═╡ b516358a-548c-11ec-3a75-5bdffb1859f0
md"""---
"""

# ╔═╡ b51635a8-548c-11ec-07a3-1ddd3e295794
md"""Find the derivative of $e^{f(x)}$. The inner function has derivative $f'(x)$, the outer function has derivative $e^x$ (the same as the outer function itself). We get for a derivative
"""

# ╔═╡ b51635b0-548c-11ec-16d6-bf700a362cb5
md"""```math
[e^{f(x)}]' = e^{f(x)} \cdot f'(x).
```
"""

# ╔═╡ b51635bc-548c-11ec-2ce1-232d8939258f
md"""This is a useful rule to remember for expressions involving exponentials.
"""

# ╔═╡ b51635c6-548c-11ec-3f1c-6799f0ea8590
md"""##### Proof of the Chain Rule
"""

# ╔═╡ b51635f8-548c-11ec-30ee-8326c2871813
md"""A function is *differentiable* at $a$ if the following limit exists $\lim_{h \rightarrow 0}(f(a+h)-f(a))/h$. Reexpressing this as: $f(a+h) - f(a) - f'(a)h = \epsilon_f(h) h$ where as $h\rightarrow 0$, $\epsilon_f(h) \rightarrow 0$. Then, we have:
"""

# ╔═╡ b5163602-548c-11ec-38f3-05c0ea962b9f
md"""```math
g(a+h) = g(a) + g'(a)h + \epsilon_g(h) h = g(a) + h',
```
"""

# ╔═╡ b5163622-548c-11ec-0b24-dd19edc163f0
md"""Where $h' = (g'(a) + \epsilon_g(h))h \rightarrow 0$ as $h \rightarrow 0$ will be used to simplify the following:
"""

# ╔═╡ b516362a-548c-11ec-11bc-37e82c0932e6
md"""```math
\begin{align}
f(g(a+h)) - f(g(a)) &=
f(g(a) + g'(a)h + \epsilon_g(h)h) - f(g(a)) \\
&= f(g(a)) + f'(g(a)) (g'(a)h + \epsilon_g(h)h) + \epsilon_f(h')(h') - f(g(a))\\
&= f'(g(a)) g'(a)h  + f'(g(a))(\epsilon_g(h)h) + \epsilon_f(h')(h').
\end{align}
```
"""

# ╔═╡ b516363e-548c-11ec-0b2a-175049f90402
md"""Rearranging:
"""

# ╔═╡ b5163648-548c-11ec-3449-f7f63452e443
md"""```math
f(g(a+h)) - f(g(a)) - f'(g(a)) g'(a) h = f'(g(a))\epsilon_g(h))h + \epsilon_f(h')(h') =
(f'(g(a)) \epsilon_g(h)  + \epsilon_f(h')( (g'(a) + \epsilon_g(h))))h =
\epsilon(h)h,
```
"""

# ╔═╡ b5163666-548c-11ec-2b1b-35e90aef263b
md"""where $\epsilon(h)$ combines the above terms which go to zero as $h\rightarrow 0$ into one. This is the alternative definition of the derivative, showing $(f\circ g)'(a) = f'(g(a)) g'(a)$ when $g$ is differentiable at $a$ and $f$ is differentiable at $g(a)$.
"""

# ╔═╡ b5163670-548c-11ec-1bbc-55b09ad2c4a6
md"""##### More examples
"""

# ╔═╡ b5163718-548c-11ec-3bee-098bb6ffa434
md"""  * Find the derivative of $x^5 \cdot \sin(x)$.
"""

# ╔═╡ b516372e-548c-11ec-0ee8-bf057b4be83b
md"""This is a product of functions, using $[u\cdot v]' = u'v + uv'$ we get:
"""

# ╔═╡ b5163738-548c-11ec-2ef9-6faffb26df16
md"""```math
5x^4 \cdot \sin(x) + x^5 \cdot \cos(x)
```
"""

# ╔═╡ b516376a-548c-11ec-368c-610f0f196860
md"""  * Find the derivative of $x^5 / \sin(x)$.
"""

# ╔═╡ b5163774-548c-11ec-2cbe-c3d02bc23055
md"""This is a quotient of functions. Using $[u/v]' = (u'v - uv')/v^2$ we get
"""

# ╔═╡ b516378a-548c-11ec-3950-c3b81365d7c9
md"""```math
(5x^4 \cdot \sin(x) - x^5 \cdot \cos(x)) / (\sin(x))^2.
```
"""

# ╔═╡ b51637d8-548c-11ec-1535-6100691799a9
md"""  * Find the derivative of $\sin(x^5)$. This is a composition of functions $u(v(x))$ with $v(x) = x^5$. The chain rule says find the derivative of $u$ ($\cos(x)$) and evaluate at $v(x)$ ($\cos(x^5)$) then multiply by the derivative of $v$:
"""

# ╔═╡ b51637e2-548c-11ec-0770-c71cd0bbf2e9
md"""```math
\cos(x^5) \cdot 5x^4.
```
"""

# ╔═╡ b5163828-548c-11ec-27b1-073157621e6c
md"""  * Similarly, but differently, find the derivative of $\sin(x)^5$. Now $v(x) = \sin(x)$, so the derivative of $u(x)$ ($5x^4$) evaluated at $v(x)$ is $5(\sin(x))^4$ so multiplying by $v'$ gives:
"""

# ╔═╡ b5163832-548c-11ec-3cae-d7a9d33e992e
md"""```math
5(\sin(x))^4 \cdot \cos(x)
```
"""

# ╔═╡ b5163864-548c-11ec-00ef-059fa9c9d431
md"""We can verify these with `SymPy`. Rather than take a limit, we will use `SymPy`'s `diff` function to compute derivatives.
"""

# ╔═╡ b5163d82-548c-11ec-1d0d-fb1cc7cf924b
diff(x^5 * sin(x))

# ╔═╡ b5164020-548c-11ec-1b1d-4d8361813265
diff(x^5/sin(x))

# ╔═╡ b5164278-548c-11ec-0eb2-bba0ce2561de
diff(sin(x^5))

# ╔═╡ b516428c-548c-11ec-0015-ed08a935bd99
md"""and finally,
"""

# ╔═╡ b516449e-548c-11ec-1257-fd046ede761c
diff(sin(x)^5)

# ╔═╡ b5164d4a-548c-11ec-2255-f9bb5df5dbfc
note("""
The `diff` function can be called as `diff(ex)` when there is just one
free variable, as in the above examples; as  `diff(ex, var)` when there are parameters in the
expression.
"""
)

# ╔═╡ b5164dc2-548c-11ec-0068-2f81eef7a3c7
md"""  * The general product rule:  For any $n$ - not just integer values -  we can re-express $x^n$  using $e$: $x^n = e^{n \log(x)}$. Now the chain rule can be applied:
"""

# ╔═╡ b5164dd8-548c-11ec-13c9-0d6f37a93ae4
md"""```math
[x^n]' = [e^{n\log(x)}]' = e^{n\log(x)} \cdot (n \frac{1}{x}) = n x^n \cdot \frac{1}{x} = n x^{n-1}.
```
"""

# ╔═╡ b5164e06-548c-11ec-2f97-cd57dd9aefa3
md"""  * Find the derivative of $f(x) = x^3 (1-x)^2$ using either the power rule or the sum rule.
"""

# ╔═╡ b5164e26-548c-11ec-1587-0fc99da84195
md"""The power rule expresses $f=u\cdot v$. With $u(x)=x^3$ and $v(x)=(1-x)^2$ we get:
"""

# ╔═╡ b5164e30-548c-11ec-1d37-5db5e1a7cf07
md"""```math
u'(x) = 3x^2, \quad v'(x) = 2 \cdot (1-x)^1 \cdot (-1),
```
"""

# ╔═╡ b5164e44-548c-11ec-1703-91d9cf2ae2b0
md"""the last by the chain rule. Combining with $u' v + u v'$ we get: $f'(x) = (3x^2)\cdot (1-x)^2 + x^3 \cdot (-2) \cdot (1-x)$.
"""

# ╔═╡ b5164e58-548c-11ec-344d-97305fe6b511
md"""Otherwise, the polynomial can be expanded to give $f(x)=x^5-2x^4+x^3$ which has derivative $f'(x) = 5x^4 - 8x^3 + 3x^2$.
"""

# ╔═╡ b5164e8a-548c-11ec-185b-0b862e6c0b33
md"""  * Find the derivative of $f(x) = x \cdot e^{-x^2}$.
"""

# ╔═╡ b5164e94-548c-11ec-2cd3-43fe353d9327
md"""Using the product rule and then the chain rule, we have:
"""

# ╔═╡ b5164e9e-548c-11ec-0e01-777797c6b255
md"""```math
\begin{align}
f'(x) &= [x \cdot e^{-x^2}]'\\
&= [x]' \cdot e^{-x^2} + x \cdot [e^{-x^2}]'\\
&= 1 \cdot e^{-x^2} + x \cdot (e^{-x^2}) \cdot [-x^2]'\\
&= e^{-x^2} + x \cdot e^{-x^2} \cdot (-2x)\\
&= e^{-x^2} (1 - 2x^2).
\end{align}
```
"""

# ╔═╡ b5164ed0-548c-11ec-3890-4774cdc06a6c
md"""  * Find the derivative of $f(x) = e^{-ax} \cdot \sin(x)$.
"""

# ╔═╡ b5164edc-548c-11ec-21b0-0753fbb01603
md"""Using the  product rule and then the chain rule, we have:
"""

# ╔═╡ b5164eee-548c-11ec-2bf1-8bbce9a06d5a
md"""```math
\begin{align}
f'(x) &= [e^{-ax} \cdot \sin(x)]'\\
&= [e^{-ax}]' \cdot \sin(x) + e^{-ax} \cdot [\sin(x)]'\\
&= e^{-ax} \cdot [-ax]' \cdot \sin(x) + e^{-ax} \cdot \cos(x)\\
&= e^{-ax} \cdot (-a)   \cdot \sin(x) + e^{-ax} \cos(x)\\
&= e^{-ax}(\cos(x) - a\sin(x)).
\end{align}
```
"""

# ╔═╡ b5164f02-548c-11ec-0052-597d58f81ee4
md"""##### Example: derivative of inverse functions
"""

# ╔═╡ b5164f20-548c-11ec-3a8f-232629613ae5
md"""Suppose we knew that $\log(x)$ had derivative of $1/x$, but didn't know the derivative of $e^x$. From their inverse relation, we have: $x=\log(e^x)$, so taking derivatives of both sides would yield:
"""

# ╔═╡ b5164f2a-548c-11ec-072c-830ee0702da6
md"""```math
1 = (\frac{1}{e^x}) \cdot [e^x]'.
```
"""

# ╔═╡ b5164f48-548c-11ec-1b24-f55d1ad8ffaa
md"""Or solving, $[e^x]' = e^x$. This is a general strategy to find the derivative of an *inverse* function.
"""

# ╔═╡ b5164f5c-548c-11ec-023d-0fb6d5352a7f
md"""The graph of an inverse function is related to the graph of the function through the symmetry $y=x$.
"""

# ╔═╡ b5164f6e-548c-11ec-27f8-1536cd87213b
md"""For example, the graph of $e^x$ and $\log(x)$ have this symmetry, emphasized below:
"""

# ╔═╡ b51653d8-548c-11ec-34ce-3df62989e6d7
let
	f(x) = exp(x)
	f′(x) = exp(x)
	f⁻¹(x) = log(x)  # using Unicode typed with "f^\-^\1"
	xs = range(0, 2, length=25)
	ys = f.(xs)
	plot(f, 0, 2, aspect_ratio=:equal, xlim=(0,8), ylim=(0,8), legend=false)
	scatter!(xs, ys)
	plot!(f⁻¹, extrema(ys)...)
	scatter!(ys, xs, color=:blue)
	plot!(identity, linestyle=:dot) # the line y=x
	x₀, y₀ = xs[13], ys[13]
	plot!([x₀, y₀],[y₀, x₀], linestyle=:dash)
	ys′ = @.  y₀ + f(x₀)*(xs - x₀)
	plot!(xs, ys′, linestyle=:dash)
	g(y) = 1/f′(f⁻¹(y))
	xs′ = @. x₀ + g(y₀) * (ys - y₀)
	plot!(ys, xs′, linestyle=:dash)
end

# ╔═╡ b5165416-548c-11ec-3dd0-edf3cce9c6bd
md"""The point $(1, e)$ on the graph of $e^x$ matches the point $(e, 1)$ on the graph of the inverse function, $\log(x)$. The slope of the tangent line at $x=1$ to $e^x$ is given by $e$ as well. What is the slope of the tangent line to $\log(x)$ at $x=e$?
"""

# ╔═╡ b5165420-548c-11ec-261d-250161b43d1e
md"""As seen, the value can be computed, but how?
"""

# ╔═╡ b5165434-548c-11ec-0176-33e26b44bbf1
md"""Finding the derivative of the inverse function can be achieved from the chain rule using the identify $f^{-1}(f(x)) = x$ for all $x$ in the domain of $f$.
"""

# ╔═╡ b516544a-548c-11ec-0872-3d4def7ecc33
md"""The chain rule applied to both sides, yields:
"""

# ╔═╡ b5165452-548c-11ec-1328-d3d4f701e31d
md"""```math
1 = [f^{-1}]'(f(x)) \cdot f'(x)
```
"""

# ╔═╡ b5165466-548c-11ec-032f-291ebba1a161
md"""Solving, we see that $[f^{-1}]'(f(x)) = 1/f'(x)$. To emphasize the evaluation of the derivative of the inverse function at $f(x)$ we might write:
"""

# ╔═╡ b516547c-548c-11ec-0e45-8d18e91f44cf
md"""```math
\frac{d}{du} (f^{-1}(u)) \big|_{u=f(x)} = \frac{1}{f'(x)}
```
"""

# ╔═╡ b51654a2-548c-11ec-3467-83241cca74d0
md"""So the reciprocal of the slope of the tangent line of $f$ at the mirror image point. In the above, we see if the slope of the tangent line at $(1,e)$ to $f$ is $e$, then the slope of the tangent line to $f^{-1}(x)$ at $(e,1)$ would be $1/e$.
"""

# ╔═╡ b518e8c0-548c-11ec-223b-f50f500de238
md"""#### Rules of derivatives and some sample functions
"""

# ╔═╡ b518e91a-548c-11ec-06dc-4dcd834ac815
md"""This table summarizes the rules of derivatives that allow derivatives of more complicated expressions to be computed with the derivatives of their pieces.
"""

# ╔═╡ b518f40a-548c-11ec-0769-5f39f19ece7b
let
	nm = ["Power rule", "constant", "sum/difference", "product", "quotient", "chain"]
	rule = [L"[x^n]' = n\cdot x^{n-1}",
	 L"[cf(x)]' = c \cdot f'(x)",
	 L"[f(x) \pm g(x)]' = f'(x) \pm g'(x)",
	 L"[f(x) \cdot g(x)]' = f'(x)\cdot g(x) + f(x) \cdot g'(x)",
	 L"[f(x)/g(x)]' = (f'(x) \cdot g(x) - f(x) \cdot g'(x)) / g(x)^2",
	 L"[f(g(x))]' = f'(g(x)) \cdot g'(x)"]
	d = DataFrame(Name=nm, Rule=rule)
	table(d)
end

# ╔═╡ b518f428-548c-11ec-2e72-1d978e392212
md"""This table gives some useful derivatives:
"""

# ╔═╡ b518fbf6-548c-11ec-0c16-7f273efb5fa0
let
	fn = [L"x^n (\text{ all } n)",
	L"e^x",
	L"\log(x)",
	L"\sin(x)",
	L"\cos(x)"]
	a = [L"nx^{n-1}",
	L"e^x",
	L"1/x",
	L"\cos(x)",
	L"-\sin(x)"]
	d = DataFrame(Function=fn, Derivative=a)
	table(d)
end

# ╔═╡ b518fc3e-548c-11ec-2024-871a50126322
md"""## Higher-order derivatives
"""

# ╔═╡ b518fc8e-548c-11ec-1893-6b90ca823e68
md"""The derivative of a function is an operator, it takes a function and returns a new, derived, function. We could repeat this operation. The result is called a higher-order derivative. The Lagrange notation uses additional "primes" to indicate how many. So $f''(x)$ is the second derivative and $f'''(x)$ the third. For even higher orders, sometimes the notation is $f^{(n)}(x)$ to indicate an $n$th derivative.
"""

# ╔═╡ b518fcac-548c-11ec-028c-21d147fac4fd
md"""##### Examples
"""

# ╔═╡ b518fcc0-548c-11ec-0494-c1ccc60d90fb
md"""Find the first $3$ derivatives of $f(x) = ax^3 + bx^2 + cx + d$.
"""

# ╔═╡ b518fccc-548c-11ec-38a4-0bca95172882
md"""Differentiating a polynomial is done with the sum rule, here we repeat three times:
"""

# ╔═╡ b518fcf2-548c-11ec-2d52-b9a3ece04497
md"""```math
\begin{align}
f(x)    &= ax^3 + bx^2 + cx + d\\
f'(x)   &= 3ax^2 + 2bx + c \\
f''(x)  &= 3\cdot 2 a x + 2b \\
f'''(x) &= 6a
\end{align}
```
"""

# ╔═╡ b518fd1a-548c-11ec-3da7-b7f4de657cb1
md"""We can see, the fourth derivative – and all higher order ones – would be identically $0$. This is part of a general phenomenon: an $n$th degree polynomial has only $n$ non-zero derivatives.
"""

# ╔═╡ b518fd42-548c-11ec-37aa-7f37259bb002
md"""---
"""

# ╔═╡ b518fd5e-548c-11ec-04ba-ffc40eb930dc
md"""Find the first $5$ derivatives of $\sin(x)$.
"""

# ╔═╡ b518fd74-548c-11ec-0ad5-c198d9049728
md"""```math
\begin{align}
f(x)    &= \sin(x) \\
f'(x)   &= \cos(x) \\
f''(x)  &= -\sin(x) \\
f'''(x) &= -\cos(x) \\
f^{(4)} &= \sin(x) \\
f^{(5)} &= \cos(x)
\end{align}
```
"""

# ╔═╡ b518fd7e-548c-11ec-2371-b3f82426a9b9
md"""We see the derivatives repeat them selves. (We also see alternative notation for higher order derivatives.)
"""

# ╔═╡ b518fd88-548c-11ec-1690-cb459f05b31c
md"""---
"""

# ╔═╡ b518fd9c-548c-11ec-1995-8d83a1894dbb
md"""Find the second derivative of $e^{-x^2}$.
"""

# ╔═╡ b518fdba-548c-11ec-1392-71b3b29e3cda
md"""We need the chain rule *and* the product rule:
"""

# ╔═╡ b518fdce-548c-11ec-047d-9986c72f5f4b
md"""```math
[e^{-x^2}]'' = [e^{-x^2} \cdot (-2x)]' = \left(e^{-x^2} \cdot (-2x)\right) \cdot(-2x) + e^{-x^2} \cdot (-2) =
e^{-x^2}(4x^2 - 2).
```
"""

# ╔═╡ b518fdd8-548c-11ec-2a69-ab56c5cebeea
md"""This can be verified:
"""

# ╔═╡ b519027e-548c-11ec-3615-ada60790d846
diff(diff(exp(-x^2))) |> simplify

# ╔═╡ b51902b0-548c-11ec-0410-b7d44b47212b
md"""Having to iterate the use of `diff` is cumbersome. An alternate notation is either specifying the variable twice: `diff(ex, x, x)` or using a number after the variable: `diff(ex, x, 2)`:
"""

# ╔═╡ b51905e4-548c-11ec-0481-158bab98b372
diff(exp(-x^2), x, x) |> simplify

# ╔═╡ b51905f8-548c-11ec-056f-c14a0a706b33
md"""Higher-order derivatives can become involved when the product or quotient rules becomes involved.
"""

# ╔═╡ b5190602-548c-11ec-022f-97a65532272b
md"""## Questions
"""

# ╔═╡ b51d5f22-548c-11ec-1d7f-a74087398d09
md"""###### Question
"""

# ╔═╡ b51d5fc2-548c-11ec-1625-7fb69e03e414
md"""The derivative at $c$ is the slope of the tangent line at $x=c$. Answer the following based on this graph:
"""

# ╔═╡ b51d68aa-548c-11ec-2f91-2bd338c0f38b
begin
	fn = x -> -x*exp(x)*sin(pi*x)
	plot(fn, 0, 2)
end

# ╔═╡ b51d68fa-548c-11ec-083e-af7d911abbe9
md"""At which of these points $c= 1/2, 1, 3/2$ is the derivative negative?
"""

# ╔═╡ b51d6f26-548c-11ec-233c-735b5977574c
let
	choices = ["``1/2``", "``1``", "``3/2``"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d6f46-548c-11ec-2806-f312f6469ea5
md"""Which value looks bigger from reading the graph:
"""

# ╔═╡ b51d7494-548c-11ec-22de-b92fe6cfa9fc
let
	choices = ["``f(1)``", "``f(3/2)``"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d74bc-548c-11ec-016a-6da2c56747a1
md"""At $0.708 \dots$ and $1.65\dots$ the derivative has a common value. What is it?
"""

# ╔═╡ b51d7728-548c-11ec-3ee6-8d19053dce3a
let
	numericq(0, 1e-2)
end

# ╔═╡ b51d775a-548c-11ec-28b6-edd230db3d00
md"""###### Question
"""

# ╔═╡ b51d778c-548c-11ec-0a0f-8d059d65c539
md"""Consider the graph of the `airyai` function (from `SpecialFunctions`) over $[-5, 5]$.
"""

# ╔═╡ b51d7a02-548c-11ec-0104-75ebed262584
let
	plot(airyai, -5, 5)
end

# ╔═╡ b51d7a22-548c-11ec-3388-296db2c59642
md"""At $x = -2.5$  the derivative is postive or negative?
"""

# ╔═╡ b51d7f02-548c-11ec-0101-d194dbf39925
let
	choices = ["positive", "negative"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d7f2a-548c-11ec-3222-dbbd236c89a4
md"""At $x=0$ the derivative is postive or negative?
"""

# ╔═╡ b51d83d0-548c-11ec-0715-7139db5cc11d
let
	choices = ["positive", "negative"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d83fa-548c-11ec-0a1f-73b305eb0ca7
md"""At $x = 2.5$  the derivative is postive or negative?
"""

# ╔═╡ b51d8892-548c-11ec-351a-3fd54bd9e591
let
	choices = ["positive", "negative"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d88b2-548c-11ec-053f-45a7b38f2c2c
md"""###### Question
"""

# ╔═╡ b51d88da-548c-11ec-1e75-d5ace7da0643
md"""Compute the derivative of $e^x$ using `limit`. What do you get?
"""

# ╔═╡ b51d9096-548c-11ec-083f-57909765fcc3
let
	choices = ["``e^x``", "``x^e``", "``(e-1)x^e``", "``e x^{(e-1)}``", "something else"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d90b4-548c-11ec-17d1-63fdd610ff3b
md"""###### Question
"""

# ╔═╡ b51d90e6-548c-11ec-2e0a-cbd34fa3196a
md"""Compute the derivative of $x^e$ using `limit`. What do you get?
"""

# ╔═╡ b51d98ca-548c-11ec-3241-95d9a5102809
let
	choices = ["``e^x``", "``x^e``", "``(e-1)x^e``", "``e x^{(e-1)}``", "something else"]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51d98e8-548c-11ec-1891-2d758b42e05b
md"""###### Question
"""

# ╔═╡ b51d9906-548c-11ec-0564-bde1255b8c08
md"""Compute the derivative of $e^{e\cdot x}$ using `limit`. What do you get?
"""

# ╔═╡ b51da222-548c-11ec-27c0-4fa4a1c1a08a
let
	choices = ["``e^x``", "``x^e``", "``(e-1)x^e``", "``e x^{(e-1)}``", "``e \\cdot e^{e\\cdot x}``", "something else"]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ b51da234-548c-11ec-125e-41ae0605f6d8
md"""###### Question
"""

# ╔═╡ b51da250-548c-11ec-0efb-21e2fc5d9e2f
md"""In the derivation of the derivative of $\sin(x)$, the following limit is needed:
"""

# ╔═╡ b51da282-548c-11ec-1074-ab67219acc8f
md"""```math
L = \lim_{h \rightarrow 0} \frac{\cos(h) - 1}{h}.
```
"""

# ╔═╡ b51da28e-548c-11ec-0f6e-0f789bc5add6
md"""This is
"""

# ╔═╡ b51daf5e-548c-11ec-0119-29bfc4dd379b
let
	choices = [
	L" $1$, as this is clearly the analog of the limit of $\sin(h)/h$.",
	L"Does not exist. The answer is $0/0$ which is undefined",
	L" $0$,  as this expression is the derivative of cosine at $0$. The answer follows, as cosine clearly has a tangent line with slope $0$  at $x=0$."]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ b51daf7c-548c-11ec-08d5-9917a59bae29
md"""###### Question
"""

# ╔═╡ b51daf9c-548c-11ec-163b-e7d4239e1e1e
md"""Let $f(x) = (e^x + e^{-x})/2$ and $g(x) = (e^x - e^{-x})/2$. Which is true?
"""

# ╔═╡ b51db74c-548c-11ec-2c29-3513af039b9b
let
	choices = [
	"``f'(x) =  g(x)``",
	"``f'(x) = -g(x)``",
	"``f'(x) =  f(x)``",
	"``f'(x) = -f(x)``"
	]
	ans= 1
	radioq(choices, ans)
end

# ╔═╡ b51db760-548c-11ec-385e-e3179a7f9b9d
md"""###### Question
"""

# ╔═╡ b51db788-548c-11ec-1f65-9b77175d330d
md"""Let $f(x) = (e^x + e^{-x})/2$ and $g(x) = (e^x - e^{-x})/2$. Which is true?
"""

# ╔═╡ b51dbf58-548c-11ec-1df5-21123860201f
let
	choices = [
	"``f''(x) =  g(x)``",
	"``f''(x) = -g(x)``",
	"``f''(x) =  f(x)``",
	"``f''(x) = -f(x)``"]
	ans= 3
	radioq(choices, ans)
end

# ╔═╡ b51dbf74-548c-11ec-024e-f195ff317780
md"""###### Question
"""

# ╔═╡ b51dbf9e-548c-11ec-1b43-29b4f44c823c
md"""Consider the function $f$ and its transformation $g(x) = a + f(x)$ (shift up by $a$). Do $f$ and $g$ have the same derivative?
"""

# ╔═╡ b51dc1ba-548c-11ec-15d8-879499d4379a
let
	yesnoq("yes")
end

# ╔═╡ b51dc1e0-548c-11ec-2aa4-63a18d581c76
md"""Consider the function $f$ and its transformation $g(x) = f(x - a)$ (shift right by $a$). Do $f$ and $g$ have the same derivative?
"""

# ╔═╡ b51dc3ac-548c-11ec-0eb4-ed29a9f7c37f
let
	yesnoq("no")
end

# ╔═╡ b51dc3e0-548c-11ec-1b89-ff1374ff3b9c
md"""Consider the function $f$ and its transformation $g(x) = f(x - a)$ (shift right by $a$). Is $f'$ at $x$ equal to $g'$ at $x-a$?
"""

# ╔═╡ b51dc5b8-548c-11ec-2c8a-a7bf6a996070
let
	yesnoq("yes")
end

# ╔═╡ b51dc5de-548c-11ec-0ed0-e3cfae1a7826
md"""Consider the function $f$ and its transformation $g(x) = c f(x)$, $c > 1$. Do $f$ and $g$ have the same derivative?
"""

# ╔═╡ b51dc7a0-548c-11ec-26da-45103d2ad301
let
	yesnoq("no")
end

# ╔═╡ b51dc7c8-548c-11ec-216d-d98b6b5bb70f
md"""Consider the function $f$ and its transformation $g(x) = f(x/c)$, $c > 1$. Do $f$ and $g$ have the same derivative?
"""

# ╔═╡ b51dc980-548c-11ec-3e77-89b9cccc3236
let
	yesnoq("no")
end

# ╔═╡ b51dc994-548c-11ec-0ec1-3748f74438e0
md"""Which of the following is true?
"""

# ╔═╡ b51dd9d4-548c-11ec-05c7-f5386e99baeb
let
	choices = [
	L"If the graphs of $f$ and $g$ are translations up and down, the tangent line at corresponding points is unchanged.",
	L"If the graphs of $f$ and $g$ are rescalings of each other through $g(x)=f(x/c)$, $c > 1$. Then the tangent line for corresponding points is the same.",
	L"If the graphs of $f$ and $g$ are rescalings of each other through $g(x)=cf(x)$, $c > 1$. Then the tangent line for corresponding points is the same."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ b51dd9f2-548c-11ec-386c-c1b1fbc2e678
md"""###### Question
"""

# ╔═╡ b51dda1a-548c-11ec-0c00-11c048fce9d2
md"""The rate of change of volume with respect to height is $3h$. The rate of change of height with respect to time is $2t$. At at $t=3$ the height is $h=14$ what is the rate of change of volume with respect to time when $t=3$?
"""

# ╔═╡ b51ddede-548c-11ec-1ce0-37266408e9a7
let
	## dv/dt = dv/dh * dh/dt = 3h * 2t
	h = 14; t=3
	val = (3*h) * (2*t)
	numericq(val)
end

# ╔═╡ b51ddefc-548c-11ec-090a-f71b2245cfd0
md"""###### Question
"""

# ╔═╡ b51ddf1a-548c-11ec-139c-53f8f7867e10
md"""Which equation below is $f(x) = \sin(k\cdot x)$ a solution of ($k > 1$)?
"""

# ╔═╡ b51de8ca-548c-11ec-1aa1-6946f23f8839
let
	choices = [
	"``f'(x) =  k^2  \\cdot f(x)``",
	"``f'(x) = -k^2  \\cdot f(x)``",
	"``f''(x) = k^2  \\cdot f(x)``",
	"``f''(x) = -k^2 \\cdot f(x)``"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ b51de8de-548c-11ec-10dc-a36dbed0203a
md"""###### Question
"""

# ╔═╡ b51de906-548c-11ec-3c01-fbf8acf3255f
md"""Let $f(x) = e^{k\cdot x}$, $k > 1$. Which equation below is $f(x)$ a solution of?
"""

# ╔═╡ b51df1c6-548c-11ec-1ea9-dd6a5a0ddfe8
let
	choices = [
	"``f'(x) = k^2   \\cdot f(x)``",
	"``f'(x) = -k^2  \\cdot f(x)``",
	"``f''(x) = k^2  \\cdot f(x)``",
	"``f''(x) = -k^2 \\cdot f(x)``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ b51df202-548c-11ec-275d-ddb50e1de9a5
md"""##### Question
"""

# ╔═╡ b51df234-548c-11ec-3641-a16e7a76cb87
md"""Their are $6$ trig functions. The derivatives of $\sin(x)$ and $\cos(x)$ should be memorized. The others can be derived if not memorized using the quotient rule or chain rule.
"""

# ╔═╡ b51df248-548c-11ec-11c8-b3c288b62437
md"""What is $[\tan(x)]'$? (Use $\tan(x) =  \sin(x)/\cos(x)$.)
"""

# ╔═╡ b51dfa2a-548c-11ec-1879-275332464ad1
begin
	trig_choices = [
	"``\\sec^2(x)``",
	"``\\sec(x)\\tan(x)``",
	"``-\\csc^2(x)``",
	"``-\\csc(x)\\cot(x)``"
	]
	radioq(trig_choices, 1)
end

# ╔═╡ b51dfa54-548c-11ec-3324-93711a1a8235
md"""What is $[\cot(x)]'$? (Use $\tan(x) = \cos(x)/\sin(x)$.)
"""

# ╔═╡ b51dfbf8-548c-11ec-2265-e161117f6f46
radioq(trig_choices, 3)

# ╔═╡ b51dfc20-548c-11ec-3ab1-db0a747f49c6
md"""What is $[\sec(x)]'$? (Use $\sec(x) = 1/\cos(x)$.)
"""

# ╔═╡ b51dfd9e-548c-11ec-1f1c-b5d2be047edc
radioq(trig_choices, 2)

# ╔═╡ b51dfdba-548c-11ec-36a9-a55fa73e5b27
md"""What is $[\csc(x)]'$? (Use $\csc(x) = 1/\sin(x)$.)
"""

# ╔═╡ b51dff5e-548c-11ec-35cc-c342b7298bca
radioq(trig_choices, 4)

# ╔═╡ b51dff86-548c-11ec-1b5a-29b0f9162a98
HTML("""<div class="markdown"><blockquote>
<p><a href="../limits/intermediate_value_theorem.html">◅ previous</a>  <a href="../derivatives/numeric_derivatives.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/derivatives.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ b51dff90-548c-11ec-1ccc-410408525817
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.11"
DataFrames = "~1.3.0"
Plots = "~1.25.0"
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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "57dbb47c8d661a2c3128b30d0407256b8e4d450e"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.11"

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
git-tree-sha1 = "2e993336a3f68216be91eb8ee4625ebbaba19147"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.0"

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
git-tree-sha1 = "8789439a899b77f4fbb4d7298500a6a5781205bc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.0"

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
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

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
# ╟─b51dff6a-548c-11ec-2e7b-7d31ca2a8cc0
# ╟─b4d25860-548c-11ec-25e9-2fa6558c2ccf
# ╟─b4d4803e-548c-11ec-29d7-975d2593b2f7
# ╠═b4eaacda-548c-11ec-18cb-07d903e1fbec
# ╟─b4eab2f2-548c-11ec-0a3e-7fc343ece080
# ╟─b4ec7c36-548c-11ec-1476-27331b19e2b9
# ╟─b4ec7cb8-548c-11ec-02de-b303b97f7199
# ╟─b4eefbde-548c-11ec-1de5-e573fc987622
# ╟─b4eefc36-548c-11ec-2003-b74977c6b5b5
# ╟─b4f1c5ec-548c-11ec-1759-150d07287427
# ╟─b4f3a838-548c-11ec-36ef-590935ead43c
# ╟─b4f3a8d0-548c-11ec-2cc1-2d555f5be72d
# ╟─b4f3a8ee-548c-11ec-12dc-6b4bc653339c
# ╟─b4f3a90e-548c-11ec-033f-a38c14b34f3a
# ╠═b4f3b03c-548c-11ec-0a05-13238a7b1b26
# ╟─b4f672d6-548c-11ec-2bb6-c12d009c52b8
# ╠═b4f678da-548c-11ec-1954-3976c8a7047a
# ╟─b4f679e8-548c-11ec-1193-77a3606b06e5
# ╟─b4f690a4-548c-11ec-0712-3d15907e6ee4
# ╟─b4f690de-548c-11ec-09c3-efcc57264cca
# ╟─b4f690f4-548c-11ec-0f98-0398b14e400e
# ╠═b4f692a2-548c-11ec-3f50-6b385582b388
# ╟─b4f692c0-548c-11ec-04e4-595aec80cd6d
# ╠═b4f6952c-548c-11ec-2467-2fc82540813d
# ╟─b4f69540-548c-11ec-19b0-bf39be188b6b
# ╠═b4f697b4-548c-11ec-1981-dda5b1b962d4
# ╟─b4f697d4-548c-11ec-2fd4-49e201ef25de
# ╟─b4f697e6-548c-11ec-2cc8-333b362a3cc6
# ╟─b4f697f2-548c-11ec-253b-6b858aeea214
# ╠═b4f6a382-548c-11ec-2026-9f221cd7e722
# ╟─b4fea76c-548c-11ec-2848-85d8989b9ec9
# ╟─b4fec0ee-548c-11ec-084d-6f400e56ffc3
# ╟─b4fec166-548c-11ec-1ff8-e7d77dcae5e5
# ╟─b50075a6-548c-11ec-3d5d-2191ebd4a4a3
# ╟─b500761e-548c-11ec-151f-c71ceab55703
# ╟─b5007d4e-548c-11ec-2c8a-59e1a372cb72
# ╟─b5007d76-548c-11ec-3df5-4d8e12c90aa1
# ╠═b50081ea-548c-11ec-0802-0d6de9dfc630
# ╟─b50081fe-548c-11ec-2b5e-219ce834959a
# ╟─b509bad2-548c-11ec-15f4-814ddc08d47c
# ╠═b509c124-548c-11ec-04f1-734cf92df0f9
# ╟─b509c1ec-548c-11ec-2993-6b243d471bf8
# ╠═b509c5ae-548c-11ec-3c3a-3f6da113ef9c
# ╟─b509c5e8-548c-11ec-2376-8f210b8aae4c
# ╟─b509c5fc-548c-11ec-0f44-812e938c18ba
# ╠═b509cc96-548c-11ec-3b63-597da2d567ef
# ╟─b509ccbe-548c-11ec-1b18-e394f46aa852
# ╟─b509ccc8-548c-11ec-2d8c-af78c0d730cb
# ╟─b50c58a6-548c-11ec-0f9e-ffee2169a922
# ╟─b50c5934-548c-11ec-335a-17e9548c55bf
# ╟─b50f892e-548c-11ec-1198-6f3f670184cb
# ╟─b50f89a6-548c-11ec-2888-1721bddeeed0
# ╟─b50f89c4-548c-11ec-3d64-8768613fd47c
# ╟─b50f8a00-548c-11ec-2ee6-7f823da7af83
# ╟─b50f8a1e-548c-11ec-1b37-77868bb8187f
# ╟─b50f8a46-548c-11ec-0a69-cb0a97538eeb
# ╟─b50fc286-548c-11ec-3151-7d902863157c
# ╟─b50fc2ce-548c-11ec-1cb3-d361e0ab1ad1
# ╟─b50fc2ea-548c-11ec-0e5e-295ebb3194b7
# ╟─b50fc300-548c-11ec-2748-d37f1c9bd3ba
# ╟─b50fe298-548c-11ec-11d9-af64d8b8ac17
# ╟─b50fe2b6-548c-11ec-01f6-fd49c4441099
# ╟─b50ff044-548c-11ec-1544-1bebafc332c5
# ╟─b50ff080-548c-11ec-386a-33f4ef510c06
# ╟─b50ff0a8-548c-11ec-18fc-8bc811c44725
# ╟─b50ff0c6-548c-11ec-32ad-674239d21bef
# ╠═b50ff422-548c-11ec-3df6-892da7f33139
# ╟─b50ff442-548c-11ec-1898-95b4c7d036bf
# ╟─b50ff486-548c-11ec-217f-a50f047a1eb7
# ╟─b50ff49a-548c-11ec-0318-43441913f313
# ╟─b50ff4ae-548c-11ec-33da-211850d457c8
# ╟─b50ff4c2-548c-11ec-0fec-cff2f3458816
# ╟─b51273b4-548c-11ec-0cef-e13683f485a9
# ╟─b513fe82-548c-11ec-309d-49416d5871fb
# ╠═b51405ce-548c-11ec-39f8-cd53d22bd478
# ╟─b5140632-548c-11ec-3a47-1f33ea7fc4dd
# ╠═b514089e-548c-11ec-10f2-499aeaa37862
# ╟─b51408dc-548c-11ec-1326-8f35ccb0b21f
# ╟─b5140918-548c-11ec-30f3-7d51c1335220
# ╟─b5140936-548c-11ec-111b-0b8863f11123
# ╟─b51409d4-548c-11ec-10d3-bd53ff7416bd
# ╟─b51409ea-548c-11ec-3f1e-d99cf3208d76
# ╠═b5140db4-548c-11ec-3ffe-e9c11a5d84c2
# ╟─b5140dde-548c-11ec-3fe1-5958c0f4e6cd
# ╟─b5140de6-548c-11ec-1f3f-e3c482bf36e2
# ╟─b5140e0c-548c-11ec-19d9-91a0019bebcb
# ╟─b5140e36-548c-11ec-1035-073b29ddde22
# ╠═b5141336-548c-11ec-2d3b-dd2d2f74b94b
# ╟─b5141372-548c-11ec-359f-b30385f2984b
# ╟─b51413cc-548c-11ec-1632-f9e387e71bc8
# ╟─b51413de-548c-11ec-2b29-6d6dac447ae6
# ╟─b5141412-548c-11ec-178f-2d707e9cbcba
# ╟─b514141c-548c-11ec-2032-2faf25d3eb36
# ╠═b51418cc-548c-11ec-2967-5557b182dd91
# ╟─b514191a-548c-11ec-1cc8-0b41b0535e53
# ╟─b5141930-548c-11ec-0036-f18950c185d3
# ╟─b514194c-548c-11ec-2f7e-eb0611ba712a
# ╟─b514196c-548c-11ec-0754-156e0d6c811e
# ╟─b51419a8-548c-11ec-2087-4f873508155e
# ╟─b51419b2-548c-11ec-06a7-cbba94e70079
# ╟─b5141a0c-548c-11ec-3f11-4da6f589e862
# ╟─b5141a22-548c-11ec-33f9-97bb3762d7ef
# ╟─b5141a34-548c-11ec-1329-5f19013d73ca
# ╟─b5141aac-548c-11ec-316a-613608ffa8ca
# ╟─b5141ad4-548c-11ec-01f0-35ef9a4dca7b
# ╟─b514f09c-548c-11ec-01fb-558e59177b2e
# ╟─b514f10e-548c-11ec-242b-c541ad3c8ce4
# ╟─b514f116-548c-11ec-258b-9d30dcf8b369
# ╟─b514f15c-548c-11ec-1cbb-fd39b35e2e20
# ╟─b514f17a-548c-11ec-1cac-d35664b870ea
# ╟─b514f198-548c-11ec-1fdc-e583c5d4b41e
# ╟─b514f1b6-548c-11ec-049c-0503d6a631c8
# ╟─b514f1c0-548c-11ec-33ea-91bd7f00cabc
# ╟─b514f1de-548c-11ec-2a6c-0373d4adc884
# ╟─b514f1e8-548c-11ec-0185-c7c49523cb31
# ╟─b514f1fc-548c-11ec-3a5a-755d62bc2452
# ╟─b514f204-548c-11ec-1d6e-3dc1bb471ecd
# ╟─b514f21a-548c-11ec-0f36-f9dc66a17705
# ╟─b514f22e-548c-11ec-0c42-4bd106bca18b
# ╟─b514f238-548c-11ec-066e-5bd0e0288c82
# ╟─b514f242-548c-11ec-2136-e3b48832586d
# ╟─b514f276-548c-11ec-09ea-6787b9449ddf
# ╠═b514f90e-548c-11ec-0404-5f730b830709
# ╟─b514f94c-548c-11ec-2c9a-11781fcfe3df
# ╟─b514f95e-548c-11ec-1ad2-19036a2e1cd8
# ╟─b514f972-548c-11ec-24ac-51353c3d8ce6
# ╠═b514fd46-548c-11ec-3521-953ad944f00b
# ╟─b514fd84-548c-11ec-154a-318be490a5e1
# ╟─b514fda0-548c-11ec-09d3-c745b33d8a33
# ╟─b514fdb6-548c-11ec-1c5d-19de5f498990
# ╟─b514fdc8-548c-11ec-36e7-67ebc896d6e1
# ╟─b514fddc-548c-11ec-1bd3-993ac123f7a1
# ╟─b514fdf0-548c-11ec-297e-9905d0c12826
# ╟─b514fe0e-548c-11ec-32ab-77182bdec037
# ╟─b514fe16-548c-11ec-1ebe-7332702ccb29
# ╟─b514fe22-548c-11ec-2e13-fb3c0a6531f8
# ╟─b514fe36-548c-11ec-255f-955ef132782f
# ╟─b514fe48-548c-11ec-1d07-d31f259ece57
# ╟─b514fe54-548c-11ec-1bf6-fb4c2e4a5109
# ╟─b514fe5e-548c-11ec-1f78-71b52320b2db
# ╟─b514fe68-548c-11ec-0f49-e95829873f10
# ╟─b514fe9a-548c-11ec-1dd0-2978e5b18007
# ╟─b514feae-548c-11ec-07c9-a9eccfecaac3
# ╟─b514feb8-548c-11ec-14b8-61e21625304c
# ╟─b514fec2-548c-11ec-05ad-8f77b91604e0
# ╟─b514fecc-548c-11ec-0f4b-11d559a1ef54
# ╟─b514fed6-548c-11ec-2597-a1ce306ac7af
# ╟─b514feec-548c-11ec-2382-0322021ecaf5
# ╟─b514fef4-548c-11ec-0296-bde05a27f405
# ╟─b514fefe-548c-11ec-037f-b3a4acb59ca8
# ╟─b514ff08-548c-11ec-1ea0-85574ef71c2c
# ╟─b514ff1e-548c-11ec-034c-c98ca949957b
# ╟─b514ff30-548c-11ec-05d3-031afb2ed531
# ╟─b514ff4c-548c-11ec-1089-d389b45065df
# ╟─b514ff58-548c-11ec-16f6-7b4dbc2271bf
# ╟─b514ff6c-548c-11ec-26b7-af0087699809
# ╟─b514ff7e-548c-11ec-23bb-03e5f4241b38
# ╟─b514ff9e-548c-11ec-0bd7-c136e09319d2
# ╟─b514ffb0-548c-11ec-167f-e9f922a56aff
# ╟─b514ffc6-548c-11ec-2277-7d63b2884882
# ╟─b514ffd0-548c-11ec-342b-978239d13186
# ╟─b514ffee-548c-11ec-13bc-afa3a1944195
# ╟─b514fff8-548c-11ec-30f8-63ce726156fd
# ╟─b515002a-548c-11ec-0b53-69ad8bcc85f0
# ╟─b5150034-548c-11ec-39f6-352027856ea5
# ╟─b515003e-548c-11ec-3ff6-05da4e6b815e
# ╟─b5150054-548c-11ec-12b1-816b4c4825b1
# ╟─b5150066-548c-11ec-1115-8549ad196034
# ╟─b51500b4-548c-11ec-173e-495797fa6abe
# ╟─b51500c0-548c-11ec-2801-93864154ef01
# ╟─b5163422-548c-11ec-1183-1bf40a435ff9
# ╟─b516349a-548c-11ec-36e7-dd0900347cba
# ╟─b51634ae-548c-11ec-0abc-138c133ac833
# ╟─b51634c2-548c-11ec-13af-d33828aa36e6
# ╟─b51634f4-548c-11ec-38f9-b17f5a99d722
# ╟─b516351e-548c-11ec-1bda-5f447f2936ae
# ╟─b5163530-548c-11ec-106c-1fabc06c29fe
# ╟─b5163544-548c-11ec-13c2-450dc7859003
# ╟─b516356c-548c-11ec-009e-53176d20babd
# ╟─b5163576-548c-11ec-217b-7b195832d2c7
# ╟─b516357e-548c-11ec-2112-cd35a9a59f50
# ╟─b516358a-548c-11ec-3a75-5bdffb1859f0
# ╟─b51635a8-548c-11ec-07a3-1ddd3e295794
# ╟─b51635b0-548c-11ec-16d6-bf700a362cb5
# ╟─b51635bc-548c-11ec-2ce1-232d8939258f
# ╟─b51635c6-548c-11ec-3f1c-6799f0ea8590
# ╟─b51635f8-548c-11ec-30ee-8326c2871813
# ╟─b5163602-548c-11ec-38f3-05c0ea962b9f
# ╟─b5163622-548c-11ec-0b24-dd19edc163f0
# ╟─b516362a-548c-11ec-11bc-37e82c0932e6
# ╟─b516363e-548c-11ec-0b2a-175049f90402
# ╟─b5163648-548c-11ec-3449-f7f63452e443
# ╟─b5163666-548c-11ec-2b1b-35e90aef263b
# ╟─b5163670-548c-11ec-1bbc-55b09ad2c4a6
# ╟─b5163718-548c-11ec-3bee-098bb6ffa434
# ╟─b516372e-548c-11ec-0ee8-bf057b4be83b
# ╟─b5163738-548c-11ec-2ef9-6faffb26df16
# ╟─b516376a-548c-11ec-368c-610f0f196860
# ╟─b5163774-548c-11ec-2cbe-c3d02bc23055
# ╟─b516378a-548c-11ec-3950-c3b81365d7c9
# ╟─b51637d8-548c-11ec-1535-6100691799a9
# ╟─b51637e2-548c-11ec-0770-c71cd0bbf2e9
# ╟─b5163828-548c-11ec-27b1-073157621e6c
# ╟─b5163832-548c-11ec-3cae-d7a9d33e992e
# ╟─b5163864-548c-11ec-00ef-059fa9c9d431
# ╠═b5163d82-548c-11ec-1d0d-fb1cc7cf924b
# ╠═b5164020-548c-11ec-1b1d-4d8361813265
# ╠═b5164278-548c-11ec-0eb2-bba0ce2561de
# ╟─b516428c-548c-11ec-0015-ed08a935bd99
# ╠═b516449e-548c-11ec-1257-fd046ede761c
# ╟─b5164d4a-548c-11ec-2255-f9bb5df5dbfc
# ╟─b5164dc2-548c-11ec-0068-2f81eef7a3c7
# ╟─b5164dd8-548c-11ec-13c9-0d6f37a93ae4
# ╟─b5164e06-548c-11ec-2f97-cd57dd9aefa3
# ╟─b5164e26-548c-11ec-1587-0fc99da84195
# ╟─b5164e30-548c-11ec-1d37-5db5e1a7cf07
# ╟─b5164e44-548c-11ec-1703-91d9cf2ae2b0
# ╟─b5164e58-548c-11ec-344d-97305fe6b511
# ╟─b5164e8a-548c-11ec-185b-0b862e6c0b33
# ╟─b5164e94-548c-11ec-2cd3-43fe353d9327
# ╟─b5164e9e-548c-11ec-0e01-777797c6b255
# ╟─b5164ed0-548c-11ec-3890-4774cdc06a6c
# ╟─b5164edc-548c-11ec-21b0-0753fbb01603
# ╟─b5164eee-548c-11ec-2bf1-8bbce9a06d5a
# ╟─b5164f02-548c-11ec-0052-597d58f81ee4
# ╟─b5164f20-548c-11ec-3a8f-232629613ae5
# ╟─b5164f2a-548c-11ec-072c-830ee0702da6
# ╟─b5164f48-548c-11ec-1b24-f55d1ad8ffaa
# ╟─b5164f5c-548c-11ec-023d-0fb6d5352a7f
# ╟─b5164f6e-548c-11ec-27f8-1536cd87213b
# ╟─b51653d8-548c-11ec-34ce-3df62989e6d7
# ╟─b5165416-548c-11ec-3dd0-edf3cce9c6bd
# ╟─b5165420-548c-11ec-261d-250161b43d1e
# ╟─b5165434-548c-11ec-0176-33e26b44bbf1
# ╟─b516544a-548c-11ec-0872-3d4def7ecc33
# ╟─b5165452-548c-11ec-1328-d3d4f701e31d
# ╟─b5165466-548c-11ec-032f-291ebba1a161
# ╟─b516547c-548c-11ec-0e45-8d18e91f44cf
# ╟─b51654a2-548c-11ec-3467-83241cca74d0
# ╟─b518e8c0-548c-11ec-223b-f50f500de238
# ╟─b518e91a-548c-11ec-06dc-4dcd834ac815
# ╟─b518f40a-548c-11ec-0769-5f39f19ece7b
# ╟─b518f428-548c-11ec-2e72-1d978e392212
# ╟─b518fbf6-548c-11ec-0c16-7f273efb5fa0
# ╟─b518fc3e-548c-11ec-2024-871a50126322
# ╟─b518fc8e-548c-11ec-1893-6b90ca823e68
# ╟─b518fcac-548c-11ec-028c-21d147fac4fd
# ╟─b518fcc0-548c-11ec-0494-c1ccc60d90fb
# ╟─b518fccc-548c-11ec-38a4-0bca95172882
# ╟─b518fcf2-548c-11ec-2d52-b9a3ece04497
# ╟─b518fd1a-548c-11ec-3da7-b7f4de657cb1
# ╟─b518fd42-548c-11ec-37aa-7f37259bb002
# ╟─b518fd5e-548c-11ec-04ba-ffc40eb930dc
# ╟─b518fd74-548c-11ec-0ad5-c198d9049728
# ╟─b518fd7e-548c-11ec-2371-b3f82426a9b9
# ╟─b518fd88-548c-11ec-1690-cb459f05b31c
# ╟─b518fd9c-548c-11ec-1995-8d83a1894dbb
# ╟─b518fdba-548c-11ec-1392-71b3b29e3cda
# ╟─b518fdce-548c-11ec-047d-9986c72f5f4b
# ╟─b518fdd8-548c-11ec-2a69-ab56c5cebeea
# ╠═b519027e-548c-11ec-3615-ada60790d846
# ╟─b51902b0-548c-11ec-0410-b7d44b47212b
# ╠═b51905e4-548c-11ec-0481-158bab98b372
# ╟─b51905f8-548c-11ec-056f-c14a0a706b33
# ╟─b5190602-548c-11ec-022f-97a65532272b
# ╟─b51d5f22-548c-11ec-1d7f-a74087398d09
# ╟─b51d5fc2-548c-11ec-1625-7fb69e03e414
# ╠═b51d68aa-548c-11ec-2f91-2bd338c0f38b
# ╟─b51d68fa-548c-11ec-083e-af7d911abbe9
# ╟─b51d6f26-548c-11ec-233c-735b5977574c
# ╟─b51d6f46-548c-11ec-2806-f312f6469ea5
# ╟─b51d7494-548c-11ec-22de-b92fe6cfa9fc
# ╟─b51d74bc-548c-11ec-016a-6da2c56747a1
# ╟─b51d7728-548c-11ec-3ee6-8d19053dce3a
# ╟─b51d775a-548c-11ec-28b6-edd230db3d00
# ╟─b51d778c-548c-11ec-0a0f-8d059d65c539
# ╟─b51d7a02-548c-11ec-0104-75ebed262584
# ╟─b51d7a22-548c-11ec-3388-296db2c59642
# ╟─b51d7f02-548c-11ec-0101-d194dbf39925
# ╟─b51d7f2a-548c-11ec-3222-dbbd236c89a4
# ╟─b51d83d0-548c-11ec-0715-7139db5cc11d
# ╟─b51d83fa-548c-11ec-0a1f-73b305eb0ca7
# ╟─b51d8892-548c-11ec-351a-3fd54bd9e591
# ╟─b51d88b2-548c-11ec-053f-45a7b38f2c2c
# ╟─b51d88da-548c-11ec-1e75-d5ace7da0643
# ╟─b51d9096-548c-11ec-083f-57909765fcc3
# ╟─b51d90b4-548c-11ec-17d1-63fdd610ff3b
# ╟─b51d90e6-548c-11ec-2e0a-cbd34fa3196a
# ╟─b51d98ca-548c-11ec-3241-95d9a5102809
# ╟─b51d98e8-548c-11ec-1891-2d758b42e05b
# ╟─b51d9906-548c-11ec-0564-bde1255b8c08
# ╟─b51da222-548c-11ec-27c0-4fa4a1c1a08a
# ╟─b51da234-548c-11ec-125e-41ae0605f6d8
# ╟─b51da250-548c-11ec-0efb-21e2fc5d9e2f
# ╟─b51da282-548c-11ec-1074-ab67219acc8f
# ╟─b51da28e-548c-11ec-0f6e-0f789bc5add6
# ╟─b51daf5e-548c-11ec-0119-29bfc4dd379b
# ╟─b51daf7c-548c-11ec-08d5-9917a59bae29
# ╟─b51daf9c-548c-11ec-163b-e7d4239e1e1e
# ╟─b51db74c-548c-11ec-2c29-3513af039b9b
# ╟─b51db760-548c-11ec-385e-e3179a7f9b9d
# ╟─b51db788-548c-11ec-1f65-9b77175d330d
# ╟─b51dbf58-548c-11ec-1df5-21123860201f
# ╟─b51dbf74-548c-11ec-024e-f195ff317780
# ╟─b51dbf9e-548c-11ec-1b43-29b4f44c823c
# ╟─b51dc1ba-548c-11ec-15d8-879499d4379a
# ╟─b51dc1e0-548c-11ec-2aa4-63a18d581c76
# ╟─b51dc3ac-548c-11ec-0eb4-ed29a9f7c37f
# ╟─b51dc3e0-548c-11ec-1b89-ff1374ff3b9c
# ╟─b51dc5b8-548c-11ec-2c8a-a7bf6a996070
# ╟─b51dc5de-548c-11ec-0ed0-e3cfae1a7826
# ╟─b51dc7a0-548c-11ec-26da-45103d2ad301
# ╟─b51dc7c8-548c-11ec-216d-d98b6b5bb70f
# ╟─b51dc980-548c-11ec-3e77-89b9cccc3236
# ╟─b51dc994-548c-11ec-0ec1-3748f74438e0
# ╟─b51dd9d4-548c-11ec-05c7-f5386e99baeb
# ╟─b51dd9f2-548c-11ec-386c-c1b1fbc2e678
# ╟─b51dda1a-548c-11ec-0c00-11c048fce9d2
# ╟─b51ddede-548c-11ec-1ce0-37266408e9a7
# ╟─b51ddefc-548c-11ec-090a-f71b2245cfd0
# ╟─b51ddf1a-548c-11ec-139c-53f8f7867e10
# ╟─b51de8ca-548c-11ec-1aa1-6946f23f8839
# ╟─b51de8de-548c-11ec-10dc-a36dbed0203a
# ╟─b51de906-548c-11ec-3c01-fbf8acf3255f
# ╟─b51df1c6-548c-11ec-1ea9-dd6a5a0ddfe8
# ╟─b51df202-548c-11ec-275d-ddb50e1de9a5
# ╟─b51df234-548c-11ec-3641-a16e7a76cb87
# ╟─b51df248-548c-11ec-11c8-b3c288b62437
# ╟─b51dfa2a-548c-11ec-1879-275332464ad1
# ╟─b51dfa54-548c-11ec-3324-93711a1a8235
# ╟─b51dfbf8-548c-11ec-2265-e161117f6f46
# ╟─b51dfc20-548c-11ec-3ab1-db0a747f49c6
# ╟─b51dfd9e-548c-11ec-1f1c-b5d2be047edc
# ╟─b51dfdba-548c-11ec-36a9-a55fa73e5b27
# ╟─b51dff5e-548c-11ec-35cc-c342b7298bca
# ╟─b51dff86-548c-11ec-1b5a-29b0f9162a98
# ╟─b51dff90-548c-11ec-1484-a710322fa338
# ╟─b51dff90-548c-11ec-1ccc-410408525817
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
