#!/bin/bash

# Ottiene il path assoluto della directory dello script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ADDONS_PATH="$SCRIPT_DIR/addons"
mkdir -p $ADDONS_PATH
cd $ADDONS_PATH

# Funzione per clonare o aggiornare un repository
clone_or_update() {
    local repo_url=$1
    local repo_name=$(basename $repo_url .git)
    
    echo "Processando $repo_name..."
    
    if [ -d "$repo_name" ]; then
        echo "Il repository $repo_name esiste già, aggiornamento in corso..."
        cd $repo_name
        git pull origin
        cd ..
    else
        echo "Clonazione di $repo_name..."
        git clone --depth=1 $repo_url
    fi
}

# Clonazione o aggiornamento dei moduli OCA
while read -r repo; do
    if [[ $repo == https* ]]; then
        clone_or_update $repo
    fi
done << 'END'
https://github.com/OCA/account-analytic.git
https://github.com/OCA/account-budgeting.git
https://github.com/OCA/account-closing.git
https://github.com/OCA/account-financial-tools.git
https://github.com/OCA/account-financial-reporting.git
https://github.com/OCA/account-fiscal-rule.git
https://github.com/OCA/account-invoicing.git
https://github.com/OCA/account-invoice-reporting.git
https://github.com/OCA/account-payment.git
https://github.com/OCA/account-reconcile.git
https://github.com/OCA/bank-statement-import.git
https://github.com/OCA/bank-payment.git
https://github.com/OCA/brand.git
https://github.com/OCA/business-requirement.git
https://github.com/OCA/calendar.git
https://github.com/OCA/commission.git
https://github.com/OCA/community-data-files.git
https://github.com/OCA/connector.git
https://github.com/OCA/connector-cmis.git
https://github.com/OCA/connector-ecommerce.git
https://github.com/OCA/connector-interfaces.git
https://github.com/OCA/connector-telephony.git
https://github.com/OCA/contract.git
https://github.com/OCA/credit-control.git
https://github.com/OCA/crm.git
https://github.com/OCA/currency.git
https://github.com/OCA/data-protection.git
https://github.com/OCA/database_cleanup.git
https://github.com/OCA/ddmrp.git
https://github.com/OCA/delivery-carrier.git
https://github.com/OCA/dms.git
https://github.com/OCA/donation.git
https://github.com/OCA/e-commerce.git
https://github.com/OCA/edi.git
https://github.com/OCA/event.git
https://github.com/OCA/field-service.git
https://github.com/OCA/fleet.git
https://github.com/OCA/geospatial.git
https://github.com/OCA/helpdesk.git
https://github.com/OCA/hr.git
https://github.com/OCA/hr-attendance.git
https://github.com/OCA/hr-expense.git
https://github.com/OCA/hr-holidays.git
https://github.com/OCA/interface-github.git
https://github.com/OCA/intrastat-extrastat.git
https://github.com/OCA/iot.git
https://github.com/OCA/knowledge.git
https://github.com/OCA/l10n-italy.git
https://github.com/OCA/maintenance.git
https://github.com/OCA/management-system.git
https://github.com/OCA/manufacture.git
https://github.com/OCA/manufacture-reporting.git
https://github.com/OCA/margin-analysis.git
https://github.com/OCA/mis-builder.git
https://github.com/OCA/mis-builder-contrib.git
https://github.com/OCA/multi-company.git
https://github.com/OCA/odoo-pim.git
https://github.com/OCA/operating-unit.git
https://github.com/OCA/openupgradelib.git
https://github.com/OCA/partner-contact.git
https://github.com/OCA/payroll.git
https://github.com/OCA/pos.git
https://github.com/OCA/product-attribute.git
https://github.com/OCA/product-configurator.git
https://github.com/OCA/product-pack.git
https://github.com/OCA/product-variant.git
https://github.com/OCA/project.git
https://github.com/OCA/purchase-reporting.git
https://github.com/OCA/purchase-workflow.git
https://github.com/OCA/queue.git
https://github.com/OCA/report-print-send.git
https://github.com/OCA/reporting-engine.git
https://github.com/OCA/rest-framework.git
https://github.com/OCA/rma.git
https://github.com/OCA/sale-promotion.git
https://github.com/OCA/sale-reporting.git
https://github.com/OCA/sale-workflow.git
https://github.com/OCA/search-engine.git
https://github.com/OCA/server-auth.git
https://github.com/OCA/server-backend.git
https://github.com/OCA/server-brand.git
https://github.com/OCA/server-env.git
https://github.com/OCA/server-tools.git
https://github.com/OCA/server-ux.git
https://github.com/OCA/social.git
https://github.com/OCA/spreadsheet.git
https://github.com/OCA/stock-logistics-barcode.git
https://github.com/OCA/stock-logistics-reporting.git
https://github.com/OCA/stock-logistics-tracking.git
https://github.com/OCA/stock-logistics-transport.git
https://github.com/OCA/stock-logistics-warehouse.git
https://github.com/OCA/stock-logistics-workflow.git
https://github.com/OCA/storage.git
https://github.com/OCA/survey.git
https://github.com/OCA/timesheet.git
https://github.com/OCA/vertical-abbey.git
https://github.com/OCA/vertical-association.git
https://github.com/OCA/web.git
https://github.com/OCA/website.git
https://github.com/OCA/website-cms.git
https://github.com/OCA/wms.git
END

# Set permissions
chmod -R 777 $ADDONS_PATH

echo "Operazione completata!"
