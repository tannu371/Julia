### A Pluto.jl notebook ###
# v0.19.27

#> [frontmatter]
#> author_url = "https://github.com/JuliaPluto"
#> image = "https://user-images.githubusercontent.com/6933510/174067690-50c8128d-748b-4f50-8a76-2ce18166642b.png"
#> order = "3"
#> tags = ["basic", "interactivity", "classic"]
#> author_name = "Pluto.jl"
#> description = "Slider, buttons, dropdowns and more from PlutoUI.jl!"
#> license = "Unlicense"

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

# ╔═╡ 071d9ca5-9b42-4583-ad96-a48f93453a0e
using PlutoUI

# ╔═╡ 46beaa3c-57cf-41f6-a1af-9d55aa167b38
using  HypertextLiteral

# ╔═╡ bc532cd2-c75b-11ea-313f-8b5e771c9227
md"""# PlutoUI.jl

Pluto notebooks can use **`@bind`** to add _interactivity_ to your notebook. It's a simple concept - it uses the same reactivity that you have when editing code, except now you use sliders and buttons, instead of editing code.
"""

# ╔═╡ 3eff9592-cc63-11ea-2b61-4170d1a7656a


# ╔═╡ 051f31fc-cc63-11ea-1e2c-0704285ea6a9
md"""
#### To use it in other notebooks
Simply import the `PlutoUI` package, and Pluto's built-in package manager takes care of the rest!
"""

# ╔═╡ deadce6b-4abc-42b0-9997-07be8637ee94
TableOfContents()

# ╔═╡ fddb794c-c75c-11ea-1f55-eb9c178424cd
md"""
# Basics
"""

# ╔═╡ b819e9a8-c760-11ea-11ee-dd01da663b5c
md"## Slider
A slider over the given values."

# ╔═╡ 34ebf81e-c760-11ea-05bb-376173e7ed10
@bind x Slider(5:15)

# ╔═╡ 1048d1e0-cc50-11ea-1bf3-d76cae42740a


# ╔═╡ a709fd2e-c760-11ea-05c5-7bf673990de1
md"The first argument is a `Vector` or range. You can set the _default value_ using a keyword argument:"

# ╔═╡ d3811ac2-c760-11ea-0811-131d9f1d3910
@bind y Slider(20:0.1:30, default=25, show_value = true)

# ╔═╡ 06962cde-cc4f-11ea-0d96-69a8cb7eeda2


# ╔═╡ 6605d010-d0d1-4cc8-a34d-3158b8572b5d
md"""
## Scrubbable

`Scrubbable` makes a number interactive, you can **click and drag** its value left or right. 

Try it in the text below:
"""

# ╔═╡ 756e2c82-6e2f-4d7b-a1ed-5de97be04269
md"""
_If Alice has $(@bind a Scrubbable(20)) apples, 
and she gives $(@bind b Scrubbable(3)) apples to Bob..._
"""

# ╔═╡ c07c5a9e-61f9-4247-86e7-7c3f9956d0ff
md"""
_...then Alice has **$(a - b)** apples left._
"""

# ╔═╡ c3fea1b2-fc11-4c19-9c01-a8e03fda2817
md"""
Besides an initial value, a scrubbable number also has an array of possible values that can be reached. When you pass a single number to Scrubbable, this array is automatically created.

You can also specify the array manually:
"""

# ╔═╡ ddedffe8-aa06-414a-b37b-e44002dd30ba
@bind apples Scrubbable(200 : 300; default=220)

# ╔═╡ ecc04039-2ab1-439b-b8f8-a7c65cdd177c
md"""
The library [d3-format](https://github.com/d3/d3-format) is used to format floating-point numbers.
"""

# ╔═╡ ee29ff92-ba28-48dc-906f-4df8c25272cb
@bind money Scrubbable(30e6, format=".2s", prefix="€ ")

# ╔═╡ 6433e2f2-e7db-428c-8988-9be8c27c8b0a
@bind coolness Scrubbable(0.80 : 0.01 : 1.00, format=".0%", prefix="you are 🌝 ", suffix=" cool")

# ╔═╡ 221c308e-3cbe-4689-aa67-8970957f8cb0


# ╔═╡ e49623ac-c760-11ea-3689-c15f2e2f6081
md"## NumberField

A box where you can type in a number, within a specific range. 

A `NumberField` can be used just like a `Slider`, it just looks different:"

# ╔═╡ 314cb85a-c761-11ea-1cba-b73f84a52be8
@bind x_different NumberField(0:2:100, default=20)

# ╔═╡ 104b55ce-cc4f-11ea-1273-092a1717e399


# ╔═╡ 4513b730-c761-11ea-1460-2dca56081fcf
md"## CheckBox
A checkbox to choose a Boolean value true/false."

# ╔═╡ 4f8e4e1e-c761-11ea-1787-419cab59bb12
@bind z CheckBox()

# ╔═╡ b787ead6-c761-11ea-3b17-41c0a5434f9b
z

# ╔═╡ 177e6bf0-cc50-11ea-0de2-e77544f5c615


# ╔═╡ b08c347e-c761-11ea-1b61-7b69631d078b
md"Default value:"

# ╔═╡ b53c8ffa-c761-11ea-38d1-2d4ad96a7bee
@bind having_fun CheckBox(default=true)

# ╔═╡ adcf4e68-c761-11ea-00bb-c3b15c6dedc0
having_fun

