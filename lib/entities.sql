/* relies on game_state.sql */

DROP TABLE IF EXISTS _entityTypes;
CREATE TABLE _entityTypes (
  entity_type_id INTEGER NOT NULL PRIMARY KEY,
  name TEXT NOT NULL);

DROP TABLE IF EXISTS _entities;
CREATE TABLE _entities (
  entity_id INTEGER NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  entity_type_id INTEGER NOT NULL,
  FOREIGN KEY (game_id) REFERENCES _gameState(game_id),
  FOREIGN KEY (entity_type_id) REFERENCES _entityTypes(entity_type_id));

DROP TABLE IF EXISTS _entity_type_attributes;
CREATE TABLE _entity_type_attributes (
  entity_type_id INTEGER NOT NULL,
  attribute TEXT NOT NULL,
  value REAL NOT NULL,
  FOREIGN KEY (entity_type_id) REFERENCES _entities(entity_id));

DROP TABLE IF EXISTS _entity_type_classes;
CREATE TABLE _entity_type_classes (
  entity_type_id INTEGER NOT NULL,
  class TEXT NOT NULL,
  FOREIGN KEY (entity_type_id) REFERENCES _entityTypes(entity_id));

DROP TABLE IF EXISTS _entity_attribute_modifiers;
CREATE TABLE _entity_attribute_modifiers (
  entity_id INTEGER NOT NULL,
  attribute TEXT NOT NULL,
  multiplier REAL NOT NULL,
  expiration_decision_point INTEGER,
  FOREIGN KEY (entity_id) REFERENCES _entities(entity_id));

DROP TABLE IF EXISTS _entity_classes;
CREATE TABLE _entity_classes (
  entity_id INTEGER NOT NULL,
  class TEXT NOT NULL,
  is_suppress_class INTEGER NOT NULL DEFAULT 0,
  expiration_decision_point INTEGER,
  FOREIGN KEY (entity_id) REFERENCES _entities(entity_id));

DROP VIEW IF EXISTS effective_entity_attributes;
CREATE VIEW effective_entity_attributes AS
SELECT
  e.entity_id AS entity_id,
  e.game_id AS game_id,
  d.attribute AS attribute,
  ROUND(EXP(SUM(LOG(
    CASE WHEN m.multiplier IS NULL THEN 1
    ELSE m.multiplier END))),3) * d.value AS value
FROM _entities AS e
INNER JOIN _entity_type_attributes AS d
  ON e.entity_type_id = d.entity_type_id
LEFT JOIN _entity_attribute_modifiers AS m
  ON e.entity_id = m.entity_id AND d.attribute = m.attribute
GROUP BY 1, 2, 3, d.value;

DROP VIEW IF EXISTS _effective_entity_classes;
CREATE VIEW _effective_entity_classes AS
SELECT
  e.entity_id AS entity_id,
  game_id,
  class,
  0 AS is_suppress_class
FROM _entities AS e
INNER JOIN _entity_type_classes AS d
  ON e.entity_type_id = d.entity_type_id
UNION 
  SELECT c.entity_id AS entity_id,
         game_id,
         class,
         is_suppress_class
  FROM _entity_classes AS c
  INNER JOIN _entities AS e ON c.entity_id = e.entity_id;

DROP VIEW IF EXISTS active_entity_classes;
CREATE VIEW active_entity_classes AS
SELECT
  entity_id,
  game_id,
  class
FROM (
  SELECT entity_id,
         game_id,
         class,
         MAX(is_suppress_class) AS is_suppress_class
  FROM _effective_entity_classes
  GROUP BY 1, 2, 3)
WHERE is_suppress_class = 0;

DROP TRIGGER IF EXISTS remove_expired_classes_and_attributes;
CREATE TRIGGER remove_expired_classes_and_attributes
  AFTER UPDATE
  ON _gameState
  WHEN NEW.decision_point > OLD.decision_point
BEGIN
  DELETE FROM _entity_classes
  WHERE expiration_decision_point IS NOT NULL
  AND expiration_decision_point <= NEW.decision_point;
  DELETE FROM _entity_attribute_modifiers
  WHERE expiration_decision_point IS NOT NULL
  AND expiration_decision_point <= NEW.decision_point;
END;
