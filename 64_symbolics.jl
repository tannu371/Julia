### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 36f3c464-c184-11ec-344e-070bcb1b4207
using PlutoUI

# ╔═╡ 36f3c432-c184-11ec-22e5-d36163ed4064
HTML("""
<div class="admonition info">
<a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
""")


# ╔═╡ 36f30ff6-c184-11ec-1795-25b9ea3f355a
md"""# Symbolics.jl
"""

# ╔═╡ 36f3105a-c184-11ec-010b-8bfb41e2f488
md"""The `Symbolics.jl` package is a Computer Algebra System (CAS) built entirely in `Julia`. This package is under heavy development.
"""

# ╔═╡ 36f31078-c184-11ec-20e2-cd30beb0d33f
md"""## Algebraic manipulations
"""

# ╔═╡ 36f310a0-c184-11ec-3f55-9d0a0a7a1e00
md"""### construction
"""

# ╔═╡ 36f310aa-c184-11ec-0429-b996db7b7692
md"""@variables
"""

# ╔═╡ 36f310be-c184-11ec-07d8-6b812866bb44
md"""SymbolicUtils.@syms  assumptions
"""

# ╔═╡ 36f310dc-c184-11ec-3099-51eddc32da6b
md"""x is a `Num`, `Symbolics.value(x)` is of type `SymbolicUtils{Real, Nothing}
"""

# ╔═╡ 36f310e6-c184-11ec-0f32-ed641592b6dd
md"""relation to SymbolicUtils Num wraps things; Term
"""

# ╔═╡ 36f310f0-c184-11ec-028e-437f0c306994
md"""### Substitute
"""

# ╔═╡ 36f310f8-c184-11ec-3902-4d362ff0b889
md"""### Simplify
"""

# ╔═╡ 36f31104-c184-11ec-2ffc-058922ac648c
md"""simplify expand
"""

# ╔═╡ 36f3110e-c184-11ec-2f5d-5f10b962476b
md"""rewrite rules
"""

# ╔═╡ 36f31122-c184-11ec-051b-7b762c3515ec
md"""### Solving equations
"""

# ╔═╡ 36f3112c-c184-11ec-3b73-415906d20678
md"""solve_for
"""

# ╔═╡ 36f31140-c184-11ec-2dec-653b6912129d
md"""## Expressions to functions
"""

# ╔═╡ 36f3114a-c184-11ec-266e-796e05200866
md"""build_function
"""

# ╔═╡ 36f31154-c184-11ec-29d2-4dec22054e62
md"""## Derivatives
"""

# ╔═╡ 36f3116a-c184-11ec-3266-f3c27ea8ffb8
md"""1->1: Symbolics.derivative(x^2 + cos(x), x)
"""

# ╔═╡ 36f31172-c184-11ec-3593-6f0e2f3229db
md"""1->3: Symbolics.derivative.([x^2, x, cos(x)], x)
"""

# ╔═╡ 36f3117c-c184-11ec-068e-ffc72902d532
md"""3 -> 1: Symbolics.gradient(x*y^z, [x,y,z])
"""

# ╔═╡ 36f31186-c184-11ec-1a33-19cb8992ed6f
md"""2 -> 2: Symbolics.jacobian([x,y^z], [x,y])
"""

# ╔═╡ 36f311a4-c184-11ec-3f73-05100a865dda
md"""# higher order
"""

# ╔═╡ 36f311ae-c184-11ec-2c57-cb718f88a204
md"""1 -> 1: D(ex, x, n=1) = foldl((ex,_) -> Symbolics.derivative(ex, x), 1:n, init=ex)
"""

# ╔═╡ 36f311c2-c184-11ec-0600-9fea860cd62b
md"""2 -> 1: (2nd) Hessian
"""

# ╔═╡ 36f311ce-c184-11ec-1cbb-4bc9fbc14598
md"""## Differential equations
"""

# ╔═╡ 36f311e0-c184-11ec-0254-095d9c5194d9
md"""## Integrals
"""

# ╔═╡ 36f311ea-c184-11ec-1531-69ea82e8e5ce
md"""WIP
"""

