-- +goose Up
create table fulfilments (
    id SERIAL primary key,
    year integer,
    source_id integer,
    district_id integer,
    region_id integer,
    values real[]
);

create table organizations (
    id serial primary key,
    name text
);

create table districts (
    id serial primary key,
    name text
);

create table regions (
    id serial primary key,
    name text
);