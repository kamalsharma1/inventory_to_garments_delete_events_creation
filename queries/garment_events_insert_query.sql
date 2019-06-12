INSERT INTO
  `GARMENT_EVENTS_TABLE`
SELECT
  inventory.sku_id AS skuId,
  garments.receivedDate AS receivedDate,
  inventory.po_id AS poid,
  CAST(0 AS NUMERIC) AS cost,
  inventory.garment_id AS id,
  NULL AS fingerprint,
  NULL AS locationId,
  NULL AS locationDesc,
  "garment_event" AS event_type,
  "garment_delete" AS event_subtype,
  inventory.event_datetime
FROM (
  SELECT
    inventory.*
  FROM (
    SELECT
      po_id,
      garment_id,
      sku_id,
      event_type,
      event_subtype AS inventory_event_subtype,
      event_subtype,
      event_datetime
    FROM
      `INVENTORY_EVENTS_TABLE`
    WHERE
      event_type = "GARMENT_DELETE" ) inventory
  LEFT JOIN (
    SELECT
      id
    FROM
      `GARMENT_EVENTS_TABLE` garments
    WHERE
      event_subtype = "garment_delete" ) AS garment
  ON
    inventory.garment_id = garment.id
  WHERE
    garment.id IS NULL ) inventory
LEFT JOIN
  `GARMENT_EVENTS_TABLE` garments
ON
  garments.id = inventory.garment_id
  AND (garments.event_subtype = "garment_event"
    OR garments.event_subtype = "garment_create")