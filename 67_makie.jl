### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 94e93b5c-c183-11ec-1226-3f58d2068615
using MDBM

# ╔═╡ 94eda9c8-c183-11ec-3224-c56ecf97ff27
using PlutoUI

# ╔═╡ 94eda8e2-c183-11ec-1361-17462d288031
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 94d3ccb0-c183-11ec-2b52-5b3c83e1334f
md"""# Calculus plots with Makie
"""

# ╔═╡ 94d3d172-c183-11ec-3a71-9f3a8473368b
md"""## XXX This needs a total rewrite for the new Makie
"""

# ╔═╡ 94d460d2-c183-11ec-10ba-d7ea38d21c35
md"""The [Makie.jl webpage](https://github.com/JuliaPlots/Makie.jl) says
"""

# ╔═╡ 94d4928a-c183-11ec-30cd-2925267fc3bb
md"""> From the Jpanese word Maki-e, which is a technique to sprinkle lacquer with gold and silver powder. Data is basically the gold and silver of our age, so let's spread it out beautifully on the screen!

"""

# ╔═╡ 94dad0e4-c183-11ec-2340-631fc67b9bed
md"""`Makie` itself is a metapackage for a rich ecosystem. We show how to use the interface provided by `AbstractPlotting` and the `GLMakie` backend to produce the familiar graphics of calculus.  We do not discuss the `MakieLayout` package which provides a means to layout multiple graphics and add widgets, such as sliders and buttons, to a layout. We do not discuss `MakieRecipes`. For `Plots`, there are "recipes" that make some of the plots more straightforward.  We do not discuss the [`AlgebraOfGraphics`](https://github.com/JuliaPlots/AlgebraOfGraphics.jl) which presents an interface for the familiar graphics of statistics.
"""

# ╔═╡ 94dad280-c183-11ec-20b2-cb35b1ca82ba
md"""## Scenes
"""

# ╔═╡ 94dad2c6-c183-11ec-1405-2dc115686fa9
md"""Makie draws graphics onto a canvas termed a "scene" in the Makie documentation. There are `GLMakie`, `WGLMakie`, and `CairoMakie` backends for different types of canvases. In the following, we have used `GLMakie`. `WGLMakie` is useful for incorporating `Makie` plots into web-based technologies.
"""

# ╔═╡ 94dad38e-c183-11ec-1db8-fba9662d3497
md"""We begin by loading our two packages:
"""

# ╔═╡ 94dadbea-c183-11ec-2248-e7eb87c8882e
md"""The `Makie` developers have workarounds for the delayed time to first plot, but without utilizing these the time to load the package is lengthy.
"""

# ╔═╡ 94dadc08-c183-11ec-1c9f-4f4d1e86f535
md"""A scene is produced with `Scene()` or through a plotting primitive:
"""

# ╔═╡ 94dae78e-c183-11ec-1247-b144266c64f3
md"""We see next how to move beyond the blank canvas.
"""

# ╔═╡ 94dae7ca-c183-11ec-3a09-f5243ddb0b65
md"""## Points (`scatter`)
"""

# ╔═╡ 94daea42-c183-11ec-1f08-0d59265f4cf2
md"""The task of plotting the points, say $(1,2)$, $(2,3)$, $(3,2)$ can be done different ways. Most plotting packages, and `Makie` is no exception, allow the following: form vectors of the $x$ and $y$ values then plot those with `scatter`:
"""

# ╔═╡ 94daf3f0-c183-11ec-1cab-abd9769a36cb
md"""The `scatter` function creates and returns a `Scene` object, which when displayed shows the plot.
"""

# ╔═╡ 94daf40e-c183-11ec-2e73-ab158586c95a
md"""The more generic `plot` function can also be used for this task.
"""

# ╔═╡ 94e63e4a-c183-11ec-191c-bbe170ddf49f
md"""### `Point2`, `Point3`
"""

# ╔═╡ 94e63ed8-c183-11ec-3e63-25be67f70203
md"""When learning about points on the Cartesian plane, a "`t`"-chart is often produced:
"""

# ╔═╡ 94e66ac8-c183-11ec-1b6a-11106728b29a
begin
	x | y
	-----
	1 | 2
	2 | 3
	3 | 2
end

# ╔═╡ 94e66c46-c183-11ec-348d-07c67f91866a
md"""The `scatter` usage above used the columns. The rows are associated with the points, and these too can be used to produce the same graphic. Rather than make vectors of $x$ and $y$ (and optionally $z$) coordinates, it is more idiomatic to create a vector of "points." `Makie` utilizes a `Point` type to store a 2 or 3 dimensional point. The `Point2` and `Point3` constructors will be utilized.
"""

# ╔═╡ 94e68d8c-c183-11ec-0e23-73dcdfa9a8f2
md"""`Makie` uses a GPU, when present, to accelerate the graphic rendering. GPUs employ 32-bit numbers. Julia uses an `f0` to indicate 32-bit floating points. Hence the alternate types `Point2f0` to store 2D points as 32-bit numbers and `Points3f0` to store 3D points as 32-bit numbers are seen in the documentation for Makie.
"""

# ╔═╡ 94e68e68-c183-11ec-3271-d1a4a5eb2b14
md"""We can plot vector of points in as direct manner as vectors of their coordinates:
"""

# ╔═╡ 94e6e926-c183-11ec-11af-0d05b01b16cb
md"""A typical usage is to generate points from some vector-valued function. Say we have a parameterized function `r` taking $R$ into $R^2$ defined by:
"""

# ╔═╡ 94e718a6-c183-11ec-36fc-0344020882a6
md"""Then broadcasting values gives a vector of vectors, each identified with a point:
"""

# ╔═╡ 94e723e6-c183-11ec-2e0a-47d053b4e692
md"""We can broadcast `Point2` over this to create a vector of `Point` objects:
"""

# ╔═╡ 94e72ac6-c183-11ec-2b0f-57525af08744
md"""These then can be plotted directly:
"""

# ╔═╡ 94e72ff8-c183-11ec-2daf-b1cdba20fdab
md"""The ploting of points in three dimesions is essentially the same, save the use of `Point3` instead of `Point2`.
"""

# ╔═╡ 94e73c64-c183-11ec-1e93-e595ad894c64
md"""---
"""

# ╔═╡ 94e73d18-c183-11ec-27a2-35fa458d66ee
md"""To plot points generated in terms of vectors of coordinates, the component vectors must be created.  The "`t`"-table shows how, simply loop over each column and add the corresponding $x$ or $y$ (or $z$) value.  This utility function does exactly that, returning the vectors in a tuple.
"""

# ╔═╡ 94e795b0-c183-11ec-3acb-5f8d9ae7f43d
unzip(vs) = Tuple([vs[j][i] for j in eachindex(vs)] for i in eachindex(vs[1]))

# ╔═╡ 94e796aa-c183-11ec-154b-0d227483fc98
md"""(The functionality is essentially a reverse of the `zip` function, hence the name.)
"""

# ╔═╡ 94e79790-c183-11ec-2e8b-61cb32ac13c3
md"""We might have then:
"""

# ╔═╡ 94e7a1a2-c183-11ec-3d59-fd3ed16f8b6a
md"""where splatting is used to specify the `xs`, `ys`, and `zs` to `scatter`.
"""

# ╔═╡ 94e7a1cc-c183-11ec-33a1-09c5a78abae1
md"""(Compare to `scatter(Point3.(r.(ts)))` or `scatter(Point3∘r).(ts))`.)
"""

# ╔═╡ 94e7a2d8-c183-11ec-0b08-098dc0521860
md"""### Attributes
"""

# ╔═╡ 94e7a2f8-c183-11ec-22c3-bb9df42e20f0
md"""A point is drawn with a "marker" with a certain size and color. These attributes can be adjusted, as in the following:
"""

# ╔═╡ 94e7fcd0-c183-11ec-2917-4f083801ab4b
md"""Marker attributes include
"""

# ╔═╡ 94e81e54-c183-11ec-396e-89070b156b00
md"""  * `marker` a symbol, shape. A single value will be repeated. A vector of values of a matching size will specify a marker for each point.
  * `marker_offset` offset coordinates
  * `markersize` size (radius pixels) of marker
"""

# ╔═╡ 94e81f50-c183-11ec-07ac-8db18322bb6d
md"""### Text (`text`)
"""

# ╔═╡ 94e82188-c183-11ec-1652-21038cc7885c
md"""Text can be placed at a point, as a marker is. To place text the desired text and a position need to be specified.
"""

# ╔═╡ 94e821b0-c183-11ec-3206-87e92719263c
md"""For example:
"""

# ╔═╡ 94e832c2-c183-11ec-36fa-37e3e1db217c
md"""The graphic shows that `position` positions the text, `textsize` adjusts the displayed size, and `rotation` adjusts the orientation.
"""

# ╔═╡ 94e8340c-c183-11ec-2a1f-77f0835b3ae4
md"""Attributes for `text` include:
"""

# ╔═╡ 94e8377c-c183-11ec-2101-41ff66cd0a67
md"""  * `position` to indicate the position. Either a `Point` object, as above, or a tuple
  * `align` Specify the text alignment through `(:pos, :pos)`, where `:pos` can be `:left`, `:center`, or `:right`.
  * `rotation` to indicate how the text is to be rotated
  * `textsize` the font point size for the text
  * `font` to indicate the desired font
"""

# ╔═╡ 94e837b8-c183-11ec-219d-c9ef99bb562a
md"""## Curves
"""

# ╔═╡ 94e83826-c183-11ec-2a92-93a288b5b45b
md"""### Plots of univariate functions
"""

# ╔═╡ 94e83972-c183-11ec-38e5-19f04aa72ea5
md"""The basic plot of univariate calculus is the graph of a function $f$ over an interval $[a,b]$. This is implemented using a familiar strategy: produce a series of representative values between $a$ and $b$; produce the corresponding $f(x)$ values; plot these as points and connect the points with straight lines. The `lines` function of `AbstractPlotting` will do the last step.
"""

# ╔═╡ 94e8398e-c183-11ec-1c32-3f968a705057
md"""By taking a sufficient number of points within $[a,b]$ the connect-the-dot figure will appear curved, when the function is.
"""