# ╔═╡ 36f31208-c184-11ec-133d-c10459b9abb2
md"""## ––
"""

# ╔═╡ 36f31212-c184-11ec-3214-2f502d5f53af
md"""# follow sympy tutorial
"""

# ╔═╡ 36f31226-c184-11ec-0307-07855c31d037
md"""using Symbolics import SymbolicUtils
"""

# ╔═╡ 36f3122e-c184-11ec-1f99-3de2242e2a22
md"""@variables x y z
"""

# ╔═╡ 36f31244-c184-11ec-3751-5bffe142c166
md"""# substitution
"""

# ╔═╡ 36f3124e-c184-11ec-25bc-257b7a162bb8
md"""ex = cos(x) + 1 substitute(ex, Dict(x=>y))
"""

# ╔═╡ 36f31258-c184-11ec-2322-593ed27d86ec
md"""substitute(ex, Dict(x=>0)) # does eval
"""

# ╔═╡ 36f31262-c184-11ec-2a4e-7baefaa03d36
md"""ex = x^y substitute(ex, Dict(y=> x^y))
"""

# ╔═╡ 36f3126c-c184-11ec-025b-b9255dae15f8
md"""# expand trig
"""

# ╔═╡ 36f31276-c184-11ec-0377-6dd3eac0973b
md"""r1 = @rule sin(2 * ~x) => 2sin(~x)*cos(~x) r2 = @rule cos(2 * ~x) => cos(~x)^2 - sin(~x)^2 expand_trig(ex) = simplify(ex, RuleSet([r1, r2]))
"""

# ╔═╡ 36f3128a-c184-11ec-322c-49a01e82d31b
md"""ex = sin(2x) + cos(2x) expand_trig(ex)
"""

# ╔═╡ 36f31294-c184-11ec-321d-fb4869377d6c
md"""## Multiple
"""

# ╔═╡ 36f3129e-c184-11ec-354e-c9f67b9a3c7c
md"""@variables x y z ex = x^3 + 4x*y -z substitute(ex, Dict(x=>2, y=>4, z=>0))
"""

# ╔═╡ 36f312a8-c184-11ec-26e1-1d40255b546b
md"""# Converting Strings to Expressions
"""

# ╔═╡ 36f312bc-c184-11ec-2147-6bdb67c12c0b
md"""# what is sympify?
"""

# ╔═╡ 36f312c6-c184-11ec-28fe-6f19d05217d2
md"""# evalf
"""

# ╔═╡ 36f312da-c184-11ec-103b-b7dd39b4e8d1
md"""# lambdify: symbolic expression -> function
"""

# ╔═╡ 36f312e4-c184-11ec-1a98-4bf29a157786
md"""ex = x^3 + 4x*y -z λ = build_function(ex, x,y,z, expression=Val(false)) λ(2,4,0)
"""

# ╔═╡ 36f312ee-c184-11ec-3a29-f353237c4304
md"""# pretty printing
"""

# ╔═╡ 36f31304-c184-11ec-0f71-277f765f5e47
md"""using Latexify latexify(ex)
"""

# ╔═╡ 36f31316-c184-11ec-35a0-1920b0912d0b
md"""# Simplify
"""

# ╔═╡ 36f3132a-c184-11ec-1553-13c41b04adbc
md"""@variables x y z t
"""

# ╔═╡ 36f31332-c184-11ec-1dc0-73ca005ceedd
md"""simplify(sin(x)^2 + cos(x)^2)
"""

# ╔═╡ 36f31348-c184-11ec-3a8e-3194336e58a8
md"""simplify((x^3 + x^2 - x - 1) / (x^2 + 2x + 1)) # fails, no factor simplify(((x+1)*(x^2-1))/((x+1)^2))            # works
"""

# ╔═╡ 36f31352-c184-11ec-21b1-e782f98d2ba1
md"""import SpecialFunctions: gamma
"""

# ╔═╡ 36f31364-c184-11ec-1a2a-87f71c1daccb
md"""simplify(gamma(x) / gamma(x-2))                # fails
"""

# ╔═╡ 36f31370-c184-11ec-12e9-45a5717f531c
md"""# Polynomial
"""

