### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 37578f7c-53a1-11ec-10bb-5dfeb8ac2d06
begin
	using CalculusWithJulia
	using Plots
	using ImplicitEquations
	using Roots
	using SymPy
end

# ╔═╡ 375797d8-53a1-11ec-337a-85df11f78553
begin
	using CalculusWithJulia.WeaveSupport
	nothing
end

# ╔═╡ 3763268e-53a1-11ec-276a-2514bbb44cca
using PlutoUI

# ╔═╡ 3763262a-53a1-11ec-0545-cfa4d9b6d305
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 3756be0a-53a1-11ec-015f-6389c05a338b
md"""# Derivative free alternatives to Newton's method
"""

# ╔═╡ 3756c0f6-53a1-11ec-0880-49fbc5d7d7b4
md"""This section uses these add-on packages:
"""

# ╔═╡ 3757c53c-53a1-11ec-0052-a1578feca029
md"""---
"""

# ╔═╡ 3757c578-53a1-11ec-3ea3-d9cb854035ac
md"""Newton's method is not the only algorithm of its kind for identifying zeros of a function. In this section we discuss some alternatives.
"""

# ╔═╡ 3757ca78-53a1-11ec-1410-57b43927bc16
md"""## `find_zero(f, x0)`
"""

# ╔═╡ 3757cc30-53a1-11ec-1e2e-f1ae013250b7
md"""The  function `find_zero` from the `Roots` packages provides several different algorithms for finding a zero of a function, including some a derivative-free algorithms for finding roots  when started with an initial guess. The default method is similar to Newton's method in that only a good initial guess is needed. However, the algorithm, while slower in terms of function evaluations and steps,  is engineered to be a bit more robust to the choice of initial estimate than Newton's method. (If it finds a bracket, it will use a bisection algorithm which is guaranteed to converge, but can be slower to do so.) Here we see how to call the function:
"""

# ╔═╡ 37580b6e-53a1-11ec-059a-c908e6b5d579
begin
	f(x) = cos(x) - x
	x₀ = 1
	find_zero(f, x₀)
end

# ╔═╡ 37580c36-53a1-11ec-2eaf-f514495fbe3a
md"""Compare to this related call which uses the bisection method:
"""

# ╔═╡ 37582e96-53a1-11ec-2e1b-9f74c2489f26
find_zero(f, (0, 1))           ## [0,1] must be a bracketing interval

# ╔═╡ 37582f0e-53a1-11ec-1e99-b510b9c9aeb7
md"""For this example both give the same answer, but the bisection method is a bit less convenient as a bracketing interval must be pre-specified.
"""

# ╔═╡ 37582f72-53a1-11ec-33e5-dd82cfbab08d
md"""## The secant method
"""

# ╔═╡ 37582ffe-53a1-11ec-183b-39cc6664c7fb
md"""The default `find_zero` method above uses a secant-like method unless a bracketing method is found. Here we place the secant method into a more general framework.
"""

# ╔═╡ 37583206-53a1-11ec-25f1-b500bc487f36
md"""One way to view Newton's method is through the inverse of $f$, as if $f(\alpha) = 0$ then – when $f^{-1}(x)$ exists – $\alpha = f^{-1}(0)$. If $f$ has a simple zero at $\alpha$ and is locally invertible (that is some $f^{-1}$ exists) then the update step for Newton's method can be identified with: fitting a polynomial to the local inverse function of $f$ going through through the point $(f(x_0),x_0)$,  and matching the slope of `f` at the same point.
"""

# ╔═╡ 3758326a-53a1-11ec-246b-357705547636
md"""That is, we can write $g(y) = h_0 + h_1 (y-f(x_0))$. Then $g(f(x0)) = x0 = h_0$, so $h_0 = x_0$, and from $g'(f(x_0)) = 1/f'(x_0)$, we get $h_1 = 1/f'(x_0)$, so $g(y) = x_0 + (y-f(x_0))/f'(x_0)$. At $y=0$, we get the update step $x_1 = g(0) = x_0 - f(x_0)/f'(x_0)$.
"""

# ╔═╡ 375832f8-53a1-11ec-1269-6b55b798d4c7
md"""The same viewpoint can be used  to create derivative-free methods.
"""

# ╔═╡ 3758349a-53a1-11ec-320e-6ba795154365
md"""For example, the  [secant method](https://en.wikipedia.org/wiki/Secant_method) can be seen as the result of fitting a polynomial approximation for  $f^{-1}$ through two points $(f(x_0),x_0)$ and $(f(x_1), x_1)$.
"""

# ╔═╡ 37583596-53a1-11ec-1e57-89655b9cd782
md"""Again, expressing this as $g(y) = h_0 + h_1(y-f(x_1))$ leads to $g(f(x_1)) = x_1 = h_0$. Substituting $f(x_0)$ gives $g(f(x_0)) = x_0 = x_1 + h_1(f(x_0)-f(x_1))$.  Solving for $h_1$ leads to $h_1=(x_1-x_0)/(f(x_1)-f(x_0))$. Then $x_2 = g(0) = x_1 + (x_1-x_0)/(f(x_1)-f(x_0)) \cdot f(x_1)$. This is the first step of the secant method:
"""

# ╔═╡ 37583a4e-53a1-11ec-3330-f75a31e27d80
md"""```math
x_{n+1} = x_n - f(x_n) \frac{x_n - x_{n-1}}{f(x_n) - f(x_{n-1})}.
```
"""

# ╔═╡ 37583a76-53a1-11ec-175d-57ccfcd724a3
md"""The secant method simply replaces $f'(x_n)$ with the slope of the secant line between $x_n$ and $x_{n-1}$. The method is historic, dating back over $3000$ years.
"""

# ╔═╡ 37583ada-53a1-11ec-08e4-75c2e50fda6c
md"""We code the update step as `λ2`:
"""

# ╔═╡ 37589c78-53a1-11ec-0623-07fd17ca0355
λ2(f0,f1,x0,x1) = x1 - f1 * (x1-x0)/(f1-f0)

