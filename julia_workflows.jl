### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ baf88246-01d1-11eb-3d35-1393445b1476
using PlutoUI

# ╔═╡ 5f8b8c4e-7aeb-4797-91e4-22680a51e468
 html"""
<b> Scientific Computing TU Berlin Winter 2021/22  &copy; Jürgen Fuhrmann </b>
<br><b> Notebook 03</b>
"""

# ╔═╡ b9010f17-deeb-4ac9-9697-76fb2b26c46e
TableOfContents(title="",depth=4)

# ╔═╡ d76c2038-0292-11eb-1fe0-e50fc2a4fc0f
md"""
# Julia workflows

When working with Julia, we can choose between a number of workflows.
"""

# ╔═╡ 53558565-e446-4721-8fc0-b27e16cd1cf7
md"""
## [Pluto](https://github.com/fonsp/Pluto.jl) notebook
This ist what you see in action here. After calling pluto, you can start with an empty notebook and add cells.

Great for teaching or trying out ideas.
"""

# ╔═╡ 163fdb18-b10d-4467-9b02-78d344f937f0
md"""

## Jupyter notebook
With the help of the package [IJulia.jl](https://github.com/JuliaLang/IJulia.jl) it is possible to work with Jupyter notebooks in the browser.
The Jupyter system is rather complex and Pluto hopefully will be able to replace it, in particular because
of its reactivity features.

"""

# ╔═╡ e654a09a-f8c1-447a-ac98-c260f62ac945
md"""
## "Classical" workflow

Use a classical code editor (emacs, vi or whatever you prefer) in a separate window and edit files, when saved to disk run code in a console window.

With Julia, this workflow has the disadvantage that everytime Julia is started, the just-in-time compiler (JIT) 
needs to recompile all the code to be run if its compiled version is not cached.

While a significant part of the compiled code of installed packages is cached, Julia needs to assume that the code you write can have changed.

- Remedy: Never leave Julia, start a permanent Julia session, include edited code after each change.
"""

# ╔═╡ 08bfe919-85b9-4443-960b-73c9ffd15e18
md"""
### The REPL 

aka __R__ead - __E__val - __P__rint - __L__oop or Julia command prompt

One enters the REPL when one starts julia in a console window without giving filename.


The REPL allows to execute Julia statements in an interactive fashion. 
It has convenient editing capabilities.
"""

# ╔═╡ b6abe01d-88c1-4904-acab-488cc4127612
md"""
Helpful commands in the  REPL default mode:


| commmand                 | action                                       |
|:-------------------------|:---------------------------------------------|
| `quit()` or `Ctrl+D`     | exit Julia                                   |
| `Ctrl+C`                 | interrupt execution                          |
| `Ctrl+L`                 | clear screen                                 |
| Append `;`               | suppress displaying return value             |
| `include("filename.jl")` | source a Julia code file and execute content |


"""



# ╔═╡ 3eab36fc-2ab5-4e1d-a4cb-8ed35e3c9aee
md"""
The REPL has different modes which can be invoked by certain characters:

| mode            | prompt   | enter/exit                          |
|:----------------|:---------|:------------------------------------|
| Default         | `julia`  | `backspace` in other modes to enter |
| Help            | `help?>` | `?` to enter                        |
|                 |          | type command name to search         |
| Shell           | `shell>` | `;` to enter                        |
|                 |          | type command to execute             |
| Package manager | `Pkg>`   | `]` to enter                        |


"""

# ╔═╡ 406e7993-44c4-4f69-bb95-12e9024d045b
md"""
### Revise.jl

The [Revise.jl](https://github.com/timholy/Revise.jl) package allows to keep track of changed files used in a Julia session if they have been included via `includet` (`t` for "tracked").
It controls recompilation of changed code - only those parts which indeed have changed are newly compiled by the JIT, moreover, recompilation is triggered automatically, no need to include code again and again.

In order to make this work, one needs to  add 
````
if isinteractive()
    try
        @eval using Revise
        Revise.async_steal_repl_backend()
    catch err
        @warn "Could not load Revise."
    end
end
````
to the startup file  `~/.julia/config/startup.jl` and to run Julia via `julia -i`.

`Revise.jl` also keeps track of packages loaded and their changes. In this setting it also can be used with Pluto.
"""

# ╔═╡ 3e668913-2489-400b-9f4a-e1b49480109e
md"""
### Recommendation
When using the REPL based workflow, don't miss Revise.jl and try to find a Julia mode
for your favorite editor which provides auto-indentation, highlighteing etc. Mine (emacs) has one.
"""

