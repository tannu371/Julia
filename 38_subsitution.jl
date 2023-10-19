### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 4f0a8e4a-70e2-11ec-3ba2-0bd8437df7e0
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 4f0a91ec-70e2-11ec-0da8-17474930b858
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 4f1c556c-70e2-11ec-1ed6-1b45f0c6192c
using PlutoUI

# ╔═╡ 4f1c5558-70e2-11ec-0e55-d32c0436409c
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 4f0a8634-70e2-11ec-3aae-c795207f12e3
md"""# Substitution
"""

# ╔═╡ 4f0a8666-70e2-11ec-16a2-25d5c6eb86c8
md"""This section uses these add-on packages:
"""

# ╔═╡ 4f0a921e-70e2-11ec-09c6-fdf559231ee9
md"""---
"""

# ╔═╡ 4f0a92aa-70e2-11ec-1c53-1fb1815b8b44
md"""The technique of $u$-[substitution](https://en.wikipedia.org/wiki/Integration_by_substitution) is derived from reversing the chain rule: $[f(g(x))]' = f'(g(x)) g'(x)$.
"""

# ╔═╡ 4f0a92c8-70e2-11ec-2060-4540756d9bad
md"""Suppose that $g$ is continuous and $u(x)$ is differentiable with $u'(x)$ being Riemann integrable. Then both these integrals are defined:
"""

# ╔═╡ 4f0a92f0-70e2-11ec-1b14-2b463772a94e
md"""```math
\int_a^b g(u(t)) \cdot u'(t) dt, \quad \text{and}\quad \int_{u(a)}^{u(b)} g(x) dx.
```
"""

# ╔═╡ 4f0a930e-70e2-11ec-3d2f-67aedd7d4eb2
md"""We wish to show they are equal.
"""

# ╔═╡ 4f0a9322-70e2-11ec-06c2-434992a1a312
md"""Let $G$ be an antiderivative of $g$, which exists as $g$ is assumed to be continuous. (By the Fundamental Theorem part I.) Consider the composition $G \circ u$. The chain rule gives:
"""

# ╔═╡ 4f0a9336-70e2-11ec-2718-69c449a565f2
md"""```math
[G \circ u]'(t) = G'(u(t)) \cdot u'(t) = g(u(t)) \cdot u'(t).
```
"""

# ╔═╡ 4f0a9340-70e2-11ec-2f0d-d560c386b4db
md"""So,
"""

# ╔═╡ 4f0a9354-70e2-11ec-29b6-8d5956923aac
md"""```math
\begin{align*}
\int_a^b g(u(t)) \cdot u'(t) dt &= \int_a^b (G \circ u)'(t) dt\\
&= (G\circ u)(b) - (G\circ u)(a) \quad\text{(the FTC, part II)}\\
&= G(u(b)) - G(u(a)) \\
&= \int_{u(a)}^{u(b)} g(x) dx. \quad\text{(the FTC part II)}
\end{align*}
```
"""

# ╔═╡ 4f0a9360-70e2-11ec-0ef0-4b16e3f55804
md"""That is, this substitution formula applies:
"""

# ╔═╡ 4f0a943a-70e2-11ec-14d3-7d8e6f79b21a
md"""> $\int_a^b g(u(x)) u'(x) dx = \int_{u(a)}^{u(b)} g(x) dx.$

"""

# ╔═╡ 4f0a944e-70e2-11ec-1109-656c81ca54e5
md"""Further, for indefinite integrals,
"""

# ╔═╡ 4f0a9480-70e2-11ec-249f-618d1d51b2ce
md"""> $\int f(g(x)) g'(x) dx = \int f(u) du.$

"""

# ╔═╡ 4f0a949e-70e2-11ec-13c8-ddb769076cb4
md"""We have seen a special case of substitution where $u(x) = x-c$ in the formula $\int_{a-c}^{b-c} g(x) dx= \int_a^b g(x-c)dx$.
"""

# ╔═╡ 4f0a94b2-70e2-11ec-1203-192169a0a682
md"""The main use of this is to take complicated things inside of the function $g$ out of the function (the $u(x)$) by renaming them, then accounting for the change of name.
"""

# ╔═╡ 4f0a94bc-70e2-11ec-1954-9b868ca0219d
md"""Some examples are in order.
"""

# ╔═╡ 4f0a94c8-70e2-11ec-1d4e-0df9ee33850c
md"""Consider:
"""

# ╔═╡ 4f0a94d0-70e2-11ec-2fbe-7d5873f39bee
md"""```math
\int_0^{\pi/2} \cos(x) e^{\sin(x)} dx.
```
"""

# ╔═╡ 4f0a94ee-70e2-11ec-1466-2f96234f5e9a
md"""Clearly the $\sin(x)$ inside the exponential is an issue. If we let $u(x) = \sin(x)$, then $u'(x) = \cos(x)$, and this becomes
"""

# ╔═╡ 4f0a94f6-70e2-11ec-2420-539ed9954ff8
md"""```math
\int_0^2 u\prime(x) e^{u(x)} dx =
\int_{u(0)}^{u(\pi/2)} e^x dx = e^x \big|_{\sin(0)}^{\sin(\pi/2)} = e^1 - e^0.
```
"""

# ╔═╡ 4f0a950c-70e2-11ec-314d-71d72a495349
md"""This all worked, as the problem was such that it was more or less obvious what to choose for $u$ and $G$.
"""

# ╔═╡ 4f0d4f5c-70e2-11ec-1f45-47d9de26260e
md"""### Integration by substitution
"""

# ╔═╡ 4f0d4fe0-70e2-11ec-1bc3-15cee470d829
md"""The process of identifying the result of the chain rule in the function to integrate is not automatic, but rather a bit of an art. The basic step is to try some values and hope one works. Typically, this is taught by "substituting" in some value for part of the expression (basically the $u(x)$) and seeing what happens.
"""

# ╔═╡ 4f0d501c-70e2-11ec-0131-c9f08f6df8ae
md"""In the above problem, $\int_0^{\pi/2} \cos(x) e^{\sin(x)} dx$, we might just rename $\sin(x)$ to be $u$ (suppressing the "of $x$ part). Then we need to rewrite the "$dx$" part of the integral. We know in this case that $du/dx = \cos(x)$. In terms of differentials, this gives $du = \cos(x) dx$. But this allows us to substitute in with $u$ and $du$ as is possible:
"""

# ╔═╡ 4f0d503a-70e2-11ec-3fc2-95095b762519
md"""```math
\int_0^{\pi/2} \cos(x) e^{\sin(x)} dx = \int_0^{\pi/2}  e^{\sin(x)} \cdot \cos(x) dx = \int_{u(0)}^{u(\pi)} e^u du.
```
"""

# ╔═╡ 4f0d504e-70e2-11ec-127f-e389505cbe69
md"""---
"""

# ╔═╡ 4f0d506c-70e2-11ec-3bc5-ef6681493825
md"""Let's illustrate with a new problem: $\int_0^2 4x e^{x^2} dx$.
"""

# ╔═╡ 4f0d5092-70e2-11ec-2d83-fb933239f650
md"""Again, we see that the $x^2$ inside the exponential is a complication. Letting $u = x^2$ we have $du = 2x dx$. We  have $4xdx$ in the original problem, so we will end up with $2du$:
"""

# ╔═╡ 4f0d509e-70e2-11ec-1ba8-1f452dafbf24
md"""```math
\int_0^2 4x e^{x^2} dx = 2\int_0^2 e^{x^2} \cdot 2x dx = 2\int_{u(0)}^{u(2)} e^u du = 2 \int_0^4 e^u du =
2 e^u\big|_{u=0}^4 = 2(e^4 - 1).
```
"""

# ╔═╡ 4f0d50a8-70e2-11ec-012a-71081a9e0b11
md"""---
"""

# ╔═╡ 4f0d50d0-70e2-11ec-2795-751f864c83c1
md"""Consider now $\int_0^1 2x^2 \sqrt{1 + x^3} dx$. Here we see that the $1 + x^3$ makes the square root term complicated. If we call this $u$, then what is $du$? Clearly, $du = 3x^2 dx$, or $(1/3)du = x^2 dx$, so we can rewrite this as:
"""

