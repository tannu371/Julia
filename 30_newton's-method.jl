### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ a1ac3736-53a1-11ec-0045-27b3b775f407
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
end

# ╔═╡ a1ac4278-53a1-11ec-1343-2dd955005a5e
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	using ImplicitEquations
	fig_size = (600, 400)
	
	# keep until CwJ bumps version
	using Downloads
	function JSXGraph(fname, caption)
	    url = "https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/"
	    content = read(Downloads.download(joinpath(url, fname)), String)
	    CalculusWithJulia.WeaveSupport.JSXGRAPH(content, caption,
	                                            "jsxgraph", "jsxgraph",
	                                            500, 300)
	end
	
	nothing
end

# ╔═╡ a1b8e690-53a1-11ec-1efc-47ed51ff4336
using PlutoUI

# ╔═╡ a1b8e550-53a1-11ec-2bbc-736e3ff65260
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ a1aaa904-53a1-11ec-1d16-c5228a087c00
md"""# Newton's method
"""

# ╔═╡ a1aabf98-53a1-11ec-104c-3f31344b5fc0
md"""This section uses these add-on packages:
"""

# ╔═╡ a1ac70fe-53a1-11ec-206f-fb62e4e7e05a
md"""---
"""

# ╔═╡ a1acb3a2-53a1-11ec-3031-ed5a1baa91e7
md"""The Babylonian method is an algorithm to find an approximate value for $\sqrt{k}$. It was described by the first-century Greek mathematician Hero of [Alexandria](http://en.wikipedia.org/wiki/Babylonian_method).
"""

# ╔═╡ a1acc266-53a1-11ec-397c-ad51c59a83c7
md"""The method starts with some initial guess, called $x_0$. It then applies a formula to produce an improved guess. This is repeated until the improved guess is accurate enough or it is clear the algorithm fails to work.
"""

# ╔═╡ a1acc310-53a1-11ec-0cbf-bbdd1a56a6f5
md"""For the Babylonian method, the next guess, $x_{i+1}$, is derived from the current guess, $x_i$. In mathematical notation, this is the updating step:
"""

# ╔═╡ a1acf038-53a1-11ec-0e44-19d343eaa3d7
md"""```math
x_{i+1} = \frac{1}{2}(x_i + \frac{k}{x_i})
```
"""

# ╔═╡ a1acf088-53a1-11ec-057d-b789f5bce7de
md"""We use this algorithm to approximate the square root of $2$, a value known to the Babylonians.
"""

# ╔═╡ a1acf0f6-53a1-11ec-07df-f5ac3ce7528a
md"""Start with $x$, then form $x/2 + 1/x$, from this again form $x/2 + 1/x$, repeat.
"""

# ╔═╡ a1acf162-53a1-11ec-263e-d59a6bb2cdea
md"""We represent this step using a function
"""

# ╔═╡ a1ad2b52-53a1-11ec-39a3-4f77e63c1f3a
babylon(x) = x/2 + 1/x

# ╔═╡ a1ad2b98-53a1-11ec-3c95-e9f91a0dd8db
md"""Let's look starting with $x = 2$ as a  rational number:
"""

