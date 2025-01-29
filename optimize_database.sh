#!/bin/bash

# Configurazioni
POSTGRES_CONTAINER_NAME="postgres_container"  # Nome del container PostgreSQL
DB_NAME="nome_database"
POSTGRES_USER="odoo"

echo "Ripristino indici e ottimizzazione del database $DB_NAME nel container Docker $POSTGRES_CONTAINER_NAME..."

docker exec -it $POSTGRES_CONTAINER_NAME psql -U $POSTGRES_USER -d $DB_NAME -c "REINDEX DATABASE $DB_NAME;"
docker exec -it $POSTGRES_CONTAINER_NAME psql -U $POSTGRES_USER -d $DB_NAME -c "VACUUM ANALYZE;"

echo "Ottimizzazione completata!"
