### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 7fcb8fc6-53c0-11ec-2b98-9f67f608eb36
begin
	using SymPy
	using Plots
end

# ╔═╡ 7fcb9644-53c0-11ec-0277-59ef42e9a62b
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	__DIR__, __FILE__ = :precalc, :polynomial
	nothing
end

# ╔═╡ 7fced3c2-53c0-11ec-1c09-af47aa23f7af
using PlutoUI

# ╔═╡ 7fced3a4-53c0-11ec-2597-3fa9bde7b611
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 7fcb6ebc-53c0-11ec-0fe6-29fc4cc893fc
md"""# Polynomials
"""

# ╔═╡ 7fcb6eee-53c0-11ec-0e9f-f1c8f0cfa5e2
md"""In this section we use the following add-on packages:
"""

# ╔═╡ 7fcb9680-53c0-11ec-189f-a78dc578d499
md"""---
"""

# ╔═╡ 7fcb96ce-53c0-11ec-125f-ad1e33192fc2
md"""Polynomials are a particular class of expressions that are simple enough to have many properties that can be analyzed. In particular, the key concepts of calculus: limits, continuity, derivatives, and integrals are all relatively trivial for polynomial functions. However, polynomials are flexible enough that they can be used to approximate a wide variety of functions. Indeed, though we don't pursue this, we mention that `Julia`'s `ApproxFun` package exploits this to great advantage.
"""

# ╔═╡ 7fcb9720-53c0-11ec-28c9-a1ddcae41a07
md"""Here we discuss some vocabulary and basic facts related to polynomials and show how the add-on `SymPy` package can be used to model polynomial expressions within `SymPy`. `SymPy` provides a Computer Algebra System (CAS) for `Julia`. In this case, by leveraging a mature `Python` package [SymPy](https://www.sympy.org/). Later we will discuss the `Polynomials` package for polynomials.
"""

# ╔═╡ 7fcb9766-53c0-11ec-1b9e-3b1018d9a091
md"""For our purposes, a *monomial* is simply a non-negative integer power of $x$ (or some other indeterminate symbol) possibly multiplied by a scalar constant.  For example, $5x^4$ is a monomial, as are constants, such as $-2=-2x^0$ and the symbol itself, as $x = x^1$. In general, one may consider restrictions on where the constants can come from, and consider more than one symbol, but we won't pursue this here, restricting ourselves to the case of a single variable and real coefficients.
"""

# ╔═╡ 7fcb9784-53c0-11ec-13a9-93396907e88d
md"""A *polynomial* is a sum of monomials. After combining terms with same powers, a non-zero polynomial may be written uniquely as:
"""

# ╔═╡ 7fcbaf1c-53c0-11ec-0c0d-73dc1b53007d
md"""```math
a_n x^n + a_{n-1}x^{n-1} + \cdots a_1 x + a_0, \quad a_n \neq 0
```
"""

# ╔═╡ 7fcbb354-53c0-11ec-03d6-0fe8f33cb00e
let
	##{{{ different_poly_graph }}}
	pyplot()
	fig_size = (400, 300)
	anim = @animate for m in  2:2:10
	    fn = x -> x^m
	    plot(fn, -1, 1, size = fig_size, legend=false, title="graph of x^{$m}", xlims=(-1,1), ylims=(-.1,1))
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	caption = "Polynomials of varying even degrees over [-1,1]."
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7fcbb432-53c0-11ec-31ba-e797f2b92835
md"""The numbers $a_0, a_1, \dots, a_n$ are the **coefficients** of the polynomial in the standard basis. With the identifications that $x=x^1$ and $1 = x^0$, the monomials above have their power match their coefficient's index, e.g., $a_ix^i$.  Outside of the coefficient $a_n$, the other coefficients may be negative, positive, *or* $0$. Except for the zero polynomial, the largest power $n$ is called the [degree](https://en.wikipedia.org/wiki/Degree_of_a_polynomial). The degree of the [zero](http://tinyurl.com/he6eg6s) polynomial is typically not defined or defined to be $-1$, so as to make certain statements easier to express. The term $a_n$ is called the **leading coefficient**. When the leading coefficient is $1$, the polynomial is called a **monic polynomial**. The monomial $a_n x^n$ is the **leading term**.
"""

# ╔═╡ 7fcbb458-53c0-11ec-2610-eb288f8c6ea8
md"""For example, the polynomial $-16x^2 - 32x + 100$ has degree $2$, leading coefficient $-16$ and leading term $-16x^2$. It is not monic, as the leading coefficient is not 1.
"""

# ╔═╡ 7fcbc946-53c0-11ec-05c3-210da07bb601
md"""Lower degree polynomials have special names: a degree $0$ polynomial ($a_0$) is a non-zero constant, a degree 1 polynomial ($a_0+a_1x$) is called linear, a degree $2$ polynomial is quadratic, and  a degree $3$ polynomial is called cubic.
"""

# ╔═╡ 7fcbc9a2-53c0-11ec-09c8-f3cade7d6b1c
md"""## Linear polynomials
"""

# ╔═╡ 7fcbc9b6-53c0-11ec-2854-01280526eb5a
md"""A special place is reserved for polynomials with degree 1. These are linear, as their graphs are straight lines. The general form,
"""

# ╔═╡ 7fcbc9ca-53c0-11ec-1200-d71f5ca1ef70
md"""```math
a_1 x + a_0, \quad a_1 \neq 0,
```
"""

# ╔═╡ 7fcbca06-53c0-11ec-04e6-3d74715e62ed
md"""is often written as $mx + b$, which is the **slope-intercept** form. The slope of a line determines how steeply it rises. The value of $m$ can be found from two points through the well-known formula:
"""

# ╔═╡ 7fcbca1c-53c0-11ec-0729-41d24b778c5c
md"""```math
m = \frac{y_1 - y_0}{x_1 - x_0} = \frac{\text{rise}}{\text{run}}
```
"""

# ╔═╡ 7fcbe496-53c0-11ec-04bc-8b511b5f6c7c
let
	### {{{ lines_m_graph }}}
	
	pyplot()
	fig_size = (400, 300)
	
	anim = @animate for m in  [-5, -2, -1, 1, 2, 5, 10, 20]
	    fn = x -> m * x
	    plot(fn, -1, 1, size = fig_size, legend=false, title="m = $m", xlims=(-1,1), ylims=(-20, 20))
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	caption = "Graphs of y = mx for different values of m"
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7fcbe4f0-53c0-11ec-24c9-a1d980f4da21
md"""The intercept, $b$, comes from the fact that when $x=0$ the expression is $b$. That is the graph of the function $f(x) = mx + b$ will have $(0,b)$ as a point on it.
"""

# ╔═╡ 7fcbe518-53c0-11ec-1f7f-3350e9431ba2
md"""More generally, we have the **point-slope** form of a line, written as a polynomial through
"""

# ╔═╡ 7fcbe52c-53c0-11ec-0d96-b96381d24bc3
md"""```math
y_0 + m \cdot (x - x_0).
```
"""

# ╔═╡ 7fcbe55e-53c0-11ec-0e51-a1aa84a08668
md"""The slope is $m$ and the point $(x_0, y_0)$. Again, the line graphing this as a function of $x$ would have the point $(x_0,y_0)$ on it and have slope $m$. This form is more useful in calculus, as the information we have convenient is more likely to be related to a specific value of $x$, not the special value $x=0$.
"""

# ╔═╡ 7fcbe590-53c0-11ec-06f6-6540f9e7d688
md"""Thinking in terms of transformations, this looks like the function $f(x) = x$ (whose graph is a line with slope 1) stretched in the $y$ direction by a factor of $m$ then shifted right by $x_0$ units, and then shifted up by $y_0$ units. When $m>1$, this means the line grows faster.  When $m< 0$, the line $f(x)=x$ is flipped through the $x$-axis so would head downwards, not upwards like $f(x) = x$.
"""

