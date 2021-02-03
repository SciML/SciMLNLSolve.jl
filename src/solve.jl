function SciMLBase.solve(
    prob::Union{SciMLBase.AbstractSteadyStateProblem{uType,isinplace},SciMLBase.AbstractNonlinearProblem{uType,isinplace}},
    alg::algType,
    timeseries=[],
    ts=[],
    ks=[],
    recompile::Type{Val{recompile_flag}}=Val{true};
    kwargs...,
) where {algType <: SciMLNLSolveAlgorithm,recompile_flag,uType,isinplace}

    if typeof(prob.u0) <: Number
        u0 = [prob.u0]
    else
        u0 = deepcopy(prob.u0)
    end

    sizeu = size(prob.u0)
    p = prob.p

    ### Fix the more general function to Sundials allowed style
    if typeof(prob.f) <: ODEFunction
        t = Inf
        if !isinplace && typeof(prob.u0) <: Number
            f! = (du, u) -> (du .= prob.f(first(u), p, t); Cint(0))
        elseif !isinplace && typeof(prob.u0) <: Vector{Float64}
            f! = (du, u) -> (du .= prob.f(u, p, t); Cint(0))
        elseif !isinplace && typeof(prob.u0) <: AbstractArray
            f! = (du, u) -> (du .= vec(prob.f(reshape(u, sizeu), p, t)); Cint(0))
        elseif typeof(prob.u0) <: Vector{Float64}
            f! = (du, u) -> prob.f(du, u, p, t)
        else # Then it's an in-place function on an abstract array
            f! = (du, u) -> (prob.f(reshape(du, sizeu), reshape(u, sizeu), p, t);
            du = vec(du);
            0)
        end
    elseif typeof(prob.f) <: NonlinearFunction
        if !isinplace && typeof(prob.u0) <: Number
            f! = (du, u) -> (du .= prob.f(first(u), p); Cint(0))
        elseif !isinplace && typeof(prob.u0) <: Vector{Float64}
            f! = (du, u) -> (du .= prob.f(u, p); Cint(0))
        elseif !isinplace && typeof(prob.u0) <: AbstractArray
            f! = (du, u) -> (du .= vec(prob.f(reshape(u, sizeu), p)); Cint(0))
        elseif typeof(prob.u0) <: Vector{Float64}
            f! = (du, u) -> prob.f(du, u, p)
        else # Then it's an in-place function on an abstract array
            f! = (du, u) -> (prob.f(reshape(du, sizeu), reshape(u, sizeu), p);
            du = vec(du);
            0)
        end
    end
    u = zero(u0)
    resid = similar(u)

    if typeof(alg) <: JuliaNLsolve
        u = nlsolve(f!, u0).zero
    end
    f!(resid, u)
    SciMLBase.build_solution(prob, alg, u, resid;retcode=:Success)
end