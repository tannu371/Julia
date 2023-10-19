### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 0cd8655c-539f-11ec-32e4-0bf925d5d572
begin
	using CalculusWithJulia
	using Plots
	using Roots
	using SymPy
	import IntervalArithmetic
	import IntervalRootFinding
end

# ╔═╡ 0cd86a04-539f-11ec-1eab-a3e271ca8ca6
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size=(400, 400)
	nothing
end

# ╔═╡ 0ce7b9b2-539f-11ec-396c-e3bc99603ac2
using PlutoUI

# ╔═╡ 0ce7b99e-539f-11ec-079e-8900f1d6bd35
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 0cd7b710-539f-11ec-39f0-79e69bb21f19
md"""# Implications of continuity
"""

# ╔═╡ 0cd7c9b2-539f-11ec-02bb-193641b00947
md"""This section uses these add-on packages:
"""

# ╔═╡ 0cd86aa2-539f-11ec-2326-ef3976381ce0
md"""---
"""

# ╔═╡ 0cd86ab6-539f-11ec-061b-b3ac7ad4d7c2
md"""Continuity for functions is a valued property which carries implications. In this section we discuss two: the intermediate value theorem and the extreme value theorem. These two theorems speak to some fundamental applications of calculus: finding zeros of a function and finding extrema of a function.
"""

# ╔═╡ 0cd86b2e-539f-11ec-17f9-1f55b4e0ff12
md"""## Intermediate Value Theorem
"""

# ╔═╡ 0cd86d54-539f-11ec-0014-01af08b26622
md"""> The *intermediate value theorem*: If $f$ is continuous on $[a,b]$  with, say, $f(a) < f(b)$, then for any $y$ with $f(a) \leq y \leq f(b)$  there exists a $c$ in $[a,b]$ with $f(c) = y$.

"""

# ╔═╡ 0cd99bf2-539f-11ec-1166-6b31c70fbbda
let
	### {{{IVT}}}
	
	function IVT_graph(n)
	    f(x) = sin(pi*x) + 9x/10
	    a,b = [0,3]
	
	    xs = range(a,stop=b, length=50)
	
	
	    ## cheat -- pick an x, then find a y
	    Δ = .2
	    x = range(a + Δ, stop=b - Δ, length=6)[n]
	    y = f(x)
	
	    plt = plot(f, a, b, legend=false, size=fig_size)
	    plot!(plt, [0,x,x], [f(x),f(x),0], color=:orange, linewidth=3)
	
	    plot
	
	end
	
	n = 6
	anim = @animate for i=1:n
	    IVT_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	
	Illustration of intermediate value theorem. The theorem implies that any randomly chosen $y$
	value between $f(a)$ and $f(b)$ will have  at least one $x$ in $[a,b]$
	with $f(x)=y$.
	
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 0cd99c4c-539f-11ec-3d09-b73818130901
md"""In the early years of calculus, the intermediate value theorem was intricately connected with the definition of continuity, now it is a consequence.
"""

# ╔═╡ 0cd99cce-539f-11ec-356a-4388c6c937c9
md"""The basic proof starts with a set of points in $[a,b]$: $C = \{x \text{ in } [a,b] \text{ with } f(x) \leq y\}$. The set is not empty (as $a$ is in $C$) so it *must* have a largest value, call it $c$ (this requires the completeness property of the real numbers).  By continuity of $f$, it can be shown that $\lim_{x \rightarrow c-} f(x) = f(c) \leq y$ and $\lim_{y \rightarrow c+}f(x) =f(c) \geq y$, which forces $f(c) = y$.
"""

# ╔═╡ 0cdcae3a-539f-11ec-07ba-2da8d2c68acd
md"""### Bolzano and the bisection method
"""

# ╔═╡ 0cdcaef0-539f-11ec-183a-bb7f5c6b0e3e
md"""Suppose we have a continuous function $f(x)$ on $[a,b]$ with $f(a) < 0$ and $f(b) > 0$. Then as $f(a) < 0 < f(b)$, the intermediate value theorem guarantees the existence of a $c$ in $[a,b]$ with $f(c) = 0$. This was a special case of the intermediate value theorem proved by Bolzano first. Such $c$ are called *zeros* of the function $f$.
"""

# ╔═╡ 0cdcaf04-539f-11ec-35e0-67cc3be9f623
md"""We use this fact when a building a "sign chart" of a polynomial function. Between any two consecutive real zeros the polynomial can not change sign. (Why?) So a "test point" can be used to determine the sign of the function over an entire interval.
"""

# ╔═╡ 0cdcaf2c-539f-11ec-20c0-cb4b99b2c96b
md"""Here, we use the Bolzano theorem to give an algorithm - the *bisection method* - to locate the value $c$ under the assumption $f$ is continous on $[a,b]$ and changes sign between $a$ and $b$.
"""

# ╔═╡ 0cdd2d30-539f-11ec-0cc4-07b2416e1bc0
let
	## {{{bisection_graph}}}
	function bisecting_graph(n)
	    f(x) = x^2 - 2
	    a,b = [0,2]
	
	    err = 2.0^(1-n)
	    title = "b - a = $err"
	    xs = range(a, stop=b, length=100)
	    plt = plot(f, a, b, legend=false, size=fig_size, title=title)
	
	    if n >= 1
	        for i in 1:n
	            c = (a+b)/2
	            if f(a) * f(c) < 0
	                a,b=a,c
	            else
	                a,b=c,b
	            end
	        end
	    end
	    plot!(plt, [a,b],[0,0], color=:orange, linewidth=3)
	    scatter!(plt, [a,b], [f(a), f(b)], color=:orange, markersize=5, markershape=:circle)
	
	    plt
	
	end
	
	
	n = 9
	anim = @animate for i=1:n
	    bisecting_graph(i-1)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	
	Illustration of the bisection method to find a zero of a function. At
	each step the interval has $f(a)$ and $f(b)$ having opposite signs so
	that the intermediate value theorem guaratees a zero.
	
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 0cdd2dbc-539f-11ec-12f9-d160cb46a47f
md"""Call $[a,b]$ a *bracketing* interval if $f(a)$ and $f(b)$ have different signs. We remark that having different signs can be expressed mathematically as $f(a) \cdot f(b) < 0$.
"""

# ╔═╡ 0cdd2dd0-539f-11ec-1f8a-55ea125dcecc
md"""We can narrow down where a zero is in $[a,b]$ by following this recipe:
"""

# ╔═╡ 0cdd2f60-539f-11ec-2c35-bfc4bd4caacd
md"""  * Pick a midpoint of the interval, for concreteness $c = (a+b)/2$.
  * If $f(c) = 0$ we are done, having found a zero in $[a,b]$.
  * Otherwise if must be that either $f(a)\cdot f(c) < 0$ or $f(c) \cdot f(b) < 0$. If $f(a) \cdot f(c) < 0$, then let $b=c$ and repeat the above. Otherwise, let $a=c$ and repeat the above.
"""

# ╔═╡ 0cde7582-539f-11ec-20d8-9d7d27df94de
md"""At each step the bracketing interval is narrowed – indeed split in half as defined – or a zero is found.
"""

# ╔═╡ 0cde75dc-539f-11ec-3c09-23ef786a30b2
md"""For the real numbers this algorithm never stops unless a zero is found. A "limiting" process is used to say that if it doesn't stop, it will converge to some value.
"""

# ╔═╡ 0cde762c-539f-11ec-056a-7921653701b8
md"""However, using floating point numbers leads to differences from the real-number situation. In this case, due to the ultimate granularity of the approximation of floating point values to the real numbers, the bracketing interval eventually can't be subdivided, that is no $c$ is found over the floating point numbers with $a < c < b$. So there is a natural stopping criteria: stop when there is an exact zero, or when the bracketing interval gets too small to subdivide.
"""

# ╔═╡ 0cde7640-539f-11ec-295a-1f66089040ed
md"""We can write a relatively simple program to implement this algorithm:
"""

# ╔═╡ 0cdea502-539f-11ec-12d7-91a145c66e6d
function simple_bisection(f, a, b)
  if f(a) == 0 return(a) end
  if f(b) == 0 return(b) end
  if f(a) * f(b) > 0 error("[a,b] is not a bracketing interval") end

  tol = 1e-14  # small number (but should depend on size of a, b)
  c = a/2 + b/2

  while abs(b-a) > tol
    if f(c) == 0 return(c) end

    if f(a) * f(c) < 0
       a, b = a, c
    else
       a, b = c, b
    end

    c = a/2 + b/2

  end
  c
end

# ╔═╡ 0cdea5a0-539f-11ec-1384-1956da88e888
md"""This function uses a `while` loop to repeat the process of subdividing $[a,b]$. A `while` loop will repeat until the condition is no longer `true`.  The above will stop for reasonably sized floating point values (within $(-100, 100)$, say), but, as written, ignores the fact that the gap between floating point values depends on their magnitude.
"""

# ╔═╡ 0cdea5d4-539f-11ec-1484-7ffbca7114cb
md"""The value $c$ returned *need not* be an exact zero. Let's see:
"""

# ╔═╡ 0cdeabb2-539f-11ec-0067-198889d32d9e
c = simple_bisection(sin, 3, 4)

# ╔═╡ 0cdeac82-539f-11ec-15ef-fb4608e94231
md"""This value of $c$ is a floating-point approximation to $\pi$, but is not *quite* a zero:
"""

# ╔═╡ 0cdeaee2-539f-11ec-2d48-4717c46ee4e8
sin(c)

# ╔═╡ 0cdeaf0c-539f-11ec-2cbe-a118c9408f27
md"""(Even `pi` itself is not a "zero" due to floating point issues.)
"""

# ╔═╡ 0cdeaf3e-539f-11ec-05d2-1b36710ca8f8
md"""### The `find_zero` function.
"""

# ╔═╡ 0cdeaf84-539f-11ec-0aa9-9741d7a7ec43
md"""The `Roots` package has a function `find_zero` that implements the bisection method when called as `find_zero(f, a..b)` where $[a,b]$ is a bracket. Its use is similar to `simple_bisection` above. This package is loaded when `CalculusWithJulia` is. We illlustrate the usage of `find_zero` in the following:
"""

# ╔═╡ 0cdeb5c4-539f-11ec-3e47-79b41064d87d
xstar = find_zero(sin, 3..4)

# ╔═╡ 0cdec5c8-539f-11ec-3eac-6141de964838
alert("""
Notice, the call `find_zero(sin, 3..4)` again fits the template `action(function, args...)` that we see repeatedly. The `find_zero` function can also be called through `fzero`. The use of `3..4` to specify the interval is not necessary. For example `(3,4)` or `[3,4]` would work equally as well. The `..` is an idiom in `Julia` for intervals, so used here, but is not part of the base language. It is imported from `EllipsisNotation` by the `CalculusWithJulia` package.
 """)

# ╔═╡ 0cdec606-539f-11ec-2c4b-23ff5e523ed0
md"""This function utilizes some facts about floating point values to guarantee that the answer will be an *exact* zero or a value where there is a sign change between the next bigger floating point or the next smaller, which means the sign at the next and previous floating point values is different:
"""

# ╔═╡ 0cdee620-539f-11ec-26c8-134235edfb0f
sin(xstar), sign(sin(prevfloat(xstar))), sign(sin(nextfloat(xstar)))

# ╔═╡ 0cdee6d4-539f-11ec-0da4-f93b26643524
md"""##### Example
"""

# ╔═╡ 0cdee71a-539f-11ec-0401-7930de6f3a00
md"""The polynomial $p(x) = x^5 - x + 1$ has a zero between $-2$ and $-1$. Find it.
"""

