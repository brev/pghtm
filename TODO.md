# Current Work

[x] Temporal Memory
  * Step 3
  * Update dox charts
[x] WebUI
  * Work with @jsfowles on react components
[ ] Encoders

# Future Work

* General:
  * pg users, roles, access controls, grants, revokes, etc.
  * pg int's not unsigned - for input indexes[], got a trinary if wanted
  * use advanced pg custom types somehow?  
* Performance: 
  * Can some vol/stable functions be moved to immutable?
    * How does this interact with my config_getter_generator?
  * Views -> Materialize and cache?
  * array/matrix/vectorize maths and data (see related pg extensions)
    * (ditch views. calc nupic style.)
  * Externalize and speed up plpgsql stuff as C Extensions.
  * Continue on to full NuPIC Integration?
* SP Phase 2
  * Dimensionality
  * Add topology AKA local column column_inhibit 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.
  * Permanence Trimming
  * Over time, Columns with low # connected synapses (below stimulusThrehsold)
    will have no chance of becoming active.  Bump up the synapses to help. 
  * Orphan Columns: For an input, a column might have 100% overlap, should
    be active.. but never is. Other columns still win. Reassign for better use.
  * High Tiering - In a situation few # of inputs, columns will tend to 
    canniablize each other and we'll never get stability. For high overlap %,
    exclude columns from column_inhibit, and promote straight to active/winner.
  * Shared Inputs - 1 input bit is linked to 2 or more active columns.
    Ideal is 1:1, so increments to shared inputs is slightly less than usual.
    No longer in Nupic.
  * Add wrapAround feature (see nupic sp)
  * "Cloning"? Replicating learning across lower levels of hierarchy to spread
    the details. Complex. No longer in Nupic.
* TM Phase 2
  * separate segment_is_active() into distal/proximal versions?
  * something in BAMI TM about each cell not having full segments+synapses?

