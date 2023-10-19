### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 5b439016-53bf-11ec-3d26-ef10419b6903
begin
	using CalculusWithJulia
	using CalculusWithJulia.WeaveSupport
	__DIR__, __FILE__ = :precalc, :calculator
	nothing
end

# ╔═╡ 5b7e3e46-53bf-11ec-1409-7f1393c7d290
begin
	using DataFrames
	calc = [
	L" $+$, $-$, $\times$, $\div$",
	L"x^y",
	L"\sqrt{}, \sqrt[3]{}",
	L"e^x",
	L" $\ln$, $\log$",
	L"\sin, \cos, \tan, \sec, \csc, \cot",
	"In degrees, not radians",
	L"\sin^{-1}, \cos^{-1}, \tan^{-1}",
	L"n!",
	]
	
	
	julia = [
	"`+`, `-`, `*`, `/`",
	"`^`",
	"`sqrt`, `cbrt`",
	"`exp`",
	"`log`, `log10`",
	"`sin`, `cos`, `tan`, `sec`, `csc`, `cot`",
	"`sind`, `cosd`, `tand`, `secd`, `cscd`, `cotd`",
	"`asin`, `acos`, `atan`",
	"`factorial`"
	]
	
	CalculusWithJulia.WeaveSupport.table(DataFrame(Calculator=calc, Julia=julia))
end

# ╔═╡ 5b85c0da-53bf-11ec-182a-a9d7797286e1
using PlutoUI

# ╔═╡ 5b85c0b2-53bf-11ec-22a2-83a606a50328
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 5b20dbd4-53bf-11ec-3df8-7fc9e56510ab
md"""# Replacing the calculator with a computer
"""

# ╔═╡ 5b576c8a-53bf-11ec-31be-3f37352f2944
md"""Let us consider a basic calculator with buttons to add, subtract, multiply, divide, and take square roots. Using such a simple thing is certainly familiar for any reader of these notes. Indeed, a familiarity with a *graphing* calculator is expected. `Julia` makes these familiar tasks just as easy, offering numerous conveniences along the way. In this section we describe how.
"""

# ╔═╡ 5b576d5c-53bf-11ec-2b4f-6bfe6b396e5f
md"""The following image is the calculator that Google presents upon searching for "calculator."
"""

# ╔═╡ 5b5884b2-53bf-11ec-21e5-1bc0ffef89a3
md"""![Screenshot of a calculator provided by the Google search engine.](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/precalc/figures/calculator.png)
"""

# ╔═╡ 5b58a690-53bf-11ec-2605-63306f61f699
begin
	imgfile = "figures/calculator.png"
	caption = "Screenshot of a calculator provided by the Google search engine."
	#ImageFile(imgfile, caption)
	nothing
end

# ╔═╡ 5b5b0d9a-53bf-11ec-2f94-3b021baa4a00
md"""This calculator should have a familiar appearance with a keypad of numbers, a set of buttons for arithmetic operations, a set of buttons for some common mathematical functions, a degree/radian switch, and buttons for interacting with the calculator: `Ans`, `AC` (also `CE`), and `=`.
"""

# ╔═╡ 5b5b0e44-53bf-11ec-0945-ab3f020ae8f1
md"""The goal here is to see the counterparts within `Julia` to these features.
"""

# ╔═╡ 5b5e90d2-53bf-11ec-02a0-a59cab315010
md"""---
"""

# ╔═╡ 5b5e91ae-53bf-11ec-3833-8d39c6aba3c7
md"""For an illustration of *really* basic calculator, have some fun watching this video:
"""

# ╔═╡ 5b5eacc0-53bf-11ec-17d4-ed0d78424c27
begin
	txt = """
	<center>
	<iframe width="560" height="315" src="https://www.youtube.com/embed/sxLdGjV-_yg" frameborder="0" allowfullscreen>
	</iframe>
	</center>
	"""
	CalculusWithJulia.WeaveSupport.HTMLoutput(txt)
end

# ╔═╡ 5b62d994-53bf-11ec-3666-4921963de1a6
md"""## Operations
"""

# ╔═╡ 5b62da2a-53bf-11ec-27b2-e9e097268e94
md"""Performing a simple computation on the calculator typically involves hitting buttons in a sequence, such as "1", "+", "2", "`=`" to compute 3 from adding 1 + 2. In `Julia`, the process is not so different. Instead of pressing buttons, the various values are typed in. So, we would have:
"""

# ╔═╡ 5b62e164-53bf-11ec-36d9-190d3f90b0d4
1 + 2

# ╔═╡ 5b62e1b4-53bf-11ec-2d90-1917d032bd7e
md"""Sending an expression to `Julia`'s interpreter - the equivalent of pressing the "`=`" key on a calculator - is done at the command line by pressing the `Enter` or `Return` key, and in `Pluto`, also using the "play" icon, or the keyboard shortcut `Shift-Enter`. If the current expression is complete, then `Julia` evaluates it and shows any output.  If the expression is not complete, `Julia`'s response depends on how it is being called. Within `Pluto`, a message about "`premature end of input`" is given. If the expression raises an error, this will be noted.
"""

# ╔═╡ 5b677472-53bf-11ec-3a9f-59f46f2f18f6
md"""The basic arithmetic operations on a calculator are "+", "-", "×", "÷", and "$xʸ$". These have parallels in `Julia` through the *binary* operators: `+`, `-`, `*`, `/`, and `^`:
"""

# ╔═╡ 5b6783e0-53bf-11ec-0849-293096cd299c
1 + 2, 2 - 3, 3 * 4, 4 / 5, 5 ^ 6

# ╔═╡ 5b67846c-53bf-11ec-3ede-4d36207948e3
md"""On some calculators, there is a distinction between minus signs - the binary minus sign and the unary minus sign to create values such as $-1$.
"""

# ╔═╡ 5b67849e-53bf-11ec-38b1-818cd58f9ac3
md"""In `Julia`, the same symbol, "`-`", is used for each:
"""

# ╔═╡ 5b67886a-53bf-11ec-0f0e-d73b568cb83f
-1 - 2

# ╔═╡ 5b6788a4-53bf-11ec-0b15-5980db46dc36
md"""An expression like $6 - -3$, subtracting minus three from six, must be handled with some care.  With the Google calculator, the expression must be entered with accompanying parentheses: $6 -(-3)$. In `Julia`, parentheses may be used, but are not needed. However, if omitted, a space is required between the two minus signs:
"""

# ╔═╡ 5b678a70-53bf-11ec-263a-252601e68b6c
6 - -3

# ╔═╡ 5b678a98-53bf-11ec-2dea-954903ef9d11
md"""(If no space is included, the value "`--`" is parsed like a different, undefined, operation.)
"""

# ╔═╡ 5b67dac0-53bf-11ec-3a47-5925a725808e
warning(L"""

`Julia` only uses one symbol for minus, but web pages may not! Copying
and pasting an expression with a minus sign can lead to hard to
understand errors such as: `invalid character "−"`. There are several
Unicode symbols that look similar to the ASCII minus sign, but are
different. These notes use a different character for the minus sign for
the typeset math (e.g., $1 - \pi$) than for the code within cells
(e.g. `1 - 2`). Thus, copying and pasting the typeset math may not work as expected.

""")

# ╔═╡ 5b6baec0-53bf-11ec-2de9-311cc59f3707
md"""### Examples
"""

# ╔═╡ 5b6ecb0a-53bf-11ec-0f39-796a73f22bed
md"""##### Example
"""

# ╔═╡ 5b6ecbbe-53bf-11ec-2a2c-67e74fbea510
md"""For everyday temperatures, the conversion from Celsius to Fahrenheit ($9/5 C + 32$) is well approximated by simply doubling and adding $30$. Compare these values for an average room temperature, $C=20$, and for a relatively chilly day, $C=5$:
"""

# ╔═╡ 5b6ecbd2-53bf-11ec-1d07-b5cc97b8cadb
md"""For $C=20$:
"""

# ╔═╡ 5b6ed2ee-53bf-11ec-15a8-51272e9ce6bd
9 / 5 * 20 + 32

# ╔═╡ 5b6ed316-53bf-11ec-14fd-5b4b4434f0c4
md"""The easy to compute approximate value is:
"""

# ╔═╡ 5b6ed5fa-53bf-11ec-1252-69c599901404
2 * 20 + 30

# ╔═╡ 5b6ed622-53bf-11ec-00b7-33990b1a5eea
md"""The difference is:
"""

# ╔═╡ 5b6ef6d6-53bf-11ec-0a0b-3d7df81cc978
(9/5*20 + 32) - (2 * 20 + 30)

# ╔═╡ 5b6ef74c-53bf-11ec-3bae-15a57ae60f5f
md"""For $C=5$, we have the actual value of:
"""

# ╔═╡ 5b6efe72-53bf-11ec-2fe4-73c6288d2165
9 / 5 * 5 + 32

# ╔═╡ 5b6efecc-53bf-11ec-3834-f9d62a14e5a8
md"""and the easy to compute value is simply $40 = 10 + 30$. The difference is
"""

# ╔═╡ 5b6f04b0-53bf-11ec-260c-bd6c5a47627d
(9 / 5 * 5 + 32) - 40

# ╔═╡ 5b6f04f8-53bf-11ec-0e2d-47918074856f
md"""##### Example
"""

