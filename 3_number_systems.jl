### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 333820ea-53c0-11ec-3976-093afeca11ea
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	using Plots
	__DIR__, __FILE__ = :precalc, :numbers_types
	nothing
end

# ╔═╡ 333d551a-53c0-11ec-0898-57ea00d4f5f1
begin
	using DataFrames
	attributes = ["construction", "exact", "wide range", "has infinity", "has `-0`", "fast", "closed under"]
	integer = [q"1", "true", "false", "false", "false", "true", "`+`, `-`, `*`, `^` (non-negative exponent)"]
	rational = ["`1//1`", "true", "false", "false", "false", "false", "`+`, `-`, `*`, `/` (non zero denominator),`^` (integer power)"]
	float = [q"1.0", "not usually", "true", "true", "true", "true", "`+`, `-`, `*`, `/` (possibly `NaN`, `Inf`),`^` (non-negative base)"]
	d = DataFrame(Attributes=attributes, Integer=integer, Rational=rational, FloatingPoint=float)
	table(d)
end

# ╔═╡ 333e0f96-53c0-11ec-1638-933d6dbb107e
using PlutoUI

# ╔═╡ 333e0f78-53c0-11ec-0eae-65a921a92e52
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 33377eb8-53c0-11ec-3bc7-59d25268d431
md"""# Number systems
"""

# ╔═╡ 33382180-53c0-11ec-27d5-e107241cf24a
md"""In mathematics, there are many different number systems in common use. For example by the end of pre-calculus, all of the following have been introduced:
"""

# ╔═╡ 3338266c-53c0-11ec-1cab-a7c068c39c92
md"""  * The integers, $\{\dots, -3, -2, -1, 0, 1, 2, 3, \dots\}$;
  * The rational numbers, $\{p/q: p, q  \text{ are integers}, q \neq 0\}$;
  * The real numbers, $\{x: -\infty < x < \infty\}$;
  * The complex numbers, $\{a + bi: a,b \text{ are real numbers and } i^2=-1\}$.
"""

# ╔═╡ 333826a0-53c0-11ec-1c8e-13eef3be15d7
md"""On top of these, we have special subsets, such as the natural numbers $\{0, 1, 2, \dots\}$, the even numbers, the odd numbers, positive numbers, non-negative numbers, etc.
"""

# ╔═╡ 333826b2-53c0-11ec-1426-c7f42c94121f
md"""Mathematically, these number systems are naturally nested within each other as integers are rational numbers which are real numbers, which can be viewed as part of the complex numbers.
"""

# ╔═╡ 33382732-53c0-11ec-3b30-0f33f5126c69
md"""Calculators typically have just one type of number - floating point values. These model the real numbers. `Julia`, on other other hand, has a rich type system, and within that has many different number types. There are types that model each of the four main systems above, and within each type, specializations for how these values are stored.
"""

# ╔═╡ 33382748-53c0-11ec-3d58-b7e16ee5a23c
md"""Most of the details will not be of interest to all, and will be described later.
"""

# ╔═╡ 333827c0-53c0-11ec-3dac-959e95ed4403
md"""For now, let's consider the number 1. It can be viewed as either an integer, rational, real, or complex number. To construct "1" in each type within `Julia` we have these different styles:
"""

# ╔═╡ 3338c7ca-53c0-11ec-226f-f7ac67cc0405
1, 1.0, 1//1, 1 + 0im

# ╔═╡ 3338c8f6-53c0-11ec-2fd2-7991a3521995
md"""The basic number types in `Julia` are `Int`, `Float64`, `Rational` and `Complex`, though in fact there are many more, and the last two aren't even *concrete* types. This distinction is important, as the type of number dictates how it will be stored and how precisely the stored value can be expected to be  to the mathematical value it models.
"""

# ╔═╡ 3338c914-53c0-11ec-3a17-19f9dfc03df9
md"""Though there are explicit constructors for these types, these notes avoid them unless necessary, as `Julia`'s parser can distinguish these types through an easy to understand syntax:
"""

# ╔═╡ 3338cc2a-53c0-11ec-2ab7-a77a177a3fdc
md"""  * integers have no decimal point;
  * floating point numbers have a decimal point (or are in scientific notation);
  * rationals are constructed from integers using the double division operator, `//`; and
  * complex numbers are formed by including a term with the imaginary unit, `im`.
"""

# ╔═╡ 3338e1e2-53c0-11ec-1421-01dc3ed7c164
alert("""
Heads up, the difference between `1` and `1.0` is subtle.
Even more so, as `1.` will parse as `1.0`.
This means some expressions, such as `2.*3`, are ambigous, as the `.` might be part of the `2` (as in `2. * 3`) or the operation `*` (as in `2 .* 3`).
""")

# ╔═╡ 3338e21e-53c0-11ec-33b4-7f2895f16bb1
md"""Similarly, each type is printed slightly differently.
"""

# ╔═╡ 3338e25a-53c0-11ec-2921-0524d174409e
md"""The key distinction is between integers and floating points. While floating point values include integers, and so can be used exclusively on the calculator, the difference is that an integer is guaranteed to be an exact value, whereas a floating point value, while often an exact representation of a number is also often just an *approximate* value. This can be an advantage – floating point values can model a much wider range of numbers.
"""

# ╔═╡ 3338e26e-53c0-11ec-0d3b-d7ed6e10f03d
md"""Now in nearly all cases, the differences are not noticed. Take for instance this simple calculation involving mixed types.
"""

# ╔═╡ 33390b04-53c0-11ec-32a8-d96a50397029
1 + 1.25 + 3//2

# ╔═╡ 33390b36-53c0-11ec-280a-1d74152b98c1
md"""The sum of an integer, a floating point number and rational number returns a floating point number without a complaint.
"""

# ╔═╡ 33390be0-53c0-11ec-25a3-ed45fbd961dd
md"""This is  because behind the scenes, `Julia` will often "promote" a type to match, so for example to compute `1 + 1.25` the integer `1` will be promoted to a floating point value and the two values are then added. Similarly, with `2.25 + 3//2`, where the fraction is promoted to the floating point value `1.5` and addition is carried out.
"""

# ╔═╡ 33390bf4-53c0-11ec-29f4-a908bc1b98e9
md"""As floating point numbers may be  approximations, some values are not quite what they would be mathematically:
"""

# ╔═╡ 33394362-53c0-11ec-044c-d3f6be55fae1
sqrt(2) * sqrt(2) - 2, sin(pi), 1/10 + 1/5 - 3/10

# ╔═╡ 33394418-53c0-11ec-0888-8f779ee92722
md"""These values are *very* small numbers, but not exactly $0$, as they are mathematically.
"""

