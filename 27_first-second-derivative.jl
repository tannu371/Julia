### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ dac9fa74-53a0-11ec-1a9a-e71a48defa26
begin
	using CalculusWithJulia
	using Plots
	using SymPy
	using Roots
end

# ╔═╡ dacb5806-53a0-11ec-186c-0d9f07a23c5c
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ daddf7fe-53a0-11ec-314f-e327c02ee240
using PlutoUI

# ╔═╡ daddf7d6-53a0-11ec-3935-9516108e2423
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ dac861ca-53a0-11ec-00e1-e9d91630671e
md"""# The first and second derivatives
"""

# ╔═╡ dac87384-53a0-11ec-0e68-934b61b1a55f
md"""This section uses these add-on packages:
"""

# ╔═╡ dac87398-53a0-11ec-2848-fdba54c9e54e
md"""Before beginning, we load the packages used in the following:
"""

# ╔═╡ dacb539c-53a0-11ec-052c-b5b9607ffd0e
begin
	## This is from CalculusWithJulia, but not until a new version is tagged
	function sign_chart(f, a, b; atol=1e-6)
	    pm(x) = x < 0 ? "-" : x > 0 ? "+" : "0"
	    summarize(f,cp,d) = (DNE_0_∞=cp, sign_change=pm(f(cp-d)) * " → " * pm(f(cp+d)))
	
	    if Roots._is_f_approx_0(f(a),a, eps(), eps()) ||
	        Roots._is_f_approx_0(f(b), b, eps(), eps())
	        return "Sorry, the endpoints must not be zeros for the function"
	    end
	
	    zs = find_zeros(f, a, b)
	    pts = vcat(a, zs, b)
	    for (u,v) ∈ zip(pts[1:end-1], pts[2:end])
	        zs′ = find_zeros(x -> 1/f(x), u, v)
	        for z′ ∈ zs′
	            flag = false
	            for z ∈ zs
	                if isapprox(z′, z, atol=atol)
	                    flag = true
	                    break
	                end
	            end
	            !flag && push!(zs, z′)
	        end
	    end
	
	
	    if isempty(zs)
		fc = f(a + (b-a)/2)
		return "No sign change, always " * (fc > 0 ? "positive" : iszero(fc) ? "zero" : "negative")
	    end
	
	    sort!(zs)
	    m,M = extrema(zs)
	    d = min((m-a)/2, (b-M)/2)
	    if length(zs) > 1
	        d′ = minimum(diff(zs))/2
	        d = min(d, d′ )
	    end
	    summarize.(f, zs, d)
	end
	nothing
end

# ╔═╡ dacb58ce-53a0-11ec-36f6-85b384c0336b
md"""---
"""

# ╔═╡ dacb5a90-53a0-11ec-00ee-e7bd5ce04cbd
md"""This section explores properties of a function, $f(x)$, that are described by properties of its first and second derivatives, $f'(x)$ and $f''(x)$. As part or the conversation two tests are discussed that characterize when a critical point is a relative maximum or minimum. (We know that any relative maximum or minimum occurs at a critical point, but it is not true that *any* critical point will be a relative maximum or minimum.)
"""

# ╔═╡ dacb71b0-53a0-11ec-2424-137280855687
md"""## Positive and increasing on an interval
"""

# ╔═╡ dacb7214-53a0-11ec-11b1-c9c4139cf9c9
md"""We start with some vocabulary:
"""

# ╔═╡ dad14c0c-53a0-11ec-1b48-bfc9e773bc1c
md"""> A function $f$ is **positive** on an interval $I$ if for any $a$ in $I$ it must be that $f(a) > 0$.

"""

# ╔═╡ dad14cb6-53a0-11ec-0862-4d02e0a7ad82
md"""Of course, we  define *negative* in a parallel manner. The intermediate value theorem says a continuous function can not change from positive to negative without crossing $0$. This is not the case for functions with jumps, of course.
"""

# ╔═╡ dad14cca-53a0-11ec-3a65-531288bb4cb5
md"""Next,
"""

# ╔═╡ dad14dc6-53a0-11ec-3d12-ddf57bd96684
md"""> A function, $f$, is (strictly) **increasing** on an interval $I$ if for any $a < b$ it must be that $f(a) < f(b)$.

"""

# ╔═╡ dad14dec-53a0-11ec-2ccf-67fed66de92d
md"""The word strictly is related to the inclusion of the $<$ precluding the possibility of a function being flat over an interval that the $\leq$ inequality would allow.
"""

# ╔═╡ dad14e14-53a0-11ec-25a9-7941830b6497
md"""A parallel definition with $a < b$ implying $f(a) > f(b)$ would be used for a *strictly decreasing* function.
"""

# ╔═╡ dad28c5c-53a0-11ec-3b3e-91d9a8776254
md"""We can try and prove these properties for a function algebraically – we'll see both are related to the zeros of some function. However, before proceeding to that it is usually helpful to get an idea of where the answer is using exploratory graphs.
"""

# ╔═╡ dad29cc4-53a0-11ec-12e7-a11df061c388
md"""We will use a helper function, `plotif(f,g,a,b)` that plots the function `f` over `[a,b]` coloring it red when `g` is positive (and blue otherwise). Such a function is defined for us in the accompanying `CalculusWithJulia` package, which has been loaded.
"""

# ╔═╡ dad29d32-53a0-11ec-0b56-b77a1ad8930a
md"""To see where a function is positive, we simply pass the function object in for *both* `f` and `g` above. For example, let's look at where $f(x) = \sin(x)$ is positive:
"""

# ╔═╡ dad2a3a4-53a0-11ec-2f13-4ff089994706
let
	f(x) = sin(x)
	plotif(f, f, -2pi, 2pi)
end

# ╔═╡ dad2a3d6-53a0-11ec-2790-d59120dc4e16
md"""Let's graph with `cos` in the masking spot and see what happens:
"""

# ╔═╡ dad2a822-53a0-11ec-1475-1d91cec35689
plotif(sin, cos, -2pi, 2pi)

# ╔═╡ dad2a84a-53a0-11ec-1a81-5572b07fff59
md"""Maybe surprisingly, we see that the increasing parts of the sine curve are now highlighted. Of course, the cosine is the derivative of the sine function, now we discuss that this is no coincidence.
"""

# ╔═╡ dad2a872-53a0-11ec-3367-3f3bc3d53d89
md"""For the sequel, we will use `f'` notation to find numeric derivatives, with the notation being defined in the `CalculusWithJulia` package using the `ForwardDiff` package.
"""

# ╔═╡ dad2a89a-53a0-11ec-2d1e-bfac09feda1e
md"""## The relationship of the derivative and increasing
"""

# ╔═╡ dad2a8cc-53a0-11ec-3a6d-5beeada05432
md"""The derivative, $f'(x)$, computes the slope of the tangent line to the graph of $f(x)$ at the point $(x,f(x))$. If the derivative is positive, the tangent line will have an increasing slope. Clearly if we see an increasing function and mentally layer on a tangent line, it will have a positive slope. Intuitively then, increasing functions and positive derivatives are related concepts. But there are some technicalities.
"""

# ╔═╡ dad2a8ea-53a0-11ec-0adb-ede3eb67dc1c
md"""Suppose $f(x)$ has a derivative on $I$ . Then
"""

# ╔═╡ dad2a9c8-53a0-11ec-341c-3369cbd0fc0e
md"""> If $f'(x)$ is positive on an interval $I=(a,b)$, then $f(x)$ is strictly increasing on $I$.

"""

# ╔═╡ dad2a9d0-53a0-11ec-07e5-092c7e7dda1e
md"""Meanwhile,
"""

# ╔═╡ dad2aa0c-53a0-11ec-3953-757902bc8af2
md"""> If a function $f(x)$ is increasing on $I$, then $f'(x) \geq 0$.

"""

# ╔═╡ dad2aa20-53a0-11ec-12a5-17a832071d93
md"""The technicality being the equality parts. In the second statement, we have the derivative is non-negative, as we can't guarantee it is positive, even if we considered just strictly increasing functions.
"""

# ╔═╡ dad2aa34-53a0-11ec-3328-7f97f769a80d
md"""We can see by the example of $f(x) = x^3$ that strictly increasing functions can have a zero derivative, at a point.
"""

# ╔═╡ dad2aa66-53a0-11ec-1470-d9021e9ef98c
md"""The mean value theorem provides the reasoning behind the first statement: on $I$, the slope of any secant line between $d < e$ (both in $I$) is matched by the slope of some tangent line, which by assumption will always be positive. If the secant line slope is written as $(f(e) - f(d))/(e - d)$ with $d < e$, then it is clear then that $f(e) - f(d) > 0$, or $d < e$ implies $f(d) < f(e)$.
"""

# ╔═╡ dad2aa70-53a0-11ec-1ff2-2d1e25c4cd5d
md"""The second part, follows from the secant line equation. The derivative can be written as a limit of secant-line slopes, each of which is positive. The limit of positive things can only be non-negative, though there is no guarantee the limit will be positive.
"""

# ╔═╡ dad2aa98-53a0-11ec-094a-3d299ca9ed73
md"""So, to visualize where a function is increasing, we can just pass in the derivative as the masking function in our `plotif` function, as long as we are wary about places with $0$ derivative (flat spots).
"""

# ╔═╡ dad2aaac-53a0-11ec-2565-cb0f2de5eb11
md"""For example, here, with a more complicated function, the intervals where the function is increasing are highlighted by passing in the functions derivative to `plotif`:
"""

