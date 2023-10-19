### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ b0fd2e06-70d2-11ec-114f-cf502ca7b5fc
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using QuadGK
	using Roots
end

# ╔═╡ b0fd32fc-70d2-11ec-01e7-b9f4e5186000
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size=(600, 400)
	
	nothing
end

# ╔═╡ b12fc618-70d2-11ec-343f-3f60ffe0f889
using PlutoUI

# ╔═╡ b12fc5fa-70d2-11ec-3951-977a4c43bdf5
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ b0e131d8-70d2-11ec-3b81-e737992089f0
md"""# Arc length
"""

# ╔═╡ b0e3a896-70d2-11ec-1687-6be082b6b92c
md"""This section uses these add-on packages:
"""

# ╔═╡ b0ff2396-70d2-11ec-221f-b124c21821e0
md"""---
"""

# ╔═╡ b0ff2bac-70d2-11ec-2c07-17c884654f62
let
	imgfile = "figures/jump-rope.png"
	caption = """
	
	A kids' jump rope by Lifeline is comprised of little plastic segments of uniform length around a cord. The length of the rope can be computed by adding up the lengths of each segment, regardless of how the rope is arranged.
	
	"""
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ b1055a4a-70d2-11ec-17da-4b160f03dfd6
md"""The length of the jump rope in the picture can be computed by either looking at the packaging it came in, or measuring the length of each plastic segment and multiplying by the number of segments. The former is easier, the latter provides the intuition as to how we can find the length of curves in the $x-y$ plane. The idea is old, [Archimedes](http://www.maa.org/external_archive/joma/Volume7/Aktumen/Polygon.html) used fixed length segments of polygons to approximate $\pi$ using the circumference of circle producing the bounds $3~\frac{1}{7} > \pi > 3~\frac{10}{71}$.
"""

# ╔═╡ b1055aa4-70d2-11ec-1fdd-f90471fa41bf
md"""A more modern application is the algorithm used by GPS devices to record a path taken. However, rather than record times for a fixed distance traveled, the GPS device records position ($(x,y)$) or longitude and latitude at fixed units of time - similar to how parametric functions are used. The device can then compute distance traveled and speed  using some familiar formulas.
"""

# ╔═╡ b108129e-70d2-11ec-23a9-51b76fba993e
md"""## Arc length formula
"""

# ╔═╡ b108130c-70d2-11ec-2036-45991dad44d1
md"""Recall the distance formula gives the distance between two points: $\sqrt{(x_1 - x_0)^2 + (y_1 - y_0)^2}$.
"""

# ╔═╡ b108133e-70d2-11ec-1c9c-e54ada426c92
md"""Consider now two functions $g(t)$ and $f(t)$ and the parameterized graph between $a$ and $b$ given by the points $(g(t), f(t))$ for $a \leq t \leq b$. Assume that both $g$ and $f$ are differentiable on $(a,b)$ and continuous on $[a,b]$ and furthermore that $\sqrt{g'(t)^2 + f'(t)^2}$ is Riemann integrable.
"""

# ╔═╡ b110ac24-70d2-11ec-353c-2dafaad0582f
md"""> **The arc length of a curve**. For $f$ and $g$ as described, the arc length of the parameterized curve is given by
>
> $L = \int_a^b \sqrt{g'(t)^2 + f'(t)^2} dt.$
>
> For the special case of the graph of a function $f(x)$ between $a$ and $b$ the formula becomes $L = \int_a^b \sqrt{ 1 + f'(x)^2} dx$ (taking $g(t) = t$).

"""

# ╔═╡ b110c66e-70d2-11ec-33c5-4d023efe7f35
note(L"""

The form of the integral may seem daunting with the square root and
the derivatives. A more general writing would create a vector out of
the two functions: $\phi(t) = \langle g(t), f(t) \rangle$. It is
natural to then let $\phi'(t) = \langle g'(t), f'(t) \rangle$. With
this, the integrand is just the norm - or length - of the
derivative, or $L=\int \| \phi'(t) \| dt$. This is similar to the
distance traveled being the integral of the speed, or the absolute
value of the derivative of position.

""")

# ╔═╡ b110c6dc-70d2-11ec-15af-375faa8a0a22
md"""To see why, any partition of the interval $[a,b]$ by $a = t_0 < t_1 < \cdots < t_n =b$ gives rise to $n+1$ points in the plane given by $(g(t_i), f(t_i))$.
"""

# ╔═╡ b1110bea-70d2-11ec-03c5-7f9257cac1a1
begin
	## {{{arclength_graph}}}
	function make_arclength_graph(n)
	
	    ns = [10,15,20, 30, 50]
	
	    g(t) = cos(t)/t
	    f(t) = sin(t)/t
	
	    ts = range(1, stop=4pi, length=200)
	    tis = range(1, stop=4pi, length=ns[n])
	
	    p = plot(g, f, 1, 4pi, legend=false, size=fig_size,
	             title="Approximate arc length with $(ns[n]) points")
	    plot!(p,  map(g, tis), map(f, tis), color=:orange)
	
	    p
	
	end
	
	n = 5
	anim = @animate for i=1:n
	    make_arclength_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	caption = L"""
	
	The arc length of the parametric curve can be approximated using straight line segments connecting points. This gives rise to an integral expression defining the length in terms of the functions $f$ and $g$.
	
	"""
	
	ImageFile(imgfile, caption)
end

# ╔═╡ b1110c3c-70d2-11ec-028b-b5ff77cb439e
md"""The distance between points $(g(t_i), f(t_i))$ and $(g(t_{i-1}), f(t_{i-1}))$ is just
"""

# ╔═╡ b11321aa-70d2-11ec-3a24-6f867513f887
md"""```math
d_i = \sqrt{(g(t_i)-g(t_{i-1}))^2 + (f(t_i)-f(t_{i-1}))^2}
```
"""

# ╔═╡ b1132242-70d2-11ec-25fe-c90bab93bf73
md"""The total approximate distance of the curve would be $L_n = d_1 + d_2 + \cdots + d_n$. This is exactly how we would compute the length of the jump rope or the distance traveled from GPS recordings.
"""

# ╔═╡ b1132260-70d2-11ec-19ee-15382dfe5dab
md"""However, differences, such as $f(t_i)-f(t_{i-1})$, are the building blocks of approximate derivatives. With an eye towards this, we multiply both top and bottom by $t_i - t_{i-1}$ to get:
"""

# ╔═╡ b1132280-70d2-11ec-0d61-89a17417921a
md"""```math
L_n = d_1 \cdot \frac{t_1 - t_0}{t_1 - t_0} + d_2 \cdot \frac{t_2 - t_1}{t_2 - t_1} + \cdots + d_n \cdot \frac{t_n - t_{n-1}}{t_n - t_{n-1}}.
```
"""

# ╔═╡ b1132292-70d2-11ec-00be-d1b1e689fe59
md"""But looking at each term, we can push the denominator into the square root as:
"""

# ╔═╡ b113229c-70d2-11ec-13d5-6d388f4f154f
md"""```math
\begin{align*}
d_i &= d_i \cdot \frac{t_i - t_{i-1}}{t_i - t_{i-1}}
\\
&= \sqrt{ \left(\frac{g(t_i)-g(t_{i-1})}{t_i-t_{i-1}}\right)^2 +
\left(\frac{f(t_i)-f(t_{i-1})}{t_i-t_{i-1}}\right)^2} \cdot (t_i - t_{i-1}) \\
&= \sqrt{ g'(\xi_i)^2 + f'(\psi_i)^2} \cdot (t_i - t_{i-1}).
\end{align*}
```
"""

# ╔═╡ b11322ba-70d2-11ec-2890-a3e26c2f88fe
md"""The values $\xi_i$ and $\psi_i$ are guaranteed by the mean value theorem and must be in $[t_{i-1}, t_i]$.
"""

# ╔═╡ b11322ce-70d2-11ec-3b81-63060da7e46d
md"""With this, if $\sqrt{f'(t)^2 + g'(t)^2}$ is integrable, as assumed, then as the size of the partition goes to zero, the sum of the $d_i$, $L_n$, must converge to the integral:
"""

# ╔═╡ b11322e0-70d2-11ec-09e6-d5d92029dac2
md"""```math
L = \int_a^b \sqrt{f'(t)^2 + g'(t)^2} dt.
```
"""

# ╔═╡ b1144c94-70d2-11ec-24c7-b7b03fd007df
md"""(This needs a technical adjustment to the Riemann theorem, as we are evaluating our function at two points in the interval. A general proof is [here](https://randomproofs.files.wordpress.com/2010/11/arc_length.pdf).)
"""

# ╔═╡ b1147340-70d2-11ec-10c1-77bb1ce98099
note(L"""

[Bressoud](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits/bressoud/)
notes that Gregory (1668) proved this formula for arc length of the
graph of a function by showing that the length of the curve $f(x)$ is defined
by the area under $\sqrt{1 + f'(x)^2}$. (It is commented that this was
also known a bit earlier by von Heurat.) Gregory went further though,
as part of the fundamental theorem of calculus was contained in his
work.  Gregory then posed this inverse question: given a curve
$y=g(x)$ find a function $u(x)$ so that the area under $g$ is equal to
the length of the second curve. The answer given was $u(x) =
(1/c)\int_a^x \sqrt{g^2(t) - c^2}$, which if $g(t) = \sqrt{1 + f'(t)^2}$
and $c=1$ says $u(x) = \int_a^x f(t)dt$.

An analogy might be a sausage maker. These take a mass of ground-up sausage material and return a long length of sausage. The material going in would depend on time via an equation like $\int_0^t g(u) du$ and the length coming out would be a constant (accounting for the cross section) times $u(t) = \int_0^t \sqrt{1 + g'(s)} ds$.

""")

# ╔═╡ b11701aa-70d2-11ec-163b-595e6ec69351
md"""#### Examples
"""

# ╔═╡ b1170222-70d2-11ec-322c-99eec4d1a435
md"""Let $f(x) = x^2$. The arc length of the graph of $f(x)$ over $[0,1]$ is then $L=\int_0^1 \sqrt{1 + (2x)^2} dx$. A trigonometric substitution of $2x = \sin(\theta)$ leads to the antiderivative:
"""

