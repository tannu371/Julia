### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 68dfaee2-53c1-11ec-2804-ddf049bab1da
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using Plots
	__DIR__, __FILE__ = :precalc, :ranges
	nothing
end

# ╔═╡ 68e0db52-53c1-11ec-1ace-d3462f0ffff7
using Primes

# ╔═╡ 68e3757c-53c1-11ec-2719-45c92294738d
using PlutoUI

# ╔═╡ 68e374c8-53c1-11ec-16c9-e7e2f36c9aa6
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 68df062c-53c1-11ec-23c2-8f4568fdc32e
md"""# Ranges and Sets
"""

# ╔═╡ 68dfaf96-53c1-11ec-2daa-913caa7302c3
md"""Sequences of numbers are prevalent in math. A simple one is just counting by ones:
"""

# ╔═╡ 68dfb00e-53c1-11ec-2eef-e1b368a31663
md"""```math
1, 2, 3, 4, 5, 6, 7, 8, 9, 10, \dots
```
"""

# ╔═╡ 68dfb022-53c1-11ec-2154-593fa9a08c26
md"""Or counting by sevens:
"""

# ╔═╡ 68dfb036-53c1-11ec-3481-4d4a5ac5d45c
md"""```math
7, 14, 21, 28, 35, 42, 49, \dots
```
"""

# ╔═╡ 68dfb0ae-53c1-11ec-09cf-11365f7bfe5b
md"""More challenging for humans is [counting backwards](http://www.psychpage.com/learning/library/assess/mse.htm) by 7:
"""

# ╔═╡ 68dfb0b8-53c1-11ec-3d32-8b412d01ae33
md"""```math
100, 93, 86, 79, \dots
```
"""

# ╔═╡ 68dfb108-53c1-11ec-0d0b-7b4c16ce93b1
md"""These are examples of [arithmetic sequences](http://en.wikipedia.org/wiki/Arithmetic_progression). The form of the first $n+1$ terms in such a sequence is:
"""

# ╔═╡ 68dfb112-53c1-11ec-14e2-c95976b68514
md"""```math
a_0, a_0 + h, a_0 + 2h, a_0 + 3h, \dots, a_0 + nh
```
"""

# ╔═╡ 68dfb13a-53c1-11ec-09e3-29f8838f04f8
md"""The formula for the $a_n$th term can be written in terms of $a_0$, or any other $0 \leq m \leq n$ with $a_n = a_m + (n-m)\cdot h$.
"""

# ╔═╡ 68dfb158-53c1-11ec-0b1c-09aa9decb17d
md"""A typical question might be: The first term of an arithmetic sequence is equal to 200 and the common difference is equal to -10. Find the value of $a_{20}$. We could find this using $a_n = a_0 + n\cdot h$:
"""

# ╔═╡ 68dfd142-53c1-11ec-3f9a-6bc2a767cfae
let
	a0, h, n = 200, -10, 20
	a0 + n * h
end

# ╔═╡ 68dfd1c4-53c1-11ec-2731-8789b0569690
md"""More complicated questions involve an unknown first value, as with: an arithmetic sequence has a common difference equal to 10 and its 6th term is equal to 52. Find its 15th term, $a_{15}$. Here we have to answer: $a_0 + 15 \cdot 10$. Either we could find $a_0$ (using $52 = a_0 + 6\cdot(10)$) or use the above formula
"""

# ╔═╡ 68dfdb1a-53c1-11ec-1335-992b770ce0d4
let
	a6, h, m, n = 52, 10, 6, 15
	a15 = a6 + (n-m)*h
end

# ╔═╡ 68dfdbf6-53c1-11ec-1a83-7db83991200f
md"""Rather than express sequences by the $a_0$, $h$, and $n$, `Julia` uses the starting point (`a`), the difference (`h`) and a *suggested* stopping value (`b`).  That is, we need three values to specify these ranges of numbers: a `start`, a `step`, and an `endof`. `Julia` gives a convenient syntax for this: `a:h:b`. When the difference is just $1$, all numbers between the start and end are specified by `a:b`, as in
"""

# ╔═╡ 68e00b94-53c1-11ec-179c-29364ca522f0
1:10

# ╔═╡ 68e00c34-53c1-11ec-1d5f-35294c34debd
md"""But wait, nothing different printed? This is because `1:10` is efficiently stored. Basically, a recipe to generate the next number from the previous number is created and `1:10` just stores the start and end point and that recipe is used to generate the set of all values. To expand the values, you have to ask for them to be `collect`ed (though this typically isn't needed in practice):
"""

# ╔═╡ 68e01a58-53c1-11ec-1b2b-f111c165fba1
collect(1:10)

# ╔═╡ 68e01ad0-53c1-11ec-309f-1b4c026b786b
md"""When a non-default step size is needed, it goes in the middle, as in `a:h:b`. For example, counting by sevens from 1 to 50 is achieved by:
"""

# ╔═╡ 68e020e8-53c1-11ec-3eee-390d3bf3f508
collect(1:7:50)

# ╔═╡ 68e0219c-53c1-11ec-2062-6b1630721a36
md"""Or counting down from 100:
"""

# ╔═╡ 68e026d8-53c1-11ec-1cd2-89c6f7a21eaf
collect(100:-7:1)

# ╔═╡ 68e02734-53c1-11ec-0ed9-d310686f6025
md"""In this last example, we said end with 1, but it ended with 2. The ending value in the range is a suggestion to go up to, but not exceed. Negative values for `h`  are used to make decreasing sequences.
"""

# ╔═╡ 68e027dc-53c1-11ec-14b5-938c5aa444cd
md"""### The range function
"""

# ╔═╡ 68e02840-53c1-11ec-3012-6d4a758dffbd
md"""For generating points to make graphs, a natural set of points to specify is $n$ evenly spaced points between $a$ and $b$. We can mimic creating this set with the range operation by solving for the correct step size. We have $a_0=a$ and $a_0 + (n-1) \cdot h = b$. (Why $n-1$ and not $n$?) Solving yields $h = (b-a)/(n-1)$. To be concrete we might ask for 9 points between $-1$ and $1$:
"""

