#!/bin/bash

set -eu


echo "Getting kubeconfig..."
echo ${GCLOUD_CREDENTIALS} | base64 -d > .creds
gcloud auth activate-service-account --key-file=.creds
gcloud config set project ${GCP_PROJECT}

if gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${CLUSTER_REGION}; then
    echo "Enrolled with region"
else
    echo "Could not enroll with region. Wnrolling with zone..."
    gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_REGION}
fi
echo "Got kubeconfig"

echo "Deploying resources..."
export IMG=${DOCKERHUB_REPO_OWNER}/${APP_NAME}:${DOCKER_IMAGE_TAG}
print "Setting image to $IMG..."
sed -i'' -e 's@image: '"${DOCKERHUB_REPO_OWNER}/${APP_NAME}"':.*@image: '"${IMG}"'@' ${K8S_RESOURCE_PATH}/cronJob.yaml

kubectl apply -f ${K8S_RESOURCE_PATH}
echo "Deployed resources"
