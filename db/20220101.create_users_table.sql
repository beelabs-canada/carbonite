CREATE table users ( id INTEGER PRIMARY KEY, name VARCHAR(255), email VARCHAR(224) UNIQUE, username VARCHAR(255) UNIQUE, password varchar(255) );
-- DOWN
DROP IF EXISTS table users;