# ╔═╡ 68e0309c-53c1-11ec-3067-9995a1e2a395
let
	a, b, n = -1, 1, 9
	h = (b-a)/(n-1)
	collect(a:h:b)
end

# ╔═╡ 68e030c4-53c1-11ec-3611-71a972ce7bf2
md"""Pretty neat. If we were doing this many times - such as once per plot - we'd want to encapsulate this into a function, for example:
"""

# ╔═╡ 68e05bbc-53c1-11ec-0c58-03815060964f
function evenly_spaced(a, b, n)
    h = (b-a)/(n-1)
    collect(a:h:b)
end

# ╔═╡ 68e05bf8-53c1-11ec-1e07-b935c8204d21
md"""Great, let's try it out:
"""

# ╔═╡ 68e05f72-53c1-11ec-06ac-7bac83f105ee
evenly_spaced(0, 2pi, 5)

# ╔═╡ 68e05f86-53c1-11ec-0307-a13cf317c634
md"""Now, our implementation was straightforward, but only because it avoids somethings. Look at  something simple:
"""

# ╔═╡ 68e06576-53c1-11ec-10d8-55f8f1b88925
evenly_spaced(1/5, 3/5, 3)

# ╔═╡ 68e0659e-53c1-11ec-02c9-8b00032ee8e0
md"""It seems to work as expected. But looking just at the algorithm it isn't quite so clear:
"""

# ╔═╡ 68e09c08-53c1-11ec-00ee-d380af5133d3
1/5, 1/5 + 1*1/5, 1/5 + 2*1/5

# ╔═╡ 68e09d02-53c1-11ec-3f40-1df97b948faa
md"""Floating point roundoff leads to the last value *exceeding* `0.6`, so should it be included? Well, here it is pretty clear it *should* be, but better to have something programmed that hits both `a` and `b` and adjusts `h` accordingly.
"""

# ╔═╡ 68e09d20-53c1-11ec-3707-3f3d1e3ad45f
md"""Enter the base function `range` which solves this seemingly simple - but not really - task. It can use `a`, `b`, and `n`. Like the range operation, this function returns a generator which can be collected to realize the values.
"""

# ╔═╡ 68e09d36-53c1-11ec-3979-db9901849eb3
md"""The number of points is specified with keyword arguments, as in:
"""

# ╔═╡ 68e0a3e2-53c1-11ec-13c7-259eb7f70480
xs = range(-1, 1, length=9)

# ╔═╡ 68e0a3f6-53c1-11ec-02e4-3da2b9136fe2
md"""and
"""

# ╔═╡ 68e0a626-53c1-11ec-2f37-11c54c0ad192
collect(xs)

# ╔═╡ 68e0b058-53c1-11ec-3010-7ff307c71e7f
note("""
There is also the `LinRange(a,b,n)` function which can be more performant than `range`, as it doesn't try to correct for floating point errors.
""")

# ╔═╡ 68e0b0da-53c1-11ec-3b22-abba3a4d5685
md"""## Filtering and modifying arithmetic progressions
"""

# ╔═╡ 68e0b0f8-53c1-11ec-32d6-cba94afefc64
md"""Now we concentrate on some more general styles to modify a sequence to produce a new sequence.
"""

# ╔═╡ 68e0b146-53c1-11ec-164d-ad143241957d
md"""For example, another way to get the values between 0 and 100 that are multiples of 7 is to start with all 101 values and throw out those that don't match. To check if a number is divisible by $7$, we could use the `rem` function. It gives the remainder upon division. Multiples of `7` match `rem(m, 7) == 0`. Checking for divisibility by seven is unusual enough there is nothing built in for that, but checking for division by $2$ is common, and for that, there is a built-in function `iseven`.
"""

# ╔═╡ 68e0b184-53c1-11ec-1904-653b3b8ae892
md"""The act of throwing out elements of a collection based on some condition is called *filtering*. The `filter` function does this in `Julia`; the basic syntax being `filter(predicate_function, collection)`. The "`predicate_function`" is one that returns either `true` or `false`, such as `iseven`. The output of `filter` consists of the new collection of values - those where the predicate returns `true`.
"""

# ╔═╡ 68e0b1a2-53c1-11ec-0512-ef7a8681f528
md"""To see it used, lets start with the numbers between `0` and `25` (inclusive) and filter out those that are even:
"""

# ╔═╡ 68e0d02e-53c1-11ec-2b51-a5ad2e5e8148
filter(iseven, 0:25)

# ╔═╡ 68e0d0a4-53c1-11ec-1267-eb2bc3a51d20
md"""To get the numbers between 1 and 100 that are divisible by $7$ requires us to write a function akin to `iseven`, which isn't hard (e.g., `is_seven(x)=x%7==0`), but isn't something we continue with just yet.
"""

# ╔═╡ 68e0d150-53c1-11ec-327f-b37f144074fd
md"""For another example, here is an inefficient way to list the prime numbers between 100 and 200. This uses the `isprime` function from the `Primes` package
"""

# ╔═╡ 68e0f3c4-53c1-11ec-047f-ad8f3e68d5f3
filter(isprime, 100:200)

# ╔═╡ 68e0f428-53c1-11ec-2c13-b72e9b26dcf4
md"""Illustrating `filter` at this point is mainly a motivation to illustrate that we can start with a regular set of numbers and then modify or filter them. The function takes on more value once we discuss how to write predicate functions.
"""

# ╔═╡ 68e0f450-53c1-11ec-09cf-a32b064a9aa6
md"""## Comprehensions
"""

# ╔═╡ 68e0f46c-53c1-11ec-0fb5-ab24a4a04393
md"""Let's return to the case of the set of even numbers between 0 and 100. We have many ways to describe this set:
"""

