# Hi!

[feedyour.email](https://feedyour.email) lets you send newsletters to your feed reader by generating an email address that aggregates messages into an Atom feed.

## Getting Started

``` sh
# Install Homebrew, Ruby, and gems, set up database
bin/setup
```

## Development

```sh
# Run a Rails server and Tailwind watcher
bin/dev
```

## Testing & Linting

```sh
# run tests and lints automatically on changes with guard
bin/test
```

### Fixing linter issues

```sh
# Run automatic lint fixers
bin/rubocop -A
```

### Pushing Posts via the Email Webhook

`db:seed` creates a feed named somefeed ([localhost:3000/feeds/somefeed](http://localhost:3000/feeds/somefeed)) with a post named somepost ([localhost:3000/posts/somepost](http://localhost:3000/posts/somepost)) but you can also add posts yourself using `curl`. An example email is checked into the respository and can be loaded by running:

``` sh
curl -vvv http://localhost:3000/email/incoming -d "@spec/support/body.json" -H "Content-Type: application/json"
```
