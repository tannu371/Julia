### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ e130f8b0-5399-11ec-110e-7da0b9f3872b
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ e130fda6-5399-11ec-0010-53770b8ac98f
begin
	using CalculusWithJulia.WeaveSupport
	using Roots
	import PyPlot
	pyplot()
	fig_size=(600, 400)
	
	nothing
end

# ╔═╡ e13332e2-5399-11ec-1f82-b7be1844ebc0
using PlutoUI

# ╔═╡ e1333166-5399-11ec-1aea-05cd6a1d55f9
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ e130a222-5399-11ec-034f-db1e7f9a5dc7
md"""# L'Hospital's Rule
"""

# ╔═╡ e130b954-5399-11ec-2319-9594c592f689
md"""This section uses these add-on packages:
"""

# ╔═╡ e130febe-5399-11ec-2706-992e968f952a
md"""---
"""

# ╔═╡ e130ffae-5399-11ec-1326-d97047a62ddc
md"""Let's return to limits of the form $\lim_{x \rightarrow c}f(x)/g(x)$ which have an indeterminate form of $0/0$ if both are evaluated at $c$. The typical example being the limit considered by Euler:
"""

# ╔═╡ e1310062-5399-11ec-0270-4b00f0dfd061
md"""```math
\lim_{x\rightarrow 0} \frac{\sin(x)}{x}.
```
"""

# ╔═╡ e13100a0-5399-11ec-2a70-ab0a0a14a2d5
md"""We know this is $1$ using a bound from geometry, but might also guess this is one, as we know from linearization near $0$ that we have
"""

# ╔═╡ e13100b2-5399-11ec-0acd-ad626b396857
md"""```math
\sin(x) = x - \sin(\xi)x^2/2, \quad 0 < \xi < x.
```
"""

# ╔═╡ e13100d2-5399-11ec-349f-557388347848
md"""This would yield:
"""

# ╔═╡ e1310100-5399-11ec-2429-7b1eccbd4ac6
md"""```math
\lim_{x \rightarrow 0} \frac{\sin(x)}{x} = \lim_{x\rightarrow 0} \frac{x -\sin(\xi) x^2/2}{x} = \lim_{x\rightarrow 0} 1 + \sin(\xi) \cdot x/2 = 1.
```
"""

# ╔═╡ e1310132-5399-11ec-15f2-c91b86651602
md"""This is because we know $\sin(\xi) x/2$  has a limit of $0$, when $|\xi| \leq |x|$.
"""

# ╔═╡ e131017a-5399-11ec-36ce-b74616adb970
md"""That doesn't look any easier, as we worried about the error term, but if just mentally replaced $\sin(x)$ with $x$ - which it basically is near $0$ - then we can see that the limit should be the same as $x/x$ which we know is $1$ without thinking.
"""

# ╔═╡ e1310208-5399-11ec-156e-8785f5011d82
md"""Basically, we found that in terms of limits, if both $f(x)$ and $g(x)$ are $0$ at $c$, that we *might* be able to just take this limit: $(f(c) + f'(c) \cdot(x-c)) / (g(c) + g'(c) \cdot (x-c))$ which is just $f'(c)/g'(c)$.
"""

# ╔═╡ e131022e-5399-11ec-301d-2bc841650a7f
md"""Wouldn't that be nice? We could find difficult limits just by differentiating the top and the bottom at $c$ (and not use the messy quotient rule).
"""

# ╔═╡ e1310292-5399-11ec-243a-4f5575545285
md"""Well, in fact that is more or less true, a fact that dates back to [L'Hospital](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule) - who wrote the first textbook on differential calculus - though this result is likely due to one of the Bernoulli brothers.
"""

# ╔═╡ e1313762-5399-11ec-06ef-13ed4f29a8fb
md"""> *L'Hospital's rule*: Suppose, $f$ and $g$ are differentiable in $(a,b)$ with $a < c < b$. Moreover, suppose $|g(x)| > 0$ for all $x$ in $(a,b)$ except at $c$. Further suppose $f(c)=g(c) =0$. If $\lim_{x\rightarrow c}f'(x)/g'(x)=L$ (the limit exists), then $L = \lim_{x \rightarrow c}f(x)/g(x)$.

"""

# ╔═╡ e13137e2-5399-11ec-2dcd-2d1b50229b91
md"""That is *if* the limit of $f(x)/g(x)$ is indeterminate of the form $0/0$, but the limit of $f'(x)/g'(x)$ is known, possibly by simple continuity, then the limit of $f(x)/g(x)$ exists and is equal to that of $f'(x)/g'(x)$.
"""

# ╔═╡ e1313802-5399-11ec-28ef-a9bb8151a128
md"""To apply this rule to Euler's example, $\sin(x)/x$, we just need to consider that:
"""

# ╔═╡ e131382a-5399-11ec-2b7f-07300d43550c
md"""```math
L = 1 = \lim_{x \rightarrow 0}\frac{\cos(x)}{1},
```
"""

# ╔═╡ e1313870-5399-11ec-3822-cd9221bfe92f
md"""So, as well, $\lim_{x \rightarrow 0} \sin(x)/x = 1$.
"""

# ╔═╡ e13138a2-5399-11ec-220b-758948e30d16
md"""This is due to $\cos(x)$ being continuous at $0$, so this limit is just $\cos(0)/1$. (More importantly, the tangent line expansion of $\sin(x)$ at $0$ is $\sin(0) + \cos(0)x$, so that $\cos(0)$ is why this answer is as it is, but we don't need to think in terms of $\cos(0)$, but rather the tangent-line expansion, which is $\sin(x) \approx x$, as $\cos(0)$ appears as the coefficient.
"""

