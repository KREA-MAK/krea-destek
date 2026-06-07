# Krea Destek

Krea için tamamen statik (HTML/CSS/JS) Türkçe yardım merkezi. Hiçbir
çerçeve/derleme adımı gerektirmez; doğrudan herhangi bir statik barındırmada
yayınlanabilir.

## İçerik

- `site/` — yayınlanan statik site (HTML, CSS, JS, görseller)
- `scripts/deploy-siteground.sh` — siteyi SiteGround'a SSH (rsync) ile yükleyen script
- `.github/workflows/deploy-siteground.yml` — `site/**` her değiştiğinde otomatik deploy

## Özellikler

- Hero arama ve SSS (sıkça sorulan sorular) filtreleme
- `mailto:` tabanlı destek talebi formu
- Sistem durumu ve iletişim bölümleri
- Mobil uyumlu (responsive) tasarım ve özel 404 sayfası

## Yerel önizleme

```bash
cd site
python3 -m http.server 8000
# tarayıcıda http://localhost:8000
```

## Deploy (SiteGround)

`main` dalına `site/**` altında yapılan her push, GitHub Actions üzerinden
otomatik olarak SiteGround'a yüklenir. Gerekli repo secret'ları:

| Secret | Açıklama |
|---|---|
| `SG_SSH_HOST` | SiteGround sunucu adı veya doğrudan IP (Cloudflare alan adı değil) |
| `SG_SSH_USER` | SSH kullanıcı adı |
| `SG_SSH_PORT` | SSH portu (SiteGround'da genelde `18765`) |
| `SG_SSH_KEY` | Özel SSH anahtarı (tam içerik) |
| `SG_SSH_PASSPHRASE` | Anahtar parolası (varsa) |
| `SG_DEPLOY_PATH` | Sunucudaki hedef dizin (ör. `~/www/destek.krea.tr/public_html`) |

Elle deploy için:

```bash
SG_SSH_HOST=... SG_SSH_USER=... SG_DEPLOY_PATH=... ./scripts/deploy-siteground.sh
```
