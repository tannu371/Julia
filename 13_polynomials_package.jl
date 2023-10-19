### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ ff8b7520-53c0-11ec-295b-abe68aaa56fe
begin
	using Plots
	using Polynomials
	using RealPolynomialRoots
end

# ╔═╡ ff92b1e6-53c0-11ec-095f-d115b5d8218a
using PlutoUI

# ╔═╡ ff92b1c8-53c0-11ec-2cb1-257d1350f8fe
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ ff8b55f4-53c0-11ec-39dc-ed961d7c12ae
md"""# The Polynomials package
"""

# ╔═╡ ff8b5630-53c0-11ec-2d77-0d91bea6ed08
md"""This section will use the following add-on packages:
"""

# ╔═╡ ff8b7930-53c0-11ec-2bc9-b76557672636
begin
	import CalculusWithJulia
	import CalculusWithJulia.WeaveSupport
	import CalculusWithJulia.WeaveSupport: note, radioq, yesnoq, numericq
	__DIR__, __FILE__ = :precalc, :polynomials_package
	nothing
end

# ╔═╡ ff8b796e-53c0-11ec-0f23-a1e9be79ec73
md"""---
"""

# ╔═╡ ff8b7a00-53c0-11ec-04f5-0ba11c8c01e1
md"""While `SymPy` can be used to represent polynomials, there are also native `Julia` packages available for this and related tasks. These packages include `Polynomials` and `AbstractAlgebra`, among many others. (A search on [juliahub.com](juliahub.com) found over 50 packages matching "polynomial".) We will look at the `Polynomials` package in the following, as it is straightforward to use and provides the features we are looking at for univariate polynomials.
"""

# ╔═╡ ff8b7a2a-53c0-11ec-3db4-931c16f007c8
md"""## Construction
"""

# ╔═╡ ff8b7a72-53c0-11ec-3c81-b3b3b175a428
md"""The polynomial expression $p = a_0 + a_1\cdot x + a_2\cdot x^2 + \cdots + a_n\cdot x^n$ can be viewed mathematically as a vector of numbers with respect to some "basis", which for standard polynomials, as above, is just the set of monomials, $1, x, x^2, \dots, x^n$. With this viewpoint, the polynomial $p$ can be identified with the vector `[a0, a1, a2, ..., an]`. The `Polynomials` package provides a wrapper for such an identification through the `Polynomial` constructor. We have previously loaded this add-on package.
"""

# ╔═╡ ff8b7a8e-53c0-11ec-3cce-952e5722134c
md"""To illustrate, the polynomial $p = 3 + 4x + 5x^2$ is constructed with
"""

# ╔═╡ ff8b7fca-53c0-11ec-0a9d-877d41807f5f
p = Polynomial([3,4,5])

# ╔═╡ ff8b7ffc-53c0-11ec-1f7c-0d8d429c066b
md"""where the vector `[3,4,5]` represents the coefficients. The polynomial $q = 3 + 5x^2 + 7x^4$ has some coefficients that are $0$, these too must be indicated on construction, so we would have:
"""

# ╔═╡ ff8b8466-53c0-11ec-12be-cf80609238e1
q = Polynomial([3,0,5,0,7])

# ╔═╡ ff8b848e-53c0-11ec-0bad-ff68d1e23068
md"""The `coeffs` function undoes `Polynomial`, returning the coefficients from a `Polynomial` object.
"""

# ╔═╡ ff8b861e-53c0-11ec-22fc-c7575c5120a2
coeffs(q)

# ╔═╡ ff8b8632-53c0-11ec-27ea-9fa4a1cf1392
md"""Once defined, the usual arithmetic operations for polynomials follow:
"""

# ╔═╡ ff8b87ac-53c0-11ec-0e62-cf2e0c6f65ba
p + q

# ╔═╡ ff8b8a88-53c0-11ec-11c7-eff012fbe10d
p*q + p^2

# ╔═╡ ff8b8ace-53c0-11ec-2bf6-31bd5398847e
md"""A polynomial has several familiar methods, such as `degree`:
"""

# ╔═╡ ff8b8f10-53c0-11ec-3bd0-91b2e36a68ed
degree(p), degree(q)

# ╔═╡ ff8b8f4c-53c0-11ec-0936-99aee3fed06d
md"""The zero polynomial has degree `-1`, by convention.
"""

# ╔═╡ ff8b8f60-53c0-11ec-2355-e15b9c157edb
md"""Polynomials may be evaluated using function notation, that is:
"""

# ╔═╡ ff8b91a4-53c0-11ec-26c8-f378decf10be
p(1)

# ╔═╡ ff8f57ec-53c0-11ec-0624-a38152242a18
md"""This blurs the distinction between a polynomial expression – a formal object consisting of an indeterminate, coefficients, and the operations of addition, subtraction, multiplication, and non-negative integer powers – and a polynomial function.
"""

# ╔═╡ ff8f58a2-53c0-11ec-0f04-939940fd9219
md"""The polynomial variable, in this case `1x`, can be returned by `variable`:
"""

# ╔═╡ ff8f5d34-53c0-11ec-1894-19d20961e81e
x = variable(p)

# ╔═╡ ff8f5d66-53c0-11ec-07bb-b9b14be1b3c2
md"""This variable is a `Polynomial` object, so can be manipulated as a polynomial; we can then construct polynomials through expressions like:
"""

# ╔═╡ ff8f64e6-53c0-11ec-2e1b-2ddb9bcbef15
r = (x-2)^3 * (x-1) * (x+1)

