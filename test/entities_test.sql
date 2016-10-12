.read lib/game_state.sql
.read lib/entities.sql
.read test/test_data/entities_defaults_generation.sql

/* TEST SETUP */

DROP VIEW IF EXISTS test_effective_entity_attributes_decision_0;
CREATE VIEW test_effective_entity_attributes_decision_0 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    attribute,
    value,
    GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT 'expected' AS role, 1 AS entity_id, 'move_resistance' AS attribute,  '0.4' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'mass' AS attribute,            '11.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'mass' AS attribute,            '3.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'mass' AS attribute,            '1.5' AS value UNION
    SELECT 'actual' AS role, entity_id, attribute, CAST(value AS TEXT) AS value FROM effective_entity_attributes WHERE game_id = 1)
  GROUP BY entity_id, attribute, value;

DROP VIEW IF EXISTS test_effective_entity_attributes_decision_1;
CREATE VIEW test_effective_entity_attributes_decision_1 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    attribute,
    value,
    GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT 'expected' AS role, 1 AS entity_id, 'move_resistance' AS attribute,  '0.2' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'mass' AS attribute,            '11.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'mass' AS attribute,            '3.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'mass' AS attribute,            '3.0' AS value UNION
    SELECT 'actual' AS role, entity_id, attribute, CAST(value AS TEXT) AS value FROM effective_entity_attributes WHERE game_id = 1)
  GROUP BY entity_id, attribute, value;

DROP VIEW IF EXISTS test_effective_entity_attributes_decision_2;
CREATE VIEW test_effective_entity_attributes_decision_2 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    attribute,
    value,
    GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT 'expected' AS role, 1 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'mass' AS attribute,            '11.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'mass' AS attribute,            '3.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'move_resistance' AS attribute,  '0.1' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'radius' AS attribute,           '5.0' AS value UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'mass' AS attribute,            '3.0' AS value UNION
    SELECT 'actual' AS role, entity_id, attribute, CAST(value AS TEXT) AS value FROM effective_entity_attributes WHERE game_id = 1)
  GROUP BY entity_id, attribute, value;

DROP VIEW IF EXISTS test_active_entity_classes_decision_0;
CREATE VIEW test_active_entity_classes_decision_0 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    class,
    GROUP_CONCAT(role, "|") AS roles
  FROM (
    SELECT 'expected' AS role, 1 AS entity_id, 'hero' AS class UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'playing_character' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'monster' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'ignore_collisions' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'stationary' AS class UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'monster' AS class UNION
    SELECT 'actual' AS role, entity_id, class FROM active_entity_classes WHERE game_id = 1)
  GROUP BY entity_id, class;

DROP VIEW IF EXISTS test_active_entity_classes_decision_1;
CREATE VIEW test_active_entity_classes_decision_1 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id AS entity_id,
    class AS class,
    GROUP_CONCAT(role, "|") AS roles
  FROM (
    SELECT 'expected' AS role, 1 AS entity_id, 'hero' AS class UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'playing_character' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'monster' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'ignore_collisions' AS class UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'monster' AS class UNION
    SELECT 'actual' AS role, entity_id, class FROM active_entity_classes WHERE game_id = 1)
  GROUP BY entity_id, class;

  DROP VIEW IF EXISTS test_active_entity_classes_decision_2;
CREATE VIEW test_active_entity_classes_decision_2 AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id AS entity_id,
    class AS class,
    GROUP_CONCAT(role, "|") AS roles
  FROM (
    SELECT 'expected' AS role, 1 AS entity_id, 'hero' AS class UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'playing_character' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'monster' AS class UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'ignore_collisions' AS class UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'monster' AS class UNION
    SELECT 'expected' AS role, 3 AS entity_id, 'ignore_collisions' AS class UNION
    SELECT 'actual' AS role, entity_id, class FROM active_entity_classes WHERE game_id = 1)
  GROUP BY entity_id, class;

