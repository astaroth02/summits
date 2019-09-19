@echo off

setlocal enabledelayedexpansion

set version=
set architectures=x64 arm32v7
set clusterarchitecture=
set services=ascent-service general-service user-service

if [%1] == [] (
	goto Usage
) else (
	if [%2] == [] (
		set clusterarchitecture=
	)
	if [%2] == [x64] (
		set clusterarchitecture=
	)
	if [%2] == [arm32v7] (
		set clusterarchitecture=%2
	)
	
	if not [%3] == [] (
		goto Usage
	)

	set version=%1
)

echo.
echo *******************************************
echo **  Update service container tags
echo *******************************************
for %%s in (%services%) do (
	for %%a in (%architectures%) do (
		echo Set container tags for service "%%s" ...
		if [%%a] == [x64] (
			node setContainerTag.js kubernetes\summits-%%s.yaml !version!
		) else (
			node setContainerTag.js kubernetes\summits-%%s_%%a.yaml !version! %%a
		)		
	)
)

echo.
echo *******************************************
echo **  GIT commit
echo *******************************************
echo TODO


echo.
echo *******************************************
echo **  Docker build and push
echo *******************************************
set services=ascent-service summit-service user-service
for %%s in (%services%) do (
	for %%a in (%architectures%) do (
		echo Build and push docker image for service "%%s" and architecture "%%a" ...
		if [%%a] == [x64] (
			docker build ./nodejs/%%s -t marcofenskevi/summits-%%s:!version!
			docker push marcofenskevi/summits-%%s:!version!
		) else (
			docker build ./nodejs/%%s -t marcofenskevi/summits-%%s:%%a-!version!
			docker push marcofenskevi/summits-%%s:%%a-!version!
		)		
	)
)

echo.
echo *******************************************
echo ** Deploy to Kubernetes cluster
echo *******************************************
set services=ascent-service general-service user-service
for %%s in (%services%) do (
	echo Deploy service "%%s" to cluster ...
	if [%clusterarchitecture%] == [] (
		kubectl apply -f ./kubernetes/summits-%%s.yaml
	) else (
		kubectl apply -f ./kubernetes/summits-%%s_%clusterarchitecture%.yaml
	)		
)

goto End

:Usage
echo You need at least a version and the architecture of the target machines of the cluster.
echo Currently only 'x64' and 'arm32v7' are supported and if the the architecture is left empty 'x64' is assumed. 
echo Usage: deploy VERSION [ARCHITECTURE]
echo Examples:
echo   deploy v3
echo   deploy 23.12 arm32v7

:End
set version=
set architectures=
set clusterarchitecture=
set services=