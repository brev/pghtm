# Current

* finish: functions/synapse/ htm.synapse_update_field_state()
* Perf compare: set synapse.state in insert query, or let self auto via trigger?
* Are insert & update triggers separate?
* SP Phase 1
  * Add Duty Cycles and Boosting.
  * Visualizations
* Add some output notes to data fill scripts, schema, etc.
* Add some debug and timing output+options to important functions.
* Can test triggers from data side!  check for self-inflicted values on CRUD.
* problem if you do bin/empty then bin/fill again:
  * maybe: spatial_pooler table aint getting destroyed? immutability probs?
    * `psql:../data/spatial_pooler.sql:9: ERROR:  duplicate key value violates unique constraint "spatial_pooler_pkey". DETAIL:  Key (key)=(compute_iterations) already exists.`

# Future

* "IN (SELECT unnest(input_indexes))": can check array for key instead?
* ANALYZE EXPLAIN all queries, look for speedups
* pg int's not unsigned.  
  * for input indexes[], you've now got a trinary if u want!
* 3 state not as enum/type, but as true/false/null ?
* SP Phase 2
  * Add topology AKA local column inhibition 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.
* Externalize and speed up plpgsql stuff as C Extensions.
  * Continue on to full NuPIC Integration???

