# SQL mobile game

> **Written October 2016** (11 commits, all by Matt Stults). This is old personal work, not
> recent code. It was moved from Bitbucket to GitHub in October 2026 with its full history; the
> code is unchanged since October 2016. Only this README was rewritten later; the original
> one-paragraph README is quoted below.
> It predates AI coding tools: every line of code here was written by hand.

Original README (2016):

> This is an experiment in making a cross-mobile-app app using SQL as the common language for
> business logic. In this case, the app mobile app is a game.

The idea: write the game logic once in SQLite, which runs on both iOS and Android, and keep
each platform's own code down to rendering and input.

## What's interesting in it

All the game logic is SQLite schema: tables, views and triggers.

- **`lib/game_state.sql`** is a game clock. Updating the `clock` view advances fixed-length
  turns and records how far through the current turn the game is, so the screen can draw
  positions between turns.
- **`lib/entities.sql`** handles entity types and attributes. Modifiers multiply together and
  expire after a given turn, and classes can be added or suppressed. Triggers clean up the
  expired ones.
- **`lib/movement.sql`** handles movement and physics. Applying a force (through an
  `INSTEAD OF UPDATE` trigger) changes velocity according to mass, drag slows things down, and
  two-body elastic collisions are calculated entirely in views.
- **`test/`** holds the tests, also written in SQL and larger than the logic itself. Each
  test builds expected and actual rows into a view, compares them, and prints `passed` or
  `failed` with the rows that differ.

## Status and known issues

This was a two-week experiment. As the comment in `movement.sql` says, an object hit by more
than one other object in the same turn is not handled correctly. `game_state_test.sql`
refers to a `_gameConfiguration` table that does not exist, so that test fails. The tests are
run file by file in the `sqlite3` shell from the repo root.

## Third-party code

- `3rd_party/extension-functions.c`: SQLite's public-domain extension that adds math and
  string functions (`EXP`, `LOG`, `SQRT` and so on), loaded by `game_state.sql`.