# ╔═╡ 36f31384-c184-11ec-3b82-93477e77d647
md"""## expand
"""

# ╔═╡ 36f313ac-c184-11ec-1bae-53071191067f
md"""expand((x+1)^2) expand((x+2)*(x-3)) expand((x+1)*(x-2) - (x-1)*x)
"""

# ╔═╡ 36f313c0-c184-11ec-124f-3b8ce6f83cc4
md"""## factor
"""

# ╔═╡ 36f313ca-c184-11ec-08b2-51ce1c8d8bae
md"""### not defined
"""

# ╔═╡ 36f313de-c184-11ec-1461-75fa82ce1935
md"""## collect
"""

# ╔═╡ 36f313f2-c184-11ec-0523-c59490fefcba
md"""COLLECT_RULES = [     @rule(~x*x^(~n::SymbolicUtils.isnonnegint) => (~x, ~n))     @rule(~x * x => (~x, 1)) ] function _collect(ex, x)     d = Dict()
"""

# ╔═╡ 36f33116-c184-11ec-3a1a-31ca26c870a9
begin
	exs = expand(ex)
	if SymbolicUtils.operation(Symbolics.value(ex)) != +
	    d[0] => ex
	else
	    for aᵢ ∈ SymbolicUtils.arguments(Symbolics.value(expand(ex)))
	        u = simplify(aᵢ, RuleSet(COLLECT_RULES))
	        if isa(u, Tuple)
	            a,n = u
	        else
	            a,n = u,0
	        end
	        d[n] = get(d, n, 0) + a
	    end
	end
	d
end

# ╔═╡ 36f33148-c184-11ec-119b-2d188ef7e0de
md"""end
"""

# ╔═╡ 36f33170-c184-11ec-15cd-1971d79d253a
md"""## cancel – no factor
"""

# ╔═╡ 36f33184-c184-11ec-1731-d555acac7372
md"""## apart – no factor
"""

# ╔═╡ 36f33198-c184-11ec-1885-07e75bf87314
md"""## Trignometric simplification
"""

# ╔═╡ 36f331ca-c184-11ec-35d7-f3301f6aacd8
md"""INVERSE*TRIG*RUELS = [@rule(cos(acos(~x)) => ~x)                       @rule(acos(cos(~x)) => abs(rem2pi(~x, RoundNearest)))                       @rule(sin(asin(~x)) => ~x)                       @rule(asin(sin(~x)) => abs(rem2pi(x + pi/2, RoundNearest)) - pi/2)                       ]
"""

# ╔═╡ 36f331e8-c184-11ec-1f1b-6fe4c5749faf
md"""@variables θ simplify(cos(acos(θ)), RuleSet(INVERSE*TRIG*RUELS))
"""

# ╔═╡ 36f33206-c184-11ec-2664-3fba1ade1f4e
md"""# Copy from https://github.com/JuliaSymbolics/SymbolicUtils.jl/blob/master/src/simplify_rules.jl
"""

# ╔═╡ 36f3321a-c184-11ec-0c5f-49e0f26a80bf
md"""# the TRIG_RULES are applied by simplify by default
"""

# ╔═╡ 36f33238-c184-11ec-3b6f-ef321c80e0ba
md"""HTRIG_RULES = [                @acrule(-sinh(~x)^2 + cosh(~x)^2 => one(~x))                @acrule(sinh(~x)^2 + 1        => cosh(~x)^2)                @acrule(cosh(~x)^2 + -1        => -sinh(~x)^2)
"""

# ╔═╡ 36f36b22-c184-11ec-0350-8b46b04cf62a
begin
	           @acrule(tanh(~x)^2 + 1*sech(~x)^2 => one(~x))
	           @acrule(-tanh(~x)^2 +  1 => sech(~x)^2)
	           @acrule(sech(~x)^2 + -1 => -tanh(~x)^2)
	
	           @acrule(coth(~x)^2 + -1*csch(~x)^2 => one(~x))
	           @acrule(coth(~x)^2 + -1 => csch(~x)^2)
	           @acrule(csch(~x)^2 +  1 => coth(~x)^2)
	
	@acrule(tanh(~x) => sinh(~x)/cosh(~x))
	
	@acrule(sinh(-~x) => -sinh(~x))
	@acrule(cosh(-~x) => -cosh(~x))
	       ]
