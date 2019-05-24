@SET version=v3
@SET architecture=arm32v7

@SET servicename=ascent-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************


@SET servicename=summit-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************


@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Update version for %servicename%     **
@echo *******************************************



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
docker push marcofenskevi/summits-%servicename%:arm32v7-%version%
@cd ..\..

@SET servicename=summit-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd nodejs\%servicename%
docker build . -t marcofenskevi/summits-%servicename%:%version%
docker push marcofenskevi/summits-%servicename%:%version%

docker build . -t marcofenskevi/summits-%servicename%:arm32v7-%version%
docker push marcofenskevi/summits-%servicename%:arm32v7-%version%
@cd ..\..

@SET servicename=user-service
@echo
@echo *******************************************
@echo **  Docker build and push %servicename%  **
@echo *******************************************
@cd nodejs\%servicename%
docker build . -t marcofenskevi/summits-%servicename%:%version%
docker push marcofenskevi/summits-%servicename%:%version%

docker build . -t marcofenskevi/summits-%servicename%:arm32v7-%version%
docker push marcofenskevi/summits-%servicename%:arm32v7-%version%
@cd ..\..

@echo
@echo *******************************************
@echo ** Deploy to Kubernetes Cluster          **
@echo *******************************************
@cd kubernetes
@SET suffix=
@IF "%architecture%" == "arm32v7" (
    SET suffix=_arm32v7
)
kubectl apply -f summits_general%suffix%.yaml
kubectl apply -f summits_user%suffix%.yaml
kubectl apply -f summits_ascent%suffix%.yaml
@cd ..\..
