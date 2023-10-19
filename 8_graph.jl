### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 5771a184-53c0-11ec-26b7-5d3ab87dca60
begin
	using CalculusWithJulia
	using Plots
end

# ╔═╡ 5771a710-53c0-11ec-3dd6-ff2ce3af6d3c
begin
	using CalculusWithJulia.WeaveSupport
	using Roots
	__DIR__, __FILE__ = :precalc, :plotting
	nothing
end

# ╔═╡ 57739e94-53c0-11ec-25cd-31ddaff687a0
using SymPy, DataFrames

# ╔═╡ 5774bfae-53c0-11ec-3e48-f1b4815c2176
using PlutoUI

# ╔═╡ 5774bf86-53c0-11ec-15ac-b90237305151
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 5770d862-53c0-11ec-0518-7bb44845b034
md"""# The Graph of a Function
"""

# ╔═╡ 5770ef6e-53c0-11ec-2504-7993238cc233
md"""This section will use the following packages:
"""

# ╔═╡ 5771a7d8-53c0-11ec-1383-c391799a5896
md"""---
"""

# ╔═╡ 5771a846-53c0-11ec-2c7e-7faec07b1929
md"""A scalar, univariate function, such as $f(x) = 1 - x^2/2$, can be thought of in many different ways. For example:
"""

# ╔═╡ 5771abac-53c0-11ec-1789-e1b5f1f157e3
md"""  * It can be represented through a rule of what it does to $x$, as above. This is useful for computing numeric values.
  * it can be interpreted verbally, as in *square* $x$, take half then *subtract* from one. This can give clarity to what the function does.
  * It can be thought of in terms of its properties: a polynomial, continuous, $U$-shaped, an approximation for $\cos(x)$ near $0$, $\dots$
  * it can be visualized graphically. This is useful for seeing the qualitative behaviour of a function.
"""

# ╔═╡ 5771abca-53c0-11ec-27a3-47350abe52da
md"""The graph of a univariate function is just a set of points in the Cartesian plane. These points come from the relation $(x,f(x))$ that defines the function. Operationally, a sketch of the graph will consider a handful of such pairs and then the rest of the points will be imputed.
"""

# ╔═╡ 5771abde-53c0-11ec-1b62-550813663f8f
md"""For example, a typical approach to plot $f(x) = 1 - x^2/2$ would be to choose some values for $x$ and find the corresponding values of $y$. This might be organized in a "T"-table:
"""

# ╔═╡ 5771ac10-53c0-11ec-275d-6374a1199d3c
md"""```
 x | y
--------
-2 |  -1
-1 |  1/2
 0 |   1
 1 |  1/2
 2 |  -1
 3 | -7/2
```"""

# ╔═╡ 5771ac24-53c0-11ec-1ab1-d31714f5b030
md"""These pairs would be plotted in a Cartesian plane and then connected with curved lines. A good sketch is aided by knowing ahead of time that this function describes a parabola which is curving downwards.
"""

# ╔═╡ 5771ac4a-53c0-11ec-313f-7bc84ddf72eb
md"""We note that this sketch would not include *all* the pairs $(x,f(x))$, as their extent is infinite, rather a well chosen collection of points over some finite domain.
"""

# ╔═╡ 5771ac9c-53c0-11ec-03c5-a1a76530b966
md"""## Graphing a function with Julia
"""

# ╔═╡ 5771ad00-53c0-11ec-39b6-95a54bdb4139
md"""`Julia` has several different options for rendering graphs, all in external packages. We will focus in these notes on the `Plots` package, which provides a common interface to several different plotting backends. (Click through for instructions for plotting with the [Makie](../alternatives/makie_plotting.html) package.) At the top of this section the accompanying `CalculusWithJulia` package and  the `Plots` package were loaded with the `using` command, like this:
"""

# ╔═╡ 5771ad28-53c0-11ec-23d4-5d529f3ef996
md"""```
using CalculusWithJulia
using Plots
```"""

# ╔═╡ 5771f44c-53c0-11ec-24d3-3de6c89fa7d9
note("""
`Plots` is a frontend for one of several backends. `Plots` comes with a backend for web-based graphics (call `plotly()` to specify that); a backend for static graphs (call `gr()` for that). If the `PyPlot` package is installed, calling `pyplot()` will set that as a backend. For terminal usage, if the `UnicodePlots` package is installed, calling `unicodeplots()` will enable that usage. There are still other backends.""")

# ╔═╡ 5771f510-53c0-11ec-13b7-81ec8f382ad1
md"""The `plotly` backend is part of the `Plots` package, as is `gr`. Other backends require installation, such as `PyPlot` and `PlotlyJS`. We use a mix of `gr` and `pyplot` in these notes. (The `plotly` backend is also quite nice for interactive usage, but doesn't work as well with the static HTML pages.)
"""

# ╔═╡ 5771f530-53c0-11ec-0599-b51ed3d4ce3a
md"""With `Plots` loaded, it is straightforward to graph a function.
"""

# ╔═╡ 5771f558-53c0-11ec-0396-4fd37f9b9ba5
md"""For example, to graph $f(x) = 1 - x^2/2$ over the interval $[-3,3]$ we have:
"""

# ╔═╡ 5771fe5e-53c0-11ec-1215-b5abfeb64996
begin
	f(x) = 1 - x^2/2
	plot(f, -3, 3)
end

# ╔═╡ 5771fe90-53c0-11ec-3b12-431c056b266c
md"""The `plot` command does the hard work behind the scenes. It needs 2 pieces of information declared:
"""

# ╔═╡ 5771ff94-53c0-11ec-2e50-d91f5a5c5f2d
md"""  * **What** to plot. With this invocation, this detail is expressed by passing a function object to `plot`
  * **Where** to plot; the `xmin` and `xmax` values. As with a sketch, it is impossible in this case to render a graph with all possible $x$ values in the domain of $f$, so we need to pick some viewing window. In the example this is $[-3,3]$ which is expressed by passing the two endpoints as the second and third arguments.
"""

# ╔═╡ 5771ffb2-53c0-11ec-0672-7f1e279a0f47
md"""Plotting a function is then this simple: `plot(f, xmin, xmax)`.
"""

# ╔═╡ 577200a2-53c0-11ec-1471-8d6578db5662
md"""> *A basic template:* Many operations we meet will take the form `action(function, args...)`, as the call to `plot` does. The template shifts the focus to the action to be performed. This is a [declarative](http://en.wikipedia.org/wiki/Declarative_programming) style, where the details to execute the action are only exposed as needed.

"""

# ╔═╡ 577208d6-53c0-11ec-2dde-9bed64a7587f
note("""
The time to first plot can feel sluggish, but subsequent plots will be speedy. See the technical note at the end of this section for an explanation.
""")

# ╔═╡ 577208f4-53c0-11ec-3ffb-b52abaf8a276
md"""Let's see some other graphs.
"""

# ╔═╡ 57720912-53c0-11ec-329e-bdb219eb056d
md"""The `sin` function over one period is plotted through:
"""

# ╔═╡ 57720d18-53c0-11ec-2783-d773d0dbcbd2
plot(sin, 0, 2pi)

# ╔═╡ 57720d4a-53c0-11ec-07b1-75f2ff833a88
md"""We can make a graph of $f(x) = (1+x^2)^{-1}$ over $[-3,3]$ with
"""

# ╔═╡ 577213d0-53c0-11ec-0cdc-ab51e80de9f4
let
	f(x) = 1 / (1 + x^2)
	plot(f, -3, 3)
end

# ╔═╡ 577213f8-53c0-11ec-3c2e-338aca1eb1cd
md"""A graph of $f(x) = e^{-x^2/2}$ over $[-2,2]$ is produced with:
"""

# ╔═╡ 5772316c-53c0-11ec-1f9e-6d3561cdcb00
let
	f(x) = exp(-x^2/2)
	plot(f, -2, 2)
end

# ╔═╡ 577231e4-53c0-11ec-30aa-b9bac661eed5
md"""We could skip the first step of defining a function by using an *anonymous function*. For example, to plot $f(x) = \cos(x) - x$ over $[0, \pi/2]$ we could do:
"""

# ╔═╡ 57724e4a-53c0-11ec-2abc-755efe1b392d
plot(x -> cos(x) - x, 0, pi/2)

# ╔═╡ 57725b68-53c0-11ec-1577-af5089e1179f
note("""

The function object in the general pattern `action(function, args...)`
is commonly specified in one of three ways: by a name, as with `f`; as an
anonymous function; or as the return value of some other action
through composition.

""")

