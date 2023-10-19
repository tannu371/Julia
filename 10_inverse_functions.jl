### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ d48057a2-53bf-11ec-179f-df48b7c760e2
begin
	using CalculusWithJulia
	using Plots
end

# ╔═╡ d4805dc4-53bf-11ec-1019-efb05fba4127
begin
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :inversefunctions
	nothing
end

# ╔═╡ d483e9c6-53bf-11ec-2e7d-7560e26895ea
using PlutoUI

# ╔═╡ d483e99e-53bf-11ec-0517-5beaa6c533ba
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ d47fb8c4-53bf-11ec-2f92-db98b350951e
md"""# The Inverse of a Function
"""

# ╔═╡ d47fb9aa-53bf-11ec-0336-9f6196c8ee69
md"""In this section we will use these add-on packages:
"""

# ╔═╡ d4805e50-53bf-11ec-10bd-bb768da916fd
md"""---
"""

# ╔═╡ d4805ed2-53bf-11ec-3444-b160213c2610
md"""A (univariate) mathematical function relates or associates values of $x$ to values $y$ using the notation $y=f(x)$. A key point is a given $x$ is associated with just one $y$ value, though a given $y$ value may be associated with several different $x$ values. (Graphically, this is the vertical line test.)
"""

# ╔═╡ d4805fb8-53bf-11ec-235e-cdb5107d5d12
md"""We may conceptualize such a relation in many ways: through an algebraic rule; through the graph of $f$; through a description of what $f$ does; or through a table of paired values, say.  For the moment, let's consider a function as rule that takes in a value of $x$ and outputs a value $y$. If a rule is given defining the function, the computation of $y$ is straightforward. A different question is not so easy: for a given value $y$ what value - or *values* - of $x$ (if any) produce an output of $y$? That is, what $x$ value(s) satisfy $f(x)=y$?
"""

# ╔═╡ d4805ffe-53bf-11ec-3e16-bb96a54d088c
md"""*If* for each $y$ in some set of values there is just one $x$ value, then this operation associates to each value $y$ a single value $x$, so it too is a function. When that is the case we call this an *inverse* function.
"""

# ╔═╡ d480601c-53bf-11ec-1f11-db93f38a167e
md"""Why is this useful? When available, it can help us solve equations. If we can write our equation as $f(x) = y$, then we can "solve" for $x$ through $x = g(y)$, where $g$ is this inverse function.
"""

# ╔═╡ d4806026-53bf-11ec-2dc1-3db3f6cd4f2a
md"""Let's explore when we can "solve" for an inverse function.
"""

# ╔═╡ d480603c-53bf-11ec-2c96-4743a44cb65e
md"""Consider the graph of the function $f(x) = 2^x$:
"""

# ╔═╡ d480a16c-53bf-11ec-2ceb-0f2dfac5fcca
let
	f(x) = 2^x
	plot(f, 0, 4, legend=false)
	plot!([2,2,0], [0,f(2),f(2)])
end

# ╔═╡ d480a266-53bf-11ec-058d-6fbd63176fb7
md"""The graph of a function is a representation of points $(x,f(x))$, so to *find* $f(c)$ from the graph, we begin on the $x$ axis at $c$, move vertically to the graph (the point $(c, f(c))$), and then move horizontally to the $y$ axis, intersecting it at $f(c)$. The figure shows this for $c=2$, from which we can read that $f(c)$ is about $4$. This is how an $x$ is associated to a single $y$.
"""

# ╔═╡ d480a2fc-53bf-11ec-22b3-d93642abd0cd
md"""If we were to *reverse* the direction, starting at $f(c)$ on the $y$ axis and then moving horizontally to the graph, and then vertically to the $x$-axis we end up at a value $c$ with the correct $f(c)$. This operation will form a function **if** the initial movement horizontally is guaranteed to find *no more than one* value on the graph. That is, to have an inverse function, there can not be two $x$ values corresponding to a given $y$ value. This observation is often visualized through the "horizontal line test" - the graph of a function with an inverse function can only intersect a horizontal line at most in one place.
"""

# ╔═╡ d480a36a-53bf-11ec-2abf-f7296fe171fd
md"""More formally, a function is called *one-to-one* *if* for any two $a \neq b$, it must be that $f(a) \neq f(b)$. Many functions are one-to-one, many are not. Familiar one-to-one functions are linear functions ($f(x)=a \cdot x + b$ with $a\neq 0$), odd powers of $x$ ($f(x)=x^{2k+1}$), and functions of the form $f(x)=x^{1/n}$ for $x \geq 0$. In contrast, all *even* functions are *not* one-to-one, as $f(x) = f(-x)$ for any nonzero $x$ in the domain of $f$.
"""

# ╔═╡ d480a3b0-53bf-11ec-09b5-11ac1f50a6b3
md"""A class of functions that are guaranteed to be one-to-one are the *strictly* increasing functions (which satisfy $a < b$ implies $f(a) < f(b)$). Similarly, strictly decreasing functions are one-to-one. The term strictly *monotonic* is used to describe either strictly increasing or strictly decreasing.  By the above observations, strictly monotonic function will have inverse functions.
"""

# ╔═╡ d480a3d8-53bf-11ec-05a0-1d0e809c395c
md"""The function $2^x$, graphed above, is strictly increasing, so it will have an inverse function. That is we can solve for $x$ in an equation like $2^x = 9$ using the inverse function of $f(x) = 2^x$, provided we can identify the inverse function.
"""

# ╔═╡ d480a482-53bf-11ec-2ed3-3f598af53bfe
md"""## How to solve for an inverse function?
"""

# ╔═╡ d480a4a0-53bf-11ec-184d-6f97bce67751
md"""If we know an inverse function exists, how can we find it?
"""

# ╔═╡ d480a4be-53bf-11ec-0704-ed6daf0b39fb
md"""If our function is given by a graph, the process above describes how to find the inverse function.
"""

# ╔═╡ d480a536-53bf-11ec-3d55-41bee1b53df6
md"""However, typically we have a rule describing our function. What is the process then?  A simple example helps illustrate. The *linear* function $f(x) = 9/5\cdot x + 32$ is strictly increasing, hence has an inverse function. What should it be? Let's describe the action of $f$: it multiplies $x$ by $9/5$ and then adds $32$. To "invert" this we *first* invert the adding of $32$ by subtracting $32$, then we would "invert" multiplying by $9/5$ by *dividing* by $9/5$. Hence $g(x)=(x-32)/(9/5)$. We would generally simplify this, but let's not for now. If we view a function as a composition of many actions, then we find the inverse by composing the inverse of these actions in **reverse** order. The reverse order might seem confusing, but this is how we get dressed and undressed: to dress we put on socks and then shoes. To undress we take off the shoes and then take off the socks.
"""

