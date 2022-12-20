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

SonarQube UI can be accessed from the host at `http://localhost:30900/sonarqube`. The default credentials on the first login are: username `admin` and password `admin`.
Immediately, after the first successful login with these credentials, SonarQube asks to change them.
If You encounter a strange behaviour of SonarQube UI, clean the cookies in Your browser.

**Caution**: Since this SonarQube is configured to work with PostgreSQL instead of the default H2, which is for evaluation purposes only, You may encounter the follwoing error:

```
ERROR: [1] bootstrap checks failed. You must address the points described in the following [1] lines before starting Elasticsearch.
bootstrap check failure [1] of [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

The value is confirmed by peeking `sudo cat /proc/sys/vm/max_map_count`. If so, it must be increased by either `sudo sysctl -w vm.max_map_count=262144` (which is reset after the host restart), or by editing `/etc/sysctl.conf` and adding the line `vm.max_map_count=262144` (which is persistent).
Note that this parameter should be increased in the OS hosting the image (e.g. hosting microk8s installation).

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
