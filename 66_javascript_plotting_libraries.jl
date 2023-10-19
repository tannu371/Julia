### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 252eaa96-c184-11ec-3e1e-21a6f427604b
using PlotlyLight

# ╔═╡ 252ed7be-c184-11ec-26e7-fd614cd6cc1a
begin
	using PlotUtils
	using SplitApplyCombine
end

# ╔═╡ 253173a2-c184-11ec-11ba-97a1678cef43
using PlutoUI

# ╔═╡ 25317334-c184-11ec-0358-13d91cce56b5
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 252e546a-c184-11ec-0ffb-adb91358b886
md"""# JavaScript based plotting libraries
"""

# ╔═╡ 252e5546-c184-11ec-01fc-9f248d79146a
md"""This section uses this add-on package:
"""

# ╔═╡ 252eac30-c184-11ec-006d-9d6a852087db
md"""To avoid a dependence on the `CalculusWithJulia` package, we load two utility packages:
"""

# ╔═╡ 252ed8b0-c184-11ec-022a-cb1194aa83fc
md"""---
"""

# ╔═╡ 252ed9d0-c184-11ec-1185-29a36b3fd02b
md"""`Julia` has different interfaces to a few JavaScript plotting libraries, notably the [vega](https://vega.github.io/vega/) and [vega-lite](https://vega.github.io/vega-lite/)  through the [VegaLite.jl](https://github.com/queryverse/VegaLite.jl) package, and [plotly](https://plotly.com/javascript/) through several interfaces: `Plots.jl`, `PlotlyJS.jl`, and `PlotlyLight.jl`. These all make web-based graphics, for display through a web browser.
"""

# ╔═╡ 252eda5c-c184-11ec-329d-395c669c6f0b
md"""The `Plots.jl` interface is a backend for the familiar `Plots` package, making the calling syntax familiar, as is used throughout these notes. The `plotly()` command, from `Plots`, switches to this backend.
"""

# ╔═╡ 252efd84-c184-11ec-1ff6-295631e4b962
md"""The `PlotlyJS.jl` interface offers direct translation from `Julia` structures to the underlying `JSON` structures needed by plotly, and has mechanisms to call back into `Julia` from `JavaScript`. This allows complicated interfaces to be produced.
"""

# ╔═╡ 252efeec-c184-11ec-1a1e-bbb3a11cab84
md"""Here we discuss `PlotlyLight` which conveniently provides the translation from `Julia` structures to the `JSON` structures needed in a light-weight package, which plots quickly, without the delays due to compilation of the more complicated interfaces. Minor modifications would be needed to adjust the examples to work with `PlotlyJS` or `PlotlyBase`. The documentation for the `JavaScript` [library](https://plotly.com/javascript/) provides numerous examples which can easily be translated. The [one-page-reference](https://plotly.com/javascript/reference/) gives specific details, and is quoted from below, at times.
"""

# ╔═╡ 252eff44-c184-11ec-32ef-eb775e12124f
md"""This discussion covers the basic of graphing for calculus purposes. It does not cover, for example, the faceting common in statistical usages, or the chart types common in business and statistics uses. The `plotly` library is much more extensive than what is reviewed below.
"""

# ╔═╡ 252eff96-c184-11ec-2d66-a71229581cf9
md"""## Julia dictionaries to JSON
"""

# ╔═╡ 252f001a-c184-11ec-1d86-370e2d7591dc
md"""`PlotlyLight` uses the `JavaScript` interface for the `plotly` libraries. Unlike more developed interfaces, like the one for `Python`, `PlotlyLight` only manages the translation from `Julia` structures to `JavaScript` structures and the display of the results.
"""

# ╔═╡ 252f00b8-c184-11ec-2c14-1f1eea57c333
md"""The key to translation is the mapping for `Julia`'s dictionaries to the nested `JSON` structures needed by the `JavaScript` library.
"""

# ╔═╡ 252f011c-c184-11ec-0180-6ff0b656b0f8
md"""For example, an introductory [example](https://plotly.com/javascript/line-and-scatter/) for a scatter plot includes this `JSON` structure:
"""

# ╔═╡ 252f01c6-c184-11ec-3ccc-ab1655d23bcc
md"""```
var trace1 = {
  x: [1, 2, 3, 4],
  y: [10, 15, 13, 17],
  mode: 'markers',
  type: 'scatter'
};
```"""

# ╔═╡ 252f020c-c184-11ec-0208-7f2dc01fe62e
md"""The `{}` create a list, the `[]` an Array (or vector, as it does with `Julia`), the `name:` are keys. The above is simply translated via:
"""

# ╔═╡ 252f4372-c184-11ec-2014-bfdd2dbd6b89
Config(x = [1,2,3,4],
       y = [10, 15, 13, 17],
       mode = "markers",
       type = "scatter"
       )

# ╔═╡ 252f447e-c184-11ec-36c0-d97ae59bb782
md"""The `Config` constructor (from the `EasyConfig` package loaded with `PlotlyLight`) is an interface for a dictionary whose keys are symbols, which are produced by the named arguments passed to `Config`. By nesting `Config` statements, nested `JavaScript` structures can be built up. As well, these can be built on the fly using `.` notation, as in:
"""

# ╔═╡ 252f4cbc-c184-11ec-3c90-b57030cf83ba
begin
	cfg = Config()
	cfg.key1.key2.key3 = "value"
	cfg
end

# ╔═╡ 252f4d4a-c184-11ec-3abb-d573ca06d823
md"""To produce a figure with `PlotlyLight` then is fairly straightforward: data and, optionally, a layout are created using `Config`, then passed along to the `Plot` command producing a `Plot` object which has `display` methods defined for it. This will be illustrated through the examples.
"""

# ╔═╡ 252f4d78-c184-11ec-24b4-8d26de0ed180
md"""## Scatter plot
"""

# ╔═╡ 252f4dfc-c184-11ec-2001-b91c0d6caf5f
md"""A basic scatter plot of points $(x,y)$ is created as follows:
"""