# ╔═╡ 37589ce8-53a1-11ec-0d60-4304eb06788b
md"""Then we can run a few steps to identify the zero of sine starting at $3$ and $4$
"""

# ╔═╡ 37593976-53a1-11ec-1ed7-cb731f7c7db9
let
	with_terminal() do
		x0,x1 = 4,3
		f0,f1 = sin.((x0,x1))
		@show x1,f1
		
		x0,x1 = x1, λ2(f0,f1,x0,x1)
		f0,f1 = f1, sin(x1)
		@show x1,f1
		
		x0,x1 = x1, λ2(f0,f1,x0,x1)
		f0,f1 = f1, sin(x1)
		@show x1,f1
		
		x0,x1 = x1, λ2(f0,f1,x0,x1)
		f0,f1 = f1, sin(x1)
		@show x1,f1
		
		x0,x1 = x1, λ2(f0,f1,x0,x1)
		f0,f1 = f1, sin(x1)
		x1,f1
	end
end

# ╔═╡ 37593a0c-53a1-11ec-0ac5-29f917a962ad
md"""Like Newton's method, the secant method coverges quickly for this problem (though its rate is less than the quadratic rate of Newton's method.)
"""

# ╔═╡ 37593aca-53a1-11ec-0f3b-4138b41b9ee0
md"""This method is included in `Roots` as `Secant()` (or `Order1()`):
"""

# ╔═╡ 37595a16-53a1-11ec-1bce-073add297187
find_zero(sin, (4,3), Secant(), verbose=true)

# ╔═╡ 37595b2c-53a1-11ec-2dc5-157396003282
md"""Though the derivative is related to the slope of the secant line, that is in the limit. The convergence of the secant method is not as fast as Newton's method, though at each step of the secant method, only $1$ new function evaluation is needed, so it can be more efficient for functions that are expensive to compute or differentiate.
"""

# ╔═╡ 37595ce6-53a1-11ec-3674-3f5c29b791d5
md"""Let $\epsilon_{n+1} = x_{n+1}-\alpha$, where $\alpha$ is assumed to be a *simple* zero of $f(x)$ that the secant method converges to. A [calculation](https://math.okstate.edu/people/binegar/4513-F98/4513-l08.pdf) shows that
"""

# ╔═╡ 37595d98-53a1-11ec-0bc5-6bc570b97566
md"""```math
\begin{align*}
\epsilon_{n+1} &\approx \frac{x_n-x_{n-1}}{f(x_n)-f(x_{n-1})} \frac{(1/2)f''(\alpha)(e_n-e_{n-1})}{x_n-x_{n-1}} \epsilon_n \epsilon_{n-1}\\
& \approx \frac{f''(\alpha)}{2f'(\alpha)} \epsilon_n \epsilon_{n-1}\\
&= C  \epsilon_n \epsilon_{n-1}.
\end{align*}
```
"""

# ╔═╡ 37595dc0-53a1-11ec-36b7-af29b6996067
md"""The constant `C` is similar to that for Newton's method, and reveals potential troubles for the secant method similar to those of Newton's method: a poor initial guess (the initial error is too big), the second derivative is too large, the first derivative too flat near the answer.
"""

# ╔═╡ 37595dde-53a1-11ec-2ec1-31083ac38083
md"""Assuming the error term has the form $\epsilon_{n+1} = A|\epsilon_n|^\phi$ and substituting into the above leads to the equation
"""

# ╔═╡ 37595e24-53a1-11ec-10af-915f6f2020f8
md"""```math
\frac{A^{1-1/\phi}}{C} = |\epsilon_n|^{1 - \phi +1/\phi}.
```
"""

# ╔═╡ 37595e4e-53a1-11ec-257c-61f4b56e7b4a
md"""The left side being a constant suggests $\phi$ solves: $1 - \phi + 1/\phi = 0$ or $\phi^2 -\phi - 1 = 0$. The solution is the golden ratio, $(1 + \sqrt{5})/2 \approx 1.618\dots$.
"""

# ╔═╡ 3759830e-53a1-11ec-1144-57f71c8177bb
md"""### Steffensen's method
"""

# ╔═╡ 37598450-53a1-11ec-2644-15eaf515d1ca
md"""Steffensen's method is a secant-like method that converges with $|\epsilon_{n+1}| \approx C |\epsilon_n|^2$. The secant is taken between the points $(x_n,f(x_n))$ and  $(x_n + f(x_n), f(x_n + f(x_n))$. Like Newton's method this requires 2 function evaluations per step. Steffensen's is implemented through `Roots.Steffensen()`.
"""

# ╔═╡ 37598476-53a1-11ec-0814-43b92e8a9cb0
md"""## Inverse quadratic interpolation
"""

# ╔═╡ 3759848a-53a1-11ec-3dd3-2fa1ba25950c
md"""Inverse quadratic interpolation fits a quadratic polynomial through three points, not just two like the Secant method. The third being $(f(x_2), x_2)$.
"""

# ╔═╡ 37598502-53a1-11ec-18b4-c3b5dbf74b83
md"""For example, here is the inverse quadratic function, $g(y)$, going through three points marked with red dots. The blue dot is found from $(g(0), 0)$.
"""

# ╔═╡ 37598e6c-53a1-11ec-19c4-1ff480d798ca
let
	a,b,c = 1,2,3
	fa,fb,fc = -1,1/4,1
	g(y) = (y-fb)*(y-fa)/(fc-fb)/(fc-fa)*c + (y-fc)*(y-fa)/(fb-fc)/(fb-fa)*b + (y-fc)*(y-fb)/(fa-fc)/(fa-fb)*a
	ys = range(-2,2, length=100)
	xs = g.(ys)
	plot(xs, ys, legend=false)
	scatter!([a,b,c],[fa,fb,fc], color=:red, markersize=5)
	scatter!([g(0)],[0], color=:blue, markersize=5)
	plot!(zero, color=:blue)
end

