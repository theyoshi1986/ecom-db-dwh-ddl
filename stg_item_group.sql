drop table dwh.stg_item_group;
create table dwh.stg_item_group
(id_group serial
,group_name varchar(100)
,group_match_word varchar(100) primary key
);

insert into dwh.stg_item_group (group_name,group_match_word) values  ('Молочная продукция','Молоко');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Молочная продукция','Масло');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Мороженое','Мороженое');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Мороженое','Пломбир');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Мороженое','Эскимо');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Творог');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Йогурт');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Сметана');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Кефир');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Ряженка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Сырок');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Бифилюкс');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Снежок');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Кисломолочная продукция','Оцидофилин');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Сырная продукция','Сыр');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Хлеб');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Каравай');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Сухарь');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Сушка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Лепешка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Круассан');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Слойка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Пирожок');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Булка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Кекс');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Ватрушка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Сдоба');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Сочник');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Рогалик');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Бриош');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Штрудель');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Батон');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Буханка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Тост');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Хлебобулочная продукция','Баранка');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Торты','Торт');
insert into dwh.stg_item_group (group_name,group_match_word) values  ('Торты','Пирожное');