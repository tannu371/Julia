### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ ddc711f4-5825-11ec-2f2f-774ff67af6a7
begin
	using CalculusWithJulia
	using Plots
	using QuadGK
	using Roots
end

# ╔═╡ ddc717be-5825-11ec-3ce7-23cc33910687
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size = (600, 400)
	using Markdown, Mustache
	function _ImageFile(f, caption, alt="A figure", width=nothing)
	    data = CalculusWithJulia.WeaveSupport.base64encode(read(f, String))
	    content = Mustache.render(CalculusWithJulia.WeaveSupport.gif_to_img_tpl, data=data, alt=alt)
	    caption = Markdown.parse(caption)
	    CalculusWithJulia.WeaveSupport.ImageFile(f, caption, alt, width, content)
	end
	
	nothing
end

# ╔═╡ de0056da-5825-11ec-3c88-91f4875407eb
using PlutoUI

# ╔═╡ de0056b4-5825-11ec-2b37-11a8d56a4596
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ ddae19d0-5825-11ec-3248-2773029664ff
md"""# Area under a curve
"""

# ╔═╡ ddb02266-5825-11ec-0748-a1d016024b26
md"""This section uses these add-on packages:
"""

# ╔═╡ ddc8ec36-5825-11ec-23d2-4f3d37f25f46
md"""---
"""

# ╔═╡ ddcda494-5825-11ec-1649-d368f03dab41
md"""The question of area has long fascinated human culture. As children, we learn early on the formulas for the areas of some geometric figures: a square is $b^2$, a rectangle $b\cdot h$ a triangle $1/2 \cdot b \cdot h$ and for a circle, $\pi r^2$. The area of a rectangle is often the intuitive basis for illustrating multiplication. The area of a triangle has been known for ages. Even complicated expressions, such as [Heron's](http://tinyurl.com/mqm9z) formula which relates the area of a triangle with measurements from its perimeter have been around for 2000 years. The formula for the area of a circle is also quite old. Wikipedia dates it as far back as the [Rhind](http://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus) papyrus for 1700 BC, with the approximation of $256/81$ for $\pi$.
"""

# ╔═╡ ddcda52a-5825-11ec-368b-fb9571ee6a75
md"""The modern approach to area begins with a non-negative function $f(x)$ over an interval $[a,b]$. The goal is to compute the area under the graph. That is, the area between $f(x)$ and the $x$-axis between $a \leq x \leq b$.
"""

# ╔═╡ ddcda53e-5825-11ec-2bae-673d5e8f2123
md"""For some functions, this area can be computed by geometry, for example, here we see the area under $f(x)$ is just $1$, as it is a triangle with base $2$ and height $1$:
"""

# ╔═╡ ddcdade0-5825-11ec-31d2-9b4b8f2b639c
let
	f(x) = 1 - abs(x)
	plot(f, -1, 1)
	plot!(zero)
end

# ╔═╡ ddcdae1a-5825-11ec-1c73-7dabd6a36067
md"""Similarly, we know this area is also $1$, it being a square:
"""

# ╔═╡ ddcdb4ca-5825-11ec-1bd2-ef6384da8865
let
	f(x) = 1
	plot(f, 0, 1)
	plot!(zero)
end

# ╔═╡ ddcdb51a-5825-11ec-079d-73d6d97a351d
md"""This one, is simply $\pi/2$, it being half a circle of radius $1$:
"""

# ╔═╡ ddcdc2a0-5825-11ec-28d5-d3e0d50729ce
let
	f(x) = sqrt(1 - x^2)
	plot(f, -1, 1)
	plot!(zero)
end

# ╔═╡ ddcdc2e4-5825-11ec-2316-f365e838a6f6
md"""And this area can be broken into a sum of the area of square and the area of a rectangle, or $1 + 1/2$:
"""

# ╔═╡ ddcdc8e8-5825-11ec-0b7e-39f37401a600
let
	f(x) = x > 1 ? 2 - x : 1.0
	plot(f, 0, 2)
	plot!(zero)
end

# ╔═╡ ddcdc8fc-5825-11ec-2fb8-5f41bebe4c25
md"""But what of more complicated areas? Can these have their area computed?
"""

# ╔═╡ ddd0635a-5825-11ec-2256-0d98baf0709a
md"""## Approximating areas
"""

# ╔═╡ ddd063d2-5825-11ec-3380-f5b3ae1a98de
md"""In a previous section, we saw this animation:
"""

# ╔═╡ ddd06c6a-5825-11ec-3e4d-3fc6ca25ec1b
let
	## {{{archimedes_parabola}}}
	
	
	f(x) = x^2
	colors = [:black, :blue, :orange, :red, :green, :orange, :purple]
	
	## Area of parabola
	
	## Area of parabola
	function make_triangle_graph(n)
	    title = "Area of parabolic cup ..."
	    n==1 && (title = "Area = 1/2")
	    n==2 && (title = "Area = previous + 1/8")
	    n==3 && (title = "Area = previous + 2*(1/8)^2")
	    n==4 && (title = "Area = previous + 4*(1/8)^3")
	    n==5 && (title = "Area = previous + 8*(1/8)^4")
	    n==6 && (title = "Area = previous + 16*(1/8)^5")
	    n==7 && (title = "Area = previous + 32*(1/8)^6")
	
	
	
	    plt = plot(f, 0, 1, legend=false, size = fig_size, linewidth=2)
	    annotate!(plt, [(0.05, 0.9, text(title,:left))])  # if in title, it grows funny with gr
	    n >= 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linetype=:polygon, fill=colors[1], alpha=.2)
	    n == 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linewidth=2)
	    for k in 2:n
	        xs = range(0, stop=1, length=1+2^(k-1))
	        ys = map(f, xs)
	        k < n && plot!(plt, xs, ys, linetype=:polygon, fill=:black, alpha=.2)
	        if k == n
	            plot!(plt, xs, ys, color=colors[k], linetype=:polygon, fill=:black, alpha=.2)
	            plot!(plt, xs, ys, color=:black, linewidth=2)
	        end
	    end
	    plt
	end
	
	
	
	n = 7
	anim = @animate for i=1:n
	    make_triangle_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	caption = L"""
	The first triangle has area $1/2$, the second has area $1/8$, then $2$ have area $(1/8)^2$, $4$ have area $(1/8)^3$, ...
	With some algebra, the total area then should be $1/2 \cdot (1 + (1/4) + (1/4)^2 + \cdots) = 2/3$.
	"""
	
	_ImageFile(imgfile, caption)
end

# ╔═╡ ddd1a6ca-5825-11ec-19ae-112b4d614486
md"""This illustrates a method of [Archimedes](http://en.wikipedia.org/wiki/The_Quadrature_of_the_Parabola) to compute the area contained in a parabola using the method of exhaustion. Archimedes leveraged a fact he discovered relating the areas of triangle inscribed with parabolic segments to create a sum that could be computed.
"""

# ╔═╡ ddd358ee-5825-11ec-2565-3f6b1949e2c6
md"""The pursuit of computing areas persisted. The method of computing area by finding a square with an equivalent area was known as *quadrature*. Over the years, many figures had their area computed, for example, the area under the graph of the [cycloid](http://en.wikipedia.org/wiki/Cycloid) (...Galileo tried empirically to find this using a tracing on sheet metal and a scale).
"""

# ╔═╡ ddd35952-5825-11ec-2b9e-d7ff60d5b451
md"""However, as areas of geometric objects were replaced by the more general question of area related to graphs of functions, a more general study was called for.
"""

# ╔═╡ ddd3597a-5825-11ec-0659-f9cc3aa102dd
md"""One such approach is illustrated in this figure due to Beeckman from 1618 (from [Bressoud](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits/bressoud/))
"""

# ╔═╡ ddd3617c-5825-11ec-32c3-d16e878c9689
begin
	imgfile = "figures/beeckman-1618.png"
	caption = L"""
	
	Figure of Beeckman (1618) showing a means to compute the area under a
	curve, in this example the line connecting points $A$ and $B$. Using
	approximations by geometric figures with known area is the basis of
	Riemann sums.
	
	"""
	#ImageFile(imgfile, caption)
	nothing
end

# ╔═╡ ddd458ca-5825-11ec-0596-3541cdf5e4c0
md"""![Figure of Beeckman (1618) showing a means to compute the area under a curve, in this example the line connecting points $A$ and $B$. Using approximations by geometric figures with known area is the basis of Riemann sums.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/integrals/figures/beeckman-1618.png)
"""

# ╔═╡ ddd459f6-5825-11ec-1f1e-970ec0e66462
md"""Beeckman actually did more than find the area. He generalized the relationship of rate $\times$ time $=$ distance. The line was interpreting a velocity, the "squares", then, provided an approximate distance traveled when the velocity is taken as a constant on the small time interval. Then the distance traveled can be approximated by a smaller quantity - just add the area of the rectangles squarely within the desired area ($6+16+6$) - and a larger quantity - by including all rectangles that have a portion of their area within the desired area ($10 + 16 + 10$). Beeckman argued that the error vanishes as the rectangles get smaller.
"""

# ╔═╡ ddd45a28-5825-11ec-3205-a9885af25f8f
md"""Adding up the smaller "squares" can be a bit more efficient if we were to add all those in a row, or column at once. We would then add the areas of a smaller number of rectangles. For this curve, the two approaches are basically identical. For other curves, identifying which squares in a row would be added is much more complicated (though useful), but for a curve generated by a function, identifying which "squares" go in a rectangle is quite easy, in fact we can see the rectangle's area will be a base given by that of the squares, and height depending on the function.
"""

# ╔═╡ ddd6ec34-5825-11ec-3abb-bbd1453a7ff8
md"""### Adding rectangles
"""

# ╔═╡ ddd6ecac-5825-11ec-066b-219c1ba48edf
md"""The idea of the Riemann sum then is to approximate the area under the curve by the area of well-chosen rectangles in such a way that as the bases of the rectangles get smaller (hence adding more rectangles) the error in approximation vanishes.
"""

# ╔═╡ ddd74cd8-5825-11ec-3ca2-3bc5d8b78b76
md"""Define a partition of $[a,b]$ to be a selection of points $a = x_0 < x_1 < \cdots < x_{n-1} < x_n = b$. The norm of the partition is the largest of all the differences $\lvert x_i - x_{i-1} \rvert$. For a partition, consider an arbitrary selection of points $c_i$ satisfying $x_{i-1} \leq c_i \leq x_{i}$, $1 \leq i \leq n$. Then the following is a **Riemann sum**:
"""

# ╔═╡ ddd95942-5825-11ec-0144-ff9cd6e98840
md"""```math
S_n  = f(c_1) \cdot (x_1 - x_0) + f(c_2) \cdot (x_2 - x_1) + \cdots + f(c_n) \cdot (x_n - x_{n-1}).
```
"""

# ╔═╡ ddd95a64-5825-11ec-084a-452d7f84c5cc
md"""Clearly for a given partition and choice of $c_i$, the above can be computed. Each term $f(c_i)\cdot(x_i-x_{i-1})$ can be visualized as the area of a rectangle with base spanning from $x_{i-1}$ to $x_i$ and height given by the function value at $c_i$. The following [image](http://en.wikipedia.org/wiki/Riemann_sum) from Wikipedia visualizes Riemann sums for different values of $n$ in a way that makes Beekman's intuition plausible – that as the number of rectangles gets larger, the approximate sum will get closer to the actual area.
"""

# ╔═╡ ddd95a8e-5825-11ec-2050-ad9b7c2e1c26
md"""![Illustration of Riemann sums](http://tinyurl.com/pztbwgb)
"""

# ╔═╡ ddd95aaa-5825-11ec-1ba2-b3c261116985
md"""To successfully compute a good approximation for the area, we would need to choose $c_i$ and the partition so that a formula can be found to express the dependence on the size of the partition.
"""

# ╔═╡ ddd95ac8-5825-11ec-13a8-c52eca5be4de
md"""For Archimedes' problem - finding the area under $f(x)=x^2$ between $0$ and $1$ -  if we take as a partition $x_i = i/n$ and $c_i = x_i$, then the above sum becomes:
"""

# ╔═╡ ddd95afa-5825-11ec-2b6b-072cce3226cb
md"""```math
\begin{align*}
S_n &= f(c_1) \cdot (x_1 - x_0) + f(c_2) \cdot (x_2 - x_1) + \cdots + f(c_n) \cdot (x_n - x_{n-1})\\
&= (x_1)^2 \cdot \frac{1}{n} + (x_2)^2 \cdot \frac{1}{n} + \cdot + (x_n)^2 \cdot \frac{1}{n}\\
&= 1^2 \cdot \frac{1}{n^3}  + 2^2 \cdot \frac{1}{n^3} + \cdots + n^2 \cdot \frac{1}{n^3}\\
&= \frac{1}{n^3} \cdot (1^2 + 2^2 + \cdots + n^2) \\
&= \frac{1}{n^3} \cdot \frac{n\cdot(n-1)\cdot(2n+1)}{6}.
\end{align*}
```
"""

# ╔═╡ ddd95b0e-5825-11ec-052b-e379ef92af38
md"""The latter uses a well-known formula for the sum of squares of the first $n$ natural numbers.
"""

# ╔═╡ ddd95b20-5825-11ec-1f6b-93c79a1d2a0b
md"""With this expression, it is readily seen that as $n$ gets large this value gets close to $2/6 = 1/3$.
"""

