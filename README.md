# Addo Demo

As an SRE I would like to know when a CVE is published that may affect important Software I use. 

This repo contains all configuration and scripts to solve this problem. This demo was created to demonstrate unique tools for five key areas an SRE is required to deal with on a day-to-day basis tackling multi cloud. The demo was presented in a presentation titled Multi Cloud "Day-to-Day" DevOps Power Tools. Information about the presentation can be found [here](https://www.alldaydevops.com/addo-speakers/ronen-freeman).


## Details

### Code

A bash script created in `cmd/run.sh` pulls the latest CVE list from the NVD and searches each CVE matching a keyword in the description. This CVE id is then logged.

### Package

A `Dockerfile` packages the script along with its dependencies into a Docker image able to run on any system.

### Deliver

Concourse is used to deliver the code to the platform. Three files are defined to create a `pipeline`. `ci/scripts/deploy.sh`, `ci/tasks/deploy.yml` and `ci/pipeline.yml`.

### Platform

The `GKE` cluster is setup using `terraform`. the scripts are found in `terraform` directory. A single master and two node pools are created in a subnet and vpc accross two availability zones in a single region.


### Monitor

Since the cluster is created in GKE in the GCP ecosystem, monitoring and logging is easily tied in with GCP stackdriver


## Setup


### 1. Prereqruisites

- terraform
- docker
- jq
- unzip
- curl
- kubectl
- Create a GCP service account with least permisions:
    - Compute Network Admin (gcp vpc and subnet)
    - Kubernetes Engine Cluster Admin (gcp gke)
    - Service Account User (gcp gke nodepools)
    - container.cronJobs.get (k8s cronjob)
    - container.cronJobs.create (k8s cronjob)
    - container.cronJobs.update (k8s cronjob)
    - Logs Writer (stack driver monitoring/logging)
    - Monitoring Metric Writer (stack driver monitoring/logging)
    - Stackdriver Resource Metadata Writer (stack driver monitoring/logging)

### 2. Provision Platform

```
cd terraform
terraform init
terraform apply
```

### 3. Setup Concourse

`helm install -f values.yaml --name concourse --namespace utils stable/concourse`    

### 4. Create and push to repo

Create a github repo, commit to the repo and push to the repo.

### 5. Create Concourse pipeline

[Recommended Concourse tutorial by Stark & Wayne.](https://concoursetutorial.com/)

```
fly -t <target> sp -c ci/pipeline.yml -p addo-demo
fly -t <target> unpause-pipeline -p addo-demo
```

### 6. Get info on cronjob

```
kubectl get cronjobs
kubectl describe cronjob addo-demo
kubectl get pods
kubectl log <pod_name> -f
```

### 7. Cleanup

```
fly -t <target> destroy-pipeline -p addo-demo
cd terraform
terraform destroy
```

## Some Notes

- This is a very basic representation of a complete software cycle. It should not be used in any production systems. It can be used as a basis and extended upon.
- There is probably smaller configurations that the user will need to do themselves that are not detailed here. This setup wont necessarily work "out of the box"