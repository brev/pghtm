CREATE TABLE htm.dendrite (
	id        integer             NOT NULL PRIMARY KEY,
	neuron_id integer             NOT NULL,
	class     htm.dendrite_class  NOT NULL,

	FOREIGN KEY (neuron_id) 
	  REFERENCES htm.neuron(id) 
  	ON UPDATE CASCADE 
  	ON DELETE CASCADE
);

