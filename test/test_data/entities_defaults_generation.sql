.read test/test_data/game_state_defaults_generation.sql

INSERT INTO _entityTypes (name) VALUES ('player'), ('enemy');
INSERT INTO _entities (game_id, entity_type_id) VALUES (1, 1), (1, 2), (1, 2), (2, 1);
INSERT INTO _entity_type_attributes (entity_type_id, attribute, value) VALUES
  (1, 'mass', 10), (1, 'radius', 5), (1, 'move_resistance', 0.1),
  (2, 'mass', 3),  (2, 'radius', 5), (2, 'move_resistance', 0.1);
INSERT INTO _entity_type_classes (entity_type_id, class) VALUES
  (1, 'hero'), (2, 'monster'), (2, 'ignore_collisions');
INSERT INTO _entity_attribute_modifiers (
	entity_id,
	attribute,
	multiplier,
	expiration_decision_point) VALUES
  (1, 'mass', 1.1, NULL),
  (1, 'move_resistance', 2, 2),
  (1, 'move_resistance', 2, 1),
  (3, 'mass', 0.5, 1);
INSERT INTO _entity_classes (
	entity_id,
	class,
	expiration_decision_point,
	is_suppress_class) VALUES
  (2, 'stationary', 1, 0),
  (3, 'ignore_collisions', 2, 1),
  (1, 'playing_character', NULL, 0);