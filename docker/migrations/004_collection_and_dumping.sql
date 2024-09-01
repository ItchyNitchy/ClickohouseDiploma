-- +goose Up
create table sanitation_of_settlements.collection_usage_dumping_additional (
    collected_and_transported Decimal128(2),
    transfered Decimal128(2),
    taken Decimal128(2),
    total_collected Decimal128(2),
    stockpiled Decimal128(2),
    recyclable_collection_total Decimal128(2),
    of_sorted_by_housing_services Decimal128(2),
    total Decimal128(2) materialized (total_collected + recyclable_collection_total - of_sorted_by_housing_services),
    total_usage Decimal128(2) materialized (total - stockpiled),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine SummingMergeTree()
order by (year, region_id, district_id)
comment 'Приложение (для заполнения приложения 1). По районам';

create materialized view sanitation_of_settlements.collection_and_disposal_to_collection_usage_dumping_additional_mv to sanitation_of_settlements.collection_usage_dumping_additional
as select
    source.values[5] * source.sign as collected_and_transported,
    source.values[25] * source.sign as transfered,
    source.values[29] * source.sign as taken,
    (source.values[5] - source.values[25] + source.values[29]) * source.sign as total_collected,
    source.values[33] * source.sign as stockpiled,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.collection_and_disposal as source;

create materialized view sanitation_of_settlements.volumes_of_recyclable_resources_to_collection_usage_dumping_additional_mv to sanitation_of_settlements.collection_usage_dumping_additional
as select
    source.total as recyclable_collection_total,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.volumes_of_recyclable_resources as source;

create materialized view sanitation_of_settlements.sorting_and_recycling_detailed_to_collection_usage_dumping_additional_mv to sanitation_of_settlements.collection_usage_dumping_additional
as select
    (source.values[2] + source.values[3] + source.values[4] + source.values[10] + source.values[11] + source.values[12]) * source.sign as of_sorted_by_housing_services,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.sorting_and_recycling_detailed as source;


create table sanitation_of_settlements.collection_usage_dumping (
    collected Decimal128(2),
    usage Decimal128(2),
    dumping_total Decimal128(2),
    dumping_on_polygons Decimal128(2),
    dumping_on_mini_polygons Decimal128(2),
    dumping_sites_total Decimal128(2),
    dumping_sites_polygons Decimal128(2),
    dumping_sites_mini_polygons Decimal128(2),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine SummingMergeTree()
order by (year, region_id, district_id)
comment 'Приложение 1. Информация об объемах образования, использования и захоронения твердых комунальных отходов. По районам';

create materialized view sanitation_of_settlements.collection_usage_dumping_additional_to_collection_usage_dumping_mv to sanitation_of_settlements.collection_usage_dumping
as select
    source.total / 1000 as collected,
    source.stockpiled / 1000 as usage,
    source.total_usage / 1000 as dumping_total,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.collection_usage_dumping_additional as source;

create materialized view sanitation_of_settlements.collection_and_disposal_to_collection_usage_dumping_mv to sanitation_of_settlements.collection_usage_dumping
as select
    source.values[29] * source.sign / 1000 as dumping_on_polygons,
    source.values[33] * source.sign / 1000 as dumping_on_mini_polygons,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.collection_and_disposal as source;

create materialized view sanitation_of_settlements.disposal_sites_to_collection_usage_dumping_mv to sanitation_of_settlements.collection_usage_dumping
as select
    source.values[1] * source.sign as dumping_sites_total,
    source.values[9] * source.sign as dumping_sites_polygons,
    source.values[17] * source.sign as dumping_sites_mini_polygons,
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id
from sanitation_of_settlements.disposal_sites as source;