# ╔═╡ ff8f6538-53c0-11ec-01db-358565b278cf
md"""The product is expanded for storage by `Polynomials`, which may not be desirable for some uses. A new variable can produced by calling `variable()`; so we could have constructed `p` by:
"""

# ╔═╡ ff8f6970-53c0-11ec-21a3-4faedba3b6c0
let
	x = variable()
	3 + 4x + 5x^2
end

# ╔═╡ ff8f69c8-53c0-11ec-0982-ef0c60d6a294
md"""A polynomial in factored form, as `r` above is, can be constructed from its roots. Above, `r` has roots $2$ (twice), $1$, and $-1$. Passing these as a vector to `fromroots` re-produces `r`:
"""

# ╔═╡ ff8f6da8-53c0-11ec-3d25-133a52f1e8d7
fromroots([2,2,1,-1])

# ╔═╡ ff8f6e00-53c0-11ec-2950-ebe7ba8abb08
md"""The `fromroots` function is basically the [factor thereom](https://en.wikipedia.org/wiki/Factor_theorem) which links the factored form of the polynomial with the roots of the polynomial: $(x-k)$ is a factor of $p$ if and only if $k$ is a root of $p$. By combining a factor of the type $(x-k)$ for each specified root, the polynomial can be constructed by multiplying its factors. For example, using `prod` and a generarator, we would have:
"""

# ╔═╡ ff8f71ae-53c0-11ec-011f-f348e4c57de8
let
	x = variable()
	prod(x - k for k in [2,2,1,-1])
end

# ╔═╡ ff8f71d4-53c0-11ec-103e-87cfdca4b014
md"""The `Polynomials` package has different ways to represent polynomials, and a factored form can also be used. For example, the `fromroots` function constructs polynomials from the specified roots and `FactoredPolynomial` leaves these in a factored form:
"""

# ╔═╡ ff8f7652-53c0-11ec-13ef-470b4ae73a40
fromroots(FactoredPolynomial, [2, 2, 1, -1])

# ╔═╡ ff8f7670-53c0-11ec-20d7-6fd283bf1c6f
md"""This form is helpful for some operations, for example polynomial multiplication and positive integer exponentiation, but not others such as addition of polynomials, where such polynomials must first be converted to the standard basis to add and are then converted back into a factored form.
"""

# ╔═╡ ff8f7684-53c0-11ec-0e0a-2f8a45408cb0
md"""---
"""

# ╔═╡ ff8f76ca-53c0-11ec-2c6c-2dcd200d724d
md"""The indeterminate, or polynomial symbol is a related, but different concept to `variable`. Polynomials are stored as a collection of coefficients, an implicit basis, *and* a symbol, in the above this symbol is `:x`. A polynomial's symbol is checked to ensure that polynomials with different symbols are not algebraically combined, except for the special case of constant polynomials. The symbol is specified through a second argument on construction:
"""

# ╔═╡ ff8f7b70-53c0-11ec-1bda-832220a3a488
s = Polynomial([1,2,3], "t")

# ╔═╡ ff8f7b98-53c0-11ec-1710-e111f0d8b2ec
md"""As `r` uses "`x`", and `s` a "`t`" the two can not be added, say:
"""

# ╔═╡ ff8f7d14-53c0-11ec-1e7a-17f38efc178a
r + s

# ╔═╡ ff8f7d32-53c0-11ec-2e52-ab1c1d579ecd
md"""## Graphs
"""

# ╔═╡ ff919bf0-53c0-11ec-317d-75a5333e00c1
md"""Polynomial objects have a plot recipe defined – plotting from the `Plots` package should be as easy as calling `plot`:
"""

# ╔═╡ ff91a152-53c0-11ec-2fca-47d7b9a75549
plot(r, legend=false)  # suppress the legend

# ╔═╡ ff91a198-53c0-11ec-3d36-d3a36da3f109
md"""The choice of domain is heuristically identified; it and can be manually adjusted, as with:
"""

# ╔═╡ ff91a592-53c0-11ec-058a-33f66eda3585
plot(r, 1.5, 2.5, legend=false)

# ╔═╡ ff91a5bc-53c0-11ec-2cc4-a5e979e8270d
md"""## Roots
"""

# ╔═╡ ff91a60c-53c0-11ec-28fe-1b81242880a0
md"""The default `plot` recipe checks to ensure the real roots of the polynomial are included in the domain of the plot. To do this, it must identify the roots. This is done *numerically* by the `roots` function, as in this example:
"""

# ╔═╡ ff91aa58-53c0-11ec-19a1-c387e39df125
let
	x = variable()
	p = x^5 - x - 1
	roots(p)
end

# ╔═╡ ff91aabc-53c0-11ec-3558-4b344d0b8076
md"""A consequence of the fundamental theorem of algebra and the factor theorem is that any fifth degree polynomial with integer coefficients has $5$ roots, where possibly some are complex. For real coefficients, these complex values must come in conjugate pairs, which can be observed from the output. The lone real root is approximately `1.1673039782614187`. This value being a numeric approximation to the irrational root.
"""

# ╔═╡ ff91b6ce-53c0-11ec-0b00-a7fa6013e7f4
note("""
`SymPy` also has a `roots` function. If both `Polynomials` and `SymPy` are used together, calling `roots` must be qualified, as with `Polynomials.roots(...)`. Similarly, `degree` is provided in both, so it too must be qualified.
""")

# ╔═╡ ff91b716-53c0-11ec-059f-733f83d2a147
md"""The `roots` function numerically identifies roots. As such, it is susceptible to floating point issues. For example, the following polynomial has one root with multiplicity $5$, but $5$ distinct roots are numerically identified:
"""

