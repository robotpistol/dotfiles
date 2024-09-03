#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

mkdir -p ~/.hammerspoon
mkdir -p ~/.hammerspoon/Spoons

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.hammerspoon)"

info "Configuraing hammerspoon..."

find . -name "*.lua" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

cp -r "$SOURCE/Spoons/SpoonInstall.spoon" "$DESTINATION/Spoons/"

success "Finished configuring hammerspoon."
