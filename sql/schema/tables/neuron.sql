CREATE TABLE htm.neuron (
	id        integer           NOT NULL PRIMARY KEY,
 	region_id integer           NOT NULL,
	x_coord   integer           NOT NULL,
	y_coord   integer           NOT NULL,
	
  FOREIGN KEY (region_id) 
  	REFERENCES htm.region(id) 
  	ON UPDATE CASCADE 
  	ON DELETE CASCADE
);

