# Current

* Boosting.
  * Auto-update: 
    * region.boost_factor_min/max
    * Note that once learning is turned off, boost(c) is frozen.
    * htm.boost_factor_compute() test cacls not just existence
    * column.boost_factor - mean(*) or mean(distinct *) ???
  * new/change column view: overlap_boosted
    * numeric (27.34) - note overlaps have only been INT so far.
* trigger learning function - after duty cycles are update?
* WebUI
* data tests for views.
  * fix duty_cycle_period() functions test w/input row count
* htm.synapse refcheck on connected+active
* Move config to tables so webui can access/see/change settings?
  * "id INT PRIMARY KEY NOT NULL DEFAULT(1) CHECK (id = 1)"
* Can test triggers from data side? check for self-inflicted values on CRUD.
  * input.modified
  * input.sp_compute_iteration

# Future

* Tag dox w/@SpatialPooler, etc.
* Sane DEFAULTS 
* Add some output notes to data fill scripts, schema, etc.
* Add some debug and timing output+options to important functions.
* see docs: "CREATE TRIGGER UPDATE OF column"
  * also: more IMMUTABLE? SELECT FOR UPDATE? etc. improve and optimize.
* ANALYZE EXPLAIN all queries, look for speedups
* Views -> Materialize and cache
* pg int's not unsigned - for input indexes[], got a trinary if wanted
* SP Phase 2
  * Add topology AKA local column inhibition 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.
* Externalize and speed up plpgsql stuff as C Extensions.
  * Continue on to full NuPIC Integration???
    * ditch views
      * more server-side, less nice data to client.
        client reproduce threshold calcs and stuff. unless js/v8?..but slow!?