# ╔═╡ 37598f02-53a1-11ec-02ea-454c08e2cd4d
md"""Here we use `SymPy` to identify the polynomial as a function of $y$, then evaluate it at $y=0$ to find the next step:
"""

# ╔═╡ 3759b7a2-53a1-11ec-248c-bfb258562021
begin
	@syms y hs[0:2] xs[0:2] fs[0:2]
	H(y) = sum(hᵢ*(y - fs[end])^i for (hᵢ,i) ∈ zip(hs, 0:2))
	
	eqs = [H(fᵢ) ~ xᵢ for (xᵢ, fᵢ) ∈ zip(xs, fs)]
	ϕ = solve(eqs, hs)
	hy = subs(H(y), ϕ)
end

# ╔═╡ 3759b874-53a1-11ec-0141-296000213c1d
md"""The value of `hy` at $y=0$ yields the next guess based on the past three, and is given by:
"""

# ╔═╡ 3759e984-53a1-11ec-36d1-d5752dc1d053
q⁻¹ = hy(y => 0)

# ╔═╡ 3759ea24-53a1-11ec-075d-c5fef8676e58
md"""Though the above can be simplified quite a bit when computed by hand, here we simply make this a function with `lambdify` which we will use below.
"""

# ╔═╡ 375a0a5e-53a1-11ec-0a2c-a397f1903017
λ3 = lambdify(q⁻¹) # fs, then xs

# ╔═╡ 375a0b26-53a1-11ec-1275-938b46b5b8c0
md"""(`SymPy`'s `lambdify` function, by default, picks the order of its argument lexicographically, in this case they will be the `f` values then the `x` values.)
"""

# ╔═╡ 375a0c04-53a1-11ec-08fb-b5f40d3855c6
md"""An inverse quadratic step is utilized by Brent's method, as possible, to yield a rapidly convergent bracketing algorithm implemented as a default zero finder in many software languages.  `Julia`'s `Roots` package implements the method in `Roots.Brent()`. An inverse cubic interpolation is utilized by [Alefeld, Potra, and Shi](https://dl.acm.org/doi/10.1145/210089.210111) which gives an asymptotically even more rapidly convergent algorithm then Brent's (implemented in `Roots.AlefeldPotraShi()` and also `Roots.A42()`). This is used as a finishing step in many cases by the default hybrid `Order0()` method of `find_zero`.
"""

# ╔═╡ 375a0c5c-53a1-11ec-2396-59a0e22ce116
md"""In a bracketing algorithm, the next step should reduce the size of the bracket, so the next iterate should be inside the current bracket. However, quadratic convergence does not guarantee this to happen. As such, sometimes a subsitute method must be chosen.
"""

# ╔═╡ 375e3930-53a1-11ec-3142-8b17b31e2786
md"""[Chandrapatlu's](https://www.google.com/books/edition/Computational_Physics/cC-8BAAAQBAJ?hl=en&gbpv=1&pg=PA95&printsec=frontcover) method, is a bracketing method utilizing an inverse quadratic step as the centerpiece. The key insight is the test to choose between this inverse quadratic step and a bisection step. This is done in the following based on values of $\xi$ and $\Phi$ defined within:
"""

# ╔═╡ 375ee222-53a1-11ec-0420-c7007aebf9cc
function chandrapatlu(f, u, v, λ; verbose=false)
    a,b = promote(float(u), float(v))
    fa,fb = f(a),f(b)
    @assert fa * fb < 0

    if abs(fa) < abs(fb)
        a,b,fa,fb = b,a,fb,fa
    end

    c, fc = a, fa

    maxsteps = 100
    for ns in 1:maxsteps

        Δ = abs(b-a)
        ϵ = max(eps(a),eps(b))
        if Δ < 2ϵ
          return abs(fa) < abs(fb) ? a : b
        end
        abs(fa) < ϵ && return a

        ξ = (a-b)/(c-b)
        Φ = (fa-fb)/(fc-fb)

        if Φ^2 < ξ < 1 - (1-Φ)^2
            xt = λ(fa,fc,fb, a,c,b) # inverse quadratic
        else
            xt = a + (b-a)/2
        end

        ft = f(xt)

        isnan(ft) && break

        if sign(fa) == sign(ft)
            c,fc = a,fa
            a,fa = xt,ft
        else
            c,b,a = b,a,xt
            fc,fb,fa = fb,fa,ft
        end

    	verbose && @show ns, a, fa

    end
    error("no convergence: [a,b] = $(sort([a,b]))")
end

# ╔═╡ 375ee32e-53a1-11ec-099c-f94e3a51084f
md"""Like bisection, this method ensures that $a$ and $b$ is a bracket, but it moves $a$ to the newest estimate, so does not maintain that $a < b$ throughout.
"""

# ╔═╡ 375ee40c-53a1-11ec-3b37-21ed346484b9
md"""We can see it in action on the sine function.   Here we pass in $\lambda$, but in a real implementation we would have programmed the algorithm to compute the inverse quadratic value.
"""

# ╔═╡ 375eeab0-53a1-11ec-0726-9fb870b74241
with_terminal() do
	chandrapatlu(sin, 3, 4,  λ3, verbose=true)
end

# ╔═╡ 375eeb1e-53a1-11ec-01f1-17f2d6634748
md"""The condition `Φ^2 < ξ < 1 - (1-Φ)^2` can be visualized. Assume `a,b=0,1`, `fa,fb=-1/2,1`, Then `c < a < b`, and `fc` has the same sign as `fa`, but what values of `fc` will satisfy the inequality?
"""

# ╔═╡ 375ef3a2-53a1-11ec-39af-4f58ecc54e70
begin
	ξ(c,fc) = (a-b)/(c-b)
	Φ(c,fc) = (fa-fb)/(fc-fb)
	Φl(c,fc) = Φ(c,fc)^2
	Φr(c,fc) = 1 - (1-Φ(c,fc))^2
	a,b = 0, 1
	fa,fb = -1/2, 1
	region = Lt(Φl, ξ) & Lt(ξ,Φr)
	plot(region, xlims=(-2,a), ylims=(-3,0))
end

