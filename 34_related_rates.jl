### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 77cfaf7c-539b-11ec-024c-15eb56b8fc1f
begin
	using CalculusWithJulia
	using Plots
	using Roots
	using SymPy
end

# ╔═╡ 77cfcca0-539b-11ec-3acb-1730008efd33
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	fig_size=(600, 400)
	
	nothing
end

# ╔═╡ 77d26ff0-539b-11ec-3434-f1fb4242e2c6
using PlutoUI

# ╔═╡ 77d26faa-539b-11ec-2537-8f5948852614
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 77cf63d2-539b-11ec-19a9-2552399c576c
md"""# Related rates
"""

# ╔═╡ 77cf91e0-539b-11ec-3133-e179469bc331
md"""This section uses these add-on packaages:
"""

# ╔═╡ 77cfcd04-539b-11ec-15b6-fd3f8dc26223
md"""Related rates problems involve two (or more) unknown quantities that are related through an equation. As the two variables depend on each other, also so do their rates - change with respect to some variable which is often time, though exactly how remains to be discovered. Hence the name "related rates."
"""

# ╔═╡ 77cfcf0c-539b-11ec-02d9-4db0fefa68c2
md"""## Examples
"""

# ╔═╡ 77cfcf34-539b-11ec-01be-8dfdfd4437bb
md"""The following is a typical "book" problem:
"""

# ╔═╡ 77d0051c-539b-11ec-15fa-4f3f4d940df2
md"""> A screen saver displays the outline of a 3 cm by 2 cm rectangle and then expands the rectangle in such a way that the 2 cm side is expanding at the rate of 4 cm/sec and the proportions of the rectangle never change.  How fast is the area of the rectangle increasing when its dimensions are 12 cm by 8 cm? [Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)

"""

# ╔═╡ 77d085d0-539b-11ec-1a3d-7991c2fbf9b9
let
	### {{{growing_rects}}}
	## Secant line approaches tangent line...
	function growing_rects_graph(n)
	    w = (t) -> 2 + 4t
	    h = (t) -> 3/2 * w(t)
	    t = n - 1
	
	    w_2 = w(t)/2
	    h_2 = h(t)/2
	
	    w_n = w(5)/2
	    h_n = h(5)/2
	
	    plt = plot(w_2 * [-1, -1, 1, 1, -1], h_2 * [-1, 1, 1, -1, -1], xlim=(-17,17), ylim=(-17,17),
	               legend=false, size=fig_size)
	    annotate!(plt, [(-1.5, 1, "Area = $(round(Int, 4*w_2*h_2))")])
	    plt
	
	
	end
	caption = L"""
	
	As $t$ increases, the size of the rectangle grows. The ratio of width to height is fixed. If we know the rate of change in time for the width ($dw/dt$) and the height ($dh/dt$) can we tell the rate of change of *area* with respect to time ($dA/dt$)?
	
	"""
	n=6
	
	anim = @animate for i=1:n
	    growing_rects_graph(i)
	end
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 77d08780-539b-11ec-28d9-298fa970b321
md"""Here we know $A = w \cdot h$ and we know some things about how $w$ and $h$ are related *and* about the rate of how both $w$ and $h$ grow in time $t$. That means that we could express this growth in terms of some functions $w(t)$ and $h(t)$, then we can figure out that the area - as a function of $t$ - will be expressed as:
"""

# ╔═╡ 77d09d42-539b-11ec-11c1-a31821725916
md"""```math
A(t) = w(t) \cdot h(t).
```
"""

# ╔═╡ 77d09dc6-539b-11ec-0bf6-4b25b5e895de
md"""We would get by the product rule that the *rate of change* of area with respect to time, $A'(t)$ is just:
"""

# ╔═╡ 77d09dec-539b-11ec-39d4-613458cd1a59
md"""```math
A'(t) = w'(t) h(t) + w(t) h'(t).
```
"""

# ╔═╡ 77d09eb4-539b-11ec-2ba9-bd106f28c3b1
md"""As an aside, it is fairly conventional to suppress the $(t)$ part of the notation $A=wh$ and to use the Leibniz notation for derivatives:
"""

# ╔═╡ 77d09ed2-539b-11ec-2d31-5f0440ddd6f6
md"""```math
\frac{dA}{dt} = \frac{dw}{dt} h + w \frac{dh}{dt}.
```
"""

# ╔═╡ 77d09f04-539b-11ec-0e28-415df29ba960
md"""This relationship is true for all $t$, but the problem discusses a certain value of $t$ - when $w(t)=8$ and $h(t) = 12$. At this same value of $t$, we have $w'(t) = 4$ and so $h'(t) = 6$. Substituting these 4 values into the 4 unknowns in the formula for $A'(t)$ gives:
"""

# ╔═╡ 77d09f2e-539b-11ec-3f75-01a5a66c8b0e
md"""```math
A'(t) = 4 \cdot 12 + 8 \cdot 6 = 96.
```
"""

# ╔═╡ 77d09f68-539b-11ec-2145-451c57cde49f
md"""Summarizing, from the relationship between $A$, $w$ and $t$, there is a relationship between their rates of growth with respect to $t$, a time variable. Using this and known values, we can compute. In this case,  $A'$ at the specific $t$.
"""

# ╔═╡ 77d09f7c-539b-11ec-258e-bda76eb1e326
md"""We could also have done this differently. We would recognize the following:
"""

# ╔═╡ 77d0a080-539b-11ec-3f15-55b87e92d577
md"""  * The area of a rectangle is just:
"""

# ╔═╡ 77d0a40e-539b-11ec-16f0-51d41df5e415
A(w,h) = w * h

# ╔═╡ 77d0a486-539b-11ec-14aa-15f120921b51
md"""  * The width - expanding at a rate of $4t$ from a starting value of $2$ - must satisfy:
"""

# ╔═╡ 77d0be94-539b-11ec-2ea8-7dad3c087486
w(t) = 2 + 4*t

# ╔═╡ 77d0bf3e-539b-11ec-372b-c967137f1ebb
md"""  * The height is a constant proportion of the width:
"""

# ╔═╡ 77d0c344-539b-11ec-1525-7b1cd944b611
h(t) = 3/2 * w(t)

# ╔═╡ 77d0c39e-539b-11ec-3a5a-d70def6963df
md"""This means again that area depends on $t$ through this formula:
"""

# ╔═╡ 77d0c736-539b-11ec-180e-2b78604ab92d
A(t) = A(w(t), h(t))

# ╔═╡ 77d0c786-539b-11ec-0ee6-83d7ccce1a6e
md"""This is why the rates of change are related: as $w$ and $h$ change in time, the functional relationship with $A$ means $A$ also changes in time.
"""

# ╔═╡ 77d0c7a4-539b-11ec-0368-6ff0395e2f39
md"""Now to answer the question, when the width is 8, we must have that $t$ is:
"""

# ╔═╡ 77d0cde4-539b-11ec-340d-43d87ad19bf8
tstar = find_zero(x -> w(x) - 8, [0, 4])  # or solve by hand to get 3/2

