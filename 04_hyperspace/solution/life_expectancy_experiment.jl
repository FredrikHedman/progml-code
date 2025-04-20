using FStrings
using Statistics: mean
using StructArrays

include("parse_file.jl")

predict(X, w) = X * w

loss(X,Y, w) = mean((predict(X, w) - Y) .^ 2)

function gradient(X, Y, w)
    dY = (predict(X, w) - Y)./size(X, 1)
    w_grad = 2 * X' * dY
    return w_grad
end

function train(X, Y; iterations, lr)
    w = zeros(size(X, 2))
    for ii = 0:iterations-1
        # println(f"Iteration {ii:4d} => Loss: {loss(X, Y, w):.10f}")
        dw = gradient(X, Y, w)
        w -= lr*dw
    end
    return w
end

sa = read_file("../../data/life-expectancy/life-expectancy.txt")

X = hcat(ones(length(sa)), sa.Pollution, sa.Healthcare, sa.Water)
Y = sa.Life
w = train(X, Y, iterations=1000*1000, lr=1E-4)

println("Weights: ", w)
println("A few predictions:")
pdct = predict(X, w)
for i = 1:length(sa)
     println(f"{sa.Country[i]} X[{i:d}] -> {pdct[i]:.1f} (label: {Y[i]:.1f}) (diff: {Y[i]-pdct[i]:.2f})")
 end

wlsq = X \ Y
plsq = predict(X, wlsq)
for i = 1:length(sa)
     println(f"{sa.Country[i]} X[{i:d}] -> {plsq[i]:.1f} (label: {Y[i]:.1f}) (diff: {plsq[i]-pdct[i]:.2f})")
 end

println("DONE")