# ╔═╡ 94e839b6-c183-11ec-1cf8-9b70e52dda0d
md"""To create regular values between `a` and `b` either the `range` function, the related `LinRange` function, or the range operator (`a:h:b`) are employed.
"""

# ╔═╡ 94e83a10-c183-11ec-149a-47e425d1a8fb
md"""For example:
"""

# ╔═╡ 94e840da-c183-11ec-3109-37f7120af40d
md"""Or
"""

# ╔═╡ 94e848de-c183-11ec-071b-0fc6707285c2
md"""As with `scatter`, `lines` returns a `Scene` object that produces a graphic when displayed.
"""

# ╔═╡ 94e848fc-c183-11ec-2dbf-0d6813562120
md"""As with `scatter`, `lines` can can also be drawn using a vector of points:
"""

# ╔═╡ 94e854f0-c183-11ec-1766-ad2e775a4fa2
md"""(Though the advantage isn't clear here, this will be useful when the points are more naturally generated.)
"""

# ╔═╡ 94e8552a-c183-11ec-29a1-fbe26acfb0da
md"""When a `y` value is `NaN` or infinite, the connecting lines are not drawn:
"""

# ╔═╡ 94e85cd6-c183-11ec-21aa-7f382d094f9b
md"""As with other plotting packages, this is useful to represent discontinuous functions, such as what occurs at a vertical asymptote.
"""

# ╔═╡ 94e86116-c183-11ec-1482-67aec8ce71be
md"""#### Adding to a scene (`lines!`, `scatter!`, ...)
"""

# ╔═╡ 94e8629c-c183-11ec-1ab3-0fef85a2ea6a
md"""To *add* or *modify* a scene can be done using a mutating version of a plotting primitive, such as `lines!` or `scatter!`. The names follow `Julia`'s convention of using an `!` to indicate that a function modifies an argument, in this case the scene.
"""

# ╔═╡ 94e862f6-c183-11ec-27f7-514de7b75ee1
md"""Here is one way to show two plots at once:
"""

# ╔═╡ 94e86fbc-c183-11ec-38be-7d59215328ce
md"""We will see soon how to modify the line attributes so that the curves can be distinguished.
"""

# ╔═╡ 94e86fd0-c183-11ec-2481-0d833120ed6b
md"""The following shows the construction details in the graphic, and that  the initial scene argument is implicitly assumed:
"""

# ╔═╡ 94e87aac-c183-11ec-289e-ad4aa353cb9d
md"""---
"""

# ╔═╡ 94e87b38-c183-11ec-356e-298b243c7b74
md"""The current scene will have data limits that can be of interest. The following indicates how they can be manipulated to get the limits of the displayed `x` values.
"""

# ╔═╡ 94e885f6-c183-11ec-023d-a731c87fd7be
md"""In the output it can be discerned that the values are 32-bit floating point numbers *and* yield a  slightly larger interval than specified in `xs`.
"""

# ╔═╡ 94e88614-c183-11ec-0d85-8d11505d1f1b
md"""As an example, this shows how to add the tangent line to a graph. The slope of the tangent line being computed by `ForwardDiff.derivative`.
"""

# ╔═╡ 94e88d42-c183-11ec-375d-a55f91f06527
md"""#### Attributes
"""

# ╔═╡ 94e88de4-c183-11ec-1f10-e7e753366755
md"""In the last example, we added the argument `color=:blue` to the `lines!` call. This set an attribute for the line being drawn. Lines have other attributes that allow different ones to be distinguished, as above where colors indicate the different graphs.
"""

# ╔═╡ 94e88e4a-c183-11ec-267e-21a6d973815d
md"""Other attributes can be seen from the help page for `lines`, and include:
"""

# ╔═╡ 94e891fe-c183-11ec-1f19-41c87a1a42c6
md"""  * `color` set with a symbol, as above, or a string
  * `linestyle` available styles are set by a symbol, one of `:dash`, `:dot`, `:dashdot`, or `:dashdotdot`.
  * `linewidth` width of line
  * `transparency` the `alpha` value, a number between $0$ and $1$, smaller numbers for more transparent.
"""

# ╔═╡ 94e89212-c183-11ec-3212-2f6999c0eacf
md"""A legend can also be used to help identify different curves on the same graphic, though this is not illustrated. There are examples in the Makie gallery.
"""

# ╔═╡ 94e892da-c183-11ec-08ba-eb97c157e93f
md"""#### Scene attributes
"""

# ╔═╡ 94e892ee-c183-11ec-1ac8-a36879a7d9d7
md"""Attributes of the scene include any titles and labels, the limits that define the coordinates being displayed, the presentation of tick marks, etc.
"""

# ╔═╡ 94e8930c-c183-11ec-2d38-a14a685b1c94
md"""The `title` function can be used to add a title to a scene. The calling syntax is `title(scene, text)`.
"""

# ╔═╡ 94e893de-c183-11ec-2f09-81b898589319
md"""To set the labels of the graph, there are "shorthand" functions `xlabel!`, `ylabel!`, and `zlabel!`. The calling pattern would follow `xlabel!(scene, "x-axis")`.
"""

# ╔═╡ 94e894d8-c183-11ec-1176-0ff39ad8de6c
md"""The plotting ticks and their labels are returned by the unexported functions `tickranges` and `ticklabels`. The unexported `xtickrange`, `ytickrange`, and `ztickrange`; and `xticklabels`, `yticklabels`, and `zticklabels` return these for the indicated axes.
"""

# ╔═╡ 94e89636-c183-11ec-354d-4b992aa80b20
md"""These can be dynamically adjusted using `xticks!`, `yticks!`, or `zticks!`.
"""

# ╔═╡ 94e8a3b0-c183-11ec-1546-1fa1d0ad0afd
md"""To set the limits of the graph there are shorthand functions `xlims!`, `ylims!`, and `zlims!`. This might prove useful if vertical asymptotes are encountered, as in this example:
"""

# ╔═╡ 94e8ab0a-c183-11ec-36b0-a11ad3df68e4
md"""### Plots of parametric functions
"""

# ╔═╡ 94e8ab3c-c183-11ec-2690-8d2ac412dbe5
md"""A space curve is a plot of a function $f:R^2 \rightarrow R$ or $f:R^3 \rightarrow R$.
"""

# ╔═╡ 94e8ab58-c183-11ec-0884-c7ef3aa6c8f4
md"""To construct a curve from a set of points, we have a similar pattern in both $2$ and $3$ dimensions:
"""

# ╔═╡ 94e8b58a-c183-11ec-2448-210b94c818bd
md"""Or
"""

# ╔═╡ 94e72ef4-c183-11ec-3fd5-9326eae930e5
scatter(pts)

# ╔═╡ 94e7a0de-c183-11ec-2921-27024f547ecc
scatter(unzip(r.(ts))...)

# ╔═╡ 94ecfca8-c183-11ec-0772-d5c1de1db07f
begin
	using LinearAlgebra
	dvs = dus ./ norm.(dus)
	arrows(pts, dvs)
end

# ╔═╡ 94e8e578-c183-11ec-36f8-873704132d8d
md"""Alternatively, vectors of the $x$, $y$, and $z$ components can be produced and then plotted using the pattern `lines(xs, ys)` or `lines(xs, ys, zs)`. For example, using `unzip`, as above, we might have done the prior example with:
"""

# ╔═╡ 94e8f16c-c183-11ec-37bf-5b44a5705af0
md"""#### Tangent vectors (`arrows`)
"""

# ╔═╡ 94e8f1f8-c183-11ec-158b-d3989a1b669d
md"""A tangent vector along a curve can be drawn quite easily using the `arrows` function. There are different interfaces for `arrows`, but we show the one which uses a vector of positions and a vector of "vectors". For the latter, we utilize the `derivative` function from `ForwardDiff`:
"""

# ╔═╡ 94e8f658-c183-11ec-3352-9316e15d11ab
md"""In 3 dimensions the differences are minor:
"""

# ╔═╡ 94e901d4-c183-11ec-01bb-ab984d141e05
md"""##### Attributes
"""

# ╔═╡ 94e9026a-c183-11ec-2acd-65e65f0ba927
md"""Attributes for `arrows` include
"""

# ╔═╡ 94e9058a-c183-11ec-3920-37b0259e1fd9
md"""  * `arrowsize` to adjust the size
  * `lengthscale` to scale the size
  * `arrowcolor` to set the color
  * `arrowhead` to adjust the head
  * `arrowtail` to adjust the tail
"""

# ╔═╡ 94e905a8-c183-11ec-0bf2-5f0780769b00
md"""### Implicit equations (2D)
"""

# ╔═╡ 94e9063e-c183-11ec-02ee-a5796e2ed603
md"""The graph of an equation is the collection of all $(x,y)$ values satisfying the equation. This is more general than the graph of a function, which can be viewed as the graph of the equation $y=f(x)$. An equation in $x$-$y$ can be graphed if the set of solutions to a related equation $f(x,y)=0$ can be identified, as one can move all terms to one side of an equation and define $f$ as the rule of the side with the terms.
"""

# ╔═╡ 94e906b8-c183-11ec-37de-c9efa3aaf0fc
md"""The [MDBM](https://github.com/bachrathyd/MDBM.jl) (Multi-Dimensional Bisection Method) package can be used for the task of characterizing when $f(x,y)=0$. (Also `IntervalConstraintProgramming` can be used.) We first wrap its interface and then define a "`plot`" recipe (through method overloading, not through `MakieRecipes`).
"""

# ╔═╡ 94e99908-c183-11ec-31dc-ff1b1119d3a6
function implicit_equation(f, axes...; iteration::Int=4, constraint=nothing)

    axes = [axes...]

    if constraint == nothing
        prob = MDBM_Problem(f, axes)
    else
        prob = MDBM_Problem(f, axes, constraint=constraint)
    end

    solve!(prob, iteration)

    prob
end

# ╔═╡ 94e99aea-c183-11ec-1d0b-53dc15f1cfc4
md"""The `implicit_equation` function is just a simplified wrapper for the `MDBM_Problem` interface. It creates an object to be plotted in a manner akin to:
"""

# ╔═╡ 94e9b282-c183-11ec-1dba-6f974b017480
md"""The function definition is straightforward. The limits for `x` and `y` are specified in the above using ranges. This specifies the initial grid of points for the apdaptive algorithm used by `MDBM` to identify solutions.
"""

