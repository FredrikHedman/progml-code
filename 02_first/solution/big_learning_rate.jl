using DelimitedFiles
using FStrings
include("linear_regression.jl")

# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

# Train the system
w, b = train(X, Y, iterations=50, lr=0.5)
println(f"w = {w:.3f}\t b = {b:.3f}")

# Predict the number of pizzas
rs = 20
println(f"Prediction: x = {rs} => ŷ = {predict(rs, w, b):.2f}")


