### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 5667c9d7-46ce-47ce-bfb7-5851cf8e80a7
using LinearAlgebra, BenchmarkTools

# ╔═╡ b4c31904-2384-425d-a12b-5f3c145bc5fb
using PrettyTables

# ╔═╡ 1cbe8ec9-a704-4912-98d2-69385c773627
using Plots

# ╔═╡ 09a3f57a-db03-4bf4-9129-ab4a0254604e
begin
	using PlutoUI
	PlutoUI.TableOfContents(title = "Contents")
end

# ╔═╡ 58a85b40-e086-11eb-1471-a3d9d5596625
md"""
# Introduction to Julia for CATAM


Computer-Aided Teaching of All Mathematics
"""

# ╔═╡ b695a54f-da17-4acf-aa30-5fb2344df48e
md"""
## About this manual

This manual is intended as an introduction to the programming language [Julia](https://julialang.org/) for use for [CATAM](https://www.maths.cam.ac.uk/undergrad/catam). Some of the advantages of Julia over other programming languages can be found in the section [Learning Julia](#ffcdf202-a14d-417a-9a82-bf3e5ba38972). The headline advantage that it has over the likes of perennial favourites Matlab and Python is [speed](#d508655f-663b-4baa-af93-d0cbd5935a97), which can be critical in some projects, and remains handy for all others. This is rare among languages with the intuitive and wide-ranging syntax that Julia provides.

This manual is perfectly viewable in web-page form, and you will be able to copy code from the manual into Julia to test/edit it. No code which is used in creating the outputs seen in this document is hidden.

However, the interactivity built into the Pluto notebook in which this is written is lost. To enable this:
- Download the notebook as a *.jl* file by clicking *`Edit or run this notebook`* in the top right, and clicking the download button
- Download and install Julia as detailed in the section [Installing Julia](#45aa5e5d-b518-4f28-ab45-365a9c3d4ee1) (note that no editor, e.g. VSCode, is needed)
- Download the Pluto package as detailed in the section [Pluto notebooks](#3cb29926-3332-429b-b8b6-0b95113b388b)
- Open the notebook which you have downloaded in Pluto
A more detailed guide to downloading Julia and Pluto, with images, is [here](https://medium.com/swlh/a-guide-to-building-reactive-notebooks-for-scientific-computing-with-julia-and-pluto-jl-1a2c0c455d51)
"""

# ╔═╡ 45aa5e5d-b518-4f28-ab45-365a9c3d4ee1
md"""
## Installing Julia

To use Julia, two elements are required: Julia itself, and an editor to allow you to write and run your programs.

Julia is a standalone program downloaded from <https://julialang.org/downloads/>
- For most Windows users, the version to download will be the 64-bit (installer). Once downloaded, run the installer, making sure to check the **Add Julia to PATH** box (which will allow the editor to find it)
- For Mac users there is no such paralysis of choice, the single Mac download link is the one you want
- For Linux users, you know what you're doing anyway
Additional platform specific information can be found at <https://julialang.org/downloads/platform/>

An editor is technically not essential, although it makes programming immeasuarably faster and easier. This manual will use the editor VSCode, which is developed by Microsoft but available on Mac and Linux as well as Windows. This is downloadable from <https://code.visualstudio.com/Download>

The third and final step is to open VSCode and install the Julia extension which allows it to recognise and run Julia code. This is found in the Extensions tab (accessible via **View** > **Extensions**, or `Ctrl` + `Shift` + `X`, or as the fifth symbol on the left sidebar). Search for Julia, and click Install. Once the extension has installed, restart VSCode, and it will be ready to use. Documentation for the extension is found at <https://www.julia-vscode.org/docs/dev/>, which provides (at the time of writing) limited information on using the extension.

Many alternatives to VSCode exist, as detailed in the **Editors and IDEs** section of <https://julialang.org/>. If you already have an editor of choice, it is likely that a Julia syntax-highlighting or even REPL extension exists for it.
"""

# ╔═╡ 6dab02d3-4b45-4227-a790-00350002a909
md"""
## Using Julia with VSCode

VSCode gives two ways to interact with Julia: the REPL and the editor

### The Julia REPL

The read-eval-print-loop (REPL) is the command line interface of Julia, akin to the MATLAB Command Window or the Python Shell. It allows single lines of code to be written and evaluated, and is also the place where any programs you write will run. It can be opened by the key sequence `Alt` + `J` followed by `Alt` + `O`, or by opening VSCode's command palette via the **View** menu or with `Ctrl` + `Shift` + `P`, and searching for the command **Julia: Start REPL**. It is identical to the command line which appears when running Julia as an application, so there is no need to interact with Julia outside of VSCode.

To test it, try copying the code in the boxes below, and see if the outputs match:
"""

# ╔═╡ 07d24863-82aa-4b13-aa92-1b06a0b5276b
a = 3;

# ╔═╡ c8366549-83b0-4a1c-b526-a4c38c1b1151
b = 2

# ╔═╡ 1c46f6c4-fba1-460d-91ff-a7f5e4506041
a + b

# ╔═╡ d3da52ff-1f54-4b15-bdb7-1c213154cc89
md"""
Note that without the semicolon, an output is displayed, which may or may not be desirable. Multiple lines can be written at once by seperation by semicolons, e.g.:
"""

# ╔═╡ 21f97b7f-7dd1-4f12-9812-081f08ed3f1f
c = a + 4; b * c

# ╔═╡ 6d3d80e1-c4e9-43eb-8750-48ce16a55e63
md"""
One particularly useful feature of the REPL is help mode. By typing `?` into the REPL. the prompt changes from **`julia>`** to **`help?>`**, after which typing the name of any variable or function tells you about it. Help mode can be exited by `Backspace` on an empty line, or `Ctrl` + `C` at any time. 

### The editor

The editor pane is the large central pane, which will allow the writing of programs in the form of scripts. To create a new file, select **File** and choose **New File** from the menu, or use `Ctrl` + `N`. Then, you need to tell VSCode that you will be writing Julia, which can be done through the **Select a language** prompt, or by saving the file with the file type *.jl*.

VSCode will prompt you to open a folder, which you will want to do. This not only allows for saving of your files to a chosen location, but also will determine the place from which any file paths that you use (such as in the section [Customising outputs](#3665a395-ae1c-40cf-8e98-00534f53ee4f)), allowing your program to work independent of its file location.

Once a script has been written and saved, it can be run through the REPL by clicking the triangle in the top right and selecting **Julia: Execute File in REPL**. This does not have a keyboard shortcut automatically, but this (and any other keyboard shortcuts) can be changed through the command palette (`Ctrl` + `Shift` + `P`) by searching for the relevant command and clicking the cog that appears when you mouse over it.
"""

