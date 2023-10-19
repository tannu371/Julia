### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ cfeb5c0a-7ad4-11ec-1bf3-4f48a6f38a3b
begin
	using CalculusWithJulia
	using Plots
	using ForwardDiff
	using SymPy
	using Roots
	using QuadGK
	using JSON
	import Contour: contours, levels, level, lines, coordinates
end

# ╔═╡ cfeb6128-7ad4-11ec-249f-f9893df219c0
begin
	using CalculusWithJulia.WeaveSupport
	using CSV, DataFrames
	import PyPlot
	pyplot()
	
	nothing
end

# ╔═╡ d01df142-7ad4-11ec-3081-7344a0df643d
using PlutoUI

# ╔═╡ d01df110-7ad4-11ec-2b29-b79ee4db4592
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ cfc7987e-7ad4-11ec-21bf-e9b665dc3a1a
md"""# Scalar functions
"""

# ╔═╡ cfca2636-7ad4-11ec-0b03-2d4a0495db36
md"""This section uses these add-on packages:
"""

# ╔═╡ cff0569c-7ad4-11ec-35a2-11abcbca2d55
md"""Consider a function $f: R^n \rightarrow R$. It has multiple arguments for its input (an $x_1, x_2, \dots, x_n$) and only one, *scalar*, value for an output. Some simple examples might be:
"""

# ╔═╡ cff2a032-7ad4-11ec-0a61-7dc549aea064
md"""```math
\begin{align}
f(x,y) &= x^2 + y^2\\
g(x,y) &= x \cdot y\\
h(x,y) &= \sin(x) \cdot \sin(y)
\end{align}
```
"""

# ╔═╡ cff48ee2-7ad4-11ec-2655-e367c71aa587
md"""For two examples from real life consider the elevation Point Query Service (of the [USGS](https://nationalmap.gov/epqs/)) returns the elevation in international feet or meters for a specific latitude/longitude within the United States. The longitude can be associated to an $x$ coordinate, the latitude to a $y$ coordinate, and the elevation a $z$ coordinate, and as long as the region is small enough, the $x$-$y$ coordinates can be thought to lie on a plane. (A flat earth assumption.)
"""

# ╔═╡ cff48f3c-7ad4-11ec-1657-d554f776531b
md"""Similarly,  a weather map, say of the United States, may show the maximum predicted temperature for a given day. This describes a function that take a position ($x$, $y$) and returns a predicted temperature ($z$).
"""

# ╔═╡ cff48f64-7ad4-11ec-0216-c5f4847d71c2
md"""Mathematically, we may describe the values $(x,y)$ in terms of a point, $P=(x,y)$ or a vector $\vec{v} = \langle x, y \rangle$ using the identification of a point with a vector. As convenient, we may write any of $f(x,y)$, $f(P)$, or $f(\vec{v})$ to describe the evaluation of $f$ at the value $x$ and $y$
"""

# ╔═╡ cff680c6-7ad4-11ec-0a80-8d881050e190
md"""---
"""

# ╔═╡ cffe0094-7ad4-11ec-06e4-058e2b3fd2da
md"""Returning to the task at hand, in `Julia`, defining a scalar function is straightforward, the syntax following mathematical notation:
"""

# ╔═╡ cffe243e-7ad4-11ec-389f-59b0050bf4eb
begin
	f(x,y) = x^2 + y^2
	g(x,y) = x * y
	h(x,y) = sin(x) * sin(y)
end

# ╔═╡ cffe24ca-7ad4-11ec-2200-e1037e303032
md"""To call a scalar function for specific values of $x$ and $y$ is also similar to the mathematical case:
"""

# ╔═╡ cffe2c22-7ad4-11ec-1fb4-63de8f11d9ff
md"""It may be advantageous to have the values as a vector or a point, as in `v=[x,y]`. Splatting can be used to turn a vector or tuple into two arguments:
"""

# ╔═╡ cffe315e-7ad4-11ec-22fc-b9797b5b47dd
md"""Alternatively, the function may be defined using a vector argument:
"""

# ╔═╡ cffe36a4-7ad4-11ec-0ef6-15ffd9b07ddb
f(v) = v[1]^2 + v[2]^2

# ╔═╡ cffe3140-7ad4-11ec-1ca2-8bd1049bb2b9
begin
	v = [1,2]
	f(v...)
end

# ╔═╡ cffe36cc-7ad4-11ec-2ace-531b9e6af7e1
md"""A style required for other packages within the `Julia` ecosystem, as there are many advantages to passing containers of values: they can have arbitrary length, they can be modified more cheaply, the functions can be more generic, etc.
"""

# ╔═╡ cffe36e0-7ad4-11ec-31a5-c17afb187647
md"""More verbosely, but avoiding index notation, we can use multiline functions:
"""

# ╔═╡ cffe3b36-7ad4-11ec-35f6-edfb20cddfcd
function g(v)
    x, y = v
    x * y
end

# ╔═╡ cffe2bdc-7ad4-11ec-18c2-89af9cd96cd7
f(1,2), g(2, 3), h(3,4)

# ╔═╡ cffe3b54-7ad4-11ec-1a78-9f9da89528e7
md"""Then we have
"""

# ╔═╡ cffe404c-7ad4-11ec-1f9f-bfed08d99c46
f(v), g([2,3])

# ╔═╡ cffe4090-7ad4-11ec-3a7c-33d923c0d940
md"""---
"""

# ╔═╡ cfff481e-7ad4-11ec-31f8-13aa1ce5e8f0
md"""More elegantly, perhaps – and the approach we will use in this section – is to mirror the mathematical notation through multiple dispatch. If we define `j` for multiple variables, say with:
"""

# ╔═╡ cfff508e-7ad4-11ec-226d-89d6be122407
j(x,y) = x^2 - 2x*y^2

# ╔═╡ cfff50c0-7ad4-11ec-1560-8d6f692e5169
md"""The we can define an alternative method with just a single variable and use splatting to turn it into multiple variables:
"""

# ╔═╡ cfff54ee-7ad4-11ec-1fc2-fb29b0f70b2a
j(v) = j(v...)

# ╔═╡ cfff5520-7ad4-11ec-2829-49b1f341ab05
md"""The we can call `j` with a vector or point:
"""

# ╔═╡ cfff57c8-7ad4-11ec-1a79-f5c64c0bee83
j([1,2])

# ╔═╡ cfff57e6-7ad4-11ec-280b-5d12d8b1f778
md"""or by passing in the individual components:
"""

# ╔═╡ cfff59be-7ad4-11ec-099b-a38c8b0a40fc
j(1,2)

# ╔═╡ cfff59f0-7ad4-11ec-2546-3fbce6dea1d7
md"""---
"""

# ╔═╡ cfff5a0c-7ad4-11ec-22ea-71cfb567e250
md"""Following a calculus perspective, we take up the question of how to visualize scalar functions within `Julia`? Further, how to describe the change in the function between nearby values?
"""

# ╔═╡ d0021d0a-7ad4-11ec-3154-9715dcc29351
md"""## Visualizing scalar functions
"""

# ╔═╡ d0021dc6-7ad4-11ec-3537-516f1ae24266
md"""Suppose for the moment that $f:R^2 \rightarrow R$. The equation $z = f(x,y)$ may be visualized by the set of points in $3$-dimensions $\{(x,y,z): z = f(x,y)\}$. This will render as a surface, and that surface will pass a "vertical line test", in that each $(x,y)$ value corresponds to at most one $z$ value. We will see alternatives for describing surfaces beyond through a function of the form $z=f(x,y)$. These are similar to how a curve in the $x$-$y$ plane can be described by a function of the form $y=f(x)$ but also through an equation of the form $F(x,y) = c$ or through a parametric description, such as is used for planar curves. For now though we focus on the case where $z=f(x,y)$.
"""

# ╔═╡ d0021e04-7ad4-11ec-1c26-0f208206e36e
md"""In `Julia`, plotting such a surface requires a generalization to plotting a univariate function where, typically, a grid of evenly spaced values is given between some $a$ and $b$, the corresponding $y$ or $f(x)$ values are found, and then the points are connected in a dot-to-dot manner.
"""

# ╔═╡ d0021e40-7ad4-11ec-31b6-4f6fb53a125f
md"""Here, a two-dimensional grid of $x$-$y$ values needs specifying, and the corresponding $z$ values found. As the grid will be assumed to be regular only the $x$ and $y$ values need specifying, the set of pairs can be computed. The $z$ values, it will be seen, are easily computed. This cloud of points is plotted and each cell in the $x$-$y$ plane is plotted with a surface giving the $x$-$y$-$z$, 3-dimensional, view. One way to plot such a surface is to tessalate the cell and then for each triangle, represent a plane made up of the $3$ boundary points.
"""

# ╔═╡ d0021e72-7ad4-11ec-034e-fbbbe8ae064f
md"""Here is an example:
"""

# ╔═╡ d002253e-7ad4-11ec-21c2-718848156e6c
𝒇(x, y) = x^2 + y^2

# ╔═╡ d0022dea-7ad4-11ec-1714-4d80adf6a555
begin
	xs = range(-2, 2, length=100)
	ys = range(-2, 2, length=100)
	
	surface(xs, ys, 𝒇)
end

# ╔═╡ d0022e1c-7ad4-11ec-2e1b-11d66abecdd4
md"""The `surface` function will generate the surface.
"""

# ╔═╡ d00235b0-7ad4-11ec-1c47-fd502591d1b8
note("""Using `surface` as a function name is equivalent to `plot(xs, ys, f, seriestype=:surface)`.""")

# ╔═╡ d002363c-7ad4-11ec-1c96-bd5be5ab3546
md"""We can also use `surface(xs, ys, zs)` where `zs` is not a vector, but rather a *matrix* of values corresponding to a grid described by the `xs` and `ys`. A matrix is a rectangular collection of values indexed by row and column through indices `i` and `j`. Here the values in `zs` should satisfy: the $i$th row and $j$th column entry should be $z_{ij} = f(x_i, y_j)$ where $x_i$ is the $i$th entry from the `xs` and $y_j$ the $j$th entry from the `ys`.
"""

# ╔═╡ d0023652-7ad4-11ec-1f52-15bdd9445a95
md"""We can generate this using a comprehension:
"""

# ╔═╡ d0023e52-7ad4-11ec-009c-2f2ceb368944
let
	zs = [𝒇(x,y) for y in ys, x in xs]
	surface(xs, ys, zs)
end

# ╔═╡ d0023eca-7ad4-11ec-1802-09977aae2623
md"""If remembering that the $y$ values go first, and then the $x$ values in the above is too hard, then an alternative can be used. Broadcasting `f.(xs,ys)` may not make sense, were the `xs` and `ys` not of commensurate lengths, and when it does, this call pairs off `xs` and `ys` values and passes them to `f`. What is desired here is different, where for each `xs` value there are pairs for each of the `ys` values. The syntax `xs'` can ve viewed as creating a *row* vector, where `xs` is a *column* vector. Broadcasting will create a *matrix*  of values in this case. So the following is identical to the above:
"""