# ╔═╡ ddd96c8e-5825-11ec-0830-1d4161ac2f89
note("""

The above approach, like Archimedes', ends with a limit being
taken. The answer comes from using a limit to add a big number of
small values. As with all limit questions, worrying about whether a
limit exists is fundamental. For this problem, we will see that for
the general statement there is a stretching of the formal concept of a limit.

""")

# ╔═╡ ddd96cc0-5825-11ec-2b63-2367062f3ecd
md"""---
"""

# ╔═╡ ddd96d10-5825-11ec-1360-2dd2aa1b7057
md"""There is a more compact notation to $x_1 + x_2 + \cdots + x_n$, this using the *summation notation* or capital sigma. We have:
"""

# ╔═╡ ddd96d1a-5825-11ec-0a2a-35201361151e
md"""```math
\Sigma_{i = 1}^n x_i = x_1 + x_2 + \cdots + x_n
```
"""

# ╔═╡ ddd96d2e-5825-11ec-1d68-ed0db21e4c07
md"""The notation includes three pieces of information:
"""

# ╔═╡ dde2d1e8-5825-11ec-27d2-b5f4efb078bc
md"""  * The $\Sigma$ is an indication of a sum
  * The ${i=1}$ and $n$ sub- and superscripts indicate the range to sum over.
  * The term $x_i$ is a general term describing the $i$th entry, where it is understood that $i$ is just some arbitrary indexing value.
"""

# ╔═╡ dde2d244-5825-11ec-2a8b-21f8002da464
md"""With this notation, a Riemann sum can be written  as $\Sigma_{i=1}^n f(c_i)(x_i-x_{i-1})$.
"""

# ╔═╡ dde2d288-5825-11ec-0efb-635c3e0cd351
md"""### Other sums
"""

# ╔═╡ dde2d2a4-5825-11ec-3db0-5bb597e9e6fe
md"""The choice of the $c_i$ will give different answers for the approximation, though for an integrable function these differences will vanish in the limit. Some common choices are:
"""

# ╔═╡ dde2d37a-5825-11ec-12d5-dd977ab90bc8
md"""  * Using the right hand endpoint of the interval $[x_{i-1}, x_i]$ giving the right-Riemann sum.
  * The choice $c_i = x_{i-1}$ gives the left-Riemann sum.
  * The choice $c_i = (x_i + x_{i-1})/2$ is the midpoint rule.
  * If the function is continuous on the closed subinterval $[x_{i-1}, x_i]$, then it will take on its minimum and maximum values. By the extreme value theorem, we could take $c_i$ to correspond to either the maximum or the minimum. These choices give  the "upper Riemann-sums" and "lower Riemann-sums".
"""

# ╔═╡ ddeaba16-5825-11ec-131b-737301da0959
md"""The choice of partition can also give different answers. A common choice is to break the interval into $n+1$ equal-sized pieces. With $\Delta = (b-a)/n$, these pieces become the arithmetic sequence $a = a + 0 \cdot \Delta < a + 1 \cdot \Delta < a + 2 \cdot \Delta < \cdots a + n \cdots < \Delta = b$ with $x_i = a + i (b-a)/n$. (The `range(a, b, length=n+1)` command will compute these.) An alternate choice made below for one problem is to use a geometric progression $a = a(1+\alpha)^0 < a(1+\alpha)^1 < a (1+\alpha)^2 < \cdots < a (1+\alpha)^n = b$. The general statement allows for any partition such that the largest gap gets small.
"""

# ╔═╡ ddeaba7a-5825-11ec-3eb5-bd659a41d5be
md"""---
"""

# ╔═╡ ddeabaa2-5825-11ec-1de8-a760f7d2f695
md"""Riemann sums weren't named after Riemann because he was the first to approximate areas using rectangles. Indeed, others had been using even more efficient ways to compute areas for  centuries prior to Riemann's work. Rather, Riemann put the definition of the area under the curve on a firm theoretical footing with the following theorem which gives a concrete notion of what functions are integrable:
"""

# ╔═╡ ddefb322-5825-11ec-0171-4729cd0c405b
md"""> **Riemann Integral**: A function $f$ is Riemann integrable over the interval $[a,b]$ and its integral will have value $V$ provided for every $\epsilon > 0$ there exists a $\delta > 0$ such that for any partition $a =x_0 < x_1 < \cdots < x_n=b$ with $\lvert x_i - x_{i-1} \rvert < \delta$ and for any choice of points $x_{i-1} \leq c_i \leq x_{i}$ this is satisfied:
>
> ```math
> \lvert \sum_{i=1}^n f(c_i)(x_{i} - x_{i-1}) - V \rvert < \epsilon.
> ```
>
> When the integral exists, it is written $V = \int_a^b f(x) dx$.

"""

# ╔═╡ ddf6a92a-5825-11ec-23fa-cf34617dfaa3
md"""!!! info "History note"
    The expression $V = \int_a^b f(x) dx$ is known as the *definite integral* of $f$ over $[a,b]$. Much earlier than Riemann, Cauchy had defined the definite integral in terms of a sum of rectangular products beginning with $S=(x_1 - x_0) f(x_0) + (x_2 - x_1) f(x_1) + \cdots + (x_n - x_{n-1}) f(x_{n-1})$ (the left Riemann sum). He showed the limit was well defined for any continuous function. Riemann's formulation relaxes the choice of partition and the choice of the $c_i$ so that integrability can be better understood.

"""

# ╔═╡ ddf6a978-5825-11ec-391a-4ba721e6a672
md"""### Some immediate consequences
"""

# ╔═╡ ddf6a9b6-5825-11ec-311b-73c6148e8942
md"""The following formulas are consequences when $f(x)$ is integrable. These  mostly follow through a judicious rearranging of the approximating sums.
"""

# ╔═╡ ddf6a9ca-5825-11ec-0fc8-cfdd2aaed1f0
md"""The area is $0$ when there is no width to the interval to integrate over:
"""

# ╔═╡ ddf6aa4e-5825-11ec-3ccf-0bf0a4fde7c2
md"""> ```math
> \int_a^a f(x) dx = 0.
> ```

"""

# ╔═╡ ddf6aa6a-5825-11ec-375f-150fa662a219
md"""Even our definition of a partition doesn't really apply, as we assume $a < b$, but clearly if $a=x_0=x_n=b$ then our only"approximating" sum could be $f(a)(b-a) = 0$.
"""

# ╔═╡ ddf6aa88-5825-11ec-3a7f-9f5db84b7dab
md"""The area under a constant function is found from the area of rectangle, a special case being $c=0$ yielding $0$ area:
"""

# ╔═╡ ddf6aaae-5825-11ec-26d8-0df5d8527230
md"""> ```math
> \int_a^b c dx = c \cdot (b-a).
> ```

"""

# ╔═╡ ddf6aad8-5825-11ec-0ca4-1d6dc4bfd346
md"""For any partition of $a < b$, we have $S_n = c(x_1 - x_0) + c(x_2 -x_1) + \cdots + c(x_n - x_{n-1})$. By factoring out the $c$, we have a *telescoping sum* which means the sum simplifies to $S_n = c(x_n-x_0) = c(b-a)$. Hence any limit must be this constant value.
"""

# ╔═╡ ddf6aae0-5825-11ec-0bbb-5b3519721d0c
md"""Scaling the $y$ axis by a constant can be done before or after computing the area:
"""

# ╔═╡ ddf6ab12-5825-11ec-06f1-032b8313ef9e
md"""> ```math
> \int_a^b cf(x) dx = c \int_a^b f(x) dx.
> ```

"""

# ╔═╡ ddf6ab46-5825-11ec-3cea-854b9b0691aa
md"""Let $a=x_0 < x_1 < \cdots < x_n=b$ be any partition. Then we have $S_n= cf(c_1)(x_1-x_0) + \cdots + cf(c_n)(x_n-x_0)$ $=$ $c\cdot\left[ f(c_1)(x_1 - x_0) + \cdots + f(c_n)(x_n - x_0)\right]$. The "limit" of the left side is $\int_a^b c f(x) dx$. The "limit" of the right side is $c \cdot \int_a^b f(x)$. We call this a "sketch" as a formal proof would show that for any $\epsilon$ we could choose a $\delta$ so that any partition with norm $\delta$ will yield a sum less than $\epsilon$. Here, then our "any" partition would be one for which the $\delta$ on the left hand side applies. The computation shows that the same $\delta$ would apply for the right hand side when $\epsilon$ is the same.
"""

# ╔═╡ ddf6ab5a-5825-11ec-279b-4528d99c9487
md"""The area is invariant under shifts left or right.
"""

# ╔═╡ ddf6ab84-5825-11ec-2a2d-2b110aa674ac
md"""> ```math
> \int_a^b f(x - c) dx = \int_{a-c}^{b-c} f(x) dx.
> ```

"""

# ╔═╡ ddf6aba0-5825-11ec-0675-a598765b120a
md"""Any partition $a =x_0 < x_1 < \cdots < x_n=b$ is related to a partition of $[a-c, b-c]$ through $a-c < x_0-c < x_1-c < \cdots < x_n - c = b-c$. Let $d_i=c_i-c$ denote this partition, then we have:
"""

# ╔═╡ ddf6abc8-5825-11ec-3615-a5f19e27a2a1
md"""```math
f(c_1 -c) \cdot (x_1 - x_0) + f(c_2 -c) \cdot (x_2 - x_1)  + \cdots + f(c_n -c) \cdot (x_n - x_{n-1}) =
f(d_1) \cdot(x_1-c - (x_0-c)) + f(d_2) \cdot(x_2-c - (x_1-c)) + \cdots + f(d_n) \cdot(x_n-c - (x_{n-1}-c)).
```
"""

# ╔═╡ ddf6abdc-5825-11ec-3082-f10fc57b67d6
md"""The left side will have a limit of $\int_a^b f(x-c) dx$ the right would have a "limit" of $\int_{a-c}^{b-c}f(x)dx$.
"""

# ╔═╡ ddf6abe8-5825-11ec-39b7-2d5bc6fcc1b6
md"""Similarly, reflections don't effect the area under the curve, they just require a new parameterization:
"""

# ╔═╡ ddf6ac16-5825-11ec-1d5d-7d6060174f9c
md"""> ```math
> \int_a^b f(x) dx = \int_{-b}^{-a} f(-x) dx
> ```

"""

# ╔═╡ ddf6ac2c-5825-11ec-3b25-63cf4eb630e1
md"""The scaling operation $g(x) = f(cx)$ has the following:
"""

# ╔═╡ ddf6ac54-5825-11ec-0686-618e54299b12
md"""> ```math
> \int_a^b f(c\cdot x) dx = \frac{1}{c} \int_{ca}^{cb}f(x) dx
> ```

"""

# ╔═╡ ddf6ac86-5825-11ec-3692-d1d183b162cd
md"""The scaling operation shifts $a$ to $ca$ and $b$ to $cb$ so the limits of integration make sense. However, the area stretches by $c$ in the $x$ direction, so must contract by $c$ in the $y$ direction to stay in balance. Hence the factor of $1/c$.
"""

# ╔═╡ ddf6aca4-5825-11ec-14cf-0179bb2f3e61
md"""Combining two operations above, the operation $g(x) = \frac{1}{h}f(\frac{x-c}{h})$ will leave the area between $a$ and $b$ under $g$ the same as the area under $g$ between $(a-c)/h$ and $(b-c)/h$.
"""

# ╔═╡ ddf6acc2-5825-11ec-1ae4-3fb566a0ffbc
md"""---
"""

# ╔═╡ ddf6ace0-5825-11ec-0138-431ae050f508
md"""The area between $a$ and $b$ can be broken up into the sum of the area between $a$ and $c$ and that between $c$ and $b$.
"""

# ╔═╡ ddf6ad1e-5825-11ec-2f23-6954f09c77ce
md"""> ```math
> \int_a^b f(x) dx = \int_a^c f(x) dx + \int_c^b f(x) dx.
> ```

"""

# ╔═╡ ddf6ad3a-5825-11ec-1f93-f9e1cb1c8158
md"""For this, suppose we have a partition for both the integrals on the right hand side for a given $\epsilon/2$ and $\delta$. Combining these into a partition of $[a,b]$ will mean $\delta$ is still the norm. The approximating sum will combine to be no more than $\epsilon/2 + \epsilon/2$, so for a given $\epsilon$, this $\delta$ applies.
"""

# ╔═╡ ddf6ad50-5825-11ec-2270-5365e58cfc64
md"""This is due to the area on the left and right of $0$ being equivalent.
"""

# ╔═╡ ddf6ad58-5825-11ec-2d6e-d1dab4c2f0a1
md"""The "reversed" area is the same, only accounted for with a minus sign.
"""

# ╔═╡ ddf6ad7e-5825-11ec-393d-a14af6ed8c7e
md"""> ```math
> \int_a^b f(x) dx = -\int_b^a f(x) dx.
> ```

"""

# ╔═╡ ddf6ad8a-5825-11ec-15ae-c5c3a64581ce
md"""A consequence of the last few statements is:
"""

# ╔═╡ ddf6adc6-5825-11ec-161e-49d5182ec679
md"""> If $f(x)$ is an even function, then $\int_{-a}^a f(x) dx = 2 \int_0^a f(x) dx$. If $f(x)$ is an odd function, then  $\int_{-a}^a f(x) dx = 0$.

"""