# ╔═╡ 252f590a-c184-11ec-36a0-d9af71b20ab5
let
	xs = 1:5
	ys = rand(5)
	data = Config(x = xs,
	              y = ys,
	              type="scatter",
	              mode="markers"
	              )
	Plot(data)
end

# ╔═╡ 252f59aa-c184-11ec-32f4-a301eca48612
md"""The symbols `x` and `y` (and later `z`) specify the data to `plotly`. Here the `mode` is specified to show markers.
"""

# ╔═╡ 252f59fa-c184-11ec-2ee6-778616091322
md"""The `type` key specifies the chart or trace type. The `mode` specification sets the drawing mode for the trace. Above it is "markers". It can be any combination of "lines", "markers", or "text" joined with a "+" if more than one is desired.
"""

# ╔═╡ 252f5a18-c184-11ec-3614-29153ebfb1ec
md"""## Line plot
"""

# ╔═╡ 252f5a40-c184-11ec-2e59-8b447ad9e03b
md"""A line plot is very similar, save for a different `mode` specification:
"""

# ╔═╡ 252f6148-c184-11ec-0117-673733f6023b
let
	xs = 1:5
	ys = rand(5)
	data = Config(x = xs,
	              y = ys,
	              type="scatter",
	              mode="lines"
	              )
	Plot(data)
end

# ╔═╡ 252f618e-c184-11ec-023e-cf3874c60e1f
md"""The difference is solely the specification of the `mode` value, for a line plot it is "lines," for a scatter plot it is "markers" The `mode` "lines+markers" will plot both. The default for the "scatter" types is to use "lines+markers" for small data sets, and "lines" for others, so for this example, `mode` could be left off.
"""

# ╔═╡ 252f61f2-c184-11ec-02e3-2f398c493ec5
md"""### Nothing
"""

# ╔═╡ 252f624c-c184-11ec-352a-e717db3ba128
md"""The line graph plays connect-the-dots with the points specified by paired `x` and `y` values. *Typically*, when and `x` value is `NaN` that "dot" (or point) is skipped. However, `NaN` doesn't pass through the JSON conversion – `nothing` can be used.
"""

# ╔═╡ 252f7746-c184-11ec-3704-8df969aad612
let
	data = Config(
	    x=[0,1,nothing,3,4,5],
		y = [0,1,2,3,4,5],
	    type="scatter", mode="markers+lines")
	Plot(data)
end

# ╔═╡ 252f7778-c184-11ec-0a9b-57c130dea839
md"""## Multiple plots
"""

# ╔═╡ 252f77dc-c184-11ec-06fc-690cbb970e46
md"""More than one graph or layer can appear on a plot. The `data` argument can be a vector of `Config` values, each describing a plot. For example, here we make a scatter plot and a line plot:
"""

# ╔═╡ 252fb3d4-c184-11ec-0ad8-1705cad4b2e3
let
	data = [Config(x = 1:5,
	               y = rand(5),
	               type = "scatter",
	               mode = "markers",
	               name = "scatter plot"),
	        Config(x = 1:5,
	               y = rand(5),
	               type = "scatter",
	               mode = "lines",
	               name = "line plot")
	        ]
	Plot(data)
end

# ╔═╡ 252fb498-c184-11ec-382a-9b8360234a58
md"""The `name` argument adjusts the name in the legend referencing the plot. This is produced by default.
"""

# ╔═╡ 252fb4c2-c184-11ec-2032-d736f192e645
md"""### Adding a layer
"""

# ╔═╡ 252fb544-c184-11ec-2aeb-f9bdc648da44
md"""In `PlotlyLight`, the `Plot` object has a field `data` for storing a vector of configurations, as above. After a plot is made, this field can have values pushed onto it and the corresponding layers will be rendered when the plot is redisplayed.
"""

# ╔═╡ 252fcdc4-c184-11ec-2e2f-a786fd8a8408
md"""For example, here we plot the graphs of both the $\sin(x)$ and $\cos(x)$ over $[0,2\pi]$. We used the utility `PlotUtils.adapted_grid` to select the points to use for the graph.
"""

# ╔═╡ 252fd666-c184-11ec-3431-abb0bcd507d5
let
	a, b = 0, 2pi
	
	xs, ys = PlotUtils.adapted_grid(sin, (a,b))
	p = Plot(Config(x=xs, y=ys, name="sin"))
	
	xs, ys = PlotUtils.adapted_grid(cos, (a,b))
	push!(p.data, Config(x=xs, y=ys, name="cos"))
	
	p   # to display the plot
end

# ╔═╡ 252ff126-c184-11ec-3c01-dbe3aa39c20c
md"""The values for `a` and `b` are used to generate the $x$- and $y$-values. These can also be gathered from the existing plot object. Here is one way, where for each trace with an `x` key, the extrema are consulted to update a list of left and right ranges.
"""

# ╔═╡ 25301b42-c184-11ec-2737-6713c1dffd8b
begin
	xs, ys = PlotUtils.adapted_grid(x -> x^5 - x - 1, (0, 2))  # answer is (0,2)
	p = Plot([Config(x=xs, y=ys, name="Polynomial"),
	         Config(x=xs, y=0 .* ys, name="x-axis", mode="lines", line=Config(width=5))]
	         )
	ds = filter(d -> !isnothing(get(d, :x, nothing)), p.data)
	a=reduce(min, [minimum(d.x) for d ∈ ds]; init=Inf)
	b=reduce(max, [maximum(d.x) for d ∈ ds]; init=-Inf)
	(a, b)
end

# ╔═╡ 25301bba-c184-11ec-362f-9d45c2c29cad
md"""## Interactivity
"""

# ╔═╡ 25301c2a-c184-11ec-366c-4d571de6f7af
md"""`JavaScript` allows interaction with a plot as it is presented within a browser. (Not the `Julia` process which produced the data or the plot. For that interaction, `PlotlyJS` may be used.) The basic *default* features are:
"""

# ╔═╡ 25301f0c-c184-11ec-1eb0-6dd2ff4897e1
md"""  * The data producing a graphic are displayed on hover using flags.
  * The legend may be clicked to toggle whether the corresponding graph is displayed.
  * The viewing region can be narrowed using the mouse for selection.
  * The toolbar has several features for panning and zooming, as well as adjusting the information shown on hover.
"""

