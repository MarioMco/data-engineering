### Set up Apache Airflow on AWS EKS with the Kubernetes Executor

Before we start with setup make suer you have:

- AWS Account
- Github account

## AWS

### Cloud9

AWS Cloud9 is an integrated development environment (IDE). It provides a cloud-based environment for software development, allowing developers to write, test, and debug code without needing to set up and manage their own development environments.

- Go to Cloud9
- Click on `Create environment`, give a name. Leave everything as it's set by default and at the bottom click on create.
- Once when the workstation is ready click `Open` and you are ready for work.

#### Configuring the workstation

In the Cloud9 terminal run commands from below:

- Update packages of the instance: `sudo yum -y update`
- Create a python virtual environment: `python -m venv .sandbox`
- Active the python virtual environment: `source .sandbox/bin/activate`
- Upgrade pip: `pip install --upgrade pip`
- Download and extract the latest release of eksctl with the following command: `curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp`
- `sudo mv /tmp/eksctl /usr/local/bin`
- Check if the installation was successful: `eksctl version`
- Download the latest release of Kubectl with the command: `curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.8/bin/linux/amd64/kubectl`
- Make the kubectl binary executable: `chmod +x ./kubectl`
- Move the binary in to your PATH: `sudo mv ./kubectl /usr/local/bin/kubectl`
- Test to ensure the version you installed is up-to-date: `kubectl version --client`
- Install Helm3: `curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash`
- Check the version: `helm version --short`
- Download the stable repo: `helm repo add stable https://charts.helm.sh/stable`
- Config git: `git config --global user.name "airflow-workstation"`

#### Configuring Cloud9 with the Admin account

- activate python environment: `source .sandbox/bin/activate`
- upgrade aws cli: `pip install --upgrade awscli && hash -r`
- install some utilities: `sudo yum -y install jq gettext bash-completion moreutils`

Outside of the terminal go the settings, AWS settings and turn off temporary credentials:

- Cloud9 Prefrences -> AWS Settings and then uncheck: `AWS managed temporary credentials`
- Close Prefrences

Go back to terminal:

- remove temporary credentials: `rm -vf ${HOME}/.aws/credentials`
- configure aws env variables. The following get-caller-identity example displays information about the IAM identity used to authenticate the request: `aws configure`
  - AWS Access Key ID [None]: `<put_your_access_key_id>`
  - AWS Secret Access Key [None]: `<put_your_secret_key>`
  - Default region name [None]: `<put_your_region>`
  - Default output format [None]: `json`
- `aws sts get-caller-identity`
  - `export ACCOUNT_ID=<Account>`. We'll get Account with command we run before.
  - `export AWS_REGION=<put_your_region>`
- update the file bash_profile and configure aws:
  - `echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile`
  - `echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile`
  - `aws configure set default.region ${AWS_REGION}`
  - `aws configure get default.region`

## Github

### Create Github repository

- Go to Github and click on: `Create Repository`
- Put the repository name: `airflow-eks-config`
- Set repository to: `Private`
- Click on: `Create Repository`

Now go back to Cloud9 workstation.

### Cloud9

- Create ssh key: `ssh-keygen -t rsa`
- Copy the ssh key: `cat /home/ec2-user/.ssh/id_rsa.pub`
- Go back to Github account.

### Github

Add SSH key to Github.

- Profil -> Settings -> SSH and GPG keys -> New SSH Key
- Title: `airflow-workstation`
- Key: `<paste_ssh_key>`
- Click on: `Add SSH key`

### Cloud9

#### Creating Cluster with eksctl

- Create Key Pair in the EC2. Go to Cloud9 terminal and run: `aws ec2 import-key-pair --key-name "airflow-workstation" --public-key-material fileb:///home/ec2-user/.ssh/id_rsa.pub`
- Install aws-iam-authenticator: `curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64`
- `chmod +x ./aws-iam-authenticator`
- `mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin`
- `echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc`
- After you run this command. If you see the output it means everything was done successfully: `aws-iam-authenticator help`
- Install AWS V2:
  - `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
  - `unzip awscliv2.zip`
  - `sudo ./aws/install --update`

In the `cluster.yml` file update `region: <your_aws_region>`. Then upload file to Cloud9.

- Go to File -> Upload Local Files ... and add cluster.yml file.

- To create the cluster in the Cloud9 terminal run: `eksctl create cluster -f cluster.yml`
- Check if the cluster is healthy: `kubectl get nodes`
- Enable CloudWatch logging: `eksctl utils update-cluster-logging --enable-types=all --region=<your_aws_region> --cluster=airflow --approve`

#### Install Flux

- Run in the Cloud9 terminal: `curl -s https://fluxcd.io/install.sh | sudo bash`
- Check the version: `flux --version`