# ╔═╡ ddf6ade2-5825-11ec-35fd-7d56dc82af99
md"""If $g$ bounds $f$ then the area under $g$ wil bound the area under  $f$, in particular if $f(x)$ is non negative, so will the area under  $f$ be non negative for any $a < b$. (This assumes that $g$ and $f$  are integrable.)
"""

# ╔═╡ ddf6ae20-5825-11ec-0a32-5d9b47a3672a
md"""> If $0 \leq f(x) \leq g(x)$ then $\int_a^b f(x) dx \leq \int_a^b g(x) dx.$

"""

# ╔═╡ ddf6ae3e-5825-11ec-03ac-d139cc6531fa
md"""For any partition of $[a,b]$ and choice of $c_i$, we have the term-by-term bound $f(c_i)(x_i-x_{i-1}) \leq g(c_i)(x_i-x_{i-1})$ So any sequence of partitions that converges to the limits will have this inequality maintained for the sum.
"""

# ╔═╡ ddf6ae54-5825-11ec-113a-7b94402d10b7
md"""### Some known integrals
"""

# ╔═╡ ddf6ae70-5825-11ec-2c15-61d1935b7dd5
md"""Using the definition, we can compute a few definite integrals:
"""

# ╔═╡ ddf6ae98-5825-11ec-3310-2737deca1d2c
md"""> ```math
> \int_a^b c dx = c \cdot (b-a).
> ```

"""

# ╔═╡ ddf6aeca-5825-11ec-3e73-4b397feb1089
md"""> ```math
> \int_a^b x dx = \frac{b^2}{2} - \frac{a^2}{2}.
> ```

"""

# ╔═╡ ddf6aee6-5825-11ec-30a6-059f93d7d081
md"""This is just the area of a trapezoid with heights $a$ and $b$ and side   length $b-a$, or $1/2 \cdot (b + a) \cdot (b - a)$. The right sum   would be:
"""

# ╔═╡ ddf6aefc-5825-11ec-0435-f72a9030513f
md"""```math
\begin{align*}
S &= x_1 \cdot (x_1 - x_0) + x_2 \cdot (x_2 - x_1) + \cdots x_n \cdot (x_n - x_{n-1}) \\
&= (a + 1\frac{b-a}{n}) \cdot \frac{b-a}{n} + (a + 2\frac{b-a}{n}) \cdot \frac{b-a}{n} + \cdots  (a + n\frac{b-a}{n}) \cdot \frac{b-a}{n}\\
&= n \cdot a \cdot (\frac{b-a}{n})  + (1 + 2 + \cdots n) \cdot (\frac{b-a}{n})^2 \\
&= n \cdot a \cdot (\frac{b-a}{n})  + \frac{n(n+1)}{2} \cdot (\frac{b-a}{n})^2 \\
& \rightarrow a \cdot(b-a) + \frac{(b-a)^2}{2} \\
&= \frac{b^2}{2} - \frac{a^2}{2}.
\end{align*}
```
"""

# ╔═╡ ddf6af2e-5825-11ec-1b88-a9c2f8699c6b
md"""> ```math
> \int_a^b x^2 dx = \frac{b^3}{3} - \frac{a^3}{3}.
> ```

"""

# ╔═╡ ddf6af42-5825-11ec-0622-e7a048557932
md"""This is similar to the Archimedes case with $a=0$ and $b=1$ shown above.
"""

# ╔═╡ ddf6af88-5825-11ec-0755-378828a79380
md"""> ```math
> \int_a^b x^k dx = \frac{b^{k+1}}{k+1} - \frac{a^{k+1}}{k+1},\quad k \neq -1
> ```
>
> .

"""

# ╔═╡ ddf6afc4-5825-11ec-3ad6-c5f7389dda70
md"""Cauchy showed this using a *geometric series* for the partition, not the arithmetic series $x_i = a + i (b-a)/n$. The series defined by $1 + \alpha = (b/a)^{1/n}$, then $x_i = a \cdot (1 + \alpha)^i$. Here the bases $x_{i+1} - x_i$ simplify to $x_i \cdot \alpha$ and $f(x_i) = (a\cdot(1+\alpha)^i)^k = a^k (1+\alpha)^{ik}$, or $f(x_i)(x_{i+1}-x_i) = a^{k+1}\alpha[(1+\alpha)^{k+1}]^i$, so, using $u=(1+\alpha)^{k+1}=(b/a)^{(k+1)/n}$, $f(x_i) \cdot(x_{i+1} - x_i) = a^{k+1}\alpha u^i$. This gives
"""

# ╔═╡ ddf6afd8-5825-11ec-33d3-af64817334e2
md"""```math
\begin{align*}
S &= a^{k+1}\alpha u^0 + a^{k+1}\alpha u^1 + \cdots + a^{k+1}\alpha u^{n-1}
&= a^{k+1} \cdot \alpha \cdot (u^0 + u^1 + \cdot u^{n-1}) \\
&= a^{k+1} \cdot \alpha \cdot \frac{u^n - 1}{u - 1}\\
&= (b^{k+1} - a^{k+1}) \cdot \frac{\alpha}{(1+\alpha)^{k+1} - 1} \\
&\rightarrow \frac{b^{k+1} - a^{k+1}}{k+1}.
\end{align*}
```
"""

# ╔═╡ ddf6b00a-5825-11ec-13be-8deb8f2db2af
md"""> ```math
> \int_a^b x^{-1} dx = \log(b) - \log(a), \quad (0 < a < b).
> ```

"""

# ╔═╡ ddf6b028-5825-11ec-0229-a7447cb05a62
md"""Again, Cauchy showed this using a geometric series. The expression $f(x_i) \cdot(x_{i+1} - x_i)$ becomes just $\alpha$. So the approximating sum becomes:
"""

# ╔═╡ ddf6b032-5825-11ec-0334-3bd78c45ef61
md"""```math
S = f(x_0)(x_1 - x_0) + f(x_1)(x_2 - x_1) + \cdots + f(x_{n-1}) (x_n - x_{n-1}) = \alpha + \alpha + \cdots \alpha = n\alpha.
```
"""

# ╔═╡ ddf6b04e-5825-11ec-34f2-b90f1293052c
md"""But, letting $x = 1/n$, the limit above is just the limit of
"""

# ╔═╡ ddf6b05a-5825-11ec-217a-117b3496d4a8
md"""```math
\lim_{x \rightarrow 0+} \frac{(b/a)^x - 1}{x} = \log(b/a) = \log(b) - \log(a).
```
"""

# ╔═╡ ddf6b064-5825-11ec-38b1-8ff08f5c005b
md"""(Using L'Hopital's rule to compute the limit.)
"""

# ╔═╡ ddf6b06e-5825-11ec-3b96-0354c7baa7d8
md"""Certainly other integrals could be computed with various tricks, but we won't pursue this. There is another way to evaluate integrals using the forthcoming Fundamental Theorem of Calculus.
"""

# ╔═╡ ddf6b080-5825-11ec-1bf9-57495a71e7c5
md"""### Some other consequences
"""

# ╔═╡ ddf6b156-5825-11ec-19a1-394511531c71
md"""  * The definition is defined in terms of any partition with its norm bounded by $\delta$. If you know a function $f$ is Riemann integrable, then it is enough to consider just a regular partition $x_i = a + i \cdot (b-a)/n$ when forming the sums, as was done above. It is just that showing a limit for just this particular type of partition would not be sufficient to prove Riemann integrability.
  * The choice of $c_i$ is arbitrary to allow for maximum flexibility. The Darboux integrals use the maximum and minimum over the subinterval. It is sufficient to prove integrability to show that the limit exists with just these choices.
  * Most importantly,
"""

# ╔═╡ ddf6b184-5825-11ec-0a47-9b5602b33ac2
md"""> A continuous function on $[a,b]$ is Riemann integrable on $[a,b]$.

"""

# ╔═╡ ddf6b1c2-5825-11ec-2524-d17ba524fa3c
md"""The main idea behind this is that the difference between the maximum and minimum values over a partition gets small. That is if $[x_{i-1}, x_i]$ is like $1/n$ is length, then the difference between the maximum of $f$ over this interval, $M$, and the minimum, $m$ over this interval will go to zero as $n$ gets big. That $m$ and $M$ exists is due to the extreme value theorem, that this difference goes to $0$ is a consequence of continuity. What is needed is that this value goes to $0$ at the same rate – no matter what interval is being discussed – is a consequence of a notion of uniform continuity, a concept discussed in advanced calculus, but which holds for continuous functions on closed intervals. Armed with this, the Riemann sum for a general partition can be bounded by this difference times $b-a$, which will go to zero. So the upper and lower Riemann sums will converge to the same value.
"""

# ╔═╡ ddf6b226-5825-11ec-0258-0f4a4e3f4d4f
md"""  * A "jump", or discontinuity of the first kind, is a value $c$ in $[a,b]$ where $\lim_{x \rightarrow c+} f(x)$ and $\lim_{x \rightarrow c-}f(x)$ both exist, but are not equal. It is true that a function that is not continuous on $I=[a,b]$, but only has discontinuities of the first kind on $I$ will be Riemann integrable on $I$.
"""

# ╔═╡ ddf6b244-5825-11ec-08f0-dfaa5cc21a96
md"""For example, the function $f(x) = 1$ for $x$ in $[0,1]$ and $0$ otherwise will be integrable, as it is continuous at all but two points, $0$ and $1$, where it jumps.
"""

# ╔═╡ ddf6b280-5825-11ec-0cce-cb7db9df3137
md"""  * Some functions can have infinitely many points of discontinuity and still be integrable. The example of $f(x) = 1/q$ when $x=p/q$ is rational, and $0$ otherwise is often used as an example.
"""

# ╔═╡ ddf6b2b2-5825-11ec-2f4a-0ff26245b297
md"""## Numeric integration
"""

# ╔═╡ ddf6b2c6-5825-11ec-142f-6b3dbdf0c9d3
md"""The Riemann sum approach gives a method to approximate the value of a definite integral. We just compute an approximating sum for a large value of $n$, so large that the limiting value and the approximating sum are close.
"""

# ╔═╡ ddf6b2d0-5825-11ec-1e07-fb35d269207b
md"""To see the mechanics, let's again return to Archimedes' problem and compute $\int_0^1 x^2 dx$.
"""

# ╔═╡ ddf6b2da-5825-11ec-0c47-ff081d194e1e
md"""Let us fix some values:
"""

# ╔═╡ ddf6ba8c-5825-11ec-361e-2f1ed95c1538
begin
	a, b = 0, 1
	f(x) = x^2
end

# ╔═╡ ddf6babe-5825-11ec-3b3e-49401c4f9d0d
md"""Then for a given $n$ we have some steps to do: create the partition, find the $c_i$, multiply the pieces and add up. Here is one way to do all this:
"""

# ╔═╡ ddf6be10-5825-11ec-0c22-511e238705fb
begin
	n = 5
	xs = a:(b-a)/n:b       # also range(a, b, length=n)
	deltas = diff(xs)      # forms x2-x1, x3-x2, ..., xn-xn-1
	cs = xs[1:end-1]       # finds left-hand end points. xs[2:end] would be right-hand ones.
end

# ╔═╡ ddf7e0ba-5825-11ec-31c1-09a14426ef70
md"""Now to multiply the values. We want to sum the product `f(cs[i]) * deltas[i]`, here is one way to do so:
"""

# ╔═╡ ddf7e948-5825-11ec-3a7e-a9eb8046f3aa
sum(f(cs[i]) * deltas[i] for i in 1:length(deltas))

# ╔═╡ ddf7e9c2-5825-11ec-301d-15925d1d3811
md"""Our answer is not so close to the value of $1/3$, but what did we expect - we only used $n=5$ intervals. Trying again with $50,000$ gives us:
"""

# ╔═╡ ddf7edc6-5825-11ec-2e18-3b50ad4bb509
let
	n = 50_000
	xs = a:(b-a)/n:b
	deltas = diff(xs)
	cs = xs[1:end-1]
	sum(f(cs[i]) * deltas[i] for i in 1:length(deltas))
end

# ╔═╡ ddf7edfa-5825-11ec-2d97-a190b653af3f
md"""This value is about $10^{-5}$ off from the actual answer of $1/3$.
"""

# ╔═╡ ddf7ee0c-5825-11ec-311b-71ed54756881
md"""We should expect that larger values of $n$ will produce better approximate values, as long as numeric issues don't get involved.
"""

# ╔═╡ ddf7ee20-5825-11ec-1f94-27b4f8979105
md"""Before continuing, we define a function to compute the Riemann sum for us with an extra argument to specifying one of four methods for computing $c_i$:
"""

# ╔═╡ ddf7ee48-5825-11ec-1995-b92a29a25ae3
md"""```
function riemann(f::Function, a::Real, b::Real, n::Int; method="right")
    if method == "right"
        meth = f -> (lr -> begin l,r = lr; f(r) * (r-l) end)
    elseif method == "left"
        meth = f -> (lr -> begin l,r = lr; f(l) * (r-l) end)
    elseif method == "trapezoid"
        meth = f -> (lr -> begin l,r = lr; (1/2) * (f(l) + f(r)) * (r-l) end)
    elseif method == "simpsons"
        meth = f -> (lr -> begin l,r=lr; (1/6) * (f(l) + 4*(f((l+r)/2)) + f(r)) * (r-l) end)
    end

    xs = a .+ (0:n) * (b-a)/n

    sum(meth(f), zip(xs[1:end-1], xs[2:end]))
end
```"""

