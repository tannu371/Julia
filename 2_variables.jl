### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 4eef5342-53c2-11ec-0850-bbf94b730535
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :variables
	nothing
end

# ╔═╡ 4ef205d8-53c2-11ec-3dce-75c1dd99cbe2
using PlutoUI

# ╔═╡ 4ef205ba-53c2-11ec-3a66-0f16cdcc6174
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 4eeecada-53c2-11ec-3f91-152a23d6ee6a
md"""# Variables
"""

# ╔═╡ 4eeecbfc-53c2-11ec-1e01-9bc6f45fb35a
md"""## Assignment
"""

# ╔═╡ 4eef5446-53c2-11ec-043f-6fb185140bda
md"""![Screenshot of a calculator provided by the Google search engine.]( https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/precalc/figures/calculator.png )
"""

# ╔═╡ 4eefa630-53c2-11ec-14e7-c137a50fa5c0
begin
	imgfile = "figures/calculator.png"
	caption = "Screenshot of a calculator provided by the Google search engine."
	#ImageFile(imgfile, caption)
	nothing
end

# ╔═╡ 4eefa72a-53c2-11ec-38ea-69fbf35839a9
md"""The Google calculator has a button `Ans` to refer to the answer to the previous evaluation. This is a form of memory. The last answer is stored in a specific place in memory for retrieval when `Ans` is used. In some calculators, more advanced memory features are possible. For some, it is possible to push values onto a stack of values for them to be referred to at a later time. This proves useful for complicated expressions, say, as the expression can be broken into smaller intermediate steps to be computed. These values can then be appropriately combined. This strategy is a good one, though the memory buttons can make its implementation a bit cumbersome.
"""

# ╔═╡ 4eefa76e-53c2-11ec-39de-4d31044f32cf
md"""With `Julia`, as with other programming languages, it is very easy to refer to past evaluations. This is done by *assignment* whereby a computed value stored in memory is associated with a name. The name can be used to look up the value later.
"""

# ╔═╡ 4eefa784-53c2-11ec-2820-6b03b988fed4
md"""Assignment in `Julia` is handled by the equals sign and takes the general form `variable_name = value`. For example, here we assign values to the variables `x` and `y`
"""

# ╔═╡ 4eefc9f8-53c2-11ec-2691-bfe5917b6d51
begin
	x = sqrt(2)
	y = 42
end

# ╔═╡ 4eefcaca-53c2-11ec-05c2-af88caa462d8
md"""In an assignment, the right hand side is returned, so it appears nothing has happened. However, the values are there, as can be checked by typing their name
"""

# ╔═╡ 4eefd092-53c2-11ec-014f-e3ee8c6b85c0
x

# ╔═╡ 4eefd0ce-53c2-11ec-1427-b388cc8ccb51
md"""Just typing a variable name (without a trailing semicolon) causes the assigned value to be displayed.
"""

# ╔═╡ 4eefd10a-53c2-11ec-05c9-67787b684b97
md"""Variable names can be reused, as here, where we redefine `x`:
"""

# ╔═╡ 4eefd498-53c2-11ec-109e-b5b8d14ecef6
let
	x = 2
end

# ╔═╡ 4ef01520-53c2-11ec-1d3e-79798ba34b4d
note("""
The `Pluto` interface for `Julia` is idiosyncratic, as variables are *reactive*. This interface allows changes to a variable `x` to propogate to all other cells referring to `x`. Consequently, the variable name can only be assigned *once* per notebook **unless** the name is in some other namespace, which can be arranged by including the assignment inside a function or a `let` block.
""")

# ╔═╡ 4ef01584-53c2-11ec-108c-09305235ec4d
md"""`Julia` is referred to as a "dynamic language" which means (in most cases) that a variable can be reassigned with a value of a different type, as we did with `x` where first it was assigned to a floating point value then to an integer value. (Though we meet some cases - generic functions -  where `Julia` balks at reassigning a variable if the type if different.)
"""

# ╔═╡ 4ef015a4-53c2-11ec-32f7-5f384120bf05
md"""More importantly than displaying a value, is the use of variables to build up more complicated expressions. For example, to compute
"""

# ╔═╡ 4ef01642-53c2-11ec-2a74-ff4c197d1c37
md"""```math
\frac{1 + 2 \cdot 3^4}{5 - 6/7}
```
"""