# ╔═╡ ffcdf202-a14d-417a-9a82-bf3e5ba38972
md"""
## Learning Julia and its advantages

This manual doesn't focus on teaching Julia, purely because there are already plenty of freely available resources online to get you started
- A good place to start is the Julia Manual on Julia's official website, starting with <https://docs.julialang.org/en/v1/manual/getting-started/> and navigable through the left-hand menu
- Another great option is the Julia Express linked at <https://github.com/bkamins/The-Julia-Express/>
- For programmers already familiar with other languages, a useful page from the manual is <https://docs.julialang.org/en/v1/manual/noteworthy-differences/>, detailing how Julia differs from other languages, and <https://cheatsheets.quantecon.org/>, which gives explicit differences in syntax between Julia, Python, and MATLAB
- A short introductory guide is at <https://computationalthinking.mit.edu/Spring21/basic_syntax/>. This is an interactive Pluto notebook, with the ability to edit the snippets of code (see section on Pluto notebooks for further details). Further similar material is also available at <https://computationalthinking.mit.edu/>
- A quick cheatsheet for Julia syntax and its abilities is at <https://juliadocs.github.io/Julia-Cheat-Sheet/>
- A similar cheatsheet for the Plots package is at <https://github.com/sswatson/cheatsheets/blob/master/plotsjl-cheatsheet.pdf>
- YouTube (as usual) provides a plethora of videos of a wide range of qualities; simply searching for "Learn Julia", or the Julia language channel <https://www.youtube.com/c/TheJuliaLanguage>, would be a good start

However, there are some particular features worth highlighting:
"""

# ╔═╡ af2dd15c-cb27-483f-b047-69c70d9e7532
md"""
### Unicode support

Julia is unusual in supporting the use of characters usual Latin alphabet, Arabic numerals, and common English punctuation. For example:
- Instead of `pi` and `exp(1)`, we can use `π` and `ℯ`
- Where Greek letters are used by mathematical convention, they can be used in programs, such as `ρ` for density, or `λ` for the parameter of a Poisson distribution, improving comprehension
- Some symbols have syntactic meaning, such as using `≤` instead of `<=`, or `∈` instead of the keyword `in`
- Non-Latin writing systems are supported, allowing variable/function names as well as text within the program to be written in your (human) language of choice
- Emoji can be used similarly. Unfortunately, the author of this manual is too boring to appreciate this. `😒 = true`
These can be copied and pasted into your code, or directly typed if you have the capabilities, but the easiest way tends to be to use ``\LaTeX``-like shortcuts with tab-completion, such as `\alpha<tab>` for `α` or `\leq<tab>` for `≤`. The help mode of the REPL allows pasting of characters to see the relevant shortcuts available for typing them.
"""

# ╔═╡ 6cf95416-a4d0-442b-8dfa-5e59d07d4a15
md"""
### Mathematical notation uncommon in other languages

The usual syntax for defining functions is similar to many other programming languages
"""

# ╔═╡ 92715aab-25fe-4387-9fd9-45c7e632b50d
function f(x,y)
	return √(x^2 + y^2)
end

# ╔═╡ a151d910-5408-40cc-a352-2eeef5434551
f(3,4)

# ╔═╡ 4f540782-83d9-4401-8865-78bb39af2aae
md"""
However, an alternative syntax is particularly useful for readability of short functions, by writing them in the compact form:
"""

# ╔═╡ dd43c006-3455-49db-97bc-e928408a0539
g(x,y) = √(x^2 + y^2)

# ╔═╡ 45a265d6-b489-49d1-b93d-4907f6ea66b2
g(3,4)

# ╔═╡ 26b5cc22-db0b-46f4-9d45-d3830223d336
md"""
This is convenient notation since it mirrors the mathematical equivalent. The expression after the equals must be a single line, but can also be extended to longer expressions by using a `begin`-`end` block, which allows multiple lines to be treated together as a single line:
"""

# ╔═╡ 59b2dc85-0ce7-4e99-aeae-170cc13cfe87
h(x) = begin
	if 0 < x < 3
		return x
	else
		return 0
	end
end

# ╔═╡ 2bb4926a-2b5b-4e02-b1f9-d8225b909ae5
h(2)

# ╔═╡ e3884fe1-4451-4601-b483-6b4ee03d572e
h(-2)

# ╔═╡ 74e50b24-39d8-49b4-b651-e4cbe07d382f
md"""
The function `h` above also demonstrates another ability of Julia, which is to allow multiple comparisons in the same statement. In many languages, `0 < x < 3` would be invalid syntax, and would have to be written as `0 < x && x < 3`.

A third feature of Julia that appeals to standard mathematical notation is function composition:
"""

# ╔═╡ 0c4f78f4-055b-47fd-8c64-8a77259a13c1
hg = h ∘ g

# ╔═╡ a2cf252e-604c-40b7-9bff-d0970ebf9b80
md"""
Here, `hg` isn't technically a function, but a `ComposedFunction`, although it acts in much the same way.
"""

# ╔═╡ cef7f72e-73fe-4a6a-b807-46e14d794014
hg(1,1)

# ╔═╡ a5717ddf-2e3c-4138-8d7c-40f9d6fb1a12
hg(3,5)

# ╔═╡ be6f9061-dd1b-4c8a-bd13-82455e8a0207
md"""
A fourth such feature is the ability to use numeric coefficients to denote multiplication. Consider the following:
"""

# ╔═╡ a671de2a-de76-4728-bf7b-f751c284aace
d = 2; e = 2d

# ╔═╡ 1b859eb6-525f-4405-b4fc-181ff335532b
md"""
In most other programming languages, this would cause an error, as the implicit multiplication wouldn't be recognised. Julia, however, knows that prefixing a variable name with a number means multiplication, so treats it as such.

This only works with numeric literals, i.e. actual numbers, not variables which take a number as a value. For example, trying to multiply `d` and `e` like this results in:
"""

# ╔═╡ c33eeb03-07d8-4f16-8691-568bc830e468
de

# ╔═╡ 7e80b6cc-d4b6-45c7-a14f-76e0f67a6053
md"""
because Julia interprets this as the variable with name `de`, not `d` multiplied by `e`.
"""

# ╔═╡ 2fe58313-a17a-4af0-b68f-8bdefd0a035d
md"""
### Short-circuiting and the ternary operator

The `if`-statement is one of the most used in programming, since it allows the program to respond differently depending on different conditions. In cases where `if`-statements are short, the syntax can become bulky, so can be substituted for some concise alternatives.

Usually, the **AND** (`&&`) and **OR** (`||`) operators are used for combining logical statements. An optimisation which allows more efficient code is *short-circuiting*:
- Consider the statement `<statement-1> && <statement-2>`. If `<statement-1>` is `false`, then there is no need to evaluate `<statement-2>`, since the overall result will always be `false`, so Julia *short-circuits* by ignoring it and simply returning `false`
- Similarly, in the case `<statement-1> || <statement-2>` with `<statement-1>` true, the overall result will be `true` without checking `<statement-2>`
A useful way of using this is to have `<statement-2>` not be a logical statement at all, and instead be a piece of code. This will then only run if no short-circuit is made, abbreviating:
```julia
if <statement-1>
	<statement-2>			=>			<statement-1> && <statement-2>
end
```
and
```julia
if !<statement-1>
	<statement-2>			=>			<statement-1> || <statement-2>
end
```
For example:
"""

