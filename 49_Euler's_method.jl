### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 28b9640c-793c-11ec-24c9-0fa61a072f3b
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
end

# ╔═╡ 28b9804a-793c-11ec-0ace-d50819909ebb
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size = (600, 400)
	nothing
end

# ╔═╡ 28dca23c-793c-11ec-3f55-bd876325fbfe
using PlutoUI

# ╔═╡ 28dca214-793c-11ec-0ce1-ef8450969dcc
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 289aef88-793c-11ec-2567-d3b6c5bf13ab
md"""# Euler's method
"""

# ╔═╡ 289d9eca-793c-11ec-093c-5f1b257e2239
md"""This section uses these add-on packages:
"""

# ╔═╡ 28bba47e-793c-11ec-3deb-ab9623ec1351
md"""---
"""

# ╔═╡ 28c73ad2-793c-11ec-1021-6b00f4e906fd
md"""The following section takes up the task of numerically approximating solutions to differential equations. `Julia` has a huge set of state-of-the-art tools for this task starting with the [DifferentialEquations](https://github.com/SciML/DifferentialEquations.jl) package. We don't use that package in this section, focusing on  simpler methods and implementations for pedagogical purposes, but any further exploration should utilize the tools provided therein. A brief introduction to the package follows in an upcoming [section](./differential_equations.html).
"""

# ╔═╡ 28c73b72-793c-11ec-20ae-f5734d370d10
md"""---
"""

# ╔═╡ 28c73b90-793c-11ec-3499-575e8069531d
md"""Consider the differential equation:
"""

# ╔═╡ 28c9812a-793c-11ec-0f96-095c2a753fc7
md"""```math
y'(x) = y(x) \cdot  x, \quad y(1)=1,
```
"""

# ╔═╡ 28c981fc-793c-11ec-17a4-8f9db1840d64
md"""which can be solved with `SymPy`:
"""

# ╔═╡ 28c98c7e-793c-11ec-0d6b-a1e4b520d11d
begin
	@syms x, y, u()
	D = Differential(x)
	x0, y0 = 1, 1
	F(y,x) = y*x
	
	dsolve(D(u)(x) - F(u(x), x))
end

# ╔═╡ 28c98cb8-793c-11ec-0af9-5b99011e4795
md"""With the given initial condition, the solution becomes:
"""

# ╔═╡ 28c995ac-793c-11ec-3221-4f0a7ee260c6
out = dsolve(D(u)(x) - F(u(x),x), u(x), ics=Dict(u(x0) => y0))

# ╔═╡ 28c995d4-793c-11ec-2b86-0d8fd3af628a
md"""Plotting this solution over the slope field
"""

# ╔═╡ 28c99ac0-793c-11ec-29d4-31e0e7e21d40
begin
	p = plot(legend=false)
	vectorfieldplot!((x,y) -> [1, F(x,y)], xlims=(0, 2.5), ylims=(0, 10))
	plot!(rhs(out),  linewidth=5)
end

# ╔═╡ 28c99ade-793c-11ec-110d-9be9ae8515f9
md"""we see that the vectors that are drawn seem to be tangent to the graph of the solution. This is no coincidence, the tangent lines to integral curves are in the direction of the slope field.
"""

# ╔═╡ 28cb86d2-793c-11ec-0abe-b79f980d4600
md"""What if the graph of the solution were not there, could we use this fact to *approximately* reconstruct the solution?
"""

# ╔═╡ 28cb8718-793c-11ec-1347-818fd588a813
md"""That is, if we stitched together pieces of the slope field, would we get a curve that was close to the actual answer?
"""

