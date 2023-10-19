### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ a145e2fe-a903-11eb-160f-df7ea83fa3e6
begin
	using PlotlyBase
	using HypertextLiteral
	using PlutoUI
	using LinearAlgebra
	using Symbolics
	using Symbolics:@variables	
end

# ╔═╡ 15d7b793-6e8f-4b78-a40e-a79406578550
html"<button onclick=present()>Present</button>"

# ╔═╡ 943edb36-acc8-4b2a-94ab-c544f9eb279b
md"""
# II - Linear Algebra

## A quick introduction to Julia and Pluto

**Macroeconomics (M8674), ISCTE-IUL**
"""

# ╔═╡ 1245aef9-18ce-42f5-af82-c2e6cce70798
md"""
**Vivaldo Mendes, September 2021**
"""

# ╔═╡ a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
html"""<style>
main {
    max-width: 900px;
    align-self: flex-start;
    margin-left: 100px;
}
"""


# ╔═╡ 9fa87191-7c90-4738-a45a-acd929c8bd1b
  TableOfContents()

# ╔═╡ 4618a663-f77e-4ccc-9b00-e84dbd5beb34
md"""
## Packages we need in this notebook
"""

# ╔═╡ 1c787d91-ffdd-489e-a755-c0ab12272585
md"""
The next cell includes code to allow PLotlyJS to work inside Pluto. It will be kept hidden in this notebook. **Do not delete it.**
"""

# ╔═╡ 74de9f66-d5b4-4e0f-a75d-5177b1842191
begin
	function Base.show(io::IO, mimetype::MIME"text/html", plt::PlotlyBase.Plot)
       # Remove responsive flag on the plot as we handle responsibity via ResizeObeserver and leaving it on makes the div flickr during updates
	hasproperty(plt,:config) && plt.config.responsive && (plt.config.responsive = false)   
	show(io,mimetype, @htl("""
			<div>
			<script id=asdf>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.2.0.min.js")
			const PLOT = this ?? document.createElement("div");
		

		
			Plotly.react(PLOT, $(HypertextLiteral.JavaScript(PlotlyBase.json(plt))));


		
			const pluto_output = currentScript.parentElement.closest('pluto-output')

			const resizeObserver = new ResizeObserver(entries => {
				Plotly.Plots.resize(PLOT)
			})

			resizeObserver.observe(pluto_output)

			invalidation.then(() => {
				resizeObserver.disconnect()
			})
		
			return PLOT
			</script>
			</div>
	"""))
	end
end

# ╔═╡ 9a963cbc-78fe-4a90-a791-bd69cbb8e5dd
md"""
# 1. Broadcasting
"""

# ╔═╡ 1b5f13b2-b126-40c4-936f-34db443547b6
md"""
Before exemplifying the basic algebra operations, it is crucial to stress one particular point: **operations with arrays that do not obey the rules of algebra**. Consider the following example:
"""

# ╔═╡ 1ed1b272-f6bd-4f57-a438-49812ff7a072
Skip = [1  2  3]

# ╔═╡ 1deee867-66c3-445c-87d7-897a55b68030
Maurice =[1 ; 2 ; 3]

# ╔═╡ b0cdf557-a76a-4ba0-bd64-0d6880f2e4e5
	Eva = [1, 2, 3]


# ╔═╡ d3fb3ad5-b106-43ec-8c18-aa975c068b47
typeof(Eva)

# ╔═╡ 488674bf-ab74-416f-b38f-3f03856159a0
typeof(Skip)

# ╔═╡ c4e36a06-7806-4835-9c40-9d1682936da9
typeof(Maurice)

# ╔═╡ d3a4daef-f35d-4b5a-92a0-accc15051e6d
Skip+Maurice

# ╔═╡ 3b969b09-d4e0-484c-9bdb-c077152b6124
Maurice*Eva

# ╔═╡ aca57619-8f5b-4490-8367-2d2416e7881c
Skip.+Maurice

# ╔═╡ da06b143-075d-4dff-90fb-e6d3cfdb5a33
Maurice.*Eva