# ╔═╡ 0cdeee4a-539f-11ec-19fd-2d2d3b524132
begin
	p(x) = x^5 - x + 1
	c₀ = find_zero(p, -2 .. -1)  # avoiding ..-1 which errors
	(c₀, p(c₀))
end

# ╔═╡ 0cdeee9a-539f-11ec-0852-dbf24e78c987
md"""We see, as before, that $p(c)$ is not quite $0$. But it can be easily checked that `p` is negative at the previous floating point number, while `p` is seen to be positive at the returned value:
"""

# ╔═╡ 0cdef408-539f-11ec-056d-d12861b684ba
p(c₀), sign(p(prevfloat(c₀))), sign(p(nextfloat(c₀)))

# ╔═╡ 0cdef426-539f-11ec-2f7e-0fe95e613d2f
md"""##### Example
"""

# ╔═╡ 0cdef458-539f-11ec-0841-33f6b093bd21
md"""The function $q(x) = e^x - x^4$ has a zero between $5$ and $10$, as this graph shows:
"""

# ╔═╡ 0cdef93a-539f-11ec-1410-d153ea3ffceb
begin
	q(x) = exp(x) - x^4
	plot(q, 5, 10)
end

# ╔═╡ 0cdef962-539f-11ec-3a5d-f584cbb57f72
md"""Find the zero numerically. The plot shows $q(5) < 0 < q(10)$, so $[5,10]$ is a bracket. We thus have:
"""

# ╔═╡ 0cdefc96-539f-11ec-285d-51320aaaf913
find_zero(q, 5..10)

# ╔═╡ 0cdefcbe-539f-11ec-3619-8d6c1774c530
md"""##### Example
"""

# ╔═╡ 0cdefcdc-539f-11ec-2e62-7fa583e69153
md"""Find all real zeros of $f(x) = x^3 -x + 1$ using the bisection method.
"""

# ╔═╡ 0cdefcf0-539f-11ec-3251-2b10694ba29b
md"""We show next that symbolic values can be used with `find_zero`, should that be useful.
"""

# ╔═╡ 0cdefd04-539f-11ec-0584-a35b1aa818ee
md"""First, we produce a plot to identify a bracketing interval
"""

# ╔═╡ 0cdf0006-539f-11ec-31fe-bddb670a8d16
begin
	@syms x
	plot(x^3 - x + 1, -3, 3)
end

# ╔═╡ 0cdf002e-539f-11ec-2a3e-b91e80e3e296
md"""It appears (and a plot over $[0,1]$ verifies) that there is one zero between $-2$ and $-1$. It is found with:
"""

# ╔═╡ 0cdf0586-539f-11ec-152a-4108fdced6c2
find_zero(x^3 - x + 1, -2 .. -1)

# ╔═╡ 0cdf05a6-539f-11ec-1a14-475a02befb49
md"""##### Example
"""

# ╔═╡ 0cdf05b8-539f-11ec-3b98-37ada4ae2e32
md"""The equation $\cos(x) = x$ has just one solution, as can be seen in this plot:
"""

# ╔═╡ 0cdf09ca-539f-11ec-2f47-6573e33d9e86
begin
	𝒇(x) = cos(x)
	𝒈(x) = x
	plot(𝒇, -pi, pi)
	plot!(𝒈)
end

# ╔═╡ 0cdf09de-539f-11ec-1ba2-25591d8e1c5a
md"""Find it.
"""

# ╔═╡ 0cdf0a10-539f-11ec-2c29-8bcd2eaf81e1
md"""We see from the graph that it is clearly between $0$ and $2$, so all we need is a function. (We have two.) The trick is to observe that solving $f(x) = g(x)$ is the same problem as solving for $x$ where $f(x) - g(x) = 0$. So we define the difference and use that:
"""

# ╔═╡ 0cdf0e68-539f-11ec-10bd-e91df1ca2d49
begin
	𝒉(x) = 𝒇(x) - 𝒈(x)
	find_zero(𝒉, 0..2)
end

# ╔═╡ 0ce212b4-539f-11ec-0052-c111f0103220
md"""#### Using parameterized function (`f(x,p)`) with `find_zero`
"""

# ╔═╡ 0ce2135c-539f-11ec-35c4-cdc912caded8
md"""Geometry will tell us that $\cos(x) = x/p$ for *one* $x$ in $[0,pi/2]$ when ever $p>0$. We could set up finding this value for a given $p$ by making $p$ part of the function definition, but as an illustration of passing parameters, we leave `p` as a parameter (in this case, as a second value with default of $1$):
"""

# ╔═╡ 0ce23582-539f-11ec-1cf5-9321e59783f7
let
	f(x, p=1) = cos(x) - x/p
	I = 0..pi/2
	find_zero(f, I), find_zero(f,I, p=2)
end

# ╔═╡ 0ce235f0-539f-11ec-05ab-6b575ec794ac
md"""The second number the solution when `p=2`.
"""

# ╔═╡ 0ce2360e-539f-11ec-00df-5daf5aa027ac
md"""##### Example
"""

# ╔═╡ 0ce23618-539f-11ec-0b66-a508bc969c6e
md"""We wish to compare two trash collection plans
"""

# ╔═╡ 0ce236ea-539f-11ec-1474-23c9c5432fe1
md"""  * Plan 1: You pay 47.49 plus 0.77 per bag.
  * Plan 2: You pay 30.00 plus 2.00 per bag.
"""

# ╔═╡ 0ce236fe-539f-11ec-1656-0744396cfc28
md"""There are some cases where plan 1 is cheaper and some where plan 2 is. Categorize them.
"""

# ╔═╡ 0ce2373a-539f-11ec-3eac-6368abbcb7df
md"""Both plans are *linear models* and may be written in *slope-intercept* form:
"""

# ╔═╡ 0ce253fa-539f-11ec-17a5-8b1642a00090
begin
	plan1(x) = 47.49 + 0.77x
	plan2(x) = 30.00 + 2.00x
end

# ╔═╡ 0ce25422-539f-11ec-1f81-412cf62c8877
md"""Assuming this is a realistic problem and an average American household might produce 10-20 bags of trash a month (yes, that seems too much!) we plot in that range:
"""

# ╔═╡ 0ce25814-539f-11ec-2b75-3519ba674b11
begin
	plot(plan1, 10, 20)
	plot!(plan2)
end

# ╔═╡ 0ce25832-539f-11ec-1f09-9985aa84407a
md"""We can see the intersection point is around 14 and that if a family generates between 0-14 bags of trash per month that plan 2 would be cheaper.
"""

# ╔═╡ 0ce25846-539f-11ec-177c-09d234a012f0
md"""Let's get a numeric value, using a simple bracket and an anonymous function:
"""

# ╔═╡ 0ce273bc-539f-11ec-03b7-07817340fbb7
find_zero(x -> plan1(x) - plan2(x), 10..20)

# ╔═╡ 0ce273ee-539f-11ec-07bf-93e0456c22a8
md"""##### Example, the flight of an arrow
"""

# ╔═╡ 0ce2742a-539f-11ec-3ad1-dbbd4fe4b843
md"""The flight of an arrow can be modeled using various functions, depending on assumptions. Suppose an arrow is launched in the air from a height of $0$ feet above the ground at an angle of $\theta = \pi/4$. With a suitable choice for the initial velocity, a model without wind resistance for the height of the arrow at a distance $x$ units away may be:
"""

# ╔═╡ 0ce274b6-539f-11ec-0ce6-2fe3c828da71
md"""```math
j(x) = \tan(\theta) x - (1/2) \cdot g(\frac{x}{v_0 \cos\theta})^2.
```
"""

# ╔═╡ 0ce274dc-539f-11ec-16ef-3758775701eb
md"""In `julia` we have, taking $v_0=200$:
"""

# ╔═╡ 0ce28334-539f-11ec-0f16-c7919c89296c
j(x; theta=pi/4, g=32, v0=200) = tan(theta)*x - (1/2)*g*(x/(v0*cos(theta)))^2

# ╔═╡ 0ce28366-539f-11ec-1406-63e4c1eec324
md"""With a velocity-dependent wind resistance given by $\gamma$, again with some units, a similar equation can be constructed. It takes a different form:
"""

# ╔═╡ 0ce2837a-539f-11ec-358a-c788ca5108ab
md"""```math
d(x) = (\frac{g}{\gamma v_0 \cos(\theta)} + \tan(\theta)) \cdot x  +
      \frac{g}{\gamma^2}\log(\frac{v_0\cos(\theta) - \gamma x}{v_0\cos(\theta)})
```
"""

# ╔═╡ 0ce28410-539f-11ec-3c0c-f10f6aae8dbb
md"""Again, $v_0$ is the initial velocity and is taken to be $200$ and $\gamma$ a resistance, which we take to be $1$. With this, we have the following `julia` definition (with a slight reworking of $\gamma$):
"""

# ╔═╡ 0ce29568-539f-11ec-2242-b7457a815288
function d(x; theta=pi/4, g=32, v0=200, gamma=1)
	 a = gamma * v0 * cos(theta)
	 (g/a + tan(theta)) * x + g/gamma^2 * log((a-gamma^2 * x)/a)
end

# ╔═╡ 0ce295a2-539f-11ec-2baa-a3b045b5139d
md"""For each model, we wish to find the value of $x$ after launching where the height is modeled to be $0$. That is how far will the arrow travel before touching the ground?
"""

# ╔═╡ 0ce295b8-539f-11ec-2b13-93de4d208ceb
md"""For the model without wind resistance, we can graph the function easily enough. Let's guess the distance is no more than $500$ feet:
"""

# ╔═╡ 0ce29812-539f-11ec-3e47-05b15f211fb8
plot(j, 0, 500)

# ╔═╡ 0ce29838-539f-11ec-27b7-e98050072af3
md"""Well, we haven't even seen the peak yet. Better to do a little spade work first. This is a quadratic function, so we can use `roots` from `SymPy` to find the roots:
"""

# ╔═╡ 0ce2b1e2-539f-11ec-0145-570255fc9e6a
roots(j(x))

# ╔═╡ 0ce2b21e-539f-11ec-181a-797f6216326a
md"""We see that $1250$ is the largest root. So we plot over this domain to visualize the flight:
"""

# ╔═╡ 0ce2b476-539f-11ec-35d7-b5d9dccfb010
plot(j, 0, 1250)

# ╔═╡ 0ce2b4a0-539f-11ec-0798-cd10e1c22b85
md"""As for the model with wind resistance,  a quick plot over the same interval, $[0, 1250]$ yields:
"""

# ╔═╡ 0ce2b6e2-539f-11ec-1008-4f181139acbc
plot(d, 0, 1250)

# ╔═╡ 0ce2b732-539f-11ec-36a4-c994520dc1e1
md"""This graph eventually goes negative and then stops. This is due to the asymptote in model when `(a - gamma^2*x)/a` is zero. To plot the trajectory until it returns to $0$, we need to identify the value of the zero. This model is non-linear and we don't have the simplicity of using `roots` to find out the answer, so we solve for when $a-\gamma^2 x$ is $0$:
"""

# ╔═╡ 0ce2ba48-539f-11ec-11bc-cb1b5340b7e4
begin
	gamma = 1
	a = 200 * cos(pi/4)
	b = a/gamma^2
end

# ╔═╡ 0ce2ba6e-539f-11ec-0629-c9cde2c4786d
md"""Note that the function is infinite at `b`:
"""

