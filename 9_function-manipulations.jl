### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ e49d4198-53c1-11ec-1588-85c157fad66a
begin
	using CalculusWithJulia
	using Plots
end

# ╔═╡ e49d46f4-53c1-11ec-3240-995fef8558b0
begin
	using CalculusWithJulia.WeaveSupport
	using DataFrames
	__DIR__, __FILE__ = :precalc, :transformations
	nothing
end

# ╔═╡ e4a04a3c-53c1-11ec-3861-5f2b26f022aa
using PlutoUI

# ╔═╡ e4a04a1c-53c1-11ec-38a9-6d927de19f30
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ e49c8c96-53c1-11ec-03a8-791e7fec1646
md"""# Function manipulations
"""

# ╔═╡ e49ca526-53c1-11ec-0ba6-1976f4bdba96
md"""In this section we will use these add-on packages:
"""

# ╔═╡ e49d4800-53c1-11ec-05a6-0f295003981e
md"""Thinking of functions as objects themselves that can be manipulated - rather than just blackboxes for evaluation - is a major abstraction of calculus. The main operations to come: the limit *of a function*, the derivative *of a function*, and the integral *of a function* all operate on functions. Hence the idea of an [operator](http://tinyurl.com/n5gp6mf). Here we discuss manipulations of functions from pre-calculus that have proven to be useful abstractions.
"""

# ╔═╡ e49d73e8-53c1-11ec-16a3-715b98ad54d0
md"""## The algebra of functions
"""

# ╔═╡ e49d74ec-53c1-11ec-07e3-0357a36ba0b2
md"""We can talk about the algebra of functions. For example, the sum of functions $f$ and $g$ would be a function whose value at $x$ was just $f(x) + g(x)$. More formally, we would have:
"""

# ╔═╡ e49d75be-53c1-11ec-3c6e-6d630f9917cf
md"""```math
(f + g)(x) = f(x) + g(x),
```
"""

# ╔═╡ e49d75e6-53c1-11ec-3c45-c92d3d4df27e
md"""We have given meaning to a new function $f+g$ by defining what is does to $x$ with the rule on the right hand side. Similarly, we can define operations for subtraction, multiplication, addition, and powers.
"""

# ╔═╡ e49d7654-53c1-11ec-15b6-af52342af26f
md"""These mathematical concepts aren't defined for functions in base `Julia`, though they could be if desired, by a commands such as:
"""

# ╔═╡ e49d7ce4-53c1-11ec-3969-790a494ca7ce
begin
	import Base: +
	f::Function + g::Function = x -> f(x) + g(x)
end

# ╔═╡ e49d7d0c-53c1-11ec-1f6b-bdc65392a6ce
md"""This adds a method to the generic `+` function for functions. The type annotations `::Function` ensure this applies only to functions. To see that it would work, we could do odd-looking things like:
"""

# ╔═╡ e49d8392-53c1-11ec-26c3-bbc427d62b79
begin
	ss = sin + sqrt
	ss(4)
end

# ╔═╡ e49d8408-53c1-11ec-1ea4-ad93cb56c533
md"""Doing this works, as Julia treats functions as first class objects, lending itself to [higher](https://en.wikipedia.org/wiki/Higher-order_programming) order programming. However, this definition in general is kind of limiting, as functions in mathematics and Julia can be much more varied than just the univariate functions we have defined addition for. We won't pursue this further.
"""

# ╔═╡ e49d845a-53c1-11ec-180f-5b4e5b167c21
md"""## Composition of functions
"""

# ╔═╡ e49d8522-53c1-11ec-157d-07ae9ad85e60
md"""As seen, just like with numbers, it can make sense mathematically to define addition, subtraction, multiplication and division of functions. Unlike numbers though, we can also define a new operation on functions called **composition** that involves chaining the output of one function to the input of another.  Composition is a common practice in life, where the result of some act is fed into another process. For example, making a pie from scratch involves first making a crust, then composing this with a filling. A better abstraction might be how we "surf" the web. The output of one search leads us to another search whose output then is a composition.
"""

# ╔═╡ e49d8626-53c1-11ec-1e55-1137aed1761f
md"""Mathematically, a composition of univariate functions $f$ and $g$ is written $f \circ g$ and defined by what it does to a value in the domain of $g$ by:
"""

# ╔═╡ e49d863a-53c1-11ec-161b-7516ed3dc224
md"""```math
(f \circ g)(x) = f(g(x)).
```
"""

# ╔═╡ e49d864e-53c1-11ec-32eb-a7ef5fb246f6
md"""The output of $g$ becomes the input of $f$.
"""

# ╔═╡ e49d866c-53c1-11ec-1b67-d92d63aa366d
md"""Composition depends on the order of things. There is no guarantee that $f \circ g$ should be the same as $g \circ f$. (Putting on socks then shoes is quite different from putting on shoes then socks.) Mathematically, we can see this quite clearly with the functions $f(x) = x^2$ and $g(x) = \sin(x)$. Algebraically we have:
"""

# ╔═╡ e49d8674-53c1-11ec-369d-c3692519e4f6
md"""```math
(f \circ g)(x) = \sin(x)^2, \quad (g \circ f)(x) = \sin(x^2).
```
"""

# ╔═╡ e49d869e-53c1-11ec-01a4-7f869349e696
md"""Though they may be *typographically* similar don't be fooled, the following graph shows that the two functions aren't even close except for $x$ near $0$ (for example, one composition is always non-negative, whereas the other is not):
"""

# ╔═╡ e49da836-53c1-11ec-032a-87e89734bcb9
let
	f(x) = x^2
	g(x) = sin(x)
	fg = f ∘ g      # typed as f \circ[tab] g
	gf = g ∘ f      # typed as g \circ[tab] f
	plot(fg, -2, 2, label="f∘g")
	plot!(gf, label="g∘f")
end

# ╔═╡ e49dd428-53c1-11ec-24ae-2366d7072173
note("""

Unlike how the basic arithmetic operations are treated, `Julia` defines the infix
Unicode operator `\\circ[tab]` to represent composition of functions,
mirroring mathematical notation. This infix operations takes in two functions and returns an anonymous function. It
can be useful and will mirror standard mathematical usage up to issues
with precedence rules.

""")

