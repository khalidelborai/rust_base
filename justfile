set shell := ["zsh", "-cu"]

prepare:
    chmod +x ./scripts/*.zsh

docs: prepare
    ./scripts/docs.zsh

release-start: prepare
    ./scripts/release-start.zsh