# ╔═╡ d480a568-53bf-11ec-3b8a-c1bed851757b
md"""When we solve algebraically for $x$ in $y=9/5 \cdot x + 32$ we do the same thing as we do verbally: we subtract $32$ from each side, and then divide by $9/5$ to isolate $x$:
"""

# ╔═╡ d480a6ee-53bf-11ec-0b2c-83d774a16b2e
md"""```math
\begin{align}
y &= 9/5 \cdot x + 32\\
y - 32 &= 9/5 \cdot x\\
(y-32) / (9/5) &= x.
\end{align}
```
"""

# ╔═╡ d480e2a8-53bf-11ec-1afa-2ff0034c3693
md"""From this, we have the function $g(y) = (y-32) / (9/5)$ is the inverse function of $f(x) =  9/5\cdot x + 32$.
"""

# ╔═╡ d480e334-53bf-11ec-14e7-0ddfcee17ceb
md"""*Usually* univariate functions are written with $x$ as the dummy variable, so it is typical to write $g(x) = (x-32) / (9/5)$ as the inverse function.
"""

# ╔═╡ d480e3a2-53bf-11ec-349b-abaf72d71224
md"""*Usually* we use the name $f^{-1}$ for the inverse function of $f$, so this would be most often [seen](http://tinyurl.com/qypbueb) as $f^{-1}(x) = (x-32)/(9/5)$ or after simplification $f^{-1}(x) = (5/9) \cdot (x-32)$.
"""

# ╔═╡ d4811606-53bf-11ec-3994-6dd39d80dfeb
note(L"""The use of a negative exponent on the function name is *easily* confused for the notation for a reciprocal when it is used on a mathematical *expression*. An example might be the notation $(1/x)^{-1}$. As this is an expression this would simplify to $x$ and not the inverse of the *function* $f(x)=1/x$ (which is $f^{-1}(x) = 1/x$).
""")

# ╔═╡ d481170a-53bf-11ec-38bc-a760cebce278
md"""##### Example
"""

# ╔═╡ d481180e-53bf-11ec-0252-4d1976584bc9
md"""Suppose a transformation of $x$ is given by $y = f(x) = (ax + b)/(cx+d)$. This function is  invertible for most choices of the parameters. Find the inverse and describe it's domain.
"""

# ╔═╡ d4811912-53bf-11ec-18c1-1151341ffab1
md"""From the expression $y=f(x)$ we *algebraically* solve for $x$:
"""

# ╔═╡ d481193a-53bf-11ec-26b6-eddb2bfa8f34
md"""```math
\begin{align*}
y &= \frac{ax +b}{cx+d}\\
y \cdot (cx + d) &= ax + b\\
ycx - ax &= b - yd\\
(cy-a) \cdot x &= b - dy\\
x &= -\frac{dy - b}{cy-a}.
\end{align*}
```
"""

# ╔═╡ d4811964-53bf-11ec-33c4-ede112e59818
md"""We see that to solve for $x$ we need to divide by $cy-a$, so this expression can not be zero. So, using $x$ as the dummy variable, we have
"""

# ╔═╡ d4811976-53bf-11ec-14f9-77857e000e2b
md"""```math
f^{-1}(x) = -\frac{dx - b}{cx-a},\quad  cx-a \neq 0.
```
"""

# ╔═╡ d481198a-53bf-11ec-2875-a35031fb4749
md"""##### Example
"""

# ╔═╡ d48119a8-53bf-11ec-0cf4-6f93472e254d
md"""The function $f(x) = (x-1)^5 + 2$ is strictly increasing and so will have an inverse function. Find it.
"""

# ╔═╡ d48119d0-53bf-11ec-38b7-cd2642303846
md"""Again, we solve algebraically starting with $y=(x-1)^5 + 2$ and solving for $x$:
"""

# ╔═╡ d48119e4-53bf-11ec-3e74-ad40753766b2
md"""```math
\begin{align*}
y &= (x-1)^5 + 2\\
y - 2 &= (x-1)^5\\
(y-2)^{1/5} &= x - 1\\
(y-2)^{1/5} + 1 &= x.
\end{align*}
```
"""

# ╔═╡ d4811a0c-53bf-11ec-207c-a3bce2e5fa0a
md"""We see that $f^{-1}(x) = 1 + (x - 2)^{1/5}$. The fact that the power $5$ is an odd power is important, as this ensures a unique (real) solution to the fifth root of a value, in the above $y-2$.
"""

# ╔═╡ d4811a20-53bf-11ec-23fd-1ffc8f3e2f95
md"""##### Example
"""

# ╔═╡ d4811aa2-53bf-11ec-38fc-ffc11f4c66a0
md"""The function $f(x) = x^x,  x \geq 1/e$ is strictly increasing. However, trying to algebraically solve for an inverse function will quickly run into problems (without using specially defined functions). The existence of an inverse does not imply there will always be luck in trying to find a mathematical rule defining the inverse.
"""

# ╔═╡ d4811acc-53bf-11ec-0538-65707090dd78
md"""## Functions which are not always invertible
"""

# ╔═╡ d4811b10-53bf-11ec-1858-696ebb10526e
md"""Consider the function $f(x) = x^2$. The graph - a parabola - is clearly not *monotonic*. Hence no inverse function exists. Yet, we can solve equations $y=x^2$ quite easily: $y=\sqrt{x}$ *or* $y=-\sqrt{x}$. We know the square root undoes the squaring, but we need to be a little more careful to say the square root is the inverse of the squaring function.
"""

# ╔═╡ d4811b56-53bf-11ec-3295-95a052e59396
md"""The issue is there are generally *two* possible answers. To avoid this, we might choose to only take the *non-negative* answer. To make this all work as above, we restrict the domain of $f(x)$ and now consider the related function $f(x)=x^2, x \geq 0$. This is now a monotonic function, so will have an inverse function. This is clearly $f^{-1}(x) = \sqrt{x}$.
"""

# ╔═╡ d4811bd8-53bf-11ec-2527-5f9561ce54c2
md"""The [inverse function theorem](https://en.wikipedia.org/wiki/Inverse_function_theorem) basically says that if $f$ is *locally* monotonic, then an inverse function will exist *locally*. By "local" we mean in a neighborhood of $c$.
"""

# ╔═╡ d4811bf6-53bf-11ec-2134-7bd0d403e002
md"""##### Example
"""

# ╔═╡ d4811c28-53bf-11ec-0e57-9bcd345286d7
md"""Consider the function $f(x) = (1+x^2)^{-1}$. This bell-shaped function is even (symmetric about $0$), so can not possibly be one-to-one. However, if the domain is restricted to $[0,\infty)$ it is. The restricted function is strictly decreasing and its inverse is found, as follows:
"""

