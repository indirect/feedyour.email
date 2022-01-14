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

```sh
# run a local rails server and tailwind rebuilder
bin/dev
# run tests and lints automatically on changes with guard
bin/test
# run all the tests once
bin/rspec
# fix lint issues
bin/rubocop -a
# or with all possible fixes, even those that might break the app
bin/rubocop -A
```

### Pushing Posts via the Email Webhook

`db:seed` creates a feed named somefeed ([localhost:3000/feeds/somefeed](http://localhost:3000/feeds/somefeed)) with a post named somepost ([localhost:3000/posts/somepost](http://localhost:3000/posts/somepost)) but you can also add posts yourself using `curl`. An example email is checked into the respository and can be loaded by running:

``` sh
curl -vvv http://localhost:3000/email/incoming -d "@spec/support/body.json" -H "Content-Type: application/json"
```