# ╔═╡ 4ef01656-53c2-11ec-3fa3-ad2ccdae8a2c
md"""we might break it into the grouped pieces implied by the mathematical notation:
"""

# ╔═╡ 4ef04af4-53c2-11ec-0106-f78141a10965
begin
	top = 1 + 2*3^4
	bottom = 5 - 6/7
	top/bottom
end

# ╔═╡ 4ef04ba8-53c2-11ec-1c8f-953e432475bf
md"""### Examples
"""

# ╔═╡ 4ef04bee-53c2-11ec-2467-e1935613244b
md"""##### Example
"""

# ╔═╡ 4ef04c7a-53c2-11ec-3520-31f96bf05bcd
md"""Imagine we have the following complicated expression related to the trajectory of a [projectile](http://www.researchgate.net/publication/230963032_On_the_trajectories_of_projectiles_depicted_in_early_ballistic_woodcuts) with wind resistance:
"""

# ╔═╡ 4ef04cd4-53c2-11ec-237f-fde8aec2eddc
md"""```math
	\left(\frac{g}{k v_0\cos(\theta)} + \tan(\theta) \right) t + \frac{g}{k^2}\ln\left(1 - \frac{k}{v_0\cos(\theta)} t \right)
```
"""

# ╔═╡ 4ef04d24-53c2-11ec-31d6-9de3253229cd
md"""Here $g$ is the gravitational constant $9.8$ and $v_0$, $\theta$ and $k$ parameters, which we take to be $200$, $45$ degrees, and $1/2$ respectively. With these values, the above expression can be computed when $s=100$:
"""

# ╔═╡ 4ef053bc-53c2-11ec-120e-d34b5dfbc653
begin
	g = 9.8
	v0 = 200
	theta = 45
	k = 1/2
	t = 100
	a = v0 * cosd(theta)
	(g/(k*a) + tand(theta))* t + (g/k^2) * log(1 - (k/a)*t)
end

# ╔═╡ 4ef05418-53c2-11ec-172a-316fae119f25
md"""By defining a new variable `a` to represent a value that is repeated a few times in the expression, the last command is greatly simplified. Doing so makes it much easier to check for accuracy against the expression to compute.
"""

# ╔═╡ 4ef0542c-53c2-11ec-2598-d10a419250e1
md"""##### Example
"""

# ╔═╡ 4ef0545e-53c2-11ec-09d2-31162bd75acf
md"""A common expression in mathematics is a polynomial expression, for example $-16s^2 + 32s - 12$. Translating this to `Julia` at $s =3$ we might have:
"""

# ╔═╡ 4ef05968-53c2-11ec-12ac-338fb7e75594
begin
	s = 3
	-16*s^2 + 32*s - 12
end

# ╔═╡ 4ef059a4-53c2-11ec-23d8-779f7b5a14c9
md"""This looks nearly identical to the mathematical expression, but we inserted `*` to indicate multiplication between the constant and the variable. In fact, this step is not needed as Julia allows numeric literals to have an implied multiplication:
"""

# ╔═╡ 4ef05ef4-53c2-11ec-2230-f1814f2d67f0
-16s^2 + 32s - 12

# ╔═╡ 4ef05f3a-53c2-11ec-135c-435618636836
md"""## Where math and computer notations diverge
"""

# ╔═╡ 4ef05f8a-53c2-11ec-3aa1-0556f2b0c5b7
md"""It is important to recognize that `=` to `Julia` is not in analogy to how $=$ is used in mathematical notation. The following `Julia` code is not an equation:
"""

# ╔═╡ 4ef064b2-53c2-11ec-359b-f352d2ac31d8
let
	x = 3
	x = x^2
end

# ╔═╡ 4ef0650e-53c2-11ec-35ad-9f7415721de9
md"""What happens instead? The right hand side is evaluated (`x` is squared), the result is stored and bound to the variable `x` (so that `x` will end up pointing to the new value, `9`, and not the original one, `3`); finally the value computed on the right-hand side is returned and in this case displayed, as there is no trailing semicolon to suppress the output.
"""

# ╔═╡ 4ef06540-53c2-11ec-335b-e94b21384392
md"""This is completely unlike the mathematical equation $x = x^2$ which is typically solved for values of $x$ that satisfy the equation ($0$ and $1$).
"""

# ╔═╡ 4ef0655c-53c2-11ec-1dc0-e55d6ee26410
md"""##### Example
"""