# ╔═╡ 0ce2bbce-539f-11ec-0cd4-55fc9ba46ffb
d(b)

# ╔═╡ 0ce2bbf6-539f-11ec-0c52-ed97d570b8c2
md"""From the graph,  we can see the zero is around `b`. As `y(b)` is `-Inf` we can use the bracket `(b/2,b)`
"""

# ╔═╡ 0ce2c006-539f-11ec-083f-1f385baadd1d
x1 = find_zero(d, (b/2)..b)

# ╔═╡ 0ce2c024-539f-11ec-1abe-35098f7f4891
md"""The answer is approximately $140.7$
"""

# ╔═╡ 0ce2c040-539f-11ec-1d21-31375371f753
md"""(The bisection method only needs to know the sign of the function. Other bracketing methods would have issues with an endpoint with an infinite function value. To use them, some value between the zero and `b` would needed.)
"""

# ╔═╡ 0ce2c056-539f-11ec-3277-21040e120b55
md"""Finally, we plot both graphs at once to see that it was a very windy day indeed.
"""

# ╔═╡ 0ce2c542-539f-11ec-303d-ed8f98d1fbe5
begin
	plot(j, 0, 1250, label="no wind")
	plot!(d, 0, x1, label="windy day")
end

# ╔═╡ 0ce2c574-539f-11ec-0d25-318bccaa6af7
md"""##### Example: bisection and non-continuity
"""

# ╔═╡ 0ce2c592-539f-11ec-3afa-134fb5a367fb
md"""The Bolzano theorem assumes a continuous function $f$, and when applicable, yields an algorithm to find a guaranteed zero.
"""

# ╔═╡ 0ce2c59c-539f-11ec-2a98-d1662e570d07
md"""However, the algorithm itself does not know that the function is continuous or not, only that the function changes sign. As such, it can produce answers that are not "zeros" when used with discontinuous functions.
"""

# ╔═╡ 0ce2c5ba-539f-11ec-171b-1d92b1093965
md"""In general a function over floating point values could be considered as a large table of mappings: each of the $2^{64}$ floating point values gets assigned a value. This is discrete mapping, there is nothing the computer sees related to continuity.
"""

# ╔═╡ 0ce2c652-539f-11ec-1669-3fffc064aaaa
md"""> The concept of continuity, if needed, must be verified by the user of the algorithm.

"""

# ╔═╡ 0ce2c66e-539f-11ec-2d99-bfe2f1437797
md"""We have seen this when plotting rational functions or functions with vertical asymptotes. The default algorithms just connect points with lines. The user must manage the discontinuity (by assigning some values `NaN`, say); the algorithms used do not.
"""

# ╔═╡ 0ce2c68c-539f-11ec-0c9e-afa0ee3e0460
md"""In this particular case, the bisection algorithm can still be fruitful even when the function is not continuous, as the algorithm will yield information about crossing values of $0$, possibly at discontinuities. But the user of the algorithm must be aware that the answers are only guaranteed to be zeros of the function if the function is continuous and the algorithm did not check for that assumption.
"""

# ╔═╡ 0ce2c6aa-539f-11ec-0c82-5391a5248fc6
md"""As an example, let $f(x) = 1/x$. Clearly the interval $[-1,1]$ is a "bracketing" interval as $f(x)$ changes sign between $a$ and $b$. What does the algorithm yield:
"""

# ╔═╡ 0ce2e95a-539f-11ec-1fbd-67cde0a9df6c
begin
	fᵢ(x) = 1/x
	x0 = find_zero(fᵢ, -1..1)
end

# ╔═╡ 0ce2e996-539f-11ec-1531-07b9a62c1e66
md"""The function is not defined at the answer, but we do have the fact that just to the left of the answer (`prevfloat`) and just to the right of the answer (`nextfloat`) the function changes sign:
"""

# ╔═╡ 0ce3073a-539f-11ec-3c1b-83797312c64b
sign(fᵢ(prevfloat(x0))), sign(fᵢ(nextfloat(x0)))

# ╔═╡ 0ce307b4-539f-11ec-3446-417678017b3a
md"""So, the "bisection method" applied here finds a point where the function crosses $0$, either by continuity or by jumping over the $0$.  (A `jump` discontinuity at $x=c$ is defined by the left and right limits of $f$ at $c$ existing but being unequal. The algorithm can find $c$ when this type of function jumps over $0$.)
"""

# ╔═╡ 0ce307fa-539f-11ec-1bdf-33175402af5e
md"""### The `find_zeros` function
"""

# ╔═╡ 0ce30822-539f-11ec-2923-c13740f11564
md"""The bisection method suggests a naive means to search for all zeros within an interval $(a, b)$: split the interval into many small intervals and for each that is a bracketing interval find a zero. This simple description has three flaws: it might miss values where the function doesn't actually cross the $x$ axis; it might miss values where the function just dips to the other side; and it might miss multiple values in the same small interval.
"""

# ╔═╡ 0ce30842-539f-11ec-1229-c5574ae70a83
md"""Still, with some engineering, this can be a useful approach, save the caveats. This idea is implemented in the `find_zeros` function of the `Roots` package. The function is called via `find_zeros(f, a..b)` but here the interval $[a,b]$ is not necessarily a bracketing interval.
"""

# ╔═╡ 0ce3084a-539f-11ec-0f5a-4d45708de991
md"""To see, we have:
"""

# ╔═╡ 0ce30ffc-539f-11ec-312c-95ecfaac41fd
let
	f(x) = cos(10*pi*x)
	find_zeros(f, 0..1)
end

# ╔═╡ 0ce31010-539f-11ec-0889-61d9c53c59f2
md"""Or for a polynomial:
"""

# ╔═╡ 0ce31950-539f-11ec-2710-c5e6fa1eb508
let
	f(x) = x^5 - x^4 + x^3 - x^2 + 1
	find_zeros(f, -10..10)
end

# ╔═╡ 0ce31982-539f-11ec-1979-5f8e3d658b07
md"""(Here $-10$ and $10$ were arbitrarily chosen. Cauchy's method could be used to be more systematic.)
"""

# ╔═╡ 0ce32046-539f-11ec-2329-43f46f5bfee7
note("""
At the end of this section are details on how to use the `IntervalRootFinding` package to identify all zeros in a specified interval. This package offers a more robust algorithm for this task.
""")

# ╔═╡ 0ce32082-539f-11ec-0929-d975cf77e27e
md"""##### Example: Solving f(x) = g(x)
"""

# ╔═╡ 0ce320aa-539f-11ec-23d9-d5a4e816f593
md"""Use `find_zeros` to find when $e^x = x^5$ in the interval $[-20, 20]$. Verify the answers.
"""

# ╔═╡ 0ce32118-539f-11ec-0885-7da621783515
md"""To proceed with `find_zeros`, we define $f(x) = e^x - x^5$, as $f(x) = 0$ precisely when $e^x = x^5$. The zeros are then found with:
"""

# ╔═╡ 0ce325be-539f-11ec-021d-031e16fb0db0
begin
	f₁(x) = exp(x) - x^5
	zs = find_zeros(f₁, -20..20)
end

# ╔═╡ 0ce325dc-539f-11ec-1208-55eb674663d7
md"""The output of `find_zeros` is a vector of values. To check that each value is an approximate zero can be done with the "." (broadcast) syntax:
"""

# ╔═╡ 0ce32820-539f-11ec-1e27-09ec213ab73a
f₁.(zs)

# ╔═╡ 0ce32848-539f-11ec-063c-a5b014012a0d
md"""(For a continuous function this should be the case that the values returned by `find_zeros` are approximate zeros. Bear in mind that if $f$ is not continous the algorithm might find jumping points that are not zeros and may not even be in the domain of the function.)
"""

# ╔═╡ 0ce32864-539f-11ec-0eaa-dfc5af914468
md"""### An alternate interface to `find_zero`
"""

# ╔═╡ 0ce328c0-539f-11ec-2c04-d52b492593f8
md"""The `find_zero` function in the `Roots` package is an interface to one of several methods. For now we focus on the *bracketing* methods, later we will see others. Bracketing methods, among others,  include `Roots.Bisection()`, the basic bisection method though with a different sense of "middle" than $(a+b)/2$ and used by default above; `Roots.A42()`, which will typically converge much faster than simple bisection; `Roots.Brent()` for the classic method of Brent, and `FalsePosition()` for a family of *regula falsi* methods. These can all be used by specifying the method in a call to `find_zero`.
"""

# ╔═╡ 0ce328de-539f-11ec-0874-4575ae622fe7
md"""Alternatively, `Roots` implements the `CommonSolve` interface popularized by its use in the `DifferentialEquations.jl` ecosystem, a wildly successful area for `Julia`. The basic setup is two steps: setup a "problem," solve the problem.
"""

# ╔═╡ 0ce328f2-539f-11ec-3f40-f15eedc80cd8
md"""To set up a problem, we call `ZeroProblem` with the function and an initial interval, as in:
"""

# ╔═╡ 0ce32df2-539f-11ec-33a8-6972b92c77ff
begin
	f₅(x) = x^5 - x - 1
	prob = ZeroProblem(f₅, (1,2))
end

# ╔═╡ 0ce32e10-539f-11ec-311a-21975523ae33
md"""Then we can "solve" this problem with `solve`. For example:
"""

# ╔═╡ 0ce3336a-539f-11ec-134f-e5081b782621
solve(prob), solve(prob, Roots.Brent()), solve(prob, Roots.A42())

# ╔═╡ 0ce33388-539f-11ec-17aa-fb7f9c4ee4d5
md"""Though the answers are identical, the methods employed were not. The first call, with an unspecified method, defaults to bisection.
"""

# ╔═╡ 0ce333ba-539f-11ec-03fe-9d2771eb59b5
md"""## Extreme value theorem
"""

# ╔═╡ 0ce333c4-539f-11ec-14e7-21ec7b3ebc75
md"""The Extreme Value Theorem is another consequence of continuity.
"""

# ╔═╡ 0ce33416-539f-11ec-03f6-29d85ae92a8b
md"""To discuss the extreme value theorem, we define an *absolute maximum*.
"""

# ╔═╡ 0ce33536-539f-11ec-1044-630554e745b4
md"""> The absolute maximum of $f(x)$ over an interval $I$ is the value $f(c)$, $c$ in $I$, where $f(x) \leq f(c)$ for any $x$ in $I$.
>
> Similarly, an *absolute minimum* of $f(x)$ over an interval $I$ can be defined by a value $f(c)$ where $c$ is in $I$ *and* $f(c) \leq f(x)$ for any $x$ in $I$.

"""

# ╔═╡ 0ce33554-539f-11ec-2a46-bda4f293e163
md"""Related but different is the concept of a relative of *local extrema*:
"""

# ╔═╡ 0ce3361c-539f-11ec-2ef7-71d9c406b898
md"""> A local maxima for $f$ is a value $f(c)$ where $c$ is in **some** *open* interval $I=(a,b)$, $I$ in the domain of $f$, and $f(c)$ is an absolute maxima for $f$ over $I$. Similarly, an local minima for $f$ is a value $f(c)$ where $c$ is in **some** *open* interval $I=(a,b)$, $I$ in the domain of $f$, and $f(x)$ is an absolute minima for $f$ over $I$.

"""

# ╔═╡ 0ce3363a-539f-11ec-3e02-7bae8c53e1d4
md"""The term *local extrema* is used to describe either a local maximum or local minimum.
"""

# ╔═╡ 0ce3368a-539f-11ec-3a9d-a9d55b4fadfe
md"""The key point, is the extrema are values in the *range* that are realized by some value in the domain (possibly more than one.)
"""