# ╔═╡ 4f0d50e4-70e2-11ec-05d3-a15d89ba2e3c
md"""```math
\int_0^1 2x^2 \sqrt{1 + x^3} dx = \int_{u(0)}^{u(1)} 2 \sqrt{u} (1/3) du = 2/3 \cdot \frac{u^{3/2}}{3/2} \big|_1^2 =
\frac{4}{9} \cdot(2^{3/2} - 1).
```
"""

# ╔═╡ 4f0d50ee-70e2-11ec-1f54-ad2d802c8ed0
md"""---
"""

# ╔═╡ 4f0d510c-70e2-11ec-1282-6583fef43104
md"""Consider $\int_0^{\pi} \cos(x)^3 \sin(x) dx$. The $\cos(x)$ function inside the $x^3$ function is complicated. We let $u(x) = \cos(x)$ and see what that implies: $du = \sin(x) dx$, which we see is part of the question. So the above becomes:
"""

# ╔═╡ 4f0d5116-70e2-11ec-3131-cb565efe17b9
md"""```math
\int_0^{\pi} \cos(x)^3 \sin(x) dx = \int_{u(0)}^{u(\pi)} u^3 du= \frac{u^4}{4}\big|_0^0 = 0.
```
"""

# ╔═╡ 4f0d5136-70e2-11ec-387a-f7fc8ac6ba63
md"""Changing limits leaves the two endpoints the same, which means the total area after substitution is $0$. A graph of this function shows that about $\pi/2$ the function has odd-like symmetry, so the answer of $0$ is supported by the plot:
"""

# ╔═╡ 4f0d5954-70e2-11ec-30b4-b7f6b1595383
let
	f(x) = cos(x)^3 * sin(x)
	plot(f, 0, 1pi)
end

# ╔═╡ 4f0d5974-70e2-11ec-1629-af66c542577b
md"""---
"""

# ╔═╡ 4f0d599a-70e2-11ec-0e05-0d9632444d5b
md"""Consider $\int_1^e \log(x)/x dx$. There isn't really an "inside" function here, but instead just a tricky $\log(x)$. If we let $u=\log(x)$, what happens? We get $du = 1/x \cdot dx$, which we see present in the original. So with this, we have:
"""

# ╔═╡ 4f0d59b8-70e2-11ec-2dcd-3536f7dfc6e6
md"""```math
\int_1^e \frac{\log(x)}{x} dx = \int_{u(1)}^{u(e)} u du = \frac{u^2}{2}\big|_0^1 = \frac{1}{2}.
```
"""

# ╔═╡ 4f0d59ea-70e2-11ec-0bf0-fdd13da92cee
md"""##### Example: Transformations
"""

# ╔═╡ 4f0d5a12-70e2-11ec-3e21-adac9d5e096f
md"""We say that the area intrinsically discussed in the definite integral $A=\int_a^b f(x-c) dx$ is unaffected by shifts, in that $A = \int_{a-c}^{b-c} f(x) dx$. What about more general transformations? For example: if $g(x) = (1/h) \cdot f((x-c)/h)$ for values $c$ and $h$ what is the integral over $a$ to $b$ in terms of the function $f(x)$?
"""

# ╔═╡ 4f0d5a26-70e2-11ec-2b79-e369b0e89133
md"""If $A = \int_a^b (1/h) \cdot f((x-c)/h) dx$ then we let $u = (x-c)/h$. With this, $du = 1/h \cdot dx$. This allows a straight substitution:
"""

# ╔═╡ 4f0d5a38-70e2-11ec-1545-9f25fcef8ad2
md"""```math
A = \int_a^b \frac{1}{h} f(\frac{x-c}{h}) dx = \int_{(a-c)/h}^{(b-c)/h} f(u) du.
```
"""

# ╔═╡ 4f0d5a44-70e2-11ec-10dc-239dc2579717
md"""So the answer is: the area under the transformed function over $a$ to $b$ is the area of the function over the transformed region.
"""

# ╔═╡ 4f0d5a6a-70e2-11ec-3c9f-8dd32f399dd3
md"""For example, consider the "hat" function $f(x) = 1 - \lvert x \rvert $ when $-1 \leq x \leq 1$ and $0$ otherwise. The area under $f$ is just $1$ - the graph forms a triangle with base of length $2$ and height $1$. If we take any values of $c$ and $h$, what do we find for the area under the curve of the transformed function?
"""

# ╔═╡ 4f0d5a80-70e2-11ec-1fc3-45fa0fb7cb18
md"""Let $u(x) = (x-c)/h$ and $g(x) = h f(u(x))$. Then, as $du = 1/h dx$
"""

# ╔═╡ 4f0d5a8a-70e2-11ec-0bc3-e52efe49d546
md"""```math
\begin{align}
\int_{c-h}^{c+h} g(x) dx
&= \int_{c-h}^{c+h} h f(u(x)) dx\\
&= \int_{u(c-h)}^{u(c+h)} f(u) du\\
&= \int_{-1}^1 f(u) du\\
&= 1.
\end{align}
```
"""

# ╔═╡ 4f0d5aa8-70e2-11ec-0b5e-4712b3258700
md"""So the area of this transformed function is still $1$. The shifting by $c$ we know doesn't effect the area, the scaling by $h$ inside of $f$ does, but is balanced out by the multiplication by $h$ outside of $f$.
"""

# ╔═╡ 4f0d5abc-70e2-11ec-1c0f-3f41bd4a7afb
md"""##### Example: Speed versus velocity
"""

# ╔═╡ 4f0d5ad0-70e2-11ec-0946-3d9a5926087d
md"""The "velocity" of an object includes a sense of direction in addition to the sense of magnitude. The "speed" just includes the sense of magnitude. Speed is always non-negative, whereas velocity is a signed quantity.
"""

# ╔═╡ 4f0d5adc-70e2-11ec-39ce-ad83c4d16f02
md"""As mentioned previously, position is the integral of velocity, as expressed precisely through this equation:
"""

# ╔═╡ 4f0d5aee-70e2-11ec-3086-ebf30fece36d
md"""```math
x(t) = \int_0^t v(u) du - x(0).
```
"""

# ╔═╡ 4f0d5af8-70e2-11ec-36e4-ef1b32535e58
md"""What is the integral of speed?
"""

# ╔═╡ 4f0d5b20-70e2-11ec-2b9b-d5721507b92e
md"""If $v(t)$ is the velocity, the $s(t) = \lvert v(t) \rvert$ is the speed. If integrating either $s(t)$ or $v(t)$, the  integrals would agree when $v(t) \geq 0$. However,  when $v(t) \leq 0$, the position back tracks so $x(t)$ decreases, where the integral of $s(t)$ would only increase.
"""

# ╔═╡ 4f0d5b2a-70e2-11ec-0675-a5f03963f317
md"""This integral
"""

# ╔═╡ 4f0d5b34-70e2-11ec-2be6-71c594475257
md"""```math
td(t) = \int_0^t s(u) du = \int_0^t \lvert v(u) \rvert du,
```
"""

# ╔═╡ 4f0d5b66-70e2-11ec-0688-7b1c57b5cb0d
md"""Gives the *total distance* traveled.
"""

# ╔═╡ 4f0d5b8e-70e2-11ec-1a47-6381b059729e
md"""To illustrate with a simple example, if a car drives East for one hour at 60 miles per hour, then heads back West for an hour at 60 miles per hour, the car's position after one hour is $x(2) = x(0)$, with a change in position $x(2) - x(0) = 0$. Whereas, the total distance traveled is $120$ miles. (Gas is paid on total distance, not change in position!). What are the formulas for speed and velocity? Clearly $s(t) = 60$, a constant, whereas here $v(t) = 60$ for $0 \leq t \leq 1$ and $-60$ for $1 < t \leq 2$.
"""