Before installing Flux go to Github:

- Profile -> Settings -> Developer Settings -> Personal Access Tokens -> Tokens (classic) -> Generate new token -> Generate new token (classic)
- Note: `airflow-eks-token`
- Check: `repo`
- At the bottom click on: `Generate token`
- Copy token
- Go to Cloud9 terminal and run: `export GITHUB_TOKEN=<your_github_token>`
- You can check your token wiht: `echo GITHUB_TOKEN`
- Configure flux with your Github repository: `flux bootstrap github \
--owner=<your_github_username> \
--repository=airflow-eks-config \
--branch=main \
--interval=15s \
--personal`
- If everything went OK you should see: all components are healthy
- Also in your Github repository new folder `flux-system` will be created.
- Now we'll create few folders. In your Github repository go to `Code` and copy `SSH` link.
  - Then go back to `Cloud9 terminal`, make sure you are in the folder `environment` and run: `git clone <your_github_SSH_link>`
  - `mkdir airflow-eks-config/{workloads,releases,namespaces}`
  - `find airflow-eks-config/ -type d -exec touch {}/.keep \;`
  - `cd airflow-eks-config`
  - `git add .`
  - `git commit -am "directory structure"`
  - `git push`

### Add Namespaces

- In the Cloud9 go to `airflow-eks-config/namespaces` folder and upload `dev.yml` file.
- Go to Cloud9 terminal and run:
  - `git add .`
  - `git commit -am "add a new namespace"`
  - `git push`
- Check if namespace has been created: `kubectl get namespaces`
- Go to `namespaces` folder and duplicate `dev.yml` file twice. Rename it to `prod.yml` and `staging.yml` and in the files update to `name: prod` and `name: staging`
- Repeat git commands from before and push changes to Github. Check if namespaces are created with: `kubectl get namespaces`

#### Install EBS Driver

- If you want to check it, you can find more information here: `https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md`
- To install it, go to Cloud9 terminal and run:
  - `helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver`
  - `helm repo update`
  - `helm upgrade --install aws-ebs-csi-driver --namespace kube-system aws-ebs-csi-driver/aws-ebs-csi-driver`
- To verify that aws-ebs-csi-driver has started, run: `kubectl get pod -n kube-system -l "app.kubernetes.io/name=aws-ebs-csi-driver,app.kubernetes.io/instance=aws-ebs-csi-driver"`

### Setting up the Helm repo

- Go to Cloud9 File -> Upload Local files ... and upload `Sources` folder with `airflow-repo.yml` file in it to the `airflow-eks-config` folder.
- Then push it to Github:
  - `git add .`
  - `git commit -am "sources"`
  - `git push`
- Run: `flux get all` and you should see: `helmrepository/apache-airflow`
- Go to Cloud9 File -> Upload Local files ... and upload `releases` folder with `airflow-dev.yml` file in it to the `airflow-eks-config` folder.
- Then push it to Github:
  - `git add .`
  - `git commit -am "new releas"`
  - `git push`
- To check if there were any errors run: `flux logs --follow --level=error --all-namespaces`
- Check if everythin runs perfectly: `kubectl get pods -n dev`
- In the `airlfow-dev.yml` add from pic below:

<img src="pics/dags_sync.png" alt="Dags Sync" title="Dags Sync">

- Then push it to Github:
  - `git add .`
  - `git commit -am "gitsync enabled"`
  - `git push`
- To check if there were any errors run: `flux logs --follow --level=error --all-namespaces`
- If you run: `kubectl get pods -n dev` you should see that scheduler now has 3 pods.
- To get inside of Scheduler container run: `kubectl exec -it <name> -n dev -c scheduler -- /bin/bash`
- Once when inside if we run: `airflow dags list` we should see list with `parallel_dag.py`

### Fetching DAGs with GitSync from a private repository

- Go to Github and create new private repository: `airflow-private-dags` for example.
- Go to Cloud9 terminal and create new SSH Key: `ssh-keygen -t rsa -b 4096`
- Give a name: `private-git`
- In the Cloud9 on the left side `private-git.pub` file will apear. Open it and copy the key.
- Go to `airflow-private-dags` repository we just created. Settings -> Deploy keys -> Add new:
  - Title: `git-private-eks`
  - Key: paste the key we just copied from the `private-git.pub`
  - Check: `Allow write access`
  - Click on Add key