# ╔═╡ 4ef0657a-53c2-11ec-3701-3bedbc6f76b7
md"""Having `=` as assignment is usefully exploited when modeling sequences. For example, an application of Newton's method might end up with this expression:
"""

# ╔═╡ 4ef065ac-53c2-11ec-37f7-557da4ee9276
md"""```math
x_{i+1} = x_i - \frac{x_i^2 - 2}{2x_i}
```
"""

# ╔═╡ 4ef065d2-53c2-11ec-3f7e-e9921dd98ce3
md"""As a mathematical expression, for each $i$ this defines a new value for $x_{i+1}$ in terms of a known value $x_i$. This can be used to recursively generate a sequence, provided some starting point is known, such as $x_0 = 2$.
"""

# ╔═╡ 4ef065f2-53c2-11ec-19dc-83f6929ef41c
md"""The above might be written instead with:
"""

# ╔═╡ 4ef069ee-53c2-11ec-2b65-7f740502711f
let
	x = 2
	x = x - (x^2 - 2) / (2x)
	x = x - (x^2 - 2) / (2x)
end

# ╔═╡ 4ef06a16-53c2-11ec-195c-37e1789568ba
md"""Repeating this last line will generate new values of `x` based on the previous one - no need for subscripts. This is exactly what the mathematical notation indicates is to be done.
"""

# ╔═╡ 4ef06a34-53c2-11ec-037c-5f6258485a86
md"""## Context
"""

# ╔═╡ 4ef06a52-53c2-11ec-006e-fd3e2d39bb08
md"""The binding of a value to a variable name happens within some context. For our simple illustrations, we are assigning values, as though they were typed at the command line. This stores the binding in the `Main` module. `Julia` looks for variables in this module when it encounters an expression and the value is substituted. Other uses, such as when variables are defined within a function, involve different contexts which may not be visible within the `Main` module.
"""

# ╔═╡ 4ef07506-53c2-11ec-13e4-21243a0c8a88
note("""
The `varinfo` function will list the variables currently defined in the
main workspace. There is no mechanism to delete a single variable.
""")

# ╔═╡ 4ef0adaa-53c2-11ec-2c2e-f7e0c19df1b2
alert("""
**Shooting oneselves in the foot.** `Julia` allows us to locally
redefine variables that are built in, such as the value for `pi` or
the function object assigned to `sin`. For example, this is a
perfectly valid command `sin=3`. However, it will overwrite the
typical value of `sin` so that `sin(3)` will be an error. At the terminal, the
binding to `sin` occurs in the `Main` module. This shadows that
value of `sin` bound in the `Base` module. Even if redefined in
`Main`, the value in base can be used by fully qualifying the name,
as in `Base.sin(pi)`. This uses the notation
`module_name.variable_name` to look up a binding in a module.
""")

# ╔═╡ 4ef0ae06-53c2-11ec-38c6-09ea82db3937
md"""## Variable names
"""

# ╔═╡ 4ef0aefe-53c2-11ec-2e1b-27f892130383
md"""`Julia` has a very wide set of possible [names](https://docs.julialang.org/en/stable/manual/variables/#Allowed-Variable-Names-1) for variables. Variables are case sensitive and their names can include many [Unicode](http://en.wikipedia.org/wiki/List_of_Unicode_characters) characters. Names must begin with a letter or an appropriate Unicode value (but not a number). There are some reserved words, such as `try` or `else` which can not be assigned to. However, many built-in names can be locally overwritten. Conventionally, variable names are lower case. For compound names, it is not unusual to see them squished together, joined with underscores, or written in camelCase.
"""

# ╔═╡ 4ef0b7d2-53c2-11ec-27a9-f3a116c0d99f
begin
	value_1 = 1
	a_long_winded_variable_name = 2
	sinOfX = sind(45)
	__private = 2     # a convention
end

# ╔═╡ 4ef0b818-53c2-11ec-3fed-576b73c2e524
md"""### Unicode names
"""

# ╔═╡ 4ef0b8d6-53c2-11ec-328f-cfa2693f82b5
md"""Julia allows variable names to use Unicode identifiers. Such names allow `julia` notation to mirror that of many mathematical texts. For example, in calculus the variable $\epsilon$ is often used to represent some small number. We can assign to a symbol that looks like $\epsilon$ using `Julia`'s LaTeX input mode. Typing `\epsilon[tab]` will replace the text with the symbol within `IJulia` or the command line.
"""