# ╔═╡ 7fcbe5a6-53c0-11ec-07cb-9f2b7860d342
md"""## Symbolic math in Julia
"""

# ╔═╡ 7fcbe5d8-53c0-11ec-061b-9913cfca2c7d
md"""The indeterminate value `x` (or some other symbol) in a polynomial, is like a variable in a function and unlike a variable in `Julia`. Variables in `Julia` are identifiers,  just a means to look up a specific, already determined, value. Rather, the symbol `x` is not yet determined, it is essentially a place holder for a future value. Although we have seen that `Julia` makes it very easy to work with mathematical functions, it is not the case that base `Julia` makes working with expressions of algebraic symbols easy.  This makes sense, `Julia` is primarily designed for technical computing, where numeric approaches rule the day. However, symbolic math can be used from within `Julia` through add-on packages.
"""

# ╔═╡ 7fcbe638-53c0-11ec-0d1e-ada782b93060
md"""Symbolic math programs include well-known ones like the commercial programs Mathematica and Maple. Mathematica powers the popular [WolframAlpha](www.wolframalpha.com) website, which turns "natural" language into the specifics of a programming language. The open-source Sage project is an alternative to these two commercial giants. It includes a wide-range of open-source math projects available within its umbrella framework. (`Julia` can even be run from within the free service [cloud.sagemath.com](https://cloud.sagemath.com/projects).) A more focused project for symbolic math, is the [SymPy](www.sympy.org) Python library. SymPy is also used  within Sage. However, SymPy provides a self-contained library that can be used standalone within a Python session. That is great for `Julia` users, as the `PyCall` package glues `Julia` to Python in a seamless manner. This allows the `Julia` package `SymPy` to provide functionality from SymPy within `Julia`.
"""

# ╔═╡ 7fcc0504-53c0-11ec-3b56-c5bbbb14ffa5
note("""

 When `SymPy` is installed through the package manger, the underlying `Python`
 libraries will also be installed.

""")

# ╔═╡ 7fcc055c-53c0-11ec-1ae3-83b38bc0062b
md"""The [`Symbolics`](../alternatives/symbolics) package is a rapidly developing `Julia`-only packge that provides symbolic math options.
"""

# ╔═╡ 7fcc0570-53c0-11ec-3e85-278c3716aeb5
md"""---
"""

# ╔═╡ 7fcc0596-53c0-11ec-2387-cb049b907d41
md"""To use `SymPy`, we create symbolic objects to be our indeterminate symbols. The `symbols` function does this. However, we will use the more convenient `@syms` macro front end for `symbols`.
"""

# ╔═╡ 7fcc0c64-53c0-11ec-0b56-0772fcf836d3
@syms a, b, c, x::real, zs[1:10]

# ╔═╡ 7fcc0cc8-53c0-11ec-0dc0-b9b9c31f382b
md"""The above shows that multiple symbols can be defined at once. The annotation `x::real` instructs `SymPy` to assume the `x` is real, as otherwise it assumes it is possibly complex. There are many other [assumptions](http://docs.sympy.org/dev/modules/core.html#module-sympy.core.assumptions) that can be made. The `@syms` macro documentation lists them. The `zs[1:10]` tensor notation creates a container with 10 different symbols.  The *macro* `@syms` does not need assignment, as the variable(s) are created behind the scenes by the macro.
"""

# ╔═╡ 7fcc179a-53c0-11ec-1715-21cca502145b
note("""Macros in `Julia` are just transformations of the syntax into other syntax. The `@` indicates they behave differently than regular function calls.
""")

# ╔═╡ 7fcc17c2-53c0-11ec-3aa2-654f5b5ee017
md"""The `SymPy` package does three basic things:
"""

# ╔═╡ 7fcc18ee-53c0-11ec-097b-3bd5679674fe
md"""  * It imports some of the functionality provided by `SymPy`, including the ability to create symbolic variables.
  * It overloads many `Julia` functions to work seamlessly with symbolic expressions. This makes working with polynomials quite natural.
  * It gives access to a wide range of SymPy's functionality through the `sympy` object.
"""

# ╔═╡ 7fcc1914-53c0-11ec-20e6-c1c6fb0801ad
md"""To illustrate, using the just defined `x`, here is how we can create the polynomial $-16x^2 + 100$:
"""

# ╔═╡ 7fcc1d44-53c0-11ec-028f-3bfec8570cf4
𝒑 = -16x^2 + 100

# ╔═╡ 7fcc1d76-53c0-11ec-248b-87cea98ffc39
md"""That is, the expression is created just as you would create it within a function body. But here the result is still a symbolic object. We have assigned this expression to a variable `p`, and have not defined it as a function `p(x)`. Mentally keeping the distinction between symbolic expressions and functions is very important.
"""

# ╔═╡ 7fcc1d8a-53c0-11ec-136c-094e564920d1
md"""The `typeof` function shows that `𝒑` is of a symbolic type (`Sym`):
"""

# ╔═╡ 7fcc1ef2-53c0-11ec-0765-21223cd018f6
typeof(𝒑)

# ╔═╡ 7fcc1f06-53c0-11ec-2135-672a469825d3
md"""We can mix and match symbolic objects. This command creates an arbitrary quadratic polynomial:
"""

# ╔═╡ 7fcc2294-53c0-11ec-36d5-5965d8192cd2
quad = a*x^2 + b*x + c

# ╔═╡ 7fcc22ba-53c0-11ec-2257-bb9f945a467e
md"""Again, this is entered in a manner nearly identical to how we see such expressions typeset ($ax^2 + bx+c$), though we must remember to explicitly place the multiplication operator, as the symbols are not numeric literals.
"""

# ╔═╡ 7fcc22d0-53c0-11ec-3362-23576a1aa6dd
md"""We can apply many of `Julia`'s mathematical functions and the result will still be symbolic:
"""

# ╔═╡ 7fcc2660-53c0-11ec-3c52-1f8edda23e1b
sin(a*(x - b*pi) + c)

# ╔═╡ 7fcc2672-53c0-11ec-2039-dfbd5598e7b3
md"""Another example, might be the following combination:
"""

# ╔═╡ 7fcc2990-53c0-11ec-335f-fd9c08531734
quad + quad^2 - quad^3

# ╔═╡ 7fcc29c4-53c0-11ec-1ab6-abff7d8bfced
md"""One way to create symbolic expressions is simply to call a `Julia` function with symbolic arguments. The first line in the next example defines a function, the second evaluates it at the symbols `x`, `a`, and `b` resulting in a symbolic expression `ex`:
"""

# ╔═╡ 7fcc2e42-53c0-11ec-2cac-2b04785e0070
begin
	f(x, m, b) = m*x + b
	ex = f(x, a, b)
end

# ╔═╡ 7fcc2e60-53c0-11ec-15b1-05a6a5cd77d6
md"""## Substitution: subs, replace
"""

# ╔═╡ 7fcc2e7e-53c0-11ec-01f0-259a9669de1a
md"""Algebraically working with symbolic expressions is straightforward. A different symbolic task is substitution. For example, replacing each instance of `x` in a polynomial, with, say, `(x-1)^2`. Substitution requires three things to be specified: an expression to work on, a variable to substitute, and a value to substitute in.
"""

# ╔═╡ 7fcc2e9e-53c0-11ec-3878-5154e0732514
md"""SymPy provides its `subs` function for this. This function is available in `Julia`, but it is easier to use notation reminiscent of function evaluation.
"""

# ╔═╡ 7fcc2eba-53c0-11ec-0624-4d0a08b6c35e
md"""To illustrate, to do the task above for the polynomial $-16x^2 + 100$ we could have:
"""

