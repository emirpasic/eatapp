# README

## Running the application

```
# Master key for credentials sent seperately in email.
# To view the credentials use: RAILS_MASTER_KEY=??? EDITOR=vim rails credentials:edit
export RAILS_MASTER_KEY=???

# Create database, migrate and seed...
rake db:create && rake db:migrate && rake db:seed

# Run server
rails server
```

## Test the application

TODO write tests and document command to execute the test suite

## Decisions

- Simple task, simple solution (KISS principle)
- No over-engineering (implement only the minimal set of requested requirements)
- Quick and productive solution by sticking with the Rails conventions, boilerplate and scaffolds (despite my personal
  preferences on other less-magical gems)
- SQLite as embedded database for purpose of this simple task (PostgreSQL would be my choice for a more serious project)
- JWT for authorization (CookieSession perhaps less usable from the REST API usage point of view, OAuth perhaps
  over-kill for this simple solution)
- Handling of CORS
- Target test coverage over 80% (unfortunately target not met due to time limitations)
- bcrypt for password hashing (security)
- Inheritance in user model (DRY as users table is generalization of the other three admin/restaurant/guest users
  specializations, the support for this ActiveRecord is limited - Sequelize ORM has better support here)
- Credentials secured with the master.key file
- Versioning through namespaces (laziest and easiest solution that works, there are gems for this also, but this
  suffices)

Not in scope of the solution or not implemented in time:

- Swagger documentation not included, usually a must for REST APIs, but omitted here, i.e. gem rswag
- User management as this is not in the requirements, we use the seed file (db/seeds.rb) to instantiate a few users
- Better normalization of cuisines and opening hours for restaurants. We simply used a string column, but this should be
  normalized into other tables to allow better search functionality across restaurants based on a specific cuisine or
  availability slots.
- Much room for improvement on the input validations, e.g. validate emails and other input params (omitted due to time constraints, some model validations test only presence)

## Environment

- Rails version: 6.1.3 (latest)
- Ruby version: ruby 3.0.0p0 (latest - performance boost with JIT)
- Test platform: x86_64-linux
- Database: SQLite V3 (latest)

