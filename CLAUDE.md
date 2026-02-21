# CLAUDE.md

This file provides guidance for AI assistants working with the skeleton-rails-app codebase.

## Project Overview

A Ruby on Rails 7.0.4.3 **API-only** application used as a skeleton/starter template for coding tests. It runs on Ruby 3.2.2 with PostgreSQL 13.1. The application has no frontend — all interactions are via API endpoints and tested through RSpec and the Rails console.

## Tech Stack

- **Ruby**: 3.2.2 (with YJIT enabled in Docker)
- **Rails**: 7.0.4.3 (API-only mode, `config.api_only = true`)
- **Database**: PostgreSQL 13.1
- **Testing**: RSpec (primary), Minitest scaffolding also present in `test/`
- **Linting**: RuboCop with extensions (rubocop-performance, rubocop-rspec, rubocop-rails, rubocop-faker)
- **Server**: Puma
- **Containerization**: Docker + docker-compose

## Repository Structure

```
app/
  controllers/       # API controllers (inherit from ActionController::API)
    concerns/        # Controller concerns
  models/            # ActiveRecord models
    concerns/        # Model concerns
  channels/          # Action Cable channels
  jobs/              # Active Job classes
  mailers/           # Action Mailer classes
  views/layouts/     # Mailer layout templates only (API-only app)
config/
  environments/      # Per-environment config (development, test, production)
  initializers/      # App initializers (CORS, filtering, etc.)
  database.yml       # PostgreSQL connection config
  routes.rb          # Route definitions (currently empty)
  application.rb     # Main app config
db/
  seeds.rb           # Database seed data
  migrate/           # Database migrations (add here)
spec/                # RSpec test files (PRIMARY test directory)
  rails_helper.rb    # Rails-specific RSpec config
  spec_helper.rb     # Base RSpec config
test/                # Minitest scaffolding (default Rails-generated, not primary)
lib/tasks/           # Custom Rake tasks
bin/                 # Rails executables (rails, rake, etc.)
```

## Development Setup (Docker)

The project uses Docker for development. All commands run inside the Docker container:

```bash
# Create the database
docker-compose run web rake db:create

# Open Rails console
docker-compose run web rails c

# Run any command inside the container
docker-compose run web ANY_COMMAND

# Run migrations
docker-compose run web rake db:migrate

# Run RSpec tests
docker-compose run web bundle exec rspec spec
```

The `docker-compose.yml` defines two services:
- **web**: The Rails app (port 3000), built from `Dockerfile.web.development`
- **postgres**: PostgreSQL 13.1 (trust auth, no password required in dev)

Database host is `postgres` (the Docker service name), connecting on port 5432 with user `postgres` and no password.

## Running Without Docker

If running locally without Docker, adjust `config/database.yml` — change `host: postgres` to `host: localhost` and set appropriate credentials.

```bash
bundle install
rake db:create db:migrate
bundle exec rspec spec
rails s
```

## Testing

### RSpec (Primary)

- Test files go in `spec/` following Rails conventions
- Run all specs: `bundle exec rspec spec`
- Run a specific file: `bundle exec rspec spec/models/some_model_spec.rb`
- Run a specific test: `bundle exec rspec spec/models/some_model_spec.rb:42`
- Config: `.rspec` requires `spec_helper` automatically
- `spec/rails_helper.rb` loads the Rails environment and configures ActiveRecord transactional fixtures
- Spec types are inferred from file location (`spec/models/` → model spec, `spec/controllers/` → controller spec, etc.)

### Test Organization

Place specs in subdirectories matching the app structure:
- `spec/models/` — Model specs
- `spec/controllers/` — Controller/request specs
- `spec/services/` or `spec/interactors/` — Service/interactor specs
- `spec/support/` — Shared helpers and custom matchers

## Linting

RuboCop is configured with `EnabledByDefault: true` in `.rubocop.yml`, meaning all cops are enabled unless explicitly disabled.

```bash
# Run RuboCop
bundle exec rubocop

# Auto-correct offenses
bundle exec rubocop -a

# Auto-correct including unsafe corrections
bundle exec rubocop -A
```

### Key RuboCop Settings

The `.rubocop.yml` disables several cops for flexibility:
- **Metrics**: AbcSize, MethodLength, CyclomaticComplexity, PerceivedComplexity, ClassLength, BlockLength, ModuleLength, ParameterLists all disabled
- **Style**: Copyright, MethodCallWithArgsParentheses, Documentation, DocumentationMethod, MissingElse, TopLevelMethodDefinition disabled
- **Layout**: LineLength disabled
- **Naming**: MethodParameterName, PredicateName, VariableNumber disabled
- **RSpec**: EmptyExampleGroup, ExampleLength, InstanceVariable, MultipleExpectations, RepeatedDescription, Pending disabled

Extensions loaded: `rubocop-performance`, `rubocop-rspec`, `rubocop-rails`, `rubocop-faker`

## Code Conventions

### General

- All Ruby files must use `# frozen_string_literal: true` at the top
- 2-space indentation, UTF-8 encoding (see `.editorconfig`)
- Insert final newline, trim trailing whitespace
- API-only: no views, helpers, or asset pipeline for web pages

### Controllers

- Inherit from `ActionController::API` (not `ActionController::Base`)
- No session, flash, or cookie middleware by default

### Models

- Inherit from `ApplicationRecord`
- Place shared logic in `app/models/concerns/`

### Database

- Database names follow pattern: `skeleton_rails_app_{environment}`
- Use UUIDs for model IDs where non-sequential IDs are required
- PostgreSQL-specific features (extensions, data types) are encouraged

### Environment Configuration

- Three environments: `development`, `test`, `production` (plus `staging` recognized by RuboCop)
- Environment variables:
  - `RAILS_MAX_THREADS` — Connection pool size (default: 5)
  - `SKELETON_RAILS_APP_DATABASE_PASSWORD` — Production DB password
  - `DATABASE_URL` — Optional full connection URL override

## Adding New Features

1. Generate migrations: `rails generate migration CreateTableName`
2. Create models in `app/models/`
3. Create controllers in `app/controllers/`
4. Define routes in `config/routes.rb`
5. Write RSpec tests in `spec/`
6. Run `bundle exec rubocop` before committing
7. Run `bundle exec rspec spec` to verify all tests pass

## Dependencies

Key gems in `Gemfile`:
- `pg` — PostgreSQL adapter
- `puma` — Web server
- `bootsnap` — Boot time optimization
- `rspec-rails` — Testing framework (dev/test)
- `byebug` — Debugger (dev/test)
- `rubocop` + extensions — Code linting (dev)
- `listen` — File change detection (dev)
- `spring` — Application preloader (dev)

Add new gems to `Gemfile`, then run `bundle install`.
