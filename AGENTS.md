# Agent instructions

Better is a Rails 2.3.18 app on Ruby 1.8.7 (a Redmine/Bettermeans fork). The
age of the stack is the main thing to keep in mind — modern Ruby and Rails
habits will break things.

## Run everything in Docker

The host machine has a modern Ruby; the app only runs inside the dev
container. Never run `ruby`, `rake`, `bundle`, or `spec` directly on the host.

```sh
docker compose up -d                  # start app + postgres containers
docker compose exec app bundle exec rake spec           # full test suite
docker compose exec app bundle exec spec spec/models/   # one directory
docker compose exec app bundle exec spec spec/models/board/visible_predicate_spec.rb
docker compose exec app bundle exec script/server -b 0.0.0.0  # localhost:3000
```

Setup details (database config, seeding) are in README.md. CI (CircleCI) runs
the same image (`mockdeep/better:0.5`) and runs the specs in
`spec/controllers/`, `spec/models/`, `spec/lib/`, and `spec/routing/`.

Do not rebuild the Docker image unless explicitly asked: the `Dockerfile`
bases on `ubuntu:16.04`, whose apt archives moved to old-releases.ubuntu.com,
so rebuilds fail without rework. The published image on Docker Hub is the
source of truth.

## Ruby 1.8.7 — write old-style Ruby

Code written in modern Ruby idiom will fail with syntax errors. In particular:

- Hash syntax is `:key => value`. The `key: value` shorthand does not exist.
- No `->(x) {}` stabby lambdas — use `lambda { |x| }` or `Proc.new`.
- No `require_relative`, no keyword arguments, no `&.` safe navigation, no
  `Object#then`/`yield_self`, no `Array#each_with_object`... when in doubt,
  check 1.8.7 documentation rather than assuming a method exists.
- String iteration, encoding, and `Symbol#to_proc` behavior differ from
  modern Ruby — 1.8 strings are byte arrays with no encoding.

## Rails 2.3 — old API names

- `named_scope`, not `scope`; `RAILS_ROOT`/`RAILS_ENV` constants are common.
- Routing uses `map.connect`/`map.resources` in `config/routes.rb`.
- Validations/callbacks use the 2.x forms; there is no strong parameters,
  no asset pipeline, no `app/assets` (assets live in `public/`).
- Many dependencies are vendored in `vendor/plugins/`.

## Tests — RSpec 1, not RSpec 3

- Old expectation syntax: `foo.should == bar`, `foo.should be_valid`,
  `lambda { ... }.should raise_error`. There is no `expect(...)` syntax.
- Spec files are organized one-file-per-method, e.g.
  `spec/models/board/visible_predicate_spec.rb` for `Board#visible?`.
  Follow that layout when adding specs.
- Factories are factory_girl 1.x, defined in `spec/factories/` and invoked
  with the old syntax: `Factory(:user)` / `Factory.build(:user)`.
- Methods tagged `spec_me` / `cover_me` / `heckle_me` in comments mark
  missing test coverage (see README.md "Dev notes").

## Dependencies

Bundler is 1.10.6 and RubyGems is 1.8.25 inside the container — modern
Gemfile features won't parse, and most gem versions are pinned to the last
release that supports Ruby 1.8.7. Don't bump gem versions casually; almost
any upgrade requires a Ruby upgrade first (see the roadmap in README.md).

## Local files to know about

- `config/database.yml` is gitignored; the local copy must use `host: db`
  (the compose service) and `username: postgres`.
- Dummy AWS keys and session secrets for development are set in
  `docker-compose.yml` (`BETTER_S3_*`, `BETTER_SESSION_*`). The app 500s on
  every request if the session vars are missing.