# ╔═╡ 4ef0bd9a-53c2-11ec-2cfb-7dd4c92fa8d3
ϵ = 1e-10

# ╔═╡ 4ef0be50-53c2-11ec-1fef-29247868e5c8
md"""Entering Unicode names follows the pattern of "slash" + LaTeX name + `[tab]` key. Some other ones that are useful are `\delta[tab]`, `\alpha[tab]`, and `\beta[tab]`, though there are [hundreds](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/latex_symbols.jl) of other values defined.
"""

# ╔═╡ 4ef0be76-53c2-11ec-3da9-4f8cdc988553
md"""For example, we could have defined `theta` (`\theta[tab]`) and `v0` (`v\_0[tab]`) using Unicode to make them match more closely the typeset math:
"""

# ╔═╡ 4ef0e7d4-53c2-11ec-0c6d-5744cde61960
θ = 45; v₀ = 200

# ╔═╡ 4ef0e838-53c2-11ec-1cc2-f707ae4e347e
md"""These notes often use Unicode alternatives to avoid the `Pluto` requirement of a single use of assigning to a variable name in a notebook without placing the assignment in a `let` block or a function body.
"""

# ╔═╡ 4ef0f5a8-53c2-11ec-072c-4781e05b7312
alert("""
There is even support for tab-completion of
[emojis](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/emoji_symbols.jl)
such as `\\:snowman:[tab]` or `\\:koala:[tab]`

""")

# ╔═╡ 4ef0f60c-53c2-11ec-1e73-c1cd73c61207
md"""##### Example
"""

# ╔═╡ 4ef0f710-53c2-11ec-16d7-336df211a484
md"""As mentioned the value of $e$ is bound to the unicode value `\euler[tab]` and not the letter `e`, so Unicode entry is required to access this constant This isn't quite true. The `MathConstants` module defines `e`, as well as a few other values accessed via unicode. When the `CalculusWithJulia` package is loaded, as will often be done in these notes, a value of `exp(1)` is assigned to `e`.
"""

# ╔═╡ 4ef0f738-53c2-11ec-1afc-bd637d2ab489
md"""## Tuple assignment
"""

# ╔═╡ 4ef0f74c-53c2-11ec-2dfa-076df0138b94
md"""It is a common task to define more than one variable. Multiple definitions can be done in one line, using semicolons to break up the commands, as with:
"""

# ╔═╡ 4ef0ffe4-53c2-11ec-2972-9bf227590758
let
	a = 1; b = 2; c=3
end

# ╔═╡ 4ef10192-53c2-11ec-365f-b7918228381d
md"""For convenience, `Julia` allows an alternate means to define more than one variable at a time. The syntax is similar:
"""

# ╔═╡ 4ef10cdc-53c2-11ec-1d52-3b808d42d1dc
let
	a, b, c = 1, 2, 3
	b
end

# ╔═╡ 4ef10d68-53c2-11ec-2349-2d308c81d2d1
md"""This sets `a=1`, `b=2`, and `c=3`, as suggested. This construct relies on *tuple destructuring*. The expression on the right hand side forms a tuple of values. A tuple is a container for different types of values, and in this case the tuple has 3 values. When the same number of variables match on the left-hand side as those in the container on the right, the names are assigned one by one.
"""

# ╔═╡ 4ef10d9a-53c2-11ec-1e33-9727d2cddf4c
md"""The value on the right hand side is evaluated, then the assignment occurs. The following exploits this to swap the values assigned to `a` and `b`:
"""

# ╔═╡ 4ef116fa-53c2-11ec-3027-5b3ff033c833
let
	a, b = 1, 2
	a, b = b, a
end

# ╔═╡ 4ef117fe-53c2-11ec-00e1-bda9ff9b43dc
md"""#### Example, finding the slope
"""

# ╔═╡ 4ef11934-53c2-11ec-13b8-c1d7a7c9cbc7
md"""Find the slope of the line connecting the points $(1,2)$ and $(4,6)$. We begin by defining the values and then applying the slope formula:
"""

# ╔═╡ 4ef121ca-53c2-11ec-02c6-e5cc590ef713
begin
	x0, y0 = 1, 2
	x1, y1 = 4, 6
	m = (y1 - y0) / (x1 - x0)
