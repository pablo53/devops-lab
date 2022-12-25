#!/bin/sh


#
# Preconfiguration script.
# This script should run before the first deploment to Kubernetes (via Helm).
#

. ./config-env.sh

#
## GitLab

mkdir -p $GITLAB_RUNNER_CONFIG
mkdir -p $GITLAB_RUNNER_DATA
mkdir -p $GITLAB_RUNNER_LOGS

#
## GitLab Runner

mkdir -p $GITLAB_RUNNER_DOCKER
mkdir -p $GITLAB_RUNNER_CONFIG
