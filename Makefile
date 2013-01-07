PACKAGES = hapi joi hoek lout hapi-helmet faketoe hapi-log flod catbox
REPOS = hapi joi hoek lout helmet faketoe log flod catbox

install-dev: clean
	mkdir dev
	for REPO in $(REPOS); do \
		git clone -b develop git://github.com/walmartlabs/$$REPO.git dev/$$REPO; \
		(cd dev/$$REPO && npm install); \
	done

install-prod: clean
	for PACKAGE in $(PACKAGES); do \
		npm install $$PACKAGE; \
		(cd node_modules/$$PACKAGE && npm install); \
	done

test: install-prod
	for PACKAGE in $(PACKAGES); do \
	    echo "Running tests for:" $$PACKAGE; \
		(cd node_modules/$$PACKAGE && make test); \
	done
	make clean

test-dev: install-dev
	for REPO in $(REPOS); do \
	    echo "Running tests for:" $$REPO; \
		(cd dev/$$REPO && make test); \
	done
	make clean

test-cov: install-prod
	rm -rf coverage
	mkdir coverage
	echo "<html><head></head><body><ul>" > coverage/index.html;
	for PACKAGE in $(PACKAGES); do \
	    echo "Running coverage report for:" $$PACKAGE; \
		(cd node_modules/$$PACKAGE && make test-cov-html); \
		(cd node_modules/$$PACKAGE && cp coverage.html ../../coverage/$$PACKAGE.html); \
		echo "<li><a href='$$PACKAGE.html' target='_parent'>$$PACKAGE coverage</a></li>" >> coverage/index.html; \
	done
	echo "</ul></body></html>" >> coverage/index.html
	make clean

test-cov-dev: install-dev
	rm -rf coverage-dev
	mkdir coverage-dev
	echo "<html><head></head><body><ul>" > coverage-dev/index.html;
	for REPO in $(REPOS); do \
	    echo "Running coverage report for:" $$REPO; \
		(cd dev/$$REPO && make test-cov-html); \
		(cd dev/$$REPO && cp coverage.html ../../coverage-dev/$$REPO.html); \
		echo "<li><a href='$$REPO.html' target='_parent'>$$REPO coverage</a></li>" >> coverage-dev/index.html; \
	done
	echo "</ul></body></html>" >> coverage-dev/index.html
	make clean

clean:
	rm -rf node_modules
	rm -rf dev