# ╔═╡ e49dd482-53c1-11ec-2869-1b51433d8976
md"""Starting with two functions and composing them requires nothing more than a solid grasp of knowing the rules of function evaluation. If $f(x)$ is defined by some rule involving $x$, then $f(g(x))$ just replaces each $x$ in the rule with a $g(x)$.
"""

# ╔═╡ e49dd4be-53c1-11ec-04e8-9f8ac96e9183
md"""So if $f(x) = x^2 + 2x - 1$ and $g(x) = e^x - x$ then $f \circ g$ would be (before any simplification)
"""

# ╔═╡ e49dd4d2-53c1-11ec-3d47-617256a2f361
md"""```math
(f \circ g)(x) = (e^x - x)^2 + 2(e^x - x) - 1.
```
"""

# ╔═╡ e49dd4e6-53c1-11ec-1860-0b438dd1d04f
md"""Here we look at a few compositions:
"""

# ╔═╡ e49dd892-53c1-11ec-1041-dda812540d1b
md"""  * The function $h(x) = \sqrt{1 - x^2}$ can be seen as $f\circ g$ with $f(x) = \sqrt{x}$ and $g(x) = 1-x^2$.
  * The function $h(x) = \sin(x/3 + x^2)$ can be viewed as $f\circ g$ with $f(x) = \sin(x)$ and $g(x) = x/3 + x^2$.
  * The function $h(x) = e^{-1/2 \cdot x^2}$  can be viewed as $f\circ g$ with $f(x) = e^{-x}$ and $g(x) = (1/2) \cdot x^2$.
"""

# ╔═╡ e49dd946-53c1-11ec-2032-036bdffa4ef8
md"""Decomposing a function into a composition of functions is not unique, other compositions could have been given above. For example, the last function is also $f(x) = e^{-x/2}$ composed with $g(x) = x^2$.
"""

# ╔═╡ e49de940-53c1-11ec-055d-a705d4a82a3b
note("""
The real value of composition is to break down more complicated things into a sequence of easier steps. This is good mathematics, but also good practice more generally. For example, when we approach a problem with the computer, we generally use a smallish set of functions and piece them together (that is, compose them) to find a solution.
""")

# ╔═╡ e49de95c-53c1-11ec-0650-71419496a279
md"""## Shifting and scaling graphs
"""

# ╔═╡ e49dea00-53c1-11ec-132e-d5f46d0f956c
md"""It is very useful to mentally categorize functions within families. The difference between $f(x) = \cos(x)$ and $g(x) = 12\cos(2(x - \pi/4))$ is not that much - both are cosine functions, one is just a simple enough transformation of the other. As such, we expect bounded, oscillatory behaviour with the details of how large and how fast the oscillations are to depend on the specifics of the function. Similarly, both these functions $f(x) = 2^x$ and $g(x)=e^x$ behave like exponential growth, the difference being only in the rate of growth. There are families of functions that are qualitatively similar, but quantitatively different, linked together by a few basic transformations.
"""

# ╔═╡ e49dea12-53c1-11ec-2213-e1d4301e7673
md"""There is a set of operations of functions, which does not really change the type of function. Rather, it basically moves and stretches how the functions are graphed. We discuss these four main transformations of $f$:
"""

# ╔═╡ e49df3b8-53c1-11ec-3f8f-c595e0d07e44
begin
	nms = ["*vertical shifts*","*horizontal shifts*","*stretching*","*scaling*"]
	acts = [L"The function $h(x) = k + f(x)$ will have the same graph as $f$ shifted up by $k$ units.",
	L"The function $h(x) = f(x - k)$ will have the same graph as $f$ shifted right by $k$ units.",
	L"The function $h(x) = kf(x)$ will have the same graph as $f$ stretched by a factor of $k$ in the $y$ direction.",
	L"The function $h(x) = f(kx)$ will have the same graph as $f$ compressed horizontally by a factor of $1$ over $k$."]
	table(DataFrame(Transformation=nms, Description=acts))
end

# ╔═╡ e49df3fe-53c1-11ec-16e3-756ad44d2ebb
md"""The functions $h$ are derived from $f$ in a predictable way. To implement these transformations within `Julia`, we define operators (functions which transform one function into another). As these return functions, the function bodies are anonymous functions. The basic definitions are similar, save for the `x -> ...` part that signals the creation of an anonymous function to return:
"""

# ╔═╡ e49dfafc-53c1-11ec-1866-054c9132d910
begin
	up(f, k)       = x -> f(x) + k
	over(f, k)     = x -> f(x - k)
	stretch(f, k)  = x -> k * f(x)
	scale(f, k)    = x -> f(k * x)
end

# ╔═╡ e49dfb1a-53c1-11ec-2eef-c5f4521e79f8
md"""To illustrate, let's define a hat-shaped function as follows:
"""

# ╔═╡ e49e11c2-53c1-11ec-2333-a5ffe5ddb929
𝒇(x) = max(0, 1 - abs(x))

# ╔═╡ e49e1208-53c1-11ec-3f5e-1b6b99c77a55
md"""A plot over the interval $[-2,2]$ is shown here:
"""

# ╔═╡ e49e1816-53c1-11ec-3b4e-9fc5beb2849b
plot(𝒇, -2,2)

# ╔═╡ e49e18d6-53c1-11ec-1f29-ade034bee909
md"""The same graph of $f$ and its image shifted up by 2 units would be given by:
"""

# ╔═╡ e49e2374-53c1-11ec-2018-2539434cbacf
begin
	plot(𝒇, -2, 2, label="f")
	plot!(up(𝒇, 2), label="up")
end

# ╔═╡ e49e23b2-53c1-11ec-0f25-d92279ee374b
md"""A graph of $f$ and its shift over by $2$ units would be given  by:
"""

# ╔═╡ e49e40ac-53c1-11ec-34db-0116b6983ee9
begin
	plot(𝒇, -2, 4, label="f")
	plot!(over(𝒇, 2), label="over")
end

