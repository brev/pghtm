# Current

* code flow chart
* ditch empty space chars
* Make config read-only fields work
* WebUI
* Temporal Memory
* Encoders

# Future

* Way slower with table-based configs/queries - need immutable or something
  * also: more IMMUTABLE? SELECT FOR UPDATE? etc. improve and optimize.
* see docs: "CREATE TRIGGER UPDATE OF column"
* Tag dox w/@SpatialPooler, etc.
* Sane DEFAULTS 
* Timing/Performance log output + flag option?
* ANALYZE EXPLAIN all queries, look for speedups
* Views -> Materialize and cache
* pg int's not unsigned - for input indexes[], got a trinary if wanted
* SP Phase 2
  * Add topology AKA local column inhibition 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.
* pg users, roles, access controls, grants, revokes, etc.
* Externalize and speed up plpgsql stuff as C Extensions.
  * Continue on to full NuPIC Integration???
    * ditch views
      * more server-side, less nice data to client.
        client reproduce threshold calcs and stuff. unless js/v8?..but slow!?

