#!/bin/sh
# This script is to be used by crontab to run migration scripts

# 30 21 * * * /home/root/coog-admin/cron/migration_cron.sh

USER=jack
COOG_ADMIN=/home/jack/workspace/coog-admin/
MIGRATION_DIR=/home/jack/workspace/roederer/migration
BACKUP=backup_$(date "+%d-%m-%y").tar.gz

JOB_SIZE=100
UPDATE=true

cd $COOG_ADMIN

if [ "$(ls -A $MIGRATION_DIR/done/*.CSV)" ]; then
    find $MIGRATION_DIR/'done' -name "*.CSV" -type f -print0 |
        tar -czvf $MIGRATION_DIR/'done'/$BACKUP --null -T -
fi

./coog batch roederer.file.import dir=$MIGRATION_DIR --job_size=1
./coog chain roederer_interface migrate-update --job_size=$JOB_SIZE --limit=10 --update=$UPDATE

