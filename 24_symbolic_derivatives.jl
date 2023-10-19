### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ a8e1b2b8-539b-11ec-00f2-41ad0110e315
using TermInterface

# ╔═╡ a8e52ab0-539b-11ec-22a3-f5b0ba6ed150
using PlutoUI

# ╔═╡ a8e52a60-539b-11ec-1e28-5fbba2937b72
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ a8e0f9e0-539b-11ec-1746-17637e93da57
md"""# Symbolic derivatives
"""

# ╔═╡ a8e0fde6-539b-11ec-2a2c-6700bca8ab87
md"""This section uses this add-on package:
"""

# ╔═╡ a8e207ae-539b-11ec-27ea-1ff324c175a8
md"""---
"""

# ╔═╡ a8e2093e-539b-11ec-1d02-f7929be50981
md"""The ability to breakdown an expression into operations and their arguments is necessary when trying to apply the differentiation rules. Such rules are applied from the outside in. Identifying the proper "outside" function is usually most of the battle when finding derivatives.
"""

# ╔═╡ a8e209d4-539b-11ec-1a86-69d497fc97e7
md"""In the following example, we provide a sketch of a framework to differentiate expressions by a chosen symbol to illustrate how the outer function drives the task of differentiation.
"""

# ╔═╡ a8e2236a-539b-11ec-0d07-51b266713234
md"""The `Symbolics` package provides native symbolic manipulation abilities for `Julia`, similar to `SymPy`, though without the dependence on `Python`. The `TermInterface` package provides a generic interface for expression manipulation for this package that *also* is implemented for `Julia`'s expressions and symbols.
"""

# ╔═╡ a8e223a6-539b-11ec-0548-c740717da044
md"""An expression is an unevaluated portion of code that for our purposes below contains other expressions, symbols, and numeric literals. They are held in the `Expr` type.  A symbol, such as `:x`, is distinct from a string (e.g. `"x"`) and is useful to the programmer to distinguish between the contents a variable points to from the name of the variable. Symbols are fundamental to metaprogramming in `Julia`. An expression is a specification of some set of statements to execute. A numeric literal is just a number.
"""

# ╔═╡ a8e22414-539b-11ec-0884-35bc9103b91f
md"""The three main functions from `TermInterface` we leverage are `istree`, `operation`, and `arguments`. The `operation` function returns the "outside" function of an expression. For example:
"""

# ╔═╡ a8e285dc-539b-11ec-0310-6d9d111f1289
operation(:(sin(x)))

# ╔═╡ a8e2874c-539b-11ec-34e2-59df1dc6ee59
md"""We see the `sin` function, referred to  by a symbol (`:sin`). The `:(...)` above *quotes* the argument, and does not evaluate it, hence `x` need not be defined above. (The `:` notation is used to create both symbols and expressions.)
"""

# ╔═╡ a8e29f7a-539b-11ec-38d4-ab7a26364d54
md"""The arguments are the terms that the outside function is called on. For our purposes there may be $1$ (*unary*), $2$ (*binary*), or more than $2$ (*nary*) arguments. For example:
"""

# ╔═╡ a8e2d6c0-539b-11ec-20c2-db61e052b77a
arguments(:(-x)), arguments(:(pi^2)), arguments(:(1 + x + x^2))

# ╔═╡ a8e2d760-539b-11ec-19a7-ff2ce80ed6a5
md"""(The last one may be surprising, but all three arguments are passed to the `+` function.)
"""

# ╔═╡ a8e2d882-539b-11ec-2677-af1945d1c344
md"""Here we define a function to decide the *arity* of an expression based on the number of arguments it is called with:
"""

# ╔═╡ a8e38090-539b-11ec-2af3-a5b46aa1e041
function arity(ex)
		n = length(arguments(ex))
		n == 1 ? Val(:unary) :
		n == 2 ? Val(:binary) : Val(:nary)
end