# ╔═╡ 1a562ad4-cc50-11ea-2485-cdec6e1a78dc


# ╔═╡ 5d420570-c764-11ea-396b-cf0db01d34aa
having_fun ? md"🎈🎈" : md"☕"

# ╔═╡ 09393bf2-cc4f-11ea-1e48-cfbedab8e6b4


# ╔═╡ cd1b5872-c761-11ea-2179-57a3cb34d235
md"## TextField"

# ╔═╡ d9e85ed0-c761-11ea-30bf-83ce272526e0
@bind s TextField()

# ╔═╡ 674523d6-2b86-4d1e-a2e3-3ce8c59c8175
@bind text TextField(placeholder = "text-field")

# ╔═╡ 0934bc0c-cc50-11ea-0da8-0d6b2f275399


# ╔═╡ e690337c-c761-11ea-08be-ade40a464eb4
md"With a default value:"

# ╔═╡ f1f83980-c761-11ea-1e34-97c0ffca3f67
@bind sentence TextField(default="te dansen omdat men leeft")

# ╔═╡ 1cbfd28e-cc50-11ea-2c90-a7807e4979ef


# ╔═╡ 0136af80-c762-11ea-2f1a-9dccff334a11
md"You can also create a **multi-line** text box!"

# ╔═╡ 0e6f0508-c762-11ea-0352-09bd694a9b35
@bind poem TextField((30, 3), "Je opent en sluit je armen,\nMaar houdt niets vast.\nHet is net zwemmen")

# (poem by: Sanne de Kroon)

# ╔═╡ 3dcd7002-c765-11ea-323d-a1fb49409011
split(poem, "\n")

# ╔═╡ f57089fd-b366-45e5-9b50-8a8d2f137891
@bind message TextField((30,5); default="Hello\nJuliaCon!")

# ╔═╡ 6339e49e-0d31-4e06-ad73-987b122c02bc
md"""
!!! note
	* `size`: If size is a tuple (cols::Integer, row::Integer), a multi-line <textarea> will be shown, with the given dimensions. If size is an integer, it controls the width of the single-line input.
	* `default`: the initial value
	* `placeholder`: a value to display when the text input is empty
"""

# ╔═╡ 0aa3c85e-cc4f-11ea-2fba-4bdd513d9217


# ╔═╡ 5833f7f4-c763-11ea-0b95-9b21a40192a9
md"## Select"

# ╔═╡ 690cf3ac-c763-11ea-10f0-b3e28c380be9
@bind vegetable Select(["potato", "carrot"])

# ╔═╡ 1feebd8f-667a-42fd-965d-5e3167ff7c7a
@bind favourite_function Select([sin, cos, tan, sqrt], default = tan)

# ╔═╡ 9128d2c1-364c-4446-baaa-6d0593edda47
favourite_function(2)

# ╔═╡ 3930f0d8-cc50-11ea-3de6-d91ac5c6cd9f


# ╔═╡ ac8c4dee-c763-11ea-1b2d-c590a2d50d7e
@bind fruit Select(["apple" => "🍎", "melon" => "🍉"])

# ╔═╡ dcda9ad2-c763-11ea-3ec6-093b823ba66d
fruit

# ╔═╡ 0c3ab1f8-cc4f-11ea-0cfb-8f076d2c9836


# ╔═╡ 62c6f866-f0fe-11ea-0961-319f28d040d4
md"""
## MultiSelect

This widget allows the user to select multiple element by holding `Ctrl` / `Cmd` while clicking a more items.
"""

# ╔═╡ a01c8096-f0fe-11ea-3e78-ad8551e84fa1
@bind vegetable_basket MultiSelect(["potato", "carrot", "boerenkool"])

# ╔═╡ a20e30f2-f0fe-11ea-0ca7-c5195c9eb24a
vegetable_basket

# ╔═╡ a282d0e2-594d-447c-824d-fb7f85edb483


# ╔═╡ 105202a8-4bd0-4a1d-9144-323aac5876da
@bind chosen_functions MultiSelect([
	cos => "cosine function", 
	sin => "sine function",
])

# ╔═╡ 641d76f9-0bfb-4930-8dd7-3db8d35b97b8
@bind letters MultiSelect(string.('a':'z'), default = ["c", "e"], size=10)

# ╔═╡ 4e727de4-a795-4f43-a5f8-f3aee870bbb9
md"""
!!! note
	The `size` keyword argument may be used to specify how many rows should be visible at once.
"""

# ╔═╡ b104ba6d-0293-4378-9652-f628f1d08d97
md"""
## MultiCheckBox

This widget allows the user to select multiple elements using checkboxes.
"""

# ╔═╡ 16f2218d-f1bc-4b34-a355-53acfa77fbf5
@bind fruit_basket MultiCheckBox(["apple", "blueberry", "mango"])

# ╔═╡ 2c7811cb-d9ea-470c-8cb7-2b3803489f3f
fruit_basket

# ╔═╡ 90d84f1b-042c-444e-8bac-fe358b6d68a1
@bind my_functions MultiCheckBox([sin, cos, tan])

# ╔═╡ b97cfb04-0c39-4709-9419-9294e677a872
[f(π) for f in my_functions]

# ╔═╡ aec9858b-44c1-460b-bbcb-dfefda07a68a


# ╔═╡ 40ea94df-ebeb-4b28-9e66-c66b88791f47
@bind snacks MultiCheckBox(["🥕" => "🐰", "🐟" => "🐱", "🍌" => "🐵"]; default=["🥕", "🍌"])