# ╔═╡ e13139e2-5399-11ec-35c5-f54d8d7b107d
md"""##### Examples
"""

# ╔═╡ e1313afa-5399-11ec-0085-7f51a5f3e82f
md"""  * Consider this limit at $0$: $(a^x - 1)/x$. We have $f(x) =a^x-1$ has $f(0) = 0$, so this limit is indeterminate of the form $0/0$. The derivative of $f(x)$ is $f'(x) = a^x \log(a)$ which has $f'(0) = \log(a)$. The derivative of the bottom is also $1$ at $0$, so we have:
"""

# ╔═╡ e1313b22-5399-11ec-1df4-bf9b05b95d78
md"""```math
\log(a) = \frac{\log(a)}{1} = \frac{f'(0)}{g'(0)} = \lim_{x \rightarrow 0}\frac{f'(x)}{g'(x)} = \lim_{x \rightarrow 0}\frac{f(x)}{g(x)}
= \lim_{x \rightarrow 0}\frac{a^x - 1}{x}.
```
"""

# ╔═╡ e1315224-5399-11ec-0490-45ee4efc295e
md"""(Why rewrite in the "opposite" direction? Because the theorem's result – $L$ is the limit – is only true if the related limit involving the derivative exists.We don't do this in the following, but did so here to emphasize the need for the limit to exist.)
"""

# ╔═╡ e13152b0-5399-11ec-1724-21c8b4618b54
md"""  * Consider this limit:
"""

# ╔═╡ e13152ce-5399-11ec-2438-bb4a9a2e7629
md"""```math
\lim_{x \rightarrow 0} \frac{e^x - e^{-x}}{x}.
```
"""

# ╔═╡ e131531e-5399-11ec-2522-3bab0258d7fa
md"""It too is of the indeterminate form $0/0$. The derivative of the top is $e^x + e^{-x}$, which is $2$ when $x=0$, so the ratio of $f'(0)/g'(0)$ is seen to be 2 By continuity, the limit of the ratio of the derivatives is $2$. Then by L'Hospital's rule, the limit above is $2$.
"""

# ╔═╡ e1315378-5399-11ec-0a82-53a811436538
md"""  * Sometimes, L'Hospital's rule must be applied twice. Consider this limit:
"""

# ╔═╡ e131538c-5399-11ec-0eaf-5d29a845903b
md"""```math
\lim_{x \rightarrow 0} \frac{\cos(x)}{1 - x^2}
```
"""

# ╔═╡ e13153be-5399-11ec-3a24-0149611aa8da
md"""By L'Hospital's rule *if* this following limit exists, the two will be equal:
"""

# ╔═╡ e13153d2-5399-11ec-10c1-ad45350e1dbf
md"""```math
\lim_{x \rightarrow 0} \frac{-\sin(x)}{-2x}.
```
"""

# ╔═╡ e13153fa-5399-11ec-23bb-ad9a2586e7f2
md"""But if we didn't guess the answer, we see that this new problem is *also* indeterminate of the form $0/0$. So, repeating the process, this new limit will exist and be equal to the following limit, should it exist:
"""

# ╔═╡ e1315410-5399-11ec-1cfe-173429053177
md"""```math
\lim_{x \rightarrow 0} \frac{-\cos(x)}{-2} = 1/2.
```
"""

# ╔═╡ e1315436-5399-11ec-2f45-935e0c7bf5e7
md"""As $L = 1/2$ for this related limit, it must also be the limit of the original problem, by L'Hospital's rule.
"""

# ╔═╡ e13154c2-5399-11ec-0c8d-fdfad8e12c5a
md"""  * Our "intuitive" limits can bump into issues. Take for example the limit of $(\sin(x)-x)/x^2$ as $x$ goes to $0$. Using $\sin(x) \approx x$ makes this look like $0/x^2$ which is still indeterminate. (Because the difference is higher order than $x$.) Using L'Hospitals, says this limit will exist (and be equal) if the following one does:
"""

# ╔═╡ e13154ea-5399-11ec-1f1c-950d6ad7f892
md"""```math
\lim_{x \rightarrow 0} \frac{\cos(x) - 1}{2x}.
```
"""

# ╔═╡ e13154fe-5399-11ec-19de-1d9ca1a86676
md"""This particular limit is indeterminate of the form $0/0$, so we again try L'Hospital's rule and consider
"""

# ╔═╡ e131551c-5399-11ec-0ed5-2bc431dde4ac
md"""```math
\lim_{x \rightarrow 0} \frac{-\sin(x)}{2} = 0
```
"""

# ╔═╡ e131553a-5399-11ec-29ff-45eb491029d2
md"""So as this limit exists, working backwards, the original limit in question will also be $0$.
"""

# ╔═╡ e131558a-5399-11ec-0e86-610c368eaffe
md"""  * This example comes from the Wikipedia page. It "proves" a discrete approximation for the second derivative.
"""

# ╔═╡ e13155b2-5399-11ec-1e4e-a544aa9c4162
md"""Show if $f''(x)$ exists at $c$ and is continuous at $c$, then
"""

# ╔═╡ e13155c6-5399-11ec-1732-7b2a8298bd05
md"""```math
f''(c) = \lim_{h \rightarrow 0} \frac{f(c + h) - 2f(c) + f(c-h)}{h^2}.
```
"""

# ╔═╡ e13155dc-5399-11ec-0c35-238b459ea5ec
md"""This will follow from two applications of L'Hospital's rule to the right-hand side. The first says, the limit on the right is equal to this limit, should it exist:
"""

# ╔═╡ e13155e4-5399-11ec-376b-492719d006e5
md"""```math
\lim_{h \rightarrow 0} \frac{f'(c+h) - 0 - f'(c-h)}{2h}.
```
"""

