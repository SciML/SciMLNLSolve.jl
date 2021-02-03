abstract type SciMLNLSolveAlgorithm end

struct JuliaNLsolve <: SciMLNLSolveAlgorithm

end

struct CMINPACK <: SciMLNLSolveAlgorithm
    
end