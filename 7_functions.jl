### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 9dd7e8aa-53bf-11ec-0b13-85afa9ce3650
using CalculusWithJulia, Plots

# ╔═╡ 9dd7ecd8-53bf-11ec-2c1c-d53aa339dfa5
begin
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :functions
	nothing
end

# ╔═╡ 9de84b3c-53bf-11ec-0f9c-79bb41fc5eaa
using PlutoUI

# ╔═╡ 9de84b14-53bf-11ec-2231-c7237996641b
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 9dd7ce6a-53bf-11ec-3756-e3019b5b6a23
md"""# Functions
"""

# ╔═╡ 9dd7cea6-53bf-11ec-1fe2-1f4b860dcf8e
md"""This section will use the following add-on packages:
"""

# ╔═╡ 9dd7ed14-53bf-11ec-25b4-b5adb971081f
md"""---
"""

# ╔═╡ 9dd7ed8e-53bf-11ec-0d91-c97564f8552e
md"""A mathematical [function](http://en.wikipedia.org/wiki/Function_(mathematics)) is defined abstractly by
"""

# ╔═╡ 9dd80b64-53bf-11ec-03d1-e3fe37e05ce2
md"""> **Function:** A function is a *relation* which assigns to each element in the domain a *single* element in the range. A **relation** is a set of ordered pairs, $(x,y)$. The set of first coordinates is the domain, the set of second coordinates the range of the relation.

"""

# ╔═╡ 9dd80bb6-53bf-11ec-0a10-1398b37e747b
md"""That is, a function gives a correspondence between  values in its domain with  values in its range.
"""

# ╔═╡ 9dd80c2c-53bf-11ec-1ee6-4fdde3bf6782
md"""This definition is abstract, as functions can be very general. With single-variable calculus, we generally specialize to real-valued functions of a single variable (*scalar univariate functions*). These typically have the correspondence given by a rule, such as $f(x) = x^2$ or $f(x) = \sqrt{x}$. The function's domain may be implicit (as in all $x$ for which the rule is defined) or may be explicitly given as part of the rule. The function's range is then the image of its domain, or the set of all $f(x)$ for each $x$ in the domain ($\{f(x): x \in \text{ domain}\}$).
"""

# ╔═╡ 9dd80c36-53bf-11ec-3d70-075eb989331a
md"""Some examples of mathematical functions are:
"""

# ╔═╡ 9dd80c68-53bf-11ec-03a6-b9152dbf7144
md"""```math
f(x) = \cos(x), \quad g(x) = x^2 - x, \quad h(x) = \sqrt{x}, \quad
s(x) = \begin{cases} -1 & x < 0\\1&x>0\end{cases}.
```
"""

# ╔═╡ 9dd80cae-53bf-11ec-32cd-93fbf1602004
md"""For these examples, the domain of both $f(x)$ and $g(x)$ is all real values of $x$, where as for $h(x)$ it is implicitly just the set of non-negative numbers, $[0, \infty)$. Finally, for $s(x)$, we can see that the domain is defined for every $x$ but $0$.
"""

# ╔═╡ 9dd80cfe-53bf-11ec-2f00-89045bbe79db
md"""In general the range is harder to identify than the domain, and this is the case for these functions too. For $f(x)$ we know the $\cos$ function is trapped in $[-1,1]$ and it is intuitively clear than all values in that set are possible. The function $h(x)$ would have range $[0,\infty)$.  The $s(x)$ function is either $-1$ or $1$, so only has two possible values in its range.  What about $g(x)$? It is a parabola that opens upward, so any $y$ values below the $y$ value of its vertex will not appear in the range. In this case, the symmetry indicates that the vertex will be at $(1/2, -1/4)$, so the range is $[-1/4, \infty)$.
"""

# ╔═╡ 9dd88682-53bf-11ec-05a3-09d7ebf973de
note("""

**Thanks to Euler (1707-1783):** The formal idea of a function is a relatively modern concept in mathematics.  According to [Dunham](http://www.maa.org/sites/default/files/pdf/upload_library/22/Ford/dunham1.pdf),
  Euler defined a function as an "analytic expression composed in any way
  whatsoever of the variable quantity and numbers or constant
  quantities." He goes on to indicate that as Euler matured, so did
  his notion of function, ending up closer to the modern idea of a
  correspondence not necessarily tied to a particular formula or
  “analytic expression.” He finishes by saying: "It is fair to say
  that we now study functions in analysis because of him."

""")

# ╔═╡ 9dd88726-53bf-11ec-2bc3-f588e4cbf0a4
md"""We will see that defining functions within `Julia` can be as simple a concept as Euler started with, but that the more abstract concept has a great advantage that is exploited in the design of the language.
"""

# ╔═╡ 9dd88760-53bf-11ec-39e3-fbf0bb93ca32
md"""## Defining simple mathematical functions
"""

# ╔═╡ 9dd887a6-53bf-11ec-282d-73e8f764aeae
md"""The notation `Julia` uses to define simple mathematical functions could not be more closely related to how they are written mathematically. For example, the functions $f(x)$, $g(x)$, and $h(x)$ above may be defined by:
"""

# ╔═╡ 9dd88ce2-53bf-11ec-0b60-37f224aef487
begin
	f(x) = cos(x)
	g(x) = x^2 - x
	h(x) = sqrt(x)
end

# ╔═╡ 9dd88d3c-53bf-11ec-1aef-c3f4ac11cce3
md"""The left-hand sign of the equals sign is still an assignment, though in this case an assignment to a function object which has a name and a specification of an argument, $x$ in each case above, though other *dummy variables* could be used. The right hand side is simply `Julia` code to compute the *rule* corresponding to the function.
"""

# ╔═╡ 9dd88d50-53bf-11ec-1d5e-412157d6f859
md"""Calling the function also follows standard math notation:
"""

# ╔═╡ 9dd8a2e2-53bf-11ec-3a08-45f93bbe138e
f(pi), g(2), h(4)

# ╔═╡ 9dd8a310-53bf-11ec-250f-c530bc5def98
md"""For typical cases like the three above, there isn't really much new to learn.
"""

# ╔═╡ 9dd8efae-53bf-11ec-1b4d-d7efcb9774e2
note(""" The equals sign in the definition of a function above is an *assignment*. Assignment restricts the expressions available on the *left*-hand side to a) a variable name, b) an indexing assignment, as in `xs[1]`, or c) a function assignment following this form `function_name(args...)`. Whereas function definitions and usage in `Julia` mirrors standard math notation; equations in math are not so mirrored in `Julia`. In mathematical equations, the left-hand of an equation is typically a complicated algebraic expression. Not so with `Julia`, where the left hand side of the equals sign is prescribed and quite limited.
""")

# ╔═╡ 9dd8f01a-53bf-11ec-18ba-e52476d21a6a
md"""### The domain of a function
"""

# ╔═╡ 9dd8f092-53bf-11ec-347f-73153153a4ec
md"""Functions in `Julia` have an implicit domain, just as they do mathematically. In the case of $f(x)$ and $g(x)$, the right-hand side is defined for all real values of $x$, so the domain is all $x$. For $h(x)$ this isn't the case, of course. Trying to call $h(x)$ when $x < 0$ will give an error:
"""

# ╔═╡ 9dd90dd6-53bf-11ec-191e-4dd61fcdca5b
h(-1)

# ╔═╡ 9dd90e4c-53bf-11ec-0319-5bc4ada150d1
md"""The `DomainError` is one of many different error types `Julia` has, in this case it is quite apt: the value $-1$ is not in the domain of the function.
"""

# ╔═╡ 9dd90e60-53bf-11ec-0f39-65948bb34319
md"""### Equations, functions, calling a function
"""

# ╔═╡ 9dd90e74-53bf-11ec-05a6-7fcaae94962a
md"""Mathematically we tend to blur the distinction between the equation
"""

# ╔═╡ 9dd90e9c-53bf-11ec-1d90-792fd07ef547
md"""```math
y = 5/9 \cdot (x - 32)
```
"""

# ╔═╡ 9dd90eba-53bf-11ec-3ca4-47f5186df5ce
md"""and the function
"""

# ╔═╡ 9dd90ec4-53bf-11ec-0337-aba8d7cca4d5
md"""```math
f(x) = 5/9 \cdot (x - 32)
```
"""

# ╔═╡ 9dd90eec-53bf-11ec-3e1f-419ef79833d5
md"""In fact, the graph of a function $f(x)$ is simply defined as the graph of the equation $y=f(x)$. There is a distinction in `Julia` as a command such as
"""

# ╔═╡ 9dd929c0-53bf-11ec-24e5-932afee3a4cf
begin
	x = -40
	y = 5/9 * (x - 32)
end

# ╔═╡ 9dd929fe-53bf-11ec-025f-fdf202f6922f
md"""will evaluate the righthand side with the value of `x` bound at the time of assignment to `y`, whereas assignment to a function
"""

# ╔═╡ 9dd94934-53bf-11ec-032c-054ca494aaab
let
	f(x) = 5/9 * (x - 32)
	f(72)				## room temperature
end

# ╔═╡ 9dd94970-53bf-11ec-38e1-e1ee8e678a9b
md"""will create a function object with a value of `x` determined at a later time - the time the function is called. So the value of `x` defined when the function is created is not important here (as the value of `x` used by `f` is passed in as an argument).
"""

# ╔═╡ 9dd949ac-53bf-11ec-1f4b-1f17085c2d8f
md"""Within `Julia`, we make note of the distinction between a function object versus a function call. In the definition `f(x)=cos(x)`, the variable `f` refers to a function object, whereas the expression `f(pi)` is a function call. This mirrors the math notation where an $f$ is used when properties of a function are being emphasized (such as $f \circ g$ for composition) and $f(x)$ is used when the values related to the function are being emphasized (such as saying "the plot of the equation $y=f(x)$).
"""

# ╔═╡ 9dd949c2-53bf-11ec-0b1c-c9a5d9bee451
md"""Distinguishing these three related but different concepts (equations, function objects, and function calls) is important when modeling on the computer.
"""

# ╔═╡ 9dd949d4-53bf-11ec-0c99-45b52310d3f8
md"""### Cases
"""

# ╔═╡ 9dd949f4-53bf-11ec-0da0-a5e39930bf1a
md"""The definition of $s(x)$ above has two cases:
"""

# ╔═╡ 9dd94a06-53bf-11ec-341b-7f2dc17504a1
md"""```math
s(x) = \begin{cases} -1 & s < 0\\ 1 & s > 0. \end{cases}
```
"""

# ╔═╡ 9dd94a4c-53bf-11ec-0273-5be572e627c0
md"""We learn to read this as "If $s$ is less than $0$, then the answer is $-1$. If $s$ is greater than $0$ the answer is $1$." Often - but not in this example - there is an "otherwise" case to catch those values of $x$ that are not explicitly mentioned. As there is no such "otherwise" case here, we can see that this function has no definition when $x=0$. This function is often called the "sign" function and is also defined by $\lvert x\rvert/x$. (`Julia`'s `sign` function actually defines `sign(0)` to be `0`.)
"""

# ╔═╡ 9dd94a6a-53bf-11ec-134d-6da6b30d4041
md"""How do we create conditional statements in `Julia`? Programming languages generally have "if-then-else" constructs to handle conditional evaluation. In `Julia`, the following code will handle the above condition:
"""

# ╔═╡ 9dd94ad8-53bf-11ec-1be9-072c2b10e6c8
md"""```
if x < 0
  -1
elseif x > 0
   1
end
```"""

# ╔═╡ 9dd94b00-53bf-11ec-19ab-6905a9d47cc5
md"""The "otherwise" case would be caught with an `else` addition. So, for example, this would implement `Julia`'s definition of `sign` (which also assigns $0$ to $0$):
"""

# ╔═╡ 9dd94b1e-53bf-11ec-24b6-d31b5a03e00e
md"""```
if x < 0
  -1
elseif x > 0
   1
else
   0
end
```"""

