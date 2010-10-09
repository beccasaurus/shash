#  shash
## Hashes for /bin/sh Shell

Although some unix shells like BASH support associative arrays, I wanted better "Hash tables" when writing shell scripts.

This provides hash-like functionality with a pleasant syntax.

It is compatible with /bin/sh and should be compatible with all of its descendants, eg. BASH and zsh

## Usage

To view this example code: [example.sh](/remi/shash/blob/master/example.sh)

    . shash.sh

    shash_define dogs

    dogs Snoopy     Beagle
    dogs Scooby-Doo "Great Dane"
    dogs Lady       "Cocker Spaniel"
    dogs Tramp      Mutt

Now that you have a few items in your Hash, there are a few ways you can access them.

    >> dogs Snoopy
    Beagle

    >> dogs_keys
    Snoopy
    Scooby-Doo
    Lady
    Tramp

    >> dogs_values
    Beagle
    Great Dane
    Cocker Spaniel
    Mutt

    >> dogs
    Snoopy: Beagle
    Scooby-Doo: Great Dane
    Lady: Cocker Spaniel
    Tramp: Mutt

    >> dogs_echo 'The dog named $key is a $value'
    The dog named Snoopy is a Beagle
    The dog named Scooby-Doo is a Great Dane
    The dog named Lady is a Cocker Spaniel
    The dog named Tramp is a Mutt

    for key in `dog_keys`; do echo "$key is a `dogs "$key"`"; done
    Snoopy is a Beagle
    Scooby-Doo is a Great Dane
    Lady is a Cocker Spaniel
    Tramp is a Mutt

## Tests

To run the test, you need:

 - ruby
 - RubyGems

Then you can:

    $ cd /path/to/shash
    $ gem install bundler
    $ bundle install
    $ bundle exec rspec --color --format documentation shash_spec.rb