# ╔═╡ 5b6f0514-53bf-11ec-0e44-295c6b32d474
md"""Add the numbers $1 + 2 + 3 + 4 + 5$.
"""

# ╔═╡ 5b6f091a-53bf-11ec-0c3d-b572abfc4733
1 + 2 + 3 + 4 + 5

# ╔═╡ 5b6f0930-53bf-11ec-2636-fbffdd2e35c7
md"""##### Example
"""

# ╔═╡ 5b6f0958-53bf-11ec-00a7-8be6abfbb054
md"""How small is $1/2/3/4/5/6$? It is about $14/10,000$, as this will show:
"""

# ╔═╡ 5b6f0e94-53bf-11ec-2a7a-d3a680bdb07b
1/2/3/4/5/6

# ╔═╡ 5b6f0eba-53bf-11ec-11b0-c5eb40644bf2
md"""##### Example
"""

# ╔═╡ 5b6f0eda-53bf-11ec-085b-63fe73662477
md"""Which is bigger $4^3$ or $3^4$? We can check by computing their difference:
"""

# ╔═╡ 5b6f11fc-53bf-11ec-3e7f-3bdf5a8645a5
4^3 - 3^4

# ╔═╡ 5b6f1218-53bf-11ec-01dc-07556bf5156a
md"""So $3^4$ is bigger.
"""

# ╔═╡ 5b6f122e-53bf-11ec-1ff7-193a69666f46
md"""##### Example
"""

# ╔═╡ 5b6f124a-53bf-11ec-392a-175ce90f34a4
md"""A right triangle has sides $a=11$ and $b=12$. Find the length of the   hypotenuse squared. As $c^2 = a^2 + b^2$ we have:
"""

# ╔═╡ 5b6f160a-53bf-11ec-3fb1-5fde4085970b
11^2 + 12^2

# ╔═╡ 5b6f163c-53bf-11ec-3b4e-030d42e6c7d8
md"""## Order of operations
"""

# ╔═╡ 5b6f165a-53bf-11ec-121f-9fd1a9766eec
md"""The calculator must use some rules to define how it will evaluate its instructions when two or more operations are involved. We know mathematically, that when $1 + 2 \cdot 3$ is to be evaluated the multiplication is  done first then the addition.
"""

# ╔═╡ 5b6f16f0-53bf-11ec-3433-5d91b6e59169
md"""With the Google Calculator, typing `1 + 2 x 3 =` will give the value $7$, but *if* we evaluate the `+` sign first, via `1`  `+` `2` `=` `x` `3` `=` the answer will be 9, as that will force the addition of `1+2` before multiplying. The more traditional way of performing that calculation is to use *parentheses* to force an evaluation. That is, `(1 + 2) * 3 =` will produce `9` (though one must type it in, and not use a mouse to enter). Except for the most primitive of calculators, there are dedicated buttons for parentheses to group expressions.
"""

# ╔═╡ 5b6fcb56-53bf-11ec-1e22-ff1485b50616
md"""In `Julia`, the entire expression is typed in before being evaluated, so the usual conventions of mathematics related to the order of operations may be used. These are colloquially summarized by the acronym [PEMDAS](http://en.wikipedia.org/wiki/Order_of_operations).
"""

# ╔═╡ 5b7a3788-53bf-11ec-0c8a-19e557a98739
md"""> **PEMDAS**. This acronym stands for Parentheses, Exponents, Multiplication, Division, Addition, Subtraction. The order indicates which operation has higher precedence, or should happen first. This isn't exactly the case, as "M" and "D" have the same precedence, as do "A" and "S". In the case of two operations with equal precedence, *associativity* is used to decide which to do. For the operations `+`, `-`, `*`, `/` the associativity is left to right, as in the left one is done first, then the right. However, `^` has right associativity, so `4^3^2` is `4^(3^2)` and not `(4^3)^2`. (Be warned that some calculators - and spread sheets, such as Excel - will treat this expression with left associativity.)

"""

# ╔═╡ 5b7a37e2-53bf-11ec-3397-fffac55b73cc
md"""With rules of precedence, an expression like the following has a clear interpretation to `Julia` without the need for parentheses:
"""

# ╔═╡ 5b7a51c8-53bf-11ec-2dfd-9d01dce0b046
1 + 2 - 3 * 4 / 5 ^ 6

# ╔═╡ 5b7a522c-53bf-11ec-25a3-991f19603a96
md"""Working through PEMDAS we see that `^` is first, then `*` and then `/` (this due to associativity and `*` being the leftmost expression of the two) and finally `+` and then `-`, again by associativity rules. So we should have the same value with:
"""

# ╔═╡ 5b7a593e-53bf-11ec-29d5-7f8a441b29a8
(1 + 2) - ((3 * 4) / (5 ^ 6))

# ╔═╡ 5b7a597c-53bf-11ec-1083-e92efff69c4a
md"""If different parentheses are used, the answer will likely be different. For example, the following forces the operations to be `-`, then `*`, then `+`. The result of that is then divided by `5^6`:
"""

# ╔═╡ 5b7a6000-53bf-11ec-1da4-3f070a9203bc
(1 + ((2 - 3) * 4)) / (5 ^ 6)

# ╔═╡ 5b7a6046-53bf-11ec-3749-a72af45f383f
md"""### Examples
"""

# ╔═╡ 5b7a605a-53bf-11ec-032e-2bbe8db15c57
md"""##### Example
"""

# ╔═╡ 5b7a60aa-53bf-11ec-1825-a7b5d99836d5
md"""The percentage error in $x$ if $y$ is the correct value is $(x-y)/y \cdot 100$. Compute this if $x=100$ and $y=98.6$.
"""

# ╔═╡ 5b7a65dc-53bf-11ec-103d-f77197e23b64
(100 - 98.6) / 98.6 * 100

# ╔═╡ 5b7a6604-53bf-11ec-2ce8-a129849e11f2
md"""##### Example
"""

# ╔═╡ 5b7a6640-53bf-11ec-2d1d-edc477bc818b
md"""The marginal cost of producing one unit can be computed by   finding the cost for $n+1$ units and subtracting the cost for   $n$ units. If the cost of $n$ units is $n^2 + 10$, find the marginal cost when $n=100$.
"""

# ╔═╡ 5b7a6c12-53bf-11ec-18b8-6b6d84d9342e
(101^2 + 10) - (100^2 + 10)

# ╔═╡ 5b7a6c32-53bf-11ec-1241-f7bab03ba409
md"""##### Example
"""

# ╔═╡ 5b7a6c58-53bf-11ec-3c4b-b78d4d3dfeee
md"""The average cost per unit is the total cost divided by the number of units. Again, if the cost of $n$ units is $n^2 + 10$, find the average cost for $n=100$ units.
"""

# ╔═╡ 5b7a897c-53bf-11ec-05c2-37707252b82d
(100^2 + 10) / 100

# ╔═╡ 5b7a89c2-53bf-11ec-1ad3-d92c74ecc9c9
md"""##### Example
"""

# ╔═╡ 5b7a89fe-53bf-11ec-1ca9-f9490db1601d
md"""The slope of the line through two points is $m=(y_1 - y_0) / (x_1 - x_0)$. For the two points $(1,2)$ and $(3,4)$ find the slope of the line through them.
"""

# ╔═╡ 5b7a8ee0-53bf-11ec-042c-8ba5d2497214
(4 - 2) / (3 - 1)

# ╔═╡ 5b7a8f08-53bf-11ec-27a2-a70512279704
md"""### Two ways to write division - and they are not the same
"""

# ╔═╡ 5b7a8f30-53bf-11ec-16bd-dbc85792b104
md"""The expression $a + b / c + d$ is equivalent to $a + (b/c) + d$ due to the order of operations. It will generally have a different answer than $(a + b) / (c + d)$.
"""

# ╔═╡ 5b7a8f44-53bf-11ec-2d0c-d99211f90cee
md"""How would the following be expressed, were it written inline:
"""

# ╔═╡ 5b7d6de0-53bf-11ec-2c52-718495755c9b
md"""```math
\frac{1 + 2}{3 + 4}?
```
"""

# ╔═╡ 5b7d6f20-53bf-11ec-1688-6b8402a1dda7
md"""It would have to be computed through $(1 + 2) / (3 + 4)$.  This is because unlike `/`, the implied order of operation in the mathematical notation with the *horizontal division symbol* (the [vinicula](http://tinyurl.com/y9tj6udl)) is to compute the top and the bottom and then divide. That is, the vinicula is a grouping notation like parentheses, only implicitly so. Thus the above expression really represents the more verbose:
"""

# ╔═╡ 5b7d6f48-53bf-11ec-3d46-45e48f4ef417
md"""```math
\frac{(1 + 2)}{(3 + 4)}.
```
"""

# ╔═╡ 5b7d6f5e-53bf-11ec-2a89-859fedd42b7a
md"""Which  lends itself readily to the translation:
"""

# ╔═╡ 5b7d77c2-53bf-11ec-3903-414bb3f46d3b
(1 + 2) / (3 + 4)

# ╔═╡ 5b7d77ea-53bf-11ec-28bb-875133dc91c4
md"""To emphasize, this is not the same as the value without the parentheses:
"""

# ╔═╡ 5b7d7b82-53bf-11ec-3b4e-a546b00d579c
1 + 2 / 3 + 4