# ╔═╡ 4f0d5ba0-70e2-11ec-01b1-f3e377586f2b
md"""Suppose $v(t)$ is given by $v(t) = (t-2)^3/3 - 4(t-2)/3$. If $x(0)=0$ Find the position after 3 time units and the total distance traveled.
"""

# ╔═╡ 4f0d5bc0-70e2-11ec-1f47-111bd8685437
md"""We let $u(t) = t - 2$ so $du=dt$. The position is given by
"""

# ╔═╡ 4f0d5bca-70e2-11ec-04c2-01792c9f3c4f
md"""```math
\int_0^3  ((t-2)^3/3 - 4(t-2)/3) dt = \int_{u(0)}^{u(3)} (u^3/3 - 4/3 u) du =
(\frac{u^4}{12} - \frac{4}{3}\frac{u^2}{2}) \big|_{-2}^1 = \frac{3}{4}.
```
"""

# ╔═╡ 4f0d5bde-70e2-11ec-2412-0b9d1e2714e7
md"""The speed is similar, but we have to work harder:
"""

# ╔═╡ 4f0d5bf2-70e2-11ec-2166-ebb07889cd65
md"""```math
\int_0^3 \lvert v(t) \rvert dt = \int_0^3  \lvert ((t-2)^3/3 - 4(t-2)/3) \rvert dt  =
\int_{-2}^1 \lvert u^3/3 - 4u/3 \rvert du.
```
"""

# ╔═╡ 4f0d5c06-70e2-11ec-1f38-d5457f06f7db
md"""But $u^3/3 - 4u/3 = (1/3) \cdot u(u-1)(u+2)$, so between $-2$ and $0$ it is positive and between $0$ and $1$ negative, so this integral is:
"""

# ╔═╡ 4f0d5c1a-70e2-11ec-2d72-c75e17f71c52
md"""```math
\int_{-2}^0 (u^3/3 - 4u/3 ) du + \int_{0}^1 -(u^3/3 - 4u/3) du =
(\frac{u^4}{12} - \frac{4}{3}\frac{u^2}{2}) \big|_{-2}^0 - (\frac{u^4}{12} - \frac{4}{3}\frac{u^2}{2}) \big|_{0}^1 = \frac{4}{3} - -\frac{7}{12} = \frac{23}{12}.
```
"""

# ╔═╡ 4f0d5c2e-70e2-11ec-2db3-7bbe07a31f0c
md"""##### Example
"""

# ╔═╡ 4f0d5c44-70e2-11ec-0699-4b9dd3d3c076
md"""In probability, the normal distribution plays an outsized role. This distribution is characterized by a family of *density* functions:
"""

# ╔═╡ 4f0d5c4c-70e2-11ec-0525-b92b57554b4a
md"""```math
f(x; \mu, \sigma) = \frac{1}{\sqrt{2\pi}}\frac{1}{\sigma} \exp(-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2).
```
"""

# ╔═╡ 4f0d5c56-70e2-11ec-1c47-f31bbcbc3540
md"""Integrals involving this function are typically transformed by substitution. For example:
"""

# ╔═╡ 4f0d5c6a-70e2-11ec-3e6e-85910bdf1cfb
md"""```math
\begin{align*}
\int_a^b f(x; \mu, \sigma) dx
&= \int_a^b  \frac{1}{\sqrt{2\pi}}\frac{1}{\sigma} \exp(-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2) dx \\
&= \int_{u(a)}^{u(b)} \frac{1}{\sqrt{2\pi}} \exp(-\frac{1}{2}u^2) du \\
&= \int_{u(a)}^{u(b)} f(u; 0, 1) du,
\end{align*}
```
"""

# ╔═╡ 4f0d5c7e-70e2-11ec-0380-b54a9c04c2a0
md"""where $u = (x-\mu)/\sigma$, so $du = (1/\sigma) dx$.
"""

# ╔═╡ 4f0d5c9c-70e2-11ec-3098-27fbe35d1ecb
md"""This shows that integrals involving a normal density with parameters $\mu$ and $\sigma$ can be computed using the *standard* normal density with $\mu=0$ and $\sigma=1$. Unfortunately, there is no elementary antiderivative for $\exp(-u^2/2)$, so integrals for the standard normal must be numerically approximated.
"""

# ╔═╡ 4f148706-70e2-11ec-1a64-a9150bde2c36
md"""There is a function `erf` in the `SpecialFunctions` package (which is loaded by `CalculusWithJulia`) that computes:
"""

# ╔═╡ 4f148760-70e2-11ec-3a1d-c5ff738ff747
md"""```math
\int_0^x \frac{2}{\sqrt{\pi}} \exp(-t^2) dt
```
"""

# ╔═╡ 4f1487b0-70e2-11ec-156d-a1386a6578d9
md"""A further change of variables by $t = u/\sqrt{2}$ (with $\sqrt{2}dt = du$) gives:
"""

# ╔═╡ 4f1487c4-70e2-11ec-017a-1d3fded10569
md"""```math
\begin{align*}
\int_a^b f(x; \mu, \sigma) dx &=
\int_{t(u(a))}^{t(u(b))} \frac{\sqrt{2}}{\sqrt{2\pi}} \exp(-t^2) dt\\
&= \frac{1}{2} \int_{t(u(a))}^{t(u(b))} \frac{2}{\sqrt{\pi}} \exp(-t^2) dt
\end{align*}
```
"""

# ╔═╡ 4f1487e2-70e2-11ec-3fc6-33bca67ced31
md"""Up to a factor of $1/2$ this is `erf`.
"""

# ╔═╡ 4f148800-70e2-11ec-0c0a-23454bd75211
md"""So we would have, for example, with $\mu=1$,$\sigma=2$ and $a=1$ and $b=3$ that:
"""

# ╔═╡ 4f14881c-70e2-11ec-0ade-c1531116c7ff
md"""```math
\begin{align*}
t(u(a)) &= (1 - 1)/2/\sqrt{2} = 0\\
t(u(b)) &= (3 - 1)/2/\sqrt{2} = \frac{1}{\sqrt{2}}\\
\int_1^3 f(x; 1, 2)
&= \frac{1}{2} \int_0^{1/\sqrt{2}} \frac{2}{\sqrt{\pi}} \exp(-t^2) dt.
\end{align*}
```
"""

# ╔═╡ 4f148828-70e2-11ec-0a30-292b2a260882
md"""Or
"""

# ╔═╡ 4f148e4a-70e2-11ec-2fa4-4d4b4d3e954e
1/2 * erf(1/sqrt(2))

# ╔═╡ 4f1bab62-70e2-11ec-1e70-558e160e5388
md"""!!! note "The `Distributions` package"
    The above calculation is for illustration purposes. The add-on package `Distributions` makes much quicker work of such a task for the normal distribution and many other distributions from probability and statistics.

"""

# ╔═╡ 4f1babd0-70e2-11ec-14c0-e989d2697208
md"""## SymPy and substitution
"""

# ╔═╡ 4f1babfa-70e2-11ec-056b-578d511a3973
md"""The `integrate` function in `SymPy` can handle most problems which involve substitution. Here are a few examples:
"""

# ╔═╡ 4f1bac8c-70e2-11ec-0013-ef31f9c2c7d5
md"""  * This integral, $\int_0^2 4x/\sqrt{x^2 +1}dx$, involves a substitution for $x^2 + 1$:
"""

# ╔═╡ 4f1bb3aa-70e2-11ec-2087-0dc029b0d4a5
begin
	@syms x::real t::real
	integrate(4x / sqrt(x^2 + 1), (x, 0, 2))
end

# ╔═╡ 4f1bb418-70e2-11ec-3bbe-d99934a31a2d
md"""  * This integral, $\int_e^{e^2} 1/(x\log(x)) dx$ involves a substitution of $u=\log(x)$. Here we see the answer:
"""

# ╔═╡ 4f1bba12-70e2-11ec-372e-f982ad593f54
let
	f(x) = 1/(x*log(x))
	integrate(f(x), (x, sympy.E, sympy.E^2))
end

