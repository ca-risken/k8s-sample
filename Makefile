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
	kubectl kustomize overlays/local

.PHONY: local-apply
local-apply: local-build
	kubectl apply -k overlays/local

.PHONY: local-delete
local-delete: local-switch 
	kubectl delete -k overlays/local

.PHONY: local-db
local-db: local-switch
	kubectl -n middleware exec -it db-0 -- mysql -uroot -Dmimosa --default-character-set=utf8

## EKS #############################################
.PHONY: eks-build
eks-build:
	kubectl kustomize overlays/eks

.PHONY: eks-apply
eks-apply: eks-build
	kubectl apply -k overlays/eks

.PHONY: eks-delete
eks-delete:
	kubectl delete -k overlays/eks
