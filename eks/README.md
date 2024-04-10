# Portfolio App Deployment on Amazon EKS

This repository contains YAML files for deploying a portfolio application on Amazon Elastic Kubernetes Service (EKS). The application is composed of a backend MySQL database and a frontend web server.

## Prerequisites

Before deploying the application, make sure you have the following:

- An AWS account with permissions to create EKS clusters and related resources.
- `kubectl` installed locally for interacting with the Kubernetes cluster.
- `eksctl` installed for creating and managing EKS clusters.

## Setup

**1. Create an EKS Cluster:**

   Use `eksctl` to create a new EKS cluster.
   ```bash
   eksctl create cluster --name cluster --version 1.29 --nodegroup-name standard-workers --node-type t2.large --nodes 1 --nodes-min 1 --nodes-max 1 --region=us-west-1
   ```
   Setup kubeconfig to new EKS cluster.
   ```bash
   aws eks --region us-west-1 update-kubeconfig --name cluster
   ```

**2. Create GitHub Docker Registry Secret**

   Run the following command to create a Kubernetes secret named github for accessing the GitHub Docker registry:
   ```bash
   kubectl create secret docker-registry github \
        --docker-server=ghcr.io \
        --docker-username=$MYGITHUB_USERNAME \
        --docker-password=$MYGITHUB_PASSWORD \
        --docker-email=your_email@example.com
   ```

   Replace $MYGITHUB_USERNAME with your GitHub username , $MYGITHUB_PASSWORD with your GitHub Personal Access Token or password and your_email@example.com with your email id.

   Once the secret is created, you can obtain the encoded credentials and update your YAML file.

   ```bash
   kubectl get secret github -o jsonpath="{.data.\.dockerconfigjson}" | base64 --decode
   ```

   Copy the decoded output and update the github_secret.yaml file with the new .dockerconfigjson value.
   
**3. Update Secret Values**

   Follow these steps to update the secret values in the app-secret.yaml file.
    
   * Base64 Encode Values:
    
       Use a base64 encoder to encode your sensitive values. You can use online tools, command-line tools, or programming languages like Python to do this.
    
       Repeat this step for each value you need to encode.
    
  * Update YAML File:
    
       Open the app-secret.yaml file.
       Replace the existing base64 encoded values with your newly encoded values.
    
  * Apply Changes:
    
       Save the changes to the app-secret.yaml file.
       Apply the updated secret to your Kubernetes cluster:
      
       ```bash
       kubectl apply -f app-secret.yaml
       ```
   Make sure to apply the changes to your Kubernetes cluster to update the secret with the new values.

Follow similar steps to update secret values in mysql-secret.yaml file.

**4. Apply YAML Files**

After updating the secret values, apply each YAML file in the following order:

- MySQL Resources:

  - Apply MySQL PersistentVolumeClaim (PVC):
    ```bash
    kubectl apply -f mysql_pvc.yaml
  
  - Apply MySQL Deployment:
    ```bash
    kubectl apply -f mysql_deployment.yaml

  - Apply MySQL Service:
     ```bash
     kubectl apply -f mysql_svc.yaml

- MySQL Initialization SQL ConfigMap:
   - Apply MySQL Initialization SQL ConfigMap:
     ```bash
     kubectl apply -f mysql_initsql_configmap.yaml
     
- MySQL PersistentVolume:
  - Apply MySQL PersistentVolume:
    ```bash
    kubectl apply -f mysql_pv.yaml

- MySQL Secret:
   - Apply MySQL Secret:
     ```bash
     kubectl apply -f mysql_secret.yaml
     
- MySQL Horizontal Pod Autoscaler (Optional):
   - Apply MySQL Horizontal Pod Autoscaler:
     ```bash
     kubectl apply -f mysql_hpa.yaml

- Application Resources:
   - Apply Application Secret:
     ```bash
     kubectl apply -f app_secret.yaml

   - Apply Application Deployment:
     ```bash
     kubectl apply -f app_deployment.yaml

   - Apply Application Service:
     ```bash
     kubectl apply -f app_svc.yaml

- Application Horizontal Pod Autoscaler (Optional):
   - Apply Application Horizontal Pod Autoscaler:
     ```bash
     kubectl apply -f app_hpa.yaml
     
- GitHub Docker Registry Secret (if not applied earlier):
   - Apply GitHub Docker Registry Secret:
     ```bash
      kubectl apply -f github_secret.yaml

After applying all the YAML files, your application should be deployed and running on your Kubernetes cluster.

**5. Verification**

Check Pods Status:
```bash
kubectl get pods
```
Ensure that all pods are in the Running state.

Check service status. Locate the Load Balancer service and note its DNS name.
```bash
kubectl get svc
```

**6. Accessing the website**
   
Access Website:

Use the load balancer DNS name to form the website URL:

Website URL: 
```bash
http://loadbalancer_dns_name:80/portfolio/index.html
```
Visit the provided URL to access your live website.

## Contributing

Contributions to PortfolioSetup are welcome! Feel free to open issues for feature requests or bug reports, and submit pull requests for proposed changes.

## License

This project is licensed under the [MIT License](LICENSE).