# ╔═╡ 94e9b46c-c183-11ec-3a17-a50f7262cce3
md"""To visualize the output, we make a new method for `plot` and `plot!`. There is a distinction between 2 and 3 dimensions. Below in two dimensions curve(s) are drawn. In three dimensions, scaled cubes are used to indicate the surface.
"""

# ╔═╡ 94e9d140-c183-11ec-155f-8f76c9283682
begin
	AbstractPlotting.plot(m::MDBM_Problem; kwargs...) = plot!(Scene(), m; kwargs...)
	AbstractPlotting.plot!(m::MDBM_Problem; kwargs...) = plot!(AbstractPlotting.current_scene(), m; kwargs...)
	AbstractPlotting.plot!(scene::AbstractPlotting.Scene, m::MDBM_Problem; kwargs...) =
	    plot!(Val(_dim(m)), scene, m; kwargs...)
	
	_dim(m::MDBM.MDBM_Problem{a,N,b,c,d,e,f,g,h}) where {a,N,b,c,d,e,f,g,h} = N
end

# ╔═╡ 94e9d2a8-c183-11ec-35f1-63c8d247038e
md"""Dispatch is used for the two different dimesions, identified through `_dim`, defined above.
"""

# ╔═╡ 94ea38f6-c183-11ec-1945-61f8544bdbfe
# 2D plot
function AbstractPlotting.plot!(::Val{2}, scene::AbstractPlotting.Scene,
    m::MDBM_Problem; color=:black, kwargs...)

    mdt=MDBM.connect(m)
    for i in 1:length(mdt)
        dt=mdt[i]
        P1=getinterpolatedsolution(m.ncubes[dt[1]], m)
        P2=getinterpolatedsolution(m.ncubes[dt[2]], m)
        lines!(scene, [P1[1],P2[1]],[P1[2],P2[2]], color=color, kwargs...)
    end

    scene
end

# ╔═╡ 94eaf41c-c183-11ec-3451-05f6b9367aef
# 3D plot
function AbstractPlotting.plot!(::Val{3}, scene::AbstractPlotting.Scene,
    m::MDBM_Problem; color=:black, kwargs...)

    positions = Point{3, Float32}[]
    scales = Vec3[]

    mdt=MDBM.connect(m)
    for i in 1:length(mdt)
        dt=mdt[i]
        P1=getinterpolatedsolution(m.ncubes[dt[1]], m)
        P2=getinterpolatedsolution(m.ncubes[dt[2]], m)

        a, b = Vec3(P1), Vec3(P2)
        push!(positions, Point3(P1))
        push!(scales, b-a)
    end

    cube = Rect{3, Float32}(Vec3(-0.5, -0.5, -0.5), Vec3(1, 1, 1))
    meshscatter!(scene, positions, marker=cube, scale = scales, color=color, transparency=true, kwargs...)

    scene
end

# ╔═╡ 94eaf714-c183-11ec-0690-650bd9cdeb62
md"""We see that the equation `ie` has two pieces. (This is known as Newton's trident, as Newton was interested in this form of equation.)
"""

# ╔═╡ 94eaff86-c183-11ec-1f8c-db44f319dc06
plot(ie)

# ╔═╡ 94eb0042-c183-11ec-06e2-37e8e1016587
md"""## Surfaces
"""

# ╔═╡ 94eb00a6-c183-11ec-172d-3986f2fe0ab1
md"""Plots of surfaces in 3 dimensions are useful to help understand the behavior of multivariate functions.
"""

# ╔═╡ 94eb0180-c183-11ec-0f61-456a86434084
md"""#### Surfaces defined through $z=f(x,y)$
"""

# ╔═╡ 94eb01fa-c183-11ec-0d75-3f7643fd3fe0
md"""The "peaks" function generates the logo for MATLAB. Here we see how it can be plotted over the region $[-5,5]\times[-5,5]$.
"""

# ╔═╡ 94eb27f2-c183-11ec-36fd-77899a99cffa
md"""The calling pattern `surface(xs, ys, f)` implies a rectangular grid over the $x$-$y$ plane defined by `xs` and `ys` with $z$ values given by $f(x,y)$.
"""

# ╔═╡ 94eb289c-c183-11ec-2b08-03870af2715b
md"""Alternatively a "matrix" of $z$ values can be specified. For a function `f`, this is conveniently generated by the pattern `f.(xs, ys')`, the `'` being important to get a matrix of all $x$-$y$ pairs through `Julia`'s broadcasting syntax.
"""

# ╔═╡ 94eb3224-c183-11ec-3ae6-4b1549344a83
md"""To see how this graph is constructed, the points $(x,y,f(x,y))$ are plotted over the grid and displayed.
"""

# ╔═╡ 94eb32c2-c183-11ec-1caa-2d646be77530
md"""Here we downsample to illutrate
"""

# ╔═╡ 94eb3e90-c183-11ec-18e2-d9aca7707f75
md"""These points are connected. The `wireframe` function illustrates just the frame
"""

# ╔═╡ 94eb48b8-c183-11ec-2362-4bcb30c62cb0
md"""The `surface` call triangulates the frame and fills in the shading:
"""

# ╔═╡ 94eb4e30-c183-11ec-3450-c3788de59433
md"""#### Implicitly defined surfaces, $F(x,y,z)=0$
"""

# ╔═╡ 94eb4f5c-c183-11ec-262b-c995967662d9
md"""The set of points $(x,y,z)$ satisfying $F(x,y,z) = 0$ will form a surface that can be visualized using the `MDBM` package. We illustrate showing two nested surfaces.
"""

# ╔═╡ 94eb5e02-c183-11ec-3641-db18756215b1
md"""#### Parametrically defined surfaces
"""

# ╔═╡ 94eb5e3e-c183-11ec-2422-17ac3c6d833f
md"""A surface may be parametrically defined through a function $r(u,v) = (x(u,v), y(u,v), z(u,v))$. For example, the surface generated by $z=f(x,y)$ is of the form with $r(u,v) = (u,v,f(u,v))$.
"""

# ╔═╡ 94eb5fa6-c183-11ec-2ccc-7f0f5a16eecf
md"""The `surface` function and the `wireframe` function can be used to display such surfaces. In previous usages, the `x` and `y` values were vectors from which a 2-dimensional grid is formed. For parametric surfaces, a grid for the `x` and `y` values must be generated. This function will do so:
"""

# ╔═╡ 94ebb940-c183-11ec-0efa-fb167c4bbe51
function parametric_grid(us, vs, r)
    n,m = length(us), length(vs)
    xs, ys, zs = zeros(n,m), zeros(n,m), zeros(n,m)
    for (i, uᵢ) in enumerate(us)
        for (j, vⱼ) in enumerate(vs)
            x,y,z = r(uᵢ, vⱼ)
            xs[i,j] = x
            ys[i,j] = y
            zs[i,j] = z
        end
    end
    (xs, ys, zs)
end

# ╔═╡ 94ebbb2c-c183-11ec-0789-399e0341e036
md"""With the data suitably massaged, we can directly plot either a `surface` or `wireframe` plot.
"""

# ╔═╡ 94ebbc94-c183-11ec-0ec3-cb50f27594fb
md"""---
"""

# ╔═╡ 94ebbd34-c183-11ec-265a-f5057cb52646
md"""As an aside, The above can be done more campactly with nested list comprehensions:
"""

# ╔═╡ 94ebd03a-c183-11ec-0de9-c9b5d36c321a
md"""Or using the `unzip` function directly after broadcasting:
"""

# ╔═╡ 94ebd8be-c183-11ec-25e9-e9606aeeacf5
md"""---
"""

# ╔═╡ 94ebd9a6-c183-11ec-3ea0-7f7c90329d8b
md"""For example, a sphere can be parameterized by $r(u,v) = (\sin(u)\cos(v), \sin(u)\sin(v), \cos(u))$ and visualized through:
"""

# ╔═╡ 94ebec6e-c183-11ec-1eb3-835e2772e1e6
md"""A surface of revolution for $g(u)$ revolved about the $z$ axis can be visualized through:
"""

# ╔═╡ 94ebf952-c183-11ec-3f7e-4f5081ee7683
md"""A torus with big radius $2$ and inner radius $1/2$ can be visualized as follows
"""

# ╔═╡ 94ec04ce-c183-11ec-26c4-c9624233775b
md"""A Möbius strip can be produced with:
"""

# ╔═╡ 94ec152c-c183-11ec-220d-91ffb45bf76b
md"""## Contour plots (`contour`, `heatmap`)
"""

# ╔═╡ 94ec1694-c183-11ec-23d0-cffaf854ab90
md"""For a function $z = f(x,y)$ an alternative to a surface plot, is a contour plot. That is, for different values of $c$ the level curves $f(x,y)=c$ are drawn.
"""

# ╔═╡ 94ec1716-c183-11ec-2f56-85751765141d
md"""For a function $f(x,y)$, the syntax for generating a contour plot follows that for `surface`.
"""

# ╔═╡ 94ec17ca-c183-11ec-0fa4-dbcb74985749
md"""For example, using the `peaks` function, previously defined, we have a contour plot over the region $[-5,5]\times[-5,5]$ is generated through:
"""

# ╔═╡ 94ec2672-c183-11ec-36c3-f18020bf5ce6
md"""The default of $5$ levels can be adjusted using the `levels` keyword:
"""

# ╔═╡ 94ec31ec-c183-11ec-035d-2b0f554dd21a
md"""(As a reminder, the above also shows how to generate values "`zs`" to pass to `contour` instead of a function.)
"""

# ╔═╡ 94ec326e-c183-11ec-2371-6d9f097e54c5
md"""The contour graph makes identification of peaks and valleys easy as the limits of patterns of nested contour lines.
"""

# ╔═╡ 94ec3412-c183-11ec-275e-7ba3eb0b5039
md"""An alternative visualzation using color to replace contour lines is a heatmap. The `heatmap` function produces these. The calling syntax is similar to `contour` and `surface`:
"""

# ╔═╡ 94ec3b26-c183-11ec-1a4c-9102e488e808
md"""This graph shows peaks and valleys through "hotspots" on the graph.
"""

