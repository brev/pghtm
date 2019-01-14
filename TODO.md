# Current

* problems:
  * input.columns_active is not matching columns_active view now
    * synapse updates change views out from under me?
      * might be showing half-future next step state already?
      * >>> Logging output + flag option
  * Way slower with table-based configs/queries - need immutable or something
  * Make table htm.constant read-only
* WebUI
* Temporal Memory
* Encoders

# Future

* see docs: "CREATE TRIGGER UPDATE OF column"
  * also: more IMMUTABLE? SELECT FOR UPDATE? etc. improve and optimize.
* Tag dox w/@SpatialPooler, etc.
* Sane DEFAULTS 
* Add some output notes to data fill scripts, schema, etc.
* Timing/Performance log output + flag option?
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

