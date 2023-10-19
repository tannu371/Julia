### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 4bf9d8a4-5399-11ec-24a2-8bf5aa574d19
begin
	using CalculusWithJulia
	using Plots
	using ImplicitEquations
	import IntervalArithmetic
	using IntervalConstraintProgramming
	using Roots
	using SymPy
end

# ╔═╡ 4bf9dba2-5399-11ec-3db8-894baebf6e4c
begin
	using CalculusWithJulia.WeaveSupport
	using LaTeXStrings
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 4bff8854-5399-11ec-3e53-f906e1bbae16
using PlutoUI

# ╔═╡ 4bff87f0-5399-11ec-3887-b1a538e7094f
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 4bf9d172-5399-11ec-198a-93f5e3a98e3e
md"""# Implicit Differentiation
"""

# ╔═╡ 4bf9d1ae-5399-11ec-09fb-4df481d99e2e
md"""This section uses these add-on packages:
"""

# ╔═╡ 4bf9dbf4-5399-11ec-3ece-25ef1c21023e
md"""## Graphs of equations
"""

# ╔═╡ 4bf9dc94-5399-11ec-1fef-37281a2f643a
md"""An **equation** in $y$ and $x$ is an algebraic expression involving an equality with two (or more) variables. An example might be $x^2 + y^2 = 1$.
"""

# ╔═╡ 4bf9dcbc-5399-11ec-34b7-01b4c18fa0f5
md"""The **solutions** to an equation in the variables $x$ and $y$ are all points $(x,y)$ which satisfy the equation.
"""

# ╔═╡ 4bf9dcd0-5399-11ec-0134-27caa97d4153
md"""The **graph** of an equation is just the set of solutions to the equation represented in the Cartesian plane.
"""

# ╔═╡ 4bf9dd20-5399-11ec-3581-11a1861d085b
md"""With this definition, the graph of a function $f(x)$ is just the graph of the equation $y = f(x)$. In general, graphing an equation is more complicated than graphing a function. For a function, we know for a given value of $x$ what the corresponding value of $f(x)$ is through evaluation of the function. For equations, we may have $0$, $1$ or more $y$ values for a given $x$ and even more problematic is we may have no rule to find these values.
"""

# ╔═╡ 4bf9dd52-5399-11ec-2075-af5de62b035a
md"""To plot such an equation in `Julia`, we can use the `ImplicitEquations` package.
"""

# ╔═╡ 4bf9dd70-5399-11ec-1395-3be34ccdfab1
md"""To plot the circle of radius $2$, we would first define a function of *two* variables:
"""

# ╔═╡ 4bf9e1da-5399-11ec-1895-2d86895efb51
f(x,y) = x^2 + y^2

# ╔═╡ 4bfa04e4-5399-11ec-1e95-43dedf7927a2
note("""

This is a function of *two* variables, used here to express one side of an equation. `Julia` makes this easy to do - just make sure two variables are in the signature of `f` when it is defined. Using functions like this, we can express our equation in the form ``f(x,y) = c`` or ``f(x,y) = g(x,y)``, the latter of which can be expressed as ``h(x,y) = f(x,y) - g(x,y) = 0``. That is, only the form ``f(x,y)=c`` is needed.

""")

# ╔═╡ 4bfa057c-5399-11ec-3c62-f9fdc2303303
md"""Then we use one of the logical operations - `Lt`, `Le`, `Eq`, `Ne`, `Ge`, or `Gt` - to construct a predicate to plot. This one describes $x^2 + y^2 = 2^2$:
"""

# ╔═╡ 4bfa0c3c-5399-11ec-3b48-cda7dbf4b956
r = Eq(f, 2^2)

# ╔═╡ 4bfa1498-5399-11ec-08f5-6da1a89d157f
note("""
There are unicode infix operators for each of these which make it
easier to read at the cost of being harder to type in. This predicate
would be written as `f ⩵ 2^2` where `⩵` is **not** two equals signs,
but rather typed with `\\Equal[tab]`.)
""")

# ╔═╡ 4bfa14c2-5399-11ec-01b0-61f07a891d34
md"""These "predicate" objects can be passed to `plot` for visualization:
"""

# ╔═╡ 4bfa160a-5399-11ec-06ed-c7843a251e6b
plot(r)

# ╔═╡ 4bfa165c-5399-11ec-0678-37e0d56aa5b7
md"""Of course, more complicated equations are possible and the steps are similar - only the function definition is more involved.  For example, the [Devils curve](http://www-groups.dcs.st-and.ac.uk/~history/Curves/Devils.html) has the form
"""

# ╔═╡ 4bfa1696-5399-11ec-216c-338fef5ae41e
md"""```math
y^4 - x^4 + ay^2 + bx^2 = 0
```
"""

# ╔═╡ 4bfa16d2-5399-11ec-231d-b3cbe8355347
md"""Here we draw the curve for a particular choice of $a$ and $b$. For illustration purposes, a narrower viewing window than the default of $[-5,5] \times [-5,5]$ is specified below using `xlims` and `ylims`:
"""

# ╔═╡ 4bfa1b0a-5399-11ec-08a3-cd8a9bd1009e
let
	a,b = -1,2
	f(x,y) =  y^4 - x^4 + a*y^2 + b*x^2
	plot(Eq(f, 0), xlims=(-3,3), ylims=(-3,3), M=8, N=8)
end

# ╔═╡ 4bfa28e8-5399-11ec-272b-251b1c367838
note("""

The rendered plots look "blocky" due to the algorithm used to plot the
equations. As there is no rule defining ``(x,y)`` pairs to plot, a
search by regions is done. A region is initially labeled
undetermined. If it can be shown that for any value in the region the
equation is true (equations can also be inequalities), the region is
colored black. If it can be shown it will never be true, the region is
dropped. If a black-and-white answer is not clear, the region is
subdivided and each subregion is similarly tested. This continues
until the remaining undecided regions are smaller than some
threshold. Such regions comprise a boundary, and here are also colored
black. Only regions are plotted - not ``(x,y)`` pairs - so the results
are blocky. Pass larger values of ``N=M`` (with defaults of ``10``) to
`plot` to lower the threshold at the cost of longer computation times.

""")

# ╔═╡ 4bfa292e-5399-11ec-2d26-a9f82573ab29
md"""### The IntervalConstraintProgramming package
"""

# ╔═╡ 4bfa2956-5399-11ec-27c2-2dd058eb51c7
md"""The `IntervalConstraintProgramming` package also can be used to graph implicit equations. For certain problem descriptions it is significantly faster and makes better graphs. The usage is slightly more involved:
"""

# ╔═╡ 4bfa2976-5399-11ec-2852-512c50b5dab3
md"""We specify a problem using the `@constraint` macro. Using a macro allows expressions to involve free symbols, so the problem is specified in an equation-like manner:
"""

# ╔═╡ 4bfa2e40-5399-11ec-2207-4d0c8c43d024
S = @constraint x^2 + y^2 <= 2

# ╔═╡ 4bfa2e56-5399-11ec-2f2a-a5bc62a87bd4
md"""The right hand side must be a number.
"""

# ╔═╡ 4bfa2e7e-5399-11ec-0009-39e7adc78b6c
md"""The area to plot over must be specified as an `IntervalBox`, basically a pair of intervals. The interval $[a,b]$ is expressed through `a..b`, though, as `CalculusWithJulia` co-opts that notation, the following workaround is needed:
"""

# ╔═╡ 4bfa3338-5399-11ec-220b-fbdebfff5868
begin
	J = IntervalArithmetic.Interval(-3, 3)  # can use -3..3 as it conflicts
	X = IntervalArithmetic.IntervalBox(J, J)
end

# ╔═╡ 4bfa35a4-5399-11ec-1043-5b65e2cb533f
region = IntervalConstraintProgramming.pave(S, X)

# ╔═╡ 4bfa35ba-5399-11ec-0848-493cda3359bf
md"""We can plot either the boundary, the interior, or both.
"""

# ╔═╡ 4bfa37c0-5399-11ec-3b45-e5887b4df6f0
plot(region.inner)       # plot interior; use r.boundary for boundary

# ╔═╡ 4bfa37de-5399-11ec-0b3d-852237b73ec8
md"""## Tangent lines, implicit differentiation
"""

# ╔═╡ 4bfa3824-5399-11ec-2fa2-411e6970244a
md"""The graph $x^2 + y^2 = 1$ has well-defined tangent lines at all points except $(-1,0)$ and $(0, 1)$ and even at these two points, we could call the vertical lines $x=-1$ and $x=1$ tangent lines. However, to recover the slope would need us to express $y$ as a function of $x$ and then differentiate that function. Of course, in this example, we would need two functions: $f(x) = \sqrt{1-x^2}$ and $g(x) = - \sqrt{1-x^2}$ to do this completely.
"""

# ╔═╡ 4bfa3842-5399-11ec-205e-e187e682e53b
md"""In general though, we may not be able to solve for $y$ in terms of $x$. What then?
"""

# ╔═╡ 4bfa388a-5399-11ec-133b-49dc3a7a2ab3
md"""The idea is to *assume* that $y$ is representable by some function of $x$. This makes sense, moving on the curve from $(x,y)$ to some nearby point, means changing $x$ will cause some change in $y$. This assumption is only made *locally* - basically meaning a complicated graph is reduced to just a small, well-behaved, section of its graph.
"""

# ╔═╡ 4bfa38a6-5399-11ec-3ff4-7324e21f338a
md"""With this assumption, asking what $dy/dx$ is has an obvious meaning - what is the slope of the tangent line to the graph at $(x,y)$. (The assumption eliminates the question of what a tangent line would  mean when a graph self intersects.)
"""

# ╔═╡ 4bfa38c4-5399-11ec-1cab-7945b3d88d1f
md"""The method of implicit differentiation allows this question to be investigated. It begins by differentiating both sides of the equation assuming $y$ is a function of $x$ to derive a new equation involving $dy/dx$.
"""

# ╔═╡ 4bfa38d8-5399-11ec-2863-c5c144931a44
md"""For example,  starting with $x^2 + y^2 = 1$, differentiating both sides in $x$ gives:
"""

# ╔═╡ 4bfa38ea-5399-11ec-2bdd-a9d27685287c
md"""```math
2x + 2y\cdot \frac{dy}{dx} = 0.
```
"""

# ╔═╡ 4bfa390a-5399-11ec-345f-0b338ff98dfa
md"""The chain rule was used to find $(d/dx)(y^2) = 2y \cdot dy/dx$. From this we can solve for $dy/dx$ (the resulting equations are linear in $dy/dx$, so can always be solved explicitly):
"""

# ╔═╡ 4bfa391c-5399-11ec-1925-5b1b0da1aa0a
md"""```math
dy/dx = -x/y
```
"""

# ╔═╡ 4bfa3932-5399-11ec-2062-9597eea97dbb
md"""This says the slope of the tangent line depends on the point $(x,y)$ through the formula $-x/y$.
"""

