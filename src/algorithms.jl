abstract type SciMLNLSolveAlgorithm end

"""
```julia
NLSolveJL(;
          method=:trust_region,
          autodiff=:central,
          store_trace=false,
          extended_trace=false,
          linesearch=LineSearches.Static(),
          linsolve=(x, A, b) -> copyto!(x, A\\b),
          factor = one(Float64),
          autoscale=true,
          m=10,
          beta=one(Float64),
          show_trace=false,
       )
```

### Keyword Arguments

- `method`: the choice of method for solving the nonlinear system.
- `autodiff`: the choice of method for generating the Jacobian. Defaults to `:central` or
  central differencing via FiniteDiff.jl. The other choices are `:forward`
- `show_trace`: should a trace of the optimization algorithm's state be shown on STDOUT?
  Default: false.
- `extended_trace`: should additifonal algorithm internals be added to the state trace?
  Default: false.
- `linesearch`: the line search method to be used within the solver method. The choices
  are line search types from
  [LineSearches.jl](https://github.com/JuliaNLSolvers/LineSearches.jl). Defaults to
  `LineSearches.Static()`.
- `linsolve`: a function `linsolve(x, A, b)` that solves `Ax = b`. Defaults to using Julia's
  `\\`.
- `factor``: determines the size of the initial trust region. This size is set to the
  product of factor and the euclidean norm of `u0` if nonzero, or else to factor itself.
  Default: 1.0.
- `autoscale`: if true, then the variables will be automatically rescaled. The scaling
  factors are the norms of the Jacobian columns. Default: true.
- `m`: the amount of history in the Anderson method. Naive "Picard"-style iteration can be
  achieved by setting m=0, but that isn't advisable for contractions whose Lipschitz
  constants are close to 1. If convergence fails, though, you may consider lowering it.
- `beta`: It is also known as DIIS or Pulay mixing, this method is based on the acceleration
  of the fixed-point iteration xₙ₊₁ = xₙ + beta*f(xₙ), where by default beta=1.
- `store_trace``: should a trace of the optimization algorithm's state be stored? Default:
  false.

### Submethod Choice

Choices for methods in `NLSolveJL`:

- `:fixedpoint`: Fixed-point iteration
- `:anderson`: Anderson-accelerated fixed-point iteration
- `:newton`: Classical Newton method with an optional line search
- `:trust_region`: Trust region Newton method (the default choice)

For more information on these arguments, consult the
[NLsolve.jl documentation](https://github.com/JuliaNLSolvers/NLsolve.jl).
"""
struct NLSolveJL{LSH, LS} <: SciMLNLSolveAlgorithm
    # Refer for tuning parameter choices: https://github.com/JuliaNLSolvers/NLsolve.jl#automatic-differentiation
    method::Symbol
    autodiff::Symbol
    store_trace::Bool
    extended_trace::Bool
    linesearch::LSH
    linsolve::LS
    factor::Real
    autoscale::Bool
    m::Integer
    beta::Real
    show_trace::Bool
    # aa_start::Integer
    # droptol::Real
end

function NLSolveJL(;
                   method = :trust_region,
                   autodiff = :central,
                   store_trace = false,
                   extended_trace = false,
                   linesearch = LineSearches.Static(),
                   linsolve = (x, A, b) -> copyto!(x, A \ b),
                   factor = one(Float64),
                   autoscale = true,
                   m = 10,
                   beta = one(Float64),
                   show_trace = false)
    NLSolveJL{typeof(linesearch), typeof(linsolve)}(method, autodiff, store_trace,
                                                    extended_trace, linesearch, linsolve,
                                                    factor, autoscale, m, beta, show_trace)
end