# ╔═╡ 0d6f6cf0-4706-4469-bd4b-ca65af27ffe6
3 > 4 && "Secret message"

# ╔═╡ 3ac36546-1ddd-479d-86c5-d02e07993069
3 < 4 && "Secret message"

# ╔═╡ 89b0c356-3962-4201-abb6-caeb334fce6a
md"""
Another common use for an `if`-statement is to assign a variable one of two values, depending on whether a condition is met or not. This can be done by the ternary operator, which provides the following abbreviation
```julia
if <condition>
	x = <valueif>
else 						=>		x = (<condition> ? <valueif> : <valueelse>)
	x = <valueelse>
end
```
which can be seen in the following example:
"""

# ╔═╡ c5193537-9e52-4391-b352-3aaf640192c4
3 > 4 ? "This is true" : "This is false"

# ╔═╡ db2c9293-1c23-4708-b1a9-5ed013d1f8f4
3 < 4 ? "This is true" : "This is false"

# ╔═╡ f3cfccf4-ff2d-44af-9735-242c2c1e80ac
md"""
Alternatively, consider how the function `h` in the previous section could be rewritten to make use of the ternary operator.
"""

# ╔═╡ 4325ba80-3823-4c76-992e-351969e67222
md"""
### Broadcasting and splat

If a function takes an array (such as a vector or a matrix) or similar collection (such as a tuple) as an input, it will treat it as such, and operations will act as such (such as matrix products). However, sometimes different behaviour is desired.

Julia has inbuilt functionality for elementwise operation without needing to define a separate function to do so, which is called broadcasting. Consider the function:
"""

# ╔═╡ 84588d2f-de11-44d3-8b1d-afcaa9b59282
p(x) = x^3 - 4x^2 + 2x

# ╔═╡ cb5f1991-5928-4bae-b853-935d08c1f61a
A = [ [1,2,3] [4,5,6] [7,8,9] ]

# ╔═╡ f7943ee4-6927-4aef-b97e-b70691e431f7
md"""
For matrix `A`, `p(A)` is defined by squaring and cubing `A`
"""

# ╔═╡ e526a902-224f-4f19-8bab-7c53be471671
p(A)

# ╔═╡ d9788710-0493-41b2-8510-08ff76614977
md"""
If instead we want `p` to act elementwise, Julia provides two simple options. The first is the `broadcast` function:
"""

# ╔═╡ cb4f8751-6678-4db3-98f1-2c380d272428
broadcast(p,A)

# ╔═╡ 6ee30cb8-70c9-46fb-bc03-c1917a342ffc
md"""
and the second is following the function name with a `.`:
"""

# ╔═╡ fffd5baf-9142-4c32-9a85-c0258e6366be
p.(A)

# ╔═╡ 30f3d516-6f44-4eb3-8792-aa4e5ef7a93f
md"""
Another thing that you may need to do with an array is pass each element individually as separate arguments to a function, which is done through the splat operator `...`. As an example, consider the difference between:
"""

# ╔═╡ 7c081773-bb95-489c-844a-16f9c5bd950f
+(A)

# ╔═╡ 8c58354d-8a1f-400b-a4a1-ff2ea9016e72
+(A...)

# ╔═╡ 91855dee-a9a6-4782-b4af-62a87c2705b3
md"""
The same syntax has another use, that is for defining your own functions with an arbitrary number of arguments without needing them to be contained in a tuple beforehand, such as:
"""

# ╔═╡ f1a45f51-6ad6-43c2-904f-4fff9e399535
function myminimum(x...)
	m = Inf
	for y ∈ x
		if y < m
			m = y
		end
	end
	return m
end

# ╔═╡ 0b5793f1-8834-4258-846d-47b76bc9b6c8
md"""
Here, `x` captures all of the inputs to the function in a single tuple, meaning that any number of arguments can be specified without needing to write separate functions:
"""

# ╔═╡ 4df7cae4-4eeb-4681-a8d3-00c4f457ded2
myminimum(12,15,9,151,23)

# ╔═╡ d3d71501-0dc7-4d9e-a3b4-4cc62aa640ab
myminimum(π,ℯ,Inf)

# ╔═╡ ab8d0a33-c0cd-4ad3-9d94-b9b1afbcca4b
md"""
### Packages

As it is, Julia is already equipped with many useful tools, which for some projects may already be sufficient to complete them. However, there is far more that Julia can do through the package system.

Packages are (usually quite specialised) extensions to Julia's functionality which can be downloaded and used in your programs. Any of these can be downloaded for the first time by running `using Pkg; Pkg.add("<package-name>")` in the REPL. Alternatively, pressing `]` in the REPL puts it in package mode, allowing packages to be downloaded by simply typing `add("<package-name>")`. This only needs to be done the first time that a package is used, as it will download and remain accessible to you in the future. To access the functionality of the package, run `using <package-name>`.

Over 4000 packages exist for Julia, which can be searched through by any of the options linked at <https://julialang.org/packages/>. Some particularly useful packages are used in this manual, as well as in the accompanying case studies.
"""

# ╔═╡ 2691d33f-7ecc-4c5b-a249-ac3f16fbefdb
md"""
### Expressions and Macros

The `Expr` data type is used to store Julia code as a variable, which is not run until the user wishes to evaluate it. For example:
"""

# ╔═╡ 46c6cbb6-e2a7-4ad9-8869-8f31a15c9358
q = quote
	if 3 < 4
		return true
	else
		return false
	end
end;

# ╔═╡ dbe458d4-f24a-4f8d-8c31-b18555afa57b
md"""
`q` stores the entire block of code as written inside the `quote`-`end` block as a variable, which can be run at a later stage with `eval`.
"""

# ╔═╡ 9e65f10e-3963-45c6-a517-cb78756d8d77
typeof(q)

# ╔═╡ 2e9e8b67-7173-4e77-b5d1-f7eaa8834b5e
eval(q)

# ╔═╡ 47a3f741-4064-477e-8eb9-fc0ccac5858c
md"""
These can be useful in many situations, such as to operate on pieces of code, or generate code automatically to simplify repetitivity. As an example, suppose we want to calculate the first ``50`` Fibonacci numbers and store them as `F₁`, `F₂`, ..., `F₅₀`. First, we can write a custom function to get the symbol `:Fₙ` (which is much like an `Expr` but represents a single variable/function name instead of a larger snippet of code) from an integer `n`:
"""

