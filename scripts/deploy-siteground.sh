#!/usr/bin/env bash
#
# Krea Destek statik sitesini SiteGround'a SSH (rsync) ile deploy eder.
#
# Gerekli ortam değişkenleri:
#   SG_SSH_HOST    SiteGround SSH sunucusu (ör. ssh.krea.tr veya giadaXX.siteground.biz)
#   SG_SSH_USER    SSH kullanıcı adı
#   SG_SSH_PORT    SSH portu (SiteGround genelde 18765)
#   SG_DEPLOY_PATH Sunucudaki hedef dizin (ör. ~/www/destek.krea.tr/public_html)
#
# İsteğe bağlı:
#   SG_SSH_KEY     Özel anahtar dosyasının yolu (verilmezse ssh-agent/varsayılan kullanılır)
#
# Kullanım:
#   SG_SSH_HOST=... SG_SSH_USER=... SG_DEPLOY_PATH=... ./scripts/deploy-siteground.sh
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/site/"

: "${SG_SSH_HOST:?SG_SSH_HOST tanımlı değil}"
: "${SG_SSH_USER:?SG_SSH_USER tanımlı değil}"
: "${SG_DEPLOY_PATH:?SG_DEPLOY_PATH tanımlı değil}"
SG_SSH_PORT="${SG_SSH_PORT:-18765}"

SSH_OPTS=(-p "$SG_SSH_PORT" -o StrictHostKeyChecking=accept-new)
if [[ -n "${SG_SSH_KEY:-}" ]]; then
  SSH_OPTS+=(-i "$SG_SSH_KEY")
fi

echo "→ Kaynak : $SRC_DIR"
echo "→ Hedef  : ${SG_SSH_USER}@${SG_SSH_HOST}:${SG_DEPLOY_PATH} (port ${SG_SSH_PORT})"

# Hedef dizini oluştur
ssh "${SSH_OPTS[@]}" "${SG_SSH_USER}@${SG_SSH_HOST}" "mkdir -p '${SG_DEPLOY_PATH}'"

# Statik dosyaları senkronize et (--delete: sunucuda artık olmayan dosyaları siler)
rsync -avz --delete \
  --exclude ".DS_Store" \
  --exclude "README.md" \
  -e "ssh ${SSH_OPTS[*]}" \
  "$SRC_DIR" "${SG_SSH_USER}@${SG_SSH_HOST}:${SG_DEPLOY_PATH}/"

echo "✓ Deploy tamamlandı."