# ╔═╡ 25301f5a-c184-11ec-14d1-9ddcf3166aa4
md"""Later we will see that $3$-dimensional surfaces can be rotated interactively.
"""

# ╔═╡ 25301f84-c184-11ec-1f13-59176556a593
md"""## Plot attributes
"""

# ╔═╡ 25301f98-c184-11ec-2ae6-ddee5ceb2c5d
md"""Attributes of the markers and lines may be adjusted when the data configuration is specified. A selection is shown below. Consult the reference for the extensive list.
"""

# ╔═╡ 25301fb6-c184-11ec-2911-6bceff508853
md"""### Marker attributes
"""

# ╔═╡ 25301ff2-c184-11ec-2c2d-1f9e8a2849e7
md"""A marker's attributes can be adjusted by values passed to the `marker` key. Labels for each marker can be assigned through a `text` key and adding `text` to the `mode` key. For example:
"""

# ╔═╡ 253042ac-c184-11ec-1735-7df89c9882d3
let
	data = Config(x = 1:5,
	              y = rand(5),
	              mode="markers+text",
	              type="scatter",
	              name="scatter plot",
	              text = ["marker $i" for i in 1:5],
	              textposition = "top center",
	              marker = Config(size=12, color=:blue)
	              )
	Plot(data)
end

# ╔═╡ 2530434c-c184-11ec-27f0-e59b785a7302
md"""The `text` mode specification is necessary to have text be displayed on the chart, and not just appear on hover.  The `size` and `color` attributes are recycled; they can be specified using a vector for per-marker styling. Here the symbol `:blue` is used to specify a color, which could also be a name, such as `"blue"`.
"""

# ╔═╡ 25304392-c184-11ec-06f4-f7948287bf71
md"""#### RGB Colors
"""

# ╔═╡ 2530440a-c184-11ec-3f4f-93a9a260b9b1
md"""The `ColorTypes` package is the standard `Julia` package providing an `RGB` type (among others) for specifying red-green-blue colors. To make this work with `Config` and `JSON3` requires some type-piracy (modifying `Base.string` for the `RGB` type) to get, say, `RGB(0.5, 0.5, 0.5)` to output as `"rgb(0.5, 0.5, 0.5)"`.  (RGB values in JavaScript are integers between $0$ and $255$ or floating point values between $0$ and $1$.) A string with this content can be specified. Otherwise, something like the following can be used to avoid the type piracy:
"""

# ╔═╡ 25304bee-c184-11ec-38f4-75f718076737
begin
	struct rgb
	    r
	    g
	    b
	end
	PlotlyLight.JSON3.StructTypes.StructType(::Type{rgb}) = PlotlyLight.JSON3.StructTypes.StringType()
	Base.string(x::rgb) = "rgb($(x.r), $(x.g), $(x.b))"
end

# ╔═╡ 25304c48-c184-11ec-16a8-bb5c62f995e4
md"""With these defined, red-green-blue values can be used for colors. For example to give a range of colors, we might have:
"""

# ╔═╡ 253056d4-c184-11ec-2f28-c3351a70a942
let
	cols = [rgb(i,i,i) for i in range(10, 245, length=5)]
	sizes = [12, 16, 20, 24, 28]
	data = Config(x = 1:5,
	              y = rand(5),
	              mode="markers+text",
	              type="scatter",
	              name="scatter plot",
	              text = ["marker $i" for i in 1:5],
	              textposition = "top center",
	              marker = Config(size=sizes, color=cols)
	              )
	Plot(data)
end

# ╔═╡ 25305792-c184-11ec-28a3-5dc6668913b7
md"""The `opacity` key can be used to control the transparency, with a value between $0$ and $1$.
"""

# ╔═╡ 25305814-c184-11ec-3c1c-97b26e2e2b1e
md"""#### Marker symbols
"""

# ╔═╡ 2530586e-c184-11ec-1718-ed5562a41dd3
md"""The `marker_symbol` key can be used to set a marker shape, with the basic values being: `circle`, `square`, `diamond`, `cross`, `x`, `triangle`, `pentagon`, `hexagram`, `star`, `diamond`, `hourglass`, `bowtie`, `asterisk`, `hash`, `y`, and `line`. Add `-open` or `-open-dot` modifies the basic shape.
"""

# ╔═╡ 25309036-c184-11ec-1407-2f7f436f3967
let
	markers = ["circle", "square", "diamond", "cross", "x", "triangle", "pentagon",
	           "hexagram", "star", "diamond", "hourglass", "bowtie", "asterisk",
	           "hash", "y", "line"]
	n = length(markers)
	data = [Config(x=1:n, y=1:n, mode="markers",
	               marker = Config(symbol=markers, size=10)),
	        Config(x=1:n, y=2 .+ (1:n), mode="markers",
	               marker = Config(symbol=markers .* "-open", size=10)),
	        Config(x=1:n, y=4 .+ (1:n), mode="markers",
	               marker = Config(symbol=markers .* "-open-dot", size=10))
	        ]
	Plot(data)
end

# ╔═╡ 25309112-c184-11ec-232c-c705c4011f8d
md"""### Line attributes
"""

# ╔═╡ 25309188-c184-11ec-0afd-a3cb056a9dbe
md"""The `line` key can be used to specify line attributes, such as `width` (pixel width), `color`, or `dash`.
"""

# ╔═╡ 253091bc-c184-11ec-38c5-4b04f82bc1fb
md"""The `width` key specifies the line width in pixels.
"""

# ╔═╡ 253091da-c184-11ec-2999-5913fd0242bf
md"""The `color` key specifies the color of the line drawn.
"""

# ╔═╡ 25309248-c184-11ec-12a1-c19da3c2e72e
md"""The `dash` key specifies the style for the drawn line. Values can be set by string from "solid", "dot", "dash", "longdash", "dashdot", or "longdashdot" or set by specifying a pattern in pixels, e.g. "5px,10px,2px,2px".
"""