# ╔═╡ e09302d6-2e28-4565-a84e-04dfa9335a34
Skip.^2

# ╔═╡ d62b266e-07bd-4388-ae27-2c4f1860382a
Skip+Skip

# ╔═╡ 4cb0f3fe-83b0-4b8d-b52f-b35e093b1bb7
Eva+Maurice

# ╔═╡ 41396532-b1c1-4bb3-bb6f-b003b7c98cdb


# ╔═╡ c39831b8-7a25-4104-8f75-b6f44d2b0ce8
md"""
# 2. Linear algebra operations
"""

# ╔═╡ 42c36143-a434-4715-8f91-2c536a0faa18
md"""
## Basic operations
"""

# ╔═╡ 3ac6a190-07b3-4ce6-b417-ec4eddf53b23
Bia = [0  3  5 ; -2  9  0 ; 1  1  1 ] 

# ╔═╡ 1888712e-aba9-402a-abe8-73f6604719d4
Bia'

# ╔═╡ cfeec38a-85dd-4738-bb2d-fb8b03e8206b
inv(Bia) # inverse of A

# ╔═╡ 706c5a01-9ff9-4af0-8b04-1e68c5aaaa7c
det(Bia)

# ╔═╡ a9647d48-3f08-464a-a51c-c2481850257f
rank(Bia) # rank of Bia (maximal number of linearly independent columns)

# ╔═╡ c758f930-81e1-46e8-beec-0050abed5ad1
tr(Bia) # trace of Bia (the sum of elements on the main diagonal)

# ╔═╡ 7e7b8ec2-1446-47ec-a149-8fc5a75e0652
norm(Bia) # The Euclidean norm

# ╔═╡ 92f0a000-d193-41f4-9018-44bed26b904a
Bia^2 # the square of A

# ╔═╡ dfb101ff-7948-4c8f-8923-0bb8298188c9
Bia/3

# ╔═╡ f2b55d25-0553-4956-b521-0a6d000de859
Bia-Bia

# ╔═╡ f8faecce-5ddb-4658-b460-2cadd46afd1a
Bia+Bia

# ╔═╡ 134ac2e8-9f26-47f7-b11b-5af43a963e01
Toy = Bia*Skip'

# ╔═╡ a2b8aad8-b440-41fb-b165-d48682bc917b
Zee = [1-1im  2+3im  3-2im ; 0+6im  -1+1im  1-9im] # 2x3 complex matrix (2-dimensional array)

# ╔═╡ bcd4cb5b-26db-4e5b-8f0d-43d4635d70bc
Zee'

# ╔═╡ 3f02c50a-16c3-4ef1-bdcf-e8c5760329f0
md"""
Look at the speed of dealing with large matrices (1000 $\times$ 1000)
"""

# ╔═╡ b992730c-733a-4fe3-8c83-0e0cdd0b1b32
Zak =randn(1000,1000)

# ╔═╡ 6e9d28d1-3962-40f3-aca2-94fb05dbc90c
det(Zak)

# ╔═╡ d9365b69-da0d-4271-9051-564707ac264a
Cat = rand(1000,1000)

# ╔═╡ f3f44ae4-38ff-40bf-9bb5-3fce834d6807
inv(Cat)

# ╔═╡ 410f06bf-d372-420e-8f06-4cd35ec64c1f
Di = Zak*Cat

# ╔═╡ 11e1841e-7198-4dbd-bf61-22f9a57859f2
Di[:, 2] # all elements of column 2

# ╔═╡ 2063b474-587d-4388-9960-b458df0234f1
Di[3, :] # all elements of rwo 3

# ╔═╡ 37b4aee1-05f1-41fe-ac41-90187781d14a
Di[3,2] #the element of row 3 and column 2

# ╔═╡ f93488ea-f17b-43eb-9275-827b0452d557


# ╔═╡ 17f2fa6f-f1be-4d5d-a66c-7da009d20cf9
md"""
## Eigenvalues and eigenvectors
"""

# ╔═╡ dbbca37d-6748-44ce-9d5c-e5703c7a264a
eigvals(Bia)