# ╔═╡ e1c783c7-d338-49f6-a7ab-b9dee5463beb
@bind animals MultiCheckBox(["🐰", "🐱" , "🐵", "🐘", "🦝", "🐿️" , "🐝",  "🐪"]; orientation=:column, select_all=true)

# ╔═╡ 46e6c836-e070-4a2d-b1db-c4a185c35aa6
md"""
!!! note
	* `default = Vector` specifies which options should be checked initally.
	* `orientation` specifies whether the options should be arranged in `:row`'s `:column`'s.
	* `select_all = bool` specifies whether or not to include a "Select All" checkbox.
"""

# ╔═╡ f9c6f24e-fd00-44f1-b876-e559aeed0aa2
md"""
!!! note
	For `Select` `MultiSelect` `MultiCheckbox`
	* You can use any vector of objects, not just strings
	* Instead of an array of values, you can also give an array of pairs, where the first item is the bound value, and the second item is displayed. `bound_value => display_value`
"""

# ╔═╡ 0b1ce22e-c764-11ea-3d60-e799d58aee30
md"## Button"

# ╔═╡ ff0e137e-d3fb-4536-8fe8-f75d8f041da4
md"A button that sends back the same value every time that it is clicked."

# ╔═╡ 4e8cceec-96c1-40b1-b598-868101875670
@bind click Button("Go!")

# ╔═╡ 7853922e-5fae-4597-bd5a-0c4270208cb8
click

# ╔═╡ a0a0399b-7956-4fa7-8e45-4469a3f84069
begin
	# reference the bound variable - clicking the button will run this cell
	click

	md"My favorite number is $(rand())!"
end

# ╔═╡ cb976f76-adc4-42bf-93cf-44a34dacbc87
md"""
## CounterButton
"""

# ╔═╡ ad99b557-b5ff-488d-880f-398d45b35e30
md"A button that sends back the number of times that it was clicked."

# ╔═╡ 724b779c-0ca0-4ddf-9e55-f931332d0ff2
@bind click_counter CounterButton("Go!")

# ╔═╡ e021ee6a-a9a6-48fd-b8ea-743dba8b7103
click_counter

# ╔═╡ f76acfa7-5fb2-4ff9-b814-11805666b0da
begin
	# reference the bound variable - clicking the button will run this cell
	click_counter

	md"My favorite number is $(rand())!"
end

# ╔═╡ 3eff932a-cc50-11ea-366e-812d3854dd4c


# ╔═╡ 7e10fb52-c765-11ea-2a71-0fc347d09885
md"""
### Button as reactive trigger

In the example above, _any cell that references `clicked` will re-evaluate_ when you click the button. This means that you can use a **Button** or **CounterButton** as a **reactive trigger**, by referencing its value in another cell.
"""

# ╔═╡ aeb6df86-4a51-44b0-b58f-6bfce9543251
@bind go Button("Recompute")

# ╔═╡ 7114241f-929e-41b2-b9b5-329f0122301b
let
	go
	
	md"I am $(rand(1:15)) years old!"
end

# ╔═╡ 9276da28-cc4f-11ea-17b3-65eec41a181e


# ╔═╡ 92def54a-cc4f-11ea-12c5-652f2bb46413
md"## FilePicker"

# ╔═╡ 9920e56c-cc4f-11ea-2d5e-f5371c79f048
@bind important_document FilePicker()

# ╔═╡ 44591b34-cc50-11ea-2005-2f7075e6f2db
important_document

# ╔═╡ 4fda3072-cc50-11ea-2804-197b6391b269
md"The file picker is useful if you want to show off your notebook on a dataset or image **uploaded by the reader**. It will work anywhere - you don't access files using their path.

The caveat is that large files might take a long time to get processed: everything needs to pass through the browser. If you are using large datasets, a better option is to use `Select` to let the reader pick a filename. You can then read the file using `Base.read(filename, type)`"

# ╔═╡ 9f43fa2b-0421-4448-8943-8271689da9a7
@bind image_data FilePicker([MIME("image/jpg"), MIME("image/png")])

# ╔═╡ a6d30c5e-5c3b-4972-9e55-33605c918206
# and use MIME groups:
@bind any_image_data FilePicker([MIME("image/*")])

# ╔═╡ 3bae6061-32e8-4e4d-9959-44cd9f97e73c
md"""
!!! note
	The optional accept argument can be an array of `MIME`s. The user can only select files with these MIME. If only `image/*` MIMEs are allowed, then smartphone browsers will open the camera instead of a file browser.
"""

# ╔═╡ 2989dc42-0206-47a2-9930-7459707a3551
md"""
!!! info
	`MIME`

	A type representing a standard internet data format. *MIME* stands for `Multipurpose Internet Mail Extensions`, since the standard was originally used to describe multimedia attachments to email messages.
"""

# ╔═╡ 3e5dd7d2-c760-11ea-1dca-6d8720b3558d
md"# Extras"

# ╔═╡ f31668c6-c768-11ea-1501-5f41afa7c83b
md"## Clock"

# ╔═╡ 417390ba-c760-11ea-27df-5908858ae88c
@bind t Clock()

# ╔═╡ 49e7cd06-c760-11ea-3f5d-2741d94278a6
t

# ╔═╡ 31a2f3c4-cc51-11ea-3652-bd814517a4b5


# ╔═╡ 67709812-c760-11ea-2bda-9756ead35749
md"You can set the interval (`5.0` seconds), and disable the UI (`true`):"