# ╔═╡ 4bfa395a-5399-11ec-1707-8de0bcc62ca2
md"""As a check, we compare to what we would have found had we solved for $y= \sqrt{1 - x^2}$ (for $(x,y)$ with $y \geq 0$). We would have found: $dy/dx = 1/2 \cdot 1/\sqrt{1 - x^2} \cdot -2x$. Which can be simplified to $-x/y$. This should show that the method above - assuming $y$ is a function of $x$ and differentiating - is not only more general, but can even be easier.
"""

# ╔═╡ 4bfa3996-5399-11ec-0339-0d4c27cc2437
md"""The name - *implicit differentiation* - comes from the assumption that $y$ is implicitly defined in terms of $x$.  According to the [Implicit Function Theorem](http://en.wikipedia.org/wiki/Implicit_function_theorem) the above method will work provided the curve has sufficient smoothness near the point $(x,y)$.
"""

# ╔═╡ 4bfa39d2-5399-11ec-2b6d-0de1d4c40eba
md"""##### Examples
"""

# ╔═╡ 4bfa39fa-5399-11ec-1117-4d8b39834085
md"""Consider the [serpentine](http://www-history.mcs.st-and.ac.uk/Curves/Serpentine.html) equation
"""

# ╔═╡ 4bfa3a04-5399-11ec-386a-adba595bf7d8
md"""```math
x^2y + a\cdot b \cdot y - a^2 \cdot x = 0, \quad a\cdot b > 0.
```
"""

# ╔═╡ 4bfa3a18-5399-11ec-01db-25f0836277a1
md"""For $a = 2, b=1$ we have the graph:
"""

# ╔═╡ 4bfa3eb4-5399-11ec-0321-bd7a86d0a97a
let
	a, b = 2, 1
	f(x,y) = x^2*y + a * b * y - a^2 * x
	plot(Eq(f, 0))
end

# ╔═╡ 4bfa3ee6-5399-11ec-371b-8382f444390b
md"""We can see that at each point in the viewing window the tangent line exists due to the smoothness of the curve. Moreover, at a point $(x,y)$ the tangent will have slope $dy/dx$ satisfying:
"""

# ╔═╡ 4bfa3efa-5399-11ec-01cc-f71edbe1a9d3
md"""```math
2xy + x^2 \frac{dy}{dx} + a\cdot b \frac{dy}{dx} - a^2 = 0.
```
"""

# ╔═╡ 4bfa3f04-5399-11ec-00b4-874d5f1e1703
md"""Solving, yields:
"""

# ╔═╡ 4bfa3f18-5399-11ec-2a72-c7ca639978a7
md"""```math
\frac{dy}{dx} = \frac{a^2 - 2xy}{ab + x^2}.
```
"""

# ╔═╡ 4bfa3f2e-5399-11ec-08c0-bf3f4e6bfedd
md"""In particular, the point $(0,0)$ is always on this graph, and the tangent line will have positive slope $a^2/(ab) = a/b$.
"""

# ╔═╡ 4bfa3f54-5399-11ec-336d-e1d46c06b9f7
md"""---
"""

# ╔═╡ 4bfa3f7c-5399-11ec-1bd9-c7c858348670
md"""The [eight](http://www-history.mcs.st-and.ac.uk/Curves/Eight.html) curve has representation
"""

# ╔═╡ 4bfa3f8e-5399-11ec-2962-a58746609417
md"""```math
x^4 = a^2(x^2-y^2), \quad a \neq 0.
```
"""

# ╔═╡ 4bfa3fa4-5399-11ec-07d9-d9167abfdcc5
md"""A graph for $a=3$ shows why it has the name it does:
"""

# ╔═╡ 4bfa43d2-5399-11ec-250f-d9e9838e2b79
let
	a = 3
	f(x,y) = x^4 - a^2*(x^2 - y^2)
	plot(Eq(f, 0))
end

# ╔═╡ 4bfa43f8-5399-11ec-0870-075ec14eefad
md"""The tangent line at $(x,y)$ will have slope, $dy/dx$ satisfying:
"""

# ╔═╡ 4bfa440e-5399-11ec-040b-dd650efc42ed
md"""```math
4x^3 = a^2 \cdot (2x - 2y \frac{dy}{dx}).
```
"""

# ╔═╡ 4bfa44c2-5399-11ec-1c24-55aa9ad93dcb
md"""Solving gives:
"""

# ╔═╡ 4bfa44ce-5399-11ec-2fb5-1f1b947a276f
md"""```math
\frac{dy}{dx} = -\frac{4x^3 - a^2 \cdot 2x}{a^2 \cdot 2y}.
```
"""

# ╔═╡ 4bfa4508-5399-11ec-0bc6-23740f4785a4
md"""The point $(3,0)$ can be seen to be a solution to the equation and should have a vertical tangent line. This also is reflected in the formula, as the denominator is $a^2\cdot 2 y$, which is $0$ at this point, whereas the numerator is not.
"""

# ╔═╡ 4bfa451c-5399-11ec-0ec1-4be3dbd7df94
md"""##### Example
"""

# ╔═╡ 4bfa453a-5399-11ec-0b41-4b79b064ae89
md"""The quotient rule can be hard to remember, unlike the product rule. No reason to despair, the product rule plus implicit differentiation can be used to recover the quotient rule. Suppose $y=f(x)/g(x)$, then we could also write $y g(x) = f(x)$. Differentiating implicitly gives:
"""

# ╔═╡ 4bfa4544-5399-11ec-2c24-49888212310e
md"""```math
\frac{dy}{dx} g(x) + y g'(x) = f'(x).
```
"""

# ╔═╡ 4bfa4558-5399-11ec-338a-51b7b83810a3
md"""Solving for $dy/dx$ gives:
"""

# ╔═╡ 4bfa456c-5399-11ec-2f84-212c3767a07c
md"""```math
\frac{dy}{dx} = \frac{f'(x) - y g'(x)}{g(x)}.
```
"""

# ╔═╡ 4bfa4580-5399-11ec-1720-5122b46a08fc
md"""Not quite what we expect, perhaps, but substituting in $f(x)/g(x)$ for $y$ gives us the usual formula:
"""

# ╔═╡ 4bfa4592-5399-11ec-2b4b-957ae0b9ff42
md"""```math
\frac{dy}{dx} = \frac{f'(x) - \frac{f(x)}{g(x)} g'(x)}{g(x)} = \frac{f'(x) g(x) - f(x) g'(x)}{g(x)^2}.
```
"""

# ╔═╡ 4bfa4c60-5399-11ec-027b-971235f0fd47
note("""

In this example we mix notations using ``g'(x)`` to
represent a derivative of ``g`` with respect to ``x`` and ``dy/dx`` to
represent the derivative of ``y`` with respect to ``x``. This is done to
emphasize the value that we are solving for. It is just a convention
though, we could just as well have used the "prime" notation for each.

""")

# ╔═╡ 4bfa4c7e-5399-11ec-0f9e-bb89d849e819
md"""##### Example: Graphing a tangent line
"""

# ╔═╡ 4bfa4c92-5399-11ec-00c5-f9c31cb84037
md"""Let's see how to add a graph of a tangent line to the graph of an equation. Tangent lines are tangent at a point, so we need a point to discuss.
"""

# ╔═╡ 4bfa4d96-5399-11ec-39e0-9d275ece1ecd
md"""Returning to the equation for a circle, $x^2 + y^2 = 1$, let's look at $(\sqrt{2}/2, - \sqrt{2}/2)$. The derivative is $-y/x$, so the slope at this point is $1$. The line itself has equation $y = b + m \cdot (x-a)$. The following represents this in `Julia`:
"""

# ╔═╡ 4bfa543a-5399-11ec-18cd-21838feaf233
let
	F(x,y) = x^2 + y^2
	
	a,b = sqrt(2)/2, -sqrt(2)/2
	
	m = -a/b
	tl(x) = b + m * (x-a)
	
	plot(Eq(F, 1), xlims=(-2, 2), ylims=(-2, 2), aspect_ratio=:equal)
	plot!(tl)
end

# ╔═╡ 4bfa546c-5399-11ec-1331-75a245420dc0
md"""We added *both* $F ⩵ 1$ and the tangent line to the graph.
"""

# ╔═╡ 4bfa5480-5399-11ec-33fb-855c9e9221f2
md"""##### Example
"""

# ╔═╡ 4bfa54bc-5399-11ec-1a44-b7874e0d384d
md"""When we assume $y$ is a function of $x$, it may not be feasible to actually find the function algebraically. However, in many cases one can be found numerically. Suppose $G(x,y) = c$ describes the equation. Then for a fixed $x$, $y(x)$ solves $G(x,y(x))) - c = 0$, so $y(x)$ is a zero of a known function. As long as we can piece together which $y$ goes with which, we can find the function.
"""

# ╔═╡ 4bfa54da-5399-11ec-3d79-a54ed09117bc
md"""For example, the [folium](http://www-history.mcs.st-and.ac.uk/Curves/Foliumd.html) of Descartes has the equation
"""

# ╔═╡ 4bfa54e4-5399-11ec-0113-49e4ce595513
md"""```math
x^3 + y^3  = 3axy.
```
"""

# ╔═╡ 4bfa54f8-5399-11ec-2832-4d1274025c77
md"""Setting $a=1$ we have the graph:
"""

# ╔═╡ 4bfa5804-5399-11ec-2a44-33e6fdb61920
begin
	𝒂 = 1
	G(x,y) = x^3 + y^3 - 3*𝒂*x*y
	plot(Eq(G,0))
end

# ╔═╡ 4bfa582c-5399-11ec-1eba-c3d0df9e9307
md"""We can solve for the lower curve, $y$, as a function of $x$, as follows:
"""

# ╔═╡ 4bfa5d72-5399-11ec-376b-270f36e2eafb
y1(x) = minimum(find_zeros(y->G(x,y), -10, 10))  # find_zeros from `Roots`

# ╔═╡ 4bfa5d90-5399-11ec-2fa7-0fc047905887
md"""This gives the lower part of the curve, which we can plot with:
"""

# ╔═╡ 4bfa5f98-5399-11ec-313e-e9d37aa79381
plot(y1, -5, 5)

# ╔═╡ 4bfa5fb6-5399-11ec-348e-0ba1b17af354
md"""Though, in this case, the cubic equation would admit a closed-form solution, the approach illustrated applies more generally.
"""

# ╔═╡ 4bfa5fca-5399-11ec-186e-9381f696a3c4
md"""## Using SymPy for computation
"""

# ╔═╡ 4bfc3ea8-5399-11ec-2040-ffe49d4c9946
md"""`SymPy` can be used to perform implicit differentiation. The three steps are similar: we assume $y$ is a function of $x$, *locally*; differentiate both sides; solve the result for $dy/dx$.
"""

# ╔═╡ 4bfc3f32-5399-11ec-0332-cf446db91742
md"""Let's do so for the [Trident of Newton](http://www-history.mcs.st-and.ac.uk/Curves/Trident.html), which is represented in Cartesian form as follows:
"""

# ╔═╡ 4bfc3f70-5399-11ec-335b-2373055e580e
md"""```math
xy = cx^3 + dx^2 + ex + h.
```
"""

