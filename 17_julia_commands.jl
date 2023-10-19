### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ d96c1324-53c3-11ec-17e8-33d09badd066
using Pkg

# ╔═╡ d86e8e0c-53c3-11ec-09e6-43dbdb09c93c
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :julia_overview
	nothing
end

# ╔═╡ d98a7a58-53c3-11ec-32d3-c78ddc63810a
using Plots

# ╔═╡ d990f41e-53c3-11ec-24bd-5b83dccfeb63
using SymPy

# ╔═╡ d991259c-53c3-11ec-0188-49395d2a327c
using PlutoUI

# ╔═╡ d9912466-53c3-11ec-31f9-7b394b47802d
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ d83684d0-53c3-11ec-31e7-578be34c7f2c
md"""# Overview of Julia commands
"""

# ╔═╡ d887af02-53c3-11ec-384f-35a30843e970
md"""The [`Julia`](http://www.julialang.org) programming language is well suited as a computer accompaniment while learning the concepts of calculus. The following overview covers the language-specific aspects of the pre-calculus part of the [Calculus with Julia](calculuswithjulia.github.io) notes.
"""

# ╔═╡ d88e5a66-53c3-11ec-0d2a-b91aead8578f
md"""## Installing `Julia`
"""

# ╔═╡ d89187d8-53c3-11ec-149f-6f76f9876a1f
md"""`Julia` is an *open source* project which allows anyone with a supported  computer to use it. To install locally, the [downloads](https://julialang.org/downloads/) page has several different binaries for installation. Additionally, the downloads page contains a link to a docker image.  For Microsoft Windows, the new [juilaup](https://github.com/JuliaLang/juliaup) installer may be of interest; it is available from the Windows Store. `Julia` can also be compiled from source.
"""

# ╔═╡ d891884e-53c3-11ec-2f9b-2f54e16c84da
md"""`Julia` can also be run through the web. The [https://mybinder.org/](https://mybinder.org/) service in particular allows free access, though limited in terms of allotted memory and with a relatively short timeout for inactivity.
"""

# ╔═╡ d8918876-53c3-11ec-2609-3de6793ee6f3
md"""[Launch Binder](https://mybinder.org/v2/gh/CalculusWithJulia/CwJScratchPad.git/master)
"""

# ╔═╡ d8918998-53c3-11ec-2896-7b5574b8ecd3
md"""## Interacting with `Julia`
"""

# ╔═╡ d893da7c-53c3-11ec-1522-7fa512a968cf
md"""The html version of the **Calculus With Julia** notes are formatted as Pluto notebooks. `Pluto` is one of many different means for a user to interact with a `Julia` process.
"""

# ╔═╡ d8957a1c-53c3-11ec-07ce-3711f81c3585
md"""At a basic level, `Julia` provides a means to read commands or instructions, evaluate those commands, and then print or return those commands. At a user level, there are many different ways to interact with the reading and printing. For example:
"""

# ╔═╡ d95bb056-53c3-11ec-296a-9bb93444bf58
md"""  * The REPL. The `Julia` terminal is the built-in means to interact with `Julia`. A `Julia` Terminal has a command prompt, after which commands are typed and then sent to be evaluated by the `enter` key. The terminal may look something like the following where `2+2` is evaluated:
"""

# ╔═╡ d9607d84-53c3-11ec-1422-bbe6456ed8ed
md"""---
"""

# ╔═╡ d96081c6-53c3-11ec-3b43-110184f3b100
md"""```
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.7.0 (2021-11-30)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> 2 + 2
4
```"""

# ╔═╡ d9608234-53c3-11ec-0887-e126adc198e6
md"""---
"""

# ╔═╡ d960913e-53c3-11ec-2b59-b5b9ac79a0de
md"""  * An IDE. For programmers, an integrated development environment is often used to manage bigger projects. `Julia` has `Juno` and `VSCode`.
  * A notebook. The [Project Juptyer](https://jupyter.org/) provides a notebook interface for interacting with `Julia` and a more `IDE` style `jupyterlab` interface. A jupyter notebook has cells where commands are typed and immediately following is the printed output returned by `Julia`. The output of a cell depends on the state of the kernel when the cell is computed, not the order of the cells in the notebook. Cells have a number attached, showing the execution order. The `Juypter` notebook is used by `binder` and can be used locally through the `IJulia` package. This notebook has the ability to display many different types of outputs in addition to plain text, such as images, marked up math text, etc.
  * The [Pluto](https://github.com/fonsp/Pluto.jl) package provides a *reactive* notebook interface. Reactive means when one "cell" is modified and executed, the new values cascade to all other dependent cells which in turn are updated. This is very useful for exploring a parameter space, say. These html pages are formatted as `Pluto` notebooks, which makes them able to be easily run on the reader's desktop.
"""

# ╔═╡ d9609274-53c3-11ec-1aaa-4d976b9648d6
md"""The `Pluto` interface has some idiosyncracies that need explanation:
"""

# ╔═╡ d96bb5c8-53c3-11ec-3d09-9d04e7fa0146
md"""  * Cells can only have one command within them. Multiple-command cells must be contained in a `begin` block or a `let` block.
  * By default, the cells are *reactive*. This means when a variable in one cell is changed, then any references to that variable are also updated – like a spreadsheet. This is fantastic for updating several computations at once. However it means variable names can not be repeated within a page. Pedagogically, it is convenient to use variable names and function names (e.g., `x` and `f`) repeatedly, but this is only possible *if* they are within a `let` block or a function body.
  * To not repeat names, but to be able to reference a value from cell-to-cell,  some unicode variants are used within a page. Visually these look familiar, but typing the names requires some understanding of unicode input. The primary usages is *bold italic* (e.g., `\bix[tab]` or `\bif[tab]`) or *bold face* (e.g. `\bfx[tab]` or `bff[tab]`).
  * The notebooks snapshot the packages they depend on, which is great for reproducability, but may mean older versions are silently used.
"""

# ╔═╡ d96bb86e-53c3-11ec-2836-5584cdefb263
md"""## Augmenting base `Julia`
"""

# ╔═╡ d96bb8ac-53c3-11ec-3b16-2f1dd8e2370a
md"""The base `Julia` installation has many features, but leaves many others to `Julia`'s package ecosystem. These notes use packages to provide plotting, symbolic math, access to special functions, numeric routines, and more.
"""

