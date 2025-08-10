import numpy as np
import matplotlib.pyplot as plt
from heated_plate import heated_plate_mod

# Parâmetros da simulação:
m, n = 200, 200           # Número de pontos na grade (x, y)
top = 100.0               # Temperatura no topo (condição de contorno)
bottom = 0.0              # Temperatura na base
left = 75.0               # Temperatura à esquerda
right = 50.0              # Temperatura à direita
tol = 1e-4                # Tolerância para convergência do solver

# A rotina `heated_plate_solver`, implementada em Fortran, retorna a solução convergida.
T = heated_plate_mod.heated_plate_solver(m, n, top, bottom, left, right, tol)

plt.imshow(T, cmap='hot', extent=[0,1,0,1])
plt.colorbar(label='Temperatura')
plt.title('Distribuição Térmica 2D em Regime Permanente')
plt.xlabel('X (Normalizado) ')
plt.ylabel('Y (Normalizado) ')

annotation_text = (
    f"Condições de Contorno:\n"
    f"Topo: {top}°C | Base: {bottom}°C\n"
    f"Esquerda: {left}°C | Direita: {right}°C\n"
    f"Tolerância de convergência: {tol:.0e}\n" 
    f"Ordem do array T: {'Column-major (F)' if T.flags.f_contiguous else 'Row-major (C)'}\n"
    f"Precisão: {T.dtype} ({T.dtype.itemsize} B) = REAL*8"
)

plt.annotate(
    annotation_text,
    xy=(0.02, 0.98),
    xycoords='axes fraction',
    ha='left',
    va='top',
    bbox=dict(
        boxstyle='round',
        alpha=0.4,
        facecolor='white',
        edgecolor='gray'
    )
)

plt.tight_layout()
plt.show()

