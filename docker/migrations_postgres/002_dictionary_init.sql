-- +goose Up
insert into organizations(id, name) values 
(default, 'ЧУП по оказанию услуг "СпецЭкоКлининг"'),
(default, 'Брестский мусороперерабатывающий завод'),
(default, 'ООО "Экогран-Пром Плюс"'),
(default, 'ОАО СГЦ "Западный"');

insert into districts(id, name) values 
(default, 'Барановичский'),
(default, 'Ганцевичский'),
(default, 'Жабинковский'),
(default, 'Кобринский'),
(default, 'Малоритский'),

(default, 'Городокский '),
(default, 'Дубровенский'),
(default, 'Миорский'),
(default, 'Полоцкий'),
(default, 'Шарковщинский'),

(default, 'Житковичский'),
(default, 'Жлобинский'),
(default, 'Калинковичский'),
(default, 'Речицкий'),
(default, 'Петриковский'),

(default, 'Ивьевский'),
(default, 'Мостовский'),
(default, 'Островецкий'),
(default, 'Слонимский'),
(default, 'Сморгонский');

insert into regions(id, name) values 
(default, 'Брестская область'),
(default, 'Витебская область'),
(default, 'Гомельская  область'),
(default, 'Минская область'),
(default, 'Могилевская область'),
(default, 'Гродненская область');