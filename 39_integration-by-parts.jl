### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ d031298c-70d3-11ec-2771-63a6f1856316
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ d0312ccc-70d3-11ec-0a7a-830138d398f8
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	using QuadGK
	nothing
end

# ╔═╡ d031cbb4-70d3-11ec-38ff-517af7f603e7
using PlutoUI

# ╔═╡ d031cb8c-70d3-11ec-11d1-3bb8357e40a2
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ d031241e-70d3-11ec-1e12-8fed791bd3e8
md"""# Integration By Parts
"""

# ╔═╡ d0312448-70d3-11ec-3260-596f6d18ca60
md"""This section uses these add-on packages:
"""

# ╔═╡ d0312cf4-70d3-11ec-1cc6-871e9d54e097
md"""---
"""

# ╔═╡ d0312d3a-70d3-11ec-3651-7bf4aabe3af9
md"""So far we have seen that the *derivative* rules lead to *integration rules*. In particular:
"""

# ╔═╡ d0312e7a-70d3-11ec-29c7-a3be414ab34a
md"""  * The sum rule $[au(x) + bv(x)]' = au'(x) + bv'(x)$ gives rise to an integration rule: $\int (au(x) + bv(x))dx = a\int u(x)dx + b\int v(x))dx$. (That is, the linearity of the derivative means the integral has linearity.)
  * The chain rule $[f(g(x))]' = f'(g(x)) g'(x)$ gives $\int_a^b f(g(x))g'(x)dx=\int_{g(a)}^{g(b)}f(x)dx$. That is, substitution reverses the chain rule.
"""

# ╔═╡ d0312e9a-70d3-11ec-3d4a-d538945f9db4
md"""Now we turn our attention to the implications of the *product rule*: $[uv]' = u'v + uv'$. The resulting technique is called integration by parts.
"""

# ╔═╡ d0312ecc-70d3-11ec-2f1b-711ce9802847
md"""The following illustrates integration by parts of the integral $(uv)'$ over $[a,b]$ [original](http://en.wikipedia.org/wiki/Integration_by_parts#Visualization).
"""

# ╔═╡ d031358c-70d3-11ec-343e-19858c006729
begin
	## parts picture
	u(x) = sin(x*pi/2)
	v(x) = x
	xs = range(0, stop=1, length=50)
	a,b = 1/4, 3/4
	p = plot(u, v, 0, 1, legend=false)
	plot!(p, zero, 0, 1)
	scatter!(p, [u(a), u(b)], [v(a), v(b)], color=:orange, markersize=5)
	
	plot!(p, [u(a),u(a),0, 0, u(b),u(b),u(a)], [0, v(a), v(a), v(b), v(b), 0, 0], linetype=:polygon, fillcolor=:orange, alpha=0.25)
	#plot!(p, [u(a),u(a),0],  [0, v(a), v(a)], color=:orange)
	#plot!(p,  [u(b),u(b),0], [0, v(b), v(b)], color=:orange)
	annotate!(p, [(0.65, .25, "A"), (0.4, .55, "B")])
	annotate!(p, [(u(a),v(a) + .08, "(u(a),v(a))"), (u(b),v(b)+.08, "(u(b),v(b))")])
end

# ╔═╡ d03135f0-70d3-11ec-23d4-4f47e00c83c7
md"""The figure is a parametric plot of $(u,v)$ with the points $(u(a), v(a))$ and $(u(b), v(b))$ marked. The difference $u(b)v(b) - u(a)v(a) = u(x)v(x) \mid_a^b$ is shaded.  This area breaks into two pieces, $A$ and $B$, partitioned by the curve. If $u$ is increasing and the curve is parameterized by $t \rightarrow u^{-1}(t)$, then $A=\int_{u^{-1}(a)}^{u^{-1}(b)} v(u^{-1}(t))dt$. A $u$-substitution with $t = u(x)$ changes this into the integral $\int_a^b v(x) u'(x) dx$. Similarly, for increasing $v$, it can be seen that $B=\int_a^b u(x) v'(x) dx$. This suggests a relationship between the integral of $u v'$, the integral of $u' v$ and the value $u(b)v(b) - u(a)v(a)$.
"""

# ╔═╡ d0313602-70d3-11ec-3218-173e8f9f5e4b
md"""In terms of formulas, by the fundamental theorem of calculus:
"""

# ╔═╡ d031362c-70d3-11ec-147b-2f56365cd0e8
md"""```math
u(x)\cdot v(x)\big|_a^b = \int_a^b [u(x) v(x)]' dx = \int_a^b u'(x) \cdot v(x) dx + \int_a^b u(x) \cdot v'(x) dx.
```
"""

# ╔═╡ d0313634-70d3-11ec-0de0-ab01121dd5ca
md"""This is re-expressed as
"""

# ╔═╡ d031364a-70d3-11ec-139e-bb74263d6893
md"""```math
\int_a^b u(x) \cdot v'(x) dx = u(x) \cdot v(x)\big|_a^b -  \int_a^b v(x) \cdot u'(x) dx,
```
"""

# ╔═╡ d031365e-70d3-11ec-1651-d181435ed2b9
md"""Or, more informally, as $\int udv = uv - \int v du$.
"""

# ╔═╡ d0313672-70d3-11ec-05fa-376ec83f6a9f
md"""This can sometimes be confusingly written as:
"""

# ╔═╡ d031367c-70d3-11ec-2ea1-9d969ce9a274
md"""```math
\int f(x) g'(x) dx = f(x)g(x) - \int f'(x) g(x) dx.
```
"""