# ╔═╡ ddf7ee5a-5825-11ec-005c-3f46b44c59d4
md"""(This function is defined in `CalculusWithJulia` and need not be copied over if that package is loaded.)
"""

# ╔═╡ ddf7ee7a-5825-11ec-2430-0dbd9df424b2
md"""With this, we can easily find an approximate answer. We wrote the function to use the familiar template `action(function, arguments...)`, so we pass in a function and arguments to describe the problem (`a`, `b`, and  `n` and, optionally, the `method`):
"""

# ╔═╡ ddf7f28a-5825-11ec-28e5-437507b10a09
begin
	𝒇(x) = exp(x)
	riemann(𝒇, 0, 5, 10)   # S_10
end

# ╔═╡ ddf7f2a8-5825-11ec-0830-cf9b2668b00e
md"""Or with more intervals in the partition
"""

# ╔═╡ ddf7f4f6-5825-11ec-1f80-7147a4c1a7db
riemann(𝒇, 0, 5, 50_000)

# ╔═╡ ddf7f51e-5825-11ec-3e4e-73d9a4b6aa00
md"""(The answer is $e^5 - e^0 = 147.4131591025766\dots$, which shows that even $50,000$ partitions is not enough to guarantee many digits of accuracy.)
"""

# ╔═╡ ddf7f546-5825-11ec-3b71-fdc5dacdd5c3
md"""## "Negative" area
"""

# ╔═╡ ddf7f562-5825-11ec-008c-8731c54330be
md"""So far, we have had the assumption that $f(x) \geq 0$, as that allows us to define the concept of area. We can define the signed area between $f(x)$ and the $x$ axis through the definite integral:
"""

# ╔═╡ ddf7f5a0-5825-11ec-0024-6b99e79f1f6b
md"""```math
A = \int_a^b f(x) dx.
```
"""

# ╔═╡ ddf7f5b4-5825-11ec-3daa-ad631a8afcde
md"""The right hand side is defined whenever the Riemann limit exists and in that case we call $f(x)$ Riemann integrable. (The definition does not suppose $f$ is non-negative.)
"""

# ╔═╡ ddf7f5d2-5825-11ec-21c3-1dbd5da235ca
md"""Suppose $f(a) = f(b) = 0$ for $a < b$ and for all $a < x < b$ we have $f(x) < 0$. Then we can see easily from the geometry (or from the Riemann sum approximation) that
"""

# ╔═╡ ddf7f5dc-5825-11ec-3539-d98318c746f6
md"""```math
\int_a^b f(x) dx = - \int_a^b \lvert f(x) \rvert dx.
```
"""

# ╔═╡ ddf7f5f0-5825-11ec-3603-6d1779ca5cea
md"""If we think of the area below the $x$ axis as "signed" area carrying a minus sign, then the total area can be seen again as a sum, only this time some of the summands may be negative.
"""

# ╔═╡ ddfafc8c-5825-11ec-0e2c-b308a56ebaef
md"""##### Example
"""

# ╔═╡ ddfafd18-5825-11ec-1949-eb767fd26524
md"""Consider a function $g(x)$ defined through its piecewise linear graph:
"""

# ╔═╡ ddfb073e-5825-11ec-2e11-1f8a7f7dc951
begin
	g(x) = abs(x) > 2 ? 1.0 : abs(x) - 1.0
	plot(g, -3,3)
	plot!(zero)
end

# ╔═╡ ddfb08c6-5825-11ec-2a0f-7b6e8eb759f3
md"""  * Compute $\int_{-3}^{-1} g(x) dx$. The area comprised of a square of area $1$ and a triangle with area $1/2$, so should be $3/2$.
  * Compute $\int_{-3}^{0} g(x) dx$. In addition to the above, there is a triangle with area $1/2$, but since the function is negative, this area is added in as $-1/2$. In total then we have $1 + 1/2 - 1/2 = 1$ for the answer.
  * Compute $\int_{-3}^{1} g(x) dx$:
"""

# ╔═╡ ddfb08f8-5825-11ec-0d7a-312c6bfaceab
md"""We could add the signed area over $[0,1]$ to the above, but instead see a square of area $1$, a triangle with area $1/2$ and a triangle with signed area $-1$. The total is then $1/2$.
"""

# ╔═╡ ddfb0920-5825-11ec-1616-ab592abee6a0
md"""  * Compute $\int_{-3}^{3} g(x) dx$:
"""

# ╔═╡ ddfb093e-5825-11ec-09f7-ed55b6f1d41b
md"""We could add the area, but let's use a symmetry trick. This is clearly twice our second answer, or $2$. (This is because $g(x)$ is an even function, as we can tell from the graph.)
"""

# ╔═╡ ddfb0952-5825-11ec-0c72-352713d919d3
md"""##### Example
"""

# ╔═╡ ddfb097c-5825-11ec-120b-4b90b5f4c884
md"""Suppose $f(x)$ is an odd function, then $f(x) = - f(-x)$ for any $x$. So the signed area between $[-a,0]$ is related to the signed area between $[0,a]$ but of different sign. This gives $\int_{-a}^a f(x) dx = 0$ for odd functions.
"""

# ╔═╡ ddfb0998-5825-11ec-3abb-29a076b60498
md"""An immediate consequence would be $\int_{-\pi}^\pi \sin(x) = 0$, as would $\int_{-a}^a x^k dx$ for any *odd* integer $k > 0$.
"""

# ╔═╡ ddfb09ae-5825-11ec-0f87-bde8bde0487e
md"""##### Example
"""

# ╔═╡ ddfb09c0-5825-11ec-16e1-6f7e1f4b812e
md"""Numerically estimate the definite integral $\int_0^e x\log(x) dx$. (We redefine the function to be $0$ at $0$, so it is continuous.)
"""

# ╔═╡ ddfb09f2-5825-11ec-2639-b59b0258fc31
md"""We have to be a bit careful with the Riemann sum, as the left Riemann sum will have an issue at $0=x_0$ (`0*log(0)` returns `NaN` which will poison any subsequent arithmetic operations, so the value returned will be `NaN` and not an approximate answer). We could define our function with a check:
"""

# ╔═╡ ddfb0ede-5825-11ec-0001-fbaf8ce0969c
𝒉(x) = x > 0 ? x * log(x) : 0.0

# ╔═╡ ddfb0f10-5825-11ec-3c32-93d730cb9a10
md"""This is actually inefficient, as the check for the size of `x` will slow things down a bit. Since we will call this function 50,000 times, we would like to avoid this, if we can. In this case just using the right sum will work:
"""

# ╔═╡ ddfb12f0-5825-11ec-0af6-b9e002e5452d
begin
	h(x) = x * log(x)
	riemann(h, 0, 2, 50_000, method="right")
end

# ╔═╡ ddfb130c-5825-11ec-00d8-351b84c15ac9
md"""(The default is `"right"`, so no method specified would also work.)
"""

# ╔═╡ ddfb1322-5825-11ec-32a9-858b95172f51
md"""##### Example
"""

# ╔═╡ ddfb1354-5825-11ec-0032-adfc490e5ad4
md"""Let $j(x) = \sqrt{1 - x^2}$. The area under the curve between $-1$ and $1$ is $\pi/2$. Using a Riemann sum with 4 equal subintervals and the midpoint, estimate $\pi$. How close are you?
"""

# ╔═╡ ddfb1366-5825-11ec-3264-cba88c72a01a
md"""The partition is $-1 < -1/2 < 0 < 1/2 < 1$. The midpoints are $-3/4, -1/4, 1/4, 3/4$. We thus have that $\pi/2$ is approximately:
"""

# ╔═╡ ddfb18de-5825-11ec-214b-416793734383
let
	xs = range(-1, 1, length=5)
	deltas = diff(xs)
	cs = [-3/4, -1/4, 1/4, 3/4]
	j(x) = sqrt(1 - x^2)
	a = sum(j(c)*delta for (c,delta) in zip(cs, deltas))
	a, pi/2  # π ≈  2a
end

# ╔═╡ ddfb18f0-5825-11ec-01cc-79128b34896b
md"""(For variety, we used an alternate way to sum over two vectors.)
"""

# ╔═╡ ddfb1910-5825-11ec-3546-6d1da74d2ea2
md"""So $\pi$ is about `2a`.
"""

# ╔═╡ ddfb191a-5825-11ec-2704-8988170f99a6
md"""##### Example
"""

# ╔═╡ ddfb1954-5825-11ec-2f00-f55bb1a412c1
md"""We have the well-known triangle [inequality](http://en.wikipedia.org/wiki/Triangle_inequality) which says for an individual sum: $\lvert a + b \rvert \leq \lvert a \rvert +\lvert b \rvert$. Applying this recursively to a partition with $a < b$ gives:
"""

# ╔═╡ ddfb197e-5825-11ec-0b78-135353061870
md"""```math
\begin{align*}
\lvert f(c_1)(x_1-x_0) + f(c_2)(x_2-x_1) + \cdots + f(c_n) (x_n-x_1) \rvert
& \leq
\lvert f(c_1)(x_1-x_0) \rvert + \lvert f(c_2)(x_2-x_1)\rvert + \cdots +\lvert f(c_n) (x_n-x_1) \rvert \\
&= \lvert f(c_1)\rvert (x_1-x_0) + \lvert f(c_2)\rvert (x_2-x_1)+ \cdots +\lvert f(c_n) \rvert(x_n-x_1).
\end{align*}
```
"""

# ╔═╡ ddfb1992-5825-11ec-0954-f1080a5994ef
md"""This suggests that the following inequality holds for integrals:
"""

# ╔═╡ ddfc9592-5825-11ec-1881-498729932d47
md"""> $\lvert \int_a^b f(x) dx \rvert \leq \int_a^b \lvert f(x) \rvert dx$.

"""

# ╔═╡ ddfc9678-5825-11ec-0c85-c965da4ac9d7
md"""This can be used to give bounds on the size of an integral. For example, suppose you know that $f(x)$ is continuous on $[a,b]$ and takes its maximum value of $M$ and minimum value of $m$. Letting $K$ be the larger of $\lvert M\rvert$ and $\lvert m \rvert$, gives this bound when $a < b$:
"""

# ╔═╡ ddfc96aa-5825-11ec-3c01-95dc61f697f4
md"""```math
\lvert\int_a^b f(x) dx \rvert \leq \int_a^b \lvert f(x) \rvert dx \leq \int_a^b K dx = K(b-a).
```
"""

# ╔═╡ ddfc96be-5825-11ec-0301-8ffe00fb08f9
md"""While such bounds are disappointing, often, when looking for specific values, they are very useful when establishing general truths, such as is done with proofs.
"""

# ╔═╡ ddfc96fa-5825-11ec-0d93-4d8096eda058
md"""## Error estimate
"""

# ╔═╡ ddfc9724-5825-11ec-3476-b317e77e7dfc
md"""The Riemann sum above is actually extremely inefficient. To see how much, we can derive an estimate for the error in approximating the value using an arithmetic progression as the partition. Let's assume that our function $f(x)$ is increasing, so that the right sum gives an upper estimate and the left sum a lower estimate, so the error in the estimate will be between these two values:
"""

# ╔═╡ ddfc9736-5825-11ec-1e91-f1fb973f8eae
md"""```math
\begin{align*}
\text{error} &\leq
\left[
f(x_1) \cdot (x_{1} - x_0)  + f(x_2) \cdot  (x_{2} - x_1) + \cdots + f(x_{n-1})(x_{n-1} - x_n) + f(x_n) \cdot (x_n - x_{n-1})\right] -
\left[f(x_0) \cdot (x_{1} - x_0)  + f(x_1) \cdot  (x_{2} - x_1) + \cdots + f(x_{n-1})(x_{n-1} - x_n)\right] \\
&= \frac{b-a}{n} \cdot (\left[f(x_1) + f(x_2) + \cdots f(x_n)\right] - \left[f(x_0) + \cdots f(x_{n-1})\right]) \\
&= \frac{b-a}{n} \cdot (f(b) - f(a)).
\end{align*}
```
"""

# ╔═╡ ddfc9756-5825-11ec-143f-d58b397eedd3
md"""We see the error goes to $0$ at a rate of $1/n$ with the constant depending on $b-a$ and the function $f$. In general, a similar bound holds when $f$ is not monotonic.
"""

# ╔═╡ ddfc9790-5825-11ec-21a4-972067afadce
md"""There are other ways to approximate the integral that use fewer points in the partition. [Simpson's](http://tinyurl.com/7b9pmu) rule is one, where instead of approximating the area with rectangles that go through some $c_i$ in $[x_{i-1}, x_i]$ instead the function is approximated by the quadratic polynomial going through $x_{i-1}$, $(x_i + x_{i-1})/2$, and $x_i$ and the exact area under that polynomial is used in the approximation. The explicit formula is:
"""