# ╔═╡ 9dd94b46-53bf-11ec-3836-679b90c3e6f3
md"""The conditions for the `if` statements are expressions that evaluate to either `true` or `false`, such as generated by the Boolean operators `<`, `<=`, `==`, `!-`, `>=`, and `>`.
"""

# ╔═╡ 9dd94ba0-53bf-11ec-0e21-cd2d745b9af3
md"""If familiar with `if` conditions, they are natural to use. However, for simpler cases of "if-else" `Julia` provides the more convenient *ternary* operator: `cond ? if_true : if_false`. (The name comes from the fact that there are three arguments specified.) The ternary operator checks the condition and if true returns the first expression, whereas if the condition is false the second condition is returned. Both expressions are evaluated. (The [short-circuit](http://julia.readthedocs.org/en/latest/manual/control-flow/#short-circuit-evaluation) operators can be used to avoid both evaluations.)
"""

# ╔═╡ 9dd94bb4-53bf-11ec-3ceb-6fe8b8adf7c3
md"""For example, here is one way to define an absolute value function:
"""

# ╔═╡ 9dd965cc-53bf-11ec-305e-3fd98203e128
abs_val(x) = x >= 0 ? x : -x

# ╔═╡ 9dd96610-53bf-11ec-1f73-4184f0b8a25b
md"""The condition is `x >= 0` - or is `x` non-negative? If so, the value `x` is used, otherwise `-x` is used.
"""

# ╔═╡ 9dd96630-53bf-11ec-1815-f12f05aa9ec8
md"""Here is a means to implement a function which takes the larger of `x` or `10`:
"""

# ╔═╡ 9dd96b6c-53bf-11ec-1265-25e6202769d9
bigger_10(x) = x > 10 ? x : 10.0

# ╔═╡ 9dd96b9e-53bf-11ec-39a9-a15990f79358
md"""(This could also utilize the `max` function: `f(x) = max(x, 10.0)`.)
"""

# ╔═╡ 9dd96bb0-53bf-11ec-3cb7-6337cacf0c4f
md"""Or similarly, a function to represent a cell phone plan where the first 500 minutes are 20 dollars and every additional minute is 5 cents:
"""

# ╔═╡ 9dd9a33e-53bf-11ec-3c00-b9e818162370
cellplan(x) = x < 500 ? 20.0 : 20.0 + 0.05 * (x-500)

# ╔═╡ 9dd9f5d0-53bf-11ec-1fdd-27d2ab5776c6
alert("""

Type stability. These last two definitions used `10.0` and `20.0`
instead of the integers `10` and `20` for the answer. Why the extra
typing? When `Julia` can predict the type of the output from the type
of inputs, it can be more efficient. So when possible, we help out and
ensure the output is always the same type.

""")

# ╔═╡ 9dd9f62c-53bf-11ec-184c-abc85a18e76d
md"""##### Example
"""

# ╔═╡ 9dd9f672-53bf-11ec-04bb-e36f5164f173
md"""The `ternary` operator can be used to define an explicit domain. For example, a falling body might have height given by $h(t) = 10 - 16t^2$. This model only applies for non-negative $t$ and non-negative $h$ values. So, in particular $0 \leq t \leq \sqrt{10/16}$. To implement this function we might have:
"""

# ╔═╡ 9dda572a-53bf-11ec-39c1-f19ebf3398f7
let
	h(t) = 0 <= t <= sqrt(10/16) ? 10.0 - 16t^2 : error("t is not in the domain")
end

# ╔═╡ 9ddd0754-53bf-11ec-3e26-abbab1f3147f
md"""#### Nesting ternary operators
"""

# ╔═╡ 9ddd07cc-53bf-11ec-13ea-afed43fc6568
md"""The function `s(x)` isn't quite so easy to implement, as there isn't an "otherwise" case. We could use an `if` statement, but instead illustrate using a second, nested ternary operator:
"""

# ╔═╡ 9ddd1280-53bf-11ec-3098-a9cd87eab914
s(x) = x < 0 ? 1 :
    x > 0 ? 1 : error("0 is not in the domain")

# ╔═╡ 9ddd12ba-53bf-11ec-1a28-ebc4fb7f742c
md"""With nested ternary operators, the advantage over the `if` condition is not very compelling, but for simple cases the ternary operator is quite useful.
"""

# ╔═╡ 9ddd12f8-53bf-11ec-272d-e578e49b0d4b
md"""## Functions defined with the "function" keyword
"""

# ╔═╡ 9ddd1316-53bf-11ec-2cd3-eb2d65efe32f
md"""For more complicated functions, say one with a few steps to compute, an alternate form for defining a function can be used:
"""

# ╔═╡ 9ddd133e-53bf-11ec-0b53-37405e0cc841
md"""```
function function_name(function_arguments)
  ...function_body...
end
```"""

# ╔═╡ 9ddd135c-53bf-11ec-0686-c77a9ad4398e
md"""The last value computed is returned unless the `function_body` contains an explicit `return` statement.
"""

# ╔═╡ 9ddd1390-53bf-11ec-2555-e7bbd6d5bc4d
md"""For example, the following is a more verbose way to define $f(x) = x^2$:
"""

# ╔═╡ 9ddd3198-53bf-11ec-0f02-710aa7542634
let
	function f(x)
	  return x^2
	end
end

# ╔═╡ 9ddd31de-53bf-11ec-3f9f-b17d790c6f09
md"""The line `return x^2`, could have just been `x^2` as it is the last (and) only line evaluated.
"""

# ╔═╡ 9ddd6be0-53bf-11ec-3cf8-8d934cb36766
note("""
The `return` keyword is not a function, so is not called with parentheses. An emtpy `return` statement will return a value of `nothing`.
""")

# ╔═╡ 9ddd6c3a-53bf-11ec-0fdb-9dd659f97cfc
md"""##### Example
"""

# ╔═╡ 9ddd6c94-53bf-11ec-17ee-2da4b23af589
md"""Imagine we have the following complicated function related to the trajectory of a [projectile](http://www.researchgate.net/publication/230963032_On_the_trajectories_of_projectiles_depicted_in_early_ballistic_woodcuts) with wind resistance:
"""

# ╔═╡ 9ddd6cc6-53bf-11ec-3e63-05bd5202603b
md"""```math
	f(x) = \left(\frac{g}{k v_0\cos(\theta)} + \tan(\theta) \right) x + \frac{g}{k^2}\ln\left(1 - \frac{k}{v_0\cos(\theta)} x \right)
```
"""

# ╔═╡ 9ddd6d16-53bf-11ec-2096-65d55eb42037
md"""Here $g$ is the gravitational constant $9.8$ and $v_0$, $\theta$ and $k$ parameters, which we take to be $200$, $45$ degrees and $1/2$ respectively. With these values, the above function can be computed when $x=100$ with:
"""

# ╔═╡ 9dddbdca-53bf-11ec-11e9-fb09ff6846aa
function trajectory(x)
  g, v0, theta, k = 9.8, 200, 45*pi/180, 1/2
  a = v0 * cos(theta)

  (g/(k*a) + tan(theta))* x + (g/k^2) * log(1 - k/a*x)
end

# ╔═╡ 9dddc1b2-53bf-11ec-3016-b705ca0d6db7
trajectory(100)

# ╔═╡ 9dddc202-53bf-11ec-05a6-a5caaecaf37b
md"""By using a multi-line function our work is much easier to look over for errors.
"""

# ╔═╡ 9dddc266-53bf-11ec-29f6-f9fd320b3e90
md"""##### Example: the secant method for finding a solution to $f(x) = 0$.
"""

# ╔═╡ 9dddc27a-53bf-11ec-0eb8-c972d442a999
md"""This next example, shows how using functions to collect a set of computations for simpler reuse can be very helpful.
"""

# ╔═╡ 9dddc2ca-53bf-11ec-0c87-538e0ad7e061
md"""An old method for finding a zero of an equation is the [secant method](https://en.wikipedia.org/wiki/Secant_method). We illustrate the method with the function $f(x) = x^2 - 2$. In an upcoming example we saw how to create a function to evaluate the secant line between $(a,f(a))$ and $(b, f(b))$ at any point. In this example, we define a function to compute the $x$ coordinate of where the secant line crosses the $x$ axis. This can be defined as follows:
"""

# ╔═╡ 9dddf510-53bf-11ec-38f0-4942fe040876
function secant_intersection(f, a, b)
   # solve 0 = f(b) + m * (x-b) where m is the slope of the secant line
   # x = b - f(b) / m
   m = (f(b) - f(a)) / (b - a)
   b - f(b) / m
end

# ╔═╡ 9dddf59c-53bf-11ec-04f2-c914549efc27
md"""We utilize this as follows. Suppose we wish to solve $f(x) = 0$ and we have two "rough" guesses for the answer. In our example, we wish to solve $q(x) = x^2 - 2$ and our "rough" guesses are $1$ and $2$. Call these values $a$ and $b$. We *improve* our rough guesses by finding a value $c$ which is the intersection point of the secant line.
"""

# ╔═╡ 9dde130e-53bf-11ec-0ac1-5d7f77cfb328
begin
	q(x) = x^2 - 2
	𝒂, 𝒃 = 1, 2
	𝒄 = secant_intersection(q, 𝒂, 𝒃)
end

# ╔═╡ 9dde134c-53bf-11ec-3a04-69343ecacc91
md"""In our example, we see that in trying to find an answer to $f(x) = 0$ ( $\sqrt{2}\approx 1.414\dots$) our value found from the intersection point is a better guess than either $a=1$ or $b=2$:
"""

# ╔═╡ 9dde19b6-53bf-11ec-06e8-514a5c598ba6
begin
	plot(q, 𝒂, 𝒃, linewidth=5, legend=false)
	plot!(zero, 𝒂, 𝒃)
	plot!([𝒂, 𝒃], q.([𝒂, 𝒃]))
	scatter!([𝒄], [q(𝒄)])
end

# ╔═╡ 9dde19f0-53bf-11ec-3dc2-ed3228e50c15
md"""Still,  `q(𝒄)` is not really close to $0$:
"""

# ╔═╡ 9dde1ba8-53bf-11ec-36d2-111bbbb62fd7
q(𝒄)

# ╔═╡ 9ddf4d34-53bf-11ec-3f8c-25057527ae03
md"""*But* it is much closer than either $q(a)$ or $q(b)$, so it is an improvement. This suggests renaming $a$ and $b$ with the old $b$ and $c$ values and trying again we might do better still:
"""

# ╔═╡ 9ddf53c4-53bf-11ec-271d-ad27ea6bd869
let
	𝒂, 𝒃 = 𝒃, 𝒄
	𝒄 = secant_intersection(q, 𝒂, 𝒃)
	q(𝒄)
end

# ╔═╡ 9ddf540a-53bf-11ec-2ce6-f167ca168a31
md"""Yes, now the function value at this new $c$ is even closer to $0$. Trying a few more times we see we just get closer and closer. He we start again to see the progress
"""

# ╔═╡ 9ddf94ce-53bf-11ec-351e-3bd9771f3819
let
	with_terminal() do
		𝒂,𝒃 = 1, 2
		for step in 1:6
		    𝒂, 𝒃 = 𝒃, secant_intersection(q, 𝒂, 𝒃)
		    current = (c=𝒃, qc=q(𝒃))
		    @show current
		end
	end
end

# ╔═╡ 9ddf9528-53bf-11ec-39d0-971e7ca2bbcd
md"""Now our guess $c$ is basically the same as `sqrt(2)`. Repeating the above leads to only a slight improvement in the guess, as we are about as close as floating point values will allow.
"""

# ╔═╡ 9ddf9546-53bf-11ec-14fe-81e5c8660e1b
md"""Here we see a visualization with all these points. As can be seen, it quickly converges at the scale of the visualization, as we can't see much closer than `1e-2`.
"""