# ╔═╡ a1ad6342-53a1-11ec-33c0-1d0d732a6c68
let
	x₁ = babylon(2//1)
	x₁, x₁^2.0
end

# ╔═╡ a1ad6388-53a1-11ec-1202-75ef81de6316
md"""Our estimate improved from something which squared to $4$ down to something which squares to $2.25$. A big improvement, but there is still more to come. Had we done one more step:
"""

# ╔═╡ a1ad7c60-53a1-11ec-2482-4381acae438e
begin
	x₂ = (babylon ∘ babylon)(2//1)
	x₂, x₂^2.0
end

# ╔═╡ a1ad7cbc-53a1-11ec-3f40-a969c96fd1af
md"""We now see accuracy until the third decimal point.
"""

# ╔═╡ a1ad99e0-53a1-11ec-31a7-41ab33c96d93
begin
	x₃ = (babylon ∘ babylon ∘ babylon)(2//1)
	x₃, x₃^2.0
end

# ╔═╡ a1ad9a92-53a1-11ec-0729-cd0acc302764
md"""This is now accurate to the sixth decimal point.  That is about as far as we, or the Bablyonians, would want to go by hand. Using rational numbers quickly grows out of hand. The next step shows the explosion.
"""

# ╔═╡ a1adf4c4-53a1-11ec-2330-65eb65e6a510
reduce((x,step) -> babylon(x), 1:4, init=2//1)

# ╔═╡ a1adf974-53a1-11ec-2200-5ff805bf96fb
md"""(In the above, we used `reduce` to repeat a function call $4$ times, as an alternative to the composition operation. In this section we show a few styles to do this repetition before introducing a packaged function.)
"""

# ╔═╡ a1adf99c-53a1-11ec-0063-010ef01ab78c
md"""However, with the advent of floating point numbers, the method stays quite manageable:
"""

# ╔═╡ a1ae0cb6-53a1-11ec-104f-8de0e939a0c1
let
	xₙ = reduce((x, step) -> babylon(x), 1:6, init=2.0)
	xₙ, xₙ^2
end

# ╔═╡ a1ae5cfc-53a1-11ec-12a8-356c940c9ae3
md"""We see that the algorithm - to the precision offered by floating point numbers - has resulted in an answer `1.414213562373095`. This answer is an *approximation* to the actual answer. Approximation is necessary, as $\sqrt{2}$ is an irrational number and so can never be exactly represented in floating point. That being said, we see that the value of $f(x)$ is accurate to the last decimal place, so our approximation is very close and is achieved in a few steps.
"""

# ╔═╡ a1ae8d30-53a1-11ec-1ff6-f1d344a9c514
md"""## Newton's generalization
"""

# ╔═╡ a1ae8e50-53a1-11ec-0dda-e1cb82e0711d
md"""Let $f(x) = x^3 - 2x -5$. The value of 2 is almost a zero, but not quite, as $f(2) = -1$. We can check that there are no *rational* roots. Though there is a method to solve the cubic it may be difficult to compute and will not be as generally applicable as some algorithm like the Babylonian method to produce an approximate answer.
"""

# ╔═╡ a1ae8eb4-53a1-11ec-205a-69b2e0d552e8
md"""Is there some generalization to the Babylonian method?
"""

# ╔═╡ a1aea87e-53a1-11ec-3d37-a7e1919a474c
md"""We know that the tangent line is a good approximation to the function at the point. Looking at this graph gives a hint as to an algorithm:
"""

# ╔═╡ a1aecf66-53a1-11ec-2753-ff3213d3ae56
let
	f(x) = x^3 - 2x - 5
	fp(x) = 3x^2 - 2
	c = 2
	p = plot(f, 1.75, 2.25, legend=false)
	plot!(x->f(2) + fp(2)*(x-2))
	plot!(zero)
	scatter!(p, [c], [f(c)], color=:orange, markersize=3)
	p
end

# ╔═╡ a1aecffc-53a1-11ec-1ea7-21a902fd0995
md"""The tangent line and the function nearly agree near $2$. So much so, that the intersection point of the tangent line with the $x$ axis nearly hides the actual zero of $f(x)$ that is near $2.1$.
"""

# ╔═╡ a1aed01a-53a1-11ec-1d8e-e5e51a3d4568
md"""That is, it seems that the intersection of the tangent line and the $x$ axis should be an improved approximation for the zero of the function.
"""

# ╔═╡ a1aed0c4-53a1-11ec-0efc-c95d2427d432
md"""Let $x_0$ be $2$, and $x_1$ be the intersection point of the tangent line at $(x_0, f(x_0))$ with the $x$ axis. Then by the definition of the tangent line:
"""

# ╔═╡ a1aed132-53a1-11ec-1067-37c7349beb4a
md"""```math
f'(x_0) = \frac{\Delta y }{\Delta x} = \frac{f(x_0)}{x_0 - x_1}.
```
"""

# ╔═╡ a1aed150-53a1-11ec-189e-7f219d54e83a
md"""This can be solved for $x_1$ to give $x_1 = x_0 - f(x_0)/f'(x_0)$. In general, if we had $x_i$ and used the intersection point of the tangent line to produce $x_{i+1}$ we would have Newton's method:
"""

# ╔═╡ a1aed1a0-53a1-11ec-05ec-f9c905e75b3a
md"""```math
x_{i+1} = x_i - \frac{f(x_i)}{f'(x_i)}.
```
"""

# ╔═╡ a1aee3e8-53a1-11ec-283b-cfcc8870b720
md"""Using automatic derivatives, as brought in with the `CalculusWithJulia` package, we can implement this algorithm.
"""

# ╔═╡ a1aee424-53a1-11ec-1ca7-07108617d020
md"""The algorithm above starts at $2$ and then becomes:
"""

# ╔═╡ a1af0f80-53a1-11ec-276b-f3a4fc2d3e62
begin
	f(x) = x^3 - 2x - 5
	x0 = 2.0
	x1 = x0 - f(x0) / f'(x0)
end

# ╔═╡ a1af0fbc-53a1-11ec-3b7f-7dddfc446e14
md"""We can see we are closer to a zero:
"""

# ╔═╡ a1af65c0-53a1-11ec-1661-cdcbafa52333
f(x0), f(x1)

# ╔═╡ a1af65fc-53a1-11ec-3b8a-3b18ae09ab84
md"""Trying again, we have
"""

# ╔═╡ a1af6f5c-53a1-11ec-1321-353e4b7e7dfb
begin
	x2 = x1 - f(x1)/ f'(x1)
	x2, f(x2), f(x1)
end

# ╔═╡ a1af6f78-53a1-11ec-3a53-07df487276e0
md"""And again:
"""

# ╔═╡ a1af7664-53a1-11ec-3db5-71bd8f62766c
begin
	x3 = x2 - f(x2)/ f'(x2)
	x3, f(x3), f(x2)
end

# ╔═╡ a1af7b6e-53a1-11ec-1689-e94b54750237
begin
	x4 = x3 - f(x3)/ f'(x3)
	x4, f(x4), f(x3)
end

# ╔═╡ a1af7be6-53a1-11ec-217b-9f96a5b804c4
md"""We see now that $f(x_4)$ is within machine tolerance of $0$, so we call $x_4$ an *approximate zero* of $f(x)$.
"""

# ╔═╡ a1afe1c6-53a1-11ec-27de-934d0dc4879b
md"""> Newton's method. Let $x_0$ be an initial guess for a zero of $f(x)$. Iteratively define $x_{i+1}$ in terms of the just generated $x_i$ by: $x_{i+1} = x_i - f(x_i) / f'(x_i)$. Then for reasonable functions and reasonable initial guesses, the sequence of points converges to a zero of $f$.

"""

# ╔═╡ a1afe20c-53a1-11ec-31c5-4d10c9fa6ac6
md"""On the computer, we know that actual convergence will likely never occur, but accuracy to a certain tolerance can often be achieved.
"""

# ╔═╡ a1afe23e-53a1-11ec-315e-0fb7d3e50e75
md"""In the example above, we kept track of the previous values. This is unnecessary if only the answer is sought. In that case, the update step could use the same variable. Here we use `reduce`:
"""

# ╔═╡ a1affcf6-53a1-11ec-2d4f-e78f83ce93da
let
	xₙ = reduce((x, step) -> x - f(x)/f'(x), 1:4, init=2)
	xₙ, f(xₙ)
end

# ╔═╡ a1affd3e-53a1-11ec-1a36-951614f7c0f9
md"""In practice, the algorithm is implemented not by repeating the update step a fixed number of times, rather by repeating the step until either we converge or it is clear we won't converge. For good guesses and most functions, convergence happens quickly.
"""

# ╔═╡ a1b028fc-53a1-11ec-0fef-f18e20560911
note("""

----

Newton looked at this same example in 1699 (B.T. Polyak, *Newton's
method and its use in optimization*, European Journal of Operational
Research. 02/2007; 181(3):1086-1096.) though his technique was
slightly different as he did not use the derivative, *per se*, but
rather an approximation based on the fact that his function was a
polynomial (though identical to the derivative). Raphson (1690)
proposed the general form, hence the usual name of the Newton-Raphson
method.


""")

# ╔═╡ a1b02992-53a1-11ec-2b43-230a8c5c81f2
md"""## Examples
"""

# ╔═╡ a1b078fc-53a1-11ec-12c4-3395eaf74580
md"""##### Example: visualizing convergence
"""

# ╔═╡ a1b079ba-53a1-11ec-11fd-a3a54d1a3794
md"""This  graphic demonstrates the method and the rapid convergence:
"""

# ╔═╡ a1b25488-53a1-11ec-10ab-a75012a25c02
begin
	function newtons_method_graph(n, f, a, b, c)
	
	    xstars = [c]
	    xs = [c]
	    ys = [0.0]
	
	    plt = plot(f, a, b, legend=false, size=fig_size)
	    plot!(plt, [a, b], [0,0], color=:black)
	
	
	    ts = range(a, stop=b, length=50)
	    for i in 1:n
	        x0 = xs[end]
	        x1 = x0 - f(x0)/D(f)(x0)
	        push!(xstars, x1)
	            append!(xs, [x0, x1])
	        append!(ys, [f(x0), 0])
	    end
	    plot!(plt, xs, ys, color=:orange)
	    scatter!(plt, xstars, 0*xstars, color=:orange, markersize=5)
	    plt
	end
	nothing
end

# ╔═╡ a1b29b5a-53a1-11ec-2512-6d339f364e04
let
	### {{{newtons_method_example}}}
	
	caption = """
	
	Illustration of Newton's Method converging to a zero of a function.
	
	"""
	n = 6
	
	fn, a, b, c = x->log(x), .15, 2, .2
	
	anim = @animate for i=1:n
	    newtons_method_graph(i-1, fn, a, b, c)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a1b29c54-53a1-11ec-2cf8-9b3cad532397
md"""##### Example: numeric not algebraic
"""

# ╔═╡ a1b29ccc-53a1-11ec-0696-b7b5cd25d21b
md"""For the function $f(x) = \cos(x) - x$, we see that SymPy can not solve symbolically for a zero:
"""

# ╔═╡ a1b2e6e6-53a1-11ec-24df-b1b6ffa93127
begin
	@syms x::real
	solve(cos(x) - x, x)
end

# ╔═╡ a1b2e72c-53a1-11ec-3489-3d099cfccf2d
md"""We can find a numeric solution, even though there is no closed-form answer. Here we try Newton's method:
"""

# ╔═╡ a1b30428-53a1-11ec-0c21-67e49d65cffe
let
	f(x) = cos(x) - x
	x = .5
	x = x - f(x)/f'(x)  # 0.7552224171056364
	x = x - f(x)/f'(x)  # 0.7391416661498792
	x = x - f(x)/f'(x)  # 0.7390851339208068
	x = x - f(x)/f'(x)  # 0.7390851332151607
	x = x - f(x)/f'(x)
	x, f(x)
end

# ╔═╡ a1b30522-53a1-11ec-2baa-c36434777092
md"""To machine tolerance the answer is a zero, even though the exact answer is irrational and all finite floating point values can be represented as rational numbers.
"""

# ╔═╡ a1b30540-53a1-11ec-1aed-2b078337ed3d
md"""##### Example
"""

# ╔═╡ a1b31c10-53a1-11ec-1bde-4198e52ddd40
md"""Use Newton's method to find the *largest* real solution to $e^x = x^6$.
"""

# ╔═╡ a1b31c7e-53a1-11ec-026f-93f4041538bb
md"""A plot shows us roughly where the value lies:
"""

# ╔═╡ a1b32200-53a1-11ec-2711-5b016d27c61e
let
	f(x) = exp(x)
	g(x) = x^6
	plot(f, 0, 25, label="f")
	plot!(g, label="g")
end

# ╔═╡ a1b32232-53a1-11ec-3064-8f5516583c6a
md"""Clearly by $20$ the two paths diverge. We know exponentials eventually grow faster than powers, and this is seen in the graph.
"""

# ╔═╡ a1b32400-53a1-11ec-3f33-21911cf1d6f9
md"""To use Newton's method to find the intersection point. Stop when the increment $f(x)/f'(x)$ is smaller than `1e-4`. We need to turn the solution to an equation into a value where a function is $0$. Just moving the terms to one side of the equals sign gives $e^x - x^6 = 0$, or the $x$ we seek is a solution to $h(x)=0$ with $h(x) = e^x - x^6$.
"""

# ╔═╡ a1b3a614-53a1-11ec-028d-3f58dfa09f8a
let
	with_terminal() do
		h(x) = exp(x) - x^6
		x = 20
		for step in 1:10
		    delta = h(x)/h'(x)
		    x = x - delta
		    @show step, x, delta
		end
	end
end

# ╔═╡ a1b3a73e-53a1-11ec-11cd-a798e0ad494e
md"""So it takes $8$ steps to get an increment that small and about `10` steps to get to full convergence.
"""

# ╔═╡ a1b3a82e-53a1-11ec-3639-ff88de270912
md"""##### Example division as multiplication
"""

# ╔═╡ a1b3bd46-53a1-11ec-229d-c5896202a5da
md"""[Newton-Raphson Division](http://tinyurl.com/kjj9w92) is a means to divide by multiplying.
"""

# ╔═╡ a1b3bdb4-53a1-11ec-0dc4-e5318689ca8f
md"""Why would you want to do that? Well, even for computers division is harder (read slower) than multiplying. The trick is that $p/q$ is simply $p \cdot (1/q)$, so finding a means to compute a reciprocal by multiplying will reduce division to multiplication.  (This trick is used by [yeppp](http://www.yeppp.info/resources/ppam-presentation.pdf), a high performance library for computational mathematics.)
"""

# ╔═╡ a1b3be36-53a1-11ec-327f-e726429ab2c6
md"""Well suppose we have $q$, we could try to use Newton's method to find $1/q$, as it is a solution to $f(x) = x - 1/q$. The Newton update step simplifies to:
"""

# ╔═╡ a1b3beb8-53a1-11ec-108d-7b0feafa6948
md"""```math
x - f(x) / f'(x) \quad\text{or}\quad x - (x - 1/q)/ 1 = 1/q
```
"""

# ╔═╡ a1b3bece-53a1-11ec-3990-cde0d14510c5
md"""That doesn't really help, as Newton's method is just $x_{i+1} = 1/q$. That is, it just jumps to the answer, the one we want to compute by some other means!
"""

# ╔═╡ a1b3bf6c-53a1-11ec-1fb4-3b48d1cedba0
md"""Trying again, we simplify the update step for a related function: $f(x) = 1/x - q$ with $f'(x) = -1/x^2$ and then one step of the process is:
"""

# ╔═╡ a1b3bf80-53a1-11ec-0310-7b91526d747c
md"""```math
x_{i+1} = x_i - (1/x_i - q)/(-1/x_i^2) = -qx^2_i + 2x_i.
```
"""

# ╔═╡ a1b3bfee-53a1-11ec-3346-4d81e84c8d20
md"""Now for $q$ in the interval $[1/2, 1]$ we want to get a *good* initial guess. Here is a claim. We can use $x_0=48/17 - 32/17 \cdot q$. Let's check graphically that this is a reasonable initial approximation to $1/q$:
"""

# ╔═╡ a1b3cb24-53a1-11ec-37ec-a53549523138
let
	plot(q -> 1/q, 1/2, 1, label="1/q")
	plot!(q -> 1/17 * (48 - 32q), label="linear approximation")
end

# ╔═╡ a1b3cb60-53a1-11ec-1f47-691d8ee31709
md"""It can be shown that we have for any $q$ in $[1/2, 1]$ with initial guess $x_0 = 48/17 - 32/17\cdot q$ that Newton's method will converge to 16 digits in no more than this many steps:
"""

# ╔═╡ a1b3cbba-53a1-11ec-2f76-3fa91705e581
md"""```math
\log_2(\frac{53 + 1}{\log_2(17)}).
```
"""

# ╔═╡ a1b3fa54-53a1-11ec-1be9-95093a2461cb
begin
	a = log2((53 + 1)/log2(17))
	ceil(Integer, a)
end

# ╔═╡ a1b3fa9a-53a1-11ec-043c-0f24d1fd1f41
md"""That is $4$ steps suffices.
"""

# ╔═╡ a1b3fb08-53a1-11ec-2b17-91296002d010
md"""For $q = 0.80$, to find $1/q$ using the above we have
"""

# ╔═╡ a1b3ff88-53a1-11ec-378c-c9555d0c668a
let
	q = 0.80
	x = (48/17) - (32/17)*q
	x = -q*x*x + 2*x
	x = -q*x*x + 2*x
	x = -q*x*x + 2*x
	x = -q*x*x + 2*x
end

# ╔═╡ a1b3ffe8-53a1-11ec-1f67-b5693025111b
md"""This method has basically $18$ multiplication and addition operations for one division, so it naively would seem slower, but timing this shows the method is competitive with a regular division.
"""

# ╔═╡ a1b4004e-53a1-11ec-3143-b98ff000a852
md"""## Wrapping in a function
"""

# ╔═╡ a1b400d0-53a1-11ec-2b65-55bf3317d28d
md"""In the previous examples, we saw fast convergence, guaranteed converge  in $4$ steps, and an example where $8$ steps were needed to get the requested level of approximation. Newton's method usually converges quickly, but may converge slowly, and may not converge at all. Automating the task to avoid repeatedly running the update step is a task best done by the computer.
"""

# ╔═╡ a1b40134-53a1-11ec-0dec-53d722b87a3f
md"""The `while` loop is a good way to repeat commands until some condition is met. With this, we present a simple function implementing Newton's method, we iterate until the update step gets really small (the `delta`) or the convergence takes more than 50 steps. (There are other better choices that could be used to determine when the algorithm should stop, these are just easy to understand)
"""

# ╔═╡ a1b4675a-53a1-11ec-389e-a1e6899b19ef
function nm(f, fp, x0)
  tol = 1e-14
  ctr = 0
  delta = Inf
  while (abs(delta) > tol) && (ctr < 50)
    delta = f(x0)/fp(x0)
    x0 = x0 - delta
    ctr = ctr + 1
  end

  ctr < 50 ? x0 : NaN
end

# ╔═╡ a1b46796-53a1-11ec-084e-0b7c813d1853
md"""##### Examples
"""

# ╔═╡ a1b47aec-53a1-11ec-3a7d-e1912b76fbbf
md"""  * Find a zero of $\sin(x)$ starting at $x_0=3$:
"""

# ╔═╡ a1b47df6-53a1-11ec-3a21-cb710e5bd2e6
nm(sin, cos, 3)

# ╔═╡ a1b47e70-53a1-11ec-365d-5d79f7614d31
md"""This is an approximation for $\pi$, that historically found use, as the convergence is fast.
"""

# ╔═╡ a1b47ecc-53a1-11ec-33b0-c16a0cbb5f3f
md"""  * Find a solution to $x^5 =  5^x$ near $2$:
"""

# ╔═╡ a1b47f5e-53a1-11ec-3499-c17aa1892a70
md"""Writing a function to handle this, we have:
"""

# ╔═╡ a1b4955e-53a1-11ec-23e9-5f21f0b7662e
k(x) = x^5 - 5^x

# ╔═╡ a1b495cc-53a1-11ec-27b3-b7904578f6cb
md"""We could find the derivative by hand, but use the automatic one instead:
"""

# ╔═╡ a1b4c86c-53a1-11ec-075f-ef1542e95962
begin
	alpha = nm(k, k', 2)
	alpha, f(alpha)
end

# ╔═╡ a1b4e2ea-53a1-11ec-2599-f70d23f86a86
md"""### Functions in the Roots package
"""

# ╔═╡ a1b4e40a-53a1-11ec-156d-6fcd25fbb40c
md"""Typing in the `nm` function might be okay once, but would be tedious if it was needed each time. Besides, it isn't as robust to different inputs as possible. The `Roots` package provides a `Newton` method for `find_zero`.
"""

# ╔═╡ a1b4e432-53a1-11ec-1f6c-c9856061a8f6
md"""To use a different method with `find_zero`, the calling pattern is `find_zero(f, x, M)` where `f` represent the function(s), `x` the initial point(s), and `M` the method. Here we have:
"""

# ╔═╡ a1b4fa3c-53a1-11ec-2973-cd5530ec37bd
find_zero((sin, cos), 3, Roots.Newton())

# ╔═╡ a1b4faa8-53a1-11ec-2b29-b7efe1ec087b
md"""Or, if a derivative is not specified, one can be computed using automatic differentiation:
"""

# ╔═╡ a1b4fecc-53a1-11ec-0a10-11ae718b53da
let
	f(x) = sin(x)
	find_zero((f, f'), 2, Roots.Newton())
end

# ╔═╡ a1b4ff44-53a1-11ec-3c38-4bd3b167e28e
md"""Outside of `Pluto`, the argument `verbose=true` will force a print out of a message summarizing the convergence and showing each step. Within `Pluto`, we need to introduce a `Tracks` object and display that after the algorithm is run:
"""

# ╔═╡ a1b50494-53a1-11ec-14df-97e140b93f95
let
	f(x) = exp(x) - x^4
	tracks = Roots.Tracks()
	find_zero((f,f'), 8, Roots.Newton(); tracks=tracks)
	tracks
end

# ╔═╡ a1b50552-53a1-11ec-1ed1-31f733aa017d
md"""##### Example: intersection of two graphs
"""

# ╔═╡ a1b50584-53a1-11ec-1a7f-abcc01da5d96
md"""Find the intersection point between $f(x) = \cos(x)$ and $g(x) = 5x$ near $0$.
"""

# ╔═╡ a1b50638-53a1-11ec-168a-c506c7424283
md"""We have Newton's method to solve for zeros of $f(x)$, i.e. when $f(x) = 0$. Here we want to solve for $x$ with $f(x) = g(x)$. To do so, we make a new function $h(x) = f(x) - g(x)$, that is $0$ when $f(x)$ equals $g(x)$:
"""

# ╔═╡ a1b509ee-53a1-11ec-3874-b94e51563bd6
let
	f(x) = cos(x)
	g(x) = 5x
	h(x) = f(x) - g(x)
	x0 = find_zero((h,h'), 0, Roots.Newton())
	x0, h(x0), f(x0), g(x0)
end

# ╔═╡ a1b50a20-53a1-11ec-1ff4-a329b3272314
md"""##### Example: Finding  $c$ in Rolle's Theorem
"""

# ╔═╡ a1b50a70-53a1-11ec-001c-57d9102ef15f
md"""The function $r(x) = \sqrt{1 - \cos(x^2)^2}$ has a zero at $0$ and one at $a$ near $1.77$.
"""

# ╔═╡ a1b5226e-53a1-11ec-2a67-ed68f6f396bb
begin
	r(x) = sqrt(1 - cos(x^2)^2)
	plot(r, 0, 1.77)
end

# ╔═╡ a1b522a8-53a1-11ec-194c-05ec4cc93c14
md"""As $f(x)$ is differentiable between $0$ and $a$, Rolle's theorem says there will be value where the derivative is $0$. Find that value.
"""

# ╔═╡ a1b522f8-53a1-11ec-3d60-35534739e894
md"""This value will be a zero of the derivative. A graph shows it should be near $1.2$, so we use that as a starting value to get the answer:
"""

# ╔═╡ a1b529f6-53a1-11ec-027e-bd3763c59bb2
find_zero((r',r''), 1.2, Roots.Newton())

# ╔═╡ a1b52a64-53a1-11ec-0416-838558d2b622
md"""## Convergence
"""

# ╔═╡ a1b52ada-53a1-11ec-2ed7-258885b24015
md"""Newton's method is famously known to have "quadratic convergence." What does this mean? Let the error in the $i$th step be called $e_i = x_i - \alpha$. Then Newton's method satisfies a bound of the type:
"""

# ╔═╡ a1b52b36-53a1-11ec-26cd-c1d9a26e1210
md"""```math
\lvert e_{i+1} \rvert \leq M_i \cdot e_i^2.
```
"""

# ╔═╡ a1b52b7c-53a1-11ec-20e6-8b1e5bf4452d
md"""If $M$ were just a constant and we suppose $e_0 = 10^{-1}$ then $e_1$ would be less than $M 10^{-2}$ and $e_2$ less than $M^2 10^{-4}$, $e_3$ less than $M^3 10^{-8}$ and $e_4$ less than $M^4 10^{-16}$ which for $M=1$ is basically the machine precision. That is for some problems, with a good initial guess it will take around $4$ or so steps to converge.
"""

# ╔═╡ a1b52be2-53a1-11ec-14e1-7985970fe678
md"""Let $\alpha$ be the zero of $f$ to be approximated. Assume
"""

# ╔═╡ a1b52ca8-53a1-11ec-02ee-252cdf0c66bb
md"""  * The function $f$ has at continuous second derivative in a neighborhood of $\alpha$.
  * The value $f'(\alpha)$ is *non-zero* in the neighborhood of $\alpha$.
"""

# ╔═╡ a1b52cee-53a1-11ec-187b-572e0d45b578
md"""Then this linearization holds at each $x_i$ in the above neighborhood:
"""

# ╔═╡ a1b52d02-53a1-11ec-1fbf-2716631e70d4
md"""```math
f(x) = f(x_i) + f'(x_i) \cdot (x - x_i) + \frac{1}{2} f''(\xi) \cdot (x-x_i)^2.
```
"""

# ╔═╡ a1b52d18-53a1-11ec-2b37-593a7361c92a
md"""The value $\xi$ is from the mean value theorem and is between $x$ and $x_i$.
"""

# ╔═╡ a1b52d98-53a1-11ec-0d25-d38322b00dec
md"""Dividing by $f'(x_i)$ and setting $x=\alpha$ (as $f(\alpha)=0$) leaves
"""

# ╔═╡ a1b52ddc-53a1-11ec-2036-7f278dcff301
md"""```math
0 = \frac{f(x_i)}{f'(x_i)} + (\alpha-x_i) + \frac{1}{2}\cdot \frac{f''(\xi)}{f'(x_i)} \cdot (\alpha-x_i)^2.
```
"""

# ╔═╡ a1b52e38-53a1-11ec-0320-b73db6d1824d
md"""For this value, we have
"""

# ╔═╡ a1b52e4e-53a1-11ec-169f-879ea1e8e7c4
md"""```math
\begin{align*}
x_{i+1} - \alpha
&= \left(x_i  - \frac{f(x_i)}{f'(x_i)}\right) - \alpha\\
&= \left(x_i - \alpha \right) - \frac{f(x_i)}{f'(x_i)}\\
&= (x_i - \alpha) + \left(
(\alpha - x_i) + \frac{1}{2}\frac{f''(\xi) \cdot(\alpha - x_i)^2}{f'(x_i)}
\right)\\
&=  \frac{1}{2}\frac{f''(\xi)}{f'(x_i)} \cdot(x_i - \alpha)^2.
\end{align*}
```
"""

# ╔═╡ a1b52e80-53a1-11ec-1a2c-59b378168382
md"""That is
"""

# ╔═╡ a1b52e88-53a1-11ec-3eb6-b3fa397f872d
md"""```math
e_{i+1} = \frac{1}{2}\frac{f''(\xi)}{f'(x_i)} e_i^2.
```
"""

# ╔═╡ a1b52eb2-53a1-11ec-339d-8bd1af9813ee
md"""This convergence to $\alpha$ will be quadratic *if*:
"""

# ╔═╡ a1b53130-53a1-11ec-1e0c-f7541ccf751f
md"""  * The initial guess $x_0$ is not too far from $\alpha$, so $e_0$ is managed.
  * The derivative at $\alpha$ is not too close to $0$, hence, by continuity $f'(x\_i`)$ is not too close to $0$. (As it appears in the denominator). That is, the function can't be too flat, which should make sense, as then the tangent line is nearly parallel to the $x$ axis and would intersect far away.
  * The function $f$ has a continuous second derivative at $\alpha$.
  * The second derivative is not too big (in absolute value) near $\alpha$. A large second derivative means the function is very concave, which means it is "turning" a lot. In this case, the function turns away from the tangent line quickly, so the tangent line's zero is not necessarily a better approximation to the actual zero, $\alpha$.
"""

# ╔═╡ a1b54d64-53a1-11ec-1fb8-4ba631b207c1
note("""
The basic tradeoff: methods like Newton's are faster than the
bisection method in terms of function calls, but are not guaranteed to
converge, as the bisection method is.
""")

# ╔═╡ a1b54dde-53a1-11ec-3284-671a01858925
md"""What can go wrong when one of these isn't the case is illustrated next:
"""

# ╔═╡ a1b54e90-53a1-11ec-1dd5-cbbe597486ea
md"""### Poor initial step
"""

# ╔═╡ a1b55962-53a1-11ec-0774-295c6866cbc7
let
	### {{{newtons_method_poor_x0}}}
	caption = """
	
	Illustration of Newton's Method converging to a zero of a function,
	but slowly as the initial guess, is very poor, and not close to the
	zero. The algorithm does converge in this illustration, but not quickly and not to the nearest root from
	the initial guess.
	
	"""
	
	fn, a, b, c = x ->  sin(x) - x/4, -15, 20, 2pi
	
	n = 20
	anim = @animate for i=1:n
	    newtons_method_graph(i-1, fn, a, b, c)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 2)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a1b57c62-53a1-11ec-3087-812d2bb27fb9
let
	# {{{newtons_method_flat}}}
	caption = L"""
	
	Illustration of Newton's method failing to coverge as for some $x_i$,
	$f'(x_i)$ is too close to ``0``. In this instance after a few steps, the
	algorithm just cycles around the local minimum near $0.66$. The values
	of $x_i$ repeat in the pattern: $1.0002, 0.7503, -0.0833, 1.0002,
	\dots$. This is also an illustration of a poor initial guess. If there
	is a local minimum or maximum between the guess and the zero, such
	cycles can occur.
	
	"""
	
	fn, a, b, c = x -> x^5 - x + 1, -1.5, 1.4, 0.0
	
	n=7
	anim = @animate for i=1:n
	    newtons_method_graph(i-1, fn, a, b, c)
	end
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a1b57cda-53a1-11ec-39cb-17d6ef463cd6
md"""### The second derivative is too big
"""

# ╔═╡ a1b587c2-53a1-11ec-21cf-59b10be8af24
let
	# {{{newtons_method_cycle}}}
	
	fn, a, b, c, = x -> abs(x)^(0.49),  -2, 2, 1.0
	caption = L"""
	
	Illustration of Newton's Method not converging. Here the second
	derivative is too big near the zero - it blows up near $0$ - and the
	convergence does not occur. Rather the iterates increase in their
	distance from the zero.
	
	"""
	
	n=10
	anim = @animate for i=1:n
	    newtons_method_graph(i-1, fn, a, b, c)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 2)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a1b587e8-53a1-11ec-3803-a1a3f59c1cd5
md"""### The tangent line at some xᵢ is flat
"""

# ╔═╡ a1b5be16-53a1-11ec-239c-9930c371f036
let
	# {{{newtons_method_wilkinson}}}
	
	caption = L"""
	
	The function $f(x) = x^{20} - 1$ has two bad behaviours for Newton's
	method: for $x < 1$ the derivative is nearly $0$ and for $x>1$ the
	second derivative is very big. In this illustration, we have an
	initial guess of $x_0=8/9$. As the tangent line is fairly flat, the
	next approximation is far away, $x_1 = 1.313\dots$. As this guess is
	is much bigger than $1$, the ratio $f(x)/f'(x) \approx
	x^{20}/(20x^{19}) = x/20$, so $x_i - x_{i-1} \approx (19/20)x_i$
	yielding slow, linear convergence until $f''(x_i)$ is moderate. For
	this function, starting at $x_0=8/9$ takes 11 steps, at $x_0=7/8$
	takes 13 steps, at $x_0=3/4$ takes 55 steps, and at $x_0=1/2$ it takes
	$204$ steps.
	
	"""
	
	
	fn,a,b,c = x -> x^20 - 1,  .7, 1.4, 8/9
	n = 10
	
	anim = @animate for i=1:n
	    newtons_method_graph(i-1, fn, a, b, c)
	end
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ a1b5d5a4-53a1-11ec-174b-0376695ab7e7
md"""###### Example
"""

# ╔═╡ a1b5d6b2-53a1-11ec-028e-032b486b30d8
md"""Suppose $\alpha$ is a simple zero for $f(x)$.  (The value $\alpha$ is a zero of multiplicity $k$ if $f(x) = (x-\alpha)^kg(x)$ where $g(\alpha)$ is not zero. A simple zero has multiplicity $1$. If $f'(\alpha) \neq 0$ and the second derivative exists, then a zero $\alpha$ will be simple.)  Around $\alpha$, quadratic convergence should apply. However, consider the function $g(x) = f(x)^k$ for some integer $k \geq 2$. Then $\alpha$ is still a zero, but the derivative of $g$ at $\alpha$ is zero, so the tangent line is basically flat. This will slow the convergence up. We can see that the update step $g'(x)/g(x)$ becomes $(1/k) f'(x)/f(x)$, so an extra factor is introduced.
"""

# ╔═╡ a1b5d6fa-53a1-11ec-0b2e-9f4f28b0e1ff
md"""The calculation that produces the quadratic convergence now becomes:
"""

# ╔═╡ a1b5d7ca-53a1-11ec-1027-81edbd8ec69e
md"""```math
x_{i+1} - \alpha = (x_i - \alpha) - \frac{1}{k}(x_i-\alpha + \frac{f''(\xi)}{2f'(x_i)}(x_i-\alpha)^2) =
\frac{k-1}{k} (x_i-\alpha) + \frac{f''(\xi)}{2kf'(x_i)}(x_i-\alpha)^2.
```
"""

# ╔═╡ a1b5d7f0-53a1-11ec-02db-47cb1f3a3a53
md"""As $k > 1$, the $(x_i - \alpha)$ term dominates, and we see the convergence is linear with $\lvert e_{i+1}\rvert \approx (k-1)/k \lvert e_i\rvert$.
"""

# ╔═╡ a1b5d84c-53a1-11ec-3ebb-7fcb438e0296
md"""## Questions
"""

# ╔═╡ a1b5d862-53a1-11ec-2857-4d823c6bc45c
md"""###### Question
"""

# ╔═╡ a1b5d8ec-53a1-11ec-2fb4-d3db7a858ab6
md"""Look at this graph with $x_0$ marked with a point:
"""

# ╔═╡ a1b6056a-53a1-11ec-38e9-1f4dc217664e
let
	import SpecialFunctions: airyai
	p = plot(airyai, -3.3, 0, legend=false);
	plot!(p, zero, -3.3, 0);
	scatter!(p, [-2.8], [0], color=:orange, markersize=5);
	annotate!(p, [(-2.8, 0.2, "x₀")])
	p
end

# ╔═╡ a1b605b0-53a1-11ec-1ced-b73d63b89c45
md"""If one step of Newton's method was used, what would be the value of $x_1$?
"""

# ╔═╡ a1b62360-53a1-11ec-0d25-039e4adaae5f
let
	choices = ["``-2.224``", "``-2.80``",  "``-0.020``", "``0.355``"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b623d8-53a1-11ec-37f3-cf022504ba82
md"""###### Question
"""

# ╔═╡ a1b624b4-53a1-11ec-247a-911e328a4a97
md"""Look at this graph of some increasing, concave up $f(x)$ with initial point $x_0$ marked. Let $\alpha$ be the zero.
"""

# ╔═╡ a1b62de2-53a1-11ec-2875-f1195ad91f93
let
	p = plot(x -> x^2 - 2, .75, 2.2, legend=false);
	plot!(p, zero,                   color=:green);
	scatter!(p, [1],[0],             color=:orange, markersize=5);
	annotate!(p, [(1,.25, "x₀"), (sqrt(2), .2, "α")]);
	p
end

# ╔═╡ a1b62e0a-53a1-11ec-31d5-e563db89b283
md"""What can be said about $x_1$?
"""

# ╔═╡ a1b634fe-53a1-11ec-26d4-b90d66848e5c
let
	choices = [
	L"It must be $x_1 > \alpha$",
	L"It must be $x_1 < x_0$",
	L"It must be $x_0 < x_1 < \alpha$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a1b63530-53a1-11ec-281e-9dba7b727d04
md"""---
"""

# ╔═╡ a1b635b2-53a1-11ec-1d8a-c7c3988e1562
md"""Look at this graph of some increasing, concave up $f(x)$ with initial point $x_0$ marked. Let $\alpha$ be the zero.
"""

# ╔═╡ a1b63ede-53a1-11ec-36ad-d5f19234e9fc
let
	p = plot(x -> x^2 - 2, .75, 2.2, legend=false);
	plot!(p, zero, .75, 2.2, color=:green);
	scatter!(p, [2],[0], color=:orange, markersize=5);
	annotate!(p, [(2,.25, "x₀"), (sqrt(2), .2, "α")]);
	p
end

# ╔═╡ a1b63f08-53a1-11ec-1385-7170dea76c39
md"""What can be said about $x_1$?
"""

# ╔═╡ a1b64566-53a1-11ec-320b-1fb2409de382
let
	choices = [
	L"It must be $x_1 < \alpha$",
	L"It must be $x_1 > x_0$",
	L"It must be $\alpha < x_1 < x_0$"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ a1b6457a-53a1-11ec-0142-5536080133cd
md"""---
"""

# ╔═╡ a1b6468a-53a1-11ec-2924-a5c51b9c1118
md"""Suppose $f(x)$ is increasing and concave up. From the tangent line representation: $f(x) = f(c) + f'(c)\cdot(x-c) + f''(\xi)/2 \cdot(x-c)^2$, explain why it must be that the graph of $f(x)$ lies on or *above* the tangent line.
"""

# ╔═╡ a1b66456-53a1-11ec-0258-474db8dbbf8b
let
	choices = [
	L"As $f''(\xi)/2 \cdot(x-c)^2$ is non-negative, we must have $f(x) - (f(c) + f'(c)\cdot(x-c)) \geq 0$.",
	L"As $f''(\xi) < 0$ it must be that $f(x) - (f(c) + f'(c)\cdot(x-c)) \geq 0$.",
	L"This isn't true. The function $f(x) = x^3$ at $x=0$ provides a counterexample"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a1b66544-53a1-11ec-0d9d-6ffb64e17eb1
md"""This question can be used to give a proof for the previous two questions, which can be answered by considering the graphs alone. Combined, they say that if a function is  increasing and concave up and $\alpha$ is a zero, then if $x_0 < \alpha$ it will be $x_1 > \alpha$, and for any $x_i > \alpha$, $\alpha <= x_{i+1} <= x_\alpha$, so the sequence in Newton's method is decreasing and bounded below; conditions for which it is guaranteed mathematically there will be convergence.
"""

# ╔═╡ a1b665e8-53a1-11ec-3178-3958f3e57a2a
md"""###### Question
"""

# ╔═╡ a1b66604-53a1-11ec-06c5-a9fc67697422
md"""Let $f(x) = x^2 - 3^x$. This has derivative $2x - 3^x \cdot \log(3)$. Starting with $x_0=0$, what does Newton's method converge on?
"""

# ╔═╡ a1b66c3a-53a1-11ec-2724-27eeec45de1f
let
	f(x) = x^2 - 3^x;
	fp(x) = 2x - 3^x*log(3);
	val = Roots.newton(f, fp, 0);
	numericq(val, 1e-14)
end

# ╔═╡ a1b66c94-53a1-11ec-3dc1-e99eed2865c3
md"""###### Question
"""

# ╔═╡ a1b66d5c-53a1-11ec-16b5-91d41d417ca5
md"""Let $f(x) = \exp(x) - x^4$. There are 3 zeros for this function. Which one does Newton's method converge to when $x_0=2$?
"""

# ╔═╡ a1b67270-53a1-11ec-1381-b3e6cc5f07dc
let
	f(x) = exp(x) - x^4;
	fp(x) = exp(x) - 4x^3;
	xstar= Roots.newton(f, fp, 2);
	numericq(xstar, 1e-1)
end

# ╔═╡ a1b6728c-53a1-11ec-2b54-435ce64f9826
md"""###### Question
"""

# ╔═╡ a1b68d28-53a1-11ec-154c-a710d98fe562
md"""Let $f(x) = \exp(x) - x^4$. As mentioned, there are 3 zeros for this function. Which one does Newton's method converge to when $x_0=8$?
"""

# ╔═╡ a1b69296-53a1-11ec-2625-4bc0313692de
let
	f(x) = exp(x) - x^4;
	fp(x) = exp(x) - 4x^3;
	xstar = Roots.newton(f, fp, 8);
	numericq(xstar, 1e-1)
end

# ╔═╡ a1b692aa-53a1-11ec-026b-f7a754d3ba96
md"""###### Question
"""

# ╔═╡ a1b69324-53a1-11ec-364b-b913e5f86da8
md"""Let $f(x) = \sin(x) - \cos(4\cdot x)$.
"""

# ╔═╡ a1b6937c-53a1-11ec-204a-57ab71c08a6a
md"""Starting at $\pi/8$, solve for the root returned by Newton's method
"""

# ╔═╡ a1b6973c-53a1-11ec-0baa-c1d5690eb6cd
let
	k1=4
	f(x)  = sin(x) - cos(k1*x);
	fp(x) = cos(x) + k1*sin(k1*x);
	val = Roots.newton(f, fp, pi/(2k1));
	numericq(val)
end

# ╔═╡ a1b6975c-53a1-11ec-0fb1-31b3f72399f6
md"""###### Question
"""

# ╔═╡ a1b69778-53a1-11ec-093d-47e786d09667
md"""Using Newton's method find a root to $f(x) = \cos(x) - x^3$ starting at $x_0 = 1/2$.
"""

# ╔═╡ a1b69cfc-53a1-11ec-2082-ab7bc667a3e1
let
	f(x) = cos(x) - x^3
	val = Roots.newton(f,f', 1/2)
	numericq(val)
end

# ╔═╡ a1b69d22-53a1-11ec-0112-0f5cf0521c27
md"""###### Question
"""

# ╔═╡ a1b69d4a-53a1-11ec-2847-37a47dab89e9
md"""Use Newton's method to find a root of $f(x) = x^5 + x -1$. Make a quick graph to find a reasonable starting point.
"""

# ╔═╡ a1b6be1a-53a1-11ec-31a5-bbfa2d3b957c
let
	f(x) = x^5 + x - 1
	val = Roots.newton(f,f', -1)
	numericq(val)
end

# ╔═╡ a1b6be38-53a1-11ec-1fc1-878901e2c39d
md"""###### Question
"""

# ╔═╡ a1b6bea6-53a1-11ec-3440-ad82915e34d4
md"""Consider the following interactive illustration of Newton's method
"""

# ╔═╡ a1b6c50e-53a1-11ec-19ca-f5155299a82b
let
	caption = """
	Illustration of Newton's method. Moving the point ``x_0`` shows different behaviours of the algorithm.
	"""
	#CalculusWithJulia.WeaveSupport.JSXGraph(joinpath(@__DIR__, "newtons-method.js"), caption)
	
	JSXGraph("newtons-method.js", caption)
end

# ╔═╡ a1b6c540-53a1-11ec-1d59-ed71ba37b0e9
md"""If $x_0$ is $1$ what occurs?
"""

# ╔═╡ a1b6ce96-53a1-11ec-10e8-87dd8b7648d0
begin
	nm_choices = [
	"The algorithm converges very quickly. A good initial point was chosen.",
	"The algorithm converges, but slowly. The initial point is close enough to the answer to ensure decreasing errors.",
	"The algrithm fails to converge, as it cycles about"
	]
	radioq(nm_choices, 1, keep_order=true)
end

# ╔═╡ a1b6cec8-53a1-11ec-0f9d-59e58e1f72ae
md"""When $x_0 = 1.0$ the following values are true for $f$:
"""

# ╔═╡ a1b6d49a-53a1-11ec-2cc4-cb173e7896b1
begin
	ff(x) = x^5 - x - 1
	α = find_zero(ff, 1)
	function error_terms(x)
	    (e₀=x-α, f₀′= f'(x), f̄₀′′=f''(α), ē₁ = 1/2*f''(α)/f'(x)*(x-α)^2)
	end
	error_terms(1.0)
end

# ╔═╡ a1b6d526-53a1-11ec-3d6b-076816789e56
md"""Where the values `f̄₀′′` and `ē₁` are worst-case estimates when $\xi$ is between $x_0$ and the zero.
"""

# ╔═╡ a1b6d580-53a1-11ec-1c7c-f134bc9014c9
md"""Does the magnitude of the error increase or decrease in the first step?
"""

# ╔═╡ a1b6dcc4-53a1-11ec-1cf4-51037bf315b2
let
	radioq(["Appears to increase", "It decreases"],2,keep_order=true)
end

# ╔═╡ a1b6dd28-53a1-11ec-0b0f-1ff477dc48d7
md"""If $x_0$ is set near $0.40$ what happens?
"""

# ╔═╡ a1b6e034-53a1-11ec-26c7-a3af745aafb5
let
	radioq(nm_choices, 3, keep_order=true)
end

# ╔═╡ a1b6e098-53a1-11ec-37d3-cfe624a415f7
md"""When $x_0 = 0.4$ the following values are true for $f$:
"""

# ╔═╡ a1b6f4d2-53a1-11ec-22d4-a37a7e58248a
let
	error_terms(0.4)
end

# ╔═╡ a1b6f51a-53a1-11ec-34e2-777d6ac311cf
md"""Where the values `f̄₀′′` and `ē₁` are worst-case estimates when $\xi$ is between $x_0$ and the zero.
"""

# ╔═╡ a1b6f5e2-53a1-11ec-2e38-a1597d027ac2
md"""Does the magnitude of the error increase or decrease in the first step?
"""

# ╔═╡ a1b71bda-53a1-11ec-383e-6d675af2f6c8
let
	radioq(["Appears to increase", "It decreases"],1,keep_order=true)
end

# ╔═╡ a1b71c2a-53a1-11ec-3cce-916dbcb4e3c3
md"""If $x_0$ is set near $0.75$ what happens?
"""

# ╔═╡ a1b71ffe-53a1-11ec-08f5-e7eda0700c49
let
	radioq(nm_choices, 3, keep_order=true)
end

# ╔═╡ a1b7201c-53a1-11ec-1b59-31ef45ae832f
md"""###### Question
"""

# ╔═╡ a1b7203a-53a1-11ec-1464-571a06d0f374
md"""Will Newton's method converge for the function $f(x) = x^5 - x + 1$ starting at $x=1$?
"""

# ╔═╡ a1b727f6-53a1-11ec-3870-4593170be3ac
let
	choices = [
	"Yes",
	"No. The initial guess is not close enough",
	"No. The second derivative is too big",
	L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b72812-53a1-11ec-373d-2b227f615a82
md"""###### Question
"""

# ╔═╡ a1b7288c-53a1-11ec-364b-13e7808181cf
md"""Will Newton's method converge for the function $f(x) = 4x^5 - x + 1$ starting at $x=1$?
"""

# ╔═╡ a1b747cc-53a1-11ec-3c89-a9a419d26dd5
let
	choices = [
	"Yes",
	"No. The initial guess is not close enough",
	"No. The second derivative is too big, or does not exist",
	L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b74830-53a1-11ec-1408-61f6d44a3e08
md"""###### Question
"""

# ╔═╡ a1b748a6-53a1-11ec-3bc8-9f84e96ff3c2
md"""Will Newton's method converge for the function $f(x) = x^{10} - 2x^3 - x + 1$ starting from $0.25$?
"""

# ╔═╡ a1b750e4-53a1-11ec-2fce-df08386285f5
let
	choices = [
	"Yes",
	"No. The initial guess is not close enough",
	"No. The second derivative is too big, or does not exist",
	L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b75104-53a1-11ec-22a0-0f068e7fa7a7
md"""###### Question
"""

# ╔═╡ a1b75172-53a1-11ec-3920-07b16742eb91
md"""Will Newton's method converge for $f(x) = 20x/(100 x^2 + 1)$ starting at $0.1$?
"""

# ╔═╡ a1b759b0-53a1-11ec-2d4e-b726a1437eb5
let
	choices = [
	"Yes",
	"No. The initial guess is not close enough",
	"No. The second derivative is too big, or does not exist",
	L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b75a0a-53a1-11ec-249d-f5ad1f007845
md"""###### Question
"""

# ╔═╡ a1b75a82-53a1-11ec-2c41-c3ab75c26d7b
md"""Will Newton's method converge to a zero for $f(x) = \sqrt{(1 - x^2)^2}$?
"""

# ╔═╡ a1b77576-53a1-11ec-1764-fbfa4bc35976
let
	choices = [
	"Yes",
	"No. The initial guess is not close enough",
	"No. The second derivative is too big, or does not exist",
	L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ a1b7759e-53a1-11ec-02ac-e379399b37d9
md"""###### Question
"""

# ╔═╡ a1b775e2-53a1-11ec-1130-dd03dfb0a180
md"""Use Newton's method to find a root of $f(x) = 4x^4 - 5x^3 + 4x^2 -20x -6$ starting at $x_0 = 0$.
"""

# ╔═╡ a1b77fb2-53a1-11ec-1e1d-d545205462ef
let
	f(x) = 4x^4 - 5x^3 + 4x^2 -20x -6
	val = find_zero((f,f') , 0, Roots.Newton())
	numericq(val)
end

# ╔═╡ a1b77fd0-53a1-11ec-15a1-a90f3b3ef3fe
md"""###### Question
"""

# ╔═╡ a1b78110-53a1-11ec-182c-970352349253
md"""Use Newton's method to find a zero of $f(x) = \sin(x) - x/2$ that is *bigger* than $0$.
"""

# ╔═╡ a1b79c0e-53a1-11ec-3e51-175d8a0175c6
let
	f(x) = sin(x) - x/2
	val = find_zero((f,f'), 2, Roots.Newton())
	numericq(val)
end

# ╔═╡ a1b79c36-53a1-11ec-077c-fb74aeeb766c
md"""###### Question
"""

# ╔═╡ a1b79c48-53a1-11ec-3b42-f1a84ff2eb32
md"""The Newton baffler (defined below) is so named, as Newton's method will fail to find the root for most starting points.
"""

# ╔═╡ a1b7ae38-53a1-11ec-36d8-314da13ea19f
function newton_baffler(x)
    if ( x - 0.0 ) < -0.25
        0.75 * ( x - 0 ) - 0.3125
    elseif  ( x - 0 ) < 0.25
        2.0 * ( x - 0 )
    else
        0.75 * ( x - 0 ) + 0.3125
    end
end

# ╔═╡ a1b7ae74-53a1-11ec-2ef0-cb4147b52fde
md"""Will Newton's method find the zero at $0.0$ starting at $1$?
"""

# ╔═╡ a1b7b248-53a1-11ec-2bd9-6ddd834bc8bb
let
	yesnoq("no")
end

# ╔═╡ a1b7c0bc-53a1-11ec-2be5-0538b37d4ac7
md"""Considering this plot:
"""

# ╔═╡ a1b7d07a-53a1-11ec-230c-97927705dd24
let
	plot(newton_baffler, -1.1, 1.1)
end

# ╔═╡ a1b7d106-53a1-11ec-003e-53542570922f
md"""Starting with $x_0=1$, you can see why Newton's method will fail. Why?
"""

# ╔═╡ a1b7d8ca-53a1-11ec-2f53-9fc59679a6b2
let
	choices = [
	L"It doesn't fail, it converges to $0$",
	L"The tangent lines for $|x| > 0.25$ intersect at $x$ values with $|x| > 0.25$",
	L"The first derivative is $0$ at $1$"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ a1b7d908-53a1-11ec-110b-797d5b6772c7
md"""This function does not have a small first derivative; or a large second derivative; and the bump up can be made as close to the origin as desired, so the starting point can be very close to the zero. However, even though the conditions of the error term are satisfied, the error term does not apply, as $f$ is not continuously differentiable.
"""

# ╔═╡ a1b7d958-53a1-11ec-2393-b546892e890c
md"""###### Question
"""

# ╔═╡ a1b7ea38-53a1-11ec-3d45-f7b55b26565a
md"""Let $f(x) = \sin(x) - x/4$. Starting at  $x_0 = 2\pi$ Newton's method will converge to a value, but it will take many steps. Using a `Tracks` object when calling the  `find_zero` function in the `Roots` package, how many steps does it take:
"""

# ╔═╡ a1b802de-53a1-11ec-1d27-0909452c4cd6
let
	f(x) = sin(x) - x/4
	x₀ = 2π
	tracks = Roots.Tracks()
	find_zero((f,f'), x₀, Roots.Newton(); tracks=tracks)
	val = tracks.steps
	numericq(val, 2)
end

# ╔═╡ a1b8037e-53a1-11ec-0302-538add83b29c
md"""What is the zero that is found?
"""

# ╔═╡ a1b80edc-53a1-11ec-2907-813df1034853
let
	val = Roots.newton(f,f', 2pi)
	numericq(val)
end

# ╔═╡ a1b80f5e-53a1-11ec-1064-77399ee092d0
md"""Is this the closest zero to the starting point, $x_0$?
"""

# ╔═╡ a1b8122e-53a1-11ec-2f5a-25a376ba7d34
let
	yesnoq("no")
end

# ╔═╡ a1b812ce-53a1-11ec-23c1-a98c674c7385
md"""###### Question
"""

# ╔═╡ a1b81378-53a1-11ec-3230-1b45a0626417
md"""Quadratic convergence of Newton's method only applies to *simple* roots. For example, we can see (using the `verbose=true` argument to the `Roots` package's `newton` method, that it only takes $4$ steps to find a zero to $f(x) = \cos(x) - x$ starting at $x_0 = 1$. But it takes many more steps to find the same zero for $f(x) = (\cos(x) - x)^2$.
"""

# ╔═╡ a1b813b2-53a1-11ec-129b-7f328c4b8e97
md"""How many?
"""

# ╔═╡ a1b817b0-53a1-11ec-157f-4b6372c42f0e
let
	val = 24
	numericq(val, 2)
end

# ╔═╡ a1b8181c-53a1-11ec-33b7-29a842e8712e
md"""###### Question: Implicit equations
"""

# ╔═╡ a1b81878-53a1-11ec-1f0c-5d4abff27153
md"""The equation $x^2 + x\cdot y + y^2 = 1$ is a rotated ellipse.
"""

# ╔═╡ a1b8215e-53a1-11ec-01ab-f1809a3f8800
let
	f(x,y) = x^2 + x * y + y^2 - 1
	plot(Eq(f, 0), xlims=(-2,2), ylims=(-2,2), legend=false)
end

# ╔═╡ a1b821d8-53a1-11ec-1d30-7dbe800e0105
md"""Can we find which point on its graph has the largest $y$ value?
"""

# ╔═╡ a1b82246-53a1-11ec-2385-3334ff8fee59
md"""This would be straightforward *if* we could write $y(x) = \dots$, for then we would simply find the critical points and investiate. But we can't so easily solve for $y$ interms of $x$. However, we can use Newton's method to do so:
"""

# ╔═╡ a1b833bc-53a1-11ec-1f0e-6ff37311a000
function findy(x)
  fn = y -> (x^2 + x*y + y^2) - 1
  fp = y -> (x + 2y)
  find_zero((fn, fp), sqrt(1 - x^2), Roots.Newton())
end

# ╔═╡ a1b846a4-53a1-11ec-3e70-150bb6b90e85
md"""For a *fixed* x, this solves for $y$ in the equation: $F(y) = x^2 + x \cdot y + y^2 - 1 = 0$. It should be that $(x,y)$ is a solution:
"""

# ╔═╡ a1b85ebe-53a1-11ec-2275-75044ac39fd4
let
	x = .75
	y = findy(x)
	x^2 + x*y + y^2  ## is this 1?
end

# ╔═╡ a1b86012-53a1-11ec-3b6a-d143f316ec93
md"""So we have a means to find $y(x)$, but it is implicit. We can't readily find the derivative to find critical points. Instead we can use the approximate derivative with $h=10^{-6}$:
"""

# ╔═╡ a1b866fc-53a1-11ec-176c-a32d6cc0b266
yp(x) = (findy(x + 1e-6) - findy(x)) / 1e-6

# ╔═╡ a1b8674c-53a1-11ec-09ea-e91f908a07cb
md"""Using `find_zero`, find the value $x$ which maximizes `yp`. Use this to find the point $(x,y)$ with largest $y$ value.
"""

# ╔═╡ a1b86cf4-53a1-11ec-0cf4-b595373a117d
let
	xstar = find_zero(yp, 0.5)
	ystar = findy(xstar)
	choices = ["``(-0.577, 1.155)``",
	           "``(0,0)``",
	           "``(0, -0.577)``",
	           "``(0.577, 0.577)``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ a1b86d8c-53a1-11ec-3e75-a57b236e2801
md"""###### Question
"""

# ╔═╡ a1b86e7c-53a1-11ec-163e-137aa89ec0f1
md"""In the last problem we used an *approximate* derivative (forward difference) in place of the derivative. This can introduce an error due to the approximation. Would Newton's method still converge if the derivative in the algorithm were replaced with an approximate derivative? In general, this can often be done *but* the convergence can be *slower* and the sensitivity to a poor initial guess even greater.
"""

# ╔═╡ a1b86ee0-53a1-11ec-1885-257d9df604cf
md"""Three common approximations are given by the difference quotient for a fixed $h$: $f'(x_i) \approx (f(x_i+h)-f(x_i))/h$; the secant line approximation: $f'(x_i) \approx (f(x_i) - f(x_{i-1})) / (x_i - x_{i-1})$; and the Steffensen approximation $f'(x_i) \approx (f(x_i + f(x_i)) - f(x_i)) / f(x_i)$ (using $h=f(x_i)$).
"""

# ╔═╡ a1b86f3a-53a1-11ec-09d0-09d9e9182486
md"""Let's revisit the $4$-step convergence of Newton's method to the root of $f(x) = 1/x - q$ when $q=0.8$. Will these methods be as fast?
"""

# ╔═╡ a1b86f4e-53a1-11ec-187f-396abbc82be9
md"""Let's define the above approximations for a given `f`:
"""

# ╔═╡ a1b89140-53a1-11ec-0368-778c48942517
begin
	q₀ = 0.8
	fq(x) = 1/x - q₀
	secant_approx(x0,x1) = (fq(x1) - f(x0)) / (x1 - x0)
	diffq_approx(x0, h) = secant_approx(x0, x0+h)
	steff_approx(x0) = diffq_approx(x0, fq(x0))
end

# ╔═╡ a1b8919a-53a1-11ec-2b5b-47338015f13b
md"""Then using the difference quotient would look like:
"""

# ╔═╡ a1b8a74a-53a1-11ec-3c95-394a47580fc6
let
	Δ = 1e-6
	x1 = 42/17 - 32/17 * q₀
	x1 = x1 - fq(x1) / diffq_approx(x1, Δ)   # |x1 - xstar| = 0.06511395862036995
	x1 = x1 - fq(x1) / diffq_approx(x1, Δ)   # |x1 - xstar| = 0.003391809999860218; etc
end

# ╔═╡ a1b8a7aa-53a1-11ec-08cc-d9ae8b3aaa11
md"""The Steffensen method would look like:
"""

# ╔═╡ a1b8afba-53a1-11ec-36a5-efb0748cef3f
let
	x1 = 42/17 - 32/17 * q₀
	x1 = x1 - fq(x1) / steff_approx(x1)   # |x1 - xstar| = 0.011117056291670258
	x1 = x1 - fq(x1) / steff_approx(x1)   # |x1 - xstar| = 3.502579696146313e-5; etc.
end

# ╔═╡ a1b8b04c-53a1-11ec-3ee0-a16a838e10ed
md"""And the secant method like:
"""

# ╔═╡ a1b8b404-53a1-11ec-0562-fbe2f65db469
let
	Δ = 1e-6
	x1 = 42/17 - 32/17 * q₀
	x0 = x1 - Δ # we need two initial values
	x0, x1 = x1, x1 - fq(x1) / secant_approx(x0, x1)   # |x1 - xstar| = 8.222358365284066e-6
	x0, x1 = x1, x1 - fq(x1) / secant_approx(x0, x1)   # |x1 - xstar| = 1.8766323799379592e-6; etc.
end

# ╔═╡ a1b8b47c-53a1-11ec-2086-21304373d769
md"""Repeat each of the above algorithms until `abs(x1 - 1.25)` is `0` (which will happen for this problem, though not in general). Record the steps.
"""

# ╔═╡ a1b8b562-53a1-11ec-1661-453914a22ce7
md"""  * Does the difference quotient need *more* than $4$ steps?
"""

# ╔═╡ a1b8dcfe-53a1-11ec-388b-d1b53203c4d7
let
	yesnoq(false)
end

# ╔═╡ a1b8de5e-53a1-11ec-1398-95cba5d0b47d
md"""  * Does the secant method need *more* than $4$ steps?
"""

# ╔═╡ a1b8e10e-53a1-11ec-29af-639a0219696b
let
	yesnoq(true)
end

# ╔═╡ a1b8e1ae-53a1-11ec-2f24-310028158aa2
md"""  * Does the Steffensen method need *more* than 4 steps?
"""

# ╔═╡ a1b8e456-53a1-11ec-0b0d-1d42c40020f7
let
	yesnoq(false)
end

# ╔═╡ a1b8e4d8-53a1-11ec-1714-e38d23256ca5
md"""All methods work quickly with this well-behaved problem. In general the convergence rates are slightly different for each, with the Steffensen method matching Newton's method and the difference quotient method being slower in general. All can be more sensitive to the initial guess.
"""

# ╔═╡ a1b8e654-53a1-11ec-07cc-436d77acdd59
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/linearization.html">◅ previous</a>  <a href="../derivatives/more_zeros.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/newtons_method.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ a1b8e6c2-53a1-11ec-27dd-4d885785b34e
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
ImplicitEquations = "95701278-4526-5785-aba3-513cca398f19"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
ImplicitEquations = "~1.0.6"
Plots = "~1.23.6"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
SpecialFunctions = "~1.8.1"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[CRlibm]]
deps = ["Libdl"]
git-tree-sha1 = "9d1c22cff9c04207f336b8e64840d0bd40d86e0e"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "0.8.0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Pluto", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "7adfe1a4e3f52fc356dfa2b0b26457f0acf81aa2"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.10"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "d8f468c5cd4d94e86816603f7d18ece910b4aaf1"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.5.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FastRounding]]
deps = ["ErrorfreeArithmetic", "Test"]
git-tree-sha1 = "224175e213fd4fe112db3eea05d66b308dc2bf6b"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.2.0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "6406b5112809c08b1baa5703ad274e1dded0652f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.23"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "f823a2d04fb233d52812c8024a6d46d9581904a4"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.4.5"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[ImplicitEquations]]
deps = ["CommonEq", "IntervalArithmetic", "RecipesBase", "Test", "Unicode"]
git-tree-sha1 = "cf1660b41894f07d06580ac528a7f580c480c909"
uuid = "95701278-4526-5785-aba3-513cca398f19"
version = "1.0.6"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalArithmetic]]
deps = ["CRlibm", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "00cce14aeb4b256f2f57caf3f3b9354c27d93259"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.17.8"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "0d185e8c33401084cab546a756b387b15f76720c"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.23.6"

[[Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "Sockets", "TableIOInterface", "Tables", "UUIDs"]
git-tree-sha1 = "a5b3fee95de0c0a324bab53a03911395936d15d9"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.17.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

[[RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableIOInterface]]
git-tree-sha1 = "9a0d3ab8afd14f33a35af7391491ff3104401a35"
uuid = "d1efa939-5518-4425-949f-ab857e148477"
version = "0.1.6"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─a1b8e550-53a1-11ec-2bbc-736e3ff65260
# ╟─a1aaa904-53a1-11ec-1d16-c5228a087c00
# ╟─a1aabf98-53a1-11ec-104c-3f31344b5fc0
# ╠═a1ac3736-53a1-11ec-0045-27b3b775f407
# ╟─a1ac4278-53a1-11ec-1343-2dd955005a5e
# ╟─a1ac70fe-53a1-11ec-206f-fb62e4e7e05a
# ╟─a1acb3a2-53a1-11ec-3031-ed5a1baa91e7
# ╟─a1acc266-53a1-11ec-397c-ad51c59a83c7
# ╟─a1acc310-53a1-11ec-0cbf-bbdd1a56a6f5
# ╟─a1acf038-53a1-11ec-0e44-19d343eaa3d7
# ╟─a1acf088-53a1-11ec-057d-b789f5bce7de
# ╟─a1acf0f6-53a1-11ec-07df-f5ac3ce7528a
# ╟─a1acf162-53a1-11ec-263e-d59a6bb2cdea
# ╠═a1ad2b52-53a1-11ec-39a3-4f77e63c1f3a
# ╟─a1ad2b98-53a1-11ec-3c95-e9f91a0dd8db
# ╠═a1ad6342-53a1-11ec-33c0-1d0d732a6c68
# ╟─a1ad6388-53a1-11ec-1202-75ef81de6316
# ╠═a1ad7c60-53a1-11ec-2482-4381acae438e
# ╟─a1ad7cbc-53a1-11ec-3f40-a969c96fd1af
# ╠═a1ad99e0-53a1-11ec-31a7-41ab33c96d93
# ╟─a1ad9a92-53a1-11ec-0729-cd0acc302764
# ╠═a1adf4c4-53a1-11ec-2330-65eb65e6a510
# ╟─a1adf974-53a1-11ec-2200-5ff805bf96fb
# ╟─a1adf99c-53a1-11ec-0063-010ef01ab78c
# ╠═a1ae0cb6-53a1-11ec-104f-8de0e939a0c1
# ╟─a1ae5cfc-53a1-11ec-12a8-356c940c9ae3
# ╟─a1ae8d30-53a1-11ec-1ff6-f1d344a9c514
# ╟─a1ae8e50-53a1-11ec-0dda-e1cb82e0711d
# ╟─a1ae8eb4-53a1-11ec-205a-69b2e0d552e8
# ╟─a1aea87e-53a1-11ec-3d37-a7e1919a474c
# ╟─a1aecf66-53a1-11ec-2753-ff3213d3ae56
# ╟─a1aecffc-53a1-11ec-1ea7-21a902fd0995
# ╟─a1aed01a-53a1-11ec-1d8e-e5e51a3d4568
# ╟─a1aed0c4-53a1-11ec-0efc-c95d2427d432
# ╟─a1aed132-53a1-11ec-1067-37c7349beb4a
# ╟─a1aed150-53a1-11ec-189e-7f219d54e83a
# ╟─a1aed1a0-53a1-11ec-05ec-f9c905e75b3a
# ╟─a1aee3e8-53a1-11ec-283b-cfcc8870b720
# ╟─a1aee424-53a1-11ec-1ca7-07108617d020
# ╠═a1af0f80-53a1-11ec-276b-f3a4fc2d3e62
# ╟─a1af0fbc-53a1-11ec-3b7f-7dddfc446e14
# ╠═a1af65c0-53a1-11ec-1661-cdcbafa52333
# ╟─a1af65fc-53a1-11ec-3b8a-3b18ae09ab84
# ╠═a1af6f5c-53a1-11ec-1321-353e4b7e7dfb
# ╟─a1af6f78-53a1-11ec-3a53-07df487276e0
# ╠═a1af7664-53a1-11ec-3db5-71bd8f62766c
# ╠═a1af7b6e-53a1-11ec-1689-e94b54750237
# ╟─a1af7be6-53a1-11ec-217b-9f96a5b804c4
# ╟─a1afe1c6-53a1-11ec-27de-934d0dc4879b
# ╟─a1afe20c-53a1-11ec-31c5-4d10c9fa6ac6
# ╟─a1afe23e-53a1-11ec-315e-0fb7d3e50e75
# ╠═a1affcf6-53a1-11ec-2d4f-e78f83ce93da
# ╟─a1affd3e-53a1-11ec-1a36-951614f7c0f9
# ╟─a1b028fc-53a1-11ec-0fef-f18e20560911
# ╟─a1b02992-53a1-11ec-2b43-230a8c5c81f2
# ╟─a1b078fc-53a1-11ec-12c4-3395eaf74580
# ╟─a1b079ba-53a1-11ec-11fd-a3a54d1a3794
# ╟─a1b25488-53a1-11ec-10ab-a75012a25c02
# ╟─a1b29b5a-53a1-11ec-2512-6d339f364e04
# ╟─a1b29c54-53a1-11ec-2cf8-9b3cad532397
# ╟─a1b29ccc-53a1-11ec-0696-b7b5cd25d21b
# ╠═a1b2e6e6-53a1-11ec-24df-b1b6ffa93127
# ╟─a1b2e72c-53a1-11ec-3489-3d099cfccf2d
# ╠═a1b30428-53a1-11ec-0c21-67e49d65cffe
# ╟─a1b30522-53a1-11ec-2baa-c36434777092
# ╟─a1b30540-53a1-11ec-1aed-2b078337ed3d
# ╟─a1b31c10-53a1-11ec-1bde-4198e52ddd40
# ╟─a1b31c7e-53a1-11ec-026f-93f4041538bb
# ╠═a1b32200-53a1-11ec-2711-5b016d27c61e
# ╟─a1b32232-53a1-11ec-3064-8f5516583c6a
# ╟─a1b32400-53a1-11ec-3f33-21911cf1d6f9
# ╠═a1b3a614-53a1-11ec-028d-3f58dfa09f8a
# ╟─a1b3a73e-53a1-11ec-11cd-a798e0ad494e
# ╟─a1b3a82e-53a1-11ec-3639-ff88de270912
# ╟─a1b3bd46-53a1-11ec-229d-c5896202a5da
# ╟─a1b3bdb4-53a1-11ec-0dc4-e5318689ca8f
# ╟─a1b3be36-53a1-11ec-327f-e726429ab2c6
# ╟─a1b3beb8-53a1-11ec-108d-7b0feafa6948
# ╟─a1b3bece-53a1-11ec-3990-cde0d14510c5
# ╟─a1b3bf6c-53a1-11ec-1fb4-3b48d1cedba0
# ╟─a1b3bf80-53a1-11ec-0310-7b91526d747c
# ╟─a1b3bfee-53a1-11ec-3346-4d81e84c8d20
# ╠═a1b3cb24-53a1-11ec-37ec-a53549523138
# ╟─a1b3cb60-53a1-11ec-1f47-691d8ee31709
# ╟─a1b3cbba-53a1-11ec-2f76-3fa91705e581
# ╠═a1b3fa54-53a1-11ec-1be9-95093a2461cb
# ╟─a1b3fa9a-53a1-11ec-043c-0f24d1fd1f41
# ╟─a1b3fb08-53a1-11ec-2b17-91296002d010
# ╠═a1b3ff88-53a1-11ec-378c-c9555d0c668a
# ╟─a1b3ffe8-53a1-11ec-1f67-b5693025111b
# ╟─a1b4004e-53a1-11ec-3143-b98ff000a852
# ╟─a1b400d0-53a1-11ec-2b65-55bf3317d28d
# ╟─a1b40134-53a1-11ec-0dec-53d722b87a3f
# ╠═a1b4675a-53a1-11ec-389e-a1e6899b19ef
# ╟─a1b46796-53a1-11ec-084e-0b7c813d1853
# ╟─a1b47aec-53a1-11ec-3a7d-e1912b76fbbf
# ╠═a1b47df6-53a1-11ec-3a21-cb710e5bd2e6
# ╟─a1b47e70-53a1-11ec-365d-5d79f7614d31
# ╟─a1b47ecc-53a1-11ec-33b0-c16a0cbb5f3f
# ╟─a1b47f5e-53a1-11ec-3499-c17aa1892a70
# ╠═a1b4955e-53a1-11ec-23e9-5f21f0b7662e
# ╟─a1b495cc-53a1-11ec-27b3-b7904578f6cb
# ╠═a1b4c86c-53a1-11ec-075f-ef1542e95962
# ╟─a1b4e2ea-53a1-11ec-2599-f70d23f86a86
# ╟─a1b4e40a-53a1-11ec-156d-6fcd25fbb40c
# ╟─a1b4e432-53a1-11ec-1f6c-c9856061a8f6
# ╠═a1b4fa3c-53a1-11ec-2973-cd5530ec37bd
# ╟─a1b4faa8-53a1-11ec-2b29-b7efe1ec087b
# ╠═a1b4fecc-53a1-11ec-0a10-11ae718b53da
# ╟─a1b4ff44-53a1-11ec-3c38-4bd3b167e28e
# ╠═a1b50494-53a1-11ec-14df-97e140b93f95
# ╟─a1b50552-53a1-11ec-1ed1-31f733aa017d
# ╟─a1b50584-53a1-11ec-1a7f-abcc01da5d96
# ╟─a1b50638-53a1-11ec-168a-c506c7424283
# ╠═a1b509ee-53a1-11ec-3874-b94e51563bd6
# ╟─a1b50a20-53a1-11ec-1ff4-a329b3272314
# ╟─a1b50a70-53a1-11ec-001c-57d9102ef15f
# ╠═a1b5226e-53a1-11ec-2a67-ed68f6f396bb
# ╟─a1b522a8-53a1-11ec-194c-05ec4cc93c14
# ╟─a1b522f8-53a1-11ec-3d60-35534739e894
# ╠═a1b529f6-53a1-11ec-027e-bd3763c59bb2
# ╟─a1b52a64-53a1-11ec-0416-838558d2b622
# ╟─a1b52ada-53a1-11ec-2ed7-258885b24015
# ╟─a1b52b36-53a1-11ec-26cd-c1d9a26e1210
# ╟─a1b52b7c-53a1-11ec-20e6-8b1e5bf4452d
# ╟─a1b52be2-53a1-11ec-14e1-7985970fe678
# ╟─a1b52ca8-53a1-11ec-02ee-252cdf0c66bb
# ╟─a1b52cee-53a1-11ec-187b-572e0d45b578
# ╟─a1b52d02-53a1-11ec-1fbf-2716631e70d4
# ╟─a1b52d18-53a1-11ec-2b37-593a7361c92a
# ╟─a1b52d98-53a1-11ec-0d25-d38322b00dec
# ╟─a1b52ddc-53a1-11ec-2036-7f278dcff301
# ╟─a1b52e38-53a1-11ec-0320-b73db6d1824d
# ╟─a1b52e4e-53a1-11ec-169f-879ea1e8e7c4
# ╟─a1b52e80-53a1-11ec-1a2c-59b378168382
# ╟─a1b52e88-53a1-11ec-3eb6-b3fa397f872d
# ╟─a1b52eb2-53a1-11ec-339d-8bd1af9813ee
# ╟─a1b53130-53a1-11ec-1e0c-f7541ccf751f
# ╟─a1b54d64-53a1-11ec-1fb8-4ba631b207c1
# ╟─a1b54dde-53a1-11ec-3284-671a01858925
# ╟─a1b54e90-53a1-11ec-1dd5-cbbe597486ea
# ╟─a1b55962-53a1-11ec-0774-295c6866cbc7
# ╟─a1b57c62-53a1-11ec-3087-812d2bb27fb9
# ╟─a1b57cda-53a1-11ec-39cb-17d6ef463cd6
# ╟─a1b587c2-53a1-11ec-21cf-59b10be8af24
# ╟─a1b587e8-53a1-11ec-3803-a1a3f59c1cd5
# ╟─a1b5be16-53a1-11ec-239c-9930c371f036
# ╟─a1b5d5a4-53a1-11ec-174b-0376695ab7e7
# ╟─a1b5d6b2-53a1-11ec-028e-032b486b30d8
# ╟─a1b5d6fa-53a1-11ec-0b2e-9f4f28b0e1ff
# ╟─a1b5d7ca-53a1-11ec-1027-81edbd8ec69e
# ╟─a1b5d7f0-53a1-11ec-02db-47cb1f3a3a53
# ╟─a1b5d84c-53a1-11ec-3ebb-7fcb438e0296
# ╟─a1b5d862-53a1-11ec-2857-4d823c6bc45c
# ╟─a1b5d8ec-53a1-11ec-2fb4-d3db7a858ab6
# ╟─a1b6056a-53a1-11ec-38e9-1f4dc217664e
# ╟─a1b605b0-53a1-11ec-1ced-b73d63b89c45
# ╟─a1b62360-53a1-11ec-0d25-039e4adaae5f
# ╟─a1b623d8-53a1-11ec-37f3-cf022504ba82
# ╟─a1b624b4-53a1-11ec-247a-911e328a4a97
# ╟─a1b62de2-53a1-11ec-2875-f1195ad91f93
# ╟─a1b62e0a-53a1-11ec-31d5-e563db89b283
# ╟─a1b634fe-53a1-11ec-26d4-b90d66848e5c
# ╟─a1b63530-53a1-11ec-281e-9dba7b727d04
# ╟─a1b635b2-53a1-11ec-1d8a-c7c3988e1562
# ╟─a1b63ede-53a1-11ec-36ad-d5f19234e9fc
# ╟─a1b63f08-53a1-11ec-1385-7170dea76c39
# ╟─a1b64566-53a1-11ec-320b-1fb2409de382
# ╟─a1b6457a-53a1-11ec-0142-5536080133cd
# ╟─a1b6468a-53a1-11ec-2924-a5c51b9c1118
# ╟─a1b66456-53a1-11ec-0258-474db8dbbf8b
# ╟─a1b66544-53a1-11ec-0d9d-6ffb64e17eb1
# ╟─a1b665e8-53a1-11ec-3178-3958f3e57a2a
# ╟─a1b66604-53a1-11ec-06c5-a9fc67697422
# ╟─a1b66c3a-53a1-11ec-2724-27eeec45de1f
# ╟─a1b66c94-53a1-11ec-3dc1-e99eed2865c3
# ╟─a1b66d5c-53a1-11ec-16b5-91d41d417ca5
# ╟─a1b67270-53a1-11ec-1381-b3e6cc5f07dc
# ╟─a1b6728c-53a1-11ec-2b54-435ce64f9826
# ╟─a1b68d28-53a1-11ec-154c-a710d98fe562
# ╟─a1b69296-53a1-11ec-2625-4bc0313692de
# ╟─a1b692aa-53a1-11ec-026b-f7a754d3ba96
# ╟─a1b69324-53a1-11ec-364b-b913e5f86da8
# ╟─a1b6937c-53a1-11ec-204a-57ab71c08a6a
# ╟─a1b6973c-53a1-11ec-0baa-c1d5690eb6cd
# ╟─a1b6975c-53a1-11ec-0fb1-31b3f72399f6
# ╟─a1b69778-53a1-11ec-093d-47e786d09667
# ╟─a1b69cfc-53a1-11ec-2082-ab7bc667a3e1
# ╟─a1b69d22-53a1-11ec-0112-0f5cf0521c27
# ╟─a1b69d4a-53a1-11ec-2847-37a47dab89e9
# ╟─a1b6be1a-53a1-11ec-31a5-bbfa2d3b957c
# ╟─a1b6be38-53a1-11ec-1fc1-878901e2c39d
# ╟─a1b6bea6-53a1-11ec-3440-ad82915e34d4
# ╟─a1b6c50e-53a1-11ec-19ca-f5155299a82b
# ╟─a1b6c540-53a1-11ec-1d59-ed71ba37b0e9
# ╟─a1b6ce96-53a1-11ec-10e8-87dd8b7648d0
# ╟─a1b6cec8-53a1-11ec-0f9d-59e58e1f72ae
# ╟─a1b6d49a-53a1-11ec-2cc4-cb173e7896b1
# ╟─a1b6d526-53a1-11ec-3d6b-076816789e56
# ╟─a1b6d580-53a1-11ec-1c7c-f134bc9014c9
# ╟─a1b6dcc4-53a1-11ec-1cf4-51037bf315b2
# ╟─a1b6dd28-53a1-11ec-0b0f-1ff477dc48d7
# ╟─a1b6e034-53a1-11ec-26c7-a3af745aafb5
# ╟─a1b6e098-53a1-11ec-37d3-cfe624a415f7
# ╟─a1b6f4d2-53a1-11ec-22d4-a37a7e58248a
# ╟─a1b6f51a-53a1-11ec-34e2-777d6ac311cf
# ╟─a1b6f5e2-53a1-11ec-2e38-a1597d027ac2
# ╟─a1b71bda-53a1-11ec-383e-6d675af2f6c8
# ╟─a1b71c2a-53a1-11ec-3cce-916dbcb4e3c3
# ╟─a1b71ffe-53a1-11ec-08f5-e7eda0700c49
# ╟─a1b7201c-53a1-11ec-1b59-31ef45ae832f
# ╟─a1b7203a-53a1-11ec-1464-571a06d0f374
# ╟─a1b727f6-53a1-11ec-3870-4593170be3ac
# ╟─a1b72812-53a1-11ec-373d-2b227f615a82
# ╟─a1b7288c-53a1-11ec-364b-13e7808181cf
# ╟─a1b747cc-53a1-11ec-3c89-a9a419d26dd5
# ╟─a1b74830-53a1-11ec-1408-61f6d44a3e08
# ╟─a1b748a6-53a1-11ec-3bc8-9f84e96ff3c2
# ╟─a1b750e4-53a1-11ec-2fce-df08386285f5
# ╟─a1b75104-53a1-11ec-22a0-0f068e7fa7a7
# ╟─a1b75172-53a1-11ec-3920-07b16742eb91
# ╟─a1b759b0-53a1-11ec-2d4e-b726a1437eb5
# ╟─a1b75a0a-53a1-11ec-249d-f5ad1f007845
# ╟─a1b75a82-53a1-11ec-2c41-c3ab75c26d7b
# ╟─a1b77576-53a1-11ec-1764-fbfa4bc35976
# ╟─a1b7759e-53a1-11ec-02ac-e379399b37d9
# ╟─a1b775e2-53a1-11ec-1130-dd03dfb0a180
# ╟─a1b77fb2-53a1-11ec-1e1d-d545205462ef
# ╟─a1b77fd0-53a1-11ec-15a1-a90f3b3ef3fe
# ╟─a1b78110-53a1-11ec-182c-970352349253
# ╟─a1b79c0e-53a1-11ec-3e51-175d8a0175c6
# ╟─a1b79c36-53a1-11ec-077c-fb74aeeb766c
# ╟─a1b79c48-53a1-11ec-3b42-f1a84ff2eb32
# ╠═a1b7ae38-53a1-11ec-36d8-314da13ea19f
# ╟─a1b7ae74-53a1-11ec-2ef0-cb4147b52fde
# ╟─a1b7b248-53a1-11ec-2bd9-6ddd834bc8bb
# ╟─a1b7c0bc-53a1-11ec-2be5-0538b37d4ac7
# ╠═a1b7d07a-53a1-11ec-230c-97927705dd24
# ╟─a1b7d106-53a1-11ec-003e-53542570922f
# ╟─a1b7d8ca-53a1-11ec-2f53-9fc59679a6b2
# ╟─a1b7d908-53a1-11ec-110b-797d5b6772c7
# ╟─a1b7d958-53a1-11ec-2393-b546892e890c
# ╟─a1b7ea38-53a1-11ec-3d45-f7b55b26565a
# ╟─a1b802de-53a1-11ec-1d27-0909452c4cd6
# ╟─a1b8037e-53a1-11ec-0302-538add83b29c
# ╟─a1b80edc-53a1-11ec-2907-813df1034853
# ╟─a1b80f5e-53a1-11ec-1064-77399ee092d0
# ╟─a1b8122e-53a1-11ec-2f5a-25a376ba7d34
# ╟─a1b812ce-53a1-11ec-23c1-a98c674c7385
# ╟─a1b81378-53a1-11ec-3230-1b45a0626417
# ╟─a1b813b2-53a1-11ec-129b-7f328c4b8e97
# ╟─a1b817b0-53a1-11ec-157f-4b6372c42f0e
# ╟─a1b8181c-53a1-11ec-33b7-29a842e8712e
# ╟─a1b81878-53a1-11ec-1f0c-5d4abff27153
# ╟─a1b8215e-53a1-11ec-01ab-f1809a3f8800
# ╟─a1b821d8-53a1-11ec-1d30-7dbe800e0105
# ╟─a1b82246-53a1-11ec-2385-3334ff8fee59
# ╠═a1b833bc-53a1-11ec-1f0e-6ff37311a000
# ╟─a1b846a4-53a1-11ec-3e70-150bb6b90e85
# ╠═a1b85ebe-53a1-11ec-2275-75044ac39fd4
# ╟─a1b86012-53a1-11ec-3b6a-d143f316ec93
# ╠═a1b866fc-53a1-11ec-176c-a32d6cc0b266
# ╟─a1b8674c-53a1-11ec-09ea-e91f908a07cb
# ╟─a1b86cf4-53a1-11ec-0cf4-b595373a117d
# ╟─a1b86d8c-53a1-11ec-3e75-a57b236e2801
# ╟─a1b86e7c-53a1-11ec-163e-137aa89ec0f1
# ╟─a1b86ee0-53a1-11ec-1885-257d9df604cf
# ╟─a1b86f3a-53a1-11ec-09d0-09d9e9182486
# ╟─a1b86f4e-53a1-11ec-187f-396abbc82be9
# ╠═a1b89140-53a1-11ec-0368-778c48942517
# ╟─a1b8919a-53a1-11ec-2b5b-47338015f13b
# ╠═a1b8a74a-53a1-11ec-3c95-394a47580fc6
# ╟─a1b8a7aa-53a1-11ec-08cc-d9ae8b3aaa11
# ╠═a1b8afba-53a1-11ec-36a5-efb0748cef3f
# ╟─a1b8b04c-53a1-11ec-3ee0-a16a838e10ed
# ╠═a1b8b404-53a1-11ec-0562-fbe2f65db469
# ╟─a1b8b47c-53a1-11ec-2086-21304373d769
# ╟─a1b8b562-53a1-11ec-1661-453914a22ce7
# ╟─a1b8dcfe-53a1-11ec-388b-d1b53203c4d7
# ╟─a1b8de5e-53a1-11ec-1398-95cba5d0b47d
# ╟─a1b8e10e-53a1-11ec-29af-639a0219696b
# ╟─a1b8e1ae-53a1-11ec-2f24-310028158aa2
# ╟─a1b8e456-53a1-11ec-0b0d-1d42c40020f7
# ╟─a1b8e4d8-53a1-11ec-1714-e38d23256ca5
# ╟─a1b8e654-53a1-11ec-07cc-436d77acdd59
# ╟─a1b8e690-53a1-11ec-1efc-47ed51ff4336
# ╟─a1b8e6c2-53a1-11ec-27dd-4d885785b34e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