# ╔═╡ ddfc97a4-5825-11ec-2645-433d492a459d
md"""```math
A \approx \frac{b-a}{3n} (f(x_0) + 4 f(x_1) + 2f(x_2) + 4f(x_3) + \cdots + 2f(x_{n-2}) + 4f(x_{n-1}) + f(x_n)).
```
"""

# ╔═╡ ddfc97b6-5825-11ec-370b-73daa6858a4d
md"""The error in this approximation can be shown to be
"""

# ╔═╡ ddfc97c2-5825-11ec-3c02-23515629e08c
md"""```math
\text{error} \leq \frac{(b-a)^5}{180n^4} \text{max}_{\xi \text{ in } [a,b]} \lvert f^{(4)}(\xi) \rvert.
```
"""

# ╔═╡ ddfc97e0-5825-11ec-1b54-4786bf1b1229
md"""That is, the error is like $1/n^4$ with constants depending on the length of the interval, $(b-a)^5$, and the maximum value of the fourth derivative over $[a,b]$. This is significant, the error in $10$ steps of Simpson's rule is on the scale of the error of $10,000$ steps of the Riemann sum for well-behaved functions.
"""

# ╔═╡ ddfca726-5825-11ec-0858-4dc35beb62a8
note(L"""

The Wikipedia article mentions that Kepler used a similar formula $100$
years prior to Simpson, or about $200$ years before Riemann published
his work. Again, the value in Riemann's work is not the computation of
the answer, but the framework it provides in determining if a function
is Riemann integrable or not.

""")

# ╔═╡ ddfca74e-5825-11ec-23f3-0b6a0d1243d3
md"""## Gauss quadrature
"""

# ╔═╡ ddfca7a0-5825-11ec-1bd7-6bf6c663c750
md"""The formula for Simpson's rule was the *composite* formula. If just a single rectangle is approximated over $[a,b]$ by a parabola interpolating the points $x_1=a$, $x_2=(a+b)/2$, and $x_3=b$, the formula is:
"""

# ╔═╡ ddfca7bc-5825-11ec-1db1-79422609abae
md"""```math
\frac{b-a}{6}(f(x_1) + 4f(x_2) + f(x_3)).
```
"""

# ╔═╡ ddfca7da-5825-11ec-3cac-a110c12f9b03
md"""This formula will actually be exact for any 3rd degree polynomial. In fact an entire family of similar approximations using $n$ points can be made exact for any polynomial of degree $n-1$ or lower. But with non-evenly spaced points, even better results can be found.
"""

# ╔═╡ ddfca7ee-5825-11ec-00f8-cd97efe6cc87
md"""The formulas for an approximation to the integral $\int_{-1}^1 f(x) dx$ discussed so far can be written as:
"""

# ╔═╡ ddfca804-5825-11ec-259f-e72ebd37176e
md"""```math
S = w_1 f(x_1) + w_2 f(x_2) + \cdots + w_n f(x_n).
```
"""

# ╔═╡ ddfca852-5825-11ec-38f7-ebfdc9c7e6e6
md"""The $w$s are "weights" and the $x$s are nodes. A [Gaussian](http://en.wikipedia.org/wiki/Gaussian_quadrature) *quadrature rule* is a set of weights and nodes for $i=1, \dots n$ for which the sum is *exact* for any $f$ which is a polynomial of degree $2n-1$ or less. Such choices then also approximate well the integrals of functions which are not polynomials of degree $2n-1$, provided $f$ can be well approximated by a polynomial over $[-1,1]$. (Which is the case for the "nice" functions we encounter.) Some examples are given in the questions.
"""

# ╔═╡ ddfca87a-5825-11ec-1953-11a4c34eb076
md"""### The quadgk function
"""

# ╔═╡ ddfca8c0-5825-11ec-1b23-41eec39d1127
md"""In `Julia` a modification of the Gauss quadrature rule is implemented in the `quadgk` function (from the `QuadGK` package) to give numeric approximations to integrals. The `quadgk` function also has the familiar interface `action(function, arguments...)`. Unlike our `riemann` function, there is no `n` specified, as the number of steps is *adaptively* determined. (There is more partitioning occurring where the function is changing rapidly.) Instead, the algorithm outputs an estimate on the possible error along with the answer. Instead of $n$, some trickier problems require a specification of an error threshold.
"""

# ╔═╡ ddfca8d4-5825-11ec-1a52-a9123e88321f
md"""To use the function, we have:
"""

# ╔═╡ ddfcae04-5825-11ec-1f2e-3daa91073e33
let
	f(x) = x * log(x)
	quadgk(f, 0, 2)
end

# ╔═╡ ddfcae42-5825-11ec-1bfb-9b283609db82
md"""As mentioned, there are two values returned: an approximate answer, and an error estimate. In this example we see that the value of $0.3862943610307017$ is accurate to within $10^{-9}$.  (The actual answer is $-1 + 2\cdot \log(2)$ and the error is only $10^{-11}$. The reported error is an upper bound, and may be conservative, as with this problem.)  Our previous answer using $50,000$ right-Riemann sums was $0.38632208884775737$ and is only accurate to $10^{-5}$. By contrast, this method uses just $256$ function evaluations in the above problem.
"""

# ╔═╡ ddfcae4c-5825-11ec-190c-0bbf73154dd6
md"""The method should be exact for polynomial functions:
"""

# ╔═╡ ddfcb34c-5825-11ec-3677-6d5296eb9c6a
let
	f(x) = x^5 - x + 1
	quadgk(f, -2, 2)
end

# ╔═╡ ddfcb372-5825-11ec-0875-af5dc45b9f84
md"""The error term is $0$, answer is $4$ up to the last unit of precision (1 ulp), so any error is only in floating point approximations.
"""

# ╔═╡ ddfcb392-5825-11ec-0b7d-4f77505df0a2
md"""For the numeric computation of definite integrals, the `quadgk` function should be used over the Riemann sums or even Simpson's rule.
"""

# ╔═╡ ddfcb3a6-5825-11ec-0dba-9d5cfde02a5a
md"""Here are some sample integrals computed with `quadgk`:
"""

# ╔═╡ ddfcb3b0-5825-11ec-279b-6d507b31c619
md"""```math
\int_0^\pi \sin(x) dx
```
"""

# ╔═╡ ddfcb5fe-5825-11ec-23cf-03ae7f3c447d
quadgk(sin, 0, pi)

# ╔═╡ ddfcb610-5825-11ec-0bcd-7fdfccb2a4ca
md"""(Again, the actual answer is off only in the last digit, the error estimate is an upper bound.)
"""

# ╔═╡ ddfcb626-5825-11ec-3bec-7df615bbdbf1
md"""```math
\int_0^2 x^x dx
```
"""

# ╔═╡ ddfcb93c-5825-11ec-1a0a-21bc84d08fc6
quadgk(x -> x^x, 0, 2)

# ╔═╡ ddfcb950-5825-11ec-1066-8be5f30b2608
md"""```math
\int_0^5 e^x dx
```
"""

# ╔═╡ ddfcbc16-5825-11ec-2e7f-f30415e65f60
quadgk(exp, 0, 5)

# ╔═╡ ddfcbc34-5825-11ec-39d2-19bad93e99ce
md"""When composing the answer with other functions it may be desirable to drop the error in the answer. Two styles can be used for this. The first is to just name the two returned values:
"""

# ╔═╡ ddfccb16-5825-11ec-2232-dbec5898f1e9
let
	A, err = quadgk(cos, 0, pi/4)
	A
end

# ╔═╡ ddfccb48-5825-11ec-2fd5-1db2528b8b51
md"""The second is to ask for just the first component of the returned value:
"""

# ╔═╡ ddfccfbc-5825-11ec-3bb8-e99076d50619
let
	A = quadgk(tan, 0, pi/4)[1] # or first(quadgk(tan, 0, pi/4))
end

# ╔═╡ ddfccff8-5825-11ec-36e9-cd82d03fde26
md"""##### Example
"""

# ╔═╡ ddfcd05c-5825-11ec-23c2-b5e7ec0d050d
md"""In probability theory, a *univariate density* is a function, $f(x)$ such that $f(x) \geq 0$ and $\int_a^b f(x) dx = 1$, where $a$ and $b$ are the range of the distribution. The [Von Mises](http://en.wikipedia.org/wiki/Von_Mises_distribution) distribution, takes the form
"""

# ╔═╡ ddfcd070-5825-11ec-3062-b34998c886e3
md"""```math
k(x) = C \cdot \exp(\cos(x)), \quad -\pi \leq x \leq \pi
```
"""

# ╔═╡ ddfcd084-5825-11ec-0ed9-4786939b8993
md"""Compute $C$ (numerically).
"""

# ╔═╡ ddfcd0a2-5825-11ec-07e9-ed08533d2899
md"""The fact that $1 = \int_{-\pi}^\pi C \cdot \exp(\cos(x)) dx = C \int_{-\pi}^\pi \exp(\cos(x)) dx$ implies that $C$ is the reciprocal of
"""

# ╔═╡ ddfcd4e4-5825-11ec-149a-133b697251b7
begin
	k(x) = exp(cos(x))
	A,err = quadgk(k, -pi, pi)
end

# ╔═╡ ddfcd4f8-5825-11ec-15c1-0f5cdcebd771
md"""So
"""

# ╔═╡ ddfcd886-5825-11ec-0962-e11fc844f5ce
begin
	C = 1/A
	k₁(x) = C * exp(cos(x))
end

# ╔═╡ ddfcd8e0-5825-11ec-047d-cdc862aca626
md"""The *cumulative distribution function* for $k(x)$ is $K(x) = \int_{-\pi}^x k(u) du$, $-\pi \leq x \leq \pi$. We just showed that $K(\pi) = 1$ and it is trivial that $K(-\pi) = 0$. The quantiles of the distribution are the values $q_1$, $q_2$, and $q_3$ for which $K(q_i) = i/4$. Can we find these?
"""

# ╔═╡ ddfcd8f4-5825-11ec-1944-2f83a91cf9be
md"""First we define a function, that computes $K(x)$:
"""

# ╔═╡ ddfcdc5a-5825-11ec-1a74-2f992f3a060a
K(x) = quadgk(k₁, -pi, x)[1]

# ╔═╡ ddfcdc8c-5825-11ec-360e-15262693fbc7
md"""(The trailing `[1]` is so only the answer - and not the error - is returned.)
"""

# ╔═╡ ddfcdcdc-5825-11ec-1cb7-8d69324b5200
md"""The question asks us to solve $K(x) = 0.25$, $K(x) = 0.5$ and $K(x) = 0.75$. The `Roots` package can be used for such work, in particular `find_zero`. We will use a bracketing method, as clearly $K(x)$ is increasing, as $k(u)$ is positive, so we can just bracket our answer with $-\pi$ and $\pi$. (We solve $K(x) - p = 0$, so $K(\pi) - p > 0$ and $K(-\pi)-p < 0$.). The only trick below is the use of an anonymous function to write the function for $K(x) - p$ with $p$ taking one of three values:
"""

# ╔═╡ ddfce38a-5825-11ec-14eb-7f6436f2e4ac
[find_zero(x -> K(x) - p, (-pi, pi)) for p in [0.25, 0.5, 0.75]]

# ╔═╡ ddfce3e4-5825-11ec-3b35-b3dbfd26ff92
md"""The middle one is clearly $0$. This distribution is symmetric about $0$, so half the area is to the right of $0$ and half to the left, so clearly when $p=0.5$, $x$ is $0$. The other two show that the area to the left of $-0.809767$ is equal to the area to the right of $0.809767$ and equal to $0.25$.
"""

# ╔═╡ ddfce402-5825-11ec-1d76-2f323b5b8087
md"""## Questions
"""

# ╔═╡ ddff9de6-5825-11ec-3c51-6d7530982946
md"""###### Question
"""

# ╔═╡ ddff9e56-5825-11ec-03b8-7f1b8b43ef33
md"""Using geometry, compute the definite integral:
"""

# ╔═╡ ddff9ea4-5825-11ec-29ee-3752424eac79
md"""```math
\int_{-5}^5 \sqrt{5^2 - x^2} dx.
```
"""

# ╔═╡ ddffa8ae-5825-11ec-2f8d-83610f687e38
let
	f(x) = sqrt(5^2 - x^2)
	val, _ = quadgk(f, -5,5)
	numericq(val)
end

# ╔═╡ ddffa8e0-5825-11ec-20a1-7fb14126793c
md"""###### Question
"""

# ╔═╡ ddffa8f4-5825-11ec-2f82-1d608fbb44c3
md"""Using geometry, compute the definite integral:
"""

# ╔═╡ ddffa908-5825-11ec-1815-9508f72876a5
md"""```math
\int_{-2}^2 (2 - \lvert x\rvert) dx
```
"""

# ╔═╡ ddffad9c-5825-11ec-1d08-e9e328048115
let
	f(x) = 2- abs(x)
	a,b = -2, 2
	val, _ = quadgk(f, a,b)
	numericq(val)
end

# ╔═╡ ddffadae-5825-11ec-002e-31f254bda9c0
md"""###### Question
"""

# ╔═╡ ddffadc2-5825-11ec-23dd-af3e013deeb8
md"""Using geometry, compute the definite integral:
"""

# ╔═╡ ddffadd6-5825-11ec-133e-21e3f01bed8e
md"""```math
\int_0^3 3 dx + \int_3^9 (3 + 3(x-3)) dx
```
"""