# ╔═╡ d0313690-70d3-11ec-0c0f-fb3abe0a4d64
md"""(The confusion coming from the fact that the indefinite integrals are only defined up to a constant.)
"""

# ╔═╡ d03136a6-70d3-11ec-199c-1933c2a44edf
md"""How does this help? It allows us to differentiate parts of an integral in hopes it makes the result easier to integrate.
"""

# ╔═╡ d03136b8-70d3-11ec-104a-496ad678ad9b
md"""An illustration can clarify.
"""

# ╔═╡ d03136e0-70d3-11ec-21be-d34a055c25d8
md"""Consider the integral $\int_0^\pi x\sin(x) dx$. If we let $u=x$ and $dv=\sin(x) dx$, then $du = 1dx$ and $v=-\cos(x)$. The above then says:
"""

# ╔═╡ d03136f4-70d3-11ec-028c-63201400ae7a
md"""```math
\begin{align*}
\int_0^\pi x\sin(x) dx &= \int_0^\pi u dv\\
&= uv\big|_0^\pi - \int_0^\pi v du\\
&= x \cdot (-\cos(x)) \big|_0^\pi - \int_0^\pi (-\cos(x)) dx\\
&= \pi (-\cos(\pi)) - 0(-\cos(0)) + \int_0^\pi \cos(x) dx\\
&= \pi + \sin(x)\big|_0^\pi\\
&= \pi.
\end{align*}
```
"""

# ╔═╡ d031370a-70d3-11ec-3289-5fc6ed01743a
md"""The technique means one part is differentiated and one part integrated. The art is to break the integrand up into a piece that gets easier through differentiation and a piece that doesn't get much harder through integration.
"""

# ╔═╡ d0313738-70d3-11ec-15e6-cf57c5295714
md"""#### Examples
"""

# ╔═╡ d0313758-70d3-11ec-1d24-19a20df929b9
md"""Consider $\int_1^2 x \log(x) dx$. We might try differentiating the $\log(x)$ term, so we set
"""

# ╔═╡ d031376a-70d3-11ec-2d88-63ad6fc58df4
md"""```math
u=\log(x) \text{ and  } dv=xdx
```
"""

# ╔═╡ d0313776-70d3-11ec-070d-19d0087e29a8
md"""Then we get
"""

# ╔═╡ d0313780-70d3-11ec-2327-ffab4a071e34
md"""```math
du = \frac{1}{x} dx \text{ and } v = \frac{x^2}{2}.
```
"""

# ╔═╡ d0313794-70d3-11ec-3414-ad8f1f8bf0e2
md"""Putting together gives:
"""

# ╔═╡ d031379c-70d3-11ec-0bbc-8ffb45f191e1
md"""```math
\begin{align*}
\int_1^2 x \log(x) dx
&= (\log(x) \cdot \frac{x^2}{2}) \big|_1^2 - \int_1^2 \frac{x^2}{2} \frac{1}{x} dx\\
&= (2\log(2) - 0) - (\frac{x^2}{4})\big|_1^2\\
&= 2\log(2) - (1 - \frac{1}{4}) \\
&= 2\log(2) - \frac{3}{4}.
\end{align*}
```
"""

# ╔═╡ d03137d0-70d3-11ec-24fe-4db4d264216c
md"""##### Example
"""

# ╔═╡ d03137f8-70d3-11ec-3f8d-41396f778311
md"""This related problem, $\int \log(x) dx$, uses the same idea, though perhaps harder to see at first glance, as setting `dv=dx` is almost too simple to try:
"""

# ╔═╡ d031380e-70d3-11ec-0954-852dc487d1e4
md"""```math
\begin{align*}
u &= \log(x) & dv &= dx\\
du &= \frac{1}{x}dx & v &= x
\end{align*}
```
"""

# ╔═╡ d0313820-70d3-11ec-23b3-c19b10541ad1
md"""```math
\begin{align*}
\int \log(x) dx
&= \int u dv\\
&= uv - \int v du\\
&= (\log(x) \cdot x) - \int x \cdot \frac{1}{x} dx\\
&= x \log(x) - \int dx\\
&= x \log(x) - x
\end{align*}
```
"""

# ╔═╡ d0313834-70d3-11ec-1d7a-1d8c5a5f2eb6
md"""Were this a definite integral problem, we would have written:
"""

# ╔═╡ d0313840-70d3-11ec-2689-1121c2c7a30b
md"""```math
\int_a^b \log(x) dx = (x\log(x))\big|_a^b - \int_a^b dx = (x\log(x) - x)\big|_a^b.
```
"""

# ╔═╡ d0313852-70d3-11ec-2abe-2b8b0a63eaca
md"""##### Example
"""

# ╔═╡ d0313872-70d3-11ec-0012-291c083d281e
md"""Sometimes integration by parts is used two or more times. Here we let $u=x^2$ and $dv = e^x dx$:
"""

# ╔═╡ d031387a-70d3-11ec-0273-bfc67dfefc04
md"""```math
\int_a^b x^2 e^x dx = (x^2 \cdot e^x)\big|_a^b - \int_a^b 2x e^x dx.
```
"""

# ╔═╡ d0313898-70d3-11ec-22ee-8b37e1a35f8d
md"""But we can do $\int_a^b x e^xdx$ the same way:
"""

# ╔═╡ d03138ac-70d3-11ec-0aed-3d8bff170992
md"""```math
\int_a^b x e^x = (x\cdot e^x)\big|_a^b - \int_a^b 1 \cdot e^xdx = (xe^x - e^x)\big|_a^b.
```
"""

# ╔═╡ d03138b6-70d3-11ec-164d-0936dcf7f8e4
md"""Combining gives the answer:
"""