# ╔═╡ 28cbd5ec-793c-11ec-286d-55bac83798d1
let
	## {{{euler_graph}}}
	function make_euler_graph(n)
	    x, y = symbols("x, y")
	    F(y,x) = y*x
	    x0, y0 = 1, 1
	
	    h = (2-1)/5
	    xs = zeros(n+1)
	    ys = zeros(n+1)
	    xs[1] = x0   # index is off by 1
	    ys[1] = y0
	    for i in 1:n
	        xs[i + 1] = xs[i] + h
	        ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
	    end
	
		p = plot(legend=false)
	    vectorfieldplot!((x,y) -> [1, F(y,x)], xlims=(1,2), ylims=(0,6))
	
	    ## Add Euler soln
	    plot!(p, xs, ys, linewidth=5)
	    scatter!(p, xs, ys)
	
	    ## add function
	    out = dsolve(u'(x) - F(u(x), x), u(x), ics=(u, x0, y0))
	    plot!(p, rhs(out), x0, xs[end], linewidth=5)
	
	    p
	end
	
	
	
	
	n = 5
	anim = @animate for i=1:n
	    make_euler_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = """
	Illustration of a function stitching together slope field lines to
	approximate the answer to an initial-value problem. The other function drawn is the actual solution.
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 28cf3c6e-793c-11ec-18ff-df72221eb040
md"""The illustration suggests the answer is yes, let's see. The solution is drawn over $x$ values $1$ to $2$. Let's try piecing together $5$ pieces between $1$ and $2$ and see what we have.
"""

# ╔═╡ 28cf3d3e-793c-11ec-1c0c-bd5faace6f20
md"""The slope-field vectors are *scaled* versions of the vector `[1, F(y,x)]`. The `1` is the part in the direction of the $x$ axis, so here we would like that to be $0.2$ (which is $(2-1)/5$. So our vectors would be `0.2 * [1, F(y,x)]`. To allow for generality, we use `h` in place of the specific value $0.2$.
"""

# ╔═╡ 28cf3d5e-793c-11ec-1e50-67c8678ad000
md"""Then our first pieces would be the line connecting $(x_0,y_0)$ to
"""

# ╔═╡ 28cf3d90-793c-11ec-383c-1f454192013e
md"""```math
\langle x_0, y_0 \rangle + h \cdot \langle 1, F(y_0, x_0) \rangle.
```
"""

# ╔═╡ 28cf3db8-793c-11ec-2c92-bfd909c79cf1
md"""The above uses vector notation to add the piece scaled by $h$ to the starting point. Rather than continue with that notation, we will use subscripts. Let $x_1$, $y_1$ be the postion of the tip of the vector. Then we have:
"""

# ╔═╡ 28cf3dc2-793c-11ec-1f5f-cd26d6b22509
md"""```math
x_1 = x_0 + h, \quad y_1 = y_0 + h F(y_0, x_0).
```
"""

# ╔═╡ 28cf3dcc-793c-11ec-1218-0314f11e8a28
md"""With this notation, it is easy to see what comes next:
"""

# ╔═╡ 28cf3de2-793c-11ec-0475-1d90891ce764
md"""```math
x_2 = x_1 + h, \quad y_2 = y_1 + h F(y_1, x_1).
```
"""

# ╔═╡ 28cf3df4-793c-11ec-01c0-afbfdd1d2f80
md"""We just shifted the indices forward by $1$. But graphically what is this? It takes the tip of the first part of our "stitched" together solution, finds the slope filed there (`[1, F(y,x)]`) and then uses this direction to stitch together one more piece.
"""

# ╔═╡ 28cf3e08-793c-11ec-084a-397fdf563790
md"""Clearly, we can repeat. The $n$th piece will end at:
"""

# ╔═╡ 28cf3e14-793c-11ec-10ec-dfcd173f0cdd
md"""```math
x_{n+1} = x_n + h, \quad y_{n+1} = y_n + h F(y_n, x_n).
```
"""

# ╔═╡ 28cf3e94-793c-11ec-32d5-1516132d87a1
md"""For our example, we can do some numerics. We want $h=0.2$ and $5$ pieces, so values of $y$ at $x_0=1, x_1=1.2, x_2=1.4, x_3=1.6, x_4=1.8,$ and $x_5=2$.
"""

# ╔═╡ 28cf3ebc-793c-11ec-0a14-470f8df1d2d5
md"""Below we do this in a loop. We have to be a bit careful, as in `Julia` the vector of zeros we create to store our answers begins indexing at $1$, and not $0$.
"""

# ╔═╡ 28cf45ce-793c-11ec-0eac-593a55f8efb8
begin
	n=5
	h = (2-1)/n
	xs = zeros(n+1)
	ys = zeros(n+1)
	xs[1] = x0   # index is off by 1
	ys[1] = y0
	for i in 1:n
	  xs[i + 1] = xs[i] + h
	  ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
	end
end

# ╔═╡ 28cf45ec-793c-11ec-1e2b-a5772a26f14a
md"""So how did we do? Let's look graphically:
"""

# ╔═╡ 28cf680e-793c-11ec-002e-51e6d3ce22df
begin
	plot(exp(-1/2)*exp(x^2/2), x0, 2)
	plot!(xs, ys)
end

# ╔═╡ 28cf686a-793c-11ec-2763-172dbc3affbd
md"""Not bad. We wouldn't expect this to be exact - due to the concavity of the solution, each step is an underestimate. However, we see it is an okay approximation and would likely be better with a smaller $h$. A topic we pursue in just a bit.
"""

# ╔═╡ 28cf68a6-793c-11ec-03a9-c776593ec560
md"""Rather than type in the above command each time, we wrap it all up in a function.  The inputs are $n$, $a=x_0$, $b=x_n$, $y_0$, and, most importantly, $F$. The output is massaged into a function through a call to `linterp`, rather than two vectors. The `linterp` function we define below just finds a function that linearly interpolates between the points and is `NaN` outside of the range of the $x$ values:
"""

# ╔═╡ 28cf848a-793c-11ec-24fd-33b55c42a330
function linterp(xs, ys)
    function(x)
        ((x < xs[1]) || (x > xs[end])) && return NaN
        for i in 1:(length(xs) - 1)
            if xs[i] <= x < xs[i+1]
                l = (x-xs[i]) / (xs[i+1] - xs[i])
                return (1-l) * ys[i] + l * ys[i+1]
            end
        end
        ys[end]
    end
end

# ╔═╡ 28cf84b2-793c-11ec-299c-ff17d18dda32
md"""With that, here is our function to find an approximate solution to $y'=F(y,x)$ with initial condition:
"""

# ╔═╡ 28cf9d76-793c-11ec-3b58-d70ddb2fb9b5
function euler(F, x0, xn, y0, n)
  h = (xn - x0)/n
  xs = zeros(n+1)
  ys = zeros(n+1)
  xs[1] = x0
  ys[1] = y0
  for i in 1:n
    xs[i + 1] = xs[i] + h
    ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
  end
  linterp(xs, ys)
end

# ╔═╡ 28cf9db2-793c-11ec-18fe-f1ac5cbd2881
md"""With `euler`, it becomes easy to explore different values.
"""

# ╔═╡ 28cf9dda-793c-11ec-0771-31300623b00a
md"""For example, we thought the solution would look better with a smaller $h$ (or larger $n$). Instead of $n=5$, let's try $n=50$:
"""

# ╔═╡ 28cfa35c-793c-11ec-1576-0ba77b9564d2
begin
	u₁₂ = euler(F, 1, 2, 1, 50)
	plot(exp(-1/2)*exp(x^2/2), x0, 2)
	plot!(u₁₂, x0, 2)
end

# ╔═╡ 28cfa370-793c-11ec-1694-bf8c37d63b00
md"""It is more work for the computer, but not for us, and clearly a much better approximation to the actual answer is found.
"""

# ╔═╡ 28d27c62-793c-11ec-0f79-3104fa8798f2
md"""## The Euler method
"""

# ╔═╡ 28d28446-793c-11ec-19a3-b11dba536d11
let
	imgfile ="figures/euler.png"
	caption = """
	Figure from first publication of Euler's method. From [Gander and Wanner](http://www.unige.ch/~gander/Preprints/Ritz.pdf).
	"""
	
	ImageFile(:ODEs, imgfile, caption)
end

# ╔═╡ 28d3c8c4-793c-11ec-3581-df58af785da4
md"""The name of our function reflects the [mathematician](https://en.wikipedia.org/wiki/Leonhard_Euler) associated with the iteration:
"""

# ╔═╡ 28d3c928-793c-11ec-1f7e-892acd6c3f59
md"""```math
x_{n+1} = x_n + h, \quad y_{n+1} = y_n + h \cdot F(y_n, x_n),
```
"""

# ╔═╡ 28d3c982-793c-11ec-1f53-edfe72931313
md"""to approximate a solution to the first-order, ordinary differential equation with initial values: $y'(x) = F(y,x)$.
"""

# ╔═╡ 28d52192-793c-11ec-1e83-17930b5a169b
md"""[The Euler method](https://en.wikipedia.org/wiki/Euler_method) uses linearization. Each "step" is just an approximation of the function value $y(x_{n+1})$ with the value from the tangent line tangent to the point $(x_n, y_n)$.
"""

# ╔═╡ 28d52214-793c-11ec-22a6-cfaac18137e8
md"""Each step introduces an error. The error in one step is known as the *local truncation error* and can be shown to be about equal to $1/2 \cdot h^2 \cdot f''(x_{n})$ assuming $y$ has $3$ or more derivatives.
"""

# ╔═╡ 28d52250-793c-11ec-1ba7-fde89791bfe3
md"""The total error, or more commonly, *global truncation error*, is the error between the actual answer and the approximate answer at the end of the process. It reflects an accumulation of these local errors. This error is *bounded* by a constant times $h$. Since it gets smaller as $h$ gets smaller in direct proportion, the Euler method is called *first order*.
"""

# ╔═╡ 28d52282-793c-11ec-03ed-ad650b552bc4
md"""Other, somewhat more complicated, methods have global truncation errors that involve higher powers of $h$ - that is for the same size $h$, the error is smaller. In analogy is the fact that Riemann sums have error that depends on $h$, whereas other methods of approximating the integral have smaller errors. For example, Simpson's rule had error related to $h^4$. So, the Euler method may not be employed if there is concern about total resources (time, computer, ...), it is important for theoretical purposes in a manner similar to the role of the Riemann integral.
"""

# ╔═╡ 28d52296-793c-11ec-2a32-f51939d8a467
md"""In the examples, we will see that for many problems the simple Euler method is satisfactory, but not always so. The task of numerically solving differential equations is not a one-size-fits-all one. In the following, a few different modifications are presented to the basic Euler method, but this just scratches the surface of the topic.
"""

# ╔═╡ 28d8377e-793c-11ec-0d15-214dd76f0109
md"""#### Examples
"""

# ╔═╡ 28db3046-793c-11ec-24a9-29209b34d9ec
md"""##### Example
"""

# ╔═╡ 28db30f0-793c-11ec-24e4-639d02821990
md"""Consider the initial value problem $y'(x) = x + y(x)$ with initial condition $y(0)=1$. This problem can be solved exactly. Here we approximate over $[0,2]$ using Euler's method.
"""

# ╔═╡ 28db38ea-793c-11ec-25c2-69578e0aa59e
begin
	𝑭(y,x) = x + y
	𝒙0, 𝒙n, 𝒚0 = 0, 2, 1
	𝒇 = euler(𝑭, 𝒙0, 𝒙n, 𝒚0, 25)
	𝒇(𝒙n)
end

# ╔═╡ 28db3910-793c-11ec-12af-2f2705999bd0
md"""We graphically compare our approximate answer with the exact one:
"""

# ╔═╡ 28db3cf8-793c-11ec-2218-adefb3218076
begin
	plot(𝒇, 𝒙0, 𝒙n)
	𝒐ut = dsolve(D(u)(x) - 𝑭(u(x),x), u(x), ics = Dict(u(𝒙0) => 𝒚0))
	plot(rhs(𝒐ut), 𝒙0, 𝒙n)
	plot!(𝒇, 𝒙0, 𝒙n)
end

# ╔═╡ 28db3d2a-793c-11ec-3033-9f593e559abd
md"""From the graph it appears our value for `f(xn)` will underestimate the actual value of the solution slightly.
"""

# ╔═╡ 28db3d54-793c-11ec-3b7c-9765d1ce077a
md"""##### Example
"""

# ╔═╡ 28db3d8e-793c-11ec-3487-bf7f14976d42
md"""The equation $y'(x) = \sin(x \cdot y)$ is not separable, so need not have an easy solution. The default method will fail. Looking at the available methods with `sympy.classify_ode(𝐞qn, u(x))` shows a power series method which can return a power series *approximation* (a Taylor polynomial). Let's look at comparing an approximate answer given by the Euler method to that one returned by `SymPy`.
"""

# ╔═╡ 28db3dac-793c-11ec-2ca9-418633ca97cc
md"""First, the `SymPy` solution:
"""

# ╔═╡ 28db53d0-793c-11ec-350f-37dd837cb762
begin
	𝐅(y,x) = sin(x*y)
	𝐞qn = D(u)(x) - 𝐅(u(x), x)
	𝐨ut = dsolve(𝐞qn, hint="1st_power_series")
end

# ╔═╡ 28db5436-793c-11ec-1def-5bdaf12cd9c7
md"""If we assume $y(0) = 1$, we can continue:
"""

# ╔═╡ 28db5daa-793c-11ec-177e-ab4145e872fa
𝐨ut1 = dsolve(𝐞qn, u(x), ics=Dict(u(0) => 1), hint="1st_power_series")

# ╔═╡ 28db5dd2-793c-11ec-220e-8313cc4507b3
md"""The approximate value given by the Euler method is
"""

# ╔═╡ 28db648a-793c-11ec-351e-0331e027521f
begin
	𝐱0, 𝐱n, 𝐲0 = 0, 2, 1
	
	plot(legend=false)
	vectorfieldplot!((x,y) -> [1, 𝐅(y,x)], xlims=(𝐱0, 𝐱n), ylims=(0,5))
	plot!(rhs(𝐨ut1).removeO(),  linewidth=5)
	
	𝐮 = euler(𝐅, 𝐱0, 𝐱n, 𝐲0, 10)
	plot!(𝐮, linewidth=5)
end

# ╔═╡ 28db64c6-793c-11ec-12a5-a1bae49cc6cf
md"""We see that the answer found from using a polynomial series matches that of Euler's method for a bit, but as time evolves, the approximate solution given by Euler's method more closely tracks the slope field.
"""

# ╔═╡ 28db64f8-793c-11ec-0838-4f23a485fb3d
md"""##### Example
"""

# ╔═╡ 28db6548-793c-11ec-3d24-5504f435803a
md"""The [Brachistochrone problem](http://www.unige.ch/~gander/Preprints/Ritz.pdf) was posed by Johann Bernoulli in 1696. It asked for the curve between two points for which an object will fall faster along that curve than any other. For an example, a bead sliding on a wire will take  a certain amount of time to get from point $A$ to point $B$, the time depending on the shape of the wire. Which shape will take the least amount  of time?
"""

# ╔═╡ 28db6a7a-793c-11ec-0e6f-0d8b14f7723c
let
	imgfile = "figures/bead-game.jpg"
	caption = """
	
	A child's bead game. What shape wire will produce the shortest time for a bed to slide from a top to the bottom?
	
	"""
	ImageFile(:ODEs, imgfile, caption)
end

# ╔═╡ 28db6ad4-793c-11ec-2944-c73fc3f851cb
md"""Restrict our attention to the $x$-$y$ plane, and consider a path, between the point $(0,A)$ and $(B,0)$. Let $y(x)$ be the distance from $A$, so $y(0)=0$ and at the end $y$ will be $A$.
"""

# ╔═╡ 28db6afc-793c-11ec-1720-d9e6ab959781
md"""[Galileo](http://www-history.mcs.st-and.ac.uk/HistTopics/Brachistochrone.html) knew the straight line was not the curve, but incorrectly thought the answer was a part of a circle.
"""

# ╔═╡ 28db6f8e-793c-11ec-0074-c78acac29cdb
let
	imgfile = "figures/galileo.gif"
	caption = """
	As early as 1638, Galileo showed that an object falling along `AC` and then `CB` will fall faster than one traveling along `AB`, where `C` is on the arc of a circle.
	From the [History of Math Archive](http://www-history.mcs.st-and.ac.uk/HistTopics/Brachistochrone.html).
	"""
	ImageFile(:ODEs, imgfile, caption)
end

# ╔═╡ 28db6fac-793c-11ec-0624-292fa0c2cae9
md"""This simulation also suggests that a curved path is better than the shorter straight one:
"""

# ╔═╡ 28dbc240-793c-11ec-312a-4b724510071d
let
	##{{{brach_graph}}}
	
	function brach(f, x0, vx0, y0, vy0, dt, n)
	    m = 1
	    g = 9.8
	
	    axs = Float64[0]
	    ays = Float64[-g]
	    vxs = Float64[vx0]
	    vys = Float64[vy0]
	    xs = Float64[x0]
	    ys = Float64[y0]
	
	    for i in 1:n
	        x = xs[end]
	        vx = vxs[end]
	
	        ax = -f'(x) * (f''(x) * vx^2 + g) / (1 + f'(x)^2)
	        ay = f''(x) * vx^2 + f'(x) * ax
	
	        push!(axs, ax)
	        push!(ays, ay)
	
	        push!(vxs, vx + ax * dt)
	        push!(vys, vys[end] + ay * dt)
	        push!(xs, x       + vxs[end] * dt)# + (1/2) * ax * dt^2)
	        push!(ys, ys[end] + vys[end] * dt)# + (1/2) * ay * dt^2)
	    end
	
	    [xs ys vxs vys axs ays]
	
	end
	
	
	fs = [x -> 1 - x,
	      x -> (x-1)^2,
	      x -> 1 - sqrt(1 - (x-1)^2),
	      x ->  - (x-1)*(x+1),
	      x -> 3*(x-1)*(x-1/3)
	      ]
	
	
	MS = [brach(f, 1/100, 0, 1, 0, 1/100, 100) for f in fs]
	
	
	function make_brach_graph(n)
	
	    p = plot(xlim=(0,1), ylim=(-1/3, 1), legend=false)
	    for (i,f) in enumerate(fs)
	        plot!(f, 0, 1)
	        U = MS[i]
	        x = min(1.0, U[n,1])
	        scatter!(p, [x], [f(x)])
	    end
	    p
	
	end
	
	
	
	n = 4
	anim = @animate for i=[1,5,10,15,20,25,30,35,40,45,50,55,60]
	    make_brach_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = """
	The race is on. An illustration of beads falling along a path, as can be seen, some paths are faster than others. The fastest path would follow a cycloid. See [Bensky and Moelter](https://pdfs.semanticscholar.org/66c1/4d8da6f2f5f2b93faf4deb77aafc7febb43a.pdf) for details on simulating a bead on a wire.
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 28dbc2e0-793c-11ec-0fe4-77eccc0e9a8a
md"""Now, the natural question is which path is best?  The solution can be [reduced](http://mathworld.wolfram.com/BrachistochroneProblem.html) to solving this equation for a positive $c$:
"""

# ╔═╡ 28dbc308-793c-11ec-2d72-cdf6635a9615
md"""```math
1 + (y'(x))^2  = \frac{c}{y}, \quad c > 0.
```
"""

# ╔═╡ 28dbc31c-793c-11ec-2118-3b4b454dad9e
md"""Reexpressing, this becomes:
"""

# ╔═╡ 28dbc326-793c-11ec-1850-57b520feb00b
md"""```math
\frac{dy}{dx} = \sqrt{\frac{C-y}{y}}.
```
"""

# ╔═╡ 28dbc34e-793c-11ec-05f4-35e8983be820
md"""This is a separable equation and can be solved, but even `SymPy` has trouble with this integral. However, the result has been known to be a piece of a cycloid since the insightful Jacob Bernoulli used an analogy from light bending to approach the problem. The answer is best described parametrically through:
"""

# ╔═╡ 28dbc358-793c-11ec-2fb5-5525d56bba82
md"""```math
x(u) = c\cdot u - \frac{c}{2}\sin(2u), \quad y(u) = \frac{c}{2}( 1- \cos(2u)), \quad 0 \leq u \leq U.
```
"""

# ╔═╡ 28dbc380-793c-11ec-246e-cf0bf729a798
md"""The values of $U$ and $c$ must satisfy $(x(U), y(U)) = (B, A)$.
"""

# ╔═╡ 28dbc394-793c-11ec-0ef8-b34b947c9238
md"""Rather than pursue this, we will solve it numerically for a fixed value of $C$ over a fixed interval to see the shape.
"""

# ╔═╡ 28dbc3a0-793c-11ec-1cf4-93dac8aa113b
md"""The equation can be written in terms of $y'=F(y,x)$, where
"""

# ╔═╡ 28dbc3b2-793c-11ec-0546-237cdb9c3eb5
md"""```math
F(y,x) = \sqrt{\frac{c-y}{y}}.
```
"""

# ╔═╡ 28dbc3c6-793c-11ec-2dd4-e1903f3e7e38
md"""But as $y_0 = 0$, we immediately would have a problem with the first step, as there would be division by $0$.
"""

# ╔═╡ 28dbc3e4-793c-11ec-255c-1dd929f3959e
md"""This says that for the optimal solution, the bead picks up speed by first sliding straight down before heading off towards $B$. That's great for the physics, but runs roughshod over our Euler method, as the first step has an infinity.
"""

# ╔═╡ 28dbc40c-793c-11ec-3c5a-c995d18c21a4
md"""For this, we can try the *backwards Euler* method which uses the slope at $(x_{n+1}, y_{n+1})$, rather than $(x_n, y_n)$. The update step becomes:
"""

# ╔═╡ 28dbc416-793c-11ec-353b-9375ba6f31ee
md"""```math
y_{n+1} = y_n + h \cdot F(y_{n+1}, x_{n+1}).
```
"""

# ╔═╡ 28dbc43e-793c-11ec-0a05-1ba08a9a1b21
md"""Seems innocuous, but the value we are trying to find, $y_{n+1}$, is now on both sides of the equation, so is only *implicitly* defined. In this code, we use the `find_zero` function from the `Roots` package. The caveat is, this function needs a good initial guess, and the one we use below need not be widely applicable.
"""

# ╔═╡ 28dbe180-793c-11ec-16aa-8bb43dadda3a
function back_euler(F, x0, xn, y0, n)
    h = (xn - x0)/n
    xs = zeros(n+1)
    ys = zeros(n+1)
    xs[1] = x0
    ys[1] = y0
    for i in 1:n
        xs[i + 1] = xs[i] + h
        ## solve y[i+1] = y[i] + h * F(y[i+1], x[i+1])
        ys[i + 1] = find_zero(y -> ys[i] + h * F(y, xs[i + 1]) - y, ys[i]+h)
    end
  linterp(xs, ys)
end

# ╔═╡ 28dbe1bc-793c-11ec-1adc-ad729ba13087
md"""We then have with $C=1$ over the interval $[0,1.2]$ the following:
"""

# ╔═╡ 28dbea18-793c-11ec-1947-f3914aa2b8d9
begin
	𝐹(y, x; C=1) = sqrt(C/y - 1)
	𝑥0, 𝑥n, 𝑦0 = 0, 1.2, 0
	cyc = back_euler(𝐹, 𝑥0, 𝑥n, 𝑦0, 50)
	plot(x -> 1 - cyc(x), 𝑥0, 𝑥n)
end

# ╔═╡ 28dbea54-793c-11ec-1484-e12ce2ee1067
md"""Remember, $y$ is the displacement from the top, so it is non-negative. Above we flipped the graph to make it look more like expectation. In general, the trajectory may actually dip below the ending point and come back up. The above won't see this, for as written $dy/dx \geq 0$, which need not be the case, as the defining equation is in terms of $(dy/dx)^2$, so the derivative could have any sign.
"""

# ╔═╡ 28dbea72-793c-11ec-02a6-75b07422b094
md"""##### Example: stiff equations
"""

# ╔═╡ 28dbeaae-793c-11ec-2832-b134ffa804ed
md"""The Euler method is *convergent*, in that as $h$ goes to $0$, the approximate solution will converge to the actual answer. However, this does not say that for a fixed size $h$, the approximate value will be good. For example, consider the differential equation $y'(x) = -5y$. This has solution $y(x)=y_0 e^{-5x}$. However, if we try the Euler method to get an answer over $[0,2]$ with $h=0.5$ we don't see this:
"""

# ╔═╡ 28dbef9a-793c-11ec-3cb0-7fa5ade2b8f6
begin
	ℱ(y,x) = -5y
	𝓍0, 𝓍n, 𝓎0 = 0, 2, 1
	𝓊 = euler(ℱ, 𝓍0, 𝓍n, 𝓎0, 4)     # n =4 => h = 2/4
	vectorfieldplot((x,y) -> [1, ℱ(y,x)], xlims=(0, 2), ylims=(-5, 5))
	plot!(x -> y0 * exp(-5x), 0, 2, linewidth=5)
	plot!(𝓊, 0, 2, linewidth=5)
end

# ╔═╡ 28dbefd4-793c-11ec-2523-89304a8709ab
md"""What we see is that the value of $h$ is too big to capture the decay scale of the solution. A smaller $h$, can do much better:
"""

# ╔═╡ 28dc1362-793c-11ec-3f93-6f33710bb69d
begin
	𝓊₁ = euler(ℱ, 𝓍0, 𝓍n, 𝓎0, 50)    # n=50 => h = 2/50
	plot(x -> y0 * exp(-5x), 0, 2)
	plot!(𝓊₁, 0, 2)
end

# ╔═╡ 28dc13da-793c-11ec-251a-67b6878a57f9
md"""This is an example of a [stiff equation](https://en.wikipedia.org/wiki/Stiff_equation). Such equations cause explicit methods like the Euler one problems, as small $h$s are needed to good results.
"""

# ╔═╡ 28dc13ee-793c-11ec-272e-2789dd8e11be
md"""The implicit, backward Euler method does not have this issue, as we can see here:
"""

# ╔═╡ 28dc1952-793c-11ec-3ec6-c1cc687574f9
begin
	𝓊₂ = back_euler(ℱ, 𝓍0, 𝓍n, 𝓎0, 4)     # n =4 => h = 2/4
	vectorfieldplot((x,y) -> [1, ℱ(y,x)],  xlims=(0, 2), ylims=(-1, 1))
	plot!(x -> y0 * exp(-5x), 0, 2, linewidth=5)
	plot!(𝓊₂, 0, 2, linewidth=5)
end

# ╔═╡ 28dc197a-793c-11ec-04b8-c54aadad6a0a
md"""##### Example: The pendulum
"""

# ╔═╡ 28dc1984-793c-11ec-3caf-41ecfbe292cf
md"""The differential equation describing the simple pendulum is
"""

# ╔═╡ 28dc19a2-793c-11ec-2b1e-bdd89b7e8aae
md"""```math
\theta''(t) = - \frac{g}{l}\sin(\theta(t)).
```
"""

# ╔═╡ 28dc19ca-793c-11ec-1fa9-4b58078553c2
md"""The typical approach to solving for $\theta(t)$ is to use the small-angle approximation that $\sin(x) \approx x$, and then the differential equation simplifies to: $\theta''(t) = -g/l \cdot \theta(t)$, which is easily solved.
"""

# ╔═╡ 28dc19fc-793c-11ec-11f0-a3bfeb56dc44
md"""Here we try to get an answer numerically. However, the problem, as stated, is not a first order equation due to the $\theta''(t)$ term. If we let $u(t) = \theta(t)$ and $v(t) = \theta'(t)$, then we get *two* coupled first order equations:
"""

# ╔═╡ 28dc1a12-793c-11ec-23e4-8fb5045a2e4b
md"""```math
v'(t) = -g/l \cdot \sin(u(t)), \quad u'(t) = v(t).
```
"""

# ╔═╡ 28dc1a24-793c-11ec-12a3-67ba48358d90
md"""We can try the Euler method here. A simple approach might be this iteration scheme:
"""

# ╔═╡ 28dc1a2e-793c-11ec-2cf9-5d36fba0bdc5
md"""```math
\begin{align*}
x_{n+1} &= x_n + h,\\
u_{n+1} &= u_n + h v_n,\\
v_{n+1} &= v_n - h \cdot g/l \cdot \sin(u_n).
\end{align*}
```
"""

# ╔═╡ 28dc1a72-793c-11ec-3484-a7cdf80dfc5c
md"""Here we need *two* initial conditions: one for the initial value $u(t_0)$ and the initial value of $u'(t_0)$. We have seen if we start at an angle $a$ and release the bob from rest, so $u'(0)=0$ we get a sinusoidal answer to the linearized model. What happens here? We let $a=1$, $L=5$ and $g=9.8$:
"""

# ╔═╡ 28dc1a9c-793c-11ec-0a9b-bdc23435a1a0
md"""We write a function to solve this starting from $(x_0, y_0)$ and ending at $x_n$:
"""

# ╔═╡ 28dc4468-793c-11ec-2a67-418ef9a3e0a5
function euler2(x0, xn, y0, yp0, n; g=9.8, l = 5)
  xs, us, vs = zeros(n+1), zeros(n+1), zeros(n+1)
  xs[1], us[1], vs[1] = x0, y0, yp0
  h = (xn - x0)/n
  for i = 1:n
    xs[i+1] = xs[i] + h
	us[i+1] = us[i] + h * vs[i]
	vs[i+1] = vs[i] + h * (-g / l) * sin(us[i])
	end
	linterp(xs, us)
end

# ╔═╡ 28dc44cc-793c-11ec-3ec5-a5c4459f25df
md"""Let's take $a = \pi/4$ as the initial angle, then the approximate solution should be $\pi/4\cos(\sqrt{g/l}x)$ with period $T = 2\pi\sqrt{l/g}$. We try first to plot then over 4 periods:
"""

# ╔═╡ 28dc6178-793c-11ec-32b6-dfba225712b5
begin
	𝗅, 𝗀 = 5, 9.8
	𝖳 = 2pi * sqrt(𝗅/𝗀)
	𝗑0, 𝗑n, 𝗒0, 𝗒p0 = 0, 4𝖳, pi/4, 0
	plot(euler2(𝗑0, 𝗑n, 𝗒0, 𝗒p0, 20), 0, 4𝖳)
end

# ╔═╡ 28dc61dc-793c-11ec-1157-f14916fd1c8b
md"""Something looks terribly amiss. The issue is the step size, $h$, is too large to capture the oscillations. There are basically only $5$ steps to capture a full up and down motion. Instead, we try to get $20$ steps per period so $n$ must be not $20$, but $4 \cdot 20 \cdot T \approx 360$. To this graph, we add the approximate one:
"""

# ╔═╡ 28dc6916-793c-11ec-3d37-c5d4ad938ab5
begin
	plot(euler2(𝗑0, 𝗑n, 𝗒0, 𝗒p0, 360), 0, 4𝖳)
	plot!(x -> pi/4*cos(sqrt(𝗀/𝗅)*x), 0, 4𝖳)
end

# ╔═╡ 28dc693e-793c-11ec-2178-930d1bed28fd
md"""Even now, we still see that something seems amiss, though the issue is not as dramatic as before. The oscillatory nature of the pendulum is seen, but in the Euler solution, the amplitude grows, which would necessarily mean energy is being put into the system.  A familiar instance of a pendulum would be a child on a swing. Without pumping the legs - putting energy in the system - the height of the swing's arc will not grow.  Though we now have oscillatory motion, this growth indicates the solution is still not quite right. The issue is likely due to each step mildly overcorrecting and resulting in an overall growth.  One of the questions pursues this a bit further.
"""

# ╔═╡ 28dc697c-793c-11ec-3574-3111e806f176
md"""## Questions
"""

# ╔═╡ 28dc698e-793c-11ec-1323-31d3b2de9e16
md"""##### Question
"""

# ╔═╡ 28dc69c0-793c-11ec-0627-7372c704da03
md"""Use Euler's method with $n=5$ to approximate $u(1)$ where
"""

# ╔═╡ 28dc69f2-793c-11ec-3747-b1d1295f5ae5
md"""```math
u'(x) = x - u(x), \quad u(0) = 1
```
"""

# ╔═╡ 28dc6e8e-793c-11ec-09f2-8333540c5b1b
let
	F(y,x) = x - y
	x0, xn, y0 = 0, 1, 1
	val = euler(F, x0, xn, y0, 5)(1)
	numericq(val)
end

# ╔═╡ 28dc6eb8-793c-11ec-37ff-155c3b558bf9
md"""##### Question
"""

# ╔═╡ 28dc6ec0-793c-11ec-0284-036ae44ffc54
md"""Consider the equation
"""

# ╔═╡ 28dc6ed4-793c-11ec-02a1-15c83753214a
md"""```math
y' = x \cdot \sin(y), \quad y(0) = 1.
```
"""

# ╔═╡ 28dc6ef2-793c-11ec-3f48-bb63d744e3b3
md"""Use Euler's method with $n=50$ to find the value of $y(5)$.
"""

# ╔═╡ 28dc7366-793c-11ec-1b6b-5d0b1ea7efa4
let
	F(y, x) = x * sin(y)
	x0, xn, y0 = 0, 5, 1
	n = 50
	u = euler(F, x0, xn, y0, n)
	numericq(u(xn))
end

# ╔═╡ 28dc737a-793c-11ec-21ca-f9305dfa83ed
md"""##### Question
"""

# ╔═╡ 28dc738e-793c-11ec-3a80-bfe192a1bf64
md"""Consider the ordinary differential equation
"""

# ╔═╡ 28dc73a2-793c-11ec-2f14-bd09f81fd3c6
md"""```math
\frac{dy}{dx} = 1 - 2\frac{y}{x}, \quad y(1) = 0.
```
"""

# ╔═╡ 28dc73c0-793c-11ec-1a87-f1a1d0cd58d1
md"""Use Euler's method to solve for $y(2)$ when $n=50$.
"""

# ╔═╡ 28dc796a-793c-11ec-3e42-49af9ba70944
let
	F(y, x) = 1 - 2y/x
	x0, xn, y0 = 1, 2, 0
	n = 50
	u = euler(F, x0, xn, y0, n)
	numericq(u(xn))
end

# ╔═╡ 28dc797e-793c-11ec-38a5-d9b967baa388
md"""##### Question
"""

# ╔═╡ 28dc7988-793c-11ec-3a5d-bd71d55a1bf5
md"""Consider the ordinary differential equation
"""

# ╔═╡ 28dc79a6-793c-11ec-225e-4990e6e2b1f2
md"""```math
\frac{dy}{dx} = \frac{y \cdot \log(y)}{x}, \quad y(2) = e.
```
"""

# ╔═╡ 28dc79ba-793c-11ec-0b1c-f1c21946dc51
md"""Use Euler's method to solve for $y(3)$ when $n=25$.
"""

# ╔═╡ 28dc7ece-793c-11ec-3743-6fa76e2013d3
let
	F(y, x) = y*log(y)/x
	x0, xn, y0 = 2, 3, exp(1)
	n = 25
	u = euler(F, x0, xn, y0, n)
	numericq(u(xn))
end

# ╔═╡ 28dc7eec-793c-11ec-03f9-d1bd4d9e6b8f
md"""##### Question
"""

# ╔═╡ 28dc7f00-793c-11ec-29f7-b9d95dee1a73
md"""Consider the first-order non-linear ODE
"""

# ╔═╡ 28dc7f0a-793c-11ec-024e-fb64bf289416
md"""```math
y' = y \cdot (1-2x), \quad y(0) = 1.
```
"""

# ╔═╡ 28dc7f34-793c-11ec-3a0c-d554b711d8ff
md"""Use Euler's method with $n=50$ to approximate the solution $y$ over $[0,2]$.
"""

# ╔═╡ 28dc7f46-793c-11ec-3e1d-ef72a86ddf36
md"""What is the value at $x=1/2$?
"""

# ╔═╡ 28dc8540-793c-11ec-10de-bd9fa6250f97
let
	F(y, x) = y * (1-2x)
	x0, xn, y0 = 0, 2, 1
	n = 50
	u = euler(F, x0, xn, y0, n)
	numericq(u(1/2))
end

# ╔═╡ 28dc855e-793c-11ec-0b0b-2bf392489552
md"""What is the value at $x=3/2$?
"""

# ╔═╡ 28dc8c02-793c-11ec-30b9-e5d36d9c56a4
let
	F(y, x) = y * (1-2x)
	x0, xn, y0 = 0, 2, 1
	n = 50
	u = euler(F, x0, xn, y0, n)
	numericq(u(3/2))
end

# ╔═╡ 28dc8c20-793c-11ec-251e-5f2286b48ff3
md"""##### Question: The pendulum revisited.
"""

# ╔═╡ 28dc8c7a-793c-11ec-33b2-0b54fb4e04a2
md"""The issue with the pendulum's solution growing in amplitude can be addressed using a modification to the Euler method attributed to [Cromer](http://astro.physics.ncsu.edu/urca/course_files/Lesson14/index.html). The fix is to replace the term `sin(us[i])` in the line `vs[i+1] = vs[i] + h * (-g / l) * sin(us[i])` of the `euler2` function with `sin(us[i+1])`, which uses the updated angular velocity in the $2$nd step in place of the value before the step.
"""

# ╔═╡ 28dc8c8e-793c-11ec-1e0d-3108c4ca4a1d
md"""Modify the `euler2` function to implement the Euler-Cromer method. What do you see?
"""

# ╔═╡ 28dca20a-793c-11ec-39e4-f5ee7c7aa881
let
	choices = [
	"The same as before - the amplitude grows",
	"The solution is identical to that of the approximation found by linearization of the sine term",
	"The solution has a constant amplitude, but its period is slightly *shorter* than that of the approximate solution found by linearization",
	"The solution has a constant amplitude, but its period is slightly *longer* than that of the approximate solution found by linearization"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 28dca232-793c-11ec-110e-4f1fd79c926e
HTML("""<div class="markdown"><blockquote>
<p><a href="../ODEs/odes.html">◅ previous</a>  <a href="../ODEs/solve.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/ODEs/euler.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 28dca23c-793c-11ec-3a05-5de186027847
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
Roots = "~1.3.14"
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
git-tree-sha1 = "6e39c91fb4b84dcb870813c91674bdebb9145895"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.5"

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
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

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
git-tree-sha1 = "2ae4fe21e97cd13efd857462c1869b73c9f61be3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.2"

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
# ╟─28dca214-793c-11ec-0ce1-ef8450969dcc
# ╟─289aef88-793c-11ec-2567-d3b6c5bf13ab
# ╟─289d9eca-793c-11ec-093c-5f1b257e2239
# ╠═28b9640c-793c-11ec-24c9-0fa61a072f3b
# ╟─28b9804a-793c-11ec-0ace-d50819909ebb
# ╟─28bba47e-793c-11ec-3deb-ab9623ec1351
# ╟─28c73ad2-793c-11ec-1021-6b00f4e906fd
# ╟─28c73b72-793c-11ec-20ae-f5734d370d10
# ╟─28c73b90-793c-11ec-3499-575e8069531d
# ╟─28c9812a-793c-11ec-0f96-095c2a753fc7
# ╟─28c981fc-793c-11ec-17a4-8f9db1840d64
# ╠═28c98c7e-793c-11ec-0d6b-a1e4b520d11d
# ╟─28c98cb8-793c-11ec-0af9-5b99011e4795
# ╠═28c995ac-793c-11ec-3221-4f0a7ee260c6
# ╟─28c995d4-793c-11ec-2b86-0d8fd3af628a
# ╠═28c99ac0-793c-11ec-29d4-31e0e7e21d40
# ╟─28c99ade-793c-11ec-110d-9be9ae8515f9
# ╟─28cb86d2-793c-11ec-0abe-b79f980d4600
# ╟─28cb8718-793c-11ec-1347-818fd588a813
# ╟─28cbd5ec-793c-11ec-286d-55bac83798d1
# ╟─28cf3c6e-793c-11ec-18ff-df72221eb040
# ╟─28cf3d3e-793c-11ec-1c0c-bd5faace6f20
# ╟─28cf3d5e-793c-11ec-1e50-67c8678ad000
# ╟─28cf3d90-793c-11ec-383c-1f454192013e
# ╟─28cf3db8-793c-11ec-2c92-bfd909c79cf1
# ╟─28cf3dc2-793c-11ec-1f5f-cd26d6b22509
# ╟─28cf3dcc-793c-11ec-1218-0314f11e8a28
# ╟─28cf3de2-793c-11ec-0475-1d90891ce764
# ╟─28cf3df4-793c-11ec-01c0-afbfdd1d2f80
# ╟─28cf3e08-793c-11ec-084a-397fdf563790
# ╟─28cf3e14-793c-11ec-10ec-dfcd173f0cdd
# ╟─28cf3e94-793c-11ec-32d5-1516132d87a1
# ╟─28cf3ebc-793c-11ec-0a14-470f8df1d2d5
# ╠═28cf45ce-793c-11ec-0eac-593a55f8efb8
# ╟─28cf45ec-793c-11ec-1e2b-a5772a26f14a
# ╠═28cf680e-793c-11ec-002e-51e6d3ce22df
# ╟─28cf686a-793c-11ec-2763-172dbc3affbd
# ╟─28cf68a6-793c-11ec-03a9-c776593ec560
# ╠═28cf848a-793c-11ec-24fd-33b55c42a330
# ╟─28cf84b2-793c-11ec-299c-ff17d18dda32
# ╠═28cf9d76-793c-11ec-3b58-d70ddb2fb9b5
# ╟─28cf9db2-793c-11ec-18fe-f1ac5cbd2881
# ╟─28cf9dda-793c-11ec-0771-31300623b00a
# ╠═28cfa35c-793c-11ec-1576-0ba77b9564d2
# ╟─28cfa370-793c-11ec-1694-bf8c37d63b00
# ╟─28d27c62-793c-11ec-0f79-3104fa8798f2
# ╟─28d28446-793c-11ec-19a3-b11dba536d11
# ╟─28d3c8c4-793c-11ec-3581-df58af785da4
# ╟─28d3c928-793c-11ec-1f7e-892acd6c3f59
# ╟─28d3c982-793c-11ec-1f53-edfe72931313
# ╟─28d52192-793c-11ec-1e83-17930b5a169b
# ╟─28d52214-793c-11ec-22a6-cfaac18137e8
# ╟─28d52250-793c-11ec-1ba7-fde89791bfe3
# ╟─28d52282-793c-11ec-03ed-ad650b552bc4
# ╟─28d52296-793c-11ec-2a32-f51939d8a467
# ╟─28d8377e-793c-11ec-0d15-214dd76f0109
# ╟─28db3046-793c-11ec-24a9-29209b34d9ec
# ╟─28db30f0-793c-11ec-24e4-639d02821990
# ╠═28db38ea-793c-11ec-25c2-69578e0aa59e
# ╟─28db3910-793c-11ec-12af-2f2705999bd0
# ╠═28db3cf8-793c-11ec-2218-adefb3218076
# ╟─28db3d2a-793c-11ec-3033-9f593e559abd
# ╟─28db3d54-793c-11ec-3b7c-9765d1ce077a
# ╟─28db3d8e-793c-11ec-3487-bf7f14976d42
# ╟─28db3dac-793c-11ec-2ca9-418633ca97cc
# ╠═28db53d0-793c-11ec-350f-37dd837cb762
# ╟─28db5436-793c-11ec-1def-5bdaf12cd9c7
# ╠═28db5daa-793c-11ec-177e-ab4145e872fa
# ╟─28db5dd2-793c-11ec-220e-8313cc4507b3
# ╠═28db648a-793c-11ec-351e-0331e027521f
# ╟─28db64c6-793c-11ec-12a5-a1bae49cc6cf
# ╟─28db64f8-793c-11ec-0838-4f23a485fb3d
# ╟─28db6548-793c-11ec-3d24-5504f435803a
# ╟─28db6a7a-793c-11ec-0e6f-0d8b14f7723c
# ╟─28db6ad4-793c-11ec-2944-c73fc3f851cb
# ╟─28db6afc-793c-11ec-1720-d9e6ab959781
# ╟─28db6f8e-793c-11ec-0074-c78acac29cdb
# ╟─28db6fac-793c-11ec-0624-292fa0c2cae9
# ╟─28dbc240-793c-11ec-312a-4b724510071d
# ╟─28dbc2e0-793c-11ec-0fe4-77eccc0e9a8a
# ╟─28dbc308-793c-11ec-2d72-cdf6635a9615
# ╟─28dbc31c-793c-11ec-2118-3b4b454dad9e
# ╟─28dbc326-793c-11ec-1850-57b520feb00b
# ╟─28dbc34e-793c-11ec-05f4-35e8983be820
# ╟─28dbc358-793c-11ec-2fb5-5525d56bba82
# ╟─28dbc380-793c-11ec-246e-cf0bf729a798
# ╟─28dbc394-793c-11ec-0ef8-b34b947c9238
# ╟─28dbc3a0-793c-11ec-1cf4-93dac8aa113b
# ╟─28dbc3b2-793c-11ec-0546-237cdb9c3eb5
# ╟─28dbc3c6-793c-11ec-2dd4-e1903f3e7e38
# ╟─28dbc3e4-793c-11ec-255c-1dd929f3959e
# ╟─28dbc40c-793c-11ec-3c5a-c995d18c21a4
# ╟─28dbc416-793c-11ec-353b-9375ba6f31ee
# ╟─28dbc43e-793c-11ec-0a05-1ba08a9a1b21
# ╠═28dbe180-793c-11ec-16aa-8bb43dadda3a
# ╟─28dbe1bc-793c-11ec-1adc-ad729ba13087
# ╠═28dbea18-793c-11ec-1947-f3914aa2b8d9
# ╟─28dbea54-793c-11ec-1484-e12ce2ee1067
# ╟─28dbea72-793c-11ec-02a6-75b07422b094
# ╟─28dbeaae-793c-11ec-2832-b134ffa804ed
# ╠═28dbef9a-793c-11ec-3cb0-7fa5ade2b8f6
# ╟─28dbefd4-793c-11ec-2523-89304a8709ab
# ╠═28dc1362-793c-11ec-3f93-6f33710bb69d
# ╟─28dc13da-793c-11ec-251a-67b6878a57f9
# ╟─28dc13ee-793c-11ec-272e-2789dd8e11be
# ╠═28dc1952-793c-11ec-3ec6-c1cc687574f9
# ╟─28dc197a-793c-11ec-04b8-c54aadad6a0a
# ╟─28dc1984-793c-11ec-3caf-41ecfbe292cf
# ╟─28dc19a2-793c-11ec-2b1e-bdd89b7e8aae
# ╟─28dc19ca-793c-11ec-1fa9-4b58078553c2
# ╟─28dc19fc-793c-11ec-11f0-a3bfeb56dc44
# ╟─28dc1a12-793c-11ec-23e4-8fb5045a2e4b
# ╟─28dc1a24-793c-11ec-12a3-67ba48358d90
# ╟─28dc1a2e-793c-11ec-2cf9-5d36fba0bdc5
# ╟─28dc1a72-793c-11ec-3484-a7cdf80dfc5c
# ╟─28dc1a9c-793c-11ec-0a9b-bdc23435a1a0
# ╠═28dc4468-793c-11ec-2a67-418ef9a3e0a5
# ╟─28dc44cc-793c-11ec-3ec5-a5c4459f25df
# ╠═28dc6178-793c-11ec-32b6-dfba225712b5
# ╟─28dc61dc-793c-11ec-1157-f14916fd1c8b
# ╠═28dc6916-793c-11ec-3d37-c5d4ad938ab5
# ╟─28dc693e-793c-11ec-2178-930d1bed28fd
# ╟─28dc697c-793c-11ec-3574-3111e806f176
# ╟─28dc698e-793c-11ec-1323-31d3b2de9e16
# ╟─28dc69c0-793c-11ec-0627-7372c704da03
# ╟─28dc69f2-793c-11ec-3747-b1d1295f5ae5
# ╟─28dc6e8e-793c-11ec-09f2-8333540c5b1b
# ╟─28dc6eb8-793c-11ec-37ff-155c3b558bf9
# ╟─28dc6ec0-793c-11ec-0284-036ae44ffc54
# ╟─28dc6ed4-793c-11ec-02a1-15c83753214a
# ╟─28dc6ef2-793c-11ec-3f48-bb63d744e3b3
# ╟─28dc7366-793c-11ec-1b6b-5d0b1ea7efa4
# ╟─28dc737a-793c-11ec-21ca-f9305dfa83ed
# ╟─28dc738e-793c-11ec-3a80-bfe192a1bf64
# ╟─28dc73a2-793c-11ec-2f14-bd09f81fd3c6
# ╟─28dc73c0-793c-11ec-1a87-f1a1d0cd58d1
# ╟─28dc796a-793c-11ec-3e42-49af9ba70944
# ╟─28dc797e-793c-11ec-38a5-d9b967baa388
# ╟─28dc7988-793c-11ec-3a5d-bd71d55a1bf5
# ╟─28dc79a6-793c-11ec-225e-4990e6e2b1f2
# ╟─28dc79ba-793c-11ec-0b1c-f1c21946dc51
# ╟─28dc7ece-793c-11ec-3743-6fa76e2013d3
# ╟─28dc7eec-793c-11ec-03f9-d1bd4d9e6b8f
# ╟─28dc7f00-793c-11ec-29f7-b9d95dee1a73
# ╟─28dc7f0a-793c-11ec-024e-fb64bf289416
# ╟─28dc7f34-793c-11ec-3a0c-d554b711d8ff
# ╟─28dc7f46-793c-11ec-3e1d-ef72a86ddf36
# ╟─28dc8540-793c-11ec-10de-bd9fa6250f97
# ╟─28dc855e-793c-11ec-0b0b-2bf392489552
# ╟─28dc8c02-793c-11ec-30b9-e5d36d9c56a4
# ╟─28dc8c20-793c-11ec-251e-5f2286b48ff3
# ╟─28dc8c7a-793c-11ec-33b2-0b54fb4e04a2
# ╟─28dc8c8e-793c-11ec-1e0d-3108c4ca4a1d
# ╟─28dca20a-793c-11ec-39e4-f5ee7c7aa881
# ╟─28dca232-793c-11ec-110e-4f1fd79c926e
# ╟─28dca23c-793c-11ec-3f55-bd876325fbfe
# ╟─28dca23c-793c-11ec-3a05-5de186027847
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