# ╔═╡ ddffb592-5825-11ec-09e0-876a41e99041
let
	f(x) = x <= 3 ? 3.0 : 3 + 3*(x-3)
	a,b = 0, 9
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ ddffb5b0-5825-11ec-0b02-fd9e6d097dda
md"""###### Question
"""

# ╔═╡ ddffb5ba-5825-11ec-1f90-b91c388c48a1
md"""Using geometry, compute the definite integral:
"""

# ╔═╡ ddffb5ce-5825-11ec-0f26-818506d1f53a
md"""```math
\int_0^5 \lfloor x \rfloor dx
```
"""

# ╔═╡ ddffb61e-5825-11ec-2cae-3f7a3504124e
md"""(The notation $\lfloor x \rfloor$ is the integer such that $\lfloor x \rfloor \leq x < \lfloor x \rfloor + 1$.)
"""

# ╔═╡ ddffb9a2-5825-11ec-0abc-1b9878398292
let
	f(x) = floor(x)
	a, b = 0, 5
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ ddffb9b6-5825-11ec-1d9e-75a564324886
md"""###### Question
"""

# ╔═╡ ddffb9e0-5825-11ec-0634-25943b858590
md"""Using geometry, compute the definite integral between $-3$ and $3$ of this graph comprised of lines and circular arcs:
"""

# ╔═╡ ddffc60e-5825-11ec-1405-cf0e400857da
let
	function f(x)
	  if x < -1
	    abs(x+1)
	  elseif -1 <= x <= 1
	    sqrt(1 - x^2)
	  else
	    abs(x-1)
	  end
	end
	plot(f, -3, 3, aspect_ratio=:equal)
end

# ╔═╡ ddffc62c-5825-11ec-20c3-9710c0730001
md"""The value is:
"""

# ╔═╡ ddffcdb6-5825-11ec-0225-1b2bbfd98fb7
let
	val = (1/2 * 2 * 2) * 2 + pi*1^2/2
	numericq(val)
end

# ╔═╡ ddffcdd4-5825-11ec-252b-3f3623fdfa03
md"""###### Question
"""

# ╔═╡ ddffce06-5825-11ec-216a-dd415e2d4bc1
md"""For the function $f(x) = \sin(\pi x)$, estimate the integral for $-1$ to $1$ using a left-Riemann sum with the partition $-1 < -1/2 < 0 < 1/2 < 1$.
"""

# ╔═╡ ddffd18a-5825-11ec-2107-a98949662fab
let
	f(x) = sin(x)
	xs = -1:1/2:1
	deltas = diff(xs)
	val = sum(map(f, xs[1:end-1]) .* deltas)
	numericq(val)
end

# ╔═╡ ddffd1a8-5825-11ec-1249-6b7243d71078
md"""###### Question
"""

# ╔═╡ ddffd1da-5825-11ec-2b78-315c555895b5
md"""Without doing any *real* work, find this integral:
"""

# ╔═╡ ddffd1ee-5825-11ec-37be-fb56c0cf6ccf
md"""```math
\int_{-\pi/4}^{\pi/4} \tan(x) dx.
```
"""

# ╔═╡ ddffd4e6-5825-11ec-356a-17b2ac0703e1
let
	val = 0
	numericq(val)
end

# ╔═╡ ddffd506-5825-11ec-3e8e-d5c91ef18999
md"""###### Question
"""

# ╔═╡ ddffd518-5825-11ec-0bb9-71d0189bf422
md"""Without doing any *real* work, find this integral:
"""

# ╔═╡ ddffd52c-5825-11ec-2825-35fc34c1cd0a
md"""```math
\int_3^5 (1 - \lvert x-4 \rvert) dx
```
"""

# ╔═╡ ddffd82e-5825-11ec-0036-4b056e7b3632
let
	val = 1
	numericq(val)
end

# ╔═╡ ddffd842-5825-11ec-16a3-e94066ea1e43
md"""###### Question
"""

# ╔═╡ ddffd868-5825-11ec-0a76-5715b428f758
md"""Suppose you know that for the integrable function $\int_a^b f(u)du =1$ and $\int_a^c f(u)du = p$. If $a < c < b$ what is $\int_c^b f(u)du$?
"""

# ╔═╡ ddffdec8-5825-11ec-07de-299a332b7fe0
let
	choices = [
	"``1``",
	"``p``",
	"``1-p``",
	"``p^2``"]
	 ans = 3
	radioq(choices, ans)
end

# ╔═╡ ddffdee6-5825-11ec-2783-f1c2b38fd577
md"""###### Question
"""

# ╔═╡ ddffdf04-5825-11ec-0f62-b3ef6f24e9f3
md"""What is $\int_0^2 x^4 dx$? Use the rule for integrating $x^n$.
"""

