### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ 76d90728-793c-11ec-02e4-218df8d51b08
begin
	using CalculusWithJulia
	using Plots
	using SymPy
end

# ╔═╡ 76d90c1e-793c-11ec-14c3-eb081f26009a
begin
	using CalculusWithJulia.WeaveSupport
	import PyPlot
	pyplot()
	nothing
end

# ╔═╡ 76ebf888-793c-11ec-2187-53af8ace6ee5
using PlutoUI

# ╔═╡ 76ebf860-793c-11ec-04e3-8902609bd448
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 76d8ca1a-793c-11ec-1ebc-1d346c8cda95
md"""# ODEs
"""

# ╔═╡ 76d8ca88-793c-11ec-2092-ff2f004b2bef
md"""This section uses these add-on packages:
"""

# ╔═╡ 76d90ca0-793c-11ec-38ef-17af41684647
md"""---
"""

# ╔═╡ 76d90cc8-793c-11ec-31ba-21f28d1c88e9
md"""Some relationships are easiest to describe in terms of rates or derivatives. For example:
"""

# ╔═╡ 76e41ca8-793c-11ec-3664-9f58f41cb996
md"""  * Knowing the speed of a car and how long it has been driving can summarize the car's location.
  * One of Newton's famous laws, $F=ma$, describes the force on an  object of mass $m$ in terms of the acceleration. The acceleration  is the derivative of velocity, which in turn is the derivative of  position. So if we know the rates of change of $v(t)$ or $x(t)$, we  can differentiate to find $F$.
  * Newton's law of [cooling](http://tinyurl.com/z4lmetp). This describes the temperature change in an object due to a difference in temperature with the object's surroundings. The formula being, $T'(t) = -r \left(T(t) - T_a \right)$, where $T(t)$ is temperature at time $t$ and $T_a$ the ambient temperature.
  * [Hooke's law](http://tinyurl.com/kbz7r8l) relates force on an object to the position on the object, through $F = k x$. This is appropriate for many systems involving springs. Combined with Newton's law $F=ma$, this leads to an equation that $x$ must satisfy: $m x''(t) = k x(t)$.
"""

# ╔═╡ 76e41e06-793c-11ec-0ff0-5354448854a5
md"""## Motion with constant acceleration
"""

# ╔═╡ 76e41e30-793c-11ec-3caf-d1e769daab5b
md"""Let's consider the case of constant acceleration. This describes how nearby objects fall to earth, as the force due to gravity is assumed to be a constant, so the acceleration is the constant force divided by the constant mass.
"""

# ╔═╡ 76e41e42-793c-11ec-2110-75bbb9c3ffae
md"""With constant acceleration, what is the velocity?
"""

# ╔═╡ 76e41e6a-793c-11ec-2bb2-21d27d0a21ce
md"""As mentioned, we have $dv/dt = a$ for any velocity function $v(t)$, but in this case, the right hand side is assumed to be constant. How does this restrict the possible functions, $v(t)$, that the velocity can be?
"""

# ╔═╡ 76e41e74-793c-11ec-39e0-3dd27a89319c
md"""Here we can integrate to find that any answer must look like the following for some constant of integration:
"""

# ╔═╡ 76e41ed8-793c-11ec-2c90-e98756d27eb2
md"""```math
v(t) = \int \frac{dv}{dt} dt = \int a dt = at + C.
```
"""

# ╔═╡ 76e41eec-793c-11ec-1dbd-c3dfaa63a88b
md"""If we are given the velocity at a fixed time, say $v(t_0) = v_0$, then we can use the definite integral to get:
"""

# ╔═╡ 76e41f00-793c-11ec-2f08-7d7bfe697ced
md"""```math
v(t) - v(t_0) = \int_{t_0}^t a dt = at - a t_0.
```
"""

# ╔═╡ 76e41f0a-793c-11ec-2ae2-978532ddbcd1
md"""Solving, gives:
"""

# ╔═╡ 76e41f14-793c-11ec-3a21-9bb2e899af97
md"""```math
v(t) = v_0 + a (t - t_0).
```
"""

# ╔═╡ 76e41f28-793c-11ec-136c-dd16c4e1e246
md"""This expresses the velocity at time $t$ in terms of the initial velocity, the constant acceleration and the time duration.
"""

# ╔═╡ 76e41fa0-793c-11ec-010f-318ce375b8f7
md"""A natural question might be, is this the *only* possible answer? There are a few useful ways to think about this.
"""

# ╔═╡ 76e41ff8-793c-11ec-2c50-dd1b646c430d
md"""First, suppose there were another, say $u(t)$. Then define $w(t)$ to be the difference: $w(t) = v(t) - u(t)$. We would have that $w'(t) = v'(t) - u'(t) = a - a = 0$. But from the mean value theorem, a function whose derivative is *continuously* $0$, will necessarily be a constant. So at most, $v$ and $u$ will differ by a constant, but if both are equal at $t_0$, they will be equal for all $t$.
"""

# ╔═╡ 76e42018-793c-11ec-3b06-1709793711f5
md"""Second, since the derivative of any solution is a continuous function, it is true by the fundamental theorem of calculus that it *must* satisfy the form for the antiderivative. The initial condition makes the answer unique, as the indeterminate $C$ can take only one value.
"""

# ╔═╡ 76e42022-793c-11ec-2eb3-2faf0c544121
md"""Summarizing, we have
"""

# ╔═╡ 76e7a7ba-793c-11ec-25b9-4987f597017b
md"""> If $v(t)$ satisfies the equation: $v'(t) = a$, $v(t_0) = v_0,$ then the unique solution will be $v(t) = v_0 + a (t - t_0)$.

"""

# ╔═╡ 76e7a800-793c-11ec-1f08-0d8604ef67b1
md"""Next, what about position? Here we know that the time derivative of position yields the velocity, so we should have that the unknown position function satisfies this equation and initial condition:
"""

# ╔═╡ 76e7a814-793c-11ec-3d97-0dbf39f0d61b
md"""```math
x'(t) = v(t) = v_0 + a (t - t_0), \quad x(t_0) = x_0.
```
"""

# ╔═╡ 76e7a832-793c-11ec-1084-17b65735c1f0
md"""Again, we can integrate to get an answer for any value $t$:
"""

# ╔═╡ 76e7a83c-793c-11ec-3354-3b63b301471d
md"""```math
x(t) - x(t_0) = \int_{t_0}^t \frac{dv}{dt} dt = (v_0t + \frac{1}{2}a t^2 - at_0 t) |_{t_0}^t =
(v_0 - at_0)(t - t_0) + \frac{1}{2} a (t^2 - t_0^2).
```
"""

# ╔═╡ 76e7a85a-793c-11ec-1ab6-7f7e738244f5
md"""There are three constants: the initial value for the independent variable, $t_0$, and the two initial values for the velocity and position, $v_0, x_0$.  Assuming $t_0 = 0$, we can simplify the above to get a formula familiar from introductory physics:
"""

# ╔═╡ 76e7a864-793c-11ec-0580-972b43f8a931
md"""```math
x(t) = x_0 + v_0 t + \frac{1}{2} at^2.
```
"""

# ╔═╡ 76e7a87a-793c-11ec-27d5-f71a3a7c2db3
md"""Again, the mean value theorem can show that with the initial value specified this is the only possible solution.
"""

# ╔═╡ 76e7a896-793c-11ec-17c6-753bb1320486
md"""## First-order initial-value problems
"""

# ╔═╡ 76e7a8be-793c-11ec-317d-e9fd6aa0804e
md"""The two problems just looked at can be summarized by the following. We are looking for solutions to an equation of the form (taking $y$ and $x$ as the variables, in place of $x$ and $t$):
"""

# ╔═╡ 76e7a8d2-793c-11ec-3c21-81035d370db5
md"""```math
y'(x) = f(x), \quad y(x_0) = y_0.
```
"""

# ╔═╡ 76e7a918-793c-11ec-0052-0d419c996b25
md"""This is called an *ordinary differential equation* (ODE), as it is an equation involving the ordinary derivative of an unknown function, $y$.
"""

# ╔═╡ 76e7a92c-793c-11ec-0f03-e96f8db91aed
md"""This is called a first-order, ordinary differential equation, as there is only the first derivative involved.
"""

# ╔═╡ 76e7a94a-793c-11ec-2284-1d29739ea00b
md"""This is called an initial-value problem, as the value at the initial point $x_0$ is specified as part of the problem.
"""

# ╔═╡ 76e7aa1c-793c-11ec-220d-ed58c644a49d
md"""#### Examples
"""

# ╔═╡ 76e7aa30-793c-11ec-3747-2bce513434ee
md"""Let's look at a few more examples, and then generalize.
"""

# ╔═╡ 76e7aabc-793c-11ec-2d13-c394d639b6fc
md"""##### Example: Newton's law of cooling
"""

# ╔═╡ 76e7aad0-793c-11ec-2ab1-c9b07baeb5ed
md"""Consider the ordinary differential equation given by Newton's law of cooling:
"""

# ╔═╡ 76e7aaee-793c-11ec-0825-633b45bedc68
md"""```math
T'(t) = -r (T(t) - T_a), \quad T(0) = T_0
```
"""

# ╔═╡ 76e7ab20-793c-11ec-3e2c-29c56c0175d2
md"""This equation is also first order, as it involves just the first derivative, but notice that on the right hand side is the function $T$, not the variable being differentiated against, $t$.
"""

# ╔═╡ 76e7ab3e-793c-11ec-1c29-d90d9ceaaa72
md"""As we have a difference on the right hand side, we rename the variable through $U(t) = T(t) - T_a$. Then, as $U'(t) = T'(t)$, we have the equation:
"""

# ╔═╡ 76e7ab5c-793c-11ec-3f72-ad9b12cecda8
md"""```math
U'(t) = -r U(t), \quad U(0) = U_0.
```
"""

# ╔═╡ 76e7ac1a-793c-11ec-2939-07ddfcaabc16
md"""This shows that the rate of change of $U$ depends on $U$. Large postive values indicate a negative rate of change - a push back towards the origin, and large negative values of $U$ indicate a positive rate of change - again, a push back towards the origin. We shouldn't be surprised to either see a steady decay towards the origin, or oscillations about the origin.
"""

