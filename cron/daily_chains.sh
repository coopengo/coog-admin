#!/bin/sh
# This script is to be used by crontab to run daily chains

# 0 3 * * * /home/root/coog-admin/cron/daily_chains.sh

USER=coog-adm
COOG_ADMIN="$HOME/coog-admin"

export USER=$USER

cd $COOG_ADMIN

./coog chain account_payment_sepa_cog payment --treatment_date=$(date --iso) --payment_kind='payable' --journal_methods='sepa'
./coog chain account_aggregate snapshot
./coog chain roederer extract_snapshot --treatment_date=$(date --iso) --flush_size='1024' --env_name='ROEDR' --output_filename="/workspace/io/batch/extractions/snapshots/snapshots_$(date --iso).csv";
./coog chain report_engine produce_request
./coog batch ftp.move --input="/workspace/io/reports/bdoc/" --output="."

# attente de 20 minutes le temps d'envoyer la bande à la banque et de recevoir l'accusé reception
sleep 1200
./coog chain account_payment_cog payment_ack --treatment_date=$(date --iso) --journal_methods=sepa --payment_kind='payable'

cd -
