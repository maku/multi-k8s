
# docker build images with 2 tags (latest and with git sha)
docker build -t makuat/multi-client:latest -t makuat/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t makuat/multi-server:latest -t makuat/multi-server:$SHA -f ./server/Dockerfile  ./server
docker build -t makuat/multi-worker:latest -t makuat/multi-worker:$SHA -f ./worker/Dockerfile  ./worker

# We are already logged in docker (because of .travis.yml before_install)
docker push makuat/multi-client:latest
docker push makuat/multi-server:latest
docker push makuat/multi-worker:latest

docker push makuat/multi-client:$SHA
docker push makuat/multi-server:$SHA
docker push makuat/multi-worker:$SHA


# kubectl is already configured (in .travis.yml glcoud stuff)
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=makuat/multi-client:$SHA
kubectl set image deployments/server-deployment server=makuat/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=makuat/multi-worker:$SHA

kubectl set image deployment/client-deployment client=makuat/multi-client:v5