# ╔═╡ 76e7ac80-793c-11ec-1858-29948d3050c4
md"""What will we find? This equation is different from the previous two equations, as the function $U$ appears on both sides. However, we can rearrange to get:
"""

# ╔═╡ 76e7ac9c-793c-11ec-23a6-212a4f2d8795
md"""```math
\frac{dU}{dt}\frac{1}{U(t)} = -r.
```
"""

# ╔═╡ 76e7acba-793c-11ec-3624-a579dea402c8
md"""This suggests integrating both sides, as before. Here we do the "$u$"-substitution $u = U(t)$, so $du = U'(t) dt$:
"""

# ╔═╡ 76e7acc4-793c-11ec-0011-13c6acfb5d4c
md"""```math
-rt + C = \int \frac{dU}{dt}\frac{1}{U(t)} dt =
\int \frac{1}{u}du = \log(u).
```
"""

# ╔═╡ 76e7ace4-793c-11ec-38e8-a34e324a3e56
md"""Solving gives: $u = U(t) = e^C e^{-rt}$. Using the initial condition forces $e^C = U(t_0) = T(0) - T_a$ and so our solution in terms of $T(t)$ is:
"""

# ╔═╡ 76e7ad0a-793c-11ec-2b6d-c385569d2962
md"""```math
T(t) - T_a = (T_0 - T_a) e^{-rt}.
```
"""

# ╔═╡ 76e7ad32-793c-11ec-3a75-dfad25550038
md"""In words, the initial difference in temperature of the object and the environment exponentially decays to $0$.
"""

# ╔═╡ 76e7ad64-793c-11ec-3034-379664748fe4
md"""That is, as $t > 0$ goes to $\infty$, the right hand will go to $0$ for $r > 0$, so $T(t) \rightarrow T_a$ - the temperature of the object will reach the ambient temperature. The rate of this is largest when the difference between $T(t)$ and $T_a$ is largest, so when objects are cooling the statement "hotter things cool faster" is appropriate.
"""

# ╔═╡ 76e7ad82-793c-11ec-032a-71bbb8c712c1
md"""A graph of the solution for $T_0=200$ and $T_a=72$ and $r=1/2$ is made as follows. We've added a few line segments from the defining formula, and see that they are indeed tangent to the solution found for the differential equation.
"""

# ╔═╡ 76e7bc32-793c-11ec-1a77-177a625b0754
let
	T0, Ta, r = 200, 72, 1/2
	f(u, t) = -r*(u - Ta)
	v(t) = Ta + (T0 - Ta) * exp(-r*t)
	p = plot(v, 0, 6, linewidth=4, legend=false)
	[plot!(p, x -> v(a) + f(v(a), a) * (x-a), 0, 6) for a in 1:2:5]
	p
end

# ╔═╡ 76e7bc6e-793c-11ec-069b-efad499a1778
md"""The above is implicitly assuming that there could be no other solution, than the one we found. Is that really the case? We will see that there is a theorem that can answer this, but in this case, the trick of taking the difference of two equations satisfying the equation leads to the equation $W'(t) = r W(t), \text{ and } W(0) = 0$. This equation has a general solution of $W(t) = Ce^{rt}$ and the initial condition forces $C=0$, so $W(t) = 0$, as before. Hence, the initial-value problem for Newton's law of cooling has a unique solution.
"""

# ╔═╡ 76e7bc8a-793c-11ec-166e-45a7f2cd5f0e
md"""In general, the equation could be written as (again using $y$ and $x$ as the variables):
"""

# ╔═╡ 76e7bca0-793c-11ec-10fd-8b71cd7c1511
md"""```math
y'(x) = g(y), \quad y(x_0) = y_0
```
"""

# ╔═╡ 76e7bcd2-793c-11ec-0615-31320c22ad76
md"""This is called an *autonomous*, first-order ODE, as the right-hand side does not depend on $x$ (except through $y(x)$).
"""

# ╔═╡ 76e7bcf0-793c-11ec-055b-b164b6f395ea
md"""Let $F(y) = \int_{y_0}^y du/g(u)$, then a solution to the above is $F(y) = x - x_0$, assuming $1/g(u)$ is integrable.
"""

# ╔═╡ 76e7bd04-793c-11ec-1c66-d11c64c8b06d
md"""##### Example: Toricelli's law
"""

# ╔═╡ 76e7bd4a-793c-11ec-2798-c1f884077091
md"""[Toricelli's Law](http://tinyurl.com/hxvf3qp) describes the speed a jet of water will leave a vessel through an opening below the surface of the water. The formula is $v=\sqrt{2gh}$, where $h$ is the height of the water above the hole and $g$ the gravitational constant. This arises from equating the kinetic energy gained, $1/2 mv^2$ and potential energy lost, $mgh$, for the exiting water.
"""

# ╔═╡ 76e7bd72-793c-11ec-3ddc-a93107c4f6dc
md"""An application of Torricelli's law is to describe the volume of water in a tank over time, $V(t)$. Imagine a cylinder of cross sectional area $A$ with a hole of cross sectional diameter $a$ at the bottom, Then $V(t) = A h(t)$, with $h$ giving the height. The change in volume over $\Delta t$ units of time must be given by the value $a v(t) \Delta t$, or
"""

# ╔═╡ 76e7bd86-793c-11ec-1e13-935626961791
md"""```math
V(t+\Delta t) - V(t) = -a v(t) \Delta t = -a\sqrt{2gh(t)}\Delta t
```
"""

# ╔═╡ 76e7bd9a-793c-11ec-3991-2339a2cac4f5
md"""This suggests the following formula, written in terms of $h(t)$ should apply:
"""

# ╔═╡ 76e7bda4-793c-11ec-06d5-79cc824dbf86
md"""```math
A\frac{dh}{dt} = -a \sqrt{2gh(t)}.
```
"""

# ╔═╡ 76e7bdae-793c-11ec-1f80-59e08ce44ffb
md"""Rearranging, this gives an equation
"""

# ╔═╡ 76e7bdb8-793c-11ec-34bb-d77c41e9de75
md"""```math
\frac{dh}{dt} \frac{1}{\sqrt{h(t)}} = -\frac{a}{A}\sqrt{2g}.
```
"""

# ╔═╡ 76e7bdcc-793c-11ec-21d1-9362fcca2793
md"""Integrating both sides yields:
"""

# ╔═╡ 76e7bdd6-793c-11ec-1f42-49c79deac04e
md"""```math
2\sqrt{h(t)} = -\frac{a}{A}\sqrt{2g} t + C.
```
"""

# ╔═╡ 76e7bdea-793c-11ec-043d-138db64a5380
md"""If $h(0) = h_0 = V(0)/A$, we can solve for $C = 2\sqrt{h_0}$, or
"""

# ╔═╡ 76e7bdf2-793c-11ec-223d-57f273502f33
md"""```math
\sqrt{h(t)} = \sqrt{h_0} -\frac{1}{2}\frac{a}{A}\sqrt{2g} t.
```
"""

# ╔═╡ 76e7be1c-793c-11ec-351a-d11d919f40fc
md"""Setting $h(t)=0$ and solving for $t$ shows that the time to drain the tank would be $(2A)/(a\sqrt{2g})\sqrt{h_0}$.
"""

# ╔═╡ 76e7be30-793c-11ec-1b21-855e61c76c62
md"""##### Example
"""

# ╔═╡ 76e7be44-793c-11ec-12a4-0bbaa8777685
md"""Consider now the equation
"""

# ╔═╡ 76e7be4e-793c-11ec-1e92-9586f2a7ef52
md"""```math
y'(x) = y(x)^2, \quad y(x_0) = y_0.
```
"""

# ╔═╡ 76e7be6c-793c-11ec-3929-a31d53e95f07
md"""This is called a *non-linear* ordinary differential equation, as the $y$ variable on the right hand side presents itself in a non-linear form (it is squared). These equations may have solutions that are not defined for all times.
"""

# ╔═╡ 76e7be80-793c-11ec-147c-1d0c032785a7
md"""This particular problem can be solved as before by moving the $y^2$ to the left hand side and integrating to yield:
"""

# ╔═╡ 76e7be8a-793c-11ec-3c0e-2f69dde35757
md"""```math
y(x) = - \frac{1}{C + x},
```
"""

# ╔═╡ 76e7be96-793c-11ec-0cd2-51a2b6fbd48a
md"""and with the initial condition:
"""

# ╔═╡ 76e7be9e-793c-11ec-2af0-9554bae6f386
md"""```math
y(x) = \frac{y_0}{1 - y_0(x - x_0)}.
```
"""

# ╔═╡ 76e7bed0-793c-11ec-17d9-0318659d95b4
md"""This answer can demonstrate *blow-up*. That is, in a finite range for $x$ values, the $y$ value can go to infinity. For example, if the initial conditions are $x_0=0$ and $y_0 = 1$, then $y(x) = 1/(1-x)$ is only defined for $x \geq x_0$ on $[0,1)$, as at $x=1$ there is a vertical asymptote.
"""

# ╔═╡ 76e7beee-793c-11ec-156a-99db7e5e589c
md"""## Separable equations
"""

# ╔═╡ 76e7bf0c-793c-11ec-16f5-d3ced40452af
md"""We've seen equations of the form $y'(x) = f(x)$ and $y'(x) = g(y)$ both solved by integrating. The same tricks will work for equations of the form $y'(x) = f(x) \cdot g(y)$. Such equations are called *separable*.
"""

# ╔═╡ 76e7bf20-793c-11ec-2dc5-bf39200655bb
md"""Basically, we equate up to constants
"""

# ╔═╡ 76e7bf34-793c-11ec-32a8-6db3a5578ff8
md"""```math
\int \frac{dy}{g(y)} = \int f(x) dx.
```
"""

# ╔═╡ 76e7bf3e-793c-11ec-08a4-31f71fae1e26
md"""For example, suppose we have the equation
"""

# ╔═╡ 76e7bf48-793c-11ec-102e-a93ca3f4988b
md"""```math
\frac{dy}{dx} = x \cdot y(x), \quad y(x_0) = y_0.
```
"""