# ╔═╡ 375ef44c-53a1-11ec-10bf-418f1919bd1f
md"""When `(c,fc)` is in the shaded area, the inverse quadratic step is chosen. We can see that `fc < fa` is needed.
"""

# ╔═╡ 375ef474-53a1-11ec-03d4-c5af5545ce17
md"""For these values, this area is within the area where a implicit quadratic step will result in a value between `a` and `b`:
"""

# ╔═╡ 375f17ba-53a1-11ec-283e-1d3b3c5d5231
begin
	l(c,fc) = λ3(fa,fb,fc,a,b,c)
	region₃ = ImplicitEquations.Lt(l,b) & ImplicitEquations.Gt(l,a)
	plot(region₃, xlims=(-2,0), ylims=(-3,0))
end

# ╔═╡ 375f1800-53a1-11ec-3b4d-4f93ef8fd5ef
md"""There are values in the parameter space where this does not occur.
"""

# ╔═╡ 375f1b52-53a1-11ec-04ad-7d870aab8c47
md"""## Tolerances
"""

# ╔═╡ 375f1d00-53a1-11ec-0554-89e1a5805809
md"""The `chandrapatlu` algorithm typically waits until `abs(b-a) <= 2max(eps(a),eps(b))` is satisfied. Informally this means the algorithm stops when the two bracketing values are no more than a small amount apart. What is a "small amount?"
"""

# ╔═╡ 375f1d1e-53a1-11ec-3df9-2b814904e18c
md"""To understand, we start with the fact that floating point numbers are an approximation to real numbers.
"""

# ╔═╡ 375f1d84-53a1-11ec-170d-5f3cb4ffaf12
md"""Floating point numbers effectively represent a number in scientific notation in terms of
"""

# ╔═╡ 375f3464-53a1-11ec-251f-99bf4166dd3e
md"""  * a sign (plus or minus) ,
  * a *mantissa* (a number in $[1,2)$, in binary ), and
  * an exponent (to represent a power of $2$).
"""

# ╔═╡ 375f36be-53a1-11ec-1da4-813a5a11141c
md"""The mantissa is of the form `1.xxxxx...xxx` where there are $m$ different `x`s each possibly a `0` or `1`. The `i`th `x` indicates if the term `1/2^i` should be included in the value.  The mantissa is the sum of `1` plus the indicated values of `1/2^i` for `i` in `1` to `m`. So the last `x` represents if `1/2^m` should be included in the sum. As such, the mantissa represents a discrete set of values, separated by `1/2^m`, as that is the smallest difference possible.
"""

# ╔═╡ 375f36f0-53a1-11ec-2f04-eda59dea4ef1
md"""For example if `m=2` then the possible value for the mantissa are `11 => 1 + 1/2 + 1/4 = 7/4`, `10 => 1 + 1/2 = 6/4`, `01 => 1 + 1/4 = 5/4`. and `00 => 1 = 4/4`, values separated by `1/4 = 1/2^m`.
"""

# ╔═╡ 375f3790-53a1-11ec-0d5f-3fbf76de47fc
md"""For 64-bit floating point numbers `m=52`, so the values in the mantissa differ by `1/2^52 = 2.220446049250313e-16`. This is the value of `eps()`.
"""

# ╔═╡ 375f37b8-53a1-11ec-3c79-3fda807b1dd8
md"""However, this "gap" between numbers is for values when the exponent is `0`. That is the numbers in `[1,2)`. For values in `[2,4)` the gap is twice, between `[1/2,1)` the gap is half. That is the gap depends on the size of the number. The gap between `x` and its next largest floating point number  is given by `eps(x)` and that always satisfies `eps(x) <= eps() * abs(x)`.
"""

# ╔═╡ 375f37ea-53a1-11ec-3579-fb7b1b214e8a
md"""One way to think about this is the difference between `x` and the next largest floating point values is *basically* `x*(1+eps()) - x` or `x*eps()`.
"""

# ╔═╡ 375f386a-53a1-11ec-3889-f5c81d206a8f
md"""For the specific example, `abs(b-a) <= 2eps(max(abs(a),abs(b)))` which in turn is bounded by `2max(abs(b),abs(a)) * eps()` means that the gap between `a` and `b` is essentially 2 floating point values.
"""

# ╔═╡ 375f38ee-53a1-11ec-3139-f5fafefab5c9
md"""For bisection methods that is about as good as you can get. However, once floating values are understood, the best you can get for a bracketing interval would be
"""

# ╔═╡ 375f3a76-53a1-11ec-3078-4348a7464ccb
md"""  * along the way, a value `f(c)` is found which is *exactly* `0.0`
  * the endpoints of the bracketing interval are *adjacent* floating point values, meaning the interval can not be bisected and `f` changes sign between the two values.
"""

# ╔═╡ 375f3a92-53a1-11ec-248e-11437a474f04
md"""(This is the stopping criteria for `Roots.BisectionExact()` when `find_zero` from `Roots` is used.)
"""

# ╔═╡ 375f3aec-53a1-11ec-227d-6dc8b08e167d
md"""There can be problems when the stopping criteria is `abs(b-a) <= 2eps(max(a,b))` and the answer is `0.0`. For example, the algorithm above for the function `f(x) =  -40*x*exp(-x)` does not converge when started with `[-9,1]`, even though `0.0` is an obvious zero.
"""

# ╔═╡ 375f5ca4-53a1-11ec-3cef-ef6199176891
let
	fu(x) = -40*x*exp(-x)
	chandrapatlu(fu, -9, 1, λ3)
end

# ╔═╡ 375f5d56-53a1-11ec-0b9b-8557c4f0e7c3
md"""Here the issue is `abs(b-a)` is tiny (of the order `1e-119`) but `max(eps(a), eps(b))` is even smaller, as the values are close to `0.0`.
"""