# ╔═╡ 4c2b45a0-c760-11ea-2b64-3fefc820cd5b
@bind t_slow Clock(5.0, true)

# ╔═╡ 5be148cc-c760-11ea-0819-a7bb403d27ff
t_slow

# ╔═╡ 347e3d06-cc51-11ea-012c-43e824eaffa2


# ╔═╡ 343d7118-cc51-11ea-387a-fb22d8c73506
md"You can use a `Clock` to drive an animation! Or use it to repeat the same command at an interval: just like with `Button`, you can reference a bound (reactive) variable without actually using it!"

# ╔═╡ 32e41ac2-cc51-11ea-3358-bbead9c68123


# ╔═╡ f74f434a-c768-11ea-079c-fb707e6ba17b
md"## DownloadButton"

# ╔═╡ ea00721c-cc4b-11ea-1e82-0b3dbe6a7f1e
md"""
The download button is **not an input** element that you can `@bind` to, it's an **output** that you can use to get processed data from your notebook easily. The second argument is the _output filename_.
"""

# ╔═╡ fc12280c-c768-11ea-3ebc-ebcd6b3459c1
DownloadButton(poem, "poem.txt")

# ╔═╡ 067cbcde-cc4c-11ea-3eed-972dc6d7bb3b
DownloadButton([0x01, 0x02, 0x03], "secret_data.bin")

# ╔═╡ 0334bc3f-45d4-4bb5-bcb4-29ee8b4749d5
import JSON

# ╔═╡ f84c9200-8f26-4ef8-9520-d63dc6f2d439
DownloadButton(JSON.json(Dict("name" => "merlijn", "can_cook" => true)), "staff.json")

# ╔═╡ cc337b24-41d4-46bb-bc63-629e3f4948d7
md"If you want to make a local file available for download, you need to read the file's data:"

# ╔═╡ bed4f5bd-f38b-4b69-9e01-788d08d3716f
let
    filename = "/Users/tannu/Downloads/seed.py"
    DownloadButton(read(filename), basename(filename))
end

# ╔═╡ 7da30d97-b28a-4eb9-a2ef-fad599b549d1
md"""
# High-level inputs
"""

# ╔═╡ 170089cd-f366-4c0a-b58d-fe6e36049db7
md"""
## Confirm

Normally, when you move a [`Slider`](@ref) or type in a [`TextField`](@ref), all intermediate values are sent back to `@bind`. By wrapping an input element in `confirm`, you get a button to manually **control when the value is sent**, intermediate updates are hidden from Pluto.

"""

# ╔═╡ b29215cb-8e7e-4382-822c-cdaa4c473ba1
@bind distance confirm(Slider(1:100))

# ╔═╡ 00f9f608-85bd-4932-b585-39f74dcf53b4
distance

# ╔═╡ 48a9ffbd-cac7-4c4e-85e5-c3d0693e5550
md"""
`confirm` can be wrapper around any input element to create a new one, including inputs from other packages, or inputs that you have made yourself!
"""

# ╔═╡ 5c85ee41-da68-4f5f-b45e-e1de7996747d


# ╔═╡ 8c51343f-cb35-4ff9-9fd8-642ffab57e22
md"""
## Combine

This next high-level component is a bit tricky, but very powerful!

Using `combine`, you can create a single input out of multiple existing ones! In the example below, we **create a new input, `wind_speed_input`**. Notice that the list of wind directions is *dynamic*: if you add a new direction, a 5th slider will appear!

"""

# ╔═╡ 621f2e82-5ab4-4ab9-a0ff-fb1cc1b41295
import PlutoUI: combine

# ╔═╡ a4837897-caae-447a-8db9-7775e7a4d0c8


# ╔═╡ d278189e-6a5b-428a-8c81-ce3d206b042c
function wind_speed_input(directions::Vector)
	
	return combine() do Child
		
		inputs = [
			md""" $(name): $(
				Child(name, Slider(1:100))
			)"""
			
			for name in directions
		]
		
		md"""
		#### Wind speeds
		$(inputs)
		"""
	end
end

# ╔═╡ f5c421cc-dbdb-459a-9bb4-d648507a87d2
@bind speed wind_speed_input(["North", "East", "South", "West"])

# ╔═╡ a4eac824-ba87-473a-b39a-783c4de3f933
speed

# ╔═╡ f9052ed8-84cc-4cca-abb2-9363aafc6040
speed.North

# ╔═╡ 4ca9c749-08ee-467f-af2c-9b2f13199d72
md"""
Use the Live Docs to learn more about `combine` and to see additional examples. 

> 🙋 `combine` is very useful in combination with [HypertextLiteral.jl](https://github.com/MechanicalRabbit/HypertextLiteral.jl), which you can learn using our JavaScript sample notebook. 
"""

# ╔═╡ 58094500-16fe-4a58-85b6-f5cdeb5f29b8
@bind speeds confirm(
	combine() do Child
		@htl("""
		<h3>Wind speeds</h3>
		<ul>
		$([
			@htl("<li>$(name): $(Child(name, Slider(1:100)))")
			for name in ["North", "East", "South", "West"]
		])
		</ul>
		""")
	end
)

# ╔═╡ b314c77a-f542-40e4-a3b7-1dcdf3dba3c8
speeds

