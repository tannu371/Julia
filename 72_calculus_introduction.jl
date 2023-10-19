### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 5c08bfe2-c194-11ec-2b7e-1f00623582dd
using LinearAlgebra

# ╔═╡ 5c0d74d8-c194-11ec-27c7-c39ae0bc1949
using QuadGK, HCubature

# ╔═╡ 5c0ed90e-c194-11ec-17e8-8fa5611fcee2
using PlutoUI

# ╔═╡ 5c0ed896-c194-11ec-2cdf-536a73499a05
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 5c08b330-c194-11ec-2778-1f8492521842
md"""# Quick introduction to calculus with Julia
"""

# ╔═╡ 5c08b39e-c194-11ec-3353-b92659ab913a
md"""Julia can be downloaded and used like other programming languages.
"""

# ╔═╡ 5c08b416-c194-11ec-35d0-070fa57a6a22
md"""[launch binder](https://mybinder.org/v2/gh/CalculusWithJulia/CwJScratchPad.git/master)
"""

# ╔═╡ 5c08b48e-c194-11ec-3009-4dc6ad328c39
md"""Julia can be used through the internet for free using the [mybinder.org](https://mybinder.org) service. To do so, click on the `CalcululsWithJulia.ipynb` file after launching Binder by clicking on the badge.
"""

# ╔═╡ 5c08b4b4-c194-11ec-3ce8-391cd225ca86
md"""These notes are transitioning from HTML pages to Pluto HTML pages, meaning they can be downloaded and run as notebooks within Pluto. Pluto will handle the package management for add-on packages automatically, though `Pluto` itself must be installed. In a terminal session, the following commands will install `Pluto`:
"""

# ╔═╡ 5c08b574-c194-11ec-0919-977f053f5f98
md"""```
import Pkg
Pkg.add("Pluto")
```"""

# ╔═╡ 5c08b5d8-c194-11ec-3743-1d5619b107ce
md"""Installation happens once. Then each new *session*, `Pluto` must be loaded and run:
"""

# ╔═╡ 5c08b614-c194-11ec-2474-e7456f8af86b
md"""```
using Pluto
Pluto.run()
```"""

# ╔═╡ 5c08b646-c194-11ec-1f69-0512810dc2a9
md"""`Pluto` notebooks run in a web browser, the above command will open a landing page in the default browser.
"""

# ╔═╡ 5c08b68c-c194-11ec-14ca-af4ef355ed7c
md"""---
"""

# ╔═╡ 5c08bdd0-c194-11ec-3e34-639b51cc0c46
md"""Here are some `Julia` usages to create calculus objects.
"""

# ╔═╡ 5c08be02-c194-11ec-35cb-2b8646cd8c50
md"""The `Julia` packages loaded below are all loaded when the `CalculusWithJulia` package is loaded.
"""

# ╔═╡ 5c08be20-c194-11ec-2701-395d7574bbcc
md"""A `Julia` package is loaded with the `using` command:
"""

# ╔═╡ 5c08c01e-c194-11ec-2b1e-a9b75144f151
md"""The `LinearAlgebra` package comes with a `Julia` installation. Other packages can be added. Something like:
"""

# ╔═╡ 5c08c06e-c194-11ec-2571-cbd46d05e137
md"""```
using Pkg
Pkg.add("SomePackageName")
```"""

# ╔═╡ 5c08c082-c194-11ec-17da-2d6ec31879c6
md"""These notes have an accompanying package, `CalculusWithJulia`, that when installed, as above, also installs most of the necessary packages to perform the examples.
"""

# ╔═╡ 5c08c0a0-c194-11ec-383c-a54d50baf87d
md"""Packages need only be installed once, but they must be loaded into *each* session for which they will be used.
"""

# ╔═╡ 5c08c42c-c194-11ec-12a5-15276d7807ce
md"""Packages can also be loaded through `import PackageName`. Importing does not add the exported objects of a function into the namespace, so is used when there are possible name collisions.
"""

# ╔═╡ 5c08c460-c194-11ec-1fcd-5da7220a72dd
md"""## Types
"""

# ╔═╡ 5c08c4d8-c194-11ec-2d2a-9339b8986ab7
md"""Objects in `Julia` are "typed." Common numeric types are `Float64`, `Int64` for floating point numbers and integers. Less used here are types like `Rational{Int64}`,  specifying rational numbers with a numerator and denominator as `Int64`; or `Complex{Float64}`, specifying a comlex number with floating point components. Julia also has `BigFloat` and `BigInt` for arbitrary precision types. Typically, operations use "promotion" to ensure the combination of types is appropriate. Other useful types are `Function`, an abstract type describing functions; `Bool` for true and false values; `Sym` for symbolic values (through `SymPy`); and `Vector{Float64}` for vectors with floating point components.
"""

# ╔═╡ 5c08c4f6-c194-11ec-2b76-8304c6a64c8c
md"""For the most part the type will not be so important, but it is useful to know that for some function calls the  type of the argument will decide what method ultimately gets called. (This allows symbolic types to interact with Julia functions in an idiomatic manner.)
"""

# ╔═╡ 5c08c53c-c194-11ec-3d32-f9383c8d727f
md"""## Functions
"""

# ╔═╡ 5c08c578-c194-11ec-32d4-3105585c2cfb
md"""### Definition
"""

# ╔═╡ 5c08c5a0-c194-11ec-0222-1f5d58b0be63
md"""Functions can be defined four basic ways:
"""

# ╔═╡ 5c08c6ae-c194-11ec-3239-f326ad70b6a8
md"""  * one statement functions follow traditional mathematics notation:
"""

# ╔═╡ 5c08cc8a-c194-11ec-213b-0fb1f793c99c
md"""  * multi-statement functions are defined with the `function` keyword. The `end` statement ends the definition. The last evaluated command is returned. There is no need for explicit `return` statement, though it can be useful for control flow.
"""

# ╔═╡ 5c08d41e-c194-11ec-06b6-a9d540931af0
function g(x)
  a = sin(x)^2
  a + a^2 + a^3
end

# ╔═╡ 5c08d4b4-c194-11ec-27be-892f716e832f
md"""  * Anonymous functions, useful for example, as arguments to other functions or as return values, are defined using an arrow, `->`, as follows:
"""

# ╔═╡ 5c090024-c194-11ec-054b-c758ac972e64
begin
	fn = x -> sin(2x)
	fn(pi/2)
end

# ╔═╡ 5c0901a0-c194-11ec-306c-a3c8b39c186b
md"""In the following, the defined function, `Derivative`, returns an anonymously defined function that uses a `Julia` package, loaded with `CalculusWithJulia`, to take a derivative:
"""

# ╔═╡ 5c090862-c194-11ec-1c1d-fffeba0292c5
Derivatve(f::Function) = x -> ForwardDiff.derivative(f, x)    # ForwardDiff is loaded in CalculusWithJulia

# ╔═╡ 5c0908b2-c194-11ec-0ab7-8dc316e09438
md"""(The `D` function of `CalculusWithJulia` implements something similar.)
"""

# ╔═╡ 5c0909d4-c194-11ec-14a9-ef7d1eb1a223
md"""  * Anonymous function may also be created using the `function` keyword.
"""

# ╔═╡ 5c090a38-c194-11ec-06be-f1b11f4b12e8
md"""For mathematical functions $f: R^n \rightarrow R^m$ when $n$ or $m$ is bigger than 1 we have:
"""

# ╔═╡ 5c090a94-c194-11ec-0b65-dd156b1d78c4
md"""  * When $n =1$ and $m > 1$ we use a "vector" for the return value
"""

# ╔═╡ 5c090fc2-c194-11ec-2f88-b9d01edc5e32
md"""(An alternative would be to create a vector of functions.)
"""

# ╔═╡ 5c09106e-c194-11ec-15ea-1fab2923a1fc
md"""  * When $n > 1$ and $m=1$ we use multiple arguments or pass the arguments in a container. This pattern is common, as it allows both calling styles.
"""

# ╔═╡ 5c094494-c194-11ec-06e8-6d971d08295d
md"""Some functions need to pass in a container of values, for this the last definition is useful to expand the values. Splatting takes a container and treats the values like individual arguments.
"""

# ╔═╡ 5c0944ee-c194-11ec-3842-7b2482a4d20d
md"""Alternatively, indexing can be used directly, as in:
"""

# ╔═╡ 5c0951dc-c194-11ec-293b-d94edd15a004
md"""  * For vector fields ($n,m > 1$) a combination is used:
"""

# ╔═╡ 5c095862-c194-11ec-22a4-cbba9aa8fcf1
md"""### Calling a function
"""

# ╔═╡ 5c095894-c194-11ec-0a4f-17218f8da70d
md"""Functions are called using parentheses to group the arguments.
"""

# ╔═╡ 5c095e48-c194-11ec-1d4a-3f7bae50dfa2
md"""When a function has multiple arguments, yet the value passed in is a container holding the arguments, splatting is used to expand the arguments, as is done in the definition `F(v) = F(v...)`, above.
"""

# ╔═╡ 5c095e70-c194-11ec-22e4-2b82f8e12849
md"""### Multiple dispatch
"""

# ╔═╡ 5c095ef2-c194-11ec-0505-81f21ba86ef0
md"""`Julia` can have many methods for a single generic function. (E.g., it can have many different implementations of addiion when the `+` sign is encountered.) The *type*s of the arguments and the number of arguments are used for dispatch.
"""

# ╔═╡ 5c095efa-c194-11ec-285f-f9b0accefb3a
md"""Here the number of arguments is used:
"""

# ╔═╡ 5c09643a-c194-11ec-0fee-f3404cc85b6b
begin
	Area(w, h) = w * h    # area of rectangle
	Area(w) = Area(w, w)  # area of square using area of rectangle defintion
end

# ╔═╡ 5c096468-c194-11ec-0076-7bd7d03f9c9e
md"""Calling `Area(5)` will call `Area(5,5)` which will return `5*5`.
"""

# ╔═╡ 5c098436-c194-11ec-307d-231d627797e7
md"""Similarly, the definition for a vector field:
"""

# ╔═╡ 5c098fee-c194-11ec-0628-c1dc50510d76
md"""takes advantage of multiple dispatch to allow either a vector argument or individual arguments.
"""

# ╔═╡ 5c09906e-c194-11ec-27df-5796341da0f3
md"""Type parameters can be used to restrict the type of arguments that are permitted. The `Derivative(f::Function)` definition illustrates how the `Derivative` function, defined above, is restricted to `Function` objects.
"""

# ╔═╡ 5c0990ac-c194-11ec-24be-4bfde7e757f6
md"""### Keyword arguments
"""

# ╔═╡ 5c0990de-c194-11ec-0628-83966e8b3e44
md"""Optional arguments may be specified with keywords, when the function is defined to use them. Keywords are separated from positional arguments using a semicolon, `;`:
"""

# ╔═╡ 5c099a84-c194-11ec-002d-af838f7686c8
begin
	circle(x; r=1) = sqrt(r^2 - x^2)
	circle(0.5), circle(0.5, r=10)
end

# ╔═╡ 5c099ade-c194-11ec-12e2-876546ebc307
md"""The main (but not sole) use of keyword arguments will be with plotting, where various plot attribute are passed as `key=value` pairs.
"""

# ╔═╡ 5c099b24-c194-11ec-0631-93b2be0d0f12
md"""## Symbolic objects
"""