# ╔═╡ ff91ba98-53c0-11ec-20ca-6d9f5b8141b0
let
	x = variable()
	p = (x-1)^5
	roots(p)
end

# ╔═╡ ff91bad4-53c0-11ec-1557-179d34dc88c7
md"""The `Polynomials` package has the `multroot` function to identify roots of polynomials when there are multiplicities expected. This function is not exported, so is called through:
"""

# ╔═╡ ff91be26-53c0-11ec-3fd4-e33aa4c50caf
let
	x = variable()
	p = (x-1)^5
	Polynomials.Multroot.multroot(p)
end

# ╔═╡ ff91be44-53c0-11ec-37f4-476edbc9ca90
md"""Floating point error can also prevent the finding of real roots. For example, this polynomial has 3 real roots, but `roots` finds but 1, as the two nearby ones are identified as complex:
"""

# ╔═╡ ff91c1a0-53c0-11ec-12f5-f3d42f83a185
let
	x = variable()
	p = -1 + 254x - 16129x^2 + x^9
	roots(p)
end

# ╔═╡ ff91c1be-53c0-11ec-3848-7102400f7be7
md"""The `RealPolynomialRoots` package, loaded at the top, can assist in the case of identifying real roots of square-free polynomials (no multiple roots). For example:
"""

# ╔═╡ ff91cb26-53c0-11ec-1d73-d311fa7fbcd2
let
	ps = coeffs(-1 + 254x - 16129x^2 + x^9)
	st = ANewDsc(ps)
	refine_roots(st)
end

# ╔═╡ ff91cb50-53c0-11ec-2d1b-875a237128dc
md"""## Fitting a polynomial to data
"""

# ╔═╡ ff91cb8c-53c0-11ec-23f4-219b38fbdfcb
md"""The fact that two distinct points determine a line is well known. Deriving the line is easy. Say we have two points $(x_0, y_0)$ and $(x_1, y_1)$. The *slope* is then
"""

# ╔═╡ ff91cbca-53c0-11ec-3b52-83a84f9b09c1
md"""```math
m = \frac{y_1 - y_0}{x_1 - x_0}, \quad x_1 \neq x_0
```
"""

# ╔═╡ ff91cc04-53c0-11ec-3289-152e6fc963cd
md"""The line is then given from the *point-slope* form by, say, $y= y_0 + m\cdot (x-x_0)$. This all assumes, $x_1 \neq x_0$, as were that the case the slope would be infinite (though the vertical line `x=x_0` would still be determined).
"""

# ╔═╡ ff91cc7c-53c0-11ec-3ae9-a5aaab40759e
md"""A line, `y=mx+b` can be a linear polynomial or a constant depending on $m$, so we could say $2$ points determine a polynomial of degree $1$ or less. Similarly, $3$ distinct points determine a degree $2$ polynomial or less, $\dots$, $n+1$ distinct points determine a degree $n$ or less polynomial. Finding a polynomial, $p$  that goes through $n+1$ points (i.e., $p(x_i)=y_i$ for each $i$) is called  [polynomial interpolation](https://en.wikipedia.org/wiki/Polynomial_interpolation). The main theorem says if the $x_i$ are distinct, there is a unique polynomial of degree $n$ *or* less that will interpolate each of the points.
"""

# ╔═╡ ff91ccae-53c0-11ec-3dad-3d6f53fc6750
md"""Knowing we can succeed, we approach the problem of $3$ points, say $(x_0, y_0)$, $(x_1,y_1)$, and $(x_2, y_2)$. There is a polynomial $p = a\cdot x^2 + b\cdot x + c$ with $p(x_i) = y_i$. This gives 3 equations for the 3 unknown values $a$, $b$, and $c$:
"""

# ╔═╡ ff91ccc2-53c0-11ec-2dc0-79300924e389
md"""```math
\begin{align*}
a\cdot x_0^2 + b\cdot x_0 + c &= y_0\\
a\cdot x_1^2 + b\cdot x_1 + c &= y_1\\
a\cdot x_2^2 + b\cdot x_2 + c &= y_2\\
\end{align*}
```
"""

# ╔═╡ ff91cce0-53c0-11ec-0bc8-3d4de39c2681
md"""Solving this with `SymPy` is tractable. A comprehension is used below to create the $3$ equations; the `zip` function is a simple means to iterate over 2 or more iterables simultaneously:
"""

# ╔═╡ ff91cef2-53c0-11ec-193a-bf74d3d9ce30
import SymPy # imported only so some functions, e.g. degree, need qualification

# ╔═╡ ff91d8f2-53c0-11ec-3b0c-df43929055a5
begin
	SymPy.@syms a b c xs[0:2] ys[0:2]
	eqs = [a*xi^2 + b*xi + c ~ yi for (xi,yi) in zip(xs, ys)]
	abc = SymPy.solve(eqs, [a,b,c])
end

# ╔═╡ ff91d91a-53c0-11ec-231c-f72c30f0c1d6
md"""As can be seen, the terms do get quite unwieldy when treated symbolically. Numerically, the `fit` function from the `Polynomials` package will return the interpolating polynomial. To compare,
"""

# ╔═╡ ff91ddfc-53c0-11ec-03f3-93ac695be174
fit(Polynomial, [1,2,3], [3,1,2])

# ╔═╡ ff91de0e-53c0-11ec-21bb-6363b2f8d250
md"""and we can compare that the two give the same answer with, for example:
"""

# ╔═╡ ff91e5fe-53c0-11ec-13a2-af12cf0de3c6
abc[b]((xs .=> [1,2,3])..., (ys .=>[3,1,2])...)