# ╔═╡ ad8e9b30-c75d-11ea-1fd0-0b53592135bf
md"""# Loading resources

Notebooks use data from different places. For example, you use [`Base.read`](https://docs.julialang.org/en/v1/base/io-network/#:~:text=read(filename%3A%3AAbstractString%2C%20String)) to access local data (files) inside your Julia code, and [`Downloads.jl`](https://github.com/JuliaLang/Downloads.jl) for remote data (interwebs). 

`PlutoUI` helps you communicate with the person reading the notebook!
- To get **remote media** (URL) inside your **Markdown text**, use `PlutoUI.Resource`.
- To get **local media** (file) inside your **Markdown text**, use `PlutoUI.LocalResource`.

(With _media_, we mean **images**, video and audio.)

> We **strongly recommend** that you use _remote_ media inside Pluto notebooks! 
> 
> If your notebook uses local images, then those images **will not show** when someone else opens your notebook, unless they have the same images on their computer, at the exact same location. _More on this later._

"""

# ╔═╡ 87d088d0-cc54-11ea-02c6-bd673b95b9d3
md"""## Resource

A container for a URL-addressed resource that displays correctly in rich IDEs.

If you just want to show **images inside Markdown**, you can use the built-in syntax (without `PlutoUI`):

```
md"Here is a _dog_: ![](https://fonsp.com/img/doggoSmall.jpg)"
```

`PlutoUI.Resource` has some extra features:
- specify **image dimensions** and spacing
- support for videos
- support for audio"""

# ╔═╡ 6a7e7e54-c75e-11ea-2ea7-ed3da37e9e96
dog_url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Welsh_Springer_Spaniel.jpg/640px-Welsh_Springer_Spaniel.jpg"

# ╔═╡ 3c68b25c-c761-11ea-226a-4f46579a6732
Resource(dog_url, :width => x * x_different)

# ╔═╡ 9ac7921c-c75e-11ea-30f5-c35e6ee370cb
t_rex_url = "https://cdn.pixabay.com/audio/2023/08/26/audio_a6ee15a317.mp3"

# ╔═╡ a8c57442-c75e-11ea-1913-7d82cbd2c69c
flower_url = "https://cdn.pixabay.com/vimeo/173062443/rose-3654.mp4?width=640&hash=a83b1ab31514810e4fecd9cacacb032b2e94508c"

# ╔═╡ cb37b916-c75b-11ea-0c83-6ba759536075
md"""Hello I am a dog $(Resource(dog_url))"""

# ╔═╡ 16ea31fc-c75e-11ea-0f2d-dd790a56b2dc
md"""And I sound like this: $(Resource(t_rex_url))"""

# ╔═╡ 1dfd8cc6-c75e-11ea-3c04-a96734779c97
md"""This is my flower friend

$(Resource(flower_url, :width => 200))"""

# ╔═╡ 2fda30ea-c75e-11ea-2ff5-7f2dcf4f9b66
md"### Attributes

You can pass additional _HTML attributes_ to `Resource`, these will be added to the element. For example:"

# ╔═╡ 525ceea0-c75e-11ea-2766-f72418fd784e
md"""
$(Resource(dog_url, :width => 20))
$(Resource(dog_url, :width => 50))
$(Resource(dog_url, :width => 100))
$(Resource(dog_url, 
	:width => 100, 
	:style => "filter: grayscale(100%); border: 3px solid black;"))
"""

# ╔═╡ 382d41d8-c75e-11ea-2ae3-2ffe96e04b5a
Resource(flower_url, :width => 200, :autoplay => "", :loop => "")

# ╔═╡ da4b167c-b783-4127-948e-bb01df557448
md"""
	To get url of any media visit: chrome -> pixabay.com -> inspect
"""

# ╔═╡ 958ab19c-cc56-11ea-162e-d3664e66ff66
md"### YouTube, Vimeo, etc.

If you use `Resource` for video, the URL has to point to a _video file_ (like `.mp4` or `.mov`). 

Popular video sites don't give you that link, instead, you can use their **embed codes**. You can find these inside the video player, by right clicking or using the menu buttons. You then use that inside an HTML block:
```
html\"\"\"
~ paste embed code here ~
\"\"\"
```

You might need to change the `width` to `100%` to make it fit."

# ╔═╡ 8477619c-cc57-11ea-0618-1778c502d28f
html"""

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/438210156" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

"""

# ╔═╡ f743076c-cc57-11ea-1a8e-8799d9db985a


# ╔═╡ c65d28a2-c75d-11ea-2e13-7332f93d9c5e
md"## LocalResource _(not recommended)_

The examples above use `Resource` to make media from a URL available inside Markdown. To use **local files**, simply **replace `Resource` with `LocalResource`**, and use a _file path_ instead of a URL."

# ╔═╡ c16dff74-cc5d-11ea-380c-aff1639b5551


# ╔═╡ dada2154-c75d-11ea-2312-b9156a9a531e
html"<span style='font-family: cursive; color: purple;'>I really hope that this works</span>"

# ╔═╡ f809110c-cc55-11ea-1551-e138c28d5d82
md"""Hello I am a dog $(LocalResource("C:\\Users\\fons\\Pictures\\hannes.jpg"))"""

# ╔═╡ 1c930364-cc58-11ea-36c8-0ddf7c4700cd
md""" $(html"<span style='font-family: cursive; color: purple;'>OOPS</span>"), it didn't!

$(html"<br>")

Here are **two tips** for getting local images to work correctly:

1. Go to [imgur.com](https://imgur.com) and drag&drop the image to the page. Right click on the image, and select "Copy image location". You can now use the image like so: 

   ```PlutoUI.Resource("https://i.imgur.com/SAzsMMA.jpg")```


2. If your notebook is part of a git repository, place the image in the repository and use a relative path: 
   
    ```PlutoUI.LocalResource("../images/cat.jpg")```


"""

