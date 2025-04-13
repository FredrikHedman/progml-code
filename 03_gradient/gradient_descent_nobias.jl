using DelimitedFiles
using FStrings
using Statistics: mean

predict(X, w, b) = X * w .+ b

loss(X,Y, w, b) = mean((predict(X, w, b) - Y) .^ 2)

function gradient(X, Y, w)
    dY = predict(X, w, 0) - Y
    w_grad = 2 * mean(X .* dY)
    return w_grad
end

function train(X, Y, iterations, lr)
    w = 0.0
    for ii = 1:iterations
        println(f"Iteration {ii:4d} => Loss: {loss(X,Y,w, 0):.10f}")
        w -= gradient(X, Y, w) * lr
    end
    return w
end


# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

w = train(X, Y, 100, 1E-3)
println(f"w= {w:.10f}")