# ╔═╡ 68e0f9b4-53c1-11ec-3ac8-f722c3bfb585
md"""  * The collection of numbers $0, 2, 4, 6 \dots, 100$, or the arithmetic sequence with step size 2, which is returned by `0:2:100`.
  * The numbers between 0 and 100 that are even, that is `filter(iseven, 0:100)`.
  * The set of numbers $\{2k: k=0, \dots, 50\}$.
"""

# ╔═╡ 68e0fa2c-53c1-11ec-1a0a-2dcaa25c1610
md"""While `Julia` has a special type for dealing with sets, we will use a vector for such a set. (Unlike a set, vectors can have repeated values, but as vectors are more widely used, we demonstrate them.) Vectors are described more fully in a previous section, but as a reminder, vectors are constructed using square brackets: `[]` (a special syntax for [concatenation](http://docs.julialang.org/en/latest/manual/arrays/#concatenation)). Square brackets are used in different contexts within `Julia`, in this case we use them to create a *collection*. If we separate single values in our collection by commas (or semicolons), we will create a vector:
"""

# ╔═╡ 68e11f2a-53c1-11ec-2b44-abbca3f135dc
x = [0, 2, 4, 6, 8, 10]

# ╔═╡ 68e1200e-53c1-11ec-10ab-15a3dc92c66c
md"""That is of course only part of the set of even numbers we want. Creating more might be tedious were we to type them all out, as above. In such cases, it is best to *generate* the values.
"""

# ╔═╡ 68e120ba-53c1-11ec-32c7-8f987d8983c1
md"""For this simple case, a range can be used, but more generally a [comprehension](http://julia.readthedocs.org/en/latest/manual/arrays/#comprehensions) provides this ability using a construct that closely mirrors  a set definition, such as $\{2k: k=0, \dots, 50\}$. The simplest use of a comprehension takes this form (as we described in the section on vectors):
"""

# ╔═╡ 68e120e4-53c1-11ec-1238-4db013c826ea
md"""`[expr for variable in collection]`
"""

# ╔═╡ 68e12128-53c1-11ec-212f-21cbd90e5426
md"""The expression typically involves the variable specified after the keyword `for`. The collection can be a range, a vector, or many other items that are *iterable*. Here is how the mathematical set $\{2k: k=0, \dots, 50\}$ may be generated by a comprehension:
"""

# ╔═╡ 68e12894-53c1-11ec-20f0-2b7f2b0cdd0c
[2k for k in 0:50]

# ╔═╡ 68e128e4-53c1-11ec-3f21-d178d2f04e47
md"""The expression is `2k`, the variable `k`, and the collection is the range of values, `0:50`. The syntax is basically identical to how the math expression is typically read aloud.
"""

# ╔═╡ 68e12902-53c1-11ec-2f66-6f4502e8b8c8
md"""For some other examples, here is how we can create the first 10 numbers divisible by 7:
"""

# ╔═╡ 68e136a4-53c1-11ec-2bf3-fd8b87281b8b
[7k for k in 1:10]

# ╔═╡ 68e136e0-53c1-11ec-0b28-5d1b32f6dccb
md"""Here is how we can square the numbers between 1 and 10:
"""

# ╔═╡ 68e13e36-53c1-11ec-1048-499a1bceb729
[x^2 for x in 1:10]

# ╔═╡ 68e13e60-53c1-11ec-05ca-fd02eb527a15
md"""To generate other progressions, such as powers of 2, we could do:
"""

# ╔═╡ 68e14428-53c1-11ec-0aba-81e167d63cfc
[2^i for i in 1:10]

# ╔═╡ 68e14450-53c1-11ec-0c1d-8df718c6edbd
md"""Here are decreasing powers of 2:
"""

# ╔═╡ 68e17812-53c1-11ec-1c22-0f3d9d289f37
[1/2^i for i in 1:10]

# ╔═╡ 68e178a8-53c1-11ec-38f8-77f9d80d9da5
md"""Sometimes, the comprehension does not produce the type of output that may be expected. This is related to `Julia`'s more limited abilities to infer types at the command line. If the output type is important, the extra prefix of `T[]` can be used, where `T` is the desired type. We will see that this will be needed at times with symbolic math.
"""

# ╔═╡ 68e178d0-53c1-11ec-1a52-1b503a476a9b
md"""## Generators
"""

# ╔═╡ 68e178f8-53c1-11ec-1940-c51265d55b2b
md"""A typical pattern would be to generate a collection of numbers and then apply a function to them. For example, here is one way to sum the powers of `2`:
"""

# ╔═╡ 68e18956-53c1-11ec-06c7-9b58e65b9a28
sum([2^i for i in 1:10])

# ╔═╡ 68e18abe-53c1-11ec-04fc-e1060e47c4d9
md"""Conceptually this is easy to understand, but computationally it is a bit inefficient. The generator syntax allows this type of task to be done more efficiently. To use this syntax, we just need to drop the `[]`:
"""

# ╔═╡ 68e195a4-53c1-11ec-3c8a-5f9118fb2420
sum(2^i for i in 1:10)

# ╔═╡ 68e1961c-53c1-11ec-2d18-7760036d8238
md"""(The difference being no intermediate object is created to store the collection of all values specified by the generator.)
"""

# ╔═╡ 68e19766-53c1-11ec-2b7e-d94a9202535d
md"""### Filtering generated expressions - the "if" keyword in a generator
"""

# ╔═╡ 68e1984e-53c1-11ec-0774-b34b3bf40add
md"""Both comprehensions and generators allow for filtering through the keyword `if`. The following shows *one* way to add the prime numbers in $[1,100]$:
"""

# ╔═╡ 68e1a11e-53c1-11ec-0dfe-7fc4382f8f1a
sum(p for p in 1:100 if isprime(p))

# ╔═╡ 68e1a17a-53c1-11ec-2b32-959be3f47ca9
md"""The value on the other side of `if` should be an expression that evaluates to either `true` or `false` for a given `p` (like a predicate function, but here specified as an expression). The value returned by `isprime(p)` is such.
"""

