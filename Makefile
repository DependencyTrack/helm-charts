CHART_DIR := charts/dependency-track
HELM_DOCS_IMAGE := jnorwood/helm-docs:v1.14.2
HELM_UNITTEST_IMAGE := helmunittest/helm-unittest:4.2.0-1.1.1
KUBECONFORM_IMAGE := ghcr.io/yannh/kubeconform:v0.8.0
HELM_UNITTEST_VERSION := 1.1.0

unit-test:
	docker run --rm -v "$(shell pwd)/$(CHART_DIR):/apps" $(HELM_UNITTEST_IMAGE) .
.PHONY: unit-test

lint:
	ct lint --config ct.yaml
.PHONY: lint

docs:
	docker run --rm -v "$(shell pwd):/helm-docs" -u "$(shell id -u)" $(HELM_DOCS_IMAGE) --chart-search-root $(CHART_DIR)
.PHONY: docs

kubeconform:
	@for f in $(CHART_DIR)/ci/*-values.yaml; do \
		echo "==> kubeconform $$f"; \
		helm template kc $(CHART_DIR) -f $$f \
		  | docker run --rm -i $(KUBECONFORM_IMAGE) -strict -summary -schema-location default \
		  || exit 1; \
	done
.PHONY: kubeconform