# ╔═╡ 76e7bf5c-793c-11ec-1153-fdb5d29e2cd4
md"""Then we can find a solution, $y(x)$ through:
"""

# ╔═╡ 76e7bf66-793c-11ec-3a1b-a78b7734bb5d
md"""```math
\int \frac{dy}{y} = \int x dx,
```
"""

# ╔═╡ 76e7bf70-793c-11ec-336d-8bb2350063df
md"""or
"""

# ╔═╡ 76e7bf7a-793c-11ec-1c2b-2b18bd49704f
md"""```math
\log(y) = \frac{x^2}{2} + C
```
"""

# ╔═╡ 76e7bf84-793c-11ec-133d-47acb44220fa
md"""Which yields:
"""

# ╔═╡ 76e7bf8e-793c-11ec-3fab-b76c49691f56
md"""```math
y(x) = e^C e^{\frac{1}{2}x^2}.
```
"""

# ╔═╡ 76e7bfa2-793c-11ec-32eb-3920585d149a
md"""Substituting in $x_0$ yields a value for $C$ in terms of the initial information $y_0$ and $x_0$.
"""

# ╔═╡ 76e7bfb6-793c-11ec-1bb5-c1459ad37126
md"""## Symbolic solutions
"""

# ╔═╡ 76e7bfc0-793c-11ec-2f7c-cfaca0616a5a
md"""Differential equations are classified according to their type. Different types have different methods for solution, when a solution exists.
"""

# ╔═╡ 76e7bfd4-793c-11ec-3a67-036d9dfe643b
md"""The first-order initial value equations we have seen can be described generally by
"""

# ╔═╡ 76e7bfde-793c-11ec-12e6-6df1550ba207
md"""```math
\begin{align*}
y'(x) &= F(y,x),\\
y(x_0) &= x_0.
\end{align*}
```
"""

# ╔═╡ 76e7bfe8-793c-11ec-1369-3f90b0f10085
md"""Special cases include:
"""

# ╔═╡ 76e8fcb4-793c-11ec-37db-9ba7d1db1aa2
md"""  * *linear* if the function $F$ is linear in $y$;
  * *autonomous* if $F(y,x) = G(y)$ (a function of $y$ alone);
  * *separable* if $F(y,x) = G(y)H(x)$.
"""

# ╔═╡ 76e8fd22-793c-11ec-27e3-0f6ad6b4739b
md"""As seen, separable equations are approached by moving the "$y$" terms to one side, the "$x$" terms to the other and integrating. This also applies to autonomous equations then. There are other families of equation types that have exact solutions, and techniques for solution, summarized at this [Wikipedia page](http://tinyurl.com/zywzz4q).
"""

# ╔═╡ 76e8fd4a-793c-11ec-2e16-8fa4290e45f0
md"""Rather than go over these various families, we demonstrate that `SymPy` can solve many of these equations symbolically.
"""

# ╔═╡ 76e8fd7c-793c-11ec-2e47-af0229e4c99d
md"""The `solve` function in `SymPy` solves equations for unknown *variables*. As a differential equation involves an unknown *function* there is a different function, `dsolve`. The basic idea is to describe the differential equation using a symbolic function and then call `dsolve` to solve the expression.
"""

# ╔═╡ 76e8fd90-793c-11ec-1150-314a9c4d7305
md"""Symbolic functions are defined by the  `@syms` macro (also see `?symbols`) using parentheses to distinguish a function from a variable:
"""

# ╔═╡ 76e90466-793c-11ec-06bf-a524994c4f11
@syms x u() # a symbolic variable and a symbolic function

# ╔═╡ 76e904a2-793c-11ec-34d3-658ceaf58bba
md"""We will solve the following, known as the *logistic equation*:
"""

# ╔═╡ 76e904c0-793c-11ec-3912-05a7346bfe3d
md"""```math
u'(x) = a u(1-u), \quad a > 0
```
"""

# ╔═╡ 76e90506-793c-11ec-19fd-4f8e1adb463b
md"""Before beginning, we look at the form of the equation. When $u=0$ or $u=1$ the rate of change is $0$, so we expect the function might be bounded within that range. If not, when $u$ gets bigger than $1$, then the slope is negative and when $u$ gets less than $0$, the slope is positive, so there will at least be a drift back to the range $[0,1]$. Let's see exactly what happens. We define a parameter, restricting `a` to be positive:
"""

# ╔═╡ 76e908ee-793c-11ec-025e-cff5fff0867a
@syms a::positive

# ╔═╡ 76e90920-793c-11ec-0cbf-0d3046d9d8cc
md"""To specify a derivative of `u` in our equation we can use `diff(u(x),x)` but here, for visual simplicity, use the `Differential` operator, as follows:
"""

# ╔═╡ 76e90d8a-793c-11ec-3b28-c5021c333c98
begin
	D = Differential(x)
	eqn = D(u)(x) ~ a * u(x) * (1 - u(x)) # use l \Equal[tab] r, Eq(l,r), or just l - r
end

# ╔═╡ 76e90dda-793c-11ec-1bc9-fdd0ae8172cc
md"""In the above, we evaluate the symbolic function at the variable `x` through the use of `u(x)` in the expression. The equation above uses `~` to combine the left- and right-hand sides as an equation in `SymPy`. (A unicode equals is also available for this task). This is a shortcut for `Eq(l,r)`, but even just using `l - r` would suffice, as the default assumption for an equation is that it is set to `0`.
"""

# ╔═╡ 76e90dee-793c-11ec-188c-2ba44bb6c199
md"""To finish, we call `dsolve` to find a solution (if possible):
"""

# ╔═╡ 76e9108c-793c-11ec-26da-8507dcb68d7f
out = dsolve(eqn)

# ╔═╡ 76e910be-793c-11ec-3131-3b0fd51f808d
md"""This answer - to a first-order equation - has one free constant, `C_1`, which can be solved for from an initial condition. We can see that when $a > 0$, as $x$ goes to positive infinity the solution goes to $1$, and when $x$ goes to negative infinity, the solution goes to $0$ and otherwise is trapped in between, as expected.
"""

# ╔═╡ 76e910d2-793c-11ec-112c-b5df0468a09c
md"""The limits are confirmed by investigating  the limits of the right-hand:
"""

# ╔═╡ 76e9179e-793c-11ec-2a28-ed9f7f406661
limit(rhs(out), x => oo), limit(rhs(out), x => -oo)

# ╔═╡ 76e917c6-793c-11ec-05a0-df1f9171f1c4
md"""We can confirm that the solution is always increasing, hence trapped within $[0,1]$ by observing that the derivative is positive when `C₁` is positive:
"""

# ╔═╡ 76e919a6-793c-11ec-18c4-ede9b7c76299
diff(rhs(out),x)

# ╔═╡ 76e919d8-793c-11ec-3adc-bf9b1d3e667d
md"""Suppose that $u(0) = 1/2$. Can we solve for $C_1$ symbolically? We can use `solve`, but first we will need to get the symbol for `C_1`:
"""