# ╔═╡ 7fcc3310-53c0-11ec-3038-814c1f6d0b75
𝒑(x => (x-1)^2)

# ╔═╡ 7fcc3336-53c0-11ec-0023-8171939f6755
md"""This "call" notation takes pairs (designated by `a=>b`) where the left-hand side is the variable to substitute for, and the right-hand side the new value. The value to substitute can depend on the variable, as illustrated; be a different variable; or be a numeric value, such as $2$:
"""

# ╔═╡ 7fcc4fd0-53c0-11ec-026c-455bbf44d2f5
𝒚 = 𝒑(x=>2)

# ╔═╡ 7fcc5002-53c0-11ec-2f66-353c3ff6ee0c
md"""The result will always be of a symbolic type, even if the answer is just a number:
"""

# ╔═╡ 7fcc519c-53c0-11ec-3e74-1de8d377530d
typeof(𝒚)

# ╔═╡ 7fcc51ba-53c0-11ec-0dea-b19e54877d55
md"""If there is just one free variable in an expression, the pair notation can be dropped:
"""

# ╔═╡ 7fcc6b96-53c0-11ec-30e7-bf1df254a0e8
𝒑(4) # substitutes x=>4

# ╔═╡ 7fcc6bdc-53c0-11ec-2d6d-b7514f753ed8
md"""##### Example
"""

# ╔═╡ 7fcc6c18-53c0-11ec-2243-09c4b3bc1ef2
md"""Suppose we have the polynomial $p = ax^2 + bx +c$. What would it look like if we shifted right by $E$ units and up by $F$ units?
"""

# ╔═╡ 7fcc70bc-53c0-11ec-0599-913a9a9b8225
begin
	@syms E F
	p₂ = a*x^2 + b*x + c
	p₂(x => x-E) + F
end

# ╔═╡ 7fcc70d2-53c0-11ec-23a1-c936a15365f6
md"""And expanded this becomes:
"""

# ╔═╡ 7fcc75dc-53c0-11ec-0840-a92991c950fe
expand(p₂(x => x-E) + F)

# ╔═╡ 7fcc7618-53c0-11ec-26b9-bdee94b97e9b
md"""### Conversion of symbolic numbers to Julia numbers
"""

# ╔═╡ 7fcc764a-53c0-11ec-38ef-a9c420b63bab
md"""In the above, we substituted `2` in for `x` to get `y`:
"""

# ╔═╡ 7fccaeb2-53c0-11ec-26f3-d190a347f52e
let
	p = -16x^2 + 100
	y = p(2)
end

# ╔═╡ 7fccaf3e-53c0-11ec-0c34-f1e1a2bef1ec
md"""The value, $36$ is still symbolic, but clearly an integer. If we are just looking at the output, we can easily translate from the symbolic value to an integer, as they print similarly. However the conversion to an integer, or another type of number, does not happen automatically.  If a number is needed to pass along to another `Julia` function, it may need to be converted. In general, conversions between different types are handled through various methods of `convert`. However, with `SymPy`, the `N` function will attempt to do the conversion for you:
"""

# ╔═╡ 7fcccc8a-53c0-11ec-362b-5f2be8f196da
let
	p = -16x^2 + 100
	N(p(2))
end

# ╔═╡ 7fcccd02-53c0-11ec-243d-8f3e306e055b
md"""Where `convert(T,x)` requires a specification of the type to convert `x` to, `N` attempts to match the data type used by SymPy to store the number. As such, the output type of `N` may very (rational, a BigFloat, a float, etc.) For getting more digits of accuracy, a precision can be passed to `N`. The following command will take the symbolic value for $\pi$, `PI`, and produce about 60 digits worth as a `BigFloat` value:
"""

# ╔═╡ 7fcce81e-53c0-11ec-1cf4-332121ab8260
N(PI, 60)

# ╔═╡ 7fcce878-53c0-11ec-1384-0747f5bff4aa
md"""Conversion will fail if the value to be converted contains free symbols, as would be expected.
"""

# ╔═╡ 7fcce896-53c0-11ec-2871-cd43a8c32cfe
md"""### Converting symbolic expressions into Julia functions
"""

# ╔═╡ 7fcce8a0-53c0-11ec-0f62-cd39e1a3ac04
md"""Evaluating a symbolic expression and returning a numeric value can be done by composing the two just discussed concepts. For example:
"""

# ╔═╡ 7fccf052-53c0-11ec-11db-7b15a0c66a7b
begin
	𝐩 = 200 - 16x^2
	N(𝐩(2))
end

# ╔═╡ 7fccf0de-53c0-11ec-02e6-433e00efed4d
md"""This approach is direct, but can be slow *if* many such evaluations were needed (such as with a plot). An alternative is to turn the symbolic expression into a `Julia` function and then evaluate that as usual.
"""

# ╔═╡ 7fccf108-53c0-11ec-31fd-079d934e5e1f
md"""The `lambdify` function turns a symbolic expression into a `Julia` function
"""

# ╔═╡ 7fccf7aa-53c0-11ec-194a-b36c48c176d0
let
	pp = lambdify(𝐩)
	pp(2)
end

# ╔═╡ 7fccf7de-53c0-11ec-261a-dd7ad4198192
md"""The `lambdify` function uses the name of the similar `SymPy` function which is named after Pythons convention of calling anoynmous function "lambdas." The use above is straightforward. Only slightly more complicated is the use when there are multiple symbolic values. For example:
"""

# ╔═╡ 7fcd16d6-53c0-11ec-0283-032eb0d02dd4
let
	p = a*x^2 + b
	pp = lambdify(p)
	pp(1,2,3)
end

# ╔═╡ 7fcd1726-53c0-11ec-2e8e-9f614b5e53e6
md"""This evaluation matches `a` with `1`, `b` with`2`, and `x` with `3` as that is the order returned by the function call `free_symbols(p)`. To adjust that, a second `vars` argument can be given:
"""

# ╔═╡ 7fcd1c6a-53c0-11ec-08bf-c9043195e852
md"""## Graphical properties of polynomials
"""

# ╔═╡ 7fcd1c80-53c0-11ec-0db7-43c4e771ac03
md"""Consider the graph of the polynomial `x^5 - x + 1`:
"""

# ╔═╡ 7fcd671c-53c0-11ec-0085-d540271295a7
plot(x^5 - x + 1, -3/2, 3/2)

# ╔═╡ 7fcd674e-53c0-11ec-1343-a9d465098bf0
md"""(Plotting symbolic expressions is similar to plotting a function, in that the expression is passed in as the first argument. The expression must have only one free variable, as above, or an error will occur.)
"""

# ╔═╡ 7fcd6758-53c0-11ec-1e45-356b0af6111f
md"""This graph illustrates the key features of polynomial graphs:
"""

# ╔═╡ 7fcd68b6-53c0-11ec-38c9-57ce03ea4903
md"""  * there may be values for `x` where the graph crosses the $x$ axis (real roots of the polynomial);
  * there may be peaks and valleys (local maxima and local minima)
  * except for constant polynomials, the ultimate behaviour for large values of $\lvert x\rvert$ is either both sides of the graph going to positive infinity, or negative infinity, or as in this graph one to the positive infinity and one to negative infinity. In particular, there is no *horizontal asymptote*.
"""

# ╔═╡ 7fcd68de-53c0-11ec-1762-9d52dbc4a994
md"""To investigate this last point, let's consider the case of the monomial $x^n$. When $n$ is even, the following animation shows that larger values of $n$ have greater growth once outside of $[-1,1]$:
"""

