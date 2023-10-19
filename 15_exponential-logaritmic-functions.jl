### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 82998210-53bf-11ec-13e0-cf06e9cecf74
begin
	using CalculusWithJulia
	using Plots
end

# ╔═╡ 829986c2-53bf-11ec-3159-37fcbe6977bf
begin
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :exp_log_functions
	nothing
end

# ╔═╡ 82aa8830-53bf-11ec-3023-a303754a96dc
using PlutoUI

# ╔═╡ 82aa880a-53bf-11ec-108b-d5ee06e89d33
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 8298ba60-53bf-11ec-20c8-0b3fa54ecb23
md"""# Exponential and logarithmic functions
"""

# ╔═╡ 8298ccd0-53bf-11ec-1413-69bc1b859b96
md"""This section uses the following add-on packages:
"""

# ╔═╡ 82999d2c-53bf-11ec-2b13-0797c1dc6c65
md"""---
"""

# ╔═╡ 82999d86-53bf-11ec-2c9d-433ceed821d2
md"""The family of exponential functions is used to model growth and decay. The family of logarithmic functions is defined here as the inverse of the exponential functions, but have reach far outside of that.
"""

# ╔═╡ 8299b168-53bf-11ec-3c0d-3742ca4db444
md"""## Exponential functions
"""

# ╔═╡ 8299b1fe-53bf-11ec-0669-7b28a51eb058
md"""The family of exponential functions is defined by $f(x) = a^x, -\infty< x < \infty$ and $a > 0$. For $0 < a < 1$ these functions decay or decrease, for $a > 1$ the functions grow or increase, and if $a=1$ the function is constantly $1$.
"""

# ╔═╡ 8299b24e-53bf-11ec-08a6-733c9c58bb09
md"""For a given $a$, defining $a^n$ for positive integers is straightforward, as it means multiplying $n$ copies of $a.$ From this, the key properties of exponents: $a^x \cdot a^y = a^{x+y}$, and $(a^x)^y = a^{x \cdot y}$ are immediate consequences, for integer powers. For $a \neq 0$, $a^0$ is defined to be $1$. For positive, integer values of $n$, we have by definition that $a^{-n} = 1/a^n$. For $n$ a positive integer, we can define $a^{1/n}$ to be the unique positive solution to $x^n=a$. And using the key properties of exponents extend this to a definition of $a^x$ for any rational $x$.
"""

# ╔═╡ 8299b328-53bf-11ec-2327-0fef6551234e
md"""Defining $a^x$ for any real number requires some more sophisticated mathematics. One method is to use a [theorem](http://tinyurl.com/zk86c8r) that says a *bounded* monotonically increasing sequence will converge. (This uses the [Completeness Axiom](https://en.wikipedia.org/wiki/Completeness_of_the_real_numbers).) Then for $a > 1$ we have if $q_n$ is a sequence of rational numbers increasing to $x$, then $a^{q_n}$ will be a bounded sequence of increasing numbers, so will converge to a number defined to be $a^x$. Something similar is possible for the $0 < a < 1$ case.
"""

# ╔═╡ 8299b33e-53bf-11ec-2ad4-73c84f2ea22f
md"""This definition can be done to ensure the rules of exponents hold for $a > 0$:
"""

# ╔═╡ 8299c9e8-53bf-11ec-204c-95f51a9d234a
md"""```math
a^{x + y} = a^x \cdot a^y, \quad (a^x)^y = a^{x \cdot y}.
```
"""

# ╔═╡ 8299ca5e-53bf-11ec-1684-a56c2ddffc3a
md"""In `Julia` these functions are implemented using `^` or for a base of $e$ through `exp(x)`. Here are some representative graphs:
"""

# ╔═╡ 829a1432-53bf-11ec-2f72-af41169705d9
let
	f1(x) = (1/2)^x
	f2(x) = 1^x
	f3(x) = 2^x
	f4(x) = exp(x)
	
	plot(f1, -2, 2, label="1/2")
	plot!(f2, label="1")
	plot!(f3, label="2")
	plot!(f4, label="e")
end

# ╔═╡ 829a145a-53bf-11ec-0c00-970f27eff566
md"""We see examples of some general properties:
"""

# ╔═╡ 82a164d0-53bf-11ec-3665-252cea266e1d
md"""  * The domain is all real $x$ and the range is all *positive* $y$ (provided $a \neq 1$).
  * For $0 < a < 1$ the functions are monotonically decreasing.
  * For $a > 1$ the functions are monotonically increasing.
  * If $1 < a < b$ and $x > 0$ we have $a^x < b^x$.
"""

# ╔═╡ 82a17cea-53bf-11ec-2b0b-31bce4c14425
md"""##### Example
"""

# ╔═╡ 82a2a76e-53bf-11ec-2edf-4db4bb93275c
md"""[Continuously](http://tinyurl.com/gsy939y) compounded interest allows an initial amount $P_0$ to grow over time according to $P(t)=P_0e^{rt}$. Investigate the difference between investing $1,000$ dollars in an account which earns $2$% as opposed to an account which earns $8$% over $20$ years.
"""

# ╔═╡ 82a2a7d4-53bf-11ec-2b2a-cf1d5625125c
md"""The  $r$ in the formula is the interest rate, so $r=0.02$ or $r=0.08$. To compare the differences we have:
"""

# ╔═╡ 82a33d28-53bf-11ec-399d-d12134c4213d
begin
	r2, r8 = 0.02, 0.08
	P0 = 1000
	t = 20
	P0 * exp(r2*t), P0 * exp(r8*t)
end

# ╔═╡ 82a33d78-53bf-11ec-1292-63ad4bdfce37
md"""As can be seen, there is quite a bit of difference.
"""

# ╔═╡ 82a33de6-53bf-11ec-1742-63f8481152e8
md"""In 1494, [Pacioli](http://tinyurl.com/gsy939y) gave the "Rule of 72", stating that to find the number of years it takes an investment to double when continuously compounded one should divide the interest rate into $72$.
"""