# ╔═╡ 68e1a1ca-53c1-11ec-1766-5b0f5311066f
md"""In this example, we use the fact that `rem(k, 7)` returns the remainder found from dividing `k` by `7`, and so is `0` when `k` is a multiple of `7`:
"""

# ╔═╡ 68e1b108-53c1-11ec-0088-816baa7c3c75
sum(k for k in 1:100 if rem(k,7) == 0)  ## add multiples of 7

# ╔═╡ 68e1b174-53c1-11ec-2386-d3d5c1415d80
md"""The same `if` can be used in a comprehension. For example, this is an alternative to `filter` for identifying the numbers divisble by `7` in a range of numbers:
"""

# ╔═╡ 68e1c1b6-53c1-11ec-096f-aff909dcba0b
[k for k in 1:100 if rem(k,7) == 0]

# ╔═╡ 68e1c2cc-53c1-11ec-3653-29c70d58358d
md"""#### Example: Making change
"""

# ╔═╡ 68e1c34c-53c1-11ec-3543-a767934e738f
md"""This example of Stefan Karpinski comes from a [blog](http://julialang.org/blog/2016/10/julia-0.5-highlights) post highlighting changes to the `Julia` language with version `v"0.5.0"`, which added features to comprehensions that made this example possible.
"""

# ╔═╡ 68e1c3a8-53c1-11ec-3b60-edbda4e1832f
md"""First, a simple question: using pennies, nickels, dimes, and quarters how many different ways can we generate one dollar? Clearly $100$ pennies, or $20$ nickels, or $10$ dimes, or $4$ quarters will do this, so the answer is at least four, but how much more than four?
"""

# ╔═╡ 68e1c3c6-53c1-11ec-1a47-a5e42248938f
md"""Well, we can use a comprehension to enumerate the possibilities. This example illustrates how comprehensions and generators can involve one or more variable for the iteration.
"""

# ╔═╡ 68e1c422-53c1-11ec-0eaf-85ec2df41304
md"""First, we either have $0,1,2,3$, or $4$ quarters, or $0$, $25$ cents, $50$ cents, $75$ cents, or a dollar's worth. If we have, say, $1$ quarter, then we need to make up $75$ cents with the rest. If we had $3$ dimes, then we need to make up $45$ cents out of nickels and pennies, if we then had $6$ nickels, we know we must need $15$ pennies.
"""

# ╔═╡ 68e1c470-53c1-11ec-2b8b-25c67a781b6b
md"""The following expression shows how counting this can be done through enumeration. Here `q` is the amount contributed by quarters, `d` the amount from dimes, `n` the amount from nickels, and `p` the amount from pennies. `q` ranges over $0, 25, 50, 75, 100$ or `0:25:100`, etc. If we know that the sum of quarters, dimes, nickels contributes a certain amount, then the number of pennies must round things up to $100$.
"""

# ╔═╡ 68e1f12a-53c1-11ec-051f-efe21541520b
begin
	ways = [(q, d, n, p) for q = 0:25:100 for d = 0:10:(100 - q) for n = 0:5:(100 - q - d) for p = (100 - q - d - n)]
	length(ways)
end

# ╔═╡ 68e1f190-53c1-11ec-23ae-f34e8ebebf24
md"""We see 242 cases, each distinct. The first $3$ are:
"""

# ╔═╡ 68e20016-53c1-11ec-2946-79d1e38760f3
ways[1:3]

# ╔═╡ 68e2008e-53c1-11ec-3095-a1bbe8cc6db3
md"""The generating expression reads naturally. It introduces the use of multiple `for` statements, each subsequent one depending on the value of the previous (working left to right). Now suppose, we want to ensure that the amount in pennies is less than the amount in nickels, etc. We could use `filter` somehow to do this for our last answer, but using `if` allows for filtering while the events are generating. Here our condition is simply expressed: `q > d > n > p`:
"""

# ╔═╡ 68e211fa-53c1-11ec-2b4d-8f8e3180a59d
[(q, d, n, p) for q = 0:25:100 for d = 0:10:(100 - q) for n = 0:5:(100 - q - d) for p = (100 - q - d - n) if q > d > n > p]

# ╔═╡ 68e21236-53c1-11ec-3607-9d29746e74eb
md"""## Random numbers
"""

# ╔═╡ 68e2129a-53c1-11ec-1147-3df141646215
md"""We have been discussing structured sets of numbers. On the opposite end of the spectrum are random numbers. `Julia` makes them easy to generate, especially random numbers chosen uniformly from $[0,1)$.
"""

# ╔═╡ 68e2143e-53c1-11ec-278c-21842cdbf8c1
md"""  * The `rand()` function returns a randomly chosen number in $[0,1)$.
  * The `rand(n)` function returns a vector of `n` randomly chosen numbers in $[0,1)$.
"""

# ╔═╡ 68e2145c-53c1-11ec-3330-d151b0e07baa
md"""To illustrate, this will command return a single number
"""

# ╔═╡ 68e21f38-53c1-11ec-3450-07cb957c494d
rand()

# ╔═╡ 68e21f74-53c1-11ec-0416-1382d9457616
md"""If the command is run again, it is almost certain that a different value will be returned:
"""

# ╔═╡ 68e22208-53c1-11ec-03da-0b2782e04aac
rand()

# ╔═╡ 68e2223a-53c1-11ec-3380-0378b1a03f73
md"""This call will return a vector of 10 such random numbers:
"""

# ╔═╡ 68e224ec-53c1-11ec-2b47-e5a6a225efd8
rand(10)

# ╔═╡ 68e225fa-53c1-11ec-1665-a351e5be8635
md"""The `rand` function is easy to use. The only common source of confusion is the subtle distinction between `rand()` and `rand(1)`, as the latter is a vector of 1 random number and the former just 1 random number.
"""

# ╔═╡ 68e22618-53c1-11ec-1b55-07baf1c28fc5
md"""## Questions
"""

# ╔═╡ 68e226a4-53c1-11ec-18a9-c7a40735a53f
md"""###### Question
"""

# ╔═╡ 68e226b8-53c1-11ec-2069-4dd09ab95eeb
md"""Which of these will produce the odd numbers between 1 and 99?
"""