# ╔═╡ 57725bd8-53c0-11ec-0ef1-3b1f112254ea
md"""Anonymous functions are also created by `Julia's` `do` notation, which is useful when the first argument to  function (like `plot`) accepts a function:
"""

# ╔═╡ 57727a50-53c0-11ec-2bb9-cbee58f56a92
plot(0, pi/2) do x
    cos(x) - x
end

# ╔═╡ 57727aaa-53c0-11ec-0cd2-373547f84235
md"""The `do` notation can be a bit confusing to read when unfamiliar, though its convenience makes it appealing.
"""

# ╔═╡ 57728590-53c0-11ec-134f-a30c4e3539c5
note("""
Some types we will encounter, such as the one for symbolic values or the special polynomial one, have their own `plot` recipes that allow them to be plotted similarly as above, even though they are not functions.
""")

# ╔═╡ 577285cc-53c0-11ec-1ebe-b71bac6553e9
md"""---
"""

# ╔═╡ 57728606-53c0-11ec-06e5-155f5182db7f
md"""Making a graph with `Plots` is easy, but producing a graph that is informative can be a challenge, as the choice of a viewing window can make a big difference in what is seen. For example, trying to make a graph of $f(x) = \tan(x)$, as below, will result in a bit of a mess - the chosen viewing window crosses several places where the function blows up:
"""

# ╔═╡ 57728b26-53c0-11ec-2d66-f74c457c2e9b
let
	f(x) = tan(x)
	plot(f, -10, 10)
end

# ╔═╡ 57728b46-53c0-11ec-1a83-cba31d6159d4
md"""Though this graph shows the asymptote structure and periodicity, it doesn't give much insight into each period or even into the fact that the function is periodic.
"""

# ╔═╡ 57728b62-53c0-11ec-1fc3-ef47b83d91c4
md"""## The details of graph making
"""

# ╔═╡ 57728b8a-53c0-11ec-36ac-6db08423b609
md"""The actual details of making a graph of $f$ over $[a,b]$ are pretty simple and follow the steps in making a "T"-table:
"""

# ╔═╡ 57728d06-53c0-11ec-111b-497233e3999c
md"""  * A set of $x$ values are created between $a$ and $b$.
  * A corresponding set of $y$ values are created.
  * The pairs $(x,y)$ are plotted as points and connected with straight lines.
"""

# ╔═╡ 57728d24-53c0-11ec-18d6-fd8b11856fb5
md"""The only real difference is that when drawing by hand, we might know to curve the lines connecting points based on an analysis of the function. As `Julia` doesn't consider this, the points are connected with straight lines – like a dot-to-dot puzzle.
"""

# ╔═╡ 57728d40-53c0-11ec-2aec-8d5d470c3228
md"""The plotting directive `plot(f, xmin, xmax)` calls an adaptive algorithm to use more points where needed, as judged by `PlotUtils.adapted_grid(f, (xmin, xmax))`. The is wrapped up into the `unzip(f, xmin, xmax)` function from `CalculusWithJulia`.  The algorithm adds more points where the function is more "curvy" and uses fewer points where it is "straighter." Here we see the linear function is identified as needing far fewer points than the oscillating function when plotted over the same range:
"""

# ╔═╡ 5772ad9a-53c0-11ec-2bda-3bde71fe051a
begin
	pts_needed(f, xmin, xmax) = length(unzip(f, xmin, xmax)[1])
	pts_needed(x -> 10x, 0, 10), pts_needed(x -> sin(10x), 0, 10)
end

# ╔═╡ 5772ade0-53c0-11ec-0764-a33f5072cf77
md"""(In fact, the `21` is the minimum number of points used for any function; a linear function only needs two.)
"""

# ╔═╡ 5772ae4e-53c0-11ec-231f-87c1eaa0e731
md"""##### Example
"""

# ╔═╡ 5772ae76-53c0-11ec-0e54-bd2bb08239de
md"""This demo shows more points are needed as the function becomes more "curvy." There are the minimum of $21$ for a straight line, $37$ for a half period, $45$ for a full period, etc.
"""

# ╔═╡ 5772b268-53c0-11ec-0b51-d7d5f3443519
md"""
n = $(@bind 𝐧 Slider(0:20, default=1))
"""

# ╔═╡ 5772d55e-53c0-11ec-194f-674a37f4e05b
let
	xs,ys = unzip(x -> sin(𝐧*x*pi), 0, 1)
	plot(xs, ys, title="n=$(length(xs))")
	scatter!(xs, ys)
end

# ╔═╡ 5772d586-53c0-11ec-1d1c-1966e998c9c5
md"""---
"""

# ╔═╡ 5772d5f4-53c0-11ec-3605-a5354aaf9650
md"""For instances where a *specific* set of $x$ values is desired to be used, the `range` function or colon operator can be used to create the $x$ values and broadcasting used to create the $y$ values. For example, if we were to plot $f(x) = \sin(x)$ over $[0,2\pi]$ using $10$ points, we might do:
"""

# ╔═╡ 5772e026-53c0-11ec-0c1d-451541ffccfa
begin
	𝒙s = range(0, 2pi, length=10)
	𝒚s = sin.(𝒙s)
end

# ╔═╡ 5772e062-53c0-11ec-17a6-0faf64867b62
md"""Finally, to plot the set of points and connect with lines. If the collection of points are specified in place of a function, the graph is produced:
"""

# ╔═╡ 5772e51c-53c0-11ec-27c6-55a2869f7de7
plot(𝒙s, 𝒚s)

# ╔═╡ 5772e54e-53c0-11ec-3305-3b7aa6f9f2e2
md"""This plots the points as pairs and then connects them in order using straight lines. Basically, it creates a dot-to-dot graph. The above graph looks primitive, as it doesn't utilize enough points.
"""

# ╔═╡ 5772e580-53c0-11ec-3e3c-6f51a7b4e9b9
md"""##### Example: Reflections
"""

# ╔═╡ 5772e5c6-53c0-11ec-2f57-c72802c61010
md"""The graph of a function may be reflected through a line, as those seen with a mirror. For example, a reflection through the $y$ axis takes a point $(x,y)$ to the point $(-x, y)$. We can easily see this graphically, when we have sets of $x$ and $y$ values through a judiciously placed minus sign.
"""

# ╔═╡ 5772e5e4-53c0-11ec-3fb9-05117ad96314
md"""For example, to plot $\sin(x)$ over $(-\pi,\pi)$ we might do:
"""

# ╔═╡ 5772edaa-53c0-11ec-1fd9-5d7e274e09fd
begin
	xs = range(-pi, pi, length=100)
	ys = sin.(xs)
	plot(xs, ys)
end

# ╔═╡ 5772ede6-53c0-11ec-21ad-d147228f737c
md"""To reflect this graph through the $y$ axis, we only need to plot `-xs` and not `xs`:
"""

# ╔═╡ 5772eff6-53c0-11ec-2c43-8deb15a18a85
plot(-xs, ys)

# ╔═╡ 5772f00c-53c0-11ec-1d39-198b808ffa41
md"""Looking carefully we see there is a difference. (How?)
"""

# ╔═╡ 5772f020-53c0-11ec-1af7-bbdd4177b04e
md"""There are four very common reflections:
"""

# ╔═╡ 5772f124-53c0-11ec-04c2-596d33fa8606
md"""  * reflection through the $y$-axis takes $(x,y)$ to $(-x, y)$.
  * reflection through the $x$-axis takes $(x,y)$ to $(x, -y)$.
  * reflection through the origin takes $(x,y)$ to $(-x, -y)$.
  * reflection through the line $y=x$ takes $(x,y)$ to $(y,x)$.
"""

# ╔═╡ 5772f142-53c0-11ec-08a0-394c0e0cb430
md"""For the $\sin(x)$ graph, we see that reflecting through the $x$ axis produces the same graph as reflecting through the $y$ axis:
"""

# ╔═╡ 5772f480-53c0-11ec-0c4e-4f2e461681a6
plot(xs, -ys)

# ╔═╡ 5772f4b2-53c0-11ec-18b5-870c5423b358
md"""However, reflecting through the origin leaves this graph unchanged:
"""

# ╔═╡ 5772f7f0-53c0-11ec-2de3-1f45fae752d6
plot(-xs,  -ys)

# ╔═╡ 5772f91c-53c0-11ec-3f28-4b3eae3204a8
md"""> An *even function* is one where reflection through the $y$ axis leaves the graph unchanged. That is, $f(-x) = f(x)$.  An *odd function* is one where a reflection through the origin leaves the graph unchanged, or symbolically $f(-x) = -f(x)$.

"""