# ╔═╡ 9ddf9bc2-53bf-11ec-3e89-09b8172f64c9
let
	f(x) = x^2 - 2
	a, b = 1, 2
	c = secant_intersection(f, a, b)
	
	p = plot(f, a, b, linewidth=5, legend=false)
	plot!(p, zero, a, b)
	
	plot!(p, [a,b], f.([a,b]));
	scatter!(p, [c], [f(c)])
	
	a, b = b, c
	c = secant_intersection(f, a, b)
	plot!(p, [a,b], f.([a,b]));
	scatter!(p, [c], [f(c)])
	
	
	a, b = b, c
	c = secant_intersection(f, a, b)
	plot!(p, [a,b], f.([a,b]));
	scatter!(p, [c], [f(c)])
	p
end

# ╔═╡ 9ddf9be0-53bf-11ec-0864-490ca9cbd1b8
md"""In most cases, this method can fairly quickly find a zero provided two good starting points are used.
"""

# ╔═╡ 9ddf9c08-53bf-11ec-23c0-f90f0d5441bf
md"""## Parameters, function context (scope), keyword arguments
"""

# ╔═╡ 9ddf9c1c-53bf-11ec-3ae3-6727293167f7
md"""Consider two functions implementing the slope-intercept form and point-slope form of a line:
"""

# ╔═╡ 9ddf9c3a-53bf-11ec-00be-efd9891ad759
md"""```math
f(x) = m \cdot x + b, \quad g(x) = y_0 + m \cdot (x - x_0).
```
"""

# ╔═╡ 9ddf9c82-53bf-11ec-2beb-6166c8136e18
md"""Both functions use the variable $x$, but there is no confusion, as we learn that this is just a dummy variable to be substituted for and so could have any name. Both also share a variable $m$ for a slope. Where does that value come from? In practice, there is a context that gives an answer. Despite the same name, there is no expectation that the slope will be the same for each function if the context is different. So when parameters are involved, a function involves a rule and a context to give specific values to the parameters. Euler had said initially that functions a composed of "the variable quantity and numbers or constant quantities." The term "variable," we still use, but instead of "constant quantities," we use the name "parameters."
"""

# ╔═╡ 9ddf9ca8-53bf-11ec-3908-4dd454fb1fbe
md"""Something similar is also true with `Julia`.  Consider the example of writing a function to model a linear equation with slope $m=2$ and $y$-intercept $3$. A typical means to do this would be to define constants, and then use the familiar formula:
"""

# ╔═╡ 9ddfa20c-53bf-11ec-1294-a95c9ed16c16
begin
	m, b = 2, 3
	mxplusb(x) = m*x + b
end

# ╔═╡ 9ddfa23e-53bf-11ec-005d-eb6cba28faf1
md"""This will work as expected. For example, $f(0)$ will be $b$  and $f(2)$ will be $7$:
"""

# ╔═╡ 9ddfb616-53bf-11ec-1b1a-c1494f8143ad
mxplusb(0), mxplusb(2)

# ╔═╡ 9ddfb672-53bf-11ec-2876-3b041f5f2358
md"""All fine, but what if somewhere later the values for $m$ and $b$ were *redefined*, say with $m,b = 3,2$?
"""

# ╔═╡ 9ddfb6ac-53bf-11ec-3755-719adf3abc73
md"""Now what happens with $f(0)$? When $f$ was defined `b` was $3$, but now if we were to call `f`, `b` is 2. Which value will we get? More generally, when `f` is being evaluated in what context does `Julia` look up the bindings for the variables it encounters? It could be that the values are assigned when the function is defined, or it could be that the values for the parameters are resolved when the function is called. If the latter, what context will be used?
"""

# ╔═╡ 9ddfb6b6-53bf-11ec-3a12-513ec60ef726
md"""Before discussing this, let's just see in this case:
"""

# ╔═╡ 9ddfbc72-53bf-11ec-1ce7-0b576bf77086
let
	m, b = 3, 2
	mxplusb(0)
end

# ╔═╡ 9ddfbca4-53bf-11ec-248c-d92198a24d2b
md"""So the `b` is found from the currently stored value. This fact can be exploited. we can write template-like functions, such as `f(x)=m*x+b` and reuse them just by updating the parameters separately.
"""

# ╔═╡ 9ddfbcf6-53bf-11ec-25d0-1fed6aa844f3
md"""How `Julia` resolves what a variable refers to is described in detail in the manual page [Scope of Variables](http://julia.readthedocs.org/en/latest/manual/variables-and-scoping/). In this case, the function definition finds variables in the context of where the function was defined, the main workspace. As seen, this context can be modified after the function definition and prior to the function call. It is only when `b` is needed, that the context is consulted, so the most recent binding is retrieved.  Contexts (more formally known as environments) allow the user to repurpose variable names without there being name collision. For example, we typically use `x` as a function argument, and different contexts allow this `x` to refer to different values.
"""

# ╔═╡ 9ddfbd32-53bf-11ec-2876-e33849f14378
md"""Mostly this works as expected, but at times it can be complicated to reason about. In our example, definitions of the parameters can be forgotten, or the same variable name may have been used for some other purpose. The potential issue is with the parameters, the value for `x` is straightforward, as it is passed into the function. However, we can also pass the parameters, such as $m$ and $b$, as arguments.  For parameters, we suggest using [keyword](http://julia.readthedocs.org/en/latest/manual/functions/#keyword-arguments) arguments. These allow the specification of parameters, but also give a default value. This can make usage explicit, yet still convenient. For example, here is an alternate way of defining a line with parameters `m` and `b`:
"""

# ╔═╡ 9ddfc458-53bf-11ec-03cb-27fdb6d83762
mxb(x; m=1, b=0) = m*x + b

# ╔═╡ 9ddfc494-53bf-11ec-2b49-87946bc7f751
md"""The right-hand side is identical to before, but the left hand side is different. Arguments defined *after* a semicolon are keyword arguments. They are specified as `var=value` (or `var::Type=value` to restrict the type) where the value is used as the default, should a value not be specified when the function is called.
"""

# ╔═╡ 9ddfc4a8-53bf-11ec-1ff3-9504171a8483
md"""Calling a function with keyword arguments can be identical to before:
"""

# ╔═╡ 9ddfc674-53bf-11ec-36c3-39c583e76d9f
mxb(0)

# ╔═╡ 9ddfc6b0-53bf-11ec-2ead-5794b62d5ee3
md"""During this call, values for `m` and `b` are found from how the function is called, not the main workspace. In this case, nothing is specified so the defaults of $m=1$ and $b=0$ are used. Whereas, this call will use the user-specified values for `m` and `b`:
"""

# ╔═╡ 9ddfcb6a-53bf-11ec-1a96-f76d91734607
mxb(0, m=3, b=2)

# ╔═╡ 9ddfcba6-53bf-11ec-2cae-b3eaa58a2c84
md"""Keywords are used to mark the parameters whose values are to be changed from the default. Though one can use *positional arguments* for parameters - and there are good reasons to do so - using keyword arguments is a good practice if performance isn't paramount, as their usage is more explicit yet the defaults mean that a minimum amount of typing needs to be done.
"""

# ╔═╡ 9ddfcbce-53bf-11ec-299f-49b52aefb46f
md"""##### Example
"""

# ╔═╡ 9ddfcbe2-53bf-11ec-2728-abccb4566f46
md"""In the example for multi-line functions we hard coded many variables inside the body of the function. In practice it can be better to pass these in as parameters along the lines of:
"""

# ╔═╡ 9de0111c-53bf-11ec-2951-8757620d13e1
let
	function trajectory(x; g = 9.8, v0 = 200, theta = 45*pi/180, k = 1/2)
	  a = v0 * cos(theta)
	  (g/(k*a) + tan(theta))* x + (g/k^2) * log(1 - k/a*x)
	end
	trajectory(100)
end

# ╔═╡ 9de18fc2-53bf-11ec-0f13-47b9cebbdff1
md"""#### `f(x,p)` alternative
"""

# ╔═╡ 9de1903a-53bf-11ec-2e12-cb0bd732b888
md"""An alternative to keyword arguments is to bundle the parameters into a container and pass them as a single argument to the function. This style is used in the `SciML` suite of packages.
"""

# ╔═╡ 9de19074-53bf-11ec-0e2d-f7bcfb178116
md"""For example, here we use a *named tuple* to pass parameters to `f`:
"""

# ╔═╡ 9de1bc90-53bf-11ec-2ac6-fb89d47724ed
let
	function trajectory(x,p)
	    g,v0, theta, k = p.g, p.v0, p.theta, p.k # unpack parameters
	
	    a = v0 * cos(theta)
	    (g/(k*a) + tan(theta))* x + (g/k^2) * log(1 - k/a*x)
	end
	
	p = (g=9.8, v0=200, theta = 45*pi/180, k=1/2)
	trajectory(100, p)
end

# ╔═╡ 9de1bcfe-53bf-11ec-2710-55032d600bd4
md"""The style isn't so different from using keyword arguments, save the extra step of unpacking the parameters. The *big* advantage is consistency – the function is always called in an identical manner regardless of the number of parameters (or variables).
"""

# ╔═╡ 9de1bd3a-53bf-11ec-1f49-1b9d9999e902
md"""## Multiple dispatch
"""

# ╔═╡ 9de1bd58-53bf-11ec-03d6-d7fe38212403
md"""The concept of a function is of much more general use than its restriction to mathematical functions of single real variable. A natural application comes from describing basic properties of geometric objects. The following function definitions likely will cause no great concern when skimmed over:
"""

# ╔═╡ 9de1db30-53bf-11ec-3531-2bd3d30e571c
let
	Area(w, h) = w * h		                   # of a rectangle
	Volume(r, h) = pi * r^2 * h	                   # of a cylinder
	SurfaceArea(r, h) = pi * r * (r + sqrt(h^2 + r^2)) # of a right circular cone, including the base
end

# ╔═╡ 9de1db80-53bf-11ec-2240-a79b833d038f
md"""The right-hand sides may or may not be familiar, but it should be reasonable to believe that if push came to shove, the formulas could be looked up. However, the left-hand sides are subtly different - they have two arguments, not one. In `Julia` it is trivial to define functions with multiple arguments - we just did.
"""

# ╔═╡ 9de1db9e-53bf-11ec-1523-bf00fcedc1b9
md"""Earlier we saw the `log` function can use a second argument to express the base. This function is basically defined by `log(b,x)=log(x)/log(b)`. The `log(x)` value is the natural log, and this definition just uses the change-of-base formula for logarithms.
"""

# ╔═╡ 9de1dc02-53bf-11ec-27e6-75195785294c
md"""But not so fast, on the left side is a function with two arguments and on the right side the functions have one argument - yet they share the same name. How does `Julia` know which to use? `Julia` uses the number, order, and *type* of the positional arguments passed to a function to determine which function definition to use. This is technically known as [multiple dispatch](http://en.wikipedia.org/wiki/Multiple_dispatch) or **polymorphism**. As a feature of the language, it can be used to greatly simplify the number of functions the user must learn. The basic idea is that many functions are "generic" in that they will work for many different scenarios.
"""

# ╔═╡ 9de220ea-53bf-11ec-3a48-459ca2379dff
alert("""
Multiple dispatch is very common in mathematics. For example, we learn different ways to add: integers (fingers, carrying), real numbers (align the decimal points), rational numbers (common denominators), complex numbers (add components), vectors (add components), polynomials (combine like monomials), ... yet we just use the same `+` notation for each operation. The concepts are related, the details different.
""")

# ╔═╡ 9de3672a-53bf-11ec-3709-4b47b7421807
md"""`Julia` is similarly structured.  `Julia` terminology would be to call the operation "`+`" a *generic function* and the different implementations *methods* of "`+`". This allows the user to just need to know a smaller collection of generic concepts yet still have the power of detail-specific implementations.  To see how many different methods are defined in the base `Julia` language for the `+` operator, we can use the command `methods(+)`. As there are so many ($\approx 200$) and that number is growing, we illustrate how many different logarithm methods are implemented for "numbers:"
"""

# ╔═╡ 9de36b62-53bf-11ec-1cd6-4f8e5d0df7e3
methods(log, (Number,))

