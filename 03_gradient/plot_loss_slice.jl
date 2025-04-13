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

ww, bb, ll, hh = train_with_history(X, Y, 20000, 1E-3, 1E-4, 0.0, 0.0)
println(f"w= {ww:.3f} b= {bb:.3f} loss= {ll:.1f}")

history_w = hh[:,1]
history_b = hh[:,2]
history_loss = hh[:,3]

weights = range(-10, stop=10, length=20)
biases = range(-100, stop=100, length=20)
lo = [loss(X, Y, ww, bb) for ww in weights, bb in biases]

# Trace path of partial derivative slices
# TODO: seem to be shifted in space when plotting.  Why?
w_path = weights
b_path = fill(history_b[1], length(w_path))
l_path = [loss(X,Y, ww, history_b[1]) for ww in w_path]
p = plot(w_path, b_path, l_path, color=:red, lw=1, label=false)

b_path = biases
w_path = [history_w[1] for _ in b_path]
l_path = [loss(X,Y, history_w[1], bb) for bb in b_path]
plot!(w_path, b_path, l_path, color=:black, lw=1, label=false)

# Surface of loss
surface!(weights, biases, lo,
    camera=(45,45), colorbar=false, alpha=0.45)


# Style the plot
plot!(p, margin=2mm,
    tickfontsize=10,
    xlabel="Weight",
    ylabel="Bias",
    zlabel="Loss",
    guidefontsize=8,
)

# Need this to display when running via include
display(p)
println("DONE!")