end

# ╔═╡ 36f36b54-c184-11ec-155c-8b63355ff442
md"""trigsimp(ex) = simplify(simplify(ex, RuleSet(HTRIG_RULES)))
"""

# ╔═╡ 36f36b68-c184-11ec-0595-8d01746c3cfc
md"""trigsimp(sin(x)^2 + cos(x)^2) trigsimp(sin(x)^4 -2cos(x)^2*sin(x)^2 + cos(x)^4) # no factor trigsimp(cosh(x)^2 + sinh(x)^2) trigsimp(sinh(x)/tanh(x))
"""

# ╔═╡ 36f36b90-c184-11ec-04af-31718c9c4ba5
md"""EXPAND*TRIG*RULES = [
"""

# ╔═╡ 36f38bd6-c184-11ec-1188-57898d0f9ff2
@acrule(sin(~x+~y) => sin(~x)*cos(~y)   + cos(~x)*sin(~y))

# ╔═╡ 36f38c24-c184-11ec-13e1-7d55d2214874
md"""@acrule(sinh(~x+~y) => sinh(~x)*cosh(~y) + cosh(~x)*sinh(~y))
"""

# ╔═╡ 36f394c6-c184-11ec-1b2b-352b569b246f
begin
	    @acrule(sin(2*~x)   => 2sin(~x)*cos(~x))
	@acrule(sinh(2*~x) => 2sinh(~x)*cosh(~x))
end

# ╔═╡ 36f394f8-c184-11ec-2580-c9b07a273fa2
md"""@acrule(cos(~x+~y)  => cos(~x)*cos(~y)   - sin(~x)*sin(~y)) @acrule(cosh(~x+~y) => cosh(~x)*cosh(~y) + sinh(~x)*sinh(~y))
"""

# ╔═╡ 36f39e26-c184-11ec-13ab-19940d35eebe
begin
	    @acrule(cos(2*~x)   => cos(~x)^2 - sin(~x)^2)
	@acrule(cosh(2*~x) => cosh(~x)^2 + sinh(~x)^2)
end

# ╔═╡ 36f39e4e-c184-11ec-3a5c-8f67f2084c2e
md"""@acrule(tan(~x+~y)  => (tan(~x)  - tan(~y))  / (1 + tan(~x)*tan(~y)))     @acrule(tanh(~x+~y) => (tanh(~x) + tanh(~y)) / (1 + tanh(~x)*tanh(~y)))
"""

# ╔═╡ 36f3c176-c184-11ec-0789-193078cff993
begin
	@acrule(tan(2*~x) => 2*tan(~x)/(1 - tan(~x)^2))
	@acrule(tanh(2*~x) => 2*tanh(~x)/(1 + tanh(~x)^2))
end

# ╔═╡ 36f3c1a8-c184-11ec-3d88-e53c7a3d7d5d
md"""]
"""

# ╔═╡ 36f3c1d0-c184-11ec-1611-0bfbf76f702f
md"""expandtrig(ex) = simplify(simplify(ex, RuleSet(EXPAND*TRIG*RULES)))
"""

# ╔═╡ 36f3c1e2-c184-11ec-1ca5-25dfbf42360c
md"""expandtrig(sin(x+y)) expandtrig(tan(2x))
"""

# ╔═╡ 36f3c1f8-c184-11ec-07da-fb199d9350c8
md"""# powers
"""

# ╔═╡ 36f3c20c-c184-11ec-2696-db05b0263e5f
md"""# in genearl x^a*x^b = x^(a+b)
"""

# ╔═╡ 36f3c220-c184-11ec-060f-4dccd43d150d
md"""@variables x y a b simplify(x^a*x^b - x^(a+b)) # 0
"""

# ╔═╡ 36f3c22a-c184-11ec-0e61-55757e4d0be5
md"""# x^a*y^a = (xy)^a When x,y >=0, a ∈ R
"""

# ╔═╡ 36f3c23e-c184-11ec-2864-01d60920c87c
md"""simplify(x^a*y^a - (x*y)^a)
"""