# ╔═╡ 2530928c-c184-11ec-1a3b-c9359f7e1e83
md"""The `shape` attribute determine how the points are connected. The default is `linear`, but other possibilities are `hv`, `vh`, `hvh`, `vhv`, `spline` for various patterns of connectivity. The following example, from the plotly documentation, shows the differences:
"""

# ╔═╡ 2530a18e-c184-11ec-034c-27888285f80f
let
	shapes = ["linear", "hv", "vh", "hvh", "vhv", "spline"]
	data = [Config(x = 1:5, y = 5*(i-1) .+ [1,3,2,3,1], mode="lines+markers", type="scatter",
	               name=shape,
	               line=Config(shape=shape)
	               ) for (i, shape) ∈ enumerate(shapes)]
	Plot(data)
end

# ╔═╡ 2530a1f2-c184-11ec-2d80-439ea99e765f
md"""### Text
"""

# ╔═╡ 2530a22e-c184-11ec-051b-f92e14054f83
md"""The text associated with each point can be drawn on the chart, when "text" is  included in the `mode` or shown on hover.
"""

# ╔═╡ 2530a29c-c184-11ec-1b58-3f1ddb538d68
md"""The onscreen text is passed to the `text` attribute. The [`texttemplate`](https://plotly.com/javascript/reference/scatter/#scatter-texttemplate) key can be used to format the text with details in the accompanying link.
"""

# ╔═╡ 2530a2ec-c184-11ec-0c4a-8156841659e3
md"""Similarly, the `hovertext` key specifies the text shown on hover, with [`hovertemplate`](https://plotly.com/javascript/reference/scatter/#scatter-hovertemplate) used to format the displayed text.
"""

# ╔═╡ 2530a314-c184-11ec-3a8d-8b46f8457179
md"""### Filled regions
"""

# ╔═╡ 2530a3be-c184-11ec-0dd4-034d8fcfd147
md"""The `fill` key for a chart of mode `line` specifies how the area around a chart should be colored, or filled. The specification are declarative, with values in "none", "tozeroy", "tozerox", "tonexty", "tonextx", "toself", and "tonext". The value of "none" is the default, unless stacked traces are used.
"""

# ╔═╡ 2530a470-c184-11ec-0946-596144060a9d
md"""In the following, to highlight the difference between $f(x) = \cos(x)$ and $p(x) = 1 - x^2/2$ the area from $f$ to the next $y$ is declared; for $p$, the area to $0$ is declared.
"""

# ╔═╡ 2530acec-c184-11ec-087e-7deef9f6d4fa
let
	xs = range(-1, 1, 100)
	data = [
	    Config(
		    x=xs, y=cos.(xs),
		    fill = "tonexty",
		    fillcolor = "rgba(0,0,255,0.25)", # to get transparency
		    line = Config(color=:blue)
	    ),
		Config(
			x=xs, y=[1 - x^2/2 for x ∈ xs ],
			fill = "tozeroy",
			fillcolor = "rgba(255,0,0,0.25)", # to get transparency
			line = Config(color=:red)
		)
	]
	Plot(data)
end

# ╔═╡ 2530ad32-c184-11ec-10a4-4bfabf75e3d7
md"""The `toself` declaration is used below to fill in a polygon:
"""

# ╔═╡ 2530c0ba-c184-11ec-330f-b9c14a1e1779
let
	data = Config(
		x=[-1,1,1,-1,-1], y = [-1,1,-1,1,-1],
		fill="toself",
		type="scatter")
	Plot(data)
end

# ╔═╡ 2530c0f6-c184-11ec-3f9e-25b8d4154361
md"""## Layout attributes
"""

# ╔═╡ 2530c146-c184-11ec-3bfe-53c606857f6f
md"""The `title` key sets the main title; the `title` key in the `xaxis` configuration sets the $x$-axis title (similarly for the $y$ axis).
"""

# ╔═╡ 2530c194-c184-11ec-279a-f91f44a4eff8
md"""The legend is shown when $2$ or more charts or specified, by default. This can be adjusted with the `showlegend` key, as below. The legend shows the corresponding `name` for each chart.
"""

# ╔═╡ 2530d282-c184-11ec-2a62-dd6465c8a790
let
	data = Config(x=1:5, y=rand(5), type="scatter", mode="markers", name="legend label")
	lyt = Config(title = "Main chart title",
	             xaxis = Config(title="x-axis label"),
	             yaxis = Config(title="y-axis label"),
	             showlegend=true
	             )
	Plot(data, lyt)
end

# ╔═╡ 2530d2d0-c184-11ec-3c5c-e335955525cf
md"""The `xaxis` and `yaxis` keys have many customizations. For example: `nticks` specifies the maximum number of ticks; `range` to set the range of the axis; `type` to specify the axis type from "linear", "log", "date", "category", or "multicategory;" and `visible`
"""

# ╔═╡ 2530d2e2-c184-11ec-20f0-799a20eb5386
md"""The aspect ratio of the chart can be set to be equal through the `scaleanchor` key, which specifies another axis to take a value from. For example, here is a parametric plot of a circle:
"""

# ╔═╡ 2530dbfe-c184-11ec-3093-a72125aba075
let
	ts = range(0, 2pi, length=100)
	data = Config(x = sin.(ts), y = cos.(ts), mode="lines", type="scatter")
	lyt = Config(title = "A circle",
	             xaxis = Config(title = "x"),
	             yaxis = Config(title = "y",
	                            scaleanchor = "x")
	             )
	Plot(data, lyt)
end

# ╔═╡ 2530dc30-c184-11ec-0a0d-815aa9397c5d
md"""#### Annotations
"""

# ╔═╡ 2530dc62-c184-11ec-1c6f-3f001e62156b
md"""Text annotations may be specified as part of the layout object. Annotations may or may not show an arrow. Here is a simple example using a vector of annotations.
"""