# ╔═╡ a8e3992a-539b-11ec-3456-61058f75b2eb
md"""Differentiation must distinguish between expressions, variables, and numbers.  Mathematically expressions have an "outer" function, where as variables and numbers can be directly differentiated.  The `istree` function in `TermInterface` returns `true` when passed an expression, and `false` when passed a symbol or numeric literal. The latter two may be distinguished by `isa(..., Symbol)`.
"""

# ╔═╡ a8e39a80-539b-11ec-039f-a747d94993fe
md"""Here we create a function, `D`, that when it encounters an expression it *dispatches* to a specific method of `D` based on the outer operation and arity, otherwise if it encounters a symbol or a numeric literal it does the differentiation:
"""

# ╔═╡ a8e3bbaa-539b-11ec-1ac7-d70e242399bc
function D(ex, var=:x)
	if istree(ex)
		op, args = operation(ex), arguments(ex)
		D(Val(op), arity(ex), args, var)
	elseif isa(ex, Symbol) && ex == :x
		1
	else
		0
	end
end

# ╔═╡ a8e3bc2a-539b-11ec-23fe-75a1daacb24a
md"""Now to develop methods for `D` for different "outside" functions and arities.
"""

# ╔═╡ a8e3bce8-539b-11ec-1113-e509d397321f
md"""Addition can be unary (`:(+x)` is a valid quoting, even if it might simplify to the symbol `:x` when evaluated), *binary*, or *nary*. Here we implement the *sum rule*:
"""

# ╔═╡ a8e4154c-539b-11ec-17d8-e93315f8a074
begin
	D(::Val{:+}, ::Val{:unary}, args, var) = D(first(args), var)
	
	function D(::Val{:+}, ::Val{:binary}, args, var)
		a′, b′ = D.(args, var)
		:($a′ + $b′)
	end
	
	function D(::Val{:+}, ::Val{:nary}, args, var)
		a′s = D.(args, var)
		:(+($a′s...))
	end
end

# ╔═╡ a8e41602-539b-11ec-3932-e9bc75dd9fd6
md"""The `args` are always held in a container, so the unary method must pull out the first one. The binary case should read as: apply `D` to each of the two arguments, and then create a quoted expression containing the sum of the results. The dollar signs interpolate into the quoting. (The "primes" are unicode notation achieved through `\prime[tab]` and not operations.) The *nary* case does something similar, only uses splatting to produce the sum.
"""

# ╔═╡ a8e416ac-539b-11ec-2450-0b8509ea89f6
md"""Subtraction must also be implemented in a similar manner, but not for the *nary* case:
"""

# ╔═╡ a8e47930-539b-11ec-085a-f549166cf038
begin
	function D(::Val{:-}, ::Val{:unary}, args, var)
		a′ = D(first(args), var)
		:(-$a′)
	end
	function D(::Val{:-}, ::Val{:binary}, args, var)
		a′, b′ = D.(args, var)
		:($a′ - $b′)
	end
end

# ╔═╡ a8e47b56-539b-11ec-3a86-7f343a1ca33f
md"""The *product rule* is similar to addition, in that $3$ cases are considered:
"""

# ╔═╡ a8e4893e-539b-11ec-2b4b-f522159466fb
begin
	D(op::Val{:*}, ::Val{:unary}, args, var) = D(first(args), var)
	
	function D(::Val{:*}, ::Val{:binary}, args, var)
	    a,b = args
	    a′, b′ = D.(args, var)
	    :($a′ * $b + $a * $b′)
	end
	
	function D(op::Val{:*}, ::Val{:nary}, args, var)
	    a, bs... = args
	    b = :(*($bs...))
	    b′ = D(op, bs, var)
		:($a′ * $b + $a * $b′)
	end
end

# ╔═╡ a8e48a18-539b-11ec-1d16-f1b7e991436a
md"""Division is only a binary operation, so here we have the *quotient rule*:
"""

