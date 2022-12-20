# devops-lab
DevOps Laboratory Project - CI/CD experiments

### Registry Server

Local OCI (Open Container Initiative, a.k.a. Docker) registry.

Service location from pods: `http://registry-server-service:5001`, from host: `http://localhost:31500`.

### Registry UI

Browsing local Registry Server from host browser: `http://localhost:31182`

### Trivy

A Trivy server is deployed via Kubernetes and Helm. A trivy client can be
called from wherever with the command like e.g.:

Locally

```
trivy --debug --server http://trivy-server:8080 fs <dir_or_file>
```

or, in another pod,

```
trivy --debug --server http://trivy-server-service:8080 fs <dir_or_file>
```

Scanning images from the local registry in another pod:

```
trivy --debug --server http://trivy-server-service:8080 image registry-server-service:5001/<NAME>:<TAG>
```

Trivy server location from pods: `http://trivy-server-service:8080`, from host: `http://localhost:31180`.
