
all: up build

up:
	vagrant up

build:
	vagrant ssh -c 'docker build -t digibib/biblio-sip2 /vagrant' | tee -a build.log

run_proxy:
ifndef LISTEN_HOST_PORT
	@echo "You must specify LISTEN_HOST_PORT"
	exit 1
endif

ifndef SIPSERVER_HOST_PORT
	@echo "You must specify SIPSERVER_HOST_PORT"
	exit 1
endif
	vagrant ssh -c 'docker run --rm -e "LISTEN_HOST_PORT=$(LISTEN_HOST_PORT)" -e "SIPSERVER_HOST_PORT=$(SIPSERVER_HOST_PORT)" digibib/biblio-sip2'

login: # needs EMAIL, PASSWORD, USERNAME
	@ vagrant ssh -c 'sudo docker login --email=$(EMAIL) --username=$(USERNAME) --password=$(PASSWORD)'

tag = "$(shell git rev-parse HEAD)"
push:
	@echo "======= PUSHING CONTAINER ======\n"
	vagrant ssh -c 'sudo docker tag digibib/biblio-sip2 digibib/biblio-sip2:$(tag)' | tee -a build.log
	vagrant ssh -c 'sudo docker push digibib/biblio-sip2' | tee -a build.log

clean:
	vagrant destroy --force