# ╔═╡ 82a33e04-53bf-11ec-10ce-fdb1c640a5f5
md"""This formula is not quite precise, but a rule of thumb, the number is closer to $69$, but $72$ has many divisors which makes this an easy to compute approximation. Let's see how accurate it is:
"""

# ╔═╡ 82a35e66-53bf-11ec-029a-ed7a0835c86c
begin
	t2, t8 = 72/2, 72/8
	exp(r2*t2), exp(r8*t8)
end

# ╔═╡ 82a35eb6-53bf-11ec-2000-498a22bb7188
md"""So fairly close - after $72/r$ years the amount is $2.05...$ times more than the initial amount.
"""

# ╔═╡ 82a35ed4-53bf-11ec-26bc-e98f547326b0
md"""##### Example
"""

# ╔═╡ 82a35f24-53bf-11ec-0f0a-e3c52c077ad2
md"""[Bacterial growth](https://en.wikipedia.org/wiki/Bacterial_growth) (according to Wikipedia) is the asexual reproduction, or cell division, of a bacterium into two daughter cells, in a process called binary fission. During the log phase "the number of new bacteria appearing per unit time is proportional to the present population." The article states that "Under controlled conditions, *cyanobacteria* can double their population four times a day..."
"""

# ╔═╡ 82a35f4c-53bf-11ec-36c8-83ae35bd0eb3
md"""Suppose an initial population of $P_0$ bacteria, a formula for the number after $n$ *hours* is $P(n) = P_0 2^{n/6}$ where $6 = 24/4$.
"""

# ╔═╡ 82a35f62-53bf-11ec-13ad-67fdb05545ff
md"""After two days what multiple of the initial amount is present if conditions are appropriate?
"""

# ╔═╡ 82a39412-53bf-11ec-278d-37e6a8bcef67
let
	n = 2 * 24
	2^(n/6)
end

# ╔═╡ 82a39430-53bf-11ec-3667-a7055a04669e
md"""That would be an enormous growth.  Don't worry: "Exponential growth cannot continue indefinitely, however, because the medium is soon depleted of nutrients and enriched with wastes."
"""

# ╔═╡ 82a3944e-53bf-11ec-1857-ab00886a1ee1
md"""##### Example
"""

# ╔═╡ 82a394bc-53bf-11ec-34e2-0b57141cb725
md"""The famous [Fibonacci](https://en.wikipedia.org/wiki/Fibonacci_number) numbers are $1,1,2,3,5,8,13,\dots$, where $F_{n+1}=F_n+F_{n-1}$. These numbers increase. To see how fast, if we *guess* that the growth is evenually exponential and assume $F_n \approx c \cdot a^n$, then our equation is approximately $ca^{n+1} = ca^n + ca^{n-1}$. Factoring out common terms gives $ca^{n-1} \cdot (a^2 - a - 1) = 0$. The term $a^{n-1}$ is always positive, so any solution would satisfy $a^2 - a -1 = 0$. The positve solution is $(1 + \sqrt{5})/2 \approx 1.618$
"""

# ╔═╡ 82a394ee-53bf-11ec-3b82-113ac3f0174f
md"""That is evidence that the $F_n \approx c\cdot 1.618^n$. (See [Relation to golden ratio](https://en.wikipedia.org/wiki/Fibonacci_number#Relation_to_the_golden_ratio) for a related, but more explicit exact formula.
"""

# ╔═╡ 82a394f8-53bf-11ec-1036-0122999dffb8
md"""##### Example
"""

# ╔═╡ 82a3950e-53bf-11ec-3c74-f3db20128339
md"""In the previous example, the exponential family of functions is used to describe growth. Polynomial functions also increase. Could these be used instead? If so that would be great, as they are easier to reason about.
"""

# ╔═╡ 82a3952a-53bf-11ec-12e4-4b35f75713cf
md"""The key fact is that exponential growth is much greater than polynomial growth. That is for large enough $x$ and for any fixed $a>1$ and positive integer $n$ it is true that $a^x \gg x^n$.
"""

# ╔═╡ 82a39534-53bf-11ec-208f-33b1b7ce64d5
md"""Later we will see an easy way to certify this statement.
"""

# ╔═╡ 82a39548-53bf-11ec-15c4-e11c04c96afb
md"""##### The mathematical constant $e$
"""

# ╔═╡ 82a39584-53bf-11ec-2b93-4176d0946832
md"""Euler's number, $e$, may be defined several ways. One way is as the limit of $(1+1/n)^n$. The value is an irrational number. This number turns up to be the natural base to use for many problems arising in Calculus.  In `Julia` there are a few mathematical constants that get special treatment, so that when needed, extra precision is available. The value `e` is not immediately assigned to this value, rather `ℯ` is. This is typed `\euler[tab]`. The constant `e` is thought too important for other uses to reserve the name for  a single number. However, users can issue the command `using Base.MathConstants` and `e` will be available to represent this number. In `CalculusWithJulia`, the value `e` is defined to be the floating point number returned by `exp(1)`. This loses the feature of arbitrary precision, but has other advantages.
"""

# ╔═╡ 82a395b6-53bf-11ec-1f68-bd126d7ef744
md"""A [cute](https://www.mathsisfun.com/numbers/e-eulers-number.html) appearance of $e$ is in this problem: Let $a>0$. Cut $a$ into $n$ equal pieces and then multiply them. What $n$ will produce the largest value? Note that the formula is $(a/n)^n$ for a given $a$ and $n$.
"""

# ╔═╡ 82a395ca-53bf-11ec-2e68-bdeb1daf93b8
md"""Suppose $a=5$ then for $n=1,2,3$ we get:
"""

# ╔═╡ 82a39994-53bf-11ec-03c4-9d7212437264
let
	a = 5
	(a/1)^1, (a/2)^2, (a/3)^3
end

# ╔═╡ 82a399bc-53bf-11ec-3f70-cb2f08c1456c
md"""We'd need to compare more, but at this point $n=2$ is the winner when $a=5$.
"""