# ╔═╡ 94ec3b6a-c183-11ec-1356-8f541df73380
md"""The `MakieGallery` package includes an example of a surface plot with both a wireframe and 2D contour graph added. It is replicated here using the `peaks` function scaled by $5$.
"""

# ╔═╡ 94ec3be2-c183-11ec-3c9b-a5cabc20645b
md"""The function and domain to plot are described by:
"""

# ╔═╡ 94ec498e-c183-11ec-3bcc-356c3bf7f1cb
md"""The `zs` were generated, as `wireframe` does not provide the interface for passing a function.
"""

# ╔═╡ 94ec4a74-c183-11ec-2796-bdb936c34381
md"""The `surface` and `wireframe` are produced as follows:
"""

# ╔═╡ 94ec51b8-c183-11ec-2716-15aadd13ceed
md"""To add the contour, a simple call via `contour!(scene, xs, ys, zs)` will place the contour at the $z=0$ level which will make it hard to read. Rather, placing at the "bottom" of the scene is desirable. To identify that the "scene limits" are queried and the argument `transformation = (:xy, zmin)` is passed to `contour!`:
"""

# ╔═╡ 94ec8232-c183-11ec-38c9-f104a86c910e
md"""The `transformation` plot attribute sets the "plane" (one of `:xy`, `:yz`, or `:xz`) at a location, in this example `zmin`.
"""

# ╔═╡ 94ec8372-c183-11ec-35e0-9f660d6205ef
md"""### Three dimensional contour plots
"""

# ╔═╡ 94ec8426-c183-11ec-2aa2-d5e3ebdc0b77
md"""The `contour` function can also plot $3$-dimensional contour plots. Concentric spheres, contours of $x^2 + y^2 + z^2 = c$ for $c > 0$ are presented by the following:
"""

# ╔═╡ 94ec92e0-c183-11ec-197a-fb45e31148ac
md"""## Vector fields. Visualizations of $f:R^2 \rightarrow R^2$
"""

# ╔═╡ 94ec93b2-c183-11ec-050d-ddfe6cf81146
md"""The vector field $f(x,y) = (y, -x)$ can be visualized as a set of vectors, $f(x,y)$, positioned at a grid. These can be produced with the `arrows` function. Below we pass a vector of points for the anchors and a vector of points representing the vectors.
"""

# ╔═╡ 94ec943e-c183-11ec-1fd4-7b2e0cbbb166
md"""We can generate these on a regular grid through:
"""

# ╔═╡ 94ec9c36-c183-11ec-3d4a-5b185f9c1333
md"""Broadcasting over `(xs, ys')` ensures each pair of possible values is encountered. The `vec` call reshapes an array into a  vector.
"""

# ╔═╡ 94ecc044-c183-11ec-2cac-e3998bc97687
md"""Calling `arrows` on the prepared data produces the graphic:
"""

# ╔═╡ 94ecedaa-c183-11ec-1598-f71464bbd200
arrows(pts, dus)

# ╔═╡ 94ecefb0-c183-11ec-31b2-3d5e73cc903b
md"""The grid seems rotated at first glance. This is due to the length of the vectors as the $(x,y)$ values get farther from the origin. Plotting the *normalized* values (each will have length $1$) can be done easily using `norm` (which requires `LinearAlgebra` to be loaded):
"""

# ╔═╡ 94ecfe60-c183-11ec-2f8c-3946f114284d
md"""The rotational pattern becomes quite clear now.
"""

# ╔═╡ 94ed0022-c183-11ec-005b-2daec2db6b92
md"""The `streamplot` function also illustrates this phenomenon. This implements an "algorithm [that] puts an arrow somewhere and extends the streamline in both directions from there. Then, it chooses a new position (from the remaining ones), repeating the the exercise until the streamline  gets blocked, from which on a new starting point, the process repeats."
"""

# ╔═╡ 94ed00cc-c183-11ec-1f05-438f2c75204e
md"""The `streamplot` function expects a `point` not a pair of values, so we adjust `f` slightly and call the function using the pattern `streamplot(f, xs, ys)`:
"""

# ╔═╡ 94ed0ca2-c183-11ec-3a32-c7a9e61bc375
md"""(The viewing range could also be adjusted with the `-5..5` notation from the `IntervalSets` package which is brought in when `AbstractPlotting` is loaded.)
"""

# ╔═╡ 94ed0cca-c183-11ec-2563-e721cccb4b9e
md"""## Interacting with a scene
"""

# ╔═╡ 94ed0eaa-c183-11ec-187f-0f823eb5b10f
md"""[Interaction](http://makie.juliaplots.org/stable/interaction.html) with a scene is very much integrated into `Makie`, as the design has a "sophisticated referencing system" which allows sharing of attributes. Adjusting one attribute, can then propogate to others.
"""

# ╔═╡ 94ed0f0e-c183-11ec-2726-15037cc30178
md"""In Makie, a `Node` is a structure that allows its value to be updated, similar to an array. Nodes are `Observables`, which when changed can trigger an event. Nodes can rely on other nodes, so events can be cascaded.
"""

# ╔═╡ 94ed0fa6-c183-11ec-3710-f94eefbce3ed
md"""A simple example is a means to dynamically adjust a label for a scene.
"""

# ╔═╡ 94ed1a08-c183-11ec-0ccc-6b11ab9fccb7
md"""We can create a "Node" through:
"""

# ╔═╡ 94ed1fb2-c183-11ec-33ef-efefcfb24f43
x = Node("x values")

# ╔═╡ 94ed3d58-c183-11ec-0f9c-35a25faaf802
md"""The value of the node is retrieved by `x[]`, though the function call `to_value(x)` is recommened, as it will be defined even when `x` is not a node. This stored value could be used to set the $x$-label in our scene:
"""

# ╔═╡ 94ed47f0-c183-11ec-07fe-a3ed18af650d
md"""We now set up an observer to update the label whenever the value of `x` is updated:
"""

# ╔═╡ 94ed5216-c183-11ec-00f2-f314bac24a1c
on(x) do val
   xlabel!(scen, val)
end

# ╔═╡ 94ed52c0-c183-11ec-23a6-1323a54681dc
md"""Now setting the value of `x` will also update the label:
"""

# ╔═╡ 94ed575c-c183-11ec-2a2e-81dc21394d19
x[] = "The x axis"

# ╔═╡ 94ed57ac-c183-11ec-0a22-7942b0aa9951
md"""A node can be more complicated. This shows how a node of $x$ value can be used to define dependent $y$ values. A scatter plot will update when the $x$ values are updated:
"""

# ╔═╡ 94e7fb18-c183-11ec-02a6-ddce69eb8cf9
scatter(xs, ys, marker=[:x,:cross, :circle], markersize=25, color=:blue)

# ╔═╡ 94e8545a-c183-11ec-3f02-ab5f49ef7388
lines([Point2(x, fx) for (x,fx) in zip(xs, f.(xs))])