# ╔═╡ 0ce336c6-539f-11ec-2378-4781e97283ee
md"""This chart of the [Hardrock 100](http://hardrock100.com/) illustrates the two concepts.
"""

# ╔═╡ 0ce33a90-539f-11ec-1552-ebdb7ff0ef70
begin
	###{{{hardrock_profile}}}
	imgfile = "figures/hardrock-100.png"
	caption = """
	Elevation profile of the  Hardrock 100 ultramarathon. Treating the elevation profile as a function, the absolute maximum is just about 14,000 feet and the absolute minimum about 7600 feet. These are of interest to the runner for different reasons. Also of interest would be each local maxima and local minima - the peaks and valleys of the graph - and the total elevation climbed - the latter so important/unforgettable its value makes it into the chart's title.
	"""
	
	#ImageFile(imgfile, caption)
	nothing
end

# ╔═╡ 0ce442a0-539f-11ec-2d75-43e9fa274d81
md"""![Elevation profile of the  Hardrock 100 ultramarathon. Treating the elevation profile as a function, the absolute maximum is just about 14,000 feet and the absolute minimum about 7600 feet. These are of interest to the runner for different reasons. Also of interest would be each local maxima and local minima - the peaks and valleys of the graph - and the total elevation climbed - the latter so important/unforgettable its value makes it into the chart's title.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/limits/figures/hardrock-100.png)
"""

# ╔═╡ 0ce44304-539f-11ec-20fe-63b9797c0541
md"""The extreme value theorem discusses an assumption that ensures absolute maximum and absolute minimum values exist.
"""

# ╔═╡ 0ce44426-539f-11ec-19e3-272910306bc9
md"""> The *extreme value theorem*: If $f(x)$ is continuous over a closed  interval $[a,b]$ then $f$ has an absolute maximum and an absolute  minimum over $[a,b]$.

"""

# ╔═╡ 0ce44458-539f-11ec-33f9-8be04b95a60c
md"""(By continuous over $[a,b]$ we mean continuous on $(a,b)$ and right continuous at $a$ and left continuous at $b$.)
"""

# ╔═╡ 0ce44480-539f-11ec-17f5-79e70b7cfe12
md"""The assumption that $[a,b]$ includes its endpoints (it is closed)  is crucial to make a guarantee. There are functions which are continuous on open intervals for which this result is not true. For example, $f(x) = 1/x$ on $(0,1)$. This function will have no smallest value or largest value, as defined above.
"""

# ╔═╡ 0ce44494-539f-11ec-14c7-39f70756c2dc
md"""The extreme value theorem is an important theoretical tool for investigating maxima and minima of functions.
"""

# ╔═╡ 0ce444b2-539f-11ec-1377-1f654acebc02
md"""##### Example
"""

# ╔═╡ 0ce444da-539f-11ec-19e7-719d373ed604
md"""The function $f(x) = \sqrt{1-x^2}$ is continuous on the interval $[-1,1]$ (in the sense above). It then has an absolute maximum, we can see to be $1$ occurring at an interior point $0$. The absolute minimum is $0$, it occurs at each endpoint.
"""

# ╔═╡ 0ce444ee-539f-11ec-2bcc-d3c23bfd4ec7
md"""##### Example
"""

# ╔═╡ 0ce44578-539f-11ec-29c1-15f819811785
md"""The function $f(x) = x \cdot e^{-x}$ on the closed interval $[0, 5]$ is continuous. Hence it has an absolute maximum, which a graph shows to be $0.4$. It has an absolute minimum, clearly the value $0$ occurring at the endpoint.
"""

# ╔═╡ 0ce44c96-539f-11ec-05e6-d3cab59199ab
let
	plot(x -> x * exp(-x), 0, 5)
end

# ╔═╡ 0ce44cbe-539f-11ec-1ad9-ef16e2f7692a
md"""##### Example
"""

# ╔═╡ 0ce44d04-539f-11ec-16c6-9bcb93be120f
md"""The tangent function does not have a *guarantee* of absolute maximum or minimum over $(-\pi/2, \pi/2),$ as it is not *continuous* at the endpoints. In fact, it doesn't have either extrema - it has vertical asymptotes at each endpoint of this interval.
"""

# ╔═╡ 0ce44d18-539f-11ec-338d-2f3e8e6ef2bc
md"""##### Example
"""

# ╔═╡ 0ce44d40-539f-11ec-35b7-a134527160ac
md"""The function $f(x) = x^{2/3}$ over the interval $[-2,2]$ has cusp at $0$. However, it is continuous on this closed interval, so must have an absolute maximum and absolute minimum. They can be seen from the graph to occur at the endpoints and the cusp at $x=0$, respectively:
"""

# ╔═╡ 0ce454e8-539f-11ec-2be5-b58b19f96f9f
let
	plot(x -> (x^2)^(1/3), -2, 2)
end

# ╔═╡ 0ce45524-539f-11ec-0cdd-19ef8e4a12d9
md"""(The use of just `x^(2/3)` would fail, can you guess why?)
"""

# ╔═╡ 0ce4552e-539f-11ec-0698-1b6faa834d09
md"""##### Example
"""

# ╔═╡ 0ce4556a-539f-11ec-1a79-b11ef78f5702
md"""A New York Times [article](https://www.nytimes.com/2016/07/30/world/europe/norway-considers-a-birthday-gift-for-finland-the-peak-of-an-arctic-mountain.html) discusses an idea of Norway moving its border some 490 feet north and 650 feet east in order to have the peak of Mount Halti be the highest point in Finland, as currently it would be on the boundary. Mathematically this hints at a higher dimensional version of the extreme value theorem.
"""

# ╔═╡ 0ce45588-539f-11ec-3202-7dd36903a537
md"""## Continuity and closed and open sets
"""

# ╔═╡ 0ce45594-539f-11ec-2dad-e3437e57a2b2
md"""We comment on two implications of continuity that can be generalized to more general settings.
"""

# ╔═╡ 0ce455c6-539f-11ec-0aed-a56acfcaac2c
md"""The two intervals $(a,b)$ and $[a,b]$ differ as the latter includes the endpoints. The extreme value theorem shows this distinction can make a big difference in what can be said regarding *images* of such interval.
"""

# ╔═╡ 0ce45600-539f-11ec-1391-b324bcd5f8a6
md"""In particular, if $f$ is continuous and $I = [a,b]$ with $a$ and $b$ finite ($I$ is *closed* and bounded) then the *image* of $I$ sometimes denoted $f(I) = \{y: y=f(x) \text{ for } x \in I\}$ has the property that it will be an interval and will include its endpoints (also closed and bounded).
"""

# ╔═╡ 0ce45614-539f-11ec-2629-b55f6d8c98e1
md"""That $f(I)$ is an interval is a consequence of the Intermediate Value Theorem. That $f(I)$ contains its endpoints is the Extreme Value Theorem.
"""

# ╔═╡ 0ce4561e-539f-11ec-1e8b-63659d254e74
md"""On the real line, sets that are closed and bounded are "compact," a term that generalizes to other settings.
"""

# ╔═╡ 0ce456aa-539f-11ec-2340-29d7937d5bab
md"""> Continuity implies that the *image* of a compact set is compact.

"""

# ╔═╡ 0ce456e6-539f-11ec-061f-bb41edaeaa60
md"""Now let $(c,d)$ be an *open* interval in the range of $f$. An open interval is an open set. On the real line, an open set is one where each point in the set, $a$, has some $\delta$ such that if $|b-a| < \delta$ then $b$ is also in the set.
"""

# ╔═╡ 0ce45786-539f-11ec-015f-95c92723727d
md"""> Continuity implies that the *preimage* of an open set is an open set.

"""

# ╔═╡ 0ce457f4-539f-11ec-1a3a-6f73bbd6e17b
md"""The *preimage* of an open set, $I$, is $\{a: f(a) \in I\}$. (All $a$ with an image in $I$.) Taking some pair $(a,y)$ with $y$ in $I$ and $a$ in the preimage as $f(a)=y$. Let $\epsilon$ be such that $|x-y| < \epsilon$ implies $x$ is in $I$. Then as $f$ is continuous at $a$, given $\epsilon$ there is a $\delta$ such that $|b-a| <\delta$ implies $|f(b) - f(a)| < \epsilon$ or $|f(b)-y| < \epsilon$ which means that $f(b)$ is in the $I$ so $b$ is in the preimage, implying the preimage is an open set.
"""

# ╔═╡ 0ce457fe-539f-11ec-2ea1-cda4715d875f
md"""## Questions
"""

# ╔═╡ 0ce45876-539f-11ec-3ff4-1ddf5491b3b1
md"""###### Question
"""

# ╔═╡ 0ce4589e-539f-11ec-078d-f1cd3c71791d
md"""There is negative zero in the interval $[-10, 0]$ for the function $f(x) = e^x - x^4$. Find its value numerically:
"""

# ╔═╡ 0ce46078-539f-11ec-310a-b9f42ae7ec00
let
	f(x) = exp(x) - x^4
	val = find_zero(f, -10..0);
	numericq(val, 1e-3)
end

# ╔═╡ 0ce460b4-539f-11ec-0cd7-bfd5e5f7e63c
md"""###### Question
"""

# ╔═╡ 0ce460e6-539f-11ec-108d-4180720d0f25
md"""There is  zero in the interval $[0, 5]$ for the function $f(x) = e^x - x^4$. Find its value numerically:
"""

# ╔═╡ 0ce4687a-539f-11ec-0439-4d4a36da6afc
let
	f(x) = exp(x) - x^4
	val = find_zero(f, 0..5);
	numericq(val, 1e-3)
end

# ╔═╡ 0ce46898-539f-11ec-12c0-2d01d4f58583
md"""###### Question
"""

# ╔═╡ 0ce468ca-539f-11ec-2645-7dde530025e6
md"""Let $f(x) = x^2 - 10 \cdot x \cdot \log(x)$. This function has two zeros on the positive $x$ axis. You are asked to find the largest (graph and bracket...).
"""

# ╔═╡ 0ce46ce6-539f-11ec-2667-d16518ff9d0d
let
	b = 10
	f(x) =  x^2 - b * x * log(x)
	val = find_zero(f, 10..500)
	numericq(val, 1e-3)
end

# ╔═╡ 0ce46d98-539f-11ec-163a-0519e2f28a0b
md"""###### Question
"""

# ╔═╡ 0ce46dde-539f-11ec-0d68-47620d3cb93a
md"""The `airyai` function has infinitely many negative roots, as the function oscillates when $x < 0$ and *no* positive roots. Find the *second largest root* using the graph to bracket the answer, and then solve.
"""

# ╔═╡ 0ce47220-539f-11ec-0862-ed6efad32230
plot(airyai, -10, 10)   # `airyai` loaded in `SpecialFunctions` by `CalculusWithJulia`

# ╔═╡ 0ce4723e-539f-11ec-246e-63bb682f25ab
md"""The second largest root is:
"""

# ╔═╡ 0ce47a04-539f-11ec-30fb-07429b3ae23c
let
	val = find_zero(airyai, -5 .. -4);
	numericq(val, 1e-8)
end

# ╔═╡ 0ce47a22-539f-11ec-1a7d-9dbbe04235aa
md"""###### Question
"""

# ╔═╡ 0ce47a54-539f-11ec-2a20-8dbcc27f62a5
md"""(From [Strang](http://ocw.mit.edu/ans7870/resources/Strang/Edited/Calculus/Calculus.pdf), p. 37)
"""