# ╔═╡ 4bfc3f8e-5399-11ec-124d-116ae97351a9
md"""To approach this task in `SymPy`, we begin by defining our symbolic expression. For now, we keep the parameters as symbolic values:
"""

# ╔═╡ 4bfc61a8-5399-11ec-198c-f1a261c14e81
begin
	@syms a b c d x y
	ex = x*y - (a*c^3 + b*x^2 + c*x + d)
end

# ╔═╡ 4bfc6216-5399-11ec-1a97-dbbc9ddcbab7
md"""To express that `y` is a locally a function of `x`, we use a "symbolic function" object:
"""

# ╔═╡ 4bfc6494-5399-11ec-002b-bbdf456bc200
@syms u()

# ╔═╡ 4bfc64d2-5399-11ec-1ce0-015b779af761
md"""The object `u` is the symbolic function, and `u(x)` a symbolic expression involving a symbolic function.  This is what we will use to refer to `y`.
"""

# ╔═╡ 4bfc6518-5399-11ec-051f-bfe7ed5de662
md"""Assume $y$ is a function of $x$, called `u(x)`, this substitution is just a renaming:
"""

# ╔═╡ 4bfc6860-5399-11ec-3b92-9158c87dd902
ex1 = ex(y => u(x))

# ╔═╡ 4bfc6888-5399-11ec-2ab8-658263f96484
md"""At this point,  we differentiate both sides in `x`:
"""

# ╔═╡ 4bfc6a54-5399-11ec-3bc5-5f729ac08426
ex2 = diff(ex1, x)

# ╔═╡ 4bfc6a86-5399-11ec-189e-8d40c65957d9
md"""The next step is solve for $dy/dx$ - the lone answer to the linear equation - which is done as follows:
"""

# ╔═╡ 4bfc85ca-5399-11ec-243d-57851699c843
begin
	dydx = diff(u(x), x)
	ex3 = solve(ex2, dydx)[1]    # pull out lone answer with [1] indexing
end

# ╔═╡ 4bfc8606-5399-11ec-1d88-a77aa0919041
md"""As this represents an answer in terms of `u(x)`, we replace that term with the original variable:
"""

# ╔═╡ 4bfc89bc-5399-11ec-397b-070f53685ac2
dydx₁ = ex3(u(x) => y)

# ╔═╡ 4bfc89ee-5399-11ec-121e-cd00e614cc79
md"""If `x` and `y` are the variable names, this function will combine the steps above:
"""

# ╔═╡ 4bfc9576-5399-11ec-2690-5dbe42851116
function dy_dx(eqn, x, y)
  @syms u()
  eqn1 = eqn(y => u(x))
  eqn2 = solve(diff(eqn1, x), diff(u(x), x))[1]
  eqn2(u(x) => y)
end

# ╔═╡ 4bfc95ba-5399-11ec-2dc4-f3c90110402a
md"""Let $a = b = c = d = 1$, then $(1,4)$ is a point on the curve. We can draw a tangent line to this point with these commands:
"""

# ╔═╡ 4bfc9d08-5399-11ec-31d9-876caa98a760
begin
	H = ex(a=>1, b=>1, c=>1, d=>1)
	x0, y0 = 1, 4
	𝒎 = dydx₁(x=>1, y=>4, a=>1, b=>1, c=>1, d=>1)
	plot(Eq(lambdify(H), 0), xlims=(-5,5), ylims=(-5,5))
	plot!(y0 + 𝒎 * (x-x0))
end

# ╔═╡ 4bfc9d26-5399-11ec-2060-ab61e6fa724a
md"""Basically all the same steps as if done "by hand." Some effort could have been saved in plotting, had values for the parameters been substituted initially, but not doing so shows their dependence in the derivative.
"""

# ╔═╡ 4bfca064-5399-11ec-39c8-8b2861b4fb32
alert("The use of `lambdify` is needed to turn the symbolic expression, `H`, into a function, as `ImplicitEquations` expects functions in its predicates.")

# ╔═╡ 4bfca514-5399-11ec-1595-43969333635a
note("""

While `SymPy` itself has the `plot_implicit` function for plotting implicit equations,  this works only with `PyPlot`, not `Plots`, so we use the `ImplicitEquations` package in these examples.

""")

# ╔═╡ 4bfca53c-5399-11ec-2f1f-e79320bd08bc
md"""## Higher order derivatives
"""

# ╔═╡ 4bfca55a-5399-11ec-3365-4586d3eac812
md"""Implicit differentiation can be used to find $d^2y/dx^2$ or other higher-order derivatives. At each stage, the same technique is applied. The only "trick" is that some simplifications can be made.
"""

# ╔═╡ 4bfca582-5399-11ec-129b-d9e79071a0d7
md"""For example, consider $x^3 - y^3=3$. To find $d^2y/dx^2$, we first find $dy/dx$:
"""

# ╔═╡ 4bfca596-5399-11ec-3679-b9a7578c0bda
md"""```math
3x^2 - (3y^2 \frac{dy}{dx}) = 0.
```
"""

# ╔═╡ 4bfca5aa-5399-11ec-18f6-3152940e644e
md"""We could solve for $dy/dx$ at this point - it always appears as a linear factor - to get:
"""

# ╔═╡ 4bfca5c0-5399-11ec-1b7e-d7320a30e9da
md"""```math
\frac{dy}{dx} = \frac{3x^2}{3y^2} = \frac{x^2}{y^2}.
```
"""

# ╔═╡ 4bfca5c8-5399-11ec-1ea8-33f1e113429a
md"""However, we differentiate the first equation, as we generally try to avoid the quotient rule
"""

# ╔═╡ 4bfca5d2-5399-11ec-0f93-3fd18db2aaf5
md"""```math
6x - (6y \frac{dy}{dx} \cdot \frac{dy}{dx} + 3y^2 \frac{d^2y}{dx^2}) = 0.
```
"""

# ╔═╡ 4bfca5e6-5399-11ec-2311-7973f5ddd759
md"""Again, if must be that $d^2y/dx^2$ appears as a linear factor, so we can solve for it:
"""

# ╔═╡ 4bfca5fa-5399-11ec-0af7-cd605e3c930c
md"""```math
\frac{d^2y}{dx^2} = \frac{6x - 6y (\frac{dy}{dx})^2}{3y^2}.
```
"""

# ╔═╡ 4bfca604-5399-11ec-339e-478b981342e2
md"""One last substitution for $dy/dx$ gives:
"""

# ╔═╡ 4bfca618-5399-11ec-2ac7-5d69960f0580
md"""```math
\frac{d^2y}{dx^2} = \frac{-6x + 6y (\frac{x^2}{y^2})^2}{3y^2} = -2\frac{x}{y^2} + 2\frac{x^4}{y^5} = 2\frac{x}{y^2}(1 - \frac{x^3}{y^3}) = 2\frac{x}{y^5}(y^3 - x^3) = 2 \frac{x}{y^5}(-3).
```
"""

# ╔═╡ 4bfca62c-5399-11ec-3985-493919e9c851
md"""It isn't so pretty, but that's all it takes.
"""

# ╔═╡ 4bfca636-5399-11ec-0e6d-f9f729de8ffb
md"""To visualize, we plot implicitly and notice that:
"""

# ╔═╡ 4bfca7b2-5399-11ec-32b9-c397e7d1f00a
md"""  * as we change quadrants from the third to the fourth to the first the concavity changes from down to up to down, as the sign of the second derivative changes from negative to positive to negative;
  * and that at these inflection points, the "tangent" line is vertical when $y=0$ and flat when $x=0$.
"""

# ╔═╡ 4bfcac30-5399-11ec-2220-cdae5741804c
begin
	K(x,y) = x^3 - y^3
	plot(Eq(K, 3),  xlims=(-3, 3), ylims=(-3, 3))
end

# ╔═╡ 4bfcac6c-5399-11ec-190b-c78c948e178d
md"""The same problem can be done symbolically. The steps are similar, though the last step (replacing $x^3 - y^3$ with $3$) isn't done without explicitly asking.
"""

# ╔═╡ 4bfcb3cc-5399-11ec-056c-c79a3a3a6567
let
	@syms x y u()
	
	eqn    = K(x,y) - 3
	eqn1   = eqn(y => u(x))
	dydx   = solve(diff(eqn1,x), diff(u(x), x))[1]        # 1 solution
	d2ydx2 = solve(diff(eqn1, x, 2), diff(u(x),x, 2))[1]  # 1 solution
	eqn2   = d2ydx2(diff(u(x), x) => dydx, u(x) => y)
	simplify(eqn2)
end

# ╔═╡ 4bfcb414-5399-11ec-3ba1-ab619b8278f7
md"""## Inverse functions
"""

# ╔═╡ 4bfcb482-5399-11ec-2a07-17a29fa90b0e
md"""As [mentioned](../precalc/inversefunctions.html), an [inverse](http://en.wikipedia.org/wiki/Inverse_function) function for $f(x)$ is a function $g(x)$ satisfying: $y = f(x)$ if and only if $g(y) = x$ for all $x$ in the domain of $f$ and $y$ in the range of $f$.
"""

# ╔═╡ 4bfcb54a-5399-11ec-26d1-7b229d4e571d
md"""In short, both $f \circ g$ and $g \circ f$ are identify functions on their respective domains. As inverses are unique, their notation, $f^{-1}(x)$, reflects the name of the related function. function.
"""

# ╔═╡ 4bfcb55e-5399-11ec-2f97-eb54733e41d2
md"""The chain rule can be used to give the derivative of an inverse function when applied to $f(f^{-1}(x)) = x$. Solving gives, $[f^{-1}(x)]' = 1 / f'(g(x))$.
"""

# ╔═╡ 4bfcb572-5399-11ec-3377-c9994dbb635a
md"""This is great - if we can remember the rules. If not, sometimes implicit differentiation can also help.
"""

# ╔═╡ 4bfcb590-5399-11ec-1c78-c59d728728b6
md"""Consider the inverse function for the tangent, which exists when the domain of the tangent function is restricted to $(-\pi/2, \pi/2)$. The function solves $y = \tan^{-1}(x)$ or $\tan(y) = x$. Differentiating this yields:
"""

# ╔═╡ 4bfcb5ae-5399-11ec-0da0-cf84080f069e
md"""```math
\sec(y)^2 \frac{dy}{dx} = 1.
```
"""

# ╔═╡ 4bfcb5cc-5399-11ec-0588-03a351778665
md"""But $\sec(y)^2 = 1 + x^2$, as can be seen by right-triangle trigonometry. This yields the formula $dy/dx = [\tan^{-1}(x)]' = 1 / (1 + x^2)$.
"""

# ╔═╡ 4bfcb60a-5399-11ec-3329-17a96c3c5c33
md"""##### Example
"""

# ╔═╡ 4bfcb61c-5399-11ec-3a6f-3d70f0435a73
md"""For a more complicated example, suppose we have a moving trajectory $(x(t), y(t))$. The angle it makes with the origin satisfies
"""

# ╔═╡ 4bfcb63c-5399-11ec-20e4-d9f869951031
md"""```math
\tan(\theta(t)) = \frac{y(t)}{x(t)}.
```
"""

