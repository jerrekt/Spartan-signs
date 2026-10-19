#!/usr/bin/env bash
# Pull the latest sites from GitHub and reload nginx, only when GitHub has something new.
# Runs every minute from spartan-deploy.timer; safe to run by hand too.
set -euo pipefail
cd /var/www/spartan-signs
git fetch -q origin main
if [ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ]; then
  exit 0
fi
git merge -q --ff-only origin/main
nginx -t -q
systemctl reload nginx
echo "Deployed $(git rev-parse --short HEAD)"