# ╔═╡ 77d0ce32-539b-11ec-3e86-1f9a59ae43e4
md"""The question is to find the rate the area is increasing at the given time $t$, which is $A'(t)$ or $dA/dt$. We get this by performing the differentiation, the substituting in the value.
"""

# ╔═╡ 77d0ce70-539b-11ec-0758-b5998bf7fd42
md"""Here we do so with the aid of `Julia`, though this problem could readily be done "by hand."
"""

# ╔═╡ 77d0cea2-539b-11ec-240c-d54ac050bc7c
md"""We have expressed $A$ as a function of $t$ by composition, so can differentiate that:
"""

# ╔═╡ 77d0d050-539b-11ec-1871-21a04899b26d
A'(tstar)

# ╔═╡ 77d0e716-539b-11ec-1e59-4353ceb74f22
md"""---
"""

# ╔═╡ 77d0e7b6-539b-11ec-1179-4f36efc01379
md"""Now what? Why is 96 of any interest? It is if the value at a specific time is needed. But in general, a better question might be to understand if there is some pattern to the numbers in the figure, these being $6, 54, 150, 294, 486, 726$. Their differences are the *average* rate of change:
"""

# ╔═╡ 77d0ee14-539b-11ec-2915-91e6888de055
begin
	xs = [6, 54, 150, 294, 486, 726]
	ds = diff(xs)
end

# ╔═╡ 77d0ee50-539b-11ec-2b36-677b66ebf04f
md"""Those seem to be increasing by a fixed amount each time, which we can see by one more application of `diff`:
"""

# ╔═╡ 77d0f0bc-539b-11ec-1716-f7fcbaa00330
diff(ds)

# ╔═╡ 77d0f0e4-539b-11ec-2faf-23b5f2484669
md"""How can this relationship be summarized? Well, let's go back to what we know, though this time using symbolic math:
"""

# ╔═╡ 77d10a3e-539b-11ec-16c5-f5c22fa8c2d3
begin
	@syms t
	diff(A(t), t)
end

# ╔═╡ 77d10ad4-539b-11ec-1ae5-f74ca780671b
md"""This should be clear: the rate of change, $dA/dt$, is increasing linearly, hence the second derivative, $dA^2/dt^2$ would be constant, just as we saw for the average rate of change.
"""

# ╔═╡ 77d10af2-539b-11ec-39ca-ed2e92a3e358
md"""So, for this problem, a constant rate of change in width and height leads to a linear rate of change in area, put otherwise, linear growth in both width and height leads to quadratic growth in area.
"""

# ╔═╡ 77d120dc-539b-11ec-07cf-1929a61334b8
md"""##### Example
"""

# ╔═╡ 77d1215e-539b-11ec-2565-7d44865c35bb
md"""A ladder, with length $l$, is leaning against a wall. We parameterize this problem so that the top of the ladder is at $(0,h)$ and the bottom at $(b, 0)$. Then $l^2 = h^2 + b^2$ is a constant.
"""

# ╔═╡ 77d12186-539b-11ec-27a0-3bd404409313
md"""If the ladder starts to slip away at the base, but remains in contact with the wall, express the rate of change of $h$ with respect to $t$ in terms of $db/dt$.
"""

# ╔═╡ 77d121ae-539b-11ec-1bfb-498862596b3d
md"""We have from implicitly differentiating in $t$ the equation $l^2 = h^2 + b^2$,  noting that $l$ is a constant, that:
"""

# ╔═╡ 77d121e0-539b-11ec-3191-65d7daf2e488
md"""```math
0 = 2h \frac{dh}{dt} + 2b \frac{db}{dt}.
```
"""

# ╔═╡ 77d121f4-539b-11ec-3eac-05f60b9405a8
md"""Solving, yields:
"""

# ╔═╡ 77d1221c-539b-11ec-3626-ed310416a21b
md"""```math
\frac{dh}{dt} = -\frac{b}{h} \cdot \frac{db}{dt}.
```
"""

# ╔═╡ 77d1229e-539b-11ec-3b23-f541f5d55bf4
md"""  * If $l = 12$ and $db/dt = 2$ when $b=4$, find $dh/dt$.
"""

# ╔═╡ 77d122dc-539b-11ec-2871-df8623565b57
md"""We just need to find $h$ for this value of $b$, as the other two quantities in the last equation are known.
"""

# ╔═╡ 77d122f8-539b-11ec-0a19-e596c3b82d4e
md"""But $h = \sqrt{l^2 - b^2}$, so the answer is:
"""

# ╔═╡ 77d144fe-539b-11ec-1ee9-8f6908c6a06e
begin
	length, bottom, dbdt = 12, 4, 2
	height = sqrt(length^2 - bottom^2)
	-bottom/height * dbdt
end

# ╔═╡ 77d1458a-539b-11ec-0657-830ba49fa530
md"""  * What happens to the rate as $b$ goes to $l$?
"""

# ╔═╡ 77d145da-539b-11ec-084a-058e276af32a
md"""As $b$ goes to $l$, $h$ goes to $0$, so $b/h$ blows up. Unless $db/dt$ goes to $0$, the expression will become $-\infty$.
"""

# ╔═╡ 77d1460c-539b-11ec-0edc-d727b97c0456
md"""##### Example
"""

# ╔═╡ 77d1468e-539b-11ec-1cef-83fd6bc4bf67
md"""![A man and woman walk towards the light](https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/derivatives/figures/long-shadow-noir.png)
"""

# ╔═╡ 77d146b6-539b-11ec-2c90-69300bcdc131
md"""Shadows are a staple of film noir. In the photo, suppose a man and a woman walk towards a street light. As they approach the light the length of their shadow changes.
"""

# ╔═╡ 77d146de-539b-11ec-22f7-49767d5a1d8f
md"""Suppose, we focus on the $5$ foot tall woman. Her shadow comes from a streetlight $15$ feet high. She is walking at $3$ feet per second towards the light. What is the rate of change of her shadow?
"""

# ╔═╡ 77d14710-539b-11ec-1bbd-5324d6f89c79
md"""The setup for this problem involves drawing a right triangle with height $12$ and base given by the distance $x$ from the light the woman is *plus* the length $l$ of the shadow. There is a similar triangle formed by the woman's height with length $l$. Equating the ratios of the sided gives:
"""

# ╔═╡ 77d14736-539b-11ec-348d-b32408e361dc
md"""```math
\frac{5}{l} = \frac{12}{x + l}
```
"""

# ╔═╡ 77d1474c-539b-11ec-0fb2-e993d2d82b86
md"""As we need to take derivatives, we work with the reciprocal relationship:
"""

# ╔═╡ 77d14760-539b-11ec-3231-afd914745dd1
md"""```math
\frac{l}{5} = \frac{x + l}{12}
```
"""

# ╔═╡ 77d14792-539b-11ec-0fbb-9949eaf8ca38
md"""Differentiating in $t$ gives:
"""

# ╔═╡ 77d147a8-539b-11ec-0dd7-a56b28e8f5ba
md"""```math
\frac{l'}{5} = \frac{x' + l'}{12}
```
"""

# ╔═╡ 77d147b0-539b-11ec-092a-35d1c7a8253d
md"""Or
"""

