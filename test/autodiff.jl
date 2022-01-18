using SciMLNLSolve, SciMLBase
# Test the autodiff technique
function f!(fvec, x, p)
    fvec[1] = (x[1]+3)*(x[2]^3-7)+18
    fvec[2] = sin(x[2]*exp(x[1])-1)
end

prob = NonlinearProblem{true}(f!,[ 0.1; 1.2])
sol = solve(prob,NLSolveJL(autodiff=:forward))

du = zeros(2)
f!(du, sol.u, nothing)
@test maximum(du) < 1e-6