# ╔═╡ c5d14e00-7779-4207-ab78-0dc98f9dfd6e
eigvecs(Bia)

# ╔═╡ e13d8255-94c4-4bed-8359-8b84c33a5899
eigen(Bia) # Eigenvalues and eigenvectors of A

# ╔═╡ d5146a46-bcdb-4019-a985-75a8a5541cce
Marty = Diagonal(eigvals(Bia))

# ╔═╡ d8953a6f-d793-4ee3-b929-c641d066a309
md"""
## Working with symbols instead of numbers
"""

# ╔═╡ 6e6dbe1c-8a45-4dd4-922f-acffcda71eb4
md"""
In this case we use the package `Symbolics.jl`
"""

# ╔═╡ d98259ff-41f7-46d7-a871-589f320433f0
md"""
Defining two variables: `x` and `y`
"""

# ╔═╡ 1453f829-106a-4537-8aed-e4eb2a0ade71
@variables x y

# ╔═╡ ebe938d0-93ba-4ab3-a767-51f37d175641
Jef = [x^2 + y   1   2x 
	 	1        2   y 
	   y^2 + x   3   0]

# ╔═╡ bf70a01b-7cdb-4871-ac37-6fd35d705e29
det(Jef)

# ╔═╡ beb1a536-b099-431e-9656-2273ab2afb54
inv(Jef)

# ╔═╡ 0f87ea8a-293d-486e-8eac-30666544b794
A = [0 1 2 ; 1 1 1; 3 5 2] 

# ╔═╡ 74032959-6104-40cd-843b-cf65ccf86710
A*Jef

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"