DROP VIEW IF EXISTS test_effective_entity_attributes_simple;
CREATE VIEW test_effective_entity_attributes_simple AS
  SELECT COUNT(DISTINCT role) AS count, /* All equal */
    entity_id,
    attribute,
    value,
    GROUP_CONCAT(role, "|") AS roles
  FROM(
    SELECT 'expected' AS role, 1 AS entity_id, 'radius' AS attribute,           '1.0' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'mass' AS attribute,            '10.0' AS value UNION
    SELECT 'expected' AS role, 1 AS entity_id, 'drag' AS attribute,             '0.2' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'radius' AS attribute,           '1.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'mass' AS attribute,             '1.0' AS value UNION
    SELECT 'expected' AS role, 2 AS entity_id, 'drag' AS attribute,             '0.5' AS value UNION
    SELECT 'actual' AS role, entity_id, attribute, CAST(value AS TEXT) AS value FROM effective_entity_attributes WHERE game_id = 1)
  GROUP BY entity_id, attribute, value;
/* TESTS BEGIN HERE */

SELECT
  'entities_test; effective_entity_attributes calculation: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_effective_entity_attributes_decision_0 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      attribute || ': ' ||
      value || '; (' ||
      roles || ')', ';;')
    FROM test_effective_entity_attributes_decision_0
    WHERE count != 2) END;

SELECT
  'entities_test; active_entity_classes calculation: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_active_entity_classes_decision_0 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      class || '; (' || roles || ')', ';;')
    FROM test_active_entity_classes_decision_0
    WHERE count != 2) END;

UPDATE clock SET current_milliseconds =
    (SELECT millis_per_decision_point FROM _gameState WHERE game_id = 1)
    WHERE game_id = 1;

SELECT
  'entities_test; effective_entity_attributes calculation: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_effective_entity_attributes_decision_1 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      attribute || ': ' ||
      value || '; (' ||
      roles || ')', ';;')
    FROM test_effective_entity_attributes_decision_1
    WHERE count != 2) END;

SELECT
  'entities_test; remove_expired_classes_and_attributes removes classes: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_active_entity_classes_decision_1 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      class || '; (' || roles || ')', ';;')
    FROM test_active_entity_classes_decision_1
    WHERE count != 2) END;

UPDATE clock SET current_milliseconds =
    (SELECT millis_per_decision_point * 2 FROM _gameState WHERE game_id = 1)
    WHERE game_id = 1;

SELECT
  'entities_test; effective_entity_attributes calculation: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_effective_entity_attributes_decision_2 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      attribute || ': ' ||
      value || '; (' ||
      roles || ')', ';;')
    FROM test_effective_entity_attributes_decision_2
    WHERE count != 2) END;

SELECT
  'entities_test; remove_expired_classes_and_attributes removes overrides: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_active_entity_classes_decision_2 WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      class || '; (' || roles || ')', ';;')
    FROM test_active_entity_classes_decision_2
    WHERE count != 2) END;

.read lib/game_state.sql
.read lib/entities.sql
INSERT INTO _entityTypes (name) VALUES ('player'), ('enemy'), ('unknown');
INSERT INTO _entities (game_id, entity_type_id) VALUES
  (1, 1),
  (1, 2);
INSERT INTO _entity_type_attributes (entity_type_id, attribute, value) VALUES
  (1, 'mass', 10), (1, 'radius', 1), (1, 'drag', 0.2),
  (2, 'mass', 1),  (2, 'radius', 1), (2, 'drag', 0.5);

SELECT
  'entities_test; effective_entity_attributes simple: ' ||
  CASE WHEN
    (SELECT COUNT(*) = 0 FROM test_effective_entity_attributes_simple WHERE count != 2)
  THEN 'passed'
  ELSE 'failed;; ' ||
    (SELECT GROUP_CONCAT(
      'entity_id(' || entity_id || ')' || ': ' ||
      attribute || ': ' ||
      value || '; (' ||
      roles || ')', ';;')
    FROM test_effective_entity_attributes_simple
    WHERE count != 2) END;

/* TEST TEARDOWN */
DROP VIEW test_effective_entity_attributes_decision_0;
DROP VIEW test_effective_entity_attributes_decision_1;
DROP VIEW test_effective_entity_attributes_decision_2;
DROP VIEW test_active_entity_classes_decision_0;
DROP VIEW test_active_entity_classes_decision_1;
DROP VIEW test_active_entity_classes_decision_2;