end

# ╔═╡ 4ef12280-53c2-11ec-1db6-43da678ca1a3
md"""Of course, this could be computed directly with `(6-2) / (4-1)`, but by using familiar names for the values we can be certain we apply the formula properly.
"""

# ╔═╡ 4ef122bc-53c2-11ec-3d49-7f3b9e9fddb5
md"""## Questions
"""

# ╔═╡ 4ef13b9e-53c2-11ec-3c73-132b874d67e1
md"""###### Question
"""

# ╔═╡ 4ef13c02-53c2-11ec-2a87-5be12205ce13
md"""Let $a=10$, $b=2.3$, and $c=8$. Find the value of $(a-b)/(a-c)$.
"""

# ╔═╡ 4ef1591c-53c2-11ec-122b-d770b29cb581
let
	a,b,c = 10, 2.3, 8;
	numericq((a-b)/(a-c))
end

# ╔═╡ 4ef15962-53c2-11ec-1f3c-2b1ea1c5b24c
md"""###### Question
"""

# ╔═╡ 4ef159e2-53c2-11ec-29bb-91796658a146
md"""Let `x = 4`. Compute $y=100 - 2x - x^2$. What is the value:
"""

# ╔═╡ 4ef160b0-53c2-11ec-17c6-6f634f590ce3
let
	x = 4
	y =- 100 - 2x - x^2
	numericq(y, 0.1)
end

# ╔═╡ 4ef160e2-53c2-11ec-24f6-bbd2eaaae8f2
md"""###### Question
"""

# ╔═╡ 4ef160f6-53c2-11ec-3750-e187984e92f0
md"""What is the answer to this computation?
"""

# ╔═╡ 4ef16146-53c2-11ec-00c8-0174e12b3dd2
md"""```
a = 3.2; b=2.3
a^b - b^a
```"""

# ╔═╡ 4ef16ac4-53c2-11ec-1582-05caec10f114
let
	a = 3.2; b=2.3;
	val = a^b - b^a;
	numericq(val)
end

# ╔═╡ 4ef16af6-53c2-11ec-29b8-93d89c976c1f
md"""###### Question
"""

# ╔═╡ 4ef16b0a-53c2-11ec-04c2-9d33e48e85ee
md"""For longer computations, it can be convenient to do them in parts, as this makes it easier to check for mistakes.
"""

# ╔═╡ 4ef16b8c-53c2-11ec-2e65-2bd8c912e275
md"""For example, to compute
"""

# ╔═╡ 4ef16c22-53c2-11ec-2606-958b172c84c4
md"""```math
\frac{p - q}{\sqrt{p(1-p)}}
```
"""

# ╔═╡ 4ef16d1c-53c2-11ec-0a12-29dbe8bee9c1
md"""for $p=0.25$ and $q=0.2$ we might do:
"""

# ╔═╡ 4ef16e0c-53c2-11ec-0cbb-555cd2b4438a
md"""```
p, q = 0.25, 0.2
top = p - q
bottom = sqrt(p*(1-p))
ans = top/bottom
```"""

# ╔═╡ 4ef16e96-53c2-11ec-0a9f-a58ebb9d96f3
md"""What is the result of the above?
"""

# ╔═╡ 4ef1ab38-53c2-11ec-00eb-7fa370b59e5f
let
	p, q = 0.25, 0.2;
	top = p - q;
	bottom = sqrt(p*(1-p));
	ans = top/bottom;
	numericq(ans)
end

# ╔═╡ 4ef1aba6-53c2-11ec-1b65-09f5285daa3e
md"""###### Question
"""

# ╔═╡ 4ef1ac00-53c2-11ec-00d1-4568b0366f0c
md"""Using variables to record the top and the bottom of the expression, compute the following for $x=3$:
"""

# ╔═╡ 4ef1ac28-53c2-11ec-3775-c79cecc6901c
md"""```math
y = \frac{x^2 - 2x - 8}{x^2 - 9x - 20}.
```
"""

# ╔═╡ 4ef1b150-53c2-11ec-2786-9383b98634d8
let
	x = 3
	val = (x^2 - 2x - 8)/(x^2 - 9x - 20)
	numericq(val)
end

# ╔═╡ 4ef1b178-53c2-11ec-2b50-c1de322e2ab1
md"""###### Question
"""