# ╔═╡ dad2b34e-53a0-11ec-3f4e-19cc526e118c
let
	f(x) = sin(pi*x) * (x^3 - 4x^2 + 2)
	plotif(f, f', -2, 2)
end

# ╔═╡ dad6e9be-53a0-11ec-0820-736078d10176
md"""### First derivative test
"""

# ╔═╡ dad6ea0e-53a0-11ec-3d79-197f50961f21
md"""When a function changes from increasing to decreasing, or decreasing to increasing, it will have a peak or a valley. More formally, such points are relative extrema.
"""

# ╔═╡ dad6ea90-53a0-11ec-376c-5959dcbbe6c4
md"""When discussing the mean value thereom, we said $f(x)$ has a *relative maximum* at $c$ if there exists some interval $I=(a,b)$ with $a < c < b$ for which $f(c)$ is an absolute maximum for $f$ and $I$.
"""

# ╔═╡ dad6eaa4-53a0-11ec-0064-65375102a545
md"""Alternatively, we could say
"""

# ╔═╡ dad6ebc4-53a0-11ec-01d5-bda25a0b4578
md"""> The function $f(x)$ has a *relative  maximum* at $c$ if the value $f(c)$ is an *absolute maximum* for some *open* interval containing $c$. Similarly, a *relative minimum* is defined, as having $f(c)$ be an absolute minimum for *some* open interval about $c$.

"""

# ╔═╡ dad6ec02-53a0-11ec-3af6-f564d750515a
md"""We know since [Fermat](http://tinyurl.com/nfgz8fz) that:
"""

# ╔═╡ dad6ec52-53a0-11ec-1a2a-55c042f167f0
md"""> Relative maxima and minima *must* occur at *critical* points.

"""

# ╔═╡ dad6ec5c-53a0-11ec-10bd-531a9ec712ae
md"""However,
"""

# ╔═╡ dad6ec84-53a0-11ec-2022-4dbc39cc3876
md"""> A critical point need not indicate a relative maxima or minima.

"""

# ╔═╡ dad6eca2-53a0-11ec-2a8c-75e07b9ac18d
md"""Again, $f(x)=x^3$ provides the example at $x=0$. This is a critical point, but clearly not a relative maximum or minimum - it is just a slight pause for a strictly increasing function.
"""

# ╔═╡ dad6ecac-53a0-11ec-1712-69e718ffc8c6
md"""When will a critical point correspond to a relative maximum or minimum? That question can be answered by considering the first derivative.
"""

# ╔═╡ dad84048-53a0-11ec-1e6e-c9a533f3694d
md"""> *The first derivative test*: If $c$ is a critical point for $f(x)$ and *if* $f'(x)$ changes sign at $x=c$, then $f(c)$ will be either a relative maximum or a relative minimum. It will be a relative maximum if the derivative changes sign from $+$ to $-$ and a relative minimum if the derivative changes sign from $-$ to $+$. If $f'(x)$ does not change sign at $c$, then $(c,f(c))$ is *not* a relative maximum or minimum.

"""

# ╔═╡ dad840ca-53a0-11ec-29af-6d1712367ea8
md"""The classification part, should be clear: e.g., if the derivative is positive then negative, the function $f$ will increase to $(c,f(c))$ then decrease from $(c,f(c))$ – so $f$ will have a local maximum at $c$.
"""

# ╔═╡ dad84110-53a0-11ec-046b-e5997891db7c
md"""Our definition of critical point *assumes* $f(c)$ exists, as $c$ is in the domain of $f$. With this assumption, vertical asymptotes are avoided. However, it need not be that $f'(c)$ exists. The absolute value function at $x=0$ provides an example: this point is a critical point where the derivative changes sign, but $f'(x)$ is not defined  at exactly $x=0$. Regardless, it is guaranteed that $(c,f(c))$ will be a relative minimum by the first derivative test.
"""

# ╔═╡ dad85bd2-53a0-11ec-1e51-37e9526601c0
md"""##### Example
"""

# ╔═╡ dad85c7a-53a0-11ec-3a54-c3e694acdd7e
md"""Consider the function $f(x) = e^{-\lvert x\rvert} \cos(\pi x)$ over $[-3,3]$:
"""

# ╔═╡ dad86834-53a0-11ec-0766-53492ec22a2f
begin
	𝐟(x) = exp(-abs(x)) * cos(pi * x)
	plotif(𝐟, 𝐟', -3, 3)
end

# ╔═╡ dad97c90-53a0-11ec-16d3-1de08d471538
md"""We can see the first derivative test in action: at the peaks and valleys – the relative extrema – the color changes. This is because $f'$ is changing sign as as the function changes from increasing to decreasing or vice versa.
"""

# ╔═╡ dad97d66-53a0-11ec-0274-2b46faebcacf
md"""This function has a critical point at $0$, as can be seen. It corresponds to a point where the derivative does not exist. It is still identified through `find_zeros`, which picks up zeros and in case of discontinuous functions, like `f'`, zero crossings:
"""

# ╔═╡ dad9a5a0-53a0-11ec-32e3-7986594f7672
find_zeros(𝐟', -3, 3)

# ╔═╡ dad9a5f0-53a0-11ec-2128-a16ba2e48093
md"""##### Example
"""

# ╔═╡ dad9a638-53a0-11ec-27de-ff91f335258c
md"""Find all the relative maxima and minima of the function $f(x) = \sin(\pi \cdot x) \cdot (x^3 - 4x^2 + 2)$ over the interval $[-2, 2]$.
"""

# ╔═╡ dad9a65e-53a0-11ec-295e-8df76fb79d66
md"""We will do so numerically. For this task we first need to gather the critical points. As each of the pieces of $f$ are everywhere differentiable and no quotients are involved, the function $f$ will be everywhere differentiable. As such, only zeros of $f'(x)$ can be critical points. We find these with
"""

# ╔═╡ dad9b036-53a0-11ec-0e95-5718b6659e14
begin
	𝒇(x) = sin(pi*x) * (x^3 - 4x^2 + 2)
	𝒇cps = find_zeros(𝒇', -2, 2)
end

# ╔═╡ dad9b070-53a0-11ec-30f3-5909bb49719d
md"""We should be careful though, as `find_zeros` may miss zeros that are not simple or too close together. A critical point will correspond to a relative maximum if the function crosses the axis, so these can not be "pauses." As this is exactly the case we are screening for, we double check that all the critical points are accounted for by graphing the derivative:
"""

# ╔═╡ dad9b6a8-53a0-11ec-0be3-9d6a470756f5
begin
	plot(𝒇', -2, 2, legend=false)
	plot!(zero)
	scatter!(𝒇cps, 0*𝒇cps)
end

# ╔═╡ dad9b6e6-53a0-11ec-2644-d3ae1de1a193
md"""We see the six zeros as stored in `cps` and note that at each the function clearly crosses the $x$ axis.
"""

# ╔═╡ dad9b720-53a0-11ec-0d0a-bfe86ba450f8
md"""From this last graph of the derivative we can also characterize the graph of $f$: The left-most critical point coincides with a relative minimum of $f$, as the derivative changes sign from negative to positive. The critical points then alternate relative maximum, relative minimum, relative maximum, relative, minimum, and finally relative maximum.
"""

# ╔═╡ dad9b734-53a0-11ec-138e-47a0fd3fd230
md"""##### Example
"""

# ╔═╡ dad9b752-53a0-11ec-1816-67848be7e9a7
md"""Consider the function $g(x) = \sqrt{\lvert x^2 - 1\rvert}$. Find the critical points and characterize them as relative extrema or not.
"""

# ╔═╡ dad9b770-53a0-11ec-32f0-87e7a7b304c8
md"""We will apply the same approach, but need to get a handle on how large the values can be. The function is a composition of three functions. We should expect that the only critical points will occur when the interior polynomial, $x^2-1$ has values of interest, which is around the interval $(-1, 1)$. So we look to the slightly wider interval $[-2, 2]$:
"""

# ╔═╡ dad9bd8a-53a0-11ec-0159-33b103826ded
begin
	g(x) = sqrt(abs(x^2 - 1))
	gcps = find_zeros(g', -2, 2)
end

# ╔═╡ dad9bdc4-53a0-11ec-22be-7f935e30220e
md"""We see the three values $-1$, $0$, $1$ that correspond to the two zeros and the relative minimum of $x^2 - 1$. We could graph things, but instead we characterize these values using a sign chart. A continuous function only can change sign when it crosses $0$ and the derivative will be continuous, except possibly at the three values above.
"""

# ╔═╡ dad9bdd8-53a0-11ec-1765-5356cb2ae432
md"""We can then pick intermediate values to test for positive or negative values:
"""

# ╔═╡ dad9c42c-53a0-11ec-0a9a-2ba25a4e6a03
begin
	pts = sort(union(-2, gcps, 2))  # this includes the endpoints (a, b) and the critical points
	test_pts = pts[1:end-1] + diff(pts)/2 # midpoints of intervals between pts
	[test_pts sign.(g'.(test_pts))]
end

# ╔═╡ dad9c44a-53a0-11ec-26a8-95b0946e138f
md"""Reading this we have:
"""

# ╔═╡ dad9d75a-53a0-11ec-2b02-3d266ca0ec71
md"""  * the derivative changes sign from negative to postive at $x=-1$, so $f(x)$ will have a relative minimum.
  * the derivative changes sign from positive to negative at $x=0$, so $f(x)$ will have a relative maximum.
  * the derivative changes sign from negative to postive at $x=1$, so $f(x)$ will have a relative minimum.
"""

# ╔═╡ dad9d7a0-53a0-11ec-103d-8f5d36290925
md"""In the `CalculusWithJulia` package there is function `sign_chart` that will do such work for us:
"""

# ╔═╡ dad9db38-53a0-11ec-1e5f-0da7758d749a
sign_chart(g', -2, 2)

# ╔═╡ dad9db56-53a0-11ec-0afb-8945374e2e2d
md"""We did this all without graphs. But, let's look at the graph of the derivative:
"""

# ╔═╡ dad9de6c-53a0-11ec-1686-69fac602cd4d
plot(g', -2, 2)

# ╔═╡ dad9dea8-53a0-11ec-2e4f-0b911c05e4df
md"""We see asymptotes at $x=-1$ and $x=1$! These aren't zeroes of $f'(x)$, but rather where $f'(x)$ does not exist. The conclusion is correct - each of $-1$, $0$ and $1$ are critical points with the identified characterization - but not for the reason that they are all zeros.
"""

# ╔═╡ dad9e11e-53a0-11ec-2696-1b2ecb46c9e8
plot(g, -2, 2)

# ╔═╡ dad9e15a-53a0-11ec-1b08-1fe98ee214d4
md"""Finally, why does `find_zeros` find these values that are not zeros of $g'(x)$? As discussed briefly above, it uses the bisection algorithm on bracketing intervals to find zeros which are guaranteed by the intermediate value theorem, but when applied to discontinuous functions, as `f'` is, will also identify values where the function jumps over $0$.
"""

# ╔═╡ dad9e16e-53a0-11ec-3424-cfba3192f700
md"""##### Example
"""

# ╔═╡ dad9e18c-53a0-11ec-35d7-f92ed4cf72ee
md"""Consider the function $f(x) = \sin(x) - x$. Characterize the critical points.
"""

# ╔═╡ dad9e196-53a0-11ec-193c-e52e178c9c30
md"""We will work symbolically for this example.
"""

# ╔═╡ dad9e4b4-53a0-11ec-3229-9199c1168f39
begin
	@syms x
	fx = sin(x) - x
	fp = diff(fx, x)
	solve(fp)
end

# ╔═╡ dad9e4de-53a0-11ec-0673-1b5192699ee1
md"""We get values of $0$ and $2\pi$. Let's look at the derivative at these points:
"""

# ╔═╡ dad9e4f2-53a0-11ec-21f4-452137c3a776
md"""At $x=0$ we have to the left and right signs found by
"""

# ╔═╡ dad9e9ac-53a0-11ec-0823-a9dc1c5eb5ab
fp.([-1/10, 1/10])

# ╔═╡ dad9e9d4-53a0-11ec-0e58-194745538589
md"""Both are negative. The derivative does not change sign at $0$, so the critical point is neither a relative minimum or maximum.
"""

# ╔═╡ dad9e9e8-53a0-11ec-3cd9-0ff2fae869fc
md"""What about at $2\pi$? We do something similar:
"""

# ╔═╡ dad9f01e-53a0-11ec-28c4-6101360d572b
fp.(2*pi .+ [-1/10,  1/10])

# ╔═╡ dad9f050-53a0-11ec-13da-df56ac1d3460
md"""Again, both negative. The function $f(x)$ is just decreasing near $2\pi$, so again the critical point is neither a relative minimum or maximum.
"""

# ╔═╡ dad9f05a-53a0-11ec-2863-977cad1366e3
md"""A graph verifies this:
"""

# ╔═╡ dad9f3ac-53a0-11ec-1db5-4fc6e77d00b3
plot(fx, -3pi, 3pi)

# ╔═╡ dad9f3e8-53a0-11ec-3afa-47884e0985c4
md"""We see that at $0$ and $2\pi$ there are "pauses" as the function decreases. We should also see that this pattern repeats. The critical points found by `solve` are only those within a certain domain. Any value that satisfies $\cos(x) - 1 = 0$ will be a critical point, and there are infinitely many of these of the form $n \cdot 2\pi$ for $n$ an integer.
"""

# ╔═╡ dad9f406-53a0-11ec-095d-d3f0a9fbad91
md"""As a comment, the `solveset` function, which is replacing `solve`, returns the entire collection of zeros:
"""

# ╔═╡ dad9f56e-53a0-11ec-27d7-e361e2aaa48b
solveset(fp)

# ╔═╡ dad9f5a0-53a0-11ec-14a3-097d94cff38e
md"""---
"""

# ╔═╡ dad9f5c8-53a0-11ec-3b8b-3feb6e8d925b
md"""Of course, `sign_chart` also does this, only numerically. We just need to pick an interval wide enough to contains $[0,2\pi]$
"""

# ╔═╡ dad9fcbc-53a0-11ec-079a-c372b4260fa2
sign_chart((x -> sin(x)-x)', -3pi, 3pi)

# ╔═╡ dad9fce4-53a0-11ec-19d6-bdc678b8553a
md"""##### Example
"""

# ╔═╡ dad9fd0e-53a0-11ec-10c1-2fd30e59156b
md"""Suppose you know $f'(x) = (x-1)\cdot(x-2)\cdot (x-3) = x^3 - 6x^2 + 11x - 6$ and $g'(x) = (x-1)\cdot(x-2)^2\cdot(x-3)^3 = x^6 -14x^5 +80x^4-238x^3+387x^2-324x+108$.
"""

# ╔═╡ dad9fd20-53a0-11ec-1ba5-ffc8ac7fa104
md"""How would the graphs of $f(x)$ and $g(x)$ differ, as they share identical critical points?
"""

# ╔═╡ dad9fd48-53a0-11ec-0c86-457fd21d68ac
md"""The graph of $f(x)$ - a function we do not have a formula for - can have its critical points characterized by the first derivative test. As the derivative changes sign at each, all critical points correspond to relative maxima. The sign pattern is negative/positive/negative/positive so we have from left to right a relative minimum, a relative maximum, and then a relative minimum. This is consistent with a $4$th degree polynomial with $3$ relative extrema.
"""

# ╔═╡ dad9fda0-53a0-11ec-0ba1-992a8725b864
md"""For the graph of $g(x)$ we can apply the same analysis. Thinking for a moment, we see as the factor $(x-2)^2$ comes as a power of $2$, the derivative of $g(x)$ will not change sign at $x=2$, so there is no relative extreme value there. However, at $x=3$ the factor has an odd power, so the derivative will change sign at $x=3$. So, as $g'(x)$ is positive for large *negative* values, there will be a relative maximum at $x=1$ and, as $g'(x)$ is positive for large *positive* values, a relative minimum at $x=3$.
"""

# ╔═╡ dad9fdca-53a0-11ec-0f0d-878ab011b37b
md"""The latter is consistent with a $7$th degree polynomial with positive leading coefficient. It is intuitive that since $g'(x)$ is a $6$th degree polynomial, $g(x)$ will be a $7$th degree one, as the power rule applied to a polynomial results in a polynomial of lesser degree by one.
"""

# ╔═╡ dad9fdd4-53a0-11ec-0750-c3e924221eae
md"""Here is a simple schematic that illustrates the above considerations.
"""

# ╔═╡ dad9fe12-53a0-11ec-307c-fd170f938048
md"""```
f'  -   0   +   0   -   0   +     f'-sign
    ↘       ↗       ↘       ↗     f-direction
        ∪       ∩       ∪         f-shape

g'  +   0   -   0   -   0   +     g'-sign
    ↗       ↘       ↘       ↗     g-direction
        ∩       ~       ∪         g-shape
<------ 1 ----- 2 ----- 3 ------>
```"""

# ╔═╡ dad9fe44-53a0-11ec-331a-7b7d94d84d74
md"""## Concavity
"""

# ╔═╡ dad9fe56-53a0-11ec-2085-ff0c35ba14dd
md"""Consider the function $f(x) = x^2$. Over this function we draw some secant lines for a few pairs of $x$ values:
"""

# ╔═╡ dada0234-53a0-11ec-05c4-839d84a56b66
let
	f(x) = x^2
	seca(f,a,b) = x -> f(a) + (f(b) - f(a)) / (b-a) * (x-a)
	p = plot(f, -2, 3, legend=false, linewidth=5, xlim=(-2,3), ylim=(-2, 9))
	plot!(p,seca(f, -1, 2))
	a,b = -1, 2; xs = range(a, stop=b, length=50)
	plot!(xs, seca(f, a, b).(xs), linewidth=5)
	plot!(p,seca(f, 0, 3/2))
	a,b = 0, 3/2; xs = range(a, stop=b, length=50)
	plot!(xs, seca(f, a, b).(xs), linewidth=5)
	p
end

# ╔═╡ dada025c-53a0-11ec-09f5-45ca69bd26a2
md"""The graph attempts to illustrate that for this function the secant line between any two points $a < b$ will lie above the graph over $[a,b]$.
"""

# ╔═╡ dada0270-53a0-11ec-3cc2-e378e5db74bb
md"""This is a special property not shared by all functions. Let $I$ be an open interval.
"""

# ╔═╡ dadb60d4-53a0-11ec-3c37-e17c7d116a55
md"""> **Concave up**: A function $f(x)$ is concave up on $I$ if for any $a < b$ in $I$, the secant line between $a$ and $b$ lies above the graph of $f(x)$ over $[a,b]$.

"""

# ╔═╡ dadb61ce-53a0-11ec-1613-c74e6d282b18
md"""A similar definition exists for *concave down* where the secant lines lie below the graph.  Notationally, concave up says  for any $x$ in $[a,b]$:
"""

# ╔═╡ dadb7c5e-53a0-11ec-31d5-7fbe964b9ac4
md"""```math
f(a) + (f(b) - f(a))/(b-a) \cdot (x-a) \geq f(x) \quad\text{ (concave up) }
```
"""

# ╔═╡ dadb7cfe-53a0-11ec-0046-b94687977e21
md"""Replacing $\geq$ with $\leq$ defines *concave down*, and with either $>$ or $<$ will add the prefix "strictly." These definitions are useful for a general definition of [convex functions](https://en.wikipedia.org/wiki/Convex_function).
"""

# ╔═╡ dadb7d12-53a0-11ec-0cf0-51c792b9a144
md"""We won't work with these definitions, rather we will characterize concavity for functions which have either a first or second derivative:
"""

# ╔═╡ dadb7e0e-53a0-11ec-1d20-17cd9a9dc8db
md"""> If $f'(x)$ exists and is *increasing* on $(a,b)$ then $f(x)$ is concave up on $(a,b)$. If $f'(x)$ is *decreasing* on $(a,b)$, then $f(x)$ is concave *down*.

"""

# ╔═╡ dadb7e7a-53a0-11ec-004f-8f5af5080252
md"""A proof of this makes use of the same trick used to establish the mean value theorem from Rolle's theorem. Assume $f'$ is increasing and let $g(x) = f(x) - (f(a) + M \cdot (x-a))$, where $M$ is the slope of the secant line between $a$ and $b$. By construction $g(a) = g(b) = 0$. If $f'(x)$ is increasing, then so is $g'(x) = f'(x) + M$. By its definition above, showing $f$ is concave up is the same as showing $g(x) \leq 0$. Suppose to the contrary that there is a value where $g(x) > 0$ in $[a,b]$. We show this can't be. Assuming $g'(x)$ always exists, after some work, Rolle's theorem will ensure there is a value where $g'(c) = 0$ and $(c,g(c))$ is a relative maximum, and as we know there is at least one positive value, it must be $g(c) > 0$. The first derivative test then ensures that $g'(x)$ will increase to the left of $c$ and decrease to the right of $c$, since $c$ is at a critical point and not an endpoint. But this can't happen as $g'(x)$ is assumed to be increasing on the interval.
"""

# ╔═╡ dadb7ea0-53a0-11ec-18a8-6d3efeacc057
md"""The relationship between increasing functions and their derivatives – if $f'(x) > 0 $ on $I$ it is increasing on $I$ – gives this second characterization of concavity when the second derivative exists:
"""

# ╔═╡ dadb7ee8-53a0-11ec-17e0-092f5f2885a0
md"""> If $f''(x)$ exists and is positive on $I$, then $f(x)$ is concave up on $I$.

"""

# ╔═╡ dadb7f10-53a0-11ec-1340-d5a2b7d7f992
md"""This follows,  as we can think of $f''(x)$ as just the first derivative of the function $f'(x)$, so the assumption will force $f'(x)$ to exist and be increasing, and hence $f(x)$ to be concave up.
"""

# ╔═╡ dadb7f42-53a0-11ec-0147-e94d6a3bd53f
md"""##### Example
"""

# ╔═╡ dadb7f60-53a0-11ec-2828-7d6278273158
md"""Let's look at the function $x^2 \cdot e^{-x}$ for positive $x$. A quick graph shows the function is concave up, then down, then up in the region plotted:
"""

# ╔═╡ dadb8898-53a0-11ec-3441-63961ab6d32f
begin
	h(x) = x^2 * exp(-x)
	plotif(h, h'', 0, 8)
end

# ╔═╡ dadb88fc-53a0-11ec-2234-f94d89bfb992
md"""From the graph, we would expect that the second derivative - which is continuous - would have two zeros on $[0,8]$:
"""

# ╔═╡ dadb8d98-53a0-11ec-37fd-4b4350a4d224
ips = find_zeros(h'', 0, 8)

# ╔═╡ dadb8dde-53a0-11ec-273f-1f54b61e3094
md"""As well, between the zeros we should have the sign pattern `+`, `-`, and `+`, as we verify:
"""

# ╔═╡ dadb919e-53a0-11ec-186f-839fa69a94b2
sign_chart(h'', 0, 8)

# ╔═╡ dadb91e4-53a0-11ec-0e45-0d4c2b85e37f
md"""### Second derivative test
"""

# ╔═╡ dadb923e-53a0-11ec-370c-0378ee3361ab
md"""Concave up functions are "opening" up, and often clearly $U$-shaped, though that is not necessary. At a relative minimum, where there is a $U$-shape, the graph will be concave up; conversely at a relative maximum, where the graph has a downward $\cap$-shape, the function will be concave down. This observation becomes:
"""

# ╔═╡ dadcdd6a-53a0-11ec-16f9-0f44319ab499
md"""> The **second derivative test**: If $c$ is a critical point of $f(x)$ with $f''(c)$ existing in a neighborhood of $c$, then $(c,f(c))$ will be a relative maximum if $f''(c) > 0$ and a relative minimum if $f''(c) < 0$.

"""

# ╔═╡ dadcddd6-53a0-11ec-31a9-359b1a31836c
md"""If $f''(c)$ is positive in an interval about $c$, then  $f''(c) > 0$ implies the function is concave up at $x=c$. In turn, concave up implies the derivative is increasing so must go from negative to positive at the critical point.
"""

# ╔═╡ dadcde08-53a0-11ec-34b2-bbc1c0e6e5bb
md"""The second derivative test is **inconclusive** when $f''(c)=0$. No such general statement exists, as there isn't enough information. For example, the function $f(x) = x^3$ has $0$ as a critical point, $f''(0)=0$ and the value does not correspond to a relative maximum or minimum. On the other hand $f(x)=x^4$ has $0$ as a critical point, $f''(0)=0$  is a relative minimum.
"""

# ╔═╡ dadcde46-53a0-11ec-29d8-29d3d7919348
md"""##### Example
"""

# ╔═╡ dadcde64-53a0-11ec-3069-c9c976f5853a
md"""Use the second derivative test to characterize the critical points of $j(x) = x^5 - x^4 + x^3$.
"""

# ╔═╡ dadce832-53a0-11ec-3095-7bf0ee2a3542
begin
	j(x) = x^5 - 2x^4 + x^3
	jcps = find_zeros(j', -3, 3)
end

# ╔═╡ dadce864-53a0-11ec-229b-8bf9aa44f9ba
md"""We can check the sign of the second derivative for each critical point:
"""

# ╔═╡ dadcebfc-53a0-11ec-386b-cf5715323b07
[jcps j''.(jcps)]

# ╔═╡ dadcec6a-53a0-11ec-0be7-85846383cfe3
md"""That $j''(0.6) < 0$ implies that at $0.6$, $j(x)$ will have a relative maximum. As $''(1) > 0$, the second derivative test says at $x=1$ there will be a relative minimum. That $j''(0) = 0$ says that only that there **may** be a relative maximum or minimum at $x=0$, as the second derivative test does not speak to this situation. (This last check, requiring a function evaluation to be `0`,  is susceptible to floating point errors, so isn't very robust as a general tool.)
"""

# ╔═╡ dadcec8a-53a0-11ec-3c15-11981ba00b52
md"""This should be consistent with this graph, where $-0.25$, and $1.25$ are chosen to capture the zero at $0$ and the two relative extrema:
"""

# ╔═╡ dadcf0c2-53a0-11ec-1b51-0b5044ace343
plotif(j, j'', -0.25, 1.25)

# ╔═╡ dadcf0f0-53a0-11ec-36e2-09a2a2d8b5f1
md"""For the graph we see that $0$ **is not** a relative maximum or minimum. We could have seen this numerically by checking the first derivative test, and noting there is no sign change:
"""

# ╔═╡ dadcf412-53a0-11ec-0944-45a58fbf0e14
sign_chart(j', -3, 3)

# ╔═╡ dadcf430-53a0-11ec-239b-ddec0012a4d0
md"""##### Example
"""

# ╔═╡ dadcf480-53a0-11ec-36d8-331e3649deca
md"""One way to visualize the second derivative test is to *locally* overlay on a critical point a parabola. For example, consider $f(x) = \sin(x) + \sin(2x) + \sin(3x)$ over $[0,2\pi]$. It has $6$ critical points over $[0,2\pi]$. In this graphic, we *locally* layer on $6$ parabolas:
"""

# ╔═╡ dadcfb7e-53a0-11ec-053f-093327b59cd1
let
	f(x) = sin(x) + sin(2x) + sin(3x)
	p = plot(f, 0, 2pi, legend=false, color=:blue, linewidth=3)
	cps = fzeros(f', 0, 2pi)
	h = 0.5
	for c in cps
	    parabola(x) = f(c) + (f''(c)/2) * (x-c)^2
	    plot!(parabola, c-h, c+h, color=:red, linewidth=5, alpha=0.6)
	end
	p
end

# ╔═╡ dadcfbb0-53a0-11ec-23f4-3fb9d0ff9a76
md"""The graphic shows that for this function near the relative extrema the parabolas *approximate* the function well, so that the relative extrema are characterized by the relative extrema of the parabolas.
"""

# ╔═╡ dadcfbc4-53a0-11ec-306a-21c9ebe0ac8c
md"""At each critical point $c$, the parabolas have the form
"""

# ╔═╡ dadcfc0a-53a0-11ec-31b1-37ef75b74b65
md"""```math
f(c) + \frac{f''(c)}{2}(x-c)^2.
```
"""

# ╔═╡ dadcfc78-53a0-11ec-14ee-adf1849dd122
md"""The $2$ is a mystery to be answered in the section on [Taylor series](../taylor_series_polynomials.html), the focus here is on the *sign* of $f''(c)$:
"""

# ╔═╡ dadcfdc2-53a0-11ec-1db2-3b64d365e1a6
md"""  * if $f''(c) > 0$ then the approximating parabola opens upward and the critical point is a point of relative minimum for $f$,
  * if $f''(c) < 0$ then the approximating parabola opens downward and the critical point is a point of relative maximum for $f$, and
  * were $f''(c) = 0$ then the approximating parabola is just a line – the tangent line at a critical point – and is non-informative about extrema.
"""

# ╔═╡ dadcfde0-53a0-11ec-0e60-f9f72e761ac4
md"""That is, the parabola picture is just the second derivative test in this light.
"""

# ╔═╡ dadcfe08-53a0-11ec-20bb-c3ced0378084
md"""### Inflection points
"""

# ╔═╡ dadcfe30-53a0-11ec-16e9-a351ccb27efb
md"""An inflection point is a value where the *second* derivative of $f$ changes sign. At an inflection point the derivative will change from increasing to decreasing (or vice versa) and the function will change from concave up to down (or vice versa).
"""

# ╔═╡ dadcfe58-53a0-11ec-2428-994784c26f8b
md"""We can use the `find_zeros` function to find inflection points, by passing in the second derivative function. For example, consider the bell-shaped function
"""

# ╔═╡ dadcfe6e-53a0-11ec-3d48-79ad0400c7f5
md"""```math
k(x) = e^{-x^2/2}.
```
"""

# ╔═╡ dadcfe80-53a0-11ec-09c1-cbb296eb7803
md"""A graph suggests relative a maximum at $x=0$, a horizontal asymptote of $y=0$, and two inflection points:
"""

# ╔═╡ dadd0434-53a0-11ec-2ed7-b9ed15ca3249
begin
	k(x) = exp(-x^2/2)
	plotif(k, k'', -3, 3)
end

# ╔═╡ dadd0452-53a0-11ec-219c-4b91ba023733
md"""The inflection points can be found directly, if desired, or numerically with:
"""

# ╔═╡ dadd07e2-53a0-11ec-15ec-e9bea9abbe20
find_zeros(k'', -3, 3)

# ╔═╡ dadd0830-53a0-11ec-05d4-bb9e0ec98028
md"""(The `find_zeros` function may return points which are not inflection points. It primarily returns points where $k''(x)$ changes sign, but *may* also find points where $k''(x)$ is $0$ yet does not change sign at $x$.)
"""

# ╔═╡ dadd0858-53a0-11ec-2ba8-f38560e03569
md"""##### Example
"""

# ╔═╡ dadd0862-53a0-11ec-3e09-91f3d0fbe7e5
md"""A car travels from a stop for 1 mile in 2 minutes. A graph of its position as a function of time might look like any of these graphs:
"""

# ╔═╡ dadd0d26-53a0-11ec-117b-19e8fdcb68a0
let
	v(t) = 30/60*t
	w(t) = t < 1/2 ? 0.0 : (t > 3/2 ? 1.0 : (t-1/2))
	y(t) = 1 / (1 + exp(-t))
	y1(t) = y(2(t-1))
	y2(t) = y1(t) - y1(0)
	y3(t) = 1/y2(2) * y2(t)
	plot([v, w, y3], 0, 2)
end

# ╔═╡ dadd0d6c-53a0-11ec-30f2-f3245543a017
md"""All three graphs have the same *average* velocity which is just the $1/2$ miles per minute (30 miles an hour). But the instantaneous velocity - which is given by the derivative of the position function) varies.
"""

# ╔═╡ dadd0db0-53a0-11ec-3f1d-fd602302e0db
md"""The graph `f1` has constant velocity, so the position is a straight line with slope $v_0$. The graph `f2` is similar, though for first and last 30 seconds, the car does not move, so must move faster during the time it moves. A more realistic graph would be `f3`. The position increases continuously, as do the others, but the velocity changes more gradually. The initial velocity is less than $v_0$, but eventually gets to be more than $v_0$, then velocity starts to increase less. At no point is the velocity not increasing, for `f3`, the way it is for `f2` after a minute and a half.
"""

# ╔═╡ dadd0df8-53a0-11ec-14ce-07714196cede
md"""The rate of change of the velocity is the acceleration. For `f1` this is zero, for `f2` it is zero as well - when it is defined. However, for `f3` we see the increase in velocity is positive in the first minute, but negative in the second minute. This fact relates to the concavity of the graph. As acceleration is the derivative of velocity, it is the second derivative of position - the graph we see. Where the acceleration is *positive*, the position graph will be concave *up*, where the acceleration is *negative* the graph will be concave *down*. The point $t=1$ is an inflection point, and would be felt by most riders.
"""

# ╔═╡ dadd0e20-53a0-11ec-1d24-71beb271369c
md"""## Questions
"""

# ╔═╡ dadd25d8-53a0-11ec-3f36-81d3d8afc00b
md"""###### Question
"""

# ╔═╡ dadd25fe-53a0-11ec-04b9-7f5eea91a628
md"""Consider this graph:
"""

# ╔═╡ dadd293a-53a0-11ec-2092-8bfc42e76503
plot(airyai, -5, 0)  # airyai in `SpecialFunctions` loaded with `CalculusWithJulia`

# ╔═╡ dadd295a-53a0-11ec-0314-c19d4f69f8ea
md"""On what intervals (roughly) is the function positive?
"""

# ╔═╡ dadd3042-53a0-11ec-1ed0-87598991ba75
let
	choices=[
	"(-3.2,-1)",
	"(-5, -4.2)",
	"``(-5, -4.2)`` and ``(-2.5, 0)``",
	"(-4.2, -2.5)"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ dadd3062-53a0-11ec-0f44-c51b57a1fed5
md"""###### Question
"""

# ╔═╡ dadd3074-53a0-11ec-284d-bd61722140c3
md"""Consider this graph:
"""

# ╔═╡ dadd3396-53a0-11ec-3024-d5f98913e6a3
let
	import SpecialFunctions: besselj
	p = plot(x->besselj(x, 1), -5,-3)
end

# ╔═╡ dadd33b6-53a0-11ec-3782-7566628f82ce
md"""On what intervals (roughly) is the function negative?
"""

# ╔═╡ dadd3bac-53a0-11ec-1517-6db43e859719
let
	choices=[
	"``(-5.0, -4.0)``",
	"``(-25.0, 0.0)``",
	"``(-5.0, -4.0)`` and ``(-4, -3)``",
	"``(-4.0, -3.0)``"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ dadd3bd4-53a0-11ec-17f3-379a4d0c29cf
md"""###### Question
"""

# ╔═╡ dadd3be8-53a0-11ec-1e7e-a5f140080c19
md"""Consider this graph
"""

# ╔═╡ dadd59f2-53a0-11ec-0bb2-479e45066c8e
let
	plot(x->besselj(x, 21), -5,-3)
end

# ╔═╡ dadd5a1c-53a0-11ec-0f54-a35a0ba01242
md"""On what interval(s) is this function increasing?
"""

# ╔═╡ dadd60c8-53a0-11ec-2f61-dff5ff48df5d
let
	choices=[
	"``(-5.0, -3.8)``",
	"``(-3.8, -3.0)``",
	"``(-4.7, -3.0)``",
	"``(-0.17, 0.17)``"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ dadd60f2-53a0-11ec-3d7e-519d86141459
md"""###### Question
"""

# ╔═╡ dadd60fa-53a0-11ec-2e2f-972d354f79e0
md"""Consider this graph
"""

# ╔═╡ dadd6802-53a0-11ec-2e6d-ed3de7ab1351
let
	p = plot(x -> 1 / (1+x^2), -3, 3)
end

# ╔═╡ dadd6820-53a0-11ec-0527-33b411f9252d
md"""On what interval(s) is this function concave up?
"""

# ╔═╡ dadd6e2c-53a0-11ec-1e41-ede66a182a51
let
	choices=[
	"``(0.1, 1.0)``",
	"``(-3.0, 3.0)``",
	"(-0.6, 0.6)",
	" ``(-3.0, -0.6)`` and ``(0.6, 3.0)``"
	]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ dadd6e4c-53a0-11ec-04fe-91737e2c0ab6
md"""###### Question
"""

# ╔═╡ dadd6e60-53a0-11ec-3526-9581f303c36e
md"""If it is known that:
"""

# ╔═╡ dadd6f78-53a0-11ec-09c1-2da494ab46d4
md"""  * A function $f(x)$ has critical points at $x=-1, 0, 1$
  * at $-2$ an $-1/2$ the values are: $f'(-2) = 1$ and $f'(-1/2) = -1$.
"""

# ╔═╡ dadd6f8c-53a0-11ec-0f79-e5719fd03203
md"""What can be concluded?
"""

# ╔═╡ dadd796e-53a0-11ec-27e8-d7b715c12249
let
	choices = [
	    "Nothing",
	    "That the critical point at ``-1`` is a relative maximum",
	    "That the critical point at ``-1`` is a relative minimum",
	    "That the critical point at ``0`` is a relative maximum",
	    "That the critical point at ``0`` is a relative minimum"
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ dadd798c-53a0-11ec-3755-ddbf360e0d74
md"""###### Question
"""

# ╔═╡ dadd79d2-53a0-11ec-2e76-35c66d7afa11
md"""Mystery function $f(x)$ has $f'(2) = 0$ and $f''(0) = 2$. What is the *most* you can say about $x=2$?
"""

# ╔═╡ dadd826a-53a0-11ec-2936-733cef60e766
let
	choices = [
	" ``f(x)`` is continuous at ``2``",
	" ``f(x)`` is continuous and differentiable at ``2``",
	" ``f(x)`` is continuous and differentiable at ``2`` and has a critical point",
	" ``f(x)`` is continuous and differentiable at ``2`` and has a critical point that is a relative minimum by the second derivative test"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ dadd8292-53a0-11ec-393d-171a4a044d64
md"""###### Question
"""

# ╔═╡ dadd82c4-53a0-11ec-05e9-9b3abc762f2b
md"""Find  the smallest critical point of $f(x) = x^3 e^{-x}$.
"""

# ╔═╡ dadd89a4-53a0-11ec-3a7e-e5da9cc92a0f
let
	f(x)= x^3*exp(-x)
	cps = find_zeros(D(f), -5, 10)
	val = minimum(cps)
	numericq(val)
end

# ╔═╡ dadd89c2-53a0-11ec-3c9d-071bd0a12dda
md"""###### Question
"""

# ╔═╡ dadd89ea-53a0-11ec-271b-67756baa0cf7
md"""How many critical points does $f(x) = x^5 - x + 1$ have?
"""

# ╔═╡ dadd8ed6-53a0-11ec-2f3e-a544c0809500
let
	f(x) = x^5 - x + 1
	cps = find_zeros(D(f), -3, 3)
	val = length(cps)
	numericq(val)
end

# ╔═╡ dadd8eea-53a0-11ec-3410-896a50c7eab1
md"""###### Question
"""

# ╔═╡ dadd8f08-53a0-11ec-3be4-336810150ccf
md"""How many inflection points does $f(x) = x^5 - x + 1$ have?
"""

# ╔═╡ dadd939c-53a0-11ec-3b09-2fe2027d5911
let
	f(x) = x^5 - x + 1
	cps = find_zeros(D(f,2), -3, 3)
	val = length(cps)
	numericq(val)
end

# ╔═╡ dadd93ae-53a0-11ec-2da5-7b0582812e82
md"""###### Question
"""

# ╔═╡ dadd93e0-53a0-11ec-2a4c-09099cb884b9
md"""At $c$, $f'(c) = 0$ and $f''(c) = 1 + c^2$. Is $(c,f(c))$ a relative maximum? ($f$ is a "nice" function.)
"""

# ╔═╡ dadd99bc-53a0-11ec-123a-cdadb1c97cc2
let
	choices = [
	"No, it is a relative minimum",
	"No, the second derivative test is possibly inconclusive",
	"Yes"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ dadd99da-53a0-11ec-026a-31e125dd3738
md"""###### Question
"""

# ╔═╡ dadd9a0c-53a0-11ec-15a1-3d7243234f53
md"""At $c$, $f'(c) = 0$ and $f''(c) = c^2$. Is $(c,f(c))$ a relative minimum? ($f$ is a "nice" function.)
"""

# ╔═╡ dadda038-53a0-11ec-2a59-553f6e52a260
let
	choices = [
	"No, it is a relative maximum",
	"No, the second derivative test is possibly inconclusive if ``c=0``, but otherwise yes",
	"Yes"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ dadda04c-53a0-11ec-1308-bd20fa191444
md"""###### Question
"""

# ╔═╡ dadda5ec-53a0-11ec-080b-8fb2021735f9
let
	f(x) = exp(-x) * sin(pi*x)
	plot(D(f), 0, 3)
end

# ╔═╡ dadda628-53a0-11ec-19fc-57e013a803ca
md"""The graph shows $f'(x)$. Is it possible that $f(x) = e^{-x} \sin(\pi x)$?
"""

# ╔═╡ daddac5e-53a0-11ec-065a-e5e1a5d530dc
let
	yesnoq(true)
end

# ╔═╡ daddad26-53a0-11ec-13bb-5f695e866d93
md"""(Plot $f(x)$ and compare features like critical points, increasing decreasing to that indicated by $f'$ through the graph.)
"""

# ╔═╡ daddad44-53a0-11ec-0af1-9b3f90e60521
md"""###### Question
"""

# ╔═╡ daddb51e-53a0-11ec-23ff-6fabf39e3b07
let
	f(x) = x^4 - 3x^3 - 2x + 4
	plot(D(f,2), -2, 4)
end

# ╔═╡ daddb558-53a0-11ec-264f-237d91989583
md"""The graph shows $f'(x)$. Is it possible that $f(x) = x^4 - 3x^3 - 2x + 4$?
"""

# ╔═╡ daddb776-53a0-11ec-27ce-a3e90ee357e2
let
	yesnoq("no")
end

# ╔═╡ daddb796-53a0-11ec-18c1-5fac84c466c6
md"""###### Question
"""

# ╔═╡ daddbd20-53a0-11ec-1751-1be299e14bd6
let
	f(x) = (1+x)^(-2)
	plot(D(f,2), 0,2)
end

# ╔═╡ daddbd52-53a0-11ec-23c7-e918eb3dc4e9
md"""The graph shows $f''(x)$. Is it possible that $f(x) = (1+x)^{-2}$?
"""

# ╔═╡ daddbf46-53a0-11ec-0d5f-17600cc98e13
let
	yesnoq("yes")
end

# ╔═╡ daddbf64-53a0-11ec-01c2-b51dbcf1e62e
md"""###### Question
"""

# ╔═╡ daddc982-53a0-11ec-1cb1-8d16834cad98
let
	f_p(x) = (x-1)*(x-2)^2*(x-3)^2
	plot(f_p, 0.75, 3.5)
end

# ╔═╡ daddc9b4-53a0-11ec-2cd0-8928b68ff3f0
md"""This plot shows the graph of $f'(x)$. What is true about the critical points and their characterization?
"""

# ╔═╡ daddd4c2-53a0-11ec-1e7a-edbf1afc7f77
let
	choices = [
	"The critical points are at ``x=1`` (a relative minimum), ``x=2`` (not a relative extrema), and ``x=3`` (not a relative extrema).",
	"The critical points are at ``x=1`` (a relative maximum), ``x=2`` (not a relative extrema), and ``x=3`` (not a relative extrema).",
	"The critical points are at ``x=1`` (a relative minimum), ``x=2`` (not a relative extrema), and ``x=3`` (a relative minimum).",
	"The critical points are at ``x=1`` (a relative minimum), ``x=2`` (a relative minimum), and ``x=3`` (a relative minimum).",
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ daddd508-53a0-11ec-2892-a312245ba7fc
md"""##### Question
"""

# ╔═╡ daddd530-53a0-11ec-0001-1f21f8d4cff7
md"""You know $f''(x) = (x-1)^3$. What do you know about $f(x)$?
"""

# ╔═╡ dadddd14-53a0-11ec-1f99-25513bd0d7e2
let
	choices = [
	"The function is concave down over ``(-\\infty, 1)`` and concave up over ``(1, \\infty)``",
	"The function is decreasing over ``(-\\infty, 1)`` and increasing over ``(1, \\infty)``",
	"The function is negative over ``(-\\infty, 1)`` and positive over ``(1, \\infty)``",
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ dadddd3c-53a0-11ec-2cef-eb72b55d63cd
md"""##### Question
"""

# ╔═╡ dadddd6e-53a0-11ec-0e40-37a7ebf5c5d4
md"""While driving we accelerate to get through a light before it turns red. However, at time $t_0$ a car cuts in front of us and we are forced to break. If $s(t)$ represents position, what is $t_0$:
"""

# ╔═╡ dadde4e4-53a0-11ec-14e3-6962a728d850
let
	choices = ["A zero of the function",
	"A critical point for the function",
	"An inflection point for the function"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ dadde516-53a0-11ec-08d0-616bb91e5bc9
md"""###### Question
"""

# ╔═╡ dadde55c-53a0-11ec-3c4f-432fa9e7eef8
md"""The [investopedia](https://www.investopedia.com/terms/i/inflectionpoint.asp) website describes:
"""

# ╔═╡ dadde58e-53a0-11ec-308c-5f60ac902147
md""""An **inflection point** is an event that results in a significant change in the progress of a company, industry, sector, economy, or geopolitical situation and can be considered a turning point after which a dramatic change, with either positive or negative results, is expected to result."
"""

# ╔═╡ dadde5c0-53a0-11ec-2903-c904cff19594
md"""This accurately summarizes how the term is used outside of math books. Does it also describe how the term is used *inside* math books?
"""

# ╔═╡ daddef7c-53a0-11ec-2eaf-45bfafd6a03c
let
	choices = ["Yes. Same words, same meaning",
	           """No, but it is close. An inflection point is when the *acceleration* changes from positive to negative, so if "results" are about how a company's rate of change is changing, then it is in the ballpark."""]
	radioq(choices, 2)
end

# ╔═╡ daddefa2-53a0-11ec-2fa0-b9b405e8eb00
md"""###### Question
"""

# ╔═╡ daddf07e-53a0-11ec-041f-4d39ace7f55e
md"""The function $f(x) = x^3 + x^4$ has a critical point at $0$ and a second derivative of $0$ at $x=0$. Without resorting to the first derivative test, and only considering that *near* $x=0$ the function $f(x)$ is essentially $x^3$, as $f(x) = x^3(1+x)$, what can you say about whether the critical point is a relative extrema?
"""

# ╔═╡ daddf772-53a0-11ec-2c11-8b28bc5fb64a
let
	choices = ["As ``x^3`` has no extrema at ``x=0``, neither will ``f``",
	           "As ``x^4`` is of higher degree than ``x^3``, ``f`` will be ``U``-shaped, as ``x^4`` is."]
	radioq(choices, 1)
end

# ╔═╡ daddf7fe-53a0-11ec-3905-4b2bf8b89e99
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/optimization.html">◅ previous</a>  <a href="../derivatives/curve_sketching.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/first_second_derivatives.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ daddf808-53a0-11ec-052a-5d18137bd085
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
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

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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
git-tree-sha1 = "d73736030a094e8d24fdf3629ae980217bf1d59d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.3"

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
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

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

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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
# ╟─daddf7d6-53a0-11ec-3935-9516108e2423
# ╟─dac861ca-53a0-11ec-00e1-e9d91630671e
# ╟─dac87384-53a0-11ec-0e68-934b61b1a55f
# ╟─dac87398-53a0-11ec-2848-fdba54c9e54e
# ╠═dac9fa74-53a0-11ec-1a9a-e71a48defa26
# ╟─dacb539c-53a0-11ec-052c-b5b9607ffd0e
# ╟─dacb5806-53a0-11ec-186c-0d9f07a23c5c
# ╟─dacb58ce-53a0-11ec-36f6-85b384c0336b
# ╟─dacb5a90-53a0-11ec-00ee-e7bd5ce04cbd
# ╟─dacb71b0-53a0-11ec-2424-137280855687
# ╟─dacb7214-53a0-11ec-11b1-c9c4139cf9c9
# ╟─dad14c0c-53a0-11ec-1b48-bfc9e773bc1c
# ╟─dad14cb6-53a0-11ec-0862-4d02e0a7ad82
# ╟─dad14cca-53a0-11ec-3a65-531288bb4cb5
# ╟─dad14dc6-53a0-11ec-3d12-ddf57bd96684
# ╟─dad14dec-53a0-11ec-2ccf-67fed66de92d
# ╟─dad14e14-53a0-11ec-25a9-7941830b6497
# ╟─dad28c5c-53a0-11ec-3b3e-91d9a8776254
# ╟─dad29cc4-53a0-11ec-12e7-a11df061c388
# ╟─dad29d32-53a0-11ec-0b56-b77a1ad8930a
# ╠═dad2a3a4-53a0-11ec-2f13-4ff089994706
# ╟─dad2a3d6-53a0-11ec-2790-d59120dc4e16
# ╠═dad2a822-53a0-11ec-1475-1d91cec35689
# ╟─dad2a84a-53a0-11ec-1a81-5572b07fff59
# ╟─dad2a872-53a0-11ec-3367-3f3bc3d53d89
# ╟─dad2a89a-53a0-11ec-2d1e-bfac09feda1e
# ╟─dad2a8cc-53a0-11ec-3a6d-5beeada05432
# ╟─dad2a8ea-53a0-11ec-0adb-ede3eb67dc1c
# ╟─dad2a9c8-53a0-11ec-341c-3369cbd0fc0e
# ╟─dad2a9d0-53a0-11ec-07e5-092c7e7dda1e
# ╟─dad2aa0c-53a0-11ec-3953-757902bc8af2
# ╟─dad2aa20-53a0-11ec-12a5-17a832071d93
# ╟─dad2aa34-53a0-11ec-3328-7f97f769a80d
# ╟─dad2aa66-53a0-11ec-1470-d9021e9ef98c
# ╟─dad2aa70-53a0-11ec-1ff2-2d1e25c4cd5d
# ╟─dad2aa98-53a0-11ec-094a-3d299ca9ed73
# ╟─dad2aaac-53a0-11ec-2565-cb0f2de5eb11
# ╠═dad2b34e-53a0-11ec-3f4e-19cc526e118c
# ╟─dad6e9be-53a0-11ec-0820-736078d10176
# ╟─dad6ea0e-53a0-11ec-3d79-197f50961f21
# ╟─dad6ea90-53a0-11ec-376c-5959dcbbe6c4
# ╟─dad6eaa4-53a0-11ec-0064-65375102a545
# ╟─dad6ebc4-53a0-11ec-01d5-bda25a0b4578
# ╟─dad6ec02-53a0-11ec-3af6-f564d750515a
# ╟─dad6ec52-53a0-11ec-1a2a-55c042f167f0
# ╟─dad6ec5c-53a0-11ec-10bd-531a9ec712ae
# ╟─dad6ec84-53a0-11ec-2022-4dbc39cc3876
# ╟─dad6eca2-53a0-11ec-2a8c-75e07b9ac18d
# ╟─dad6ecac-53a0-11ec-1712-69e718ffc8c6
# ╟─dad84048-53a0-11ec-1e6e-c9a533f3694d
# ╟─dad840ca-53a0-11ec-29af-6d1712367ea8
# ╟─dad84110-53a0-11ec-046b-e5997891db7c
# ╟─dad85bd2-53a0-11ec-1e51-37e9526601c0
# ╟─dad85c7a-53a0-11ec-3a54-c3e694acdd7e
# ╠═dad86834-53a0-11ec-0766-53492ec22a2f
# ╟─dad97c90-53a0-11ec-16d3-1de08d471538
# ╟─dad97d66-53a0-11ec-0274-2b46faebcacf
# ╠═dad9a5a0-53a0-11ec-32e3-7986594f7672
# ╟─dad9a5f0-53a0-11ec-2128-a16ba2e48093
# ╟─dad9a638-53a0-11ec-27de-ff91f335258c
# ╟─dad9a65e-53a0-11ec-295e-8df76fb79d66
# ╠═dad9b036-53a0-11ec-0e95-5718b6659e14
# ╟─dad9b070-53a0-11ec-30f3-5909bb49719d
# ╠═dad9b6a8-53a0-11ec-0be3-9d6a470756f5
# ╟─dad9b6e6-53a0-11ec-2644-d3ae1de1a193
# ╟─dad9b720-53a0-11ec-0d0a-bfe86ba450f8
# ╟─dad9b734-53a0-11ec-138e-47a0fd3fd230
# ╟─dad9b752-53a0-11ec-1816-67848be7e9a7
# ╟─dad9b770-53a0-11ec-32f0-87e7a7b304c8
# ╠═dad9bd8a-53a0-11ec-0159-33b103826ded
# ╟─dad9bdc4-53a0-11ec-22be-7f935e30220e
# ╟─dad9bdd8-53a0-11ec-1765-5356cb2ae432
# ╠═dad9c42c-53a0-11ec-0a9a-2ba25a4e6a03
# ╟─dad9c44a-53a0-11ec-26a8-95b0946e138f
# ╟─dad9d75a-53a0-11ec-2b02-3d266ca0ec71
# ╟─dad9d7a0-53a0-11ec-103d-8f5d36290925
# ╠═dad9db38-53a0-11ec-1e5f-0da7758d749a
# ╟─dad9db56-53a0-11ec-0afb-8945374e2e2d
# ╠═dad9de6c-53a0-11ec-1686-69fac602cd4d
# ╟─dad9dea8-53a0-11ec-2e4f-0b911c05e4df
# ╠═dad9e11e-53a0-11ec-2696-1b2ecb46c9e8
# ╟─dad9e15a-53a0-11ec-1b08-1fe98ee214d4
# ╟─dad9e16e-53a0-11ec-3424-cfba3192f700
# ╟─dad9e18c-53a0-11ec-35d7-f92ed4cf72ee
# ╟─dad9e196-53a0-11ec-193c-e52e178c9c30
# ╠═dad9e4b4-53a0-11ec-3229-9199c1168f39
# ╟─dad9e4de-53a0-11ec-0673-1b5192699ee1
# ╟─dad9e4f2-53a0-11ec-21f4-452137c3a776
# ╠═dad9e9ac-53a0-11ec-0823-a9dc1c5eb5ab
# ╟─dad9e9d4-53a0-11ec-0e58-194745538589
# ╟─dad9e9e8-53a0-11ec-3cd9-0ff2fae869fc
# ╠═dad9f01e-53a0-11ec-28c4-6101360d572b
# ╟─dad9f050-53a0-11ec-13da-df56ac1d3460
# ╟─dad9f05a-53a0-11ec-2863-977cad1366e3
# ╠═dad9f3ac-53a0-11ec-1db5-4fc6e77d00b3
# ╟─dad9f3e8-53a0-11ec-3afa-47884e0985c4
# ╟─dad9f406-53a0-11ec-095d-d3f0a9fbad91
# ╠═dad9f56e-53a0-11ec-27d7-e361e2aaa48b
# ╟─dad9f5a0-53a0-11ec-14a3-097d94cff38e
# ╟─dad9f5c8-53a0-11ec-3b8b-3feb6e8d925b
# ╠═dad9fcbc-53a0-11ec-079a-c372b4260fa2
# ╟─dad9fce4-53a0-11ec-19d6-bdc678b8553a
# ╟─dad9fd0e-53a0-11ec-10c1-2fd30e59156b
# ╟─dad9fd20-53a0-11ec-1ba5-ffc8ac7fa104
# ╟─dad9fd48-53a0-11ec-0c86-457fd21d68ac
# ╟─dad9fda0-53a0-11ec-0ba1-992a8725b864
# ╟─dad9fdca-53a0-11ec-0f0d-878ab011b37b
# ╟─dad9fdd4-53a0-11ec-0750-c3e924221eae
# ╟─dad9fe12-53a0-11ec-307c-fd170f938048
# ╟─dad9fe44-53a0-11ec-331a-7b7d94d84d74
# ╟─dad9fe56-53a0-11ec-2085-ff0c35ba14dd
# ╟─dada0234-53a0-11ec-05c4-839d84a56b66
# ╟─dada025c-53a0-11ec-09f5-45ca69bd26a2
# ╟─dada0270-53a0-11ec-3cc2-e378e5db74bb
# ╟─dadb60d4-53a0-11ec-3c37-e17c7d116a55
# ╟─dadb61ce-53a0-11ec-1613-c74e6d282b18
# ╟─dadb7c5e-53a0-11ec-31d5-7fbe964b9ac4
# ╟─dadb7cfe-53a0-11ec-0046-b94687977e21
# ╟─dadb7d12-53a0-11ec-0cf0-51c792b9a144
# ╟─dadb7e0e-53a0-11ec-1d20-17cd9a9dc8db
# ╟─dadb7e7a-53a0-11ec-004f-8f5af5080252
# ╟─dadb7ea0-53a0-11ec-18a8-6d3efeacc057
# ╟─dadb7ee8-53a0-11ec-17e0-092f5f2885a0
# ╟─dadb7f10-53a0-11ec-1340-d5a2b7d7f992
# ╟─dadb7f42-53a0-11ec-0147-e94d6a3bd53f
# ╟─dadb7f60-53a0-11ec-2828-7d6278273158
# ╠═dadb8898-53a0-11ec-3441-63961ab6d32f
# ╟─dadb88fc-53a0-11ec-2234-f94d89bfb992
# ╠═dadb8d98-53a0-11ec-37fd-4b4350a4d224
# ╟─dadb8dde-53a0-11ec-273f-1f54b61e3094
# ╠═dadb919e-53a0-11ec-186f-839fa69a94b2
# ╟─dadb91e4-53a0-11ec-0e45-0d4c2b85e37f
# ╟─dadb923e-53a0-11ec-370c-0378ee3361ab
# ╟─dadcdd6a-53a0-11ec-16f9-0f44319ab499
# ╟─dadcddd6-53a0-11ec-31a9-359b1a31836c
# ╟─dadcde08-53a0-11ec-34b2-bbc1c0e6e5bb
# ╟─dadcde46-53a0-11ec-29d8-29d3d7919348
# ╟─dadcde64-53a0-11ec-3069-c9c976f5853a
# ╠═dadce832-53a0-11ec-3095-7bf0ee2a3542
# ╟─dadce864-53a0-11ec-229b-8bf9aa44f9ba
# ╠═dadcebfc-53a0-11ec-386b-cf5715323b07
# ╟─dadcec6a-53a0-11ec-0be7-85846383cfe3
# ╟─dadcec8a-53a0-11ec-3c15-11981ba00b52
# ╠═dadcf0c2-53a0-11ec-1b51-0b5044ace343
# ╟─dadcf0f0-53a0-11ec-36e2-09a2a2d8b5f1
# ╠═dadcf412-53a0-11ec-0944-45a58fbf0e14
# ╟─dadcf430-53a0-11ec-239b-ddec0012a4d0
# ╟─dadcf480-53a0-11ec-36d8-331e3649deca
# ╠═dadcfb7e-53a0-11ec-053f-093327b59cd1
# ╟─dadcfbb0-53a0-11ec-23f4-3fb9d0ff9a76
# ╟─dadcfbc4-53a0-11ec-306a-21c9ebe0ac8c
# ╟─dadcfc0a-53a0-11ec-31b1-37ef75b74b65
# ╟─dadcfc78-53a0-11ec-14ee-adf1849dd122
# ╟─dadcfdc2-53a0-11ec-1db2-3b64d365e1a6
# ╟─dadcfde0-53a0-11ec-0e60-f9f72e761ac4
# ╟─dadcfe08-53a0-11ec-20bb-c3ced0378084
# ╟─dadcfe30-53a0-11ec-16e9-a351ccb27efb
# ╟─dadcfe58-53a0-11ec-2428-994784c26f8b
# ╟─dadcfe6e-53a0-11ec-3d48-79ad0400c7f5
# ╟─dadcfe80-53a0-11ec-09c1-cbb296eb7803
# ╠═dadd0434-53a0-11ec-2ed7-b9ed15ca3249
# ╟─dadd0452-53a0-11ec-219c-4b91ba023733
# ╠═dadd07e2-53a0-11ec-15ec-e9bea9abbe20
# ╟─dadd0830-53a0-11ec-05d4-bb9e0ec98028
# ╟─dadd0858-53a0-11ec-2ba8-f38560e03569
# ╟─dadd0862-53a0-11ec-3e09-91f3d0fbe7e5
# ╟─dadd0d26-53a0-11ec-117b-19e8fdcb68a0
# ╟─dadd0d6c-53a0-11ec-30f2-f3245543a017
# ╟─dadd0db0-53a0-11ec-3f1d-fd602302e0db
# ╟─dadd0df8-53a0-11ec-14ce-07714196cede
# ╟─dadd0e20-53a0-11ec-1d24-71beb271369c
# ╟─dadd25d8-53a0-11ec-3f36-81d3d8afc00b
# ╟─dadd25fe-53a0-11ec-04b9-7f5eea91a628
# ╠═dadd293a-53a0-11ec-2092-8bfc42e76503
# ╟─dadd295a-53a0-11ec-0314-c19d4f69f8ea
# ╟─dadd3042-53a0-11ec-1ed0-87598991ba75
# ╟─dadd3062-53a0-11ec-0f44-c51b57a1fed5
# ╟─dadd3074-53a0-11ec-284d-bd61722140c3
# ╟─dadd3396-53a0-11ec-3024-d5f98913e6a3
# ╟─dadd33b6-53a0-11ec-3782-7566628f82ce
# ╟─dadd3bac-53a0-11ec-1517-6db43e859719
# ╟─dadd3bd4-53a0-11ec-17f3-379a4d0c29cf
# ╟─dadd3be8-53a0-11ec-1e7e-a5f140080c19
# ╟─dadd59f2-53a0-11ec-0bb2-479e45066c8e
# ╟─dadd5a1c-53a0-11ec-0f54-a35a0ba01242
# ╟─dadd60c8-53a0-11ec-2f61-dff5ff48df5d
# ╟─dadd60f2-53a0-11ec-3d7e-519d86141459
# ╟─dadd60fa-53a0-11ec-2e2f-972d354f79e0
# ╟─dadd6802-53a0-11ec-2e6d-ed3de7ab1351
# ╟─dadd6820-53a0-11ec-0527-33b411f9252d
# ╟─dadd6e2c-53a0-11ec-1e41-ede66a182a51
# ╟─dadd6e4c-53a0-11ec-04fe-91737e2c0ab6
# ╟─dadd6e60-53a0-11ec-3526-9581f303c36e
# ╟─dadd6f78-53a0-11ec-09c1-2da494ab46d4
# ╟─dadd6f8c-53a0-11ec-0f79-e5719fd03203
# ╟─dadd796e-53a0-11ec-27e8-d7b715c12249
# ╟─dadd798c-53a0-11ec-3755-ddbf360e0d74
# ╟─dadd79d2-53a0-11ec-2e76-35c66d7afa11
# ╟─dadd826a-53a0-11ec-2936-733cef60e766
# ╟─dadd8292-53a0-11ec-393d-171a4a044d64
# ╟─dadd82c4-53a0-11ec-05e9-9b3abc762f2b
# ╟─dadd89a4-53a0-11ec-3a7e-e5da9cc92a0f
# ╟─dadd89c2-53a0-11ec-3c9d-071bd0a12dda
# ╟─dadd89ea-53a0-11ec-271b-67756baa0cf7
# ╟─dadd8ed6-53a0-11ec-2f3e-a544c0809500
# ╟─dadd8eea-53a0-11ec-3410-896a50c7eab1
# ╟─dadd8f08-53a0-11ec-3be4-336810150ccf
# ╟─dadd939c-53a0-11ec-3b09-2fe2027d5911
# ╟─dadd93ae-53a0-11ec-2da5-7b0582812e82
# ╟─dadd93e0-53a0-11ec-2a4c-09099cb884b9
# ╟─dadd99bc-53a0-11ec-123a-cdadb1c97cc2
# ╟─dadd99da-53a0-11ec-026a-31e125dd3738
# ╟─dadd9a0c-53a0-11ec-15a1-3d7243234f53
# ╟─dadda038-53a0-11ec-2a59-553f6e52a260
# ╟─dadda04c-53a0-11ec-1308-bd20fa191444
# ╟─dadda5ec-53a0-11ec-080b-8fb2021735f9
# ╟─dadda628-53a0-11ec-19fc-57e013a803ca
# ╟─daddac5e-53a0-11ec-065a-e5e1a5d530dc
# ╟─daddad26-53a0-11ec-13bb-5f695e866d93
# ╟─daddad44-53a0-11ec-0af1-9b3f90e60521
# ╟─daddb51e-53a0-11ec-23ff-6fabf39e3b07
# ╟─daddb558-53a0-11ec-264f-237d91989583
# ╟─daddb776-53a0-11ec-27ce-a3e90ee357e2
# ╟─daddb796-53a0-11ec-18c1-5fac84c466c6
# ╟─daddbd20-53a0-11ec-1751-1be299e14bd6
# ╟─daddbd52-53a0-11ec-23c7-e918eb3dc4e9
# ╟─daddbf46-53a0-11ec-0d5f-17600cc98e13
# ╟─daddbf64-53a0-11ec-01c2-b51dbcf1e62e
# ╟─daddc982-53a0-11ec-1cb1-8d16834cad98
# ╟─daddc9b4-53a0-11ec-2cd0-8928b68ff3f0
# ╟─daddd4c2-53a0-11ec-1e7a-edbf1afc7f77
# ╟─daddd508-53a0-11ec-2892-a312245ba7fc
# ╟─daddd530-53a0-11ec-0001-1f21f8d4cff7
# ╟─dadddd14-53a0-11ec-1f99-25513bd0d7e2
# ╟─dadddd3c-53a0-11ec-2cef-eb72b55d63cd
# ╟─dadddd6e-53a0-11ec-0e40-37a7ebf5c5d4
# ╟─dadde4e4-53a0-11ec-14e3-6962a728d850
# ╟─dadde516-53a0-11ec-08d0-616bb91e5bc9
# ╟─dadde55c-53a0-11ec-3c4f-432fa9e7eef8
# ╟─dadde58e-53a0-11ec-308c-5f60ac902147
# ╟─dadde5c0-53a0-11ec-2903-c904cff19594
# ╟─daddef7c-53a0-11ec-2eaf-45bfafd6a03c
# ╟─daddefa2-53a0-11ec-2fa0-b9b405e8eb00
# ╟─daddf07e-53a0-11ec-041f-4d39ace7f55e
# ╟─daddf772-53a0-11ec-2c11-8b28bc5fb64a
# ╟─daddf7fe-53a0-11ec-3905-4b2bf8b89e99
# ╟─daddf7fe-53a0-11ec-314f-e327c02ee240
# ╟─daddf808-53a0-11ec-052a-5d18137bd085
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
