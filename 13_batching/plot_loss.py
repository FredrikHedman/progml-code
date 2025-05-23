# Plot the loss during a run of GD.

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()


def sigmoid(z):
    return 1 / (1 + np.exp(-z))


def softmax(logits):
    exponentials = np.exp(logits)
    return exponentials / np.sum(exponentials, axis=1).reshape(-1, 1)


def sigmoid_gradient(sigmoid):
    return np.multiply(sigmoid, (1 - sigmoid))


def loss(Y, y_hat):
    return -np.sum(Y * np.log(y_hat)) / Y.shape[0]


def prepend_bias(X):
    return np.insert(X, 0, 1, axis=1)


def forward(X, w1, w2):
    h = sigmoid(np.matmul(prepend_bias(X), w1))
    y_hat = softmax(np.matmul(prepend_bias(h), w2))
    return (y_hat, h)


def back(X, Y, y_hat, w2, h):
    w2_gradient = np.matmul(prepend_bias(h).T, (y_hat - Y)) / X.shape[0]
    w1_gradient = np.matmul(prepend_bias(X).T, np.matmul(y_hat - Y, w2[1:].T)
                            * sigmoid_gradient(h)) / X.shape[0]
    return (w1_gradient, w2_gradient)


def classify(X, w1, w2):
    y_hat, _ = forward(X, w1, w2)
    labels = np.argmax(y_hat, axis=1)
    return labels.reshape(-1, 1)


def initialize_weights(n_input_variables, n_hidden_nodes, n_classes):
    w1_rows = n_input_variables + 1
    w1 = np.random.randn(w1_rows, n_hidden_nodes) * np.sqrt(1 / w1_rows)

    w2_rows = n_hidden_nodes + 1
    w2 = np.random.randn(w2_rows, n_classes) * np.sqrt(1 / w2_rows)

    return (w1, w2)


def report(iteration, X_train, Y_train, X_test, Y_test, w1, w2):
    y_hat, _ = forward(X_train, w1, w2)
    training_loss = loss(Y_train, y_hat)
    classifications = classify(X_test, w1, w2)
    accuracy = np.average(classifications == Y_test) * 100.0
    print("Iteration: %5d, Loss: %.8f, Accuracy: %.2f%%" %
          (iteration, training_loss, accuracy))
    return (training_loss, accuracy)


def train(X_train, Y_train, X_test, Y_test, n_hidden_nodes, iterations, lr):
    n_input_variables = X_train.shape[1]
    n_classes = Y_train.shape[1]

    loss_history = []
    accuracy_history = []
    w1, w2 = initialize_weights(n_input_variables, n_hidden_nodes, n_classes)
    for i in range(iterations):
        y_hat, h = forward(X_train, w1, w2)
        training_loss = loss(Y_train, y_hat)
        w1_gradient, w2_gradient = back(X_train, Y_train, y_hat, w2, h)
        w1 = w1 - (w1_gradient * lr)
        w2 = w2 - (w2_gradient * lr)
        training_loss, accuracy = report(i, X_train, Y_train, X_test, Y_test,
                                         w1, w2)
        loss_history.append(training_loss)
        accuracy_history.append(accuracy)
    return (loss_history, accuracy_history)


if __name__ == "__main__":
    import mnist
    np.random.seed(1234)

    # Plot loss across ITERATIONS training iterations
    ITERATIONS = 30
    # ITERATIONS = 1000

    loss_history, accuracy_history = train(mnist.X_train, mnist.Y_train,
                                           mnist.X_test, mnist.Y_test,
                                           n_hidden_nodes=200,
                                           iterations=ITERATIONS,
                                           lr=0.01)

    plt.subplot(1, 2, 1)
    plt.xticks(fontsize=15)
    plt.yticks(fontsize=15)
    plt.ylabel("Loss", fontsize=30)
    plt.plot(loss_history, color='orange')

    plt.subplot(1, 2, 2)
    plt.xticks(fontsize=15)
    plt.yticks(fontsize=15)
    plt.ylabel("Accuracy %", fontsize=30)
    plt.plot(accuracy_history, color='green')

    plt.show()
