#!/bin/bash
set -e
FILES=$(cat ./files)
DL_DIR='download'

DB_NAME=mimic

if [ "${DL_USER}" == "" ]; then
    echo -n 'Enter your username: '
    read DL_USER
else
    echo "Using username ${DL_USER}"
fi

if [ "${DL_PASS}" = "" ]; then
    echo -n 'Enter your password: '
    read -s DL_PASS
    echo ''
fi

AUTH=$(echo -n "${DL_USER}:${DL_PASS}" | base64)

mkdir -p "${DL_DIR}/data"
cd "${DL_DIR}"

function download() {
    echo downloading $1
    wget -nc --header "Authorization: Basic ${AUTH}" $1
}

function extract() {
    echo extracting $1
    tar xzf $1
}

# download https://physionet.org/works/MIMICIIClinicalDatabase/files/downloads-2.6/MIMIC-Importer-2.6.tar.gz
# tar xzvf 'MIMIC-Importer-2.6.tar.gz'

download https://physionet.org/works/MIMICIIClinicalDatabase/files/downloads-2.6/mimic2cdb-2.6-Definitions.tar.gz
extract mimic2cdb-2.6-Definitions.tar.gz

cd data
for file in $FILES; do
    download $file
done

if [ "${NO_EXTRACT}" != "1" ]; then
    echo extracting tars...
    for tar in $(ls *.tar.gz); do
        extract ${tar}
    done
fi