# ╔═╡ 77d147ba-539b-11ec-2277-3157e2ef1138
md"""```math
l' \cdot (\frac{1}{5} - \frac{1}{12}) =  \frac{x'}{12}
```
"""

# ╔═╡ 77d147ec-539b-11ec-217b-2536633caecb
md"""Solving for $l'$ gives an answer in terms of $x'$ the rate the woman is walking. In this description $x$ is getting shorter, so $x'$ would be $-3$ feet per second and the shadow length would be decreasing at a rate proportional to the walking speed.
"""

# ╔═╡ 77d147f6-539b-11ec-0166-df6213d0ac8e
md"""##### Example
"""

# ╔═╡ 77d14dac-539b-11ec-1c2d-f13b85acef0a
let
	###{{{baseball_been_berry_good}}}
	## Secant line approaches tangent line...
	pyplot()
	function baseball_been_berry_good_graph(n)
	
	    v0 = 15
	    x = (t) -> 50t
	    y = (t) -> v0*t - 5 * t^2
	
	
	    ns = range(.25, stop=3, length=8)
	
	    t = ns[n]
	    ts = range(0, stop=t, length=50)
	    xs = map(x, ts)
	    ys = map(y, ts)
	
	    degrees = atand(y(t)/(100-x(t)))
	    degrees = degrees < 0 ? 180 + degrees : degrees
	
	    plt = plot(xs, ys, legend=false, size=fig_size, xlim=(0,150), ylim=(0,15))
	    plot!(plt, [x(t), 100], [y(t), 0.0], color=:orange)
	    annotate!(plt, [(55, 4,"θ = $(round(Int, degrees)) degrees"),
	                    (x(t), y(t), "($(round(Int, x(t))), $(round(Int, y(t))))")])
	
	end
	caption = L"""
	
	The flight of the ball as being tracked by a stationary outfielder.  This ball will go over the head of the player. What can the player tell from the quantity $d\theta/dt$?
	
	"""
	n = 8
	
	
	anim = @animate for i=1:n
	    baseball_been_berry_good_graph(i)
	end
	
	
	imgfile = tempname() * ".gif"
	gif(anim, imgfile, fps = 1)
	
	ImageFile(imgfile, caption)
end

# ╔═╡ 77d14dda-539b-11ec-14b0-07e58aecdacd
md"""A baseball player stands $100$ meters from home base. A batter hits the ball directly at the player so that the distance from home plate is $x(t)$ and the height is $y(t)$.
"""

# ╔═╡ 77d14e04-539b-11ec-0651-ad8fb82f3936
md"""The player tracks the flight of the ball in terms of the angle $\theta$ made between the ball and the player. This will satisfy:
"""

# ╔═╡ 77d14e22-539b-11ec-3967-edc29f204355
md"""```math
\tan(\theta) = \frac{y(t)}{100 - x(t)}.
```
"""

# ╔═╡ 77d14e5e-539b-11ec-3756-f36f15eb2286
md"""What is the rate of change of $\theta$ with respect to $t$ in terms of that of $x$ and $y$?
"""

# ╔═╡ 77d14e7c-539b-11ec-2519-73c461ade761
md"""We have by the chain rule and quotient rule:
"""

# ╔═╡ 77d14ea4-539b-11ec-180c-b71e86f66074
md"""```math
\sec^2(\theta) \theta'(t) = \frac{y'(t) \cdot (100 - x(t)) - y(t) \cdot (-x'(t))}{(100 - x(t))^2}.
```
"""

# ╔═╡ 77d14ec2-539b-11ec-30bd-555659755539
md"""If we have $x(t) = 50t$ and $y(t)=v_{0y} t - 5 t^2$ when is the rate of change of the angle happening most quickly?
"""

# ╔═╡ 77d14ee2-539b-11ec-12e5-7f8563cc8227
md"""The formula for $\theta'(t)$ is
"""

# ╔═╡ 77d14ef4-539b-11ec-0a03-8fecd997a14a
md"""```math
\theta'(t) = \cos^2(\theta) \cdot \frac{y'(t) \cdot (100 - x(t)) - y(t) \cdot (-x'(t))}{(100 - x(t))^2}.
```
"""

# ╔═╡ 77d1655e-539b-11ec-3f52-bb4bdbb22332
md"""This question requires us to differentiate *again* in $t$. Since we have fairly explicit function for $x$ and $y$, we will use `SymPy` to do this.
"""

# ╔═╡ 77d169ca-539b-11ec-094f-95e858c9aa5a
begin
	@syms theta()
	
	v0 = 5
	x(t) = 50t
	y(t) = v0*t - 5 * t^2
	eqn = tan(theta(t)) - y(t) / (100 - x(t))
end

# ╔═╡ 77d16f1a-539b-11ec-23f7-bdb936843857
begin
	thetap = diff(theta(t),t)
	dtheta = solve(diff(eqn, t), thetap)[1]
end

# ╔═╡ 77d16f38-539b-11ec-153a-730fabc4df71
md"""We could proceed directly by evaluating:
"""

# ╔═╡ 77d17472-539b-11ec-075b-190e0c941aad
d2theta = diff(dtheta, t)(thetap => dtheta)

# ╔═╡ 77d17492-539b-11ec-1312-d569dc975ba1
md"""That is not so tractable, however.
"""

# ╔═╡ 77d174e2-539b-11ec-145c-2961eb93da81
md"""It helps to simplify $\cos^2(\theta(t))$ using basic right-triangle trigonometry. Recall, $\theta$ comes from a right triangle with height $y(t)$ and length $(100 - x(t))$. The cosine of this angle will be $100 - x(t)$ divided by the length of the hypotenuse. So we can substitute:
"""

# ╔═╡ 77d1b2ae-539b-11ec-230a-b10d875e2ec0
dtheta₁ = dtheta(cos(theta(t))^2 => (100 -x(t))^2/(y(t)^2 + (100-x(t))^2))

# ╔═╡ 77d1b300-539b-11ec-3ecf-bf056bdd7ad4
md"""Plotting reveals some interesting things. For $v_{0y} < 10$ we have graphs that look like:
"""

# ╔═╡ 77d1b68c-539b-11ec-0108-a5bd096df6d7
plot(dtheta₁, 0, v0/5)

# ╔═╡ 77d1b6d4-539b-11ec-04c5-31c1caffb937
md"""The ball will drop in front of the player, and the change in $d\theta/dt$ is monotonic.
"""

# ╔═╡ 77d1b6e6-539b-11ec-0727-130136105cc6
md"""But let's rerun the code with $v_{0y} > 10$:
"""

# ╔═╡ 77d1ba68-539b-11ec-3caa-1d9f65b5374d
let
	v0 = 15
	x(t) = 50t
	y(t) = v0*t - 5 * t^2
	eqn = tan(theta(t)) - y(t) / (100 - x(t))
	thetap = diff(theta(t),t)
	dtheta = solve(diff(eqn, t), thetap)[1]
	dtheta₁ = subs(dtheta, cos(theta(t))^2, (100 - x(t))^2/(y(t)^2 + (100 - x(t))^2))
	plot(dtheta₁, 0, v0/5)
