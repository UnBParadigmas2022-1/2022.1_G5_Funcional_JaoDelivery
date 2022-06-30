setup:
	stack setup

run:
	stack build
	stack exec decision-questions-exe

build:
	stack build