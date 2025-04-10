using Statistics
using Printf
using Plots
using Plots.PlotMeasures

function predict(X, w)
   return X * w
end

function loss(X, Y, w)
    tmp = predict(X, w) - Y
    return Statistics.mean(tmp .^2)
end

function train(X, Y; iterations, lr)
    w = 0.0
    for i = 0:iterations
        current_loss = loss(X, Y, w)
        @printf("Iteration %4d => Loss: %.6f\n", i, current_loss)
        if loss(X, Y, w + lr) < current_loss
            w += lr
        elseif loss(X, Y, w - lr) < current_loss
            w -= lr
        else
            return w
        end
    end
end

# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

# Train the system
w = train(X, Y, iterations=10000, lr=0.01)
 @printf("w = %.3f\n", w)

# Predict the number of pizzas
@printf("Prediction: x = %d => y = %.2f\n", 20, predict(20, w))

# Calculate the least-square solution
A = [ones(length(X)) X]
b = Y
x = A \ b
@printf("LS: w = %.3f\n", x[2])
@printf("LS: b = %.3f\n", x[1])
x0 = 20
@printf("Prediction: x = %d => y = %.2f\n", x0, x[1]+ x0*x[2])

# Plot the chart
x_edge = 30
y_edge = 30
x = range(0, x_edge, length=5)
y = predict.(x, w)
p = plot(x, y, color=:green, label="prediction")
scatter!(X, Y, color=:blue, label="observations")

plot!(p, margin=5mm,
    tickfontsize=15,
    xlabel="Reservations",
    ylabel="Pizzas",
    guidefontsize=20,
)

