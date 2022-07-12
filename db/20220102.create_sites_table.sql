CREATE table sites ( id INTEGER PRIMARY KEY, name VARCHAR(255), user_id INTEGER, theme VARCHAR(255), docroot varchar(255) );
-- DOWN
DROP IF EXISTS table sites;