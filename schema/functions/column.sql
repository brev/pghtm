/**
 * Column Functions
 */


/**
 * Auto-update htm.column.overlap field (via synapse.active, via input.indexes).
 *  Connected Columns linked to new On Input bits are counted per Column
    as Overlap score. 
 */
CREATE FUNCTION htm.column_overlap_update()
RETURNS TRIGGER
AS $$
DECLARE
  period CONSTANT INTEGER := htm.duty_cycle_period();
BEGIN
  WITH column_next AS (
    SELECT
      htm.column.id AS column_id,
      SUM(synapse.active::INTEGER) AS new_overlap,
      htm.running_moving_average(
        htm.column.overlapDutyCycle, 
        htm.dendrite_is_active(SUM(synapse.active::INTEGER)::INTEGER)::INTEGER,
        period
      ) AS new_overlapDutyCycle
    FROM htm.column
    JOIN htm.link_dendrite_column
      ON link_dendrite_column.column_id = htm.column.id
    JOIN htm.dendrite
      ON dendrite.id = link_dendrite_column.dendrite_id
      AND dendrite.class = 'proximal'
    JOIN htm.synapse
      ON synapse.dendrite_id = dendrite.id
    GROUP BY htm.column.id
  )
  UPDATE htm.column
    SET 
      overlap = column_next.new_overlap,
      overlapDutyCycle = column_next.new_overlapDutyCycle
    FROM column_next
    WHERE htm.column.id = column_next.column_id; 

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

