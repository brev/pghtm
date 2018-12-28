# Current

* SP Phase 1
  * Do something with our new overlap query in sp compute function. 
  * Boosting needs to be added.
* General
  * Add function and trigger to auto-update "updated" timestampz columns.
  * Replace view tests: test synapse > dendrite > nueuron collapses other way.

# Future

* pg int's not unsigned.  
  * for input indexes[], you've now got a trinary if u want!
* 3 state not as enum/type, but as true/false/null ?
* SP Phase 2
  * Add topology AKA local column inhibition 
    * radius (aka? input spread. calc with.), etc.
    * Inputs directly below column should be weighted slightly higher on init
      than inputs further away from column center.