# ╔═╡ d96bb8d4-53c3-11ec-1db1-fdd2dad39f24
md"""Within `Pluto`, using add-on packages is very simple, as `Pluto` downloads and installs packages when they are requested through a `using` or `import` directive.
"""

# ╔═╡ d96bb8f2-53c3-11ec-28ec-bb27638f409b
md"""---
"""

# ╔═╡ d96bb912-53c3-11ec-3d36-6f35272036b6
md"""For other interfaces to `Julia` some more detail is needed.
"""

# ╔═╡ d96bb924-53c3-11ec-32b0-f9cd2039ea98
md"""The `Julia` package manager makes add-on packages very easy to install.
"""

# ╔═╡ d96bb96a-53c3-11ec-14bf-b9132c8a0887
md"""Julia comes with just a few built-in packages, one being `Pkg` which manages subsequent package installation. To add more packages, we first must *load* the `Pkg` package. This is done by issuing the following command:
"""

# ╔═╡ d96c13d8-53c3-11ec-18b5-2f16fd71ada9
md"""The `using` command loads the specified package and makes all its *exported* values available for direct use. There is also the `import` command which allows the user to select which values should be imported from the package, if any, and otherwise gives access to the new functionality through the dot syntax.
"""

# ╔═╡ d96c13f6-53c3-11ec-0700-ab746858465f
md"""Packages need to be loaded just once per session.
"""

# ╔═╡ d96c140a-53c3-11ec-16f2-05cc25d3c00f
md"""To use `Pkg` to "add" another package, we would have a command like:
"""

# ╔═╡ d96c146e-53c3-11ec-18ec-ed6938c7ae5f
md"""```
Pkg.add("CalculusWithJulia")
```"""

# ╔═╡ d96c152c-53c3-11ec-1bfe-01d118ad8dfd
md"""This command instructs `Julia` to look at its *general registry* for the `CalculusWithJulia.jl` package, download it, then install it. Once installed, a package only  needs to be brought into play with the `using` or `import` commands.
"""

# ╔═╡ d96c3b6a-53c3-11ec-0db7-f5a91c8eb003
note("""
In a terminal setting, there is a package mode, entered by typing `]` as the leading character and exited by entering `<delete>` at a blank line. This mode allows direct access to `Pkg` with a simpler syntax. The command above would be just `add CalculusWithJulia`.)
""")

# ╔═╡ d96c3bf6-53c3-11ec-23b8-dd7f177a1811
md"""Packages can be updated through the command `Pkg.up()`, and removed with `Pkg.rm(pkgname)`.
"""

# ╔═╡ d96c3c1c-53c3-11ec-136f-8d786fb874c5
md"""By default packages are installed in a common area. It may be desirable to keep packages for projects isolated. For this the `Pkg.activate` command can be used. This feature allows a means to have reproducible environments even if `Julia` or the packages used are upgraded, possibly introducing incompatabilities.
"""

# ╔═╡ d96c3c3c-53c3-11ec-3ce8-29c0edb7638b
md"""For these notes, the following packages, among others, are used:
"""

# ╔═╡ d96c3ca0-53c3-11ec-2f9c-c59c91821e3a
md"""```
Pkg.add("CalculusWithJulia") # for some simplifying functions and a few packages (SpecialFunctions, ForwardDiff)
Pkg.add("Plots")  # for basic plotting
Pkg.add("SymPy")  # for symbolic math
Pkg.add("Roots")  # for solving  `f(x)=0`
Pkg.add("QuadGk") # for integration
Pkg.add("HQuadrature") # for higher-dimensional integration
```"""

# ╔═╡ d96c3d72-53c3-11ec-364c-23aed42d98d7
md"""## `Julia` commands
"""

# ╔═╡ d96c3d9a-53c3-11ec-3ef7-7b515021c651
md"""In `Pluto`, commands are typed into a notebook cell:
"""

# ╔═╡ d96c4e20-53c3-11ec-070d-91377bfa0ea0
2 + 2   # use shift-enter to evaluate

# ╔═╡ d96c4e8e-53c3-11ec-0c59-a593991ae10c
md"""Commands are executed by using `shift-enter` or the run button at the bottom right of a cell.
"""

# ╔═╡ d96c4eb6-53c3-11ec-3915-5b51ca8c000c
md"""Multiple commands per cell are possible if a `begin` or `let` block is used. Commands may be separated by new lines or semicolons.
"""

# ╔═╡ d96c4f24-53c3-11ec-0173-bb2234efb2b8
md"""On a given line, anything **after** a `#` is a *comment* and is not processed.
"""

# ╔═╡ d96c4f74-53c3-11ec-0d6f-df6628c1dc09
md"""The results of the last command executed will be displayed in an output area. Separating values by commas allows more than one value to be displayed.  Plots are displayed when the plot object is returned by the  last executed command.
"""

# ╔═╡ d96c4f9c-53c3-11ec-3b0c-610dfb6e18d4
md"""The state of a Pluto notebook is a result of all the cells in the notebook being executed. The cell order does not impact this and can be rearranged by the user.
"""

# ╔═╡ d96c4fba-53c3-11ec-21c0-7db76c555a80
md"""## Numbers, variable types
"""

# ╔═╡ d96c4fec-53c3-11ec-2081-43b2e9f579d9
md"""`Julia` has many different number types beyond the floating point type employed by most calculators. These include
"""

# ╔═╡ d96c51e0-53c3-11ec-16a1-6f849fe1725a
md"""  * Floating point numbers: `0.5`
  * Integers: `2`
  * Rational numbers: `1//2`
  * Complex numbers `2 + 0im`
"""

# ╔═╡ d9741b14-53c3-11ec-09cc-177800a80a96
md"""`Julia`'s parser finds the appropriate type for the value, when read in. The following all create the number $1$ first as an integer, then a rational, then a floating point number, again as floating point number, and finally as a complex number:
"""

# ╔═╡ d9742c94-53c3-11ec-2356-7de3a2c8952d
1, 1//1, 1.0, 1e0, 1 + 0im

# ╔═╡ d9742d16-53c3-11ec-3809-c32840bc318e
md"""As much as possible, operations involving  certain types of numbers will produce output of a given type. For example, both of these divisions produce a floating point answer, even though  mathematically, they need not:
"""