# ╔═╡ 5c099b42-c194-11ec-26aa-3d7117fb71c5
md"""The add-on `SymPy` package allows for symbolic expressions to be used. Symbolic values are defined with `@syms`, as below.
"""

# ╔═╡ 5c099ef8-c194-11ec-2b0c-a1dbcde8a614
md"""Assumptions on the variables can be useful, particularly with simplification, as in
"""

# ╔═╡ 5c09bf78-c194-11ec-0318-99aedbc5a0eb
md"""Symbolic expressions flow through `Julia` functions symbolically
"""

# ╔═╡ 5c09c54a-c194-11ec-3ee2-cbbda322b971
md"""Numbers are symbolic once `SymPy` interacts with them:
"""

# ╔═╡ 5c09c7de-c194-11ec-0a36-f93ddfd61187
md"""The number `PI` is a symbolic `pi`. a
"""

# ╔═╡ 5c09ca36-c194-11ec-01ac-2d73cb8d6adb
sin(PI), sin(pi)

# ╔═╡ 5c09ca72-c194-11ec-380c-af41fe49e91a
md"""Use `Sym` to create symbolic numbers, `N` to find a `Julia` number from a symbolic number:
"""

# ╔═╡ 5c09cd42-c194-11ec-1ddc-b3a603b6fc82
1 / Sym(2)

# ╔═╡ 5c09cea0-c194-11ec-051e-9b0e991b4288
N(PI)

# ╔═╡ 5c09cee6-c194-11ec-0439-7bd05c8dbf6b
md"""Many generic `Julia` functions will work with symbolic objects through multiple dispatch (e.g., `sin`, `cos`, ...). Sympy functions that are not in `Julia` can be accessed through the `sympy` object using dot-call notation:
"""

# ╔═╡ 5c09d170-c194-11ec-1f76-a7944d469d06
sympy.harmonic(10)

# ╔═╡ 5c09d1a2-c194-11ec-1152-6fafba36569b
md"""Some Sympy methods belong to the object and a called via the pattern `object.method(...)`. This too is the case using SymPy with `Julia`. For example:
"""

# ╔═╡ 5c09d8be-c194-11ec-14c4-5929577c081d
md"""## Containers
"""

# ╔═╡ 5c09d8f0-c194-11ec-31e8-2dbbe1a8f6cb
md"""We use a few different containers:
"""

# ╔═╡ 5c09d9e0-c194-11ec-3969-e980ea866f0d
md"""  * Tuples. These are objects grouped together using parentheses. They need not be of the same type
"""

# ╔═╡ 5c09de10-c194-11ec-0bc3-f1bddcc2cd65
x1 = (1, "two", 3.0)

# ╔═╡ 5c09de4a-c194-11ec-1f39-39ce02a933f8
md"""Tuples are useful for programming. For example, they are uesd to return multiple values from a function.
"""

# ╔═╡ 5c09def4-c194-11ec-108a-2fcad6d36474
md"""  * Vectors. These are objects of the same type (typically) grouped together using square brackets, values separated by commas:
"""

# ╔═╡ 5c09e264-c194-11ec-1db6-fd98cc37542b
x2 = [1, 2, 3.0]  # 3.0 makes theses all floating point

# ╔═╡ 5c09e276-c194-11ec-01e7-d74b82c58be8
md"""Unlike tuples, the expected arithmatic from Linear Algebra is implemented for vectors.
"""

# ╔═╡ 5c09e2da-c194-11ec-22e1-0bf529b8afc3
md"""  * Matrices. Like vectors, combine values of the same type, only they are 2-dimensional. Use spaces to separate values along a row; semicolons to separate rows:
"""

# ╔═╡ 5c09ebc4-c194-11ec-1986-b385c95cc12e
x3 = [1 2 3; 4 5 6; 7 8 9]

# ╔═╡ 5c09ec32-c194-11ec-1a79-a35245dd38c0
md"""  * Row vectors. A vector is 1 dimensional, though it may be identified as a column of two dimensional matrix. A row vector is a two-dimensional matrix with a single row:
"""

# ╔═╡ 5c09f010-c194-11ec-3073-e195d0f110ad
x4 = [1 2 3.0]

# ╔═╡ 5c09f060-c194-11ec-2899-d77a1060c125
md"""These have *indexing* using square brackets:
"""

# ╔═╡ 5c09f3e4-c194-11ec-11c9-895d098b153a
x1[1], x2[2], x3[3]

# ╔═╡ 5c09f40c-c194-11ec-0860-b749a791f09b
md"""Matrices are usually indexed by row and column:
"""

# ╔═╡ 5c09f5ec-c194-11ec-397d-373a3d625577
x3[1,2] # row one column two

# ╔═╡ 5c09f61e-c194-11ec-0c14-0357d63157da
md"""For vectors and matrices - but not tuples, as they are immutable - indexing can be used to change a value in the container:
"""

# ╔═╡ 5c09fa4c-c194-11ec-3d6a-6b52b7e68c0e
x2[1], x3[1,1] = 2, 2

# ╔═╡ 5c09fa7e-c194-11ec-32c0-f9fef57e204d
md"""Vectors and matrices are arrays. As hinted above, arrays have mathematical operations, such as addition and subtraction, defined for them. Tuples do not.
"""

# ╔═╡ 5c09faba-c194-11ec-34e5-03fe86148187
md"""Destructuring is an alternative to indexing to get at the entries in certain containers:
"""

# ╔═╡ 5c09fd44-c194-11ec-1630-571ba2d1e4e9
md"""### Structured collections
"""

# ╔═╡ 5c09fdda-c194-11ec-0930-692b599d0a42
md"""An arithmetic progression, $a, a+h, a+2h, ..., b$ can be produced *efficiently* using the range operator `a:h:b`:
"""

# ╔═╡ 5c0a00e6-c194-11ec-240a-87348e77f7f0
5:10:55  # an object that describes 5, 15, 25, 35, 45, 55

# ╔═╡ 5c0a0136-c194-11ec-25ad-d3f0c9d5b77f
md"""If `h=1` it can be omitted:
"""

# ╔═╡ 5c0a037a-c194-11ec-210d-2905d796fdb2
1:10     # an object that describes 1,2,3,4,5,6,7,8,9,10

# ╔═╡ 5c0a03c0-c194-11ec-289c-17f30a632222
md"""The `range` function can *efficiently* describe $n$ evenly spaced points between `a` and `b`:
"""

# ╔═╡ 5c0a0726-c194-11ec-0940-43a8dbd77a83
range(0, pi, length=5)  # range(a, stop=b, length=n) for version 1.0

# ╔═╡ 5c0a0758-c194-11ec-2e66-7bb816940c45
md"""This is useful for creating regularly spaced values needed for certain plots.
"""

# ╔═╡ 5c0a076c-c194-11ec-095f-09c387af9f63
md"""## Iteration
"""

# ╔═╡ 5c0a079e-c194-11ec-2db8-2d93a1bec91a
md"""The `for` keyword is useful for iteration, Here is a traditional for loop, as `i` loops over each entry of the vector `[1,2,3]`:
"""

# ╔═╡ 5c0a0c10-c194-11ec-2771-55a1456b112a
for i in [1,2,3]
  print(i)
end

# ╔═╡ 5c0a14a0-c194-11ec-21ea-d156e06375f2
CalculusWithJulia.WeaveSupport.note("""Technical aside: For assignment within a for loop at the global level, a `global` declaration may be needed to ensure proper scoping.""")

# ╔═╡ 5c0a14c8-c194-11ec-36aa-ff8ffe2dc536
md"""List comprehensions are similar, but are useful as they perform the iteration and collect the values:
"""

# ╔═╡ 5c0a19aa-c194-11ec-187a-07a45aa40e53
[i^2 for i in [1,2,3]]

# ╔═╡ 5c0a19c8-c194-11ec-028b-d59567a8063e
md"""Comprehesions can also be used to make matrices
"""

# ╔═╡ 5c0a215c-c194-11ec-118a-613d912be193
[1/(i+j) for i in 1:3, j in 1:4]

# ╔═╡ 5c0a2196-c194-11ec-22a3-1771fc7d07ac
md"""(The three rows are for `i=1`, then `i=2`, and finally for `i=3`.)
"""

# ╔═╡ 5c0a21d4-c194-11ec-2f6a-7fca84bfde1a
md"""Comprehensions  apply an *expression* to each entry in a container through iteration. Applying a function to each entry of a container can be facilitated by:
"""

# ╔═╡ 5c0a2256-c194-11ec-13d2-819bbc0f0a19
md"""  * Broadcasting. Using  `.` before an operation instructs `Julia` to match up sizes (possibly extending to do so) and then apply the operation element by element:
"""

# ╔═╡ 5c0a280c-c194-11ec-2196-ebe947124ee9
md"""This example pairs off the value in `bases` and `xs`:
"""

# ╔═╡ 5c0a2d96-c194-11ec-09fe-8da5438c0ad6
md"""This example broadcasts the scalar value for the base with `xs`:
"""

# ╔═╡ 5c0a2fda-c194-11ec-1f67-8fc307ea6fe9
md"""Row and column vectors can fill in:
"""

# ╔═╡ 5c0a34ee-c194-11ec-3250-0f5c310585a3
md"""This should be contrasted to the case when both `xs` and `ys` are (column) vectors, as then they pair off:
"""

# ╔═╡ 5c0a3856-c194-11ec-1c47-d3ec9472bc68
md"""  * The `map` function is similar, it applies a function to each element:
"""

# ╔═╡ 5c0a3b7e-c194-11ec-186c-fdf00f9ccb3c
map(sin, [1,2,3])

# ╔═╡ 5c0a6c48-c194-11ec-0e30-bb209a5c3198
CalculusWithJulia.WeaveSupport.note("""Many different computer languages implement `map`, broadcasting is less common. `Julia`'s use of the dot syntax to indicate broadcasting is reminiscent of MATLAB, but is quite different.""")

# ╔═╡ 5c0a6d38-c194-11ec-03f8-4fe856ea8194
md"""## Plots
"""

# ╔═╡ 5c0a6de2-c194-11ec-2e21-b3f5bb04bc0d
md"""The following commands use the `Plots` package. The `Plots` package expects a choice of backend. We will use both `plotly` and `gr` (and occasionally `pyplot()`).
"""

# ╔═╡ 5c0a811c-c194-11ec-2245-bd01907efed2
CalculusWithJulia.WeaveSupport.note("""
The `plotly` backend and `gr` backends are available by default. The `plotly` backend is has some interactivity, `gr` is for static plots. The `pyplot` package is used for certain surface plots, when `gr` can not be used.
""")

# ╔═╡ 5c0a8296-c194-11ec-0813-519a125f8708
md"""> Plotting a univariate function $f:R \rightarrow R$

"""

# ╔═╡ 5c0a832c-c194-11ec-28f8-5f56e13ea77e
md"""  * using `plot(f, a, b)`
"""

# ╔═╡ 5c0a8746-c194-11ec-3b14-338fcdd63627
plot(sin, 0, 2pi)

# ╔═╡ 5c0a878c-c194-11ec-1375-f7db641a445a
md"""Or
"""

# ╔═╡ 5c0a8fbe-c194-11ec-1376-c73c3920ced5
md"""Or with an anonymous function
"""

# ╔═╡ 5c0a968c-c194-11ec-055a-579b9f0457a7
plot(x -> sin(x) + sin(2x), 0, 2pi)