# ╔═╡ 33395faa-53c0-11ec-119a-41290793e291
md"""---
"""

# ╔═╡ 3339609a-53c0-11ec-1045-6b8afbe571dd
md"""The only  common issue is with powers. `Julia` tries to keep a predictable output from the input types (not their values). Here are the two main cases that arise where this can cause unexpected results:
"""

# ╔═╡ 333961d0-53c0-11ec-3fc5-e788144bf443
md"""  * integer bases and integer exponents can *easily* overflow. Not only `m^n` is always an integer, it is always an integer with a fixed storage size computed from the sizes of `m` and `n`. So the powers can quickly get too big. This can be especially noticeable on older $32$-bit machines, where too big is $2^{32} = 4,294,967,296$. On $64$-bit machines, this limit is present but much bigger.
"""

# ╔═╡ 333961f8-53c0-11ec-30bf-47c3ad4ad420
md"""Rather than give an error though, `Julia` gives seemingly arbitrary answers, as can be seen in this example on a $64$-bit machine:
"""

# ╔═╡ 3339774c-53c0-11ec-19fe-93a0786d160d
2^62, 2^63

# ╔═╡ 3339777e-53c0-11ec-0824-1d46562ec91b
md"""(They aren't arbitrary, rather integer arithmetic is implemented as modular arithmetic.)
"""

# ╔═╡ 33397792-53c0-11ec-382a-27914f73f68f
md"""This could be worked around, as it is with some programming languages, but it isn't, as it would slow down this basic computation. So, it is up to the user to be aware of cases where their integer values can grow to big. The suggestion is to use floating point numbers in this domain, as they have more room, at the cost of sometimes being approximate values.
"""

# ╔═╡ 333978a0-53c0-11ec-0dcb-83eecb41d5d6
md"""  * the `sqrt` function will give a domain error for negative values:
"""

# ╔═╡ 333992cc-53c0-11ec-0f24-d711f5fd5cd9
sqrt(-1.0)

# ╔═╡ 33399310-53c0-11ec-27d5-fd5c51451bdd
md"""This is because for real-valued inputs `Julia` expects to return a real-valued output. Of course, this is true in mathematics until the complex numbers are introduced. Similarly in `Julia` - to take square roots of negative numbers, start with complex numbers:
"""

# ╔═╡ 3339b07c-53c0-11ec-0c2f-9d8cee03ff22
sqrt(-1.0 + 0im)

# ╔═╡ 3339b162-53c0-11ec-0a69-b350df3b95d5
md"""  * At one point, `Julia` had an issue with a third type of power:
"""

# ╔═╡ 3339b1aa-53c0-11ec-0bfa-71b1cf0077a9
md"""integer bases and negative integer exponents. For example `2^(-1)`. This is now special cased, though only for numeric literals. If `z=-1`, `2^z` will throw a `DomainError`.  Historically, the desire to keep a predictable type for the output (integer) led to defining this case as a domain error, but its usefulness led to special casing.
"""

# ╔═╡ 3339b46e-53c0-11ec-1fec-41dd09f1448f
md"""## Some more details.
"""

# ╔═╡ 3339b4a0-53c0-11ec-2752-7b0db5da4914
md"""What follows is only needed for those seeking more background.
"""

# ╔═╡ 3339b4e6-53c0-11ec-2949-bbf9d6363a3d
md"""Julia has *abstract* number types `Integer`, `Real`, and `Number`. All four types described above are of type `Number`, but `Complex` is not of type `Real`.
"""

# ╔═╡ 3339b52c-53c0-11ec-112e-b9c5336ed37b
md"""However, a specific value is an instance of a *concrete* type. A concrete type will also include information about how the value is stored. For example, the *integer* `1` could be stored using $64$ bits as a signed integers, or, should storage be a concern, as an $8$ bits signed or even unsigned integer, etc.. If storage isn't an issue, but exactness at all scales is, then it can be stored in a manner that allows for the storage to grow using "big" numbers.
"""

# ╔═╡ 3339b53e-53c0-11ec-0554-69d4d835d727
md"""These distinctions can be seen in how `Julia` parses these three values:
"""

# ╔═╡ 3339b614-53c0-11ec-1f62-dd48218b5619
md"""  * `1234567890` will be a $64$-bit integer (on newer machines), `Int64`
  * `12345678901234567890` will be a $128$ bit integer, `Int128`
  * `1234567890123456789012345678901234567890` will be a big integer, `BigInt`
"""

# ╔═╡ 3339b626-53c0-11ec-36c3-876bd01079a1
md"""Having abstract types allows programmers to write functions that will work over a wide range of input values that are similar, but have different implementation details.
"""

# ╔═╡ 3339b694-53c0-11ec-19dd-174a7f12bfc1
md"""### Integers
"""

# ╔═╡ 3339b73e-53c0-11ec-16b6-6ddb1ade14b1
md"""Integers are often used casually, as they come about from parsing. As with a calculator, floating point numbers *could* be used for integers, but in `Julia` - and other languages - it proves useful to have numbers known to have *exact* values. In `Julia` there are built-in number types for integers stored in $8$, $16$, $32$, $64$, and $128$ bits and `BigInt`s if the previous aren't large enough. ($8$ bits can hold $8$ binary values representing $1$ of $256=2^8$ possibilities, whereas the larger $128$ bit can hold one of $2^{128}$ possibilities.) Smaller values can be more efficiently used, and this is leveraged at the system level, but not a necessary distinction with calculus where the default size along with an occasional usage of `BigInt` suffice.
"""

# ╔═╡ 3339b752-53c0-11ec-0c1e-b57b754b2886
md"""### Floating point numbers
"""

# ╔═╡ 3339b81a-53c0-11ec-09b6-a1ce18b78c46
md"""[Floating point](http://en.wikipedia.org/wiki/Floating_point) numbers are a computational model for the real numbers.  For floating point numbers, $64$ bits are used by default for both $32$- and $64$-bit systems, though other storage sizes can be requested. This gives a large ranging - but still finite - set of real numbers that can be represented. However, there are infinitely many real numbers just between $0$ and $1$, so there is no chance that all can be represented exactly on the computer with a floating point value. Floating point then is *necessarily* an approximation for all but a subset of the real numbers. Floating point values can be viewed in normalized [scientific notation](http://en.wikipedia.org/wiki/Scientific_notation) as $a\cdot 2^b$ where $a$ is the *significand* and $b$ is the *exponent*. Save for special values, the significand $a$ is normalized to satisfy $1 \leq \lvert a\rvert < 2$, the exponent can be taken to be an integer, possibly negative.
"""

