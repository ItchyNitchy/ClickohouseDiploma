-- +goose Up
create table sanitation_of_settlements.volumes_of_recyclable_resources (
    paper_and_cardboard Decimal128(2),
    glass Decimal128(2),
    polymer Decimal128(2),
    tires Decimal128(2),
    electronics_parts Decimal128(2),
    oil Decimal128(2),
    total Decimal128(2),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine SummingMergeTree()
order by (year, region_id, district_id)
comment 'Приложение 2. Информация об объемах собранных (заготовленных) вторичных ресурсов. По районам';

create materialized view sanitation_of_settlements.volumes_of_recyclable_resources_mv to sanitation_of_settlements.volumes_of_recyclable_resources
as select
    source.values[4] * source.sign as paper_and_cardboard,
    source.values[10] * source.sign as glass,
    source.values[7] * source.sign as polymer,
    source.values[31] * source.sign as electronics_parts,
    (source.values[4] + source.values[10] + source.values[7] + source.values[31]) * source.sign as total,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.preparation_and_transportation_usage as source;

create table sanitation_of_settlements.volumes_of_recyclable_resources_additional_fulfilment (
    version UInt64,
    sign Int8,
    paper_and_cardboard Decimal128(2),
    glass Decimal128(2),
    polymer Decimal128(2),
    tires Decimal128(2),
    electronics_parts Decimal128(2),
    oil Decimal128(2),
    total Decimal128(2),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, region_id, district_id)
comment 'Приложение 2. Информация об объемах собранных (заготовленных) вторичных ресурсов. Для данных оператора ВМР';

create materialized view sanitation_of_settlements.volumes_of_recyclable_resources_additional_mv to sanitation_of_settlements.volumes_of_recyclable_resources
as select
    source.paper_and_cardboard * source.sign as paper_and_cardboard,
    source.glass * source.sign as glass,
    source.polymer * source.sign as polymer,
    source.tires * source.sign as tires,
    source.electronics_parts * source.sign as electronics_parts,
    source.oil * source.sign as oil,
    source.total * source.sign as total,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.volumes_of_recyclable_resources_additional_fulfilment as source;