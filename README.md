# README

## Decisions

- Simple task, simple solution (KISS principle)
- No over-engineering (implement only the minimal set of requested requirements)
- Quick and productive solution by sticking with the Rails conventions, boilerplate and scaffolds (despite my personal
  preferences on other less-magical gems)
- SQLite as embedded database for purpose of this simple task (PostgreSQL would be my choice for a more serious project)
- JWT for authorization (CookieSession perhaps less usable from the REST API usage point of view, OAuth perhaps over-kill for this
  simple solution)
- Handling of CORS
- Test coverage target over 80%

## Environment

- Rails version: 6.1.3 (latest)
- Ruby version: ruby 3.0.0p0 (latest - performance boost with JIT)
- Test platform: x86_64-linux
- Database: SQLite V3 (latest)

## Running

- TODO tests
- TODO application
