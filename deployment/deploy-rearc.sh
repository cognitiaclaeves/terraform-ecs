#!/bin/sh -e

#Usage: CONTAINER_VERSION=docker_container_version [create|update]

# register task-definition
sed <td-rearcquest.template -e "s,@VERSION@,\"$CONTAINER_VERSION\",">TASKDEF.json
aws ecs register-task-definition --cli-input-json file://TASKDEF.json > REGISTERED_TASKDEF.json
TASKDEFINITION_ARN=$( < REGISTERED_TASKDEF.json jq .taskDefinition.taskDefinitionArn | tr -d \" )

# create or update service
sed "s,@@TASKDEFINITION_ARN@@,$TASKDEFINITION_ARN," <service-$1-rearcquest.json >SERVICEDEF.json
aws ecs $1-service --cli-input-json file://SERVICEDEF.json | tee SERVICE.json
