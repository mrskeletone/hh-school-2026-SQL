select v.area_id,
       floor(avg(compensation_to))                           as salary_to,
       floor(avg(compensation_from))                         as salary_from,
       floor(avg((compensation_to + compensation_from)) / 2) as salary_from_to
from vacancy v
group by v.area_id;