# ╔═╡ d4811c50-53bf-11ec-3b5d-298b75bfbb87
md"""```math
\begin{align*}
y &= \frac{1}{1 + x^2}\\
1+x^2 &= \frac{1}{y}\\
x^2 &= \frac{1}{y} - 1\\
x &= \sqrt{(1-y)/y}, \quad 0 \leq y \leq 1.
\end{align*}
```
"""

# ╔═╡ d4811c78-53bf-11ec-3043-7504272da78d
md"""Then $f^{-1}(x) = \sqrt{(1-x)/x}$ where $0 < x \leq 1$. The somewhat complicated restriction for the the domain coincides with the range of $f(x)$. We shall see next that this is no coincidence.
"""

# ╔═╡ d4811c8c-53bf-11ec-0e24-2f791f28f25b
md"""## Formal properties of the inverse function
"""

# ╔═╡ d4811caa-53bf-11ec-319b-efa4fd028add
md"""Consider again the graph of a monotonic function, in this case $f(x) = x^2 + 2, x \geq 0$:
"""

# ╔═╡ d4812556-53bf-11ec-0120-fb5465ff8601
let
	f(x) = x^2 + 2
	plot(f, 0, 4, legend=false)
	plot!([2,2,0], [0,f(2),f(2)])
end

# ╔═╡ d481259c-53bf-11ec-2665-b9854bc28e97
md"""The graph is shown over the interval $(0,4)$, but the *domain* of $f(x)$ is all $x \geq 0$. The *range* of $f(x)$ is clearly $2 \leq x \leq \infty$.
"""

# ╔═╡ d48125da-53bf-11ec-0f03-cf9c67312fd0
md"""The lines layered on the plot show how to associate an $x$ value to a $y$ value or vice versa (as $f(x)$ is one-to-one). The domain then of the inverse function is all the $y$ values for which a corresponding $x$ value exists: this is clearly all values bigger or equal to $2$. The *range* of the inverse function can be seen to be all the images for the values of $y$, which would be all $x \geq 0$. This gives the relationship:
"""

# ╔═╡ d4813f14-53bf-11ec-3ef1-4382a0819f4f
md"""> the *range* of $f(x)$ is the *domain* of $f^{-1}(x)$ and furthermore the *domain* of $f(x)$ is the *range* for $f^{-1}(x)$;

"""

# ╔═╡ d4813f78-53bf-11ec-138e-fd154dd46e8e
md"""Further, from this we can see if we start at $x$, apply $f$ we get $y$, if we then apply $f^{-1}$ we will get back to $x$ so we have:
"""

# ╔═╡ d4814004-53bf-11ec-1665-a5e93574dfcb
md"""> For all $x$ in the domain of $f$: $f^{-1}(f(x)) = x$.

"""

# ╔═╡ d4814018-53bf-11ec-045a-df06f5abe732
md"""Similarly, were we to start on the $y$ axis, we would see:
"""

# ╔═╡ d4814068-53bf-11ec-1e82-1f41b7d801d6
md"""> For all $x$ in the domain of $f^{-1}$: $f(f^{-1}(x)) = x$.

"""

# ╔═╡ d481407c-53bf-11ec-1d1a-87db97022f1b
md"""In short $f^{-1} \circ f$ and $f \circ f^{-1}$ are both identity functions, though on possibly different domains.
"""

# ╔═╡ d481409a-53bf-11ec-0823-316336ed0430
md"""## The graph of the inverse function
"""

# ╔═╡ d48140b8-53bf-11ec-022a-1ba005595efd
md"""The graph of $f(x)$ is a representation of all values $(x,y)$ where $y=f(x)$. As the inverse flips around the role of $x$ and $y$ we have:
"""

# ╔═╡ d48140f4-53bf-11ec-3cd4-41e447061816
md"""> If $(x,y)$ is a point on the graph of $f(x)$, then $(y,x)$ will be a point on the graph of $f^{-1}(x)$.

"""

# ╔═╡ d4814108-53bf-11ec-1782-f7f0d5d6f511
md"""Let's see this in action. Take the function $2^x$. We can plot it by generating points to plot as follows:
"""

# ╔═╡ d48147a2-53bf-11ec-3330-b7ffcf65710d
let
	f(x) = 2^x
	xs = range(0, 2, length=50)
	ys = f.(xs)
	plot(xs, ys, color=:blue, label="f")
	plot!(ys, xs, color=:red, label="f⁻¹") # the inverse
end

# ╔═╡ d48147e8-53bf-11ec-21c6-5d1494899e1d
md"""By flipping around the $x$ and $y$ values in the `plot!` command, we produce the graph of the inverse function - when viewed as a function of $x$. We can see that the domain of the inverse function (in red) is clearly different from that of the function (in blue).
"""

# ╔═╡ d4814808-53bf-11ec-341f-116f281ae3a3
md"""The inverse function graph can be viewed as a symmetry of the graph of the function. Flipping the graph for $f(x)$ around the line $y=x$ will produce the graph of the inverse function: Here we see for the graph of $f(x) = x^{1/3}$ and its inverse function:
"""

# ╔═╡ d4814ca4-53bf-11ec-2a8c-b5f0c4404628
let
	f(x) = cbrt(x)
	xs = range(-2, 2, length=150)
	ys = f.(xs)
	plot(xs, ys, color=:blue, aspect_ratio=:equal, legend=false)
	plot!(ys, xs, color=:red)
	plot!(identity, color=:green, linestyle=:dash)
	x, y = 1/2, f(1/2)
	plot!([x,y], [y,x], color=:green, linestyle=:dot)
end

# ╔═╡ d4814cde-53bf-11ec-2cf5-ab21f3cde057
md"""We drew a line connecting $(1/2, f(1/2))$ to $(f(1/2),1/2)$. We can see that it crosses the line $y=x$ perpendicularly, indicating that points are symmetric about this line. (The plotting argument `aspect_ratio=:equal` ensures that the $x$ and $y$ axes are on the same scale, so that this type of line will look perpendicular.)
"""

# ╔═╡ d4814cfc-53bf-11ec-312b-5f4f63150dfb
md"""One consequence of this symmetry, is that if $f$ is strictly increasing, then so is its inverse.
"""

# ╔═╡ d48159c2-53bf-11ec-3f37-f7103e1042a2
note(L"""In the above we used `cbrt(x)` and not `x^(1/3)`. The latter usage assumes that $x \geq 0$ as it isn't guaranteed that for all real exponents the answer will be a real number. The `cbrt` function knows there will always be a real answer and provides it.
""")