# ╔═╡ ddffe6c0-5825-11ec-2f5b-4b50c71f1742
let
	choices = [
	"``2^5 - 0^5``",
	"``2^5/5 - 0^5/5``",
	"``2^4/4 - 0^4/4``",
	"``3\\cdot 2^3 - 3 \\cdot 0^3``"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ ddffe6d4-5825-11ec-0b79-f97e7d0b0ce9
md"""###### Question
"""

# ╔═╡ ddffe6f2-5825-11ec-1f0e-b7554b5aff85
md"""Solve for a value of $x$ for which:
"""

# ╔═╡ ddffe706-5825-11ec-2e2b-6130563e8b53
md"""```math
\int_1^x \frac{1}{u}du = 1.
```
"""

# ╔═╡ ddffea7e-5825-11ec-27f1-b1f28a00d1d9
let
	val = exp(1)
	numericq(val)
end

# ╔═╡ ddffea94-5825-11ec-1d8c-8d575bdc95ec
md"""###### Question
"""

# ╔═╡ ddffeab2-5825-11ec-3cb6-3f4fc302d46c
md"""Solve for a value of $n$ for which
"""

# ╔═╡ ddffeac6-5825-11ec-3ac6-7da3c719e0e7
md"""```math
\int_0^1 x^n dx = \frac{1}{12}.
```
"""

# ╔═╡ ddffedd2-5825-11ec-2a86-2115b31291c4
let
	val = 11
	numericq(val)
end

# ╔═╡ ddffede6-5825-11ec-2163-1fecb61a3867
md"""###### Question
"""

# ╔═╡ ddffee18-5825-11ec-0d41-ef25f6e0e310
md"""Suppose $f(x) > 0$ and $a < c < b$. Define $F(x) = \int_a^x f(u) du$. What can be said about $F(b)$ and $F(c)$?
"""

# ╔═╡ ddfff8e0-5825-11ec-18c7-adfa0de9a95a
let
	choices = [
	L"The area between $c$ and $b$ must be positive, so $F(c) < F(b)$.",
	"``F(b) - F(c) = F(a).``",
	L" $F(x)$ is continuous, so between $a$ and $b$ has an extreme value, which must be at $c$. So $F(c) \geq F(b)$."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ ddfff8f4-5825-11ec-08e2-0967f368228f
md"""###### Question
"""

# ╔═╡ ddfff91c-5825-11ec-0558-dddc13eaaf9f
md"""For the right Riemann sum approximating $\int_0^{10} e^x dx$ with $n=100$ subintervals, what would  be a good estimate for the error?
"""

# ╔═╡ de0000a6-5825-11ec-318c-b955c81df2f7
let
	choices = [
	"``(10 - 0)/100 \\cdot (e^{10} - e^{0})``",
	"``10/100``",
	"``(10 - 0) \\cdot e^{10} / 100^4``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ de0000ba-5825-11ec-1217-976a98e990f5
md"""###### Question
"""

# ╔═╡ de0000e2-5825-11ec-11e8-21c5050a676e
md"""Use `quadgk` to find the following definite integral:
"""

# ╔═╡ de0000f6-5825-11ec-278e-07d5dc76da14
md"""```math
\int_1^4 x^x dx   .
```
"""

# ╔═╡ de00046e-5825-11ec-3291-ef5cdde40bfd
let
	f(x) = x^x
	a, b = 1, 4
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ de000484-5825-11ec-2338-9b2bdd178dff
md"""###### Question
"""

# ╔═╡ de0004a2-5825-11ec-0d56-e521d01943b0
md"""Use `quadgk` to find the following definite integral:
"""

# ╔═╡ de0004ac-5825-11ec-0edb-97d5e5152bf7
md"""```math
\int_0^3 e^{-x^2} dx   .
```
"""

# ╔═╡ de000a42-5825-11ec-14cb-895ca1ed802f
let
	f(x) = exp(-x^2)
	a, b = 0, 3
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ de000a60-5825-11ec-0b8a-73aa9217b59f
md"""###### Question
"""

# ╔═╡ de000a80-5825-11ec-3230-f95e09e3de50
md"""Use `quadgk` to find the following definite integral:
"""

# ╔═╡ de000a92-5825-11ec-0199-879fd808a661
md"""```math
\int_0^{9/10} \tan(u \frac{\pi}{2}) du.   .
```
"""

# ╔═╡ de001000-5825-11ec-3d13-4f7aabd36cbd
let
	f(x) = tan(x*pi/2)
	a, b = 0, 9/10
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ de001028-5825-11ec-324b-7bf4d10423cc
md"""###### Question
"""

# ╔═╡ de001046-5825-11ec-330c-0d8f4ade1e5c
md"""Use `quadgk` to find the following definite integral:
"""

# ╔═╡ de00105a-5825-11ec-1104-f5c28f9a3d7e
md"""```math
\int_{-1/2}^{1/2} \frac{1}{\sqrt{1 - x^2}} dx
```
"""

# ╔═╡ de001960-5825-11ec-3d97-d189cdacd14d
let
	f(x) = 1/sqrt(1 - x^2)
	a, b =-1/2, 1/2
	val, _ = quadgk(f, a, b)
	numericq(val)
end

# ╔═╡ de001974-5825-11ec-0032-cdcf1272a0ea
md"""###### Question
"""

# ╔═╡ de0022ca-5825-11ec-0d79-771517cdde74
let
	caption = """
	The area under a curve approximated by a Riemann sum.
	"""
	url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/integrals/riemann.js"
	#CalculusWithJulia.WeaveSupport.JSXGraph(joinpath(@__DIR__, "riemann.js"), caption)
	CalculusWithJulia.WeaveSupport.JSXGraph(url, caption)
end

# ╔═╡ de0022de-5825-11ec-1ee3-877d85a04f7c
md"""The interactive graphic shows the area of a right-Riemann sum for different partitions. The function is
"""

# ╔═╡ de0022f2-5825-11ec-2423-21fbb49ed9e7
md"""```math
f(x) = \frac{1}{\sqrt{ x^4 +  10x^2 - 60x + 100}}
```
"""

# ╔═╡ de00231a-5825-11ec-0d99-d90de70f3474
md"""When $n=5$ what is the area of the Riemann sum?
"""

# ╔═╡ de002518-5825-11ec-0ae2-c9318ff732ed
let
	numericq(0.1224)
end

# ╔═╡ de002540-5825-11ec-1eb5-c5c1594b8729
md"""When $n=50$ what is the area of the Riemann sum?
"""

# ╔═╡ de0026f8-5825-11ec-25a0-f3358b1bd6aa
let
	numericq(0.1887)
end

# ╔═╡ de002720-5825-11ec-3fbb-673a4d540b55
md"""Using `quadgk` what is the area under the curve?
"""

# ╔═╡ de0031aa-5825-11ec-0378-9da964018002
let
	g(x) = 1/sqrt(x^4 + 10x^2 - 60x + 100)
	val, tmp = quadgk(g, 0, 1)
	numericq(val)
end

# ╔═╡ de0031ca-5825-11ec-07f0-31aff5852f02
md"""###### Question
"""

# ╔═╡ de0031e8-5825-11ec-1ed1-25512a25e4a8
md"""Gauss nodes for approximating the integral $\int_{-1}^1 f(x) dx$ for $n=4$ are:
"""

# ╔═╡ de0038d2-5825-11ec-0ca9-a516bb8d9899
ns = [-0.861136, -0.339981, 0.339981, 0.861136]

# ╔═╡ de003904-5825-11ec-00c0-9b37369d6020
md"""The corresponding weights are
"""

# ╔═╡ de003e4a-5825-11ec-0c62-8be0e2551238
wts = [0.347855, 0.652145, 0.652145, 0.347855]

# ╔═╡ de003e7c-5825-11ec-1c55-3905426daca9
md"""Use these to estimate the integral $\int_{-1}^1 \cos(\pi/2 \cdot x)dx$ with $w_1f(x_1) + w_2 f(x_2) + w_3 f(x_3) + w_4 f(x_4)$.
"""

# ╔═╡ de0046d8-5825-11ec-013f-dfbde508885c
let
	f(x) = cos(pi/2*x)
	val = sum([f(wi)*ni for (wi, ni) in zip(wts, ns)])
	numericq(val)
end

# ╔═╡ de004702-5825-11ec-31e0-831ea71e201c
md"""The actual answer is $4/\pi$. How far off is the approximation based on 4 points?
"""

# ╔═╡ de005308-5825-11ec-1d56-4b5e10d3bc32
let
	choices = [
	L"around $10^{-1}$",
	L"around $10^{-2}$",
	L"around $10^{-4}$",
	L"around $10^{-6}$",
	L"around $10^{-8}$"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ de005326-5825-11ec-1276-43069c4e659e
md"""###### Question
"""

# ╔═╡ de005346-5825-11ec-046a-193b9c440644
md"""Using the Gauss nodes and weights from the previous question, estimate the integral of $f(x) = e^x$ over $[-1, 1]$. The value is:
"""

# ╔═╡ de0056a8-5825-11ec-0f82-9db26286f7cd
let
	f(x) = exp(x)
	val = sum([f(wi)*ni for (wi, ni) in zip(wts, ns)])
	numericq(val)
end

# ╔═╡ de0056d2-5825-11ec-380d-816f0e812f6f
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/taylor_series_polynomials.html">◅ previous</a>  <a href="../integrals/ftc.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/integrals/area.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ de0056e6-5825-11ec-0697-9dc8e614b2c7
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Mustache = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
QuadGK = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"

[compat]
CalculusWithJulia = "~0.0.12"
Mustache = "~1.0.12"
Plots = "~1.25.1"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
QuadGK = "~2.4.2"
Roots = "~1.3.11"
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
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "Test"]
git-tree-sha1 = "a27b8f527652c6c06c0857319878b22563238102"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.12"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

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
git-tree-sha1 = "3e7e9415f917db410dcc0a6b2b55711df434522c"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

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
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

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
# ╟─de0056b4-5825-11ec-2b37-11a8d56a4596
# ╟─ddae19d0-5825-11ec-3248-2773029664ff
# ╟─ddb02266-5825-11ec-0748-a1d016024b26
# ╠═ddc711f4-5825-11ec-2f2f-774ff67af6a7
# ╟─ddc717be-5825-11ec-3ce7-23cc33910687
# ╟─ddc8ec36-5825-11ec-23d2-4f3d37f25f46
# ╟─ddcda494-5825-11ec-1649-d368f03dab41
# ╟─ddcda52a-5825-11ec-368b-fb9571ee6a75
# ╟─ddcda53e-5825-11ec-2bae-673d5e8f2123
# ╠═ddcdade0-5825-11ec-31d2-9b4b8f2b639c
# ╟─ddcdae1a-5825-11ec-1c73-7dabd6a36067
# ╠═ddcdb4ca-5825-11ec-1bd2-ef6384da8865
# ╟─ddcdb51a-5825-11ec-079d-73d6d97a351d
# ╠═ddcdc2a0-5825-11ec-28d5-d3e0d50729ce
# ╟─ddcdc2e4-5825-11ec-2316-f365e838a6f6
# ╠═ddcdc8e8-5825-11ec-0b7e-39f37401a600
# ╟─ddcdc8fc-5825-11ec-2fb8-5f41bebe4c25
# ╟─ddd0635a-5825-11ec-2256-0d98baf0709a
# ╟─ddd063d2-5825-11ec-3380-f5b3ae1a98de
# ╟─ddd06c6a-5825-11ec-3e4d-3fc6ca25ec1b
# ╟─ddd1a6ca-5825-11ec-19ae-112b4d614486
# ╟─ddd358ee-5825-11ec-2565-3f6b1949e2c6
# ╟─ddd35952-5825-11ec-2b9e-d7ff60d5b451
# ╟─ddd3597a-5825-11ec-0659-f9cc3aa102dd
# ╟─ddd3617c-5825-11ec-32c3-d16e878c9689
# ╟─ddd458ca-5825-11ec-0596-3541cdf5e4c0
# ╟─ddd459f6-5825-11ec-1f1e-970ec0e66462
# ╟─ddd45a28-5825-11ec-3205-a9885af25f8f
# ╟─ddd6ec34-5825-11ec-3abb-bbd1453a7ff8
# ╟─ddd6ecac-5825-11ec-066b-219c1ba48edf
# ╟─ddd74cd8-5825-11ec-3ca2-3bc5d8b78b76
# ╟─ddd95942-5825-11ec-0144-ff9cd6e98840
# ╟─ddd95a64-5825-11ec-084a-452d7f84c5cc
# ╟─ddd95a8e-5825-11ec-2050-ad9b7c2e1c26
# ╟─ddd95aaa-5825-11ec-1ba2-b3c261116985
# ╟─ddd95ac8-5825-11ec-13a8-c52eca5be4de
# ╟─ddd95afa-5825-11ec-2b6b-072cce3226cb
# ╟─ddd95b0e-5825-11ec-052b-e379ef92af38
# ╟─ddd95b20-5825-11ec-1f6b-93c79a1d2a0b
# ╟─ddd96c8e-5825-11ec-0830-1d4161ac2f89
# ╟─ddd96cc0-5825-11ec-2b63-2367062f3ecd
# ╟─ddd96d10-5825-11ec-1360-2dd2aa1b7057
# ╟─ddd96d1a-5825-11ec-0a2a-35201361151e
# ╟─ddd96d2e-5825-11ec-1d68-ed0db21e4c07
# ╟─dde2d1e8-5825-11ec-27d2-b5f4efb078bc
# ╟─dde2d244-5825-11ec-2a8b-21f8002da464
# ╟─dde2d288-5825-11ec-0efb-635c3e0cd351
# ╟─dde2d2a4-5825-11ec-3db0-5bb597e9e6fe
# ╟─dde2d37a-5825-11ec-12d5-dd977ab90bc8
# ╟─ddeaba16-5825-11ec-131b-737301da0959
# ╟─ddeaba7a-5825-11ec-3eb5-bd659a41d5be
# ╟─ddeabaa2-5825-11ec-1de8-a760f7d2f695
# ╟─ddefb322-5825-11ec-0171-4729cd0c405b
# ╟─ddf6a92a-5825-11ec-23fa-cf34617dfaa3
# ╟─ddf6a978-5825-11ec-391a-4ba721e6a672
# ╟─ddf6a9b6-5825-11ec-311b-73c6148e8942
# ╟─ddf6a9ca-5825-11ec-0fc8-cfdd2aaed1f0
# ╟─ddf6aa4e-5825-11ec-3ccf-0bf0a4fde7c2
# ╟─ddf6aa6a-5825-11ec-375f-150fa662a219
# ╟─ddf6aa88-5825-11ec-3a7f-9f5db84b7dab
# ╟─ddf6aaae-5825-11ec-26d8-0df5d8527230
# ╟─ddf6aad8-5825-11ec-0ca4-1d6dc4bfd346
# ╟─ddf6aae0-5825-11ec-0bbb-5b3519721d0c
# ╟─ddf6ab12-5825-11ec-06f1-032b8313ef9e
# ╟─ddf6ab46-5825-11ec-3cea-854b9b0691aa
# ╟─ddf6ab5a-5825-11ec-279b-4528d99c9487
# ╟─ddf6ab84-5825-11ec-2a2d-2b110aa674ac
# ╟─ddf6aba0-5825-11ec-0675-a598765b120a
# ╟─ddf6abc8-5825-11ec-3615-a5f19e27a2a1
# ╟─ddf6abdc-5825-11ec-3082-f10fc57b67d6
# ╟─ddf6abe8-5825-11ec-39b7-2d5bc6fcc1b6
# ╟─ddf6ac16-5825-11ec-1d5d-7d6060174f9c
# ╟─ddf6ac2c-5825-11ec-3b25-63cf4eb630e1
# ╟─ddf6ac54-5825-11ec-0686-618e54299b12
# ╟─ddf6ac86-5825-11ec-3692-d1d183b162cd
# ╟─ddf6aca4-5825-11ec-14cf-0179bb2f3e61
# ╟─ddf6acc2-5825-11ec-1ae4-3fb566a0ffbc
# ╟─ddf6ace0-5825-11ec-0138-431ae050f508
# ╟─ddf6ad1e-5825-11ec-2f23-6954f09c77ce
# ╟─ddf6ad3a-5825-11ec-1f93-f9e1cb1c8158
# ╟─ddf6ad50-5825-11ec-2270-5365e58cfc64
# ╟─ddf6ad58-5825-11ec-2d6e-d1dab4c2f0a1
# ╟─ddf6ad7e-5825-11ec-393d-a14af6ed8c7e
# ╟─ddf6ad8a-5825-11ec-15ae-c5c3a64581ce
# ╟─ddf6adc6-5825-11ec-161e-49d5182ec679
# ╟─ddf6ade2-5825-11ec-35fd-7d56dc82af99
# ╟─ddf6ae20-5825-11ec-0a32-5d9b47a3672a
# ╟─ddf6ae3e-5825-11ec-03ac-d139cc6531fa
# ╟─ddf6ae54-5825-11ec-113a-7b94402d10b7
# ╟─ddf6ae70-5825-11ec-2c15-61d1935b7dd5
# ╟─ddf6ae98-5825-11ec-3310-2737deca1d2c
# ╟─ddf6aeca-5825-11ec-3e73-4b397feb1089
# ╟─ddf6aee6-5825-11ec-30a6-059f93d7d081
# ╟─ddf6aefc-5825-11ec-0435-f72a9030513f
# ╟─ddf6af2e-5825-11ec-1b88-a9c2f8699c6b
# ╟─ddf6af42-5825-11ec-0622-e7a048557932
# ╟─ddf6af88-5825-11ec-0755-378828a79380
# ╟─ddf6afc4-5825-11ec-3ad6-c5f7389dda70
# ╟─ddf6afd8-5825-11ec-33d3-af64817334e2
# ╟─ddf6b00a-5825-11ec-13be-8deb8f2db2af
# ╟─ddf6b028-5825-11ec-0229-a7447cb05a62
# ╟─ddf6b032-5825-11ec-0334-3bd78c45ef61
# ╟─ddf6b04e-5825-11ec-34f2-b90f1293052c
# ╟─ddf6b05a-5825-11ec-217a-117b3496d4a8
# ╟─ddf6b064-5825-11ec-38b1-8ff08f5c005b
# ╟─ddf6b06e-5825-11ec-3b96-0354c7baa7d8
# ╟─ddf6b080-5825-11ec-1bf9-57495a71e7c5
# ╟─ddf6b156-5825-11ec-19a1-394511531c71
# ╟─ddf6b184-5825-11ec-0a47-9b5602b33ac2
# ╟─ddf6b1c2-5825-11ec-2524-d17ba524fa3c
# ╟─ddf6b226-5825-11ec-0258-0f4a4e3f4d4f
# ╟─ddf6b244-5825-11ec-08f0-dfaa5cc21a96
# ╟─ddf6b280-5825-11ec-0cce-cb7db9df3137
# ╟─ddf6b2b2-5825-11ec-2f4a-0ff26245b297
# ╟─ddf6b2c6-5825-11ec-142f-6b3dbdf0c9d3
# ╟─ddf6b2d0-5825-11ec-1e07-fb35d269207b
# ╟─ddf6b2da-5825-11ec-0c47-ff081d194e1e
# ╠═ddf6ba8c-5825-11ec-361e-2f1ed95c1538
# ╟─ddf6babe-5825-11ec-3b3e-49401c4f9d0d
# ╠═ddf6be10-5825-11ec-0c22-511e238705fb
# ╟─ddf7e0ba-5825-11ec-31c1-09a14426ef70
# ╠═ddf7e948-5825-11ec-3a7e-a9eb8046f3aa
# ╟─ddf7e9c2-5825-11ec-301d-15925d1d3811
# ╠═ddf7edc6-5825-11ec-2e18-3b50ad4bb509
# ╟─ddf7edfa-5825-11ec-2d97-a190b653af3f
# ╟─ddf7ee0c-5825-11ec-311b-71ed54756881
# ╟─ddf7ee20-5825-11ec-1f94-27b4f8979105
# ╟─ddf7ee48-5825-11ec-1995-b92a29a25ae3
# ╟─ddf7ee5a-5825-11ec-005c-3f46b44c59d4
# ╟─ddf7ee7a-5825-11ec-2430-0dbd9df424b2
# ╠═ddf7f28a-5825-11ec-28e5-437507b10a09
# ╟─ddf7f2a8-5825-11ec-0830-cf9b2668b00e
# ╠═ddf7f4f6-5825-11ec-1f80-7147a4c1a7db
# ╟─ddf7f51e-5825-11ec-3e4e-73d9a4b6aa00
# ╟─ddf7f546-5825-11ec-3b71-fdc5dacdd5c3
# ╟─ddf7f562-5825-11ec-008c-8731c54330be
# ╟─ddf7f5a0-5825-11ec-0024-6b99e79f1f6b
# ╟─ddf7f5b4-5825-11ec-3daa-ad631a8afcde
# ╟─ddf7f5d2-5825-11ec-21c3-1dbd5da235ca
# ╟─ddf7f5dc-5825-11ec-3539-d98318c746f6
# ╟─ddf7f5f0-5825-11ec-3603-6d1779ca5cea
# ╟─ddfafc8c-5825-11ec-0e2c-b308a56ebaef
# ╟─ddfafd18-5825-11ec-1949-eb767fd26524
# ╟─ddfb073e-5825-11ec-2e11-1f8a7f7dc951
# ╟─ddfb08c6-5825-11ec-2a0f-7b6e8eb759f3
# ╟─ddfb08f8-5825-11ec-0d7a-312c6bfaceab
# ╟─ddfb0920-5825-11ec-1616-ab592abee6a0
# ╟─ddfb093e-5825-11ec-09f7-ed55b6f1d41b
# ╟─ddfb0952-5825-11ec-0c72-352713d919d3
# ╟─ddfb097c-5825-11ec-120b-4b90b5f4c884
# ╟─ddfb0998-5825-11ec-3abb-29a076b60498
# ╟─ddfb09ae-5825-11ec-0f87-bde8bde0487e
# ╟─ddfb09c0-5825-11ec-16e1-6f7e1f4b812e
# ╟─ddfb09f2-5825-11ec-2639-b59b0258fc31
# ╠═ddfb0ede-5825-11ec-0001-fbaf8ce0969c
# ╟─ddfb0f10-5825-11ec-3c32-93d730cb9a10
# ╠═ddfb12f0-5825-11ec-0af6-b9e002e5452d
# ╟─ddfb130c-5825-11ec-00d8-351b84c15ac9
# ╟─ddfb1322-5825-11ec-32a9-858b95172f51
# ╟─ddfb1354-5825-11ec-0032-adfc490e5ad4
# ╟─ddfb1366-5825-11ec-3264-cba88c72a01a
# ╠═ddfb18de-5825-11ec-214b-416793734383
# ╟─ddfb18f0-5825-11ec-01cc-79128b34896b
# ╟─ddfb1910-5825-11ec-3546-6d1da74d2ea2
# ╟─ddfb191a-5825-11ec-2704-8988170f99a6
# ╟─ddfb1954-5825-11ec-2f00-f55bb1a412c1
# ╟─ddfb197e-5825-11ec-0b78-135353061870
# ╟─ddfb1992-5825-11ec-0954-f1080a5994ef
# ╟─ddfc9592-5825-11ec-1881-498729932d47
# ╟─ddfc9678-5825-11ec-0c85-c965da4ac9d7
# ╟─ddfc96aa-5825-11ec-3c01-95dc61f697f4
# ╟─ddfc96be-5825-11ec-0301-8ffe00fb08f9
# ╟─ddfc96fa-5825-11ec-0d93-4d8096eda058
# ╟─ddfc9724-5825-11ec-3476-b317e77e7dfc
# ╟─ddfc9736-5825-11ec-1e91-f1fb973f8eae
# ╟─ddfc9756-5825-11ec-143f-d58b397eedd3
# ╟─ddfc9790-5825-11ec-21a4-972067afadce
# ╟─ddfc97a4-5825-11ec-2645-433d492a459d
# ╟─ddfc97b6-5825-11ec-370b-73daa6858a4d
# ╟─ddfc97c2-5825-11ec-3c02-23515629e08c
# ╟─ddfc97e0-5825-11ec-1b54-4786bf1b1229
# ╟─ddfca726-5825-11ec-0858-4dc35beb62a8
# ╟─ddfca74e-5825-11ec-23f3-0b6a0d1243d3
# ╟─ddfca7a0-5825-11ec-1bd7-6bf6c663c750
# ╟─ddfca7bc-5825-11ec-1db1-79422609abae
# ╟─ddfca7da-5825-11ec-3cac-a110c12f9b03
# ╟─ddfca7ee-5825-11ec-00f8-cd97efe6cc87
# ╟─ddfca804-5825-11ec-259f-e72ebd37176e
# ╟─ddfca852-5825-11ec-38f7-ebfdc9c7e6e6
# ╟─ddfca87a-5825-11ec-1953-11a4c34eb076
# ╟─ddfca8c0-5825-11ec-1b23-41eec39d1127
# ╟─ddfca8d4-5825-11ec-1a52-a9123e88321f
# ╠═ddfcae04-5825-11ec-1f2e-3daa91073e33
# ╟─ddfcae42-5825-11ec-1bfb-9b283609db82
# ╟─ddfcae4c-5825-11ec-190c-0bbf73154dd6
# ╠═ddfcb34c-5825-11ec-3677-6d5296eb9c6a
# ╟─ddfcb372-5825-11ec-0875-af5dc45b9f84
# ╟─ddfcb392-5825-11ec-0b7d-4f77505df0a2
# ╟─ddfcb3a6-5825-11ec-0dba-9d5cfde02a5a
# ╟─ddfcb3b0-5825-11ec-279b-6d507b31c619
# ╠═ddfcb5fe-5825-11ec-23cf-03ae7f3c447d
# ╟─ddfcb610-5825-11ec-0bcd-7fdfccb2a4ca
# ╟─ddfcb626-5825-11ec-3bec-7df615bbdbf1
# ╠═ddfcb93c-5825-11ec-1a0a-21bc84d08fc6
# ╟─ddfcb950-5825-11ec-1066-8be5f30b2608
# ╠═ddfcbc16-5825-11ec-2e7f-f30415e65f60
# ╟─ddfcbc34-5825-11ec-39d2-19bad93e99ce
# ╠═ddfccb16-5825-11ec-2232-dbec5898f1e9
# ╟─ddfccb48-5825-11ec-2fd5-1db2528b8b51
# ╠═ddfccfbc-5825-11ec-3bb8-e99076d50619
# ╟─ddfccff8-5825-11ec-36e9-cd82d03fde26
# ╟─ddfcd05c-5825-11ec-23c2-b5e7ec0d050d
# ╟─ddfcd070-5825-11ec-3062-b34998c886e3
# ╟─ddfcd084-5825-11ec-0ed9-4786939b8993
# ╟─ddfcd0a2-5825-11ec-07e9-ed08533d2899
# ╠═ddfcd4e4-5825-11ec-149a-133b697251b7
# ╟─ddfcd4f8-5825-11ec-15c1-0f5cdcebd771
# ╠═ddfcd886-5825-11ec-0962-e11fc844f5ce
# ╟─ddfcd8e0-5825-11ec-047d-cdc862aca626
# ╟─ddfcd8f4-5825-11ec-1944-2f83a91cf9be
# ╠═ddfcdc5a-5825-11ec-1a74-2f992f3a060a
# ╟─ddfcdc8c-5825-11ec-360e-15262693fbc7
# ╟─ddfcdcdc-5825-11ec-1cb7-8d69324b5200
# ╠═ddfce38a-5825-11ec-14eb-7f6436f2e4ac
# ╟─ddfce3e4-5825-11ec-3b35-b3dbfd26ff92
# ╟─ddfce402-5825-11ec-1d76-2f323b5b8087
# ╟─ddff9de6-5825-11ec-3c51-6d7530982946
# ╟─ddff9e56-5825-11ec-03b8-7f1b8b43ef33
# ╟─ddff9ea4-5825-11ec-29ee-3752424eac79
# ╟─ddffa8ae-5825-11ec-2f8d-83610f687e38
# ╟─ddffa8e0-5825-11ec-20a1-7fb14126793c
# ╟─ddffa8f4-5825-11ec-2f82-1d608fbb44c3
# ╟─ddffa908-5825-11ec-1815-9508f72876a5
# ╟─ddffad9c-5825-11ec-1d08-e9e328048115
# ╟─ddffadae-5825-11ec-002e-31f254bda9c0
# ╟─ddffadc2-5825-11ec-23dd-af3e013deeb8
# ╟─ddffadd6-5825-11ec-133e-21e3f01bed8e
# ╟─ddffb592-5825-11ec-09e0-876a41e99041
# ╟─ddffb5b0-5825-11ec-0b02-fd9e6d097dda
# ╟─ddffb5ba-5825-11ec-1f90-b91c388c48a1
# ╟─ddffb5ce-5825-11ec-0f26-818506d1f53a
# ╟─ddffb61e-5825-11ec-2cae-3f7a3504124e
# ╟─ddffb9a2-5825-11ec-0abc-1b9878398292
# ╟─ddffb9b6-5825-11ec-1d9e-75a564324886
# ╟─ddffb9e0-5825-11ec-0634-25943b858590
# ╟─ddffc60e-5825-11ec-1405-cf0e400857da
# ╟─ddffc62c-5825-11ec-20c3-9710c0730001
# ╟─ddffcdb6-5825-11ec-0225-1b2bbfd98fb7
# ╟─ddffcdd4-5825-11ec-252b-3f3623fdfa03
# ╟─ddffce06-5825-11ec-216a-dd415e2d4bc1
# ╟─ddffd18a-5825-11ec-2107-a98949662fab
# ╟─ddffd1a8-5825-11ec-1249-6b7243d71078
# ╟─ddffd1da-5825-11ec-2b78-315c555895b5
# ╟─ddffd1ee-5825-11ec-37be-fb56c0cf6ccf
# ╟─ddffd4e6-5825-11ec-356a-17b2ac0703e1
# ╟─ddffd506-5825-11ec-3e8e-d5c91ef18999
# ╟─ddffd518-5825-11ec-0bb9-71d0189bf422
# ╟─ddffd52c-5825-11ec-2825-35fc34c1cd0a
# ╟─ddffd82e-5825-11ec-0036-4b056e7b3632
# ╟─ddffd842-5825-11ec-16a3-e94066ea1e43
# ╟─ddffd868-5825-11ec-0a76-5715b428f758
# ╟─ddffdec8-5825-11ec-07de-299a332b7fe0
# ╟─ddffdee6-5825-11ec-2783-f1c2b38fd577
# ╟─ddffdf04-5825-11ec-0f62-b3ef6f24e9f3
# ╟─ddffe6c0-5825-11ec-2f5b-4b50c71f1742
# ╟─ddffe6d4-5825-11ec-0b79-f97e7d0b0ce9
# ╟─ddffe6f2-5825-11ec-1f0e-b7554b5aff85
# ╟─ddffe706-5825-11ec-2e2b-6130563e8b53
# ╟─ddffea7e-5825-11ec-27f1-b1f28a00d1d9
# ╟─ddffea94-5825-11ec-1d8c-8d575bdc95ec
# ╟─ddffeab2-5825-11ec-3cb6-3f4fc302d46c
# ╟─ddffeac6-5825-11ec-3ac6-7da3c719e0e7
# ╟─ddffedd2-5825-11ec-2a86-2115b31291c4
# ╟─ddffede6-5825-11ec-2163-1fecb61a3867
# ╟─ddffee18-5825-11ec-0d41-ef25f6e0e310
# ╟─ddfff8e0-5825-11ec-18c7-adfa0de9a95a
# ╟─ddfff8f4-5825-11ec-08e2-0967f368228f
# ╟─ddfff91c-5825-11ec-0558-dddc13eaaf9f
# ╟─de0000a6-5825-11ec-318c-b955c81df2f7
# ╟─de0000ba-5825-11ec-1217-976a98e990f5
# ╟─de0000e2-5825-11ec-11e8-21c5050a676e
# ╟─de0000f6-5825-11ec-278e-07d5dc76da14
# ╟─de00046e-5825-11ec-3291-ef5cdde40bfd
# ╟─de000484-5825-11ec-2338-9b2bdd178dff
# ╟─de0004a2-5825-11ec-0d56-e521d01943b0
# ╟─de0004ac-5825-11ec-0edb-97d5e5152bf7
# ╟─de000a42-5825-11ec-14cb-895ca1ed802f
# ╟─de000a60-5825-11ec-0b8a-73aa9217b59f
# ╟─de000a80-5825-11ec-3230-f95e09e3de50
# ╟─de000a92-5825-11ec-0199-879fd808a661
# ╟─de001000-5825-11ec-3d13-4f7aabd36cbd
# ╟─de001028-5825-11ec-324b-7bf4d10423cc
# ╟─de001046-5825-11ec-330c-0d8f4ade1e5c
# ╟─de00105a-5825-11ec-1104-f5c28f9a3d7e
# ╟─de001960-5825-11ec-3d97-d189cdacd14d
# ╟─de001974-5825-11ec-0032-cdcf1272a0ea
# ╟─de0022ca-5825-11ec-0d79-771517cdde74
# ╟─de0022de-5825-11ec-1ee3-877d85a04f7c
# ╟─de0022f2-5825-11ec-2423-21fbb49ed9e7
# ╟─de00231a-5825-11ec-0d99-d90de70f3474
# ╟─de002518-5825-11ec-0ae2-c9318ff732ed
# ╟─de002540-5825-11ec-1eb5-c5c1594b8729
# ╟─de0026f8-5825-11ec-25a0-f3358b1bd6aa
# ╟─de002720-5825-11ec-3fbb-673a4d540b55
# ╟─de0031aa-5825-11ec-0378-9da964018002
# ╟─de0031ca-5825-11ec-07f0-31aff5852f02
# ╟─de0031e8-5825-11ec-1ed1-25512a25e4a8
# ╠═de0038d2-5825-11ec-0ca9-a516bb8d9899
# ╟─de003904-5825-11ec-00c0-9b37369d6020
# ╠═de003e4a-5825-11ec-0c62-8be0e2551238
# ╟─de003e7c-5825-11ec-1c55-3905426daca9
# ╟─de0046d8-5825-11ec-013f-dfbde508885c
# ╟─de004702-5825-11ec-31e0-831ea71e201c
# ╟─de005308-5825-11ec-1d56-4b5e10d3bc32
# ╟─de005326-5825-11ec-1276-43069c4e659e
# ╟─de005346-5825-11ec-046a-193b9c440644
# ╟─de0056a8-5825-11ec-0f82-9db26286f7cd
# ╟─de0056d2-5825-11ec-380d-816f0e812f6f
# ╟─de0056da-5825-11ec-3c88-91f4875407eb
# ╟─de0056e6-5825-11ec-0697-9dc8e614b2c7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