# ╔═╡ 4f1bba44-70e2-11ec-1af7-7596ebc0baac
md"""(We used `sympy.E)` - and not `e` - to avoid any conversion to floating point, which could yield an inexact answer.)
"""

# ╔═╡ 4f1bba6c-70e2-11ec-32b1-a3fac1cbcb2f
md"""The antiderivative is interesting here; it being an *iterated* logarithm.
"""

# ╔═╡ 4f1bbe04-70e2-11ec-0260-cde305c34cf0
integrate(1/(x*log(x)), x)

# ╔═╡ 4f1bbe4a-70e2-11ec-0cbe-a1f824b701b5
md"""### Failures...
"""

# ╔═╡ 4f1bbe7c-70e2-11ec-0598-ef5bcc8f374b
md"""Not every integral problem lends itself to solution by substitution. For example, we can use substitution to evaluate the integral of $xe^{-x^2}$, but for $e^{-x^2}$ or $x^2e^{-x^2}$. The first has no familiar antiderivative, the second is done by a different technique.
"""

# ╔═╡ 4f1bbe9a-70e2-11ec-3dd8-d30d096f953f
md"""Even when substitution can be used, `SymPy` may not be able to algorithmically identify it. The main algorithm used can determine if expressions involving rational functions, radicals, logarithms, and exponential functions is integrable. Missing from this list are absolute values.
"""

# ╔═╡ 4f1bbea4-70e2-11ec-20b2-1912bdd10fc1
md"""For some such problems, we can help `SymPy` out - by breaking the integral into pieces where we know the sign of the expression.
"""

# ╔═╡ 4f1bbeae-70e2-11ec-3e40-ed992db26483
md"""For substitution problems, we can also help out. For example, to find an antiderivative for
"""

# ╔═╡ 4f1bbecc-70e2-11ec-301c-ad238b59b6a1
md"""```math
\int(1 + \log(x)) \sqrt{1 + (x\log(x))^2} dx
```
"""

# ╔═╡ 4f1bbed6-70e2-11ec-3860-f33d31f368e2
md"""A quick attempt with `SymPy` turns up nothing:
"""

# ╔═╡ 4f1bc6c4-70e2-11ec-0383-a9d6f7a4782d
begin
	𝒇(x) = (1 + log(x)) * sqrt(1 + (x*log(x))^2 )
	integrate(𝒇(x), x)
end

# ╔═╡ 4f1bc6ec-70e2-11ec-0901-930a1908c6b9
md"""But were we to try $u=x\log(x)$, we'd see that this simplifies to $\int \sqrt{1 + u^2} du$, which has some hope of having an antiderivative.
"""

# ╔═╡ 4f1bc700-70e2-11ec-3e62-094ce4c0e26c
md"""We can help `SymPy` out by substitution:
"""

# ╔═╡ 4f1bcae8-70e2-11ec-19df-bf9c7fab4d59
begin
	u(x) = x * log(x)
	@syms w dw
	ex = 𝒇(x)
	ex₁ = ex(u(x) => w, diff(u(x),x) => dw)
end

# ╔═╡ 4f1bcb10-70e2-11ec-0903-e3a309105e91
md"""This verifies the above. Can it be integrated in `w`? The "`dw`" is only for familiarity, `SymPy` doesn't use this, so we set it to 1 then integrate:
"""

# ╔═╡ 4f1bcfac-70e2-11ec-0e68-f9234aa1e297
begin
	ex₂ = ex₁(dw => 1)
	ex₃ = integrate(ex₂, w)
end

# ╔═╡ 4f1bcfca-70e2-11ec-3221-a5a5778d759e
md"""Finally, we put back in the `u(x)` to get an antiderivative.
"""

# ╔═╡ 4f1bd24a-70e2-11ec-1882-dbed2baa7e7f
ex₃(w => u(x))

# ╔═╡ 4f1bdb96-70e2-11ec-031e-4b56b10a47c7
note("""
Lest it be thought this is an issue with `SymPy`, but not other
systems, this example was [borrowed](http://faculty.uml.edu/jpropp/142/Integration.pdf) from an
illustration for helping Mathematica.
""")

# ╔═╡ 4f1bdbbe-70e2-11ec-39c9-9bad18aa1edf
md"""## Trigonometric substitution
"""

# ╔═╡ 4f1bdbdc-70e2-11ec-2a92-8919caec322d
md"""Wait, in the last example an antiderivative for $\sqrt{1 + u^2}$ was found. But how? We haven't discussed this yet.
"""

# ╔═╡ 4f1bdc22-70e2-11ec-3833-8bde05393297
md"""This can be found using *trigonometric* substitution. In this example, we know that $1 + \tan(\theta)^2$ simplifies to $\sec(\theta)^2$, so we might *try* a substitution of $\tan(u)=x$. This would simplify $\sqrt{1 + x^2}$ to $\sqrt{1 + \tan(u)^2} = \sqrt{\sec(u)^2}$ which is $\lvert \sec(u) \rvert$. What of $du$? The chain rule gives $\sec(u)^2du = dx$. In short we get:
"""

# ╔═╡ 4f1bdc34-70e2-11ec-03f7-17d5cdb79393
md"""```math
\int \sqrt{1 + x^2} dx = \int \sec(u)^2 \lvert \sec(u) \rvert du = \int \sec(u)^3 du,
```
"""

# ╔═╡ 4f1bdc4a-70e2-11ec-3083-9f71b2c6198a
md"""if we know $\sec(u) \geq 0$.
"""

# ╔═╡ 4f1bdc54-70e2-11ec-1f33-4986f9e7de8e
md"""This leaves still the question of integrating $\sec(u)^3$, which we aren't (yet) prepared to discuss, but we see that this type of substitution can re-express an integral in a new way that may pay off.
"""

# ╔═╡ 4f1bdc7c-70e2-11ec-11fe-c51f9e22cbcf
md"""#### Examples
"""

# ╔═╡ 4f1bdc90-70e2-11ec-1a49-fd6da0a95fbb
md"""Let's see some examples where a trigonometric substitution is all that is needed.
"""

# ╔═╡ 4f1bdcae-70e2-11ec-309b-6118dbe158e2
md"""##### Example
"""

# ╔═╡ 4f1bdccc-70e2-11ec-214e-ebda41ae22a7
md"""Consider $\int 1/(1+x^2) dx$. This is an antiderivative of some function, but if that isn't observed, we might notice the $1+x^2$ and try to simplify that. First, an attempt at a $u$-substitution:
"""

# ╔═╡ 4f1bdce0-70e2-11ec-2267-130d3bc16d8b
md"""Letting $u = 1+x^2$ we get $du = 2xdx$ which gives $\int (1/u) (2x) du$. We aren't able to address the "$2x$" part successfully, so this attempt is for naught.
"""

# ╔═╡ 4f1bdcfe-70e2-11ec-063f-a11d5d4385a4
md"""Now we try a trigonometric substitution, taking advantage of the identity $1+\tan(x)^2 = \sec(x)^2$. Letting $\tan(u) = x$ yields $\sec(u)^2 du = dx$ and we get:
"""

# ╔═╡ 4f1bdd0a-70e2-11ec-162f-e9f75cc325aa
md"""```math
\int \frac{1}{1+x^2} dx = \int \frac{1}{1 + \tan(u)^2} \sec(u)^2 du = \int 1 du = u.
```
"""

# ╔═╡ 4f1bdd30-70e2-11ec-38f8-ff6cfd4a9fd8
md"""But $\tan(u) = x$, so in terms of $x$, an antiderivative is just $\tan^{-1}(x)$, or the arctangent. Here we verify with `SymPy`:
"""

# ╔═╡ 4f1be0f0-70e2-11ec-3f05-b5d3b8d571f6
integrate(1/(1+x^2), x)

# ╔═╡ 4f1be10e-70e2-11ec-2b7c-fb2b7a7c5f5b
md"""The general form allows $a^2 + (bx)^2$ in the denominator (squared so both are positive and the answer is nicer):
"""

