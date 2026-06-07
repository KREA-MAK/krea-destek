<h1 align="center">Welcome to Krea Destek</h1>
<p align="center">
  <img src="./static/logo.svg" alt="Logo" height="80px" />
</p>

> Açık kaynak issue management ve help desk çözümü. Zendesk ve Jira alternatifidir.

## ✨ Özellikler

- **Ticket Oluşturma**: Markdown editörü ve dosya yükleme desteğiyle ticket oluşturma
- **Müşteri Geçmişi Kaydı**
- **Markdown tabanlı not defteri ve todo listeleri**
- **Responsive**: Mobil cihazlardan 4K ekranlara kadar uyumlu tasarım
- **Çoklu dağıtım**: Docker ve pm2 ile hızlı kurulum
- **Kolay Kullanım**: Basit ve mantıklı akışla kullanım kolaylığı

## 🐳 Docker ile kurulum

Aşağıdaki örnek `docker-compose` dosyasıyla projeyi ayağa kaldırabilirsiniz:

```yaml
version: "3.1"

services:
  postgres:
    container_name: krea_destek_postgres
    image: postgres:latest
    restart: always
    ports:
      - 5432:5432
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: krea_destek
      POSTGRES_PASSWORD: 1234
      POSTGRES_DB: krea_destek

  app:
    container_name: krea_destek
    image: your-registry/krea-destek:latest
    ports:
      - 3000:3000
      - 5003:5003
    restart: always
    depends_on:
      - postgres
    environment:
      DB_USERNAME: "krea_destek"
      DB_PASSWORD: "1234"
      DB_HOST: "postgres"
      SECRET: "change-me"

volumes:
  pgdata:
```

Kurulum tamamlandıktan sonra uygulamaya `http://server-ip:3000` üzerinden erişebilirsiniz.

## Dokümantasyon

Repo içindeki dokümantasyon ve `site/` altındaki statik yardım merkezi içeriğini kullanabilirsiniz.

## Not

Bu repo artık Peppermint bağlantıları ve yönlendirmeleri içermeyecek şekilde özelleştirilmektedir.