# ╔═╡ e1315616-5399-11ec-067f-3f9788f5fa75
md"""We have to be careful, as we differentiate in the $h$ variable, not the $c$ one, so the chain rule brings out the minus sign. But again, as we still have an indeterminate form $0/0$, this limit will equal the following limit should it exist:
"""

# ╔═╡ e1315620-5399-11ec-07ef-0b5b5be466b8
md"""```math
\lim_{h \rightarrow 0} \frac{f''(c+h) - 0 - (-f''(c-h))}{2} =
\lim_{c \rightarrow 0}\frac{f''(c+h) + f''(c-h)}{2} = f''(c).
```
"""

# ╔═╡ e1315648-5399-11ec-2384-db30b5732472
md"""That last equality follows, as it is assumed that $f''(x)$ exists at $c$ and is continuous, that is, $f''(c \pm h) \rightarrow f''(c)$.
"""

# ╔═╡ e131565c-5399-11ec-213f-1f9fa1cf99a7
md"""The expression above finds use when second derivatives are numerically approximated. (The middle expression is the basis of the central-finite difference approximation to the derivative.)
"""

# ╔═╡ e13157a4-5399-11ec-330e-190bc4cba024
md"""## Why?
"""

# ╔═╡ e1315828-5399-11ec-10de-c749de2bf2d8
md"""The proof of L'Hospital's rule takes advantage of Cauchy's [generalization](http://en.wikipedia.org/wiki/Mean_value_theorem#Cauchy.27s_mean_value_theorem) of the mean value theorem to two functions. Let $f(x)$ and $g(x)$ be continuous on $[a,b]$ and differentiable on $(a,b)$ so that on $[c,c+x]$ there exists a $\xi$ with $f'(\xi) \cdot (f(x) - f(c)) = g'(\xi) \cdot (g(x) - g(c))$. In our formulation, both $f(c)$ and $g(c)$ are zero, so we have, provided we know that $g(x)$ is non zero, that $f(x)/g(x) = f'(\xi)/g'(\xi)$ for some $\xi$, $c < \xi < c + x$. That the right-hand side has a limit as $x \rightarrow c+$ is true by the assumption that the limit of the derivative's ratio exists. (The $\xi$ part can be removed by considering it as a composition of a function going to $c$.) Thus the right limit of the left hand side is known. Similarly, working with $[c-x, c]$ we can get the left limit is known and is equal to the right.
"""

# ╔═╡ e1315896-5399-11ec-1368-6b61104d031a
md"""### L'Hospital's picture
"""

# ╔═╡ e1329102-5399-11ec-04a7-758848060dd0
let
	## {{{lhopitals_picture}}}
	
	function lhopitals_picture_graph(n)
	
	    g = (x) -> sqrt(1 + x) - 1 - x^2
	    f = (x) -> x^2
	    ts = range(-1/2, stop=1/2, length=50)
	
	
	    a, b = 0, 1/2^n * 1/2
	    m = (f(b)-f(a)) /  (g(b)-g(a))
	
	    ## get bounds
	    tl = (x) -> g(0) + m * (x - f(0))
	
	    lx = max(fzero(x -> tl(x) - (-0.05),-1000, 1000), -0.6)
	    rx = min(fzero(x -> tl(x) - (0.25),-1000, 1000), 0.2)
	    xs = [lx, rx]
	    ys = map(tl, xs)
	
	    plt = plot(g, f, -1/2, 1/2, legend=false, size=fig_size, xlim=(-.6, .5), ylim=(-.1, .3))
	    plot!(plt, xs, ys, color=:orange)
	    scatter!(plt, [g(a),g(b)], [f(a),f(b)], markersize=5, color=:orange)
	    plt
	end
	
	caption = L"""
	
	Geometric interpretation of $L=\lim_{x \rightarrow 0} x^2 / (\sqrt{1 +
	x} - 1 - x^2)$. At $0$ this limit is indeterminate of the form
	$0/0$. The value for a fixed $x$ can be seen as the slope of a secant
	line of a parametric plot of the two functions, plotted as $(g,
	f)$. In this figure, the limiting "tangent" line has $0$ slope,
	corresponding to the limit $L$. In general, L'Hospital's rule is
	nothing more than a statement about slopes of tangent lines.
	
	"""
	
	n = 6
	anim = @animate for i=1:n
	    lhopitals_picture_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	
	plotly()
	ImageFile(imgfile, caption)
end

# ╔═╡ e1329184-5399-11ec-013b-2185a91c36bf
md"""## Generalizations
"""

# ╔═╡ e132921a-5399-11ec-16c4-ad9d01692bd4
md"""L'Hospital's rule generalizes to other indeterminate forms, in particular $\infty/\infty$ can be proved at the same time as $0/0$ with a more careful [proof](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule#General_proof).
"""

# ╔═╡ e1329242-5399-11ec-2393-b5b0f3ca1427
md"""In addition, indeterminate forms of the type $0 \cdot \infty$, $0^0$ and $\infty^\infty$ can be re-expressed to be in the form $0/0$ or $\infty/\infty$.
"""

# ╔═╡ e1329260-5399-11ec-27e7-4fcc6a125e39
md"""For example, consider
"""

# ╔═╡ e132929c-5399-11ec-32a7-a94f16a88067
md"""```math
\lim_{x \rightarrow \infty} \frac{x}{e^x}.
```
"""

# ╔═╡ e13292d8-5399-11ec-270c-ff8ffbb095da
md"""We see it is of the form $\infty/\infty$ (That we are taking a limit at $\infty$ is also a generalization.) We have by the generalized L'Hospital rule that this limit will exist and be equal to this one, should it exist:
"""