# ╔═╡ 3339b842-53c0-11ec-1ae7-13137db274f1
md"""As per IEEE Standard 754, the `Float64` type gives 52 bits to the precision (with an additional implied one), 11 bits to the exponent and the other bit is used to represent the sign.  Positive, finite, floating point numbers have a range approximately between $10^{-308}$ and $10^{308}$, as 308 is about $\log_{10}\cdot 2^{1023}$. The numbers are not evenly spread out over this range, but, rather, are much more concentrated closer to $0$.
"""

# ╔═╡ 333ab9fc-53c0-11ec-234b-95dbef7b15f2
alert("""
You can discover more about the range of floating point values provided by calling a few different functions.

- `typemax(0.0)` gives the largest value for the type (`Inf` in this case).

- `prevfloat(Inf)` gives the largest finite one, in general `prevfloat` is the next smallest floating point value.

- `nextfloat(-Inf)`, similarly,  gives the smallest finite floating point value, and in general returns the next largest floating point value.

- `nextfloat(0.0)` gives the closest positive value to 0.

- `eps()`  gives the distance to the next floating point number bigger than `1.0`. This is sometimes referred to as machine precision.

""", title="More on floating point", label="More on the range of floating point values")

# ╔═╡ 333ad2fe-53c0-11ec-1c16-eb0a92261805
md"""#### Scientific notation
"""

# ╔═╡ 333ad376-53c0-11ec-106e-df178054adeb
md"""Floating point numbers may print in a familiar manner:
"""

# ╔═╡ 333ad7cc-53c0-11ec-0e82-f9d9535b944e
x = 1.23

# ╔═╡ 333ad808-53c0-11ec-2ef7-67b6c292b5ae
md"""or may be represented in scientific notation:
"""

# ╔═╡ 333b07ec-53c0-11ec-1938-9b76654cf29f
6.23 * 10.0^23

# ╔═╡ 333b088c-53c0-11ec-1851-8107ec14d6c5
md"""The special coding `aeb` (or if the exponent is negative `ae-b`) is used to represent the number $a \cdot 10^b$ ($1 \leq a < 10$). This notation can be used directly to specify a floating point value:
"""

# ╔═╡ 333b0c24-53c0-11ec-1010-0969e3165b66
avagadro = 6.23e23

# ╔═╡ 333b0c88-53c0-11ec-3ebe-93f2ce54a6ec
md"""Here `e` is decidedly *not* the Euler number, rather syntax to separate the exponent from the mantissa.
"""

# ╔═╡ 333b0cba-53c0-11ec-2f09-4372eb152457
md"""The first way of representing this number required using `10.0` and not `10` as the integer power will return an integer and even for 64-bit systems is only valid up to `10^18`. Using scientific notation avoids having to concentrate on such limitations.
"""

# ╔═╡ 333b0d0c-53c0-11ec-2f68-01b473c8c562
md"""##### Example
"""

# ╔═╡ 333b0d82-53c0-11ec-2d1b-3d515ce5b679
md"""Floating point values in scientific notation will always be normalized. This is easy for the computer to do, but tedious to do by hand. Here we see:
"""

# ╔═╡ 333b13e2-53c0-11ec-3870-bbdb09d27c3c
4e30 * 3e40

# ╔═╡ 333b314a-53c0-11ec-387b-ad0b8da3e512
3e40 / 4e30

# ╔═╡ 333b31d8-53c0-11ec-3987-b3218ce91068
md"""The power in the first is 71, not 70 = 30+40, as the product of 3 and 4 as 12 or `1.2e^1`. (We also see the artifact of `1.2` not being exactly representable in floating point.)
"""

# ╔═╡ 333b31fe-53c0-11ec-21b4-f37ae27a1e8b
md"""##### Example: 32-bit floating point
"""

# ╔═╡ 333b3230-53c0-11ec-1cf0-e30ff5f017d8
md"""In some uses, such as using a GPU, 32-bit floating point (single precision) is also common. These values may be specified with an `f` in place of the `e` in scientific notation:
"""

# ╔═╡ 333b4e14-53c0-11ec-04db-37c5d7d705c0
1.23f0

# ╔═╡ 333b4eb4-53c0-11ec-09fa-c52080bcc7bb
md"""As with the use of `e`, some exponent is needed after the `f`, even if it is `0`.
"""

# ╔═╡ 333b4edc-53c0-11ec-3e12-b98eb505ccf1
md"""#### Special values: Inf, -Inf, NaN
"""

# ╔═╡ 333b4f68-53c0-11ec-37c5-9d12bd361bb9
md"""The coding of floating point numbers also allows for the special values of `Inf`, `-Inf` to represent positive and negative infinity. As well, a special value `NaN` ("not a number") is used to represent a value that arises when an operation is not closed (e.g., $0.0/0.0$ yields `NaN`). (Technically `NaN` has several possible "values," a point ignored here.) Except for negative bases, the floating point numbers with the addition of `Inf` and `NaN` are closed under the operations `+`, `-`, `*`, `/`, and `^`. Here are some computations that produce `NaN`:
"""

# ╔═╡ 333b7a74-53c0-11ec-0ede-615586809670
0/0, Inf/Inf, Inf - Inf, 0 * Inf

# ╔═╡ 333b7ad8-53c0-11ec-05c6-0f62cfe1e37b
md"""Whereas, these produce an infinity
"""

# ╔═╡ 333b815e-53c0-11ec-0101-35b8d5e72d20
1/0, Inf + Inf, 1 * Inf

# ╔═╡ 333b81cc-53c0-11ec-2e8a-6b664ceaf674
md"""Finally, these are mathematically undefined, but still yield a finite value with `Julia`:
"""

# ╔═╡ 333b8604-53c0-11ec-3d40-db02e2f4fd78
0^0, Inf^0

# ╔═╡ 333b863e-53c0-11ec-187b-c780945696a3
md"""#### Floating point numbers and real numbers
"""

# ╔═╡ 333b86c2-53c0-11ec-15f0-458fe71f748a
md"""Floating point numbers are an abstraction for the real numbers. For the most part this abstraction works in the background, though there are cases where one needs to have it in mind. Here are a few:
"""

# ╔═╡ 333b8898-53c0-11ec-0dc4-21a62a868916
md"""  * For real and rational numbers, between any two numbers $a < b$, there is another real number in between. This is not so for floating point numbers which have a finite precision. (Julia has some functions for working with this distinction.)
  * Floating point numbers are approximations for most values, even simple rational ones like $1/3$. This leads to oddities such as this value not being $0$:
"""