# ╔═╡ ff91e626-53c0-11ec-1894-6b4070b4e640
md"""(Ignore the tricky way of substituting in each value of `xs` and `ys` for the symbolic values in `x` and `y`.)
"""

# ╔═╡ ff91e658-53c0-11ec-2350-17c079508d01
md"""##### Example Inverse quadratic interpolation
"""

# ╔═╡ ff91e6bc-53c0-11ec-0baa-cdcfd733b388
md"""A related problem, that will arise when finding iterative means to solve for zeros of functions, is *inverse* quadratic interpolation. That is finding $q$ that goes through the points $(x_0,y_0), (x_1, y_1), \dots, (x_n, y_n)$ satisfying $q(y_i) = x_i$. (That is $x$ and $y$ are reversed, as with inverse functions.) For the envisioned task, where the inverse quadratic function  intersects the $x$ axis is of interest, which is at the constant term of the polynomial (as it is like the $y$ intercept of  typical polynomial). Let's see what that is in general by replicating the above steps (though now the assumption is the $y$ values are distinct):
"""

# ╔═╡ ff91ef72-53c0-11ec-3440-8399a9c94f64
let
	SymPy.@syms a b c xs[0:2] ys[0:2]
	eqs = [a*yi^2 + b*yi + c ~ xi for (xi, yi) in zip(xs,ys)]
	abc = SymPy.solve(eqs, [a,b,c])
	abc[c]
end

# ╔═╡ ff91efa4-53c0-11ec-2a6d-c1eff0064132
md"""We can graphically see the result for the specific values of `xs` and `ys` as follows:
"""

# ╔═╡ ff920f8e-53c0-11ec-3dcb-534d4b768cf9
let
	SymPy.@syms a b c xs[0:2] ys[0:2]
	eqs = [a*yi^2 + b*yi + c ~ xi for (xi, yi) in zip(xs,ys)]
	abc = SymPy.solve(eqs, [a,b,c])
	abc[c]
	
	𝒙s, 𝒚s = [1,2,3], [3,1,2]
	q = fit(Polynomial, 𝒚s,  𝒙s)  # reverse
	# plot
	us = range(-1/4, 4, length=100)
	vs = q.(us)
	plot(vs, us, legend=false)
	scatter!(𝒙s, 𝒚s)
	plot!(zero)
	x0 = abc[c]((xs .=> 𝒙s)..., (ys .=> 𝒚s)...)
	scatter!([SymPy.N(x0)], [0], markershape=:star)
end

# ╔═╡ ff920fc0-53c0-11ec-2c3d-71dd50690f9c
md"""## Questions
"""

# ╔═╡ ff920fe8-53c0-11ec-3e7a-a11172b75972
md"""###### Question
"""

# ╔═╡ ff921026-53c0-11ec-012d-1d8927ae56a2
md"""Do the polynomials $p = x^4$ and $q = x^2 - 2$ intersect?
"""

# ╔═╡ ff922a3c-53c0-11ec-08a4-e178ca7b7015
let
	x = variable()
	p,q = x^4, x^2 - 2
	st = ANewDsc(coeffs(p-q))
	yesnoq(length(st) > 0)
end

# ╔═╡ ff922a64-53c0-11ec-17e2-b72573533a16
md"""###### Question
"""

# ╔═╡ ff922a8c-53c0-11ec-20cf-1d11d2ce2262
md"""Do the polynomials $p = x^4-4$ and $q = x^2 - 2$ intersect?
"""

# ╔═╡ ff922dfc-53c0-11ec-0643-2331a9575bd5
let
	x = variable()
	p,q = x^4-4, x^2 - 2
	st = ANewDsc(coeffs(p-q))
	yesnoq(length(st) > 0)
end

# ╔═╡ ff922e1a-53c0-11ec-0798-f75b0feb7b14
md"""###### Question
"""

# ╔═╡ ff922e38-53c0-11ec-28b0-d108dd5b3852
md"""How many real roots does $p = 1 + x + x^2 + x^3 + x^4 + x^5$ have?
"""

# ╔═╡ ff92317e-53c0-11ec-2537-9fe9c3213822
let
	x = variable()
	p = 1 + x + x^2 + x^3 + x^4 + x^5
	st = (ANewDsc∘coeffs)(p)
	numericq(length(st))
end

# ╔═╡ ff923194-53c0-11ec-2580-bfddea50194e
md"""###### Question
"""

# ╔═╡ ff9231c6-53c0-11ec-09f5-37d10af8c652
md"""Mathematically we say the $0$ polynomial has ano degree. What convention does `Polynomials` use? (Look at `degree(zero(Polynomial))`.)
"""