# ╔═╡ 375f5e3e-53a1-11ec-042b-e5898854c700
md"""For non-bracketing methods, like Newton's method or the secant method, different criteria are useful. There may not be a bracketing interval for `f` (for example `f(x) = (x-1)^2`) so the second criteria above might need to be restated in terms of the last two iterates, $x_n$ and $x_{n-1}$. Calling this difference $\Delta = |x_n - x_{n-1}|$, we might stop if $\Delta$ is small enough. As there are scenarios where this can happen, but the function is not at a zero, a check on the size of `f` is needed.
"""

# ╔═╡ 375f5e50-53a1-11ec-1815-23e3b9e1b938
md"""However, there may be no floating point value where `f` is exactly `0.0` so checking the size of `f(x_n)` requires some agreement.
"""

# ╔═╡ 375f5e9e-53a1-11ec-13d6-9121a03d227a
md"""First if `f(x_n)` is `0.0` then it makes sense to call `x_n` an *exact zero* of `f`, even though this may hold even if `x_n`, a floating point value, is not mathematically an *exact* zero of `f`. (Consider `f(x) = x^2 - 2x + 1`. Mathematically, this is identical to `g(x) = (x-1)^2`, but `f(1 + eps())` is zero, while `g(1+eps())` is `4.930380657631324e-32`.
"""

# ╔═╡ 375f5ef0-53a1-11ec-1074-2170a5479cc2
md"""However, there may never be a value with `f(x_n)` exactly `0.0`. (The value of `sin(pi)` is not zero, for example, as `pi` is an approximation to $\pi$, as well the `sin` of values adjacent to `float(pi)` do not produce `0.0` exactly.)
"""

# ╔═╡ 375f5f18-53a1-11ec-19f5-d9f24ee8b994
md"""Suppose `x_n` is the closest floating number to $\alpha$, the zero. Then the relative rounding error,$(\text{\texttt{x\_n}} - \alpha)/\alpha$, will be a value $(1 + \delta)$ with $\delta$ less than `eps()`.
"""

# ╔═╡ 375f5f2c-53a1-11ec-35ed-87adcfa29667
md"""How far then can `f(x_n)` be from $0 = f(\alpha)$?
"""

# ╔═╡ 375f5fcc-53a1-11ec-2f5b-9be988c3baf4
md"""```math
f(x_n) = f(x_n - \alpha + \alpha) =  f(\alpha + \alpha \cdot \delta) = f(\alpha \cdot (1 + \delta)),
```
"""

# ╔═╡ 375f5fea-53a1-11ec-2b81-ef5e15f57e9d
md"""Assuming $f$ has a derivative, the linear approximation gives:
"""

# ╔═╡ 375f60bc-53a1-11ec-27f8-c365cc73685e
md"""```math
\text{\texttt{f(x\_n)}} \approx f(\alpha) + f'(\alpha) \cdot (\alpha\delta) = f'(\alpha) \cdot \alpha \delta
```
"""

# ╔═╡ 375f60e4-53a1-11ec-02d7-d5f44e60ea68
md"""So we should consider `f(x_n)` an *approximate zero* when it is on the scale of $f'(\alpha) \cdot \alpha \delta$.
"""

# ╔═╡ 375f61a0-53a1-11ec-15b4-1347cd26a0df
md"""That $\alpha$ means we consider a *relative* tolerance for `f`. Also important – when `x_n` is close to  `0`, is the need for an *absolute* tolerance, one not dependent on the size of `x`. So a good condition to check if `f(x_n)` is small is
"""

# ╔═╡ 37622888-53a1-11ec-0e7d-1d9c0c52a95e
md"""`abs(f(x_n)) <= abs(x_n) * rtol + atol`,
"""

# ╔═╡ 376229f2-53a1-11ec-3470-bfc151819bbd
md"""where the relative tolerance, `rtol`, would absorb an estimate for $f'(\alpha)$.
"""

# ╔═╡ 37622a9a-53a1-11ec-05e2-33c9ac52eb3f
md"""Now, in Newton's method the update step is $f(x_n)/f'(x_n)$. Naturally when $f(x_n)$ is close to $0$, the update step is small and $\Delta$ will be close to $0$. *However*, should $f'(x_n)$ be large, then $\Delta$ can also be small and the algorithm will possibly stop, as $x_{n+1} \approx x_n$ – but not necessarily $x_{n+1} \approx \alpha$. So termination on $\Delta$ alone can be off. Checking if $f(x_{n+1})$ is an approximate zero is  also useful to include in a stopping criteria.
"""

# ╔═╡ 37622acc-53a1-11ec-0746-29d569317a6a
md"""One thing to keep in mind is that the right-hand side of the rule `abs(f(x_n)) <= abs(x_n) * rtol + atol`, as a function of `x_n`, goes to `Inf` as `x_n` increases. So if `f` has `0` as an asymptote (like `e^(-x)`) for large enough `x_n`, the rule will be `true` and `x_n` could be counted as an approximate zero, despite it not being one.
"""

# ╔═╡ 37622b12-53a1-11ec-0227-d175f155e295
md"""So a modified criteria for convergence might look like:
"""

# ╔═╡ 37622cac-53a1-11ec-2f0c-ed489d3468b6
md"""  * stop if $\Delta$ is small and `f` is an approximate zero with some tolerances
  * stop if `f` is an approximate zero with some tolerances, but be mindful that this rule can identify mathematically erroneous answers.
"""

# ╔═╡ 37622cd4-53a1-11ec-3018-a344e3d4a0a2
md"""It is not uncommon to assign `rtol` to have a value like `sqrt(eps())` to account for accumulated floating point errors and the factor of $f'(\alpha)$, though in the `Roots` package it is set smaller by default.
"""

# ╔═╡ 37622d38-53a1-11ec-033c-49d9c3c46b43
md"""## Questions
"""

# ╔═╡ 37624b6a-53a1-11ec-28f4-7b57d4bf466f
md"""###### Question
"""

# ╔═╡ 37624cdc-53a1-11ec-1bdf-7b50aae84a56
md"""Let `f(x) = tanh(x)` (the hyperbolic tangent) and `fp(x) = sech(x)^2`, its derivative.
"""