# ╔═╡ 333ba7a8-53c0-11ec-14a5-911341703faf
sqrt(2)*sqrt(2) - 2

# ╔═╡ 333ba878-53c0-11ec-3dba-a38006a3d788
md"""It is no surprise that an irrational number, like $\sqrt{2}$, can't be represented **exactly** within floating point, but it is perhaps surprising that simple numbers can not be, so $1/3$, $1/5$, $\dots$ are approximated. Here is a surprising-at-first consequence:
"""

# ╔═╡ 333bb084-53c0-11ec-21d9-2392623add9e
1/10 + 2/10 == 3/10

# ╔═╡ 333bb0fc-53c0-11ec-1ec3-7b309a5bb49e
md"""That is adding `1/10` and `2/10` is not exactly `3/10`, as expected mathematically. Such differences are usually very small and are generally attributed to rounding error. The user needs to be mindful when testing for equality, as is done above with the `==` operator.
"""

# ╔═╡ 333bb264-53c0-11ec-3a71-1f68aa131f1d
md"""  * Floating point addition is not necessarily associative, that is the property $a + (b+c) = (a+b) + c$ may not hold exactly. For example:
"""

# ╔═╡ 333bf9d6-53c0-11ec-19ed-ff459b99981b
1/10 + (2/10 + 3/10) == (1/10 + 2/10) + 3/10

# ╔═╡ 333bfec2-53c0-11ec-306e-9f1fb270da1e
md"""  * For real numbers subtraction of similar-sized numbers is not exceptional, for example $1 - \cos(x)$ is positive if $0 < x < \pi/2$, say. This will not be the case for floating point values. If $x$ is close enough to $0$, then $\cos(x)$ and $1$ will be so close, that they will be represented by the same floating point value, `1.0`, so the difference will be zero:
"""

# ╔═╡ 333c04a8-53c0-11ec-2bfd-89d5e6d4db8c
1.0 - cos(1e-8)

# ╔═╡ 333c050c-53c0-11ec-2e7d-c9da9d6e691e
md"""### Rational numbers
"""

# ╔═╡ 333c05ca-53c0-11ec-2419-53fae619a7d0
md"""Rational numbers can be used when the exactness of the number is more important than the speed or wider range of values offered by floating point numbers. In `Julia` a rational number is comprised of a numerator and a denominator, each an integer of the same type, and reduced to lowest terms. The operations of addition, subtraction, multiplication, and division will keep their answers as rational numbers. As well, raising a rational number to a positive, integer value will produce a rational number.
"""

# ╔═╡ 333c05e6-53c0-11ec-2600-336b1bad41b5
md"""As mentioned, these are constructed using double slashes:
"""

# ╔═╡ 333c2a64-53c0-11ec-3d35-4f80335c33f9
1//2, 2//1, 6//4

# ╔═╡ 333c2ab2-53c0-11ec-1e33-a1b8bc337d2e
md"""Rational numbers are exact, so the following are identical to their mathematical counterparts:
"""

# ╔═╡ 333c4e90-53c0-11ec-3cf9-f9072115c463
1//10 + 2//10 == 3//10

# ╔═╡ 333c4ed6-53c0-11ec-0212-8161616e34b2
md"""and associativity:
"""