# ╔═╡ d03138ca-70d3-11ec-382d-4bc3833a90f5
md"""```math
\int_a^b x^2 e^x dx
= (x^2 \cdot e^x)\big|_a^b - 2( (xe^x - e^x)\big|_a^b ) =
e^x(x^2  - 2x - 1) \big|_a^b.
```
"""

# ╔═╡ d03138e8-70d3-11ec-1ed6-cf931f21ebf1
md"""In fact, it isn't hard to see that an integral of $x^m e^x$, $m$ a positive integer, can be handled in this manner. For example, when $m=10$, `SymPy` gives:
"""

# ╔═╡ d0313c80-70d3-11ec-008d-818e946fe452
begin
	@syms x
	integrate(x^10 * exp(x), x)
end

# ╔═╡ d0313cbc-70d3-11ec-028f-f17745491c66
md"""The general answer is $\int x^n e^xdx = p(x) e^x$, where $p(x)$ is a polynomial of degree $n$.
"""

# ╔═╡ d0313cd0-70d3-11ec-05d3-174a184c7453
md"""##### Example
"""

# ╔═╡ d0313cee-70d3-11ec-1b2f-19cf93ca5761
md"""The same technique is attempted for  this integral, but ends differently. First in the following we let $u=\sin(x)$ and $dv=e^x dx$:
"""

# ╔═╡ d0313d0a-70d3-11ec-1c05-d1a085c680c5
md"""```math
\int e^x \sin(x)dx = \sin(x) e^x - \int \cos(x) e^x dx.
```
"""

# ╔═╡ d0313d2a-70d3-11ec-05c0-553748ec32f5
md"""Now we let $u = \cos(x)$ and again $dv=e^x dx$:
"""

# ╔═╡ d0313d3e-70d3-11ec-33ac-7319d66cd9b9
md"""```math
\int e^x \sin(x)dx = \sin(x) e^x - \int \cos(x) e^x dx = \sin(x)e^x - \cos(x)e^x - \int (-\sin(x))e^x dx.
```
"""

# ╔═╡ d0313d52-70d3-11ec-2db4-796c74d6e16c
md"""But simplifying this gives:
"""

# ╔═╡ d0313d66-70d3-11ec-112f-6f0010e7be79
md"""```math
\int e^x \sin(x)dx = - \int e^x \sin(x)dx +  e^x(\sin(x) - \cos(x)).
```
"""

# ╔═╡ d0313d84-70d3-11ec-2e3e-75019a0d3d35
md"""Solving for the "unknown" $\int e^x \sin(x) dx$ gives:
"""

# ╔═╡ d0313d98-70d3-11ec-2023-9f02c8c0090b
md"""```math
\int e^x \sin(x) dx = \frac{1}{2} e^x (\sin(x) - \cos(x)).
```
"""

# ╔═╡ d0313dae-70d3-11ec-35a9-ff7bfae446bb
md"""##### Example
"""

# ╔═╡ d0313dd4-70d3-11ec-3115-edb774fb1b1b
md"""Positive integer powers of trigonometric functions can be addressed by this technique. Consider $\int \cos(x)^n dx$. We let $u=\cos(x)^{n-1}$ and $dv=\cos(x) dx$. Then $du = (n-1)\cos(x)^{n-2}(-\sin(x))dx$ and $v=\sin(x)$. So,
"""

# ╔═╡ d0313de8-70d3-11ec-02c9-dfbf1dc4c3dd
md"""```math
\begin{align*}
\int \cos(x)^n dx &= \cos(x)^{n-1} \cdot (\sin(x)) - \int (\sin(x)) ((n-1)\sin(x) \cos(x)^{n-2}) dx \\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int \sin^2(x) \cos(x)^{n-1} dx\\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int (1 - \cos(x)^2) \cos(x)^{n-2} dx\\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int \cos(x)^{n-2}dx - (n-1)\int \cos(x)^n dx.
\end{align*}
```
"""

# ╔═╡ d0313e0e-70d3-11ec-0e92-b13fc432b5b6
md"""We can then solve for the unknown ($\int \cos(x)^{n}dx$) to get this *reduction formula*:
"""

# ╔═╡ d0313e1a-70d3-11ec-3183-2f46733a19db
md"""```math
\int \cos(x)^n dx = \frac{1}{n}\sin(x) \cos(x)^{n-1} + \frac{n-1}{n}\int \cos(x)^{n-2}dx.
```
"""

# ╔═╡ d0313e40-70d3-11ec-1d23-41edb6bdea6a
md"""This is called a reduction formula as it reduces the problem from an integral with a power of $n$ to one with a power of $n - 2$, so could be repeated until the remaining indefinite integral required knowing either $\int \cos(x) dx$ (which is $-\sin(x)$) or $\int \cos(x)^2 dx$, which by a double angle formula application, is $x/2 - \sin(2x)/4$.
"""

# ╔═╡ d0313e6a-70d3-11ec-0673-35f4e896f520
md"""`SymPy` is quite able to do this repeated bookkeeping. For example with $n=10$:
"""

# ╔═╡ d031416c-70d3-11ec-2e6b-9d14e94ca3bf
integrate(cos(x)^10, x)

# ╔═╡ d031418a-70d3-11ec-0804-7b7ad894d566
md"""##### Example
"""

# ╔═╡ d0315922-70d3-11ec-1a29-f732a24b9151
md"""The visual interpretation of integration by parts breaks area into two pieces, the one labeled "B" looks like it would be labeled "A" for an inverse function for $f$. Indeed, integration by parts gives a means to possibly find antiderivatives for inverse functions.
"""