# ╔═╡ 37624dd6-53a1-11ec-08a5-0311f5829385
md"""Does *Newton's* method (using `Roots.Newton()`) converge starting at `1.0`?
"""

# ╔═╡ 37625a24-53a1-11ec-0072-3b17f4aa02b7
let
	yesnoq("yes")
end

# ╔═╡ 37625ba0-53a1-11ec-0d8e-edbd8084bc54
md"""Does *Newton's* method (using `Roots.Newton()`) converge starting at `1.3`?
"""

# ╔═╡ 37625e96-53a1-11ec-0fec-0d17bb53b292
let
	yesnoq("no")
end

# ╔═╡ 37625ed4-53a1-11ec-2b26-d785f5020b6a
md"""Does the secant method (using `Roots.Secant()`) converge starting at `1.3`? (a second starting value will automatically be chosen, if not directly passed in.)
"""

# ╔═╡ 37626208-53a1-11ec-16c2-8f8705cf15cd
let
	yesnoq("yes")
end

# ╔═╡ 37626230-53a1-11ec-1599-8d6648eff6e1
md"""###### Question
"""

# ╔═╡ 376262c6-53a1-11ec-0d51-0f642c913220
md"""For the function `f(x) = x^5 - x - 1` both Newton's method and the secant method will converge to the one root when started from `1.0`. Using `verbose=true` as an argument to `find_zero`, (e.g., `find_zero(f, x0, Roots.Secant(), verbose=true)`) how many *more* steps does the secant method need to converge?
"""

# ╔═╡ 37626578-53a1-11ec-2d50-dbf782078840
let
	numericq(2)
end

# ╔═╡ 3762658c-53a1-11ec-29c0-030c55d7b7c3
md"""Do the two methods converge to the exact same value?
"""

# ╔═╡ 37626776-53a1-11ec-12ea-75b0b7373f53
let
	yesnoq("yes")
end

# ╔═╡ 376267bc-53a1-11ec-0893-f59f4fb5b77f
md"""###### Question
"""

# ╔═╡ 376267e4-53a1-11ec-10f7-e71bbcadbe84
md"""Let `f(x) = exp(x) - x^4` and `x0=8.0`. How many steps (iterations) does it take for the secant method to converge using the default tolerances?
"""

# ╔═╡ 37626ab4-53a1-11ec-28cc-5f871c5b307f
let
	numericq(10, 1)
end

# ╔═╡ 37626b18-53a1-11ec-1fdc-598cedc47c6c
md"""###### Question
"""

# ╔═╡ 37626b7c-53a1-11ec-1e40-ddb13b498709
md"""Let `f(x) = exp(x) - x^4` and a starting bracket be `x0 = [8.9]`. Then calling `find_zero(f,x0, verbose=true)` will show that 49 steps are needed for exact bisection to converge. What about with the `Roots.Brent()` algorithm, which uses inverse quadratic steps when it can?
"""

# ╔═╡ 37626bc2-53a1-11ec-36a8-512ac53958dc
md"""It takes how many steps?
"""

# ╔═╡ 37626dfc-53a1-11ec-2c44-e1fb079bf2dd
let
	numericq(36, 1)
end

# ╔═╡ 37626e9c-53a1-11ec-1333-1703f0152e29
md"""The `Roots.A42()` method uses inverse cubic interpolation, as possible, how many steps does this method take to converge?
"""

# ╔═╡ 3762711c-53a1-11ec-3a09-df0d7b851afe
let
	numericq(3, 1)
end

# ╔═╡ 376271f8-53a1-11ec-0d80-df1f22858ee8
md"""The large difference is due to how the tolerances are set within `Roots`. The `Brent method gets pretty close in a few steps, but takes a much longer time to get close enough for the default tolerances
"""

# ╔═╡ 37627234-53a1-11ec-06a4-ab667e94e4a2
md"""###### Question
"""

# ╔═╡ 3762723e-53a1-11ec-16cc-e33852e4da8f
md"""Consider this crazy function defined by:
"""

# ╔═╡ 37627310-53a1-11ec-1982-dfec3fed4fe8
md"""```
f(x) = cos(100*x)-4*erf(30*x-10)
```"""

# ╔═╡ 37627338-53a1-11ec-1398-ed55ab7ec6cd
md"""(The `erf` function is the (error function](https://en.wikipedia.org/wiki/Error_function) and is in the `SpecialFunctions` package loaded with `CalculusWithJulia`.)
"""

# ╔═╡ 3762739c-53a1-11ec-048d-b3cb16ece175
md"""Make a plot over the interval $[-3,3]$ to see why it is called "crazy".
"""

# ╔═╡ 376273ae-53a1-11ec-0fcf-01821964f1be
md"""Does `find_zero` find a zero to this function starting from $0$?
"""

# ╔═╡ 376275e8-53a1-11ec-2127-1f83c07016af
let
	yesnoq("yes")
end

# ╔═╡ 376275fe-53a1-11ec-023a-2d9ef98bea3e
md"""If so, what is the value?
"""

# ╔═╡ 3762afb0-53a1-11ec-0c7d-97d2064af7c9
let
	f(x) = cos(100*x)-4*erf(30*x-10)
	val = find_zero(f, 0)
	numericq(val)
end

# ╔═╡ 3762afd8-53a1-11ec-0869-5363d374d9ba
md"""If not, what is the reason?
"""

# ╔═╡ 3762b8d4-53a1-11ec-3507-e971662404bc
let
	choices = [
	"The zero is a simple zero",
	"The zero is not a simple zero",
	"The function oscillates too much to rely on the tangent line approximation far from the zero",
	"We can find an answer"
	]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 3762ba00-53a1-11ec-3df3-619b9c12260e
md"""Does `find_zero` find a zero to this function starting from $1$?
"""

# ╔═╡ 3762bcee-53a1-11ec-3945-e11e8b40bae5
let
	yesnoq(false)
end

# ╔═╡ 3762d288-53a1-11ec-21de-59cd18904957
md"""If so, what is the value?
"""