- Go to Cloud9 terminal and run: `base64 private-git -w 0 > tmp.txt`
- Go to the `relases` folder and open `airflow-dev.yml` file. Go to the `airflow-private-dags` repository and copy SSH link. In the `airflow-dev.yml` replace existing github link at the `repo:` with new SSH link we just copied.
- Add new things from the picture below. You can find `gitSshKey` in the tmp.txt file.
  <img src="pics/Secrets.png" alt="Secrets" title="Secrets">
- Go to Cloud9 terminal: `cd airlfow-eks-config` and push changes to the Github:
  - `git add .`
  - `git commit -am "new gitsync with private repo"`
  - `git push`
- To check if there were any errors run: `flux logs --follow --level=error --all-namespaces`
- To check if everything went OK:
  - `kubectl get pods -n dev`
  - To get inside of Scheduler container run: `kubectl exec -it <name> -n dev -c scheduler -- /bin/bash`
  - Once when inside if we run: `airflow dags list` we should see list with `private_dag.py`

## CI/CD Pipeline

- Fork `https://github.com/marclamberti/airflow-eks-docker` repository.
- In the Github create two new branches: `dev` and `staging`
- Go to Settings -> Developer settings -> Personal access tokens -> Generate new token:
  - Note: `dev-airflow-codepipeline`
  - Check: `repo`
  - Click on `Generate token`
  - Copy Token

Go to the Cloud9 and run in terminal:

- Create the S3 bucket for the CodePipeline artifacts - This bucket must be globally unique so set your own: `aws s3 mb s3://airflow-dev-codepipeline-artifacts-besto`
- Create IAM roles and add iniline policies so that CodePipeline can interact with EKS through kubectl:
  - `aws iam create-role --role-name AirflowCodePipelineServiceRole --assume-role-policy-document file://airflow-materials-aws/section-6/code-pipeline cpAssumeRolePolicyDocument.json`
  - `aws iam put-role-policy --role-name AirflowCodePipelineServiceRole --policy-name codepipeline-access --policy-document file://airflow-materials-aws/section-6/code-pipeline/cpPolicyDocument.json`
  - `aws iam create-role --role-name AirflowCodeBuildServiceRole --assume-role-policy-document file://airflow-materials-aws/section-6/code-pipeline/cbAssumeRolePolicyDocument.json`
  - `aws iam put-role-policy --role-name AirflowCodeBuildServiceRole --policy-name codebuild-access --policy-document file://airflow-materials-aws/section-6/code-pipeline/cbPolicyDocument.json`
- Go to IAM and check if `AirflowCodePipelineServiceRole` and `AirflowCodeBuildServiceRole` exist.
- Go to `airflow-material-aws/section-6/code-pipeline/airflow-dev-pipeline.cfn.yml` and update `Location` under `ArtifactStore` to:`airflow-dev-codepipeline-artifacts-besto`
- In the `airflow-materials-aws/code-pipeline/airflow-dev-pipeline.cfn.yml` needs to update the code:
  <img src="pics/code_update.png" alt="Code update" title="Code update">
- Create the AWS CodePipeline using CloudFormation (This doesn't deploy the image as Flux handles it): `aws cloudformation create-stack --stack-name=airflow-dev-pipeline --template-body=file://airflow-materials-aws/section-6/code-pipeline/airflow-dev-pipeline.cfn.yml --parameters ParameterKey=GitHubUser,ParameterValue=<your_github_username> ParameterKey=GitHubToken,ParameterValue=<github_token_we_just_create> ParameterKey=GitSourceRepo,ParameterValue=airflow-eks-docker ParameterKey=GitBranch,ParameterValue=dev`
- Go to Cloud9 terminal and clone `airflow-eks-docker` repository.

  - `git checkout dev`
  - `git branch`
  - Do update on some file and push it.
  - AWS CodePipeline will execute again and AWS ECR will create new Docker image

- Go to Cloud9 and open `airflow-dev.yml` that is located in `airflow-eks-config/releases` folder:
  - Under the `values` info from AWS ECR (image_tag_id and image_URI) add:
    <img src="pics/image_tag.png" alt="image tag" title="image tag">
- Update this code as well:
  - `name: "AIRFLOW__KUBERNETES_EXECUTOR__WORKER_CONTAINER_REPOSITORY"`
    `value: "<image_tag_URI>"`
  - `name: "AIRFLOW__KUBERNETES_EXECUTOR__WORKER_CONTAINER_TAG"`
    `value: "<image_tag_id>"`
    <img src="pics/update_tag.png" alt="update tag" title="update tag">
- Remove things we don't need anymore:
  <img src="pics/remove.png" alt="remove" title="remove">

Token=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
