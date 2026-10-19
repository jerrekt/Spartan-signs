#!/usr/bin/env bash
# Pull the latest sites from GitHub and reload nginx. Run on the LXC: /var/www/spartan-signs/deploy.sh
set -euo pipefail
cd /var/www/spartan-signs
git pull --ff-only
nginx -t
systemctl reload nginx
echo "Deployed $(git rev-parse --short HEAD)"
