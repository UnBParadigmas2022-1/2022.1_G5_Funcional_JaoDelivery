setup:
	stack setup

run:
	stack build
	stack exec jao-delivery-exe

build:
	stack build