# ╔═╡ ff92398e-53c0-11ec-1232-3164a5508803
let
	choices = ["`nothing`", "-1", "0", "Inf", "-Inf"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ ff9239a0-53c0-11ec-17f9-87a0644c8436
md"""###### Question
"""

# ╔═╡ ff9239bc-53c0-11ec-0efa-579f93462966
md"""Consider the polynomial $p(x) = a_1 x - a_3 x^3 + a_5 x^5$ where
"""

# ╔═╡ ff9239dc-53c0-11ec-3728-2b3d9422b5c4
md"""```math
\begin{align*}
a_1 &= 4(\frac{3}{\pi} - \frac{9}{16}) \\
a_3 &= 2a_1 -\frac{5}{2}\\
a_5 &= a_1 - \frac{3}{2}.
\end{align*}
```
"""

# ╔═╡ ff923b62-53c0-11ec-1aba-cde17d4e8a43
md"""  * Form the polynomial `p` by first computing the $a$s and forming `p=Polynomial([0,a1,0,-a3,0,a5])`
  * Form the polynomial `q` by these commands `x=variable(); q=p(2x/pi)`
"""

# ╔═╡ ff923b9e-53c0-11ec-3166-3f10b6f5b23c
md"""The polynomial `q`, a $5$th-degree polynomial, is a good approximation of for the [sine](http://www.coranac.com/2009/07/sines/) function.
"""

# ╔═╡ ff923bb2-53c0-11ec-0317-0191e89478cd
md"""Make graphs of both `q` and `sin`. Over which interval is the approximation (visually) a good one?
"""

# ╔═╡ ff924292-53c0-11ec-1a41-1135a9045a63
let
	choices = ["``[0,1]``",
	"``[0,\\pi]``",
	"``[0,2\\pi]``"]
	radioq(choices, 1, keep_order=true)
end

# ╔═╡ ff9242e2-53c0-11ec-1611-abaa48bbe73c
md"""(This [blog post](https://www.nullhardware.com/blog/fixed-point-sine-and-cosine-for-embedded-systems/) shows how this approximation is valuable under some specific circumstances.)
"""

# ╔═╡ ff9242f6-53c0-11ec-2dc7-0dcafa153a88
md"""###### Question
"""

# ╔═╡ ff92430a-53c0-11ec-3cef-91768bd3ecef
md"""The polynomial
"""

# ╔═╡ ff92467a-53c0-11ec-0f96-ffdebb81e1b0
fromroots([1,2,3,3,5])

# ╔═╡ ff9246b6-53c0-11ec-280a-c5cb7f63552d
md"""has $5$ sign changes and $5$ real roots. For `x = variable()` use `div(p, x-3)` to find the result of dividing $p$ by $x-3$. How many sign changes are there in the new polynomial?
"""

# ╔═╡ ff9248aa-53c0-11ec-3c0d-3144157e296c
let
	numericq(4)
end

# ╔═╡ ff9248be-53c0-11ec-3518-db149da8ddd7
md"""###### Question
"""

# ╔═╡ ff924918-53c0-11ec-1f02-4b82d3dea6b2
md"""The identification of a collection of coefficients with a polynomial depends on an understood **basis**. A basis for the polynomials of degree $n$ or less, consists of a minimal collection of polynomials for which all the polynomials of degree $n$ or less can be expressed through a combination of sums of terms, each of which is just a coefficient times a basis member. The typical basis is the $n+$ polynomials $1`, `x`, `x^2, \dots, x^n$. However, though every basis must have $n+1$ members, they need not be these.
"""

# ╔═╡ ff92494a-53c0-11ec-1087-8f67d7e47260
md"""A basis used by [Lagrange](https://en.wikipedia.org/wiki/Lagrange_polynomial) is the following. Let there be $n+1$ points distinct points $x_0, x_1, \dots, x_n$. For each $i$ in $0$ to $n$ define
"""

# ╔═╡ ff924972-53c0-11ec-036d-4d6b0bba1fed
md"""```math
l_i(x) = \prod_{0 \leq j \leq n; j \ne i} \frac{x-x_j}{x_i - x_j} =
\frac{(x-x_1)\cdot(x-x_2)\cdot \cdots \cdot (x-x_{j-1}) \cdot (x-x_{j+1}) \cdot \cdots \cdot (x-x_n)}{(x_i-x_1)\cdot(x_i-x_2)\cdot \cdots \cdot (x_i-x_{j-1}) \cdot (x_i-x_{j+1}) \cdot \cdots \cdot (x_i-x_n)}.
```
"""

# ╔═╡ ff9249a6-53c0-11ec-2dcb-a1d72cfff862
md"""That is $l_i(x)$ is a product of terms like $(x-x_j)/(x_i-x_j)$ *except* when $j=i$.
"""

# ╔═╡ ff9249b8-53c0-11ec-0f04-bb5630c62cfa
md"""What is is the value of $l_0(x_0)$?
"""

# ╔═╡ ff924ba0-53c0-11ec-1a8f-d187fc756d2e
let
	numericq(1)
end

# ╔═╡ ff924bb6-53c0-11ec-2514-97094a83ec9c
md"""Why?
"""

# ╔═╡ ff926cea-53c0-11ec-26ce-296568ef70be
let
	choices = ["""
	All terms like ``(x-x_j)/(x_0 - x_j)`` will be ``1`` when ``x=x_0`` and these are all the terms in the product defining ``l_0``.
	""",
		"The term ``(x_0-x_0)`` will be ``0``, so the product will be zero"
		]
	radioq(choices, 1)
end

# ╔═╡ ff926d26-53c0-11ec-02af-2f33c6b1c205
md"""What is the value of $l_i(x_i)$?
"""

# ╔═╡ ff926f10-53c0-11ec-20a2-51f10cbbd21f
let
	numericq(1)
end

# ╔═╡ ff926f36-53c0-11ec-0a27-ef37a7278f0e
md"""What is the value of $l_0(x_1)$?
"""

# ╔═╡ ff9270d0-53c0-11ec-3407-1195091557f1
let
	numericq(0)
end

# ╔═╡ ff9270e6-53c0-11ec-2349-9bad205aeb9c
md"""Why?
"""

# ╔═╡ ff927d14-53c0-11ec-0923-9fd05d463d59
let
	choices = ["""
	The term like ``(x-x_1)/(x_0 - x_1)`` will be ``0`` when ``x=x_1`` and so the product will be ``0``.
	""",
		"The term ``(x-x_1)/(x_0-x_1)`` is omitted from the product, so the answer is non-zero."
		]
	radioq(choices, 1)
end

# ╔═╡ ff927d46-53c0-11ec-27cc-df35e60877df
md"""What is the value of $l_i(x_j)$ *if* $i \ne j$?
"""

# ╔═╡ ff927ef6-53c0-11ec-0ffc-156825703bc2
let
	numericq(0)
end

# ╔═╡ ff927f32-53c0-11ec-2993-8b4db389eb11
md"""Suppose the $x_0, x_1, \dots, x_n$ are the $x$ coordinates of $n$ distinct points $(x_0,y_0)$, $(x_1, y_1), \dots, (x_n,y_n)$. Form the polynomial with the above basis and coefficients being the $y$ values. That is consider:
"""

# ╔═╡ ff927f52-53c0-11ec-1c85-b9f500ecaa1e
md"""```math
p(x) = \sum_{i=0}^n y_i l_i(x) = y_0l_0(x) + y_1l_1(x) + \dots + y_nl_n(x)
```
"""

# ╔═╡ ff927f64-53c0-11ec-32ed-3fd9caa7ed29
md"""What is the value of $p(x_j)$?
"""

# ╔═╡ ff928552-53c0-11ec-02cd-2339c1d6789d
let
	choices = ["``0``", "``1``", "``y_j``"]
	radioq(choices, 3)
end

# ╔═╡ ff92857c-53c0-11ec-333f-bd5af0bc4963
md"""This last answer is why $p$ is called an *interpolating* polynomial and this question shows an alternative way to identify interpolating polynomials from solving a system of linear equations.
"""

# ╔═╡ ff92859a-53c0-11ec-2ea7-1518d1e1e11c
md"""###### Question
"""

# ╔═╡ ff9285c2-53c0-11ec-321b-5dc96bf2e902
md"""The Chebyshev ($T$) polynomials are polynomials which use a different basis from the standard basis. Denote the basis elements $T_0$, $T_1$, ... where we have $T_0(x) = 1$, $T_1(x) = x$, and for bigger indices $T_{i+1}(x) = 2xT_i(x) - T_{i-1}(x)$. The first others are then:
"""

# ╔═╡ ff9285e0-53c0-11ec-3a62-1bede468d9f6
md"""```math
\begin{align*}
T_2(x) &= 2xT_1(x) - T_0(x) = 2x^2 - 1\\
T_3(x) &= 2xT_2(x) - T_1(x) = 2x(2x^2-1) - x = 4x^3 - 3x\\
T_4(x) &= 2xT_3(x) - T_2(x) = 2x(4x^3-3x) - (2x^2-1) = 8x^4 - 8x^2 + 1
\end{align*}
```
"""

# ╔═╡ ff9285f4-53c0-11ec-1d02-27c2f0d19f6a
md"""With these definitions what is the polynomial associated to the coefficients $[0,1,2,3]$ with this basis?
"""

# ╔═╡ ff929600-53c0-11ec-0b9d-7f8829e0ee5a
let
	choices = [
			raw"""
			It is ``0\cdot 1 + 1 \cdot x + 2 \cdots x^2 + 3\cdot x^3 = x + 2x^2 + 3x^3``
			""",
		    raw"""
	It is ``0\cdot T_1(x) +	1\cdot T_1(x) + 2\cdot T_2(x) + 3\cdot T_3(x) = 0``
	""",
		    raw"""
	It is ``0\cdot T_1(x) +	1\cdot T_1(x) + 2\cdot T_2(x) + 3\cdot T_3(x) = -2 - 8\cdot x + 4\cdot x^2 + 12\cdot x^3```
	"""]
	radioq(choices, 3)
end

# ╔═╡ ff92b1b4-53c0-11ec-3bcc-b1e42629ca94
let
	note("""
	The `Polynomials` package has an implementation, so you can check your answer through `convert(Polynomial, ChebyshevT([0,1,2,3]))`. Similarly, the `SpecialPolynomials` package has these and many other polynomial bases represented.
	
	The `ApproxFun` package is built on top of polynomials expressed in this basis, as the Chebyshev polynomials have special properties which make them very suitable when approximating functions with polynomials. The `ApproxFun` package uses  easier-to-manipulate polynomials to approximate functions very accurately, thereby being useful for investigating properties of non-linear functions leveraging properties for polynomials.
	""")
end

# ╔═╡ ff92b1dc-53c0-11ec-01ee-973b3cc75a9c
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/polynomial_roots.html">◅ previous</a>  <a href="../precalc/rational_functions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/polynomials_package.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ ff92b1fc-53c0-11ec-04e1-6974ef3818e2
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
RealPolynomialRoots = "87be438c-38ae-47c4-9398-763eabe5c3be"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Polynomials = "~2.0.18"
RealPolynomialRoots = "~0.1.0"
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

[[deps.ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

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

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[deps.Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

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

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

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

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "7bb6853d9afec54019c1397c6eb610b9b9a19525"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.3.1"

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

[[deps.Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "79bcbb379205f1c62913fa9ebecb413c7a35f8b0"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.18"

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

[[deps.RealPolynomialRoots]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "aa5acc17f15ff874bea3dc4edea424ea93e7256f"
uuid = "87be438c-38ae-47c4-9398-763eabe5c3be"
version = "0.1.0"

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

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

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
# ╟─ff92b1c8-53c0-11ec-2cb1-257d1350f8fe
# ╟─ff8b55f4-53c0-11ec-39dc-ed961d7c12ae
# ╟─ff8b5630-53c0-11ec-2d77-0d91bea6ed08
# ╠═ff8b7520-53c0-11ec-295b-abe68aaa56fe
# ╟─ff8b7930-53c0-11ec-2bc9-b76557672636
# ╟─ff8b796e-53c0-11ec-0f23-a1e9be79ec73
# ╟─ff8b7a00-53c0-11ec-04f5-0ba11c8c01e1
# ╟─ff8b7a2a-53c0-11ec-3db4-931c16f007c8
# ╟─ff8b7a72-53c0-11ec-3c81-b3b3b175a428
# ╟─ff8b7a8e-53c0-11ec-3cce-952e5722134c
# ╠═ff8b7fca-53c0-11ec-0a9d-877d41807f5f
# ╟─ff8b7ffc-53c0-11ec-1f7c-0d8d429c066b
# ╠═ff8b8466-53c0-11ec-12be-cf80609238e1
# ╟─ff8b848e-53c0-11ec-0bad-ff68d1e23068
# ╠═ff8b861e-53c0-11ec-22fc-c7575c5120a2
# ╟─ff8b8632-53c0-11ec-27ea-9fa4a1cf1392
# ╠═ff8b87ac-53c0-11ec-0e62-cf2e0c6f65ba
# ╠═ff8b8a88-53c0-11ec-11c7-eff012fbe10d
# ╟─ff8b8ace-53c0-11ec-2bf6-31bd5398847e
# ╠═ff8b8f10-53c0-11ec-3bd0-91b2e36a68ed
# ╟─ff8b8f4c-53c0-11ec-0936-99aee3fed06d
# ╟─ff8b8f60-53c0-11ec-2355-e15b9c157edb
# ╠═ff8b91a4-53c0-11ec-26c8-f378decf10be
# ╟─ff8f57ec-53c0-11ec-0624-a38152242a18
# ╟─ff8f58a2-53c0-11ec-0f04-939940fd9219
# ╠═ff8f5d34-53c0-11ec-1894-19d20961e81e
# ╟─ff8f5d66-53c0-11ec-07bb-b9b14be1b3c2
# ╠═ff8f64e6-53c0-11ec-2e1b-2ddb9bcbef15
# ╟─ff8f6538-53c0-11ec-01db-358565b278cf
# ╠═ff8f6970-53c0-11ec-21a3-4faedba3b6c0
# ╟─ff8f69c8-53c0-11ec-0982-ef0c60d6a294
# ╠═ff8f6da8-53c0-11ec-3d25-133a52f1e8d7
# ╟─ff8f6e00-53c0-11ec-2950-ebe7ba8abb08
# ╠═ff8f71ae-53c0-11ec-011f-f348e4c57de8
# ╟─ff8f71d4-53c0-11ec-103e-87cfdca4b014
# ╠═ff8f7652-53c0-11ec-13ef-470b4ae73a40
# ╟─ff8f7670-53c0-11ec-20d7-6fd283bf1c6f
# ╟─ff8f7684-53c0-11ec-0e0a-2f8a45408cb0
# ╟─ff8f76ca-53c0-11ec-2c6c-2dcd200d724d
# ╠═ff8f7b70-53c0-11ec-1bda-832220a3a488
# ╟─ff8f7b98-53c0-11ec-1710-e111f0d8b2ec
# ╠═ff8f7d14-53c0-11ec-1e7a-17f38efc178a
# ╟─ff8f7d32-53c0-11ec-2e52-ab1c1d579ecd
# ╟─ff919bf0-53c0-11ec-317d-75a5333e00c1
# ╠═ff91a152-53c0-11ec-2fca-47d7b9a75549
# ╟─ff91a198-53c0-11ec-3d36-d3a36da3f109
# ╠═ff91a592-53c0-11ec-058a-33f66eda3585
# ╟─ff91a5bc-53c0-11ec-2cc4-a5e979e8270d
# ╟─ff91a60c-53c0-11ec-28fe-1b81242880a0
# ╠═ff91aa58-53c0-11ec-19a1-c387e39df125
# ╟─ff91aabc-53c0-11ec-3558-4b344d0b8076
# ╟─ff91b6ce-53c0-11ec-0b00-a7fa6013e7f4
# ╟─ff91b716-53c0-11ec-059f-733f83d2a147
# ╠═ff91ba98-53c0-11ec-20ca-6d9f5b8141b0
# ╟─ff91bad4-53c0-11ec-1557-179d34dc88c7
# ╠═ff91be26-53c0-11ec-3fd4-e33aa4c50caf
# ╟─ff91be44-53c0-11ec-37f4-476edbc9ca90
# ╠═ff91c1a0-53c0-11ec-12f5-f3d42f83a185
# ╟─ff91c1be-53c0-11ec-3848-7102400f7be7
# ╠═ff91cb26-53c0-11ec-1d73-d311fa7fbcd2
# ╟─ff91cb50-53c0-11ec-2d1b-875a237128dc
# ╟─ff91cb8c-53c0-11ec-23f4-219b38fbdfcb
# ╟─ff91cbca-53c0-11ec-3b52-83a84f9b09c1
# ╟─ff91cc04-53c0-11ec-3289-152e6fc963cd
# ╟─ff91cc7c-53c0-11ec-3ae9-a5aaab40759e
# ╟─ff91ccae-53c0-11ec-3dad-3d6f53fc6750
# ╟─ff91ccc2-53c0-11ec-2dc0-79300924e389
# ╟─ff91cce0-53c0-11ec-0bc8-3d4de39c2681
# ╠═ff91cef2-53c0-11ec-193a-bf74d3d9ce30
# ╠═ff91d8f2-53c0-11ec-3b0c-df43929055a5
# ╟─ff91d91a-53c0-11ec-231c-f72c30f0c1d6
# ╠═ff91ddfc-53c0-11ec-03f3-93ac695be174
# ╟─ff91de0e-53c0-11ec-21bb-6363b2f8d250
# ╠═ff91e5fe-53c0-11ec-13a2-af12cf0de3c6
# ╟─ff91e626-53c0-11ec-1894-6b4070b4e640
# ╟─ff91e658-53c0-11ec-2350-17c079508d01
# ╟─ff91e6bc-53c0-11ec-0baa-cdcfd733b388
# ╠═ff91ef72-53c0-11ec-3440-8399a9c94f64
# ╟─ff91efa4-53c0-11ec-2a6d-c1eff0064132
# ╠═ff920f8e-53c0-11ec-3dcb-534d4b768cf9
# ╟─ff920fc0-53c0-11ec-2c3d-71dd50690f9c
# ╟─ff920fe8-53c0-11ec-3e7a-a11172b75972
# ╟─ff921026-53c0-11ec-012d-1d8927ae56a2
# ╟─ff922a3c-53c0-11ec-08a4-e178ca7b7015
# ╟─ff922a64-53c0-11ec-17e2-b72573533a16
# ╟─ff922a8c-53c0-11ec-20cf-1d11d2ce2262
# ╟─ff922dfc-53c0-11ec-0643-2331a9575bd5
# ╟─ff922e1a-53c0-11ec-0798-f75b0feb7b14
# ╟─ff922e38-53c0-11ec-28b0-d108dd5b3852
# ╟─ff92317e-53c0-11ec-2537-9fe9c3213822
# ╟─ff923194-53c0-11ec-2580-bfddea50194e
# ╟─ff9231c6-53c0-11ec-09f5-37d10af8c652
# ╟─ff92398e-53c0-11ec-1232-3164a5508803
# ╟─ff9239a0-53c0-11ec-17f9-87a0644c8436
# ╟─ff9239bc-53c0-11ec-0efa-579f93462966
# ╟─ff9239dc-53c0-11ec-3728-2b3d9422b5c4
# ╟─ff923b62-53c0-11ec-1aba-cde17d4e8a43
# ╟─ff923b9e-53c0-11ec-3166-3f10b6f5b23c
# ╟─ff923bb2-53c0-11ec-0317-0191e89478cd
# ╟─ff924292-53c0-11ec-1a41-1135a9045a63
# ╟─ff9242e2-53c0-11ec-1611-abaa48bbe73c
# ╟─ff9242f6-53c0-11ec-2dc7-0dcafa153a88
# ╟─ff92430a-53c0-11ec-3cef-91768bd3ecef
# ╠═ff92467a-53c0-11ec-0f96-ffdebb81e1b0
# ╟─ff9246b6-53c0-11ec-280a-c5cb7f63552d
# ╟─ff9248aa-53c0-11ec-3c0d-3144157e296c
# ╟─ff9248be-53c0-11ec-3518-db149da8ddd7
# ╟─ff924918-53c0-11ec-1f02-4b82d3dea6b2
# ╟─ff92494a-53c0-11ec-1087-8f67d7e47260
# ╟─ff924972-53c0-11ec-036d-4d6b0bba1fed
# ╟─ff9249a6-53c0-11ec-2dcb-a1d72cfff862
# ╟─ff9249b8-53c0-11ec-0f04-bb5630c62cfa
# ╟─ff924ba0-53c0-11ec-1a8f-d187fc756d2e
# ╟─ff924bb6-53c0-11ec-2514-97094a83ec9c
# ╟─ff926cea-53c0-11ec-26ce-296568ef70be
# ╟─ff926d26-53c0-11ec-02af-2f33c6b1c205
# ╟─ff926f10-53c0-11ec-20a2-51f10cbbd21f
# ╟─ff926f36-53c0-11ec-0a27-ef37a7278f0e
# ╟─ff9270d0-53c0-11ec-3407-1195091557f1
# ╟─ff9270e6-53c0-11ec-2349-9bad205aeb9c
# ╟─ff927d14-53c0-11ec-0923-9fd05d463d59
# ╟─ff927d46-53c0-11ec-27cc-df35e60877df
# ╟─ff927ef6-53c0-11ec-0ffc-156825703bc2
# ╟─ff927f32-53c0-11ec-2993-8b4db389eb11
# ╟─ff927f52-53c0-11ec-1c85-b9f500ecaa1e
# ╟─ff927f64-53c0-11ec-32ed-3fd9caa7ed29
# ╟─ff928552-53c0-11ec-02cd-2339c1d6789d
# ╟─ff92857c-53c0-11ec-333f-bd5af0bc4963
# ╟─ff92859a-53c0-11ec-2ea7-1518d1e1e11c
# ╟─ff9285c2-53c0-11ec-321b-5dc96bf2e902
# ╟─ff9285e0-53c0-11ec-3a62-1bede468d9f6
# ╟─ff9285f4-53c0-11ec-1d02-27c2f0d19f6a
# ╟─ff929600-53c0-11ec-0b9d-7f8829e0ee5a
# ╟─ff92b1b4-53c0-11ec-3bcc-b1e42629ca94
# ╟─ff92b1dc-53c0-11ec-01ee-973b3cc75a9c
# ╟─ff92b1e6-53c0-11ec-095f-d115b5d8218a
# ╟─ff92b1fc-53c0-11ec-04e1-6974ef3818e2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
