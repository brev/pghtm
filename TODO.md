# Current

### SP Phase 1

* Synapse Data fill
  * small random range around connectedPerm
  * bias towards 90-deg vertical overhead connections between column/input
  * input spread is random, not linear.  make sure no orphans after change.
    * poolPct also
  * spatial_pooler table?
    * track computation cycle iterations
      * add dutycycle period
  * start tracking column active duty cycles
  * spatial_pooler() function that takes input and does stuff

### SP Phase 2

* Add topology AKA local column inhibition 
  * radius (aka? input spread. calc with.), etc.


# Future

* pg int's not unsigned.  
  * for input indexes[], you've now got a trinary if u want!
* 3 state not as enum/type, but as true/false/null ?

