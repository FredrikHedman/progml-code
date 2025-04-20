using DelimitedFiles
using FStrings
using Statistics: mean

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
        println(f"Iteration {ii:4d} => Loss: {loss(X, Y, w):.10f}")
        dw = gradient(X, Y, w)
        w -= lr*dw
    end
    return w
end

# Import the dataset
data = readdlm("pizza_3_vars.txt", skipstart=1)
X = hcat(ones(size(data,1)), data[:, 1:3])
Y = data[:, 4]
w = train(X, Y, iterations=100000, lr=1E-3)

println("Weights: ", w)
println("A few predictions:")
pdct = predict(X, w)
for i = 1:5
     println(f"X[{i}] -> {pdct[i]:.4f} (label: {Y[i]:d})")
 end
 println("DONE")
