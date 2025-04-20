using Plots
using MeshGrid: meshgrid

# Define the plane z = 1 - x - y
x = range(-10, stop=10, length=100)
y = range(-10, stop=10, length=100)
X, Y = meshgrid(x, y)
Z = 1 .- X .- Y

# Generate random points in 3D space
num_points = 50
points_x = rand(-10:0.1:10, num_points)
points_y = rand(-10:0.1:10, num_points)
points_z = rand(-10:0.1:10, num_points)

# Determine whether each point is above or below the plane
plane_z = 1 .- points_x .- points_y
above_plane = points_z .> plane_z
below_plane = .!above_plane

# Separate points based on their position relative to the plane
points_above_x = points_x[above_plane]
points_above_y = points_y[above_plane]
points_above_z = points_z[above_plane]

points_below_x = points_x[below_plane]
points_below_y = points_y[below_plane]
points_below_z = points_z[below_plane]

# Plot the plane
surface(X, Y, Z, color=:blue, alpha=0.5, label="Plane")

# Plot points above the plane (in red)
plot!(points_above_x, points_above_y, points_above_z, color=:red, marker=:circle, label="Above Plane")

# Plot points below the plane (in green)
scatter!(points_below_x, points_below_y, points_below_z, color=:green, marker=:circle, label="Below Plane")