# ╔═╡ 4f1be5ac-70e2-11ec-23fa-d94b2fb31ea1
let
	@syms a::real, b::real, x::real
	integrate(1 / (a^2  + (b*x)^2), x)
end

# ╔═╡ 4f1be5c8-70e2-11ec-0f1b-61a33c74f50c
md"""##### Example
"""

# ╔═╡ 4f1be5e6-70e2-11ec-28e4-c358fd8bb61d
md"""The expression $1-x^2$ can be attacked by the substitution $\sin(u) =x$ as then $1-x^2 = 1-\cos(u)^2 = \sin(u)^2$. Here we see this substitution being used successfully:
"""

# ╔═╡ 4f1be5fa-70e2-11ec-22f7-e948f2304fff
md"""```math
\begin{align*}
\int \frac{1}{\sqrt{9 - x^2}} dx &= \int \frac{1}{\sqrt{9 - (3\sin(u))^2}} \cdot 3\cos(u) du\\
&=\int \frac{1}{3\sqrt{1 - \sin(u)^2}}\cdot3\cos(u) du \\
&= \int du \\
&= u \\
&= \sin^{-1}(x/3).
\end{align*}
```
"""

# ╔═╡ 4f1be60c-70e2-11ec-18f1-2bc595c4597e
md"""Further substitution allows the following integral to be solved for an antiderivative:
"""

# ╔═╡ 4f1be9ec-70e2-11ec-10c1-d3387ba3e187
let
	@syms a::real, b::real
	integrate(1 / sqrt(a^2 - b^2*x^2), x)
end

# ╔═╡ 4f1beac8-70e2-11ec-0c64-432929fe8494
md"""##### Example
"""

# ╔═╡ 4f1beae8-70e2-11ec-0fc7-936f5816d128
md"""The expression $x^2 - 1$ is a bit different, this lends itself to $\sec(u) = x$ for a substitution, for $\sec(u)^2 - 1 = \tan(u)^2$. For example, we try $\sec(u) = x$ to integrate:
"""

# ╔═╡ 4f1beafa-70e2-11ec-0d3d-59ae329c7d15
md"""```math
\begin{align*}
\int \frac{1}{\sqrt{x^2 - 1}} dx &= \int \frac{1}{\sqrt{\sec(u)^2 - 1}} \cdot \sec(u)\tan(u) du\\
&=\int \frac{1}{\tan(u)}\sec(u)\tan(u) du\\
&= \int \sec(u) du.
\end{align*}
```
"""

# ╔═╡ 4f1beb0e-70e2-11ec-2533-1febf1cb52b9
md"""This doesn't seem that helpful, but the antiderivative to $\sec(u)$ is $\log\lvert (\sec(u) + \tan(u))\rvert$, so we can proceed to get:
"""

# ╔═╡ 4f1beb22-70e2-11ec-2f7b-fb2b6793be14
md"""```math
\begin{align*}
\int \frac{1}{\sqrt{x^2 - 1}} dx &= \int \sec(u) du\\
&= \log\lvert (\sec(u) + \tan(u))\rvert\\
&= \log\lvert x + \sqrt{x^2-1} \rvert.
\end{align*}
```
"""

# ╔═╡ 4f1beb2c-70e2-11ec-21fe-37ca9378b631
md"""SymPy gives a different representation using the arccosine:
"""

# ╔═╡ 4f1bf068-70e2-11ec-0082-5313809b4e1d
let
	@syms a::positive, b::positive, x::real
	integrate(1 / sqrt(a^2*x^2 - b^2), x)
end

# ╔═╡ 4f1bf07c-70e2-11ec-38e5-63f414194fb7
md"""##### Example
"""

# ╔═╡ 4f1bf0a4-70e2-11ec-3d9a-73471930b94e
md"""The equation of an ellipse is $x^2/a^2 + y^2/b^2 = 1$. Suppose $a,b>0$. The area under the function $b \sqrt{1 - x^2/a^2}$ between $-a$ and $a$ will then be half the area of the ellipse. Find the area enclosed by the ellipse.
"""

# ╔═╡ 4f1bf0b6-70e2-11ec-2647-63a53c986e0c
md"""We need to compute:
"""

# ╔═╡ 4f1bf0c2-70e2-11ec-0431-2db51f7ec29c
md"""```math
2\int_{-a}^a b \sqrt{1 - x^2/a^2} dx =
4 b \int_0^a\sqrt{1 - x^2/a^2} dx.
```
"""

# ╔═╡ 4f1bf0d6-70e2-11ec-034d-590e7072c866
md"""Letting $\sin(u) = x/a$ gives $a\cos(u)du = dx$ and an antiderivative is found with:
"""

# ╔═╡ 4f1bf0e8-70e2-11ec-14e4-71f81ff3f7ca
md"""```math
4 b \int_0^a \sqrt{1 - x^2/a^2} dx = 4b \int_0^{\pi/2} \sqrt{1-u^2} a \cos(u) du
= 4ab \int_0^{\pi/2} \cos(u)^2 du
```
"""

# ╔═╡ 4f1bf0f4-70e2-11ec-0f0d-bbe047ee5922
md"""The identify $\cos(u)^2 = (1 +  \cos(2u))/2$ makes this tractable:
"""

# ╔═╡ 4f1bf108-70e2-11ec-0277-0d0d0e6db870
md"""```math
\begin{align*}
4ab \int \cos(u)^2 du
&= 4ab\int_0^{\pi/2}(\frac{1}{2} + \frac{\cos(2u)}{2}) du\\
&= 4ab(\frac{1}{2}u + \frac{\sin(2u)}{4})\big|_0^{\pi/2}\\
&= 4ab (\pi/4 + 0) = \pi ab.
\end{align*}
```
"""

# ╔═╡ 4f1bf11a-70e2-11ec-2ae2-d50192ca1642
md"""Keeping in mind that that a circle with radius $a$ is an ellipse with $b=a$, we see that this gives the correct answer for a circle.
"""

# ╔═╡ 4f1bf130-70e2-11ec-0e74-6dd60d53a5ed
md"""## Questions
"""

# ╔═╡ 4f1bf158-70e2-11ec-296a-0d267e67546d
md"""###### Question
"""

# ╔═╡ 4f1bf16c-70e2-11ec-3640-cf7eb58cb42c
md"""For $\int \sin(x) \cos(x) dx$, let $u=\sin(x)$. What is the resulting substitution?
"""

