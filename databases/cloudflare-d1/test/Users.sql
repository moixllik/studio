-- PUT
insert or ignore into Users(username, password) values
    ('admin', current_timestamp),
    ('moix', current_timestamp),
    ('moix_cc', current_timestamp),
    ('moixllik', current_timestamp);

-- POST
select * from Users;

-- PATCH
update Users set password = 'HASH' where is_banned = 0 and username = 'moixllik';
select * from Users where username = 'moixllik';

-- DELETE
delete from Users where username = 'moix_cc';
select * from Users;
