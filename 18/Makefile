all: program program2

%: %.f90
	gfortran -fdefault-integer-8 -fimplicit-none -o $@ $<

clean:
	rm -f program program2
