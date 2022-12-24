#!/bin/sh


#
# This script should be used to update GitLab config, once this is up and running for the first time.

sudo cp volumes/gitlab/config/gitlab.rb volumes/gitlab/config/gitlab.rb.orig

cat << EOF | sudo tee volumes/gitlab/config/gitlab.rb
external_url 'http://localhost:32080'
nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['listen_addresses'] = ['*', '[::]']
EOF


kubectl exec $(kubectl get pods -o name | grep -i "gitlab-") -- /bin/sh -c "gitlab-ctl reconfigure"
kubectl exec $(kubectl get pods -o name | grep -i "gitlab-") -- /bin/sh -c "gitlab-ctl hup nginx"
