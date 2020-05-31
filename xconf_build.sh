#!/bin/sh
rm -rf artifactory/*
docker run --rm -it -v $(pwd)/artifactory:/artifacts -v m2:/root/.m2 $(docker build -q builder)
mkdir -p artifactory/build/webapp
cp -r artifactory/adminservice/* artifactory/build/webapp
cp adminservice/* artifactory/build/
docker build -t xconf/adminservice artifactory/build
rm -rf artifactory/build/*
mkdir -p artifactory/build/webapp
cp -r artifactory/dataservice/* artifactory/build/webapp
cp dataservice/* artifactory/build/
docker build -t xconf/dataservice artifactory/build
docker image prune

