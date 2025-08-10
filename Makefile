F2PY = f2py
PY = python3
SRC = heated_plate_mod.f90
MOD = heated_plate

all: $(MOD).so
	$(PY) main.py

$(MOD).so: $(SRC)
	$(F2PY) -c $< -m $(MOD)

clean:
	rm -f $(MOD)*.so *.mod