# ╔═╡ e49e40fc-53c1-11ec-1316-c3a5f01e9979
md"""A graph of $f$ and it being stretched by $2$ units would be given by:
"""

# ╔═╡ e49e6062-53c1-11ec-0619-9972f3e138ad
begin
	plot(𝒇, -2, 2, label="f")
	plot!(stretch(𝒇, 2), label="stretch")
end

# ╔═╡ e49e60be-53c1-11ec-106a-a937b6a47a8f
md"""Finally, a graph of $f$ and it being scaled by $2$ would be given by:
"""

# ╔═╡ e49e66ae-53c1-11ec-0e58-59cdcf0571b5
begin
	plot(𝒇, -2, 2, label="f")
	plot!(scale(𝒇, 2), label="scale")
end

# ╔═╡ e49e66ea-53c1-11ec-3f20-dd20e87fb646
md"""Scaling by $2$ shrinks the non-zero domain, scaling by $1/2$ would stretch it. If this is not intuitive, the defintion `x-> f(x/c)` could have been used, which would have opposite behaviour for scaling.
"""

# ╔═╡ e49e67bc-53c1-11ec-097d-f15ef4035217
md"""---
"""

# ╔═╡ e49e67da-53c1-11ec-0856-b7f089bfb7dc
md"""More exciting is what happens if we combine these operations.
"""

# ╔═╡ e49e67e4-53c1-11ec-355e-ad1e6d2d9d35
md"""A shift right by 2 and up by 1 is achieved through
"""

# ╔═╡ e49e87e2-53c1-11ec-3d19-a73163ff0f99
begin
	plot(𝒇, -2, 4, label="f")
	plot!(up(over(𝒇,2), 1), label="over and up")
end

# ╔═╡ e49e8894-53c1-11ec-1f1c-3b0cee580ec2
md"""Shifting and scaling can be confusing. Here we graph `scale(over(𝒇,2),1/3)`:
"""

# ╔═╡ e49e8f38-53c1-11ec-162a-3d81ba4fd3f2
begin
	plot(𝒇, -1,9, label="f")
	plot!(scale(over(𝒇,2), 1/3), label="over and scale")
end

# ╔═╡ e49e8f76-53c1-11ec-3f6b-bbc68d230723
md"""This graph is over by $6$ with a width of $3$ on each side of the center. Mathematically, we have $h(x) = f((1/3)\cdot x - 2)$
"""

# ╔═╡ e49e8f8a-53c1-11ec-3bd8-e1276f208a00
md"""Compare this to the same operations in opposite order:
"""

# ╔═╡ e49e952a-53c1-11ec-3603-e59de2ea869d
begin
	plot(𝒇, -1, 5, label="f")
	plot!(over(scale(𝒇, 1/3), 2), label="scale and over")
end

# ╔═╡ e49e955c-53c1-11ec-348a-3f28683aad5e
md"""This graph first scales the symmetric graph, stretching from $-3$ to $3$, then shifts over right by $2$. The resulting function is $f((1/3)\cdot (x-2))$.
"""

# ╔═╡ e49e9570-53c1-11ec-1e02-096037d0db60
md"""As a last example, following up on the last example, a common transformation mathematically is
"""

# ╔═╡ e49e9598-53c1-11ec-0876-e7b8c4173572
md"""```math
h(x) = \frac{1}{a}f(\frac{x - b}{a}).
```
"""

# ╔═╡ e49e95c0-53c1-11ec-2c32-8b2546afdfbc
md"""We can view this as a composition of "scale" by $1/a$, then  "over" by $b$,  and finally "stretch" by $1/a$:
"""

# ╔═╡ e49e9ade-53c1-11ec-17f3-45b750732de9
let
	a = 2; b = 5
	𝒉(x) = stretch(over(scale(𝒇, 1/a), b), 1/a)(x)
	plot(𝒇, -1, 8, label="f")
	plot!(𝒉, label="h")
end

# ╔═╡ e49e9af2-53c1-11ec-125f-1f30e8da2c73
md"""(This transformation keeps the same amount of area in the triangles, can you tell from the graph?)
"""

# ╔═╡ e49e9b6a-53c1-11ec-0a1a-6712d30cdef6
md"""##### Example
"""

# ╔═╡ e49e9b9c-53c1-11ec-3a21-cf33f60ac5ae
md"""A model for the length of a day in New York City must take into account periodic seasonal effects. A simple model might be a sine curve. However, there would need to be many modifications: Obvious ones would be that the period would need to be about $365$ days, the oscillation around 12 and the amplitude of the oscillations no more than 12.
"""

# ╔═╡ e49e9bc4-53c1-11ec-3e0c-0fffe4dc0dfe
md"""We can be more precise. According to [dateandtime.info](http://dateandtime.info/citysunrisesunset.php?id=5128581) in 2015 the longest day will be June 21st when there will be 15h 5m 46s of sunlight, the shortest day will be December 21st when there will be 9h 15m 19s of sunlight. On January 1, there will be 9h 19m 44s of sunlight.
"""

# ╔═╡ e49e9bd8-53c1-11ec-352f-ddbca976da73
md"""A model for a transformed sine curve is
"""

# ╔═╡ e49e9c3c-53c1-11ec-36b0-45e8af1b6cf1
md"""```math
a + b\sin(d(x - c))
```
"""

# ╔═╡ e49e9c5a-53c1-11ec-2d19-4dc6806d074f
md"""Where $b$ is related to the amplitude, $c$ the shift and the period is $T=2\pi/d$. We can find some of these easily from the above:
"""

# ╔═╡ e49e9ff2-53c1-11ec-197a-493db447a3b6
begin
	a = 12
	b = ((15 + 5/60 + 46/60/60) - (9 + 19/60 + 44/60/60)) / 2
	d = 2pi/365
end

# ╔═╡ e49ea074-53c1-11ec-1725-ff27e594b779
md"""If we let January 1 be $x=0$ then the first day of spring, March 21, is day 80 (`Date(2017, 3, 21) - Date(2017, 1, 1) + 1`). This day aligns with the shift of the sine curve.  This shift is 80:
"""

# ╔═╡ e49ea2c2-53c1-11ec-350c-cbc4990d2c37
c = 80

