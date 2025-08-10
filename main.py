import numpy as np
import matplotlib.pyplot as plt
from heated_plate import heated_plate_mod

m, n = 200, 200
top, bottom = 100.0, 0.0
left, right = 75.0, 50.0
tol = 1e-4

T = np.zeros((m, n), order='F', dtype=np.float64)

T = heated_plate_mod.heated_plate_solver(m, n, top, bottom, left, right, tol)

plt.imshow(T, cmap='hot', extent=[0,1,0,1])
plt.colorbar(label='Temperature')
plt.title('2D Steady-State Heat Distribution')
plt.xlabel('X')
plt.ylabel('Y')
plt.show()

