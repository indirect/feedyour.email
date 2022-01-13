# Hi!

[feedyour.email](https://feedyour.email) lets you send newsletters to your feed reader by generating an email address that aggregates messages into an Atom feed.

## Getting Started

``` sh
brew install chruby ruby-install postgresql redis
ruby-install ruby 3.1.0

# fish users: `brew install chruby-fish` instead
source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh

chruby 3.1.0
bundle install
brew services start postgresql
brew services start redis
bin/rails db:create db:migrate db:seed
```

## Development

To run a local server:

```sh
bin/dev
```

To run the tests/linters automatically on changes:

```sh
bin/test
```

To run all the tests once:

```sh
bin/rspec
```

To try to fix lint issues:

```sh
bin/rubocop --fix
```

### Pushing Posts via the Email Webhook

`db:seed` creates a feed named somefeed ([localhost:3000/feeds/somefeed](http://localhost:3000/feeds/somefeed)) with a post named somepost ([localhost:3000/posts/somepost](http://localhost:3000/posts/somepost)) but you can also add posts yourself using `curl`. An example email is checked into the respository and can be loaded by running:

``` sh
curl -vvv http://localhost:3000/email/incoming -d "@spec/support/body.json" -H "Content-Type: application/json"
```

For convenience, emails with `To:` headers that don't match a feed will be added to the newest feed when `Rails.env.development?`.
