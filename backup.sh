#!/bin/sh
set -e

die() {
    echo "Unable to start: $1"
    exit 1
}

[ -n "$DB_HOST" ] || die "Please set DB_HOST"
[ -n "$DB_NAME" ] || die "Please set DB_NAME"
[ -n "$DB_USERNAME" ] || die "Please set DB_USERNAME"
[ -n "$DB_PASSWORD" ] || die "Please set DB_PASSWORD"
[ -n "$S3_BACKUP_LOCATION" ] || die "Please set S3_BACKUP_LOCATION"
[ -n "$S3_REGION" ] || S3_REGION="us-east-1"

while true; do
    date=$(date +%Y%m%d%H%M%S)
    echo "Backing up at ${date}"
    fn="${DB_NAME}_${date}.sql"
    mysqldump -h $DB_HOST -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME > ${fn}
    gzip ${fn}
    aws --region $S3_REGION s3 cp "${fn}" "${S3_BACKUP_LOCATION}/${fn}"
    sleep 3600
done
