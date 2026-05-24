#!/bin/bash

{{ if eq .chezmoi.os "darwin" -}}

# duti uses bundle IDs and UTI types
# Format: duti -s <bundle_id> <UTI/extension> <role>
# Roles: all, viewer, editor, shell

# Text/code files → VS Code
duti -s com.microsoft.VSCode .txt editor
duti -s com.microsoft.VSCode .md editor
duti -s com.microsoft.VSCode .json editor
duti -s com.microsoft.VSCode .yaml editor
duti -s com.microsoft.VSCode .yml editor
duti -s com.microsoft.VSCode .toml editor
duti -s com.microsoft.VSCode .sh editor
duti -s com.microsoft.VSCode .zsh editor
duti -s com.microsoft.VSCode .py editor
duti -s com.microsoft.VSCode .go editor
duti -s com.microsoft.VSCode .rb editor
duti -s com.microsoft.VSCode .rs editor
duti -s com.microsoft.VSCode .lua editor
duti -s com.microsoft.VSCode .ex editor
duti -s com.microsoft.VSCode .exs editor
duti -s com.microsoft.VSCode .csv editor
duti -s com.microsoft.VSCode .xml editor
duti -s com.microsoft.VSCode .conf editor
duti -s com.microsoft.VSCode .cfg editor
duti -s com.microsoft.VSCode .env editor
duti -s com.microsoft.VSCode .log viewer
duti -s com.microsoft.VSCode .css editor
duti -s com.microsoft.VSCode .html editor
duti -s com.microsoft.VSCode .js editor
duti -s com.microsoft.VSCode .ts editor
duti -s com.microsoft.VSCode .jsx editor
duti -s com.microsoft.VSCode .tsx editor
duti -s com.microsoft.VSCode .sql editor
duti -s com.microsoft.VSCode .graphql editor
duti -s com.microsoft.VSCode .dockerfile editor
duti -s com.microsoft.VSCode .tf editor
duti -s com.microsoft.VSCode .hcl editor
duti -s com.microsoft.VSCode .swift editor
duti -s com.microsoft.VSCode .c editor
duti -s com.microsoft.VSCode .h editor
duti -s com.microsoft.VSCode .cpp editor
duti -s com.microsoft.VSCode .makefile editor
duti -s com.microsoft.VSCode .gitignore editor

# Video → VLC
duti -s org.videolan.vlc .mp4 viewer
duti -s org.videolan.vlc .mkv viewer
duti -s org.videolan.vlc .avi viewer
duti -s org.videolan.vlc .mov viewer
duti -s org.videolan.vlc .webm viewer
duti -s org.videolan.vlc .m4v viewer
duti -s org.videolan.vlc .flv viewer

{{ end -}}
