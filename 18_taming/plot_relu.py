# Plot the ReLU function.

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme()

MARGIN = 4
FAR_POINT = 100

# Configure axes
plt.axis('equal')
plt.axis([-MARGIN, MARGIN, -MARGIN, MARGIN])
plt.xticks(fontsize=15)
plt.yticks(fontsize=15)

# Plot horizontal axis
plt.plot([-FAR_POINT, FAR_POINT], [0, 0],
         color="grey", linestyle="dashed")

# Plot vertical axis
plt.plot([0, 0], [-FAR_POINT, FAR_POINT],
         color="grey", linestyle="dashed")

# Plot ReLU
plt.plot([-FAR_POINT, 0], [0, 0], color="blue")
plt.plot([FAR_POINT, 0], [FAR_POINT, 0], color="blue")
plt.xlabel("z", fontsize=30)
plt.ylabel("ReLU(z)", fontsize=30)

plt.show()