# ╔═╡ 36f3c25c-c184-11ec-07b0-c9ce4608a244
md"""## ??? How to specify such assumptions?
"""

# ╔═╡ 36f3c266-c184-11ec-3adb-75a2c3111d91
md"""# (x^a)^b = x^(ab) only if b ∈ Int
"""

# ╔═╡ 36f3c270-c184-11ec-14d6-fbd9fda0a16d
md"""@syms x a b simplify((x^a)^b - x^(a*b))
"""

# ╔═╡ 36f3c286-c184-11ec-2ab9-cb6235b4bbd8
md"""@syms x a b::Int simplify((x^a)^b - x^(a*b)) # nope
"""

# ╔═╡ 36f3c2a2-c184-11ec-1e2c-99b2852cf340
md"""ispositive(x) = isa(x, Real) && x > 0 *isinteger(x) = isa(x, Integer) _isinteger(x::SymbolicUtils.Sym{T,S}) where {T <: Integer, S} = true POWSIMP*RULES = [ @acrule((~x::ispositive)^(~a::isreal) * (~y::ispositive)^(~a::isreal) => (~x*~y)^~a) @rule(((~x)^(~a))^(~b::*isinteger) => ~x^(~a * ~b)) ] powsimp(ex) = simplify(simplify(ex, RuleSet(POWSIMP*RULES)))
"""

# ╔═╡ 36f3c2b8-c184-11ec-3690-f1d70097ed4f
md"""@syms x a b::Int simplify((x^a)^b - x^(a*b)) # nope
"""

# ╔═╡ 36f3c2ca-c184-11ec-34f3-5795642d6d79
md"""EXPAND*POWER*RULES = [ @rule((~x)^(~a + ~b) => (_~)^(~a) * (~x)^(~b)) @rule((~x*~y)^(~a) => (~x)^(~a) * (~y)^(~a))
"""

# ╔═╡ 36f3c2d4-c184-11ec-257f-a73d6b091551
md"""## ... more on simplification...
"""

# ╔═╡ 36f3c2de-c184-11ec-2163-bb667082f773
md"""## Calculus
"""

# ╔═╡ 36f3c2f2-c184-11ec-2a53-5772409abd31
md"""@variables x y z import Symbolics: derivative derivative(cos(x), x) derivative(exp(x^2), x)
"""

# ╔═╡ 36f3c2fc-c184-11ec-21f1-13c8a1a6affb
md"""# multiple derivative
"""

# ╔═╡ 36f3c306-c184-11ec-35ec-39078259cc29
md"""Symbolics.derivative(ex, x, n::Int) = reduce((ex,_) -> derivative(ex, x), 1:n, init=ex) # helper derivative(x^4, x, 3)
"""

# ╔═╡ 36f3c318-c184-11ec-2986-bbc72b0a6e68
md"""ex = exp(x*y*z)
"""

# ╔═╡ 36f3c324-c184-11ec-3c34-992563bf77a6
md"""using Chain @chain ex begin     derivative(x, 3)     derivative(y, 3)     derivative(z, 3) end
"""

# ╔═╡ 36f3c32e-c184-11ec-2d7d-430e1c94be4b
md"""# using Differential operator
"""

# ╔═╡ 36f3c342-c184-11ec-39b1-9d4647a045f3
md"""expr = exp(x*y*z) expr |> Differential(x)^2 |> Differential(y)^3 |> expand_derivatives
"""

# ╔═╡ 36f3c356-c184-11ec-1f44-0dd4d56b390b
md"""# no integrate
"""

# ╔═╡ 36f3c360-c184-11ec-340a-81366ee45eba
md"""# no limit
"""

# ╔═╡ 36f3c36a-c184-11ec-3388-6fa76a70794f
md"""# Series
"""

# ╔═╡ 36f3c374-c184-11ec-2c82-0d0686dee119
md"""function series(ex, x, x0=0, n=5)     Σ = zero(ex)     for i ∈ 0:n         ex = expand_derivatives((Differential(x))(ex))         Σ += substitute(ex, Dict(x=>0)) * x^i / factorial(i)     end     Σ end
"""

