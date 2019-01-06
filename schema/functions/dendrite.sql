/**
 * Dendrite Functions
 */


/**
 * Calculate if dendrite is activated based on synapse connection count.
 */
CREATE FUNCTION htm.dendrite_activated(synapse_count BIGINT)
RETURNS BOOL
AS $$
DECLARE
  DendriteThreshold CONSTANT INT := htm.config('DendriteThreshold');
BEGIN
  RETURN synapse_count > DendriteThreshold;
END;
$$ LANGUAGE plpgsql;

/**
 * Auto-update htm.dendrite.state column/field (via synapse connection calcs).
 */
CREATE FUNCTION htm.dendrite_state_update()
RETURNS TRIGGER
AS $$
BEGIN
  WITH dendrite_next AS (
    SELECT
      synapse.dendrite_id,
      htm.dendrite_activated(COUNT(synapse.id)) AS new_state
    FROM htm.synapse
    WHERE synapse.state = 'connected'
      -- AND synapse.id IN (NEWTABLE.?) -- TODO: narrow changeset?
    GROUP BY synapse.dendrite_id
    HAVING htm.dendrite_activated(COUNT(synapse.id))
  )
  UPDATE htm.dendrite
    SET state = dendrite_next.new_state
    FROM dendrite_next
    WHERE dendrite.id = dendrite_next.dendrite_id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