# ╔═╡ c48b48f6-cc5d-11ea-0f3b-d3481238625d


# ╔═╡ ea6ade22-cc5a-11ea-1782-97f2464fd148
md"#### Why does it have to be so difficult?

Pluto only stores _code_ in the notebook file, not images. This minimal file format is very valuable, but it means that images need to be _addressed_, not stored.

Addressing _local files_ is fragile: if someone else opens the notebook, or if you move the notebook to a different folder, that image file needs to be available at exactly the same path. This is difficult to do correctly, and if it works for you, it is hard to tell if it will work for someone else. 

Putting images online might be a hassle, but once it works, it will work everywhere! The stateless nature of URLs means that the images will work regardless of how the notebook file is accessed, while keeping a minimal file format."

# ╔═╡ a245dddc-cc59-11ea-3e1d-1763673ff706
md"# PlutoUI without Pluto

Huh?

Did you know that you can run Pluto notebooks _without Pluto_? If your notebook is called `wow.jl`, then 
```sh
$ julia wow.jl
```
will run the notebook just fine. 

When you use `@bind`, your notebook can still run without Pluto! Sort of. Normally, all bound variables are assigned the value `missing` when you run it elsewhere. However, the `PlutoUI` types have all been configured to assign a more sensible default value.

For example, if your notebook contains
```julia
@bind x Slider(10:20)
```
and you run it without Pluto, then this statement simply assigns `x = 10`.
"

# ╔═╡ 0cda8986-cc64-11ea-2acc-b5c38fdf17e5


# ╔═╡ 0da7bc30-cc64-11ea-1dde-2b7f2dd76036
md"`Pluto` and `PlutoUI` work independently of each other! In fact, _you_ could write a package with fun input elements, or add `@bind`able values to existing packages."

# ╔═╡ 512fe760-cc4c-11ea-1c5b-2b32da035aad
md"# Appendix"

# ╔═╡ 55bcdbf8-cc4c-11ea-1549-87c076a59ff4
space = html"<br><br><br>"

# ╔═╡ fb6142f6-c765-11ea-29fd-7ff4e823c02b
space

# ╔═╡ ebfc61b0-c765-11ea-1d66-cbf1dcdb8bdb
space

# ╔═╡ f69a5d5e-c765-11ea-3fa0-230c6c619730
space

# ╔═╡ 0b66c781-ecf2-445e-b2aa-82cb13371e46
space

# ╔═╡ 35523932-cc4f-11ea-0908-2d51c57176b7
space