# ╔═╡ 94eb482c-c183-11ec-2034-fd87f23022f2
wireframe(xs, ys, peaks.(xs, ys'), linewidth=5)

# ╔═╡ 94eb4df4-c183-11ec-0a50-19182e47ae4a
surface!(xs, ys, peaks.(xs, ys'))

# ╔═╡ 94ec3124-c183-11ec-2c95-7dbd1b1e85c9
contour(xs, ys, peaks.(xs, ys'), levels = 20)

# ╔═╡ 94ec3a70-c183-11ec-248c-d51103f66d2c
heatmap(xs, ys, peaks)

# ╔═╡ 94ed0b94-c183-11ec-2b0d-d1d358225399
begin
	g(x,y) = Point2(f(x,y))
	streamplot(g, xs, ys)
end

# ╔═╡ 94ed60dc-c183-11ec-1d99-f3a666d7dc03
md"""The `lift` function lifts the values of `xs` to the values of `ys`.
"""

# ╔═╡ 94ed6198-c183-11ec-2219-792e287a8a53
md"""These can be plotted directly:
"""

# ╔═╡ 94ed66c0-c183-11ec-1edc-3d3b2749f993
md"""Changes to the `xs` values will be reflected in the `scene`.
"""

# ╔═╡ 94ed6b2a-c183-11ec-37ea-f1e9c6528f76
xs[] = 2:9

# ╔═╡ 94ed6c74-c183-11ec-0d0e-3f135a0068b8
md"""We can incoporporate the two:
"""

# ╔═╡ 94ed9aaa-c183-11ec-3c0b-dbcf257c0bf5
md"""The `update!` call redraws the scene to adjust to increased or decreased range of $x$ values.
"""

# ╔═╡ 94ed9c44-c183-11ec-33a6-ffb0e2ba8b06
md"""The mouse position can be recorded. An example in the gallery of examples shows how.
"""

# ╔═╡ 94ed9d3e-c183-11ec-3223-e95d7babf890
md"""Here is a hint:
"""

# ╔═╡ 94ec80d4-c183-11ec-2f3c-3b4f13c246bf
begin
	xmin, ymin, zmin = minimum(scene_limits(scene))
	contour!(scene, xs, ys, zs, levels = 15, linewidth = 2, transformation = (:xy, zmin))
	center!(scene)
end

# ╔═╡ 94ed4636-c183-11ec-1ab5-1f07f3b15aca
xlabel!(scene, x[])

# ╔═╡ 94ed99b0-c183-11ec-31bb-1566cac0ed13
begin
	lab = lift(val -> "Showing from $(val.start) to $(val.stop)", xs)
	on(lab) do val
	  xlabel!(scene, val)
	  udpate!(scene)
	end
end

# ╔═╡ 94eda8d8-c183-11ec-3f6c-7361147bc1bc
md"""This will display the coordinates of the mouse in the terminal, as the mouse is moved around.
"""

# ╔═╡ 94eda9be-c183-11ec-0903-9feddb85bd43
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/plots_plotting.html">◅ previous</a>  <a href="../alternatives/plotly_plotting.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/alternatives/makie_plotting.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 94edaaea-c183-11ec-215a-bda43d4788e1
PlutoUI.TableOfContents()

# ╔═╡ 94e85be4-c183-11ec-0282-f9514328407d
begin
	xs = 1:5
	ys = [1,2,NaN, 4, 5]
	lines(xs, ys)
end

# ╔═╡ 94eb5d80-c183-11ec-0611-097590bcf5ab
begin
	r₂(x,y,z) = x^2 + y^2 + z^2 - 5/4 # a sphere
	r₄(x,y,z) = x^4 + y^4 + z^4 - 1
	xs = ys = zs = -2:2
	m2,m4 = implicit_equation(r₂, xs, ys, zs), implicit_equation(r₄, xs, ys, zs)
	
	plot(m4, color=:yellow)
	plot!(m2, color=:red)
end

# ╔═╡ 94e879c8-c183-11ec-2753-d3f6a374dfb6
begin
	xs = range(0, 2pi, length=10)
	lines(xs, sin.(xs))
	scatter!(xs, sin.(xs), markersize=10)
end

# ╔═╡ 94e8aa5e-c183-11ec-3fb4-bd097201037e
begin
	f(x) = 1/x
	a,b = -1, 1
	xs = range(-1, 1, length=200)
	scene = lines(xs, f.(xs))
	ylims!(scene, (-10, 10))
	center!(scene)
end

# ╔═╡ 94e88504-c183-11ec-059b-7756fb97bd89
begin
	xs = range(0, 2pi, length=200)
	scene = plot(xs, sin.(xs))
	rect = scene.data_limits[] # get limits for g from f
	a, b = rect.origin[1],  rect.origin[1] + rect.widths[1]
end

# ╔═╡ 94e8fede-c183-11ec-04d0-69510dcd4d02
begin
	r(t) = [sin(t), cos(t), t] # vector, not tuple
	ts = range(0, 4pi, length=200)
	scene = Scene()
	lines!(scene, Point3.(r.(ts)))
	
	nts = pi:pi/4:3pi
	us = r.(nts)
	dus = ForwardDiff.derivative.(r, nts)
	
	arrows!(scene, Point3.(us), Point3.(dus))
end

# ╔═╡ 94e72292-c183-11ec-0299-ebec9364e806
begin
	ts = [1,2,3]
	r.(ts)
end

# ╔═╡ 94daf274-c183-11ec-0c2a-5b7087b0f05f
begin
	xs = [1,2,3]
	ys = [2,3,2]
	scatter(xs, ys)
end

# ╔═╡ 94ec47ca-c183-11ec-13e3-47861d5557f2
begin
	xs = ys = range(-5, 5, length=51)
	zs = peaks.(xs, ys') / 5;
end

# ╔═╡ 94e840be-c183-11ec-0bf4-3f932121cd08
begin
	f(x) = sin(x)
	a, b = 0, 2pi
	xs = range(a, b, length=250)
	lines(xs, f.(xs))
end

# ╔═╡ 94eb3d70-c183-11ec-0916-d35504bdc533
begin
	xs = ys = range(-5, 5, length=5)
	pts = [Point3(x, y, peaks(x,y)) for x in xs for y in ys]
	scatter(pts, markersize=25)
end

# ╔═╡ 94e8e41a-c183-11ec-2826-d9fc7a8f63b5
begin
	r(t) = [sin(2t), cos(3t), t]
	ts = range(0, 2pi, length=200)
	pts = Point3.(r.(ts))
	lines(pts)
end

# ╔═╡ 94e83222-c183-11ec-089a-ef8b5d83a6e2
begin
	pts = Point2.(1:5, 1:5)
	scene = scatter(pts)
	[text!(scene, "text", position=pt, textsize=1/i, rotation=2pi/i) for (i,pt) in enumerate(pts)]
	scene
end

# ╔═╡ 94ed197e-c183-11ec-3816-eb1419bb9143
begin
	xs, = 1:5, rand(5)
	scene = scatter(xs, ys)
end

# ╔═╡ 94ed5ff4-c183-11ec-1eaf-513ca23eba33
begin
	xs = Node(1:10)
	ys = lift(a -> f.(a), xs)
end

# ╔═╡ 94ebcee6-c183-11ec-17cb-4b9db57b7a25
xs, ys, zs = [[pt[i] for pt in r.(us, vs')] for i in 1:3]

# ╔═╡ 94ec5168-c183-11ec-35c0-d5c616f35a99
begin
	scene = surface(xs, ys, zs)
	wireframe!(scene, xs, ys, zs, overdraw = true, transparency = true, color = (:black, 0.1))
end

# ╔═╡ 94e8480c-c183-11ec-3278-dd76a6f5b9a4
begin
	f(x) = cos(x)
	a, b = -pi, pi
	xs = a:pi/100:b
	lines(xs, f.(xs))
end

# ╔═╡ 94e88d1c-c183-11ec-1958-f98b3d54b660
begin
	using ForwardDiff
	f(x) = x^x
	a, b= 0, 2
	c = 0.5
	xs = range(a, b, length=200)
	
	tl(x) = f(c) + ForwardDiff.derivative(f, c) * (x-c)
	
	scene = lines(xs, f.(xs))
	lines!(scene, xs, tl.(xs), color=:blue)
end

# ╔═╡ 94e6e712-c183-11ec-01fb-675b0092b0dc
begin
	pts = [Point2(1,2), Point2(2,3), Point2(3,2)]
	scatter(pts)
end

# ╔═╡ 94ebd7ba-c183-11ec-2c5f-511de6239edc
xs, ys, zs = unzip(r.(us, vs'))

# ╔═╡ 94eda8b0-c183-11ec-3c94-3d8456703416
begin
	scene = lines(1:5, rand(5))
	pos = lift(scene.events.mouseposition) do mpos
	    @show AbstractPlotting.to_world(scene, Point2f0(mpos))
	end
end

# ╔═╡ 94e9b0de-c183-11ec-117f-594324c0353d
begin
	f(x,y) = x^3 + x^2 + x + 1 - x*y        # solve x^3 + x^2 + x + 1 = x*y
	ie = implicit_equation(f, -5:5, -10:10)
end

# ╔═╡ 94e86ed6-c183-11ec-33d6-476886a5ca99
begin
	xs = range(0, 2pi, length=100)
	scene = lines(xs, sin.(xs))
	lines!(scene, xs, cos.(xs))
end

# ╔═╡ 94ed668e-c183-11ec-3997-5b262887eca5
scene =  lines(xs, ys)

# ╔═╡ 94dae6bc-c183-11ec-2fbf-47d039db8f73
scene = Scene()

# ╔═╡ 94ebeb92-c183-11ec-2c4b-09c445df9ac3
begin
	r(u,v) = [sin(u)*cos(v), sin(u)*sin(v), cos(u)]
	us = range(0, pi, length=25)
	vs = range(0, pi/2, length=25)
	xs, ys, zs = parametric_grid(us, vs, r)
	
	scene = Scene()
	surface!(scene, xs, ys, zs)
	wireframe!(scene, xs, ys, zs)
end

# ╔═╡ 94e737f0-c183-11ec-02b5-8770db75af64
begin
	r(t) = [sin(t), cos(t), t]
	ts = range(0, 4pi, length=100)
	pts = Point3.(r.(ts))
	scatter(pts)
end

# ╔═╡ 94ec9290-c183-11ec-110f-57fa8945e358
begin
	f(x,y,z) = x^2 + y^2 + z^2
	xs = ys = zs = range(-3, 3, length=100)
	contour(xs, ys, zs, f)
end

# ╔═╡ 94e8b56c-c183-11ec-09c4-7ddba68674f7
begin
	r(t) = [sin(2t), cos(3t)]
	ts = range(0, 2pi, length=200)
	pts = Point2.(r.(ts))  # or (Point2∘r).(ts)
	lines(pts)
end

# ╔═╡ 94ebf892-c183-11ec-07f5-fd2592a0523f
begin
	g(u) = u^2 * exp(-u)
	r(u,v) = (g(u)*sin(v), g(u)*cos(v), u)
	us = range(0, 3, length=10)
	vs = range(0, 2pi, length=10)
	xs, ys, zs = parametric_grid(us, vs, r)
	
	scene = Scene()
	surface!(scene, xs, ys, zs)
	wireframe!(scene, xs, ys, zs)
end

# ╔═╡ 94eb30ee-c183-11ec-1610-e512a169a7e3
begin
	zs = peaks.(xs, ys')
	surface(xs, ys, zs)
end

# ╔═╡ 94ec9b8c-c183-11ec-2752-b748fdc0d4f1
begin
	f(x, y) = [y, -x]
	xs = ys = -5:5
	pts = vec(Point2.(xs, ys'))
	dus = vec(Point2.(f.(xs, ys')))
end

# ╔═╡ 94eb26bc-c183-11ec-08d4-7d501b04e3e3
begin
	peaks(x,y) = 3*(1-x)^2*exp(-x^2 - (y+1)^2) - 10(x/5-x^3-y^5)*exp(-x^2-y^2)- 1/3*exp(-(x+1)^2-y^2)
	xs = ys = range(-5, 5, length=25)
	surface(xs, ys, peaks)
end

# ╔═╡ 94e8a31a-c183-11ec-34bb-15223f5b9701
begin
	pts = [Point2(1,2), Point2(2,3), Point2(3,2)]
	scene = scatter(pts)
	title(scene, "3 points")
	ylabel!(scene, "y values")
	xticks!(scene, xtickrange=[1,2,3], xticklabels=["a", "b", "c"])
end

# ╔═╡ 94dadbae-c183-11ec-2849-2f7c5676e371
begin
	using AbstractPlotting
	using GLMakie
	#using WGLMakie; WGLMakie.activate!()
	#AbstractPlotting.set_theme!(scale_figure=false, resolution = (480, 400))
end

# ╔═╡ 94ec03d4-c183-11ec-259c-c17783723769
begin
	r1, r2 = 2, 1/2
	r(u,v) = ((r1 + r2*cos(v))*cos(u), (r1 + r2*cos(v))*sin(u), r2*sin(v))
	us = vs = range(0, 2pi, length=25)
	xs, ys, zs = parametric_grid(us, vs, r)
	
	scene = Scene()
	surface!(scene, xs, ys, zs)
	wireframe!(scene, xs, ys, zs)
end

# ╔═╡ 94e8f630-c183-11ec-19e9-1910018f6377
begin
	using ForwardDiff
	r(t) = [sin(t), cos(t)] # vector, not tuple
	ts = range(0, 4pi, length=200)
	scene = Scene()
	lines!(scene, Point2.(r.(ts)))
	
	nts = 0:pi/4:2pi
	us = r.(nts)
	dus = ForwardDiff.derivative.(r, nts)
	
	arrows!(scene, Point2.(us), Point2.(dus))
end

# ╔═╡ 94ec1446-c183-11ec-2462-153455823571
begin
	ws = range(-1/4, 1/4, length=8)
	thetas = range(0, 2pi, length=30)
	r(w, θ) = ((1+w*cos(θ/2))*cos(θ), (1+w*cos(θ/2))*sin(θ), w*sin(θ/2))
	xs, ys, zs = parametric_grid(ws, thetas, r)
	
	scene = Scene()
	surface!(scene, xs, ys, zs)
	wireframe!(scene, xs, ys, zs)
end

# ╔═╡ 94e8f108-c183-11ec-2c29-cd25306b72b4
begin
	xs, ys, zs = unzip(r.(ts))
	lines(xs, ys, zs)
end

# ╔═╡ 94e717ac-c183-11ec-09c4-df9a097db216
r(t) = [sin(t), cos(t)]

# ╔═╡ 94d4591e-c183-11ec-2d84-97d20c079ad0
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using AbstractPlotting
	Base.showable(m::MIME"image/png", p::AbstractPlotting.Scene) = true # instruct weave to make graphs
	nothing
end

# ╔═╡ 94e729f4-c183-11ec-364d-43b3b6488041
pts = Point2.(r.(ts))

# ╔═╡ 94ec24cc-c183-11ec-16da-33dafcb8bcd2
begin
	xs = ys = range(-5, 5, length=100)
	contour(xs, ys, peaks)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlotting = "537997a7-5e4e-5d89-9595-2241ea00577e"
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
GLMakie = "e9467ef8-e4e7-5192-8a1a-b1aee30e663a"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
MDBM = "dd61e66b-39ce-57b0-8813-509f78be4b4d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlotting = "~0.18.3"
CalculusWithJulia = "~0.0.9"
ForwardDiff = "~0.10.25"
GLMakie = "~0.4.5"
MDBM = "~0.1.4"
PlutoUI = "~0.7.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlotting]]
deps = ["Animations", "Artifacts", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Distributions", "DocStringExtensions", "FFMPEG", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "IntervalSets", "Isoband", "KernelDensity", "LinearAlgebra", "Markdown", "Match", "Observables", "Packing", "PlotUtils", "PolygonOps", "Printf", "Random", "Serialization", "Showoff", "SignedDistanceFields", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "UnicodeFun"]
git-tree-sha1 = "320f1c13006a9011cdd40ee6826c928249132ca0"
uuid = "537997a7-5e4e-5d89-9595-2241ea00577e"
version = "0.18.3"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.Animations]]
deps = ["Colors"]
git-tree-sha1 = "e81c509d2c8e49592413bfb0bb3b08150056c79d"
uuid = "27a7e980-b3e6-11e9-2bcd-0b925532e340"
version = "0.4.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Automa]]
deps = ["Printf", "ScanByte", "TranscodingStreams"]
git-tree-sha1 = "d50976f217489ce799e366d9561d56a98a30d7fe"
uuid = "67c07d97-cdcb-5c2c-af73-a7f9c32a568b"
version = "0.8.2"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "3c9862a8d41ccc11469024b1fe191223f8f8c6b4"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.9"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorBrewer]]
deps = ["Colors", "JSON", "Test"]
git-tree-sha1 = "61c5334f33d91e570e1d0c3eb5465835242582c4"
uuid = "a2cac450-b92f-5266-8821-25eda20663c8"
version = "0.4.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

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
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "6c19003824cbebd804a51211fd3bbd81bf1ecad5"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.3"

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

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "dd933c4ef7b4c270aacd4eb88fa64c147492acf0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.10.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "24d26ca2197c158304ab2329af074fbe14c988e4"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.45"

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
git-tree-sha1 = "d064b0340db45d48893e7604ec95e7a2dc9da904"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.5.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

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

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "deed294cde3de20ae0b2e0355a6c4e1c6a5ceffc"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.8"

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

[[deps.FreeType]]
deps = ["CEnum", "FreeType2_jll"]
git-tree-sha1 = "cabd77ab6a6fdff49bfd24af2ebe76e6e018a2b4"
uuid = "b38be410-82b0-50bf-ab77-7b57e271db43"
version = "4.0.0"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FreeTypeAbstraction]]
deps = ["ColorVectorSpace", "Colors", "FreeType", "GeometryBasics", "StaticArrays"]
git-tree-sha1 = "d51e69f0a2f8a3842bca4183b700cf3d9acce626"
uuid = "663a7486-cb36-511b-a19d-713bb74d65c9"
version = "0.9.1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW]]
deps = ["GLFW_jll"]
git-tree-sha1 = "35dbc482f0967d8dceaa7ce007d16f9064072166"
uuid = "f7f18e0c-5ee9-5ccd-a5bf-e8befd85ed98"
version = "3.4.1"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GLMakie]]
deps = ["ColorTypes", "Colors", "FileIO", "FixedPointNumbers", "FreeTypeAbstraction", "GLFW", "GeometryBasics", "LinearAlgebra", "Makie", "Markdown", "MeshIO", "ModernGL", "Observables", "Printf", "Serialization", "ShaderAbstractions", "StaticArrays"]
git-tree-sha1 = "5a1cb5efff725ebb6b9040eacd24044784459380"
uuid = "e9467ef8-e4e7-5192-8a1a-b1aee30e663a"
version = "0.4.5"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "4136b8a5668341e58398bb472754bff4ba0456ff"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.3.12"

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

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.GridLayoutBase]]
deps = ["GeometryBasics", "InteractiveUtils", "Match", "Observables"]
git-tree-sha1 = "d44945bdc7a462fa68bb847759294669352bd0a4"
uuid = "3955a311-db13-416c-9275-1d80ed98e5e9"
version = "0.5.7"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "a2951c93684551467265e0e32b577914f69532be"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.9"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b7bc05649af456efc75d178846f47006c2c4c3c7"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.6"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "bcf640979ee55b652f3b01650444eb7bbe3ea837"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.Isoband]]
deps = ["isoband_jll"]
git-tree-sha1 = "f9b6d97355599074dc867318950adaa6f9946137"
uuid = "f1662d9f-8043-43de-a69a-05efc1cc6ff4"
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
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "591e8dc09ad18386189610acafb970032c519707"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.3"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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
git-tree-sha1 = "a970d55c2ad8084ca317a4658ba6ce99b7523571"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.12"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MDBM]]
deps = ["LinearAlgebra", "Reexport", "StaticArrays", "Test"]
git-tree-sha1 = "f81f80af4b2b38fd48bc4c1e71add65495e33a93"
uuid = "dd61e66b-39ce-57b0-8813-509f78be4b4d"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Makie]]
deps = ["Animations", "Base64", "ColorBrewer", "ColorSchemes", "ColorTypes", "Colors", "Contour", "Distributions", "DocStringExtensions", "FFMPEG", "FileIO", "FixedPointNumbers", "Formatting", "FreeType", "FreeTypeAbstraction", "GeometryBasics", "GridLayoutBase", "ImageIO", "IntervalSets", "Isoband", "KernelDensity", "LaTeXStrings", "LinearAlgebra", "MakieCore", "Markdown", "Match", "MathTeXEngine", "Observables", "Packing", "PlotUtils", "PolygonOps", "Printf", "Random", "RelocatableFolders", "Serialization", "Showoff", "SignedDistanceFields", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "StatsFuns", "StructArrays", "UnicodeFun"]
git-tree-sha1 = "d03c5a4056707bb8d43e349bc2cb49fc1cfa8b9f"
uuid = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
version = "0.15.1"

[[deps.MakieCore]]
deps = ["Observables"]
git-tree-sha1 = "7bcc8323fb37523a6a51ade2234eee27a11114c8"
uuid = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
version = "0.1.3"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Match]]
git-tree-sha1 = "1d9bc5c1a6e7ee24effb93f175c9342f9154d97f"
uuid = "7eb4fadd-790c-5f42-8a69-bfa0b872bfbf"
version = "1.2.0"

[[deps.MathTeXEngine]]
deps = ["AbstractTrees", "Automa", "DataStructures", "FreeTypeAbstraction", "GeometryBasics", "LaTeXStrings", "REPL", "Test"]
git-tree-sha1 = "69b565c0ca7bf9dae18498b52431f854147ecbf3"
uuid = "0a4f8689-d25c-4efe-a92b-7142dfc1aa53"
version = "0.1.2"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.MeshIO]]
deps = ["ColorTypes", "FileIO", "GeometryBasics", "Printf"]
git-tree-sha1 = "6d92d825d3834ecad23ffd5582dc67da7e6f020c"
uuid = "7269a6da-0436-5bbc-96c2-40638cbb6118"
version = "0.4.7"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.ModernGL]]
deps = ["Libdl"]
git-tree-sha1 = "344f8896e55541e30d5ccffcbf747c98ad57ca47"
uuid = "66fc600b-dfda-50eb-8b99-91cfa97b1301"
version = "1.1.4"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "bfbd6fb946d967794498790aa7a0e6cdf1120f41"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.13"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

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

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e8185b83b9fc56eb6456200e873ce598ebc7f262"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.7"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "eb4dbb8139f6125471aa3da98fb70f02dc58e49c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.14"

[[deps.Packing]]
deps = ["GeometryBasics"]
git-tree-sha1 = "f4049d379326c2c7aa875c702ad19346ecb2b004"
uuid = "19eb6ba3-879d-56ad-ad62-d5c202156566"
version = "0.4.1"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "Logging", "Markdown", "Random", "Suppressor"]
git-tree-sha1 = "45ce174d36d3931cd4e37a47f93e07d1455f038d"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.1"

[[deps.PolygonOps]]
git-tree-sha1 = "77b3d3605fc1cd0b42d95eba87dfcd2bf67d5ff6"
uuid = "647866c9-e3ac-4575-94e7-e3d426903924"
version = "0.1.2"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "28ef6c7ce353f0b35d0df0d5930e0d072c1f5b9b"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

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

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.Reexport]]
deps = ["Pkg"]
git-tree-sha1 = "7b1d07f411bc8ddb7977ec7f377b97b158514fe0"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "0.2.0"

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

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SIMD]]
git-tree-sha1 = "7dbc15af7ed5f751a82bf3ed37757adf76c32402"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.4.1"

