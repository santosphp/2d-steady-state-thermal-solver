# Solucionador Térmico em Regime Permanente 2D

## Estrutura do Repositório

```bash
.
├── heated_plate_mod.f90
├── main.py
├── Makefile
├── README.md
├── study_case.py
└── unidimensional_version
    ├── main.py
    ├── Makefile
    ├── README.md
    └── solver.f90
```

## Sobre o Projeto

Foram implementadas duas versões do solucionador térmico:

1. **Versão unidimensional**: Desenvolvida completamente pelo nosso grupo.
2. **Versão bidimensional**: Adaptada a partir de um código existente (com os créditos nos comentários do arquivo Fortran)

Este documento focará na versão principal (2D). Os arquivos relevantes no diretório raiz são:

- `heated_plate_mod.f90`: Contém a subrotina Fortran `heated_plate_solver()`
- `main.py`: Interface gráfica em Python para interação com o usuário
- `Makefile`: Arquivo de compilação para a versão 2D
- `README.md`: Este arquivo
- `study_case.py`: Demonstração com um caso de estudo pré-configurado

## Compilação e Execução

### Requisitos
- Python3
- Compilador gfortran
- Meson (necessário para o f2py)
- f2py (para integração Fortran-Python)
- Numpy

### Instruções de Compilação
```bash
git clone git@github.com:santosphp/2d-steady-state-thermal-solver.git
cd 2d-steady-state-thermal-solver
make
```

### Modos de Execução

#### 1. Interface Gráfica Interativa
```bash
make run
```

#### 2. Caso de Estudo Pré-definido
```bash
make study
```