# ╔═╡ 4bfcb662-5399-11ec-2405-4148637f6854
md"""Suppose $\theta(t)$ can be defined in terms of the inverse to some function ($\tan^{-1}(x)$). We can differentiate implicitly to find $\theta'(t)$ in terms of derivatives of $y$ and $x$:
"""

# ╔═╡ 4bfcb676-5399-11ec-3efb-195f791b5c29
md"""```math
\sec^2(\theta(t)) \cdot \theta'(t) = \frac{y'(t) x(t) - y(t) x'(t)}{x(t))^2}.
```
"""

# ╔═╡ 4bfcb694-5399-11ec-3cd8-0de726cb8bad
md"""But $\sec^2(\theta(t)) = (r(t)/x(t))^2 = (x(t)^2 + y(t)^2) / x(t)^2$, so moving to the other side the secant term gives an explicit, albeit complicated, expression for the derivative of $\theta$ in terms of the functions $x$ and $y$:
"""

# ╔═╡ 4bfcb69c-5399-11ec-20e6-59240caef118
md"""```math
\theta'(t) = \frac{x^2}{x^2(t) + y^2(t)} \cdot \frac{y'(t) x(t) - y(t) x'(t)}{x(t))^2} = \frac{y'(t) x(t) - y(t) x'(t)}{x^2(t) + y^2(t)}.
```
"""

# ╔═╡ 4bfcb6b2-5399-11ec-3f5a-e3e6515d2946
md"""This could have been made easier, had we leveraged the result of the previous example.
"""

# ╔═╡ 4bfcb6c6-5399-11ec-12a4-91c794319194
md"""## Example from physics
"""

# ╔═╡ 4bfcb6ee-5399-11ec-261e-cd3d3453b51a
md"""Many problems are best done with implicit derivatives. A video showing such a problem along with how to do it analytically is [here](http://ocw.mit.edu/courses/mathematics/18-01sc-single-variable-calculus-fall-2010/unit-2-applications-of-differentiation/part-b-optimization-related-rates-and-newtons-method/session-32-ring-on-a-string/).
"""

# ╔═╡ 4bfcb700-5399-11ec-0c0e-f39e27265207
md"""This video starts with a simple question:
"""

# ╔═╡ 4bfcb7b6-5399-11ec-3942-b310b6940020
md"""> If you have a rope and heavy ring, where will the ring position itself due to gravity?

"""

# ╔═╡ 4bfcb7de-5399-11ec-069a-b17895020a82
md"""Well, suppose you hold the rope in two places, which we can take to be $(0,0)$ and $(a,b)$. Then let $(x,y)$ be all the possible positions of the ring that hold the rope taught. Then we have this picture:
"""

# ╔═╡ 4bfcbb78-5399-11ec-25d0-4f57793f4a93
let
	imgfile = "figures/extrema-ring-string.png"
	caption = "Ring on string figure."
	nothing
	#ImageFile(imgfile, caption)
end

# ╔═╡ 4bfebf3e-5399-11ec-2911-d5da2a201ac7
md"""![Ring on string figure.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/extrema-ring-string.png)
"""

# ╔═╡ 4bfebffc-5399-11ec-2f7d-299a2a6946c6
md"""Since the length of the rope does not change, we must have for any admissible $(x,y)$ that:
"""

# ╔═╡ 4bfec02e-5399-11ec-0351-13ef709eb9f3
md"""```math
L = \sqrt{x^2 + y^2} + \sqrt{(a-x)^2 + (b-y)^2},
```
"""

# ╔═╡ 4bfec042-5399-11ec-0758-e77017c918e5
md"""where these terms come from  the two hypotenuses in the figure, as computed through Pythagorean's theorem.
"""

# ╔═╡ 4bfec114-5399-11ec-16a1-15f90405b75f
md"""> If we assume that the ring will minimize the value of y subject to this constraint, can we solve for y?

"""

# ╔═╡ 4bfec11c-5399-11ec-36c6-b1ac65869d8d
md"""We create a function to represent the equation:
"""

# ╔═╡ 4bfecbd2-5399-11ec-082d-ab18109f7b58
F₀(x, y, a, b) = sqrt(x^2 + y^2) + sqrt((a-x)^2 + (b-y)^2)

# ╔═╡ 4bfecc0e-5399-11ec-2025-49a54a3b8e28
md"""To illustrate, we need specific values of $a$, $b$, and $L$:
"""

# ╔═╡ 4bfed208-5399-11ec-1ebc-a5ed0bd6f8e0
begin
	𝐚, 𝐛, 𝐋 = 3, 3, 10      # L > sqrt{a^2 + b^2}
	F₀(x, y) = F₀(x, y, 𝐚, 𝐛)
end

# ╔═╡ 4bfed230-5399-11ec-3638-cd1fb835e3d8
md"""Our values $(x,y)$ must satisfy $f(x,y) = L$. Let's graph:
"""

# ╔═╡ 4bfeeda6-5399-11ec-39bc-63ed7663dc52
plot(Eq(F₀, 𝐋), xlims=(-5, 7), ylims=(-5, 7))

# ╔═╡ 4bfeedce-5399-11ec-3442-851dd0d2efa0
md"""The graph is an ellipse, though slightly tilted.
"""

# ╔═╡ 4bfeee14-5399-11ec-3aae-c9df863318fc
md"""Okay, now to find the lowest point. This will be when the derivative is $0$. We solve by assuming $y$ is a function of $x$ called `u`. We have already defined symbolic variables `a`, `b`, `x`, and `y`, here we define `L`:
"""

# ╔═╡ 4bfeefea-5399-11ec-2178-8d7657144e28
@syms L

# ╔═╡ 4bfeeffe-5399-11ec-0aa7-ff0cfc15ae3e
md"""Then
"""

# ╔═╡ 4bfef24c-5399-11ec-24bf-7349d1171c62
eqn = F₀(x,y,a,b) - L

# ╔═╡ 4bfef72e-5399-11ec-1535-03f41094e63e
begin
	eqn_1 = diff(eqn(y => u(x)), x)
	eqn_2 = solve(eqn_1, diff(u(x), x))[1]
	dydx₂  = eqn_2(u(x) => y)
end

# ╔═╡ 4bfef760-5399-11ec-1cd7-1d17ef51fc52
md"""We are looking for when the tangent line has 0 slope, or when `dydx` is 0:
"""

# ╔═╡ 4bfef972-5399-11ec-20a8-753c7c2d0fb1
cps = solve(dydx₂, x)

# ╔═╡ 4bfef998-5399-11ec-32ca-9be98da8d378
md"""There are two answers, as we could guess from the graph, but we want the one for the smallest value of $y$, which is the second.
"""

# ╔═╡ 4bfef9ae-5399-11ec-220e-373854edbb71
md"""The values of dydx depend on any pair (x,y), but our solution must also satisfy the equation. That is for our value of x, we need to find the corresponding y. This should be possible by substituting:
"""

# ╔═╡ 4bfefce2-5399-11ec-1be8-7bc3037aa25d
eqn1 = eqn(x => cps[2])

# ╔═╡ 4bfefd28-5399-11ec-1914-03d3853ec86e
md"""We would try to solve `eqn1` for `y` with `solve(eqn1, y)`, but `SymPy` can't complete this problem. Instead, we will approach this numerically using `find_zero` from the `Roots` package. We make the above a function of `y` alone
"""

# ╔═╡ 4bff0386-5399-11ec-1a0f-93042a581cc4
begin
	eqn2 = eqn1(a=>3, b=>3, L=>10)
	ystar = find_zero(eqn2, -3)
end

# ╔═╡ 4bff03a4-5399-11ec-38ad-255851f3b1e3
md"""Okay, now we need to put this value back into our expression for the `x` value and also substitute in for the parameters:
"""

# ╔═╡ 4bff0aa2-5399-11ec-3a33-a3ec1c6798ca
xstar = N(cps[2](y => ystar, a =>3, b => 3, L => 3))

# ╔═╡ 4bff0aca-5399-11ec-1d34-057acdb67f99
md"""Our minimum is at `(xstar, ystar)`, as this graphic shows:
"""

# ╔═╡ 4bff0f82-5399-11ec-160f-f7648352c45b
begin
	tl(x) = ystar + 0 * (x- xstar)
	plot(Eq((x,y) -> F₀(x,y,3,3), 10), xlims=(-4, 7), ylims=(-10, 10))
	plot!(tl)
end

# ╔═╡ 4bff0fa2-5399-11ec-0130-ab88957509eb
md"""If you watch the video linked to above, you will see that the surprising fact here is the resting point is such that the angles formed by the rope are the same. Basically this makes the tension in both parts of the rope equal, so there is a static position (if not static, the ring would move and not end in the final position). We can verify this fact numerically by showing the arctangents of the two triangles are the same up to a sign (and slight round-off error):
"""

# ╔═╡ 4bff13b2-5399-11ec-3da7-314cab086a14
begin
	a0, b0 = 0,0   # the foci of the ellipse are (0,0) and (3,3)
	a1, b1 = 3, 3
	atan((b0 - ystar)/(a0 - xstar)) + atan((b1 - ystar)/(a1 - xstar)) # 0
end

# ╔═╡ 4bff13da-5399-11ec-0451-8556eb66b98f
md"""Now, were we lucky and just happened to take $a=3$, $b = 3$ in such a way to make this work? Well, no. But convince yourself by doing the above for different values of $b$.
"""

# ╔═╡ 4bff1416-5399-11ec-1347-2bf45371892e
md"""### Numeric approach
"""

# ╔═╡ 4bff143e-5399-11ec-1350-c31747131f48
md"""In the above, we started with $F(x,y) = L$ and solved symbolically for $y=f(x)$ so that $F(x,f(x)) = L$. Then we took a derivative of $f(x)$ and set this equal to $0$ to solve for the minimum $y$ values.
"""

# ╔═╡ 4bff1452-5399-11ec-008b-9561a397a8db
md"""Here we try the same problem numerically, using a zero-finding approach to identify $f(x))$.
"""

# ╔═╡ 4bff1470-5399-11ec-2a39-9d355d186ed4
md"""Starting with $F(x,y) = sqrt(x^2 + y^2) + sqrt((x-1)^2 + (b-2)^2)$ and $L=3$, we have:
"""

# ╔═╡ 4bff18e4-5399-11ec-225b-61e9a7c7f756
begin
	F₁(x,y) = F₀(x,y, 1, 2) # a,b,L = 1,2,3
	plot(Eq(F₁, 3))
end

# ╔═╡ 4bff1902-5399-11ec-076f-8dbbba24cf2d
md"""Trying to find the lowest $y$ value we have from the graph it is near $x=0.1$. We can do better.
"""

# ╔═╡ 4bff1920-5399-11ec-06a6-bfed37a2e520
md"""First, we could try so solve for the $f$ using `find_zero`. Here is one way:
"""

# ╔═╡ 4bff1d76-5399-11ec-3746-0f5216f1f955
f₀(x) = find_zero(y -> F₁(x, y) - 3, 0)