# ╔═╡ 18d2d68b-95cb-44a6-93d6-0f1dfd32b03a
function symbolFn(n)
	subscriptn = String([Char(0x2080+d) for d in reverse(digits(n))])
	return Symbol("F",subscriptn)
end

# ╔═╡ de04ed4a-84f4-4030-84dd-0092e7772ffa
symbolFn(123)

# ╔═╡ 1a0ee7c6-58ca-44e5-a94d-b5cf60940392
md"""
Then, the variables themselves can be created:
"""

# ╔═╡ c24f6d7e-0c78-41f4-9468-3d4a6210c47a
begin
	F₁ = 1
	F₂ = 1
	for n ∈ 3:50
		eval( :( $(symbolFn(n)) = $(symbolFn(n-1)) + $(symbolFn(n-2)) ) )
	end
end

# ╔═╡ 61ba579c-981f-48df-a002-ab452897c311
md"""
and then displayed (note that the `with_terminal` function creates the terminal for the notebook, in the REPL only the `[println ...]` line is needed):
"""

# ╔═╡ ffd60a8d-0c0a-4f76-8948-d6314d344878
with_terminal() do
	[println( String(s), " = $(eval(:($s)))" ) for s ∈ symbolFn.(1:15)]
end

# ╔═╡ a0e8c156-480d-40d5-a3dc-36e1757ae0f5
F₅₀

# ╔═╡ 85843b08-dcf9-4449-88f9-255773605970
md"""
One particular use for expressions is in macros. These are function-like in that they take an input, run some pre-determined code using the input, and produce an output. However, macros differ from functions as they take their inputs as `Expr`s, and also return `Expr`s which are then run as code. Macros are distinguished as such by an `@` preceding their name.

For example, the macro `@mutiple` runs the input code `n` times (note that `n` is specified as an integer by the double colon, so the macro will not run unless an integer is given). An example usage of this macro is also shown below:
"""

# ╔═╡ cdde6b43-39f2-4cda-bfea-eef48ee494eb
macro multiple(n::Integer, expr)
    return quote
        $([esc(expr) for i ∈ 1:n]...)
    end
end

# ╔═╡ 3c21e020-7287-4a3c-9046-7e2ab1150065
begin
	x = 1
	@multiple 10 x += 1
end;

# ╔═╡ fb37b982-a6f2-4461-ab12-6cf6e3a2837f
x

# ╔═╡ 9193e3e6-f1aa-40f8-b009-b712248e72c3
md"""
The macro `@macroexpand` can be used to show the expression returned by another macro before it is evaluated, which helps to see how macros work and is invaluable for debugging custom macros.

Two related useful macros are `@elapsed`, which times how long its argument takes to run in seconds, returning the time while discarding the result, and `@time`, which prints the time and returns the result. An important note about these two is that the first time a function runs, Julia has to compile it first, so it will always be slower than subsequent runs. To counteract this, make sure to either run the function first, or use the macros from `BenchmarkTools` as described in the next section [Efficiency](#d508655f-663b-4baa-af93-d0cbd5935a97).
"""

# ╔═╡ a6023033-f699-4913-83b3-d4abb76e42e6
begin
	inv([[1,0] [0,1]])
	@elapsed inv(rand(1000,1000))
end

# ╔═╡ 8e0bb01c-93e6-4f7b-9d5f-6f815370bad6
md"""
Further uses for macros can be seen in later sections.
"""

# ╔═╡ d508655f-663b-4baa-af93-d0cbd5935a97
md"""
### Efficiency

One of the principal advantages that Julia has over other languages, especially Matlab, is the speed of execution, and the ease of achieving this. This is because Julia is able to efficiently translate its code into the same machine code as from the equivalent compilation of C code (arguably the gold-standard for efficiency), giving Julia readability and usability while not compromising on speed. A discussion of this is given (with an aesthetic that conceals its modernity) at <https://web.mit.edu/18.06/www/Spring17/Julia-intro.pdf>

Additionally, Julia has many inbuilt ways to exploit knowledge of properties of the variables in order to increase the speed of execution. To demonstrate one instance of this, we will use the `LinearAlgebra` package (which includes many opportunities for such shortcuts to be made) and the `BenchmarkTools` package (which provides better macros for estimating the average time that a function takes than `@time` or `@elapsed`).

"""

# ╔═╡ 086ee7e2-4159-4ddd-bd56-f7c5474696a4
md"""
One of the matrix types that `LinearAlgebra` presents is `Hermitian`, which is a useful property of a matrix to be able to exploit, since quicker algorithms exist for many tasks for Hermitian matrices compared to general matrices. To demonstrate this, we will time calculating the eigenvalues of random ``1000 \times 1000`` complex matrices versus random ``1000 \times 1000`` Hermitian matrices (which are in fact random complex matrices turned into Hermitian matrices by removing the imaginary parts from the diagonal entries and transposing the complex conjugate of the triangle above the diagonal onto the triangle below the diagonal):
"""

# ╔═╡ 9cca126f-d8c9-46de-9cc7-2a7a4d94beaa
@belapsed eigvals(rand(ComplexF64,1000,1000))

# ╔═╡ 285f7f1c-6f64-46c4-8956-69dd8988b131
@belapsed (eigvals ∘ Hermitian ∘ rand)(ComplexF64,1000,1000)

# ╔═╡ dd71ca55-2e7b-40e7-9811-97739b236eaa
md"""
The use of the composition has no impact on the speed, but helps with readability by avoiding large stacks of parentheses.

Julia can also recognise properties in matrices that it isn't told. For example, if the random Hermitian matrices are returned to the normal `Matrix` type, the `eigvals` algorithm is still just as fast:
"""

# ╔═╡ 106b6981-0691-46ad-a74c-637eaf97c91d
@belapsed eigvals(H) setup = (H = (Matrix ∘ Hermitian ∘ rand)(ComplexF64,1000,1000))

# ╔═╡ 7091f035-8f17-460f-a9e9-d7cd9198e106
md"""
In order for your own code to make best use of the potential efficiency that Julia boasts, refer to documentation, the case studies accompanying this manual, as well as <https://docs.julialang.org/en/v1/manual/performance-tips/>.
"""

# ╔═╡ 3665a395-ae1c-40cf-8e98-00534f53ee4f
md"""
## Customising outputs

*Note: Code referencing external files in this section is not interactive. To see the functionality in full, transfer the code yourself to your own scripts and test them out.*

As standard, most outputs that Julia will be able to give will be in terms of variables such as numbers, vectors, matrics, etc., or text printed to the REPL. For more complex outputs, we need to look further afield.
"""

