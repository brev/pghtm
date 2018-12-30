# Current

* SP Phase 1
  * Replace view tests: test synapse > dendrite > nueuron collapses other way.
  * Visualizations
  * Duty Cycles and Boosting needs to be added.

# Future

* "IN (SELECT unnest(input_indexes))": can check array for key instead?
* pg int's not unsigned.  
  * for input indexes[], you've now got a trinary if u want!
* 3 state not as enum/type, but as true/false/null ?
* SP Phase 2
  * Add topology AKA local column inhibition 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.

