#!/bin/bash

set -o errexit \
    -o pipefail \
    -o xtrace

declare -r PROJECT_ID=$1
[[ -z "${PROJECT_ID// }" ]] && exit

declare -r INVENTORY_DATASET_NAME=$2
[[ -z "${INVENTORY_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_DATASET_NAME=$3
[[ -z "${GARMENTS_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_TABLE_NAME=$4
[[ -z "${GARMENTS_TABLE_NAME// }" ]] && exit

declare -r INVENTORY_TABLE_NAME=$5
[[ -z "${INVENTORY_TABLE_NAME// }" ]] && exit

source ./bq.sh

# sql query and schema file name
query_file_name=queries/garment_events_insert_query.sql

# full table name with project id, dataset and table name
inventory_data_table_name=${PROJECT_ID}.${INVENTORY_DATASET_NAME}.${INVENTORY_TABLE_NAME}
garments_data_table_name=${PROJECT_ID}.${GARMENTS_DATASET_NAME}.${GARMENTS_TABLE_NAME}

# read query and repalce Garments and Inventory table name
query=$(readfile $query_file_name)
query=$(replace_string "$query" "GARMENT_EVENTS_TABLE" "$garments_data_table_name")
query=$(replace_string "$query" "INVENTORY_EVENTS_TABLE" "$inventory_data_table_name")

# execute insert query
execute_query "$query"