# ╔═╡ e49ea2fe-53c1-11ec-2e4d-2f8f3f44ef5a
md"""Putting this together, we have our graph is "scaled" by $d$, "over" by $c$, "stretched" by $b$ and "up" by $a$. Here we plot it over slightly more than one year so that we can see that the shortest day of light is in late December ($x \approx -10$ or $x \approx 355$).
"""

# ╔═╡ e49ef6f0-53c1-11ec-0f82-49a2b8f57493
begin
	newyork(t) = up(stretch(over(scale(sin, d), c), b), a)(t)
	plot(newyork, -20, 385)
end

# ╔═╡ e49ef786-53c1-11ec-342f-675c56be1663
md"""To test, if we match up with the model powering [dateandtime.info](http://dateandtime.info/citysunrisesunset.php?id=5128581) we note that it predicts "15h 0m 4s" on July 4, 2015. This is day 185 (`Date(2015, 7, 4) - Date(2015, 1, 1) + 1`). Our model prediction has a difference of
"""

# ╔═╡ e49f0190-53c1-11ec-1d2a-ffe5d1621b5a
begin
	datetime = 15 + 0/60 + 4/60/60
	delta = (newyork(185) - datetime) * 60
end

# ╔═╡ e49f01f4-53c1-11ec-2368-212ce9bc91fe
md"""This is off by a fair amount - almost 12 minutes. Clearly a trigonometric model, based on the assumption of circular motion of the earth around the sun, is not accurate enough for precise work.
"""

# ╔═╡ e49f020a-53c1-11ec-06da-4d4f06fbf9f5
md"""##### Example: a growth model in fisheries
"""

# ╔═╡ e49f024e-53c1-11ec-2d05-bfe9d675dfc5
md"""The von Bertanlaffy growth [equation](http://www.fao.org/docrep/W5449e/w5449e05.htm) is $L(t) =L_\infty \cdot (1 - e^{k\cdot(t-t_0)})$. This family of functions can be viewed as a transformation of the exponential function $f(t)=e^t$. Part is a scaling and shifting (the $e^{k \cdot (t - t_0)}$) along with some shifting and stretching. The various parameters have physical importance which can be measured: $L_\infty$ is a carrying capacity for the species or organism, and $k$ is a rate of growth. These parameters may be estimated from data by finding the "closest" curve to a given data set.
"""

# ╔═╡ e49f0262-53c1-11ec-0b33-0b1e860e593d
md"""##### Example: the pipeline operator
"""

# ╔═╡ e49f02a8-53c1-11ec-06cf-f5eaeb829a45
md"""In the last example, we described our sequence as scale, over, stretch, and up, but code this in reverse order, as the composition $f \circ g$ is done from right to left. A more convenient notation would be to have syntax that allows the composition of $g$ then $f$ to be written $x \rightarrow g \rightarrow f$. `Julia` provides the [pipeline](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.|>) operator for chaining function calls together.
"""

# ╔═╡ e49f02c6-53c1-11ec-37ed-59f83085aa65
md"""For example, if $g(x) = \sqrt{x}$ and $f(x) =\sin(x)$ we could call $f(g(x))$ through:
"""

# ╔═╡ e49f06fe-53c1-11ec-0f54-f5d91b363eb4
let
	g(x) = sqrt(x)
	f(x) = sin(x)
	pi/2 |> g |> f
end

# ╔═╡ e49f076c-53c1-11ec-27b3-15e035dccebd
md"""The output of the preceding expression is passed as the input to the next. This notation is especially convenient when the enclosing function is not the main focus. (Some programming languages have more developed [fluent interfaces](https://en.wikipedia.org/wiki/Fluent_interface) for chaining function calls. Julia has some macros provided in packages.)
"""

# ╔═╡ e49f078a-53c1-11ec-03fe-a39941addc1f
md"""## Operators
"""

# ╔═╡ e49f07bc-53c1-11ec-3ea6-0df4ed73987e
md"""The functions `up`, `over`, etc. are operators that take a function as an argument and return a function. The use of operators fits in with the template `action(f, args...)`. The action is what we are doing, such as `plot`, `over`, and others to come. The function `f` here is just an object that we are performing the action on. For example, a plot takes a function and renders a graph using the additional arguments to select the domain to view, etc.
"""

# ╔═╡ e49f07d0-53c1-11ec-3603-71f6fa0cd47c
md"""Creating operators that return functions involves the use of anonymous functions, using these operators is relatively straightforward. Two basic patterns are
"""

# ╔═╡ e49f0870-53c1-11ec-0442-37a657a1cd53
md"""  * Storing the returned function, then calling it:
"""

# ╔═╡ e49f08a2-53c1-11ec-39e8-ebecc8e32dd2
md"""```
l(x) = action1(f, args...)(x)
l(10)
```"""

# ╔═╡ e49f08d4-53c1-11ec-3db8-bd028c7df0ab
md"""  * Composing two operators:
"""

# ╔═╡ e49f08e8-53c1-11ec-2136-91e88c03b8c5
md"""```
action2( action1(f, args..), other_args...)
```"""

# ╔═╡ e49f08fc-53c1-11ec-10c3-b1a779b66d18
md"""Composition like the above is convenient, but can get confusing if more than one composition is involved.
"""

# ╔═╡ e49f0912-53c1-11ec-3bb4-a14d5e18f17e
md"""##### Example: two operators
"""

# ╔═╡ e49f094c-53c1-11ec-2444-a12d54e6fbcb
md"""(See [Krill](http://arxiv.org/abs/1403.5821) for background on this example.) Consider two operations on functions. The first takes the *difference* between adjacent points. We call this `D`:
"""

# ╔═╡ e49f2a80-53c1-11ec-27c6-09eb79556885
D(f::Function) = k -> f(k) - f(k-1)

# ╔═╡ e49f2ab2-53c1-11ec-0652-015f5f62c016
md"""To see that it works, we take a typical function
"""

# ╔═╡ e49f7422-53c1-11ec-0a37-7d873e68cc5f
𝐟(k) = 1 + k^2