# ╔═╡ 5772f94e-53c0-11ec-0590-affa25eabba2
md"""If we try reflecting the graph of $\sin(x)$ through the line $y=x$, we have:
"""

# ╔═╡ 5772fb76-53c0-11ec-3196-8bf1eb5b45c6
plot(ys, xs)

# ╔═╡ 5772fbe2-53c0-11ec-379a-bd8e0a6de06b
md"""This is the graph of the equation $x = \sin(y)$, but is not the graph of a function as the same $x$ can map to more than one $y$ value. (The new graph does not pass the "vertical line" test.)
"""

# ╔═╡ 5772fbf6-53c0-11ec-15a9-233f9f174dd6
md"""However, for the sine function we can get a function from this reflection if we choose a narrower viewing window:
"""

# ╔═╡ 57730330-53c0-11ec-221a-cbad6f54272c
let
	xs = range(-pi/2, pi/2, length=100)
	ys = sin.(xs)
	plot(ys, xs)
end

# ╔═╡ 57730358-53c0-11ec-3a74-232cd60003fc
md"""The graph is that of the "inverse function" for $\sin(x), x \text{ in } [-\pi/2, \pi/2]$.
"""

# ╔═╡ 577303da-53c0-11ec-18ac-41009d7bd4e3
md"""#### The `plot(xs, f)` syntax
"""

# ╔═╡ 577303f8-53c0-11ec-232f-59ee14d91238
md"""When plotting a univariate function there are three basic patterns that can be employed. We have examples above of:
"""

# ╔═╡ 577304a2-53c0-11ec-36b0-19aeb8e1bdd4
md"""  * `plot(f, xmin, xmax)` uses an adaptive algorithm to identify values for $x$ in the interval `[xmin, xmas]`,
  * `plot(xs, f.(xs))` to manually choose the values of $x$ to plot points for, and
"""

# ╔═╡ 577304ac-53c0-11ec-08c5-d986c3f2487f
md"""Finally there is a merging of these following either of these patterns:
"""

# ╔═╡ 577304f2-53c0-11ec-1945-f9113fb5ee22
md"""  * `plot(f, xs)` *or*  `plot(xs, f)`
"""

# ╔═╡ 57730510-53c0-11ec-2779-b7e994b77403
md"""Both require a manual choice of the values of the $x$-values to plot, but the broadcasting is carried out in the `plot` command. This style is convenient, for example, to down sample the $x$ range to see the plotting mechanics, such as:
"""

# ╔═╡ 57730a10-53c0-11ec-2be0-2fb43a570814
plot(0:pi/4:2pi, sin)

# ╔═╡ 57730a2e-53c0-11ec-099d-6168ff29dca2
md"""#### NaN values
"""

# ╔═╡ 57730a56-53c0-11ec-2981-0377e0fe196b
md"""At times it is not desirable to draw lines between each succesive point. For example, if there is a discontinuity in the function or if there were a vertical asymptote, such as what happens at $0$ with $f(x) = 1/x$.
"""

# ╔═╡ 57730a6a-53c0-11ec-22a6-91d4b221e6d6
md"""The most straightforward plot is dominated by the vertical asymptote at $x=0$:
"""

# ╔═╡ 577310bc-53c0-11ec-1b70-a79afe818364
begin
	q(x) = 1/x
	plot(q, -1, 1)
end

# ╔═╡ 57731104-53c0-11ec-2ed2-43cec9139b26
md"""We can attempt to improve this graph by adjusting the viewport. The *viewport* of a graph is the $x$-$y$ range of the viewing window.  By default, the $y$-part of the viewport is determined by the range of the function over the specified interval, $[a,b]$. As just seen, this approach can produce poor graphs.  The `ylims=(ymin, ymax)` argument can modify what part of the $y$ axis is shown. (Similarly `xlims=(xmin, xmax)` will modify the viewport in the $x$ direction.)
"""

# ╔═╡ 57731118-53c0-11ec-10fb-699cd987e57b
md"""As we see, even with this adjustment, the spurious line connecting the points with $x$ values closest to $0$ is still drawn:
"""

# ╔═╡ 57732f0e-53c0-11ec-03a4-e508e4b51c07
plot(q, -1, 1, ylims=(-10,10))

# ╔═╡ 57732f54-53c0-11ec-26c8-ddbb82065ef1
md"""The dot-to-dot algorithm, at some level, assumes the underlying function is continuous; here $q(x)=1/x$ is not.
"""

# ╔═╡ 57732fae-53c0-11ec-07ab-294270d21084
md"""There is a convention for most plotting programs that **if** the $y$ value for a point is `NaN` that no lines will connect to that point, `(x,NaN)`. `NaN` conveniently appears in many cases where a plot may have an issue, though not with $1/x$ as `1/0` is `Inf` and not `NaN`. (Unlike, say, `0/0` which is NaN.)
"""

# ╔═╡ 57732fcc-53c0-11ec-2a18-0d7d6778d01c
md"""Here is one way to plot $q(x) = 1/x$ over $[-1,1]$ taking advantage of this convention:
"""

# ╔═╡ 57733648-53c0-11ec-3996-07abe045c210
let
	xs = range(-1, 1, length=251)
	ys = q.(xs)
	ys[xs .== 0.0] .= NaN
	plot(xs, ys)
end

# ╔═╡ 57733684-53c0-11ec-02fa-e17155f690ce
md"""By using an odd number of points, we should have that $0.0$ is amongst the `xs`. The next to last line replaces the $y$ value that would be infinite with `NaN`.
"""

# ╔═╡ 577336a2-53c0-11ec-282d-49fa0200f3ec
md"""As a recommended alternative, we might modify the function so that if it is too large, the values are replaced by `NaN`. Here is one such function consuming a function and returning a modified function put to use to make this graph:
"""

# ╔═╡ 577344b2-53c0-11ec-0b4a-95f304cf1ebb
begin
	rangeclamp(f, hi=20, lo=-hi; replacement=NaN) = x -> lo < f(x) < hi ? f(x) : replacement
	plot(rangeclamp(x -> 1/x), -1, 1)
end

# ╔═╡ 577344ee-53c0-11ec-30b7-e36928df5761
md"""(The `clamp` function is a base `Julia` function which clamps a number between `lo` and `hi`, returning `lo` or `hi` if `x` is outside that range.)
"""

# ╔═╡ 57734516-53c0-11ec-231f-0f7144d8befa
md"""## Layers
"""

# ╔═╡ 57734534-53c0-11ec-0cf3-dbea76d7d01e
md"""Graphing more than one function over the same viewing window is often desirable. Though this is easily done in `Plots` by specifying a vector of functions as the first argument to `plot` instead of a single function object, we instead focus on building the graph layer by layer.
"""

# ╔═╡ 57734566-53c0-11ec-2461-f1d2c949e04e
md"""For example, to see that the polynomial and the cosine function are "close" near $0$, we can plot *both* $\cos(x)$ and the function $f(x) = 1 - x^2/2$ over $[-\pi/2,\pi/2]$:
"""

# ╔═╡ 57734b1a-53c0-11ec-3902-6dba041f9356
let
	f(x) = 1 - x^2/2
	plot(cos, -pi/2, pi/2, label="cos")
	plot!(f, -pi/2, pi/2, label="f")
end

# ╔═╡ 57734b56-53c0-11ec-1574-a9bb4c87a8df
md"""Another useful function to add to a plot is one to highlight the $x$ axis. This makes identifying zeros of the function easier. The anonymous function `x -> 0` will do this. But, perhaps less cryptically, so will the base function `zero`. For example
"""

# ╔═╡ 57735080-53c0-11ec-0c2d-7d6fa4f88c11
let
	f(x) = x^5 - x + 1
	plot(f, -1.5, 1.4, label="f")
	plot!(zero, label="zero")
end

# ╔═╡ 577350b2-53c0-11ec-1086-690972e54869
md"""(The job of `zero` is to return "$0$" in the appropriate type. There is also a similar `one` function in base `Julia`.)
"""

# ╔═╡ 577350ce-53c0-11ec-1a1f-c57a8f55f0c2
md"""The `plot!` call adds a layer. We could still specify the limits for the plot, though as this can be computed from the figure, to plot `zero` we let `Plots` do it.
"""

# ╔═╡ 577350f6-53c0-11ec-3cdf-3f2733beba34
md"""For another example, suppose we wish to plot the function $f(x)=x\cdot(x-1)$ over the interval $[-1,2]$ and emphasize with points the fact that $0$ and $1$ are zeros. We can do this with three layers: the first to graph the function, the second to emphasize the $x$ axis, the third to graph the points.
"""

