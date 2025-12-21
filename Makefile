.PHONY: server
server:
	hugo -D server --config config_dev.toml

.PHONY: dev
dev:
	go install github.com/gohugoio/hugo@v0.153.0