# ╔═╡ e49f7454-53c1-11ec-083d-f94b4d6ad5f9
md"""and check:
"""

# ╔═╡ e49f7a8a-53c1-11ec-11d1-653ab6697c59
D(𝐟)(3), 𝐟(3) - 𝐟(3-1)

# ╔═╡ e49f7ac6-53c1-11ec-23a5-1fb403692a04
md"""That the two are the same value is no coincidence. (Again, pause for a second to make sure you understand why `D(f)(3)` makes sense. If this is unclear, you could name the function `D(f)` and then call this with a value of `3`.)
"""

# ╔═╡ e49f7b0a-53c1-11ec-2e3c-6bba70dcda26
md"""Now we want a function to cumulatively *sum* the values $S(f)(k) = f(1) + f(2) + \cdots + f(k-1) + f(k)$, as a function of $k$. Adding up $k$ terms is easy to do with a generator and the function `sum` to add a vector of numbers:
"""

# ╔═╡ e49f828c-53c1-11ec-0888-6f418af0c3d8
S(f) = k -> sum(f(i) for i in 1:k)

# ╔═╡ e49f82aa-53c1-11ec-24f7-1741171c9ba5
md"""To check if this works as expected, compare these two values:
"""

# ╔═╡ e49f8912-53c1-11ec-2a3b-ef08ff139231
S(𝐟)(4), 𝐟(1) + 𝐟(2) + 𝐟(3) + 𝐟(4)

# ╔═╡ e49f8926-53c1-11ec-0838-6de4e2e2c50b
md"""So one function adds, the other subtracts. Addition and subtraction are somehow inverse to each other so should "cancel" out. This holds for these two operations as well, in the following sense: subtracting after adding leaves the function alone:
"""

# ╔═╡ e49f8d20-53c1-11ec-0773-e9891e3f0a7a
begin
	k = 10    # some arbitrary value k >= 1
	D(S(𝐟))(k), 𝐟(k)
end

# ╔═╡ e49f8d4a-53c1-11ec-0c6c-457b0bbb6634
md"""Any positive integer value of `k` will give the same answer (up to overflow). This says the difference of the accumulation process is just the last value to accumulate.
"""

# ╔═╡ e49f8d72-53c1-11ec-29df-b7a503b83293
md"""Adding after subtracting also leaves the function alone, save for a vestige of $f(0)$. For example, `k=15`:
"""

# ╔═╡ e49f91fc-53c1-11ec-057f-63a09e0f306d
S(D(𝐟))(15),  𝐟(15) - 𝐟(0)

# ╔═╡ e49f920e-53c1-11ec-1a25-61c5303cdb24
md"""That is the accumulation of differences is just the difference of the end values.
"""

# ╔═╡ e49f9218-53c1-11ec-0771-67d45259191e
md"""These two operations are discrete versions of the two main operations of calculus - the derivative and the integral. This relationship will be known as the "fundamental theorem of calculus."
"""

# ╔═╡ e49f9236-53c1-11ec-1f94-7bfceab37d33
md"""## Questions
"""

# ╔═╡ e49f929a-53c1-11ec-2e8a-df8a2c127f86
md"""###### Question
"""

# ╔═╡ e49f92cc-53c1-11ec-2791-0f25e2244328
md"""If $f(x) = 1/x$ and $g(x) = x-2$, what is $g(f(x))$?
"""

