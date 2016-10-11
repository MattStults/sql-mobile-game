.read lib/game_state.sql
.read test/test_data/game_state_defaults_generation.sql

/* TEST SETUP */
DROP TABLE IF EXISTS _testGameStateUpdates;
CREATE TABLE _testGameStateUpdates (
  update_id INTEGER NOT NULL PRIMARY KEY,
  game_id INTEGER NOT NULL,
  decision_point INTEGER NOT NULL DEFAULT 0,
  partial_point REAL NOT NULL DEFAULT 0,
  FOREIGN KEY (game_id) REFERENCES _gameState(game_id));

DROP TRIGGER IF EXISTS test_game_state_update_watcher;
CREATE TRIGGER test_game_state_update_watcher
  AFTER UPDATE
  ON _gameState
BEGIN
  INSERT INTO _testGameStateUpdates (game_id, decision_point, partial_point)
    VALUES (NEW.game_id, NEW.decision_point, NEW.partial_point);
END;

/* TESTS BEGIN HERE */

SELECT
  'game_state_test; verify initial state: ' ||
  CASE WHEN
    (SELECT current_milliseconds = 0
      AND next_decision_milliseconds =
        (SELECT millis_per_decision_point
          FROM _gameState
          WHERE game_id = 1)
      FROM clock
      WHERE game_id = 1)
  THEN 'passed' ELSE 'failed' END;

/* Update two decisions and 2 milliseconds */
UPDATE clock SET current_milliseconds =
    (SELECT millis_per_decision_point * 2 + 2 FROM _gameState WHERE game_id = 1)
    WHERE game_id = 1;

SELECT 
  'game_state_test; verify clock_update_decision and clock_update_partial_decision: ' ||
  CASE WHEN
    (SELECT current_milliseconds =
      (SELECT millis_per_decision_point * 2 + 2
        FROM _gameState
        WHERE game_id = 1)
    AND next_decision_milliseconds =
      (SELECT 3 * millis_per_decision_point
        FROM _gameState
        WHERE game_id = 1)
      FROM clock
      WHERE game_id = 1)
  AND (SELECT COUNT(*)
    FROM _testGameStateUpdates
    WHERE game_id = 1 AND partial_point = 0) = 2
  AND (SELECT COUNT(*)
    FROM _testGameStateUpdates
    WHERE game_id = 1 AND partial_point != 0) = 1
  THEN 'passed' ELSE 'failed' END;

INSERT INTO _gameState (game_id, decision_point, partial_point)
  WITH RECURSIVE cnt(x) AS (SELECT 0 UNION ALL SELECT x+1 FROM cnt LIMIT (SELECT millis_per_decision_point FROM _gameConfiguration WHERE game_id = 1)) SELECT x+2, 0, CAST(x AS REAL) / (SELECT millis_per_decision_point FROM _gameConfiguration WHERE game_id = 1) from cnt;

SELECT
  'game_state_test; verify that all millisecond values result in a change to current_milliseconds: ' ||
  CASE WHEN 
    (SELECT COUNT(DISTINCT current_milliseconds) FROM clock WHERE game_id != 1) =
    (SELECT millis_per_decision_point FROM _gameConfiguration WHERE game_id = 1)
  THEN 'passed' ELSE 'failed' END;

/* TEST TEARDOWN */
DROP TABLE _testGameStateUpdates;
DROP TRIGGER test_game_state_update_watcher;
