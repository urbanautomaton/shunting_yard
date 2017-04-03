SRC_FILES := $(wildcard src/*.pl)
TEST_FILES := $(wildcard test/*_test.pl)

LOAD_FLAGS := $(foreach file, $(SRC_FILES),-l $(file))
TEST_FLAGS := $(foreach file, $(TEST_FILES),-l $(file))

.PHONY: test console

default: test

test:
	swipl -p src=src/ $(TEST_FLAGS) -g run_tests,halt -t 'halt(1)'

console:
	swipl $(LOAD_FLAGS)