# ╔═╡ e13292e0-5399-11ec-1f93-63ae9aeda160
md"""```math
\lim_{x \rightarrow \infty} \frac{1}{e^x}.
```
"""

# ╔═╡ e132930a-5399-11ec-02ab-0b1d4ff38b5b
md"""This limit is, of course, $0$, as it is of the form $1/\infty$. It is not hard to build up from here to show that for any integer value of $n>0$ that:
"""

# ╔═╡ e1329312-5399-11ec-2e3a-03087bdd8be3
md"""```math
\lim_{x \rightarrow \infty} \frac{x^n}{e^x} = 0.
```
"""

# ╔═╡ e1329332-5399-11ec-0281-718d399b10ea
md"""This is an expression of the fact that exponential functions grow faster than polynomial functions.
"""

# ╔═╡ e1329378-5399-11ec-3e5e-ddfe8d98ba2b
md"""##### Examples
"""

# ╔═╡ e1329440-5399-11ec-0d1f-b188848451fe
md"""  * What is the limit $x \log(x)$ as $x \rightarrow 0+$?
"""

# ╔═╡ e1329454-5399-11ec-1ace-17e7bbe90a28
md"""Rewriting, we see this is just:
"""

# ╔═╡ e1329486-5399-11ec-3cf4-a51634b37877
md"""```math
\lim_{x \rightarrow 0+}\frac{\log(x)}{1/x}.
```
"""

# ╔═╡ e13294ae-5399-11ec-2107-974e6ca09c52
md"""L'Hospital's rule clearly applies to one sided limits, as well as two (our proof sketch used one-sided limits), so this limit will equal the following, should it exist:
"""

# ╔═╡ e13294cc-5399-11ec-3f1b-c31b5bd14c66
md"""```math
\lim_{x \rightarrow 0+}\frac{1/x}{-1/x^2} = \lim_{x \rightarrow 0+} -x = 0.
```
"""

# ╔═╡ e1329530-5399-11ec-27b4-5305a28370c7
md"""  * What is the limit $x^x$ as $x \rightarrow 0+$? The expression is of the form $0^0$, which is indeterminate. (Even though floating point math defines the value as $1$.) We can rewrite this by taking a log:
"""

# ╔═╡ e1329544-5399-11ec-1876-bbbbc69a7885
md"""```math
x^x = \exp(\log(x^x)) = \exp(x \log(x)) = \exp(\log(x)/(1/x)).
```
"""

# ╔═╡ e132956c-5399-11ec-0b66-e3bd40161344
md"""Be just saw that $\lim_{x \rightarrow 0+}\log(x)/(1/x) = 0$. So by the rules for limits of compositions and the fact that $e^x$ is continuous, we see $\lim_{x \rightarrow 0+} x^x = e^0 = 1$.
"""

# ╔═╡ e13295da-5399-11ec-315a-6d92042eddae
md"""  * L'Hospital himself was interested in this limit for $a > 0$ ([math overflow](http://mathoverflow.net/questions/51685/how-did-bernoulli-prove-lh%C3%B4pitals-rule))
"""

# ╔═╡ e13295f8-5399-11ec-1ef9-6de86c194543
md"""```math
\lim_{x \rightarrow a} \frac{\sqrt{2a^3\cdot x-x^4} - a\cdot(a^2\cdot x)^{1/3}}{ a - (a\cdot x^3)^{1/4}}.
```
"""

# ╔═╡ e1329634-5399-11ec-13e1-3730d9b3fd6c
md"""These derivatives can be done by hand, but to avoid any minor mistakes we utilize `SymPy` taking care to use rational numbers for the fractional powers, so as not to lose precision through floating point roundoff:
"""