[[deps.ScanByte]]
deps = ["Libdl", "SIMD"]
git-tree-sha1 = "9cc2955f2a254b18be655a4ee70bc4031b2b189e"
uuid = "7b38b023-a4d7-4c5e-8d43-3f3097f304eb"
version = "0.3.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.ShaderAbstractions]]
deps = ["ColorTypes", "FixedPointNumbers", "GeometryBasics", "LinearAlgebra", "Observables", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "63c6b8796d28a1f942c29659e5519e2ef9ef4a59"
uuid = "65257c39-d410-5151-9873-9b3e5be5013e"
version = "0.2.7"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SignedDistanceFields]]
deps = ["Random", "Statistics", "Test"]
git-tree-sha1 = "d263a08ec505853a5ff1c1ebde2070419e3f28e9"
uuid = "73760f76-fbc4-59ce-8f25-708e95d2df96"
version = "0.4.0"

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
deps = ["OpenSpecFun_jll"]
git-tree-sha1 = "d8d8b8a9f4119829410ecd706da4cc8594a1e020"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "0.10.3"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "da4cf579416c81994afd6322365d00916c79b8ae"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "0.12.5"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "8d7530a38dbd2c397be7ddd01a424e4f411dcc41"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.2"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["Rmath", "SpecialFunctions"]
git-tree-sha1 = "ced55fd4bae008a8ea12508314e725df61f0ba45"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.7"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "Tables"]
git-tree-sha1 = "44b3afd37b17422a62aea25f04c1f7e09ce6b07f"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.5.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.Suppressor]]
git-tree-sha1 = "c6ed566db2fe3931292865b966d6d140b7ef32a9"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "aaa19086bc282630d82f818456bc40b4d314307d"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.4"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

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