# ╔═╡ 82a399d0-53bf-11ec-1b71-5f08e0fd5deb
md"""With calculus, we will be able to see that the function $f(x) = (a/x)^x$ will be maximized at $a/e$, but for now we approach this in an exploratory manner. Suppose $a=5$, then we have:
"""

# ╔═╡ 82a39d22-53bf-11ec-37d3-ad5524df0c01
let
	a = 5
	n = 1:10
	f(n) = (a/n)^n
	@. [n f(n) (a/n - e)]  # @. just allows broadcasting
end

# ╔═╡ 82a39d54-53bf-11ec-2e85-8d068d2e2a42
md"""We can see more clearly that $n=2$ is the largest value for $f$ and $a/2$ is the closest value to $e$. This would be the case for any $a>0$, pick $n$ so that $a/n$ is closest to $e$.
"""

# ╔═╡ 82a39d86-53bf-11ec-1696-75a4cbaea459
md"""## Logarithmic functions: the inverse of exponential functions
"""

# ╔═╡ 82a39dde-53bf-11ec-0d69-e5c78ab29a4e
md"""As the exponential functions are strictly *decreasing* when $0 < a < 1$ and strictly *increasing* when $a>1,$ in both cases an inverse function will exist. (When $a=1$ the function is a constant and is not one-to-one.) The domain of an exponential function is all real $x$ and the range is all *positive* $x$, so these are switched around for the inverse function. Explicitly: the inverse function to $f(x)=a^x$  will have domain $(0,\infty)$ and range $(-\infty, \infty)$ when $a > 0, a \neq 1$.
"""

# ╔═╡ 82a39df4-53bf-11ec-3997-a5331bd40df7
md"""The inverse function will solve for $x$ in the equation $a^x = y$. The answer, formally, is the logarithm base $a$, written $\log_a(x)$.
"""

# ╔═╡ 82a39e12-53bf-11ec-3df3-a9bf620f08ed
md"""That is $a^{\log_a(x)} = x$ for $x > 0$ and $\log_a(a^x) = x$ for all $x$.
"""

# ╔═╡ 82a39e4e-53bf-11ec-169c-613fe94fee17
md"""To see how a logarithm is mathematically defined will have to wait, though the family of functions - one for each $a>0$ - are implemented in `Julia` through the function `log(a,x)`. There are special cases requiring just one argument: `log(x)` will compute the natural log, base $e$ - the inverse of $f(x) = e^x$; `log2(x)` will compute the log base $2$ - the inverse of $f(x) = 2^x$; and `log10(x)` will compute the log base $10$ - the inverse of $f(x)=10^x$.
"""

# ╔═╡ 82a39e6c-53bf-11ec-3292-c9f5898ea6e8
md"""To see this in an example, we plot for base $2$ the exponential function $f(x)=2^x$, its inverse, and the logarithm function with base $2$:
"""

# ╔═╡ 82a3a312-53bf-11ec-18ac-4b0b6bb01db3
let
	f(x) = 2^x
	xs = range(-2, stop=2, length=100)
	ys = f.(xs)
	plot(xs, ys,  color=:blue, label="2ˣ")           # plot f
	plot!(ys, xs, color=:red, label="f⁻¹")           # plot f^(-1)
	xs = range(1/4, stop=4, length=100)
	plot!(xs, log2.(xs), color=:green, label="log₂") # plot log2
end

# ╔═╡ 82a3a33a-53bf-11ec-26d4-8b5ba0aafb7f
md"""Though we made three graphs, only two are seen, as the graph of `log2` matches that of the inverse function.
"""

# ╔═╡ 82a3a37e-53bf-11ec-31b0-bd8036e74165
md"""Note that we needed a bit of care to plot the inverse function directly, as the domain of $f$ is *not* the domain of $f^{-1}$. Again, in this case the domain of $f$ is all $x$, but the domain of $f^{-1}$ is only all *positive* $x$ values.
"""

# ╔═╡ 82a3a394-53bf-11ec-22cb-dd4b1285d2bf
md"""Knowing that `log2` implements an inverse function allows us to solve many problems involving doubling.
"""

# ╔═╡ 82a3a3a8-53bf-11ec-1cc4-cf981479013b
md"""##### Example
"""

# ╔═╡ 82a3a3d0-53bf-11ec-1cdf-5badfb84099c
md"""An [old](https://en.wikipedia.org/wiki/Wheat_and_chessboard_problem) story about doubling is couched in terms of doubling grains of wheat. To simplify the story, suppose each day an amount of grain is doubled. How many days of doubling will it take $1$ grain to become $1$ million grains?
"""

# ╔═╡ 82a3a3f8-53bf-11ec-05ce-574797e603d5
md"""The number of grains after one day is $2$, two days is $4$, three days is $8$ and so after $n$ days the number of grains is $2^n$. To answer the question, we need to solve $2^x = 1,000,000$. The logarithm function yields $20$ days (after rounding up):
"""

# ╔═╡ 82a3a68c-53bf-11ec-0330-c7f5346d1ea0
log2(1_000_000)

# ╔═╡ 82a3a6a0-53bf-11ec-28fa-3f4b55fda188
md"""##### Example
"""

# ╔═╡ 82a3a6c0-53bf-11ec-1023-690c7b7aaaa8
md"""The half-life of a radioactive material is the time it takes for half the material to decay. Different materials have quite different half lives with some quite long, and others quite short. See [half lives](https://en.wikipedia.org/wiki/List_of_radioactive_isotopes_by_half-life) for some details.
"""

# ╔═╡ 82a3a6dc-53bf-11ec-3258-3bf896ccb2a6
md"""The carbon 14 isotope is a naturally occurring isotope on Earth, appearing in trace amounts. Unlike Carbon 12 and 13 it decays, in this case with a half life of 5730 years (plus or minus 40 years). In a [technique](https://en.wikipedia.org/wiki/Radiocarbon_dating) due to Libby, measuring the amount of Carbon 14 present in an organic item can indicate the time since death. The amount of Carbon 14 at death is essentially that of the atmosphere, and this amount decays over time. So, for example, if roughly half the carbon 14 remains, then the death occurred about 5730 years ago.
"""

