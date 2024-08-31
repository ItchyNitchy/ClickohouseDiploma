-- +goose Up
create table sanitation_of_settlements.motor_vehicle_availability_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 1. Наличие автомобильных транспортных средств специального назначения. По районам';

create materialized view sanitation_of_settlements.motor_vehicle_availability_per_district_mv to sanitation_of_settlements.motor_vehicle_availability_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.motor_vehicle_availability as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.special_machine_operation_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 2. Работа автомобильных транспортных средств специального назначения. По районам';

create materialized view sanitation_of_settlements.special_machine_operation_per_district_mv to sanitation_of_settlements.special_machine_operation_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.special_machine_operation as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.disposal_sites_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 3. Объекты размещения твердых коммунальных отходов. По районам';

create materialized view sanitation_of_settlements.disposal_sites_per_district_mv to sanitation_of_settlements.disposal_sites_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.disposal_sites as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.sorting_and_recycling_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 4. Объекты сортировки и переработки твердых коммунальных отходов. По районам';

create materialized view sanitation_of_settlements.sorting_and_recycling_per_district_mv to sanitation_of_settlements.sorting_and_recycling_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.sorting_and_recycling as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.sorting_and_recycling_detailed_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 5. Объекты сортировки и переработки твердых коммунальных отходов (отобрано вторичных материальных ресурсов по видам). По районам';

create materialized view sanitation_of_settlements.sorting_and_recycling_detailed_per_district_mv to sanitation_of_settlements.sorting_and_recycling_detailed_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.motor_vehicle_availability as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.collection_and_disposal_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 6. Сбор, вывоз и размещение коммунальных отходов. По районам';

create materialized view sanitation_of_settlements.collection_and_disposal_per_district_mv to sanitation_of_settlements.collection_and_disposal_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.collection_and_disposal as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.preparation_and_transportation_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 7. Сбор, заготовка и сдача вторичного сырья (Комплексные приемные пункты). По районам';

create materialized view sanitation_of_settlements.preparation_and_transportation_per_district_mv to sanitation_of_settlements.preparation_and_transportation_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.preparation_and_transportation as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.preparation_and_transportation_usage_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 7. Сбор, заготовка и сдача вторичного сырья (Использование на собственные нужды. По районам';

create materialized view sanitation_of_settlements.preparation_and_transportation_usage_per_district_mv to sanitation_of_settlements.preparation_and_transportation_usage_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.preparation_and_transportation_usage as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.main_performance_indicators_per_district (
    values AggregateFunction(sumForEach, Array(Decimal128(2))),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Раздел 8. Основные показатели финансово-хозяйственной деятельности. По районам';

create materialized view sanitation_of_settlements.main_performance_indicators_per_district_mv to sanitation_of_settlements.main_performance_indicators_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.main_performance_indicators as source
group by year, region_id, district_id;

--###

create table sanitation_of_settlements.additional_per_district (
    values AggregateFunction(sumForEach, Array(Int64)),
    year UInt64,
    district_id UInt64,
    region_id UInt64
) engine AggregatingMergeTree()
order by (year, region_id, district_id)
comment 'Справочно. По районам';

create materialized view sanitation_of_settlements.additional_per_district_mv to sanitation_of_settlements.additional_per_district
as select
    source.year as year,
    source.district_id as district_id,
    source.region_id as region_id,
    sumForEachState(source.values * source.sign) as values
from sanitation_of_settlements.additional as source
group by year, region_id, district_id;
