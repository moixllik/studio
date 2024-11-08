create table if not exists Users(
    user_id integer primary key,
    username text unique not null, -- max(15ch)
    password text not null, -- hash(max(15ch))
    is_banned integer default 0, -- 1 banned
    at_created text default current_timestamp
);
