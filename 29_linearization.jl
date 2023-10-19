### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 0cf5e116-539a-11ec-3f1b-cb52b44fa006
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using TaylorSeries
end

# ╔═╡ 0cf5e46a-539a-11ec-1fed-c9a2eaab1bc5
begin
	using CalculusWithJulia.WeaveSupport
	
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 0cfb0300-539a-11ec-1a9a-e56e3bdc4ce9
using PlutoUI

# ╔═╡ 0cfb02ba-539a-11ec-2c6a-5b68503e02bf
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 0cf5c0fc-539a-11ec-2567-e104f51a01ad
md"""# Linearization
"""

# ╔═╡ 0cf5c142-539a-11ec-2fe2-85bf1d32c3e5
md"""This section uses these add-on packages:
"""

# ╔═╡ 0cf5e50a-539a-11ec-161b-15de1e755a46
md"""The derivative of $f(x)$ has the interpretation as the slope of the tangent line. The tangent line is the line that best approximates the function at the point.
"""

# ╔═╡ 0cf5e528-539a-11ec-0da2-67788597d559
md"""Using the point-slope form of a line, we see that the tangent line to the graph of $f(x)$ at $(c,f(c))$ is given by:
"""

# ╔═╡ 0cf5e56e-539a-11ec-2ef9-b583856be3c2
md"""```math
y = f(c) + f'(c) \cdot (x - c).
```
"""

# ╔═╡ 0cf5e5be-539a-11ec-11f2-bb060d775bb8
md"""This is written as an equation, though we prefer to work with functions within `Julia`. Here we write such a function as an operator - it takes a function `f` and returns a function representing the tangent line.
"""

# ╔═╡ 0cf5e5fa-539a-11ec-29c0-35ce29ab3055
md"""```
tangent(f, c) = x -> f(c) + f'(c) * (x - c)
```"""

# ╔═╡ 0cf5e624-539a-11ec-1bb8-836ccbef781b
md"""(Recall, the `->` indicates that an anonymous function is being generated.)
"""

# ╔═╡ 0cf5e640-539a-11ec-376b-cbe096a8a274
md"""This function along with the `f'` notation for automatic derivatives is defined in the `CalculusWithJulia` package:
"""

# ╔═╡ 0cf5e652-539a-11ec-0c23-5332c39e2034
md"""We make some graphs with tangent lines:
"""

# ╔═╡ 0cf5eadc-539a-11ec-3272-2d41c91200f0
let
	f(x) = x^2
	plot(f, -3, 3)
	plot!(tangent(f, -1))
	plot!(tangent(f, 2))
end

# ╔═╡ 0cf5eafa-539a-11ec-2695-6f318598d7e6
md"""The graph shows that near the point, the line and function are close, but this need not be the case away from the point. We can express this informally as
"""

# ╔═╡ 0cf5eb18-539a-11ec-379a-b39497777a86
md"""```math
f(x) \approx f(c) + f'(c) \cdot (x-c)
```
"""

# ╔═╡ 0cf5eb2c-539a-11ec-2157-7b0f32164308
md"""with the understanding this applies for $x$ "close" to $c$.
"""

# ╔═╡ 0cf5eb4a-539a-11ec-3609-f9125fc25321
md"""This section gives some implications of this fact and quantifies what "close" can mean.
"""

# ╔═╡ 0cf5eb72-539a-11ec-3e5d-ebb9e3a624b2
md"""##### Example
"""

# ╔═╡ 0cf5eb86-539a-11ec-2b23-0f509e52c93f
md"""There are several approximations that are well known in physics, due to their widespread usage. Three are:
"""

# ╔═╡ 0cf5ec56-539a-11ec-057c-abeeb1050300
md"""  * That $\sin(x) \approx x$ around $x=0$:
"""

# ╔═╡ 0cf60896-539a-11ec-13ed-db7765c45c73
let
	plot(sin, -pi/2, pi/2)
	plot!(tangent(sin, 0))
end

# ╔═╡ 0cf60940-539a-11ec-343a-5105a6de7b30
md"""  * That $\log(1 + x) \approx x$ around $x=0$:
"""

# ╔═╡ 0cf60e68-539a-11ec-1551-cf9a5d4d3209
let
	f(x) = log(1 + x)
	plot(f, -1/2, 1/2)
	plot!(tangent(f, 0))
end

# ╔═╡ 0cf60ef6-539a-11ec-2da7-9565506cffad
md"""  * That $1/(1-x) \approx x$ around $x=0$:
"""

# ╔═╡ 0cf613f2-539a-11ec-23db-a50af72edab2
let
	f(x) = 1/(1-x)
	plot(f, -1/2, 1/2)
	plot!(tangent(f, 0))
end

# ╔═╡ 0cf6141c-539a-11ec-3613-ff1890994a02
md"""In each of these  cases, a more complicated non-linear function is well approximated in a region of interest by a simple linear function.
"""

# ╔═╡ 0cf61458-539a-11ec-27e8-63f198a894c2
md"""## Numeric approximations
"""

# ╔═╡ 0cf617b4-539a-11ec-13c7-f3178d7d1b3b
let
	f(x) = sin(x)
	a, b = -1/4, pi/2
	
	p = plot(f, a, b, legend=false);
	plot!(p, x->x, a, b);
	plot!(p, [0,1,1], [0, 0, 1], color=:brown);
	plot!(p, [0,1,1], [0, 0, sin(1)], color=:green);
	annotate!(p, collect(zip([1/2,1+.05, 1/2-1/8], [.05, sin(1)/2, .75], ["Δx", "Δy", "m=dy/dx"])));
	p
end

# ╔═╡ 0cf617f8-539a-11ec-1b5c-2d0ebe4d5c23
md"""The plot shows the tangent line with slope $dy/dx$ and the actual change in $y$, $\Delta y$, for some specified $\Delta x$. The small gap above the sine curve is the error were the value of the sine approximated using the drawn tangent line. We can see that approximating the value of $\Delta y = \sin(c+\Delta x) - \sin(c)$ with the often easier to compute $f'(c)\Delta x$ - for small enough values of $\Delta x$ -  is not going to be too far off provided $\Delta x$ is not too large.
"""

# ╔═╡ 0cf61818-539a-11ec-132f-edb47500de82
md"""This approximation is known as linearization. It can be used both in theoretical computations and in pratical applications. To see how effective it is, we look at some examples.
"""

# ╔═╡ 0cf61840-539a-11ec-3d25-3b970d57609d
md"""##### Example
"""

# ╔═╡ 0cf61872-539a-11ec-34cd-4731e8d5efb9
md"""If $f(x) = \sin(x)$, $c=0$ and $\Delta x= 0.1$ then the values for the actual change in the function values and the value of $\Delta y$ are:
"""

# ╔═╡ 0cf63460-539a-11ec-353a-1d274f836a50
begin
	f(x) = sin(x)
	c, deltax = 0, 0.1
	f(c + deltax) - f(c), f'(c) * deltax
