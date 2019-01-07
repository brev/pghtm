# Current

* SP Phase 1
  * overlapDutyCycle
  * trigger_column_state
    - state (active)
    - active duty
  * Add Duty Cycles and Boosting.
  * Visualizations
* Move config to tables so webui can access/see/change settings?
* Can test triggers from data side!  check for self-inflicted values on CRUD.
  * input.modified, synapse.state

# Future

* Synapse naming: "Disconnected" ? vs. "Unconnected" (BAMI)
* problem if you do bin/empty then bin/fill again:
  * maybe: spatial_pooler table aint getting destroyed? immutability probs?
    * psql:../data/spatial_pooler.sql:9: ERROR:  
      duplicate key value violates unique constraint "spatial_pooler_pkey". 
      DETAIL:  Key (key)=(compute_iterations) already exists.
* Add some output notes to data fill scripts, schema, etc.
* Add some debug and timing output+options to important functions.
* Perf compare: set synapse.state in insert query, or let self auto via trigger?
* see docs: "CREATE TRIGGER UPDATE OF column"
  * also: more IMMUTABLE? SELECT FOR UPDATE? etc. improve and optimize.
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

# Balances of Building an HTM

* Data-structure centric vs. Learning-algorithm centric
  * Naming conventions
* Easy to understand vs. Performant
  * Easy to understand vs. Easy to use ?
    * i.e. 1 query for speed, but 2 queries for ease of understanding and
      simple visualization.
* Blazing vs Just-Enough vs. Non Performance