# ╔═╡ 5b7db0ac-53bf-11ec-3082-ed5f3e1f7272
alert(L"""

The viniculum also indicates grouping when used with the square root
(the top bar), and complex conjugation. That usage is often clear
enough, but the usage of the viniculum in division often leads to
confusion. The example above is one where the parentheses are often,
erroneously, omitted. However, more confusion can arise when there is
more than one vinicula. An expression such as $a/b/c$ written inline
has no confusion, it is: $(a/b) / c$ as left association is used; but
when written with a pair of vinicula there is often the typographical
convention of a slightly longer vinicula to indicate which is to
be considered first. In the absence of that, then top to bottom association is
often implied.

""")

# ╔═╡ 5b7db124-53bf-11ec-1dfd-e3b7547830e2
md"""### Infix, postfix, and prefix notation
"""

# ╔═╡ 5b7db1a6-53bf-11ec-191b-c93a6f342a8a
md"""The factorial button on the Google Button creates an expression like `14!` that is then evaluated. The operator, `!`, appears after the value (`14`) that it is applied to. This is called *postfix notation*. When a unary minus sign is used, as in `-14`, the minus sign occurs before the value it operates on. This uses *prefix notation*. These concepts can be extended to binary operations, where a third possibility is provided: *infix notation*, where the operator is between the two values. The infix notation is common for our familiar mathematical operations. We write `14 + 2` and not `+ 14 2` or `14 2 +`. (Though if we had an old reverse-Polish notation calculator, we would enter `14 2 +`!) In `Julia`, there are several infix operators, such as `+`, `-`, ... and others that we may be unfamiliar with. These mirror the familiar notation from most math texts.
"""

# ╔═╡ 5b7dbf84-53bf-11ec-1552-93acb0c30137
note("""

In `Julia` many infix operations can be done using a prefix manner. For example `14 + 2` can also be evaluated by `+(14,2)`. There are very few *postfix* operations, though in these notes we will overload one, the `'` operation, to indicate a derivative."

""")

# ╔═╡ 5b7dbfd4-53bf-11ec-30f0-e386e113fab2
md"""## Constants
"""

# ╔═╡ 5b7dc010-53bf-11ec-038e-27788a6cef12
md"""The Google calculator has two built in constants, `e` and `π`. Julia provides these as well, though not quite as easily. First,  `π` is just `pi`:
"""

# ╔═╡ 5b7dc16e-53bf-11ec-22a9-33553c33ef32
pi

# ╔═╡ 5b7dc1be-53bf-11ec-2518-47ac514afd6a
md"""Whereas, `e` is is not simply the character `e`, but *rather* a [unicode](../unicode.html) character typed in as `\euler[tab]`.
"""

# ╔═╡ 5b7dc33a-53bf-11ec-0b89-a164e0588888
ℯ

# ╔═╡ 5b7de4dc-53bf-11ec-3ec5-2d71e1734acc
note("""
However, when the accompanying package, `CalculusWithJulia`, is loaded, the character `e` will refer to a floating point approximation to the Euler constant .
""")

# ╔═╡ 5b7dfd78-53bf-11ec-2399-fbc21a7ae69c
md"""In the sequel, we will just use `e` for this constant (though more commonly the `exp` function), with the reminder that base `Julia` alone does not reserve this symbol.
"""

# ╔═╡ 5b7dfddc-53bf-11ec-213f-f1e1901e98f6
md"""Mathematically these are irrational values with decimal expansions that do not repeat. `Julia` represents these values internally with additional accuracy beyond that which is displayed. Math constants can be used as though they were numbers, such is done with this expression:
"""

# ╔═╡ 5b7e035e-53bf-11ec-2bd9-353ddc04f6d2
ℯ^(1/(2*pi))

# ╔═╡ 5b7e0e64-53bf-11ec-1e2f-37b5d89ee734
alert("""In most cases. There are occasional (basically rare) spots where using `pi` by itself causes an eror where `1*pi` will not. The reason is `1*pi` will create a floating point value from the irrational object, `pi`.
""")

# ╔═╡ 5b7e0e9e-53bf-11ec-1c37-75021f542d11
md"""### Numeric literals
"""

# ╔═╡ 5b7e0f02-53bf-11ec-2329-85effd6613bf
md"""For some special cases, Julia implements *multiplication* without a multiplication symbol. This is when the value on the left is a number, as in `2pi`, which has an equivalent value to `2*pi`. *However* the two are not equivalent, in that multiplication with *numeric literals* does not have the same precedence as regular multiplication - it is higher. This has practical importance when used in division or powers. For instance, these two are **not** the same:
"""

# ╔═╡ 5b7e136c-53bf-11ec-33ce-89e9a381e1fb
1/2pi, 1/2*pi

# ╔═╡ 5b7e1394-53bf-11ec-1c75-13d09fa2ad1c
md"""Why? Because the first `2pi` is performed before division, as multiplication with numeric literals  has higher precedence than regular multiplication, which is at the same level as division.
"""

# ╔═╡ 5b7e13a8-53bf-11ec-1dd5-19aa6d1d7224
md"""To confuse things even more, consider
"""

# ╔═╡ 5b7e163c-53bf-11ec-2dfb-b39cf2651cb0
2pi^2pi

# ╔═╡ 5b7e1670-53bf-11ec-1f67-41ed506c580e
md"""Is this the same as `2 * (pi^2) * pi` or `(2pi)^(2pi)`?. The former would be the case is powers had higher precedence than literal multiplication, the latter would be the case were it the reverse. In fact, the correct answer is `2 * (pi^(2*pi))`:
"""

# ╔═╡ 5b7e384c-53bf-11ec-27bc-9b9682cce5d5
2pi^2pi, 2 * (pi/2) * pi, (2pi)^(2pi), 2 * (pi^(2pi))

# ╔═╡ 5b7e3888-53bf-11ec-1e04-1d01bb5afad5
md"""This follows usual mathematical convention, but is a source of potential confusion. It can be best to be explicit about multiplication, save for the simplest of cases.
"""

# ╔═╡ 5b7e389c-53bf-11ec-2c52-c5446f7c7b4d
md"""## Functions
"""

# ╔═╡ 5b7e38ec-53bf-11ec-09ab-716dd957dd24
md"""On the Google calculator, the square root button has a single purpose: for the current value find a square root if possible, and if not signal an error (such as what happens if the value is negative). For more general powers, the $x^y$ key can be used.
"""

# ╔═╡ 5b7e398c-53bf-11ec-0849-5bdefb595d14
md"""In `Julia`, functions are used to perform the actions that a specialized button may do on the calculator. `Julia` provides many standard mathematical functions - more than there could be buttons on a calculator - and allows the user to easily define their own functions. For example, `Julia` provides the same set of functions as on Google's calculator, though with different names. For logarithms, $\ln$ becomes `log` and $\log$ is `log10` (computer programs almost exclusively reserve `log` for the natural log); for factorials, $x!$, there is `factorial`; for powers $\sqrt{}$ becomes `sqrt`, $EXP$ becomes `exp`, and $x^y$ is computed with the infix operator `^`. For the trigonometric functions, the basic names are similar: `sin`, `cos`, `tan`. These expect radians. For angles in degrees, the convenience functions `sind`, `cosd`, and `tand` are provided. On the calculator, inverse functions like $\sin^{-1}(x)$ are done by combining $Inv$ with $\sin$. With `Julia`, the function name is `asin`, an abbreviation for "arcsine." (Which is a good thing, as the notation using a power of $-1$ is often a source of confusion and is not supported by `Julia` without work.) Similarly, there are `asind`, `acos`, `acosd`, `atan`, and `atand` functions available to the `Julia` user.
"""

# ╔═╡ 5b7e3994-53bf-11ec-246b-d7300165f4ad
md"""The following table summarizes the above:
"""

# ╔═╡ 5b7e3e70-53bf-11ec-1dff-a3ca55eaff97
md"""Using a function is very straightforward. A function is called using parentheses, in a manner visually similar to how a function is called mathematically. So if we consider the `sqrt` function, we have:
"""

# ╔═╡ 5b7e418e-53bf-11ec-017d-93b3891b18ee
sqrt(4), sqrt(5)

# ╔═╡ 5b7e41de-53bf-11ec-2da3-b573b292dac5
md"""The function is referred to by name (`sqrt`) and called with parentheses. Any arguments are passed into the function using commas to separate values, should there be more than one. When there are numerous values for a function, the arguments may need to be given in a specific order or may possibly be specified with *keywords*. (A semicolon can be used instead of a comma to separate keyword arguments.)
"""

# ╔═╡ 5b7e41f2-53bf-11ec-24c8-a3335c136a35
md"""Some more examples:
"""

# ╔═╡ 5b7e62a4-53bf-11ec-2611-97906bda10eb
exp(2), log(10), sqrt(100), 10^(1/2)

# ╔═╡ 5b7e7802-53bf-11ec-3dbb-2d7382957f1b
note("""

Parentheses have many roles. We've just seen that parentheses may be
used for grouping, and now we see they are used to indicate a function
is being called. These are familiar from their parallel usage in
traditional math notation. In `Julia`, a third usage is common, the
making of a "tuple," or a container of different objects, for example
`(1, sqrt(2), pi)`. In these notes, the output of multiple commands separated by commas is a printed tuple.

""")

# ╔═╡ 5b7e783e-53bf-11ec-0141-7bb917055fa6
md"""### Multiple arguments
"""

