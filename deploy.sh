#!/bin/bash

version=""
architectures="x64 arm32v7"
clusterarchitecture=""

function usage()
{
	echo You need at least a version and the architecture of the target machines of the cluster.
	echo Currently only 'x64' and 'arm32v7' are supported and if the the architecture is left empty 'x64' is assumed.
	echo Usage: deploy VERSION [ARCHITECTURE]
	echo Examples:
	echo   deploy v3
	echo   deploy 23.12 arm32v7
	exit
}

if [[ "$1" == "" ]]
then
	usage
else
	if [[ "$2" == "" ]]
	then
		clusterarchitecture=""
	fi
	if [[ "$2" == "x64" ]]
	then
		clusterarchitecture=""
	fi
	if [[ "$2" == "arm32v7" ]]
	then
		clusterarchitecture="$2"
	fi
	
	if [[ ! "$3" == "" ]]
	then
		usage
	fi
	
	version="$1"
fi

echo
echo "*******************************************"
echo "**  Update service container tags"
echo "*******************************************"
services="ascent-service general-service user-service"
for s in $services
do
	for a in $architectures
	do
		echo Set container tags for service \"${s}\" ...
		if [[ "$a" == "x64" ]]
		then
			node setContainerTag.js kubernetes/summits-${s}.yaml ${version}
		else
			node setContainerTag.js kubernetes/summits-${s}_${a}.yaml ${version} ${a}
		fi
	done
done

echo
echo "*******************************************"
echo "**  GIT commit"
echo "*******************************************"
echo TODO

echo
echo "*******************************************"
echo "**  Docker build and push"
echo "*******************************************"
services="ascent-service summit-service user-service"
for s in $services
do
	for a in $architectures
	do
		echo Build and push docker image for service \"${s}\" and architecture \"${a}\" ...
		if [[ "$a" == "x64" ]]
		then
			docker build ./nodejs/${s} -t marcofenskevi/summits-${s}:${version}
			docker push marcofenskevi/summits-${s}:${version}
		else
			docker build ./nodejs/${s} -t marcofenskevi/summits-${s}:${a}-${version}
			docker push marcofenskevi/summits-${s}:${a}-${version}
		fi
	done
done

echo
echo "*******************************************"
echo "** Deploy to Kubernetes cluster"
echo "*******************************************"
services="ascent-service general-service user-service"
for s in $services
do
	echo Deploy service \"${s}\" to cluster ...
	if [[ "$clusterarchitecture" == "" ]]
	then
		kubectl apply -f ./kubernetes/summits-${s}.yaml
	else
		kubectl apply -f ./kubernetes/summits-${s}_${clusterarchitecture}.yaml
	fi
done

version=""
architectures=""
clusterarchitecture=""
services=""