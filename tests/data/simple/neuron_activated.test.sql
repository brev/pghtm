/**
 * Neuron (Activated) View Data Test
 */

BEGIN;
SET search_path TO htm, public;
SELECT plan(4);  -- Test count


UPDATE synapse
  SET permanence = 0.00;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM neuron_activated; $$,
  ROW(0::bigint),
  'Neuron_Activated starts empty'
);

UPDATE synapse 
  SET permanence = 1.00
  WHERE dendrite_id IN (
    SELECT dendrite_id
    FROM link_dendrite_neuron
    WHERE neuron_id = 1
    LIMIT 1
  );
SELECT row_eq(
  $$ SELECT COUNT(id) FROM neuron_activated; $$,
  ROW(1::bigint),
  'Neuron_Activated row fills with a single active dendrite'
);

UPDATE synapse 
  SET permanence = 1.00
  WHERE dendrite_id IN (
    SELECT dendrite_id
    FROM link_dendrite_neuron
    WHERE neuron_id = 1
  );
SELECT row_eq(
  $$ SELECT COUNT(id) FROM neuron_activated; $$,
  ROW(1::bigint),
  'Neuron_Activated row stays filled when active dendrites maxxed'
);

UPDATE synapse
  SET permanence = 1.00;
SELECT row_eq(
  $$ SELECT COUNT(id) FROM neuron_activated; $$,
  ROW(config_int('DataSimpleCountNeuron')::bigint),
  'Neuron_Activated all rows maxxed with active dendrites'
);


SELECT * FROM finish();
ROLLBACK;  -- Don't save test data