# ╔═╡ 82a3a6fa-53bf-11ec-0077-3709e18dc7f5
md"""A formula for the amount of carbon 14 remaining $t$ years after death would be $P(t) = P_0 \cdot 2^{-t/5730}$.
"""

# ╔═╡ 82a3a70e-53bf-11ec-311c-1fcf213ae528
md"""If $1/10$ of the original carbon 14 remains, how old is the item? This amounts to solving $2^{-t/5730} = 1/10$. We have: $-t/5730 = \log_2(1/10)$ or:
"""

# ╔═╡ 82a3aaa6-53bf-11ec-396a-37a29b15a4b7
-5730 * log2(1/10)

# ╔═╡ 82a40468-53bf-11ec-0a4f-457a709a9fca
note("""
(Historically) Libby and James Arnold proceeded to test the radiocarbon dating theory by analyzing samples with known ages. For example, two samples taken from the tombs of two Egyptian kings, Zoser and Sneferu, independently dated to 2625 BC plus or minus 75 years, were dated by radiocarbon measurement to an average of 2800 BC plus or minus 250 years. These results were published in Science in 1949. Within 11 years of their announcement, more than 20 radiocarbon dating laboratories had been set up worldwide. Source: [Wikipedia](http://tinyurl.com/p5msnh6).
""")

# ╔═╡ 82a404ba-53bf-11ec-020f-19aba2b96d1c
md"""### Properties of logarithms
"""

# ╔═╡ 82a404e2-53bf-11ec-1384-8bc3c9c49fec
md"""The basic graphs of logarithms ($a > 1$) are all similar, though as we see larger bases lead to slower growing functions, though all satisfy $\log_a(1) = 0$:
"""

# ╔═╡ 82a4229c-53bf-11ec-26ce-5dfacec2939e
begin
	plot(log2, 1/2, 10, label="2")           # base 2
	plot!(log, 1/2, 10, label="e")           # base e
	plot!(log10, 1/2, 10, label="10")        # base 10
end

# ╔═╡ 82a422c2-53bf-11ec-1526-a1bd7b4d1bfe
md"""Now, what do the properties of exponents imply about logarithms?
"""

# ╔═╡ 82a422ec-53bf-11ec-2f77-0bea9c3dda80
md"""Consider the sum $\log_a(u) + \log_a(v)$. If we raise $a$ to this power, we have using the powers of exponents and the inverse nature of $a^x$ and $\log_a(x)$ that:
"""

# ╔═╡ 82a4231e-53bf-11ec-348e-5793522704c6
md"""```math
a^{\log_a(u) + \log_a(v)} = a^{\log_a(u)} \cdot a^{\log_a(v)} = u \cdot v.
```
"""

# ╔═╡ 82a42350-53bf-11ec-07ea-d7c91ad7ee99
md"""Taking $\log_a$ of *both* sides yields $\log_a(u) + \log_a(v)=\log_a(u\cdot v)$. That is logarithms turn products into sums (of logs).
"""

# ╔═╡ 82a42366-53bf-11ec-3f77-f9cf3ebc9c24
md"""Similarly, the relation $(a^{x})^y =a^{x \cdot y}, a > 0$ can be used to see that $\log_a(b^x) = x \cdot\log_a(b)$. This follows, as applying $a^x$ to each side yields the same answer.
"""

# ╔═╡ 82a42382-53bf-11ec-0b4a-959c7128583e
md"""Due to inverse relationship between $a^x$ and $\log_a(x)$ we have:
"""

# ╔═╡ 82a4238c-53bf-11ec-16da-9784e4a0715c
md"""```math
a^{\log_a(b^x)} = b^x.
```
"""

# ╔═╡ 82a42398-53bf-11ec-0c57-8bb4ab16a1e9
md"""Due to the rules of exponents, we have:
"""

# ╔═╡ 82a423aa-53bf-11ec-06f1-0773bb13b939
md"""```math
a^{x \log_a(b)} = a^{\log_a(b) \cdot x} = (a^{\log_a(b)})^x = b^x.
```
"""

# ╔═╡ 82a423ca-53bf-11ec-0d67-a5fc351dd883
md"""Finally, since $a^x$ is one-to-one (when $a>0$ and $a \neq 1$), if  $a^{\log_a(b^x)}=a^{x \log_a(b)}$ it must be that $\log_a(b^x) = x \log_a(b)$. That is, logarithms turn powers into products.
"""

# ╔═╡ 82a423dc-53bf-11ec-2e85-e78aaf691bbc
md"""Finally, we use the inverse property of logarithms and powers to show that logarithms can be defined for any base. Say $a, b > 0$. Then $\log_a(x) = \log_b(x)/\log_b(a)$. Again, to verify this we apply $a^x$ to both sides to see we get the same answer:
"""

# ╔═╡ 82a423e6-53bf-11ec-0305-e16f4ac4d8c6
md"""```math
a^{\log_a(x)} = x,
```
"""

# ╔═╡ 82a423f8-53bf-11ec-08a0-81a85ba76e8d
md"""this by the inverse property. Whereas, by expressing $a=b^{\log_b(a)}$ we have:
"""

# ╔═╡ 82a42404-53bf-11ec-1217-cd455abb1603
md"""```math
a^{(\log_b(x)/\log_b(b))} = (b^{\log_b(a)})^{(\log_b(x)/\log_b(a))} =
b^{\log_b(a) \cdot \log_b(x)/\log_b(a) } = b^{\log_b(x)} = x.
```
"""

# ╔═╡ 82a4240e-53bf-11ec-0075-2b5f8129852d
md"""In short, we have these three properties of logarithmic functions:
"""

# ╔═╡ 82a4242a-53bf-11ec-132e-6fb92ac64fdb
md"""If $a, b$ are positive bases; $u,v$ are positive numbers; and $x$ is any real number then:
"""

