-- PUT
insert or ignore into Sessions(user_id, hash)
select user_id, current_timestamp
from Users
where is_banned = 0 and (username = 'moixllik' or username = 'admin');

-- POST
select * from Sessions;

-- DELETE
delete from Sessions where user_id = (select user_id from Users where username = 'moixllik');
select * from Sessions;
