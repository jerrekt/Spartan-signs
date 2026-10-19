# Spartan Signs

Web front end for the SME club's Spartan logo LED signs.

| Path | What it is |
|---|---|
| `signs/index.html` | Control site: sign in, add/claim signs, power, colors, schedule, sharing, support tickets |
| `lab/index.html` | Build options: simulated face/wall/LED combos for the sign |
| `nginx/sign-sites.conf` | nginx server block |
| `deploy.sh` | Pull + reload on the server |

Live at `spartan-signs.adsuaracloud.com` (control) and `/lab` (build options), served from an nginx LXC on Kratos (CT 310, 10.0.0.70) through the Cloudflare tunnel.

Both pages are clickable demos: no backend yet, so changes reset on reload.

## First-time server setup (run in the LXC as root)

```bash
apt install -y git
ssh-keygen -t ed25519 -f ~/.ssh/spartan_deploy -N ""
cat ~/.ssh/spartan_deploy.pub
# GitHub → this repo → Settings → Deploy keys → Add deploy key (paste, leave "Allow write access" off)

printf 'Host github.com\n  IdentityFile ~/.ssh/spartan_deploy\n' >> ~/.ssh/config
ssh -T git@github.com            # type "yes" once; expect "successfully authenticated"

git clone git@github.com:jerrekt/spartan-signs.git /var/www/spartan-signs
ln -sf /var/www/spartan-signs/nginx/sign-sites.conf /etc/nginx/sites-enabled/sign-sites.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx
```

## Updating

```bash
/var/www/spartan-signs/deploy.sh
```