# ╔═╡ 82a42436-53bf-11ec-369b-7dbe24cd16c5
md"""```math
\begin{align*}
\log_a(uv) &= \log_a(u) + \log_a(v),    \\
\log_a(u^x) &= x \log_a(u), \text{ and} \\
\log_a(u) &= \log_b(u)/\log_b(a).
\end{align*}
```
"""

# ╔═╡ 82a43ade-53bf-11ec-1072-971012a2e4e4
md"""##### Example
"""

# ╔═╡ 82a43b4a-53bf-11ec-267c-872b5dc5bd8d
md"""Before the ubiquity of electronic calculating devices, the need to compute was still present. Ancient civilizations had abacuses to make addition easier. For multiplication and powers a [slide rule](https://en.wikipedia.org/wiki/Slide_rule) rule could be used. It is easy to represent addition physically with two straight pieces of wood - just represent a number with a distance and align the two pieces so that the distances are sequentially arranged. To multiply then was as easy: represent the logarithm of a number with a distance then add the logarithms. The sum of the logarithms is the logarithm of the *product* of the original two values. Converting back to a number answers the question. The conversion back and forth is done by simply labeling the wood using a logartithmic scale. The slide rule was [invented](http://tinyurl.com/qytxo3e) soon after Napier's initial publication on the logarithm in 1614.
"""

# ╔═╡ 82a43b60-53bf-11ec-3d02-719775e59525
md"""##### Example
"""

# ╔═╡ 82a43b74-53bf-11ec-3cac-e5670aba4291
md"""Returning to the Rule of 72, what should the exact number be?
"""

# ╔═╡ 82a43ba6-53bf-11ec-015b-a588a47892cb
md"""The amount of time to double an investment that grows according to $P_0 e^{rt}$ solves $P_0 e^{rt} = 2P_0$ or $rt = \log_e(2)$. So we get $t=\log_e(2)/r$. As $\log_e(2)$ is
"""

# ╔═╡ 82a45618-53bf-11ec-1cb3-d5801d6e3487
log(e, 2)

# ╔═╡ 82a45654-53bf-11ec-307f-43663b51725d
md"""We get the actual rule should be the "Rule of $69.314...$."
"""

# ╔═╡ 82a4567c-53bf-11ec-273e-7136422d11ab
md"""## Questions
"""

# ╔═╡ 82a456f4-53bf-11ec-3fd1-2fdc1bc58bf7
md"""###### Question
"""

# ╔═╡ 82a4571c-53bf-11ec-2b4a-b9da78f5f3c6
md"""Suppose every $4$ days, a population doubles. If the population starts with $2$ individuals, what is its size after $4$ weeks?
"""

# ╔═╡ 82a46176-53bf-11ec-19d4-25eb192a94f5
let
	n = 4*7/4
	val = 2 * 2^n
	numericq(val)
end

# ╔═╡ 82a46194-53bf-11ec-37b4-3788a42774e9
md"""###### Question
"""

# ╔═╡ 82a46266-53bf-11ec-3059-4f43808e5924
md"""A bouncing ball rebounds to a height of $5/6$ of the previous peak height. If the ball is droppet at a height of $3$ feet, how high will it bounce after $5$ bounces?
"""

# ╔═╡ 82a480b6-53bf-11ec-327d-936e545afd82
let
	val = 3 * (5/6)^5
	numericq(val)
end

# ╔═╡ 82a480e8-53bf-11ec-1623-19808d91a61b
md"""###### Question
"""

# ╔═╡ 82a48112-53bf-11ec-31a0-f73c34fa88a4
md"""Which is bigger $e^2$ or $2^e$?
"""

# ╔═╡ 82a486ba-53bf-11ec-193f-1f7355d4d863
let
	choices = ["``e^2``", "``2^e``"]
	ans = e^2 - 2^e > 0 ? 1 : 2
	radioq(choices, ans)
end

# ╔═╡ 82a486d8-53bf-11ec-2fe1-e9795582d537
md"""###### Question
"""

# ╔═╡ 82a486f6-53bf-11ec-34ce-6dc6829f32c4
md"""Which is bigger $\log_8(9)$ or $\log_9(10)$?
"""

# ╔═╡ 82a48ce6-53bf-11ec-23a4-f75124d0e5cd
let
	choices = [raw"``\log_8(9)``", raw"``\log_9(10)``"]
	ans = log(8,9) > log(9,10) ? 1 : 2
	radioq(choices, ans)
end

# ╔═╡ 82a48d04-53bf-11ec-20c8-1b99e575c703
md"""###### Question
"""

# ╔═╡ 82a48d36-53bf-11ec-1f05-5185f107b56b
md"""If $x$, $y$, and $z$ satisfy $2^x = 3^y$ and $4^y = 5^z$, what is the ratio $x/z$?
"""

