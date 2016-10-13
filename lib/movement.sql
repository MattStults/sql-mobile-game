/* relies on game_state.sql */
/* relies on attributes.sql */

DROP TABLE IF EXISTS _entity_positions;
CREATE TABLE _entity_positions (
  entity_id INTEGER NOT NULL PRIMARY KEY,
  x REAL NOT NULL,
  y REAL NOT NULL,
  vx REAL NOT NULL,
  vy REAL NOT NULL,
  FOREIGN KEY (entity_id) REFERENCES _entities(entity_id) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS move_decision;
CREATE TRIGGER move_decision
  BEFORE UPDATE
  ON _gameState
  WHEN NEW.decision_point > OLD.decision_point
BEGIN
  INSERT OR REPLACE INTO _entity_positions(entity_id, x, y, vx, vy)
  SELECT entity_id, x, y, vx, vy
  FROM movement_decisions
  WHERE game_id = NEW.game_id;
END;

DROP VIEW IF EXISTS rendered_entity_positions;
CREATE VIEW rendered_entity_positions AS
SELECT
  p.entity_id AS entity_id,
  e.game_id AS game_id,
  x + vx * partial_point AS x,
  y + vy * partial_point AS y,
  vx,
  vy
FROM _entity_positions AS p
JOIN _entities AS e ON p.entity_id = e.entity_id
JOIN _gameState AS g ON e.game_id = g.game_id;

DROP VIEW IF EXISTS entity_movement_details;
CREATE VIEW entity_movement_details AS
SELECT
  e.game_id AS game_id,
  e.entity_id AS entity_id,
  CASE WHEN SUM(CASE WHEN a.attribute = 'mass' THEN a.value ELSE 0 END) >= 0.01
       THEN SUM(CASE WHEN a.attribute = 'mass' THEN a.value ELSE 0 END)
       ELSE 1.0 END AS mass,
  MAX(CASE WHEN a.attribute = 'radius' THEN a.value ELSE 0.0 END) AS radius,
  MAX(CASE WHEN a.attribute = 'drag' THEN a.value ELSE 0.0 END) AS drag
FROM _entities AS e
LEFT OUTER JOIN effective_entity_attributes AS a ON e.entity_id = a.entity_id
GROUP BY 1, 2;

DROP VIEW IF EXISTS travel_plans;
CREATE VIEW travel_plans AS
SELECT
  e.game_id AS game_id,
  p.entity_id AS entity_id,
  x,
  y,
  vx,
  vy,
  x + vx AS destination_x,
  y + vy AS destination_y,
  mass,
  radius,
  drag
FROM _entity_positions AS p
INNER JOIN entity_movement_details AS e ON p.entity_id = e.entity_id
GROUP BY 1, 2, 3, 4, 5, 6, vx, vy;

DROP VIEW IF EXISTS potential_collision_pairs;
CREATE VIEW potential_collision_pairs AS
SELECT
  l.game_id AS game_id,
  l.entity_id AS left_entity_id,
  r.entity_id AS right_entity_id,
  CASE WHEN l.destination_x = r.destination_x AND l.destination_y = r.destination_y
       THEN (l.destination_x - l.vx * 0.01) - (r.destination_x - r.vx * 0.01)
       ELSE l.destination_x - r.destination_x
       END AS dx,
  CASE WHEN l.destination_x = r.destination_x AND l.destination_y = r.destination_y
       THEN (l.destination_y - l.vy * 0.01) - (r.destination_y - r.vy * 0.01)
       ELSE l.destination_y - r.destination_y
       END AS dy,
  (l.radius + r.radius) * (l.radius + r.radius) AS min_distance_squared,
  l.mass as left_mass,
  r.mass as right_mass,
  l.vx as left_vx,
  r.vx as right_vx,
  l.vy AS left_vy,
  r.vy AS right_vy
FROM travel_plans AS l
INNER JOIN travel_plans AS r ON l.entity_id < r.entity_id AND l.game_id = r.game_id
WHERE l.radius > 0 AND r.radius > 0;

DROP VIEW IF EXISTS collision_pairs;
CREATE VIEW collision_pairs AS
SELECT
  game_id,
  left_entity_id,
  right_entity_id,
  left_mass,
  right_mass,
  left_vx,
  right_vx,
  left_vy,
  right_vy,
  dx / SQRT(dx * dx + dy * dy) AS kx,
  dy / SQRT(dx * dx + dy * dy) AS ky,
  1/left_mass + 1/right_mass AS a_denominator,
  left_vx - right_vx AS d_vx,
  left_vy - right_vy AS d_vy
FROM potential_collision_pairs
WHERE
  min_distance_squared > (dx * dx + dy * dy);

DROP VIEW IF EXISTS collision_results;
CREATE VIEW collision_results AS
SELECT 
  game_id,
  left_entity_id AS entity_id,
  left_vx - (2 * (kx * d_vx + ky * d_vy) / (a_denominator * left_mass) * kx) AS vx,
  left_vy - (2 * (kx * d_vx + ky * d_vy) / (a_denominator * left_mass) * ky) AS vy
FROM collision_pairs
UNION SELECT
  game_id,
  right_entity_id AS entity_id,
  right_vx + (2 * (kx * d_vx + ky * d_vy) / (a_denominator * right_mass) * kx) AS vx,
  right_vy + (2 * (kx * d_vx + ky * d_vy) / (a_denominator * right_mass) * ky) AS vy
FROM collision_pairs;

/* THIS IS BROKEN!  It does not handle multiple collisions on a single object correctly. */
DROP VIEW IF EXISTS movement_decisions;
CREATE VIEW movement_decisions AS
SELECT
  p.game_id AS game_id,
  p.entity_id AS entity_id,
  destination_x AS x,
  destination_y AS y,
  ROUND(SUM(CASE WHEN c.vx IS NOT NULL THEN c.vx ELSE p.vx END * (1.0 - drag)), 2) AS vx,
  ROUND(SUM(CASE WHEN c.vy IS NOT NULL THEN c.vy ELSE p.vy END * (1.0 - drag)), 2) AS vy
FROM travel_plans AS p
LEFT JOIN collision_results AS c ON p.entity_id = c.entity_id
GROUP BY 1, 2, 3, 4;