# ╔═╡ b1170844-70d2-11ec-129c-9d0540b2f7cc
begin
	@syms x
	F = integrate(sqrt(1 + (2x)^2), x)
end

# ╔═╡ b1170bd2-70d2-11ec-1159-81da029fbf1d
F(1) - F(0)

# ╔═╡ b1170c0c-70d2-11ec-1596-f3de0b672246
md"""That number has some context, as can be seen from the graph, which gives simple lower and upper bounds of $\sqrt{1^2 + 1^2} = 1.414...$ and $1 + 1 = 2$.
"""

# ╔═╡ b11710aa-70d2-11ec-2c61-7b10aaa767ff
begin
	f(x) = x^2
	plot(f, 0, 1)
end

# ╔═╡ b1171f64-70d2-11ec-1ea9-83d339e8b6e2
note(L"""

The integrand $\sqrt{1 + f'(x)^2}$ may seem odd at first, but it can be interpreted as the length of the hypotenuse of a right triangle with "run" of $1$ and "rise" of $f'(x)$. This triangle is easily formed using the tangent line to the graph of $f(x)$. By multiplying by $dx$, the integral is "summing" up the lengths of infinitesimal pieces of the tangent line approximation.

""")

# ╔═╡ b119aa7c-70d2-11ec-1878-03cc8665b49b
md"""##### Example
"""

# ╔═╡ b119aaf4-70d2-11ec-349a-6706ffecc380
md"""Let $f(t) = R\cos(t)$ and $g(t) = R\sin(t)$. Then the parametric curve over $[0, 2\pi]$ is a circle. As the curve does not wrap around, the arc-length of the curve is just the circumference of the circle. To see that the arc length formula gives us familiar answers, we have:
"""

# ╔═╡ b119ab12-70d2-11ec-3186-3dcaf06f604c
md"""```math
L = \int_0^{2\pi} \sqrt{(R\cos(t))^2 + (-R\sin(t))^2} dt = R\int_0^{2\pi} \sqrt{\cos(t)^2 + \sin(t)^2} dt =
R\int_0^{2\pi} dt = 2\pi R.
```
"""

# ╔═╡ b119ab30-70d2-11ec-0158-bd57bda97a0a
md"""##### Example
"""

# ╔═╡ b119ab44-70d2-11ec-1eac-c370e1fdbb68
md"""Let $f(x) = \log(x)$. Find the length of the graph of $f$ over $[1/e, e]$.
"""

# ╔═╡ b119ab4e-70d2-11ec-132f-45c3771ef133
md"""The answer is
"""

# ╔═╡ b119ab62-70d2-11ec-3aad-e12178ac1fb2
md"""```math
L = \int_{1/e}^e \sqrt{1 + \left(\frac{1}{x}\right)^2} dx.
```
"""

# ╔═╡ b121c950-70d2-11ec-2b6b-ada779f62626
md"""This has a *messy* antiderivative, so we let `SymPy` compute for us:
"""

# ╔═╡ b121d594-70d2-11ec-0c11-a58200738f47
ex = integrate(sqrt(1 + (1/x)^2), (x, 1/sympy.E, sympy.E))    # sympy.E is symbolic

# ╔═╡ b121d5c6-70d2-11ec-2577-0db5c5365af7
md"""Which isn't so satisfying. From a quick graph, we see the answer should be no more than 4, and we see in fact it is
"""

# ╔═╡ b121d74c-70d2-11ec-39e0-7b4bb341ffbc
N(ex)

# ╔═╡ b121d774-70d2-11ec-299b-cb6aee62d57a
md"""##### Example
"""

# ╔═╡ b121d7b8-70d2-11ec-12ff-352a315ccb62
md"""A [catenary shape](http://en.wikipedia.org/wiki/Catenary) is the shape a hanging chain will take as it is suspended between two posts. It appears elsewhere, for example, power wires will also have this shape as they are suspended between towers.  A formula for a catenary can be written in terms of the hyperbolic cosine, `cosh` in `julia` or exponentials.
"""

# ╔═╡ b121d7d8-70d2-11ec-261b-1f899225e777
md"""```math
y = a \cosh(x/a) = a \cdot \frac{e^{x/a} + e^{-x/a}}{2}.
```
"""

# ╔═╡ b121d80a-70d2-11ec-3cac-7dc1a4bd0fc0
md"""Suppose we have the following chain hung between $x=-1$ and $x=1$ with $a = 2$:
"""

# ╔═╡ b121e020-70d2-11ec-367f-49547fa8e3ca
begin
	chain(x; a=2) = a * cosh(x/a)
	plot(chain, -1, 1)
end

# ╔═╡ b121e05a-70d2-11ec-2dc9-4dd511d77ddc
md"""How long is the chain? Looking at the graph we can guess an answer is between $2$ and $2.5$, say, but it isn't much work to get an approximate numeric answer. Recall, the accompanying `CalculusWithJulia` package deines `f'` to find the derivative using the `ForwardDiff` package.
"""