# ╔═╡ 992d6562-950d-4071-b189-b39a13fb7f30
md"""
### Outputting to files

One option for a different output is to send the outputs to a separate file instead of the REPL. This is done in three steps:
- Open a file which can be written into (denoted by the `"w"` parameter) as a variable (so that it can be referenced later). The file name given represents a path relative to the current folder, which can be viewed by `pwd()`. If no file with this path exists, one will be created.
```julia
textfile = open("text.txt", "w")
```
- Write into the file, by using functions such as `show` and `println` in combination with the file as a parameter. For example, the vector `a = [1, 2, 3, 4]` can be written into the file by
```julia
println(textfile, a)
```
- Close the file to save it
```julia
close(textfile)
```
If all of the data needed to be written into the file is ready, these can be combined into a single statement, of the form
```julia
open("text.txt", "w") do textfile
	println(textfile, a)
end
```
which will automatically close the file once the `do` statement has finished.
"""

# ╔═╡ a4c99e37-b3b8-446e-a655-d4ac1237d0c7
md"""
### Creating tables with PrettyTables

A table is often the best way to present data, so having a way of creating them automatically is very useful. Contrary to expectation, the package `Tables` is not the package to do this, since it is more useful for database-like manipulation of tables rather than displaying them as objects. For this purpose, one good option is `PrettyTables`.
"""

# ╔═╡ 4f886a63-42fa-4c4d-b7fe-c0caa2884ad3
md"""
In its most basic usage, `PrettyTables` allows the conversion of a matrix into a table
"""

# ╔═╡ 0a95770e-b495-4a4d-9e59-d1fbf662829d
M = rand(4,4)

# ╔═╡ 8f408461-f868-41d8-98c9-42babca608f7
with_terminal() do
	pretty_table(M)
end

# ╔═╡ 24e06691-f641-4f41-a3f4-dfd57f600c68
md"""
One important note with `PrettyTables` is that the tables outputted are printed to the REPL (or another output of choice as we'll see later), and are not returned as variables. As a result, for display purposes within this notebook, the tables will have to be returned in mini-terminals as above, created by the function `with_terminal`. Unfortunately, the limitations of these terminals means that many features of `PrettyTables` cannot be viewed directly from this notebook. To use this code in the REPL, copy only the contents of the `do` block (in this case `pretty_table(M)`).

The power of `PrettyTables` comes in the multitude of customisations that can be made to the table. These, and the package as a whole, are comprehensively documented at <https://ronisbr.github.io/PrettyTables.jl/stable/>.

The most impactful keyword is `backend`, which allows the choice between three forms of output for the table (and most other keywords depend on which backend is chosen):
- `backend = :text` is the default, outputting the table in raw text
- `backend = :html` outputs HTML defining the table
- `backend = :latex` outputs $\LaTeX$ code defining the table as a `tabular` object

`PrettyTables` also allows creating preset configurations which can be used for multiple tables. This can be done either through the `set_table_conf` and `pretty_table_with_conf` functions:
"""

# ╔═╡ e9eca1cf-149e-4763-8024-1093841c5430
tableconfig = set_pt_conf(
	tf = tf_markdown,
	columns_width = 15,
	alignment = :c,
	formatters = ((value,i,j) -> round(value, digits = 3))
);

# ╔═╡ 359594ae-dc8b-4d59-babd-5d5163098cad
with_terminal() do
	pretty_table_with_conf(tableconfig, M; header = ["Player $i" for i = 1:4])
end

# ╔═╡ 384289b4-2788-47ba-a061-7ce025db7a4b
md"""
or through the use of macros, with `@ptconf` setting the configuration, `@pt` using this configuration to display tables, and `@ptconfclean` clearing the configuration:
"""

# ╔═╡ 3a54dbdb-7fa8-4fcc-864a-f67a8c3df010
@ptconf(
	backend = :latex,
	highlighters = LatexHighlighter((data,i,j) -> data[i,j] > 0.5, "textbf"),
	wrap_table = false,
	alignment = :c
)

# ╔═╡ 87ee2688-4612-48f3-b75f-af68ce8061f7
with_terminal() do
	@pt :header = ["Player $i" for i = 1:4] M
end

# ╔═╡ 736b81c0-f10f-4dcb-a1a3-0791bc169cee
md"""
In addition, the outputs can be written to files much like `show` or `println` can have their output written to files:
```julia
open("tablefile.txt", "w") do io
	pretty_table(io, M; header = ["Player $i" for i = 1:4])
end
```
"""

# ╔═╡ 6916be23-b667-471a-bd5d-e45163e7f7df
md"""
### Creating and saving graphics with Plots

One of the most useful packages for Julia is the `Plots` package, allowing the creation of plots, graphs, and diagrams of many kinds.
"""

# ╔═╡ 0e81d3de-fc91-4327-a9a2-8b375d74f4fa
md"""
The most basic plots that `Plots` makes are line graphs between input points, or plots of functions:
"""

# ╔═╡ 6a6a1d26-c4b7-4acf-9cb9-028415d36655
begin
	xdata = collect(1:10)
	ydata = [10,6,5,4,8,9,3,4,2,1]
	plot(xdata, ydata)
end

# ╔═╡ cd9b60e0-11d3-4a7d-bbfc-2576d64364ff
plot(sinc)

# ╔═╡ 79b48255-2f6d-4825-8139-9825a71100cb
md"""
Changing attributes allows the appearance of the plot to be customised. Some of the most useful are:
- `title` controls the title of the plot
- `label` controls the name given to the line in the legend, `legend` controls whether the legend appears or not
- `xlims` and `ylims` (and `zlims` for 3D plots) control the extent of the corresponding axis
- `grid` controls whether a grid appears in the background of the plot, while `minorgrid` does the same with a grid with smaller divisions
- `showaxis` controls which axes are shown, while `ticks` controls the numbering of the axes
A more complete list can be found in the documentation at <http://docs.juliaplots.org/latest/>
"""

# ╔═╡ 81de08b7-e78c-4238-9eb5-d032dbd55fd0
plot(
	tan,
	title = "The tangent function",
	legend = false,
	xlims = (-π,π),
	ylims = (-10,10),
	grid = false,
	showaxis = :x,
	framestyle = :origin
)

# ╔═╡ b475321e-824e-4a77-bb4c-07d7730591f1
md"""
Different plot types can be chosen using the attribute `seriestype`, or for some more common types, a specialised function. Additional series types can be found in other packages, such as `StatsPlots` for additional methods of statistical data visualisation, and `GraphRecipes` for plotting graphs of the graph theoretical kind. Also, plots can be saved as variables and then added to with `plot!` and related functions:
"""

# ╔═╡ f31c2367-d0de-485b-a06f-2b29cb1d319a
plot(
	[(0,1),(4,3),(1,6),(5,2),(6,3),(2,4)],
	label = "Blue",
	seriestype = :scatter,
	xlims = (-1,7),
	ylims = (-1,7),
	framestyle = :origin
)