end

# ╔═╡ 0cf6349c-539a-11ec-08f7-2d8a1c24dc62
md"""The values are pretty close. But what is $0.1$ radians? Lets use degrees. Suppose we have $\Delta x = 10^\circ$:
"""

# ╔═╡ 0cf63988-539a-11ec-300d-f5ac7a2bf48a
begin
	deltax⁰ = 10*pi/180
	actual=f(c + deltax⁰) - f(c)
	approx = f'(c) * deltax⁰
	actual, approx
end

# ╔═╡ 0cf639ce-539a-11ec-1d28-8743aebad822
md"""They agree until the third decimal value. The *percentage error* is just $1/2$ a percent:
"""

# ╔═╡ 0cf63d34-539a-11ec-0448-b3168389c20e
(approx - actual) / actual * 100

# ╔═╡ 0cf63d5c-539a-11ec-28c7-13ea7a8663ee
md"""##### Example
"""

# ╔═╡ 0cf63d70-539a-11ec-3bba-ffee28ce4590
md"""We are traveling 60 miles. At 60 miles an hour, we will take 60 minutes (or one hour). How long will it take at 70 miles an hour? (Assume you can't divide, but, instead, can only multiply!)
"""

# ╔═╡ 0cf63d8e-539a-11ec-2e06-711df11c1069
md"""Well the answer is $60/70$ hours or $60/70 \cdot 60$ minutes. But we can't divide, so we turn this into a multiplication problem via some algebra:
"""

# ╔═╡ 0cf63dc0-539a-11ec-09fc-71b0d8c891a9
md"""```math
\frac{60}{70} = \frac{60}{60 + 10} = \frac{1}{1 + 10/60} = \frac{1}{1 + 1/6}.
```
"""

# ╔═╡ 0cf63e1a-539a-11ec-0bc7-fdc0e6c600e4
md"""Okay, so far no calculator was needed. We wrote $70 = 60 + 10$, as we know that $60/60$ is just $1$. This almost gets us there. If we really don't want to divide, we can get an answer by using the tangent line approximation for $1/(1+x)$ around $x=0$. This is $1/(1+x) \approx 1 - x$. (You can check by finding that $f'(0) = -1$.) Thus, our answer is approximately $5/6$ of an hour or 50 minutes.
"""

# ╔═╡ 0cf63e38-539a-11ec-27df-1ff8591e7057
md"""How much in error are we?
"""

# ╔═╡ 0cf675ec-539a-11ec-05ee-0b6a35532867
abs(50 - 60/70*60) / (60/70*60) * 100

# ╔═╡ 0cf6763c-539a-11ec-32dd-512ff8430ef4
md"""That's about $3$ percent. Not bad considering we could have done all the above in our head while driving without taking our eyes off the road to use the calculator on our phone for a division.
"""

# ╔═╡ 0cf6765a-539a-11ec-0f83-b77d2082281d
md"""##### Example
"""

# ╔═╡ 0cf6768c-539a-11ec-0e60-31e17319ace5
md"""A $10$cm by $10$cm by $10$cm cube will contain $1$ liter ($1000$cm$^3$). In manufacturing such a cube, the side lengths are actually $10.1$ cm. What will be the volume in liters? Compute this with a linear approximation to $(10.1)^3$.
"""

# ╔═╡ 0cf676be-539a-11ec-09a9-835c50e58277
md"""Here $f(x) = x^3$ and we are asked to approximate $f(10.1)$. Letting $c=10$, we have:
"""

# ╔═╡ 0cf676da-539a-11ec-17e5-e38a35ec341a
md"""```math
f(c + \Delta) \approx f(c) + f'(c) \cdot \Delta = 1000 + f'(c) \cdot (0.1)
```
"""

# ╔═╡ 0cf676e6-539a-11ec-3015-cf2ffd22e188
md"""Computing the derivative can be done easily, we get for our answer:
"""

# ╔═╡ 0cf67be4-539a-11ec-07bd-89f8c9d54683
begin
	fp(x) = 3*x^2
	c₀, Delta = 10, 0.1
	approx₀ = 1000 + fp(c₀) * Delta
end

# ╔═╡ 0cf67bfa-539a-11ec-14ed-8b0c74c3c77f
md"""This is a relative error as a percent of:
"""

# ╔═╡ 0cf68028-539a-11ec-217c-b1cf6b8544ea
begin
	actual₀ = 10.1^3
	(actual₀ - approx₀)/actual₀ * 100
end

# ╔═╡ 0cf6804e-539a-11ec-1951-25e71f9e4111
md"""The manufacturer may be interested instead in comparing the volume of the actual object to the $1$ liter target. They might use the approximate value for this comparison, which would yield:
"""

# ╔═╡ 0cf683d4-539a-11ec-11d5-690367ce842e
(1000 - approx₀)/approx₀ * 100

# ╔═╡ 0cf683fc-539a-11ec-3149-8daafb5b6b89
md"""This is off by about $3$ percent. Not so bad for some applications, devastating for others.
"""

# ╔═╡ 0cf68422-539a-11ec-31a4-039f9b58ffa5
md"""##### Example from physics
"""

# ╔═╡ 0cf6847e-539a-11ec-1b2e-938f17015555
md"""A *simple* pendulum is comprised of a massless "bob" on a rigid "rod" of length $l$. The rod swings back and forth making an angle $\theta$ with the perpendicular. At rest $\theta=0$, here we have $\theta$ swinging with $\lvert\theta\rvert \leq \theta_0$ for some $\theta_0$.
"""

# ╔═╡ 0cf684b0-539a-11ec-0fac-c97de8f75666
md"""According to [Wikipedia](http://tinyurl.com/yz5sz7e) - and many introductory physics book - while swinging, the angle $\theta$ varies with time following this equation:
"""

# ╔═╡ 0cf684d8-539a-11ec-135a-af20fbefaef5
md"""```math
\theta''(t) + \frac{g}{l} \sin(\theta(t)) = 0.
```
"""

# ╔═╡ 0cf684ec-539a-11ec-075d-cdeed73b37a1
md"""That is, the second derivative of $\theta$ is proportional to the sine of $\theta$ where the proportionality constant involves $g$ from gravity and the length of the "rod."
"""

# ╔═╡ 0cf68514-539a-11ec-00c2-efeb67025fd3
md"""This would be much easier if the second derivative were proportional to the angle $\theta$ and not its sine.
"""

# ╔═╡ 0cf9ae7e-539a-11ec-0214-dbdb6743a6f3
md"""[Huygens](http://en.wikipedia.org/wiki/Christiaan_Huygens) used the approximation of $\sin(x) \approx x$, noted above, to say that when the angle is not too big, we have the pendulum's swing obeying $\theta''(t) = -g/l \cdot t$. Without getting too involved in why, we can verify by taking two derivatives that $\theta_0\sin(\sqrt{g/l}\cdot t)$ will be a solution to this modified equation.
"""

