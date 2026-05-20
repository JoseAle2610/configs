#!/usr/bin/env bash
set -e

PLUGIN_NAME="CorsairBattery"
PLUGIN_ID="corsairBattery"
PLUGIN_DIR="$HOME/.config/DankMaterialShell/plugins/$PLUGIN_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Deploying $PLUGIN_NAME plugin..."

mkdir -p "$PLUGIN_DIR"

cp "$SCRIPT_DIR/plugin.json" "$PLUGIN_DIR/"
cp "$SCRIPT_DIR/$PLUGIN_NAME.qml" "$PLUGIN_DIR/"
cp "$SCRIPT_DIR/${PLUGIN_NAME}Settings.qml" "$PLUGIN_DIR/"

echo "Plugin files copied to $PLUGIN_DIR"

echo "Scanning for plugins..."
dms ipc call plugins scan

echo "Reloading plugin..."
dms ipc call plugins reload "$PLUGIN_ID"

echo "Done! Check Settings -> Plugins to enable $PLUGIN_NAME"