# ╔═╡ b121ead6-70d2-11ec-2e62-01f2d4f358a4
quadgk(x -> sqrt(1 + chain'(x)^2), -1, 1)[1]

# ╔═╡ b121eafc-70d2-11ec-31ed-9b1d77a3ef3e
md"""We used a numeric approach, but this can be solved by hand and the answer is surprising.
"""

# ╔═╡ b121eb24-70d2-11ec-2665-5d04a7f8a7bd
md"""##### Example
"""

# ╔═╡ b121eb42-70d2-11ec-003f-65e3aa8336f9
md"""This picture of Jasper John's [Near the Lagoon](http://www.artic.edu/aic/collections/artwork/184095) was taken at The Art Institute Chicago.
"""

# ╔═╡ b121f18c-70d2-11ec-37d7-f795647bad42
let
	imgfile = "figures/johns-catenary.jpg"
	caption = "One of Jasper Johns' Catenary series. Art Institute of Chicago."
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ b121f1c8-70d2-11ec-22ac-f98d5c4e79be
md"""The museum notes have
"""

# ╔═╡ b121f2b8-70d2-11ec-2465-814f5795bcc3
md"""> For his Catenary series (1997–2003), of which Near the Lagoon is    the largest and last work, Johns formed catenaries—a term used to    describe the curve assumed by a cord suspended freely from two    points—by tacking ordinary household string to the canvas or its    supports.

"""

# ╔═╡ b121f2ea-70d2-11ec-3758-152494048936
md"""This particular catenary has a certain length. The basic dimensions are $78$in wide and $118$in drop. We shift the basic function for catenaries to have $f(78/2) = f(-78/2) = 0$ and $f(0) = -118$ (the top curve segment is on the $x$ axis and centered). We let our shifted function be parameterized by
"""

# ╔═╡ b121f308-70d2-11ec-2c10-3fc53a6629ec
md"""```math
f(x; a, b) = a \cosh(x/a) - b.
```
"""

# ╔═╡ b121f326-70d2-11ec-12ad-c9efba08b815
md"""Evaluating at $0$ gives:
"""

# ╔═╡ b121f330-70d2-11ec-20cf-7342c96dda87
md"""```math
-118 = a - b \text{ or } b = a + 118.
```
"""

# ╔═╡ b121f342-70d2-11ec-2053-97496a7d73b4
md"""Evaluating at $78/2$ gives: $a \cdot \cosh(78/(2a)) - (a + 118) = 0$. This can be solved numerically for a:
"""

# ╔═╡ b1220082-70d2-11ec-133f-ab882ae32952
begin
	cat(x; a=1, b=0) = a*cosh(x/a) - b
	find_zero(a -> cat(78/2, a=a, b=118 + a), 10)
end

# ╔═╡ b12200c8-70d2-11ec-2eed-db3537f5c224
md"""Rounding, we take $a=13$. With these parameters ($a=13$, $b = 131$), we compute the length of Johns' catenary in inches:
"""

# ╔═╡ b122049c-70d2-11ec-2859-274bee68dbe2
let
	a = 13
	b = 118 + a
	f(x) = cat(x, a=13, b=118+13)
	quadgk(x -> sqrt(1 + f'(x)^2), -78/2, 78/2)[1]
end

# ╔═╡ b12204c6-70d2-11ec-0a90-19778a35cde9
md"""##### Example
"""

# ╔═╡ b12204f4-70d2-11ec-3915-234e7b52a113
md"""Suspension bridges, like the Verrazzano-Narrows Bridge, have different loading than a cable and hence a different shape. A parabola is the shape the cable takes under uniform loading (cf. [page 19](http://calteches.library.caltech.edu/4007/1/Calculus.pdf) for a picture).
"""

# ╔═╡ b122051e-70d2-11ec-19ea-3d4a4bef561a
md"""The Verrazzano-Narrows [Bridge](https://www.brownstoner.com/brooklyn-life/verrazano-narrows-bridge-anniversary-historic-photos/) has a span of $1298$m.
"""

# ╔═╡ b1220532-70d2-11ec-375a-e1d4310f66c9
md"""Suppose the drop of the main cables is $147$ meters over this span. Then the cable itself can be modeled as a parabola with
"""

# ╔═╡ b1285266-70d2-11ec-1685-8514433137f4
md"""  * The $x$-intercepts $a = 1298/2$ and $-a$ and
  * vertex $(0,b)$ with $b=-147$.
"""

# ╔═╡ b1285298-70d2-11ec-267c-77225b891871
md"""The parabola that fits these three points is
"""

# ╔═╡ b12852ac-70d2-11ec-2f96-1bef63f091d1
md"""```math
y = \frac{-b}{a^2}(x^2 - a^2)
```
"""

# ╔═╡ b12852c0-70d2-11ec-2ac0-774a96af61ed
md"""Find the  length of the cable in meters.
"""

# ╔═╡ b12859e6-70d2-11ec-2341-4935313f11d1
let
	a = 1298/2;
	b = -147;
	f(x) = (-b/a^2)*(x^2 - a^2);
	val, _ = quadgk(x -> sqrt(1 + f'(x)^2), -a, a)
	val
end

# ╔═╡ b1285fc0-70d2-11ec-03da-71fa0c8f000d
let
	imgfile="figures/verrazzano-unloaded.jpg"
	caption = """
	The Verrazzano-Narrows Bridge during construction. The unloaded suspension cables form a catenary.
	"""
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ b128644a-70d2-11ec-220d-fdf56c93c167
let
	imgfile="figures/verrazzano-loaded.jpg"
	caption = """
	A rendering of the Verrazzano-Narrows Bridge after construction (cf. [nycgovparks.org](https://www.nycgovparks.org/highlights/verrazano-bridge)). The uniformly loaded suspension cables would form a parabola, presumably a fact the artist of this rendering knew. (The spelling in the link is not the official spelling, which carries two zs.)
	"""
	ImageFile(:integrals, imgfile, caption)
end

# ╔═╡ b1286486-70d2-11ec-3b1b-c3eda439f0c1
md"""##### Example
"""

# ╔═╡ b12864b8-70d2-11ec-3982-6dbaf66acda6
md"""The [nephroid](http://www-history.mcs.st-and.ac.uk/Curves/Nephroid.html) is a curve that can be described parametrically by
"""

# ╔═╡ b12864ce-70d2-11ec-1d13-35437d680c2f
md"""```math
\begin{align*}
g(t) &= a(3\cos(t) - \cos(3t)), \\
f(t) &= a(3\sin(t) - \sin(3t)).
\end{align*}
```
"""

# ╔═╡ b12864ea-70d2-11ec-1055-9d3acc0ab4ff
md"""Taking $a=1$ we have this graph:
"""

# ╔═╡ b1286906-70d2-11ec-2799-3b8c0ae40c1b
begin
	a = 1
	𝒈(t) = a*(3cos(t) - cos(3t))
	𝒇(t) = a*(3sin(t) - sin(3t))
	plot(𝒈, 𝒇, 0, 2pi)
end

# ╔═╡ b1286922-70d2-11ec-2ba5-27519f052f54
md"""Find the length of the perimeter of the closed figure formed by the graph.
"""

# ╔═╡ b128694a-70d2-11ec-0da3-4b884fafaef8
md"""We have $\sqrt{g'(t)^2 + f'(t)^2} = \sqrt{18 - 18\cos(2t)}$. An antiderivative isn't forthcoming through `SymPy`, so we take a numeric approach to find the length:
"""

# ╔═╡ b128727a-70d2-11ec-1730-9da0a10dda58
quadgk(t -> sqrt(𝒈'(t)^2 + 𝒇'(t)^2), 0, 2pi)[1]

# ╔═╡ b12872a0-70d2-11ec-227f-bd3a0677a457
md"""The answer seems like a floating point approximation of $24$, which  suggests that  this integral is tractable. Pursuing this, the integrand simplifies:
"""

# ╔═╡ b12872b4-70d2-11ec-32cf-9f9565834c8e
md"""```math
\begin{align*}
\sqrt{g'(t)^2 + f'(t)^2}
&= \sqrt{(-3\sin(t) + 3\sin(3t))^2 + (3\cos(t) - 3\cos(3t))^2} \\
&= 3\sqrt{(\sin(t)^2 - 2\sin(t)\sin(3t) + \sin(3t)^2) + (\cos(t)^2 -2\cos(t)\cos(3t) + \cos(3t)^2)} \\
&= 3\sqrt{(\sin(t)^2+\cos(t)^2) + (\sin(3t)^2 + \cos(3t)^2) - 2(\sin(t)\sin(3t) + \cos(t)\cos(3t))}\\
&= 3\sqrt{2(1 - (\sin(t)\sin(3t) + \cos(t)\cos(3t)))}\\
&= 3\sqrt{2}\sqrt{1 - \cos(2t)}\\
&= 3\sqrt{2}\sqrt{2\sin(t)^2}.
\end{align*}
```
"""

# ╔═╡ b12872d2-70d2-11ec-3b19-27c94395760a
md"""The second to last line comes from a double angle formula expansion of $\cos(3t - t)$ and the last line from the half angle formula for $\cos$.
"""

# ╔═╡ b12872e6-70d2-11ec-2c72-033abf685b88
md"""By graphing, we see that integrating over $[0,2\pi]$ gives twice the answer to integrating over $[0, \pi]$, which allows the simplification to:
"""

# ╔═╡ b12872f0-70d2-11ec-3d06-dbf14ede23c0
md"""```math
L = \int_0^{2\pi} \sqrt{g'(t)^2 + f'(t)^2}dt = \int_0^{2\pi} 3\sqrt{2}\sqrt{2\sin(t)^2} =
3 \cdot 2 \cdot 2 \int_0^\pi \sin(t) dt = 3 \cdot 2 \cdot 2 \cdot 2 = 24.
```
"""

# ╔═╡ b1287304-70d2-11ec-364b-795887647412
md"""##### Example
"""

# ╔═╡ b1287322-70d2-11ec-1e90-15a79d4d1990
md"""A teacher of small children assigns his students the task of computing the length of a jump rope by counting the number of $1$-inch segments it is made of. He knows that if a student is accurate, no matter how fast or slow they count the answer will be the same. (That is, unless the student starts counting in the wrong direction by mistake). The teacher knows this, as he is certain that the length of curve is independent of its parameterization, as it is a property intrinsic to the curve.
"""

# ╔═╡ b128734a-70d2-11ec-3a65-59dec6ddc4c4
md"""Mathematically, suppose a curve is described parametrically by $(g(t), f(t))$ for $a \leq t \leq b$. A new parameterization is provided by $\gamma(t)$. Suppose $\gamma$ is strictly increasing, so that an inverse function exists. (This assumption is implicitly made by the teacher, as it implies the student won't start counting in the wrong direction.) Then the same curve is described by composition through $(g(\gamma(u)), f(\gamma(u)))$, $\gamma^{-1}(a) \leq u \leq \gamma^{-1}(b)$. That the arc length is the same follows from substitution:
"""

# ╔═╡ b1287354-70d2-11ec-0b7c-073d3d90ea1c
md"""```math
\begin{align*}
\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{([g(\gamma(t))]')^2 + ([f(\gamma(t))]')^2} dt
&=\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{(g'(\gamma(t) )\gamma'(t))^2 + (f'(\gamma(t) )\gamma'(t))^2 } dt \\
&=\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{g'(\gamma(t))^2 + f'(\gamma(t))^2} \gamma'(t) dt\\
&=\int_a^b \sqrt{g'(u)^2 + f'(u)^2} du = L
\end{align*}
```
"""

# ╔═╡ b1287390-70d2-11ec-0c7e-217cb8c0cdd1
md"""(Using $u=\gamma(t)$ for the substitution.)
"""

# ╔═╡ b12873a4-70d2-11ec-2bff-e95b17a3b086
md"""In traveling there are two natural parameterizations: one by time, as in "how long have we been driving?"; and the other by distance, as in "how  far have we been driving?" Parameterizing by distance, or more technically arc length, has other mathematical advantages.
"""

# ╔═╡ b12873b8-70d2-11ec-24e3-7f01d91d63dc
md"""To parameterize by arc length, we just need to consider a special $\gamma$ defined by:
"""

# ╔═╡ b12873c2-70d2-11ec-1c11-d7c633688e9d
md"""```math
\gamma(u) = \int_0^u \sqrt{g'(t)^2 + f'(t)^2} dt.
```
"""

# ╔═╡ b12873e2-70d2-11ec-1020-873caaf13e36
md"""Supposing $\sqrt{g'(t)^2 + f'(t)^2}$ is continuous and positive, This transformation is increasing, as its derivative by the Fundamental Theorem of Calculus is $\gamma'(u) = \sqrt{g'(u)^2 + f'(u)^2}$, which by assumption is positive. (It is certainly non-negative.) So there exists an inverse function. That it exists is one thing, computing all of this is a different matter, of course.
"""

# ╔═╡ b12873fe-70d2-11ec-3a64-553b6aab637d
md"""For a simple example, we have $g(t) = R\cos(t)$ and $f(t)=R\sin(t)$ parameterizing the circle of radius $R$. The arc length between $0$ and $t$ is simply $\gamma(t) = Rt$, which we can easily see from the formula.  The inverse of this function is $\gamma^{-1}(u) = u/R$, so we get the parameterization $(g(Rt), f(Rt))$ for $0/R \leq t \leq 2\pi/R$.
"""

# ╔═╡ b128741c-70d2-11ec-16d0-f7a796cef368
md"""What looks at first glance to be just a slightly more complicated equation is that of an ellipse, with $g(t) = a\cos(t)$ and $f(t) = b\sin(t)$. Taking $a=1$ and $b = a + c$, for $c > 0$ we get the equation for the arc length as a function of $t$ is just
"""

# ╔═╡ b1287426-70d2-11ec-1fdd-415a8412edd5
md"""```math
\begin{align*}
s(u) &= \int_0^u \sqrt{(-\sin(t))^2 + b\cos(t)^2} dt\\
     &= \int_0^u \sqrt{\sin(t))^2 + \cos(t)^2 + c\cos(t)^2} dt  \\
	 &=\int_0^u \sqrt{1 + c\cos(t)^2} dt.
\end{align*}
```
"""

# ╔═╡ b1287442-70d2-11ec-14bd-b597f02969ec
md"""But, despite it not looking too daunting, this integral is not tractable through our techniques and has an answer involving elliptic integrals. We can work numerically though. Letting $a=1$ and $b=2$, we have the arc length is given by:
"""

# ╔═╡ b1287950-70d2-11ec-0771-b141d8b40b6d
begin
	𝒂, 𝒃 = 1, 2
	𝒔(u) = quadgk(t -> sqrt(𝒂^2 * sin(t)^2 + 𝒃^2 * cos(t)^2), 0, u)[1]
end

# ╔═╡ b1287962-70d2-11ec-0368-ad7b773bc74a
md"""This  has a graph, which does not look familiar, but we can see is monotonically increasing, so will have an inverse function:
"""

# ╔═╡ b1287ce4-70d2-11ec-10e0-695f1ebb4f23
plot(𝒔, 0, 2pi)

# ╔═╡ b1287d0e-70d2-11ec-3b04-875a773046b9
md"""The range is $[0, s(2\pi)]$.
"""

# ╔═╡ b129aaee-70d2-11ec-0e13-7b02d290a324
md"""The inverse function can be found by solving, we use the bracketing version of `find_zero` for this:
"""

# ╔═╡ b129cdaa-70d2-11ec-1798-75b00ef13175
sinv(u) = find_zero(x -> 𝒔(x) - u, (0, 𝒔(2pi)))

# ╔═╡ b129cdee-70d2-11ec-36d2-63750d80278e
md"""Here we see visually that the new parameterization yields the same curve:
"""

# ╔═╡ b129d34a-70d2-11ec-1373-437d7acfc819
let
	g(t) = 𝒂 * cos(t)
	f(t) = 𝒃 * sin(t)
	
	plot(t -> g(𝒔(t)), t -> f(𝒔(t)), 0, 𝒔(2*pi))
end

# ╔═╡ b129d38e-70d2-11ec-108e-113c029c3bbc
md"""#### Example: An implication of concavity
"""

# ╔═╡ b129d41a-70d2-11ec-3f29-4d479b3dbc74
md"""Following (faithfully) [Kantorwitz and Neumann](https://www.researchgate.net/publication/341676916_The_English_Galileo_and_His_Vision_of_Projectile_Motion_under_Air_Resistance), we consider a function $f(x)$ with the property that **both** $f$ and $f'$ are strictly concave down on $[a,b]$ and suppose $f(a) = f(b)$. Further, assume $f'$ is continuous. We will see this implies facts about arc-length and other integrals related to $f$.
"""

# ╔═╡ b129d442-70d2-11ec-0f18-e3f7b0e48965
md"""The following figure is clearly of a concave down function. The asymmetry about the critical point will be seen to be a result of the derivative also being concave down. This asymmetry will be characterized in several different ways in the following including showing that the arc length from $(a,0)$ to $(c,f(c))$ is longer than from $(c,f(c))$ to $(b,0)$.
"""

# ╔═╡ b129e89c-70d2-11ec-0269-9beeada8be17
let
	function trajectory(x; g = 9.8, v0 = 50, theta = 45*pi/180, k = 1/8)
	    a = v0 * cos(theta)
	    (g/(k*a) + tan(theta))* x + (g/k^2) * log(1 - k/a*x)
	end
	v0 = 50; theta = 45*pi/180; k = 1/5
	𝒂 = v0 * cos(theta)
	Δ = 𝒂/k
	a = find_zero(trajectory, (50, Δ-1/10))
	plot(trajectory,0, a, legend=false, linewidth=5)
	
	u=25
	fu = trajectory(u)
	v = find_zero(x -> trajectory(x) - fu, (50, Δ))
	plot!([u,v], [fu,fu])#, linestyle = :dash)
	
	c = find_zero(trajectory', (50, 100))
	plot!([c,c],[0, trajectory(c)])
	
	
	h(y)= tangent(trajectory, u)(y) - tangent(trajectory, v)(y)
	d = find_zero(h, (u,v))
	plot!(tangent(trajectory, u), 0, 110)
	plot!(tangent(trajectory, v), 75, 150)
	
	plot!(zero)
	𝒚 = 4
	annotate!([(0, 𝒚, "a"), (152, 𝒚, "b"), (u, 𝒚, "u"), (v, 𝒚, "v"), (c, 𝒚, "c")])
end

# ╔═╡ b129e8e2-70d2-11ec-19ff-c108a9fc0830
md"""Take $a < u < c < v < b$ with $f(u) = f(v)$ and $c$ a critical point, as in the picture. There must be a critical point by Rolle's theorem, and it must be unique, as the derivative, which exists by the assumptions, must be strictly decreasing due to concavity of $f$ and hence there can be at most $1$ critical point.
"""

# ╔═╡ b129e8f6-70d2-11ec-30a7-55013beb3316
md"""Some facts about this picture can be proven from the definition of concavity:
"""

# ╔═╡ b129e9b4-70d2-11ec-3ee5-ef07c5740586
md"""> The slope of the tangent line at $u$ goes up slower than the slope of the tangent line at $v$ declines:  $f'(u) < -f'(v)$.

"""

# ╔═╡ b129e9f0-70d2-11ec-3bfc-4f32da92429b
md"""Since $f'$ is *strictly* concave, we have for any $a<u<v<b$ from the definition of concavity that for all $0 \leq t \leq 1$
"""

# ╔═╡ b129ea0e-70d2-11ec-3622-7793f1cab8df
md"""```math
tf'(u) + (1-t)f'(v) < f'(tu + (1-t)v).
```
"""

# ╔═╡ b129ea22-70d2-11ec-03f4-f131202a8f69
md"""So
"""

# ╔═╡ b129ea2c-70d2-11ec-0c6d-7ff81195f053
md"""```math
\begin{align*}
\int_0^1 (tf'(u) + (1-t)f'(v)) dt &< \int_0^1 f'(tu + (1-t)v) dt, \text{or}\\
\frac{f'(u) + f'(v)}{2} &< \frac{1}{v-u}\int_u^v f'(w) dw,
\end{align*}
```
"""

# ╔═╡ b129ea4a-70d2-11ec-3f90-55eccbc1abad
md"""by the substitution $w = tu + (1-t)v$. Using the fundamental theorem of calculus to compute the mean value of the integral of $f'$ over $[u,v]$ gives the following as a consequence of strict concavity of $f'$:
"""

# ╔═╡ b129ea54-70d2-11ec-37a4-dbcbf9f4dd34
md"""```math
\frac{f'(u) + f'(v)}{2} < \frac{f(v)-f(u)}{v-u}
```
"""

# ╔═╡ b129ea72-70d2-11ec-1e9e-e3d01aeeb5aa
md"""The above is true for any $u$ and $v$, but, by assumption our $u$ and $v$ under consideration have $f(u) = f(v)$, hence it must be  $f'(u) < -f'(v)$.
"""

# ╔═╡ b129eac2-70d2-11ec-2959-c9de2c270a0e
md"""> The critical point is greater than the midpoint between $u$ and $v$:  $(u+v)/2 < c$.

"""

# ╔═╡ b129eb08-70d2-11ec-0db9-7996e272f191
md"""The function $f$ restricted to $[a,c]$ and $[c,b]$ is strictly monotone, as $f'$ only changes sign at $c$. Hence, there are inverse functions, say $f_1^{-1}$ and $f_2^{-1}$ taking $[0,m]$ to $[a,c]$ and $[c,b]$ respectively. The inverses are differentiable, as $f'$ exists, and must satisfy: $[f_1^{-1}]'(y) > 0$ (as $f'$ is positive on $[a,c]$) and, similarly, $[f_2^{-1}]'(y) < 0$. By the previous result, the inverses also satisfy:
"""

# ╔═╡ b129eb12-70d2-11ec-1117-0fd4f98722d1
md"""```math
[f_1^{-1}]'(y) > -[f_2^{-1}]'(y)
```
"""

# ╔═╡ b129eb1c-70d2-11ec-0b71-83fcb5e922eb
md"""(The inequality reversed due to the derivative of the inverse function being related to the reciprocal of the derivative of the function.)
"""

# ╔═╡ b129eb2e-70d2-11ec-00e6-2b22e18eb1f6
md"""For any $0 \leq \alpha < \beta \leq m$ we have:
"""

# ╔═╡ b129eb3a-70d2-11ec-0330-d59aebe72d06
md"""```math
\int_{\alpha}^{\beta} ([f_1^{-1}]'(y) +[f_2^{-1}]'(y)) dy > 0
```
"""

# ╔═╡ b129eb44-70d2-11ec-1d1a-effd592d4fed
md"""By the fundamental theorem of calculus:
"""

# ╔═╡ b129eb4e-70d2-11ec-3345-6f20dd045e91
md"""```math
(f_1^{-1}(y) + f_2^{-1}(y))\big|_\alpha^\beta > 0
```
"""

# ╔═╡ b129eb58-70d2-11ec-2724-db8d230d0798
md"""On rearranging:
"""

# ╔═╡ b129ec2a-70d2-11ec-108b-3d2442e5248b
md"""```math
f_1^{-1}(\alpha) + f_2^{-1}(\alpha) < f_1^{-1}(\beta) + f_2^{-1}(\beta)
```
"""

# ╔═╡ b129ec3e-70d2-11ec-3547-d3f72fdbee65
md"""That is $f_1^{-1} + f_2^{-1}$ is strictly increasing.
"""

# ╔═╡ b129ec5c-70d2-11ec-040d-6b794608beb6
md"""Taking $\beta=m$ gives a bound in terms of $c$ for any $0 \leq \alpha < m$:
"""

# ╔═╡ b129ec70-70d2-11ec-10e3-95e28269fe55
md"""```math
f_1^{-1}(\alpha) + f_2^{-1}(\alpha) < 2c.
```
"""

# ╔═╡ b129ec8e-70d2-11ec-358b-9fc0700ab780
md"""The result comes from setting $\alpha=f(u)$; setting $\alpha=0$ shows the result for $[a,b]$.
"""

# ╔═╡ b129ece8-70d2-11ec-14ce-c9939543b3c0
md"""> The intersection point of the two tangent lines, $d$, satisfies $(u+v)/2 < d$.

"""

# ╔═╡ b129ed10-70d2-11ec-3386-b3ab61fb5ac1
md"""If $f(u) = f(v)$, the previously established relationship between the slopes of the tangent lines suggests the answer. However, this statement is actually true more generally, with just the assumption that $u < v$ and not necessarily that $f(u)=f(v)$.
"""

# ╔═╡ b129ed2e-70d2-11ec-1f68-f1cf6c3d18ab
md"""Solving for $d$ from equations of the tangent lines gives
"""

# ╔═╡ b129ed42-70d2-11ec-13f2-fb924af9bab3
md"""```math
d = \frac{f(v)-f(u) + uf'(u) - vf'(v)}{f'(u) - f'(v)}
```
"""

# ╔═╡ b129ed56-70d2-11ec-0534-d744a4bc0923
md"""So $(u+v)/2 < d$ can be re-expressed as
"""

# ╔═╡ b129ed68-70d2-11ec-1d8e-afe381093218
md"""```math
\frac{f'(u) + f'(v)}{2} < \frac{f(v) - f(u)}{v-u}
```
"""

# ╔═╡ b129ed7e-70d2-11ec-1768-17a8de27ad0b
md"""which holds by the strict concavity of $f'$, as found previously.
"""

# ╔═╡ b129ee0a-70d2-11ec-1ae0-4d4e2ca18bb1
md"""> Let $h=f(u)$. The areas under $f$ are such that there is more area in $[a,u]$ than $[v,b]$ and more area under $f(x)-h$ in $[u,c]$ than $[c,v]$. In particular more area under $f$ over $[a,c]$ than $[c,b]$.

"""

# ╔═╡ b129ee1e-70d2-11ec-1b02-9d8794f189fe
md"""Using the substitution $x = f_i^{-1}(u)$ as needed to see:
"""

# ╔═╡ b129ee3e-70d2-11ec-260e-651f2c97872d
md"""```math
\begin{align*}
\int_a^u f(x) dx &= \int_0^{f(u)} u [f_1^{-1}]'(u) du \\
&> -\int_0^h u [f_2^{-1}]'(u) du \\
&= \int_h^0 u [f_2^{-1}]'(u) du \\
&= \int_v^b f(x) dx.
\end{align*}
```
"""

# ╔═╡ b129ee50-70d2-11ec-0133-5715e5ddf738
md"""For the latter claim, integrating in the $y$ variable gives
"""

# ╔═╡ b129ee64-70d2-11ec-257c-ef8909e91046
md"""```math
\begin{align*}
\int_u^c (f(x)-h) dx &= \int_h^m (c - f_1^{-1}(y)) dy\\
&> \int_h^m (c - f_2^{-1}(y)) dy\\
&= \int_c^v (f(x)-h) dx
\end{align*}
```
"""

# ╔═╡ b129ee82-70d2-11ec-368e-4b081d73be1d
md"""Now, the area under $h$ over $[u,c]$ is greater than that over $[c,v]$ as $(u+v)/2 < c$ or $v-c < c-u$. That means the area under $f$ over $[u,c]$ is greater than that over $[c,v]$.
"""

# ╔═╡ b129eedc-70d2-11ec-2573-235650817e27
md"""> There is more arc length for $f$over $[a,u]$ than $[v,b]$; more arc length for $f$ over $[u,c]$ than $[c,v]$. In particular more arc length over $[a,c]$ than $[c,b]$.

"""

# ╔═╡ b129ef02-70d2-11ec-105f-614d9d57e06f
md"""let $\phi(z) = f_2^{-1}(f_1(z))$ be the function taking $u$ to $v$, and $a$ to $b$ and moreover the interval $[a,u]$ to $[v,b]$. Further, $f(z) = f(\phi(z))$. The function is differentiable, as it is a composition of differentiable functions and for any $a \leq z \leq u$ we have
"""

# ╔═╡ b129ef0e-70d2-11ec-1445-a79dad7c804c
md"""```math
f'(\phi(z)) \cdot \phi'(z) = f'(z) < 0
```
"""

# ╔═╡ b129ef2c-70d2-11ec-0a0a-7324de0f6907
md"""or $\phi'(z) < 0$. Moreover, we have by the first assertion that $f'(z) < -f'(\phi(z))$ so $|\phi'(z)| = |f(z)/f'(\phi(z))| < 1$.
"""

# ╔═╡ b129ef34-70d2-11ec-2b73-dda3ddb194c3
md"""Using the substitution $x = \phi(z)$ gives:
"""

# ╔═╡ b129ef4a-70d2-11ec-266d-5d0c925c16ff
md"""```math
\begin{align*}
\int_v^b \sqrt{1 + f'(x)^2} dx &=
\int_u^a \sqrt{1 + f'(\phi(z))^2} \phi'(z) dz\\
&= \int_a^u \sqrt{1 + f'(\phi(z))^2} |\phi'(z)| dz\\
&= \int_a^u \sqrt{\phi'(z)^2 + (f'(\phi(z))\phi'(z))^2} dz\\
&= \int_a^u \sqrt{\phi'(z)^2 + f'(z)^2} dz\\
&< \int_a^u \sqrt{1 + f'(z)^2} dz
\end{align*}
```
"""

# ╔═╡ b129ef68-70d2-11ec-318f-db5dad3554a0
md"""Letting $h=f(u) \rightarrow c$ we get the *inequality*
"""

# ╔═╡ b129ef72-70d2-11ec-3628-95c98eda94ee
md"""```math
\int_c^b \sqrt{1 + f'(x)^2} dx \leq \int_a^c \sqrt{1 + f'(x)^2} dx,
```
"""

# ╔═╡ b129ef90-70d2-11ec-0b9a-5f65dbbe4041
md"""which must also hold for any paired $u,v=\phi(u)$. This allows the use of the strict inequality over $[v,b]$ and $[a,u]$ to give:
"""

# ╔═╡ b129efa6-70d2-11ec-2cfb-21af1e017bc5
md"""```math
\int_c^b \sqrt{1 + f'(x)^2} dx < \int_a^c \sqrt{1 + f'(x)^2} dx,
```
"""

# ╔═╡ b129efb8-70d2-11ec-38ce-b194fb4091d2
md"""which would also hold for any paired $u, v$.
"""

# ╔═╡ b129efcc-70d2-11ec-325e-0b95bdf96f0d
md"""Now, why is this of interest. Previously, we have considered the example of the trajectory of an arrow on a windy day given in function form by:
"""

# ╔═╡ b129efea-70d2-11ec-348d-1d8d408e3a3f
md"""```math
f(x) = \left(\frac{g}{k v_0\cos(\theta)} + \tan(\theta) \right) x + \frac{g}{k^2}\log\left(1 - \frac{k}{v_0\cos(\theta)} x \right)
```
"""

# ╔═╡ b129f00a-70d2-11ec-28d0-1f4e5be624cc
md"""This comes from solving the projectile motion equations with a drag force *proportional* to the velocity. This function satisfies:
"""

# ╔═╡ b129f7f6-70d2-11ec-3a48-4fe92c8ea0d9
let
	@syms g::postive, k::postive, v₀::positive, θ::postive, x::postive
	ex = (g/(k*v₀*cos(θ)) + tan(θ))*x + g/k^2 * log(1 - k/(v₀*cos(θ))*x)
	diff(ex, x, x), diff(ex, x, x, x,)
end

# ╔═╡ b129f828-70d2-11ec-3ded-7798e5c3f29f
md"""Both the second and third derivatives are negative (as $0 \leq x < (v_0\cos(\theta))/k$ due to the logarithm term), so, both $f$ and $f'$ are strictly concave down. Hence the results above apply. That is the arrow will fly further as it goes up, than as it comes down and will carve out more area on its way up, than its way down. The trajectory could also show time versus height, and the same would hold, e.g, the arrow would take longer to go up than come down.
"""

# ╔═╡ b129f83c-70d2-11ec-3d02-69d88418fa93
md"""In general, the drag force need not be proportional to the velocity, but merely in opposite direction to the velocity vector $\langle x'(t), y'(t) \rangle$:
"""

# ╔═╡ b129f850-70d2-11ec-0d27-c5d8b69c5b79
md"""```math
-m W(t, x(t), x'(t), y(t), y'(t)) \cdot \langle x'(t), y'(t)\rangle,
```
"""

# ╔═╡ b129f864-70d2-11ec-29fd-513ade42f769
md"""with the case above corresponding to $W = -m(k/m)$. The set of equations then satisfy:
"""

# ╔═╡ b129f86e-70d2-11ec-369d-bb692c24182e
md"""```math
\begin{align*}
x''(t) &= - W(t,x(t), x'(t), y(t), y'(t)) \cdot x'(t)\\
y''(t) &= -g - W(t,x(t), x'(t), y(t), y'(t)) \cdot y'(t)\\
\end{align*}
```
"""

# ╔═╡ b129f882-70d2-11ec-2ded-056e783e82ed
md"""with initial conditions: $x(0) = y(0) = 0$ and $x'(0) = v_0 \cos(\theta), y'(0) = v_0 \sin(\theta)$.
"""

# ╔═╡ b129f8a8-70d2-11ec-3cc6-49b5cb4196f7
md"""Only with certain drag forces, can this set of equations be be solved exactly, though it can be approximated numerically for admissible $W$, but if $W$ is strictly positive then it can be shown $x(t)$ is increasing on $[0, x_\infty)$ and so invertible, and $f(u) = y(x^{-1}(u))$ is three times differentiable with both $f$ and $f'$ being strictly concave, as it can be shown that (say $x(v) = u$ so $dv/du = 1/x'(v) > 0$):
"""

# ╔═╡ b129f8b4-70d2-11ec-3e11-d3540dbb8a17
md"""```math
\begin{align*}
f''(u) &= -\frac{g}{x'(v)^2} < 0\\
f'''(u) &= \frac{2gx''(v)}{x'(v)^3} \\
&= -\frac{2gW}{x'(v)^2}  \cdot \frac{dv}{du} < 0
\end{align*}
```
"""

# ╔═╡ b129f8be-70d2-11ec-0723-a923c8177eb4
md"""The latter by differentiating, the former a consequence of the following formulas for derivatives of inverse functions
"""

# ╔═╡ b129f8c8-70d2-11ec-07c7-05c46950c6c3
md"""```math
\begin{align*}
[x^{-1}]'(u) &= 1 / x'(v) \\
[x^{-1}]''(u) &= -x''(v)/(x'(v))^3
\end{align*}
```
"""

# ╔═╡ b129f8da-70d2-11ec-077d-b3058aae42d7
md"""For then
"""

# ╔═╡ b129f8e6-70d2-11ec-2d1c-a96c1f6a2e7c
md"""```math
\begin{align*}
f(u)   &= y(x^{-1}(u)) \\
f'(u)  &= y'(x^{-1}(u)) \cdot {x^{-1}}'(u) \\
f''(u) &= y''(x^{-1}(u))\cdot[x^{-1}]'(u)^2 + y'(x^{-1}(u)) \cdot [x^{-1}]''(u) \\
       &= y''(v) / (x'(v))^2 - y'(v) \cdot x''(v) / x'(v)^3\\
       &= -g/(x'(v))^2 - W y'/(x'(v))^2 - y'(v) \cdot (- W \cdot x'(v)) / x'(v)^3\\
       &= -g/x'(v)^2.
\end{align*}
```
"""

# ╔═╡ b129f90e-70d2-11ec-3fb9-b5fcdaa728e9
md"""## Questions
"""

# ╔═╡ b12d2bec-70d2-11ec-2ed3-3f735b0612b4
md"""###### Question
"""

# ╔═╡ b12d2c6e-70d2-11ec-3e9d-dfbd0df064d3
md"""The length of the curve given by $f(x) = e^x$ between $0$ and $1$ is certainly longer than the length of the line connecting $(0, f(0))$ and $(1, f(1))$. What is that length?
"""

# ╔═╡ b12d3312-70d2-11ec-0d27-ed923ed58aa6
let
	f(x) = exp(x)
	val = sqrt( (f(1) - f(0))^2 - (1 - 0)^2)
	numericq(val)
end

# ╔═╡ b12d3344-70d2-11ec-0c7c-2fca80adacac
md"""The length of the curve is certainly less than the length of going from $(0,f(0))$ to $(1, f(0))$ and then up to $(1, f(1))$. What is the length of this upper bound?
"""

# ╔═╡ b12d4046-70d2-11ec-0ea8-2d575cbd7db6
let
	val = (1 - 0) + (f(1) - f(0))
	numericq(val)
end

# ╔═╡ b12d406e-70d2-11ec-3240-a97212647e5c
md"""Now find the actual length of the curve numerically:
"""

# ╔═╡ b12d46cc-70d2-11ec-1293-29b71fcfea71
let
	a,b = 0, 1
	val, _ = quadgk(x -> sqrt(1 + exp(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12d46f4-70d2-11ec-374b-ab94cf0e205c
md"""###### Question
"""

# ╔═╡ b12d4730-70d2-11ec-3345-f7cbfd493a11
md"""Find the length of the graph of $f(x) = x^{3/2}$ between $0$ and $4$.
"""

# ╔═╡ b12d516c-70d2-11ec-15ff-db4b4129297c
let
	f(x) = x^(3/2)
	a, b = 0, 4
	val, _ = quadgk( x -> sqrt(1 + f'(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12d519e-70d2-11ec-2cc1-3142ec85883d
md"""###### Question
"""

# ╔═╡ b12d523e-70d2-11ec-1dfe-29c3c02cd519
md"""A [pursuit](http://www-history.mcs.st-and.ac.uk/Curves/Pursuit.html) curve is a track an optimal pursuer will take when chasing prey. The function $f(x) = x^2 - \log(x)$ is an example. Find the length of the curve between $1/10$ and $2$.
"""

# ╔═╡ b12d595c-70d2-11ec-0313-3101dadd8174
let
	f(x) = x^2 - log(x)
	a, b= 1/10, 2
	val, _ = quadgk( x -> sqrt(1 + (f)(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12d5982-70d2-11ec-07d2-d3ef18120989
md"""###### Question
"""

# ╔═╡ b12d59aa-70d2-11ec-1094-b58cedf30eb3
md"""Find the length of the graph of $f(x) = \tan(x)$ between $-\pi/4$ and $\pi/4$.
"""

# ╔═╡ b12d5f9a-70d2-11ec-29d4-c34844323939
let
	f(x) = tan(x)
	a, b= -pi/4, pi/4
	val, _ = quadgk( x -> sqrt(1 + f'(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12d5fd6-70d2-11ec-1c75-7d9d45e972c3
md"""Note, the straight line segment should be a close approximation and has length:
"""

# ╔═╡ b12d70d4-70d2-11ec-184a-ab8a160f9133
let
	sqrt((tan(pi/4) - tan(-pi/4))^2 + (pi/4 - -pi/4)^2)
end

# ╔═╡ b12d7138-70d2-11ec-3618-d17d1ffd4e5a
md"""###### Question
"""

# ╔═╡ b12d719c-70d2-11ec-2aa9-9fe17889ec4e
md"""Find the length of the graph of the function $g(x) =\int_0^x \tan(x)dx$ between $0$ and $\pi/4$ by hand or numerically:
"""

# ╔═╡ b12d76ce-70d2-11ec-3b70-b7fc0d430d65
let
	fp(x) = tan(x)
	a, b = 0, pi/4
	val, _ = quadgk(x -> sqrt(1 + fp(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12d76f6-70d2-11ec-2068-2b6f5ad93ce4
md"""###### Question
"""

# ╔═╡ b12d7728-70d2-11ec-1f1b-9302e10a9125
md"""A boat sits at the point $(a, 0)$ and a man holds a rope taut attached to the boat at the origin $(0,0)$. The man walks on the $y$ axis. The position $y$ depends then on the position $x$ of the boat, and if the rope is taut, the position satisfies:
"""

# ╔═╡ b12d7750-70d2-11ec-2335-25fc99d5c850
md"""```math
y = a \ln\frac{a + \sqrt{a^2 - x^2}}{x} - \sqrt{a^2 - x^2}
```
"""

# ╔═╡ b12d7778-70d2-11ec-0793-474d46870811
md"""This can be entered into `julia` as:
"""

# ╔═╡ b12d80b0-70d2-11ec-18fd-171333fa116b
g(x, a) = a * log((a + sqrt(a^2 - x^2))/x) - sqrt(a^2 - x^2)

# ╔═╡ b12d80ec-70d2-11ec-23ce-95a7cbfc116e
md"""Let $a=12$, $f(x) = g(x, a)$. Compute the length the bow of the boat has traveled between $x=1$ and $x=a$ using `quadgk`.
"""

# ╔═╡ b12d84ca-70d2-11ec-1f30-f1c82f883689
let
	a = 12
	f(x) = g(x, a);
	val = quadgk(x -> sqrt(1 + D(f)(x)^2), 1, a)[1];
	numericq(val, 1e-3)
end

# ╔═╡ b12d84f2-70d2-11ec-27e9-7dbdb0066a66
md"""(The most elementary description of this curve is in terms of the relationship $dy/dx = -\sqrt{a^2-x^2}/x$ which could be used in place of `D(f)` in your work.)
"""

# ╔═╡ b12d9578-70d2-11ec-0f09-b3b6a7be0877
let
	note("""
	
	To see an example of how the tractrix can be found in an everyday observation, follow this link on a description of [bicycle](https://simonsfoundation.org/multimedia/mathematical-impressions-bicycle-tracks) tracks.
	
	""")
end

# ╔═╡ b12d95a0-70d2-11ec-38a5-a11df637567d
md"""###### Question
"""

# ╔═╡ b12f507a-70d2-11ec-2748-01ff3b0fb2c7
md"""`SymPy` fails with the brute force approach to finding the length of a catenary, but can with a little help:
"""

# ╔═╡ b12f58ae-70d2-11ec-00a0-ad0ba4bfcce4
let
	@syms x::real a::real
	f(x,a) = a * cosh(x/a)
	inside = 1 + diff(f(x,a), x)^2
end

# ╔═╡ b12f5900-70d2-11ec-0b4d-5b35fb2e319a
md"""Just trying `integrate(sqrt(inside), x)` will fail, but if we try `integrate(sqrt(simplify(inside), x))` an antiderivative can be found. What is it?
"""

# ╔═╡ b12f6608-70d2-11ec-2a9f-e911b0b96b83
begin
	choices = ["``a \\sinh{\\left(\\frac{x}{a} \\right)}``",
	           "``\\frac{a \\sinh{\\left(\\frac{x}{a} \\right)} \\cosh{\\left(\\frac{x}{a} \\right)}}{2} - \\frac{x \\sinh^{2}{\\left(\\frac{x}{a} \\right)}}{2} + \\frac{x \\cosh^{2}{\\left(\\frac{x}{a} \\right)}}{2}``"
	           ]
	radioq(choices, 1)
end

# ╔═╡ b12f6632-70d2-11ec-0b1e-4bb320f70ac0
md"""###### Question
"""

# ╔═╡ b12f6682-70d2-11ec-3a02-ff2be2b396ce
md"""A curve is parameterized by $g(t) = t + \sin(t)$ and $f(t) = \cos(t)$. Find the arc length of the curve between $t=0$ and $\pi$.
"""

# ╔═╡ b12f846e-70d2-11ec-3b3b-037d12d91edc
let
	g(t) = t + sin(t)
	f(t) = cos(t)
	a, b = 0, pi
	val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12f84a0-70d2-11ec-3a38-6553f8d2c3aa
md"""###### Question
"""

# ╔═╡ b12f84f0-70d2-11ec-07bc-f14139f64e61
md"""The [astroid](http://www-history.mcs.st-and.ac.uk/Curves/Astroid.html) is a curve  parameterized by $g(t) = \cos(t)^3$ and $f(t) = \sin(t)^3$. Find the arc length of the curve between $t=0$ and $2\pi$. (This can be computed by hand or numerically.)
"""

# ╔═╡ b12f8a22-70d2-11ec-1e2d-b5d8130488e1
let
	g(t) = cos(t)^3
	f(t) = sin(t)^3
	a, b = 0, 2pi
	val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12f8a40-70d2-11ec-3fff-ab155cbe2880
md"""###### Question
"""

# ╔═╡ b12f8a68-70d2-11ec-343e-239cb9f2b1ec
md"""A curve is parameterized by $g(t) = (2t + 3)^{2/3}/3$ and $f(t) = t + t^2/2$, for $0\leq t \leq 3$. Compute the arc-length numerically or by hand:
"""

# ╔═╡ b12f9274-70d2-11ec-112d-8167312657e0
let
	g(t) = (2t+3)^(2/3)/3
	f(t) = t + t^2/2
	a, b = 0, 3
	val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
	numericq(val)
end

# ╔═╡ b12f9292-70d2-11ec-2a1e-dfc9767b09f3
md"""###### Question
"""

# ╔═╡ b12f92ce-70d2-11ec-03ef-f7bd9770f5a6
md"""The cycloid is parameterized by $g(t) = a(t - \sin(t))$ and $f(t) = a(1 - \cos(t))$ for $a > 0$. Taking $a=3$, and $t$ in $[0, 2\pi]$, find the length of the curve traced out. (This was solved by the architect and polymath [Wren](https://www.maa.org/sites/default/files/pdf/cmj_ftp/CMJ/January%202010/3%20Articles/3%20Martin/08-170.pdf) in 1650.)
"""

# ╔═╡ b12f9666-70d2-11ec-0343-970f3f360202
let
	a = 3
	g(t) = a*(t - sin(t))
	f(t) = a*(1 - cos(t))
	val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), 0, 2pi)
	numericq(val)
end

# ╔═╡ b12f968e-70d2-11ec-05a3-f915225f0f1c
md"""A cycloid parameterized this way can be generated by a circle of radius $a$. Based on this example, what do you think Wren wrote to Pascal about this length:
"""

# ╔═╡ b12fa5a2-70d2-11ec-33f0-9b78ecfc54e8
let
	choices = ["The length of the cycloidal arch is exactly **two** times the radius of the generating
	circle.",
	           "The length of the cycloidal arch is exactly **four** times the radius of the generating
	circle.",
	           "The length of the cycloidal arch is exactly **eight** times the radius of the generating
	circle."]
	radioq(choices, 3, keep_order=true)
end

# ╔═╡ b12fc5ee-70d2-11ec-32ec-cf6875c28df6
let
	note("""
	In [Martin](https://www.maa.org/sites/default/files/pdf/cmj_ftp/CMJ/January%202010/3%20Articles/3%20Martin/08-170.pdf) we read why Wren was mailing Pascal:
	
	After demonstrating mathematical talent at an early age, Blaise Pascal
	turned his attention to theology, denouncing the study of mathematics
	as a vainglorious pursuit. Then one night, unable to sleep as the
	result of a toothache, he began thinking about the cycloid and to his
	surprise, his tooth stopped aching. Taking this as a sign that he had
	God’s approval to continue, Pascal spent the next eight days studying
	the curve.  During this time he discovered nearly all of the geometric
	properties of the cycloid. He issued some of his results in ``1658`` in
	the form of a contest, offering a prize of forty Spanish gold pieces
	and a second prize of twenty pieces.
	
	""")
end

# ╔═╡ b12fc618-70d2-11ec-081f-8b1c218b7132
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/volumes_slice.html">◅ previous</a>  <a href="../integrals/surface_area.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/arc_length.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ b12fc620-70d2-11ec-2436-0541d974018c
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.13"
Plots = "~1.25.4"
PlutoUI = "~0.7.29"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
Roots = "~1.3.14"
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
# ╟─b12fc5fa-70d2-11ec-3951-977a4c43bdf5
# ╟─b0e131d8-70d2-11ec-3b81-e737992089f0
# ╟─b0e3a896-70d2-11ec-1687-6be082b6b92c
# ╠═b0fd2e06-70d2-11ec-114f-cf502ca7b5fc
# ╟─b0fd32fc-70d2-11ec-01e7-b9f4e5186000
# ╟─b0ff2396-70d2-11ec-221f-b124c21821e0
# ╟─b0ff2bac-70d2-11ec-2c07-17c884654f62
# ╟─b1055a4a-70d2-11ec-17da-4b160f03dfd6
# ╟─b1055aa4-70d2-11ec-1fdd-f90471fa41bf
# ╟─b108129e-70d2-11ec-23a9-51b76fba993e
# ╟─b108130c-70d2-11ec-2036-45991dad44d1
# ╟─b108133e-70d2-11ec-1c9c-e54ada426c92
# ╟─b110ac24-70d2-11ec-353c-2dafaad0582f
# ╟─b110c66e-70d2-11ec-33c5-4d023efe7f35
# ╟─b110c6dc-70d2-11ec-15af-375faa8a0a22
# ╟─b1110bea-70d2-11ec-03c5-7f9257cac1a1
# ╟─b1110c3c-70d2-11ec-028b-b5ff77cb439e
# ╟─b11321aa-70d2-11ec-3a24-6f867513f887
# ╟─b1132242-70d2-11ec-25fe-c90bab93bf73
# ╟─b1132260-70d2-11ec-19ee-15382dfe5dab
# ╟─b1132280-70d2-11ec-0d61-89a17417921a
# ╟─b1132292-70d2-11ec-00be-d1b1e689fe59
# ╟─b113229c-70d2-11ec-13d5-6d388f4f154f
# ╟─b11322ba-70d2-11ec-2890-a3e26c2f88fe
# ╟─b11322ce-70d2-11ec-3b81-63060da7e46d
# ╟─b11322e0-70d2-11ec-09e6-d5d92029dac2
# ╟─b1144c94-70d2-11ec-24c7-b7b03fd007df
# ╟─b1147340-70d2-11ec-10c1-77bb1ce98099
# ╟─b11701aa-70d2-11ec-163b-595e6ec69351
# ╟─b1170222-70d2-11ec-322c-99eec4d1a435
# ╠═b1170844-70d2-11ec-129c-9d0540b2f7cc
# ╠═b1170bd2-70d2-11ec-1159-81da029fbf1d
# ╟─b1170c0c-70d2-11ec-1596-f3de0b672246
# ╠═b11710aa-70d2-11ec-2c61-7b10aaa767ff
# ╟─b1171f64-70d2-11ec-1ea9-83d339e8b6e2
# ╟─b119aa7c-70d2-11ec-1878-03cc8665b49b
# ╟─b119aaf4-70d2-11ec-349a-6706ffecc380
# ╟─b119ab12-70d2-11ec-3186-3dcaf06f604c
# ╟─b119ab30-70d2-11ec-0158-bd57bda97a0a
# ╟─b119ab44-70d2-11ec-1eac-c370e1fdbb68
# ╟─b119ab4e-70d2-11ec-132f-45c3771ef133
# ╟─b119ab62-70d2-11ec-3aad-e12178ac1fb2
# ╟─b121c950-70d2-11ec-2b6b-ada779f62626
# ╠═b121d594-70d2-11ec-0c11-a58200738f47
# ╟─b121d5c6-70d2-11ec-2577-0db5c5365af7
# ╠═b121d74c-70d2-11ec-39e0-7b4bb341ffbc
# ╟─b121d774-70d2-11ec-299b-cb6aee62d57a
# ╟─b121d7b8-70d2-11ec-12ff-352a315ccb62
# ╟─b121d7d8-70d2-11ec-261b-1f899225e777
# ╟─b121d80a-70d2-11ec-3cac-7dc1a4bd0fc0
# ╠═b121e020-70d2-11ec-367f-49547fa8e3ca
# ╟─b121e05a-70d2-11ec-2dc9-4dd511d77ddc
# ╠═b121ead6-70d2-11ec-2e62-01f2d4f358a4
# ╟─b121eafc-70d2-11ec-31ed-9b1d77a3ef3e
# ╟─b121eb24-70d2-11ec-2665-5d04a7f8a7bd
# ╟─b121eb42-70d2-11ec-003f-65e3aa8336f9
# ╟─b121f18c-70d2-11ec-37d7-f795647bad42
# ╟─b121f1c8-70d2-11ec-22ac-f98d5c4e79be
# ╟─b121f2b8-70d2-11ec-2465-814f5795bcc3
# ╟─b121f2ea-70d2-11ec-3758-152494048936
# ╟─b121f308-70d2-11ec-2c10-3fc53a6629ec
# ╟─b121f326-70d2-11ec-12ad-c9efba08b815
# ╟─b121f330-70d2-11ec-20cf-7342c96dda87
# ╟─b121f342-70d2-11ec-2053-97496a7d73b4
# ╠═b1220082-70d2-11ec-133f-ab882ae32952
# ╟─b12200c8-70d2-11ec-2eed-db3537f5c224
# ╠═b122049c-70d2-11ec-2859-274bee68dbe2
# ╟─b12204c6-70d2-11ec-0a90-19778a35cde9
# ╟─b12204f4-70d2-11ec-3915-234e7b52a113
# ╟─b122051e-70d2-11ec-19ea-3d4a4bef561a
# ╟─b1220532-70d2-11ec-375a-e1d4310f66c9
# ╟─b1285266-70d2-11ec-1685-8514433137f4
# ╟─b1285298-70d2-11ec-267c-77225b891871
# ╟─b12852ac-70d2-11ec-2f96-1bef63f091d1
# ╟─b12852c0-70d2-11ec-2ac0-774a96af61ed
# ╠═b12859e6-70d2-11ec-2341-4935313f11d1
# ╟─b1285fc0-70d2-11ec-03da-71fa0c8f000d
# ╟─b128644a-70d2-11ec-220d-fdf56c93c167
# ╟─b1286486-70d2-11ec-3b1b-c3eda439f0c1
# ╟─b12864b8-70d2-11ec-3982-6dbaf66acda6
# ╟─b12864ce-70d2-11ec-1d13-35437d680c2f
# ╟─b12864ea-70d2-11ec-1055-9d3acc0ab4ff
# ╠═b1286906-70d2-11ec-2799-3b8c0ae40c1b
# ╟─b1286922-70d2-11ec-2ba5-27519f052f54
# ╟─b128694a-70d2-11ec-0da3-4b884fafaef8
# ╠═b128727a-70d2-11ec-1730-9da0a10dda58
# ╟─b12872a0-70d2-11ec-227f-bd3a0677a457
# ╟─b12872b4-70d2-11ec-32cf-9f9565834c8e
# ╟─b12872d2-70d2-11ec-3b19-27c94395760a
# ╟─b12872e6-70d2-11ec-2c72-033abf685b88
# ╟─b12872f0-70d2-11ec-3d06-dbf14ede23c0
# ╟─b1287304-70d2-11ec-364b-795887647412
# ╟─b1287322-70d2-11ec-1e90-15a79d4d1990
# ╟─b128734a-70d2-11ec-3a65-59dec6ddc4c4
# ╟─b1287354-70d2-11ec-0b7c-073d3d90ea1c
# ╟─b1287390-70d2-11ec-0c7e-217cb8c0cdd1
# ╟─b12873a4-70d2-11ec-2bff-e95b17a3b086
# ╟─b12873b8-70d2-11ec-24e3-7f01d91d63dc
# ╟─b12873c2-70d2-11ec-1c11-d7c633688e9d
# ╟─b12873e2-70d2-11ec-1020-873caaf13e36
# ╟─b12873fe-70d2-11ec-3a64-553b6aab637d
# ╟─b128741c-70d2-11ec-16d0-f7a796cef368
# ╟─b1287426-70d2-11ec-1fdd-415a8412edd5
# ╟─b1287442-70d2-11ec-14bd-b597f02969ec
# ╠═b1287950-70d2-11ec-0771-b141d8b40b6d
# ╟─b1287962-70d2-11ec-0368-ad7b773bc74a
# ╠═b1287ce4-70d2-11ec-10e0-695f1ebb4f23
# ╟─b1287d0e-70d2-11ec-3b04-875a773046b9
# ╟─b129aaee-70d2-11ec-0e13-7b02d290a324
# ╠═b129cdaa-70d2-11ec-1798-75b00ef13175
# ╟─b129cdee-70d2-11ec-36d2-63750d80278e
# ╠═b129d34a-70d2-11ec-1373-437d7acfc819
# ╟─b129d38e-70d2-11ec-108e-113c029c3bbc
# ╟─b129d41a-70d2-11ec-3f29-4d479b3dbc74
# ╟─b129d442-70d2-11ec-0f18-e3f7b0e48965
# ╟─b129e89c-70d2-11ec-0269-9beeada8be17
# ╟─b129e8e2-70d2-11ec-19ff-c108a9fc0830
# ╟─b129e8f6-70d2-11ec-30a7-55013beb3316
# ╟─b129e9b4-70d2-11ec-3ee5-ef07c5740586
# ╟─b129e9f0-70d2-11ec-3bfc-4f32da92429b
# ╟─b129ea0e-70d2-11ec-3622-7793f1cab8df
# ╟─b129ea22-70d2-11ec-03f4-f131202a8f69
# ╟─b129ea2c-70d2-11ec-0c6d-7ff81195f053
# ╟─b129ea4a-70d2-11ec-3f90-55eccbc1abad
# ╟─b129ea54-70d2-11ec-37a4-dbcbf9f4dd34
# ╟─b129ea72-70d2-11ec-1e9e-e3d01aeeb5aa
# ╟─b129eac2-70d2-11ec-2959-c9de2c270a0e
# ╟─b129eb08-70d2-11ec-0db9-7996e272f191
# ╟─b129eb12-70d2-11ec-1117-0fd4f98722d1
# ╟─b129eb1c-70d2-11ec-0b71-83fcb5e922eb
# ╟─b129eb2e-70d2-11ec-00e6-2b22e18eb1f6
# ╟─b129eb3a-70d2-11ec-0330-d59aebe72d06
# ╟─b129eb44-70d2-11ec-1d1a-effd592d4fed
# ╟─b129eb4e-70d2-11ec-3345-6f20dd045e91
# ╟─b129eb58-70d2-11ec-2724-db8d230d0798
# ╟─b129ec2a-70d2-11ec-108b-3d2442e5248b
# ╟─b129ec3e-70d2-11ec-3547-d3f72fdbee65
# ╟─b129ec5c-70d2-11ec-040d-6b794608beb6
# ╟─b129ec70-70d2-11ec-10e3-95e28269fe55
# ╟─b129ec8e-70d2-11ec-358b-9fc0700ab780
# ╟─b129ece8-70d2-11ec-14ce-c9939543b3c0
# ╟─b129ed10-70d2-11ec-3386-b3ab61fb5ac1
# ╟─b129ed2e-70d2-11ec-1f68-f1cf6c3d18ab
# ╟─b129ed42-70d2-11ec-13f2-fb924af9bab3
# ╟─b129ed56-70d2-11ec-0534-d744a4bc0923
# ╟─b129ed68-70d2-11ec-1d8e-afe381093218
# ╟─b129ed7e-70d2-11ec-1768-17a8de27ad0b
# ╟─b129ee0a-70d2-11ec-1ae0-4d4e2ca18bb1
# ╟─b129ee1e-70d2-11ec-1b02-9d8794f189fe
# ╟─b129ee3e-70d2-11ec-260e-651f2c97872d
# ╟─b129ee50-70d2-11ec-0133-5715e5ddf738
# ╟─b129ee64-70d2-11ec-257c-ef8909e91046
# ╟─b129ee82-70d2-11ec-368e-4b081d73be1d
# ╟─b129eedc-70d2-11ec-2573-235650817e27
# ╟─b129ef02-70d2-11ec-105f-614d9d57e06f
# ╟─b129ef0e-70d2-11ec-1445-a79dad7c804c
# ╟─b129ef2c-70d2-11ec-0a0a-7324de0f6907
# ╟─b129ef34-70d2-11ec-2b73-dda3ddb194c3
# ╟─b129ef4a-70d2-11ec-266d-5d0c925c16ff
# ╟─b129ef68-70d2-11ec-318f-db5dad3554a0
# ╟─b129ef72-70d2-11ec-3628-95c98eda94ee
# ╟─b129ef90-70d2-11ec-0b9a-5f65dbbe4041
# ╟─b129efa6-70d2-11ec-2cfb-21af1e017bc5
# ╟─b129efb8-70d2-11ec-38ce-b194fb4091d2
# ╟─b129efcc-70d2-11ec-325e-0b95bdf96f0d
# ╟─b129efea-70d2-11ec-348d-1d8d408e3a3f
# ╟─b129f00a-70d2-11ec-28d0-1f4e5be624cc
# ╠═b129f7f6-70d2-11ec-3a48-4fe92c8ea0d9
# ╟─b129f828-70d2-11ec-3ded-7798e5c3f29f
# ╟─b129f83c-70d2-11ec-3d02-69d88418fa93
# ╟─b129f850-70d2-11ec-0d27-c5d8b69c5b79
# ╟─b129f864-70d2-11ec-29fd-513ade42f769
# ╟─b129f86e-70d2-11ec-369d-bb692c24182e
# ╟─b129f882-70d2-11ec-2ded-056e783e82ed
# ╟─b129f8a8-70d2-11ec-3cc6-49b5cb4196f7
# ╟─b129f8b4-70d2-11ec-3e11-d3540dbb8a17
# ╟─b129f8be-70d2-11ec-0723-a923c8177eb4
# ╟─b129f8c8-70d2-11ec-07c7-05c46950c6c3
# ╟─b129f8da-70d2-11ec-077d-b3058aae42d7
# ╟─b129f8e6-70d2-11ec-2d1c-a96c1f6a2e7c
# ╟─b129f90e-70d2-11ec-3fb9-b5fcdaa728e9
# ╟─b12d2bec-70d2-11ec-2ed3-3f735b0612b4
# ╟─b12d2c6e-70d2-11ec-3e9d-dfbd0df064d3
# ╟─b12d3312-70d2-11ec-0d27-ed923ed58aa6
# ╟─b12d3344-70d2-11ec-0c7c-2fca80adacac
# ╟─b12d4046-70d2-11ec-0ea8-2d575cbd7db6
# ╟─b12d406e-70d2-11ec-3240-a97212647e5c
# ╟─b12d46cc-70d2-11ec-1293-29b71fcfea71
# ╟─b12d46f4-70d2-11ec-374b-ab94cf0e205c
# ╟─b12d4730-70d2-11ec-3345-f7cbfd493a11
# ╟─b12d516c-70d2-11ec-15ff-db4b4129297c
# ╟─b12d519e-70d2-11ec-2cc1-3142ec85883d
# ╟─b12d523e-70d2-11ec-1dfe-29c3c02cd519
# ╟─b12d595c-70d2-11ec-0313-3101dadd8174
# ╟─b12d5982-70d2-11ec-07d2-d3ef18120989
# ╟─b12d59aa-70d2-11ec-1094-b58cedf30eb3
# ╟─b12d5f9a-70d2-11ec-29d4-c34844323939
# ╟─b12d5fd6-70d2-11ec-1c75-7d9d45e972c3
# ╠═b12d70d4-70d2-11ec-184a-ab8a160f9133
# ╟─b12d7138-70d2-11ec-3618-d17d1ffd4e5a
# ╟─b12d719c-70d2-11ec-2aa9-9fe17889ec4e
# ╟─b12d76ce-70d2-11ec-3b70-b7fc0d430d65
# ╟─b12d76f6-70d2-11ec-2068-2b6f5ad93ce4
# ╟─b12d7728-70d2-11ec-1f1b-9302e10a9125
# ╟─b12d7750-70d2-11ec-2335-25fc99d5c850
# ╟─b12d7778-70d2-11ec-0793-474d46870811
# ╠═b12d80b0-70d2-11ec-18fd-171333fa116b
# ╟─b12d80ec-70d2-11ec-23ce-95a7cbfc116e
# ╟─b12d84ca-70d2-11ec-1f30-f1c82f883689
# ╟─b12d84f2-70d2-11ec-27e9-7dbdb0066a66
# ╟─b12d9578-70d2-11ec-0f09-b3b6a7be0877
# ╟─b12d95a0-70d2-11ec-38a5-a11df637567d
# ╟─b12f507a-70d2-11ec-2748-01ff3b0fb2c7
# ╠═b12f58ae-70d2-11ec-00a0-ad0ba4bfcce4
# ╟─b12f5900-70d2-11ec-0b4d-5b35fb2e319a
# ╟─b12f6608-70d2-11ec-2a9f-e911b0b96b83
# ╟─b12f6632-70d2-11ec-0b1e-4bb320f70ac0
# ╟─b12f6682-70d2-11ec-3a02-ff2be2b396ce
# ╟─b12f846e-70d2-11ec-3b3b-037d12d91edc
# ╟─b12f84a0-70d2-11ec-3a38-6553f8d2c3aa
# ╟─b12f84f0-70d2-11ec-07bc-f14139f64e61
# ╟─b12f8a22-70d2-11ec-1e2d-b5d8130488e1
# ╟─b12f8a40-70d2-11ec-3fff-ab155cbe2880
# ╟─b12f8a68-70d2-11ec-343e-239cb9f2b1ec
# ╟─b12f9274-70d2-11ec-112d-8167312657e0
# ╟─b12f9292-70d2-11ec-2a1e-dfc9767b09f3
# ╟─b12f92ce-70d2-11ec-03ef-f7bd9770f5a6
# ╟─b12f9666-70d2-11ec-0343-970f3f360202
# ╟─b12f968e-70d2-11ec-05a3-f915225f0f1c
# ╟─b12fa5a2-70d2-11ec-33f0-9b78ecfc54e8
# ╟─b12fc5ee-70d2-11ec-32ec-cf6875c28df6
# ╟─b12fc618-70d2-11ec-081f-8b1c218b7132
# ╟─b12fc618-70d2-11ec-343f-3f60ffe0f889
# ╟─b12fc620-70d2-11ec-2436-0541d974018c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
