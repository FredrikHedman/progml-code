using DelimitedFiles
using Printf
using FStrings
using Statistics
using Plots
using Plots.PlotMeasures

function predict(X, w, b)
   return X * w .+ b
end

function loss(X, Y, w, b)
    tmp = predict(X, w, b) - Y
    return Statistics.mean(tmp .^2)
end

function train(X, Y; iterations, lr)
    w = b = 0.0
    for i = 0:iterations
        current_loss = loss(X, Y, w, b)
        @printf("Iteration %4d => Loss: %.6f\t", i, current_loss)
        @printf("w = %.6f\t b = %.6f\n", w, b)
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
    end
end

# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

# Train the system
w, b = train(X, Y, iterations=10000, lr=0.1)
println(f"w = {w:.3f}\t b = {b:.3f}")

# Predict the number of pizzas
rs = 20
println(f"Prediction: x = {rs} => ŷ = {predict(rs, w, b):.2f}")

# Calculate the least-square solution
A = [ones(length(X)) X]
b_lsq, w_lsq = A \ Y
println(f"LS: w = {w_lsq:.3f}\t b = {b_lsq:.3f}")
println(f"LS prediction: x = {rs} => y = {predict(rs, w_lsq, b_lsq):.2f}")
println(f"LS loss: {loss(X, Y, w_lsq, b_lsq):.6f}")

# Plot the chart
x_edge = 30
y_edge = 30

x = range(0, x_edge, length=5)
ŷ = predict.(x, w, b)
p = plot(x, ŷ, color=:green, label="prediction", alpha=0.5)

ŷ = predict.(x, w_lsq, b_lsq)
plot!(x, ŷ, color=:red, label="LSQ prediction", alpha=1.0)

scatter!(X, Y, color=:blue, label="observations")

plot!(p, margin=5mm,
    tickfontsize=15,
    xlabel="Reservations",
    ylabel="Pizzas",
    guidefontsize=20,
)