# ╔═╡ 3fab1731-0854-4248-89e2-e04cc909c68c
barchart = bar(
	[("A",4),("B",5),("C",1),("D",4),("E",6),("F",2)],
	legend = false,
	fillcolor = :green
)

# ╔═╡ 98f2a28d-5a83-4981-acb2-d68268bc03a7
bar!(
	barchart,
	[("A",2),("B",6),("C",3),("D",3),("E",6),("F",5)],
	color = :red,
	bar_width = 0.5
)

# ╔═╡ ebdfd3f2-7d95-4391-81e4-1d384b6aa52a
md"""
Different plots can be grouped together into a single image, with the layout customisable by using the `layout` attribute:
"""

# ╔═╡ 37da7e59-a1e3-454c-86ee-959c761fedeb
begin
	function customfnplot(fnname)
		return plot(
			eval(Meta.parse(fnname)),
			xlims = (0,4π),
			legend = false,
			title = fnname
		)
	end
	
	sinplot = customfnplot("sin")
	cosplot = customfnplot("cos")
end;

# ╔═╡ e44a80d2-dd32-443b-a918-2af821cad6ac
doubleplot = plot(sinplot, cosplot, layout = (2,1))

# ╔═╡ 6ceecd44-e185-4bcd-993c-94677f033714
md"""
Plots can be saved as files by the function `savefig`, or can be saved by file type specific functions such as `png`. The following code, if run, would save the `doubleplot` graph as *sinandcos.png*:
```julia
png(doubleplot,"sinandcos")
```
"""

# ╔═╡ a8973a1e-b1a7-4792-8c0a-4c8c8b4ecd60
md"""
## Example - The logistic map

The logistic map (<https://en.wikipedia.org/wiki/Logistic_map>) is given by the difference equation 

```math
x_{n+1} = r x_n (1 - x_n) 
```

where `` x_0 \in [0,1] `` and `` r \in [0,4] ``. It is notable for its chaotic behaviour as ``r`` approaches ``4``.

To begin with, we need a function to iterate the difference equation:

"""

# ╔═╡ d595f9fe-83bc-497a-8f2e-558bf893a3b7
logisticiteration(r,x) = r * x * (1-x)

# ╔═╡ 7c0491c6-8144-4b0c-83d3-7011c6e98b9a
md"""
We will run the difference equation for `N` iterations:
"""

# ╔═╡ 5df85afe-df4c-4812-be38-8b9e2ba8f261
N = 100

# ╔═╡ b8727283-b7f3-4d76-addf-3ca45ac7703b
md"""
Choose a value for x₀ (in general this doesn't massively impact the eventual result):
"""

# ╔═╡ ac8421b4-a2da-4274-9192-9c8c1f9790f9
x₀ = 0.5

# ╔═╡ 43546149-7226-4e06-a7ce-6c6f8c4cddae
md"""
Now choose a value for r:
"""

# ╔═╡ e2c61bfb-9abf-4dda-a8bc-0adeb163b6b4
r = 3.1

# ╔═╡ 2bfdf102-f4c5-4f17-8440-6722095a901e
md"""
We then iterate the function `logisticiteration`, and finally can plot the graph of ``x_n`` against ``n``
"""

# ╔═╡ ee0d8687-73f7-497f-9222-61578e2391e8
begin
	sequence = zeros(N+1); sequence[1] = x₀;
	for n ∈ 1:N
		sequence[n+1] = logisticiteration(r,sequence[n])
	end	
end

# ╔═╡ 976d19d8-f319-43de-ad60-d5706db26df8
plot(0:N, sequence, legend=false)

# ╔═╡ 851db6f0-0194-4c88-83dd-c2570c0c8729
md"""
If ``r > 3``, the oscillatory behaviour characterising the beginning of the chaotic behaviour of the logistic map is evident. However, it is not the best graphical demonstration of the chaos which occurs for ``r ⪆ 3.57``; instead let's approximate the bifurcation diagram, a graph of the parameter `r` against the corresponding oscillatory values of the difference equation. For this, the algorithm that will be used is detailed at <http://www.math.le.ac.uk/people/rld8/ma1251/lab3.html>.

To start with, choose a range of values of `r`. The syntax `0:0.005:4` gives all of the numbers counting from `0` to `4` in intervals of `0.005`:
"""

# ╔═╡ adbdc425-5de6-42be-9399-36f24f2d8316
rvalues = 0:0.005:4

# ╔═╡ b3d635a1-6c3a-4d0b-800c-d08c5c7a7789
md"""
All iterations will start with `x₀ = 0.5`. We need to discard the earliest iterations before they have converged close to the eventual oscillatory values of the sequence
"""

# ╔═╡ a643373c-ca5f-4d7d-9e94-9d1dcc7446e7
discardediterations = 200

# ╔═╡ 6d2765c1-ed26-4c78-98d8-02c71e7c2af6
md"""
Then, the sequence will continue for some more iterations to ensure that many of the oscillatory values are plotted. We need to put a limit on this number of iterations otherwise the program won't terminate
"""

# ╔═╡ 96e2fbe3-8569-49a8-af5b-bae456024b66
maxoscillatoryvalues = 100

# ╔═╡ aad017bb-7fa3-4af6-85cc-6d9018c744d8
md"""
For each value of ``r``, we run the iteration, plotting each point, and terminating early for efficiency if any iteration results in a value sufficiently close (in this case within ``0.001``) to the last discarded value.
"""

# ╔═╡ 62c56061-9064-45a2-bf9b-c9f17fb2f8cd
md"""
If you are viewing this manual as an editable Pluto notebook, try some different ranges for `rvalues` (in particular, an interesting result occurs by choosing a range of values from ``-2`` to ``0``). It may be necessary to press the button below to refresh the graph.
"""

# ╔═╡ 3de49c33-a185-4a67-820c-e1b87a48b484
@bind bifurcationreset Button("Recalculate graph")

# ╔═╡ 547a3549-ba11-4dbc-b316-0c2dd7384b0d
begin
	bifurcationreset
	points = Vector{Tuple{Float64,Float64}}(undef, 0)
end;

# ╔═╡ ad032574-1ca6-483d-b642-58af6838f9d0
for rvalue ∈ rvalues
	x = 0.5
	for i ∈ 1:discardediterations
		x = logisticiteration(rvalue,x)
	end
	maxdiscardedvalue = x
	for i ∈ 1:maxoscillatoryvalues
		x = logisticiteration(rvalue,x)
        push!(points,(rvalue, x))
		if abs(x - maxdiscardedvalue) < 0.001
			break
		end
	end
end

# ╔═╡ 97d306da-666d-4ba9-bd6c-16b79212f926
bifurcationplot = scatter(points, markersize = 1, markercolor = :black, legend = false, xlims = (min(rvalues...),max(rvalues...)), ylims = (-0.5,1.5))

