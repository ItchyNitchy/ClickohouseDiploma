-- +goose Up
insert into organizations(id, name) values 
(default, 'ЧУП по оказанию услуг "СпецЭкоКлининг"'),
(default, 'Брестский мусороперерабатывающий завод'),
(default, 'ООО "Экогран-Пром Плюс"'),
(default, 'ОАО СГЦ "Западный"');

insert into districts(id, name) values 
(default, 'Петриковский'),
(default, 'Минский'),
(default, 'Брестский'),
(default, 'Мозырьский');

insert into regions(id, name) values 
(default, 'Гомельская'),
(default, 'Минская'),
(default, 'Гродненская'),
(default, 'Витебская');