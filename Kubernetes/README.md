Here is a list of useful Kubernetes commands:

1. Cluster Management:

- `kubectl cluster-info`: Display cluster information.
- `kubectl config use-context <context-name>`: Set the current context for kubectl.
- `kubectl config get-contexts`: List available contexts.
- `kubectl get nodes`: List all nodes in the cluster.
- `kubectl get namespaces`: List all namespaces in the cluster.

2. Pod Management:

- `kubectl get pods`: List all pods in the current namespace.
- `kubectl describe pod <pod-name>`: Display detailed information about a pod.
- `kubectl logs <pod-name>`: View logs of a pod.
- `kubectl exec -it <pod-name> -- <command>`: Execute a command in a running pod.
- `kubectl delete pod <pod-name>`: Delete a pod.

3. Deployment Management:

- `kubectl get deployments`: List all deployments in the current namespace.
- `kubectl describe deployment <deployment-name>`: Display detailed information about a deployment.
- `kubectl scale deployment <deployment-name> --replicas=<num-replicas>`: Scale a deployment.
- `kubectl rollout status deployment/<deployment-name>`: Check the status of a rollout.
- `kubectl rollout history deployment/<deployment-name>`: View rollout history.
- `kubectl rollout undo deployment/<deployment-name>`: Rollback a deployment.

4. Service Management:

- `kubectl get services`: List all services in the current namespace.
- `kubectl describe service <service-name>`: Display detailed information about a service.

5. ConfigMap and Secret Management:

- `kubectl get configmaps`: List all ConfigMaps in the current namespace.
- `kubectl get secrets`: List all secrets in the current namespace.

6. Namespace Management:

- `kubectl create namespace <namespace-name>`: Create a new namespace.
- `kubectl delete namespace <namespace-name>`: Delete a namespace and its resources.
- `kubectl get pods --namespace=<namespace-name>`: List pods in a specific namespace.

7. Resource Descriptions:

- `kubectl get <resource>`: List resources (e.g., pods, services, deployments).
- `kubectl describe <resource> <resource-name>`: Describe a specific resource.

8. Port Forwarding:

- `kubectl port-forward <pod-name> <local-port>:<remote-port>`: Forward ports from a pod to your local machine.

9. Context Switching:

- `kubectl config use-context <context-name>`: Switch between different clusters or contexts.

10. Resource Deletion:

- `kubectl delete <resource> <resource-name>`: Delete a specific resource.

11. Apply Configuration:

- `kubectl apply -f <file-or-directory>`: Apply a configuration from a file or directory.

12. Rolling Updates and Rollbacks:

- `kubectl set image deployment/<deployment-name> <container-name>=<new-image>`: Update a container image.
- `kubectl rollout undo deployment/<deployment-name>`: Rollback a deployment to the previous state.
