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

### Adding posts in development

`db:seed` creates a feed named somefeed ([localhost:3000/feeds/somefeed](http://localhost:3000/feeds/somefeed)) with a post named somepost ([localhost:3000/posts/somepost](http://localhost:3000/posts/somepost)).

You can also add posts yourself by hitting the Postmark inbound webhook:

```
bin/email [HOST=localhost:3000] [POST=spec/support/body.json]
```