# ╔═╡ 5773565a-53c0-11ec-27fb-1be16ae80012
let
	f(x) = x*(x-1)
	plot(f, -1, 2, legend=false)   # turn off legend
	plot!(zero)
	scatter!([0,1], [0,0])
end

# ╔═╡ 5773566e-53c0-11ec-30c9-136997f0f142
md"""The 3 main functions used in these notes for adding layers are:
"""

# ╔═╡ 57735736-53c0-11ec-1f32-87e341d2a242
md"""  * `plot!(f, a, b)` to add the graph of the function `f`; also `plot!(xs, ys)`
  * `scatter!(xs, ys)` to add points $(x_1, y_1), (x_2, y_2), \dots$.
  * `annotate!((x,y, label))` to add a label at $(x,y)$
"""

# ╔═╡ 57736490-53c0-11ec-138c-6142b2ce7a0d
alert("""

Julia has a convention to use functions named with a `!` suffix to
indicate that they mutate some object. In this case, the object is the
current graph, though it is implicit. Both `plot!`, `scatter!`, and
`annotate!` (others too) do this by adding a layer.

""")

# ╔═╡ 577364ce-53c0-11ec-3733-a56384bcf96c
md"""### Additional arguments to adjust a graphic
"""

# ╔═╡ 57736514-53c0-11ec-27bf-81c7990ffa6e
md"""The `Plots` package provides many arguments for adjusting a graphic, here we mention just a few of the [attributes](https://docs.juliaplots.org/latest/attributes/):
"""

# ╔═╡ 577366b8-53c0-11ec-03b2-8dcaa39ecb48
md"""  * `plot(..., title="main title", xlab="x axis label", ylab="y axis label")`: add title and label information to a graphic
  * `plot(..., color="green")`: this argument can be used to adjust the color of the drawn figure (color can be a string,`"green"`, or a symbol, `:green`, among other specifications)
  * `plot(..., linewidth=5)`: this argument can be used to adjust the width of drawn lines
  * `plot(..., xlims=(a,b), ylims=(c,d)`: either or both `xlims` and `ylims` can be used to control the viewing window
  * `plot(..., linestyle=:dash)`: will change the line style of the plotted lines to dashed lines. Also `:dot`, ...
  * `plot(..., aspect_ratio=:equal)`: will keep $x$ and $y$ axis on same scale so that squares look square.
  * `plot(..., legend=false)`: by default, different layers will be indicated with a legend, this will turn off this feature
  * `plot(..., label="a label")` the `label` attribute will show up when a legend is present.
"""

# ╔═╡ 577366e0-53c0-11ec-3f34-c56ab51c17ac
md"""For plotting points with `scatter` or `scatter!` the markers can be adjusted via
"""

# ╔═╡ 5773672e-53c0-11ec-2737-9f14663c479b
md"""  * `scatter(..., markersize=5)`: increase marker size
  * `scatter(..., marker=:square)`: change the marker (uses a symbol, not a string to specify)
"""

# ╔═╡ 5773674e-53c0-11ec-0ad0-a93dbd16e635
md"""Of course, zero, one, or more of these can be used on any given call to `plot`, `plot!`, `scatter` or `scatter!`.
"""

# ╔═╡ 57736760-53c0-11ec-1fed-398965c502ec
md"""## Parametric graphs
"""

# ╔═╡ 5773679e-53c0-11ec-1577-6d8b5cc758b1
md"""If we have two functions $f(x)$ and $g(x)$ there are a few ways to investigate their joint behaviour. As just mentioned, we can graph both $f$ and $g$ over the same interval using layers. Such a graph allows an easy comparison of the shape of the two functions and can be useful in solving $f(x) = g(x)$. For the latter, the graph of $h(x) = f(x) - g(x)$ is also of value: solutions to $f(x)=g(x)$ appear as crossing points on the graphs of `f` and `g`, whereas they appear as zeros (crossings of the $x$-axis) when `h` is plotted.
"""

# ╔═╡ 577367bc-53c0-11ec-1d9a-1d87b89fa144
md"""A different graph can be made to compare the two functions side-by-side. This is a parametric plot. Rather than plotting points $(x,f(x))$ and $(x,g(x))$ with two separate graphs, the graph consists of points $(f(x), g(x))$. We illustrate with some examples below:
"""

# ╔═╡ 577367da-53c0-11ec-24e6-a956f24f8846
md"""##### Example
"""

# ╔═╡ 5773683e-53c0-11ec-1012-ff0d754930ba
md"""The most "famous" parametric graph is one that is likely already familiar, as it follows the parametrization of points on the unit circle by the angle made between the $x$ axis and the ray from the origin through the point. (If not familiar, this will soon be discussed in these notes.)
"""

# ╔═╡ 57739aca-53c0-11ec-39a5-951d0b73379f
begin
	𝒇(x) = cos(x); 𝒈(x) = sin(x)
	𝒕s = range(0, 2pi, length=100)
	plot(𝒇.(𝒕s), 𝒈.(𝒕s), aspect_ratio=:equal)   # make equal axes
end

# ╔═╡ 57739b2e-53c0-11ec-01fe-010a5e2c5b50
md"""Any point $(a,b)$ on this graph is represented by $(\cos(t), \sin(t))$ for some value of $t$, and in fact multiple values of $t$, since $t + 2k\pi$ will produce the same $(a,b)$ value as $t$ will.
"""

# ╔═╡ 57739b56-53c0-11ec-2f59-ab3b92ab1ede
md"""Making the parametric plot is similar to creating a plot using lower level commands. There  a sequence of values is generated to approximate the $x$ values in the graph (`xs`), a set of commands to create the corresponding function values (e.g., `f.(xs)`), and some instruction on how to represent the values, in this case with lines connecting the points (the default for `plot` for two sets of numbers).
"""

# ╔═╡ 57739b9c-53c0-11ec-2582-0b41204c1de3
md"""In this next plot, the angle values are chosen to be the familiar ones, so the mechanics of the graph can be emphasized. Only the upper half is plotted:
"""

# ╔═╡ 5773c72a-53c0-11ec-327a-9ff6ba2db2b5
let
	θs =[0, PI/6, PI/4, PI/3, PI/2, 2PI/3, 3PI/4,5PI/6, PI]
	DataFrame(θ=θs, x=cos.(θs), y=sin.(θs))
end

# ╔═╡ 5773eadc-53c0-11ec-0333-c15962107732
let
	θs =[0, pi/6, pi/4, pi/3, pi/2, 2pi/3, 3pi/4, 5pi/6, pi]
	plot(𝒇.(θs), 𝒈.(θs), legend=false, aspect_ratio=:equal)
	scatter!(𝒇.(θs), 𝒈.(θs))
end

# ╔═╡ 5773eb1a-53c0-11ec-36af-91bd4626c598
md"""---
"""

# ╔═╡ 5773eb38-53c0-11ec-3d03-f3c0168ed40b
md"""As with the plot of a univariate function, there is a convenience interface for these plots - just pass the two functions in:
"""

# ╔═╡ 5773f0f6-53c0-11ec-0eb5-21118c905d50
plot(𝒇, 𝒈, 0, 2pi, aspect_ratio=:equal)

# ╔═╡ 5773f114-53c0-11ec-00ad-5b19b7aee4e7
md"""##### Example
"""

# ╔═╡ 5773f146-53c0-11ec-3a11-fd88a5382efa
md"""Looking at growth. Comparing $x^2$ with $x^3$ can run into issues, as the scale gets big:
"""

# ╔═╡ 5773f5d8-53c0-11ec-25de-150bf8484f22
begin
	x²(x) = x^2
	x³(x) = x^3
	plot(x², 0, 25)
	plot!(x³, 0, 25)
end

# ╔═╡ 5773f61e-53c0-11ec-3289-9d32588fff72
md"""In the above, `x³` is already $25$ times larger on the scale of $[0,25]$ and this only gets worse if the viewing window were to get larger. However, the parametric graph is quite different:
"""

# ╔═╡ 5773f95e-53c0-11ec-0196-b76c89147bd3
plot(x², x³, 0, 25)

# ╔═╡ 5773f984-53c0-11ec-3d46-3515da287b4a
md"""In this graph, as $x^3/x^2 = x$, as $x$ gets large, the ratio stays reasonable.
"""

# ╔═╡ 5773f998-53c0-11ec-2eb0-dd3cc86cf0a7
md"""##### Example
"""

# ╔═╡ 5773f9be-53c0-11ec-2d1b-9f86a1bc5d81
md"""Parametric plots are useful to compare the ratio of values near a point. In the above example, we see how this is helpful for large `x`. This example shows it is convenient for a fixed `x`, in this case `x=0`.
"""