# ╔═╡ 4bff1db2-5399-11ec-2ada-298cb0eeee15
md"""We use $0$ as an initial guess, as the $y$ value is near $0$. More on this later. We could then just sample many $x$ values between $-0.5$ and $1.5$ and find the one corresponding to the smallest $t$ value:
"""

# ╔═╡ 4bff23de-5399-11ec-34c7-7f298b0e5290
findmin([f₀(x) for x ∈ range(-0.5, 1.5, length=100)])

# ╔═╡ 4bff2424-5399-11ec-0277-3f45fdf35020
md"""This shows the smallest value is around $-0.414$ and occurs in the $33$rd position of the sampled $x$ values. Pretty good, but we can do better. We just need to differentiate $f$, solve for $f'(x) = 0$ and then put that value back into $f$ to find the smallest $y$.
"""

# ╔═╡ 4bff2492-5399-11ec-1f57-ef803a047898
md"""**However** there is one subtle point. Using automatic differentiation, as implemented in `ForwardDiff`, with `find_zero` requires the `x0` initial value to have a certain type. In this case, the same type as the "`x`" passed into $f(x)$. So rather than use an initial value of $0$, we must use an initial value $zero(x)$! (Otherwise, there will be an error "`no method matching Float64(::ForwardDiff.Dual{...`".)
"""

# ╔═╡ 4bff249c-5399-11ec-0764-7f4c87b3a4a4
md"""With this slight modification, we have:
"""

