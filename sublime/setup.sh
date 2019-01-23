#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
BASE_DIR="$(realpath ~/Library/Application\ Support/Sublime\ Text\ 3)"
INSTALLED_PACKAGES_DIR="$BASE_DIR/Installed Packages"
USER_PREFERENCES_DIR="$BASE_DIR/User"

info "Setting up Sublime Text 3"

substep_info "Creating Sublime Text 3 folders..."
mkdir -p "$BASE_DIR"

substep_info "Installing Package Control"
mkdir -p $INSTALLED_PACKAGES_DIR
# Install Package Control
cd $INSTALLED_PACKAGES_DIR && { curl -sLO https://packagecontrol.io/Package\ Control.sublime-package ; cd -; }

substep_info "Installing User Preferences"
mkdir -p $USER_PREFERENCES_DIR
find * -not -name "$(basename ${0})" -type f | while read fn; do
  symlink "$SOURCE/User/$fn" "$USER_PREFERENCES_DIR/$fn"
done

success "Finished setting up Sublime Text 3"
