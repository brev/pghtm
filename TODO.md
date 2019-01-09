# Current

* SP Phase 1
  * SWITCH TO VIEWS
    * fix duty_cycle_period() functions test w/input row count
    * data tests for views.
    * overlap INTEGER NOT NULL,
    * overlapDutyCycle  NUMERIC NOT NULL,
    * CHECK ((overlapDutyCycle >= 0.0) AND (overlapDutyCycle <= 1.0))
    * trigger_column_active, active duty
    * WITH column_next AS (
        SELECT
          htm.column.id AS column_id,
          SUM(synapse.active::INTEGER) AS new_overlap,
          htm.running_moving_average(
            htm.column.overlapDutyCycle,
            htm.dendrite_is_active(
              SUM(synapse.active::INTEGER)::INTEGER
            )::INTEGER,
            period
          ) AS new_overlapDutyCycle
        FROM htm.column
        JOIN htm.link_dendrite_column
          ON link_dendrite_column.column_id = htm.column.id
        JOIN htm.dendrite
          ON dendrite.id = link_dendrite_column.dendrite_id
          AND dendrite.class = 'proximal'
        JOIN htm.synapse
          ON synapse.dendrite_id = dendrite.id
        GROUP BY htm.column.id
      )
      UPDATE htm.column
        SET
          overlap = column_next.new_overlap,
          overlapDutyCycle = column_next.new_overlapDutyCycle
        FROM column_next
        WHERE htm.column.id = column_next.column_id;
  * htm.synapse refcheck on connected+active
  * trigger learning function somewheres
  * Boosting.
  * Visualizations
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

