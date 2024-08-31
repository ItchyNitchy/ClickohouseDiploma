-- +goose Up
create database sanitation_of_settlements; 

create table sanitation_of_settlements.motor_vehicle_availability (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 1. Наличие автомобильных транспортных средств специального назначения';

create table sanitation_of_settlements.special_machine_operation (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 2. Работа автомобильных транспортных средств специального назначения';

create table sanitation_of_settlements.disposal_sites (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 3. Объекты размещения твердых коммунальных отходов';

create table sanitation_of_settlements.sorting_and_recycling (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 4. Объекты сортировки и переработки твердых коммунальных отходов';

create table sanitation_of_settlements.sorting_and_recycling_detailed (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 5. Объекты сортировки и переработки твердых коммунальных отходов (отобрано вторичных материальных ресурсов по видам)';

create table sanitation_of_settlements.collection_and_disposal (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 6. Сбор, вывоз и размещение коммунальных отходов';

create table sanitation_of_settlements.preparation_and_transportation (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 7. Сбор, заготовка и сдача вторичного сырья (Комплексные приемные пункты)';

create table sanitation_of_settlements.preparation_and_transportation_usage (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 7. Сбор, заготовка и сдача вторичного сырья (Использование на собственные нужды)';

create table sanitation_of_settlements.main_performance_indicators (
    version UInt64,
    sign Int8,
    values Array(Decimal128(2)),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Раздел 8. Основные показатели финансово-хозяйственной деятельности';

create table sanitation_of_settlements.additional (
    version UInt64,
    sign Int8,
    values Array(UInt64),
    year UInt64,
    source_id UInt64,
    district_id UInt64,
    region_id UInt64
) engine VersionedCollapsingMergeTree(sign, version)
order by (year, source_id)
comment 'Справочно';
