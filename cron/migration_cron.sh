#!/bin/sh
# This script is to be used by crontab to run migration scripts

# 30 21 * * * /home/root/coog-admin/cron/migration_cron.sh

USER=root
COOG_ADMIN="$HOME/coog-admin"
MIGRATION_DIR="/usr/local/coog/coog/as400"
DOCKER_MIGRATION_DIR="/coog/io/as400"
BACKUP="backup_$(date "+%d-%m-%y").tar.gz"
JOB_SIZE=100
UPDATE=true

export USER=$USER

cd $MIGRATION_DIR/'done'

if [ "$(ls -A *.CSV)" ]; then
    find . -name "*.CSV" -type f -print0 |
        tar -czvf ./$BACKUP --null -T -
	rm -rf "*.CSV"
fi

cd $COOG_ADMIN

./coog redis celery qremove migrator.party
./coog redis celery qremove migrator.company
./coog redis celery qremove migrator.group
./coog redis celery qremove migrator.address
./coog redis celery qremove migrator.bank
./coog redis celery qremove migrator.contact
./coog redis celery qremove migrator.contract
./coog redis celery qremove migrator.adhesions

./coog batch roederer.file.import dir=$DOCKER_MIGRATION_DIR --job_size=1
./coog chain roederer_interface migrate-update --job_size=$JOB_SIZE --update=$UPDATE

