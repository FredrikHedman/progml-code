# A solution to the "Hands On: Field Statistician" exercise at the end
# of chapter "Hyperspace!"

import numpy as np


def predict(X, w):
    return np.matmul(X, w)


def loss(X, Y, w):
    return np.average((predict(X, w) - Y) ** 2)


def gradient(X, Y, w):
    return 2 * np.matmul(X.T, (predict(X, w) - Y)) / X.shape[0]


def train(X, Y, iterations, lr):
    w = np.zeros((X.shape[1], 1))
    for i in range(iterations):
        print("Iteration %4d => Loss: %.20f" % (i, loss(X, Y, w)))
        w -= gradient(X, Y, w) * lr
    return w


FILENAME = "../../data/life-expectancy/life-expectancy-without-country-names.txt"
x1, x2, x3, y = np.loadtxt(FILENAME, skiprows=1, unpack=True)
X = np.column_stack((np.ones(x1.size), x1, x2, x3))
Y = y.reshape(-1, 1)
w = train(X, Y, iterations=5_000_000, lr=0.0001)

print("\nWeights: %s" % w.T)
print("\nA few predictions:")
for i in range(10):
    print("X[%d] -> %.4f (label: %d)" % (i, predict(X[i], w).item(), Y[i].item()))
