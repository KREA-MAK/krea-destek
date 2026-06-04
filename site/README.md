# Krea Destek — Statik Yardım Merkezi

`destek.krea.tr` adresinde yayınlanan, tamamen statik (HTML/CSS/JS) destek sitesi.
Backend gerektirmez; herhangi bir statik barındırma servisinde çalışır.

## İçerik

```
site/
├── index.html         # Ana yardım merkezi sayfası
├── 404.html           # Bulunamadı sayfası
├── CNAME              # Özel alan adı (destek.krea.tr)
├── .nojekyll          # GitHub Pages Jekyll işlemesini kapatır
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

## Yayınlama (GitHub Pages)

`.github/workflows/deploy-pages.yml` iş akışı, `site/` altında bir değişiklik
push edildiğinde siteyi otomatik olarak GitHub Pages'e dağıtır.

Tek seferlik kurulum (depo ayarlarından):

1. **Settings → Pages → Build and deployment → Source: GitHub Actions** seçin.
2. DNS sağlayıcınızda `destek.krea.tr` için bir `CNAME` kaydı oluşturup
   `<kullanıcı>.github.io` adresine yönlendirin (apex değil, alt alan adı).
3. İş akışı çalıştıktan sonra **Settings → Pages → Custom domain** alanında
   `destek.krea.tr` görünür ve "Enforce HTTPS" işaretlenebilir.

## Başka bir servise yükleme

`site/` klasörünün içeriğini olduğu gibi Netlify, Vercel, Cloudflare Pages
veya herhangi bir statik sunucuya yükleyebilirsiniz — build adımı yoktur.