# ╔═╡ 5c0aa96a-c194-11ec-24d3-2da0173cee6a
CalculusWithJulia.WeaveSupport.note("""The time to first plot can be lengthy! This can be removed by creating a custom `Julia` image, but that is not introductory level stuff. As well, standalone plotting packages offer quicker first plots, but the simplicity of `Plots` is preferred. Subsequent plots are not so time consuming, as the initial time is spent compiling functions so their re-use is speedy.
""")

# ╔═╡ 5c0aa9c4-c194-11ec-0101-5f265de7224d
md"""Arguments of interest include
"""

# ╔═╡ 5c0b69b8-c194-11ec-32bc-3fb973357cb1
md"""|   Attribute    |                         Value                          |
|:--------------:|:------------------------------------------------------:|
|    `legend`    | A boolean, specify `false` to inhibit drawing a legend |
| `aspect_ratio` |   Use `:equal` to have x and y axis have same scale    |
|  `linewidth`   |    Ingters greater than 1 will thicken lines drawn     |
|    `color`     |  A color may be specified by a symbol (leading `:`).   |
|                |            E.g., `:black`, `:red`, `:blue`             |
"""

# ╔═╡ 5c0b6ba2-c194-11ec-2330-a97bd77dfa75
md"""  * using `plot(xs, ys)`
"""

# ╔═╡ 5c0b6bde-c194-11ec-01ee-af5cb4115f92
md"""The lower level interface to `plot` involves directly creating x and y values to plot:
"""

# ╔═╡ 5c0b78fe-c194-11ec-1725-c759e9f67d69
md"""  * plotting a symbolic expression
"""

# ╔═╡ 5c0b7926-c194-11ec-2da4-39e49562428c
md"""A symbolic expression of single variable can be plotted as a function is:
"""

# ╔═╡ 5c0b7e12-c194-11ec-2e35-f1aa2252e35f
md"""  * Multiple functions
"""

# ╔═╡ 5c0b7e58-c194-11ec-08b1-33d9342b3b2f
md"""The `!` Julia convention to modify an object is used by the `plot` command, so `plot!` will add to the existing plot:
"""

# ╔═╡ 5c0b8574-c194-11ec-1dc6-9fcc14e2d6c7
begin
	plot(sin, 0, 2pi, color=:red)
	plot!(cos, 0, 2pi, color=:blue)
	plot!(zero, color=:green)  # no a, b then inherited from graph.
end

# ╔═╡ 5c0b85da-c194-11ec-3b57-ff74c8e3dce8
md"""The `zero` function is just 0 (more generally useful when the type of a number is important, but used here to emphasize the $x$ axis).
"""

# ╔═╡ 5c0b869e-c194-11ec-2fa1-37628912d561
md"""> Plotting a parameterized (space) curve function $f:R \rightarrow R^n$, $n = 2$ or $3$

"""

# ╔═╡ 5c0b86e6-c194-11ec-28b3-f5b7f7434eeb
md"""  * Using `plot(xs, ys)`
"""

# ╔═╡ 5c0b8722-c194-11ec-1082-7d90bb2bbaad
md"""Let $f(t) = e^{t/2\pi} \langle \cos(t), \sin(t)\rangle$ be a parameterized function. Then the $t$ values can be generated as follows:
"""

# ╔═╡ 5c0bb6a2-c194-11ec-329b-c98c84fc044c
md"""  * using `plot(f1, f2, a, b)`. If the two functions describing the components are available, then
"""

# ╔═╡ 5c0bc0f4-c194-11ec-23f9-ab5b3c5454e9
begin
	f1(t) = exp(t/2pi) * cos(t)
	f2(t) = exp(t/2pi) * sin(t)
	plot(f1, f2, 0, 2pi)
end

# ╔═╡ 5c0bc1ba-c194-11ec-058e-e31699b8519e
md"""  * Using `plot_parametric`. If the curve is described as a function of `t` with a vector output, then the `CalculusWithJulia` package provides `plot_parametric` to produce a plot:
"""

# ╔═╡ 5c0bcac0-c194-11ec-328f-adf46cede86e
md"""The low-level approach doesn't quite work as easily as desired:
"""

# ╔═╡ 5c0bd218-c194-11ec-2841-fb5b144765b9
md"""As seen, the values are a vector of vectors. To plot a reshaping needs to be done:
"""

# ╔═╡ 5c0bd9b6-c194-11ec-21bf-1f76ea3f5fa1
md"""This approach is faciliated by the `unzip` function in `CalculusWithJulia` (and used internally by `plot_parametric`):
"""

# ╔═╡ 5c0bdd82-c194-11ec-27b0-f55fc88acee1
md"""  * Plotting an arrow
"""

# ╔═╡ 5c0bde02-c194-11ec-1527-6b8f589e743c
md"""An arrow in 2D can be plotted with the `quiver` command. We show the `arrow(p, v)` (or `arrow!(p,v)` function) from the `CalculusWithJulia` package, which has an easier syntax (`arrow!(p, v)`, where `p` is a point indicating the placement of the tail, and `v` the vector to represent):
"""

# ╔═╡ 5c0be460-c194-11ec-25f2-e13abd93cc5c
md"""> Plotting a scalar function $f:R^2 \rightarrow R$

"""

# ╔═╡ 5c0be4a6-c194-11ec-3100-27bf78994e6c
md"""The `surface` and `contour` functions are available to visualize a scalar function of $2$ variables:
"""

# ╔═╡ 5c0be4ea-c194-11ec-1b2a-634ab44501c2
md"""  * A surface plot
"""

# ╔═╡ 5c0bec76-c194-11ec-293d-31ff5027fd16
md"""The function generates the $z$ values, this can be done by the user and then passed to the `surface(xs, ys, zs)` format:
"""

# ╔═╡ 5c0bf086-c194-11ec-098c-c981969876ff
md"""  * A contour plot
"""

# ╔═╡ 5c0bf0ce-c194-11ec-217b-4ff7db9b3731
md"""The `contour` function is like the `surface` function.
"""

# ╔═╡ 5c0bf6a8-c194-11ec-1b17-0943e45e1068
md"""  * An implicit equation. The constraint $f(x,y)=c$ generates an implicit equation. While `contour` can be used for this type of plot - by adjusting the requested contours - the `ImplicitEquations` package can as well, and, perhaps. is easier.`ImplicitEquations` plots predicates formed by `Eq`, `Le`, `Lt`, `Ge`, and `Gt` (or some unicode counterparts). For example to plot when $f(x,y) = \sin(xy) - \cos(xy) \leq 0$ we have:
"""

# ╔═╡ 5c0bfaf4-c194-11ec-19dc-5d7c43953ddd
md"""> Plotting a parameterized surface $f:R^2 \rightarrow R^3$

"""

# ╔═╡ 5c0bfb1c-c194-11ec-3201-552ba01763a3
md"""The `pyplot` (and `plotly`) backends allow plotting of parameterized surfaces.
"""

# ╔═╡ 5c0bfb4e-c194-11ec-32a8-7535b6d93cb3
md"""The low-level `surface(xs,ys,zs)` is used, and can be specified directly as follows:
"""

