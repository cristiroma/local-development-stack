#!/bin/sh

# usage ./create-core template-name core-name

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as root"
  exit
fi

if [ -z $1 ]; then
	echo "Create a new core from templates/ directory"
	echo "usage ./create-core <template-name> <core-name>"
	exit -1
fi

if [ -z $2 ]; then
	echo "Create a new core from templates/ directory"
	echo "usage ./create-core <template-name> <core-name>"
	exit -1
fi

if [ ! -d "./templates/$1" ]; then
	echo "Template does not exist, check valid names are:"
	find ./templates/ -mindepth 1 -maxdepth 1 -type d -printf " - %f \n"
	exit -1
fi

if [ -d "cores/$2" ]; then
	echo "Core '$2' already exists, pick another name."
	exit -1
fi

cp -r "templates/$1" "cores/$2"
echo "name=$2" > "cores/$2/core.properties"
sudo chown -R 8983:8983 "cores/$2"
sudo chmod -R ug+w "cores/$2"
