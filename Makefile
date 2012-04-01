TESTS = test/lib/*.coffee
REPORTER = landing

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
    --compilers coffee:coffee-script \
		$(TESTS)

.PHONY: test