# ╔═╡ d031597c-70d3-11ec-1395-43b9d8d77b55
md"""Let $uv = x f^{-1}(x)$. Then we have $[uv]' = u'v + uv' = f^{-1}(x) + x [f^{-1}(x)]'$. So, up to a constant $uv = \int [uv]'dx = \int f^{-1}(x) + \int  x [f^{-1}(x)]'$. Re-expressing gives:
"""

# ╔═╡ d0315998-70d3-11ec-093a-417e1d3ff924
md"""```math
\begin{align*}
\int f^{-1}(x) dx
&= xf^{-1}(x) - \int x [f^{-1}(x)]' dx\\
&= xf^{-1}(x) - \int f(u) du.\\
\end{align*}
```
"""

# ╔═╡ d03159b8-70d3-11ec-3ade-ddcf768ea63c
md"""The last line follows from the $u$-substitution: $u=f^{-1}(x)$ for then $du = [f^{-1}(x)]' dx$ and $x=f(u)$.
"""

# ╔═╡ d03159d6-70d3-11ec-2f41-3f9e5753534e
md"""We use this to find an antiderivative for $\sin^{-1}(x)$:
"""

# ╔═╡ d03159ea-70d3-11ec-1824-6d4c3a55df6e
md"""```math
\begin{align*}
\int \sin^{-1}(x) dx &= x \sin^{-1}(x) - \int \sin(u) du \\
&=  x \sin^{-1}(x) + \cos(u) \\
&= x \sin^{-1}(x) + \cos(\sin^{-1}(x)).
\end{align*}
```
"""

# ╔═╡ d0315a08-70d3-11ec-087f-8b1820614834
md"""Using right triangles to simplify, the last value $\cos(\sin^{-1}(x))$ can otherwise be written as $\sqrt{1 - x^2}$.
"""

# ╔═╡ d0315a1c-70d3-11ec-0328-6f6ca98dd141
md"""##### Example
"""

# ╔═╡ d0315a4e-70d3-11ec-119b-07f0a09edbb8
md"""The [trapezoid](http://en.wikipedia.org/wiki/Trapezoidal_rule) rule is an approximation to the definite integral like a Riemann sum, only instead of approximating the area above $[x_i, x_i + h]$ by a rectangle with height $f(c_i)$ (for some $c_i$), it uses a trapezoid formed by the left and right endpoints. That is, this area is used in the estimation: $(1/2)\cdot (f(x_i) + f(x_i+h)) \cdot h$.
"""

# ╔═╡ d0315a6e-70d3-11ec-220f-cfc17847db56
md"""Even though we suggest just using `quadgk` for numeric integration, estimating the error in this approximation is still of some theoretical interest.
"""

# ╔═╡ d0315aa0-70d3-11ec-0612-29d0fd530e2d
md"""Recall, just using *either* $x_i$ or $x_{i-1}$ for $c_i$ gives an error that is "like" $1/n$, as $n$ gets large, though the exact rate depends on the function and the length of the interval.
"""

# ╔═╡ d0315ae4-70d3-11ec-1453-75c02ad2b598
md"""This [proof](http://www.math.ucsd.edu/~ebender/20B/77_Trap.pdf) for the error estimate is involved, but is reproduced here, as it nicely integrates many of the theoretical concepts of integration discussed so far.
"""

# ╔═╡ d0315b20-70d3-11ec-0084-37df203293c9
md"""First, for convenience, we consider the interval $x_i$ to $x_i+h$. The actual answer over this is just $\int_{x_i}^{x_i+h}f(x) dx$. By a $u$-substitution with $u=x-x_i$ this becomes $\int_0^h f(t + x_i) dt$. For analyzing this we integrate once by parts using $u=f(t+x_i)$ and $dv=dt$. But instead of letting $v=t$, we choose to add - as is our prerogative - a constant of integration $A$, so $v=t+A$:
"""

# ╔═╡ d0315b3e-70d3-11ec-02a2-49f067946ba2
md"""```math
\begin{align*}
\int_0^h f(t + x_i) dt &= uv \big|_0^h - \int_0^h v du\\
&= f(t+x_i)(t+A)\big|_0^h - \int_0^h (t + A) f'(t + x_i) dt.
\end{align*}
```
"""

# ╔═╡ d0315b66-70d3-11ec-17ca-47be2eb3dd73
md"""We choose $A$ to be $-h/2$, any constant is possible, for then the term $f(t+x_i)(t+A)\big|_0^h$ becomes $(1/2)(f(x_i+h) + f(x_i)) \cdot h$, or the trapezoid approximation. This means, the error over this interval - actual minus estimate - satisfies:
"""

# ╔═╡ d0315b7a-70d3-11ec-217b-13f2cfeac947
md"""```math
\text{error}_i = \int_{x_i}^{x_i+h}f(x) dx - \frac{f(x_i+h) -f(x_i)}{2} \cdot h  = - \int_0^h (t + A) f'(t + x_i) dt.
```
"""

# ╔═╡ d0315b8e-70d3-11ec-31ec-db3f7cab7e55
md"""For this, we *again* integrate by parts with
"""

# ╔═╡ d0315ba2-70d3-11ec-24dc-533bc70fc20c
md"""```math
\begin{align*}
u  &= f'(t + x_i)  & dv &= (t + A)dt\\
du &= f''(t + x_i) & v  &= \frac{(t + A)^2}{2} + B
\end{align*}
```
"""

# ╔═╡ d0315bc0-70d3-11ec-11e6-adc125d2f2f3
md"""Again we added a constant of integration, $B$, to  $v$. The  error becomes:
"""