# ╔═╡ 36f3c37e-c184-11ec-2395-8d3ee048fc16
md"""# finite differences
"""

# ╔═╡ 36f3c392-c184-11ec-00c3-fd000538fafd
md"""# Solvers
"""

# ╔═╡ 36f3c39c-c184-11ec-1a37-e3a39df52a0b
md"""@variables  x y z  a eq = x ~ a Symbolics.solve_for(eq, x)
"""

# ╔═╡ 36f3c3a6-c184-11ec-19f3-15b614f907d8
md"""eqs = [x + y + z ~ 1        x + y + 2z ~ 3        x + 2y + 3z ~ 3        ] vars = [x,y,z] xs = Symbolics.solve_for(eqs, vars)
"""

# ╔═╡ 36f3c3b0-c184-11ec-22ba-61c0a2d72aaf
md"""[reduce((ex, r)->substitute(ex, r), Pair.(vars, xs), init=ex.lhs) for ex ∈ eqs] == [eq.rhs for eq ∈ eqs]
"""

# ╔═╡ 36f3c3c4-c184-11ec-2fc9-4378651d9a84
md"""A = [1 1; 1 2] b = [1, 3] xs = Symbolics.solve_for(A*[x,y] .~ b, [x,y]) A*xs - b
"""

# ╔═╡ 36f3c3d8-c184-11ec-15a4-c58d361893ae
md"""A = [1 1 1; 1 1 2] b = [1,3] A*[x,y,z] - b Symbolics.solve_for(A*[x,y,z] .~ b, [x,y,z]) # fails, singular
"""

# ╔═╡ 36f3c3e2-c184-11ec-123a-05eb35f5a74e
md"""# nonlinear solve
"""

# ╔═╡ 36f3c40a-c184-11ec-111e-158faa28f5c3
md"""# use `λ = mk_function(ex, args, expression=Val(false))`
"""

# ╔═╡ 36f3c41c-c184-11ec-29a1-23e36d790384
md"""# polynomial roots
"""

# ╔═╡ 36f3c428-c184-11ec-1790-41d71ff115fa
md"""# differential equations
"""

# ╔═╡ 36f3c464-c184-11ec-2eb1-ed656852a1eb
HTML("""<div class="markdown"><blockquote>
<p><a href="../integral_vector_calculus/review.html">◅ previous</a>  <a href="../misc/getting_started_with_juila.html">▻  next</a>  <a href="../index.html">⌂ table of contents</a>  <a href="https://github.com/jverzani/CalculusWithJulia.jl/edit/master/CwJ/alternatives/symbolics.jmd">✏ suggest an edit</a></p>
</blockquote>
</div>""")

