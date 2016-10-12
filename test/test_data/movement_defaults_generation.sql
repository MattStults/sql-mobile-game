INSERT INTO _gameState DEFAULT VALUES;
INSERT INTO _gameState DEFAULT VALUES;

INSERT INTO _entityTypes (name) VALUES ('player'), ('enemy'), ('unknown');
INSERT INTO _entities (entity_id, game_id, entity_type_id) VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 2),
  (4, 1, 2),
  (5, 1, 2),
  (6, 1, 2),
  (7, 1, 2),
  (8, 1, 2),
  (9, 1, 3),
  (10, 2, 1);
INSERT INTO _entity_type_attributes (entity_type_id, attribute, value) VALUES
  (1, 'mass', 10), (1, 'radius', 1), (1, 'drag', 0.2),
  (2, 'mass', 1),  (2, 'radius', 1), (2, 'drag', 0.5);

INSERT INTO _entity_positions
  (entity_id, x, y, vx, vy) VALUES
  (1, 0, 0, 5, 0),
  (2, 5, 0, 0, 0),
  (3, 10, 0, 0, 5),
  (4, 10, 10, 0, -5),
  (5, 20, 0, 0, 0),
  (6, 25, 0.5, -4.75, 0),
  (7, 50, 5, 0, 0),
  (8, 45, 0, 4.75, 4.5),
  (9, 0, 0, 5, 0),
  (10, 0, 0, 5, 0);