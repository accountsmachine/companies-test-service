
GIT_VERSION=3ab26482
VERSION=1.0.3

GIT_REPO=https://github.com/cybermaggedon/gnucash-uk-vat

all:

NAME=companies-test-service

REPO=europe-west2-docker.pkg.dev/accounts-machine-dev/accounts-machine
CONTAINER=${REPO}/${NAME}

container:
	podman build -f Containerfile -t ${CONTAINER}:${VERSION} \
	    --format docker

login:
	gcloud auth print-access-token | \
	    podman login -u oauth2accesstoken --password-stdin \
	        europe-west2-docker.pkg.dev

push:
	podman push --remove-signatures ${CONTAINER}:${VERSION}

start:
	podman run -d --name ${NAME} \
	    -p 9000:8080 \
	    --env USERNAME=test --env PASSWORD=test \
	    ${CONTAINER}:${VERSION}

clean:
	rm -rf build/ wheels/

stop:
	podman rm -f ${NAME}

SERVICE=companies-test-service
PROJECT=accounts-machine-dev
REGION=europe-west1
TAG=v$(subst .,-,${VERSION})

deploy:
	gcloud run services update ${SERVICE} \
	    --project ${PROJECT} --region ${REGION} \
	    --image ${CONTAINER}:${VERSION} \
	    --tag ${TAG}