# ╔═╡ 3cb29926-3332-429b-b8b6-0b95113b388b
md"""
## Pluto notebooks

Pluto notebooks are created from the Pluto package for Julia. They act as an alternative, more interactive method of presentation of Julia code; indeed this manual itself is a Pluto notebook. Pluto notebooks are edited from the browser, with text written in Markdown, which is simple but reasonably powerful text-editing tool, with a good introductory guide at several pages of <https://www.markdownguide.org/>.

Other than being made specifically for Julia, Pluto's main draw is its reactivity, meaning that different cells work more like a live-updating network of code than a simple linear script. This can mean that not all Julia programs are suitable for Pluto notebook form, but does provide an excellent method of presentation for Julia code as well displaying the outputs beside the code which creates them, while also allowing efficient editing of code and recalculation of only the cells which are affected by these edits.

To use Pluto:
  - Run `using Pkg; Pkg.add("Pluto");` in the Julia REPL and wait for the package to be downloaded and installed
  - Now run `using Pluto; Pluto.run()`, which should open in your browser, or give an address of the form `localhost:1234/?secret=XXXXXXXX` for you to open
  - You will be presented with a welcome page. A good place to start is the sample notebooks provided by the developers of Pluto, or this manual (see section [Using this manual](#b695a54f-da17-4acf-aa30-5fb2344df48e)) and the case studies that go along with it

A similar although not Julia-specific notebook tool is Jupyter, which can be installed for VSCode or run in the browser like Pluto. For more information on this, see <https://jupyter.org/>, and the Jupyter extension for VSCode found through the extension search.

### Excess Pluto code

The following code is run for the purposes of creating the contents table, and is not otherwise relevant to the discussion in this manual.

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
BenchmarkTools = "~1.3.2"
Plots = "~1.39.0"
PlutoUI = "~0.7.52"
PrettyTables = "~2.2.7"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "e8ed9fe90d1a3c145520e392ec46ee0a65a5cf1b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "d9a9701b899b30332bbcb3e1679c41cce81fb0e8"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.2"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "02aa26a4cf76381be7f66e020a3eddeb27b0a092"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

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

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "ee094908d720185ddbdc58dbe0c1cbe35453ec7a"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.7"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "7c29f0e8c575428bd84dc3c72ece5178caa67336"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.2+2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "a72d22c7e13fe2de562feda8645aa134712a87ee"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.17.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "24b81b59bd35b3c42ab84fa589086e19be919916"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.11.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "cf2c7de82431ca6f39250d2fc4aacd0daa1675c0"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.4+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

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
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

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
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─58a85b40-e086-11eb-1471-a3d9d5596625
# ╟─b695a54f-da17-4acf-aa30-5fb2344df48e
# ╟─45aa5e5d-b518-4f28-ab45-365a9c3d4ee1
# ╟─6dab02d3-4b45-4227-a790-00350002a909
# ╠═07d24863-82aa-4b13-aa92-1b06a0b5276b
# ╠═c8366549-83b0-4a1c-b526-a4c38c1b1151
# ╠═1c46f6c4-fba1-460d-91ff-a7f5e4506041
# ╟─d3da52ff-1f54-4b15-bdb7-1c213154cc89
# ╠═21f97b7f-7dd1-4f12-9812-081f08ed3f1f
# ╟─6d3d80e1-c4e9-43eb-8750-48ce16a55e63
# ╟─ffcdf202-a14d-417a-9a82-bf3e5ba38972
# ╟─af2dd15c-cb27-483f-b047-69c70d9e7532
# ╟─6cf95416-a4d0-442b-8dfa-5e59d07d4a15
# ╠═92715aab-25fe-4387-9fd9-45c7e632b50d
# ╠═a151d910-5408-40cc-a352-2eeef5434551
# ╟─4f540782-83d9-4401-8865-78bb39af2aae
# ╠═dd43c006-3455-49db-97bc-e928408a0539
# ╠═45a265d6-b489-49d1-b93d-4907f6ea66b2
# ╟─26b5cc22-db0b-46f4-9d45-d3830223d336
# ╠═59b2dc85-0ce7-4e99-aeae-170cc13cfe87
# ╠═2bb4926a-2b5b-4e02-b1f9-d8225b909ae5
# ╠═e3884fe1-4451-4601-b483-6b4ee03d572e
# ╟─74e50b24-39d8-49b4-b651-e4cbe07d382f
# ╠═0c4f78f4-055b-47fd-8c64-8a77259a13c1
# ╟─a2cf252e-604c-40b7-9bff-d0970ebf9b80
# ╠═cef7f72e-73fe-4a6a-b807-46e14d794014
# ╠═a5717ddf-2e3c-4138-8d7c-40f9d6fb1a12
# ╟─be6f9061-dd1b-4c8a-bd13-82455e8a0207
# ╠═a671de2a-de76-4728-bf7b-f751c284aace
# ╟─1b859eb6-525f-4405-b4fc-181ff335532b
# ╠═c33eeb03-07d8-4f16-8691-568bc830e468
# ╟─7e80b6cc-d4b6-45c7-a14f-76e0f67a6053
# ╟─2fe58313-a17a-4af0-b68f-8bdefd0a035d
# ╠═0d6f6cf0-4706-4469-bd4b-ca65af27ffe6
# ╠═3ac36546-1ddd-479d-86c5-d02e07993069
# ╟─89b0c356-3962-4201-abb6-caeb334fce6a
# ╠═c5193537-9e52-4391-b352-3aaf640192c4
# ╠═db2c9293-1c23-4708-b1a9-5ed013d1f8f4
# ╟─f3cfccf4-ff2d-44af-9735-242c2c1e80ac
# ╟─4325ba80-3823-4c76-992e-351969e67222
# ╠═84588d2f-de11-44d3-8b1d-afcaa9b59282
# ╠═cb5f1991-5928-4bae-b853-935d08c1f61a
# ╟─f7943ee4-6927-4aef-b97e-b70691e431f7
# ╠═e526a902-224f-4f19-8bab-7c53be471671
# ╟─d9788710-0493-41b2-8510-08ff76614977
# ╠═cb4f8751-6678-4db3-98f1-2c380d272428
# ╟─6ee30cb8-70c9-46fb-bc03-c1917a342ffc
# ╠═fffd5baf-9142-4c32-9a85-c0258e6366be
# ╟─30f3d516-6f44-4eb3-8792-aa4e5ef7a93f
# ╠═7c081773-bb95-489c-844a-16f9c5bd950f
# ╠═8c58354d-8a1f-400b-a4a1-ff2ea9016e72
# ╟─91855dee-a9a6-4782-b4af-62a87c2705b3
# ╠═f1a45f51-6ad6-43c2-904f-4fff9e399535
# ╟─0b5793f1-8834-4258-846d-47b76bc9b6c8
# ╠═4df7cae4-4eeb-4681-a8d3-00c4f457ded2
# ╠═d3d71501-0dc7-4d9e-a3b4-4cc62aa640ab
# ╟─ab8d0a33-c0cd-4ad3-9d94-b9b1afbcca4b
# ╟─2691d33f-7ecc-4c5b-a249-ac3f16fbefdb
# ╠═46c6cbb6-e2a7-4ad9-8869-8f31a15c9358
# ╟─dbe458d4-f24a-4f8d-8c31-b18555afa57b
# ╠═9e65f10e-3963-45c6-a517-cb78756d8d77
# ╠═2e9e8b67-7173-4e77-b5d1-f7eaa8834b5e
# ╟─47a3f741-4064-477e-8eb9-fc0ccac5858c
# ╠═18d2d68b-95cb-44a6-93d6-0f1dfd32b03a
# ╠═de04ed4a-84f4-4030-84dd-0092e7772ffa
# ╟─1a0ee7c6-58ca-44e5-a94d-b5cf60940392
# ╠═c24f6d7e-0c78-41f4-9468-3d4a6210c47a
# ╟─61ba579c-981f-48df-a002-ab452897c311
# ╠═ffd60a8d-0c0a-4f76-8948-d6314d344878
# ╠═a0e8c156-480d-40d5-a3dc-36e1757ae0f5
# ╟─85843b08-dcf9-4449-88f9-255773605970
# ╠═cdde6b43-39f2-4cda-bfea-eef48ee494eb
# ╠═3c21e020-7287-4a3c-9046-7e2ab1150065
# ╠═fb37b982-a6f2-4461-ab12-6cf6e3a2837f
# ╟─9193e3e6-f1aa-40f8-b009-b712248e72c3
# ╠═a6023033-f699-4913-83b3-d4abb76e42e6
# ╟─8e0bb01c-93e6-4f7b-9d5f-6f815370bad6
# ╟─d508655f-663b-4baa-af93-d0cbd5935a97
# ╠═5667c9d7-46ce-47ce-bfb7-5851cf8e80a7
# ╟─086ee7e2-4159-4ddd-bd56-f7c5474696a4
# ╠═9cca126f-d8c9-46de-9cc7-2a7a4d94beaa
# ╠═285f7f1c-6f64-46c4-8956-69dd8988b131
# ╟─dd71ca55-2e7b-40e7-9811-97739b236eaa
# ╠═106b6981-0691-46ad-a74c-637eaf97c91d
# ╟─7091f035-8f17-460f-a9e9-d7cd9198e106
# ╟─3665a395-ae1c-40cf-8e98-00534f53ee4f
# ╟─992d6562-950d-4071-b189-b39a13fb7f30
# ╟─a4c99e37-b3b8-446e-a655-d4ac1237d0c7
# ╠═b4c31904-2384-425d-a12b-5f3c145bc5fb
# ╟─4f886a63-42fa-4c4d-b7fe-c0caa2884ad3
# ╠═0a95770e-b495-4a4d-9e59-d1fbf662829d
# ╠═8f408461-f868-41d8-98c9-42babca608f7
# ╟─24e06691-f641-4f41-a3f4-dfd57f600c68
# ╠═e9eca1cf-149e-4763-8024-1093841c5430
# ╠═359594ae-dc8b-4d59-babd-5d5163098cad
# ╟─384289b4-2788-47ba-a061-7ce025db7a4b
# ╠═3a54dbdb-7fa8-4fcc-864a-f67a8c3df010
# ╠═87ee2688-4612-48f3-b75f-af68ce8061f7
# ╟─736b81c0-f10f-4dcb-a1a3-0791bc169cee
# ╟─6916be23-b667-471a-bd5d-e45163e7f7df
# ╠═1cbe8ec9-a704-4912-98d2-69385c773627
# ╟─0e81d3de-fc91-4327-a9a2-8b375d74f4fa
# ╠═6a6a1d26-c4b7-4acf-9cb9-028415d36655
# ╠═cd9b60e0-11d3-4a7d-bbfc-2576d64364ff
# ╟─79b48255-2f6d-4825-8139-9825a71100cb
# ╠═81de08b7-e78c-4238-9eb5-d032dbd55fd0
# ╟─b475321e-824e-4a77-bb4c-07d7730591f1
# ╠═f31c2367-d0de-485b-a06f-2b29cb1d319a
# ╠═3fab1731-0854-4248-89e2-e04cc909c68c
# ╠═98f2a28d-5a83-4981-acb2-d68268bc03a7
# ╟─ebdfd3f2-7d95-4391-81e4-1d384b6aa52a
# ╠═37da7e59-a1e3-454c-86ee-959c761fedeb
# ╠═e44a80d2-dd32-443b-a918-2af821cad6ac
# ╟─6ceecd44-e185-4bcd-993c-94677f033714
# ╟─a8973a1e-b1a7-4792-8c0a-4c8c8b4ecd60
# ╠═d595f9fe-83bc-497a-8f2e-558bf893a3b7
# ╟─7c0491c6-8144-4b0c-83d3-7011c6e98b9a
# ╠═5df85afe-df4c-4812-be38-8b9e2ba8f261
# ╟─b8727283-b7f3-4d76-addf-3ca45ac7703b
# ╠═ac8421b4-a2da-4274-9192-9c8c1f9790f9
# ╟─43546149-7226-4e06-a7ce-6c6f8c4cddae
# ╠═e2c61bfb-9abf-4dda-a8bc-0adeb163b6b4
# ╟─2bfdf102-f4c5-4f17-8440-6722095a901e
# ╠═ee0d8687-73f7-497f-9222-61578e2391e8
# ╠═976d19d8-f319-43de-ad60-d5706db26df8
# ╟─851db6f0-0194-4c88-83dd-c2570c0c8729
# ╠═adbdc425-5de6-42be-9399-36f24f2d8316
# ╟─b3d635a1-6c3a-4d0b-800c-d08c5c7a7789
# ╠═a643373c-ca5f-4d7d-9e94-9d1dcc7446e7
# ╟─6d2765c1-ed26-4c78-98d8-02c71e7c2af6
# ╠═96e2fbe3-8569-49a8-af5b-bae456024b66
# ╟─aad017bb-7fa3-4af6-85cc-6d9018c744d8
# ╠═547a3549-ba11-4dbc-b316-0c2dd7384b0d
# ╠═ad032574-1ca6-483d-b642-58af6838f9d0
# ╠═97d306da-666d-4ba9-bd6c-16b79212f926
# ╟─62c56061-9064-45a2-bf9b-c9f17fb2f8cd
# ╠═3de49c33-a185-4a67-820c-e1b87a48b484
# ╟─3cb29926-3332-429b-b8b6-0b95113b388b
# ╠═09a3f57a-db03-4bf4-9129-ab4a0254604e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
