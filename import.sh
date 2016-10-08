#!/bin/bash

DB_NAME=mimic
MIMIC_VERSION='mimic2v26'
createdb ${DB_NAME}
psql -q ${DB_NAME} < ./download/Definitions/POSTGRES/schema_$MIMIC_VERSION.sql

function import {
    file=$1
    table=$2
    echo "\copy ${MIMIC_VERSION}.${table} from '$file' delimiter ',' csv header"
}

for file in $(ls ./download/Definitions/*.txt); do
    table=$(basename $file | sed 's/\.txt$//g')
    echo processing file $file
    psql -q ${DB_NAME} -c "$(import $file $table);"
done

jobs_running=0
max_jobs=10

for dir in $(find ./download/data/**/* -type d | sort); do
    if [ $jobs_running -eq $max_jobs ]; then
        jobs_running=0
        wait
    fi
    jobs_running=$(( $jobs_running+1 ))
    echo processing dir $dir
    (
        for file in $(ls $dir/*.txt); do
            table=$(basename $file | sed 's/-.*\.txt$//g')
            echo "$(import $file $table)"
        done
    ) | psql ${DB_NAME} -q -f - &
done

psql -q ${DB_NAME} < ./download/Definitions/POSTGRES/indices_$MIMIC_VERSION.sql
