####################################################
## kubectl example
####################################################
.PHONY: all
all: help

.PHONY: help
help:
	@echo "Usage: make <sub-command>"
	@echo "\n---------------- sub-command list ----------------"
	@cat Makefile | grep -e "^.PHONY:" | grep -v "all" | cut -f2 -d' '

.PHONY: get-cluster
get-cluster:
	@kubectl config get-clusters

.PHONY: debug-pod
debug-pod:
	kubectl apply -f debug/pod.yaml 

.PHONY: pull-image
pull-image:
	docker pull public.ecr.aws/risken/aws/access-analyzer:latest
	@sleep 1 && docker pull public.ecr.aws/risken/risken-core:latest
	@sleep 1 && docker pull public.ecr.aws/risken/risken-datasource-api:latest
	@sleep 1 && docker pull public.ecr.aws/risken/aws/admin-checker:latest
	@sleep 1 && docker pull public.ecr.aws/risken/aws/cloudsploit:latest
	@sleep 1 && docker pull public.ecr.aws/risken/aws/guard-duty:latest
	@sleep 1 && docker pull public.ecr.aws/risken/aws/portscan:latest
	@sleep 1 && docker pull public.ecr.aws/risken/code/gitleaks:latest
	@sleep 1 && docker pull public.ecr.aws/risken/code/dependency:latest
	@sleep 1 && docker pull public.ecr.aws/risken/diagnosis/wpscan:latest
	@sleep 1 && docker pull public.ecr.aws/risken/diagnosis/portscan:latest
	@sleep 1 && docker pull public.ecr.aws/risken/diagnosis/applicationscan:latest
	@sleep 1 && docker pull public.ecr.aws/risken/gateway/gateway:latest
	@sleep 1 && docker pull public.ecr.aws/risken/gateway/web:latest
	@sleep 1 && docker pull public.ecr.aws/risken/google/asset:latest
	@sleep 1 && docker pull public.ecr.aws/risken/google/cloudsploit:latest
	@sleep 1 && docker pull public.ecr.aws/risken/google/portscan:latest
	@sleep 1 && docker pull public.ecr.aws/risken/google/scc:latest
	@sleep 1 && docker pull public.ecr.aws/risken/middleware/db:latest
	@sleep 1 && docker pull public.ecr.aws/risken/middleware/queue:latest
	@sleep 1 && docker pull public.ecr.aws/risken/osint/subdomain:latest
	@sleep 1 && docker pull public.ecr.aws/risken/osint/website:latest

## local #############################################
.PHONY: local-switch
local-switch:
	@kubectl config use-context docker-desktop

generator := genarate_confimap_properties.sh
generator_template := genarate_confimap_properties_sample.sh
generator_exists := $(shell find -f $(generator))

define message
	@echo "message: found $(generator)"
endef

define copy_template
	@cp $(generator_template) $(generator)
endef

.PHONY: local-setting
local-setting: local-switch
	$(if $(generator_exists), $(message), $(copy_template))
	sh genarate_confimap_properties.sh

.PHONY: local-build
local-build: local-switch local-setting
	kustomize build overlays/local

.PHONY: local-apply
local-apply: local-build
	kustomize build overlays/local | kubectl apply -f -

.PHONY: local-delete
local-delete: local-switch 
	kustomize build overlays/local | kubectl delete -f -

.PHONY: local-db
local-db: local-switch
	kubectl -n middleware exec -it db-0 -- mysql -uroot -Dmimosa --default-character-set=utf8

## EKS #############################################
.PHONY: eks-build
eks-build:
	kustomize build overlays/eks

.PHONY: eks-apply
eks-apply: eks-build
	kustomize build overlays/eks | kubectl apply -f -

.PHONY: eks-delete
eks-delete:
	kustomize build overlays/eks | kubectl delete -f -