# ╔═╡ 5773f9de-53c0-11ec-10fd-35a82d737597
md"""Plot $f(x) = x^3$ and $g(x) = x - \sin(x)$ around $x=0$:
"""

# ╔═╡ 5773fdd0-53c0-11ec-2e71-856851b4945c
let
	f(x) = x^3
	g(x) = x - sin(x)
	plot(f, g, -pi/2, pi/2)
end

# ╔═╡ 5773fe16-53c0-11ec-2b08-9534cbb40bc6
md"""This graph is *nearly* a straight line. At the point $(0,0)=(g(0), g(0))$, we see that both functions are behaving in a similar manner, though the slope is not $1$, so they do not increase at exactly the same rate.
"""

# ╔═╡ 5773fe28-53c0-11ec-147b-3918be065735
md"""##### Example: Etch A Sketch
"""

# ╔═╡ 5773fe5c-53c0-11ec-1a12-3593da8cc03e
md"""[Etch A sketch](http://en.wikipedia.org/wiki/Etch_A_Sketch) is a drawing toy where two knobs control the motion of a pointer, one knob controlling the $x$ motion, the other the $y$ motion. The trace of the movement of the pointer is recorded until the display is cleared by shaking. Shake to clear is now a motion incorporated by some smart-phone apps.
"""

# ╔═╡ 5773fe70-53c0-11ec-2c2c-6f44cbe68e68
md"""Playing with the toy makes a few things become clear:
"""

# ╔═╡ 5773ffd8-53c0-11ec-14cc-633cb5350c57
md"""  * Twisting just the left knob (the horizontal or $x$ motion) will move the pointer left or right, leaving a horizontal line. Parametrically, this would follow the equations $f(t) = \xi(t)$ for some $\xi$ and $g(t) = c$.
  * Twisting just the right knob (the vertical or $y$ motion) will move the pointer up or down, leaving a vertical line.  Parametrically, this would follow the equations $f(t) = c$  and $g(t) = \psi(t)$ for some $\psi$.
  * Drawing a line with a slope different from $0$ or $\infty$ requires moving both knobs at the same time. A 45$^\circ$ line with slope $m=1$ can be made by twisting both at the same rate, say through $f(t) = ct$, $g(t)=ct$. It doesn't matter how big $c$ is, just that it is the same for both $f$ and $g$. Creating a different slope is done by twisting at different rates, say $f(t)=ct$ and $g(t)=dt$. The slope of the resulting line will be $d/c$.
  * Drawing a curve is done by twisting the two knobs with varying rates.
"""

# ╔═╡ 5773fff6-53c0-11ec-3484-817772d9e4ad
md"""These all apply to parametric plots, as the Etch A Sketch trace is no more than a plot of $(f(t), g(t))$ over some range of values for $t$, where $f$ describes the movement in time of the left knob and $g$ the movement in time of the right.
"""

# ╔═╡ 5774001e-53c0-11ec-357e-39635b646aba
md"""Now, we revist the last problem in the context of this. We saw in the last problem that the parametric graph was nearly a line - so close the eye can't really tell otherwise. That means that the growth in  both $f(t) = t^3$ and $g(t)=t - \sin(t)$ for $t$ around $0$ are in a nearly fixed ratio, as otherwise the graph would have more curve in it.
"""

# ╔═╡ 57740034-53c0-11ec-3f5e-21a11d595751
md"""##### Example: Spirograph
"""

# ╔═╡ 57740078-53c0-11ec-1a53-a544edc77112
md"""Parametric plots can describe a richer set of curves than can plots of functions. Plots of functions must pass the "vertical-line test", as there can be at most one $y$ value for a given $x$ value. This is not so for parametric plots, as the circle example above shows. Plotting sines and cosines this way is the basis for the once popular [Spirograph](http://en.wikipedia.org/wiki/Spirograph#Mathematical_basis) toy. The curves drawn there are parametric plots where the functions come from rolling a smaller disc either around the outside or inside of a larger disc.
"""

# ╔═╡ 5774008c-53c0-11ec-0b75-11b4afa33f30
md"""Here is an example using a parameterization provided on the Wikipedia page where $R$ is the radius of the larger disc, $r$ the radius of the smaller disc and $\rho < r$ indicating the position of the pencil within the smaller disc.
"""