# ╔═╡ e49f9ad8-53c1-11ec-1dc7-9d8b8df14eab
let
	choices=["``1/(x-2)``", "``1/x - 2``", "``x - 2``", "``-2``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ e49f9af6-53c1-11ec-1f3d-994040638ac1
md"""###### Question
"""

# ╔═╡ e49f9b28-53c1-11ec-33d5-85b5d08a4765
md"""If $f(x) = e^{-x}$ and $g(x) = x^2$ and $h(x) = x-3$, what is $f \circ g \circ h$?
"""

# ╔═╡ e49fa3c0-53c1-11ec-20f3-4f0b088f67c6
let
	choices=["``e^{-x^2 - 3}``", "``(e^x -3)^2``",
	         "``e^{-(x-3)^2}``", "``e^x+x^2+x-3``"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ e49fa3d4-53c1-11ec-0aa1-cf04235b71a1
md"""###### Question
"""

# ╔═╡ e49fa3fc-53c1-11ec-3e51-d7fdb7b6fb22
md"""If $h(x) = (f \circ g)(x) = \sin^2(x)$ which is  a possibility for $f$ and $g$:
"""

# ╔═╡ e49fad16-53c1-11ec-301f-e53694e2c55e
let
	choices = [raw"``f(x)=x^2; \quad g(x) = \sin^2(x)``",
		       raw"```f(x)=x^2; \quad g(x) = \sin(x)``",
		       raw"``f(x)=\sin(x); \quad g(x) = x^2``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ e49fad2a-53c1-11ec-2b31-1d15eb1ac66e
md"""###### Question
"""

# ╔═╡ e49fad86-53c1-11ec-3c06-9dabca065e5f
md"""Which function would have the same graph as the sine curve shifted over by 4 and up by 6?
"""

# ╔═╡ e49fb662-53c1-11ec-0b65-c1509a9d6673
let
	choices = [
	    raw"``h(x) = 4 + \sin(6x)``",
	    raw"``h(x) = 6 + \sin(x + 4)``",
	    raw"``h(x) = 6 + \sin(x-4)``",
	    raw"``h(x) = 6\sin(x-4)``"]
	ans = 3
	radioq(choices, 3)
end

# ╔═╡ e49fb676-53c1-11ec-3c03-21da3d05b6a4
md"""###### Question
"""

# ╔═╡ e49fb6bc-53c1-11ec-3a10-435537f5314d
md"""Let $h(x) = 4x^2$ and $f(x) = x^2$. Which is **not** true:
"""

# ╔═╡ e49fc2d8-53c1-11ec-0049-456e3097daec
let
	choices = [L"The graph of $h(x)$ is the graph of $f(x)$ stretched by a factor of 4",
		   L"The graph of $h(x)$ is the graph of $f(x)$ scaled by a factor of 2",
		   L"The graph of $h(x)$ is the graph of $f(x) shifted up by 4 units"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ e49fc2f6-53c1-11ec-15c8-a7a3f5b1d8d3
md"""###### Question
"""

# ╔═╡ e49fc31e-53c1-11ec-0304-3198c9d9f0a7
md"""The transformation $h(x) = (1/a) \cdot f((x-b)/a)$ can be viewed in one sequence:
"""

# ╔═╡ e49fe7b8-53c1-11ec-3cff-d19ff703fdb2
let
	choices = [L"scaling by $1/a$, then shifting by $b$, then stretching by $1/a$",
	           L"shifting by $a$, then scaling by $b$, and then scaling by $1/a$",
		   L"shifting by $a$, then scaling by $a$, and then scaling by $b$" ]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ e49fe7ea-53c1-11ec-13e3-0574521f6925
md"""###### Question
"""

# ╔═╡ e49fe7fe-53c1-11ec-2eca-9d30fdcc50ec
md"""This is the graph of a transformed sine curve.
"""

# ╔═╡ e4a009c6-53c1-11ec-01f1-bb5864b39335
let
	f(x) = 2*sin(pi*x)
	p = plot(f, -2,2)
end

# ╔═╡ e4a009f0-53c1-11ec-3fe8-bb12e87329a7
md"""What is the period of the graph?
"""

# ╔═╡ e4a00f22-53c1-11ec-1a53-6f489d709156
let
	val = 2
	numericq(val)
end

# ╔═╡ e4a00f4a-53c1-11ec-10ad-e3f96dd499b2
md"""What is the amplitude of the graph?
"""

# ╔═╡ e4a01454-53c1-11ec-32ee-edc19915daaa
let
	val = 2
	numericq(val)
end

# ╔═╡ e4a0147c-53c1-11ec-080f-335c2e78b927
md"""What is the form of the function graphed?
"""

# ╔═╡ e4a03948-53c1-11ec-1923-5bb9fd380da5
let
	choices = [
	raw"``2 \sin(x)``",
	raw"``\sin(2x)``",
	raw"``\sin(\pi x)``",
	raw"``2 \sin(\pi x)``"
	]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ e4a03984-53c1-11ec-1502-d309228375a7
md"""###### Question
"""

# ╔═╡ e4a039a0-53c1-11ec-3ba1-0db84f45fa35
md"""Consider this expression
"""

# ╔═╡ e4a03a24-53c1-11ec-3e8b-35bb66faf940
md"""```math
\left(f(1) - f(0)\right) + \left(f(2) - f(1)\right) + \cdots + \left(f(n) - f(n-1)\right) =
-f(0) + f(1) - f(1) + f(2) - f(2) + \cdots + f(n-1) - f(n-1) + f(n) =
f(n) - f(0).
```
"""

# ╔═╡ e4a03a60-53c1-11ec-08ac-13cd9cd8b13f
md"""Referring to the definitions of `D` and `S` in the example on operators, which relationship does this support:
"""

# ╔═╡ e4a041f4-53c1-11ec-3667-ab7c7a85fc45
let
	choices = [
	q"D(S(f))(n) = f(n)",
	q"S(D(f))(n) = f(n) - f(0)"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ e4a04208-53c1-11ec-2c0d-9355105ffa88
md"""###### Question
"""

# ╔═╡ e4a0421c-53c1-11ec-0641-573965037d22
md"""Consider this expression:
"""

# ╔═╡ e4a04280-53c1-11ec-1db4-939b621b1e34
md"""```math
\left(f(1) + f(2) + \cdots + f(n-1) + f(n)\right) - \left(f(1) + f(2) + \cdots + f(n-1)\right) = f(n).
```
"""

# ╔═╡ e4a04366-53c1-11ec-1035-a1cd99dc1083
md"""Referring to the definitions of `D` and `S` in the example on operators, which relationship does this support:
"""

# ╔═╡ e4a04a14-53c1-11ec-10f9-27b117d3b539
let
	choices = [
	q"D(S(f))(n) = f(n)",
	q"S(D(f))(n) = f(n) - f(0)"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ e4a04a32-53c1-11ec-2a3c-87ca0e9f9ae7
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/plotting.html">◅ previous</a>  <a href="../precalc/inversefunctions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/transformations.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ e4a04a46-53c1-11ec-3826-ddba2879857e
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.1.2"
DataFrames = "~1.6.1"
Plots = "~1.39.0"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "6721ac259bc00c235297720f84b3a349dc23cb4b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LinearAlgebra", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "049194aa15becc95f65f2cf38ec0a221e486d1c3"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.1.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "e82c3c97b5b4ec111f3c1b55228cebc7510525a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.25"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

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
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

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
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

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
git-tree-sha1 = "e95b36755023def6ebc3d269e6483efa8b2f7f65"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.1"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "Random"]
git-tree-sha1 = "8e59ea773deee525c99a8018409f64f19fb719e6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.7"
weakdeps = ["Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

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
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "ee094908d720185ddbdc58dbe0c1cbe35453ec7a"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "7c29f0e8c575428bd84dc3c72ece5178caa67336"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.2+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "06b5ac80ff1b88bd82df92c1c1875eea3954cd6e"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.20"

    [deps.Roots.extensions]
    RootsForwardDiffExt = "ForwardDiff"
    RootsIntervalRootFindingExt = "IntervalRootFinding"
    RootsSymPyExt = "SymPy"
    RootsSymPyPythonCallExt = "SymPyPythonCall"

    [deps.Roots.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
    SymPyPythonCall = "bc8888f7-b21e-4b7c-a06a-5d9c9496438c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "48f393b0231516850e39f6c756970e7ca8b77045"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

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
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─e4a04a1c-53c1-11ec-38a9-6d927de19f30
# ╟─e49c8c96-53c1-11ec-03a8-791e7fec1646
# ╟─e49ca526-53c1-11ec-0ba6-1976f4bdba96
# ╠═e49d4198-53c1-11ec-1588-85c157fad66a
# ╟─e49d46f4-53c1-11ec-3240-995fef8558b0
# ╟─e49d4800-53c1-11ec-05a6-0f295003981e
# ╟─e49d73e8-53c1-11ec-16a3-715b98ad54d0
# ╟─e49d74ec-53c1-11ec-07e3-0357a36ba0b2
# ╟─e49d75be-53c1-11ec-3c6e-6d630f9917cf
# ╟─e49d75e6-53c1-11ec-3c45-c92d3d4df27e
# ╟─e49d7654-53c1-11ec-15b6-af52342af26f
# ╠═e49d7ce4-53c1-11ec-3969-790a494ca7ce
# ╟─e49d7d0c-53c1-11ec-1f6b-bdc65392a6ce
# ╠═e49d8392-53c1-11ec-26c3-bbc427d62b79
# ╟─e49d8408-53c1-11ec-1ea4-ad93cb56c533
# ╟─e49d845a-53c1-11ec-180f-5b4e5b167c21
# ╟─e49d8522-53c1-11ec-157d-07ae9ad85e60
# ╟─e49d8626-53c1-11ec-1e55-1137aed1761f
# ╟─e49d863a-53c1-11ec-161b-7516ed3dc224
# ╟─e49d864e-53c1-11ec-32eb-a7ef5fb246f6
# ╟─e49d866c-53c1-11ec-1b67-d92d63aa366d
# ╟─e49d8674-53c1-11ec-369d-c3692519e4f6
# ╟─e49d869e-53c1-11ec-01a4-7f869349e696
# ╠═e49da836-53c1-11ec-032a-87e89734bcb9
# ╟─e49dd428-53c1-11ec-24ae-2366d7072173
# ╟─e49dd482-53c1-11ec-2869-1b51433d8976
# ╟─e49dd4be-53c1-11ec-04e8-9f8ac96e9183
# ╟─e49dd4d2-53c1-11ec-3d47-617256a2f361
# ╟─e49dd4e6-53c1-11ec-1860-0b438dd1d04f
# ╟─e49dd892-53c1-11ec-1041-dda812540d1b
# ╟─e49dd946-53c1-11ec-2032-036bdffa4ef8
# ╟─e49de940-53c1-11ec-055d-a705d4a82a3b
# ╟─e49de95c-53c1-11ec-0650-71419496a279
# ╟─e49dea00-53c1-11ec-132e-d5f46d0f956c
# ╟─e49dea12-53c1-11ec-2213-e1d4301e7673
# ╟─e49df3b8-53c1-11ec-3f8f-c595e0d07e44
# ╟─e49df3fe-53c1-11ec-16e3-756ad44d2ebb
# ╠═e49dfafc-53c1-11ec-1866-054c9132d910
# ╟─e49dfb1a-53c1-11ec-2eef-c5f4521e79f8
# ╠═e49e11c2-53c1-11ec-2333-a5ffe5ddb929
# ╟─e49e1208-53c1-11ec-3f5e-1b6b99c77a55
# ╠═e49e1816-53c1-11ec-3b4e-9fc5beb2849b
# ╟─e49e18d6-53c1-11ec-1f29-ade034bee909
# ╠═e49e2374-53c1-11ec-2018-2539434cbacf
# ╟─e49e23b2-53c1-11ec-0f25-d92279ee374b
# ╠═e49e40ac-53c1-11ec-34db-0116b6983ee9
# ╟─e49e40fc-53c1-11ec-1316-c3a5f01e9979
# ╠═e49e6062-53c1-11ec-0619-9972f3e138ad
# ╟─e49e60be-53c1-11ec-106a-a937b6a47a8f
# ╠═e49e66ae-53c1-11ec-0e58-59cdcf0571b5
# ╟─e49e66ea-53c1-11ec-3f20-dd20e87fb646
# ╟─e49e67bc-53c1-11ec-097d-f15ef4035217
# ╟─e49e67da-53c1-11ec-0856-b7f089bfb7dc
# ╟─e49e67e4-53c1-11ec-355e-ad1e6d2d9d35
# ╠═e49e87e2-53c1-11ec-3d19-a73163ff0f99
# ╟─e49e8894-53c1-11ec-1f1c-3b0cee580ec2
# ╠═e49e8f38-53c1-11ec-162a-3d81ba4fd3f2
# ╟─e49e8f76-53c1-11ec-3f6b-bbc68d230723
# ╟─e49e8f8a-53c1-11ec-3bd8-e1276f208a00
# ╠═e49e952a-53c1-11ec-3603-e59de2ea869d
# ╟─e49e955c-53c1-11ec-348a-3f28683aad5e
# ╟─e49e9570-53c1-11ec-1e02-096037d0db60
# ╟─e49e9598-53c1-11ec-0876-e7b8c4173572
# ╟─e49e95c0-53c1-11ec-2c32-8b2546afdfbc
# ╠═e49e9ade-53c1-11ec-17f3-45b750732de9
# ╟─e49e9af2-53c1-11ec-125f-1f30e8da2c73
# ╟─e49e9b6a-53c1-11ec-0a1a-6712d30cdef6
# ╟─e49e9b9c-53c1-11ec-3a21-cf33f60ac5ae
# ╟─e49e9bc4-53c1-11ec-3e0c-0fffe4dc0dfe
# ╟─e49e9bd8-53c1-11ec-352f-ddbca976da73
# ╟─e49e9c3c-53c1-11ec-36b0-45e8af1b6cf1
# ╟─e49e9c5a-53c1-11ec-2d19-4dc6806d074f
# ╠═e49e9ff2-53c1-11ec-197a-493db447a3b6
# ╟─e49ea074-53c1-11ec-1725-ff27e594b779
# ╠═e49ea2c2-53c1-11ec-350c-cbc4990d2c37
# ╟─e49ea2fe-53c1-11ec-2e4d-2f8f3f44ef5a
# ╠═e49ef6f0-53c1-11ec-0f82-49a2b8f57493
# ╟─e49ef786-53c1-11ec-342f-675c56be1663
# ╠═e49f0190-53c1-11ec-1d2a-ffe5d1621b5a
# ╟─e49f01f4-53c1-11ec-2368-212ce9bc91fe
# ╟─e49f020a-53c1-11ec-06da-4d4f06fbf9f5
# ╟─e49f024e-53c1-11ec-2d05-bfe9d675dfc5
# ╟─e49f0262-53c1-11ec-0b33-0b1e860e593d
# ╟─e49f02a8-53c1-11ec-06cf-f5eaeb829a45
# ╟─e49f02c6-53c1-11ec-37ed-59f83085aa65
# ╠═e49f06fe-53c1-11ec-0f54-f5d91b363eb4
# ╟─e49f076c-53c1-11ec-27b3-15e035dccebd
# ╟─e49f078a-53c1-11ec-03fe-a39941addc1f
# ╟─e49f07bc-53c1-11ec-3ea6-0df4ed73987e
# ╟─e49f07d0-53c1-11ec-3603-71f6fa0cd47c
# ╟─e49f0870-53c1-11ec-0442-37a657a1cd53
# ╟─e49f08a2-53c1-11ec-39e8-ebecc8e32dd2
# ╟─e49f08d4-53c1-11ec-3db8-bd028c7df0ab
# ╟─e49f08e8-53c1-11ec-2136-91e88c03b8c5
# ╟─e49f08fc-53c1-11ec-10c3-b1a779b66d18
# ╟─e49f0912-53c1-11ec-3bb4-a14d5e18f17e
# ╟─e49f094c-53c1-11ec-2444-a12d54e6fbcb
# ╠═e49f2a80-53c1-11ec-27c6-09eb79556885
# ╟─e49f2ab2-53c1-11ec-0652-015f5f62c016
# ╠═e49f7422-53c1-11ec-0a37-7d873e68cc5f
# ╟─e49f7454-53c1-11ec-083d-f94b4d6ad5f9
# ╠═e49f7a8a-53c1-11ec-11d1-653ab6697c59
# ╟─e49f7ac6-53c1-11ec-23a5-1fb403692a04
# ╟─e49f7b0a-53c1-11ec-2e3c-6bba70dcda26
# ╠═e49f828c-53c1-11ec-0888-6f418af0c3d8
# ╟─e49f82aa-53c1-11ec-24f7-1741171c9ba5
# ╠═e49f8912-53c1-11ec-2a3b-ef08ff139231
# ╟─e49f8926-53c1-11ec-0838-6de4e2e2c50b
# ╠═e49f8d20-53c1-11ec-0773-e9891e3f0a7a
# ╟─e49f8d4a-53c1-11ec-0c6c-457b0bbb6634
# ╟─e49f8d72-53c1-11ec-29df-b7a503b83293
# ╠═e49f91fc-53c1-11ec-057f-63a09e0f306d
# ╟─e49f920e-53c1-11ec-1a25-61c5303cdb24
# ╟─e49f9218-53c1-11ec-0771-67d45259191e
# ╟─e49f9236-53c1-11ec-1f94-7bfceab37d33
# ╟─e49f929a-53c1-11ec-2e8a-df8a2c127f86
# ╟─e49f92cc-53c1-11ec-2791-0f25e2244328
# ╟─e49f9ad8-53c1-11ec-1dc7-9d8b8df14eab
# ╟─e49f9af6-53c1-11ec-1f3d-994040638ac1
# ╟─e49f9b28-53c1-11ec-33d5-85b5d08a4765
# ╟─e49fa3c0-53c1-11ec-20f3-4f0b088f67c6
# ╟─e49fa3d4-53c1-11ec-0aa1-cf04235b71a1
# ╟─e49fa3fc-53c1-11ec-3e51-d7fdb7b6fb22
# ╟─e49fad16-53c1-11ec-301f-e53694e2c55e
# ╟─e49fad2a-53c1-11ec-2b31-1d15eb1ac66e
# ╟─e49fad86-53c1-11ec-3c06-9dabca065e5f
# ╟─e49fb662-53c1-11ec-0b65-c1509a9d6673
# ╟─e49fb676-53c1-11ec-3c03-21da3d05b6a4
# ╟─e49fb6bc-53c1-11ec-3a10-435537f5314d
# ╟─e49fc2d8-53c1-11ec-0049-456e3097daec
# ╟─e49fc2f6-53c1-11ec-15c8-a7a3f5b1d8d3
# ╟─e49fc31e-53c1-11ec-0304-3198c9d9f0a7
# ╟─e49fe7b8-53c1-11ec-3cff-d19ff703fdb2
# ╟─e49fe7ea-53c1-11ec-13e3-0574521f6925
# ╟─e49fe7fe-53c1-11ec-2eca-9d30fdcc50ec
# ╟─e4a009c6-53c1-11ec-01f1-bb5864b39335
# ╟─e4a009f0-53c1-11ec-3fe8-bb12e87329a7
# ╟─e4a00f22-53c1-11ec-1a53-6f489d709156
# ╟─e4a00f4a-53c1-11ec-10ad-e3f96dd499b2
# ╟─e4a01454-53c1-11ec-32ee-edc19915daaa
# ╟─e4a0147c-53c1-11ec-080f-335c2e78b927
# ╟─e4a03948-53c1-11ec-1923-5bb9fd380da5
# ╟─e4a03984-53c1-11ec-1502-d309228375a7
# ╟─e4a039a0-53c1-11ec-3ba1-0db84f45fa35
# ╟─e4a03a24-53c1-11ec-3e8b-35bb66faf940
# ╟─e4a03a60-53c1-11ec-08ac-13cd9cd8b13f
# ╟─e4a041f4-53c1-11ec-3667-ab7c7a85fc45
# ╟─e4a04208-53c1-11ec-2c0d-9355105ffa88
# ╟─e4a0421c-53c1-11ec-0641-573965037d22
# ╟─e4a04280-53c1-11ec-1db4-939b621b1e34
# ╟─e4a04366-53c1-11ec-1035-a1cd99dc1083
# ╟─e4a04a14-53c1-11ec-10f9-27b117d3b539
# ╟─e4a04a32-53c1-11ec-2a3c-87ca0e9f9ae7
# ╟─e4a04a3c-53c1-11ec-3861-5f2b26f022aa
# ╟─e4a04a46-53c1-11ec-3826-ddba2879857e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