# ╔═╡ d0315bca-70d3-11ec-3f01-977b3920b5c0
md"""```math
\text{error}_i = -(\frac{(t+A)^2}{2} + B)f'(t+x_i)\big|_0^h + \int_0^h (\frac{(t+A)^2}{2} + B) \cdot f''(t+x_i) dt.
```
"""

# ╔═╡ d0315bf2-70d3-11ec-00dd-fb776a3ad3ad
md"""With $A=-h/2$, $B$ is chosen so $(t+A)^2/2 + B = 0$, or  $B=-h^2/8$. The error becomes
"""

# ╔═╡ d0315c08-70d3-11ec-3e2e-11a85176136f
md"""```math
\text{error}_i = \int_0^h \left(\frac{(t-h/2)^2}{2} - \frac{h^2}{8}\right) \cdot f''(t + x_i) dt.
```
"""

# ╔═╡ d0315c24-70d3-11ec-04f9-4372ff2078c8
md"""Now, we assume the $\lvert f''(t)\rvert$ is bounded by $K$ for any $a \leq t \leq b$. This will be true, for example, if the second derivative is assumed to exist and be continuous.  Using this fact about definite integrals $\lvert \int_a^b g dx\rvert \leq \int_a^b \lvert g \rvert dx$ we have:
"""

# ╔═╡ d0315c36-70d3-11ec-22dc-bf09701f9d41
md"""```math
\lvert \text{error}_i  \rvert \leq K \int_0^h \lvert (\frac{(t-h/2)^2}{2} - \frac{h^2}{8}) \rvert dt.
```
"""

# ╔═╡ d0315c4c-70d3-11ec-0540-79ad281fa964
md"""But what is the function in the integrand? Clearly it is a quadratic in $t$. Expanding gives $1/2 \cdot (t^2 - ht)$.  This is negative over $[0,h]$ (and $0$ at these endpoints, so the integral above is just:
"""

# ╔═╡ d0315c60-70d3-11ec-3f1f-fb7474b6198b
md"""```math
\frac{1}{2}\int_0^h (ht - t^2)dt = \frac{1}{2} (\frac{ht^2}{2} - \frac{t^3}{3})\big|_0^h = \frac{h^3}{12}
```
"""

# ╔═╡ d0315c7e-70d3-11ec-079e-4794ade409f1
md"""This gives the bound: $\vert \text{error}_i \rvert \leq K h^3/12$. The *total* error may be less, but is not more than the value found by adding up the error over each of the $n$ intervals. As our bound does not depend on the $i$, we have this sum satisfies:
"""

# ╔═╡ d0315c92-70d3-11ec-1cb4-b50c3b53071d
md"""```math
\lvert \text{error}\rvert \leq n \cdot \frac{Kh^3}{12} = \frac{K(b-a)^3}{12}\frac{1}{n^2}.
```
"""

# ╔═╡ d0315cb0-70d3-11ec-1ce2-8d0bade9c171
md"""So the error is like $1/n^2$, in contrast to the $1/n$ error of the Riemann sums. One way to see this, for the Riemann sum it takes twice as many terms to half an error estimate, but for the trapezoid rule only $\sqrt{2}$ as many, and for Simpson's rule, only $2^{1/4}$ as many.
"""

# ╔═╡ d0315cd8-70d3-11ec-2bc4-e565599970ee
md"""## Questions
"""

# ╔═╡ d0315d0c-70d3-11ec-0c31-273a1970b84c
md"""###### Question
"""

# ╔═╡ d0315d32-70d3-11ec-05d7-357a2f90f9c6
md"""In the integral of $\int \log(x) dx$ we let $u=\log(x)$ and $dv=dx$. What are $du$ and $v$?
"""