# ╔═╡ 7fcd6c8a-53c0-11ec-37a3-f7494084a706
let
	### {{{ poly_growth_graph }}}
	
	pyplot()
	fig_size = (400, 300)
	
	anim = @animate for m in  0:2:12
	    fn = x -> x^m
	    plot(fn, -1.2, 1.2, size = fig_size, legend=false, xlims=(-1.2, 1.2), ylims=(0, 1.2^12), title="x^{$m} over [-1.2, 1.2]")
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	caption = L"Demonstration that $x^{10}$ grows faster than $x^8$, ... and $x^2$  grows faster than $x^0$ (which is constant)."
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7fcd6cb2-53c0-11ec-03e1-83ca0ca9c6f3
md"""Of course, this is expected, as, for example, $2^2 < 2^4 < 2^6 < \cdots$. The general shape of these terms is similar - $U$ shaped, and larger powers dominate the smaller powers as $\lvert x\rvert$ gets big.
"""

# ╔═╡ 7fcd6cd0-53c0-11ec-0fd8-f545f817c10e
md"""For odd powers of $n$, the graph of the monomial $x^n$ is no longer $U$ shaped, but rather constantly increasing. This graph of $x^5$ is typical:
"""

# ╔═╡ 7fcd70b0-53c0-11ec-0951-edfc830d8d68
plot(x^5, -2, 2)

# ╔═╡ 7fcd70c2-53c0-11ec-2129-2f51dce9bb30
md"""Again, for larger powers the shape is similar, but the growth is faster.
"""

# ╔═╡ 7fcd70e2-53c0-11ec-15c3-ab78337cdc43
md"""### Leading term dominates
"""

# ╔═╡ 7fcd7108-53c0-11ec-2e06-bf5e225e41dc
md"""To see the roots and/or the peaks and valleys of a polynomial requires a judicious choice of viewing window, as ultimately the leading term will dominate the graph. The following animation of the graph of $(x-5)(x-3)(x-2)(x-1)$ illustrates. Subsequent images show a widening of the plot window until the graph appears U-shaped.
"""

# ╔═╡ 7fcd7432-53c0-11ec-3b80-b9fccfa39a98
let
	### {{{ leading_term_graph }}}
	
	pyplot()
	fig_size = (400, 300)
	
	anim = @animate for n in 1:6
	    m = [1, .5, -1, -5, -20, -25]
	    M = [2, 4,    5, 10, 25, 30]
	    fn = x -> (x-1)*(x-2)*(x-3)*(x-5)
	
	    plt = plot(fn, m[n], M[n], size=fig_size, legend=false, linewidth=2, title ="Graph of on ($(m[n]), $(M[n]))")
	    if n > 1
	        plot!(plt, fn, m[n-1], M[n-1], color=:red, linewidth=4)
	    end
	end
	
	caption = "The previous graph is highlighted in red. Ultimately the leading term (\$x^4\$ here) dominates the graph."
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps=1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 7fcd745a-53c0-11ec-3473-59adb6f807c0
md"""The leading term in the animation is $x^4$, of even degree, so the graphic is U-shaped, were the leading term of odd degree  the left and right sides would each head off to different signs of infinity.
"""

# ╔═╡ 7fcd746e-53c0-11ec-08e6-b36b989e7d8f
md"""To illustrate analytically why the leading term dominates, consider the polynomial $2x^5 - x + 1$ and then factor out the largest power, $x^5$, leaving a product:
"""

# ╔═╡ 7fcd7496-53c0-11ec-1e2c-5909e3255ee3
md"""```math
x^5 \cdot (2 - \frac{1}{x^4} + \frac{1}{x^5}).
```
"""

# ╔═╡ 7fcd74be-53c0-11ec-2594-230210691a69
md"""For large $\lvert x\rvert$, the last two terms in the product on the right get close to $0$, so this expression is *basically* just $2x^5$ - the leading term.
"""

# ╔═╡ 7fcd74d2-53c0-11ec-1ea2-dd4125e5b89c
md"""---
"""

# ╔═╡ 7fcd74fa-53c0-11ec-05e2-51fdd39d8e66
md"""The following graphic illustrates the $4$ basic *overall* shapes that can result when plotting a polynomials as $x$ grows without bound:
"""

# ╔═╡ 7fcd9066-53c0-11ec-1edd-9938d7d586c1
begin
	plot(; layout=4)
	plot!(x -> x^4,  -3,3, legend=false, xticks=false, yticks=false, subplot=1, title="n > even, aₙ > 0")
	plot!(x -> x^5,  -3,3, legend=false, xticks=false, yticks=false, subplot=2, title="n > odd, aₙ > 0")
	plot!(x -> -x^4, -3,3, legend=false, xticks=false, yticks=false, subplot=3, title="n > even, aₙ < 0")
	plot!(x -> -x^5, -3,3, legend=false, xticks=false, yticks=false, subplot=4, title="n > odd, aₙ < 0")
end

# ╔═╡ 7fcd90a0-53c0-11ec-146f-3dd889bcd9fd
md"""##### Example
"""

# ╔═╡ 7fcd90e8-53c0-11ec-0992-b7878605a7a7
md"""Suppose $p = a_n x^n + \cdots + a_1 x + a_0$ with $a_n > 0$. Then by the above, eventually for large $x > 0$ we have $p > 0$, as that is the behaviour of $a_n x^n$. Were $a_n < 0$, then eventually for large $x>0$, $p < 0$.
"""

# ╔═╡ 7fcd9110-53c0-11ec-2797-bbfc67645679
md"""Now consider the related polynomial, $q$, where we multiply $p$ by $x^n$ and substitute in $1/x$ for $x$. This is the "reversed" polynomial, as we see in this illustration for $n=2$:
"""

# ╔═╡ 7fcd966a-53c0-11ec-1f05-85983df0744c
let
	p = a*x^2 + b*x + c
	n = 2    # the degree of p
	q = expand(x^n * p(x => 1/x))
end

# ╔═╡ 7fcd96e4-53c0-11ec-159e-ddbe6e5489ac
md"""In particular, from the reversal, the behavior of $q$ for large $x$ depends on the sign of $a_0$. As well, due to the $1/x$, the behaviour of $q$ for large $x>0$ is the same as the behaviour of $p$ for small *positive* $x$. In particular if $a_n > 0$ but $a_0 < 0$, then `p` is eventually positive and `q` is eventually negative.
"""

# ╔═╡ 7fcd9700-53c0-11ec-38ec-65262505d95a
md"""That is, if $p$ has $a_n > 0$ but $a_0 < 0$ then the graph of $p$ must cross the $x$ axis.
"""

# ╔═╡ 7fcd973c-53c0-11ec-300d-f321198e5086
md"""This observation is the start of Descartes' rule of [signs](http://sepwww.stanford.edu/oldsep/stew/descartes.pdf), which counts the change of signs of the coefficients in `p` to say something about how many possible crossings there are of the $x$ axis by the graph of the polynomial $p$.
"""

# ╔═╡ 7fcd975a-53c0-11ec-3122-71fb8163c14a
md"""## Factoring polynomials
"""

# ╔═╡ 7fcd976e-53c0-11ec-27ab-c1f1a807924a
md"""Among numerous others, there are two common ways of representing a non-zero polynomial:
"""

# ╔═╡ 7fcd980e-53c0-11ec-39b3-759525d507a9
md"""  * expanded form, as in $a_n x^n + a_{n-1}x^{n-1} + \cdots a_1 x + a_0, a_n \neq 0$; or
  * factored form, as in $a\cdot(x-r_1)\cdot(x-r_2)\cdots(x-r_n), a \neq 0$.
"""

# ╔═╡ 7fcd982c-53c0-11ec-2a29-8366b53b5590
md"""The latter writes $p$ as a product of linear factors, though this is only possible in general if we consider complex roots. With real roots only, then the factors are either linear or quadratic, as will be discussed later.
"""

