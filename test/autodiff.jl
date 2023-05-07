using SciMLNLSolve, LinearAlgebra, Test

# Test the autodiff technique
function f!(fvec, x, p)
    fvec[1] = (x[1] + 3) * (x[2]^3 - 7) + 18
    fvec[2] = sin(x[2] * exp(x[1]) - 1)
end

prob = NonlinearProblem{true}(f!, [0.1; 1.2])
sol = solve(prob, NLSolveJL(autodiff = :forward))

du = zeros(2)
f!(du, sol.u, nothing)
@test maximum(du) < 1e-6

function problem(x, A)
    return x .^ 2 - A
end

function problemJacobian(x, A)
    return diagm(2 .* x)
end

function f!(F, u, p)
    F[1:152] = problem(u, p)
end

function j!(J, u, p)
    J[1:152, 1:152] = problemJacobian(u, p)
end

f = NonlinearFunction(f!)

init = ones(152);
A = ones(152);
A[6] = 0.8

f = NonlinearFunction(f!, jac = j!)

p = A

ProbN = NonlinearProblem(f, init, p)
sol = solve(ProbN, NLSolveJL(), reltol = 1e-8, abstol = 1e-8)

init = ones(Complex{Float64},152);
ProbN = NonlinearProblem(f,init,p)
sol = solve(ProbN,NLSolveJL(linesearch = HagerZhang(),method = :newton), reltol = 1e-8,abstol = 1e-8)