# ╔═╡ 0cf9af82-539a-11ec-3823-a5890d20601f
md"""This says the motion is periodic with constant amplitude (assuming frictionless behaviour), as the sine function is. More surprisingly, the period is found from $T = 2\pi/(\sqrt{g/l}) = 2\pi \sqrt{l/g}$. It depends on $l$ - longer "rods" take more time to swing back and forth - but does not depend on the how wide the pendulum is swinging between (provided $\theta_0$ is not so big the approximation of $\sin(x) \approx x$ fails). This latter fact may be surprising, though not to Galileo who discovered it.
"""

# ╔═╡ 0cf9afc0-539a-11ec-3590-ef7f91615f4c
md"""## The actual error
"""

# ╔═╡ 0cf9b02c-539a-11ec-18f3-935c3059ed0f
md"""How good is the approximation? Graphically we can see it is pretty good for the graphs we choose, but are there graphs out there for which the approximation is not so good?  Of course. However, we can say this (the [Lagrange](http://en.wikipedia.org/wiki/Taylor%27s_theorem) form of a more general Taylor remainder theorem):
"""

# ╔═╡ 0cf9b374-539a-11ec-327a-2784fa760522
md"""> Let $f(x)$ be twice differentiable on $I=(a,b)$, $f$ is continuous on $[a,b]$, and $a < c < b$. Then for any $x$ in $I$, there exists some value $\xi$ between $c$  and $x$ such that $f(x) = f(c) + f'(c)(x-c) + (f''(\xi)/2)\cdot(x-c)^2$.

"""

# ╔═╡ 0cf9b3c6-539a-11ec-0622-e11bd5e17d0b
md"""That is, the error is basically a constant depending on the concavity of $f$ times a quadratic function centered at $c$.
"""

# ╔═╡ 0cf9b3f8-539a-11ec-3e76-67a72309033a
md"""For $\sin(x)$ at $c=0$ we get $\lvert\sin(x) - x\rvert = \lvert-\sin(\xi)\cdot x^2/2\rvert$. Since $\lvert\sin(\xi)\rvert \leq 1$, we must have this bound: $\lvert\sin(x) - x\rvert \leq x^2/2$.
"""

# ╔═╡ 0cf9b43c-539a-11ec-01b0-9b78faac8ba5
md"""Can we verify? Let's do so graphically:
"""

# ╔═╡ 0cf9e3c6-539a-11ec-3bf0-195c57d05855
let
	h(x) = abs(sin(x) - x)
	g(x) = x^2/2
	plot(h, -2, 2, label="h")
	plot!(g, -2, 2, label="f")
end

# ╔═╡ 0cf9e484-539a-11ec-0111-0ffb03d9a3b2
md"""The graph shows a tight bound near $0$ and then a bound over this viewing window.
"""

# ╔═╡ 0cf9e4b6-539a-11ec-359f-97c63dd593ed
md"""Similarly, for $f(x) = \log(1 + x)$ we have the following at $c=0$:
"""

# ╔═╡ 0cf9e4fc-539a-11ec-13e0-d30f89a27359
md"""```math
f'(x) = 1/(1+x), \quad f''(x) = -1/(1+x)^2.
```
"""

# ╔═╡ 0cf9e592-539a-11ec-30a4-59d0587b91b4
md"""So, as $f(c)=0$ and $f'(c) = 1$, we have
"""

# ╔═╡ 0cf9e664-539a-11ec-325d-110440d43cd7
md"""```math
\lvert f(x) - x\rvert \leq \lvert f''(\xi)\rvert \cdot \frac{x^2}{2}
```
"""

# ╔═╡ 0cf9e696-539a-11ec-2a37-cd19c7ad0b48
md"""We see that $\lvert f''(x)\rvert$ is decreasing for $x > -1$. So if $-1 < x < c$ we have
"""

# ╔═╡ 0cf9e6aa-539a-11ec-0c8f-3f7f5e669504
md"""```math
\lvert f(x) - x\rvert \leq \lvert f''(x)\rvert \cdot \frac{x^2}{2} = \frac{x^2}{2(1+x)^2}.
```
"""

# ╔═╡ 0cf9e754-539a-11ec-3c04-61068d55657e
md"""And for  $c=0 < x$, we have
"""

# ╔═╡ 0cf9e77c-539a-11ec-0858-835414487f6e
md"""```math
\lvert f(x) - x\rvert \leq \lvert f''(0)\rvert \cdot \frac{x^2}{2} = x^2/2.
```
"""

# ╔═╡ 0cf9e79a-539a-11ec-0e5e-d50c5adcabab
md"""Plotting we verify the bound on $|\log(1+x)-x|$:
"""

# ╔═╡ 0cfa0824-539a-11ec-3c03-dbf268b9de1c
let
	h(x) = abs(log(1+x) - x)
	g(x) = x < 0 ? x^2/(2*(1+x)^2) : x^2/2
	plot(h, -0.5, 2, label="h")
	plot!(g, -0.5, 2, label="g")
end

# ╔═╡ 0cfa086a-539a-11ec-3776-83400c7e8493
md"""Again, we see the very close bound near $0$, which widens at the edges of the viewing window.
"""

# ╔═╡ 0cfa08a6-539a-11ec-0a1a-9333164cc714
md"""### Why is the remainder term as it is?
"""

# ╔═╡ 0cfa08d8-539a-11ec-28ea-cf177e728eb1
md"""To see formally why the remainder is as it is, we recall the mean value theorem in the extended form of Cauchy. Suppose $c=0$, $x > 0$, and let $h(x) = f(x) - (f(0) + f'(0) x)$ and $g(x) = x^2$. Then we have that there exists a $e$ with $0 < e < x$ such that
"""

# ╔═╡ 0cfa091e-539a-11ec-3bfe-b98d8c4487d9
md"""```math
\text{error} = h(x) - h(0) = (g(x) - g(0)) \frac{h'(e)}{g'(e)} = x^2 \cdot \frac{1}{2} \cdot \frac{f'(e) - f'(0)}{e} =
x^2 \cdot \frac{1}{2} \cdot f''(\xi).
```
"""

# ╔═╡ 0cfa093c-539a-11ec-1859-5103b7f77b2b
md"""The value of $\xi$, from the mean value theorem applied to $f'(x)$, satisfies $0 < \xi < e < x$, so is in $[0,x]$.
"""

# ╔═╡ 0cfa0950-539a-11ec-03de-719d0579a9fc
md"""### The big (and small) "oh"
"""

# ╔═╡ 0cfa09fa-539a-11ec-0217-e99d677f993f
md"""`SymPy` can find the tangent line expression as a special case of its `series` function (which implements [Taylor series](../taylor_series_polynomials.html)). The `series` function needs an expression to approximate; a variable specified, as there may be parameters in the expression; a value $c$ for *where* the expansion is taken, with default $0$; and a number of terms, for this example $2$ for a constant and linear term. (There is also an optional `dir` argument for one-sided expansions.)
"""