# ╔═╡ 7fcd9872-53c0-11ec-07ac-b14d4f746bbd
md"""There are values to each representation. One value of the expanded form is that polynomial addition and scalar multiplication is much easier in expanded form. For example, adding polynomials just requires matching up the monomials of similar powers. For the factored format, polynomial multiplication is much easier. For the factored form it is easy to read off *roots* of the polynomial (values of $x$ where $p$ is $0$), as a product is $0$ only if a term is $0$, so any zero must be a zero of a factor. Factored form has other advantages. For example, the polynomial $(x-1)^{1000}$ can be compactly represented using the factored form, but would require 1001 coefficients to store in expanded form. (As well, due to floating point differences, the two would evaluate quite differently as one would require over a 1000 operations to compute, the other just two.)
"""

# ╔═╡ 7fcd987e-53c0-11ec-15e7-c3dba567066a
md"""Translating from factored form to expanded form can be done by carefully following the distributive law of multiplication. For example, with some care it can be shown that:
"""

# ╔═╡ 7fcd9890-53c0-11ec-07cc-1f7543f15caf
md"""```math
(x-1) \cdot (x-2) \cdot (x-3) = x^3  - 6x^2 +11x - 6.
```
"""

# ╔═╡ 7fcd98c2-53c0-11ec-163d-01dcd4bb649a
md"""The `SymPy` function `expand` will perform these algebraic manipulations without fuss:
"""

# ╔═╡ 7fcd9ea8-53c0-11ec-1b1c-490b3472ef6a
expand((x-1)*(x-2)*(x-3))

# ╔═╡ 7fcd9ee4-53c0-11ec-249d-3ba483e6caeb
md"""Factoring a polynomial is several weeks worth of lessons, as there is no one-size-fits-all algorithm to follow. There are some tricks that are taught: for example factoring differences of perfect squares, completing the square, the rational root theorem, $\dots$. But in general the solution is not automated. The `SymPy` function `factor` will find all rational factors (terms like $(qx-p)$), but will leave terms that do not have rational factors alone. For example:
"""

# ╔═╡ 7fcda43e-53c0-11ec-2c9a-b3e3f9b558af
factor(x^3 - 6x^2 + 11x -6)

# ╔═╡ 7fcda452-53c0-11ec-12ba-07c63a80e443
md"""Or
"""

# ╔═╡ 7fcdd7fe-53c0-11ec-2903-6dc7b4acdcee
factor(x^5 - 5x^4 + 8x^3 - 8x^2 + 7x - 3)

# ╔═╡ 7fcdd830-53c0-11ec-11d8-19d99087869a
md"""But will not factor things that are not hard to see:
"""

# ╔═╡ 7fcddaee-53c0-11ec-3b14-7bb841669ceb
x^2 - 2

# ╔═╡ 7fcddb20-53c0-11ec-2772-ff1d844c8bba
md"""The factoring $(x-\sqrt{2})\cdot(x + \sqrt{2})$ is not found, as $\sqrt{2}$ is not rational.
"""

# ╔═╡ 7fcddb34-53c0-11ec-043f-75b08a27b60b
md"""(For those, it may be possible to solve to get the roots, which can then be used to produce the factored form.)
"""

# ╔═╡ 7fcddb48-53c0-11ec-0af2-233e290188d6
md"""### Polynomial functions and polynomials.
"""

# ╔═╡ 7fcddb7a-53c0-11ec-1985-278e6caa1ac9
md"""Our definition of a polynomial is in terms of algebraic expressions which are easily represented by `SymPy` objects, but not objects from base `Julia`. (Later we discuss the `Polynomials` package for representing polynomials. There is also the `AbstractAlbegra` package for a more algebraic treatment of polynomials.)
"""

# ╔═╡ 7fcddbac-53c0-11ec-1f92-1d749b076171
md"""However, *polynomial functions* are easily represented by `Julia`, for example,
"""

# ╔═╡ 7fcddf76-53c0-11ec-2793-1bc336ee4e30
f(x) = -16x^2 + 100

# ╔═╡ 7fcddfaa-53c0-11ec-3635-fdb9661549d4
md"""The distinction is subtle, the expression is turned into a function just by adding the `f(x) =` preface. But to `Julia` there is a big distinction. The function form never does any computation until after a value of $x$ is passed to it. Whereas symbolic expressions can be manipulated quite freely before any numeric values are specified.
"""

# ╔═╡ 7fcddfbc-53c0-11ec-2827-4164ab2c5358
md"""It is easy to create a symbolic expression from a function - just evaluate the function on a symbolic value:
"""

# ╔═╡ 7fcde138-53c0-11ec-269e-c90d16f8d500
f(x)

# ╔═╡ 7fcde16a-53c0-11ec-36ca-4d848e0167b6
md"""This is easy - but can also be confusing. The function object is `f`, the expression is `f(x)` - the function evaluated on a symbolic object. Moreover, as seen, the symbolic expression can be evaluated using the same syntax as a function call:
"""

# ╔═╡ 7fcde4da-53c0-11ec-0520-25c34d5a18be
begin
	p = f(x)
	p(2)
end

# ╔═╡ 7fcd1c30-53c0-11ec-2380-2d74df2ee7f4
let
	pp = lambdify(p, (x,a,b))
	pp(1,2,3) # computes 2*1^2 + 3
end

# ╔═╡ 7fcde50c-53c0-11ec-26bd-c1623de16086
md"""For many uses, the distinction is unnecessary to make, as the many functions will work with any callable expression. One such is `plot` – either `plot(f, a, b)` or `plot(f(x),a, b)` will produce the same plot using the `Plots` package.
"""

# ╔═╡ 7fcde52a-53c0-11ec-20d2-1fc79a6ff66c
md"""## Questions
"""

# ╔═╡ 7fcde552-53c0-11ec-0da3-27bbec9fd78e
md"""###### Question
"""

# ╔═╡ 7fcde570-53c0-11ec-3046-c31513733f75
md"""Let $p$ be the polynomial $3x^2 - 2x + 5$.
"""

# ╔═╡ 7fcde58e-53c0-11ec-1772-e1f0e1e0ed6a
md"""What is the degree of $p$?
"""

# ╔═╡ 7fcde764-53c0-11ec-01df-c38a2a74184e
let
	numericq(2)
end

# ╔═╡ 7fcde78c-53c0-11ec-3eb4-41196186c865
md"""What is the leading coefficient of $p$?
"""

# ╔═╡ 7fcde962-53c0-11ec-2edf-9febc237b9f1
numericq(3)

# ╔═╡ 7fcde98a-53c0-11ec-07d9-79dadcb0fda2
md"""The graph of $p$ would have what $y$-intercept?
"""

# ╔═╡ 7fcdeb18-53c0-11ec-279e-89c7636fd790
numericq(5)

# ╔═╡ 7fcdeb38-53c0-11ec-119f-0bd1c2d66636
md"""Is $p$ a monic polynomial?
"""

# ╔═╡ 7fce0668-53c0-11ec-23dc-e145b4e16f60
booleanq(false, labels=["Yes", "No"])

# ╔═╡ 7fce06a2-53c0-11ec-3baf-9ff72954ab99
md"""Is $p$ a quadratic polynomial?
"""

# ╔═╡ 7fce21d4-53c0-11ec-1f42-e5bab3568800
booleanq(true, labels=["Yes", "No"])

# ╔═╡ 7fce221a-53c0-11ec-16f0-916897447f1d
md"""The graph of $p$ would be $U$-shaped?
"""

# ╔═╡ 7fce26b6-53c0-11ec-2ce7-a156dcb75548
booleanq(true, labels=["Yes", "No"])

# ╔═╡ 7fce26e8-53c0-11ec-0005-73a2b21b0eeb
md"""What is the leading term of $p$?
"""