# ╔═╡ d002435c-7ad4-11ec-3ecc-2f1bcd4252e1
surface(xs, ys, 𝒇.(xs', ys))

# ╔═╡ d0024384-7ad4-11ec-22e9-bb2093ce2b92
md"""(This is still subtle. The use of the adjoint operation on `ys` will error if the dimensions are not square, but will produce an incorrect surface if not. It would be best to simply pass the function and let `Plots` handle this detail which for the alternative `Makie` is reversed.)
"""

# ╔═╡ d00243ac-7ad4-11ec-18c0-1dcb5f73c2fa
md"""---
"""

# ╔═╡ d00243d4-7ad4-11ec-15a4-4745cd696d6d
md"""An alternate to `surface` is `wireframe` – which may not use shading in all backenends. This displays a grid in the $x$-$y$ plane mapped to the surface:
"""

# ╔═╡ d0024618-7ad4-11ec-02df-d756524bcc1a
wireframe(xs, ys, 𝒇)   # gr() or pyplot() wireplots render better than plotly()

# ╔═╡ d004fe1c-7ad4-11ec-3a9a-5bc1fc576687
md"""##### Example
"""

# ╔═╡ d004feda-7ad4-11ec-21bb-1df57b2fbadd
md"""The surface $f(x,y) = x^2 - y^2$ has a "saddle," as this shows:
"""

# ╔═╡ d005092a-7ad4-11ec-0db7-4d8ca320cede
let
	f(x,y) = x^2 - y^2
	xs = ys = range(-2, 2, length=100)
	surface(xs, ys, f)
end

# ╔═╡ d0050952-7ad4-11ec-272a-85317095a7a9
md"""##### Example
"""

# ╔═╡ d005098e-7ad4-11ec-18b2-77d74045fe71
md"""As mentioned. In plots of univariate functions, a dot-to-dot algorithm is followed. For surfaces, the two dots are replaced by four points, which over determines a plane. Some choice is made to partition that rectangle into two triangles, and for each triangle, the $3$ resulting points determines a plane, which can be suitably rendered.
"""

# ╔═╡ d00509ca-7ad4-11ec-15fd-cdf9f667934b
md"""We can see this in the `pyplot` toolkit by forcing the surface to show just one cell, as the `xs` and `ys` below only contain $2$ values:
"""

# ╔═╡ d005112c-7ad4-11ec-290e-e997af9adb52
let
	xs = [-1,1]; ys = [-1,1]
	f(x,y) = x*y
	surface(xs, ys, f)
end

# ╔═╡ d005114c-7ad4-11ec-00e2-b1e8470c449c
md"""Compare this, to the same region, but with many cells to represent the surface:
"""

# ╔═╡ d0051854-7ad4-11ec-0743-7df8f68d0977
let
	xs = ys = range(-1, 1, length=100)
	f(x,y) = x*y
	surface(xs, ys, f)
end

# ╔═╡ d007f782-7ad4-11ec-2af1-8d4d0f0ea4e4
md"""### Contour plots
"""

# ╔═╡ d007ff18-7ad4-11ec-15ba-f3ca8f9dce45
#n,m = 25,50
#xs = range(-74.3129825592041, -74.2722129821777, length=n)
#ys = range(40.7261855236006, 40.7869834960339, length=m)
#d = DataFrame(xs =reshape([m[1] for m in [(xi,yi) for xi in xs, yi in ys]], (n*m),),
#       ys = reshape([m[2] for m in [(xi,yi) for xi in xs, yi in ys]], (n*m,)))
# In RCall
#using RCall
#z = R"""
#library(elevatr)
#z = get_elev_point($d, prj="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
#z = data.frame(z)
#"""
#elev = rcopy(DataFrame, z).elevation
#zs = reshape(elev, m, n)
#D = Dict(:xs => xs, :ys=>ys, :zs => elev)
#io = open("data/somocon.json", "w")
#JSON.print(io, D)
#close(io)
nothing

# ╔═╡ d007ff9a-7ad4-11ec-2a24-89ed3b8c64fa
md"""Consider the example of latitude, longitude, and elevation data describing a surface. The following graph is generated from such data, which was retrieved from the USGS website for a given area. The grid points are chosen about every $150$m, so this is not too fine grained.
"""

# ╔═╡ d009a142-7ad4-11ec-005d-e13673223724
begin
	somocon = """
	{"ys":[40.7261855236006,40.72742629854822,40.728667073495835,40.72990784844345,40.73114862339107,40.73238939833869,40.73363017328631,40.734870948233926,40.736111723181544,40.73735249812916,40.73859327307678,40.7398340480244,40.74107482297202,40.742315597919635,40.74355637286725,40.74479714781487,40.74603792276249,40.74727869771011,40.748519472657726,40.749760247605344,40.75100102255296,40.75224179750058,40.7534825724482,40.75472334739582,40.755964122343435,40.75720489729106,40.75844567223868,40.7596864471863,40.760927222133915,40.762167997081534,40.76340877202915,40.76464954697677,40.76589032192439,40.767131096872006,40.768371871819625,40.76961264676724,40.77085342171486,40.77209419666248,40.7733349716101,40.774575746557716,40.775816521505334,40.77705729645295,40.77829807140057,40.77953884634819,40.78077962129581,40.782020396243425,40.78326117119104,40.78450194613866,40.78574272108628,40.7869834960339],"zs":[56.01,51.48,51.74,44.9,45.6,48.76,51.94,61.55,73.28,66.29,63.29,61.46,58.49,50.06,44.18,41.35,39.9,39.84,36.59,39.0,32.85,30.03,33.51,41.28,48.27,62.42,60.31,47.04,45.5,48.2,53.46,64.52,90.94,99.45,88.22,77.94,74.07,67.39,57.02,48.88,45.05,48.09,43.18,39.9,39.08,40.62,33.1,31.9,36.77,43.92,71.71,69.82,57.64,46.98,60.73,60.83,96.1,142.76,137.34,115.32,94.89,84.02,76.91,67.68,56.16,48.75,51.23,49.58,44.37,39.98,41.33,39.08,33.27,34.35,38.63,74.36,76.11,64.27,50.65,61.01,87.64,127.37,144.27,154.88,154.21,121.78,101.25,89.54,78.44,65.93,57.72,53.51,54.97,50.69,45.22,40.48,37.04,35.56,33.26,36.96,77.43,64.79,71.06,63.36,57.43,106.1,134.93,142.34,148.85,155.99,159.95,124.49,103.86,87.97,76.57,68.22,60.35,57.23,55.58,51.15,42.79,40.6,41.94,34.53,34.96,78.13,73.79,75.67,56.64,60.87,96.08,128.31,138.22,143.42,153.35,161.87,155.41,122.68,104.06,87.5,77.81,68.75,64.85,60.88,59.44,47.98,44.57,45.44,42.71,35.23,77.37,77.0,77.61,59.73,63.84,99.1,113.48,135.22,152.77,151.16,158.9,162.84,153.3,120.58,103.98,87.91,79.23,73.92,67.96,64.94,53.54,44.0,50.07,46.93,43.32,88.65,84.02,80.83,65.49,59.07,77.84,103.68,125.53,147.66,160.47,159.49,164.66,165.91,146.24,118.18,102.01,88.47,80.25,74.83,70.48,62.1,49.47,48.1,53.33,48.34,99.44,88.01,84.27,82.97,60.09,69.83,92.51,113.41,135.15,149.8,164.15,160.75,163.8,167.33,147.47,118.41,101.95,88.65,82.18,78.29,69.59,55.74,49.71,51.8,57.88,102.64,104.12,97.82,74.39,68.53,60.14,77.6,99.22,117.22,130.03,153.71,162.09,161.09,164.47,167.19,139.18,114.62,97.97,87.68,83.73,76.03,60.99,51.93,49.41,59.15,114.76,115.62,99.65,95.47,95.31,70.6,60.14,75.41,100.54,122.61,141.39,157.32,160.93,163.17,167.0,158.25,129.02,112.59,96.6,89.03,80.11,65.83,56.0,49.52,54.51,121.11,111.04,114.21,111.8,105.23,102.43,66.8,74.98,99.48,111.59,126.23,144.81,163.02,164.44,165.56,165.01,157.87,129.18,108.67,96.9,87.28,74.81,60.53,53.12,52.44,123.96,126.43,127.51,124.19,107.58,92.65,67.27,74.09,95.48,102.63,123.05,143.73,153.72,166.16,164.96,166.27,166.6,156.49,122.54,104.98,94.24,81.41,70.53,60.0,55.06,132.49,128.75,142.22,132.8,116.22,95.17,78.05,65.54,73.44,94.77,122.63,150.45,159.95,162.54,164.74,165.55,167.95,167.5,141.39,116.28,102.84,88.36,78.59,68.04,59.33,135.9,129.63,135.65,149.65,131.83,109.12,92.13,67.31,71.28,95.2,105.78,133.74,155.48,169.13,167.16,163.63,164.41,168.11,159.05,128.09,109.31,95.72,85.54,79.65,67.48,139.88,133.57,135.32,141.51,145.89,119.2,96.72,77.69,69.21,80.55,95.18,129.15,144.98,165.06,158.96,167.14,159.53,164.18,156.31,133.83,121.74,108.38,93.46,86.54,79.24,142.73,152.05,156.37,143.59,147.61,126.53,103.08,90.34,92.32,71.97,83.82,113.32,135.91,156.39,150.75,161.93,157.2,155.83,154.93,150.37,140.2,119.8,102.33,94.4,90.57,136.21,140.78,156.4,162.33,152.52,138.31,127.93,95.01,89.0,83.32,74.11,102.61,125.18,134.58,135.15,151.46,152.13,149.58,153.91,156.0,162.27,132.0,115.84,105.2,99.94,133.21,139.49,147.1,157.23,167.48,154.91,135.91,111.99,94.57,90.76,78.29,83.11,102.76,112.19,120.68,136.88,137.72,144.85,153.46,161.94,169.27,165.91,133.39,118.98,107.7,136.68,139.87,152.59,158.63,167.04,165.88,161.25,126.56,102.07,93.71,79.93,81.49,96.21,93.82,101.26,124.57,146.39,150.26,147.96,158.73,168.95,173.35,156.12,130.89,116.13,131.8,135.34,149.18,158.94,158.41,153.19,153.96,152.89,109.61,101.17,103.41,91.12,79.35,83.68,90.6,118.7,139.47,152.39,155.23,154.36,163.94,171.28,171.87,141.11,123.49,128.26,127.93,136.81,138.07,139.58,140.93,137.3,139.21,119.46,103.23,100.02,95.77,81.51,93.65,103.9,120.91,126.51,147.94,160.93,159.58,158.97,170.02,173.4,171.77,133.46,129.34,123.57,125.8,127.17,134.63,140.14,141.37,132.18,121.88,112.02,104.23,98.86,81.28,97.91,96.43,113.3,139.2,143.14,155.76,166.2,158.24,165.4,171.77,172.06,140.75,112.75,119.41,120.86,124.88,134.42,145.88,159.11,160.31,147.24,125.13,112.38,100.79,87.49,88.87,99.02,114.24,130.88,155.17,156.39,166.16,161.29,161.34,161.94,158.02,158.28,106.87,113.99,118.24,122.56,133.41,145.66,155.71,165.71,165.42,155.14,127.78,111.46,91.2,91.16,97.31,106.22,134.23,149.23,164.3,163.19,170.52,162.95,168.76,152.24,161.13,121.83,121.15,119.0,121.56,129.72,140.09,153.12,162.86,168.34,168.92,161.0,128.69,108.79,89.1,87.66,99.02,125.32,149.07,162.35,168.22,170.28,171.39,167.62,172.27,174.12,124.29,121.09,122.74,121.68,128.9,135.39,145.94,155.36,157.98,166.38,171.83,161.26,117.38,101.24,92.25,90.26,111.61,132.57,145.7,165.92,169.35,170.59,169.76,175.52,175.58,127.46,123.56,122.96,122.32,125.0,129.83,139.32,144.75,145.12,151.16,159.37,163.38,125.29,108.04,102.34,100.38,100.38,118.72,144.25,162.56,168.8,175.06,173.27,175.9,176.65,129.23,123.85,124.3,124.41,126.73,127.33,130.66,135.53,143.09,163.18,161.45,160.31,146.71,123.03,104.09,100.38,100.38,104.73,136.26,158.26,162.47,172.58,172.73,171.67,176.73,120.55,127.56,125.67,126.14,127.67,129.82,129.3,132.26,143.3,161.39,171.13,173.89,171.66,131.8,107.61,100.38,100.38,102.62,126.85,144.66,154.41,172.86,175.48,172.4,173.72,116.01,126.43,125.59,126.5,131.19,129.04,134.07,136.27,135.63,142.09,159.11,175.01,179.52,138.05,101.75,102.8,100.38,100.38,112.51,127.4,152.04,170.15,172.66,169.62,171.11,110.18,130.36,129.34,129.04,134.03,141.08,139.77,145.16,147.8,149.31,165.49,172.97,175.88,134.81,108.36,103.24,100.38,100.38,106.34,121.12,144.63,160.44,166.56,164.1,169.59,104.51,119.17,134.58,130.33,134.6,141.51,155.8,151.57,159.5,155.76,158.77,163.45,159.48,143.39,111.96,107.48,100.38,100.38,104.99,113.14,132.14,150.97,163.91,158.67,167.88,96.5,107.46,121.18,145.9,141.42,141.48,145.83,143.74,150.62,145.75,144.48,148.36,146.6,149.51,122.77,111.64,104.44,100.38,102.92,111.09,126.52,143.73,159.52,155.23,163.23,90.59,97.17,112.25,134.94,140.29,135.93,137.72,134.54,137.69,132.11,135.01,141.86,149.14,153.19,150.77,116.52,106.07,101.64,102.67,106.72,122.36,136.38,153.14,160.57,154.01,84.27,91.0,99.89,120.09,123.15,120.86,128.41,127.42,126.42,129.29,143.8,149.59,165.05,163.71,156.91,126.17,110.32,103.98,102.7,105.38,113.28,126.0,141.28,156.94,142.7,79.52,85.85,89.72,96.0,103.94,109.11,113.31,125.44,129.86,134.67,139.17,154.89,169.61,178.97,171.75,153.95,122.39,110.25,101.31,104.01,111.03,119.34,127.07,138.48,150.35,78.71,83.85,92.84,103.12,118.74,123.26,124.38,132.82,135.71,139.43,142.35,153.33,166.66,178.73,179.83,177.3,146.91,115.31,103.65,102.19,108.29,120.87,140.26,153.15,161.64,76.53,81.19,85.54,97.94,114.77,120.33,127.56,136.91,150.14,148.19,151.04,158.93,159.35,167.55,176.78,177.43,168.22,122.85,106.91,103.39,105.17,112.83,127.37,149.56,158.63,76.9,80.11,83.05,89.9,103.9,107.88,113.18,128.27,146.95,157.8,156.48,162.97,152.02,155.46,175.3,175.85,165.8,124.73,118.12,105.54,104.85,113.42,120.65,135.84,155.64,76.36,79.74,86.01,86.54,92.08,95.01,105.42,123.23,141.01,149.2,147.39,149.84,141.68,150.58,164.87,169.4,157.16,159.46,134.27,110.78,103.99,110.46,118.75,135.33,152.69,78.1,78.68,86.48,90.58,93.27,92.16,97.28,110.67,126.28,130.56,128.0,128.45,127.66,137.06,149.28,153.26,160.61,169.86,156.81,123.71,103.82,106.59,113.73,127.34,148.38,82.35,80.09,82.09,88.63,95.05,96.56,97.26,100.99,110.38,113.98,120.77,132.22,134.76,147.55,166.07,170.47,169.35,168.89,155.55,134.24,110.96,104.36,108.32,118.05,136.24,84.15,84.23,82.32,87.76,91.64,93.12,96.96,106.33,111.31,106.79,119.35,132.95,147.96,153.55,165.8,178.43,178.35,170.88,165.74,140.36,119.17,107.65,106.75,113.56,127.58,82.99,85.54,84.77,84.53,90.08,95.19,95.25,105.43,118.46,119.85,116.2,129.13,142.15,149.56,155.14,171.6,179.44,174.73,161.75,142.72,129.9,115.26,107.99,111.72,121.99,83.01,84.0,87.7,86.06,85.61,94.36,100.3,105.68,117.92,125.39,115.72,129.22,138.43,141.11,151.63,160.55,168.46,164.25,159.16,150.23,136.74,122.5,113.66,108.45,114.78,84.11,84.63,86.98,90.22,88.1,91.68,100.12,113.41,115.57,121.86,128.81,118.67,129.66,133.23,141.51,145.97,148.93,150.71,162.12,166.27,141.86,130.13,115.63,109.05,112.53,85.03,84.97,87.49,89.39,93.67,94.55,102.32,113.85,127.45,126.0,130.58,124.19,132.07,132.58,131.1,139.71,148.52,162.21,157.78,164.7,149.31,142.46,128.04,109.0,110.09,85.93,87.73,89.92,90.55,93.51,98.52,103.9,118.72,129.55,133.86,136.06,137.44,136.47,146.6,143.25,136.06,157.12,172.07,169.4,168.79,158.26,144.45,138.0,111.86,109.03,87.34,90.39,91.4,93.1,91.44,93.54,97.58,115.07,124.02,123.47,137.17,141.91,149.48,150.24,151.28,139.57,144.66,162.92,170.62,177.08,172.96,151.89,129.57,120.07,112.54],"xs":[-74.3129825592041,-74.311283826828,-74.3095850944519,-74.3078863620758,-74.3061876296997,-74.30448889732361,-74.30279016494751,-74.3010914325714,-74.2993927001953,-74.2976939678192,-74.2959952354431,-74.294296503067,-74.2925977706909,-74.2908990383148,-74.2892003059387,-74.28750157356261,-74.28580284118651,-74.28410410881041,-74.2824053764343,-74.2807066440582,-74.2790079116821,-74.277309179306,-74.2756104469299,-74.2739117145538,-74.2722129821777]}
	"""
	lenape_csv = """
	"","elevation","elev_units","longitude","latitude"
	"1",126.85,"meters",-74.2986363,40.7541939
	"2",125.19,"meters",-74.298561,40.754122
	"3",123.52,"meters",-74.298505,40.754049
	"4",121.92,"meters",-74.298435,40.753972
	"5",119.86,"meters",-74.298402,40.753872
	"6",119.86,"meters",-74.298416,40.753818
	"7",119.86,"meters",-74.298393,40.753805
	"8",118.32,"meters",-74.298233,40.753717
	"9",118.48,"meters",-74.298113,40.753706
	"10",118.48,"meters",-74.298079,40.753714
	"11",110.65,"meters",-74.297548,40.753434
	"12",108.68,"meters",-74.297364,40.753392
	"13",108.68,"meters",-74.2973338,40.7533463
	"14",107.67,"meters",-74.2972265,40.7533169
	"15",107.54,"meters",-74.297087,40.753356
	"16",107.54,"meters",-74.2970438,40.7533584
	"17",106.74,"meters",-74.296979,40.753397
	"18",107.69,"meters",-74.29689,40.753533
	"19",108.01,"meters",-74.296812,40.753661
	"20",108.34,"meters",-74.296718,40.753785
	"21",108.93,"meters",-74.296627,40.753874
	"22",109.26,"meters",-74.296514,40.753973
	"23",109.44,"meters",-74.296377,40.754026
	"24",107.8,"meters",-74.296184,40.754049
	"25",108.14,"meters",-74.29596,40.754119
	"26",108.31,"meters",-74.295761,40.754191
	"27",107.08,"meters",-74.295542,40.754277
	"28",106.54,"meters",-74.295345,40.754276
	"29",105.18,"meters",-74.295177,40.754295
	"30",104.93,"meters",-74.2951,40.754358
	"31",103.79,"meters",-74.294976,40.754381
	"32",103.79,"meters",-74.294943,40.754379
	"33",103.62,"meters",-74.294873,40.754362
	"34",103.46,"meters",-74.294805,40.754359
	"35",102.68,"meters",-74.294687,40.754349
	"36",102.78,"meters",-74.294537,40.754269
	"37",100.91,"meters",-74.294341,40.754248
	"38",101.24,"meters",-74.294228,40.754249
	"39",101.15,"meters",-74.294146,40.75427
	"40",100.73,"meters",-74.294043,40.754277
	"41",100.77,"meters",-74.293997,40.75418
	"42",97.54,"meters",-74.293672,40.75418
	"43",97.58,"meters",-74.293539,40.754324
	"44",97.41,"meters",-74.293442,40.754447
	"45",97.02,"meters",-74.29342,40.754555
	"46",96.78,"meters",-74.293397,40.754677
	"47",96.72,"meters",-74.293319,40.754787
	"48",96.98,"meters",-74.2933093,40.7549621
	"49",97.04,"meters",-74.2931914,40.7550903
	"50",95.89,"meters",-74.2931359,40.7552002
	"51",95.48,"meters",-74.293124,40.75528
	"52",95.43,"meters",-74.293142,40.755375
	"53",95.58,"meters",-74.293163,40.7554692
	"54",95.58,"meters",-74.2931806,40.7555174
	"55",95.31,"meters",-74.2930826,40.7555402
	"56",95.45,"meters",-74.2930283,40.7555572
	"57",94.19,"meters",-74.2929292,40.7555853
	"58",93.57,"meters",-74.2928114,40.7556067
	"59",92.9,"meters",-74.2927408,40.7556127
	"60",92.9,"meters",-74.2926921,40.7556257
	"61",91.46,"meters",-74.2926528,40.7556602
	"62",91.46,"meters",-74.2926104,40.7556888
	"63",88.42,"meters",-74.2925696,40.7557042
	"64",88.42,"meters",-74.2925272,40.7556876
	"65",85.62,"meters",-74.2924927,40.7556674
	"66",85.32,"meters",-74.2924503,40.755646
	"67",85.32,"meters",-74.2924377,40.7556222
	"68",85.32,"meters",-74.2924377,40.7555877
	"69",84.49,"meters",-74.2924346,40.7555365
	"70",84.49,"meters",-74.2924236,40.755502
	"71",84.36,"meters",-74.2923562,40.7554961
	"""
	nothing
end

# ╔═╡ d009a7dc-7ad4-11ec-3dc5-3f56f8949f40
begin
	SC = JSON.parse(somocon)  # defined in a hidden cell
	xsₛ, ysₛ, zsₛ =  [float.(SC[i]) for i in ("xs", "ys","zs")]
	zzsₛ = reshape(zsₛ, (length(xsₛ), length(ysₛ)))' # reshape to matrix
	surface(xsₛ, ysₛ, zzsₛ)
end

# ╔═╡ d009a822-7ad4-11ec-0032-1bfc51941151
md"""This shows a bit of the topography. If we look at the region from directly above, the graph looks different:
"""

# ╔═╡ d009adae-7ad4-11ec-1c96-95ece3e6ee18
let
	surface(xsₛ, ysₛ, zzsₛ, camera=(0, 90))
end

# ╔═╡ d00aed4a-7ad4-11ec-2e0d-37b5dee8fae7
md"""The rendering uses different colors to indicate height. A more typical graph, that is somewhat similar to the top down view, is a *contour* map.
"""

# ╔═╡ d00aedea-7ad4-11ec-3f5c-e34439205bed
md"""For a scalar function, Define a *level curve* as the solutions to the equations $f(x,y) = c$ for a given $c$. (Or more generally $f(\vec{x}) = c$ for a vector if dimension $2$ or more.) Plotting a selection of level curves yields a *contour* graph. These are produced with `contour` and called as above. For example, we have:
"""

# ╔═╡ d00af1d2-7ad4-11ec-0c74-79cfce44e5bc
let
	contour(xsₛ, ysₛ, zzsₛ)
end

# ╔═╡ d00af1f0-7ad4-11ec-23bb-c3fed870d80d
md"""Were one to walk along one of the contour lines, then there would be no change in elevation. The areas of greatest change in elevation - basically the hills - occur where the different contour lines are closest. In this particular area, there is a river that runs from the upper right through to the lower left and this is flanked by hills.
"""

# ╔═╡ d00af218-7ad4-11ec-336c-eb9a5b82f7d6
md"""The $c$ values for the levels drawn may be specified through the `levels` argument:
"""

# ╔═╡ d00af9b6-7ad4-11ec-149c-3bdd2e190f14
let
	contour(xsₛ, ysₛ, zzsₛ, levels=[50,75,100, 125, 150, 175])
end

# ╔═╡ d00af9fc-7ad4-11ec-11a6-77a4b62126c3
md"""That shows the 50m, 75m, ... contours.
"""

# ╔═╡ d00afa42-7ad4-11ec-1046-97d2bef4c935
md"""If a fixed number of evenly spaced levels is desirable, then the `nlevels` argument is available.
"""

# ╔═╡ d00afff6-7ad4-11ec-3088-2bf41907b884
contour(xsₛ, ysₛ, zzsₛ, nlevels = 5)

# ╔═╡ d00b0028-7ad4-11ec-3338-13a80d1521ad
md"""If a function describes the surface, then the function may be passed as the third value:
"""

# ╔═╡ d00b087a-7ad4-11ec-2a66-ebba5b52fd00
let
	f(x, y) = sin(x) - cos(y)
	xs = range(0, 2pi, length=100)
	ys = range(-pi, pi, length = 100)
	contour(xs, ys, f)
end

# ╔═╡ d00b08b6-7ad4-11ec-1907-d194aa19090a
md"""##### Example
"""

# ╔═╡ d00b08e8-7ad4-11ec-19d2-73f717af0148
md"""An informative graphic mixes both a surface plot with a contour plot. The `PyPlot` package can be used to generate one, but such graphs are not readily made within the `Plots` framework. Here is a workaround, where the contours are generated through the `Contours` package. At the beginning of this section several of its methods are imported.
"""

# ╔═╡ d00b091a-7ad4-11ec-3eb1-4d2e1e6823ee
md"""This example shows how to add a contour at a fixed level ($0$ below). As no hidden line algorithm is used to hide the contour line if the surface were to cover it, a transparency is specified through `alpha=0.5`:
"""

# ╔═╡ d00b2dbe-7ad4-11ec-11be-b5f4c1c5dc4f
let
	function surface_contour(xs, ys, f; offset=0)
	  p = surface(xs, ys, f, legend=false, fillalpha=0.5)
	
	  ## we add to the graphic p, then plot
	  zs = [f(x,y) for x in xs, y in ys]  # reverse order for use with Contour package
	  for cl in levels(contours(xs, ys, zs))
	    lvl = level(cl) # the z-value of this contour level
	    for line in lines(cl)
	        _xs, _ys = coordinates(line) # coordinates of this line segment
	        _zs = offset .+ (0 .* _xs)
	        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add curve on x-y plane
	    end
	  end
	  p
	end
	
	xs = ys = range(-pi, stop=pi, length=100)
	f(x,y) = 2 + sin(x) - cos(y)
	
	surface_contour(xs, ys, f)
end

# ╔═╡ d00b2dfc-7ad4-11ec-1ec2-89afbd1afd8d
md"""We can see that at the minimum of the surface, the contour lines are nested closed loops with decreasing area.
"""

# ╔═╡ d00b2e0e-7ad4-11ec-2268-27892408e91b
md"""##### Example
"""

# ╔═╡ d00b2e40-7ad4-11ec-077f-4965ddeb949c
md"""The figure shows a weather map from 1943 with contour lines based on atmospheric pressure. These are also know as *isolines*.
"""

# ╔═╡ d00b3372-7ad4-11ec-3a64-f3e47e8b28b4
let
	imgfile = "figures/daily-map.jpg"
	caption = """
	Image from [weather.gov](https://www.weather.gov/unr/1943-01-22) of a contour map showing atmospheric pressures from January 22, 1943 in Rapid City, South Dakota.
	"""
	ImageFile(:differentiable_vector_calculus, imgfile, caption)
end

# ╔═╡ d00b3390-7ad4-11ec-3344-fdfb82991dad
md"""This day is highlighted as "The most notable temperature fluctuations occurred on January 22, 1943 when temperatures rose and fell almost 50 degrees in a few minutes. This phenomenon was caused when a frontal boundary separating extremely cold Arctic air from warmer Pacific air rolled like an ocean tide along the northern and eastern slopes of the Black Hills."
"""

# ╔═╡ d00b33a4-7ad4-11ec-1a72-57210ce78749
md"""This frontal boundary is marked with triangles and half circles along the thicker black line. The tight spacing of the contour lines above that marked line show a big change in pressure in a short distance.
"""

# ╔═╡ d00b33b8-7ad4-11ec-35eb-e3054d628f7a
md"""##### Example
"""

# ╔═╡ d00b33c2-7ad4-11ec-2599-e1c0a40bd78a
md"""Sea surface temperature varies with latitude and other factors, such as water depth. The following figure shows average temperatures for January 1982 around Australia. The filled contours allow for an easier identification of the ranges represented.
"""

# ╔═╡ d00b3818-7ad4-11ec-3dac-d57f737137a8
let
	imgfile = "figures/australia.png"
	caption = """
	Image from [IRI](https://iridl.ldeo.columbia.edu/maproom/Global/Ocean_Temp/Monthly_Temp.html) shows mean sea surface temperature near Australia in January 1982. IRI has zoomable graphs for this measurement from 1981 to the present. The contour lines are in 2 degree Celsius increments.
	"""
	ImageFile(:differentiable_vector_calculus, imgfile, caption)
end

# ╔═╡ d00b382c-7ad4-11ec-2de1-6b05b5cb1e9a
md"""##### Example
"""

# ╔═╡ d00b385e-7ad4-11ec-1de8-c321b33b0ea7
md"""The filled contour and the heatmap are related figures to a simple contour graph. The heatmap uses a color gradient to indicate the value at $(x,y)$:
"""

# ╔═╡ d00b431c-7ad4-11ec-0bdc-b7595450e350
let
	f(x,y) = exp(-(x^2 + y^2)/5) * sin(x) * cos(y)
	xs= ys = range(-pi, pi, length=100)
	heatmap(xs, ys, f)
end

# ╔═╡ d00b4342-7ad4-11ec-2160-e13f564c7812
md"""The filled contour layers on the contour lines to a heatmap:
"""

# ╔═╡ d00b4c0e-7ad4-11ec-3ebf-e32b1cf41ff6
let
	f(x,y) = exp(-(x^2 + y^2)/5) * sin(x) * cos(y)
	xs= ys = range(-pi, pi, length=100)
	contourf(xs, ys, f)
end

# ╔═╡ d00b4c2c-7ad4-11ec-3218-3d7aa4169c21
md"""This function has a prominent peak and a prominent valley, around the middle of the viewing window. The nested contour lines indicate this, and the color key can be used to identify which is the peak and which the valley.
"""

# ╔═╡ d00b4c5e-7ad4-11ec-1881-4197f6b43f61
md"""## Limits
"""

# ╔═╡ d00b4c90-7ad4-11ec-1a13-39c6c745ef16
md"""The notion of a limit for a univariate function: as $x$ gets close to $c$ then $f(x)$ gets close to $L$, needs some modification:
"""

# ╔═╡ d0127010-7ad4-11ec-3fcd-c3d9d1ac8093
md"""> Let $f: R^n \rightarrow R$ and $C$ be a point in $R^n$. Then $\lim_{P \rightarrow C}f(P) = L$ if for every $\epsilon > 0$ there exists a $\delta > 0$ such that $|f(P) - L| < \epsilon$ whenever $0 < \| P - C \| < \delta$.

"""

# ╔═╡ d012706a-7ad4-11ec-03d8-1d1da568d38d
md"""(If $P=(x1, x2, \dots, x_n)$ we use $f(P) = f(x1, x2, \dots, x_n)$.)
"""

# ╔═╡ d0127100-7ad4-11ec-2213-dbe7d298fa35
md"""This says, informally, for any scale about $L$ there is a "ball" about $C$ for which the images of $f$ always sit in the ball. Formally we define a ball of radius $r$ about a point $C$ to be all points $P$ with distance between $P$ and $C$ less than $r$. A ball is an *open* set. An [open](https://en.wikipedia.org/wiki/Open_set#Euclidean_space) is a set $U$ such that for any $x$ in $U$, there is a radius $r$ such that the ball of radius $r$ about $x$ is *still* within $U$. An open set generalizes an open interval. A *closed* set generalizes a *closed* interval. These are [defined](https://en.wikipedia.org/wiki/Closed_set) by a set that contains its boundary. Boundary points are any points that can be approached in the limit by points within the set.
"""

# ╔═╡ d0127150-7ad4-11ec-0e10-2fb93cd46438
md"""In the univariate case, it can be useful to characterize a limit at $x=c$ existing if *both* the left and right limits exist and the two are equal. Generalizing to getting close in $R^m$ leads to the intuitive idea of a limit existing in terms of any continuous "path" that approaches $C$ in the $x$-$y$ plane has a limit and all are equal. Let $\gamma$ describe the path, and $\lim_{s \rightarrow t}\gamma(s) = C$. Then $f \circ \gamma$ will be a univariate function. If there is a limit, $L$, then this composition will also have the same limit as $s \rightarrow t$. Conversely, if for *every* path this composition has the *same* limit, then $f$ will have a limit.
"""

# ╔═╡ d0127164-7ad4-11ec-16c0-a97a17b977cf
md"""The "two path corollary" is a trick to show a limit does not exist - just find two paths where there is a limit, but they differ, then a limit does not exist in general.
"""

# ╔═╡ d0127196-7ad4-11ec-29b6-49977a12696d
md"""### Continuity of scalar functions
"""

# ╔═╡ d01271be-7ad4-11ec-2553-2b24f873aaa2
md"""Continuity is defined in a familiar manner: $f(P)$ is continuous at $C$ if $\lim_{P \rightarrow C} f(P) = f(C)$, where we interpret $P \rightarrow C$ in the sense of a ball about $C$.
"""

# ╔═╡ d01271d2-7ad4-11ec-0ce6-81996090f49a
md"""As with univariate functions continuity will be preserved under function addition, subtraction, multiplication, and division (provided there is no dividing by $0$). With this, all these functions are continuous everywhere and so have limits everywhere:
"""

# ╔═╡ d01271fc-7ad4-11ec-33b5-2147dd500fe5
md"""```math
f(x,y) = \sin(x + y), \quad
g(x,y,z) = x^2 + y^2 + z^2, \quad
h(w, x,y,z) = \sqrt{w^2 + x^2 + y^2 + z^2}.
```
"""

# ╔═╡ d0127236-7ad4-11ec-1c89-27ecef765cbf
md"""Not all functions will have a limit though. Consider $f(x,y) = 2x^2/(x^2+y^2)$ and $C=(0,0)$. It is not defined at $C$, but may have a limit. Consider the path $x=0$ (the $y$ axis) parameterized by $\vec\gamma(t) = \langle 0, t\rangle$. Along this path $f\circ \vec\gamma(t) = 0/t^2 = 0$ so will have a limit of $0$. If the limit of $f$ exists it must be $0$. But, along  the line $y=0$ (the $x$ axis) parameterized by $\vec{\gamma}(t) = \langle t, 0 \rangle$, the function simplifies to $f\circ\vec\gamma(t)=2$, so would have a limit of $2$. As the limit along different paths is different, this function has no limit in general.
"""

# ╔═╡ d0127254-7ad4-11ec-3f5e-2b3892ff500f
md"""##### Example
"""

# ╔═╡ d0127268-7ad4-11ec-147e-a7b4a9cde70e
md"""If is not enough that a limit exist along many paths to say a limit exists in general. It must be all paths and be equal. An example might be this function:
"""

# ╔═╡ d012727c-7ad4-11ec-24b2-634d9c610fc6
md"""```math
f(x,y) =
\begin{cases}
(x + y)/(x-y) & x \neq y,\\
0 & x = y
\end{cases}
```
"""

# ╔═╡ d012729a-7ad4-11ec-15c5-bd697b403a84
md"""At $\vec{0}$ this will not have a limit. However, along any line $y=mx$ we have a limit. If $m=1$ the function is constantly $0$, and so has the limit. If $m \neq 1$, then we get $f(x, y) = f(x, mx) = (1 + m)/(1-m)$, a constant So for each $m$ there is a different limit. Consequently, the scalar function does not have a limit.
"""

# ╔═╡ d01272c0-7ad4-11ec-3708-215fe1eff3cd
md"""## Partial derivatives and the gradient
"""

# ╔═╡ d01272e0-7ad4-11ec-0c6f-135b42c15afa
md"""Discussing the behaviour of a scalar function along a path is described mathematically through composition. If $\vec\gamma(t)$ is a path in $R^n$, then the composition $f \circ \vec\gamma$ will be a univariate function. When $n=2$, we can visualize this composition directly, or as a 3D path on the surface given by $\vec{r}(t) = \langle \gamma_1(t), \gamma_2(t), \dots, \gamma_n(t), (f \circ \vec\gamma)(t) \rangle$.
"""

# ╔═╡ d0127e02-7ad4-11ec-0e61-5757c8c1531b
begin
	f₁(x,y) = 2 - x^2 - 3y^2
	f₁(x) = f₁(x...)
	γ₁(t) = 2 * [t, -t^2]   # use \gamma[tab]
	x₁s = y₁s = range(-1, 1, length=100)
	surface(x₁s, y₁s, f₁)
	r3₁(t) = [γ₁(t)..., f₁(γ₁(t))]  # to plot the path on the surface
	plot_parametric!(0..1/2, r3₁, linewidth=5, color=:black)
	
	r2₁(t) = [γ₁(t)..., 0]
	plot_parametric!(0..1/2, r2₁, linewidth=5, color=:black) # in the $x$-$y$ plane
end

# ╔═╡ d0127e48-7ad4-11ec-0a20-f96255b20c4d
md"""The vector valued function `r3(t) = [γ(t)..., f(γ(t))]` takes the 2-dimensional path specified by $\vec\gamma(t)$ and adds a third, $x$, direction by composing the position with `f`. In this way, a 2D path is visualized with a 3D path. This viewpoint can be reversed, as desired.
"""

# ╔═╡ d0127e5c-7ad4-11ec-3325-8d97e0554290
md"""However, the composition,  $f\circ\vec\gamma$, is a univariate function, so this can also be visualized by
"""

# ╔═╡ d01284d8-7ad4-11ec-05ad-dffee3115b72
plot(f₁ ∘ γ₁, 0, 1/2)

# ╔═╡ d01284f6-7ad4-11ec-091a-5dad7aeda9cc
md"""With this graph, we might be led to ask about derivatives or rates of change. For this example, we can algebraically compute the composition:
"""

# ╔═╡ d0128516-7ad4-11ec-2643-dbbcf602b536
md"""```math
(f \circ \vec\gamma)(t) = 2 - (2t) - 3(-2t^2)^2 = 2 - 2t +12t^4
```
"""

# ╔═╡ d012853c-7ad4-11ec-2b71-0bfbbcf18250
md"""From here we clearly have $f'(t) = -2 + 48t^3$. But could this be computed in terms of a "derivative" of $f$ and the derivative of $\vec\gamma$?
"""

# ╔═╡ d0128564-7ad4-11ec-2bc1-310380cb3358
md"""Before answering this, we discuss *directional* derivatives along the simplified paths $\vec\gamma_x(t) = \langle t, c\rangle$ or $\vec\gamma_y(t) = \langle c, t\rangle$.
"""

# ╔═╡ d0128582-7ad4-11ec-0fe3-2f808e19b148
md"""If we compose $f \circ \vec\gamma_x$, we can visualize this as a curve on the surface from $f$ that moves in the $x$-$y$ plane along the line $y=c$. The derivative of this curve will satisfy:
"""

# ╔═╡ d0128596-7ad4-11ec-1674-631a6499a84b
md"""```math
\begin{align}
(f \circ \vec\gamma_x)'(x) &=
\lim_{t \rightarrow x} \frac{(f\circ\vec\gamma_x)(t) - (f\circ\vec\gamma_x)(x)}{t-x}\\
&= \lim_{t\rightarrow x} \frac{f(t, c) - f(x,c)}{t-x}\\
&= \lim_{h \rightarrow 0} \frac{f(x+h, c) - f(x, c)}{h}.
\end{align}
```
"""

# ╔═╡ d01285b4-7ad4-11ec-041d-4b42831ccbd6
md"""The latter expresses this to be the derivative of the function that holds the $y$ value fixed, but lets the $x$ value vary. It is the rate of change in the $x$ direction. There is special notation for this:
"""

# ╔═╡ d01285c8-7ad4-11ec-2415-a53531a904b7
md"""```math
\begin{align}
\frac{\partial f(x,y)}{\partial x} &=
\lim_{h \rightarrow 0} \frac{f(x+h, y) - f(x, y)}{h},\quad\text{and analogously}\\
\frac{\partial f(x,y)}{\partial y} &=
\lim_{h \rightarrow 0} \frac{f(x, y+h) - f(x, y)}{h}.
\end{align}
```
"""

# ╔═╡ d01285e6-7ad4-11ec-382c-3599d6db6e1f
md"""These are called the *partial* derivatives of $f$. The symbol $\partial$, read as "partial", is reminiscent of "$d$", but indicates the derivative is only in a given direction. Other notations exist for this:
"""

# ╔═╡ d01285f0-7ad4-11ec-3144-9daefd1e2479
md"""```math
\frac{\partial f}{\partial x}, \quad f_x, \quad \partial_x f,
```
"""

# ╔═╡ d0128604-7ad4-11ec-3656-59c3b7036638
md"""and more generally, when $n$ may be 2 or more,
"""

# ╔═╡ d012860e-7ad4-11ec-28b4-4fc172cce58c
md"""```math
\frac{\partial f}{\partial x_i}, \quad f_{x_i}, \quad f_i, \quad \partial_{x_i} f, \quad \partial_i f.
```
"""

# ╔═╡ d0128622-7ad4-11ec-1858-095d51fa5d1a
md"""The *gradient* of a scalar function $f$ is the vector comprised of the partial derivatives:
"""

# ╔═╡ d0128636-7ad4-11ec-385b-adf05a1e4749
md"""```math
\nabla f(x_1, x_2, \dots, x_n) = \langle
\frac{\partial f}{\partial x_1},
\frac{\partial f}{\partial x_2}, \dots,
\frac{\partial f}{\partial x_n} \rangle.
```
"""

# ╔═╡ d012864a-7ad4-11ec-2233-a50217c8b2be
md"""As seen, the gradient is a vector-valued function, but has, also, multivariable inputs. It is a function from $R^n \rightarrow R^n$.
"""

# ╔═╡ d012865e-7ad4-11ec-0a87-b561519061f0
md"""##### Example
"""

# ╔═╡ d0128668-7ad4-11ec-1c7a-65aef0b7a862
md"""Let $f(x,y) = x^2 - 2xy$, then to compute the partials, we just treat the other variables like a constant. (This is consistent with the view that the partial derivative is just a regular derivative along a line where all other variables are constant.)
"""

# ╔═╡ d012867e-7ad4-11ec-18fc-43000c60bc48
md"""Then
"""

# ╔═╡ d0128686-7ad4-11ec-2fe1-6f1c6de01248
md"""```math
\begin{align}
\frac{\partial (x^2 - 2xy)}{\partial x} &= 2x - 2y\\
\frac{\partial (x^2 - 2xy)}{\partial y} &= 0 - 2x = -2x.
\end{align}
```
"""

# ╔═╡ d012869a-7ad4-11ec-23f0-f533d0737672
md"""Combining, gives $\nabla{f} = \langle 2x -2y, -2x \rangle$.
"""

# ╔═╡ d01286a4-7ad4-11ec-3bbf-b554dbc4564a
md"""If $g(x,y,z) = \sin(x) + z\cos(y)$, then
"""

# ╔═╡ d01286b0-7ad4-11ec-3dfa-bb829d94d2e2
md"""```math
\begin{align}
\frac{\partial g }{\partial x} &= \cos(x) + 0 = \cos(x),\\
\frac{\partial g }{\partial y} &= 0 + z(-\sin(y)) = -z\sin(y),\\
\frac{\partial g }{\partial z} &= 0 + \cos(y) = \cos(y).
\end{align}
```
"""

# ╔═╡ d01286c2-7ad4-11ec-2fa4-615001292373
md"""Combining, gives $\nabla{g} = \langle \cos(x), -z\sin(y), \cos(y) \rangle$.
"""

# ╔═╡ d01286de-7ad4-11ec-140d-81c17b62bfde
md"""### Finding partial derivatives in Julia
"""

# ╔═╡ d01286fe-7ad4-11ec-24f0-654d58399974
md"""Two different methods are described, one for working with functions, the other symbolic expressions. This mirrors our treatment for vector-valued functions, where `ForwardDiff.derivative` was used for functions, and `SymPy`'s `diff` function for symbolic expressions.
"""

# ╔═╡ d0128710-7ad4-11ec-3997-d379eef6e22c
md"""Suppose, we consider $f(x,y) = x^2 - 2xy$. We may define it with `Julia` through:
"""

# ╔═╡ d0128d7a-7ad4-11ec-28a6-c19a170d11d3
begin
	f₂(x,y) = x^2 - 2x*y
	f₂(v) = f₂(v...)       # to handle vectors. Need not be defined each time
end

# ╔═╡ d0128da2-7ad4-11ec-195f-c5907021133b
md"""The numeric gradient at a point, can be found from the function `ForwardDiff.gradient` through:
"""

# ╔═╡ d012934c-7ad4-11ec-2397-ef9421aebe8b
begin
	pt₂ = [1, 2]
	ForwardDiff.gradient(f₂, pt₂)      # uses the f(v) call above
end

# ╔═╡ d0129392-7ad4-11ec-30db-33dd64d91c05
md"""This, of course matches the computation above, where $\nabla f = \langle (2x -2y, -2x)$, so at $(1,2)$ is $(-2, 2)$, as a point in $R^2$.
"""

# ╔═╡ d01293b0-7ad4-11ec-089b-5f7bc0628ff2
md"""The `ForwardDiff.gradient` function expects a function that accepts a vector of values, so the method for `f(v)` is needed for the computation.
"""

# ╔═╡ d01293ce-7ad4-11ec-070e-e3a62662b410
md"""To go from a function that takes a point to a function of that point, we have the following definition. This takes advantage of `Julia`'s multiple dispatch to add a new method for the `gradient` generic. This is done in the `CalculusWithJulia` package along the lines of:
"""

# ╔═╡ d0129400-7ad4-11ec-2858-7167e32ee5f2
md"""```
FowardDiff.gradient(f::Function) = x -> ForwardDiff.gradient(f, x)
```"""

# ╔═╡ d012940a-7ad4-11ec-0c24-d7693ecd41a0
md"""It works as follows, where a vector of values is passed in for the point in question:
"""

# ╔═╡ d0129932-7ad4-11ec-0e53-09ce45752c95
gradient(f₂)([1,2]), gradient(f₂)([3,4])

# ╔═╡ d0129950-7ad4-11ec-2218-1b9022410d62
md"""This expects a point or vector for its argument, and not the expanded values. Were that desired, something like this would work:
"""

# ╔═╡ d0129978-7ad4-11ec-2acf-9bcb681e0d70
md"""```
ForwardDiff.gradient(f::Function) = (x, xs...) -> ForwardDiff.gradient(f, vcat(x, xs...))
```"""

# ╔═╡ d0129dba-7ad4-11ec-205b-3db3d6581e03
gradient(f₂)([1,2]), gradient(f₂)(3,4)

# ╔═╡ d0129dd8-7ad4-11ec-2a77-69cd301dd635
md"""From the gradient, finding the partial derivatives involves extraction of the corresponding component.
"""

# ╔═╡ d0129df6-7ad4-11ec-15f0-25df39675a32
md"""For example, were it desirable, this function could be used to find the partial in $x$ for some constant $y$:
"""

# ╔═╡ d012a364-7ad4-11ec-3248-35742771833b
partial_x(f, y) = x -> ForwardDiff.gradient(f,[x,y])[1]   # first component of gradient

# ╔═╡ d012a396-7ad4-11ec-20c6-27d6218a5f7a
md"""Another alternative would be to hold one variable constant, and use the `derivative` function, as in:
"""

# ╔═╡ d012a85a-7ad4-11ec-17ad-43f9f7b72a1f
let
	partial_x(f, y) = x -> ForwardDiff.derivative(u -> f(u,y), x)
end

# ╔═╡ d012c178-7ad4-11ec-1db1-7d764919f97e
note("""
For vector-valued functions, we can overide the syntax `'` using `Base.adjoint`, as `'` is treated as a postfix operator in `Julia` for the `adjoint` operation. The symbol `\\nabla` is also available in `Julia`, but it is not an operator, so can't be used as mathematically written `∇f` (this could be used as a name though). In `CalculusWithJulia` a definition is made so essentially `∇(f) = x -> ForwardDiff.gradient(f, x)`. It does require parentheses to be called, as in `∇(f)`.
""")

# ╔═╡ d015a50a-7ad4-11ec-06b7-3785f50e80ad
md"""#### Symbolic expressions
"""

# ╔═╡ d015a594-7ad4-11ec-3952-83f08d757d56
md"""The partial derivatives are more directly found with `SymPy`. As with univariate functions, the `diff` function is used by simply passing in the variable in which to find the partial derivative:
"""

# ╔═╡ d015ad48-7ad4-11ec-0f61-5719ea43732f
begin
	@syms x y
	ex = x^2 - 2x*y
	diff(ex, x)
end

# ╔═╡ d015ad6e-7ad4-11ec-1a49-bd334de85b2e
md"""And evaluation:
"""

# ╔═╡ d015b340-7ad4-11ec-3698-333a6f5f3bc3
diff(ex,x)(x=>1, y=>2)

# ╔═╡ d015b356-7ad4-11ec-0241-9bc233c4e8c3
md"""Or
"""

# ╔═╡ d015b778-7ad4-11ec-1ae2-79e09bba4281
diff(ex, y)(x=>1, y=>2)

# ╔═╡ d015b78e-7ad4-11ec-0da5-750110be3351
md"""The gradient would be found by combining the two:
"""

# ╔═╡ d015ba5e-7ad4-11ec-0969-493f15ec0e05
[diff(ex, x), diff(ex, y)]

# ╔═╡ d015ba72-7ad4-11ec-346a-f3bd22c1671c
md"""This can be simplified through broadcasting:
"""

# ╔═╡ d015bd06-7ad4-11ec-13c0-272cb6df2c49
grad_ex = diff.(ex, [x,y])

# ╔═╡ d015bd24-7ad4-11ec-3cf7-3d98b122f2df
md"""To evaluate at a point we have:
"""

# ╔═╡ d015c1b6-7ad4-11ec-18c1-3de2d70a1817
subs.(grad_ex, x=>1, y=>2)

# ╔═╡ d015c1f0-7ad4-11ec-20b3-837281669859
md"""The above relies on broadcasting treating the pair as a single value so the substitution is repeated for each entry of `grad_ex`.
"""

# ╔═╡ d015c21a-7ad4-11ec-3d07-07faaf57dec1
md"""The `gradient` function from `CalculusWithJulia` is defined to find the symbolic gradient. It uses `free_symbols` to specify the number and order of the variables, but that may be wrong; they are specified below:
"""

# ╔═╡ d015c44a-7ad4-11ec-21e9-d5b385671bf9
gradient(ex, [x, y])   # [∂f/∂x, ∂f/∂y]

# ╔═╡ d015c468-7ad4-11ec-0652-ffac4858f22b
md"""To use `∇` and specify the variables, a tuple (grouping parentheses) is used:
"""

# ╔═╡ d015c788-7ad4-11ec-2c48-df720a4a6900
∇((ex, [x,y]))

# ╔═╡ d015c7c2-7ad4-11ec-32b8-1fd555fc3df4
md"""---
"""

# ╔═╡ d015c83c-7ad4-11ec-02f9-4f768c5fd4f6
md"""In computer science there are two related concepts [Currying](https://en.wikipedia.org/wiki/Currying) and [Partial application](https://en.wikipedia.org/wiki/Partial_application). For a function $f(x,y)$, say, partial application is the process of fixing one of the variables, producing a new function of fewer variables. For example, fixing $y=c$, the we get a new function (of just $x$ and not $(x,y)$) $g(x) = f(x,c)$. In partial derivatives the partial derivative of $f(x,y)$ with respect to $x$ is the derivative of the function $g$, as defined above.
"""

# ╔═╡ d015c86e-7ad4-11ec-0ecd-29ddf4e0e286
md"""Currying, is related, but technically returns a function, so we think of the curried version of $f$ as a function, $h$, which takes $x$ and returns the function $y \rightarrow f(x,y)$ so that $h(x)(y) = f(x, y)$.
"""

# ╔═╡ d015c882-7ad4-11ec-2817-e94081af7a9a
md"""### Visualizing the gradient
"""

# ╔═╡ d015c8ca-7ad4-11ec-37af-47ac61e7a941
md"""The gradient is not a univariate function, a simple vector-valued function, or a scalar function, but rather a *vector field* (which will  be discussed later). For the case, $f: R^2 \rightarrow R$, the gradient will be a function which takes a point $(x,y)$ and returns a vector , $\langle \partial{f}/\partial{x}(x,y), \partial{f}/\partial{y}(x,y) \rangle$. We can visualize this by plotting a vector at several points on a grid. This task is made easier with a function like the following, which handles the task of vectorizing the values. It is provided within the `CalculusWithJulia` package:
"""

# ╔═╡ d015c8f0-7ad4-11ec-3c17-210bf23f84e7
md"""```
function vectorfieldplot!(V; xlim=(-5,5), ylim=(-5,5), nx=10, ny=10, kwargs...)

    dx, dy = (xlim[2]-xlim[1])/nx, (ylim[2]-ylim[1])/ny
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]

    ps = [[x,y] for x in xs for y in ys]
    vs = V.(ps)
	λ = 0.9 * minimum([u/maximum(getindex.(vs,i)) for (i,u) in enumerate((dx,dy))])

    quiver!(unzip(ps)..., quiver=unzip(λ * vs))

end
```"""

# ╔═╡ d015c904-7ad4-11ec-2b01-91c1dc6ecbe3
md"""Here we show the gradient for the scalar function $f(x,y) = 2 - x^2 - 3y^2$ over the region $[-2, 2]\times[-2,2]$ along with a contour plot:
"""

# ╔═╡ d015cfee-7ad4-11ec-05a7-f126f4fd58ba
let
	f(x,y) = 2 - x^2 - 3y^2
	f(v) = f(v...)
	
	xs = ys = range(-2,2, length=50)
	
	p = contour(xs, ys, f, nlevels=12)
	vectorfieldplot!(p, gradient(f), xlim=(-2,2), ylim=(-2,2), nx=10, ny=10)
	
	p
end

# ╔═╡ d015d02a-7ad4-11ec-2f81-a14132dbb1d2
md"""The figure suggests a potential geometric relationship between the gradient and the contour line to be explored later.
"""

# ╔═╡ d015d052-7ad4-11ec-17b4-e1747ea191b4
md"""## Differentiable
"""

# ╔═╡ d015d07a-7ad4-11ec-0903-899a81e3ac19
md"""We see here how the gradient of $f$, $\nabla{f} = \langle f_{x_1}, f_{x_2}, \dots, f_{x_n} \rangle$, plays a similar role as the derivative does for univariate functions.
"""

# ╔═╡ d015d08e-7ad4-11ec-1081-a395918ddb82
md"""First, we consider the role of the derivative for univariate functions. The main characterization - the derivative is the slope of the line that best approximates the function at a point - is quantified by Taylor's theorem. For a function $f$ with a continuous second derivative:
"""

# ╔═╡ d015d0b6-7ad4-11ec-0a66-45fdb61c12e6
md"""```math
f(c+h) = f(c) = f'(c)h + \frac{1}{2} f''(\xi) h^2,
```
"""

# ╔═╡ d015d0ca-7ad4-11ec-3f3c-a3655b8631dc
md"""for some $\xi$ within $c$ and $c+h$.
"""

# ╔═╡ d015d0d6-7ad4-11ec-2e35-6f327778c387
md"""We re-express this through:
"""

# ╔═╡ d015d0e8-7ad4-11ec-0d7f-a180ef80f938
md"""```math
(f(c+h) - f(c)) - f'(c)h  =\frac{1}{2} f''(\xi) h^2.
```
"""

# ╔═╡ d015d0fc-7ad4-11ec-13ee-0df3593e5717
md"""The right hand side is the *error* term between the function value at $c+h$ and, in this case, the linear approximation at the same value.
"""

# ╔═╡ d015d11a-7ad4-11ec-12e9-1f034932444f
md"""If the assumptions are relaxed, and $f$ is just assumed to be *differentiable* at $x=c$, then only this is known:
"""

# ╔═╡ d015d124-7ad4-11ec-3439-33fb1bc27b5f
md"""```math
(f(c+h) - f(c)) - f'(c)h  = \epsilon(h) h,
```
"""

# ╔═╡ d015d136-7ad4-11ec-182a-6de34e9f4625
md"""where $\epsilon(h) \rightarrow 0$ as $h \rightarrow 0$.
"""

# ╔═╡ d015d142-7ad4-11ec-3159-735a33dcfa35
md"""It is this characterization of differentiable that is generalized to define when a scalar function is *differentiable*.
"""

# ╔═╡ d0176f0c-7ad4-11ec-0c75-258fdd944c3d
md"""> *Differentiable*: Let $f$ be a scalar function. Then $f$ is [differentiable](https://tinyurl.com/qj8qcbb) at a point $C$ **if** the first order partial derivatives exist at $C$ **and** for $\vec{h}$ going to $\vec{0}$:
>
> $\|f(C + \vec{h}) - f(C) - \nabla{f}(C) \cdot \vec{h}\| = \mathcal{o}(\|\vec{h}\|),$
>
> where $\mathcal{o}(\|\vec{h}\|)$ means that dividing the left hand side by $\|\vec{h}\|$ and taking a limit as $\vec{h}\rightarrow 0$ the limit will be $0$..

"""

# ╔═╡ d0176f66-7ad4-11ec-153c-49677246653a
md"""The limits here are for limits of scalar functions, which means along any path going to $\vec{0}$, not just straight line paths, as are used to define the partial derivatives. Hidden above, is an assumption that there is some open set around $C$ for which $f$ is defined for $f(C + \vec{h})$ when $C+\vec{h}$ is in this open set.
"""

# ╔═╡ d0176f8c-7ad4-11ec-1479-59ed6b916abc
md"""The role of the derivative in the univariate case is played by the gradient in the scalar case, where $f'(c)h$ is replaced by $\nabla{f}(C) \cdot \vec{h}$. For the univariate case, differentiable is simply the derivative existing, but saying a scalar function is differentiable at $C$ is a stronger statement than saying it has a gradient or, equivalently, it has partial derivatives at $C$, as this is assumed in the statement along with the other condition.
"""

# ╔═╡ d0176fa2-7ad4-11ec-1b41-694aa42d0c68
md"""Later we will see how Taylor's theorem generalizes for scalar functions and interpret the gradient geometrically, as was done for the derivative (it being the slope of the tangent line).
"""

# ╔═╡ d0176fbe-7ad4-11ec-0d3a-a11578f9b8ef
md"""## The chain rule to evaluate $f\circ\vec\gamma$
"""

# ╔═╡ d0176ff2-7ad4-11ec-0b76-af1ce6194635
md"""In finding a partial derivative, we restricted the surface along a curve in the $x$-$y$ plane, in this case the curve $\vec{\gamma}(t)=\langle t, c\rangle$. In general if we have a curve in the $x$-$y$ plane, $\vec{\gamma}(t)$, we can compose the scalar function $f$ with $\vec{\gamma}$ to create a univariate function. If the functions are "smooth" then this composed function should have a derivative, and some version of a "chain rule" should provide a means to compute the derivative in terms of the "derivative" of $f$ (the gradient) and the derivative of $\vec{\gamma}$ ($\vec{\gamma}'$).
"""

# ╔═╡ d01770c2-7ad4-11ec-0395-f1717b00b98b
md"""> *Chain rule*: Suppose $f$ is *differentiable* at $C$, and $\vec{\gamma}(t)$ is differentiable at $c$ with $\vec{\gamma}(c) = C$. Then $f\circ\vec{\gamma}$ is differentiable at $c$ with derivative $\nabla f(\vec{\gamma}(c)) \cdot \vec{\gamma}'(c)$.

"""

# ╔═╡ d01770e2-7ad4-11ec-3959-d10129cbc26e
md"""This is similar to the chain rule for univariate functions $(f\circ g)'(u) = f'(g(u)) g'(u)$ or $df/dx = df/du \cdot du/dx$. However, when we write out in components there are more terms. For example, for $n=2$ we have with $\vec{\gamma} = \langle x(t), y(t) \rangle$:
"""

# ╔═╡ d01770f4-7ad4-11ec-0061-0b3c28d727bb
md"""```math
\frac{d(f\circ\vec{\gamma})}{dt} =
\frac{\partial f}{\partial x} \frac{dx}{dt} +
\frac{\partial f}{\partial y} \frac{dy}{dt}.
```
"""

# ╔═╡ d017710a-7ad4-11ec-3a67-fdd8dc986b1c
md"""The proof is a consequence of the definition of differentiability and will be shown in more generality later.
"""

# ╔═╡ d0177132-7ad4-11ec-02a0-0df1d376e827
md"""##### Example
"""

# ╔═╡ d017715a-7ad4-11ec-109b-b71cf7b989a3
md"""Consider the function $f(x,y) = 2 - x^2 - y^2$ and the curve $\vec\gamma(t) = t\langle \cos(t), -\sin(t) \rangle$ at $t=\pi/6$. We visualize this below:
"""

# ╔═╡ d0177ae2-7ad4-11ec-00b4-03d396f9080f
begin
	f₃(x,y) = 2 - x^2 - y^2
	f₃(x) = f₃(x...)
	γ₃(t) = t*[cos(t), -sin(t)]
	t0₃ = pi/6
end

# ╔═╡ d01783fc-7ad4-11ec-33e7-1f5cb436f359
let
	xs = ys = range(-3/2, 3/2, length=100)
	surface(xs, ys, f₃, legend=false)
	
	r(t) = [γ₃(t)..., (f₃∘γ₃)(t)]
	plot_parametric!(0..1/2, r, linewidth=5, color=:black)
	
	arrow!(r(t0₃), r'(t0₃), linewidth=5, color=:black)
end

# ╔═╡ d0178438-7ad4-11ec-38d5-1dc082219db0
md"""In three dimensions, the tangent line is seen, but the univariate function $f \circ \vec\gamma$ looks like:
"""

# ╔═╡ d0178a00-7ad4-11ec-3f58-c53bd8fcff4d
let
	plot(f₃ ∘ γ₃, 0, pi/2)
	plot!(t -> (f₃ ∘ γ₃)(t0₃) + (f₃ ∘ γ₃)'(t0₃)*(t - t0₃), 0, pi/2)
end

# ╔═╡ d0178a28-7ad4-11ec-2a03-257ce8f4801b
md"""From the graph, the slope of the tangent line looks to be about $-1$, using the chain rule gives the exact value:
"""

# ╔═╡ d0178e8a-7ad4-11ec-1cf5-9510716e567b
ForwardDiff.gradient(f₃, γ₃(t0₃)) ⋅ γ₃'(t0₃)

# ╔═╡ d0178ea6-7ad4-11ec-1d60-eddb7dc65094
md"""We can compare this to taking the derivative after composition:
"""

# ╔═╡ d017911c-7ad4-11ec-0ded-d15fadcc321a
(f₃ ∘ γ₃)'(t0₃)

# ╔═╡ d017913a-7ad4-11ec-3b4d-352acc9c3365
md"""##### Example
"""

# ╔═╡ d017914e-7ad4-11ec-0b22-3f9861b28ee8
md"""Consider the following plot showing a hiking trail on a surface:
"""

# ╔═╡ d0179ba8-7ad4-11ec-0aff-9fcb4d16660c
begin
	lenape = CSV.File(IOBuffer(lenape_csv)) |> DataFrame
	nothing
end

# ╔═╡ d017a5bc-7ad4-11ec-081c-59831fac475b
let
	xs, ys, zs =  [float.(SC[i]) for i in ("xs", "ys","zs")]
	zzs = reshape(zs, (length(xs), length(ys)))' # reshape to matrix
	surface(xs, ys, zzs, legend=false)
	plot!(lenape.longitude, lenape.latitude, lenape.elevation, linewidth=5, color=:black)
end

# ╔═╡ d017a5ee-7ad4-11ec-1894-f19d03cbec3a
md"""Though here it is hard to see the trail  rendered on the surface, for the hiker, such questions are far from the mind. Rather, questions such as what is the steepest part of the trail may come to mind.
"""

# ╔═╡ d017a634-7ad4-11ec-356e-a3e792965c89
md"""For this question, we can answer it in turns of the sampled data in the `lenape` variable. The steepness being the change in elevation with respect to distance in the $x$-$y$ direction. Treating latitude and longitude coordinates describing motion in a plane (as opposed to a very big sphere), we can compute the maximum steepness:
"""

# ╔═╡ d017acf6-7ad4-11ec-2a01-137da9369170
let
	xs, ys, zs = lenape.longitude, lenape.latitude, lenape.elevation
	dzs = zs[2:end] - zs[1:end-1]
	dxs, dys = xs[2:end] - xs[1:end-1], ys[2:end] - ys[1:end-1]
	deltas = sqrt.(dxs.^2 + dys.^2) * 69 / 1.6 * 1000 # in meters now
	global slopes = abs.(dzs ./ deltas)  # to re-use
	m = maximum(slopes)
	atand(maximum(slopes))   # in degrees due to the `d`
end

# ╔═╡ d017ad32-7ad4-11ec-3742-3346529f2250
md"""This is certainly too steep for a trail, which should be at most $10$ to $15$ degrees or so, not $58$. This is due to the inaccuracy in the measurements. An average might be better:
"""

# ╔═╡ d017b110-7ad4-11ec-3621-17766988d320
begin
	import Statistics: mean
	atand(mean(slopes))
end

# ╔═╡ d017b124-7ad4-11ec-0027-41ddb2cf31dd
md"""Which seems about right for a generally uphill trail section, as this is.
"""

# ╔═╡ d017b14a-7ad4-11ec-30b7-69b80cd54d2c
md"""In the above example, the data is given in terms of a sample, not a functional representation. Suppose instead, the surface was generated by `f` and the path - in the $x$-$y$ plane - by $\gamma$. Then we could estimate the maximum and average steepness by a process like this:
"""

# ╔═╡ d017b7d2-7ad4-11ec-3c1f-bf1f29a224ed
begin
	f₄(x,y) = 2 - x^2 - y^2
	f₄(x) = f₄(x...)
	γ₄(t) = t*[cos(t), -sin(t)]
end

# ╔═╡ d017bfe8-7ad4-11ec-156e-c96d2fb83a99
let
	xs = ys = range(-3/2, 3/2, length=100)
	
	surface(xs, ys, f₄, legend=false)
	r(t) = [γ₄(t)..., (f₄ ∘ γ₄)(t)]
	plot_parametric!(0..1/2, r, linewidth=5, color=:black)
end

# ╔═╡ d017c56c-7ad4-11ec-08f9-e7d560dc5651
begin
	plot(f₄ ∘ γ₄, 0, pi/2)
	slope(t) = abs((f₄ ∘ γ₄)'(t))
	
	1/(pi/2 - 0) * quadgk(t -> atand(slope(t)), 0, pi/2)[1]  # the average
end

# ╔═╡ d017c59e-7ad4-11ec-04ec-ef2fb65613b9
md"""the average is $50$ degrees. As for the maximum slope:
"""

# ╔═╡ d017cb32-7ad4-11ec-04b2-27180b3729f9
let
	cps = find_zeros(slope, 0, pi/2) # critical points
	
	append!(cps, (0, pi/2))  # add end points
	unique!(cps)
	
	M, i = findmax(slope.(cps))  # max, index
	
	cps[i], slope(cps[i])
end

# ╔═╡ d017cb46-7ad4-11ec-21be-e944252952d8
md"""The maximum slope occurs at an endpoint.
"""

# ╔═╡ d017cb82-7ad4-11ec-2470-734bd1822a48
md"""## Directional Derivatives
"""

# ╔═╡ d017cbaa-7ad4-11ec-1bcb-f7e3442bfb00
md"""The last example, how steep is the direction we are walking, is a question that can be asked when walking in a straight line in the $x$-$y$ plane. The answer has a simplified answer:
"""

# ╔═╡ d017cbc8-7ad4-11ec-0b2a-172413d219ac
md"""Let $\vec\gamma(t) = C + t \langle a, b \rangle$ be a line that goes through the point $C$ parallel, or in the direction of, to $\vec{v} = \langle a , b \rangle$.
"""

# ╔═╡ d017cbdc-7ad4-11ec-3ae0-571e326c9ced
md"""Then the function $f \circ \vec\gamma(t)$ will have a derivative when $f$ is differentiable and by the chain rule will be:
"""

# ╔═╡ d017cc04-7ad4-11ec-0dc9-45e2d70b3f47
md"""```math
(f\circ\vec\gamma)'(\vec\gamma(t)) = \nabla{f}(\vec\gamma(t)) \cdot \vec\gamma'(t) =
\nabla{f}(\vec\gamma(t)) \cdot \langle a, b\rangle =
\vec{v} \cdot \nabla{f}(\vec\gamma(t)).
```
"""

# ╔═╡ d017cc18-7ad4-11ec-1fca-e7584e84e694
md"""At $t=0$, we see that $(f\circ\vec\gamma)'(C) = \nabla{f}(C)\cdot \vec{v}$.
"""

# ╔═╡ d017cc4a-7ad4-11ec-1267-3b18720136c1
md"""This defines the *directional derivative* at $C$ in the direction $\vec{v}$:
"""

# ╔═╡ d017cc5e-7ad4-11ec-2153-31bf3ca6da09
md"""```math
\text{Directional derivative} = \nabla_{\vec{v}}(f) =  \nabla{f} \cdot \vec{v}.
```
"""

# ╔═╡ d017cc86-7ad4-11ec-2faf-2705f52f599b
md"""If $\vec{v}$ is a *unit* vector, then the value of the directional derivative is the rate of increase in $f$ in the direction of $\vec{v}$.
"""

# ╔═╡ d017cca2-7ad4-11ec-197f-f342b6b5473c
md"""This is a *natural* generalization of the partial derivatives, which, in two dimensions, are the directional derivative in the $x$ direction and the directional derivative in the $y$ direction.
"""

# ╔═╡ d017ccb8-7ad4-11ec-1fa9-59a9762fac47
md"""The following figure shows $C = (1/2, -1/2)$ and the two curves. Planes are added, as it can be easiest to visualize these curves as the intersection of the surface generated by $f$ and the vertical planes $x=C_x$ and $y=C_y$
"""

# ╔═╡ d017d2ee-7ad4-11ec-0c63-897932a2162c
let
	f(x,y) = 2 - x^2 - y^2
	
	xs = ys = range(-3/2, 3/2, length=100)
	surface(xs, ys, f, legend=false)
	M=f(3/2,3/2)
	
	x0,y0 = 1/2, -1/2
	plot!([-3/2, 3/2, 3/2, -3/2, -3/2], y0 .+ [0,0,0,0, 0], [M,M,2,2,M], linestyle=:dash)
	r(x) = [x, y0, f(x,y0)]
	plot_parametric!(-3/2..3/2, r, linewidth=5, color=:black)
	
	
	plot!(x0 .+ [0,0,0,0, 0], [-3/2, 3/2, 3/2, -3/2, -3/2], [M,M,2,2,M], linestyle=:dash)
	r(y) = [x0, y, f(x0, y)]
	plot_parametric!(-3/2..3/2, r, linewidth=5, color=:black)
	
	
	scatter!([x0],[y0],[M])
	arrow!([x0,y0,M], [1,0,0], linewidth=3)
	arrow!([x0,y0,M], [0, 1,0], linewidth=3)
end

# ╔═╡ d017d320-7ad4-11ec-06c8-83289855df83
md"""We can then visualize the directional derivative by a plane through $C$ in the direction $\vec{v}$. Here we take $C=(1/2, -1/2)$, as before, and $\vec{v} = \langle 1, 1\rangle$:
"""

# ╔═╡ d017d918-7ad4-11ec-39f9-31323f482180
let
	f(x,y) = 2 - x^2 - y^2
	f(x) = f(x...)
	xs = ys = range(-3/2, 3/2, length=100)
	p = surface(xs, ys, f, legend=false)
	M=f(3/2,3/2)
	
	x0,y0 = 1/2, -1/2
	vx, vy = 1, 1
	l1(t) = [x0, y0] .+ t*[vx, vy]
	llx, lly = l1(-1)
	rrx, rry = l1(1)
	plot!([llx, rrx, rrx, llx, llx], [lly, rry, rry, lly, lly], [M,M, 2, 2, M], linestyle=:dash)
	
	r(t) = [l1(t)..., f(l1(t))]
	plot_parametric!(-1..1, r, linewidth=5, color=:black)
	arrow!(r(0), r'(0), linewidth=5, color=:black)
	
	
	scatter!([x0],[y0],[M])
	arrow!([x0,y0,M], [vx, vy,0], linewidth=3)
end

# ╔═╡ d017d94a-7ad4-11ec-2333-e51d63a38462
md"""In this figure, we see that the directional derivative appears to be $0$, unlike the partial derivatives in $x$ and $y$, which are negative and positive, respectively.
"""

# ╔═╡ d017d96a-7ad4-11ec-1af2-01a914edd576
md"""##### Example
"""

# ╔═╡ d017d97e-7ad4-11ec-29c9-5db69983ffaf
md"""Let $f(x,y) = \sin(x+2y)$ and $\vec{v} = \langle 2, 1\rangle$. The directional derivative of $f$ in the direction of $\vec{v}$ at $(x,y)$ is:
"""

# ╔═╡ d017d992-7ad4-11ec-18ed-e9844b491ec2
md"""```math
\nabla{f}\cdot \frac{\vec{v}}{\|\vec{v}\|} = \langle \cos(x + 2y), 2\cos(x + 2y)\rangle \cdot \frac{\langle 2, 1 \rangle}{\sqrt{5}} = \frac{4}{\sqrt{5}} \cos(x + 2y).
```
"""

# ╔═╡ d017d9a6-7ad4-11ec-3523-6fed18c5b55e
md"""##### Example
"""

# ╔═╡ d017d9c4-7ad4-11ec-3b30-15aeb9469c22
md"""Suppose $f(x,y)$ describes a surface, and $\vec\gamma(t)$ parameterizes a path in the $x$-$y$ plane. Then the vector valued function $\vec{r}(t) = \langle \vec\gamma_1(t), \vec\gamma_2(t), (f\circ\vec\gamma)(t)\rangle$ describes a path on the surface. The maximum steepness of the this path is found by maximizing the slope of the directional derivative in the direction of the tangent line. This would be the function of $t$:
"""

# ╔═╡ d017d9d8-7ad4-11ec-2d9d-61290dbab802
md"""```math
\nabla{f}(\vec\gamma(t)) \cdot \vec{T}(t),
```
"""

# ╔═╡ d017d9e2-7ad4-11ec-0672-9570c06a50db
md"""Where $T(t) = \vec\gamma'(t)/\|\vec\gamma'(t)\|$ is the unit tangent vector to $\gamma$.
"""

# ╔═╡ d017d9f6-7ad4-11ec-1542-7759ba7a5e88
md"""Let $f(x,y) = 2 - x^2 - y^2$ and $\vec\gamma(t) = (\pi-t) \langle \cos(t), \sin(t) \rangle$. What is the maximum steepness?
"""

# ╔═╡ d017da14-7ad4-11ec-3e18-015816b5168a
md"""We have $\nabla{f} = \langle -2x, -2y \rangle$ and $\vec\gamma'(t) = -\langle(\cos(t), \sin(t)) + (\pi-t) \langle(-\sin(t), \cos(t)\rangle$. We maximize this over $[0, \pi]$:
"""

# ╔═╡ d017e11c-7ad4-11ec-2239-41a656578e95
let
	f(x,y) = 2 - x^2 - y^2
	f(v) = f(v...)
	gamma(t) = (pi-t) * [cos(t), sin(t)]
	dd(t) = gradient(f)(gamma(t)) ⋅ gamma'(t)
	
	cps = find_zeros(dd, 0, pi)
	unique!(append!(cps, (0, pi)))  # add endpoints
	M,i = findmax(dd.(cps))
	M
end

# ╔═╡ d017e14e-7ad4-11ec-1c68-058d02d6f4bf
md"""##### Example: The gradient indicates the direction of steepest ascent
"""

# ╔═╡ d017e162-7ad4-11ec-2ff7-7bc46f4b2888
md"""Consider this figure showing a surface and a level curve along with a contour line:
"""

# ╔═╡ d017ea90-7ad4-11ec-0534-3ba7c21c2f32
let
	f(x,y) = sqrt(x^2 + y^2)
	f(v) = f(v...)
	
	xs = ys = range(-2, 2, length=100)
	p = surface(xs, ys, f, legend=false)
	
	γ(t) = [cos(t), sin(t), f(cos(t), sin(t))]
	plot_parametric!(0..2pi, γ, linewidth=5)
	
	t =7pi/4;
	scatter!(p, unzip([γ(t)])...)
	
	
	rad(t) = 1 * [cos(t), sin(t)]
	γ(t) = [rad(t)..., 0]
	plot_parametric!(0..2pi, γ, linestyle=:dash)
	
	
	
	arrow!(γ(t), γ'(t))
	arrow!(γ(t), [ForwardDiff.gradient(f, rad(t))..., 0])
end

# ╔═╡ d017eaf4-7ad4-11ec-14eb-f557da3ca002
md"""We have the level curve for $f(x,y) = c$ represented, and a point $(x,y, f(x,y))$ drawn. At the point $(x,y)$ which sits on the level curve, we have indicated the gradient and the tangent curve to the level curve, or contour line. Worth reiterating, the gradient is not on the surface, but rather is a $2$-dimensional vector, but it does indicate a direction that can be taken on the surface. We will see that this direction indicates the path of steepest ascent.
"""

# ╔═╡ d017eb44-7ad4-11ec-09f7-f93fdc9df471
md"""The figure suggests a relationship between the gradient and the tangents to the contour lines. Let's parameterize the contour line by $\vec\gamma(t)$, assuming such a parameterization exists, let $C = (x,y) = \vec\gamma(t)$, for some $t$, be a point on the level curve, and $\vec{T} = \vec\gamma'(t)/\|\vec\gamma'(t)\|$ be the tangent to to the level curve at $C$. Then the directional derivative at $C$ in the direction of $T$ must be $0$, as along the level curve, the function $f\circ \vec\gamma = c$, a constant. But by the chain rule, this says:
"""

# ╔═╡ d017eb62-7ad4-11ec-1a39-1bcb6ebf4986
md"""```math
0 = (c)' = (f\circ\vec\gamma)'(t) = \nabla{f}(\vec\gamma(t)) \cdot \vec\gamma'(t)
```
"""

# ╔═╡ d017eba0-7ad4-11ec-2f67-8dc0f06ceed0
md"""That is the gradient is *orthogonal* to $\vec{\gamma}'(t)$. As well, is orthogonal to the tangent vector $\vec{T}$ and hence to the level curve at any point. (As the dot product is $0$.)
"""

# ╔═╡ d017ebd2-7ad4-11ec-128c-51796f65f160
md"""Now, consider a unit vector $\vec{v}$ in the direction of steepest ascent at $C$. Since $\nabla{f}(C)$ and $\vec{T}$ are orthogonal, we can express the unit vector uniquely as $a\nabla{f}(C) + b \vec{T}$ with $a^2 + b^2 = 1$. The directional derivative is then
"""

# ╔═╡ d017ebee-7ad4-11ec-27f3-1387a4a38deb
md"""```math
\nabla{f} \cdot \vec{v} = \nabla{f}  \cdot (a\nabla{f}(C) + b \vec{T}) = a \| \nabla{f} \|^2  + b \nabla{f} \cdot \vec{T} = a \| \nabla{f} \|^2.
```
"""

# ╔═╡ d017ec20-7ad4-11ec-3d84-076ee84281f8
md"""The will be largest when $a=1$ and $b=0$. That is, the direction of greatest ascent in indicated by the gradient. (It is smallest when $a=-1$ and $b=0$, the direction opposite the gradient.
"""

# ╔═╡ d017ec32-7ad4-11ec-3ebd-8b0d0b453d46
md"""In practical terms, if standing on a hill, walking in the direction of the gradient will go uphill the fastest possible way, walking along a contour will not gain any elevation. The two directions are orthogonal.
"""

# ╔═╡ d017ec52-7ad4-11ec-2656-d74879c8c540
md"""## Other types of compositions and the chain rule
"""

# ╔═╡ d017ec84-7ad4-11ec-3cf0-533ce369da57
md"""The chain rule we discussed was for a composition of $f:R^n \rightarrow R$ with $\vec\gamma:R \rightarrow R^n$ resulting in a function $f\circ\vec\gamma:R \rightarrow R$. There are other possible compositions.
"""

# ╔═╡ d017ecc0-7ad4-11ec-0df9-f78bae93ef71
md"""For example, suppose we have an economic model for beverage consumption based on temperature given by $c(T)$. But temperature depends on geographic location, so may be modeled through a function $T(x,y)$. The composition $c \circ T$ would be a function from $R^2 \rightarrow R$, so should have partial derivatives with respect to $x$ and $y$ which should be expressible in terms of the derivative of $c$ and the partial derivatives of $T$.
"""

# ╔═╡ d017ed10-7ad4-11ec-3f21-8f178f4a1f9e
md"""Consider a different situation, say we have $f(x,y)$ a scalar function, but want to consider the position in polar coordinates involving $r$ and $\theta$. We can think directly of $F(r,\theta) = f(r\cdot\cos(\theta), r\cdot\sin(\theta))$, but more generally, we have a function $G(r, \theta)$ that is vector valued: $G(r,\theta) = \langle r\cdot\cos(\theta), r\cdot\sin(\theta) \rangle$ ($G:R^2 \rightarrow R^2$). The composition $F=f\circ G$ is a scalar function of $r$ and $\theta$ and the partial derivatives with respect to these should be expressible in terms of the partial derivatives of $f$ and the partial derivatives of $G$.
"""

# ╔═╡ d017ed24-7ad4-11ec-21a9-fbf48151d18e
md"""Finding the derivative of a composition in terms of the individual pieces involves some form of the chain rule, which will differ depending on the exact circumstances.
"""

# ╔═╡ d017ed60-7ad4-11ec-3de9-39130c15f6f6
md"""### Chain rule for a univariate function composed with a scalar function
"""

# ╔═╡ d017eda6-7ad4-11ec-1524-890e09b045a9
md"""If $f(t)$ is a univariate function and $G(x,y)$ a scalar function, the $F(x,y) = f(G(x,y))$ will be a scalar function and may have partial derivatives. If $f$ and $G$ are differentiable at a point $P$, then
"""

# ╔═╡ d017edc4-7ad4-11ec-3f8e-fb7e36d2aeff
md"""```math
\frac{\partial F}{\partial x} = f'(G(x,y)) \frac{\partial G}{\partial x}, \quad
\frac{\partial F}{\partial y} = f'(G(x,y)) \frac{\partial G}{\partial y},
```
"""

# ╔═╡ d017edd8-7ad4-11ec-214f-b1eb5335a1af
md"""and
"""

# ╔═╡ d017edec-7ad4-11ec-258b-c73dd7e778fb
md"""```math
\nabla{F} = \nabla{f \circ G} = f'(G(x,y)) \nabla{G}(x,y).
```
"""

# ╔═╡ d017ee00-7ad4-11ec-1e80-79a94c690c8e
md"""The result is an immediate application of the univariate chain rule, when the partial functions are considered.
"""

# ╔═╡ d017ee28-7ad4-11ec-3988-434eca77fc08
md"""##### Example
"""

# ╔═╡ d017ee70-7ad4-11ec-1375-6100a9395813
md"""Imagine a scenario where sales of some commodity (say ice) depend on the temperature which in turn depends on location. Formally, we might have functions $S(T)$ and $T(x,y)$ and then sales would be the composition $S(T(x,y))$. How might sales go up or down if one moved west, or one moved in the northwest direction? These would be a *directional* derivative, answered by $\nabla{S}\cdot \hat{v}$, where $\vec{v}$ is the direction. Of importance would be to compute $\nabla{S}$ which might best be done through the chain rule.
"""

# ╔═╡ d017eec8-7ad4-11ec-105f-a5aa4d74436c
md"""For example, if $S(T) = \exp((T - 70)/10)$ and $T(x,y) = (1-x^2)\cdot y$, the gradient of $S(T(x,y))$ would be given by:
"""

# ╔═╡ d017eedc-7ad4-11ec-235d-5581640ace0b
md"""```math
S'(T(x,y)) \nabla{T}(x,y) = (S(T(x,y))/10) \langle(-2xy, 1-x^2 \rangle.
```
"""

# ╔═╡ d017ef02-7ad4-11ec-19c7-b3ab8f45575e
md"""### Chain rule for a scalar function, $f$, composed with a function $G: R^m \rightarrow R^n$.
"""

# ╔═╡ d017ef54-7ad4-11ec-019b-7d4db4bafd16
md"""If $G(u_1, \dots, u_m) = \langle G_1, G_2,\dots, G_n\rangle$ is a function of $m$ inputs that returns $n$ outputs we may view it as $G: R^m \rightarrow R^n$. The composition with a scalar function $f(v_1, v_2, \dots, v_n)=z$ from $R^n \rightarrow R$ creates a scalar function from $R^m \rightarrow R$, so the question of partial derivatives is of interest. We have:
"""

# ╔═╡ d017ef72-7ad4-11ec-2eeb-5389bb88402e
md"""```math
\frac{\partial (f \circ G)}{\partial u_i} =
\frac{\partial f}{\partial v_1} \frac{\partial G}{\partial u_i} +
\frac{\partial f}{\partial v_2} \frac{\partial G}{\partial u_i} + \dots +
\frac{\partial f}{\partial v_n} \frac{\partial G}{\partial u_i}.
```
"""

# ╔═╡ d017ef86-7ad4-11ec-20cb-1dc31f1ebc4b
md"""The gradient is then:
"""

# ╔═╡ d017efa6-7ad4-11ec-038f-937c3801f318
md"""```math
\nabla(f\circ G) =
\frac{\partial f}{\partial v_1} \nabla{G_1} +
\frac{\partial f}{\partial v_2} \nabla{G_2} + \dots +
\frac{\partial f}{\partial v_n} \nabla{G_n} = \nabla(f) \cdot \langle \nabla{G_1}, \nabla{G_2}, \dots, \nabla{G_n} \rangle,
```
"""

# ╔═╡ d017f012-7ad4-11ec-3b80-077f21672247
md"""The last expression is a suggestion, as it is an abuse of previously used notation: the dot product isn't between vectors of the same type, as the rightmost vector is representing a vector of vectors. The [Jacobian](https://en.wikipedia.org/wiki/Jacobian_matrix_and_determinant) matrix combines these vectors into a rectangular array, though with the vectors written as *row* vectors. If $G: R^m \rightarrow R^n$, then the Jacobian is the $n \times m$ matrix with $(i,j)$ entry given by $\partial G_i, \partial u_j$:
"""

# ╔═╡ d017f030-7ad4-11ec-1a4f-2dd56db4d0cc
md"""```math
J = \left[
\begin{align}
\frac{\partial G_1}{\partial u_1} & \frac{\partial G_1}{\partial u_2} & \dots \frac{\partial G_1}{\partial u_m}\\
\frac{\partial G_2}{\partial u_1} & \frac{\partial G_2}{\partial u_2} & \dots \frac{\partial G_2}{\partial u_m}\\
& \vdots & \\
\frac{\partial G_n}{\partial u_1} & \frac{\partial G_n}{\partial u_2} & \dots \frac{\partial G_n}{\partial u_m}
\end{align}
\right].
```
"""

# ╔═╡ d017f04e-7ad4-11ec-2a33-f9e2829d6290
md"""With this notation, and matrix multiplication we have $(\nabla(f\circ G))^t = \nabla(f)^t J$.
"""

# ╔═╡ d017f062-7ad4-11ec-2907-2db4ac21f2fe
md"""(Later, we will see that the chain rule in general has a familiar form using matrices, not vectors, which will avoid the need for a transpose.)
"""

# ╔═╡ d017f076-7ad4-11ec-3939-efac5922d1ca
md"""##### Example
"""

# ╔═╡ d017f0b2-7ad4-11ec-0edd-cd44c4a2914f
md"""Let $f(x,y) = x^2 + y^2$ be a scalar function. We have if $G(r, \theta) = \langle r\cos(\theta)(, r\sin(\theta) \rangle$ then after simplification, we have $(f \circ G)(r, \theta) = r^2$. Clearly then $\partial(f\circ G)/\partial r = 2r$ and $\partial(f\circ G)/\partial \theta = 0$.
"""

# ╔═╡ d017f0c6-7ad4-11ec-0989-3bbb5a4f178f
md"""Were this computed through the chain rule, we have:
"""

# ╔═╡ d017f0f8-7ad4-11ec-3307-ed4e1f2edeec
md"""```math
\begin{align}
\nabla G_1 &= \langle \frac{\partial r\cos(\theta)}{\partial r}, \frac{\partial r\cos(\theta)}{\partial \theta} \rangle=
\langle \cos(\theta), -r \sin(\theta) \rangle,\\
\nabla G_2 &= \langle \frac{\partial r\sin(\theta)}{\partial r}, \frac{\partial r\sin(\theta)}{\partial \theta}  \rangle=
\langle \sin(\theta), r \cos(\theta) \rangle.
\end{align}
```
"""

# ╔═╡ d017f120-7ad4-11ec-08b2-fb3c1b60c510
md"""We have $\partial f/\partial x = 2x$ and  $\partial f/\partial y = 2y$, which at $G$ are $2r\cos(\theta)$ and $2r\sin(\theta)$, so by the chain rule, we should have
"""

# ╔═╡ d017f140-7ad4-11ec-20c8-9f3c9620724e
md"""```math
\begin{align}
\frac{\partial (f\circ G)}{\partial r} &=
\frac{\partial{f}}{\partial{x}}\frac{\partial G_1}{\partial r} +
\frac{\partial{f}}{\partial{y}}\frac{\partial G_2}{\partial r} =
2r\cos(\theta) \cos(\theta) + 2r\sin(\theta) \sin(\theta) =
2r (\cos^2(\theta) + \sin^2(\theta)) = 2r, \\
\frac{\partial (f\circ G)}{\partial \theta} &=
\frac{\partial f}{\partial x}\frac{\partial G_1}{\partial \theta} +
\frac{\partial f}{\partial y}\frac{\partial G_2}{\partial \theta} =
2r\cos(\theta)(-r\sin(\theta)) + 2r\sin(\theta)(r\cos(\theta)) = 0.
\end{align}
```
"""

# ╔═╡ d017f15c-7ad4-11ec-0bf0-9d0d865d2cb9
md"""## Higher order partial derivatives
"""

# ╔═╡ d017f198-7ad4-11ec-316e-01899edf2196
md"""If $f:R^n \rightarrow R$, the $\partial f/\partial x_i$ takes $R^n \rightarrow R$ too, so may also have a partial derivative.
"""

# ╔═╡ d017f1e8-7ad4-11ec-2a61-f57e07b8468b
md"""Consider the case $f: R^2 \rightarrow R$, then there are $4$ possible partial derivatives of order 2: partial in $x$ then $x$, partial in $x$ then $y$, partial in $y$ and then $x$, and, finally, partial in $y$ and then $y$.
"""

# ╔═╡ d017f210-7ad4-11ec-3956-bb17307ea397
md"""The notation for the partial in $y$ *of* the partial in $x$ is:
"""

# ╔═╡ d017f242-7ad4-11ec-0b5f-515865f2a39a
md"""```math
\frac{\partial^2 f}{\partial{y}\partial{x}} = \frac{\partial{\frac{\partial{f}}{\partial{x}}}}{\partial{y}} = \frac{\partial f_x}{\partial{y}} = f_{xy}.
```
"""

# ╔═╡ d017f260-7ad4-11ec-17ad-e3265607b0cc
md"""The placement of $x$ and $y$ indicating the order is different in the two notations.
"""

# ╔═╡ d017f276-7ad4-11ec-27fe-a3576e7a27c9
md"""We can compute these for an example easily enough:
"""

# ╔═╡ d017f8b4-7ad4-11ec-0b19-61c031b042c0
let
	@syms x y
	f(x, y) = exp(x) * cos(y)
	ex = f(x,y)
	diff(ex, x, x), diff(ex, x, y), diff(ex, y, x), diff(ex, y, y)
end

# ╔═╡ d017f9f4-7ad4-11ec-3263-d7f9d41e77cf
md"""In `SymPy` the variable to differentiate by is taken from left to right, so `diff(ex, x, y, x)` would first take the partial in $x$, then $y$, and finally $x$.
"""

# ╔═╡ d017fa4e-7ad4-11ec-1196-5dcd1cf64244
md"""We see that `diff(ex, x, y)` and `diff(ex, y, x)` are identical. This is not a coincidence, as by [Schwarz's Theorem](https://tinyurl.com/y7sfw9sx) (also known as Clairaut's theorem) this will always be the case under typical assumptions:
"""

# ╔═╡ d017fb70-7ad4-11ec-2389-e923ef51b7cf
md"""> Theorem on mixed partials. If the mixed partials $\partial^2 f/\partial x \partial y$ and $\partial^2 f/\partial y \partial x$ exist and are continuous, then they are equal.

"""

# ╔═╡ d017fbb6-7ad4-11ec-17ba-1543b739b117
md"""For higher order mixed partials, something similar to Schwarz's theorem still  holds. Say $f:R^n \rightarrow R$ is $C^k$ if $f$ is continuous and all partial derivatives of order $j \leq k$ are continous. If $f$ is $C^k$, and $k=k_1+k_2+\cdots+k_n$ ($k_i \geq 0$) then
"""

# ╔═╡ d017fbde-7ad4-11ec-315f-e90993b7fb13
md"""```math
\frac{\partial^k f}{\partial x_1^{k_1} \partial x_2^{k_2}  \cdots \partial x_n^{k_n}},
```
"""

# ╔═╡ d017fbf2-7ad4-11ec-04d8-33f32519216f
md"""is uniquely defined. That is, which order the partial derivatives are taken is unimportant if the function is sufficiently smooth.
"""

# ╔═╡ d017fc1c-7ad4-11ec-26ea-bfcc7bbf9773
md"""---
"""

# ╔═╡ d017fc56-7ad4-11ec-00f2-d3e1cd384ba7
md"""The [Hessian](https://en.wikipedia.org/wiki/Hessian_matrix) matrix is the matrix of mixed partials defined (for $n=2$) by:
"""

# ╔═╡ d017fc74-7ad4-11ec-1268-c9df6abf02fb
md"""```math
H = \left[
\begin{align}
\frac{\partial^2 f}{\partial x \partial x} & \frac{\partial^2 f}{\partial x \partial y}\\
\frac{\partial^2 f}{\partial y \partial x} & \frac{\partial^2 f}{\partial y \partial y}
\end{align}
\right].
```
"""

# ╔═╡ d017fc9c-7ad4-11ec-3b74-d92afd6ca8be
md"""For symbolic expressions, the Hessian may be computed directly in `SymPy` with its `hessian` function:
"""

# ╔═╡ d017fee0-7ad4-11ec-16dc-31eb02a54841
ex

# ╔═╡ d01802fa-7ad4-11ec-3eb7-8304f93bcc83
hessian(ex, (x, y))

# ╔═╡ d018035e-7ad4-11ec-179b-893c8114837d
md"""When the mixed partials are continuous, this will be a symmetric matrix. The Hessian matrix plays the role of the second derivative in the multivariate Taylor theorem.
"""

# ╔═╡ d018039a-7ad4-11ec-0972-8da3ac06e556
md"""For numeric use, `FowardDiff` has a `hessian` function. It expects a scalar function and a point and returns the Hessian matrix. We have for $f(x,y) = e^x\cos(y)$ at the point $(1,2)$, the Hessian matrix is:
"""

# ╔═╡ d0180a0c-7ad4-11ec-088e-1b34a3835470
let
	f(x,y) = exp(x) * cos(y)
	f(v) = f(v...)
	pt = [1, 2]
	
	ForwardDiff.hessian(f, pt)  # symmetric
end

# ╔═╡ d0180a48-7ad4-11ec-3e78-3b52cad3de13
md"""## Questions
"""

# ╔═╡ d01ab126-7ad4-11ec-2ad2-194396565a74
md"""###### Question
"""

# ╔═╡ d01ab1b2-7ad4-11ec-121a-f5d65a04fb26
md"""Consider the graph of a function $z= f(x,y)$ presented below:
"""

# ╔═╡ d01abcf2-7ad4-11ec-19bb-d92598b7fbf2
let
	f(x,y) = x * exp(-(x^2 + y^2))
	xs = ys = range(-2, stop=2, length=50)
	surface(xs, ys, f)
end

# ╔═╡ d01abd2e-7ad4-11ec-1537-870228140ec6
md"""From the graph, is the value of $f(1/2, 1)$ positive or negative?
"""

# ╔═╡ d01ac31e-7ad4-11ec-1cba-1b10ab8c5fa0
let
	choices = ["positive", "negative"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01ac350-7ad4-11ec-2518-27259d7a0896
md"""On which line is the function $0$:
"""

# ╔═╡ d01aca2e-7ad4-11ec-1994-4fc17b3b4a3f
let
	choices = [
	L"The line $x=0$",
	L"The line $y=0$"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01aca60-7ad4-11ec-0a29-cbdbd6d9326a
md"""Consider the contour plot
"""

# ╔═╡ d01ad446-7ad4-11ec-09d2-a1dc9f669ff9
let
	f(x,y) = x * exp(-(x^2 + y^2))
	xs = ys = range(-2, stop=2, length=50)
	contour(xs, ys, f)
end

# ╔═╡ d01ad494-7ad4-11ec-1518-ad577914f31f
md"""What is the value of $f(1, 0)$?
"""

# ╔═╡ d01ad8fe-7ad4-11ec-2bf8-c7b4c56ec283
let
	val = 0.367879
	numericq(val, 1/2)
end

# ╔═╡ d01ad91c-7ad4-11ec-23a5-4f3513d1b0cd
md"""From this graph, the minimum value over this region is
"""

# ╔═╡ d01ae5b0-7ad4-11ec-287e-b14a9e15c913
let
	choices = [
	L"is around $(-0.7, 0)$ and with a value less than $-0.4$",
	L"is around $(0.7, 0)$ and with a value less than $-0.4$",
	L"is around $(-2.0, 0)$ and with a value less than $-0.4$",
	L"is around $(2.0, 0)$ and with a value less than $-0.4$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01ae5ec-7ad4-11ec-30e0-27d243dab4c7
md"""From this graph, where is the surface steeper?
"""

# ╔═╡ d01aedee-7ad4-11ec-1414-653e29712551
let
	choices = [
	L"near $(1/4, 0)$",
	L"near $(1/2, 0)$",
	L"near $(3/4, 0)$",
	L"near $(1, 0)$"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01aee20-7ad4-11ec-0c57-256642abc198
md"""###### Question
"""

# ╔═╡ d01aee34-7ad4-11ec-0dc3-79bba9eccbab
md"""Consider the contour graph of a function below:
"""

# ╔═╡ d01af3c0-7ad4-11ec-1c87-21efbf65e04d
let
	f(x,y)= sin(x)*cos(x*y)
	xs = ys = range(-3, stop=3, length=50)
	contour(xs, ys, f)
end

# ╔═╡ d01af3de-7ad4-11ec-0f58-03454dd559ef
md"""Are there any peaks or valleys (local extrema) indicated?
"""

# ╔═╡ d01afce4-7ad4-11ec-1ab8-15c0fd6831ca
let
	choices = [
	L"Yes, the closed loops near $(-1.5, 0)$ and $(1.5, 0)$ will contain these",
	L"No, the vertical lines parallel to $x=0$ show this function to be flat"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01afcf8-7ad4-11ec-0e85-4ba20d3ae836
md"""Imagine hiking on this surface within this region. Could you traverse from left to right without having to go up or down?
"""

# ╔═╡ d01aff1e-7ad4-11ec-0fae-0d0a5408a4d8
let
	yesnoq(false)
end

# ╔═╡ d01aff32-7ad4-11ec-1fa4-295ae0d6d835
md"""Imagine hiking on this surface within this region. Could you traverse from top to bottom without having to go up or down?
"""

# ╔═╡ d01b00d6-7ad4-11ec-179c-5d8f1d4757ba
let
	yesnoq(true)
end

# ╔═╡ d01b00f4-7ad4-11ec-1d9c-bf390486a327
md"""###### Question
"""

# ╔═╡ d01b0130-7ad4-11ec-10c7-d780804086c5
md"""The figure (taken from [openstreetmap.org](https://www.openstreetmap.org/way/537938655#map=15/46.5308/10.4556&layers=C) shows the [Stelvio](https://en.wikipedia.org/wiki/Stelvio_Pass) Pass  in Northern Italy near the Swiss border.
"""

# ╔═╡ d01b05cc-7ad4-11ec-29f8-3f0c270f020a
let
	ImageFile(:differentiable_vector_calculus, "figures/stelvio-pass.png", "Stelvio Pass")
end

# ╔═╡ d01b05ec-7ad4-11ec-35b8-570e5af3e01a
md"""The road through the pass (on the right) makes a series of switch backs.
"""

# ╔═╡ d01b05fe-7ad4-11ec-2adb-2993a5de33bd
md"""Are these
"""

# ╔═╡ d01b0e64-7ad4-11ec-222a-1f594609d01a
let
	choices = [
	"running essentially parallel to the contour lines",
	"running essentially perpendicular to the contour lines"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b0e78-7ad4-11ec-3d34-731deddccb91
md"""Why?
"""

# ╔═╡ d01b1906-7ad4-11ec-1603-83d6f31120e2
let
	choices = [
	"By being essentially parallel, the steepness of the roadway can be kept to a passable level",
	"By being essentially perpendicular, the road can more quickly climb up the mountain"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b192c-7ad4-11ec-0ca2-db96773e2ddd
md"""The pass is at about 2700 meters. As shown towards the top and bottom of the figure the contour lines show increasing heights, and to the left and right decreasing heights. The shape of the [pass](https://en.wikipedia.org/wiki/Mountain_pass) would look like:
"""

# ╔═╡ d01b2188-7ad4-11ec-08c9-f7fd17e47069
let
	choices = [
	"A saddle-like shape, called a *col* or *gap*",
	"A upside down bowl-like shape like the top of a mountain"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b219c-7ad4-11ec-0927-e1c0c47f1a72
md"""###### Question
"""

# ╔═╡ d01b21ce-7ad4-11ec-0be1-977dc60bcff7
md"""Limits of scalar functions have the same set of rules as limits of univariate functions. These include limits of constants; limits of sums, differences, and scalar multiples; limits of products; and limits of ratios. The latter with the provision that division by $0$ does not occur at the point in question.
"""

# ╔═╡ d01b2200-7ad4-11ec-10ba-0fb3fd4f1d22
md"""Using these, identify any points where the following limit *may* not exist, knowing the limits of the individual functions exist at $\vec{c}$:
"""

# ╔═╡ d01b2232-7ad4-11ec-2f30-cd04e3547943
md"""```math
\lim_{\vec{x} \rightarrow \vec{x}} \frac{af(\vec{x})g(\vec{x}) + bh(\vec{x})}{ci(\vec{x})}.
```
"""

# ╔═╡ d01b2d5e-7ad4-11ec-20d7-915e8f701202
let
	choices = [
	L"When $i(\vec{x}) = 0$",
	L"When any of $f(\vec{x})$, $g(\vec{x})$, or $i(\vec{x})$ are zero",
	L"The limit exists everywhere, as the function $f$, $g$, $h$, and $i$ have limits at $\vec{c}$ by assumption"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b2d90-7ad4-11ec-2153-bf1221b97ff4
md"""###### Question
"""

# ╔═╡ d01b2dba-7ad4-11ec-10f3-131f73cfb803
md"""Let $f(x,y) = (x^2 -  y^2) /(x^2 + y^2)$.
"""

# ╔═╡ d01b2dcc-7ad4-11ec-14e7-4b86cab0d799
md"""Fix $y=0$. What is $\lim_{x \rightarrow 0} f(x,0)$?
"""

# ╔═╡ d01b302e-7ad4-11ec-29db-b3bd984fabda
let
	numericq(1)
end

# ╔═╡ d01b3058-7ad4-11ec-2aaf-ef6ef94d970b
md"""Fix $x=0$. What is $\lim_{y \rightarrow 0} f(0, y)$?
"""

# ╔═╡ d01b3268-7ad4-11ec-35e0-f9f58e0041f1
let
	numericq(-1)
end

# ╔═╡ d01b329a-7ad4-11ec-1b95-43ba6015ce81
md"""The two paths technique shows a limit does not exist by finding two paths with *different* limits as $\vec{x}$ approaches $\vec{c}$. Does this apply to $\lim_{\langle x,y\rangle \rightarrow\langle 0, 0 \rangle}f(x,y)$?
"""

# ╔═╡ d01b345e-7ad4-11ec-0b56-a7879653a245
let
	yesnoq(true)
end

# ╔═╡ d01b3470-7ad4-11ec-3381-5f423306e8d6
md"""###### Question
"""

# ╔═╡ d01b3490-7ad4-11ec-3b87-9d83f7963fed
md"""Let $f(x,y) = \langle \sin(x)\cos(2y), \sin(2x)\cos(y) \rangle$
"""

# ╔═╡ d01b3498-7ad4-11ec-011b-7b69c5976c73
md"""Compute $f_x$
"""

# ╔═╡ d01b3f38-7ad4-11ec-17b8-2b7ad64a330b
let
	choices = [
	raw"`` \langle \cos(x)\cos(2y), 2\cos(2x)\cos(y)\rangle``",
	raw"`` \langle \cos(2y), \cos(y) \rangle``",
	raw"`` \langle \sin(x), \sin(2x) \rangle``",
	raw"`` \sin(x)\cos(2y)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b3f56-7ad4-11ec-379e-05b95d747597
md"""Compute $f_y$
"""

# ╔═╡ d01b4ae6-7ad4-11ec-2aa9-75e928eb689d
let
	choices = [
	raw"`` \langle -2\sin(x)\sin(2y), -\sin(2x)\sin(y)  \rangle``",
	raw"`` \langle 2\sin(x), \sin(2x)  \rangle``",
	raw"`` \langle  -2\sin(2y), -\sin(y) \rangle``",
	raw"`` - \sin(2x)\sin(y)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b4b04-7ad4-11ec-0325-dfd7864ddd2b
md"""###### Question
"""

# ╔═╡ d01b4b5e-7ad4-11ec-2fff-d5803292398d
md"""Let $f(x,y) = x^{y\sin(xy)}$. Using `ForwardDiff`, at the point $(1/2, 1/2)$, compute the following.
"""

# ╔═╡ d01b4b72-7ad4-11ec-32a4-bb64f2912ec2
md"""The value of $f_x$:
"""

# ╔═╡ d01b5194-7ad4-11ec-3a70-87b930505bfa
let
	f(x,y) = x^(y*sin(x*y))
	f(v) = f(v...)
	pt  = [1/2, 1/2]
	fx, fy = ForwardDiff.gradient(f, pt)
	numericq(fx)
end

# ╔═╡ d01b51b0-7ad4-11ec-298a-75ae76e4457d
md"""The value of $\partial{f}/\partial{y}$:
"""

# ╔═╡ d01b578e-7ad4-11ec-2698-37d219230490
let
	f(x,y) = x^(y*sin(x*y))
	f(v) = f(v...)
	pt  = [1/2, 1/2]
	fx, fy = ForwardDiff.gradient(f, pt)
	numericq(fy)
end

# ╔═╡ d01b57ac-7ad4-11ec-19ac-3d1e01f582ee
md"""###### Question
"""

# ╔═╡ d01b57ca-7ad4-11ec-3280-956788ed5d19
md"""Let $z = f(x,y)$ have gradient $\langle f_x, f_y \rangle$.
"""

# ╔═╡ d01b57f4-7ad4-11ec-02c2-ad6c1cfb6810
md"""The gradient is:
"""

# ╔═╡ d01b5da6-7ad4-11ec-21ed-31b0ae47679c
let
	choices = ["two dimensional", "three dimensional"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01b5dc6-7ad4-11ec-2ea3-475fdb18d5c7
md"""The surface is:
"""

# ╔═╡ d01b6382-7ad4-11ec-25f7-dd92648d1586
let
	choices = ["two dimensional", "three dimensional"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01b63b4-7ad4-11ec-3770-53bfa6e798e1
md"""The gradient points in the direction of greatest increase of $f$. If a person were on a hill described by $z=f(x,y)$, what three dimensional vector would they follow to go the steepest way up the hill?
"""

# ╔═╡ d01b6c04-7ad4-11ec-1a53-f9726bf17456
let
	choices = [
	    raw"`` \langle f_x, f_y, -1 \rangle``",
	    raw"`` \langle -f_x, -f_y, 1 \rangle``",
	    raw"`` \langle f_x, f_y \rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b6c42-7ad4-11ec-0a36-c3ce512a37fb
md"""##### Question
"""

# ╔═╡ d01b6c56-7ad4-11ec-127c-2544e2d6f0b9
md"""The figure shows climbers on their way to summit Mt. Everest:
"""

# ╔═╡ d01b708e-7ad4-11ec-1918-9797dbb7252b
let
	imgfile = "figures/everest.png"
	caption = "Climbers en route to the summit of Mt. Everest"
	ImageFile(:differentiable_vector_calculus, imgfile, caption)
end

# ╔═╡ d01b70b6-7ad4-11ec-1803-bdf73ac883e2
md"""If the surface of the mountain is given by a function $z=f(x,y)$ then the climbers move along a single path parameterized, say, by $\vec{\gamma}(t) = \langle x(t), y(t)\rangle$, as set up by the Sherpas.
"""

# ╔═╡ d01b70ca-7ad4-11ec-01d1-1baa93e0b119
md"""Consider the composition $(f\circ\vec\gamma)(t)$.
"""

# ╔═╡ d01b70e0-7ad4-11ec-1e26-4f2743256a84
md"""For a climber with GPS coordinates $(x,y)$. What describes her elevation?
"""

# ╔═╡ d01b7840-7ad4-11ec-123b-b9183dd0b1fc
let
	choices = [
	    raw"`` f(x,y)``",
	    raw"`` (f\circ\vec\gamma)(x,y)``",
	    raw"`` \vec\gamma(x,y)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b787a-7ad4-11ec-1b10-8948d99a0ec0
md"""A climber leaves base camp at $t_0$. At time $t > t_0$, what describes her elevation?
"""

# ╔═╡ d01b7f8e-7ad4-11ec-277b-abd9cd473e2f
let
	choices = [
	    raw"`` (f\circ\vec\gamma)(t)``",
	    raw"`` \vec\gamma(t)``",
	    raw"`` f(t)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b7fac-7ad4-11ec-3ab9-7be84dd56ac9
md"""What does the vector-valued function $\vec{r}(t) = \langle x(t), y(t), (f\circ\vec\gamma(t))\rangle$ describe:
"""

# ╔═╡ d01b8844-7ad4-11ec-1ffe-bb321207c0bc
let
	choices = [
	    "The three dimensional position of the climber",
	    "The climbers gradient, pointing in the direction of greatest ascent"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b886c-7ad4-11ec-1fea-450ee0bded92
md"""In the figure, the climbers are making a switch back, so as to avoid the steeper direct ascent. Mathematically $\nabla{f}(\vec\gamma(t)) \cdot \vec\gamma'(t)$ describes the directional derivative that they follow. Using $\|\vec{u}\cdot\vec{v}\| = \|\vec{u}\|\|\vec{v}\|\cos(\theta)$, does this route:
"""

# ╔═╡ d01b964a-7ad4-11ec-326c-01cfe9be3a59
let
	choices = [
	    L"Keep $\cos(\theta)$ smaller than $1$, so that the slope taken is not too great",
	    L"Keep $\cos(\theta)$ as close to $1$ as possible, so the slope taken is as big as possible",
	    L"Keep $̧\cos(\theta)$ as close to $0$ as possible, so that they climbers don't waste energy going up and down"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01b9670-7ad4-11ec-2297-cf1551dadcb5
md"""Suppose our climber reaches the top at time $t$. What would be $(f\circ\vec\gamma)'(t)$, assuming the derivative exists?
"""

# ╔═╡ d01ba2fc-7ad4-11ec-344d-d183966f88b6
let
	choices = [
	    L"It would be $0$, as the top would be maximum for $f\circ\vec\gamma$",
	    L"It would be $\langle f_x, f_y\rangle$ and point towards the sky, the direction of greatest ascent",
	    "It would not exist, as there would not be enough oxygen to compute it"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01ba318-7ad4-11ec-2231-3dec3f4ac743
md"""###### Question
"""

# ╔═╡ d01ba338-7ad4-11ec-0d04-d73afa2d8052
md"""Building sustainable hiking trails involves proper water management. Two rules of thumb are 1) the trail should not be steeper than 10 degrees 2) the outward slope (in the steepest downhill direction) should be around 5%. (A trail tread is not flat, but rather sloped downward, similar to the crown on a road, so that water will run to the downhill side of the tread, not along the tread, which would cause erosion. In the best possible world, the outslope will exceed the downward slope.)
"""

# ╔═╡ d01ba37e-7ad4-11ec-129e-5d7851d7b8d2
md"""Suppose a trail height is described parametrically by a composition $(f \circ \vec\gamma)(t))$, where $\vec\gamma(t) = \langle x(t),y(t)\rangle$. The vector $\vec{T}(t) = \langle x(t), y(t), \nabla{f}(\vec\gamma(t)) \rangle$ describes the tangent to the trail at a point ($\vec\gamma(t)$). Let $\hat{T}(t)$ be the unit normal, and $\hat{P}(t)$ be a unit normal in the direction of the *projection* of $\vec{T}$ onto the $x$-$y$ plane. (Make the third component of $\vec{T}$ $0$, and then form a unit vector from that.)
"""

# ╔═╡ d01ba392-7ad4-11ec-347f-bfc00ed1865e
md"""What expression below captures point 1 that the steepness should be no more than 10 degrees ($\pi/18$ radians):
"""

# ╔═╡ d01bad30-7ad4-11ec-1791-1b017d022a44
let
	choices = [
	raw"`` |\hat{T} \cdot \hat{P}| \leq \cos(π/18)``",
	    raw"`` |\hat{T} \cdot \hat{P}| \leq \sin(\pi/18)``",
	    raw"`` |\hat{T} \cdot \hat{P}| \leq \pi/18``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bad7e-7ad4-11ec-3cea-7bbbe4614210
md"""The normal to the surface $z=f(x,y)$ is *not* the normal to the trail tread. Suppose $\vec{N}(t)$ is a function that returns this. At the same point $\vec\gamma(t)$, let $\vec{M} = \langle -f_x, -f_y, 0\rangle$ be a vector in 3 dimensions pointing downhill. Let "hats" indicate unit vectors. The outward slope is $\pi/2$ minus the angle between $\hat{N}$ and $\hat{M}$. What condition will ensure this angle is $5$ degrees ($\pi/36$ radians)?
"""

# ╔═╡ d01bb774-7ad4-11ec-20ba-8953162cd988
let
	choices = [
	    raw"`` |\hat{N} \cdot \hat{M}| \leq \cos(\pi/2 - π/36)``",
	    raw"`` |\hat{N} \cdot \hat{M}| \leq \sin(\pi/2 - \pi/18)``",
	    raw"`` |\hat{N} \cdot \hat{M}| \leq \pi/2 - \pi/18``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bb792-7ad4-11ec-0a0d-9dad8aab24b9
md"""###### Question
"""

# ╔═╡ d01bb7ba-7ad4-11ec-357b-67ca025e6968
md"""Let $f(x,y) = x^2 \cdot(x - y^2)$. Let $\vec{v} = \langle 1, 2\rangle$. Find the directional derivative in the direction of $\vec{v}$.
"""

# ╔═╡ d01bc502-7ad4-11ec-239f-83ade3f2d328
let
	choices = [
	    raw"`` \frac{\sqrt{5}}{5}\left(2 \cos{\left (3 \right )} - 7 \sin{\left (3 \right )}\right)``",
	    raw"`` 2 \cos{\left (3 \right )} - 7 \sin{\left (3 \right )}``",
	    raw"`` 4 x^{2} y \sin{\left (x - y^{2} \right )} - x^{2} \sin{\left (x - y^{2} \right )} + 2 x \cos{\left (x - y^{2} \right )}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bc520-7ad4-11ec-0c3e-f1245a8d1b6f
md"""###### Question
"""

# ╔═╡ d01bc546-7ad4-11ec-3e11-df6530e8af58
md"""Let $\vec{v}$ be any non-zero vector. Does $\nabla{f}(\vec{x})\cdot\vec{v}$ give the rate of increase of $f$ per unit of distance in the direction of $\vec{v}$?
"""

# ╔═╡ d01bcc00-7ad4-11ec-3717-1ffda5546988
let
	choices = [
	    "Yes, by definition",
	    L"No, not unless $\vec{v}$ were a unit vector"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ d01bcc14-7ad4-11ec-26aa-ef0489761118
md"""###### Question
"""

# ╔═╡ d01bcc50-7ad4-11ec-2349-cbc748d9fd16
md"""Let $f(x,y,z) = x^4 + 2xz + 2xy + y^4$ and $\vec\gamma(t) = \langle t, t^2, t^3\rangle$. Using the chain rule, compute $(f\circ\vec\gamma)'(t)$.
"""

# ╔═╡ d01bcc64-7ad4-11ec-1d31-970d4681e123
md"""The value of $\nabla{f}(x,y,z)$ is
"""

# ╔═╡ d01bd6be-7ad4-11ec-1854-411d42231275
let
	choices = [
	    raw"`` \langle 4x^3 + 2x + 2y, 2x + 4y^3, 2x \rangle``",
	    raw"`` \langle 4x^3, 2z, 2y\rangle``",
	    raw"`` \langle x^3 + 2x + 2x, 2y+ y^3, 2x\rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bd704-7ad4-11ec-05b7-7725dbe493fe
md"""The value of $\vec\gamma'(t)$ is:
"""

# ╔═╡ d01bdec0-7ad4-11ec-1c97-7d83318cde47
let
	choices = [
	    raw"`` \langle 1, 2t, 3t^2\rangle``",
	    raw"`` 1 + 2y + 3t^2``",
	    raw"`` \langle 1,2, 3 \rangle``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bdee8-7ad4-11ec-1005-472001cecb23
md"""The value of $(f\circ\vec\gamma)'(t)$ is found by:
"""

# ╔═╡ d01beaaa-7ad4-11ec-298a-0911f815120e
let
	choices = [
	    L"Taking the dot product of  $\nabla{f}(\vec\gamma(t))$ and $\vec\gamma'(t)$",
	    L"Taking the dot product of  $\nabla{f}(\vec\gamma'(t))$ and $\vec\gamma(t)$",
	    L"Taking the dot product of  $\nabla{f}(x,y,z)$ and $\vec\gamma'(t)$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01beac8-7ad4-11ec-2eeb-6929ff3433e0
md"""###### Question
"""

# ╔═╡ d01beadc-7ad4-11ec-0fb0-fbc479d3e031
md"""Let $z = f(x,y)$ be some unknown function,
"""

# ╔═╡ d01beaf0-7ad4-11ec-14f7-313d1a154b0a
md"""From the figure, which drawn vector is the gradient at $(1/2, -3/4)$?
"""

# ╔═╡ d01bf130-7ad4-11ec-0348-3d8ba81e6590
let
	f(x,y) = 2 + x^2 - y^2
	f(v) = f(v...)
	pt = [1/2, -3/4]
	xs = ys = range(-1, stop=1, length=50)
	uvec(x) = x/norm(x)
	
	gradf = ForwardDiff.gradient(f, pt)
	surface(xs, ys, f, legend=false) #, aspect_ratio=:equal)
	arrow!([pt...,0], [uvec(gradf)...,0], color=:blue, linewidth=3)
	arrow!([pt...,0], [-1,0,0], color=:green, linewidth=3)
	arrow!([pt..., f(pt...)], uvec([(-gradf)..., 1]), color=:red, linewidth=3)
end

# ╔═╡ d01bf7fc-7ad4-11ec-182c-f9d1a3aaf46e
let
	choices = [
	    "The blue one",
	    "The green one",
	    "The red one"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01bf822-7ad4-11ec-1a47-c57a03aa87ef
md"""From the figure, which drawn vector is the gradient as $(1/2, -3/4)$?
"""

# ╔═╡ d01bfe82-7ad4-11ec-0454-4b4527dc9d29
let
	f(x,y) = 2 + x^2 - y^2
	f(v) = f(v...)
	
	uvec(v)=v/norm(v)
	pt = [1/2, -3/4]
	gradf = ForwardDiff.gradient(f, pt)
	xs = ys = range(-3/2, stop=3/2, length=50)
	
	contour(xs, ys, f, aspect_ratio=:equal)
	arrow!(pt, [uvec(gradf)...], color=:blue, linewidth=3)
	arrow!(pt, [-1, 0], color=:green, linewidth=3)
	arrow!([0,0], pt, color=:red, linewidth=3)
end

# ╔═╡ d01c054e-7ad4-11ec-00b2-dd0121c172ae
let
	choices = [
	    "The blue one",
	    "The green one",
	    "The red one"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01c056a-7ad4-11ec-22df-17ad39d13058
md"""###### Question
"""

# ╔═╡ d01c0594-7ad4-11ec-0a78-4543a36c3be1
md"""For a function $f(x,y)$ and a point (as a vector, $\vec{c}$) we consider this derived function:
"""

# ╔═╡ d01c05b2-7ad4-11ec-010d-cd46db6d139d
md"""```math
g(\vec{x}) = f(\vec{c}) + \nabla{f}(\vec{c}) \cdot(\vec{x} - \vec{c}) + \frac{1}{2}(\vec{x} - \vec{c})^tH(\vec{c})(\vec{x} - \vec{c}),
```
"""

# ╔═╡ d01c05c6-7ad4-11ec-2038-e9976b9f4cac
md"""where $H(\vec{c})$ is the Hessian.
"""

# ╔═╡ d01c05e4-7ad4-11ec-1eef-630a3892bdda
md"""Further, *suppose* $\nabla{f}(\vec{c}) = \vec{0}$, so in fact:
"""

# ╔═╡ d01c062a-7ad4-11ec-21d8-736fbcd580cd
md"""```math
g(\vec{x}) = f(\vec{c}) + \frac{1}{2}(\vec{x} - \vec{c})^tH(\vec{c})(\vec{x} - \vec{c}).
```
"""

# ╔═╡ d01c0652-7ad4-11ec-2a01-f97de42ab5b2
md"""If $f$ is a linear function at $\vec{c}$, what does this say about $g$?
"""

# ╔═╡ d01c125a-7ad4-11ec-2868-d72377fdb0ff
let
	choices = [
	    L"Linear means $H$ is the $0$ matrix, so $g(\vec{x})$ is the constant $f(\vec{c})$",
	    L"Linear means $H$ is linear, so $g(\vec{x})$ describes a plane",
	    L"Linear means $H$ is the $0$ matrix, so the gradient couldn't have been $\vec{0}$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d01c128c-7ad4-11ec-2166-13b3c0cadc19
md"""Suppose, $H$ has the magic property that for *any* vector $\vec{v}^tH\vec{v} < 0$. What does this imply:
"""

# ╔═╡ d01c1ade-7ad4-11ec-0617-5faf8023cbf5
let
	choices = [
	    L"That $g(\vec{x}) \geq f(\vec{c})$",
	    L"That $g(\vec{x}) = f(\vec{c})$",
	    L"That $g(\vec{x}) \leq f(\vec{c})$"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01c1b06-7ad4-11ec-35a8-fb18e756d713
md"""###### Question
"""

# ╔═╡ d01c1b2e-7ad4-11ec-242e-553f5c891080
md"""Let $f(x,y) = x^3y^3$. Which partial derivative is identically $0$?
"""

# ╔═╡ d01c4de2-7ad4-11ec-0979-fbce3e36e72d
let
	choices = [
	    raw"`` \partial^4{f}/\partial{x^4}``",
	    raw"`` \partial^4{f}/\partial{x^3}\partial{y}``",
	    raw"`` \partial^4{f}/\partial{x^2}\partial{y^2}``",
	    raw"`` \partial^4{f}/\partial{x^1}\partial{y^3}``"
	]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01c4e30-7ad4-11ec-0151-b15f2220a1d9
md"""###### Question
"""

# ╔═╡ d01c4e6e-7ad4-11ec-3bc8-8549e22811e8
md"""Let $f(x,y) = 3x^2 y$.
"""

# ╔═╡ d01c4e8c-7ad4-11ec-0ad3-37e29913f251
md"""Which value is greater at the point $(1/2,2)$?
"""

# ╔═╡ d01c57b0-7ad4-11ec-3717-df4290df7994
let
	choices = [
	    raw"`` f_x``",
	    raw"`` f_y``",
	    raw"`` f_{xx}``",
	    raw"`` f_{xy}``",
	    raw"`` f_{yy}``"
	]
	x,y=1/2, 2
	val, ans = findmax([6x*y, 3x^2, 6*y, 6x, 0])
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d01c57ce-7ad4-11ec-0ed0-7fb5b48d064d
md"""###### Question
"""

# ╔═╡ d01c57ec-7ad4-11ec-20d7-d92bc91fe216
md"""The order of partial derivatives matters if the mixed partials are not continuous. Take
"""

# ╔═╡ d01c5808-7ad4-11ec-09ad-697f0f4e0c28
md"""```math
f(x,y) = \frac{xy ( x^2 - y^2)}{x^2 + y^2}, \quad f(0,0) = 0
```
"""

# ╔═╡ d01c5814-7ad4-11ec-2772-63860b56107a
md"""Using the definition of the derivative from a limit, we have
"""

# ╔═╡ d01c5828-7ad4-11ec-0053-eb8e68c0953e
md"""```math
\frac{\partial \frac{\partial f}{\partial x}}{ \partial y} =
\lim_{\Delta y \rightarrow 0} \lim_{\Delta x \rightarrow 0}
\frac{f(x+\Delta x, y + \Delta y) - f(x, y+\Delta{y}) - f(x+\Delta x,y) + f(x,y)}{\Delta x \Delta y}.
```
"""

# ╔═╡ d01c5832-7ad4-11ec-38db-d133a3306bbe
md"""Whereas,
"""

# ╔═╡ d01c5846-7ad4-11ec-1327-599c175ebe58
md"""```math
\frac{\partial \frac{\partial f}{\partial y}}{ \partial x} =
\lim_{\Delta x \rightarrow 0} \lim_{\Delta y \rightarrow 0}
\frac{f(x+\Delta x, y + \Delta y) - f(x, y+\Delta{y}) - f(x+\Delta x,y) + f(x,y)}{\Delta x \Delta y}.
```
"""

# ╔═╡ d01c5864-7ad4-11ec-0777-d302a64e754c
md"""At $(0,0)$ what is $ \frac{\partial \frac{\partial f}{\partial x}}{ \partial y}$?
"""

# ╔═╡ d01c5ce4-7ad4-11ec-0e1e-3bb365ae6d1d
let
	ans = -1
	numericq(ans)
end

# ╔═╡ d01c5d0a-7ad4-11ec-06c6-2b19fdce639b
md"""At $(0,0)$ what is $ \frac{\partial \frac{\partial f}{\partial y}}{ \partial x}$?
"""

# ╔═╡ d01c60ca-7ad4-11ec-1e36-257e5eb602e9
let
	ans = 1
	numericq(ans)
end

# ╔═╡ d01c6106-7ad4-11ec-36e6-0d129c2c7a71
md"""Away from $(0,0)$ the mixed partial is $\frac{x^{6} + 9 x^{4} y^{2} - 9 x^{2} y^{4} - y^{6}}{x^{6} + 3 x^{4} y^{2} + 3 x^{2} y^{4} + y^{6}}$.
"""

# ╔═╡ d01c6f7a-7ad4-11ec-054a-f70577afcfeb
let
	choices = [
	    "As this is the ratio of continuous functions, it is continuous at the origin",
	    L"This is not continuous at $(0,0)$, still the limit along the two paths $x=0$ and $y=0$ are equivalent.",
	    L"This is not continuous at $(0,0)$, as the limit along the two paths $x=0$ and $y=0$ are not equivalent."
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ d01c6f98-7ad4-11ec-3708-2b7cee3a45e3
md"""###### Question
"""

# ╔═╡ d01db9dc-7ad4-11ec-001a-c9e22b71491f
md"""[Knill](http://www.math.harvard.edu/~knill/teaching/summer2018/handouts/week3.pdf). Clairaut's theorem is the name given to the fact that if the partial derivatives are continuous, the mixed partials are equal, $f_{xy} = f_{yx}$.
"""

# ╔═╡ d01dba42-7ad4-11ec-00f8-876d272c5064
md"""Consider the following code which computes the mixed partials for the discrete derivative:
"""

# ╔═╡ d01dc350-7ad4-11ec-2f08-3746efed04f4
let
	@syms x::real y::real Δ::real G()
	
	Dx(f,h) = (subs(f, x=>x+h) - f)/h
	Dy(f,h) = (subs(f, y=>y+h) - f)/h
	
	Dy(Dx(G(x,y), Δ), Δ) - Dx(Dy(G(x,y), Δ), Δ)
end

# ╔═╡ d01dc370-7ad4-11ec-1721-0fd38cde2562
md"""What does this simplify to?
"""

# ╔═╡ d01dc582-7ad4-11ec-0611-a5e8e9801641
let
	numericq(0)
end

# ╔═╡ d01dc5a0-7ad4-11ec-2e1f-b734060af4ac
md"""Is continuity required for this to be true?
"""

# ╔═╡ d01dc776-7ad4-11ec-2ff5-e977cb8e2432
let
	yesnoq(false)
end

# ╔═╡ d01dc79e-7ad4-11ec-158d-e3839603bb58
md"""###### Question
"""

# ╔═╡ d01dc7ba-7ad4-11ec-1746-c30814654d64
md"""(Examples and descriptions from Krill)
"""

# ╔═╡ d01dc7e4-7ad4-11ec-0dde-fbc99bea7327
md"""What equation does the function $f(x,y) = x^3 - 3xy^2$ satisfy?
"""

# ╔═╡ d01de5c6-7ad4-11ec-1b44-65215b7079d3
begin
	# 4 questions, don't edit this order!
	ode_choices = [
	L"The wave equation: $f_{tt} = f_{xx}$; governs motion of light or sound",
	L"The heat equation: $f_t = f_{xx}$; describes diffusion of heat",
	L"The Laplace equation: $f_{xx} + f_{yy} = 0$; determines shape of a membrane",
	L"The advection equation: $f_t = f_x$; is used to model transport in a wire",
	L"The eiconal equation: $f_x^2 + f_y^2 = 1$; is used to model evolution of a wave front in optics",
	L"The Burgers equation: $f_t + ff_x = f_{xx}$; describes waves at the beach which break",
	L"The KdV equation: $f_t + 6ff_x+ f_{xxx} = 0$; models water waves in a narrow channel",
	L"The Schrodinger equation: $f_t = (i\hbar/(2m))f_xx$; used to describe a quantum particle of mass $m$"
	]
	ans′ = 3
	radioq(ode_choices, ans′, keep_order=true)
end

# ╔═╡ d01de60c-7ad4-11ec-1493-2322627fc607
md"""What equation does the function $f(t, x) = sin(x-t) + sin(x+t)$ satisfy?
"""

# ╔═╡ d01de9c2-7ad4-11ec-398b-93314a625688
let
	ans = 1
	radioq(ode_choices, ans, keep_order=true)
end

# ╔═╡ d01de9e0-7ad4-11ec-0fc2-bb49de0fd96e
md"""What equation does the function $f(t, x) = e^{-(x+t)^2}$ satisfy?
"""

# ╔═╡ d01ded82-7ad4-11ec-13b9-1bb93da8f2da
let
	ans = 4
	radioq(ode_choices, ans, keep_order=true)
end

# ╔═╡ d01dedaa-7ad4-11ec-2720-9b2c2c209778
md"""What equation does the function $f(x,y) = \cos(x) + \sin(y)$ satisfy?
"""

# ╔═╡ d01df106-7ad4-11ec-10bd-c73f4f586949
let
	ans = 5
	radioq(ode_choices, ans, keep_order=true)
end

# ╔═╡ d01df124-7ad4-11ec-11d6-37d6fda15d2e
HTML("""<div class="markdown"><blockquote>
<p><a href="../differentiable_vector_calculus/vector_valued_functions.html">◅ previous</a>  <a href="../differentiable_vector_calculus/scalar_functions_applications.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/differentiable_vector_calculus/scalar_functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ d01df14c-7ad4-11ec-1a31-d55c97b50c8a
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Contour = "d38c429a-6771-53c6-b99e-75d170b6e991"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CSV = "~0.10.2"
CalculusWithJulia = "~0.0.14"
Contour = "~0.5.7"
DataFrames = "~1.3.1"
ForwardDiff = "~0.10.25"
JSON = "~0.21.2"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
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

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "9519274b50500b8029973d241d32cfbf0b127d97"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.2"

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
git-tree-sha1 = "54fc4400de6e5c3e27be6047da2ef6ba355511f8"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

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
git-tree-sha1 = "cfdfef912b7f93e4b848e80b9befdf9e331bc05a"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.1"

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

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "04d13bfa8ef11720c24e4d840c0033d145537df7"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.17"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "8d70835a3759cdd75881426fced1508bb7b7e1b6"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.1"

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
git-tree-sha1 = "6f1b25e8ea06279b5689263cc538f51331d7ca17"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.3"

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

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

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

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "15dfe6b103c2a993be24404124b8791a09460983"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.11"

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
git-tree-sha1 = "2884859916598f974858ff01df7dfc6c708dd895"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.3"

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

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

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

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

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
# ╟─d01df110-7ad4-11ec-2b29-b79ee4db4592
# ╟─cfc7987e-7ad4-11ec-21bf-e9b665dc3a1a
# ╟─cfca2636-7ad4-11ec-0b03-2d4a0495db36
# ╠═cfeb5c0a-7ad4-11ec-1bf3-4f48a6f38a3b
# ╟─cfeb6128-7ad4-11ec-249f-f9893df219c0
# ╟─cff0569c-7ad4-11ec-35a2-11abcbca2d55
# ╟─cff2a032-7ad4-11ec-0a61-7dc549aea064
# ╟─cff48ee2-7ad4-11ec-2655-e367c71aa587
# ╟─cff48f3c-7ad4-11ec-1657-d554f776531b
# ╟─cff48f64-7ad4-11ec-0216-c5f4847d71c2
# ╟─cff680c6-7ad4-11ec-0a80-8d881050e190
# ╟─cffe0094-7ad4-11ec-06e4-058e2b3fd2da
# ╠═cffe243e-7ad4-11ec-389f-59b0050bf4eb
# ╟─cffe24ca-7ad4-11ec-2200-e1037e303032
# ╠═cffe2bdc-7ad4-11ec-18c2-89af9cd96cd7
# ╟─cffe2c22-7ad4-11ec-1fb4-63de8f11d9ff
# ╠═cffe3140-7ad4-11ec-1ca2-8bd1049bb2b9
# ╟─cffe315e-7ad4-11ec-22fc-b9797b5b47dd
# ╠═cffe36a4-7ad4-11ec-0ef6-15ffd9b07ddb
# ╟─cffe36cc-7ad4-11ec-2ace-531b9e6af7e1
# ╟─cffe36e0-7ad4-11ec-31a5-c17afb187647
# ╠═cffe3b36-7ad4-11ec-35f6-edfb20cddfcd
# ╟─cffe3b54-7ad4-11ec-1a78-9f9da89528e7
# ╠═cffe404c-7ad4-11ec-1f9f-bfed08d99c46
# ╟─cffe4090-7ad4-11ec-3a7c-33d923c0d940
# ╟─cfff481e-7ad4-11ec-31f8-13aa1ce5e8f0
# ╠═cfff508e-7ad4-11ec-226d-89d6be122407
# ╟─cfff50c0-7ad4-11ec-1560-8d6f692e5169
# ╠═cfff54ee-7ad4-11ec-1fc2-fb29b0f70b2a
# ╟─cfff5520-7ad4-11ec-2829-49b1f341ab05
# ╠═cfff57c8-7ad4-11ec-1a79-f5c64c0bee83
# ╟─cfff57e6-7ad4-11ec-280b-5d12d8b1f778
# ╠═cfff59be-7ad4-11ec-099b-a38c8b0a40fc
# ╟─cfff59f0-7ad4-11ec-2546-3fbce6dea1d7
# ╟─cfff5a0c-7ad4-11ec-22ea-71cfb567e250
# ╟─d0021d0a-7ad4-11ec-3154-9715dcc29351
# ╟─d0021dc6-7ad4-11ec-3537-516f1ae24266
# ╟─d0021e04-7ad4-11ec-1c26-0f208206e36e
# ╟─d0021e40-7ad4-11ec-31b6-4f6fb53a125f
# ╟─d0021e72-7ad4-11ec-034e-fbbbe8ae064f
# ╠═d002253e-7ad4-11ec-21c2-718848156e6c
# ╠═d0022dea-7ad4-11ec-1714-4d80adf6a555
# ╟─d0022e1c-7ad4-11ec-2e1b-11d66abecdd4
# ╟─d00235b0-7ad4-11ec-1c47-fd502591d1b8
# ╟─d002363c-7ad4-11ec-1c96-bd5be5ab3546
# ╟─d0023652-7ad4-11ec-1f52-15bdd9445a95
# ╠═d0023e52-7ad4-11ec-009c-2f2ceb368944
# ╟─d0023eca-7ad4-11ec-1802-09977aae2623
# ╠═d002435c-7ad4-11ec-3ecc-2f1bcd4252e1
# ╟─d0024384-7ad4-11ec-22e9-bb2093ce2b92
# ╟─d00243ac-7ad4-11ec-18c0-1dcb5f73c2fa
# ╟─d00243d4-7ad4-11ec-15a4-4745cd696d6d
# ╠═d0024618-7ad4-11ec-02df-d756524bcc1a
# ╟─d004fe1c-7ad4-11ec-3a9a-5bc1fc576687
# ╟─d004feda-7ad4-11ec-21bb-1df57b2fbadd
# ╠═d005092a-7ad4-11ec-0db7-4d8ca320cede
# ╟─d0050952-7ad4-11ec-272a-85317095a7a9
# ╟─d005098e-7ad4-11ec-18b2-77d74045fe71
# ╟─d00509ca-7ad4-11ec-15fd-cdf9f667934b
# ╠═d005112c-7ad4-11ec-290e-e997af9adb52
# ╟─d005114c-7ad4-11ec-00e2-b1e8470c449c
# ╠═d0051854-7ad4-11ec-0743-7df8f68d0977
# ╟─d007f782-7ad4-11ec-2af1-8d4d0f0ea4e4
# ╟─d007ff18-7ad4-11ec-15ba-f3ca8f9dce45
# ╟─d007ff9a-7ad4-11ec-2a24-89ed3b8c64fa
# ╟─d009a142-7ad4-11ec-005d-e13673223724
# ╠═d009a7dc-7ad4-11ec-3dc5-3f56f8949f40
# ╟─d009a822-7ad4-11ec-0032-1bfc51941151
# ╠═d009adae-7ad4-11ec-1c96-95ece3e6ee18
# ╟─d00aed4a-7ad4-11ec-2e0d-37b5dee8fae7
# ╟─d00aedea-7ad4-11ec-3f5c-e34439205bed
# ╠═d00af1d2-7ad4-11ec-0c74-79cfce44e5bc
# ╟─d00af1f0-7ad4-11ec-23bb-c3fed870d80d
# ╟─d00af218-7ad4-11ec-336c-eb9a5b82f7d6
# ╠═d00af9b6-7ad4-11ec-149c-3bdd2e190f14
# ╟─d00af9fc-7ad4-11ec-11a6-77a4b62126c3
# ╟─d00afa42-7ad4-11ec-1046-97d2bef4c935
# ╠═d00afff6-7ad4-11ec-3088-2bf41907b884
# ╟─d00b0028-7ad4-11ec-3338-13a80d1521ad
# ╠═d00b087a-7ad4-11ec-2a66-ebba5b52fd00
# ╟─d00b08b6-7ad4-11ec-1907-d194aa19090a
# ╟─d00b08e8-7ad4-11ec-19d2-73f717af0148
# ╟─d00b091a-7ad4-11ec-3eb1-4d2e1e6823ee
# ╠═d00b2dbe-7ad4-11ec-11be-b5f4c1c5dc4f
# ╟─d00b2dfc-7ad4-11ec-1ec2-89afbd1afd8d
# ╟─d00b2e0e-7ad4-11ec-2268-27892408e91b
# ╟─d00b2e40-7ad4-11ec-077f-4965ddeb949c
# ╟─d00b3372-7ad4-11ec-3a64-f3e47e8b28b4
# ╟─d00b3390-7ad4-11ec-3344-fdfb82991dad
# ╟─d00b33a4-7ad4-11ec-1a72-57210ce78749
# ╟─d00b33b8-7ad4-11ec-35eb-e3054d628f7a
# ╟─d00b33c2-7ad4-11ec-2599-e1c0a40bd78a
# ╟─d00b3818-7ad4-11ec-3dac-d57f737137a8
# ╟─d00b382c-7ad4-11ec-2de1-6b05b5cb1e9a
# ╟─d00b385e-7ad4-11ec-1de8-c321b33b0ea7
# ╠═d00b431c-7ad4-11ec-0bdc-b7595450e350
# ╟─d00b4342-7ad4-11ec-2160-e13f564c7812
# ╠═d00b4c0e-7ad4-11ec-3ebf-e32b1cf41ff6
# ╟─d00b4c2c-7ad4-11ec-3218-3d7aa4169c21
# ╟─d00b4c5e-7ad4-11ec-1881-4197f6b43f61
# ╟─d00b4c90-7ad4-11ec-1a13-39c6c745ef16
# ╟─d0127010-7ad4-11ec-3fcd-c3d9d1ac8093
# ╟─d012706a-7ad4-11ec-03d8-1d1da568d38d
# ╟─d0127100-7ad4-11ec-2213-dbe7d298fa35
# ╟─d0127150-7ad4-11ec-0e10-2fb93cd46438
# ╟─d0127164-7ad4-11ec-16c0-a97a17b977cf
# ╟─d0127196-7ad4-11ec-29b6-49977a12696d
# ╟─d01271be-7ad4-11ec-2553-2b24f873aaa2
# ╟─d01271d2-7ad4-11ec-0ce6-81996090f49a
# ╟─d01271fc-7ad4-11ec-33b5-2147dd500fe5
# ╟─d0127236-7ad4-11ec-1c89-27ecef765cbf
# ╟─d0127254-7ad4-11ec-3f5e-2b3892ff500f
# ╟─d0127268-7ad4-11ec-147e-a7b4a9cde70e
# ╟─d012727c-7ad4-11ec-24b2-634d9c610fc6
# ╟─d012729a-7ad4-11ec-15c5-bd697b403a84
# ╟─d01272c0-7ad4-11ec-3708-215fe1eff3cd
# ╟─d01272e0-7ad4-11ec-0c6f-135b42c15afa
# ╠═d0127e02-7ad4-11ec-0e61-5757c8c1531b
# ╟─d0127e48-7ad4-11ec-0a20-f96255b20c4d
# ╟─d0127e5c-7ad4-11ec-3325-8d97e0554290
# ╠═d01284d8-7ad4-11ec-05ad-dffee3115b72
# ╟─d01284f6-7ad4-11ec-091a-5dad7aeda9cc
# ╟─d0128516-7ad4-11ec-2643-dbbcf602b536
# ╟─d012853c-7ad4-11ec-2b71-0bfbbcf18250
# ╟─d0128564-7ad4-11ec-2bc1-310380cb3358
# ╟─d0128582-7ad4-11ec-0fe3-2f808e19b148
# ╟─d0128596-7ad4-11ec-1674-631a6499a84b
# ╟─d01285b4-7ad4-11ec-041d-4b42831ccbd6
# ╟─d01285c8-7ad4-11ec-2415-a53531a904b7
# ╟─d01285e6-7ad4-11ec-382c-3599d6db6e1f
# ╟─d01285f0-7ad4-11ec-3144-9daefd1e2479
# ╟─d0128604-7ad4-11ec-3656-59c3b7036638
# ╟─d012860e-7ad4-11ec-28b4-4fc172cce58c
# ╟─d0128622-7ad4-11ec-1858-095d51fa5d1a
# ╟─d0128636-7ad4-11ec-385b-adf05a1e4749
# ╟─d012864a-7ad4-11ec-2233-a50217c8b2be
# ╟─d012865e-7ad4-11ec-0a87-b561519061f0
# ╟─d0128668-7ad4-11ec-1c7a-65aef0b7a862
# ╟─d012867e-7ad4-11ec-18fc-43000c60bc48
# ╟─d0128686-7ad4-11ec-2fe1-6f1c6de01248
# ╟─d012869a-7ad4-11ec-23f0-f533d0737672
# ╟─d01286a4-7ad4-11ec-3bbf-b554dbc4564a
# ╟─d01286b0-7ad4-11ec-3dfa-bb829d94d2e2
# ╟─d01286c2-7ad4-11ec-2fa4-615001292373
# ╟─d01286de-7ad4-11ec-140d-81c17b62bfde
# ╟─d01286fe-7ad4-11ec-24f0-654d58399974
# ╟─d0128710-7ad4-11ec-3997-d379eef6e22c
# ╠═d0128d7a-7ad4-11ec-28a6-c19a170d11d3
# ╟─d0128da2-7ad4-11ec-195f-c5907021133b
# ╠═d012934c-7ad4-11ec-2397-ef9421aebe8b
# ╟─d0129392-7ad4-11ec-30db-33dd64d91c05
# ╟─d01293b0-7ad4-11ec-089b-5f7bc0628ff2
# ╟─d01293ce-7ad4-11ec-070e-e3a62662b410
# ╟─d0129400-7ad4-11ec-2858-7167e32ee5f2
# ╟─d012940a-7ad4-11ec-0c24-d7693ecd41a0
# ╠═d0129932-7ad4-11ec-0e53-09ce45752c95
# ╟─d0129950-7ad4-11ec-2218-1b9022410d62
# ╟─d0129978-7ad4-11ec-2acf-9bcb681e0d70
# ╠═d0129dba-7ad4-11ec-205b-3db3d6581e03
# ╟─d0129dd8-7ad4-11ec-2a77-69cd301dd635
# ╟─d0129df6-7ad4-11ec-15f0-25df39675a32
# ╠═d012a364-7ad4-11ec-3248-35742771833b
# ╟─d012a396-7ad4-11ec-20c6-27d6218a5f7a
# ╠═d012a85a-7ad4-11ec-17ad-43f9f7b72a1f
# ╟─d012c178-7ad4-11ec-1db1-7d764919f97e
# ╟─d015a50a-7ad4-11ec-06b7-3785f50e80ad
# ╟─d015a594-7ad4-11ec-3952-83f08d757d56
# ╠═d015ad48-7ad4-11ec-0f61-5719ea43732f
# ╟─d015ad6e-7ad4-11ec-1a49-bd334de85b2e
# ╠═d015b340-7ad4-11ec-3698-333a6f5f3bc3
# ╟─d015b356-7ad4-11ec-0241-9bc233c4e8c3
# ╠═d015b778-7ad4-11ec-1ae2-79e09bba4281
# ╟─d015b78e-7ad4-11ec-0da5-750110be3351
# ╠═d015ba5e-7ad4-11ec-0969-493f15ec0e05
# ╟─d015ba72-7ad4-11ec-346a-f3bd22c1671c
# ╠═d015bd06-7ad4-11ec-13c0-272cb6df2c49
# ╟─d015bd24-7ad4-11ec-3cf7-3d98b122f2df
# ╠═d015c1b6-7ad4-11ec-18c1-3de2d70a1817
# ╟─d015c1f0-7ad4-11ec-20b3-837281669859
# ╟─d015c21a-7ad4-11ec-3d07-07faaf57dec1
# ╠═d015c44a-7ad4-11ec-21e9-d5b385671bf9
# ╟─d015c468-7ad4-11ec-0652-ffac4858f22b
# ╠═d015c788-7ad4-11ec-2c48-df720a4a6900
# ╟─d015c7c2-7ad4-11ec-32b8-1fd555fc3df4
# ╟─d015c83c-7ad4-11ec-02f9-4f768c5fd4f6
# ╟─d015c86e-7ad4-11ec-0ecd-29ddf4e0e286
# ╟─d015c882-7ad4-11ec-2817-e94081af7a9a
# ╟─d015c8ca-7ad4-11ec-37af-47ac61e7a941
# ╟─d015c8f0-7ad4-11ec-3c17-210bf23f84e7
# ╟─d015c904-7ad4-11ec-2b01-91c1dc6ecbe3
# ╠═d015cfee-7ad4-11ec-05a7-f126f4fd58ba
# ╟─d015d02a-7ad4-11ec-2f81-a14132dbb1d2
# ╟─d015d052-7ad4-11ec-17b4-e1747ea191b4
# ╟─d015d07a-7ad4-11ec-0903-899a81e3ac19
# ╟─d015d08e-7ad4-11ec-1081-a395918ddb82
# ╟─d015d0b6-7ad4-11ec-0a66-45fdb61c12e6
# ╟─d015d0ca-7ad4-11ec-3f3c-a3655b8631dc
# ╟─d015d0d6-7ad4-11ec-2e35-6f327778c387
# ╟─d015d0e8-7ad4-11ec-0d7f-a180ef80f938
# ╟─d015d0fc-7ad4-11ec-13ee-0df3593e5717
# ╟─d015d11a-7ad4-11ec-12e9-1f034932444f
# ╟─d015d124-7ad4-11ec-3439-33fb1bc27b5f
# ╟─d015d136-7ad4-11ec-182a-6de34e9f4625
# ╟─d015d142-7ad4-11ec-3159-735a33dcfa35
# ╟─d0176f0c-7ad4-11ec-0c75-258fdd944c3d
# ╟─d0176f66-7ad4-11ec-153c-49677246653a
# ╟─d0176f8c-7ad4-11ec-1479-59ed6b916abc
# ╟─d0176fa2-7ad4-11ec-1b41-694aa42d0c68
# ╟─d0176fbe-7ad4-11ec-0d3a-a11578f9b8ef
# ╟─d0176ff2-7ad4-11ec-0b76-af1ce6194635
# ╟─d01770c2-7ad4-11ec-0395-f1717b00b98b
# ╟─d01770e2-7ad4-11ec-3959-d10129cbc26e
# ╟─d01770f4-7ad4-11ec-0061-0b3c28d727bb
# ╟─d017710a-7ad4-11ec-3a67-fdd8dc986b1c
# ╟─d0177132-7ad4-11ec-02a0-0df1d376e827
# ╟─d017715a-7ad4-11ec-109b-b71cf7b989a3
# ╠═d0177ae2-7ad4-11ec-00b4-03d396f9080f
# ╠═d01783fc-7ad4-11ec-33e7-1f5cb436f359
# ╟─d0178438-7ad4-11ec-38d5-1dc082219db0
# ╠═d0178a00-7ad4-11ec-3f58-c53bd8fcff4d
# ╟─d0178a28-7ad4-11ec-2a03-257ce8f4801b
# ╠═d0178e8a-7ad4-11ec-1cf5-9510716e567b
# ╟─d0178ea6-7ad4-11ec-1d60-eddb7dc65094
# ╠═d017911c-7ad4-11ec-0ded-d15fadcc321a
# ╟─d017913a-7ad4-11ec-3b4d-352acc9c3365
# ╟─d017914e-7ad4-11ec-0b22-3f9861b28ee8
# ╟─d0179ba8-7ad4-11ec-0aff-9fcb4d16660c
# ╟─d017a5bc-7ad4-11ec-081c-59831fac475b
# ╟─d017a5ee-7ad4-11ec-1894-f19d03cbec3a
# ╟─d017a634-7ad4-11ec-356e-a3e792965c89
# ╠═d017acf6-7ad4-11ec-2a01-137da9369170
# ╟─d017ad32-7ad4-11ec-3742-3346529f2250
# ╠═d017b110-7ad4-11ec-3621-17766988d320
# ╟─d017b124-7ad4-11ec-0027-41ddb2cf31dd
# ╟─d017b14a-7ad4-11ec-30b7-69b80cd54d2c
# ╠═d017b7d2-7ad4-11ec-3c1f-bf1f29a224ed
# ╠═d017bfe8-7ad4-11ec-156e-c96d2fb83a99
# ╠═d017c56c-7ad4-11ec-08f9-e7d560dc5651
# ╟─d017c59e-7ad4-11ec-04ec-ef2fb65613b9
# ╠═d017cb32-7ad4-11ec-04b2-27180b3729f9
# ╟─d017cb46-7ad4-11ec-21be-e944252952d8
# ╟─d017cb82-7ad4-11ec-2470-734bd1822a48
# ╟─d017cbaa-7ad4-11ec-1bcb-f7e3442bfb00
# ╟─d017cbc8-7ad4-11ec-0b2a-172413d219ac
# ╟─d017cbdc-7ad4-11ec-3ae0-571e326c9ced
# ╟─d017cc04-7ad4-11ec-0dc9-45e2d70b3f47
# ╟─d017cc18-7ad4-11ec-1fca-e7584e84e694
# ╟─d017cc4a-7ad4-11ec-1267-3b18720136c1
# ╟─d017cc5e-7ad4-11ec-2153-31bf3ca6da09
# ╟─d017cc86-7ad4-11ec-2faf-2705f52f599b
# ╟─d017cca2-7ad4-11ec-197f-f342b6b5473c
# ╟─d017ccb8-7ad4-11ec-1fa9-59a9762fac47
# ╟─d017d2ee-7ad4-11ec-0c63-897932a2162c
# ╟─d017d320-7ad4-11ec-06c8-83289855df83
# ╟─d017d918-7ad4-11ec-39f9-31323f482180
# ╟─d017d94a-7ad4-11ec-2333-e51d63a38462
# ╟─d017d96a-7ad4-11ec-1af2-01a914edd576
# ╟─d017d97e-7ad4-11ec-29c9-5db69983ffaf
# ╟─d017d992-7ad4-11ec-18ed-e9844b491ec2
# ╟─d017d9a6-7ad4-11ec-3523-6fed18c5b55e
# ╟─d017d9c4-7ad4-11ec-3b30-15aeb9469c22
# ╟─d017d9d8-7ad4-11ec-2d9d-61290dbab802
# ╟─d017d9e2-7ad4-11ec-0672-9570c06a50db
# ╟─d017d9f6-7ad4-11ec-1542-7759ba7a5e88
# ╟─d017da14-7ad4-11ec-3e18-015816b5168a
# ╠═d017e11c-7ad4-11ec-2239-41a656578e95
# ╟─d017e14e-7ad4-11ec-1c68-058d02d6f4bf
# ╟─d017e162-7ad4-11ec-2ff7-7bc46f4b2888
# ╟─d017ea90-7ad4-11ec-0534-3ba7c21c2f32
# ╟─d017eaf4-7ad4-11ec-14eb-f557da3ca002
# ╟─d017eb44-7ad4-11ec-09f7-f93fdc9df471
# ╟─d017eb62-7ad4-11ec-1a39-1bcb6ebf4986
# ╟─d017eba0-7ad4-11ec-2f67-8dc0f06ceed0
# ╟─d017ebd2-7ad4-11ec-128c-51796f65f160
# ╟─d017ebee-7ad4-11ec-27f3-1387a4a38deb
# ╟─d017ec20-7ad4-11ec-3d84-076ee84281f8
# ╟─d017ec32-7ad4-11ec-3ebd-8b0d0b453d46
# ╟─d017ec52-7ad4-11ec-2656-d74879c8c540
# ╟─d017ec84-7ad4-11ec-3cf0-533ce369da57
# ╟─d017ecc0-7ad4-11ec-0df9-f78bae93ef71
# ╟─d017ed10-7ad4-11ec-3f21-8f178f4a1f9e
# ╟─d017ed24-7ad4-11ec-21a9-fbf48151d18e
# ╟─d017ed60-7ad4-11ec-3de9-39130c15f6f6
# ╟─d017eda6-7ad4-11ec-1524-890e09b045a9
# ╟─d017edc4-7ad4-11ec-3f8e-fb7e36d2aeff
# ╟─d017edd8-7ad4-11ec-214f-b1eb5335a1af
# ╟─d017edec-7ad4-11ec-258b-c73dd7e778fb
# ╟─d017ee00-7ad4-11ec-1e80-79a94c690c8e
# ╟─d017ee28-7ad4-11ec-3988-434eca77fc08
# ╟─d017ee70-7ad4-11ec-1375-6100a9395813
# ╟─d017eec8-7ad4-11ec-105f-a5aa4d74436c
# ╟─d017eedc-7ad4-11ec-235d-5581640ace0b
# ╟─d017ef02-7ad4-11ec-19c7-b3ab8f45575e
# ╟─d017ef54-7ad4-11ec-019b-7d4db4bafd16
# ╟─d017ef72-7ad4-11ec-2eeb-5389bb88402e
# ╟─d017ef86-7ad4-11ec-20cb-1dc31f1ebc4b
# ╟─d017efa6-7ad4-11ec-038f-937c3801f318
# ╟─d017f012-7ad4-11ec-3b80-077f21672247
# ╟─d017f030-7ad4-11ec-1a4f-2dd56db4d0cc
# ╟─d017f04e-7ad4-11ec-2a33-f9e2829d6290
# ╟─d017f062-7ad4-11ec-2907-2db4ac21f2fe
# ╟─d017f076-7ad4-11ec-3939-efac5922d1ca
# ╟─d017f0b2-7ad4-11ec-0edd-cd44c4a2914f
# ╟─d017f0c6-7ad4-11ec-0989-3bbb5a4f178f
# ╟─d017f0f8-7ad4-11ec-3307-ed4e1f2edeec
# ╟─d017f120-7ad4-11ec-08b2-fb3c1b60c510
# ╟─d017f140-7ad4-11ec-20c8-9f3c9620724e
# ╟─d017f15c-7ad4-11ec-0bf0-9d0d865d2cb9
# ╟─d017f198-7ad4-11ec-316e-01899edf2196
# ╟─d017f1e8-7ad4-11ec-2a61-f57e07b8468b
# ╟─d017f210-7ad4-11ec-3956-bb17307ea397
# ╟─d017f242-7ad4-11ec-0b5f-515865f2a39a
# ╟─d017f260-7ad4-11ec-17ad-e3265607b0cc
# ╟─d017f276-7ad4-11ec-27fe-a3576e7a27c9
# ╠═d017f8b4-7ad4-11ec-0b19-61c031b042c0
# ╟─d017f9f4-7ad4-11ec-3263-d7f9d41e77cf
# ╟─d017fa4e-7ad4-11ec-1196-5dcd1cf64244
# ╟─d017fb70-7ad4-11ec-2389-e923ef51b7cf
# ╟─d017fbb6-7ad4-11ec-17ba-1543b739b117
# ╟─d017fbde-7ad4-11ec-315f-e90993b7fb13
# ╟─d017fbf2-7ad4-11ec-04d8-33f32519216f
# ╟─d017fc1c-7ad4-11ec-26ea-bfcc7bbf9773
# ╟─d017fc56-7ad4-11ec-00f2-d3e1cd384ba7
# ╟─d017fc74-7ad4-11ec-1268-c9df6abf02fb
# ╟─d017fc9c-7ad4-11ec-3b74-d92afd6ca8be
# ╠═d017fee0-7ad4-11ec-16dc-31eb02a54841
# ╠═d01802fa-7ad4-11ec-3eb7-8304f93bcc83
# ╟─d018035e-7ad4-11ec-179b-893c8114837d
# ╟─d018039a-7ad4-11ec-0972-8da3ac06e556
# ╠═d0180a0c-7ad4-11ec-088e-1b34a3835470
# ╟─d0180a48-7ad4-11ec-3e78-3b52cad3de13
# ╟─d01ab126-7ad4-11ec-2ad2-194396565a74
# ╟─d01ab1b2-7ad4-11ec-121a-f5d65a04fb26
# ╟─d01abcf2-7ad4-11ec-19bb-d92598b7fbf2
# ╟─d01abd2e-7ad4-11ec-1537-870228140ec6
# ╟─d01ac31e-7ad4-11ec-1cba-1b10ab8c5fa0
# ╟─d01ac350-7ad4-11ec-2518-27259d7a0896
# ╟─d01aca2e-7ad4-11ec-1994-4fc17b3b4a3f
# ╟─d01aca60-7ad4-11ec-0a29-cbdbd6d9326a
# ╟─d01ad446-7ad4-11ec-09d2-a1dc9f669ff9
# ╟─d01ad494-7ad4-11ec-1518-ad577914f31f
# ╟─d01ad8fe-7ad4-11ec-2bf8-c7b4c56ec283
# ╟─d01ad91c-7ad4-11ec-23a5-4f3513d1b0cd
# ╟─d01ae5b0-7ad4-11ec-287e-b14a9e15c913
# ╟─d01ae5ec-7ad4-11ec-30e0-27d243dab4c7
# ╟─d01aedee-7ad4-11ec-1414-653e29712551
# ╟─d01aee20-7ad4-11ec-0c57-256642abc198
# ╟─d01aee34-7ad4-11ec-0dc3-79bba9eccbab
# ╟─d01af3c0-7ad4-11ec-1c87-21efbf65e04d
# ╟─d01af3de-7ad4-11ec-0f58-03454dd559ef
# ╟─d01afce4-7ad4-11ec-1ab8-15c0fd6831ca
# ╟─d01afcf8-7ad4-11ec-0e85-4ba20d3ae836
# ╟─d01aff1e-7ad4-11ec-0fae-0d0a5408a4d8
# ╟─d01aff32-7ad4-11ec-1fa4-295ae0d6d835
# ╟─d01b00d6-7ad4-11ec-179c-5d8f1d4757ba
# ╟─d01b00f4-7ad4-11ec-1d9c-bf390486a327
# ╟─d01b0130-7ad4-11ec-10c7-d780804086c5
# ╟─d01b05cc-7ad4-11ec-29f8-3f0c270f020a
# ╟─d01b05ec-7ad4-11ec-35b8-570e5af3e01a
# ╟─d01b05fe-7ad4-11ec-2adb-2993a5de33bd
# ╟─d01b0e64-7ad4-11ec-222a-1f594609d01a
# ╟─d01b0e78-7ad4-11ec-3d34-731deddccb91
# ╟─d01b1906-7ad4-11ec-1603-83d6f31120e2
# ╟─d01b192c-7ad4-11ec-0ca2-db96773e2ddd
# ╟─d01b2188-7ad4-11ec-08c9-f7fd17e47069
# ╟─d01b219c-7ad4-11ec-0927-e1c0c47f1a72
# ╟─d01b21ce-7ad4-11ec-0be1-977dc60bcff7
# ╟─d01b2200-7ad4-11ec-10ba-0fb3fd4f1d22
# ╟─d01b2232-7ad4-11ec-2f30-cd04e3547943
# ╟─d01b2d5e-7ad4-11ec-20d7-915e8f701202
# ╟─d01b2d90-7ad4-11ec-2153-bf1221b97ff4
# ╟─d01b2dba-7ad4-11ec-10f3-131f73cfb803
# ╟─d01b2dcc-7ad4-11ec-14e7-4b86cab0d799
# ╟─d01b302e-7ad4-11ec-29db-b3bd984fabda
# ╟─d01b3058-7ad4-11ec-2aaf-ef6ef94d970b
# ╟─d01b3268-7ad4-11ec-35e0-f9f58e0041f1
# ╟─d01b329a-7ad4-11ec-1b95-43ba6015ce81
# ╟─d01b345e-7ad4-11ec-0b56-a7879653a245
# ╟─d01b3470-7ad4-11ec-3381-5f423306e8d6
# ╟─d01b3490-7ad4-11ec-3b87-9d83f7963fed
# ╟─d01b3498-7ad4-11ec-011b-7b69c5976c73
# ╟─d01b3f38-7ad4-11ec-17b8-2b7ad64a330b
# ╟─d01b3f56-7ad4-11ec-379e-05b95d747597
# ╟─d01b4ae6-7ad4-11ec-2aa9-75e928eb689d
# ╟─d01b4b04-7ad4-11ec-0325-dfd7864ddd2b
# ╟─d01b4b5e-7ad4-11ec-2fff-d5803292398d
# ╟─d01b4b72-7ad4-11ec-32a4-bb64f2912ec2
# ╟─d01b5194-7ad4-11ec-3a70-87b930505bfa
# ╟─d01b51b0-7ad4-11ec-298a-75ae76e4457d
# ╟─d01b578e-7ad4-11ec-2698-37d219230490
# ╟─d01b57ac-7ad4-11ec-19ac-3d1e01f582ee
# ╟─d01b57ca-7ad4-11ec-3280-956788ed5d19
# ╟─d01b57f4-7ad4-11ec-02c2-ad6c1cfb6810
# ╟─d01b5da6-7ad4-11ec-21ed-31b0ae47679c
# ╟─d01b5dc6-7ad4-11ec-2ea3-475fdb18d5c7
# ╟─d01b6382-7ad4-11ec-25f7-dd92648d1586
# ╟─d01b63b4-7ad4-11ec-3770-53bfa6e798e1
# ╟─d01b6c04-7ad4-11ec-1a53-f9726bf17456
# ╟─d01b6c42-7ad4-11ec-0a36-c3ce512a37fb
# ╟─d01b6c56-7ad4-11ec-127c-2544e2d6f0b9
# ╟─d01b708e-7ad4-11ec-1918-9797dbb7252b
# ╟─d01b70b6-7ad4-11ec-1803-bdf73ac883e2
# ╟─d01b70ca-7ad4-11ec-01d1-1baa93e0b119
# ╟─d01b70e0-7ad4-11ec-1e26-4f2743256a84
# ╟─d01b7840-7ad4-11ec-123b-b9183dd0b1fc
# ╟─d01b787a-7ad4-11ec-1b10-8948d99a0ec0
# ╟─d01b7f8e-7ad4-11ec-277b-abd9cd473e2f
# ╟─d01b7fac-7ad4-11ec-3ab9-7be84dd56ac9
# ╟─d01b8844-7ad4-11ec-1ffe-bb321207c0bc
# ╟─d01b886c-7ad4-11ec-1fea-450ee0bded92
# ╟─d01b964a-7ad4-11ec-326c-01cfe9be3a59
# ╟─d01b9670-7ad4-11ec-2297-cf1551dadcb5
# ╟─d01ba2fc-7ad4-11ec-344d-d183966f88b6
# ╟─d01ba318-7ad4-11ec-2231-3dec3f4ac743
# ╟─d01ba338-7ad4-11ec-0d04-d73afa2d8052
# ╟─d01ba37e-7ad4-11ec-129e-5d7851d7b8d2
# ╟─d01ba392-7ad4-11ec-347f-bfc00ed1865e
# ╟─d01bad30-7ad4-11ec-1791-1b017d022a44
# ╟─d01bad7e-7ad4-11ec-3cea-7bbbe4614210
# ╟─d01bb774-7ad4-11ec-20ba-8953162cd988
# ╟─d01bb792-7ad4-11ec-0a0d-9dad8aab24b9
# ╟─d01bb7ba-7ad4-11ec-357b-67ca025e6968
# ╟─d01bc502-7ad4-11ec-239f-83ade3f2d328
# ╟─d01bc520-7ad4-11ec-0c3e-f1245a8d1b6f
# ╟─d01bc546-7ad4-11ec-3e11-df6530e8af58
# ╟─d01bcc00-7ad4-11ec-3717-1ffda5546988
# ╟─d01bcc14-7ad4-11ec-26aa-ef0489761118
# ╟─d01bcc50-7ad4-11ec-2349-cbc748d9fd16
# ╟─d01bcc64-7ad4-11ec-1d31-970d4681e123
# ╟─d01bd6be-7ad4-11ec-1854-411d42231275
# ╟─d01bd704-7ad4-11ec-05b7-7725dbe493fe
# ╟─d01bdec0-7ad4-11ec-1c97-7d83318cde47
# ╟─d01bdee8-7ad4-11ec-1005-472001cecb23
# ╟─d01beaaa-7ad4-11ec-298a-0911f815120e
# ╟─d01beac8-7ad4-11ec-2eeb-6929ff3433e0
# ╟─d01beadc-7ad4-11ec-0fb0-fbc479d3e031
# ╟─d01beaf0-7ad4-11ec-14f7-313d1a154b0a
# ╟─d01bf130-7ad4-11ec-0348-3d8ba81e6590
# ╟─d01bf7fc-7ad4-11ec-182c-f9d1a3aaf46e
# ╟─d01bf822-7ad4-11ec-1a47-c57a03aa87ef
# ╟─d01bfe82-7ad4-11ec-0454-4b4527dc9d29
# ╟─d01c054e-7ad4-11ec-00b2-dd0121c172ae
# ╟─d01c056a-7ad4-11ec-22df-17ad39d13058
# ╟─d01c0594-7ad4-11ec-0a78-4543a36c3be1
# ╟─d01c05b2-7ad4-11ec-010d-cd46db6d139d
# ╟─d01c05c6-7ad4-11ec-2038-e9976b9f4cac
# ╟─d01c05e4-7ad4-11ec-1eef-630a3892bdda
# ╟─d01c062a-7ad4-11ec-21d8-736fbcd580cd
# ╟─d01c0652-7ad4-11ec-2a01-f97de42ab5b2
# ╟─d01c125a-7ad4-11ec-2868-d72377fdb0ff
# ╟─d01c128c-7ad4-11ec-2166-13b3c0cadc19
# ╟─d01c1ade-7ad4-11ec-0617-5faf8023cbf5
# ╟─d01c1b06-7ad4-11ec-35a8-fb18e756d713
# ╟─d01c1b2e-7ad4-11ec-242e-553f5c891080
# ╟─d01c4de2-7ad4-11ec-0979-fbce3e36e72d
# ╟─d01c4e30-7ad4-11ec-0151-b15f2220a1d9
# ╟─d01c4e6e-7ad4-11ec-3bc8-8549e22811e8
# ╟─d01c4e8c-7ad4-11ec-0ad3-37e29913f251
# ╟─d01c57b0-7ad4-11ec-3717-df4290df7994
# ╟─d01c57ce-7ad4-11ec-0ed0-7fb5b48d064d
# ╟─d01c57ec-7ad4-11ec-20d7-d92bc91fe216
# ╟─d01c5808-7ad4-11ec-09ad-697f0f4e0c28
# ╟─d01c5814-7ad4-11ec-2772-63860b56107a
# ╟─d01c5828-7ad4-11ec-0053-eb8e68c0953e
# ╟─d01c5832-7ad4-11ec-38db-d133a3306bbe
# ╟─d01c5846-7ad4-11ec-1327-599c175ebe58
# ╟─d01c5864-7ad4-11ec-0777-d302a64e754c
# ╟─d01c5ce4-7ad4-11ec-0e1e-3bb365ae6d1d
# ╟─d01c5d0a-7ad4-11ec-06c6-2b19fdce639b
# ╟─d01c60ca-7ad4-11ec-1e36-257e5eb602e9
# ╟─d01c6106-7ad4-11ec-36e6-0d129c2c7a71
# ╟─d01c6f7a-7ad4-11ec-054a-f70577afcfeb
# ╟─d01c6f98-7ad4-11ec-3708-2b7cee3a45e3
# ╟─d01db9dc-7ad4-11ec-001a-c9e22b71491f
# ╟─d01dba42-7ad4-11ec-00f8-876d272c5064
# ╠═d01dc350-7ad4-11ec-2f08-3746efed04f4
# ╟─d01dc370-7ad4-11ec-1721-0fd38cde2562
# ╟─d01dc582-7ad4-11ec-0611-a5e8e9801641
# ╟─d01dc5a0-7ad4-11ec-2e1f-b734060af4ac
# ╟─d01dc776-7ad4-11ec-2ff5-e977cb8e2432
# ╟─d01dc79e-7ad4-11ec-158d-e3839603bb58
# ╟─d01dc7ba-7ad4-11ec-1746-c30814654d64
# ╟─d01dc7e4-7ad4-11ec-0dde-fbc99bea7327
# ╟─d01de5c6-7ad4-11ec-1b44-65215b7079d3
# ╟─d01de60c-7ad4-11ec-1493-2322627fc607
# ╟─d01de9c2-7ad4-11ec-398b-93314a625688
# ╟─d01de9e0-7ad4-11ec-0fc2-bb49de0fd96e
# ╟─d01ded82-7ad4-11ec-13b9-1bb93da8f2da
# ╟─d01dedaa-7ad4-11ec-2720-9b2c2c209778
# ╟─d01df106-7ad4-11ec-10bd-c73f4f586949
# ╟─d01df124-7ad4-11ec-11d6-37d6fda15d2e
# ╟─d01df142-7ad4-11ec-3081-7344a0df643d
# ╟─d01df14c-7ad4-11ec-1a31-d55c97b50c8a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
