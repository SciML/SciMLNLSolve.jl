using Pkg
using SafeTestsets
using Test

#@test isempty(detect_ambiguities(SciMLBase))

const GROUP = get(ENV, "GROUP", "All")
const is_APPVEYOR = (Sys.iswindows() && haskey(ENV, "APPVEYOR"))

@time begin
    @time @safetestset "NLsolve.jl Basic" include("nlsolve.jl")
    @time @safetestset "NLsolve.jl Autodiff" include("autodiff.jl")
    @time @safetestset "NLsolve.jl FiniteDiff" include("finite_difference.jl")
end