# ╔═╡ 7fce2dd2-53c0-11ec-091d-cf56c208a1f3
let
	choices = ["``3``", "``3x^2``", "``-2x``", "``5``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 7fce2df0-53c0-11ec-264c-fb4ad1575fd7
md"""###### Question
"""

# ╔═╡ 7fce2e18-53c0-11ec-2804-c9122337ad8c
md"""Let $p = x^3 - 2x^2 +3x - 4$.
"""

# ╔═╡ 7fce2e2c-53c0-11ec-303b-09d33db995a8
md"""What is  $a_2$, using the standard numbering of coefficient?
"""

# ╔═╡ 7fce31e4-53c0-11ec-2167-dff3a699ffdf
numericq(-2)

# ╔═╡ 7fce3200-53c0-11ec-0522-ffdb2013a8d9
md"""What is $a_n$?
"""

# ╔═╡ 7fce33a4-53c0-11ec-002e-47d7f6c941d6
numericq(1)

# ╔═╡ 7fce33c2-53c0-11ec-04fc-e947a400d698
md"""What is $a_0$?
"""

# ╔═╡ 7fce3598-53c0-11ec-38fe-510b83b38102
numericq(-4)

# ╔═╡ 7fce35b6-53c0-11ec-01e8-ab64bb07c10e
md"""###### Question
"""

# ╔═╡ 7fce35d4-53c0-11ec-254f-192d039025ce
md"""The linear polynomial $p = 2x + 3$ is written in which form:
"""

# ╔═╡ 7fce58e8-53c0-11ec-083f-a99b0ed382a6
let
	choices = ["point-slope form", "slope-intercept form", "general form"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 7fce591a-53c0-11ec-3e27-153885999e06
md"""###### Question
"""

# ╔═╡ 7fce5940-53c0-11ec-0c9b-a53e5c3003a1
md"""The polynomial `p` is defined in `Julia` as follows:
"""

# ╔═╡ 7fce5988-53c0-11ec-31fd-9fcb86d2eccd
md"""```
@syms x
p = -16x^2 + 64
```"""

# ╔═╡ 7fce59b2-53c0-11ec-2398-f70802faf97a
md"""What command will return the value of the polynomial when $x=2$?
"""

# ╔═╡ 7fce779c-53c0-11ec-1670-778a424fad5d
let
	choices = [q"p*2", q"p[2]", q"p_2", q"p(x=>2)"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ 7fce77c4-53c0-11ec-0ee2-87f0c132217a
md"""###### Question
"""

# ╔═╡ 7fce77ec-53c0-11ec-2a82-ef82daccb237
md"""In the large, the graph of $p=x^{101} - x + 1$ will
"""

# ╔═╡ 7fce82be-53c0-11ec-2d85-db13d49cc3d5
let
	choices = [
	L"Be $U$-shaped, opening upward",
	L"Be $U$-shaped, opening downward",
	L"Overall, go upwards from $-\infty$ to $+\infty$",
	L"Overall, go downwards from $+\infty$ to $-\infty$"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7fce82dc-53c0-11ec-388f-55aa93e12c5c
md"""###### Question
"""

# ╔═╡ 7fce8304-53c0-11ec-389c-a75e9112cab8
md"""In the large, the graph of $p=x^{102} - x^{101} + x + 1$ will
"""

# ╔═╡ 7fce945c-53c0-11ec-38a2-ad7862030362
let
	choices = [
	L"Be $U$-shaped, opening upward",
	L"Be $U$-shaped, opening downward",
	L"Overall, go upwards from $-\infty$ to $+\infty$",
	L"Overall, go downwards from $+\infty$ to $-\infty$"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7fce94ac-53c0-11ec-39f4-835244a70379
md"""###### Question
"""

# ╔═╡ 7fce94fe-53c0-11ec-34ad-69d3aedb4d14
md"""In the large, the graph of $p=-x^{10} + x^9 + x^8 + x^7 + x^6$ will
"""

# ╔═╡ 7fcea14a-53c0-11ec-0bfb-795315852776
let
	choices = [
	L"Be $U$-shaped, opening upward",
	L"Be $U$-shaped, opening downward",
	L"Overall, go upwards from $-\infty$ to $+\infty$",
	L"Overall, go downwards from $+\infty$ to $-\infty$"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 7fcea168-53c0-11ec-20b1-2b5d7948a22c
md"""###### Question
"""

# ╔═╡ 7fcea190-53c0-11ec-13d5-038a6a5f8769
md"""Use `SymPy` to factor the polynomial $x^{11} - x$. How many factors are found?
"""

# ╔═╡ 7fcea4f6-53c0-11ec-061c-7bdd89fe19d5
let
	@syms x
	ex = x^11 - x
	nf = length(factor(ex).args)
	numericq(nf)
end

# ╔═╡ 7fcea516-53c0-11ec-3f24-7f62e0dba273
md"""###### Question
"""

# ╔═╡ 7fcea532-53c0-11ec-2f21-2db4bef5c035
md"""Use `SymPy` to factor the polynomial $x^{12} - 1$. How many factors are found?
"""

# ╔═╡ 7fcea85c-53c0-11ec-1915-5d4b143d32b7
let
	@syms x
	ex = x^12 - 1
	nf = length(factor(ex).args)
	numericq(nf)
end

# ╔═╡ 7fcea878-53c0-11ec-18e3-91bbd36115dd
md"""###### Question
"""

# ╔═╡ 7fcea8a2-53c0-11ec-18af-a500a7588003
md"""What is the monic polynomial with roots $x=-1$, $x=0$, and $x=2$?
"""

# ╔═╡ 7fcecb02-53c0-11ec-368a-292b5061b8f7
let
	choices = [q"x^3 - 3x^2  + 2x",
	q"x^3 - x^2 - 2x",
	q"x^3 + x^2 - 2x",
	q"x^3 + x^2 + 2x"]
	ans = 2
	radioq(choices, 2)
end

# ╔═╡ 7fcecb2a-53c0-11ec-2694-9fbab1687479
md"""###### Question
"""

# ╔═╡ 7fcecb5c-53c0-11ec-29d3-8b8bb66a5466
md"""Use `expand` to expand the expression `((x-h)^3 - x^3) / h` where `x` and `h` are symbolic constants. What is the value:
"""

# ╔═╡ 7fced39a-53c0-11ec-3ba0-c705539158db
let
	choices = [
	q"-h^2 + 3hx  - 3x^2",
	q"h^3 + 3h^2x + 3hx^2 + x^3 -x^3/h",
	q"x^3 - x^3/h",
	q"0"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 7fced3ba-53c0-11ec-02a9-dd464713452b
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/inversefunctions.html">◅ previous</a>  <a href="../precalc/polynomial_roots.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/polynomial.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 7fced3cc-53c0-11ec-3461-59a8fca47694
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
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
# ╟─7fced3a4-53c0-11ec-2597-3fa9bde7b611
# ╟─7fcb6ebc-53c0-11ec-0fe6-29fc4cc893fc
# ╟─7fcb6eee-53c0-11ec-0e9f-f1c8f0cfa5e2
# ╠═7fcb8fc6-53c0-11ec-2b98-9f67f608eb36
# ╟─7fcb9644-53c0-11ec-0277-59ef42e9a62b
# ╟─7fcb9680-53c0-11ec-189f-a78dc578d499
# ╟─7fcb96ce-53c0-11ec-125f-ad1e33192fc2
# ╟─7fcb9720-53c0-11ec-28c9-a1ddcae41a07
# ╟─7fcb9766-53c0-11ec-1b9e-3b1018d9a091
# ╟─7fcb9784-53c0-11ec-13a9-93396907e88d
# ╟─7fcbaf1c-53c0-11ec-0c0d-73dc1b53007d
# ╟─7fcbb354-53c0-11ec-03d6-0fe8f33cb00e
# ╟─7fcbb432-53c0-11ec-31ba-e797f2b92835
# ╟─7fcbb458-53c0-11ec-2610-eb288f8c6ea8
# ╟─7fcbc946-53c0-11ec-05c3-210da07bb601
# ╟─7fcbc9a2-53c0-11ec-09c8-f3cade7d6b1c
# ╟─7fcbc9b6-53c0-11ec-2854-01280526eb5a
# ╟─7fcbc9ca-53c0-11ec-1200-d71f5ca1ef70
# ╟─7fcbca06-53c0-11ec-04e6-3d74715e62ed
# ╟─7fcbca1c-53c0-11ec-0729-41d24b778c5c
# ╟─7fcbe496-53c0-11ec-04bc-8b511b5f6c7c
# ╟─7fcbe4f0-53c0-11ec-24c9-a1d980f4da21
# ╟─7fcbe518-53c0-11ec-1f7f-3350e9431ba2
# ╟─7fcbe52c-53c0-11ec-0d96-b96381d24bc3
# ╟─7fcbe55e-53c0-11ec-0e51-a1aa84a08668
# ╟─7fcbe590-53c0-11ec-06f6-6540f9e7d688
# ╟─7fcbe5a6-53c0-11ec-07cb-9f2b7860d342
# ╟─7fcbe5d8-53c0-11ec-061b-9913cfca2c7d
# ╟─7fcbe638-53c0-11ec-0d1e-ada782b93060
# ╟─7fcc0504-53c0-11ec-3b56-c5bbbb14ffa5
# ╟─7fcc055c-53c0-11ec-1ae3-83b38bc0062b
# ╟─7fcc0570-53c0-11ec-3e85-278c3716aeb5
# ╟─7fcc0596-53c0-11ec-2387-cb049b907d41
# ╠═7fcc0c64-53c0-11ec-0b56-0772fcf836d3
# ╟─7fcc0cc8-53c0-11ec-0dc0-b9b9c31f382b
# ╟─7fcc179a-53c0-11ec-1715-21cca502145b
# ╟─7fcc17c2-53c0-11ec-3aa2-654f5b5ee017
# ╟─7fcc18ee-53c0-11ec-097b-3bd5679674fe
# ╟─7fcc1914-53c0-11ec-20e6-c1c6fb0801ad
# ╠═7fcc1d44-53c0-11ec-028f-3bfec8570cf4
# ╟─7fcc1d76-53c0-11ec-248b-87cea98ffc39
# ╟─7fcc1d8a-53c0-11ec-136c-094e564920d1
# ╠═7fcc1ef2-53c0-11ec-0765-21223cd018f6
# ╟─7fcc1f06-53c0-11ec-2135-672a469825d3
# ╠═7fcc2294-53c0-11ec-36d5-5965d8192cd2
# ╟─7fcc22ba-53c0-11ec-2257-bb9f945a467e
# ╟─7fcc22d0-53c0-11ec-3362-23576a1aa6dd
# ╠═7fcc2660-53c0-11ec-3c52-1f8edda23e1b
# ╟─7fcc2672-53c0-11ec-2039-dfbd5598e7b3
# ╠═7fcc2990-53c0-11ec-335f-fd9c08531734
# ╟─7fcc29c4-53c0-11ec-1ab6-abff7d8bfced
# ╠═7fcc2e42-53c0-11ec-2cac-2b04785e0070
# ╟─7fcc2e60-53c0-11ec-15b1-05a6a5cd77d6
# ╟─7fcc2e7e-53c0-11ec-01f0-259a9669de1a
# ╟─7fcc2e9e-53c0-11ec-3878-5154e0732514
# ╟─7fcc2eba-53c0-11ec-0624-4d0a08b6c35e
# ╠═7fcc3310-53c0-11ec-3038-814c1f6d0b75
# ╟─7fcc3336-53c0-11ec-0023-8171939f6755
# ╠═7fcc4fd0-53c0-11ec-026c-455bbf44d2f5
# ╟─7fcc5002-53c0-11ec-2f66-353c3ff6ee0c
# ╠═7fcc519c-53c0-11ec-3e74-1de8d377530d
# ╟─7fcc51ba-53c0-11ec-0dea-b19e54877d55
# ╠═7fcc6b96-53c0-11ec-30e7-bf1df254a0e8
# ╟─7fcc6bdc-53c0-11ec-2d6d-b7514f753ed8
# ╟─7fcc6c18-53c0-11ec-2243-09c4b3bc1ef2
# ╠═7fcc70bc-53c0-11ec-0599-913a9a9b8225
# ╟─7fcc70d2-53c0-11ec-23a1-c936a15365f6
# ╠═7fcc75dc-53c0-11ec-0840-a92991c950fe
# ╟─7fcc7618-53c0-11ec-26b9-bdee94b97e9b
# ╟─7fcc764a-53c0-11ec-38ef-a9c420b63bab
# ╠═7fccaeb2-53c0-11ec-26f3-d190a347f52e
# ╟─7fccaf3e-53c0-11ec-0c34-f1e1a2bef1ec
# ╠═7fcccc8a-53c0-11ec-362b-5f2be8f196da
# ╟─7fcccd02-53c0-11ec-243d-8f3e306e055b
# ╠═7fcce81e-53c0-11ec-1cf4-332121ab8260
# ╟─7fcce878-53c0-11ec-1384-0747f5bff4aa
# ╟─7fcce896-53c0-11ec-2871-cd43a8c32cfe
# ╟─7fcce8a0-53c0-11ec-0f62-cd39e1a3ac04
# ╠═7fccf052-53c0-11ec-11db-7b15a0c66a7b
# ╟─7fccf0de-53c0-11ec-02e6-433e00efed4d
# ╟─7fccf108-53c0-11ec-31fd-079d934e5e1f
# ╠═7fccf7aa-53c0-11ec-194a-b36c48c176d0
# ╟─7fccf7de-53c0-11ec-261a-dd7ad4198192
# ╠═7fcd16d6-53c0-11ec-0283-032eb0d02dd4
# ╟─7fcd1726-53c0-11ec-2e8e-9f614b5e53e6
# ╠═7fcd1c30-53c0-11ec-2380-2d74df2ee7f4
# ╟─7fcd1c6a-53c0-11ec-08bf-c9043195e852
# ╟─7fcd1c80-53c0-11ec-0db7-43c4e771ac03
# ╠═7fcd671c-53c0-11ec-0085-d540271295a7
# ╟─7fcd674e-53c0-11ec-1343-a9d465098bf0
# ╟─7fcd6758-53c0-11ec-1e45-356b0af6111f
# ╟─7fcd68b6-53c0-11ec-38c9-57ce03ea4903
# ╟─7fcd68de-53c0-11ec-1762-9d52dbc4a994
# ╟─7fcd6c8a-53c0-11ec-37a3-f7494084a706
# ╟─7fcd6cb2-53c0-11ec-03e1-83ca0ca9c6f3
# ╟─7fcd6cd0-53c0-11ec-0fd8-f545f817c10e
# ╠═7fcd70b0-53c0-11ec-0951-edfc830d8d68
# ╟─7fcd70c2-53c0-11ec-2129-2f51dce9bb30
# ╟─7fcd70e2-53c0-11ec-15c3-ab78337cdc43
# ╟─7fcd7108-53c0-11ec-2e06-bf5e225e41dc
# ╟─7fcd7432-53c0-11ec-3b80-b9fccfa39a98
# ╟─7fcd745a-53c0-11ec-3473-59adb6f807c0
# ╟─7fcd746e-53c0-11ec-08e6-b36b989e7d8f
# ╟─7fcd7496-53c0-11ec-1e2c-5909e3255ee3
# ╟─7fcd74be-53c0-11ec-2594-230210691a69
# ╟─7fcd74d2-53c0-11ec-1ea2-dd4125e5b89c
# ╟─7fcd74fa-53c0-11ec-05e2-51fdd39d8e66
# ╟─7fcd9066-53c0-11ec-1edd-9938d7d586c1
# ╟─7fcd90a0-53c0-11ec-146f-3dd889bcd9fd
# ╟─7fcd90e8-53c0-11ec-0992-b7878605a7a7
# ╟─7fcd9110-53c0-11ec-2797-bbfc67645679
# ╠═7fcd966a-53c0-11ec-1f05-85983df0744c
# ╟─7fcd96e4-53c0-11ec-159e-ddbe6e5489ac
# ╟─7fcd9700-53c0-11ec-38ec-65262505d95a
# ╟─7fcd973c-53c0-11ec-300d-f321198e5086
# ╟─7fcd975a-53c0-11ec-3122-71fb8163c14a
# ╟─7fcd976e-53c0-11ec-27ab-c1f1a807924a
# ╟─7fcd980e-53c0-11ec-39b3-759525d507a9
# ╟─7fcd982c-53c0-11ec-2a29-8366b53b5590
# ╟─7fcd9872-53c0-11ec-07ac-b14d4f746bbd
# ╟─7fcd987e-53c0-11ec-15e7-c3dba567066a
# ╟─7fcd9890-53c0-11ec-07cc-1f7543f15caf
# ╟─7fcd98c2-53c0-11ec-163d-01dcd4bb649a
# ╠═7fcd9ea8-53c0-11ec-1b1c-490b3472ef6a
# ╟─7fcd9ee4-53c0-11ec-249d-3ba483e6caeb
# ╠═7fcda43e-53c0-11ec-2c9a-b3e3f9b558af
# ╟─7fcda452-53c0-11ec-12ba-07c63a80e443
# ╠═7fcdd7fe-53c0-11ec-2903-6dc7b4acdcee
# ╟─7fcdd830-53c0-11ec-11d8-19d99087869a
# ╠═7fcddaee-53c0-11ec-3b14-7bb841669ceb
# ╟─7fcddb20-53c0-11ec-2772-ff1d844c8bba
# ╟─7fcddb34-53c0-11ec-043f-75b08a27b60b
# ╟─7fcddb48-53c0-11ec-0af2-233e290188d6
# ╟─7fcddb7a-53c0-11ec-1985-278e6caa1ac9
# ╟─7fcddbac-53c0-11ec-1f92-1d749b076171
# ╠═7fcddf76-53c0-11ec-2793-1bc336ee4e30
# ╟─7fcddfaa-53c0-11ec-3635-fdb9661549d4
# ╟─7fcddfbc-53c0-11ec-2827-4164ab2c5358
# ╠═7fcde138-53c0-11ec-269e-c90d16f8d500
# ╟─7fcde16a-53c0-11ec-36ca-4d848e0167b6
# ╠═7fcde4da-53c0-11ec-0520-25c34d5a18be
# ╟─7fcde50c-53c0-11ec-26bd-c1623de16086
# ╟─7fcde52a-53c0-11ec-20d2-1fc79a6ff66c
# ╟─7fcde552-53c0-11ec-0da3-27bbec9fd78e
# ╟─7fcde570-53c0-11ec-3046-c31513733f75
# ╟─7fcde58e-53c0-11ec-1772-e1f0e1e0ed6a
# ╟─7fcde764-53c0-11ec-01df-c38a2a74184e
# ╟─7fcde78c-53c0-11ec-3eb4-41196186c865
# ╟─7fcde962-53c0-11ec-2edf-9febc237b9f1
# ╟─7fcde98a-53c0-11ec-07d9-79dadcb0fda2
# ╟─7fcdeb18-53c0-11ec-279e-89c7636fd790
# ╟─7fcdeb38-53c0-11ec-119f-0bd1c2d66636
# ╟─7fce0668-53c0-11ec-23dc-e145b4e16f60
# ╟─7fce06a2-53c0-11ec-3baf-9ff72954ab99
# ╟─7fce21d4-53c0-11ec-1f42-e5bab3568800
# ╟─7fce221a-53c0-11ec-16f0-916897447f1d
# ╟─7fce26b6-53c0-11ec-2ce7-a156dcb75548
# ╟─7fce26e8-53c0-11ec-0005-73a2b21b0eeb
# ╟─7fce2dd2-53c0-11ec-091d-cf56c208a1f3
# ╟─7fce2df0-53c0-11ec-264c-fb4ad1575fd7
# ╟─7fce2e18-53c0-11ec-2804-c9122337ad8c
# ╟─7fce2e2c-53c0-11ec-303b-09d33db995a8
# ╟─7fce31e4-53c0-11ec-2167-dff3a699ffdf
# ╟─7fce3200-53c0-11ec-0522-ffdb2013a8d9
# ╟─7fce33a4-53c0-11ec-002e-47d7f6c941d6
# ╟─7fce33c2-53c0-11ec-04fc-e947a400d698
# ╟─7fce3598-53c0-11ec-38fe-510b83b38102
# ╟─7fce35b6-53c0-11ec-01e8-ab64bb07c10e
# ╟─7fce35d4-53c0-11ec-254f-192d039025ce
# ╟─7fce58e8-53c0-11ec-083f-a99b0ed382a6
# ╟─7fce591a-53c0-11ec-3e27-153885999e06
# ╟─7fce5940-53c0-11ec-0c9b-a53e5c3003a1
# ╟─7fce5988-53c0-11ec-31fd-9fcb86d2eccd
# ╟─7fce59b2-53c0-11ec-2398-f70802faf97a
# ╟─7fce779c-53c0-11ec-1670-778a424fad5d
# ╟─7fce77c4-53c0-11ec-0ee2-87f0c132217a
# ╟─7fce77ec-53c0-11ec-2a82-ef82daccb237
# ╟─7fce82be-53c0-11ec-2d85-db13d49cc3d5
# ╟─7fce82dc-53c0-11ec-388f-55aa93e12c5c
# ╟─7fce8304-53c0-11ec-389c-a75e9112cab8
# ╟─7fce945c-53c0-11ec-38a2-ad7862030362
# ╟─7fce94ac-53c0-11ec-39f4-835244a70379
# ╟─7fce94fe-53c0-11ec-34ad-69d3aedb4d14
# ╟─7fcea14a-53c0-11ec-0bfb-795315852776
# ╟─7fcea168-53c0-11ec-20b1-2b5d7948a22c
# ╟─7fcea190-53c0-11ec-13d5-038a6a5f8769
# ╟─7fcea4f6-53c0-11ec-061c-7bdd89fe19d5
# ╟─7fcea516-53c0-11ec-3f24-7f62e0dba273
# ╟─7fcea532-53c0-11ec-2f21-2db4bef5c035
# ╟─7fcea85c-53c0-11ec-1915-5d4b143d32b7
# ╟─7fcea878-53c0-11ec-18e3-91bbd36115dd
# ╟─7fcea8a2-53c0-11ec-18af-a500a7588003
# ╟─7fcecb02-53c0-11ec-368a-292b5061b8f7
# ╟─7fcecb2a-53c0-11ec-2694-9fbab1687479
# ╟─7fcecb5c-53c0-11ec-29d3-8b8bb66a5466
# ╟─7fced39a-53c0-11ec-3ba0-c705539158db
# ╟─7fced3ba-53c0-11ec-02a9-dd464713452b
# ╟─7fced3c2-53c0-11ec-1c09-af47aa23f7af
# ╟─7fced3cc-53c0-11ec-3461-59a8fca47694
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
