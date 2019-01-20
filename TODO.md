# Current

* WebUI
* Temporal Memory
* Encoders

# Future

* Schema
  * on create: config as table/function?  configurable vs speedy
  * pg int's not unsigned - for input indexes[], got a trinary if wanted
* Admin 
  * pg users, roles, access controls, grants, revokes, etc.
* Performance: 
  * Views -> Materialize and cache?
  * ditch views? calc nupic style?
  * array/matrix/vectorize maths and data (see related pg extensions)
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

