with monthly_vacancy as (select date_trunc('month', published_at) as month,
                                (count(*))                        as count_vacancy
                         from vacancy
                         group by month),
     monthly_resume as (select date_trunc('month', created_at) as month,
                               count(*)                        as count_resume
                        from resume
                        group by month)
select to_char(month, 'MM'), count_vacancy as count
from monthly_vacancy
where count_vacancy = (select max(count_vacancy) from monthly_vacancy)
union all
select to_char(month, 'MM'), count_resume
from monthly_resume
where count_resume = (select max(count_resume) from monthly_resume)