# ╔═╡ 3762ffd8-53a1-11ec-3049-ad37b208ba8c
let
	numericq(-999.999)
end

# ╔═╡ 3762fff6-53a1-11ec-0e9b-9d9a103f1e93
md"""If not, what is the reason?
"""

# ╔═╡ 376325c6-53a1-11ec-24fd-bdd886097b5c
let
	choices = [
	"The zero is a simple zero",
	"The zero is not a simple zero",
	"The function oscillates too much to rely on the tangent line approximations far from the zero",
	"We can find an answer"
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 37632648-53a1-11ec-2b93-49b6338d2570
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/newtons_method.html">◅ previous</a>  <a href="../derivatives/lhospitals_rule.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/more_zeros.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 37632698-53a1-11ec-1b6c-f1999709e85a
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
ImplicitEquations = "95701278-4526-5785-aba3-513cca398f19"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
ImplicitEquations = "~1.0.6"
Plots = "~1.23.6"
PlutoUI = "~0.7.21"
Roots = "~1.3.11"
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
# ╟─3763262a-53a1-11ec-0545-cfa4d9b6d305
# ╟─3756be0a-53a1-11ec-015f-6389c05a338b
# ╟─3756c0f6-53a1-11ec-0880-49fbc5d7d7b4
# ╠═37578f7c-53a1-11ec-10bb-5dfeb8ac2d06
# ╟─375797d8-53a1-11ec-337a-85df11f78553
# ╟─3757c53c-53a1-11ec-0052-a1578feca029
# ╟─3757c578-53a1-11ec-3ea3-d9cb854035ac
# ╟─3757ca78-53a1-11ec-1410-57b43927bc16
# ╟─3757cc30-53a1-11ec-1e2e-f1ae013250b7
# ╠═37580b6e-53a1-11ec-059a-c908e6b5d579
# ╟─37580c36-53a1-11ec-2eaf-f514495fbe3a
# ╠═37582e96-53a1-11ec-2e1b-9f74c2489f26
# ╟─37582f0e-53a1-11ec-1e99-b510b9c9aeb7
# ╟─37582f72-53a1-11ec-33e5-dd82cfbab08d
# ╟─37582ffe-53a1-11ec-183b-39cc6664c7fb
# ╟─37583206-53a1-11ec-25f1-b500bc487f36
# ╟─3758326a-53a1-11ec-246b-357705547636
# ╟─375832f8-53a1-11ec-1269-6b55b798d4c7
# ╟─3758349a-53a1-11ec-320e-6ba795154365
# ╟─37583596-53a1-11ec-1e57-89655b9cd782
# ╟─37583a4e-53a1-11ec-3330-f75a31e27d80
# ╟─37583a76-53a1-11ec-175d-57ccfcd724a3
# ╟─37583ada-53a1-11ec-08e4-75c2e50fda6c
# ╠═37589c78-53a1-11ec-0623-07fd17ca0355
# ╟─37589ce8-53a1-11ec-0d60-4304eb06788b
# ╠═37593976-53a1-11ec-1ed7-cb731f7c7db9
# ╟─37593a0c-53a1-11ec-0ac5-29f917a962ad
# ╟─37593aca-53a1-11ec-0f3b-4138b41b9ee0
# ╠═37595a16-53a1-11ec-1bce-073add297187
# ╟─37595b2c-53a1-11ec-2dc5-157396003282
# ╟─37595ce6-53a1-11ec-3674-3f5c29b791d5
# ╟─37595d98-53a1-11ec-0bc5-6bc570b97566
# ╟─37595dc0-53a1-11ec-36b7-af29b6996067
# ╟─37595dde-53a1-11ec-2ec1-31083ac38083
# ╟─37595e24-53a1-11ec-10af-915f6f2020f8
# ╟─37595e4e-53a1-11ec-257c-61f4b56e7b4a
# ╟─3759830e-53a1-11ec-1144-57f71c8177bb
# ╟─37598450-53a1-11ec-2644-15eaf515d1ca
# ╟─37598476-53a1-11ec-0814-43b92e8a9cb0
# ╟─3759848a-53a1-11ec-3dd3-2fa1ba25950c
# ╟─37598502-53a1-11ec-18b4-c3b5dbf74b83
# ╟─37598e6c-53a1-11ec-19c4-1ff480d798ca
# ╟─37598f02-53a1-11ec-02ea-454c08e2cd4d
# ╠═3759b7a2-53a1-11ec-248c-bfb258562021
# ╟─3759b874-53a1-11ec-0141-296000213c1d
# ╠═3759e984-53a1-11ec-36d1-d5752dc1d053
# ╟─3759ea24-53a1-11ec-075d-c5fef8676e58
# ╠═375a0a5e-53a1-11ec-0a2c-a397f1903017
# ╟─375a0b26-53a1-11ec-1275-938b46b5b8c0
# ╟─375a0c04-53a1-11ec-08fb-b5f40d3855c6
# ╟─375a0c5c-53a1-11ec-2396-59a0e22ce116
# ╟─375e3930-53a1-11ec-3142-8b17b31e2786
# ╠═375ee222-53a1-11ec-0420-c7007aebf9cc
# ╟─375ee32e-53a1-11ec-099c-f94e3a51084f
# ╟─375ee40c-53a1-11ec-3b37-21ed346484b9
# ╠═375eeab0-53a1-11ec-0726-9fb870b74241
# ╟─375eeb1e-53a1-11ec-01f1-17f2d6634748
# ╠═375ef3a2-53a1-11ec-39af-4f58ecc54e70
# ╟─375ef44c-53a1-11ec-10bf-418f1919bd1f
# ╟─375ef474-53a1-11ec-03d4-c5af5545ce17
# ╠═375f17ba-53a1-11ec-283e-1d3b3c5d5231
# ╟─375f1800-53a1-11ec-3b4d-4f93ef8fd5ef
# ╟─375f1b52-53a1-11ec-04ad-7d870aab8c47
# ╟─375f1d00-53a1-11ec-0554-89e1a5805809
# ╟─375f1d1e-53a1-11ec-3df9-2b814904e18c
# ╟─375f1d84-53a1-11ec-170d-5f3cb4ffaf12
# ╟─375f3464-53a1-11ec-251f-99bf4166dd3e
# ╟─375f36be-53a1-11ec-1da4-813a5a11141c
# ╟─375f36f0-53a1-11ec-2f04-eda59dea4ef1
# ╟─375f3790-53a1-11ec-0d5f-3fbf76de47fc
# ╟─375f37b8-53a1-11ec-3c79-3fda807b1dd8
# ╟─375f37ea-53a1-11ec-3579-fb7b1b214e8a
# ╟─375f386a-53a1-11ec-3889-f5c81d206a8f
# ╟─375f38ee-53a1-11ec-3139-f5fafefab5c9
# ╟─375f3a76-53a1-11ec-3078-4348a7464ccb
# ╟─375f3a92-53a1-11ec-248e-11437a474f04
# ╟─375f3aec-53a1-11ec-227d-6dc8b08e167d
# ╠═375f5ca4-53a1-11ec-3cef-ef6199176891
# ╟─375f5d56-53a1-11ec-0b9b-8557c4f0e7c3
# ╟─375f5e3e-53a1-11ec-042b-e5898854c700
# ╟─375f5e50-53a1-11ec-1815-23e3b9e1b938
# ╟─375f5e9e-53a1-11ec-13d6-9121a03d227a
# ╟─375f5ef0-53a1-11ec-1074-2170a5479cc2
# ╟─375f5f18-53a1-11ec-19f5-d9f24ee8b994
# ╟─375f5f2c-53a1-11ec-35ed-87adcfa29667
# ╟─375f5fcc-53a1-11ec-2f5b-9be988c3baf4
# ╟─375f5fea-53a1-11ec-2b81-ef5e15f57e9d
# ╟─375f60bc-53a1-11ec-27f8-c365cc73685e
# ╟─375f60e4-53a1-11ec-02d7-d5f44e60ea68
# ╟─375f61a0-53a1-11ec-15b4-1347cd26a0df
# ╟─37622888-53a1-11ec-0e7d-1d9c0c52a95e
# ╟─376229f2-53a1-11ec-3470-bfc151819bbd
# ╟─37622a9a-53a1-11ec-05e2-33c9ac52eb3f
# ╟─37622acc-53a1-11ec-0746-29d569317a6a
# ╟─37622b12-53a1-11ec-0227-d175f155e295
# ╟─37622cac-53a1-11ec-2f0c-ed489d3468b6
# ╟─37622cd4-53a1-11ec-3018-a344e3d4a0a2
# ╟─37622d38-53a1-11ec-033c-49d9c3c46b43
# ╟─37624b6a-53a1-11ec-28f4-7b57d4bf466f
# ╟─37624cdc-53a1-11ec-1bdf-7b50aae84a56
# ╟─37624dd6-53a1-11ec-08a5-0311f5829385
# ╟─37625a24-53a1-11ec-0072-3b17f4aa02b7
# ╟─37625ba0-53a1-11ec-0d8e-edbd8084bc54
# ╟─37625e96-53a1-11ec-0fec-0d17bb53b292
# ╟─37625ed4-53a1-11ec-2b26-d785f5020b6a
# ╟─37626208-53a1-11ec-16c2-8f8705cf15cd
# ╟─37626230-53a1-11ec-1599-8d6648eff6e1
# ╟─376262c6-53a1-11ec-0d51-0f642c913220
# ╟─37626578-53a1-11ec-2d50-dbf782078840
# ╟─3762658c-53a1-11ec-29c0-030c55d7b7c3
# ╟─37626776-53a1-11ec-12ea-75b0b7373f53
# ╟─376267bc-53a1-11ec-0893-f59f4fb5b77f
# ╟─376267e4-53a1-11ec-10f7-e71bbcadbe84
# ╟─37626ab4-53a1-11ec-28cc-5f871c5b307f
# ╟─37626b18-53a1-11ec-1fdc-598cedc47c6c
# ╟─37626b7c-53a1-11ec-1e40-ddb13b498709
# ╟─37626bc2-53a1-11ec-36a8-512ac53958dc
# ╟─37626dfc-53a1-11ec-2c44-e1fb079bf2dd
# ╟─37626e9c-53a1-11ec-1333-1703f0152e29
# ╟─3762711c-53a1-11ec-3a09-df0d7b851afe
# ╟─376271f8-53a1-11ec-0d80-df1f22858ee8
# ╟─37627234-53a1-11ec-06a4-ab667e94e4a2
# ╟─3762723e-53a1-11ec-16cc-e33852e4da8f
# ╟─37627310-53a1-11ec-1982-dfec3fed4fe8
# ╟─37627338-53a1-11ec-1398-ed55ab7ec6cd
# ╟─3762739c-53a1-11ec-048d-b3cb16ece175
# ╟─376273ae-53a1-11ec-0fcf-01821964f1be
# ╟─376275e8-53a1-11ec-2127-1f83c07016af
# ╟─376275fe-53a1-11ec-023a-2d9ef98bea3e
# ╟─3762afb0-53a1-11ec-0c7d-97d2064af7c9
# ╟─3762afd8-53a1-11ec-0869-5363d374d9ba
# ╟─3762b8d4-53a1-11ec-3507-e971662404bc
# ╟─3762ba00-53a1-11ec-3df3-619b9c12260e
# ╟─3762bcee-53a1-11ec-3945-e11e8b40bae5
# ╟─3762d288-53a1-11ec-21de-59cd18904957
# ╟─3762ffd8-53a1-11ec-3049-ad37b208ba8c
# ╟─3762fff6-53a1-11ec-0e9b-9d9a103f1e93
# ╟─376325c6-53a1-11ec-24fd-bdd886097b5c
# ╟─37632648-53a1-11ec-2b93-49b6338d2570
# ╟─3763268e-53a1-11ec-276a-2514bbb44cca
# ╟─37632698-53a1-11ec-1b6c-f1999709e85a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
