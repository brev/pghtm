CREATE TABLE htm.synapse (
	id 					integer NOT NULL PRIMARY KEY,
 	dendrite_id integer NOT NULL,
 	permanence 	numeric NOT NULL,

	CHECK ((permanence >= 0) AND (permanence <= 1)),
	FOREIGN KEY (dendrite_id) 
	  REFERENCES htm.dendrite(id) 
  	ON UPDATE CASCADE 
  	ON DELETE CASCADE
);

