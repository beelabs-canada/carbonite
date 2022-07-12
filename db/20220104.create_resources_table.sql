CREATE table resources ( id INTEGER PRIMARY KEY, path VARCHAR(255), site_id INTEGER );
CREATE table page_resource (id INTEGER PRIMARY KEY, page_id INTEGER, resource_id INTEGER);
-- DOWN
DROP IF EXISTS table resources;
DROP IF EXISTS table page_resource;