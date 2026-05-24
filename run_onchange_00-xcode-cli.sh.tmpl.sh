#!/bin/bash

{{ if eq .chezmoi.os "darwin" -}}
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
fi
{{ end -}}