# ╔═╡ a8e4c930-539b-11ec-0fb3-75d2f6566c70
	function D(::Val{:/}, ::Val{:binary}, args, var)
	   	u,v = args
		u′, v′ = D(u, var), D(v, var)
		:( ($u′*$v - $u*$v′)/$v^2 )
	end

# ╔═╡ a8e4ca3c-539b-11ec-3c70-151c76af7755
md"""Powers are handled a bit differently. The power rule would require checking if the exponent does not contain the variable of differentiation, exponential derivatives would require checking the base does not contain the variable of differentation. Trying to implement both would be tedious, so we use the fact that $x = \exp(\log(x))$ (for `x` in the domain of `log`, more care is necessary if `x` is negative) to differentiate:
"""

# ╔═╡ a8e4d7d6-539b-11ec-0f81-517388294b1f
function D(::Val{:^}, ::Val{:binary}, args, var)
	a, b = args
    D(:(exp($b*log($a))), var)  # a > 0 assumed here
end

# ╔═╡ a8e4d876-539b-11ec-344c-4525c89272b8
md"""That leaves the task of defining a rule to differentiate both `exp` and `log`. We do so with *unary* definitions. In the following we also implement `sin` and `cos` rules:
"""

# ╔═╡ a8e4e5f0-539b-11ec-19eb-6f695dae7296
begin
	function D(::Val{:exp}, ::Val{:unary}, args, var)
		a = first(args)
		a′ = D(a, var)
		:(exp($a) * $a′)
	end
	
	function D(::Val{:log}, ::Val{:unary}, args, var)
		a = first(args)
		a′ = D(a, var)
		:(1/$a * $a′)
	end
	
	function D(::Val{:sin}, ::Val{:unary}, args, var)
		a = first(args)
		a′ = D(a, var)
		:(cos($a) * $a′)
	end
	
	function D(::Val{:cos}, ::Val{:unary}, args, var)
		a = first(args)
		a′ = D(a, var)
		:(-sin($a) * $a′)
	end
end

# ╔═╡ a8e4e6b8-539b-11ec-1b3f-df2a68a9f67e
md"""The pattern is similar for each. The `$a′` factor is needed due to the *chain rule*. The above illustrates the simple pattern necessary to add a derivative rule for a function. More could be, but for this example the above will suffice, as now the system is ready to be put to work.
"""

# ╔═╡ a8e4ed66-539b-11ec-23a0-31e85f9fe82c
begin
	ex₁ = :(x + 2/x)
	D(ex₁, :x)
end

# ╔═╡ a8e4edca-539b-11ec-275a-2d6b906fd4e2
md"""The output does not simplify, so some work is needed to identify `1 - 2/x^2` as the answer.
"""

# ╔═╡ a8e4f482-539b-11ec-20d5-eba6a87c5519
begin
	ex₂ = :( (x + sin(x))/sin(x))
	D(ex₂, :x)
end

# ╔═╡ a8e4f50c-539b-11ec-37f5-25c3fefbd72a
md"""Again, simplification is not performed.
"""

# ╔═╡ a8e4f55e-539b-11ec-3e40-0373d3aa0aac
md"""Finally, we have a second derivative taken below:
"""

# ╔═╡ a8e52902-539b-11ec-361d-49c894d69d82
begin
	ex₃ = :(sin(x) - x - x^3/6)
	D(D(ex₃, :x), :x)
end

# ╔═╡ a8e529d4-539b-11ec-2b61-af2872929fe6
md"""The length of the expression should lead to further appreciation for simplification steps taken when doing such a computation by hand.
"""

# ╔═╡ a8e52ab0-539b-11ec-31c6-2d6af9714f27
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/numeric_derivatives.html">◅ previous</a>  <a href="../derivatives/mean_value_theorem.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/symbolic_derivatives.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ a8e52af8-539b-11ec-03e0-c9f3bbedd6d5
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
TermInterface = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"

