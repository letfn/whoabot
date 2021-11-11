SHELL := /bin/bash

first_ = $(word 1, $(subst _, ,$@))
second_ = $(word 2, $(subst _, ,$@))

warm:
	docker pull "$(shell cat params.yaml | yq -r .base_upstream_source)$(variant)"
	docker tag "$(shell cat params.yaml | yq -r .base_upstream_source)$(variant)" "$(shell cat params.yaml | yq -r .base_source)$(variant)"
	docker push "$(shell cat params.yaml | yq -r .base_source)$(variant)"

submit:
	$(MAKE) submit_base
	$(MAKE) submit_{app,ci}
	$(MAKE) submit_{aws,terraform,cdktf}

cue: o/argo.yaml
	#git diff o/argo.yaml

o/argo.yaml: argo.cue schema.cue
	cue eval --out yaml > o/argo.yaml

submit_%: o/argo.yaml
	argo submit --log -f params.yaml --entrypoint build-$(second_) o/argo.yaml