# ╔═╡ 36a942af-00ca-461e-9ffe-6da9fc11440e
md"""
## IDE based workflow
Use an IDE (integrated development environment). Currently the best one for Julia is [Visual Studio Code](https://code.visualstudio.com/)
with  the [Julia extension](https://www.julia-vscode.org/).

For introductory material, see the tutorial information given upon starting of 
a newly installed instance of `code`. For the Julia extension, find videos on `code` 
[Julia for Talented Amateurs](https://www.youtube.com/c/juliafortalentedamateurs/videos).

"""

# ╔═╡ 2c13aee4-79c8-4686-90de-a7af26a82160
md"""
# Packages
"""

# ╔═╡ 06a3282e-0298-11eb-39cc-a1e604624b9e
md"""
## Structure of a package
- Packages are modules searched for in a number of standard places and as git repositories on the internet
- Locally, each package is stored in  directory named e.g. `MyPack` for a package `MyPack.jl`.
- Structure of a package Directory:
   - Subdirectory `MyPack/src` for sources
   - Main source `MyPack/src/MyPack.jl` defining  a module named `MyPack`
   - Further Julia sources in  `MyPack/src/` included by `MyPack/src/MyPack.jl`
   - Code for unit testing in `MyPack/test`
      - a well designed package has a good number of tests which are run upon every upload on github
   - Code for documentation generation  in `MyPack/docs`
      - a well designed package has documentation generated upon every upload on github
   - License
      - Packages in the general registry (see below) are required to have an open source license
   - Metadata
"""

# ╔═╡ 6e1148bb-ebac-4825-b10a-558dfa30a700
md"""
## Metadata
Package metadata are stored in `MyPack/Project.toml`
- Name
- Unique Universal Identifier (UUID) - a long character string hopefully unique in the world
- Author
- Version number
- Package dependencies (names and UUIDs)
- [Version bounds](https://pkgdocs.julialang.org/v1/compatibility/) for package dependencies
"""

# ╔═╡ 9380b76f-5ed6-485d-8f85-0cb0cd0c1a9d
md"""
## [Environments](https://pkgdocs.julialang.org/v1/environments/)
Environments (projects) are essentially lists of packages used in a current Julia session.
An environment is described by a directory containing at least two metadata files:
- `Project.toml` describing the list of packages required for the project
- `Manifest.toml` describing the actually installed versions of the required packages and *all their dependencies*
"""

# ╔═╡ 4717c7a9-a96a-4787-b7a0-42269ccff6f0
md"""
### Global environment
By default, a global environment stored in `.julia/environments/vX.Y` under the user home directory will be used
"""

# ╔═╡ d29403e2-2f8c-43dc-85f9-d746f5a9ae1f
md"""
### Local environments
In oder to avoid version clashes for different projects, one can activate any directory  - e.g. `mydir` as a local package environment
by invoking Julia with 

```julia --project=mydir```

"""

# ╔═╡ 11feb7c0-cd60-49ed-a196-d6b2e45df85d
md"""
## Package manager
 - Default packages (e.g. the package manager Pkg) are always found in the `.julia` subdirectory of your home directory
 - The package manager allows to add packages to your installation by finding their git repositories via the [Julia General Registry](https://github.com/JuliaRegistries/General)
   or another registry 
   - Packages are found via the UUID
   - During package installation, compatibility is checked accordint to the `[compat]` entries in the respective `Project.toml` files
"""

# ╔═╡ 8c89b58c-13b0-448a-b8a8-a99ac9014b22
md"""
### [Basic package manager commands](https://pkgdocs.julialang.org/v1/managing-packages/)

The package manager can be used in two ways: via the Pkg REPL mode or via Julia function calls
after havig invoked `using Pkg`.

| Function                | `pkg` mode            | Explanation                                               |
|:------------------------|:----------------------|:----------------------------------------------------------|
| `Pkg.add("MyPack")`     | `pkg> add MyPack`     | add `MyPack.jl` to current environment                    |
| `Pkg.rm("MyPack")`      | `pkg> rm MyPack`      | remove `MyPack.jl` from current environment               |
| `Pkg.update()`          | `pkg> up`             | update packages in current environment                    |
| `Pkg.activate("mydir")` | `pkg> activate mydir` | activate directory as current environment                 |
| `Pkg.instantiate()`     | `pkg> instatiate`     | populate current environment according to `Manifest.toml` |
| `Pkg.test("MyPack")`    | `pkg> test mypack`    | run tests of `MyPack.jl`                                  |
| `Pkg.status()`    | `pkg> status`    | list packages                                  |

For more information, see the  [documentation of the package manager](https://pkgdocs.julialang.org/v1/managing-packages/)

"""