# ╔═╡ 2530ec20-c184-11ec-1482-c17b6c8b6f5d
let
	data = Config(x = [0, 1], y = [0, 1], mode="markers", type="scatter")
	layout = Config(title = "Annotations",
	                xaxis = Config(title="x",
	                               range = (-0.5, 1.5)),
	                yaxis = Config(title="y",
	                               range = (-0.5, 1.5)),
	                annotations = [
	                    Config(x=0, y=0, text = "(0,0)"),
	                    Config(x=1, y=1.2, text = "(1,1)", showarrow=false)
	                ]
	                )
	Plot(data, layout)
end

# ╔═╡ 2530ed2e-c184-11ec-0c10-2165c4c7a0c7
md"""The following example is more complicated use of the elements previously described. It comes from an image from [Wikipedia](https://en.wikipedia.org/wiki/List_of_trigonometric_identities) for trigonometric identities. The use of $\LaTeX$ does not seem to be supported through the `JavaScript` interface; unicode symbols are used instead. The `xanchor` and `yanchor` keys are used to position annotations away from the default. The `textangle` key is used to rotate text, as desired.
"""

# ╔═╡ 2530f602-c184-11ec-3a72-0977acb42765
let
	alpha = pi/6
	beta = pi/5
	xₘ = cos(alpha)*cos(beta)
	yₘ = sin(alpha+beta)
	r₀ = 0.1
	
	data = [
		Config(
			x = [0,xₘ, xₘ, 0, 0],
			y = [0, 0, yₘ, yₘ, 0],
			type="scatter", mode="line"
		),
		Config(
			x = [0, xₘ],
			y = [0, sin(alpha)*cos(beta)],
			fill = "tozeroy",
			fillcolor = "rgba(100, 100, 100, 0.5)"
		),
		Config(
			x = [0, cos(alpha+beta), xₘ],
			y = [0, yₘ, sin(alpha)*cos(beta)],
			fill = "tonexty",
			fillcolor = "rgba(200, 0, 100, 0.5)",
		),
		Config(
			x = [0, cos(alpha+beta)],
			y = [0, yₘ],
			line = Config(width=5, color=:black)
		)
	]
	
	lyt = Config(
		height=450,
		showlegend=false,
		xaxis=Config(visible=false),
		yaxis = Config(visible=false, scaleanchor="x"),
		annotations = [
	
			Config(x = r₀*cos(alpha/2), y = r₀*sin(alpha/2),
				   text="α", showarrow=false),
			Config(x = r₀*cos(alpha+beta/2), y = r₀*sin(alpha+beta/2),
				   text="β", showarrow=false),
			Config(x = cos(alpha+beta) + r₀*cos(pi+(alpha+beta)/2),
				   y = yₘ + r₀*sin(pi+(alpha+beta)/2),
				   xanchor="center", yanchor="center",
				   text="α+β", showarrow=false),
			Config(x = xₘ + r₀*cos(pi/2+alpha/2),
				   y = sin(alpha)*cos(beta) + r₀ * sin(pi/2 + alpha/2),
				   text="α", showarrow=false),
			Config(x = 1/2 * cos(alpha+beta),
	               y = 1/2 * sin(alpha+beta),
				   text = "1"),
			Config(x = xₘ/2*cos(alpha), y = xₘ/2*sin(alpha),
				   xanchor="center", yanchor="bottom",
				   text = "cos(β)",
				   textangle=-rad2deg(alpha),
				   showarrow=false),
			Config(x = xₘ + sin(beta)/2*cos(pi/2 + alpha),
				   y = sin(alpha)*cos(beta) + sin(beta)/2*sin(pi/2 + alpha),
				   xanchor="center", yanchor="top",
				   text = "sin(β)",
				   textangle = rad2deg(pi/2-alpha),
				   showarrow=false),
	
			Config(x = xₘ/2,
	               y = 0,
				   xanchor="center", yanchor="top",
				   text = "cos(α)⋅cos(β)", showarrow=false),
			Config(x = 0,
	               y = yₘ/2,
				   xanchor="right", yanchor="center",
				   text = "sin(α+β)",
				   textangle=-90,
				   showarrow=false),
			Config(x = cos(alpha+beta)/2,
	               y = yₘ,
				   xanchor="center", yanchor="bottom",
				   text = "cos(α+β)", showarrow=false),
			Config(x = cos(alpha+beta) + (xₘ - cos(alpha+beta))/2,
	               y = yₘ,
				   xanchor="center", yanchor="bottom",
				   text = "sin(α)⋅sin(β)", showarrow=false),
			Config(x = xₘ, y=sin(alpha)*cos(beta) + (yₘ - sin(alpha)*cos(beta))/2,
				   xanchor="left", yanchor="center",
				   text = "cos(α)⋅sin(β)",
				   textangle=90,
				   showarrow=false),
			Config(x = xₘ,
	               y = sin(alpha)*cos(beta)/2,
				   xanchor="left", yanchor="center",
				   text = "sin(α)⋅cos(β)",
				   textangle=90,
				   showarrow=false)
		]
	)
	
	Plot(data, lyt)
end

# ╔═╡ 2530f62a-c184-11ec-288e-ab1af18926d7
md"""## Parameterized curves
"""

# ╔═╡ 2530f670-c184-11ec-2722-533eb3433451
md"""In $2$-dimensions, the plotting of a parameterized curve is similar to that of plotting a function. In $3$-dimensions, an extra $z$-coordinate is included.
"""

# ╔═╡ 2530f6b6-c184-11ec-0365-4ffe9364ca78
md"""To help, we define an `unzip` function as an interface to `SplitApplyCombine`'s `invert` function:
"""

# ╔═╡ 25311a6a-c184-11ec-3b3e-3171690b1058
unzip(v) = SplitApplyCombine.invert(v)

# ╔═╡ 25311b00-c184-11ec-011e-b9a492d3949c
md"""Earlier, we plotted a two dimensional circle, here we plot the related helix.
"""

# ╔═╡ 253129a6-c184-11ec-1c89-419edba185f2
let
	helix(t) = [cos(t), sin(t), t]
	
	ts = range(0, 4pi, length=200)
	
	xs, ys, zs = unzip(helix.(ts))
	
	data = Config(x=xs, y=ys, z=zs,
	              type = "scatter3d",  # <<- note the 3d
	              mode = "lines",
	              line=(width=2,
	                    color=:red)
	              )
	
	Plot(data)