# ╔═╡ 5b7e78ac-53bf-11ec-3746-47387d9a5850
md"""For the logarithm, we mentioned that `log` is the natural log and `log10` implements the logarithm base 10. As well there is `log2`. However, in general there is no `logb` for any base `b`. Instead, the basic `log` function can take *two* arguments. When it does, the first is the base, and the second the value to take the logarithm of. This avoids forcing the user to remember that $\log_b(x) = \log(x)/\log(b)$.
"""

# ╔═╡ 5b7e78c0-53bf-11ec-2ada-1be6257215e8
md"""So we have all these different, but related, uses to find logarithms:
"""

# ╔═╡ 5b7e7e56-53bf-11ec-2fe5-233237e26de2
log(e), log(2, e), log(10, e), log(e, 2)

# ╔═╡ 5b7e7e92-53bf-11ec-1946-eb3eb080d060
md"""In `Julia`, the "generic" function `log` not only has different implementations for different types of arguments (real or complex), but also has a different implementation depending on the number of arguments.
"""

# ╔═╡ 5b7e7ea6-53bf-11ec-2663-59ef4d5fce84
md"""### Examples
"""

# ╔═╡ 5b7e7ed8-53bf-11ec-3747-237ee8186a7b
md"""##### Example
"""

# ╔═╡ 5b7e7f0a-53bf-11ec-1293-73e056c7b7d6
md"""A right triangle has sides $a=11$ and $b=12$. Find the length of the hypotenuse. As $c^2 = a^2 + b^2$ we have:
"""

# ╔═╡ 5b7e834c-53bf-11ec-1a1e-fd4cb4b0be8f
sqrt(11^2 + 12^2)

# ╔═╡ 5b7e836a-53bf-11ec-184b-7dc6f08f5b23
md"""##### Example
"""

# ╔═╡ 5b7e8390-53bf-11ec-28ce-0761f86bcf09
md"""A formula from statistics to compute the variance of a binomial random variable for parameters $p$ and $n$ is $\sqrt{n p (1-p)}$. Compute this value for $p=1/4$ and $n=10$.
"""

# ╔═╡ 5b7e8a18-53bf-11ec-212c-f702c8e56d99
sqrt(10 * 1/4 * (1 - 1/4))

# ╔═╡ 5b7e8a2c-53bf-11ec-00a5-a11ff95f1f63
md"""##### Example
"""

# ╔═╡ 5b7e8a54-53bf-11ec-263b-3541efff4a5a
md"""Find the distance between the points $(-3, -4)$ and $(5,6)$. Using the distance formula $\sqrt{(x_1-x_0)^2+(y_1-y_0)^2}$, we have:
"""

# ╔═╡ 5b7e9094-53bf-11ec-1502-e5636663312d
sqrt((5 - -3)^2 + (6 - -4)^2)

# ╔═╡ 5b7e90b2-53bf-11ec-346f-55d439c534b3
md"""##### Example
"""

# ╔═╡ 5b7e90d0-53bf-11ec-317f-a3d949c3388d
md"""The formula to compute the resistance of two resistors in parallel is given by: $1/(1/r_1 + 1/r_2)$. Suppose the resistance is $10$ in one resistor and $20$ in the other. What is the resistance in parallel?
"""

# ╔═╡ 5b7e94fe-53bf-11ec-0326-2b1217dd7828
1 / (1/10 + 1/20)

# ╔═╡ 5b7e951c-53bf-11ec-06ef-d1603c2b356e
md"""## Errors
"""

# ╔═╡ 5b7e954e-53bf-11ec-172f-c1a67456a193
md"""Not all computations on a calculator are valid. For example, the Google calculator will display `Error` as the output of $0/0$ or $\sqrt{-1}$. These are also errors mathematically, though the second is not if the complex numbers are considered.
"""

# ╔═╡ 5b7e956c-53bf-11ec-1609-b92111a39ddb
md"""In `Julia`, there is a richer set of error types. The value `0/0` will in fact not be an error, but rather a value `NaN`. This is a special floating point value indicating "not a number" and is the result for various operations.  The output of $\sqrt{-1}$ (computed via `sqrt(-1)`) will indicate a domain error:
"""

# ╔═╡ 5b7e97ba-53bf-11ec-3e4b-130eb330966a
sqrt(-1)

# ╔═╡ 5b7e97d8-53bf-11ec-2389-05ed9388755d
md"""For integer or real-valued inputs, the `sqrt` function expects non-negative values, so that the output will always be a real number.
"""

# ╔═╡ 5b7e981e-53bf-11ec-11c5-f70d4c34eb37
md"""There are other types of errors. Overflow is a common one on most calculators. The value of $1000!$ is actually *very* large (over 2500 digits large). On the Google calculator it returns `Infinity`, a slight stretch. For `factorial(1000)` `Julia` returns an `OverflowError`. This means that the answer is too large to be represented as a regular integer.
"""

# ╔═╡ 5b7e99ea-53bf-11ec-0a16-b7f6857df538
factorial(1000)

# ╔═╡ 5b7e9a6c-53bf-11ec-24bb-1957d6815c0b
md"""How `Julia` handles overflow is a study in tradeoffs. For integer operations that demand high performance, `Julia` does not check for overflow. So, for example, if we are not careful strange answers can be had. Consider the difference here between powers of 2:
"""

# ╔═╡ 5b7eb448-53bf-11ec-1531-3ded2e6eb48a
2^62, 2^63

# ╔═╡ 5b7eb4ac-53bf-11ec-3da3-9d449353b28a
md"""On a machine with $64$-bit integers, the first of these two values is correct, the second, clearly wrong, as the answer given is negative. This is due to overflow. The cost of checking is considered too high, so no error is thrown. The user is expected to have a sense that they need to be careful when their values are quite large. (Or the user can use floating point numbers, which though not always exact, can represent much bigger values and are exact for a reasonably wide range of integer values.)
"""

# ╔═╡ 5b7ed25c-53bf-11ec-0bea-8bed00afe502
alert("""

In a turnaround from a classic blues song, we can think of `Julia` as
built for speed, not for comfort. All of these errors above could be
worked around so that the end user doesn't see them. However, this
would require slowing things down, either through checking of
operations or allowing different types of outputs for similar type of
inputs. These are tradeoffs that are not made for performance
reasons. For the most part, the tradeoffs don't get in the way, but
learning where to be careful takes some time. Error messages
often suggest a proper alternative.

""")

# ╔═╡ 5b7ed2c0-53bf-11ec-15a9-8138d1aaea08
md"""##### Example
"""

# ╔═╡ 5b806752-53bf-11ec-3840-6f1fd71c1ccf
md"""Did Homer Simpson disprove [Fermat's Theorem](http://www.npr.org/sections/krulwich/2014/05/08/310818693/did-homer-simpson-actually-solve-fermat-s-last-theorem-take-a-look)?
"""

# ╔═╡ 5b80684e-53bf-11ec-1383-9ffb8f38f2ef
md"""Fermat's theorem states there are no solutions over the integers to $a^n + b^n = c^n$ when $n > 2$. In the photo accompanying the linked article, we see:
"""

# ╔═╡ 5b806892-53bf-11ec-0013-c3ae55c147cf
md"""```math
3987^{12} + 4365^{12} - 4472^{12}.
```
"""

# ╔═╡ 5b8068ba-53bf-11ec-23e4-dd8cdb9f137f
md"""If you were to do this on most calculators, the answer would be $0$. Were this true, it would show that there is at least one solution to $a^{12} + b^{12} = c^{12}$ over the integers - hence Fermat would be wrong. So is it $0$?
"""

# ╔═╡ 5b80693c-53bf-11ec-1e4f-b7469b94e24f
md"""Well, let's try something with `Julia` to see. Being clever, we check if $(3987^{12} + 4365^{12})^{1/12} = 4472$:
"""

# ╔═╡ 5b8071b6-53bf-11ec-2152-5742d0aab546
(3987^12 + 4365^12)^(1/12)

# ╔═╡ 5b807226-53bf-11ec-2b70-2795ab1ec90c
md"""Not even close. Case closed. But wait? This number to be found must be *at least* as big as $3987$ and we got $28$. Doh! Something can't be right. Well, maybe integer powers are being an issue. (The largest $64$-bit integer is less than $10^{19}$ and we can see that $(4\cdot 10^3)^{12}$ is bigger than $10^{36})$. Trying again using floating point values for the base, we see:
"""

# ╔═╡ 5b807878-53bf-11ec-15e8-79e50c32a6fc
(3987.0^12 + 4365.0^12)^(1/12)

# ╔═╡ 5b8078fc-53bf-11ec-1088-63a2692c0e52
md"""Ahh, we see something really close to $4472$, but not exactly. Why do most calculators get this last part wrong? It isn't that they don't use floating point, but rather the difference between the two numbers:
"""

# ╔═╡ 5b807f80-53bf-11ec-3a88-49d9aa5620a0
(3987.0^12 + 4365.0^12)^(1/12) - 4472

# ╔═╡ 5b807fb2-53bf-11ec-3f0b-911d1b44430d
md"""is less than $10^{-8}$ so on a display with $8$ digits may be rounded to $0$.
"""

# ╔═╡ 5b807fd2-53bf-11ec-29a4-236df6274512
md"""Moral: with `Julia` and with calculators, we still have to be mindful not to blindly accept an answer.
"""