end

# ╔═╡ 77d1bac4-539b-11ec-0a06-d140218bf87a
md"""In the second case we have a different shape. The graph is not monotonic, and before the peak there is an inflection point.  Without thinking too hard, we can see that the greatest change in the angle is when it is just above the head ($t=2$ has $x(t)=100$).
"""

# ╔═╡ 77d1bae2-539b-11ec-1f43-11ac0c910985
md"""That these two graphs differ so, means that the player may be able to read if the ball is going to go over his or her head by paying attention to the how the ball is being tracked.
"""

# ╔═╡ 77d1bb00-539b-11ec-0636-b1ad62e9eca1
md"""##### Example
"""

# ╔═╡ 77d1bb6c-539b-11ec-2a24-f73aaee7de9b
md"""Hipster pour-over coffee is made with a conical coffee filter. The cone is actually a [frustum](http://en.wikipedia.org/wiki/Frustum) of a cone with small diameter, say $r_0$ chopped off. We will parameterize our cone by a value $h \geq 0$ on the $y$ axis and an angle $\theta$ formed by a side and the $y$ axis. Then the coffee filter is the part of the cone between some $h_0$ (related  $r_0=h_0 \tan(\theta)$) and $h$.
"""

# ╔═╡ 77d1bbaa-539b-11ec-2c62-87a6df6f2506
md"""The volume of a cone of height $h$ is $V(h) = \pi/3 h \cdot R^2$. From the geometry, $R = h\tan(\theta)$. The volume of the filter then is:
"""

# ╔═╡ 77d1bbbe-539b-11ec-03d8-c5d681b77920
md"""```math
V = V(h) - V(h_0).
```
"""

# ╔═╡ 77d1bbe6-539b-11ec-0c8d-b1708058c1c2
md"""What is $dV/dh$ in terms of $dR/dh$?
"""

# ╔═╡ 77d1bbfa-539b-11ec-0633-eb8533663f31
md"""Differentiating implicitly gives:
"""

# ╔═╡ 77d1bc0e-539b-11ec-37a7-5b1eb2321a21
md"""```math
\frac{dV}{dh} = \frac{\pi}{3} ( R(h)^2 + h \cdot 2 R \frac{dR}{dh}).
```
"""

# ╔═╡ 77d1bc36-539b-11ec-06a8-a1c888792cb5
md"""We see that it depends on $R$ and the change in $R$ with respect to $h$. However, we visualize $h$ - the height - so it is better to re-express. Clearly, $dR/dh = \tan\theta$ and using $R(h) = h \tan(\theta)$ we get:
"""

# ╔═╡ 77d1bc42-539b-11ec-054d-69f34fdbc616
md"""```math
\frac{dV}{dh} = \pi h^2 \tan^2(\theta).
```
"""

# ╔═╡ 77d1bc74-539b-11ec-180d-2f713fd3e6fd
md"""The rate of change goes down as $h$ gets smaller ($h \geq h_0$) and gets bigger for bigger $\theta$.
"""

# ╔═╡ 77d1bc7c-539b-11ec-38a2-21fec6de3201
md"""How do the quantities vary in time?
"""

# ╔═╡ 77d1bca6-539b-11ec-0b3d-8d9feec3f55a
md"""For an incompressible fluid, by balancing the volume leaving with how it leaves we will have $dh/dt$ is the ratio of the cross-sectional area at bottom over that at the height of the fluid $(\pi \cdot (h_0\tan(\theta))^2) / (\pi \cdot ((h\tan\theta))^2)$ times the outward velocity of the fluid.
"""

# ╔═╡ 77d1bcd4-539b-11ec-27d7-49abf10b911b
md"""That is $dh/dt = (h_0/h)^2 \cdot v$. Which makes sense - larger openings ($h_0$) mean more fluid lost per unit time so the height change follows, higher levels ($h$) means the change in height is slower, as the cross-sections have more volume.
"""

# ╔═╡ 77d1bd30-539b-11ec-316e-d9b022693467
md"""By [Torricelli's](http://en.wikipedia.org/wiki/Torricelli's_law) law, the out velocity follows the law $v = \sqrt{2g(h-h_0)}$. This gives:
"""

# ╔═╡ 77d1bd44-539b-11ec-2d57-5bcffea3408f
md"""```math
\frac{dh}{dt} = \frac{h_0^2}{h^2} \cdot v = \frac{h_0^2}{h^2} \sqrt{2g(h-h_0)}.
```
"""

# ╔═╡ 77d1bd62-539b-11ec-35a9-3d66b0ccd749
md"""If $h >> h_0$, then $\sqrt{h-h_0} = \sqrt{h}\sqrt(1 - h_0/h) \approx \sqrt{h}(1 - (1/2)(h_0/h)) \approx \sqrt{h}$. So the rate of change of height in time is like $1/h^{3/2}$.
"""

# ╔═╡ 77d1bd80-539b-11ec-2e28-edfd2cd935ef
md"""Now, by the chain rule, we have then the rate of change of volume with respect to time, $dV/dt$, is:
"""

# ╔═╡ 77d1bdbc-539b-11ec-1032-e5243e8fd60a
md"""```math
\begin{align*}
\frac{dV}{dt} &=
\frac{dV}{dh} \cdot \frac{dh}{dt}\\
&= \pi h^2 \tan^2(\theta) \cdot \frac{h_0^2}{h^2} \sqrt{2g(h-h_0)}  \\
&= \pi \sqrt{2g} \cdot (r_0)^2 \cdot \sqrt{h-h_0} \\
&\approx \pi \sqrt{2g} \cdot r_0^2 \cdot \sqrt{h}.
\end{align*}
```
"""

# ╔═╡ 77d1bddc-539b-11ec-2bb8-4f18ec04b217
md"""This rate depends on the square of the size of the opening ($r_0^2$) and the square root of the height ($h$), but not the angle of the cone.
"""

# ╔═╡ 77d1bdf8-539b-11ec-2a07-f1242bbdc3b5
md"""##### Example
"""

# ╔═╡ 77d1be20-539b-11ec-2654-bf6624741e1f
md"""A batter hits a ball toward third base at $75$ ft/sec and runs toward first base at a rate of $24$ ft/sec. At what rate does the distance between the ball and the batter change when $2$ seconds have passed?
"""

# ╔═╡ 77d1be5c-539b-11ec-3cf1-e9f3cec3220e
md"""We will answer this with `SymPy`. First we create some symbols for the movement of the ball towardsthird base, `b(t)`, the runner toward first base, `r(t)`, and the two velocities. We use symbolic functions for the movements, as we will be differentiating them in time:
"""

# ╔═╡ 77d1c49c-539b-11ec-1e13-8f538c68ef95
begin
	@syms b() r() v_b v_r
	d = sqrt(b(t)^2 + r(t)^2)
end

# ╔═╡ 77d1c4c4-539b-11ec-1d7c-f99204b7bf45
md"""The distance formula applies to give $d$. As the ball and runner are moving in a perpendicular direction, the formula is easy to apply.
"""

