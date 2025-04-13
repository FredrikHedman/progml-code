using DelimitedFiles
using Statistics
using Plots
using Plots.PlotMeasures

predict(X, w, b) = X * w .+ b

loss(X, Y, w, b) = Statistics.mean((predict(X, w, b) - Y) .^2)

# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

weights = range(-1.0, 4.0, length=200)
losses = [loss(X, Y, w, 0) for w in weights]

min_idx = argmin(losses)
min_weight = weights[min_idx]
min_loss = losses[min_idx]

p = plot(weights, losses, color=:green, label="Loss", alpha=0.5)
xlims!(-1, 4)
ylims!(0,1000)

scatter!([min_weight], [min_loss],
    marker=(:xcross, 4, :red),
    label="Minimum loss")

plot!(p, margin=5mm,
    tickfontsize=15,
    xlabel="Weight",
    ylabel="Loss",
    guidefontsize=20,
)