# ╔═╡ 68e23cf4-53c1-11ec-15e9-756e086fbd53
let
	choices = [
	q"1:99",
	q"1:3:99",
	q"1:2:99"
	]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 68e23d2e-53c1-11ec-1ae2-4fb457e5c965
md"""###### Question
"""

# ╔═╡ 68e23d7e-53c1-11ec-20ef-c5d61e86d1fc
md"""Which of these will create the sequence $2, 9, 16, 23, \dots, 72$?
"""

# ╔═╡ 68e24894-53c1-11ec-293a-8f12e570fa1f
let
	choices = [q"2:7:72", q"2:9:72", q"2:72", q"72:-7:2"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 68e248d2-53c1-11ec-06be-1befd0831755
md"""###### Question
"""

# ╔═╡ 68e24918-53c1-11ec-28b3-89bbc1644e98
md"""How many numbers are in the sequence produced by `0:19:1000`?
"""

# ╔═╡ 68e253f4-53c1-11ec-0fea-51ece9c431cd
let
	val = length(collect(0:19:1000))
	numericq(val)
end

# ╔═╡ 68e25426-53c1-11ec-1670-f5f09ff57401
md"""###### Question
"""

# ╔═╡ 68e2546c-53c1-11ec-0611-9f38c19a544a
md"""The range operation (`a:h:b`) can also be used to countdown. Which of these will do so, counting down from `10` to `1`? (You can call `collect` to visualize the generated numbers.)
"""

# ╔═╡ 68e26d80-53c1-11ec-206f-79616942fb1a
let
	choices = [
	"`10:-1:1`",
	"`10:1`",
	"`1:-1:10`",
	"`1:10`"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 68e26dbc-53c1-11ec-28e3-3b6e796aeecc
md"""###### Question
"""

# ╔═╡ 68e26df8-53c1-11ec-3995-679be02daead
md"""What is the last number generated by `1:4:7`?
"""

# ╔═╡ 68e28626-53c1-11ec-2ddc-59d3797fc119
let
	val = (1:4:7)[end]
	numericq(val)
end

# ╔═╡ 68e2866c-53c1-11ec-08c3-bd9710abbed1
md"""###### Question
"""

# ╔═╡ 68e28694-53c1-11ec-28b8-374a52ee8a14
md"""While the range operation can generate vectors by collecting, do the objects themselves act like vectors?
"""

# ╔═╡ 68e2870c-53c1-11ec-290a-9b1d8f295751
md"""Does scalar multiplication work as expected? In particular, is the result of `2*(1:5)` *basically* the same as `2 * [1,2,3,4,5]`?
"""

# ╔═╡ 68e28b12-53c1-11ec-358a-13b3ee2afe48
let
	yesnoq(true)
end

# ╔═╡ 68e28b6c-53c1-11ec-1478-d7b26d77598c
md"""Does vector addition work? as expected? In particular, is the result of `(1:4) + (2:5)` *basically* the same as `[1,2,3,4]` + `[2,3,4,5]`?
"""

# ╔═╡ 68e28e00-53c1-11ec-05de-3d2f140d5d9c
let
	yesnoq(true)
end

# ╔═╡ 68e28e46-53c1-11ec-39c4-bf44c3f1f541
md"""What if parenthese are left off? Explain the output of `1:4 + 2:5`?
"""

# ╔═╡ 68e2a00a-53c1-11ec-227a-79a56b36d20d
let
	choices = ["It is just random",
	"Addition happens prior to the use of `:` so this is like `1:(4+2):5`",
	"It gives the correct answer, a generator for the vector `[3,5,7,9]`"
	]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 68e2a03c-53c1-11ec-0b84-eb004728867c
md"""###### Question
"""

# ╔═╡ 68e2a06e-53c1-11ec-2653-3d03b0d7fa84
md"""How is `a:b-1` interpreted:
"""

# ╔═╡ 68e2b236-53c1-11ec-36bb-b51f535229ca
let
	choices = ["as `a:(b-1)`", "as `(a:b) - 1`, which is `(a-1):(b-1)`"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 68e2b27c-53c1-11ec-0412-21504191f66d
md"""###### Question
"""

# ╔═╡ 68e2b380-53c1-11ec-047d-1bc0df2f538f
md"""Create the sequence $10, 100, 1000, \dots, 1,000,000$ using a list comprehension. Which of these works?
"""

# ╔═╡ 68e2ce88-53c1-11ec-0647-852f5a38f3e9
let
	choices = [q"[10^i for i in 1:6]", q"[10^i for i in [10, 100, 1000]]", q"[i^10 for i in [1:6]]"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 68e2cece-53c1-11ec-2358-4161b86a4a97
md"""###### Question
"""

# ╔═╡ 68e2cf28-53c1-11ec-21d0-c3a049406423
md"""Create the sequence $0.1, 0.01, 0.001, \dots, 0.0000001$ using a list comprehension. Which of these will work:
"""

# ╔═╡ 68e2dbe4-53c1-11ec-3e40-017c2a61ff50
let
	choices = [
	q"[10^-i for i in 1:7]",
	q"[(1/10)^i for i in 1:7]",
	q"[i^(1/10) for i in 1:7]"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 68e2dc5e-53c1-11ec-3909-c3fdd5234c52
md"""###### Question
"""

# ╔═╡ 68e2dcbe-53c1-11ec-2f82-f19f663c9067
md"""Evaluate the expression $x^3 - 2x + 3$ for each of the values $-5, -4, \dots, 4, 5$ using a comprehension. Which of these will work?
"""

# ╔═╡ 68e2ebac-53c1-11ec-2ba0-a9c7d64a2eb8
let
	choices = [q"[x^3 - 2x + 3 for i in -5:5]", q"[x^3 - 2x + 3 for x in -(5:5)]", q"[x^3 - 2x + 3 for x in -5:5]"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 68e2ebe8-53c1-11ec-29d4-1d4aaae65410
md"""###### Question
"""

# ╔═╡ 68e2ec4c-53c1-11ec-2709-8dd6b4d9f688
md"""How many prime numbers are there between $1100$ and $1200$? (Use `filter` and `isprime`)
"""

# ╔═╡ 68e2fee4-53c1-11ec-0083-c9694f392821
let
	val = length(filter(isprime, 1100:1200))
	numericq(val)
end

# ╔═╡ 68e2ff2a-53c1-11ec-0041-077f7509717a
md"""###### Question
"""

# ╔═╡ 68e2ff84-53c1-11ec-192b-6d28f1a50d0d
md"""Which has more prime numbers  the range `1000:2000` or the range `11000:12000`?
"""

# ╔═╡ 68e325a4-53c1-11ec-37ec-29635097e2db
let
	n1 = length(filter(isprime, 1000:2000))
	n2 = length(filter(isprime, 11_000:12_000))
	booleanq(n1 > n2, labels=[q"1000:2000", q"11000:12000"])
end

# ╔═╡ 68e325ea-53c1-11ec-0a9a-7192f505818a
md"""###### Question
"""

# ╔═╡ 68e3264e-53c1-11ec-18dd-93c29afc1bba
md"""We can easily add an arithmetic progression with the `sum` function. For example, `sum(1:100)` will add the numbers $1, 2, ..., 100$.
"""

# ╔═╡ 68e3266c-53c1-11ec-3e51-df7b06beea6b
md"""What is the sum of the odd numbers between $0$ and $100$?
"""

# ╔═╡ 68e32fa4-53c1-11ec-1dc8-851ecb4eed20
let
	val = sum(1:2:99)
	numericq(val)
end

# ╔═╡ 68e32fd6-53c1-11ec-04c7-5d7329c0c400
md"""###### Question
"""

# ╔═╡ 68e33008-53c1-11ec-09ef-5956eadf76ef
md"""The sum of the arithmetic progression $a, a+h, \dots, a+n\cdot h$ has a simple formula. Using a few cases, can you tell if this is the correct one:
"""

# ╔═╡ 68e33058-53c1-11ec-1550-5dde5b5480b6
md"""```math
(n+1)\cdot a + h \cdot n(n+1)/2
```
"""

# ╔═╡ 68e33918-53c1-11ec-06e9-99232b5ea335
let
	booleanq(true, labels=["Yes, this is true", "No, this is false"])
end

# ╔═╡ 68e33942-53c1-11ec-2461-1bd9c0db2244
md"""###### Question
"""

# ╔═╡ 68e339f4-53c1-11ec-2a8b-79a527387b0b
md"""A *geometric progression* is of the form $a^0, a^1, a^2, \dots, a^n$. These are easily generated by comprehensions of the form `[a^i for i in 0:n]`. Find the sum of the geometric progression $1, 2^1, 2^2, \dots, 2^{10}$.
"""

# ╔═╡ 68e34232-53c1-11ec-0820-1b3bf0e469dd
let
	as = [2^i for i in 0:10]
	val = sum(as)
	numericq(val)
end

# ╔═╡ 68e34278-53c1-11ec-1a43-073197d83585
md"""Is your answer of the form $(1 - a^{n+1}) / (1-a)$?
"""

# ╔═╡ 68e34d36-53c1-11ec-3f4a-b7476da9b6f1
let
	yesnoq(true)
end

# ╔═╡ 68e34d72-53c1-11ec-16b1-7f42baeb465c
md"""###### Question
"""

# ╔═╡ 68e34dfe-53c1-11ec-12e5-53f6f9928328
md"""The [product](http://en.wikipedia.org/wiki/Arithmetic_progression) of the terms in an arithmetic progression has a known formula.  The product can be found by an expression of the form `prod(a:h:b)`.  Find the product of the terms in the sequence $1,3,5,\dots,19$.
"""

# ╔═╡ 68e374a0-53c1-11ec-3557-9f55743e1c4f
let
	val = prod(1:2:19)
	numericq(val)
end

# ╔═╡ 68e37568-53c1-11ec-2369-672431f850ad
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/vectors.html">◅ previous</a>  <a href="../precalc/functions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/ranges.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 68e3757c-53c1-11ec-3b46-17f1696abfe3
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Primes = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
Primes = "~0.5.0"
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

[[deps.Primes]]
git-tree-sha1 = "afccf037da52fa596223e5a0e331ff752e0e845c"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.0"

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
# ╟─68e374c8-53c1-11ec-16c9-e7e2f36c9aa6
# ╟─68df062c-53c1-11ec-23c2-8f4568fdc32e
# ╟─68dfaee2-53c1-11ec-2804-ddf049bab1da
# ╟─68dfaf96-53c1-11ec-2daa-913caa7302c3
# ╟─68dfb00e-53c1-11ec-2eef-e1b368a31663
# ╟─68dfb022-53c1-11ec-2154-593fa9a08c26
# ╟─68dfb036-53c1-11ec-3481-4d4a5ac5d45c
# ╟─68dfb0ae-53c1-11ec-09cf-11365f7bfe5b
# ╟─68dfb0b8-53c1-11ec-3d32-8b412d01ae33
# ╟─68dfb108-53c1-11ec-0d0b-7b4c16ce93b1
# ╟─68dfb112-53c1-11ec-14e2-c95976b68514
# ╟─68dfb13a-53c1-11ec-09e3-29f8838f04f8
# ╟─68dfb158-53c1-11ec-0b1c-09aa9decb17d
# ╠═68dfd142-53c1-11ec-3f9a-6bc2a767cfae
# ╟─68dfd1c4-53c1-11ec-2731-8789b0569690
# ╠═68dfdb1a-53c1-11ec-1335-992b770ce0d4
# ╟─68dfdbf6-53c1-11ec-1a83-7db83991200f
# ╠═68e00b94-53c1-11ec-179c-29364ca522f0
# ╟─68e00c34-53c1-11ec-1d5f-35294c34debd
# ╠═68e01a58-53c1-11ec-1b2b-f111c165fba1
# ╟─68e01ad0-53c1-11ec-309f-1b4c026b786b
# ╠═68e020e8-53c1-11ec-3eee-390d3bf3f508
# ╟─68e0219c-53c1-11ec-2062-6b1630721a36
# ╠═68e026d8-53c1-11ec-1cd2-89c6f7a21eaf
# ╟─68e02734-53c1-11ec-0ed9-d310686f6025
# ╟─68e027dc-53c1-11ec-14b5-938c5aa444cd
# ╟─68e02840-53c1-11ec-3012-6d4a758dffbd
# ╠═68e0309c-53c1-11ec-3067-9995a1e2a395
# ╟─68e030c4-53c1-11ec-3611-71a972ce7bf2
# ╠═68e05bbc-53c1-11ec-0c58-03815060964f
# ╟─68e05bf8-53c1-11ec-1e07-b935c8204d21
# ╠═68e05f72-53c1-11ec-06ac-7bac83f105ee
# ╟─68e05f86-53c1-11ec-0307-a13cf317c634
# ╠═68e06576-53c1-11ec-10d8-55f8f1b88925
# ╟─68e0659e-53c1-11ec-02c9-8b00032ee8e0
# ╠═68e09c08-53c1-11ec-00ee-d380af5133d3
# ╟─68e09d02-53c1-11ec-3f40-1df97b948faa
# ╟─68e09d20-53c1-11ec-3707-3f3d1e3ad45f
# ╟─68e09d36-53c1-11ec-3979-db9901849eb3
# ╠═68e0a3e2-53c1-11ec-13c7-259eb7f70480
# ╟─68e0a3f6-53c1-11ec-02e4-3da2b9136fe2
# ╠═68e0a626-53c1-11ec-2f37-11c54c0ad192
# ╟─68e0b058-53c1-11ec-3010-7ff307c71e7f
# ╟─68e0b0da-53c1-11ec-3b22-abba3a4d5685
# ╟─68e0b0f8-53c1-11ec-32d6-cba94afefc64
# ╟─68e0b146-53c1-11ec-164d-ad143241957d
# ╟─68e0b184-53c1-11ec-1904-653b3b8ae892
# ╟─68e0b1a2-53c1-11ec-0512-ef7a8681f528
# ╠═68e0d02e-53c1-11ec-2b51-a5ad2e5e8148
# ╟─68e0d0a4-53c1-11ec-1267-eb2bc3a51d20
# ╟─68e0d150-53c1-11ec-327f-b37f144074fd
# ╠═68e0db52-53c1-11ec-1ace-d3462f0ffff7
# ╠═68e0f3c4-53c1-11ec-047f-ad8f3e68d5f3
# ╟─68e0f428-53c1-11ec-2c13-b72e9b26dcf4
# ╟─68e0f450-53c1-11ec-09cf-a32b064a9aa6
# ╟─68e0f46c-53c1-11ec-0fb5-ab24a4a04393
# ╟─68e0f9b4-53c1-11ec-3ac8-f722c3bfb585
# ╟─68e0fa2c-53c1-11ec-1a0a-2dcaa25c1610
# ╠═68e11f2a-53c1-11ec-2b44-abbca3f135dc
# ╟─68e1200e-53c1-11ec-10ab-15a3dc92c66c
# ╟─68e120ba-53c1-11ec-32c7-8f987d8983c1
# ╟─68e120e4-53c1-11ec-1238-4db013c826ea
# ╟─68e12128-53c1-11ec-212f-21cbd90e5426
# ╠═68e12894-53c1-11ec-20f0-2b7f2b0cdd0c
# ╟─68e128e4-53c1-11ec-3f21-d178d2f04e47
# ╟─68e12902-53c1-11ec-2f66-6f4502e8b8c8
# ╠═68e136a4-53c1-11ec-2bf3-fd8b87281b8b
# ╟─68e136e0-53c1-11ec-0b28-5d1b32f6dccb
# ╠═68e13e36-53c1-11ec-1048-499a1bceb729
# ╟─68e13e60-53c1-11ec-05ca-fd02eb527a15
# ╠═68e14428-53c1-11ec-0aba-81e167d63cfc
# ╟─68e14450-53c1-11ec-0c1d-8df718c6edbd
# ╠═68e17812-53c1-11ec-1c22-0f3d9d289f37
# ╟─68e178a8-53c1-11ec-38f8-77f9d80d9da5
# ╟─68e178d0-53c1-11ec-1a52-1b503a476a9b
# ╟─68e178f8-53c1-11ec-1940-c51265d55b2b
# ╠═68e18956-53c1-11ec-06c7-9b58e65b9a28
# ╟─68e18abe-53c1-11ec-04fc-e1060e47c4d9
# ╠═68e195a4-53c1-11ec-3c8a-5f9118fb2420
# ╟─68e1961c-53c1-11ec-2d18-7760036d8238
# ╟─68e19766-53c1-11ec-2b7e-d94a9202535d
# ╟─68e1984e-53c1-11ec-0774-b34b3bf40add
# ╠═68e1a11e-53c1-11ec-0dfe-7fc4382f8f1a
# ╟─68e1a17a-53c1-11ec-2b32-959be3f47ca9
# ╟─68e1a1ca-53c1-11ec-1766-5b0f5311066f
# ╠═68e1b108-53c1-11ec-0088-816baa7c3c75
# ╟─68e1b174-53c1-11ec-2386-d3d5c1415d80
# ╠═68e1c1b6-53c1-11ec-096f-aff909dcba0b
# ╟─68e1c2cc-53c1-11ec-3653-29c70d58358d
# ╟─68e1c34c-53c1-11ec-3543-a767934e738f
# ╟─68e1c3a8-53c1-11ec-3b60-edbda4e1832f
# ╟─68e1c3c6-53c1-11ec-1a47-a5e42248938f
# ╟─68e1c422-53c1-11ec-0eaf-85ec2df41304
# ╟─68e1c470-53c1-11ec-2b8b-25c67a781b6b
# ╠═68e1f12a-53c1-11ec-051f-efe21541520b
# ╟─68e1f190-53c1-11ec-23ae-f34e8ebebf24
# ╠═68e20016-53c1-11ec-2946-79d1e38760f3
# ╟─68e2008e-53c1-11ec-3095-a1bbe8cc6db3
# ╠═68e211fa-53c1-11ec-2b4d-8f8e3180a59d
# ╟─68e21236-53c1-11ec-3607-9d29746e74eb
# ╟─68e2129a-53c1-11ec-1147-3df141646215
# ╟─68e2143e-53c1-11ec-278c-21842cdbf8c1
# ╟─68e2145c-53c1-11ec-3330-d151b0e07baa
# ╠═68e21f38-53c1-11ec-3450-07cb957c494d
# ╟─68e21f74-53c1-11ec-0416-1382d9457616
# ╠═68e22208-53c1-11ec-03da-0b2782e04aac
# ╟─68e2223a-53c1-11ec-3380-0378b1a03f73
# ╠═68e224ec-53c1-11ec-2b47-e5a6a225efd8
# ╟─68e225fa-53c1-11ec-1665-a351e5be8635
# ╟─68e22618-53c1-11ec-1b55-07baf1c28fc5
# ╟─68e226a4-53c1-11ec-18a9-c7a40735a53f
# ╟─68e226b8-53c1-11ec-2069-4dd09ab95eeb
# ╟─68e23cf4-53c1-11ec-15e9-756e086fbd53
# ╟─68e23d2e-53c1-11ec-1ae2-4fb457e5c965
# ╟─68e23d7e-53c1-11ec-20ef-c5d61e86d1fc
# ╟─68e24894-53c1-11ec-293a-8f12e570fa1f
# ╟─68e248d2-53c1-11ec-06be-1befd0831755
# ╟─68e24918-53c1-11ec-28b3-89bbc1644e98
# ╟─68e253f4-53c1-11ec-0fea-51ece9c431cd
# ╟─68e25426-53c1-11ec-1670-f5f09ff57401
# ╟─68e2546c-53c1-11ec-0611-9f38c19a544a
# ╟─68e26d80-53c1-11ec-206f-79616942fb1a
# ╟─68e26dbc-53c1-11ec-28e3-3b6e796aeecc
# ╟─68e26df8-53c1-11ec-3995-679be02daead
# ╟─68e28626-53c1-11ec-2ddc-59d3797fc119
# ╟─68e2866c-53c1-11ec-08c3-bd9710abbed1
# ╟─68e28694-53c1-11ec-28b8-374a52ee8a14
# ╟─68e2870c-53c1-11ec-290a-9b1d8f295751
# ╟─68e28b12-53c1-11ec-358a-13b3ee2afe48
# ╟─68e28b6c-53c1-11ec-1478-d7b26d77598c
# ╟─68e28e00-53c1-11ec-05de-3d2f140d5d9c
# ╟─68e28e46-53c1-11ec-39c4-bf44c3f1f541
# ╟─68e2a00a-53c1-11ec-227a-79a56b36d20d
# ╟─68e2a03c-53c1-11ec-0b84-eb004728867c
# ╟─68e2a06e-53c1-11ec-2653-3d03b0d7fa84
# ╟─68e2b236-53c1-11ec-36bb-b51f535229ca
# ╟─68e2b27c-53c1-11ec-0412-21504191f66d
# ╟─68e2b380-53c1-11ec-047d-1bc0df2f538f
# ╟─68e2ce88-53c1-11ec-0647-852f5a38f3e9
# ╟─68e2cece-53c1-11ec-2358-4161b86a4a97
# ╟─68e2cf28-53c1-11ec-21d0-c3a049406423
# ╟─68e2dbe4-53c1-11ec-3e40-017c2a61ff50
# ╟─68e2dc5e-53c1-11ec-3909-c3fdd5234c52
# ╟─68e2dcbe-53c1-11ec-2f82-f19f663c9067
# ╟─68e2ebac-53c1-11ec-2ba0-a9c7d64a2eb8
# ╟─68e2ebe8-53c1-11ec-29d4-1d4aaae65410
# ╟─68e2ec4c-53c1-11ec-2709-8dd6b4d9f688
# ╟─68e2fee4-53c1-11ec-0083-c9694f392821
# ╟─68e2ff2a-53c1-11ec-0041-077f7509717a
# ╟─68e2ff84-53c1-11ec-192b-6d28f1a50d0d
# ╟─68e325a4-53c1-11ec-37ec-29635097e2db
# ╟─68e325ea-53c1-11ec-0a9a-7192f505818a
# ╟─68e3264e-53c1-11ec-18dd-93c29afc1bba
# ╟─68e3266c-53c1-11ec-3e51-df7b06beea6b
# ╟─68e32fa4-53c1-11ec-1dc8-851ecb4eed20
# ╟─68e32fd6-53c1-11ec-04c7-5d7329c0c400
# ╟─68e33008-53c1-11ec-09ef-5956eadf76ef
# ╟─68e33058-53c1-11ec-1550-5dde5b5480b6
# ╟─68e33918-53c1-11ec-06e9-99232b5ea335
# ╟─68e33942-53c1-11ec-2461-1bd9c0db2244
# ╟─68e339f4-53c1-11ec-2a8b-79a527387b0b
# ╟─68e34232-53c1-11ec-0820-1b3bf0e469dd
# ╟─68e34278-53c1-11ec-1a43-073197d83585
# ╟─68e34d36-53c1-11ec-3f4a-b7476da9b6f1
# ╟─68e34d72-53c1-11ec-16b1-7f42baeb465c
# ╟─68e34dfe-53c1-11ec-12e5-53f6f9928328
# ╟─68e374a0-53c1-11ec-3557-9f55743e1c4f
# ╟─68e37568-53c1-11ec-2369-672431f850ad
# ╟─68e3757c-53c1-11ec-2719-45c92294738d
# ╟─68e3757c-53c1-11ec-3b46-17f1696abfe3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
