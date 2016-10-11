PRAGMA recursive_triggers = ON;
SELECT load_extension('3rd_party/libsqlitefunctions.dylib');

DROP TABLE IF EXISTS _gameState;
CREATE TABLE _gameState (
  game_id INTEGER NOT NULL PRIMARY KEY,
  decision_point INTEGER NOT NULL DEFAULT 0,
  partial_point REAL NOT NULL DEFAULT 0,
  millis_per_decision_point INTEGER NOT NULL DEFAULT 16);

DROP VIEW IF EXISTS clock;
CREATE VIEW clock AS
SELECT
    _gameState.game_id AS game_id,
    decision_point * millis_per_decision_point
        + CAST(partial_point * millis_per_decision_point AS INTEGER) AS current_milliseconds,
    (decision_point + 1) * millis_per_decision_point AS next_decision_milliseconds
FROM _gameState;

DROP TRIGGER IF EXISTS clock_update_decision;
CREATE TRIGGER clock_update_decision
  INSTEAD OF UPDATE
  ON clock
  WHEN NEW.current_milliseconds  >= OLD.next_decision_milliseconds
BEGIN
  UPDATE _gameState
    SET partial_point = 0,
       decision_point = (SELECT decision_point FROM _gameState WHERE game_id = NEW.game_id) + 1
    WHERE game_id = NEW.game_id;
  UPDATE clock
    SET current_milliseconds = NEW.current_milliseconds
    WHERE game_id = NEW.game_id;
END;

DROP TRIGGER IF EXISTS clock_update_partial_decision;
CREATE TRIGGER clock_update_partial_decision
  INSTEAD OF UPDATE
  ON clock
  WHEN NEW.current_milliseconds < OLD.next_decision_milliseconds
      AND NEW.current_milliseconds > OLD.current_milliseconds
BEGIN
  UPDATE _gameState
    SET partial_point =
        (SELECT CAST(NEW.current_milliseconds % millis_per_decision_point AS REAL)
          / millis_per_decision_point
         FROM _gameState
         WHERE game_id = NEW.game_id)
    WHERE game_id = NEW.game_id;
END;