# ╔═╡ 77d1c50a-539b-11ec-38dd-af4ead25aff5
md"""We can differentiate `d` in terms of `t` and in process we also find the derivatives of `b` and `r`:
"""

# ╔═╡ 77d1cc12-539b-11ec-3f95-178f9ab08753
begin
	db, dr = diff(b(t),t), diff(r(t),t) # b(t), r(t) -- symbolic functions
	dd = diff(d,t)                      # d -- not d(t) -- an expression
end

# ╔═╡ 77d1cc62-539b-11ec-1ac9-97a61f987332
md"""The slight difference in the commands is due to `b` and `r` being symbolic functions, whereas `d` is a symbolic expression. Now we begin substituting. First, from the problem `db` is just the velocity in the ball's direction, or `v_b`. Similarly for `v_r`:
"""

# ╔═╡ 77d1ebaa-539b-11ec-1f31-dd4c2af0d59b
ddt = subs(dd, db => v_b, dr => v_r)

# ╔═╡ 77d1ebe8-539b-11ec-0bd4-3d0e1f94b5ed
md"""Now, we can substitute in for `b(t)`, as it is `v_b*t`, etc.:
"""

# ╔═╡ 77d1f200-539b-11ec-35ff-bb65c354329b
ddt₁ = subs(ddt, b(t) => v_b * t, r(t) => v_r * t)

# ╔═╡ 77d1f246-539b-11ec-2905-d5d50eb13889
md"""This finds the rate of change of time for any `t` with symbolic values of the velocities. (And shows how the answer doesn't actually depend on $t$.) The problem's answer comes from a last substitution:
"""

# ╔═╡ 77d1f796-539b-11ec-346a-f1934523295e
ddt₁(t => 2, v_b => 75, v_r => 24)

# ╔═╡ 77d1f7c8-539b-11ec-31f8-631c5c2dc003
md"""Were this done by "hand," it would be better to work with distance squared to avoid the expansion of complexity from the square root. That is, using implicit differentiation:
"""

# ╔═╡ 77d1f7dc-539b-11ec-05d5-efa59d584f03
md"""```math
\begin{align*}
d^2 &= b^2 + r^2\\
2d\cdot d' &= 2b\cdot b' + 2r\cdot r'\\
d' &= (b\cdot b' + r \cdot r')/d\\
d' &= (tb'\cdot b' + tr' \cdot r')/d\\
d' &= \left((b')^2 + (r')^2\right) \cdot \frac{t}{d}.
\end{align*}
```
"""

# ╔═╡ 77d1f820-539b-11ec-18e9-ddd6c4499899
md"""## Questions
"""

# ╔═╡ 77d1f8a4-539b-11ec-3faf-29b51f2443d6
md"""###### Question
"""

# ╔═╡ 77d1f930-539b-11ec-2865-a7fe908db2a6
md"""Supply and demand. Suppose demand for product $XYZ$ is $d(x)$ and supply is $s(x)$. The excess demand is $d(x) - s(x)$. Suppose this is positive. How does this influence price? Guess the "law" of economics that applies:
"""

# ╔═╡ 77d2009c-539b-11ec-2e79-7baff9f508d7
let
	choices = [
	"The rate of change of price will be ``0``",
	"The rate of change of price will increase",
	"The rate of change of price will be positive and will depend on the rate of change of excess demand."
	]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 77d200c4-539b-11ec-0b22-c7531893d0fc
md"""(Theoretically, when demand exceeds supply, prices increase.)
"""

# ╔═╡ 77d200d8-539b-11ec-2d95-17ed21a87d53
md"""###### Question
"""

# ╔═╡ 77d200ec-539b-11ec-3a36-4b48ceb4d153
md"""Which makes more sense from an economic viewpoint?
"""

# ╔═╡ 77d20790-539b-11ec-2a58-5d0880b059b8
let
	choices = [
	"If the rate of change of unemployment is negative, the rate of change of wages will be negative.",
	"If the rate of change of unemployment is negative, the rate of change of wages will be positive."
	]
	ans = 2
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 77d207ae-539b-11ec-261d-d79c6455c788
md"""(Colloquially, "the rate of change of unemployment is negative" means the unemployment rate is going down, so there are fewer workers available to fill new jobs.)
"""

# ╔═╡ 77d207e0-539b-11ec-0bef-5bd065074a23
md"""###### Question
"""

# ╔═╡ 77d2088a-539b-11ec-1f74-c5e4b66d84ae
md"""In chemistry there is a fundamental relationship between pressure ($P$), temperature ($T)$ and volume ($V$) given by $PV=cT$ where $c$ is a constant. Which of the following would be true with respect to time?
"""

# ╔═╡ 77d229be-539b-11ec-0fea-c1cb30784fab
let
	choices = [
	L"The rate of change of pressure is always increasing by $c$",
	"If volume is constant, the rate of change of pressure is proportional to the temperature",
	"If volume is constant, the rate of change of pressure is proportional to the rate of change of temperature",
	"If pressure is held constant, the rate of change of pressure is proportional to the rate of change of temperature"]
	ans = 3
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 77d22a0e-539b-11ec-3518-b9bc2ea5c132
md"""###### Question
"""

# ╔═╡ 77d22a5e-539b-11ec-0096-2d17b6777cd3
md"""A pebble is thrown into a lake causing ripples to form expanding circles. Suppose one of the circles expands at a rate of $1$ foot per second and the radius of the circle is $10$ feet, what is the rate of change of the area enclosed by the circle?
"""

# ╔═╡ 77d24590-539b-11ec-09f4-5d1008e6562c
let
	# a = pi*r^2
	# da/dt = pi * 2r * drdt
	r = 10; drdt = 1
	val = pi * 2r * drdt
	numericq(val, units=L"feet$^2$/second")
end

# ╔═╡ 77d245ca-539b-11ec-0eac-5ba648b708a4
md"""###### Question
"""

# ╔═╡ 77d24606-539b-11ec-29a0-0174dab97cdf
md"""A pizza maker tosses some dough in the air. The dough is formed in a circle with radius $10$. As it rotates, its area increases at a rate of $1$ inch$^2$ per second. What is the rate of change of the radius?
"""

# ╔═╡ 77d24c32-539b-11ec-098f-436e154bbb30
let
	# a = pi*r^2
	# da/dt = pi * 2r * drdt
	r = 10; dadt = 1
	val =  dadt /( pi * 2r)
	numericq(val, units="inches/second")
end

# ╔═╡ 77d24c50-539b-11ec-2612-0362367160d9
md"""###### Question
"""

# ╔═╡ 77d24ca0-539b-11ec-14cd-d9c10eab7801
md"""An FBI agent with a powerful spyglass is located in a boat anchored 400 meters offshore.  A gangster under surveillance is driving along the shore. Assume the shoreline is straight and that the gangster is 1 km from the point on the shore nearest to the boat.  If the spyglasses must rotate at a rate of $\pi/4$ radians per minute to track the gangster, how fast is the gangster moving? (In kilometers per minute.) [Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)
"""

