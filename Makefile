# Licensed under the Apache License. See footer for details.

.PHONY: lib test

COFFEE     = node_modules/.bin/coffee
COFFEEC    = $(COFFEE) --bare --compile

#-------------------------------------------------------------------------------
help:
	@echo "available targets:"
	@echo "   watch  - watch for source changes, then build, then test"
	@echo "   build  - run a build"
	@echo "   test   - run the tests"
	@echo "   help   - print this help"

#-------------------------------------------------------------------------------
watch: 
	make build-test
	wr "make build-test" bin lib-src examples Makefile

#-------------------------------------------------------------------------------
build-test: build test

#-------------------------------------------------------------------------------
build:
	@mkdir -p lib
	@rm -rf lib/*
	@cp lib-src/*.html lib
	@$(COFFEEC) --output lib  lib-src/*.coffee 

#-------------------------------------------------------------------------------
test:
	@mkdir -p tmp

	@node bin/apir.js \
		--gen html \
		--gen json \
		--verbose \
		--output tmp/us-weather.http \
		    examples/us-weather.http

	@node bin/apir.js \
		--gen html \
		--gen json \
		--verbose \
		--output tmp/us-weather.js \
		    examples/us-weather.js


#-------------------------------------------------------------------------------
# Copyright 2013 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