# ╔═╡ d48159ec-53bf-11ec-0edd-ab11329b9f09
md"""## Lines
"""

# ╔═╡ d4815a1e-53bf-11ec-09c7-4dc4aca24fd2
md"""The slope of $f(x) = 9/5 \cdot x + 32$ is clearly $9/5$ and the slope of the inverse function $f^{-1}(x) = 5/9 \cdot (x-32)$ is clearly $5/9$ - or the reciprocal. This makes sense, as the slope is the rise over the run, and by flipping the $x$ and $y$ values we merely flip over the rise and the run.
"""

# ╔═╡ d4815a44-53bf-11ec-0ce3-77e9e1e93fda
md"""Now consider the graph of the *tangent line* to a function. This concept will be better defined later, for now, it is a line "tangent" to the graph of $f(x)$ at a point $x=c$.
"""

# ╔═╡ d4815a62-53bf-11ec-29e8-69e5dd449e2a
md"""For concreteness, we consider $f(x) = \sqrt{x}$ at $c=2$. The tangent line will have slope $1/(2\sqrt{2})$ and will go through the point $(2, f(2)$. We graph the function, its tangent line, and their inverses:
"""

# ╔═╡ d4815e68-53bf-11ec-07cf-07bfcccbf160
let
	f(x) = sqrt(x)
	c = 2
	tl(x) = f(c) + 1/(2 * sqrt(2)) * (x - c)
	xs = range(0, 3, length=150)
	ys = f.(xs)
	zs = tl.(xs)
	plot(xs, ys,  color=:blue, legend=false)
	plot!(xs, zs, color=:blue) # the tangent line
	plot!(ys, xs, color=:red)  # the inverse function
	plot!(zs, xs, color=:red)  # inverse of tangent line
end

# ╔═╡ d4815e90-53bf-11ec-1299-1172344c3f37
md"""What do we see? In blue, we can see the familiar square root graph along with a "tangent" line through the point $(2, f(2))$. The red graph of $f^{-1}(x) = x^2, x \geq 0$ is seen and, perhaps surprisingly, a tangent line. This is at the point $(f(2), 2)$. We know the slope of this tangent line is the reciprocal of the slope of the red tangent line. This gives this informal observation:
"""

# ╔═╡ d4815f5a-53bf-11ec-06cc-b9752a548b35
md"""> If the graph of $f(x)$ has a tangent line at $(c, f(c))$ with slope $m$, then the graph of $f^{-1}(x)$ will have a tangent line at $(f(c), c)$ with slope $1/m$.

"""

# ╔═╡ d4815f6c-53bf-11ec-0832-016f23627d3d
md"""This is reminiscent of the formula for the slope of a perpendicular line, $-1/m$, but quite different, as this formula implies the two lines have either both positive slopes or both negative slopes, unlike the relationship in slopes between a line and a perpendicular line.
"""

# ╔═╡ d4815f94-53bf-11ec-011f-e7b6cec7bad9
md"""The key here is that the shape of $f(x)$ near $x=c$ is somewhat related to the shape of $f^{-1}(x)$ at $f(c)$. In this case, if we use the tangent line as a fill in for how steep a function is, we see from the relationship that if $f(x)$ is "steep" at $x=c$, then $f^{-1}(x)$ will be "shallow" at $x=f(c)$.
"""

# ╔═╡ d4815fb2-53bf-11ec-151c-01182f236c1e
md"""## Questions
"""

# ╔═╡ d481602a-53bf-11ec-14e5-e1887350ce3b
md"""###### Question
"""

# ╔═╡ d4816034-53bf-11ec-05f0-eb6207e1deaf
md"""Is it possible that a function have two different inverses?
"""