# ╔═╡ d163f434-cc5a-11ea-19e9-9319ba994efa
space

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
JSON = "~0.21.4"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "d3f9644a69b37effc8d524142ffb976a95efdba7"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─bc532cd2-c75b-11ea-313f-8b5e771c9227
# ╟─3eff9592-cc63-11ea-2b61-4170d1a7656a
# ╟─051f31fc-cc63-11ea-1e2c-0704285ea6a9
# ╠═071d9ca5-9b42-4583-ad96-a48f93453a0e
# ╟─deadce6b-4abc-42b0-9997-07be8637ee94
# ╟─fb6142f6-c765-11ea-29fd-7ff4e823c02b
# ╟─fddb794c-c75c-11ea-1f55-eb9c178424cd
# ╟─b819e9a8-c760-11ea-11ee-dd01da663b5c
# ╠═34ebf81e-c760-11ea-05bb-376173e7ed10
# ╟─1048d1e0-cc50-11ea-1bf3-d76cae42740a
# ╟─a709fd2e-c760-11ea-05c5-7bf673990de1
# ╠═d3811ac2-c760-11ea-0811-131d9f1d3910
# ╟─06962cde-cc4f-11ea-0d96-69a8cb7eeda2
# ╟─6605d010-d0d1-4cc8-a34d-3158b8572b5d
# ╠═756e2c82-6e2f-4d7b-a1ed-5de97be04269
# ╠═c07c5a9e-61f9-4247-86e7-7c3f9956d0ff
# ╟─c3fea1b2-fc11-4c19-9c01-a8e03fda2817
# ╠═ddedffe8-aa06-414a-b37b-e44002dd30ba
# ╟─ecc04039-2ab1-439b-b8f8-a7c65cdd177c
# ╠═ee29ff92-ba28-48dc-906f-4df8c25272cb
# ╠═6433e2f2-e7db-428c-8988-9be8c27c8b0a
# ╟─221c308e-3cbe-4689-aa67-8970957f8cb0
# ╟─e49623ac-c760-11ea-3689-c15f2e2f6081
# ╠═314cb85a-c761-11ea-1cba-b73f84a52be8
# ╠═3c68b25c-c761-11ea-226a-4f46579a6732
# ╟─104b55ce-cc4f-11ea-1273-092a1717e399
# ╟─4513b730-c761-11ea-1460-2dca56081fcf
# ╠═4f8e4e1e-c761-11ea-1787-419cab59bb12
# ╠═b787ead6-c761-11ea-3b17-41c0a5434f9b
# ╟─177e6bf0-cc50-11ea-0de2-e77544f5c615
# ╟─b08c347e-c761-11ea-1b61-7b69631d078b
# ╠═b53c8ffa-c761-11ea-38d1-2d4ad96a7bee
# ╠═adcf4e68-c761-11ea-00bb-c3b15c6dedc0
# ╟─1a562ad4-cc50-11ea-2485-cdec6e1a78dc
# ╠═5d420570-c764-11ea-396b-cf0db01d34aa
# ╟─09393bf2-cc4f-11ea-1e48-cfbedab8e6b4
# ╟─cd1b5872-c761-11ea-2179-57a3cb34d235
# ╠═d9e85ed0-c761-11ea-30bf-83ce272526e0
# ╠═674523d6-2b86-4d1e-a2e3-3ce8c59c8175
# ╟─0934bc0c-cc50-11ea-0da8-0d6b2f275399
# ╟─e690337c-c761-11ea-08be-ade40a464eb4
# ╠═f1f83980-c761-11ea-1e34-97c0ffca3f67
# ╟─1cbfd28e-cc50-11ea-2c90-a7807e4979ef
# ╟─0136af80-c762-11ea-2f1a-9dccff334a11
# ╠═0e6f0508-c762-11ea-0352-09bd694a9b35
# ╠═3dcd7002-c765-11ea-323d-a1fb49409011
# ╠═f57089fd-b366-45e5-9b50-8a8d2f137891
# ╟─6339e49e-0d31-4e06-ad73-987b122c02bc
# ╟─0aa3c85e-cc4f-11ea-2fba-4bdd513d9217
# ╟─5833f7f4-c763-11ea-0b95-9b21a40192a9
# ╠═690cf3ac-c763-11ea-10f0-b3e28c380be9
# ╠═1feebd8f-667a-42fd-965d-5e3167ff7c7a
# ╠═9128d2c1-364c-4446-baaa-6d0593edda47
# ╟─3930f0d8-cc50-11ea-3de6-d91ac5c6cd9f
# ╠═ac8c4dee-c763-11ea-1b2d-c590a2d50d7e
# ╠═dcda9ad2-c763-11ea-3ec6-093b823ba66d
# ╟─0c3ab1f8-cc4f-11ea-0cfb-8f076d2c9836
# ╟─62c6f866-f0fe-11ea-0961-319f28d040d4
# ╠═a01c8096-f0fe-11ea-3e78-ad8551e84fa1
# ╠═a20e30f2-f0fe-11ea-0ca7-c5195c9eb24a
# ╟─a282d0e2-594d-447c-824d-fb7f85edb483
# ╠═105202a8-4bd0-4a1d-9144-323aac5876da
# ╠═641d76f9-0bfb-4930-8dd7-3db8d35b97b8
# ╟─4e727de4-a795-4f43-a5f8-f3aee870bbb9
# ╟─b104ba6d-0293-4378-9652-f628f1d08d97
# ╠═16f2218d-f1bc-4b34-a355-53acfa77fbf5
# ╠═2c7811cb-d9ea-470c-8cb7-2b3803489f3f
# ╠═90d84f1b-042c-444e-8bac-fe358b6d68a1
# ╠═b97cfb04-0c39-4709-9419-9294e677a872
# ╟─aec9858b-44c1-460b-bbcb-dfefda07a68a
# ╠═40ea94df-ebeb-4b28-9e66-c66b88791f47
# ╠═e1c783c7-d338-49f6-a7ab-b9dee5463beb
# ╟─46e6c836-e070-4a2d-b1db-c4a185c35aa6
# ╟─f9c6f24e-fd00-44f1-b876-e559aeed0aa2
# ╟─0b1ce22e-c764-11ea-3d60-e799d58aee30
# ╟─ff0e137e-d3fb-4536-8fe8-f75d8f041da4
# ╠═4e8cceec-96c1-40b1-b598-868101875670
# ╠═7853922e-5fae-4597-bd5a-0c4270208cb8
# ╠═a0a0399b-7956-4fa7-8e45-4469a3f84069
# ╟─cb976f76-adc4-42bf-93cf-44a34dacbc87
# ╟─ad99b557-b5ff-488d-880f-398d45b35e30
# ╠═724b779c-0ca0-4ddf-9e55-f931332d0ff2
# ╠═e021ee6a-a9a6-48fd-b8ea-743dba8b7103
# ╠═f76acfa7-5fb2-4ff9-b814-11805666b0da
# ╟─3eff932a-cc50-11ea-366e-812d3854dd4c
# ╟─7e10fb52-c765-11ea-2a71-0fc347d09885
# ╠═aeb6df86-4a51-44b0-b58f-6bfce9543251
# ╠═7114241f-929e-41b2-b9b5-329f0122301b
# ╟─9276da28-cc4f-11ea-17b3-65eec41a181e
# ╟─92def54a-cc4f-11ea-12c5-652f2bb46413
# ╠═9920e56c-cc4f-11ea-2d5e-f5371c79f048
# ╠═44591b34-cc50-11ea-2005-2f7075e6f2db
# ╟─4fda3072-cc50-11ea-2804-197b6391b269
# ╠═9f43fa2b-0421-4448-8943-8271689da9a7
# ╠═a6d30c5e-5c3b-4972-9e55-33605c918206
# ╟─3bae6061-32e8-4e4d-9959-44cd9f97e73c
# ╟─2989dc42-0206-47a2-9930-7459707a3551
# ╟─ebfc61b0-c765-11ea-1d66-cbf1dcdb8bdb
# ╟─3e5dd7d2-c760-11ea-1dca-6d8720b3558d
# ╟─f31668c6-c768-11ea-1501-5f41afa7c83b
# ╠═417390ba-c760-11ea-27df-5908858ae88c
# ╠═49e7cd06-c760-11ea-3f5d-2741d94278a6
# ╟─31a2f3c4-cc51-11ea-3652-bd814517a4b5
# ╟─67709812-c760-11ea-2bda-9756ead35749
# ╠═4c2b45a0-c760-11ea-2b64-3fefc820cd5b
# ╠═5be148cc-c760-11ea-0819-a7bb403d27ff
# ╟─347e3d06-cc51-11ea-012c-43e824eaffa2
# ╟─343d7118-cc51-11ea-387a-fb22d8c73506
# ╟─32e41ac2-cc51-11ea-3358-bbead9c68123
# ╟─f74f434a-c768-11ea-079c-fb707e6ba17b
# ╟─ea00721c-cc4b-11ea-1e82-0b3dbe6a7f1e
# ╠═fc12280c-c768-11ea-3ebc-ebcd6b3459c1
# ╠═067cbcde-cc4c-11ea-3eed-972dc6d7bb3b
# ╠═0334bc3f-45d4-4bb5-bcb4-29ee8b4749d5
# ╠═f84c9200-8f26-4ef8-9520-d63dc6f2d439
# ╟─cc337b24-41d4-46bb-bc63-629e3f4948d7
# ╠═bed4f5bd-f38b-4b69-9e01-788d08d3716f
# ╟─f69a5d5e-c765-11ea-3fa0-230c6c619730
# ╟─7da30d97-b28a-4eb9-a2ef-fad599b549d1
# ╟─170089cd-f366-4c0a-b58d-fe6e36049db7
# ╠═b29215cb-8e7e-4382-822c-cdaa4c473ba1
# ╠═00f9f608-85bd-4932-b585-39f74dcf53b4
# ╟─48a9ffbd-cac7-4c4e-85e5-c3d0693e5550
# ╟─5c85ee41-da68-4f5f-b45e-e1de7996747d
# ╟─8c51343f-cb35-4ff9-9fd8-642ffab57e22
# ╠═621f2e82-5ab4-4ab9-a0ff-fb1cc1b41295
# ╟─a4837897-caae-447a-8db9-7775e7a4d0c8
# ╠═f5c421cc-dbdb-459a-9bb4-d648507a87d2
# ╠═a4eac824-ba87-473a-b39a-783c4de3f933
# ╠═f9052ed8-84cc-4cca-abb2-9363aafc6040
# ╠═d278189e-6a5b-428a-8c81-ce3d206b042c
# ╟─4ca9c749-08ee-467f-af2c-9b2f13199d72
# ╠═46beaa3c-57cf-41f6-a1af-9d55aa167b38
# ╠═58094500-16fe-4a58-85b6-f5cdeb5f29b8
# ╠═b314c77a-f542-40e4-a3b7-1dcdf3dba3c8
# ╟─0b66c781-ecf2-445e-b2aa-82cb13371e46
# ╟─ad8e9b30-c75d-11ea-1fd0-0b53592135bf
# ╟─87d088d0-cc54-11ea-02c6-bd673b95b9d3
# ╟─6a7e7e54-c75e-11ea-2ea7-ed3da37e9e96
# ╠═9ac7921c-c75e-11ea-30f5-c35e6ee370cb
# ╟─a8c57442-c75e-11ea-1913-7d82cbd2c69c
# ╠═cb37b916-c75b-11ea-0c83-6ba759536075
# ╠═16ea31fc-c75e-11ea-0f2d-dd790a56b2dc
# ╠═1dfd8cc6-c75e-11ea-3c04-a96734779c97
# ╟─2fda30ea-c75e-11ea-2ff5-7f2dcf4f9b66
# ╠═525ceea0-c75e-11ea-2766-f72418fd784e
# ╠═382d41d8-c75e-11ea-2ae3-2ffe96e04b5a
# ╟─da4b167c-b783-4127-948e-bb01df557448
# ╟─958ab19c-cc56-11ea-162e-d3664e66ff66
# ╠═8477619c-cc57-11ea-0618-1778c502d28f
# ╟─f743076c-cc57-11ea-1a8e-8799d9db985a
# ╟─c65d28a2-c75d-11ea-2e13-7332f93d9c5e
# ╟─c16dff74-cc5d-11ea-380c-aff1639b5551
# ╟─dada2154-c75d-11ea-2312-b9156a9a531e
# ╠═f809110c-cc55-11ea-1551-e138c28d5d82
# ╟─1c930364-cc58-11ea-36c8-0ddf7c4700cd
# ╟─c48b48f6-cc5d-11ea-0f3b-d3481238625d
# ╟─ea6ade22-cc5a-11ea-1782-97f2464fd148
# ╟─35523932-cc4f-11ea-0908-2d51c57176b7
# ╟─a245dddc-cc59-11ea-3e1d-1763673ff706
# ╟─0cda8986-cc64-11ea-2acc-b5c38fdf17e5
# ╟─0da7bc30-cc64-11ea-1dde-2b7f2dd76036
# ╟─d163f434-cc5a-11ea-19e9-9319ba994efa
# ╟─512fe760-cc4c-11ea-1c5b-2b32da035aad
# ╠═55bcdbf8-cc4c-11ea-1549-87c076a59ff4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