# ╔═╡ 5b80803e-53bf-11ec-0890-4d80c18f0fb0
md"""## Questions
"""

# ╔═╡ 5b848d0a-53bf-11ec-2a3f-e13ee1612d79
md"""###### Question
"""

# ╔═╡ 5b848dfc-53bf-11ec-0be7-f17e28c1d33c
md"""Compute $22/7$ with `Julia`.
"""

# ╔═╡ 5b8498cc-53bf-11ec-2a40-55be97b5e0bf
let
	val = 22/7
	numericq(val)
end

# ╔═╡ 5b84991c-53bf-11ec-00ed-2bdb17cc4860
md"""###### Question
"""

# ╔═╡ 5b8499e4-53bf-11ec-1abc-cbe4a506b7fc
md"""Compute $\sqrt{220}$ with `Julia`.
"""

# ╔═╡ 5b84a01a-53bf-11ec-179d-d1f856e71440
let
	val = sqrt(220)
	numericq(val)
end

# ╔═╡ 5b84a128-53bf-11ec-3a32-117f5489c0bd
md"""###### Question
"""

# ╔═╡ 5b84a15a-53bf-11ec-27f6-41fd4b9c7a91
md"""Compute $2^8$ with `Julia`.
"""

# ╔═╡ 5b84a79a-53bf-11ec-36e5-412d8885ef04
let
	val = 2^8
	numericq(val)
end

# ╔═╡ 5b84a7b8-53bf-11ec-11c6-598a9a9c1170
md"""###### Question
"""

# ╔═╡ 5b84a7d6-53bf-11ec-24c3-25ad0ebc93f0
md"""Compute the value of
"""

# ╔═╡ 5b84a826-53bf-11ec-10f4-493d61238f88
md"""```math
\frac{9 - 5 \cdot (3-4)}{6 - 2}.
```
"""

# ╔═╡ 5b84b4f4-53bf-11ec-08d5-91b399e29996
let
	val = (9-5*(3-4)) / (6-2)
	numericq(val)
end

# ╔═╡ 5b84b526-53bf-11ec-3ebb-e1899061ce5b
md"""###### Question
"""

# ╔═╡ 5b84b56e-53bf-11ec-09ee-c9e74001a90f
md"""Compute the following using `Julia`:
"""

# ╔═╡ 5b84b58c-53bf-11ec-02b9-417b2be7724f
md"""```math
\frac{(.25 - .2)^2}{(1/4)^2 + (1/3)^2}
```
"""

# ╔═╡ 5b84c678-53bf-11ec-180c-af7d9a7bd67f
let
	val = (.25 - .2)^2/((1/4)^2 + (1/3)^2);
	numericq(val)
end

# ╔═╡ 5b84c6b2-53bf-11ec-2629-89a2d134ec55
md"""###### Question
"""

# ╔═╡ 5b84c6d8-53bf-11ec-340f-b5f010d277ed
md"""Compute the decimal representation of the following using `Julia`:
"""

# ╔═╡ 5b84c6f8-53bf-11ec-161d-e331c39053eb
md"""```math
1 + \frac{1}{2} + \frac{1}{2^2} + \frac{1}{2^3} + \frac{1}{2^4}
```
"""

# ╔═╡ 5b84d1e6-53bf-11ec-35e7-f198767bfd03
let
	val = sum((1/2).^(0:4));
	numericq(val)
end

# ╔═╡ 5b84d210-53bf-11ec-3283-dbe6d0eabe34
md"""###### Question
"""

# ╔═╡ 5b84d242-53bf-11ec-2042-737ed1dd5de7
md"""Compute the following using `Julia`:
"""

# ╔═╡ 5b84d260-53bf-11ec-3a3e-f9277327ab5b
md"""```math
\frac{3 - 2^2}{4 - 2\cdot3}
```
"""

# ╔═╡ 5b84dd28-53bf-11ec-1676-4f9db523f878
let
	val = (3 - 2^2)/(4 - 2*3);
	numericq(val)
end

# ╔═╡ 5b84dd5a-53bf-11ec-3a89-a9ad2d6f5e02
md"""###### Question
"""

# ╔═╡ 5b84dd8c-53bf-11ec-06d6-156496732a88
md"""Compute the following using `Julia`:
"""

# ╔═╡ 5b84ddaa-53bf-11ec-2436-511ae3d97cff
md"""```math
(1/2) \cdot 32 \cdot 3^2 + 100 \cdot 3 - 20
```
"""

# ╔═╡ 5b84ec5a-53bf-11ec-0858-7b32691599c8
let
	val = (1/2)*32*3^2 + 100*3 - 20;
	numericq(val)
end

# ╔═╡ 5b84ec8c-53bf-11ec-0b52-7b75eea2d82d
md"""###### Question
"""

# ╔═╡ 5b84ecb4-53bf-11ec-2cca-379d97719953
md"""Wich of the following is a valid `Julia` expression for
"""

# ╔═╡ 5b84ecd2-53bf-11ec-2d1c-29bb132582ea
md"""```math
\frac{3 - 2}{4 - 1}
```
"""

# ╔═╡ 5b84ecde-53bf-11ec-2265-6df4bacd4b02
md"""that uses the least number of parentheses?
"""