# ╔═╡ 77d2515a-539b-11ec-2eef-a790be1a8f1a
let
	## tan(theta) = x/y
	## sec^2(theta) dtheta/dt = 1/y dx/dt (y is constant)
	## dxdt = y sec^2(theta) dtheta/dt
	dthetadt = pi/4
	y0 = .4; x0 = 1.0
	theta = atan(x0/y0)
	val = y0 * sec(theta)^2 * dthetadt
	numericq(val, units="kilometers/minute")
end

# ╔═╡ 77d2518c-539b-11ec-378e-8512dd434d2d
md"""###### Question
"""

# ╔═╡ 77d251be-539b-11ec-1949-a9844daeadc2
md"""A flood lamp is installed on the ground 200 feet from a vertical wall. A six foot tall man is walking towards the wall at the rate of 4 feet per second. How fast is the tip of his shadow moving down the wall when he is 50 feet from the wall? [Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html) (As the question is written the answer should be positive.)
"""

# ╔═╡ 77d255f6-539b-11ec-06a3-91350c62f991
let
	## y/200 = 6/x
	## dydt = 200 * 6 * -1/x^2 dxdt
	x0 = 200 - 50
	dxdt = 4
	val = 200 * 6 * (1/x0^2) * dxdt
	numericq(val, units="feet/second")
end

# ╔═╡ 77d25614-539b-11ec-3bc2-e1f451f3c244
md"""###### Question
"""

# ╔═╡ 77d256c8-539b-11ec-2f68-2597f70c0f1c
md"""Consider the hyperbola $y = 1/x$ and think of it as a slide. A particle slides along the hyperbola so that its x-coordinate is increasing at a rate of $f(x)$ units/sec. If its $y$-coordinate is decreasing at a constant rate of $1$ unit/sec, what is $f(x)$? [Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)
"""

# ╔═╡ 77d25d26-539b-11ec-224d-99099b3fe9ee
let
	choices = [
	"``f(x) = 1/x``",
	"``f(x) = x^0``",
	"``f(x) = x``",
	"``f(x) = x^2``"
	]
	ans = 4
	radioq(choices, ans, keep_order=true)
end

# ╔═╡ 77d25d42-539b-11ec-3b4f-7f8da5e168ec
md"""###### Question
"""

# ╔═╡ 77d25d94-539b-11ec-3c6c-c96aba8265a0
md"""A balloon is in the shape of a sphere, fortunately, as this gives a known formula, $V=4/3 \pi r^3$, for the volume. If the balloon is being filled with a rate of change of volume per unit time is $2$ and the radius is $3$, what is rate of change of radius per unit time?
"""

# ╔═╡ 77d26208-539b-11ec-2451-6d2962667c20
let
	r, dVdt = 3, 2
	drdt = dVdt / (4 * pi * r^2)
	numericq(drdt, units="units per unit time")
end

# ╔═╡ 77d26226-539b-11ec-3422-f7a2ff27d088
md"""###### Question
"""

# ╔═╡ 77d26250-539b-11ec-2d06-b96ceaef4eac
md"""Consider the curve $f(x) = x^2 - \log(x)$. For a given $x$, the tangent line intersects the $y$ axis. Where?
"""

