#!/bin/sh
# This script is to be used by crontab to run daily chains

# 0 3 * * * /home/root/coog-admin/cron/daily_chains.sh

USER=root
COOG_ADMIN="$HOME/coog-admin"


export USER=$USER

cd $COOG_ADMIN

./coog chain -- account_payment_sepa_cog payment --treatment_date=$(date --iso) --payment_kind='payable' --journal_methods='sepa' --out="$HOME/payments/out/";
./coog chain -- roederer extract_snapshot --treatment_date=$(date --iso) --flush_size='1024' --env_name='ROEDR' --output_filename="$HOME/extractions/snapshots/snapshots_$(date --iso).csv";

cd -
