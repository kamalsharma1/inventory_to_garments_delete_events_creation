#!/bin/bash

declare -r PROJECT_ID=$1
[[ -z "${PROJECT_ID// }" ]] && exit

declare -r INVENTORY_DATASET_NAME=$2
[[ -z "${INVENTORY_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_DATASET_NAME=$3
[[ -z "${GARMENTS_DATASET_NAME// }" ]] && exit

declare -r BACKUP_DATASET_NAME=$4
[[ -z "${BACKUP_DATASET_NAME// }" ]] && exit

declare -r GARMENTS_TABLE_NAME=$5
[[ -z "${GARMENTS_TABLE_NAME// }" ]] && exit

declare -r INVENTORY_TABLE_NAME=$6
[[ -z "${INVENTORY_TABLE_NAME// }" ]] && exit

source ./bq.sh

garment_events_select_query_file_name=queries/garment_events_select_query.sql
garment_events_insert_query_file_name=queries/garment_events_insert_query.sql

# backup data postfix
backup_table_name_postfix=_backup
backup_affected_rows_table_name_postfix=_insertable

# full table name with project id, dataset and table name
inventory_data_table_name=${PROJECT_ID}.${INVENTORY_DATASET_NAME}.${INVENTORY_TABLE_NAME}
garments_data_table_name=${PROJECT_ID}.${GARMENTS_DATASET_NAME}.${GARMENTS_TABLE_NAME}

backup_inventory_data_table_name=${PROJECT_ID}:${BACKUP_DATASET_NAME}.${INVENTORY_TABLE_NAME}${backup_table_name_postfix}
backup_garments_data_table_name=${PROJECT_ID}:${BACKUP_DATASET_NAME}.${GARMENTS_TABLE_NAME}${backup_table_name_postfix}
backup_affected_rows_table_name=${PROJECT_ID}:${BACKUP_DATASET_NAME}.${INVENTORY_TABLE_NAME}${backup_affected_rows_table_name_postfix}

# read table query from file
garment_event_select_query=$(readfile $garment_events_select_query_file_name)
garment_event_select_query=$(replace_string "$garment_event_select_query" "GARMENT_EVENTS_TABLE" $garments_data_table_name)
garment_event_select_query=$(replace_string "$garment_event_select_query" "INVENTORY_EVENTS_TABLE" $inventory_data_table_name)

garment_event_create_query=$(readfile $garment_events_insert_query_file_name)
garment_event_create_query=$(replace_string "$garment_event_create_query" "GARMENT_EVENTS_TABLE" $garments_data_table_name)
garment_event_create_query=$(replace_string "$garment_event_create_query" "INVENTORY_EVENTS_TABLE" $inventory_data_table_name)

# Backup original table in new table-> creation of backup table 
copy_table ${PROJECT_ID}:${INVENTORY_DATASET_NAME}.${INVENTORY_TABLE_NAME} $backup_inventory_data_table_name

# Backup original table in new table-> creation of backup table 
copy_table ${PROJECT_ID}:${GARMENTS_DATASET_NAME}.${GARMENTS_TABLE_NAME} $backup_garments_data_table_name

# Copy all deletable records in a backup table for deletable data
create_table_by_result $backup_affected_rows_table_name "$garment_event_select_query"

# Delete all duplicate records
execute_query "$garment_event_create_query"