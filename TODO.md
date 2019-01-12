# Current

* "If a column's connected synapses do not overlap well with any inputs 
  often enough (as measured by overlapDutyCycle), its permanence values 
  are boosted."
  * "Before inhibition, if a column’s overlap duty cycle is below its 
    minimum acceptable value calculated dynamically as a function of 
    minPctOverlapDutyCycle and the overlap duty cycle of neighboring 
    columns), then all its permanence values are boosted by the 
    increment amount."
   * ```
      if overlapDutyCycle(c) < minDutyCycle(c) then
        increasePermanences(c, 0.1*connectedPerm)
     ```
* Move config to tables so webui can access/see/change settings?
  * "id INT PRIMARY KEY NOT NULL DEFAULT(1) CHECK (id = 1)"
* test calcs not just existence
  * htm.boost_factor_compute() 
  * htm.column_active_get_threshold()
* data tests for views.
  * fix duty_cycle_period() functions test w/input row count
* Can test triggers from data side? check for self-inflicted values on CRUD.
  * input.modified
* htm.synapse refcheck on connected+active
* WebUI
* column.boost_factor - mean(*) or mean(distinct *) ???

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

