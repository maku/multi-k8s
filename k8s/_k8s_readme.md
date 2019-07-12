worker does not need a service file because no service needs access to it

# Infos

## Secrets for DB

A secret needs to be created imperatively

`kubectl create secret generic pgpassword --from-literal PGPASSWORD=complex`

Im postgres-deployment.yaml this secret is used for an env variable 'PGPASSWORD' used for database creation 

In server-deployment.yaml this secret is also used for an env variable 'PGPASSWORD' 

IN both cases it is referenced with the secret name 'pgpassword' and the secrete key 'PGPASSWORD'.
 
 
 ## Ingress

Ingress is for routing rules to get traffict to services

We are NOT using kubernetes-ingress, a project led by the company nginx
github.com/nginxinc/kubernetes-ingress

 
 
 
We are using ingress-nginx, a community led project
github.com/kubernetes/ingress-nginx
https://www.joyfulbikeshedding.com/blog/2018-03-26-studying-the-kubernetes-ingress-system.html

Whe have to apply for locally config:
`
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml
` 

The file ingress-service.yaml defines the rules for routing



## Dashboard 

Install dashboard 

See:
* http://collabnix.com/kubernetes-dashboard-on-docker-desktop-for-windows-2-0-0-3-in-2-minutes/
* https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/


Start proxy for serving 
`kubectl proxy`

Link for accessing the dashboard: 
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default


# Travis Config File
* Install Google Cloud SDK CLI
* Configure the SDK without Google Cloud auth info
* Login to Docker CLI
* Build the 'test' version of multi-client
* Run tests
* If tests are successful, run a script to deploy newest images
* Build all our images, tag each one, push each to docker hub
* Apply all configs in the 'k8s' folder
* Imperatively set latest images on each deployment


 
 
 
# GKE
 
Using martingcp@gmx.at account 
 
Create a cluster on https://console.cloud.google.com/kubernetes
 
* Location type **Zonal**
* Zone **europe-west3-b**
* Node Pool
    * Number of nodes: 3
    * Default (1vCPU, 3.75GB memory)  (costs * Number of nodes )
 
 
 
## Creating a service account 

https://console.cloud.google.com/iam-admin/serviceaccounts -> Create service account :
* Name: e.g. travis-deployer 
* Role: Kubernetes Engine Admin

-> Create Key: Key type "JSON" -> results in a file which has to kept private 



## Installing Travis CLI and upload 
e.g. for using the account with **travisci**
 
Download service account credentials in a json file
 
Download and install Travis CLI. Because of the CLI needs ruby we run in via a docker container

### Using ruby docker image
Linux: `docker run -it -v ${pwd}:/app ruby:2.3 sh`

In a windows system we have to copy the necessary files to the users directory 
Windows: `docker run -it -v c:/Users:/app ruby:2.3 sh`

After running we are seeing a shell.

There should be the json file with GCP credentials available (e.g. named as gcp-secret-account.json) 
 
Then we install travis:

`
gem install travis
travis -> no shell completion installation
travis login -> (login with github user data)
`

With Windows OS: create a new folder an copy the json file to the new folder (because of permission issues with docker?)

in a new directory e.g. 'encrypt' execute 
`
travis encrypt-file gcp-service-account.json -r maku/multi-k8s --org 
` 

After encrypting you get a message "openssl aes-256-...". This has to be copied to .travis.yml (before_install step -> first cmd)

Then gcp-service-account.json should be deleted. gcp-service-account.json.enc should be in the root directory
(on windows we have to copy it from the container (at least at 2019-07))
`docker cp <containerId>:/file/path/within/container /host/path/target`




 
Encrypt and upload the json file to our Travis account

In travis.yml, add code to unencrypt the json file and load it into GCloud SDK   
