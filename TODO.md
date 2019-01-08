# Current

* SP Phase 1
  * SWITCH TO VIEWS
  * htm.synapse refcheck on connected+active
  * trigger path
    * FROM: input > synapse > column
    * TO: input > synapse > +DENDRITE+ > column  (just added dendrite_active())
      * auto-update dendrite.active
      * use that flag in overlapDutyCycle instead of calc
  * trigger_column_active, active duty
  * trigger learning function somewheres
  * Archive older SP-specific code.
  * Boosting.
  * Visualizations
* Move config to tables so webui can access/see/change settings?
* Can test triggers from data side!  check for self-inflicted values on CRUD.
  * input.modified
  * input.sp_compute_iteration
  * synapse.connected
  * synapse.active
  * column.overlap

# Future

* Tag dox w/@SpatialPooler, etc.
* Sane DEFAULTS 
* Add some output notes to data fill scripts, schema, etc.
* Add some debug and timing output+options to important functions.
* Perf: set synapse.connected in insert query, or let self auto via trigger?
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