# ╔═╡ 9de36bd0-53bf-11ec-107f-63e61bdbb545
md"""(The arguments have *type annotations* such as `x::Float64` or `x::BigFloat`. `Julia` uses these to help resolve which method should be called for a given set of arguments. This allows for different operations depending on the variable type. For example, in this case, the `log` function for `Float64` values uses a fast algorithm, whereas for `BigFloat` values an algorithm that can handle multiple precision is used.)
"""

# ╔═╡ 9de36bf8-53bf-11ec-3008-13416c6b15ad
md"""##### Example. An application of composition and multiple dispatch
"""

# ╔═╡ 9de36c1e-53bf-11ec-0b69-790742f50489
md"""As mentioned `Julia`'s multiple dispatch allows multiple functions with the same name. The function that gets selected depends not just on the type of the arguments, but also on the number of arguments given to the function. We can exploit this to simplify our tasks. For example, consider this optimization problem:
"""

# ╔═╡ 9de36ce8-53bf-11ec-2269-4dff44d5ccfb
md"""> For all rectangles of perimeter 20, what is the one with largest area?

"""

# ╔═╡ 9de36cf4-53bf-11ec-1476-03d5a08b8005
md"""The start of this problem is to represent the area in terms of one variable. We see next that composition can simplify this task, which when done by hand requires a certain amount of algebra.
"""

# ╔═╡ 9de36d06-53bf-11ec-272f-1b7b0e0b5fa6
md"""Representing the area of a rectangle in terms of two variables is easy, as the familiar formula of width times height applies:
"""

# ╔═╡ 9de37076-53bf-11ec-2cce-c54f6e7e97de
Area(w, h) = w * h

# ╔═╡ 9de370bc-53bf-11ec-3dd7-ab52eb95f97d
md"""But the other fact about this problem - that the perimeter is $20$ - means that height depends on width. For this question, we can see that $P=2w + 2h$ so that - as a function - `height` depends on `w` as follows:
"""

# ╔═╡ 9de389da-53bf-11ec-279d-69311915f78d
height(w) = (20  - 2*w)/2

# ╔═╡ 9de38a3e-53bf-11ec-264d-0ff00afe50e6
md"""By hand we would substitute this last expression into that for the area and simplify (to get $A=w\cdot (20-2 \cdot w)/2 = -w^2 + 10$). However, within `Julia` we can let *composition* do the substitution and leave the algebraic simplification for `Julia` to do:
"""

# ╔═╡ 9de3a096-53bf-11ec-1a1d-b155b32524db
Area(w) = Area(w, height(w))

# ╔═╡ 9de3a106-53bf-11ec-2b1e-a5d6df6f1a9c
md"""This might seem odd, just like with `log`, we now  have two *different* but related functions named `Area`. Julia will decide which to use based on the number of arguments when the function is called. This setup allows both to be used on the same line, as above. This usage style is not so common with many computer languages, but is a feature of `Julia` which is built around the concept of *generic* functions with multiple dispatch rules to decide which rule to call.
"""

# ╔═╡ 9de3a1b8-53bf-11ec-26f7-eb2d87e2fec2
md"""For example, jumping ahead a bit, the `plot` function of `Plots`  expects functions of a single numeric variable. Behind the scenes, then the function `A(w)` will be used in this graph:
"""

# ╔═╡ 9de3a5d0-53bf-11ec-1ac0-87b77c3047b5
plot(Area, 0, 10)

# ╔═╡ 9de3a602-53bf-11ec-1f08-cbf94aca0331
md"""From the graph, we can see that that width for maximum area is $w=5$ and so $h=5$ as well.
"""

# ╔═╡ 9de3a622-53bf-11ec-2ede-fbe5b1f2140c
md"""## Anonymous functions
"""

# ╔═╡ 9de3a636-53bf-11ec-1162-cf9c9913b3eb
md"""Simple mathematical functions have a domain and range which are a subset of the real numbers, and generally have a concrete mathematical rule. However, the definition of a function is much more abstract. We've seen that functions for computer languages can be more complicated too, with, for example, the possibility of multiple input values. Things can get more abstract still.
"""

# ╔═╡ 9de3a64a-53bf-11ec-01b9-5987797a0f5c
md"""Take for example, the idea of the shift of a function. The following mathematical definition of a new function $g$ related to a function $f$:
"""

# ╔═╡ 9de3a674-53bf-11ec-17c6-2b9031a20fac
md"""```math
g(x) = f(x-c)
```
"""

# ╔═╡ 9de3a6c2-53bf-11ec-1575-ddc053548f2a
md"""has an interpretation - the graph of $g$ will be the same as the graph of $f$ shifted to the right by $c$ units. That is $g$ is a transformation of $f$. From one perspective, the act of replacing $x$ with $x-c$ transforms a function into a new function. Mathematically, when we focus on transforming functions, the word [operator](http://en.wikipedia.org/wiki/Operator_%28mathematics%29) is sometimes used. This concept of transforming a function can be viewed as a certain type of function, in an abstract enough way. The relation would be just pairs of functions $(f,g)$ where $g(x) = f(x-c)$.
"""

# ╔═╡ 9de3a6e0-53bf-11ec-1f7b-0d410a41f85c
md"""With `Julia` we can represent such operations. The simplest thing would be to do something like:
"""

# ╔═╡ 9de3aeec-53bf-11ec-183c-739aeb6c04cf
let
	f(x) = x^2 - 2x
	g(x) = f(x -3)
end

# ╔═╡ 9de3af32-53bf-11ec-0937-2ba966b64ad7
md"""Then $g$ has the graph of $f$ shifted by 3 units to the right. Now `f` above refers to something in the main workspace, in this example a specific function. Better would be to allow `f` to be an argument of a function, like this:
"""

# ╔═╡ 9de3b5d6-53bf-11ec-06e3-7ff3de39e202
function shift_right(f; c=0)
  function(x)
    f(x - c)
  end
end

# ╔═╡ 9de3b626-53bf-11ec-2b0b-b10c7c7c26ee
md"""That takes some parsing. In the body of the `shift_right` is the definition of a function. But this function has no name– it is *anonymous*. But what it does should be clear - it subtracts $c$ from $x$ and evaluates $f$ at this new value. Since the last expression creates a function, this function is returned by `shift_right`.
"""

# ╔═╡ 9de3b63a-53bf-11ec-0fb6-e3915c8e2e91
md"""So we could have done something more complicated like:
"""

# ╔═╡ 9de3bb5a-53bf-11ec-268e-83d7295dd282
begin
	p(x) = x^2 - 2x
	l = shift_right(p, c=3)
end

# ╔═╡ 9de3bb80-53bf-11ec-2f02-9923556a54f9
md"""Then `l` is a function that is derived from `p`.
"""

# ╔═╡ 9de3f690-53bf-11ec-14b9-e75fc605ece2
note("""
The value of `c` used when `l` is called is the one passed to `shift_right`. Functions like `l` that are returned by other functions also are called *closures*, as the context they are evaluated within included the context of the function that constructs them.
""")

# ╔═╡ 9de3f6c2-53bf-11ec-15fa-23b63ab94485
md"""Anonymous functions can be created with the `function` keyword, but we will use the "arrow" notation, `arg->body` to create them, The above, could have been defined as:
"""

# ╔═╡ 9de3fcb2-53bf-11ec-3a77-1b932d4bfb13
shift_right_alt(f; c=0) = x -> f(x-c)

# ╔═╡ 9de3fd70-53bf-11ec-03d3-216a693d6efa
md"""When the `->` is seen a function is being created.
"""

# ╔═╡ 9de4926c-53bf-11ec-1dd7-991031e25c40
alert("""

Generic versus anonymous functions. Julia has two types of functions,
generic ones, as defined by `f(x)=x^2` and anonymous ones, as defined
by `x -> x^2`. One gotcha is that `Julia` does not like to use the
same variable name for the two types.  In general, Julia is a dynamic
language, meaning variable names can be reused with different types
of variables. But generic functions take more care, as when a new
method is defined it gets added to a method table. So repurposing the
name of a generic function for something else is not allowed (well, in `Pluto` it is.). Similarly,
repurposing an already defined variable name for a generic function is
not allowed. This comes up when we use functions that return functions
as we have different styles that can be used: When we defined `l =
shift_right(f, c=3)` the value of `l` is assigned an anonymous
function. This binding can be reused to define other variables.
However, we could have defined the function `l` through `l(x) =
shift_right(f, c=3)(x)`, being explicit about what happens to the
variable `x`. This would have made `l` a generic function. Meaning, we
get an error if we tried to assign a variable to `l`, such as an
expression like `l=3`. We generally employ the latter style, even though
it involves a bit more typing, as we tend to stick to generic
functions for consistency.

""")

# ╔═╡ 9de492b2-53bf-11ec-1a07-f38c72aceb6d
md"""##### Example: the secant line
"""

# ╔═╡ 9de492f8-53bf-11ec-2b11-3dd53ddd72d1
md"""A secant line is a line through two points on the graph of a function. If we have a function $f(x)$, and two $x$-values $x=a$ and $x=b$, then we can find the slope between the points $(a,f(a))$ and $(b, f(b))$ with:
"""

# ╔═╡ 9de4930a-53bf-11ec-0f11-07b69144a5a9
md"""```math
m = \frac{f(b) - f(a)}{b - a}.
```
"""

# ╔═╡ 9de4932a-53bf-11ec-30d6-01eca2d12485
md"""The point-slope form a line then gives the equation of the tangent line as $y = f(a) + m \cdot (x - a)$.
"""

# ╔═╡ 9de49352-53bf-11ec-3850-6191f3ef6610
md"""To model this in `Julia`, we would want to turn the inputs `f`,`a`, `b` into a function that implements the secant line (functions are much easier to work with than equations). Here is how we can do it:
"""

# ╔═╡ 9de4aca2-53bf-11ec-11c2-1fd6a3bac0bc
function secant(f, a, b)
   m = (f(b) - f(a)) / (b-a)
   x -> f(a) + m * (x - a)
end

# ╔═╡ 9de4acf2-53bf-11ec-13b0-49004bf677c9
md"""The body of the function nearly mirrors the mathematical treatment. The main difference is in place of $y = \dots$ we have a `x -> ...` to create an anonymous function.
"""

# ╔═╡ 9de4ad1a-53bf-11ec-1d73-59cd72a27c8c
md"""To illustrate the use, suppose $f(x) = x^2 - 2$ and we have the secant line between $a=1$ and $b=2$. The value at $x=3/2$ is given by:
"""

# ╔═╡ 9de4b288-53bf-11ec-3ef1-91b724895c14
let
	f(x) = x^2 - 2
	a,b = 1, 2
	secant(f,a,b)(3/2)
end

# ╔═╡ 9de4b2a6-53bf-11ec-1a9c-3537859d981d
md"""The last line employs double parentheses. The first pair, `secant(f,a,b)`, returns a function and the second pair, `(3/2)`, are used to call the returned function.
"""

# ╔═╡ 9de4b2e2-53bf-11ec-15f1-ad5b8b4855f1
md"""### The `do` notation
"""

# ╔═╡ 9de4b314-53bf-11ec-3711-7527bab97fd6
md"""Many functions in `Julia` accept a function as the first argument. A common pattern for calling some function is `action(f, args...)` where `action` is the function that will act on another function `f` using the value(s) in `args...`. There `do` notation is syntactical sugar for creating an anonymous function which is useful when more complicated function bodies are needed.
"""

# ╔═╡ 9de4b332-53bf-11ec-2b56-5bc633d0b519
md"""Here is an artificial example to illustrate of a task we won't have cause to use in these notes, but is an important skill in some contexts. The `do` notation can be confusing to read, as it moves the function definition to the end and not the beginning, but is convenient to write and is used very often with the task of this example.
"""

# ╔═╡ 9de4b350-53bf-11ec-201a-45a06cb13628
md"""To save some text to a file requires a few steps: opening the file; writing to the file; closing the file. The `open` function does the first. It has this signature `open(f::Function, args...; kwargs....)` and is documented to "Apply the function f to the result of `open(args...; kwargs...)` and close the   resulting file descriptor upon completion." Which is great, the open and close stages are handled by `Julia` and only the writing is up to the user.
"""