# ╔═╡ d9743298-53c3-11ec-3240-fd8d51217a2c
2/1, 1/2

# ╔═╡ d974336a-53c3-11ec-3e8e-59f3cab54d9f
md"""Some powers with negative bases, like `(-3.0)^(1/3)`, are not defined. However, `Julia` provides the special-case function `cbrt` (and `sqrt`) for handling these.
"""

# ╔═╡ d9743392-53c3-11ec-1239-31ef2b303b30
md"""Integer operations may silently overflow, producing odd answers, at first glance:
"""

# ╔═╡ d9743766-53c3-11ec-1c9b-07f851bc059e
2^64

# ╔═╡ d97437a2-53c3-11ec-31b5-c7bff61f30c3
md"""(Though the output is predictable, if overflow is taken into consideration appropriately.)
"""

# ╔═╡ d97437ca-53c3-11ec-2533-cd3b6dfb79d2
md"""When different types of numbers are mixed, `Julia` will usually promote the values to a common type before the operation:
"""

# ╔═╡ d9743e5a-53c3-11ec-26c9-71e339b0b142
(2 + 1//2) + 0.5

# ╔═╡ d9743ebe-53c3-11ec-012f-f979cad7f5f3
md"""`Julia` will first add `2` and `1//2` promoting `2` to rational before doing so. Then add the result, `5//2` to `0.5` by promoting `5//2` to the floating point number `2.5` before proceeding.
"""

# ╔═╡ d9743ee6-53c3-11ec-079a-858dd186751c
md"""`Julia` uses a special type to store a handful of irrational constants such as `pi`. The special type allows these constants to be treated without round off, until they mix with other floating point numbers. There are some functions that require these be explicitly promoted to floating point. This can be done by calling `float`.
"""

# ╔═╡ d9743f24-53c3-11ec-0e98-854ddea72682
md"""The standard mathematical operations are implemented by `+`, `-`, `*`, `/`, `^`. Parentheses are used for grouping.
"""

# ╔═╡ d981e9c4-53c3-11ec-128f-f58e9cab2694
md"""### Vectors
"""

# ╔═╡ d981ee4c-53c3-11ec-2ea4-53500349a34c
md"""A vector is an indexed collection of similarly typed values. Vectors can be constructed with square brackets (syntax for concatenation):
"""

# ╔═╡ d981ff86-53c3-11ec-2a01-15d2220e20f2
[1,1,2,3,5,8]

# ╔═╡ d98201d4-53c3-11ec-1a9e-1d7416966c9a
md"""Values will be promoted to a common type (or type `Any` if none exists). For example, this vector will have type `Float64` due to the `1/3` computation:
"""

# ╔═╡ d98210fa-53c3-11ec-3533-97cbb58c663c
[1, 1//2, 1/3]

# ╔═╡ d982114c-53c3-11ec-3824-7b3da4fc9974
md"""(Vectors are used as a return type from some functions, as such, some familiarity is needed.)
"""

# ╔═╡ d9821160-53c3-11ec-20f5-a3baa48be3a7
md"""Regular arithmetic sequences can be defined by either:
"""

# ╔═╡ d9821674-53c3-11ec-0dcc-913f0dfec96d
md"""  * Range operations:  `a:h:b` or `a:b` which produces a generator of values starting at `a` separated by `h` (`h` is `1` in the last form) until they reach `b`.
  * The `range` function: `range(a, b, length=n)` which produces a generator of `n` values between `a` and `b`;
"""

# ╔═╡ d9821700-53c3-11ec-23c4-8bc4f4a0b7b8
md"""These constructs return range objects. A range object *compactly* stores the values it references. To see all the values, they can be collected with the `collect` function, though this is rarely needed in practice.
"""

# ╔═╡ d982171e-53c3-11ec-0561-b9c8443a1884
md"""Random sequences are formed by `rand`, among others:
"""

# ╔═╡ d9821ce6-53c3-11ec-187b-b917d0df2ba4
rand(3)

# ╔═╡ d98227fe-53c3-11ec-3437-c9d0de17f549
md"""The call `rand()` returns a single random number (in $[0,1)$.)
"""

# ╔═╡ d982284c-53c3-11ec-3520-23afec8e88a2
md"""## Variables
"""

# ╔═╡ d9822876-53c3-11ec-10bf-cfe6a54e0afc
md"""Values can be assigned variable names, with `=`. There are some variants
"""

# ╔═╡ d9825f94-53c3-11ec-335f-5b2ad5b76ed7
begin
	u = 2
	a_really_long_name = 3
	a0, b0 = 1, 2    # multiple assignment
	a1 = a2 = 0      # chained assignment, sets a2 and a1 to 0
end

# ╔═╡ d9826064-53c3-11ec-2239-810789d2cdac
md"""The names can be short, as above, or more verbose. Variable names can't start with a number, but can include numbers. Variables can also include [unicode](../misc/unicode.html) or even be an emoji.
"""

# ╔═╡ d982b49e-53c3-11ec-32d1-af1611ce7a1d
α, β = π/3, π/4

# ╔═╡ d982b520-53c3-11ec-38a1-b13bfb9bfbc9
md"""We can then use the variables to reference the values:
"""

# ╔═╡ d982c0f6-53c3-11ec-27e9-81ce7e2ffc85
u + a_really_long_name + a0 - b0 + α

# ╔═╡ d982c1a0-53c3-11ec-33be-f5c34727b173
md"""Within `Pluto`, names are idiosyncratic: within the global scope, only a single usage is possible per notebook; functions and variables can be freely renamed; structures can be redefined or renamed; ...
"""

# ╔═╡ d982c1e4-53c3-11ec-2e11-91cab3b04b27
md"""Outside of `Pluto`, names may be repurposed, even with values of different types (`Julia` is a dynamic language), save for function names, which have some special rules and can only be redefined as another function. Generic functions are central to `Julia`'s design. Generic functions use a method table to dispatch on, so once a name is assigned to a generic function, it can not be used as a variable name; the reverse is also true.
"""

# ╔═╡ d982c20e-53c3-11ec-3718-71c678df615c
md"""## Functions
"""

# ╔═╡ d982c22c-53c3-11ec-22f2-2719ff687afb
md"""Functions in `Julia` are first-class objects. In these notes, we often pass them as arguments to other functions. There are many built-in functions and it is easy to define new functions.
"""

# ╔═╡ d982c248-53c3-11ec-094f-3564dc85451d
md"""We "call" a function by passing argument(s) to it, grouped by parentheses:
"""

# ╔═╡ d982c916-53c3-11ec-13c9-573eeb4673c4
begin
	sqrt(10)
	sin(pi/3)
	log(5, 100)   # log base 5 of 100
end

# ╔═╡ d982c952-53c3-11ec-2776-4d821da695f0
md"""With out parentheses, the name (usually) refers to a generic name and the output lists the number of available implementations.
"""

# ╔═╡ d982cbdc-53c3-11ec-1800-751e102e4527
log

# ╔═╡ d982ce3e-53c3-11ec-2f3a-216da9f8c0b8
md"""### Built-in functions
"""

# ╔═╡ d982cec0-53c3-11ec-0f9a-6734cb404d76
md"""`Julia` has numerous built-in [mathematical](http://julia.readthedocs.io/) functions, we review a few here:
"""

# ╔═╡ d98a0a96-53c3-11ec-2aea-61f14d6fa95f
md"""#### Powers logs and roots
"""

# ╔═╡ d98a0b4a-53c3-11ec-2b87-5f8fc27e9ebf
md"""Besides `^`, there are `sqrt` and `cbrt` for powers. In addition basic functions for exponential and  logarithmic functions:
"""

# ╔═╡ d98a0be0-53c3-11ec-2804-01205a5544ec
md"""```
sqrt, cbrt
exp
log          # base e
log10, log2, # also log(b, x)
```"""

# ╔═╡ d98a0c1c-53c3-11ec-2776-45de88c6a557
md"""#### Trigonometric functions
"""

# ╔═╡ d98a0c5a-53c3-11ec-3832-0932348ffbed
md"""The `6` standard trig functions are implemented; their implementation for degree arguments; their inverse functions; and the hyperbolic analogs.
"""

# ╔═╡ d98a0c76-53c3-11ec-3235-854af42b6323
md"""```
sin, cos, tan, csc, sec, cot
asin, acos, atan, acsc, asec, acot
sinh, cosh, tanh, csch, sech, coth
asinh, acosh, atanh, acsch, asech, acoth
```"""

# ╔═╡ d98a0cda-53c3-11ec-12e2-cb2cb7c8c394
md"""If degrees are preferred, the following are defined to work with arguments in degrees:
"""

# ╔═╡ d98a0d02-53c3-11ec-18fb-9fa89e0ea1ab
md"""```
sind, cosd, tand, cscd, secd, cotd
```"""

# ╔═╡ d98a0d20-53c3-11ec-0c62-a3c7742580ee
md"""#### Useful functions
"""

# ╔═╡ d98a0d2a-53c3-11ec-1dac-23b269c5ede2
md"""Other useful and familiar functions are defined:
"""

# ╔═╡ d98a104a-53c3-11ec-0d9b-67ad5ca3f5ef
md"""  * `abs`: absolute value
  * `sign`: is $\lvert x \rvert/x$ except at $x=0$, where it is $0$.
  * `floor`, `ceil`: greatest integer less or least integer greater
  * `max(a,b)`, `min(a,b)`: larger (or smaller) of `a` or `b`
  * `maximum(xs)`, `minimum(xs)`: largest or smallest of the collection referred to by `xs`
"""

# ╔═╡ d98a1092-53c3-11ec-2891-bb25983cd7f3
md"""---
"""

# ╔═╡ d98a10b8-53c3-11ec-052b-bb3b602a5f9d
md"""In a Pluto session, the "Live docs" area shows inline documentation for the current object.
"""

# ╔═╡ d98a10ea-53c3-11ec-3d87-5797505b017a
md"""For other uses of `Julia`, the built-in documentation for an object is accessible through a leading `?`, say, `?sign`. There is also the `@doc` macro:
"""

# ╔═╡ d98a1720-53c3-11ec-1297-e7760319677e
@doc sign

# ╔═╡ d98a1796-53c3-11ec-3a61-e7c61c8e58bd
md"""---
"""

# ╔═╡ d98a17d4-53c3-11ec-038b-a12c310cd19c
md"""### User-defined functions
"""

# ╔═╡ d98a17f2-53c3-11ec-03b3-d5880a858a9b
md"""Simple mathematical functions can be defined using standard mathematical notation:
"""

# ╔═╡ d98a215c-53c3-11ec-04fe-61ff5c8932fc
f(x) = -16x^2 + 100x + 2

# ╔═╡ d98a21a2-53c3-11ec-16da-8b5dd4c30486
md"""The argument `x` is passed into the body of function.
"""

# ╔═╡ d98a21c0-53c3-11ec-1baa-85d93e7542b9
md"""Other values are found from  the environment where defined:
"""

# ╔═╡ d98a2780-53c3-11ec-027f-9b51bec589c8
let
	a = 1
	f(x) = 2*a + x
	f(3)   # 2 * 1 + 3
	a = 4
	f(3)  # now 2 * 4 + 3
end

# ╔═╡ d98a27a6-53c3-11ec-21be-1fd3ae57826e
md"""User defined functions can have 0, 1 or more arguments:
"""

# ╔═╡ d98a2ecc-53c3-11ec-31f3-c1cf90255faf
area(w, h) = w*h

# ╔═╡ d98a2f80-53c3-11ec-3e56-59770302bda2
md"""Julia makes different *methods* for *generic* function names, so function definitions whose argument specification is different are for different uses, even if the name is the same. This is *polymorphism*. The practical use is that it means users need only remember a much smaller set of function names, as attempts are made to give common expectations to the same name. (That is, `+` should be used only for "add" ing objects, however defined.)
"""

# ╔═╡ d98a2fa8-53c3-11ec-3224-f178d125a041
md"""Functions can be defined with *keyword* arguments that may have defaults specified:
"""

# ╔═╡ d98a3b7e-53c3-11ec-374c-0d092d6040f0
let
	f(x; m=1, b=0) = m*x + b     # note ";"
	f(1)                         # uses m=1, b=0   -> 1 * 1 + 0
	f(1, m=10)                   # uses m=10, b=0  -> 10 * 1 + 0
	f(1, m=10, b=5)              # uses m=10, b=5  -> 10 * 1 + 5
end

# ╔═╡ d98a3bc4-53c3-11ec-0506-bd1f1e247271
md"""Longer functions can be defined using the `function` keyword, the last command executed is returned:
"""

# ╔═╡ d98a4574-53c3-11ec-1400-d3653c1256e2
let
	function f(x)
	  y = x^2
	  z = y - 3
	  z
	end
end

# ╔═╡ d98a45c4-53c3-11ec-2894-b9e4f7cf2d4c
md"""Functions without names, *anonymous functions*, are made with the `->` syntax as in:
"""

# ╔═╡ d98a4bfa-53c3-11ec-00de-bf1da2b02a62
x -> cos(x)^2 - cos(2x)

# ╔═╡ d98a4c40-53c3-11ec-357e-971203556b87
md"""These are useful when passing a function to another function or when writing a function that *returns* a function.
"""

# ╔═╡ d98a4c7e-53c3-11ec-0f8a-23d1fe245f2b
md"""## Conditional statements
"""

# ╔═╡ d98a4cb0-53c3-11ec-1954-ff971e0f5a62
md"""`Julia` provides the traditional `if-else-end` statements, but more conveniently has a `ternary` operator for the simplest case:
"""

# ╔═╡ d98a5514-53c3-11ec-376d-21ad3b497249
our_abs(x) = (x < 0) ? -x : x

# ╔═╡ d98a553c-53c3-11ec-39e4-f7b4ab196a6f
md"""## Looping
"""

# ╔═╡ d98a556e-53c3-11ec-02ae-515e3e50de4c
md"""Iterating over a collection can be done with the traditional `for` loop. However, there are list comprehensions to mimic the definition of a set:
"""

# ╔═╡ d98a5bb8-53c3-11ec-0707-35aac9f383c9
[x^2 for x in 1:10]

# ╔═╡ d98a5bea-53c3-11ec-0523-9b642b0f0fdf
md"""Comprehensions can be filtered through the `if` keyword
"""

# ╔═╡ d98a62d4-53c3-11ec-23a7-c989b279a72b
[x^2 for x in 1:10 if iseven(x)]

# ╔═╡ d98a6306-53c3-11ec-3657-632dd23a7e59
md"""This is more efficient than creating the collection then filtering, as is done with:
"""

# ╔═╡ d98a6ac2-53c3-11ec-0d68-8d828da2c2b7
filter(iseven, [x^2 for x in 1:10])

# ╔═╡ d98a6af4-53c3-11ec-0315-45936c5ed5ed
md"""## Broadcasting, mapping
"""

# ╔═╡ d98a6b0a-53c3-11ec-2cc8-899c94d9cef5
md"""A function can be applied to each element of a vector through mapping or broadcasting. The latter is implemented in a succinct notation. Calling a function with a "." before its opening "(` will apply the function to each individual value in the argument:
"""

# ╔═╡ d98a7134-53c3-11ec-26da-1321f2c7f506
begin
	xs = [1,2,3,4,5]
	sin.(xs)     # gives back [sin(1), sin(2), sin(3), sin(4), sin(5)]
end

# ╔═╡ d98a7170-53c3-11ec-0a17-f3631325a344
md"""For "infix" operators, the dot precedes the operator, as in this example instructing pointwise multiplication of each element in `xs`:
"""

# ╔═╡ d98a7422-53c3-11ec-11ba-2bdadc4c2dd1
xs .* xs

# ╔═╡ d98a745e-53c3-11ec-2bd4-0d8abfc24681
md"""Alternatively, the more traditional `map` can be used:
"""

# ╔═╡ d98a7738-53c3-11ec-2276-894a89c461c5
map(sin, xs)

# ╔═╡ d98a7760-53c3-11ec-139d-59392fe30515
md"""## Plotting
"""

# ╔═╡ d98a77ae-53c3-11ec-0bca-f71856f6b9a5
md"""Plotting is *not* built-in to `Julia`, rather added through add-on packages.  `Julia`'s `Plots` package is an interface to several plotting packages. We mention `plotly` (built-in) for web based graphics, and `gr` (also built into `Plots`) for other graphics.
"""

# ╔═╡ d98a77ce-53c3-11ec-1e99-3532921ab17f
md"""We must load `Plots` before we can plot (and it must be installed before we can load it):
"""

# ╔═╡ d98a7a94-53c3-11ec-3ef9-71bc6a6dfffc
md"""With `Plots` loaded, we can plot a function by passing the function object by name to `plot`, specifying the range of `x` values to show, as follows:
"""

# ╔═╡ d98a8070-53c3-11ec-1528-ad44c35863a6
plot(sin, 0, 2pi) # plot a function - by name - over an interval [a,b]

# ╔═╡ d98a9d62-53c3-11ec-1701-37ee64c6fb67
note("""
This is in the form of **the** basic pattern employed: `verb(function_object, arguments...)`. The verb in this example is `plot`, the object `sin`, the arguments `0, 2pi` to specify `[a,b]` domain to plot over.
""")

# ╔═╡ d98a9e14-53c3-11ec-078e-391e4dcad3be
md"""Plotting more than one function over `[a,b]` is achieved through the `plot!` function, which modifies the existing plot (`plot` creates a new one) by adding a new layer:
"""

# ╔═╡ d98aa582-53c3-11ec-142b-bbb29211a3c0
begin
	plot(sin, 0, 2pi)
	plot!(cos, 0, 2pi)
	plot!(zero, 0, 2pi) # add the line y=0
end

# ╔═╡ d98aa954-53c3-11ec-1f40-a14651d06b91
md"""Individual points are added with `scatter` or `scatter!`:
"""

# ╔═╡ d98ab518-53c3-11ec-3031-cb7dac758b11
begin
	plot(sin, 0, 2pi, legend=false)
	plot!(cos, 0, 2pi)
	scatter!([pi/4, pi+pi/4], [sin(pi/4), sin(pi + pi/4)])
end

# ╔═╡ d98ab57c-53c3-11ec-3da3-5d66642f3cc0
md"""(The extra argument `legend=false` suppresses the automatic legend drawing. There are many other useful arguments to adjust a graphic. For example, passing `markersize=10` to the `scatter!` command would draw the points larger than the default.)
"""

# ╔═╡ d98ab5cc-53c3-11ec-33af-65f574799170
md"""Plotting an *anonymous* function is a bit more immediate than the two-step approach of defining a named function then calling `plot` with this as an argument:
"""

# ╔═╡ d98ac18e-53c3-11ec-3b23-5fb9014d419a
plot( x -> exp(-x/pi) * sin(x), 0, 2pi)

# ╔═╡ d98ac21a-53c3-11ec-2ea5-0161b6075725
md"""The `scatter!` function used above takes two vectors of values to describe the points to plot, one for the $x$ values and one for the matching $y$ values. The `plot` function can also produce plots with this interface. For example, here we use a comprehension to produce `y` values from the specified `x` values:
"""

# ╔═╡ d98acc06-53c3-11ec-1a9d-fdf56fd57569
let
	xs = range(0, 2pi, length=251)
	ys = [sin(2x) + sin(3x) + sin(4x) for x in xs]
	plot(xs, ys)
end

# ╔═╡ d98acc42-53c3-11ec-1c5c-a9fcf2e36e7c
md"""## Equations
"""

# ╔═╡ d98acca6-53c3-11ec-13d9-e999e4d5e7ce
md"""Notation for `Julia` and math is *similar* for functions - but not for equations. In math, an equation  might look like:
"""

# ╔═╡ d990ea78-53c3-11ec-0a9a-479604cfeb00
md"""```math
x^2 + y^2 = 3
```
"""

# ╔═╡ d990ee1a-53c3-11ec-2a4f-2fe7e177c5a2
md"""In `Julia` the equals sign is **only** for *assignment*. The *left-hand* side of an equals sign in `Julia` is reserved for a) variable assignment; b) function definition (via `f(x) = ...`); and c) indexed assignment to a vector or array. (Vectors are indexed by a number allowing retrieval and setting of the stored value in the container. The notation mentioned here would be `xs[2] = 3` to assign to the 2nd element of `xs` a value `3`.
"""

# ╔═╡ d990ee60-53c3-11ec-0683-59e72418ce5e
md"""## Symbolic math
"""

# ╔═╡ d990ef5a-53c3-11ec-3124-0fdd637a54b7
md"""Symbolic math is available through an add-on package `SymPy`.  Once loaded, symbolic variables are created with the macro `@syms`:
"""

# ╔═╡ d990fc5c-53c3-11ec-197d-a50b74da62e1
@syms x a b c

# ╔═╡ d990fd56-53c3-11ec-36cb-3d6db387e851
md"""(A macro rewrites values into other commands before they are interpreted. Macros are prefixed with the `@` sign. In this use, the "macro" `@syms` translates `x a b c` into a command involving `SymPy`s `symbols` function.)
"""

# ╔═╡ d990fd74-53c3-11ec-0f9e-0d230fd48722
md"""Symbolic expressions - unlike numeric expressions - are not immediately evaluated, though they may be  simplified:
"""

# ╔═╡ d991068c-53c3-11ec-0dbc-bbf77421c4d2
p = a*x^2 + b*x + c

# ╔═╡ d99106e8-53c3-11ec-0d85-e1809bfbc014
md"""To substitute a value, we can use `Julia`'s `pair` notation (`variable=>value`):
"""

# ╔═╡ d9911534-53c3-11ec-28fd-cba852f1c414
p(x=>2), p(x=>2, a=>3, b=>4, c=>1)

# ╔═╡ d991156e-53c3-11ec-124a-a761b26bd6ba
md"""This is convenient notation for calling the `subs` function for `SymPy`.
"""

# ╔═╡ d991157a-53c3-11ec-3daf-238cc3c8edf5
md"""SymPy expressions of a single free variable can be plotted directly:
"""

# ╔═╡ d9911f78-53c3-11ec-30d1-07736e0750c1
plot(64 - (1/2)*32 * x^2, 0, 2)

# ╔═╡ d991233a-53c3-11ec-1bce-b7b7918e4551
md"""  * SymPy has functions for manipulating expressions: `simplify`, `expand`, `together`, `factor`, `cancel`, `apart`,  $...$
  * SymPy has functions for basic math: `factor`, `roots`, `solve`, `solveset`, $\dots$
  * SymPy has functions for calculus: `limit`, `diff`, `integrate`, $\dots$
"""

# ╔═╡ d991256a-53c3-11ec-3bdb-597df9977a30
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/trig_functions.html">◅ previous</a>  <a href="../limits/limits.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/julia_overview.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ d991266e-53c3-11ec-1d25-7d1fa331b7ed
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
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
# ╟─d9912466-53c3-11ec-31f9-7b394b47802d
# ╟─d83684d0-53c3-11ec-31e7-578be34c7f2c
# ╟─d86e8e0c-53c3-11ec-09e6-43dbdb09c93c
# ╟─d887af02-53c3-11ec-384f-35a30843e970
# ╟─d88e5a66-53c3-11ec-0d2a-b91aead8578f
# ╟─d89187d8-53c3-11ec-149f-6f76f9876a1f
# ╟─d891884e-53c3-11ec-2f9b-2f54e16c84da
# ╟─d8918876-53c3-11ec-2609-3de6793ee6f3
# ╟─d8918998-53c3-11ec-2896-7b5574b8ecd3
# ╟─d893da7c-53c3-11ec-1522-7fa512a968cf
# ╟─d8957a1c-53c3-11ec-07ce-3711f81c3585
# ╟─d95bb056-53c3-11ec-296a-9bb93444bf58
# ╟─d9607d84-53c3-11ec-1422-bbe6456ed8ed
# ╟─d96081c6-53c3-11ec-3b43-110184f3b100
# ╟─d9608234-53c3-11ec-0887-e126adc198e6
# ╟─d960913e-53c3-11ec-2b59-b5b9ac79a0de
# ╟─d9609274-53c3-11ec-1aaa-4d976b9648d6
# ╟─d96bb5c8-53c3-11ec-3d09-9d04e7fa0146
# ╟─d96bb86e-53c3-11ec-2836-5584cdefb263
# ╟─d96bb8ac-53c3-11ec-3b16-2f1dd8e2370a
# ╟─d96bb8d4-53c3-11ec-1db1-fdd2dad39f24
# ╟─d96bb8f2-53c3-11ec-28ec-bb27638f409b
# ╟─d96bb912-53c3-11ec-3d36-6f35272036b6
# ╟─d96bb924-53c3-11ec-32b0-f9cd2039ea98
# ╟─d96bb96a-53c3-11ec-14bf-b9132c8a0887
# ╠═d96c1324-53c3-11ec-17e8-33d09badd066
# ╟─d96c13d8-53c3-11ec-18b5-2f16fd71ada9
# ╟─d96c13f6-53c3-11ec-0700-ab746858465f
# ╟─d96c140a-53c3-11ec-16f2-05cc25d3c00f
# ╟─d96c146e-53c3-11ec-18ec-ed6938c7ae5f
# ╟─d96c152c-53c3-11ec-1bfe-01d118ad8dfd
# ╟─d96c3b6a-53c3-11ec-0db7-f5a91c8eb003
# ╟─d96c3bf6-53c3-11ec-23b8-dd7f177a1811
# ╟─d96c3c1c-53c3-11ec-136f-8d786fb874c5
# ╟─d96c3c3c-53c3-11ec-3ce8-29c0edb7638b
# ╟─d96c3ca0-53c3-11ec-2f9c-c59c91821e3a
# ╟─d96c3d72-53c3-11ec-364c-23aed42d98d7
# ╟─d96c3d9a-53c3-11ec-3ef7-7b515021c651
# ╠═d96c4e20-53c3-11ec-070d-91377bfa0ea0
# ╟─d96c4e8e-53c3-11ec-0c59-a593991ae10c
# ╟─d96c4eb6-53c3-11ec-3915-5b51ca8c000c
# ╟─d96c4f24-53c3-11ec-0173-bb2234efb2b8
# ╟─d96c4f74-53c3-11ec-0d6f-df6628c1dc09
# ╟─d96c4f9c-53c3-11ec-3b0c-610dfb6e18d4
# ╟─d96c4fba-53c3-11ec-21c0-7db76c555a80
# ╟─d96c4fec-53c3-11ec-2081-43b2e9f579d9
# ╟─d96c51e0-53c3-11ec-16a1-6f849fe1725a
# ╟─d9741b14-53c3-11ec-09cc-177800a80a96
# ╠═d9742c94-53c3-11ec-2356-7de3a2c8952d
# ╟─d9742d16-53c3-11ec-3809-c32840bc318e
# ╠═d9743298-53c3-11ec-3240-fd8d51217a2c
# ╟─d974336a-53c3-11ec-3e8e-59f3cab54d9f
# ╟─d9743392-53c3-11ec-1239-31ef2b303b30
# ╠═d9743766-53c3-11ec-1c9b-07f851bc059e
# ╟─d97437a2-53c3-11ec-31b5-c7bff61f30c3
# ╟─d97437ca-53c3-11ec-2533-cd3b6dfb79d2
# ╠═d9743e5a-53c3-11ec-26c9-71e339b0b142
# ╟─d9743ebe-53c3-11ec-012f-f979cad7f5f3
# ╟─d9743ee6-53c3-11ec-079a-858dd186751c
# ╟─d9743f24-53c3-11ec-0e98-854ddea72682
# ╟─d981e9c4-53c3-11ec-128f-f58e9cab2694
# ╟─d981ee4c-53c3-11ec-2ea4-53500349a34c
# ╠═d981ff86-53c3-11ec-2a01-15d2220e20f2
# ╟─d98201d4-53c3-11ec-1a9e-1d7416966c9a
# ╠═d98210fa-53c3-11ec-3533-97cbb58c663c
# ╟─d982114c-53c3-11ec-3824-7b3da4fc9974
# ╟─d9821160-53c3-11ec-20f5-a3baa48be3a7
# ╟─d9821674-53c3-11ec-0dcc-913f0dfec96d
# ╟─d9821700-53c3-11ec-23c4-8bc4f4a0b7b8
# ╟─d982171e-53c3-11ec-0561-b9c8443a1884
# ╠═d9821ce6-53c3-11ec-187b-b917d0df2ba4
# ╟─d98227fe-53c3-11ec-3437-c9d0de17f549
# ╟─d982284c-53c3-11ec-3520-23afec8e88a2
# ╟─d9822876-53c3-11ec-10bf-cfe6a54e0afc
# ╠═d9825f94-53c3-11ec-335f-5b2ad5b76ed7
# ╟─d9826064-53c3-11ec-2239-810789d2cdac
# ╠═d982b49e-53c3-11ec-32d1-af1611ce7a1d
# ╟─d982b520-53c3-11ec-38a1-b13bfb9bfbc9
# ╠═d982c0f6-53c3-11ec-27e9-81ce7e2ffc85
# ╟─d982c1a0-53c3-11ec-33be-f5c34727b173
# ╟─d982c1e4-53c3-11ec-2e11-91cab3b04b27
# ╟─d982c20e-53c3-11ec-3718-71c678df615c
# ╟─d982c22c-53c3-11ec-22f2-2719ff687afb
# ╟─d982c248-53c3-11ec-094f-3564dc85451d
# ╠═d982c916-53c3-11ec-13c9-573eeb4673c4
# ╟─d982c952-53c3-11ec-2776-4d821da695f0
# ╠═d982cbdc-53c3-11ec-1800-751e102e4527
# ╟─d982ce3e-53c3-11ec-2f3a-216da9f8c0b8
# ╟─d982cec0-53c3-11ec-0f9a-6734cb404d76
# ╟─d98a0a96-53c3-11ec-2aea-61f14d6fa95f
# ╟─d98a0b4a-53c3-11ec-2b87-5f8fc27e9ebf
# ╟─d98a0be0-53c3-11ec-2804-01205a5544ec
# ╟─d98a0c1c-53c3-11ec-2776-45de88c6a557
# ╟─d98a0c5a-53c3-11ec-3832-0932348ffbed
# ╟─d98a0c76-53c3-11ec-3235-854af42b6323
# ╟─d98a0cda-53c3-11ec-12e2-cb2cb7c8c394
# ╟─d98a0d02-53c3-11ec-18fb-9fa89e0ea1ab
# ╟─d98a0d20-53c3-11ec-0c62-a3c7742580ee
# ╟─d98a0d2a-53c3-11ec-1dac-23b269c5ede2
# ╟─d98a104a-53c3-11ec-0d9b-67ad5ca3f5ef
# ╟─d98a1092-53c3-11ec-2891-bb25983cd7f3
# ╟─d98a10b8-53c3-11ec-052b-bb3b602a5f9d
# ╟─d98a10ea-53c3-11ec-3d87-5797505b017a
# ╠═d98a1720-53c3-11ec-1297-e7760319677e
# ╟─d98a1796-53c3-11ec-3a61-e7c61c8e58bd
# ╟─d98a17d4-53c3-11ec-038b-a12c310cd19c
# ╟─d98a17f2-53c3-11ec-03b3-d5880a858a9b
# ╠═d98a215c-53c3-11ec-04fe-61ff5c8932fc
# ╟─d98a21a2-53c3-11ec-16da-8b5dd4c30486
# ╟─d98a21c0-53c3-11ec-1baa-85d93e7542b9
# ╠═d98a2780-53c3-11ec-027f-9b51bec589c8
# ╟─d98a27a6-53c3-11ec-21be-1fd3ae57826e
# ╠═d98a2ecc-53c3-11ec-31f3-c1cf90255faf
# ╟─d98a2f80-53c3-11ec-3e56-59770302bda2
# ╟─d98a2fa8-53c3-11ec-3224-f178d125a041
# ╠═d98a3b7e-53c3-11ec-374c-0d092d6040f0
# ╟─d98a3bc4-53c3-11ec-0506-bd1f1e247271
# ╠═d98a4574-53c3-11ec-1400-d3653c1256e2
# ╟─d98a45c4-53c3-11ec-2894-b9e4f7cf2d4c
# ╠═d98a4bfa-53c3-11ec-00de-bf1da2b02a62
# ╟─d98a4c40-53c3-11ec-357e-971203556b87
# ╟─d98a4c7e-53c3-11ec-0f8a-23d1fe245f2b
# ╟─d98a4cb0-53c3-11ec-1954-ff971e0f5a62
# ╠═d98a5514-53c3-11ec-376d-21ad3b497249
# ╟─d98a553c-53c3-11ec-39e4-f7b4ab196a6f
# ╟─d98a556e-53c3-11ec-02ae-515e3e50de4c
# ╠═d98a5bb8-53c3-11ec-0707-35aac9f383c9
# ╟─d98a5bea-53c3-11ec-0523-9b642b0f0fdf
# ╠═d98a62d4-53c3-11ec-23a7-c989b279a72b
# ╟─d98a6306-53c3-11ec-3657-632dd23a7e59
# ╠═d98a6ac2-53c3-11ec-0d68-8d828da2c2b7
# ╟─d98a6af4-53c3-11ec-0315-45936c5ed5ed
# ╟─d98a6b0a-53c3-11ec-2cc8-899c94d9cef5
# ╠═d98a7134-53c3-11ec-26da-1321f2c7f506
# ╟─d98a7170-53c3-11ec-0a17-f3631325a344
# ╠═d98a7422-53c3-11ec-11ba-2bdadc4c2dd1
# ╟─d98a745e-53c3-11ec-2bd4-0d8abfc24681
# ╠═d98a7738-53c3-11ec-2276-894a89c461c5
# ╟─d98a7760-53c3-11ec-139d-59392fe30515
# ╟─d98a77ae-53c3-11ec-0bca-f71856f6b9a5
# ╟─d98a77ce-53c3-11ec-1e99-3532921ab17f
# ╠═d98a7a58-53c3-11ec-32d3-c78ddc63810a
# ╟─d98a7a94-53c3-11ec-3ef9-71bc6a6dfffc
# ╠═d98a8070-53c3-11ec-1528-ad44c35863a6
# ╟─d98a9d62-53c3-11ec-1701-37ee64c6fb67
# ╟─d98a9e14-53c3-11ec-078e-391e4dcad3be
# ╠═d98aa582-53c3-11ec-142b-bbb29211a3c0
# ╟─d98aa954-53c3-11ec-1f40-a14651d06b91
# ╠═d98ab518-53c3-11ec-3031-cb7dac758b11
# ╟─d98ab57c-53c3-11ec-3da3-5d66642f3cc0
# ╟─d98ab5cc-53c3-11ec-33af-65f574799170
# ╠═d98ac18e-53c3-11ec-3b23-5fb9014d419a
# ╟─d98ac21a-53c3-11ec-2ea5-0161b6075725
# ╠═d98acc06-53c3-11ec-1a9d-fdf56fd57569
# ╟─d98acc42-53c3-11ec-1c5c-a9fcf2e36e7c
# ╟─d98acca6-53c3-11ec-13d9-e999e4d5e7ce
# ╟─d990ea78-53c3-11ec-0a9a-479604cfeb00
# ╟─d990ee1a-53c3-11ec-2a4f-2fe7e177c5a2
# ╟─d990ee60-53c3-11ec-0683-59e72418ce5e
# ╟─d990ef5a-53c3-11ec-3124-0fdd637a54b7
# ╠═d990f41e-53c3-11ec-24bd-5b83dccfeb63
# ╠═d990fc5c-53c3-11ec-197d-a50b74da62e1
# ╟─d990fd56-53c3-11ec-36cb-3d6db387e851
# ╟─d990fd74-53c3-11ec-0f9e-0d230fd48722
# ╠═d991068c-53c3-11ec-0dbc-bbf77421c4d2
# ╟─d99106e8-53c3-11ec-0d85-e1809bfbc014
# ╠═d9911534-53c3-11ec-28fd-cba852f1c414
# ╟─d991156e-53c3-11ec-124a-a761b26bd6ba
# ╟─d991157a-53c3-11ec-3daf-238cc3c8edf5
# ╠═d9911f78-53c3-11ec-30d1-07736e0750c1
# ╟─d991233a-53c3-11ec-1bce-b7b7918e4551
# ╟─d991256a-53c3-11ec-3bdb-597df9977a30
# ╟─d991259c-53c3-11ec-0188-49395d2a327c
# ╟─d991266e-53c3-11ec-1d25-7d1fa331b7ed
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
