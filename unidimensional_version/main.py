import numpy as np
import matplotlib.pyplot as plt
from solver import solver

def uniform_grid(L, N):
    """Return a uniform mesh x on [0, L]."""
    return np.linspace(0, L, N)

def stretched_grid(L, N, power=1.5):
    """Return a power‐law stretched mesh x on [0, L]."""
    lin = np.linspace(0, L, N)
    return lin**power * L / (L**power)

def main():
    L = 1   # meters
    N = 20  # points

    # Scenario 1: Basic uniform case
    x = uniform_grid(L, N)
    kappa = np.ones(N)
    T = solver.solve_system(x, kappa, 80, -20, N)

    plt.figure()
    plt.plot(x, T, 'o-')
    plt.title(f"Uniform case\nBCs: 80C | -20C")
    plt.xlabel('Position (m)')
    plt.ylabel('Temperature (K)')
    plt.axvline(x=1/2, color='r', linestyle='--', label='Midpoint')
    plt.legend()
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    main()

