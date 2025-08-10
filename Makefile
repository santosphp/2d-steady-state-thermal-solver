F2PY = f2py
PY = python3
SRC = heated_plate_mod.f90
MOD = heated_plate
STUDY_CASE = study_case.py
APP = main.py

# Por padrão `make` compila o módulo Fortran
all: $(MOD).so

# Compila o módulo Fortran
$(MOD).so: $(SRC)
	$(F2PY) -c $< -m $(MOD)

# Executa o caso de estudo
study:
	$(PY) $(STUDY_CASE)

# Executa a aplicação interativa
run:
	$(PY) $(APP)

clean:
	rm -f $(MOD)*.so *.mod

.PHONY: all study run clean

