# encoding: UTF-8
#
# Author:    Stefano Harding <riddopic@gmail.com>
# License:   Apache License, Version 2.0
# Copyright: (C) 2014-2015 Stefano Harding
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include includes.mk

CONTAINER = centos-6 centos-7 ubuntu-14.04

all: build

dev-registry: check-docker
	@docker inspect registry >/dev/null 2>&1 && docker start registry || docker run --restart="always" -d -p 5000:5000 --name registry registry:latest
	@echo
	@echo "To use the local registry for development:"
	@echo "    export DEV_REGISTRY=`docker-machine ip 2>/dev/null`:5000"

init: check-docker
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) build &&) echo done

build: check-docker
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) build &&) echo done

basebox: check-docker
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) build &&) echo done

clean:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) clean &&) echo done

full-clean:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) full-clean &&) echo done

start:
	@$(foreach C, $(START_ORDER), $(MAKE) -C $(C) start &&) echo done

stop:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) stop &&) echo done

restart: stop start

run: start

dev-release:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) dev-release &&) echo done

push:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) push &&) echo done

set-image:
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) set-image &&) echo done

release: check-registry
	@$(foreach C, $(CONTAINER), $(MAKE) -C $(C) release &&) echo done

deploy: build dev-release restart

test:
