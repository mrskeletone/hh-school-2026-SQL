insert into area (name)
select 'Город ' || i
from generate_series(1, 89) AS i;

insert into test_result (score, name)
values (0.9, 'Отлично'),
       (0.8, 'Хорошо'),
       (0.6, 'Удовлетворительно'),
       (0.4, 'Плохо'),
       (0.95, 'Превосходно');

with  spec_insert AS (
    insert into specialization (parent_id, name)
        select NULL, 'Специализация ' || i
        from generate_series(1, 10) AS i
        returning specialization_id, name)
insert
into specialization (parent_id, name)
select parent.specialization_id, parent.name || ' - подкатегория ' || j
from spec_insert AS parent
         cross join  generate_series(1, 10) AS j;

do
$$
    declare
        area_count integer;
        spec_count integer;
    begin
        select COUNT(*) into area_count from area;
        select COUNT(*) into spec_count from specialization;

        insert into vacancy (address, specialization_id, area_id, department, employer, name,
                             premium, has_test, published_at, compensation_from, compensation_to, type)
        select 'ул. ' ||  floor(random() * 9)+1 || floor(random() * 9) || ', д. ' ||
               floor(random() * 100)::text,
               floor(random() * spec_count) + 1,
               floor(random() * area_count) + 1,
               (array ['Отдел разработки', 'Отдел продаж', 'Бухгалтерия', 'HR', 'Маркетинг'])[floor(random() * 5) + 1],
               (array [ 'Яндекс', 'Сбербанк', 'Магнит', 'Лента', 'Дикси'])[floor(random() * 5) + 1],
               (array ['Программист', 'Бухгалтер', 'Водитель', 'Инженер', 'Аналитик', 'Дизайнер', 'Маркетолог', 'HR-менеджер'])[floor(random() * 8) + 1],
               random() < 0.1,
               random() < 0.2,
               now() - (random() * interval '3 years'),
               (random() * 100000 + 20000)::int,
               ((random() * 100000 + 20000) + random() * 80000)::int,
               (array ['полная', 'частичная', 'гибридная'])[floor(random() * 3) + 1]
        from generate_series(1, 500000);
    end
$$;

do
$$
    declare
        area_count integer;
        spec_count integer;
    begin
        select COUNT(*) into area_count from area;
        select COUNT(*) into spec_count from specialization;

        insert into resume (title, age, area_id, education, real_id,
                            first_name, last_name, middle_name, specialization_id, created_at,salary)
        select 'Резюме ' || i,
               floor(random() * 47 + 18)::int,
               floor(random() * area_count) + 1,
               (array ['высшее', 'неоконченное высшее', 'среднее профессиональное', 'среднее'])[floor(random() * 4) + 1],
               floor(random() * 100000000)::text,
               (array ['Александр', 'Дмитрий', 'Максим'])[floor(random() * 3) + 1],
               (array ['Иванов', 'Петров', 'Сидоров'])[floor(random() * 3) + 1],
               case
                   when random() < 0.9 then
                       (array ['Александрович', 'Дмитриевич', 'Максимович'])[floor(random() * 3) + 1]
                   end ,
               floor(random() * spec_count) + 1,
               now() - (random() * interval '3 years'),
               (random() * 100000 + 20000)::int
        from generate_series(1, 1000000) AS i;
    end
$$;

with random_vacancy as (select floor(random() * 500000) + 1 AS vacancy_id
                        from generate_series(1, 1960000))
insert
into response(has_update, messaging_status, viewed_by_opponent,
              test_result_id, resume_id, vacancy_id, created_at)
select random() < 0.3,
       (array ['sent','delevered','read',NULL])[floor(random() * 4) + 1],
       random() < 0.5,
       case when random() < 0.4 then floor(random() * 5) + 1 end,
       floor(random() * 1000000) + 1,
       rv.vacancy_id,
       v.published_at + (random() * interval '70 days')
from random_vacancy rv
         join vacancy v on v.vacancy_id = rv.vacancy_id;

with sel_vac as (select vacancy_id, published_at
                from vacancy
                where random() < 0.01
                limit 10000),
     expanded as (select vacancy_id,
                   published_at,
                   generate_series(1, floor(random() * 5+6)::int )
            from sel_vac)
insert
into response(has_update, messaging_status, viewed_by_opponent,
              test_result_id, resume_id, vacancy_id, created_at)
select random() < 0.2,
       (array ['sent','delevered','read',NULL])[floor(random() * 4) + 1],
       random() < 0.6,
       case when random() < 0.4 then floor(random() * 5) + 1 end,
       floor(random() * 1000000) + 1,
       e.vacancy_id,
       e.published_at + (random() * interval '7 days')
from expanded e;