end

# ╔═╡ 25312a0a-c184-11ec-2e8e-6f081eb3c3a0
md"""The main difference is the chart type, as this is a $3$-dimensional plot, "scatter3d" is used.
"""

# ╔═╡ 25312a6e-c184-11ec-1c46-35aa3c1787f8
md"""### Quiver plots
"""

# ╔═╡ 25312b04-c184-11ec-12fb-d501372851be
md"""There is no `quiver` plot for `plotly` using JavaScript. In $2$-dimensions a text-less annotation could be employed. In $3$-dimensions, the following (from [stackoverflow.com](https://stackoverflow.com/questions/43164909/plotlypython-how-to-plot-arrows-in-3d) is a possible workaround where a line segment is drawn and capped with a small cone. Somewhat opaquely, we use `NamedTuple` for an iterator to create the keys for the data below:
"""

# ╔═╡ 2531339c-c184-11ec-3a70-8d0f7a42cbc8
let
	helix(t) = [cos(t), sin(t), t]
	helix′(t) = [-sin(t), cos(t), 1]
	ts = range(0, 4pi, length=200)
	xs, ys, zs = unzip(helix.(ts))
	helix_trace = Config(;NamedTuple(zip((:x,:y,:z), unzip(helix.(ts))))...,
	                     type = "scatter3d",  # <<- note the 3d
	                     mode = "lines",
	                     line=(width=2,
	                           color=:red)
	                     )
	
	tss = pi/2:pi/2:7pi/2
	rs, r′s = helix.(tss), helix′.(tss)
	
	arrows = [
		Config(x = [x[1], x[1]+x′[1]],
			   y = [x[2], x[2]+x′[2]],
			   z = [x[3], x[3]+x′[3]],
			   mode="lines", type="scatter3d")
		for (x, x′) ∈ zip(rs, r′s)
	]
	
	tips = rs .+ r′s
	lengths = 0.1 * r′s
	
	caps = Config(;
			NamedTuple(zip([:x,:y,:z], unzip(tips)))...,
			NamedTuple(zip([:u,:v,:w], unzip(lengths)))...,
			type="cone", anchor="tail")
	
	data = vcat(helix_trace, arrows, caps)
	
	Plot(data)
end

# ╔═╡ 253133f6-c184-11ec-164f-b3be85d1c802
md"""If several arrows are to be drawn, it might be more efficient to pass multiple values in for the `x`, `y`, ... values. They expect a vector. In the above, we create $1$-element vectors.
"""

# ╔═╡ 2531341e-c184-11ec-3a35-b5342e64056d
md"""## Contour plots
"""

# ╔═╡ 25313446-c184-11ec-120c-d34ba3ecaa95
md"""A contour plot is created by the "contour" trace type. The data is prepared as a vector of vectors, not a matrix. The following has the interior vector corresponding to slices ranging over $x$ for a fixed $y$. With this, the construction is straightforward using a comprehension:
"""

# ╔═╡ 25314116-c184-11ec-0906-d10a3de9da88
let
	f(x,y) = x^2 - 2y^2
	
	xs = range(0,2,length=25)
	ys = range(0,2, length=50)
	zs = [[f(x,y) for x in xs] for y in ys]
	
	data = Config(
		x=xs, y=ys, z=zs,
		type="contour"
	)
	
	Plot(data)
end

# ╔═╡ 2531418e-c184-11ec-0c2d-816a9ed4eee0
md"""The same `zs` data can be achieved by broadcasting and then collecting as follows:
"""

