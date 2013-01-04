PACKAGES = hapi joi hoek lout hapi-helmet faketoe

test:
	for PACKAGE in $(PACKAGES); do \
		npm install $$PACKAGE; \
		(cd node_modules/$$PACKAGE && npm install); \
	done
	for PACKAGE in $(PACKAGES); do \
	    echo "Running tests for: " $$PACKAGE; \
		npm test $$PACKAGE; \
	done