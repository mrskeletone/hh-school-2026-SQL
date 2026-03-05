create table area
(
    area_id integer generated always as identity primary key,
    name    text unique not null
);
create table test_result
(
    test_result_id integer generated always as identity primary key,
    score          decimal not null,
    name           text          not null
);
create table specialization
(
    specialization_id integer generated always as identity primary key,
    parent_id         integer,
    name              text not null
);
create table vacancy
(
    vacancy_id        integer generated always as identity primary key,
    address           text          not null,
    specialization_id integer       not null references specialization (specialization_id),
    area_id           integer       not null references area (area_id),
    department        text          not null,
    employer          text          not null,
    name              text          not null,
    premium           boolean       not null,
    has_test          boolean       not null,
    published_at      timestamp     not null,
    compensation_from numeric(12, 2) not null,
    compensation_to   numeric(12, 2) not null,
    type              text          not null
);
create table resume
(
    resume_id         integer generated always as identity primary key,
    title             text,
    age               integer,
    area_id           integer       not null references area (area_id),
    education         text          not null,
    real_id           text          not null,
    first_name        text          not null,
    last_name         text          not null,
    middle_name       text,
    salary            numeric(12, 2) not null,
    specialization_id integer       not null references specialization (specialization_id),
    created_at        timestamp
);
create table response
(
    response_id        integer generated always as identity primary key,
    has_update         boolean,
    messaging_status   text,
    viewed_by_opponent boolean,
    test_result_id     integer references test_result (test_result_id),
    resume_id          integer not null references resume (resume_id),
    vacancy_id         integer references vacancy (vacancy_id),
    created_at         timestamp
);