# ╔═╡ 333c8f74-53c0-11ec-30f9-876cd3526bea
(1//10 + 2//10) + 3//10 == 1//10 + (2//10 + 3//10)

# ╔═╡ 333c8fae-53c0-11ec-18d2-633f3c7db7a2
md"""Here we see that the type is preserved under the basic  operations:
"""

# ╔═╡ 333cb524-53c0-11ec-1df7-f32bfa8fdfed
(1//2 + 1//3 * 1//4 / 1//5) ^ 6

# ╔═╡ 333cb560-53c0-11ec-3e60-19d81feea127
md"""For powers, a non-integer exponent is converted to floating point, so this operation is defined, though will always return a floating point value:
"""

# ╔═╡ 333cf8b8-53c0-11ec-0ae3-e92464d5618a
(1//2)^(1//2)   # the first parentheses are necessary as `^` will be evaluated before `//`.

# ╔═╡ 333cf8fe-53c0-11ec-1d8c-ad78d8db44e6
md"""##### Example: different types of real numbers
"""

# ╔═╡ 333cf926-53c0-11ec-32b4-493b8d6f0d09
md"""This table shows what attributes are implemented for the different types.
"""

# ╔═╡ 333d55b0-53c0-11ec-1d7d-a7b08e2ef682
md"""## Complex numbers
"""

# ╔═╡ 333d565a-53c0-11ec-35dd-b58b9eedd159
md"""Complex numbers in `Julia` are stored as two numbers, a real and imaginary part, each some type of `Real` number. The special constant `im` is used to represent $i=\sqrt{-1}$.  This makes the construction of complex numbers fairly standard:
"""

# ╔═╡ 333d5d8a-53c0-11ec-3050-b5c4f15944c9
1 + 2im, 3 + 4.0im

# ╔═╡ 333d5dee-53c0-11ec-1cc6-01bd67f88fce
md"""(These two aren't exactly the same, the `3` is promoted from an integer to a float to match the `4.0`. Each of the components must be of the same type of number.)
"""

# ╔═╡ 333d5e52-53c0-11ec-3590-33dbc3454f2e
md"""Mathematically, complex numbers are needed so that certain equations can be satisfied. For example $x^2 = -2$ has solutions $-\sqrt{2}i$ and $\sqrt{2}i$ over the complex numbers. Finding this in `Julia` requires some attention, as we have both `sqrt(-2)` and `sqrt(-2.0)` throwing a `DomainError`, as the `sqrt` function expects non-negative real arguments. However first creating a complex number does work:
"""

# ╔═╡ 333d630c-53c0-11ec-3195-333c1e849885
sqrt(-2 + 0im)

# ╔═╡ 333d6350-53c0-11ec-3899-a56c37ac9809
md"""For complex arguments, the `sqrt` function will return complex values (even if the answer is a real number).
"""

# ╔═╡ 333d6370-53c0-11ec-319a-35a311165b7a
md"""This means, if you wanted to perform the quadratic equation for any real inputs, your computations might involve something like the following:
"""

# ╔═╡ 333d80a8-53c0-11ec-1bbd-f38267cd049e
begin
	a,b,c = 1,2,3  ## x^2 + 2x + 3
	discr = b^2 - 4a*c
	(-b + sqrt(discr + 0im))/(2a), (-b - sqrt(discr + 0im))/(2a)
end

# ╔═╡ 333d80ee-53c0-11ec-2fef-dbda931e2642
md"""When learning calculus, the only common usage of complex numbers arises when solving polynomial equations for roots, or zeros, though they are very important for subsequent work using the concepts of calculus.
"""

# ╔═╡ 333d92e6-53c0-11ec-3afa-49d69c92315e
note("""
Though complex numbers are stored as pairs of numbers, the imaginary unit, `im`, is of type `Complex{Bool}`, a type that can be promoted to more specific types when `im` is used with different number types.
""")

# ╔═╡ 333d9322-53c0-11ec-3033-dbfe95e5daa8
md"""## Type stability
"""

# ╔═╡ 333d937c-53c0-11ec-233f-698a4fec4c17
md"""One design priority of `Julia` is that it should be fast. How can `Julia` do this? In a simple model, `Julia` is an interface between the user and the computer's processor(s). Processors consume a set of instructions, the user issues a set of commands. `Julia` is in charge of the translation between the two. Ultimately `Julia` calls a compiler to create the instructions. A basic premise is the shorter the instructions, the faster they are to process. Shorter instructions can come about by being more explicit about what types of values the instructions concern. Explicitness means, there is no need to reason about what a value can be. When `Julia` can reason about the type of value involved without having to reason about the values themselves, it can work with the compiler to produce shorter lists of instructions.
"""

# ╔═╡ 333d93b8-53c0-11ec-0a34-bd02e9c8d0e9
md"""So knowing the type of the output of a function based only on the type of the inputs can be a big advantage. In `Julia` this is known as *type stability*. In the standard `Julia` library, this is a primary design consideration.
"""

# ╔═╡ 333d93d6-53c0-11ec-353a-d5577f84da72
md"""##### Example: closure
"""

# ╔═╡ 333d9408-53c0-11ec-1864-299a6cc293cf
md"""To motivate this a bit, we discuss how mathematics can be shaped by a desire to stick to simple ideas.  A desirable algebraic property of a set of numbers and an operation is *closure*.  That is, if one takes an operation like `+` and then uses it to add two numbers in a set, will that result also be in the set? If this is so for any pair of numbers, then the set is closed with respect to the operation addition.
"""

# ╔═╡ 333d9458-53c0-11ec-1c48-bf1f09a9ec6a
md"""Lets suppose we start with the *natural numbers*: $1,2, \dots$. Natural, in that we can easily represent small values in terms of fingers. This set is closed under addition - as a child learns when counting using their fingers. However, if we started with the odd natural numbers, this set would *not* be closed under addition - $3+3=6$.
"""

# ╔═╡ 333d9476-53c0-11ec-22e6-9368fd9198ad
md"""The natural numbers are not all the numbers we need, as once a desire for subtraction is included, we find the set isn't closed. There isn't a $0$, needed as $n-n=0$ and there aren't negative numbers. The set of integers are needed for closure under addition and subtraction.
"""

# ╔═╡ 333d948a-53c0-11ec-165e-67334b7c9843
md"""The integers are also closed under multiplication, which for integer values can be seen as just regrouping into longer additions.
"""

# ╔═╡ 333d94a8-53c0-11ec-0931-6fb0a9956867
md"""However, the integers are not closed under division - even if you put aside the pesky issue of dividing by $0$. For that, the rational numbers must be introduced. So aside from division by $0$, the rationals are closed under addition, subtraction, multiplication, and division. There is one more fundamental operation though, powers.
"""

# ╔═╡ 333d94bc-53c0-11ec-3889-6d61b3b28b7c
md"""Powers are defined for positive integers in a simple enough manner
"""

# ╔═╡ 333d9674-53c0-11ec-1888-612d8db95371
md"""```math
a^n=a \cdot a \cdot a \cdots a \text{ (n times); }  a, n \text{ are integers } n \text{ is positive}.
```
"""

# ╔═╡ 333d96c4-53c0-11ec-1563-1d9f3d96f283
md"""We can define $a^0$ to be $1$, except for the special case of $0^0$, which is left undefined mathematically (though it is also defined as `1` within `Julia`). We can extend the above to include negative values of $a$, but what about negative values of $n$? We can't say the integers are closed under powers, as the definition consistent with the rules that $a^{(-n)} = 1/a^n$ requires rational numbers to be defined.
"""

# ╔═╡ 333d9734-53c0-11ec-2348-51e49c116d3e
md"""Well, in the above `a` could be a rational number, is `a^n` closed for rational numbers? No again. Though it is fine for $n$ as an integer (save the odd case of $0$, simple definitions like $2^{1/2}$ are not answered within the rationals. For this, we need to introduce the *real* numbers. It is mentioned that [Aristotle](http://tinyurl.com/bpqbkap) hinted at the irrationality of the square root of $2$. To define terms like $a^{1/n}$ for integer values $a,n > 0$ a reference to a solution to an equation $x^n-a$ is used. Such solutions require the irrational numbers to have solutions in general. Hence the need for the real numbers (well, algebraic numbers at least, though once the exponent is no longer a rational number, the full set of real numbers are needed.)
"""

# ╔═╡ 333d9746-53c0-11ec-274e-03be2c4bd7c1
md"""So, save the pesky cases, the real numbers will be closed under addition, subtraction, multiplication, division, and powers - provided the base is non-negative.
"""

# ╔═╡ 333d975a-53c0-11ec-32be-45fc205fd8cb
md"""Finally for that last case, the complex numbers are introduced to give an answer to $\sqrt{-1}$.
"""

# ╔═╡ 333d9782-53c0-11ec-3f2f-5141ebe4cd57
md"""---
"""

# ╔═╡ 333d97aa-53c0-11ec-2e73-e352ad3140ff
md"""How does this apply with `Julia`?
"""

# ╔═╡ 333d97be-53c0-11ec-366c-6f1d947eb4df
md"""The point is, if we restrict our set of inputs, we can get more precise values for the output of basic operations, but to get more general inputs we need to have bigger output sets.
"""

# ╔═╡ 333d97dc-53c0-11ec-1336-8d5f4a585f17
md"""A similar thing happens in `Julia`. For addition say, the addition of two integers of the same type will be an integer of that type. This speed consideration is not solely for type stability, but also to avoid checking for overflow.
"""

# ╔═╡ 333d9822-53c0-11ec-3193-6513dc9bbca5
md"""Another example, the division of two integers will always be a number of the same type - floating point, as that is the only type that ensures the answer will always fit within. (The explicit use of rationals notwithstanding.) So even if two integers are the input and their answer *could* be an integer, in `Julia` it will be a floating point number, (cf. `2/1`).
"""

# ╔═╡ 333d985e-53c0-11ec-08f8-05994f765aba
md"""Hopefully this helps explain the subtle issues around powers: in `Julia` an integer raised to an integer should be an integer, for speed, though certain cases are special cased, like `2^(-1)`.  However since a real number raised to a real number makes sense always when the base is non-negative, as long as real numbers are used as outputs, the expressions `2.0^(-1)` and `2^(-1.0)` are computed and real numbers (floating points) are returned. For type stability, even though $2.0^1$ could be an integer, a floating point answer is returned.
"""

# ╔═╡ 333d9890-53c0-11ec-2c4d-e941fae0194f
md"""As for negative bases, `Julia` could always return complex numbers, but in addition to this being slower, it would be irksome to users. So user's must opt in. Hence `sqrt(-1.0)` will be an error, but the more explicit - but mathematically equivalent - `sqrt(-1.0 + 0im)` will not be a domain error, but rather a complex value will be returned.
"""

# ╔═╡ 333d98ae-53c0-11ec-18c2-e7bf18d801dc
md"""## Questions
"""

# ╔═╡ 333dbfb4-53c0-11ec-37f7-e33651bef891
begin
	choices = ["Integer", "Rational", "Floating point", "Complex", "None, an error occurs"]
	nothing
end

# ╔═╡ 333dc05e-53c0-11ec-15fc-4bc401dfca84
md"""###### Question
"""

# ╔═╡ 333dc090-53c0-11ec-2b0f-59f749a452ad
md"""The number created by `pi/2` is?
"""

# ╔═╡ 333dc4b4-53c0-11ec-338d-c775d578dbef
let
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333dc4d0-53c0-11ec-3c88-dbd6e14a394d
md"""###### Question
"""

# ╔═╡ 333dc4f0-53c0-11ec-3325-bb5a9de7b21e
md"""The number created by `2/2` is?
"""

# ╔═╡ 333dda76-53c0-11ec-3bd5-3b40671d08c3
let
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333ddab2-53c0-11ec-11fc-f5fb432359dc
md"""###### Question
"""

# ╔═╡ 333ddae4-53c0-11ec-0f0d-dd430c54c2e7
md"""The number created by `2//2` is?
"""

# ╔═╡ 333ddea4-53c0-11ec-26d3-719ecdbc0287
let
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333ddec0-53c0-11ec-2d8c-99ebe0ee7b3c
md"""###### Question
"""

# ╔═╡ 333ddee0-53c0-11ec-0a0d-cb7f34d263f0
md"""The number created by `1 + 1//2 + 1/3` is?
"""

# ╔═╡ 333de2be-53c0-11ec-3667-afb394ebc1c9
let
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333de2dc-53c0-11ec-293c-fbbed8dfa35e
md"""###### Question
"""

# ╔═╡ 333de2f8-53c0-11ec-3c70-754f9253c851
md"""The number created by `2^3` is?
"""

# ╔═╡ 333de66c-53c0-11ec-1095-d3399794f609
let
	ans = 1
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333de67e-53c0-11ec-08b4-ffebe119dabd
md"""###### Question
"""

# ╔═╡ 333de69e-53c0-11ec-1d6e-25200b19e4ab
md"""The number created by `sqrt(im)` is?
"""

# ╔═╡ 333dea16-53c0-11ec-0e99-ff999e6382de
let
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333dea34-53c0-11ec-0089-7300eae4bf10
md"""###### Question
"""

# ╔═╡ 333dea52-53c0-11ec-01ed-c195810859fa
md"""The number created by `2^(-1)` is?
"""

# ╔═╡ 333dedd4-53c0-11ec-17ac-959f9f0d9345
let
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333dedf4-53c0-11ec-26d0-6b75a2ffcdcf
md"""###### Question
"""

# ╔═╡ 333dee06-53c0-11ec-349d-6dcd1dab79d6
md"""The "number" created by `1/0` is?
"""

# ╔═╡ 333e067c-53c0-11ec-04a9-f182ef8b5480
let
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 333e06a4-53c0-11ec-3958-a5a075a254ca
md"""###### Question
"""

# ╔═╡ 333e06d6-53c0-11ec-3e3e-059d9244cf9e
md"""Is `(2 + 6) + 7` equal to  `2 + (6 + 7)`?
"""

# ╔═╡ 333e0ad2-53c0-11ec-3f83-03d93b74131b
let
	yesnoq(true)
end

# ╔═╡ 333e0af0-53c0-11ec-09c0-d9c46faa029f
md"""###### Question
"""

# ╔═╡ 333e0b18-53c0-11ec-2967-99d29a69d8b2
md"""Is `(2/10 + 6/10) + 7/10` equal to `2/10 + (6/10 + 7/10)`?
"""

# ╔═╡ 333e0cb2-53c0-11ec-2931-1d4f23e45ca4
let
	yesnoq(false)
end

# ╔═╡ 333e0cd2-53c0-11ec-08a6-c9f613d99d8e
md"""###### Question
"""

# ╔═╡ 333e0d16-53c0-11ec-0e29-65ef525e8f0b
md"""The following *should* compute `2^(-1)`, which if entered directly will return `0.5`. Does it?
"""

# ╔═╡ 333e0d8e-53c0-11ec-35b6-5fe7c61a63ff
md"""```
a, b = 2, -1
a^b
```"""

# ╔═╡ 333e0f50-53c0-11ec-1c08-45f4a7b55ce5
let
	yesnoq(false)
end

# ╔═╡ 333e0f6e-53c0-11ec-2295-337d5e267665
md"""(This shows the special casing that is done when powers use literal numbers.)
"""

# ╔═╡ 333e0f8c-53c0-11ec-297c-d9ca470c2367
HTML("""<div class="markdown"><blockquote>
<p><a href="../precalc/variables.html">◅ previous</a>  <a href="../precalc/logical_expressions.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/numbers_types.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 333e0fa2-53c0-11ec-384b-dd22fcd010c5
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.10"
DataFrames = "~1.2.2"
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
# ╟─333e0f78-53c0-11ec-0eae-65a921a92e52
# ╟─33377eb8-53c0-11ec-3bc7-59d25268d431
# ╟─333820ea-53c0-11ec-3976-093afeca11ea
# ╟─33382180-53c0-11ec-27d5-e107241cf24a
# ╟─3338266c-53c0-11ec-1cab-a7c068c39c92
# ╟─333826a0-53c0-11ec-1c8e-13eef3be15d7
# ╟─333826b2-53c0-11ec-1426-c7f42c94121f
# ╟─33382732-53c0-11ec-3b30-0f33f5126c69
# ╟─33382748-53c0-11ec-3d58-b7e16ee5a23c
# ╟─333827c0-53c0-11ec-3dac-959e95ed4403
# ╠═3338c7ca-53c0-11ec-226f-f7ac67cc0405
# ╟─3338c8f6-53c0-11ec-2fd2-7991a3521995
# ╟─3338c914-53c0-11ec-3a17-19f9dfc03df9
# ╟─3338cc2a-53c0-11ec-2ab7-a77a177a3fdc
# ╟─3338e1e2-53c0-11ec-1421-01dc3ed7c164
# ╟─3338e21e-53c0-11ec-33b4-7f2895f16bb1
# ╟─3338e25a-53c0-11ec-2921-0524d174409e
# ╟─3338e26e-53c0-11ec-0d3b-d7ed6e10f03d
# ╠═33390b04-53c0-11ec-32a8-d96a50397029
# ╟─33390b36-53c0-11ec-280a-1d74152b98c1
# ╟─33390be0-53c0-11ec-25a3-ed45fbd961dd
# ╟─33390bf4-53c0-11ec-29f4-a908bc1b98e9
# ╠═33394362-53c0-11ec-044c-d3f6be55fae1
# ╟─33394418-53c0-11ec-0888-8f779ee92722
# ╟─33395faa-53c0-11ec-119a-41290793e291
# ╟─3339609a-53c0-11ec-1045-6b8afbe571dd
# ╟─333961d0-53c0-11ec-3fc5-e788144bf443
# ╟─333961f8-53c0-11ec-30bf-47c3ad4ad420
# ╠═3339774c-53c0-11ec-19fe-93a0786d160d
# ╟─3339777e-53c0-11ec-0824-1d46562ec91b
# ╟─33397792-53c0-11ec-382a-27914f73f68f
# ╟─333978a0-53c0-11ec-0dcb-83eecb41d5d6
# ╠═333992cc-53c0-11ec-0f24-d711f5fd5cd9
# ╟─33399310-53c0-11ec-27d5-fd5c51451bdd
# ╠═3339b07c-53c0-11ec-0c2f-9d8cee03ff22
# ╟─3339b162-53c0-11ec-0a69-b350df3b95d5
# ╟─3339b1aa-53c0-11ec-0bfa-71b1cf0077a9
# ╟─3339b46e-53c0-11ec-1fec-41dd09f1448f
# ╟─3339b4a0-53c0-11ec-2752-7b0db5da4914
# ╟─3339b4e6-53c0-11ec-2949-bbf9d6363a3d
# ╟─3339b52c-53c0-11ec-112e-b9c5336ed37b
# ╟─3339b53e-53c0-11ec-0554-69d4d835d727
# ╟─3339b614-53c0-11ec-1f62-dd48218b5619
# ╟─3339b626-53c0-11ec-36c3-876bd01079a1
# ╟─3339b694-53c0-11ec-19dd-174a7f12bfc1
# ╟─3339b73e-53c0-11ec-16b6-6ddb1ade14b1
# ╟─3339b752-53c0-11ec-0c1e-b57b754b2886
# ╟─3339b81a-53c0-11ec-09b6-a1ce18b78c46
# ╟─3339b842-53c0-11ec-1ae7-13137db274f1
# ╟─333ab9fc-53c0-11ec-234b-95dbef7b15f2
# ╟─333ad2fe-53c0-11ec-1c16-eb0a92261805
# ╟─333ad376-53c0-11ec-106e-df178054adeb
# ╠═333ad7cc-53c0-11ec-0e82-f9d9535b944e
# ╟─333ad808-53c0-11ec-2ef7-67b6c292b5ae
# ╠═333b07ec-53c0-11ec-1938-9b76654cf29f
# ╟─333b088c-53c0-11ec-1851-8107ec14d6c5
# ╠═333b0c24-53c0-11ec-1010-0969e3165b66
# ╟─333b0c88-53c0-11ec-3ebe-93f2ce54a6ec
# ╟─333b0cba-53c0-11ec-2f09-4372eb152457
# ╟─333b0d0c-53c0-11ec-2f68-01b473c8c562
# ╟─333b0d82-53c0-11ec-2d1b-3d515ce5b679
# ╠═333b13e2-53c0-11ec-3870-bbdb09d27c3c
# ╠═333b314a-53c0-11ec-387b-ad0b8da3e512
# ╟─333b31d8-53c0-11ec-3987-b3218ce91068
# ╟─333b31fe-53c0-11ec-21b4-f37ae27a1e8b
# ╟─333b3230-53c0-11ec-1cf0-e30ff5f017d8
# ╠═333b4e14-53c0-11ec-04db-37c5d7d705c0
# ╟─333b4eb4-53c0-11ec-09fa-c52080bcc7bb
# ╟─333b4edc-53c0-11ec-3e12-b98eb505ccf1
# ╟─333b4f68-53c0-11ec-37c5-9d12bd361bb9
# ╠═333b7a74-53c0-11ec-0ede-615586809670
# ╟─333b7ad8-53c0-11ec-05c6-0f62cfe1e37b
# ╠═333b815e-53c0-11ec-0101-35b8d5e72d20
# ╟─333b81cc-53c0-11ec-2e8a-6b664ceaf674
# ╠═333b8604-53c0-11ec-3d40-db02e2f4fd78
# ╟─333b863e-53c0-11ec-187b-c780945696a3
# ╟─333b86c2-53c0-11ec-15f0-458fe71f748a
# ╟─333b8898-53c0-11ec-0dc4-21a62a868916
# ╠═333ba7a8-53c0-11ec-14a5-911341703faf
# ╟─333ba878-53c0-11ec-3dba-a38006a3d788
# ╠═333bb084-53c0-11ec-21d9-2392623add9e
# ╟─333bb0fc-53c0-11ec-1ec3-7b309a5bb49e
# ╟─333bb264-53c0-11ec-3a71-1f68aa131f1d
# ╠═333bf9d6-53c0-11ec-19ed-ff459b99981b
# ╟─333bfec2-53c0-11ec-306e-9f1fb270da1e
# ╠═333c04a8-53c0-11ec-2bfd-89d5e6d4db8c
# ╟─333c050c-53c0-11ec-2e7d-c9da9d6e691e
# ╟─333c05ca-53c0-11ec-2419-53fae619a7d0
# ╟─333c05e6-53c0-11ec-2600-336b1bad41b5
# ╠═333c2a64-53c0-11ec-3d35-4f80335c33f9
# ╟─333c2ab2-53c0-11ec-1e33-a1b8bc337d2e
# ╠═333c4e90-53c0-11ec-3cf9-f9072115c463
# ╟─333c4ed6-53c0-11ec-0212-8161616e34b2
# ╠═333c8f74-53c0-11ec-30f9-876cd3526bea
# ╟─333c8fae-53c0-11ec-18d2-633f3c7db7a2
# ╠═333cb524-53c0-11ec-1df7-f32bfa8fdfed
# ╟─333cb560-53c0-11ec-3e60-19d81feea127
# ╠═333cf8b8-53c0-11ec-0ae3-e92464d5618a
# ╟─333cf8fe-53c0-11ec-1d8c-ad78d8db44e6
# ╟─333cf926-53c0-11ec-32b4-493b8d6f0d09
# ╟─333d551a-53c0-11ec-0898-57ea00d4f5f1
# ╟─333d55b0-53c0-11ec-1d7d-a7b08e2ef682
# ╟─333d565a-53c0-11ec-35dd-b58b9eedd159
# ╠═333d5d8a-53c0-11ec-3050-b5c4f15944c9
# ╟─333d5dee-53c0-11ec-1cc6-01bd67f88fce
# ╟─333d5e52-53c0-11ec-3590-33dbc3454f2e
# ╠═333d630c-53c0-11ec-3195-333c1e849885
# ╟─333d6350-53c0-11ec-3899-a56c37ac9809
# ╟─333d6370-53c0-11ec-319a-35a311165b7a
# ╠═333d80a8-53c0-11ec-1bbd-f38267cd049e
# ╟─333d80ee-53c0-11ec-2fef-dbda931e2642
# ╟─333d92e6-53c0-11ec-3afa-49d69c92315e
# ╟─333d9322-53c0-11ec-3033-dbfe95e5daa8
# ╟─333d937c-53c0-11ec-233f-698a4fec4c17
# ╟─333d93b8-53c0-11ec-0a34-bd02e9c8d0e9
# ╟─333d93d6-53c0-11ec-353a-d5577f84da72
# ╟─333d9408-53c0-11ec-1864-299a6cc293cf
# ╟─333d9458-53c0-11ec-1c48-bf1f09a9ec6a
# ╟─333d9476-53c0-11ec-22e6-9368fd9198ad
# ╟─333d948a-53c0-11ec-165e-67334b7c9843
# ╟─333d94a8-53c0-11ec-0931-6fb0a9956867
# ╟─333d94bc-53c0-11ec-3889-6d61b3b28b7c
# ╟─333d9674-53c0-11ec-1888-612d8db95371
# ╟─333d96c4-53c0-11ec-1563-1d9f3d96f283
# ╟─333d9734-53c0-11ec-2348-51e49c116d3e
# ╟─333d9746-53c0-11ec-274e-03be2c4bd7c1
# ╟─333d975a-53c0-11ec-32be-45fc205fd8cb
# ╟─333d9782-53c0-11ec-3f2f-5141ebe4cd57
# ╟─333d97aa-53c0-11ec-2e73-e352ad3140ff
# ╟─333d97be-53c0-11ec-366c-6f1d947eb4df
# ╟─333d97dc-53c0-11ec-1336-8d5f4a585f17
# ╟─333d9822-53c0-11ec-3193-6513dc9bbca5
# ╟─333d985e-53c0-11ec-08f8-05994f765aba
# ╟─333d9890-53c0-11ec-2c4d-e941fae0194f
# ╟─333d98ae-53c0-11ec-18c2-e7bf18d801dc
# ╟─333dbfb4-53c0-11ec-37f7-e33651bef891
# ╟─333dc05e-53c0-11ec-15fc-4bc401dfca84
# ╟─333dc090-53c0-11ec-2b0f-59f749a452ad
# ╟─333dc4b4-53c0-11ec-338d-c775d578dbef
# ╟─333dc4d0-53c0-11ec-3c88-dbd6e14a394d
# ╟─333dc4f0-53c0-11ec-3325-bb5a9de7b21e
# ╟─333dda76-53c0-11ec-3bd5-3b40671d08c3
# ╟─333ddab2-53c0-11ec-11fc-f5fb432359dc
# ╟─333ddae4-53c0-11ec-0f0d-dd430c54c2e7
# ╟─333ddea4-53c0-11ec-26d3-719ecdbc0287
# ╟─333ddec0-53c0-11ec-2d8c-99ebe0ee7b3c
# ╟─333ddee0-53c0-11ec-0a0d-cb7f34d263f0
# ╟─333de2be-53c0-11ec-3667-afb394ebc1c9
# ╟─333de2dc-53c0-11ec-293c-fbbed8dfa35e
# ╟─333de2f8-53c0-11ec-3c70-754f9253c851
# ╟─333de66c-53c0-11ec-1095-d3399794f609
# ╟─333de67e-53c0-11ec-08b4-ffebe119dabd
# ╟─333de69e-53c0-11ec-1d6e-25200b19e4ab
# ╟─333dea16-53c0-11ec-0e99-ff999e6382de
# ╟─333dea34-53c0-11ec-0089-7300eae4bf10
# ╟─333dea52-53c0-11ec-01ed-c195810859fa
# ╟─333dedd4-53c0-11ec-17ac-959f9f0d9345
# ╟─333dedf4-53c0-11ec-26d0-6b75a2ffcdcf
# ╟─333dee06-53c0-11ec-349d-6dcd1dab79d6
# ╟─333e067c-53c0-11ec-04a9-f182ef8b5480
# ╟─333e06a4-53c0-11ec-3958-a5a075a254ca
# ╟─333e06d6-53c0-11ec-3e3e-059d9244cf9e
# ╟─333e0ad2-53c0-11ec-3f83-03d93b74131b
# ╟─333e0af0-53c0-11ec-09c0-d9c46faa029f
# ╟─333e0b18-53c0-11ec-2967-99d29a69d8b2
# ╟─333e0cb2-53c0-11ec-2931-1d4f23e45ca4
# ╟─333e0cd2-53c0-11ec-08a6-c9f613d99d8e
# ╟─333e0d16-53c0-11ec-0e29-65ef525e8f0b
# ╟─333e0d8e-53c0-11ec-35b6-5fe7c61a63ff
# ╟─333e0f50-53c0-11ec-1c08-45f4a7b55ce5
# ╟─333e0f6e-53c0-11ec-2295-337d5e267665
# ╟─333e0f8c-53c0-11ec-297c-d9ca470c2367
# ╟─333e0f96-53c0-11ec-1638-933d6dbb107e
# ╟─333e0fa2-53c0-11ec-384b-dd22fcd010c5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
