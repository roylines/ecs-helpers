.PHONY: pre build 

CONTAINER_NAME := $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(shell basename $(CURDIR))

pre:
	sudo pip install awscli

build:
	npm prune 
	npm install
	npm shrinkwrap --production
	docker info
	docker build -t $(CONTAINER_NAME):latest .
	docker tag $(CONTAINER_NAME):latest $(CONTAINER_NAME):$(CONTAINER_VERSION)
	docker images

publish:
	echo "publishing to $(CONTAINER_NAME)"
	$(shell aws ecr get-login --region $(AWS_REGION))
	docker push $(CONTAINER_NAME)
