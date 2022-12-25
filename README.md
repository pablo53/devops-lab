# devops-lab
DevOps Laboratory Project - CI/CD experiments

### GitLab

#### GitLab Community Edition.

After starting up GitLab for the first time, and before the first login, check the GitLab user "root" password:

```
sudo cat kubernetes/volumes/gitlab/config/initial_root_password
```

Beware that `initial_root_password` will automatically disappear after 24 hours!

Next, login with this password as user root at `http://localhost:32080`.
Change this password immediately in "User Settings" -> "Password" and relogin.

After You run GitLab for the first time, fix its configuration.
It needs the following conent in `/etc/gitlab/gitlab.rb`:

```
external_url 'http://localhost:32080'
nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['listen_addresses'] = ['*', '[::]']
```

For this, You can enter `kubernetes/` dir and run script `gitlab-config.sh`.

If You upload Your public key into Your GitLab account, You can clone a git repository via SSH port 32022 (as defined in `gitlab-services.yaml`) to the host.
This means, however, that an example SSH link hint from GitLab `git@localhost:gitlab-instance-a35f1f4f/my-2nd-project.git`, should in fact mean the following command in the host:

```
git clone ssh://git@localhost:32022/gitlab-instance-a35f1f4f/my-2nd-project.git
```
Note the protocol prefix `ssh://`, additional `:32022` port definition, and slash `/` instead of colon `:` before the resource path.

#### GitLab runners

Apart from the GitLab server, You need at least one GitLab runner to make CI/CD work (gitlab pipelines, as defined in `.gitlab-ci.yml` in git repositories stored by GitLab).

You can download a binary `https://s3.amazonaws.com/gitlab-runner-downloads/v15.7.0/binaries/gitlab-runner-linux-amd64` (amd set its execution flag, if necessary) to run on any Linux/x86_64 machine.

Next, register it:

```
./gitlab-runner-amd64 register --url http://localhost:30080 --registration-token <reg_token>
```

where `<reg_token>` is taken from "Admin Area" -> "Overview" -> "Runners" -> "Register an instance runner" drop-down list.

Finally, start the runner:

```
./gitlab-runner-amd64 register run
```

Instead of the above drop-in package with `gitlabb-runner` binaries, You can use...

### GitLab Runner

GitLab runner, provided here as a kubernetes service, must be registered with GitLab.
Run script:

```
./gitlab-runner-config.sh <reg_token> [<tag_list>]
```

where `<reg_token>` is the registration token disclosed to an administrator via GitLab UI,
and the optional `[<tag_list>]` is the list of tags associated with this GitLab runner.
This registration script also makes the GitLab runner accept untagged jobs.

### Redmine

Redmine UI can be reached from host at `http://localhost:32300`. On first login attempt, use username `admin` and password `admin`.
You will be immediately asked to change this default password.

Redmine is backed up by PostgreSQL database located internally on `jdbc:postgresql://redmine-db-service:5432/redminedb`, externally - on `jdbc:postgresql://localhost:31432/redminedb` (user `redmine`, password `redmine123`).

### SonarQube

SonarQube UI can be accessed from the host at `http://localhost:30900/sonarqube` or, locaaly, at `http://sonarqube-service:9100/sonarqube`. The default credentials on the first login are: username `admin` and password `admin`.
Immediately, after the first successful login with these credentials, SonarQube asks to change them.
If You encounter a strange behaviour of SonarQube UI, clean the cookies in Your browser.

SomarQube is backed up by PostgreSQL database located internally on `jdbc:postgresql://sonarqube-db-service:5432/sonarqube`, externally - on `jdbc:postgresql://localhost:30432/sonarqube` (user `sonar`, password `sonar123`).

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
