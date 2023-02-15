VERSION=10.1.3

build-image:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-amd64 .

build-image-arm64:
	docker build --no-cache --pull --build-arg version=${VERSION} -t ontotext/graphdb:${VERSION}-arm64 arm64-build-on-aws

push:
	docker push ontotext/graphdb:${VERSION}

# KMcC;)

build-preload:
	( cd preload ; docker-compose build --no-cache )
	( cd preload ; docker-compose up -d )

run:
	docker-compose up -d

clean:
	rm -rf graphdb-data
	docker container rm -f graphdb-docker
	docker container rm -f preload
	docker image rm -f graphdb-docker_graphdb
	docker image rm -f preload_graphdb
