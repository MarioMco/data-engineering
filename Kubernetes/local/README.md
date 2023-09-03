## Run Apache Airflow on Kubernetes

First we need to install all neccesery tools:

- [vscode](https://code.visualstudio.com/download)
- [Docker](https://docs.docker.com/get-docker/)
- [Kubernetes](https://kubernetes.io/releases/download/)
- [Kubernetes tools (kubectl & kind)](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

## Install Apache Airflow

1. Create folder
2. Go in the folder and create folder data and copy files: Dockerfile, kind-cluster.yaml, pv.yaml, pvc.yaml, requirements.txt, variables.yaml
3. Go at the top bar of Visual Studio Code -> Terminal -> New Terminal
4. Create cluster: `kind create cluster --name airflow-cluster --config kind-cluster.yaml`
5. Check cluster: `kubectl cluster-info --context kind-airflow-cluster`
6. Check nodes: `kubectl get nodes -o wide`
7. Create namespace: `kubectl create namespace airflow`
8. Check namespaces: `kubectl get ns`
9. Get Offical Airflow Helm Chart: `helm repo add apache-airflow https://airflow.apache.org`
10. Check helm repo list: `helm repo list`
11. Get the latest helm chart: helm repo update apache-airflow
12. Check all the helm versions for the airflow: `helm search repo airflow`
13. Deploy the ariflow: `helm install airflow apache-airflow/airflow --namespace airflow --debug --timeout 10m0s`
14. Check the instance (version and status): `helm ls -n airflow`
15. Check all the pods for the airflow: `kubectl get pods -n airflow`
16. Scheduler logs: `kubectl logs airflow-scheduler-6f48fc4d45-rqgtq -n airflow -c scheduler`
17. Airflow UI: `kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow`
18. Open your web browser and go to localhost:8080. You should Airflow Sign In page.
19. By default Username and Password is: admin

### Helm values.yaml file

- Create the file so we can configure Airflow: `helm show values apache-airflow/airflow > values.yaml`
- Go in the values.yaml file and update:
  - `executor: "KubernetesExecutor"`
  - ConfigMap connection (variables.yaml):
    ```
    - extraEnvFrom: |s
      - configMapRef:
        name: 'airflow-variables'
    ```
  - Apply variables to Kubernetes: `kubectl apply -f variables.yaml`. In variables.yaml we put variables instead in Airflow UI variables.
  - Upgrade airflow: `helm upgrade --install airflow apache-airflow/airflow -n airflow -f values.yaml --debug`
  - Open bash session of the container: `kubectl exec --stdin --tty pod_name -n airflow -- /bin/bash`

### Install your providers

In this example we'll use [https://registry.astronomer.io/](https://registry.astronomer.io/) to add [Great Expectations](https://registry.astronomer.io/providers/airflow-provider-great-expectations/versions/0.2.6).

- Create file `requirements.txt` and `airflow-provider-great-expectations==0.2.6`
- To avoid installing what's in the reuqirements.txt file every time when pods starts create `Dockerfile` and add code which will install everything from requirements.txt
- Build a Docker image: `docker build -t airflow-custom:1.0.0 .`
- Load the image: `kind load docker-image airflow-custom:1.0.0 --name airflow-cluster`
- In `values.yaml` update to:
  - `defaultAirflowRepository: airflow-custom`
  - `defaultAirflowTag: "1.0.0"`
- Upgrade airflow instance again: `helm upgrade --install airflow apache-airflow/airflow -n airflow -f values.yaml --debug`
- To check all airflow providers run this: `kubectl exec <airlow-webserver_name> -n airflow -- airflow info`

### GitHub - dags

To add dags in the airflow follow these steps:

- Create **private** GitHub repository. It has to be private.
- [Create SSH Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent):

  - Repository Settings >> Deploy Keys >> Add deploy key - Add Title and put public key

- Go to `values.yaml` and update:
  - `gitSync:`
    - `enabled: true`
    - `repo: ssh://git@github.com/MarioMco/local-ariflow-kub.git`
    - `branch: main`
    - `subPath: ""`
  - `kubectl create secret generic airflow-ssh-git-secret --from-file=gitSshKey=<sshkey_path>`
    - In `values.yaml` uncomment `sshKeySecret` and add: `sshKeySecret: airflow-ssh-git-secret`
- Check git-sync logs: `kubectl logs <pod_airflow_scheduler> -c git-sync -n airflow`
