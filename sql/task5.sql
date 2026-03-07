select v.vacancy_id, v.name as title
from vacancy v
         join public.response r on v.vacancy_id = r.vacancy_id
where r.created_at between v.published_at and v.published_at + interval '7 days'
group by v.vacancy_id
having count(*) > 5
;
