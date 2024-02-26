# kubernetes training project

source [video](https://youtu.be/U7FoyJVSH-c?si=3suC4sogaF94CenR)

github [repository](https://github.com/ktsstudio/devops_k8s_deploy_webinar)

## Install minikube and kubectl

I use [kubectl](https://kubernetes.io/docs/reference/kubectl/), [minikube](https://minikube.sigs.k8s.io/docs/start/)

[here](https://minikube.sigs.k8s.io/docs/handbook/config/) is a documentation to configure minikube.

On MacOS at School21 campus i had to use `export MINIKUBE_HOME="/opt/goinfre/celestiv/"`,

but it still would not start. If i was able to 


## push docker image to docker hub

[instruction](https://docs.docker.com/reference/cli/docker/image/push/)

I am using my username from school 21: celestiv

1. We need to create dockerfile, build an image from it. Image should contain username from dockerhub.
For example: `celestiv/http-server`
2. log in to docker account
`docker login -u celestiv`
3. run a container from the image
4. run `docker ps` to see containers ID and copy it
5. `docker container commit <container ID> <image ID>`
Example: `docker container commit rtehtrhh45 celestiv/http-server`
6. `docker push <image ID>`
Example: `docker push celestiv/http-server`
7. 