INSERT INTO `GARMENT_EVENTS_TABLE`

SELECT inventory.sku_id  as skuId , garments.receivedDate as receivedDate, inventory.po_id as poid, cast(inventory.unit_cost as NUMERIC) as cost, inventory.garment_id as id, NULL as fingerprint, inventory.location_id as locationId , inventory.location_desc as locationDesc , inventory.event_type, inventory.event_subtype, inventory.event_datetime
 from 
  (
      SELECT inventory.* FROM 
        (
          SELECT 
            po_id, garment_id, sku_id, event_type, event_subtype as inventory_event_subtype, event_subtype, event_datetime, unit_cost, location_id, location_desc 
          FROM `INVENTORY_EVENTS_TABLE` where event_type = "GARMENT_DELETE"
         ) inventory
      LEFT JOIN
        (
          select 
            id
          FROM
            `GARMENT_EVENTS_TABLE` garments where  event_subtype = "garment_delete"
        ) as garment
      ON inventory.garment_id = garment.id
      where garment.id  is null
  ) inventory
LEFT JOIN 
  `GARMENT_EVENTS_TABLE` garments
ON   
  garments.id = inventory.garment_id
and 
  (garments.event_subtype = "garment_event" OR garments.event_subtype = "garment_create")
