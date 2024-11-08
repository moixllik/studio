pragma foreign_keys = on;

create table if not exists Sessions (
    user_id integer not null,
    hash text unique not null,
    at_created text default current_timestamp,
    foreign key (user_id) references Users(user_id)
);