# ╔═╡ 4f1bf874-70e2-11ec-06f7-1be4306ab713
let
	choices = [
	"``\\int u du``",
	"``\\int u (1 - u^2) du``",
	"``\\int u \\cos(x) du``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1bf888-70e2-11ec-2c90-eb7bdcd370de
md"""###### Question
"""

# ╔═╡ 4f1bf8b0-70e2-11ec-29d9-9b2fa4bd905d
md"""For $\int \tan(x)^4 \sec(x)2 dx$ what $u$-substitution makes this easy?
"""

# ╔═╡ 4f1bfff4-70e2-11ec-3102-ef1e8dbe3b07
let
	choices = [
	"``u=\\tan(x)``",
	"``u=\\tan(x)^4``",
	"``u=\\sec(x)``",
	"``u=\\sec(x)^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c0008-70e2-11ec-18de-07382a8efe64
md"""###### Question
"""

# ╔═╡ 4f1c0026-70e2-11ec-1cba-83969572a58a
md"""For $\int x \sqrt{x^2 - 1} dx$ what $u$ substitution makes this easy?
"""

# ╔═╡ 4f1c0710-70e2-11ec-131b-692f33dbac8e
let
	choices = [
	"``u=x^2 - 1``",
	"``u=x^2``",
	"``u=\\sqrt{x^2 - 1}``",
	"``u=x``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c0724-70e2-11ec-114e-791f6c602da4
md"""###### Question
"""

# ╔═╡ 4f1c0742-70e2-11ec-11f1-d93702e152e4
md"""For $\int x^2(1-x)^2 dx$ will the substitution $u=1-x$ prove effective?
"""

# ╔═╡ 4f1c0942-70e2-11ec-3f9d-6983407396c9
let
	yesnoq("no")
end

# ╔═╡ 4f1c0954-70e2-11ec-318e-e7229f47820f
md"""What about expanding the factored polynomial to get a fourth degree polynomial, will this prove effective?
"""

# ╔═╡ 4f1c0b20-70e2-11ec-17d6-9f000a8c35f1
let
	yesnoq("yes")
end

# ╔═╡ 4f1c0b34-70e2-11ec-04bd-7518f96755dd
md"""###### Question
"""

# ╔═╡ 4f1c0b52-70e2-11ec-2aaf-c7ca98937cc2
md"""For  $\int (\log(x))^3/x dx$ the substitution $u=\log(x)$ reduces this to what?
"""

# ╔═╡ 4f1c11c4-70e2-11ec-0bbb-db56b7a748b5
let
	choices = [
	"``\\int u^3 du``",
	"``\\int u du``",
	"``\\int u^3/x du``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c11d8-70e2-11ec-374a-9370f9ea0820
md"""###### Question
"""

# ╔═╡ 4f1c11f6-70e2-11ec-3ca8-570e93b0eebe
md"""For $\int \tan(x) dx$ what substitution will prove effective?
"""

# ╔═╡ 4f1c1840-70e2-11ec-303b-5b732b79aa78
let
	choices = [
	"``u=\\cos(x)``",
	"``u=\\sin(x)``",
	"``u=\\tan(x)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c185e-70e2-11ec-11f5-81c36819b800
md"""###### Question
"""

# ╔═╡ 4f1c187c-70e2-11ec-3501-63aa2a8d8744
md"""Integrating $\int_0^1 x \sqrt{1 - x^2} dx$ can be done by using the $u$-substitution $u=1-x^2$. This yields an integral
"""

# ╔═╡ 4f1c1890-70e2-11ec-3c38-09780b0e1b4a
md"""```math
\int_a^b \frac{-\sqrt{u}}{2} du.
```
"""

# ╔═╡ 4f1c18a4-70e2-11ec-05c4-77bd3d7b6750
md"""What are $a$ and $b$?
"""

# ╔═╡ 4f1c1fac-70e2-11ec-0cdb-53e5cf926ea9
let
	choices = [
	"``a=0,~ b=1``",
	"``a=1,~ b=0``",
	"``a=0,~ b=0``",
	"``a=1,~ b=1``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c1fca-70e2-11ec-32fd-ffbefd25b2a0
md"""###### Question
"""

# ╔═╡ 4f1c1fde-70e2-11ec-0082-afcf2f60cd79
md"""The integral $\int \sqrt{1 - x^2} dx$ lends itself to what substitution?
"""

# ╔═╡ 4f1c2722-70e2-11ec-28d6-ed799b57662e
let
	choices = [
	"``\\sin(u) = x``",
	"``\\tan(u) = x``",
	"``\\sec(u) = x``",
	"``u = 1 - x^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c2738-70e2-11ec-2cef-19d5c59f730b
md"""###### Question
"""

# ╔═╡ 4f1c2754-70e2-11ec-1eea-21dd845ce7ed
md"""The integral $\int x/(1+x^2) dx$ lends itself to what substitution?
"""

# ╔═╡ 4f1c2ee8-70e2-11ec-24e4-2bf21f867b05
let
	choices = [
	"``u = 1 + x^2``",
	"``\\sin(u) = x``",
	"``\\tan(u) = x``",
	"``\\sec(u) = x``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c2efc-70e2-11ec-2a9a-351bcd125da8
md"""###### Question
"""

# ╔═╡ 4f1c2f10-70e2-11ec-20b2-170b9fc90759
md"""The integral $\int dx / \sqrt{1 - x^2}$ lends itself to what substitution?
"""

# ╔═╡ 4f1c364c-70e2-11ec-2475-071f53e51055
let
	choices = [
	"``\\sin(u) = x``",
	"``\\tan(u) = x``",
	"``\\sec(u) = x``",
	"``u = 1 - x^2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c3668-70e2-11ec-1c06-e73f41432376
md"""###### Question
"""

# ╔═╡ 4f1c367e-70e2-11ec-14fd-4fde6d416484
md"""The integral $\int dx / \sqrt{x^2 - 16}$ lends itself to what substitution?
"""

# ╔═╡ 4f1c3dde-70e2-11ec-1419-7543092bbffd
let
	choices = [
	"``4\\sec(u) = x``",
	"``\\sec(u) = x``",
	"``4\\sin(u) = x``",
	"``\\sin(u) = x``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c3dfc-70e2-11ec-187d-270e266a6343
md"""###### Question
"""

# ╔═╡ 4f1c3e10-70e2-11ec-01e1-dfb1557b11ca
md"""The integral $\int dx / (a^2 + x^2)$ lends itself to what substitution?
"""

# ╔═╡ 4f1c4568-70e2-11ec-2e97-8ddbe031cb51
let
	choices = [
	"``\\tan(u) = x``",
	"``\\tan(u) = x``",
	"``a\\sec(u) = x``",
	"``\\sec(u) = x``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4f1c4586-70e2-11ec-2a44-4775777b98f9
md"""###### Question
"""

# ╔═╡ 4f1c45a4-70e2-11ec-1e27-57d10f5919f9
md"""The integral $\int_{1/2}^1 \sqrt{1 - x^2}dx$ can be approached with the substitution $\sin(u) = x$ giving:
"""

# ╔═╡ 4f1c45b8-70e2-11ec-34a6-8d02e32e5cab
md"""```math
\int_a^b \cos(u)^2 du.
```
"""

# ╔═╡ 4f1c45cc-70e2-11ec-0ebe-df4424563fec
md"""What are $a$ and $b$?
"""

# ╔═╡ 4f1c4e0a-70e2-11ec-3ad4-5f0c2e0387d4
let
	choices =[
	"``a=\\pi/6,~ b=\\pi/2``",
	"``a=\\pi/4,~ b=\\pi/2``",
	"``a=\\pi/3,~ b=\\pi/2``",
	"``a=1/2,~ b= 1``"
	]
	ans =1
	radioq(choices, ans)
end

# ╔═╡ 4f1c4e28-70e2-11ec-23fc-1b21c5cc5dac
md"""###### Question
"""

# ╔═╡ 4f1c4e46-70e2-11ec-17cc-53b6f4566946
md"""How would we verify that $\log\lvert (\sec(u) + \tan(u))\rvert$ is an antiderivative for $\sec(u)$?
"""

# ╔═╡ 4f1c5544-70e2-11ec-0af6-17ccb5c1afa9
let
	choices = [
	L"We could differentiate $\sec(u)$.",
	L"We could differentiate $\log\lvert (\sec(u) + \tan(u))\rvert$ "]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 4f1c5562-70e2-11ec-3eed-a7c9be4a0928
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/ftc.html">◅ previous</a>  <a href="../integrals/integration_by_parts.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/substitution.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 4f1c5576-70e2-11ec-367a-2b9d91babb50
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
CalculusWithJulia = "~0.0.13"
Plots = "~1.25.4"
PlutoUI = "~0.7.29"
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
# ╟─4f1c5558-70e2-11ec-0e55-d32c0436409c
# ╟─4f0a8634-70e2-11ec-3aae-c795207f12e3
# ╟─4f0a8666-70e2-11ec-16a2-25d5c6eb86c8
# ╠═4f0a8e4a-70e2-11ec-3ba2-0bd8437df7e0
# ╟─4f0a91ec-70e2-11ec-0da8-17474930b858
# ╟─4f0a921e-70e2-11ec-09c6-fdf559231ee9
# ╟─4f0a92aa-70e2-11ec-1c53-1fb1815b8b44
# ╟─4f0a92c8-70e2-11ec-2060-4540756d9bad
# ╟─4f0a92f0-70e2-11ec-1b14-2b463772a94e
# ╟─4f0a930e-70e2-11ec-3d2f-67aedd7d4eb2
# ╟─4f0a9322-70e2-11ec-06c2-434992a1a312
# ╟─4f0a9336-70e2-11ec-2718-69c449a565f2
# ╟─4f0a9340-70e2-11ec-2f0d-d560c386b4db
# ╟─4f0a9354-70e2-11ec-29b6-8d5956923aac
# ╟─4f0a9360-70e2-11ec-0ef0-4b16e3f55804
# ╟─4f0a943a-70e2-11ec-14d3-7d8e6f79b21a
# ╟─4f0a944e-70e2-11ec-1109-656c81ca54e5
# ╟─4f0a9480-70e2-11ec-249f-618d1d51b2ce
# ╟─4f0a949e-70e2-11ec-13c8-ddb769076cb4
# ╟─4f0a94b2-70e2-11ec-1203-192169a0a682
# ╟─4f0a94bc-70e2-11ec-1954-9b868ca0219d
# ╟─4f0a94c8-70e2-11ec-1d4e-0df9ee33850c
# ╟─4f0a94d0-70e2-11ec-2fbe-7d5873f39bee
# ╟─4f0a94ee-70e2-11ec-1466-2f96234f5e9a
# ╟─4f0a94f6-70e2-11ec-2420-539ed9954ff8
# ╟─4f0a950c-70e2-11ec-314d-71d72a495349
# ╟─4f0d4f5c-70e2-11ec-1f45-47d9de26260e
# ╟─4f0d4fe0-70e2-11ec-1bc3-15cee470d829
# ╟─4f0d501c-70e2-11ec-0131-c9f08f6df8ae
# ╟─4f0d503a-70e2-11ec-3fc2-95095b762519
# ╟─4f0d504e-70e2-11ec-127f-e389505cbe69
# ╟─4f0d506c-70e2-11ec-3bc5-ef6681493825
# ╟─4f0d5092-70e2-11ec-2d83-fb933239f650
# ╟─4f0d509e-70e2-11ec-1ba8-1f452dafbf24
# ╟─4f0d50a8-70e2-11ec-012a-71081a9e0b11
# ╟─4f0d50d0-70e2-11ec-2795-751f864c83c1
# ╟─4f0d50e4-70e2-11ec-05d3-a15d89ba2e3c
# ╟─4f0d50ee-70e2-11ec-1f54-ad2d802c8ed0
# ╟─4f0d510c-70e2-11ec-1282-6583fef43104
# ╟─4f0d5116-70e2-11ec-3131-cb565efe17b9
# ╟─4f0d5136-70e2-11ec-387a-f7fc8ac6ba63
# ╠═4f0d5954-70e2-11ec-30b4-b7f6b1595383
# ╟─4f0d5974-70e2-11ec-1629-af66c542577b
# ╟─4f0d599a-70e2-11ec-0e05-0d9632444d5b
# ╟─4f0d59b8-70e2-11ec-2dcd-3536f7dfc6e6
# ╟─4f0d59ea-70e2-11ec-0bf0-fdd13da92cee
# ╟─4f0d5a12-70e2-11ec-3e21-adac9d5e096f
# ╟─4f0d5a26-70e2-11ec-2b79-e369b0e89133
# ╟─4f0d5a38-70e2-11ec-1545-9f25fcef8ad2
# ╟─4f0d5a44-70e2-11ec-10dc-239dc2579717
# ╟─4f0d5a6a-70e2-11ec-3c9f-8dd32f399dd3
# ╟─4f0d5a80-70e2-11ec-1fc3-45fa0fb7cb18
# ╟─4f0d5a8a-70e2-11ec-0bc3-e52efe49d546
# ╟─4f0d5aa8-70e2-11ec-0b5e-4712b3258700
# ╟─4f0d5abc-70e2-11ec-1c0f-3f41bd4a7afb
# ╟─4f0d5ad0-70e2-11ec-0946-3d9a5926087d
# ╟─4f0d5adc-70e2-11ec-39ce-ad83c4d16f02
# ╟─4f0d5aee-70e2-11ec-3086-ebf30fece36d
# ╟─4f0d5af8-70e2-11ec-36e4-ef1b32535e58
# ╟─4f0d5b20-70e2-11ec-2b9b-d5721507b92e
# ╟─4f0d5b2a-70e2-11ec-0675-a5f03963f317
# ╟─4f0d5b34-70e2-11ec-2be6-71c594475257
# ╟─4f0d5b66-70e2-11ec-0688-7b1c57b5cb0d
# ╟─4f0d5b8e-70e2-11ec-1a47-6381b059729e
# ╟─4f0d5ba0-70e2-11ec-01b1-f3e377586f2b
# ╟─4f0d5bc0-70e2-11ec-1f47-111bd8685437
# ╟─4f0d5bca-70e2-11ec-04c2-01792c9f3c4f
# ╟─4f0d5bde-70e2-11ec-2412-0b9d1e2714e7
# ╟─4f0d5bf2-70e2-11ec-2166-ebb07889cd65
# ╟─4f0d5c06-70e2-11ec-1f38-d5457f06f7db
# ╟─4f0d5c1a-70e2-11ec-2d72-c75e17f71c52
# ╟─4f0d5c2e-70e2-11ec-2db3-7bbe07a31f0c
# ╟─4f0d5c44-70e2-11ec-0699-4b9dd3d3c076
# ╟─4f0d5c4c-70e2-11ec-0525-b92b57554b4a
# ╟─4f0d5c56-70e2-11ec-1c47-f31bbcbc3540
# ╟─4f0d5c6a-70e2-11ec-3e6e-85910bdf1cfb
# ╟─4f0d5c7e-70e2-11ec-0380-b54a9c04c2a0
# ╟─4f0d5c9c-70e2-11ec-3098-27fbe35d1ecb
# ╟─4f148706-70e2-11ec-1a64-a9150bde2c36
# ╟─4f148760-70e2-11ec-3a1d-c5ff738ff747
# ╟─4f1487b0-70e2-11ec-156d-a1386a6578d9
# ╟─4f1487c4-70e2-11ec-017a-1d3fded10569
# ╟─4f1487e2-70e2-11ec-3fc6-33bca67ced31
# ╟─4f148800-70e2-11ec-0c0a-23454bd75211
# ╟─4f14881c-70e2-11ec-0ade-c1531116c7ff
# ╟─4f148828-70e2-11ec-0a30-292b2a260882
# ╠═4f148e4a-70e2-11ec-2fa4-4d4b4d3e954e
# ╟─4f1bab62-70e2-11ec-1e70-558e160e5388
# ╟─4f1babd0-70e2-11ec-14c0-e989d2697208
# ╟─4f1babfa-70e2-11ec-056b-578d511a3973
# ╟─4f1bac8c-70e2-11ec-0013-ef31f9c2c7d5
# ╠═4f1bb3aa-70e2-11ec-2087-0dc029b0d4a5
# ╟─4f1bb418-70e2-11ec-3bbe-d99934a31a2d
# ╠═4f1bba12-70e2-11ec-372e-f982ad593f54
# ╟─4f1bba44-70e2-11ec-1af7-7596ebc0baac
# ╟─4f1bba6c-70e2-11ec-32b1-a3fac1cbcb2f
# ╠═4f1bbe04-70e2-11ec-0260-cde305c34cf0
# ╟─4f1bbe4a-70e2-11ec-0cbe-a1f824b701b5
# ╟─4f1bbe7c-70e2-11ec-0598-ef5bcc8f374b
# ╟─4f1bbe9a-70e2-11ec-3dd8-d30d096f953f
# ╟─4f1bbea4-70e2-11ec-20b2-1912bdd10fc1
# ╟─4f1bbeae-70e2-11ec-3e40-ed992db26483
# ╟─4f1bbecc-70e2-11ec-301c-ad238b59b6a1
# ╟─4f1bbed6-70e2-11ec-3860-f33d31f368e2
# ╠═4f1bc6c4-70e2-11ec-0383-a9d6f7a4782d
# ╟─4f1bc6ec-70e2-11ec-0901-930a1908c6b9
# ╟─4f1bc700-70e2-11ec-3e62-094ce4c0e26c
# ╠═4f1bcae8-70e2-11ec-19df-bf9c7fab4d59
# ╟─4f1bcb10-70e2-11ec-0903-e3a309105e91
# ╠═4f1bcfac-70e2-11ec-0e68-f9234aa1e297
# ╟─4f1bcfca-70e2-11ec-3221-a5a5778d759e
# ╠═4f1bd24a-70e2-11ec-1882-dbed2baa7e7f
# ╟─4f1bdb96-70e2-11ec-031e-4b56b10a47c7
# ╟─4f1bdbbe-70e2-11ec-39c9-9bad18aa1edf
# ╟─4f1bdbdc-70e2-11ec-2a92-8919caec322d
# ╟─4f1bdc22-70e2-11ec-3833-8bde05393297
# ╟─4f1bdc34-70e2-11ec-03f7-17d5cdb79393
# ╟─4f1bdc4a-70e2-11ec-3083-9f71b2c6198a
# ╟─4f1bdc54-70e2-11ec-1f33-4986f9e7de8e
# ╟─4f1bdc7c-70e2-11ec-11fe-c51f9e22cbcf
# ╟─4f1bdc90-70e2-11ec-1a49-fd6da0a95fbb
# ╟─4f1bdcae-70e2-11ec-309b-6118dbe158e2
# ╟─4f1bdccc-70e2-11ec-214e-ebda41ae22a7
# ╟─4f1bdce0-70e2-11ec-2267-130d3bc16d8b
# ╟─4f1bdcfe-70e2-11ec-063f-a11d5d4385a4
# ╟─4f1bdd0a-70e2-11ec-162f-e9f75cc325aa
# ╟─4f1bdd30-70e2-11ec-38f8-ff6cfd4a9fd8
# ╠═4f1be0f0-70e2-11ec-3f05-b5d3b8d571f6
# ╟─4f1be10e-70e2-11ec-2b7c-fb2b7a7c5f5b
# ╠═4f1be5ac-70e2-11ec-23fa-d94b2fb31ea1
# ╟─4f1be5c8-70e2-11ec-0f1b-61a33c74f50c
# ╟─4f1be5e6-70e2-11ec-28e4-c358fd8bb61d
# ╟─4f1be5fa-70e2-11ec-22f7-e948f2304fff
# ╟─4f1be60c-70e2-11ec-18f1-2bc595c4597e
# ╠═4f1be9ec-70e2-11ec-10c1-d3387ba3e187
# ╟─4f1beac8-70e2-11ec-0c64-432929fe8494
# ╟─4f1beae8-70e2-11ec-0fc7-936f5816d128
# ╟─4f1beafa-70e2-11ec-0d3d-59ae329c7d15
# ╟─4f1beb0e-70e2-11ec-2533-1febf1cb52b9
# ╟─4f1beb22-70e2-11ec-2f7b-fb2b6793be14
# ╟─4f1beb2c-70e2-11ec-21fe-37ca9378b631
# ╠═4f1bf068-70e2-11ec-0082-5313809b4e1d
# ╟─4f1bf07c-70e2-11ec-38e5-63f414194fb7
# ╟─4f1bf0a4-70e2-11ec-3d9a-73471930b94e
# ╟─4f1bf0b6-70e2-11ec-2647-63a53c986e0c
# ╟─4f1bf0c2-70e2-11ec-0431-2db51f7ec29c
# ╟─4f1bf0d6-70e2-11ec-034d-590e7072c866
# ╟─4f1bf0e8-70e2-11ec-14e4-71f81ff3f7ca
# ╟─4f1bf0f4-70e2-11ec-0f0d-bbe047ee5922
# ╟─4f1bf108-70e2-11ec-0277-0d0d0e6db870
# ╟─4f1bf11a-70e2-11ec-2ae2-d50192ca1642
# ╟─4f1bf130-70e2-11ec-0e74-6dd60d53a5ed
# ╟─4f1bf158-70e2-11ec-296a-0d267e67546d
# ╟─4f1bf16c-70e2-11ec-3640-cf7eb58cb42c
# ╟─4f1bf874-70e2-11ec-06f7-1be4306ab713
# ╟─4f1bf888-70e2-11ec-2c90-eb7bdcd370de
# ╟─4f1bf8b0-70e2-11ec-29d9-9b2fa4bd905d
# ╟─4f1bfff4-70e2-11ec-3102-ef1e8dbe3b07
# ╟─4f1c0008-70e2-11ec-18de-07382a8efe64
# ╟─4f1c0026-70e2-11ec-1cba-83969572a58a
# ╟─4f1c0710-70e2-11ec-131b-692f33dbac8e
# ╟─4f1c0724-70e2-11ec-114e-791f6c602da4
# ╟─4f1c0742-70e2-11ec-11f1-d93702e152e4
# ╟─4f1c0942-70e2-11ec-3f9d-6983407396c9
# ╟─4f1c0954-70e2-11ec-318e-e7229f47820f
# ╟─4f1c0b20-70e2-11ec-17d6-9f000a8c35f1
# ╟─4f1c0b34-70e2-11ec-04bd-7518f96755dd
# ╟─4f1c0b52-70e2-11ec-2aaf-c7ca98937cc2
# ╟─4f1c11c4-70e2-11ec-0bbb-db56b7a748b5
# ╟─4f1c11d8-70e2-11ec-374a-9370f9ea0820
# ╟─4f1c11f6-70e2-11ec-3ca8-570e93b0eebe
# ╟─4f1c1840-70e2-11ec-303b-5b732b79aa78
# ╟─4f1c185e-70e2-11ec-11f5-81c36819b800
# ╟─4f1c187c-70e2-11ec-3501-63aa2a8d8744
# ╟─4f1c1890-70e2-11ec-3c38-09780b0e1b4a
# ╟─4f1c18a4-70e2-11ec-05c4-77bd3d7b6750
# ╟─4f1c1fac-70e2-11ec-0cdb-53e5cf926ea9
# ╟─4f1c1fca-70e2-11ec-32fd-ffbefd25b2a0
# ╟─4f1c1fde-70e2-11ec-0082-afcf2f60cd79
# ╟─4f1c2722-70e2-11ec-28d6-ed799b57662e
# ╟─4f1c2738-70e2-11ec-2cef-19d5c59f730b
# ╟─4f1c2754-70e2-11ec-1eea-21dd845ce7ed
# ╟─4f1c2ee8-70e2-11ec-24e4-2bf21f867b05
# ╟─4f1c2efc-70e2-11ec-2a9a-351bcd125da8
# ╟─4f1c2f10-70e2-11ec-20b2-170b9fc90759
# ╟─4f1c364c-70e2-11ec-2475-071f53e51055
# ╟─4f1c3668-70e2-11ec-1c06-e73f41432376
# ╟─4f1c367e-70e2-11ec-14fd-4fde6d416484
# ╟─4f1c3dde-70e2-11ec-1419-7543092bbffd
# ╟─4f1c3dfc-70e2-11ec-187d-270e266a6343
# ╟─4f1c3e10-70e2-11ec-01e1-dfb1557b11ca
# ╟─4f1c4568-70e2-11ec-2e97-8ddbe031cb51
# ╟─4f1c4586-70e2-11ec-2a44-4775777b98f9
# ╟─4f1c45a4-70e2-11ec-1e27-57d10f5919f9
# ╟─4f1c45b8-70e2-11ec-34a6-8d02e32e5cab
# ╟─4f1c45cc-70e2-11ec-0ebe-df4424563fec
# ╟─4f1c4e0a-70e2-11ec-3ad4-5f0c2e0387d4
# ╟─4f1c4e28-70e2-11ec-23fc-1b21c5cc5dac
# ╟─4f1c4e46-70e2-11ec-17cc-53b6f4566946
# ╟─4f1c5544-70e2-11ec-0af6-17ccb5c1afa9
# ╟─4f1c5562-70e2-11ec-3eed-a7c9be4a0928
# ╟─4f1c556c-70e2-11ec-1ed6-1b45f0c6192c
# ╟─4f1c5576-70e2-11ec-367a-2b9d91babb50
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