# ╔═╡ d9863511-5218-4c87-bfc0-002f11915b04
md"""
## Package management in Pluto notebooks
- Pluto (version >=0.16) contains an "automatic" package manager on top of `Pkg`
- Every Pluto notebook contains `Project.toml` and `Manifest.toml` and activates its own environment upon start
- All package versions for a Pluto notebook are fixed $\Rightarrow$ Reproducibility
"""

# ╔═╡ c38775c0-b1ae-4791-873e-655ad0ec8b54
md"""
# FAIRness
The [FAIR principles](https://www.go-fair.org/fair-principles/) are fundamental for the role of 
data  in modern research based on good scientific practice. The almost exactly can be applied to software
as well - software can be seen as a kind of data.
"""

# ╔═╡ 7734fd7a-3fe6-4972-8e95-0fa3156173a7
md"""
## Findability

"The first step in (re)using data is to find them. Metadata and data should be easy to find for both humans and computers. Machine-readable metadata are essential for automatic discovery..."

- Package metadata
- General registry
"""

# ╔═╡ 2d34a370-ee97-4ceb-b0f2-fa6d7feb9b25
md"""
## Accessibility

"Once the user finds the required data, she/he/they need to know how can they be accessed, possibly including authentication and authorisation"

- Published packages available (mostly) via `github`
"""

# ╔═╡ 647f8f60-e27f-49b4-8c28-1b0674ae6588
md"""
## Interoperability
"The data usually need to be integrated with other data. In addition, the data need to interoperate with applications or workflows for analysis, storage, and processing"

- Julia supports composability of packages based on interface oriented design of data structures - we will cover this later in the course
"""

# ╔═╡ 6e6e85a8-f5cd-45cf-a30f-58c4f446ceb0
md"""
## Reproducibility

"The ultimate goal of FAIR is to optimise the reuse of data. To achieve this, metadata and data should be well-described so that they can be replicated and/or combined in different settings."

- `Manifest.toml` metadata files are created with reproducibility in mind
- Package version bounds ensure composability across  compatible versions of Julia packages - allowing to prevent updates with breaking changes

"""

# ╔═╡ e64bf68b-ca46-4b21-b553-b1ecc2bb6c5a
md"""
## "Side effects"
- fast pace of development of independent and interoperable packages
- possibility to create up-to-date documentation
- culture of bug fixing via issues and pull-requests to other packages
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.6.3"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "f19e978f81eca5fd7620650d7dbea58f825802ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.0"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─5f8b8c4e-7aeb-4797-91e4-22680a51e468
# ╠═baf88246-01d1-11eb-3d35-1393445b1476
# ╟─b9010f17-deeb-4ac9-9697-76fb2b26c46e
# ╟─d76c2038-0292-11eb-1fe0-e50fc2a4fc0f
# ╟─53558565-e446-4721-8fc0-b27e16cd1cf7
# ╟─163fdb18-b10d-4467-9b02-78d344f937f0
# ╟─e654a09a-f8c1-447a-ac98-c260f62ac945
# ╟─08bfe919-85b9-4443-960b-73c9ffd15e18
# ╟─b6abe01d-88c1-4904-acab-488cc4127612
# ╟─3eab36fc-2ab5-4e1d-a4cb-8ed35e3c9aee
# ╟─406e7993-44c4-4f69-bb95-12e9024d045b
# ╟─3e668913-2489-400b-9f4a-e1b49480109e
# ╟─36a942af-00ca-461e-9ffe-6da9fc11440e
# ╟─2c13aee4-79c8-4686-90de-a7af26a82160
# ╟─06a3282e-0298-11eb-39cc-a1e604624b9e
# ╟─6e1148bb-ebac-4825-b10a-558dfa30a700
# ╟─9380b76f-5ed6-485d-8f85-0cb0cd0c1a9d
# ╟─4717c7a9-a96a-4787-b7a0-42269ccff6f0
# ╟─d29403e2-2f8c-43dc-85f9-d746f5a9ae1f
# ╟─11feb7c0-cd60-49ed-a196-d6b2e45df85d
# ╟─8c89b58c-13b0-448a-b8a8-a99ac9014b22
# ╟─d9863511-5218-4c87-bfc0-002f11915b04
# ╟─c38775c0-b1ae-4791-873e-655ad0ec8b54
# ╟─7734fd7a-3fe6-4972-8e95-0fa3156173a7
# ╟─2d34a370-ee97-4ceb-b0f2-fa6d7feb9b25
# ╟─647f8f60-e27f-49b4-8c28-1b0674ae6588
# ╟─6e6e85a8-f5cd-45cf-a30f-58c4f446ceb0
# ╟─e64bf68b-ca46-4b21-b553-b1ecc2bb6c5a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
