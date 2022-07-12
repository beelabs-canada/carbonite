CREATE table pages ( id INTEGER PRIMARY KEY, path VARCHAR(255), site_id INTEGER );
-- DOWN
DROP IF EXISTS table pages;