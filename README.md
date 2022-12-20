# devops-lab
DevOps Laboratory Project - CI/CD experiments

### GitLab

GitLab Community Edition.

After starting up GitLab for the first time, and before the first login, check the GitLab user "root" password:

```
sudo cat kubernetes/volumes/gitlab/config/initial_root_password
```

Beware that `initial_root_password` will automatically disappear after 24 hours!

Next, login with this password as user root at `http://localhost:32080`.
Change this password immediately in "User Settings" -> "Password" and relogin.

### SonarQube

SonarQube can be accessed from the host at `http://localhost:30900/sonarqube`. The default credentials on the first login are: username `admin` and password `admin`.
Immediately, after the first successful login with these credentials, SonarQube asks to change them.

### Registry Server

Local OCI (Open Container Initiative, a.k.a. Docker) registry.

Service location from pods: `http://registry-server-service:5001`, from host: `http://localhost:31500`.

### Registry UI

Browsing local Registry Server from host browser: `http://localhost:31182`

### Nexus

Browsing local Nexus repository from host browser: `http://localhost:31081/nexus/`. Internally, it is seen as `http://nexus-service:8081/nexus`.

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
