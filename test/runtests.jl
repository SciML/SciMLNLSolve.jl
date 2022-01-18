using Pkg
using SafeTestsets
using Test

#@test isempty(detect_ambiguities(SciMLBase))

const GROUP = get(ENV, "GROUP", "All")
const is_APPVEYOR = ( Sys.iswindows() && haskey(ENV,"APPVEYOR") )

@time begin
@time @safetestset "NLsolve.jl" begin include("nlsolve.jl") end
@time @safetestset "NLsolve.jl" begin include("autodiff.jl") end
@time @safetestset "NLsolve.jl" begin include("finite_difference.jl") end
end
