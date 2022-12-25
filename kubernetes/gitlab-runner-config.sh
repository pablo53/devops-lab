#!/bin/sh


#
# This script should be used to update GitLab Runner config, once this is up and running for the first time.
#
# The first paraameter to this script should be the registration token from GitLab.
# The second, optional, parameter is the tag list. If not provided, the runner will accept also untagged jobs.

. ./config-env.sh



if [ $# -lt 1 ]
then
	echo "Usage: ./gitlab-runner-config.sh <registration_token> [<tag_list>]"
	exit -1
fi



cat << EOF | tee $GITLAB_RUNNER_CONFIG/config.toml
concurrent = 1
check_interval = 0
EOF

sleep 10



GITLAB_RUNNER_REGISTER_COMMAND="gitlab-runner register --non-interactive --run-untagged --url http://gitlab-service:80 --clone-url http://gitlab-service:80 --name pablo53-devops-lab-gitlab-runner --executor shell --registration-token=$1"
if [ $# -ge 2 ]
then
GITLAB_RUNNER_REGISTER_COMMAND="$GITLAB_RUNNER_REGISTER_COMMAND --tag-list '$2'"
fi

echo $GITLAB_RUNNER_REGISTER_COMMAND

kubectl exec $(kubectl get pods -o name | grep -i "gitlabrunner-") -- /bin/sh -c "$GITLAB_RUNNER_REGISTER_COMMAND"
