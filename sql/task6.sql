-- индексы нужны для ускорения запросов получения даты в задание 4
create index vacancy_publishX on vacancy( published_at);
create index resume_createX on resume(created_at);

-- в 3 индекс избыточен, слишком мало регионов, а в 5 значений тоже недостаточно из-за чего используется параллелизм