# ╔═╡ 577408ac-53c0-11ec-241b-059d8d01f7b7
let
	R, r, rho = 1, 1/4, 1/4
	f(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
	g(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)
	
	plot(f, g, 0, max((R-r)/r, r/(R-r))*2pi)
end

# ╔═╡ 577408fc-53c0-11ec-1855-ffc83059ffa7
md"""In the above, one can fix $R=1$. Then different values for `r` and `rho` will produce different graphs. These graphs will be periodic if $(R-r)/r$ is a rational. (Nothing about these equations requires $\rho < r$.)
"""

# ╔═╡ 57740910-53c0-11ec-0ad6-09f6ab549bf7
md"""## Questions
"""

# ╔═╡ 5774097e-53c0-11ec-24c1-fb39c16bc8ac
md"""###### Question
"""

# ╔═╡ 577409a8-53c0-11ec-2bd6-a588403309cd
md"""Plot the function $f(x) = x^3 - x$. When is the function positive?
"""

# ╔═╡ 57741270-53c0-11ec-2def-91892858cbe3
let
	choices = ["`(-Inf, -1)` and `(0,1)`",
		"`(-Inf, -0.577)` and `(0.577, Inf)`",
		"`(-1, 0)` and `(1, Inf)`"
		];
	ans=3;
	radioq(choices, ans)
end

# ╔═╡ 5774128e-53c0-11ec-102d-a53fa156c841
md"""###### Question
"""

# ╔═╡ 577412c0-53c0-11ec-13d5-e53593d43ed6
md"""Plot the function $f(x) = 3x^4 + 8x^3 - 18x^2$. Where (what $x$ value) is the smallest value? (That is, for which input $x$ is the output $f(x)$ as small as possible.
"""

# ╔═╡ 57742fbc-53c0-11ec-2172-3d6ac60100eb
let
	f(x) = 3x^4 + 8x^3 - 18x^2
	val = -3;
	numericq(val, 0.25)
end

# ╔═╡ 57742fee-53c0-11ec-1c4f-e7945378f977
md"""###### Question
"""

# ╔═╡ 57743016-53c0-11ec-34c2-0536d5d87032
md"""Plot the function $f(x) = 3x^4 + 8x^3 - 18x^2$. When is the function increasing?
"""

# ╔═╡ 577438de-53c0-11ec-175e-3d5f0e6c25c9
let
	choices = ["`(-Inf, -3)` and `(0, 1)`",
		"`(-3, 0)` and `(1, Inf)`",
		"`(-Inf, -4.1)` and `(1.455, Inf)`"
		];
	ans=2;
	radioq(choices, ans)
end

# ╔═╡ 577438fe-53c0-11ec-1774-0b42014bd726
md"""###### Question
"""

# ╔═╡ 57743958-53c0-11ec-295e-1b4f599159ae
md"""Graphing both `f` and the line $y=0$  helps focus on the *zeros* of `f`. When `f(x)=log(x)-2`, plot `f` and the line $y=0$.  Identify the lone zero.
"""

# ╔═╡ 57743ff2-53c0-11ec-1aaa-b390762926a0
let
	val = find_zero(x -> log(x) - 2, 8)
	numericq(val, .5)
end

# ╔═╡ 57744010-53c0-11ec-3de4-abdefb9108ac
md"""###### Question
"""

# ╔═╡ 57744038-53c0-11ec-34f4-a92e3ec6f454
md"""Plot the function $f(x) = x^3 - x$ over $[-2,2]$. How many zeros are there?
"""

# ╔═╡ 5774439e-53c0-11ec-0203-4345fb1254c5
let
	val = 3;
	numericq(val, 1e-16)
end

# ╔═╡ 577443b2-53c0-11ec-186c-c799707c77ff
md"""###### Question
"""

# ╔═╡ 577443e4-53c0-11ec-2ee1-83b2e672fa95
md"""The function $f(x) = (x^3 - 2x) / (2x^2 -10)$ is a rational function with issues when $2x^2 = 10$, or $x = -\sqrt{5}$ or $\sqrt{5}$.
"""

# ╔═╡ 57744402-53c0-11ec-2a54-65bacb6819e5
md"""Plot this function from $-5$ to $5$. How many times does it cross the $x$ axis?
"""

# ╔═╡ 57744760-53c0-11ec-149c-cf0c8c95dd9c
let
	val = 3;
	numericq(val, .2)
end

# ╔═╡ 5774477c-53c0-11ec-26e0-cf334ab3b40a
md"""###### Question
"""

# ╔═╡ 577447d6-53c0-11ec-070a-d73608199cd7
md"""A trash collection plan charges a flat rate of 35 dollars a month for the first 10 bags of trash and is 4 dollars a bag thereafter. Which function will model this:
"""

# ╔═╡ 57745226-53c0-11ec-38af-b30d79e0d1ca
let
	choices = [
	"`f(x) = x <= 35.0 ? 10.0 : 10.0 + 35.0 * (x-4)`",
	"`f(x) = x <= 4    ? 35.0 : 35.0 + 10.0 * (x-4)`",
	"`f(x) = x <= 10   ? 35.0 : 35.0 +  4.0 * (x-10)`"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 57745244-53c0-11ec-09fc-2550baee9db0
md"""Make a plot of the model. Graphically estimate how many bags of trash will cost 55 dollars.
"""

# ╔═╡ 577455aa-53c0-11ec-3cb1-1da78e25dc6f
let
	ans = 15
	numericq(ans, .5)
end

# ╔═╡ 577455c8-53c0-11ec-1cbd-f52d4791e4f0
md"""###### Question
"""

# ╔═╡ 577455fa-53c0-11ec-2ece-1501416f92d3
md"""Plot the functions $f(x) = \cos(x)$ and $g(x) = x$. Estimate the $x$ value of where the two graphs intersect.
"""

# ╔═╡ 57745bb8-53c0-11ec-0b44-d1bbe61859a6
let
	val = find_zero(x -> cos(x) -x, .7)
	numericq(val, .25)
end

# ╔═╡ 57745bd6-53c0-11ec-2a54-c3bb8f8a1eb8
md"""###### Question
"""

# ╔═╡ 57745c14-53c0-11ec-2423-331db55851ba
md"""The fact that only a finite number of points are used in a graph can introduce artifacts. An example can appear when plotting [sinusoidal](http://en.wikipedia.org/wiki/Aliasing#Sampling_sinusoidal_functions) functions. An example is the graph of `f(x) = sin(500*pi*x)` over `[0,1]`.
"""

# ╔═╡ 57745c26-53c0-11ec-1efa-53b2e13336e6
md"""Make its graph using 250 evenly spaced points, as follows:
"""

# ╔═╡ 57745c58-53c0-11ec-0268-db311c868357
md"""```
xs = range(0, 1, length=250)
f(x) = sin(500*pi*x)
plot(xs, f.(xs))
```"""

# ╔═╡ 57745c6c-53c0-11ec-1b32-cb0da1c64d0c
md"""What is seen?
"""

# ╔═╡ 57746a36-53c0-11ec-3faa-e3bad7c21da6
let
	choices = [L"It oscillates wildly, as the period is $T=2\pi/(500 \pi)$ so there are 250 oscillations.",
		"It should oscillate evenly, but instead doesn't oscillate very much near 0 and 1",
		L"Oddly, it looks exactly like the graph of $f(x) = \sin(2\pi x)$."]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 57746a5e-53c0-11ec-2d8d-a957ab6c203c
md"""The algorithm to plot a function works to avoid aliasing issues. Does the graph generated by `plot(f, 0, 1)` look the same, as the one above?
"""

# ╔═╡ 577474e0-53c0-11ec-36d3-db9857138801
let
	choices = ["Yes",
	"No, but is still looks pretty bad, as fitting 250 periods into a too small number of pixels is a problem.",
	"No, the graph shows clearly all 250 periods."
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 57747500-53c0-11ec-2134-791a28fd5a39
md"""###### Question
"""

# ╔═╡ 57747526-53c0-11ec-2d1b-43d6233a6ec4
md"""Make this parametric plot for the specific values of the parameters `k` and `l`. What shape best describes it?
"""

# ╔═╡ 5774754e-53c0-11ec-0037-6169f9f85f32
md"""```
R, r, rho = 1, 3/4, 1/4
f(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
g(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)

plot(f, g, 0, max((R-r)/r, r/(R-r))*2pi, aspect_ratio=:equal)
```"""

# ╔═╡ 57747e18-53c0-11ec-1aab-e74ad3103c23
let
	choices = [
	"Four sharp points, like a star",
	"Four petals, like a flower",
	"An ellipse",
	"A straight line"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 57747e36-53c0-11ec-1997-ef687561ad52
md"""###### Question
"""

# ╔═╡ 57747e4a-53c0-11ec-3023-0dadb20a2398
md"""For these next questions, we use this function:
"""

# ╔═╡ 577494fc-53c0-11ec-0d9e-5bd71418a661
function spirograph(R, r, rho)
  f(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
  g(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)

  plot(f, g, 0, max((R-r)/r, r/(R-r))*2pi, aspect_ratio=:equal)
end

# ╔═╡ 57749538-53c0-11ec-1e2a-e96e47c55efc
md"""Make this plot for the following specific values of the parameters `R`, `r`, and `rho`. What shape best describes it?
"""

# ╔═╡ 5774956a-53c0-11ec-0578-f5e1e5222838
md"""```
R, r, rho = 1, 3/4, 1/4
```"""

# ╔═╡ 57749f9a-53c0-11ec-2533-c1351533f2e4
let
	choices = [
	"Four sharp points, like a star",
	"Four petals, like a flower",
	"An ellipse",
	"A straight line",
	"None of the above"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 57749fcc-53c0-11ec-3d7d-179bd7993c97
md"""Make this plot for the following specific values of the parameters `R`, `r`, and `rho`. What shape best describes it?
"""

# ╔═╡ 57749ff6-53c0-11ec-0d53-4d2a147d5ba2
md"""```
R, r, rho = 1, 1/2, 1/4
```"""

# ╔═╡ 5774a9d8-53c0-11ec-34f4-cdbb389d4ade
let
	choices = [
	"Four sharp points, like a star",
	"Four petals, like a flower",
	"An ellipse",
	"A straight line",
	"None of the above"
	]
	ans = 3
	radioq(choices, ans,keep_order=true)
end

# ╔═╡ 5774aa0a-53c0-11ec-149d-e95cdb97bd7f
md"""Make this plot for the specific values of the parameters `R`, `r`, and `rho`. What shape best describes it?
"""

# ╔═╡ 5774aa32-53c0-11ec-01be-4ba27bc80ca2
md"""```
R, r, rho = 1, 1/4, 1
```"""

# ╔═╡ 5774b3f6-53c0-11ec-0c29-9f13d8ccde9c
let
	choices = [
	"Four sharp points, like a star",
	"Four petals, like a flower",
	"A circle",
	"A straight line",
	"None of the above"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 5774b420-53c0-11ec-29de-a7853636cba3
md"""Make this plot for the specific values of the parameters `R`, `r`, and `rho`. What shape best describes it?
"""

# ╔═╡ 5774b446-53c0-11ec-18e9-ebdd646da04d
md"""```
R, r, rho = 1, 1/8, 1/4
```"""

# ╔═╡ 5774beca-53c0-11ec-3a99-fdbfa53348a2
let
	choices = [
	"Four sharp points, like a star",
	"Four petals, like a flower",
	"A circle",
	"A straight line",
	"None of the above"
	]
	ans = 5
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 5774bef0-53c0-11ec-2387-8d17afc3ffed
md"""---
"""

# ╔═╡ 5774bf18-53c0-11ec-19d4-8fb3d0929c24
md"""### Technical note
"""

# ╔═╡ 5774bf40-53c0-11ec-1cd5-5d9fba02b55f
md"""The slow "time to first plot" in `Julia` is a well-known hiccup that is related to how `Julia` can be so fast. Loading Plots and the making the first plot are both somewhat time consuming, though the second and subsequent plots are speedy. Why?
"""

# ╔═╡ 5774bf7c-53c0-11ec-3d48-2b50b87ba374
md"""`Julia` is an interactive language that attains its speed by compiling functions on the fly using the [llvm](llvm.org) compiler. When `Julia` encounters a new combination of a function method and argument types it will compile and cache a function for subsequent speedy execution. The first plot is slow, as there are many internal functions that get compiled. This has sped up of late, as excessive recompilations have been trimmed down, but still has a way to go. This is different from "precompilation" which also helps trim down time for initial executions. There are also some more technically challenging means to create `Julia` images for faster start up that can be pursued if needed.
"""

# ╔═╡ 5774bfa4-53c0-11ec-2f97-3d1da4f55a6c
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/functions.html">◅ previous</a>  <a href="../precalc/transformations.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/plotting.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 5774bfb8-53c0-11ec-1923-5b1a98fcd431
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
DataFrames = "~1.2.2"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Roots = "~1.3.11"
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
# ╟─5774bf86-53c0-11ec-15ac-b90237305151
# ╟─5770d862-53c0-11ec-0518-7bb44845b034
# ╟─5770ef6e-53c0-11ec-2504-7993238cc233
# ╠═5771a184-53c0-11ec-26b7-5d3ab87dca60
# ╟─5771a710-53c0-11ec-3dd6-ff2ce3af6d3c
# ╟─5771a7d8-53c0-11ec-1383-c391799a5896
# ╟─5771a846-53c0-11ec-2c7e-7faec07b1929
# ╟─5771abac-53c0-11ec-1789-e1b5f1f157e3
# ╟─5771abca-53c0-11ec-27a3-47350abe52da
# ╟─5771abde-53c0-11ec-1b62-550813663f8f
# ╟─5771ac10-53c0-11ec-275d-6374a1199d3c
# ╟─5771ac24-53c0-11ec-1ab1-d31714f5b030
# ╟─5771ac4a-53c0-11ec-313f-7bc84ddf72eb
# ╟─5771ac9c-53c0-11ec-03c5-a1a76530b966
# ╟─5771ad00-53c0-11ec-39b6-95a54bdb4139
# ╟─5771ad28-53c0-11ec-23d4-5d529f3ef996
# ╟─5771f44c-53c0-11ec-24d3-3de6c89fa7d9
# ╟─5771f510-53c0-11ec-13b7-81ec8f382ad1
# ╟─5771f530-53c0-11ec-0599-b51ed3d4ce3a
# ╟─5771f558-53c0-11ec-0396-4fd37f9b9ba5
# ╠═5771fe5e-53c0-11ec-1215-b5abfeb64996
# ╟─5771fe90-53c0-11ec-3b12-431c056b266c
# ╟─5771ff94-53c0-11ec-2e50-d91f5a5c5f2d
# ╟─5771ffb2-53c0-11ec-0672-7f1e279a0f47
# ╟─577200a2-53c0-11ec-1471-8d6578db5662
# ╟─577208d6-53c0-11ec-2dde-9bed64a7587f
# ╟─577208f4-53c0-11ec-3ffb-b52abaf8a276
# ╟─57720912-53c0-11ec-329e-bdb219eb056d
# ╠═57720d18-53c0-11ec-2783-d773d0dbcbd2
# ╟─57720d4a-53c0-11ec-07b1-75f2ff833a88
# ╠═577213d0-53c0-11ec-0cdc-ab51e80de9f4
# ╟─577213f8-53c0-11ec-3c2e-338aca1eb1cd
# ╠═5772316c-53c0-11ec-1f9e-6d3561cdcb00
# ╟─577231e4-53c0-11ec-30aa-b9bac661eed5
# ╠═57724e4a-53c0-11ec-2abc-755efe1b392d
# ╟─57725b68-53c0-11ec-1577-af5089e1179f
# ╟─57725bd8-53c0-11ec-0ef1-3b1f112254ea
# ╠═57727a50-53c0-11ec-2bb9-cbee58f56a92
# ╟─57727aaa-53c0-11ec-0cd2-373547f84235
# ╟─57728590-53c0-11ec-134f-a30c4e3539c5
# ╟─577285cc-53c0-11ec-1ebe-b71bac6553e9
# ╟─57728606-53c0-11ec-06e5-155f5182db7f
# ╠═57728b26-53c0-11ec-2d66-f74c457c2e9b
# ╟─57728b46-53c0-11ec-1a83-cba31d6159d4
# ╟─57728b62-53c0-11ec-1fc3-ef47b83d91c4
# ╟─57728b8a-53c0-11ec-36ac-6db08423b609
# ╟─57728d06-53c0-11ec-111b-497233e3999c
# ╟─57728d24-53c0-11ec-18d6-fd8b11856fb5
# ╟─57728d40-53c0-11ec-2aec-8d5d470c3228
# ╠═5772ad9a-53c0-11ec-2bda-3bde71fe051a
# ╟─5772ade0-53c0-11ec-0764-a33f5072cf77
# ╟─5772ae4e-53c0-11ec-231f-87c1eaa0e731
# ╟─5772ae76-53c0-11ec-0e54-bd2bb08239de
# ╟─5772b268-53c0-11ec-0b51-d7d5f3443519
# ╠═5772d55e-53c0-11ec-194f-674a37f4e05b
# ╟─5772d586-53c0-11ec-1d1c-1966e998c9c5
# ╟─5772d5f4-53c0-11ec-3605-a5354aaf9650
# ╠═5772e026-53c0-11ec-0c1d-451541ffccfa
# ╟─5772e062-53c0-11ec-17a6-0faf64867b62
# ╠═5772e51c-53c0-11ec-27c6-55a2869f7de7
# ╟─5772e54e-53c0-11ec-3305-3b7aa6f9f2e2
# ╟─5772e580-53c0-11ec-3e3c-6f51a7b4e9b9
# ╟─5772e5c6-53c0-11ec-2f57-c72802c61010
# ╟─5772e5e4-53c0-11ec-3fb9-05117ad96314
# ╠═5772edaa-53c0-11ec-1fd9-5d7e274e09fd
# ╟─5772ede6-53c0-11ec-21ad-d147228f737c
# ╠═5772eff6-53c0-11ec-2c43-8deb15a18a85
# ╟─5772f00c-53c0-11ec-1d39-198b808ffa41
# ╟─5772f020-53c0-11ec-1af7-bbdd4177b04e
# ╟─5772f124-53c0-11ec-04c2-596d33fa8606
# ╟─5772f142-53c0-11ec-08a0-394c0e0cb430
# ╠═5772f480-53c0-11ec-0c4e-4f2e461681a6
# ╟─5772f4b2-53c0-11ec-18b5-870c5423b358
# ╠═5772f7f0-53c0-11ec-2de3-1f45fae752d6
# ╟─5772f91c-53c0-11ec-3f28-4b3eae3204a8
# ╟─5772f94e-53c0-11ec-0590-affa25eabba2
# ╠═5772fb76-53c0-11ec-3196-8bf1eb5b45c6
# ╟─5772fbe2-53c0-11ec-379a-bd8e0a6de06b
# ╟─5772fbf6-53c0-11ec-15a9-233f9f174dd6
# ╠═57730330-53c0-11ec-221a-cbad6f54272c
# ╟─57730358-53c0-11ec-3a74-232cd60003fc
# ╟─577303da-53c0-11ec-18ac-41009d7bd4e3
# ╟─577303f8-53c0-11ec-232f-59ee14d91238
# ╟─577304a2-53c0-11ec-36b0-19aeb8e1bdd4
# ╟─577304ac-53c0-11ec-08c5-d986c3f2487f
# ╟─577304f2-53c0-11ec-1945-f9113fb5ee22
# ╟─57730510-53c0-11ec-2779-b7e994b77403
# ╠═57730a10-53c0-11ec-2be0-2fb43a570814
# ╟─57730a2e-53c0-11ec-099d-6168ff29dca2
# ╟─57730a56-53c0-11ec-2981-0377e0fe196b
# ╟─57730a6a-53c0-11ec-22a6-91d4b221e6d6
# ╠═577310bc-53c0-11ec-1b70-a79afe818364
# ╟─57731104-53c0-11ec-2ed2-43cec9139b26
# ╟─57731118-53c0-11ec-10fb-699cd987e57b
# ╠═57732f0e-53c0-11ec-03a4-e508e4b51c07
# ╟─57732f54-53c0-11ec-26c8-ddbb82065ef1
# ╟─57732fae-53c0-11ec-07ab-294270d21084
# ╟─57732fcc-53c0-11ec-2a18-0d7d6778d01c
# ╠═57733648-53c0-11ec-3996-07abe045c210
# ╟─57733684-53c0-11ec-02fa-e17155f690ce
# ╟─577336a2-53c0-11ec-282d-49fa0200f3ec
# ╠═577344b2-53c0-11ec-0b4a-95f304cf1ebb
# ╟─577344ee-53c0-11ec-30b7-e36928df5761
# ╟─57734516-53c0-11ec-231f-0f7144d8befa
# ╟─57734534-53c0-11ec-0cf3-dbea76d7d01e
# ╟─57734566-53c0-11ec-2461-f1d2c949e04e
# ╠═57734b1a-53c0-11ec-3902-6dba041f9356
# ╟─57734b56-53c0-11ec-1574-a9bb4c87a8df
# ╠═57735080-53c0-11ec-0c2d-7d6fa4f88c11
# ╟─577350b2-53c0-11ec-1086-690972e54869
# ╟─577350ce-53c0-11ec-1a1f-c57a8f55f0c2
# ╟─577350f6-53c0-11ec-3cdf-3f2733beba34
# ╠═5773565a-53c0-11ec-27fb-1be16ae80012
# ╟─5773566e-53c0-11ec-30c9-136997f0f142
# ╟─57735736-53c0-11ec-1f32-87e341d2a242
# ╟─57736490-53c0-11ec-138c-6142b2ce7a0d
# ╟─577364ce-53c0-11ec-3733-a56384bcf96c
# ╟─57736514-53c0-11ec-27bf-81c7990ffa6e
# ╟─577366b8-53c0-11ec-03b2-8dcaa39ecb48
# ╟─577366e0-53c0-11ec-3f34-c56ab51c17ac
# ╟─5773672e-53c0-11ec-2737-9f14663c479b
# ╟─5773674e-53c0-11ec-0ad0-a93dbd16e635
# ╟─57736760-53c0-11ec-1fed-398965c502ec
# ╟─5773679e-53c0-11ec-1577-6d8b5cc758b1
# ╟─577367bc-53c0-11ec-1d9a-1d87b89fa144
# ╟─577367da-53c0-11ec-24e6-a956f24f8846
# ╟─5773683e-53c0-11ec-1012-ff0d754930ba
# ╠═57739aca-53c0-11ec-39a5-951d0b73379f
# ╟─57739b2e-53c0-11ec-01fe-010a5e2c5b50
# ╟─57739b56-53c0-11ec-2f59-ab3b92ab1ede
# ╟─57739b9c-53c0-11ec-2582-0b41204c1de3
# ╟─57739e94-53c0-11ec-25cd-31ddaff687a0
# ╟─5773c72a-53c0-11ec-327a-9ff6ba2db2b5
# ╠═5773eadc-53c0-11ec-0333-c15962107732
# ╟─5773eb1a-53c0-11ec-36af-91bd4626c598
# ╟─5773eb38-53c0-11ec-3d03-f3c0168ed40b
# ╠═5773f0f6-53c0-11ec-0eb5-21118c905d50
# ╟─5773f114-53c0-11ec-00ad-5b19b7aee4e7
# ╟─5773f146-53c0-11ec-3a11-fd88a5382efa
# ╠═5773f5d8-53c0-11ec-25de-150bf8484f22
# ╟─5773f61e-53c0-11ec-3289-9d32588fff72
# ╠═5773f95e-53c0-11ec-0196-b76c89147bd3
# ╟─5773f984-53c0-11ec-3d46-3515da287b4a
# ╟─5773f998-53c0-11ec-2eb0-dd3cc86cf0a7
# ╟─5773f9be-53c0-11ec-2d1b-9f86a1bc5d81
# ╟─5773f9de-53c0-11ec-10fd-35a82d737597
# ╠═5773fdd0-53c0-11ec-2e71-856851b4945c
# ╟─5773fe16-53c0-11ec-2b08-9534cbb40bc6
# ╟─5773fe28-53c0-11ec-147b-3918be065735
# ╟─5773fe5c-53c0-11ec-1a12-3593da8cc03e
# ╟─5773fe70-53c0-11ec-2c2c-6f44cbe68e68
# ╟─5773ffd8-53c0-11ec-14cc-633cb5350c57
# ╟─5773fff6-53c0-11ec-3484-817772d9e4ad
# ╟─5774001e-53c0-11ec-357e-39635b646aba
# ╟─57740034-53c0-11ec-3f5e-21a11d595751
# ╟─57740078-53c0-11ec-1a53-a544edc77112
# ╟─5774008c-53c0-11ec-0b75-11b4afa33f30
# ╠═577408ac-53c0-11ec-241b-059d8d01f7b7
# ╟─577408fc-53c0-11ec-1855-ffc83059ffa7
# ╟─57740910-53c0-11ec-0ad6-09f6ab549bf7
# ╟─5774097e-53c0-11ec-24c1-fb39c16bc8ac
# ╟─577409a8-53c0-11ec-2bd6-a588403309cd
# ╟─57741270-53c0-11ec-2def-91892858cbe3
# ╟─5774128e-53c0-11ec-102d-a53fa156c841
# ╟─577412c0-53c0-11ec-13d5-e53593d43ed6
# ╟─57742fbc-53c0-11ec-2172-3d6ac60100eb
# ╟─57742fee-53c0-11ec-1c4f-e7945378f977
# ╟─57743016-53c0-11ec-34c2-0536d5d87032
# ╟─577438de-53c0-11ec-175e-3d5f0e6c25c9
# ╟─577438fe-53c0-11ec-1774-0b42014bd726
# ╟─57743958-53c0-11ec-295e-1b4f599159ae
# ╟─57743ff2-53c0-11ec-1aaa-b390762926a0
# ╟─57744010-53c0-11ec-3de4-abdefb9108ac
# ╟─57744038-53c0-11ec-34f4-a92e3ec6f454
# ╟─5774439e-53c0-11ec-0203-4345fb1254c5
# ╟─577443b2-53c0-11ec-186c-c799707c77ff
# ╟─577443e4-53c0-11ec-2ee1-83b2e672fa95
# ╟─57744402-53c0-11ec-2a54-65bacb6819e5
# ╟─57744760-53c0-11ec-149c-cf0c8c95dd9c
# ╟─5774477c-53c0-11ec-26e0-cf334ab3b40a
# ╟─577447d6-53c0-11ec-070a-d73608199cd7
# ╟─57745226-53c0-11ec-38af-b30d79e0d1ca
# ╟─57745244-53c0-11ec-09fc-2550baee9db0
# ╟─577455aa-53c0-11ec-3cb1-1da78e25dc6f
# ╟─577455c8-53c0-11ec-1cbd-f52d4791e4f0
# ╟─577455fa-53c0-11ec-2ece-1501416f92d3
# ╟─57745bb8-53c0-11ec-0b44-d1bbe61859a6
# ╟─57745bd6-53c0-11ec-2a54-c3bb8f8a1eb8
# ╟─57745c14-53c0-11ec-2423-331db55851ba
# ╟─57745c26-53c0-11ec-1efa-53b2e13336e6
# ╟─57745c58-53c0-11ec-0268-db311c868357
# ╟─57745c6c-53c0-11ec-1b32-cb0da1c64d0c
# ╟─57746a36-53c0-11ec-3faa-e3bad7c21da6
# ╟─57746a5e-53c0-11ec-2d8d-a957ab6c203c
# ╟─577474e0-53c0-11ec-36d3-db9857138801
# ╟─57747500-53c0-11ec-2134-791a28fd5a39
# ╟─57747526-53c0-11ec-2d1b-43d6233a6ec4
# ╟─5774754e-53c0-11ec-0037-6169f9f85f32
# ╟─57747e18-53c0-11ec-1aab-e74ad3103c23
# ╟─57747e36-53c0-11ec-1997-ef687561ad52
# ╟─57747e4a-53c0-11ec-3023-0dadb20a2398
# ╠═577494fc-53c0-11ec-0d9e-5bd71418a661
# ╟─57749538-53c0-11ec-1e2a-e96e47c55efc
# ╟─5774956a-53c0-11ec-0578-f5e1e5222838
# ╟─57749f9a-53c0-11ec-2533-c1351533f2e4
# ╟─57749fcc-53c0-11ec-3d7d-179bd7993c97
# ╟─57749ff6-53c0-11ec-0d53-4d2a147d5ba2
# ╟─5774a9d8-53c0-11ec-34f4-cdbb389d4ade
# ╟─5774aa0a-53c0-11ec-149d-e95cdb97bd7f
# ╟─5774aa32-53c0-11ec-01be-4ba27bc80ca2
# ╟─5774b3f6-53c0-11ec-0c29-9f13d8ccde9c
# ╟─5774b420-53c0-11ec-29de-a7853636cba3
# ╟─5774b446-53c0-11ec-18e9-ebdd646da04d
# ╟─5774beca-53c0-11ec-3a99-fdbfa53348a2
# ╟─5774bef0-53c0-11ec-2387-8d17afc3ffed
# ╟─5774bf18-53c0-11ec-19d4-8fb3d0929c24
# ╟─5774bf40-53c0-11ec-1cd5-5d9fba02b55f
# ╟─5774bf7c-53c0-11ec-3d48-2b50b87ba374
# ╟─5774bfa4-53c0-11ec-2f97-3d1da4f55a6c
# ╟─5774bfae-53c0-11ec-3e48-f1b4815c2176
# ╟─5774bfb8-53c0-11ec-1923-5b1a98fcd431
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
