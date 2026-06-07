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
#   SG_SSH_KEY        Özel anahtar dosyasının yolu (verilmezse ssh-agent/varsayılan kullanılır)
#   SG_SSH_PASSPHRASE Anahtarın parolası (parola korumalı anahtarlar için)
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

# Parola korumalı anahtar varsa, parolayı ssh-agent'a non-interaktif yükle.
if [[ -n "${SG_SSH_KEY:-}" && -n "${SG_SSH_PASSPHRASE:-}" ]]; then
  eval "$(ssh-agent -s)" >/dev/null
  trap 'ssh-agent -k >/dev/null 2>&1 || true' EXIT
  ASKPASS="$(mktemp)"
  printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$SG_SSH_PASSPHRASE"\n' > "$ASKPASS"
  chmod +x "$ASKPASS"
  SSH_ASKPASS="$ASKPASS" SSH_ASKPASS_REQUIRE=force DISPLAY="${DISPLAY:-:0}" \
    ssh-add "$SG_SSH_KEY"
  rm -f "$ASKPASS"
elif [[ -n "${SG_SSH_KEY:-}" ]]; then
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
