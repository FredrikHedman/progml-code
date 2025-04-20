using DelimitedFiles
using FStrings
using Statistics: mean
using Plots
using Plots.PlotMeasures

predict(X, w, b) = X * w .+ b

loss(X, Y, w, b) = mean((predict(X, w, b) - Y) .^2)

function loss_gradients(X, Y, w, b)
    dY = predict(X, w, b) - Y
    w_grad = 2 * mean(X .* dY)
    b_grad = 2 * mean(dY)
    return w_grad, b_grad
end

function train_with_history(X, Y, iterations, lr, eps, w, b)
    previous_loss = loss(X, Y, w, b)
    rows = [[w b previous_loss]]

    for _ in 1:iterations-1
        dw, db = loss_gradients(X, Y, w, b)
        w -= lr * dw
        b -= lr * db

        current_loss = loss(X, Y, w, b)
        push!(rows, [w b current_loss])

        if (abs(current_loss - previous_loss) < eps)
            return w, b, current_loss, reduce(vcat, rows)
        end
        previous_loss = current_loss
    end
    error("Did not converge within %d iterations", iterations)
end


# Import the dataset
data = readdlm("pizza.txt", skipstart=1)
X = data[:, 1]
Y = data[:, 2]

ww, bb, ll, hh = train_with_history(X, Y, 20000, 1E-3, 1E-4, -10.0, -250.0)
println(f"w= {ww:.3f} b= {bb:.3f} loss= {ll:.1f}")

history_w = hh[:,1]
history_b = hh[:,2]
history_loss = hh[:,3]

x = range(minimum(history_w)-10, round(maximum(history_w)+10), length=20)
y = range(minimum(history_b)-100, round(maximum(history_b)+100), length=20)
lo = [loss(X, Y, ww, bb) for ww in x, bb in y]

# Surface and starting point and end point.
p = surface(x, y, lo, camera=(60,10), colorbar=false, alpha=0.65)
scatter!([history_w[1]], [history_b[1]], [history_loss[1]], color=:red, ms=3, label=false)
scatter!([history_w[end]], [history_b[end]], [history_loss[end]], color=:green, ms=3, label=false)

# Plot the history, but smaple the path.
path_sample = 1000
rr = 1:path_sample:length(history_w)
w_path = history_w[rr]
b_path = history_b[rr]
l_path = history_loss[rr]
plot!(w_path, b_path, l_path, color=:white, ls=:dash, lw=1, label=false)
scatter!(w_path, b_path, l_path, color=:yellow, ms=2, label=false)

#
N = length(x)
dxlo = [loss(X, Y, x[i], y[i]) for i in 1:N]
plot!(x, y, dxlo, color=:red, lw=1, label=false)

dxlo = [loss(X, Y, x[N+1-i], y[i]) for i in 1:N]
plot!(reverse(x), y, dxlo, color=:red, lw=1, label=false)

# Check corners
# TODO: seem to be shifted in space when plotting.  Why?
cx = [x[1], x[N], x[1], x[N]]
cy = [y[1], y[1], y[N], y[N]]
dxlo = [loss(X, Y, cx[i], cy[i]) for i in 1:4]
scatter!(cx, cy, dxlo, color=:green, ms=3, label=false)

# Style the plot
plot!(p, margin=2mm,
    tickfontsize=10,
    xlabel="Weight",
    ylabel="Bias",
    zlabel="Loss",
    guidefontsize=5,
)

# Need this to display when running via include
display(p)
println("DONE!")

