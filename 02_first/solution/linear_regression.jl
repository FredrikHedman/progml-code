using FStrings
using Statistics

predict(X, w, b) = X * w .+ b

loss(X, Y, w, b) = Statistics.mean((predict(X, w, b) - Y) .^2)

function train(X, Y; iterations, lr)
    w = b = 0.0
    ii = 0
    while ii < iterations
        current_loss = loss(X, Y, w, b)
        println(f"Iteration {ii:4d} => Loss: {current_loss:.6f}\t w={w:.6f}\t b= {b:.6f}")
        if loss(X, Y, w + lr, b) < current_loss
            w += lr
        elseif loss(X, Y, w, b + lr) < current_loss
            b += lr
        elseif loss(X, Y, w - lr, b ) < current_loss
            w -= lr
        elseif loss(X, Y, w, b - lr) < current_loss
            b -= lr
        else
            return w, b
        end
        ii += 1
    end
    error(f"Did not converge within {iterations} iterations")
end

