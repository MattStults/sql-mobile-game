.read lib/game_state.sql
.read lib/entities.sql
.read lib/movement.sql
.read test/test_data/movement_defaults_generation.sql

/* TEST SETUP */
DROP VIEW IF EXISTS test_entity_positions_decision_0;
CREATE VIEW test_entity_positions_decision_0 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    x,
    y,
    vx,
    vy,
    GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT 'expected' AS role, 1 AS entity_id, CAST(0.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(5.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 2 AS entity_id, CAST(5.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 3 AS entity_id, CAST(10.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(5.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 4 AS entity_id, CAST(10.0 AS STRING) AS x, CAST(10.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(-5.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 5 AS entity_id, CAST(20.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 6 AS entity_id, CAST(25.0 AS STRING) AS x, CAST(0.5 AS STRING) AS y, CAST(-4.75 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 7 AS entity_id, CAST(50.0 AS STRING) AS x, CAST(5.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 8 AS entity_id, CAST(45.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(4.75 AS STRING) AS vx, CAST(4.5 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 9 AS entity_id, CAST(0.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(5.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'expected' AS role, 10 AS entity_id, CAST(0.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(5.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
    SELECT 'actual' AS role, entity_id, CAST(x AS STRING), CAST(y AS STRING), CAST(vx AS STRING), CAST(vy AS STRING) FROM _entity_positions)
  GROUP BY entity_id, x, y, vx, vy;

DROP VIEW IF EXISTS test_move_decision_0;
CREATE VIEW test_move_decision_0 AS
  SELECT 'expected' AS role, 1 AS entity_id, CAST(5.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(ROUND(4.09 * 0.8, 2) AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
  SELECT 'expected' AS role, 2 AS entity_id, CAST(5.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(ROUND(9.095 * 0.5, 2) AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
  SELECT 'expected' AS role, 3 AS entity_id, CAST(10.0 AS STRING) AS x, CAST(5.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(ROUND(-5.0 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 4 AS entity_id, CAST(10.0 AS STRING) AS x, CAST(5.0 AS STRING) AS y, CAST(0.0 AS STRING) AS vx, CAST(ROUND(5.0 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 5 AS entity_id, CAST(20.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(ROUND(-0.95 * 0.5, 2) AS STRING) AS vx, CAST(ROUND(-1.9 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 6 AS entity_id, CAST(20.25 AS STRING) AS x, CAST(0.5 AS STRING) AS y, CAST(ROUND(-3.8 * 0.5, 2) AS STRING) AS vx, CAST(ROUND(1.9 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 7 AS entity_id, CAST(50.0 AS STRING) AS x, CAST(5.0 AS STRING) AS y, CAST(ROUND(2.745 * 0.5, 2) AS STRING) AS vx, CAST(ROUND(5.5 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 8 AS entity_id, CAST(49.75 AS STRING) AS x, CAST(4.5 AS STRING) AS y, CAST(ROUND(2.0 * 0.5, 2) AS STRING) AS vx, CAST(ROUND(-1.0 * 0.5, 2) AS STRING) AS vy UNION
  SELECT 'expected' AS role, 9 AS entity_id, CAST(5.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(5.0 AS STRING) AS vx, CAST(0.0 AS STRING) AS vy UNION
  SELECT 'expected' AS role, 10 AS entity_id, CAST(5.0 AS STRING) AS x, CAST(0.0 AS STRING) AS y, CAST(ROUND(5.0 * 0.8, 2) AS STRING) AS vx, CAST(0.0 AS STRING) AS vy;

DROP VIEW IF EXISTS test_movement_decisions_decision_0;
CREATE VIEW test_movement_decisions_decision_0 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id, x, y, vx, vy, GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT * FROM test_move_decision_0 UNION
    SELECT 'actual' AS role, entity_id, CAST(x AS STRING), CAST(y AS STRING), CAST(vx AS STRING), CAST(vy AS STRING) FROM movement_decisions)
  GROUP BY entity_id, x, y, vx, vy;

DROP VIEW IF EXISTS test_entity_positions_decision_1;
CREATE VIEW test_entity_positions_decision_1 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id, x, y, vx, vy, GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT * FROM test_move_decision_0 UNION
    SELECT 'actual' AS role, entity_id, CAST(x AS STRING), CAST(y AS STRING), CAST(vx AS STRING), CAST(vy AS STRING) FROM _entity_positions)
  GROUP BY entity_id, x, y, vx, vy;

/* TESTS BEGIN HERE */
SELECT
  'movement_test; intial values: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_entity_positions_decision_0 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || '), (' ||
      x || ', ' || y || '), (' || vx || ', ' || vy || ')' ||
      roles || ')', ';;')
    FROM test_entity_positions_decision_0
    WHERE count != 2) END;

SELECT
  'movement_test; intial moves: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_movement_decisions_decision_0 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || '), (' ||
      x || ', ' || y || '), (' || vx || ', ' || vy || ')' ||
      roles || ')', ';;')
    FROM test_movement_decisions_decision_0
    WHERE count != 2) END;

UPDATE _gameState SET decision_point = 1;

SELECT
  'movement_test; values after first decision: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_entity_positions_decision_1 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || '), (' ||
      x || ', ' || y || '), (' || vx || ', ' || vy || ')' ||
      roles || ')', ';;')
    FROM test_entity_positions_decision_1
    WHERE count != 2) END;

UPDATE entity_movement_interface SET add_force_x = 20, add_force_y = 40 WHERE entity_id = 1;

SELECT
  'movement_test; updating the movement interface with a force correctly translates to velocity: ' ||
  CASE WHEN
    (SELECT vx = 5.27 AND vy = 4.0 FROM travel_plans WHERE entity_id = 1)
  THEN 'passed'
  ELSE 'failed'
  END;

UPDATE _entity_positions SET a = 20.2 WHERE entity_id = 1;
UPDATE _entity_positions SET a = -10.3 WHERE entity_id = 2;
UPDATE _entity_positions SET a = 0.15 WHERE entity_id = 3;

SELECT
  'movement_test; verifying a range (0, PI): ' ||
  CASE WHEN
    (SELECT abs(a - 1.35) < 0.01 FROM _entity_positions WHERE entity_id = 1) AND
    (SELECT abs(a - 2.27) < 0.01 FROM _entity_positions WHERE entity_id = 2) AND
    (SELECT abs(a - 0.15) < 0.01 FROM _entity_positions WHERE entity_id = 3)
  THEN 'passed'
  ELSE 'failed'
  END;

/* TEST TEARDOWN */
DROP VIEW IF EXISTS test_entity_positions_decision_0;
DROP VIEW IF EXISTS test_move_decision_0;
DROP VIEW IF EXISTS test_movement_decisions_decision_0;
DROP VIEW IF EXISTS test_entity_positions_decision_1;
