TESTS = test/lib/*.coffee
REPORTER = progress

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
    --compilers coffee:coffee-script \
		$(TESTS)

.PHONY: test