# ╔═╡ 0ce47a7c-539f-11ec-318a-15ed0d6a9781
md"""Certainly $x^3$ equals $3^x$ at $x=3$. Find the largest value for which $x^3 = 3x$.
"""

# ╔═╡ 0ce486b6-539f-11ec-3c42-4372acfde003
let
	val = maximum(find_zeros(x -> x^3 - 3^x, 0..20))
	numericq(val)
end

# ╔═╡ 0ce486f2-539f-11ec-1743-e5bb69f157cf
md"""Compare $x^2$ and $2^x$. They meet at $2$, where do the meet again?
"""

# ╔═╡ 0ce4921e-539f-11ec-0699-b1ed0a50d965
let
	choices = ["Only before 2", "Only after 2", "Before and after 2"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0ce49304-539f-11ec-05c2-c5764688fc76
md"""Just by graphing, find a number in $b$ with $2 < b < 3$ where for values less than $b$ there is a zero beyond $b$ of $b^x - x^b$ and for values more than $b$ there isn't.
"""

# ╔═╡ 0ce49f2a-539f-11ec-15d5-330384aca902
let
	choices=[
	"``b \\approx 2.2``",
	"``b \\approx 2.5``",
	"``b \\approx 2.7``",
	"``b \\approx 2.9``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0ce4a022-539f-11ec-06cf-73bff69c1554
md"""###### Question: What goes up must come down...
"""

# ╔═╡ 0ce4a600-539f-11ec-065d-2199b17d91a1
let
	### {{{cannonball_img}}}
	figure= "figure/cannonball.j;b"
	caption = """
	Trajectories of potential cannonball fires with air-resistance included. (http://ej.iop.org/images/0143-0807/33/1/149/Full/ejp405251f1_online.jpg)
	"""
	#ImageFile(figure, caption)
	nothing
end

# ╔═╡ 0ce4a63c-539f-11ec-3f49-45d9259776ba
md"""![Trajectories of potential cannonball fires with air-resistance included. [Ref.](http://ej.iop.org/images/0143-0807/33/1/149/Full/ejp405251f1_online.jpg) ](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/limits/figures/cannonball.jpg)
"""

# ╔═╡ 0ce4a678-539f-11ec-3dbb-69af54f2c707
md"""In 1638, according to Amir D. [Aczel](http://books.google.com/books?id=kvGt2OlUnQ4C&pg=PA28&lpg=PA28&dq=mersenne+cannon+ball+tests&source=bl&ots=wEUd7e0jFk&sig=LpFuPoUvODzJdaoug4CJsIGZZHw&hl=en&sa=X&ei=KUGcU6OAKJCfyASnioCoBA&ved=0CCEQ6AEwAA#v=onepage&q=mersenne%20cannon%20ball%20tests&f=false), an experiment was performed in the French Countryside. A monk, Marin Mersenne, launched a cannonball straight up into the air in an attempt to help Descartes prove facts about the rotation of the earth. Though the experiment was not successful, Mersenne later observed that the time for the cannonball to go up was greater than the time to come down. ["Vertical Projection in a Resisting Medium: Reflections on Observations of Mersenne".](http://www.maa.org/publications/periodicals/american-mathematical-monthly/american-mathematical-monthly-contents-junejuly-2014)
"""

# ╔═╡ 0ce4a682-539f-11ec-00df-fd1863413c8b
md"""This isn't the case for simple ballistic motion where the time to go up is equal to the time to come down. We can "prove" this numerically. For simple ballistic motion:
"""

# ╔═╡ 0ce4a6be-539f-11ec-26a7-6d3f40e30ee7
md"""```math
f(t) = -\frac{1}{2} \cdot 32 t^2 + v_0t.
```
"""

# ╔═╡ 0ce4a6e6-539f-11ec-36fd-7dd48c683882
md"""The time to go up and down are found by the two zeros of this function. The peak time is related to a zero of a function given by `f'`, which for now we'll take as a mystery operation, but later will be known as the derivative. (The notation assumes `CalculusWithJulia` has been loaded.)
"""

# ╔═╡ 0ce4a70e-539f-11ec-0650-0388437c19a3
md"""Let $v_0= 390$. The three times in question can be found from the zeros of `f` and `f'`. What are they?
"""

# ╔═╡ 0ce4af74-539f-11ec-38d5-532c0508088e
let
	choices = ["``(0.0, 12.1875, 24.375)``",
		"``(-4.9731, 0.0, 4.9731)``",
		"``(0.0, 625.0, 1250.0)``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 0ce4aff6-539f-11ec-3adc-d5ad31a46c96
md"""###### Question What goes up must come down... (again)
"""

# ╔═╡ 0ce4b00c-539f-11ec-2b3c-63802386430f
md"""For simple ballistic motion you find that the time to go up is the time to come down. For motion within a resistant medium, such as air, this isn't the case. Suppose a model for the height as a function of time is given by
"""

# ╔═╡ 0ce4b028-539f-11ec-3167-4d9540546d59
md"""```math
h(t) = (\frac{g}{\gamma^2} + \frac{v_0}{\gamma})(1 - e^{-\gamma t}) - \frac{gt}{\gamma}
```
"""

# ╔═╡ 0ce4b050-539f-11ec-1774-35a1d2ecfc8e
md"""([From "On the trajectories of projectiles depicted in early ballistic Woodcuts"](http://www.researchgate.net/publication/230963032_On_the_trajectories_of_projectiles_depicted_in_early_ballistic_woodcuts))
"""

# ╔═╡ 0ce4b082-539f-11ec-3041-8d18cf5e0875
md"""Here $g=32$, again we take $v_0=390$, and $\gamma$ is a drag coefficient that we will take to be $1$.  This is valid when $h(t) \geq 0$.  In `Julia`, rather than hard-code the parameter values, for added flexibility we can pass them in as keyword arguments:
"""

# ╔═╡ 0ce538cc-539f-11ec-3abc-4f5d202d5aaa
h(t; g=32, v0=390, gamma=1) = (g/gamma^2 + v0/gamma)*(1 - exp(-gamma*t)) - g*t/gamma

# ╔═╡ 0ce5393a-539f-11ec-28a1-d716429bff16
md"""Now find the three times: $t_0$, the starting time; $t_a$, the time at the apex of the flight; and $t_f$, the time the object returns to the ground.
"""

# ╔═╡ 0ce56128-539f-11ec-3105-21e89f8aa942
let
	t0 = 0.0
	tf = find_zero(h, 10..20)
	ta = find_zero(D(h), t0..tf)
	choices = ["``(0, 13.187, 30.0)``",
		"``(0, 32.0, 390.0)``",
		"``(0, 2.579, 13.187)``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0ce56180-539f-11ec-336a-394f7a0e7f69
md"""###### Question
"""

# ╔═╡ 0ce561d0-539f-11ec-1bb5-77b8cf79df23
md"""Part of the proof of the intermediate value theorem rests on knowing what the limit is of $f(x)$ when $f(x) > y$ for all $x$. What can we say about $L$ supposing $L = \lim_{x \rightarrow c+}f(x)$ under  this assumption on $f$?
"""

# ╔═╡ 0ce56a7c-539f-11ec-2aa5-b7d1466d0c38
let
	choices = [L"It must be that $L > y$ as each $f(x)$ is.",
	L"It must be that $L \geq y$",
	L"It can happen that $L < y$, $L=y$, or $L>y$"]
	ans = 2
	radioq(choices, 2, keep_order=true)
end

# ╔═╡ 0ce56aa4-539f-11ec-1b7d-8741941da8aa
md"""###### Question
"""

# ╔═╡ 0ce56ae0-539f-11ec-3f2c-f96b3ea63520
md"""The extreme value theorem has two assumptions: a continuous function and a *closed* interval. Which of the following examples fails to satisfy the consequence of the  extreme value theorem because the interval is not closed? (The consequence - the existence of an absolute maximum and minimum - can happen even if the theorem does not apply.)
"""

# ╔═╡ 0ce57562-539f-11ec-21a0-8785a5a5d41f
let
	choices = [
	"``f(x) = \\sin(x),~ I=(-2\\pi, 2\\pi)``",
	"``f(x) = \\sin(x),~ I=(-\\pi, \\pi)``",
	"``f(x) = \\sin(x),~ I=(-\\pi/2, \\pi/2)``",
	"None of the above"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 0ce57580-539f-11ec-3e77-07be8512902a
md"""###### Question
"""

# ╔═╡ 0ce57634-539f-11ec-022a-8101fde38693
md"""The extreme value theorem has two assumptions: a continuous function and a *closed* interval. Which of the following examples fails to satisfy the consequence of the  extreme value theorem because the function is not continuous?
"""

# ╔═╡ 0ce57d28-539f-11ec-2fbb-1f1c8e4a8955
let
	choices = [
	"``f(x) = 1/x,~ I=[1,2]``",
	"``f(x) = 1/x,~ I=[-2, -1]``",
	"``f(x) = 1/x,~ I=[-1, 1]``",
	"none of the above"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 0ce57d44-539f-11ec-2eb8-ab257ca0c4cc
md"""###### Question
"""

# ╔═╡ 0ce57d64-539f-11ec-000a-d3551b8d616a
md"""The extreme value theorem has two assumptions: a continuous function and a *closed* interval. Which of the following examples fails to satisfy the consequence of the  extreme value theorem because the function is not continuous?
"""

# ╔═╡ 0ce584da-539f-11ec-0036-a920d71b3390
let
	choices = [
	"``f(x) = \\text{sign}(x),~  I=[-1, 1]``",
	"``f(x) = 1/x,~      I=[-4, -1]``",
	"``f(x) = \\text{floor}(x),~ I=[-1/2, 1/2]``",
	"none of the above"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 0ce584f0-539f-11ec-379c-958a07c8e83e
md"""###### Question
"""

# ╔═╡ 0ce5852a-539f-11ec-080f-f9bdefbbc37a
md"""The function $f(x) = x^3 - x$ is continuous over the interval $I=[-2,2]$. Find a value $c$ for which $M=f(c)$ is an absolute maximum over $I$.
"""

# ╔═╡ 0ce588c4-539f-11ec-2646-ddd8ee757b9e
let
	val = 2
	numericq(val)
end

# ╔═╡ 0ce588d6-539f-11ec-0982-b18e9fba8f1a
md"""###### Question
"""

# ╔═╡ 0ce588fe-539f-11ec-207a-3f52d5c4f073
md"""The function $f(x) = x^3 - x$ is continuous over the interval $I=[-1,1]$. Find a value $c$ for which $M=f(c)$ is an absolute maximum over $I$.
"""

# ╔═╡ 0ce58da4-539f-11ec-3403-ef1c0b2f5729
let
	val = -sqrt(3)/3
	numericq(val)
end

# ╔═╡ 0ce58db8-539f-11ec-385d-c7a82fab54b9
md"""###### Question
"""

# ╔═╡ 0ce58de0-539f-11ec-18c8-379804e3d8b3
md"""Consider the continuous function $f(x) = \sin(x)$ over the closed interval $I=[0, 10\pi]$. Which of these is true?
"""

# ╔═╡ 0ce5ac26-539f-11ec-1f85-0ddd76430765
let
	choices = [
	L"There is no value $c$ for which $f(c)$ is an absolute maximum over $I$.",
	L"There is just one value of $c$ for which $f(c)$ is an absolute maximum over $I$.",
	L"There are many values of $c$ for which $f(c)$ is an absolute maximum over $I$."
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 0ce5ac5a-539f-11ec-0b76-a1a75a736b90
md"""###### Question
"""

# ╔═╡ 0ce5ac94-539f-11ec-2abd-0366bdae341c
md"""Consider the continuous function $f(x) = \sin(x)$ over the closed interval $I=[0, 10\pi]$. Which of these is true?
"""

# ╔═╡ 0ce5b50e-539f-11ec-1b11-49b7443027f0
let
	choices = [
	L"There is no value $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$.",
	L"There is just one value $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$.",
	L"There are many values $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$."
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 0ce5b52a-539f-11ec-253b-c3a205e62226
md"""###### Question
"""

# ╔═╡ 0ce5b554-539f-11ec-25f6-13fcf91b599f
md"""The extreme value theorem says that on a closed interval a continuous function has an extreme value $M=f(c)$ for some $c$. Does it also say that $c$ is unique? Which of these examples might help you answer this?
"""

# ╔═╡ 0ce5bbf8-539f-11ec-0b34-99c54f993160
let
	choices = [
	"``f(x) = \\sin(x),\\quad I=[-\\pi/2, \\pi/2]``",
	"``f(x) = \\sin(x),\\quad I=[0, 2\\pi]``",
	"``f(x) = \\sin(x),\\quad I=[-2\\pi, 2\\pi]``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0ce5bc32-539f-11ec-1382-1105ecd01e24
md"""##### Question
"""

# ╔═╡ 0ce5bc70-539f-11ec-23c8-11dd93b00472
md"""The zeros of the equation $\cos(x) \cdot \cosh(x) = 1$ are related to vibrations of rods. Using `find_zeros`, what is the largest zero in the interval $[0, 6\pi]$?
"""

# ╔═╡ 0ce5c63e-539f-11ec-23d2-fb5df2a197ca
let
	val = maximum(find_zeros(x -> cos(x) * cosh(x) - 1, 0..6pi))
	numericq(val)
end

# ╔═╡ 0ce5c65c-539f-11ec-2939-db756d59f49d
md"""##### Question
"""

# ╔═╡ 0ce5c67c-539f-11ec-3e70-0ffd4a9d573f
md"""A parametric equation is specified by a parameterization $(f(t), g(t)), a \leq t \leq b$. The parameterization will be continuous if and only if each function is continuous.
"""

# ╔═╡ 0ce5c6c0-539f-11ec-32af-672e1b5f0eac
md"""Suppose $k_x$ and $k_y$ are positive integers and $a, b$ are positive numbers, will the [Lissajous](https://en.wikipedia.org/wiki/Parametric_equation#Lissajous_Curve) curve given by $(a\cos(k_x t), b\sin(k_y t))$ be continuous?
"""

# ╔═╡ 0ce5c8a8-539f-11ec-18e5-e398469eafcb
let
	yesnoq(true)
end

# ╔═╡ 0ce5c8d2-539f-11ec-3355-73d612566be9
md"""Here is a sample graph for $a=1, b=2, k_x=3, k_y=4$:
"""

# ╔═╡ 0ce5cd14-539f-11ec-0f8c-d3457effed42
let
	a,b = 1, 2
	k_x, k_y = 3, 4
	plot(t -> a * cos(k_x *t), t-> b * sin(k_y * t), 0, 4pi)
end

# ╔═╡ 0ce5cd46-539f-11ec-0a74-ff7916b53bb2
md"""---
"""

# ╔═╡ 0ce5cd8c-539f-11ec-1bc3-ed4030590ec5
md"""## Using `IntervalRootFinding` to identify all zeros in an interval
"""

# ╔═╡ 0ce5cde4-539f-11ec-2a24-f736ae43b06a
md"""The `IntervalRootFinding` package provides a more *rigorous* alternative to `find_zeros`. This packages leverages the interval arithmetic features of `IntervalArithmetic`. The `IntervalRootFinding` package provides a function `roots`, with usage similar to `find_zeros`. Intervals are specified with the notation `a..b`. In the following, we *qualify* `roots` to not conflict with the `roots` function from `SymPy`, which has already been loaded:
"""

# ╔═╡ 0ce5d45a-539f-11ec-1220-27c811b722e4
begin
	u(x) = sin(x) - 0.1*x^2 + 1
	𝑱 = IntervalArithmetic.Interval(-10, 10) # cumbersome -10..10; needed here: .. means something in CalculusWithJulia
	rts = IntervalRootFinding.roots(u, 𝑱)
end

# ╔═╡ 0ce5d46c-539f-11ec-2d96-9bb7efcbbc6c
md"""The "zeros" are returned with an enclosing interval and a flag, which for the above indicates a unique zero in the interval.
"""

# ╔═╡ 0ce5d480-539f-11ec-308d-15746c6cf6f0
md"""The intervals with a unique answer can be filtered and refined with a construct like the following:
"""

# ╔═╡ 0ce5eb1e-539f-11ec-3734-23d8a80dedb6
[find_zero(u, (IntervalArithmetic.interval(I).lo, IntervalArithmetic.interval(I).hi)) for I in rts if I.status == :unique]

# ╔═╡ 0ce5eb64-539f-11ec-33a4-d9f5e8513ecd
md"""The midpoint of the returned interval can be found by composing the `mid` function with the `interval` function of the package:
"""

# ╔═╡ 0ce6081a-539f-11ec-0c32-89450897e75f
[(IntervalArithmetic.mid ∘ IntervalArithmetic.interval)(I) for I in rts if I.status == :unique]

# ╔═╡ 0ce6084c-539f-11ec-31c6-db63fead8aa2
md"""For some problems, `find_zeros` is more direct, as with this one:
"""

# ╔═╡ 0ce60b80-539f-11ec-0681-2f1920a43310
find_zeros(u, -10..10)

# ╔═╡ 0ce60bbc-539f-11ec-34d3-afc30a0bf7a4
md"""Which can be useful if there is some prior understanding of the zeros expected to be found. However, `IntervalRootFinding` is more efficient computationally and *offers a guarantee* on the values found.
"""

# ╔═╡ 0ce60bc6-539f-11ec-174a-8913a50282bd
md"""For functions where roots are not "unique" a different output may appear:
"""

# ╔═╡ 0ce611ca-539f-11ec-3a9d-edf165e432d5
let
	f(x) = x*(x-1)^2
	rts = IntervalRootFinding.roots(f, 𝑱)
end

# ╔═╡ 0ce611f2-539f-11ec-166f-c55d6d75923f
md"""The interval labeled `:unknown` contains a `0`, but it can't be proved by `roots`.
"""

# ╔═╡ 0ce77790-539f-11ec-26cd-41a25c33d6a4
md"""Interval arithmetic finds **rigorous** **bounds** on the range of `f` values over a closed interval `a..b` (the range is `f(a..b)`).  "Rigorous" means the bounds are truthful and account for possible floating point issues. "Bounds" means the answer lies within, but the bound need not be the answer.
"""

# ╔═╡ 0ce777ec-539f-11ec-24d7-f340de81cf38
md"""This allows one – for some functions – to answer affirmatively questions like:
"""

# ╔═╡ 0ce7797a-539f-11ec-09d1-d99fe39800aa
md"""  * Is the function *always* positive on `a..b`? Negative? This can be done by checking if `0` is in the bound given by `f(a..b)`. If it isn't then one of the two characterizations is true.
  * Is the function *strictly increasing* on `a..b`? Strictly decreasing? These questions can be answered using the (upcoming) [derivative](../derivatives/derivatives.html). If the derivative is positive on `a..b` then `f` is strictly increasing, if negative on `a..b` then `f` is strictly decreasing. Finding the derivative can be done within the `IntervalArithmetic` framework using [automatic differentiation](../derivatives/numeric_derivatives.html), a blackbox operation  denoted `f'` below.
"""

# ╔═╡ 0ce77986-539f-11ec-17b0-25d742a4e336
md"""Combined, for some functions and some intervals these two questions can be answered affirmatively:
"""

# ╔═╡ 0ce77a18-539f-11ec-3acd-8d29751b251a
md"""  * the interval does not contain a zero (`0 !in f(a..b)`)
  * over the interval, the function crosses the `x` axis *once* (`f(a..a)` and `f(b..b)` are one positive and one negative *and* `f` is strictly monotone, or `0 !in f'(a..b)`)
"""

# ╔═╡ 0ce77a24-539f-11ec-224c-b70ef7a89d47
md"""This allows the following (simplified) bisection-like algorithm to be used:
"""

# ╔═╡ 0ce77b32-539f-11ec-3974-ade404705d52
md"""  * consider an interval `a..b`
  * if the function is *always* positive or negative, it can be discarded as no zero can be in the interval
  * if the function crosses the `x` axis *once* over this interval **then** there is a "unique" zero in the interval and the interval can be marked so and set aside
  * if neither of the above  *and* `a..b` is not too small already, then *sub-divide* the interval and repeat the above with *both* smaller intervals
  * if `a..b` is too small, stop and mark it as "unknown"
"""

# ╔═╡ 0ce77bc8-539f-11ec-096d-df657cd394dc
md"""When terminated there will be intervals with unique zeros flagged and smaller intervals with an unknown status.
"""

# ╔═╡ 0ce77bf2-539f-11ec-26d9-53fb2b5d0d7d
md"""Compared to the *bisection* algorithm – which only knows for some intervals if that interval has one or more crossings – this algorithm gives a more rigorous means to get all the zeros in `a..b`.
"""

# ╔═╡ 0ce77c24-539f-11ec-161e-ef9b32907496
md"""For a last example of the value of this package, this function, which appeared in our discussion on limits, is *positive* for **every** floating point number, but has two zeros snuck in at values within the floating point neighbors of $15/11$
"""

# ╔═╡ 0ce785aa-539f-11ec-0fe4-6102f781fc30
t(x) = x^2 + 1 +log(abs( 11*x-15 ))/99

# ╔═╡ 0ce7860e-539f-11ec-33f0-351c5e949ed2
md"""The `find_zeros` function will fail on identifying any potential zeros of this function. Even the basic call of `roots` will fail, due to it relying on some smoothness of `f`. However, explicitly asking for `Bisection` shows the *potential* for one or more zeros near $15/11$:
"""

# ╔═╡ 0ce7b912-539f-11ec-065f-95dc65b55dd8
IntervalRootFinding.roots(t, 𝑱, IntervalRootFinding.Bisection)

# ╔═╡ 0ce7b994-539f-11ec-23f0-ed9a00f12264
md"""(The basic algorithm above can be sped up using a variant of [Newton's](../derivatives/newton_method.html) method, this variant assumes some "smoothness" in the function `f`, whereas this `f` is not continuous at the point $x=15/11$.)
"""

# ╔═╡ 0ce7b9b2-539f-11ec-0605-c7400a943db2
HTML("""<div class="markdown"><blockquote>
<p><a href="../limits/continuity.html">◅ previous</a>  <a href="../derivatives/derivatives.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/limits/intermediate_value_theorem.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 0ce7b9bc-539f-11ec-027e-c9624681b49a
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
IntervalArithmetic = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
IntervalArithmetic = "~0.20.0"
IntervalRootFinding = "~0.5.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
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

[[CRlibm]]
deps = ["Libdl"]
git-tree-sha1 = "9d1c22cff9c04207f336b8e64840d0bd40d86e0e"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "0.8.0"

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

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

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

[[ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[FastRounding]]
deps = ["ErrorfreeArithmetic", "Test"]
git-tree-sha1 = "224175e213fd4fe112db3eea05d66b308dc2bf6b"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.2.0"

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

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalArithmetic]]
deps = ["CRlibm", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "5f6387acf62a633bfe21a28999eef5c6a39b638a"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.20.0"

[[IntervalRootFinding]]
deps = ["ForwardDiff", "IntervalArithmetic", "LinearAlgebra", "Polynomials", "Reexport", "StaticArrays"]
git-tree-sha1 = "b6969692c800cc5b90608fbd3be83189edc5e446"
uuid = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
version = "0.5.10"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

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

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

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

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

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

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "79bcbb379205f1c62913fa9ebecb413c7a35f8b0"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.18"

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

[[Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

[[RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

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

[[TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

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
# ╟─0ce7b99e-539f-11ec-079e-8900f1d6bd35
# ╟─0cd7b710-539f-11ec-39f0-79e69bb21f19
# ╟─0cd7c9b2-539f-11ec-02bb-193641b00947
# ╠═0cd8655c-539f-11ec-32e4-0bf925d5d572
# ╟─0cd86a04-539f-11ec-1eab-a3e271ca8ca6
# ╟─0cd86aa2-539f-11ec-2326-ef3976381ce0
# ╟─0cd86ab6-539f-11ec-061b-b3ac7ad4d7c2
# ╟─0cd86b2e-539f-11ec-17f9-1f55b4e0ff12
# ╟─0cd86d54-539f-11ec-0014-01af08b26622
# ╟─0cd99bf2-539f-11ec-1166-6b31c70fbbda
# ╟─0cd99c4c-539f-11ec-3d09-b73818130901
# ╟─0cd99cce-539f-11ec-356a-4388c6c937c9
# ╟─0cdcae3a-539f-11ec-07ba-2da8d2c68acd
# ╟─0cdcaef0-539f-11ec-183a-bb7f5c6b0e3e
# ╟─0cdcaf04-539f-11ec-35e0-67cc3be9f623
# ╟─0cdcaf2c-539f-11ec-20c0-cb4b99b2c96b
# ╟─0cdd2d30-539f-11ec-0cc4-07b2416e1bc0
# ╟─0cdd2dbc-539f-11ec-12f9-d160cb46a47f
# ╟─0cdd2dd0-539f-11ec-1f8a-55ea125dcecc
# ╟─0cdd2f60-539f-11ec-2c35-bfc4bd4caacd
# ╟─0cde7582-539f-11ec-20d8-9d7d27df94de
# ╟─0cde75dc-539f-11ec-3c09-23ef786a30b2
# ╟─0cde762c-539f-11ec-056a-7921653701b8
# ╟─0cde7640-539f-11ec-295a-1f66089040ed
# ╠═0cdea502-539f-11ec-12d7-91a145c66e6d
# ╟─0cdea5a0-539f-11ec-1384-1956da88e888
# ╟─0cdea5d4-539f-11ec-1484-7ffbca7114cb
# ╠═0cdeabb2-539f-11ec-0067-198889d32d9e
# ╟─0cdeac82-539f-11ec-15ef-fb4608e94231
# ╠═0cdeaee2-539f-11ec-2d48-4717c46ee4e8
# ╟─0cdeaf0c-539f-11ec-2cbe-a118c9408f27
# ╟─0cdeaf3e-539f-11ec-05d2-1b36710ca8f8
# ╟─0cdeaf84-539f-11ec-0aa9-9741d7a7ec43
# ╠═0cdeb5c4-539f-11ec-3e47-79b41064d87d
# ╟─0cdec5c8-539f-11ec-3eac-6141de964838
# ╟─0cdec606-539f-11ec-2c4b-23ff5e523ed0
# ╠═0cdee620-539f-11ec-26c8-134235edfb0f
# ╟─0cdee6d4-539f-11ec-0da4-f93b26643524
# ╟─0cdee71a-539f-11ec-0401-7930de6f3a00
# ╠═0cdeee4a-539f-11ec-19fd-2d2d3b524132
# ╟─0cdeee9a-539f-11ec-0852-dbf24e78c987
# ╠═0cdef408-539f-11ec-056d-d12861b684ba
# ╟─0cdef426-539f-11ec-2f7e-0fe95e613d2f
# ╟─0cdef458-539f-11ec-0841-33f6b093bd21
# ╠═0cdef93a-539f-11ec-1410-d153ea3ffceb
# ╟─0cdef962-539f-11ec-3a5d-f584cbb57f72
# ╠═0cdefc96-539f-11ec-285d-51320aaaf913
# ╟─0cdefcbe-539f-11ec-3619-8d6c1774c530
# ╟─0cdefcdc-539f-11ec-2e62-7fa583e69153
# ╟─0cdefcf0-539f-11ec-3251-2b10694ba29b
# ╟─0cdefd04-539f-11ec-0584-a35b1aa818ee
# ╠═0cdf0006-539f-11ec-31fe-bddb670a8d16
# ╟─0cdf002e-539f-11ec-2a3e-b91e80e3e296
# ╠═0cdf0586-539f-11ec-152a-4108fdced6c2
# ╟─0cdf05a6-539f-11ec-1a14-475a02befb49
# ╟─0cdf05b8-539f-11ec-3b98-37ada4ae2e32
# ╠═0cdf09ca-539f-11ec-2f47-6573e33d9e86
# ╟─0cdf09de-539f-11ec-1ba2-25591d8e1c5a
# ╟─0cdf0a10-539f-11ec-2c29-8bcd2eaf81e1
# ╠═0cdf0e68-539f-11ec-10bd-e91df1ca2d49
# ╟─0ce212b4-539f-11ec-0052-c111f0103220
# ╟─0ce2135c-539f-11ec-35c4-cdc912caded8
# ╠═0ce23582-539f-11ec-1cf5-9321e59783f7
# ╟─0ce235f0-539f-11ec-05ab-6b575ec794ac
# ╟─0ce2360e-539f-11ec-00df-5daf5aa027ac
# ╟─0ce23618-539f-11ec-0b66-a508bc969c6e
# ╟─0ce236ea-539f-11ec-1474-23c9c5432fe1
# ╟─0ce236fe-539f-11ec-1656-0744396cfc28
# ╟─0ce2373a-539f-11ec-3eac-6368abbcb7df
# ╠═0ce253fa-539f-11ec-17a5-8b1642a00090
# ╟─0ce25422-539f-11ec-1f81-412cf62c8877
# ╠═0ce25814-539f-11ec-2b75-3519ba674b11
# ╟─0ce25832-539f-11ec-1f09-9985aa84407a
# ╟─0ce25846-539f-11ec-177c-09d234a012f0
# ╠═0ce273bc-539f-11ec-03b7-07817340fbb7
# ╟─0ce273ee-539f-11ec-07bf-93e0456c22a8
# ╟─0ce2742a-539f-11ec-3ad1-dbbd4fe4b843
# ╟─0ce274b6-539f-11ec-0ce6-2fe3c828da71
# ╟─0ce274dc-539f-11ec-16ef-3758775701eb
# ╠═0ce28334-539f-11ec-0f16-c7919c89296c
# ╟─0ce28366-539f-11ec-1406-63e4c1eec324
# ╟─0ce2837a-539f-11ec-358a-c788ca5108ab
# ╟─0ce28410-539f-11ec-3c0c-f10f6aae8dbb
# ╠═0ce29568-539f-11ec-2242-b7457a815288
# ╟─0ce295a2-539f-11ec-2baa-a3b045b5139d
# ╟─0ce295b8-539f-11ec-2b13-93de4d208ceb
# ╠═0ce29812-539f-11ec-3e47-05b15f211fb8
# ╟─0ce29838-539f-11ec-27b7-e98050072af3
# ╠═0ce2b1e2-539f-11ec-0145-570255fc9e6a
# ╟─0ce2b21e-539f-11ec-181a-797f6216326a
# ╠═0ce2b476-539f-11ec-35d7-b5d9dccfb010
# ╟─0ce2b4a0-539f-11ec-0798-cd10e1c22b85
# ╠═0ce2b6e2-539f-11ec-1008-4f181139acbc
# ╟─0ce2b732-539f-11ec-36a4-c994520dc1e1
# ╠═0ce2ba48-539f-11ec-11bc-cb1b5340b7e4
# ╟─0ce2ba6e-539f-11ec-0629-c9cde2c4786d
# ╠═0ce2bbce-539f-11ec-0cd4-55fc9ba46ffb
# ╟─0ce2bbf6-539f-11ec-0c52-ed97d570b8c2
# ╠═0ce2c006-539f-11ec-083f-1f385baadd1d
# ╟─0ce2c024-539f-11ec-1abe-35098f7f4891
# ╟─0ce2c040-539f-11ec-1d21-31375371f753
# ╟─0ce2c056-539f-11ec-3277-21040e120b55
# ╠═0ce2c542-539f-11ec-303d-ed8f98d1fbe5
# ╟─0ce2c574-539f-11ec-0d25-318bccaa6af7
# ╟─0ce2c592-539f-11ec-3afa-134fb5a367fb
# ╟─0ce2c59c-539f-11ec-2a98-d1662e570d07
# ╟─0ce2c5ba-539f-11ec-171b-1d92b1093965
# ╟─0ce2c652-539f-11ec-1669-3fffc064aaaa
# ╟─0ce2c66e-539f-11ec-2d99-bfe2f1437797
# ╟─0ce2c68c-539f-11ec-0c9e-afa0ee3e0460
# ╟─0ce2c6aa-539f-11ec-0c82-5391a5248fc6
# ╠═0ce2e95a-539f-11ec-1fbd-67cde0a9df6c
# ╟─0ce2e996-539f-11ec-1531-07b9a62c1e66
# ╠═0ce3073a-539f-11ec-3c1b-83797312c64b
# ╟─0ce307b4-539f-11ec-3446-417678017b3a
# ╟─0ce307fa-539f-11ec-1bdf-33175402af5e
# ╟─0ce30822-539f-11ec-2923-c13740f11564
# ╟─0ce30842-539f-11ec-1229-c5574ae70a83
# ╟─0ce3084a-539f-11ec-0f5a-4d45708de991
# ╠═0ce30ffc-539f-11ec-312c-95ecfaac41fd
# ╟─0ce31010-539f-11ec-0889-61d9c53c59f2
# ╠═0ce31950-539f-11ec-2710-c5e6fa1eb508
# ╟─0ce31982-539f-11ec-1979-5f8e3d658b07
# ╟─0ce32046-539f-11ec-2329-43f46f5bfee7
# ╟─0ce32082-539f-11ec-0929-d975cf77e27e
# ╟─0ce320aa-539f-11ec-23d9-d5a4e816f593
# ╟─0ce32118-539f-11ec-0885-7da621783515
# ╠═0ce325be-539f-11ec-021d-031e16fb0db0
# ╟─0ce325dc-539f-11ec-1208-55eb674663d7
# ╠═0ce32820-539f-11ec-1e27-09ec213ab73a
# ╟─0ce32848-539f-11ec-063c-a5b014012a0d
# ╟─0ce32864-539f-11ec-0eaa-dfc5af914468
# ╟─0ce328c0-539f-11ec-2c04-d52b492593f8
# ╟─0ce328de-539f-11ec-0874-4575ae622fe7
# ╟─0ce328f2-539f-11ec-3f40-f15eedc80cd8
# ╠═0ce32df2-539f-11ec-33a8-6972b92c77ff
# ╟─0ce32e10-539f-11ec-311a-21975523ae33
# ╠═0ce3336a-539f-11ec-134f-e5081b782621
# ╟─0ce33388-539f-11ec-17aa-fb7f9c4ee4d5
# ╟─0ce333ba-539f-11ec-03fe-9d2771eb59b5
# ╟─0ce333c4-539f-11ec-14e7-21ec7b3ebc75
# ╟─0ce33416-539f-11ec-03f6-29d85ae92a8b
# ╟─0ce33536-539f-11ec-1044-630554e745b4
# ╟─0ce33554-539f-11ec-2a46-bda4f293e163
# ╟─0ce3361c-539f-11ec-2ef7-71d9c406b898
# ╟─0ce3363a-539f-11ec-3e02-7bae8c53e1d4
# ╟─0ce3368a-539f-11ec-3a9d-a9d55b4fadfe
# ╟─0ce336c6-539f-11ec-2378-4781e97283ee
# ╟─0ce33a90-539f-11ec-1552-ebdb7ff0ef70
# ╟─0ce442a0-539f-11ec-2d75-43e9fa274d81
# ╟─0ce44304-539f-11ec-20fe-63b9797c0541
# ╟─0ce44426-539f-11ec-19e3-272910306bc9
# ╟─0ce44458-539f-11ec-33f9-8be04b95a60c
# ╟─0ce44480-539f-11ec-17f5-79e70b7cfe12
# ╟─0ce44494-539f-11ec-14c7-39f70756c2dc
# ╟─0ce444b2-539f-11ec-1377-1f654acebc02
# ╟─0ce444da-539f-11ec-19e7-719d373ed604
# ╟─0ce444ee-539f-11ec-2bcc-d3c23bfd4ec7
# ╟─0ce44578-539f-11ec-29c1-15f819811785
# ╠═0ce44c96-539f-11ec-05e6-d3cab59199ab
# ╟─0ce44cbe-539f-11ec-1ad9-ef16e2f7692a
# ╟─0ce44d04-539f-11ec-16c6-9bcb93be120f
# ╟─0ce44d18-539f-11ec-338d-2f3e8e6ef2bc
# ╟─0ce44d40-539f-11ec-35b7-a134527160ac
# ╠═0ce454e8-539f-11ec-2be5-b58b19f96f9f
# ╟─0ce45524-539f-11ec-0cdd-19ef8e4a12d9
# ╟─0ce4552e-539f-11ec-0698-1b6faa834d09
# ╟─0ce4556a-539f-11ec-1a79-b11ef78f5702
# ╟─0ce45588-539f-11ec-3202-7dd36903a537
# ╟─0ce45594-539f-11ec-2dad-e3437e57a2b2
# ╟─0ce455c6-539f-11ec-0aed-a56acfcaac2c
# ╟─0ce45600-539f-11ec-1391-b324bcd5f8a6
# ╟─0ce45614-539f-11ec-2629-b55f6d8c98e1
# ╟─0ce4561e-539f-11ec-1e8b-63659d254e74
# ╟─0ce456aa-539f-11ec-2340-29d7937d5bab
# ╟─0ce456e6-539f-11ec-061f-bb41edaeaa60
# ╟─0ce45786-539f-11ec-015f-95c92723727d
# ╟─0ce457f4-539f-11ec-1a3a-6f73bbd6e17b
# ╟─0ce457fe-539f-11ec-2ea1-cda4715d875f
# ╟─0ce45876-539f-11ec-3ff4-1ddf5491b3b1
# ╟─0ce4589e-539f-11ec-078d-f1cd3c71791d
# ╟─0ce46078-539f-11ec-310a-b9f42ae7ec00
# ╟─0ce460b4-539f-11ec-0cd7-bfd5e5f7e63c
# ╟─0ce460e6-539f-11ec-108d-4180720d0f25
# ╟─0ce4687a-539f-11ec-0439-4d4a36da6afc
# ╟─0ce46898-539f-11ec-12c0-2d01d4f58583
# ╟─0ce468ca-539f-11ec-2645-7dde530025e6
# ╟─0ce46ce6-539f-11ec-2667-d16518ff9d0d
# ╟─0ce46d98-539f-11ec-163a-0519e2f28a0b
# ╟─0ce46dde-539f-11ec-0d68-47620d3cb93a
# ╠═0ce47220-539f-11ec-0862-ed6efad32230
# ╟─0ce4723e-539f-11ec-246e-63bb682f25ab
# ╟─0ce47a04-539f-11ec-30fb-07429b3ae23c
# ╟─0ce47a22-539f-11ec-1a7d-9dbbe04235aa
# ╟─0ce47a54-539f-11ec-2a20-8dbcc27f62a5
# ╟─0ce47a7c-539f-11ec-318a-15ed0d6a9781
# ╟─0ce486b6-539f-11ec-3c42-4372acfde003
# ╟─0ce486f2-539f-11ec-1743-e5bb69f157cf
# ╟─0ce4921e-539f-11ec-0699-b1ed0a50d965
# ╟─0ce49304-539f-11ec-05c2-c5764688fc76
# ╟─0ce49f2a-539f-11ec-15d5-330384aca902
# ╟─0ce4a022-539f-11ec-06cf-73bff69c1554
# ╟─0ce4a600-539f-11ec-065d-2199b17d91a1
# ╟─0ce4a63c-539f-11ec-3f49-45d9259776ba
# ╟─0ce4a678-539f-11ec-3dbb-69af54f2c707
# ╟─0ce4a682-539f-11ec-00df-fd1863413c8b
# ╟─0ce4a6be-539f-11ec-26a7-6d3f40e30ee7
# ╟─0ce4a6e6-539f-11ec-36fd-7dd48c683882
# ╟─0ce4a70e-539f-11ec-0650-0388437c19a3
# ╟─0ce4af74-539f-11ec-38d5-532c0508088e
# ╟─0ce4aff6-539f-11ec-3adc-d5ad31a46c96
# ╟─0ce4b00c-539f-11ec-2b3c-63802386430f
# ╟─0ce4b028-539f-11ec-3167-4d9540546d59
# ╟─0ce4b050-539f-11ec-1774-35a1d2ecfc8e
# ╟─0ce4b082-539f-11ec-3041-8d18cf5e0875
# ╠═0ce538cc-539f-11ec-3abc-4f5d202d5aaa
# ╟─0ce5393a-539f-11ec-28a1-d716429bff16
# ╟─0ce56128-539f-11ec-3105-21e89f8aa942
# ╟─0ce56180-539f-11ec-336a-394f7a0e7f69
# ╟─0ce561d0-539f-11ec-1bb5-77b8cf79df23
# ╟─0ce56a7c-539f-11ec-2aa5-b7d1466d0c38
# ╟─0ce56aa4-539f-11ec-1b7d-8741941da8aa
# ╟─0ce56ae0-539f-11ec-3f2c-f96b3ea63520
# ╟─0ce57562-539f-11ec-21a0-8785a5a5d41f
# ╟─0ce57580-539f-11ec-3e77-07be8512902a
# ╟─0ce57634-539f-11ec-022a-8101fde38693
# ╟─0ce57d28-539f-11ec-2fbb-1f1c8e4a8955
# ╟─0ce57d44-539f-11ec-2eb8-ab257ca0c4cc
# ╟─0ce57d64-539f-11ec-000a-d3551b8d616a
# ╟─0ce584da-539f-11ec-0036-a920d71b3390
# ╟─0ce584f0-539f-11ec-379c-958a07c8e83e
# ╟─0ce5852a-539f-11ec-080f-f9bdefbbc37a
# ╟─0ce588c4-539f-11ec-2646-ddd8ee757b9e
# ╟─0ce588d6-539f-11ec-0982-b18e9fba8f1a
# ╟─0ce588fe-539f-11ec-207a-3f52d5c4f073
# ╟─0ce58da4-539f-11ec-3403-ef1c0b2f5729
# ╟─0ce58db8-539f-11ec-385d-c7a82fab54b9
# ╟─0ce58de0-539f-11ec-18c8-379804e3d8b3
# ╟─0ce5ac26-539f-11ec-1f85-0ddd76430765
# ╟─0ce5ac5a-539f-11ec-0b76-a1a75a736b90
# ╟─0ce5ac94-539f-11ec-2abd-0366bdae341c
# ╟─0ce5b50e-539f-11ec-1b11-49b7443027f0
# ╟─0ce5b52a-539f-11ec-253b-c3a205e62226
# ╟─0ce5b554-539f-11ec-25f6-13fcf91b599f
# ╟─0ce5bbf8-539f-11ec-0b34-99c54f993160
# ╟─0ce5bc32-539f-11ec-1382-1105ecd01e24
# ╟─0ce5bc70-539f-11ec-23c8-11dd93b00472
# ╟─0ce5c63e-539f-11ec-23d2-fb5df2a197ca
# ╟─0ce5c65c-539f-11ec-2939-db756d59f49d
# ╟─0ce5c67c-539f-11ec-3e70-0ffd4a9d573f
# ╟─0ce5c6c0-539f-11ec-32af-672e1b5f0eac
# ╟─0ce5c8a8-539f-11ec-18e5-e398469eafcb
# ╟─0ce5c8d2-539f-11ec-3355-73d612566be9
# ╠═0ce5cd14-539f-11ec-0f8c-d3457effed42
# ╟─0ce5cd46-539f-11ec-0a74-ff7916b53bb2
# ╟─0ce5cd8c-539f-11ec-1bc3-ed4030590ec5
# ╟─0ce5cde4-539f-11ec-2a24-f736ae43b06a
# ╠═0ce5d45a-539f-11ec-1220-27c811b722e4
# ╟─0ce5d46c-539f-11ec-2d96-9bb7efcbbc6c
# ╟─0ce5d480-539f-11ec-308d-15746c6cf6f0
# ╠═0ce5eb1e-539f-11ec-3734-23d8a80dedb6
# ╟─0ce5eb64-539f-11ec-33a4-d9f5e8513ecd
# ╠═0ce6081a-539f-11ec-0c32-89450897e75f
# ╟─0ce6084c-539f-11ec-31c6-db63fead8aa2
# ╠═0ce60b80-539f-11ec-0681-2f1920a43310
# ╟─0ce60bbc-539f-11ec-34d3-afc30a0bf7a4
# ╟─0ce60bc6-539f-11ec-174a-8913a50282bd
# ╠═0ce611ca-539f-11ec-3a9d-edf165e432d5
# ╟─0ce611f2-539f-11ec-166f-c55d6d75923f
# ╟─0ce77790-539f-11ec-26cd-41a25c33d6a4
# ╟─0ce777ec-539f-11ec-24d7-f340de81cf38
# ╟─0ce7797a-539f-11ec-09d1-d99fe39800aa
# ╟─0ce77986-539f-11ec-17b0-25d742a4e336
# ╟─0ce77a18-539f-11ec-3acd-8d29751b251a
# ╟─0ce77a24-539f-11ec-224c-b70ef7a89d47
# ╟─0ce77b32-539f-11ec-3974-ade404705d52
# ╟─0ce77bc8-539f-11ec-096d-df657cd394dc
# ╟─0ce77bf2-539f-11ec-26d9-53fb2b5d0d7d
# ╟─0ce77c24-539f-11ec-161e-ef9b32907496
# ╠═0ce785aa-539f-11ec-0fe4-6102f781fc30
# ╟─0ce7860e-539f-11ec-33f0-351c5e949ed2
# ╠═0ce7b912-539f-11ec-065f-95dc65b55dd8
# ╟─0ce7b994-539f-11ec-23f0-ed9a00f12264
# ╟─0ce7b9b2-539f-11ec-0605-c7400a943db2
# ╟─0ce7b9b2-539f-11ec-396c-e3bc99603ac2
# ╟─0ce7b9bc-539f-11ec-027e-c9624681b49a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