[compat]
PlutoUI = "~0.7.21"
TermInterface = "~0.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TermInterface]]
git-tree-sha1 = "7aa601f12708243987b88d1b453541a75e3d8c7a"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.2.3"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─a8e52a60-539b-11ec-1e28-5fbba2937b72
# ╟─a8e0f9e0-539b-11ec-1746-17637e93da57
# ╟─a8e0fde6-539b-11ec-2a2c-6700bca8ab87
# ╠═a8e1b2b8-539b-11ec-00f2-41ad0110e315
# ╟─a8e207ae-539b-11ec-27ea-1ff324c175a8
# ╟─a8e2093e-539b-11ec-1d02-f7929be50981
# ╟─a8e209d4-539b-11ec-1a86-69d497fc97e7
# ╟─a8e2236a-539b-11ec-0d07-51b266713234
# ╟─a8e223a6-539b-11ec-0548-c740717da044
# ╟─a8e22414-539b-11ec-0884-35bc9103b91f
# ╠═a8e285dc-539b-11ec-0310-6d9d111f1289
# ╟─a8e2874c-539b-11ec-34e2-59df1dc6ee59
# ╟─a8e29f7a-539b-11ec-38d4-ab7a26364d54
# ╠═a8e2d6c0-539b-11ec-20c2-db61e052b77a
# ╟─a8e2d760-539b-11ec-19a7-ff2ce80ed6a5
# ╟─a8e2d882-539b-11ec-2677-af1945d1c344
# ╠═a8e38090-539b-11ec-2af3-a5b46aa1e041
# ╟─a8e3992a-539b-11ec-3456-61058f75b2eb
# ╟─a8e39a80-539b-11ec-039f-a747d94993fe
# ╠═a8e3bbaa-539b-11ec-1ac7-d70e242399bc
# ╟─a8e3bc2a-539b-11ec-23fe-75a1daacb24a
# ╟─a8e3bce8-539b-11ec-1113-e509d397321f
# ╠═a8e4154c-539b-11ec-17d8-e93315f8a074
# ╟─a8e41602-539b-11ec-3932-e9bc75dd9fd6
# ╟─a8e416ac-539b-11ec-2450-0b8509ea89f6
# ╠═a8e47930-539b-11ec-085a-f549166cf038
# ╟─a8e47b56-539b-11ec-3a86-7f343a1ca33f
# ╠═a8e4893e-539b-11ec-2b4b-f522159466fb
# ╟─a8e48a18-539b-11ec-1d16-f1b7e991436a
# ╠═a8e4c930-539b-11ec-0fb3-75d2f6566c70
# ╟─a8e4ca3c-539b-11ec-3c70-151c76af7755
# ╠═a8e4d7d6-539b-11ec-0f81-517388294b1f
# ╟─a8e4d876-539b-11ec-344c-4525c89272b8
# ╠═a8e4e5f0-539b-11ec-19eb-6f695dae7296
# ╟─a8e4e6b8-539b-11ec-1b3f-df2a68a9f67e
# ╠═a8e4ed66-539b-11ec-23a0-31e85f9fe82c
# ╟─a8e4edca-539b-11ec-275a-2d6b906fd4e2
# ╠═a8e4f482-539b-11ec-20d5-eba6a87c5519
# ╟─a8e4f50c-539b-11ec-37f5-25c3fefbd72a
# ╟─a8e4f55e-539b-11ec-3e40-0373d3aa0aac
# ╠═a8e52902-539b-11ec-361d-49c894d69d82
# ╟─a8e529d4-539b-11ec-2b61-af2872929fe6
# ╟─a8e52ab0-539b-11ec-31c6-2d6af9714f27
# ╟─a8e52ab0-539b-11ec-22a3-f5b0ba6ed150
# ╟─a8e52af8-539b-11ec-03e0-c9f3bbedd6d5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