# ╔═╡ e1329e18-5399-11ec-0570-53fabbc1e6d9
begin
	@syms a::positive x::positive
	f(x) = sqrt(2a^3*x - x^4) - a * (a^2*x)^(1//3)
	g(x) = a - (a*x^3)^(1//4)
end

# ╔═╡ e1329e4a-5399-11ec-15db-91a637e8ddee
md"""We can see that at $x=a$ we have the indeterminate form $0/0$:
"""

# ╔═╡ e132a0a2-5399-11ec-06f3-4516383e36d6
f(a), g(a)

# ╔═╡ e132a0b6-5399-11ec-3e24-8f09379fd7cd
md"""What about the derivatives?
"""

# ╔═╡ e132a6e2-5399-11ec-3465-c9777e5edebf
begin
	fp, gp = diff(f(x),x), diff(g(x),x)
	fp(x=>a), gp(x=>a)
end

# ╔═╡ e132a6f6-5399-11ec-2a1c-f3e43e8d6b48
md"""Their ratio will not be indeterminate, so the limit in question is just the ratio:
"""

# ╔═╡ e132ab24-5399-11ec-37aa-65d3f5f6c2e0
fp(x=>a) / gp(x=>a)

# ╔═╡ e132ab56-5399-11ec-0a9c-4bd832f502b0
md"""Of course, we could have just relied on `limit`, which knows about L'Hospital's rule:
"""

# ╔═╡ e132ae4e-5399-11ec-3fac-bb31e9dbb142
limit(f(x)/g(x), x, a)

# ╔═╡ e132ae80-5399-11ec-1bf9-db56ffde2f00
md"""##### Example: The limit existing is necessary
"""

# ╔═╡ e132aed0-5399-11ec-2ece-c5ff319ecc0b
md"""The following limit is *easily* seen by comparing terms of largest growth:
"""

# ╔═╡ e132aee4-5399-11ec-1fab-2723e5de41c4
md"""```math
1 - \lim_{x \rightarrow \infty} \frac{x - \sin(x)}{x}
```
"""

# ╔═╡ e132af0e-5399-11ec-1180-b56b32254877
md"""However, the limit of the ratio of the derivatives *does* not exist:
"""

# ╔═╡ e132af20-5399-11ec-3efb-074c162226fb
md"""```math
\lim_{x \rightarrow \infty} \frac{1 - \cos(x)}{1},
```
"""

# ╔═╡ e132af2a-5399-11ec-20c3-db85960bc595
md"""as the function just oscillates. This shows that L'Hospital's rule does not apply when the limit of the the ratio of the derivatives does not exist.
"""

# ╔═╡ e132af52-5399-11ec-2775-ab752001e4a5
md"""## Questions
"""

# ╔═╡ e132afde-5399-11ec-0f20-0542935bca95
md"""###### Question
"""

# ╔═╡ e132b010-5399-11ec-1f68-8d7b993331e2
md"""This function $f(x) = \sin(5x)/x$ is *indeterminate* at $x=0$. What type?
"""

# ╔═╡ e132b768-5399-11ec-33c3-e3663f710d28
begin
	lh_choices = [
	"``0/0``",
	"``\\infty/\\infty``",
	"``0^0``",
	"``\\infty - \\infty``",
	"``0 \\cdot \\infty``"
	]
	nothing
end

# ╔═╡ e132bac4-5399-11ec-32b2-1dbbbfd112c8
let
	ans = 1
	radioq(lh_choices, ans, keep_order=true)
end

# ╔═╡ e132bb0a-5399-11ec-1d0e-d57b14ed00de
md"""###### Question
"""

# ╔═╡ e132bb50-5399-11ec-003e-5f92d3040162
md"""This function $f(x) = \sin(x)^{\sin(x)}$ is *indeterminate* at $x=0$. What type?
"""

# ╔═╡ e132be48-5399-11ec-0652-7f9ecf454959
let
	ans =3
	radioq(lh_choices, ans, keep_order=true)
end

# ╔═╡ e132be70-5399-11ec-2fc6-09b3005936cf
md"""###### Question
"""

# ╔═╡ e132beb4-5399-11ec-30fd-7100f5476cc8
md"""This function $f(x) = (x-2)/(x^2 - 4)$ is *indeterminate* at $x=2$. What type?
"""

# ╔═╡ e132d806-5399-11ec-026d-e97bea4594d7
let
	ans = 1
	radioq(lh_choices, ans, keep_order=true)
end

# ╔═╡ e132d84c-5399-11ec-3d79-5fe106db59ae
md"""###### Question
"""

# ╔═╡ e132d89c-5399-11ec-1268-15ff381be4c6
md"""This function $f(x) = (g(x+h) - g(x-h)) / (2h)$ ($g$ is continuous) is *indeterminate* at $h=0$. What type?
"""

# ╔═╡ e132dbe4-5399-11ec-3f9d-b729f35e6e0e
let
	ans = 1
	radioq(lh_choices, ans, keep_order=true)
end

# ╔═╡ e132dc16-5399-11ec-20f7-815ddb6f5460
md"""###### Question
"""

# ╔═╡ e132dc4a-5399-11ec-26ed-f14f1ed11a30
md"""This function $f(x) = x \log(x)$ is *indeterminate* at $x=0$. What type?
"""

# ╔═╡ e132df54-5399-11ec-11b1-4f97f32715a7
let
	ans = 5
	radioq(lh_choices, ans, keep_order=true)
end

# ╔═╡ e132df72-5399-11ec-3d03-4912f1b953fc
md"""###### Question
"""

# ╔═╡ e132df90-5399-11ec-05e1-0f0e79f2d72c
md"""Does L'Hospital's rule apply to this limit:
"""

# ╔═╡ e132dfac-5399-11ec-02a6-fbaba286f785
md"""```math
\lim_{x \rightarrow \pi} \frac{\sin(\pi x)}{\pi x}.
```
"""

# ╔═╡ e132e57e-5399-11ec-1e1e-51db84a6b586
let
	choices = [
	"Yes. It is of the form ``0/0``",
	"No. It is not indeterminate"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ e132e5b2-5399-11ec-079d-251c738cf1fa
md"""###### Question
"""

# ╔═╡ e132e5da-5399-11ec-2f61-5bd15dd580f4
md"""Use L'Hospital's rule to find the limit
"""

# ╔═╡ e132e5f8-5399-11ec-19bc-9dd0725909c2
md"""```math
L = \lim_{x \rightarrow 0} \frac{4x - \sin(x)}{x}.
```
"""

# ╔═╡ e132e616-5399-11ec-094f-af0c7796cfca
md"""What is $L$?
"""

# ╔═╡ e132ec06-5399-11ec-04ea-5f088ece9ab7
let
	f(x) = (4x - sin(x))/x
	L = float(N(limit(f, 0)))
	numericq(L)
end

# ╔═╡ e132ec42-5399-11ec-3bb7-6be57c319609
md"""###### Question
"""

# ╔═╡ e132ec60-5399-11ec-3215-eb11b970d2a5
md"""Use L'Hospital's rule to find the limit
"""

# ╔═╡ e132ec74-5399-11ec-24e3-4b8043888902
md"""```math
L = \lim_{x \rightarrow 0} \frac{\sqrt{1+x} - 1}{x}.
```
"""

# ╔═╡ e132ec9c-5399-11ec-26df-6f6ec8f4fea0
md"""What is $L$?
"""

# ╔═╡ e132f2d2-5399-11ec-2042-dd8b28f0e9cf
let
	f(x) = (sqrt(1+x) - 1)/x
	L = float(N(limit(f, 0)))
	numericq(L)
end

# ╔═╡ e132f30e-5399-11ec-04e5-971c7f23d5b6
md"""###### Question
"""

# ╔═╡ e132f340-5399-11ec-1122-9dec9949d0be
md"""Use L'Hospital's rule *two* or more times to find the limit
"""

# ╔═╡ e132f35e-5399-11ec-37e4-d760587769fe
md"""```math
L = \lim_{x \rightarrow 0} \frac{x - \sin(x)}{x^3}.
```
"""

# ╔═╡ e132f37c-5399-11ec-2708-bb735c885dc0
md"""What is $L$?
"""

# ╔═╡ e132f8f4-5399-11ec-10b1-dd37b9fc9795
let
	f(x) = (x - sin(x))/x^3
	L = float(N(limit(f, 0)))
	numericq(L)
end

# ╔═╡ e132f91c-5399-11ec-0218-b50df5f8ae47
md"""###### Question
"""

# ╔═╡ e132f94e-5399-11ec-1cd5-d11ef2c8a086
md"""Use L'Hospital's rule *two* or more times to find the limit
"""

# ╔═╡ e132f96e-5399-11ec-2593-65f65ee657db
md"""```math
L = \lim_{x \rightarrow 0} \frac{1 - x^2/2 - \cos(x)}{x^3}.
```
"""

# ╔═╡ e132f98a-5399-11ec-29f6-edbf92eb5caa
md"""What is $L$?
"""

# ╔═╡ e133010a-5399-11ec-07cd-dbbf0116ac14
let
	f(x) = (1 - x^2/2 - cos(x))/x^3
	L = float(N(limit(f, 0)))
	numericq(L)
end

# ╔═╡ e1330128-5399-11ec-3e32-471188b5f280
md"""###### Question
"""

# ╔═╡ e1330148-5399-11ec-3b80-d7acab1559eb
md"""By using a common denominator to rewrite this expression, use L'Hospital's rule to find the limit
"""

# ╔═╡ e1330164-5399-11ec-21b5-0952823a407a
md"""```math
L = \lim_{x \rightarrow 0} \frac{1}{x} - \frac{1}{\sin(x)}.
```
"""

# ╔═╡ e1330182-5399-11ec-040d-c3bb6ff177a7
md"""What is $L$?
"""

# ╔═╡ e13307cc-5399-11ec-1ca0-03db023f88c9
let
	f(x) = 1/x - 1/sin(x)
	L = float(N(limit(f, 0)))
	numericq(L)
end

# ╔═╡ e1330808-5399-11ec-000b-2bd811e1bab1
md"""##### Question
"""

# ╔═╡ e133081c-5399-11ec-3306-3fdee3516fc4
md"""Use  L'Hospital's rule  to find the limit
"""

# ╔═╡ e1330844-5399-11ec-0db1-7d0986a04eb9
md"""```math
L = \lim_{x \rightarrow \infty} \log(x)/x
```
"""

# ╔═╡ e133086c-5399-11ec-0381-7b0728a4b381
md"""What is $L$?
"""

# ╔═╡ e1331046-5399-11ec-1409-7319e7ed0235
let
	L = float(N(limit(log(x)/x, x=>oo)))
	numericq(L)
end

# ╔═╡ e133105a-5399-11ec-2cf6-fb1f19f13659
md"""##### Question
"""

# ╔═╡ e1331096-5399-11ec-1752-81413c3efd1f
md"""Using  L'Hospital's rule, does
"""

# ╔═╡ e13310a0-5399-11ec-3883-6b6556d36d24
md"""```math
\lim_{x \rightarrow 0+} x^{\log(x)}
```
"""

# ╔═╡ e13310c0-5399-11ec-18ae-c101735793d1
md"""exist?
"""

# ╔═╡ e13310e6-5399-11ec-180d-57788fa1f709
md"""Consider $x^{\log(x)} = e^{\log(x)\log(x)}$.
"""

# ╔═╡ e133135e-5399-11ec-0ab0-e36e1a4073de
let
	yesnoq(false)
end

# ╔═╡ e1331370-5399-11ec-31c1-63c39bba1905
md"""##### Question
"""

# ╔═╡ e1331390-5399-11ec-0f56-e166a63b0d63
md"""Using  L'Hospital's rule, find the limit of
"""

# ╔═╡ e13313b6-5399-11ec-2014-d1ac1a9d7698
md"""```math
\lim_{x \rightarrow 1} (2-x)^{\tan(\pi/2 \cdot x)}.
```
"""

# ╔═╡ e13313f0-5399-11ec-2e45-83c62feb297e
md"""(Hint, express as $\exp^{\tan(\pi/2 \cdot x) \cdot \log(2-x)}$ and take the limit of the resulting exponent.)
"""

# ╔═╡ e13330ee-5399-11ec-247f-d74afa2216af
let
	choices = [
	"``e^{2/\\pi}``",
	"``{2\\pi}``",
	"``1``",
	"``0``",
	"It does not exist"
	]
	ans =1
	radioq(choices, ans)
end

# ╔═╡ e13332d8-5399-11ec-3941-574c2b8d61d9
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/more_zeros.html">◅ previous</a>  <a href="../derivatives/implicit_differentiation.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/lhospitals_rule.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ e13332ee-5399-11ec-28fb-5921861c5b21
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
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
# ╟─e1333166-5399-11ec-1aea-05cd6a1d55f9
# ╟─e130a222-5399-11ec-034f-db1e7f9a5dc7
# ╟─e130b954-5399-11ec-2319-9594c592f689
# ╠═e130f8b0-5399-11ec-110e-7da0b9f3872b
# ╟─e130fda6-5399-11ec-0010-53770b8ac98f
# ╟─e130febe-5399-11ec-2706-992e968f952a
# ╟─e130ffae-5399-11ec-1326-d97047a62ddc
# ╟─e1310062-5399-11ec-0270-4b00f0dfd061
# ╟─e13100a0-5399-11ec-2a70-ab0a0a14a2d5
# ╟─e13100b2-5399-11ec-0acd-ad626b396857
# ╟─e13100d2-5399-11ec-349f-557388347848
# ╟─e1310100-5399-11ec-2429-7b1eccbd4ac6
# ╟─e1310132-5399-11ec-15f2-c91b86651602
# ╟─e131017a-5399-11ec-36ce-b74616adb970
# ╟─e1310208-5399-11ec-156e-8785f5011d82
# ╟─e131022e-5399-11ec-301d-2bc841650a7f
# ╟─e1310292-5399-11ec-243a-4f5575545285
# ╟─e1313762-5399-11ec-06ef-13ed4f29a8fb
# ╟─e13137e2-5399-11ec-2dcd-2d1b50229b91
# ╟─e1313802-5399-11ec-28ef-a9bb8151a128
# ╟─e131382a-5399-11ec-2b7f-07300d43550c
# ╟─e1313870-5399-11ec-3822-cd9221bfe92f
# ╟─e13138a2-5399-11ec-220b-758948e30d16
# ╟─e13139e2-5399-11ec-35c5-f54d8d7b107d
# ╟─e1313afa-5399-11ec-0085-7f51a5f3e82f
# ╟─e1313b22-5399-11ec-1df4-bf9b05b95d78
# ╟─e1315224-5399-11ec-0490-45ee4efc295e
# ╟─e13152b0-5399-11ec-1724-21c8b4618b54
# ╟─e13152ce-5399-11ec-2438-bb4a9a2e7629
# ╟─e131531e-5399-11ec-2522-3bab0258d7fa
# ╟─e1315378-5399-11ec-0a82-53a811436538
# ╟─e131538c-5399-11ec-0eaf-5d29a845903b
# ╟─e13153be-5399-11ec-3a24-0149611aa8da
# ╟─e13153d2-5399-11ec-10c1-ad45350e1dbf
# ╟─e13153fa-5399-11ec-23bb-ad9a2586e7f2
# ╟─e1315410-5399-11ec-1cfe-173429053177
# ╟─e1315436-5399-11ec-2f45-935e0c7bf5e7
# ╟─e13154c2-5399-11ec-0c8d-fdfad8e12c5a
# ╟─e13154ea-5399-11ec-1f1c-950d6ad7f892
# ╟─e13154fe-5399-11ec-19de-1d9ca1a86676
# ╟─e131551c-5399-11ec-0ed5-2bc431dde4ac
# ╟─e131553a-5399-11ec-29ff-45eb491029d2
# ╟─e131558a-5399-11ec-0e86-610c368eaffe
# ╟─e13155b2-5399-11ec-1e4e-a544aa9c4162
# ╟─e13155c6-5399-11ec-1732-7b2a8298bd05
# ╟─e13155dc-5399-11ec-0c35-238b459ea5ec
# ╟─e13155e4-5399-11ec-376b-492719d006e5
# ╟─e1315616-5399-11ec-067f-3f9788f5fa75
# ╟─e1315620-5399-11ec-07ef-0b5b5be466b8
# ╟─e1315648-5399-11ec-2384-db30b5732472
# ╟─e131565c-5399-11ec-213f-1f9fa1cf99a7
# ╟─e13157a4-5399-11ec-330e-190bc4cba024
# ╟─e1315828-5399-11ec-10de-c749de2bf2d8
# ╟─e1315896-5399-11ec-1368-6b61104d031a
# ╟─e1329102-5399-11ec-04a7-758848060dd0
# ╟─e1329184-5399-11ec-013b-2185a91c36bf
# ╟─e132921a-5399-11ec-16c4-ad9d01692bd4
# ╟─e1329242-5399-11ec-2393-b5b0f3ca1427
# ╟─e1329260-5399-11ec-27e7-4fcc6a125e39
# ╟─e132929c-5399-11ec-32a7-a94f16a88067
# ╟─e13292d8-5399-11ec-270c-ff8ffbb095da
# ╟─e13292e0-5399-11ec-1f93-63ae9aeda160
# ╟─e132930a-5399-11ec-02ab-0b1d4ff38b5b
# ╟─e1329312-5399-11ec-2e3a-03087bdd8be3
# ╟─e1329332-5399-11ec-0281-718d399b10ea
# ╟─e1329378-5399-11ec-3e5e-ddfe8d98ba2b
# ╟─e1329440-5399-11ec-0d1f-b188848451fe
# ╟─e1329454-5399-11ec-1ace-17e7bbe90a28
# ╟─e1329486-5399-11ec-3cf4-a51634b37877
# ╟─e13294ae-5399-11ec-2107-974e6ca09c52
# ╟─e13294cc-5399-11ec-3f1b-c31b5bd14c66
# ╟─e1329530-5399-11ec-27b4-5305a28370c7
# ╟─e1329544-5399-11ec-1876-bbbbc69a7885
# ╟─e132956c-5399-11ec-0b66-e3bd40161344
# ╟─e13295da-5399-11ec-315a-6d92042eddae
# ╟─e13295f8-5399-11ec-1ef9-6de86c194543
# ╟─e1329634-5399-11ec-13e1-3730d9b3fd6c
# ╠═e1329e18-5399-11ec-0570-53fabbc1e6d9
# ╟─e1329e4a-5399-11ec-15db-91a637e8ddee
# ╠═e132a0a2-5399-11ec-06f3-4516383e36d6
# ╟─e132a0b6-5399-11ec-3e24-8f09379fd7cd
# ╠═e132a6e2-5399-11ec-3465-c9777e5edebf
# ╟─e132a6f6-5399-11ec-2a1c-f3e43e8d6b48
# ╠═e132ab24-5399-11ec-37aa-65d3f5f6c2e0
# ╟─e132ab56-5399-11ec-0a9c-4bd832f502b0
# ╠═e132ae4e-5399-11ec-3fac-bb31e9dbb142
# ╟─e132ae80-5399-11ec-1bf9-db56ffde2f00
# ╟─e132aed0-5399-11ec-2ece-c5ff319ecc0b
# ╟─e132aee4-5399-11ec-1fab-2723e5de41c4
# ╟─e132af0e-5399-11ec-1180-b56b32254877
# ╟─e132af20-5399-11ec-3efb-074c162226fb
# ╟─e132af2a-5399-11ec-20c3-db85960bc595
# ╟─e132af52-5399-11ec-2775-ab752001e4a5
# ╟─e132afde-5399-11ec-0f20-0542935bca95
# ╟─e132b010-5399-11ec-1f68-8d7b993331e2
# ╟─e132b768-5399-11ec-33c3-e3663f710d28
# ╟─e132bac4-5399-11ec-32b2-1dbbbfd112c8
# ╟─e132bb0a-5399-11ec-1d0e-d57b14ed00de
# ╟─e132bb50-5399-11ec-003e-5f92d3040162
# ╟─e132be48-5399-11ec-0652-7f9ecf454959
# ╟─e132be70-5399-11ec-2fc6-09b3005936cf
# ╟─e132beb4-5399-11ec-30fd-7100f5476cc8
# ╟─e132d806-5399-11ec-026d-e97bea4594d7
# ╟─e132d84c-5399-11ec-3d79-5fe106db59ae
# ╟─e132d89c-5399-11ec-1268-15ff381be4c6
# ╟─e132dbe4-5399-11ec-3f9d-b729f35e6e0e
# ╟─e132dc16-5399-11ec-20f7-815ddb6f5460
# ╟─e132dc4a-5399-11ec-26ed-f14f1ed11a30
# ╟─e132df54-5399-11ec-11b1-4f97f32715a7
# ╟─e132df72-5399-11ec-3d03-4912f1b953fc
# ╟─e132df90-5399-11ec-05e1-0f0e79f2d72c
# ╟─e132dfac-5399-11ec-02a6-fbaba286f785
# ╟─e132e57e-5399-11ec-1e1e-51db84a6b586
# ╟─e132e5b2-5399-11ec-079d-251c738cf1fa
# ╟─e132e5da-5399-11ec-2f61-5bd15dd580f4
# ╟─e132e5f8-5399-11ec-19bc-9dd0725909c2
# ╟─e132e616-5399-11ec-094f-af0c7796cfca
# ╟─e132ec06-5399-11ec-04ea-5f088ece9ab7
# ╟─e132ec42-5399-11ec-3bb7-6be57c319609
# ╟─e132ec60-5399-11ec-3215-eb11b970d2a5
# ╟─e132ec74-5399-11ec-24e3-4b8043888902
# ╟─e132ec9c-5399-11ec-26df-6f6ec8f4fea0
# ╟─e132f2d2-5399-11ec-2042-dd8b28f0e9cf
# ╟─e132f30e-5399-11ec-04e5-971c7f23d5b6
# ╟─e132f340-5399-11ec-1122-9dec9949d0be
# ╟─e132f35e-5399-11ec-37e4-d760587769fe
# ╟─e132f37c-5399-11ec-2708-bb735c885dc0
# ╟─e132f8f4-5399-11ec-10b1-dd37b9fc9795
# ╟─e132f91c-5399-11ec-0218-b50df5f8ae47
# ╟─e132f94e-5399-11ec-1cd5-d11ef2c8a086
# ╟─e132f96e-5399-11ec-2593-65f65ee657db
# ╟─e132f98a-5399-11ec-29f6-edbf92eb5caa
# ╟─e133010a-5399-11ec-07cd-dbbf0116ac14
# ╟─e1330128-5399-11ec-3e32-471188b5f280
# ╟─e1330148-5399-11ec-3b80-d7acab1559eb
# ╟─e1330164-5399-11ec-21b5-0952823a407a
# ╟─e1330182-5399-11ec-040d-c3bb6ff177a7
# ╟─e13307cc-5399-11ec-1ca0-03db023f88c9
# ╟─e1330808-5399-11ec-000b-2bd811e1bab1
# ╟─e133081c-5399-11ec-3306-3fdee3516fc4
# ╟─e1330844-5399-11ec-0db1-7d0986a04eb9
# ╟─e133086c-5399-11ec-0381-7b0728a4b381
# ╟─e1331046-5399-11ec-1409-7319e7ed0235
# ╟─e133105a-5399-11ec-2cf6-fb1f19f13659
# ╟─e1331096-5399-11ec-1752-81413c3efd1f
# ╟─e13310a0-5399-11ec-3883-6b6556d36d24
# ╟─e13310c0-5399-11ec-18ae-c101735793d1
# ╟─e13310e6-5399-11ec-180d-57788fa1f709
# ╟─e133135e-5399-11ec-0ab0-e36e1a4073de
# ╟─e1331370-5399-11ec-31c1-63c39bba1905
# ╟─e1331390-5399-11ec-0f56-e166a63b0d63
# ╟─e13313b6-5399-11ec-2014-d1ac1a9d7698
# ╟─e13313f0-5399-11ec-2e45-83c62feb297e
# ╟─e13330ee-5399-11ec-247f-d74afa2216af
# ╟─e13332d8-5399-11ec-3941-574c2b8d61d9
# ╟─e13332e2-5399-11ec-1f82-b7be1844ebc0
# ╟─e13332ee-5399-11ec-28fb-5921861c5b21
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
