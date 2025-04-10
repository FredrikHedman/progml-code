import numpy as np


def predict(X, w):
    return X * w


def loss(X, Y, w):
    return np.average((predict(X, w) - Y) ** 2)


def train(X, Y, iterations, lr):
    w = 0
    for i in range(iterations):
        current_loss = loss(X, Y, w)
        print(f"Iteration {i:4d} => Loss: {current_loss:.6f}")

        if loss(X, Y, w + lr) < current_loss:
            w += lr
        elif loss(X, Y, w - lr) < current_loss:
            w -= lr
        else:
            return w

    raise Exception("Couldn't converge within %d iterations" % iterations)


# Import the dataset
X, Y = np.loadtxt("pizza.txt", skiprows=1, unpack=True)

# Train the system
w = train(X, Y, iterations=10000, lr=0.01)
print(f"\nw={w:.3f}")

# Predict the number of pizzas
x = 20
print(f"Prediction: x={x:d} => y={predict(x, w):.2f}")

# Plot the chart
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme()
plt.plot(X, Y, "bo")
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)
plt.xlabel("Reservations", fontsize=30)
plt.ylabel("Pizzas", fontsize=30)
x_edge, y_edge = 50, 50
plt.axis([0, x_edge, 0, y_edge])
plt.plot([0, x_edge], [0, predict(x_edge, w)], linewidth=1.0, color="g")
plt.show()