# ╔═╡ 25314a7e-c184-11ec-37bc-0bd81585107f
let
	f(x,y) = x^2 - 2y^2
	
	xs = range(0,2,length=25)
	ys = range(0,2, length=50)
	zs = collect(eachrow(f.(xs', ys)))
	
	data = Config(
		x=xs, y=ys, z=zs,
		type="contour"
	)
	
	Plot(data)
end

# ╔═╡ 25314ae4-c184-11ec-10fe-d735b3f1547e
md"""The use of just `f.(xs', ys)` or `f.(xs, ys')`, as with other plotting packages, is not effective, as `JSON3` writes matrices as vectors (with linear indexing).
"""

# ╔═╡ 25314b34-c184-11ec-3d88-a104cc2929ad
md"""## Surface plots
"""

# ╔═╡ 25314bc0-c184-11ec-3db2-ab43a6b92e92
md"""The chart type "surface" allows surfaces in $3$ dimensions to be plotted.
"""

# ╔═╡ 25314bf2-c184-11ec-2f8d-77c4511daa8d
md"""### Surfaces defined by $z = f(x,y)$
"""

# ╔═╡ 25314c18-c184-11ec-1d16-b5fcba6d3a10
md"""Surfaces defined through a scalar-valued function are drawn quite naturally, save for needing to express the height data ($z$ axis) using a vector of vectors, and not a matrix.
"""

# ╔═╡ 25316b96-c184-11ec-2e9d-6f1c3d2becd8
let
	peaks(x,y) = 3 * (1-x)^2 * exp(-(x^2) - (y+1)^2) -
	    10*(x/5 - x^3 - y^5) * exp(-x^2-y^2) - 1/3 * exp(-(x+1)^2 - y^2)
	
	xs = range(-3,3, length=50)
	ys = range(-3,3, length=50)
	zs = [[peaks(x,y) for x in xs] for y in  ys]
	
	data = Config(x=xs, y=ys, z=zs,
	              type="surface")
	
	Plot(data)
end

# ╔═╡ 25316bdc-c184-11ec-0189-39675330e010
md"""### Parametrically defined surfaces
"""

# ╔═╡ 25316c90-c184-11ec-153f-878888b0c310
md"""For parametrically defined surfaces, the $x$ and $y$ values also correspond to matrices. Her we see a pattern to plot a torus. The [`aspectmode`](https://plotly.com/javascript/reference/layout/scene/#layout-scene-aspectmode) instructs the scene's axes to be drawn in proportion with the axes' ranges.
"""

# ╔═╡ 2531732a-c184-11ec-34fe-a720eb9f9271
let
	r, R = 1, 5
	X(theta,phi) = [(r*cos(theta)+R)*cos(phi), (r*cos(theta)+R)*sin(phi), r*sin(theta)]
	
	us = range(0, 2pi, length=25)
	vs = range(0, pi, length=25)
	
	xs = [[X(u,v)[1] for u in us] for v in vs]
	ys = [[X(u,v)[2] for u in us] for v in vs]
	zs = [[X(u,v)[3] for u in us] for v in vs]
	
	data = Config(
		x = xs, y = ys, z = zs,
		type="surface",
		mode="scatter3d"
	)
	
	lyt = Config(scene=Config(aspectmode="data"))
	
	Plot(data, lyt)
end

# ╔═╡ 25317398-c184-11ec-2048-85a9efdba075
HTML("""<div class="markdown"><blockquote>
<p><a href="../alternatives/makie_plotting.html">◅ previous</a>  <a href="../integral_vector_calculus/double_triple_integrals.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/alternatives/plotly_plotting.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 253173ac-c184-11ec-3199-1de41340de5e
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlotUtils = "995b91a9-d308-5afd-9ec6-746e21dbc043"
PlotlyLight = "ca7969ec-10b3-423e-8d99-40f33abb42bf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SplitApplyCombine = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"

[compat]
PlotUtils = "~1.2.0"
PlotlyLight = "~0.5.0"
PlutoUI = "~0.7.38"
SplitApplyCombine = "~1.2.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Cobweb]]
deps = ["DefaultApplication", "Markdown", "Scratch"]
git-tree-sha1 = "02690a956a19e94c40feacbf368a5adcce5625fd"
uuid = "ec354790-cf28-43e8-bb59-b484409b7bad"
version = "0.1.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefaultApplication]]
deps = ["InteractiveUtils"]
git-tree-sha1 = "fc2b7122761b22c87fec8bf2ea4dc4563d9f8c24"
uuid = "3f0dd361-4fe0-5fc6-8523-80b14ec94d85"
version = "1.0.0"

[[deps.Dictionaries]]
deps = ["Indexing", "Random"]
git-tree-sha1 = "0340cee29e3456a7de968736ceeb705d591875a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.20"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EasyConfig]]
deps = ["JSON3", "OrderedCollections", "StructTypes"]
git-tree-sha1 = "c070b3c48a8ba3c6e6507997f0a7f5ebf85c3600"
uuid = "acab07b0-f158-46d4-8913-50acef6d41fe"
version = "0.1.10"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "8c1f668b24d999fb47baf80436194fdccec65ad2"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.PlotlyLight]]
deps = ["Artifacts", "Cobweb", "DefaultApplication", "Downloads", "EasyConfig", "JSON3", "Random"]
git-tree-sha1 = "6e25a9f62ec9cb5335d2a88eb324c62e9b1448ef"
uuid = "ca7969ec-10b3-423e-8d99-40f33abb42bf"
version = "0.5.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─25317334-c184-11ec-0358-13d91cce56b5
# ╟─252e546a-c184-11ec-0ffb-adb91358b886
# ╟─252e5546-c184-11ec-01fc-9f248d79146a
# ╠═252eaa96-c184-11ec-3e1e-21a6f427604b
# ╟─252eac30-c184-11ec-006d-9d6a852087db
# ╠═252ed7be-c184-11ec-26e7-fd614cd6cc1a
# ╟─252ed8b0-c184-11ec-022a-cb1194aa83fc
# ╟─252ed9d0-c184-11ec-1185-29a36b3fd02b
# ╟─252eda5c-c184-11ec-329d-395c669c6f0b
# ╟─252efd84-c184-11ec-1ff6-295631e4b962
# ╟─252efeec-c184-11ec-1a1e-bbb3a11cab84
# ╟─252eff44-c184-11ec-32ef-eb775e12124f
# ╟─252eff96-c184-11ec-2d66-a71229581cf9
# ╟─252f001a-c184-11ec-1d86-370e2d7591dc
# ╟─252f00b8-c184-11ec-2c14-1f1eea57c333
# ╟─252f011c-c184-11ec-0180-6ff0b656b0f8
# ╟─252f01c6-c184-11ec-3ccc-ab1655d23bcc
# ╟─252f020c-c184-11ec-0208-7f2dc01fe62e
# ╠═252f4372-c184-11ec-2014-bfdd2dbd6b89
# ╟─252f447e-c184-11ec-36c0-d97ae59bb782
# ╠═252f4cbc-c184-11ec-3c90-b57030cf83ba
# ╟─252f4d4a-c184-11ec-3abb-d573ca06d823
# ╟─252f4d78-c184-11ec-24b4-8d26de0ed180
# ╟─252f4dfc-c184-11ec-2001-b91c0d6caf5f
# ╠═252f590a-c184-11ec-36a0-d9af71b20ab5
# ╟─252f59aa-c184-11ec-32f4-a301eca48612
# ╟─252f59fa-c184-11ec-2ee6-778616091322
# ╟─252f5a18-c184-11ec-3614-29153ebfb1ec
# ╟─252f5a40-c184-11ec-2e59-8b447ad9e03b
# ╠═252f6148-c184-11ec-0117-673733f6023b
# ╟─252f618e-c184-11ec-023e-cf3874c60e1f
# ╟─252f61f2-c184-11ec-02e3-2f398c493ec5
# ╟─252f624c-c184-11ec-352a-e717db3ba128
# ╠═252f7746-c184-11ec-3704-8df969aad612
# ╟─252f7778-c184-11ec-0a9b-57c130dea839
# ╟─252f77dc-c184-11ec-06fc-690cbb970e46
# ╠═252fb3d4-c184-11ec-0ad8-1705cad4b2e3
# ╟─252fb498-c184-11ec-382a-9b8360234a58
# ╟─252fb4c2-c184-11ec-2032-d736f192e645
# ╟─252fb544-c184-11ec-2aeb-f9bdc648da44
# ╟─252fcdc4-c184-11ec-2e2f-a786fd8a8408
# ╠═252fd666-c184-11ec-3431-abb0bcd507d5
# ╟─252ff126-c184-11ec-3c01-dbe3aa39c20c
# ╠═25301b42-c184-11ec-2737-6713c1dffd8b
# ╟─25301bba-c184-11ec-362f-9d45c2c29cad
# ╟─25301c2a-c184-11ec-366c-4d571de6f7af
# ╟─25301f0c-c184-11ec-1eb0-6dd2ff4897e1
# ╟─25301f5a-c184-11ec-14d1-9ddcf3166aa4
# ╟─25301f84-c184-11ec-1f13-59176556a593
# ╟─25301f98-c184-11ec-2ae6-ddee5ceb2c5d
# ╟─25301fb6-c184-11ec-2911-6bceff508853
# ╟─25301ff2-c184-11ec-2c2d-1f9e8a2849e7
# ╠═253042ac-c184-11ec-1735-7df89c9882d3
# ╟─2530434c-c184-11ec-27f0-e59b785a7302
# ╟─25304392-c184-11ec-06f4-f7948287bf71
# ╟─2530440a-c184-11ec-3f4f-93a9a260b9b1
# ╠═25304bee-c184-11ec-38f4-75f718076737
# ╟─25304c48-c184-11ec-16a8-bb5c62f995e4
# ╠═253056d4-c184-11ec-2f28-c3351a70a942
# ╟─25305792-c184-11ec-28a3-5dc6668913b7
# ╟─25305814-c184-11ec-3c1c-97b26e2e2b1e
# ╟─2530586e-c184-11ec-1718-ed5562a41dd3
# ╠═25309036-c184-11ec-1407-2f7f436f3967
# ╟─25309112-c184-11ec-232c-c705c4011f8d
# ╟─25309188-c184-11ec-0afd-a3cb056a9dbe
# ╟─253091bc-c184-11ec-38c5-4b04f82bc1fb
# ╟─253091da-c184-11ec-2999-5913fd0242bf
# ╟─25309248-c184-11ec-12a1-c19da3c2e72e
# ╟─2530928c-c184-11ec-1a3b-c9359f7e1e83
# ╠═2530a18e-c184-11ec-034c-27888285f80f
# ╟─2530a1f2-c184-11ec-2d80-439ea99e765f
# ╟─2530a22e-c184-11ec-051b-f92e14054f83
# ╟─2530a29c-c184-11ec-1b58-3f1ddb538d68
# ╟─2530a2ec-c184-11ec-0c4a-8156841659e3
# ╟─2530a314-c184-11ec-3a8d-8b46f8457179
# ╟─2530a3be-c184-11ec-0dd4-034d8fcfd147
# ╟─2530a470-c184-11ec-0946-596144060a9d
# ╠═2530acec-c184-11ec-087e-7deef9f6d4fa
# ╟─2530ad32-c184-11ec-10a4-4bfabf75e3d7
# ╠═2530c0ba-c184-11ec-330f-b9c14a1e1779
# ╟─2530c0f6-c184-11ec-3f9e-25b8d4154361
# ╟─2530c146-c184-11ec-3bfe-53c606857f6f
# ╟─2530c194-c184-11ec-279a-f91f44a4eff8
# ╠═2530d282-c184-11ec-2a62-dd6465c8a790
# ╟─2530d2d0-c184-11ec-3c5c-e335955525cf
# ╟─2530d2e2-c184-11ec-20f0-799a20eb5386
# ╠═2530dbfe-c184-11ec-3093-a72125aba075
# ╟─2530dc30-c184-11ec-0a0d-815aa9397c5d
# ╟─2530dc62-c184-11ec-1c6f-3f001e62156b
# ╠═2530ec20-c184-11ec-1482-c17b6c8b6f5d
# ╟─2530ed2e-c184-11ec-0c10-2165c4c7a0c7
# ╠═2530f602-c184-11ec-3a72-0977acb42765
# ╟─2530f62a-c184-11ec-288e-ab1af18926d7
# ╟─2530f670-c184-11ec-2722-533eb3433451
# ╟─2530f6b6-c184-11ec-0365-4ffe9364ca78
# ╠═25311a6a-c184-11ec-3b3e-3171690b1058
# ╟─25311b00-c184-11ec-011e-b9a492d3949c
# ╠═253129a6-c184-11ec-1c89-419edba185f2
# ╟─25312a0a-c184-11ec-2e8e-6f081eb3c3a0
# ╟─25312a6e-c184-11ec-1c46-35aa3c1787f8
# ╟─25312b04-c184-11ec-12fb-d501372851be
# ╠═2531339c-c184-11ec-3a70-8d0f7a42cbc8
# ╟─253133f6-c184-11ec-164f-b3be85d1c802
# ╟─2531341e-c184-11ec-3a35-b5342e64056d
# ╟─25313446-c184-11ec-120c-d34ba3ecaa95
# ╠═25314116-c184-11ec-0906-d10a3de9da88
# ╟─2531418e-c184-11ec-0c2d-816a9ed4eee0
# ╠═25314a7e-c184-11ec-37bc-0bd81585107f
# ╟─25314ae4-c184-11ec-10fe-d735b3f1547e
# ╟─25314b34-c184-11ec-3d88-a104cc2929ad
# ╟─25314bc0-c184-11ec-3db2-ab43a6b92e92
# ╟─25314bf2-c184-11ec-2f8d-77c4511daa8d
# ╟─25314c18-c184-11ec-1d16-b5fcba6d3a10
# ╠═25316b96-c184-11ec-2e9d-6f1c3d2becd8
# ╟─25316bdc-c184-11ec-0189-39675330e010
# ╟─25316c90-c184-11ec-153f-878888b0c310
# ╠═2531732a-c184-11ec-34fe-a720eb9f9271
# ╟─25317398-c184-11ec-2048-85a9efdba075
# ╟─253173a2-c184-11ec-11ba-97a1678cef43
# ╟─253173ac-c184-11ec-3199-1de41340de5e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
