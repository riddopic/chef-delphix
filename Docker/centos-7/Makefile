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

.PHONY: build clean full-clean start stop restart run dev-release push \
				release deploy test

include ../includes.mk

CONTAINER = s6
IMAGE = $(IMAGE_PREFIX)$(CONTAINER):$(BUILD_TAG)
DEV_IMAGE = $(DEV_REGISTRY)/$(IMAGE)

build: check-docker
	docker build -t $(IMAGE) --rm .
	docker tag -f $(IMAGE) $(IMAGE_PREFIX)$(CONTAINER):latest
	docker tag -f $(IMAGE) $(IMAGE_PREFIX)$(CONTAINER):$(CONTAINER)$(BUILD_TAG)

clean: check-docker check-registry
	docker rmi $(IMAGE)

full-clean: check-docker check-registry
	docker images -q $(IMAGE_PREFIX)$(CONTAINER) | xargs docker rmi -f

start:
	@docker inspect $(CONTAINER) >/dev/null 2>&1 && docker start $(CONTAINER) || docker run -d --name $(CONTAINER) $(IMAGE)

stop:
	docker stop $(CONTAINER)

restart: stop start

run: start

dev-release: push set-image

push: check-registry
	docker tag -f $(IMAGE) $(DEV_IMAGE)
	docker push $(DEV_IMAGE)

release:
	docker push $(IMAGE)

deploy: build dev-release restart

test:
