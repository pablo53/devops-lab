#!/usr/bin/env sh

. ./helm-env.sh

helm install devops-lab --set "local.volumes.path=$CHARTDIR/volumes" --set "security.uid=$UID"  --set "security.gid=$GID" --set "registry_url=http://localhost:31500" .
