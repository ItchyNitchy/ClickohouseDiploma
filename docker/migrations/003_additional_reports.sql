-- +goose Up
create table sanitation_of_settlements.volumes_of_secondary_material_resources_per_region (
    paper_and_cardboard AggregateFunction(sum, Decimal128(2)),
    glass AggregateFunction(sum, Decimal128(2)),
    polymer AggregateFunction(sum, Decimal128(2)),
    tires AggregateFunction(sum, Decimal128(2)),
    electronics_parts AggregateFunction(sum, Decimal128(2)),
    oil AggregateFunction(sum, Decimal128(2)),
    total AggregateFunction(sum, Decimal128(2)),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Приложение 2. Информация об объемах собранных (заготовленных) вторичных ресурсов. По районам';

create materialized view sanitation_of_settlements.volumes_of_secondary_material_resources_mv to sanitation_of_settlements.volumes_of_secondary_material_resources_per_region
as select
    sumState(source.values[4] * source.sign) as paper_and_cardboard,
    sumState(source.values[10] * source.sign) as glass,
    sumState(source.values[7] * source.sign) as polymer,
    sumState(source.values[31] * source.sign) as electronics_parts,
    sumState((source.values[4] + source.values[10] + source.values[7] + source.values[31]) * source.sign) as total
from sanitation_of_settlements.preparation_and_transportation_usage as source
group by year, region_id, district_id;

create table sanitation_of_settlements.volumes_of_secondary_material_resources_additional_fulfilment (
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

create materialized view sanitation_of_settlements.volumes_of_secondary_material_resources_additional_mv to sanitation_of_settlements.volumes_of_secondary_material_resources_per_region
as select
    sumState(source.paper_and_cardboard * source.sign) as paper_and_cardboard,
    sumState(source.glass * source.sign) as glass,
    sumState(source.polymer * source.sign) as polymer,
    sumState(source.tires * source.sign) as tires,
    sumState(source.electronics_parts * source.sign) as electronics_parts,
    sumState(source.oil * source.sign) as oil,
    sumState(source.total * source.sign) as total,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.volumes_of_secondary_material_resources_additional_fulfilment as source
group by year, region_id, district_id;