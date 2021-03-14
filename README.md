# README

```
# Master key for credentials sent seperately in email.
# To view the credentials use: RAILS_MASTER_KEY=??? EDITOR=vim rails credentials:edit
export RAILS_MASTER_KEY=???

# Create database, migrate and seed...
rake db:create && rake db:migrate && rake db:seed
```

## Decisions

- Simple task, simple solution (KISS principle)
- No over-engineering (implement only the minimal set of requested requirements)
- Quick and productive solution by sticking with the Rails conventions, boilerplate and scaffolds (despite my personal
  preferences on other less-magical gems)
- SQLite as embedded database for purpose of this simple task (PostgreSQL would be my choice for a more serious project)
- JWT for authorization (CookieSession perhaps less usable from the REST API usage point of view, OAuth perhaps
  over-kill for this simple solution)
- Handling of CORS
- Target test coverage over 80%
- bcrypt for password hashing (security)
- Inheritance in user model (DRY as users table is generalization of the other three admin/restaurant/guest users
  specializations)
- Credentials secured with the master.key file

Not in scope of the solution:

- User management as this is not in the requirements, we use the seed file (db/seeds.rb) to instantiate a few users

## Environment

- Rails version: 6.1.3 (latest)
- Ruby version: ruby 3.0.0p0 (latest - performance boost with JIT)
- Test platform: x86_64-linux
- Database: SQLite V3 (latest)

## Running

- TODO tests
- TODO application