[[deps.Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

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

[[deps.isoband_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51b5eeb3f98367157a7a12a1fb0aa5328946c03c"
uuid = "9a68df92-36a6-505f-a73e-abb412b6bfb4"
version = "0.2.3+0"

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
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

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
"""

# ╔═╡ Cell order:
# ╟─94eda8e2-c183-11ec-1361-17462d288031
# ╟─94d3ccb0-c183-11ec-2b52-5b3c83e1334f
# ╟─94d3d172-c183-11ec-3a71-9f3a8473368b
# ╟─94d4591e-c183-11ec-2d84-97d20c079ad0
# ╟─94d460d2-c183-11ec-10ba-d7ea38d21c35
# ╟─94d4928a-c183-11ec-30cd-2925267fc3bb
# ╟─94dad0e4-c183-11ec-2340-631fc67b9bed
# ╟─94dad280-c183-11ec-20b2-cb35b1ca82ba
# ╟─94dad2c6-c183-11ec-1405-2dc115686fa9
# ╟─94dad38e-c183-11ec-1db8-fba9662d3497
# ╠═94dadbae-c183-11ec-2849-2f7c5676e371
# ╟─94dadbea-c183-11ec-2248-e7eb87c8882e
# ╟─94dadc08-c183-11ec-1c9f-4f4d1e86f535
# ╠═94dae6bc-c183-11ec-2fbf-47d039db8f73
# ╟─94dae78e-c183-11ec-1247-b144266c64f3
# ╟─94dae7ca-c183-11ec-3a09-f5243ddb0b65
# ╟─94daea42-c183-11ec-1f08-0d59265f4cf2
# ╠═94daf274-c183-11ec-0c2a-5b7087b0f05f
# ╟─94daf3f0-c183-11ec-1cab-abd9769a36cb
# ╟─94daf40e-c183-11ec-2e73-ab158586c95a
# ╟─94e63e4a-c183-11ec-191c-bbe170ddf49f
# ╟─94e63ed8-c183-11ec-3e63-25be67f70203
# ╠═94e66ac8-c183-11ec-1b6a-11106728b29a
# ╟─94e66c46-c183-11ec-348d-07c67f91866a
# ╟─94e68d8c-c183-11ec-0e23-73dcdfa9a8f2
# ╟─94e68e68-c183-11ec-3271-d1a4a5eb2b14
# ╠═94e6e712-c183-11ec-01fb-675b0092b0dc
# ╟─94e6e926-c183-11ec-11af-0d05b01b16cb
# ╠═94e717ac-c183-11ec-09c4-df9a097db216
# ╟─94e718a6-c183-11ec-36fc-0344020882a6
# ╠═94e72292-c183-11ec-0299-ebec9364e806
# ╟─94e723e6-c183-11ec-2e0a-47d053b4e692
# ╠═94e729f4-c183-11ec-364d-43b3b6488041
# ╟─94e72ac6-c183-11ec-2b0f-57525af08744
# ╠═94e72ef4-c183-11ec-3fd5-9326eae930e5
# ╟─94e72ff8-c183-11ec-2daf-b1cdba20fdab
# ╠═94e737f0-c183-11ec-02b5-8770db75af64
# ╟─94e73c64-c183-11ec-1e93-e595ad894c64
# ╟─94e73d18-c183-11ec-27a2-35fa458d66ee
# ╠═94e795b0-c183-11ec-3acb-5f8d9ae7f43d
# ╟─94e796aa-c183-11ec-154b-0d227483fc98
# ╟─94e79790-c183-11ec-2e8b-61cb32ac13c3
# ╠═94e7a0de-c183-11ec-2921-27024f547ecc
# ╟─94e7a1a2-c183-11ec-3d59-fd3ed16f8b6a
# ╟─94e7a1cc-c183-11ec-33a1-09c5a78abae1
# ╟─94e7a2d8-c183-11ec-0b08-098dc0521860
# ╟─94e7a2f8-c183-11ec-22c3-bb9df42e20f0
# ╠═94e7fb18-c183-11ec-02a6-ddce69eb8cf9
# ╟─94e7fcd0-c183-11ec-2917-4f083801ab4b
# ╟─94e81e54-c183-11ec-396e-89070b156b00
# ╟─94e81f50-c183-11ec-07ac-8db18322bb6d
# ╟─94e82188-c183-11ec-1652-21038cc7885c
# ╟─94e821b0-c183-11ec-3206-87e92719263c
# ╠═94e83222-c183-11ec-089a-ef8b5d83a6e2
# ╟─94e832c2-c183-11ec-36fa-37e3e1db217c
# ╟─94e8340c-c183-11ec-2a1f-77f0835b3ae4
# ╟─94e8377c-c183-11ec-2101-41ff66cd0a67
# ╟─94e837b8-c183-11ec-219d-c9ef99bb562a
# ╟─94e83826-c183-11ec-2a92-93a288b5b45b
# ╟─94e83972-c183-11ec-38e5-19f04aa72ea5
# ╟─94e8398e-c183-11ec-1c32-3f968a705057
# ╟─94e839b6-c183-11ec-1cf8-9b70e52dda0d
# ╟─94e83a10-c183-11ec-149a-47e425d1a8fb
# ╠═94e840be-c183-11ec-0bf4-3f932121cd08
# ╟─94e840da-c183-11ec-3109-37f7120af40d
# ╠═94e8480c-c183-11ec-3278-dd76a6f5b9a4
# ╟─94e848de-c183-11ec-071b-0fc6707285c2
# ╟─94e848fc-c183-11ec-2dbf-0d6813562120
# ╠═94e8545a-c183-11ec-3f02-ab5f49ef7388
# ╟─94e854f0-c183-11ec-1766-ad2e775a4fa2
# ╟─94e8552a-c183-11ec-29a1-fbe26acfb0da
# ╠═94e85be4-c183-11ec-0282-f9514328407d
# ╟─94e85cd6-c183-11ec-21aa-7f382d094f9b
# ╟─94e86116-c183-11ec-1482-67aec8ce71be
# ╟─94e8629c-c183-11ec-1ab3-0fef85a2ea6a
# ╟─94e862f6-c183-11ec-27f7-514de7b75ee1
# ╠═94e86ed6-c183-11ec-33d6-476886a5ca99
# ╟─94e86fbc-c183-11ec-38be-7d59215328ce
# ╟─94e86fd0-c183-11ec-2481-0d833120ed6b
# ╠═94e879c8-c183-11ec-2753-d3f6a374dfb6
# ╟─94e87aac-c183-11ec-289e-ad4aa353cb9d
# ╟─94e87b38-c183-11ec-356e-298b243c7b74
# ╠═94e88504-c183-11ec-059b-7756fb97bd89
# ╟─94e885f6-c183-11ec-023d-a731c87fd7be
# ╟─94e88614-c183-11ec-0d85-8d11505d1f1b
# ╠═94e88d1c-c183-11ec-1958-f98b3d54b660
# ╟─94e88d42-c183-11ec-375d-a55f91f06527
# ╟─94e88de4-c183-11ec-1f10-e7e753366755
# ╟─94e88e4a-c183-11ec-267e-21a6d973815d
# ╟─94e891fe-c183-11ec-1f19-41c87a1a42c6
# ╟─94e89212-c183-11ec-3212-2f6999c0eacf
# ╟─94e892da-c183-11ec-08ba-eb97c157e93f
# ╟─94e892ee-c183-11ec-1ac8-a36879a7d9d7
# ╟─94e8930c-c183-11ec-2d38-a14a685b1c94
# ╟─94e893de-c183-11ec-2f09-81b898589319
# ╟─94e894d8-c183-11ec-1176-0ff39ad8de6c
# ╟─94e89636-c183-11ec-354d-4b992aa80b20
# ╠═94e8a31a-c183-11ec-34bb-15223f5b9701
# ╟─94e8a3b0-c183-11ec-1546-1fa1d0ad0afd
# ╠═94e8aa5e-c183-11ec-3fb4-bd097201037e
# ╟─94e8ab0a-c183-11ec-36b0-a11ad3df68e4
# ╟─94e8ab3c-c183-11ec-2690-8d2ac412dbe5
# ╟─94e8ab58-c183-11ec-0884-c7ef3aa6c8f4
# ╠═94e8b56c-c183-11ec-09c4-7ddba68674f7
# ╟─94e8b58a-c183-11ec-2448-210b94c818bd
# ╠═94e8e41a-c183-11ec-2826-d9fc7a8f63b5
# ╟─94e8e578-c183-11ec-36f8-873704132d8d
# ╠═94e8f108-c183-11ec-2c29-cd25306b72b4
# ╟─94e8f16c-c183-11ec-37bf-5b44a5705af0
# ╟─94e8f1f8-c183-11ec-158b-d3989a1b669d
# ╠═94e8f630-c183-11ec-19e9-1910018f6377
# ╟─94e8f658-c183-11ec-3352-9316e15d11ab
# ╠═94e8fede-c183-11ec-04d0-69510dcd4d02
# ╟─94e901d4-c183-11ec-01bb-ab984d141e05
# ╟─94e9026a-c183-11ec-2acd-65e65f0ba927
# ╟─94e9058a-c183-11ec-3920-37b0259e1fd9
# ╟─94e905a8-c183-11ec-0bf2-5f0780769b00
# ╟─94e9063e-c183-11ec-02ee-a5796e2ed603
# ╟─94e906b8-c183-11ec-37de-c9efa3aaf0fc
# ╠═94e93b5c-c183-11ec-1226-3f58d2068615
# ╠═94e99908-c183-11ec-31dc-ff1b1119d3a6
# ╟─94e99aea-c183-11ec-1d0b-53dc15f1cfc4
# ╠═94e9b0de-c183-11ec-117f-594324c0353d
# ╟─94e9b282-c183-11ec-1dba-6f974b017480
# ╟─94e9b46c-c183-11ec-3a17-a50f7262cce3
# ╠═94e9d140-c183-11ec-155f-8f76c9283682
# ╟─94e9d2a8-c183-11ec-35f1-63c8d247038e
# ╠═94ea38f6-c183-11ec-1945-61f8544bdbfe
# ╠═94eaf41c-c183-11ec-3451-05f6b9367aef
# ╟─94eaf714-c183-11ec-0690-650bd9cdeb62
# ╠═94eaff86-c183-11ec-1f8c-db44f319dc06
# ╟─94eb0042-c183-11ec-06e2-37e8e1016587
# ╟─94eb00a6-c183-11ec-172d-3986f2fe0ab1
# ╟─94eb0180-c183-11ec-0f61-456a86434084
# ╟─94eb01fa-c183-11ec-0d75-3f7643fd3fe0
# ╠═94eb26bc-c183-11ec-08d4-7d501b04e3e3
# ╟─94eb27f2-c183-11ec-36fd-77899a99cffa
# ╟─94eb289c-c183-11ec-2b08-03870af2715b
# ╠═94eb30ee-c183-11ec-1610-e512a169a7e3
# ╟─94eb3224-c183-11ec-3ae6-4b1549344a83
# ╟─94eb32c2-c183-11ec-1caa-2d646be77530
# ╠═94eb3d70-c183-11ec-0916-d35504bdc533
# ╟─94eb3e90-c183-11ec-18e2-d9aca7707f75
# ╠═94eb482c-c183-11ec-2034-fd87f23022f2
# ╟─94eb48b8-c183-11ec-2362-4bcb30c62cb0
# ╠═94eb4df4-c183-11ec-0a50-19182e47ae4a
# ╟─94eb4e30-c183-11ec-3450-c3788de59433
# ╟─94eb4f5c-c183-11ec-262b-c995967662d9
# ╠═94eb5d80-c183-11ec-0611-097590bcf5ab
# ╟─94eb5e02-c183-11ec-3641-db18756215b1
# ╟─94eb5e3e-c183-11ec-2422-17ac3c6d833f
# ╟─94eb5fa6-c183-11ec-2ccc-7f0f5a16eecf
# ╠═94ebb940-c183-11ec-0efa-fb167c4bbe51
# ╟─94ebbb2c-c183-11ec-0789-399e0341e036
# ╟─94ebbc94-c183-11ec-0ec3-cb50f27594fb
# ╟─94ebbd34-c183-11ec-265a-f5057cb52646
# ╠═94ebcee6-c183-11ec-17cb-4b9db57b7a25
# ╟─94ebd03a-c183-11ec-0de9-c9b5d36c321a
# ╠═94ebd7ba-c183-11ec-2c5f-511de6239edc
# ╟─94ebd8be-c183-11ec-25e9-e9606aeeacf5
# ╟─94ebd9a6-c183-11ec-3ea0-7f7c90329d8b
# ╠═94ebeb92-c183-11ec-2c4b-09c445df9ac3
# ╟─94ebec6e-c183-11ec-1eb3-835e2772e1e6
# ╠═94ebf892-c183-11ec-07f5-fd2592a0523f
# ╟─94ebf952-c183-11ec-3f7e-4f5081ee7683
# ╠═94ec03d4-c183-11ec-259c-c17783723769
# ╟─94ec04ce-c183-11ec-26c4-c9624233775b
# ╠═94ec1446-c183-11ec-2462-153455823571
# ╟─94ec152c-c183-11ec-220d-91ffb45bf76b
# ╟─94ec1694-c183-11ec-23d0-cffaf854ab90
# ╟─94ec1716-c183-11ec-2f56-85751765141d
# ╟─94ec17ca-c183-11ec-0fa4-dbcb74985749
# ╠═94ec24cc-c183-11ec-16da-33dafcb8bcd2
# ╟─94ec2672-c183-11ec-36c3-f18020bf5ce6
# ╠═94ec3124-c183-11ec-2c95-7dbd1b1e85c9
# ╟─94ec31ec-c183-11ec-035d-2b0f554dd21a
# ╟─94ec326e-c183-11ec-2371-6d9f097e54c5
# ╟─94ec3412-c183-11ec-275e-7ba3eb0b5039
# ╠═94ec3a70-c183-11ec-248c-d51103f66d2c
# ╟─94ec3b26-c183-11ec-1a4c-9102e488e808
# ╟─94ec3b6a-c183-11ec-1356-8f541df73380
# ╟─94ec3be2-c183-11ec-3c9b-a5cabc20645b
# ╠═94ec47ca-c183-11ec-13e3-47861d5557f2
# ╟─94ec498e-c183-11ec-3bcc-356c3bf7f1cb
# ╟─94ec4a74-c183-11ec-2796-bdb936c34381
# ╠═94ec5168-c183-11ec-35c0-d5c616f35a99
# ╟─94ec51b8-c183-11ec-2716-15aadd13ceed
# ╠═94ec80d4-c183-11ec-2f3c-3b4f13c246bf
# ╟─94ec8232-c183-11ec-38c9-f104a86c910e
# ╟─94ec8372-c183-11ec-35e0-9f660d6205ef
# ╟─94ec8426-c183-11ec-2aa2-d5e3ebdc0b77
# ╠═94ec9290-c183-11ec-110f-57fa8945e358
# ╟─94ec92e0-c183-11ec-197a-fb45e31148ac
# ╟─94ec93b2-c183-11ec-050d-ddfe6cf81146
# ╟─94ec943e-c183-11ec-1fd4-7b2e0cbbb166
# ╠═94ec9b8c-c183-11ec-2752-b748fdc0d4f1
# ╟─94ec9c36-c183-11ec-3d4a-5b185f9c1333
# ╟─94ecc044-c183-11ec-2cac-e3998bc97687
# ╠═94ecedaa-c183-11ec-1598-f71464bbd200
# ╟─94ecefb0-c183-11ec-31b2-3d5e73cc903b
# ╠═94ecfca8-c183-11ec-0772-d5c1de1db07f
# ╟─94ecfe60-c183-11ec-2f8c-3946f114284d
# ╟─94ed0022-c183-11ec-005b-2daec2db6b92
# ╟─94ed00cc-c183-11ec-1f05-438f2c75204e
# ╠═94ed0b94-c183-11ec-2b0d-d1d358225399
# ╟─94ed0ca2-c183-11ec-3a32-c7a9e61bc375
# ╟─94ed0cca-c183-11ec-2563-e721cccb4b9e
# ╟─94ed0eaa-c183-11ec-187f-0f823eb5b10f
# ╟─94ed0f0e-c183-11ec-2726-15037cc30178
# ╟─94ed0fa6-c183-11ec-3710-f94eefbce3ed
# ╠═94ed197e-c183-11ec-3816-eb1419bb9143
# ╟─94ed1a08-c183-11ec-0ccc-6b11ab9fccb7
# ╠═94ed1fb2-c183-11ec-33ef-efefcfb24f43
# ╟─94ed3d58-c183-11ec-0f9c-35a25faaf802
# ╠═94ed4636-c183-11ec-1ab5-1f07f3b15aca
# ╟─94ed47f0-c183-11ec-07fe-a3ed18af650d
# ╠═94ed5216-c183-11ec-00f2-f314bac24a1c
# ╟─94ed52c0-c183-11ec-23a6-1323a54681dc
# ╠═94ed575c-c183-11ec-2a2e-81dc21394d19
# ╟─94ed57ac-c183-11ec-0a22-7942b0aa9951
# ╠═94ed5ff4-c183-11ec-1eaf-513ca23eba33
# ╟─94ed60dc-c183-11ec-1d99-f3a666d7dc03
# ╟─94ed6198-c183-11ec-2219-792e287a8a53
# ╠═94ed668e-c183-11ec-3997-5b262887eca5
# ╟─94ed66c0-c183-11ec-1edc-3d3b2749f993
# ╠═94ed6b2a-c183-11ec-37ea-f1e9c6528f76
# ╟─94ed6c74-c183-11ec-0d0e-3f135a0068b8
# ╠═94ed99b0-c183-11ec-31bb-1566cac0ed13
# ╟─94ed9aaa-c183-11ec-3c0b-dbcf257c0bf5
# ╟─94ed9c44-c183-11ec-33a6-ffb0e2ba8b06
# ╟─94ed9d3e-c183-11ec-3223-e95d7babf890
# ╠═94eda8b0-c183-11ec-3c94-3d8456703416
# ╟─94eda8d8-c183-11ec-3f6c-7361147bc1bc
# ╟─94eda9be-c183-11ec-0903-9feddb85bd43
# ╟─94eda9c8-c183-11ec-3224-c56ecf97ff27
# ╟─94edaaea-c183-11ec-215a-bda43d4788e1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
