worker does not need a service file because no service needs access to it


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



 
 