# ╔═╡ 4ef1b1aa-53c2-11ec-27de-8f6270decf67
md"""Which if these is not a valid variable name (identifier) in `Julia`:
"""

# ╔═╡ 4ef1d324-53c2-11ec-018c-0f80874fc981
let
	choices = [
	q"5degreesbelowzero",
	q"some_really_long_name_that_is_no_fun_to_type",
	q"aMiXeDcAsEnAmE",
	q"fahrenheit451"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4ef1d3bc-53c2-11ec-35fe-0568da2ff115
md"""###### Question
"""

# ╔═╡ 4ef1d400-53c2-11ec-2973-e7b2ee9db890
md"""Which of these symbols is  one of `Julia`'s built-in math constants?
"""

# ╔═╡ 4ef1dd24-53c2-11ec-1f49-0d7adab8c353
let
	choices = [q"pi", q"oo", q"E", q"I"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4ef1dd56-53c2-11ec-0fcb-1be1817600d8
md"""###### Question
"""

# ╔═╡ 4ef1dd6a-53c2-11ec-07d4-9dd757b8e71a
md"""What key sequence will produce this assignment
"""

# ╔═╡ 4ef1dda6-53c2-11ec-2bf0-a770cff67677
md"""```
δ = 1/10
```"""

# ╔═╡ 4ef1e8f0-53c2-11ec-08c4-5148f87c110b
let
	choices=[
	q"\delta[tab] = 1/10",
	q"delta[tab] = 1/10",
	q"$\\delta$ = 1/10"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4ef1e92c-53c2-11ec-0e29-81f91f2b3baf
md"""###### Question
"""

# ╔═╡ 4ef1e986-53c2-11ec-39a3-cb97a76e99b7
md"""Which of these three statements will **not** be a valid way to assign three variables at once:
"""

# ╔═╡ 4ef1f458-53c2-11ec-1651-d348b5b91e2e
let
	choices = [
	q"a=1, b=2, c=3",
	q"a,b,c = 1,2,3",
	q"a=1; b=2; c=3"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4ef1f494-53c2-11ec-2849-4f2ba71d49ae
md"""###### Question
"""

# ╔═╡ 4ef1f584-53c2-11ec-085e-19f1bdaea4ca
md"""The fact that assignment *always* returns the value of the right hand side *and* the fact that the `=` sign associates from right to left means that the following idiom:
"""

# ╔═╡ 4ef1f5de-53c2-11ec-0883-8dcc96fd2b0d
md"""```
x = y = z = 3
```"""

# ╔═╡ 4ef1f688-53c2-11ec-306a-73a0d20dbea5
md"""Will always:
"""

# ╔═╡ 4ef205a6-53c2-11ec-101b-f5bd7f4069d9
let
	choices = ["Assign all three variables at once to a value of 3",
	"Create 3 linked values that will stay synced when any value changes",
	"Throw an error"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 4ef205d8-53c2-11ec-2ca9-cf874a16b440
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/calculator.html">◅ previous</a>  <a href="../precalc/numbers_types.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/variables.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 4ef205e2-53c2-11ec-331a-451d03c11026
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.10"
PlutoUI = "~0.7.21"
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

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[deps.ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

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

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

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

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

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

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

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

[[deps.Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[deps.YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─4ef205ba-53c2-11ec-3a66-0f16cdcc6174
# ╟─4eeecada-53c2-11ec-3f91-152a23d6ee6a
# ╟─4eeecbfc-53c2-11ec-1e01-9bc6f45fb35a
# ╟─4eef5342-53c2-11ec-0850-bbf94b730535
# ╟─4eef5446-53c2-11ec-043f-6fb185140bda
# ╟─4eefa630-53c2-11ec-14e7-c137a50fa5c0
# ╟─4eefa72a-53c2-11ec-38ea-69fbf35839a9
# ╟─4eefa76e-53c2-11ec-39de-4d31044f32cf
# ╟─4eefa784-53c2-11ec-2820-6b03b988fed4
# ╠═4eefc9f8-53c2-11ec-2691-bfe5917b6d51
# ╟─4eefcaca-53c2-11ec-05c2-af88caa462d8
# ╠═4eefd092-53c2-11ec-014f-e3ee8c6b85c0
# ╟─4eefd0ce-53c2-11ec-1427-b388cc8ccb51
# ╟─4eefd10a-53c2-11ec-05c9-67787b684b97
# ╠═4eefd498-53c2-11ec-109e-b5b8d14ecef6
# ╟─4ef01520-53c2-11ec-1d3e-79798ba34b4d
# ╟─4ef01584-53c2-11ec-108c-09305235ec4d
# ╟─4ef015a4-53c2-11ec-32f7-5f384120bf05
# ╟─4ef01642-53c2-11ec-2a74-ff4c197d1c37
# ╟─4ef01656-53c2-11ec-3fa3-ad2ccdae8a2c
# ╠═4ef04af4-53c2-11ec-0106-f78141a10965
# ╟─4ef04ba8-53c2-11ec-1c8f-953e432475bf
# ╟─4ef04bee-53c2-11ec-2467-e1935613244b
# ╟─4ef04c7a-53c2-11ec-3520-31f96bf05bcd
# ╟─4ef04cd4-53c2-11ec-237f-fde8aec2eddc
# ╟─4ef04d24-53c2-11ec-31d6-9de3253229cd
# ╠═4ef053bc-53c2-11ec-120e-d34b5dfbc653
# ╟─4ef05418-53c2-11ec-172a-316fae119f25
# ╟─4ef0542c-53c2-11ec-2598-d10a419250e1
# ╟─4ef0545e-53c2-11ec-09d2-31162bd75acf
# ╠═4ef05968-53c2-11ec-12ac-338fb7e75594
# ╟─4ef059a4-53c2-11ec-23d8-779f7b5a14c9
# ╠═4ef05ef4-53c2-11ec-2230-f1814f2d67f0
# ╟─4ef05f3a-53c2-11ec-135c-435618636836
# ╟─4ef05f8a-53c2-11ec-3aa1-0556f2b0c5b7
# ╠═4ef064b2-53c2-11ec-359b-f352d2ac31d8
# ╟─4ef0650e-53c2-11ec-35ad-9f7415721de9
# ╟─4ef06540-53c2-11ec-335b-e94b21384392
# ╟─4ef0655c-53c2-11ec-1dc0-e55d6ee26410
# ╟─4ef0657a-53c2-11ec-3701-3bedbc6f76b7
# ╟─4ef065ac-53c2-11ec-37f7-557da4ee9276
# ╟─4ef065d2-53c2-11ec-3f7e-e9921dd98ce3
# ╟─4ef065f2-53c2-11ec-19dc-83f6929ef41c
# ╠═4ef069ee-53c2-11ec-2b65-7f740502711f
# ╟─4ef06a16-53c2-11ec-195c-37e1789568ba
# ╟─4ef06a34-53c2-11ec-037c-5f6258485a86
# ╟─4ef06a52-53c2-11ec-006e-fd3e2d39bb08
# ╟─4ef07506-53c2-11ec-13e4-21243a0c8a88
# ╟─4ef0adaa-53c2-11ec-2c2e-f7e0c19df1b2
# ╟─4ef0ae06-53c2-11ec-38c6-09ea82db3937
# ╟─4ef0aefe-53c2-11ec-2e1b-27f892130383
# ╠═4ef0b7d2-53c2-11ec-27a9-f3a116c0d99f
# ╟─4ef0b818-53c2-11ec-3fed-576b73c2e524
# ╟─4ef0b8d6-53c2-11ec-328f-cfa2693f82b5
# ╠═4ef0bd9a-53c2-11ec-2cfb-7dd4c92fa8d3
# ╟─4ef0be50-53c2-11ec-1fef-29247868e5c8
# ╟─4ef0be76-53c2-11ec-3da9-4f8cdc988553
# ╠═4ef0e7d4-53c2-11ec-0c6d-5744cde61960
# ╟─4ef0e838-53c2-11ec-1cc2-f707ae4e347e
# ╟─4ef0f5a8-53c2-11ec-072c-4781e05b7312
# ╟─4ef0f60c-53c2-11ec-1e73-c1cd73c61207
# ╟─4ef0f710-53c2-11ec-16d7-336df211a484
# ╟─4ef0f738-53c2-11ec-1afc-bd637d2ab489
# ╟─4ef0f74c-53c2-11ec-2dfa-076df0138b94
# ╠═4ef0ffe4-53c2-11ec-2972-9bf227590758
# ╟─4ef10192-53c2-11ec-365f-b7918228381d
# ╠═4ef10cdc-53c2-11ec-1d52-3b808d42d1dc
# ╟─4ef10d68-53c2-11ec-2349-2d308c81d2d1
# ╟─4ef10d9a-53c2-11ec-1e33-9727d2cddf4c
# ╠═4ef116fa-53c2-11ec-3027-5b3ff033c833
# ╟─4ef117fe-53c2-11ec-00e1-bda9ff9b43dc
# ╟─4ef11934-53c2-11ec-13b8-c1d7a7c9cbc7
# ╠═4ef121ca-53c2-11ec-02c6-e5cc590ef713
# ╟─4ef12280-53c2-11ec-1db6-43da678ca1a3
# ╟─4ef122bc-53c2-11ec-3d49-7f3b9e9fddb5
# ╟─4ef13b9e-53c2-11ec-3c73-132b874d67e1
# ╟─4ef13c02-53c2-11ec-2a87-5be12205ce13
# ╟─4ef1591c-53c2-11ec-122b-d770b29cb581
# ╟─4ef15962-53c2-11ec-1f3c-2b1ea1c5b24c
# ╟─4ef159e2-53c2-11ec-29bb-91796658a146
# ╟─4ef160b0-53c2-11ec-17c6-6f634f590ce3
# ╟─4ef160e2-53c2-11ec-24f6-bbd2eaaae8f2
# ╟─4ef160f6-53c2-11ec-3750-e187984e92f0
# ╟─4ef16146-53c2-11ec-00c8-0174e12b3dd2
# ╟─4ef16ac4-53c2-11ec-1582-05caec10f114
# ╟─4ef16af6-53c2-11ec-29b8-93d89c976c1f
# ╟─4ef16b0a-53c2-11ec-04c2-9d33e48e85ee
# ╟─4ef16b8c-53c2-11ec-2e65-2bd8c912e275
# ╟─4ef16c22-53c2-11ec-2606-958b172c84c4
# ╟─4ef16d1c-53c2-11ec-0a12-29dbe8bee9c1
# ╟─4ef16e0c-53c2-11ec-0cbb-555cd2b4438a
# ╟─4ef16e96-53c2-11ec-0a9f-a58ebb9d96f3
# ╟─4ef1ab38-53c2-11ec-00eb-7fa370b59e5f
# ╟─4ef1aba6-53c2-11ec-1b65-09f5285daa3e
# ╟─4ef1ac00-53c2-11ec-00d1-4568b0366f0c
# ╟─4ef1ac28-53c2-11ec-3775-c79cecc6901c
# ╟─4ef1b150-53c2-11ec-2786-9383b98634d8
# ╟─4ef1b178-53c2-11ec-2b50-c1de322e2ab1
# ╟─4ef1b1aa-53c2-11ec-27de-8f6270decf67
# ╟─4ef1d324-53c2-11ec-018c-0f80874fc981
# ╟─4ef1d3bc-53c2-11ec-35fe-0568da2ff115
# ╟─4ef1d400-53c2-11ec-2973-e7b2ee9db890
# ╟─4ef1dd24-53c2-11ec-1f49-0d7adab8c353
# ╟─4ef1dd56-53c2-11ec-0fcb-1be1817600d8
# ╟─4ef1dd6a-53c2-11ec-07d4-9dd757b8e71a
# ╟─4ef1dda6-53c2-11ec-2bf0-a770cff67677
# ╟─4ef1e8f0-53c2-11ec-08c4-5148f87c110b
# ╟─4ef1e92c-53c2-11ec-0e29-81f91f2b3baf
# ╟─4ef1e986-53c2-11ec-39a3-cb97a76e99b7
# ╟─4ef1f458-53c2-11ec-1651-d348b5b91e2e
# ╟─4ef1f494-53c2-11ec-2849-4f2ba71d49ae
# ╟─4ef1f584-53c2-11ec-085e-19f1bdaea4ca
# ╟─4ef1f5de-53c2-11ec-0883-8dcc96fd2b0d
# ╟─4ef1f688-53c2-11ec-306a-73a0d20dbea5
# ╟─4ef205a6-53c2-11ec-101b-f5bd7f4069d9
# ╟─4ef205d8-53c2-11ec-2ca9-cf874a16b440
# ╟─4ef205d8-53c2-11ec-3dce-75c1dd99cbe2
# ╟─4ef205e2-53c2-11ec-331a-451d03c11026
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
