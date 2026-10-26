# Spartan Signs

Web front end for the SME club's Spartan logo LED signs.

| Path | What it is |
|---|---|
| `signs/index.html` | Control site: sign in, add/claim signs, power, colors, schedule, sharing, support tickets |
| `lab/index.html` | Build options: simulated face/wall/LED combos for the sign |
| `about/index.html` | About page: what the project is, how it works, how it is connected, team |
| `nginx/sign-sites.conf` | nginx server block |
| `deploy.sh` | Pull + reload on the server |

Live at `spartan-signs.adsuaracloud.com` (control), `/lab` (build options) and `/about` (about), served from an nginx LXC on Kratos (CT 310, 10.0.0.71) through the Cloudflare tunnel.

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

Automatic: a systemd timer checks GitHub every minute and deploys anything new.

One-time install (in the LXC):

```bash
ln -sf /var/www/spartan-signs/deploy/spartan-deploy.service /etc/systemd/system/
ln -sf /var/www/spartan-signs/deploy/spartan-deploy.timer /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now spartan-deploy.timer
```

Manual deploy: `/var/www/spartan-signs/deploy.sh`
Deploy log: `journalctl -u spartan-deploy --no-pager | tail`

## Top menu

Every page has the same menu: Control, Lab, About. On the control page it sits next to Sign out. Links are relative, so they work under any prefix. A new page needs a folder here, a `location` block in `nginx/sign-sites.conf`, and a link in each page's menu.
