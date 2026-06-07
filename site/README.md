# Krea Destek — Statik Yardım Merkezi

`destek.krea.tr` adresinde yayınlanan, tamamen statik (HTML/CSS/JS) destek sitesi.
Backend gerektirmez; herhangi bir statik barındırma servisinde çalışır.

## İçerik

```
site/
├── index.html         # Ana yardım merkezi sayfası
├── 404.html           # Bulunamadı sayfası
└── assets/
    ├── styles.css     # Stiller
    ├── main.js        # SSS arama/filtre + mailto destek formu
    └── favicon.svg    # Favicon
```

## Yerelde çalıştırma

```bash
cd site
python3 -m http.server 8080
# tarayıcıda http://localhost:8080
```

## Yayınlama (SiteGround / SSH)

Site SiteGround'a SSH üzerinden `rsync` ile dağıtılır. İki yol vardır:

### 1) Otomatik (GitHub Actions)

`.github/workflows/deploy-siteground.yml` iş akışı, `site/` altında bir
değişiklik push edildiğinde siteyi otomatik olarak SiteGround'a dağıtır.

Depo **Settings → Secrets and variables → Actions** altında şu secret'ları
tanımlayın:

| Secret           | Açıklama                                                  |
| ---------------- | -------------------------------------------------------- |
| `SG_SSH_HOST`    | SiteGround SSH sunucusu (ör. `giadaXX.siteground.biz`)   |
| `SG_SSH_USER`    | SSH kullanıcı adı                                        |
| `SG_SSH_PORT`    | SSH portu (SiteGround genelde `18765`)                   |
| `SG_SSH_KEY`     | Özel SSH anahtarı (PEM içeriği)                          |
| `SG_SSH_PASSPHRASE` | (Opsiyonel) Anahtar parola korumalıysa parolası      |
| `SG_DEPLOY_PATH` | Hedef dizin, ör. `~/www/destek.krea.tr/public_html`      |

> SiteGround'da SSH anahtarını **Site Tools → Devs → SSH Keys Manager**
> üzerinden oluşturup, özel anahtarı `SG_SSH_KEY` secret'ı olarak ekleyin.

### 2) Elle (yerelden)

```bash
export SG_SSH_HOST="giadaXX.siteground.biz"
export SG_SSH_USER="kullanici"
export SG_SSH_PORT="18765"
export SG_DEPLOY_PATH="~/www/destek.krea.tr/public_html"
export SG_SSH_KEY="$HOME/.ssh/siteground_key"   # opsiyonel
export SG_SSH_PASSPHRASE="anahtar-parolasi"     # opsiyonel (parola korumalı anahtar)
./scripts/deploy-siteground.sh
```

Script `site/` içeriğini hedefe senkronize eder (`--delete` ile sunucuda
artık bulunmayan dosyaları temizler).

## Başka bir servise yükleme

`site/` klasörünün içeriğini olduğu gibi Netlify, Vercel, Cloudflare Pages
veya herhangi bir statik sunucuya da yükleyebilirsiniz — build adımı yoktur.
