# big-query-backup and inventory-to-garments delete events
Bash script to backup table & create garments delete events from inventory delete events in a google big query table

## Working on

- Linux
- OSX

## Getting Started

### Usage

Step1: Copy the `run.sh`, `bq.sh`, `garment_events_insert_query.sql` and `garment_events_select_query.sql` files locally or the server where you have gcloud installed & [authenticated](https://cloud.google.com/sdk/gcloud/reference/init).

Step2: 
`./run.sh [PROJECT-ID] [INVENTORY_DATASET_NAME] [GARMENTS_DATASET_NAME] [BACKUP_DATASET_NAME] [GARMENTS_TABLE_NAME] [INVENTORY_TABLE_NAME]`

### Info
Backup tables are created in the [BACKUP_DATASET_NAME] bigquery dataset.
