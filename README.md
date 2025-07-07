# 🚀 Quick install Odoo 18

Installazione Odoo 18 con un comando - Configurazione ottimizzata per OpenLiteSpeed/aaPanel.

## 📋 Prerequisiti

Installa [docker](https://docs.docker.com/get-docker/) e [docker-compose](https://docs.docker.com/compose/install/), poi esegui:

### 🎯 Installazione Rapida

```bash
curl -s https://raw.githubusercontent.com/grazrib/docker-compose-odoo18/master/run.sh | sudo bash -s odoo18-one 10018 20018
```

### 🔧 Installazione Personalizzata

```bash
# Scarica lo script
wget https://raw.githubusercontent.com/grazrib/docker-compose-odoo18/master/run.sh
chmod +x run.sh

# Esegui con configurazione interattiva
sudo ./run.sh odoo18-instance 10018 20018
```

**Parametri:**
- `odoo18-instance`: Nome cartella installazione
- `10018`: Porta Odoo
- `20018`: Porta live chat

## 🌐 Configurazione OpenLiteSpeed (aaPanel)

### Virtual Host Setup

1. **Crea Virtual Host in aaPanel:**
   ```
   Domain: tuodominio.com
   Document Root: /www/wwwroot/tuodominio.com
   ```

2. **Configurazione Proxy (aaPanel > Website > tuodominio.com > Configurazione):**

```apache
# Rewrite rules
RewriteEngine On
# Redirezione da www a non-www
RewriteCond %{HTTP_HOST} ^www\.(tuodominio\.com)$ [NC]
RewriteRule ^ https://%1%{REQUEST_URI} [R=301,L,NE]
# Redirezione HTTP a HTTPS
RewriteCond %{HTTPS} off
RewriteCond %{HTTP:Upgrade} !=websocket [NC]
RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L,NE]

# Proxy principale per Odoo
extprocessor odoo_main {
  type                    proxy
  address                 http://127.0.0.1:10018
  maxConns                1000
  pcKeepAliveTimeout      600
  initTimeout             600
  retryTimeout            0
  respBuffer              0
}

# Proxy per longpolling/WebSocket Odoo
extprocessor odoo_longpolling {
  type                    proxy
  address                 http://127.0.0.1:20018
  maxConns                200
  pcKeepAliveTimeout      1800
  initTimeout             60
  retryTimeout            0
  respBuffer              0
}

# Gestione del percorso principale
context / {
  handler                 odoo_main
  addDefaultCharset       off
}

# Gestione del longpolling (corretto per Odoo)
context /longpolling/ {
  handler                 odoo_longpolling
  addDefaultCharset       off
  extraHeaders            <<<END_extraHeaders
Upgrade $ws_upgrade
Connection $connection_upgrade
END_extraHeaders
}
```

### 🔒 SSL Configuration

In aaPanel > SSL > Let's Encrypt o SSL personalizzato:

```nginx
# Forza HTTPS
if ($scheme != "https") {
    return 301 https://$server_name$request_uri;
}

# Headers sicurezza
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header X-Content-Type-Options nosniff;
add_header X-Frame-Options DENY;
add_header X-XSS-Protection "1; mode=block";
```

### ⚡ Performance Tuning aaPanel

**OpenLiteSpeed Settings (aaPanel > App Store > OpenLiteSpeed > Performance):**

```
Max Connections: 2000
Max SSL Connections: 1000
Connection Timeout: 60
Max Keep-Alive Requests: 1000
Keep-Alive Timeout: 5
```

## 📊 Configurazione Performance

### Server Resources Recommended

| Istanze | CPU Cores | RAM | Storage | Users |
|---------|-----------|-----|---------|-------|
| 1 | 2 cores | 4-8 GB | 50-100 GB | 5-20 |
| 2 | 4 cores | 8-16 GB | 100-200 GB | 20-50 |
| 3+ | 6+ cores | 16+ GB | 200+ GB | 50+ |

### Database Optimization

```bash
# Nel container PostgreSQL
docker exec -it <container_postgres> psql -U odoo -d postgres
```

```sql
-- Configurazioni PostgreSQL ottimali
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '2GB';
ALTER SYSTEM SET maintenance_work_mem = '128MB';
ALTER SYSTEM SET work_mem = '16MB';
ALTER SYSTEM SET max_connections = 200;
SELECT pg_reload_conf();
```

## 🛠️ Utilizzo

### Gestione Container

```bash
# Avvia
docker-compose up -d

# Riavvia
docker-compose restart

# Ferma
docker-compose down

# Rebuild
docker-compose build

# Log
docker-compose logs -f odoo18
```

### Custom Addons

La cartella `addons/` contiene i moduli personalizzati. Per aggiungere moduli OCA:

```bash
# Scarica moduli OCA automaticamente
chmod +x clone-oca.sh
./clone-oca.sh
```

### Database Management

```bash
# Ottimizza database
chmod +x optimize_database.sh
./optimize_database.sh

# Rigenera file statici
chmod +x regenerate_static.sh
./regenerate_static.sh
```

## 🔧 Configurazioni Avanzate

### Multi-Instance Setup

Per più istanze sullo stesso server:

```bash
# Istanza 1
sudo ./run.sh odoo18-prod 10018 20018

# Istanza 2  
sudo ./run.sh odoo18-test 10019 20019

# Istanza 3
sudo ./run.sh odoo18-dev 10020 20020
```

### Backup Automatico

```bash
# Crea script backup
cat > backup_odoo.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/odoo18"
mkdir -p $BACKUP_DIR

# Backup database
docker exec postgres_container pg_dump -U odoo database_name > $BACKUP_DIR/db_$DATE.sql

# Backup filestore
tar -czf $BACKUP_DIR/filestore_$DATE.tar.gz ./etc/filestore/

# Rimuovi backup vecchi (>30 giorni)
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
EOF

chmod +x backup_odoo.sh

# Aggiungi al cron
echo "0 2 * * * /path/to/backup_odoo.sh" | crontab -
```

## 🔍 Troubleshooting

### Log comuni

```bash
# Log Odoo
docker-compose logs -f odoo18

# Log PostgreSQL  
docker-compose logs -f db

# Log sistema
tail -f /var/log/syslog | grep docker
```

### Problemi comuni

**1. Errore permessi:**
```bash
sudo chown -R 101:101 addons/ etc/
sudo chmod -R 755 addons/ etc/
sudo chmod 755 entrypoint.sh
```

**2. Odoo non raggiungibile:**
```bash
# Verifica proxy
curl -I http://localhost:10018
# Controlla firewall
sudo ufw status
```

**3. Database connection:**
```bash
# Testa connessione DB
docker exec -it db_container psql -U odoo -d postgres -c "SELECT version();"
```

## 📞 Supporto

- **Documentazione Odoo:** https://www.odoo.com/documentation
- **Community:** https://www.odoo.com/forum
- **GitHub Issues:** https://github.com/grazrib/docker-compose-odoo18/issues

## 📄 Licenza

MIT License - Vedi file LICENSE per dettagli.
