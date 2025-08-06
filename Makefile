FC = gfortran
F2PY = f2py
TARGET = run

all: $(TARGET)

solver.so: solver.f90
	$(F2PY) -c solver.f90 -m solver

run: solver.so
	python3 main.py

clean:
	rm -f solver*.so