[compat]
HypertextLiteral = "~0.9.0"
PlotlyBase = "~0.8.16"
PlutoUI = "~0.7.9"
Symbolics = "~3.3.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "85d03b60274807181bae7549bb22b2204b6e5a0e"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.30"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bijections]]
git-tree-sha1 = "705e7822597b432ebe152baa844b49f8026df090"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.3"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "bdc0937269321858ab2a4f288486cb258b9a0af7"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.3.0"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "727e463cfebd0c7b999bbf3e9e7e16f254b94193"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.34.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[CompositeTypes]]
git-tree-sha1 = "d5b014b216dc891e81fea299638e4c10c657b582"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.2"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

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

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "3ed8fa7178a10d1cd0f1ca524f249ba6937490c0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Distributions]]
deps = ["ChainRulesCore", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "f4efaa4b5157e0cdb8283ae0b5428bc9208436ed"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.16"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "a32185f5428d3986f47c2ab78b1f216d5e6cc96f"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.5"

[[DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "StaticArrays", "Statistics", "Test"]
git-tree-sha1 = "d14a65aa80e366af382d3623beba6a63cb607490"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.5.4"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[DynamicPolynomials]]
deps = ["DataStructures", "Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Pkg", "Reexport", "Test"]
git-tree-sha1 = "05b68e727a192783be0b34bd8fee8f678505c0bf"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.3.20"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "8041575f021cba5a099a456b4163c9a08b566a02"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.0"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "a3b7b041753094f3b17ffa9d2e2e07d8cace09cd"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.12.3"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IfElse]]
git-tree-sha1 = "28e837ff3e7a6c3cdb252ce49fb412c8eb3caeef"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[IrrationalConstants]]
git-tree-sha1 = "f76424439413893a832026ca355fe273e93bce94"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.0"

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

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[LabelledArrays]]
deps = ["ArrayInterface", "LinearAlgebra", "MacroTools", "StaticArrays"]
git-tree-sha1 = "bdde43e002847c34c206735b1cf860bc3abd35e7"
uuid = "2ee39098-c373-598a-b85f-a56591580800"
version = "1.6.4"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

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

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "3d682c07e6dd250ed082f883dc88aee7996bf2cc"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.0"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "2ca267b08821e86c5ef4376cffed98a46c2cb205"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MultivariatePolynomials]]
deps = ["DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "45c9940cec79dedcdccc73cc6dd09ea8b8ab142c"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.3.18"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "3927848ccebcc165952dc0d9ac9aa274a87bfe01"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.20"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "4dd403333bcf0909341cfe57ec115152f937d7d8"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "2276ac65f1e236e0a6ea70baff3f62ad4c625345"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.2"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "bfd7d8c7fd87f04543810d9cbd3995972236ba1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "7eb4ec38e1c4e00fea999256e9eb11ee7ede0c69"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.16"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "12fbe86da16df6679be7521dfb39fbc861e1dc7b"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.1"

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

[[RecursiveArrayTools]]
deps = ["ArrayInterface", "ChainRulesCore", "DocStringExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArrays", "Statistics", "ZygoteRules"]
git-tree-sha1 = "00bede2eb099dcc1ddc3f9ec02180c326b420ee2"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.17.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "cdc1e4278e91a6ad530770ebb327f9ed83cf10c4"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SciMLBase]]
deps = ["ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "RecipesBase", "RecursiveArrayTools", "StaticArrays", "Statistics", "Tables", "TreeViews"]
git-tree-sha1 = "ff686e0c79dbe91767f4c1e44257621a5455b1c6"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.18.7"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "fca29e68c5062722b5b4435594c3d1ba557072a3"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.7.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

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
deps = ["ChainRulesCore", "LogExpFunctions", "OpenSpecFun_jll"]
git-tree-sha1 = "a322a9493e49c5f3a10b50df3aedaf1cdb3244b7"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.6.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "854b024a4a81b05c0792a4b45293b85db228bd27"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.3.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3240808c6d463ac46f1c1cd7638375cd22abbccb"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.12"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8cbbc098554648c84f79a463c9ff0fd277144b6c"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.10"

[[StatsFuns]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "46d7ccc7104860c38b11966dd1f72ff042f382e4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.10"

[[SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[SymbolicUtils]]
deps = ["AbstractTrees", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LabelledArrays", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "TermInterface", "TimerOutputs"]
git-tree-sha1 = "36b02c0d2baf74a424ec1af67351101975f7cbcb"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "0.15.3"

[[Symbolics]]
deps = ["ConstructionBase", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "IfElse", "Latexify", "Libdl", "LinearAlgebra", "MacroTools", "NaNMath", "RecipesBase", "Reexport", "Requires", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicUtils", "TreeViews"]
git-tree-sha1 = "0bd8739a4a44632c930e5564b891296d86132160"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "3.3.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "d0c690d37c73aeb5ca063056283fde5585a41710"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.5.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TermInterface]]
git-tree-sha1 = "02a620218eaaa1c1914d228d0e75da122224a502"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "0.1.8"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "209a8326c4f955e2442c07b56029e88bb48299c7"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.12"

[[TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[ZygoteRules]]
deps = ["MacroTools"]
git-tree-sha1 = "9e7a1e8ca60b742e508a315c17eef5211e7fbfd7"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─15d7b793-6e8f-4b78-a40e-a79406578550
# ╟─943edb36-acc8-4b2a-94ab-c544f9eb279b
# ╟─1245aef9-18ce-42f5-af82-c2e6cce70798
# ╠═a385a0ae-d2e0-4b4e-862c-e69ec5bd6843
# ╠═9fa87191-7c90-4738-a45a-acd929c8bd1b
# ╠═4618a663-f77e-4ccc-9b00-e84dbd5beb34
# ╠═a145e2fe-a903-11eb-160f-df7ea83fa3e6
# ╟─1c787d91-ffdd-489e-a755-c0ab12272585
# ╟─74de9f66-d5b4-4e0f-a75d-5177b1842191
# ╟─9a963cbc-78fe-4a90-a791-bd69cbb8e5dd
# ╟─1b5f13b2-b126-40c4-936f-34db443547b6
# ╠═1ed1b272-f6bd-4f57-a438-49812ff7a072
# ╠═1deee867-66c3-445c-87d7-897a55b68030
# ╠═b0cdf557-a76a-4ba0-bd64-0d6880f2e4e5
# ╠═d3fb3ad5-b106-43ec-8c18-aa975c068b47
# ╠═488674bf-ab74-416f-b38f-3f03856159a0
# ╠═c4e36a06-7806-4835-9c40-9d1682936da9
# ╠═d3a4daef-f35d-4b5a-92a0-accc15051e6d
# ╠═3b969b09-d4e0-484c-9bdb-c077152b6124
# ╠═aca57619-8f5b-4490-8367-2d2416e7881c
# ╠═da06b143-075d-4dff-90fb-e6d3cfdb5a33
# ╠═e09302d6-2e28-4565-a84e-04dfa9335a34
# ╠═d62b266e-07bd-4388-ae27-2c4f1860382a
# ╠═4cb0f3fe-83b0-4b8d-b52f-b35e093b1bb7
# ╟─41396532-b1c1-4bb3-bb6f-b003b7c98cdb
# ╟─c39831b8-7a25-4104-8f75-b6f44d2b0ce8
# ╟─42c36143-a434-4715-8f91-2c536a0faa18
# ╠═3ac6a190-07b3-4ce6-b417-ec4eddf53b23
# ╠═1888712e-aba9-402a-abe8-73f6604719d4
# ╠═cfeec38a-85dd-4738-bb2d-fb8b03e8206b
# ╠═706c5a01-9ff9-4af0-8b04-1e68c5aaaa7c
# ╠═a9647d48-3f08-464a-a51c-c2481850257f
# ╠═c758f930-81e1-46e8-beec-0050abed5ad1
# ╠═7e7b8ec2-1446-47ec-a149-8fc5a75e0652
# ╠═92f0a000-d193-41f4-9018-44bed26b904a
# ╠═dfb101ff-7948-4c8f-8923-0bb8298188c9
# ╠═f2b55d25-0553-4956-b521-0a6d000de859
# ╠═f8faecce-5ddb-4658-b460-2cadd46afd1a
# ╠═134ac2e8-9f26-47f7-b11b-5af43a963e01
# ╠═a2b8aad8-b440-41fb-b165-d48682bc917b
# ╠═bcd4cb5b-26db-4e5b-8f0d-43d4635d70bc
# ╟─3f02c50a-16c3-4ef1-bdcf-e8c5760329f0
# ╠═b992730c-733a-4fe3-8c83-0e0cdd0b1b32
# ╠═6e9d28d1-3962-40f3-aca2-94fb05dbc90c
# ╠═d9365b69-da0d-4271-9051-564707ac264a
# ╠═f3f44ae4-38ff-40bf-9bb5-3fce834d6807
# ╠═410f06bf-d372-420e-8f06-4cd35ec64c1f
# ╠═11e1841e-7198-4dbd-bf61-22f9a57859f2
# ╠═2063b474-587d-4388-9960-b458df0234f1
# ╠═37b4aee1-05f1-41fe-ac41-90187781d14a
# ╟─f93488ea-f17b-43eb-9275-827b0452d557
# ╠═17f2fa6f-f1be-4d5d-a66c-7da009d20cf9
# ╠═dbbca37d-6748-44ce-9d5c-e5703c7a264a
# ╠═c5d14e00-7779-4207-ab78-0dc98f9dfd6e
# ╠═e13d8255-94c4-4bed-8359-8b84c33a5899
# ╠═d5146a46-bcdb-4019-a985-75a8a5541cce
# ╠═d8953a6f-d793-4ee3-b929-c641d066a309
# ╟─6e6dbe1c-8a45-4dd4-922f-acffcda71eb4
# ╟─d98259ff-41f7-46d7-a871-589f320433f0
# ╠═1453f829-106a-4537-8aed-e4eb2a0ade71
# ╠═ebe938d0-93ba-4ab3-a767-51f37d175641
# ╠═bf70a01b-7cdb-4871-ac37-6fd35d705e29
# ╠═beb1a536-b099-431e-9656-2273ab2afb54
# ╠═0f87ea8a-293d-486e-8eac-30666544b794
# ╠═74032959-6104-40cd-843b-cf65ccf86710
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
