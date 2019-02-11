# Current Work

[x] Temporal Memory
  * building.htm.systems - numenta or more open? sell related stuff? me take?
  * BAMI TP final table, pseudocode, chooseRandom() listed twice
  * More deep renaming/rearch
  * Mass input insert not working like individual inserts?
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
  * Try to prevent creating dupe synapses on segment to cell ahead of
    time instead of cleaning up mess afterwords. This would work beautifully
    if postgres and multi-dim-arrays wasn't such bullshit:

    ```sql
      -- get a list of active_last recent cells for each anchor cell to 
      --  connect to, avoiding any axon<=>segment connections that are
      --  already present.
      SELECT
        ca.id,  
        SELECT ARRAY(
          SELECT c.id
          FROM htm.cell AS c
          JOIN htm.link_distal_cell_synapse AS ldcs
            ON ldcs.cell_id = c.id
          JOIN htm.synapse AS s
            ON s.id = ldcs.synapse_id
          LEFT JOIN htm.link_distal_segment_cell AS ldsc
            ON ldsc.segment_id = s.segment_id
            AND ldsc.cell_id = ca.id
          WHERE c.active_last
          GROUP BY c.id
          HAVING COUNT(ldsc.cell_id) < 1
          ORDER BY c.id
        )
      FROM htm.cell_anchor AS ca
      WHERE ca.segment_grow
      ORDER BY ca.id
    ```

