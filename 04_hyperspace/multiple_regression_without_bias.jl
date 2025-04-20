using DelimitedFiles
using FStrings
using Statistics: mean
using MeshGrid: meshgrid
using Plots
using Plots.PlotMeasures

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
w = train(X, Y, iterations=10000, lr=1E-3)

println("w = $w")

shift_extrema(vec, margin) = [-margin, margin] + collect(extrema(vec))

MARGIN = 10
edges_x = shift_extrema(X[:,1], MARGIN)
edges_y = shift_extrema(X[:,2], MARGIN)

xs, ys = meshgrid(edges_x, edges_y)
zs = w[1] .+ w[2]*xs .+ w[3]*ys

# Style the plot
p = plot(margin=2mm,
    tickfontsize=10,
    xlabel="Temperature",
    ylabel="Reservations",
    zlabel="Pizzas",
    guidefontsize=12,
)

surface!(xs, ys, zs,  camera=(45,10), color=:blue, alpha=0.2, colorbar=false)
scatter!(X[:,1], X[:,2], Y, color=:red, ms=2, label=false)

display(p)
println("DONE")
