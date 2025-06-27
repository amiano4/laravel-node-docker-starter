#!/bin/sh

set -e

if [ -f package.json ]; then
  echo "[entrypoint] Detected Node project."

  if [ ! -d node_modules ]; then
    echo "[entrypoint] Installing dependencies..."
    pnpm install
  fi

  # Only copy certs if not already done
  # if [ -f /certs/server.crt ] && [ -f /certs/server.key ]; then
  #   if [ ! -f ./certs/.certs-copied ]; then
  #     echo "[entrypoint] Copying certs into project..."
  #     mkdir -p ./certs
  #     cp /certs/* ./certs/
  #     touch ./certs/.certs-copied
  #   else
  #     echo "[entrypoint] Certs already copied. Skipping."
  #   fi
  # fi

  echo "[entrypoint] Starting dev server..."
  pnpm dev --host
else
  echo "[entrypoint] No package.json found. Skipping setup."
  tail -f /dev/null
fi