# ╔═╡ 4bff2a5a-5399-11ec-2110-b54089173ef1
begin
	f₁(x) = find_zero(y -> F₁(x, y) - 3, zero(x))
	plot(f₁', -0.5, 1.5)
end

# ╔═╡ 4bff2a8c-5399-11ec-3113-23f044344e06
md"""The zero of `f'` is a bit to the right of $0$, say $0.2$; we use `find_zero` again to find it:
"""

# ╔═╡ 4bff2eb2-5399-11ec-111e-537e606812d5
begin
	xstar₁ = find_zero(f₁', 0.2)
	xstar₁, f₁(xstar₁)
end

# ╔═╡ 4bff2ef6-5399-11ec-1446-c1032b9ed7d4
md"""It is important to note that the above uses of `find_zero` required *good* initial guesses, which we were fortunate enough to identify.
"""

# ╔═╡ 4bff2f12-5399-11ec-0014-67e868e032ef
md"""## Questions
"""

# ╔═╡ 4bff2f96-5399-11ec-2935-493e9f06a236
md"""###### Question
"""

# ╔═╡ 4bff2fb6-5399-11ec-27f7-8551e136c0f9
md"""Is $(1,1)$ on the graph of
"""

# ╔═╡ 4bff2fdc-5399-11ec-2a42-475843efdfba
md"""```math
x^2 - 2xy + y^2 = 1?
```
"""

# ╔═╡ 4bff33b0-5399-11ec-21c5-1571c3f09c50
let
	x,y=1,1
	yesnoq(x^2 - 2x*y + y^2 ==1)
end

# ╔═╡ 4bff33c4-5399-11ec-16a8-b503b4662988
md"""###### Question
"""

# ╔═╡ 4bff33d8-5399-11ec-0271-c3a6e2e6c714
md"""For the equation
"""

# ╔═╡ 4bff33e2-5399-11ec-0492-e71ccda4efa0
md"""```math
x^2y + 2y - 4 x = 0,
```
"""

# ╔═╡ 4bff340a-5399-11ec-28a2-d53600106d59
md"""if $x=4$, what is a value for $y$ such that $(x,y)$ is a point on the graph of the equation?
"""

# ╔═╡ 4bff372a-5399-11ec-21fd-cd4cc1ed984c
let
	@syms x y
	eqn = x^2*y + 2y - 4x
	val = float(N(solve(subs(eqn, (x,4)), y)[1]))
	numericq(val)
end

# ╔═╡ 4bff373e-5399-11ec-24b8-c372b94882ff
md"""###### Question
"""

# ╔═╡ 4bff3750-5399-11ec-2287-291763f0cdcb
md"""For the equation
"""

# ╔═╡ 4bff3766-5399-11ec-2a4c-570f1ab87ae2
md"""```math
(y-5)\cdot \cos(4\cdot \sqrt{(x-4)^2 + y^2)} =  x\cdot\sin(2\sqrt{x^2 + y^2})
```
"""

# ╔═╡ 4bff377a-5399-11ec-232e-71c9d5f61f86
md"""is the point $(5,0)$ a solution?
"""

# ╔═╡ 4bff3914-5399-11ec-2fce-095f0a9d1426
let
	yesnoq(false)
end

# ╔═╡ 4bff3950-5399-11ec-12b9-15dd4755b252
md"""##### Question
"""

# ╔═╡ 4bff396e-5399-11ec-08e7-b5774bc54469
md"""Let $(x/3)^2 + (y/2)^2 = 1$. Find the slope of the tangent line at the point $(3/\sqrt{2}, 2/\sqrt{2})$.
"""

# ╔═╡ 4bff3d06-5399-11ec-16b9-f1c4462e8e4d
let
	@syms x y u()
	eqn = (x/3)^2 + (y/2)^2 - 1
	dydx = SymPy.solve(SymPy.diff(SymPy.subs(eqn, y, u(x)), x), SymPy.diff(u(x), x))[1]
	val = float(SymPy.N(SymPy.subs(dydx, (u(x), y), (x, 3/sqrt(2)), (y, 2/sqrt(2)))))
	numericq(val)
end

# ╔═╡ 4bff3d24-5399-11ec-2e5f-db61dbef80fe
md"""###### Question
"""

# ╔═╡ 4bff3d56-5399-11ec-0469-b1301d1ee220
md"""The [lame](http://www-history.mcs.st-and.ac.uk/Curves/Lame.html) curves satisfy:
"""

# ╔═╡ 4bff3d6a-5399-11ec-3148-7bc7f82a9781
md"""```math
\left(\frac{x}{a}\right)^n + \left(\frac{y}{b}\right)^n = 1.
```
"""

# ╔═╡ 4bff3d94-5399-11ec-10cb-8b9b38cb5606
md"""An ellipse is when $n=1$. Take $n=3$, $a=1$, and $b=2$.
"""

# ╔═╡ 4bff3dc6-5399-11ec-2678-91ea76e1ff1b
md"""Find a *positive* value of $y$ when $x=1/2$.
"""

# ╔═╡ 4bff4292-5399-11ec-069b-27fc539a9575
let
	a,b,n=1,2,3
	val = b*(1 - ((1/2)/a)^n)^(1/n)
	numericq(val)
end

# ╔═╡ 4bff42b0-5399-11ec-214f-c1db3ddfa968
md"""What expression gives $dy/dx$?
"""

# ╔═╡ 4bff47f6-5399-11ec-136c-63af9d4eeec0
let
	choices = [
	"`` -(y/x) \\cdot (x/a)^n \\cdot (y/b)^{-n}``",
	"``b \\cdot (1 - (x/a)^n)^{1/n}``",
	"``-(x/a)^n / (y/b)^n``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4bff4814-5399-11ec-3974-09f0db42084c
md"""###### Question
"""

# ╔═╡ 4bff483c-5399-11ec-2dd9-db3d90348eab
md"""Let $y - x^2 = -\log(x)$. At the point $(1/2, 0.9431...)$, the graph has a tangent line. Find this line, then find its intersection point with the $y$ axes.
"""

# ╔═╡ 4bff4846-5399-11ec-2c74-d92c431fd909
md"""This intersection is:
"""

# ╔═╡ 4bff4cb0-5399-11ec-0f97-9b723cc1bb84
let
	f(x) = x^2 - log(x)
	x0 = 1/2
	tl(x) = f(x0) + f'(x0) * (x - x0)
	numericq(tl(0))
end

# ╔═╡ 4bff4cce-5399-11ec-2dbb-37f6dad19902
md"""###### Question
"""

# ╔═╡ 4bff4d28-5399-11ec-2d09-65264d2009eb
md"""The [witch](http://www-history.mcs.st-and.ac.uk/Curves/Witch.html) of [Agnesi](http://www.maa.org/publications/periodicals/convergence/mathematical-treasures-maria-agnesis-analytical-institutions) is the curve given by the equation
"""

# ╔═╡ 4bff4d3a-5399-11ec-2d58-75a6329b4448
md"""```math
y(x^2 + a^2) = a^3.
```
"""

# ╔═╡ 4bff4d5a-5399-11ec-0514-55dcfeae10dd
md"""If $a=1$, numerically find a a value of $y$ when $x=2$.
"""

# ╔═╡ 4bff5034-5399-11ec-27b6-f7e6acfbc0aa
let
	a = 1
	f(x,y) = y*(x^2 + a^2) - a^3
	val = find_zero(y->f(2,y), 1)
	numericq(val)
end

# ╔═╡ 4bff5052-5399-11ec-224f-f78bfde234b2
md"""What expression yields $dy/dx$ for this curve:
"""

# ╔═╡ 4bff550c-5399-11ec-0f7d-570d153a2d6c
let
	choices = [
	"``-2xy/(x^2 + a^2)``",
	"``2xy / (x^2 + a^2)``",
	"``a^3/(x^2 + a^2)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4bff552a-5399-11ec-0683-db4bd26b5f3d
md"""###### Question
"""

# ╔═╡ 4bff5868-5399-11ec-29db-416b44f06e79
let
	### {{{lhopital_35}}}
	imgfile = "figures/fcarc-may2016-fig35-350.gif"
	caption = raw"""
	Image number 35 from L'Hospitals calculus book (the first). Given a description of the curve, identify the point ``E`` which maximizes the height.
	"""
	nothing
	#ImageFile(imgfile, caption)
end

# ╔═╡ 4bff5890-5399-11ec-0085-ab49655dd350
md"""![Image number 35 from L'Hospitals calculus book (the first). Given a description of the curve, identify the point ``E`` which maximizes the height.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/fcarc-may2016-fig35-350.gif)
"""

# ╔═╡ 4bff58cc-5399-11ec-3c02-a71d8dac0f93
md"""The figure above shows a problem appearing in L'Hospital's first calculus book. Given a function defined implicitly by $x^3 + y^3 = axy$  (with $AP=x$, $AM=y$ and $AB=a$) find the point $E$ that maximizes the height. In the [AMS feature column](http://www.ams.org/samplings/feature-column/fc-2016-05) this problem is illustrated and solved in the historical manner, with the comment that the concept of implicit differentiation wouldn't have occurred to L'Hospital.
"""

# ╔═╡ 4bff58e0-5399-11ec-3c6d-ff78a81fe549
md"""Using Implicit differentiation, find when $dy/dx = 0$.
"""

# ╔═╡ 4bff5dfe-5399-11ec-0c00-310c08db9419
let
	choices = ["``y^2 = 3x/a``", "``y=3x^2/a``", "``y=a/(3x^2)``", "``y^2=a/(3x)``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 4bff5e26-5399-11ec-35b3-571f3b883d21
md"""Substituting the correct value of $y$, above, into the defining equation gives what value for $x$:
"""

# ╔═╡ 4bff63da-5399-11ec-0409-af6c13df04a7
let
	choices=[
	"``x=(1/2) a 2^{1/2}``",
	"``x=(1/3) a 2^{1/3}``",
	"``x=(1/2) a^3 3^{1/3}``",
	"``x=(1/3) a^2 2^{1/2}``"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 4bff63fa-5399-11ec-38d9-9b3ad927dd3b
md"""###### Question
"""

# ╔═╡ 4bff6402-5399-11ec-247c-e1a11240e289
md"""For the equation of an ellipse:
"""

# ╔═╡ 4bff6416-5399-11ec-0fe6-994dabb4ec73
md"""```math
\left(\frac{x}{a}\right)^2 + \left(\frac{y}{b}\right)^2 = 1,
```
"""

# ╔═╡ 4bff6434-5399-11ec-3aad-2d8e32aa1d36
md"""compute $d^2y/dx^2$. Is this the answer?
"""

# ╔═╡ 4bff643e-5399-11ec-21f1-ef73204986c7
md"""```math
\frac{d^2y}{dx^2} = -\frac{b^2}{a^2\cdot y} - \frac{b^4\cdot x^2}{a^4\cdot y^3} = -\frac{1}{y}\frac{b^2}{a^2}(1 + \frac{b^2 x^2}{a^2 y^2}).
```
"""

# ╔═╡ 4bff65d8-5399-11ec-1180-b9acd8999ce9
let
	yesnoq(true)
end

# ╔═╡ 4bff65f4-5399-11ec-2c28-27f600bd159e
md"""If $y>0$ is the sign positive or negative?
"""

# ╔═╡ 4bff6a42-5399-11ec-02f5-c54823c9383b
let
	choices = ["positive", "negative", "Can be both"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 4bff6a6a-5399-11ec-0377-1b919a74b645
md"""If $x>0$ is the sign positive or negative?
"""

# ╔═╡ 4bff6eac-5399-11ec-3c78-9b92e6f9a0f3
let
	choices = ["positive", "negative", "Can be both"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 4bff6eca-5399-11ec-0286-bd94887b3880
md"""When $x>0$, the graph of the equation is...
"""

# ╔═╡ 4bff7340-5399-11ec-1c6d-5de8f85a04f5
let
	choices = ["concave up", "concave down", "both concave up and down"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 4bff884c-5399-11ec-35a6-01f1220fd083
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/lhospitals_rule.html">◅ previous</a>  <a href="../derivatives/related_rates.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/implicit_differentiation.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 4bff8854-5399-11ec-18d9-996cd9903a83
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
ImplicitEquations = "95701278-4526-5785-aba3-513cca398f19"
IntervalArithmetic = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
IntervalConstraintProgramming = "138f1668-1576-5ad7-91b9-7425abbf3153"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.9"
ImplicitEquations = "~1.0.6"
IntervalArithmetic = "~0.17.8"
IntervalConstraintProgramming = "~0.12.4"
LaTeXStrings = "~1.3.0"
Plots = "~1.23.6"
PlutoUI = "~0.7.1"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
SymPy = "~1.0.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractAlgebra]]
deps = ["InteractiveUtils", "LinearAlgebra", "Markdown", "Random", "RandomExtensions", "SparseArrays", "Test"]
git-tree-sha1 = "8a53c65dbc0423738c855abc42ea0c925ea1608b"
uuid = "c3fe647b-3220-5bb0-a1ea-a7954cac585d"
version = "0.11.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "f87e559f87a45bece9c9ed97458d3afe98b1ebb9"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.1.0"

[[ArrayInterface]]
deps = ["LinearAlgebra", "Requires", "SparseArrays"]
git-tree-sha1 = "a2a1884863704e0414f6f164a1f6f4a2a62faf4e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "2.14.17"

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
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "3c9862a8d41ccc11469024b1fe191223f8f8c6b4"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.9"

[[CanonicalTraits]]
deps = ["MLStyle"]
git-tree-sha1 = "f959d0e7164fb0262b02abecb93cf42b9a9f3188"
uuid = "a603d957-0e48-4f86-8fbd-0b7bc66df689"
version = "0.2.4"

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

[[DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DataStructures", "DocStringExtensions", "FastBroadcast", "FunctionWrappers", "IterativeSolvers", "LabelledArrays", "LinearAlgebra", "Logging", "MuladdMacro", "NonlinearSolve", "Parameters", "Printf", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "Setfield", "SparseArrays", "StaticArrays", "Statistics", "SuiteSparse", "ZygoteRules"]
git-tree-sha1 = "9d312bb0b7c8ace440a71c64330cf1bea0ade0c8"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.70.0"

[[DiffEqJump]]
deps = ["ArrayInterface", "Compat", "DataStructures", "DiffEqBase", "FunctionWrappers", "LightGraphs", "LinearAlgebra", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "d2d9a628b9659a3107c95b0a61ca93865794245a"
uuid = "c894b116-72e5-5b58-be3c-e6d8d4ac2b12"
version = "6.15.1"

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
git-tree-sha1 = "18ee049accec8763be17a933737c1dd0fdf8673a"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.0.0"

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

[[FastBroadcast]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "26be48918640ce002f5833e8fc537b2ba7ed0234"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.1.8"

[[FastRounding]]
deps = ["ErrorfreeArithmetic", "Test"]
git-tree-sha1 = "224175e213fd4fe112db3eea05d66b308dc2bf6b"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.2.0"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "8b3c09b56acaf3c0e581c66638b85c8650ee9dca"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.8.1"

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

[[FunctionWrappers]]
git-tree-sha1 = "241552bc2209f0fa068b6415b1942cc0aa486bcc"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

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

[[GeneralizedGenerated]]
deps = ["CanonicalTraits", "DataStructures", "JuliaVariables", "MLStyle"]
git-tree-sha1 = "7dd404baf79b28f117917633f0cc1d2976c1fd9f"
uuid = "6b9d7cbe-bcb9-11e9-073f-15a7a543e2eb"
version = "0.2.8"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "4136b8a5668341e58398bb472754bff4ba0456ff"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.3.12"

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

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[ImplicitEquations]]
deps = ["CommonEq", "IntervalArithmetic", "RecipesBase", "Test", "Unicode"]
git-tree-sha1 = "cf1660b41894f07d06580ac528a7f580c480c909"
uuid = "95701278-4526-5785-aba3-513cca398f19"
version = "1.0.6"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

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
git-tree-sha1 = "00cce14aeb4b256f2f57caf3f3b9354c27d93259"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.17.8"

[[IntervalConstraintProgramming]]
deps = ["IntervalArithmetic", "IntervalContractors", "IntervalRootFinding", "MacroTools", "ModelingToolkit"]
git-tree-sha1 = "c39742767b9ba904966e336b4f1795320b05c374"
uuid = "138f1668-1576-5ad7-91b9-7425abbf3153"
version = "0.12.4"

[[IntervalContractors]]
deps = ["IntervalArithmetic"]
git-tree-sha1 = "02e049c761e7fd911566c6b0eff9deffe7de876b"
uuid = "15111844-de3b-5229-b4ba-526f2f385dc9"
version = "0.4.5"

[[IntervalRootFinding]]
deps = ["ForwardDiff", "IntervalArithmetic", "LinearAlgebra", "Polynomials", "StaticArrays"]
git-tree-sha1 = "2b3c1cbe892ceb2f3936fd734c1c98ea97dfb18e"
uuid = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
version = "0.5.7"

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

[[IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

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

[[JuliaVariables]]
deps = ["MLStyle", "NameResolution"]
git-tree-sha1 = "49fb3cb53362ddadb4415e9b73926d6b40709e70"
uuid = "b14d175d-62b4-44ba-8fb7-3064adc8c3ec"
version = "0.2.4"

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

[[LabelledArrays]]
deps = ["ArrayInterface", "ChainRulesCore", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "3609bbf5feba7b22fb35fe7cb207c8c8d2e2fc5b"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.6.7"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "7c72983c6daf61393ee8a0b29a419c709a06cede"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.14.12"

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

[[LightGraphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "432428df5f360964040ed60418dd5601ecd240b6"
uuid = "093fc24a-ae57-5d10-9952-331d41423f4d"
version = "1.3.5"

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

[[MLStyle]]
git-tree-sha1 = "594e189325f66e23a8818e5beb11c43bb0141bcd"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.10"

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

[[ModelingToolkit]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqJump", "DiffRules", "Distributed", "DocStringExtensions", "GeneralizedGenerated", "IfElse", "LabelledArrays", "Latexify", "Libdl", "LightGraphs", "LinearAlgebra", "MacroTools", "NaNMath", "RecursiveArrayTools", "Requires", "SafeTestsets", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TreeViews", "UnPack", "Unitful"]
git-tree-sha1 = "c5bbf9990d0be177c3edeab96eb7551ad07c9553"
uuid = "961ee093-0014-501f-94e3-6117800e7a78"
version = "3.21.0"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MuladdMacro]]
git-tree-sha1 = "c6190f9a7fc5d9d5915ab29f2134421b12d24a68"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.2"

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

[[NameResolution]]
deps = ["PrettyPrint"]
git-tree-sha1 = "1a0fa0e9613f46c9b8c11eee38ebb4f590013c5e"
uuid = "71a1bf82-56d0-4bbc-8a3c-48b961074391"
version = "0.1.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[NonlinearSolve]]
deps = ["ArrayInterface", "FiniteDiff", "ForwardDiff", "IterativeSolvers", "LinearAlgebra", "RecursiveArrayTools", "RecursiveFactorization", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "UnPack"]
git-tree-sha1 = "e9ffc92217b8709e0cf7b8808f6223a4a0936c95"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "0.3.11"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

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

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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
git-tree-sha1 = "0d185e8c33401084cab546a756b387b15f76720c"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.23.6"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "Logging", "Markdown", "Random", "Suppressor"]
git-tree-sha1 = "45ce174d36d3931cd4e37a47f93e07d1455f038d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.1"

[[PoissonRandom]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "44d018211a56626288b5d3f8c6497d28c26dc850"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.0"

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

[[PrettyPrint]]
git-tree-sha1 = "632eb4abab3449ab30c5e1afaa874f0b98b586e4"
uuid = "8162dcfd-2161-5ef2-ae6c-7681170c5f98"
version = "0.2.0"

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

[[RandomExtensions]]
deps = ["Random", "SparseArrays"]
git-tree-sha1 = "062986376ce6d394b23d5d90f01d81426113a3c9"
uuid = "fb686558-2515-59ef-acaa-46db3789a887"
version = "0.4.3"

[[RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[RecursiveArrayTools]]
deps = ["ArrayInterface", "ChainRulesCore", "DocStringExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "00bede2eb099dcc1ddc3f9ec02180c326b420ee2"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.17.2"

[[RecursiveFactorization]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6761a5d1f9646affb2a369ff932841fff77934a3"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.1.0"

[[Reexport]]
deps = ["Pkg"]
git-tree-sha1 = "7b1d07f411bc8ddb7977ec7f377b97b158514fe0"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "0.2.0"

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

[[SafeTestsets]]
deps = ["Test"]
git-tree-sha1 = "36ebc5622c82eb9324005cc75e7e2cc51181d181"
uuid = "1bc83da4-3b8d-516f-aca4-4fe02f6d838f"
version = "0.0.1"

[[SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "b3d23aa4e5f621b574b3b0d41c62c8624d27192a"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.19.5"

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
git-tree-sha1 = "fca29e68c5062722b5b4435594c3d1ba557072a3"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.7.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

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
deps = ["OpenSpecFun_jll"]
git-tree-sha1 = "d8d8b8a9f4119829410ecd706da4cc8594a1e020"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "0.10.3"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "da4cf579416c81994afd6322365d00916c79b8ae"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "0.12.5"

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
deps = ["Adapt", "DataAPI", "Tables"]
git-tree-sha1 = "44b3afd37b17422a62aea25f04c1f7e09ce6b07f"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.5.1"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[SymPy]]
deps = ["CommonEq", "CommonSolve", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "1ef257ecbcab8058595a68ca36a6844b41babcbd"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.0.52"

[[SymbolicUtils]]
deps = ["AbstractAlgebra", "Combinatorics", "DataStructures", "NaNMath", "SpecialFunctions", "TimerOutputs"]
git-tree-sha1 = "cd230ab5f02844155415aad28e8474fe459fe366"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.5.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

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

[[TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "7cb456f358e8f9d102a8b25e8dfedf58fa5689bc"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.13"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "0992ed0c3ef66b0390e5752fe60054e5ff93b908"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.9.2"

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

[[ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "8c1a8e4dfacb1fd631745552c8db35d0deb09ea0"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.2"

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
# ╟─4bff87f0-5399-11ec-3887-b1a538e7094f
# ╟─4bf9d172-5399-11ec-198a-93f5e3a98e3e
# ╟─4bf9d1ae-5399-11ec-09fb-4df481d99e2e
# ╠═4bf9d8a4-5399-11ec-24a2-8bf5aa574d19
# ╟─4bf9dba2-5399-11ec-3db8-894baebf6e4c
# ╟─4bf9dbf4-5399-11ec-3ece-25ef1c21023e
# ╟─4bf9dc94-5399-11ec-1fef-37281a2f643a
# ╟─4bf9dcbc-5399-11ec-34b7-01b4c18fa0f5
# ╟─4bf9dcd0-5399-11ec-0134-27caa97d4153
# ╟─4bf9dd20-5399-11ec-3581-11a1861d085b
# ╟─4bf9dd52-5399-11ec-2075-af5de62b035a
# ╟─4bf9dd70-5399-11ec-1395-3be34ccdfab1
# ╠═4bf9e1da-5399-11ec-1895-2d86895efb51
# ╟─4bfa04e4-5399-11ec-1e95-43dedf7927a2
# ╟─4bfa057c-5399-11ec-3c62-f9fdc2303303
# ╠═4bfa0c3c-5399-11ec-3b48-cda7dbf4b956
# ╟─4bfa1498-5399-11ec-08f5-6da1a89d157f
# ╟─4bfa14c2-5399-11ec-01b0-61f07a891d34
# ╠═4bfa160a-5399-11ec-06ed-c7843a251e6b
# ╟─4bfa165c-5399-11ec-0678-37e0d56aa5b7
# ╟─4bfa1696-5399-11ec-216c-338fef5ae41e
# ╟─4bfa16d2-5399-11ec-231d-b3cbe8355347
# ╠═4bfa1b0a-5399-11ec-08a3-cd8a9bd1009e
# ╟─4bfa28e8-5399-11ec-272b-251b1c367838
# ╟─4bfa292e-5399-11ec-2d26-a9f82573ab29
# ╟─4bfa2956-5399-11ec-27c2-2dd058eb51c7
# ╟─4bfa2976-5399-11ec-2852-512c50b5dab3
# ╠═4bfa2e40-5399-11ec-2207-4d0c8c43d024
# ╟─4bfa2e56-5399-11ec-2f2a-a5bc62a87bd4
# ╟─4bfa2e7e-5399-11ec-0009-39e7adc78b6c
# ╠═4bfa3338-5399-11ec-220b-fbdebfff5868
# ╠═4bfa35a4-5399-11ec-1043-5b65e2cb533f
# ╟─4bfa35ba-5399-11ec-0848-493cda3359bf
# ╠═4bfa37c0-5399-11ec-3b45-e5887b4df6f0
# ╟─4bfa37de-5399-11ec-0b3d-852237b73ec8
# ╟─4bfa3824-5399-11ec-2fa2-411e6970244a
# ╟─4bfa3842-5399-11ec-205e-e187e682e53b
# ╟─4bfa388a-5399-11ec-133b-49dc3a7a2ab3
# ╟─4bfa38a6-5399-11ec-3ff4-7324e21f338a
# ╟─4bfa38c4-5399-11ec-1cab-7945b3d88d1f
# ╟─4bfa38d8-5399-11ec-2863-c5c144931a44
# ╟─4bfa38ea-5399-11ec-2bdd-a9d27685287c
# ╟─4bfa390a-5399-11ec-345f-0b338ff98dfa
# ╟─4bfa391c-5399-11ec-1925-5b1b0da1aa0a
# ╟─4bfa3932-5399-11ec-2062-9597eea97dbb
# ╟─4bfa395a-5399-11ec-1707-8de0bcc62ca2
# ╟─4bfa3996-5399-11ec-0339-0d4c27cc2437
# ╟─4bfa39d2-5399-11ec-2b6d-0de1d4c40eba
# ╟─4bfa39fa-5399-11ec-1117-4d8b39834085
# ╟─4bfa3a04-5399-11ec-386a-adba595bf7d8
# ╟─4bfa3a18-5399-11ec-01db-25f0836277a1
# ╠═4bfa3eb4-5399-11ec-0321-bd7a86d0a97a
# ╟─4bfa3ee6-5399-11ec-371b-8382f444390b
# ╟─4bfa3efa-5399-11ec-01cc-f71edbe1a9d3
# ╟─4bfa3f04-5399-11ec-00b4-874d5f1e1703
# ╟─4bfa3f18-5399-11ec-2a72-c7ca639978a7
# ╟─4bfa3f2e-5399-11ec-08c0-bf3f4e6bfedd
# ╟─4bfa3f54-5399-11ec-336d-e1d46c06b9f7
# ╟─4bfa3f7c-5399-11ec-1bd9-c7c858348670
# ╟─4bfa3f8e-5399-11ec-2962-a58746609417
# ╟─4bfa3fa4-5399-11ec-07d9-d9167abfdcc5
# ╠═4bfa43d2-5399-11ec-250f-d9e9838e2b79
# ╟─4bfa43f8-5399-11ec-0870-075ec14eefad
# ╟─4bfa440e-5399-11ec-040b-dd650efc42ed
# ╟─4bfa44c2-5399-11ec-1c24-55aa9ad93dcb
# ╟─4bfa44ce-5399-11ec-2fb5-1f1b947a276f
# ╟─4bfa4508-5399-11ec-0bc6-23740f4785a4
# ╟─4bfa451c-5399-11ec-0ec1-4be3dbd7df94
# ╟─4bfa453a-5399-11ec-0b41-4b79b064ae89
# ╟─4bfa4544-5399-11ec-2c24-49888212310e
# ╟─4bfa4558-5399-11ec-338a-51b7b83810a3
# ╟─4bfa456c-5399-11ec-2f84-212c3767a07c
# ╟─4bfa4580-5399-11ec-1720-5122b46a08fc
# ╟─4bfa4592-5399-11ec-2b4b-957ae0b9ff42
# ╟─4bfa4c60-5399-11ec-027b-971235f0fd47
# ╟─4bfa4c7e-5399-11ec-0f9e-bb89d849e819
# ╟─4bfa4c92-5399-11ec-00c5-f9c31cb84037
# ╟─4bfa4d96-5399-11ec-39e0-9d275ece1ecd
# ╠═4bfa543a-5399-11ec-18cd-21838feaf233
# ╟─4bfa546c-5399-11ec-1331-75a245420dc0
# ╟─4bfa5480-5399-11ec-33fb-855c9e9221f2
# ╟─4bfa54bc-5399-11ec-1a44-b7874e0d384d
# ╟─4bfa54da-5399-11ec-3d79-a54ed09117bc
# ╟─4bfa54e4-5399-11ec-0113-49e4ce595513
# ╟─4bfa54f8-5399-11ec-2832-4d1274025c77
# ╠═4bfa5804-5399-11ec-2a44-33e6fdb61920
# ╟─4bfa582c-5399-11ec-1eba-c3d0df9e9307
# ╠═4bfa5d72-5399-11ec-376b-270f36e2eafb
# ╟─4bfa5d90-5399-11ec-2fa7-0fc047905887
# ╠═4bfa5f98-5399-11ec-313e-e9d37aa79381
# ╟─4bfa5fb6-5399-11ec-348e-0ba1b17af354
# ╟─4bfa5fca-5399-11ec-186e-9381f696a3c4
# ╟─4bfc3ea8-5399-11ec-2040-ffe49d4c9946
# ╟─4bfc3f32-5399-11ec-0332-cf446db91742
# ╟─4bfc3f70-5399-11ec-335b-2373055e580e
# ╟─4bfc3f8e-5399-11ec-124d-116ae97351a9
# ╠═4bfc61a8-5399-11ec-198c-f1a261c14e81
# ╟─4bfc6216-5399-11ec-1a97-dbbc9ddcbab7
# ╠═4bfc6494-5399-11ec-002b-bbdf456bc200
# ╟─4bfc64d2-5399-11ec-1ce0-015b779af761
# ╟─4bfc6518-5399-11ec-051f-bfe7ed5de662
# ╠═4bfc6860-5399-11ec-3b92-9158c87dd902
# ╟─4bfc6888-5399-11ec-2ab8-658263f96484
# ╠═4bfc6a54-5399-11ec-3bc5-5f729ac08426
# ╟─4bfc6a86-5399-11ec-189e-8d40c65957d9
# ╠═4bfc85ca-5399-11ec-243d-57851699c843
# ╟─4bfc8606-5399-11ec-1d88-a77aa0919041
# ╠═4bfc89bc-5399-11ec-397b-070f53685ac2
# ╟─4bfc89ee-5399-11ec-121e-cd00e614cc79
# ╠═4bfc9576-5399-11ec-2690-5dbe42851116
# ╟─4bfc95ba-5399-11ec-2dc4-f3c90110402a
# ╠═4bfc9d08-5399-11ec-31d9-876caa98a760
# ╟─4bfc9d26-5399-11ec-2060-ab61e6fa724a
# ╟─4bfca064-5399-11ec-39c8-8b2861b4fb32
# ╟─4bfca514-5399-11ec-1595-43969333635a
# ╟─4bfca53c-5399-11ec-2f1f-e79320bd08bc
# ╟─4bfca55a-5399-11ec-3365-4586d3eac812
# ╟─4bfca582-5399-11ec-129b-d9e79071a0d7
# ╟─4bfca596-5399-11ec-3679-b9a7578c0bda
# ╟─4bfca5aa-5399-11ec-18f6-3152940e644e
# ╟─4bfca5c0-5399-11ec-1b7e-d7320a30e9da
# ╟─4bfca5c8-5399-11ec-1ea8-33f1e113429a
# ╟─4bfca5d2-5399-11ec-0f93-3fd18db2aaf5
# ╟─4bfca5e6-5399-11ec-2311-7973f5ddd759
# ╟─4bfca5fa-5399-11ec-0af7-cd605e3c930c
# ╟─4bfca604-5399-11ec-339e-478b981342e2
# ╟─4bfca618-5399-11ec-2ac7-5d69960f0580
# ╟─4bfca62c-5399-11ec-3985-493919e9c851
# ╟─4bfca636-5399-11ec-0e6d-f9f729de8ffb
# ╟─4bfca7b2-5399-11ec-32b9-c397e7d1f00a
# ╠═4bfcac30-5399-11ec-2220-cdae5741804c
# ╟─4bfcac6c-5399-11ec-190b-c78c948e178d
# ╠═4bfcb3cc-5399-11ec-056c-c79a3a3a6567
# ╟─4bfcb414-5399-11ec-3ba1-ab619b8278f7
# ╟─4bfcb482-5399-11ec-2a07-17a29fa90b0e
# ╟─4bfcb54a-5399-11ec-26d1-7b229d4e571d
# ╟─4bfcb55e-5399-11ec-2f97-eb54733e41d2
# ╟─4bfcb572-5399-11ec-3377-c9994dbb635a
# ╟─4bfcb590-5399-11ec-1c78-c59d728728b6
# ╟─4bfcb5ae-5399-11ec-0da0-cf84080f069e
# ╟─4bfcb5cc-5399-11ec-0588-03a351778665
# ╟─4bfcb60a-5399-11ec-3329-17a96c3c5c33
# ╟─4bfcb61c-5399-11ec-3a6f-3d70f0435a73
# ╟─4bfcb63c-5399-11ec-20e4-d9f869951031
# ╟─4bfcb662-5399-11ec-2405-4148637f6854
# ╟─4bfcb676-5399-11ec-3efb-195f791b5c29
# ╟─4bfcb694-5399-11ec-3cd8-0de726cb8bad
# ╟─4bfcb69c-5399-11ec-20e6-59240caef118
# ╟─4bfcb6b2-5399-11ec-3f5a-e3e6515d2946
# ╟─4bfcb6c6-5399-11ec-12a4-91c794319194
# ╟─4bfcb6ee-5399-11ec-261e-cd3d3453b51a
# ╟─4bfcb700-5399-11ec-0c0e-f39e27265207
# ╟─4bfcb7b6-5399-11ec-3942-b310b6940020
# ╟─4bfcb7de-5399-11ec-069a-b17895020a82
# ╟─4bfcbb78-5399-11ec-25d0-4f57793f4a93
# ╟─4bfebf3e-5399-11ec-2911-d5da2a201ac7
# ╟─4bfebffc-5399-11ec-2f7d-299a2a6946c6
# ╟─4bfec02e-5399-11ec-0351-13ef709eb9f3
# ╟─4bfec042-5399-11ec-0758-e77017c918e5
# ╟─4bfec114-5399-11ec-16a1-15f90405b75f
# ╟─4bfec11c-5399-11ec-36c6-b1ac65869d8d
# ╠═4bfecbd2-5399-11ec-082d-ab18109f7b58
# ╟─4bfecc0e-5399-11ec-2025-49a54a3b8e28
# ╠═4bfed208-5399-11ec-1ebc-a5ed0bd6f8e0
# ╟─4bfed230-5399-11ec-3638-cd1fb835e3d8
# ╠═4bfeeda6-5399-11ec-39bc-63ed7663dc52
# ╟─4bfeedce-5399-11ec-3442-851dd0d2efa0
# ╟─4bfeee14-5399-11ec-3aae-c9df863318fc
# ╠═4bfeefea-5399-11ec-2178-8d7657144e28
# ╟─4bfeeffe-5399-11ec-0aa7-ff0cfc15ae3e
# ╠═4bfef24c-5399-11ec-24bf-7349d1171c62
# ╠═4bfef72e-5399-11ec-1535-03f41094e63e
# ╟─4bfef760-5399-11ec-1cd7-1d17ef51fc52
# ╠═4bfef972-5399-11ec-20a8-753c7c2d0fb1
# ╟─4bfef998-5399-11ec-32ca-9be98da8d378
# ╟─4bfef9ae-5399-11ec-220e-373854edbb71
# ╠═4bfefce2-5399-11ec-1be8-7bc3037aa25d
# ╟─4bfefd28-5399-11ec-1914-03d3853ec86e
# ╠═4bff0386-5399-11ec-1a0f-93042a581cc4
# ╟─4bff03a4-5399-11ec-38ad-255851f3b1e3
# ╠═4bff0aa2-5399-11ec-3a33-a3ec1c6798ca
# ╟─4bff0aca-5399-11ec-1d34-057acdb67f99
# ╠═4bff0f82-5399-11ec-160f-f7648352c45b
# ╟─4bff0fa2-5399-11ec-0130-ab88957509eb
# ╠═4bff13b2-5399-11ec-3da7-314cab086a14
# ╟─4bff13da-5399-11ec-0451-8556eb66b98f
# ╟─4bff1416-5399-11ec-1347-2bf45371892e
# ╟─4bff143e-5399-11ec-1350-c31747131f48
# ╟─4bff1452-5399-11ec-008b-9561a397a8db
# ╟─4bff1470-5399-11ec-2a39-9d355d186ed4
# ╠═4bff18e4-5399-11ec-225b-61e9a7c7f756
# ╟─4bff1902-5399-11ec-076f-8dbbba24cf2d
# ╟─4bff1920-5399-11ec-06a6-bfed37a2e520
# ╠═4bff1d76-5399-11ec-3746-0f5216f1f955
# ╟─4bff1db2-5399-11ec-2ada-298cb0eeee15
# ╠═4bff23de-5399-11ec-34c7-7f298b0e5290
# ╟─4bff2424-5399-11ec-0277-3f45fdf35020
# ╟─4bff2492-5399-11ec-1f57-ef803a047898
# ╟─4bff249c-5399-11ec-0764-7f4c87b3a4a4
# ╠═4bff2a5a-5399-11ec-2110-b54089173ef1
# ╟─4bff2a8c-5399-11ec-3113-23f044344e06
# ╠═4bff2eb2-5399-11ec-111e-537e606812d5
# ╟─4bff2ef6-5399-11ec-1446-c1032b9ed7d4
# ╟─4bff2f12-5399-11ec-0014-67e868e032ef
# ╟─4bff2f96-5399-11ec-2935-493e9f06a236
# ╟─4bff2fb6-5399-11ec-27f7-8551e136c0f9
# ╟─4bff2fdc-5399-11ec-2a42-475843efdfba
# ╟─4bff33b0-5399-11ec-21c5-1571c3f09c50
# ╟─4bff33c4-5399-11ec-16a8-b503b4662988
# ╟─4bff33d8-5399-11ec-0271-c3a6e2e6c714
# ╟─4bff33e2-5399-11ec-0492-e71ccda4efa0
# ╟─4bff340a-5399-11ec-28a2-d53600106d59
# ╟─4bff372a-5399-11ec-21fd-cd4cc1ed984c
# ╟─4bff373e-5399-11ec-24b8-c372b94882ff
# ╟─4bff3750-5399-11ec-2287-291763f0cdcb
# ╟─4bff3766-5399-11ec-2a4c-570f1ab87ae2
# ╟─4bff377a-5399-11ec-232e-71c9d5f61f86
# ╟─4bff3914-5399-11ec-2fce-095f0a9d1426
# ╟─4bff3950-5399-11ec-12b9-15dd4755b252
# ╟─4bff396e-5399-11ec-08e7-b5774bc54469
# ╟─4bff3d06-5399-11ec-16b9-f1c4462e8e4d
# ╟─4bff3d24-5399-11ec-2e5f-db61dbef80fe
# ╟─4bff3d56-5399-11ec-0469-b1301d1ee220
# ╟─4bff3d6a-5399-11ec-3148-7bc7f82a9781
# ╟─4bff3d94-5399-11ec-10cb-8b9b38cb5606
# ╟─4bff3dc6-5399-11ec-2678-91ea76e1ff1b
# ╟─4bff4292-5399-11ec-069b-27fc539a9575
# ╟─4bff42b0-5399-11ec-214f-c1db3ddfa968
# ╟─4bff47f6-5399-11ec-136c-63af9d4eeec0
# ╟─4bff4814-5399-11ec-3974-09f0db42084c
# ╟─4bff483c-5399-11ec-2dd9-db3d90348eab
# ╟─4bff4846-5399-11ec-2c74-d92c431fd909
# ╟─4bff4cb0-5399-11ec-0f97-9b723cc1bb84
# ╟─4bff4cce-5399-11ec-2dbb-37f6dad19902
# ╟─4bff4d28-5399-11ec-2d09-65264d2009eb
# ╟─4bff4d3a-5399-11ec-2d58-75a6329b4448
# ╟─4bff4d5a-5399-11ec-0514-55dcfeae10dd
# ╟─4bff5034-5399-11ec-27b6-f7e6acfbc0aa
# ╟─4bff5052-5399-11ec-224f-f78bfde234b2
# ╟─4bff550c-5399-11ec-0f7d-570d153a2d6c
# ╟─4bff552a-5399-11ec-0683-db4bd26b5f3d
# ╟─4bff5868-5399-11ec-29db-416b44f06e79
# ╟─4bff5890-5399-11ec-0085-ab49655dd350
# ╟─4bff58cc-5399-11ec-3c02-a71d8dac0f93
# ╟─4bff58e0-5399-11ec-3c6d-ff78a81fe549
# ╟─4bff5dfe-5399-11ec-0c00-310c08db9419
# ╟─4bff5e26-5399-11ec-35b3-571f3b883d21
# ╟─4bff63da-5399-11ec-0409-af6c13df04a7
# ╟─4bff63fa-5399-11ec-38d9-9b3ad927dd3b
# ╟─4bff6402-5399-11ec-247c-e1a11240e289
# ╟─4bff6416-5399-11ec-0fe6-994dabb4ec73
# ╟─4bff6434-5399-11ec-3aad-2d8e32aa1d36
# ╟─4bff643e-5399-11ec-21f1-ef73204986c7
# ╟─4bff65d8-5399-11ec-1180-b9acd8999ce9
# ╟─4bff65f4-5399-11ec-2c28-27f600bd159e
# ╟─4bff6a42-5399-11ec-02f5-c54823c9383b
# ╟─4bff6a6a-5399-11ec-0377-1b919a74b645
# ╟─4bff6eac-5399-11ec-3c78-9b92e6f9a0f3
# ╟─4bff6eca-5399-11ec-0286-bd94887b3880
# ╟─4bff7340-5399-11ec-1c6d-5de8f85a04f5
# ╟─4bff884c-5399-11ec-35a6-01f1220fd083
# ╟─4bff8854-5399-11ec-3e53-f906e1bbae16
# ╟─4bff8854-5399-11ec-18d9-996cd9903a83
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