# ╔═╡ d481847e-53bf-11ec-175c-53d1fc90244a
let
	choices = [L"No, for all $x$ in the domain an an inverse, the value of any inverse will be the same, hence all inverse functions would be identical.",
	L"Yes, the function $f(x) = x^2, x \geq 0$ will have a different inverse than the same function $f(x) = x^2,  x \leq 0$"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d48184a6-53bf-11ec-13f3-5561722f9b37
md"""###### Question
"""

# ╔═╡ d48184d8-53bf-11ec-23a8-135dc135c183
md"""A function takes a value $x$ adds $1$, divides by $2$, and then subtracts $1$. Is the function "one-to-one"?
"""

# ╔═╡ d4818ee2-53bf-11ec-3d09-754770586908
let
	choices = [L"Yes, the function is the linear function $f(x)=(x+1)/2 + 1$ and so is monotonic.",
	L"No, the function is $1$ then $2$ then $1$, but not \"one-to-one\""
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d4818f0a-53bf-11ec-31d6-51c5b5e20797
md"""###### Question
"""

# ╔═╡ d4818f28-53bf-11ec-0368-e39a6cf556fe
md"""Is the function $f(x) = x^5 - x - 1$ one-to-one?
"""

# ╔═╡ d48196da-53bf-11ec-0f55-7dbf3797a83e
let
	choices=[L"Yes, a graph over $(-100, 100)$ will show this.",
	L"No, a graph over $(-2,2)$ will show this."
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ d481975c-53bf-11ec-303f-e1ecfe97c6d0
md"""###### Question
"""

# ╔═╡ d4819770-53bf-11ec-0c33-0fd59001bbbe
md"""A function is given by the table
"""

# ╔═╡ d4819798-53bf-11ec-19a6-0b6ca1fd91fc
md"""```
x  |   y
--------
1  |   3
2  |   4
3  |   5
4  |   3
5  |   4
6  |   5
```"""

# ╔═╡ d48197a4-53bf-11ec-2cee-09649d6f2da1
md"""Is the function one-to-one?
"""

# ╔═╡ d4819acc-53bf-11ec-0a9f-43d78abf4b4d
let
	yesnoq(false)
end

# ╔═╡ d4819aea-53bf-11ec-0fe4-8373d074df67
md"""###### Question
"""

# ╔═╡ d4819af4-53bf-11ec-0ed0-7729bededbad
md"""A function is defined by its graph.
"""

# ╔═╡ d4819fa4-53bf-11ec-25bb-090030317a6c
let
	f(x) = x - sin(x)
	plot(f, 0, 6pi)
end

# ╔═╡ d4819fc2-53bf-11ec-2cc0-c73d7b307a9d
md"""Over the domain shown, is the function one-to-one?
"""

# ╔═╡ d481a1fc-53bf-11ec-2afb-05eae46cfdca
let
	yesnoq(true)
end

# ╔═╡ d481a20e-53bf-11ec-3cc5-9527eb8f2ec7
md"""###### Question
"""

# ╔═╡ d481a238-53bf-11ec-23ab-657331970ad4
md"""Suppose $f(x) = x^{-1}$.
"""

# ╔═╡ d481a24c-53bf-11ec-0ca3-510354b97dc7
md"""What is $g(x) = (f(x))^{-1}$?
"""

# ╔═╡ d481a7f6-53bf-11ec-33e6-9d70c16f2af4
let
	choices = ["``g(x) = x``", "``g(x) = x^{-1}``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d481a820-53bf-11ec-3a4e-db991906a046
md"""What is $g(x) = f^{-1}(x)$?
"""

# ╔═╡ d481d6b8-53bf-11ec-1c92-c547fc0131a2
let
	choices = ["``g(x) = x``", "``g(x) = x^{-1}``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ d481d6ea-53bf-11ec-31aa-13a64721f8e3
md"""###### Question
"""

# ╔═╡ d481d71c-53bf-11ec-2e7b-6fad40e15936
md"""A function, $f$, is given by its graph:
"""

# ╔═╡ d481df1e-53bf-11ec-0370-57ac4af8c332
begin
	k(x) = sin(pi/4 * x)
	plot(k, -2, 2)
end

# ╔═╡ d481df50-53bf-11ec-1b0b-b9a412f08106
md"""What is the value of $f(1)$?
"""

# ╔═╡ d48248e6-53bf-11ec-1ec1-c1cc80665941
let
	val = k(1)
	numericq(val, 0.2)
end

# ╔═╡ d4824936-53bf-11ec-3363-2b3451ba6f1f
md"""What is the value of $f^{-1}(1)$?
"""

# ╔═╡ d4824d3c-53bf-11ec-1a51-255293a36de3
let
	val = 2
	numericq(val, 0.2)
end

# ╔═╡ d4824d64-53bf-11ec-2521-475649b5834c
md"""What is the value of $(f(1))^{-1}$?
"""

# ╔═╡ d4825234-53bf-11ec-09ae-0dbc1f4241bc
let
	val = 1/k(1)
	numericq(val, 0.2)
end

# ╔═╡ d4825266-53bf-11ec-1bde-9fd77b9d2e30
md"""What is the value of $f^{-1}(1/2)$?
"""

# ╔═╡ d482567e-53bf-11ec-30ab-7db85675c05c
let
	val = 2/3
	numericq(val, 0.2)
end

# ╔═╡ d48256a6-53bf-11ec-1347-ff4cdb5521f1
md"""###### Question
"""

# ╔═╡ d48256c4-53bf-11ec-3ba1-ed44380c70fd
md"""A function is described as follows: for $x > 0$ it takes the square root, adds $1$ and divides by $2$.
"""

# ╔═╡ d48256d8-53bf-11ec-1412-71af2335c57a
md"""What is the inverse of this function?
"""

# ╔═╡ d48263b2-53bf-11ec-08e5-ff0f8f1764fa
let
	choices=[
	L"The function that multiplies by $2$, subtracts $1$ and then squares the value.",
	L"The function that divides by $2$, adds $1$, and then takes the square root of the value.",
	L"The function that takes square of the value, then subtracts $1$, and finally multiplies by $2$."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d48263d0-53bf-11ec-26b2-e374bb186b6e
md"""###### Question
"""

# ╔═╡ d48263f8-53bf-11ec-06aa-3fbd5e6069b9
md"""A function, $f$, is specified by a table:
"""

# ╔═╡ d4826418-53bf-11ec-266f-e5d754c5f3c9
md"""```
x  |  y
-------
1  |  2
2  |  3
3  |  5
4  |  8
5  |  13
```"""

# ╔═╡ d482642a-53bf-11ec-12a4-13c00ac771fc
md"""What is $f(3)$?
"""

# ╔═╡ d48266aa-53bf-11ec-325a-974efe386dfe
let
	numericq(5)
end

# ╔═╡ d48266c8-53bf-11ec-1409-c3d02a76fe29
md"""What is $f^{-1}(3)$?
"""

# ╔═╡ d4826948-53bf-11ec-330f-fb07b51028a8
let
	numericq(2)
end

# ╔═╡ d4826966-53bf-11ec-257f-1bac15a5c849
md"""What is $f(5)^{-1}$?
"""

# ╔═╡ d482717c-53bf-11ec-24a2-63205a8bf5e2
let
	numericq(1/13)
end

# ╔═╡ d48271ea-53bf-11ec-0eca-c325647b47ba
md"""What is $f^{-1}(5)$?
"""

# ╔═╡ d4828428-53bf-11ec-0fcf-1334a8153c3a
let
	numericq(3)
end

# ╔═╡ d482845a-53bf-11ec-0cb5-bbe413f5cdce
md"""###### Question
"""

# ╔═╡ d482848c-53bf-11ec-1fc1-41420732e7cf
md"""Find the inverse function of $f(x) = (x^3 + 4)/5$.
"""

# ╔═╡ d4828dec-53bf-11ec-3e91-31e0fbd5d822
let
	choices = [
	"``f^{-1}(x) = (5y-4)^{1/3}``",
	"``f^{-1}(x) = (5y-4)^3``",
	"``f^{-1}(x) = 5/(x^3 + 4)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d4828e12-53bf-11ec-256d-41397e977520
md"""###### Question
"""

# ╔═╡ d4828e32-53bf-11ec-1a94-7f488deb9c99
md"""Find the inverse function of $f(x) = x^\pi + e,  x \geq 0$.
"""

# ╔═╡ d48296d4-53bf-11ec-14fe-0b0d1b0788f3
let
	choices = [
	raw"``f^{-1}(x) = (x-e)^{1/\pi}``",
	raw"``f^{-1}(x) = (x-\pi)^{e}``",
	raw"``f^{-1}(x) = (x-e)^{\pi}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d48296e8-53bf-11ec-1332-d9f332e0f3b8
md"""###### Question
"""

# ╔═╡ d482972e-53bf-11ec-1605-931dca0fad49
md"""What is the *domain* of the inverse function for $f(x) = x^2 + 7,  x \geq 0$?
"""

# ╔═╡ d4829e86-53bf-11ec-32c8-f5b940f4c084
let
	choices = [
	raw"``[7, \infty)``",
	raw"``(-\infty, \infty)``",
	raw"``[0, \infty)``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d4829ea4-53bf-11ec-0bf7-794bf43fe4ef
md"""###### Question
"""

# ╔═╡ d4829ee0-53bf-11ec-17a2-d19815d801cb
md"""What is the *range* of the inverse function for $f(x) =  x^2 + 7,  x \geq 0$?
"""

# ╔═╡ d482a61a-53bf-11ec-3928-4b5b0d27522a
let
	choices = [
	raw"``[7, \infty)``",
	raw"``(-\infty, \infty)``",
	raw"``[0, \infty)``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ d482bf1a-53bf-11ec-1954-a3e20353c08b
md"""###### Question
"""

# ╔═╡ d482bf54-53bf-11ec-0f9d-d94017137da4
md"""From the plot, are blue and red inverse functions?
"""

# ╔═╡ d482c4d8-53bf-11ec-1d51-fd12c77f9e89
let
	f(x) = x^3
	xs = range(0, 2, length=100)
	ys = f.(xs)
	plot(xs, ys, color=:blue, legend=false)
	plot!(ys, xs, color=:red)
	plot!(x->x, linestyle=:dash)
end

# ╔═╡ d482c7d0-53bf-11ec-3d6c-81428ea8ab7b
let
	yesnoq(true)
end

# ╔═╡ d482c7f8-53bf-11ec-07b7-0b0b40faadab
md"""From the plot, are blue and red inverse functions?
"""

# ╔═╡ d4834168-53bf-11ec-0041-11357ec2d104
let
	f(x) = x^3 - x - 1
	xs = range(-2,2, length=100)
	ys = f.(xs)
	plot(xs, ys, color=:blue, legend=false)
	plot!(-xs, -ys, color=:red)
	plot!(x->x, linestyle=:dash)
end

# ╔═╡ d483458e-53bf-11ec-3af0-e7acc97b7ecb
let
	yesnoq(false)
end

# ╔═╡ d48345e8-53bf-11ec-1883-bb47a1eb6d6e
md"""###### Question
"""

# ╔═╡ d4834692-53bf-11ec-0986-2dd9866a0a67
md"""The function $f(x) = (ax + b)/(cx + d)$ is known as a [Mobius](http://tinyurl.com/oemweyj) transformation and can be expressed as a composition of $4$ functions, $f_4 \circ f_3 \circ f_2 \circ f_1$:
"""

# ╔═╡ d48348d6-53bf-11ec-2524-95e78f25228c
md"""  * where $f_1(x) = x + d/c$ is a translation,
  * where $f_2(x) = x^{-1}$ is inversion and reflection,
  * where $f_3(x) = ((bc-ad)/c^2) \cdot x$ is scaling,
  * and $f_4(x) = x + a/c$ is a translation.
"""

# ╔═╡ d4834908-53bf-11ec-0dfc-e384b87dfd35
md"""For $x=10$, what is $f(10)$?
"""

# ╔═╡ d4835bbc-53bf-11ec-3b1b-0bb78df054d1
begin
	𝒂,𝒃,𝒄,𝒅 = 1,2,3,5
	f1(x) = x + 𝒅/𝒄; f2(x) = 1/x; f3(x) = (𝒃*𝒄-𝒂*𝒅)/𝒄^2 * x; f4(x)= x + 𝒂/𝒄
	𝒇(x;a=𝒂,b=𝒃,c=𝒄,d=𝒅) = (a*x+b) / (c*x + d)
	numericq(𝒇(10))
end

# ╔═╡ d4835c2c-53bf-11ec-27b0-a9ee2a28c8f1
md"""For $x=10$, what is $f_4(f_3(f_2(f_1(10))))$?
"""

# ╔═╡ d4839974-53bf-11ec-00c6-b197e4f4ffe7
let
	numericq(f4(f3(f2(f1(10)))))
end

# ╔═╡ d48399b2-53bf-11ec-3dfc-0fb0d46afff8
md"""The last two answers should be the same, why?
"""

# ╔═╡ d483a6c0-53bf-11ec-0c96-e3b0db311f47
let
	choices = [
	    L"As $f_4(f_3(f_2(f)_1(x))))=(f_4 \circ f_3 \circ f_2 \circ f_1)(x)$",
	    L"As $f_4(f_3(f_2(f_1(x))))=(f_1 \circ f_2 \circ f_3 \circ f_4)(x)$",
	    "As the latter is more complicated than the former."
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ d483a70e-53bf-11ec-1225-177d96a49922
md"""Let $g_1$, $g_2$, $g_3$, and $g_4$ denote the inverse functions. Clearly, $g_1(x) = x- d/c$ and $g+4(x) = x - a/c$, as the inverse of adding a constant is subtracting the constant.
"""

# ╔═╡ d483a72c-53bf-11ec-1410-ad7836435c74
md"""What is $g_2(x)=f_2^{-1}(x)$?
"""

# ╔═╡ d483ae9a-53bf-11ec-172e-ab3b79ca3e24
let
	choices = ["``g_2(x) = x^{-1}``", "``g_2(x) = x``", "``g_2(x) = x -1``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d483aec0-53bf-11ec-33c7-550914039cce
md"""What is $g_3(x)=f_3^{-1}(x)$?
"""

# ╔═╡ d483b726-53bf-11ec-1650-9b962a353764
let
	choices = [
	    raw"``c^2/(b\cdot c - a\cdot d) \cdot  x``",
	    raw"``(b\cdot c-a\cdot d)/c^2 \cdot  x``",
	    raw"``c^2 x``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d483b758-53bf-11ec-1c74-9347fc45adc9
md"""Given these, what is the value of $g_4(g_3(g_2(g_1(f_4(f_3(f_2(f_1(10))))))))$?
"""

# ╔═╡ d483e040-53bf-11ec-0fc8-edf80040a813
begin
	g1(x) = x - 𝒅/𝒄; g2(x) = 1/x; g3(x) = 1/((𝒃*𝒄-𝒂*𝒅)/𝒄^2) *x; g4(x)= x - 𝒂/𝒄
	val1 = g4(g3(g2(g1(f4(f3(f2(f1(10))))))))
	numericq(val1)
end

# ╔═╡ d483e07a-53bf-11ec-3e45-8342962b795a
md"""What about the value of $g_1(g_2(g_3(g_4(f_4(f_3(f_2(f_1(10))))))))$?
"""

# ╔═╡ d483e98a-53bf-11ec-3db4-d97b0b27c70e
let
	val = g1(g2(g3(g4(f4(f3(f2(f1(10))))))))
	numericq(val)
end

# ╔═╡ d483e9bc-53bf-11ec-178b-617a47588943
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/transformations.html">◅ previous</a>  <a href="../precalc/polynomial.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/inversefunctions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ d483e9d0-53bf-11ec-29e1-c76929f5c126
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
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
# ╟─d483e99e-53bf-11ec-0517-5beaa6c533ba
# ╟─d47fb8c4-53bf-11ec-2f92-db98b350951e
# ╟─d47fb9aa-53bf-11ec-0336-9f6196c8ee69
# ╠═d48057a2-53bf-11ec-179f-df48b7c760e2
# ╟─d4805dc4-53bf-11ec-1019-efb05fba4127
# ╟─d4805e50-53bf-11ec-10bd-bb768da916fd
# ╟─d4805ed2-53bf-11ec-3444-b160213c2610
# ╟─d4805fb8-53bf-11ec-235e-cdb5107d5d12
# ╟─d4805ffe-53bf-11ec-3e16-bb96a54d088c
# ╟─d480601c-53bf-11ec-1f11-db93f38a167e
# ╟─d4806026-53bf-11ec-2dc1-3db3f6cd4f2a
# ╟─d480603c-53bf-11ec-2c96-4743a44cb65e
# ╠═d480a16c-53bf-11ec-2ceb-0f2dfac5fcca
# ╟─d480a266-53bf-11ec-058d-6fbd63176fb7
# ╟─d480a2fc-53bf-11ec-22b3-d93642abd0cd
# ╟─d480a36a-53bf-11ec-2abf-f7296fe171fd
# ╟─d480a3b0-53bf-11ec-09b5-11ac1f50a6b3
# ╟─d480a3d8-53bf-11ec-05a0-1d0e809c395c
# ╟─d480a482-53bf-11ec-2ed3-3f598af53bfe
# ╟─d480a4a0-53bf-11ec-184d-6f97bce67751
# ╟─d480a4be-53bf-11ec-0704-ed6daf0b39fb
# ╟─d480a536-53bf-11ec-3d55-41bee1b53df6
# ╟─d480a568-53bf-11ec-3b8a-c1bed851757b
# ╟─d480a6ee-53bf-11ec-0b2c-83d774a16b2e
# ╟─d480e2a8-53bf-11ec-1afa-2ff0034c3693
# ╟─d480e334-53bf-11ec-14e7-0ddfcee17ceb
# ╟─d480e3a2-53bf-11ec-349b-abaf72d71224
# ╟─d4811606-53bf-11ec-3994-6dd39d80dfeb
# ╟─d481170a-53bf-11ec-38bc-a760cebce278
# ╟─d481180e-53bf-11ec-0252-4d1976584bc9
# ╟─d4811912-53bf-11ec-18c1-1151341ffab1
# ╟─d481193a-53bf-11ec-26b6-eddb2bfa8f34
# ╟─d4811964-53bf-11ec-33c4-ede112e59818
# ╟─d4811976-53bf-11ec-14f9-77857e000e2b
# ╟─d481198a-53bf-11ec-2875-a35031fb4749
# ╟─d48119a8-53bf-11ec-0cf4-6f93472e254d
# ╟─d48119d0-53bf-11ec-38b7-cd2642303846
# ╟─d48119e4-53bf-11ec-3e74-ad40753766b2
# ╟─d4811a0c-53bf-11ec-207c-a3bce2e5fa0a
# ╟─d4811a20-53bf-11ec-23fd-1ffc8f3e2f95
# ╟─d4811aa2-53bf-11ec-38fc-ffc11f4c66a0
# ╟─d4811acc-53bf-11ec-0538-65707090dd78
# ╟─d4811b10-53bf-11ec-1858-696ebb10526e
# ╟─d4811b56-53bf-11ec-3295-95a052e59396
# ╟─d4811bd8-53bf-11ec-2527-5f9561ce54c2
# ╟─d4811bf6-53bf-11ec-2134-7bd0d403e002
# ╟─d4811c28-53bf-11ec-0e57-9bcd345286d7
# ╟─d4811c50-53bf-11ec-3b5d-298b75bfbb87
# ╟─d4811c78-53bf-11ec-3043-7504272da78d
# ╟─d4811c8c-53bf-11ec-0e24-2f791f28f25b
# ╟─d4811caa-53bf-11ec-319b-efa4fd028add
# ╠═d4812556-53bf-11ec-0120-fb5465ff8601
# ╟─d481259c-53bf-11ec-2665-b9854bc28e97
# ╟─d48125da-53bf-11ec-0f03-cf9c67312fd0
# ╟─d4813f14-53bf-11ec-3ef1-4382a0819f4f
# ╟─d4813f78-53bf-11ec-138e-fd154dd46e8e
# ╟─d4814004-53bf-11ec-1665-a5e93574dfcb
# ╟─d4814018-53bf-11ec-045a-df06f5abe732
# ╟─d4814068-53bf-11ec-1e82-1f41b7d801d6
# ╟─d481407c-53bf-11ec-1d1a-87db97022f1b
# ╟─d481409a-53bf-11ec-0823-316336ed0430
# ╟─d48140b8-53bf-11ec-022a-1ba005595efd
# ╟─d48140f4-53bf-11ec-3cd4-41e447061816
# ╟─d4814108-53bf-11ec-1782-f7f0d5d6f511
# ╠═d48147a2-53bf-11ec-3330-b7ffcf65710d
# ╟─d48147e8-53bf-11ec-21c6-5d1494899e1d
# ╟─d4814808-53bf-11ec-341f-116f281ae3a3
# ╠═d4814ca4-53bf-11ec-2a8c-b5f0c4404628
# ╟─d4814cde-53bf-11ec-2cf5-ab21f3cde057
# ╟─d4814cfc-53bf-11ec-312b-5f4f63150dfb
# ╟─d48159c2-53bf-11ec-3f37-f7103e1042a2
# ╟─d48159ec-53bf-11ec-0edd-ab11329b9f09
# ╟─d4815a1e-53bf-11ec-09c7-4dc4aca24fd2
# ╟─d4815a44-53bf-11ec-0ce3-77e9e1e93fda
# ╟─d4815a62-53bf-11ec-29e8-69e5dd449e2a
# ╠═d4815e68-53bf-11ec-07cf-07bfcccbf160
# ╟─d4815e90-53bf-11ec-1299-1172344c3f37
# ╟─d4815f5a-53bf-11ec-06cc-b9752a548b35
# ╟─d4815f6c-53bf-11ec-0832-016f23627d3d
# ╟─d4815f94-53bf-11ec-011f-e7b6cec7bad9
# ╟─d4815fb2-53bf-11ec-151c-01182f236c1e
# ╟─d481602a-53bf-11ec-14e5-e1887350ce3b
# ╟─d4816034-53bf-11ec-05f0-eb6207e1deaf
# ╟─d481847e-53bf-11ec-175c-53d1fc90244a
# ╟─d48184a6-53bf-11ec-13f3-5561722f9b37
# ╟─d48184d8-53bf-11ec-23a8-135dc135c183
# ╟─d4818ee2-53bf-11ec-3d09-754770586908
# ╟─d4818f0a-53bf-11ec-31d6-51c5b5e20797
# ╟─d4818f28-53bf-11ec-0368-e39a6cf556fe
# ╟─d48196da-53bf-11ec-0f55-7dbf3797a83e
# ╟─d481975c-53bf-11ec-303f-e1ecfe97c6d0
# ╟─d4819770-53bf-11ec-0c33-0fd59001bbbe
# ╟─d4819798-53bf-11ec-19a6-0b6ca1fd91fc
# ╟─d48197a4-53bf-11ec-2cee-09649d6f2da1
# ╟─d4819acc-53bf-11ec-0a9f-43d78abf4b4d
# ╟─d4819aea-53bf-11ec-0fe4-8373d074df67
# ╟─d4819af4-53bf-11ec-0ed0-7729bededbad
# ╟─d4819fa4-53bf-11ec-25bb-090030317a6c
# ╟─d4819fc2-53bf-11ec-2cc0-c73d7b307a9d
# ╟─d481a1fc-53bf-11ec-2afb-05eae46cfdca
# ╟─d481a20e-53bf-11ec-3cc5-9527eb8f2ec7
# ╟─d481a238-53bf-11ec-23ab-657331970ad4
# ╟─d481a24c-53bf-11ec-0ca3-510354b97dc7
# ╟─d481a7f6-53bf-11ec-33e6-9d70c16f2af4
# ╟─d481a820-53bf-11ec-3a4e-db991906a046
# ╟─d481d6b8-53bf-11ec-1c92-c547fc0131a2
# ╟─d481d6ea-53bf-11ec-31aa-13a64721f8e3
# ╟─d481d71c-53bf-11ec-2e7b-6fad40e15936
# ╟─d481df1e-53bf-11ec-0370-57ac4af8c332
# ╟─d481df50-53bf-11ec-1b0b-b9a412f08106
# ╟─d48248e6-53bf-11ec-1ec1-c1cc80665941
# ╟─d4824936-53bf-11ec-3363-2b3451ba6f1f
# ╟─d4824d3c-53bf-11ec-1a51-255293a36de3
# ╟─d4824d64-53bf-11ec-2521-475649b5834c
# ╟─d4825234-53bf-11ec-09ae-0dbc1f4241bc
# ╟─d4825266-53bf-11ec-1bde-9fd77b9d2e30
# ╟─d482567e-53bf-11ec-30ab-7db85675c05c
# ╟─d48256a6-53bf-11ec-1347-ff4cdb5521f1
# ╟─d48256c4-53bf-11ec-3ba1-ed44380c70fd
# ╟─d48256d8-53bf-11ec-1412-71af2335c57a
# ╟─d48263b2-53bf-11ec-08e5-ff0f8f1764fa
# ╟─d48263d0-53bf-11ec-26b2-e374bb186b6e
# ╟─d48263f8-53bf-11ec-06aa-3fbd5e6069b9
# ╟─d4826418-53bf-11ec-266f-e5d754c5f3c9
# ╟─d482642a-53bf-11ec-12a4-13c00ac771fc
# ╟─d48266aa-53bf-11ec-325a-974efe386dfe
# ╟─d48266c8-53bf-11ec-1409-c3d02a76fe29
# ╟─d4826948-53bf-11ec-330f-fb07b51028a8
# ╟─d4826966-53bf-11ec-257f-1bac15a5c849
# ╟─d482717c-53bf-11ec-24a2-63205a8bf5e2
# ╟─d48271ea-53bf-11ec-0eca-c325647b47ba
# ╟─d4828428-53bf-11ec-0fcf-1334a8153c3a
# ╟─d482845a-53bf-11ec-0cb5-bbe413f5cdce
# ╟─d482848c-53bf-11ec-1fc1-41420732e7cf
# ╟─d4828dec-53bf-11ec-3e91-31e0fbd5d822
# ╟─d4828e12-53bf-11ec-256d-41397e977520
# ╟─d4828e32-53bf-11ec-1a94-7f488deb9c99
# ╟─d48296d4-53bf-11ec-14fe-0b0d1b0788f3
# ╟─d48296e8-53bf-11ec-1332-d9f332e0f3b8
# ╟─d482972e-53bf-11ec-1605-931dca0fad49
# ╟─d4829e86-53bf-11ec-32c8-f5b940f4c084
# ╟─d4829ea4-53bf-11ec-0bf7-794bf43fe4ef
# ╟─d4829ee0-53bf-11ec-17a2-d19815d801cb
# ╟─d482a61a-53bf-11ec-3928-4b5b0d27522a
# ╟─d482bf1a-53bf-11ec-1954-a3e20353c08b
# ╟─d482bf54-53bf-11ec-0f9d-d94017137da4
# ╟─d482c4d8-53bf-11ec-1d51-fd12c77f9e89
# ╟─d482c7d0-53bf-11ec-3d6c-81428ea8ab7b
# ╟─d482c7f8-53bf-11ec-07b7-0b0b40faadab
# ╟─d4834168-53bf-11ec-0041-11357ec2d104
# ╟─d483458e-53bf-11ec-3af0-e7acc97b7ecb
# ╟─d48345e8-53bf-11ec-1883-bb47a1eb6d6e
# ╟─d4834692-53bf-11ec-0986-2dd9866a0a67
# ╟─d48348d6-53bf-11ec-2524-95e78f25228c
# ╟─d4834908-53bf-11ec-0dfc-e384b87dfd35
# ╟─d4835bbc-53bf-11ec-3b1b-0bb78df054d1
# ╟─d4835c2c-53bf-11ec-27b0-a9ee2a28c8f1
# ╟─d4839974-53bf-11ec-00c6-b197e4f4ffe7
# ╟─d48399b2-53bf-11ec-3dfc-0fb0d46afff8
# ╟─d483a6c0-53bf-11ec-0c96-e3b0db311f47
# ╟─d483a70e-53bf-11ec-1225-177d96a49922
# ╟─d483a72c-53bf-11ec-1410-ad7836435c74
# ╟─d483ae9a-53bf-11ec-172e-ab3b79ca3e24
# ╟─d483aec0-53bf-11ec-33c7-550914039cce
# ╟─d483b726-53bf-11ec-1650-9b962a353764
# ╟─d483b758-53bf-11ec-1c74-9347fc45adc9
# ╟─d483e040-53bf-11ec-0fc8-edf80040a813
# ╟─d483e07a-53bf-11ec-3e45-8342962b795a
# ╟─d483e98a-53bf-11ec-3db4-d97b0b27c70e
# ╟─d483e9bc-53bf-11ec-178b-617a47588943
# ╟─d483e9c6-53bf-11ec-2e7d-7560e26895ea
# ╟─d483e9d0-53bf-11ec-29e1-c76929f5c126
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
