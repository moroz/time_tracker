#!/usr/bin/env bash

# Deploy app to local server

export MIX_ENV=prod
APP_NAME=time_tracker
RELEASE_NAME=$APP_NAME

DEPLOY_USER=ubuntu
APP_GROUP=app

DESTDIR="/usr/local/lib/$APP_NAME/"
CURRENT_LINK="${DESTDIR}current"

# Exit on errors
set -e
# set -o errexit -o xtrace

CURDIR="$PWD"
BINDIR=$(dirname "$0")
cd "$BINDIR"; BINDIR="$PWD"; cd "$CURDIR"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
RELEASE_DIR="${DESTDIR}releases/${TIMESTAMP}"
RELEASE_TAR="_build/prod/$RELEASE_NAME-0.1.0.tar.gz"

mkdir -p "$RELEASE_DIR"
tar -C "$RELEASE_DIR" -xf "$RELEASE_TAR"
sudo chown -R ${DEPLOY_USER}:${APP_GROUP} "${RELEASE_DIR}"

if [[ -L "$CURRENT_LINK" ]]; then
    rm "$CURRENT_LINK"
fi
ln -s "$RELEASE_DIR" "$CURRENT_LINK"
echo "===> Setting file permissions for release executables"
# Ensure that app OS user can use group permissions to execute files in release

chown -R $DEPLOY_USER:$APP_GROUP "$CURRENT_LINK"
find -H $CURRENT_LINK -executable -type f -exec chmod g+x {} \;

BASEDIR="$BINDIR/.."
cd "$BASEDIR"

source "$HOME/.asdf/asdf.sh"

mkdir -p "/usr/local/lib/$APP_NAME/current/var"
sudo chown -R $DEPLOY_USER:$APP_GROUP "/usr/local/lib/$APP_NAME/current"
sudo /bin/systemctl restart "$APP_NAME"
