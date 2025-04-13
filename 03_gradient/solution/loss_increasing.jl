using DelimitedFiles
using FStrings
using Statistics: mean

predict(X, w, b) = X * w .+ b

loss(X,Y, w, b) = mean((predict(X, w, b) - Y) .^ 2)

function gradient(X, Y, w, b)
    dY = predict(X, w, b) - Y
    w_grad = 2 * mean(X .* dY)
    b_grad = 2 * mean(dY)
    return w_grad, b_grad
end

function train(X, Y, iterations, lr)
    w = b = 0.0
    for ii = 0:iterations-1
        println(f"Iteration {ii:4d} => Loss: {loss(X,Y, w, b):.10f}")
        dw, db = gradient(X, Y, w, b)
        w -= lr*dw
        b -= lr*db
    end
    return w, b
end


# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

w, b = train(X, Y, 50, 5E-3)
println(f"w= {w:.10f} b= {b:.10f}")

x = 20
println(f"Prediction {x} → {predict(x, w, b):.2f}")
