#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"
. ../scripts/functions.sh

mkdir -p ~/.config/karabiner

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.config/karabiner)"

info "Configuraing karabiner..."

find . -name "*.yue" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

success "Finished configuring karabiner."
