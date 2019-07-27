# das-migrator

*das* (dumb and simple) *migrator* is a stupidly simple bash script that does postgres migrations via psql.

## What does it do?

Given:
1. A connection string
2. A directory of migration files to run in order

It:
1. Runs them in order

That's it. That's all it does.

It does _not_:

* selectively run only new migrations
  * ...but postgres has pretty good `IF NOT EXISTS` support across the board.
* automatically roll back if errors occur partway through
  * ...see above.
* allow "down" migrations
  * ...but you can configure it to run against a different directory of migration scripts.

If you need more functionality, you probably need a better tool.

## Why? Who needs this?

This is a quick-and-dirty solution. It's _probably_ a better idea than using an entirely separate language's tool for your application, just because your language doesn't have a good migration tool yet. _Probably_.

## Installation

Clone this, copy it wherever you want to use it. Rename it, alias it, whatever.