# ╔═╡ 77d268f2-539b-11ec-0a09-95abd48ba14e
let
	choices = [
	"``y = 1 - x^2 - \\log(x)``",
	"``y = 1 - x^2``",
	"``y = 1 - \\log(x)``",
	"``y = x(2x - 1/x)``"
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 77d26942-539b-11ec-3a6c-5b859d1ac288
md"""If $dx/dt = -1$, what is $dy/dt$?
"""

# ╔═╡ 77d26f64-539b-11ec-2610-51515d86b001
let
	choices = [
	"``dy/dt = 2x + 1/x``",
	"``dy/dt = 1 - x^2 - \\log(x)``",
	"``dy/dt = -2x - 1/x``",
	"``dy/dt = 1``"
	]
	ans=1
	radioq(choices, ans)
end

# ╔═╡ 77d26fd2-539b-11ec-0660-2b20b4997cd2
HTML("""<div class="markdown"><blockquote>
<p><a href="../derivatives/implicit_differentiation.html">◅ previous</a>  <a href="../derivatives/taylor_series_polynomials.html">▻  next</a>  <a href="../misc/toc.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/derivatives/related_rates.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 77d26ff0-539b-11ec-0ac8-b7af2114c109
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.10"
Plots = "~1.24.3"
PlutoUI = "~0.7.21"
PyPlot = "~2.10.0"
Roots = "~1.3.11"
SymPy = "~1.1.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f2202b55d816427cd385a9a4f3ffb226bee80f99"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+0"

[[CalculusWithJulia]]
deps = ["Base64", "ColorTypes", "Contour", "DataFrames", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Pluto", "Random", "RecipesBase", "Reexport", "Requires", "SpecialFunctions", "Tectonic", "Test", "Weave"]
git-tree-sha1 = "7adfe1a4e3f52fc356dfa2b0b26457f0acf81aa2"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.10"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "32a2b8af383f11cbb65803883837a149d10dfe8a"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.10.12"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "b0dcafb34cfff977df79fc9927b70a9157a702ad"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.17.0"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

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

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "d8f468c5cd4d94e86816603f7d18ece910b4aaf1"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.5.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "6406b5112809c08b1baa5703ad274e1dded0652f"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.23"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "2cc2791b324e8ed387a91d7226d17be754e9de61"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.4.3"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "30f2b340c2fff8410d89bfcdc9c0a6dd661ac5f7"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.62.1"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fd75fa3a2080109a2c0ec9864a6e14c60cca3866"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.62.0+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "58bcdf5ebc057b085e58d95c138725628dd7453c"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.1"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "74ef6288d071f58033d54fd6708d4bc23a8b8972"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+1"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HCubature]]
deps = ["Combinatorics", "DataStructures", "LinearAlgebra", "QuadGK", "StaticArrays"]
git-tree-sha1 = "134af3b940d1ca25b19bc9740948157cee7ff8fa"
uuid = "19dc6840-f33b-545b-b366-655c7e3ffd49"
version = "1.5.0"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Highlights]]
deps = ["DocStringExtensions", "InteractiveUtils", "REPL"]
git-tree-sha1 = "f823a2d04fb233d52812c8024a6d46d9581904a4"
uuid = "eafb193a-b7ab-5a9e-9068-77385905fa72"
version = "0.4.5"

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

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

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

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a8f4f279b6fa3c3c4f1adadd78a621b13a506bce"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.9"

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

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7937eda4681660b4d6aeeecc2f7e1c81c8ee4e2f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "b084324b4af5a438cd63619fd006614b3b20b87b"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.15"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun"]
git-tree-sha1 = "d73736030a094e8d24fdf3629ae980217bf1d59d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.24.3"

[[Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "Sockets", "TableIOInterface", "Tables", "UUIDs"]
git-tree-sha1 = "a5b3fee95de0c0a324bab53a03911395936d15d9"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.17.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "db3a23166af8aebf4db5ef87ac5b00d36eb771e2"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.0"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

[[QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "7ad0dfa8d03b7bcf8c597f59f5292801730c55b8"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.4.1"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "51ee572776905ee34c0568f5efe035d44bf59f74"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.11"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "def0718ddbabeb5476e51e5a43609bee889f285d"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.0"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

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
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "2ce41e0d042c60ecd131e9fb7154a3bfadbf50d3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.3"

[[SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "8f8d948ed59ae681551d184b93a256d0d5dd4eae"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableIOInterface]]
git-tree-sha1 = "9a0d3ab8afd14f33a35af7391491ff3104401a35"
uuid = "d1efa939-5518-4425-949f-ab857e148477"
version = "0.1.6"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "e3e5e7dfbe3b7d9ff767264f84e5eca487e586cb"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.2.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "66d72dc6fcc86352f01676e8f0f698562e60510f"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.23.0+0"

[[Weave]]
deps = ["Base64", "Dates", "Highlights", "JSON", "Markdown", "Mustache", "Pkg", "Printf", "REPL", "RelocatableFolders", "Requires", "Serialization", "YAML"]
git-tree-sha1 = "d62575dcea5aeb2bfdfe3b382d145b65975b5265"
uuid = "44d3d7a6-8a23-5bf8-98c5-b353f8df5ec9"
version = "0.10.10"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "c45f4e40e7aafe9d086379e5578947ec8b95a8fb"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─77d26faa-539b-11ec-2537-8f5948852614
# ╟─77cf63d2-539b-11ec-19a9-2552399c576c
# ╟─77cf91e0-539b-11ec-3133-e179469bc331
# ╠═77cfaf7c-539b-11ec-024c-15eb56b8fc1f
# ╟─77cfcca0-539b-11ec-3acb-1730008efd33
# ╟─77cfcd04-539b-11ec-15b6-fd3f8dc26223
# ╟─77cfcf0c-539b-11ec-02d9-4db0fefa68c2
# ╟─77cfcf34-539b-11ec-01be-8dfdfd4437bb
# ╟─77d0051c-539b-11ec-15fa-4f3f4d940df2
# ╟─77d085d0-539b-11ec-1a3d-7991c2fbf9b9
# ╟─77d08780-539b-11ec-28d9-298fa970b321
# ╟─77d09d42-539b-11ec-11c1-a31821725916
# ╟─77d09dc6-539b-11ec-0bf6-4b25b5e895de
# ╟─77d09dec-539b-11ec-39d4-613458cd1a59
# ╟─77d09eb4-539b-11ec-2ba9-bd106f28c3b1
# ╟─77d09ed2-539b-11ec-2d31-5f0440ddd6f6
# ╟─77d09f04-539b-11ec-0e28-415df29ba960
# ╟─77d09f2e-539b-11ec-3f75-01a5a66c8b0e
# ╟─77d09f68-539b-11ec-2145-451c57cde49f
# ╟─77d09f7c-539b-11ec-258e-bda76eb1e326
# ╟─77d0a080-539b-11ec-3f15-55b87e92d577
# ╠═77d0a40e-539b-11ec-16f0-51d41df5e415
# ╟─77d0a486-539b-11ec-14aa-15f120921b51
# ╠═77d0be94-539b-11ec-2ea8-7dad3c087486
# ╟─77d0bf3e-539b-11ec-372b-c967137f1ebb
# ╠═77d0c344-539b-11ec-1525-7b1cd944b611
# ╟─77d0c39e-539b-11ec-3a5a-d70def6963df
# ╠═77d0c736-539b-11ec-180e-2b78604ab92d
# ╟─77d0c786-539b-11ec-0ee6-83d7ccce1a6e
# ╟─77d0c7a4-539b-11ec-0368-6ff0395e2f39
# ╠═77d0cde4-539b-11ec-340d-43d87ad19bf8
# ╟─77d0ce32-539b-11ec-3e86-1f9a59ae43e4
# ╟─77d0ce70-539b-11ec-0758-b5998bf7fd42
# ╟─77d0cea2-539b-11ec-240c-d54ac050bc7c
# ╠═77d0d050-539b-11ec-1871-21a04899b26d
# ╟─77d0e716-539b-11ec-1e59-4353ceb74f22
# ╟─77d0e7b6-539b-11ec-1179-4f36efc01379
# ╠═77d0ee14-539b-11ec-2915-91e6888de055
# ╟─77d0ee50-539b-11ec-2b36-677b66ebf04f
# ╠═77d0f0bc-539b-11ec-1716-f7fcbaa00330
# ╟─77d0f0e4-539b-11ec-2faf-23b5f2484669
# ╠═77d10a3e-539b-11ec-16c5-f5c22fa8c2d3
# ╟─77d10ad4-539b-11ec-1ae5-f74ca780671b
# ╟─77d10af2-539b-11ec-39ca-ed2e92a3e358
# ╟─77d120dc-539b-11ec-07cf-1929a61334b8
# ╟─77d1215e-539b-11ec-2565-7d44865c35bb
# ╟─77d12186-539b-11ec-27a0-3bd404409313
# ╟─77d121ae-539b-11ec-1bfb-498862596b3d
# ╟─77d121e0-539b-11ec-3191-65d7daf2e488
# ╟─77d121f4-539b-11ec-3eac-05f60b9405a8
# ╟─77d1221c-539b-11ec-3626-ed310416a21b
# ╟─77d1229e-539b-11ec-3b23-f541f5d55bf4
# ╟─77d122dc-539b-11ec-2871-df8623565b57
# ╟─77d122f8-539b-11ec-0a19-e596c3b82d4e
# ╠═77d144fe-539b-11ec-1ee9-8f6908c6a06e
# ╟─77d1458a-539b-11ec-0657-830ba49fa530
# ╟─77d145da-539b-11ec-084a-058e276af32a
# ╟─77d1460c-539b-11ec-0edc-d727b97c0456
# ╟─77d1468e-539b-11ec-1cef-83fd6bc4bf67
# ╟─77d146b6-539b-11ec-2c90-69300bcdc131
# ╟─77d146de-539b-11ec-22f7-49767d5a1d8f
# ╟─77d14710-539b-11ec-1bbd-5324d6f89c79
# ╟─77d14736-539b-11ec-348d-b32408e361dc
# ╟─77d1474c-539b-11ec-0fb2-e993d2d82b86
# ╟─77d14760-539b-11ec-3231-afd914745dd1
# ╟─77d14792-539b-11ec-0fbb-9949eaf8ca38
# ╟─77d147a8-539b-11ec-0dd7-a56b28e8f5ba
# ╟─77d147b0-539b-11ec-092a-35d1c7a8253d
# ╟─77d147ba-539b-11ec-2277-3157e2ef1138
# ╟─77d147ec-539b-11ec-217b-2536633caecb
# ╟─77d147f6-539b-11ec-0166-df6213d0ac8e
# ╟─77d14dac-539b-11ec-1c2d-f13b85acef0a
# ╟─77d14dda-539b-11ec-14b0-07e58aecdacd
# ╟─77d14e04-539b-11ec-0651-ad8fb82f3936
# ╟─77d14e22-539b-11ec-3967-edc29f204355
# ╟─77d14e5e-539b-11ec-3756-f36f15eb2286
# ╟─77d14e7c-539b-11ec-2519-73c461ade761
# ╟─77d14ea4-539b-11ec-180c-b71e86f66074
# ╟─77d14ec2-539b-11ec-30bd-555659755539
# ╟─77d14ee2-539b-11ec-12e5-7f8563cc8227
# ╟─77d14ef4-539b-11ec-0a03-8fecd997a14a
# ╟─77d1655e-539b-11ec-3f52-bb4bdbb22332
# ╠═77d169ca-539b-11ec-094f-95e858c9aa5a
# ╠═77d16f1a-539b-11ec-23f7-bdb936843857
# ╟─77d16f38-539b-11ec-153a-730fabc4df71
# ╠═77d17472-539b-11ec-075b-190e0c941aad
# ╟─77d17492-539b-11ec-1312-d569dc975ba1
# ╟─77d174e2-539b-11ec-145c-2961eb93da81
# ╠═77d1b2ae-539b-11ec-230a-b10d875e2ec0
# ╟─77d1b300-539b-11ec-3ecf-bf056bdd7ad4
# ╠═77d1b68c-539b-11ec-0108-a5bd096df6d7
# ╟─77d1b6d4-539b-11ec-04c5-31c1caffb937
# ╟─77d1b6e6-539b-11ec-0727-130136105cc6
# ╠═77d1ba68-539b-11ec-3caa-1d9f65b5374d
# ╟─77d1bac4-539b-11ec-0a06-d140218bf87a
# ╟─77d1bae2-539b-11ec-1f43-11ac0c910985
# ╟─77d1bb00-539b-11ec-0636-b1ad62e9eca1
# ╟─77d1bb6c-539b-11ec-2a24-f73aaee7de9b
# ╟─77d1bbaa-539b-11ec-2c62-87a6df6f2506
# ╟─77d1bbbe-539b-11ec-03d8-c5d681b77920
# ╟─77d1bbe6-539b-11ec-0c8d-b1708058c1c2
# ╟─77d1bbfa-539b-11ec-0633-eb8533663f31
# ╟─77d1bc0e-539b-11ec-37a7-5b1eb2321a21
# ╟─77d1bc36-539b-11ec-06a8-a1c888792cb5
# ╟─77d1bc42-539b-11ec-054d-69f34fdbc616
# ╟─77d1bc74-539b-11ec-180d-2f713fd3e6fd
# ╟─77d1bc7c-539b-11ec-38a2-21fec6de3201
# ╟─77d1bca6-539b-11ec-0b3d-8d9feec3f55a
# ╟─77d1bcd4-539b-11ec-27d7-49abf10b911b
# ╟─77d1bd30-539b-11ec-316e-d9b022693467
# ╟─77d1bd44-539b-11ec-2d57-5bcffea3408f
# ╟─77d1bd62-539b-11ec-35a9-3d66b0ccd749
# ╟─77d1bd80-539b-11ec-2e28-edfd2cd935ef
# ╟─77d1bdbc-539b-11ec-1032-e5243e8fd60a
# ╟─77d1bddc-539b-11ec-2bb8-4f18ec04b217
# ╟─77d1bdf8-539b-11ec-2a07-f1242bbdc3b5
# ╟─77d1be20-539b-11ec-2654-bf6624741e1f
# ╟─77d1be5c-539b-11ec-3cf1-e9f3cec3220e
# ╠═77d1c49c-539b-11ec-1e13-8f538c68ef95
# ╟─77d1c4c4-539b-11ec-1d7c-f99204b7bf45
# ╟─77d1c50a-539b-11ec-38dd-af4ead25aff5
# ╠═77d1cc12-539b-11ec-3f95-178f9ab08753
# ╟─77d1cc62-539b-11ec-1ac9-97a61f987332
# ╠═77d1ebaa-539b-11ec-1f31-dd4c2af0d59b
# ╟─77d1ebe8-539b-11ec-0bd4-3d0e1f94b5ed
# ╠═77d1f200-539b-11ec-35ff-bb65c354329b
# ╟─77d1f246-539b-11ec-2905-d5d50eb13889
# ╠═77d1f796-539b-11ec-346a-f1934523295e
# ╟─77d1f7c8-539b-11ec-31f8-631c5c2dc003
# ╟─77d1f7dc-539b-11ec-05d5-efa59d584f03
# ╟─77d1f820-539b-11ec-18e9-ddd6c4499899
# ╟─77d1f8a4-539b-11ec-3faf-29b51f2443d6
# ╟─77d1f930-539b-11ec-2865-a7fe908db2a6
# ╟─77d2009c-539b-11ec-2e79-7baff9f508d7
# ╟─77d200c4-539b-11ec-0b22-c7531893d0fc
# ╟─77d200d8-539b-11ec-2d95-17ed21a87d53
# ╟─77d200ec-539b-11ec-3a36-4b48ceb4d153
# ╟─77d20790-539b-11ec-2a58-5d0880b059b8
# ╟─77d207ae-539b-11ec-261d-d79c6455c788
# ╟─77d207e0-539b-11ec-0bef-5bd065074a23
# ╟─77d2088a-539b-11ec-1f74-c5e4b66d84ae
# ╟─77d229be-539b-11ec-0fea-c1cb30784fab
# ╟─77d22a0e-539b-11ec-3518-b9bc2ea5c132
# ╟─77d22a5e-539b-11ec-0096-2d17b6777cd3
# ╟─77d24590-539b-11ec-09f4-5d1008e6562c
# ╟─77d245ca-539b-11ec-0eac-5ba648b708a4
# ╟─77d24606-539b-11ec-29a0-0174dab97cdf
# ╟─77d24c32-539b-11ec-098f-436e154bbb30
# ╟─77d24c50-539b-11ec-2612-0362367160d9
# ╟─77d24ca0-539b-11ec-14cd-d9c10eab7801
# ╟─77d2515a-539b-11ec-2eef-a790be1a8f1a
# ╟─77d2518c-539b-11ec-378e-8512dd434d2d
# ╟─77d251be-539b-11ec-1949-a9844daeadc2
# ╟─77d255f6-539b-11ec-06a3-91350c62f991
# ╟─77d25614-539b-11ec-3bc2-e1f451f3c244
# ╟─77d256c8-539b-11ec-2f68-2597f70c0f1c
# ╟─77d25d26-539b-11ec-224d-99099b3fe9ee
# ╟─77d25d42-539b-11ec-3b4f-7f8da5e168ec
# ╟─77d25d94-539b-11ec-3c6c-c96aba8265a0
# ╟─77d26208-539b-11ec-2451-6d2962667c20
# ╟─77d26226-539b-11ec-3422-f7a2ff27d088
# ╟─77d26250-539b-11ec-2d06-b96ceaef4eac
# ╟─77d268f2-539b-11ec-0a09-95abd48ba14e
# ╟─77d26942-539b-11ec-3a6c-5b859d1ac288
# ╟─77d26f64-539b-11ec-2610-51515d86b001
# ╟─77d26fd2-539b-11ec-0660-2b20b4997cd2
# ╟─77d26ff0-539b-11ec-3434-f1fb4242e2c6
# ╟─77d26ff0-539b-11ec-0ac8-b7af2114c109
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
