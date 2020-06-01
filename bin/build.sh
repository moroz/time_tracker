#!/usr/bin/env bash

# Build task

set -e

export LANG="${LANG:-"en_US.UTF-8"}"
export MIX_ENV="${MIX_ENV:-prod}"

CURDIR="$PWD"
BINDIR=$(dirname "$0")
cd "$BINDIR"; BINDIR="$PWD"; cd "$CURDIR"

BASEDIR="$BINDIR/.."
cd "$BASEDIR"

echo "===> Running build task"
git pull

echo "===> Installing Hex and Rebar"
mix local.hex --force
mix local.rebar --force

echo "===> Updating Elixir libs"
mix deps.get --only "$MIX_ENV"

echo "===> Compiling"
mix compile

echo "===> Compiling static assets for admin"
(cd apps/admin/assets && npm install && npm run deploy)

echo "Building digest files"
mix phx.digest

chmod +x bin/*

echo "===> Building release"
# Elixir 1.9+
mix release --overwrite bazaar_umbrella