# ╔═╡ 76e91d68-793c-11ec-02e9-61b15911dd57
begin
	eq = rhs(out)    # just the right hand side
	C1 = first(setdiff(free_symbols(eq), (x,a))) # fish out constant, it is not x or a
	c1 = solve(eq(x=>0) - 1//2, C1)
end

# ╔═╡ 76e91d84-793c-11ec-39cc-fb6b3b9d2b2d
md"""And we plug in with:
"""

# ╔═╡ 76e921f8-793c-11ec-3eaf-9dddd380d073
eq(C1 => c1[1])

# ╔═╡ 76e92284-793c-11ec-2280-4d1b62765b25
md"""That's a lot of work. The `dsolve` function in `SymPy` allows initial conditions to be specified for some equations. In this case, ours is $x_0=0$ and $y_0=1/2$. The extra arguments passed in through a dictionary to the  `ics` argument:
"""

# ╔═╡ 76e94f34-793c-11ec-0815-ff1e3b4b17d6
begin
	x0, y0 = 0, Sym(1//2)
	dsolve(eqn, u(x), ics=Dict(u(x0) => y0))
end

# ╔═╡ 76e94f84-793c-11ec-2051-b75d3c43f211
md"""(The one subtlety is the need to write the rational value as a symbolic expression, as otherwise it will get converted to a floating point value prior to being passed along.)
"""

# ╔═╡ 76e94fc0-793c-11ec-0df7-5f6df922a2ee
md"""##### Example: Hooke's law
"""

# ╔═╡ 76e94ffc-793c-11ec-30c4-6bf83817384d
md"""In the first example, we solved for position, $x(t)$, from an assumption of constant acceleration in two steps. The equation relating the two is a second-order equation: $x''(t) = a$, so two constants are generated. That a second-order equation could be reduced to two first-order equations is not happy circumstance, as it can always be done. Rather than show the technique though, we demonstrate that `SymPy` can also handle some second-order ODEs.
"""

# ╔═╡ 76e9501a-793c-11ec-375b-713006536b41
md"""Hooke's law relates the force on an object to its position via $F=ma = -kx$, or $x''(t) = -(k/m)x(t)$.
"""

# ╔═╡ 76e9502e-793c-11ec-2e9d-595e8d350357
md"""Suppose $k > 0$. Then we can solve, similar to the above, with:
"""

# ╔═╡ 76e95632-793c-11ec-04dd-170d4c827da0
begin
	@syms k::positive m::positive
	D2 = D ∘ D
	eqnh = D2(u)(x) ~ -(k/m)*u(x)
	dsolve(eqnh)
end

# ╔═╡ 76e95650-793c-11ec-0824-bff815f4f610
md"""Here we find two constants, as anticipated, for we would guess that two integrations are needed in the solution.
"""

# ╔═╡ 76e95682-793c-11ec-2b89-9177109d58d0
md"""Suppose the spring were started by pulling it down to a bottom and releasing. The initial position at time $0$ would be $a$, say, and initial velocity $0$. Here we get the solution specifying initial conditions on the function and its derivative (expressed through `u'`):
"""

# ╔═╡ 76e960c8-793c-11ec-2cb3-057a9c27a3c1
dsolve(eqnh, u(x), ics = Dict(u(0) => -a, D(u)(0) =>  0))

# ╔═╡ 76e96184-793c-11ec-3228-93499b9a124a
md"""We get that the motion will follow $u(x) = -a \cos(\sqrt{k/m}x)$. This is simple oscillatory behavior. As the spring stretches, the force gets large enough to pull it back, and as it compresses the force gets large enough to push it back. The amplitude of this oscillation is $a$ and the period $2\pi/\sqrt{k/m}$. Larger $k$ values mean shorter periods; larger $m$ values mean longer periods.
"""

# ╔═╡ 76e961b8-793c-11ec-029d-3d0ef63a1147
md"""##### Example: the pendulum
"""

# ╔═╡ 76e9621c-793c-11ec-0dfa-4d687ab6da7d
md"""The simple gravity [pendulum](http://tinyurl.com/h8ys6ts) is an idealization of a physical pendulum that models a "bob" with mass $m$ swinging on a massless rod of length $l$ in a frictionless world governed only by the gravitational constant $g$. The motion can be described by this differential equation for the angle, $\theta$, made from the vertical:
"""

# ╔═╡ 76e9623a-793c-11ec-0398-15712746f31b
md"""```math
\theta''(t) + \frac{g}{l}\sin(\theta(t)) = 0
```
"""

# ╔═╡ 76e96262-793c-11ec-3617-ab8899c99437
md"""Can this second-order equation be solved by `SymPy`?
"""

# ╔═╡ 76e969e2-793c-11ec-0951-57a84814f393
begin
	@syms g::positive l::positive theta()=>"θ"
	eqnp = theta''(x) + g/l*sin(theta(x))
end

# ╔═╡ 76e96a14-793c-11ec-01af-f715a65f1c37
md"""Trying to do so, can cause `SymPy` to hang or simply give up and repeat its input; no easy answer is forthcoming for this equation.
"""

# ╔═╡ 76e96a66-793c-11ec-277b-790f7f6c0348
md"""In general, for the first-order initial value problem characterized by $y'(x) = F(y,x)$, there are conditions ([Peano](http://tinyurl.com/h663wba) and [Picard-Lindelof](http://tinyurl.com/3rbde5e)) that can guarantee the existence (and uniqueness) of equation locally, but there may not be an accompanying method to actually find it. This particular problem has a solution, but it can not be written in terms of elementary functions.
"""

# ╔═╡ 76e96a98-793c-11ec-2ecc-f334f6bc7f3a
md"""However, as [Huygens](https://en.wikipedia.org/wiki/Christiaan_Huygens) first noted, if the angles involved are small, then we approximate the solution through the linearization $\sin(\theta(t)) \approx \theta(t)$. The resulting equation for an approximate answer is just that of Hooke:
"""

# ╔═╡ 76e96aaa-793c-11ec-16d8-1de0af2098c6
md"""```math
\theta''(t) + \frac{g}{l}\theta(t) = 0
```
"""

# ╔═╡ 76e96ad2-793c-11ec-0fd4-d18581383e62
md"""Here, the solution is in terms of sines and cosines, with period given by $T = 2\pi/\sqrt{k} =  2\pi\cdot\sqrt{l/g}$. The answer does not depend on the mass, $m$, of the bob nor the amplitude of the motion, provided the small-angle approximation is valid.
"""

# ╔═╡ 76e96af0-793c-11ec-3c97-693cd56603b2
md"""If we pull the bob back an angle $a$ and release it then the initial conditions are $\theta(0) = a$ and $\theta'(a) = 0$. This gives the solution:
"""

# ╔═╡ 76e97266-793c-11ec-31dd-d7f5c3f05b3b
begin
	eqnp₁ = D2(u)(x) + g/l * u(x)
	dsolve(eqnp₁, u(x), ics=Dict(u(0) => a, D(u)(0) => 0))
end

# ╔═╡ 76e97284-793c-11ec-31e1-8ba9538c9d12
md"""##### Example: hanging cables
"""

# ╔═╡ 76e972ac-793c-11ec-35f0-6fb759589c45
md"""A chain hangs between two supports a distance $L$ apart. What shape will it take if there are no forces outside of gravity acting on it? What about if the force is uniform along length of the chain, like a suspension bridge? How will the shape differ then?
"""

# ╔═╡ 76e972d6-793c-11ec-3b03-033273012f50
md"""Let $y(x)$ describe the chain at position $x$, with $0 \leq x \leq L$, say. We consider first the case of the chain with no force save gravity. Let $w(x)$ be the density of the chain at $x$, taken below to be a constant.
"""

# ╔═╡ 76e972f2-793c-11ec-02c3-032645bdc22c
md"""The chain is in equilibrium, so tension, $T(x)$, in the chain will be in the direction of the derivative. Let $V$ be the vertical component and $H$ the horizontal component. With only gravity acting on the chain, the value of $H$ will be a constant. The value of $V$ will vary with position.
"""

# ╔═╡ 76e97304-793c-11ec-3011-b71571b8a2ef
md"""At a point $x$, there is $s(x)$ amount of chain with weight $w \cdot s(x)$. The tension is in the direction of the tangent line, so:
"""

# ╔═╡ 76e9731a-793c-11ec-124b-c967fb7e496e
md"""```math
\tan(\theta) = y'(x) = \frac{w s(x)}{H}.
```
"""

# ╔═╡ 76e97324-793c-11ec-328d-f170f86b6389
md"""In terms of an increment of chain, we have:
"""

# ╔═╡ 76e9732e-793c-11ec-1642-f5c4ce1d3d9f
md"""```math
\frac{w ds}{H} = d(y'(x)).
```
"""

# ╔═╡ 76e97336-793c-11ec-278f-733d4b61ecf7
md"""That is, the ratio of the vertical and horizontal tensions in the increment are in balance with the differential of the derivative.
"""

# ╔═╡ 76e9734c-793c-11ec-08fd-5dd2ca741b90
md"""But $ds = \sqrt{dx^2 + dy^2} = \sqrt{dx^2 + y'(x)^2 dx^2} = \sqrt{1 + y'(x)^2}dx$, so we can simplify to:
"""

# ╔═╡ 76e97356-793c-11ec-2534-2f7a10a63f1a
md"""```math
\frac{w}{H}\sqrt{1 + y'(x)^2}dx =y''(x)dx.
```
"""

# ╔═╡ 76e97360-793c-11ec-1433-89ee5de60487
md"""This yields the second-order equation:
"""

# ╔═╡ 76e97368-793c-11ec-291a-4df698270efa
md"""```math
y''(x) = \frac{w}{H} \sqrt{1 + y'(x)^2}.
```
"""

# ╔═╡ 76e97388-793c-11ec-1399-e7e02446bdbf
md"""We enter this into `Julia`:
"""

# ╔═╡ 76e97a86-793c-11ec-1867-5933e0440de7
begin
	@syms w::positive H::positive y()
	eqnc = D2(y)(x) ~ (w/H) * sqrt(1 + y'(x)^2)
end

# ╔═╡ 76e97ab8-793c-11ec-1f71-bdc7d3f0b2ec
md"""Unfortunately, `SymPy` needs a bit of help with this problem, by breaking the problem into steps.
"""

# ╔═╡ 76e97ad6-793c-11ec-342f-27054388519c
md"""For the first step we solve for the derivative.  Let $u = y'$, then we have $u'(x) = (w/H)\sqrt{1 + u(x)^2}$:
"""

# ╔═╡ 76e97f86-793c-11ec-398b-dbce5e6c8027
eqnc₁ = subs(eqnc, D(y)(x) => u(x))

# ╔═╡ 76e97f9a-793c-11ec-2f65-f326493c04ba
md"""and can solve via:
"""

# ╔═╡ 76e98198-793c-11ec-0814-85fe1040da8d
outc = dsolve(eqnc₁)

# ╔═╡ 76e981ca-793c-11ec-2698-f5aa36e9c308
md"""So $y'(x) = u(x) = \sinh(C_1 + w \cdot x/H)$. This can be solved by direct integration as there is no $y(x)$ term on the right hand side.
"""

# ╔═╡ 76e98440-793c-11ec-1558-0d0988c83ec5
D(y)(x) ~ rhs(outc)

# ╔═╡ 76e9845e-793c-11ec-0c2b-3d0ded4fff9f
md"""We see a simple linear transformation involving the  hyperbolic sine. To avoid, `SymPy` struggling with the above equation, and knowing the hyperbolic sine is the derivative of the hyperbolic cosine, we anticipate an answer and verify it:
"""

# ╔═╡ 76e98ab2-793c-11ec-35a7-af1ab6c103ab
begin
	yc = (H/w)*cosh(C1 + w*x/H)
	diff(yc, x) == rhs(outc) # == not \Equal[tab]
end

# ╔═╡ 76e98ad0-793c-11ec-0c7f-f39fdf71ae65
md"""The shape is a hyperbolic cosine, known as the catenary.
"""

# ╔═╡ 76e990cc-793c-11ec-3a46-3b03a00b8993
begin
	imgfile = "figures/verrazano-narrows-bridge-anniversary-historic-photos-2.jpeg"
	caption = """
	The cables of an unloaded suspension bridge have a different shape than a loaded suspension bridge. As seen, the cables in this [figure](https://www.brownstoner.com/brooklyn-life/verrazano-narrows-bridge-anniversary-historic-photos/) would be modeled by a catenary.
	"""
	ImageFile(:ODEs, imgfile, caption)
end

# ╔═╡ 76e990fe-793c-11ec-2293-5704ff3d3081
md"""---
"""

# ╔═╡ 76ea876e-793c-11ec-0320-ed70c78df047
md"""If the chain has a uniform load – like a suspension bridge with a deck – sufficient to make the weight of the chain negligible, then how does the above change? Then the vertical tension comes from $Udx$ and not $w ds$, so the equation becomes instead:
"""

# ╔═╡ 76ea87de-793c-11ec-1a1f-39d85d0004b1
md"""```math
\frac{Udx}{H} = d(y'(x)).
```
"""

# ╔═╡ 76ea8818-793c-11ec-11fa-3d25449def7a
md"""This $y''(x) = U/H$, a constant. So it's answer will be a parabola.
"""

# ╔═╡ 76ea8836-793c-11ec-2b07-8fe9c7c409fb
md"""##### Example: projectile motion in a medium
"""

# ╔═╡ 76ea8854-793c-11ec-2e70-b77671b48f03
md"""The first example describes projectile motion without air resistance. If we use $(x(t), y(t))$ to describe position at time $t$, the functions satisfy:
"""

# ╔═╡ 76ea8868-793c-11ec-16b5-1989205cfc01
md"""```math
x''(t) = 0, \quad y''(t) = -g.
```
"""

# ╔═╡ 76ea8886-793c-11ec-23d9-71d79279745f
md"""That is, the $x$ position - where no forces act - has $0$ acceleration, and the $y$ position - where the force of gravity acts - has constant acceleration, $-g$, where $g=9.8m/s^2$ is the gravitational constant. These equations can be solved to give:
"""

# ╔═╡ 76ea889a-793c-11ec-0b7e-01ff0f3bd367
md"""```math
x(t) = x_0 + v_0 \cos(\alpha) t, \quad y(t) = y_0 + v_0\sin(\alpha)t - \frac{1}{2}g \cdot t^2.
```
"""

# ╔═╡ 76ea88b8-793c-11ec-00d5-fb47a8fdc015
md"""Furthermore, we can solve for $t$ from $x(t)$, to get an equation describing $y(x)$. Here are all the steps:
"""

# ╔═╡ 76ea91fa-793c-11ec-3171-b94586743fb5
let
	@syms x0::real y0::real v0::real alpha::real g::real
	@syms t x u()
	a1 = dsolve(D2(u)(x) ~ 0, u(x), ics=Dict(u(0) => x0, D(u)(0) => v0 * cos(alpha)))
	a2 = dsolve(D2(u)(x) ~ -g, u(x), ics=Dict(u(0) => y0, D(u)(0) => v0 * sin(alpha)))
	ts = solve(t - rhs(a1), x)[1]
	y = simplify(rhs(a2)(t => ts))
	sympy.Poly(y, x).coeffs()
end

# ╔═╡ 76ea9240-793c-11ec-1d08-37c1db15bb15
md"""Though `y` is messy, it can be seen that the answer is a quadratic polynomial in $x$ yielding the familiar parabolic motion for a trajectory. The output shows the coefficients.
"""

# ╔═╡ 76ea925e-793c-11ec-2ccc-031679306003
md"""In a resistive medium, there are drag forces at play. If this force is proportional to the velocity, say, with proportion $\gamma$, then the equations become:
"""

# ╔═╡ 76ea927c-793c-11ec-0497-6500ab46ace8
md"""```math
\begin{align*}
x''(t) &= -\gamma x'(t), & \quad y''(t) &= -\gamma y'(t) -g, \\
x(0) &= x_0, &\quad y(0) &= y_0,\\
x'(0) &= v_0\cos(\alpha),&\quad y'(0) &= v_0 \sin(\alpha).
\end{align*}
```
"""

# ╔═╡ 76ea9290-793c-11ec-2883-47893133322f
md"""We now attempt to solve these.
"""

# ╔═╡ 76ea99ac-793c-11ec-3964-5382ee5a872e
begin
	@syms alpha::real, γ::postive, t::positive, v()
	@syms x_0::real y_0::real v_0::real
	Dₜ = Differential(t)
	eq₁ = Dₜ(Dₜ(u))(t) ~    - γ * Dₜ(u)(t)
	eq₂ = Dₜ(Dₜ(v))(t) ~ -g - γ * Dₜ(v)(t)
	
	a₁ = dsolve(eq₁, ics=Dict(u(0) => x_0, Dₜ(u)(0) => v_0 * cos(alpha)))
	a₂ = dsolve(eq₂, ics=Dict(v(0) => y_0, Dₜ(v)(0) => v_0 * sin(alpha)))
	
	ts = solve(x - rhs(a₁), t)[1]
	yᵣ = rhs(a₂)(t => ts)
end

# ╔═╡ 76ea99d4-793c-11ec-15bd-4942ccc2ddd9
md"""This gives $y$ as a function of $x$.
"""

# ╔═╡ 76ea99e8-793c-11ec-322e-159134b27a22
md"""There are a lot of symbols. Lets simplify by using constants $x_0=y_0=0$:
"""

# ╔═╡ 76ea9f9c-793c-11ec-0806-35d2ecb81c4d
yᵣ₁ = yᵣ(x_0 => 0, y_0 => 0)

# ╔═╡ 76ea9fc2-793c-11ec-0265-ad2feac4c6a9
md"""What is the trajectory? We see that the `log` function part will have issues when $-\gamma x + v_0 \cos(\alpha) = 0$.
"""

# ╔═╡ 76ea9fd8-793c-11ec-10bb-959f41ef7aad
md"""If we fix some parameters, we can plot.
"""

# ╔═╡ 76eaa65e-793c-11ec-0c86-4947019048bd
begin
	v₀, γ₀, α = 200, 1/2, pi/4
	soln = yᵣ₁(v_0=>v₀, γ=>γ₀, alpha=>α, g=>9.8)
	plot(soln, 0, v₀ * cos(α) / γ₀ - 1/10, legend=false)
end

# ╔═╡ 76eaa67c-793c-11ec-013c-35f4b7fae5a8
md"""We can see that the resistance makes the path quite non-symmetric.
"""

# ╔═╡ 76eaa6ae-793c-11ec-114d-d343c3f752ce
md"""## Visualizing a first-order initial value problem
"""

# ╔═╡ 76eaa6f4-793c-11ec-301e-0fa746a1697b
md"""The solution, $y(x)$, is known through its derivative. A useful tool to visualize the solution to a first-order differential equation is the [slope field](http://tinyurl.com/jspzfok) (or direction field) plot, which at different values of $(x,y)$, plots a vector with slope given through $y'(x)$.The `vectorfieldplot` of the `CalculusWithJulia` package can be used to produce these.
"""

# ╔═╡ 76eaa70a-793c-11ec-1935-b5271452c3e7
md"""For example, in a previous example we found a solution to  $y'(x) = x\cdot y(x)$, coded as
"""

# ╔═╡ 76eaa97e-793c-11ec-049c-2fcbc6b470d7
F(y, x) = y*x

# ╔═╡ 76eaa9a6-793c-11ec-29c0-a188102f30ad
md"""Suppose $x_0=1$ and $y_0=1$. Then a direction field plot is drawn through:
"""

# ╔═╡ 76eaad6e-793c-11ec-1a7e-d75664bc1dbd
let
	@syms x y
	x0, y0 = 1, 1
	
	plot(legend=false)
	vectorfieldplot!((x,y) -> [1, F(y,x)], xlims=(x0, 2), ylims=(y0-5, y0+5))
	
	f(x) =  y0*exp(-x0^2/2) * exp(x^2/2)
	plot!(f,  linewidth=5)
end

# ╔═╡ 76eaada2-793c-11ec-3959-f53a5a2d2583
md"""In general, if the first-order equation is written as $y'(x) = F(y,x)$, then we plot a "function" that takes $(x,y)$ and returns an $x$ value of $1$ and a $y$ value of $F(y,x)$, so the slope is $F(y,x)$.
"""

# ╔═╡ 76eab39c-793c-11ec-3d7c-03e4c33b5d18
note(L"""The order of variables in $F(y,x)$ is conventional with the equation $y'(x) = F(y(x),x)$.
""")

# ╔═╡ 76eab3b2-793c-11ec-2f68-0dab067a7cff
md"""The plots are also useful for illustrating solutions for different initial conditions:
"""

# ╔═╡ 76eab856-793c-11ec-242c-c9fa28f6f71f
let
	p = plot(legend=false)
	x0, y0 = 1, 1
	
	vectorfieldplot!((x,y) -> [1,F(y,x)], xlims=(x0, 2), ylims=(y0-5, y0+5))
	for y0 in -4:4
	  f(x) =  y0*exp(-x0^2/2) * exp(x^2/2)
	  plot!(f, x0, 2, linewidth=5)
	end
	p
end

# ╔═╡ 76eab87c-793c-11ec-1a95-1559f4ff3529
md"""Such solutions are called [integral curves](https://en.wikipedia.org/wiki/Integral_curve). These graphs illustrate the fact that the slope field is tangent to the graph of any integral curve.
"""

# ╔═╡ 76eab892-793c-11ec-07b3-55eb5182663d
md"""## Questions
"""

# ╔═╡ 76eab8b0-793c-11ec-062c-9b9faf97727c
md"""##### Question
"""

# ╔═╡ 76eab8ce-793c-11ec-30ae-1bf36d662dd7
md"""Using `SymPy` to solve the differential equation
"""

# ╔═╡ 76eab8ee-793c-11ec-28e4-3d6b58670799
md"""```math
u' = \frac{1-x}{u}
```
"""

# ╔═╡ 76eab900-793c-11ec-2646-e7ef9abc1f0c
md"""gives
"""

# ╔═╡ 76eabcde-793c-11ec-233e-dd5647833571
let
	@syms x u()
	dsolve(D(u)(x) - (1-x)/u(x))
end

# ╔═╡ 76eabd10-793c-11ec-0445-8b0981769f8c
md"""The two answers track positive and negative solutions. For the initial condition, $u(-1)=1$, we have the second one is appropriate: $u(x) = \sqrt{C_1 - x^2 + 2x}$. At $-1$ this gives: $1 = \sqrt{C_1-3}$, so $C_1 = 4$.
"""

# ╔═╡ 76eabd2e-793c-11ec-0e2e-ab027a515404
md"""This value is good for what values of $x$?
"""

# ╔═╡ 76eac54e-793c-11ec-0988-e1975dcf1d7d
let
	choices = [
	"``[-1, \\infty)``",
	"``[-1, 4]``",
	"``[-1, 0]``",
	"``[1-\\sqrt{5}, 1 + \\sqrt{5}]``"]
	ans = 4
	radioq(choices, ans)
end

# ╔═╡ 76eac576-793c-11ec-39fc-a5aa14945279
md"""##### Question
"""

# ╔═╡ 76eac596-793c-11ec-142e-d92d20596722
md"""Suppose $y(x)$ satisfies
"""

# ╔═╡ 76eac5a8-793c-11ec-0c33-77cfcb632f54
md"""```math
y'(x) = y(x)^2, \quad y(1) = 1.
```
"""

# ╔═╡ 76eac5bc-793c-11ec-0ecd-5547a3a14d6c
md"""What is $y(3/2)$?
"""

# ╔═╡ 76eac986-793c-11ec-2bd1-1f3274268f1d
let
	@syms x u()
	out = dsolve(D(u)(x) - u(x)^2, u(x), ics=Dict(u(1) => 1))
	val = N(rhs(out(3/2)))
	numericq(val)
end

# ╔═╡ 76eac99c-793c-11ec-17bf-d56637386430
md"""##### Question
"""

# ╔═╡ 76eac9ae-793c-11ec-3f93-25c11ea49631
md"""Solve the initial value problem
"""

# ╔═╡ 76eac9c2-793c-11ec-366a-eb50a73a8eda
md"""```math
y' = 1 + x^2 + y(x)^2 + x^2 y(x)^2, \quad y(0) = 1.
```
"""

# ╔═╡ 76eac9d6-793c-11ec-37a3-69d6c07187d0
md"""Use your answer to find $y(1)$.
"""

# ╔═╡ 76ebd100-793c-11ec-2b56-efb6c29b823f
let
	eqn = D(u)(x) - (1 + x^2 + u(x)^2 + x^2 * u(x)^2)
	out = dsolve(eqn, u(x), ics=Dict(u(0) => 1))
	val = N(rhs(out)(1).evalf())
	numericq(val)
end

# ╔═╡ 76ebd164-793c-11ec-19f5-ff9edac85a8d
md"""##### Question
"""

# ╔═╡ 76ebd1b4-793c-11ec-2bff-d558adfc6fe1
md"""A population is modeled by $y(x)$. The rate of population growth is generally proportional to the population ($k y(x)$), but as the population gets large, the rate is curtailed $(1 - y(x)/M)$.
"""

# ╔═╡ 76ebd1c8-793c-11ec-3f71-c59a7b6e24dc
md"""Solve the initial value problem
"""

# ╔═╡ 76ebd1dc-793c-11ec-3bd8-df29d6c4ece9
md"""```math
y'(x) = k\cdot y(x) \cdot (1 - \frac{y(x)}{M}),
```
"""

# ╔═╡ 76ebd204-793c-11ec-09e1-b722dc705388
md"""when $k=1$, $M=100$, and $y(0) = 20$. Find the value of $y(5)$.
"""

# ╔═╡ 76ebd7f4-793c-11ec-0e01-75c6d2c88998
let
	k, M = 1, 100
	eqn = D(u)(x) - k * u(x) * (1 - u(x)/M)
	out = dsolve(eqn, u(x), ics=Dict(u(0) => 20))
	val = N(rhs(out)(5))
	numericq(val)
end

# ╔═╡ 76ebd81c-793c-11ec-0b41-895157d2e466
md"""##### Question
"""

# ╔═╡ 76ebd82e-793c-11ec-03f1-cfd97f25d210
md"""Solve the initial value problem
"""

# ╔═╡ 76ebd844-793c-11ec-27ae-cb7839c94996
md"""```math
y'(t) = \sin(t) - \frac{y(t)}{t}, \quad y(\pi) = 1
```
"""

# ╔═╡ 76ebd860-793c-11ec-133f-eb42e4cb271a
md"""Find the value of the solution at $t=2\pi$.
"""

# ╔═╡ 76ebde34-793c-11ec-0e2c-e9c83582387b
let
	eqn = D(u)(x) - (sin(x) - u(x)/x)
	out = dsolve(eqn, u(x), ics=Dict(u(PI) => 1))
	val = N(rhs(out(2PI)))
	numericq(val)
end

# ╔═╡ 76ebde52-793c-11ec-372a-9dea020bc521
md"""##### Question
"""

# ╔═╡ 76ebde72-793c-11ec-28a0-79b97d3ba7c6
md"""Suppose $u(x)$ satisfies:
"""

# ╔═╡ 76ebde84-793c-11ec-2d00-7ff740d3702b
md"""```math
\frac{du}{dx} = e^{-x} \cdot u(x), \quad u(0) = 1.
```
"""

# ╔═╡ 76ebdea4-793c-11ec-2d11-fff3967fed1b
md"""Find $u(5)$ using `SymPy`.
"""

# ╔═╡ 76ebe412-793c-11ec-0dd9-8f55de75a583
let
	eqn = D(u)(x) - exp(-x)*u(x)
	out = dsolve(eqn, u(x), ics=Dict(u(0) => 1))
	val = N(rhs(out)(5))
	numericq(val)
end

# ╔═╡ 76ebe424-793c-11ec-2088-95c816c74948
md"""##### Question
"""

# ╔═╡ 76ebe438-793c-11ec-37d1-3beb545934f7
md"""The differential equation with boundary values
"""

# ╔═╡ 76ebe44c-793c-11ec-03d6-c94f0ec82145
md"""```math
\frac{r^2 \frac{dc}{dr}}{dr} = 0, \quad c(1)=2, c(10)=1,
```
"""

# ╔═╡ 76ebe472-793c-11ec-3e8f-3fcfea5cc217
md"""can be solved with `SymPy`. What is the value of $c(5)$?
"""

# ╔═╡ 76ebe866-793c-11ec-1635-cd5418def530
let
	@syms x u()
	eqn = diff(x^2*D(u)(x), x)
	out = dsolve(eqn, u(x), ics=Dict(u(1)=>2, u(10) => 1)) |> rhs
	out(5)  # 10/9
	choices = ["``10/9``", "``3/2``", "``9/10``", "``8/9``"]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 76ebe87c-793c-11ec-224c-f1a67426352c
md"""##### Question
"""

# ╔═╡ 76ebe8aa-793c-11ec-14b5-5bac5c8d50c6
md"""The example with projectile motion in a medium has a parameter $\gamma$ modeling the effect of air resistance. If `y` is the answer - as would be the case if the example were copy-and-pasted in - what can be said about `limit(y, gamma=>0)`?
"""

# ╔═╡ 76ebf856-793c-11ec-3c39-b1df22e1c7de
let
	choices = [
	"The limit is a quadratic polynomial in `x`, mirroring the first part of that example.",
	"The limit does not exist, but the limit to `oo` gives a quadratic polynomial in `x`, mirroring the first part of that example.",
	"The limit does not exist -- there is a singularity -- as seen by setting `gamma=0`."
	]
	ans = 1
	radioq(choices, ans)
end

# ╔═╡ 76ebf87e-793c-11ec-2420-1dff0033ce64
HTML("""<div class="markdown"><blockquote>
<p><a href="../integrals/surface_area.html">◅ previous</a>  <a href="../ODEs/euler.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/ODEs/odes.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 76ebf894-793c-11ec-084b-65b0cf9dfcd4
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CalculusWithJulia = "a2e0e22d-7d4c-5312-9169-8b992201a882"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
CalculusWithJulia = "~0.0.14"
Plots = "~1.25.6"
PlutoUI = "~0.7.30"
PyPlot = "~2.10.0"
SymPy = "~1.1.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "ffc6588e17bcfcaa79dfa5b4f417025e755f83fc"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "4.0.1"

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
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CalculusWithJulia]]
deps = ["Base64", "Contour", "EllipsisNotation", "ForwardDiff", "HCubature", "IntervalSets", "JSON", "LaTeXStrings", "LinearAlgebra", "Markdown", "Mustache", "Pkg", "PlotUtils", "Random", "RecipesBase", "Reexport", "Requires", "Roots", "SpecialFunctions", "SplitApplyCombine", "Test"]
git-tree-sha1 = "07608d027a73593e867b5c10e4907b86d25959af"
uuid = "a2e0e22d-7d4c-5312-9169-8b992201a882"
version = "0.0.14"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "6e39c91fb4b84dcb870813c91674bdebb9145895"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.5"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "6b6f04f93710c71550ec7e16b650c1b9a612d0b6"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.16.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonEq]]
git-tree-sha1 = "d1beba82ceee6dc0fce8cb6b80bf600bbde66381"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.0"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

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

[[deps.Dictionaries]]
deps = ["Indexing", "Random"]
git-tree-sha1 = "66bde31636301f4d217a161cabe42536fa754ec8"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.17"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "9bc5dac3c8b6706b58ad5ce24cffd9861f07c94f"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.9.0"

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
git-tree-sha1 = "d7ab55febfd0907b285fbf8dc0c73c0825d9d6aa"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.3.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

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
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "4a740db447aae0fbeb3ee730de1afbb14ac798a1"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.63.1"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "aa22e1ee9e722f1da183eb33370df4c1aeb6c2cd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.63.1+0"

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
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

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

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

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

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "22df5b96feef82434b07327e2d3c770a9b21e023"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.0"

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
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

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

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "21d7a05c3b94bcf45af67beccab4f2a1f4a3c30a"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.12"

[[deps.NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

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
git-tree-sha1 = "92f91ba9e5941fc781fecf5494ac1da87bdac775"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.0"

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
git-tree-sha1 = "68604313ed59f0408313228ba09e79252e4b2da8"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.1.2"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "db7393a80d0e5bef70f2b518990835541917a544"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.25.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5c0eb9099596090bb3215260ceca687b888a1575"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.30"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "71fd4022ecd0c6d20180e23ff1b3e05a143959c2"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.0"

[[deps.PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

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
git-tree-sha1 = "37c1631cb3cc36a535105e6d5557864c82cd8c2b"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.0"

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
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "0abe7fc220977da88ad86d339335a4517944fea2"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.3.14"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "0afd9e6c623e379f593da01f20590bacc26d1d14"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.1"

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

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "35efd62f6f8d9142052d9c7a84e35cd1f9d2db29"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "b4912cd034cdf968e06ca5f943bb54b17b97793a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.5.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2ae4fe21e97cd13efd857462c1869b73c9f61be3"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.3.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "d88665adc9bcf45903013af0982e2fd05ae3d0a6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "51383f2d367eb3b444c961d485c565e4c0cf4ba0"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.14"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "d21f2c564b21a202f4677c0fba5b5ee431058544"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.4"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "PyCall", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "571bf3b61bcd270c33e22e2e459e9049866a2d1f"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "1.1.3"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

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

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

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
# ╟─76ebf860-793c-11ec-04e3-8902609bd448
# ╟─76d8ca1a-793c-11ec-1ebc-1d346c8cda95
# ╟─76d8ca88-793c-11ec-2092-ff2f004b2bef
# ╠═76d90728-793c-11ec-02e4-218df8d51b08
# ╟─76d90c1e-793c-11ec-14c3-eb081f26009a
# ╟─76d90ca0-793c-11ec-38ef-17af41684647
# ╟─76d90cc8-793c-11ec-31ba-21f28d1c88e9
# ╟─76e41ca8-793c-11ec-3664-9f58f41cb996
# ╟─76e41e06-793c-11ec-0ff0-5354448854a5
# ╟─76e41e30-793c-11ec-3caf-d1e769daab5b
# ╟─76e41e42-793c-11ec-2110-75bbb9c3ffae
# ╟─76e41e6a-793c-11ec-2bb2-21d27d0a21ce
# ╟─76e41e74-793c-11ec-39e0-3dd27a89319c
# ╟─76e41ed8-793c-11ec-2c90-e98756d27eb2
# ╟─76e41eec-793c-11ec-1dbd-c3dfaa63a88b
# ╟─76e41f00-793c-11ec-2f08-7d7bfe697ced
# ╟─76e41f0a-793c-11ec-2ae2-978532ddbcd1
# ╟─76e41f14-793c-11ec-3a21-9bb2e899af97
# ╟─76e41f28-793c-11ec-136c-dd16c4e1e246
# ╟─76e41fa0-793c-11ec-010f-318ce375b8f7
# ╟─76e41ff8-793c-11ec-2c50-dd1b646c430d
# ╟─76e42018-793c-11ec-3b06-1709793711f5
# ╟─76e42022-793c-11ec-2eb3-2faf0c544121
# ╟─76e7a7ba-793c-11ec-25b9-4987f597017b
# ╟─76e7a800-793c-11ec-1f08-0d8604ef67b1
# ╟─76e7a814-793c-11ec-3d97-0dbf39f0d61b
# ╟─76e7a832-793c-11ec-1084-17b65735c1f0
# ╟─76e7a83c-793c-11ec-3354-3b63b301471d
# ╟─76e7a85a-793c-11ec-1ab6-7f7e738244f5
# ╟─76e7a864-793c-11ec-0580-972b43f8a931
# ╟─76e7a87a-793c-11ec-27d5-f71a3a7c2db3
# ╟─76e7a896-793c-11ec-17c6-753bb1320486
# ╟─76e7a8be-793c-11ec-317d-e9fd6aa0804e
# ╟─76e7a8d2-793c-11ec-3c21-81035d370db5
# ╟─76e7a918-793c-11ec-0052-0d419c996b25
# ╟─76e7a92c-793c-11ec-0f03-e96f8db91aed
# ╟─76e7a94a-793c-11ec-2284-1d29739ea00b
# ╟─76e7aa1c-793c-11ec-220d-ed58c644a49d
# ╟─76e7aa30-793c-11ec-3747-2bce513434ee
# ╟─76e7aabc-793c-11ec-2d13-c394d639b6fc
# ╟─76e7aad0-793c-11ec-2ab1-c9b07baeb5ed
# ╟─76e7aaee-793c-11ec-0825-633b45bedc68
# ╟─76e7ab20-793c-11ec-3e2c-29c56c0175d2
# ╟─76e7ab3e-793c-11ec-1c29-d90d9ceaaa72
# ╟─76e7ab5c-793c-11ec-3f72-ad9b12cecda8
# ╟─76e7ac1a-793c-11ec-2939-07ddfcaabc16
# ╟─76e7ac80-793c-11ec-1858-29948d3050c4
# ╟─76e7ac9c-793c-11ec-23a6-212a4f2d8795
# ╟─76e7acba-793c-11ec-3624-a579dea402c8
# ╟─76e7acc4-793c-11ec-0011-13c6acfb5d4c
# ╟─76e7ace4-793c-11ec-38e8-a34e324a3e56
# ╟─76e7ad0a-793c-11ec-2b6d-c385569d2962
# ╟─76e7ad32-793c-11ec-3a75-dfad25550038
# ╟─76e7ad64-793c-11ec-3034-379664748fe4
# ╟─76e7ad82-793c-11ec-032a-71bbb8c712c1
# ╟─76e7bc32-793c-11ec-1a77-177a625b0754
# ╟─76e7bc6e-793c-11ec-069b-efad499a1778
# ╟─76e7bc8a-793c-11ec-166e-45a7f2cd5f0e
# ╟─76e7bca0-793c-11ec-10fd-8b71cd7c1511
# ╟─76e7bcd2-793c-11ec-0615-31320c22ad76
# ╟─76e7bcf0-793c-11ec-055b-b164b6f395ea
# ╟─76e7bd04-793c-11ec-1c66-d11c64c8b06d
# ╟─76e7bd4a-793c-11ec-2798-c1f884077091
# ╟─76e7bd72-793c-11ec-3ddc-a93107c4f6dc
# ╟─76e7bd86-793c-11ec-1e13-935626961791
# ╟─76e7bd9a-793c-11ec-3991-2339a2cac4f5
# ╟─76e7bda4-793c-11ec-06d5-79cc824dbf86
# ╟─76e7bdae-793c-11ec-1f80-59e08ce44ffb
# ╟─76e7bdb8-793c-11ec-34bb-d77c41e9de75
# ╟─76e7bdcc-793c-11ec-21d1-9362fcca2793
# ╟─76e7bdd6-793c-11ec-1f42-49c79deac04e
# ╟─76e7bdea-793c-11ec-043d-138db64a5380
# ╟─76e7bdf2-793c-11ec-223d-57f273502f33
# ╟─76e7be1c-793c-11ec-351a-d11d919f40fc
# ╟─76e7be30-793c-11ec-1b21-855e61c76c62
# ╟─76e7be44-793c-11ec-12a4-0bbaa8777685
# ╟─76e7be4e-793c-11ec-1e92-9586f2a7ef52
# ╟─76e7be6c-793c-11ec-3929-a31d53e95f07
# ╟─76e7be80-793c-11ec-147c-1d0c032785a7
# ╟─76e7be8a-793c-11ec-3c0e-2f69dde35757
# ╟─76e7be96-793c-11ec-0cd2-51a2b6fbd48a
# ╟─76e7be9e-793c-11ec-2af0-9554bae6f386
# ╟─76e7bed0-793c-11ec-17d9-0318659d95b4
# ╟─76e7beee-793c-11ec-156a-99db7e5e589c
# ╟─76e7bf0c-793c-11ec-16f5-d3ced40452af
# ╟─76e7bf20-793c-11ec-2dc5-bf39200655bb
# ╟─76e7bf34-793c-11ec-32a8-6db3a5578ff8
# ╟─76e7bf3e-793c-11ec-08a4-31f71fae1e26
# ╟─76e7bf48-793c-11ec-102e-a93ca3f4988b
# ╟─76e7bf5c-793c-11ec-1153-fdb5d29e2cd4
# ╟─76e7bf66-793c-11ec-3a1b-a78b7734bb5d
# ╟─76e7bf70-793c-11ec-336d-8bb2350063df
# ╟─76e7bf7a-793c-11ec-1c2b-2b18bd49704f
# ╟─76e7bf84-793c-11ec-133d-47acb44220fa
# ╟─76e7bf8e-793c-11ec-3fab-b76c49691f56
# ╟─76e7bfa2-793c-11ec-32eb-3920585d149a
# ╟─76e7bfb6-793c-11ec-1bb5-c1459ad37126
# ╟─76e7bfc0-793c-11ec-2f7c-cfaca0616a5a
# ╟─76e7bfd4-793c-11ec-3a67-036d9dfe643b
# ╟─76e7bfde-793c-11ec-12e6-6df1550ba207
# ╟─76e7bfe8-793c-11ec-1369-3f90b0f10085
# ╟─76e8fcb4-793c-11ec-37db-9ba7d1db1aa2
# ╟─76e8fd22-793c-11ec-27e3-0f6ad6b4739b
# ╟─76e8fd4a-793c-11ec-2e16-8fa4290e45f0
# ╟─76e8fd7c-793c-11ec-2e47-af0229e4c99d
# ╟─76e8fd90-793c-11ec-1150-314a9c4d7305
# ╠═76e90466-793c-11ec-06bf-a524994c4f11
# ╟─76e904a2-793c-11ec-34d3-658ceaf58bba
# ╟─76e904c0-793c-11ec-3912-05a7346bfe3d
# ╟─76e90506-793c-11ec-19fd-4f8e1adb463b
# ╠═76e908ee-793c-11ec-025e-cff5fff0867a
# ╟─76e90920-793c-11ec-0cbf-0d3046d9d8cc
# ╠═76e90d8a-793c-11ec-3b28-c5021c333c98
# ╟─76e90dda-793c-11ec-1bc9-fdd0ae8172cc
# ╟─76e90dee-793c-11ec-188c-2ba44bb6c199
# ╠═76e9108c-793c-11ec-26da-8507dcb68d7f
# ╟─76e910be-793c-11ec-3131-3b0fd51f808d
# ╟─76e910d2-793c-11ec-112c-b5df0468a09c
# ╠═76e9179e-793c-11ec-2a28-ed9f7f406661
# ╟─76e917c6-793c-11ec-05a0-df1f9171f1c4
# ╠═76e919a6-793c-11ec-18c4-ede9b7c76299
# ╟─76e919d8-793c-11ec-3adc-bf9b1d3e667d
# ╠═76e91d68-793c-11ec-02e9-61b15911dd57
# ╟─76e91d84-793c-11ec-39cc-fb6b3b9d2b2d
# ╠═76e921f8-793c-11ec-3eaf-9dddd380d073
# ╟─76e92284-793c-11ec-2280-4d1b62765b25
# ╠═76e94f34-793c-11ec-0815-ff1e3b4b17d6
# ╟─76e94f84-793c-11ec-2051-b75d3c43f211
# ╟─76e94fc0-793c-11ec-0df7-5f6df922a2ee
# ╟─76e94ffc-793c-11ec-30c4-6bf83817384d
# ╟─76e9501a-793c-11ec-375b-713006536b41
# ╟─76e9502e-793c-11ec-2e9d-595e8d350357
# ╠═76e95632-793c-11ec-04dd-170d4c827da0
# ╟─76e95650-793c-11ec-0824-bff815f4f610
# ╟─76e95682-793c-11ec-2b89-9177109d58d0
# ╠═76e960c8-793c-11ec-2cb3-057a9c27a3c1
# ╟─76e96184-793c-11ec-3228-93499b9a124a
# ╟─76e961b8-793c-11ec-029d-3d0ef63a1147
# ╟─76e9621c-793c-11ec-0dfa-4d687ab6da7d
# ╟─76e9623a-793c-11ec-0398-15712746f31b
# ╟─76e96262-793c-11ec-3617-ab8899c99437
# ╠═76e969e2-793c-11ec-0951-57a84814f393
# ╟─76e96a14-793c-11ec-01af-f715a65f1c37
# ╟─76e96a66-793c-11ec-277b-790f7f6c0348
# ╟─76e96a98-793c-11ec-2ecc-f334f6bc7f3a
# ╟─76e96aaa-793c-11ec-16d8-1de0af2098c6
# ╟─76e96ad2-793c-11ec-0fd4-d18581383e62
# ╟─76e96af0-793c-11ec-3c97-693cd56603b2
# ╠═76e97266-793c-11ec-31dd-d7f5c3f05b3b
# ╟─76e97284-793c-11ec-31e1-8ba9538c9d12
# ╟─76e972ac-793c-11ec-35f0-6fb759589c45
# ╟─76e972d6-793c-11ec-3b03-033273012f50
# ╟─76e972f2-793c-11ec-02c3-032645bdc22c
# ╟─76e97304-793c-11ec-3011-b71571b8a2ef
# ╟─76e9731a-793c-11ec-124b-c967fb7e496e
# ╟─76e97324-793c-11ec-328d-f170f86b6389
# ╟─76e9732e-793c-11ec-1642-f5c4ce1d3d9f
# ╟─76e97336-793c-11ec-278f-733d4b61ecf7
# ╟─76e9734c-793c-11ec-08fd-5dd2ca741b90
# ╟─76e97356-793c-11ec-2534-2f7a10a63f1a
# ╟─76e97360-793c-11ec-1433-89ee5de60487
# ╟─76e97368-793c-11ec-291a-4df698270efa
# ╟─76e97388-793c-11ec-1399-e7e02446bdbf
# ╠═76e97a86-793c-11ec-1867-5933e0440de7
# ╟─76e97ab8-793c-11ec-1f71-bdc7d3f0b2ec
# ╟─76e97ad6-793c-11ec-342f-27054388519c
# ╠═76e97f86-793c-11ec-398b-dbce5e6c8027
# ╟─76e97f9a-793c-11ec-2f65-f326493c04ba
# ╠═76e98198-793c-11ec-0814-85fe1040da8d
# ╟─76e981ca-793c-11ec-2698-f5aa36e9c308
# ╠═76e98440-793c-11ec-1558-0d0988c83ec5
# ╟─76e9845e-793c-11ec-0c2b-3d0ded4fff9f
# ╠═76e98ab2-793c-11ec-35a7-af1ab6c103ab
# ╟─76e98ad0-793c-11ec-0c7f-f39fdf71ae65
# ╟─76e990cc-793c-11ec-3a46-3b03a00b8993
# ╟─76e990fe-793c-11ec-2293-5704ff3d3081
# ╟─76ea876e-793c-11ec-0320-ed70c78df047
# ╟─76ea87de-793c-11ec-1a1f-39d85d0004b1
# ╟─76ea8818-793c-11ec-11fa-3d25449def7a
# ╟─76ea8836-793c-11ec-2b07-8fe9c7c409fb
# ╟─76ea8854-793c-11ec-2e70-b77671b48f03
# ╟─76ea8868-793c-11ec-16b5-1989205cfc01
# ╟─76ea8886-793c-11ec-23d9-71d79279745f
# ╟─76ea889a-793c-11ec-0b7e-01ff0f3bd367
# ╟─76ea88b8-793c-11ec-00d5-fb47a8fdc015
# ╠═76ea91fa-793c-11ec-3171-b94586743fb5
# ╟─76ea9240-793c-11ec-1d08-37c1db15bb15
# ╟─76ea925e-793c-11ec-2ccc-031679306003
# ╟─76ea927c-793c-11ec-0497-6500ab46ace8
# ╟─76ea9290-793c-11ec-2883-47893133322f
# ╠═76ea99ac-793c-11ec-3964-5382ee5a872e
# ╟─76ea99d4-793c-11ec-15bd-4942ccc2ddd9
# ╟─76ea99e8-793c-11ec-322e-159134b27a22
# ╠═76ea9f9c-793c-11ec-0806-35d2ecb81c4d
# ╟─76ea9fc2-793c-11ec-0265-ad2feac4c6a9
# ╟─76ea9fd8-793c-11ec-10bb-959f41ef7aad
# ╠═76eaa65e-793c-11ec-0c86-4947019048bd
# ╟─76eaa67c-793c-11ec-013c-35f4b7fae5a8
# ╟─76eaa6ae-793c-11ec-114d-d343c3f752ce
# ╟─76eaa6f4-793c-11ec-301e-0fa746a1697b
# ╟─76eaa70a-793c-11ec-1935-b5271452c3e7
# ╠═76eaa97e-793c-11ec-049c-2fcbc6b470d7
# ╟─76eaa9a6-793c-11ec-29c0-a188102f30ad
# ╠═76eaad6e-793c-11ec-1a7e-d75664bc1dbd
# ╟─76eaada2-793c-11ec-3959-f53a5a2d2583
# ╟─76eab39c-793c-11ec-3d7c-03e4c33b5d18
# ╟─76eab3b2-793c-11ec-2f68-0dab067a7cff
# ╠═76eab856-793c-11ec-242c-c9fa28f6f71f
# ╟─76eab87c-793c-11ec-1a95-1559f4ff3529
# ╟─76eab892-793c-11ec-07b3-55eb5182663d
# ╟─76eab8b0-793c-11ec-062c-9b9faf97727c
# ╟─76eab8ce-793c-11ec-30ae-1bf36d662dd7
# ╟─76eab8ee-793c-11ec-28e4-3d6b58670799
# ╟─76eab900-793c-11ec-2646-e7ef9abc1f0c
# ╠═76eabcde-793c-11ec-233e-dd5647833571
# ╟─76eabd10-793c-11ec-0445-8b0981769f8c
# ╟─76eabd2e-793c-11ec-0e2e-ab027a515404
# ╟─76eac54e-793c-11ec-0988-e1975dcf1d7d
# ╟─76eac576-793c-11ec-39fc-a5aa14945279
# ╟─76eac596-793c-11ec-142e-d92d20596722
# ╟─76eac5a8-793c-11ec-0c33-77cfcb632f54
# ╟─76eac5bc-793c-11ec-0ecd-5547a3a14d6c
# ╟─76eac986-793c-11ec-2bd1-1f3274268f1d
# ╟─76eac99c-793c-11ec-17bf-d56637386430
# ╟─76eac9ae-793c-11ec-3f93-25c11ea49631
# ╟─76eac9c2-793c-11ec-366a-eb50a73a8eda
# ╟─76eac9d6-793c-11ec-37a3-69d6c07187d0
# ╟─76ebd100-793c-11ec-2b56-efb6c29b823f
# ╟─76ebd164-793c-11ec-19f5-ff9edac85a8d
# ╟─76ebd1b4-793c-11ec-2bff-d558adfc6fe1
# ╟─76ebd1c8-793c-11ec-3f71-c59a7b6e24dc
# ╟─76ebd1dc-793c-11ec-3bd8-df29d6c4ece9
# ╟─76ebd204-793c-11ec-09e1-b722dc705388
# ╟─76ebd7f4-793c-11ec-0e01-75c6d2c88998
# ╟─76ebd81c-793c-11ec-0b41-895157d2e466
# ╟─76ebd82e-793c-11ec-03f1-cfd97f25d210
# ╟─76ebd844-793c-11ec-27ae-cb7839c94996
# ╟─76ebd860-793c-11ec-133f-eb42e4cb271a
# ╟─76ebde34-793c-11ec-0e2c-e9c83582387b
# ╟─76ebde52-793c-11ec-372a-9dea020bc521
# ╟─76ebde72-793c-11ec-28a0-79b97d3ba7c6
# ╟─76ebde84-793c-11ec-2d00-7ff740d3702b
# ╟─76ebdea4-793c-11ec-2d11-fff3967fed1b
# ╟─76ebe412-793c-11ec-0dd9-8f55de75a583
# ╟─76ebe424-793c-11ec-2088-95c816c74948
# ╟─76ebe438-793c-11ec-37d1-3beb545934f7
# ╟─76ebe44c-793c-11ec-03d6-c94f0ec82145
# ╟─76ebe472-793c-11ec-3e8f-3fcfea5cc217
# ╟─76ebe866-793c-11ec-1635-cd5418def530
# ╟─76ebe87c-793c-11ec-224c-f1a67426352c
# ╟─76ebe8aa-793c-11ec-14b5-5bac5c8d50c6
# ╟─76ebf856-793c-11ec-3c39-b1df22e1c7de
# ╟─76ebf87e-793c-11ec-2420-1dff0033ce64
# ╟─76ebf888-793c-11ec-2187-53af8ace6ee5
# ╟─76ebf894-793c-11ec-084b-65b0cf9dfcd4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