# ╔═╡ 82a49506-53bf-11ec-27ad-99e533669dfa
let
	choices = [
	raw"``\frac{\log(2)\log(3)}{\log(5)\log(4)}``",
	raw"``2/5``",
	raw"``\frac{\log(5)\log(4)}{\log(3)\log(2)}``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82a4951a-53bf-11ec-20d0-25bc9c040ccc
md"""###### Question
"""

# ╔═╡ 82a49542-53bf-11ec-140c-a16ac46f40b2
md"""Does $12$ satisfy $\log_2(x) + \log_3(x) = \log_4(x)$?
"""

# ╔═╡ 82a49c7c-53bf-11ec-2463-dd579230951d
let
	ans = log(2,12) + log(3,12) == log(4, 12)
	yesnoq(ans)
end

# ╔═╡ 82a49c9c-53bf-11ec-0389-d9c9ed46fa9f
md"""###### Question
"""

# ╔═╡ 82a49ce0-53bf-11ec-107b-251142288f53
md"""The [Richter](https://en.wikipedia.org/wiki/Richter_magnitude_scale) magnitude is determined from the logarithm of the amplitude of waves recorded by seismographs (Wikipedia). The formula is $M=\log(A) - \log(A_0)$ where $A_0$ depends on the epicenter distance. Suppose an event has $A=100$ and $A_0=1/100$. What is $M$?
"""

# ╔═╡ 82a4a226-53bf-11ec-1ed7-19e6ff239e17
let
	A, A0 = 100, 1/100
	val = M = log(A) - log(A0)
	numericq(val)
end

# ╔═╡ 82a4a24e-53bf-11ec-2a4a-9782ef9c3fe2
md"""If the magnitude of one earthquake is $9$ and the magnitude of another earthquake is $7$, how many times stronger is $A$ if $A_0$ is the same for each?
"""

# ╔═╡ 82aa2700-53bf-11ec-2f16-45a33acdafdc
let
	choices = ["1000 times", "100 times", "10 times", "the same"]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 82aa275a-53bf-11ec-2d55-4dccf4e5de03
md"""###### Question
"""

# ╔═╡ 82aa27dc-53bf-11ec-1ceb-77556d112340
md"""The [Loudest band](https://en.wikipedia.org/wiki/Loudest_band) can possibly be measured in [decibels](https://en.wikipedia.org/wiki/Decibel). In 1976 the Who recorded $126$ db and in 1986 Motorhead recorded $130$ db. Suppose both measurements record power through the formula $db = 10 \log_{10}(P)$. What is the ratio of the Motorhead $P$ to the $P$ for the Who?
"""

# ╔═╡ 82aa4544-53bf-11ec-1e68-cb345afb65a1
let
	db_who, db_motorhead = 126, 130
	db2P(db) = 10^(db/10)
	P_who, P_motorhead = db2P.((db_who, db_motorhead))
	val = P_motorhead / P_who
	numericq(val)
end

# ╔═╡ 82aa4576-53bf-11ec-1be0-b365803820f3
md"""###### Question
"""

# ╔═╡ 82aa4596-53bf-11ec-2437-014096d13772
md"""Based on this graph:
"""

# ╔═╡ 82aa4b22-53bf-11ec-2770-0735c336c687
let
	plot(log, 1/4, 4)
	f(x) = x - 1
	plot!(f, 1/4, 4)
end

# ╔═╡ 82aa4b40-53bf-11ec-340c-43762af1149e
md"""Which statement appears to be true?
"""

# ╔═╡ 82aa51a8-53bf-11ec-2501-994e854c17be
let
	choices = [
	    raw"``x \geq 1 + \log(x)``",
	    raw"``x \leq 1 + \log(x)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa51c6-53bf-11ec-3e9c-c7f9ebd0826d
md"""###### Question
"""

# ╔═╡ 82aa51d0-53bf-11ec-37ee-e7d968e32ca5
md"""Consider this graph:
"""

# ╔═╡ 82aa570c-53bf-11ec-0031-1783fb56a2fa
let
	f(x) = log(1-x)
	g(x) = -x - x^2/2
	plot(f, -3, 3/4)
	plot!(g, -3, 3/4)
end

# ╔═╡ 82aa5728-53bf-11ec-392b-0f0f5cdfbb2d
md"""What statement appears to be true?
"""

# ╔═╡ 82aa5d9e-53bf-11ec-3ebd-15892ed53528
let
	choices = [
	raw"``\log(1-x) \geq -x - x^2/2``",
	raw"``\log(1-x) \leq -x - x^2/2``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa5db0-53bf-11ec-2d89-09e7e8106d26
md"""###### Question
"""

# ╔═╡ 82aa5dec-53bf-11ec-222f-732fd20e569d
md"""Suppose $a > 1$. If $\log_a(x) = y$ what is $\log_{1/a}(x)$? (The reciprocal property of exponents, $a^{-x} = (1/a)^x$, is at play here.)
"""

# ╔═╡ 82aa63fa-53bf-11ec-3181-7f9f14814de8
let
	choices = ["``-y``", "``1/y``", "``-1/y``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa6422-53bf-11ec-3534-2b1cc2b1e628
md"""Based on this, the graph of $\log_{1/a}(x)$ is the graph of $\log_a(x)$ under which transformation?
"""

# ╔═╡ 82aa6bfc-53bf-11ec-2349-63213805efee
let
	choices = [
	L"Flipped over the $x$ axis",
	L"Flipped over the $y$ axis",
	L"Flipped over the line $y=x$"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa6c1a-53bf-11ec-24d9-29c5b63cbc5f
md"""###### Question
"""

# ╔═╡ 82aa6c42-53bf-11ec-2458-91fd6f35df88
md"""Suppose $x < y$. Then for $a > 0$, $a^y - a^x$ is equal to:
"""

# ╔═╡ 82aa7412-53bf-11ec-0564-c59ea1199039
let
	choices = [
	    raw"``a^x \cdot (a^{y-x} - 1)``",
	    raw"``a^{y-x}``",
	    raw"``a^{y-x} \cdot (a^x - 1)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa7430-53bf-11ec-2ffe-9f51a7a01eb8
md"""Using $a > 1$ we have:
"""

# ╔═╡ 82aa7f7a-53bf-11ec-305d-01a1c26cc567
let
	choices = [
	    L"as $a^{y-x} > 1$ and $y-x > 0$, $a^y > a^x$",
	    L"as $a^x  > 1$, $a^y > a^x$",
	    "``a^{y-x} > 0``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 82aa7fac-53bf-11ec-2d35-939a6c3ad41e
md"""If $a < 1$ then:
"""

# ╔═╡ 82aa87fe-53bf-11ec-038d-134300f2d04b
let
	choices = [
	L"as $a^{y-x} < 1$ as $y-x > 0$, $a^y < a^x$",
	L"as $a^x   < 1$, $a^y < a^x$",
	"``a^{y-x} < 0``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 82aa8826-53bf-11ec-33a7-25e42dc9ee73
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/rational_functions.html">◅ previous</a>  <a href="../precalc/trig_functions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/exp_log_functions.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 82aa8830-53bf-11ec-2fe3-5b5f604980db
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

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
# ╟─82aa880a-53bf-11ec-108b-d5ee06e89d33
# ╟─8298ba60-53bf-11ec-20c8-0b3fa54ecb23
# ╟─8298ccd0-53bf-11ec-1413-69bc1b859b96
# ╠═82998210-53bf-11ec-13e0-cf06e9cecf74
# ╟─829986c2-53bf-11ec-3159-37fcbe6977bf
# ╟─82999d2c-53bf-11ec-2b13-0797c1dc6c65
# ╟─82999d86-53bf-11ec-2c9d-433ceed821d2
# ╟─8299b168-53bf-11ec-3c0d-3742ca4db444
# ╟─8299b1fe-53bf-11ec-0669-7b28a51eb058
# ╟─8299b24e-53bf-11ec-08a6-733c9c58bb09
# ╟─8299b328-53bf-11ec-2327-0fef6551234e
# ╟─8299b33e-53bf-11ec-2ad4-73c84f2ea22f
# ╟─8299c9e8-53bf-11ec-204c-95f51a9d234a
# ╟─8299ca5e-53bf-11ec-1684-a56c2ddffc3a
# ╠═829a1432-53bf-11ec-2f72-af41169705d9
# ╟─829a145a-53bf-11ec-0c00-970f27eff566
# ╟─82a164d0-53bf-11ec-3665-252cea266e1d
# ╟─82a17cea-53bf-11ec-2b0b-31bce4c14425
# ╟─82a2a76e-53bf-11ec-2edf-4db4bb93275c
# ╟─82a2a7d4-53bf-11ec-2b2a-cf1d5625125c
# ╠═82a33d28-53bf-11ec-399d-d12134c4213d
# ╟─82a33d78-53bf-11ec-1292-63ad4bdfce37
# ╟─82a33de6-53bf-11ec-1742-63f8481152e8
# ╟─82a33e04-53bf-11ec-10ce-fdb1c640a5f5
# ╠═82a35e66-53bf-11ec-029a-ed7a0835c86c
# ╟─82a35eb6-53bf-11ec-2000-498a22bb7188
# ╟─82a35ed4-53bf-11ec-26bc-e98f547326b0
# ╟─82a35f24-53bf-11ec-0f0a-e3c52c077ad2
# ╟─82a35f4c-53bf-11ec-36c8-83ae35bd0eb3
# ╟─82a35f62-53bf-11ec-13ad-67fdb05545ff
# ╠═82a39412-53bf-11ec-278d-37e6a8bcef67
# ╟─82a39430-53bf-11ec-3667-a7055a04669e
# ╟─82a3944e-53bf-11ec-1857-ab00886a1ee1
# ╟─82a394bc-53bf-11ec-34e2-0b57141cb725
# ╟─82a394ee-53bf-11ec-3b82-113ac3f0174f
# ╟─82a394f8-53bf-11ec-1036-0122999dffb8
# ╟─82a3950e-53bf-11ec-3c74-f3db20128339
# ╟─82a3952a-53bf-11ec-12e4-4b35f75713cf
# ╟─82a39534-53bf-11ec-208f-33b1b7ce64d5
# ╟─82a39548-53bf-11ec-15c4-e11c04c96afb
# ╟─82a39584-53bf-11ec-2b93-4176d0946832
# ╟─82a395b6-53bf-11ec-1f68-bd126d7ef744
# ╟─82a395ca-53bf-11ec-2e68-bdeb1daf93b8
# ╠═82a39994-53bf-11ec-03c4-9d7212437264
# ╟─82a399bc-53bf-11ec-3f70-cb2f08c1456c
# ╟─82a399d0-53bf-11ec-1b71-5f08e0fd5deb
# ╠═82a39d22-53bf-11ec-37d3-ad5524df0c01
# ╟─82a39d54-53bf-11ec-2e85-8d068d2e2a42
# ╟─82a39d86-53bf-11ec-1696-75a4cbaea459
# ╟─82a39dde-53bf-11ec-0d69-e5c78ab29a4e
# ╟─82a39df4-53bf-11ec-3997-a5331bd40df7
# ╟─82a39e12-53bf-11ec-3df3-a9bf620f08ed
# ╟─82a39e4e-53bf-11ec-169c-613fe94fee17
# ╟─82a39e6c-53bf-11ec-3292-c9f5898ea6e8
# ╠═82a3a312-53bf-11ec-18ac-4b0b6bb01db3
# ╟─82a3a33a-53bf-11ec-26d4-8b5ba0aafb7f
# ╟─82a3a37e-53bf-11ec-31b0-bd8036e74165
# ╟─82a3a394-53bf-11ec-22cb-dd4b1285d2bf
# ╟─82a3a3a8-53bf-11ec-1cc4-cf981479013b
# ╟─82a3a3d0-53bf-11ec-1cdf-5badfb84099c
# ╟─82a3a3f8-53bf-11ec-05ce-574797e603d5
# ╠═82a3a68c-53bf-11ec-0330-c7f5346d1ea0
# ╟─82a3a6a0-53bf-11ec-28fa-3f4b55fda188
# ╟─82a3a6c0-53bf-11ec-1023-690c7b7aaaa8
# ╟─82a3a6dc-53bf-11ec-3258-3bf896ccb2a6
# ╟─82a3a6fa-53bf-11ec-0077-3709e18dc7f5
# ╟─82a3a70e-53bf-11ec-311c-1fcf213ae528
# ╠═82a3aaa6-53bf-11ec-396a-37a29b15a4b7
# ╟─82a40468-53bf-11ec-0a4f-457a709a9fca
# ╟─82a404ba-53bf-11ec-020f-19aba2b96d1c
# ╟─82a404e2-53bf-11ec-1384-8bc3c9c49fec
# ╠═82a4229c-53bf-11ec-26ce-5dfacec2939e
# ╟─82a422c2-53bf-11ec-1526-a1bd7b4d1bfe
# ╟─82a422ec-53bf-11ec-2f77-0bea9c3dda80
# ╟─82a4231e-53bf-11ec-348e-5793522704c6
# ╟─82a42350-53bf-11ec-07ea-d7c91ad7ee99
# ╟─82a42366-53bf-11ec-3f77-f9cf3ebc9c24
# ╟─82a42382-53bf-11ec-0b4a-959c7128583e
# ╟─82a4238c-53bf-11ec-16da-9784e4a0715c
# ╟─82a42398-53bf-11ec-0c57-8bb4ab16a1e9
# ╟─82a423aa-53bf-11ec-06f1-0773bb13b939
# ╟─82a423ca-53bf-11ec-0d67-a5fc351dd883
# ╟─82a423dc-53bf-11ec-2e85-e78aaf691bbc
# ╟─82a423e6-53bf-11ec-0305-e16f4ac4d8c6
# ╟─82a423f8-53bf-11ec-08a0-81a85ba76e8d
# ╟─82a42404-53bf-11ec-1217-cd455abb1603
# ╟─82a4240e-53bf-11ec-0075-2b5f8129852d
# ╟─82a4242a-53bf-11ec-132e-6fb92ac64fdb
# ╟─82a42436-53bf-11ec-369b-7dbe24cd16c5
# ╟─82a43ade-53bf-11ec-1072-971012a2e4e4
# ╟─82a43b4a-53bf-11ec-267c-872b5dc5bd8d
# ╟─82a43b60-53bf-11ec-3d02-719775e59525
# ╟─82a43b74-53bf-11ec-3cac-e5670aba4291
# ╟─82a43ba6-53bf-11ec-015b-a588a47892cb
# ╠═82a45618-53bf-11ec-1cb3-d5801d6e3487
# ╟─82a45654-53bf-11ec-307f-43663b51725d
# ╟─82a4567c-53bf-11ec-273e-7136422d11ab
# ╟─82a456f4-53bf-11ec-3fd1-2fdc1bc58bf7
# ╟─82a4571c-53bf-11ec-2b4a-b9da78f5f3c6
# ╟─82a46176-53bf-11ec-19d4-25eb192a94f5
# ╟─82a46194-53bf-11ec-37b4-3788a42774e9
# ╟─82a46266-53bf-11ec-3059-4f43808e5924
# ╟─82a480b6-53bf-11ec-327d-936e545afd82
# ╟─82a480e8-53bf-11ec-1623-19808d91a61b
# ╟─82a48112-53bf-11ec-31a0-f73c34fa88a4
# ╟─82a486ba-53bf-11ec-193f-1f7355d4d863
# ╟─82a486d8-53bf-11ec-2fe1-e9795582d537
# ╟─82a486f6-53bf-11ec-34ce-6dc6829f32c4
# ╟─82a48ce6-53bf-11ec-23a4-f75124d0e5cd
# ╟─82a48d04-53bf-11ec-20c8-1b99e575c703
# ╟─82a48d36-53bf-11ec-1f05-5185f107b56b
# ╟─82a49506-53bf-11ec-27ad-99e533669dfa
# ╟─82a4951a-53bf-11ec-20d0-25bc9c040ccc
# ╟─82a49542-53bf-11ec-140c-a16ac46f40b2
# ╟─82a49c7c-53bf-11ec-2463-dd579230951d
# ╟─82a49c9c-53bf-11ec-0389-d9c9ed46fa9f
# ╟─82a49ce0-53bf-11ec-107b-251142288f53
# ╟─82a4a226-53bf-11ec-1ed7-19e6ff239e17
# ╟─82a4a24e-53bf-11ec-2a4a-9782ef9c3fe2
# ╟─82aa2700-53bf-11ec-2f16-45a33acdafdc
# ╟─82aa275a-53bf-11ec-2d55-4dccf4e5de03
# ╟─82aa27dc-53bf-11ec-1ceb-77556d112340
# ╟─82aa4544-53bf-11ec-1e68-cb345afb65a1
# ╟─82aa4576-53bf-11ec-1be0-b365803820f3
# ╟─82aa4596-53bf-11ec-2437-014096d13772
# ╠═82aa4b22-53bf-11ec-2770-0735c336c687
# ╟─82aa4b40-53bf-11ec-340c-43762af1149e
# ╟─82aa51a8-53bf-11ec-2501-994e854c17be
# ╟─82aa51c6-53bf-11ec-3e9c-c7f9ebd0826d
# ╟─82aa51d0-53bf-11ec-37ee-e7d968e32ca5
# ╠═82aa570c-53bf-11ec-0031-1783fb56a2fa
# ╟─82aa5728-53bf-11ec-392b-0f0f5cdfbb2d
# ╟─82aa5d9e-53bf-11ec-3ebd-15892ed53528
# ╟─82aa5db0-53bf-11ec-2d89-09e7e8106d26
# ╟─82aa5dec-53bf-11ec-222f-732fd20e569d
# ╟─82aa63fa-53bf-11ec-3181-7f9f14814de8
# ╟─82aa6422-53bf-11ec-3534-2b1cc2b1e628
# ╟─82aa6bfc-53bf-11ec-2349-63213805efee
# ╟─82aa6c1a-53bf-11ec-24d9-29c5b63cbc5f
# ╟─82aa6c42-53bf-11ec-2458-91fd6f35df88
# ╟─82aa7412-53bf-11ec-0564-c59ea1199039
# ╟─82aa7430-53bf-11ec-2ffe-9f51a7a01eb8
# ╟─82aa7f7a-53bf-11ec-305d-01a1c26cc567
# ╟─82aa7fac-53bf-11ec-2d35-939a6c3ad41e
# ╟─82aa87fe-53bf-11ec-038d-134300f2d04b
# ╟─82aa8826-53bf-11ec-33a7-25e42dc9ee73
# ╟─82aa8830-53bf-11ec-3023-a303754a96dc
# ╟─82aa8830-53bf-11ec-2fe3-5b5f604980db
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