# ╔═╡ 9de4b364-53bf-11ec-07f7-69104452f425
md"""The writing is done in the function of a body, so the `do` notation allows the creation of the function to be handled anonymously. In this context, the argument to this function will be an `IO` handle, which is typically called `io`.
"""

# ╔═╡ 9de4b378-53bf-11ec-1eff-7b422e355aca
md"""So the pattern would be
"""

# ╔═╡ 9de4b3a2-53bf-11ec-3daa-67fa398b688e
md"""```
open("somefile.txt", "w") do io
    write(io, "Four score and seven")
    write(io, "years ago...")
end
```"""

# ╔═╡ 9de4b3be-53bf-11ec-241e-33d4cfbf670d
md"""The name of the file to open appears, how the file is to be opened (`w` means write, `r` would mean read), and then a function with argument `io` which writes to lines to `io`.
"""

# ╔═╡ 9de4b3dc-53bf-11ec-2408-914aaf59047d
md"""## Questions
"""

# ╔═╡ 9de4b3f0-53bf-11ec-3142-f7aedcbf671d
md"""##### Question
"""

# ╔═╡ 9de4b40e-53bf-11ec-3fa1-0bcf8ec3b5f2
md"""State the domain and range of $f(x) = |x + 2|$.
"""

# ╔═╡ 9de4c2b6-53bf-11ec-3f06-2b1e074cf5b7
let
	choices = [
	"Domain is all real numbers, range is all real numbers",
	"Domain is all real numbers, range is all non-negative numbers",
	"Domain is all non-negative numbers, range is all real numbers",
	"Domain is all non-negative numbers, range is all non-negative numbers"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 9de4c2d2-53bf-11ec-3ea6-d99276851d5e
md"""##### Question
"""

# ╔═╡ 9de4c2f0-53bf-11ec-03b9-c516b8ad04bd
md"""State the domain and range of $f(x) = 1/(x-2)$.
"""

# ╔═╡ 9de4f856-53bf-11ec-2822-b56fca1a30bf
let
	choices = [
	"Domain is all real numbers, range is all real numbers",
	L"Domain is all real numbers except $2$, range is all real numbers except $0$",
	L"Domain is all non-negative numbers except $0$, range is all real numbers except $2$",
	L"Domain is all non-negative numbers except $-2$, range is all non-negative numbers except $0$"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 9de4f89c-53bf-11ec-197c-331f012b66e5
md"""##### Question
"""

# ╔═╡ 9de4f8d8-53bf-11ec-03c7-e57e238dc499
md"""Which of these functions has a domain of all real $x$, but a range of $x > 0$?
"""

# ╔═╡ 9de51d0e-53bf-11ec-1a4d-d3bef407a088
let
	choices = [
	raw"``f(x) = 2^x``",
	raw"``f(x) = 1/x^2``",
	raw"``f(x) = |x|``",
	raw"``f(x) = \sqrt{x}``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 9de51d7c-53bf-11ec-29ae-c5e73b1b261f
md"""###### Question
"""

# ╔═╡ 9de51db8-53bf-11ec-2ec4-0d1c13471bb5
md"""Which of these commands will make a function for $f(x) = \sin(x + \pi/3)$?
"""

# ╔═╡ 9de52a1a-53bf-11ec-2bea-63b702fecb7d
let
	choices = [q"f = sin(x + pi/3)",
	q"function f(x) = sin(x + pi/3)",
	q"f(x)  = sin(x + pi/3)",
	q"f: x -> sin(x + pi/3)",
	q"f x = sin(x + pi/3)"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 9de52a4c-53bf-11ec-27a1-938d1997dc5f
md"""###### Question
"""

# ╔═╡ 9de52a7e-53bf-11ec-0f4e-3d15660fd9fa
md"""Which of these commands will create a function for $f(x) = (1 + x^2)^{-1}$?
"""

# ╔═╡ 9de53564-53bf-11ec-39bb-3f9e4638147a
let
	choices = [q"f(x) = (1 + x^2)^(-1)",
	q"function f(x) = (1 + x^2)^(-1)",
	q"f(x) := (1 + x^2)^(-1)",
	q"f[x] =  (1 + x^2)^(-1)",
	q"def f(x): (1 + x^2)^(-1)"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 9de5358c-53bf-11ec-0c96-39b1935f7b72
md"""###### Question
"""

# ╔═╡ 9de535aa-53bf-11ec-024c-ffd492cef200
md"""Will the following `Julia` commands create a function for
"""

# ╔═╡ 9de535dc-53bf-11ec-31ad-7f62a8fd90a4
md"""```math
f(x) = \begin{cases}
30 & x < 500\\
30 + 0.10 \cdot (x-500) & \text{otherwise.}
\end{cases}
```
"""

# ╔═╡ 9de53e6a-53bf-11ec-271e-ddc4b9b0e469
phone_plan(x) = x < 500 ? 30.0 : 30 + 0.10 * (x-500);

# ╔═╡ 9de55968-53bf-11ec-26a4-81e06a6b4d2c
let
	booleanq(true, labels=["Yes", "No"])
end

# ╔═╡ 9de559b8-53bf-11ec-1c7a-a5665a1ca298
md"""###### Question
"""

# ╔═╡ 9de559ea-53bf-11ec-2ea9-8901fe29b337
md"""The expression `max(0, x)` will be `0` if `x` is negative, but otherwise will take the value of `x`. Is this the same?
"""

# ╔═╡ 9de55fe4-53bf-11ec-2fc5-7971e77bfb43
a_max(x) = x < 0 ? x : 0.0;

# ╔═╡ 9de57aa4-53bf-11ec-3d89-71652d4da76d
let
	yesnoq(false)
end

# ╔═╡ 9de57ace-53bf-11ec-2b2e-95c45e6f997e
md"""###### Question
"""

# ╔═╡ 9de57b08-53bf-11ec-06ed-ebc5d425c42c
md"""In statistics, the normal distribution has two parameters $\mu$ and $\sigma$ appearing as:
"""

# ╔═╡ 9de57b1e-53bf-11ec-398f-03718b95817f
md"""```math
f(x; \mu, \sigma) = \frac{1}{\sqrt{2\pi\sigma}} e^{-\frac{1}{2}\frac{(x-\mu)^2}{\sigma}}.
```
"""

# ╔═╡ 9de57b3c-53bf-11ec-1212-fb1f3d89600f
md"""Does this function implement this with the default values of $\mu=0$ and $\sigma=1$?
"""

# ╔═╡ 9de58834-53bf-11ec-057a-0980eeae59be
a_normal(x; mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)

# ╔═╡ 9de58cec-53bf-11ec-1d27-d59e0ebd7270
let
	booleanq(true, labels=["Yes", "No"])
end

# ╔═╡ 9de58d16-53bf-11ec-319f-6f694c39c3de
md"""What value of $\mu$ is used if the function is called as `f(x, sigma=2.7)`?
"""

# ╔═╡ 9de58f00-53bf-11ec-3b19-b9f555a2bcc4
let
	numericq(0)
end

# ╔═╡ 9de58f26-53bf-11ec-05f8-c3300a055ad0
md"""What value of $\mu$ is used if the function is called as `f(x, mu=70)`?
"""

# ╔═╡ 9de5b7aa-53bf-11ec-1dc4-41553045f50b
let
	numericq(70)
end

# ╔═╡ 9de5b7f0-53bf-11ec-243c-2bec43a3a1a6
md"""What value of $\mu$ is used if the function is called as `f(x, mu=70, sigma=2.7)`?
"""

# ╔═╡ 9de5ba20-53bf-11ec-1b96-eda5d591b385
let
	numericq(70)
end

# ╔═╡ 9de5ba3e-53bf-11ec-14cc-d751b362e67b
md"""###### Question
"""

# ╔═╡ 9de5ba66-53bf-11ec-3f0e-93db1e0ad79e
md"""`Julia` has keyword arguments (as just illustrated) but also positional arguments. These are matched by how the function is called. For example,
"""

# ╔═╡ 9de5d3ac-53bf-11ec-369c-61dadf6ff88c
A(w, h) = w * h

# ╔═╡ 9de5d3fc-53bf-11ec-14d8-67a4fc0a3276
md"""when called as `A(10, 5)` will use 10 for `w` and `5` for `h`, as the order of `w` and `h` matches that of `10` and `5` in the call.
"""

# ╔═╡ 9de5d438-53bf-11ec-2f69-f33adb36d6ba
md"""This is clear enough, but in fact positional arguments can have default values (then called [optional](http://julia.readthedocs.org/en/latest/manual/functions/#optional-arguments)) arguments). For example,
"""

# ╔═╡ 9de5ef18-53bf-11ec-1a77-f332638e0035
B(w, h=5) = w * h

# ╔═╡ 9de5ef54-53bf-11ec-290d-636e0621a25c
md"""Actually creates two functions: `B(w,h)` for when the call is, say, `B(10,5)` and `B(w)` when the call is `B(10)`.
"""

# ╔═╡ 9de5ef68-53bf-11ec-1902-65f7a909a12b
md"""Suppose a function `C` is defined by
"""

# ╔═╡ 9de64440-53bf-11ec-2f8b-6b16bf62df3f
C(x, mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)

# ╔═╡ 9de6449a-53bf-11ec-3de2-a9cbe5ade42b
md"""This is *nearly* identical to the last question, save for a comma instead of a semicolon after the `x`.
"""

# ╔═╡ 9de644b8-53bf-11ec-32d5-8b964e964bc6
md"""What value of `mu` is used by the call `C(1, 70, 2.7)`?
"""

# ╔═╡ 9de64698-53bf-11ec-1db5-99eb45cfdd23
let
	numericq(70)
end

# ╔═╡ 9de646c0-53bf-11ec-37b7-e3feb81f6aa8
md"""What value of `mu` is used by the call `C(1, 70)`?
"""

# ╔═╡ 9de6488c-53bf-11ec-28c8-f7b4a08088bc
let
	numericq(70)
end

# ╔═╡ 9de648b2-53bf-11ec-04d0-554a59f8264e
md"""What value of `mu` is used by the call `C(1)`?
"""

# ╔═╡ 9de64a58-53bf-11ec-1274-75443abc29e1
let
	numericq(0)
end

# ╔═╡ 9de64a76-53bf-11ec-10c5-7f12a2465b39
md"""Will the call `C(1, mu=70)` use a value of `70` for `mu`?
"""

# ╔═╡ 9de65496-53bf-11ec-30a0-19c49002a495
let
	choices = ["Yes, this will work just as it does for keyword arguments",
	"No, there will be an error that the function does not accept keyword arguments"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 9de654b2-53bf-11ec-0a71-b16d8631c0b6
md"""###### Question
"""

# ╔═╡ 9de654d0-53bf-11ec-3c09-091e2cd5bfe1
md"""This function mirrors that of the built-in `clamp` function:
"""

# ╔═╡ 9de65a3e-53bf-11ec-3da1-5f9442054e6d
klamp(x, a, b) = x < a ? a : (x > b ? b : x)

# ╔═╡ 9de65a5c-53bf-11ec-1f1e-b9cedeac6689
md"""Can you tell what it does?
"""

# ╔═╡ 9de69622-53bf-11ec-1d7e-ef200d6a93f4
let
	choices = [
	"If `x` is in `[a,b]` it returns `x`, otherwise it returns `a` when `x` is less than `a` and `b` when  `x` is greater than `b`.",
	"If `x` is in `[a,b]` it returns `x`, otherwise it returns `NaN`",
	"`x` is the larger of the minimum of `x` and `a` and the value of `b`, aka `max(min(x,a),b)`"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 9de69648-53bf-11ec-0824-75e1e936cb03
md"""###### Question
"""

# ╔═╡ 9de69682-53bf-11ec-15aa-8312e80006c1
md"""`Julia` has syntax for the composition of  functions $f$ and $g$ using the Unicode operator `∘` entered as `\circ[tab]`.
"""

# ╔═╡ 9de696a2-53bf-11ec-3c07-97e9119e73b5
md"""The notation to call a composition follows the math notation, where parentheses are necessary to separate the act of composition from the act of calling the function:
"""

# ╔═╡ 9de696b4-53bf-11ec-3bd1-8d71dcb3b29c
md"""```math
(f \circ g)(x)
```
"""

# ╔═╡ 9de696ca-53bf-11ec-2142-af78e38a7747
md"""For example
"""

# ╔═╡ 9de6b15a-53bf-11ec-15b0-89cb0dd2f251
(sin ∘ cos)(pi/4)

# ╔═╡ 9de6b18c-53bf-11ec-3288-d18c6cc1c2f7
md"""What happens if you forget the extra parentheses and were to call `sin ∘ cos(pi/4)`?
"""

# ╔═╡ 9de6dae2-53bf-11ec-3830-81f54072f77b
let
	choices = [
	L"You still get $0.649...$",
	"You get a `MethodError`, as `cos(pi/4)` is evaluated as a number and `∘` is not defined for functions and numbers",
	"You get a `generic` function, but this won't be callable. If tried, it will give an method error."
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 9de6db08-53bf-11ec-1892-83c2eb1031e6
md"""###### Question
"""

# ╔═╡ 9de6db4e-53bf-11ec-3fdc-75cf64043149
md"""The [pipe](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.|>) notation `ex |> f` takes the output of `ex` and uses it as the input to the function `f`. That is composition. What is the value of this expression `1 |> sin |> cos`?
"""

# ╔═╡ 9de71032-53bf-11ec-3d6d-e1a423e733e1
let
	choices = [
	"It is `0.6663667453928805`, the same as `cos(sin(1))`",
	"It is `0.5143952585235492`, the same as `sin(cos(1))`",
	"It gives an error"]
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 9de71064-53bf-11ec-1647-b99d9e54fcc8
md"""###### Question
"""

# ╔═╡ 9de710c8-53bf-11ec-1540-5d792337a35a
md"""`Julia` has implemented this *limited* set of algebraic operations on functions: `∘` for *composition* and `!` for *negation*. (Read `!` as "not.") The latter is useful for "predicate" functions (ones that return either `true` or `false`. What is output by this command?
"""

# ╔═╡ 9de7110e-53bf-11ec-1277-c7a1cbe0e674
md"""```
fn = !iseven
fn(3)
```"""

# ╔═╡ 9de71780-53bf-11ec-3b5c-ff826cd9b0b4
let
	choices = ["`true`","`false`"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 9de717a8-53bf-11ec-0c5f-5d09be39bee5
md"""###### Question
"""

# ╔═╡ 9de717f8-53bf-11ec-3820-afe42dea8322
md"""Generic functions in `Julia` allow many algorithms to work without change for different number types. For example, [3000](https://pdfs.semanticscholar.org/1ef4/ee58a159dc7e437e190ec2839fb9a654596c.pdf) years ago, floating point numbers wouldn't have been used to carry out the secant method computations, rather rational numbers would have been. We can see the results of using rational numbers with no change to our key function, just by starting with rational numbers for `a` and `b`:
"""

# ╔═╡ 9de720e0-53bf-11ec-2a63-d78c9649d382
let
	secant_intersection(f, a, b) = b - f(b) * (b - a) / (f(b) - f(a))  # rewritten
	f(x) = x^2 - 2
	a, b = 1//1, 2//1
	c = secant_intersection(f, a, b)
end

# ╔═╡ 9de72112-53bf-11ec-0af3-f9821276615f
md"""Now `c` is `4//3` and not `1.333...`. This works as the key operations used: division, squaring, subtraction all have different implementations for rational numbers that preserve this type.
"""

# ╔═╡ 9de72144-53bf-11ec-3397-a57fc33b7381
md"""Repeat the secant method two more times to find a better approximation for $\sqrt{2}$. What is the value of `c` found?
"""

# ╔═╡ 9de73c1a-53bf-11ec-0443-43b22412f2ae
let
	choices = [q"4//3", q"7//5", q"58//41", q"816//577"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 9de73c56-53bf-11ec-06a5-3f450a342508
md"""How small is the value of $f(c)$ for this value?
"""

# ╔═╡ 9de741f6-53bf-11ec-292a-194c5d3a183f
let
	val = f(58/41)
	numericq(val)
end

# ╔═╡ 9de7421e-53bf-11ec-3bce-e1c5e51416c4
md"""How close is this answer to the true value of $\sqrt{2}$?
"""

# ╔═╡ 9de76136-53bf-11ec-1be1-f7da2ab9e406
let
	choices = [L"about $8$ parts in $100$", L"about $1$ parts in $100$", L"about $4$ parts in $10,000$", L"about $2$ parts in $1,000,000$"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 9de76168-53bf-11ec-353e-5fd2ac569c4f
md"""(Finding a good approximation to $\sqrt{2}$ would be helpful to builders, for example, as it could be used to verify the trueness of a square room, say.)
"""

# ╔═╡ 9de7617c-53bf-11ec-2bd6-c5f7750d3ed1
md"""###### Question
"""

# ╔═╡ 9de761d6-53bf-11ec-2acc-470d5140f0e8
md"""`Julia` does not have surface syntax for the *difference* of functions. This is a common thing to want when solving equations. The tools available solve $f(x)=0$, but problems may present as solving for $h(x) = g(x)$ or even $h(x) = c$, for some constant. Which of these solutions is **not** helpful if $h$ and $g$ are already defined?
"""

# ╔═╡ 9de76c58-53bf-11ec-097d-2bacad499c72
let
	choices = ["Just use `f = h - g`",
	"Define `f(x) = h(x) - g(x)`",
	"Use `x -> h(x) - g(x)` when the difference is needed"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 9de76c76-53bf-11ec-1170-f57d4ea6175e
md"""###### Question
"""

# ╔═╡ 9de76c8a-53bf-11ec-38cd-2dc8d84efbab
md"""Identifying the range of a function can be a difficult task. We see in this question that in some cases, a package can be of assistance.
"""

# ╔═╡ 9de76c9c-53bf-11ec-0dee-dfc7a3caffed
md"""A mathematical interval is a set of values of the form
"""

# ╔═╡ 9de76df2-53bf-11ec-3cd8-c9a4954e949f
md"""  * an open interval: $a < x < b$, or $(a,b)$;
  * a closed interval: $a \leq x \leq b$, or $[a,b]$;
  * or a half-open interval: $a < x \leq b$ or $a \leq x < b$, repectively $(a,b]$ or $[a,b)$.
"""

# ╔═╡ 9de76e04-53bf-11ec-2828-01a28f97e55f
md"""They all contain all real numbers between the endpoints, the distinction is whether the endpoints are included or not.
"""

# ╔═╡ 9de76e56-53bf-11ec-00ec-d31ed133dfeb
md"""A domain is some set, but typically that set is an interval such as *all real numbers* ($(-\infty,\infty)$), *all non-negative numbers* ($[0,\infty)$), or, say, *all positive numbers* ($(0,\infty)$).
"""

# ╔═╡ 9de76e74-53bf-11ec-1b70-1b93f4464ced
md"""The `IntervalArithmetic` package provides an easy  means to define closed intervals using the symbol `..`, but this is also used by the already loaded `CalculusWithJulia` package in different manner, so we use the fully qualified named constructor in the following to construct intervals:
"""

# ╔═╡ 9de77074-53bf-11ec-1839-0d82c191ddf4
import IntervalArithmetic

# ╔═╡ 9de7a2c2-53bf-11ec-2ad0-098dff3674c0
I1 = IntervalArithmetic.Interval(-Inf, Inf)

# ╔═╡ 9de7be44-53bf-11ec-1809-0f9e35e12185
I2 = IntervalArithmetic.Interval(0, Inf)

# ╔═╡ 9de7bf46-53bf-11ec-030d-9fe4c6783b37
md"""The main feature of the package is not to construct intervals, but rather to *rigorously* bound with an interval the output of the image of a closed interval under a function. That is, for a function $f$ and *closed* interval $[a,b]$, a bound for the set $\{f(x) \text{ for } x \text{ in } [a,b]\}$. When `[a,b]` is the domain of $f$, then this is a bound for the range of $f$.
"""

# ╔═╡ 9de7bf78-53bf-11ec-1841-cddfd07f07bf
md"""For example the function $f(x) = x^2 + 2$ had a domain of all real $x$, the range can be found with:
"""

# ╔═╡ 9de7c78e-53bf-11ec-19ee-edaa51065df8
begin
	ab = IntervalArithmetic.Interval(-Inf, Inf)
	u(x) = x^2 + 2
	u(ab)
end

# ╔═╡ 9de7c7c0-53bf-11ec-3889-b51a3ae22e4f
md"""For this problem, the actual range can easily be identified. Does the bound computed match exactly?
"""

# ╔═╡ 9de7cc0c-53bf-11ec-3d5e-1fc71b328823
let
	yesnoq("yes")
end

# ╔═╡ 9de7cc7a-53bf-11ec-0bba-c7931a42e933
md"""Does `sin(0..pi)` **exactly** match the interval of $[-1,1]$?
"""

# ╔═╡ 9de7cf0e-53bf-11ec-118d-bf305f586422
let
	yesnoq("no")
end

# ╔═╡ 9de7cf2c-53bf-11ec-1a3b-e9c18ee2964c
md"""Guess why or why not?
"""

# ╔═╡ 9de82d3c-53bf-11ec-0f74-57f800c21da3
let
	choices = ["Well it does, because ``[-1,1]`` is the range",
	           """It does not. The bound found is a provably known bound. The small deviation is due to the possible errors in evalution of the `sin` function near the floating point approximation of `pi`,
	"""]
	radioq(choices, 2)
end

# ╔═╡ 9de82d82-53bf-11ec-1c52-6faae83064c5
md"""Now consider the evaluation
"""

# ╔═╡ 9de831f6-53bf-11ec-392a-514aceb4ccf0
let
	f(x) = x^x
	I = IntervalArithmetic.Interval(0, Inf)
	f(I)
end

# ╔═╡ 9de8323a-53bf-11ec-1501-a5138641c577
md"""Make a graph of `f`. Does the interval found above provide a nearly exact estimate of the true range (as the previous two questions have)?
"""

# ╔═╡ 9de83446-53bf-11ec-3e3e-33505ec79238
let
	yesnoq("no")
end

# ╔═╡ 9de83458-53bf-11ec-18ed-93118fe36019
md"""Any thoughts on why?
"""

# ╔═╡ 9de84b0a-53bf-11ec-328f-e35a23004630
let
	choices = ["""
	The guarantee of `IntervalArithmetic` is a *bound* on the interval, not the *exact* interval. In the case where the variable `x` appears more than once, it is treated formulaically as an *independent* quantity (meaning it has it full set of values considered in each instance) which is not the actual case mathemitcally. This is the "dependence problem" in interval arithmetic.""",
	           """
	The interval is a nearly exact estimate, as guaranteed by `IntervalArithmetic`.
	"""]
	radioq(choices, 1)
end

# ╔═╡ 9de84b32-53bf-11ec-3ab9-db01cac2f3ec
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/ranges.html">◅ previous</a>  <a href="../precalc/plotting.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 9de84b46-53bf-11ec-331d-b9bed70fa3ec
PlutoUI.TableOfContents()

# ╔═╡ Cell order:
# ╟─9de84b14-53bf-11ec-2231-c7237996641b
# ╟─9dd7ce6a-53bf-11ec-3756-e3019b5b6a23
# ╟─9dd7cea6-53bf-11ec-1fe2-1f4b860dcf8e
# ╠═9dd7e8aa-53bf-11ec-0b13-85afa9ce3650
# ╟─9dd7ecd8-53bf-11ec-2c1c-d53aa339dfa5
# ╟─9dd7ed14-53bf-11ec-25b4-b5adb971081f
# ╟─9dd7ed8e-53bf-11ec-0d91-c97564f8552e
# ╟─9dd80b64-53bf-11ec-03d1-e3fe37e05ce2
# ╟─9dd80bb6-53bf-11ec-0a10-1398b37e747b
# ╟─9dd80c2c-53bf-11ec-1ee6-4fdde3bf6782
# ╟─9dd80c36-53bf-11ec-3d70-075eb989331a
# ╟─9dd80c68-53bf-11ec-03a6-b9152dbf7144
# ╟─9dd80cae-53bf-11ec-32cd-93fbf1602004
# ╟─9dd80cfe-53bf-11ec-2f00-89045bbe79db
# ╟─9dd88682-53bf-11ec-05a3-09d7ebf973de
# ╟─9dd88726-53bf-11ec-2bc3-f588e4cbf0a4
# ╟─9dd88760-53bf-11ec-39e3-fbf0bb93ca32
# ╟─9dd887a6-53bf-11ec-282d-73e8f764aeae
# ╠═9dd88ce2-53bf-11ec-0b60-37f224aef487
# ╟─9dd88d3c-53bf-11ec-1aef-c3f4ac11cce3
# ╟─9dd88d50-53bf-11ec-1d5e-412157d6f859
# ╠═9dd8a2e2-53bf-11ec-3a08-45f93bbe138e
# ╟─9dd8a310-53bf-11ec-250f-c530bc5def98
# ╟─9dd8efae-53bf-11ec-1b4d-d7efcb9774e2
# ╟─9dd8f01a-53bf-11ec-18ba-e52476d21a6a
# ╟─9dd8f092-53bf-11ec-347f-73153153a4ec
# ╠═9dd90dd6-53bf-11ec-191e-4dd61fcdca5b
# ╟─9dd90e4c-53bf-11ec-0319-5bc4ada150d1
# ╟─9dd90e60-53bf-11ec-0f39-65948bb34319
# ╟─9dd90e74-53bf-11ec-05a6-7fcaae94962a
# ╟─9dd90e9c-53bf-11ec-1d90-792fd07ef547
# ╟─9dd90eba-53bf-11ec-3ca4-47f5186df5ce
# ╟─9dd90ec4-53bf-11ec-0337-aba8d7cca4d5
# ╟─9dd90eec-53bf-11ec-3e1f-419ef79833d5
# ╠═9dd929c0-53bf-11ec-24e5-932afee3a4cf
# ╟─9dd929fe-53bf-11ec-025f-fdf202f6922f
# ╠═9dd94934-53bf-11ec-032c-054ca494aaab
# ╟─9dd94970-53bf-11ec-38e1-e1ee8e678a9b
# ╟─9dd949ac-53bf-11ec-1f4b-1f17085c2d8f
# ╟─9dd949c2-53bf-11ec-0b1c-c9a5d9bee451
# ╟─9dd949d4-53bf-11ec-0c99-45b52310d3f8
# ╟─9dd949f4-53bf-11ec-0da0-a5e39930bf1a
# ╟─9dd94a06-53bf-11ec-341b-7f2dc17504a1
# ╟─9dd94a4c-53bf-11ec-0273-5be572e627c0
# ╟─9dd94a6a-53bf-11ec-134d-6da6b30d4041
# ╟─9dd94ad8-53bf-11ec-1be9-072c2b10e6c8
# ╟─9dd94b00-53bf-11ec-19ab-6905a9d47cc5
# ╟─9dd94b1e-53bf-11ec-24b6-d31b5a03e00e
# ╟─9dd94b46-53bf-11ec-3836-679b90c3e6f3
# ╟─9dd94ba0-53bf-11ec-0e21-cd2d745b9af3
# ╟─9dd94bb4-53bf-11ec-3ceb-6fe8b8adf7c3
# ╠═9dd965cc-53bf-11ec-305e-3fd98203e128
# ╟─9dd96610-53bf-11ec-1f73-4184f0b8a25b
# ╟─9dd96630-53bf-11ec-1815-f12f05aa9ec8
# ╠═9dd96b6c-53bf-11ec-1265-25e6202769d9
# ╟─9dd96b9e-53bf-11ec-39a9-a15990f79358
# ╟─9dd96bb0-53bf-11ec-3cb7-6337cacf0c4f
# ╠═9dd9a33e-53bf-11ec-3c00-b9e818162370
# ╟─9dd9f5d0-53bf-11ec-1fdd-27d2ab5776c6
# ╟─9dd9f62c-53bf-11ec-184c-abc85a18e76d
# ╟─9dd9f672-53bf-11ec-04bb-e36f5164f173
# ╠═9dda572a-53bf-11ec-39c1-f19ebf3398f7
# ╟─9ddd0754-53bf-11ec-3e26-abbab1f3147f
# ╟─9ddd07cc-53bf-11ec-13ea-afed43fc6568
# ╠═9ddd1280-53bf-11ec-3098-a9cd87eab914
# ╟─9ddd12ba-53bf-11ec-1a28-ebc4fb7f742c
# ╟─9ddd12f8-53bf-11ec-272d-e578e49b0d4b
# ╟─9ddd1316-53bf-11ec-2cd3-eb2d65efe32f
# ╟─9ddd133e-53bf-11ec-0b53-37405e0cc841
# ╟─9ddd135c-53bf-11ec-0686-c77a9ad4398e
# ╟─9ddd1390-53bf-11ec-2555-e7bbd6d5bc4d
# ╠═9ddd3198-53bf-11ec-0f02-710aa7542634
# ╟─9ddd31de-53bf-11ec-3f9f-b17d790c6f09
# ╟─9ddd6be0-53bf-11ec-3cf8-8d934cb36766
# ╟─9ddd6c3a-53bf-11ec-0fdb-9dd659f97cfc
# ╟─9ddd6c94-53bf-11ec-17ee-2da4b23af589
# ╟─9ddd6cc6-53bf-11ec-3e63-05bd5202603b
# ╟─9ddd6d16-53bf-11ec-2096-65d55eb42037
# ╠═9dddbdca-53bf-11ec-11e9-fb09ff6846aa
# ╠═9dddc1b2-53bf-11ec-3016-b705ca0d6db7
# ╟─9dddc202-53bf-11ec-05a6-a5caaecaf37b
# ╟─9dddc266-53bf-11ec-29f6-f9fd320b3e90
# ╟─9dddc27a-53bf-11ec-0eb8-c972d442a999
# ╟─9dddc2ca-53bf-11ec-0c87-538e0ad7e061
# ╠═9dddf510-53bf-11ec-38f0-4942fe040876
# ╟─9dddf59c-53bf-11ec-04f2-c914549efc27
# ╠═9dde130e-53bf-11ec-0ac1-5d7f77cfb328
# ╟─9dde134c-53bf-11ec-3a04-69343ecacc91
# ╟─9dde19b6-53bf-11ec-06e8-514a5c598ba6
# ╟─9dde19f0-53bf-11ec-3dc2-ed3228e50c15
# ╠═9dde1ba8-53bf-11ec-36d2-111bbbb62fd7
# ╟─9ddf4d34-53bf-11ec-3f8c-25057527ae03
# ╠═9ddf53c4-53bf-11ec-271d-ad27ea6bd869
# ╟─9ddf540a-53bf-11ec-2ce6-f167ca168a31
# ╠═9ddf94ce-53bf-11ec-351e-3bd9771f3819
# ╟─9ddf9528-53bf-11ec-39d0-971e7ca2bbcd
# ╟─9ddf9546-53bf-11ec-14fe-81e5c8660e1b
# ╟─9ddf9bc2-53bf-11ec-3e89-09b8172f64c9
# ╟─9ddf9be0-53bf-11ec-0864-490ca9cbd1b8
# ╟─9ddf9c08-53bf-11ec-23c0-f90f0d5441bf
# ╟─9ddf9c1c-53bf-11ec-3ae3-6727293167f7
# ╟─9ddf9c3a-53bf-11ec-00be-efd9891ad759
# ╟─9ddf9c82-53bf-11ec-2beb-6166c8136e18
# ╟─9ddf9ca8-53bf-11ec-3908-4dd454fb1fbe
# ╠═9ddfa20c-53bf-11ec-1294-a95c9ed16c16
# ╟─9ddfa23e-53bf-11ec-005d-eb6cba28faf1
# ╠═9ddfb616-53bf-11ec-1b1a-c1494f8143ad
# ╟─9ddfb672-53bf-11ec-2876-3b041f5f2358
# ╟─9ddfb6ac-53bf-11ec-3755-719adf3abc73
# ╟─9ddfb6b6-53bf-11ec-3a12-513ec60ef726
# ╠═9ddfbc72-53bf-11ec-1ce7-0b576bf77086
# ╟─9ddfbca4-53bf-11ec-248c-d92198a24d2b
# ╟─9ddfbcf6-53bf-11ec-25d0-1fed6aa844f3
# ╟─9ddfbd32-53bf-11ec-2876-e33849f14378
# ╠═9ddfc458-53bf-11ec-03cb-27fdb6d83762
# ╟─9ddfc494-53bf-11ec-2b49-87946bc7f751
# ╟─9ddfc4a8-53bf-11ec-1ff3-9504171a8483
# ╠═9ddfc674-53bf-11ec-36c3-39c583e76d9f
# ╟─9ddfc6b0-53bf-11ec-2ead-5794b62d5ee3
# ╠═9ddfcb6a-53bf-11ec-1a96-f76d91734607
# ╟─9ddfcba6-53bf-11ec-2cae-b3eaa58a2c84
# ╟─9ddfcbce-53bf-11ec-299f-49b52aefb46f
# ╟─9ddfcbe2-53bf-11ec-2728-abccb4566f46
# ╠═9de0111c-53bf-11ec-2951-8757620d13e1
# ╟─9de18fc2-53bf-11ec-0f13-47b9cebbdff1
# ╟─9de1903a-53bf-11ec-2e12-cb0bd732b888
# ╟─9de19074-53bf-11ec-0e2d-f7bcfb178116
# ╠═9de1bc90-53bf-11ec-2ac6-fb89d47724ed
# ╟─9de1bcfe-53bf-11ec-2710-55032d600bd4
# ╟─9de1bd3a-53bf-11ec-1f49-1b9d9999e902
# ╟─9de1bd58-53bf-11ec-03d6-d7fe38212403
# ╠═9de1db30-53bf-11ec-3531-2bd3d30e571c
# ╟─9de1db80-53bf-11ec-2240-a79b833d038f
# ╟─9de1db9e-53bf-11ec-1523-bf00fcedc1b9
# ╟─9de1dc02-53bf-11ec-27e6-75195785294c
# ╟─9de220ea-53bf-11ec-3a48-459ca2379dff
# ╟─9de3672a-53bf-11ec-3709-4b47b7421807
# ╠═9de36b62-53bf-11ec-1cd6-4f8e5d0df7e3
# ╟─9de36bd0-53bf-11ec-107f-63e61bdbb545
# ╟─9de36bf8-53bf-11ec-3008-13416c6b15ad
# ╟─9de36c1e-53bf-11ec-0b69-790742f50489
# ╟─9de36ce8-53bf-11ec-2269-4dff44d5ccfb
# ╟─9de36cf4-53bf-11ec-1476-03d5a08b8005
# ╟─9de36d06-53bf-11ec-272f-1b7b0e0b5fa6
# ╠═9de37076-53bf-11ec-2cce-c54f6e7e97de
# ╟─9de370bc-53bf-11ec-3dd7-ab52eb95f97d
# ╠═9de389da-53bf-11ec-279d-69311915f78d
# ╟─9de38a3e-53bf-11ec-264d-0ff00afe50e6
# ╠═9de3a096-53bf-11ec-1a1d-b155b32524db
# ╟─9de3a106-53bf-11ec-2b1e-a5d6df6f1a9c
# ╟─9de3a1b8-53bf-11ec-26f7-eb2d87e2fec2
# ╠═9de3a5d0-53bf-11ec-1ac0-87b77c3047b5
# ╟─9de3a602-53bf-11ec-1f08-cbf94aca0331
# ╟─9de3a622-53bf-11ec-2ede-fbe5b1f2140c
# ╟─9de3a636-53bf-11ec-1162-cf9c9913b3eb
# ╟─9de3a64a-53bf-11ec-01b9-5987797a0f5c
# ╟─9de3a674-53bf-11ec-17c6-2b9031a20fac
# ╟─9de3a6c2-53bf-11ec-1575-ddc053548f2a
# ╟─9de3a6e0-53bf-11ec-1f7b-0d410a41f85c
# ╠═9de3aeec-53bf-11ec-183c-739aeb6c04cf
# ╟─9de3af32-53bf-11ec-0937-2ba966b64ad7
# ╠═9de3b5d6-53bf-11ec-06e3-7ff3de39e202
# ╟─9de3b626-53bf-11ec-2b0b-b10c7c7c26ee
# ╟─9de3b63a-53bf-11ec-0fb6-e3915c8e2e91
# ╠═9de3bb5a-53bf-11ec-268e-83d7295dd282
# ╟─9de3bb80-53bf-11ec-2f02-9923556a54f9
# ╟─9de3f690-53bf-11ec-14b9-e75fc605ece2
# ╟─9de3f6c2-53bf-11ec-15fa-23b63ab94485
# ╠═9de3fcb2-53bf-11ec-3a77-1b932d4bfb13
# ╟─9de3fd70-53bf-11ec-03d3-216a693d6efa
# ╟─9de4926c-53bf-11ec-1dd7-991031e25c40
# ╟─9de492b2-53bf-11ec-1a07-f38c72aceb6d
# ╟─9de492f8-53bf-11ec-2b11-3dd53ddd72d1
# ╟─9de4930a-53bf-11ec-0f11-07b69144a5a9
# ╟─9de4932a-53bf-11ec-30d6-01eca2d12485
# ╟─9de49352-53bf-11ec-3850-6191f3ef6610
# ╠═9de4aca2-53bf-11ec-11c2-1fd6a3bac0bc
# ╟─9de4acf2-53bf-11ec-13b0-49004bf677c9
# ╟─9de4ad1a-53bf-11ec-1d73-59cd72a27c8c
# ╠═9de4b288-53bf-11ec-3ef1-91b724895c14
# ╟─9de4b2a6-53bf-11ec-1a9c-3537859d981d
# ╟─9de4b2e2-53bf-11ec-15f1-ad5b8b4855f1
# ╟─9de4b314-53bf-11ec-3711-7527bab97fd6
# ╟─9de4b332-53bf-11ec-2b56-5bc633d0b519
# ╟─9de4b350-53bf-11ec-201a-45a06cb13628
# ╟─9de4b364-53bf-11ec-07f7-69104452f425
# ╟─9de4b378-53bf-11ec-1eff-7b422e355aca
# ╟─9de4b3a2-53bf-11ec-3daa-67fa398b688e
# ╟─9de4b3be-53bf-11ec-241e-33d4cfbf670d
# ╟─9de4b3dc-53bf-11ec-2408-914aaf59047d
# ╟─9de4b3f0-53bf-11ec-3142-f7aedcbf671d
# ╟─9de4b40e-53bf-11ec-3fa1-0bcf8ec3b5f2
# ╟─9de4c2b6-53bf-11ec-3f06-2b1e074cf5b7
# ╟─9de4c2d2-53bf-11ec-3ea6-d99276851d5e
# ╟─9de4c2f0-53bf-11ec-03b9-c516b8ad04bd
# ╟─9de4f856-53bf-11ec-2822-b56fca1a30bf
# ╟─9de4f89c-53bf-11ec-197c-331f012b66e5
# ╟─9de4f8d8-53bf-11ec-03c7-e57e238dc499
# ╟─9de51d0e-53bf-11ec-1a4d-d3bef407a088
# ╟─9de51d7c-53bf-11ec-29ae-c5e73b1b261f
# ╟─9de51db8-53bf-11ec-2ec4-0d1c13471bb5
# ╟─9de52a1a-53bf-11ec-2bea-63b702fecb7d
# ╟─9de52a4c-53bf-11ec-27a1-938d1997dc5f
# ╟─9de52a7e-53bf-11ec-0f4e-3d15660fd9fa
# ╟─9de53564-53bf-11ec-39bb-3f9e4638147a
# ╟─9de5358c-53bf-11ec-0c96-39b1935f7b72
# ╟─9de535aa-53bf-11ec-024c-ffd492cef200
# ╟─9de535dc-53bf-11ec-31ad-7f62a8fd90a4
# ╠═9de53e6a-53bf-11ec-271e-ddc4b9b0e469
# ╟─9de55968-53bf-11ec-26a4-81e06a6b4d2c
# ╟─9de559b8-53bf-11ec-1c7a-a5665a1ca298
# ╟─9de559ea-53bf-11ec-2ea9-8901fe29b337
# ╠═9de55fe4-53bf-11ec-2fc5-7971e77bfb43
# ╟─9de57aa4-53bf-11ec-3d89-71652d4da76d
# ╟─9de57ace-53bf-11ec-2b2e-95c45e6f997e
# ╟─9de57b08-53bf-11ec-06ed-ebc5d425c42c
# ╟─9de57b1e-53bf-11ec-398f-03718b95817f
# ╟─9de57b3c-53bf-11ec-1212-fb1f3d89600f
# ╠═9de58834-53bf-11ec-057a-0980eeae59be
# ╟─9de58cec-53bf-11ec-1d27-d59e0ebd7270
# ╟─9de58d16-53bf-11ec-319f-6f694c39c3de
# ╟─9de58f00-53bf-11ec-3b19-b9f555a2bcc4
# ╟─9de58f26-53bf-11ec-05f8-c3300a055ad0
# ╟─9de5b7aa-53bf-11ec-1dc4-41553045f50b
# ╟─9de5b7f0-53bf-11ec-243c-2bec43a3a1a6
# ╟─9de5ba20-53bf-11ec-1b96-eda5d591b385
# ╟─9de5ba3e-53bf-11ec-14cc-d751b362e67b
# ╟─9de5ba66-53bf-11ec-3f0e-93db1e0ad79e
# ╠═9de5d3ac-53bf-11ec-369c-61dadf6ff88c
# ╟─9de5d3fc-53bf-11ec-14d8-67a4fc0a3276
# ╟─9de5d438-53bf-11ec-2f69-f33adb36d6ba
# ╠═9de5ef18-53bf-11ec-1a77-f332638e0035
# ╟─9de5ef54-53bf-11ec-290d-636e0621a25c
# ╟─9de5ef68-53bf-11ec-1902-65f7a909a12b
# ╠═9de64440-53bf-11ec-2f8b-6b16bf62df3f
# ╟─9de6449a-53bf-11ec-3de2-a9cbe5ade42b
# ╟─9de644b8-53bf-11ec-32d5-8b964e964bc6
# ╟─9de64698-53bf-11ec-1db5-99eb45cfdd23
# ╟─9de646c0-53bf-11ec-37b7-e3feb81f6aa8
# ╟─9de6488c-53bf-11ec-28c8-f7b4a08088bc
# ╟─9de648b2-53bf-11ec-04d0-554a59f8264e
# ╟─9de64a58-53bf-11ec-1274-75443abc29e1
# ╟─9de64a76-53bf-11ec-10c5-7f12a2465b39
# ╟─9de65496-53bf-11ec-30a0-19c49002a495
# ╟─9de654b2-53bf-11ec-0a71-b16d8631c0b6
# ╟─9de654d0-53bf-11ec-3c09-091e2cd5bfe1
# ╠═9de65a3e-53bf-11ec-3da1-5f9442054e6d
# ╟─9de65a5c-53bf-11ec-1f1e-b9cedeac6689
# ╟─9de69622-53bf-11ec-1d7e-ef200d6a93f4
# ╟─9de69648-53bf-11ec-0824-75e1e936cb03
# ╟─9de69682-53bf-11ec-15aa-8312e80006c1
# ╟─9de696a2-53bf-11ec-3c07-97e9119e73b5
# ╟─9de696b4-53bf-11ec-3bd1-8d71dcb3b29c
# ╟─9de696ca-53bf-11ec-2142-af78e38a7747
# ╠═9de6b15a-53bf-11ec-15b0-89cb0dd2f251
# ╟─9de6b18c-53bf-11ec-3288-d18c6cc1c2f7
# ╟─9de6dae2-53bf-11ec-3830-81f54072f77b
# ╟─9de6db08-53bf-11ec-1892-83c2eb1031e6
# ╟─9de6db4e-53bf-11ec-3fdc-75cf64043149
# ╟─9de71032-53bf-11ec-3d6d-e1a423e733e1
# ╟─9de71064-53bf-11ec-1647-b99d9e54fcc8
# ╟─9de710c8-53bf-11ec-1540-5d792337a35a
# ╟─9de7110e-53bf-11ec-1277-c7a1cbe0e674
# ╟─9de71780-53bf-11ec-3b5c-ff826cd9b0b4
# ╟─9de717a8-53bf-11ec-0c5f-5d09be39bee5
# ╟─9de717f8-53bf-11ec-3820-afe42dea8322
# ╠═9de720e0-53bf-11ec-2a63-d78c9649d382
# ╟─9de72112-53bf-11ec-0af3-f9821276615f
# ╟─9de72144-53bf-11ec-3397-a57fc33b7381
# ╟─9de73c1a-53bf-11ec-0443-43b22412f2ae
# ╟─9de73c56-53bf-11ec-06a5-3f450a342508
# ╟─9de741f6-53bf-11ec-292a-194c5d3a183f
# ╟─9de7421e-53bf-11ec-3bce-e1c5e51416c4
# ╟─9de76136-53bf-11ec-1be1-f7da2ab9e406
# ╟─9de76168-53bf-11ec-353e-5fd2ac569c4f
# ╟─9de7617c-53bf-11ec-2bd6-c5f7750d3ed1
# ╟─9de761d6-53bf-11ec-2acc-470d5140f0e8
# ╟─9de76c58-53bf-11ec-097d-2bacad499c72
# ╟─9de76c76-53bf-11ec-1170-f57d4ea6175e
# ╟─9de76c8a-53bf-11ec-38cd-2dc8d84efbab
# ╟─9de76c9c-53bf-11ec-0dee-dfc7a3caffed
# ╟─9de76df2-53bf-11ec-3cd8-c9a4954e949f
# ╟─9de76e04-53bf-11ec-2828-01a28f97e55f
# ╟─9de76e56-53bf-11ec-00ec-d31ed133dfeb
# ╟─9de76e74-53bf-11ec-1b70-1b93f4464ced
# ╠═9de77074-53bf-11ec-1839-0d82c191ddf4
# ╠═9de7a2c2-53bf-11ec-2ad0-098dff3674c0
# ╠═9de7be44-53bf-11ec-1809-0f9e35e12185
# ╟─9de7bf46-53bf-11ec-030d-9fe4c6783b37
# ╟─9de7bf78-53bf-11ec-1841-cddfd07f07bf
# ╠═9de7c78e-53bf-11ec-19ee-edaa51065df8
# ╟─9de7c7c0-53bf-11ec-3889-b51a3ae22e4f
# ╟─9de7cc0c-53bf-11ec-3d5e-1fc71b328823
# ╟─9de7cc7a-53bf-11ec-0bba-c7931a42e933
# ╟─9de7cf0e-53bf-11ec-118d-bf305f586422
# ╟─9de7cf2c-53bf-11ec-1a3b-e9c18ee2964c
# ╟─9de82d3c-53bf-11ec-0f74-57f800c21da3
# ╟─9de82d82-53bf-11ec-1c52-6faae83064c5
# ╠═9de831f6-53bf-11ec-392a-514aceb4ccf0
# ╟─9de8323a-53bf-11ec-1501-a5138641c577
# ╟─9de83446-53bf-11ec-3e3e-33505ec79238
# ╟─9de83458-53bf-11ec-18ed-93118fe36019
# ╟─9de84b0a-53bf-11ec-328f-e35a23004630
# ╟─9de84b32-53bf-11ec-3ab9-db01cac2f3ec
# ╟─9de84b3c-53bf-11ec-0f9c-79bb41fc5eaa
# ╟─9de84b46-53bf-11ec-331d-b9bed70fa3ec
