-- +goose Up
create table sanitation_of_settlements.waste_processing (
    sorting_sites Decimal128(2),
    sorting_capacity Decimal128(2),
    sorting_processed Decimal128(2),
    sorting_collected Decimal128(2),
    sorting_dumped Decimal128(2),
    recycling_sites Decimal128(2),
    recycling_capacity Decimal128(2),
    recycling_processed Decimal128(2),
    recycling_collected Decimal128(2),
    recycling_dumped Decimal128(2),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine SummingMergeTree()
order by (year, region_id, district_id)
comment 'Приложение 3. Информация об объектах сортировки, использования и захоронения твердых коммунальных отходов. По районам';

create materialized view sanitation_of_settlements.sorting_and_recycling_to_waste_processing_mv to sanitation_of_settlements.waste_processing
as select
    source.values[1] * source.sign as sorting_sites,
    source.values[2] * source.sign as sorting_capacity,
    source.values[3] * source.sign as sorting_processed,
    source.values[4] * source.sign as sorting_collected,
    source.values[5] * source.sign as sorting_dumped,
    source.values[11] * source.sign as recycling_sites,
    source.values[12] * source.sign as recycling_capacity,
    source.values[13] * source.sign as recycling_processed,
    source.values[14] * source.sign as recycling_collected,
    source.values[15] * source.sign as recycling_dumped,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.sorting_and_recycling as source;