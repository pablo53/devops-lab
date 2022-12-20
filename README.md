# devops-lab
DevOps Laboratory Project - CI/CD experiments

### Trivy

A Trivy server is deployed via Kubernetes and Helm. A trivy client can be
called from wherever with the command like e.g.:

```
trivy --debug --server http://trivy-server:8080 fs <dir_or_file>
```

or, locally,

```
trivy --debug --server http://trivy-server-service:31180 fs <dir_or_file>
```