# ╔═╡ 0cfa0a0e-539a-11ec-1ac5-d78402ed1333
md"""Here we see the answer provided for $e^{\sin(x)}$:
"""

# ╔═╡ 0cfa0da6-539a-11ec-0e3b-874aaaf466ce
begin
	@syms x
	series(exp(sin(x)), x, 0, 2)
end

# ╔═╡ 0cfa0df6-539a-11ec-2fc3-1be39420ee96
md"""The expression $1 + x$  comes from the fact that `exp(sin(0))` is $1$, and the derivative `exp(sin(0)) * cos(0)` is *also* $1$. But what is the $\mathcal{O}(x^2)$?
"""

# ╔═╡ 0cfa0e50-539a-11ec-3d5a-cd9fa139b1da
md"""We know the answer is *precisely* $f''(\xi)/2 \cdot x^2$ for some $\xi$, but were we only concerned about the scale as $x$ goes to zero that when $f''$ is continuous that the error when divided by $x^2$ goes to some finite value ($f''(0)/2$). More generally, if the error divided by $x^2$ is *bounded* as $x$ goes to $0$, then we say the error is "big oh" of $x^2$.
"""

# ╔═╡ 0cfa0eaa-539a-11ec-3ae3-73cecc3822ee
md"""The [big](http://en.wikipedia.org/wiki/Big_O_notation) "oh" notation, $f(x) = \mathcal{O}(g(x))$, says that the ratio $f(x)/g(x)$ is bounded as $x$ goes to $0$ (or some other value $c$, depending on the context).  A little "oh" (e.g., $f(x) = \mathcal{o}(g(x))$) would mean that the limit $f(x)/g(x)$ would be $0$, as $x\rightarrow 0$, a much stronger assertion.
"""

# ╔═╡ 0cfa2688-539a-11ec-259b-e9eda3afa9f9
md"""Big "oh" and little "oh" give us a sense of how good an approximation is without being bogged down in the details of the exact value. As such they are useful guides in focusing on what is primary and what is secondary. Applying this to our case, we have this rough form of the tangent line approximation valid for functions having a continuous second derivative at $c$:
"""

# ╔═╡ 0cfa26ba-539a-11ec-0188-3584ec4497d9
md"""```math
f(x) = f(c) + f'(c)(x-c) + \mathcal{O}((x-c)^2).
```
"""

# ╔═╡ 0cfa270a-539a-11ec-22aa-fb6ad29eafc5
md"""##### Example: the algebra of tangent line approximations
"""

# ╔═╡ 0cfa2746-539a-11ec-213f-635e01a9a379
md"""Suppose $f(x)$ and $g(x)$ are represented by their tangent lines about $c$, respectively:
"""

# ╔═╡ 0cfa2764-539a-11ec-1e3c-5597df82725a
md"""```math
\begin{align*}
f(x) &= f(c) + f'(c)(x-c) + \mathcal{O}((x-c)^2), \\
g(x) &= g(c) + g'(c)(x-c) + \mathcal{O}((x-c)^2).
\end{align*}
```
"""

# ╔═╡ 0cfa2778-539a-11ec-1f11-35364f712344
md"""Consider the sum, after rearranging we have:
"""

# ╔═╡ 0cfa27aa-539a-11ec-32f4-01acaa35ea7d
md"""```math
\begin{align*}
f(x) + g(x) &=  \left(f(c) + f'(c)(x-c) + \mathcal{O}((x-c)^2)\right) + \left(g(c) + g'(c)(x-c) + \mathcal{O}((x-c)^2)\right)\\
&= \left(f(c) + g(c)\right) + \left(f'(c)+g'(c)\right)(x-c) + \mathcal{O}((x-c)^2).
\end{align*}
```
"""

# ╔═╡ 0cfa27e6-539a-11ec-2037-ab34f3bbf0a3
md"""The two big "Oh" terms become just one as the sum of a constant times $(x-c)^2$ plus a constant time $(x-c)^2$ is just some other constant times $(x-c)^2$. What we can read off from this is the term multiplying $(x-c)$ is just the derivative of $f(x) + g(x)$ (from the sum rule), so this too is a tangent line approximation.
"""

# ╔═╡ 0cfa27fa-539a-11ec-048d-514c5f79efc4
md"""Is it a coincidence that a basic algebraic operation with tangent lines approximations produces a tangent line approximation? Let's try multiplication:
"""

# ╔═╡ 0cfa2836-539a-11ec-3d3f-792767db184c
md"""```math
\begin{align*}
f(x) \cdot g(x) &=  [f(c) + f'(c)(x-c) + \mathcal{O}((x-c)^2)] \cdot [g(c) + g'(c)(x-c) + \mathcal{O}((x-c)^2)]\\
&=[(f(c) + f'(c)(x-c)] \cdot  [g(c) + g'(c)(x-c)] + (f(c) + f'(c)(x-c) \cdot \mathcal{O}((x-c)^2)) + g(c) + g'(c)(x-c) \cdot \mathcal{O}((x-c)^2)) + [\mathcal{O}((x-c)^2))]^2\\
&= [(f(c) + f'(c)(x-c)] \cdot  [g(c) + g'(c)(x-c)] + \mathcal{O}((x-c)^2)\\
&= f(c) \cdot g(c) + [f'(c)\cdot g(c) + f(c)\cdot g'(c)] \cdot (x-c) + [f'(c)\cdot g'(c) \cdot (x-c)^2 + \mathcal{O}((x-c)^2)] \\
&= f(c) \cdot g(c) + [f'(c)\cdot g(c) + f(c)\cdot g'(c)] \cdot (x-c) + \mathcal{O}((x-c)^2)
\end{align*}
```
"""

# ╔═╡ 0cfa2860-539a-11ec-0bfb-0fd97788a47a
md"""The big "oh" notation just sweeps up many things including any products of it *and* the term $f'(c)\cdot g'(c) \cdot (x-c)^2$. Again, we see from the product rule that this is just a tangent line approximation for $f(x) \cdot g(x)$.
"""

# ╔═╡ 0cfa2886-539a-11ec-1a13-072e783d6a57
md"""The basic mathematical operations involving tangent lines can be computed just using the tangent lines when the desired accuracy is at the tangent line level. This is even true for composition, though there the outer and inner functions may have different "$c$"s.
"""

# ╔═╡ 0cfa28ae-539a-11ec-108e-a7902831b9f9
md"""Knowing this can simplify the task of finding tangent line approximations of compound expressions.
"""

# ╔═╡ 0cfa28cc-539a-11ec-33f1-c7dc90adf7c8
md"""For example, suppose we know that at $c=0$ we have these formula where $a \approx b$ is a shorthand for the more formal $a=b + \mathcal{O}(x^2)$:
"""