# ╔═╡ 5c0c00ee-c194-11ec-1891-e1b2c0720b55
begin
	X(theta, phi) = sin(phi)*cos(theta)
	Y(theta, phi) = sin(phi)*sin(theta)
	Z(theta, phi) = cos(phi)
	thetas = range(0, pi/4, length=20)
	phis = range(0, pi, length=20)
	surface(X.(thetas, phis'), Y.(thetas, phis'), Z.(thetas, phis'))
end

# ╔═╡ 5c0c0166-c194-11ec-39e8-9b0c1360738d
md"""> Plotting a vector field $F:R^2 \rightarrow R^2$. The `CalculusWithJulia` package provides `vectorfieldplot`, used as:

"""

# ╔═╡ 5c0c0550-c194-11ec-3e5d-5beaf2380fb0
md"""There is also `vectorfieldplot3d`.
"""

# ╔═╡ 5c0c058a-c194-11ec-2107-810849a0ce65
md"""## Limits
"""

# ╔═╡ 5c0c05d0-c194-11ec-0c10-af8ebde883b9
md"""Limits can be investigated numerically by forming tables, eg.:
"""

# ╔═╡ 5c0c0f12-c194-11ec-3eed-816329f5e202
md"""Symbolically, `SymPy` provides a `limit` function:
"""

# ╔═╡ 5c0c1340-c194-11ec-3740-f9bf76ae961e
md"""Or
"""

# ╔═╡ 5c0c1804-c194-11ec-1a29-4baa863cd5df
md"""## Derivatives
"""

# ╔═╡ 5c0c182c-c194-11ec-18d8-ddfb2199350f
md"""There are numeric and symbolic approaches  to derivatives. For the numeric approach we use the `ForwardDiff` package, which performs automatic differentiation.
"""

# ╔═╡ 5c0c18a4-c194-11ec-3887-8b735d3fff44
md"""> Derivatives of univariate functions

"""

# ╔═╡ 5c0c18ce-c194-11ec-0f52-f925e5cbdc27
md"""Numerically, the `ForwardDiff.derivative(f, x)` function call will find the derivative of the function `f` at the point `x`:
"""

# ╔═╡ 5c0c1e3c-c194-11ec-3d62-8b15bc48eaa4
ForwardDiff.derivative(sin, pi/3) - cos(pi/3)

# ╔═╡ 5c0c1e94-c194-11ec-3426-9d3a31d149f8
md"""The `CalculusWithJulia` package overides the `'` (`adjoint`) syntax for functions to provide a derivative which takes a function and returns a function, so its usage is familiar
"""

# ╔═╡ 5c0c22f4-c194-11ec-14fe-6195c5a59bfa
md"""Higher order derivatives are possible as well,
"""

# ╔═╡ 5c0c279a-c194-11ec-25ce-63a5e64c5d6b
md"""---
"""

# ╔═╡ 5c0c27cc-c194-11ec-2013-43b13264ee43
md"""Symbolically, the `diff` function of `SymPy` finds derivatives.
"""

# ╔═╡ 5c0c2bd2-c194-11ec-3484-3f408ffb3b39
md"""Higher order derivatives can be specified as well
"""

# ╔═╡ 5c0c2e02-c194-11ec-1f12-c11605fc0e20
md"""Or with a number:
"""

# ╔═╡ 5c0c4908-c194-11ec-3009-4b7865a8fe33
md"""The variable is important, as this allows parameters to be symbolic
"""

# ╔═╡ 5c0c4ffe-c194-11ec-26c2-afa3b8c596ad
md"""> partial derivatives

"""

# ╔═╡ 5c0c5058-c194-11ec-1acd-d36a2f721082
md"""There is no direct partial derivative function provided by `ForwardDiff`, rather we use the result of the `ForwardDiff.gradient` function, which finds the partial derivatives for each variable. To use this, the function must be defined in terms of a point or vector.
"""

# ╔═╡ 5c0c576a-c194-11ec-1c2d-e183474f79f0
md"""We can see directly that $\partial{f}/\partial{x} = \langle y + z\rangle$. At the point $(1,2,3)$, this is $5$, as returned above.
"""

# ╔═╡ 5c0c5792-c194-11ec-1cd2-9df7cbebd307
md"""---
"""

# ╔═╡ 5c0c57b0-c194-11ec-090f-8112141e4848
md"""Symbolically, `diff` is used for partial derivatives:
"""

# ╔═╡ 5c0c5cf8-c194-11ec-350a-41a8deaa9c96
md"""> Gradient

"""

# ╔═╡ 5c0c5d3c-c194-11ec-2fb5-694daa4f4f48
md"""As seen, the `ForwardDiff.gradient` function finds the gradient at a point. In `CalculusWithJulia`, the gradient is extended to return a function when called with no additional arguments:
"""

# ╔═╡ 5c0c641c-c194-11ec-3fe3-0bf4ae8bcd57
md"""The `∇` symbol, formed by entering `\nabla[tab]`, is mathematical syntax for the gradient, and is defined in `CalculusWithJulia`.
"""

# ╔═╡ 5c0c8fbe-c194-11ec-0246-97873c3c3640
md"""---
"""

# ╔═╡ 5c0c9066-c194-11ec-156e-f323fee6285d
md"""In `SymPy`, there is no gradient function, though finding the gradient is easy through broadcasting:
"""

# ╔═╡ 5c0c9996-c194-11ec-2749-b7b88c76886d
md"""The  `CalculusWithJulia` package provides a method for `gradient`:
"""

# ╔═╡ 5c0c9d38-c194-11ec-0094-6d3843a0fe1e
md"""The `∇` symbol is an alias. It can guess the order of the free symbols, but generally specifying them is needed. This is done with a tuple:
"""

# ╔═╡ 5c0ca274-c194-11ec-0835-55b2f0baaf89
md"""> Jacobian

"""

# ╔═╡ 5c0ca2c4-c194-11ec-31f0-6d3f5f2dd8ca
md"""The Jacobian of a function $f:R^n \rightarrow R^m$ is a $m\times n$ matrix of partial derivatives. Numerically, `ForwardDiff.jacobian` can find the Jacobian of a function at a point:
"""

# ╔═╡ 5c0cac6a-c194-11ec-19d2-c7607af347a8
md"""---
"""

# ╔═╡ 5c0cace2-c194-11ec-1370-595509e78083
md"""Symbolically, the `jacobian` function is a method of a *matrix*, so the calling pattern is different. (Of the form `object.method(arguments...)`.)
"""

# ╔═╡ 5c0cb2aa-c194-11ec-1d91-b3f5c81c8c60
md"""As the Jacobian can be identified as the matrix with rows given by the transpose of the gradient of the component, it can be computed directly, but it is more difficult:
"""

# ╔═╡ 5c0ce216-c194-11ec-2fec-11fe640c7765
md"""> Divergence

"""

# ╔═╡ 5c0ce2b6-c194-11ec-3ac2-c1e08aa8a78c
md"""Numerically, the divergence can be computed from the Jacobian by adding the diagonal elements. This is a numerically inefficient, as the other partial derivates must be found and discarded, but this is generally not an issue for these notes. The following uses `tr` (the trace from the `LinearAlgebra` package) to find the sum of a diagonal.
"""

# ╔═╡ 5c0cebb4-c194-11ec-16ed-070661e16f26
md"""The `CalculusWithJulia` package provides `divergence` to compute the divergence and provides the `∇ ⋅` notation (`\nabla[tab]\cdot[tab]`):
"""

# ╔═╡ 5c0d2058-c194-11ec-04e1-e54fb5c14b2f
md"""---
"""

# ╔═╡ 5c0d20aa-c194-11ec-1d17-4da1932c5908
md"""Symbolically, the divergence can be found directly:
"""

# ╔═╡ 5c0d291a-c194-11ec-2ed3-f187a2f5b535
md"""The `divergence` function can be used for symbolic expressions:
"""

# ╔═╡ 5c0d2f96-c194-11ec-1e2e-5de683c2537f
md"""> Curl

"""

# ╔═╡ 5c0d2fc8-c194-11ec-2b58-3b639f106167
md"""The curl can be computed from the off-diagonal elements of the Jacobian. The calculation follows the formula. The `CalculusWithJulia` package provides `curl` to compute this:
"""

# ╔═╡ 5c0d3718-c194-11ec-153a-b3c9437e96a2
md"""As well, if no point is specified, a function is returned for which a point may be specified using 3 coordinates or a vector
"""

# ╔═╡ 5c0d3ed2-c194-11ec-2615-b972f1e15614
md"""Finally, the `∇ ×` (`\nabla[tab]\times[tab]` notation is available)
"""

# ╔═╡ 5c0d6aec-c194-11ec-0dce-cf5b09a4c72a
md"""For symbolic expressions, we have
"""

# ╔═╡ 5c0d7172-c194-11ec-0600-2b25e5d2456c
md"""(Do note the subtle difference in the use of parentheses between the numeric and the symbolic. For the symbolic, `F(x,y,z)` is evaluated *before* being passed to `∇×`, where as for the numeric approach `∇×F` is evaluated *before* passing a point to compute the value there.)
"""

# ╔═╡ 5c0d71ae-c194-11ec-2b23-53464b8d15ae
md"""## Integrals
"""

# ╔═╡ 5c0d71f4-c194-11ec-21fc-4789e1f5de39
md"""Numeric integration is provided by the `QuadGK` package, for univariate integrals, and the `HCubature` package for higher dimensional integrals.
"""

# ╔═╡ 5c0d75f0-c194-11ec-0a33-8d6b468d79fc
md"""> Integrals of univariate functions

"""

# ╔═╡ 5c0d762c-c194-11ec-030b-3d736c456fb3
md"""A definite integral may be computed numerically using `quadgk`
"""

# ╔═╡ 5c0d791a-c194-11ec-1fd3-2f8e248dc96e
quadgk(sin, 0, pi)

# ╔═╡ 5c0d794c-c194-11ec-3d5b-a911c6a6d824
md"""The answer and an estimate for the worst case error is returned.
"""

# ╔═╡ 5c0d7960-c194-11ec-0046-c50eae497856
md"""If singularities are avoided, improper integrals are computed as well:
"""

# ╔═╡ 5c0d822a-c194-11ec-2c5a-4dcbfac27e79
quadgk(x->1/x^(1/2), 0, 1)

# ╔═╡ 5c0d8284-c194-11ec-0c00-af194b901e27
md"""---
"""

# ╔═╡ 5c0d82fc-c194-11ec-2bcb-35b8dc7e3ee7
md"""SymPy provides the `integrate` function to compute both definite and indefinite integrals.
"""

# ╔═╡ 5c0d8b4c-c194-11ec-0947-edbccdc8e000
md"""Like `diff` the variable to integrate is specified.
"""

# ╔═╡ 5c0d8b8a-c194-11ec-2f75-0f6acd41c052
md"""Definite integrals use a tuple, `(variable, a, b)`, to specify the variable and range to integrate over:
"""

# ╔═╡ 5c0d92d8-c194-11ec-2997-9b280fed6b25
md"""> 2D and 3D iterated integrals

"""

# ╔═╡ 5c0d9346-c194-11ec-3012-cf96515f2211
md"""Two and three dimensional integrals over box-like regions are computed numerically with the `hcubature` function from the `HCubature` package. If the box is $[x_1, y_1]\times[x_2,y_2]\times\cdots\times[x_n,y_n]$ then the limits are specified through tuples of the form $(x_1,x_2,\dots,x_n)$ and $(y_1,y_2,\dots,y_n)$.
"""

# ╔═╡ 5c0d9a60-c194-11ec-3816-f1069c368cc8
md"""The calling pattern for more dimensions is identical.
"""

# ╔═╡ 5c0c8ec4-c194-11ec-10dc-19c8f7fcd14b
∇(f)(1,2,3)   # same as gradient(f, [1,2,3])

# ╔═╡ 5c0dcb36-c194-11ec-2156-c3791ddd89d0
md"""The box-like region requirement means a change of variables may be necessary. For example, to integrate over the region $x^2 + y^2 \leq 1; x \geq 0$, polar coordinates can be used with $(r,\theta)$ in $[0,1]\times[-\pi/2,\pi/2]$. When changing variables, the Jacobian enters into the formula, through
"""

# ╔═╡ 5c0dcb9a-c194-11ec-2972-cb17e01f603e
md"""```math
~
\iint_{G(S)} f(\vec{x}) dV = \iint_S (f \circ G)(\vec{u}) |\det(J_G)(\vec{u})| dU.
~
```
"""

# ╔═╡ 5c0dcbb8-c194-11ec-03d5-1bf548daffbf
md"""Here we implement this:
"""

# ╔═╡ 5c0dd444-c194-11ec-004e-cd589a26aa66
md"""In `CalculusWithJulia` a `fubini` function is provided to compute numeric integrals over regions which can be described by curves represented by functions. E.g., for this problem:
"""

# ╔═╡ 5c0de2ce-c194-11ec-1fee-e56a9fbf8333
CalculusWithJulia.fubini(f, (x -> -sqrt(1-x^2), x -> sqrt(1-x^2)), (0, 1))

# ╔═╡ 5c0de314-c194-11ec-2969-d34e52ae321b
md"""This function is for convenience, but is not performant. It is not exported, so is used as above, through qualification.
"""

# ╔═╡ 5c0de358-c194-11ec-005b-6f0c29076db8
md"""---
"""

# ╔═╡ 5c0de396-c194-11ec-0660-a3df923828cb
md"""Symbolically, the `integrate` function allows additional terms to be specified. For example, the above could be done through:
"""

# ╔═╡ 5c09c50e-c194-11ec-2333-e3ec897eaaaf
sin(x)^2 + cos(x)^2

# ╔═╡ 5c09c7a2-c194-11ec-23c4-331a29627806
x - x + 1  # 1 is now symbolic

# ╔═╡ 5c09d882-c194-11ec-0252-c75bb10ba03b
begin
	A = [x 1; x 2]
	A.det()   # determinant of symbolic matrix A
end

# ╔═╡ 5c0d91fc-c194-11ec-18e5-51eb0553485a
integrate(sin(a + x), (x, 0, PI))   #  ∫_0^PI sin(a+x) dx

# ╔═╡ 5c0deb3e-c194-11ec-32e6-4f9b9ca0a18f
md"""> Line integrals

"""

# ╔═╡ 5c0deb70-c194-11ec-1cb4-9d7d0e37a457
md"""A line integral of $f$ parameterized by $\vec{r}(t)$ is computed by:
"""

# ╔═╡ 5c0debac-c194-11ec-17d6-7d189b600815
md"""```math
~
\int_a^b (f\circ\vec{r})(t) \| \frac{dr}{dt}\| dt.
~
```
"""

# ╔═╡ 5c0debf2-c194-11ec-2405-c7ccf84b749f
md"""For example, if $f(x,y) = 2 - x^2 - y^2$ and $r(t) = 1/t \langle \cos(t), \sin(t) \rangle$, then the line integral over $[1,2]$ is given by:
"""

# ╔═╡ 5c0df412-c194-11ec-15f7-4f305aa18135
md"""To integrate a line integral through a vector field, say $\int_C F \cdot\hat{T} ds=\int_C F\cdot \vec{r}'(t) dt$ we have, for example,
"""

# ╔═╡ 5c0a2d5a-c194-11ec-0cb5-793419da5c7c
begin
	bases = [5,5,10]
	log.(bases, xs)  # log(5, 1), log(5,2), log(10, 3)
end

# ╔═╡ 5c0a2fbc-c194-11ec-0b59-577040e0c2c9
log.(5, xs)

# ╔═╡ 5c0a37c8-c194-11ec-2ba0-2d925666a5dc
f.(xs, [4,5])

# ╔═╡ 5c0bdd08-c194-11ec-20ee-9d6155e44c68
plot(unzip(vs)...)

# ╔═╡ 5c0bf02a-c194-11ec-2504-657f69cea3a4
surface(xs, ys, f.(xs, ys'))

# ╔═╡ 5c0bf2c8-c194-11ec-39ba-194a7ee7b827
contour(xs, ys, f)

# ╔═╡ 5c0bf5e0-c194-11ec-0202-cddab2e13427
contour(xs, ys, f.(xs, ys'))

# ╔═╡ 5c0be3ac-c194-11ec-2613-c104ce7b4083
begin
	plot_parametric(0..2pi, r)
	t0 = pi/8
	arrow!(r(t0), r'(t0))
end

# ╔═╡ 5c0dfa5c-c194-11ec-2ed3-9bf12837fd6d
md"""---
"""

# ╔═╡ 5c0dfaa2-c194-11ec-1d61-ab700dccafef
md"""Symbolically, there is no real difference from a 1-dimensional integral. Let $\phi = 1/\|r\|$ and integrate the gradient field over one turn of the helix $\vec{r}(t) = \langle \cos(t), \sin(t), t\rangle$.
"""

# ╔═╡ 5c0e43a4-c194-11ec-2800-8502d494fad2
md"""Then
"""

# ╔═╡ 5c0e4ba6-c194-11ec-03a8-8f3f1c28e4dc
md"""> Surface integrals

"""

# ╔═╡ 5c0e4c46-c194-11ec-2a45-697c84f3ca42
md"""The surface integral for a parameterized surface involves a surface element $\|\partial\Phi/\partial{u} \times \partial\Phi/\partial{v}\|$. This can be computed numerically with:
"""

# ╔═╡ 5c0e568a-c194-11ec-03f0-0d3789b22d70
md"""To find the surface integral ($f=1$) for this surface over $[0,1] \times [0,2\pi]$, we have:
"""

# ╔═╡ 5c0ebf14-c194-11ec-0f77-a7e1a9739799
hcubature(pt -> norm(SE(Phi, pt)), (0.0,0.0), (1.0, 2pi))

# ╔═╡ 5c0ebfe4-c194-11ec-0fd2-7179c561757d
md"""Symbolically, the approach is similar:
"""

# ╔═╡ 5c0ecb4e-c194-11ec-09e6-39556e0d367b
md"""Then
"""

# ╔═╡ 5c0ed302-c194-11ec-22b2-db70cb9b214f
md"""Integrating a vector field over the surface, would be similar:
"""

# ╔═╡ 5c0c2dc6-c194-11ec-36b9-e7b0d68375d0
diff(ex, x, x)

# ╔═╡ 5c0c489c-c194-11ec-139c-13224eea7961
diff(ex, x, 5)

# ╔═╡ 5c0c9cf2-c194-11ec-2238-8395dd15f098
gradient(ex, [x,y,z])

# ╔═╡ 5c0ca152-c194-11ec-09a1-1b109a0fdd0c
∇((ex, [x,y,z]))  # for this, ∇(ex) also works

# ╔═╡ 5c0ed2d8-c194-11ec-2ddf-b9f65db85b20
integrate(SurfEl, (u, 0, 1), (v, 0, 2PI))

# ╔═╡ 5c0d1f60-c194-11ec-30c0-1b3680018d01
begin
	divergence(F, [1,2,3])
	(∇⋅F)(1,2,3)    # not ∇⋅F(1,2,3) as that evaluates F(1,2,3) before the divergence
end

# ╔═╡ 5c0d2e68-c194-11ec-3b4a-8bb841662b3a
begin
	divergence(ex, [x,y,z])
	∇⋅(F(x,y,z), [x,y,z])   # For this, ∇ ⋅ F(x,y,z) also works
end

# ╔═╡ 5c0d3e78-c194-11ec-247a-33c2706227dc
curl(F)(1,2,3), curl(F)([1,2,3])

# ╔═╡ 5c0d69d4-c194-11ec-1118-6fd9351d03d2
(∇×F)(1,2,3)

# ╔═╡ 5c0d706e-c194-11ec-38df-db1422c8258d
∇×F(1,2,3)

# ╔═╡ 5c0e4a70-c194-11ec-058d-637d14b2368a
integrate(ex, (t, 0, 2PI))

# ╔═╡ 5c0ed902-c194-11ec-2a5e-1fa20a4738aa
HTML("""<div class="markdown"><blockquote>
<p><a href="../misc/bibliography.html">◅ previous</a>  <a href="../misc/julia_interfaces.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/misc/quick_notes.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 5c0ed918-c194-11ec-0edd-7b5b870752da
PlutoUI.TableOfContents()

# ╔═╡ 5c0e430c-c194-11ec-395f-45fb65deecbb
begin
	@syms x::real y::real z::real t::real
	phi(x,y,z) = 1/sqrt(x^2 + y^2 + z^2)
	r(t) = [cos(t), sin(t), t]
	∇phi = diff.(phi(x,y,z), [x,y,z])
	∇phi_r = subs.(∇phi, x.=> r(t)[1], y.=>r(t)[2], z.=>r(t)[3])
	rp = diff.(r(t), t)
	ex = simplify(∇phi_r ⋅ rp )
end

# ╔═╡ 5c0df3d4-c194-11ec-27b2-990f87b352ff
begin
	f(x,y) = 2 - x^2 - y^2
	f(v) = f(v...)
	r(t) = [cos(t), sin(t)]/t
	integrand(t) = (f∘r)(t) * norm(r'(t))
	quadgk(integrand, 1, 2)
end

# ╔═╡ 5c0cb246-c194-11ec-0570-0bfc9be0c766
begin
	@syms u v
	ex = F(u,v)
	ex.jacobian([u,v])
end

# ╔═╡ 5c0d36c6-c194-11ec-2780-358385dff332
begin
	F(x,y,z) = [-y, x, 1]
	F(v) = F(v...)
	curl(F, [1,2,3])
end

# ╔═╡ 5c0a8f7a-c194-11ec-17ba-ef1dc63dc890
begin
	f(x) = exp(-x/2pi)*sin(x)
	plot(f, 0, 2pi)
end

# ╔═╡ 5c0c2b96-c194-11ec-2f4f-93e84ed701cd
begin
	@syms x
	f(x) = exp(-x)*sin(x)
	ex = f(x)  # symbolic expression
	diff(ex, x)   # or just diff(f(x), x)
end

# ╔═╡ 5c09bea6-c194-11ec-13bf-bba80fc21041
@syms x::real y::integer z::positive

# ╔═╡ 5c0d9a1c-c194-11ec-33aa-d15cb71b9c67
begin
	f(x,y) = x*y^2
	f(v) = f(v...)
	hcubature(f, (0,0), (1, 2))  # computes ∫₀¹∫₀² f(x,y) dy dx
end

# ╔═╡ 5c0bfa86-c194-11ec-1c5c-5befc5ba97f1
begin
	using ImplicitEquations
	f(x,y) = sin(x*y) - cos(x*y)
	plot(Le(f, 0))     # or plot(f ≦ 0) using \leqq[tab] to create that symbol
end

# ╔═╡ 5c0ed870-c194-11ec-016f-8f536a5b1945
begin
	F(x,y,z) = [x, y, z]
	ex = F(Phi(u,v)...)  ⋅ (J[:,1] × J[:,2])
	integrate(ex, (u,0,1), (v, 0, 2PI))
end

# ╔═╡ 5c0dca00-c194-11ec-371b-9fcd75d230a7
begin
	f(x,y,z) = x*y^2*z^3
	f(v) = f(v...)
	hcubature(f, (0,0,0), (1, 2,3)) # computes ∫₀¹∫₀²∫₀³ f(x,y,z) dz dy dx
end

# ╔═╡ 5c0a27c4-c194-11ec-2731-f1877b350f59
begin
	xs = [1,2,3]
	sin.(xs)   # sin(1), sin(2), sin(3)
end

# ╔═╡ 5c0d2884-c194-11ec-111b-e71b3d48126e
begin
	@syms x y z
	ex = F(x,y,z)
	sum(diff.(ex, [x,y,z]))    # sum of [diff(ex[1], x), diff(ex[2],y), diff(ex[3], z)]
end

# ╔═╡ 5c0d8b12-c194-11ec-1bb5-1b6ba5a9bcad
begin
	@syms a::real x::real
	integrate(exp(a*x)*sin(x), x)
end

# ╔═╡ 5c099ee4-c194-11ec-3aa3-61203f6e0390
begin
	using SymPy
	@syms x y z
	x^2 + y^3 + z
end

# ╔═╡ 5c0c9928-c194-11ec-2a7b-7fe64124f4ed
begin
	@syms x y z
	ex = x*y + y*z + z*x
	diff.(ex, [x,y,z])  # [diff(ex, x), diff(ex, y), diff(ex, z)]
end

# ╔═╡ 5c0bd1dc-c194-11ec-1780-c783aff7bbb2
begin
	ts = range(0, 2pi, length = 4)
	vs = r.(ts)
end

# ╔═╡ 5c08cbd8-c194-11ec-1389-1fb8aa1e5bb7
f(x) = exp(x) * 2x

# ╔═╡ 5c0c4f40-c194-11ec-0542-8de8d62b5728
begin
	@syms mu sigma x
	diff(exp(-((x-mu)/sigma)^2/2), x)
end

# ╔═╡ 5c09fd12-c194-11ec-114f-1fb7b661b32b
a,b,c = x2

# ╔═╡ 5c0bb472-c194-11ec-2d2a-e5c6b198a38d
begin
	ts = range(0, 2pi, length = 100)
	xs = [exp(t/2pi) * cos(t) for t in ts]
	ys = [exp(t/2pi) * sin(t) for t in ts]
	plot(xs, ys)
end

# ╔═╡ 5c0943e0-c194-11ec-1116-8bc39c03b3dd
begin
	f(x,y,z) = x*y + y*z + z*x
	f(v) = f(v...)
end

# ╔═╡ 5c0c63ea-c194-11ec-3462-6b5a3cd0a7cb
begin
	f(x,y,z) =  x*y + y*z + z*x
	f(v) = f(v...)
	gradient(f)(1,2,3) - gradient(f, [1,2,3])
end

# ╔═╡ 5c090f88-c194-11ec-37c1-2ddf900d6a1c
r(t) = [sin(t), cos(t), t]

# ╔═╡ 5c095de4-c194-11ec-1e50-456ef5727c94
begin
	f(t) = sin(t)*sqrt(t)
	sin(1), sqrt(1), f(1)
end

# ╔═╡ 5c0a7382-c194-11ec-0b10-c9861c07a559
begin
	using Plots
	pyplot()      # select pyplot. Use `gr()` for GR; `plotly()` for Plotly
end

# ╔═╡ 5c0dd392-c194-11ec-2788-eb2ab0756e0c
begin
	f(x,y) = x*y^2
	f(v) = f(v...)
	Phi(r, theta) = r * [cos(theta), sin(theta)]
	Phi(rtheta) = Phi(rtheta...)
	integrand(rtheta) = f(Phi(rtheta)) * det(ForwardDiff.jacobian(Phi, rtheta))
	hcubature(integrand, (0.0,-pi/2), (1.0, pi/2))
end

# ╔═╡ 5c0ce040-c194-11ec-0f6c-b11450187f54
begin
	@syms u::real v::real
	vcat([diff.(ex, [u,v])' for ex in F(u,v)]...)
end

# ╔═╡ 5c0c5c86-c194-11ec-3763-89f6f98e83e4
begin
	@syms x y z
	ex = x*y + y*z + z*x
	diff(ex, x)    # ∂f/∂x
end

# ╔═╡ 5c0e561e-c194-11ec-0ba0-49261a8f584c
begin
	Phi(u,v) = [u*cos(v), u*sin(v), u]
	Phi(v) = Phi(v...)
	
	function SE(Phi, pt)
	   J = ForwardDiff.jacobian(Phi, pt)
	   J[:,1] × J[:,2]
	end
	
	norm(SE(Phi, [1,2]))
end

# ╔═╡ 5c0c5718-c194-11ec-1ae0-3d8e607cf560
begin
	f(x,y,z) = x*y + y*z + z*x
	f(v) = f(v...)               # this is needed for ForwardDiff.gradient
	ForwardDiff.gradient(f, [1,2,3])
end

# ╔═╡ 5c0c0ed6-c194-11ec-1b64-0f10de13d347
begin
	xs = [1, 1/10, 1/100, 1/1000]
	f(x) = sin(x)/x
	[xs f.(xs)]
end

# ╔═╡ 5c095024-c194-11ec-0401-2d012b9fd043
f(x) = x[1]*x[2] + x[2]*x[3] + x[3]*x[1]

# ╔═╡ 5c0b7d90-c194-11ec-05cb-c9aba53e0bfb
begin
	@syms x
	plot(exp(-x/2pi)*sin(x), 0, 2pi)
end

# ╔═╡ 5c0bec30-c194-11ec-28b9-210aff14c949
begin
	f(x, y) = 2 - x^2 + y^2
	xs = ys = range(-2,2, length=25)
	surface(xs, ys, f)
end

# ╔═╡ 5c0bca8e-c194-11ec-1bbd-d34d9de45ca7
begin
	r(t) = exp(t/2pi) * [cos(t), sin(t)]
	plot_parametric(0..2pi, r)
end

# ╔═╡ 5c0dfa34-c194-11ec-357e-2df3a2bbb540
begin
	F(x,y) = [-y, x]
	F(v) = F(v...)
	r(t) =  [cos(t), sin(t)]/t
	integrand(t) = (F∘r)(t) ⋅ r'(t)
	quadgk(integrand, 1, 2)
end

# ╔═╡ 5c095808-c194-11ec-3c32-41a3c0ae24a2
begin
	F(x,y,z) = [-y, x, z]
	F(v) = F(v...)
end

# ╔═╡ 5c0dea26-c194-11ec-162c-219b88c3d514
begin
	@syms x::real y::real
	integrate(x * y^2, (y, -sqrt(1-x^2), sqrt(1-x^2)), (x, 0, 1))
end

# ╔═╡ 5c0ceb58-c194-11ec-1161-8f7f5ced1f9f
begin
	F(x,y,z) = [-y, x, z]
	F(v) = F(v...)
	pt = [1,2,3]
	tr(ForwardDiff.jacobian(F , pt))
end

# ╔═╡ 5c0c17dc-c194-11ec-31c9-41db845a9c6f
begin
	@syms h x
	limit((sin(x+h) - sin(x))/h, h => 0)
end

# ╔═╡ 5c0c2754-c194-11ec-10fc-235300bc1dd0
begin
	f(x) = sin(x)
	f''''(pi/3) - f(pi/3)
end

# ╔═╡ 5c08c3f2-c194-11ec-0e1b-1d21bba9be3e
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 5c0a34b4-c194-11ec-3eb0-1da30e853d88
begin
	ys = [4 5] # a row vector
	f(x,y) = (x,y)
	f.(xs, ys)    # broadcasting a column and row vector makes a matrix, then applies f.
end

# ╔═╡ 5c098f12-c194-11ec-227e-95d4e2098f2b
begin
	F(x,y,z) = [-y, x, z]
	F(v) = F(v...)
end

# ╔═╡ 5c0c132e-c194-11ec-3dff-dd62fb126553
begin
	@syms x
	limit(sin(x)/x, x => 0)
end

# ╔═╡ 5c0ecb24-c194-11ec-3955-6b0f84baf342
begin
	@syms u::real v::real
	ex = Phi(u,v)
	J = ex.jacobian([u,v])
	SurfEl = norm(J[:,1] × J[:,2]) |> simplify
end

# ╔═╡ 5c0c0512-c194-11ec-3efb-69a8682d73c8
begin
	gr()  # better arrows than plotly()
	F(x,y) = [-y, x]
	vectorfieldplot(F, xlim=(-2, 2), ylim=(-2,2), nx=10, ny=10)
end

# ╔═╡ 5c0cac38-c194-11ec-1a68-8beaa376ca9f
begin
	F(u,v) = [u*cos(v), u*sin(v), u]
	F(v) = F(v...)    # needed for ForwardDiff.jacobian
	pt = [1, pi/4]
	ForwardDiff.jacobian(F , pt)
end

# ╔═╡ 5c0b7868-c194-11ec-38f0-35d716c9c440
begin
	xs = range(0, 2pi, length=100)
	ys = sin.(xs)
	plot(xs, ys, color=:red)
end

# ╔═╡ 5c0bd970-c194-11ec-03a1-1d254571db1a
begin
	ts = range(0, 2pi, length = 100)
	vs = r.(ts)
	xs = [vs[i][1] for i in eachindex(vs)]
	ys = [vs[i][2] for i in eachindex(vs)]
	plot(xs, ys)
end

# ╔═╡ 5c08bd8a-c194-11ec-0086-0522fa114a64
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using Plots
	nothing
end

# ╔═╡ 5c0c22e0-c194-11ec-181c-d3f58172e1fb
begin
	f(x) = sin(x)
	f'(pi/3) - cos(pi/3)  # or just sin'(pi/3) - cos(pi/3)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
HCubature = "19dc6840-f33b-545b-b366-655c7e3ffd49"
ImplicitEquations = "95701278-4526-5785-aba3-513cca398f19"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.17"
HCubature = "~1.5.0"
ImplicitEquations = "~1.0.7"
Plots = "~1.27.6"
PlutoUI = "~0.7.38"
QuadGK = "~2.4.2"
SymPy = "~1.1.4"
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

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CRlibm]]
deps = ["CRlibm_jll"]
git-tree-sha1 = "32abd86e3c2025db5172aa182b982debed519834"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "1.0.1"

[[deps.CRlibm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e329286945d0cfc04456972ea732551869af1cfc"
uuid = "4e9b3aee-d8a1-5a3d-ad8b-7d824db253f0"
version = "1.0.1+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "QuizQuestions", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "18ea2c014776f6e5cdc94b5620ca0d353b207301"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.17"

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
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

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

[[deps.Dictionaries]]
deps = ["Indexing", "Random"]
git-tree-sha1 = "0340cee29e3456a7de968736ceeb705d591875a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.20"

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

[[deps.ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

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

[[deps.FastRounding]]
deps = ["ErrorfreeArithmetic", "LinearAlgebra"]
git-tree-sha1 = "6344aa18f654196be82e62816935225b3b9abe44"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.3.1"

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
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

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

[[deps.ImplicitEquations]]
deps = ["CommonEq", "IntervalArithmetic", "RecipesBase", "Test", "Unicode"]
git-tree-sha1 = "15d04a0a28c5e256cc26c7d47baa35e595f1cd5f"
uuid = "95701278-4526-5785-aba3-513cca398f19"
version = "1.0.7"

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalArithmetic]]
deps = ["CRlibm", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "1fa3ba0893ea5611830feedac46b7f95872cbd01"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.20.5"

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
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

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
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

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
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

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
git-tree-sha1 = "bfbd6fb946d967794498790aa7a0e6cdf1120f41"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.13"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

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

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "6f2dd1cf7a4bbf4f305a0d8750e351cb46dfbe80"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

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

[[deps.QuizQuestions]]
deps = ["Base64", "Markdown", "Mustache", "Random"]
git-tree-sha1 = "9e56e8b527c96c96d7a9ad9c060aca9b5c402b1a"
uuid = "612c44de-1021-4a21-84fb-7261cf5eb2d4"
version = "0.3.11"

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
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

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
git-tree-sha1 = "e382260f6482c27b5062eba923e36fde2f5ab0b9"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.0"

[[deps.RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

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
git-tree-sha1 = "cbf21db885f478e4bd73b286af6e67d1beeebe4c"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.4"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "1763d267a68a4e58330925b7ce8b9ea2ec06c882"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.4"

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
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

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
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

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

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─5c0ed896-c194-11ec-2cdf-536a73499a05
# ╟─5c08b330-c194-11ec-2778-1f8492521842
# ╟─5c08b39e-c194-11ec-3353-b92659ab913a
# ╟─5c08b416-c194-11ec-35d0-070fa57a6a22
# ╟─5c08b48e-c194-11ec-3009-4dc6ad328c39
# ╟─5c08b4b4-c194-11ec-3ce8-391cd225ca86
# ╟─5c08b574-c194-11ec-0919-977f053f5f98
# ╟─5c08b5d8-c194-11ec-3743-1d5619b107ce
# ╟─5c08b614-c194-11ec-2474-e7456f8af86b
# ╟─5c08b646-c194-11ec-1f69-0512810dc2a9
# ╟─5c08b68c-c194-11ec-14ca-af4ef355ed7c
# ╟─5c08bd8a-c194-11ec-0086-0522fa114a64
# ╟─5c08bdd0-c194-11ec-3e34-639b51cc0c46
# ╟─5c08be02-c194-11ec-35cb-2b8646cd8c50
# ╟─5c08be20-c194-11ec-2701-395d7574bbcc
# ╠═5c08bfe2-c194-11ec-2b7e-1f00623582dd
# ╟─5c08c01e-c194-11ec-2b1e-a9b75144f151
# ╟─5c08c06e-c194-11ec-2571-cbd46d05e137
# ╟─5c08c082-c194-11ec-17da-2d6ec31879c6
# ╟─5c08c0a0-c194-11ec-383c-a54d50baf87d
# ╠═5c08c3f2-c194-11ec-0e1b-1d21bba9be3e
# ╟─5c08c42c-c194-11ec-12a5-15276d7807ce
# ╟─5c08c460-c194-11ec-1fcd-5da7220a72dd
# ╟─5c08c4d8-c194-11ec-2d2a-9339b8986ab7
# ╟─5c08c4f6-c194-11ec-2b76-8304c6a64c8c
# ╟─5c08c53c-c194-11ec-3d32-f9383c8d727f
# ╟─5c08c578-c194-11ec-32d4-3105585c2cfb
# ╟─5c08c5a0-c194-11ec-0222-1f5d58b0be63
# ╟─5c08c6ae-c194-11ec-3239-f326ad70b6a8
# ╠═5c08cbd8-c194-11ec-1389-1fb8aa1e5bb7
# ╟─5c08cc8a-c194-11ec-213b-0fb1f793c99c
# ╠═5c08d41e-c194-11ec-06b6-a9d540931af0
# ╟─5c08d4b4-c194-11ec-27be-892f716e832f
# ╠═5c090024-c194-11ec-054b-c758ac972e64
# ╟─5c0901a0-c194-11ec-306c-a3c8b39c186b
# ╠═5c090862-c194-11ec-1c1d-fffeba0292c5
# ╟─5c0908b2-c194-11ec-0ab7-8dc316e09438
# ╟─5c0909d4-c194-11ec-14a9-ef7d1eb1a223
# ╟─5c090a38-c194-11ec-06be-f1b11f4b12e8
# ╟─5c090a94-c194-11ec-0b65-dd156b1d78c4
# ╠═5c090f88-c194-11ec-37c1-2ddf900d6a1c
# ╟─5c090fc2-c194-11ec-2f88-b9d01edc5e32
# ╟─5c09106e-c194-11ec-15ea-1fab2923a1fc
# ╠═5c0943e0-c194-11ec-1116-8bc39c03b3dd
# ╟─5c094494-c194-11ec-06e8-6d971d08295d
# ╟─5c0944ee-c194-11ec-3842-7b2482a4d20d
# ╠═5c095024-c194-11ec-0401-2d012b9fd043
# ╟─5c0951dc-c194-11ec-293b-d94edd15a004
# ╠═5c095808-c194-11ec-3c32-41a3c0ae24a2
# ╟─5c095862-c194-11ec-22a4-cbba9aa8fcf1
# ╟─5c095894-c194-11ec-0a4f-17218f8da70d
# ╠═5c095de4-c194-11ec-1e50-456ef5727c94
# ╟─5c095e48-c194-11ec-1d4a-3f7bae50dfa2
# ╟─5c095e70-c194-11ec-22e4-2b82f8e12849
# ╟─5c095ef2-c194-11ec-0505-81f21ba86ef0
# ╟─5c095efa-c194-11ec-285f-f9b0accefb3a
# ╠═5c09643a-c194-11ec-0fee-f3404cc85b6b
# ╟─5c096468-c194-11ec-0076-7bd7d03f9c9e
# ╟─5c098436-c194-11ec-307d-231d627797e7
# ╠═5c098f12-c194-11ec-227e-95d4e2098f2b
# ╟─5c098fee-c194-11ec-0628-c1dc50510d76
# ╟─5c09906e-c194-11ec-27df-5796341da0f3
# ╟─5c0990ac-c194-11ec-24be-4bfde7e757f6
# ╟─5c0990de-c194-11ec-0628-83966e8b3e44
# ╠═5c099a84-c194-11ec-002d-af838f7686c8
# ╟─5c099ade-c194-11ec-12e2-876546ebc307
# ╟─5c099b24-c194-11ec-0631-93b2be0d0f12
# ╟─5c099b42-c194-11ec-26aa-3d7117fb71c5
# ╠═5c099ee4-c194-11ec-3aa3-61203f6e0390
# ╟─5c099ef8-c194-11ec-2b0c-a1dbcde8a614
# ╠═5c09bea6-c194-11ec-13bf-bba80fc21041
# ╟─5c09bf78-c194-11ec-0318-99aedbc5a0eb
# ╠═5c09c50e-c194-11ec-2333-e3ec897eaaaf
# ╟─5c09c54a-c194-11ec-3ee2-cbbda322b971
# ╠═5c09c7a2-c194-11ec-23c4-331a29627806
# ╟─5c09c7de-c194-11ec-0a36-f93ddfd61187
# ╠═5c09ca36-c194-11ec-01ac-2d73cb8d6adb
# ╟─5c09ca72-c194-11ec-380c-af41fe49e91a
# ╠═5c09cd42-c194-11ec-1ddc-b3a603b6fc82
# ╠═5c09cea0-c194-11ec-051e-9b0e991b4288
# ╟─5c09cee6-c194-11ec-0439-7bd05c8dbf6b
# ╠═5c09d170-c194-11ec-1f76-a7944d469d06
# ╟─5c09d1a2-c194-11ec-1152-6fafba36569b
# ╠═5c09d882-c194-11ec-0252-c75bb10ba03b
# ╟─5c09d8be-c194-11ec-14c4-5929577c081d
# ╟─5c09d8f0-c194-11ec-31e8-2dbbe1a8f6cb
# ╟─5c09d9e0-c194-11ec-3969-e980ea866f0d
# ╠═5c09de10-c194-11ec-0bc3-f1bddcc2cd65
# ╟─5c09de4a-c194-11ec-1f39-39ce02a933f8
# ╟─5c09def4-c194-11ec-108a-2fcad6d36474
# ╠═5c09e264-c194-11ec-1db6-fd98cc37542b
# ╟─5c09e276-c194-11ec-01e7-d74b82c58be8
# ╟─5c09e2da-c194-11ec-22e1-0bf529b8afc3
# ╠═5c09ebc4-c194-11ec-1986-b385c95cc12e
# ╟─5c09ec32-c194-11ec-1a79-a35245dd38c0
# ╠═5c09f010-c194-11ec-3073-e195d0f110ad
# ╟─5c09f060-c194-11ec-2899-d77a1060c125
# ╠═5c09f3e4-c194-11ec-11c9-895d098b153a
# ╟─5c09f40c-c194-11ec-0860-b749a791f09b
# ╠═5c09f5ec-c194-11ec-397d-373a3d625577
# ╟─5c09f61e-c194-11ec-0c14-0357d63157da
# ╠═5c09fa4c-c194-11ec-3d6a-6b52b7e68c0e
# ╟─5c09fa7e-c194-11ec-32c0-f9fef57e204d
# ╟─5c09faba-c194-11ec-34e5-03fe86148187
# ╠═5c09fd12-c194-11ec-114f-1fb7b661b32b
# ╟─5c09fd44-c194-11ec-1630-571ba2d1e4e9
# ╟─5c09fdda-c194-11ec-0930-692b599d0a42
# ╠═5c0a00e6-c194-11ec-240a-87348e77f7f0
# ╟─5c0a0136-c194-11ec-25ad-d3f0c9d5b77f
# ╠═5c0a037a-c194-11ec-210d-2905d796fdb2
# ╟─5c0a03c0-c194-11ec-289c-17f30a632222
# ╠═5c0a0726-c194-11ec-0940-43a8dbd77a83
# ╟─5c0a0758-c194-11ec-2e66-7bb816940c45
# ╟─5c0a076c-c194-11ec-095f-09c387af9f63
# ╟─5c0a079e-c194-11ec-2db8-2d93a1bec91a
# ╠═5c0a0c10-c194-11ec-2771-55a1456b112a
# ╟─5c0a14a0-c194-11ec-21ea-d156e06375f2
# ╟─5c0a14c8-c194-11ec-36aa-ff8ffe2dc536
# ╠═5c0a19aa-c194-11ec-187a-07a45aa40e53
# ╟─5c0a19c8-c194-11ec-028b-d59567a8063e
# ╠═5c0a215c-c194-11ec-118a-613d912be193
# ╟─5c0a2196-c194-11ec-22a3-1771fc7d07ac
# ╟─5c0a21d4-c194-11ec-2f6a-7fca84bfde1a
# ╟─5c0a2256-c194-11ec-13d2-819bbc0f0a19
# ╠═5c0a27c4-c194-11ec-2731-f1877b350f59
# ╟─5c0a280c-c194-11ec-2196-ebe947124ee9
# ╠═5c0a2d5a-c194-11ec-0cb5-793419da5c7c
# ╟─5c0a2d96-c194-11ec-09fe-8da5438c0ad6
# ╠═5c0a2fbc-c194-11ec-0b59-577040e0c2c9
# ╟─5c0a2fda-c194-11ec-1f67-8fc307ea6fe9
# ╠═5c0a34b4-c194-11ec-3eb0-1da30e853d88
# ╟─5c0a34ee-c194-11ec-3250-0f5c310585a3
# ╠═5c0a37c8-c194-11ec-2ba0-2d925666a5dc
# ╟─5c0a3856-c194-11ec-1c47-d3ec9472bc68
# ╠═5c0a3b7e-c194-11ec-186c-fdf00f9ccb3c
# ╟─5c0a6c48-c194-11ec-0e30-bb209a5c3198
# ╟─5c0a6d38-c194-11ec-03f8-4fe856ea8194
# ╟─5c0a6de2-c194-11ec-2e21-b3f5bb04bc0d
# ╠═5c0a7382-c194-11ec-0b10-c9861c07a559
# ╟─5c0a811c-c194-11ec-2245-bd01907efed2
# ╟─5c0a8296-c194-11ec-0813-519a125f8708
# ╟─5c0a832c-c194-11ec-28f8-5f56e13ea77e
# ╠═5c0a8746-c194-11ec-3b14-338fcdd63627
# ╟─5c0a878c-c194-11ec-1375-f7db641a445a
# ╠═5c0a8f7a-c194-11ec-17ba-ef1dc63dc890
# ╟─5c0a8fbe-c194-11ec-1376-c73c3920ced5
# ╠═5c0a968c-c194-11ec-055a-579b9f0457a7
# ╟─5c0aa96a-c194-11ec-24d3-2da0173cee6a
# ╟─5c0aa9c4-c194-11ec-0101-5f265de7224d
# ╟─5c0b69b8-c194-11ec-32bc-3fb973357cb1
# ╟─5c0b6ba2-c194-11ec-2330-a97bd77dfa75
# ╟─5c0b6bde-c194-11ec-01ee-af5cb4115f92
# ╠═5c0b7868-c194-11ec-38f0-35d716c9c440
# ╟─5c0b78fe-c194-11ec-1725-c759e9f67d69
# ╟─5c0b7926-c194-11ec-2da4-39e49562428c
# ╠═5c0b7d90-c194-11ec-05cb-c9aba53e0bfb
# ╟─5c0b7e12-c194-11ec-2e35-f1aa2252e35f
# ╟─5c0b7e58-c194-11ec-08b1-33d9342b3b2f
# ╠═5c0b8574-c194-11ec-1dc6-9fcc14e2d6c7
# ╟─5c0b85da-c194-11ec-3b57-ff74c8e3dce8
# ╟─5c0b869e-c194-11ec-2fa1-37628912d561
# ╟─5c0b86e6-c194-11ec-28b3-f5b7f7434eeb
# ╟─5c0b8722-c194-11ec-1082-7d90bb2bbaad
# ╠═5c0bb472-c194-11ec-2d2a-e5c6b198a38d
# ╟─5c0bb6a2-c194-11ec-329b-c98c84fc044c
# ╠═5c0bc0f4-c194-11ec-23f9-ab5b3c5454e9
# ╟─5c0bc1ba-c194-11ec-058e-e31699b8519e
# ╠═5c0bca8e-c194-11ec-1bbd-d34d9de45ca7
# ╟─5c0bcac0-c194-11ec-328f-adf46cede86e
# ╠═5c0bd1dc-c194-11ec-1780-c783aff7bbb2
# ╟─5c0bd218-c194-11ec-2841-fb5b144765b9
# ╠═5c0bd970-c194-11ec-03a1-1d254571db1a
# ╟─5c0bd9b6-c194-11ec-21bf-1f76ea3f5fa1
# ╠═5c0bdd08-c194-11ec-20ee-9d6155e44c68
# ╟─5c0bdd82-c194-11ec-27b0-f55fc88acee1
# ╟─5c0bde02-c194-11ec-1527-6b8f589e743c
# ╠═5c0be3ac-c194-11ec-2613-c104ce7b4083
# ╟─5c0be460-c194-11ec-25f2-e13abd93cc5c
# ╟─5c0be4a6-c194-11ec-3100-27bf78994e6c
# ╟─5c0be4ea-c194-11ec-1b2a-634ab44501c2
# ╠═5c0bec30-c194-11ec-28b9-210aff14c949
# ╟─5c0bec76-c194-11ec-293d-31ff5027fd16
# ╠═5c0bf02a-c194-11ec-2504-657f69cea3a4
# ╟─5c0bf086-c194-11ec-098c-c981969876ff
# ╟─5c0bf0ce-c194-11ec-217b-4ff7db9b3731
# ╠═5c0bf2c8-c194-11ec-39ba-194a7ee7b827
# ╠═5c0bf5e0-c194-11ec-0202-cddab2e13427
# ╟─5c0bf6a8-c194-11ec-1b17-0943e45e1068
# ╠═5c0bfa86-c194-11ec-1c5c-5befc5ba97f1
# ╟─5c0bfaf4-c194-11ec-19dc-5d7c43953ddd
# ╟─5c0bfb1c-c194-11ec-3201-552ba01763a3
# ╟─5c0bfb4e-c194-11ec-32a8-7535b6d93cb3
# ╠═5c0c00ee-c194-11ec-1891-e1b2c0720b55
# ╟─5c0c0166-c194-11ec-39e8-9b0c1360738d
# ╠═5c0c0512-c194-11ec-3efb-69a8682d73c8
# ╟─5c0c0550-c194-11ec-3e5d-5beaf2380fb0
# ╟─5c0c058a-c194-11ec-2107-810849a0ce65
# ╟─5c0c05d0-c194-11ec-0c10-af8ebde883b9
# ╠═5c0c0ed6-c194-11ec-1b64-0f10de13d347
# ╟─5c0c0f12-c194-11ec-3eed-816329f5e202
# ╠═5c0c132e-c194-11ec-3dff-dd62fb126553
# ╟─5c0c1340-c194-11ec-3740-f9bf76ae961e
# ╠═5c0c17dc-c194-11ec-31c9-41db845a9c6f
# ╟─5c0c1804-c194-11ec-1a29-4baa863cd5df
# ╟─5c0c182c-c194-11ec-18d8-ddfb2199350f
# ╟─5c0c18a4-c194-11ec-3887-8b735d3fff44
# ╟─5c0c18ce-c194-11ec-0f52-f925e5cbdc27
# ╠═5c0c1e3c-c194-11ec-3d62-8b15bc48eaa4
# ╟─5c0c1e94-c194-11ec-3426-9d3a31d149f8
# ╠═5c0c22e0-c194-11ec-181c-d3f58172e1fb
# ╟─5c0c22f4-c194-11ec-14fe-6195c5a59bfa
# ╠═5c0c2754-c194-11ec-10fc-235300bc1dd0
# ╟─5c0c279a-c194-11ec-25ce-63a5e64c5d6b
# ╟─5c0c27cc-c194-11ec-2013-43b13264ee43
# ╠═5c0c2b96-c194-11ec-2f4f-93e84ed701cd
# ╟─5c0c2bd2-c194-11ec-3484-3f408ffb3b39
# ╠═5c0c2dc6-c194-11ec-36b9-e7b0d68375d0
# ╟─5c0c2e02-c194-11ec-1f12-c11605fc0e20
# ╠═5c0c489c-c194-11ec-139c-13224eea7961
# ╟─5c0c4908-c194-11ec-3009-4b7865a8fe33
# ╠═5c0c4f40-c194-11ec-0542-8de8d62b5728
# ╟─5c0c4ffe-c194-11ec-26c2-afa3b8c596ad
# ╟─5c0c5058-c194-11ec-1acd-d36a2f721082
# ╠═5c0c5718-c194-11ec-1ae0-3d8e607cf560
# ╟─5c0c576a-c194-11ec-1c2d-e183474f79f0
# ╟─5c0c5792-c194-11ec-1cd2-9df7cbebd307
# ╟─5c0c57b0-c194-11ec-090f-8112141e4848
# ╠═5c0c5c86-c194-11ec-3763-89f6f98e83e4
# ╟─5c0c5cf8-c194-11ec-350a-41a8deaa9c96
# ╟─5c0c5d3c-c194-11ec-2fb5-694daa4f4f48
# ╠═5c0c63ea-c194-11ec-3462-6b5a3cd0a7cb
# ╟─5c0c641c-c194-11ec-3fe3-0bf4ae8bcd57
# ╠═5c0c8ec4-c194-11ec-10dc-19c8f7fcd14b
# ╟─5c0c8fbe-c194-11ec-0246-97873c3c3640
# ╟─5c0c9066-c194-11ec-156e-f323fee6285d
# ╠═5c0c9928-c194-11ec-2a7b-7fe64124f4ed
# ╟─5c0c9996-c194-11ec-2749-b7b88c76886d
# ╠═5c0c9cf2-c194-11ec-2238-8395dd15f098
# ╟─5c0c9d38-c194-11ec-0094-6d3843a0fe1e
# ╠═5c0ca152-c194-11ec-09a1-1b109a0fdd0c
# ╟─5c0ca274-c194-11ec-0835-55b2f0baaf89
# ╟─5c0ca2c4-c194-11ec-31f0-6d3f5f2dd8ca
# ╠═5c0cac38-c194-11ec-1a68-8beaa376ca9f
# ╟─5c0cac6a-c194-11ec-19d2-c7607af347a8
# ╟─5c0cace2-c194-11ec-1370-595509e78083
# ╠═5c0cb246-c194-11ec-0570-0bfc9be0c766
# ╟─5c0cb2aa-c194-11ec-1d91-b3f5c81c8c60
# ╠═5c0ce040-c194-11ec-0f6c-b11450187f54
# ╟─5c0ce216-c194-11ec-2fec-11fe640c7765
# ╟─5c0ce2b6-c194-11ec-3ac2-c1e08aa8a78c
# ╠═5c0ceb58-c194-11ec-1161-8f7f5ced1f9f
# ╟─5c0cebb4-c194-11ec-16ed-070661e16f26
# ╠═5c0d1f60-c194-11ec-30c0-1b3680018d01
# ╟─5c0d2058-c194-11ec-04e1-e54fb5c14b2f
# ╟─5c0d20aa-c194-11ec-1d17-4da1932c5908
# ╠═5c0d2884-c194-11ec-111b-e71b3d48126e
# ╟─5c0d291a-c194-11ec-2ed3-f187a2f5b535
# ╠═5c0d2e68-c194-11ec-3b4a-8bb841662b3a
# ╟─5c0d2f96-c194-11ec-1e2e-5de683c2537f
# ╟─5c0d2fc8-c194-11ec-2b58-3b639f106167
# ╠═5c0d36c6-c194-11ec-2780-358385dff332
# ╟─5c0d3718-c194-11ec-153a-b3c9437e96a2
# ╠═5c0d3e78-c194-11ec-247a-33c2706227dc
# ╟─5c0d3ed2-c194-11ec-2615-b972f1e15614
# ╠═5c0d69d4-c194-11ec-1118-6fd9351d03d2
# ╟─5c0d6aec-c194-11ec-0dce-cf5b09a4c72a
# ╠═5c0d706e-c194-11ec-38df-db1422c8258d
# ╟─5c0d7172-c194-11ec-0600-2b25e5d2456c
# ╟─5c0d71ae-c194-11ec-2b23-53464b8d15ae
# ╟─5c0d71f4-c194-11ec-21fc-4789e1f5de39
# ╠═5c0d74d8-c194-11ec-27c7-c39ae0bc1949
# ╟─5c0d75f0-c194-11ec-0a33-8d6b468d79fc
# ╟─5c0d762c-c194-11ec-030b-3d736c456fb3
# ╠═5c0d791a-c194-11ec-1fd3-2f8e248dc96e
# ╟─5c0d794c-c194-11ec-3d5b-a911c6a6d824
# ╟─5c0d7960-c194-11ec-0046-c50eae497856
# ╠═5c0d822a-c194-11ec-2c5a-4dcbfac27e79
# ╟─5c0d8284-c194-11ec-0c00-af194b901e27
# ╟─5c0d82fc-c194-11ec-2bcb-35b8dc7e3ee7
# ╠═5c0d8b12-c194-11ec-1bb5-1b6ba5a9bcad
# ╟─5c0d8b4c-c194-11ec-0947-edbccdc8e000
# ╟─5c0d8b8a-c194-11ec-2f75-0f6acd41c052
# ╠═5c0d91fc-c194-11ec-18e5-51eb0553485a
# ╟─5c0d92d8-c194-11ec-2997-9b280fed6b25
# ╟─5c0d9346-c194-11ec-3012-cf96515f2211
# ╠═5c0d9a1c-c194-11ec-33aa-d15cb71b9c67
# ╟─5c0d9a60-c194-11ec-3816-f1069c368cc8
# ╠═5c0dca00-c194-11ec-371b-9fcd75d230a7
# ╟─5c0dcb36-c194-11ec-2156-c3791ddd89d0
# ╟─5c0dcb9a-c194-11ec-2972-cb17e01f603e
# ╟─5c0dcbb8-c194-11ec-03d5-1bf548daffbf
# ╠═5c0dd392-c194-11ec-2788-eb2ab0756e0c
# ╟─5c0dd444-c194-11ec-004e-cd589a26aa66
# ╠═5c0de2ce-c194-11ec-1fee-e56a9fbf8333
# ╟─5c0de314-c194-11ec-2969-d34e52ae321b
# ╟─5c0de358-c194-11ec-005b-6f0c29076db8
# ╟─5c0de396-c194-11ec-0660-a3df923828cb
# ╠═5c0dea26-c194-11ec-162c-219b88c3d514
# ╟─5c0deb3e-c194-11ec-32e6-4f9b9ca0a18f
# ╟─5c0deb70-c194-11ec-1cb4-9d7d0e37a457
# ╟─5c0debac-c194-11ec-17d6-7d189b600815
# ╟─5c0debf2-c194-11ec-2405-c7ccf84b749f
# ╠═5c0df3d4-c194-11ec-27b2-990f87b352ff
# ╟─5c0df412-c194-11ec-15f7-4f305aa18135
# ╠═5c0dfa34-c194-11ec-357e-2df3a2bbb540
# ╟─5c0dfa5c-c194-11ec-2ed3-9bf12837fd6d
# ╟─5c0dfaa2-c194-11ec-1d61-ab700dccafef
# ╠═5c0e430c-c194-11ec-395f-45fb65deecbb
# ╟─5c0e43a4-c194-11ec-2800-8502d494fad2
# ╠═5c0e4a70-c194-11ec-058d-637d14b2368a
# ╟─5c0e4ba6-c194-11ec-03a8-8f3f1c28e4dc
# ╟─5c0e4c46-c194-11ec-2a45-697c84f3ca42
# ╠═5c0e561e-c194-11ec-0ba0-49261a8f584c
# ╟─5c0e568a-c194-11ec-03f0-0d3789b22d70
# ╠═5c0ebf14-c194-11ec-0f77-a7e1a9739799
# ╟─5c0ebfe4-c194-11ec-0fd2-7179c561757d
# ╠═5c0ecb24-c194-11ec-3955-6b0f84baf342
# ╟─5c0ecb4e-c194-11ec-09e6-39556e0d367b
# ╠═5c0ed2d8-c194-11ec-2ddf-b9f65db85b20
# ╟─5c0ed302-c194-11ec-22b2-db70cb9b214f
# ╠═5c0ed870-c194-11ec-016f-8f536a5b1945
# ╟─5c0ed902-c194-11ec-2a5e-1fa20a4738aa
# ╟─5c0ed90e-c194-11ec-17e8-8fa5611fcee2
# ╟─5c0ed918-c194-11ec-0edd-7b5b870752da
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
