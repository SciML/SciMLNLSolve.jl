abstract type SciMLNLSolveAlgorithm end

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
struct CMINPACK <: SciMLNLSolveAlgorithm end