# ╔═╡ 0cfa2908-539a-11ec-0d5a-e164e32a75be
md"""```math
\sin(x) \approx x, \quad e^x \approx 1 + x, \quad \text{and}\quad 1/(1+x) \approx 1 - x.
```
"""

# ╔═╡ 0cfa291c-539a-11ec-1883-5f3f976fdb7b
md"""Then we can immediately see these tangent line approximations about $x=0$:
"""

# ╔═╡ 0cfa294e-539a-11ec-3fef-0b632b85d1d1
md"""```math
e^x \cdot \sin(x) \approx (1+x) \cdot x = x + x^2 \approx x,
```
"""

# ╔═╡ 0cfa2962-539a-11ec-13b8-89fd920095ff
md"""and
"""

# ╔═╡ 0cfa2976-539a-11ec-0dfb-6708e306fc54
md"""```math
\frac{\sin(x)}{e^x} \approx \frac{x}{1 + x} \approx x \cdot(1-x) = x-x^2 \approx x.
```
"""

# ╔═╡ 0cfa29a8-539a-11ec-3024-11fa591b77ce
md"""Since $\sin(0) = 0$, we can use these to find the tangent line approximation of
"""

# ╔═╡ 0cfa29b2-539a-11ec-3ad8-43776c0629cd
md"""```math
e^{\sin(x)} \approx e^x \approx 1 + x.
```
"""

# ╔═╡ 0cfa29da-539a-11ec-05ba-29266093ae42
md"""Note that $\sin(\exp(x))$ is approximately $\sin(1+x)$ but not approximately $1+x$, as the expansion for $\sin$ about $1$ is not simply $x$.
"""

# ╔═╡ 0cfa29fa-539a-11ec-0a62-95bf0b2a0453
md"""### The TaylorSeries package
"""

# ╔═╡ 0cfa2a20-539a-11ec-3bb8-e156cb5823d3
md"""The `TaylorSeries` packages will do these calculations in a  manner similar to how `SymPy` transforms a function and a symbolic variable into a symbolic expression.
"""

# ╔═╡ 0cfa2a34-539a-11ec-0344-4b0fcdddfe73
md"""For example, we have
"""

# ╔═╡ 0cfa2da4-539a-11ec-37ca-d58549be46d6
t = Taylor1(Float64, 1)

# ╔═╡ 0cfa2de0-539a-11ec-114b-7d49c96cebfb
md"""The number type and the order is specified to the constructor. Linearization is order $1$, other orders will be discussed later. This variable can now be composed with mathematical functions and the linearization of the function will be returned:
"""

# ╔═╡ 0cfa324a-539a-11ec-29c0-d3ee0f48e410
sin(t), exp(t), 1/(1+t)

# ╔═╡ 0cfa3844-539a-11ec-06a2-515fb6cdb4d0
sin(t)/exp(t), exp(sin(t))

# ╔═╡ 0cfa3876-539a-11ec-0b08-15a0c7113ed9
md"""##### Example: Automatic differentiation
"""

# ╔═╡ 0cfa38f8-539a-11ec-01a4-9d660d9c933b
md"""Automatic differentiation (forward mode) essentially uses this technique. When a function is evaluated, both $(f(x), f'(x))$ are found. if "$x$" were there result of some other function computation, say $(g(y), g'(y))$, then the computation of $f'$ is possible with this information, it being $f'(g(y)) \cdot g'(y)$. The values $(f(x), f'(x))$ and $(g(x),g'(x))$ can also be added and multiplied, as by the sum and product rules $(f(x),f'(x)) \oplus (g(x),g'(x)) = (f(x)+g(x), f'(x) + g'(x))$ and $(f(x),f'(x)) \otimes (g(x),g'(x)) = (f(x)+g(x), f'(x)\cdot g(x) + f(x)\cdot g'(x))$. These are the rules for derivatives, but also the ones for tangent line approximations.
"""

# ╔═╡ 0cfa3966-539a-11ec-2b93-6597f4e41c87
md"""So with rules to compute the mathematical functions (`Julia` has these in the [ChainRules.jl](https://github.com/JuliaDiff/ChainRules.jl) package) and identifying a number, say $2$, as $(2,0)$ then we can compute derivatives at $2$. Take the function $f(x)=\exp(\sin(x))$. To find $f'(2)$ the steps would involve
"""

# ╔═╡ 0cfa3bd2-539a-11ec-0302-c15e235f6efa
md"""  * begin with $(2,0)$
  * the sine would be computed as $(\sin(2), \cos(2))$ using the rule for derivative of $\sin$
  * the exponential computed on $(\sin(2),\cos(2))$ would be $(\exp(\sin(2)), \exp(\sin(2)) \cdot \cos(2))$. To compute some $g(x)$, such as $\exp(x)$, the ability to evaluate both $g(x)$ and $g'(x)$ is needed, the chain rule used above then uses just details of $(\sin(2), \cos(2))$, $(\exp(\sin(2)), \exp(\sin(2)))$ – which are the pieces available.
"""

# ╔═╡ 0cfa3c0c-539a-11ec-1de0-ab2e6556cf58
md"""In the end, the computation carries both the function evaluation and the derivative evaluation at $2$, both built up step by step. As seen, it should be exact as floating point allows and requires *essentially* twice the work, as two steps are needed for each function evaluation.
"""

# ╔═╡ 0cfa3c3e-539a-11ec-2071-b9d95ffd1f2f
md"""## Questions
"""

# ╔═╡ 0cfa3c7c-539a-11ec-156b-3bd9d705b137
md"""###### Question
"""

# ╔═╡ 0cfa3cae-539a-11ec-238a-d3ce92f333aa
md"""What is the right linear approximation for $\sqrt{1 + x}$ near $0$?
"""