# ╔═╡ 5b84fbb4-53bf-11ec-1c0d-6fbeda015f6f
let
	choices = [
	q"(3 - 2)/ 4 - 1",
	q"3 - 2 / (4 - 1)",
	q"(3 - 2) / (4 - 1)"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5b84fbf2-53bf-11ec-0d32-e52a45d802c9
md"""###### Question
"""

# ╔═╡ 5b84fc18-53bf-11ec-1978-6748af4ed918
md"""Wich of the following is a valid `Julia` expression for
"""

# ╔═╡ 5b84fc2c-53bf-11ec-1d04-d1411cc8ca22
md"""```math
\frac{3\cdot2}{4}
```
"""

# ╔═╡ 5b84fc36-53bf-11ec-11c1-8fa43ee6f44d
md"""that uses the least number of parentheses?
"""

# ╔═╡ 5b850384-53bf-11ec-143b-9b4c363b0d1d
let
	choices = [
	q"3 * 2 / 4",
	q"(3 * 2) / 4"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 5b8503b6-53bf-11ec-1e47-5361244170cf
md"""###### Question
"""

# ╔═╡ 5b8503de-53bf-11ec-193b-e98243c3e755
md"""Which of the following is a valid `Julia` expression for
"""

# ╔═╡ 5b8503f2-53bf-11ec-02a3-39814fec98de
md"""```math
2^{4 - 2}
```
"""

# ╔═╡ 5b850438-53bf-11ec-3d2f-5b145a72bd9d
md"""that uses the least number of parentheses?
"""

# ╔═╡ 5b850ae6-53bf-11ec-34e7-2d3788a0f5ed
let
	choices = [
	q"2 ^ 4 - 2",
	q"(2 ^ 4) - 2",
	q"2 ^ (4 - 2)"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5b850b06-53bf-11ec-103e-7739e1d19e84
md"""###### Question
"""

# ╔═╡ 5b850b22-53bf-11ec-1731-c1b2900b5a34
md"""In the U.S. version of the Office, the opening credits include a calculator calculation. The key sequence shown is `9653 +` which produces `11532`.  What value was added to?
"""

# ╔═╡ 5b850fbe-53bf-11ec-1d15-05075c5ed0fc
let
	val = 11532 - 9653
	numericq(val)
end

# ╔═╡ 5b850fe6-53bf-11ec-289f-a3953146fc6c
md"""###### Question
"""

# ╔═╡ 5b851022-53bf-11ec-1843-cf5713a6a405
md"""We saw that `1 / 2 / 3 / 4 / 5 / 6` is about $14$ divided by $10,000$. But what would be a more familiar expression representing it:
"""

# ╔═╡ 5b855f14-53bf-11ec-01ab-2d5174928001
let
	choices = [
	q"1 / (2 / 3 / 4 / 5 / 6)",
	q"1 / 2 * 3 / 4  * 5 / 6",
	q"1 /(2 * 3 * 4 * 5 * 6)"]
	ans = 3
	radioq(choices, ans)
end

# ╔═╡ 5b855fe6-53bf-11ec-09c6-a36060c62ef7
md"""###### Question
"""

# ╔═╡ 5b856004-53bf-11ec-1910-fd54aaa95c14
md"""One of these three expressions will produce a different answer, select that one:
"""

# ╔═╡ 5b8569be-53bf-11ec-2bed-4106e20a1179
let
	choices = [
	q"2 - 3 - 4",
	q"(2 - 3) - 4",
	q"2 - (3 - 4)"
	];
	ans = 3;
	radioq(choices, ans)
end

# ╔═╡ 5b8569fa-53bf-11ec-2fd9-e39f00f544a4
md"""###### Question
"""

# ╔═╡ 5b856a54-53bf-11ec-12d2-a562cde69dc9
md"""One of these three expressions will produce a different answer, select that one:
"""

# ╔═╡ 5b85717a-53bf-11ec-3f8d-9517e2f8f7dd
let
	choices = [
	q"2 - 3 * 4",
	q"(2 - 3) * 4",
	q"2 - (3 * 4)"
	];
	ans = 2;
	radioq(choices, ans)
end

# ╔═╡ 5b857198-53bf-11ec-2d5e-0568d22fa3f2
md"""###### Question
"""

# ╔═╡ 5b8571ac-53bf-11ec-35f8-4b91641f0de2
md"""One of these three expressions will produce a different answer, select that one:
"""

# ╔═╡ 5b85785a-53bf-11ec-3f9c-35f390bf9ac2
let
	choices = [
	q"-1^2",
	q"(-1)^2",
	q"-(1^2)"
	];
	ans = 2;
	radioq(choices, ans)
end

# ╔═╡ 5b857882-53bf-11ec-32e3-b9bbd9bcbaf5
md"""###### Question
"""

# ╔═╡ 5b8578ca-53bf-11ec-1b2c-09b4afa1ae0c
md"""What is the value of $\sin(\pi/10)$?
"""

# ╔═╡ 5b857eae-53bf-11ec-3e3a-078a5aacc1bc
let
	val = sin(pi/10)
	numericq(val)
end

# ╔═╡ 5b857ed6-53bf-11ec-30a5-65e9042c076a
md"""###### Question
"""

# ╔═╡ 5b857f12-53bf-11ec-2d79-db62293fb902
md"""What is the value of $\sin(52^\circ)$?
"""

# ╔═╡ 5b8583fe-53bf-11ec-0e4e-a5ff7bd15ccc
let
	val = sind(52)
	numericq(val)
end

# ╔═╡ 5b858426-53bf-11ec-17f9-578896c8a629
md"""###### Question
"""

# ╔═╡ 5b85846a-53bf-11ec-2027-772101de9c49
md"""Is $\sin^{-1}(\sin(3\pi/2))$ equal to $3\pi/2$? (The "arc" functions do no use power notation, but instead a prefix of `a`.)
"""

# ╔═╡ 5b85875a-53bf-11ec-2a19-43cfd3ba86b2
let
	yesnoq(false)
end

# ╔═╡ 5b85877a-53bf-11ec-2882-71ed8bd29a47
md"""###### Question
"""

# ╔═╡ 5b8587de-53bf-11ec-17e3-716ad14ac02d
md"""What is the value of `round(3.5000)`
"""

# ╔═╡ 5b858b56-53bf-11ec-0dfa-9be05866738a
let
	numericq(round(3.5))
end

# ╔═╡ 5b858b6a-53bf-11ec-39b7-9d186f0d6aa2
md"""###### Question
"""

# ╔═╡ 5b858b88-53bf-11ec-0f66-2d6628f759c4
md"""What is the value of `sqrt(32 - 12)`
"""

# ╔═╡ 5b859042-53bf-11ec-0e17-655b8a4a38f1
let
	numericq(sqrt(32-12))
end

# ╔═╡ 5b859060-53bf-11ec-07e0-ef192fa7fa31
md"""###### Question
"""

# ╔═╡ 5b85907c-53bf-11ec-1c51-a7b12b72e766
md"""Which is greater $e^\pi$ or $\pi^e$?
"""

# ╔═╡ 5b859704-53bf-11ec-109c-8fd3c944443b
let
	choices = [
	raw"``e^{\pi}``",
	raw"``\pi^{e}``"
	];
	ans = exp(pi) - pi^exp(1) > 0 ? 1 : 2;
	radioq(choices, ans)
end

# ╔═╡ 5b859720-53bf-11ec-0b28-5bcc15970ec1
md"""###### Question
"""

# ╔═╡ 5b859740-53bf-11ec-201d-4d93664c1d34
md"""What is the value of $\pi - (x - \sin(x)/\cos(x))$ when $x=3$?
"""

# ╔═╡ 5b859b0a-53bf-11ec-3fb2-4134bf530ed4
let
	x = 3;
	ans = x - sin(x)/cos(x);
	numericq(pi - ans)
end

# ╔═╡ 5b859b2a-53bf-11ec-24c6-1b063ce1aa38
md"""###### Question
"""

# ╔═╡ 5b859b58-53bf-11ec-28ff-7df6245855eb
md"""Factorials in `Julia` are computed with the function `factorial`, not the postfix operator `!`, as with math notation. What is $10!$?
"""

# ╔═╡ 5b859f42-53bf-11ec-339b-81a939cf5892
let
	val = factorial(10)
	numericq(val)
end

# ╔═╡ 5b859f56-53bf-11ec-1d4a-c97e9f1fa8d0
md"""###### Question
"""

# ╔═╡ 5b859fba-53bf-11ec-0be3-75d6e0c13122
md"""Will `-2^2` produce `4` (which is a unary `-` evaluated *before* `^`) or `-4` (which is a unary `-` evaluated *after* `^`)?
"""

# ╔═╡ 5b85a4f6-53bf-11ec-292a-8d88d1ae3dc6
let
	choices = [q"4", q"-4"]
	ans = 2
	radioq(choices, ans)
end

# ╔═╡ 5b85a514-53bf-11ec-1bf5-cdf4cdfb014c
md"""###### Question
"""

# ╔═╡ 5b85a51e-53bf-11ec-0443-5daf2561f788
md"""A twitter post from popular mechanics generated some attention.
"""

# ╔═╡ 5b85a546-53bf-11ec-155d-d10e1d42df2c
md"""![](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/precalc/figures/order_operations_pop_mech.png)
"""

# ╔═╡ 5b85a5aa-53bf-11ec-275d-b5c9312f4c37
md"""What is the answer?
"""

# ╔═╡ 5b85ad7a-53bf-11ec-0eb8-ffea518fd3fa
let
	val = 8/2*(2+2)
	numericq(val)
end

# ╔═╡ 5b85adac-53bf-11ec-3c15-473d241853c9
md"""Does this expression return the *correct* answer using proper order of operations?
"""

# ╔═╡ 5b85b19e-53bf-11ec-25d9-1bc9f835f0ea
8÷2(2+2)

# ╔═╡ 5b85b374-53bf-11ec-1f41-c712441cb623
let
	yesnoq(false)
end

# ╔═╡ 5b85b388-53bf-11ec-1ccb-b351a5f62dcf
md"""Why or why not:
"""

# ╔═╡ 5b85c062-53bf-11ec-399d-41fc6158a3ff
let
	choices = [
	"The precedence of numeric literal coefficients used for implicit multiplication is higher than other binary operators such as multiplication (`*`), and division (`/`, `\\`, and `//`)",
	"Of course it is correct."
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 5b85c0d0-53bf-11ec-1540-3558ee560623
HTML("""<div class="markdown"><blockquote>
<p><a href="https://calculuswithjulia.github.io">◅ previous</a>  <a href="../precalc/variables.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/precalc/calculator.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 5b85c0da-53bf-11ec-37d2-2db04c82f5aa
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CalculusWithJulia = "~0.0.10"
DataFrames = "~1.2.2"
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
# ╟─5b85c0b2-53bf-11ec-22a2-83a606a50328
# ╟─5b20dbd4-53bf-11ec-3df8-7fc9e56510ab
# ╟─5b439016-53bf-11ec-3d26-ef10419b6903
# ╟─5b576c8a-53bf-11ec-31be-3f37352f2944
# ╟─5b576d5c-53bf-11ec-2b4f-6bfe6b396e5f
# ╟─5b5884b2-53bf-11ec-21e5-1bc0ffef89a3
# ╟─5b58a690-53bf-11ec-2605-63306f61f699
# ╟─5b5b0d9a-53bf-11ec-2f94-3b021baa4a00
# ╟─5b5b0e44-53bf-11ec-0945-ab3f020ae8f1
# ╟─5b5e90d2-53bf-11ec-02a0-a59cab315010
# ╟─5b5e91ae-53bf-11ec-3833-8d39c6aba3c7
# ╟─5b5eacc0-53bf-11ec-17d4-ed0d78424c27
# ╟─5b62d994-53bf-11ec-3666-4921963de1a6
# ╟─5b62da2a-53bf-11ec-27b2-e9e097268e94
# ╠═5b62e164-53bf-11ec-36d9-190d3f90b0d4
# ╟─5b62e1b4-53bf-11ec-2d90-1917d032bd7e
# ╟─5b677472-53bf-11ec-3a9f-59f46f2f18f6
# ╠═5b6783e0-53bf-11ec-0849-293096cd299c
# ╟─5b67846c-53bf-11ec-3ede-4d36207948e3
# ╟─5b67849e-53bf-11ec-38b1-818cd58f9ac3
# ╠═5b67886a-53bf-11ec-0f0e-d73b568cb83f
# ╟─5b6788a4-53bf-11ec-0b15-5980db46dc36
# ╠═5b678a70-53bf-11ec-263a-252601e68b6c
# ╟─5b678a98-53bf-11ec-2dea-954903ef9d11
# ╟─5b67dac0-53bf-11ec-3a47-5925a725808e
# ╟─5b6baec0-53bf-11ec-2de9-311cc59f3707
# ╟─5b6ecb0a-53bf-11ec-0f39-796a73f22bed
# ╟─5b6ecbbe-53bf-11ec-2a2c-67e74fbea510
# ╟─5b6ecbd2-53bf-11ec-1d07-b5cc97b8cadb
# ╠═5b6ed2ee-53bf-11ec-15a8-51272e9ce6bd
# ╟─5b6ed316-53bf-11ec-14fd-5b4b4434f0c4
# ╠═5b6ed5fa-53bf-11ec-1252-69c599901404
# ╟─5b6ed622-53bf-11ec-00b7-33990b1a5eea
# ╠═5b6ef6d6-53bf-11ec-0a0b-3d7df81cc978
# ╟─5b6ef74c-53bf-11ec-3bae-15a57ae60f5f
# ╠═5b6efe72-53bf-11ec-2fe4-73c6288d2165
# ╟─5b6efecc-53bf-11ec-3834-f9d62a14e5a8
# ╠═5b6f04b0-53bf-11ec-260c-bd6c5a47627d
# ╟─5b6f04f8-53bf-11ec-0e2d-47918074856f
# ╟─5b6f0514-53bf-11ec-0e44-295c6b32d474
# ╠═5b6f091a-53bf-11ec-0c3d-b572abfc4733
# ╟─5b6f0930-53bf-11ec-2636-fbffdd2e35c7
# ╟─5b6f0958-53bf-11ec-00a7-8be6abfbb054
# ╠═5b6f0e94-53bf-11ec-2a7a-d3a680bdb07b
# ╟─5b6f0eba-53bf-11ec-11b0-c5eb40644bf2
# ╟─5b6f0eda-53bf-11ec-085b-63fe73662477
# ╠═5b6f11fc-53bf-11ec-3e7f-3bdf5a8645a5
# ╟─5b6f1218-53bf-11ec-01dc-07556bf5156a
# ╟─5b6f122e-53bf-11ec-1ff7-193a69666f46
# ╟─5b6f124a-53bf-11ec-392a-175ce90f34a4
# ╠═5b6f160a-53bf-11ec-3fb1-5fde4085970b
# ╟─5b6f163c-53bf-11ec-3b4e-030d42e6c7d8
# ╟─5b6f165a-53bf-11ec-121f-9fd1a9766eec
# ╟─5b6f16f0-53bf-11ec-3433-5d91b6e59169
# ╟─5b6fcb56-53bf-11ec-1e22-ff1485b50616
# ╟─5b7a3788-53bf-11ec-0c8a-19e557a98739
# ╟─5b7a37e2-53bf-11ec-3397-fffac55b73cc
# ╠═5b7a51c8-53bf-11ec-2dfd-9d01dce0b046
# ╟─5b7a522c-53bf-11ec-25a3-991f19603a96
# ╠═5b7a593e-53bf-11ec-29d5-7f8a441b29a8
# ╟─5b7a597c-53bf-11ec-1083-e92efff69c4a
# ╠═5b7a6000-53bf-11ec-1da4-3f070a9203bc
# ╟─5b7a6046-53bf-11ec-3749-a72af45f383f
# ╟─5b7a605a-53bf-11ec-032e-2bbe8db15c57
# ╟─5b7a60aa-53bf-11ec-1825-a7b5d99836d5
# ╠═5b7a65dc-53bf-11ec-103d-f77197e23b64
# ╟─5b7a6604-53bf-11ec-2ce8-a129849e11f2
# ╟─5b7a6640-53bf-11ec-2d1d-edc477bc818b
# ╠═5b7a6c12-53bf-11ec-18b8-6b6d84d9342e
# ╟─5b7a6c32-53bf-11ec-1241-f7bab03ba409
# ╟─5b7a6c58-53bf-11ec-3c4b-b78d4d3dfeee
# ╠═5b7a897c-53bf-11ec-05c2-37707252b82d
# ╟─5b7a89c2-53bf-11ec-1ad3-d92c74ecc9c9
# ╟─5b7a89fe-53bf-11ec-1ca9-f9490db1601d
# ╠═5b7a8ee0-53bf-11ec-042c-8ba5d2497214
# ╟─5b7a8f08-53bf-11ec-27a2-a70512279704
# ╟─5b7a8f30-53bf-11ec-16bd-dbc85792b104
# ╟─5b7a8f44-53bf-11ec-2d0c-d99211f90cee
# ╟─5b7d6de0-53bf-11ec-2c52-718495755c9b
# ╟─5b7d6f20-53bf-11ec-1688-6b8402a1dda7
# ╟─5b7d6f48-53bf-11ec-3d46-45e48f4ef417
# ╟─5b7d6f5e-53bf-11ec-2a89-859fedd42b7a
# ╠═5b7d77c2-53bf-11ec-3903-414bb3f46d3b
# ╟─5b7d77ea-53bf-11ec-28bb-875133dc91c4
# ╠═5b7d7b82-53bf-11ec-3b4e-a546b00d579c
# ╟─5b7db0ac-53bf-11ec-3082-ed5f3e1f7272
# ╟─5b7db124-53bf-11ec-1dfd-e3b7547830e2
# ╟─5b7db1a6-53bf-11ec-191b-c93a6f342a8a
# ╟─5b7dbf84-53bf-11ec-1552-93acb0c30137
# ╟─5b7dbfd4-53bf-11ec-30f0-e386e113fab2
# ╟─5b7dc010-53bf-11ec-038e-27788a6cef12
# ╠═5b7dc16e-53bf-11ec-22a9-33553c33ef32
# ╟─5b7dc1be-53bf-11ec-2518-47ac514afd6a
# ╠═5b7dc33a-53bf-11ec-0b89-a164e0588888
# ╟─5b7de4dc-53bf-11ec-3ec5-2d71e1734acc
# ╟─5b7dfd78-53bf-11ec-2399-fbc21a7ae69c
# ╟─5b7dfddc-53bf-11ec-213f-f1e1901e98f6
# ╠═5b7e035e-53bf-11ec-2bd9-353ddc04f6d2
# ╟─5b7e0e64-53bf-11ec-1e2f-37b5d89ee734
# ╟─5b7e0e9e-53bf-11ec-1c37-75021f542d11
# ╟─5b7e0f02-53bf-11ec-2329-85effd6613bf
# ╠═5b7e136c-53bf-11ec-33ce-89e9a381e1fb
# ╟─5b7e1394-53bf-11ec-1c75-13d09fa2ad1c
# ╟─5b7e13a8-53bf-11ec-1dd5-19aa6d1d7224
# ╠═5b7e163c-53bf-11ec-2dfb-b39cf2651cb0
# ╟─5b7e1670-53bf-11ec-1f67-41ed506c580e
# ╠═5b7e384c-53bf-11ec-27bc-9b9682cce5d5
# ╟─5b7e3888-53bf-11ec-1e04-1d01bb5afad5
# ╟─5b7e389c-53bf-11ec-2c52-c5446f7c7b4d
# ╟─5b7e38ec-53bf-11ec-09ab-716dd957dd24
# ╟─5b7e398c-53bf-11ec-0849-5bdefb595d14
# ╟─5b7e3994-53bf-11ec-246b-d7300165f4ad
# ╟─5b7e3e46-53bf-11ec-1409-7f1393c7d290
# ╟─5b7e3e70-53bf-11ec-1dff-a3ca55eaff97
# ╠═5b7e418e-53bf-11ec-017d-93b3891b18ee
# ╟─5b7e41de-53bf-11ec-2da3-b573b292dac5
# ╟─5b7e41f2-53bf-11ec-24c8-a3335c136a35
# ╠═5b7e62a4-53bf-11ec-2611-97906bda10eb
# ╟─5b7e7802-53bf-11ec-3dbb-2d7382957f1b
# ╟─5b7e783e-53bf-11ec-0141-7bb917055fa6
# ╟─5b7e78ac-53bf-11ec-3746-47387d9a5850
# ╟─5b7e78c0-53bf-11ec-2ada-1be6257215e8
# ╠═5b7e7e56-53bf-11ec-2fe5-233237e26de2
# ╟─5b7e7e92-53bf-11ec-1946-eb3eb080d060
# ╟─5b7e7ea6-53bf-11ec-2663-59ef4d5fce84
# ╟─5b7e7ed8-53bf-11ec-3747-237ee8186a7b
# ╟─5b7e7f0a-53bf-11ec-1293-73e056c7b7d6
# ╠═5b7e834c-53bf-11ec-1a1e-fd4cb4b0be8f
# ╟─5b7e836a-53bf-11ec-184b-7dc6f08f5b23
# ╟─5b7e8390-53bf-11ec-28ce-0761f86bcf09
# ╠═5b7e8a18-53bf-11ec-212c-f702c8e56d99
# ╟─5b7e8a2c-53bf-11ec-00a5-a11ff95f1f63
# ╟─5b7e8a54-53bf-11ec-263b-3541efff4a5a
# ╠═5b7e9094-53bf-11ec-1502-e5636663312d
# ╟─5b7e90b2-53bf-11ec-346f-55d439c534b3
# ╟─5b7e90d0-53bf-11ec-317f-a3d949c3388d
# ╠═5b7e94fe-53bf-11ec-0326-2b1217dd7828
# ╟─5b7e951c-53bf-11ec-06ef-d1603c2b356e
# ╟─5b7e954e-53bf-11ec-172f-c1a67456a193
# ╟─5b7e956c-53bf-11ec-1609-b92111a39ddb
# ╠═5b7e97ba-53bf-11ec-3e4b-130eb330966a
# ╟─5b7e97d8-53bf-11ec-2389-05ed9388755d
# ╟─5b7e981e-53bf-11ec-11c5-f70d4c34eb37
# ╠═5b7e99ea-53bf-11ec-0a16-b7f6857df538
# ╟─5b7e9a6c-53bf-11ec-24bb-1957d6815c0b
# ╠═5b7eb448-53bf-11ec-1531-3ded2e6eb48a
# ╟─5b7eb4ac-53bf-11ec-3da3-9d449353b28a
# ╟─5b7ed25c-53bf-11ec-0bea-8bed00afe502
# ╟─5b7ed2c0-53bf-11ec-15a9-8138d1aaea08
# ╟─5b806752-53bf-11ec-3840-6f1fd71c1ccf
# ╟─5b80684e-53bf-11ec-1383-9ffb8f38f2ef
# ╟─5b806892-53bf-11ec-0013-c3ae55c147cf
# ╟─5b8068ba-53bf-11ec-23e4-dd8cdb9f137f
# ╟─5b80693c-53bf-11ec-1e4f-b7469b94e24f
# ╠═5b8071b6-53bf-11ec-2152-5742d0aab546
# ╟─5b807226-53bf-11ec-2b70-2795ab1ec90c
# ╠═5b807878-53bf-11ec-15e8-79e50c32a6fc
# ╟─5b8078fc-53bf-11ec-1088-63a2692c0e52
# ╠═5b807f80-53bf-11ec-3a88-49d9aa5620a0
# ╟─5b807fb2-53bf-11ec-3f0b-911d1b44430d
# ╟─5b807fd2-53bf-11ec-29a4-236df6274512
# ╟─5b80803e-53bf-11ec-0890-4d80c18f0fb0
# ╟─5b848d0a-53bf-11ec-2a3f-e13ee1612d79
# ╟─5b848dfc-53bf-11ec-0be7-f17e28c1d33c
# ╟─5b8498cc-53bf-11ec-2a40-55be97b5e0bf
# ╟─5b84991c-53bf-11ec-00ed-2bdb17cc4860
# ╟─5b8499e4-53bf-11ec-1abc-cbe4a506b7fc
# ╟─5b84a01a-53bf-11ec-179d-d1f856e71440
# ╟─5b84a128-53bf-11ec-3a32-117f5489c0bd
# ╟─5b84a15a-53bf-11ec-27f6-41fd4b9c7a91
# ╟─5b84a79a-53bf-11ec-36e5-412d8885ef04
# ╟─5b84a7b8-53bf-11ec-11c6-598a9a9c1170
# ╟─5b84a7d6-53bf-11ec-24c3-25ad0ebc93f0
# ╟─5b84a826-53bf-11ec-10f4-493d61238f88
# ╟─5b84b4f4-53bf-11ec-08d5-91b399e29996
# ╟─5b84b526-53bf-11ec-3ebb-e1899061ce5b
# ╟─5b84b56e-53bf-11ec-09ee-c9e74001a90f
# ╟─5b84b58c-53bf-11ec-02b9-417b2be7724f
# ╟─5b84c678-53bf-11ec-180c-af7d9a7bd67f
# ╟─5b84c6b2-53bf-11ec-2629-89a2d134ec55
# ╟─5b84c6d8-53bf-11ec-340f-b5f010d277ed
# ╟─5b84c6f8-53bf-11ec-161d-e331c39053eb
# ╟─5b84d1e6-53bf-11ec-35e7-f198767bfd03
# ╟─5b84d210-53bf-11ec-3283-dbe6d0eabe34
# ╟─5b84d242-53bf-11ec-2042-737ed1dd5de7
# ╟─5b84d260-53bf-11ec-3a3e-f9277327ab5b
# ╟─5b84dd28-53bf-11ec-1676-4f9db523f878
# ╟─5b84dd5a-53bf-11ec-3a89-a9ad2d6f5e02
# ╟─5b84dd8c-53bf-11ec-06d6-156496732a88
# ╟─5b84ddaa-53bf-11ec-2436-511ae3d97cff
# ╟─5b84ec5a-53bf-11ec-0858-7b32691599c8
# ╟─5b84ec8c-53bf-11ec-0b52-7b75eea2d82d
# ╟─5b84ecb4-53bf-11ec-2cca-379d97719953
# ╟─5b84ecd2-53bf-11ec-2d1c-29bb132582ea
# ╟─5b84ecde-53bf-11ec-2265-6df4bacd4b02
# ╟─5b84fbb4-53bf-11ec-1c0d-6fbeda015f6f
# ╟─5b84fbf2-53bf-11ec-0d32-e52a45d802c9
# ╟─5b84fc18-53bf-11ec-1978-6748af4ed918
# ╟─5b84fc2c-53bf-11ec-1d04-d1411cc8ca22
# ╟─5b84fc36-53bf-11ec-11c1-8fa43ee6f44d
# ╟─5b850384-53bf-11ec-143b-9b4c363b0d1d
# ╟─5b8503b6-53bf-11ec-1e47-5361244170cf
# ╟─5b8503de-53bf-11ec-193b-e98243c3e755
# ╟─5b8503f2-53bf-11ec-02a3-39814fec98de
# ╟─5b850438-53bf-11ec-3d2f-5b145a72bd9d
# ╟─5b850ae6-53bf-11ec-34e7-2d3788a0f5ed
# ╟─5b850b06-53bf-11ec-103e-7739e1d19e84
# ╟─5b850b22-53bf-11ec-1731-c1b2900b5a34
# ╟─5b850fbe-53bf-11ec-1d15-05075c5ed0fc
# ╟─5b850fe6-53bf-11ec-289f-a3953146fc6c
# ╟─5b851022-53bf-11ec-1843-cf5713a6a405
# ╟─5b855f14-53bf-11ec-01ab-2d5174928001
# ╟─5b855fe6-53bf-11ec-09c6-a36060c62ef7
# ╟─5b856004-53bf-11ec-1910-fd54aaa95c14
# ╟─5b8569be-53bf-11ec-2bed-4106e20a1179
# ╟─5b8569fa-53bf-11ec-2fd9-e39f00f544a4
# ╟─5b856a54-53bf-11ec-12d2-a562cde69dc9
# ╟─5b85717a-53bf-11ec-3f8d-9517e2f8f7dd
# ╟─5b857198-53bf-11ec-2d5e-0568d22fa3f2
# ╟─5b8571ac-53bf-11ec-35f8-4b91641f0de2
# ╟─5b85785a-53bf-11ec-3f9c-35f390bf9ac2
# ╟─5b857882-53bf-11ec-32e3-b9bbd9bcbaf5
# ╟─5b8578ca-53bf-11ec-1b2c-09b4afa1ae0c
# ╟─5b857eae-53bf-11ec-3e3a-078a5aacc1bc
# ╟─5b857ed6-53bf-11ec-30a5-65e9042c076a
# ╟─5b857f12-53bf-11ec-2d79-db62293fb902
# ╟─5b8583fe-53bf-11ec-0e4e-a5ff7bd15ccc
# ╟─5b858426-53bf-11ec-17f9-578896c8a629
# ╟─5b85846a-53bf-11ec-2027-772101de9c49
# ╟─5b85875a-53bf-11ec-2a19-43cfd3ba86b2
# ╟─5b85877a-53bf-11ec-2882-71ed8bd29a47
# ╟─5b8587de-53bf-11ec-17e3-716ad14ac02d
# ╟─5b858b56-53bf-11ec-0dfa-9be05866738a
# ╟─5b858b6a-53bf-11ec-39b7-9d186f0d6aa2
# ╟─5b858b88-53bf-11ec-0f66-2d6628f759c4
# ╟─5b859042-53bf-11ec-0e17-655b8a4a38f1
# ╟─5b859060-53bf-11ec-07e0-ef192fa7fa31
# ╟─5b85907c-53bf-11ec-1c51-a7b12b72e766
# ╟─5b859704-53bf-11ec-109c-8fd3c944443b
# ╟─5b859720-53bf-11ec-0b28-5bcc15970ec1
# ╟─5b859740-53bf-11ec-201d-4d93664c1d34
# ╟─5b859b0a-53bf-11ec-3fb2-4134bf530ed4
# ╟─5b859b2a-53bf-11ec-24c6-1b063ce1aa38
# ╟─5b859b58-53bf-11ec-28ff-7df6245855eb
# ╟─5b859f42-53bf-11ec-339b-81a939cf5892
# ╟─5b859f56-53bf-11ec-1d4a-c97e9f1fa8d0
# ╟─5b859fba-53bf-11ec-0be3-75d6e0c13122
# ╟─5b85a4f6-53bf-11ec-292a-8d88d1ae3dc6
# ╟─5b85a514-53bf-11ec-1bf5-cdf4cdfb014c
# ╟─5b85a51e-53bf-11ec-0443-5daf2561f788
# ╟─5b85a546-53bf-11ec-155d-d10e1d42df2c
# ╟─5b85a5aa-53bf-11ec-275d-b5c9312f4c37
# ╟─5b85ad7a-53bf-11ec-0eb8-ffea518fd3fa
# ╟─5b85adac-53bf-11ec-3c15-473d241853c9
# ╠═5b85b19e-53bf-11ec-25d9-1bc9f835f0ea
# ╟─5b85b374-53bf-11ec-1f41-c712441cb623
# ╟─5b85b388-53bf-11ec-1ccb-b351a5f62dcf
# ╟─5b85c062-53bf-11ec-399d-41fc6158a3ff
# ╟─5b85c0d0-53bf-11ec-1540-3558ee560623
# ╟─5b85c0da-53bf-11ec-182a-a9d7797286e1
# ╟─5b85c0da-53bf-11ec-37d2-2db04c82f5aa
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
