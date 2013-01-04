PACKAGES = hapi joi hoek lout hapi-helmet faketoe hapi-log flod catbox

install-all:
	for PACKAGE in $(PACKAGES); do \
		npm install $$PACKAGE; \
		(cd node_modules/$$PACKAGE && npm install); \
	done

test: install-all
	for PACKAGE in $(PACKAGES); do \
	    echo "Running tests for:" $$PACKAGE; \
		(cd node_modules/$$PACKAGE && make test); \
	done

test-cov: install-all
	mkdir coverage
	echo "<html><head></head><body><ul>" > coverage/index.html;
	for PACKAGE in $(PACKAGES); do \
	    echo "Running coverage report for:" $$PACKAGE; \
		(cd node_modules/$$PACKAGE && make test-cov-html); \
		(cd node_modules/$$PACKAGE && cp coverage.html ../../coverage/$$PACKAGE.html); \
		echo "<li><a href='$$PACKAGE.html' target='_parent'>$$PACKAGE coverage</a></li>" >> coverage/index.html; \
	done
	echo "</ul></body></html>" >> coverage/index.html