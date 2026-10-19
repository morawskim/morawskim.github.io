# Makefile

## Przekazywanie argumentów skryptu do celu w Makefile

```
###!make
SHELL := /bin/bash

.PHONY: hello

default: help

hello:  # Hello world
	@echo "Hello," $(filter-out $@,$(MAKECMDGOALS))


%: # catch-all target to ignore argument "targets"
	@: # no-op
```

[Passing script arguments to a Makefile target](https://mwop.net/blog/2026-02-11-makefile-args.html)