# ╔═╡ 0cfa5c48-539a-11ec-380b-3fbd3ff522be
let
	choices = [
	"``1 + 1/2``",
	"``1 + x^{1/2}``",
	"``1 + (1/2) \\cdot x``",
	"``1 - (1/2) \\cdot x``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0cfa5c84-539a-11ec-3730-41cda38967ab
md"""###### Question
"""

# ╔═╡ 0cfa5cca-539a-11ec-256e-29ec1c84b202
md"""What is the right linear approximation for $(1 + x)^k$ near $0$?
"""

# ╔═╡ 0cfa6348-539a-11ec-25d7-5fe31c689f45
let
	choices = [
	"``1 + k``",
	"``1 + x^k``",
	"``1 + k \\cdot x``",
	"``1 - k \\cdot x``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 0cfa637a-539a-11ec-0955-f5e30c21ade5
md"""###### Question
"""

# ╔═╡ 0cfa63c8-539a-11ec-2c3a-137a6d9f91b5
md"""What is the right linear approximation for $\cos(\sin(x))$ near $0$?
"""

# ╔═╡ 0cfa8560-539a-11ec-275e-3f2fac37d1fa
let
	choices = [
	"``1``",
	"``1 + x``",
	"``x``",
	"``1 - x^2/2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 0cfa859c-539a-11ec-3c6c-636bbf46387a
md"""###### Question
"""

# ╔═╡ 0cfa8608-539a-11ec-1873-f7835757ad39
md"""What is the  right linear approximation for $\tan(x)$ near $0$?
"""

# ╔═╡ 0cfa8c68-539a-11ec-22f6-a179f97bb2f8
let
	choices = [
	"``1``",
	"``x``",
	"``1 + x``",
	"``1 - x``"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 0cfa8c90-539a-11ec-3ba5-0163bdcf6ca0
md"""###### Question
"""

# ╔═╡ 0cfa8cb8-539a-11ec-3757-611036b65f73
md"""What is the right linear approximation of $\sqrt{25 + x}$ near $x=0$?
"""

# ╔═╡ 0cfaac16-539a-11ec-2146-031394d73609
let
	choices = [
	"``5 \\cdot (1 + (1/2) \\cdot (x/25))``",
	"``1 - (1/2) \\cdot x``",
	"``1 + x``",
	"``25``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 0cfaac66-539a-11ec-28f5-9fe7b697b79f
md"""###### Question
"""

# ╔═╡ 0cfaacc0-539a-11ec-1b34-0d9623827b5b
md"""Let $f(x) = \sqrt{x}$. Find the actual error in approximating $f(26)$ by the value of the tangent line at $(25, f(25))$ at $x=26$.
"""

# ╔═╡ 0cfacdea-539a-11ec-1915-91b4012c0bd4
let
	tgent(x) = 5 + x/10
	ans = tgent(1) - sqrt(26)
	numericq(ans)
end

# ╔═╡ 0cface30-539a-11ec-3a68-75a65598ee79
md"""###### Question
"""

# ╔═╡ 0cface76-539a-11ec-08e9-abe494e1035f
md"""An estimate of some quantity was $12.34$ the actual value was $12$. What was the *percentage error*?
"""

# ╔═╡ 0cfaeb18-539a-11ec-06a6-091829e45e73
let
	est = 12.34
	act = 12.0
	ans = (est -act)/act * 100
	numericq(ans)
end

# ╔═╡ 0cfaeb4a-539a-11ec-3ae9-b5f35e92c914
md"""###### Question
"""

# ╔═╡ 0cfaeb8e-539a-11ec-3601-a932fcd3219e
md"""Find the percentage error in estimating $\sin(5^\circ)$ by $5 \pi/180$.
"""

# ╔═╡ 0cfaef6e-539a-11ec-0c6b-4b093fe84b11
let
	tl(x) = x
	x0 = 5 * pi/180
	est = x0
	act = sin(x0)
	ans = (est -act)/act * 100
	numericq(ans)
end

# ╔═╡ 0cfaefa0-539a-11ec-08d8-25779cd5129b
md"""###### Question
"""

# ╔═╡ 0cfaeff0-539a-11ec-047e-a9874406efd8
md"""The side length of a square is measured roughly to be $2.0$ cm. The actual length $2.2$ cm. What is the difference in area (in absolute values) as *estimated* by a tangent line approximation.
"""

# ╔═╡ 0cfaf446-539a-11ec-356c-8798f0be35e9
let
	tl(x) = 4 + 4x
	ans = tl(.2) - 4
	numericq(abs(ans))
end

# ╔═╡ 0cfaf478-539a-11ec-1b2b-b10751d15ce1
md"""###### Question
"""

# ╔═╡ 0cfaf4be-539a-11ec-0665-91d51fab6bad
md"""The [Birthday problem](https://en.wikipedia.org/wiki/Birthday_problem) computes the probability that in a group of $n$ people, under some assumptions, that no two share a birthday. Without trying to spoil the problem, we focus on the calculus specific part of the problem below:
"""

# ╔═╡ 0cfaf50e-539a-11ec-1ab0-b934d3ef98cc
md"""```math
\begin{align*}
p
&= \frac{365 \cdot 364 \cdot \cdots (365-n+1)}{365^n} \\
&=  \frac{365(1 - 0/365) \cdot 365(1 - 1/365) \cdot 365(1-2/365) \cdot \cdots \cdot 365(1-(n-1)/365)}{365^n}\\
&= (1 - \frac{0}{365})\cdot(1 -\frac{1}{365})\cdot \cdots \cdot (1-\frac{n-1}{365}).
\end{align*}
```
"""

# ╔═╡ 0cfaf52c-539a-11ec-0041-5d004b376afa
md"""Taking logarithms, we have $\log(p)$ is
"""

# ╔═╡ 0cfaf554-539a-11ec-0516-479e31c9a91e
md"""```math
\log(1 - \frac{0}{365}) + \log(1 -\frac{1}{365})+ \cdots + \log(1-\frac{n-1}{365}).
```
"""

# ╔═╡ 0cfaf57c-539a-11ec-2c58-430970dd89ae
md"""Now, use the tangent line approximation for $\log(1 - x)$ and the sum formula for $0 + 1 + 2 + \dots + (n-1)$ to simplify the value of $\log(p)$:
"""

# ╔═╡ 0cfafbc6-539a-11ec-2256-2997a698391e
let
	choices = ["``-n(n-1)/2/365``",
	           "``-n(n-1)/2\\cdot 365``",
	           "``-n^2/(2\\cdot 365)``",
	           "``-n^2 / 2 \\cdot 365``"]
	radioq(choices, 1, keep_order=true)
end

# ╔═╡ 0cfafc02-539a-11ec-3f88-0d7ea91b91d4
md"""If $n = 10$, what is the approximation for $p$ (not $\log(p)$)?
"""

# ╔═╡ 0cfaff7c-539a-11ec-148e-1b170833fa08
let
	n=10
	val = exp(-n*(n-1)/2/365)
	numericq(val)
end

# ╔═╡ 0cfaffb0-539a-11ec-3abc-2526935f2b1f
md"""If $n=100$, what is the approximation for $p$ (not $\log(p)$?
"""

# ╔═╡ 0cfb02a6-539a-11ec-3333-5be3637d1ae5
let
	n=100
	val = exp(-n*(n-1)/2/365)
	numericq(val, 1e-2)
end

# ╔═╡ 0cfb02f6-539a-11ec-1ebd-9774b97dace9
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/curve_sketching.html">◅ previous</a>  <a href="../derivatives/newtons_method.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/linearization.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 0cfb0312-539a-11ec-28f1-67d700ee9801
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
TaylorSeries = "6aa5eb33-94cf-58f4-a9d0-e4b2c4fc25ea"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
SymPy = "~1.1.2"
TaylorSeries = "~0.11.2"
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

[[TaylorSeries]]
deps = ["LinearAlgebra", "Markdown", "Requires", "SparseArrays"]
git-tree-sha1 = "59ee6d7175a204013d91ad84e55eed1e772e01bd"
uuid = "6aa5eb33-94cf-58f4-a9d0-e4b2c4fc25ea"
version = "0.11.2"

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
# ╟─0cfb02ba-539a-11ec-2c6a-5b68503e02bf
# ╟─0cf5c0fc-539a-11ec-2567-e104f51a01ad
# ╟─0cf5c142-539a-11ec-2fe2-85bf1d32c3e5
# ╠═0cf5e116-539a-11ec-3f1b-cb52b44fa006
# ╟─0cf5e46a-539a-11ec-1fed-c9a2eaab1bc5
# ╟─0cf5e50a-539a-11ec-161b-15de1e755a46
# ╟─0cf5e528-539a-11ec-0da2-67788597d559
# ╟─0cf5e56e-539a-11ec-2ef9-b583856be3c2
# ╟─0cf5e5be-539a-11ec-11f2-bb060d775bb8
# ╟─0cf5e5fa-539a-11ec-29c0-35ce29ab3055
# ╟─0cf5e624-539a-11ec-1bb8-836ccbef781b
# ╟─0cf5e640-539a-11ec-376b-cbe096a8a274
# ╟─0cf5e652-539a-11ec-0c23-5332c39e2034
# ╠═0cf5eadc-539a-11ec-3272-2d41c91200f0
# ╟─0cf5eafa-539a-11ec-2695-6f318598d7e6
# ╟─0cf5eb18-539a-11ec-379a-b39497777a86
# ╟─0cf5eb2c-539a-11ec-2157-7b0f32164308
# ╟─0cf5eb4a-539a-11ec-3609-f9125fc25321
# ╟─0cf5eb72-539a-11ec-3e5d-ebb9e3a624b2
# ╟─0cf5eb86-539a-11ec-2b23-0f509e52c93f
# ╟─0cf5ec56-539a-11ec-057c-abeeb1050300
# ╠═0cf60896-539a-11ec-13ed-db7765c45c73
# ╟─0cf60940-539a-11ec-343a-5105a6de7b30
# ╠═0cf60e68-539a-11ec-1551-cf9a5d4d3209
# ╟─0cf60ef6-539a-11ec-2da7-9565506cffad
# ╠═0cf613f2-539a-11ec-23db-a50af72edab2
# ╟─0cf6141c-539a-11ec-3613-ff1890994a02
# ╟─0cf61458-539a-11ec-27e8-63f198a894c2
# ╟─0cf617b4-539a-11ec-13c7-f3178d7d1b3b
# ╟─0cf617f8-539a-11ec-1b5c-2d0ebe4d5c23
# ╟─0cf61818-539a-11ec-132f-edb47500de82
# ╟─0cf61840-539a-11ec-3d25-3b970d57609d
# ╟─0cf61872-539a-11ec-34cd-4731e8d5efb9
# ╠═0cf63460-539a-11ec-353a-1d274f836a50
# ╟─0cf6349c-539a-11ec-08f7-2d8a1c24dc62
# ╠═0cf63988-539a-11ec-300d-f5ac7a2bf48a
# ╟─0cf639ce-539a-11ec-1d28-8743aebad822
# ╠═0cf63d34-539a-11ec-0448-b3168389c20e
# ╟─0cf63d5c-539a-11ec-28c7-13ea7a8663ee
# ╟─0cf63d70-539a-11ec-3bba-ffee28ce4590
# ╟─0cf63d8e-539a-11ec-2e06-711df11c1069
# ╟─0cf63dc0-539a-11ec-09fc-71b0d8c891a9
# ╟─0cf63e1a-539a-11ec-0bc7-fdc0e6c600e4
# ╟─0cf63e38-539a-11ec-27df-1ff8591e7057
# ╠═0cf675ec-539a-11ec-05ee-0b6a35532867
# ╟─0cf6763c-539a-11ec-32dd-512ff8430ef4
# ╟─0cf6765a-539a-11ec-0f83-b77d2082281d
# ╟─0cf6768c-539a-11ec-0e60-31e17319ace5
# ╟─0cf676be-539a-11ec-09a9-835c50e58277
# ╟─0cf676da-539a-11ec-17e5-e38a35ec341a
# ╟─0cf676e6-539a-11ec-3015-cf2ffd22e188
# ╠═0cf67be4-539a-11ec-07bd-89f8c9d54683
# ╟─0cf67bfa-539a-11ec-14ed-8b0c74c3c77f
# ╠═0cf68028-539a-11ec-217c-b1cf6b8544ea
# ╟─0cf6804e-539a-11ec-1951-25e71f9e4111
# ╠═0cf683d4-539a-11ec-11d5-690367ce842e
# ╟─0cf683fc-539a-11ec-3149-8daafb5b6b89
# ╟─0cf68422-539a-11ec-31a4-039f9b58ffa5
# ╟─0cf6847e-539a-11ec-1b2e-938f17015555
# ╟─0cf684b0-539a-11ec-0fac-c97de8f75666
# ╟─0cf684d8-539a-11ec-135a-af20fbefaef5
# ╟─0cf684ec-539a-11ec-075d-cdeed73b37a1
# ╟─0cf68514-539a-11ec-00c2-efeb67025fd3
# ╟─0cf9ae7e-539a-11ec-0214-dbdb6743a6f3
# ╟─0cf9af82-539a-11ec-3823-a5890d20601f
# ╟─0cf9afc0-539a-11ec-3590-ef7f91615f4c
# ╟─0cf9b02c-539a-11ec-18f3-935c3059ed0f
# ╟─0cf9b374-539a-11ec-327a-2784fa760522
# ╟─0cf9b3c6-539a-11ec-0622-e11bd5e17d0b
# ╟─0cf9b3f8-539a-11ec-3e76-67a72309033a
# ╟─0cf9b43c-539a-11ec-01b0-9b78faac8ba5
# ╠═0cf9e3c6-539a-11ec-3bf0-195c57d05855
# ╟─0cf9e484-539a-11ec-0111-0ffb03d9a3b2
# ╟─0cf9e4b6-539a-11ec-359f-97c63dd593ed
# ╟─0cf9e4fc-539a-11ec-13e0-d30f89a27359
# ╟─0cf9e592-539a-11ec-30a4-59d0587b91b4
# ╟─0cf9e664-539a-11ec-325d-110440d43cd7
# ╟─0cf9e696-539a-11ec-2a37-cd19c7ad0b48
# ╟─0cf9e6aa-539a-11ec-0c8f-3f7f5e669504
# ╟─0cf9e754-539a-11ec-3c04-61068d55657e
# ╟─0cf9e77c-539a-11ec-0858-835414487f6e
# ╟─0cf9e79a-539a-11ec-0e5e-d50c5adcabab
# ╠═0cfa0824-539a-11ec-3c03-dbf268b9de1c
# ╟─0cfa086a-539a-11ec-3776-83400c7e8493
# ╟─0cfa08a6-539a-11ec-0a1a-9333164cc714
# ╟─0cfa08d8-539a-11ec-28ea-cf177e728eb1
# ╟─0cfa091e-539a-11ec-3bfe-b98d8c4487d9
# ╟─0cfa093c-539a-11ec-1859-5103b7f77b2b
# ╟─0cfa0950-539a-11ec-03de-719d0579a9fc
# ╟─0cfa09fa-539a-11ec-0217-e99d677f993f
# ╟─0cfa0a0e-539a-11ec-1ac5-d78402ed1333
# ╠═0cfa0da6-539a-11ec-0e3b-874aaaf466ce
# ╟─0cfa0df6-539a-11ec-2fc3-1be39420ee96
# ╟─0cfa0e50-539a-11ec-3d5a-cd9fa139b1da
# ╟─0cfa0eaa-539a-11ec-3ae3-73cecc3822ee
# ╟─0cfa2688-539a-11ec-259b-e9eda3afa9f9
# ╟─0cfa26ba-539a-11ec-0188-3584ec4497d9
# ╟─0cfa270a-539a-11ec-22aa-fb6ad29eafc5
# ╟─0cfa2746-539a-11ec-213f-635e01a9a379
# ╟─0cfa2764-539a-11ec-1e3c-5597df82725a
# ╟─0cfa2778-539a-11ec-1f11-35364f712344
# ╟─0cfa27aa-539a-11ec-32f4-01acaa35ea7d
# ╟─0cfa27e6-539a-11ec-2037-ab34f3bbf0a3
# ╟─0cfa27fa-539a-11ec-048d-514c5f79efc4
# ╟─0cfa2836-539a-11ec-3d3f-792767db184c
# ╟─0cfa2860-539a-11ec-0bfb-0fd97788a47a
# ╟─0cfa2886-539a-11ec-1a13-072e783d6a57
# ╟─0cfa28ae-539a-11ec-108e-a7902831b9f9
# ╟─0cfa28cc-539a-11ec-33f1-c7dc90adf7c8
# ╟─0cfa2908-539a-11ec-0d5a-e164e32a75be
# ╟─0cfa291c-539a-11ec-1883-5f3f976fdb7b
# ╟─0cfa294e-539a-11ec-3fef-0b632b85d1d1
# ╟─0cfa2962-539a-11ec-13b8-89fd920095ff
# ╟─0cfa2976-539a-11ec-0dfb-6708e306fc54
# ╟─0cfa29a8-539a-11ec-3024-11fa591b77ce
# ╟─0cfa29b2-539a-11ec-3ad8-43776c0629cd
# ╟─0cfa29da-539a-11ec-05ba-29266093ae42
# ╟─0cfa29fa-539a-11ec-0a62-95bf0b2a0453
# ╟─0cfa2a20-539a-11ec-3bb8-e156cb5823d3
# ╟─0cfa2a34-539a-11ec-0344-4b0fcdddfe73
# ╠═0cfa2da4-539a-11ec-37ca-d58549be46d6
# ╟─0cfa2de0-539a-11ec-114b-7d49c96cebfb
# ╠═0cfa324a-539a-11ec-29c0-d3ee0f48e410
# ╠═0cfa3844-539a-11ec-06a2-515fb6cdb4d0
# ╟─0cfa3876-539a-11ec-0b08-15a0c7113ed9
# ╟─0cfa38f8-539a-11ec-01a4-9d660d9c933b
# ╟─0cfa3966-539a-11ec-2b93-6597f4e41c87
# ╟─0cfa3bd2-539a-11ec-0302-c15e235f6efa
# ╟─0cfa3c0c-539a-11ec-1de0-ab2e6556cf58
# ╟─0cfa3c3e-539a-11ec-2071-b9d95ffd1f2f
# ╟─0cfa3c7c-539a-11ec-156b-3bd9d705b137
# ╟─0cfa3cae-539a-11ec-238a-d3ce92f333aa
# ╟─0cfa5c48-539a-11ec-380b-3fbd3ff522be
# ╟─0cfa5c84-539a-11ec-3730-41cda38967ab
# ╟─0cfa5cca-539a-11ec-256e-29ec1c84b202
# ╟─0cfa6348-539a-11ec-25d7-5fe31c689f45
# ╟─0cfa637a-539a-11ec-0955-f5e30c21ade5
# ╟─0cfa63c8-539a-11ec-2c3a-137a6d9f91b5
# ╟─0cfa8560-539a-11ec-275e-3f2fac37d1fa
# ╟─0cfa859c-539a-11ec-3c6c-636bbf46387a
# ╟─0cfa8608-539a-11ec-1873-f7835757ad39
# ╟─0cfa8c68-539a-11ec-22f6-a179f97bb2f8
# ╟─0cfa8c90-539a-11ec-3ba5-0163bdcf6ca0
# ╟─0cfa8cb8-539a-11ec-3757-611036b65f73
# ╟─0cfaac16-539a-11ec-2146-031394d73609
# ╟─0cfaac66-539a-11ec-28f5-9fe7b697b79f
# ╟─0cfaacc0-539a-11ec-1b34-0d9623827b5b
# ╟─0cfacdea-539a-11ec-1915-91b4012c0bd4
# ╟─0cface30-539a-11ec-3a68-75a65598ee79
# ╟─0cface76-539a-11ec-08e9-abe494e1035f
# ╟─0cfaeb18-539a-11ec-06a6-091829e45e73
# ╟─0cfaeb4a-539a-11ec-3ae9-b5f35e92c914
# ╟─0cfaeb8e-539a-11ec-3601-a932fcd3219e
# ╟─0cfaef6e-539a-11ec-0c6b-4b093fe84b11
# ╟─0cfaefa0-539a-11ec-08d8-25779cd5129b
# ╟─0cfaeff0-539a-11ec-047e-a9874406efd8
# ╟─0cfaf446-539a-11ec-356c-8798f0be35e9
# ╟─0cfaf478-539a-11ec-1b2b-b10751d15ce1
# ╟─0cfaf4be-539a-11ec-0665-91d51fab6bad
# ╟─0cfaf50e-539a-11ec-1ab0-b934d3ef98cc
# ╟─0cfaf52c-539a-11ec-0041-5d004b376afa
# ╟─0cfaf554-539a-11ec-0516-479e31c9a91e
# ╟─0cfaf57c-539a-11ec-2c58-430970dd89ae
# ╟─0cfafbc6-539a-11ec-2256-2997a698391e
# ╟─0cfafc02-539a-11ec-3f88-0d7ea91b91d4
# ╟─0cfaff7c-539a-11ec-148e-1b170833fa08
# ╟─0cfaffb0-539a-11ec-3abc-2526935f2b1f
# ╟─0cfb02a6-539a-11ec-3333-5be3637d1ae5
# ╟─0cfb02f6-539a-11ec-1ebd-9774b97dace9
# ╟─0cfb0300-539a-11ec-1a9a-e56e3bdc4ce9
# ╟─0cfb0312-539a-11ec-28f1-67d700ee9801
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
