# Current Work

[x] Temporal Memory
  * Is this order backwards?
    * 1. TM punishing predicted cells not in active columns
    * 2. TM updating cell activity state via bursting/predicted
  * make sure schema tests work with any data state
  * building.htm.systems - numenta or more open? sell related stuff? me take?
  * BAMI TP final table, pseudocode, chooseRandom() listed twice
  * add created/modified to most tables w/trigger
  * Mass input insert not working like individual inserts?
  * More deep renaming/rearch
  * better distal tests, plug in small fake network parts:
    * `insert into segment (id, class) values (101, 'distal');`
    * `insert into link_distal_segment_cell (id, segment_id, cell_id) 
        values (1, 101, CELL_ID);`
    * `insert into synapse (id, segment_id, permanence) values (5001, 101, 0.5);`
  * Finish dox linkage to nupic SP/TM naming
  * Update dox charts
[x] WebUI
  * Work with @jsfowles on react components
[ ] Encoders
[ ] Anomaly Detection

# Future Work

* General:
  * More detailed test per each view, etc.
  * pg users, roles, access controls, grants, revokes, etc.
  * pg int's not unsigned - for input indexes[], got a trinary if wanted
  * use advanced pg custom types somehow?  
* Biz:
  * Hosted web ui
  * Electron skeleton
  * Desktop platforms bundle postgres?
  * Postgres mobile?
  * Postgres Hosting for backend - research which modules allowed? load custom?
* Performance: 
  * Can some vol/stable functions be moved to immutable?
    * How does this interact with my config_getter_generator?
  * Views -> Materialize and cache?
  * array/matrix/vectorize maths and data (see related pg extensions)
    * (ditch views. calc nupic style.)
  * Externalize and speed up plpgsql stuff as C Extensions.
  * Continue on to full NuPIC Integration?
* SP Phase 2
  * research/dox: BAMI SP vs old whitepaper SP?
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
  * research/dox: BAMI TM vs. old Temporal Pooling?
  * Dimensionality
  * Prune old unused synapses and segments
  * Union Pooling? 

