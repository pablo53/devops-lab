#!/bin/sh


#
# Preconfiguration script.
# This script should run before the first deploment to Kubernetes (via Helm).
#

. ./config-env.sh

#
## GitLab

mkdir -p $GITLAB_CONFIG
mkdir -p $GITLAB_DATA
mkdir -p $GITLAB_LOGS

#
## GitLab Runner

mkdir -p $GITLAB_RUNNER_DOCKER
mkdir -p $GITLAB_RUNNER_CONFIG

#
## Jenkins

mkdir -p $JENKINS_DATA_DIR
chmod a+r,a+w,a+x $JENKINS_DATA_DIR
