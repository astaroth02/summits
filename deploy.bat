@SET version=v3
@SET architecture=arm32v7

@IF "%architecture%" == "arm32v7" (
    SET suffix=_%architecture%
)

@SET servicename=ascent-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
@cd kubernetes
node ..\setContainerTag.js summits-%servicename%%suffix%.yaml %version% %architecture%

@SET servicename=general-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
node ..\setContainerTag.js summits-%servicename%%suffix%.yaml %version% %architecture%

@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************
node ..\setContainerTag.js summits-%servicename%%suffix%.yaml %version% %architecture%


@echo
@echo *******************************************
@echo **  GIT commit                           **
@echo *******************************************


@SET servicename=ascent-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd nodejs\%servicename%
docker build . -t marcofenskevi/summits-%servicename%:%version%
docker push marcofenskevi/summits-%servicename%:%version%

docker build . -t marcofenskevi/summits-%servicename%:arm32v7-%version%
docker push marcofenskevi/summits-%servicename%:%architecture%-%version%
@cd ..\..

@SET servicename=summit-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd nodejs\%servicename%
docker build . -t marcofenskevi/summits-%servicename%:%version%
docker push marcofenskevi/summits-%servicename%:%version%

docker build . -t marcofenskevi/summits-%servicename%:%architecture%-%version%
docker push marcofenskevi/summits-%servicename%:%architecture%-%version%
@cd ..\..

@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd nodejs\%servicename%
docker build . -t marcofenskevi/summits-%servicename%:%version%
docker push marcofenskevi/summits-%servicename%:%version%

docker build . -t marcofenskevi/summits-%servicename%:%architecture%-%version%
docker push marcofenskevi/summits-%servicename%:%architecture%-%version%
@cd ..\..

@echo
@echo *******************************************
@echo ** Deploy to Kubernetes Cluster          **
@echo *******************************************
@cd kubernetes
kubectl apply -f summits-general-service%suffix%.yaml
kubectl apply -f summits-user-service%suffix%.yaml
kubectl apply -f summits-ascent-service%suffix%.yaml
@cd ..\..