# ╔═╡ d031662e-70d3-11ec-1e08-23ec037bd4c2
let
	choices = [
	"``du=1/x dx \\quad v = x``",
	"``du=x\\log(x) dx\\quad v = 1``",
	"``du=1/x dx\\quad v = x^2/2``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d0316656-70d3-11ec-0534-4baee89ffcb5
md"""###### Question
"""

# ╔═╡ d031667e-70d3-11ec-121f-5bef4edc30c4
md"""In the integral $\int \sec(x)^3 dx$ we let $u=\sec(x)$ and $dv = \sec(x)^2 dx$. What are $du$ and $v$?
"""

# ╔═╡ d0316fb4-70d3-11ec-1249-ad7e52ca5bcb
let
	choices = [
	"``du=\\sec(x)\\tan(x)dx \\quad v=\\tan(x)``",
	"``du=\\csc(x) dx \\quad v=\\sec(x)^3 / 3``",
	"``du=\\tan(x)  dx \\quad v=\\sec(x)\\tan(x)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d0316fd4-70d3-11ec-209f-1babe94e060b
md"""###### Question
"""

# ╔═╡ d0317006-70d3-11ec-2a2c-09bc814aabea
md"""In the integral $\int e^{-x} \cos(x)dx$ we let $u=e^{-x}$ and $dv=\cos(x) dx$. What are $du$ and $v$?
"""

# ╔═╡ d0317862-70d3-11ec-306e-99ef9985696d
let
	choices = [
	"``du=-e^{-x} dx \\quad v=\\sin(x)``",
	"``du=-e^{-x} dx \\quad v=-\\sin(x)``",
	"``du=\\sin(x)dx \\quad v=-e^{-x}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d0317880-70d3-11ec-23eb-f36e4b85c2fd
md"""###### Question
"""

# ╔═╡ d03178a8-70d3-11ec-39e7-5b8f04eb92aa
md"""Find the value of $\int_1^4 x \log(x) dx$. You can integrate by parts.
"""

# ╔═╡ d0317ce0-70d3-11ec-031b-e9c225b5843c
let
	f(x) = x*log(x)
	a,b = 1,4
	val,err = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ d0317cf4-70d3-11ec-2eb4-d173e64c25c6
md"""###### Question
"""

# ╔═╡ d0317d1c-70d3-11ec-1b33-05c21b92d1da
md"""Find the value of $\int_0^{\pi/2} x\cos(2x) dx$. You can integrate by parts.
"""

# ╔═╡ d03181ea-70d3-11ec-0a66-91021bb1ad18
let
	f(x) = x*cos(2x)
	a,b = 0, pi/2
	val,err = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ d0318208-70d3-11ec-2697-337958337f63
md"""###### Question
"""

# ╔═╡ d0318226-70d3-11ec-261a-9f01b69872b6
md"""Find the value of $\int_1^e (\log(x))^2 dx$. You can integrate by parts.
"""

# ╔═╡ d0318642-70d3-11ec-0edc-532279553198
let
	f(x) = log(x)^2
	a,b = 1,exp(1)
	val,err = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ d0318654-70d3-11ec-004a-fdc701eebdeb
md"""###### Question
"""

# ╔═╡ d031867c-70d3-11ec-3295-bb0107a3d196
md"""Integration by parts can be used to provide "reduction" formulas, where an antiderivative is written in terms of another antiderivative with a lower power. Which is the proper reduction formula for $\int (\log(x))^n dx$?
"""

# ╔═╡ d0318f76-70d3-11ec-30f8-b79648af1df5
let
	choices = [
	"``x(\\log(x))^n - n \\int (\\log(x))^{n-1} dx``",
	"``\\int (\\log(x))^{n+1}/(n+1) dx``",
	"``x(\\log(x))^n - \\int (\\log(x))^{n-1} dx``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d0318f96-70d3-11ec-3b8a-f77a6b71202e
md"""###### Question
"""

# ╔═╡ d031900e-70d3-11ec-1b34-abd8d51ebe96
md"""The [Wikipedia](http://en.wikipedia.org/wiki/Integration_by_parts) page has a rule of thumb with an acronym LIATE to indicate what is a good candidate to be "$u$": **L**og function, **I**nverse functions, **A**lgebraic functions ($x^n$), **T**rigonmetric functions, and **E**xponential functions.
"""

# ╔═╡ d0319022-70d3-11ec-0537-4342924c5822
md"""Consider the integral $\int x \cos(x) dx$. Which letter should be tried first?
"""

# ╔═╡ d0319630-70d3-11ec-3623-6191f8dfda16
let
	choices = ["L", "I", "A", "T", "E"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d031964c-70d3-11ec-16c1-f79595baa024
md"""---
"""

# ╔═╡ d0319676-70d3-11ec-06a7-db77be55d852
md"""Consider the integral $\int x^2\log(x) dx$. Which letter should be tried first?
"""

# ╔═╡ d0319c70-70d3-11ec-23c2-21a4713b6b27
let
	choices = ["L", "I", "A", "T", "E"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d0319c90-70d3-11ec-304b-fd09ff3eb1c4
md"""---
"""

# ╔═╡ d0319cac-70d3-11ec-2e7e-f73b458b2105
md"""Consider the integral $\int x^2 \sin^{-1}(x) dx$. Which letter should be tried first?
"""

# ╔═╡ d031bb38-70d3-11ec-2a0e-e53b98be817b
let
	choices = ["L", "I", "A", "T", "E"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d031bb6a-70d3-11ec-3ba4-13ecd1d292ce
md"""---
"""

# ╔═╡ d031bba6-70d3-11ec-1a2f-2ddd2fa28a49
md"""Consider the integral $\int e^x \sin(x) dx$. Which letter should be tried first?
"""

# ╔═╡ d031c254-70d3-11ec-08ab-65156c429a57
let
	choices = ["L", "I", "A", "T", "E"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ d031c27c-70d3-11ec-1dde-358f045eae45
md"""###### Question
"""

# ╔═╡ d031c2a4-70d3-11ec-3934-4d081bf0acc7
md"""Find an antiderivative for $\cos^{-1}(x)$ using the integration by parts formula.
"""

# ╔═╡ d031cb82-70d3-11ec-07cb-63017a5868d5
let
	choices = [
	"``x\\cos^{-1}(x)-\\sqrt{1 - x^2}``",
	"``x^2/2 \\cos^{-1}(x) - x\\sqrt{1-x^2}/4 - \\cos^{-1}(x)/4``",
	"``-\\sin^{-1}(x)``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ d031cbaa-70d3-11ec-3633-53186d9d3707
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/substitution.html">◅ previous</a>  <a href="../integrals/partial_fractions.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/integration_by_parts.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ d031cbbe-70d3-11ec-3ac9-4f1617d99c53
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.13"
Plots = "~1.25.4"
PlutoUI = "~0.7.29"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
SymPy = "~1.1.2"
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
git-tree-sha1 = "1ee88c4c76caa995a885dc2f22a5d548dfbbc0ba"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.2"

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
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "ae958b53cc06c6b3d5d5b0847a3d858075136417"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.13"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "926870acb6cbcf029396f2f2de030282b6bc1941"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.4"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

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
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

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
git-tree-sha1 = "2b72a5624e289ee18256111657663721d59c143e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.24"

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
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "b9a93bcdf34618031891ee56aad94cfff0843753"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f97acd98255568c3c9b416c5a3cf246c1315771b"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.0+0"

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
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

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
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "71d65e9242935132e71c4fbf084451579491166a"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "7711172ace7c40dc8449b7aed9d2d6f1cf56a5bd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.29"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

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
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

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

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "7f5a513baec6f122401abfc8e9c074fdac54f6c1"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "88a559da57529581472320892576a486fa2377b9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.1"

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
# ╟─d031cb8c-70d3-11ec-11d1-3bb8357e40a2
# ╟─d031241e-70d3-11ec-1e12-8fed791bd3e8
# ╟─d0312448-70d3-11ec-3260-596f6d18ca60
# ╠═d031298c-70d3-11ec-2771-63a6f1856316
# ╟─d0312ccc-70d3-11ec-0a7a-830138d398f8
# ╟─d0312cf4-70d3-11ec-1cc6-871e9d54e097
# ╟─d0312d3a-70d3-11ec-3651-7bf4aabe3af9
# ╟─d0312e7a-70d3-11ec-29c7-a3be414ab34a
# ╟─d0312e9a-70d3-11ec-3d4a-d538945f9db4
# ╟─d0312ecc-70d3-11ec-2f1b-711ce9802847
# ╠═d031358c-70d3-11ec-343e-19858c006729
# ╟─d03135f0-70d3-11ec-23d4-4f47e00c83c7
# ╟─d0313602-70d3-11ec-3218-173e8f9f5e4b
# ╟─d031362c-70d3-11ec-147b-2f56365cd0e8
# ╟─d0313634-70d3-11ec-0de0-ab01121dd5ca
# ╟─d031364a-70d3-11ec-139e-bb74263d6893
# ╟─d031365e-70d3-11ec-1651-d181435ed2b9
# ╟─d0313672-70d3-11ec-05fa-376ec83f6a9f
# ╟─d031367c-70d3-11ec-2ea1-9d969ce9a274
# ╟─d0313690-70d3-11ec-0c0f-fb3abe0a4d64
# ╟─d03136a6-70d3-11ec-199c-1933c2a44edf
# ╟─d03136b8-70d3-11ec-104a-496ad678ad9b
# ╟─d03136e0-70d3-11ec-21be-d34a055c25d8
# ╟─d03136f4-70d3-11ec-028c-63201400ae7a
# ╟─d031370a-70d3-11ec-3289-5fc6ed01743a
# ╟─d0313738-70d3-11ec-15e6-cf57c5295714
# ╟─d0313758-70d3-11ec-1d24-19a20df929b9
# ╟─d031376a-70d3-11ec-2d88-63ad6fc58df4
# ╟─d0313776-70d3-11ec-070d-19d0087e29a8
# ╟─d0313780-70d3-11ec-2327-ffab4a071e34
# ╟─d0313794-70d3-11ec-3414-ad8f1f8bf0e2
# ╟─d031379c-70d3-11ec-0bbc-8ffb45f191e1
# ╟─d03137d0-70d3-11ec-24fe-4db4d264216c
# ╟─d03137f8-70d3-11ec-3f8d-41396f778311
# ╟─d031380e-70d3-11ec-0954-852dc487d1e4
# ╟─d0313820-70d3-11ec-23b3-c19b10541ad1
# ╟─d0313834-70d3-11ec-1d7a-1d8c5a5f2eb6
# ╟─d0313840-70d3-11ec-2689-1121c2c7a30b
# ╟─d0313852-70d3-11ec-2abe-2b8b0a63eaca
# ╟─d0313872-70d3-11ec-0012-291c083d281e
# ╟─d031387a-70d3-11ec-0273-bfc67dfefc04
# ╟─d0313898-70d3-11ec-22ee-8b37e1a35f8d
# ╟─d03138ac-70d3-11ec-0aed-3d8bff170992
# ╟─d03138b6-70d3-11ec-164d-0936dcf7f8e4
# ╟─d03138ca-70d3-11ec-382d-4bc3833a90f5
# ╟─d03138e8-70d3-11ec-1ed6-cf931f21ebf1
# ╠═d0313c80-70d3-11ec-008d-818e946fe452
# ╟─d0313cbc-70d3-11ec-028f-f17745491c66
# ╟─d0313cd0-70d3-11ec-05d3-174a184c7453
# ╟─d0313cee-70d3-11ec-1b2f-19cf93ca5761
# ╟─d0313d0a-70d3-11ec-1c05-d1a085c680c5
# ╟─d0313d2a-70d3-11ec-05c0-553748ec32f5
# ╟─d0313d3e-70d3-11ec-33ac-7319d66cd9b9
# ╟─d0313d52-70d3-11ec-2db4-796c74d6e16c
# ╟─d0313d66-70d3-11ec-112f-6f0010e7be79
# ╟─d0313d84-70d3-11ec-2e3e-75019a0d3d35
# ╟─d0313d98-70d3-11ec-2023-9f02c8c0090b
# ╟─d0313dae-70d3-11ec-35a9-ff7bfae446bb
# ╟─d0313dd4-70d3-11ec-3115-edb774fb1b1b
# ╟─d0313de8-70d3-11ec-02c9-dfbf1dc4c3dd
# ╟─d0313e0e-70d3-11ec-0e92-b13fc432b5b6
# ╟─d0313e1a-70d3-11ec-3183-2f46733a19db
# ╟─d0313e40-70d3-11ec-1d23-41edb6bdea6a
# ╟─d0313e6a-70d3-11ec-0673-35f4e896f520
# ╠═d031416c-70d3-11ec-2e6b-9d14e94ca3bf
# ╟─d031418a-70d3-11ec-0804-7b7ad894d566
# ╟─d0315922-70d3-11ec-1a29-f732a24b9151
# ╟─d031597c-70d3-11ec-1395-43b9d8d77b55
# ╟─d0315998-70d3-11ec-093a-417e1d3ff924
# ╟─d03159b8-70d3-11ec-3ade-ddcf768ea63c
# ╟─d03159d6-70d3-11ec-2f41-3f9e5753534e
# ╟─d03159ea-70d3-11ec-1824-6d4c3a55df6e
# ╟─d0315a08-70d3-11ec-087f-8b1820614834
# ╟─d0315a1c-70d3-11ec-0328-6f6ca98dd141
# ╟─d0315a4e-70d3-11ec-119b-07f0a09edbb8
# ╟─d0315a6e-70d3-11ec-220f-cfc17847db56
# ╟─d0315aa0-70d3-11ec-0612-29d0fd530e2d
# ╟─d0315ae4-70d3-11ec-1453-75c02ad2b598
# ╟─d0315b20-70d3-11ec-0084-37df203293c9
# ╟─d0315b3e-70d3-11ec-02a2-49f067946ba2
# ╟─d0315b66-70d3-11ec-17ca-47be2eb3dd73
# ╟─d0315b7a-70d3-11ec-217b-13f2cfeac947
# ╟─d0315b8e-70d3-11ec-31ec-db3f7cab7e55
# ╟─d0315ba2-70d3-11ec-24dc-533bc70fc20c
# ╟─d0315bc0-70d3-11ec-11e6-adc125d2f2f3
# ╟─d0315bca-70d3-11ec-3f01-977b3920b5c0
# ╟─d0315bf2-70d3-11ec-00dd-fb776a3ad3ad
# ╟─d0315c08-70d3-11ec-3e2e-11a85176136f
# ╟─d0315c24-70d3-11ec-04f9-4372ff2078c8
# ╟─d0315c36-70d3-11ec-22dc-bf09701f9d41
# ╟─d0315c4c-70d3-11ec-0540-79ad281fa964
# ╟─d0315c60-70d3-11ec-3f1f-fb7474b6198b
# ╟─d0315c7e-70d3-11ec-079e-4794ade409f1
# ╟─d0315c92-70d3-11ec-1cb4-b50c3b53071d
# ╟─d0315cb0-70d3-11ec-1ce2-8d0bade9c171
# ╟─d0315cd8-70d3-11ec-2bc4-e565599970ee
# ╟─d0315d0c-70d3-11ec-0c31-273a1970b84c
# ╟─d0315d32-70d3-11ec-05d7-357a2f90f9c6
# ╟─d031662e-70d3-11ec-1e08-23ec037bd4c2
# ╟─d0316656-70d3-11ec-0534-4baee89ffcb5
# ╟─d031667e-70d3-11ec-121f-5bef4edc30c4
# ╟─d0316fb4-70d3-11ec-1249-ad7e52ca5bcb
# ╟─d0316fd4-70d3-11ec-209f-1babe94e060b
# ╟─d0317006-70d3-11ec-2a2c-09bc814aabea
# ╟─d0317862-70d3-11ec-306e-99ef9985696d
# ╟─d0317880-70d3-11ec-23eb-f36e4b85c2fd
# ╟─d03178a8-70d3-11ec-39e7-5b8f04eb92aa
# ╟─d0317ce0-70d3-11ec-031b-e9c225b5843c
# ╟─d0317cf4-70d3-11ec-2eb4-d173e64c25c6
# ╟─d0317d1c-70d3-11ec-1b33-05c21b92d1da
# ╟─d03181ea-70d3-11ec-0a66-91021bb1ad18
# ╟─d0318208-70d3-11ec-2697-337958337f63
# ╟─d0318226-70d3-11ec-261a-9f01b69872b6
# ╟─d0318642-70d3-11ec-0edc-532279553198
# ╟─d0318654-70d3-11ec-004a-fdc701eebdeb
# ╟─d031867c-70d3-11ec-3295-bb0107a3d196
# ╟─d0318f76-70d3-11ec-30f8-b79648af1df5
# ╟─d0318f96-70d3-11ec-3b8a-f77a6b71202e
# ╟─d031900e-70d3-11ec-1b34-abd8d51ebe96
# ╟─d0319022-70d3-11ec-0537-4342924c5822
# ╟─d0319630-70d3-11ec-3623-6191f8dfda16
# ╟─d031964c-70d3-11ec-16c1-f79595baa024
# ╟─d0319676-70d3-11ec-06a7-db77be55d852
# ╟─d0319c70-70d3-11ec-23c2-21a4713b6b27
# ╟─d0319c90-70d3-11ec-304b-fd09ff3eb1c4
# ╟─d0319cac-70d3-11ec-2e7e-f73b458b2105
# ╟─d031bb38-70d3-11ec-2a0e-e53b98be817b
# ╟─d031bb6a-70d3-11ec-3ba4-13ecd1d292ce
# ╟─d031bba6-70d3-11ec-1a2f-2ddd2fa28a49
# ╟─d031c254-70d3-11ec-08ab-65156c429a57
# ╟─d031c27c-70d3-11ec-1dde-358f045eae45
# ╟─d031c2a4-70d3-11ec-3934-4d081bf0acc7
# ╟─d031cb82-70d3-11ec-07cb-63017a5868d5
# ╟─d031cbaa-70d3-11ec-3633-53186d9d3707
# ╟─d031cbb4-70d3-11ec-38ff-517af7f603e7
# ╟─d031cbbe-70d3-11ec-3ac9-4f1617d99c53
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
