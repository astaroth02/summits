@SET version=v3
@SET architecture=arm32v7

if [%1]==[] (
	goto End
) else (
	if not [%2]==[arm32v7] (
		goto End
	)
) 

@IF "%architecture%" == "arm32v7" (
    SET suffix=_%architecture%
)

@SET servicename=ascent-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
node setContainerTag.js kubernetes\summits-%servicename%%suffix%.yaml %version% %architecture%

@SET servicename=general-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
node setContainerTag.js kubernetes\summits-%servicename%%suffix%.yaml %version% %architecture%

@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
node setContainerTag.js kubernetes\summits-%servicename%%suffix%.yaml %version% %architecture%


@echo
@echo *******************************************
@echo **  GIT commit                           **
@echo *******************************************


@SET servicename=ascent-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd 
docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%

docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%

@SET servicename=summit-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%

docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%

@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%version%

docker build . -t nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%
docker push nodejs\%servicename%\marcofenskevi/summits-%servicename%:%architecture%-%version%

@echo
@echo *******************************************
@echo ** Deploy to Kubernetes Cluster          **
@echo *******************************************
kubectl apply -f kubernetes\summits-general-service%suffix%.yaml
kubectl apply -f kubernetes\summits-user-service%suffix%.yaml
kubectl apply -f kubernetes\summits-ascent-service%suffix%.yaml

:End
echo You need at least a version and optional an architecture (currently only 'arm32v7' is supported).
echo Usage: deploy VERSION [ARCHITECTURE]"
echo Examples:
echo   deploy v3
echo   deploy 23.12 arm32v7