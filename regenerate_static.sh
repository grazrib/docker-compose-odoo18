#!/bin/bash

# Configurazioni
ODOO_CONTAINER_NAME="odoo_container"  # Nome del container Docker
DB_NAME="nome_database"

echo "Rigenerazione dei file statici per il database $DB_NAME nel container Docker $ODOO_CONTAINER_NAME..."

docker exec -it $ODOO_CONTAINER_NAME ./odoo-bin -d $DB_NAME -u all --stop-after-init

if [ $? -eq 0 ]; then
  echo "File statici rigenerati con successo!"
else
  echo "Errore durante la rigenerazione dei file statici!"
fi
