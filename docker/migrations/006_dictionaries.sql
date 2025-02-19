-- +goose Up
create dictionary organizations (
    id Int32,
    name String
)
primary key id
source(postgresql(
    port 5432
    host 'postgres'
    user 'postgres'
    password 'master'
    db 'sanitation'
    table 'organizations'
))
lifetime(min 300 max 360)
layout(complex_key_hashed());

create dictionary districts (
    id Int32,
    name String
)
primary key id
source(postgresql(
    port 5432
    host 'postgres'
    user 'postgres'
    password 'master'
    db 'sanitation'
    table 'districts'
))
lifetime(min 300 max 360)
layout(complex_key_hashed());

create dictionary regions (
    id Int32,
    name String
)
primary key id
source(postgresql(
    port 5432
    host 'postgres'
    user 'postgres'
    password 'master'
    db 'sanitation'
    table 'regions'
))
lifetime(min 300 max 360)
layout(complex_key_hashed());