# ╔═╡ 36f3c46e-c184-11ec-1ede-9f890fee6be9
PlutoUI.TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.38"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

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
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

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

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╟─36f3c432-c184-11ec-22e5-d36163ed4064
# ╟─36f30ff6-c184-11ec-1795-25b9ea3f355a
# ╟─36f3105a-c184-11ec-010b-8bfb41e2f488
# ╟─36f31078-c184-11ec-20e2-cd30beb0d33f
# ╟─36f310a0-c184-11ec-3f55-9d0a0a7a1e00
# ╟─36f310aa-c184-11ec-0429-b996db7b7692
# ╟─36f310be-c184-11ec-07d8-6b812866bb44
# ╟─36f310dc-c184-11ec-3099-51eddc32da6b
# ╟─36f310e6-c184-11ec-0f32-ed641592b6dd
# ╟─36f310f0-c184-11ec-028e-437f0c306994
# ╟─36f310f8-c184-11ec-3902-4d362ff0b889
# ╟─36f31104-c184-11ec-2ffc-058922ac648c
# ╟─36f3110e-c184-11ec-2f5d-5f10b962476b
# ╟─36f31122-c184-11ec-051b-7b762c3515ec
# ╟─36f3112c-c184-11ec-3b73-415906d20678
# ╟─36f31140-c184-11ec-2dec-653b6912129d
# ╟─36f3114a-c184-11ec-266e-796e05200866
# ╟─36f31154-c184-11ec-29d2-4dec22054e62
# ╟─36f3116a-c184-11ec-3266-f3c27ea8ffb8
# ╟─36f31172-c184-11ec-3593-6f0e2f3229db
# ╟─36f3117c-c184-11ec-068e-ffc72902d532
# ╟─36f31186-c184-11ec-1a33-19cb8992ed6f
# ╟─36f311a4-c184-11ec-3f73-05100a865dda
# ╟─36f311ae-c184-11ec-2c57-cb718f88a204
# ╟─36f311c2-c184-11ec-0600-9fea860cd62b
# ╟─36f311ce-c184-11ec-1cbb-4bc9fbc14598
# ╟─36f311e0-c184-11ec-0254-095d9c5194d9
# ╟─36f311ea-c184-11ec-1531-69ea82e8e5ce
# ╟─36f31208-c184-11ec-133d-c10459b9abb2
# ╟─36f31212-c184-11ec-3214-2f502d5f53af
# ╟─36f31226-c184-11ec-0307-07855c31d037
# ╟─36f3122e-c184-11ec-1f99-3de2242e2a22
# ╟─36f31244-c184-11ec-3751-5bffe142c166
# ╟─36f3124e-c184-11ec-25bc-257b7a162bb8
# ╟─36f31258-c184-11ec-2322-593ed27d86ec
# ╟─36f31262-c184-11ec-2a4e-7baefaa03d36
# ╟─36f3126c-c184-11ec-025b-b9255dae15f8
# ╟─36f31276-c184-11ec-0377-6dd3eac0973b
# ╟─36f3128a-c184-11ec-322c-49a01e82d31b
# ╟─36f31294-c184-11ec-321d-fb4869377d6c
# ╟─36f3129e-c184-11ec-354e-c9f67b9a3c7c
# ╟─36f312a8-c184-11ec-26e1-1d40255b546b
# ╟─36f312bc-c184-11ec-2147-6bdb67c12c0b
# ╟─36f312c6-c184-11ec-28fe-6f19d05217d2
# ╟─36f312da-c184-11ec-103b-b7dd39b4e8d1
# ╟─36f312e4-c184-11ec-1a98-4bf29a157786
# ╟─36f312ee-c184-11ec-3a29-f353237c4304
# ╟─36f31304-c184-11ec-0f71-277f765f5e47
# ╟─36f31316-c184-11ec-35a0-1920b0912d0b
# ╟─36f3132a-c184-11ec-1553-13c41b04adbc
# ╟─36f31332-c184-11ec-1dc0-73ca005ceedd
# ╟─36f31348-c184-11ec-3a8e-3194336e58a8
# ╟─36f31352-c184-11ec-21b1-e782f98d2ba1
# ╟─36f31364-c184-11ec-1a2a-87f71c1daccb
# ╟─36f31370-c184-11ec-12e9-45a5717f531c
# ╟─36f31384-c184-11ec-3b82-93477e77d647
# ╟─36f313ac-c184-11ec-1bae-53071191067f
# ╟─36f313c0-c184-11ec-124f-3b8ce6f83cc4
# ╟─36f313ca-c184-11ec-08b2-51ce1c8d8bae
# ╟─36f313de-c184-11ec-1461-75fa82ce1935
# ╟─36f313f2-c184-11ec-0523-c59490fefcba
# ╠═36f33116-c184-11ec-3a1a-31ca26c870a9
# ╟─36f33148-c184-11ec-119b-2d188ef7e0de
# ╟─36f33170-c184-11ec-15cd-1971d79d253a
# ╟─36f33184-c184-11ec-1731-d555acac7372
# ╟─36f33198-c184-11ec-1885-07e75bf87314
# ╟─36f331ca-c184-11ec-35d7-f3301f6aacd8
# ╟─36f331e8-c184-11ec-1f1b-6fe4c5749faf
# ╟─36f33206-c184-11ec-2664-3fba1ade1f4e
# ╟─36f3321a-c184-11ec-0c5f-49e0f26a80bf
# ╟─36f33238-c184-11ec-3b6f-ef321c80e0ba
# ╠═36f36b22-c184-11ec-0350-8b46b04cf62a
# ╟─36f36b54-c184-11ec-155c-8b63355ff442
# ╟─36f36b68-c184-11ec-0595-8d01746c3cfc
# ╟─36f36b90-c184-11ec-04af-31718c9c4ba5
# ╠═36f38bd6-c184-11ec-1188-57898d0f9ff2
# ╟─36f38c24-c184-11ec-13e1-7d55d2214874
# ╠═36f394c6-c184-11ec-1b2b-352b569b246f
# ╟─36f394f8-c184-11ec-2580-c9b07a273fa2
# ╠═36f39e26-c184-11ec-13ab-19940d35eebe
# ╟─36f39e4e-c184-11ec-3a5c-8f67f2084c2e
# ╠═36f3c176-c184-11ec-0789-193078cff993
# ╟─36f3c1a8-c184-11ec-3d88-e53c7a3d7d5d
# ╟─36f3c1d0-c184-11ec-1611-0bfbf76f702f
# ╟─36f3c1e2-c184-11ec-1ca5-25dfbf42360c
# ╟─36f3c1f8-c184-11ec-07da-fb199d9350c8
# ╟─36f3c20c-c184-11ec-2696-db05b0263e5f
# ╟─36f3c220-c184-11ec-060f-4dccd43d150d
# ╟─36f3c22a-c184-11ec-0e61-55757e4d0be5
# ╟─36f3c23e-c184-11ec-2864-01d60920c87c
# ╟─36f3c25c-c184-11ec-07b0-c9ce4608a244
# ╟─36f3c266-c184-11ec-3adb-75a2c3111d91
# ╟─36f3c270-c184-11ec-14d6-fbd9fda0a16d
# ╟─36f3c286-c184-11ec-2ab9-cb6235b4bbd8
# ╟─36f3c2a2-c184-11ec-1e2c-99b2852cf340
# ╟─36f3c2b8-c184-11ec-3690-f1d70097ed4f
# ╟─36f3c2ca-c184-11ec-34f3-5795642d6d79
# ╟─36f3c2d4-c184-11ec-257f-a73d6b091551
# ╟─36f3c2de-c184-11ec-2163-bb667082f773
# ╟─36f3c2f2-c184-11ec-2a53-5772409abd31
# ╟─36f3c2fc-c184-11ec-21f1-13c8a1a6affb
# ╟─36f3c306-c184-11ec-35ec-39078259cc29
# ╟─36f3c318-c184-11ec-2986-bbc72b0a6e68
# ╟─36f3c324-c184-11ec-3c34-992563bf77a6
# ╟─36f3c32e-c184-11ec-2d7d-430e1c94be4b
# ╟─36f3c342-c184-11ec-39b1-9d4647a045f3
# ╟─36f3c356-c184-11ec-1f44-0dd4d56b390b
# ╟─36f3c360-c184-11ec-340a-81366ee45eba
# ╟─36f3c36a-c184-11ec-3388-6fa76a70794f
# ╟─36f3c374-c184-11ec-2c82-0d0686dee119
# ╟─36f3c37e-c184-11ec-2395-8d3ee048fc16
# ╟─36f3c392-c184-11ec-00c3-fd000538fafd
# ╟─36f3c39c-c184-11ec-1a37-e3a39df52a0b
# ╟─36f3c3a6-c184-11ec-19f3-15b614f907d8
# ╟─36f3c3b0-c184-11ec-22ba-61c0a2d72aaf
# ╟─36f3c3c4-c184-11ec-2fc9-4378651d9a84
# ╟─36f3c3d8-c184-11ec-15a4-c58d361893ae
# ╟─36f3c3e2-c184-11ec-123a-05eb35f5a74e
# ╟─36f3c40a-c184-11ec-111e-158faa28f5c3
# ╟─36f3c41c-c184-11ec-29a1-23e36d790384
# ╟─36f3c428-c184-11ec-1790-41d71ff115fa
# ╟─36f3c464-c184-11ec-2eb1-ed656852a1eb
# ╟─36f3c464-c184-11ec-344e-070bcb1b4207
# ╟─36f3c46e-c184-11ec-1ede-9f890fee6be9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
